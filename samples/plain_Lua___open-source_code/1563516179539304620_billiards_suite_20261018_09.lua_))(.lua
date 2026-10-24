local function createUI()

local uiMetadata = { name = "당구 도우미", version = "1.6.0", repository = "", url = "", footer = "" }
local uiModules = {}

uiModules["choice"] = (function()
return function(env)
	local C = env.require("core")
	local Controls = env.require("controls")
	local Overlays = env.require("overlays")
	local M = {}
	local function array(value, limit)
		assert(type(value) == "table" and #value <= limit, "Expected an array with at most " .. limit .. " entries")
		local count = 0
		for key in pairs(value) do
			assert(type(key) == "number" and key % 1 == 0 and key >= 1 and key <= #value, "Expected consecutive array entries")
			count = count + 1
		end
		assert(count == #value, "Expected consecutive array entries")
	end
	local function parseOptions(values)
		array(values, 500)
		local out, seen = {}, {}
		for index, value in ipairs(values) do
			local item = type(value) == "table" and value or { Value = value, Label = tostring(value) }
			local actual = item.Value
			local kind = type(actual)
			assert(kind == "string" or kind == "boolean" or (kind == "number" and C.finite(actual)), "Option Value must be a string, boolean, or finite number")
			local key = kind .. ":" .. tostring(actual)
			assert(not seen[key], "Duplicate option value: " .. tostring(actual))
			seen[key] = true
			local image = item.Image
			if image ~= nil then
				assert(type(image) == "string" and #image > 0 and #image <= 2048, "Option Image must be a nonempty string of at most 2048 characters")
			end
			out[index] = { Value = actual, Label = tostring(item.Label or actual), Disabled = item.Disabled == true, Image = image }
		end
		return out
	end
	local function find(options, value)
		for _, option in ipairs(options) do if option.Value == value then return option end end
	end
	local function has(list, value)
		for _, item in ipairs(list or {}) do if item == value then return true end end
		return false
	end

	local function initialFor(text)
		local first = tostring(text):match("^[%z\1-\127\194-\244][\128-\191]*")
		return first and string.upper(first) or "?"
	end
	local function avatar(owner, parent, diameter, order)
		local frame = C.node(owner, "Frame", parent, {
			Name = "Avatar", Size = UDim2.fromOffset(diameter, diameter), LayoutOrder = order,
		}, { BackgroundColor3 = "Raised" })
		C.corner(frame, diameter / 2)
		C.stroke(owner, frame, "Subtle")
		local initial = C.text(owner, frame, "?", "Small", "Secondary", {
			Name = "AvatarInitial", Size = UDim2.fromScale(1, 1), TextXAlignment = Enum.TextXAlignment.Center,
			TextWrapped = false, TextTruncate = Enum.TextTruncate.AtEnd,
		})
		local photo = C.node(owner, "ImageLabel", frame, {
			Name = "AvatarImage", BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), ScaleType = Enum.ScaleType.Crop,
		})
		C.corner(photo, diameter / 2)
		pcall(function()
			owner._scope:Connect(photo:GetPropertyChangedSignal("IsLoaded"), function()
				initial.Visible = photo.IsLoaded ~= true
			end)
		end)
		local function set(image, label)
			photo.Image = image or ""
			initial.Text = initialFor(label)
			initial.Visible = photo.IsLoaded ~= true
		end
		return frame, set
	end
	local function configure(self, options)
		self.Options = parseOptions(options.Options or {})
		self.Multi = options.Multi == true
		self._normalize = function(value)
			if self.Multi then
				array(value, 500)
				for _, selected in ipairs(value) do assert(find(self.Options, selected), "Unknown option: " .. tostring(selected)) end
				local out = {}
				for _, option in ipairs(self.Options) do if has(value, option.Value) then out[#out + 1] = option.Value end end
				return out
			end
			assert(value == nil or find(self.Options, value), "Unknown option: " .. tostring(value))
			return value
		end
		self._value = self._normalize(options.Default == nil and (self.Multi and {} or nil) or options.Default)
		self._encode = function()
			if self._value == nil then return { empty = true } end
			return { value = self:Get() }
		end
		self._decode = function(value)
			assert(type(value) == "table", "Invalid saved selection")
			assert((value.empty == true and value.value == nil) or (value.empty == nil and value.value ~= nil), "Invalid saved selection")
			if value.empty == true then return self._normalize(nil) end
			return self._normalize(value.value)
		end
		function self:SetOptions(values, silent)
			assert(self.Alive, "Control is destroyed")
			local parsed = parseOptions(values)
			local nextValue
			if self.Multi then
				nextValue = {}
				for _, option in ipairs(parsed) do if has(self._value, option.Value) then nextValue[#nextValue + 1] = option.Value end end
			elseif find(parsed, self._value) then nextValue = self._value end
			self:_CancelInteraction()
			self.Options = parsed
			self:Set(nextValue, silent)
			if self.Alive and self._rebuild then self._rebuild() end
			return self
		end
	end
	function M.Dropdown(section, options)
		local self = Controls.base(section, "Dropdown", options, "stack")
		configure(self, options)
		local button, label, refresh = Controls.action(self, "", "Field")
		button.Name = "Dropdown"
		label.TextXAlignment, label.Size = Enum.TextXAlignment.Left, UDim2.new(1, -96, 1, 0)
		label.Position = UDim2.fromOffset(12, 0)
		local hint = C.text(self, button, "Choose", "Small", "Muted", { Size = UDim2.fromOffset(72, 24), TextXAlignment = Enum.TextXAlignment.Right, TextWrapped = false })
		hint.Position, hint.AnchorPoint = UDim2.new(1, -12, 0.5, 0), Vector2.new(1, 0.5)

		local fieldAvatarSize = math.min(24, self._window.Target - 16)
		local fieldAvatar, setFieldAvatar = avatar(self, button, fieldAvatarSize, 0)
		fieldAvatar.AnchorPoint, fieldAvatar.Position = Vector2.new(0, 0.5), UDim2.new(0, 12, 0.5, 0)
		fieldAvatar.Visible = false
		local paintMenu
		self._render = function()
			local captions, image, caption = {}, nil, nil
			for _, option in ipairs(self.Options) do
				if (self.Multi and has(self._value, option.Value)) or (not self.Multi and self._value == option.Value) then
					captions[#captions + 1] = option.Label
					if not image and option.Image then image, caption = option.Image, option.Label end
				end
			end
			label.Text = #captions == 0 and (options.Placeholder or C.translate(self, "Select an option")) or (#captions > 2 and tostring(#captions) .. (self._window.Locale == "ko" and "개 선택됨" or " selected") or table.concat(captions, ", "))
			if image then
				fieldAvatar.Visible = true
				setFieldAvatar(image, caption)
				label.Position, label.Size = UDim2.fromOffset(12 + fieldAvatarSize + 10, 0), UDim2.new(1, -(12 + fieldAvatarSize + 10) - 84, 1, 0)
			else
				fieldAvatar.Visible = false
				label.Position, label.Size = UDim2.fromOffset(12, 0), UDim2.new(1, -96, 1, 0)
			end
			refresh()
			if paintMenu then paintMenu() end
		end
		function self:Open()
			if not self:_Interactive() then return nil end
			local target = self._window.Target
			local bodyHeight = #self.Options > 0 and (#self.Options * target + (#self.Options - 1) * 12) or 44
			if options.Searchable ~= false then bodyHeight = bodyHeight + target + 12 end
			local panel = Overlays.panel(self._window, {
				Title = self.Text, Anchor = button, Control = self, Width = math.max(320, button.AbsoluteSize.X),
				Height = math.min(440, math.max(54, target + 12) + 30 + 16 + bodyHeight + (self.Multi and target + 20 or 0)),
				Actions = self.Multi, OnClose = function() paintMenu = nil end,
			})
			local search = C.node(panel, "TextBox", panel.Body, {
				Name = "SearchOptions", Text = "", PlaceholderText = "Search options", Font = C.Font, TextSize = 14,
				ClearTextOnFocus = false, TextXAlignment = Enum.TextXAlignment.Left, Size = UDim2.new(1, 0, 0, self._window.Target), LayoutOrder = 0,
			}, { BackgroundColor3 = "Input", TextColor3 = "Text", PlaceholderColor3 = "Muted", TextSize = function() return math.floor(14 * self._window.TextScale + 0.5) end })
			C.corner(search); C.pad(search, 12, 0); C.fieldBorder(panel, search)
			search.Visible = options.Searchable ~= false
			local rows = {}
			for index, option in ipairs(self.Options) do
				local row = C.node(panel, "TextButton", panel.Body, { Name = "Option_" .. index, Size = UDim2.new(1, 0, 0, self._window.Target), LayoutOrder = index, Selectable = not option.Disabled })
				C.corner(row)
				local refreshRow = C.selection(panel, row, function()
					return self.Multi and has(self._value, option.Value) or (not self.Multi and self._value == option.Value)
				end, function() return not option.Disabled end)
				local labelLeft = 12
				if option.Image then
					local rowAvatar = math.min(28, self._window.Target - 12)
					local avatarFrame, setAvatar = avatar(panel, row, rowAvatar, 0)
					avatarFrame.AnchorPoint, avatarFrame.Position = Vector2.new(0, 0.5), UDim2.new(0, 8, 0.5, 0)
					setAvatar(option.Image, option.Label)
					labelLeft = 8 + rowAvatar + 10
				end
				local rowLabel = C.text(panel, row, option.Label, "Body", option.Disabled and "Muted" or "Text", {
					Name = "OptionLabel", Position = UDim2.fromOffset(labelLeft, 0), Size = UDim2.new(1, -(labelLeft + 84), 1, 0),
					TextWrapped = false, TextTruncate = Enum.TextTruncate.AtEnd,
				})
				local check = C.text(panel, row, "Selected", "Small", "Accent", { Size = UDim2.fromOffset(72, 24), TextXAlignment = Enum.TextXAlignment.Right, TextWrapped = false, TextTruncate = Enum.TextTruncate.AtEnd })
				check.Position, check.AnchorPoint = UDim2.new(1, -12, 0.5, 0), Vector2.new(1, 0.5)
				rows[#rows + 1] = { row = row, check = check, option = option, label = rowLabel, labelLeft = labelLeft, refresh = refreshRow }
				panel._scope:Connect(row.Activated, function()
					if option.Disabled or not self.Alive then return end
					if self.Multi then
						local nextValue = self:Get()
						if has(nextValue, option.Value) then
							for valueIndex, value in ipairs(nextValue) do if value == option.Value then table.remove(nextValue, valueIndex); break end end
						else nextValue[#nextValue + 1] = option.Value end
						self:Set(nextValue)
					else self:Set(option.Value); panel:Close() end
				end)
			end
			local empty = C.text(panel, panel.Body, "No matching options", "Body", "Muted", { Name = "EmptyOptions", Size = UDim2.new(1, 0, 0, 44), LayoutOrder = #rows + 1, Visible = #rows == 0 })
			local function layoutRows()
				for _, item in ipairs(rows) do
					local reserve = self._window.Touch and (item.check.Visible and math.max(72, 66 * self._window.TextScale) + 12 or 12) or 84
					item.check.Size = UDim2.fromOffset(math.max(72, 66 * self._window.TextScale), math.max(24, 16 * self._window.TextScale))
					item.label.Size = UDim2.new(1, -(item.labelLeft + reserve), 1, 0)
					item.label.TextWrapped = self._window.Touch
					local height = self._window.Target
					if self._window.Touch then
						height = math.max(height, math.min(height * 3, C.measure(item.option.Label, 14 * self._window.TextScale, panel.Width - 40 - item.labelLeft - reserve) + 16))
					end
					item.row.Size = UDim2.new(1, 0, 0, height)
				end
			end
			paintMenu = function()
				if panel.Closed then return end
				local count, query = 0, string.lower(search.Text)
				for _, item in ipairs(rows) do
					item.row.Visible = query == "" or string.lower(item.option.Label):find(query, 1, true) ~= nil
					if item.row.Visible then count = count + 1 end
					local selected = self.Multi and has(self._value, item.option.Value) or (not self.Multi and self._value == item.option.Value)
					item.check.Visible = selected
					item.refresh()
				end
				empty.Visible = count == 0
				layoutRows()
			end
			panel._scope:Connect(search:GetPropertyChangedSignal("Text"), function()
				paintMenu()
				panel.Body.CanvasPosition = Vector2.new(0, 0)
			end)
			local done
			if self.Multi then
				done = C.node(panel, "TextButton", panel.Actions, { Name = "Done", Size = UDim2.fromScale(1, 1) })
				C.corner(done); C.feedback(panel, done, "Primary")
				C.text(panel, done, "Done", "Body", "OnPrimary", { Size = UDim2.fromScale(1, 1), TextXAlignment = Enum.TextXAlignment.Center })
				panel._scope:Connect(done.Activated, function() panel:Close() end)
			end
			panel.OnLayout = function(width)
				local pinned = self._window.Touch and search.Visible and panel.Body.Size.Y.Offset >= self._window.Target * 2 + 28
				search.Parent = pinned and panel.Frame or panel.Body
				search.Size = UDim2.new(1, pinned and -40 or 0, 0, self._window.Target)
				search.Position = pinned and UDim2.fromOffset(20, panel.HeaderHeight + 8) or UDim2.fromOffset(0, 0)
				if pinned then
					local reserved = self._window.Target + 12
					panel.Body.Position = UDim2.fromOffset(0, panel.HeaderHeight + reserved)
					panel.Body.Size = UDim2.fromOffset(width, math.max(0, panel.Body.Size.Y.Offset - reserved))
				end
				if done then done.Size = UDim2.new(1, 0, 0, self._window.Target) end
				layoutRows()
			end
			self._window:_Layout()
			paintMenu()
			for _, item in ipairs(rows) do if not item.option.Disabled then panel:Focus(item.row); break end end
			return panel
		end
		self._scope:Connect(button.Activated, function() self:Open() end)
		self._render()
		return self
	end
	function M.Segmented(section, options)
		assert(not options.Multi, "Segmented is single-select")
		assert(type(options.Options) == "table" and #options.Options > 0 and #options.Options <= 8, "Segmented expects 1-8 options")
		local self = Controls.base(section, "Segmented", options, "stack")
		configure(self, options)
		if self._value == nil then
			for _, option in ipairs(self.Options) do if not option.Disabled then self._value = option.Value; break end end
		end
		local rows, childScope = {}, nil
		C.bind(self, self._slot, { BackgroundColor3 = "Input" })
		self._slot.BackgroundTransparency = 0
		C.corner(self._slot, 12)
		self._render = function()
			for _, item in ipairs(rows) do
				item.refresh()
			end
		end
		self._slotHeight = function()
			local width = math.max(1, self._window._contentWidth - self._window._contentPad * 2 - 32)
			local columns = math.max(1, math.min(#rows, math.floor(width / (100 * self._window.TextScale))))
			return math.ceil(#rows / columns) * (self._window.Target + 6) + 2
		end
		self._afterLayout = function(width)
			local columns = math.max(1, math.min(#rows, math.floor(width / (100 * self._window.TextScale))))
			local cellWidth = (width - 8 - (columns - 1) * 6) / columns
			for index, item in ipairs(rows) do
				item.button.Size = UDim2.fromOffset(cellWidth, self._window.Target)
				item.button.Position = UDim2.fromOffset(4 + ((index - 1) % columns) * (cellWidth + 6), 4 + math.floor((index - 1) / columns) * (self._window.Target + 6))
			end
		end
		self._rebuild = function()
			if childScope then childScope._scope:Destroy() end
			for _, item in ipairs(rows) do item.button:Destroy() end
			rows, self._inputs = {}, {}
			childScope = C.owner(self._window, self._scope)
			for index, option in ipairs(self.Options) do
				local button = Controls.input(self, "TextButton", self._slot, { Name = "Segment_" .. index })
				C.corner(button)
				local refreshChoice = C.selection(childScope, button, function() return option.Value == self._value end, function() return not self.Disabled and not option.Disabled end)
				C.text(childScope, button, option.Label, "Body", function(theme) return (self.Disabled or option.Disabled) and theme.Muted or theme.Text end, { Position = UDim2.fromOffset(8, 0), Size = UDim2.new(1, -16, 1, 0), TextXAlignment = Enum.TextXAlignment.Center })
				childScope._scope:Connect(button.Activated, function() if self:_Interactive() and not option.Disabled then self:Set(option.Value) end end)
				rows[#rows + 1] = { button = button, option = option, refresh = refreshChoice }
			end
			self._layout(); self._render(); self:SetDisabled(self.Disabled)
		end
		local setOptions = self.SetOptions
		function self:SetOptions(values, silent)
			assert(type(values) == "table" and #values > 0 and #values <= 8, "Segmented expects 1-8 options")
			return setOptions(self, values, silent)
		end
		self._rebuild()
		return self
	end
	function M.Keybind(section, options)
		local mode = options.Mode or "Press"
		assert(mode == "Press" or mode == "Hold" or mode == "Toggle", "Keybind Mode must be Press, Hold, or Toggle")
		local self = Controls.base(section, "Keybind", options, "inline", 136)
		self._callback = options.OnChanged
		self.Mode, self.Active = mode, false
		self._normalize = function(value)
			if value == nil or value == false or value == "None" then return nil end
			if type(value) == "string" then
				local ok, key = pcall(function() return Enum.KeyCode[value] end)
				assert(ok and key, "Unknown key: " .. value)
				value = key
			end
			assert(typeof(value) == "EnumItem" and tostring(value):find("Enum.KeyCode.", 1, true) == 1, "Keybind expects an Enum.KeyCode")
			if value == Enum.KeyCode.Unknown then return nil end
			assert(value ~= self._window.ToggleKey, "Key is reserved for showing the window; choose another key")
			return value
		end
		self._value = self._normalize(options.Default)
		self._encode = function() return self._value and self._value.Name or false end
		self._decode = self._normalize
		local button, label, refresh = Controls.action(self, "", "Field")
		button.Name = "Keybind"
		local capture, pressed
		self._render = function() label.Text = capture and C.translate(self, "Press a key…") or (self._value and self._value.Name or C.translate(self, "Not set")); refresh() end
		local function activate(active)
			self.Active = active
			C.call(self._window, options.Callback, active, self._value)
		end
		local function release()
			pressed = false
			if self.Active then activate(false) end
		end
		self._cancel = function()
			if self._window._capture == capture then self._window._capture = nil end
			if self._window._captureControl == self then self._window._captureControl = nil end
			capture = nil
			release()
			if self.Alive then self._render() end
		end
		local setter = self.Set
		function self:Set(value, silent)
			local normalized = self._normalize(value)
			self._cancel()
			return setter(self, normalized, silent)
		end
		self._restore = function(value)
			local active, previous = self.Active, self._value
			self.Active, pressed = false, false
			self._cancel()
			setter(self, value, true)
			if active then return function() C.call(self._window, options.Callback, false, previous) end end
		end
		local binding = { release = release }
		binding.began = function(input)
			if not self.Alive or self.Disabled or not self.Visible or not self._value or pressed then return end
			if not self._window.Visible and not options.ActiveWhenHidden then return end
			if input.KeyCode ~= self._value then return end
			pressed = true
			if mode == "Toggle" then activate(not self.Active)
			elseif mode == "Hold" then activate(true)
			else C.call(self._window, options.Callback, true, self._value) end
		end
		binding.ended = function(input)
			if input.KeyCode == self._value then
				pressed = false
				if mode == "Hold" and self.Active then activate(false) end
			end
		end
		self._window._keys[binding] = true
		self._scope:Add(function() self._cancel(); self._window._keys[binding] = nil end)
		self._scope:Connect(button.Activated, function()
			if not self:_Interactive() then return end
			if capture then self._cancel(); return end
			self._window:_CancelCapture()
			self._window:_ReleaseKeys()
			capture = function(input)
				local key = input.KeyCode
				if key == Enum.KeyCode.Escape or key == Enum.KeyCode.ButtonB then self._cancel(); return end
				if key == Enum.KeyCode.Unknown then return end
				local nextValue = key
				if key == Enum.KeyCode.Backspace or key == Enum.KeyCode.Delete then nextValue = nil end
				local ok, why = pcall(function() self:Set(nextValue) end)
				if not ok then self._window:Notify({ Title = "Choose another key", Content = tostring(why), Kind = "Warning" }) end
			end
			self._window._capture = capture
			self._window._captureControl = self
			self._render()
		end)
		self._render()
		return self
	end
	return M
end
end)()

uiModules["color"] = (function()
return function(env)
	local C = env.require("core")
	local Controls = env.require("controls")
	local Overlays = env.require("overlays")
	local M = {}
	local function hsv(color)
		local r, g, b = color.R, color.G, color.B
		local high, low = math.max(r, g, b), math.min(r, g, b)
		local delta, hue = high - low, 0
		if delta > 0 then
			if high == r then hue = ((g - b) / delta) % 6
			elseif high == g then hue = (b - r) / delta + 2
			else hue = (r - g) / delta + 4 end
			hue = hue / 6
		end
		return hue, high == 0 and 0 or delta / high, high
	end
	local function hex(color)
		return string.format("#%02X%02X%02X", math.floor(color.R * 255 + 0.5), math.floor(color.G * 255 + 0.5), math.floor(color.B * 255 + 0.5))
	end
	local function fromHex(value)
		value = value:gsub("^#", "")
		if #value == 3 then value = value:gsub(".", function(char) return char .. char end) end
		if #value ~= 6 or value:find("[^%x]") then return nil end
		return Color3.fromRGB(tonumber(value:sub(1, 2), 16), tonumber(value:sub(3, 4), 16), tonumber(value:sub(5, 6), 16))
	end
	function M.ColorPicker(section, options)
		local self = Controls.base(section, "ColorPicker", options, "inline", 144)
		local showAlpha = options.Alpha ~= nil or options.ShowAlpha == true
		self._normalize = function(value)
			local color, alpha
			if typeof(value) == "Color3" then color, alpha = value, self._value and self._value.Alpha or C.number(options.Alpha, 1, 0, 1)
			elseif type(value) == "table" then color, alpha = value.Color, value.Alpha end
			assert(typeof(color) == "Color3" and C.finite(color.R) and C.finite(color.G) and C.finite(color.B), "ColorPicker expects a Color3")
			assert(color.R >= 0 and color.R <= 1 and color.G >= 0 and color.G <= 1 and color.B >= 0 and color.B <= 1, "ColorPicker RGB components must be between 0 and 1")
			assert(C.finite(alpha), "Alpha must be a finite number")
			return { Color = color, Alpha = C.clamp(alpha, 0, 1) }
		end
		self._value = self._normalize(options.Default or self._window.Theme.Accent)
		function self:Get() return self._value.Color, self._value.Alpha end
		function self:GetAlpha() return self._value.Alpha end
		function self:SetAlpha(alpha, silent) return self:Set({ Color = self._value.Color, Alpha = alpha }, silent) end
		function self:_Emit()
			C.call(self._window, options.Callback, self:Get())
			if not self.Alive then return end
			for callback in pairs(self._listeners) do C.call(self._window, callback, self:Get()); if not self.Alive then break end end
		end
		self._encode = function()
			local color, alpha = self:Get()
			return { rgb = { color.R, color.G, color.B }, alpha = alpha }
		end
		self._decode = function(value)
			assert(type(value) == "table" and type(value.rgb) == "table", "Invalid saved color")
			for index = 1, 3 do assert(C.finite(value.rgb[index]) and value.rgb[index] >= 0 and value.rgb[index] <= 1, "Invalid RGB component") end
			assert(C.finite(value.alpha) and value.alpha >= 0 and value.alpha <= 1, "Invalid alpha")
			return self._normalize({ Color = Color3.new(value.rgb[1], value.rgb[2], value.rgb[3]), Alpha = value.alpha })
		end
		local button, label, refresh = Controls.action(self, "", "Field")
		button.Name = "ColorPicker"
		label.Size, label.Position, label.TextXAlignment = UDim2.new(1, -48, 1, 0), UDim2.fromOffset(40, 0), Enum.TextXAlignment.Left
		local swatch = C.node(self, "Frame", button, { Name = "Swatch", Size = UDim2.fromOffset(22, 22), Position = UDim2.new(0, 10, 0.5, 0), AnchorPoint = Vector2.new(0, 0.5) })
		C.corner(swatch, 7); C.stroke(self, swatch, "Edge")
		self._render = function()
			label.Text = hex(self._value.Color)
			swatch.BackgroundColor3, swatch.BackgroundTransparency = self._value.Color, 1 - self._value.Alpha
			refresh()
		end
		function self:Open()
			if not self:_Interactive() then return nil end
			local panel = Overlays.panel(self._window, { Title = self.Text, Control = self, Width = 380, Height = showAlpha and 640 or 580, Actions = true })
			local hue, saturation, brightness = hsv(self._value.Color)
			local draft, alpha = self._value.Color, self._value.Alpha
			local painting, invalid, pending = false, false, nil
			local fields = {}
			local sv = C.node(panel, "TextButton", panel.Body, { Name = "SaturationBrightness", Size = UDim2.new(1, 0, 0, 200), ClipsDescendants = true, LayoutOrder = 0 })
			C.corner(sv, 12)
			local saturationLayer = C.node(panel, "Frame", sv, { Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.new(1, 1, 1) })
			C.corner(saturationLayer, 12)
			C.node(panel, "UIGradient", saturationLayer, { Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1) }) })
			local valueLayer = C.node(panel, "Frame", sv, { Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.new(0, 0, 0) })
			C.corner(valueLayer, 12)
			C.node(panel, "UIGradient", valueLayer, { Rotation = 90, Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0) }) })
			local cursor = C.node(panel, "Frame", sv, { Name = "Cursor", BackgroundTransparency = 1, AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.fromOffset(12, 12) })
			C.corner(cursor, 6)
			local cursorBorder = C.node(panel, "UIStroke", cursor, { Color = Color3.new(1, 1, 1), Thickness = 2, ApplyStrokeMode = Enum.ApplyStrokeMode.Border })
			local hueHit = C.node(panel, "TextButton", panel.Body, { Name = "Hue", BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, self._window.Target), LayoutOrder = 1 })
			local hueTrack = C.node(panel, "Frame", hueHit, { Size = UDim2.new(1, -12, 0, 14), Position = UDim2.new(0, 6, 0.5, -7), BackgroundColor3 = Color3.new(1, 1, 1) })
			C.corner(hueTrack, 7)
			local stops = {}
			for index = 0, 6 do stops[#stops + 1] = ColorSequenceKeypoint.new(index / 6, Color3.fromHSV(index / 6, 1, 1)) end
			C.node(panel, "UIGradient", hueTrack, { Color = ColorSequence.new(stops) })
			local hueCursor = C.node(panel, "Frame", hueTrack, { AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.fromOffset(8, 22), BackgroundColor3 = Color3.new(1, 1, 1) })
			C.corner(hueCursor, 3); C.stroke(panel, hueCursor)
			local sample = C.node(panel, "Frame", panel.Body, { Name = "Preview", BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 58), LayoutOrder = 2 })
			C.text(panel, sample, "Current", "Caption", "Muted", { Size = UDim2.new(0.5, -4, 0, 20) })
			C.text(panel, sample, "New", "Caption", "Muted", { Position = UDim2.new(0.5, 4, 0, 0), Size = UDim2.new(0.5, -4, 0, 20) })
			local oldColor = C.node(panel, "Frame", sample, { Position = UDim2.fromOffset(0, 24), Size = UDim2.new(0.5, -4, 0, 30), BackgroundColor3 = self._value.Color, BackgroundTransparency = 1 - self._value.Alpha })
			C.corner(oldColor, 8)
			local newColor = C.node(panel, "Frame", sample, { Position = UDim2.new(0.5, 4, 0, 24), Size = UDim2.new(0.5, -4, 0, 30) })
			C.corner(newColor, 8)
			local hexField = C.node(panel, "TextBox", panel.Body, { Name = "Hex", Text = hex(draft), PlaceholderText = "#RRGGBB", ClearTextOnFocus = false, Font = Enum.Font.Code, TextSize = 14, Size = UDim2.new(1, 0, 0, self._window.Target), LayoutOrder = 3 }, { BackgroundColor3 = "Input", TextColor3 = "Text", PlaceholderColor3 = "Muted" })
			C.corner(hexField); C.fieldBorder(panel, hexField)
			C.bind(panel, hexField, { TextSize = function() return 14 * self._window.TextScale end })
			local rgb = C.node(panel, "Frame", panel.Body, { Name = "RGB", BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, self._window.Target + 22), LayoutOrder = 4 })
			for index, name in ipairs({ "R", "G", "B" }) do
				local cell = C.node(panel, "Frame", rgb, { BackgroundTransparency = 1, Position = UDim2.new((index - 1) / 3, (index - 1) * 3, 0, 0), Size = UDim2.new(1 / 3, -6, 1, 0) })
				C.text(panel, cell, name, "Caption", "Muted", { Size = UDim2.new(1, 0, 0, 18) })
				fields[index] = C.node(panel, "TextBox", cell, { Name = name, Text = "", ClearTextOnFocus = false, Font = Enum.Font.Code, TextSize = 14, Position = UDim2.fromOffset(0, 22), Size = UDim2.new(1, 0, 0, self._window.Target) }, { BackgroundColor3 = "Input", TextColor3 = "Text" })
				C.corner(fields[index]); C.fieldBorder(panel, fields[index])
				C.bind(panel, fields[index], { TextSize = function() return 14 * self._window.TextScale end })
			end
			local alphaFill, alphaLabel, alphaTrack, alphaHit
			if showAlpha then
				alphaHit = C.node(panel, "TextButton", panel.Body, { Name = "Alpha", BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, self._window.Target + 18), LayoutOrder = 5 })
				alphaLabel = C.text(panel, alphaHit, "", "Caption", "Secondary", { Size = UDim2.new(1, 0, 0, 18) })
				alphaTrack = C.node(panel, "Frame", alphaHit, { Position = UDim2.fromOffset(0, 35), Size = UDim2.new(1, 0, 0, 6) }, { BackgroundColor3 = "Track" })
				alphaFill = C.node(panel, "Frame", alphaTrack, { Size = UDim2.fromScale(alpha, 1) }, { BackgroundColor3 = "Accent" })
				C.corner(alphaTrack, 3); C.corner(alphaFill, 3)
			end
			local errorLabel = C.text(panel, panel.Body, "", "Caption", "Danger", { Name = "Validation", Size = UDim2.new(1, 0, 0, 34), Visible = false, LayoutOrder = 6 })
			local function render()
				painting, invalid, pending = true, false, nil
				draft = Color3.fromHSV(hue, saturation, brightness)
				sv.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
				cursor.Position = UDim2.fromScale(saturation, 1 - brightness)
				cursorBorder.Color = brightness > 0.7 and saturation < 0.5 and Color3.new(0.1, 0.1, 0.1) or Color3.new(1, 1, 1)
				hueCursor.Position = UDim2.fromScale(hue, 0.5)
				newColor.BackgroundColor3, newColor.BackgroundTransparency = draft, 1 - alpha
				hexField.Text = hex(draft)
				fields[1].Text, fields[2].Text, fields[3].Text = tostring(math.floor(draft.R * 255 + 0.5)), tostring(math.floor(draft.G * 255 + 0.5)), tostring(math.floor(draft.B * 255 + 0.5))
				if alphaLabel then alphaLabel.Text = (self._window.Locale == "ko" and "불투명도 · " or "Opacity · ") .. tostring(math.floor(alpha * 100 + 0.5)) .. "%"; alphaFill.Size = UDim2.fromScale(alpha, 1) end
				errorLabel.Visible = false
				painting = false
			end
			local function bad(message) invalid = true; errorLabel.Text, errorLabel.Visible = message, true end
			local function pickSV(input)
				saturation = C.clamp((input.Position.X - sv.AbsolutePosition.X) / math.max(1, sv.AbsoluteSize.X), 0, 1)
				brightness = 1 - C.clamp((input.Position.Y - sv.AbsolutePosition.Y) / math.max(1, sv.AbsoluteSize.Y), 0, 1)
				render()
			end
			C.pointer(panel, sv, pickSV, pickSV, nil, { LockScroll = true })
			local function pickHue(input)
				hue = C.clamp((input.Position.X - hueTrack.AbsolutePosition.X) / math.max(1, hueTrack.AbsoluteSize.X), 0, 1)
				render()
			end
			C.pointer(panel, hueHit, pickHue, pickHue, nil, { TouchAxis = "X" })
			if alphaHit then
				local function pickAlpha(input)
					alpha = C.clamp((input.Position.X - alphaTrack.AbsolutePosition.X) / math.max(1, alphaTrack.AbsoluteSize.X), 0, 1)
					render()
				end
				C.pointer(panel, alphaHit, pickAlpha, pickAlpha, nil, { TouchAxis = "X" })
				panel._scope:Connect(alphaHit.InputBegan, function(input)
					if input.KeyCode == Enum.KeyCode.Left or input.KeyCode == Enum.KeyCode.DPadLeft then alpha = math.max(0, alpha - 0.01)
					elseif input.KeyCode == Enum.KeyCode.Right or input.KeyCode == Enum.KeyCode.DPadRight then alpha = math.min(1, alpha + 0.01)
					else return end
					render()
				end)
			end
			panel._scope:Connect(sv.InputBegan, function(input)
				local key = input.KeyCode
				if key == Enum.KeyCode.Left or key == Enum.KeyCode.DPadLeft then saturation = math.max(0, saturation - 0.01)
				elseif key == Enum.KeyCode.Right or key == Enum.KeyCode.DPadRight then saturation = math.min(1, saturation + 0.01)
				elseif key == Enum.KeyCode.Up or key == Enum.KeyCode.DPadUp then brightness = math.min(1, brightness + 0.01)
				elseif key == Enum.KeyCode.Down or key == Enum.KeyCode.DPadDown then brightness = math.max(0, brightness - 0.01)
				else return end
				render()
			end)
			panel._scope:Connect(hueHit.InputBegan, function(input)
				if input.KeyCode == Enum.KeyCode.Left or input.KeyCode == Enum.KeyCode.DPadLeft then hue = (hue - 1 / 360) % 1
				elseif input.KeyCode == Enum.KeyCode.Right or input.KeyCode == Enum.KeyCode.DPadRight then hue = (hue + 1 / 360) % 1
				else return end
				render()
			end)
			local function commitHex()
				if painting then return end
				local color = fromHex(hexField.Text)
				if not color then bad("Use a 3- or 6-digit hex color."); return end
				hue, saturation, brightness = hsv(color); render()
			end
			local function commitRGB()
				if painting then return end
				local values = {}
				for index, item in ipairs(fields) do
					local number = tonumber(item.Text)
					if not C.finite(number) or number < 0 or number > 255 or number % 1 ~= 0 then bad("Use whole RGB values from 0 to 255."); return end
					values[index] = number
				end
				hue, saturation, brightness = hsv(Color3.fromRGB(values[1], values[2], values[3])); render()
			end
			panel._scope:Connect(hexField.FocusLost, commitHex)
			panel._scope:Connect(hexField:GetPropertyChangedSignal("Text"), function() if not painting then pending = "hex" end end)
			for _, field in ipairs(fields) do
				panel._scope:Connect(field.FocusLost, commitRGB)
				panel._scope:Connect(field:GetPropertyChangedSignal("Text"), function() if not painting then pending = "rgb" end end)
			end
			local actions = {}
			for index, spec in ipairs({ { "Cancel", nil }, { "Apply", "Primary" } }) do
				local action = C.node(panel, "TextButton", panel.Actions, { Name = spec[1], Position = UDim2.new((index - 1) / 2, (index - 1) * 4, 0, 0), Size = UDim2.new(0.5, -4, 0, self._window.Target), LayoutOrder = index })
				actions[#actions + 1] = action
				C.corner(action); C.feedback(panel, action, spec[2])
				C.text(panel, action, spec[1], "Body", spec[2] and "OnPrimary" or "Text", { Size = UDim2.fromScale(1, 1), TextXAlignment = Enum.TextXAlignment.Center })
				panel._scope:Connect(action.Activated, function()
					if index == 1 then panel:Close(); return end
					if pending == "hex" then commitHex() elseif pending == "rgb" then commitRGB() end
					if invalid then return end
					panel:Close()
					if self.Alive then self:Set({ Color = draft, Alpha = alpha }) end
				end)
			end
			panel.OnLayout = function(width)
				local target = self._window.Target
				hueHit.Size, hexField.Size = UDim2.new(1, 0, 0, target), UDim2.new(1, 0, 0, target)
				rgb.Size = UDim2.new(1, 0, 0, target + 22)
				for _, field in ipairs(fields) do field.Size = UDim2.new(1, 0, 0, target) end
				for _, action in ipairs(actions) do action.Size = UDim2.new(0.5, -4, 0, target) end
				if alphaHit then alphaHit.Size = UDim2.new(1, 0, 0, target + 18) end
				local reserved = showAlpha and (4 * self._window.Target + 174) or (3 * self._window.Target + 144)
				sv.Size = UDim2.new(1, 0, 0, math.min(210, math.max(112, math.min(width - 40, panel.Body.Size.Y.Offset - reserved))))
			end
			self._window:_Layout()
			render()
			panel:Focus(sv)
			return panel
		end
		self._scope:Connect(button.Activated, function() self:Open() end)
		self._render()
		return self
	end
	return M
end
end)()

uiModules["config"] = (function()
return function(env)
	local C = env.require("core")
	local T = env.require("theme")
	local M = {}
	function M.ExportConfig(self)
		assert(self.Alive, "Window is destroyed")
		local values = {}
		for id, control in pairs(self.Controls) do
			if control._normalize and control.Persist ~= false then
				local value
				if control._encode then value = control._encode() else value = control:Get() end
				values[id] = { kind = control.Kind, value = value }
			end
		end
		local appearance = { theme = self._themeName }
		if self._accent then appearance.accent = { self._accent.R, self._accent.G, self._accent.B } end
		return env.services.HttpService:JSONEncode({ format = "billiards-ui", version = 1, window = self.Id, values = values, appearance = appearance })
	end
	function M.ImportConfig(self, source, options)
		options = options or {}
		if not self.Alive then return false, "Window is destroyed" end
		if type(source) ~= "string" or #source > 262144 then return false, "Configuration must be JSON under 256 KiB" end
		local ok, document = pcall(function() return env.services.HttpService:JSONDecode(source) end)
		if not ok or type(document) ~= "table" or document.format ~= "billiards-ui" or document.version ~= 1 or type(document.values) ~= "table" then
			return false, "Unsupported or invalid UI configuration"
		end
		if document.window ~= self.Id then return false, "Configuration belongs to a different window Id" end
		local appearance, accent = document.appearance
		if appearance ~= nil then
			if type(appearance) ~= "table" or not T.valid(appearance.theme) then
				return false, "Invalid appearance theme"
			end
			if appearance.accent ~= nil then
				local rgb = appearance.accent
				if type(rgb) ~= "table" or #rgb ~= 3 then return false, "Invalid appearance accent" end
				for index = 1, 3 do
					if not C.finite(rgb[index]) or rgb[index] < 0 or rgb[index] > 1 then return false, "Invalid appearance accent" end
				end
				accent = Color3.new(rgb[1], rgb[2], rgb[3])
			end
		end
		local pending = {}
		for id, record in pairs(document.values) do
			local control = self.Controls[id]
			if control and control._normalize and control.Persist ~= false then
				if type(record) ~= "table" or record.kind ~= control.Kind then return false, "Control type changed: " .. tostring(id) end
				local valid, normalized = pcall(control._decode or control._normalize, record.value)
				if not valid then return false, "Invalid value for " .. tostring(id) .. ": " .. tostring(normalized) end
				pending[#pending + 1] = { control = control, value = normalized, changed = not C.equal(control._value, normalized) }
			end
		end
		table.sort(pending, function(a, b) return a.control.Id < b.control.Id end)

		if appearance then self:SetTheme(appearance.theme, accent) end
		local releases = {}
		for _, item in ipairs(pending) do
			if item.control._restore then
				local release = item.control._restore(item.value)
				if release then releases[#releases + 1] = release end
			else item.control:Set(item.value, true) end
		end

		for _, release in ipairs(releases) do release() end
		if options.Silent == false then
			for _, item in ipairs(pending) do if item.changed and item.control.Alive then item.control:_Emit() end end
		end
		return true, #pending
	end
	local function pathFor(self, name)
		assert(type(name) == "string" and #name > 0 and #name <= 48 and name:match("^[%w_-]+$"), "Profile name must be 1-48 letters, digits, underscores, or hyphens")
		local hash = 5381
		for index = 1, #self.Id do hash = (hash * 33 + self.Id:byte(index)) % 4294967296 end
		local folder = "Billiards/UI/" .. self.Id:gsub("[^%w_-]", "_"):sub(1, 32) .. "-" .. string.format("%08x", hash)
		return folder .. "/" .. name .. ".json", folder
	end
	function M.SaveConfig(self, name)
		local write = env.globals.writefile or writefile
		local make = env.globals.makefolder or makefolder
		local exists = env.globals.isfolder or isfolder
		local read = env.globals.readfile or readfile
		if type(write) ~= "function" or type(make) ~= "function" then return false, "This host does not provide writefile and makefolder; use ExportConfig" end
		local ok, result = pcall(function()
			local path, folder = pathFor(self, name)
			for _, directory in ipairs({ "Billiards", "Billiards/UI", folder }) do
				if type(exists) ~= "function" or not exists(directory) then
					local made, why = pcall(make, directory)
					if not made and type(exists) == "function" and not exists(directory) then error(why, 0) end
				end
			end
			local json = self:ExportConfig()
			write(path, json)
			if type(read) == "function" then assert(read(path) == json, "Configuration read-back did not match") end
			return path
		end)
		return ok, result
	end
	function M.LoadConfig(self, name, options)
		local read = env.globals.readfile or readfile
		if type(read) ~= "function" then return false, "This host does not provide readfile; use ImportConfig" end
		local ok, result = pcall(function()
			local path = pathFor(self, name)
			return read(path)
		end)
		if not ok then return false, tostring(result) end
		return self:ImportConfig(result, options)
	end
	return M
end
end)()

uiModules["containers"] = (function()
return function(env)
	local C = env.require("core")
	local motion = env.require("motion")
	local M, Tab, Section = {}, {}, {}
	Tab.__index, Section.__index = Tab, Section
	function M.tab(window, options)
		assert(window.Alive, "Window is destroyed")
		options = type(options) == "string" and { Title = options } or options or {}
		local title = tostring(options.Title or "Tab")
		local id = tostring(options.Id or title)
		for _, tab in ipairs(window.Tabs) do assert(tab.Id ~= id, "Duplicate tab Id: " .. id) end
		local tab = setmetatable(C.owner(window), Tab)
		tab.Id, tab.Title, tab.Alive, tab.Visible, tab.Sections = id, title, true, true, {}
		tab._scope:Add(function() tab.Alive = false end)
		tab.Frame = C.scroll(tab, window._content, "Tab_" .. id)
		tab._scope:Connect(tab.Frame.Destroying, function() tab:Destroy() end)
		tab.Frame.Visible = false
		local padding = C.pad(tab.Frame, 20, 20)
		C.reflow(tab, function()
			padding.PaddingLeft, padding.PaddingRight = UDim.new(0, window._contentPad), UDim.new(0, window._contentPad)
			padding.PaddingTop, padding.PaddingBottom = UDim.new(0, window._contentPad), UDim.new(0, window._contentPad)
		end)
		C.list(tab.Frame, false, 20)
		local intro = C.node(tab, "Frame", tab.Frame, {
			Name = "TabHeading", BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 76), LayoutOrder = 0,
		})
		tab._intro = intro
		local eyebrow = C.text(tab, intro, "WORKSPACE", "Eyebrow", "Accent", { Size = UDim2.new(1, 0, 0, 14), TextWrapped = false })
		local heading = C.text(tab, intro, title, "Display", "Text", { Position = UDim2.fromOffset(0, 20), TextYAlignment = Enum.TextYAlignment.Top })
		tab._summary = C.text(tab, intro, "", "Caption", "Muted", { TextWrapped = false, TextTruncate = Enum.TextTruncate.AtEnd })
		C.reflow(tab, function()
			local width = math.max(1, window._contentWidth - window._contentPad * 2)
			local titleTop = math.ceil(20 * window.TextScale)
			local titleHeight = C.measure(title, math.floor(C.tokens.Type.Display * window.TextScale + 0.5), width, heading.Font)
			local detailHeight = math.ceil(18 * window.TextScale)
			eyebrow.Size = UDim2.new(1, 0, 0, math.ceil(14 * window.TextScale))
			heading.Position, heading.Size = UDim2.fromOffset(0, titleTop), UDim2.new(1, 0, 0, titleHeight)
			tab._summary.Position = UDim2.fromOffset(0, titleTop + titleHeight + 6)
			tab._summary.Size = UDim2.new(1, 0, 0, detailHeight)
			intro.Size = UDim2.new(1, 0, 0, titleTop + titleHeight + detailHeight + 8)
		end)
		tab._button = C.node(tab, "TextButton", window._nav, { Name = "Tab_" .. id, LayoutOrder = #window.Tabs + 1 })
		C.corner(tab._button)
		local selected, hovered = false, false
		local function edgeOpacity() return selected and 0 or window._activeTab == tab and 0.72 or 1 end
		local function textColor(theme) return window._activeTab == tab and theme.Text or theme.Secondary end
		local function background(theme) return window._activeTab == tab and theme.Selected or hovered and theme.Hover or theme.Sidebar end
		local edge = C.stroke(tab, tab._button, "Accent")
		C.bind(tab, edge, { Transparency = edgeOpacity })
		local indicator = C.node(tab, "Frame", tab._button, { Name = "ActiveIndicator", Size = UDim2.fromOffset(3, 16), AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 0, 0.5, 0) }, {
			BackgroundColor3 = "Accent", BackgroundTransparency = function() return window._activeTab == tab and 0 or 1 end,
		})
		C.corner(indicator, 1)

		local label = C.text(tab, tab._button, title, "Body", textColor, { Position = UDim2.fromOffset(14, 0), Size = UDim2.new(1, -28, 1, 0), TextWrapped = false, TextTruncate = Enum.TextTruncate.AtEnd })
		C.bind(tab, tab._button, { BackgroundColor3 = background })
		tab._refresh = function()
			motion.to(tab, tab._button, { BackgroundColor3 = background(window.Theme) })
			motion.to(tab, label, { TextColor3 = textColor(window.Theme) })
			motion.to(tab, edge, { Transparency = edgeOpacity() })
			motion.to(tab, indicator, { BackgroundTransparency = window._activeTab == tab and 0 or 1 })
		end
		tab._scope:Connect(tab._button.MouseEnter, function() hovered = true; tab._refresh() end)
		tab._scope:Connect(tab._button.MouseLeave, function() hovered = false; tab._refresh() end)
		tab._scope:Connect(tab._button.SelectionGained, function() selected = true; tab._refresh() end)
		tab._scope:Connect(tab._button.SelectionLost, function() selected = false; tab._refresh() end)
		tab._scope:Connect(tab._button.Activated, function() window:SelectTab(tab) end)
		window.Tabs[#window.Tabs + 1] = tab
		window:_Layout()
		if not window._activeTab then window:SelectTab(tab) end
		return tab
	end
	function Tab:Select() self._window:SelectTab(self); return self end
	function Tab:SetVisible(visible)
		self.Visible, self._button.Visible = visible == true, visible == true
		self.Frame.Visible = self.Visible and self._window._activeTab == self
		if not self.Visible and self._window._activeTab == self then
			self._window._activeTab = nil
			self._window:_CloseOverlay()
			for _, tab in ipairs(self._window.Tabs) do if tab.Visible then tab:Select(); break end end
		end
		self._refresh()
		return self
	end
	function Tab:Destroy()
		if not self.Alive then return end
		self:SetVisible(false)
		self.Alive = false
		for index = #self.Sections, 1, -1 do self.Sections[index]:Destroy() end
		for index, tab in ipairs(self._window.Tabs) do if tab == self then table.remove(self._window.Tabs, index); break end end
		self._scope:Destroy()
		self.Frame:Destroy(); self._button:Destroy()
	end
	function Tab:Section(options)
		assert(self.Alive, "Tab is destroyed")
		options = type(options) == "string" and { Title = options } or options or {}
		local window = self._window
		local section = setmetatable(C.owner(window, self._scope), Section)
		section._tab, section.Title, section.Description = self, tostring(options.Title or ""), tostring(options.Description or "")
		section.Alive, section.Visible, section.Collapsed, section.Controls = true, true, options.Collapsed == true, {}
		section._scope:Add(function() section.Alive = false end)
		section.Frame = C.node(section, "Frame", self.Frame, {
			Name = "Section_" .. section.Title, BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, LayoutOrder = #self.Sections + 1,
		})
		section._scope:Connect(section.Frame.Destroying, function() section:Destroy() end)
		C.list(section.Frame, false, 10)
		section._header = C.node(section, "TextButton", section.Frame, {
			Name = "SectionHeader", BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 30), LayoutOrder = 0,
			Selectable = options.Collapsible == true,
		})
		section._heading = C.text(section, section._header, section.Title, "Heading", "Text", { Size = UDim2.new(1, -24, 0, 22) })
		section._description = C.text(section, section._header, section.Description, "Caption", "Muted", { Position = UDim2.fromOffset(0, 24), TextYAlignment = Enum.TextYAlignment.Top })
		if options.Collapsible then
			section._collapseLabel = C.text(section, section._header, section.Collapsed and "Show" or "Hide", "Caption", "Muted", {
				Position = UDim2.new(1, -64, 0, 0), Size = UDim2.fromOffset(64, window.Target), TextXAlignment = Enum.TextXAlignment.Right, TextWrapped = false })
			section._scope:Connect(section._header.Activated, function() section:SetCollapsed(not section.Collapsed) end)
		end
		section._body = C.node(section, "Frame", section.Frame, {
			Name = "Rows", Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, LayoutOrder = 1, Visible = not section.Collapsed,
		}, { BackgroundColor3 = "Surface" })
		C.corner(section._body, 12); C.stroke(section, section._body, "Subtle")
		C.list(section._body, false, 0); C.pad(section._body, 0, 4)
		C.reflow(section, function()
			local width = math.max(1, window._contentWidth - window._contentPad * 2)
			local reserve = options.Collapsible and 72 or 0
			local headingHeight = C.measure(section.Title, math.floor(15 * window.TextScale + 0.5), width - reserve, section._heading.Font)
			local descriptionHeight = section.Description ~= "" and C.measure(section.Description, 12 * window.TextScale, width - reserve) or 0
			section._header.Visible = section.Title ~= "" or section.Description ~= ""
			section._header.Size = UDim2.new(1, 0, 0, math.max(options.Collapsible and window.Target or 0, headingHeight + (descriptionHeight > 0 and descriptionHeight + 4 or 0)))
			section._heading.Size = UDim2.new(1, -reserve, 0, headingHeight)
			section._description.Position = UDim2.fromOffset(0, headingHeight + 4)
			section._description.Size = UDim2.new(1, -reserve, 0, descriptionHeight)
			if section._collapseLabel then section._collapseLabel.Size = UDim2.fromOffset(64, window.Target) end
			section._description.Visible = descriptionHeight > 0
		end)
		self.Sections[#self.Sections + 1] = section
		window:_Filter()
		return section
	end
	function Section:SetCollapsed(collapsed)
		self.Collapsed = collapsed == true
		if self._collapseLabel then self._collapseLabel.Text = C.translate(self, self.Collapsed and "Show" or "Hide") end
		self._window:_Filter()
		self._window:_Refresh()
		return self
	end
	function Section:SetVisible(visible)
		self.Visible = visible == true
		self._window:_Filter()
		return self
	end
	function Section:Destroy()
		if not self.Alive then return end
		self.Alive = false
		for index = #self.Controls, 1, -1 do self.Controls[index]:Destroy() end
		for index, section in ipairs(self._tab.Sections) do if section == self then table.remove(self._tab.Sections, index); break end end
		self._scope:Destroy()
		self.Frame:Destroy()
		if self._window.Alive then self._window:_Filter() end
	end
	for _, kind in ipairs({ "Button", "Toggle", "Checkbox", "Slider", "Input", "Dropdown", "Segmented", "Keybind", "ColorPicker", "Label", "Paragraph", "Transcript", "Divider", "Badge", "Progress" }) do
		Section[kind] = function(section, options)
			return env.require("controls").create(section, kind, options)
		end
	end
	C.elevate(Tab); C.elevate(Section)
	return M
end
end)()

uiModules["controls"] = (function()
return function(env)
	local C = env.require("core")
	local motion = env.require("motion")
	local M, Control = {}, {}
	Control.__index = Control

	function Control:Get() return C.copy(self._value) end
	function Control:Set(value, silent)
		assert(self.Alive, "Control is destroyed")
		if self._normalize then value = self._normalize(value) end
		local changed = not C.equal(value, self._value)
		self._value = C.copy(value)
		if self._render then self._render() end
		if changed and not silent then self:_Emit() end
		return self
	end
	function Control:Reset(silent) return self:Set(self._default, silent) end
	function Control:_Emit()
		C.call(self._window, self._callback, self:Get())
		if not self.Alive then return end
		for callback in pairs(self._listeners) do
			C.call(self._window, callback, self:Get())
			if not self.Alive then break end
		end
	end
	function Control:OnChanged(callback)
		assert(self.Alive, "Control is destroyed")
		assert(type(callback) == "function", "OnChanged expects a function")
		self._listeners[callback] = true
		return function() self._listeners[callback] = nil end
	end
	function Control:_Interactive()
		return self.Alive and self._window.Alive and self._window.Visible and self.Visible and not self.Disabled
			and self._section.Visible and self.Frame.Visible and self._section._body.Visible and self._section._tab.Frame.Visible
	end
	function Control:_CancelInteraction()
		local window = self._window
		C.cancelGesture(window, self)
		C.releaseFocus(window, self.Frame)
		if self._cancel then self._cancel() end
		if window._overlay and window._overlay.Control == self then window:_CloseOverlay() end
	end
	function Control:SetDisabled(disabled)
		self.Disabled = disabled == true
		if self.Disabled then self:_CancelInteraction() end
		for _, input in ipairs(self._inputs) do
			input.Active, input.Selectable = not self.Disabled, not self.Disabled
			if input:IsA("TextBox") then input.TextEditable = not self.Disabled end
		end
		if self._render then self._render() end
		self._window:_Refresh()
		return self
	end
	function Control:SetVisible(visible)
		self.Visible = visible == true
		if not self.Visible then self:_CancelInteraction() end
		self._window:_Filter()
		return self
	end
	function Control:SetText(text)
		self.Text = tostring(text)
		self._label.Text = self.Text
		self._layout()
		self._window:_Filter()
		return self
	end
	function Control:SetDescription(text)
		self.Description = tostring(text)
		self._description.Text = self.Description
		self._layout()
		self._window:_Filter()
		return self
	end
	function Control:Destroy()
		if not self.Alive then return end
		self:_CancelInteraction()
		self.Alive = false
		if self.Id then self._window.Controls[self.Id] = nil end
		for index, control in ipairs(self._section.Controls) do if control == self then table.remove(self._section.Controls, index); break end end
		self._scope:Destroy()
		self._listeners = {}
		self.Frame:Destroy()
		if self._window.Alive then self._window:_Filter() end
	end
	function M.base(section, kind, options, mode, slotWidth)
		assert(section.Alive and section._window.Alive, "Section is destroyed")
		options = options or {}
		local window = section._window
		if options.Id then
			assert(type(options.Id) == "string" and #options.Id > 0, "Control Id must be a nonempty string")
			assert(not window.Controls[options.Id], "Duplicate control Id: " .. options.Id)
		end
		assert(options.Callback == nil or type(options.Callback) == "function", "Callback must be a function")
		local self = setmetatable(C.owner(window, section._scope), Control)
		self.Kind, self.Id, self.Text, self.Description = kind, options.Id, tostring(options.Text or kind), tostring(options.Description or "")
		self.Alive, self.Visible, self.Disabled = true, options.Visible ~= false, options.Disabled == true
		self.Persist = options.Persist ~= false
		self._section, self._callback, self._listeners, self._inputs = section, options.Callback, {}, {}
		self._scope:Add(function() self.Alive = false; self._listeners = {} end)
		self._mode, self._slotWidth = mode or "inline", slotWidth or 120
		self.Frame = C.node(self, "Frame", section._body, {
			Name = options.Id and ("Control_" .. options.Id) or kind, BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 64), LayoutOrder = #section.Controls + 1, Visible = self.Visible,
		})
		self._scope:Connect(self.Frame.Destroying, function() self:Destroy() end)
		if #section.Controls > 0 then
			C.node(self, "Frame", self.Frame, { Name = "RowRule", BackgroundTransparency = 0.35, Position = UDim2.fromOffset(16, 0), Size = UDim2.new(1, -32, 0, 1) }, { BackgroundColor3 = "Subtle" })
		end
		self._label = C.text(self, self.Frame, self.Text, "Body", "Text", { Name = "Label", TextYAlignment = Enum.TextYAlignment.Top })
		C.bind(self, self._label, { TextColor3 = function(theme) return self.Disabled and theme.Muted or theme.Text end })
		self._description = C.text(self, self.Frame, self.Description, "Caption", "Muted", { Name = "Description", TextYAlignment = Enum.TextYAlignment.Top })
		self._slot = C.node(self, "Frame", self.Frame, { Name = "Value", BackgroundTransparency = 1 })
		self._layout = function()
			if not self.Alive then return end
			local width = math.max(1, window._contentWidth - window._contentPad * 2 - 32)
			local stacked = self._mode == "stack" or (self._mode == "inline" and self._slotWidth > 64 and width < 280 * window.TextScale)
			self._stacked = stacked
			local content = self._mode == "content"
			local slot = math.min(self._slotWidth, width * 0.48)
			local labelWidth = (stacked or content) and width or math.max(1, width - slot - 16)
			if self._labelReserve then labelWidth = math.max(1, labelWidth - self._labelReserve) end
			local titleHeight = self.Text ~= "" and C.measure(self.Text, 14 * window.TextScale, labelWidth) or 0
			local descriptionHeight = self.Description ~= "" and C.measure(self.Description, 12 * window.TextScale, labelWidth) or 0
			local captionHeight = titleHeight + (descriptionHeight > 0 and descriptionHeight + 5 or 0)
			local slotHeight = self._slotHeight and self._slotHeight() or window.Target
			local height = 28 + ((stacked and captionHeight + 10 + slotHeight) or (content and captionHeight) or math.max(captionHeight, slotHeight))
			self.Frame.Size = UDim2.new(1, 0, 0, math.ceil(height))
			local textTop = 14 + math.max(0, (slotHeight - captionHeight) / 2)
			if stacked or content then textTop = 14 end
			self._label.Position = UDim2.fromOffset(16, textTop)
			self._label.Size = UDim2.fromOffset(labelWidth, titleHeight)
			self._description.Position = UDim2.fromOffset(16, textTop + titleHeight + 5)
			self._description.Size = UDim2.fromOffset(labelWidth, descriptionHeight)
			self._description.Visible = descriptionHeight > 0
			self._slot.Visible = not content
			self._slot.Position = stacked and UDim2.fromOffset(16, 14 + captionHeight + 10) or UDim2.new(1, -16 - slot, 0, 14 + math.max(0, (captionHeight - slotHeight) / 2))
			self._slot.Size = UDim2.fromOffset(stacked and width or slot, slotHeight)
			if self._afterLayout then self._afterLayout(width, slotHeight) end
		end
		C.reflow(self, self._layout)
		section.Controls[#section.Controls + 1] = self
		if self.Id then window.Controls[self.Id] = self end
		return self
	end
	function M.input(control, class, parent, properties)
		local node = C.node(control, class, parent or control._slot, properties)
		control._inputs[#control._inputs + 1] = node
		return node
	end
	function M.action(control, text, style)
		local button = M.input(control, "TextButton", control._slot, { Name = "Action", Size = UDim2.fromScale(1, 1) })
		C.corner(button)
		local feedback = C.feedback(control, button, style, function() return not control.Disabled and not control.Loading end)
		local label = C.text(control, button, text, "Body", "Text", { Size = UDim2.new(1, -16, 1, 0), Position = UDim2.fromOffset(8, 0), TextXAlignment = Enum.TextXAlignment.Center, TextWrapped = false, TextTruncate = Enum.TextTruncate.AtEnd })
		local function color(theme)
			if control.Disabled or control.Loading then return theme.Muted end
			return (style == "Primary" or style == "Danger") and theme.OnPrimary or theme.Text
		end
		C.bind(control, label, { TextColor3 = color })
		local function refresh() feedback(); motion.to(control, label, { TextColor3 = color(control._window.Theme) }) end
		return button, label, refresh
	end
	function M.Button(section, options)
		local self = M.base(section, "Button", options, "inline", 116)
		self.Loading = false
		local button, label, refresh = M.action(self, options.ActionText or C.translate(self, "Run"), options.Style)
		self._render = function()
			label.Text = self.Loading and (options.LoadingText or C.translate(self, "Working…")) or options.ActionText or C.translate(self, "Run")
			refresh()
		end
		function self:SetLoading(loading) self.Loading = loading == true; self._render(); return self end
		function self:Press()
			if not self:_Interactive() or self.Loading then return false end
			self:SetLoading(true)
			self._scope:Spawn(function()
				C.call(self._window, options.Callback)
				if self.Alive then self:SetLoading(false) end
			end)
			return true
		end
		self._scope:Connect(button.Activated, function() self:Press() end)
		return self
	end
	local function booleanControl(section, options, checkbox)
		local self = M.base(section, checkbox and "Checkbox" or "Toggle", options, "inline", 48)
		self._normalize = function(value) assert(type(value) == "boolean", "Expected a boolean"); return value end
		local default = options.Default
		if default == nil then default = false end
		self._value = self._normalize(default)
		local hit = M.input(self, "TextButton", self._slot, { Name = "Toggle", BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1) })
		local track = C.node(self, "Frame", hit, {
			Name = "Track", AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromOffset(checkbox and 44 or 46, 26),
		})
		C.corner(track, checkbox and 8 or 13)
		local edge = C.stroke(self, track, "Edge")
		C.bind(self, edge, { Color = function(theme) return self._value and not self.Disabled and theme.Accent or theme.Edge end })
		C.bind(self, track, { BackgroundColor3 = function(theme) return self._value and not self.Disabled and theme.Accent or theme.Input end })
		local thumb
		if checkbox then
			thumb = C.text(self, track, "Off", "Small", "Secondary", { Size = UDim2.fromScale(1, 1), TextXAlignment = Enum.TextXAlignment.Center, TextWrapped = false })
			C.bind(self, thumb, { TextColor3 = function(theme) return self._value and not self.Disabled and theme.OnAccent or theme.Secondary end })
		else
			thumb = C.node(self, "Frame", track, { Name = "Thumb", AnchorPoint = Vector2.new(0, 0.5), Size = UDim2.fromOffset(18, 18) }, {
				BackgroundColor3 = function(theme) return self._value and not self.Disabled and theme.OnAccent or theme.Secondary end,
			})
			C.corner(thumb, 9)
		end
		local initialized = false
		self._render = function()
			local duration = initialized and C.tokens.Motion.Toggle or 0
			if checkbox then
				thumb.Text = C.translate(self, self._value and "On" or "Off")
				motion.to(self, thumb, { TextColor3 = self._value and not self.Disabled and self._window.Theme.OnAccent or self._window.Theme.Secondary }, duration)
			else
				motion.to(self, thumb, { Position = UDim2.new(0, self._value and 24 or 4, 0.5, 0),
					BackgroundColor3 = self._value and not self.Disabled and self._window.Theme.OnAccent or self._window.Theme.Secondary }, duration)
			end
			motion.to(self, track, { BackgroundColor3 = self._value and not self.Disabled and self._window.Theme.Accent or self._window.Theme.Input }, duration)
			motion.to(self, edge, { Color = self._value and not self.Disabled and self._window.Theme.Accent or self._window.Theme.Edge }, duration)
			initialized = true
		end
		local focus = C.stroke(self, hit, "Accent")
		focus.Transparency = 1
		self._scope:Connect(hit.SelectionGained, function() focus.Transparency = 0 end)
		self._scope:Connect(hit.SelectionLost, function() focus.Transparency = 1 end)
		self._scope:Connect(hit.Activated, function() if self:_Interactive() then self:Set(not self._value) end end)
		self._render()
		return self
	end
	function M.Toggle(section, options) return booleanControl(section, options, false) end
	function M.Checkbox(section, options) return booleanControl(section, options, true) end
	function M.Slider(section, options)
		local minimum, maximum = options.Min or 0, options.Max or 100
		local step = options.Step or 1
		assert(C.finite(minimum) and C.finite(maximum) and maximum > minimum, "Slider Max must exceed Min")
		assert(C.finite(step) and step > 0, "Slider Step must be positive")
		local self = M.base(section, "Slider", options, "stack")
		self._labelReserve, self.Min, self.Max, self.Step = 96, minimum, maximum, step
		self._normalize = function(value)
			assert(C.finite(value), "Slider value must be a finite number")
			value = C.clamp(value, minimum, maximum)
			if value == maximum then return maximum end
			local result = C.clamp(minimum + math.floor((value - minimum) / step + 0.5) * step, minimum, maximum)
			return tonumber(string.format("%.10g", result))
		end
		self._value = self._normalize(options.Default == nil and minimum or options.Default)
		local value = C.text(self, self.Frame, "", "Caption", "Text", { Name = "Readout", BackgroundTransparency = 0, TextXAlignment = Enum.TextXAlignment.Center, TextWrapped = false, TextTruncate = Enum.TextTruncate.AtEnd })
		C.bind(self, value, { BackgroundColor3 = "Input" }); C.corner(value, 6); C.pad(value, 6, 0)
		self._afterLayout = function(width)
			value.Position = UDim2.new(1, -112, 0, 14)
			value.Size = UDim2.fromOffset(96, 20 * self._window.TextScale)
		end
		local hit = M.input(self, "TextButton", self._slot, { Name = "Slider", BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1) })
		local track = C.node(self, "Frame", hit, { Name = "Track", Position = UDim2.new(0, 10, 0.5, -3), Size = UDim2.new(1, -20, 0, 6) }, { BackgroundColor3 = "Track" })
		C.corner(track, 3)
		local fill = C.node(self, "Frame", track, { Name = "Fill", Size = UDim2.fromScale(0, 1) }, { BackgroundColor3 = function(theme) return self.Disabled and theme.Muted or theme.Accent end })
		C.corner(fill, 3)
		local knob = C.node(self, "Frame", track, { Name = "Thumb", AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.fromOffset(18, 18), Position = UDim2.fromScale(0, 0.5) }, { BackgroundColor3 = "Primary" })
		C.corner(knob, 9); C.stroke(self, knob, "Edge")
		local centre = C.node(self, "Frame", knob, { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(4, 4) }, { BackgroundColor3 = "OnPrimary" })
		C.corner(centre, 2)
		local focus = C.stroke(self, hit, "Accent"); focus.Transparency = 1; C.corner(hit)
		self._scope:Connect(hit.SelectionGained, function() focus.Transparency = 0 end)
		self._scope:Connect(hit.SelectionLost, function() focus.Transparency = 1 end)
		self._render = function()
			local share = (self._value - minimum) / (maximum - minimum)
			fill.Size, knob.Position = UDim2.fromScale(share, 1), UDim2.fromScale(share, 0.5)
			value.Text = string.format("%.10g", self._value) .. tostring(options.Suffix or "")
			fill.BackgroundColor3 = self.Disabled and self._window.Theme.Muted or self._window.Theme.Accent
		end
		local function update(input)
			if not self:_Interactive() then return end
			local share = C.clamp((input.Position.X - track.AbsolutePosition.X) / math.max(1, track.AbsoluteSize.X), 0, 1)
			self:Set(minimum + share * (maximum - minimum))
		end
		C.pointer(self, hit, function(input)
			if not self:_Interactive() then return false end
			update(input)
			return self:_Interactive()
		end, update, function()
			if self:_Interactive() then C.call(self._window, options.OnCommit, self:Get()) end
		end, { TouchAxis = "X", CanStart = function() return self:_Interactive() end })
		self._scope:Connect(hit.InputBegan, function(input)
			if not self:_Interactive() or env.services.UserInputService:GetFocusedTextBox() then return end
			local key, nextValue = input.KeyCode, nil
			if key == Enum.KeyCode.Left or key == Enum.KeyCode.Down or key == Enum.KeyCode.DPadLeft then nextValue = self._value - step end
			if key == Enum.KeyCode.Right or key == Enum.KeyCode.Up or key == Enum.KeyCode.DPadRight then nextValue = self._value + step end
			if key == Enum.KeyCode.Home then nextValue = minimum end
			if key == Enum.KeyCode.End then nextValue = maximum end
			if nextValue ~= nil then self:Set(nextValue); if self.Alive then C.call(self._window, options.OnCommit, self:Get()) end end
		end)
		self._render(); self._layout()
		return self
	end
	function M.Input(section, options)
		if options.Numeric then
			assert(options.Min == nil or C.finite(options.Min), "Input Min must be finite")
			assert(options.Max == nil or C.finite(options.Max), "Input Max must be finite")
			assert(options.Min == nil or options.Max == nil or options.Min <= options.Max, "Input Max must not be below Min")
		end
		local self = M.base(section, "Input", options, "stack")
		local maxLength = math.floor(C.number(options.MaxLength, 4096, 1, 65536))
		self._normalize = function(value)
			if options.Numeric then
				assert(C.finite(value), "Enter a valid number")
				return C.clamp(value, options.Min or -math.huge, options.Max or math.huge)
			end
			assert(type(value) == "string", "Input value must be a string")
			return C.truncate(value, maxLength)
		end
		self._value = self._normalize(options.Default == nil and (options.Numeric and 0 or "") or options.Default)
		local field = M.input(self, "TextBox", self._slot, {
			Name = "Input", Text = tostring(self._value), PlaceholderText = tostring(options.Placeholder or ""),
			Size = UDim2.fromScale(1, 1), ClearTextOnFocus = false, Font = C.Font, TextSize = 14,
			TextXAlignment = Enum.TextXAlignment.Left, MultiLine = options.MultiLine == true,
			TextWrapped = options.MultiLine == true, TextYAlignment = options.MultiLine and Enum.TextYAlignment.Top or Enum.TextYAlignment.Center,
		})
		C.bind(self, field, { BackgroundColor3 = "Input", TextColor3 = "Text", PlaceholderColor3 = "Muted", TextSize = function() return math.floor(14 * self._window.TextScale + 0.5) end })
		C.corner(field); C.pad(field, 12, options.MultiLine and 10 or 0)
		local border, refreshBorder = C.fieldBorder(self, field, function() return self._error ~= nil end)
		local errorLabel = C.text(self, self._slot, "", "Caption", "Danger", { Name = "Validation", Visible = false })
		local painting = false
		self._error = nil
		self._slotHeight = function() return self._window.Target * (options.MultiLine and C.number(options.Lines, 3, 2, 8) or 1) + (self._error and 24 or 0) end
		self._afterLayout = function(_, height)
			field.Size = UDim2.new(1, 0, 0, height - (self._error and 24 or 0))
			errorLabel.Position = UDim2.new(0, 0, 1, -22); errorLabel.Size = UDim2.new(1, 0, 0, 22)
		end
		self._render = function(preserveDraft)
			if not preserveDraft then painting = true; field.Text = tostring(self._value); painting = false end
			self._error, errorLabel.Visible = nil, false
			refreshBorder()
			self._layout()
		end
		local function commit(live)
			if painting or not self:_Interactive() then return end
			local raw = options.Numeric and tonumber(field.Text) or field.Text
			local ok, value = pcall(self._normalize, raw)
			if not ok then
				self._error = options.Numeric and C.translate(self, "Enter a valid number.") or tostring(value)
				errorLabel.Text, errorLabel.Visible, border.Color = self._error, true, self._window.Theme.Danger
				refreshBorder()
				self._layout()
				return
			end
			if live then

				local changed = not C.equal(value, self._value)
				self._value = value
				self._render(true)
				if changed then self:_Emit() end
			else self:Set(value) end
			if self.Alive then C.call(self._window, options.OnCommit, self:Get()) end
		end
		self._scope:Connect(field.FocusLost, function()
			commit()
			refreshBorder()
		end)
		self._scope:Connect(field:GetPropertyChangedSignal("Text"), function()
			if painting then return end
			local text = C.truncate(field.Text, maxLength)
			if text ~= field.Text then painting = true; field.Text = text; painting = false end
			if options.Live then commit(true) end
		end)
		function self:Focus() if self:_Interactive() then field:CaptureFocus() end; return self end
		self._layout()
		return self
	end
	function M.Label(section, options)
		return M.base(section, "Label", options, "content")
	end
	function M.Paragraph(section, options)
		local copy = C.copy(options)
		copy.Description = options.Content or options.Description or ""
		return M.base(section, "Paragraph", copy, "content")
	end
	function M.Divider(section, options)
		local self = M.base(section, "Divider", options, "content")
		self._label.Text = string.upper(self.Text)
		return self
	end
	function M.Badge(section, options)
		assert(options.Kind == nil or ({ Success = true, Warning = true, Danger = true, Secondary = true })[options.Kind], "Unknown badge Kind")
		local self = M.base(section, "Badge", options, "inline", 120)
		self._normalize = function(value) assert(type(value) == "string", "Badge value must be a string"); return value end
		self._value = self._normalize(options.Default or options.Value or "Ready")
		local tone = options.Kind or "Secondary"
		local badge = C.node(self, "Frame", self._slot, { AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.fromScale(1, 0.5), Size = UDim2.new(1, 0, 0, 28) }, { BackgroundColor3 = function(theme) return theme.Surface:Lerp(theme[tone], 0.12) end })
		C.corner(badge, 14)
		self._afterLayout = function(width)
			badge.AnchorPoint = Vector2.new(self._stacked and 0 or 1, 0.5)
			badge.Position = UDim2.fromScale(self._stacked and 0 or 1, 0.5)
			badge.Size = UDim2.fromOffset(math.min(120, width), 28)
		end
		local label = C.text(self, badge, self._value, "Caption", options.Kind or "Secondary", { Size = UDim2.new(1, -16, 1, 0), Position = UDim2.fromOffset(8, 0), TextXAlignment = Enum.TextXAlignment.Center, TextWrapped = false, TextTruncate = Enum.TextTruncate.AtEnd })
		self._render = function() label.Text = self._value end
		self._layout()
		return self
	end
	function M.Progress(section, options)
		local self = M.base(section, "Progress", options, "stack")
		local minimum, maximum = options.Min or 0, options.Max or 100
		assert(C.finite(minimum) and C.finite(maximum) and maximum > minimum, "Progress Max must exceed Min")
		self._normalize = function(value) assert(C.finite(value), "Progress expects a finite number"); return C.clamp(value, minimum, maximum) end
		self._value = self._normalize(options.Default or options.Value or minimum)
		self._slotHeight = function() return 12 end
		local track = C.node(self, "Frame", self._slot, { Size = UDim2.new(1, 0, 0, 8), Position = UDim2.fromOffset(0, 2) }, { BackgroundColor3 = "Track" })
		C.corner(track, 4)
		local fill = C.node(self, "Frame", track, { Size = UDim2.fromScale(0, 1) }, { BackgroundColor3 = "Accent" })
		C.corner(fill, 4)
		local value = C.text(self, self.Frame, "", "Caption", "Secondary", { Position = UDim2.new(1, -96, 0, 14), Size = UDim2.fromOffset(80, 20), TextXAlignment = Enum.TextXAlignment.Right })
		self._labelReserve = 96
		self._render = function()
			local fraction = (self._value - minimum) / (maximum - minimum)
			fill.Size = UDim2.fromScale(fraction, 1)
			value.Text = tostring(math.floor(fraction * 100 + 0.5)) .. "%"
		end
		self._render(); self._layout()
		return self
	end
	function M.create(section, kind, options)
		options = type(options) == "string" and { Text = options } or options or {}
		local factory = M[kind]
		if kind == "Dropdown" or kind == "Segmented" or kind == "Keybind" then factory = env.require("choice")[kind]
		elseif kind == "ColorPicker" then factory = env.require("color")[kind]
		elseif kind == "Transcript" then factory = env.require("transcript").create end
		assert(factory, "Unknown control " .. tostring(kind))
		local before = #section.Controls
		local ok, control = pcall(factory, section, options)
		if not ok then
			for index = #section.Controls, before + 1, -1 do section.Controls[index]:Destroy() end
			error(control, 2)
		end
		control._default = C.copy(control._value)
		control:SetDisabled(control.Disabled)
		section._window:_Filter()

		return C.elevate(control)
	end
	C.elevate(Control)
	return M
end
end)()

uiModules["core"] = (function()
return function(env)
	local tokens = env.require("theme")
	local M = { services = env.services, tokens = tokens }
	local unpackValues = table.unpack or unpack
	local korean = {
		["Confirm action"] = "작업 확인",
		["Cancel"] = "취소",
		["Confirm"] = "확인",
		["Dark mode"] = "어두운 모드",
		["Light mode"] = "밝은 모드",
		["Minimized"] = "최소화됨",
		["New notification"] = "새 알림",
		["NAVIGATION"] = "메뉴",
		["No matching controls"] = "검색 결과 없음",
		["Search this tab"] = "이 탭 검색",
		["Open"] = "열기",
		["Close"] = "닫기",
		["Done"] = "완료",
		["Dismiss"] = "닫기",
		["Action failed"] = "작업 실패",
		["Run"] = "실행",
		["Working…"] = "처리 중…",
		["On"] = "켜짐",
		["Off"] = "꺼짐",
		["Ready"] = "준비됨",
		["Choose"] = "선택",
		["Select an option"] = "선택해 주세요",
		["Search options"] = "항목 검색",
		["Selected"] = "선택됨",
		["No matching options"] = "검색 결과 없음",
		["Press a key…"] = "키를 누르세요…",
		["Not set"] = "미설정",
		["Choose another key"] = "다른 키를 선택하세요",
		["WORKSPACE"] = "작업 공간",
		["Show"] = "펼치기",
		["Hide"] = "접기",
		["Current"] = "현재",
		["New"] = "새 색상",
		["Local player"] = "현재 플레이어",
		["Current experience"] = "현재 게임",
		["Message Codex..."] = "Codex에게 메시지를 입력하세요…",
		["Send"] = "보내기",
		["Stop"] = "중단",
		["New Chat"] = "새 대화",
		["Copy"] = "복사",
		["Save"] = "저장",
		["Save As"] = "다른 이름으로 저장",
		["Enter a valid number."] = "올바른 숫자를 입력하세요.",
	}
	function M.translate(owner, text)
		local window = owner and (owner._window or owner)
		return window and window.Locale == "ko" and (korean[text] or text) or text
	end

	local getIdentity = (type(getidentity) == "function" and getidentity)
		or (type(getthreadidentity) == "function" and getthreadidentity) or nil
	local setIdentity = (type(setidentity) == "function" and setidentity)
		or (type(setthreadidentity) == "function" and setthreadidentity) or nil
	local identity
	if getIdentity and setIdentity then
		local ok, value = pcall(getIdentity)
		if ok and type(value) == "number" then identity = value end
	end
	M.identity = identity
	function M.reclaim()
		if identity then pcall(setIdentity, identity) end
	end
	function M.reclaimed(callback)
		if not identity then return callback end
		return function(...)
			pcall(setIdentity, identity)
			return callback(...)
		end
	end

	function M.elevate(target)
		if not identity then return target end
		local methods = {}
		for key, value in pairs(target) do
			if type(key) == "string" and type(value) == "function" and key:match("^%u") then methods[key] = value end
		end
		for key, value in pairs(methods) do rawset(target, key, M.reclaimed(value)) end
		return target
	end

	local Scope = {}
	Scope.__index = Scope

	local function dispose(resource)
		local kind = typeof(resource)
		if type(resource) == "function" then resource()
		elseif kind == "RBXScriptConnection" or (type(resource) == "table" and resource.Disconnect) then resource:Disconnect()
		elseif kind == "Instance" or (type(resource) == "table" and resource.Destroy) then resource:Destroy()
		elseif type(resource) == "thread" and task.cancel then pcall(task.cancel, resource)
		end
	end
	function M.scope(parent)
		local scope = setmetatable({ alive = true, items = {} }, Scope)
		if parent then scope.release = parent:Add(function() scope:Destroy() end) end
		return scope
	end
	function Scope:Add(resource)
		assert(resource ~= nil, "Give expects a cleanup function, connection, instance, or task")
		if not self.alive then pcall(dispose, resource); return function() end end
		local key = {}
		self.items[key] = resource
		return function(clean)
			local value = self.items[key]
			self.items[key] = nil
			if value ~= nil and clean ~= false then pcall(dispose, value) end
		end
	end
	function Scope:Connect(signal, callback)
		local connection = signal:Connect(function(...)
			if self.alive then M.reclaim(); callback(...) end
		end)
		self:Add(connection)
		return connection
	end
	function Scope:Delay(seconds, callback)
		local release, finished
		local thread = task.delay(seconds, function()
			finished = true
			if release then release(false) end
			if self.alive then M.reclaim(); callback() end
		end)
		if not finished then release = self:Add(thread) end
		return function() if release then release(); release = nil end end
	end
	function Scope:Spawn(callback)
		local release, finished
		local thread = task.spawn(function()
			if self.alive then M.reclaim(); callback() end
			finished = true
			if release then release(false) end
		end)
		if not finished then release = self:Add(thread) end
		return thread
	end
	function Scope:Destroy()
		if not self.alive then return end
		self.alive = false
		local items = self.items
		self.items = {}
		for _, resource in pairs(items) do
			local ok, why = pcall(dispose, resource)
			if not ok then warn("UI LIB cleanup: " .. tostring(why)) end
		end
		if self.release then self.release(false); self.release = nil end
	end

	function M.clamp(value, low, high) return math.max(low, math.min(high, value)) end
	function M.finite(value) return type(value) == "number" and value == value and value > -math.huge and value < math.huge end
	function M.number(value, fallback, low, high)
		if not M.finite(value) then value = fallback end
		return M.clamp(value, low, high)
	end
	function M.truncate(value, limit)
		if #value <= limit then return value end
		local cut = limit + 1
		while cut > 1 do
			local byte = value:byte(cut)
			if not byte or byte < 128 or byte >= 192 then break end
			cut = cut - 1
		end
		return value:sub(1, cut - 1)
	end
	function M.copy(value)
		if typeof(value) ~= "table" then return value end
		local result = {}
		for key, item in pairs(value) do result[key] = M.copy(item) end
		return result
	end
	function M.equal(a, b)
		if a == b then return true end
		if typeof(a) ~= "table" or typeof(b) ~= "table" then return false end
		for key, value in pairs(a) do if not M.equal(value, b[key]) then return false end end
		for key in pairs(b) do if a[key] == nil then return false end end
		return true
	end
	function M.call(window, callback, ...)
		if type(callback) ~= "function" then return true end
		local result = { pcall(callback, ...) }
		if not result[1] then
			warn("당구 UI: " .. tostring(result[2]))
			if window and window.Alive and window.Notify then
				window:Notify({ Title = "Action failed", Content = tostring(result[2]), Kind = "Danger" })
			end
		end
		return unpackValues(result)
	end
	function M.owner(window, parentScope)
		return { _window = window, _scope = M.scope(parentScope or window._scope) }
	end
	function M.bind(owner, instance, properties)
		local window = owner._window
		local binding = window._paintNodes[instance]
		if not binding then
			binding = { node = instance, owner = owner, properties = {} }
			window._paint[binding], window._paintNodes[instance] = true, binding
			owner._scope:Add(function()
				window._paint[binding] = nil
				if window._paintNodes[instance] == binding then window._paintNodes[instance] = nil end
			end)
		end
		for key, value in pairs(properties) do
			binding.properties[key] = value
			if type(value) == "function" then instance[key] = value(window.Theme)
			else instance[key] = window.Theme[value] end
		end
		return instance
	end
	function M.node(owner, class, parent, props, colors)
		local instance = Instance.new(class)
		if instance:IsA("GuiObject") then instance.BorderSizePixel = 0 end
		if class == "TextButton" or class == "ImageButton" then
			instance.AutoButtonColor = false
			instance.Selectable = true
			if class == "TextButton" then instance.Text = "" end
		end
		for key, value in pairs(props or {}) do
			if (key == "Text" or key == "PlaceholderText") and type(value) == "string" then value = M.translate(owner, value) end
			instance[key] = value
		end
		if colors then M.bind(owner, instance, colors) end
		instance.Parent = parent
		return instance
	end
	function M.corner(parent, radius)
		local node = Instance.new("UICorner")
		node.CornerRadius = UDim.new(0, radius or tokens.Size.FieldRadius)
		node.Parent = parent
		return node
	end

	function M.chromeBand(owner, parent, props, bottom)
		local band = M.node(owner, "Frame", parent, props)
		band.BackgroundTransparency, band.ClipsDescendants = 1, true
		local radius = tokens.Size.Radius
		local surface = M.node(owner, "Frame", band, {
			Name = "Surface", Position = UDim2.fromOffset(0, bottom and -radius or 0),
			Size = UDim2.new(1, 0, 1, radius),
		}, { BackgroundColor3 = "Chrome" })
		M.corner(surface, radius)
		return band
	end
	function M.stroke(owner, parent, color)
		local node = M.node(owner, "UIStroke", parent, { Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }, { Color = color or "Border" })
		return node
	end
	function M.fieldBorder(owner, field, invalid)
		local editing = false
		local border = M.stroke(owner, field, "Edge")
		local function color(theme)
			if invalid and invalid() then return theme.Danger end
			return editing and theme.Accent or theme.Edge
		end
		M.bind(owner, border, { Color = color })
		local function refresh()
			if not owner._scope.alive then return end
			border.Thickness = editing and 2 or 1
			env.require("motion").to(owner, border, { Color = color(owner._window.Theme) })
		end
		owner._scope:Connect(field.Focused, function() editing = true; refresh() end)
		owner._scope:Connect(field.FocusLost, function() editing = false; refresh() end)
		return border, refresh
	end
	function M.pad(parent, x, y)
		local node = Instance.new("UIPadding")
		node.PaddingLeft, node.PaddingRight = UDim.new(0, x), UDim.new(0, x)
		node.PaddingTop, node.PaddingBottom = UDim.new(0, y or x), UDim.new(0, y or x)
		node.Parent = parent
		return node
	end
	function M.list(parent, horizontal, gap)
		local node = Instance.new("UIListLayout")
		node.SortOrder = Enum.SortOrder.LayoutOrder
		node.FillDirection = horizontal and Enum.FillDirection.Horizontal or Enum.FillDirection.Vertical
		node.Padding = UDim.new(0, gap or 0)
		node.Parent = parent
		return node
	end
	local font, strong, display = Enum.Font.Gotham, Enum.Font.GothamMedium, Enum.Font.GothamBold
	pcall(function() font, strong, display = Enum.Font.BuilderSans, Enum.Font.BuilderSansMedium, Enum.Font.BuilderSansBold end)
	M.Font = font
	function M.text(owner, parent, text, role, color, props)
		local config = {
			BackgroundTransparency = 1, Text = tostring(text or ""), RichText = false,
			Font = role == "Display" and display or (role == "Title" or role == "Heading" or role == "Eyebrow") and strong or font,
			TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Center,
			TextWrapped = true, TextSize = tokens.Type[role or "Body"] or tokens.Type.Body,
			Size = UDim2.new(1, 0, 0, 20),
		}
		for key, value in pairs(props or {}) do config[key] = value end
		local node = M.node(owner, "TextLabel", parent, config, {
			TextColor3 = color or "Text",
			TextSize = function() return math.floor((tokens.Type[role or "Body"] or tokens.Type.Body) * owner._window.TextScale + 0.5) end,
		})
		pcall(function()
			local base = Font.fromEnum(config.Font)
			node.FontFace = Font.new(base.Family, role == "Display" and Enum.FontWeight.Bold or (role == "Title" or role == "Heading" or role == "Eyebrow") and Enum.FontWeight.Medium or Enum.FontWeight.Regular)
		end)
		return node
	end
	function M.measure(text, size, width, textFont)
		width = math.max(1, width)
		local ok, bounds = pcall(function()
			return env.services.TextService:GetTextSize(tostring(text), size, textFont or font, Vector2.new(width, 100000))
		end)
		return ok and math.ceil(bounds.Y) or math.ceil(math.max(1, #tostring(text) * size * 0.55 / width)) * math.ceil(size * 1.3)
	end
	function M.reflow(owner, callback)
		local window = owner._window
		window._reflow[callback] = true
		owner._scope:Add(function() window._reflow[callback] = nil end)
		callback()
	end
	function M.scroll(owner, parent, name)
		return M.node(owner, "ScrollingFrame", parent, {
			Name = name, BackgroundTransparency = 1, BorderSizePixel = 0,
			CanvasSize = UDim2.fromOffset(0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y,
			ScrollBarThickness = tokens.Size.Scrollbar, ScrollingDirection = Enum.ScrollingDirection.Y,
			ClipsDescendants = true, Size = UDim2.fromScale(1, 1),
		}, { ScrollBarImageColor3 = "Muted" })
	end
	local ICONS = {
		close = { { 4, 4, 16, 16 }, { 16, 4, 4, 16 } },
		minus = { { 4, 10, 16, 10 } },
		chevron = { { 5, 8, 10, 13 }, { 10, 13, 15, 8 } },
		check = { { 4, 10, 8, 14 }, { 8, 14, 16, 5 } },
		arrow = { { 4, 10, 16, 10 }, { 11, 5, 16, 10 }, { 16, 10, 11, 15 } },
		sliders = { { 3, 5, 17, 5 }, { 3, 10, 17, 10 }, { 3, 15, 17, 15 }, { 7, 3, 7, 7 }, { 13, 8, 13, 12 }, { 8, 13, 8, 17 } },
		grid = { { 4, 4, 8, 4 }, { 12, 4, 16, 4 }, { 4, 10, 8, 10 }, { 12, 10, 16, 10 }, { 4, 16, 8, 16 }, { 12, 16, 16, 16 } },
		code = { { 6, 5, 2, 10 }, { 2, 10, 6, 15 }, { 14, 5, 18, 10 }, { 18, 10, 14, 15 }, { 12, 3, 8, 17 } },
	}
	function M.icon(owner, parent, name, color, size)
		size = size or 18
		local frame = M.node(owner, "Frame", parent, { Name = name, BackgroundTransparency = 1, Size = UDim2.fromOffset(size, size) })
		for _, points in ipairs(ICONS[name] or ICONS.grid) do
			local dx, dy = points[3] - points[1], points[4] - points[2]
			local line = M.node(owner, "Frame", frame, {
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale((points[1] + points[3]) / 40, (points[2] + points[4]) / 40),
				Size = UDim2.fromOffset(math.sqrt(dx * dx + dy * dy) * size / 20, 1.5),
				Rotation = math.deg(math.atan2(dy, dx)),
			}, { BackgroundColor3 = color or "Secondary" })
			M.corner(line, 1)
		end
		return frame
	end
	function M.feedback(owner, button, style, enabled)
		local window, hovered, selected, pressed = owner._window, false, false, false
		local motion = env.require("motion")
		local stroke = M.node(owner, "UIStroke", button, { Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border })
		local function edgeColor(theme)
			return (hovered or selected) and (not enabled or enabled()) and theme.Accent or theme.Edge
		end
		local function edgeOpacity()
			return (style == "Primary" or style == "Danger") and not selected and not hovered and 1 or 0
		end
		local function edgeThickness() return selected and 2 or 1 end
		local function paint(theme)
			local active = not enabled or enabled()
			if style == "Primary" or style == "Danger" then
				if not active then return theme.Raised end
				local base = style == "Primary" and theme.Primary or theme.Danger
				if pressed then return base:Lerp(theme.OnPrimary, 0.16) end
				if hovered then return base:Lerp(style == "Primary" and theme.Accent or theme.Text, 0.1) end
				return base
			end
			return active and pressed and theme.Pressed or active and hovered and theme.Hover or style == "Field" and theme.Input or theme.Raised
		end
		M.bind(owner, button, { BackgroundColor3 = paint })
		M.bind(owner, stroke, { Color = edgeColor, Transparency = edgeOpacity, Thickness = edgeThickness })
		local function refresh()
			if not owner._scope.alive then return end
			local duration = pressed and tokens.Motion.Press or tokens.Motion.Fast
			motion.to(owner, button, { BackgroundColor3 = paint(window.Theme) }, duration)
			motion.to(owner, stroke, { Color = edgeColor(window.Theme), Transparency = edgeOpacity(), Thickness = edgeThickness() }, duration)
		end
		local function release() if pressed then pressed = false; refresh() end end
		window._presses[release] = true
		owner._scope:Add(function() window._presses[release] = nil end)
		owner._scope:Connect(button.MouseEnter, function() hovered = true; refresh() end)
		owner._scope:Connect(button.MouseLeave, function() hovered, pressed = false, false; refresh() end)
		owner._scope:Connect(button.SelectionGained, function() selected = true; refresh() end)
		owner._scope:Connect(button.SelectionLost, function() selected, pressed = false, false; refresh() end)
		owner._scope:Connect(button.InputBegan, function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch
				or input.KeyCode == Enum.KeyCode.ButtonA or input.KeyCode == Enum.KeyCode.Return then pressed = true; refresh() end
		end)
		return refresh
	end

	function M.selection(owner, button, chosen, enabled)
		local hovered, focused = false, false
		local edge = M.stroke(owner, button, "Accent")
		local function background(theme)
			if chosen() then return theme.Selected end
			return hovered and (not enabled or enabled()) and theme.Hover or theme.Input
		end
		local function opacity()
			return focused and 0 or chosen() and 0.6 or 1
		end
		M.bind(owner, button, { BackgroundColor3 = background })
		M.bind(owner, edge, { Transparency = opacity })
		local function refresh()
			local motion = env.require("motion")
			motion.to(owner, button, { BackgroundColor3 = background(owner._window.Theme) })
			motion.to(owner, edge, { Transparency = opacity() })
		end
		owner._scope:Connect(button.MouseEnter, function() hovered = true; refresh() end)
		owner._scope:Connect(button.MouseLeave, function() hovered = false; refresh() end)
		owner._scope:Connect(button.SelectionGained, function() focused = true; refresh() end)
		owner._scope:Connect(button.SelectionLost, function() focused = false; refresh() end)
		return refresh
	end
	function M.releaseFocus(window, root)
		local focused = env.services.UserInputService:GetFocusedTextBox()
		if focused and focused:IsDescendantOf(root or window.ScreenGui) then
			pcall(function() focused:ReleaseFocus() end)
		end
	end
	function M.cancelGesture(window, owner)
		local gesture = window._gesture
		if not gesture or (owner and gesture.owner ~= owner) then return end
		window._gesture = nil
		if gesture.release then gesture.release() end
	end
	function M.pointer(owner, target, began, moved, ended, options)

		local window = owner._window
		owner._scope:Connect(target.InputBegan, function(input)
			local kind = input.UserInputType
			if window._gesture or not window.Alive then return end
			if kind ~= Enum.UserInputType.MouseButton1 and kind ~= Enum.UserInputType.Touch then return end
			if options and options.CanStart and not options.CanStart() then return end
			local touch = kind == Enum.UserInputType.Touch
			local pending = touch and options and options.TouchAxis == "X"
			local origin, scrolls = input.Position, {}
			local gesture = { input = input, owner = owner }
			function gesture.release()
				for scroll, enabled in pairs(scrolls) do
					if scroll.Parent then scroll.ScrollingEnabled = enabled end
				end
				scrolls = {}
			end
			local function start(current)
				if began(current) == false or not owner._scope.alive or not window.Alive or window._gesture ~= gesture then
					if window._gesture == gesture then M.cancelGesture(window) end
					return false
				end
				pending = false
				if touch and options and (options.TouchAxis or options.LockScroll) then
					local ancestor = target.Parent
					while ancestor and ancestor ~= window.ScreenGui do
						if ancestor:IsA("ScrollingFrame") then
							scrolls[ancestor] = ancestor.ScrollingEnabled
							ancestor.ScrollingEnabled = false
						end
						ancestor = ancestor.Parent
					end
				end
				return true
			end
			function gesture.move(current)
				if pending then
					local delta = current.Position - origin
					if math.max(math.abs(delta.X), math.abs(delta.Y)) < tokens.Size.TouchSlop then return end

					if math.abs(delta.Y) >= math.abs(delta.X) then M.cancelGesture(window); return end
					if not start(current) then return end
				end
				if moved then moved(current) end
			end
			function gesture.finish(current)
				if pending then gesture.move(current) end
				if window._gesture ~= gesture then return end
				if pending and not start(current) then return end
				if ended then ended(current) end
			end
			window._gesture = gesture
			if not pending then start(input) end
		end)
		owner._scope:Add(function()
			M.cancelGesture(window, owner)
		end)
	end
	function M.isInside(node, x, y)
		local origin, size = node.AbsolutePosition, node.AbsoluteSize
		return x >= origin.X and y >= origin.Y and x <= origin.X + size.X and y <= origin.Y + size.Y
	end
	return M
end
end)()

uiModules["library"] = (function()
return function(env)
	local Window = env.require("window")
	for name, method in pairs(env.require("config")) do Window[name] = method end
	local UI = { Version = env.metadata.version, URL = env.metadata.url, Repository = env.metadata.repository }
	function UI:CreateWindow(options) return Window.new(options) end
	function UI:GetWindow(id) return env.windows[id] end
	function UI:DestroyAll()
		local windows = {}
		for _, window in pairs(env.windows) do windows[#windows + 1] = window end
		for _, window in ipairs(windows) do window:Destroy() end
	end
	return UI
end
end)()

uiModules["motion"] = (function()

return function(env)
	local T = env.require("theme")
	local M = {}
	local function assign(node, properties)
		for key, value in pairs(properties) do node[key] = value end
	end
	local function visible(window, node)
		local ancestor = node
		while ancestor and ancestor ~= window.ScreenGui do
			if ancestor:IsA("GuiObject") and not ancestor.Visible then return false end
			ancestor = ancestor.Parent
		end
		return ancestor ~= nil and window.ScreenGui.Enabled
	end
	function M.stop(window, node, settle)
		local entry = window._motions and window._motions[node]
		if not entry then return end
		window._motions[node] = nil
		if entry.connection then entry.connection:Disconnect() end
		if entry.tween then pcall(function() entry.tween:Cancel() end) end
		if entry.release then entry.release(false) end
		if settle and node.Parent then assign(node, entry.goals) end
	end
	function M.stopAll(window, settle)
		local nodes = {}
		for node in pairs(window._motions or {}) do nodes[#nodes + 1] = node end
		for _, node in ipairs(nodes) do M.stop(window, node, settle) end
	end
	function M.to(owner, node, properties, seconds)
		local window = owner._window
		if not owner._scope.alive or not window.Alive or not node.Parent then return end
		local goals = {}
		local previous = window._motions[node]
		local immediate = window.ReducedMotion or seconds == 0 or not visible(window, node)
		if previous and not immediate then
			local same = true
			for key, value in pairs(properties) do if previous.goals[key] ~= value then same = false; break end end
			if same then return end
		end
		if previous then for key, value in pairs(previous.goals) do goals[key] = value end end
		for key, value in pairs(properties) do goals[key] = value end
		M.stop(window, node, false)
		local changed = false
		for key, value in pairs(goals) do if node[key] ~= value then changed = true; break end end
		if not changed then return end
		if immediate then assign(node, goals); return end
		local ok, tween = pcall(function()
			return env.services.TweenService:Create(node, TweenInfo.new(seconds or T.Motion.Fast, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), goals)
		end)
		if not ok or not tween then assign(node, goals); return end
		local entry = { goals = goals, tween = tween }
		window._motions[node] = entry
		entry.release = owner._scope:Add(function() M.stop(window, node, true) end)
		entry.connection = tween.Completed:Connect(function()
			if window._motions[node] ~= entry then return end
			window._motions[node] = nil
			entry.connection:Disconnect(); entry.release(false)
			if owner._scope.alive and node.Parent then assign(node, goals) end
		end)
		local played = pcall(function() tween:Play() end)
		if not played then M.stop(window, node, true) end
	end

	function M.reveal(owner, node, color, radius)
		local window = owner._window
		local veil = node:FindFirstChild("Reveal")
		if window.ReducedMotion or not visible(window, node) then
			if veil then M.to(owner, veil, { BackgroundTransparency = 1 }, 0) end
			return
		end
		if not veil then
			local C = env.require("core")
			veil = C.node(owner, "Frame", node, {
				Name = "Reveal", Size = UDim2.fromScale(1, 1), Active = false, Selectable = false, ZIndex = 50,
			})
			local corner = node:FindFirstChildOfClass("UICorner")
			C.corner(veil, radius or (corner and corner.CornerRadius.Offset) or 0)
		end
		veil.BackgroundColor3 = color or node.BackgroundColor3

		if not window._motions[veil] then veil.BackgroundTransparency = 0 end
		M.to(owner, veil, { BackgroundTransparency = 1 }, T.Motion.Enter)
	end
	return M
end
end)()

uiModules["overlays"] = (function()
return function(env)
	local C = env.require("core")
	local motion = env.require("motion")
	local M = {}
	function M.panel(window, options)
		assert(window.Alive, "Window is destroyed")
		options = options or {}
		window:_CloseOverlay()
		window:_CancelCapture()
		window:_ReleaseKeys()
		C.cancelGesture(window)
		local panel = C.owner(window)
		panel.Dismissible, panel.Closed, panel.Control = options.Dismissible ~= false, false, options.Control
		local previous = env.services.GuiService.SelectedObject
		panel.Root = C.node(panel, "Frame", window._viewport, {
			Name = "Overlay", BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), ZIndex = 100,
		})
		local scrim = C.node(panel, "TextButton", panel.Root, { Name = "Backdrop", Size = UDim2.fromScale(1, 1), BackgroundTransparency = options.Anchor and 1 or 0.4, Selectable = false, Modal = true }, { BackgroundColor3 = "Scrim" })
		panel.Frame = C.node(panel, "Frame", panel.Root, { Name = "Panel", Active = true, ClipsDescendants = true, ZIndex = 2 }, { BackgroundColor3 = "Surface" })
		C.corner(panel.Frame, C.tokens.Size.Radius); C.stroke(panel, panel.Frame, "Edge")
		local headerSurface = C.chromeBand(panel, panel.Frame, { Name = "PanelHeader", Size = UDim2.new(1, 0, 0, 54) })
		C.node(panel, "Frame", headerSurface, { Position = UDim2.fromOffset(20, 0), Size = UDim2.fromOffset(40, 2) }, { BackgroundColor3 = "Accent" })
		pcall(function()
			panel.Frame.SelectionGroup = true
			panel.Frame.SelectionBehaviorUp = Enum.SelectionBehavior.Stop
			panel.Frame.SelectionBehaviorDown = Enum.SelectionBehavior.Stop
			panel.Frame.SelectionBehaviorLeft = Enum.SelectionBehavior.Stop
			panel.Frame.SelectionBehaviorRight = Enum.SelectionBehavior.Stop
		end)
		local title = C.text(panel, panel.Frame, options.Title or "", "Title", "Text", {
			Position = UDim2.fromOffset(20, 12), Size = UDim2.new(1, -40 - math.max(window.Target, 64 * window.TextScale), 0, 32), TextWrapped = false, TextTruncate = Enum.TextTruncate.AtEnd,
		})
		local close = C.node(panel, "TextButton", panel.Frame, { Name = "Dismiss", AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -8, 0, 6), Size = UDim2.fromOffset(window.Target, window.Target), Visible = panel.Dismissible })
		close.Size = UDim2.fromOffset(math.max(window.Target, 64 * window.TextScale), window.Target)
		C.corner(close); C.feedback(panel, close)
		C.text(panel, close, "Close", "Caption", "Secondary", { Size = UDim2.fromScale(1, 1), TextXAlignment = Enum.TextXAlignment.Center, TextWrapped = false })
		panel.Body = C.scroll(panel, panel.Frame, "Body")
		C.pad(panel.Body, 20, 8); C.list(panel.Body, false, 12)
		panel.Actions = C.scroll(panel, panel.Frame, "Actions")
		panel.Actions.ScrollBarThickness = 0
		function panel:Close()
			if self.Closed then return end
			self.Closed = true
			C.releaseFocus(window, self.Root)
			if window._overlay == self then window._overlay = nil end
			C.cancelGesture(window, self)
			self._scope:Destroy()
			self.Root:Destroy()
			pcall(function()
				env.services.GuiService.SelectedObject = previous and previous.Parent and previous or nil
			end)
			C.call(window, options.OnClose)
		end
		function panel:Focus(node)
			if previous then pcall(function() env.services.GuiService.SelectedObject = node end) end
		end
		panel._scope:Connect(scrim.Activated, function() if panel.Dismissible then panel:Close() end end)
		panel._scope:Connect(close.Activated, function() panel:Close() end)
		panel._scope:Add(function() if window._overlay == panel then window._overlay = nil end end)
		window._overlay = panel
		C.reflow(panel, function()
			local rect = window._rect
			scrim.BackgroundTransparency = options.Anchor and not window._compact and 1 or 0.4
			local width = math.min(C.number(options.Width, 440, 160, 1200), rect.width)
			local height = math.min(C.number(options.Height, 320, 120, 1200), rect.height)
			local header = math.max(54, window.Target + 12)
			headerSurface.Size = UDim2.new(1, 0, 0, header)
			local actionHeight = options.Actions and window.Target or 0
			if panel.LayoutActions then actionHeight = panel.LayoutActions(width) end
			if window.Touch and actionHeight > window.Target then
				height = math.min(rect.height, math.max(height, header + 30 + actionHeight + 20 + window.Target + 16))
			end
			local inlineActions = window.Touch and options.Actions and height - header - 30 - actionHeight - 20 < window.Target + 16
			local x, y = rect.x + (rect.width - width) / 2, rect.y + (rect.height - height) / 2
			if options.Anchor and not window._compact then
				local anchor, origin = options.Anchor, window._viewport.AbsolutePosition
				x = C.clamp(anchor.AbsolutePosition.X - origin.X, rect.x, rect.x + rect.width - width)
				y = anchor.AbsolutePosition.Y - origin.Y + anchor.AbsoluteSize.Y + 6
				if y + height > rect.y + rect.height then y = anchor.AbsolutePosition.Y - origin.Y - height - 6 end
				y = C.clamp(y, rect.y, rect.y + rect.height - height)
			end
			panel.Width, panel.Height = width, height
			panel.Frame.Position, panel.Frame.Size = UDim2.fromOffset(math.floor(x), math.floor(y)), UDim2.fromOffset(width, height)
			local actions = options.Actions and not inlineActions and actionHeight + 20 or 0
			local closeWidth = math.max(window.Target, 64 * window.TextScale)
			close.Size = UDim2.fromOffset(closeWidth, window.Target)
			title.Size = UDim2.new(1, -(panel.Dismissible and (40 + closeWidth) or 40), 0, math.max(32, 22 * window.TextScale))
			panel.HeaderHeight = header
			panel.Body.Position = UDim2.fromOffset(0, header)
			panel.Body.Size = UDim2.fromOffset(width, math.max(0, height - header - 30 - actions))
			panel.InlineActions = inlineActions == true
			panel.Actions.Parent = inlineActions and panel.Body or panel.Frame
			panel.Actions.LayoutOrder = 10000
			panel.Actions.Position = inlineActions and UDim2.fromOffset(0, 0) or UDim2.new(0, 20, 1, -30 - actions + 8)
			panel.Actions.Size = UDim2.new(1, inlineActions and 0 or -40, 0, actionHeight)
			panel.Actions.ScrollingEnabled = not inlineActions
			panel.Actions.Visible = options.Actions == true
			if panel.OnLayout then panel.OnLayout(width, height) end
		end)
		panel:Focus(close)
		motion.reveal(panel, panel.Frame)
		return panel
	end
	function M.dialog(window, options)
		options = options or {}
		local buttons = options.Buttons or { { Text = "Done", Style = "Primary" } }
		assert(type(buttons) == "table" and #buttons > 0 and #buttons <= 4, "Dialog expects 1-4 buttons")
		for _, spec in ipairs(buttons) do
			assert(type(spec) == "table" and (spec.Callback == nil or type(spec.Callback) == "function"), "Dialog buttons must be records with optional callbacks")
		end
		local panel = M.panel(window, { Title = options.Title or "당구 도우미", Height = options.Height or 300, Width = options.Width, Dismissible = options.Dismissible, Actions = true })
		local content = C.text(panel, panel.Body, options.Content or "", "Body", "Secondary", {
			Name = "Message", TextYAlignment = Enum.TextYAlignment.Top, Size = UDim2.new(1, 0, 0, 0), LayoutOrder = 0,
		})
		local actions = {}
		for index, spec in ipairs(buttons) do
			local button = C.node(panel, "TextButton", panel.Actions, { Name = "DialogAction_" .. index, LayoutOrder = index })
			C.corner(button); C.feedback(panel, button, spec.Style)
			C.text(panel, button, spec.Text or "Done", "Body", (spec.Style == "Primary" or spec.Style == "Danger") and "OnPrimary" or "Text", {
				Size = UDim2.new(1, -16, 1, 0), Position = UDim2.fromOffset(8, 0), TextXAlignment = Enum.TextXAlignment.Center,
			})
			panel._scope:Connect(button.Activated, function()
				panel:Close()
				if window.Alive then window._scope:Spawn(function() C.call(window, spec.Callback) end) end
			end)
			actions[#actions + 1] = button
		end
		panel.LayoutActions = function(width)
			local columns = #actions
			if window.Touch then columns = math.max(1, math.min(#actions, math.floor((width - 32) / (112 * window.TextScale + 8)))) end
			local cellWidth = math.max(1, (width - 40 - (columns - 1) * 8) / columns)
			local rowHeight = window.Target
			if window.Touch then
				for _, spec in ipairs(buttons) do
					rowHeight = math.max(rowHeight, math.min(window.Target * 2, C.measure(spec.Text or "Done", 14 * window.TextScale, cellWidth - 16) + 16))
				end
			end
			for index, button in ipairs(actions) do
				button.Size = UDim2.fromOffset(cellWidth, rowHeight)
				button.Position = UDim2.fromOffset(((index - 1) % columns) * (cellWidth + 8), math.floor((index - 1) / columns) * (rowHeight + 8))
			end
			return math.ceil(#actions / columns) * (rowHeight + 8) - 8
		end
		panel.OnLayout = function(width)
			content.Size = UDim2.new(1, 0, 0, C.measure(content.Text, 14 * window.TextScale, width - 40))
		end
		window:_Layout()
		panel:Focus(actions[#actions])
		return panel
	end
	local function fitToasts(window)
		local remaining = window._toastHost.Size.Y.Offset
		for index = #window._toasts, 1, -1 do
			local toast = window._toasts[index]
			local height = toast.Frame.Size.Y.Offset
			toast.Frame.LayoutOrder = index
			toast.Frame.Visible = height <= remaining
			if toast.Frame.Visible then remaining = remaining - height - 8 end
		end
	end
	function M.notify(window, options)
		if not window.Alive then return nil end
		options = type(options) == "string" and { Content = options } or options or {}
		assert(options.Action == nil or (type(options.Action) == "table" and (options.Action.Callback == nil or type(options.Action.Callback) == "function")), "Notification Action must be a record with an optional callback")
		local toast = C.owner(window)
		toast.Closed = false
		toast._scope:Add(function() toast.Closed = true end)
		toast.Frame = C.node(toast, "Frame", window._toastHost, { Name = "Notification", ClipsDescendants = true, Size = UDim2.new(1, 0, 0, 100), LayoutOrder = #window._toasts + 1 }, { BackgroundColor3 = "Surface" })
		C.corner(toast.Frame, 14); C.stroke(toast, toast.Frame, "Edge")
		local kind = ({ Success = "Success", Warning = "Warning", Danger = "Danger", Info = "Accent" })[options.Kind] or "Accent"
		local status = C.node(toast, "Frame", toast.Frame, { Position = UDim2.fromOffset(16, 19), Size = UDim2.fromOffset(6, 6) }, { BackgroundColor3 = kind })
		C.corner(status, 3)
		local title = C.text(toast, toast.Frame, C.truncate(tostring(options.Title or "당구 도우미"), 240), "Heading", "Text", { Position = UDim2.fromOffset(32, 12), TextWrapped = false, TextTruncate = Enum.TextTruncate.AtEnd })
		local body = C.text(toast, toast.Frame, C.truncate(tostring(options.Content or ""), 800), "Caption", "Secondary", { Name = "Message", Position = UDim2.fromOffset(16, 40), Size = UDim2.new(1, -32, 0, 36), TextYAlignment = Enum.TextYAlignment.Top, TextTruncate = Enum.TextTruncate.AtEnd })
		local close = C.node(toast, "TextButton", toast.Frame, { Name = "Dismiss", BackgroundTransparency = 1, Position = UDim2.new(1, -window.Target, 0, 2), Size = UDim2.fromOffset(window.Target, window.Target) })
		C.text(toast, close, "Dismiss", "Small", "Muted", { Size = UDim2.fromScale(1, 1), TextXAlignment = Enum.TextXAlignment.Center, TextWrapped = false })
		function toast:Close()
			if self.Closed then return end
			self.Closed = true
			for index, item in ipairs(window._toasts) do if item == self then table.remove(window._toasts, index); break end end
			self._scope:Destroy()
			self.Frame:Destroy()
			if window.Alive then fitToasts(window) end
		end
		toast._scope:Connect(toast.Frame.Destroying, function() toast:Close() end)
		toast._scope:Connect(close.Activated, function() toast:Close() end)
		local action
		if options.Action then
			action = C.node(toast, "TextButton", toast.Frame, { Name = "NotificationAction", Position = UDim2.new(0, 16, 1, -window.Target - 12), Size = UDim2.new(1, -32, 0, window.Target) })
			C.corner(action); C.feedback(toast, action)
			C.text(toast, action, options.Action.Text or "Open", "Caption", "Text", { Size = UDim2.new(1, -16, 1, 0), Position = UDim2.fromOffset(8, 0), TextXAlignment = Enum.TextXAlignment.Center, TextWrapped = false, TextTruncate = Enum.TextTruncate.AtEnd })
			toast._scope:Connect(action.Activated, function()
				toast:Close()
				if window.Alive then window._scope:Spawn(function() C.call(window, options.Action.Callback) end) end
			end)
		end
		window._toasts[#window._toasts + 1] = toast
		if window._PulseLauncher then window:_PulseLauncher() end
		C.reflow(toast, function()
			local width, available = window._toastHost.Size.X.Offset, window._toastHost.Size.Y.Offset
			local titleHeight = math.ceil(20 * window.TextScale)
			status.Position = UDim2.fromOffset(16, 12 + math.floor((titleHeight - 6) / 2))
			local headerHeight = math.max(titleHeight + 32, window.Target + 4)
			local actionHeight = action and window.Target + 12 or 0
			if headerHeight + actionHeight > available then actionHeight = 0 end
			local bodyHeight = body.Text == "" and 0 or math.min(120, math.max(0, available - headerHeight - actionHeight), C.measure(body.Text, 12 * window.TextScale, width - 32))
			local dismissWidth = math.max(window.Target, 64 * window.TextScale)
			title.Size = UDim2.new(1, -dismissWidth - 40, 0, titleHeight)
			body.Position = UDim2.fromOffset(16, headerHeight - 14)
			body.Size = UDim2.new(1, -32, 0, bodyHeight)
			body.Visible = bodyHeight > 0
			close.Position, close.Size = UDim2.new(1, -dismissWidth, 0, 2), UDim2.fromOffset(dismissWidth, window.Target)
			if action then
				action.Visible = actionHeight > 0
				action.Position, action.Size = UDim2.new(0, 16, 1, -window.Target - 12), UDim2.new(1, -32, 0, window.Target)
			end
			toast.Frame.Size = UDim2.new(1, 0, 0, math.min(available, headerHeight + bodyHeight + actionHeight))
			fitToasts(window)
		end)
		while #window._toasts > 3 do window._toasts[1]:Close() end
		local duration = C.number(options.Duration, 5, 0, 60)
		if duration > 0 then toast._scope:Delay(duration, function() toast:Close() end) end
		motion.reveal(toast, toast.Frame)
		return toast
	end
	return M
end
end)()

uiModules["profile"] = (function()

return function(env)
	local C = env.require("core")
	local T = env.require("theme")
	local M = {}
	local placeName, loading, listeners = nil, false, {}
	local function resolvePlace()
		if loading or placeName then return end
		loading = true

		task.defer(function()
			local ok, result = pcall(function() return env.services.MarketplaceService:GetProductInfo(game.PlaceId) end)
			if ok and type(result) == "table" and type(result.Name) == "string" and result.Name ~= "" then placeName = C.truncate(result.Name, 160) end
			loading = false
			for callback in pairs(listeners) do callback(placeName) end
		end)
	end
	function M.new(window, parent, gameName)
		local self = C.owner(window)
		local player = env.services.Players.LocalPlayer
		local username = player and player.Name or "Local player"
		local displayName = player and player.DisplayName or username
		self.Frame = C.node(self, "Frame", parent, { Name = "Profile", ClipsDescendants = true }, { BackgroundColor3 = "Sidebar" })
		local card = C.node(self, "Frame", self.Frame, { Name = "ProfileCard", Position = UDim2.fromOffset(10, 6), Size = UDim2.new(1, -20, 1, -12) }, { BackgroundColor3 = "Chrome" })
		C.corner(card, 12); C.stroke(self, card, "Subtle")
		local avatar = C.node(self, "Frame", self.Frame, { Name = "Avatar", Size = UDim2.fromOffset(T.Size.Avatar, T.Size.Avatar) }, { BackgroundColor3 = "Raised" })
		C.corner(avatar, T.Size.Avatar / 2)
		local initial = C.text(self, avatar, displayName:match("^.[\128-\191]*") or "?", "Heading", "Text", { Name = "Initial", Size = UDim2.fromScale(1, 1), TextXAlignment = Enum.TextXAlignment.Center })
		local photo = C.node(self, "ImageLabel", avatar, { Name = "Headshot", BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), ScaleType = Enum.ScaleType.Crop })
		C.corner(photo, T.Size.Avatar / 2)
		local function loaded() if self._scope.alive then initial.Visible = photo.IsLoaded ~= true end end
		self._scope:Connect(photo:GetPropertyChangedSignal("IsLoaded"), loaded)
		if player and player.UserId > 0 then
			photo.Image = string.format("rbxthumb://type=AvatarHeadShot&id=%.0f&w=150&h=150", player.UserId)
			task.defer(function()
				if not self._scope.alive then return end
				local ok, image, ready = pcall(function() return env.services.Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150) end)
				if not self._scope.alive or not photo.Parent then return end
				if ok and ready and type(image) == "string" then photo.Image = image end
				pcall(function() env.services.ContentProvider:PreloadAsync({ photo }) end)
				loaded()
			end)
		end
		local name = C.text(self, self.Frame, displayName, "Heading", "Text", { Name = "DisplayName", TextWrapped = false, TextTruncate = Enum.TextTruncate.AtEnd })
		local account = C.text(self, self.Frame, "@" .. username, "Caption", "Muted", { Name = "Username", TextWrapped = false, TextTruncate = Enum.TextTruncate.AtEnd })
		local place = C.text(self, self.Frame, gameName or placeName or "Current experience", "Caption", "Secondary", { Name = "GameName", TextWrapped = false, TextTruncate = Enum.TextTruncate.AtEnd })
		local function update(value) if self._scope.alive and value then place.Text = value end end
		if not gameName then listeners[update] = true; self._scope:Add(function() listeners[update] = nil end); resolvePlace() end
		function self.Layout(width)
			local line = math.ceil(18 * window.TextScale)
			local identityHeight = math.max(T.Size.Avatar, line * 2)
			local height = identityHeight + line + 42
			local left = 20 + T.Size.Avatar + 10
			avatar.Position = UDim2.fromOffset(20, 16)
			name.Position, name.Size = UDim2.fromOffset(left, 16), UDim2.fromOffset(math.max(1, width - left - 20), line)
			account.Position, account.Size = UDim2.fromOffset(left, 16 + line), UDim2.fromOffset(math.max(1, width - left - 20), line)
			place.Position, place.Size = UDim2.fromOffset(20, 24 + identityHeight), UDim2.fromOffset(math.max(1, width - 40), line)
			self.Frame.Size = UDim2.fromOffset(width, height)
			return height
		end
		return self
	end
	return M
end
end)()

uiModules["theme"] = (function()

return function(env)
	local rgb = Color3.fromRGB
	local M = {}
	M.Dark = {
		Canvas = rgb(23, 25, 29), Sidebar = rgb(17, 19, 22), Chrome = rgb(20, 22, 26),
		Surface = rgb(30, 33, 38), Raised = rgb(39, 43, 49), Input = rgb(22, 25, 29),
		Hover = rgb(48, 52, 59), Pressed = rgb(59, 64, 72), Track = rgb(47, 52, 61),
		Border = rgb(79, 85, 95), Subtle = rgb(46, 51, 59), Edge = rgb(61, 67, 77),
		Text = rgb(242, 243, 245), Secondary = rgb(193, 198, 207),
		Muted = rgb(153, 161, 174), Disabled = rgb(106, 113, 124),
		Accent = rgb(235, 148, 117), OnAccent = rgb(22, 24, 28),
		Primary = rgb(244, 240, 232), OnPrimary = rgb(22, 24, 28),
		Success = rgb(125, 211, 167), Warning = rgb(237, 193, 119),
		Danger = rgb(247, 145, 151), Scrim = rgb(7, 9, 12),
	}
	M.Light = {
		Canvas = rgb(246, 247, 249), Sidebar = rgb(236, 238, 242), Chrome = rgb(241, 243, 246),
		Surface = rgb(255, 255, 255), Raised = rgb(233, 236, 241), Input = rgb(246, 247, 249),
		Hover = rgb(226, 230, 237), Pressed = rgb(212, 218, 228), Track = rgb(221, 226, 234),
		Border = rgb(157, 166, 181), Subtle = rgb(221, 226, 234), Edge = rgb(203, 210, 221),
		Text = rgb(28, 33, 42), Secondary = rgb(65, 75, 91),
		Muted = rgb(98, 108, 125), Disabled = rgb(139, 148, 163),
		Accent = rgb(167, 69, 44), OnAccent = rgb(255, 255, 255),
		Primary = rgb(31, 37, 47), OnPrimary = rgb(255, 255, 255),
		Success = rgb(26, 117, 76), Warning = rgb(136, 87, 21),
		Danger = rgb(179, 49, 65), Scrim = rgb(7, 9, 12),
	}

	M.Codex = {
		Canvas = rgb(18, 18, 18), Sidebar = rgb(14, 14, 14), Chrome = rgb(21, 21, 21),
		Surface = rgb(25, 25, 25), Raised = rgb(34, 34, 34), Input = rgb(17, 17, 17),
		Hover = rgb(42, 42, 42), Pressed = rgb(51, 51, 51), Track = rgb(39, 39, 39),
		Border = rgb(72, 72, 72), Subtle = rgb(39, 39, 39), Edge = rgb(51, 51, 51),
		Text = rgb(242, 242, 242), Secondary = rgb(199, 199, 199),
		Muted = rgb(145, 145, 145), Disabled = rgb(95, 95, 95),
		Accent = rgb(186, 226, 204), OnAccent = rgb(18, 18, 18),
		Primary = rgb(241, 241, 241), OnPrimary = rgb(18, 18, 18),
		Success = rgb(145, 211, 174), Warning = rgb(219, 189, 130),
		Danger = rgb(235, 141, 141), Scrim = rgb(5, 5, 5),
	}
	M.CodexDark = M.Codex
	M.CodexLight = {
		Canvas = rgb(249, 249, 249), Sidebar = rgb(241, 241, 241), Chrome = rgb(246, 246, 246),
		Surface = rgb(255, 255, 255), Raised = rgb(235, 235, 235), Input = rgb(247, 247, 247),
		Hover = rgb(229, 229, 229), Pressed = rgb(215, 215, 215), Track = rgb(225, 225, 225),
		Border = rgb(162, 162, 162), Subtle = rgb(226, 226, 226), Edge = rgb(205, 205, 205),
		Text = rgb(25, 25, 25), Secondary = rgb(65, 65, 65), Muted = rgb(101, 101, 101), Disabled = rgb(144, 144, 144),
		Accent = rgb(35, 113, 82), OnAccent = rgb(255, 255, 255),
		Primary = rgb(26, 26, 26), OnPrimary = rgb(255, 255, 255),
		Success = rgb(27, 119, 78), Warning = rgb(130, 89, 28), Danger = rgb(177, 50, 62), Scrim = rgb(8, 8, 8),
	}
	function M.valid(name) return name == "Dark" or name == "Light" or name == "Codex" or name == "CodexDark" or name == "CodexLight" end
	function M.family(name) return name and name:match("^Codex") and "Codex" or "Classic" end
	function M.isLight(name) return name == "Light" or name == "CodexLight" end

	M.Size = {
		Target = 40, TouchTarget = 44, TouchSlop = 8, Gap = 12, Pad = 20, MobilePad = 12,
		Header = 80, Footer = 0, Sidebar = 196, Tabs = 52, Avatar = 36,
		Radius = 18, FieldRadius = 10, Scrollbar = 3,
		Width = 780, Height = 580, Compact = 640,
	}
	M.Type = { Display = 26, Title = 20, Heading = 15, Body = 14, Caption = 12, Small = 11, Eyebrow = 10 }
	M.Motion = { Fast = 0.10, Enter = 0.16, Toggle = 0.14, Press = 0.06 }
	local function linear(channel)
		if channel <= 0.04045 then return channel / 12.92 end
		return ((channel + 0.055) / 1.055) ^ 2.4
	end
	function M.resolve(name, accent)
		assert(name == nil or M.valid(name), "Theme must be Dark, Light, CodexDark or CodexLight (Codex alias supported)")
		local result = {}
		for key, value in pairs(M[name or "Dark"]) do result[key] = value end
		if accent ~= nil then
			assert(typeof(accent) == "Color3", "Accent must be a Color3")
			for _, channel in ipairs({ accent.R, accent.G, accent.B }) do
				assert(channel == channel and channel >= 0 and channel <= 1, "Accent components must be between 0 and 1")
			end
			result.Accent = accent

			local luminance = linear(accent.R) * 0.2126 + linear(accent.G) * 0.7152 + linear(accent.B) * 0.0722
			result.OnAccent = (luminance + 0.05) / 0.05 >= 1.05 / (luminance + 0.05) and rgb(0, 0, 0) or rgb(255, 255, 255)
		end
		result.Selected = result.Raised:Lerp(result.Accent, 0.16)
		result.AccentSoft = result.Surface:Lerp(result.Accent, 0.12)
		return result
	end
	return M
end
end)()

uiModules["transcript"] = (function()

return function(env)
	local C = env.require("core")
	local Controls = env.require("controls")
	local M = {}
	function M.create(section, options)
		local self = Controls.base(section, "Transcript", options, "stack")
		self.Persist = false
		self.Messages, self.Order = {}, {}
		self._slotHeight = function() return math.max(C.number(options.Height, 320, 140, 1000), self.Activity and (options.Composer and 260 or 140) or 140) end
		local scroll = C.scroll(self, self._slot, "Messages")
		scroll.Size = options.Composer and UDim2.new(1, 0, 1, -140) or UDim2.fromScale(1, 1)
		C.pad(scroll, 10, 10); C.list(scroll, false, 14)
		self.Scroll = scroll
		local strip = C.node(self, "Frame", self._slot, {Name = "ActivityStrip", Visible = false, BackgroundTransparency = 1, Position = UDim2.new(0, 0, 1, options.Composer and -194 or -58), Size = UDim2.new(1, 0, 0, 54)})
		local indicator = C.node(self, "Frame", strip, {Name = "ActivityIndicator", Position = UDim2.fromOffset(8, 8), Size = UDim2.fromOffset(3, 36)}, {BackgroundColor3 = "Accent"})
		C.corner(indicator, 2)
		local activityText = C.text(self, strip, "", "Body", "Text", {Name = "ActivityText", Position = UDim2.fromOffset(20, 4), Size = UDim2.new(1, -28, 0, 22), TextWrapped = false, TextTruncate = Enum.TextTruncate.AtEnd})
		local activityDetail = C.text(self, strip, "", "Caption", "Muted", {Name = "ActivityDetail", Position = UDim2.fromOffset(20, 29), Size = UDim2.new(1, -28, 0, 18), TextWrapped = false, TextTruncate = Enum.TextTruncate.AtEnd})
		self.ActivityFrame = strip
		function self:SetActivity(value)
			assert(value == nil or type(value) == "table", "Activity must be a table or nil")
			local changedVisibility = (self.Activity ~= nil) ~= (value ~= nil)
			self.Activity = value and C.copy(value) or nil
			strip.Visible = value ~= nil
			scroll.Size = UDim2.new(1, 0, 1, -(options.Composer and 140 or 0) - (value and 58 or 0))
			if value then
				activityText.Text = tostring(value.text or "") .. (value.pulse and string.rep(".", math.floor(C.number(value.phase, 0, 0, 3))) or "")
				activityDetail.Text = tostring(value.detail or "")
				local role = value.kind == "warning" and "Danger" or value.kind == "waiting" and "Secondary" or "Accent"
				C.bind(self, indicator, {BackgroundColor3 = role})
				indicator.BackgroundTransparency = value.pulse and (tonumber(value.phase) or 0) % 2 == 0 and 0.55 or 0
			end
			if changedVisibility then self._layout() end
			return self
		end
		if options.Composer then
			local composer = C.node(self, "Frame", self._slot, {Name = "Composer", Position = UDim2.new(0, 0, 1, -136), Size = UDim2.new(1, 0, 0, 136)}, {BackgroundColor3 = "Input"})
			C.corner(composer, 10); C.stroke(self, composer, "Border")
			local input = Controls.input(self, "TextBox", composer, {Name = "MessageInput", Text = "", PlaceholderText = "Message Codex...", ClearTextOnFocus = false, MultiLine = true, TextWrapped = true, TextYAlignment = Enum.TextYAlignment.Top, TextXAlignment = Enum.TextXAlignment.Left, Font = Enum.Font.BuilderSans, TextSize = 14, BackgroundTransparency = 1, Position = UDim2.fromOffset(10, 10), Size = UDim2.new(1, -20, 0, 64)})
			C.bind(self, input, {TextColor3 = "Text", PlaceholderColor3 = "Muted"})
			self.Input = input
			function self:GetDraft() return input.Text end
			function self:SetDraft(text) input.Text = tostring(text); return self end
			self.Actions = {}
			for index, action in ipairs({"Send", "Stop", "New Chat"}) do
				local button = Controls.input(self, "TextButton", composer, {Name = action, Text = action, Font = Enum.Font.BuilderSans, TextSize = 12, Size = UDim2.new(1 / 3, -8, 0, 44), Position = UDim2.new((index - 1) / 3, 4, 1, -50)}, {BackgroundColor3 = index == 1 and "Primary" or "Raised", TextColor3 = index == 1 and "OnPrimary" or "Text"})
				C.bind(self, button, {BackgroundColor3 = index == 1 and "Primary" or "Raised", TextColor3 = index == 1 and "OnPrimary" or "Text"})
				C.corner(button, 8); C.feedback(self, button, index == 1 and "Primary" or nil)
				self.Actions[action] = button
				self._scope:Connect(button.Activated, function()
					if not self:_Interactive() or not button.Active then return end
					local callback = action == "Send" and options.OnSend or action == "Stop" and options.OnCancel or options.OnNewChat
					C.call(self._window, callback, input.Text)
				end)
			end
			function self:SetComposerState(value)
				value = value or {}
				for action, button in pairs(self.Actions) do
					local enabled = not self.Disabled and (action == "Stop" and value.cancelable == true or action ~= "Stop" and not value.blocked)
					button.Active, button.Selectable, button.TextTransparency = enabled, enabled, enabled and 0 or 0.55
				end
				return self
			end
		end
		local function bottom()
			local size = scroll.AbsoluteCanvasSize
			scroll.CanvasPosition = Vector2.new(0, math.max(0, size.Y - scroll.AbsoluteSize.Y))
		end
		self._scope:Connect(scroll:GetPropertyChangedSignal("AbsoluteCanvasSize"), function() if self._follow then bottom() end end)
		self._scope:Connect(scroll:GetPropertyChangedSignal("CanvasPosition"), function()
			self._follow = scroll.CanvasPosition.Y + scroll.AbsoluteSize.Y >= scroll.AbsoluteCanvasSize.Y - 64
		end)
		self._follow = true
		function self:Clear()
			for _, message in pairs(self.Messages) do message.scope:Destroy(); message.frame:Destroy() end
			self.Messages, self.Order = {}, {}; return self
		end
		function self:ScrollToBottom() self._follow = true; bottom(); return self end
		function self:Sync(ids)
			local keep = {}; for _, id in ipairs(ids) do keep[id] = true end
			for id, message in pairs(self.Messages) do
				if not keep[id] then message.scope:Destroy(); message.frame:Destroy(); self.Messages[id] = nil end
			end
			self.Order = {}
			for index, id in ipairs(ids) do
				local message = self.Messages[id]
				if message then self.Order[#self.Order + 1] = id; message.frame.LayoutOrder = index end
			end
			return self
		end
		local function body(message, text, code, order)
			local owner = C.owner(self._window, message.scope)
			local frame = C.node(owner, "Frame", message.frame, { Name = code and "CodeBlock" or "Text", Size = UDim2.new(1, 0, 0, 0), LayoutOrder = order, BackgroundTransparency = code and 0 or 1 }, { BackgroundColor3 = "Input" })
			if code then C.corner(frame, 8); C.stroke(owner, frame, "Border") end
			local label = C.text(owner, frame, text, "Body", "Text", { Name = "Body", TextYAlignment = Enum.TextYAlignment.Top, TextWrapped = true, RichText = false })
			if code then label.Font = Enum.Font.Code end
			local function layout()
				local width = math.max(40, self._window._contentWidth - self._window._contentPad * 2 - 64)
				local height = C.measure(label.Text, 14 * self._window.TextScale, width - 20, label.Font)
				label.Position = UDim2.fromOffset(code and 10 or 0, code and 10 or 0)
				label.Size = UDim2.new(1, code and -20 or 0, 0, height)
				frame.Size = UDim2.new(1, 0, 0, height + (code and self._window.Target + 28 or 0))
			end
			C.reflow(owner, layout)
			if code then
				for i, action in ipairs({ "Copy", "Save", "Save As" }) do
					local button = C.node(owner, "TextButton", frame, { Name = action, Text = action, Font = Enum.Font.BuilderSans, TextSize = 12, Position = UDim2.new((i - 1) / 3, 4, 1, -self._window.Target - 4), Size = UDim2.new(1 / 3, -8, 0, self._window.Target) }, { BackgroundColor3 = "Raised", TextColor3 = "Text" })
					C.corner(button, 6); C.feedback(owner, button)
					message.scope:Connect(button.Activated, function() C.call(self._window, options.OnCodeAction, action, text, message.id) end)
				end
			end
			message.parts = message.parts or {}; message.parts[#message.parts + 1] = {frame = frame, scope = owner._scope}
			return label, layout, owner._scope
		end
		function self:Upsert(id, role, text, complete)
			assert(type(id) == "string" and type(text) == "string", "Transcript id/text must be strings")
			local message = self.Messages[id]
			if not message then
				if #self.Order >= 200 then local old = table.remove(self.Order, 1); self.Messages[old].scope:Destroy(); self.Messages[old].frame:Destroy(); self.Messages[old] = nil end
				message = { id = id, scope = C.scope(self._scope) }
				local owner = { _window = self._window, _scope = message.scope }
				message.frame = C.node(owner, "Frame", scroll, { Name = "Message", BackgroundTransparency = 1, Size = UDim2.new(1, -4, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, LayoutOrder = #self.Order + 1 })
				C.list(message.frame, false, 6)
				C.text(owner, message.frame, tostring(role), "Caption", "Accent", { Size = UDim2.new(1, 0, 0, 20), LayoutOrder = 0 })
				message.label, message.layout, message.bodyScope = body(message, "", false, 1)
				self.Messages[id] = message; self.Order[#self.Order + 1] = id
			end
			if message.text == text and message.complete == complete then return self end
			message.text = text; message.complete = complete
			if message.parsed or complete and text:find("```", 1, true) then
				for _, part in ipairs(message.parts or {}) do part.scope:Destroy(); part.frame:Destroy() end
				message.parts = {}; message.parsed = true
				local pos, order = 1, 1
				while pos <= #text do
					local a, b, language, code = text:find("```([%w_]*)[^\n]*\n(.-)```", pos)
					if not a then body(message, text:sub(pos), false, order); break end
					if a > pos then body(message, text:sub(pos, a - 1), false, order); order = order + 1 end
					body(message, code, true, order); order = order + 1; pos = b + 1
				end
			elseif not message.parsed then message.label.Text = text; message.layout() end
			if self._follow then self._scope:Delay(0, bottom) end
			return self
		end
		self._layout(); return self
	end
	return M
end
end)()

uiModules["window"] = (function()
return function(env)
	local C = env.require("core")
	local T = env.require("theme")
	local motion = env.require("motion")
	local Window = {}
	Window.__index = Window
	local function parentScreen(screen, requested)
		if requested then
			assert(typeof(requested) == "Instance", "Parent must be a Roblox instance")
			screen.Parent = requested
			return
		end
		if type(gethui) == "function" then
			local ok, parent = pcall(gethui)
			if ok and parent and pcall(function() screen.Parent = parent end) then return end
		end
		if pcall(function() screen.Parent = env.services.CoreGui end) then return end
		local player = env.services.Players.LocalPlayer
		assert(player, "UI LIB requires a local player or an explicit Parent")
		screen.Parent = player:FindFirstChildOfClass("PlayerGui") or player:WaitForChild("PlayerGui", 10)
		assert(screen.Parent, "UI LIB could not find PlayerGui")
	end
	function Window:Give(resource) return self._scope:Add(resource) end
	function Window:Defer(seconds, callback)
		assert(C.finite(seconds) and seconds >= 0 and type(callback) == "function", "Defer expects seconds and callback")
		return self._scope:Delay(seconds, callback)
	end
	function Window:GetGeometry()
		return {width = self._requestedWidth, height = self._requestedHeight, x = self.Frame.Position.X.Offset, y = self.Frame.Position.Y.Offset}
	end
	function Window:SetGeometry(value)
		assert(type(value) == "table", "Geometry must be a table")
		self._requestedWidth = C.number(value.width, self._requestedWidth, 280, 1600)
		self._requestedHeight = C.number(value.height, self._requestedHeight, 240, 1200)
		if C.finite(value.x) and C.finite(value.y) then self._position = Vector2.new(value.x, value.y) end
		self:_Layout(); return self
	end
	function Window:OnDestroy(callback) return self:Give(callback) end
	function Window:Get(id) return self.Controls[id] end
	function Window:Tab(options) return env.require("containers").tab(self, options) end
	function Window:Notify(options) return env.require("overlays").notify(self, options) end
	function Window:Dialog(options) return env.require("overlays").dialog(self, options) end
	function Window:Confirm(options)
		options = options or {}
		return self:Dialog({
			Title = options.Title or C.translate(self, "Confirm action"), Content = options.Content,
			Buttons = {
				{ Text = options.CancelText or C.translate(self, "Cancel") },
				{ Text = options.ConfirmText or C.translate(self, "Confirm"), Style = options.Danger and "Danger" or "Primary", Callback = options.Callback },
			},
		})
	end
	function Window:_CloseOverlay()
		if self._overlay then self._overlay:Close() end
	end
	function Window:_Refresh(animated)
		if not self.Alive then return end
		if not animated then motion.stopAll(self, true) end
		for binding in pairs(self._paint) do
			if binding.node.Parent then
				local goals = {}
				for key, value in pairs(binding.properties) do
					local resolved
					if type(value) == "function" then resolved = value(self.Theme) else resolved = self.Theme[value] end
					if animated and (key:find("Color", 1, true) or key:find("Transparency", 1, true)) then goals[key] = resolved
					else binding.node[key] = resolved end
				end
				if next(goals) then motion.to(binding.owner, binding.node, goals) end
			end
		end
	end
	function Window:SetReducedMotion(value)
		assert(type(value) == "boolean", "ReducedMotion must be a boolean")
		self._motionOverride, self.ReducedMotion = value, value
		motion.stopAll(self, true)
		return self
	end
	function Window:SetTheme(name, accent)
		self.Theme = T.resolve(name, accent)
		self._themeName, self._accent = name or "Dark", accent
		self._themeFamily = T.family(self._themeName)
		if self._themeLabel then self._themeLabel.Text = C.translate(self, T.isLight(self._themeName) and "Dark mode" or "Light mode") end
		self:_Refresh()
		return self
	end
	function Window:GetTheme() return self._themeName, self._accent end
	function Window:ToggleTheme()
		local family = self._themeFamily or T.family(self._themeName)
		local nextName = T.isLight(self._themeName) and "Dark" or "Light"
		if family == "Codex" then nextName = "Codex" .. nextName end
		return self:SetTheme(nextName, self._accent)
	end
	function Window:SetTextScale(value)
		assert(C.finite(value), "TextScale must be a finite number")
		self.TextScale = C.clamp(value, 0.85, 1.5)
		self:_Refresh()
		self:_Layout()
		return self
	end
	function Window:SetTitle(title, subtitle)
		assert(self.Alive, "Window is destroyed")
		self.Title = tostring(title)
		self._title.Text, self._launcherTitle.Text = self.Title, self.Title
		if subtitle ~= nil then
			self._subtitle.Text = tostring(subtitle)
			self._launcherDetail.Text = self._subtitle.Text ~= "" and self._subtitle.Text or C.translate(self, "Minimized")
		end
		self:_Layout()
		return self
	end
	function Window:_ReleaseKeys()
		for binding in pairs(self._keys) do if binding.release then binding.release() end end
	end
	function Window:_CancelCapture()
		if self._captureControl then self._captureControl:_CancelInteraction() end
		self._capture, self._captureControl = nil, nil
	end
	function Window:Show()
		if not self.Alive or self.Visible then return self end
		motion.stopAll(self, true)
		self.Visible = true
		self.Frame.Visible, self._launcher.Visible = true, false
		self._launcherDetail.Text = self._subtitle.Text ~= "" and self._subtitle.Text or C.translate(self, "Minimized")
		self:_Layout()
		motion.reveal(self, self.Frame)
		return self
	end
	function Window:Hide()
		if not self.Alive then return self end
		C.releaseFocus(self)
		self:_CloseOverlay()
		self:_CancelCapture()
		self:_ReleaseKeys()
		C.cancelGesture(self)
		for release in pairs(self._presses) do release() end
		motion.stopAll(self, true)
		self.Visible = false
		self.Frame.Visible, self._launcher.Visible = false, false
		pcall(function()
			local selected = env.services.GuiService.SelectedObject
			if selected and selected:IsDescendantOf(self.ScreenGui) then env.services.GuiService.SelectedObject = nil end
		end)
		return self
	end
	function Window:_PopLauncher()
		motion.reveal(self, self._launcher)
	end

	function Window:_PulseLauncher()
		if not self._launcher.Visible then return end
		self._launcherDetail.Text = C.translate(self, "New notification")
		self._launcherStroke.Color = self.Theme.Accent
		motion.to(self, self._launcherStroke, { Color = self._launcherHovered and self.Theme.Accent or self.Theme.Border }, T.Motion.Enter)
	end
	function Window:Minimize()
		if not self.Alive or not self.Visible then return self end
		self:Hide()
		if self.Alive then
			self._launcher.Visible = true
			self:_PopLauncher()
		end
		return self
	end
	function Window:Toggle()
		if self.Visible then return self:Minimize() end
		return self:Show()
	end
	function Window:Destroy()
		if not self.Alive then return end
		C.releaseFocus(self)
		self:_CloseOverlay()
		self:_CancelCapture()
		self:_ReleaseKeys()
		motion.stopAll(self, true)
		self.Alive, self.Visible = false, false
		C.cancelGesture(self)
		self._capture = nil
		if env.windows[self.Id] == self then env.windows[self.Id] = nil end
		self._scope:Destroy()
		self.ScreenGui:Destroy()
		self.Controls, self.Tabs, self._toasts = {}, {}, {}
	end
	function Window:SelectTab(target)
		local tab = target
		if type(target) == "string" then
			tab = nil
			for _, candidate in ipairs(self.Tabs) do
				if candidate.Id == target then tab = candidate; break end
			end
		end
		assert(tab and tab._window == self and tab.Alive, "Unknown tab")
		if not tab.Visible then return self end
		if self._activeTab == tab then return self end
		local previous = self._activeTab
		if previous then C.releaseFocus(self, previous.Frame) end
		self:_CloseOverlay()
		self:_CancelCapture()
		self:_ReleaseKeys()
		C.cancelGesture(self)
		self._activeTab = tab
		for _, candidate in ipairs(self.Tabs) do candidate.Frame.Visible = candidate == tab and candidate.Visible end
		if previous then previous._refresh() end
		tab._refresh()
		self:_Filter()
		if previous then motion.reveal(self, self._content, self.Theme.Canvas, 14) end
		return self
	end
	function Window:_Filter()
		local query = string.lower(self._search and self._search.Text or "")
		local count = 0
		for _, tab in ipairs(self.Tabs) do
			local tabCount, sectionCount = 0, 0
			for _, section in ipairs(tab.Sections) do
				local matches = 0
				for _, control in ipairs(section.Controls) do
					local haystack = string.lower(control.Text .. " " .. control.Description .. " " .. section.Title)
					local visible = control.Visible and (query == "" or haystack:find(query, 1, true) ~= nil)
					control.Frame.Visible = visible
					if visible then matches = matches + 1 end
				end
				section.Frame.Visible = section.Visible and (matches > 0 or query == "")
				section._body.Visible = not section.Collapsed or query ~= ""
				if section.Visible then
					tabCount = tabCount + matches
					if section.Frame.Visible then sectionCount = sectionCount + 1 end
				end
			end
			if tab == self._activeTab then count = tabCount end
			if tab._summary then
				tab._intro.Visible = query == "" or tabCount > 0
				tab._summary.Text = query ~= "" and string.format("%d matching control%s", tabCount, tabCount == 1 and "" or "s")
					or string.format("%d control%s  /  %d section%s", tabCount, tabCount == 1 and "" or "s", sectionCount, sectionCount == 1 and "" or "s")
				if self.Locale == "ko" then tab._summary.Text = query ~= "" and (tostring(tabCount) .. "개 검색됨") or (tostring(tabCount) .. "개 항목 / " .. tostring(sectionCount) .. "개 영역") end
			end
		end
		self._empty.Visible = query ~= "" and count == 0
	end
	function Window:_RevealFocused()
		local focused = env.services.UserInputService:GetFocusedTextBox()
		if not focused or not focused:IsDescendantOf(self.ScreenGui) then return end
		local ancestor = focused.Parent
		while ancestor and ancestor ~= self.ScreenGui do
			if ancestor:IsA("ScrollingFrame") then
				local top = focused.AbsolutePosition.Y - ancestor.AbsolutePosition.Y
				local bottom = top + focused.AbsoluteSize.Y
				local height = ancestor.AbsoluteSize.Y
				local y = ancestor.CanvasPosition.Y
				if focused.AbsoluteSize.Y > height - 16 then

					local lineTop = 0
					if focused.MultiLine and focused.CursorPosition > 0 then
						local before = focused.Text:sub(1, focused.CursorPosition - 1)
						lineTop = math.max(0, C.measure(before, focused.TextSize, focused.AbsoluteSize.X - 24) - focused.TextSize) + 10
					end
					local lineBottom = top + lineTop + focused.TextSize + 8
					if top + lineTop < 8 then y = y + top + lineTop - 8
					elseif lineBottom > height - 8 then y = y + lineBottom - height + 8 end
				elseif top < 8 then y = y + top - 8
				elseif bottom > height - 8 then y = y + bottom - height + 8 end
				ancestor.CanvasPosition = Vector2.new(ancestor.CanvasPosition.X, math.max(0, y))
			end
			ancestor = ancestor.Parent
		end
	end
	function Window:_Layout()
		if not self.Alive then return end
		local uis = env.services.UserInputService
		self.Touch = uis.TouchEnabled == true
		self.Target = math.max(self.Touch and T.Size.TouchTarget or T.Size.Target, math.ceil(36 * self.TextScale))
		local size, origin = self._viewport.AbsoluteSize, self._viewport.AbsolutePosition
		if size.X < 1 or size.Y < 1 then
			local camera = env.services.Workspace.CurrentCamera
			size = camera and camera.ViewportSize or Vector2.new(800, 600)
		end
		local availableHeight, keyboardVisible = size.Y, false
		pcall(function()
			if uis.OnScreenKeyboardVisible then
				keyboardVisible = true
				local keyboard = uis.OnScreenKeyboardSize
				local top = uis.OnScreenKeyboardPosition.Y
				availableHeight = top > 0 and math.min(size.Y, top - origin.Y) or size.Y - keyboard.Y
			end
		end)
		availableHeight = math.max(1, availableHeight)
		local margin = math.min(self.Touch and 8 or 16, size.X / 10, availableHeight / 10)
		local width = math.max(1, math.min(self._requestedWidth, size.X - margin * 2))
		local height = math.max(1, math.min(self._requestedHeight, availableHeight - margin * 2))
		if self.Touch and width < T.Size.Compact and self._autoHeight then height = math.max(1, availableHeight - margin * 2) end
		local x = self._position and self._position.X or (size.X - width) / 2
		local y = self._position and self._position.Y or (availableHeight - height) / 2
		x = C.clamp(x, margin, math.max(margin, size.X - width - margin))
		y = C.clamp(y, margin, math.max(margin, availableHeight - height - margin))
		self._rect = { x = margin, y = margin, width = math.max(1, size.X - margin * 2), height = math.max(1, availableHeight - margin * 2) }
		if self.Touch and (self._width ~= width or self._height ~= height) then C.cancelGesture(self) end
		self._width, self._height = width, height
		local short = height < (self.Touch and 440 or 380)
		self._compact = width < T.Size.Compact or short
		self._contentPad = self.Touch and self._compact and T.Size.MobilePad or T.Size.Pad
		local titleHeight = math.ceil(26 * self.TextScale)
		local subtitleHeight = math.ceil(18 * self.TextScale)
		local header = short and math.max(52, self.Target + 8) or math.max(T.Size.Header, 14 + titleHeight + 3 + subtitleHeight + 12)
		local nav = self._compact and math.max(T.Size.Tabs, self.Target + 8) or 0
		local sidebar = self._compact and 0 or math.floor(T.Size.Sidebar * math.min(1.28, self.TextScale))
		local railHeading = self._compact and 0 or 32
		local searchFocused = self._search and uis:GetFocusedTextBox() == self._search
		local searchVisible = self._search and (searchFocused or (height >= 300 and not (self.Touch and keyboardVisible)))
		local search = searchVisible and self.Target + 12 or 0
		local footer = T.Size.Footer
		local themeHeight = self._themeToggle and not self._compact and (self.Target + 12) or 0
		local themeWidth = self._themeToggle and math.max(96, math.ceil(78 * self.TextScale + 20)) or 0
		if self._compact and height < 240 then nav = 0 end
		if height < header + footer + self.Target then header = 0 end
		self.Frame.Size = UDim2.fromOffset(math.floor(width), math.floor(height))
		self.Frame.Position = UDim2.fromOffset(math.floor(x), math.floor(y))
		self._header.Size = UDim2.new(1, 0, 0, header)
		self._header.Visible = header > 0
		local titleInset = 20
		self._title.Position = UDim2.fromOffset(titleInset, short and 12 or 14)
		self._title.Size = UDim2.new(1, -(titleInset + self.Target * 2 + 32), 0, titleHeight)
		self._subtitle.Visible = not short and self._subtitle.Text ~= ""
		self._subtitle.Position = UDim2.fromOffset(titleInset, 17 + titleHeight)
		self._subtitle.Size = UDim2.new(1, -(titleInset + self.Target * 2 + 32), 0, subtitleHeight)
		self._headerActions.Position = UDim2.new(1, -self.Target * 2 - 20, 0, (header - self.Target) / 2)
		self._headerActions.Size = UDim2.fromOffset(self.Target * 2 + 4, self.Target)
		self._minimize.Size, self._close.Size = UDim2.fromOffset(self.Target, self.Target), UDim2.fromOffset(self.Target, self.Target)
		local profileHeight = 0
		if self._profile then
			profileHeight = self._profile.Layout(sidebar)
			self._profile.Frame.Visible = not self._compact
			self._profile.Frame.Position = UDim2.new(0, 0, 1, -footer - profileHeight)
			if self._compact then profileHeight = 0 end
		end
		self._rail.Position = UDim2.fromOffset(0, header)
		self._rail.Size = UDim2.fromOffset(sidebar, math.max(0, height - header - footer))
		self._rail.Visible = not self._compact
		self._navCaption.Position = UDim2.fromOffset(20, header + 12)
		self._navCaption.Size = UDim2.fromOffset(math.max(0, sidebar - 40), 14 * self.TextScale)
		self._navCaption.Visible = not self._compact
		self._nav.Position = UDim2.fromOffset(0, header + railHeading)
		self._nav.Visible = not self._compact or nav > 0
		self._nav.Size = self._compact and UDim2.new(1, self._themeToggle and -themeWidth - 12 or 0, 0, nav)
			or UDim2.new(0, sidebar, 1, -header - railHeading - footer - profileHeight - themeHeight)
		if self._themeToggle then
			self._themeToggle.Visible = not self._compact or nav > 0
			self._themeToggle.Size = UDim2.fromOffset(self._compact and themeWidth or sidebar - 24, self.Target)
			self._themeToggle.Position = self._compact and UDim2.new(1, -themeWidth - 12, 0, header + 4)
				or UDim2.new(0, 12, 1, -footer - profileHeight - themeHeight)
		end
		self._navLayout.FillDirection = self._compact and Enum.FillDirection.Horizontal or Enum.FillDirection.Vertical
		self._nav.ScrollingDirection = self._compact and Enum.ScrollingDirection.X or Enum.ScrollingDirection.Y
		self._nav.AutomaticCanvasSize = self._compact and Enum.AutomaticSize.X or Enum.AutomaticSize.Y
		self._nav.ScrollBarThickness = self._compact and 0 or T.Size.Scrollbar
		self._navPad.PaddingTop = UDim.new(0, self._compact and 4 or 10)
		for _, tab in ipairs(self.Tabs) do
			local tabWidth = self._compact and math.max(80, math.min(220, #tab.Title * 8 * self.TextScale + 28)) or sidebar - 24
			tab._button.Size = UDim2.fromOffset(tabWidth, self.Target)
		end
		local top = header + nav
		local inset = self._compact and 6 or 10
		self._contentWidth = math.max(1, width - sidebar - inset * 2)
		self._workspace.Position = UDim2.fromOffset(sidebar + inset, top + 6)
		self._workspace.Size = UDim2.fromOffset(self._contentWidth, math.max(0, height - top - footer - 12))
		self._content.Position = UDim2.fromOffset(sidebar + inset, top + 6 + search)
		self._content.Size = UDim2.fromOffset(self._contentWidth, math.max(0, height - top - search - footer - 12))
		if self._search then
			self._search.Visible = searchVisible == true
			self._search.Position = UDim2.fromOffset(sidebar + inset + self._contentPad, top + 14)
			self._search.Size = UDim2.fromOffset(math.max(1, self._contentWidth - self._contentPad * 2), self.Target)
		end
		self._resize.Visible = not self.Touch

		local launcherTitle = math.ceil(15 * self.TextScale)
		local launcherDetail = math.ceil(12 * self.TextScale)
		local launcherBody = launcherTitle + launcherDetail + 16
		local launcherHeight = launcherBody + T.Size.Footer
		local launcherWidth = math.min(264, size.X - margin * 2)
		local placeX = self._launcherPosition and self._launcherPosition.X or margin
		local placeY = self._launcherPosition and self._launcherPosition.Y or (availableHeight - launcherHeight - margin)
		placeX = C.clamp(placeX, margin, math.max(margin, size.X - launcherWidth - margin))
		placeY = C.clamp(placeY, margin, math.max(margin, availableHeight - launcherHeight - margin))
		self._launcher.Position = UDim2.fromOffset(math.floor(placeX), math.floor(placeY))
		self._launcher.Size = UDim2.fromOffset(math.floor(launcherWidth), math.floor(launcherHeight))
		local launcherText = 14
		local launcherTop = math.max(4, math.floor((launcherBody - launcherTitle - launcherDetail) / 2))
		self._launcherTitle.Position = UDim2.fromOffset(launcherText, launcherTop)
		self._launcherTitle.Size = UDim2.new(1, -(launcherText + 64), 0, launcherTitle)
		self._launcherDetail.Position = UDim2.fromOffset(launcherText, launcherTop + launcherTitle + 2)
		self._launcherDetail.Size = UDim2.new(1, -(launcherText + 64), 0, launcherDetail)
		self._launcherHint.Position = UDim2.new(1, -12, 0, math.floor(launcherBody / 2))
		self._toastHost.Position = UDim2.new(1, -margin, 1, -margin - (size.Y - availableHeight))
		self._toastHost.Size = UDim2.fromOffset(math.min(360, size.X - margin * 2), math.max(1, availableHeight - margin * 2))
		for callback in pairs(self._reflow) do callback() end
	end
	function Window:_Move(frame, position)
		local rect = self._rect
		local width, height = frame.Size.X.Offset, frame.Size.Y.Offset
		frame.Position = UDim2.fromOffset(math.floor(C.clamp(position.X, rect.x, math.max(rect.x, rect.x + rect.width - width))),
			math.floor(C.clamp(position.Y, rect.y, math.max(rect.y, rect.y + rect.height - height))))
	end
	function Window.new(options)
		options = options or {}
		local id = options.Id or options.Title or "billiards"
		assert(type(id) == "string" and #id > 0 and #id <= 100, "Window Id must contain 1-100 characters")
		local theme = T.resolve(options.Theme, options.Accent)
		if options.Parent ~= nil then assert(typeof(options.Parent) == "Instance", "Parent must be a Roblox instance") end
		if options.ToggleKey ~= nil and options.ToggleKey ~= false then
			assert(typeof(options.ToggleKey) == "EnumItem" and tostring(options.ToggleKey):find("Enum.KeyCode.", 1, true) == 1, "ToggleKey must be an Enum.KeyCode or false")
		end
		assert(options.ReducedMotion == nil or type(options.ReducedMotion) == "boolean", "ReducedMotion must be a boolean")
		assert(options.ThemeToggle == nil or type(options.ThemeToggle) == "boolean", "ThemeToggle must be a boolean")
		assert(options.Locale == nil or options.Locale == "ko" or options.Locale == "en", "Locale must be ko or en")
		assert(options.GameName == nil or type(options.GameName) == "string", "GameName must be a string")
		local toggleKey = options.ToggleKey
		if toggleKey == nil then toggleKey = Enum.KeyCode.RightShift end
		if env.windows[id] then env.windows[id]:Destroy() end
		local self = setmetatable({
			Id = id, Title = tostring(options.Title or "당구 도우미"), Alive = true, Visible = true,
			Locale = options.Locale or (T.family(options.Theme) == "Codex" and "ko" or "en"),
			Theme = theme, TextScale = C.number(options.TextScale, 1, 0.85, 1.5),
			_themeName = options.Theme or "Dark", _themeFamily = T.family(options.Theme), _accent = options.Accent,
			_scope = C.scope(), _paint = {}, _paintNodes = {}, _reflow = {}, _keys = {}, _motions = {}, _presses = {}, Controls = {}, Tabs = {}, _toasts = {},
			ReducedMotion = options.ReducedMotion == true, _motionOverride = options.ReducedMotion,
			_requestedWidth = C.number(options.Width, T.Size.Width, 280, 1600),
			_requestedHeight = C.number(options.Height, T.Size.Height, 240, 1200),
			_autoHeight = options.Height == nil,
			ToggleKey = toggleKey,
		}, Window)
		self._window = self
		self.ScreenGui = Instance.new("ScreenGui")
		self.ScreenGui.Name = "Billiards_UI_" .. id
		self.ScreenGui.ResetOnSpawn = false
		self.ScreenGui.IgnoreGuiInset = false
		self.ScreenGui.DisplayOrder = C.number(options.DisplayOrder, 80, 0, 10000)
		self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		pcall(function() self.ScreenGui.ScreenInsets = Enum.ScreenInsets.CoreUISafeInsets end)
		local ok, why = pcall(parentScreen, self.ScreenGui, options.Parent)
		if not ok then self.ScreenGui:Destroy(); error(why, 0) end
		self._viewport = C.node(self, "Frame", self.ScreenGui, { Name = "SafeViewport", BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1) })
		self.Frame = C.node(self, "Frame", self._viewport, { Name = "Window", Active = true, ClipsDescendants = true }, { BackgroundColor3 = "Chrome" })
		C.corner(self.Frame, T.Size.Radius)
		C.stroke(self, self.Frame, "Edge")
		self._header = C.node(self, "Frame", self.Frame, { Name = "Header", BackgroundTransparency = 1, Active = true })
		self._title = C.text(self, self._header, self.Title, "Title", "Text", { TextWrapped = false, TextTruncate = Enum.TextTruncate.AtEnd })
		self._subtitle = C.text(self, self._header, options.Subtitle or "", "Caption", "Muted", { TextWrapped = false, TextTruncate = Enum.TextTruncate.AtEnd })
		self._headerActions = C.node(self, "Frame", self._header, { BackgroundTransparency = 1 })
		C.list(self._headerActions, true, 4)

		local function headerButton(name, icon, callback, tone)
			local button = C.node(self, "TextButton", self._headerActions, { Name = name, BackgroundTransparency = 1 })
			C.corner(button)
			local hovered, selected = false, false
			local function glyphColor(theme)
				if selected then return theme.Text end
				if hovered then return (tone == "Danger") and theme.Danger or theme.Text end
				return theme.Muted
			end
			local glyph = C.icon(self, button, icon, glyphColor)
			glyph.AnchorPoint, glyph.Position = Vector2.new(0.5, 0.5), UDim2.fromScale(0.5, 0.5)
			local focus = C.stroke(self, button, "Accent"); focus.Transparency = 1
			local function repaint()
				local color = glyphColor(self.Theme)
				for _, line in ipairs(glyph:GetChildren()) do
					if line:IsA("Frame") then motion.to(self, line, { BackgroundColor3 = color }) end
				end
				motion.to(self, focus, { Transparency = selected and 0 or 1 })
			end
			self._scope:Connect(button.MouseEnter, function() hovered = true; repaint() end)
			self._scope:Connect(button.MouseLeave, function() hovered = false; repaint() end)
			self._scope:Connect(button.SelectionGained, function() selected = true; repaint() end)
			self._scope:Connect(button.SelectionLost, function() selected = false; repaint() end)
			self._scope:Connect(button.Activated, callback)
			return button
		end
		self._minimize = headerButton("Minimize", "minus", function() self:Minimize() end)
		self._close = headerButton("Close", "close", function() if options.CloseBehavior == "Minimize" then self:Minimize() else self:Destroy() end end, "Danger")
		self._rail = C.node(self, "Frame", self.Frame, { Name = "NavigationRail" }, { BackgroundColor3 = "Sidebar" })
		self._navCaption = C.text(self, self.Frame, "NAVIGATION", "Eyebrow", "Muted", { TextWrapped = false })
		self._nav = C.scroll(self, self.Frame, "Tabs")
		C.bind(self, self._nav, { BackgroundColor3 = "Sidebar" })
		self._nav.BackgroundTransparency = 0
		self._navLayout = C.list(self._nav, false, 6)
		self._navPad = C.pad(self._nav, 12, 14)
		if options.ThemeToggle ~= false then
			self._themeToggle = C.node(self, "TextButton", self.Frame, { Name = "ThemeToggle" })
			C.corner(self._themeToggle)
			C.feedback(self, self._themeToggle)
			self._themeLabel = C.text(self, self._themeToggle, T.isLight(self._themeName) and "Dark mode" or "Light mode", "Body", "Text", {
				Name = "ThemeLabel", Position = UDim2.fromOffset(8, 0), Size = UDim2.new(1, -16, 1, 0),
				TextWrapped = false, TextXAlignment = Enum.TextXAlignment.Center,
			})
			self._scope:Connect(self._themeToggle.Activated, function() self:ToggleTheme() end)
		end
		self._profile = env.require("profile").new(self, self.Frame, options.GameName)
		self._workspace = C.node(self, "Frame", self.Frame, { Name = "Workspace", Active = false }, { BackgroundColor3 = "Canvas" })
		C.corner(self._workspace, 14); C.stroke(self, self._workspace, "Subtle")
		self._content = C.node(self, "Frame", self.Frame, { Name = "Content", BackgroundTransparency = 1, ClipsDescendants = true })
		self._empty = C.text(self, self._content, "No matching controls", "Body", "Muted", { Name = "EmptySearch", Visible = false, Position = UDim2.fromOffset(20, 28), Size = UDim2.new(1, -40, 0, 40) })
		if options.Search ~= false then
			self._search = C.node(self, "TextBox", self.Frame, {
				Name = "Search", Text = "", PlaceholderText = "Search this tab", ClearTextOnFocus = false,
				Font = C.Font, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left,
			}, { BackgroundColor3 = "Input", TextColor3 = "Text", PlaceholderColor3 = "Muted", TextSize = function() return math.floor(14 * self.TextScale + 0.5) end })
			C.corner(self._search); C.pad(self._search, 14, 0)
			C.fieldBorder(self, self._search)
			self._scope:Connect(self._search:GetPropertyChangedSignal("Text"), function()
				self:_Filter()
				if self._activeTab then self._activeTab.Frame.CanvasPosition = Vector2.new(0, 0) end
			end)
		end
		self._resize = C.node(self, "TextButton", self.Frame, {
			Name = "Resize", BackgroundTransparency = 1, AnchorPoint = Vector2.new(1, 1), Position = UDim2.fromScale(1, 1),
			Size = UDim2.fromOffset(24, 24), Selectable = false,
		})
		for index = 1, 3 do
			C.node(self, "Frame", self._resize, { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset(7 + index * 3, 16), Size = UDim2.fromOffset(2, 2 + index * 3), Rotation = 45 }, { BackgroundColor3 = "Muted" })
		end

		self._launcher = C.node(self, "TextButton", self._viewport, { Name = "Restore", Visible = false, ClipsDescendants = true }, { BackgroundColor3 = "Canvas" })
		C.corner(self._launcher, T.Size.Radius)
		local launcherDragged = false
		C.bind(self, self._launcher, {
			BackgroundColor3 = function(theme) return self._launcherHovered and theme.Hover or theme.Canvas end,
		})
		self._launcherStroke = C.stroke(self, self._launcher)
		C.bind(self, self._launcherStroke, {
			Color = function(theme) return self._launcherHovered and theme.Accent or theme.Border end,
		})
		self._launcherTitle = C.text(self, self._launcher, self.Title, "Heading", "Text", { Name = "RestoreTitle", Position = UDim2.fromOffset(44, 6), Size = UDim2.new(1, -84, 0, 20), TextWrapped = false, TextTruncate = Enum.TextTruncate.AtEnd })
		self._launcherDetail = C.text(self, self._launcher, self._subtitle.Text ~= "" and self._subtitle.Text or C.translate(self, "Minimized"), "Caption", "Muted", { Name = "RestoreDetail", Position = UDim2.fromOffset(44, 26), Size = UDim2.new(1, -84, 0, 16), TextWrapped = false, TextTruncate = Enum.TextTruncate.AtEnd })
		self._launcherHint = C.text(self, self._launcher, "Open", "Caption", "Secondary", { Size = UDim2.fromOffset(44, 24), TextXAlignment = Enum.TextXAlignment.Right })
		self._launcherHint.AnchorPoint = Vector2.new(1, 0.5)
		local function hoverLauncher(value)
			self._launcherHovered = value
			motion.to(self, self._launcher, { BackgroundColor3 = value and self.Theme.Hover or self.Theme.Canvas })
			motion.to(self, self._launcherStroke, { Color = value and self.Theme.Accent or self.Theme.Border })
		end
		self._scope:Connect(self._launcher.MouseEnter, function() hoverLauncher(true) end)
		self._scope:Connect(self._launcher.MouseLeave, function() hoverLauncher(false) end)

		self._scope:Connect(self._launcher.Activated, function()
			if launcherDragged then launcherDragged = false; return end
			self:Show()
		end)
		self._toastHost = C.node(self, "Frame", self._viewport, { Name = "Notifications", AnchorPoint = Vector2.new(1, 1), BackgroundTransparency = 1, ClipsDescendants = true, ZIndex = 200 })
		local toastLayout = C.list(self._toastHost, false, 8)
		toastLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
		self:_Layout()

		local dragStart, frameStart, sizeStart
		C.pointer(self, self._header, function(input)
			if C.isInside(self._headerActions, input.Position.X, input.Position.Y) then return false end
			dragStart, frameStart = input.Position, self.Frame.Position
		end, function(input)
			self._position = Vector2.new(frameStart.X.Offset + input.Position.X - dragStart.X, frameStart.Y.Offset + input.Position.Y - dragStart.Y)
			self:_Move(self.Frame, self._position)
		end)
		C.pointer(self, self._resize, function(input)
			dragStart, sizeStart = input.Position, self.Frame.AbsoluteSize
			self._position = Vector2.new(self.Frame.Position.X.Offset, self.Frame.Position.Y.Offset)
		end, function(input)
			self._requestedWidth = math.max(280, sizeStart.X + input.Position.X - dragStart.X)
			self._requestedHeight = math.max(240, sizeStart.Y + input.Position.Y - dragStart.Y)
			self:_Layout()
		end)
		local launcherOrigin, launcherStart
		C.pointer(self, self._launcher, function(input)
			launcherDragged = false
			launcherOrigin, launcherStart = input.Position, self._launcher.Position
			return true
		end, function(input)
			if not launcherStart then return end
			local delta = input.Position - launcherOrigin
			if math.abs(delta.X) > 4 or math.abs(delta.Y) > 4 then launcherDragged = true end
			if not launcherDragged then return end
			self._launcherPosition = Vector2.new(launcherStart.X.Offset + delta.X, launcherStart.Y.Offset + delta.Y)
			self:_Move(self._launcher, self._launcherPosition)
		end, function()
			launcherOrigin, launcherStart = nil, nil
		end)
		local uis = env.services.UserInputService
		self._scope:Connect(uis.InputChanged, function(input)
			local gesture = self._gesture
			if not gesture then return end
			local touch = gesture.input.UserInputType == Enum.UserInputType.Touch
			if (touch and input == gesture.input) or (not touch and input.UserInputType == Enum.UserInputType.MouseMovement) then
				if gesture.owner._scope.alive and gesture.move then gesture.move(input) end
			end
		end)
		self._scope:Connect(uis.InputEnded, function(input)
			for release in pairs(self._presses) do release() end
			local gesture = self._gesture
			if gesture then
				local touch = gesture.input.UserInputType == Enum.UserInputType.Touch
				if (touch and input == gesture.input) or (not touch and input.UserInputType == Enum.UserInputType.MouseButton1) then
					if input.UserInputState ~= Enum.UserInputState.Cancel and gesture.owner._scope.alive and gesture.finish then gesture.finish(input) end
					if self._gesture == gesture then C.cancelGesture(self) end
				end
			end
			for binding in pairs(self._keys) do if binding.ended then binding.ended(input) end end
		end)
		self._scope:Connect(uis.InputBegan, function(input, processed)
			if self._capture then self._capture(input); return end
			if self._overlay and (input.KeyCode == Enum.KeyCode.Escape or input.KeyCode == Enum.KeyCode.ButtonB) then
				if self._overlay.Dismissible then self:_CloseOverlay() end
				return
			end
			if processed or uis:GetFocusedTextBox() then return end
			if self.ToggleKey and input.KeyCode == self.ToggleKey then self:Toggle(); return end
			if self._overlay then return end
			for binding in pairs(self._keys) do if binding.began then binding.began(input) end end
		end)
		self._scope:Connect(uis.WindowFocusReleased, function()
			C.cancelGesture(self); self:_CancelCapture(); self:_ReleaseKeys()
			for release in pairs(self._presses) do release() end
			motion.stopAll(self, true)
		end)
		pcall(function()
			local function preference()
				if self._motionOverride == nil then self.ReducedMotion = env.services.GuiService.ReducedMotionEnabled == true; motion.stopAll(self, true) end
			end
			preference()
			self._scope:Connect(env.services.GuiService:GetPropertyChangedSignal("ReducedMotionEnabled"), preference)
		end)
		self._scope:Connect(self._viewport:GetPropertyChangedSignal("AbsoluteSize"), function() self:_Layout() end)
		self._scope:Connect(self._viewport:GetPropertyChangedSignal("AbsolutePosition"), function() self:_Layout() end)
		local cameraRelease
		local function cameraChanged()
			if cameraRelease then cameraRelease(); cameraRelease = nil end
			local camera = env.services.Workspace.CurrentCamera
			if camera then cameraRelease = self._scope:Add(camera:GetPropertyChangedSignal("ViewportSize"):Connect(function() self:_Layout() end)) end
			self:_Layout()
		end
		self._scope:Connect(env.services.Workspace:GetPropertyChangedSignal("CurrentCamera"), cameraChanged)
		cameraChanged()
		for _, property in ipairs({ "OnScreenKeyboardVisible", "OnScreenKeyboardSize", "OnScreenKeyboardPosition", "TouchEnabled" }) do
			pcall(function()
				self._scope:Connect(uis:GetPropertyChangedSignal(property), function()
					self:_Layout()
					self._scope:Delay(0.05, function() self:_RevealFocused() end)
				end)
			end)
		end
		self._scope:Connect(uis.TextBoxFocused, function()
			self:_Layout()
			self._scope:Delay(0.05, function() self:_RevealFocused() end)
		end)
		self._scope:Connect(uis.TextBoxFocusReleased, function() self:_Layout() end)
		self._scope:Connect(self.ScreenGui.Destroying, function() self:Destroy() end)
		self._scope:Connect(self.Frame.Destroying, function() self:Destroy() end)
		env.windows[id] = self
		if options.OnDestroy then self:OnDestroy(options.OnDestroy) end
		motion.reveal(self, self.Frame)
		return self
	end
	C.elevate(Window)
	return Window
end
end)()

local environment = { metadata = uiMetadata }
environment.services = setmetatable({}, {
	__index = function(services, name)
		local service = game:GetService(name)
		rawset(services, name, service)
		return service
	end,
})
local cache, loading = {}, {}
function environment.require(id)
	if cache[id] ~= nil then return cache[id] end
	assert(uiModules[id], "UI LIB: missing module " .. tostring(id))
	assert(not loading[id], "UI LIB: circular module " .. tostring(id))
	loading[id] = true
	local ok, result = pcall(uiModules[id], environment)
	loading[id] = nil
	if not ok then error(result, 0) end
	cache[id] = result
	return result
end
local globals = _G
if type(getgenv) == "function" then
	local ok, value = pcall(getgenv)
	if ok and type(value) == "table" then globals = value end
end
local registry = rawget(globals, "__BILLIARDS_UI_V1")
if type(registry) ~= "table" or type(registry.Windows) ~= "table" then
	registry = { Windows = {} }
	rawset(globals, "__BILLIARDS_UI_V1", registry)
end
environment.windows = registry.Windows
environment.globals = globals
return environment.require("library")
end

local env = getgenv()
if env.BilliardsSuite then env.BilliardsSuite.Stop() end
local function startPreview()
	local env = getgenv()
	if env.BilliardsPath then
		env.BilliardsPath.Stop()
	end
	local modules = game:GetService("ReplicatedStorage"):WaitForChild("Billiards", 10)
	assert(modules, "당구 모듈을 찾을 수 없습니다.")
	local preview = require(modules:WaitForChild("ShotPreview", 10))
	local geometry = require(modules:WaitForChild("TableGeometry", 10))
	local guides = require(modules:WaitForChild("GuideLines", 10))
	local originalShow = guides.Show
	local showWrapper
	local original = preview.Predict
	assert(type(original) == "function", "예상 경로 API가 변경되었습니다.")
	local runService = game:GetService("RunService")
	local folder = Instance.new("Folder")
	folder.Name = "당구예상경로"
	folder.Parent = workspace
	local state = {Enabled = true, Calls = 0, Segments = 0, Error = nil, HoldUntil = 0}
	local pool = {}
	local lastCall = 0
	local lastBuild = -math.huge
	local alive = true
	local busy = false
	local wrapper
	local heartbeat
	local colours = {
		Color3.fromRGB(80, 240, 255),
		Color3.fromRGB(255, 200, 65),
		Color3.fromRGB(255, 110, 140),
		Color3.fromRGB(135, 255, 130)
	}
	local function hide()
		for _, part in ipairs(pool) do
			part.Transparency = 1
		end
		state.Segments = 0
	end
	local function segment(a, b, colour, count)
		local length = (b - a).Magnitude
		if length < 0.012 or count >= 320 then
			return count
		end
		count = count + 1
		local part = pool[count]
		if not part then
			part = Instance.new("Part")
			part.Name = "경로"
			part.Anchored = true
			part.CanCollide = false
			part.CanTouch = false
			part.CanQuery = false
			part.CastShadow = false
			part.Material = Enum.Material.Neon
			part.Parent = folder
			pool[count] = part
		end
		part.Size = Vector3.new(0.025, 0.025, length)
		part.CFrame = CFrame.lookAt((a + b) / 2, b)
		part.Color = colour
		part.Transparency = 0.18
		return count
	end
	local function findGeometry(config)
		local views = workspace:FindFirstChild("BilliardsView")
		if not views then return nil end
		local chosen, best
		local camera = workspace.CurrentCamera
		for _, part in ipairs(views:GetDescendants()) do
			if part.Name == "PlayArea" and part:IsA("BasePart") then
				local mismatch = math.abs(part.Size.X / config.VisualScale - config.Width)
					+ math.abs(part.Size.Z / config.VisualScale - config.Height)
				if mismatch < 0.03 then
					local distance = camera and (camera.Focus.Position - part.Position).Magnitude or 0
					if not best or distance < best then
						chosen, best = part, distance
					end
				end
			end
		end
		if not chosen then return nil end

		return geometry.Configure(table.clone(config), chosen)
	end
	local function build(physics, balls, cueIndex, direction, power, spinX, spinY, boost)
		local config = physics.Config
		local geo = findGeometry(config)
		if not geo then
			hide()
			state.Error = "현재 물리 설정에 맞는 PlayArea를 찾지 못했습니다."
			return
		end
		local copies, paths = {}, {}
		for i, ball in ipairs(balls) do
			copies[i] = table.clone(ball)
			paths[i] = {ball.p}
		end
		local cue = copies[cueIndex]
		if not cue or cue.pocketed then hide() return end
		local reach = physics.Reach and physics.Reach(copies, cueIndex, direction) or boost or 1
		physics.Strike(cue, direction, math.clamp(power, 0, 1), spinX, spinY, reach)
		local started = os.clock()
		local dt = config.Step
		local steps = math.min(math.ceil(12 / dt), 900)
		local simulated = 0
		for step = 1, steps do
			physics.Step(copies, dt)
			simulated = step * dt
			local moving = false
			for i, ball in ipairs(copies) do
				if not ball.pocketed then
					if step % 3 == 0 or step == steps then
						local path = paths[i]
						if (ball.p - path[#path]).Magnitude > 0.002 then
							path[#path + 1] = ball.p
						end
					end
					if ball.v.Magnitude > 0.001 or (physics.Slip and physics.Slip(ball).Magnitude > 0.001) then
						moving = true
					end
				end
			end
			if not moving or os.clock() - started > 0.018 then
				for i, ball in ipairs(copies) do
					if not ball.pocketed then
						local path = paths[i]
						if (ball.p - path[#path]).Magnitude > 0.002 then
							path[#path + 1] = ball.p
						end
					end
				end
				break
			end
		end
		local count = 0

		for pass = 1, 2 do
			for i, path in ipairs(paths) do
				if (pass == 1 and i == cueIndex) or (pass == 2 and i ~= cueIndex) then
					local colour = i == cueIndex and colours[1] or colours[2 + ((i - 1) % 3)]
					for j = 2, #path do
						local lift = Vector3.new(0, 0.025, 0)
						count = segment(geo:World(path[j - 1]) + lift, geo:World(path[j]) + lift, colour, count)
					end
				end
			end
		end
		for i = count + 1, #pool do pool[i].Transparency = 1 end
		state.Segments = count
		state.SimulatedSeconds = simulated
		state.Error = nil
	end
	wrapper = function(physics, balls, cueIndex, direction, power, spinX, spinY, ...)

		local result = original(physics, balls, cueIndex, direction, power, spinX, spinY, ...)
		if alive then
			lastCall = os.clock()
			state.Calls = state.Calls + 1
			if state.Enabled and not busy and lastCall >= state.HoldUntil and lastCall - lastBuild >= 0.2 then
				lastBuild = lastCall
				busy = true
				local _, selectedPower = ...
				local ok, err = pcall(build, physics, balls, cueIndex, direction, selectedPower or power, spinX, spinY)
				busy = false
				if not ok then
					hide()
					state.Error = tostring(err)
				end
			end
		end
		return result
	end
	function state.SetEnabled(value)
		state.Enabled = value == true
		if not state.Enabled then state.HoldUntil = 0 hide() end
	end
	function state.DrawPlan(physics, balls, cueIndex, plan)
		if not alive or not state.Enabled then return false end
		local direction = Vector3.new(math.cos(plan.angle), 0, math.sin(plan.angle))
		local drawBalls = balls
		if plan.cue then
			drawBalls = table.clone(balls)
			drawBalls[1] = table.clone(balls[1])
			drawBalls[1].p = Vector3.new(plan.cue[1], 0, plan.cue[2])
			drawBalls[1].pocketed = nil
		end
		local ok, err = pcall(build, physics, drawBalls, cueIndex, direction, plan.power, plan.side, plan.top, plan.BreakBoost)
		if not ok then state.Error = tostring(err) hide() return false end
		lastCall = os.clock()
		state.HoldUntil = lastCall + 1.2
		return true
	end
	function state.Stop()
		if not alive then return end
		alive = false
		if preview.Predict == wrapper then preview.Predict = original end
		if guides.Show == showWrapper then guides.Show = originalShow end
		if heartbeat then heartbeat:Disconnect() end
		folder:Destroy()
		if env.BilliardsPath == state then env.BilliardsPath = nil end
	end
	preview.Predict = wrapper
	showWrapper = function(self, ...)
		local shown = originalShow(self, ...)
		if alive and shown then
			lastCall = os.clock()
			if state.Enabled and state.OnPoolGuide and lastCall >= state.HoldUntil and lastCall - lastBuild >= 0.2 then
				lastBuild = lastCall
				local data = ...
				local ok, err = pcall(state.OnPoolGuide, data)
				if not ok then state.Error = tostring(err) end
			end
		end
		return shown
	end
	guides.Show = showWrapper
	heartbeat = runService.Heartbeat:Connect(function()
		if not state.Enabled or (os.clock() > state.HoldUntil and os.clock() - lastCall > 0.5) then hide() end
	end)
	env.BilliardsPath = state
	return state
end
local function startAuto(preview)
	local env = getgenv()
	local modules = game:GetService("ReplicatedStorage"):WaitForChild("Billiards", 10)
	assert(modules, "당구 모듈을 찾지 못했습니다.")
	local basePhysics = require(modules:WaitForChild("Physics", 10))
	local poolPhysics = require(modules:WaitForChild("PoolPhysics", 10))
	local poolAI = require(modules:WaitForChild("PocketBallAI", 10))
	local ai = require(modules:WaitForChild("FourBallAI", 10))
	local cueMotion = require(modules:WaitForChild("CueMotion", 10))
	local geometry = require(modules:WaitForChild("TableGeometry", 10))
	local matchClass = require(modules:WaitForChild("Match", 10))
	assert(type(ai.Plan) == "function", "자동 조준 API가 변경되었습니다.")
	if env.BilliardsAuto then env.BilliardsAuto.Stop() end
	local player = game:GetService("Players").LocalPlayer
	local runService = game:GetService("RunService")
	local state = {
		Enabled = false, Status = "경기 상태 확인 중", ShotsSent = 0,
		ShotsAccepted = 0, Error = nil, LastPlan = nil, Thinking = false,
		ThinkSeconds = 10, Level = 4, StrongPlay = true, SmoothCue = true, AimSeconds = 1.0, HumanThinking = true,
	}
	local alive, generation = true, 0
	local remote, snapshot, listener, heartbeat, window, statusLabel, toggle, modeLabel, statsLabel
	state.Preview = preview
	state.Version = "20261018_09"
	state.Standalone = true
	local attempted, pending, plannedKey, readyAt
	local lastTick, lastSync = 0, -math.huge
	local tablePhysics, physicsRemote, physicsThree
	local function key(s)
		return table.concat({tostring(s.round), tostring(s.turnId), tostring(s.shots), tostring(s.turn)}, ":")
	end
	local function myTurn(s)
		if s.turnPlayerId ~= nil then return s.turnPlayerId == player.UserId end
		if s.doubles then return false end
		return s.seats and s.seats[s.turn] == player.UserId
	end
	local function ready(s)
		if not s or s.phase ~= "playing" or not myTurn(s) then return false end
		if s.LocalMoving or s.moving or s.striking or s.opening or s.openingWaiting or s.cleaning then return false end
		if s.winner ~= 0 or s.stale or not s.balls or not s.balls[s.PoolMode and 1 or s.turn] then return false end
		local now = workspace:GetServerTimeNow()
		return now >= (s.busyUntil or 0) and now + 0.6 < (s.turnDeadline or 0)
	end
	local function setStatus(text)
		if state.Status == text then return end
		state.Status = text
		if statusLabel then statusLabel:SetText(text) end
	end
	local function pause(reason)
		state.Enabled = false
		generation = generation + 1
		if toggle then toggle:Set(false, true) end
		setStatus(reason)
	end
	local function physicsFor(s, selectedRemote)
		if s.PoolMode then return poolPhysics end
		local three = s.threeBall == true or (s.rules and s.rules.threeBall == true)
		if tablePhysics and physicsRemote == selectedRemote and physicsThree == three then return tablePhysics end
		local physical = selectedRemote:FindFirstChild("Table")
		physical = physical and physical.Value
		assert(physical, "현재 경기의 테이블을 찾지 못했습니다.")
		local size = physical:GetAttribute("TableSize")
		local viewName = three and size ~= "중대" and "DaedaeView" or "ViewTable"
		local views = workspace:FindFirstChild("BilliardsView")
		local view = views and views:FindFirstChild(viewName)
		local area = view and view:FindFirstChild("PlayArea", true)
		assert(area and area:IsA("BasePart"), "경기에 맞는 PlayArea를 찾지 못했습니다.")
		local physics = basePhysics.ForTable(three)
		geometry.Configure(physics.Config, area)
		tablePhysics, physicsRemote, physicsThree = physics, selectedRemote, three
		return physics
	end
	local function normalizePool(raw)
		local s = table.clone(raw)
		s.PoolMode = true
		s.RawBalls = raw.balls
		s.shots = raw.shotSeq or 0
		s.balls = {}
		for i, b in ipairs(raw.balls or {}) do
			local ball = poolPhysics.NewBall(i, b[1], b[2])
			if b[3] and b[3] ~= 0 then ball.pocketed = b[3] end
			s.balls[i] = ball
		end
		return s
	end
	function state.EvaluatePool(s, inputPlan, cancelled)
		local group = s.groups and s.groups[s.turn] or nil
		local onEight = group and true or false
		local legal = {}
		for i = 2, 16 do
			local n = i - 1
			if not s.balls[i].pocketed and group and n ~= 8 and ((n < 8) == (group == "low")) then onEight = false end
		end
		for i = 2, 16 do
			local n = i - 1
			legal[i] = s.breakShot or (onEight and n == 8) or
				(not onEight and n ~= 8 and (not group or ((n < 8) == (group == "low"))))
		end
		local deadline = os.clock() + math.clamp(state.ThinkSeconds, 1, 15)
		local function interrupted()
			return not alive or os.clock() > deadline or (cancelled and cancelled())
		end
		local request = {kitchen = s.kitchen == true or s.breakShot == true}
		local plan = table.clone(inputPlan)
		if interrupted() then return nil, "경기 상태 변경 또는 계산 중단" end
		for _, field in ipairs({"angle", "power", "side", "top"}) do
			local n = plan[field]
			assert(type(n) == "number" and n == n and math.abs(n) < math.huge, "포켓볼 타격값 오류")
		end
		assert(plan.power >= 0.005 and plan.power <= 1, "포켓볼 힘 범위 오류")
		assert(Vector2.new(plan.side, plan.top).Magnitude <= 0.6501, "포켓볼 회전 범위 오류")
		local balls = {}
		for i, b in ipairs(s.balls) do balls[i] = table.clone(b) end
		if plan.cue then
			local c = poolPhysics.Config
			local pos = Vector3.new(plan.cue[1], 0, plan.cue[2])
			assert(s.ballInHand or s.breakShot or s.kitchen, "수구 배치 권한 없음")
			assert(pos.X >= c.Radius and pos.X <= c.Width - c.Radius and pos.Z >= c.Radius and pos.Z <= c.Height - c.Radius and not poolPhysics.PocketAt(pos), "수구 배치 범위 오류")
			assert(not request.kitchen or s.ballInHand or pos.X <= c.Width * 0.25, "브레이크 수구 배치 범위 오류")
			for i = 2, 16 do assert(balls[i].pocketed or (balls[i].p - pos).Magnitude >= 2 * c.Radius, "수구 배치 겹침") end
			balls[1].p, balls[1].pocketed = pos, nil
		end
		local first, scratched, eight, own, any, rail = nil, false, false, 0, 0, false
		local pocketedIndices = {}
		local function contact(a, b)
			if not first then if a == 1 then first = b elseif b == 1 then first = a end end
		end
		local function impact(kind)
			if first and kind == "rail" then rail = true end
		end
		local function pocket(i)
			table.insert(pocketedIndices, i)
			if i == 1 then scratched = true elseif i == 9 then eight = true
			else any = any + 1 if legal[i] then own = own + 1 end end
		end
		plan.BreakBoost = s.breakShot and poolPhysics.Config.BreakBoost or 1
		poolPhysics.Strike(balls[1], Vector3.new(math.cos(plan.angle), 0, math.sin(plan.angle)), plan.power, plan.side, plan.top, plan.BreakBoost)
		local settled, frameAt = false, os.clock()
		for _ = 1, math.ceil(30 / poolPhysics.Config.Step) do
			poolPhysics.Step(balls, poolPhysics.Config.Step, contact, impact, pocket)
			if poolPhysics.IsSettled(balls) then settled = true break end
			if os.clock() - frameAt > 0.003 then task.wait() frameAt = os.clock() if interrupted() then return nil, "포켓볼 검증 중 상태 변경 또는 시간 초과" end end
		end
		if not settled then return nil, "포켓볼 정지 확인 시간 초과" end
		plan.VerifiedFoul = scratched or not first or not legal[first] or (not rail and any == 0 and not eight)
		plan.VerifiedScore = group and own or any
		plan.VerifiedWinner = eight and onEight and not plan.VerifiedFoul and s.turn or 0
		plan.VerifiedLoss = eight and not s.breakShot and (not onEight or plan.VerifiedFoul)
		if plan.VerifiedLoss then return nil, "8번 공 조기 포켓 예상 타격 제외" end
		if plan.VerifiedFoul then return nil, "포켓볼 파울 예상 타격 제외" end
		plan.PocketedIndices = pocketedIndices
		return plan, balls
	end

	function state.EvaluateCarom(s, selectedRemote, inputPlan, cancelled)
		assert(s and s.balls and s.turn, "계산할 경기 상태가 없습니다.")
		if s.PoolMode then return state.EvaluatePool(s, inputPlan, cancelled) end
		local physics = physicsFor(s, selectedRemote)
		local balls = {}
		for i, ball in ipairs(s.balls) do
			assert(typeof(ball.p) == "Vector3", "공 위치 형식이 변경되었습니다.")
			balls[i] = physics.NewBall(i, ball.p.X, ball.p.Z)
			balls[i].v = ball.v or Vector3.new()
			balls[i].w = ball.w or Vector3.new()
		end
		local three = #balls == 3
		local final = s.finalThreeCushion and s.finalThreeCushion[s.turn] == true
		local deadline = os.clock() + math.clamp(state.ThinkSeconds, 1, 15)
		local function interrupted()
			return not alive or os.clock() > deadline or (cancelled and cancelled())
		end
		local plan = table.clone(inputPlan)
		if interrupted() then return nil, "경기 상태 변경 또는 계산 중단" end
		for _, field in ipairs({"angle", "power", "side", "top"}) do
			local n = plan[field]
			assert(type(n) == "number" and n == n and math.abs(n) < math.huge, "조준 계산값이 올바르지 않습니다.")
		end
		plan.power = math.clamp(plan.power, cueMotion.MinPower, 1)
		local spin = Vector2.new(plan.side, plan.top)
		assert(spin.Magnitude <= (cueMotion.MaxSpin or 0.65) + 0.0001, "회전값이 허용 범위를 벗어났습니다.")

		local test = matchClass.new(three, physics)
		test:SetRules(s.targetScore or (s.rules and s.rules.target) or 10,
			s.finalRule == true or (s.rules and s.rules.final == true),
			not s.rules or s.rules.penalty ~= false)
		test.balls = {}
		for i, ball in ipairs(balls) do test.balls[i] = table.clone(ball) end
		test.turn = s.turn
		test.scores = {s.scores and s.scores[1] or 0, s.scores and s.scores[2] or 0}
		test.turnStartScore = test.scores[s.turn]
		local scoreBefore = test.scores[s.turn]
		assert(test:Shoot(plan.angle, plan.power, plan.side, plan.top), "물리 엔진이 타격값을 거부했습니다.")
		local frameAt = os.clock()
		for _ = 1, math.ceil(35 / physics.Config.Step) do
			test:Step(physics.Config.Step)
			if not test.moving then break end
			if os.clock() - frameAt > 0.003 then
				task.wait()
				frameAt = os.clock()
				if interrupted() then return nil, "검증 중 경기 상태 변경 또는 시간 초과" end
			end
		end
		if test.moving then return nil, "정지까지 검증하지 못한 타격" end
		plan.VerifiedScore = test.scores[s.turn] - scoreBefore
		plan.VerifiedFoul = test.shot and test.shot.foul == true or false
		plan.VerifiedWinner = test.winner
		if plan.VerifiedFoul or plan.VerifiedScore < 0 then return nil, "파울 예상 타격 제외" end
		return plan, test.balls, test
	end
	local function groupFor(s)
		return s.groups and s.groups[s.turn] or nil
	end
	local function poolLegal(balls, group, breakShot)
		local onEight = group ~= nil
		if group then
			for i = 2, 16 do
				local n = i - 1
				if not balls[i].pocketed and n ~= 8 and ((n < 8) == (group == "low")) then onEight = false end
			end
		end
		local legal = {}
		for i = 2, 16 do
			local n = i - 1
			legal[i] = not balls[i].pocketed and (breakShot or (onEight and n == 8)
				or (not onEight and n ~= 8 and (not group or ((n < 8) == (group == "low")))))
		end
		return legal
	end
	local function clearLine(balls, a, b, skipA, skipB)
		local delta = b - a
		local length2 = delta:Dot(delta)
		if length2 < 1e-10 then return false end
		local width = poolPhysics.Config.Radius * 2.03
		for i, ball in ipairs(balls) do
			if i ~= skipA and i ~= skipB and not ball.pocketed then
				local t = math.clamp((ball.p - a):Dot(delta) / length2, 0, 1)
				if (ball.p - (a + delta * t)).Magnitude < width then return false end
			end
		end
		return true
	end

	function state.PoolChances(balls, group, origin)
		local cue = origin or balls[1].p
		local legal = poolLegal(balls, group, false)
		local choices = {}
		local c = poolPhysics.Config
		for i = 2, 16 do
			if legal[i] then
				local ball = balls[i]
				for _, pocket in ipairs(poolPhysics.Pockets) do
					local toHole = pocket.hole - ball.p
					if toHole.Magnitude > c.Radius then
						local ghost = ball.p - toHole.Unit * (2 * c.Radius)
						local aim = ghost - cue
						if aim.Magnitude > 0.001 and ghost.X >= c.Radius and ghost.X <= c.Width - c.Radius
							and ghost.Z >= c.Radius and ghost.Z <= c.Height - c.Radius then
							local cut = aim.Unit:Dot(toHole.Unit)
							if cut > 0.18 and clearLine(balls, cue, ghost, 1, i) and clearLine(balls, ball.p, pocket.hole, 1, i) then
								local quality = cut * cut / (1 + aim.Magnitude + toHole.Magnitude)
								table.insert(choices, {angle = math.atan2(aim.Z, aim.X), Quality = quality,
									Distance = aim.Magnitude + toHole.Magnitude / math.max(cut * cut, 0.12), Ball = i})
							end
						end
					end
				end
			end
		end
		table.sort(choices, function(a, b) return a.Quality > b.Quality end)
		return choices[1] and choices[1].Quality or 0, choices
	end
	local function nextPoolState(s, plan, balls)
		local nextState = table.clone(s)
		nextState.balls, nextState.RawBalls = balls, {}
		nextState.breakShot, nextState.ballInHand, nextState.kitchen = false, false, false
		nextState.groups = table.clone(s.groups or {})

		if not groupFor(s) and not s.breakShot then
			for _, i in ipairs(plan.PocketedIndices or {}) do
				if i > 1 and i ~= 9 then
					nextState.groups[s.turn] = i < 9 and "low" or "high"
					nextState.groups[3 - s.turn] = i < 9 and "high" or "low"
					break
				end
			end
		end
		for i, b in ipairs(balls) do nextState.RawBalls[i] = {b.p.X, b.p.Z, b.pocketed or 0} end
		return nextState
	end
	local function caromQuality(balls, turn)
		local targets = #balls == 3 and {3, 3 - turn} or {3, 4}
		local cue = balls[turn].p
		local a, b = balls[targets[1]].p, balls[targets[2]].p
		local nearest = math.min((a - cue).Magnitude, (b - cue).Magnitude)
		local spread = (a - b).Magnitude
		return 1 / (1 + spread * 1.7 + math.abs(nearest - 0.45))
	end
	function state.BuildShotCandidates(s, selectedRemote, seed)
		local list, seen = {}, {}
		local function add(p)
			if not p then return end
			local angle = math.atan2(math.sin(p.angle), math.cos(p.angle))
			local power = math.clamp(p.power, s.PoolMode and 0.05 or cueMotion.MinPower, 1)
			local tag = string.format("%.5f:%.4f:%.3f:%.3f", angle, power, p.side or 0, p.top or 0)
			if seen[tag] then return end
			seen[tag] = true
			table.insert(list, {angle = angle, power = power, side = p.side or 0, top = p.top or 0, cue = p.cue})
		end
		add(seed)
		if seed then
			for _, d in ipairs({-0.003, 0.003, -0.008, 0.008, 0}) do
				for _, scale in ipairs({0.92, 1.08, 1}) do
					add({angle = seed.angle + d, power = seed.power * scale, side = seed.side, top = seed.top, cue = seed.cue})
				end
			end
			for _, spin in ipairs({{0.15, 0}, {-0.15, 0}, {0, 0.15}, {0, -0.15}}) do
				local side, top = math.clamp(seed.side + spin[1], -0.6, 0.6), math.clamp(seed.top + spin[2], -0.6, 0.6)
				if Vector2.new(side, top).Magnitude <= 0.65 then
					add({angle = seed.angle, power = seed.power, side = side, top = top, cue = seed.cue})
				end
			end
		end
		if s.PoolMode then
			local origin = seed and seed.cue and Vector3.new(seed.cue[1], 0, seed.cue[2]) or s.balls[1].p
			local _, choices = state.PoolChances(s.balls, groupFor(s), origin)
			for i = 1, math.min(#choices, 10) do
				local choice = choices[i]
				local c = poolPhysics.Config
				local approximate = math.clamp(math.sqrt(2.8 * c.RollingFriction * c.Gravity * choice.Distance) / c.MaxSpeed, 0.13, 0.6)
				for _, multiplier in ipairs({1.25, 1.8, 2.5}) do
					add({angle = choice.angle, power = approximate * multiplier, side = 0, top = 0, cue = seed and seed.cue})
				end
			end

			local legal = poolLegal(s.balls, groupFor(s), s.breakShot)
			for i = 2, 16 do
				if legal[i] then
					local delta = s.balls[i].p - origin
					if delta.Magnitude > 0.001 then
						local angle = math.atan2(delta.Z, delta.X)
						local edge = math.asin(math.min(0.99, 2 * poolPhysics.Config.Radius / delta.Magnitude)) * 0.5
						for _, d in ipairs({0, -edge, edge}) do
							for _, power in ipairs({0.18, 0.3}) do add({angle = angle + d, power = power, side = 0, top = 0, cue = seed and seed.cue}) end
						end
					end
				end
			end
		else
			local physics = physicsFor(s, selectedRemote)
			local c, origin = physics.Config, s.balls[s.turn].p
			local targets = #s.balls == 3 and {3, 3 - s.turn} or {3, 4}
			for _, i in ipairs(targets) do
				local p = s.balls[i].p
				for _, target in ipairs({p, Vector3.new(2 * c.Radius - p.X, 0, p.Z),
					Vector3.new(2 * (c.Width - c.Radius) - p.X, 0, p.Z),
					Vector3.new(p.X, 0, 2 * c.Radius - p.Z), Vector3.new(p.X, 0, 2 * (c.Height - c.Radius) - p.Z)}) do
					local delta = target - origin
					local angle = math.atan2(delta.Z, delta.X)
					for _, power in ipairs({0.38, 0.6, 0.82}) do
						add({angle = angle, power = power, side = 0, top = 0.1})
					end
				end
			end
		end
		return list
	end
	function state.PlanSnapshot(s, selectedRemote, cancelled)
		assert(s and s.balls and s.turn, "계산할 경기 상태가 없습니다.")
		local started = os.clock()
		local remaining = s.turnDeadline and s.turnDeadline - workspace:GetServerTimeNow() - 2.2 or state.ThinkSeconds
		local budget = math.max(0, math.min(state.ThinkSeconds, remaining))
		if budget < 0.2 then return nil, "계산할 차례 시간이 부족합니다" end
		local deadline = started + budget
		local function hardCancel() return not alive or (cancelled and cancelled()) end
		local function exhausted() return hardCancel() or os.clock() >= deadline end
		local function seedPlan(limit, selectedState)
			local function stop() return hardCancel() or os.clock() >= limit end
			if selectedState.PoolMode then
				return poolAI.Plan(poolPhysics, {balls = selectedState.RawBalls, group = groupFor(selectedState),
					ballInHand = selectedState.ballInHand, kitchen = selectedState.kitchen == true or selectedState.breakShot == true,
					breakShot = selectedState.breakShot, level = state.Level}, {frameBudget = 0.003, cancelled = stop})
			end
			local three = #selectedState.balls == 3
			return ai.Plan(physicsFor(selectedState, selectedRemote), cueMotion, selectedState.balls, selectedState.turn,
				{targets = three and {3, 3 - selectedState.turn} or {3, 4}, threeCushions = three or
					(selectedState.finalThreeCushion and selectedState.finalThreeCushion[selectedState.turn] == true),
					level = state.Level, frameBudget = 0.003, cancelled = stop})
		end
		local seed = seedPlan(math.min(deadline, started + math.max(0.1, budget * 0.42)), s)
		if hardCancel() then return nil, "경기 상태 변경으로 계산 취소" end
		local candidates = state.BuildShotCandidates(s, selectedRemote, seed)
		local finalists, checked = {}, 0
		local function evaluate(selectedState, shot, stop)
			if selectedState.PoolMode then return state.EvaluatePool(selectedState, shot, stop) end
			return state.EvaluateCarom(selectedState, selectedRemote, shot, stop)
		end
		local firstDeadline = state.StrongPlay and started + budget * 0.78 or deadline
		for _, shot in ipairs(candidates) do
			if exhausted() or (checked > 0 and os.clock() >= firstDeadline) then break end
			local plan, balls, match = evaluate(s, shot, exhausted)
			checked = checked + 1
			if plan then
				local nextState = s.PoolMode and nextPoolState(s, plan, balls) or table.clone(s)
				local own, opponent
				if s.PoolMode then
					local group = groupFor(nextState)
					own = state.PoolChances(balls, group)
					opponent = state.PoolChances(balls, group and (group == "low" and "high" or "low") or nil)
				else
					nextState.balls, nextState.scores = balls, table.clone(match.scores)
					own, opponent = caromQuality(balls, s.turn), caromQuality(balls, 3 - s.turn)
				end
				local score = (plan.VerifiedWinner == s.turn and 100000 or 0) + plan.VerifiedScore * 1000
				if state.StrongPlay then score = score + own * 120 - opponent * (plan.VerifiedScore > 0 and 15 or 220) end
				score = score - plan.power * 2 - math.abs(plan.side) * 0.8
				table.insert(finalists, {Plan = plan, State = nextState, Value = score, Own = own, Opponent = opponent})
				if not state.StrongPlay then break end
			end
		end
		if hardCancel() then return nil, "경기 상태 변경으로 계산 취소" end
		if #finalists == 0 then return nil, "제한시간 안에 검증된 합법 타격을 찾지 못했습니다" end
		table.sort(finalists, function(a, b) return a.Value > b.Value end)
		local legalCount = #finalists
		local deeper, robustChecks = 0, 0
		while #finalists > 3 do table.remove(finalists) end
		if state.StrongPlay then

			for i = 1, math.min(3, #finalists) do
				if exhausted() then break end
				local item = finalists[i]
				local safe, scored, trials = 0, 0, 0
				local limit = math.min(deadline, os.clock() + math.min(0.35, budget * 0.045))
				local function stop() return hardCancel() or os.clock() >= limit end
				for _, error in ipairs({{-0.0008, 0.98}, {0.0008, 1.02}}) do
					if stop() then break end
					local p = table.clone(item.Plan)
					p.angle, p.power = p.angle + error[1], math.clamp(p.power * error[2], s.PoolMode and 0.05 or cueMotion.MinPower, 1)
					local result, reason = evaluate(s, p, stop)
					if stop() and not result then break end
					trials, robustChecks = trials + 1, robustChecks + 1
					if result then
						safe = safe + 1
						if result.VerifiedScore >= item.Plan.VerifiedScore and result.VerifiedWinner == item.Plan.VerifiedWinner then scored = scored + 1 end
					end
				end
				if trials > 0 then
					item.Plan.RobustTrials, item.Plan.RobustSafe = trials, safe
					item.Value = item.Value - (1 - safe / trials) * 1500 - (1 - scored / trials) * 180
				end
			end
			table.sort(finalists, function(a, b) return a.Value > b.Value end)

			for i = 1, math.min(3, #finalists) do
				if exhausted() then break end
				local item = finalists[i]
				if item.Plan.VerifiedWinner ~= s.turn then
					local nextState = table.clone(item.State)
					local attack = item.Plan.VerifiedScore > 0
					if not attack then nextState.turn = 3 - s.turn end
					local limit = math.min(deadline, os.clock() + math.min(0.65, budget * 0.09))
					local function stop() return hardCancel() or os.clock() >= limit end
					local options = state.BuildShotCandidates(nextState, selectedRemote, nil)
					local nextBest = 0
					for j = 1, math.min(#options, 8) do
						if stop() then break end
						local nextPlan = evaluate(nextState, options[j], stop)
						deeper = deeper + 1
						if nextPlan then nextBest = math.max(nextBest, nextPlan.VerifiedWinner == nextState.turn and 3 or nextPlan.VerifiedScore) end
					end
					item.Plan.NextVerifiedScore = nextBest
					item.Value = item.Value + nextBest * (attack and 160 or -240)
				end
			end
		end
		if hardCancel() then return nil, "경기 상태 변경으로 계산 취소" end
		table.sort(finalists, function(a, b) return a.Value > b.Value end)
		local best = finalists[1]
		best.Plan.Strategy = best.Plan.VerifiedWinner == s.turn and "승리 경로" or (best.Plan.VerifiedScore > 0 and "득점·다음 배치" or "상대 기회 억제 수비")
		best.Plan.SearchCandidates, best.Plan.SearchSeconds = checked, os.clock() - started
		state.LastSearch = {Candidates = checked, Legal = legalCount, NextChecks = deeper, RobustChecks = robustChecks, Seconds = os.clock() - started,
			Strategy = best.Plan.Strategy, NextQuality = best.Own, OpponentThreat = best.Opponent}
		return best.Plan
	end
	local cueStandModule = require(modules:WaitForChild("CueStand", 10))
	local originalCueNew = cueStandModule.new
	local cueNewWrapper
	local cueRecords, cueSeen = {}, {}
	local smoothStage, bypassUntil = nil, 0
	local aimRandom = Random.new()
	state.SmoothFrames = 0
	local function ease(t)
		t = math.clamp(t, 0, 1)
		return t * t * (3 - 2 * t)
	end
	local function attachCue(stand, config, pool)
		if type(stand) ~= "table" or cueSeen[stand] or type(stand.place) ~= "function" or type(stand.frameAt) ~= "function" then return end
		cueSeen[stand] = true
		local record = {Stand = stand, Config = config, Pool = pool, Original = stand.place, Frames = {}, Times = {}}
		local function wrapper(seat, frame, hidden, ...)
			if alive and state.SmoothCue and snapshot and myTurn(snapshot) and seat == snapshot.turn
				and state.Enabled and record.Pool == (snapshot.PoolMode == true) and typeof(frame) == "CFrame" then
				local now = os.clock()
				local stage = smoothStage
				if stage and stage.Generation == generation and stage.Key == key(snapshot) and stage.Remote == remote and not (snapshot.LocalMoving or snapshot.moving or snapshot.striking) then
					local configNow = record.Config or stage.Config
					local shown = state.SampleAimSequence(stage.Sequence, now - stage.At)

					frame = stand.frameAt(configNow, stage.Position, shown.angle, shown.side, shown.top,
						cueMotion.TipGap + shown.power * cueMotion.PullDistance)
					hidden = false
					state.SmoothFrames = state.SmoothFrames + 1
				elseif now >= bypassUntil and ready(snapshot) and not hidden then
					local previous = record.Frames[seat]
					local dt = math.min(now - (record.Times[seat] or now), 0.1)
					if previous and dt > 0 then frame = previous:Lerp(frame, 1 - math.exp(-16 * dt)) end
				end
				record.Frames[seat], record.Times[seat] = frame, now
			else
				record.Frames[seat], record.Times[seat] = frame, os.clock()
			end
			return record.Original(seat, frame, hidden, ...)
		end
		record.Wrapper = wrapper
		record.OriginalFrameAt = stand.frameAt
		record.FrameWrapper = function(configNow, position, angle, ...)
			if not smoothStage then record.Angle = angle end
			return record.OriginalFrameAt(configNow, position, angle, ...)
		end
		stand.frameAt = record.FrameWrapper
		stand.place = wrapper
		table.insert(cueRecords, record)
		state.CueBindings = #cueRecords
	end
	local function discoverCues()
		if type(getconnections) ~= "function" or type(debug.getupvalues) ~= "function" or type(getfenv) ~= "function" then
			state.SmoothError = "현재 실행기에서 기존 큐대 연결 조회를 지원하지 않습니다."
			return
		end
		local visited = {}
		local function visit(fn, depth, pool)
			if depth > 2 or visited[fn] then return end
			visited[fn] = true
			local ok, values = pcall(debug.getupvalues, fn)
			if not ok then return end
			for _, value in pairs(values) do
				if type(value) == "table" then
					attachCue(value.stand or value, value.config, pool)
					if type(value.angle) == "number" and type(value.power) == "number" and value.sentAt ~= nil then
						state.ClientAim = value
					end
					for _, child in pairs(value) do
						if type(child) == "function" then visit(child, depth + 1, pool) end
					end
				elseif type(value) == "function" then visit(value, depth + 1, pool) end
			end
		end
		for _, signal in ipairs({runService.RenderStepped, runService.Heartbeat}) do
			for _, connection in ipairs(getconnections(signal)) do
				local fn = connection.Function
				if type(fn) == "function" then
					local ok, context = pcall(getfenv, fn)
					local owner = ok and context.script
					if owner and (owner.Name == "PocketBallClient" or owner.Name == "FourBallClient") then visit(fn, 0, owner.Name == "PocketBallClient") end
				end
			end
		end
	end
	cueNewWrapper = function(options, ...)
		local stand = originalCueNew(options, ...)
		local area = options.area
		local isPool = options.parent and options.parent.Name == "PocketBallCues"
		if not isPool and area and area.Parent then isPool = string.find(area.Parent.Name, "Pocket", 1, true) ~= nil end
		attachCue(stand, nil, isPool == true)
		return stand
	end
	cueStandModule.new = cueNewWrapper
	discoverCues()

	function state.CreateAimSequence(plan, fromAngle, budget)
		local sequence = {Duration = 0, Phases = {}}
		local current = {angle = fromAngle, power = 0, side = 0, top = 0}
		budget = math.max(0, budget)
		local finalSeconds = math.min(math.clamp(state.AimSeconds, 0.4, 2), budget)
		local extra = math.min(math.max(0, budget - finalSeconds), 3.2)
		local function add(target, duration, label)
			local delta = math.atan2(math.sin(target.angle - current.angle), math.cos(target.angle - current.angle))
			local nextValue = {angle = current.angle + delta, power = target.power, side = target.side, top = target.top}
			table.insert(sequence.Phases, {From = current, To = nextValue, At = sequence.Duration, Duration = duration, Label = label})
			sequence.Duration = sequence.Duration + duration
			current = nextValue
		end
		if state.HumanThinking and extra >= 1.25 then
			local sign = aimRandom:NextNumber() < 0.5 and -1 or 1
			local offset = math.rad(aimRandom:NextNumber(7, 19)) * sign
			local count = extra >= 2.2 and aimRandom:NextInteger(1, 2) or 1
			local used = math.min(extra, aimRandom:NextNumber(1.4, 2.0) + (count - 1) * 0.9)
			for i = 1, count do
				local target = {angle = plan.angle + offset, power = plan.power * aimRandom:NextNumber(0.12, 0.35), side = 0, top = 0}
				add(target, used / count * 0.68, i == 1 and "다른 방향 살펴보는 중" or "반대쪽 방향도 살펴보는 중")
				add(current, used / count * 0.32, "잠깐 멈춰 방향 검토 중")
				offset = -offset * aimRandom:NextNumber(0.55, 0.9)
			end
		end
		add(plan, finalSeconds, "방향 결정 · 최종 조준 중")
		return sequence
	end
	function state.SampleAimSequence(sequence, elapsed)
		local phases = sequence.Phases
		local phase = phases[#phases]
		local index = #phases
		for i, candidate in ipairs(phases) do
			if elapsed < candidate.At + candidate.Duration then phase, index = candidate, i break end
		end
		local u = phase.Duration > 0 and ease((elapsed - phase.At) / phase.Duration) or 1
		local a, b = phase.From, phase.To
		return {angle = a.angle + (b.angle - a.angle) * u, power = a.power + (b.power - a.power) * u,
			side = a.side + (b.side - a.side) * u, top = a.top + (b.top - a.top) * u}, index
	end
	function state.AnimateAim(plan, selectedState, selected, cancelled)
		if cancelled() then return false end
		if not state.SmoothCue then task.wait(0.25) return not cancelled() end
		local physics = physicsFor(selectedState, selected)
		local config = table.clone(physics.Config)
		config.CushionHeight = config.CushionHeight or 0
		config.RailTopRadius = config.RailTopRadius or cueMotion.RailTopRadius
		local cue = selectedState.balls[selectedState.PoolMode and 1 or selectedState.turn]
		local position = plan.cue and Vector3.new(plan.cue[1], 0, plan.cue[2]) or cue.p
		local fromAngle = selectedState.PoolMode and state.ClientAim and state.ClientAim.angle or state.LastAimAngle or plan.angle
		for _, record in ipairs(cueRecords) do
			if record.Pool == (selectedState.PoolMode == true) and record.Angle ~= nil
				and record.Stand.frames and record.Stand.frames[selectedState.turn] then fromAngle = record.Angle break end
		end

		local budget = math.max(0, math.min(4.5, (selectedState.turnDeadline or 0) - workspace:GetServerTimeNow() - 1.2))
		local sequence = state.CreateAimSequence(plan, fromAngle, budget)
		local stage = {Key = key(selectedState), Remote = selected, Position = position,
			Generation = generation, Config = config, At = os.clock(), Sequence = sequence}
		smoothStage = stage
		local lastSend, lastPhase = -math.huge, nil
		while true do
			if cancelled() then if smoothStage == stage then smoothStage = nil end return false end
			local now = os.clock()
			local elapsed = now - stage.At
			local shown, phase = state.SampleAimSequence(sequence, elapsed)
			if lastPhase ~= phase then lastPhase = phase setStatus(sequence.Phases[phase].Label) end
			if now - lastSend >= 0.11 then
				lastSend = now
				selected:FireServer("aim", {turnId = selectedState.turnId, angle = shown.angle,
					power = shown.power, side = shown.side, top = shown.top, cue = plan.cue,
					pulling = phase == #sequence.Phases and shown.power > plan.power * 0.45})
				if elapsed >= sequence.Duration then break end
			end
			runService.RenderStepped:Wait()
		end
		state.LastAimAngle = plan.angle
		bypassUntil = os.clock() + 0.6
		return not cancelled()
	end
	local function resolvePending(s)
		if not pending then return end
		if s.round ~= pending.round then pending = nil return end
		if (s.shots or 0) > pending.shots then
			state.ShotsAccepted = state.ShotsAccepted + 1
			state.LastReceipt = {Accepted = true, TurnId = pending.turnId, Shots = s.shots}
			pending = nil
		elseif s.turnId ~= pending.turnId then
			state.LastReceipt = {Accepted = false, TurnId = pending.turnId}
			pending = nil
		end
	end
	local function bind(selectedRemote)
		smoothStage = nil
		state.LastAimAngle = nil
		discoverCues()
		generation = generation + 1
		if listener then listener:Disconnect() end
		remote, snapshot, pending, attempted, plannedKey = selectedRemote, nil, nil, nil, nil
		state.Remote = selectedRemote and selectedRemote:GetFullName() or nil
		state.LastPlan = nil
		readyAt = nil
		if not selectedRemote then setStatus("포켓볼·4구·3구 경기에 입장하세요") return end
		listener = selectedRemote.OnClientEvent:Connect(function(kind, payload)
			if not alive or remote ~= selectedRemote then return end
			local isPool = selectedRemote.Parent and selectedRemote.Parent.Name == "PocketBallEvents"
			if isPool and kind == "shot" and type(payload) == "table" then
				if snapshot and payload.round == snapshot.round then snapshot.LocalMoving = true end
				if pending and snapshot and payload.round == pending.round and payload.shooter == snapshot.turn and (payload.turnId == nil or payload.turnId == pending.turnId) then
					state.ShotsAccepted = state.ShotsAccepted + 1
					state.LastReceipt = {Accepted = true, TurnId = pending.turnId, Seq = payload.seq}
					pending = nil
				end
				return
			end
			if isPool and kind == "result" and type(payload) == "table" and type(payload.result) == "table" then kind, payload = "state", payload.result end
			if kind == "state" and type(payload) == "table" then
				if isPool then payload = normalizePool(payload) end
				if snapshot and type(payload.sequence) == "number" and payload.sequence <= (snapshot.sequence or -1) then return end
				if payload.slim then
					if not snapshot then return end
					local merged = table.clone(snapshot)
					for k, v in pairs(payload) do merged[k] = v end
					merged.slim, merged.stale = nil, true
					snapshot = merged
				else snapshot = payload end
				state.Snapshot = snapshot
				resolvePending(snapshot)
				if not state.Enabled and not state.Error then setStatus("준비 완료 · 자동 플레이를 켜세요") end
			elseif kind == "error" or kind == "denied" then
				state.Error = tostring(payload)
				pause("타격 거부: " .. state.Error)
			end
		end)
		lastSync = os.clock()
		selectedRemote:FireServer("sync")
	end
	function state.SetEnabled(value)
		if not alive then return end
		state.Enabled = value == true
		generation = generation + 1
		state.Error = nil
		smoothStage = nil
		if state.Enabled then plannedKey, readyAt = nil, nil end
		if toggle then toggle:Set(state.Enabled, true) end
		setStatus(state.Enabled and "자동 플레이 대기 중" or "자동 플레이 중지")
	end
	function state.Stop()
		if not alive then return end
		alive = false
		state.Enabled = false
		generation = generation + 1
		if listener then listener:Disconnect() end
		if heartbeat then heartbeat:Disconnect() end
		if window then local old = window window = nil state.Window = nil old:Destroy() end
		if cueStandModule.new == cueNewWrapper then cueStandModule.new = originalCueNew end
		for _, record in ipairs(cueRecords) do
			if record.Stand.place == record.Wrapper then record.Stand.place = record.Original end
			if record.Stand.frameAt == record.FrameWrapper then record.Stand.frameAt = record.OriginalFrameAt end
		end
		smoothStage = nil
		if preview then preview.Stop() end
		if env.BilliardsSuite == state then env.BilliardsSuite = nil end
		if env.BilliardsAuto == state then env.BilliardsAuto = nil end
	end
	local function tick()
		if not alive or os.clock() - lastTick < 0.2 then return end
		lastTick = os.clock()
		local events = modules:FindFirstChild("TableEvents")
		local name = player:GetAttribute("BilliardsMatch")
		local poolEvents = modules:FindFirstChild("PocketBallEvents")
		local selectedRemote = type(name) == "string" and ((poolEvents and poolEvents:FindFirstChild(name)) or (events and events:FindFirstChild(name))) or nil
		if selectedRemote ~= remote then bind(selectedRemote) end
		if not remote then
			state.Mode = "경기 없음"
			if modeLabel then modeLabel:SetText("포켓볼·4구·3구 자동 감지 · 경기 입장 대기") end
			return
		end
		if snapshot then
			local three = snapshot.threeBall == true or (snapshot.rules and snapshot.rules.threeBall == true)
			state.Mode = snapshot.PoolMode and "포켓볼(8볼)" or (three and "3구" or "4구")
			local final = snapshot.finalThreeCushion and snapshot.finalThreeCushion[snapshot.turn]
			if modeLabel then modeLabel:SetText("현재 모드: " .. state.Mode .. (snapshot.PoolMode and " · 공 종류·8번 공 규칙" or ((three or final) and " · 3쿠션 규칙" or " · 일반 득점 규칙"))) end
			if statsLabel then
				statsLabel:SetText(string.format("타격 %d회 · 서버 확인 %d회 · 경로 %d개", state.ShotsSent, state.ShotsAccepted, preview.Segments))
			end
		end
		if pending then
			if os.clock() - pending.at > 5 then
				state.Error = "서버 타격 확인 없음"
				pause("타격 결과 미확인: 상태를 확인한 후 다시 켜세요")
			end
			return
		end
		if snapshot and snapshot.stale and not snapshot.moving and os.clock() - lastSync > 2 then
			lastSync = os.clock()
			remote:FireServer("sync")
		end
		if not state.Enabled then return end
		if not ready(snapshot) then
			readyAt = nil
			setStatus(snapshot and snapshot.phase == "finished" and "경기 종료" or "내 차례와 공 정지 대기 중")
			return
		end
		local shotKey = key(snapshot)
		if attempted == shotKey or plannedKey == shotKey or state.Thinking then return end
		if not readyAt then readyAt = os.clock() return end
		if os.clock() - readyAt < 0.7 then return end
		local selectedState, selected = snapshot, remote
		local token = generation
		plannedKey = shotKey
		state.Thinking = true
		setStatus("각도·힘·회전 계산 및 파울 검사 중")
		task.spawn(function()
			local function cancelled()
				return not alive or not state.Enabled or generation ~= token or remote ~= selected
					or not snapshot or key(snapshot) ~= shotKey or not ready(snapshot)
			end
			local ok, plan, reason = pcall(state.PlanSnapshot, selectedState, selected, cancelled)
			state.Thinking = false
			if cancelled() then return end
			if not ok then state.Error = tostring(plan) pause("계산 오류: " .. state.Error) return end
			if not plan then setStatus(reason or "가능한 타격을 찾지 못했습니다") return end
			state.LastPlan = plan
			if preview.Enabled then
				preview.DrawPlan(physicsFor(selectedState, selected), selectedState.balls, selectedState.PoolMode and 1 or selectedState.turn, plan)
			end
			setStatus("목표 방향으로 부드럽게 조준 중")
			local aimOK, aimed = pcall(state.AnimateAim, plan, selectedState, selected, cancelled)
			if not aimOK then smoothStage = nil state.Error = tostring(aimed) pause("조준 이동 오류: " .. state.Error) return end
			if not aimed or cancelled() then smoothStage = nil return end

			smoothStage = nil
			attempted = shotKey
			pending = {round = snapshot.round, turnId = snapshot.turnId, shots = snapshot.shots or 0, at = os.clock()}
			local sent, err = pcall(function()
				selected:FireServer("shoot", {turnId = snapshot.turnId, angle = plan.angle,
					power = plan.power, side = plan.side, top = plan.top, cue = plan.cue,
					impactAt = workspace:GetServerTimeNow() + (cueMotion.StrokeTime or 0.18)})
			end)
			if not sent then state.Error = tostring(err) pause("타격 전송 오류: " .. state.Error) return end
			state.ShotsSent = state.ShotsSent + 1
			setStatus(string.format("타격 전송 %d회 · 서버 확인 대기", state.ShotsSent))
		end)
	end
	preview.OnPoolGuide = function(data)
		if not snapshot or not snapshot.PoolMode or snapshot.LocalMoving or not data or not data.start or not data.contact then return end
		local direction = data.contact - data.start
		if direction.Magnitude < 0.0001 then return end
		local cueLength = data.cueLine and (data.cueLine[2] - data.cueLine[1]).Magnitude or 0
		local objectLength = data.objectLine and (data.objectLine[2] - data.objectLine[1]).Magnitude or 0
		local power = math.clamp(math.sqrt(cueLength * cueLength + objectLength * objectLength) / (6 * poolPhysics.Config.Radius), 0.05, 1)
		local plan = {angle = math.atan2(direction.Z, direction.X), power = power, side = 0, top = 0,
			cue = {data.start.X, data.start.Z}, BreakBoost = snapshot.breakShot and poolPhysics.Config.BreakBoost or 1}
		preview.DrawPlan(poolPhysics, snapshot.balls, 1, plan)
		preview.HoldUntil = 0
	end
	env.BilliardsAuto = state
	env.BilliardsSuite = state
	local ok, err = pcall(function()
		local UI = createUI()
		window = UI:CreateWindow({Id = "billiards-suite", Title = "당구 통합 도우미",
			Subtitle = "포켓볼·3구·4구 자동 감지 · 예상 경로 · 자동 플레이", Theme = "CodexDark", Locale = "ko",
			CloseBehavior = "Minimize", Width = 540, Height = 540})
		local section = window:Tab({Id = "main", Title = "당구 도우미"}):Section({Title = "경로 표시와 자동 플레이"})
		modeLabel = section:Label({Id = "mode", Text = "포켓볼·3구·4구 모드 확인 중"})
		section:Toggle({Id = "preview", Text = "예상 경로 표시", Default = true, Persist = false, Callback = preview.SetEnabled})
		toggle = section:Toggle({Id = "enabled", Text = "자동 플레이", Default = false,
			Persist = false, Callback = state.SetEnabled})
		section:Label({Id = "shot-policy", Text = "득점·다음 수·수비를 비교 · 검증된 유효 타격 실행"})
		section:Toggle({Id = "strong-play", Text = "다음 수와 수비까지 비교", Default = true, Persist = false,
			Callback = function(v) state.StrongPlay = v == true end})
		section:Label({Id = "pool-preview-info", Text = "자동 경로는 힘·회전 반영 · 수동 포켓볼 경로는 가이드 기반 근사"})
		section:Toggle({Id = "smooth-cue", Text = "큐대 부드럽게 이동", Default = true, Persist = false,
			Callback = function(v) state.SmoothCue = v == true end})
		section:Toggle({Id = "human-thinking", Text = "방향을 고민하는 동작", Default = true, Persist = false,
			Callback = function(v) state.HumanThinking = v == true end})
		statusLabel = section:Label({Id = "status", Text = state.Status})
		statsLabel = section:Label({Id = "stats", Text = "타격 0회 · 서버 확인 0회"})
		section:Button({Id = "sync", Text = "경기 상태 다시 조회", ActionText = "조회",
			Callback = function() if remote then lastSync = os.clock() remote:FireServer("sync") end end})
		section:Button({Id = "stop", Text = "완전히 종료", ActionText = "종료", Callback = state.Stop})
		state.Window = window
		window:OnDestroy(state.Stop)
	end)
	if not ok then state.UIError = tostring(err) warn("자동 플레이 창 오류: " .. state.UIError) end
	heartbeat = runService.Heartbeat:Connect(function()
		local ok, err = pcall(tick)
		if not ok then state.Error = tostring(err) pause("자동 플레이 오류: " .. state.Error) end
	end)
	tick()
	print("당구 통합 도우미 준비 완료: 포켓볼·3구·4구 자동 감지, 예상 경로 표시 켜짐, 자동 플레이 꺼짐")
	return state
end
local preview = startPreview()
local ok, suite = pcall(startAuto, preview)
if not ok then preview.Stop() error(suite) end
return suite
