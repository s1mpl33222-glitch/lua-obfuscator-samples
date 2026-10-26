-- DeaDx 1.0.0
-- UI library by ServerDead
-- Built 2026-10-26 16:18

local __clock = os.clock()
local __modules = {}

__modules["Core/Signal"] = (function()
return function(import)
	local Signal = {}
	Signal.__index = Signal

	local Connection = {}
	Connection.__index = Connection

	function Connection:Disconnect()
		if not self.Connected then
			return
		end
		self.Connected = false
		local handlers = self._signal._handlers
		local index = table.find(handlers, self)
		if index then
			table.remove(handlers, index)
		end
	end
	Connection.Destroy = Connection.Disconnect

	function Signal.new()
		return setmetatable({ _handlers = {}, _destroyed = false }, Signal)
	end

	function Signal:Connect(callback)
		assert(type(callback) == "function", "[DEADX] Signal:Connect expects a function")
		local connection = setmetatable({
			Connected = not self._destroyed,
			_callback = callback,
			_signal = self,
		}, Connection)
		if not self._destroyed then
			table.insert(self._handlers, connection)
		end
		return connection
	end

	function Signal:Once(callback)
		local connection
		connection = self:Connect(function(...)
			connection:Disconnect()
			callback(...)
		end)
		return connection
	end

	function Signal:Fire(...)
		if self._destroyed then
			return
		end
		for _, connection in table.clone(self._handlers) do
			if connection.Connected then
				task.spawn(connection._callback, ...)
			end
		end
	end

	function Signal:FireSync(...)
		if self._destroyed then
			return
		end
		for _, connection in table.clone(self._handlers) do
			if connection.Connected then
				connection._callback(...)
			end
		end
	end

	function Signal:Wait()
		local thread = coroutine.running()
		local connection
		connection = self:Connect(function(...)
			connection:Disconnect()
			task.spawn(thread, ...)
		end)
		return coroutine.yield()
	end

	function Signal:Count()
		return #self._handlers
	end

	function Signal:Destroy()
		self._destroyed = true
		for _, connection in self._handlers do
			connection.Connected = false
		end
		table.clear(self._handlers)
	end

	return Signal
end
end)()

__modules["Core/State"] = (function()
return function(import)
	local Signal = import("Core/Signal")

	local State = {}
	State.__index = State

	function State.new(value)
		return setmetatable({ _value = value, Changed = Signal.new() }, State)
	end

	function State:Get()
		return self._value
	end

	function State:Set(value, silent)
		if self._value == value and type(value) ~= "table" then
			return
		end
		self._value = value
		if not silent then
			self.Changed:Fire(value)
		end
	end

	function State:Update(transform)
		self:Set(transform(self._value))
	end

	function State:OnChanged(callback)
		return self.Changed:Connect(callback)
	end

	function State:Destroy()
		self.Changed:Destroy()
	end

	return State
end
end)()

__modules["Core/Capabilities"] = (function()
return function(import)
	local UserInputService = game:GetService("UserInputService")
	local RunService = game:GetService("RunService")

	local env = {}
	pcall(function()
		env = getfenv(1)
	end)

	local function lookup(...)
		for _, name in { ... } do
			local value = rawget(env, name) or env[name]
			if type(value) == "function" then
				return value
			end
		end
		return nil
	end

	local Capabilities = {}

	Capabilities.Studio = RunService:IsStudio()
	Capabilities.GetHui = lookup("gethui")
	Capabilities.ProtectGui = lookup("protectgui") or (type(env.syn) == "table" and env.syn.protect_gui or nil)
	Capabilities.GetCustomAsset = lookup("getcustomasset", "getsynasset")
	Capabilities.Identity = lookup("getidentity", "getthreadidentity")

	local requestFn = lookup("request", "http_request")
	if not requestFn and type(env.syn) == "table" then
		requestFn = env.syn.request
	end
	Capabilities.Request = requestFn

	local okGet, httpGet = pcall(function()
		return game.HttpGet
	end)
	local hasHttpGet = okGet and httpGet ~= nil
	Capabilities.Http = hasHttpGet or requestFn ~= nil

	local fs = {
		Write = lookup("writefile"),
		Append = lookup("appendfile"),
		Read = lookup("readfile"),
		IsFile = lookup("isfile"),
		Delete = lookup("delfile"),
		MakeFolder = lookup("makefolder"),
		IsFolder = lookup("isfolder"),
		DeleteFolder = lookup("delfolder"),
		List = lookup("listfiles"),
	}
	Capabilities.FS = fs
	Capabilities.FileSystem = fs.Write ~= nil and fs.Read ~= nil and fs.IsFile ~= nil and fs.MakeFolder ~= nil and fs.IsFolder ~= nil

	local clipboard = lookup("setclipboard", "toclipboard")
	Capabilities.Clipboard = clipboard ~= nil
	Capabilities.Drawing = env.Drawing ~= nil
	Capabilities.Touch = UserInputService.TouchEnabled
	Capabilities.Keyboard = UserInputService.KeyboardEnabled
	Capabilities.Mobile = not Capabilities.Studio
		and table.find({ Enum.Platform.IOS, Enum.Platform.Android }, UserInputService:GetPlatform()) ~= nil

	function Capabilities.SetClipboard(text)
		if not clipboard then
			return false
		end
		return (pcall(clipboard, text))
	end

	function Capabilities.HttpGet(url)
		if requestFn then
			local ok, response = pcall(requestFn, { Url = url, Method = "GET" })
			if ok and type(response) == "table" then
				local code = response.StatusCode or response.Status
				if response.Success or code == 200 then
					return true, response.Body
				end
				return false, "status " .. tostring(code)
			end
		end
		if hasHttpGet then
			local ok, body = pcall(function()
				return game:HttpGet(url)
			end)
			if ok then
				return true, body
			end
			return false, tostring(body)
		end
		return false, "no http capability"
	end

	local cachedHwid
	function Capabilities.Hwid()
		if cachedHwid then
			return cachedHwid
		end
		local fn = lookup("gethwid", "get_hwid")
		if fn then
			local ok, value = pcall(fn)
			if ok and type(value) == "string" and value ~= "" then
				cachedHwid = value
				return cachedHwid
			end
		end
		local ok, value = pcall(function()
			return game:GetService("RbxAnalyticsService"):GetClientId()
		end)
		if ok and type(value) == "string" and value ~= "" then
			cachedHwid = value
			return cachedHwid
		end
		local player = game:GetService("Players").LocalPlayer
		cachedHwid = "uid-" .. tostring(player and player.UserId or 0)
		return cachedHwid
	end

	function Capabilities.EnsureFolder(path)
		if not Capabilities.FileSystem then
			return false
		end
		local built = ""
		for part in string.gmatch(path, "[^/\\]+") do
			built = built == "" and part or (built .. "/" .. part)
			if not fs.IsFolder(built) then
				local ok = pcall(fs.MakeFolder, built)
				if not ok then
					return false
				end
			end
		end
		return true
	end

	return Capabilities
end
end)()

__modules["Core/Utility"] = (function()
return function(import)
	local Players = game:GetService("Players")
	local CoreGui = game:GetService("CoreGui")
	local Capabilities = import("Core/Capabilities")

	local Utility = { Debug = false, Root = "DeaDx" }

	local EARLY = { "RichText", "FontFace", "TextSize", "TextWrapped", "TextTruncate", "TextScaled" }
	local LATE = { AutomaticSize = true, Parent = true }

	function Utility.Create(class, props, children)
		local instance = Instance.new(class)
		if instance:IsA("GuiObject") then
			instance.BorderSizePixel = 0
		end
		if instance:IsA("GuiButton") then
			instance.AutoButtonColor = false
		end
		if instance:IsA("TextLabel") or instance:IsA("TextButton") or instance:IsA("TextBox") then
			instance.Text = ""
		end
		props = props or {}
		local applied = {}
		for _, key in EARLY do
			if props[key] ~= nil then
				instance[key] = props[key]
				applied[key] = true
			end
		end
		for key, value in props do
			if not applied[key] and not LATE[key] then
				instance[key] = value
			end
		end
		for _, child in children or {} do
			child.Parent = instance
		end
		if props.AutomaticSize ~= nil then
			instance.AutomaticSize = props.AutomaticSize
		end
		instance.Parent = props.Parent
		return instance
	end

	function Utility.Log(...)
		if Utility.Debug then
			print("[DEADX]", ...)
		end
	end

	function Utility.Warn(message)
		warn("[DEADX][WARN] " .. tostring(message))
	end

	function Utility.Format(kind, name, reason)
		return string.format('[DEADX][ERROR]\nFailed to create %s "%s":\n%s', kind, tostring(name or "?"), tostring(reason))
	end

	function Utility.Fail(kind, name, reason)
		error(Utility.Format(kind, name, reason), 0)
	end

	function Utility.Check(condition, kind, name, reason)
		if not condition then
			Utility.Fail(kind, name, reason)
		end
	end

	function Utility.SafeCall(label, callback, ...)
		if type(callback) ~= "function" then
			return false
		end
		local ok = xpcall(callback, function(err)
			warn(string.format("[DEADX][ERROR] Callback error in %s:\n%s", label, Utility.Debug and debug.traceback(tostring(err), 2) or tostring(err)))
		end, ...)
		return ok
	end

	function Utility.Round(value, decimals)
		local m = 10 ^ (decimals or 0)
		return math.floor(value * m + 0.5) / m
	end

	function Utility.Map(value, inMin, inMax, outMin, outMax)
		if inMax == inMin then
			return outMin
		end
		return (value - inMin) * (outMax - outMin) / (inMax - inMin) + outMin
	end

	function Utility.DeepCopy(value)
		if type(value) ~= "table" then
			return value
		end
		local out = {}
		for k, v in value do
			out[k] = Utility.DeepCopy(v)
		end
		return out
	end

	function Utility.ToHex(color)
		return string.format(
			"#%02X%02X%02X",
			math.floor(color.R * 255 + 0.5),
			math.floor(color.G * 255 + 0.5),
			math.floor(color.B * 255 + 0.5)
		)
	end

	function Utility.FromHex(text)
		text = string.gsub(tostring(text), "^#", "")
		if #text == 3 then
			text = string.gsub(text, ".", "%0%0")
		end
		if #text ~= 6 or string.find(text, "%X") then
			return nil
		end
		return Color3.fromRGB(
			tonumber(string.sub(text, 1, 2), 16),
			tonumber(string.sub(text, 3, 4), 16),
			tonumber(string.sub(text, 5, 6), 16)
		)
	end

	function Utility.Hash(text)
		if type(text) ~= "string" then
			return "00000000000000000000"
		end
		local a, b = 5381, 52711
		local length = #text
		for index = 1, length do
			local byte = string.byte(text, index)
			a = (a * 33 + byte) % 4294967296
			b = (b * 31 + byte * index) % 4294967296
		end
		return string.format("%08x%08x%04x", a, b, length % 65536)
	end

	function Utility.Slug(text)
		text = string.lower(tostring(text))
		text = string.gsub(text, "[^%w%-_%.]+", "-")
		text = string.gsub(text, "%-+", "-")
		text = string.gsub(text, "^%-", "")
		text = string.gsub(text, "%-$", "")
		if text == "" then
			text = "icon"
		end
		return string.sub(text, 1, 72)
	end

	function Utility.Kebab(text)
		text = string.gsub(tostring(text), "(%l%d)(%u)", "%1-%2")
		text = string.gsub(text, "(%u)(%u%l)", "%1-%2")
		text = string.gsub(text, "[%s_]+", "-")
		return string.lower(text)
	end

	function Utility.Clamp(value, min, max)
		return math.max(min, math.min(max, value))
	end

	function Utility.GetGuiParent()
		if Capabilities.GetHui then
			local ok, hui = pcall(Capabilities.GetHui)
			if ok and hui then
				return hui
			end
		end
		local ok = pcall(function()
			local probe = Instance.new("Folder")
			probe.Parent = CoreGui
			probe:Destroy()
		end)
		if ok then
			return CoreGui
		end
		local player = Players.LocalPlayer
		return player and player:FindFirstChildOfClass("PlayerGui")
	end

	function Utility.NewScreenGui(name, order)
		local parent = Utility.GetGuiParent()
		if not parent then
			error("[DEADX][ERROR] No GUI parent available (PlayerGui not found).", 0)
		end
		local gui = Instance.new("ScreenGui")
		gui.Name = name
		gui.ResetOnSpawn = false
		gui.IgnoreGuiInset = false
		gui.DisplayOrder = order or 100
		gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		gui:SetAttribute("DeaDx", true)
		if Capabilities.ProtectGui then
			pcall(Capabilities.ProtectGui, gui)
		end
		gui.Parent = parent
		return gui
	end

	return Utility
end
end)()

__modules["Core/Markup"] = (function()
return function(import)
	local Markup = { Enabled = true }

	local NAMED = {
		black = "#000000",
		white = "#FFFFFF",
		red = "#FF5555",
		darkred = "#AA0000",
		green = "#55FF55",
		darkgreen = "#00AA00",
		lime = "#A3E635",
		blue = "#5555FF",
		darkblue = "#0000AA",
		aqua = "#55FFFF",
		cyan = "#22D3EE",
		teal = "#14B8A6",
		darkaqua = "#00AAAA",
		yellow = "#FACC15",
		gold = "#FFAA00",
		orange = "#FB923C",
		purple = "#A855F7",
		darkpurple = "#AA00AA",
		violet = "#8B5CF6",
		magenta = "#FF55FF",
		pink = "#F472B6",
		rose = "#FB7185",
		brown = "#AA5500",
		gray = "#AAAAAA",
		grey = "#AAAAAA",
		darkgray = "#555555",
		darkgrey = "#555555",
		silver = "#D4D4D8",
		slate = "#64748B",
		indigo = "#6366F1",
		emerald = "#34D399",
		amber = "#FBBF24",
		crimson = "#DC2626",
		mint = "#6EE7B7",
		sky = "#38BDF8",
		deadx = "#FF2D40",
	}

	local STYLES = {
		b = "b",
		bold = "b",
		i = "i",
		italic = "i",
		em = "i",
		u = "u",
		underline = "u",
		underlined = "u",
		s = "s",
		strike = "s",
		strikethrough = "s",
	}

	function Markup.RegisterColor(name, hex)
		if type(name) == "string" and type(hex) == "string" then
			NAMED[string.lower(name)] = hex
		end
	end

	function Markup.Colors()
		local out = {}
		for name in NAMED do
			table.insert(out, name)
		end
		table.sort(out)
		return out
	end

	local function toHex(value)
		if typeof(value) == "Color3" then
			return string.format(
				"#%02X%02X%02X",
				math.floor(value.R * 255 + 0.5),
				math.floor(value.G * 255 + 0.5),
				math.floor(value.B * 255 + 0.5)
			)
		end
		if type(value) ~= "string" then
			return nil
		end
		local text = string.gsub(value, "^#", "")
		if #text == 3 and not string.find(text, "%X") then
			text = string.gsub(text, ".", "%0%0")
		end
		if #text == 6 and not string.find(text, "%X") then
			return "#" .. string.upper(text)
		end
		return NAMED[string.lower(value)]
	end
	Markup.ToHex = toHex

	local function channels(hex)
		return tonumber(string.sub(hex, 2, 3), 16) or 0,
			tonumber(string.sub(hex, 4, 5), 16) or 0,
			tonumber(string.sub(hex, 6, 7), 16) or 0
	end

	local function mix(a, b, alpha)
		local r1, g1, b1 = channels(a)
		local r2, g2, b2 = channels(b)
		return string.format(
			"#%02X%02X%02X",
			math.floor(r1 + (r2 - r1) * alpha + 0.5),
			math.floor(g1 + (g2 - g1) * alpha + 0.5),
			math.floor(b1 + (b2 - b1) * alpha + 0.5)
		)
	end

	local function sample(stops, alpha)
		alpha = math.clamp(alpha, 0, 1)
		if #stops == 1 then
			return stops[1]
		end
		local segments = #stops - 1
		local scaled = alpha * segments
		local index = math.min(math.floor(scaled), segments - 1)
		return mix(stops[index + 1], stops[index + 2], scaled - index)
	end

	local function units(content)
		local list = {}
		local position = 1
		local length = #content
		while position <= length do
			local char = string.sub(content, position, position)
			if char == "<" then
				local close = string.find(content, ">", position, true)
				if close then
					table.insert(list, { tag = string.sub(content, position, close) })
					position = close + 1
					continue
				end
			elseif char == "&" then
				local close = string.find(content, ";", position, true)
				if close and close - position <= 8 then
					table.insert(list, { text = string.sub(content, position, close) })
					position = close + 1
					continue
				end
			end
			table.insert(list, { text = char })
			position += 1
		end
		return list
	end

	local function paint(content, pick)
		local parts = units(content)
		local total = 0
		for _, part in parts do
			if part.text and part.text ~= "\n" then
				total += 1
			end
		end
		if total == 0 then
			return content
		end
		local out, run, runColor = {}, "", nil
		local index = 0

		local function flush()
			if run ~= "" then
				if runColor then
					table.insert(out, string.format('<font color="%s">%s</font>', runColor, run))
				else
					table.insert(out, run)
				end
				run, runColor = "", nil
			end
		end

		for _, part in parts do
			if part.tag then
				flush()
				table.insert(out, part.tag)
			elseif part.text == "\n" then
				flush()
				table.insert(out, part.text)
			else
				local color = pick(total <= 1 and 0 or index / (total - 1), index, total)
				if color ~= runColor then
					flush()
					runColor = color
				end
				run ..= part.text
				index += 1
			end
		end
		flush()
		return table.concat(out)
	end

	local function gradient(spec, content)
		local stops = {}
		for token in string.gmatch(spec, "[^:,%s]+") do
			local hex = toHex(token)
			if hex then
				table.insert(stops, hex)
			end
		end
		if #stops == 0 then
			return content
		end
		return paint(content, function(alpha)
			return sample(stops, alpha)
		end)
	end

	local function rainbow(spec, content)
		local saturation = tonumber(string.match(spec or "", "s(%d+%.?%d*)")) or 0.85
		local offset = tonumber(string.match(spec or "", "o(%d+%.?%d*)")) or 0
		return paint(content, function(alpha)
			local color = Color3.fromHSV((offset + alpha * 0.85) % 1, math.clamp(saturation, 0, 1), 1)
			return toHex(color)
		end)
	end

	function Markup.Has(text)
		return type(text) == "string" and string.find(text, "<[^>]+>") ~= nil
	end

	function Markup.Parse(text)
		if not Markup.Enabled or type(text) ~= "string" or text == "" then
			return text
		end
		if not string.find(text, "<[^>]+>") then
			return text
		end

		local result = string.gsub(text, "<br%s*/?>", "\n")
		result = string.gsub(result, "<newline>", "\n")
		result = string.gsub(result, "<nl>", "\n")

		for _ = 1, 8 do
			local replaced, count = string.gsub(result, "<gradient:([^>]+)>(.-)</gradient>", gradient)
			result = replaced
			if count == 0 then
				break
			end
		end

		for _ = 1, 4 do
			local replaced, count = string.gsub(result, "<rainbow:?([^>]*)>(.-)</rainbow>", rainbow)
			result = replaced
			if count == 0 then
				break
			end
		end

		result = string.gsub(result, "<color:([^>]+)>", function(token)
			local hex = toHex(token)
			return hex and string.format('<font color="%s">', hex) or ""
		end)
		result = string.gsub(result, "</color>", "</font>")

		result = string.gsub(result, "<(#?%x%x%x%x%x%x)>", function(token)
			local hex = toHex(token)
			return hex and string.format('<font color="%s">', hex) or ""
		end)
		result = string.gsub(result, "</#?%x%x%x%x%x%x>", "</font>")

		result = string.gsub(result, "<size:(%d+)>", '<font size="%1">')
		result = string.gsub(result, "</size>", "</font>")
		result = string.gsub(result, "<fade:(%d*%.?%d+)>", '<font transparency="%1">')
		result = string.gsub(result, "</fade>", "</font>")
		result = string.gsub(result, "<stroke:([^>]+)>", function(token)
			local hex = toHex(token)
			return hex and string.format('<stroke color="%s" thickness="1">', hex) or ""
		end)

		result = string.gsub(result, "<(/?)(%a+)>", function(slash, name)
			local style = STYLES[string.lower(name)]
			if style then
				return "<" .. slash .. style .. ">"
			end
			local hex = NAMED[string.lower(name)]
			if hex then
				return slash == "/" and "</font>" or string.format('<font color="%s">', hex)
			end
			return "<" .. slash .. name .. ">"
		end)

		result = string.gsub(result, "<reset>", "</font></b></i></u></s>")
		result = string.gsub(result, '<font color="[^"]*"></font>', "")
		return result
	end

	function Markup.Strip(text)
		if type(text) ~= "string" then
			return text
		end
		local result = string.gsub(text, "<br%s*/?>", " ")
		result = string.gsub(result, "<[^>]+>", "")
		result = string.gsub(result, "&lt;", "<")
		result = string.gsub(result, "&gt;", ">")
		result = string.gsub(result, "&quot;", '"')
		result = string.gsub(result, "&apos;", "'")
		result = string.gsub(result, "&amp;", "&")
		return result
	end

	function Markup.Escape(text)
		if type(text) ~= "string" then
			return text
		end
		local result = string.gsub(text, "&", "&amp;")
		result = string.gsub(result, "<", "&lt;")
		result = string.gsub(result, ">", "&gt;")
		return result
	end

	function Markup.Color(value, text)
		local hex = toHex(value)
		if not hex then
			return text
		end
		return string.format("<color:%s>%s</color>", hex, text)
	end

	function Markup.Gradient(stops, text)
		local tokens = {}
		for _, stop in stops do
			local hex = toHex(stop)
			if hex then
				table.insert(tokens, hex)
			end
		end
		if #tokens == 0 then
			return text
		end
		return string.format("<gradient:%s>%s</gradient>", table.concat(tokens, ":"), text)
	end

	return Markup
end
end)()

__modules["Core/Theme"] = (function()
return function(import)
	local Signal = import("Core/Signal")
	local Default = import("Themes/Default")

	local ALIASES = {
		Secondary = "SecondaryBackground",
		Tertiary = "TertiaryBackground",
		SubText = "MutedText",
		Element = "SecondaryBackground",
		Stroke = "Border",
	}

	local Theme = {
		Changed = Signal.new(),
		ScaleChanged = Signal.new(),
		Scale = 1,
	}

	local themes = {}
	local order = {}
	local current = "DeaDx"

	local function applyFont(font)
		Theme.Font = font
		Theme.FontBold = Font.new(font.Family, Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
		Theme.FontHeavy = Font.new(font.Family, Enum.FontWeight.Bold, Enum.FontStyle.Normal)
	end
	applyFont(Font.fromEnum(Enum.Font.GothamMedium))

	function Theme.Register(name, definition)
		if type(name) ~= "string" or type(definition) ~= "table" then
			error("[DEADX][ERROR] Theme.Register expects (name: string, definition: table)", 2)
		end
		local base = definition.Base and themes[definition.Base] or Default
		local merged = table.clone(base)
		for key, value in definition do
			if key ~= "Base" and key ~= "Name" then
				key = ALIASES[key] or key
				local expected = Default[key]
				if expected ~= nil and typeof(expected) ~= typeof(value) then
					error(string.format('[DEADX][ERROR] Theme "%s": token "%s" must be %s', name, key, typeof(expected)), 2)
				end
				merged[key] = value
			end
		end
		if not themes[name] then
			table.insert(order, name)
		end
		themes[name] = merged
		if name == current then
			Theme.Changed:Fire(current)
		end
	end

	function Theme.Set(name, force)
		if Theme.Locked and not force then
			return false, "theme is locked"
		end
		if type(name) == "table" then
			local custom = name.Name or "Custom"
			Theme.Register(custom, name)
			name = custom
		end
		if not themes[name] then
			warn(string.format('[DEADX][WARN] Theme "%s" is not registered.', tostring(name)))
			return false
		end
		current = name
		Theme.Changed:Fire(name)
		return true
	end

	function Theme.Lock(name)
		Theme.Locked = false
		if name ~= nil then
			Theme.Set(name, true)
		end
		Theme.Locked = true
		return current
	end

	function Theme.Unlock()
		Theme.Locked = false
		return current
	end

	function Theme.IsLocked()
		return Theme.Locked == true
	end

	function Theme.GetName()
		return current
	end

	function Theme.Names()
		return table.clone(order)
	end

	function Theme.Has(name)
		return themes[name] ~= nil
	end

	function Theme.Get(token)
		token = ALIASES[token] or token
		local active = themes[current]
		local value = active and active[token]
		if value == nil then
			value = Default[token]
		end
		return value
	end

	function Theme.Resolve(value, fallback)
		if value == nil then
			return fallback and Theme.Get(fallback) or nil
		end
		if typeof(value) == "Color3" then
			return value
		end
		if type(value) == "string" then
			local token = Theme.Get(value)
			if typeof(token) == "Color3" then
				return token
			end
			local hex = string.gsub(value, "^#", "")
			if #hex == 3 then
				hex = string.gsub(hex, ".", "%0%0")
			end
			if #hex == 6 and not string.find(hex, "%X") then
				return Color3.fromRGB(
					tonumber(string.sub(hex, 1, 2), 16),
					tonumber(string.sub(hex, 3, 4), 16),
					tonumber(string.sub(hex, 5, 6), 16)
				)
			end
		end
		return fallback and Theme.Get(fallback) or nil
	end

	function Theme.BindFn(callback, cleanup)
		callback()
		local connection = Theme.Changed:Connect(callback)
		if cleanup then
			cleanup:Add(connection)
		end
		return connection
	end

	function Theme.Bind(instance, map, cleanup)
		return Theme.BindFn(function()
			for property, token in map do
				if type(token) == "function" then
					instance[property] = token(Theme)
				else
					instance[property] = Theme.Get(token)
				end
			end
		end, cleanup)
	end

	function Theme.SetFont(font)
		if typeof(font) == "EnumItem" then
			applyFont(Font.fromEnum(font))
		elseif typeof(font) == "Font" then
			applyFont(font)
		elseif type(font) == "string" then
			applyFont(Font.new(font, Enum.FontWeight.Medium, Enum.FontStyle.Normal))
		else
			error("[DEADX][ERROR] SetFont expects an Enum.Font, a Font or a font asset id", 2)
		end
		Theme.Changed:Fire(current)
	end

	function Theme.SetScale(scale, force)
		if type(scale) ~= "number" then
			error("[DEADX][ERROR] SetScale expects a number", 2)
		end
		if Theme.ScaleLocked and not force then
			return false, "scale is locked"
		end
		Theme.Scale = math.clamp(scale, 0.5, 2)
		Theme.ScaleChanged:Fire(Theme.Scale)
		return true
	end

	function Theme.LockScale(scale)
		Theme.ScaleLocked = false
		if scale ~= nil then
			Theme.SetScale(scale, true)
		end
		Theme.ScaleLocked = true
		return Theme.Scale
	end

	function Theme.UnlockScale()
		Theme.ScaleLocked = false
		return Theme.Scale
	end

	function Theme.IsScaleLocked()
		return Theme.ScaleLocked == true
	end

	function Theme.BindScale(uiScale, cleanup)
		uiScale.Scale = Theme.Scale
		local connection = Theme.ScaleChanged:Connect(function(value)
			uiScale.Scale = value
		end)
		if cleanup then
			cleanup:Add(connection)
		end
		return connection
	end

	function Theme.Override(token, value)
		local active = themes[current]
		if active then
			active[ALIASES[token] or token] = value
			Theme.Changed:Fire(current)
		end
	end

	return Theme
end
end)()

__modules["Core/Config"] = (function()
return function(import)
	local HttpService = game:GetService("HttpService")
	local State = import("Core/State")
	local Signal = import("Core/Signal")
	local Utility = import("Core/Utility")
	local Capabilities = import("Core/Capabilities")

	local Config = {
		Folder = "DeaDx/configs",
		Changed = Signal.new(),
		AutoSave = false,
		AutoSaveName = "autosave",
		History = 120,
		_states = {},
		_defaults = {},
		_connections = {},
		_previous = {},
		_history = {},
		_cursor = 0,
		_silent = false,
		_queued = false,
	}

	local function queueAutoSave()
		if not Config.AutoSave or Config._queued then
			return
		end
		Config._queued = true
		task.delay(0.5, function()
			Config._queued = false
			if Config.AutoSave then
				pcall(function()
					Config:Save(Config.AutoSaveName)
				end)
			end
		end)
	end

	function Config:_Record(key, value)
		local old = self._previous[key]
		self._previous[key] = Utility.DeepCopy(value)
		if self._silent or self.History <= 0 then
			return
		end
		for index = #self._history, self._cursor + 1, -1 do
			table.remove(self._history, index)
		end
		table.insert(self._history, { Key = key, Old = old, New = Utility.DeepCopy(value) })
		while #self._history > self.History do
			table.remove(self._history, 1)
		end
		self._cursor = #self._history
	end

	function Config:Register(key, default)
		local state = self._states[key]
		if not state then
			state = State.new(default)
			self._states[key] = state
			self._previous[key] = Utility.DeepCopy(default)
			self._connections[key] = state.Changed:Connect(function(value)
				self:_Record(key, value)
				self.Changed:Fire(key, value)
				queueAutoSave()
			end)
		end
		if self._defaults[key] == nil then
			self._defaults[key] = Utility.DeepCopy(default)
		end
		return state
	end

	function Config:_Apply(key, value)
		local state = self._states[key]
		if not state then
			return false
		end
		self._silent = true
		state:Set(Utility.DeepCopy(value))
		self._silent = false
		return true
	end

	function Config:CanUndo()
		return self._cursor > 0
	end

	function Config:CanRedo()
		return self._cursor < #self._history
	end

	function Config:Undo()
		if self._cursor <= 0 then
			return false
		end
		local entry = self._history[self._cursor]
		self._cursor -= 1
		if not entry then
			return false
		end
		self:_Apply(entry.Key, entry.Old)
		return true, entry.Key
	end

	function Config:Redo()
		if self._cursor >= #self._history then
			return false
		end
		self._cursor += 1
		local entry = self._history[self._cursor]
		if not entry then
			return false
		end
		self:_Apply(entry.Key, entry.New)
		return true, entry.Key
	end

	function Config:ClearHistory()
		table.clear(self._history)
		self._cursor = 0
		return self
	end

	function Config:Set(key, value)
		assert(type(key) == "string", "[DEADX] Config key must be a string")
		local state = self._states[key]
		if not state then
			state = self:Register(key, nil)
		end
		state:Set(value)
	end

	function Config:Get(key)
		local state = self._states[key]
		return state and state:Get()
	end

	function Config:Has(key)
		return self._states[key] ~= nil
	end

	function Config:Keys()
		local out = {}
		for key in self._states do
			table.insert(out, key)
		end
		table.sort(out)
		return out
	end

	function Config:Export()
		local out = {}
		for key, state in self._states do
			out[key] = Utility.DeepCopy(state:Get())
		end
		return out
	end

	function Config:Import(data)
		assert(type(data) == "table", "[DEADX] Config:Import expects a table")
		for key, value in data do
			self:Set(key, Utility.DeepCopy(value))
		end
	end

	function Config:Reset()
		for key, state in self._states do
			state:Set(Utility.DeepCopy(self._defaults[key]))
		end
	end

	function Config:Wipe()
		for _, connection in self._connections do
			connection:Disconnect()
		end
		table.clear(self._connections)
		for _, state in self._states do
			state:Destroy()
		end
		table.clear(self._states)
		table.clear(self._defaults)
	end

	local function encode(value)
		local kind = typeof(value)
		if kind == "Color3" then
			return { __t = "Color3", R = value.R, G = value.G, B = value.B }
		elseif kind == "EnumItem" then
			return { __t = "Enum", Type = tostring(value.EnumType), Name = value.Name }
		elseif kind == "Vector2" then
			return { __t = "Vector2", X = value.X, Y = value.Y }
		elseif kind == "table" then
			local out = {}
			for k, v in value do
				out[k] = encode(v)
			end
			return out
		end
		return value
	end

	local function decode(value)
		if type(value) ~= "table" then
			return value
		end
		if value.__t == "Color3" then
			return Color3.new(value.R, value.G, value.B)
		elseif value.__t == "Enum" then
			local ok, item = pcall(function()
				return Enum[value.Type][value.Name]
			end)
			return ok and item or nil
		elseif value.__t == "Vector2" then
			return Vector2.new(value.X, value.Y)
		end
		local out = {}
		for k, v in value do
			out[k] = decode(v)
		end
		return out
	end

	function Config:Serialize()
		return HttpService:JSONEncode(encode(self:Export()))
	end

	function Config:Deserialize(json)
		local ok, data = pcall(function()
			return decode(HttpService:JSONDecode(json))
		end)
		if not ok then
			return false, "invalid JSON"
		end
		self:Import(data)
		return true
	end

	function Config:Save(name)
		if not Capabilities.FileSystem then
			return false, "FileSystem capability unavailable"
		end
		name = tostring(name or self.AutoSaveName)
		local ok, err = pcall(function()
			Capabilities.EnsureFolder(self.Folder)
			Capabilities.FS.Write(self.Folder .. "/" .. name .. ".json", self:Serialize())
		end)
		return ok, not ok and tostring(err) or nil
	end

	function Config:Load(name)
		if not Capabilities.FileSystem then
			return false, "FileSystem capability unavailable"
		end
		name = tostring(name or self.AutoSaveName)
		local path = self.Folder .. "/" .. name .. ".json"
		if not Capabilities.FS.IsFile(path) then
			return false, "file not found"
		end
		local ok, content = pcall(Capabilities.FS.Read, path)
		if not ok then
			return false, tostring(content)
		end
		return self:Deserialize(content)
	end

	function Config:Delete(name)
		if not Capabilities.FileSystem or not Capabilities.FS.Delete then
			return false, "FileSystem capability unavailable"
		end
		local path = self.Folder .. "/" .. tostring(name) .. ".json"
		if not Capabilities.FS.IsFile(path) then
			return false, "file not found"
		end
		return pcall(Capabilities.FS.Delete, path)
	end

	function Config:List()
		if not Capabilities.FileSystem or not Capabilities.FS.List then
			return {}
		end
		Capabilities.EnsureFolder(self.Folder)
		local ok, files = pcall(Capabilities.FS.List, self.Folder)
		if not ok or type(files) ~= "table" then
			return {}
		end
		local out = {}
		for _, path in files do
			local name = string.match(tostring(path), "([^/\\]+)%.json$")
			if name then
				table.insert(out, name)
			end
		end
		table.sort(out)
		return out
	end

	function Config:SetAutoSave(enabled, name)
		self.AutoSave = enabled == true
		if name then
			self.AutoSaveName = tostring(name)
		end
		if self.AutoSave then
			queueAutoSave()
		end
		return self.AutoSave
	end

	return Config
end
end)()

__modules["Core/Widgets"] = (function()
return function(import)
	local Theme = import("Core/Theme")
	local Utility = import("Core/Utility")
	local Markup = import("Core/Markup")
	local Animation = import("Services/Animation")

	local Widgets = {}

	local TEXT_KEYS = { Color = true, Bold = true, Heavy = true, Class = true, Gradient = true, Markup = true }
	local SURFACE_KEYS = { Fill = true, Stroke = true, Radius = true, Class = true, Transparency = true, Gradient = true, StrokeTransparency = true }

	local function without(props, keys)
		local out = {}
		for key, value in props do
			if not keys[key] then
				out[key] = value
			end
		end
		return out
	end

	local function stops(value)
		if typeof(value) == "ColorSequence" then
			return value
		end
		if type(value) == "table" then
			local keypoints = {}
			local count = #value
			if count == 1 then
				local color = Theme.Resolve(value[1])
				return color and ColorSequence.new(color) or nil
			end
			for index, entry in value do
				local color = Theme.Resolve(entry)
				if not color then
					return nil
				end
				table.insert(keypoints, ColorSequenceKeypoint.new((index - 1) / (count - 1), color))
			end
			return #keypoints >= 2 and ColorSequence.new(keypoints) or nil
		end
		return nil
	end
	Widgets.Stops = stops

	function Widgets.Text(cleanup, props)
		props = props or {}
		local class = props.Class or "TextLabel"
		local raw = without(props, TEXT_KEYS)
		raw.BackgroundTransparency = 1
		raw.TextSize = raw.TextSize or 13
		raw.TextXAlignment = raw.TextXAlignment or Enum.TextXAlignment.Left

		local useMarkup = props.Markup ~= false and class ~= "TextBox"
		local source = raw.Text
		if source == nil then
			source = ""
		end
		if useMarkup then
			raw.Text = Markup.Parse(source)
			if raw.RichText == nil and raw.Text ~= source then
				raw.RichText = true
			end
		else
			raw.Text = source
		end

		local label = Utility.Create(class, raw)
		local colorSource = props.Color or "Text"
		local gradient
		local weight = props.Heavy and "FontHeavy" or (props.Bold and "FontBold" or "Font")

		local handle = { Instance = label, Source = source }

		local function applyColor()
			local sequence = stops(props.Gradient or (typeof(colorSource) == "ColorSequence" and colorSource or nil))
			if type(colorSource) == "table" and not sequence then
				sequence = stops(colorSource)
			end
			if sequence then
				if not gradient then
					gradient = Utility.Create("UIGradient", { Parent = label })
				end
				gradient.Color = sequence
				label.TextColor3 = Color3.new(1, 1, 1)
			else
				if gradient then
					gradient:Destroy()
					gradient = nil
				end
				label.TextColor3 = Theme.Resolve(colorSource, "Text")
			end
		end

		Theme.BindFn(function()
			applyColor()
			label.FontFace = Theme[weight]
			if class == "TextBox" then
				label.PlaceholderColor3 = Theme.Get("MutedText")
			end
		end, cleanup)

		function handle.SetText(value)
			value = value == nil and "" or tostring(value)
			handle.Source = value
			if useMarkup then
				local parsed = Markup.Parse(value)
				if parsed ~= value then
					label.RichText = true
				end
				label.Text = parsed
			else
				label.Text = value
			end
		end

		function handle.SetColor(value)
			colorSource = value or "Text"
			props.Gradient = nil
			applyColor()
		end

		function handle.SetGradient(value)
			props.Gradient = value
			applyColor()
		end

		function handle.SetWeight(value)
			weight = value == "Heavy" and "FontHeavy" or (value == "Bold" and "FontBold" or "Font")
			label.FontFace = Theme[weight]
		end

		return label, handle
	end

	function Widgets.Surface(cleanup, props)
		local raw = without(props, SURFACE_KEYS)
		local fill, strokeToken, radius, transparency = props.Fill, props.Stroke, props.Radius, props.Transparency
		if radius == nil then
			radius = 12
		end
		if fill == nil and transparency == nil and raw.BackgroundTransparency == nil then
			raw.BackgroundTransparency = 1
		end
		local instance = Utility.Create(props.Class or "Frame", raw)
		if radius ~= 0 then
			Utility.Create("UICorner", {
				CornerRadius = radius == "Full" and UDim.new(1, 0) or UDim.new(0, radius),
				Parent = instance,
			})
		end
		local gradient
		if props.Gradient then
			gradient = Utility.Create("UIGradient", { Parent = instance })
		end
		local stroke
		if strokeToken then
			stroke = Utility.Create("UIStroke", {
				Thickness = 1,
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Parent = instance,
			})
		end
		Theme.BindFn(function()
			if fill then
				instance.BackgroundColor3 = Theme.Resolve(fill, "SecondaryBackground")
			end
			if transparency ~= nil then
				instance.BackgroundTransparency = type(transparency) == "number" and transparency or Theme.Get(transparency)
			end
			if gradient then
				local sequence = stops(props.Gradient)
				if sequence then
					gradient.Color = sequence
				end
			end
			if stroke then
				stroke.Color = Theme.Resolve(strokeToken, "Border")
				if props.StrokeTransparency ~= nil then
					stroke.Transparency = type(props.StrokeTransparency) == "number" and props.StrokeTransparency
						or Theme.Get(props.StrokeTransparency)
				end
			end
		end, cleanup)
		return instance, stroke
	end

	function Widgets.Interactive(cleanup, target, trigger, opts)
		opts = opts or {}
		local base = opts.Base or "SecondaryBackground"
		local hoverToken = opts.Hover or "Hover"
		local pressedToken = opts.Pressed or "Pressed"
		local hover, down, enabled = false, false, true
		local handle = {}

		local function apply(instant)
			local color = Theme.Get(base)
			local alpha = opts.Alpha and opts.Alpha[1]
			if enabled and down then
				color = Theme.Get(pressedToken)
				alpha = opts.Alpha and opts.Alpha[3]
			elseif enabled and hover then
				color = Theme.Get(hoverToken)
				alpha = opts.Alpha and opts.Alpha[2]
			end
			local goal = { BackgroundColor3 = color }
			if alpha then
				goal.BackgroundTransparency = alpha
			end
			if instant then
				for property, value in goal do
					target[property] = value
				end
			else
				Animation:Play(target, goal, {
					Duration = down and Animation.Duration.Instant or Animation.Duration.Normal,
					Ease = "Soft",
				})
			end
			if opts.OnState then
				opts.OnState(enabled and hover, enabled and down)
			end
		end

		local function isPress(input)
			return input.UserInputType == Enum.UserInputType.MouseButton1
				or input.UserInputType == Enum.UserInputType.Touch
		end

		cleanup:Add(trigger.MouseEnter:Connect(function()
			hover = true
			apply()
		end))
		cleanup:Add(trigger.MouseLeave:Connect(function()
			hover = false
			down = false
			apply()
		end))
		cleanup:Add(trigger.InputBegan:Connect(function(input)
			if isPress(input) then
				down = true
				apply()
			end
		end))
		cleanup:Add(trigger.InputEnded:Connect(function(input)
			if isPress(input) then
				down = false
				if input.UserInputType == Enum.UserInputType.Touch then
					hover = false
				end
				apply()
			end
		end))
		Theme.BindFn(function()
			apply(true)
		end, cleanup)

		function handle.SetEnabled(value)
			enabled = value
			if not value then
				hover, down = false, false
			end
			apply()
		end
		handle.Refresh = apply
		return handle
	end

	function Widgets.Pulse(instance, amount, duration)
		if not instance or not instance.Parent then
			return nil
		end
		local scale = instance:FindFirstChild("PulseScale")
		if not scale then
			scale = Utility.Create("UIScale", { Name = "PulseScale", Parent = instance })
		end
		Animation:Cancel(scale)
		scale.Scale = amount or 0.9
		Animation:Play(scale, { Scale = 1 }, {
			Duration = duration or 0.28,
			Style = Enum.EasingStyle.Back,
			Direction = Enum.EasingDirection.Out,
		})
		return scale
	end

	function Widgets.Glow(stroke, token, duration)
		if not stroke or not stroke.Parent then
			return
		end
		local resting = stroke.Transparency
		local color = stroke.Color
		Animation:Play(stroke, { Color = Theme.Get(token or "Accent"), Transparency = 0 }, { Duration = 0.1 })
		task.delay(duration or 0.45, function()
			if stroke.Parent then
				Animation:Play(stroke, { Color = color, Transparency = resting }, { Duration = 0.3 })
			end
		end)
	end

	function Widgets.Padding(parent, left, top, right, bottom)
		top = top or left
		return Utility.Create("UIPadding", {
			PaddingLeft = UDim.new(0, left),
			PaddingTop = UDim.new(0, top),
			PaddingRight = UDim.new(0, right or left),
			PaddingBottom = UDim.new(0, bottom or top),
			Parent = parent,
		})
	end

	function Widgets.List(parent, gap, extra)
		local props = {
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, gap or 0),
			Parent = parent,
		}
		for key, value in extra or {} do
			props[key] = value
		end
		return Utility.Create("UIListLayout", props)
	end

	function Widgets.Scroller(cleanup, props)
		local raw = props or {}
		local scroller = Utility.Create("ScrollingFrame", {
			Name = raw.Name or "Scroller",
			BackgroundTransparency = 1,
			Size = raw.Size or UDim2.fromScale(1, 1),
			Position = raw.Position or UDim2.new(),
			CanvasSize = UDim2.new(),
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			ScrollingDirection = Enum.ScrollingDirection.Y,
			ScrollBarThickness = raw.Thickness or 3,
			ScrollBarImageTransparency = 0.4,
			ClipsDescendants = true,
			LayoutOrder = raw.LayoutOrder or 1,
			Visible = raw.Visible ~= false,
			Parent = raw.Parent,
		})
		Theme.BindFn(function()
			scroller.ScrollBarImageColor3 = Theme.Get("MutedText")
		end, cleanup)
		return scroller
	end

	function Widgets.Field(cleanup, props)
		props = props or {}
		local holder, stroke = Widgets.Surface(cleanup, {
			Name = props.Name or "Field",
			Parent = props.Parent,
			Fill = props.Fill or "TertiaryBackground",
			Transparency = props.Transparency or "ElementTransparency",
			Stroke = "Border",
			StrokeTransparency = 0.45,
			Radius = props.Radius or 10,
			Size = props.Size or UDim2.fromScale(1, 1),
			Position = props.Position,
			AnchorPoint = props.AnchorPoint,
			LayoutOrder = props.LayoutOrder,
		})
		local box = Widgets.Text(cleanup, {
			Class = "TextBox",
			Name = "Box",
			Parent = holder,
			Text = props.Text or "",
			PlaceholderText = props.Placeholder or "",
			ClearTextOnFocus = false,
			TextSize = props.TextSize or 12,
			TextXAlignment = props.TextXAlignment or Enum.TextXAlignment.Left,
			TextTruncate = Enum.TextTruncate.AtEnd,
			Position = UDim2.fromOffset(props.Inset or 9, 0),
			Size = UDim2.new(1, -((props.Inset or 9) + (props.Trail or 9)), 1, 0),
		})

		local focused = false
		local function paint(instant)
			local color = Theme.Get(focused and "Accent" or "Border")
			local alpha = focused and 0.15 or 0.45
			if instant then
				stroke.Color = color
				stroke.Transparency = alpha
			else
				Animation:Play(stroke, { Color = color, Transparency = alpha }, { Duration = 0.12 })
			end
		end
		cleanup:Add(box.Focused:Connect(function()
			focused = true
			paint()
		end))
		cleanup:Add(box.FocusLost:Connect(function()
			focused = false
			paint()
		end))

		local handle = {}
		function handle.Flash(token)
			Animation:Play(stroke, { Color = Theme.Get(token or "Error"), Transparency = 0.1 }, { Duration = 0.1 })
			task.delay(0.5, function()
				if stroke.Parent then
					paint()
				end
			end)
		end
		handle.Refresh = paint

		return holder, box, stroke, handle
	end

	function Widgets.Chip(cleanup, props)
		props = props or {}
		local chip = Widgets.Surface(cleanup, {
			Class = props.Class or "TextButton",
			Name = props.Name or "Chip",
			Parent = props.Parent,
			Fill = props.Fill or "TertiaryBackground",
			Transparency = props.Transparency or "ElementTransparency",
			Stroke = "Border",
			StrokeTransparency = 0.5,
			Radius = props.Radius or "Full",
			Size = props.Size or UDim2.fromOffset(24, 24),
			Position = props.Position,
			AnchorPoint = props.AnchorPoint,
			LayoutOrder = props.LayoutOrder,
			ZIndex = props.ZIndex or 1,
			Visible = props.Visible ~= false,
		})
		Widgets.Interactive(cleanup, chip, chip, { Base = props.Fill or "TertiaryBackground" })
		return chip
	end

	return Widgets
end
end)()

__modules["Core/Editable"] = (function()
return function(import)
	local Theme = import("Core/Theme")
	local Utility = import("Core/Utility")
	local Signal = import("Core/Signal")
	local Animation = import("Services/Animation")

	local Editable = {}

	function Editable.Attach(cleanup, box, text, opts)
		opts = opts or {}
		local handle = { Editing = false, Enabled = opts.Enabled ~= false, Committed = Signal.new() }
		cleanup:Add(handle.Committed)
		local original
		local lastClick = 0
		local underline

		local function highlight(active)
			if not opts.Highlight then
				return
			end
			if active and not underline then
				underline = Utility.Create("Frame", {
					Name = "EditLine",
					AnchorPoint = Vector2.new(0, 1),
					Position = UDim2.fromScale(0, 1),
					Size = UDim2.new(1, 0, 0, 1),
					BackgroundColor3 = Theme.Get("Accent"),
					Parent = box,
				})
			elseif not active and underline then
				underline:Destroy()
				underline = nil
			end
		end

		local function finish(commit)
			if not handle.Editing then
				return
			end
			handle.Editing = false
			box.TextEditable = false
			box.Selectable = false
			highlight(false)
			local value = box.Text
			if commit and value ~= original then
				local valid = true
				if opts.Validate then
					local ok, result = pcall(opts.Validate, value)
					valid = ok and result ~= false
				end
				if valid then
					if opts.OnCommit then
						Utility.SafeCall(opts.Label or "Editable", opts.OnCommit, value)
					end
					handle.Committed:Fire(value)
				else
					Animation:Play(box, { TextColor3 = Theme.Get("Error") }, { Duration = 0.1 })
					task.delay(0.45, function()
						if box.Parent then
							text.SetColor(opts.Color or "Text")
						end
					end)
					value = original
				end
			elseif not commit then
				value = original
			end
			text.SetText(opts.Source and opts.Source() or value)
		end

		function handle.Begin()
			if not handle.Enabled or handle.Editing or not box.Parent then
				return
			end
			handle.Editing = true
			original = opts.Source and opts.Source() or text.Source
			box.RichText = false
			box.Text = original
			box.TextEditable = true
			box.Selectable = true
			highlight(true)
			box:CaptureFocus()
			pcall(function()
				box.CursorPosition = #original + 1
				box.SelectionStart = 1
			end)
		end

		function handle.Cancel()
			finish(false)
		end

		function handle.SetEnabled(value)
			handle.Enabled = value == true
			if not handle.Enabled then
				finish(false)
			end
		end

		cleanup:Add(box.FocusLost:Connect(function(enter)
			finish(enter or opts.CommitOnFocusLost ~= false)
		end))

		cleanup:Add(box.InputBegan:Connect(function(input)
			if handle.Editing or not handle.Enabled then
				return
			end
			if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then
				return
			end
			local now = os.clock()
			if now - lastClick < 0.4 then
				lastClick = 0
				handle.Begin()
			else
				lastClick = now
			end
		end))

		if opts.Trigger then
			cleanup:Add(opts.Trigger.Activated:Connect(function()
				handle.Begin()
			end))
		end

		box.TextEditable = false
		box.ClearTextOnFocus = false
		box.Selectable = false
		return handle
	end

	return Editable
end
end)()

__modules["Core/Search"] = (function()
return function(import)
	local Search = { Limit = 25 }
	Search.__index = Search

	function Search.new()
		return setmetatable({ _entries = {} }, Search)
	end

	function Search:Add(entry)
		function entry.Remove()
			local index = table.find(self._entries, entry)
			if index then
				table.remove(self._entries, index)
			end
		end
		table.insert(self._entries, entry)
		return entry
	end

	function Search:Count()
		return #self._entries
	end

	function Search:Query(text)
		local needle = string.lower((string.gsub(tostring(text or ""), "^%s*(.-)%s*$", "%1")))
		if needle == "" then
			return {}
		end
		local scored = {}
		for _, entry in self._entries do
			local title = string.lower(entry.Title or "")
			local description = string.lower(entry.Description or "")
			local score = 0
			if title == needle then
				score = 120
			elseif string.sub(title, 1, #needle) == needle then
				score = 100
			elseif string.find(title, needle, 1, true) then
				score = 60
			elseif string.find(description, needle, 1, true) then
				score = 30
			elseif entry.Section and string.find(string.lower(entry.Section.Title or ""), needle, 1, true) then
				score = 12
			elseif entry.Tab and string.find(string.lower(entry.Tab.Title or ""), needle, 1, true) then
				score = 8
			end
			if score > 0 then
				table.insert(scored, { entry = entry, score = score })
			end
		end
		table.sort(scored, function(a, b)
			if a.score ~= b.score then
				return a.score > b.score
			end
			return (a.entry.Title or "") < (b.entry.Title or "")
		end)
		local results = {}
		for index = 1, math.min(#scored, Search.Limit) do
			results[index] = scored[index].entry
		end
		return results
	end

	return Search
end
end)()

__modules["Core/Hash"] = (function()
return function(import)
	local Hash = {}

	local K = {
		0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5, 0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5,
		0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3, 0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174,
		0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc, 0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da,
		0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7, 0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967,
		0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13, 0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85,
		0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3, 0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070,
		0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5, 0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3,
		0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208, 0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2,
	}

	local band, bor, bxor, bnot = bit32.band, bit32.bor, bit32.bxor, bit32.bnot
	local rrotate, rshift, lshift = bit32.rrotate, bit32.rshift, bit32.lshift

	local function pack(value)
		return string.char(
			band(rshift(value, 24), 0xff),
			band(rshift(value, 16), 0xff),
			band(rshift(value, 8), 0xff),
			band(value, 0xff)
		)
	end

	local function unpack32(text, index)
		local a, b, c, d = string.byte(text, index, index + 3)
		return lshift(a, 24) + lshift(b, 16) + lshift(c, 8) + d
	end

	local function preprocess(message)
		local length = #message
		local bits = length * 8
		message ..= "\128"
		local padding = (56 - (length + 1) % 64) % 64
		message ..= string.rep("\0", padding)
		message ..= pack(math.floor(bits / 4294967296))
		message ..= pack(bits % 4294967296)
		return message
	end

	function Hash.Sha256(message)
		if type(message) ~= "string" then
			return nil
		end
		local h = {
			0x6a09e667, 0xbb67ae85, 0x3c6ef372, 0xa54ff53a,
			0x510e527f, 0x9b05688c, 0x1f83d9ab, 0x5be0cd19,
		}
		local data = preprocess(message)
		local w = table.create(64, 0)

		for chunk = 1, #data, 64 do
			for index = 0, 15 do
				w[index + 1] = unpack32(data, chunk + index * 4)
			end
			for index = 17, 64 do
				local a, b = w[index - 15], w[index - 2]
				local s0 = bxor(rrotate(a, 7), rrotate(a, 18), rshift(a, 3))
				local s1 = bxor(rrotate(b, 17), rrotate(b, 19), rshift(b, 10))
				w[index] = (w[index - 16] + s0 + w[index - 7] + s1) % 4294967296
			end

			local a, b, c, d, e, f, g, hh = h[1], h[2], h[3], h[4], h[5], h[6], h[7], h[8]
			for index = 1, 64 do
				local s1 = bxor(rrotate(e, 6), rrotate(e, 11), rrotate(e, 25))
				local ch = bxor(band(e, f), band(bnot(e), g))
				local temp1 = (hh + s1 + ch + K[index] + w[index]) % 4294967296
				local s0 = bxor(rrotate(a, 2), rrotate(a, 13), rrotate(a, 22))
				local maj = bxor(band(a, b), band(a, c), band(b, c))
				local temp2 = (s0 + maj) % 4294967296
				hh, g, f, e = g, f, e, (d + temp1) % 4294967296
				d, c, b, a = c, b, a, (temp1 + temp2) % 4294967296
			end

			h[1] = (h[1] + a) % 4294967296
			h[2] = (h[2] + b) % 4294967296
			h[3] = (h[3] + c) % 4294967296
			h[4] = (h[4] + d) % 4294967296
			h[5] = (h[5] + e) % 4294967296
			h[6] = (h[6] + f) % 4294967296
			h[7] = (h[7] + g) % 4294967296
			h[8] = (h[8] + hh) % 4294967296
		end

		local out = {}
		for index = 1, 8 do
			out[index] = string.format("%08x", h[index])
		end
		return table.concat(out)
	end

	function Hash.Salted(message, salt)
		return Hash.Sha256(tostring(salt or "") .. "::" .. tostring(message))
	end

	local function hexToBytes(text)
		if type(text) ~= "string" or #text % 2 ~= 0 then
			return nil
		end
		local out = table.create(#text / 2)
		local position = 1
		for index = 1, #text, 2 do
			local byte = tonumber(string.sub(text, index, index + 1), 16)
			if not byte then
				return nil
			end
			out[position] = string.char(byte)
			position += 1
		end
		return table.concat(out)
	end
	Hash.FromHex = hexToBytes

	function Hash.ToHex(text)
		local out = table.create(#text)
		for index = 1, #text do
			out[index] = string.format("%02x", string.byte(text, index))
		end
		return table.concat(out)
	end

	local B64 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"

	function Hash.Base64Encode(text)
		if type(text) ~= "string" then
			return nil
		end
		local out = {}
		for index = 1, #text, 3 do
			local a, b, c = string.byte(text, index, index + 2)
			local value = lshift(a, 16) + lshift(b or 0, 8) + (c or 0)
			local chunk = {}
			for slot = 0, 3 do
				chunk[slot + 1] = string.sub(B64, band(rshift(value, 18 - slot * 6), 63) + 1, band(rshift(value, 18 - slot * 6), 63) + 1)
			end
			if not b then
				chunk[3], chunk[4] = "=", "="
			elseif not c then
				chunk[4] = "="
			end
			table.insert(out, table.concat(chunk))
		end
		return table.concat(out)
	end

	function Hash.Base64Decode(text)
		if type(text) ~= "string" then
			return nil
		end
		text = string.gsub(text, "[^%w%+/=]", "")
		local out = {}
		for index = 1, #text, 4 do
			local value, bits = 0, 0
			for slot = 0, 3 do
				local char = string.sub(text, index + slot, index + slot)
				if char ~= "" and char ~= "=" then
					local position = string.find(B64, char, 1, true)
					if not position then
						return nil
					end
					value = lshift(value, 6) + (position - 1)
					bits += 6
				else
					value = lshift(value, 6)
				end
			end
			local chars = math.floor(bits / 8)
			for slot = 1, chars do
				table.insert(out, string.char(band(rshift(value, 24 - slot * 8), 0xff)))
			end
		end
		return table.concat(out)
	end

	function Hash.Hmac(key, message)
		key, message = tostring(key), tostring(message)
		local block = 64
		if #key > block then
			key = hexToBytes(Hash.Sha256(key)) or key
		end
		key ..= string.rep("\0", block - #key)
		local inner, outer = table.create(block), table.create(block)
		for index = 1, block do
			local byte = string.byte(key, index)
			inner[index] = string.char(bxor(byte, 0x36))
			outer[index] = string.char(bxor(byte, 0x5c))
		end
		local first = hexToBytes(Hash.Sha256(table.concat(inner) .. message))
		return Hash.Sha256(table.concat(outer) .. (first or ""))
	end

	function Hash.Keystream(key, length)
		local out, index = {}, 0
		local produced = 0
		while produced < length do
			local block = hexToBytes(Hash.Sha256(tostring(key) .. ":" .. index))
			if not block then
				return nil
			end
			table.insert(out, block)
			produced += #block
			index += 1
		end
		return string.sub(table.concat(out), 1, length)
	end

	function Hash.Stream(data, key)
		if type(data) ~= "string" or data == "" then
			return data
		end
		local stream = Hash.Keystream(key, #data)
		if not stream then
			return nil
		end
		local out = table.create(#data)
		for index = 1, #data do
			out[index] = string.char(bxor(string.byte(data, index), string.byte(stream, index)))
		end
		return table.concat(out)
	end

	function Hash.Nonce(size)
		local out = table.create(size or 16)
		for index = 1, size or 16 do
			out[index] = string.format("%02x", math.random(0, 255))
		end
		return table.concat(out)
	end

	function Hash.Equal(a, b)
		if type(a) ~= "string" or type(b) ~= "string" or #a ~= #b then
			return false
		end
		local diff = 0
		for index = 1, #a do
			diff = bor(diff, bxor(string.byte(a, index), string.byte(b, index)))
		end
		return diff == 0
	end

	function Hash.Encode(text, key)
		if type(text) ~= "string" or type(key) ~= "string" or key == "" then
			return text
		end
		local out = table.create(#text)
		for index = 1, #text do
			local byte = string.byte(text, index)
			local mask = string.byte(key, (index - 1) % #key + 1)
			out[index] = string.format("%02x", bxor(byte, mask))
		end
		return table.concat(out)
	end

	function Hash.Decode(text, key)
		if type(text) ~= "string" or type(key) ~= "string" or key == "" or #text % 2 ~= 0 then
			return nil
		end
		local out = table.create(#text / 2)
		local position = 1
		for index = 1, #text, 2 do
			local byte = tonumber(string.sub(text, index, index + 1), 16)
			if not byte then
				return nil
			end
			local mask = string.byte(key, (position - 1) % #key + 1)
			out[position] = string.char(bxor(byte, mask))
			position += 1
		end
		return table.concat(out)
	end

	return Hash
end
end)()

__modules["Core/Integrity"] = (function()
return function(import)
	local Utility = import("Core/Utility")
	local Signal = import("Core/Signal")

	local env = {}
	pcall(function()
		env = getfenv(1)
	end)

	local function lookup(...)
		for _, name in { ... } do
			local value = rawget(env, name) or env[name]
			if type(value) == "function" then
				return value
			end
		end
		return nil
	end

	local Integrity = {
		Tampered = Signal.new(),
		Strict = false,
	}

	local isHooked = lookup("isfunctionhooked", "is_function_hooked")
	local isC = lookup("iscclosure", "is_c_closure")
	local isL = lookup("islclosure", "is_l_closure")
	local isSynapse = lookup("issynapsefunction", "isexecutorclosure", "is_executor_closure", "checkclosure")
	local rawMeta = lookup("getrawmetatable", "get_raw_metatable")
	local checkCaller = lookup("checkcaller")
	local hookRestore = lookup("restorefunction")
	local getInfo = debug and debug.info

	Integrity.Available = {
		IsFunctionHooked = isHooked ~= nil,
		IsCClosure = isC ~= nil,
		IsLClosure = isL ~= nil,
		IsExecutorClosure = isSynapse ~= nil,
		RawMetatable = rawMeta ~= nil,
		CheckCaller = checkCaller ~= nil,
		Restore = hookRestore ~= nil,
	}

	local function hooked(fn)
		if type(fn) ~= "function" or not isHooked then
			return false
		end
		local ok, result = pcall(isHooked, fn)
		return ok and result == true
	end
	Integrity.IsHooked = hooked

	local function native(fn)
		if type(fn) ~= "function" or not isC then
			return true
		end
		local ok, result = pcall(isC, fn)
		if not ok then
			return true
		end
		return result == true
	end
	Integrity.IsNative = native

	local function lua(fn)
		if type(fn) ~= "function" or not isL then
			return true
		end
		local ok, result = pcall(isL, fn)
		if not ok then
			return true
		end
		return result == true
	end
	Integrity.IsLua = lua

	function Integrity.Signature(fn)
		if type(fn) ~= "function" or not getInfo then
			return nil
		end
		local ok, source = pcall(getInfo, fn, "s")
		if not ok then
			return nil
		end
		local okLine, line = pcall(getInfo, fn, "l")
		return tostring(source) .. ":" .. tostring(okLine and line or "?")
	end

	local function engineTargets()
		local targets = {}
		local function add(name, fn)
			if type(fn) == "function" then
				table.insert(targets, { Name = name, Fn = fn, Native = true })
			end
		end
		pcall(function()
			add("game.HttpGet", game.HttpGet)
			add("game.GetService", game.GetService)
			add("Instance.new", Instance.new)
		end)
		pcall(function()
			local http = game:GetService("HttpService")
			add("HttpService.JSONDecode", http.JSONDecode)
			add("HttpService.JSONEncode", http.JSONEncode)
		end)
		pcall(function()
			local market = game:GetService("MarketplaceService")
			add("Marketplace.UserOwnsGamePassAsync", market.UserOwnsGamePassAsync)
			add("Marketplace.PlayerOwnsAsset", market.PlayerOwnsAsset)
		end)
		pcall(function()
			local player = game:GetService("Players").LocalPlayer
			if player then
				add("Player.IsInGroup", player.IsInGroup)
				add("Player.GetRankInGroup", player.GetRankInGroup)
			end
		end)
		add("string.format", string.format)
		add("string.byte", string.byte)
		add("string.sub", string.sub)
		add("table.concat", table.concat)
		add("bit32.bxor", bit32 and bit32.bxor)
		add("os.time", os.time)
		return targets
	end

	function Integrity.Scan(extra)
		local failures = {}
		for _, target in engineTargets() do
			if hooked(target.Fn) then
				table.insert(failures, target.Name .. " (hook)")
			elseif target.Native and not native(target.Fn) then
				table.insert(failures, target.Name .. " (nao nativa)")
			end
		end

		for _, entry in extra or {} do
			local fn = type(entry) == "table" and entry.Fn or entry
			local name = type(entry) == "table" and entry.Name or "custom"
			if hooked(fn) then
				table.insert(failures, name .. " (hook)")
			elseif type(entry) == "table" and entry.Lua and not lua(fn) then
				table.insert(failures, name .. " (nao lua)")
			end
		end

		if rawMeta then
			local ok, meta = pcall(rawMeta, game)
			if ok and type(meta) == "table" then
				for _, name in { "__namecall", "__index", "__newindex" } do
					local value = rawget(meta, name)
					if type(value) == "function" then
						if hooked(value) then
							table.insert(failures, "game." .. name .. " (hook)")
						elseif not native(value) then
							table.insert(failures, "game." .. name .. " (nao nativa)")
						end
					end
				end
			end
		end

		if checkCaller then
			local ok, result = pcall(checkCaller)
			if ok and result == false then
				table.insert(failures, "checkcaller")
			end
		end

		return #failures == 0, failures
	end

	function Integrity.Report()
		local ok, failures = Integrity.Scan()
		return {
			Clean = ok,
			Failures = failures,
			Detection = Integrity.Available,
		}
	end

	function Integrity.Guard(interval, onTamper, extra)
		local running = true
		local thread = task.spawn(function()
			while running do
				task.wait(interval or 5)
				if not running then
					break
				end
				local ok, failures = Integrity.Scan(extra)
				if not ok then
					Integrity.Tampered:Fire(failures)
					Utility.SafeCall("Integrity guard", onTamper, failures)
					if Integrity.Strict then
						running = false
					end
				end
			end
		end)
		return {
			Stop = function()
				running = false
				pcall(task.cancel, thread)
			end,
			Thread = thread,
		}
	end

	return Integrity
end
end)()

__modules["Core/Component"] = (function()
return function(import)
	local Utility = import("Core/Utility")
	local Signal = import("Core/Signal")
	local State = import("Core/State")
	local Config = import("Core/Config")
	local Theme = import("Core/Theme")
	local Markup = import("Core/Markup")
	local Widgets = import("Core/Widgets")
	local Editable = import("Core/Editable")
	local Capabilities = import("Core/Capabilities")
	local Icons = import("Icons/Icon")
	local Tooltip = import("Services/Tooltip")
	local Animation = import("Services/Animation")
	local Input = import("Services/Input")

	local Component = { Registry = {} }
	local Base = {}
	Base.__index = Base
	Component.Base = Base

	function Component.Register(name, factory)
		Utility.Check(
			type(name) == "string" and string.match(name, "^%u%w*$") ~= nil,
			"Component",
			name,
			"Name must be PascalCase and alphanumeric."
		)
		Utility.Check(type(factory) == "function", "Component", name, "Factory must be a function.")
		Component.Registry[name] = factory
	end

	function Component.Names()
		local out = {}
		for name in Component.Registry do
			table.insert(out, name)
		end
		table.sort(out)
		return out
	end

	function Component.NewBare(ctx, class, kind, id, config)
		Utility.Check(type(config) == "table", kind, id, "Config must be a table.")
		local self = setmetatable({}, class)
		self.Kind, self.Id, self.Config = kind, id, config
		self.Window, self.Tab, self.Section = ctx.Window, ctx.Tab, ctx.Section
		self.Cleanup = ctx.Cleanup:Extend()
		self.Changed = Signal.new()
		self.TextChanged = Signal.new()
		self.Cleanup:Add(self.Changed)
		self.Cleanup:Add(self.TextChanged)
		self.Enabled, self.Visible, self._destroyed = true, true, false
		self.Cleanup:Add(function()
			self._destroyed = true
			if self._entry then
				self._entry.Remove()
				self._entry = nil
			end
			if self.Id and self.Window.Options[self.Id] == self then
				self.Window.Options[self.Id] = nil
			end
		end)
		ctx.Pending = self
		task.defer(function()
			if self._destroyed or self._entry or not self.Frame then
				return
			end
			local title = config.Title or config.Text
			if type(title) ~= "string" or title == "" or config.Search == false then
				return
			end
			self._entry = ctx.Window:_IndexAdd({
				Kind = kind,
				Title = Markup.Strip(title),
				Description = Markup.Strip(config.Description or config.Content or ""),
				Tab = ctx.Tab,
				Section = ctx.Section,
				Frame = self.Frame,
				Component = self,
			})
		end)
		return self
	end

	local function stub(instance)
		return {
			Instance = instance,
			Source = "",
			SetText = function() end,
			SetColor = function() end,
			SetGradient = function() end,
			SetWeight = function() end,
		}
	end

	function Component.New(ctx, class, kind, id, config, opts)
		opts = opts or {}
		local self = Component.NewBare(ctx, class, kind, id, config)
		local cleanup = self.Cleanup

		if ctx.Host then
			local host = ctx.Host
			self.Frame = host
			self.Hosted = true
			self.Right = Utility.Create("Frame", {
				Name = "Right",
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.new(1, 0, 0.5, 0),
				Size = UDim2.fromOffset(opts.RightWidth or 40, opts.RightHeight or 22),
				Parent = host,
			})
			self.TitleLabel = nil
			self._title = stub(host)
			self._description = stub(host)
			if config.Tooltip then
				self:SetTooltip(config.Tooltip)
			end
			return self
		end

		local flat = opts.Flat == true

		local frame, stroke = Widgets.Surface(cleanup, {
			Name = kind,
			Parent = ctx.Parent,
			Fill = (not flat) and "SecondaryBackground" or nil,
			Transparency = (not flat) and "ComponentTransparency" or nil,
			Stroke = (not flat) and "Border" or nil,
			StrokeTransparency = (not flat) and "ComponentStrokeTransparency" or nil,
			Radius = opts.Radius or 14,
			Size = UDim2.new(1, 0, 0, opts.MinHeight or 46),
			AutomaticSize = Enum.AutomaticSize.Y,
			LayoutOrder = ctx.Order(),
		})
		cleanup:Add(frame)
		self.Frame, self.Stroke = frame, stroke

		if opts.Flat ~= true and config.Rail ~= false then
			self._rail = Widgets.Surface(cleanup, {
				Name = "Rail",
				Parent = frame,
				Fill = config.RailColor or "Accent",
				Radius = "Full",
				AnchorPoint = Vector2.new(0, 0.5),
				Position = UDim2.new(0, 3, 0.5, 0),
				Size = UDim2.fromOffset(2, 0),
				ZIndex = 4,
			})
			cleanup:Add(frame.MouseEnter:Connect(function()
				if self.Enabled and not self:IsLocked() then
					Animation:Play(self._rail, { Size = UDim2.fromOffset(2, 16) }, {
						Duration = 0.26,
						Ease = "Snap",
					})
				end
			end))
			cleanup:Add(frame.MouseLeave:Connect(function()
				Animation:Play(self._rail, { Size = UDim2.fromOffset(2, 0) }, { Duration = 0.18, Ease = "Soft" })
			end))
		end

		local rightWidth = opts.RightWidth or 0
		local left = Utility.Create("Frame", {
			Name = "Left",
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.new(1, rightWidth > 0 and -(rightWidth + 14) or 0, 0, 0),
			Parent = frame,
		})
		Widgets.Padding(left, 14, 13, 12, 13)
		Widgets.List(left, 11, {
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
		})
		self.Left, self._left = left, left

		local iconSize = tonumber(config.IconSize) or 16
		self._iconSize = iconSize
		self._iconHolder = Utility.Create("Frame", {
			Name = "IconHolder",
			BackgroundTransparency = 1,
			Size = UDim2.fromOffset(iconSize, iconSize),
			LayoutOrder = 1,
			Visible = false,
			Parent = left,
		})
		self._textCol = Utility.Create("Frame", {
			Name = "TextColumn",
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.new(1, 0, 0, 0),
			LayoutOrder = 2,
			Parent = left,
		})
		Widgets.List(self._textCol, 3)

		local title = config.Title or config.Text or config.Name or ""
		local description = config.Description or config.Content or config.Desc or ""
		self._editableTitle = config.EditableTitle == true or config.Editable == true
		self._editableDescription = config.EditableDescription == true

		local titleRow = Utility.Create("Frame", {
			Name = "TitleRow",
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.new(1, 0, 0, 0),
			LayoutOrder = 1,
			Visible = title ~= "",
			Parent = self._textCol,
		})
		Widgets.List(titleRow, 6, {
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
		})
		self._titleRow = titleRow

		local needsChip = self._editableTitle or self._editableDescription
		self.TitleLabel, self._title = Widgets.Text(cleanup, {
			Class = self._editableTitle and "TextBox" or "TextLabel",
			Name = "Title",
			Parent = titleRow,
			Text = title,
			Color = config.TitleColor,
			Gradient = config.TitleGradient,
			Bold = true,
			TextWrapped = true,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.new(1, needsChip and -24 or 0, 0, 0),
			LayoutOrder = 1,
			Markup = not self._editableTitle,
		})

		self.DescriptionLabel, self._description = Widgets.Text(cleanup, {
			Class = self._editableDescription and "TextBox" or "TextLabel",
			Name = "Description",
			Parent = self._textCol,
			Text = description,
			Color = config.DescriptionColor or config.ContentColor or "MutedText",
			Gradient = config.DescriptionGradient,
			TextSize = 12,
			TextWrapped = true,
			RichText = config.RichText == true or Markup.Has(description),
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.new(1, 0, 0, 0),
			LayoutOrder = 2,
			Visible = description ~= "",
			Markup = not self._editableDescription,
		})

		if config.Badge then
			local badge = Widgets.Surface(cleanup, {
				Name = "Badge",
				Parent = titleRow,
				Fill = config.BadgeColor or "Accent",
				Radius = "Full",
				Size = UDim2.new(0, 0, 0, 15),
				AutomaticSize = Enum.AutomaticSize.X,
				LayoutOrder = 3,
			})
			Widgets.Padding(badge, 6, 0)
			local _, badgeText = Widgets.Text(cleanup, {
				Parent = badge,
				Text = config.Badge,
				Color = config.BadgeTextColor or "AccentText",
				Heavy = true,
				TextSize = 9,
				AutomaticSize = Enum.AutomaticSize.X,
				Size = UDim2.new(0, 0, 1, 0),
			})
			self._badge = badgeText
			self.TitleLabel.Size = UDim2.new(1, needsChip and -70 or -46, 0, 0)
		end

		if needsChip then
			self._chip = Widgets.Chip(cleanup, {
				Name = "Edit",
				Parent = titleRow,
				Radius = "Full",
				Size = UDim2.fromOffset(18, 18),
				LayoutOrder = 2,
				Visible = false,
			})
			Icons.Create(self._chip, "pencil", { Size = 11, Position = UDim2.fromOffset(3.5, 3.5), Cleanup = cleanup })
			cleanup:Add(frame.MouseEnter:Connect(function()
				if self.Enabled then
					self._chip.Visible = true
				end
			end))
			cleanup:Add(frame.MouseLeave:Connect(function()
				self._chip.Visible = false
			end))
		end

		if self._editableTitle then
			self.TitleEditor = Editable.Attach(cleanup, self.TitleLabel, self._title, {
				Label = kind .. " title",
				Color = config.TitleColor,
				Highlight = true,
				Trigger = self._chip,
				Source = function()
					return self._title.Source
				end,
				Validate = config.ValidateTitle,
				OnCommit = function(value)
					self:SetTitle(value)
					Utility.SafeCall(kind .. " OnTitleChanged", config.OnTitleChanged, value)
					self.TextChanged:Fire("Title", value)
				end,
			})
		end
		if self._editableDescription then
			self.DescriptionEditor = Editable.Attach(cleanup, self.DescriptionLabel, self._description, {
				Label = kind .. " description",
				Color = config.DescriptionColor or "MutedText",
				Highlight = true,
				Trigger = (not self._editableTitle) and self._chip or nil,
				Source = function()
					return self._description.Source
				end,
				OnCommit = function(value)
					self:SetDescription(value)
					Utility.SafeCall(kind .. " OnDescriptionChanged", config.OnDescriptionChanged, value)
					self.TextChanged:Fire("Description", value)
				end,
			})
		end

		if rightWidth > 0 then
			self.Right = Utility.Create("Frame", {
				Name = "Right",
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.new(1, -12, 0.5, 0),
				Size = UDim2.fromOffset(rightWidth, opts.RightHeight or 26),
				ZIndex = 3,
				Parent = frame,
			})
		end

		self:SetIcon(config.Icon)
		if config.IconColor then
			self:SetIconColor(config.IconColor)
		end

		if not opts.NoSearch and (title ~= "" or description ~= "") then
			self._entry = ctx.Window:_IndexAdd({
				Kind = kind,
				Title = Markup.Strip(title),
				Description = Markup.Strip(description),
				Tab = ctx.Tab,
				Section = ctx.Section,
				Frame = frame,
				Component = self,
			})
		end
		if config.Tooltip then
			self:SetTooltip(config.Tooltip)
		end
		if config.Visible == false then
			self:SetVisible(false)
		end
		if config.Enabled == false or config.Disabled == true then
			self:SetEnabled(false)
		end
		if config.Locked then
			self:Lock(type(config.Locked) == "number" and config.Locked or 0, config.LockReason)
		end
		if config.Key then
			self:Bind(config.Key)
		end
		if config.VisibleWhen ~= nil then
			self:DependOn(config.VisibleWhen, "Visible")
		end
		if config.EnabledWhen ~= nil then
			self:DependOn(config.EnabledWhen, "Enabled")
		end

		cleanup:Add(frame.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton2 and not self:IsLocked() then
				self:_Menu()
			end
		end))
		return self
	end

	function Component.BindValue(self, id, default, render)
		local state
		if id then
			state = Config:Register(id, default)
		else
			state = State.new(default)
			self.Cleanup:Add(state)
		end
		local valid, value = self:_Normalize(state:Get())
		if not valid then
			value = default
		end
		if value ~= state:Get() or type(value) == "table" then
			state:Set(value, true)
		end
		self.State = state
		self.Cleanup:Add(state.Changed:Connect(function(newValue)
			if self._destroyed then
				return
			end
			render(newValue, true)
			self:_Emit(newValue)
		end))
		Theme.BindFn(function()
			render(state:Get(), false)
		end, self.Cleanup)
	end

	function Base:_Normalize(value)
		return true, value
	end

	function Base:_Emit(value)
		if self._destroyed then
			return
		end
		Utility.SafeCall(self.Kind .. " " .. tostring(self.Id or self.Config.Title or "?"), self.Config.Callback, value)
		self.Changed:Fire(value)
	end

	function Base:GetValue()
		return self.State and self.State:Get()
	end

	function Base:SetValue(value)
		if not self.State then
			Utility.Warn(self.Kind .. " does not hold a value.")
			return self
		end
		local valid, normalized = self:_Normalize(value)
		if not valid then
			Utility.Warn(string.format('Invalid value for %s "%s".', self.Kind, tostring(self.Id)))
			return self
		end
		self.State:Set(normalized)
		return self
	end

	function Base:OnChanged(callback)
		return self.Changed:Connect(callback)
	end

	function Base:SetCallback(callback)
		Utility.Check(callback == nil or type(callback) == "function", self.Kind, self.Id, "Callback must be a function.")
		self.Config.Callback = callback
		return self
	end

	function Base:GetTitle()
		return self._title and self._title.Source or ""
	end

	function Base:GetDescription()
		return self._description and self._description.Source or ""
	end

	function Base:SetTitle(text)
		text = text == nil and "" or tostring(text)
		self._title.SetText(text)
		if self._titleRow then
			self._titleRow.Visible = text ~= ""
		end
		if self._entry then
			self._entry.Title = Markup.Strip(text)
		end
		return self
	end

	function Base:SetDescription(text)
		text = text == nil and "" or tostring(text)
		self._description.SetText(text)
		self.DescriptionLabel.Visible = text ~= ""
		if self._entry then
			self._entry.Description = Markup.Strip(text)
		end
		return self
	end
	Base.SetContent = Base.SetDescription
	Base.SetDesc = Base.SetDescription

	function Base:SetTitleColor(color)
		self._title.SetColor(color)
		return self
	end

	function Base:SetDescriptionColor(color)
		self._description.SetColor(color)
		return self
	end

	function Base:SetTitleGradient(stops)
		self._title.SetGradient(stops)
		return self
	end

	function Base:SetDescriptionGradient(stops)
		self._description.SetGradient(stops)
		return self
	end

	function Base:SetTextColor(color)
		self:SetTitleColor(color)
		self:SetDescriptionColor(color)
		return self
	end

	function Base:SetEditable(kind, enabled)
		if kind == "Title" and self.TitleEditor then
			self.TitleEditor.SetEnabled(enabled ~= false)
		elseif kind == "Description" and self.DescriptionEditor then
			self.DescriptionEditor.SetEnabled(enabled ~= false)
		end
		return self
	end

	function Base:Edit(kind)
		local editor = kind == "Description" and self.DescriptionEditor or self.TitleEditor
		if editor then
			editor.Begin()
		end
		return self
	end

	function Base:SetIcon(spec)
		local holder = self._iconHolder
		if not holder then
			return self
		end
		if spec == nil then
			if self._icon then
				self._icon:Set(nil)
			end
			holder.Visible = false
			self._textCol.Size = UDim2.new(1, 0, 0, 0)
			return self
		end
		if self._icon then
			self._icon:Set(spec)
		else
			self._icon = Icons.Create(holder, spec, Icons.Options(self.Config, {
				Size = self._iconSize or 16,
				Color = self.Config.IconColor or "MutedText",
				Cleanup = self.Cleanup,
			}))
		end
		holder.Visible = true
		self._textCol.Size = UDim2.new(1, -((self._iconSize or 16) + 11), 0, 0)
		return self
	end

	function Base:SetIconColor(color)
		if self._icon then
			self._icon:SetColor(color)
		end
		return self
	end

	function Base:SetIconShape(shape, corner)
		self.Config.IconShape = shape
		if corner ~= nil then
			self.Config.IconCorner = corner
		end
		if self._icon then
			self._icon:SetShape(shape, corner)
		end
		return self
	end

	function Base:SetIconTint(enabled)
		self.Config.IconTint = enabled
		if self._icon then
			self._icon:SetTint(enabled)
		end
		return self
	end

	function Base:SetVisible(visible)
		self.Visible = visible == true
		if self.Frame then
			self.Frame.Visible = self.Visible
		end
		return self
	end

	function Base:SetEnabled(enabled)
		self.Enabled = enabled == true
		if not self.Frame then
			return self
		end
		if self.Enabled then
			if self._blocker then
				self._blocker:Destroy()
				self._blocker = nil
			end
		elseif not self._blocker then
			if self._chip then
				self._chip.Visible = false
			end
			self._blocker = Widgets.Surface(self.Cleanup, {
				Name = "DisabledOverlay",
				Parent = self.Frame,
				Fill = "Background",
				BackgroundTransparency = 0.5,
				Radius = self.Config.Radius or 14,
				Active = true,
				ZIndex = 20,
				Size = UDim2.fromScale(1, 1),
			})
		end
		return self
	end

	local function clock(seconds)
		seconds = math.max(seconds, 0)
		local minutes = math.floor(seconds / 60)
		local rest = math.ceil(seconds % 60)
		if rest == 60 then
			minutes += 1
			rest = 0
		end
		if minutes >= 60 then
			return string.format("%d:%02d:%02d", math.floor(minutes / 60), minutes % 60, rest)
		end
		return string.format("%02d:%02d", minutes, rest)
	end
	Component.Clock = clock

	function Base:_BuildLock()
		if self._lock then
			return self._lock
		end
		local cleanup = self.Cleanup
		local radius = self.Config.Radius or 14

		local cover = Widgets.Surface(cleanup, {
			Class = "CanvasGroup",
			Name = "Lock",
			Parent = self.Frame,
			Fill = "Background",
			BackgroundTransparency = 0.22,
			Radius = radius,
			Active = true,
			ClipsDescendants = true,
			AutomaticSize = Enum.AutomaticSize.None,
			ZIndex = 30,
			Size = UDim2.new(1, 0, 0, 40),
			Visible = false,
			GroupTransparency = 1,
		})

		local function sync()
			local height = 0
			if self._left then
				height = math.max(height, self._left.AbsoluteSize.Y)
			end
			if self.Right then
				height = math.max(height, self.Right.AbsoluteSize.Y + 16)
			end
			if height < 12 then
				height = math.max(self.Frame.Size.Y.Offset, 40)
			end
			cover.Size = UDim2.new(1, 0, 0, height)
		end
		self._lockSync = sync
		if self._left then
			cleanup:Add(self._left:GetPropertyChangedSignal("AbsoluteSize"):Connect(sync))
		end
		sync()
		Utility.Create("UIGradient", {
			Rotation = 35,
			Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 0.1),
				NumberSequenceKeypoint.new(0.5, 0.3),
				NumberSequenceKeypoint.new(1, 0.1),
			}),
			Parent = cover,
		})

		local shine = Widgets.Surface(cleanup, {
			Name = "Shine",
			Parent = cover,
			Fill = "Text",
			BackgroundTransparency = 0.94,
			Radius = 0,
			Rotation = 18,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Size = UDim2.new(0, 46, 1, 0),
			Position = UDim2.new(0, -40, 0.5, 0),
		})

		local row = Utility.Create("Frame", {
			Name = "Row",
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.new(0, 0, 0, 20),
			AutomaticSize = Enum.AutomaticSize.X,
			Parent = cover,
		})
		Widgets.List(row, 7, {
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
		})

		local iconHolder = Utility.Create("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.fromOffset(15, 15),
			LayoutOrder = 1,
			Parent = row,
		})
		local icon = Icons.Create(iconHolder, "lock", { Size = 15, Color = "MutedText", Cleanup = cleanup })

		local _, label = Widgets.Text(cleanup, {
			Parent = row,
			Text = "00:00",
			Color = "Text",
			Bold = true,
			TextSize = 12,
			AutomaticSize = Enum.AutomaticSize.X,
			Size = UDim2.new(0, 0, 1, 0),
			LayoutOrder = 2,
			Markup = false,
		})

		local bar = Widgets.Surface(cleanup, {
			Name = "Bar",
			Parent = cover,
			Fill = self.Config.LockColor or "Accent",
			Radius = "Full",
			AnchorPoint = Vector2.new(0, 1),
			Position = UDim2.new(0, 0, 1, -3),
			Size = UDim2.new(1, 0, 0, 2),
		})

		local hit = Utility.Create("TextButton", {
			Name = "Hit",
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			ZIndex = 5,
			Parent = cover,
		})

		local function nudge()
			Widgets.Pulse(iconHolder, 0.72, 0.35)
			Animation:Play(icon.Instance, { Rotation = -14 }, { Duration = 0.06 })
			task.delay(0.06, function()
				if icon.Instance.Parent then
					Animation:Play(icon.Instance, { Rotation = 12 }, { Duration = 0.07 })
					task.delay(0.07, function()
						if icon.Instance.Parent then
							Animation:Play(icon.Instance, { Rotation = 0 }, { Duration = 0.12 })
						end
					end)
				end
			end)
		end

		cleanup:Add(hit.Activated:Connect(nudge))
		cleanup:Add(hit.MouseEnter:Connect(function()
			Animation:Play(cover, { BackgroundTransparency = 0.12 }, { Duration = 0.15 })
			icon:SetColor(self.Config.LockColor or "Accent")
			Animation:Play(shine, { Position = UDim2.new(1, 50, 0.5, 0) }, {
				Duration = 0.55,
				Style = Enum.EasingStyle.Quad,
			})
			task.delay(0.6, function()
				if shine.Parent then
					shine.Position = UDim2.new(0, -50, 0.5, 0)
				end
			end)
		end))
		cleanup:Add(hit.MouseLeave:Connect(function()
			Animation:Play(cover, { BackgroundTransparency = 0.22 }, { Duration = 0.2 })
			icon:SetColor("MutedText")
		end))

		self._lock = {
			Frame = cover,
			Row = row,
			Icon = icon,
			Label = label,
			Bar = bar,
			Hit = hit,
			Nudge = nudge,
		}
		return self._lock
	end

	function Base:Lock(seconds, reason)
		if self._destroyed or not self.Frame then
			return self
		end
		local lock = self:_BuildLock()
		local total = tonumber(seconds) or 0
		self._lockUntil = total > 0 and (os.clock() + total) or math.huge
		self._lockReason = reason

		if self._lockThread then
			pcall(task.cancel, self._lockThread)
			self._lockThread = nil
		end
		if self._lockSync then
			self._lockSync()
		end
		lock.Frame.Visible = true
		lock.Bar.Visible = total > 0
		lock.Label.Instance.Visible = total > 0
		lock.Label.SetText(total > 0 and clock(total) or (reason or ""))
		if reason and total <= 0 then
			lock.Label.Instance.Visible = true
		end
		Animation:Play(lock.Frame, { GroupTransparency = 0 }, { Duration = 0.2 })
		Widgets.Pulse(lock.Row, 0.82, 0.32)

		if total > 0 then
			self._lockThread = task.spawn(function()
				while not self._destroyed do
					local left = self._lockUntil - os.clock()
					if left <= 0 then
						break
					end
					lock.Label.SetText(clock(left))
					lock.Bar.Size = UDim2.new(math.clamp(left / total, 0, 1), 0, 0, 2)
					task.wait(0.05)
				end
				if not self._destroyed then
					self:Unlock()
				end
			end)
			self.Cleanup:Add(self._lockThread)
		end
		return self
	end

	function Base:Unlock()
		if not self._lock then
			return self
		end
		self._lockUntil = nil
		if self._lockThread then
			pcall(task.cancel, self._lockThread)
			self._lockThread = nil
		end
		local cover = self._lock.Frame
		Animation:Play(cover, { GroupTransparency = 1 }, {
			Duration = 0.22,
			OnComplete = function()
				if cover.Parent and not self:IsLocked() then
					cover.Visible = false
				end
			end,
		})
		if self.Stroke then
			Widgets.Glow(self.Stroke, self.Config.LockColor or "Accent", 0.35)
		end
		Utility.SafeCall(self.Kind .. " OnUnlock", self.Config.OnUnlock)
		return self
	end

	function Base:IsLocked()
		if not self._lockUntil then
			return false
		end
		if self._lockUntil == math.huge then
			return true
		end
		return os.clock() < self._lockUntil
	end

	function Base:GetLockRemaining()
		if not self:IsLocked() or self._lockUntil == math.huge then
			return 0
		end
		return math.max(self._lockUntil - os.clock(), 0)
	end

	function Base:SetCooldown(seconds)
		self.Config.Cooldown = tonumber(seconds) or 0
		return self
	end

	function Base:Shake()
		if self._lock and self:IsLocked() then
			self._lock.Nudge()
		end
		return self
	end

	function Base:SetTooltip(text)
		if not self.Frame then
			return self
		end
		if self._tooltip then
			self._tooltip.Text = text
		else
			self._tooltip = Tooltip.Attach(self.Frame, text, self.Cleanup)
		end
		return self
	end

	function Base:DependOn(spec, mode)
		local function evaluate()
			if type(spec) == "function" then
				local ok, result = pcall(spec, self.Window.Options)
				return ok and result == true
			end
			if type(spec) == "string" then
				local value = Config:Get(spec)
				return value ~= nil and value ~= false
			end
			if type(spec) == "table" then
				for id, expected in spec do
					local value = Config:Get(id)
					if type(expected) == "function" then
						local ok, result = pcall(expected, value)
						if not ok or result ~= true then
							return false
						end
					elseif type(expected) == "table" then
						if table.find(expected, value) == nil then
							return false
						end
					elseif value ~= expected then
						return false
					end
				end
				return true
			end
			return true
		end

		local last
		local function apply(instant)
			local on = evaluate()
			if on == last then
				return
			end
			last = on
			if mode == "Enabled" then
				self:SetEnabled(on)
			else
				self:SetVisible(on)
				if on and not instant and self.Frame then
					self.Frame.Position = UDim2.fromOffset(-10, 0)
					Animation:Play(self.Frame, { Position = UDim2.new() }, { Duration = 0.18 })
				end
			end
		end

		self.Cleanup:Add(Config.Changed:Connect(function()
			apply(false)
		end))
		apply(true)
		return self
	end

	function Base:GetDefault()
		return self.Id and Config._defaults[self.Id] or self.Config.Default
	end

	function Base:Reset()
		local default = self:GetDefault()
		if default ~= nil and self.State then
			self.State:Set(Utility.DeepCopy(default))
		end
		return self
	end

	function Base:Bind(key)
		if self._menuBind then
			self._menuBind:Destroy()
			self._menuBind = nil
		end
		if key == nil or key == Enum.KeyCode.Unknown then
			self.BoundKey = nil
			return self
		end
		self.BoundKey = key
		self._menuBind = self.Cleanup:Add(Input.AddBind(key, function()
			self:Trigger()
		end, self.Kind .. " " .. tostring(self.Id or self:GetTitle())))
		return self
	end

	function Base:Trigger()
		if not self.Enabled or self:IsLocked() then
			return self
		end
		if type(self.Fire) == "function" then
			self:Fire()
		elseif self.State and type(self.State:Get()) == "boolean" then
			self.State:Set(not self.State:Get())
		elseif self.Window then
			self.Window:Focus(self)
		end
		return self
	end

	local function describe(value)
		if type(value) == "boolean" then
			return value and "on" or "off"
		end
		if typeof(value) == "Color3" then
			return Utility.ToHex(value)
		end
		if typeof(value) == "EnumItem" then
			return value.Name
		end
		if type(value) == "table" then
			local parts = {}
			for name, on in value do
				if on == true then
					table.insert(parts, tostring(name))
				end
			end
			if #parts > 0 then
				table.sort(parts)
				return table.concat(parts, ", ")
			end
			return "empty"
		end
		if value == nil then
			return "none"
		end
		return tostring(value)
	end
	Component.Describe = describe

	function Base:_Menu()
		if self._destroyed or not self.Window or self.Config.Menu == false then
			return
		end
		local entries = {}
		local function add(title, icon, callback, color)
			table.insert(entries, { Title = title, Icon = icon, Callback = callback, Color = color })
		end

		if self.State then
			add("Copy value", "copy", function()
				Capabilities.SetClipboard(describe(self.State:Get()))
			end)
			if self:GetDefault() ~= nil then
				add("Reset to default", "rotate-ccw", function()
					self:Reset()
				end)
			end
		end
		if type(self.Fire) == "function" or (self.State and type(self.State:Get()) == "boolean") then
			add(self.BoundKey and ("Key: " .. self.BoundKey.Name) or "Set key", "keyboard", function()
				self:_Capture()
			end)
		end
		local bar = self.Window.StatusBar or (self.Window.Owner and self.Window.Owner.StatusBars[1])
		if bar and self.State then
			local pinned = bar._fields and bar._fields[self.Id or Utility.Slug(self:GetTitle())]
			add(pinned and "Unpin from status bar" or "Pin to status bar", "pin", function()
				local id = self.Id or Utility.Slug(self:GetTitle())
				if bar._fields[id] then
					bar:RemoveField(id)
					return
				end
				local clickable = type(self.State:Get()) == "boolean" or type(self.Fire) == "function"
				bar:AddField(id, {
					Label = Markup.Strip(self:GetTitle()),
					Icon = self.Config.Icon,
					Value = function()
						return describe(self.State:Get())
					end,
					Callback = clickable and function()
						self:Trigger()
					end or nil,
				})
			end)
		end
		if self.Config.Menu then
			for _, entry in self.Config.Menu do
				if type(entry) == "table" and entry.Title then
					add(entry.Title, entry.Icon, entry.Callback, entry.Color)
				end
			end
		end
		if #entries == 0 then
			return
		end

		local popup = self.Window:OpenPopup(self.Frame, 184, #entries * 28 + 10)
		local cleanup = popup.Cleanup
		Widgets.Padding(popup.Frame, 5)
		Widgets.List(popup.Frame, 2)
		for index, entry in entries do
			local row = Widgets.Surface(cleanup, {
				Class = "TextButton",
				Parent = popup.Frame,
				Fill = "SecondaryBackground",
				Transparency = 1,
				Radius = 8,
				Size = UDim2.new(1, 0, 0, 26),
				LayoutOrder = index,
			})
			Icons.Create(row, entry.Icon or "dot", {
				Size = 13,
				Color = entry.Color or "MutedText",
				AnchorPoint = Vector2.new(0, 0.5),
				Position = UDim2.new(0, 9, 0.5, 0),
				Cleanup = cleanup,
			})
			Widgets.Text(cleanup, {
				Parent = row,
				Text = entry.Title,
				Color = entry.Color or "Text",
				TextSize = 12,
				Position = UDim2.fromOffset(29, 0),
				Size = UDim2.new(1, -36, 1, 0),
				TextTruncate = Enum.TextTruncate.AtEnd,
			})
			Widgets.Interactive(cleanup, row, row, { Alpha = { 1, 0.6, 0.45 } })
			cleanup:Add(row.Activated:Connect(function()
				popup.Close()
				Utility.SafeCall("Menu " .. entry.Title, entry.Callback)
			end))
		end
	end

	function Base:_Capture()
		if self._capturingKey then
			return
		end
		self._capturingKey = true
		self:Flash("Accent")
		local cancel = Input.Capture(function(key, cancelled)
			self._capturingKey = false
			if self._destroyed then
				return
			end
			if cancelled then
				return
			end
			self:Bind(key ~= Enum.KeyCode.Unknown and key or nil)
			if self.Window then
				self.Window:Toast(self:GetTitle() .. " -> " .. (key and key.Name or "unbound"))
			end
		end)
		self.Cleanup:Add(cancel)
	end

	function Base:SetBadge(text)
		if self._badge then
			self._badge.SetText(text)
			Widgets.Pulse(self._badge.Instance, 0.8, 0.3)
		end
		return self
	end

	function Base:SetLayoutOrder(order)
		if self.Frame then
			self.Frame.LayoutOrder = order
		end
		return self
	end

	function Base:Flash(token)
		if not self.Stroke then
			return self
		end
		local stroke = self.Stroke
		Animation:Play(stroke, { Color = Theme.Get(token or "Accent"), Transparency = 0 }, { Duration = 0.15 })
		task.delay(0.9, function()
			if stroke.Parent and not self._destroyed then
				Animation:Play(stroke, {
					Color = Theme.Get("Border"),
					Transparency = Theme.Get("ComponentStrokeTransparency"),
				}, { Duration = 0.3 })
			end
		end)
		return self
	end

	function Base:Destroy()
		if self._destroyed then
			return
		end
		if self.Frame then
			Animation:CancelTree(self.Frame)
		end
		self.Cleanup:Clean()
	end

	function Component.Add(owner, name, first, second)
		local factory = Component.Registry[name]
		local id, config
		if type(first) == "string" then
			id, config = first, second
		else
			config = first
		end
		config = config or {}
		if type(config) ~= "table" then
			Utility.Fail(name, id, "Config must be a table.")
		end
		if id ~= nil and owner.Window.Options[id] then
			Utility.Fail(name, id, "Duplicate id: an option with this id already exists in this window.")
		end
		local ctx = {
			Parent = owner.Container,
			Window = owner.Window,
			Tab = owner.TabRef,
			Section = owner.SectionRef,
			Cleanup = owner.Cleanup,
			Order = owner.NextOrder,
		}
		local ok, result = pcall(factory, ctx, id, config)
		if not ok then
			if ctx.Pending then
				pcall(function()
					ctx.Pending:Destroy()
				end)
			end
			local message = tostring(result)
			if string.sub(message, 1, 7) == "[DEADX]" then
				error(message, 0)
			end
			Utility.Fail(name, id, message)
		end
		if id ~= nil then
			owner.Window.Options[id] = result
		end
		return result
	end

	function Component.MakeContainer(class)
		class.__index = function(object, key)
			local method = rawget(class, key)
			if method ~= nil then
				return method
			end
			local name = type(key) == "string" and string.match(key, "^Add(%u%w*)$")
			if name and Component.Registry[name] then
				return function(self, first, second)
					return Component.Add(self, name, first, second)
				end
			end
			return nil
		end
	end

	return Component
end
end)()

__modules["Core/Section"] = (function()
return function(import)
	local Utility = import("Core/Utility")
	local Theme = import("Core/Theme")
	local Markup = import("Core/Markup")
	local Widgets = import("Core/Widgets")
	local Component = import("Core/Component")
	local Icons = import("Icons/Icon")
	local Animation = import("Services/Animation")

	local Section = {}
	Component.MakeContainer(Section)

	function Section.new(owner, config)
		if type(config) == "string" then
			config = { Title = config }
		end
		config = config or {}
		Utility.Check(type(config.Title) == "string", "Section", config.Title, "Title must be a string.")
		local self = setmetatable({}, Section)
		local tab = owner.TabRef or owner
		local window = owner.Window
		self.Window, self.Title, self.TabRef, self.SectionRef = window, config.Title, tab, self
		self.Config = config
		self.Cleanup = owner.Cleanup:Extend()
		self._order = 0
		self._collapsed = false
		self.NextOrder = function()
			self._order += 1
			return self._order
		end
		local cleanup = self.Cleanup

		local frame = Utility.Create("Frame", {
			Name = "Section",
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			LayoutOrder = owner.NextOrder(),
			Parent = owner.Container,
		})
		cleanup:Add(frame)
		Widgets.List(frame, 12)
		self.Frame = frame

		local collapsible = config.Collapsible == true
		local header = Utility.Create(collapsible and "TextButton" or "Frame", {
			Name = "Header",
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 22),
			LayoutOrder = 0,
			Parent = frame,
		})
		self.Header = header

		local row = Utility.Create("Frame", {
			Name = "Row",
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, -5),
			Parent = header,
		})
		Widgets.List(row, 7, {
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
		})

		if collapsible then
			local chevronHolder = Utility.Create("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.fromOffset(12, 12),
				LayoutOrder = 0,
				Parent = row,
			})
			self._chevron = Icons.Create(chevronHolder, "chevron-down", {
				Size = 12,
				Color = "MutedText",
				Cleanup = cleanup,
			})
		end

		if config.Icon then
			local holder = Utility.Create("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.fromOffset(13, 13),
				LayoutOrder = 1,
				Parent = row,
			})
			self._icon = Icons.Create(holder, config.Icon, Icons.Options(config, {
				Size = 13,
				Color = config.IconColor or config.Color or "MutedText",
				Cleanup = cleanup,
			}))
		end

		self.Label, self._text = Widgets.Text(cleanup, {
			Name = "Title",
			Parent = row,
			Text = config.Title,
			Color = config.Color or config.TitleColor or "MutedText",
			Gradient = config.Gradient,
			Bold = true,
			TextSize = 12,
			AutomaticSize = Enum.AutomaticSize.X,
			Size = UDim2.new(0, 0, 1, 0),
			LayoutOrder = 2,
		})

		self._line = Widgets.Surface(cleanup, {
			Name = "Line",
			Parent = header,
			Fill = config.LineColor or "Border",
			Radius = 0,
			Size = UDim2.new(1, 0, 0, 1),
			Position = UDim2.new(0, 0, 1, -1),
			Visible = config.Line ~= false,
		})

		local clip = Utility.Create("Frame", {
			Name = "Clip",
			BackgroundTransparency = 1,
			ClipsDescendants = true,
			Size = UDim2.new(1, 0, 0, 0),
			LayoutOrder = 1,
			Parent = frame,
		})
		self._clip = clip

		self.Container = Utility.Create("Frame", {
			Name = "Body",
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			Parent = clip,
		})
		Widgets.List(self.Container, config.Gap or 9)

		local function fit()
			if self._collapsed or self._animating then
				return
			end
			clip.Size = UDim2.new(1, 0, 0, self.Container.AbsoluteSize.Y)
		end
		cleanup:Add(self.Container:GetPropertyChangedSignal("AbsoluteSize"):Connect(fit))
		task.defer(fit)
		self._fit = fit

		if collapsible then
			cleanup:Add(header.Activated:Connect(function()
				self:Toggle()
			end))
			if config.Collapsed == true then
				self:Collapse(true)
			end
		end

		self._entry = window:_IndexAdd({
			Kind = "Section",
			Title = Markup.Strip(config.Title),
			Tab = tab,
			Section = self,
			Frame = header,
		})
		cleanup:Add(function()
			if self._entry then
				self._entry.Remove()
			end
		end)
		return self
	end

	function Section:AddCard(config)
		return import("Core/Card").new(self, config)
	end

	function Section:SetTitle(text)
		self.Title = text
		self._text.SetText(text)
		if self._entry then
			self._entry.Title = Markup.Strip(text)
		end
		return self
	end

	function Section:SetColor(color)
		self._text.SetColor(color)
		return self
	end

	function Section:SetIcon(spec)
		if self._icon then
			self._icon:Set(spec)
		end
		return self
	end

	function Section:SetIconColor(color)
		if self._icon then
			self._icon:SetColor(color)
		end
		return self
	end

	function Section:Collapse(instant)
		if self._collapsed then
			return self
		end
		self._collapsed = true
		self._animating = true
		Animation:Play(self._clip, { Size = UDim2.new(1, 0, 0, 0) }, {
			Duration = instant and 0 or 0.26,
			Ease = "Smooth",
			OnComplete = function()
				self._animating = false
			end,
		})
		if self._chevron then
			Animation:Play(self._chevron.Instance, { Rotation = -90 }, {
				Duration = instant and 0 or 0.26,
				Ease = "Smooth",
			})
		end
		return self
	end

	function Section:Expand(instant)
		if not self._collapsed then
			return self
		end
		self._collapsed = false
		self._animating = true
		local target = self.Container.AbsoluteSize.Y
		Animation:Play(self._clip, { Size = UDim2.new(1, 0, 0, target) }, {
			Duration = instant and 0 or 0.28,
			Ease = "Smooth",
			OnComplete = function()
				self._animating = false
				self._fit()
			end,
		})
		if self._chevron then
			Animation:Play(self._chevron.Instance, { Rotation = 0 }, {
				Duration = instant and 0 or 0.28,
				Ease = "Smooth",
			})
		end
		return self
	end

	function Section:Toggle()
		if self._collapsed then
			return self:Expand()
		end
		return self:Collapse()
	end

	function Section:IsCollapsed()
		return self._collapsed
	end

	function Section:SetVisible(visible)
		self.Frame.Visible = visible == true
		return self
	end

	function Section:Destroy()
		self.Cleanup:Clean()
	end

	return Section
end
end)()

__modules["Core/Card"] = (function()
return function(import)
	local Utility = import("Core/Utility")
	local Markup = import("Core/Markup")
	local Widgets = import("Core/Widgets")
	local Component = import("Core/Component")
	local Icons = import("Icons/Icon")
	local Animation = import("Services/Animation")

	local Card = {}
	Component.MakeContainer(Card)

	function Card.new(owner, config)
		if type(config) == "string" then
			config = { Title = config }
		end
		config = config or {}
		local self = setmetatable({}, Card)
		local tab = owner.TabRef or owner
		local window = owner.Window
		self.Window, self.Title, self.TabRef, self.SectionRef = window, config.Title, tab, self
		self.Config = config
		self.Cleanup = owner.Cleanup:Extend()
		self._order = 0
		self._collapsed = false
		self.NextOrder = function()
			self._order += 1
			return self._order
		end
		local cleanup = self.Cleanup

		local inset = config.Accent and 10 or 0
		local wrapper = Utility.Create("Frame", {
			Name = "Card",
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.new(1, 0, 0, 0),
			LayoutOrder = owner.NextOrder(),
			Parent = owner.Container,
		})
		cleanup:Add(wrapper)
		self.Wrapper = wrapper

		local frame, stroke = Widgets.Surface(cleanup, {
			Name = "Surface",
			Parent = wrapper,
			Fill = config.Fill or "SecondaryBackground",
			Transparency = config.Transparency or "ComponentTransparency",
			Stroke = config.Border or "Border",
			StrokeTransparency = "ComponentStrokeTransparency",
			Radius = config.Radius or 16,
			AutomaticSize = Enum.AutomaticSize.Y,
			Position = UDim2.fromOffset(inset, 0),
			Size = UDim2.new(1, -inset, 0, 0),
		})
		Widgets.Padding(frame, 12, 12)
		Widgets.List(frame, 10)
		self.Frame, self.Stroke = frame, stroke

		if config.Accent then
			Widgets.Surface(cleanup, {
				Name = "Accent",
				Parent = wrapper,
				Fill = config.Accent,
				Radius = "Full",
				AnchorPoint = Vector2.new(0, 0.5),
				Position = UDim2.new(0, 0, 0.5, 0),
				Size = UDim2.new(0, 3, 1, -16),
			})
		end

		if config.Title then
			local collapsible = config.Collapsible == true
			local header = Utility.Create(collapsible and "TextButton" or "Frame", {
				Name = "Header",
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 20),
				LayoutOrder = 0,
				Parent = frame,
			})
			Widgets.List(header, 7, {
				FillDirection = Enum.FillDirection.Horizontal,
				VerticalAlignment = Enum.VerticalAlignment.Center,
			})
			self.Header = header

			if config.Icon then
				local holder = Utility.Create("Frame", {
					BackgroundTransparency = 1,
					Size = UDim2.fromOffset(15, 15),
					LayoutOrder = 1,
					Parent = header,
				})
				self._icon = Icons.Create(holder, config.Icon, Icons.Options(config, {
					Size = 15,
					Color = config.IconColor or config.Accent or "Accent",
					Cleanup = cleanup,
				}))
			end
			local _, handle = Widgets.Text(cleanup, {
				Parent = header,
				Text = config.Title,
				Color = config.TitleColor or "Text",
				Gradient = config.TitleGradient,
				Bold = true,
				AutomaticSize = Enum.AutomaticSize.X,
				Size = UDim2.new(0, 0, 1, 0),
				LayoutOrder = 2,
			})
			self._text = handle

			if config.Badge then
				local badge = Widgets.Surface(cleanup, {
					Name = "Badge",
					Parent = header,
					Fill = config.BadgeColor or "Accent",
					Radius = "Full",
					Size = UDim2.new(0, 0, 0, 16),
					AutomaticSize = Enum.AutomaticSize.X,
					LayoutOrder = 3,
				})
				Widgets.Padding(badge, 7, 0)
				local _, badgeText = Widgets.Text(cleanup, {
					Parent = badge,
					Text = config.Badge,
					Color = config.BadgeTextColor or "AccentText",
					Bold = true,
					TextSize = 10,
					AutomaticSize = Enum.AutomaticSize.X,
					Size = UDim2.new(0, 0, 1, 0),
				})
				self._badge = badgeText
			end

			if collapsible then
				local chevronHolder = Utility.Create("Frame", {
					BackgroundTransparency = 1,
					AnchorPoint = Vector2.new(1, 0.5),
					Position = UDim2.new(1, 0, 0.5, 0),
					Size = UDim2.fromOffset(13, 13),
					Parent = header,
				})
				self._chevron = Icons.Create(chevronHolder, "chevron-down", {
					Size = 13,
					Color = "MutedText",
					Cleanup = cleanup,
				})
				cleanup:Add(header.Activated:Connect(function()
					self:Toggle()
				end))
			end
		end

		local clip = Utility.Create("Frame", {
			Name = "Clip",
			BackgroundTransparency = 1,
			ClipsDescendants = true,
			Size = UDim2.new(1, 0, 0, 0),
			LayoutOrder = 1,
			Parent = frame,
		})
		self._clip = clip

		self.Container = Utility.Create("Frame", {
			Name = "Body",
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.new(1, 0, 0, 0),
			Parent = clip,
		})
		Widgets.List(self.Container, config.Gap or 8)

		local function fit()
			if self._collapsed or self._animating then
				return
			end
			clip.Size = UDim2.new(1, 0, 0, self.Container.AbsoluteSize.Y)
		end
		cleanup:Add(self.Container:GetPropertyChangedSignal("AbsoluteSize"):Connect(fit))
		task.defer(fit)
		self._fit = fit

		if config.Title then
			self._entry = window:_IndexAdd({
				Kind = "Card",
				Title = Markup.Strip(config.Title),
				Tab = tab,
				Section = self,
				Frame = frame,
			})
			cleanup:Add(function()
				if self._entry then
					self._entry.Remove()
				end
			end)
		end
		if config.Collapsed == true then
			self:Collapse(true)
		end
		return self
	end

	function Card:AddCard(config)
		return Card.new(self, config)
	end

	function Card:AddSection(config)
		return import("Core/Section").new(self, config)
	end

	function Card:SetTitle(text)
		self.Title = text
		if self._text then
			self._text.SetText(text)
		end
		if self._entry then
			self._entry.Title = Markup.Strip(text)
		end
		return self
	end

	function Card:SetBadge(text)
		if self._badge then
			self._badge.SetText(text)
			Widgets.Pulse(self._badge.Instance, 0.8, 0.3)
		end
		return self
	end

	function Card:SetIcon(spec)
		if self._icon then
			self._icon:Set(spec)
		end
		return self
	end

	function Card:Collapse(instant)
		if self._collapsed then
			return self
		end
		self._collapsed = true
		self._animating = true
		Animation:Play(self._clip, { Size = UDim2.new(1, 0, 0, 0) }, {
			Duration = instant and 0 or 0.26,
			Ease = "Smooth",
			OnComplete = function()
				self._animating = false
			end,
		})
		if self._chevron then
			Animation:Play(self._chevron.Instance, { Rotation = -90 }, {
				Duration = instant and 0 or 0.26,
				Ease = "Smooth",
			})
		end
		return self
	end

	function Card:Expand(instant)
		if not self._collapsed then
			return self
		end
		self._collapsed = false
		self._animating = true
		Animation:Play(self._clip, { Size = UDim2.new(1, 0, 0, self.Container.AbsoluteSize.Y) }, {
			Duration = instant and 0 or 0.28,
			Ease = "Smooth",
			OnComplete = function()
				self._animating = false
				self._fit()
			end,
		})
		if self._chevron then
			Animation:Play(self._chevron.Instance, { Rotation = 0 }, {
				Duration = instant and 0 or 0.28,
				Ease = "Smooth",
			})
		end
		return self
	end

	function Card:Toggle()
		if self._collapsed then
			return self:Expand()
		end
		return self:Collapse()
	end

	function Card:SetVisible(visible)
		self.Wrapper.Visible = visible == true
		return self
	end

	function Card:Destroy()
		self.Cleanup:Clean()
	end

	return Card
end
end)()

__modules["Core/Tab"] = (function()
return function(import)
	local Utility = import("Core/Utility")
	local Theme = import("Core/Theme")
	local Markup = import("Core/Markup")
	local Widgets = import("Core/Widgets")
	local Component = import("Core/Component")
	local Section = import("Core/Section")
	local Animation = import("Services/Animation")
	local Icons = import("Icons/Icon")

	local SUBBAR = 34

	local SubTab = {}
	Component.MakeContainer(SubTab)

	local Tab = {}
	Component.MakeContainer(Tab)

	function SubTab.new(tab, config)
		if type(config) == "string" then
			config = { Title = config }
		end
		config = config or {}
		Utility.Check(type(config.Title) == "string", "SubTab", config.Title, "Title must be a string.")
		local self = setmetatable({}, SubTab)
		local window = tab.Window
		self.Window, self.Title, self.TabRef, self.SectionRef = window, config.Title, tab, nil
		self.Parent = tab
		self.Config = config
		self.Selected = false
		self.Cleanup = tab.Cleanup:Extend()
		self._order = 0
		self.NextOrder = function()
			self._order += 1
			return self._order
		end
		local cleanup = self.Cleanup

		local button = Widgets.Surface(cleanup, {
			Class = "TextButton",
			Name = "SubTab",
			Parent = tab._subBar,
			Fill = "SecondaryBackground",
			Transparency = 1,
			Radius = "Full",
			Size = UDim2.new(0, 0, 1, 0),
			AutomaticSize = Enum.AutomaticSize.X,
			LayoutOrder = #tab.SubTabs + 1,
		})
		cleanup:Add(button)
		self.Button = button
		Widgets.Padding(button, 12, 0)
		Widgets.List(button, 6, {
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
		})

		if config.Icon then
			local holder = Utility.Create("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.fromOffset(14, 14),
				LayoutOrder = 1,
				Parent = button,
			})
			self._icon = Icons.Create(holder, config.Icon, Icons.Options(config, {
				Size = 14,
				Color = config.IconColor or "MutedText",
				Cleanup = cleanup,
			}))
		end

		self.Label, self._text = Widgets.Text(cleanup, {
			Parent = button,
			Text = config.Title,
			Color = config.TitleColor or "MutedText",
			TextSize = 12,
			Bold = true,
			AutomaticSize = Enum.AutomaticSize.X,
			Size = UDim2.new(0, 0, 1, 0),
			LayoutOrder = 2,
		})

		local page = Widgets.Scroller(cleanup, {
			Name = "SubPage",
			Parent = tab._subHolder,
			Visible = false,
		})
		cleanup:Add(page)
		Widgets.Padding(page, 2, 2, 8, 10)
		Widgets.List(page, config.Gap or 9)
		self.Page, self.Container = page, page

		cleanup:Add(button.MouseEnter:Connect(function()
			self._hover = true
			self:_Visual()
		end))
		cleanup:Add(button.MouseLeave:Connect(function()
			self._hover = false
			self:_Visual()
		end))
		cleanup:Add(button.Activated:Connect(function()
			tab:SelectSubTab(self)
		end))
		Theme.BindFn(function()
			self:_Visual(true)
		end, cleanup)

		self._entry = window:_IndexAdd({
			Kind = "SubTab",
			Title = Markup.Strip(config.Title),
			Tab = tab,
			SubTab = self,
			Frame = page,
		})
		cleanup:Add(function()
			if self._entry then
				self._entry.Remove()
			end
		end)
		return self
	end

	function SubTab:_Visual(instant)
		local selected, hover = self.Selected, self._hover
		local goal = {
			BackgroundColor3 = Theme.Get(selected and "Accent" or "Hover"),
			BackgroundTransparency = selected and 0 or (hover and 0.6 or 1),
		}
		local textColor = Theme.Resolve(
			selected and (self.Config.SelectedColor or "AccentText") or (self.Config.TitleColor or "MutedText"),
			"MutedText"
		)
		if instant then
			for property, value in goal do
				self.Button[property] = value
			end
			self.Label.TextColor3 = textColor
		else
			Animation:Play(self.Button, goal, { Duration = Animation.Duration.Fast })
			Animation:Play(self.Label, { TextColor3 = textColor }, { Duration = Animation.Duration.Fast })
		end
		if self._icon then
			self._icon:SetColor(selected and (self.Config.SelectedColor or "AccentText") or (self.Config.IconColor or "MutedText"))
		end
	end

	function SubTab:_SetSelected(selected)
		self.Selected = selected
		self.Page.Visible = selected
		if selected then
			self.Page.Position = UDim2.fromOffset(0, 5)
			Animation:Play(self.Page, { Position = UDim2.new() }, { Duration = 0.24, Ease = "Smooth" })
			task.defer(function()
				if self.Selected then
					self.Parent:_Stagger()
				end
			end)
		end
		self:_Visual()
	end

	function SubTab:Select()
		self.Parent:SelectSubTab(self)
		return self
	end

	function SubTab:SetTitle(text)
		self.Title = text
		self._text.SetText(text)
		if self._entry then
			self._entry.Title = Markup.Strip(text)
		end
		return self
	end

	function SubTab:SetIcon(spec)
		if self._icon then
			self._icon:Set(spec)
		end
		return self
	end

	function SubTab:AddSection(config)
		return Section.new(self, config)
	end

	function SubTab:AddCard(config)
		return import("Core/Card").new(self, config)
	end

	function SubTab:Destroy()
		local parent = self.Parent
		local index = table.find(parent.SubTabs, self)
		if index then
			table.remove(parent.SubTabs, index)
		end
		local wasSelected = parent._subSelected == self
		if wasSelected then
			parent._subSelected = nil
		end
		self.Cleanup:Clean()
		if wasSelected and parent.SubTabs[1] then
			parent:SelectSubTab(parent.SubTabs[1])
		end
	end

	function Tab.new(window, config)
		if type(config) == "string" then
			config = { Title = config }
		end
		Utility.Check(
			type(config) == "table" and type(config.Title) == "string",
			"Tab",
			config and config.Title,
			"Title must be a string."
		)
		local self = setmetatable({}, Tab)
		self.Window, self.Title, self.Config = window, config.Title, config
		self.TabRef, self.SectionRef = self, nil
		self.SubTabs = {}
		self.Selected, self._hover, self._compact = false, false, false
		self._order = 0
		self.NextOrder = function()
			self._order += 1
			return self._order
		end
		self.Cleanup = window.Cleanup:Extend()
		local cleanup = self.Cleanup

		local button = Widgets.Surface(cleanup, {
			Class = "TextButton",
			Name = "Tab",
			Parent = window._tabList,
			Fill = "SecondaryBackground",
			BackgroundTransparency = 1,
			Radius = 9,
			Size = UDim2.new(1, 0, 0, 32),
			LayoutOrder = #window.Tabs + 1,
		})
		cleanup:Add(button)
		self.Button = button

		self._indicator = Widgets.Surface(cleanup, {
			Name = "Indicator",
			Parent = button,
			Fill = config.IndicatorColor or "Accent",
			Radius = "Full",
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0, 2, 0.5, 0),
			Size = UDim2.fromOffset(3, 0),
		})
		self._icon = Icons.Create(button, config.Icon, Icons.Options(config, {
			Size = config.IconSize or 16,
			Color = config.IconColor or "MutedText",
			Cleanup = cleanup,
		}))
		self.Label, self._text = Widgets.Text(cleanup, {
			Name = "Title",
			Parent = button,
			Text = config.Title,
			Color = config.TitleColor or "MutedText",
			Gradient = config.TitleGradient,
			TextTruncate = Enum.TextTruncate.AtEnd,
			Size = UDim2.new(1, -40, 1, 0),
			Position = UDim2.fromOffset(36, 0),
		})

		self._badge = Widgets.Surface(cleanup, {
			Name = "Badge",
			Parent = button,
			Fill = config.BadgeColor or "Accent",
			Radius = "Full",
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, -9, 0.5, 0),
			Size = UDim2.fromOffset(0, 16),
			AutomaticSize = Enum.AutomaticSize.X,
			Visible = false,
			ZIndex = 3,
		})
		Widgets.Padding(self._badge, 6, 0)
		local _, badgeText = Widgets.Text(cleanup, {
			Parent = self._badge,
			Text = "",
			Color = config.BadgeTextColor or "AccentText",
			Heavy = true,
			TextSize = 10,
			AutomaticSize = Enum.AutomaticSize.X,
			Size = UDim2.new(0, 0, 1, 0),
			Markup = false,
		})
		self._badgeText = badgeText
		if config.Badge then
			task.defer(function()
				self:SetBadge(config.Badge)
			end)
		end

		local page = Utility.Create("Frame", {
			Name = "Page",
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			Visible = false,
			Parent = window._pages,
		})
		cleanup:Add(page)
		self.Page = page

		self._subBar = Utility.Create("ScrollingFrame", {
			Name = "SubBar",
			BackgroundTransparency = 1,
			Size = UDim2.new(1, -12, 0, SUBBAR - 8),
			Position = UDim2.fromOffset(12, 4),
			CanvasSize = UDim2.new(),
			AutomaticCanvasSize = Enum.AutomaticSize.X,
			ScrollingDirection = Enum.ScrollingDirection.X,
			ScrollBarThickness = 0,
			Visible = false,
			Parent = page,
		})
		Widgets.List(self._subBar, 6, {
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
		})

		self._subHolder = Utility.Create("Frame", {
			Name = "SubPages",
			BackgroundTransparency = 1,
			ClipsDescendants = true,
			Position = UDim2.fromOffset(12, SUBBAR),
			Size = UDim2.new(1, -12, 1, -SUBBAR),
			Visible = false,
			Parent = page,
		})

		local body = Widgets.Scroller(cleanup, {
			Name = "Body",
			Parent = page,
		})
		Widgets.Padding(body, 12, 12, 14, 14)
		Widgets.List(body, config.Gap or 9)
		self.Body, self.Container = body, body

		cleanup:Add(button.MouseEnter:Connect(function()
			self._hover = true
			self:_Visual()
		end))
		cleanup:Add(button.MouseLeave:Connect(function()
			self._hover = false
			self:_Visual()
		end))
		cleanup:Add(button.Activated:Connect(function()
			window:SelectTab(self)
		end))
		Theme.BindFn(function()
			self:_Visual(true)
		end, cleanup)

		self._entry = window:_IndexAdd({
			Kind = "Tab",
			Title = Markup.Strip(config.Title),
			Tab = self,
		})
		cleanup:Add(function()
			if self._entry then
				self._entry.Remove()
			end
		end)
		self:_Layout()
		return self
	end

	function Tab:_Layout()
		local hasIcon = self._icon.Instance.Visible
		if self._compact then
			self._icon.Instance.AnchorPoint = Vector2.new(0.5, 0.5)
			self._icon.Instance.Position = UDim2.fromScale(0.5, 0.5)
			self.Label.Visible = false
		else
			self._icon.Instance.AnchorPoint = Vector2.zero
			self._icon.Instance.Position = UDim2.new(0, 13, 0.5, -(self._icon.Instance.Size.Y.Offset / 2))
			self.Label.Visible = true
			local x = hasIcon and 36 or 13
			local trail = (self._badge and self._badge.Visible) and (self._badge.AbsoluteSize.X + 14) or 8
			self.Label.Position = UDim2.fromOffset(x, 0)
			self.Label.Size = UDim2.new(1, -(x + trail), 1, 0)
		end
		if self._badge then
			self._badge.Visible = self._badgeOn == true and not self._compact
		end
	end

	function Tab:_SetCompact(compact)
		if self._compact ~= compact then
			self._compact = compact
			self:_Layout()
		end
	end

	function Tab:_Visual(instant)
		local selected, hover = self.Selected, self._hover
		local goal = {
			BackgroundColor3 = Theme.Get(selected and "SecondaryBackground" or "Hover"),
			BackgroundTransparency = selected and 0.1 or (hover and 0.55 or 1),
		}
		local textColor = Theme.Resolve(
			selected and (self.Config.SelectedColor or "Text") or (self.Config.TitleColor or "MutedText"),
			"MutedText"
		)
		local indicator = { Size = UDim2.fromOffset(3, selected and 15 or 0) }
		if instant then
			for property, value in goal do
				self.Button[property] = value
			end
			self.Label.TextColor3 = textColor
			self._indicator.Size = indicator.Size
		else
			Animation:Play(self.Button, goal, { Duration = Animation.Duration.Fast })
			Animation:Play(self.Label, { TextColor3 = textColor }, { Duration = Animation.Duration.Fast })
			Animation:Play(self._indicator, indicator, { Duration = Animation.Duration.Fast })
		end
		self._icon:SetColor(selected and (self.Config.SelectedColor or "Text") or (self.Config.IconColor or "MutedText"))
	end

	function Tab:_Stagger()
		local host = self._subSelected and self._subSelected.Container or self.Body
		if not host or not host.Visible then
			return
		end
		local items = {}
		for _, child in host:GetChildren() do
			if child:IsA("GuiObject") and child.Visible then
				table.insert(items, child)
			end
		end
		table.sort(items, function(a, b)
			return a.LayoutOrder < b.LayoutOrder
		end)
		Animation:Sequence(items, function(item, _, delay)
			local target = item.Position
			item.Position = UDim2.new(target.X.Scale, target.X.Offset - 14, target.Y.Scale, target.Y.Offset)
			Animation:Play(item, { Position = target }, {
				Duration = 0.3,
				Delay = delay,
				Ease = "Smooth",
			})
		end, { Limit = 14 })
	end

	function Tab:_SetSelected(selected)
		self.Selected = selected
		self.Page.Visible = selected
		if selected then
			self.Page.Position = UDim2.fromOffset(0, 6)
			Animation:Play(self.Page, { Position = UDim2.new() }, { Duration = 0.26, Ease = "Smooth" })
			task.defer(function()
				if self.Selected then
					self:_Stagger()
				end
			end)
		end
		self:_Visual()
	end

	function Tab:Select()
		self.Window:SelectTab(self)
		return self
	end

	function Tab:Deselect()
		if self.Window._selected == self then
			self.Window._selected = nil
		end
		self:_SetSelected(false)
		return self
	end

	function Tab:SetTitle(text)
		self.Title = text
		self._text.SetText(text)
		if self._entry then
			self._entry.Title = Markup.Strip(text)
		end
		return self
	end

	function Tab:SetTitleColor(color)
		self.Config.TitleColor = color
		self._text.SetColor(color)
		self:_Visual(true)
		return self
	end

	function Tab:SetIcon(spec)
		self._icon:Set(spec)
		self:_Layout()
		return self
	end

	function Tab:SetIconColor(color)
		self.Config.IconColor = color
		self._icon:SetColor(color)
		return self
	end

	function Tab:SetIconShape(shape, corner)
		self.Config.IconShape = shape
		if corner ~= nil then
			self.Config.IconCorner = corner
		end
		self._icon:SetShape(shape, corner)
		return self
	end

	function Tab:SetBadge(text)
		if text == nil or text == false or text == "" then
			self._badgeOn = false
			self._badge.Visible = false
			self:_Layout()
			return self
		end
		local first = not self._badgeOn
		self._badgeOn = true
		self._badgeText.SetText(tostring(text))
		self._badge.Visible = not self._compact
		Widgets.Pulse(self._badge, first and 0.5 or 0.82, 0.32)
		task.defer(function()
			if not self.Cleanup:IsCleaned() then
				self:_Layout()
			end
		end)
		return self
	end

	function Tab:GetBadge()
		return self._badgeOn and self._badgeText.Source or nil
	end

	function Tab:SetVisible(visible)
		self.Button.Visible = visible == true
		return self
	end

	function Tab:AddSection(config)
		return Section.new(self, config)
	end

	function Tab:AddCard(config)
		return import("Core/Card").new(self, config)
	end

	function Tab:AddSubTab(config)
		local sub = SubTab.new(self, config)
		table.insert(self.SubTabs, sub)
		if #self.SubTabs == 1 then
			self._subBar.Visible = true
			self._subHolder.Visible = true
			self.Body.Visible = false
		end
		if not self._subSelected then
			self:SelectSubTab(sub)
		end
		return sub
	end

	function Tab:SelectSubTab(target)
		local sub = target
		if type(target) == "number" then
			sub = self.SubTabs[target]
		elseif type(target) == "string" then
			sub = nil
			for _, candidate in self.SubTabs do
				if candidate.Title == target then
					sub = candidate
					break
				end
			end
		end
		if not sub or sub == self._subSelected then
			return self
		end
		if self._subSelected then
			self._subSelected:_SetSelected(false)
		end
		self._subSelected = sub
		sub:_SetSelected(true)
		return self
	end

	function Tab:GetSubTab(title)
		for _, sub in self.SubTabs do
			if sub.Title == title then
				return sub
			end
		end
		return nil
	end

	function Tab:Destroy()
		local window = self.Window
		local index = table.find(window.Tabs, self)
		if index then
			table.remove(window.Tabs, index)
		end
		local wasSelected = window._selected == self
		if wasSelected then
			window._selected = nil
		end
		Animation:CancelTree(self.Page)
		self.Cleanup:Clean()
		if wasSelected and window.Tabs[1] then
			window:SelectTab(window.Tabs[1])
		end
	end

	Tab.SubTab = SubTab
	return Tab
end
end)()

__modules["Core/Window"] = (function()
return function(import)
	local Workspace = game:GetService("Workspace")
	local UserInputService = game:GetService("UserInputService")
	local Utility = import("Core/Utility")
	local Signal = import("Core/Signal")
	local Theme = import("Core/Theme")
	local Markup = import("Core/Markup")
	local Widgets = import("Core/Widgets")
	local Search = import("Core/Search")
	local Config = import("Core/Config")
	local Capabilities = import("Core/Capabilities")
	local Tab = import("Core/Tab")
	local Cleanup = import("Services/Cleanup")
	local Animation = import("Services/Animation")
	local Input = import("Services/Input")
	local Drag = import("Services/Drag")
	local Acrylic = import("Services/Acrylic")
	local Icons = import("Icons/Icon")
	local Dialog = import("Components/Dialog")

	local Window = {}
	Window.__index = Window

	local TOPBAR = Capabilities.Mobile and 50 or 44
	local CORNER = 16
	local CONTROL = Capabilities.Mobile and 30 or 26

	function Window.new(config)
		Utility.Check(type(config) == "table", "Window", "?", "Config must be a table.")
		Utility.Check(config.Title == nil or type(config.Title) == "string", "Window", config.Title, "Title must be a string.")
		local self = setmetatable({}, Window)
		self.Options, self.Tabs = {}, {}
		self.Config = config
		self._search = Search.new()
		self.Cleanup = Cleanup.new()
		self.OnDestroy = Signal.new()
		self.MinimizedChanged = Signal.new()
		self.TabWidth = config.TabWidth or 152
		self.MinSize = config.MinSize or Vector2.new(400, 300)
		self.MaxSize = config.MaxSize or Vector2.new(1100, 860)
		self.Acrylic = config.Acrylic ~= false
		self._searchEnabled = config.Search ~= false and config.SearchEnabled ~= false
		self._minimized, self._destroyed, self._compact = false, false, false
		self._collapsed, self._maximized = false, false
		local cleanup = self.Cleanup

		if config.Theme then
			Theme.Set(config.Theme)
		end
		if config.Font then
			Theme.SetFont(config.Font)
		end
		if config.Scale then
			Theme.SetScale(config.Scale, true)
		end
		if config.LockTheme then
			Theme.Lock(type(config.LockTheme) == "string" and config.LockTheme or nil)
		end
		if config.LockScale then
			Theme.LockScale(type(config.LockScale) == "number" and config.LockScale or nil)
		end
		Input.Init()

		local gui = cleanup:Add(Utility.NewScreenGui("DeaDx_Window", config.DisplayOrder or 100))
		self.Gui = gui
		local size = config.Size or UDim2.fromOffset(580, 440)

		local root, rootStroke = Widgets.Surface(cleanup, {
			Class = "CanvasGroup",
			Name = "Window",
			Parent = gui,
			Stroke = "Border",
			Radius = CORNER,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = config.Position or UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromOffset(size.X.Offset, size.Y.Offset),
			BackgroundTransparency = 1,
			GroupTransparency = 1,
		})
		self.Root, self.RootStroke = root, rootStroke
		local uiScale = Instance.new("UIScale")
		uiScale.Parent = root
		Theme.BindScale(uiScale, cleanup)

		if self.Acrylic then
			self._paint = Acrylic.Paint(cleanup, {
				Parent = root,
				Radius = CORNER,
				Glass = config.Blur ~= false and config.Glass ~= false,
			})
			self._paint.Frame.ZIndex = 0
		else
			local fill = Widgets.Surface(cleanup, {
				Name = "Fill",
				Parent = root,
				Fill = "Background",
				Radius = CORNER,
				Size = UDim2.fromScale(1, 1),
				ZIndex = 0,
			})
			self._fill = fill
		end

		self._tint = Utility.Create("Frame", {
			Name = "Tint",
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			Visible = false,
			ZIndex = 1,
			Parent = root,
		})
		Utility.Create("UICorner", { CornerRadius = UDim.new(0, CORNER), Parent = self._tint })
		self._tintGradient = Utility.Create("UIGradient", { Parent = self._tint })

		self._image = Utility.Create("ImageLabel", {
			Name = "Backdrop",
			BackgroundTransparency = 1,
			Image = config.BackgroundImage or "",
			ImageTransparency = config.BackgroundImageTransparency or 0.65,
			ScaleType = Enum.ScaleType.Crop,
			Size = UDim2.fromScale(1, 1),
			Visible = (config.BackgroundImage or "") ~= "",
			ZIndex = 1,
			Parent = root,
		})
		Utility.Create("UICorner", { CornerRadius = UDim.new(0, CORNER), Parent = self._image })
		if config.Background then
			self:SetBackground(config.Background)
		end

		local topbar = Utility.Create("Frame", {
			Name = "Topbar",
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, TOPBAR),
			ZIndex = 4,
			Parent = root,
		})
		self._topbar = topbar
		self._topline = Widgets.Surface(cleanup, {
			Name = "TopbarLine",
			Parent = root,
			Fill = "Border",
			Radius = 0,
			Position = UDim2.fromOffset(0, TOPBAR),
			Size = UDim2.new(1, 0, 0, 1),
			ZIndex = 4,
		})

		local titles = Utility.Create("Frame", {
			Name = "Titles",
			BackgroundTransparency = 1,
			Position = UDim2.fromOffset(16, 0),
			Size = UDim2.new(0, 0, 1, 0),
			AutomaticSize = Enum.AutomaticSize.X,
			Parent = topbar,
		})
		Widgets.List(titles, 8, {
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
		})
		if config.Icon then
			local holder = Utility.Create("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.fromOffset(18, 18),
				LayoutOrder = 0,
				Parent = titles,
			})
			self._icon = Icons.Create(holder, config.Icon, Icons.Options(config, {
				Size = config.IconSize or 18,
				Color = config.IconColor or "Accent",
				Cleanup = cleanup,
			}))
		end
		self.TitleLabel, self._title = Widgets.Text(cleanup, {
			Name = "Title",
			Parent = titles,
			Text = config.Title or "DeaDx",
			Color = config.TitleColor or "Text",
			Gradient = config.TitleGradient,
			Bold = true,
			TextSize = 14,
			AutomaticSize = Enum.AutomaticSize.X,
			Size = UDim2.new(0, 0, 1, 0),
			LayoutOrder = 1,
		})
		local subtitle = config.SubTitle or config.Subtitle or ""
		self.SubtitleLabel, self._subtitle = Widgets.Text(cleanup, {
			Name = "Subtitle",
			Parent = titles,
			Text = subtitle,
			Color = config.SubTitleColor or "MutedText",
			TextSize = 11,
			AutomaticSize = Enum.AutomaticSize.X,
			Size = UDim2.new(0, 0, 1, 0),
			LayoutOrder = 2,
			Visible = subtitle ~= "",
		})

		local controls = Utility.Create("Frame", {
			Name = "Controls",
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, -12, 0.5, 0),
			Size = UDim2.new(0, 0, 0, CONTROL),
			AutomaticSize = Enum.AutomaticSize.X,
			Parent = topbar,
		})
		Widgets.List(controls, 6, {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Right,
			VerticalAlignment = Enum.VerticalAlignment.Center,
		})

		local controlsWidth = 0
		local function control(iconName, order, callback)
			controlsWidth += CONTROL + 6
			local button = Widgets.Chip(cleanup, {
				Name = "Control",
				Parent = controls,
				Fill = "SecondaryBackground",
				Transparency = "ElementTransparency",
				Radius = "Full",
				Size = UDim2.fromOffset(CONTROL, CONTROL),
				LayoutOrder = order,
			})
			local icon = Icons.Create(button, iconName, {
				Size = 13,
				Position = UDim2.fromOffset((CONTROL - 13) / 2, (CONTROL - 13) / 2),
				Cleanup = cleanup,
			})
			cleanup:Add(button.Activated:Connect(callback))
			return button, icon
		end

		if config.CollapseButton ~= false then
			local _, icon = control("chevrons-up-down", 1, function()
				self:ToggleCollapsed()
			end)
			self._collapseIcon = icon
		end
		if config.MaximizeButton == true then
			control("maximize-2", 2, function()
				self:ToggleMaximized()
			end)
		end
		control("minus", 3, function()
			self:Minimize()
		end)
		if config.CloseButton ~= false then
			control("x", 4, function()
				if config.ConfirmClose then
					self:CreateDialog({
						Title = "Close",
						Content = "Close this window?",
						Buttons = {
							{ Title = "Cancel" },
							{
								Title = "Close",
								Primary = true,
								Callback = function()
									Utility.SafeCall("Window OnClose", config.OnClose)
									self:Destroy()
								end,
							},
						},
					})
					return
				end
				Utility.SafeCall("Window OnClose", config.OnClose)
				self:Destroy()
			end)
		end

		local searchBox, searchStroke = Widgets.Surface(cleanup, {
			Name = "Search",
			Parent = topbar,
			Fill = "TertiaryBackground",
			Stroke = "Border",
			StrokeTransparency = 0.45,
			Transparency = "ElementTransparency",
			Radius = "Full",
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, -(controlsWidth + 14), 0.5, 0),
			Size = UDim2.fromOffset(150, CONTROL),
		})
		self._searchBox, self._searchStroke = searchBox, searchStroke
		Icons.Create(searchBox, "search", {
			Size = 13,
			Position = UDim2.fromOffset(9, (CONTROL - 13) / 2),
			Cleanup = cleanup,
		})
		local searchInput = Widgets.Text(cleanup, {
			Class = "TextBox",
			Name = "SearchInput",
			Parent = searchBox,
			PlaceholderText = "Search...",
			ClearTextOnFocus = false,
			TextSize = 12,
			Position = UDim2.fromOffset(28, 0),
			Size = UDim2.new(1, -36, 1, 0),
		})
		self._searchInput = searchInput

		local sidebar = Utility.Create("Frame", {
			Name = "Sidebar",
			BackgroundTransparency = 1,
			Position = UDim2.fromOffset(0, TOPBAR + 1),
			Size = UDim2.new(0, self.TabWidth, 1, -(TOPBAR + 1)),
			ZIndex = 3,
			Parent = root,
		})
		self._sidebar = sidebar
		self._sideline = Widgets.Surface(cleanup, {
			Name = "SidebarLine",
			Parent = sidebar,
			Fill = "Border",
			Radius = 0,
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.fromScale(1, 0),
			Size = UDim2.new(0, 1, 1, 0),
		})
		local tabList = Widgets.Scroller(cleanup, {
			Name = "Tabs",
			Parent = sidebar,
			Size = UDim2.new(1, -1, 1, 0),
			Thickness = 0,
		})
		Widgets.Padding(tabList, 8, 8)
		Widgets.List(tabList, 4)
		self._tabList = tabList

		if config.Footer then
			local footer = Utility.Create("Frame", {
				Name = "Footer",
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(0, 1),
				Position = UDim2.fromScale(0, 1),
				Size = UDim2.new(1, -1, 0, 34),
				Parent = sidebar,
			})
			Widgets.Padding(footer, 12, 0)
			local _, handle = Widgets.Text(cleanup, {
				Parent = footer,
				Text = config.Footer,
				Color = config.FooterColor or "MutedText",
				TextSize = 11,
				Size = UDim2.fromScale(1, 1),
			})
			self._footer = handle
			tabList.Size = UDim2.new(1, -1, 1, -34)
		end

		self._pages = Utility.Create("Frame", {
			Name = "Content",
			BackgroundTransparency = 1,
			ClipsDescendants = true,
			Position = UDim2.fromOffset(self.TabWidth, TOPBAR + 1),
			Size = UDim2.new(1, -self.TabWidth, 1, -(TOPBAR + 1)),
			ZIndex = 2,
			Parent = root,
		})
		self._content = self._pages

		local function layer(name, order, parent)
			return Utility.Create("Frame", {
				Name = name,
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 1),
				ZIndex = order,
				Parent = parent or root,
			})
		end
		if config.PopupsOutside == true or config.DropdownsOutsideWindow == true then
			self._popupGui = cleanup:Add(Utility.NewScreenGui("DeaDx_Popups", (config.DisplayOrder or 100) + 5))
			self._popupLayer = layer("Popups", 1, self._popupGui)
			self._outside = true
		else
			self._popupLayer = layer("Popups", 20)
		end
		local searchLayer = layer("SearchLayer", 30)
		self._dialogLayer = layer("Dialogs", 40)

		local results = Widgets.Surface(cleanup, {
			Class = "ScrollingFrame",
			Name = "Results",
			Parent = searchLayer,
			Fill = "SecondaryBackground",
			Stroke = "Border",
			Radius = 12,
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.new(1, -10, 0, TOPBAR + 6),
			Size = UDim2.fromOffset(300, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			CanvasSize = UDim2.new(),
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			ScrollBarThickness = 3,
			ScrollingDirection = Enum.ScrollingDirection.Y,
			Visible = false,
		})
		Utility.Create("UISizeConstraint", { MaxSize = Vector2.new(300, 280), Parent = results })
		Widgets.Padding(results, 5)
		Widgets.List(results, 2)

		local function showResults(text)
			if self._results then
				self._results:Clean()
			end
			local rc = cleanup:Extend()
			self._results = rc
			if text == "" then
				results.Visible = false
				return
			end
			results.Visible = true
			local list = self._search:Query(text)
			if #list == 0 then
				Widgets.Text(rc, {
					Parent = results,
					Text = "No results",
					Color = "MutedText",
					Size = UDim2.new(1, 0, 0, 32),
					TextXAlignment = Enum.TextXAlignment.Center,
				})
				return
			end
			for index, entry in list do
				local row = Widgets.Surface(rc, {
					Class = "TextButton",
					Name = "Result",
					Parent = results,
					Fill = "SecondaryBackground",
					Radius = 10,
					Size = UDim2.new(1, 0, 0, 40),
					LayoutOrder = index,
				})
				rc:Add(row)
				local crumb = { entry.Tab and entry.Tab.Title or "?" }
				if entry.SubTab then
					table.insert(crumb, entry.SubTab.Title)
				end
				if entry.Section and entry.Kind ~= "Section" then
					table.insert(crumb, entry.Section.Title)
				end
				if entry.Kind ~= "Tab" and entry.Kind ~= "Section" and entry.Kind ~= "SubTab" then
					table.insert(crumb, entry.Kind)
				end
				Widgets.Text(rc, {
					Parent = row,
					Text = entry.Title,
					Bold = true,
					Position = UDim2.fromOffset(10, 5),
					Size = UDim2.new(1, -20, 0, 15),
					TextTruncate = Enum.TextTruncate.AtEnd,
					Markup = false,
				})
				Widgets.Text(rc, {
					Parent = row,
					Text = table.concat(crumb, "  /  "),
					Color = "MutedText",
					TextSize = 11,
					Position = UDim2.fromOffset(10, 21),
					Size = UDim2.new(1, -20, 0, 14),
					TextTruncate = Enum.TextTruncate.AtEnd,
					Markup = false,
				})
				Widgets.Interactive(rc, row, row, {})
				rc:Add(row.Activated:Connect(function()
					searchInput.Text = ""
					self:_GoTo(entry)
				end))
			end
		end

		cleanup:Add(searchInput:GetPropertyChangedSignal("Text"):Connect(function()
			showResults(searchInput.Text)
		end))
		cleanup:Add(searchInput.Focused:Connect(function()
			if searchInput.Text ~= "" then
				results.Visible = true
			end
		end))
		cleanup:Add(searchInput.FocusLost:Connect(function()
			task.delay(0.2, function()
				if not self._destroyed and not searchInput:IsFocused() then
					results.Visible = false
				end
			end)
		end))

		Drag.Attach(topbar, root, cleanup, {
			Ignore = { controls, searchBox },
			Blocked = function()
				return self._maximized
			end,
		})

		if config.Resize ~= false then
			local grip = Utility.Create("TextButton", {
				Name = "ResizeGrip",
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(1, 1),
				Position = UDim2.new(1, -3, 1, -3),
				Size = UDim2.fromOffset(16, 16),
				ZIndex = 15,
				Parent = root,
			})
			Icons.Create(grip, "grip", { Size = 13, Position = UDim2.fromOffset(1.5, 1.5), Cleanup = cleanup })
			self._grip = grip
			Drag.Resize(grip, root, cleanup, {
				Min = self.MinSize,
				Max = self.MaxSize,
				GetScale = function()
					return Theme.Scale
				end,
				OnResize = function()
					self._maximized = false
					self:_Clamp()
				end,
			})
		end

		if config.RestoreButton ~= false then
			self:_BuildPill(config)
		end

		local cameraConnection
		local function hookCamera()
			if cameraConnection then
				cameraConnection:Disconnect()
				cameraConnection = nil
			end
			local camera = Workspace.CurrentCamera
			if camera then
				cameraConnection = camera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
					self:_Clamp()
				end)
			end
		end
		hookCamera()
		cleanup:Add(function()
			if cameraConnection then
				cameraConnection:Disconnect()
			end
		end)
		cleanup:Add(Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
			hookCamera()
			self:_Clamp()
		end))
		cleanup:Add(Theme.ScaleChanged:Connect(function()
			self:_Clamp()
		end))
		cleanup:Add(root:GetPropertyChangedSignal("Size"):Connect(function()
			self:_UpdateLayout()
		end))
		cleanup:Add(self.OnDestroy)
		cleanup:Add(self.MinimizedChanged)

		self:SetMinimizeKey(config.MinimizeKey)
		self._modifier = config.Modifier ~= false and (config.Modifier or Enum.KeyCode.LeftControl) or nil
		if config.UndoKey or config.RedoKey then
			self:SetUndoKeys(config.UndoKey, config.RedoKey)
		end
		if config.Palette ~= false then
			task.defer(function()
				if not self._destroyed then
					self:CreatePalette(config.Palette)
				end
			end)
		end
		self:_Clamp()
		self:_UpdateLayout()
		uiScale.Scale = Theme.Scale * 0.965
		Animation:Play(root, { GroupTransparency = 0 }, { Duration = 0.26, Ease = "Smooth" })
		Animation:Play(uiScale, { Scale = Theme.Scale }, { Duration = 0.38, Ease = "Snap" })
		return self
	end

	function Window:_BuildPill(config)
		local cleanup = self.Cleanup
		local pillGui = cleanup:Add(Utility.NewScreenGui("DeaDx_Restore", (config.DisplayOrder or 100) + 1))
		pillGui.IgnoreGuiInset = true
		local pill = Widgets.Surface(cleanup, {
			Class = "TextButton",
			Name = "Restore",
			Parent = pillGui,
			Fill = "SecondaryBackground",
			Transparency = "ElementTransparency",
			Stroke = "Border",
			Radius = "Full",
			AnchorPoint = Vector2.new(0.5, 0),
			Position = config.RestorePosition or UDim2.new(0.5, 0, 0, 10),
			Size = UDim2.fromOffset(0, 32),
			AutomaticSize = Enum.AutomaticSize.X,
			Visible = false,
		})
		Widgets.Padding(pill, 12, 0)
		Widgets.List(pill, 8, {
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
		})
		local scale = Instance.new("UIScale")
		scale.Scale = 0.92
		scale.Parent = pill

		if config.Icon then
			local holder = Utility.Create("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.fromOffset(15, 15),
				LayoutOrder = 1,
				Parent = pill,
			})
			Icons.Create(holder, config.Icon, { Size = 15, Color = "Accent", Cleanup = cleanup })
		end
		Widgets.Text(cleanup, {
			Name = "Brand",
			Parent = pill,
			Text = config.RestoreText or config.Title or "DeaDx",
			Color = config.TitleColor or "Text",
			Bold = true,
			TextSize = 13,
			AutomaticSize = Enum.AutomaticSize.X,
			Size = UDim2.new(0, 0, 1, 0),
			LayoutOrder = 2,
		})
		local chevronHolder = Utility.Create("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.fromOffset(14, 14),
			LayoutOrder = 3,
			Parent = pill,
		})
		local chevron = Icons.Create(chevronHolder, "chevron-down", { Size = 14, Color = "MutedText", Cleanup = cleanup })

		Widgets.Interactive(cleanup, pill, pill, {})
		cleanup:Add(pill.Activated:Connect(function()
			self:Restore()
		end))
		if config.RestoreDraggable ~= false then
			Drag.Attach(pill, pill, cleanup, { Margin = 16 })
		end
		self._pill = { Frame = pill, Scale = scale, Chevron = chevron.Instance }
	end

	function Window:_Clamp()
		if self._destroyed then
			return
		end
		local camera = Workspace.CurrentCamera
		if not camera then
			return
		end
		local viewport = camera.ViewportSize
		local scale = Theme.Scale
		local maxW = math.min(self.MaxSize.X, viewport.X / scale - 20)
		local maxH = math.min(self.MaxSize.Y, viewport.Y / scale - 20)
		local minW = math.min(self.MinSize.X, maxW)
		local minH = math.min(self.MinSize.Y, maxH)
		if self._collapsed then
			minH, maxH = TOPBAR, math.max(TOPBAR, maxH)
		end
		local size = self.Root.Size
		local width = math.clamp(size.X.Offset, minW, maxW)
		local height = math.clamp(size.Y.Offset, minH, maxH)
		if width ~= size.X.Offset or height ~= size.Y.Offset then
			self.Root.Size = UDim2.fromOffset(width, height)
		end
	end

	function Window:_UpdateLayout()
		if self._destroyed then
			return
		end
		local width = self.Root.Size.X.Offset
		local compact = width < 520
		local sidebar = compact and 50 or self.TabWidth
		self._compact = compact
		self._sidebar.Size = UDim2.new(0, sidebar, 1, -(TOPBAR + 1))
		self._content.Position = UDim2.fromOffset(sidebar, TOPBAR + 1)
		self._content.Size = UDim2.new(1, -sidebar, 1, -(TOPBAR + 1))
		for _, tab in self.Tabs do
			tab:_SetCompact(compact)
		end
		self._searchBox.Visible = self._searchEnabled and width >= 470 and not self._collapsed
	end

	function Window:_IndexAdd(entry)
		return self._search:Add(entry)
	end

	function Window:_GoTo(entry)
		local tab = entry.Tab
		if self._destroyed or not tab or tab.Cleanup:IsCleaned() then
			return
		end
		if self._minimized then
			self:Restore()
		end
		if self._collapsed then
			self:SetCollapsed(false)
		end
		self:SelectTab(tab)
		if entry.SubTab then
			tab:SelectSubTab(entry.SubTab)
		end
		if entry.Kind == "Tab" or entry.Kind == "SubTab" then
			return
		end
		task.delay(0.22, function()
			if self._destroyed then
				return
			end
			local frame = entry.Frame
			if not frame or not frame.Parent then
				return
			end
			local page = entry.SubTab and entry.SubTab.Page or tab.Body
			if not page or not page:IsA("ScrollingFrame") then
				page = frame:FindFirstAncestorWhichIsA("ScrollingFrame")
			end
			if page then
				local offset = (frame.AbsolutePosition.Y - page.AbsolutePosition.Y) / Theme.Scale + page.CanvasPosition.Y - 10
				Animation:Play(page, { CanvasPosition = Vector2.new(0, math.max(0, offset)) }, { Duration = 0.25 })
			end
			if entry.Component and entry.Component.Flash then
				entry.Component:Flash("Accent")
			end
		end)
	end

	function Window:AddTab(config)
		Utility.Check(not self._destroyed, "Tab", config and config.Title, "Window is destroyed.")
		local tab = Tab.new(self, config)
		table.insert(self.Tabs, tab)
		tab:_SetCompact(self._compact)
		if not self._selected then
			self:SelectTab(tab)
		end
		return tab
	end

	function Window:SelectTab(target)
		if self._destroyed then
			return self
		end
		local tab = target
		if type(target) == "number" then
			tab = self.Tabs[target]
		elseif type(target) == "string" then
			tab = nil
			for _, candidate in self.Tabs do
				if candidate.Title == target then
					tab = candidate
					break
				end
			end
		end
		if not tab or tab == self._selected then
			return self
		end
		self:ClosePopup()
		if self._selected then
			self._selected:_SetSelected(false)
		end
		self._selected = tab
		tab:_SetSelected(true)
		return self
	end
	Window.SetTab = Window.SelectTab

	function Window:GetTab(title)
		for _, tab in self.Tabs do
			if tab.Title == title then
				return tab
			end
		end
		return nil
	end

	function Window:SetTitle(text)
		self._title.SetText(text)
		return self
	end

	function Window:SetTitleColor(color)
		self._title.SetColor(color)
		return self
	end

	function Window:SetSubTitle(text)
		text = text or ""
		self._subtitle.SetText(text)
		self.SubtitleLabel.Visible = text ~= ""
		return self
	end
	Window.SetSubtitle = Window.SetSubTitle

	function Window:SetIcon(spec)
		if self._icon then
			self._icon:Set(spec)
		end
		return self
	end

	function Window:SetIconShape(shape, corner)
		self.Config.IconShape = shape
		if corner ~= nil then
			self.Config.IconCorner = corner
		end
		if self._icon then
			self._icon:SetShape(shape, corner)
		end
		return self
	end

	function Window:SetFooter(text)
		if self._footer then
			self._footer.SetText(text)
		end
		return self
	end

	function Window:SetTheme(name)
		return Theme.Set(name)
	end

	function Window:SetSearchEnabled(enabled)
		self._searchEnabled = enabled == true
		if not self._searchEnabled then
			self._searchInput.Text = ""
		end
		self:_UpdateLayout()
		return self
	end

	function Window:ToggleSearch()
		return self:SetSearchEnabled(not self._searchEnabled)
	end

	function Window:SetBackgroundImage(image, transparency)
		self._image.Image = image or ""
		if transparency ~= nil then
			self._image.ImageTransparency = transparency
		end
		self._image.Visible = (image or "") ~= ""
		return self
	end

	function Window:SetBackground(config)
		if type(config) == "string" then
			config = { Image = config }
		end
		if type(config) ~= "table" then
			return self
		end
		if config.Image ~= nil then
			self._image.Image = config.Image
			self._image.Visible = config.Image ~= ""
		end
		if config.Transparency ~= nil then
			Animation:Play(self._image, { ImageTransparency = config.Transparency }, { Duration = 0.2 })
		end
		if config.ScaleType ~= nil then
			self._image.ScaleType = config.ScaleType
		end
		if config.TileSize ~= nil then
			self._image.TileSize = config.TileSize
		end
		if config.ImageColor ~= nil then
			self._image.ImageColor3 = Theme.Resolve(config.ImageColor, "Text")
		end

		local stops = Widgets.Stops(config.Gradient)
		if stops then
			self._tintGradient.Color = stops
			self._tintGradient.Rotation = config.Rotation or 90
			self._tint.BackgroundColor3 = Color3.new(1, 1, 1)
			self._tint.BackgroundTransparency = config.TintTransparency or 0.25
			self._tint.Visible = true
		elseif config.Color ~= nil then
			self._tintGradient.Color = ColorSequence.new(Color3.new(1, 1, 1))
			self._tint.BackgroundColor3 = Theme.Resolve(config.Color, "Background")
			self._tint.BackgroundTransparency = config.TintTransparency or 0.2
			self._tint.Visible = true
		elseif config.Color == false or config.Gradient == false then
			self._tint.Visible = false
		end
		return self
	end

	function Window:SetAcrylic(enabled)
		self.Acrylic = enabled == true
		if self._paint then
			self._paint.SetVisible(self.Acrylic and not self._minimized)
		end
		if self.Acrylic then
			Acrylic.Enable()
		else
			Acrylic.Disable()
		end
		return self
	end

	function Window:SetTransparency(value)
		value = math.clamp(tonumber(value) or 0, 0, 1)
		if self._paint then
			self._paint.SetTransparency(value)
		elseif self._fill then
			Animation:Play(self._fill, { BackgroundTransparency = value }, { Duration = 0.2 })
		end
		return self
	end

	function Window:SetMinimizeKey(key)
		if self._minimizeBind then
			self._minimizeBind:Destroy()
			self._minimizeBind = nil
		end
		if key ~= nil then
			Utility.Check(typeof(key) == "EnumItem", "Window", "MinimizeKey", "MinimizeKey must be an Enum.KeyCode.")
			self._minimizeBind = self.Cleanup:Add(Input.AddBind(key, function()
				self:Toggle()
			end, "Window toggle"))
		end
		return self
	end

	function Window:SetCollapsed(value)
		value = value == true
		if self._collapsed == value or self._destroyed then
			return self
		end
		self._collapsed = value
		local root = self.Root
		local width = root.Size.X.Offset
		local anchor = root.AnchorPoint.Y
		local position = root.Position
		local target = value and TOPBAR or (self._restoreHeight or 440)
		local shift = (root.Size.Y.Offset - target) * anchor

		if value then
			self._restoreHeight = root.Size.Y.Offset
			self._sidebar.Visible = false
			self._content.Visible = false
			self._topline.Visible = false
			if self._grip then
				self._grip.Visible = false
			end
		end

		Animation:Play(root, {
			Size = UDim2.fromOffset(width, target),
			Position = UDim2.new(position.X.Scale, position.X.Offset, position.Y.Scale, position.Y.Offset - shift),
		}, {
			Duration = 0.22,
			Style = Enum.EasingStyle.Quint,
			OnComplete = function()
				if not self._destroyed and not value then
					self:_Clamp()
				end
			end,
		})

		if not value then
			self._sidebar.Visible = true
			self._content.Visible = true
			self._topline.Visible = true
			if self._grip then
				self._grip.Visible = true
			end
		end
		if self._collapseIcon then
			Animation:Play(self._collapseIcon.Instance, { Rotation = value and 180 or 0 }, { Duration = 0.2 })
		end
		self:_UpdateLayout()
		return self
	end

	function Window:ToggleCollapsed()
		return self:SetCollapsed(not self._collapsed)
	end

	function Window:IsCollapsed()
		return self._collapsed
	end

	function Window:SetMaximized(value)
		value = value == true
		if self._maximized == value or self._destroyed then
			return self
		end
		local camera = Workspace.CurrentCamera
		if not camera then
			return self
		end
		self._maximized = value
		if value then
			self._restoreRect = { Size = self.Root.Size, Position = self.Root.Position }
			local viewport = camera.ViewportSize / Theme.Scale
			Animation:Play(self.Root, {
				Size = UDim2.fromOffset(math.min(viewport.X - 20, self.MaxSize.X), math.min(viewport.Y - 20, self.MaxSize.Y)),
				Position = UDim2.fromScale(0.5, 0.5),
			}, { Duration = 0.22 })
		elseif self._restoreRect then
			Animation:Play(self.Root, {
				Size = self._restoreRect.Size,
				Position = self._restoreRect.Position,
			}, { Duration = 0.22 })
		end
		return self
	end

	function Window:ToggleMaximized()
		return self:SetMaximized(not self._maximized)
	end

	function Window:_Pill(show)
		local pill = self._pill
		if not pill then
			return
		end
		if show then
			pill.Frame.Visible = true
			pill.Chevron.Rotation = 180
			pill.Scale.Scale = 0.92
			Animation:Play(pill.Scale, { Scale = 1 }, { Duration = Animation.Duration.Normal })
			Animation:Play(pill.Chevron, { Rotation = 0 }, { Duration = Animation.Duration.Normal })
		else
			Animation:Play(pill.Chevron, { Rotation = 180 }, { Duration = Animation.Duration.Fast })
			Animation:Play(pill.Scale, { Scale = 0.92 }, {
				Duration = Animation.Duration.Fast,
				OnComplete = function()
					if not self._minimized and not self._destroyed then
						pill.Frame.Visible = false
					end
				end,
			})
		end
	end

	function Window:Minimize()
		if self._minimized or self._destroyed then
			return self
		end
		self._minimized = true
		self:ClosePopup()
		if self._paint then
			self._paint.SetVisible(false)
		end
		Acrylic.Disable()
		self:_Pill(true)
		self.Root.Visible = false
		if self._popupGui then
			self._popupGui.Enabled = false
		end
		self.MinimizedChanged:Fire(true)
		return self
	end

	function Window:Restore()
		if not self._minimized or self._destroyed then
			return self
		end
		self._minimized = false
		self:_Clamp()
		self.Root.Visible = true
		if self._popupGui then
			self._popupGui.Enabled = true
		end
		self:_Pill(false)
		if self._paint then
			self._paint.SetVisible(true)
			if self.Acrylic then
				Acrylic.Enable()
			end
		end
		self.MinimizedChanged:Fire(false)
		return self
	end

	function Window:ToggleMinimize()
		if self._minimized then
			return self:Restore()
		end
		return self:Minimize()
	end
	Window.Toggle = Window.ToggleMinimize

	function Window:IsMinimized()
		return self._minimized
	end

	function Window:Notify(config)
		return import("Services/Notification").Notify(config)
	end

	function Window:Toast(text, kind)
		return import("Services/Notification").Notify({
			Title = text,
			Type = kind or "Info",
			Duration = 2,
			Progress = false,
		})
	end

	function Window:Focus(component)
		if type(component) == "string" then
			component = self.Options[component]
		end
		if not component or not component._entry then
			return self
		end
		self:_GoTo(component._entry)
		return self
	end

	function Window:Index()
		return self._search
	end

	function Window:Tour(steps, config)
		if self._tour and self._tour:IsRunning() then
			self._tour:Finish(true)
		end
		self._tour = import("Services/Tour").new(self, steps, config)
		self.Cleanup:Add(self._tour)
		return self._tour
	end

	function Window:CreatePalette(config)
		if self._palette then
			return self._palette
		end
		config = type(config) == "table" and config or {}
		self._palette = import("Services/Palette").new(self, config)
		self.Cleanup:Add(self._palette)
		return self._palette
	end

	function Window:GetPalette()
		return self._palette
	end

	function Window:SetUndoKeys(undo, redo)
		for _, bind in self._historyBinds or {} do
			bind:Destroy()
		end
		self._historyBinds = {}
		local function hook(key, action, label)
			if key == nil then
				return
			end
			table.insert(
				self._historyBinds,
				self.Cleanup:Add(Input.AddBind(key, function()
					if self._modifier and not UserInputService:IsKeyDown(self._modifier) then
						return
					end
					local ok, id = action()
					if ok then
						self:Toast(label .. ": " .. tostring(id))
					end
				end, label))
			)
		end
		hook(undo, function()
			return Config:Undo()
		end, "Undone")
		hook(redo, function()
			return Config:Redo()
		end, "Redone")
		return self
	end

	function Window:CreateDialog(config)
		Utility.Check(not self._destroyed, "Dialog", config and config.Title, "Window is destroyed.")
		return Dialog.new(self, config)
	end
	Window.Dialog = Window.CreateDialog

	function Window:OpenPopup(anchor, width, height)
		self:ClosePopup()
		local layer = self._popupLayer
		local cleanup = self.Cleanup:Extend()
		local closed = Signal.new()
		cleanup:Add(closed)

		local catcher = Utility.Create("TextButton", {
			Name = "PopupCatcher",
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			Parent = layer,
		})
		cleanup:Add(catcher)
		local frame = Widgets.Surface(cleanup, {
			Class = "CanvasGroup",
			Name = "Popup",
			Parent = layer,
			Fill = "SecondaryBackground",
			Stroke = "Border",
			Radius = 12,
			Size = UDim2.fromOffset(width, height),
			GroupTransparency = 1,
			ZIndex = 2,
		})
		cleanup:Add(frame)
		local base = self._outside and Theme.Scale or 1
		local scale = Instance.new("UIScale")
		scale.Scale = base * 0.95
		scale.Parent = frame

		local popup
		local x, y = 0, 0

		local function place()
			local uiScale = Theme.Scale
			local bounds, origin
			if self._outside then
				bounds = layer.AbsoluteSize / uiScale
				origin = Vector2.zero
			else
				bounds = Vector2.new(self.Root.Size.X.Offset, self.Root.Size.Y.Offset)
				origin = self.Root.AbsolutePosition
			end
			local anchorPosition = (anchor.AbsolutePosition - origin) / uiScale
			local anchorSize = anchor.AbsoluteSize / uiScale
			x = anchorPosition.X + anchorSize.X - popup.Width
			y = anchorPosition.Y + anchorSize.Y + 4
			if y + popup.Height > bounds.Y - 8 then
				local above = anchorPosition.Y - popup.Height - 4
				if above >= 8 then
					y = above
				end
			end
			x = math.clamp(x, 8, math.max(8, bounds.X - popup.Width - 8))
			y = math.clamp(y, 8, math.max(8, bounds.Y - popup.Height - 8))
			frame.Position = UDim2.fromOffset(x, y)
		end

		popup = { Frame = frame, Cleanup = cleanup, Closed = closed, Width = width, Height = height, Anchor = anchor }
		local isClosed = false

		local viewport = anchor:FindFirstAncestorWhichIsA("ScrollingFrame")
		local function follow()
			if isClosed then
				return
			end
			if viewport then
				local top = viewport.AbsolutePosition.Y
				local bottom = top + viewport.AbsoluteSize.Y
				local anchorTop = anchor.AbsolutePosition.Y
				local anchorBottom = anchorTop + anchor.AbsoluteSize.Y
				local hidden = anchorBottom < top - 2 or anchorTop > bottom + 2
				frame.Visible = not hidden
				if hidden then
					return
				end
			end
			place()
		end

		place()
		cleanup:Add(anchor:GetPropertyChangedSignal("AbsolutePosition"):Connect(follow))
		cleanup:Add(anchor:GetPropertyChangedSignal("AbsoluteSize"):Connect(follow))
		cleanup:Add(self.Root:GetPropertyChangedSignal("AbsolutePosition"):Connect(follow))
		cleanup:Add(Theme.ScaleChanged:Connect(follow))
		frame.Position = UDim2.fromOffset(x, y + 7)
		Animation:Play(frame, { GroupTransparency = 0, Position = UDim2.fromOffset(x, y) }, {
			Duration = 0.2,
			Ease = "Smooth",
		})
		Animation:Play(scale, { Scale = base }, { Duration = 0.28, Ease = "Snap" })
		function popup.Close()
			if isClosed then
				return
			end
			isClosed = true
			if self._popup == popup then
				self._popup = nil
			end
			closed:Fire()
			catcher:Destroy()
			Animation:Play(scale, { Scale = base * 0.97 }, { Duration = 0.12, Ease = "Soft" })
			Animation:Play(frame, { GroupTransparency = 1 }, {
				Duration = 0.13,
				Ease = "Soft",
				OnComplete = function()
					cleanup:Clean()
				end,
			})
			task.delay(0.3, function()
				cleanup:Clean()
			end)
		end
		function popup.Resize(newHeight)
			popup.Height = newHeight
			frame.Size = UDim2.fromOffset(popup.Width, newHeight)
			place()
		end

		popup.Place = place
		cleanup:Add(catcher.Activated:Connect(popup.Close))
		self._popup = popup
		return popup
	end

	function Window:ClosePopup()
		if self._popup then
			self._popup.Close()
		end
		return self
	end

	function Window:Save(name)
		return Config:Save(name or self.Config.SaveFile or Utility.Slug(self.Config.Title or "window"))
	end

	function Window:Load(name)
		return Config:Load(name or self.Config.SaveFile or Utility.Slug(self.Config.Title or "window"))
	end

	function Window:SetAutoSave(enabled, name)
		return Config:SetAutoSave(enabled, name or self.Config.SaveFile or Utility.Slug(self.Config.Title or "window"))
	end

	function Window:Destroy()
		if self._destroyed then
			return
		end
		self._destroyed = true
		if self._popup then
			self._popup.Close()
		end
		self.OnDestroy:Fire()
		Acrylic.Disable()
		Animation:CancelTree(self.Gui)
		self.Cleanup:Clean()
		table.clear(self.Options)
		table.clear(self.Tabs)
	end

	return Window
end
end)()

__modules["Themes/Default"] = (function()
return {
	Background = Color3.fromRGB(13, 13, 15),
	SecondaryBackground = Color3.fromRGB(26, 26, 30),
	TertiaryBackground = Color3.fromRGB(38, 38, 44),
	Text = Color3.fromRGB(236, 236, 240),
	MutedText = Color3.fromRGB(136, 136, 148),
	Accent = Color3.fromRGB(255, 45, 64),
	AccentText = Color3.fromRGB(12, 12, 14),
	Border = Color3.fromRGB(42, 42, 48),
	Hover = Color3.fromRGB(44, 44, 51),
	Pressed = Color3.fromRGB(24, 24, 28),
	Success = Color3.fromRGB(74, 222, 128),
	Warning = Color3.fromRGB(250, 204, 21),
	Error = Color3.fromRGB(248, 113, 113),
	Info = Color3.fromRGB(125, 168, 255),
	Overlay = Color3.fromRGB(0, 0, 0),
	AcrylicTint = Color3.fromRGB(40, 40, 46),
	AcrylicGradient = ColorSequence.new(Color3.fromRGB(26, 26, 30), Color3.fromRGB(16, 16, 19)),
	AcrylicNoise = 0.92,
	AcrylicTransparency = 0.1,
	ElementTransparency = 0.4,
	ComponentTransparency = 0.76,
	ComponentStrokeTransparency = 0.8,
}
end)()

__modules["Themes/DeaDx"] = (function()
return {
	Background = Color3.fromRGB(10, 10, 12),
	SecondaryBackground = Color3.fromRGB(23, 23, 27),
	TertiaryBackground = Color3.fromRGB(35, 35, 41),
	Text = Color3.fromRGB(242, 242, 245),
	MutedText = Color3.fromRGB(130, 130, 142),
	Accent = Color3.fromRGB(255, 45, 64),
	AccentText = Color3.fromRGB(255, 255, 255),
	Border = Color3.fromRGB(40, 40, 47),
	Hover = Color3.fromRGB(43, 43, 50),
	Pressed = Color3.fromRGB(20, 20, 24),
	AcrylicTint = Color3.fromRGB(38, 30, 32),
	AcrylicGradient = ColorSequence.new(Color3.fromRGB(28, 20, 22), Color3.fromRGB(12, 11, 13)),
	AcrylicNoise = 0.9,
	AcrylicTransparency = 0.16,
}
end)()

__modules["Themes/Dark"] = (function()
return {
	Background = Color3.fromRGB(18, 18, 20),
	SecondaryBackground = Color3.fromRGB(31, 31, 35),
	TertiaryBackground = Color3.fromRGB(44, 44, 50),
	Accent = Color3.fromRGB(96, 165, 250),
	AccentText = Color3.fromRGB(10, 14, 22),
	Border = Color3.fromRGB(48, 48, 55),
	Hover = Color3.fromRGB(50, 50, 58),
	Pressed = Color3.fromRGB(28, 28, 33),
	AcrylicTint = Color3.fromRGB(52, 52, 58),
	AcrylicGradient = ColorSequence.new(Color3.fromRGB(36, 36, 41), Color3.fromRGB(22, 22, 26)),
	AcrylicNoise = 0.9,
	AcrylicTransparency = 0.14,
}
end)()

__modules["Themes/Darker"] = (function()
return {
	Background = Color3.fromRGB(11, 11, 13),
	SecondaryBackground = Color3.fromRGB(21, 21, 24),
	TertiaryBackground = Color3.fromRGB(31, 31, 36),
	Accent = Color3.fromRGB(99, 102, 241),
	AccentText = Color3.fromRGB(245, 245, 255),
	Border = Color3.fromRGB(34, 34, 39),
	Hover = Color3.fromRGB(37, 37, 43),
	Pressed = Color3.fromRGB(18, 18, 21),
	AcrylicTint = Color3.fromRGB(30, 30, 36),
	AcrylicGradient = ColorSequence.new(Color3.fromRGB(20, 20, 24), Color3.fromRGB(10, 10, 12)),
	AcrylicNoise = 0.94,
	AcrylicTransparency = 0.12,
}
end)()

__modules["Themes/Amoled"] = (function()
return {
	Background = Color3.fromRGB(0, 0, 0),
	SecondaryBackground = Color3.fromRGB(12, 12, 12),
	TertiaryBackground = Color3.fromRGB(22, 22, 22),
	Text = Color3.fromRGB(250, 250, 250),
	MutedText = Color3.fromRGB(120, 120, 120),
	Accent = Color3.fromRGB(255, 255, 255),
	AccentText = Color3.fromRGB(0, 0, 0),
	Border = Color3.fromRGB(26, 26, 26),
	Hover = Color3.fromRGB(26, 26, 26),
	Pressed = Color3.fromRGB(8, 8, 8),
	AcrylicTint = Color3.fromRGB(0, 0, 0),
	AcrylicGradient = ColorSequence.new(Color3.fromRGB(0, 0, 0), Color3.fromRGB(0, 0, 0)),
	AcrylicNoise = 1,
	AcrylicTransparency = 0.05,
}
end)()

__modules["Themes/Light"] = (function()
return {
	Background = Color3.fromRGB(246, 246, 248),
	SecondaryBackground = Color3.fromRGB(255, 255, 255),
	TertiaryBackground = Color3.fromRGB(237, 237, 242),
	Text = Color3.fromRGB(24, 24, 27),
	MutedText = Color3.fromRGB(113, 113, 122),
	Accent = Color3.fromRGB(220, 38, 56),
	AccentText = Color3.fromRGB(255, 255, 255),
	Border = Color3.fromRGB(220, 220, 226),
	Hover = Color3.fromRGB(240, 240, 244),
	Pressed = Color3.fromRGB(228, 228, 234),
	Success = Color3.fromRGB(22, 163, 74),
	Warning = Color3.fromRGB(202, 138, 4),
	Error = Color3.fromRGB(220, 38, 38),
	Info = Color3.fromRGB(37, 99, 235),
	AcrylicTint = Color3.fromRGB(226, 226, 232),
	AcrylicGradient = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(240, 240, 246)),
	AcrylicNoise = 0.96,
	AcrylicTransparency = 0.22,
	ComponentTransparency = 0.35,
	ComponentStrokeTransparency = 0.55,
	ElementTransparency = 0.2,
}
end)()

__modules["Themes/Midnight"] = (function()
return {
	Background = Color3.fromRGB(12, 15, 25),
	SecondaryBackground = Color3.fromRGB(21, 26, 42),
	TertiaryBackground = Color3.fromRGB(31, 38, 59),
	Text = Color3.fromRGB(232, 237, 250),
	MutedText = Color3.fromRGB(128, 142, 176),
	Accent = Color3.fromRGB(129, 140, 248),
	AccentText = Color3.fromRGB(12, 15, 25),
	Border = Color3.fromRGB(36, 44, 68),
	Hover = Color3.fromRGB(38, 47, 73),
	Pressed = Color3.fromRGB(18, 22, 36),
	AcrylicTint = Color3.fromRGB(34, 42, 68),
	AcrylicGradient = ColorSequence.new(Color3.fromRGB(23, 29, 48), Color3.fromRGB(11, 14, 24)),
	AcrylicNoise = 0.93,
	AcrylicTransparency = 0.15,
}
end)()

__modules["Themes/Crimson"] = (function()
return {
	Background = Color3.fromRGB(18, 10, 12),
	SecondaryBackground = Color3.fromRGB(32, 18, 21),
	TertiaryBackground = Color3.fromRGB(46, 25, 29),
	Text = Color3.fromRGB(248, 236, 238),
	MutedText = Color3.fromRGB(166, 132, 138),
	Accent = Color3.fromRGB(239, 68, 68),
	AccentText = Color3.fromRGB(255, 244, 244),
	Border = Color3.fromRGB(56, 30, 35),
	Hover = Color3.fromRGB(58, 32, 37),
	Pressed = Color3.fromRGB(26, 14, 17),
	AcrylicTint = Color3.fromRGB(54, 26, 30),
	AcrylicGradient = ColorSequence.new(Color3.fromRGB(38, 18, 22), Color3.fromRGB(16, 9, 11)),
	AcrylicNoise = 0.92,
	AcrylicTransparency = 0.16,
}
end)()

__modules["Themes/Ocean"] = (function()
return {
	Background = Color3.fromRGB(9, 18, 26),
	SecondaryBackground = Color3.fromRGB(17, 31, 44),
	TertiaryBackground = Color3.fromRGB(25, 44, 62),
	Text = Color3.fromRGB(228, 242, 250),
	MutedText = Color3.fromRGB(124, 155, 176),
	Accent = Color3.fromRGB(56, 189, 248),
	AccentText = Color3.fromRGB(8, 20, 30),
	Border = Color3.fromRGB(31, 52, 72),
	Hover = Color3.fromRGB(33, 56, 78),
	Pressed = Color3.fromRGB(14, 26, 37),
	AcrylicTint = Color3.fromRGB(28, 52, 72),
	AcrylicGradient = ColorSequence.new(Color3.fromRGB(18, 35, 50), Color3.fromRGB(8, 16, 24)),
	AcrylicNoise = 0.93,
	AcrylicTransparency = 0.15,
}
end)()

__modules["Themes/Forest"] = (function()
return {
	Background = Color3.fromRGB(11, 19, 15),
	SecondaryBackground = Color3.fromRGB(20, 33, 26),
	TertiaryBackground = Color3.fromRGB(29, 47, 37),
	Text = Color3.fromRGB(231, 245, 236),
	MutedText = Color3.fromRGB(129, 162, 142),
	Accent = Color3.fromRGB(52, 211, 153),
	AccentText = Color3.fromRGB(9, 22, 16),
	Border = Color3.fromRGB(34, 55, 43),
	Hover = Color3.fromRGB(36, 59, 46),
	Pressed = Color3.fromRGB(16, 27, 21),
	AcrylicTint = Color3.fromRGB(32, 55, 43),
	AcrylicGradient = ColorSequence.new(Color3.fromRGB(21, 37, 29), Color3.fromRGB(10, 18, 14)),
	AcrylicNoise = 0.93,
	AcrylicTransparency = 0.15,
}
end)()

__modules["Themes/Amethyst"] = (function()
return {
	Background = Color3.fromRGB(17, 12, 24),
	SecondaryBackground = Color3.fromRGB(29, 21, 41),
	TertiaryBackground = Color3.fromRGB(42, 30, 58),
	Text = Color3.fromRGB(240, 234, 250),
	MutedText = Color3.fromRGB(154, 137, 177),
	Accent = Color3.fromRGB(168, 85, 247),
	AccentText = Color3.fromRGB(250, 245, 255),
	Border = Color3.fromRGB(50, 36, 69),
	Hover = Color3.fromRGB(53, 39, 73),
	Pressed = Color3.fromRGB(24, 17, 34),
	AcrylicTint = Color3.fromRGB(50, 34, 70),
	AcrylicGradient = ColorSequence.new(Color3.fromRGB(33, 23, 47), Color3.fromRGB(15, 11, 22)),
	AcrylicNoise = 0.92,
	AcrylicTransparency = 0.16,
}
end)()

__modules["Themes/Sunset"] = (function()
return {
	Background = Color3.fromRGB(22, 14, 12),
	SecondaryBackground = Color3.fromRGB(37, 24, 20),
	TertiaryBackground = Color3.fromRGB(53, 34, 28),
	Text = Color3.fromRGB(250, 238, 232),
	MutedText = Color3.fromRGB(172, 139, 124),
	Accent = Color3.fromRGB(251, 146, 60),
	AccentText = Color3.fromRGB(28, 15, 8),
	Border = Color3.fromRGB(63, 41, 33),
	Hover = Color3.fromRGB(66, 43, 35),
	Pressed = Color3.fromRGB(30, 19, 15),
	AcrylicTint = Color3.fromRGB(62, 38, 30),
	AcrylicGradient = ColorSequence.new(Color3.fromRGB(43, 26, 21), Color3.fromRGB(19, 12, 10)),
	AcrylicNoise = 0.92,
	AcrylicTransparency = 0.16,
}
end)()

__modules["Services/Cleanup"] = (function()
return function(import)
	local Cleanup = {}
	Cleanup.__index = Cleanup

	local function dispose(item)
		local kind = typeof(item)
		if kind == "function" then
			item()
		elseif kind == "RBXScriptConnection" then
			item:Disconnect()
		elseif kind == "Instance" then
			if item:IsA("TweenBase") then
				item:Cancel()
			end
			item:Destroy()
		elseif kind == "thread" then
			pcall(task.cancel, item)
		elseif kind == "table" then
			if type(item.Destroy) == "function" then
				item:Destroy()
			elseif type(item.Disconnect) == "function" then
				item:Disconnect()
			elseif type(item.Clean) == "function" then
				item:Clean()
			end
		end
	end

	function Cleanup.new(parent)
		return setmetatable({ _items = {}, _cleaned = false, _parent = parent }, Cleanup)
	end

	function Cleanup:Add(item)
		if self._cleaned then
			pcall(dispose, item)
			return item
		end
		table.insert(self._items, item)
		return item
	end

	function Cleanup:Extend()
		local child = Cleanup.new(self)
		if self._cleaned then
			child._cleaned = true
		else
			table.insert(self._items, child)
		end
		return child
	end

	function Cleanup:IsCleaned()
		return self._cleaned
	end

	function Cleanup:Clean()
		if self._cleaned then
			return
		end
		self._cleaned = true
		local items = self._items
		self._items = {}
		for index = #items, 1, -1 do
			local ok, err = pcall(dispose, items[index])
			if not ok then
				warn("[DEADX][WARN] Cleanup error: " .. tostring(err))
			end
		end
		local parent = self._parent
		if parent and not parent._cleaned then
			local position = table.find(parent._items, self)
			if position then
				table.remove(parent._items, position)
			end
		end
	end
	Cleanup.Destroy = Cleanup.Clean

	return Cleanup
end
end)()

__modules["Services/Animation"] = (function()
return function(import)
	local TweenService = game:GetService("TweenService")

	local Animation = {
		Enabled = true,
		Duration = { Instant = 0.07, Fast = 0.14, Normal = 0.24, Slow = 0.38 },
		Stagger = 0.022,
	}

	Animation.Ease = {
		Smooth = { Style = Enum.EasingStyle.Quint, Direction = Enum.EasingDirection.Out },
		Soft = { Style = Enum.EasingStyle.Sine, Direction = Enum.EasingDirection.Out },
		Snap = { Style = Enum.EasingStyle.Back, Direction = Enum.EasingDirection.Out },
		Glide = { Style = Enum.EasingStyle.Cubic, Direction = Enum.EasingDirection.InOut },
		Linear = { Style = Enum.EasingStyle.Linear, Direction = Enum.EasingDirection.Out },
	}

	local active = setmetatable({}, { __mode = "k" })

	local function resolve(opts)
		local ease = opts.Ease and Animation.Ease[opts.Ease] or Animation.Ease.Smooth
		return opts.Style or ease.Style, opts.Direction or ease.Direction
	end

	function Animation:Play(object, props, opts)
		opts = opts or {}
		if not Animation.Enabled or opts.Duration == 0 then
			for property, value in props do
				object[property] = value
			end
			if opts.OnComplete then
				task.defer(opts.OnComplete)
			end
			return nil
		end

		local list = active[object]
		if not list then
			list = {}
			active[object] = list
		end
		for index = #list, 1, -1 do
			local entry = list[index]
			for property in props do
				if entry.props[property] then
					entry.tween:Cancel()
					table.remove(list, index)
					break
				end
			end
		end

		local style, direction = resolve(opts)
		local info = TweenInfo.new(
			opts.Duration or Animation.Duration.Normal,
			style,
			direction,
			0,
			false,
			opts.Delay or 0
		)
		local tween = TweenService:Create(object, info, props)
		local entry = { tween = tween, props = props }
		table.insert(list, entry)
		tween.Completed:Once(function(state)
			local position = table.find(list, entry)
			if position then
				table.remove(list, position)
			end
			if opts.OnComplete and state == Enum.PlaybackState.Completed then
				opts.OnComplete()
			end
		end)
		tween:Play()
		return tween
	end

	function Animation:Snap(object, props, opts)
		opts = opts or {}
		opts.Ease = "Snap"
		opts.Duration = opts.Duration or Animation.Duration.Normal
		return Animation:Play(object, props, opts)
	end

	function Animation:Soft(object, props, duration)
		return Animation:Play(object, props, { Ease = "Soft", Duration = duration or Animation.Duration.Fast })
	end

	function Animation:Tween(object, props, duration, style, direction)
		return Animation:Play(object, props, { Duration = duration, Style = style, Direction = direction })
	end

	function Animation:Sequence(items, build, opts)
		opts = opts or {}
		local gap = opts.Stagger or Animation.Stagger
		local limit = opts.Limit or 16
		for index, item in items do
			if index > limit then
				build(item, index, 0)
			else
				build(item, index, (index - 1) * gap)
			end
		end
	end

	function Animation:Cancel(object)
		local list = active[object]
		if list then
			for _, entry in list do
				entry.tween:Cancel()
			end
			table.clear(list)
		end
	end

	function Animation:CancelTree(root)
		if not root then
			return
		end
		Animation:Cancel(root)
		for _, descendant in root:GetDescendants() do
			Animation:Cancel(descendant)
		end
	end

	return Animation
end
end)()

__modules["Services/Input"] = (function()
return function(import)
	local UserInputService = game:GetService("UserInputService")
	local GuiService = game:GetService("GuiService")
	local Signal = import("Core/Signal")
	local Utility = import("Core/Utility")

	local Input = {
		Began = Signal.new(),
		Changed = Signal.new(),
		Ended = Signal.new(),
		Capturing = false,
	}

	local binds = {}
	local connections = {}
	local pointer

	local function matches(key, input)
		if typeof(key) ~= "EnumItem" then
			return false
		end
		if key.EnumType == Enum.KeyCode then
			return key ~= Enum.KeyCode.Unknown and input.KeyCode == key
		end
		return input.UserInputType == key
	end

	function Input.Init()
		if #connections > 0 then
			return
		end
		table.insert(
			connections,
			UserInputService.InputBegan:Connect(function(input, processed)
				Input.Began:Fire(input, processed)
				if processed or Input.Capturing then
					return
				end
				for _, bind in table.clone(binds) do
					if bind.Enabled and matches(bind.Key, input) then
						task.spawn(Utility.SafeCall, "Keybind " .. bind.Label, bind.Callback, bind.Key)
					end
				end
			end)
		)
		table.insert(
			connections,
			UserInputService.InputChanged:Connect(function(input, processed)
				local kind = input.UserInputType
				if kind == Enum.UserInputType.MouseMovement or kind == Enum.UserInputType.Touch then
					pointer = Vector2.new(input.Position.X, input.Position.Y)
				end
				Input.Changed:Fire(input, processed)
			end)
		)
		table.insert(
			connections,
			UserInputService.InputEnded:Connect(function(input, processed)
				Input.Ended:Fire(input, processed)
			end)
		)
	end

	function Input.GetPointer()
		if pointer then
			return pointer
		end
		return UserInputService:GetMouseLocation() - GuiService:GetGuiInset()
	end

	function Input.AddBind(key, callback, label)
		Input.Init()
		local bind = { Key = key, Callback = callback, Label = label or "Keybind", Enabled = true }
		function bind:SetKey(newKey)
			self.Key = newKey
		end
		function bind:SetEnabled(value)
			self.Enabled = value == true
		end
		function bind:Destroy()
			local index = table.find(binds, self)
			if index then
				table.remove(binds, index)
			end
		end
		table.insert(binds, bind)
		return bind
	end

	function Input.FindConflict(key, ignore)
		if typeof(key) ~= "EnumItem" or key == Enum.KeyCode.Unknown then
			return nil
		end
		for _, bind in binds do
			if bind ~= ignore and bind.Key == key then
				return bind
			end
		end
		return nil
	end

	function Input.BindCount()
		return #binds
	end

	function Input.Capture(callback)
		Input.Init()
		Input.Capturing = true
		local finished = false
		local connection

		local function finish(key, cancelled)
			if finished then
				return
			end
			finished = true
			if connection then
				connection:Disconnect()
			end
			task.defer(function()
				Input.Capturing = false
			end)
			callback(key, cancelled)
		end

		task.defer(function()
			if finished then
				return
			end
			connection = UserInputService.InputBegan:Connect(function(input)
				local kind = input.UserInputType
				if kind == Enum.UserInputType.Keyboard then
					if input.KeyCode == Enum.KeyCode.Escape then
						finish(nil, true)
					elseif input.KeyCode == Enum.KeyCode.Backspace then
						finish(Enum.KeyCode.Unknown, false)
					else
						finish(input.KeyCode, false)
					end
				elseif kind == Enum.UserInputType.MouseButton2 or kind == Enum.UserInputType.MouseButton3 then
					finish(kind, false)
				elseif kind == Enum.UserInputType.MouseButton1 or kind == Enum.UserInputType.Touch then
					finish(nil, true)
				end
			end)
		end)

		return function()
			finish(nil, true)
		end
	end

	function Input.Reset()
		for _, connection in connections do
			connection:Disconnect()
		end
		table.clear(connections)
		table.clear(binds)
		Input.Capturing = false
		pointer = nil
	end

	return Input
end
end)()

__modules["Services/Drag"] = (function()
return function(import)
	local Input = import("Services/Input")

	local Drag = {}

	local function isPointer(input)
		return input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch
	end

	local function isMove(input, origin)
		return input.UserInputType == Enum.UserInputType.MouseMovement or input == origin
	end

	function Drag.Track(handle, cleanup, onMove, onEnd, onBegin)
		local stopCurrent
		cleanup:Add(function()
			if stopCurrent then
				stopCurrent()
			end
		end)
		cleanup:Add(handle.InputBegan:Connect(function(input)
			if not isPointer(input) then
				return
			end
			if onBegin and onBegin(input) == false then
				return
			end
			if stopCurrent then
				stopCurrent()
			end
			local running = true
			local moveConnection, endConnection
			local function stop()
				if not running then
					return
				end
				running = false
				stopCurrent = nil
				moveConnection:Disconnect()
				endConnection:Disconnect()
				if onEnd then
					onEnd()
				end
			end
			stopCurrent = stop
			onMove(Vector2.new(input.Position.X, input.Position.Y))
			moveConnection = Input.Changed:Connect(function(changed)
				if running and isMove(changed, input) then
					onMove(Vector2.new(changed.Position.X, changed.Position.Y))
				end
			end)
			endConnection = input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					stop()
				end
			end)
		end))
	end

	local function inside(frame, point)
		if not frame or not frame.Visible then
			return false
		end
		local origin, size = frame.AbsolutePosition, frame.AbsoluteSize
		return point.X >= origin.X
			and point.X <= origin.X + size.X
			and point.Y >= origin.Y
			and point.Y <= origin.Y + size.Y
	end
	Drag.Inside = inside

	function Drag.Attach(handle, target, cleanup, opts)
		opts = opts or {}
		local margin = opts.Margin or 24
		local startPosition, startPointer

		local function begin(input)
			if opts.Blocked and opts.Blocked() then
				return false
			end
			local point = Vector2.new(input.Position.X, input.Position.Y)
			for _, ignored in opts.Ignore or {} do
				if inside(ignored, point) then
					return false
				end
			end
			startPosition = target.Position
			startPointer = point
			return true
		end

		Drag.Track(handle, cleanup, function(position)
			if not startPosition or not startPointer then
				return
			end
			local delta = position - startPointer
			local x = startPosition.X.Offset + delta.X
			local y = startPosition.Y.Offset + delta.Y
			local parent = target.Parent
			if parent and parent:IsA("GuiBase2d") then
				local size = parent.AbsoluteSize
				local px = math.clamp(startPosition.X.Scale * size.X + x, margin, size.X - margin)
				local py = math.clamp(startPosition.Y.Scale * size.Y + y, margin, size.Y - margin)
				x = px - startPosition.X.Scale * size.X
				y = py - startPosition.Y.Scale * size.Y
			end
			target.Position = UDim2.new(startPosition.X.Scale, x, startPosition.Y.Scale, y)
			if opts.OnMove then
				opts.OnMove()
			end
		end, opts.OnEnd, begin)
	end

	function Drag.Resize(handle, target, cleanup, opts)
		opts = opts or {}
		local minSize = opts.Min or Vector2.new(300, 200)
		local maxSize = opts.Max or Vector2.new(2000, 2000)
		local startSize, startPosition, startPointer

		local function begin(input)
			startSize = target.Size
			startPosition = target.Position
			startPointer = Vector2.new(input.Position.X, input.Position.Y)
			return true
		end

		Drag.Track(handle, cleanup, function(position)
			if not startSize or not startPointer then
				return
			end
			local scale = opts.GetScale and opts.GetScale() or 1
			local delta = position - startPointer
			local width = math.clamp(startSize.X.Offset + delta.X / scale, minSize.X, maxSize.X)
			local height = math.clamp(startSize.Y.Offset + delta.Y / scale, minSize.Y, maxSize.Y)
			local appliedX = (width - startSize.X.Offset) * scale
			local appliedY = (height - startSize.Y.Offset) * scale
			target.Size = UDim2.fromOffset(width, height)
			target.Position = UDim2.new(
				startPosition.X.Scale,
				startPosition.X.Offset + appliedX * target.AnchorPoint.X,
				startPosition.Y.Scale,
				startPosition.Y.Offset + appliedY * target.AnchorPoint.Y
			)
			if opts.OnResize then
				opts.OnResize()
			end
		end, opts.OnEnd, begin)
	end

	return Drag
end
end)()

__modules["Services/Acrylic"] = (function()
return function(import)
	local Lighting = game:GetService("Lighting")
	local Workspace = game:GetService("Workspace")
	local Utility = import("Core/Utility")
	local Theme = import("Core/Theme")
	local Animation = import("Services/Animation")

	local Acrylic = {
		ShadowAsset = "",
		NoiseAsset = "",
		Radius = 16,
	}

	local folder
	local effect
	local defaults = {}
	local enabled = false

	local function ensureFolder()
		if folder and folder.Parent then
			return folder
		end
		folder = Instance.new("Folder")
		folder.Name = "DeaDxGlass"
		local camera = Workspace.CurrentCamera
		if camera then
			folder.Parent = camera
		end
		Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
			local current = Workspace.CurrentCamera
			if folder and current and folder.Parent ~= current then
				folder.Parent = current
			end
		end)
		return folder
	end

	function Acrylic.Supported()
		local ok = pcall(function()
			local probe = Instance.new("DepthOfFieldEffect")
			probe.Parent = Lighting
			probe:Destroy()
		end)
		return ok and Workspace.CurrentCamera ~= nil
	end

	function Acrylic.Enable()
		if enabled then
			return
		end
		enabled = true
		if not effect then
			effect = Instance.new("DepthOfFieldEffect")
			effect.Name = "DeaDxDepth"
			effect.FarIntensity = 0
			effect.InFocusRadius = 0.1
			effect.NearIntensity = 1
		end
		table.clear(defaults)
		for _, child in Lighting:GetChildren() do
			if child:IsA("DepthOfFieldEffect") and child ~= effect then
				defaults[child] = child.Enabled
				child.Enabled = false
			end
		end
		effect.Parent = Lighting
	end

	function Acrylic.Disable()
		if not enabled then
			return
		end
		enabled = false
		for child, value in defaults do
			if child.Parent then
				child.Enabled = value
			end
		end
		table.clear(defaults)
		if effect then
			effect.Parent = nil
		end
	end

	function Acrylic.IsEnabled()
		return enabled
	end

	local function viewportToWorld(point, distance)
		local camera = Workspace.CurrentCamera
		if not camera then
			return Vector3.zero
		end
		local ray = camera:ScreenPointToRay(point.X, point.Y)
		return ray.Origin + ray.Direction * distance
	end

	local function inset()
		local camera = Workspace.CurrentCamera
		local height = camera and camera.ViewportSize.Y or 1080
		return Utility.Map(height, 0, 2560, 8, 56)
	end

	function Acrylic.Glass(cleanup, distance)
		distance = distance or 0.001
		local self = {}
		local part = Utility.Create("Part", {
			Name = "Glass",
			Color = Color3.new(0, 0, 0),
			Material = Enum.Material.Glass,
			Size = Vector3.new(1, 1, 0),
			Anchored = true,
			CanCollide = false,
			CanQuery = false,
			CanTouch = false,
			Locked = true,
			CastShadow = false,
			Transparency = 0.98,
			Parent = ensureFolder(),
		}, {
			Utility.Create("SpecialMesh", {
				Name = "Mesh",
				MeshType = Enum.MeshType.Brick,
				Offset = Vector3.new(0, 0, -0.000001),
			}),
		})
		cleanup:Add(part)

		local corners = { Vector2.zero, Vector2.zero, Vector2.zero }
		local visible = true

		local function render()
			local camera = Workspace.CurrentCamera
			if not camera or not part.Parent then
				return
			end
			local frame = camera.CFrame
			local topLeft = viewportToWorld(corners[1], distance)
			local topRight = viewportToWorld(corners[2], distance)
			local bottomRight = viewportToWorld(corners[3], distance)
			local width = (topRight - topLeft).Magnitude
			local height = (topRight - bottomRight).Magnitude
			part.CFrame = CFrame.fromMatrix((topLeft + bottomRight) / 2, frame.XVector, frame.YVector, frame.ZVector)
			part.Mesh.Scale = Vector3.new(width, height, 0)
		end

		local tracker = Utility.Create("Frame", {
			Name = "GlassTracker",
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
		})
		cleanup:Add(tracker)

		local function sync()
			local offset = inset()
			local size = tracker.AbsoluteSize - Vector2.new(offset, offset)
			local position = tracker.AbsolutePosition + Vector2.new(offset / 2, offset / 2)
			corners[1] = position
			corners[2] = position + Vector2.new(size.X, 0)
			corners[3] = position + size
			task.spawn(render)
		end

		cleanup:Add(tracker:GetPropertyChangedSignal("AbsolutePosition"):Connect(sync))
		cleanup:Add(tracker:GetPropertyChangedSignal("AbsoluteSize"):Connect(sync))

		local hooks = {}
		local function hookCamera()
			for _, connection in hooks do
				connection:Disconnect()
			end
			table.clear(hooks)
			local camera = Workspace.CurrentCamera
			if not camera then
				return
			end
			table.insert(hooks, camera:GetPropertyChangedSignal("CFrame"):Connect(render))
			table.insert(hooks, camera:GetPropertyChangedSignal("ViewportSize"):Connect(sync))
			table.insert(hooks, camera:GetPropertyChangedSignal("FieldOfView"):Connect(render))
			task.spawn(render)
		end
		hookCamera()
		cleanup:Add(Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
			ensureFolder()
			part.Parent = folder
			hookCamera()
		end))
		cleanup:Add(function()
			for _, connection in hooks do
				connection:Disconnect()
			end
			table.clear(hooks)
		end)

		self.Frame = tracker
		self.Part = part

		function self.SetVisible(value)
			visible = value == true
			part.Transparency = visible and 0.98 or 1
		end

		function self.Destroy()
			part:Destroy()
			tracker:Destroy()
		end

		return self
	end

	function Acrylic.Paint(cleanup, opts)
		opts = opts or {}
		local radius = opts.Radius or Acrylic.Radius
		local self = {}

		local root = Utility.Create("Frame", {
			Name = "Acrylic",
			BackgroundColor3 = Color3.new(1, 1, 1),
			BackgroundTransparency = 0.9,
			Size = UDim2.fromScale(1, 1),
			Parent = opts.Parent,
		})
		cleanup:Add(root)
		Utility.Create("UICorner", { CornerRadius = UDim.new(0, radius), Parent = root })

		if Acrylic.ShadowAsset ~= "" then
			Utility.Create("ImageLabel", {
				Name = "Shadow",
				Image = Acrylic.ShadowAsset,
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = Rect.new(Vector2.new(99, 99), Vector2.new(99, 99)),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.new(1, 120, 1, 116),
				BackgroundTransparency = 1,
				ImageColor3 = Color3.new(0, 0, 0),
				ImageTransparency = 0.7,
				Parent = root,
			})
		end

		local tint = Utility.Create("Frame", {
			Name = "Tint",
			BackgroundTransparency = 0.45,
			Size = UDim2.fromScale(1, 1),
			Parent = root,
		})
		Utility.Create("UICorner", { CornerRadius = UDim.new(0, radius), Parent = tint })

		local sheen = Utility.Create("Frame", {
			Name = "Sheen",
			BackgroundColor3 = Color3.new(1, 1, 1),
			BackgroundTransparency = 0.42,
			Size = UDim2.fromScale(1, 1),
			Parent = root,
		})
		Utility.Create("UICorner", { CornerRadius = UDim.new(0, radius), Parent = sheen })
		local gradient = Utility.Create("UIGradient", { Rotation = 90, Parent = sheen })

		local noise
		if Acrylic.NoiseAsset ~= "" then
			noise = Utility.Create("ImageLabel", {
				Name = "Noise",
				Image = Acrylic.NoiseAsset,
				ImageTransparency = 0.92,
				ScaleType = Enum.ScaleType.Tile,
				TileSize = UDim2.fromOffset(128, 128),
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = 1,
				Parent = root,
			})
			Utility.Create("UICorner", { CornerRadius = UDim.new(0, radius), Parent = noise })
		end

		local outline = Utility.Create("Frame", {
			Name = "Outline",
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			ZIndex = 2,
			Parent = root,
		})
		Utility.Create("UICorner", { CornerRadius = UDim.new(0, radius), Parent = outline })
		local stroke = Utility.Create("UIStroke", {
			Thickness = 1,
			Transparency = 0.5,
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Parent = outline,
		})

		Theme.BindFn(function()
			tint.BackgroundColor3 = Theme.Get("AcrylicTint")
			gradient.Color = Theme.Get("AcrylicGradient")
			stroke.Color = Theme.Get("Border")
			if noise then
				noise.ImageTransparency = Theme.Get("AcrylicNoise")
			end
		end, cleanup)

		local glass
		if opts.Glass and Acrylic.Supported() then
			glass = Acrylic.Glass(cleanup, opts.Distance)
			glass.Frame.Parent = root
			self.Part = glass.Part
			Acrylic.Enable()
		end

		self.Frame = root
		self.Tint = tint

		function self.SetVisible(value)
			root.Visible = value == true
			if glass then
				glass.SetVisible(value)
			end
		end

		function self.SetTransparency(value)
			Animation:Play(root, { BackgroundTransparency = math.clamp(0.9 + value * 0.1, 0, 1) }, { Duration = 0.2 })
			Animation:Play(tint, { BackgroundTransparency = math.clamp(0.45 + value * 0.55, 0, 1) }, { Duration = 0.2 })
			Animation:Play(sheen, { BackgroundTransparency = math.clamp(0.42 + value * 0.58, 0, 1) }, { Duration = 0.2 })
		end

		return self
	end

	function Acrylic.Reset()
		Acrylic.Disable()
		if folder then
			folder:Destroy()
			folder = nil
		end
		if effect then
			effect:Destroy()
			effect = nil
		end
	end

	return Acrylic
end
end)()

__modules["Services/Tooltip"] = (function()
return function(import)
	local Utility = import("Core/Utility")
	local Widgets = import("Core/Widgets")
	local Theme = import("Core/Theme")
	local Animation = import("Services/Animation")
	local Input = import("Services/Input")
	local Cleanup = import("Services/Cleanup")

	local Tooltip = { Delay = 0.4 }

	local root, gui, frame, text

	local function ensure()
		if gui and gui.Parent then
			return
		end
		root = Cleanup.new()
		gui = root:Add(Utility.NewScreenGui("DeaDx_Tooltip", 2000))
		frame = Widgets.Surface(root, {
			Class = "CanvasGroup",
			Name = "Tooltip",
			Parent = gui,
			Fill = "SecondaryBackground",
			Stroke = "Border",
			Radius = 8,
			AutomaticSize = Enum.AutomaticSize.XY,
			Size = UDim2.new(),
			GroupTransparency = 1,
			Visible = false,
		})
		pcall(function()
			frame.Interactable = false
		end)
		Widgets.Padding(frame, 9, 6)
		local _, handle = Widgets.Text(root, {
			Parent = frame,
			TextSize = 12,
			AutomaticSize = Enum.AutomaticSize.XY,
			Size = UDim2.new(),
			TextWrapped = false,
		})
		text = handle
		local scale = Instance.new("UIScale")
		scale.Parent = frame
		Theme.BindScale(scale, root)
	end

	local function place(override)
		if not frame then
			return
		end
		local point = override or Input.GetPointer()
		local viewport = gui.AbsoluteSize
		local size = frame.AbsoluteSize
		local x = math.clamp(point.X + 14, 4, math.max(4, viewport.X - size.X - 4))
		local y = math.clamp(point.Y + 18, 4, math.max(4, viewport.Y - size.Y - 4))
		frame.Position = UDim2.fromOffset(x, y)
	end

	function Tooltip.Attach(target, content, cleanup)
		Input.Init()
		local handle = { Text = content }
		local hovering = false
		local ticket = 0
		local shown = false
		local connections = {}

		local function hide()
			if shown and frame then
				shown = false
				Animation:Play(frame, { GroupTransparency = 1 }, { Duration = 0.08 })
				task.delay(0.12, function()
					if not shown and frame then
						frame.Visible = false
					end
				end)
			end
		end

		local function show(point)
			if type(handle.Text) ~= "string" or handle.Text == "" then
				return
			end
			ensure()
			text.SetText(handle.Text)
			frame.Visible = true
			shown = true
			place(point)
			Animation:Play(frame, { GroupTransparency = 0 }, { Duration = 0.1 })
		end

		table.insert(connections, target.MouseEnter:Connect(function()
			hovering = true
			ticket += 1
			local mine = ticket
			task.delay(Tooltip.Delay, function()
				if hovering and mine == ticket then
					show()
				end
			end)
		end))
		table.insert(connections, target.MouseLeave:Connect(function()
			hovering = false
			ticket += 1
			hide()
		end))
		table.insert(connections, target.MouseMoved:Connect(function()
			if shown then
				place()
			end
		end))
		table.insert(connections, target.InputBegan:Connect(function(input)
			if input.UserInputType ~= Enum.UserInputType.Touch then
				return
			end
			ticket += 1
			local mine = ticket
			task.delay(Tooltip.Delay, function()
				if mine == ticket then
					show(input.Position)
				end
			end)
		end))
		table.insert(connections, target.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.Touch then
				ticket += 1
				hide()
			end
		end))

		function handle:Destroy()
			hovering = false
			ticket += 1
			hide()
			for _, connection in connections do
				connection:Disconnect()
			end
			table.clear(connections)
		end

		if cleanup then
			cleanup:Add(handle)
		end
		return handle
	end

	function Tooltip.Reset()
		if root then
			root:Clean()
		end
		root, gui, frame, text = nil, nil, nil, nil
	end

	return Tooltip
end
end)()

__modules["Services/Notification"] = (function()
return function(import)
	local Utility = import("Core/Utility")
	local Widgets = import("Core/Widgets")
	local Theme = import("Core/Theme")
	local Cleanup = import("Services/Cleanup")
	local Toast = import("Components/Notification")

	local Notification = { Max = 6, Side = "BottomRight", Width = 282 }

	local root, gui, holder
	local active = {}
	local counter = 0

	local SIDES = {
		bottomright = { Vector2.new(1, 1), UDim2.new(1, -8, 1, -8), Enum.VerticalAlignment.Bottom, Enum.HorizontalAlignment.Right },
		bottomleft = { Vector2.new(0, 1), UDim2.new(0, 8, 1, -8), Enum.VerticalAlignment.Bottom, Enum.HorizontalAlignment.Left },
		topright = { Vector2.new(1, 0), UDim2.new(1, -8, 0, 8), Enum.VerticalAlignment.Top, Enum.HorizontalAlignment.Right },
		topleft = { Vector2.new(0, 0), UDim2.new(0, 8, 0, 8), Enum.VerticalAlignment.Top, Enum.HorizontalAlignment.Left },
		topcenter = { Vector2.new(0.5, 0), UDim2.new(0.5, 0, 0, 8), Enum.VerticalAlignment.Top, Enum.HorizontalAlignment.Center },
		bottomcenter = { Vector2.new(0.5, 1), UDim2.new(0.5, 0, 1, -8), Enum.VerticalAlignment.Bottom, Enum.HorizontalAlignment.Center },
	}

	local function ensure()
		if gui and gui.Parent then
			return
		end
		root = Cleanup.new()
		gui = root:Add(Utility.NewScreenGui("DeaDx_Notifications", 1500))
		holder = Utility.Create("Frame", {
			Name = "Holder",
			BackgroundTransparency = 1,
			Size = UDim2.fromOffset(Notification.Width, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			Parent = gui,
		})
		Widgets.List(holder, 7)
		local scale = Instance.new("UIScale")
		scale.Parent = holder
		Theme.BindScale(scale, root)
		Notification.SetSide(Notification.Side)
	end

	function Notification.SetSide(side)
		Notification.Side = side
		if not holder then
			return
		end
		local preset = SIDES[string.lower(string.gsub(tostring(side), "[%s%-]", ""))] or SIDES.bottomright
		holder.AnchorPoint = preset[1]
		holder.Position = preset[2]
		local layout = holder:FindFirstChildOfClass("UIListLayout")
		if layout then
			layout.VerticalAlignment = preset[3]
			layout.HorizontalAlignment = preset[4]
		end
	end

	function Notification.Notify(config)
		Utility.Check(type(config) == "table", "Notification", "?", "Config must be a table.")
		ensure()
		counter += 1
		local toast = Toast.new(holder, config, counter, function(closed)
			local index = table.find(active, closed)
			if index then
				table.remove(active, index)
			end
		end)
		table.insert(active, toast)
		while #active > Notification.Max do
			active[1]:Close()
		end
		return toast
	end

	function Notification.Ask(config)
		Utility.Check(type(config) == "table", "Notification", "?", "Config must be a table.")
		local copy = table.clone(config)
		copy.Options = config.Options or { config.Confirm or "Yes", config.Cancel or "No" }
		copy.Type = config.Type or "Warning"
		copy.Duration = config.Duration or 0
		copy.Closable = config.Closable ~= false
		return Notification.Notify(copy)
	end

	function Notification.Prompt(config)
		Utility.Check(type(config) == "table", "Notification", "?", "Config must be a table.")
		local copy = table.clone(config)
		copy.Input = config.Input or config.Placeholder or true
		copy.Type = config.Type or "Info"
		copy.Duration = config.Duration or 0
		copy.Closable = config.Closable ~= false
		return Notification.Notify(copy)
	end

	function Notification.Count()
		return #active
	end

	function Notification.SetMax(value)
		Notification.Max = math.max(tonumber(value) or 6, 1)
		while #active > Notification.Max do
			active[1]:Close()
		end
		return Notification.Max
	end

	function Notification.SetWidth(value)
		Notification.Width = math.clamp(tonumber(value) or 282, 180, 520)
		if holder then
			holder.Size = UDim2.fromOffset(Notification.Width, 0)
		end
		return Notification.Width
	end

	function Notification.List()
		return table.clone(active)
	end

	function Notification.CloseAll()
		for _, toast in table.clone(active) do
			toast:Close()
		end
	end

	function Notification.Reset()
		for _, toast in table.clone(active) do
			toast:Destroy()
		end
		table.clear(active)
		if root then
			root:Clean()
		end
		root, gui, holder = nil, nil, nil
	end

	return Notification
end
end)()

__modules["Services/StatusBar"] = (function()
return function(import)
	local RunService = game:GetService("RunService")
	local Players = game:GetService("Players")
	local Stats = game:GetService("Stats")
	local MarketplaceService = game:GetService("MarketplaceService")
	local Utility = import("Core/Utility")
	local Theme = import("Core/Theme")
	local Widgets = import("Core/Widgets")
	local Markup = import("Core/Markup")
	local Signal = import("Core/Signal")
	local Icons = import("Icons/Icon")
	local Cleanup = import("Services/Cleanup")
	local Animation = import("Services/Animation")
	local Drag = import("Services/Drag")

	local StatusBar = {}
	StatusBar.__index = StatusBar

	local ANCHORS = {
		topleft = { Vector2.new(0, 0), UDim2.fromScale(0, 0), Vector2.new(12, 12) },
		topcenter = { Vector2.new(0.5, 0), UDim2.fromScale(0.5, 0), Vector2.new(0, 12) },
		topright = { Vector2.new(1, 0), UDim2.fromScale(1, 0), Vector2.new(-12, 12) },
		middleleft = { Vector2.new(0, 0.5), UDim2.fromScale(0, 0.5), Vector2.new(12, 0) },
		middleright = { Vector2.new(1, 0.5), UDim2.fromScale(1, 0.5), Vector2.new(-12, 0) },
		bottomleft = { Vector2.new(0, 1), UDim2.fromScale(0, 1), Vector2.new(12, -12) },
		bottomcenter = { Vector2.new(0.5, 1), UDim2.fromScale(0.5, 1), Vector2.new(0, -12) },
		bottomright = { Vector2.new(1, 1), UDim2.fromScale(1, 1), Vector2.new(-12, -12) },
		abovehotbar = { Vector2.new(0.5, 1), UDim2.fromScale(0.5, 1), Vector2.new(0, -86) },
		undertopbar = { Vector2.new(0.5, 0), UDim2.fromScale(0.5, 0), Vector2.new(0, 42) },
		center = { Vector2.new(0.5, 0.5), UDim2.fromScale(0.5, 0.5), Vector2.new(0, 0) },
	}

	local ALIASES = {
		top = "topcenter",
		bottom = "bottomcenter",
		left = "middleleft",
		right = "middleright",
		["top-left"] = "topleft",
		["top-center"] = "topcenter",
		["top-right"] = "topright",
		["bottom-left"] = "bottomleft",
		["bottom-center"] = "bottomcenter",
		["bottom-right"] = "bottomright",
		["middle-left"] = "middleleft",
		["middle-right"] = "middleright",
		inventory = "abovehotbar",
		hotbar = "abovehotbar",
		topbar = "undertopbar",
	}

	local placeName

	local function resolveAnchor(value)
		if typeof(value) == "UDim2" then
			return nil, value, nil
		end
		local name = string.lower(tostring(value or "topcenter"))
		name = string.gsub(name, "%s+", "")
		name = ALIASES[name] or name
		local preset = ANCHORS[name] or ANCHORS.topcenter
		return preset[1], preset[2], preset[3]
	end

	function StatusBar.Anchors()
		local out = {}
		for name in ANCHORS do
			table.insert(out, name)
		end
		table.sort(out)
		return out
	end

	local BUILTIN = {
		{ key = "Fps", icon = "activity", label = "FPS" },
		{ key = "Ping", icon = "wifi", label = "Ping" },
		{ key = "Players", icon = "users", label = "Players" },
		{ key = "Memory", icon = "cpu", label = "Mem" },
		{ key = "Clock", icon = "clock", label = "Clock" },
		{ key = "Session", icon = "timer", label = "Session" },
		{ key = "Place", icon = "gamepad-2", label = "Place" },
	}

	function StatusBar.new(config)
		config = config or {}
		Utility.Check(type(config) == "table", "StatusBar", "?", "Config must be a table.")
		local self = setmetatable({}, StatusBar)
		self.Cleanup = Cleanup.new()
		self.Changed = Signal.new()
		self.Config = config
		self._fields = {}
		self._order = 0
		self._frames = 0
		self._elapsed = 0
		self._started = os.clock()
		self._destroyed = false
		self._interval = math.max(config.Interval or 0.5, 0.1)
		self._separator = config.Separator or "|"
		self._compact = config.Compact == true
		local cleanup = self.Cleanup
		cleanup:Add(self.Changed)

		local gui = cleanup:Add(Utility.NewScreenGui("DeaDx_StatusBar", config.DisplayOrder or 900))
		gui.IgnoreGuiInset = config.IgnoreInset == true
		self.Gui = gui

		local frame = Widgets.Surface(cleanup, {
			Class = "CanvasGroup",
			Name = "StatusBar",
			Parent = gui,
			Fill = config.Background or "Background",
			Transparency = config.Transparency or 0.18,
			Stroke = config.Border or "Border",
			StrokeTransparency = 0.4,
			Radius = config.Radius or "Full",
			Size = UDim2.fromOffset(0, config.Height or 30),
			AutomaticSize = Enum.AutomaticSize.X,
			GroupTransparency = 1,
		})
		self.Frame = frame
		Widgets.Padding(frame, config.PaddingX or 12, 0)
		Widgets.List(frame, self._compact and 8 or 10, {
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
		})

		local scale = Instance.new("UIScale")
		scale.Parent = frame
		Theme.BindScale(scale, cleanup)
		self._scale = scale

		local bounds = Instance.new("UISizeConstraint")
		bounds.MinSize = Vector2.new(config.MinWidth or 0, 0)
		bounds.MaxSize = Vector2.new(config.MaxWidth or 760, math.huge)
		bounds.Parent = frame

		if config.Icon then
			local holder = Utility.Create("Frame", {
				Name = "Brand",
				BackgroundTransparency = 1,
				Size = UDim2.fromOffset(16, 16),
				LayoutOrder = 0,
				Parent = frame,
			})
			self._icon = Icons.Create(holder, config.Icon, Icons.Options(config, {
				Size = config.IconSize or 16,
				Color = config.IconColor or config.TitleColor or "Accent",
				Cleanup = cleanup,
			}))
		end

		local title = config.Title or config.Name or config.Text
		if title and title ~= "" then
			self._order += 1
			local _, handle = Widgets.Text(cleanup, {
				Name = "Title",
				Parent = frame,
				Text = title,
				Color = config.TitleColor or "Text",
				Bold = true,
				TextSize = config.TextSize or 13,
				AutomaticSize = Enum.AutomaticSize.X,
				Size = UDim2.new(0, 0, 1, 0),
				LayoutOrder = self._order,
			})
			self._title = handle
		end

		self._body = frame
		self:_Build()
		self:SetPosition(config.Position or "TopCenter", config.Offset)

		if config.Draggable ~= false then
			frame.Active = true
			Drag.Attach(frame, frame, cleanup, { Margin = 8 })
		end

		cleanup:Add(RunService.RenderStepped:Connect(function(delta)
			self._frames += 1
			self._elapsed += delta
			if self._elapsed >= self._interval then
				self._fps = self._frames / self._elapsed
				self._frames, self._elapsed = 0, 0
				self:Refresh()
			end
		end))

		Animation:Play(frame, { GroupTransparency = 0 }, { Duration = 0.25 })
		self:Refresh()
		return self
	end

	function StatusBar:_Separator()
		self._order += 1
		local label = Widgets.Text(self.Cleanup, {
			Name = "Separator",
			Parent = self._body,
			Text = self._separator,
			Color = "Border",
			TextSize = 12,
			AutomaticSize = Enum.AutomaticSize.X,
			Size = UDim2.new(0, 0, 1, 0),
			LayoutOrder = self._order,
		})
		return label
	end

	function StatusBar:_Field(key, iconName, label, getter, options)
		local config = self.Config
		if self._fields[key] then
			return self._fields[key]
		end
		if #self._fields > 0 or self._title or self._icon then
			self:_Separator()
		end
		self._order += 1
		local holder = Utility.Create(options and options.Callback and "TextButton" or "Frame", {
			Name = "Field_" .. key,
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.X,
			Size = UDim2.new(0, 0, 1, 0),
			LayoutOrder = self._order,
			Parent = self._body,
		})
		if options and options.Callback then
			self.Cleanup:Add(holder.Activated:Connect(function()
				Utility.SafeCall("StatusBar field " .. key, options.Callback, self)
				Widgets.Pulse(holder, 0.84, 0.28)
				self:Refresh()
			end))
			self.Cleanup:Add(holder.MouseEnter:Connect(function()
				Widgets.Pulse(holder, 1.06, 0.24)
			end))
		end
		Widgets.List(holder, 5, {
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
		})
		local icon
		if config.Icons ~= false and iconName then
			local slot = Utility.Create("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.fromOffset(13, 13),
				LayoutOrder = 1,
				Parent = holder,
			})
			icon = Icons.Create(slot, iconName, { Size = 13, Color = "MutedText", Cleanup = self.Cleanup })
		end
		local _, text = Widgets.Text(self.Cleanup, {
			Parent = holder,
			Text = "",
			Color = config.ValueColor or "MutedText",
			TextSize = config.TextSize and config.TextSize - 1 or 12,
			AutomaticSize = Enum.AutomaticSize.X,
			Size = UDim2.new(0, 0, 1, 0),
			LayoutOrder = 2,
		})
		local field = { Key = key, Label = label, Holder = holder, Icon = icon, Text = text, Getter = getter }
		self._fields[key] = field
		table.insert(self._fields, field)
		return field
	end

	function StatusBar:_Build()
		local config = self.Config
		for _, entry in BUILTIN do
			if config[entry.key] then
				self:_Field(entry.key, entry.icon, entry.label)
			end
		end
		for _, custom in config.Fields or {} do
			if type(custom) == "table" and custom.Key then
				self:_Field(custom.Key, custom.Icon, custom.Label, custom.Value, custom)
			end
		end
	end

	local function ping()
		local ok, value = pcall(function()
			return Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
		end)
		if ok and type(value) == "number" then
			return math.floor(value + 0.5)
		end
		return nil
	end

	local function memory()
		local ok, value = pcall(function()
			return Stats:GetTotalMemoryUsageMb()
		end)
		if ok and type(value) == "number" then
			return math.floor(value + 0.5)
		end
		return nil
	end

	local function place()
		if placeName then
			return placeName
		end
		local ok, info = pcall(function()
			return MarketplaceService:GetProductInfo(game.PlaceId)
		end)
		placeName = ok and type(info) == "table" and info.Name or "Unknown"
		return placeName
	end

	local function clock(format)
		return os.date(format or "%H:%M:%S")
	end

	local function duration(seconds)
		local total = math.floor(seconds)
		local hours = math.floor(total / 3600)
		local minutes = math.floor(total % 3600 / 60)
		local rest = total % 60
		if hours > 0 then
			return string.format("%d:%02d:%02d", hours, minutes, rest)
		end
		return string.format("%d:%02d", minutes, rest)
	end

	function StatusBar:_Value(field)
		local config = self.Config
		local key = field.Key
		if field.Getter then
			local ok, value = pcall(field.Getter, self)
			return ok and value ~= nil and tostring(value) or "-"
		end
		if key == "Fps" then
			return tostring(math.floor((self._fps or 0) + 0.5))
		elseif key == "Ping" then
			local value = ping()
			return value and (value .. "ms") or "-"
		elseif key == "Players" then
			return tostring(#Players:GetPlayers()) .. (config.MaxPlayers ~= false and ("/" .. tostring(Players.MaxPlayers)) or "")
		elseif key == "Memory" then
			local value = memory()
			return value and (value .. "mb") or "-"
		elseif key == "Clock" then
			return clock(config.ClockFormat)
		elseif key == "Session" then
			return duration(os.clock() - self._started)
		elseif key == "Place" then
			return place()
		end
		return field.Value or "-"
	end

	function StatusBar:Refresh()
		if self._destroyed then
			return
		end
		local compact = self._compact
		for _, field in self._fields do
			if type(field) == "table" and field.Text then
				local value = self:_Value(field)
				local prefix = (not compact and self.Config.Labels ~= false and field.Label) and (field.Label .. " ") or ""
				field.Text.SetText(prefix .. value)
			end
		end
	end

	function StatusBar:AddField(key, options)
		Utility.Check(type(key) == "string", "StatusBar field", key, "Key must be a string.")
		options = options or {}
		local field = self:_Field(key, options.Icon, options.Label, options.Value, options)
		if options.Text then
			field.Value = options.Text
		end
		self:Refresh()
		return self
	end

	function StatusBar:SetField(key, value)
		local field = self._fields[key]
		if not field then
			self:AddField(key, { Text = value })
			return self
		end
		field.Value = value
		field.Getter = nil
		self:Refresh()
		return self
	end

	function StatusBar:RemoveField(key)
		local field = self._fields[key]
		if not field then
			return self
		end
		field.Holder:Destroy()
		local index = table.find(self._fields, field)
		if index then
			table.remove(self._fields, index)
		end
		self._fields[key] = nil
		return self
	end

	function StatusBar:SetTitle(text)
		if self._title then
			self._title.SetText(text)
		end
		return self
	end

	function StatusBar:SetTitleColor(color)
		if self._title then
			self._title.SetColor(color)
		end
		return self
	end

	function StatusBar:SetIcon(spec)
		if self._icon then
			self._icon:Set(spec)
		end
		return self
	end

	function StatusBar:SetPosition(value, offset)
		local anchor, position, preset = resolveAnchor(value)
		offset = offset or preset or Vector2.zero
		if anchor then
			self.Frame.AnchorPoint = anchor
		end
		self.Frame.Position = UDim2.new(
			position.X.Scale,
			position.X.Offset + offset.X,
			position.Y.Scale,
			position.Y.Offset + offset.Y
		)
		self.Anchor = typeof(value) == "UDim2" and "custom" or string.lower(tostring(value))
		return self
	end

	function StatusBar:SetInterval(seconds)
		self._interval = math.max(tonumber(seconds) or 0.5, 0.1)
		return self
	end

	function StatusBar:SetCompact(value)
		self._compact = value == true
		self:Refresh()
		return self
	end

	function StatusBar:SetSeparator(text)
		self._separator = tostring(text)
		for _, child in self._body:GetChildren() do
			if child.Name == "Separator" then
				child.Text = Markup.Parse(self._separator)
			end
		end
		return self
	end

	function StatusBar:SetVisible(value)
		self.Frame.Visible = value == true
		return self
	end

	function StatusBar:Show()
		return self:SetVisible(true)
	end

	function StatusBar:Hide()
		return self:SetVisible(false)
	end

	function StatusBar:Toggle()
		return self:SetVisible(not self.Frame.Visible)
	end

	function StatusBar:IsVisible()
		return self.Frame.Visible
	end

	function StatusBar:GetFps()
		return self._fps or 0
	end

	function StatusBar:GetPing()
		return ping()
	end

	function StatusBar:Destroy()
		if self._destroyed then
			return
		end
		self._destroyed = true
		Animation:CancelTree(self.Gui)
		self.Cleanup:Clean()
		table.clear(self._fields)
	end

	return StatusBar
end
end)()

__modules["Services/Loading"] = (function()
return function(import)
	local Lighting = game:GetService("Lighting")
	local RunService = game:GetService("RunService")
	local Workspace = game:GetService("Workspace")
	local Utility = import("Core/Utility")
	local Signal = import("Core/Signal")
	local Theme = import("Core/Theme")
	local Widgets = import("Core/Widgets")
	local Icons = import("Icons/Icon")
	local Cleanup = import("Services/Cleanup")
	local Animation = import("Services/Animation")

	local Loading = {}
	Loading.__index = Loading

	local function viewportScale()
		local camera = Workspace.CurrentCamera
		if not camera then
			return 1
		end
		local height = camera.ViewportSize.Y
		if height <= 0 then
			return 1
		end
		return math.clamp(height / 900, 0.78, 1.35)
	end

	function Loading.new(config)
		config = config or {}
		Utility.Check(type(config) == "table", "LoadingScreen", "?", "Config must be a table.")
		local self = setmetatable({}, Loading)
		self.Cleanup = Cleanup.new()
		self.Finished = Signal.new()
		self.Config = config
		self.Steps = config.Steps or {}
		self._index = 0
		self._done = false
		self._progress = 0
		self._opened = os.clock()
		local cleanup = self.Cleanup
		cleanup:Add(self.Finished)

		local gui = cleanup:Add(Utility.NewScreenGui("DeaDx_Loading", config.DisplayOrder or 2500))
		gui.IgnoreGuiInset = true
		self.Gui = gui

		local root = Utility.Create("CanvasGroup", {
			Name = "Loading",
			BackgroundColor3 = config.Backdrop or Color3.fromRGB(6, 6, 8),
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			GroupTransparency = 1,
			Parent = gui,
		})
		self.Root = root

		local vignette = Utility.Create("Frame", {
			Name = "Vignette",
			BackgroundColor3 = Color3.new(0, 0, 0),
			BackgroundTransparency = 0.35,
			Size = UDim2.fromScale(1, 1),
			Parent = root,
		})
		Utility.Create("UIGradient", {
			Rotation = 90,
			Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 0.1),
				NumberSequenceKeypoint.new(0.5, 0.85),
				NumberSequenceKeypoint.new(1, 0.1),
			}),
			Parent = vignette,
		})

		if config.Blur ~= false then
			local blur = Instance.new("BlurEffect")
			blur.Name = "DeaDxLoadingBlur"
			blur.Size = 0
			blur.Parent = Lighting
			cleanup:Add(blur)
			Animation:Play(blur, { Size = config.BlurSize or 22 }, { Duration = 0.25 })
			self._blur = blur
		end

		local stage = Utility.Create("Frame", {
			Name = "Stage",
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromOffset(config.Width or 420, 260),
			Parent = root,
		})
		local scale = Instance.new("UIScale")
		scale.Scale = viewportScale() * 0.96
		scale.Parent = stage
		self._scale = scale
		cleanup:Add(Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
			scale.Scale = viewportScale()
		end))

		local glow = Utility.Create("Frame", {
			Name = "Glow",
			BackgroundColor3 = Theme.Resolve(config.Color, "Accent"),
			BackgroundTransparency = 0.88,
			AnchorPoint = Vector2.new(0.5, 1),
			Position = UDim2.new(0.5, 0, 0.5, 40),
			Size = UDim2.fromOffset(160, 160),
			Parent = stage,
		})
		Utility.Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = glow })
		Utility.Create("UIGradient", {
			Rotation = 90,
			Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 0.45),
				NumberSequenceKeypoint.new(1, 1),
			}),
			Parent = glow,
		})
		self._glow = glow

		local card = Widgets.Surface(cleanup, {
			Name = "Card",
			Parent = stage,
			Fill = "Background",
			Transparency = 0.05,
			Stroke = "Border",
			StrokeTransparency = 0.35,
			Radius = 24,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
		})
		self.Card = card
		Widgets.Padding(card, 26, 26)
		Widgets.List(card, 14, { HorizontalAlignment = Enum.HorizontalAlignment.Center })

		local ring = Utility.Create("Frame", {
			Name = "Ring",
			BackgroundTransparency = 1,
			Size = UDim2.fromOffset(62, 62),
			LayoutOrder = 1,
			Parent = card,
		})
		local track = Widgets.Surface(cleanup, {
			Name = "RingTrack",
			Parent = ring,
			Radius = "Full",
			Stroke = "Border",
			StrokeTransparency = 0.6,
			Size = UDim2.fromScale(1, 1),
		})
		track:FindFirstChildOfClass("UIStroke").Thickness = 2
		local orbit = Widgets.Surface(cleanup, {
			Name = "Orbit",
			Parent = ring,
			Radius = "Full",
			Stroke = config.Color or "Accent",
			StrokeTransparency = 0,
			Size = UDim2.fromScale(1, 1),
		})
		orbit:FindFirstChildOfClass("UIStroke").Thickness = 2
		Utility.Create("UIGradient", {
			Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 0),
				NumberSequenceKeypoint.new(0.42, 0.75),
				NumberSequenceKeypoint.new(1, 1),
			}),
			Parent = orbit,
		})
		self._orbit = orbit

		local iconHolder = Utility.Create("Frame", {
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromOffset(26, 26),
			Parent = ring,
		})
		self._icon = Icons.Create(iconHolder, config.Icon or "zap", Icons.Options(config, {
			Size = config.IconSize or 26,
			Color = config.IconColor or config.Color or "Accent",
			Cleanup = cleanup,
		}))

		local _, title = Widgets.Text(cleanup, {
			Name = "Title",
			Parent = card,
			Text = config.Title or "DeaDx",
			Color = config.TitleColor or "Text",
			Gradient = config.TitleGradient,
			Heavy = true,
			TextSize = 26,
			TextXAlignment = Enum.TextXAlignment.Center,
			Size = UDim2.new(1, 0, 0, 28),
			LayoutOrder = 2,
		})
		self._title = title

		local subtitle = config.Subtitle or config.SubTitle or ""
		local subtitleLabel, subtitleHandle = Widgets.Text(cleanup, {
			Name = "Subtitle",
			Parent = card,
			Text = subtitle,
			Color = config.SubtitleColor or "MutedText",
			TextSize = 13,
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Center,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.new(1, 0, 0, 0),
			LayoutOrder = 3,
			Visible = subtitle ~= "",
		})
		self._subtitle, self._subtitleLabel = subtitleHandle, subtitleLabel

		local bar = Widgets.Surface(cleanup, {
			Name = "Bar",
			Parent = card,
			Fill = "SecondaryBackground",
			Transparency = 0.2,
			Radius = "Full",
			ClipsDescendants = true,
			Size = UDim2.new(1, 0, 0, 8),
			LayoutOrder = 4,
		})
		local fill = Widgets.Surface(cleanup, {
			Name = "Fill",
			Parent = bar,
			Fill = config.Color or "Accent",
			Radius = "Full",
			Size = UDim2.fromScale(0, 1),
		})
		local stops = Widgets.Stops(config.Gradient)
		if stops then
			Utility.Create("UIGradient", { Color = stops, Parent = fill })
		end
		local head = Widgets.Surface(cleanup, {
			Name = "Head",
			Parent = fill,
			Fill = "Text",
			BackgroundTransparency = 0.6,
			Radius = "Full",
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.fromScale(1, 0.5),
			Size = UDim2.new(0, 14, 1, 0),
		})
		self._fill, self._head = fill, head

		local statusRow = Utility.Create("Frame", {
			Name = "Status",
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 16),
			LayoutOrder = 5,
			Parent = card,
		})
		local _, status = Widgets.Text(cleanup, {
			Parent = statusRow,
			Text = config.Status or "Loading",
			Color = "MutedText",
			TextSize = 12,
			Size = UDim2.new(1, -48, 1, 0),
			TextTruncate = Enum.TextTruncate.AtEnd,
		})
		self._status = status
		local _, percent = Widgets.Text(cleanup, {
			Parent = statusRow,
			Text = "0%",
			Color = config.Color or "Accent",
			Bold = true,
			TextSize = 12,
			TextXAlignment = Enum.TextXAlignment.Right,
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.fromScale(1, 0),
			Size = UDim2.fromOffset(46, 16),
			Markup = false,
		})
		self._percent = percent

		if #self.Steps > 0 and config.Dots ~= false then
			local dots = Utility.Create("Frame", {
				Name = "Dots",
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 8),
				LayoutOrder = 6,
				Parent = card,
			})
			Widgets.List(dots, 6, {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center,
			})
			self._dots = {}
			for index = 1, #self.Steps do
				local dot = Widgets.Surface(cleanup, {
					Parent = dots,
					Fill = "Border",
					Radius = "Full",
					Size = UDim2.fromOffset(6, 6),
					LayoutOrder = index,
				})
				table.insert(self._dots, dot)
			end
		end

		if config.Tips and #config.Tips > 0 then
			Widgets.Surface(cleanup, {
				Name = "Rule",
				Parent = card,
				Fill = "Border",
				Radius = 0,
				BackgroundTransparency = 0.4,
				Size = UDim2.new(1, 0, 0, 1),
				LayoutOrder = 7,
			})
			local _, tip = Widgets.Text(cleanup, {
				Name = "Tip",
				Parent = card,
				Text = config.Tips[1],
				Color = "MutedText",
				TextSize = 12,
				TextWrapped = true,
				TextXAlignment = Enum.TextXAlignment.Center,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(1, 0, 0, 0),
				LayoutOrder = 8,
			})
			self._tip = tip
			cleanup:Add(task.spawn(function()
				local index = 1
				while not self._done do
					task.wait(config.TipInterval or 4)
					if self._done then
						break
					end
					index = index % #config.Tips + 1
					Animation:Play(tip.Instance, { TextTransparency = 1 }, { Duration = 0.18 })
					task.wait(0.2)
					tip.SetText(config.Tips[index])
					Animation:Play(tip.Instance, { TextTransparency = 0 }, { Duration = 0.22 })
				end
			end))
		end

		if config.Footer then
			Widgets.Text(cleanup, {
				Name = "Footer",
				Parent = card,
				Text = config.Footer,
				Color = "MutedText",
				TextSize = 11,
				TextXAlignment = Enum.TextXAlignment.Center,
				Size = UDim2.new(1, 0, 0, 13),
				LayoutOrder = 9,
			})
		end

		local spin = 0
		cleanup:Add(RunService.RenderStepped:Connect(function(delta)
			if self._done then
				return
			end
			spin = (spin + delta * 220) % 360
			orbit.Rotation = spin
		end))

		Animation:Play(root, { GroupTransparency = 0, BackgroundTransparency = config.Dim or 0.12 }, { Duration = 0.18 })
		Animation:Play(scale, { Scale = viewportScale() }, { Duration = 0.26, Style = Enum.EasingStyle.Back })

		if config.Auto then
			self:Auto(config.Auto)
		end
		return self
	end

	function Loading:SetProgress(alpha, status)
		if self._done and alpha ~= 1 then
			return self
		end
		alpha = math.clamp(tonumber(alpha) or 0, 0, 1)
		self._progress = alpha
		Animation:Play(self._fill, { Size = UDim2.fromScale(alpha, 1) }, {
			Duration = 0.25,
			Style = Enum.EasingStyle.Quint,
		})
		self._head.Visible = alpha > 0.02
		self._percent.SetText(string.format("%d%%", alpha * 100 + 0.5))
		if status then
			self:SetStatus(status)
		end
		return self
	end

	function Loading:GetProgress()
		return self._progress or 0
	end

	function Loading:SetStatus(text)
		self._status.SetText(text)
		return self
	end

	function Loading:SetTitle(text)
		self._title.SetText(text)
		return self
	end

	function Loading:SetSubtitle(text)
		self._subtitle.SetText(text)
		self._subtitleLabel.Visible = text ~= nil and text ~= ""
		return self
	end

	function Loading:Step(status)
		if #self.Steps == 0 then
			return self:SetProgress(math.min(self._progress + 0.25, 1), status)
		end
		self._index = math.min(self._index + 1, #self.Steps)
		for index, dot in self._dots or {} do
			local active = index <= self._index
			Animation:Play(dot, {
				BackgroundColor3 = Theme.Resolve(active and (self.Config.Color or "Accent") or "Border", "Border"),
				Size = UDim2.fromOffset(active and 8 or 6, active and 8 or 6),
			}, { Duration = 0.18 })
		end
		self:SetProgress(self._index / #self.Steps, status or self.Steps[self._index])
		return self
	end

	function Loading:Run(tasks)
		task.spawn(function()
			for index, entry in tasks or {} do
				if self._done then
					return
				end
				local label = type(entry) == "table" and entry.Title or self.Steps[index]
				self:Step(label)
				local work = type(entry) == "table" and entry.Run or entry
				if type(work) == "function" then
					Utility.SafeCall("Loading step", work, self)
				end
			end
			self:Finish()
		end)
		return self
	end

	function Loading:Auto(duration)
		duration = tonumber(duration) or 1.2
		self.Cleanup:Add(task.spawn(function()
			local steps = math.max(#self.Steps, 1)
			for _ = 1, steps do
				if self._done then
					return
				end
				self:Step()
				task.wait(duration / steps)
			end
			self:Finish()
		end))
		return self
	end

	function Loading:IsFinished()
		return self._done
	end

	function Loading:Wait(timeout)
		local deadline = os.clock() + (tonumber(timeout) or 60)
		while not self._done and os.clock() < deadline do
			task.wait(0.03)
		end
		return self._done
	end

	function Loading:Finish(message)
		if self._done then
			return self
		end
		local minimum = tonumber(self.Config.MinDuration) or 0
		local elapsed = os.clock() - self._opened
		if minimum > elapsed then
			task.delay(minimum - elapsed, function()
				self:Finish(message)
			end)
			return self
		end

		self._done = true
		self:SetProgress(1, message)
		self.Finished:Fire()
		if self._blur then
			Animation:Play(self._blur, { Size = 0 }, { Duration = 0.22 })
		end
		Animation:Play(self._scale, { Scale = self._scale.Scale * 1.04 }, { Duration = 0.22 })
		Animation:Play(self.Root, { GroupTransparency = 1 }, {
			Duration = 0.22,
			Delay = 0.06,
			OnComplete = function()
				self.Cleanup:Clean()
			end,
		})
		task.delay(0.6, function()
			self.Cleanup:Clean()
		end)
		return self
	end

	function Loading:Destroy()
		self._done = true
		self.Cleanup:Clean()
	end

	return Loading
end
end)()

__modules["Services/KeySystem"] = (function()
return function(import)
	local HttpService = game:GetService("HttpService")
	local Players = game:GetService("Players")
	local MarketplaceService = game:GetService("MarketplaceService")
	local Workspace = game:GetService("Workspace")
	local Utility = import("Core/Utility")
	local Signal = import("Core/Signal")
	local Theme = import("Core/Theme")
	local Widgets = import("Core/Widgets")
	local Hash = import("Core/Hash")
	local Integrity = import("Core/Integrity")
	local Capabilities = import("Core/Capabilities")
	local Icons = import("Icons/Icon")
	local Cleanup = import("Services/Cleanup")
	local Animation = import("Services/Animation")
	local Drag = import("Services/Drag")

	local KeySystem = {}
	KeySystem.__index = KeySystem

	local vault = setmetatable({}, { __mode = "k" })
	local accept

	local function seal(self)
		local slot = vault[self]
		if not slot then
			return false
		end
		slot.proof = Hash.Hmac(slot.session, "unlocked|" .. tostring(self.Hwid))
		return true
	end

	local function sealed(self)
		local slot = vault[self]
		if not slot or not slot.proof then
			return false
		end
		return Hash.Equal(slot.proof, Hash.Hmac(slot.session, "unlocked|" .. tostring(self.Hwid)))
	end

	local function clock(seconds)
		seconds = math.max(math.ceil(seconds), 0)
		return string.format("%02d:%02d", math.floor(seconds / 60), seconds % 60)
	end

	local function list(value)
		if value == nil then
			return nil
		end
		if type(value) ~= "table" then
			return { value }
		end
		return value
	end

	local function lines(body)
		local out = {}
		for line in string.gmatch(tostring(body), "[^\r\n]+") do
			line = string.gsub(line, "^%s*(.-)%s*$", "%1")
			if line ~= "" and string.sub(line, 1, 1) ~= "#" then
				table.insert(out, line)
			end
		end
		return out
	end

	local function viewportScale()
		local camera = Workspace.CurrentCamera
		if not camera or camera.ViewportSize.Y <= 0 then
			return 1
		end
		return math.clamp(camera.ViewportSize.Y / 900, 0.78, 1.3)
	end

	local function assetId(text)
		return tonumber(string.match(tostring(text), "(%d+)") or "") or 0
	end

	local function wearing(player, id)
		id = tonumber(id) or 0
		if id == 0 then
			return false
		end
		local character = player.Character
		if character then
			for _, item in character:GetDescendants() do
				if item:IsA("Shirt") and assetId(item.ShirtTemplate) == id then
					return true
				elseif item:IsA("Pants") and assetId(item.PantsTemplate) == id then
					return true
				elseif item:IsA("ShirtGraphic") and assetId(item.Graphic) == id then
					return true
				elseif item:IsA("Accessory") then
					if item:GetAttribute("AssetId") == id then
						return true
					end
					local handle = item:FindFirstChild("Handle")
					local mesh = handle and (handle:FindFirstChildWhichIsA("SpecialMesh") or handle)
					if mesh then
						local texture = mesh:IsA("SpecialMesh") and mesh.TextureId or (mesh:IsA("MeshPart") and mesh.TextureID or "")
						local meshId = mesh:IsA("SpecialMesh") and mesh.MeshId or (mesh:IsA("MeshPart") and mesh.MeshId or "")
						if assetId(texture) == id or assetId(meshId) == id then
							return true
						end
					end
				end
			end
		end
		local ok, description = pcall(function()
			return Players:GetHumanoidDescriptionFromUserId(player.UserId)
		end)
		if ok and description then
			for _, field in { "Shirt", "Pants", "GraphicTShirt", "HatAccessory", "FaceAccessory", "BackAccessory", "FrontAccessory", "NeckAccessory", "ShouldersAccessory", "WaistAccessory" } do
				local value = description[field]
				if value ~= nil then
					for part in string.gmatch(tostring(value), "%d+") do
						if tonumber(part) == id then
							return true
						end
					end
				end
			end
		end
		return false
	end

	function KeySystem.new(config)
		config = config or {}
		Utility.Check(type(config) == "table", "KeySystem", "?", "Config must be a table.")
		local self = setmetatable({}, KeySystem)
		self.Cleanup = Cleanup.new()
		self.Validated = Signal.new()
		self.Rejected = Signal.new()
		self.Config = config
		self.Salt = config.Salt or "DeaDx"
		self.File = config.File or "DeaDx/key.dat"
		self.Attempts = config.Attempts or 5
		self.Lockout = config.Lockout or 30
		self.Require = config.Require == "all" and "all" or "any"
		self._left = self.Attempts
		self._done = false
		vault[self] = { session = Hash.Nonce(24) }
		self._rows = {}
		local cleanup = self.Cleanup
		cleanup:Add(self.Validated)
		cleanup:Add(self.Rejected)

		self.Player = Players.LocalPlayer
		self.Hwid = Capabilities.Hwid()
		self.HwidShort = string.sub(Hash.Sha256(self.Hwid), 1, 18)

		self.Plus = config.Plus
		if self.Plus then
			Utility.Check(type(self.Plus) == "table", "KeySystem", "Plus", "Plus must be a table.")
			Utility.Check(
				type(self.Plus.Endpoint) == "string" and self.Plus.Endpoint ~= "",
				"KeySystem",
				"Plus",
				"Plus needs an Endpoint."
			)
		end
		self.Luarmor = config.Luarmor
		if self.Luarmor then
			if type(self.Luarmor) == "string" then
				self.Luarmor = { ScriptId = self.Luarmor }
			end
			Utility.Check(
				type(self.Luarmor) == "table" and type(self.Luarmor.ScriptId) == "string",
				"KeySystem",
				"Luarmor",
				"Luarmor needs a ScriptId."
			)
		end
		self.Checks = self:_BuildChecks()
		self.UsesKey = (
			config.Key
			or config.Keys
			or config.Hashes
			or config.Url
			or config.Endpoint
			or config.Validate
			or config.Plus
			or config.Luarmor
		) ~= nil

		if config.Integrity ~= false then
			local clean, failures = Integrity.Scan()
			self._tampered = not clean
			self._tamperList = failures
		end

		local gui = cleanup:Add(Utility.NewScreenGui("DeaDx_Key", config.DisplayOrder or 2400))
		gui.IgnoreGuiInset = true
		self.Gui = gui

		local backdrop = Utility.Create("Frame", {
			Name = "Backdrop",
			BackgroundColor3 = Color3.fromRGB(6, 6, 8),
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			Active = true,
			Parent = gui,
		})
		Animation:Play(backdrop, { BackgroundTransparency = config.Dim or 0.2 }, { Duration = 0.2 })
		self._backdrop = backdrop

		local stage = Utility.Create("Frame", {
			Name = "Stage",
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromOffset(config.Width or 400, 120),
			Parent = backdrop,
		})
		self.Stage = stage
		local scale = Instance.new("UIScale")
		scale.Scale = viewportScale() * 0.96
		scale.Parent = stage
		self._scale = scale

		local card = Widgets.Surface(cleanup, {
			Class = "CanvasGroup",
			Name = "Key",
			Parent = stage,
			Fill = "Background",
			Transparency = 0.04,
			Stroke = "Border",
			StrokeTransparency = 0.3,
			Radius = 24,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			GroupTransparency = 1,
		})
		self.Card = card
		Widgets.Padding(card, 24, 24)
		Widgets.List(card, 14)

		local head = Utility.Create("Frame", {
			Name = "Head",
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 44),
			LayoutOrder = 1,
			Parent = card,
		})
		local badge = Widgets.Surface(cleanup, {
			Parent = head,
			Fill = config.IconBackground or "SecondaryBackground",
			Stroke = "Border",
			StrokeTransparency = 0.35,
			Radius = 14,
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0, 0, 0.5, 0),
			Size = UDim2.fromOffset(44, 44),
		})
		Icons.Create(badge, config.Icon or "key-round", {
			Size = 22,
			Color = config.IconColor or "Accent",
			Position = UDim2.fromOffset(11, 11),
			Cleanup = cleanup,
		})
		Widgets.Text(cleanup, {
			Parent = head,
			Text = config.Title or "Key system",
			Color = config.TitleColor or "Text",
			Gradient = config.TitleGradient,
			Heavy = true,
			TextSize = 21,
			Position = UDim2.fromOffset(56, 3),
			Size = UDim2.new(1, -56, 0, 22),
			TextTruncate = Enum.TextTruncate.AtEnd,
		})
		Widgets.Text(cleanup, {
			Parent = head,
			Text = config.Subtitle or (self.UsesKey and "Enter your key to continue" or "Access requirements"),
			Color = "MutedText",
			TextSize = 12,
			Position = UDim2.fromOffset(56, 25),
			Size = UDim2.new(1, -56, 0, 16),
			TextTruncate = Enum.TextTruncate.AtEnd,
		})

		if config.Note then
			local note = Widgets.Surface(cleanup, {
				Parent = card,
				Fill = "SecondaryBackground",
				Transparency = 0.3,
				Stroke = "Border",
				StrokeTransparency = 0.55,
				Radius = 13,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(1, 0, 0, 0),
				LayoutOrder = 2,
			})
			Widgets.Padding(note, 13, 11)
			Widgets.Text(cleanup, {
				Parent = note,
				Text = config.Note,
				Color = config.NoteColor or "MutedText",
				TextSize = 12,
				TextWrapped = true,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(1, 0, 0, 0),
			})
		end

		if #self.Checks > 0 then
			local panel = Utility.Create("Frame", {
				Name = "Checks",
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(1, 0, 0, 0),
				LayoutOrder = 3,
				Parent = card,
			})
			Widgets.List(panel, 6)
			for index, check in self.Checks do
				self._rows[index] = self:_Row(panel, check, index)
			end
		end

		if self.UsesKey then
			local holder, box, stroke, field = Widgets.Field(cleanup, {
				Name = "Input",
				Parent = card,
				Radius = 14,
				Placeholder = config.Placeholder or "paste your key here",
				Size = UDim2.new(1, 0, 0, 42),
				TextSize = 14,
				Inset = 14,
				Trail = 14,
				LayoutOrder = 4,
			})
			self._box, self._field, self._stroke = box, field, stroke
			self._holder = holder
			cleanup:Add(box.FocusLost:Connect(function(enter)
				if enter then
					self:Submit(box.Text)
				end
			end))
		end

		local buttons = Utility.Create("Frame", {
			Name = "Buttons",
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 40),
			LayoutOrder = 5,
			Parent = card,
		})
		Widgets.List(buttons, 9, {
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
		})
		self._buttons = buttons

		local links = config.Links or (config.Link and { { Title = "Get key", Url = config.Link } } or nil)
		local count = (links and links[1] and 1 or 0) + 1
		local width = 1 / count

		if links and links[1] then
			self:_Action(links[1].Title or "Get key", links[1].Icon or "link", false, 1, width, function()
				if Capabilities.SetClipboard(links[1].Url or "") then
					self:SetStatus("Link copied.", "Success")
				else
					self:SetStatus(links[1].Url or "", "Info")
				end
			end)
		end

		self._submit = self:_Action(
			config.SubmitText or (self.UsesKey and "Verify" or "Check access"),
			"check",
			true,
			2,
			width,
			function()
				if self.UsesKey and self._box then
					self:Submit(self._box.Text)
				else
					self:Recheck(true)
				end
			end
		)

		local status = Utility.Create("Frame", {
			Name = "Status",
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 16),
			LayoutOrder = 6,
			Parent = card,
		})
		local _, statusText = Widgets.Text(cleanup, {
			Parent = status,
			Text = "",
			Color = "MutedText",
			TextSize = 12,
			Size = UDim2.new(1, -52, 1, 0),
			TextTruncate = Enum.TextTruncate.AtEnd,
		})
		self._status = statusText
		if self.UsesKey then
			local _, attempts = Widgets.Text(cleanup, {
				Parent = status,
				Text = string.format("%d/%d", self._left, self.Attempts),
				Color = "MutedText",
				TextSize = 12,
				TextXAlignment = Enum.TextXAlignment.Right,
				AnchorPoint = Vector2.new(1, 0),
				Position = UDim2.fromScale(1, 0),
				Size = UDim2.fromOffset(50, 16),
				Markup = false,
			})
			self._attempts = attempts
		end

		if config.ShowHwid ~= false then
			local row = Widgets.Surface(cleanup, {
				Class = "TextButton",
				Parent = card,
				Fill = "SecondaryBackground",
				Transparency = 0.4,
				Radius = 11,
				Size = UDim2.new(1, 0, 0, 28),
				LayoutOrder = 7,
			})
			Icons.Create(row, "fingerprint", {
				Size = 13,
				Color = "MutedText",
				AnchorPoint = Vector2.new(0, 0.5),
				Position = UDim2.new(0, 11, 0.5, 0),
				Cleanup = cleanup,
			})
			Widgets.Text(cleanup, {
				Parent = row,
				Text = "HWID " .. self.HwidShort,
				Color = "MutedText",
				TextSize = 11,
				Position = UDim2.fromOffset(30, 0),
				Size = UDim2.new(1, -62, 1, 0),
				TextTruncate = Enum.TextTruncate.AtEnd,
				Markup = false,
			})
			local copyIcon = Icons.Create(row, "copy", {
				Size = 13,
				Color = "MutedText",
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.new(1, -11, 0.5, 0),
				Cleanup = cleanup,
			})
			Widgets.Interactive(cleanup, row, row, { Base = "SecondaryBackground", Alpha = { 0.4, 0.24, 0.14 } })
			cleanup:Add(row.Activated:Connect(function()
				if Capabilities.SetClipboard(self.Hwid) then
					copyIcon:Set("check")
					self:SetStatus("HWID copied.", "Success")
					task.delay(1.2, function()
						if not self._done then
							copyIcon:Set("copy")
						end
					end)
				end
			end))
		end

		if config.Draggable ~= false then
			card.Active = true
			Drag.Attach(card, stage, cleanup, { Margin = 60, Ignore = { self._holder, buttons } })
		end

		Animation:Play(card, { GroupTransparency = 0 }, { Duration = 0.2 })
		Animation:Play(scale, { Scale = viewportScale() }, { Duration = 0.28, Style = Enum.EasingStyle.Back })

		if self._tampered then
			self:SetStatus("Tampered environment: " .. (self._tamperList[1] or "hook"), "Error")
			Utility.SafeCall("KeySystem OnTamper", config.OnTamper, self._tamperList)
			if config.BlockOnTamper then
				self._blocked = true
			end
		end

		if config.Integrity ~= false and config.Guard ~= false then
			local watched = {
				{ Name = "KeySystem.IsValid", Fn = KeySystem.IsValid, Lua = true },
				{ Name = "KeySystem.Submit", Fn = KeySystem.Submit, Lua = true },
				{ Name = "KeySystem.Wait", Fn = KeySystem.Wait, Lua = true },
				{ Name = "KeySystem.accept", Fn = accept, Lua = true },
				{ Name = "Hash.Hmac", Fn = Hash.Hmac, Lua = true },
				{ Name = "Hash.Equal", Fn = Hash.Equal, Lua = true },
			}
			self._guard = Integrity.Guard(config.GuardInterval or 6, function(failures)
				self._tampered = true
				Utility.SafeCall("KeySystem OnTamper", config.OnTamper, failures)
			end, watched)
			cleanup:Add(function()
				self._guard.Stop()
			end)
		end

		task.defer(function()
			if config.Remember ~= false and self:_LoadSaved() then
				accept(self, "Saved key accepted.", true)
				return
			end
			if #self.Checks > 0 then
				self:Recheck(false)
			end
		end)
		return self
	end

	function KeySystem:_Action(text, iconName, primary, order, width, callback)
		local cleanup = self.Cleanup
		local config = self.Config
		local button = Widgets.Surface(cleanup, {
			Class = "TextButton",
			Parent = self._buttons,
			Fill = primary and (config.Accent or "Accent") or "SecondaryBackground",
			Stroke = (not primary) and "Border" or nil,
			StrokeTransparency = 0.35,
			Radius = 13,
			Size = UDim2.new(width or 0.5, -5, 1, 0),
			LayoutOrder = order,
		})
		local icon = Icons.Create(button, iconName, {
			Size = 15,
			Color = primary and "AccentText" or "MutedText",
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0, 16, 0.5, 0),
			Cleanup = cleanup,
		})
		Widgets.Text(cleanup, {
			Parent = button,
			Text = text,
			Color = primary and "AccentText" or "Text",
			Bold = true,
			TextSize = 13,
			Position = UDim2.fromOffset(38, 0),
			Size = UDim2.new(1, -44, 1, 0),
			TextTruncate = Enum.TextTruncate.AtEnd,
		})
		Widgets.Interactive(cleanup, button, button, {
			Base = primary and (config.Accent or "Accent") or "SecondaryBackground",
			Hover = primary and (config.Accent or "Accent") or "Hover",
			Pressed = primary and (config.Accent or "Accent") or "Pressed",
			Alpha = primary and { 0, 0.12, 0.25 } or nil,
		})
		cleanup:Add(button.Activated:Connect(callback))
		return button, icon
	end

	function KeySystem:_BuildChecks()
		local config = self.Config
		local player = Players.LocalPlayer
		local checks = {}

		local function add(kind, label, icon, run)
			table.insert(checks, { Kind = kind, Label = label, Icon = icon, Run = run, State = "pending" })
		end

		if config.Group then
			local groups = list(config.Group)
			for _, id in groups do
				local rank = config.GroupRank or 0
				add("group", config.GroupText or ("Join the group " .. tostring(id)), "users", function()
					local ok, member = pcall(function()
						return player:IsInGroup(id)
					end)
					if not ok or not member then
						return false, "you are not in the group"
					end
					if rank > 0 then
						local okRank, value = pcall(function()
							return player:GetRankInGroup(id)
						end)
						if not okRank or value < rank then
							return false, "rank too low"
						end
					end
					return true
				end)
			end
		end

		for _, id in list(config.Gamepass) or {} do
			add("gamepass", config.GamepassText or ("Buy the gamepass " .. tostring(id)), "shopping-cart", function()
				local ok, owns = pcall(function()
					return MarketplaceService:UserOwnsGamePassAsync(player.UserId, id)
				end)
				if ok and owns then
					return true
				end
				return false, "gamepass not found"
			end)
		end

		for _, id in list(config.Asset) or {} do
			add("asset", config.AssetText or ("Own the item " .. tostring(id)), "shirt", function()
				local ok, owns = pcall(function()
					return MarketplaceService:PlayerOwnsAsset(player, id)
				end)
				if ok and owns then
					return true
				end
				return false, "item not found"
			end)
		end

		for _, id in list(config.Wearing) or {} do
			add("wearing", config.WearingText or ("Wear the item " .. tostring(id)), "shirt", function()
				if wearing(player, id) then
					return true
				end
				return false, "item not equipped"
			end)
		end

		if config.Whitelist then
			add("whitelist", config.WhitelistText or "Be on the whitelist", "user-check", function()
				for _, entry in config.Whitelist do
					if type(entry) == "number" and entry == player.UserId then
						return true
					end
					if type(entry) == "string" then
						local lowered = string.lower(entry)
						if lowered == string.lower(player.Name) or lowered == string.lower(player.DisplayName) then
							return true
						end
					end
				end
				if type(config.WhitelistUrl) == "string" then
					local ok, body = Capabilities.HttpGet(config.WhitelistUrl)
					if ok then
						for _, entry in lines(body) do
							if entry == tostring(player.UserId) or string.lower(entry) == string.lower(player.Name) then
								return true
							end
						end
					end
				end
				return false, "name not listed"
			end)
		end

		if config.Premium then
			add("premium", "Have Roblox Premium", "crown", function()
				if player.MembershipType == Enum.MembershipType.Premium then
					return true
				end
				return false, "no premium"
			end)
		end

		if config.Checks then
			for _, entry in config.Checks do
				if type(entry) == "table" and type(entry.Run) == "function" then
					add(entry.Kind or "custom", entry.Label or "Requirement", entry.Icon or "circle-check", entry.Run)
				end
			end
		end

		return checks
	end

	function KeySystem:_Row(parent, check, index)
		local cleanup = self.Cleanup
		local row = Widgets.Surface(cleanup, {
			Class = "TextButton",
			Parent = parent,
			Fill = "SecondaryBackground",
			Transparency = 0.42,
			Stroke = "Border",
			StrokeTransparency = 0.6,
			Radius = 12,
			Size = UDim2.new(1, 0, 0, 34),
			LayoutOrder = index,
		})
		local icon = Icons.Create(row, check.Icon or "circle-check", {
			Size = 15,
			Color = "MutedText",
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0, 12, 0.5, 0),
			Cleanup = cleanup,
		})
		local _, label = Widgets.Text(cleanup, {
			Parent = row,
			Text = check.Label,
			Color = "Text",
			TextSize = 12,
			Position = UDim2.fromOffset(34, 0),
			Size = UDim2.new(1, -62, 1, 0),
			TextTruncate = Enum.TextTruncate.AtEnd,
		})
		local mark = Icons.Create(row, "loader", {
			Size = 14,
			Color = "MutedText",
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, -12, 0.5, 0),
			Cleanup = cleanup,
		})
		Widgets.Interactive(cleanup, row, row, { Base = "SecondaryBackground", Alpha = { 0.42, 0.26, 0.16 } })
		cleanup:Add(row.Activated:Connect(function()
			self:Recheck(true)
		end))
		return { Frame = row, Icon = icon, Label = label, Mark = mark, Check = check }
	end

	function KeySystem:_Paint(index, state, reason)
		local row = self._rows[index]
		if not row then
			return
		end
		local check = row.Check
		check.State = state
		check.Reason = reason
		if state == "ok" then
			row.Mark:Set("circle-check")
			row.Mark:SetColor("Success")
			row.Icon:SetColor("Success")
			Widgets.Pulse(row.Mark.Instance, 0.6, 0.3)
		elseif state == "fail" then
			row.Mark:Set("circle-x")
			row.Mark:SetColor("Error")
			row.Icon:SetColor("MutedText")
		else
			row.Mark:Set("loader")
			row.Mark:SetColor("MutedText")
		end
		if reason and state == "fail" then
			row.Label.SetText(check.Label .. "  <fade:0.35>(" .. reason .. ")</fade>")
		else
			row.Label.SetText(check.Label)
		end
	end

	function KeySystem:Recheck(manual)
		if self._done or self._checking then
			return self
		end
		self._checking = true
		if manual then
			self:SetStatus("Checking requirements...")
		end
		task.spawn(function()
			local passed, total = 0, #self.Checks
			for index, check in self.Checks do
				self:_Paint(index, "pending")
				local ok, reason = check.Run()
				if ok == true then
					passed += 1
					self:_Paint(index, "ok")
				else
					self:_Paint(index, "fail", reason)
				end
			end
			self._checking = false
			if self._done then
				return
			end
			self._passed = passed
			local granted = total > 0 and (self.Require == "all" and passed == total or (self.Require == "any" and passed > 0))
			if granted and not self.UsesKey then
				accept(self, "Access granted.")
				return
			end
			if granted and self.Require == "any" then
				accept(self, "Access granted by whitelist.")
				return
			end
			if manual then
				if total > 0 and passed == 0 then
					self:SetStatus("No requirement met.", "Error")
					self:_Shake()
				elseif self.UsesKey then
					self:SetStatus("Requirements missing. Use a key.", "Error")
				end
			end
		end)
		return self
	end

	function KeySystem:SetStatus(text, kind)
		if not self._status then
			return self
		end
		self._status.SetText(text or "")
		self._status.SetColor(kind == "Success" and "Success" or (kind == "Error" and "Error" or "MutedText"))
		return self
	end

	function KeySystem:_Shake()
		local stage = self.Stage
		local base = stage.Position
		task.spawn(function()
			for _, offset in { 11, -9, 6, -4, 0 } do
				if not stage.Parent then
					return
				end
				Animation:Play(stage, {
					Position = UDim2.new(base.X.Scale, base.X.Offset + offset, base.Y.Scale, base.Y.Offset),
				}, { Duration = 0.045 })
				task.wait(0.05)
			end
			if stage.Parent then
				stage.Position = base
			end
		end)
		if self._stroke then
			Widgets.Glow(self._stroke, "Error", 0.6)
		end
	end

	function KeySystem:_Token()
		return Hash.Salted(self.Hwid .. "|" .. tostring(self.Config.Product or "DeaDx"), self.Salt)
	end

	function KeySystem:_SaveKey(key)
		if self.Config.Remember == false or not Capabilities.FileSystem then
			return false
		end
		local payload = {
			t = self:_Token(),
			k = Hash.Salted(key, self.Salt),
			e = self.Config.ExpiresIn and (os.time() + self.Config.ExpiresIn) or 0,
		}
		if self.Plus or self.Luarmor then
			payload.p = Hash.Encode(key, self:_Token())
		end
		local ok, body = pcall(HttpService.JSONEncode, HttpService, payload)
		if not ok then
			return false
		end
		Capabilities.EnsureFolder(string.match(self.File, "^(.*)/[^/]+$") or "DeaDx")
		return (pcall(Capabilities.FS.Write, self.File, Hash.Encode(body, self.Hwid)))
	end

	function KeySystem:_LoadSaved()
		if not Capabilities.FileSystem or not Capabilities.FS.IsFile(self.File) then
			return false
		end
		local ok, raw = pcall(Capabilities.FS.Read, self.File)
		if not ok or type(raw) ~= "string" then
			return false
		end
		local decoded = Hash.Decode(raw, self.Hwid)
		if not decoded then
			return false
		end
		local parsed, payload = pcall(HttpService.JSONDecode, HttpService, decoded)
		if not parsed or type(payload) ~= "table" then
			return false
		end
		if not Hash.Equal(tostring(payload.t), self:_Token()) then
			return false
		end
		if type(payload.e) == "number" and payload.e > 0 and os.time() > payload.e then
			pcall(Capabilities.FS.Delete, self.File)
			return false
		end
		if self.Luarmor then
			local stored = type(payload.p) == "string" and Hash.Decode(payload.p, self:_Token()) or nil
			if not stored then
				return false
			end
			local Luarmor = import("Services/Luarmor")
			local status = Luarmor.Check(self.Luarmor, stored)
			if status.code ~= "KEY_VALID" then
				self._savedReason = status.message
				return false
			end
			self.Status = status
			self.Info = Luarmor.Info(status)
			Luarmor.SetKey(stored)
			if self.Luarmor.Load then
				task.defer(function()
					Luarmor.Load(self.Luarmor, stored)
				end)
			end
			return true
		end

		if self.Plus then
			local stored = type(payload.p) == "string" and Hash.Decode(payload.p, self:_Token()) or nil
			if not stored then
				return false
			end
			local body, reason = import("Services/KeyPlus").Request(self.Plus, stored)
			if not body then
				self._plusReason = reason
				return false
			end
			self._payload = body
			return true
		end
		return self:_Match(nil, payload.k)
	end

	function KeySystem:Forget()
		if Capabilities.FileSystem and Capabilities.FS.Delete and Capabilities.FS.IsFile(self.File) then
			pcall(Capabilities.FS.Delete, self.File)
		end
		return self
	end

	function KeySystem:_Remote()
		local config = self.Config
		if self._remote ~= nil then
			return self._remote
		end
		if type(config.Url) ~= "string" then
			self._remote = false
			return false
		end
		local ok, body = Capabilities.HttpGet(config.Url)
		self._remote = ok and lines(body) or false
		return self._remote
	end

	function KeySystem:_Match(key, hashed)
		local config = self.Config
		local digest = hashed or Hash.Salted(key, self.Salt)

		if type(config.Validate) == "function" and key ~= nil then
			local ok, result = pcall(config.Validate, key, self.Hwid)
			if ok and result == true then
				return true
			end
		end

		for _, entry in config.Hashes or {} do
			if Hash.Equal(string.lower(tostring(entry)), digest) then
				return true
			end
		end

		if key ~= nil then
			local plain = config.Keys or (config.Key and { config.Key } or nil)
			for _, entry in plain or {} do
				if Hash.Equal(Hash.Salted(tostring(entry), self.Salt), digest) then
					return true
				end
			end
		end

		local remote = self:_Remote()
		if type(remote) == "table" then
			for _, entry in remote do
				entry = string.lower(entry)
				if Hash.Equal(entry, digest) then
					return true
				end
				if key ~= nil and Hash.Equal(Hash.Salted(entry, self.Salt), digest) then
					return true
				end
			end
		end

		return false
	end

	function KeySystem:_Endpoint(key)
		local config = self.Config
		if type(config.Endpoint) ~= "string" then
			return nil
		end
		local url = config.Endpoint
		local replacements = {
			key = HttpService:UrlEncode(key),
			hwid = HttpService:UrlEncode(self.Hwid),
			user = HttpService:UrlEncode(self.Player and self.Player.Name or ""),
			userid = tostring(self.Player and self.Player.UserId or 0),
			place = tostring(game.PlaceId),
		}
		url = string.gsub(url, "{(%w+)}", function(name)
			return replacements[string.lower(name)] or ""
		end)
		if string.find(url, "%%s") then
			local count = select(2, string.gsub(url, "%%s", ""))
			url = count >= 2 and string.format(url, replacements.key, replacements.hwid)
				or string.format(url, replacements.key)
		end
		local ok, body = Capabilities.HttpGet(url)
		if not ok or type(body) ~= "string" then
			return false, "no response from the server"
		end
		local expect = config.Expect
		if type(expect) == "string" then
			return string.find(body, expect, 1, true) ~= nil
		end
		local parsed, data = pcall(HttpService.JSONDecode, HttpService, body)
		if parsed and type(data) == "table" then
			if data.valid == true or data.success == true or data.status == "ok" then
				return true
			end
			return false, data.message or data.error
		end
		local trimmed = string.lower((string.gsub(body, "%s", "")))
		return trimmed == "true" or trimmed == "1" or trimmed == "ok"
	end

	function KeySystem:IsLocked()
		return self._lockUntil ~= nil and os.clock() < self._lockUntil
	end

	function KeySystem:_Lock()
		self._lockUntil = os.clock() + self.Lockout
		self._left = self.Attempts
		if self._box then
			self._box.TextEditable = false
		end
		task.spawn(function()
			while self:IsLocked() and not self._done do
				self:SetStatus("Locked for " .. clock(self._lockUntil - os.clock()), "Error")
				task.wait(0.2)
			end
			if not self._done then
				self._lockUntil = nil
				if self._box then
					self._box.TextEditable = true
				end
				if self._attempts then
					self._attempts.SetText(string.format("%d/%d", self._left, self.Attempts))
				end
				self:SetStatus("You can try again.")
			end
		end)
	end

	function accept(self, message, silent)
		if self._done then
			return
		end
		if self._blocked then
			self:SetStatus("Blocked: tampered environment.", "Error")
			return
		end
		self._done = true
		seal(self)
		self:SetStatus(message or "Key accepted.", "Success")
		if self._stroke then
			Widgets.Glow(self._stroke, "Success", 0.6)
		end
		self.Validated:Fire(self._payload, self.Info)
		Utility.SafeCall("KeySystem OnSuccess", self.Config.OnSuccess, self._payload, self.Info)
		if self._payload then
			Utility.SafeCall("KeySystem OnUnlock", self.Config.OnUnlock, self._payload)
		end
		task.delay(silent and 0.05 or 0.3, function()
			Animation:Play(self._scale, { Scale = self._scale.Scale * 1.03 }, { Duration = 0.2 })
			Animation:Play(self.Card, { GroupTransparency = 1 }, { Duration = 0.2 })
			Animation:Play(self._backdrop, { BackgroundTransparency = 1 }, {
				Duration = 0.2,
				OnComplete = function()
					self.Cleanup:Clean()
				end,
			})
			task.delay(0.6, function()
				self.Cleanup:Clean()
			end)
		end)
	end

	function KeySystem:Submit(key)
		if self._done or self._checking then
			return self
		end
		if self:IsLocked() then
			self:_Shake()
			return self
		end
		key = string.gsub(tostring(key or ""), "^%s*(.-)%s*$", "%1")
		if key == "" then
			self:SetStatus("Type a key.", "Error")
			self:_Shake()
			return self
		end

		self._checking = true
		self:SetStatus("Checking...")
		task.spawn(function()
			if self.Luarmor then
				local Luarmor = import("Services/Luarmor")
				local status = Luarmor.Check(self.Luarmor, key)
				self._checking = false
				if self._done then
					return
				end
				self.Status = status
				self.Info = Luarmor.Info(status)

				if status.code == "KEY_VALID" then
					Luarmor.SetKey(key)
					self._payload = nil
					self:_SaveKey(key)
					local note = self.Info and (" - " .. Luarmor.Remaining(self.Info)) or ""
					accept(self, "Key accepted" .. note .. ".")
					if self.Luarmor.Load then
						task.defer(function()
							local ok, reason = Luarmor.Load(self.Luarmor, key)
							if not ok then
								Utility.Warn("luarmor load_script failed: " .. tostring(reason))
							end
						end)
					end
					return
				end

				self:_Shake()
				self.Rejected:Fire(key, status.code)
				Utility.SafeCall("KeySystem OnFail", self.Config.OnFail, key, status.code, status.message)
				if Luarmor.IsOwnerFault(status.code) then
					Utility.Warn("luarmor: " .. tostring(status.message))
				end
				if Luarmor.IsFatal(status.code) then
					self:SetStatus(tostring(status.message), "Error")
					return
				end
				self._left -= 1
				if self._attempts then
					self._attempts.SetText(string.format("%d/%d", math.max(self._left, 0), self.Attempts))
				end
				if self._left <= 0 then
					self:_Lock()
				else
					self:SetStatus(tostring(status.message) .. " (" .. self._left .. ")", "Error")
				end
				return
			end

			if self.Plus then
				local body, reason = import("Services/KeyPlus").Request(self.Plus, key)
				self._checking = false
				if self._done then
					return
				end
				if body then
					self._payload = body
					self:_SaveKey(key)
					accept(self, "Unlocked by the server.")
					return
				end
				self._left -= 1
				if self._attempts then
					self._attempts.SetText(string.format("%d/%d", math.max(self._left, 0), self.Attempts))
				end
				self:_Shake()
				self.Rejected:Fire(key)
				Utility.SafeCall("KeySystem OnFail", self.Config.OnFail, key, reason)
				if self._left <= 0 then
					self:_Lock()
				else
					self:SetStatus(tostring(reason or "Invalid key") .. " (" .. self._left .. ")", "Error")
				end
				return
			end

			local ok = self:_Match(key)
			if not ok then
				local remote, reason = self:_Endpoint(key)
				if remote == true then
					ok = true
				elseif remote == false and reason then
					self:SetStatus(tostring(reason), "Error")
				end
			end
			if ok and self.Require == "all" and #self.Checks > 0 then
				local passed = 0
				for index, check in self.Checks do
					local good = check.Run()
					self:_Paint(index, good and "ok" or "fail")
					if good then
						passed += 1
					end
				end
				if passed < #self.Checks then
					ok = false
					self:SetStatus("Key is fine, requirements missing.", "Error")
				end
			end
			self._checking = false
			if self._done then
				return
			end
			if ok then
				self:_SaveKey(key)
				accept(self)
				return
			end
			self._left -= 1
			if self._attempts then
				self._attempts.SetText(string.format("%d/%d", math.max(self._left, 0), self.Attempts))
			end
			self:_Shake()
			self.Rejected:Fire(key)
			Utility.SafeCall("KeySystem OnFail", self.Config.OnFail, key)
			if self._left <= 0 then
				self:_Lock()
			else
				self:SetStatus("Invalid key. " .. self._left .. " tries left.", "Error")
			end
		end)
		return self
	end

	function KeySystem:IsValid()
		return sealed(self)
	end

	function KeySystem:GetPayload()
		return self._payload
	end

	function KeySystem:GetInfo()
		return self.Info
	end

	function KeySystem:GetStatus()
		return self.Status
	end

	function KeySystem:LoadScript()
		if not self.Luarmor then
			return false, "not a luarmor key system"
		end
		return import("Services/Luarmor").Load(self.Luarmor)
	end

	function KeySystem:PurgeCache()
		if not self.Luarmor then
			return false
		end
		return import("Services/Luarmor").PurgeCache(self.Luarmor)
	end

	function KeySystem:RunPayload()
		if type(self._payload) ~= "string" then
			return nil, "sem payload"
		end
		local compiled, err = loadstring(self._payload, "=DeaDx/KeyPlus")
		if not compiled then
			return nil, tostring(err)
		end
		local ok, result = pcall(compiled)
		if not ok then
			return nil, tostring(result)
		end
		return result or true
	end

	function KeySystem:Wait(timeout)
		local deadline = os.clock() + (tonumber(timeout) or 300)
		while not self._done and os.clock() < deadline do
			task.wait(0.04)
		end
		return sealed(self)
	end

	function KeySystem:Destroy()
		self._done = true
		self.Cleanup:Clean()
	end

	return KeySystem
end
end)()

__modules["Services/KeyPlus"] = (function()
return function(import)
	local HttpService = game:GetService("HttpService")
	local Players = game:GetService("Players")
	local Utility = import("Core/Utility")
	local Hash = import("Core/Hash")
	local Capabilities = import("Core/Capabilities")

	local KeyPlus = { Version = 1, Marker = "--DEADX" }

	local function options(value)
		if type(value) == "string" then
			return { Secret = value }
		end
		return value or {}
	end

	local function signature(config, key, hwid, nonce, stamp)
		if not config.Secret then
			return nil
		end
		return Hash.Hmac(config.Secret, table.concat({
			"v1",
			tostring(key),
			tostring(hwid),
			tostring(nonce),
			tostring(stamp),
		}, "|"))
	end
	KeyPlus.Sign = signature

	local function streamKey(config, key, hwid, nonce, stamp)
		local base = config.Secret or tostring(key)
		local tag = config.Secret and "stream" or "ukey"
		local parts = { tag, tostring(nonce), tostring(stamp) }
		if config.BindHwid then
			table.insert(parts, tostring(hwid))
		end
		return Hash.Hmac(base, table.concat(parts, "|"))
	end
	KeyPlus.StreamKey = streamKey

	function KeyPlus.Pack(config, key, hwid, nonce, stamp, payload)
		config = options(config)
		stamp = stamp or os.time()
		nonce = nonce or Hash.Nonce(16)
		local cipher = Hash.Stream(payload, streamKey(config, key, hwid, nonce, stamp))
		local response = {
			v = KeyPlus.Version,
			ts = stamp,
			nonce = nonce,
			data = Hash.ToHex(cipher),
		}
		local sig = signature(config, key, hwid, nonce, stamp)
		if sig then
			response.sig = sig
		end
		return response
	end

	function KeyPlus.Open(config, key, hwid, nonce, response, window)
		config = options(config)
		if type(response) ~= "table" then
			return nil, "invalid response"
		end
		if response.error then
			return nil, tostring(response.error)
		end
		local stamp = tonumber(response.ts or response.timestamp)
		if not stamp then
			return nil, "missing timestamp"
		end
		if math.abs(os.time() - stamp) > (window or config.Window or 300) then
			return nil, "response expired"
		end
		local echo = tostring(response.nonce or response.n or "")
		if echo ~= "" and echo ~= nonce then
			return nil, "nonce mismatch"
		end
		if config.Secret then
			local expected = signature(config, key, hwid, nonce, stamp)
			if not Hash.Equal(string.lower(tostring(response.sig or response.signature or "")), expected) then
				return nil, "invalid signature"
			end
		end

		local raw = response.data or response.payload
		if type(raw) ~= "string" or raw == "" then
			return nil, "missing payload"
		end
		local cipher = Hash.FromHex(raw) or Hash.Base64Decode(raw)
		if not cipher then
			return nil, "corrupted payload"
		end
		local plain = Hash.Stream(cipher, streamKey(config, key, hwid, nonce, stamp))
		if type(plain) ~= "string" or plain == "" then
			return nil, "failed to open"
		end

		local marker = config.Marker or KeyPlus.Marker
		if marker ~= "" and string.sub(plain, 1, #marker) == marker then
			return plain, stamp
		end
		if loadstring and loadstring(plain) then
			return plain, stamp
		end
		return nil, "wrong key"
	end

	function KeyPlus.Request(config, key)
		config = options(config)
		Utility.Check(
			type(config.Endpoint) == "string" and config.Endpoint ~= "",
			"KeyPlus",
			"Endpoint",
			"Endpoint must be a url."
		)

		local player = Players.LocalPlayer
		local hwid = config.Hwid or Capabilities.Hwid()
		local nonce = Hash.Nonce(16)
		local replacements = {
			key = HttpService:UrlEncode(tostring(key or "")),
			hwid = HttpService:UrlEncode(hwid),
			nonce = nonce,
			user = HttpService:UrlEncode(player and player.Name or ""),
			userid = tostring(player and player.UserId or 0),
			place = tostring(game.PlaceId),
			id = HttpService:UrlEncode(tostring(config.KeyId or "")),
			v = tostring(KeyPlus.Version),
		}

		local url = config.Endpoint
		if not string.find(url, "{") then
			local glue = string.find(url, "?", 1, true) and "&" or "?"
			url ..= glue .. "key={key}&hwid={hwid}&nonce={nonce}&v={v}"
		end
		url = string.gsub(url, "{(%w+)}", function(name)
			return replacements[string.lower(name)] or ""
		end)

		local ok, body = Capabilities.HttpGet(url)
		if not ok or type(body) ~= "string" then
			return nil, "no response from the server"
		end

		local parsed, response = pcall(HttpService.JSONDecode, HttpService, body)
		if not parsed or type(response) ~= "table" then
			return nil, "response is not json"
		end

		return KeyPlus.Open(config, key, hwid, nonce, response, config.Window)
	end

	function KeyPlus.Run(config, key)
		local payload, reason = KeyPlus.Request(config, key)
		if not payload then
			return nil, reason
		end
		local compiled, err = loadstring(payload, "=DeaDx/KeyPlus")
		if not compiled then
			return nil, "compile failed: " .. tostring(err)
		end
		local ok, result = pcall(compiled)
		if not ok then
			return nil, "run failed: " .. tostring(result)
		end
		return result or true
	end

	function KeyPlus.Verify(config, key)
		local payload, reason = KeyPlus.Request(config, key)
		return payload ~= nil, reason
	end

	return KeyPlus
end
end)()

__modules["Services/Luarmor"] = (function()
return function(import)
	local Utility = import("Core/Utility")
	local Signal = import("Core/Signal")
	local Capabilities = import("Core/Capabilities")

	local Luarmor = {
		Library = "https://sdkapi-public.luarmor.net/library.lua",
		Loaded = Signal.new(),
	}

	local CODES = {
		KEY_VALID = { Message = "Key accepted.", Ok = true },
		KEY_EXPIRED = { Message = "This key has expired.", Fatal = true },
		KEY_BANNED = { Message = "This key is blacklisted.", Fatal = true },
		KEY_HWID_LOCKED = { Message = "Key is locked to another HWID. Reset it on the bot.", Fatal = true },
		KEY_INCORRECT = { Message = "Key not found. Check it and try again." },
		KEY_INVALID = { Message = "Key format is invalid." },
		SCRIPT_ID_INCORRECT = { Message = "Script id not found.", Fatal = true, Owner = true },
		SCRIPT_ID_INVALID = { Message = "Script id format is invalid.", Fatal = true, Owner = true },
		INVALID_EXECUTOR = { Message = "Executor not supported.", Fatal = true },
		SECURITY_ERROR = { Message = "Request could not be validated.", Fatal = true },
		TIME_ERROR = { Message = "Your system clock is off. Fix the time and retry.", Fatal = true },
		UNKNOWN_ERROR = { Message = "Luarmor is down. Try again in a bit.", Fatal = true },
	}

	function Luarmor.Codes()
		local out = {}
		for code in CODES do
			table.insert(out, code)
		end
		table.sort(out)
		return out
	end

	function Luarmor.Describe(code)
		local entry = CODES[code]
		return entry and entry.Message or ("Unexpected code: " .. tostring(code))
	end

	function Luarmor.IsFatal(code)
		local entry = CODES[code]
		return entry ~= nil and entry.Fatal == true
	end

	function Luarmor.IsOwnerFault(code)
		local entry = CODES[code]
		return entry ~= nil and entry.Owner == true
	end

	local cached

	function Luarmor.Api(config)
		config = config or {}
		if cached and not config.Reload then
			cached.script_id = config.ScriptId or config.script_id or cached.script_id
			return cached
		end
		if not Capabilities.Http then
			return nil, "no http capability"
		end
		local url = config.Library or Luarmor.Library
		local ok, body = Capabilities.HttpGet(url)
		if not ok or type(body) ~= "string" or body == "" then
			return nil, "could not download the luarmor library"
		end
		local compiled, err = loadstring(body, "=DeaDx/Luarmor")
		if not compiled then
			return nil, "luarmor library failed to compile: " .. tostring(err)
		end
		local built, api = pcall(compiled)
		if not built or type(api) ~= "table" then
			return nil, "luarmor library returned no api"
		end
		cached = api
		api.script_id = config.ScriptId or config.script_id
		Luarmor.Loaded:Fire(api)
		return api
	end

	function Luarmor.Check(config, key)
		config = config or {}
		Utility.Check(
			type(config.ScriptId) == "string" and config.ScriptId ~= "",
			"Luarmor",
			"ScriptId",
			"ScriptId is required."
		)
		key = tostring(key or "")
		if key == "" then
			return { code = "KEY_INVALID", message = Luarmor.Describe("KEY_INVALID") }
		end

		local api, reason = Luarmor.Api(config)
		if not api then
			return { code = "UNKNOWN_ERROR", message = reason or Luarmor.Describe("UNKNOWN_ERROR"), Local = true }
		end
		api.script_id = config.ScriptId

		local ran, status = pcall(api.check_key, key)
		if not ran or type(status) ~= "table" or status.code == nil then
			return {
				code = "UNKNOWN_ERROR",
				message = ran and Luarmor.Describe("UNKNOWN_ERROR") or tostring(status),
				Local = true,
			}
		end
		if status.message == nil or status.message == "" then
			status.message = Luarmor.Describe(status.code)
		end
		return status
	end

	function Luarmor.SetKey(key)
		local env = getgenv and getgenv() or _G
		env.script_key = tostring(key or "")
		return env.script_key
	end

	function Luarmor.Load(config, key)
		config = config or {}
		if key then
			Luarmor.SetKey(key)
		end
		local api, reason = Luarmor.Api(config)
		if not api then
			return false, reason
		end
		api.script_id = config.ScriptId or api.script_id
		if type(api.load_script) ~= "function" then
			return false, "luarmor library has no load_script"
		end
		local ok, err = pcall(api.load_script)
		if not ok then
			return false, tostring(err)
		end
		return true
	end

	function Luarmor.PurgeCache(config)
		local api = Luarmor.Api(config or {})
		if not api or type(api.purge_cache) ~= "function" then
			return false
		end
		return (pcall(api.purge_cache))
	end

	function Luarmor.Info(status)
		if type(status) ~= "table" or status.code ~= "KEY_VALID" or type(status.data) ~= "table" then
			return nil
		end
		local data = status.data
		local expire = tonumber(data.auth_expire) or 0
		local left = expire > 0 and (expire - os.time()) or -1
		return {
			Expire = expire,
			Lifetime = expire <= 0,
			SecondsLeft = left,
			Note = data.note,
			Executions = tonumber(data.total_executions) or 0,
			FromAd = data.note == "Ad Reward",
		}
	end

	function Luarmor.Remaining(info)
		if not info or info.Lifetime then
			return "lifetime"
		end
		local left = info.SecondsLeft
		if left <= 0 then
			return "expired"
		end
		local days = math.floor(left / 86400)
		if days >= 1 then
			return days .. (days == 1 and " day left" or " days left")
		end
		local hours = math.floor(left / 3600)
		if hours >= 1 then
			return hours .. (hours == 1 and " hour left" or " hours left")
		end
		return math.max(math.floor(left / 60), 1) .. " min left"
	end

	return Luarmor
end
end)()

__modules["Services/Palette"] = (function()
return function(import)
	local UserInputService = game:GetService("UserInputService")
	local Utility = import("Core/Utility")
	local Signal = import("Core/Signal")
	local Theme = import("Core/Theme")
	local Widgets = import("Core/Widgets")
	local Markup = import("Core/Markup")
	local Component = import("Core/Component")
	local Icons = import("Icons/Icon")
	local Cleanup = import("Services/Cleanup")
	local Animation = import("Services/Animation")
	local Input = import("Services/Input")

	local Palette = {}
	Palette.__index = Palette

	local KINDS = {
		Tab = { Icon = "layout-dashboard", Verb = "open" },
		SubTab = { Icon = "layout-panel-top", Verb = "open" },
		Section = { Icon = "folder", Verb = "go" },
		Card = { Icon = "square", Verb = "go" },
		Toggle = { Icon = "toggle-left", Verb = "toggle" },
		Button = { Icon = "mouse-pointer-click", Verb = "run" },
		Slider = { Icon = "sliders-horizontal", Verb = "go" },
		Dropdown = { Icon = "list", Verb = "open" },
		MultiDropdown = { Icon = "list-checks", Verb = "open" },
		Input = { Icon = "text-cursor-input", Verb = "edit" },
		Keybind = { Icon = "keyboard", Verb = "go" },
		Colorpicker = { Icon = "palette", Verb = "open" },
		Segmented = { Icon = "columns-3", Verb = "go" },
	}

	local function score(text, needle)
		text = string.lower(text or "")
		if needle == "" then
			return 1
		end
		if text == needle then
			return 120
		end
		if string.sub(text, 1, #needle) == needle then
			return 90
		end
		if string.find(text, needle, 1, true) then
			return 60
		end
		local position, hits = 1, 0
		for index = 1, #needle do
			local char = string.sub(needle, index, index)
			local found = string.find(text, char, position, true)
			if not found then
				return 0
			end
			position = found + 1
			hits += 1
		end
		return 20 + hits
	end

	function Palette.new(window, config)
		config = config or {}
		local self = setmetatable({}, Palette)
		self.Window = window
		self.Config = config
		self.Cleanup = Cleanup.new()
		self.Opened = Signal.new()
		self.Actions = {}
		self._open = false
		self._index = 1
		self._rows = {}
		local cleanup = self.Cleanup
		cleanup:Add(self.Opened)

		local gui = cleanup:Add(Utility.NewScreenGui("DeaDx_Palette", config.DisplayOrder or 2300))
		gui.IgnoreGuiInset = true
		gui.Enabled = false
		self.Gui = gui

		local backdrop = Utility.Create("Frame", {
			Name = "Backdrop",
			BackgroundColor3 = Color3.new(0, 0, 0),
			BackgroundTransparency = 0.45,
			Size = UDim2.fromScale(1, 1),
			Active = true,
			Parent = gui,
		})
		local catcher = Utility.Create("TextButton", {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			Text = "",
			Parent = backdrop,
		})
		cleanup:Add(catcher.Activated:Connect(function()
			self:Close()
		end))

		local panel = Widgets.Surface(cleanup, {
			Class = "CanvasGroup",
			Name = "Palette",
			Parent = backdrop,
			Fill = "Background",
			Transparency = 0.04,
			Stroke = "Border",
			StrokeTransparency = 0.3,
			Radius = 18,
			AnchorPoint = Vector2.new(0.5, 0),
			Position = UDim2.new(0.5, 0, 0, 90),
			Size = UDim2.fromOffset(config.Width or 460, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			GroupTransparency = 1,
		})
		self.Panel = panel
		Widgets.Padding(panel, 10, 10)
		Widgets.List(panel, 8)

		local scale = Instance.new("UIScale")
		scale.Scale = 0.97
		scale.Parent = panel
		self._scale = scale

		local bar = Utility.Create("Frame", {
			Name = "Bar",
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 34),
			LayoutOrder = 1,
			Parent = panel,
		})
		Icons.Create(bar, "search", {
			Size = 15,
			Color = "MutedText",
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0, 6, 0.5, 0),
			Cleanup = cleanup,
		})
		local box = Widgets.Text(cleanup, {
			Class = "TextBox",
			Name = "Search",
			Parent = bar,
			PlaceholderText = config.Placeholder or "search an option or action...",
			ClearTextOnFocus = false,
			TextSize = 15,
			Position = UDim2.fromOffset(28, 0),
			Size = UDim2.new(1, -36, 1, 0),
		})
		self._box = box

		Widgets.Surface(cleanup, {
			Name = "Rule",
			Parent = panel,
			Fill = "Border",
			Radius = 0,
			BackgroundTransparency = 0.45,
			Size = UDim2.new(1, 0, 0, 1),
			LayoutOrder = 2,
		})

		local list = Widgets.Scroller(cleanup, {
			Name = "Results",
			Parent = panel,
			Size = UDim2.new(1, 0, 0, config.Height or 232),
			LayoutOrder = 3,
		})
		Widgets.List(list, 3)
		self._list = list

		local hint = Utility.Create("Frame", {
			Name = "Hint",
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 14),
			LayoutOrder = 4,
			Parent = panel,
		})
		Widgets.Text(cleanup, {
			Parent = hint,
			Text = "<fade:0.35>arrows</fade> move   <fade:0.35>enter</fade> use   <fade:0.35>esc</fade> close",
			Color = "MutedText",
			TextSize = 11,
			Size = UDim2.fromScale(1, 1),
		})

		cleanup:Add(box:GetPropertyChangedSignal("Text"):Connect(function()
			self._index = 1
			self:_Render()
		end))

		cleanup:Add(Input.Began:Connect(function(input, processed)
			if not self._open or processed then
				return
			end
			if input.KeyCode == Enum.KeyCode.Escape then
				self:Close()
			elseif input.KeyCode == Enum.KeyCode.Down then
				self:_Move(1)
			elseif input.KeyCode == Enum.KeyCode.Up then
				self:_Move(-1)
			elseif input.KeyCode == Enum.KeyCode.Return or input.KeyCode == Enum.KeyCode.KeypadEnter then
				self:_Activate(self._index)
			end
		end))

		self:SetKey(config.Key or Enum.KeyCode.K, config.Modifier ~= false and (config.Modifier or Enum.KeyCode.LeftControl) or nil)
		self._panel = panel
		return self
	end

	function Palette:SetKey(key, modifier)
		if self._bind then
			self._bind:Destroy()
			self._bind = nil
		end
		self.Key, self.Modifier = key, modifier
		if not key then
			return self
		end
		self._bind = self.Cleanup:Add(Input.AddBind(key, function()
			if modifier and not UserInputService:IsKeyDown(modifier) then
				return
			end
			self:Toggle()
		end, "Command palette"))
		return self
	end

	function Palette:AddAction(config)
		Utility.Check(type(config) == "table" and type(config.Title) == "string", "Palette action", config and config.Title, "Title must be a string.")
		table.insert(self.Actions, config)
		return self
	end

	function Palette:_Entries(needle)
		local out = {}

		for _, action in self.Actions do
			local value = score(action.Title, needle)
			if value > 0 then
				table.insert(out, {
					Score = value + 15,
					Title = action.Title,
					Detail = action.Detail or "action",
					Icon = action.Icon or "zap",
					Run = action.Callback,
				})
			end
		end

		for _, entry in self.Window:Index()._entries do
			local title = Markup.Strip(entry.Title or "")
			local value = score(title, needle)
			if value == 0 then
				value = score(Markup.Strip(entry.Description or ""), needle) * 0.4
			end
			if value > 0 then
				local kind = KINDS[entry.Kind] or { Icon = "dot", Verb = "go" }
				local crumb = { entry.Tab and entry.Tab.Title or "" }
				if entry.SubTab then
					table.insert(crumb, entry.SubTab.Title)
				end
				if entry.Section and entry.Kind ~= "Section" then
					table.insert(crumb, entry.Section.Title)
				end
				local component = entry.Component
				local detail = table.concat(crumb, " / ")
				if component and component.State then
					detail ..= "   " .. Component.Describe(component.State:Get())
				end
				table.insert(out, {
					Score = value,
					Title = title,
					Detail = detail,
					Icon = entry.Component and entry.Component.Config.Icon or kind.Icon,
					Verb = kind.Verb,
					Entry = entry,
					Component = component,
				})
			end
		end

		table.sort(out, function(a, b)
			if a.Score ~= b.Score then
				return a.Score > b.Score
			end
			return a.Title < b.Title
		end)
		local limited = {}
		for index = 1, math.min(#out, self.Config.Limit or 40) do
			limited[index] = out[index]
		end
		return limited
	end

	function Palette:_Render()
		if self._scope then
			self._scope:Clean()
		end
		self._scope = self.Cleanup:Extend()
		local scope = self._scope
		local needle = string.lower((string.gsub(self._box.Text, "^%s*(.-)%s*$", "%1")))
		self._results = self:_Entries(needle)
		table.clear(self._rows)

		if #self._results == 0 then
			scope:Add((Widgets.Text(scope, {
				Parent = self._list,
				Text = "nothing found",
				Color = "MutedText",
				TextXAlignment = Enum.TextXAlignment.Center,
				Size = UDim2.new(1, 0, 0, 40),
			})))
			return
		end

		for index, result in self._results do
			local row = Widgets.Surface(scope, {
				Class = "TextButton",
				Parent = self._list,
				Fill = "SecondaryBackground",
				Transparency = 1,
				Radius = 11,
				Size = UDim2.new(1, 0, 0, 42),
				LayoutOrder = index,
			})
			scope:Add(row)
			local holder = Utility.Create("Frame", {
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(0, 0.5),
				Position = UDim2.new(0, 11, 0.5, 0),
				Size = UDim2.fromOffset(16, 16),
				Parent = row,
			})
			Icons.Create(holder, result.Icon, { Size = 16, Color = "MutedText", Cleanup = scope })
			Widgets.Text(scope, {
				Parent = row,
				Text = result.Title,
				Bold = true,
				TextSize = 13,
				Position = UDim2.fromOffset(37, 6),
				Size = UDim2.new(1, -90, 0, 16),
				TextTruncate = Enum.TextTruncate.AtEnd,
				Markup = false,
			})
			Widgets.Text(scope, {
				Parent = row,
				Text = result.Detail,
				Color = "MutedText",
				TextSize = 11,
				Position = UDim2.fromOffset(37, 22),
				Size = UDim2.new(1, -90, 0, 14),
				TextTruncate = Enum.TextTruncate.AtEnd,
				Markup = false,
			})
			local _, verb = Widgets.Text(scope, {
				Parent = row,
				Text = result.Verb or "run",
				Color = "MutedText",
				TextSize = 10,
				TextXAlignment = Enum.TextXAlignment.Right,
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.new(1, -11, 0.5, 0),
				Size = UDim2.fromOffset(60, 14),
				Markup = false,
			})
			scope:Add(row.Activated:Connect(function()
				self:_Activate(index)
			end))
			scope:Add(row.MouseEnter:Connect(function()
				self._index = index
				self:_Highlight()
			end))
			self._rows[index] = { Frame = row, Verb = verb }
		end
		self:_Highlight()
	end

	function Palette:_Highlight()
		for index, row in self._rows do
			local active = index == self._index
			Animation:Play(row.Frame, {
				BackgroundTransparency = active and 0.25 or 1,
				BackgroundColor3 = Theme.Get(active and "Hover" or "SecondaryBackground"),
			}, { Duration = 0.1 })
			row.Verb.SetColor(active and "Accent" or "MutedText")
		end
	end

	function Palette:_Move(delta)
		if #self._rows == 0 then
			return
		end
		self._index = (self._index - 1 + delta) % #self._rows + 1
		self:_Highlight()
		local row = self._rows[self._index]
		if row then
			local top = row.Frame.AbsolutePosition.Y - self._list.AbsolutePosition.Y + self._list.CanvasPosition.Y
			local height = self._list.AbsoluteSize.Y
			if top < self._list.CanvasPosition.Y then
				self._list.CanvasPosition = Vector2.new(0, math.max(top - 4, 0))
			elseif top + 42 > self._list.CanvasPosition.Y + height then
				self._list.CanvasPosition = Vector2.new(0, top + 46 - height)
			end
		end
	end

	function Palette:_Activate(index)
		local result = self._results and self._results[index]
		if not result then
			return
		end
		self:Close()
		task.defer(function()
			if result.Run then
				Utility.SafeCall("Palette action", result.Run)
				return
			end
			local component = result.Component
			if component and not component:IsLocked() and component.Enabled then
				if type(component.Fire) == "function" then
					component:Fire()
					return
				end
				if component.State and type(component.State:Get()) == "boolean" then
					component.State:Set(not component.State:Get())
					return
				end
			end
			if result.Entry then
				self.Window:_GoTo(result.Entry)
			end
		end)
	end

	function Palette:IsOpen()
		return self._open
	end

	function Palette:Open()
		if self._open then
			return self
		end
		self._open = true
		self.Gui.Enabled = true
		self._box.Text = ""
		self._index = 1
		self:_Render()
		Animation:Play(self._panel, { GroupTransparency = 0 }, { Duration = 0.14 })
		Animation:Play(self._scale, { Scale = 1 }, { Duration = 0.2, Style = Enum.EasingStyle.Back })
		task.defer(function()
			if self._open then
				self._box:CaptureFocus()
			end
		end)
		self.Opened:Fire()
		return self
	end

	function Palette:Close()
		if not self._open then
			return self
		end
		self._open = false
		self._box:ReleaseFocus()
		Animation:Play(self._scale, { Scale = 0.97 }, { Duration = 0.12 })
		Animation:Play(self._panel, { GroupTransparency = 1 }, {
			Duration = 0.12,
			OnComplete = function()
				if not self._open then
					self.Gui.Enabled = false
				end
			end,
		})
		return self
	end

	function Palette:Toggle()
		if self._open then
			return self:Close()
		end
		return self:Open()
	end

	function Palette:Destroy()
		self._open = false
		self.Cleanup:Clean()
	end

	return Palette
end
end)()

__modules["Services/ThemeEditor"] = (function()
return function(import)
	local HttpService = game:GetService("HttpService")
	local Utility = import("Core/Utility")
	local Theme = import("Core/Theme")
	local Capabilities = import("Core/Capabilities")

	local ThemeEditor = {}

	local GROUPS = {
		{
			Title = "Background",
			Icon = "layers",
			Tokens = { "Background", "SecondaryBackground", "TertiaryBackground", "Border" },
		},
		{
			Title = "Accent",
			Icon = "palette",
			Tokens = { "Accent", "AccentText", "Hover", "Pressed" },
		},
		{
			Title = "Text",
			Icon = "type",
			Tokens = { "Text", "MutedText" },
		},
		{
			Title = "States",
			Icon = "bell",
			Tokens = { "Success", "Warning", "Error", "Info" },
		},
	}

	local SLIDERS = {
		{ Token = "AcrylicTransparency", Title = "Acrylic", Max = 1 },
		{ Token = "ElementTransparency", Title = "Elements", Max = 1 },
		{ Token = "ComponentTransparency", Title = "Components", Max = 1 },
		{ Token = "ComponentStrokeTransparency", Title = "Strokes", Max = 1 },
	}

	local function snapshot()
		local out = {}
		for _, group in GROUPS do
			for _, token in group.Tokens do
				local value = Theme.Get(token)
				if typeof(value) == "Color3" then
					out[token] = value
				end
			end
		end
		for _, entry in SLIDERS do
			local value = Theme.Get(entry.Token)
			if type(value) == "number" then
				out[entry.Token] = value
			end
		end
		return out
	end

	function ThemeEditor.Export(name)
		local lines = { "return {" }
		local data = snapshot()
		local keys = {}
		for token in data do
			table.insert(keys, token)
		end
		table.sort(keys)
		for _, token in keys do
			local value = data[token]
			if typeof(value) == "Color3" then
				table.insert(lines, string.format(
					"\t%s = Color3.fromRGB(%d, %d, %d),",
					token,
					math.floor(value.R * 255 + 0.5),
					math.floor(value.G * 255 + 0.5),
					math.floor(value.B * 255 + 0.5)
				))
			else
				table.insert(lines, string.format("\t%s = %.2f,", token, value))
			end
		end
		table.insert(lines, "}")
		return table.concat(lines, "\n"), name
	end

	function ThemeEditor.Build(container, config)
		config = config or {}
		Utility.Check(type(container) == "table" and container.Container, "ThemeEditor", "?", "Needs a tab, section or card.")
		local name = config.Name or "Custom"
		local created = {}

		local picker = container:AddDropdown(config.Id or "theme/base", {
			Title = "Base theme",
			Description = "switches the theme and reloads the values",
			Values = Theme.Names(),
			Default = Theme.GetName(),
			Searchable = true,
			Callback = function(value)
				if Theme.IsLocked() then
					return
				end
				Theme.Set(value)
				for token, control in created do
					local current = Theme.Get(token)
					if typeof(current) == "Color3" then
						control:SetValue(current)
					elseif type(current) == "number" then
						control:SetValue(current)
					end
				end
			end,
		})

		for _, group in GROUPS do
			local host = container.AddCard and container:AddCard({
				Title = group.Title,
				Icon = group.Icon,
				Collapsible = true,
				Collapsed = true,
			}) or container
			for _, token in group.Tokens do
				local value = Theme.Get(token)
				if typeof(value) == "Color3" then
					created[token] = host:AddColorpicker("theme/" .. token, {
						Title = token,
						Default = value,
						Swatches = true,
						Harmony = true,
						Callback = function(color)
							Theme.Override(token, color)
						end,
					})
				end
			end
		end

		local fades = container.AddCard and container:AddCard({
			Title = "Transparency",
			Icon = "droplet",
			Collapsible = true,
			Collapsed = true,
		}) or container
		for _, entry in SLIDERS do
			local value = Theme.Get(entry.Token)
			if type(value) == "number" then
				created[entry.Token] = fades:AddSlider("theme/" .. entry.Token, {
					Title = entry.Title,
					Min = 0,
					Max = entry.Max or 1,
					Default = value,
					Increment = 0.02,
					Rounding = 2,
					Callback = function(amount)
						Theme.Override(entry.Token, amount)
					end,
				})
			end
		end

		container:AddButton({
			Title = "Copy theme",
			Description = "sends the ready table to the clipboard",
			Icon = "clipboard-copy",
			Callback = function()
				local source = ThemeEditor.Export(name)
				if Capabilities.SetClipboard(source) then
					container.Window:Toast("Theme copied", "Success")
				else
					container.Window:Toast("No clipboard on this executor", "Warning")
				end
			end,
		})

		container:AddButton({
			Title = "Save as theme",
			Description = "registers " .. name .. " and applies it",
			Icon = "save",
			Callback = function()
				Theme.Register(name, snapshot())
				Theme.Set(name)
				picker:SetValues(Theme.Names())
				picker:SetValue(name)
				container.Window:Toast("Theme " .. name .. " saved", "Success")
			end,
		})

		return {
			Controls = created,
			Export = ThemeEditor.Export,
			Snapshot = snapshot,
		}
	end

	return ThemeEditor
end
end)()

__modules["Services/Tour"] = (function()
return function(import)
	local Utility = import("Core/Utility")
	local Signal = import("Core/Signal")
	local Theme = import("Core/Theme")
	local Widgets = import("Core/Widgets")
	local Icons = import("Icons/Icon")
	local Cleanup = import("Services/Cleanup")
	local Animation = import("Services/Animation")
	local Input = import("Services/Input")

	local Tour = {}
	Tour.__index = Tour

	local PAD = 6

	function Tour.new(window, steps, config)
		config = config or {}
		Utility.Check(type(steps) == "table" and #steps > 0, "Tour", "?", "Steps must be a non-empty array.")
		local self = setmetatable({}, Tour)
		self.Window = window
		self.Steps = steps
		self.Config = config
		self.Cleanup = Cleanup.new()
		self.Finished = Signal.new()
		self.Changed = Signal.new()
		self._index = 0
		self._done = false
		local cleanup = self.Cleanup
		cleanup:Add(self.Finished)
		cleanup:Add(self.Changed)

		local gui = cleanup:Add(Utility.NewScreenGui("DeaDx_Tour", config.DisplayOrder or 2200))
		gui.IgnoreGuiInset = true
		self.Gui = gui

		local shade = Utility.Create("CanvasGroup", {
			Name = "Shade",
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			GroupTransparency = 1,
			Parent = gui,
		})
		self._shade = shade

		self._panels = {}
		for _, name in { "Top", "Bottom", "Left", "Right" } do
			local panel = Utility.Create("Frame", {
				Name = name,
				BackgroundColor3 = config.Backdrop or Color3.fromRGB(4, 4, 6),
				BackgroundTransparency = config.Dim or 0.25,
				Size = UDim2.new(),
				Parent = shade,
			})
			self._panels[name] = panel
		end

		local halo = Widgets.Surface(cleanup, {
			Name = "Halo",
			Parent = gui,
			Stroke = config.Color or "Accent",
			StrokeTransparency = 0.1,
			Radius = 16,
			Size = UDim2.new(),
			Visible = false,
		})
		halo:FindFirstChildOfClass("UIStroke").Thickness = 2
		self._halo = halo

		local card = Widgets.Surface(cleanup, {
			Class = "CanvasGroup",
			Name = "Step",
			Parent = gui,
			Fill = "Background",
			Transparency = 0.04,
			Stroke = "Border",
			StrokeTransparency = 0.3,
			Radius = 16,
			Size = UDim2.fromOffset(config.Width or 268, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			GroupTransparency = 1,
		})
		self._card = card
		Widgets.Padding(card, 16, 15)
		Widgets.List(card, 9)

		local head = Utility.Create("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 18),
			LayoutOrder = 1,
			Parent = card,
		})
		local holder = Utility.Create("Frame", {
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0, 0, 0.5, 0),
			Size = UDim2.fromOffset(15, 15),
			Parent = head,
		})
		self._icon = Icons.Create(holder, config.Icon or "compass", {
			Size = 15,
			Color = config.Color or "Accent",
			Cleanup = cleanup,
		})
		local _, title = Widgets.Text(cleanup, {
			Parent = head,
			Text = "",
			Bold = true,
			TextSize = 14,
			Position = UDim2.fromOffset(22, 0),
			Size = UDim2.new(1, -62, 1, 0),
			TextTruncate = Enum.TextTruncate.AtEnd,
		})
		self._title = title
		local _, counter = Widgets.Text(cleanup, {
			Parent = head,
			Text = "",
			Color = "MutedText",
			TextSize = 11,
			TextXAlignment = Enum.TextXAlignment.Right,
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.fromScale(1, 0),
			Size = UDim2.fromOffset(40, 18),
			Markup = false,
		})
		self._counter = counter

		local _, body = Widgets.Text(cleanup, {
			Parent = card,
			Text = "",
			Color = "MutedText",
			TextSize = 12,
			TextWrapped = true,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.new(1, 0, 0, 0),
			LayoutOrder = 2,
		})
		self._body = body

		local track = Widgets.Surface(cleanup, {
			Parent = card,
			Fill = "SecondaryBackground",
			Transparency = 0.2,
			Radius = "Full",
			ClipsDescendants = true,
			Size = UDim2.new(1, 0, 0, 3),
			LayoutOrder = 3,
		})
		self._progress = Widgets.Surface(cleanup, {
			Parent = track,
			Fill = config.Color or "Accent",
			Radius = "Full",
			Size = UDim2.fromScale(0, 1),
		})

		local row = Utility.Create("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 30),
			LayoutOrder = 4,
			Parent = card,
		})
		Widgets.List(row, 7, {
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
		})

		local function button(text, primary, order, width, callback)
			local control = Widgets.Surface(cleanup, {
				Class = "TextButton",
				Parent = row,
				Fill = primary and (config.Color or "Accent") or "SecondaryBackground",
				Stroke = (not primary) and "Border" or nil,
				StrokeTransparency = 0.4,
				Radius = 10,
				Size = UDim2.new(width, -4, 1, 0),
				LayoutOrder = order,
				Text = text,
				TextSize = 12,
			})
			Theme.BindFn(function()
				control.TextColor3 = Theme.Get(primary and "AccentText" or "Text")
				control.FontFace = Theme.FontBold
			end, cleanup)
			Widgets.Interactive(cleanup, control, control, {
				Base = primary and (config.Color or "Accent") or "SecondaryBackground",
				Hover = primary and (config.Color or "Accent") or "Hover",
				Pressed = primary and (config.Color or "Accent") or "Pressed",
				Alpha = primary and { 0, 0.12, 0.25 } or nil,
			})
			cleanup:Add(control.Activated:Connect(callback))
			return control
		end

		button(config.SkipText or "Skip", false, 1, 0.3, function()
			self:Finish(true)
		end)
		self._back = button(config.BackText or "Back", false, 2, 0.3, function()
			self:Prev()
		end)
		self._next = button(config.NextText or "Next", true, 3, 0.4, function()
			self:Next()
		end)

		cleanup:Add(Input.Began:Connect(function(input, processed)
			if self._done or processed then
				return
			end
			if input.KeyCode == Enum.KeyCode.Escape then
				self:Finish(true)
			elseif input.KeyCode == Enum.KeyCode.Right or input.KeyCode == Enum.KeyCode.Return then
				self:Next()
			elseif input.KeyCode == Enum.KeyCode.Left then
				self:Prev()
			end
		end))

		Animation:Play(shade, { GroupTransparency = 0 }, { Duration = 0.25, Ease = "Smooth" })
		self:Next()
		return self
	end

	function Tour:_Target(step)
		local window = self.Window
		if step.Tab then
			window:SelectTab(step.Tab)
		end
		local target = step.Target
		if type(target) == "string" then
			local component = window.Options[target]
			if component then
				if not step.Tab and component._entry then
					window:_GoTo(component._entry)
				end
				return component.Frame
			end
			local tab = window:GetTab(target)
			if tab then
				window:SelectTab(tab)
				return tab.Button
			end
			return nil
		end
		if typeof(target) == "Instance" and target:IsA("GuiObject") then
			return target
		end
		if type(target) == "table" and target.Frame then
			return target.Frame
		end
		return nil
	end

	function Tour:_Frame(rect, instant, override)
		local gui = self.Gui
		local origin = gui.AbsolutePosition
		local viewport = gui.AbsoluteSize
		local duration = instant and 0 or (override or 0.34)
		local panels = self._panels
		local x = rect.Position.X - origin.X
		local y = rect.Position.Y - origin.Y
		local w, h = rect.Size.X, rect.Size.Y

		local function move(panel, px, py, sx, sy)
			Animation:Play(panel, {
				Position = UDim2.fromOffset(px, py),
				Size = UDim2.fromOffset(math.max(sx, 0), math.max(sy, 0)),
			}, { Duration = duration, Ease = "Smooth" })
		end

		move(panels.Top, 0, 0, viewport.X, y)
		move(panels.Bottom, 0, y + h, viewport.X, viewport.Y - (y + h))
		move(panels.Left, 0, y, x, h)
		move(panels.Right, x + w, y, viewport.X - (x + w), h)

		self._halo.Visible = true
		Animation:Play(self._halo, {
			Position = UDim2.fromOffset(x, y),
			Size = UDim2.fromOffset(w, h),
		}, { Duration = duration, Ease = "Smooth" })

		local card = self._card
		local cardWidth = card.AbsoluteSize.X
		local cardHeight = math.max(card.AbsoluteSize.Y, 120)
		local below = y + h + 12
		local cardY = below
		if below + cardHeight > viewport.Y - 12 then
			cardY = math.max(y - cardHeight - 12, 12)
		end
		local cardX = math.clamp(x + w / 2 - cardWidth / 2, 12, math.max(12, viewport.X - cardWidth - 12))
		Animation:Play(card, {
			Position = UDim2.fromOffset(cardX, cardY),
		}, { Duration = duration, Ease = "Smooth" })
	end

	function Tour:_Show(index)
		local step = self.Steps[index]
		if not step then
			return self:Finish()
		end
		self._index = index
		self._title.SetText(step.Title or "Step " .. index)
		self._body.SetText(step.Text or step.Description or "")
		self._counter.SetText(index .. "/" .. #self.Steps)
		self._back.Visible = index > 1
		self._next.Text = index == #self.Steps and (self.Config.DoneText or "Done") or (self.Config.NextText or "Next")
		Animation:Play(self._progress, { Size = UDim2.fromScale(index / #self.Steps, 1) }, {
			Duration = 0.3,
			Ease = "Smooth",
		})
		self.Changed:Fire(index, step)

		task.spawn(function()
			if self._done then
				return
			end
			local frame = self:_Target(step)
			local token = self._index

			local function rect()
				if frame and frame.Parent and frame.AbsoluteSize.Y > 0 then
					return {
						Position = frame.AbsolutePosition - Vector2.new(PAD, PAD),
						Size = frame.AbsoluteSize + Vector2.new(PAD * 2, PAD * 2),
					}
				end
				local gui = self.Gui
				self._halo.Visible = false
				return {
					Position = gui.AbsolutePosition + gui.AbsoluteSize / 2 - Vector2.new(1, 1),
					Size = Vector2.new(2, 2),
				}
			end

			task.wait(step.Delay or 0.34)
			if self._done or self._index ~= token then
				return
			end
			self:_Frame(rect(), not self._started)
			self._started = true
			if self._card.GroupTransparency > 0 then
				Animation:Play(self._card, { GroupTransparency = 0 }, { Duration = 0.2 })
			end
			if step.Run then
				Utility.SafeCall("Tour step", step.Run, self.Window)
			end

			local last
			for _ = 1, 9 do
				task.wait(0.12)
				if self._done or self._index ~= token then
					return
				end
				local settled = rect()
				if last and (settled.Position - last).Magnitude < 1 and (settled.Size - self._halo.AbsoluteSize).Magnitude < 2 then
					break
				end
				last = settled.Position
				self:_Frame(settled, false, 0.16)
			end
		end)
		return self
	end

	function Tour:Next()
		if self._done then
			return self
		end
		if self._index >= #self.Steps then
			return self:Finish()
		end
		return self:_Show(self._index + 1)
	end

	function Tour:Prev()
		if self._done or self._index <= 1 then
			return self
		end
		return self:_Show(self._index - 1)
	end

	function Tour:Goto(index)
		return self:_Show(math.clamp(index, 1, #self.Steps))
	end

	function Tour:IsRunning()
		return not self._done
	end

	function Tour:Finish(skipped)
		if self._done then
			return self
		end
		self._done = true
		self.Finished:Fire(skipped == true, self._index)
		Utility.SafeCall("Tour finish", self.Config.OnFinish, skipped == true)
		Animation:Play(self._card, { GroupTransparency = 1 }, { Duration = 0.18 })
		Animation:Play(self._shade, { GroupTransparency = 1 }, {
			Duration = 0.24,
			OnComplete = function()
				self.Cleanup:Clean()
			end,
		})
		task.delay(0.7, function()
			self.Cleanup:Clean()
		end)
		return self
	end

	function Tour:Destroy()
		self._done = true
		self.Cleanup:Clean()
	end

	return Tour
end
end)()

__modules["Services/Console"] = (function()
return function(import)
	local Utility = import("Core/Utility")
	local Signal = import("Core/Signal")
	local Theme = import("Core/Theme")
	local Widgets = import("Core/Widgets")
	local Markup = import("Core/Markup")
	local Capabilities = import("Core/Capabilities")
	local Icons = import("Icons/Icon")
	local Animation = import("Services/Animation")

	local Console = {
		Limit = 300,
		Entries = {},
		Added = Signal.new(),
		Cleared = Signal.new(),
		Mirror = false,
	}

	local LEVELS = {
		Info = { Color = "Info", Icon = "info" },
		Success = { Color = "Success", Icon = "circle-check" },
		Warning = { Color = "Warning", Icon = "triangle-alert" },
		Error = { Color = "Error", Icon = "alert-circle" },
		Debug = { Color = "MutedText", Icon = "bug" },
	}

	function Console.Log(text, level, tag)
		level = LEVELS[level] and level or "Info"
		local entry = {
			Text = tostring(text),
			Level = level,
			Tag = tag,
			Clock = os.date("%H:%M:%S"),
			Time = os.clock(),
		}
		table.insert(Console.Entries, entry)
		while #Console.Entries > Console.Limit do
			table.remove(Console.Entries, 1)
		end
		if Console.Mirror then
			local prefix = "[DEADX]" .. (tag and ("[" .. tag .. "]") or "")
			if level == "Error" then
				warn(prefix .. " " .. entry.Text)
			else
				print(prefix, entry.Text)
			end
		end
		Console.Added:Fire(entry)
		return entry
	end

	function Console.Clear()
		table.clear(Console.Entries)
		Console.Cleared:Fire()
	end

	function Console.Dump()
		local lines = {}
		for _, entry in Console.Entries do
			table.insert(lines, string.format(
				"[%s][%s]%s %s",
				entry.Clock,
				string.upper(entry.Level),
				entry.Tag and ("[" .. entry.Tag .. "]") or "",
				Markup.Strip(entry.Text)
			))
		end
		return table.concat(lines, "\n")
	end

	function Console.Levels()
		local out = {}
		for name in LEVELS do
			table.insert(out, name)
		end
		table.sort(out)
		return out
	end

	function Console.Build(container, config)
		config = config or {}
		Utility.Check(
			type(container) == "table" and container.Container,
			"Console",
			"?",
			"Needs a tab, section or card."
		)
		local cleanup = container.Cleanup:Extend()
		local height = config.Height or 190
		local filter, level = "", "All"
		local handle = {}

		local frame, stroke = Widgets.Surface(cleanup, {
			Name = "Console",
			Parent = container.Container,
			Fill = config.Background or "Background",
			Transparency = config.Transparency or 0.2,
			Stroke = "Border",
			StrokeTransparency = 0.5,
			Radius = 14,
			Size = UDim2.new(1, 0, 0, height),
			LayoutOrder = container.NextOrder(),
		})
		cleanup:Add(frame)
		Widgets.Padding(frame, 10, 10)

		local bar = Utility.Create("Frame", {
			Name = "Bar",
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 26),
			Parent = frame,
		})
		local _, search = Widgets.Field(cleanup, {
			Name = "Filter",
			Parent = bar,
			Radius = 9,
			Placeholder = "filter...",
			Size = UDim2.new(1, -128, 1, 0),
			Inset = 9,
			Trail = 9,
		})
		cleanup:Add(search:GetPropertyChangedSignal("Text"):Connect(function()
			filter = string.lower(search.Text)
			if handle.Refresh then
				handle:Refresh()
			end
		end))

		local function chip(iconName, offset, callback)
			local button = Widgets.Chip(cleanup, {
				Parent = bar,
				Radius = 9,
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.new(1, -offset, 0.5, 0),
				Size = UDim2.fromOffset(26, 26),
			})
			local icon = Icons.Create(button, iconName, {
				Size = 13,
				Position = UDim2.fromOffset(6.5, 6.5),
				Cleanup = cleanup,
			})
			cleanup:Add(button.Activated:Connect(callback))
			return button, icon
		end

		local list = Widgets.Scroller(cleanup, {
			Name = "Lines",
			Parent = frame,
			Position = UDim2.fromOffset(0, 32),
			Size = UDim2.new(1, 0, 1, -32),
			Thickness = 3,
		})
		Widgets.List(list, 2)

		local rows = cleanup:Extend()

		function handle:Refresh()
			rows:Clean()
			rows = cleanup:Extend()
			local shown = 0
			for index, entry in Console.Entries do
				local matches = filter == "" or string.find(string.lower(Markup.Strip(entry.Text)), filter, 1, true)
				if matches and (level == "All" or entry.Level == level) then
					shown += 1
					local row = Utility.Create("Frame", {
						Name = "Line",
						BackgroundTransparency = 1,
						AutomaticSize = Enum.AutomaticSize.Y,
						Size = UDim2.new(1, 0, 0, 0),
						LayoutOrder = index,
						Parent = list,
					})
					rows:Add(row)
					Widgets.Surface(rows, {
						Parent = row,
						Fill = LEVELS[entry.Level].Color,
						Radius = "Full",
						Position = UDim2.fromOffset(0, 5),
						Size = UDim2.fromOffset(2, 10),
					})
					Widgets.Text(rows, {
						Parent = row,
						Text = entry.Clock,
						Color = "MutedText",
						TextSize = 10,
						Position = UDim2.fromOffset(8, 1),
						Size = UDim2.fromOffset(48, 14),
						Markup = false,
					})
					Widgets.Text(rows, {
						Parent = row,
						Text = (entry.Tag and ("<fade:0.4>[" .. entry.Tag .. "]</fade> ") or "") .. entry.Text,
						Color = entry.Level == "Error" and "Error" or (entry.Level == "Warning" and "Warning" or "Text"),
						TextSize = 11,
						TextWrapped = true,
						AutomaticSize = Enum.AutomaticSize.Y,
						Position = UDim2.fromOffset(58, 0),
						Size = UDim2.new(1, -62, 0, 0),
					})
				end
			end
			if shown == 0 then
				rows:Add((Widgets.Text(rows, {
					Parent = list,
					Text = #Console.Entries == 0 and "no logs yet" or "nothing matches",
					Color = "MutedText",
					TextSize = 11,
					TextXAlignment = Enum.TextXAlignment.Center,
					Size = UDim2.new(1, 0, 0, 28),
				})))
			end
			if config.AutoScroll ~= false then
				task.defer(function()
					if list.Parent then
						list.CanvasPosition = Vector2.new(0, list.AbsoluteCanvasSize.Y)
					end
				end)
			end
		end

		local copyButton, copyIcon = chip("copy", 60, function()
			if Capabilities.SetClipboard(Console.Dump()) then
				copyIcon:Set("check")
				task.delay(1.2, function()
					if copyIcon then
						copyIcon:Set("copy")
					end
				end)
			end
		end)

		chip("eraser", 30, function()
			Console.Clear()
		end)

		local levelButton, levelIcon = chip("filter", 0, function()
			local levels = { "All" }
			for _, name in Console.Levels() do
				table.insert(levels, name)
			end
			local index = (table.find(levels, level) or 1) % #levels + 1
			level = levels[index]
			levelIcon:SetColor(level == "All" and "MutedText" or LEVELS[level].Color)
			handle:Refresh()
		end)

		cleanup:Add(Console.Added:Connect(function()
			handle:Refresh()
		end))
		cleanup:Add(Console.Cleared:Connect(function()
			handle:Refresh()
		end))
		handle:Refresh()

		handle.Frame = frame
		handle.List = list
		function handle:Destroy()
			cleanup:Clean()
		end
		return handle
	end

	return Console
end
end)()

__modules["Services/ConfigPanel"] = (function()
return function(import)
	local Utility = import("Core/Utility")
	local Config = import("Core/Config")
	local Capabilities = import("Core/Capabilities")

	local ConfigPanel = {}

	function ConfigPanel.Build(container, config)
		config = config or {}
		Utility.Check(
			type(container) == "table" and container.Container,
			"ConfigPanel",
			"?",
			"Needs a tab, section or card."
		)
		local window = container.Window
		local prefix = config.Prefix or "configs"
		local handle = {}

		local function toast(text, kind)
			if window and window.Toast then
				window:Toast(text, kind)
			end
		end

		local name = container:AddInput(prefix .. "/name", {
			Title = "Name",
			Description = "what the file will be called",
			Placeholder = "default",
			Default = config.Default or "default",
			Icon = "file-pen",
		})

		local list
		local function refresh(silent)
			local saved = Config:List()
			if #saved == 0 then
				saved = { "none" }
			end
			list:SetValues(saved)
			if not silent then
				toast(#Config:List() .. " config(s)", "Info")
			end
		end

		list = container:AddDropdown(prefix .. "/list", {
			Title = "Saved",
			Description = "pick one to load",
			Values = (function()
				local saved = Config:List()
				return #saved > 0 and saved or { "none" }
			end)(),
			Searchable = true,
			Icon = "folder-open",
			Callback = function(value)
				if value and value ~= "none" then
					name:SetValue(value)
				end
			end,
		})

		container:AddButton({
			Title = "Save",
			Description = "writes everything with an id",
			Icon = "save",
			Callback = function()
				local target = name:GetValue()
				if target == "" then
					toast("Pick a name", "Warning")
					return
				end
				local ok, err = Config:Save(target)
				refresh(true)
				toast(ok and ("Saved to " .. target) or tostring(err), ok and "Success" or "Error")
			end,
		})

		container:AddButton({
			Title = "Load",
			Icon = "folder-down",
			Callback = function()
				local target = name:GetValue()
				local ok, err = Config:Load(target)
				toast(ok and ("Loaded " .. target) or tostring(err), ok and "Success" or "Error")
			end,
		})

		container:AddButton({
			Title = "Delete",
			Icon = "trash-2",
			Cooldown = config.DeleteCooldown or 2,
			Callback = function()
				local target = name:GetValue()
				local ok = Config:Delete(target)
				refresh(true)
				toast(ok and ("Deleted " .. target) or "Not found", ok and "Success" or "Error")
			end,
		})

		container:AddButton({
			Title = "Refresh list",
			Icon = "refresh-ccw",
			Callback = function()
				refresh()
			end,
		})

		container:AddToggle(prefix .. "/autosave", {
			Title = "Auto save",
			Description = "writes on every change",
			Default = Config.AutoSave,
			Callback = function(value)
				Config:SetAutoSave(value, name:GetValue())
			end,
		})

		if config.Transfer ~= false then
			container:AddDivider({ Title = "transfer" })

			container:AddButton({
				Title = "Copy config",
				Description = "sends the json to the clipboard",
				Icon = "clipboard-copy",
				Callback = function()
					if Capabilities.SetClipboard(Config:Serialize()) then
						toast("Config copied", "Success")
					else
						toast("No clipboard on this executor", "Warning")
					end
				end,
			})

			local paste = container:AddInput(prefix .. "/paste", {
				Title = "Paste config",
				Description = "paste the json here and confirm",
				Placeholder = "{...}",
				Width = 210,
			})

			container:AddButton({
				Title = "Import",
				Icon = "clipboard-paste",
				Callback = function()
					local text = paste:GetValue()
					if text == "" then
						toast("Paste the json first", "Warning")
						return
					end
					local ok, err = Config:Deserialize(text)
					if ok then
						paste:SetValue("")
					end
					toast(ok and "Imported" or tostring(err), ok and "Success" or "Error")
				end,
			})
		end

		container:AddButton({
			Title = "Reset all",
			Description = "everything back to default",
			Icon = "rotate-ccw",
			Cooldown = config.ResetCooldown or 3,
			Callback = function()
				Config:Reset()
				toast("Everything reset", "Warning")
			end,
		})

		handle.Name = name
		handle.List = list
		handle.Refresh = function()
			refresh(true)
		end
		return handle
	end

	return ConfigPanel
end
end)()

__modules["Services/KeybindPanel"] = (function()
return function(import)
	local Utility = import("Core/Utility")
	local Theme = import("Core/Theme")
	local Widgets = import("Core/Widgets")
	local Markup = import("Core/Markup")
	local Icons = import("Icons/Icon")
	local Input = import("Services/Input")
	local Animation = import("Services/Animation")

	local KeybindPanel = {}

	local function label(key)
		if typeof(key) ~= "EnumItem" or key == Enum.KeyCode.Unknown then
			return "unbound"
		end
		if key.EnumType == Enum.UserInputType then
			return "Mouse " .. string.gsub(key.Name, "MouseButton", "")
		end
		return key.Name
	end

	function KeybindPanel.Collect(window)
		local out = {}
		for id, component in window.Options do
			if component.Kind == "Keybind" and component.State then
				table.insert(out, {
					Id = id,
					Title = component:GetTitle(),
					Key = component.State:Get(),
					Mode = component.Mode,
					Component = component,
					Kind = "Keybind",
				})
			elseif component.BoundKey then
				table.insert(out, {
					Id = id,
					Title = component:GetTitle(),
					Key = component.BoundKey,
					Component = component,
					Kind = component.Kind,
				})
			end
		end
		table.sort(out, function(a, b)
			return string.lower(a.Title) < string.lower(b.Title)
		end)
		return out
	end

	function KeybindPanel.Build(container, config)
		config = config or {}
		Utility.Check(
			type(container) == "table" and container.Container,
			"KeybindPanel",
			"?",
			"Needs a tab, section or card."
		)
		local window = container.Window
		local cleanup = container.Cleanup:Extend()

		local frame = Widgets.Surface(cleanup, {
			Name = "Keybinds",
			Parent = container.Container,
			Fill = "SecondaryBackground",
			Transparency = "ComponentTransparency",
			Stroke = "Border",
			StrokeTransparency = "ComponentStrokeTransparency",
			Radius = 14,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.new(1, 0, 0, 0),
			LayoutOrder = container.NextOrder(),
		})
		cleanup:Add(frame)
		Widgets.Padding(frame, 12, 11)
		Widgets.List(frame, 7)

		local header = Utility.Create("Frame", {
			Name = "Header",
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 18),
			LayoutOrder = 1,
			Parent = frame,
		})
		local holder = Utility.Create("Frame", {
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0, 0, 0.5, 0),
			Size = UDim2.fromOffset(14, 14),
			Parent = header,
		})
		Icons.Create(holder, config.Icon or "keyboard", {
			Size = 14,
			Color = config.IconColor or "Accent",
			Cleanup = cleanup,
		})
		Widgets.Text(cleanup, {
			Parent = header,
			Text = config.Title or "Keybinds",
			Bold = true,
			Position = UDim2.fromOffset(21, 0),
			Size = UDim2.new(1, -60, 1, 0),
		})
		local _, count = Widgets.Text(cleanup, {
			Parent = header,
			Text = "0",
			Color = "MutedText",
			TextSize = 11,
			TextXAlignment = Enum.TextXAlignment.Right,
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.fromScale(1, 0),
			Size = UDim2.fromOffset(40, 18),
			Markup = false,
		})

		local body = Utility.Create("Frame", {
			Name = "Body",
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.new(1, 0, 0, 0),
			LayoutOrder = 2,
			Parent = frame,
		})
		Widgets.List(body, 4)

		local rows = cleanup:Extend()
		local handle = {}

		function handle:Refresh()
			rows:Clean()
			rows = cleanup:Extend()
			local entries = KeybindPanel.Collect(window)
			count.SetText(tostring(#entries))

			if #entries == 0 then
				rows:Add((Widgets.Text(rows, {
					Parent = body,
					Text = config.Empty or "no keys bound yet",
					Color = "MutedText",
					TextSize = 11,
					Size = UDim2.new(1, 0, 0, 24),
				})))
				return
			end

			for index, entry in entries do
				local row = Widgets.Surface(rows, {
					Class = "TextButton",
					Parent = body,
					Fill = "TertiaryBackground",
					Transparency = "ElementTransparency",
					Radius = 10,
					Size = UDim2.new(1, 0, 0, 30),
					LayoutOrder = index,
				})
				rows:Add(row)
				Widgets.Text(rows, {
					Parent = row,
					Text = Markup.Strip(entry.Title),
					TextSize = 12,
					Position = UDim2.fromOffset(11, 0),
					Size = UDim2.new(1, -108, 1, 0),
					TextTruncate = Enum.TextTruncate.AtEnd,
					Markup = false,
				})
				if entry.Mode and entry.Mode ~= "Press" then
					Widgets.Text(rows, {
						Parent = row,
						Text = entry.Mode,
						Color = "MutedText",
						TextSize = 10,
						TextXAlignment = Enum.TextXAlignment.Right,
						AnchorPoint = Vector2.new(1, 0.5),
						Position = UDim2.new(1, -78, 0.5, 0),
						Size = UDim2.fromOffset(44, 14),
						Markup = false,
					})
				end
				local chip = Widgets.Surface(rows, {
					Parent = row,
					Fill = "SecondaryBackground",
					Stroke = "Border",
					StrokeTransparency = 0.4,
					Radius = 8,
					AnchorPoint = Vector2.new(1, 0.5),
					Position = UDim2.new(1, -8, 0.5, 0),
					Size = UDim2.fromOffset(66, 20),
				})
				local _, keyText = Widgets.Text(rows, {
					Parent = chip,
					Text = label(entry.Key),
					Color = entry.Key and entry.Key ~= Enum.KeyCode.Unknown and "Text" or "MutedText",
					TextSize = 11,
					TextXAlignment = Enum.TextXAlignment.Center,
					Size = UDim2.fromScale(1, 1),
					TextTruncate = Enum.TextTruncate.AtEnd,
					Markup = false,
				})
				Widgets.Interactive(rows, row, row, { Base = "TertiaryBackground" })

				local capturing = false
				local function rebind()
					if capturing then
						return
					end
					capturing = true
					keyText.SetText("...")
					Widgets.Pulse(chip, 0.85, 0.3)
					local chipStroke = chip:FindFirstChildOfClass("UIStroke")
					Widgets.Glow(chipStroke, "Accent", 6)
					local cancel = Input.Capture(function(key, cancelled)
						capturing = false
						if cancelled then
							keyText.SetText(label(entry.Key))
							return
						end
						local chosen = key ~= Enum.KeyCode.Unknown and key or nil
						if entry.Kind == "Keybind" then
							entry.Component:SetValue(chosen or Enum.KeyCode.Unknown)
						else
							entry.Component:Bind(chosen)
						end
						handle:Refresh()
					end)
					rows:Add(cancel)
				end

				rows:Add(row.Activated:Connect(rebind))
				rows:Add(row.MouseButton2Click:Connect(function()
					if entry.Kind == "Keybind" then
						entry.Component:SetValue(Enum.KeyCode.Unknown)
					else
						entry.Component:Bind(nil)
					end
					handle:Refresh()
				end))
			end
		end

		Widgets.Text(cleanup, {
			Parent = frame,
			Text = "<fade:0.4>click to rebind, right click to clear</fade>",
			Color = "MutedText",
			TextSize = 10,
			Size = UDim2.new(1, 0, 0, 12),
			LayoutOrder = 3,
		})

		handle:Refresh()
		handle.Frame = frame
		function handle:Destroy()
			cleanup:Clean()
		end
		return handle
	end

	return KeybindPanel
end
end)()

__modules["Icons/Catalog"] = (function()
return [[a-arrow-down=87834851353233;a-arrow-up=89385437396694;a-large-small=73183249747960;accessibility=109960743825561;activity=137527339160230;activity-square=126953951117387;air-vent=111625153433818;airplay=92171397431531;alarm-check=130501077167542;alarm-clock=118636480109240;alarm-clock-check=70976944787280;alarm-clock-minus=70856300954858;alarm-clock-off=110132709107464;alarm-clock-plus=96736786697131;alarm-minus=77271404005062;alarm-plus=128528043300240;alarm-smoke=76581519928624;album=112445622428637;alert-circle=74115333842618;alert-octagon=138910404523272;alert-triangle=112102474509324;align-center=120408521883501;align-center-horizontal=108597166812858;align-center-vertical=121154206034694;align-end-horizontal=99069601868832;align-end-vertical=117942349521535;align-horizontal-distribute-center=77482483036009;align-horizontal-distribute-end=134639979863642;align-horizontal-distribute-start=134435692726811;align-horizontal-justify-center=92390581039957;align-horizontal-justify-end=104340168067575;align-horizontal-justify-start=78939447794797;align-horizontal-space-around=80515421591545;align-horizontal-space-between=114038806348167;align-justify=92373371786861;align-left=136554315335959;align-right=135067010612236;align-start-horizontal=96834758740744;align-start-vertical=123458513293976;align-vertical-distribute-center=90818078154247;align-vertical-distribute-end=136782098795781;align-vertical-distribute-start=134480830300767;align-vertical-justify-center=130298876730417;align-vertical-justify-end=100777246465864;align-vertical-justify-start=123693071723398;align-vertical-space-around=124225977511288;align-vertical-space-between=81499787439793;ambulance=103392162911629;ampersand=76900943277226;ampersands=86469233094518;anchor=127378493192461;angry=79345553086407;annoyed=104846682265434;antenna=112766612909532;anvil=86432599455606;aperture=139684165362622;app-window=87635787215081;app-window-mac=108549782746996;apple=93203750625654;archive=137249944163344;archive-restore=96820254661076;archive-x=134784309661522;area-chart=107486186614989;armchair=104852764227195;arrow-big-down=134387593103194;arrow-big-down-dash=125189777214718;arrow-big-left=79012356613282;arrow-big-left-dash=132879301629314;arrow-big-right=90405262165720;arrow-big-right-dash=121488142481379;arrow-big-up=95689861013321;arrow-big-up-dash=106976910180035;arrow-down=134161790366779;arrow-down-0-1=140381370510884;arrow-down-1-0=130494621181478;arrow-down-a-z=103554859233661;arrow-down-circle=131404694292521;arrow-down-from-line=81443516391691;arrow-down-left=102509297349411;arrow-down-left-from-circle=73012719459961;arrow-down-left-square=90976696713068;arrow-down-narrow-wide=71046418862578;arrow-down-right=72764732196403;arrow-down-right-from-circle=97668995487103;arrow-down-right-square=128499661363473;arrow-down-square=138838216140198;arrow-down-to-dot=88868273845458;arrow-down-to-line=137644743820952;arrow-down-up=117405374619280;arrow-down-wide-narrow=75826372885867;arrow-down-z-a=118359795316087;arrow-left=90293255250749;arrow-left-circle=130847257582775;arrow-left-from-line=77381869318221;arrow-left-right=112517617090898;arrow-left-square=135104418905606;arrow-left-to-line=130252021035812;arrow-right=134908902120212;arrow-right-circle=94365145580321;arrow-right-from-line=107378199607331;arrow-right-left=111890422557630;arrow-right-square=115337431423227;arrow-right-to-line=103829994761864;arrow-up=104406213770080;arrow-up-0-1=139178256421912;arrow-up-1-0=97298977768167;arrow-up-a-z=97443044644659;arrow-up-circle=75833692771331;arrow-up-down=73746166761985;arrow-up-from-dot=103317134268223;arrow-up-from-line=101711387260955;arrow-up-left=103783370700580;arrow-up-left-from-circle=96382098119619;arrow-up-left-square=101543880954604;arrow-up-narrow-wide=122289869517959;arrow-up-right=115214649052675;arrow-up-right-from-circle=102906718956851;arrow-up-right-square=113196521639031;arrow-up-square=112280252781879;arrow-up-to-line=135365442561417;arrow-up-wide-narrow=79052928363256;arrow-up-z-a=93443333447390;arrows-up-from-line=140178313470659;asterisk=107247711733329;at-sign=94614469252449;atom=119051552929078;audio-lines=133487746892141;audio-waveform=135412900878575;award=82039875682356;axe=84931585672806;axis-3d=83328523632480;baby=75683742350958;backpack=76143965140765;badge=78791133479661;badge-alert=92904571921902;badge-cent=110902979965426;badge-check=76305757263548;badge-dollar-sign=123225256208806;badge-euro=82107326159074;badge-help=83944903318576;badge-indian-rupee=105958255216505;badge-info=109792483526167;badge-japanese-yen=96156476341857;badge-minus=79191240000290;badge-percent=129993801535784;badge-plus=73308743105191;badge-pound-sterling=104904198937382;badge-russian-ruble=91738909980749;badge-swiss-franc=102826901242684;badge-x=117187082865205;baggage-claim=119346910227968;ban=109685306480139;banana=128374499714074;banknote=113703117675594;bar-chart=121570259716677;bar-chart-2=121452498735866;bar-chart-3=130626786024244;bar-chart-4=96221317327213;bar-chart-big=119295298711810;bar-chart-horizontal=109235174327898;bar-chart-horizontal-big=139737497124066;barcode=78580529416152;baseline=116347038683714;bath=89008182357290;battery=102599812606554;battery-charging=91402957855599;battery-full=108407180588179;battery-low=132416805088817;battery-medium=139407584675024;battery-warning=119084304752903;beaker=100026072450383;bean=108654318985558;bean-off=75755103997845;bed=71982795501399;bed-double=97693190540435;bed-single=80557330573152;beef=93001452038647;beer=71718925718592;beer-off=135309228180602;bell=84691420588185;bell-dot=100564215426004;bell-electric=120584905231603;bell-minus=117849268875449;bell-off=115540031372596;bell-plus=85655293455454;bell-ring=71006419366158;between-horizontal-end=97454674221809;between-horizontal-start=122308710081740;between-vertical-end=73288142609772;between-vertical-start=96319480553759;bike=139392597724277;binary=73887562333653;biohazard=137351193301090;bird=78301366757596;bitcoin=87905951788220;blend=99774242136996;blinds=97128563480198;blocks=116361302503360;bluetooth=140648462080543;bluetooth-connected=108047104997672;bluetooth-off=85384277884353;bluetooth-searching=88887842293685;bold=114571598098097;bolt=134172358414310;bomb=85112456002145;bone=110911138031483;book=74111869099427;book-a=130683776374615;book-audio=84765914852101;book-check=116693733550590;book-copy=103556293898971;book-dashed=90144560974060;book-down=102612840928328;book-headphones=101847018803943;book-heart=79225550955168;book-image=97175021450327;book-key=78825638323167;book-lock=136914298397858;book-marked=130311722822005;book-minus=111140800790677;book-open=84762150530577;book-open-check=100175521109916;book-open-text=83251408532985;book-plus=135397977794739;book-text=96481772943887;book-type=80135728169729;book-up=92592832226795;book-up-2=74123009075829;book-user=80586093636888;book-x=75485266769989;bookmark=137439152875860;bookmark-check=103743627936816;bookmark-minus=106761186502279;bookmark-plus=108572239011289;bookmark-x=115354177404954;boom-box=88874304172044;bot=70979486241131;bot-message-square=79709292282995;box=117371753006597;box-select=106969329058115;boxes=95055252135506;braces=92263187057993;brackets=87406077670628;brain=116902501990569;brain-circuit=130830898675113;brain-cog=76347059769903;brick-wall=94677898150825;briefcase=78701740878808;briefcase-business=83989706459460;briefcase-medical=101696204417639;bring-to-front=105016868447258;brush=113475652218451;bug=75649814233484;bug-off=72963988065933;bug-play=109066688101101;building=128630485814878;building-2=97744948701888;bus=115040051931434;bus-front=89834398235413;cable=122718774070506;cable-car=75378206085314;cake=88535465840262;cake-slice=99501344714989;calculator=107281102048400;calendar=126460151885084;calendar-check=116665691227418;calendar-check-2=128139765113287;calendar-clock=91678408267921;calendar-days=83005303274935;calendar-fold=120622111767156;calendar-heart=101728896191412;calendar-minus=97111317408323;calendar-minus-2=114139960753026;calendar-off=72690038281381;calendar-plus=113126930241503;calendar-plus-2=95708816339251;calendar-range=85814519406070;calendar-search=94105486063910;calendar-x=117555084312063;calendar-x-2=137455674513711;camera=114084146151777;camera-off=101456706369049;candlestick-chart=99842864833044;candy=113164012451432;candy-cane=125416183674924;candy-off=122702931937344;captions=105023593632540;captions-off=75480095441780;car=91451724283877;car-front=79993076477613;car-taxi-front=75623233937291;caravan=78521421981947;carrot=71122235024925;case-lower=95359311197985;case-sensitive=133603526051277;case-upper=77340278207531;cassette-tape=113140472253110;cast=119573692041871;castle=104598700669384;cat=118339348494810;cctv=84978679477516;check=86817768619372;check-check=101885204738917;check-circle=105979545056636;check-circle-2=76928915955542;check-square=135686334400788;check-square-2=84113739446686;chef-hat=94153362248387;cherry=116326418543667;chevron-down=71457658246709;chevron-down-circle=130642617728982;chevron-down-square=84683053234548;chevron-first=70831710633364;chevron-last=102556054621077;chevron-left=102314312897830;chevron-left-circle=70732746220332;chevron-left-square=78492542000164;chevron-right=101007429951147;chevron-right-circle=87038574131735;chevron-right-square=119136642030742;chevron-up=98648581502859;chevron-up-circle=111681831848531;chevrons-down=84492998086101;chevrons-down-up=82103880591342;chevrons-left=87881912126351;chevrons-left-right=132331219761704;chevrons-right=134353805354361;chevrons-right-left=96783734429291;chevrons-up=88461690106632;chevrons-up-down=71880540200693;circle-arrow-down=129076838165145;circle-arrow-left=88796613571531;circle-arrow-out-down-left=107231337431973;circle-arrow-out-down-right=70490689174861;circle-arrow-out-up-left=79479678307645;circle-arrow-out-up-right=127093834620465;circle-arrow-right=97664127355280;circle-arrow-up=72634350793509;circle-check=88244323237265;circle-check-big=105847305799404;circle-chevron-down=88531529614731;circle-chevron-left=109806050128867;circle-chevron-right=130159833971034;circle-chevron-up=126990996679640;circle-dashed=122032109800866;circle-divide=136980096833105;circle-dollar-sign=102720278203768;circle-dot=122878673716704;circle-dot-dashed=107222591318022;circle-ellipsis=72989868902667;circle-equal=83415595687523;circle-fading-plus=97734885169321;circle-gauge=79712667314679;circle-help=132353516577418;circle-minus=98163850412523;circle-off=95467094528299;circle-parking=117482323268433;circle-parking-off=80459013698184;circle-pause=88794740338426;circle-percent=125429815212970;circle-play=84481789029543;circle-plus=117262167984222;circle-power=127349877206105;circle-slash=98431785453122;circle-slash-2=79541029224240;circle-stop=109423106908446;circle-user=87167719100614;circle-user-round=113831490904568;circle-x=106305483906363;circuit-board=124136951218642;citrus=79624448772527;clapperboard=132343838416956;clipboard=105021692319787;clipboard-check=90432969741774;clipboard-copy=85387882337161;clipboard-edit=131193135046966;clipboard-list=129402512748462;clipboard-minus=94779294031183;clipboard-paste=79192963603923;clipboard-pen=99195778697194;clipboard-pen-line=103555830963651;clipboard-plus=74352366953056;clipboard-signature=120750772696869;clipboard-type=132835545998943;clipboard-x=132658738057667;clock=136533241128438;clock-1=71498600757409;clock-10=123641121766955;clock-11=85845500811663;clock-12=133878455420257;clock-2=102975079908275;clock-3=119663119982527;clock-4=108792000100666;clock-5=97840714155038;clock-6=102025123837297;clock-7=110824271252901;clock-8=123515589399454;clock-9=126662391246112;cloud=136524873450824;cloud-cog=108438517119798;cloud-download=78768373704516;cloud-drizzle=80789072164434;cloud-fog=110403642693501;cloud-hail=95998880244047;cloud-lightning=118391347029403;cloud-moon=120156057895579;cloud-moon-rain=101513348432910;cloud-off=111796785870393;cloud-rain=130177212410873;cloud-rain-wind=87893934921731;cloud-snow=104971371973617;cloud-sun=140109651313859;cloud-sun-rain=132138781511885;cloud-upload=86452290950086;cloudy=132267475821363;clover=128291338532394;club=83110975306436;code=75851496262862;code-2=79541605299928;code-xml=106124864132557;codepen=131077252082543;codesandbox=139298967633423;coffee=125329933348791;cog=123222732420633;coins=117341212186115;columns=96838631255058;columns-2=110924811097991;columns-3=88214025452433;columns-4=100379574150921;combine=103133480717944;command=90385430770591;compass=73836660434977;component=106556990975641;computer=72888027377165;concierge-bell=134373387272639;cone=80255197365555;construction=77845797691565;contact=102372888309353;contact-2=100454539997812;contact-round=117599766367773;container=135116917100753;contrast=71154426791470;cookie=96083862569395;cooking-pot=100393801714299;copy=116378866141355;copy-check=92397569046734;copy-minus=75815893695780;copy-plus=138173295478363;copy-slash=74395410823283;copy-x=98741265066436;copyleft=103019482632984;copyright=82044483134605;corner-down-left=105689000447775;corner-down-right=82061714010896;corner-left-down=133517193053100;corner-left-up=78035789940893;corner-right-down=135390474501786;corner-right-up=122661540167291;corner-up-left=72973602941956;corner-up-right=108297458644964;cpu=105237370909681;creative-commons=111243376462256;credit-card=124946887228472;croissant=77683374738482;crop=121481502611712;cross=93673591064028;crosshair=83752373575368;crown=92253403464658;cuboid=117329818290748;cup-soda=132120247880161;currency=96706001818192;cylinder=99158693669056;database=99154172590159;diamond=136889727768904;diamond-percent=138695404542126;dice-1=133629376866649;dice-2=137517882571271;dice-3=128612626459042;dice-4=73117400593570;dice-5=107643287892749;dice-6=112067139297943;dices=116678154854810;diff=122850860032588;disc=77318106935130;disc-2=135460247355994;disc-3=118087373340436;disc-album=101298984360789;divide=134571770296218;divide-circle=115849848955050;divide-square=78617148972524;dna=131581201333424;dna-off=90101733367858;dock=96133720652582;dog=123749328846346;dollar-sign=74567340201672;donut=123909563150383;door-closed=118483980594708;door-open=124230332524625;dot=105006331197983;download=109698732019071;download-cloud=122841052352556;drafting-compass=110585086142082;drama=138828515077300;dribbble=112906380564504;drill=113833078477512;droplet=91586468475195;droplets=117720354071548;drum=121019656655547;drumstick=106711459328737;dumbbell=130873531670678;ear=92631431780796;ear-off=81480882487332;earth=75025349205767;earth-lock=103673515494330;eclipse=113566298471092;egg=103880404435578;egg-fried=137654273789326;egg-off=99146230558760;ellipsis=95127553964880;ellipsis-vertical=95771045694204;equal=79273099065269;eraser=71210100060694;euro=139202392240827;expand=107643532357936;external-link=78664150174274;eye=127234874352422;eye-off=85207295981701;facebook=98822363427090;factory=79319339232812;fan=76323281744636;fast-forward=131011550754955;feather=103991922506350;fence=90935998613863;ferris-wheel=94538249337586;figma=103020132259719;file=108499043987115;file-archive=78133118745021;file-audio=101306436065858;file-audio-2=103353018363480;file-axis-3d=136107008496948;file-badge=135829024450190;file-badge-2=87916835926622;file-bar-chart=92900624303400;file-bar-chart-2=133337118425916;file-box=102441183584476;file-check=91719007832323;file-check-2=120611252466724;file-clock=101240345040794;file-code=93918366472395;file-code-2=77999709917415;file-cog=130835463141181;file-diff=132890714271689;file-digit=108016195781167;file-down=79495546108963;file-edit=82156880342025;file-heart=138364329637312;file-image=83675710276234;file-input=78561929224193;file-json=98868866618869;file-json-2=92610524789574;file-key=83249504215614;file-key-2=103006369640378;file-line-chart=84182680444173;file-lock=140186307068344;file-lock-2=126656887901996;file-minus=138371877961417;file-minus-2=107551117550330;file-music=107180630571772;file-output=109566424197143;file-pen=134577965177665;file-pen-line=90852962587361;file-pie-chart=94554256943610;file-plus=74194167957081;file-plus-2=111571245681686;file-question=128415338385227;file-scan=132590981389921;file-search=131130928074464;file-search-2=139930116408040;file-signature=87096324580559;file-sliders=133181135528313;file-spreadsheet=117808207510717;file-stack=132187715148899;file-symlink=122206323516270;file-terminal=91847143440556;file-text=92774566080911;file-type=139551268989315;file-type-2=91173675777316;file-up=99191463679083;file-video=105252283775469;file-video-2=130213998083954;file-volume=119603558694315;file-volume-2=139949156797892;file-warning=89824347717079;file-x=117124390222574;file-x-2=136449417648465;files=78685849153126;film=120941801045330;filter=100930784445785;filter-x=85838104400923;fingerprint=109514257830136;fire-extinguisher=84862159260845;fish=114555142566431;fish-off=99443044829026;fish-symbol=123702927226939;flag=121835250831612;flag-off=90046025355940;flag-triangle-left=73117581559482;flag-triangle-right=106524126597496;flame=125012650497883;flame-kindling=136834319064926;flashlight=110881718712443;flashlight-off=117038550056668;flask-conical=115528123394259;flask-conical-off=102385597737770;flask-round=118701306736141;flip-horizontal=76347241876815;flip-horizontal-2=107329750779249;flip-vertical=121575310281690;flip-vertical-2=77578710261033;flower=98459040977090;flower-2=79478214327919;focus=116191961683883;fold-horizontal=133102230855922;fold-vertical=128556601978376;folder=77937190465422;folder-archive=96956679126324;folder-check=95477621394824;folder-clock=137926892639070;folder-closed=86427718056887;folder-cog=127866486547434;folder-dot=129773010201383;folder-down=82793534945672;folder-edit=102495189191583;folder-git=104507928948019;folder-git-2=85014883332248;folder-heart=110088173047332;folder-input=132837435930621;folder-kanban=138103158509024;folder-key=130401922270021;folder-lock=111493727654155;folder-minus=97790081587083;folder-open=112237915867403;folder-open-dot=90332268376865;folder-output=125946013402264;folder-pen=81838874164795;folder-plus=71462957431660;folder-root=80403663819762;folder-search=109602276944932;folder-search-2=74614286288240;folder-symlink=89907141903257;folder-sync=137088423628527;folder-tree=78199416535568;folder-up=85416900334449;folder-x=103887939759350;folders=97828544806816;footprints=80792036653047;forklift=117529645336183;form-input=73368443063193;forward=78301309129142;frame=81913255681858;framer=117525065607897;frown=88589722723911;fuel=112915457104961;fullscreen=92176335589571;function-square=77009803117016;gallery-horizontal=113964455804231;gallery-horizontal-end=125589356860308;gallery-thumbnails=123093292028306;gallery-vertical=109130466006021;gallery-vertical-end=122352399696695;gamepad=81482768981191;gamepad-2=99293705721130;gantt-chart=122456724985241;gantt-chart-square=73571197135748;gauge=128279962545721;gauge-circle=110231832967256;gavel=118993398179839;gem=125353572203968;ghost=132705178126217;gift=87706885156127;git-branch=101518089376526;git-branch-plus=127909649257701;git-commit-horizontal=91306319670540;git-commit-vertical=101185915909200;git-compare=134611228556653;git-compare-arrows=134203912676625;git-fork=138214272765755;git-graph=126789259203618;git-merge=118868315103570;git-pull-request=117991178843732;git-pull-request-arrow=133155768650667;git-pull-request-closed=74188383635944;git-pull-request-create=108540858735398;git-pull-request-create-arrow=75317536980451;git-pull-request-draft=127220095778670;github=140138081031269;gitlab=109316577965403;glass-water=125170765146614;glasses=77027406085123;globe=125685532120024;globe-2=112945472486319;globe-lock=96469366281710;goal=90015442702200;grab=117741873625250;graduation-cap=140187510907091;grape=73195418744413;grid-2x2=134599229810680;grid-3x3=108197747587523;grip=88188569450143;grip-horizontal=72027364608348;grip-vertical=136050395759142;group=79946652686375;guitar=135654565391445;ham=134057117057030;hammer=73956316105509;hand=83088528355903;hand-coins=85922324710029;hand-heart=124155721578457;hand-helping=95094264299544;hand-metal=105555696144202;hand-platter=101356141176839;handshake=121760224402586;hard-drive=115211376876196;hard-drive-download=115854711953657;hard-drive-upload=112990104477043;hard-hat=105207891316460;hash=128945191245705;haze=86624380139587;hdmi-port=123935181216786;heading=115666667306834;heading-1=82056941503516;heading-2=109194333144049;heading-3=86456694536830;heading-4=108808532352504;heading-5=84468448396475;heading-6=70885434512827;headphones=89990513082092;headset=77155289443816;heart=88525382655929;heart-crack=78532998725036;heart-handshake=88807882205984;heart-off=121500734414824;heart-pulse=101116623654468;heater=75867015789217;help-circle=71693802872044;helping-hand=82838882533396;hexagon=111932983587355;highlighter=124195908160173;history=70375455140492;home=109841253338329;hop=87886892027508;hop-off=124047203843704;hospital=100542468114469;hotel=88463240253197;hourglass=135654740495171;ice-cream=95314536020685;ice-cream-2=93935347717656;ice-cream-bowl=116507918255217;ice-cream-cone=72823870951577;image=114022611279795;image-down=91697762317652;image-minus=111691180013117;image-off=113890586559666;image-plus=131640557457656;image-up=95362531246536;images=87539822715105;import=87776530532335;inbox=131993988107472;indent=111431763044113;indent-decrease=77902371540680;indent-increase=116043459584133;indian-rupee=121515804799242;infinity=77975814002740;info=120620848266512;inspection-panel=93487140703578;instagram=88504800931130;italic=96844815325902;iteration-ccw=114475186061127;iteration-cw=130833288197698;japanese-yen=108845518454015;joystick=75024649968329;kanban=132557744047883;kanban-square=124564901729634;kanban-square-dashed=134205902924289;key=83474888140571;key-round=116918931002434;key-square=79693131186843;keyboard=121978468376124;keyboard-music=74763240290099;lamp=123765123149989;lamp-ceiling=120174084956571;lamp-desk=125995036157694;lamp-floor=102217348025530;lamp-wall-down=134067530649420;lamp-wall-up=101034120941267;land-plot=114974071140535;landmark=130189940998950;languages=130065428637597;laptop=103798905446648;laptop-2=106021728338003;laptop-minimal=91920768368168;lasso=110262485516329;lasso-select=112600066891219;laugh=115974660887808;layers=114499998778667;layers-2=87219208863328;layers-3=114549653986465;layout=75056433029964;layout-dashboard=70433574792490;layout-grid=89644754139307;layout-list=72384664085473;layout-panel-left=117264898598467;layout-panel-top=135570881026156;layout-template=78078135578383;leaf=70846801126940;leafy-green=94770162749325;library=114050057679028;library-big=135791941822287;library-square=132158761398954;life-buoy=99147024142900;ligature=75804099923602;lightbulb=98419938500979;lightbulb-off=126746194476977;line-chart=115214641333880;link=86131768436965;link-2=107339085791087;link-2-off=74994782779018;linkedin=102928864661994;list=101699539545687;list-checks=133109875194066;list-collapse=103651151660786;list-end=116487672075047;list-filter=83186010624431;list-minus=119184210915074;list-music=88988800995482;list-ordered=100068475590931;list-plus=124010335412192;list-restart=91193864293753;list-start=131366235513143;list-todo=83287488939815;list-tree=127759805921507;list-video=117978552190904;list-x=115746075160943;loader=132295854994374;loader-2=128780061297692;loader-circle=71250150569964;locate=106821189831430;locate-fixed=80648116191645;locate-off=121088730454886;lock=119765975153029;lock-keyhole=135504457058301;lock-keyhole-open=132192657766903;lock-open=71186154315213;log-in=82241120685313;log-out=140299936053191;lollipop=102239398934579;luggage=140614046877100;m-square=97856747717836;magnet=97474941633274;mail=77537514051485;mail-check=90824179551389;mail-minus=104189493909738;mail-open=74874447671108;mail-plus=130540869833539;mail-question=128924135790205;mail-search=108269769085404;mail-warning=126275145590627;mail-x=97229750262408;mailbox=104064071799815;mails=120925930542398;map=131325044235094;map-pin=137091405832737;map-pin-off=130126969919710;map-pinned=78894827751778;martini=108853683970464;maximize=116546384863431;maximize-2=130049637400171;medal=97534791863003;megaphone=139746713205639;megaphone-off=130364738220291;meh=117127044934876;memory-stick=82464660673318;menu=83047518441184;menu-square=84168857053009;merge=96640473379848;message-circle=74163263000218;message-circle-code=124462142601421;message-circle-dashed=78559601215727;message-circle-heart=122100978068245;message-circle-more=72969556529414;message-circle-off=106640802525475;message-circle-plus=97202853233666;message-circle-question=85003442346058;message-circle-reply=96024981688039;message-circle-warning=112239075926369;message-circle-x=104081317224904;message-square=86432989388834;message-square-code=139338315973052;message-square-dashed=127422492651127;message-square-diff=120745701209397;message-square-dot=131246995114947;message-square-heart=137436561363370;message-square-more=76812000893936;message-square-off=97376166485199;message-square-plus=77957118386462;message-square-quote=97203851012575;message-square-reply=138540430807955;message-square-share=94526690702300;message-square-text=128095657789286;message-square-warning=83694786088101;message-square-x=83972010967159;messages-square=112345482432498;mic=125870172276779;mic-2=79774423165436;mic-off=84064988822624;mic-vocal=116345765074785;microscope=134078584568005;microwave=109575331253451;milestone=88614752388873;milk=119818923307142;milk-off=72925919409773;minimize=95555494586098;minimize-2=96294437144715;minus=95070996149109;minus-circle=103303552772654;minus-square=96983863580751;monitor=70520152532392;monitor-check=112341875921743;monitor-dot=132673547251589;monitor-down=132502390896673;monitor-off=95048101284680;monitor-pause=99458637542686;monitor-play=107640137618506;monitor-smartphone=81757216234228;monitor-speaker=131099454095944;monitor-stop=99235976282671;monitor-up=116018518624879;monitor-x=102604336229610;moon=98353636264918;moon-star=137086737657962;more-horizontal=101330725759187;more-vertical=76302166494262;mountain=90592200130155;mountain-snow=111710418991773;mouse=122014945028597;mouse-pointer=113428527051320;mouse-pointer-2=84070353881242;mouse-pointer-click=81854854241463;mouse-pointer-square=112337311970951;mouse-pointer-square-dashed=80677641664079;move=77028714324861;move-3d=82487420092874;move-diagonal=111179404262244;move-diagonal-2=128492050787735;move-down=85099736811132;move-down-left=138054515129112;move-down-right=116621809745618;move-horizontal=136107424781093;move-left=89444723083105;move-right=133586722586273;move-up=76410952730524;move-up-left=102293680652367;move-up-right=88087592569369;move-vertical=92087242547029;music=132132095360900;music-2=121112248614371;music-3=75731760539974;music-4=122935411241955;navigation=76549947719521;navigation-2=127270865325663;navigation-2-off=74005663669130;navigation-off=96787422854853;network=110230147673946;newspaper=115179113478597;nfc=119131457808272;notebook=93996170225525;notebook-pen=70494109504383;notebook-tabs=113749031276097;notebook-text=86811328922423;notepad-text=104957079697866;notepad-text-dashed=113624610966525;nut=77621843968987;nut-off=84877157781266;octagon=103646759535962;octagon-alert=101226496664732;octagon-pause=127095623629829;octagon-x=103912968479362;option=77581357923982;orbit=79200159961573;outdent=136657573552804;package=106101842173393;package-2=76736374924338;package-check=100671298334773;package-minus=72114807005321;package-open=86470175749466;package-plus=74357376952178;package-search=108965513580143;package-x=80178189812476;paint-bucket=116536780343642;paint-roller=76545833297923;paintbrush=113234034461805;paintbrush-2=116925836096427;palette=127369887384101;palmtree=85651135388680;panel-bottom=86537618399617;panel-bottom-close=91281796987492;panel-bottom-dashed=130167117027190;panel-bottom-inactive=97483023786802;panel-bottom-open=86549932703136;panel-left=125599129725759;panel-left-close=106532774300164;panel-left-dashed=115976249358122;panel-left-inactive=102689057283340;panel-left-open=126704485649345;panel-right=83386566029978;panel-right-close=133236216519470;panel-right-dashed=138321632890167;panel-right-inactive=95197732140314;panel-right-open=107436518875633;panel-top=80001561556081;panel-top-close=124467779594157;panel-top-dashed=79452019243803;panel-top-inactive=135806161551683;panel-top-open=88468571469051;panels-left-bottom=100709335124708;panels-right-bottom=118563843738058;panels-top-left=119230493302275;paperclip=101144735754292;parentheses=117743859847736;parking-circle=132958171449207;parking-circle-off=90293787674695;parking-meter=95540023655686;parking-square=119709845027214;parking-square-off=111516007201199;party-popper=92886643958723;pause=79610666871575;pause-circle=121009275520669;pause-octagon=75691149975017;paw-print=97578437331341;pc-case=134071343822649;pen=101486948449510;pen-line=108991407462745;pen-square=124290018373176;pen-tool=126917951709518;pencil=113132794872298;pencil-line=97622550721067;pencil-ruler=83914055949508;pentagon=133006808893408;percent=138143948353522;percent-circle=120133426400204;percent-diamond=116484660741674;percent-square=123104718284792;person-standing=101118444346965;phone=110402416146068;phone-call=83844308787978;phone-forwarded=121647613341736;phone-incoming=80024725665109;phone-missed=79555645036339;phone-off=124218610436691;phone-outgoing=107942094735434;pi=94324814221349;pi-square=104995627137456;piano=119387553084830;pickaxe=111300940329486;picture-in-picture=131356651374909;picture-in-picture-2=82685697007608;pie-chart=102602815840153;piggy-bank=137519559090410;pilcrow=73426591830540;pilcrow-square=104294263901485;pill=102063979166015;pin=84152083728286;pin-off=79775551915820;pipette=104047428948587;pizza=137422469806542;plane=123931033451986;plane-landing=127564654216931;plane-takeoff=71424495151201;play=76386816441302;play-circle=94679908148591;play-square=88949301532557;plug=92495517782055;plug-2=90278231790155;plug-zap=120081085677067;plug-zap-2=114634662672913;plus=101123124881873;plus-circle=120968869021626;plus-square=110356023190006;pocket=84604104357709;pocket-knife=75327579226876;podcast=107827753005302;pointer=98931495397575;pointer-off=121208450103912;popcorn=131831744800890;popsicle=104185203372496;pound-sterling=104324833143828;power=89331085993646;power-circle=116376776686511;power-off=71082730746769;power-square=119684962977179;presentation=116401163910084;printer=71465784501775;projector=73231680903652;proportions=78144579158638;puzzle=117598556369229;pyramid=132485249599747;qr-code=113440393569209;quote=131322529504476;rabbit=114280087699339;radar=132868138496209;radiation=100877813176471;radical=108409175619446;radio=99420757373028;radio-receiver=121282639721016;radio-tower=88833838205757;radius=74995747675698;rail-symbol=97316226200213;rainbow=103765621191575;rat=87357329634876;ratio=93282099315884;receipt=92008292109070;receipt-cent=112492211580771;receipt-euro=133191175020669;receipt-indian-rupee=133266746153788;receipt-japanese-yen=124042872765776;receipt-pound-sterling=100101322122623;receipt-russian-ruble=121506664677675;receipt-swiss-franc=99002246681862;receipt-text=100006409297382;rectangle-ellipsis=107119201863591;rectangle-horizontal=138840515431449;rectangle-vertical=105899574411289;recycle=113939163175897;redo=109330889951617;redo-2=139377644547969;redo-dot=103006780441917;refresh-ccw=112330254035751;refresh-ccw-dot=82338761134697;refresh-cw=106497040962250;refresh-cw-off=70915551154203;refrigerator=112780018998815;regex=134026857287988;remove-formatting=138608399804923;repeat=88751041821881;repeat-1=83172378763568;repeat-2=103267027937654;replace=107047557421203;replace-all=100838712445846;reply=92729212112550;reply-all=89383445888953;rewind=112118266859844;ribbon=138074895056157;rocket=109537053598807;rocking-chair=78801538856684;roller-coaster=97027135474963;rotate-3d=97818595741565;rotate-ccw=75086444429266;rotate-ccw-square=109860100695153;rotate-cw=83145058297547;rotate-cw-square=125618900116298;route=92054788599928;route-off=84281383994516;router=137822323057124;rows=137919453076186;rows-2=95783038014917;rows-3=120887473789104;rows-4=116714271746099;rss=133733106949535;ruler=84633402845324;russian-ruble=126835196314974;sailboat=95990070790702;salad=126822773594847;sandwich=125331738014611;satellite=76405829153460;satellite-dish=80919601328215;save=122894934359450;save-all=130108174247404;scale=104058148891720;scale-3d=98514591753294;scaling=101030566996452;scan=125367266780285;scan-barcode=97414347978098;scan-eye=109514269737059;scan-face=98379048258175;scan-line=74491678843147;scan-search=133304136560518;scan-text=135056446730766;scatter-chart=74267179296978;school=127958337382355;school-2=85807427737192;scissors=105992192896067;scissors-line-dashed=136613376152055;scissors-square=74695197837525;scissors-square-dashed-bottom=107920465612561;screen-share=77511025094385;screen-share-off=121685614490746;scroll=120140373437385;scroll-text=93551675076113;search=72296609649861;search-check=135876289053244;search-code=96217854889522;search-slash=103651057689299;search-x=107116182495739;send=94849431195865;send-horizontal=71350661970492;send-to-back=128357510439179;separator-horizontal=138451510103519;separator-vertical=136594330269338;server=105706502741449;server-cog=100022312079887;server-crash=87758222542375;server-off=80255747106695;settings=106205298246017;settings-2=109485777305919;shapes=72318824907864;share=78225483239202;share-2=139712792470775;sheet=74805372511449;shell=103995324275618;shield=106509993556171;shield-alert=91754324662625;shield-ban=124352578023288;shield-check=71867984579031;shield-ellipsis=93065391097116;shield-half=123735656472960;shield-minus=80388855203128;shield-off=98525250043109;shield-plus=121205118266112;shield-question=114815120818758;shield-x=75826463279777;ship=98574156558498;ship-wheel=130141263234416;shirt=128162112866809;shopping-bag=121389568871142;shopping-basket=110161824939086;shopping-cart=79435149356304;shovel=96637119542790;shower-head=114908638980660;shrink=115135316516120;shrub=79864992147519;shuffle=103735725549548;sigma=74383416855806;sigma-square=132360260153111;signal=126197135689656;signal-high=93347669262895;signal-low=84665611291998;signal-medium=75062813653519;signal-zero=109850227743382;signpost=97962937781200;signpost-big=87216549939239;siren=81845882921662;skip-back=137660494219613;skip-forward=121822124041513;skull=101060850237115;slack=107723459729315;slash=77878973734361;slice=140518011325498;sliders=105166722651208;sliders-horizontal=125396339381135;sliders-vertical=75780544616650;smartphone=74962751233767;smartphone-charging=86644420255103;smartphone-nfc=121578015636822;smile=129431925610335;smile-plus=83315367165388;snail=104438747965017;snowflake=70879271596915;sofa=87577807512220;soup=123867447658880;space=86056382889566;spade=121221766194945;sparkle=83114431765537;sparkles=105634041692696;speaker=117894179084666;speech=86788645272110;spell-check=139048235918692;spell-check-2=77691901804556;spline=127621289965723;split=124184087776521;split-square-horizontal=71187946462875;split-square-vertical=77254227779817;spray-can=97652569554326;sprout=100976494216154;square=135105418501265;square-activity=123457120309378;square-arrow-down=116832660638208;square-arrow-down-left=90743878595626;square-arrow-down-right=111115470362134;square-arrow-left=118414350090559;square-arrow-out-down-left=118423572451505;square-arrow-out-down-right=82860326458804;square-arrow-out-up-left=107517171610982;square-arrow-out-up-right=96480170164917;square-arrow-right=137471464720012;square-arrow-up=130005030476582;square-arrow-up-left=103366812234876;square-arrow-up-right=80186154045078;square-asterisk=85576779554554;square-bottom-dashed-scissors=105977668655594;square-check=122631573561562;square-check-big=139404784607168;square-chevron-down=120680078209607;square-chevron-left=75397936728579;square-chevron-right=76189118488226;square-chevron-up=97181506287521;square-code=76845656194464;square-dashed-bottom=133040895929365;square-dashed-bottom-code=103061363625640;square-dashed-kanban=114545633956348;square-dashed-mouse-pointer=123670726680392;square-divide=107353979642451;square-dot=110899495515389;square-equal=124042600382551;square-function=83985860709793;square-gantt-chart=107284369076219;square-kanban=97476877950543;square-library=81887890003221;square-m=135912337332436;square-menu=135438142591878;square-minus=78721357781624;square-mouse-pointer=127552100194692;square-parking=91463654971693;square-parking-off=111927816549509;square-pen=71257379947442;square-percent=113289006657504;square-pi=132511605174622;square-pilcrow=87094629814766;square-play=138697695062525;square-plus=91942389112860;square-power=120703265040347;square-radical=134223878880054;square-scissors=78779074277571;square-sigma=94523643558062;square-slash=78987954134223;square-split-horizontal=125857047694996;square-split-vertical=126418050285776;square-stack=94687061933604;square-terminal=75828907654568;square-user=140235161621168;square-user-round=81288587564855;square-x=76206131996728;squircle=99439828273252;squirrel=120668151944533;stamp=85130810524517;star=72669221096319;star-half=80822269649856;star-off=120003686620511;step-back=120706787286328;step-forward=91046009066136;stethoscope=78571774060105;sticker=139865196874378;sticky-note=98432110278865;stop-circle=97489143368359;store=121962391563311;stretch-horizontal=78770748920269;stretch-vertical=85907320465911;strikethrough=90568214674515;subscript=82653949184992;subtitles=134234590631375;sun=139232691165198;sun-dim=131075444152110;sun-medium=112704797109150;sun-moon=121221641564933;sun-snow=83004210487318;sunrise=116733420530374;sunset=101740056345650;superscript=93191189359166;swatch-book=70990631477660;swiss-franc=72116456510352;switch-camera=124033626341331;sword=121406454377051;swords=99199363807265;syringe=86444160764731;table=100826532869925;table-2=129391889722576;table-cells-merge=118490713113220;table-cells-split=113945031629733;table-columns-split=79195518284331;table-properties=135976623395143;table-rows-split=126696533672175;tablet=90619723471983;tablet-smartphone=78186066591210;tablets=88043022962639;tag=75425807137911;tags=103166221753217;tally-1=90000711698807;tally-2=99935651880614;tally-3=98958831676946;tally-4=128656473677471;tally-5=101955254503648;tangent=103123484115035;target=121091323240554;telescope=103588488639070;tent=91768489962137;tent-tree=85050403463582;terminal=102379915564176;terminal-square=89706340938367;test-tube=139701481278358;test-tube-2=118913572969135;test-tube-diagonal=121621592892259;test-tubes=117323642962952;text=99369759989955;text-cursor=103697482936876;text-cursor-input=84912489891242;text-quote=102573021965795;text-search=114489224126711;text-select=99310852917353;theater=89919220874053;thermometer=90545345642681;thermometer-snowflake=138010690931368;thermometer-sun=82795165216031;thumbs-down=73778874448741;thumbs-up=96046658888813;ticket=126875062984266;ticket-check=117888043623314;ticket-minus=89176175166723;ticket-percent=88410626824232;ticket-plus=83968600419805;ticket-slash=79392492298521;ticket-x=86658718829072;timer=120164083411828;timer-off=116991705734594;timer-reset=79948324123231;toggle-left=105639191695402;toggle-right=129483325318573;tornado=93796857097422;torus=78822043673501;touchpad=112333029100357;touchpad-off=86546394503986;tower-control=128131047012652;toy-brick=81793486260595;tractor=87948191954230;traffic-cone=87190332091101;train-front=91480038985820;train-front-tunnel=77194453402235;train-track=105798879242186;tram-front=80023103356955;trash=94712995845562;trash-2=126010725826757;tree-deciduous=109951315210525;tree-palm=111070569131758;tree-pine=71580980892868;trees=79707751200645;trello=90438659765426;trending-down=122658819043338;trending-up=86000419326493;triangle=134878256295114;triangle-alert=91165848022002;triangle-right=105796120965583;trophy=113055182645565;truck=125468675952181;turtle=73899487161474;tv=130308429701946;tv-2=129500347007411;twitch=90697389361633;twitter=90424880717042;type=70694319369829;umbrella=108749598923776;umbrella-off=111820268638089;underline=127096081441525;undo=111464695038355;undo-2=87358323292564;undo-dot=102793353935041;unfold-horizontal=85781955020909;unfold-vertical=122887666597646;ungroup=76318446818069;university=102146636224428;unlink=102194562745333;unlink-2=108239607794680;unlock=110263656507369;unlock-keyhole=126931549237422;unplug=123150141199349;upload=118488857289315;upload-cloud=121807815408739;usb=75949167692936;user=114567720540659;user-2=92481398073007;user-check=75620511859505;user-check-2=73224920504446;user-circle=111917761312899;user-circle-2=96888447186214;user-cog=87518742987519;user-cog-2=115462370853742;user-minus=94865546608687;user-minus-2=93808234717021;user-plus=101184880550364;user-plus-2=104764183758140;user-round=119713822992150;user-round-check=99288072031664;user-round-cog=127120627937146;user-round-minus=129866427748569;user-round-plus=101991526004413;user-round-search=114857943818454;user-round-x=89227016198055;user-search=110388873642450;user-square=136305896243658;user-square-2=71391894371551;user-x=138436637971548;user-x-2=96976557144947;users=85332511060401;users-2=138651149526372;users-round=103880524805720;utensils=122537080261787;utensils-crossed=100229317932246;utility-pole=137834357386674;variable=73932604072578;vault=107415856993701;vegan=127691293819852;venetian-mask=84202958608655;vibrate=140427675871522;vibrate-off=102494346080496;video=99411215690870;video-off=81634790888002;videotape=92799250697204;view=102821349715124;voicemail=121299677348672;volume=127607149758269;volume-1=115207748957226;volume-2=129861259578431;volume-x=106700331106145;vote=137637654521705;wallet=132318555862654;wallet-2=120839431200970;wallet-cards=86866924072285;wallet-minimal=77655892701714;wallpaper=76631821212930;wand=95424916372879;wand-2=84750107238092;wand-sparkles=115623066336607;warehouse=126757874656976;washing-machine=72331434583186;watch=103181426780078;waves=98840358372718;waypoints=101997233404191;webcam=90027890284611;webhook=110638252405523;webhook-off=71995352392407;weight=79312026690586;wheat=115823998996262;wheat-off=110571881208127;whole-word=110504483563993;wifi=104941258142372;wifi-off=120795495190257;wind=86165302601843;wine=101623153529226;wine-off=131814228138093;workflow=78971198932745;worm=98855303743824;wrap-text=70866394776130;wrench=85345725497834;x=116396312853810;x-circle=111132030834422;x-octagon=105062643930018;x-square=115678228554812;youtube=134880265650906;zap=109718589733073;zap-off=115642996489807;zoom-in=135570550221809;zoom-out=100181096350591]]
end)()

__modules["Icons/Svg"] = (function()
return function(import)
	local Svg = { MaxSegments = 160 }

	local function attribute(source, name)
		local value = string.match(source, name .. '%s*=%s*"([^"]*)"')
		if value == nil then
			value = string.match(source, name .. "%s*=%s*'([^']*)'")
		end
		return value
	end

	local function numbers(source)
		local out = {}
		if type(source) ~= "string" then
			return out
		end
		for token in string.gmatch(source, "[-+]?%d*%.?%d+[eE]?[-+]?%d*") do
			local value = tonumber(token)
			if value then
				table.insert(out, value)
			end
		end
		return out
	end

	local function scan(data)
		local out = {}
		local index, length = 1, #data
		while index <= length do
			local char = string.sub(data, index, index)
			if string.match(char, "%a") then
				table.insert(out, { cmd = char })
				index += 1
			elseif string.match(char, "[%d%.%-+]") then
				local stop = index
				if string.match(string.sub(data, stop, stop), "[-+]") then
					stop += 1
				end
				while stop <= length and string.match(string.sub(data, stop, stop), "%d") do
					stop += 1
				end
				if string.sub(data, stop, stop) == "." then
					stop += 1
					while stop <= length and string.match(string.sub(data, stop, stop), "%d") do
						stop += 1
					end
				end
				local exponent = string.lower(string.sub(data, stop, stop))
				if exponent == "e" then
					stop += 1
					if string.match(string.sub(data, stop, stop), "[-+]") then
						stop += 1
					end
					while stop <= length and string.match(string.sub(data, stop, stop), "%d") do
						stop += 1
					end
				end
				local value = tonumber(string.sub(data, index, stop - 1))
				if value then
					table.insert(out, { num = value })
				end
				index = stop > index and stop or index + 1
			else
				index += 1
			end
		end
		return out
	end

	local function cubic(points, x0, y0, x1, y1, x2, y2, x3, y3)
		local rough = math.abs(x1 - x0) + math.abs(y1 - y0) + math.abs(x2 - x1) + math.abs(y2 - y1) + math.abs(x3 - x2) + math.abs(y3 - y2)
		local steps = math.clamp(math.floor(rough / 1.4 + 0.5), 3, 14)
		for step = 1, steps do
			local t = step / steps
			local u = 1 - t
			local a, b, c, d = u * u * u, 3 * u * u * t, 3 * u * t * t, t * t * t
			table.insert(points, {
				a * x0 + b * x1 + c * x2 + d * x3,
				a * y0 + b * y1 + c * y2 + d * y3,
			})
		end
	end

	local function arc(points, x0, y0, rx, ry, rotation, largeArc, sweep, x1, y1)
		if rx == 0 or ry == 0 then
			table.insert(points, { x1, y1 })
			return
		end
		rx, ry = math.abs(rx), math.abs(ry)
		local phi = math.rad(rotation or 0)
		local cosPhi, sinPhi = math.cos(phi), math.sin(phi)
		local dx2, dy2 = (x0 - x1) / 2, (y0 - y1) / 2
		local x1p = cosPhi * dx2 + sinPhi * dy2
		local y1p = -sinPhi * dx2 + cosPhi * dy2
		local check = (x1p * x1p) / (rx * rx) + (y1p * y1p) / (ry * ry)
		if check > 1 then
			local scale = math.sqrt(check)
			rx, ry = rx * scale, ry * scale
		end
		local denominator = rx * rx * y1p * y1p + ry * ry * x1p * x1p
		local numerator = rx * rx * ry * ry - denominator
		if numerator < 0 then
			numerator = 0
		end
		local factor = math.sqrt(numerator / math.max(denominator, 1e-9))
		if largeArc == sweep then
			factor = -factor
		end
		local cxp = factor * rx * y1p / ry
		local cyp = -factor * ry * x1p / rx
		local cx = cosPhi * cxp - sinPhi * cyp + (x0 + x1) / 2
		local cy = sinPhi * cxp + cosPhi * cyp + (y0 + y1) / 2

		local function angle(ux, uy, vx, vy)
			local dot = ux * vx + uy * vy
			local len = math.sqrt((ux * ux + uy * uy) * (vx * vx + vy * vy))
			local value = math.acos(math.clamp(dot / math.max(len, 1e-9), -1, 1))
			if ux * vy - uy * vx < 0 then
				value = -value
			end
			return value
		end

		local start = angle(1, 0, (x1p - cxp) / rx, (y1p - cyp) / ry)
		local delta = angle((x1p - cxp) / rx, (y1p - cyp) / ry, (-x1p - cxp) / rx, (-y1p - cyp) / ry)
		if sweep == 0 and delta > 0 then
			delta -= math.pi * 2
		elseif sweep == 1 and delta < 0 then
			delta += math.pi * 2
		end

		local steps = math.clamp(math.ceil(math.abs(delta) / 0.32), 2, 20)
		for step = 1, steps do
			local theta = start + delta * (step / steps)
			local ex, ey = rx * math.cos(theta), ry * math.sin(theta)
			table.insert(points, {
				cosPhi * ex - sinPhi * ey + cx,
				sinPhi * ex + cosPhi * ey + cy,
			})
		end
	end

	local function path(data)
		local polylines = {}
		local items = scan(data)
		local current = {}
		local x, y, startX, startY = 0, 0, 0, 0
		local lastCommand
		local controlX, controlY
		local index = 1

		local function push()
			if #current > 1 then
				table.insert(polylines, current)
			end
			current = {}
		end

		local function take(count)
			local out = {}
			for offset = 0, count - 1 do
				local item = items[index + offset]
				if not item or not item.num then
					return nil
				end
				out[offset + 1] = item.num
			end
			index += count
			return out
		end

		while index <= #items do
			local item = items[index]
			local command
			if item.cmd then
				command = item.cmd
				index += 1
			elseif lastCommand then
				command = lastCommand == "M" and "L" or (lastCommand == "m" and "l" or lastCommand)
			else
				index += 1
				continue
			end
			lastCommand = command
			local upper = string.upper(command)
			local relative = command ~= upper

			if upper == "M" then
				local values = take(2)
				if not values then
					break
				end
				push()
				x = relative and x + values[1] or values[1]
				y = relative and y + values[2] or values[2]
				startX, startY = x, y
				current = { { x, y } }
				controlX, controlY = nil, nil
			elseif upper == "L" then
				local values = take(2)
				if not values then
					break
				end
				x = relative and x + values[1] or values[1]
				y = relative and y + values[2] or values[2]
				table.insert(current, { x, y })
				controlX, controlY = nil, nil
			elseif upper == "H" then
				local values = take(1)
				if not values then
					break
				end
				x = relative and x + values[1] or values[1]
				table.insert(current, { x, y })
				controlX, controlY = nil, nil
			elseif upper == "V" then
				local values = take(1)
				if not values then
					break
				end
				y = relative and y + values[1] or values[1]
				table.insert(current, { x, y })
				controlX, controlY = nil, nil
			elseif upper == "C" then
				local values = take(6)
				if not values then
					break
				end
				local x1 = relative and x + values[1] or values[1]
				local y1 = relative and y + values[2] or values[2]
				local x2 = relative and x + values[3] or values[3]
				local y2 = relative and y + values[4] or values[4]
				local x3 = relative and x + values[5] or values[5]
				local y3 = relative and y + values[6] or values[6]
				cubic(current, x, y, x1, y1, x2, y2, x3, y3)
				controlX, controlY = x2, y2
				x, y = x3, y3
			elseif upper == "S" then
				local values = take(4)
				if not values then
					break
				end
				local x1 = controlX and (2 * x - controlX) or x
				local y1 = controlY and (2 * y - controlY) or y
				local x2 = relative and x + values[1] or values[1]
				local y2 = relative and y + values[2] or values[2]
				local x3 = relative and x + values[3] or values[3]
				local y3 = relative and y + values[4] or values[4]
				cubic(current, x, y, x1, y1, x2, y2, x3, y3)
				controlX, controlY = x2, y2
				x, y = x3, y3
			elseif upper == "Q" then
				local values = take(4)
				if not values then
					break
				end
				local qx = relative and x + values[1] or values[1]
				local qy = relative and y + values[2] or values[2]
				local ex = relative and x + values[3] or values[3]
				local ey = relative and y + values[4] or values[4]
				cubic(current, x, y, x + 2 / 3 * (qx - x), y + 2 / 3 * (qy - y), ex + 2 / 3 * (qx - ex), ey + 2 / 3 * (qy - ey), ex, ey)
				controlX, controlY = qx, qy
				x, y = ex, ey
			elseif upper == "T" then
				local values = take(2)
				if not values then
					break
				end
				local qx = controlX and (2 * x - controlX) or x
				local qy = controlY and (2 * y - controlY) or y
				local ex = relative and x + values[1] or values[1]
				local ey = relative and y + values[2] or values[2]
				cubic(current, x, y, x + 2 / 3 * (qx - x), y + 2 / 3 * (qy - y), ex + 2 / 3 * (qx - ex), ey + 2 / 3 * (qy - ey), ex, ey)
				controlX, controlY = qx, qy
				x, y = ex, ey
			elseif upper == "A" then
				local values = take(7)
				if not values then
					break
				end
				local ex = relative and x + values[6] or values[6]
				local ey = relative and y + values[7] or values[7]
				arc(current, x, y, values[1], values[2], values[3], values[4], values[5], ex, ey)
				x, y = ex, ey
				controlX, controlY = nil, nil
			elseif upper == "Z" then
				if #current > 0 then
					table.insert(current, { startX, startY })
				end
				x, y = startX, startY
				push()
				lastCommand = nil
				controlX, controlY = nil, nil
			else
				index += 1
			end
		end
		push()
		return polylines
	end
	Svg.Path = path

	local function segments(spec, polylines)
		for _, line in polylines do
			for index = 1, #line - 1 do
				if #spec.L >= Svg.MaxSegments then
					return
				end
				local a, b = line[index], line[index + 1]
				if math.abs(a[1] - b[1]) > 0.01 or math.abs(a[2] - b[2]) > 0.01 then
					table.insert(spec.L, { a[1], a[2], b[1], b[2] })
				end
			end
		end
	end

	function Svg.Parse(text)
		if type(text) ~= "string" or not string.find(text, "<svg", 1, true) then
			return nil
		end
		local header = string.match(text, "<svg([^>]*)>") or ""
		local box = numbers(attribute(header, "viewBox"))
		local size = 24
		if #box >= 4 and box[3] > 0 then
			size = math.max(box[3], box[4])
		else
			local width = tonumber(attribute(header, "width") or "")
			if width and width > 0 then
				size = width
			end
		end
		local offsetX = #box >= 4 and box[1] or 0
		local offsetY = #box >= 4 and box[2] or 0

		local spec = {
			Type = "Vector",
			Size = size,
			Width = tonumber(attribute(header, "stroke%-width") or "") or 2,
			L = {},
			C = {},
			R = {},
		}

		for tag, body in string.gmatch(text, "<(%a+)([^>]*)>") do
			tag = string.lower(tag)
			if tag == "path" then
				local data = attribute(body, "d")
				if data then
					segments(spec, path(data))
				end
			elseif tag == "line" then
				local x1 = tonumber(attribute(body, "x1") or "") or 0
				local y1 = tonumber(attribute(body, "y1") or "") or 0
				local x2 = tonumber(attribute(body, "x2") or "") or 0
				local y2 = tonumber(attribute(body, "y2") or "") or 0
				table.insert(spec.L, { x1, y1, x2, y2 })
			elseif tag == "circle" then
				local cx = tonumber(attribute(body, "cx") or "") or 0
				local cy = tonumber(attribute(body, "cy") or "") or 0
				local r = tonumber(attribute(body, "r") or "") or 0
				if r > 0 then
					table.insert(spec.C, { cx, cy, r })
				end
			elseif tag == "ellipse" then
				local cx = tonumber(attribute(body, "cx") or "") or 0
				local cy = tonumber(attribute(body, "cy") or "") or 0
				local rx = tonumber(attribute(body, "rx") or "") or 0
				local ry = tonumber(attribute(body, "ry") or "") or 0
				if rx > 0 and ry > 0 then
					if math.abs(rx - ry) < 0.2 then
						table.insert(spec.C, { cx, cy, (rx + ry) / 2 })
					else
						local points = {}
						for step = 0, 20 do
							local theta = step / 20 * math.pi * 2
							table.insert(points, { cx + rx * math.cos(theta), cy + ry * math.sin(theta) })
						end
						segments(spec, { points })
					end
				end
			elseif tag == "rect" then
				local rx = tonumber(attribute(body, "x") or "") or 0
				local ry = tonumber(attribute(body, "y") or "") or 0
				local width = tonumber(attribute(body, "width") or "") or 0
				local height = tonumber(attribute(body, "height") or "") or 0
				local radius = tonumber(attribute(body, "rx") or "") or 0
				if width > 0 and height > 0 then
					table.insert(spec.R, { rx, ry, width, height, radius })
				end
			elseif tag == "polyline" or tag == "polygon" then
				local values = numbers(attribute(body, "points"))
				local points = {}
				for index = 1, #values - 1, 2 do
					table.insert(points, { values[index], values[index + 1] })
				end
				if tag == "polygon" and #points > 2 then
					table.insert(points, points[1])
				end
				segments(spec, { points })
			end
		end

		if offsetX ~= 0 or offsetY ~= 0 then
			for _, line in spec.L do
				line[1] -= offsetX
				line[2] -= offsetY
				line[3] -= offsetX
				line[4] -= offsetY
			end
			for _, circle in spec.C do
				circle[1] -= offsetX
				circle[2] -= offsetY
			end
			for _, rect in spec.R do
				rect[1] -= offsetX
				rect[2] -= offsetY
			end
		end

		if #spec.L == 0 and #spec.C == 0 and #spec.R == 0 then
			return nil
		end
		return spec
	end

	function Svg.Encode(spec)
		local HttpService = game:GetService("HttpService")
		local ok, json = pcall(HttpService.JSONEncode, HttpService, {
			Size = spec.Size,
			Width = spec.Width,
			L = spec.L,
			C = spec.C,
			R = spec.R,
		})
		return ok and json or nil
	end

	function Svg.Decode(json)
		local HttpService = game:GetService("HttpService")
		local ok, data = pcall(HttpService.JSONDecode, HttpService, json)
		if not ok or type(data) ~= "table" then
			return nil
		end
		return {
			Type = "Vector",
			Size = data.Size or 24,
			Width = data.Width or 2,
			L = data.L or {},
			C = data.C or {},
			R = data.R or {},
		}
	end

	return Svg
end
end)()

__modules["Icons/Store"] = (function()
return function(import)
	local HttpService = game:GetService("HttpService")
	local Capabilities = import("Core/Capabilities")
	local Utility = import("Core/Utility")
	local Signal = import("Core/Signal")
	local Svg = import("Icons/Svg")

	local Store = {
		Folder = "DeaDx/icons",
		Index = "DeaDx/icons/index.json",
		MaxBytes = 524288,
		Verify = true,
		Updated = Signal.new(),
	}

	local manifest
	local assets = {}
	local vectors = {}
	local pending = {}
	local checked = {}
	local writeQueued = false
	local dirty = false

	local function available()
		return Capabilities.FileSystem and Capabilities.GetCustomAsset ~= nil
	end
	Store.Available = available

	local function load()
		if manifest then
			return manifest
		end
		manifest = {}
		if not available() then
			return manifest
		end
		Capabilities.EnsureFolder(Store.Folder)
		if Capabilities.FS.IsFile(Store.Index) then
			local ok, body = pcall(Capabilities.FS.Read, Store.Index)
			if ok and type(body) == "string" and body ~= "" then
				local parsed, data = pcall(HttpService.JSONDecode, HttpService, body)
				if parsed and type(data) == "table" then
					manifest = data
				end
			end
		end
		return manifest
	end

	local function flush()
		if not available() then
			return
		end
		dirty = true
		if writeQueued then
			return
		end
		writeQueued = true
		task.delay(0.6, function()
			writeQueued = false
			if not dirty then
				return
			end
			dirty = false
			local ok, body = pcall(HttpService.JSONEncode, HttpService, manifest or {})
			if ok then
				pcall(Capabilities.FS.Write, Store.Index, body)
			end
		end)
	end

	local function isRaster(body)
		if type(body) ~= "string" or #body < 12 then
			return false
		end
		if string.sub(body, 2, 4) == "PNG" then
			return true
		end
		if string.byte(body, 1) == 255 and string.byte(body, 2) == 216 then
			return true
		end
		return false
	end

	local function customAsset(path)
		local ok, asset = pcall(Capabilities.GetCustomAsset, path)
		if ok and type(asset) == "string" and asset ~= "" then
			return asset
		end
		return nil
	end

	local function download(url)
		local ok, body = Capabilities.HttpGet(url)
		if not ok or type(body) ~= "string" or body == "" then
			return nil, "download failed"
		end
		if #body > Store.MaxBytes then
			return nil, "icon too large"
		end
		return body
	end

	function Store.Entry(key)
		return load()[key]
	end

	function Store.List()
		local out = {}
		for key in load() do
			table.insert(out, key)
		end
		table.sort(out)
		return out
	end

	function Store.Forget(key)
		local data = load()
		local entry = data[key]
		if entry then
			if available() and Capabilities.FS.Delete and entry.file and Capabilities.FS.IsFile(entry.file) then
				pcall(Capabilities.FS.Delete, entry.file)
			end
			if available() and Capabilities.FS.Delete and entry.spec and Capabilities.FS.IsFile(entry.spec) then
				pcall(Capabilities.FS.Delete, entry.spec)
			end
			data[key] = nil
			flush()
		end
		assets[key] = nil
		vectors[key] = nil
		checked[key] = nil
		return entry ~= nil
	end

	function Store.Clear()
		for _, key in Store.List() do
			Store.Forget(key)
		end
		manifest = {}
		flush()
	end

	local function resolveRaster(key, url, body)
		local data = load()
		local path = string.format("%s/%s.png", Store.Folder, key)
		local written = pcall(Capabilities.FS.Write, path, body)
		if not written then
			return nil
		end
		local asset = customAsset(path)
		if not asset then
			return nil
		end
		data[key] = { kind = "raster", url = url, hash = Utility.Hash(body), file = path, size = #body }
		flush()
		assets[key] = asset
		return asset
	end

	local function resolveVector(key, url, body)
		local spec = Svg.Parse(body)
		if not spec then
			return nil
		end
		local data = load()
		local entry = { kind = "vector", url = url, hash = Utility.Hash(body) }
		if available() then
			local rawPath = string.format("%s/%s.svg", Store.Folder, key)
			local specPath = string.format("%s/%s.json", Store.Folder, key)
			local encoded = Svg.Encode(spec)
			if encoded then
				pcall(Capabilities.FS.Write, rawPath, body)
				pcall(Capabilities.FS.Write, specPath, encoded)
				entry.file = rawPath
				entry.spec = specPath
			end
		end
		data[key] = entry
		flush()
		vectors[key] = spec
		return spec
	end

	local function revalidate(key, url, vector)
		if not Store.Verify or checked[key] then
			return
		end
		checked[key] = true
		task.spawn(function()
			local body = download(url)
			if not body then
				return
			end
			local data = load()
			local entry = data[key]
			local hash = Utility.Hash(body)
			if entry and entry.hash == hash then
				return
			end
			if vector then
				local spec = resolveVector(key, url, body)
				if spec then
					Store.Updated:Fire(key, spec, true)
				end
			elseif isRaster(body) then
				assets[key] = nil
				local asset = resolveRaster(key, url, body)
				if asset then
					Store.Updated:Fire(key, asset, false)
				end
			end
		end)
	end

	local function queue(key, worker, callback)
		local waiting = pending[key]
		if waiting then
			table.insert(waiting, callback)
			return
		end
		pending[key] = { callback }
		task.spawn(function()
			local result = worker()
			local list = pending[key] or {}
			pending[key] = nil
			for _, listener in list do
				task.spawn(listener, result)
			end
		end)
	end

	local complained = {}

	function Store.Complain(key, message)
		if complained[key] then
			return false
		end
		complained[key] = true
		Utility.Warn(string.format("icon %s: %s", tostring(key), message))
		return true
	end

	function Store.Raster(key, url, callback)
		key = Utility.Slug(key)
		if assets[key] then
			callback(assets[key])
			revalidate(key, url, false)
			return
		end
		if not available() then
			Store.Complain(
				key,
				"this executor has no file access or getcustomasset, so a photo from a url cannot be drawn. Use rbxassetid:// instead."
			)
			callback(nil)
			return
		end
		local data = load()
		local entry = data[key]
		if entry and entry.kind == "raster" and entry.file and Capabilities.FS.IsFile(entry.file) then
			local asset = customAsset(entry.file)
			if asset then
				assets[key] = asset
				callback(asset)
				revalidate(key, url, false)
				return
			end
		end
		queue(key, function()
			local body, reason = download(url)
			if not body then
				Store.Complain(key, string.format('could not download "%s" (%s)', url, tostring(reason)))
				return nil
			end
			if not isRaster(body) then
				Store.Complain(
					key,
					string.format('"%s" did not answer with a png or jpg. Roblox only draws those two, and some sites refuse Roblox. Upload it as a Roblox decal and use rbxassetid:// instead.', url)
				)
				return nil
			end
			return resolveRaster(key, url, body)
		end, callback)
	end

	function Store.Vector(key, url, callback)
		key = Utility.Slug(key)
		if vectors[key] then
			callback(vectors[key])
			revalidate(key, url, true)
			return
		end
		local data = load()
		local entry = data[key]
		if entry and entry.kind == "vector" and entry.spec and available() and Capabilities.FS.IsFile(entry.spec) then
			local ok, body = pcall(Capabilities.FS.Read, entry.spec)
			if ok and type(body) == "string" then
				local spec = Svg.Decode(body)
				if spec then
					vectors[key] = spec
					callback(spec)
					revalidate(key, url, true)
					return
				end
			end
		end
		queue(key, function()
			local body, reason = download(url)
			if not body then
				Store.Complain(key, string.format('could not download the svg "%s" (%s)', url, tostring(reason)))
				return nil
			end
			local spec = resolveVector(key, url, body)
			if not spec then
				Store.Complain(key, string.format('could not read the svg at "%s"', url))
			end
			return spec
		end, callback)
	end

	function Store.Local(path)
		if not available() or not Capabilities.FS.IsFile(path) then
			return nil
		end
		return customAsset(path)
	end

	function Store.Import(key, body, url)
		key = Utility.Slug(key)
		if type(body) ~= "string" then
			return nil
		end
		if isRaster(body) then
			assets[key] = nil
			return resolveRaster(key, url or "", body)
		end
		return resolveVector(key, url or "", body)
	end

	function Store.Stats()
		local data = load()
		local count, bytes = 0, 0
		for _, entry in data do
			count += 1
			bytes += entry.size or 0
		end
		return { Count = count, Bytes = bytes, Cached = count, Folder = Store.Folder, Available = available() }
	end

	return Store
end
end)()

__modules["Icons/Providers"] = (function()
return function(import)
	local Store = import("Icons/Store")
	local Utility = import("Core/Utility")

	local Providers = {}

	local names
	local catalog

	local function entries()
		if catalog then
			return catalog
		end
		catalog = {}
		for name, id in string.gmatch(import("Icons/Catalog"), "([^;=]+)=([^;]+)") do
			catalog[name] = id
		end
		return catalog
	end
	Providers.Entries = entries

	Providers.Templates = {
		lucide = "https://unpkg.com/lucide-static@0.544.0/icons/%s.svg",
		iconsax = "https://raw.githubusercontent.com/lusaxweb/iconsax/master/svg/%s.svg",
		tabler = "https://unpkg.com/@tabler/icons@3.31.0/icons/outline/%s.svg",
		feather = "https://unpkg.com/feather-icons@4.29.2/dist/icons/%s.svg",
	}

	function Providers.SetTemplate(provider, template)
		Utility.Check(
			type(provider) == "string" and type(template) == "string" and string.find(template, "%%s") ~= nil,
			"IconTemplate",
			provider,
			"Expected (provider: string, template: string) where template contains %s."
		)
		Providers.Templates[string.lower(provider)] = template
	end

	function Providers.Template(provider)
		return Providers.Templates[string.lower(provider or "")]
	end

	local RENAMES = {
		house = "home",
		["square-pen"] = "edit-3",
		["pen-line"] = "edit-3",
		["loader-circle"] = "loader-2",
		["gauge-circle"] = "gauge",
		["circle-dot"] = "dot-circle",
		["message-circle-more"] = "message-circle",
		["panel-left"] = "sidebar",
		["panel-top"] = "panel-top",
		["chart-no-axes-column"] = "bar-chart",
		["chart-column"] = "bar-chart-3",
		["chart-line"] = "line-chart",
		["chart-pie"] = "pie-chart",
		["chart-bar"] = "bar-chart-horizontal",
		["arrow-up-narrow-wide"] = "arrow-up-narrow-wide",
		["ellipsis"] = "more-horizontal",
		["ellipsis-vertical"] = "more-vertical",
		["x-circle"] = "circle-x",
		["refresh-ccw-dot"] = "refresh-ccw",
	}

	local function rotate(name)
		local parts = string.split(name, "-")
		if #parts < 2 then
			return nil
		end
		local first = table.remove(parts, 1)
		table.insert(parts, first)
		return table.concat(parts, "-")
	end

	function Providers.Catalog(name)
		if type(name) ~= "string" then
			return nil
		end
		local key = string.lower(name)
		local source = entries()
		local id = source[key]
		if not id and RENAMES[key] then
			id = source[RENAMES[key]]
		end
		if not id then
			local rotated = rotate(key)
			if rotated then
				id = source[rotated]
			end
		end
		if not id then
			return nil
		end
		return { Type = "Image", Source = "rbxassetid://" .. id, Tint = true, Name = key }
	end

	function Providers.Names()
		if not names then
			names = {}
			for key in entries() do
				table.insert(names, key)
			end
			table.sort(names)
		end
		return table.clone(names)
	end

	function Providers.Count()
		return #Providers.Names()
	end

	local PHOTO = {
		png = true, jpg = true, jpeg = true, webp = true,
		bmp = true, tga = true, gif = true, avif = true,
	}

	function Providers.Kind(url)
		local path = string.lower(tostring(url))
		path = string.match(path, "^([^?#]+)") or path
		local extension = string.match(path, "%.(%w+)$")
		if extension == "svg" then
			return "Svg", true
		end
		if extension and PHOTO[extension] then
			return "Url", false
		end
		if string.find(path, "%.svg") then
			return "Svg", true
		end
		return "Url", false
	end

	function Providers.IsPhoto(url)
		local _, tint = Providers.Kind(url)
		return not tint
	end

	function Providers.Remote(provider, name)
		local template = Providers.Template(provider)
		if not template then
			return nil
		end
		local url = string.format(template, name)
		local kind = Providers.Kind(url)
		return {
			Type = kind,
			Source = url,
			Tint = true,
			Name = string.lower(provider) .. "-" .. Utility.Slug(name),
		}
	end

	function Providers.FromUrl(url, name, tint)
		local kind, monochrome = Providers.Kind(url)
		if tint == nil then
			tint = monochrome
		end
		return {
			Type = kind,
			Source = url,
			Tint = tint == true,
			Name = name or ("url-" .. Utility.Hash(url)),
		}
	end

	function Providers.Load(spec, callback)
		if spec.Type == "Url" then
			Store.Raster(spec.Name or Utility.Hash(spec.Source), spec.Source, callback)
		elseif spec.Type == "Svg" then
			Store.Vector(spec.Name or Utility.Hash(spec.Source), spec.Source, callback)
		else
			callback(nil)
		end
	end

	local fallback
	function Providers.GetFallback()
		if fallback == nil then
			fallback = Providers.Catalog(Providers.FallbackName or "circle-help") or false
		end
		return fallback or nil
	end

	return Providers
end
end)()

__modules["Icons/Registry"] = (function()
return function(import)
	local Providers = import("Icons/Providers")
	local Utility = import("Core/Utility")

	local Registry = {
		_providers = {},
		_current = "lucide",
		_aliases = {},
	}

	Registry._providers.lucide = function(name)
		return Providers.Catalog(name) or Providers.Remote("lucide", name)
	end
	Registry._providers.builtin = Registry._providers.lucide
	Registry._providers.iconsax = function(name)
		return Providers.Remote("iconsax", name)
	end
	Registry._providers.tabler = function(name)
		return Providers.Remote("tabler", name)
	end
	Registry._providers.feather = function(name)
		return Providers.Remote("feather", name)
	end

	function Registry.Register(name, resolve)
		Utility.Check(
			type(name) == "string" and type(resolve) == "function",
			"IconProvider",
			name,
			"Expected (name: string, resolve: function)."
		)
		Registry._providers[string.lower(name)] = resolve
	end

	function Registry.SetProvider(name)
		name = string.lower(tostring(name))
		if not Registry._providers[name] then
			Utility.Warn(string.format('Icon provider "%s" is not registered.', tostring(name)))
			return false
		end
		Registry._current = name
		return true
	end

	function Registry.GetProvider()
		return Registry._current
	end

	function Registry.Providers()
		local out = {}
		for name in Registry._providers do
			table.insert(out, name)
		end
		table.sort(out)
		return out
	end

	function Registry.Alias(alias, spec)
		Utility.Check(type(alias) == "string", "IconAlias", alias, "Alias must be a string.")
		Registry._aliases[string.lower(alias)] = spec
	end

	local function fromString(spec)
		local alias = Registry._aliases[string.lower(spec)]
		if alias ~= nil and type(alias) ~= "table" then
			spec = alias
		elseif type(alias) == "table" then
			return alias
		end

		if string.sub(spec, 1, 8) == "https://" or string.sub(spec, 1, 7) == "http://" then
			return Providers.FromUrl(spec)
		end
		if
			string.sub(spec, 1, 13) == "rbxassetid://"
			or string.sub(spec, 1, 9) == "rbxasset:"
			or string.sub(spec, 1, 11) == "rbxthumb://"
			or string.sub(spec, 1, 10) == "rbxhttp://"
		then
			return { Type = "Image", Source = spec, Tint = false, Name = spec }
		end
		if string.match(spec, "^%d+$") then
			return { Type = "Image", Source = "rbxassetid://" .. spec, Tint = false, Name = spec }
		end
		if string.sub(spec, 1, 5) == "file:" then
			return { Type = "File", Source = string.sub(spec, 6), Tint = false, Name = spec }
		end

		local provider, name = string.match(spec, "^(%w[%w%-_]*):(.+)$")
		if provider and Registry._providers[string.lower(provider)] then
			local ok, resolved = pcall(Registry._providers[string.lower(provider)], name)
			if ok and resolved then
				return resolved
			end
			return nil
		end

		local resolver = Registry._providers[Registry._current]
		if resolver then
			local ok, resolved = pcall(resolver, spec)
			if ok and resolved then
				return resolved
			end
		end
		return Providers.Catalog(spec)
	end

	function Registry.Resolve(spec)
		if type(spec) == "number" then
			return { Type = "Image", Source = "rbxassetid://" .. tostring(spec), Tint = false, Name = tostring(spec) }
		end
		if type(spec) == "string" then
			if spec == "" then
				return nil
			end
			return fromString(spec)
		end
		if type(spec) == "table" then
			if spec.Type == "Image" or spec.Type == "Url" or spec.Type == "Svg" or spec.Type == "Vector" or spec.Type == "File" then
				return spec
			end
			local source = spec.Source or spec.Image or spec.Url or spec.Icon
			if type(source) == "string" or type(source) == "number" then
				local resolved = Registry.Resolve(source)
				if resolved then
					resolved = table.clone(resolved)
					if spec.Tint ~= nil then
						resolved.Tint = spec.Tint == true
					end
					if spec.Name then
						resolved.Name = spec.Name
					end
					resolved.Shape = spec.Shape or resolved.Shape
					resolved.Corner = spec.Corner or resolved.Corner
					resolved.ScaleType = spec.ScaleType or resolved.ScaleType
					return resolved
				end
			end
		end
		return nil
	end

	function Registry.Exists(spec)
		return Registry.Resolve(spec) ~= nil
	end

	return Registry
end
end)()

__modules["Icons/Icon"] = (function()
return function(import)
	local Registry = import("Icons/Registry")
	local Providers = import("Icons/Providers")
	local Store = import("Icons/Store")
	local Theme = import("Core/Theme")
	local Utility = import("Core/Utility")
	local Widgets = import("Core/Widgets")
	local Cleanup = import("Services/Cleanup")
	local Animation = import("Services/Animation")

	local Icons = {}

	function Icons:Get(name)
		return Registry.Resolve(name)
	end

	function Icons:List()
		return Providers.Names()
	end

	function Icons:Count()
		return Providers.Count()
	end

	setmetatable(Icons, {
		__index = function(_, key)
			if type(key) ~= "string" then
				return nil
			end
			return Registry.Resolve(Utility.Kebab(key))
		end,
	})

	local SHAPES = {
		square = "Square", sharp = "Square", none = "Square",
		rounded = "Rounded", round = "Rounded", soft = "Rounded", squircle = "Rounded",
		circle = "Circle", circular = "Circle", full = "Circle", round_full = "Circle",
	}

	function Icons.Shape(value)
		if value == nil then
			return nil
		end
		if type(value) == "number" then
			return value
		end
		return SHAPES[string.lower(tostring(value))]
	end

	function Icons.Options(config, base)
		local opts = base or {}
		if type(config) ~= "table" then
			return opts
		end
		if config.IconShape ~= nil then
			opts.Shape = config.IconShape
		end
		if config.IconCorner ~= nil then
			opts.Corner = config.IconCorner
		end
		if config.IconTint ~= nil then
			opts.Tint = config.IconTint == true
		end
		if config.IconScale ~= nil then
			opts.ScaleType = config.IconScale
		end
		if config.IconColor ~= nil and opts.Color == nil then
			opts.Color = config.IconColor
		end
		return opts
	end

	function Icons.Create(parent, spec, opts)
		opts = opts or {}
		local size = opts.Size or 16
		local cleanup = opts.Cleanup and opts.Cleanup:Extend() or Cleanup.new()
		local self = {}

		local container = Utility.Create("Frame", {
			Name = "Icon",
			BackgroundTransparency = 1,
			Size = UDim2.fromOffset(size, size),
			Position = opts.Position or UDim2.new(),
			AnchorPoint = opts.AnchorPoint or Vector2.zero,
			LayoutOrder = opts.LayoutOrder,
			ZIndex = opts.ZIndex or 1,
			Rotation = opts.Rotation or 0,
			Parent = parent,
		})
		cleanup:Add(container)
		self.Instance = container

		local colorSource = opts.Color or "MutedText"
		local parts = {}
		local image, tinted, gradient
		local ticket = 0
		local key

		local function paint(animate)
			local sequence = Widgets.Stops(colorSource)
			local color = sequence and Color3.new(1, 1, 1) or Theme.Resolve(colorSource, "MutedText")
			local tween = animate and opts.Tween ~= false
			for _, part in parts do
				if part.stroke then
					if tween then
						Animation:Play(part.stroke, { Color = color }, { Duration = 0.18, Ease = "Soft" })
					else
						part.stroke.Color = color
					end
				elseif tween then
					Animation:Play(part.instance, { BackgroundColor3 = color }, { Duration = 0.18, Ease = "Soft" })
				else
					part.instance.BackgroundColor3 = color
				end
			end
			if image then
				if sequence then
					if not gradient then
						gradient = Utility.Create("UIGradient", { Parent = image })
					end
					gradient.Color = sequence
					image.ImageColor3 = Color3.new(1, 1, 1)
				else
					if gradient then
						gradient:Destroy()
						gradient = nil
					end
					if tinted then
						if tween then
							Animation:Play(image, { ImageColor3 = color }, { Duration = 0.18, Ease = "Soft" })
						else
							image.ImageColor3 = color
						end
					end
				end
			end
		end

		local function clear()
			container:ClearAllChildren()
			table.clear(parts)
			image, tinted, gradient = nil, false, nil
		end

		local function drawVector(vector)
			local grid = vector.Size or 24
			local weight = vector.Width or 2
			local thickness = math.max(1.2, size / grid * weight * 0.9)
			for _, segment in vector.L or {} do
				local x1, y1, x2, y2 = segment[1], segment[2], segment[3], segment[4]
				local dx, dy = x2 - x1, y2 - y1
				local length = math.max(math.sqrt(dx * dx + dy * dy), 0.01)
				local line = Utility.Create("Frame", {
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale((x1 + x2) / (grid * 2), (y1 + y2) / (grid * 2)),
					Size = UDim2.new(length / grid, thickness, 0, thickness),
					Rotation = math.deg(math.atan2(dy, dx)),
					Parent = container,
				})
				Utility.Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = line })
				table.insert(parts, { instance = line })
			end
			for _, circle in vector.C or {} do
				local diameter = circle[3] * 2 / grid
				local ring = Utility.Create("Frame", {
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundTransparency = 1,
					Position = UDim2.fromScale(circle[1] / grid, circle[2] / grid),
					Size = UDim2.fromScale(diameter, diameter),
					Parent = container,
				})
				Utility.Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = ring })
				local stroke = Utility.Create("UIStroke", {
					Thickness = thickness,
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
					Parent = ring,
				})
				table.insert(parts, { instance = ring, stroke = stroke })
			end
			for _, rect in vector.R or {} do
				local box = Utility.Create("Frame", {
					BackgroundTransparency = 1,
					Position = UDim2.fromScale(rect[1] / grid, rect[2] / grid),
					Size = UDim2.fromScale(rect[3] / grid, rect[4] / grid),
					Parent = container,
				})
				if (rect[5] or 0) > 0 then
					Utility.Create("UICorner", {
						CornerRadius = UDim.new(0, math.max(1, rect[5] / grid * size)),
						Parent = box,
					})
				end
				local stroke = Utility.Create("UIStroke", {
					Thickness = thickness,
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
					Parent = box,
				})
				table.insert(parts, { instance = box, stroke = stroke })
			end
		end

		local shape, shapeCorner, shapeScale

		local function radius()
			if type(shapeCorner) == "number" then
				return UDim.new(0, shapeCorner)
			end
			if shapeCorner == "Full" then
				return UDim.new(1, 0)
			end
			if shape == "Circle" then
				return UDim.new(1, 0)
			end
			if shape == "Rounded" then
				return UDim.new(0, math.max(2, math.floor(size * 0.28)))
			end
			return nil
		end

		local function scaleType()
			local wanted = shapeScale or opts.ScaleType
			if wanted == nil then
				if shape == "Circle" or shape == "Rounded" or shapeCorner ~= nil then
					return Enum.ScaleType.Crop
				end
				return Enum.ScaleType.Fit
			end
			if typeof(wanted) == "EnumItem" then
				return wanted
			end
			local name = string.lower(tostring(wanted))
			if name == "crop" or name == "cover" or name == "fill" then
				return Enum.ScaleType.Crop
			end
			if name == "stretch" then
				return Enum.ScaleType.Stretch
			end
			if name == "slice" then
				return Enum.ScaleType.Slice
			end
			return Enum.ScaleType.Fit
		end

		local function clipShape()
			local corner = radius()
			container.ClipsDescendants = corner ~= nil
			local existing = container:FindFirstChildOfClass("UICorner")
			if corner == nil then
				if existing then
					existing:Destroy()
				end
				return nil
			end
			if existing then
				existing.CornerRadius = corner
			else
				Utility.Create("UICorner", { CornerRadius = corner, Parent = container })
			end
			return corner
		end

		local function newImage(source, tint)
			image = Utility.Create("ImageLabel", {
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 1),
				Image = source or "",
				ScaleType = scaleType(),
				Parent = container,
			})
			local corner = radius()
			if corner then
				Utility.Create("UICorner", { CornerRadius = corner, Parent = image })
			end
			tinted = tint == true
			return image
		end

		local function fallback()
			clear()
			clipShape()
			local spare = Providers.GetFallback()
			if spare then
				newImage(spare.Source, spare.Tint)
				image.ScaleType = Enum.ScaleType.Fit
			else
				container.Visible = false
			end
			paint()
		end

		local function draw(newSpec)
			ticket += 1
			local mine = ticket
			key = nil
			clear()
			if newSpec == nil or newSpec == "" then
				container.Visible = false
				return
			end
			container.Visible = true
			local resolved = Registry.Resolve(newSpec)
			if not resolved then
				Store.Complain(
					"spec-" .. Utility.Slug(tostring(newSpec)),
					string.format('"%s" is not a catalog name, a url, an rbxassetid:// or a file: path.', tostring(newSpec))
				)
				resolved = Providers.GetFallback()
			end
			if not resolved then
				container.Visible = false
				return
			end

			shape = Icons.Shape(opts.Shape or resolved.Shape)
			shapeCorner = opts.Corner or resolved.Corner
			shapeScale = opts.ScaleType or resolved.ScaleType
			clipShape()

			if opts.Tint ~= nil then
				resolved = table.clone(resolved)
				resolved.Tint = opts.Tint == true
			end

			if resolved.Type == "Vector" then
				drawVector(resolved)
			elseif resolved.Type == "Image" then
				newImage(resolved.Source, resolved.Tint)
			elseif resolved.Type == "File" then
				local asset = Store.Local(resolved.Source)
				if asset then
					newImage(asset, resolved.Tint)
				else
					fallback()
					return
				end
			else
				key = Utility.Slug(resolved.Name or resolved.Source)
				newImage(nil, resolved.Tint)
				Providers.Load(resolved, function(result)
					if mine ~= ticket or not container.Parent then
						return
					end
					if result == nil then
						fallback()
						return
					end
					if type(result) == "table" then
						clear()
						clipShape()
						drawVector(result)
					elseif image then
						image.Image = result
					end
					paint()
				end)
			end
			paint()
		end

		cleanup:Add(Store.Updated:Connect(function(updatedKey, result)
			if key ~= updatedKey or not container.Parent then
				return
			end
			if type(result) == "table" then
				clear()
				clipShape()
				drawVector(result)
			elseif image then
				image.Image = result
			end
			paint()
		end))

		function self.Set(_, newSpec)
			self.Spec = newSpec
			draw(newSpec)
		end

		function self.SetShape(_, newShape, corner)
			opts.Shape = newShape
			if corner ~= nil then
				opts.Corner = corner
			end
			draw(self.Spec)
			return self
		end

		function self.SetTint(_, enabled)
			opts.Tint = enabled
			draw(self.Spec)
			return self
		end

		function self.SetColor(_, newColor)
			if colorSource == newColor then
				return
			end
			colorSource = newColor
			paint(true)
		end

		function self.SetSize(_, newSize)
			size = newSize
			container.Size = UDim2.fromOffset(newSize, newSize)
			draw(self.Spec)
		end

		function self.IsVisible()
			return container.Visible
		end

		function self.Destroy()
			cleanup:Clean()
		end

		Theme.BindFn(paint, cleanup)
		self.Spec = spec
		draw(spec)
		return self
	end

	return Icons
end
end)()

__modules["Components/Button"] = (function()
return function(import)
	local Component = import("Core/Component")
	local Utility = import("Core/Utility")
	local Widgets = import("Core/Widgets")
	local Icons = import("Icons/Icon")
	local Animation = import("Services/Animation")

	local Button = setmetatable({}, { __index = Component.Base })
	Button.__index = Button

	function Button:Fire(skipCooldown)
		if self._destroyed or not self.Enabled then
			return self
		end
		if self:IsLocked() then
			self:Shake()
			return self
		end
		Utility.SafeCall("Button " .. tostring(self.Config.Title), self.Config.Callback)
		self.Changed:Fire()
		local cooldown = tonumber(self.Config.Cooldown)
		if cooldown and cooldown > 0 and not skipCooldown then
			self:Lock(cooldown)
		end
		return self
	end

	return function(ctx, id, config)
		Utility.Check(
			config.Callback == nil or type(config.Callback) == "function",
			"Button",
			config.Title,
			"Callback must be a function."
		)
		local self = Component.New(ctx, Button, "Button", id, config, { RightWidth = 16, RightHeight = 16 })
		local cleanup = self.Cleanup
		self._arrow = Icons.Create(self.Right, config.Arrow or "chevron-right", {
			Size = 16,
			Color = config.ArrowColor or "MutedText",
			Cleanup = cleanup,
		})
		local hit = Utility.Create("TextButton", {
			Name = "Hit",
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			ZIndex = 2,
			Parent = self.Frame,
		})
		Widgets.Interactive(cleanup, self.Frame, hit, {})
		cleanup:Add(hit.Activated:Connect(function()
			if self.Enabled and not self:IsLocked() then
				Widgets.Pulse(self._arrow.Instance, 0.6, 0.35)
				Animation:Play(self._arrow.Instance, { Position = UDim2.fromOffset(4, 0) }, { Duration = 0.12 })
				task.delay(0.12, function()
					if self._arrow.Instance.Parent then
						Animation:Play(self._arrow.Instance, { Position = UDim2.new() }, { Duration = 0.18 })
					end
				end)
			end
			self:Fire()
		end))
		return self
	end
end
end)()

__modules["Components/Toggle"] = (function()
return function(import)
	local Component = import("Core/Component")
	local Utility = import("Core/Utility")
	local Widgets = import("Core/Widgets")
	local Theme = import("Core/Theme")
	local Animation = import("Services/Animation")

	local Toggle = setmetatable({}, { __index = Component.Base })
	Toggle.__index = Toggle

	function Toggle:_Normalize(value)
		if type(value) == "boolean" then
			return true, value
		end
		return false
	end

	function Toggle:Flip()
		self.State:Set(not self.State:Get())
		return self
	end

	return function(ctx, id, config)
		Utility.Check(
			config.Default == nil or type(config.Default) == "boolean",
			"Toggle",
			id,
			"Default value must be boolean."
		)
		local extra = config.Picker and 62 or 0
		local self = Component.New(ctx, Toggle, "Toggle", id, config, {
			RightWidth = 38 + extra,
			RightHeight = 22,
		})
		local cleanup = self.Cleanup

		local track, trackStroke = Widgets.Surface(cleanup, {
			Name = "Track",
			Parent = self.Right,
			Fill = "TertiaryBackground",
			Stroke = "Border",
			StrokeTransparency = 0.45,
			Radius = "Full",
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, 0, 0.5, 0),
			Size = UDim2.fromOffset(38, 20),
		})

		if config.Picker then
			local slot = Utility.Create("Frame", {
				Name = "Picker",
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(0, 0.5),
				Position = UDim2.new(0, 0, 0.5, 0),
				Size = UDim2.fromOffset(56, 22),
				ZIndex = 3,
				Parent = self.Right,
			})
			local settings = typeof(config.Picker) == "Color3" and { Default = config.Picker } or config.Picker
			settings = table.clone(settings)
			settings.Title = settings.Title or (config.Title or "") .. " color"
			settings.Search = false
			settings.Menu = false
			local factory = Component.Registry.Colorpicker
			if factory then
				self.Picker = factory({
					Host = slot,
					Parent = slot,
					Window = self.Window,
					Tab = self.Tab,
					Section = self.Section,
					Cleanup = cleanup,
					Order = function()
						return 1
					end,
				}, id and (id .. "/Picker") or nil, settings)
			end
		end
		local knob = Widgets.Surface(cleanup, {
			Name = "Knob",
			Parent = track,
			Fill = "MutedText",
			Radius = "Full",
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0, 3, 0.5, 0),
			Size = UDim2.fromOffset(14, 14),
		})
		self._track, self._knob = track, knob

		local activeColor = config.Color or config.ActiveColor or "Accent"
		local knobColor = config.KnobColor or "AccentText"

		local function render(value, animate)
			local trackColor = value and Theme.Resolve(activeColor, "Accent") or Theme.Get("TertiaryBackground")
			local dotColor = value and Theme.Resolve(knobColor, "AccentText") or Theme.Get("MutedText")
			local position = value and UDim2.new(1, -17, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)
			local alpha = value and 0 or Theme.Get("ElementTransparency")
			if animate then
				Animation:Play(track, { BackgroundColor3 = trackColor, BackgroundTransparency = alpha }, { Duration = 0.15 })
				Animation:Play(knob, { BackgroundColor3 = dotColor, Position = position }, {
					Duration = 0.22,
					Style = Enum.EasingStyle.Back,
				})
				Animation:Play(knob, { Size = UDim2.fromOffset(value and 16 or 14, value and 16 or 14) }, { Duration = 0.1 })
				task.delay(0.1, function()
					if knob.Parent then
						Animation:Play(knob, { Size = UDim2.fromOffset(14, 14) }, { Duration = 0.14 })
					end
				end)
			else
				track.BackgroundColor3 = trackColor
				track.BackgroundTransparency = alpha
				knob.BackgroundColor3 = dotColor
				knob.Position = position
			end
			trackStroke.Transparency = value and 1 or 0.45
		end
		Component.BindValue(self, id, config.Default == true, render)

		local hit = Utility.Create("TextButton", {
			Name = "Hit",
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			ZIndex = 2,
			Parent = self.Frame,
		})
		Widgets.Interactive(cleanup, self.Frame, hit, {})
		cleanup:Add(hit.Activated:Connect(function()
			self.State:Set(not self.State:Get())
		end))

		function self:SetColor(color)
			activeColor = color
			render(self.State:Get(), true)
			return self
		end

		return self
	end
end
end)()

__modules["Components/Slider"] = (function()
return function(import)
	local Component = import("Core/Component")
	local Utility = import("Core/Utility")
	local Widgets = import("Core/Widgets")
	local Theme = import("Core/Theme")
	local Animation = import("Services/Animation")
	local Drag = import("Services/Drag")

	local Slider = setmetatable({}, { __index = Component.Base })
	Slider.__index = Slider

	function Slider:_Snap(value)
		value = math.clamp(value, self._min, self._max)
		if self._increment then
			value = self._min + math.floor((value - self._min) / self._increment + 0.5) * self._increment
		end
		return math.clamp(Utility.Round(value, self._rounding), self._min, self._max)
	end

	function Slider:_Normalize(value)
		if type(value) ~= "number" or value ~= value then
			return false
		end
		return true, self:_Snap(value)
	end

	function Slider:SetRange(min, max)
		Utility.Check(
			type(min) == "number" and type(max) == "number" and min < max,
			self.Kind,
			self.Id,
			"Min and Max must be numbers with Min < Max."
		)
		self._min, self._max = min, max
		self.State:Set(self:_Snap(self.State:Get()))
		self._render(self.State:Get(), true)
		return self
	end

	return function(ctx, id, config)
		local min, max = config.Min, config.Max
		Utility.Check(
			type(min) == "number" and type(max) == "number" and min < max,
			"Slider",
			id,
			"Min and Max must be numbers with Min < Max."
		)
		local default = config.Default
		if default == nil then
			default = min
		end
		Utility.Check(type(default) == "number", "Slider", id, "Default must be a number.")
		Utility.Check(
			config.Increment == nil or (type(config.Increment) == "number" and config.Increment > 0),
			"Slider",
			id,
			"Increment must be a positive number."
		)

		local self = Component.New(ctx, Slider, "Slider", id, config, { RightWidth = 206, RightHeight = 24 })
		self._min, self._max, self._increment = min, max, config.Increment
		self._rounding = math.clamp(config.Rounding or ((config.Increment and config.Increment % 1 ~= 0) and 2 or 0), 0, 6)
		local cleanup = self.Cleanup
		local _, defaultValue = self:_Normalize(default)
		local accent = config.Color or "Accent"

		local bar = Utility.Create("TextButton", {
			Name = "Bar",
			BackgroundTransparency = 1,
			Size = UDim2.new(1, -58, 1, 0),
			Parent = self.Right,
		})
		local track = Widgets.Surface(cleanup, {
			Name = "Track",
			Parent = bar,
			Fill = "TertiaryBackground",
			Transparency = "ElementTransparency",
			Radius = "Full",
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0, 6, 0.5, 0),
			Size = UDim2.new(1, -12, 0, 4),
		})
		local fill = Widgets.Surface(cleanup, {
			Name = "Fill",
			Parent = track,
			Fill = accent,
			Radius = "Full",
			Size = UDim2.fromScale(0, 1),
		})
		local knob = Widgets.Surface(cleanup, {
			Name = "Knob",
			Parent = track,
			Fill = accent,
			Stroke = "Background",
			Radius = "Full",
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0, 0.5),
			Size = UDim2.fromOffset(12, 12),
		})
		self._track, self._fill, self._knob = track, fill, knob

		local boxFrame, box = Widgets.Field(cleanup, {
			Name = "Value",
			Parent = self.Right,
			Radius = 9,
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, 0, 0.5, 0),
			Size = UDim2.fromOffset(50, 22),
			Inset = 4,
			Trail = 4,
			TextXAlignment = Enum.TextXAlignment.Center,
		})
		self._box = box

		local format = "%." .. tostring(self._rounding) .. "f"
		local suffix = config.Suffix or ""
		local function render(value, animate)
			local alpha = (value - self._min) / (self._max - self._min)
			local fillSize, knobPosition = UDim2.fromScale(alpha, 1), UDim2.fromScale(alpha, 0.5)
			if animate then
				Animation:Play(fill, { Size = fillSize }, { Duration = 0.08 })
				Animation:Play(knob, { Position = knobPosition }, { Duration = 0.08 })
			else
				fill.Size, knob.Position = fillSize, knobPosition
			end
			if not box:IsFocused() then
				box.Text = string.format(format, value) .. suffix
			end
		end
		self._render = render
		Component.BindValue(self, id, defaultValue, render)

		Drag.Track(bar, cleanup, function(position)
			if not self.Enabled then
				return
			end
			if not self._dragging then
				self._dragging = true
				Animation:Play(knob, { Size = UDim2.fromOffset(16, 16) }, { Duration = 0.12, Style = Enum.EasingStyle.Back })
				Animation:Play(track, { Size = UDim2.new(1, -12, 0, 6) }, { Duration = 0.12 })
			end
			local alpha = math.clamp(
				(position.X - track.AbsolutePosition.X) / math.max(track.AbsoluteSize.X, 1),
				0,
				1
			)
			self.State:Set(self:_Snap(self._min + alpha * (self._max - self._min)))
		end, function()
			self._dragging = false
			if knob.Parent then
				Animation:Play(knob, { Size = UDim2.fromOffset(12, 12) }, { Duration = 0.16 })
				Animation:Play(track, { Size = UDim2.new(1, -12, 0, 4) }, { Duration = 0.16 })
			end
		end)
		cleanup:Add(box.FocusLost:Connect(function()
			local number = tonumber((string.gsub(box.Text, "[^%-%d%.]", "")))
			if number then
				self:SetValue(number)
			end
			box.Text = string.format(format, self.State:Get()) .. suffix
		end))

		function self:SetColor(color)
			fill.BackgroundColor3 = Theme.Resolve(color, "Accent")
			knob.BackgroundColor3 = Theme.Resolve(color, "Accent")
			return self
		end

		return self
	end
end
end)()

__modules["Components/Dropdown"] = (function()
return function(import)
	local Component = import("Core/Component")
	local Utility = import("Core/Utility")
	local Signal = import("Core/Signal")
	local Widgets = import("Core/Widgets")
	local Theme = import("Core/Theme")
	local Markup = import("Core/Markup")
	local Editable = import("Core/Editable")
	local Icons = import("Icons/Icon")
	local Animation = import("Services/Animation")
	local Capabilities = import("Core/Capabilities")

	local Dropdown = setmetatable({}, { __index = Component.Base })
	Dropdown.__index = Dropdown

	local ROW = Capabilities.Mobile and 34 or 28

	function Dropdown:_Normalize(value)
		if self.Multi then
			if type(value) ~= "table" then
				return false
			end
			local isArray = value[1] ~= nil
			local map = {}
			for _, name in self.Values do
				if isArray then
					map[name] = table.find(value, name) ~= nil
				else
					map[name] = value[name] == true
				end
			end
			return true, map
		end
		if value == nil then
			return true, nil
		end
		if type(value) == "number" then
			local name = self.Values[value]
			if name == nil then
				return false
			end
			return true, name
		end
		if type(value) == "string" and table.find(self.Values, value) then
			return true, value
		end
		return false
	end

	function Dropdown:_Display(value)
		if self.Multi then
			local picked = {}
			for _, name in self.Values do
				if value and value[name] then
					table.insert(picked, self:GetLabel(name))
				end
			end
			if #picked == 0 then
				return self.Config.Placeholder or "None"
			end
			if #picked > 2 then
				return string.format("%d selected", #picked)
			end
			return table.concat(picked, ", ")
		end
		if value == nil then
			return self.Config.Placeholder or "None"
		end
		return self:GetLabel(value)
	end

	function Dropdown:GetLabel(name)
		local meta = self.Meta[name]
		return meta and meta.Title or name
	end

	function Dropdown:GetValues()
		return table.clone(self.Values)
	end

	function Dropdown:GetSelected()
		local value = self.State:Get()
		if not self.Multi then
			return value
		end
		local picked = {}
		for _, name in self.Values do
			if value and value[name] then
				table.insert(picked, name)
			end
		end
		return picked
	end

	function Dropdown:_Commit()
		local valid, normalized = self:_Normalize(self.State:Get())
		if not valid then
			if self.Multi then
				_, normalized = self:_Normalize({})
			else
				normalized = self.Values[1]
			end
		end
		self.State:Set(normalized)
		self._render(self.State:Get())
		self.ValuesChanged:Fire(self:GetValues())
		Utility.SafeCall("Dropdown " .. tostring(self.Id), self.Config.OnValuesChanged, self:GetValues())
		if self._rebuild then
			self._rebuild()
		end
	end

	function Dropdown:SetValues(values)
		Utility.Check(type(values) == "table", self.Kind, self.Id, "Values must be an array.")
		local names, meta = {}, {}
		for _, entry in values do
			if type(entry) == "string" then
				table.insert(names, entry)
			elseif type(entry) == "table" then
				local name = entry.Value or entry.Name or entry.Title
				Utility.Check(type(name) == "string", self.Kind, self.Id, "Each value needs a string Value or Title.")
				table.insert(names, name)
				meta[name] = { Title = entry.Title or name, Icon = entry.Icon, Color = entry.Color }
			else
				Utility.Fail(self.Kind, self.Id, "Values must be strings or tables.")
			end
		end
		for name, icon in self.Config.Icons or {} do
			meta[name] = meta[name] or {}
			meta[name].Icon = meta[name].Icon or icon
		end
		for name, color in self.Config.Colors or {} do
			meta[name] = meta[name] or {}
			meta[name].Color = meta[name].Color or color
		end
		self.Values, self.Meta = names, meta
		self:_Commit()
		return self
	end

	function Dropdown:AddValue(name, options)
		Utility.Check(type(name) == "string" and name ~= "", self.Kind, self.Id, "Value must be a non-empty string.")
		if table.find(self.Values, name) then
			return self
		end
		table.insert(self.Values, name)
		if type(options) == "table" then
			self.Meta[name] = { Title = options.Title or name, Icon = options.Icon, Color = options.Color }
		end
		if self.Multi then
			local value = table.clone(self.State:Get() or {})
			value[name] = false
			self.State:Set(value, true)
		end
		self:_Commit()
		Utility.SafeCall("Dropdown " .. tostring(self.Id), self.Config.OnAdd, name)
		return self
	end

	function Dropdown:RemoveValue(name)
		local index = table.find(self.Values, name)
		if not index then
			return self
		end
		table.remove(self.Values, index)
		self.Meta[name] = nil
		if self.Multi then
			local value = table.clone(self.State:Get() or {})
			value[name] = nil
			self.State:Set(value, true)
		elseif self.State:Get() == name then
			self.State:Set(self.Values[math.min(index, #self.Values)], true)
		end
		self:_Commit()
		Utility.SafeCall("Dropdown " .. tostring(self.Id), self.Config.OnRemove, name)
		return self
	end

	function Dropdown:RenameValue(old, new)
		Utility.Check(type(new) == "string" and new ~= "", self.Kind, self.Id, "New value must be a non-empty string.")
		local index = table.find(self.Values, old)
		if not index or old == new then
			return self
		end
		if table.find(self.Values, new) then
			return self
		end
		self.Values[index] = new
		local meta = self.Meta[old]
		self.Meta[old] = nil
		if meta then
			if meta.Title == old then
				meta.Title = new
			end
			self.Meta[new] = meta
		end
		if self.Multi then
			local value = table.clone(self.State:Get() or {})
			value[new] = value[old] == true
			value[old] = nil
			self.State:Set(value, true)
		elseif self.State:Get() == old then
			self.State:Set(new, true)
		end
		self:_Commit()
		Utility.SafeCall("Dropdown " .. tostring(self.Id), self.Config.OnRename, old, new)
		return self
	end

	function Dropdown:SetOption(name, options)
		if not table.find(self.Values, name) or type(options) ~= "table" then
			return self
		end
		local meta = self.Meta[name] or {}
		meta.Title = options.Title or meta.Title or name
		meta.Icon = options.Icon ~= nil and options.Icon or meta.Icon
		meta.Color = options.Color ~= nil and options.Color or meta.Color
		self.Meta[name] = meta
		self._render(self.State:Get())
		if self._rebuild then
			self._rebuild()
		end
		return self
	end

	function Dropdown:Clear()
		self.Values = {}
		self.Meta = {}
		self:_Commit()
		return self
	end

	function Dropdown:SelectAll()
		if not self.Multi then
			return self
		end
		local value = {}
		for _, name in self.Values do
			value[name] = true
		end
		self.State:Set(value)
		return self
	end

	function Dropdown:SelectNone()
		if not self.Multi then
			self.State:Set(nil)
			return self
		end
		self.State:Set({})
		return self
	end

	function Dropdown:Close()
		if self._popup then
			self._popup.Close()
		end
		return self
	end

	function Dropdown:Open()
		self:_Open()
		return self
	end

	function Dropdown:_Open()
		if self._destroyed or not self.Enabled or self._popup then
			return
		end
		local config = self.Config
		local button = self._button
		local editable = config.Editable == true
		local creatable = config.Creatable == true
		local removable = config.Removable == true or (editable and config.Removable ~= false)
		local searchable = config.Searchable == true or (config.Searchable ~= false and #self.Values > 8)
		local maxVisible = config.MaxVisible or 7

		local width = math.max(config.PopupWidth or 190, button.AbsoluteSize.X / Theme.Scale)
		local headerHeight = searchable and 34 or 0
		local footerHeight = creatable and 32 or 0

		local function measure(count)
			local rows = math.clamp(count, 1, maxVisible) * ROW + 10
			return math.min(rows + headerHeight + footerHeight, 320)
		end

		local popup = self.Window:OpenPopup(button, width, measure(#self.Values))
		self._popup = popup
		local cleanup = popup.Cleanup
		if self._chevron then
			Animation:Play(self._chevron.Instance, { Rotation = 180 }, { Duration = 0.18 })
		end
		cleanup:Add(popup.Closed:Connect(function()
			if self._popup == popup then
				self._popup = nil
			end
			self._rebuild = nil
			self._filter = nil
			if self._chevron and self._chevron.Instance.Parent then
				Animation:Play(self._chevron.Instance, { Rotation = 0 }, { Duration = 0.18 })
			end
		end))

		local filterText = ""
		if searchable then
			local _, filterBox = Widgets.Field(cleanup, {
				Name = "Filter",
				Parent = popup.Frame,
				Radius = 8,
				Placeholder = "Filter...",
				Position = UDim2.fromOffset(5, 5),
				Size = UDim2.new(1, -10, 0, 24),
			})
			cleanup:Add(filterBox:GetPropertyChangedSignal("Text"):Connect(function()
				filterText = string.lower(filterBox.Text)
				if self._rebuild then
					self._rebuild()
				end
			end))
		end

		local list = Widgets.Scroller(cleanup, {
			Name = "Options",
			Parent = popup.Frame,
			Position = UDim2.fromOffset(0, headerHeight),
			Size = UDim2.new(1, 0, 1, -(headerHeight + footerHeight)),
		})
		Widgets.Padding(list, 5)
		Widgets.List(list, 2)

		local rows = cleanup:Extend()

		local function selected(name)
			local value = self.State:Get()
			if self.Multi then
				return value ~= nil and value[name] == true
			end
			return value == name
		end

		local function build()
			rows:Clean()
			rows = cleanup:Extend()
			local shown = 0
			for index, name in self.Values do
				local label = self:GetLabel(name)
				if filterText == "" or string.find(string.lower(Markup.Strip(label)), filterText, 1, true) then
					shown += 1
					local meta = self.Meta[name] or {}
					local row = Widgets.Surface(rows, {
						Class = "TextButton",
						Name = "Option",
						Parent = list,
						Fill = "SecondaryBackground",
						Transparency = 1,
						Radius = 8,
						Size = UDim2.new(1, 0, 0, ROW - 2),
						LayoutOrder = index,
					})
					rows:Add(row)

					local inset = 9
					if meta.Icon then
						local holder = Utility.Create("Frame", {
							BackgroundTransparency = 1,
							Position = UDim2.fromOffset(8, (ROW - 2) / 2 - 7),
							Size = UDim2.fromOffset(14, 14),
							Parent = row,
						})
						Icons.Create(holder, meta.Icon, {
							Size = 14,
							Color = meta.Color or "MutedText",
							Cleanup = rows,
						})
						inset = 29
					end

					local trail = 28
					if editable then
						trail += 22
					end
					if removable then
						trail += 22
					end

					local optionLabel, optionText = Widgets.Text(rows, {
						Class = editable and "TextBox" or "TextLabel",
						Parent = row,
						Text = label,
						Color = meta.Color,
						Position = UDim2.fromOffset(inset, 0),
						Size = UDim2.new(1, -(inset + trail), 1, 0),
						TextTruncate = Enum.TextTruncate.AtEnd,
						Markup = not editable,
					})

					local check = Icons.Create(row, config.CheckIcon or "check", {
						Size = 13,
						Color = config.CheckColor or "Accent",
						AnchorPoint = Vector2.new(1, 0.5),
						Position = UDim2.new(1, -9, 0.5, 0),
						Cleanup = rows,
					})
					check.Instance.Visible = selected(name)
					check.Instance.ZIndex = 2

					local actions = {}
					local offset = 28
					if editable then
						local pencil = Widgets.Chip(rows, {
							Name = "Rename",
							Parent = row,
							Radius = "Full",
							AnchorPoint = Vector2.new(1, 0.5),
							Position = UDim2.new(1, -offset, 0.5, 0),
							Size = UDim2.fromOffset(18, 18),
							ZIndex = 3,
							Visible = false,
						})
						Icons.Create(pencil, "pencil", {
							Size = 10,
							Position = UDim2.fromOffset(4, 4),
							Cleanup = rows,
						})
						table.insert(actions, pencil)
						offset += 22

						local editor = Editable.Attach(rows, optionLabel, optionText, {
							Label = "Dropdown option",
							Color = meta.Color,
							Trigger = pencil,
							Source = function()
								return self:GetLabel(name)
							end,
							Validate = function(value)
								return value ~= "" and (value == name or table.find(self.Values, value) == nil)
							end,
							OnCommit = function(value)
								self:RenameValue(name, value)
							end,
						})
						rows:Add(function()
							editor.Cancel()
						end)
					end
					if removable then
						local trash = Widgets.Chip(rows, {
							Name = "Remove",
							Parent = row,
							Radius = "Full",
							AnchorPoint = Vector2.new(1, 0.5),
							Position = UDim2.new(1, -offset, 0.5, 0),
							Size = UDim2.fromOffset(18, 18),
							ZIndex = 3,
							Visible = false,
						})
						Icons.Create(trash, "trash-2", {
							Size = 10,
							Color = "Error",
							Position = UDim2.fromOffset(4, 4),
							Cleanup = rows,
						})
						table.insert(actions, trash)
						rows:Add(trash.Activated:Connect(function()
							self:RemoveValue(name)
						end))
					end

					if #actions > 0 then
						rows:Add(row.MouseEnter:Connect(function()
							for _, action in actions do
								action.Visible = true
							end
							check.Instance.Visible = false
						end))
						rows:Add(row.MouseLeave:Connect(function()
							for _, action in actions do
								action.Visible = false
							end
							check.Instance.Visible = selected(name)
						end))
					end

					Widgets.Interactive(rows, row, row, { Alpha = { 1, 0.6, 0.45 } })
					rows:Add(row.Activated:Connect(function()
						if editable and optionLabel:IsFocused() then
							return
						end
						if self.Multi then
							local value = table.clone(self.State:Get() or {})
							value[name] = not value[name]
							self.State:Set(value)
						else
							self.State:Set(name)
							popup.Close()
						end
					end))
				end
			end

			if shown == 0 then
				rows:Add((Widgets.Text(rows, {
					Parent = list,
					Text = #self.Values == 0 and "No options" or "No matches",
					Color = "MutedText",
					TextXAlignment = Enum.TextXAlignment.Center,
					Size = UDim2.new(1, 0, 0, ROW),
					LayoutOrder = 1,
				})))
				shown = 1
			end
			popup.Resize(measure(shown))
		end
		self._rebuild = build
		build()

		if creatable then
			local addRow = Widgets.Surface(cleanup, {
				Class = "TextButton",
				Name = "Add",
				Parent = popup.Frame,
				Fill = "TertiaryBackground",
				Transparency = "ElementTransparency",
				Radius = 8,
				AnchorPoint = Vector2.new(0.5, 1),
				Position = UDim2.new(0.5, 0, 1, -5),
				Size = UDim2.new(1, -10, 0, 24),
			})
			Icons.Create(addRow, "plus", {
				Size = 12,
				Color = "Accent",
				Position = UDim2.fromOffset(8, 6),
				Cleanup = cleanup,
			})
			local addLabel, addText = Widgets.Text(cleanup, {
				Class = "TextBox",
				Parent = addRow,
				Text = config.AddText or "Add option",
				Color = "MutedText",
				TextSize = 12,
				Position = UDim2.fromOffset(26, 0),
				Size = UDim2.new(1, -34, 1, 0),
				Markup = false,
			})
			Widgets.Interactive(cleanup, addRow, addRow, { Base = "TertiaryBackground" })
			local adding = Editable.Attach(cleanup, addLabel, addText, {
				Label = "Dropdown add",
				Color = "MutedText",
				Trigger = addRow,
				Source = function()
					return ""
				end,
				Validate = function(value)
					return value ~= "" and table.find(self.Values, value) == nil
				end,
				OnCommit = function(value)
					self:AddValue(value)
					addText.SetText(config.AddText or "Add option")
				end,
			})
			cleanup:Add(function()
				adding.Cancel()
			end)
		end
	end

	return function(ctx, id, config)
		local values = config.Values or {}
		Utility.Check(type(values) == "table", "Dropdown", id, "Values must be an array.")
		local multi = config.Multi == true
		local self = Component.New(ctx, Dropdown, multi and "MultiDropdown" or "Dropdown", id, config, {
			RightWidth = config.Width or 172,
			RightHeight = 26,
		})
		self.Multi = multi
		self.Values, self.Meta = {}, {}
		self.ValuesChanged = Signal.new()
		local cleanup = self.Cleanup
		cleanup:Add(self.ValuesChanged)

		local names = {}
		for _, entry in values do
			if type(entry) == "string" then
				table.insert(names, entry)
			elseif type(entry) == "table" then
				local name = entry.Value or entry.Name or entry.Title
				Utility.Check(type(name) == "string", "Dropdown", id, "Each value needs a string Value or Title.")
				table.insert(names, name)
				self.Meta[name] = { Title = entry.Title or name, Icon = entry.Icon, Color = entry.Color }
			else
				Utility.Fail("Dropdown", id, "Values must be strings or tables.")
			end
		end
		for name, icon in config.Icons or {} do
			self.Meta[name] = self.Meta[name] or {}
			self.Meta[name].Icon = self.Meta[name].Icon or icon
		end
		for name, color in config.Colors or {} do
			self.Meta[name] = self.Meta[name] or {}
			self.Meta[name].Color = self.Meta[name].Color or color
		end
		self.Values = names

		local valid, default = self:_Normalize(multi and (config.Default or {}) or config.Default)
		Utility.Check(
			valid,
			self.Kind,
			id,
			multi and "Default must be a table ({ Name = true } or an array of names)."
				or "Default must be a value (or index) from Values."
		)

		local button, buttonStroke = Widgets.Surface(cleanup, {
			Class = "TextButton",
			Name = "Select",
			Parent = self.Right,
			Fill = "TertiaryBackground",
			Transparency = "ElementTransparency",
			Stroke = "Border",
			StrokeTransparency = 0.45,
			Radius = 10,
			Size = UDim2.fromScale(1, 1),
		})
		self._button, self._buttonStroke = button, buttonStroke
		local _, label = Widgets.Text(cleanup, {
			Parent = button,
			Position = UDim2.fromOffset(10, 0),
			Size = UDim2.new(1, -32, 1, 0),
			TextSize = 12,
			TextTruncate = Enum.TextTruncate.AtEnd,
		})
		self._label = label
		self._chevron = Icons.Create(button, "chevron-down", {
			Size = 13,
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, -8, 0.5, 0),
			Cleanup = cleanup,
		})
		Widgets.Interactive(cleanup, button, button, { Base = "TertiaryBackground" })

		self._render = function(value)
			label.SetText(self:_Display(value))
		end
		Component.BindValue(self, id, default, function(value)
			self._render(value)
		end)
		cleanup:Add(button.Activated:Connect(function()
			if self._popup then
				self:Close()
				return
			end
			self:_Open()
		end))
		cleanup:Add(function()
			if self._popup then
				self._popup.Close()
			end
		end)
		return self
	end
end
end)()

__modules["Components/MultiDropdown"] = (function()
return function(import)
	local Dropdown = import("Components/Dropdown")

	return function(ctx, id, config)
		config.Multi = true
		return Dropdown(ctx, id, config)
	end
end
end)()

__modules["Components/Input"] = (function()
return function(import)
	local Component = import("Core/Component")
	local Utility = import("Core/Utility")
	local Widgets = import("Core/Widgets")
	local Icons = import("Icons/Icon")

	local TextInput = setmetatable({}, { __index = Component.Base })
	TextInput.__index = TextInput

	function TextInput:_Normalize(value)
		if type(value) == "string" then
			return true, value
		elseif type(value) == "number" then
			return true, tostring(value)
		elseif value == nil then
			return true, ""
		end
		return false
	end

	function TextInput:SetPlaceholder(text)
		self._box.PlaceholderText = text or ""
		return self
	end

	function TextInput:Focus()
		self._box:CaptureFocus()
		return self
	end

	function TextInput:Clear()
		self.State:Set("")
		return self
	end

	return function(ctx, id, config)
		Utility.Check(config.Default == nil or type(config.Default) == "string", "Input", id, "Default must be a string.")
		Utility.Check(
			config.MaxLength == nil or type(config.MaxLength) == "number",
			"Input",
			id,
			"MaxLength must be a number."
		)
		Utility.Check(
			config.Validate == nil or type(config.Validate) == "function",
			"Input",
			id,
			"Validate must be a function."
		)
		local self = Component.New(ctx, TextInput, "Input", id, config, {
			RightWidth = config.Width or 190,
			RightHeight = config.Height or 26,
		})
		local cleanup = self.Cleanup

		local holder, box, stroke, field = Widgets.Field(cleanup, {
			Name = "Input",
			Parent = self.Right,
			Radius = 10,
			Placeholder = config.Placeholder or "",
			Trail = 26,
			Size = UDim2.fromScale(1, 1),
		})
		self._box, self._field = box, field
		if config.TextColor then
			box.TextColor3 = Utility.FromHex(config.TextColor) or box.TextColor3
		end

		local clear = Utility.Create("TextButton", {
			Name = "Clear",
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, -5, 0.5, 0),
			Size = UDim2.fromOffset(18, 18),
			Visible = false,
			Parent = holder,
		})
		Icons.Create(clear, "x", { Size = 11, Position = UDim2.fromOffset(3.5, 3.5), Cleanup = cleanup })

		local function validate(text)
			if config.MaxLength and #text > config.MaxLength then
				return false
			end
			if config.Numeric and text ~= "" and tonumber(text) == nil then
				return false
			end
			if config.Validate then
				local ok, result = pcall(config.Validate, text)
				if not ok or result == false then
					return false
				end
			end
			return true
		end

		Component.BindValue(self, id, config.Default or "", function(value)
			if box.Text ~= value then
				box.Text = value
			end
		end)

		cleanup:Add(box:GetPropertyChangedSignal("Text"):Connect(function()
			local text = box.Text
			if config.MaxLength and #text > config.MaxLength then
				box.Text = string.sub(text, 1, config.MaxLength)
				return
			end
			clear.Visible = text ~= "" and config.ClearButton ~= false
			if config.Live and validate(text) then
				self.State:Set(text)
			end
		end))
		cleanup:Add(box.FocusLost:Connect(function()
			if validate(box.Text) then
				self.State:Set(box.Text)
			else
				box.Text = self.State:Get()
				field.Flash("Error")
			end
		end))
		cleanup:Add(clear.Activated:Connect(function()
			box.Text = ""
			self.State:Set("")
		end))
		clear.Visible = box.Text ~= "" and config.ClearButton ~= false
		return self
	end
end
end)()

__modules["Components/Keybind"] = (function()
return function(import)
	local Component = import("Core/Component")
	local Utility = import("Core/Utility")
	local Signal = import("Core/Signal")
	local Widgets = import("Core/Widgets")
	local Theme = import("Core/Theme")
	local Icons = import("Icons/Icon")
	local InputService = import("Services/Input")
	local Notification = import("Services/Notification")

	local Keybind = setmetatable({}, { __index = Component.Base })
	Keybind.__index = Keybind

	local MOUSE = {
		[Enum.UserInputType.MouseButton1] = "Mouse 1",
		[Enum.UserInputType.MouseButton2] = "Mouse 2",
		[Enum.UserInputType.MouseButton3] = "Mouse 3",
	}

	local MODES = { "Press", "Toggle", "Hold", "Always" }

	local function display(key)
		if typeof(key) ~= "EnumItem" or key == Enum.KeyCode.Unknown then
			return "None"
		end
		return MOUSE[key] or key.Name
	end

	local function parse(value)
		if typeof(value) == "EnumItem" then
			if value.EnumType == Enum.KeyCode or value.EnumType == Enum.UserInputType then
				return true, value
			end
			return false
		end
		if value == nil or value == "None" then
			return true, Enum.KeyCode.Unknown
		end
		if type(value) == "string" then
			local ok, item = pcall(function()
				return Enum.KeyCode[value]
			end)
			if ok and item then
				return true, item
			end
		end
		return false
	end

	function Keybind:_Normalize(value)
		return parse(value)
	end

	function Keybind:_Emit(value)
		if self._destroyed then
			return
		end
		Utility.SafeCall("Keybind " .. tostring(self.Id), self.Config.ChangedCallback, value)
		self.Changed:Fire(value)
	end

	function Keybind:OnClick(callback)
		return self.Clicked:Connect(callback)
	end

	function Keybind:GetState()
		if self.Mode == "Always" then
			return true
		end
		return self.Toggled == true
	end

	function Keybind:SetMode(mode)
		if not table.find(MODES, mode) then
			return self
		end
		local changed = self.Mode ~= mode
		self.Mode = mode
		if mode == "Always" then
			self.Toggled = true
		elseif mode ~= "Toggle" then
			self.Toggled = false
		end
		if self._modeLabel then
			self._modeLabel.SetText(mode)
			self._modeLabel.Instance.Visible = mode ~= "Press"
			if changed then
				Widgets.Pulse(self._modeLabel.Instance, 0.8, 0.3)
			end
		end
		Utility.SafeCall("Keybind " .. tostring(self.Id), self.Config.ModeCallback, mode)
		return self
	end

	function Keybind:Reset()
		self.State:Set(self._default)
		return self
	end

	return function(ctx, id, config)
		local valid, default = parse(config.Default)
		Utility.Check(valid, "Keybind", id, "Default must be an Enum.KeyCode, a mouse UserInputType or a key name.")
		local self = Component.New(ctx, Keybind, "Keybind", id, config, { RightWidth = 132, RightHeight = 26 })
		local cleanup = self.Cleanup
		self._default = default
		self.Mode = table.find(MODES, config.Mode or "") and config.Mode or "Press"
		self.Toggled = self.Mode == "Always"
		self.Clicked = Signal.new()
		cleanup:Add(self.Clicked)

		local modeHolder = Utility.Create("Frame", {
			Name = "Mode",
			BackgroundTransparency = 1,
			Size = UDim2.fromOffset(52, 26),
			Parent = self.Right,
		})
		local _, modeLabel = Widgets.Text(cleanup, {
			Parent = modeHolder,
			Text = self.Mode,
			Color = "MutedText",
			TextSize = 11,
			TextXAlignment = Enum.TextXAlignment.Right,
			Size = UDim2.fromScale(1, 1),
			Visible = self.Mode ~= "Press",
		})
		self._modeLabel = modeLabel

		local button = Widgets.Surface(cleanup, {
			Class = "TextButton",
			Name = "Key",
			Parent = self.Right,
			Fill = "TertiaryBackground",
			Transparency = "ElementTransparency",
			Stroke = "Border",
			StrokeTransparency = 0.45,
			Radius = 10,
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, 0, 0.5, 0),
			Size = UDim2.fromOffset(74, 26),
		})
		local _, label = Widgets.Text(cleanup, {
			Parent = button,
			Size = UDim2.fromScale(1, 1),
			TextXAlignment = Enum.TextXAlignment.Center,
			TextSize = 12,
			TextTruncate = Enum.TextTruncate.AtEnd,
			Markup = false,
		})
		Widgets.Interactive(cleanup, button, button, { Base = "TertiaryBackground" })
		self._button, self._label = button, label

		local buttonStroke = button:FindFirstChildOfClass("UIStroke")
		Component.BindValue(self, id, default, function(value, animate)
			label.SetText(display(value))
			if self._bind then
				self._bind:SetKey(value)
			end
			if animate then
				Widgets.Pulse(button, 0.86, 0.3)
				Widgets.Glow(buttonStroke, "Accent", 0.4)
			end
		end)

		local function trigger(key)
			if not self.Enabled or self._destroyed then
				return
			end
			if self.Mode == "Toggle" then
				self.Toggled = not self.Toggled
				Utility.SafeCall("Keybind " .. tostring(self.Id), config.Callback, self.Toggled)
			elseif self.Mode == "Hold" or self.Mode == "Always" then
				Utility.SafeCall("Keybind " .. tostring(self.Id), config.Callback, true)
			else
				Utility.SafeCall("Keybind " .. tostring(self.Id), config.Callback, key)
			end
			self.Clicked:Fire(key)
		end

		self._bind = cleanup:Add(InputService.AddBind(
			self.State:Get(),
			trigger,
			"Keybind " .. tostring(config.Title or id or "?")
		))

		if self.Mode == "Hold" then
			cleanup:Add(InputService.Ended:Connect(function(input)
				local key = self.State:Get()
				if typeof(key) ~= "EnumItem" or not self.Enabled then
					return
				end
				local matched = key.EnumType == Enum.KeyCode and input.KeyCode == key or input.UserInputType == key
				if matched and self.Toggled then
					self.Toggled = false
					Utility.SafeCall("Keybind " .. tostring(self.Id), config.Callback, false)
				end
			end))
			cleanup:Add(self.Clicked:Connect(function()
				self.Toggled = true
			end))
		end

		cleanup:Add(button.Activated:Connect(function()
			if self._capturing or not self.Enabled then
				return
			end
			self._capturing = true
			label.SetText("...")
			Widgets.Pulse(button, 0.9, 0.25)
			Widgets.Glow(buttonStroke, "Accent", 6)
			self._cancel = InputService.Capture(function(key, cancelled)
				self._capturing, self._cancel = false, nil
				if self._destroyed then
					return
				end
				if not cancelled then
					local conflict = InputService.FindConflict(key, self._bind)
					if conflict then
						Notification.Notify({
							Type = "Warning",
							Title = "Keybind conflict",
							Content = string.format('%s is also used by "%s".', display(key), conflict.Label),
						})
					end
					self.State:Set(key)
				end
				label.SetText(display(self.State:Get()))
			end)
		end))

		cleanup:Add(button.MouseButton2Click:Connect(function()
			if self._capturing or not self.Enabled then
				return
			end
			local popup = self.Window:OpenPopup(button, 120, #MODES * 26 + 36)
			local pcl = popup.Cleanup
			Widgets.Padding(popup.Frame, 5)
			Widgets.List(popup.Frame, 2)
			for index, mode in MODES do
				local row = Widgets.Surface(pcl, {
					Class = "TextButton",
					Parent = popup.Frame,
					Fill = "SecondaryBackground",
					Transparency = 1,
					Radius = 8,
					Size = UDim2.new(1, 0, 0, 24),
					LayoutOrder = index,
				})
				Widgets.Text(pcl, {
					Parent = row,
					Text = mode,
					TextSize = 12,
					Position = UDim2.fromOffset(8, 0),
					Size = UDim2.new(1, -28, 1, 0),
				})
				local check = Icons.Create(row, "check", {
					Size = 13,
					Color = "Accent",
					AnchorPoint = Vector2.new(1, 0.5),
					Position = UDim2.new(1, -8, 0.5, 0),
					Cleanup = pcl,
				})
				check.Instance.Visible = self.Mode == mode
				Widgets.Interactive(pcl, row, row, { Alpha = { 1, 0.6, 0.45 } })
				pcl:Add(row.Activated:Connect(function()
					self:SetMode(mode)
					popup.Close()
				end))
			end
			local reset = Widgets.Surface(pcl, {
				Class = "TextButton",
				Parent = popup.Frame,
				Fill = "TertiaryBackground",
				Radius = 8,
				Size = UDim2.new(1, 0, 0, 24),
				LayoutOrder = #MODES + 1,
			})
			Widgets.Text(pcl, {
				Parent = reset,
				Text = "Reset key",
				Color = "MutedText",
				TextSize = 12,
				Position = UDim2.fromOffset(8, 0),
				Size = UDim2.new(1, -16, 1, 0),
			})
			Widgets.Interactive(pcl, reset, reset, { Base = "TertiaryBackground" })
			pcl:Add(reset.Activated:Connect(function()
				self:Reset()
				popup.Close()
			end))
		end))

		cleanup:Add(function()
			if self._cancel then
				self._cancel()
			end
		end)
		return self
	end
end
end)()

__modules["Components/Colorpicker"] = (function()
return function(import)
	local Component = import("Core/Component")
	local Utility = import("Core/Utility")
	local Widgets = import("Core/Widgets")
	local Theme = import("Core/Theme")
	local State = import("Core/State")
	local Config = import("Core/Config")
	local Capabilities = import("Core/Capabilities")
	local Icons = import("Icons/Icon")
	local Drag = import("Services/Drag")
	local Animation = import("Services/Animation")

	local Colorpicker = setmetatable({}, { __index = Component.Base })
	Colorpicker.__index = Colorpicker

	local SWATCH_KEY = "DeaDx/Swatches"
	local DEFAULT_SWATCHES = { "#FF2D40", "#FB923C", "#FACC15", "#4ADE80", "#38BDF8", "#A855F7", "#FFFFFF" }

	local function to255(value)
		return math.floor(value * 255 + 0.5)
	end

	local function sameColor(a, b)
		return to255(a.R) == to255(b.R) and to255(a.G) == to255(b.G) and to255(a.B) == to255(b.B)
	end

	local function swatches()
		local state = Config:Register(SWATCH_KEY, table.clone(DEFAULT_SWATCHES))
		local value = state:Get()
		if type(value) ~= "table" then
			value = table.clone(DEFAULT_SWATCHES)
			state:Set(value)
		end
		return state, value
	end

	function Colorpicker:_Normalize(value)
		if typeof(value) == "Color3" then
			return true, value
		end
		if type(value) == "string" then
			local color = Utility.FromHex(value)
			if color then
				return true, color
			end
		end
		return false
	end

	function Colorpicker:_Emit(value)
		if self._destroyed then
			return
		end
		local transparency = self.TransparencyState:Get()
		Utility.SafeCall("Colorpicker " .. tostring(self.Id), self.Config.Callback, value, transparency)
		self.Changed:Fire(value, transparency)
	end

	function Colorpicker:GetTransparency()
		return self.TransparencyState:Get()
	end

	function Colorpicker:SetTransparency(value)
		if type(value) == "number" then
			self.TransparencyState:Set(math.clamp(value, 0, 1))
		end
		return self
	end

	function Colorpicker:SetValueRGB(color, transparency)
		self:SetValue(color)
		if transparency ~= nil then
			self:SetTransparency(transparency)
		end
		return self
	end

	function Colorpicker:GetHex()
		return Utility.ToHex(self.State:Get())
	end

	function Colorpicker:Copy()
		return Capabilities.SetClipboard(self:GetHex())
	end

	function Colorpicker:Paste()
		return false
	end

	function Colorpicker:Reset()
		self:SetRainbow(false)
		self.State:Set(self._default)
		if self._hasAlpha then
			self.TransparencyState:Set(self._defaultAlpha)
		end
		return self
	end

	function Colorpicker:IsRainbow()
		return self._rainbow == true
	end

	function Colorpicker:SetRainbow(enabled, speed)
		enabled = enabled == true
		if self._rainbowThread then
			pcall(task.cancel, self._rainbowThread)
			self._rainbowThread = nil
		end
		self._rainbow = enabled
		self._rainbowSpeed = speed or self._rainbowSpeed or 0.22
		if self._rainbowButton then
			self._rainbowButton()
		end
		if not enabled then
			return self
		end
		self._rainbowThread = task.spawn(function()
			while self._rainbow and not self._destroyed do
				local hue = (os.clock() * self._rainbowSpeed) % 1
				self._h = hue
				local saturation = self._s > 0.15 and self._s or 1
				local brightness = self._v > 0.15 and self._v or 1
				self.State:Set(Color3.fromHSV(hue, saturation, brightness))
				task.wait(0.05)
			end
		end)
		self.Cleanup:Add(self._rainbowThread)
		return self
	end

	function Colorpicker:Save()
		local state, list = swatches()
		local hex = self:GetHex()
		if not table.find(list, hex) then
			local copy = table.clone(list)
			table.insert(copy, 1, hex)
			while #copy > 18 do
				table.remove(copy)
			end
			state:Set(copy)
		end
		return self
	end

	function Colorpicker:Harmonies()
		local h, s, v = self._h, self._s, self._v
		return {
			{ Name = "Comp", Color = Color3.fromHSV((h + 0.5) % 1, s, v) },
			{ Name = "Tri A", Color = Color3.fromHSV((h + 1 / 3) % 1, s, v) },
			{ Name = "Tri B", Color = Color3.fromHSV((h + 2 / 3) % 1, s, v) },
			{ Name = "Ana A", Color = Color3.fromHSV((h + 0.083) % 1, s, v) },
			{ Name = "Ana B", Color = Color3.fromHSV((h - 0.083) % 1, s, v) },
			{ Name = "Shade", Color = Color3.fromHSV(h, s, math.clamp(v * 0.6, 0, 1)) },
			{ Name = "Tint", Color = Color3.fromHSV(h, math.clamp(s * 0.5, 0, 1), math.clamp(v * 1.2, 0, 1)) },
		}
	end

	local HUES = {}
	for step = 0, 6 do
		table.insert(HUES, ColorSequenceKeypoint.new(step / 6, Color3.fromHSV(math.min(step / 6, 1), 1, 1)))
	end

	return function(ctx, id, config)
		local default = config.Default or Color3.new(1, 1, 1)
		if type(default) == "string" then
			default = Utility.FromHex(default) or Color3.new(1, 1, 1)
		end
		Utility.Check(typeof(default) == "Color3", "Colorpicker", id, "Default must be a Color3 or a hex string.")
		local hasAlpha = config.Transparency ~= nil
		Utility.Check(
			not hasAlpha or (type(config.Transparency) == "number" and config.Transparency >= 0 and config.Transparency <= 1),
			"Colorpicker",
			id,
			"Transparency must be a number between 0 and 1."
		)

		local self = Component.New(ctx, Colorpicker, "Colorpicker", id, config, { RightWidth = 56, RightHeight = 22 })
		local cleanup = self.Cleanup
		self._default, self._hasAlpha, self._defaultAlpha = default, hasAlpha, config.Transparency or 0

		if id then
			self.TransparencyState = Config:Register(id .. "/Transparency", self._defaultAlpha)
		else
			self.TransparencyState = cleanup:Add(State.new(self._defaultAlpha))
		end
		self._h, self._s, self._v = default:ToHSV()

		local swatch = Widgets.Surface(cleanup, {
			Class = "TextButton",
			Name = "Swatch",
			Parent = self.Right,
			Stroke = "Border",
			StrokeTransparency = 0.3,
			Radius = 9,
			BackgroundTransparency = 0,
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, 0, 0.5, 0),
			Size = UDim2.fromOffset(44, 22),
		})
		self._swatch = swatch

		local rainbowDot = Icons.Create(self.Right, "sparkles", {
			Size = 13,
			Color = "Accent",
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0, 0, 0.5, 0),
			Cleanup = cleanup,
		})
		rainbowDot.Instance.Visible = false

		local function paintSwatch()
			swatch.BackgroundColor3 = self.State:Get()
			swatch.BackgroundTransparency = hasAlpha and self.TransparencyState:Get() or 0
			rainbowDot.Instance.Visible = self._rainbow == true
		end
		Component.BindValue(self, id, default, function(color)
			if not sameColor(color, Color3.fromHSV(self._h, self._s, self._v)) then
				self._h, self._s, self._v = color:ToHSV()
			end
			paintSwatch()
		end)
		cleanup:Add(self.TransparencyState.Changed:Connect(function()
			if self._destroyed then
				return
			end
			paintSwatch()
			self:_Emit(self.State:Get())
		end))

		cleanup:Add(swatch.Activated:Connect(function()
			if self._destroyed or not self.Enabled or self:IsLocked() then
				return
			end
			local rows = 0
			if config.Swatches ~= false then
				rows += 26
			end
			if config.Harmony ~= false then
				rows += 26
			end
			local height = 150 + (hasAlpha and 20 or 0) + rows + 92
			local popup = self.Window:OpenPopup(swatch, 236, height)
			self._popup = popup
			local pcl, frame = popup.Cleanup, popup.Frame
			pcl:Add(popup.Closed:Connect(function()
				if self._popup == popup then
					self._popup = nil
				end
				self._rainbowButton = nil
			end))

			local hexBox, rBox, gBox, bBox, hBox, sBox, vBox
			local svBase, svCursor, hueCursor, alphaBar, alphaCursor
			local swatchRow, harmonyRow

			local function refresh()
				local color = self.State:Get()
				svBase.BackgroundColor3 = Color3.fromHSV(self._h, 1, 1)
				svCursor.Position = UDim2.fromScale(self._s, 1 - self._v)
				svCursor.BackgroundColor3 = color
				hueCursor.Position = UDim2.fromScale(self._h, 0.5)
				if hasAlpha then
					alphaBar.BackgroundColor3 = color
					alphaCursor.Position = UDim2.fromScale(self.TransparencyState:Get(), 0.5)
				end
				local function put(box, text)
					if not box:IsFocused() then
						box.Text = text
					end
				end
				put(hexBox, Utility.ToHex(color))
				put(rBox, tostring(to255(color.R)))
				put(gBox, tostring(to255(color.G)))
				put(bBox, tostring(to255(color.B)))
				put(hBox, tostring(math.floor(self._h * 360 + 0.5)))
				put(sBox, tostring(math.floor(self._s * 100 + 0.5)))
				put(vBox, tostring(math.floor(self._v * 100 + 0.5)))
			end

			local function apply()
				self.State:Set(Color3.fromHSV(self._h, self._s, self._v))
				refresh()
			end

			local function bar(y)
				local strip = Widgets.Surface(pcl, {
					Parent = frame,
					BackgroundTransparency = 0,
					BackgroundColor3 = Color3.new(1, 1, 1),
					Radius = 5,
					Position = UDim2.fromOffset(12, y),
					Size = UDim2.fromOffset(212, 12),
				})
				local hit = Utility.Create("TextButton", {
					BackgroundTransparency = 1,
					Size = UDim2.fromScale(1, 1),
					ZIndex = 3,
					Parent = strip,
				})
				local cursor = Widgets.Surface(pcl, {
					Parent = strip,
					Fill = "Text",
					Stroke = "Background",
					Radius = 3,
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0, 0.5),
					Size = UDim2.fromOffset(4, 18),
					ZIndex = 4,
				})
				return strip, hit, cursor
			end

			svBase = Widgets.Surface(pcl, {
				Parent = frame,
				BackgroundTransparency = 0,
				Radius = 8,
				ClipsDescendants = true,
				Position = UDim2.fromOffset(12, 12),
				Size = UDim2.fromOffset(212, 112),
			})
			local white = Utility.Create("Frame", {
				BackgroundColor3 = Color3.new(1, 1, 1),
				Size = UDim2.fromScale(1, 1),
				Parent = svBase,
			})
			Utility.Create("UIGradient", { Transparency = NumberSequence.new(0, 1), Parent = white })
			local black = Utility.Create("Frame", {
				BackgroundColor3 = Color3.new(0, 0, 0),
				Size = UDim2.fromScale(1, 1),
				Parent = svBase,
			})
			Utility.Create("UIGradient", { Transparency = NumberSequence.new(1, 0), Rotation = 90, Parent = black })
			local svHit = Utility.Create("TextButton", {
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 1),
				ZIndex = 3,
				Parent = svBase,
			})
			svCursor = Widgets.Surface(pcl, {
				Parent = svBase,
				Stroke = "Text",
				Radius = "Full",
				BackgroundTransparency = 0,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Size = UDim2.fromOffset(12, 12),
				ZIndex = 4,
			})
			Drag.Track(svHit, pcl, function(position)
				self:SetRainbow(false)
				self._s = math.clamp((position.X - svBase.AbsolutePosition.X) / math.max(svBase.AbsoluteSize.X, 1), 0, 1)
				self._v = 1 - math.clamp((position.Y - svBase.AbsolutePosition.Y) / math.max(svBase.AbsoluteSize.Y, 1), 0, 1)
				apply()
			end)

			local hueBar, hueHit
			hueBar, hueHit, hueCursor = bar(132)
			Utility.Create("UIGradient", { Color = ColorSequence.new(HUES), Parent = hueBar })
			Drag.Track(hueHit, pcl, function(position)
				self:SetRainbow(false)
				self._h = math.clamp((position.X - hueBar.AbsolutePosition.X) / math.max(hueBar.AbsoluteSize.X, 1), 0, 1)
				apply()
			end)

			local cursorY = 152
			if hasAlpha then
				local alphaHit
				alphaBar, alphaHit, alphaCursor = bar(152)
				Utility.Create("UIGradient", { Transparency = NumberSequence.new(0, 1), Parent = alphaBar })
				Drag.Track(alphaHit, pcl, function(position)
					local alpha = math.clamp(
						(position.X - alphaBar.AbsolutePosition.X) / math.max(alphaBar.AbsoluteSize.X, 1),
						0,
						1
					)
					self.TransparencyState:Set(Utility.Round(alpha, 2))
				end)
				cursorY = 172
			end

			local function dot(parent, color, order, onPick, onDrop)
				local item = Widgets.Surface(pcl, {
					Class = "TextButton",
					Parent = parent,
					Stroke = "Border",
					StrokeTransparency = 0.4,
					Radius = "Full",
					BackgroundTransparency = 0,
					BackgroundColor3 = color,
					Size = UDim2.fromOffset(18, 18),
					LayoutOrder = order,
				})
				pcl:Add(item.Activated:Connect(function()
					Widgets.Pulse(item, 0.7, 0.3)
					onPick()
				end))
				if onDrop then
					pcl:Add(item.MouseButton2Click:Connect(onDrop))
				end
				return item
			end

			if config.Swatches ~= false then
				local header = Utility.Create("Frame", {
					BackgroundTransparency = 1,
					Position = UDim2.fromOffset(12, cursorY),
					Size = UDim2.fromOffset(212, 18),
					Parent = frame,
				})
				Widgets.List(header, 4, {
					FillDirection = Enum.FillDirection.Horizontal,
					VerticalAlignment = Enum.VerticalAlignment.Center,
				})
				swatchRow = header

				local save = Widgets.Chip(pcl, {
					Parent = header,
					Radius = "Full",
					Fill = "Accent",
					Transparency = 0,
					Size = UDim2.fromOffset(18, 18),
					LayoutOrder = 0,
				})
				Icons.Create(save, "plus", {
					Size = 11,
					Color = "AccentText",
					Position = UDim2.fromOffset(3.5, 3.5),
					Cleanup = pcl,
				})
				pcl:Add(save.Activated:Connect(function()
					self:Save()
					Widgets.Pulse(save, 0.7, 0.3)
				end))

				local state = swatches()
				local list = pcl:Extend()
				local function rebuild()
					list:Clean()
					list = pcl:Extend()
					for index, hex in state:Get() do
						local color = Utility.FromHex(hex)
						if color then
							local item = dot(header, color, index, function()
								self:SetRainbow(false)
								self.State:Set(color)
								self._h, self._s, self._v = color:ToHSV()
								refresh()
							end, function()
								local copy = table.clone(state:Get())
								local at = table.find(copy, hex)
								if at then
									table.remove(copy, at)
									state:Set(copy)
								end
							end)
							list:Add(item)
						end
					end
				end
				pcl:Add(state.Changed:Connect(rebuild))
				rebuild()
				cursorY += 26
			end

			if config.Harmony ~= false then
				local row = Utility.Create("Frame", {
					BackgroundTransparency = 1,
					Position = UDim2.fromOffset(12, cursorY),
					Size = UDim2.fromOffset(212, 18),
					Parent = frame,
				})
				Widgets.List(row, 4, {
					FillDirection = Enum.FillDirection.Horizontal,
					VerticalAlignment = Enum.VerticalAlignment.Center,
				})
				harmonyRow = row

				local items = {}
				local function rebuild()
					for _, item in items do
						item:Destroy()
					end
					table.clear(items)
					for index, entry in self:Harmonies() do
						local item = dot(row, entry.Color, index, function()
							self:SetRainbow(false)
							self.State:Set(entry.Color)
							self._h, self._s, self._v = entry.Color:ToHSV()
							refresh()
						end)
						table.insert(items, item)
					end
				end
				rebuild()
				pcl:Add(self.State.Changed:Connect(function()
					if harmonyRow.Parent then
						rebuild()
					end
				end))
				cursorY += 26
			end

			local function field(x, y, width, name, commit)
				Widgets.Text(pcl, {
					Parent = frame,
					Text = name,
					Color = "MutedText",
					TextSize = 10,
					Position = UDim2.fromOffset(x, y),
					Size = UDim2.fromOffset(width, 11),
				})
				local _, box = Widgets.Field(pcl, {
					Parent = frame,
					Radius = 6,
					Position = UDim2.fromOffset(x, y + 12),
					Size = UDim2.fromOffset(width, 21),
					Inset = 2,
					Trail = 2,
					TextXAlignment = Enum.TextXAlignment.Center,
				})
				pcl:Add(box.FocusLost:Connect(function()
					commit(box.Text)
					refresh()
				end))
				return box
			end

			local function setRGB(r, g, b)
				self:SetRainbow(false)
				self.State:Set(Color3.fromRGB(math.clamp(r, 0, 255), math.clamp(g, 0, 255), math.clamp(b, 0, 255)))
			end
			local function channel(index)
				return function(text)
					local number = tonumber(text)
					if number then
						local color = self.State:Get()
						local values = { to255(color.R), to255(color.G), to255(color.B) }
						values[index] = number
						setRGB(values[1], values[2], values[3])
					end
				end
			end
			local function hsv(key, scale)
				return function(text)
					local number = tonumber(text)
					if number then
						self:SetRainbow(false)
						self[key] = math.clamp(number / scale, 0, 1)
						self.State:Set(Color3.fromHSV(self._h, self._s, self._v))
					end
				end
			end

			hexBox = field(12, cursorY, 70, "HEX", function(text)
				local color = Utility.FromHex(text)
				if color then
					self:SetRainbow(false)
					self.State:Set(color)
				end
			end)
			rBox = field(88, cursorY, 40, "R", channel(1))
			gBox = field(134, cursorY, 40, "G", channel(2))
			bBox = field(180, cursorY, 44, "B", channel(3))
			hBox = field(12, cursorY + 38, 66, "H", hsv("_h", 360))
			sBox = field(84, cursorY + 38, 66, "S", hsv("_s", 100))
			vBox = field(156, cursorY + 38, 68, "V", hsv("_v", 100))

			local buttonsY = cursorY + 78
			local function button(x, width, iconName, text, callback)
				local control = Widgets.Surface(pcl, {
					Class = "TextButton",
					Parent = frame,
					Fill = "TertiaryBackground",
					Stroke = "Border",
					StrokeTransparency = 0.4,
					Radius = 9,
					Position = UDim2.fromOffset(x, buttonsY),
					Size = UDim2.fromOffset(width, 24),
				})
				local icon = Icons.Create(control, iconName, {
					Size = 12,
					Position = UDim2.fromOffset(9, 6),
					Cleanup = pcl,
				})
				local _, label = Widgets.Text(pcl, {
					Parent = control,
					Text = text,
					TextSize = 11,
					Bold = true,
					Position = UDim2.fromOffset(25, 0),
					Size = UDim2.new(1, -29, 1, 0),
					Markup = false,
				})
				Widgets.Interactive(pcl, control, control, { Base = "TertiaryBackground" })
				pcl:Add(control.Activated:Connect(function()
					callback(control, icon, label)
				end))
				return control, icon, label
			end

			local copyable = Capabilities.Clipboard
			local rainbowWidth = copyable and 90 or 136
			local rainbow, rainbowIcon, rainbowLabel = button(12, rainbowWidth, "sparkles", "Rainbow", function()
				self:SetRainbow(not self._rainbow)
			end)
			self._rainbowButton = function()
				if not rainbow.Parent then
					return
				end
				local on = self._rainbow == true
				rainbowIcon:SetColor(on and "Accent" or "MutedText")
				rainbowLabel.SetColor(on and "Accent" or "Text")
				Animation:Play(rainbow, {
					BackgroundColor3 = Theme.Get(on and "Hover" or "TertiaryBackground"),
				}, { Duration = 0.15 })
				if on then
					Widgets.Pulse(rainbow, 0.9, 0.3)
				end
			end
			self._rainbowButton()

			button(12 + rainbowWidth + 6, 76, "rotate-ccw", "Reset", function()
				self:Reset()
				refresh()
			end)
			if copyable then
				button(12 + rainbowWidth + 88, 46, "copy", "", function()
					self:Copy()
				end)
			end

			popup.Resize(buttonsY + 36)
			pcl:Add(self.State.Changed:Connect(refresh))
			pcl:Add(self.TransparencyState.Changed:Connect(refresh))
			refresh()
		end))

		cleanup:Add(function()
			if self._popup then
				self._popup.Close()
			end
			if self._rainbowThread then
				pcall(task.cancel, self._rainbowThread)
			end
		end)

		if config.Rainbow then
			self:SetRainbow(true, config.RainbowSpeed)
		end
		return self
	end
end
end)()

__modules["Components/Paragraph"] = (function()
return function(import)
	local Component = import("Core/Component")

	local Paragraph = setmetatable({}, { __index = Component.Base })
	Paragraph.__index = Paragraph

	return function(ctx, id, config)
		return Component.New(ctx, Paragraph, "Paragraph", id, config, {})
	end
end
end)()

__modules["Components/Label"] = (function()
return function(import)
	local Component = import("Core/Component")

	local Label = setmetatable({}, { __index = Component.Base })
	Label.__index = Label

	function Label:SetText(text)
		return self:SetTitle(text)
	end

	return function(ctx, id, config)
		if type(config.Title) ~= "string" and type(config.Text) == "string" then
			config.Title = config.Text
		end
		return Component.New(ctx, Label, "Label", id, config, { MinHeight = 38, Flat = config.Flat ~= false })
	end
end
end)()

__modules["Components/Divider"] = (function()
return function(import)
	local Component = import("Core/Component")
	local Utility = import("Core/Utility")
	local Widgets = import("Core/Widgets")

	local Divider = setmetatable({}, { __index = Component.Base })
	Divider.__index = Divider

	return function(ctx, id, config)
		local self = Component.NewBare(ctx, Divider, "Divider", id, config)
		local frame = Utility.Create("Frame", {
			Name = "Divider",
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, config.Height or 9),
			LayoutOrder = ctx.Order(),
			Parent = ctx.Parent,
		})
		self.Cleanup:Add(frame)

		if type(config.Title) == "string" and config.Title ~= "" then
			local row = Utility.Create("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 1),
				Parent = frame,
			})
			Widgets.List(row, 8, {
				FillDirection = Enum.FillDirection.Horizontal,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
			})
			Widgets.Surface(self.Cleanup, {
				Parent = row,
				Fill = config.Color or "Border",
				Radius = 0,
				Size = UDim2.new(0.5, -40, 0, 1),
				LayoutOrder = 1,
			})
			local _, handle = Widgets.Text(self.Cleanup, {
				Parent = row,
				Text = config.Title,
				Color = config.TitleColor or "MutedText",
				TextSize = 11,
				Bold = true,
				AutomaticSize = Enum.AutomaticSize.X,
				Size = UDim2.new(0, 0, 1, 0),
				LayoutOrder = 2,
			})
			self._label = handle
			Widgets.Surface(self.Cleanup, {
				Parent = row,
				Fill = config.Color or "Border",
				Radius = 0,
				Size = UDim2.new(0.5, -40, 0, 1),
				LayoutOrder = 3,
			})
		else
			Widgets.Surface(self.Cleanup, {
				Parent = frame,
				Fill = config.Color or "Border",
				Radius = 0,
				AnchorPoint = Vector2.new(0, 0.5),
				Position = UDim2.fromScale(0, 0.5),
				Size = UDim2.new(1, 0, 0, 1),
			})
		end

		self.Frame = frame

		function self:SetTitle(text)
			if self._label then
				self._label.SetText(text)
			end
			return self
		end

		return self
	end
end
end)()

__modules["Components/Notification"] = (function()
return function(import)
	local Utility = import("Core/Utility")
	local Signal = import("Core/Signal")
	local Widgets = import("Core/Widgets")
	local Theme = import("Core/Theme")
	local Icons = import("Icons/Icon")
	local Animation = import("Services/Animation")
	local Cleanup = import("Services/Cleanup")

	local Toast = {}
	Toast.__index = Toast

	local TYPES = {
		Info = { Icon = "info", Token = "Info" },
		Success = { Icon = "circle-check", Token = "Success" },
		Warning = { Icon = "triangle-alert", Token = "Warning" },
		Error = { Icon = "alert-circle", Token = "Error" },
	}

	function Toast.new(holder, config, order, onClosed)
		local kind = TYPES[config.Type or "Info"]
		Utility.Check(kind ~= nil, "Notification", config.Title, "Type must be Info, Success, Warning or Error.")
		local self = setmetatable({}, Toast)
		self.Cleanup = Cleanup.new()
		self.Closed = Signal.new()
		self.Answered = Signal.new()
		self._closed = false
		self._answered = false
		local cleanup = self.Cleanup
		cleanup:Add(self.Answered)

		local wrapper = Utility.Create("Frame", {
			Name = "Toast",
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			LayoutOrder = order,
			Parent = holder,
		})
		cleanup:Add(wrapper)

		local card = Widgets.Surface(cleanup, {
			Class = "CanvasGroup",
			Name = "Card",
			Parent = wrapper,
			Fill = "SecondaryBackground",
			BackgroundTransparency = 0.12,
			Stroke = "Border",
			StrokeTransparency = 0.4,
			Radius = 14,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			Position = UDim2.fromOffset(40, 0),
			GroupTransparency = 1,
		})
		self.Frame = card

		local accent = Widgets.Surface(cleanup, {
			Name = "Accent",
			Parent = card,
			Fill = config.Color or kind.Token,
			Radius = "Full",
			Position = UDim2.new(0, 6, 0.5, 0),
			AnchorPoint = Vector2.new(0, 0.5),
			Size = UDim2.new(0, 3, 1, -22),
			ZIndex = 2,
		})

		local body = Utility.Create("Frame", {
			Name = "Body",
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			Parent = card,
		})
		Widgets.Padding(body, 17, 11, 11, 12)

		local icon = Icons.Create(body, config.Icon or kind.Icon, Icons.Options(config, {
			Size = config.IconSize or 17,
			Color = config.IconColor or kind.Token,
			Cleanup = cleanup,
		}))
		icon.Instance.Position = UDim2.fromOffset(0, 1)
		self._icon = icon

		local column = Utility.Create("Frame", {
			BackgroundTransparency = 1,
			Position = UDim2.fromOffset(26, 0),
			Size = UDim2.new(1, -48, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			Parent = body,
		})
		Widgets.List(column, 2)

		local title = config.Title or ""
		self.TitleLabel, self._title = Widgets.Text(cleanup, {
			Parent = column,
			Text = title,
			Color = config.TitleColor or "Text",
			Bold = true,
			TextSize = 13,
			TextWrapped = true,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			LayoutOrder = 1,
			Visible = title ~= "",
		})
		local content = config.Content or config.Description or ""
		self.ContentLabel, self._content = Widgets.Text(cleanup, {
			Parent = column,
			Text = content,
			Color = config.ContentColor or "MutedText",
			TextSize = 12,
			TextWrapped = true,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			LayoutOrder = 2,
			Visible = content ~= "",
		})

		if config.Input then
			local _, box = Widgets.Field(cleanup, {
				Name = "Input",
				Parent = column,
				Radius = 8,
				Placeholder = type(config.Input) == "string" and config.Input or (config.Placeholder or ""),
				Size = UDim2.new(1, 0, 0, 26),
				LayoutOrder = 3,
			})
			if config.Default then
				box.Text = config.Default
			end
			self._input = box
			cleanup:Add(box.FocusLost:Connect(function(enter)
				if enter then
					self:Answer(box.Text)
				end
			end))
		end

		local buttons = config.Buttons
		if not buttons and config.Options then
			buttons = {}
			for index, option in config.Options do
				table.insert(buttons, {
					Title = option,
					Primary = index == 1,
					Answer = option,
				})
			end
		elseif not buttons and config.Input then
			buttons = { { Title = config.ConfirmText or "OK", Primary = true, Answer = true } }
		end

		if buttons then
			local row = Utility.Create("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 24),
				LayoutOrder = 4,
				Parent = column,
			})
			Widgets.List(row, 6, {
				FillDirection = Enum.FillDirection.Horizontal,
				VerticalAlignment = Enum.VerticalAlignment.Center,
			})
			for index, entry in buttons do
				local button = Widgets.Surface(cleanup, {
					Class = "TextButton",
					Parent = row,
					Fill = entry.Primary and (entry.Color or kind.Token) or "TertiaryBackground",
					Radius = 8,
					Size = UDim2.new(0, 0, 1, 0),
					AutomaticSize = Enum.AutomaticSize.X,
					LayoutOrder = index,
					Text = entry.Title or "OK",
					TextSize = 11,
				})
				Widgets.Padding(button, 11, 0)
				Theme.BindFn(function()
					button.TextColor3 = Theme.Get(entry.Primary and "AccentText" or "Text")
					button.FontFace = Theme.FontBold
				end, cleanup)
				Widgets.Interactive(cleanup, button, button, {
					Base = entry.Primary and (entry.Color or kind.Token) or "TertiaryBackground",
					Hover = entry.Primary and (entry.Color or kind.Token) or "Hover",
					Pressed = entry.Primary and (entry.Color or kind.Token) or "Pressed",
					Alpha = entry.Primary and { 0, 0.12, 0.25 } or nil,
				})
				cleanup:Add(button.Activated:Connect(function()
					Utility.SafeCall("Notification button", entry.Callback)
					if entry.Answer ~= nil then
						self:Answer(entry.Answer == true and (self._input and self._input.Text or true) or entry.Answer)
					else
						self:Close()
					end
				end))
			end
		end

		if config.Closable ~= false then
			local close = Utility.Create("TextButton", {
				Name = "Close",
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(1, 0),
				Position = UDim2.new(1, 0, 0, 0),
				Size = UDim2.fromOffset(18, 18),
				Parent = body,
			})
			Icons.Create(close, "x", { Size = 12, Position = UDim2.fromOffset(3, 3), Cleanup = cleanup })
			cleanup:Add(close.Activated:Connect(function()
				self:Close()
			end))
		end

		local duration = config.Duration
		if duration == nil then
			duration = 4
		end
		local timed = type(duration) == "number" and duration > 0 and duration < math.huge
		if (timed or config.Progress == true) and config.Progress ~= false then
			local track = Utility.Create("Frame", {
				Name = "Progress",
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(0, 1),
				Position = UDim2.fromScale(0, 1),
				Size = UDim2.new(1, 0, 0, 2),
				Parent = card,
			})
			local bar = Utility.Create("Frame", { Size = UDim2.fromScale(1, 1), Parent = track })
			Theme.BindFn(function()
				bar.BackgroundColor3 = Theme.Resolve(config.Color or kind.Token, "Info")
			end, cleanup)
			self._bar = bar
			if timed then
				Animation:Play(bar, { Size = UDim2.fromScale(0, 1) }, {
					Duration = duration,
					Style = Enum.EasingStyle.Linear,
				})
			end
		end

		Animation:Play(card, { GroupTransparency = 0, Position = UDim2.new() }, { Duration = 0.22 })
		if timed then
			cleanup:Add(task.delay(duration, function()
				self:Close()
			end))
		end

		self._accent = accent
		self._onClosed = onClosed
		self._onAnswer = config.OnAnswer or ((config.Options or config.Input) and config.Callback or nil)
		return self
	end

	function Toast:Update(config)
		if self._closed or type(config) ~= "table" then
			return self
		end
		if config.Title ~= nil then
			self._title.SetText(config.Title)
			self.TitleLabel.Visible = config.Title ~= ""
		end
		if config.Content ~= nil then
			self._content.SetText(config.Content)
			self.ContentLabel.Visible = config.Content ~= ""
		end
		if config.Icon ~= nil then
			self._icon:Set(config.Icon)
		end
		if config.Color ~= nil then
			self._accent.BackgroundColor3 = Theme.Resolve(config.Color, "Accent")
			if self._bar then
				self._bar.BackgroundColor3 = Theme.Resolve(config.Color, "Accent")
			end
		end
		if config.Type ~= nil and TYPES[config.Type] then
			local kind = TYPES[config.Type]
			self._icon:Set(config.Icon or kind.Icon)
			self._icon:SetColor(kind.Token)
			self._accent.BackgroundColor3 = Theme.Get(kind.Token)
		end
		return self
	end

	function Toast:Answer(value)
		if self._answered or self._closed then
			return self
		end
		self._answered = true
		self.Value = value
		Utility.SafeCall("Notification answer", self._onAnswer, value)
		self.Answered:FireSync(value)
		self:Close()
		return self
	end

	function Toast:OnAnswer(callback)
		return self.Answered:Connect(callback)
	end

	function Toast:GetInput()
		return self._input and self._input.Text or nil
	end

	function Toast:Wait(timeout)
		local deadline = os.clock() + (tonumber(timeout) or 120)
		while not self._answered and not self._closed and os.clock() < deadline do
			task.wait(0.05)
		end
		return self.Value
	end

	function Toast:SetProgress(alpha)
		if self._bar then
			Animation:Cancel(self._bar)
			self._bar.Size = UDim2.fromScale(math.clamp(tonumber(alpha) or 0, 0, 1), 1)
		end
		return self
	end

	function Toast:Close()
		if self._closed then
			return
		end
		self._closed = true
		self.Closed:Fire()
		if self._onClosed then
			self._onClosed(self)
		end
		Animation:Play(self.Frame, { GroupTransparency = 1, Position = UDim2.fromOffset(40, 0) }, {
			Duration = 0.15,
			OnComplete = function()
				self.Cleanup:Clean()
			end,
		})
		task.delay(0.4, function()
			self.Cleanup:Clean()
		end)
	end

	function Toast:Destroy()
		self._closed = true
		self.Cleanup:Clean()
		self.Closed:Destroy()
	end

	return Toast
end
end)()

__modules["Components/Dialog"] = (function()
return function(import)
	local Utility = import("Core/Utility")
	local Signal = import("Core/Signal")
	local Theme = import("Core/Theme")
	local Widgets = import("Core/Widgets")
	local Icons = import("Icons/Icon")
	local Animation = import("Services/Animation")

	local Dialog = {}
	Dialog.__index = Dialog

	function Dialog.new(window, config)
		Utility.Check(
			type(config) == "table" and type(config.Title) == "string",
			"Dialog",
			config and config.Title,
			"Title must be a string."
		)
		local self = setmetatable({}, Dialog)
		self.Window = window
		self.Closed = Signal.new()
		self._closed = false
		self._count = 0
		self.Cleanup = window.Cleanup:Extend()
		local cleanup = self.Cleanup
		cleanup:Add(self.Closed)

		local overlay = Widgets.Surface(cleanup, {
			Name = "DialogOverlay",
			Parent = window._dialogLayer,
			Fill = "Overlay",
			BackgroundTransparency = 1,
			Radius = 0,
			Active = true,
			Size = UDim2.fromScale(1, 1),
		})
		cleanup:Add(overlay)
		self._overlay = overlay

		local box = Widgets.Surface(cleanup, {
			Class = "CanvasGroup",
			Name = "Dialog",
			Parent = overlay,
			Fill = "SecondaryBackground",
			Stroke = "Border",
			Radius = 16,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.new(0, config.Width or 320, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			GroupTransparency = 1,
		})
		self._box = box
		Widgets.Padding(box, 16)
		Widgets.List(box, 10)
		Utility.Create("UISizeConstraint", { MaxSize = Vector2.new(config.Width or 360, math.huge), Parent = box })

		local header = Utility.Create("Frame", {
			Name = "Header",
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.new(1, 0, 0, 0),
			LayoutOrder = 1,
			Parent = box,
		})
		Widgets.List(header, 8, {
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
		})
		if config.Icon then
			local holder = Utility.Create("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.fromOffset(18, 18),
				LayoutOrder = 1,
				Parent = header,
			})
			Icons.Create(holder, config.Icon, Icons.Options(config, {
				Size = config.IconSize or 18,
				Color = config.IconColor or "Accent",
				Cleanup = cleanup,
			}))
		end
		Widgets.Text(cleanup, {
			Parent = header,
			Text = config.Title,
			Color = config.TitleColor or "Text",
			Bold = true,
			TextSize = 15,
			TextWrapped = true,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.new(1, config.Icon and -26 or 0, 0, 0),
			LayoutOrder = 2,
		})

		if config.Content and config.Content ~= "" then
			self.ContentLabel, self._content = Widgets.Text(cleanup, {
				Parent = box,
				Text = config.Content,
				Color = config.ContentColor or "MutedText",
				TextWrapped = true,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				LayoutOrder = 2,
			})
		end

		if config.Input then
			local holder, inputBox = Widgets.Field(cleanup, {
				Name = "Input",
				Parent = box,
				Radius = 10,
				Placeholder = type(config.Input) == "string" and config.Input or (config.Placeholder or ""),
				Size = UDim2.new(1, 0, 0, 30),
				LayoutOrder = 3,
			})
			self.Input = inputBox
			if config.InputDefault then
				inputBox.Text = config.InputDefault
			end
		end

		self._buttons = Utility.Create("Frame", {
			Name = "Buttons",
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 32),
			LayoutOrder = 4,
			Parent = box,
		})
		Widgets.List(self._buttons, 8, {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Right,
			VerticalAlignment = Enum.VerticalAlignment.Center,
		})

		Animation:Play(overlay, { BackgroundTransparency = 0.5 }, { Duration = 0.15 })
		Animation:Play(box, { GroupTransparency = 0 }, { Duration = 0.15 })

		for _, buttonConfig in config.Buttons or {} do
			self:AddButton(buttonConfig)
		end
		return self
	end

	function Dialog:GetInput()
		return self.Input and self.Input.Text or nil
	end

	function Dialog:SetContent(text)
		if self._content then
			self._content.SetText(text)
		end
		return self
	end

	function Dialog:AddButton(config)
		Utility.Check(
			type(config) == "table" and type(config.Title) == "string",
			"Dialog button",
			config and config.Title,
			"Title must be a string."
		)
		self._count += 1
		local primary = config.Primary == true
		local cleanup = self.Cleanup
		local button = Widgets.Surface(cleanup, {
			Class = "TextButton",
			Name = "Button",
			Parent = self._buttons,
			Fill = primary and (config.Color or "Accent") or "TertiaryBackground",
			Stroke = (not primary) and "Border" or nil,
			StrokeTransparency = 0.4,
			Radius = 11,
			Size = UDim2.new(0, 0, 1, 0),
			AutomaticSize = Enum.AutomaticSize.X,
			LayoutOrder = self._count,
			Text = config.Title,
		})
		Widgets.Padding(button, 16, 0)
		Theme.BindFn(function()
			button.TextColor3 = Theme.Resolve(
				primary and (config.TextColor or "AccentText") or (config.TextColor or "Text"),
				"Text"
			)
			button.FontFace = Theme.FontBold
			button.TextSize = 13
		end, cleanup)
		Widgets.Interactive(cleanup, button, button, {
			Base = primary and (config.Color or "Accent") or "TertiaryBackground",
			Hover = primary and (config.Color or "Accent") or "Hover",
			Pressed = primary and (config.Color or "Accent") or "Pressed",
			Alpha = primary and { 0, 0.12, 0.25 } or nil,
		})
		cleanup:Add(button.Activated:Connect(function()
			if self._closed then
				return
			end
			Utility.SafeCall("Dialog button " .. config.Title, config.Callback, self:GetInput())
			if config.KeepOpen ~= true then
				self:Close()
			end
		end))
		return self
	end

	function Dialog:Close()
		if self._closed then
			return
		end
		self._closed = true
		self.Closed:Fire()
		Animation:Play(self._box, { GroupTransparency = 1 }, { Duration = 0.12 })
		Animation:Play(self._overlay, { BackgroundTransparency = 1 }, {
			Duration = 0.12,
			OnComplete = function()
				self.Cleanup:Clean()
			end,
		})
		task.delay(0.4, function()
			self.Cleanup:Clean()
		end)
	end

	return Dialog
end
end)()

__modules["Components/Segmented"] = (function()
return function(import)
	local Component = import("Core/Component")
	local Utility = import("Core/Utility")
	local Widgets = import("Core/Widgets")
	local Theme = import("Core/Theme")
	local Icons = import("Icons/Icon")
	local Animation = import("Services/Animation")

	local Segmented = setmetatable({}, { __index = Component.Base })
	Segmented.__index = Segmented

	function Segmented:_Normalize(value)
		if type(value) == "number" then
			local name = self.Values[value]
			if name == nil then
				return false
			end
			return true, name
		end
		if type(value) == "string" and table.find(self.Values, value) then
			return true, value
		end
		return false
	end

	function Segmented:GetValues()
		return table.clone(self.Values)
	end

	function Segmented:Next()
		local index = table.find(self.Values, self.State:Get()) or 0
		self.State:Set(self.Values[index % #self.Values + 1])
		return self
	end

	return function(ctx, id, config)
		local values = config.Values
		Utility.Check(type(values) == "table" and #values > 0, "Segmented", id, "Values must be a non-empty array.")
		for _, name in values do
			Utility.Check(type(name) == "string", "Segmented", id, "Values must be strings.")
		end

		local width = config.Width or math.min(60 + #values * 56, 240)
		local self = Component.New(ctx, Segmented, "Segmented", id, config, { RightWidth = width, RightHeight = 26 })
		self.Values = table.clone(values)
		local cleanup = self.Cleanup

		local track = Widgets.Surface(cleanup, {
			Name = "Track",
			Parent = self.Right,
			Fill = "TertiaryBackground",
			Transparency = "ElementTransparency",
			Stroke = "Border",
			StrokeTransparency = 0.5,
			Radius = "Full",
			Size = UDim2.fromScale(1, 1),
		})
		Widgets.Padding(track, 3, 3)

		local highlight = Widgets.Surface(cleanup, {
			Name = "Highlight",
			Parent = track,
			Fill = config.Color or "Accent",
			Radius = "Full",
			Size = UDim2.new(1 / #values, 0, 1, 0),
			Position = UDim2.new(),
		})

		local row = Utility.Create("Frame", {
			Name = "Options",
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			Parent = track,
		})
		Widgets.List(row, 0, {
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
		})

		local labels, icons = {}, {}
		for index, name in values do
			local button = Utility.Create("TextButton", {
				Name = name,
				BackgroundTransparency = 1,
				Size = UDim2.new(1 / #values, 0, 1, 0),
				LayoutOrder = index,
				Parent = row,
			})
			local iconName = config.Icons and config.Icons[name]
			local inset = 0
			if iconName then
				local holder = Utility.Create("Frame", {
					BackgroundTransparency = 1,
					AnchorPoint = Vector2.new(0, 0.5),
					Position = UDim2.new(0, 8, 0.5, 0),
					Size = UDim2.fromOffset(13, 13),
					Parent = button,
				})
				icons[name] = Icons.Create(holder, iconName, { Size = 13, Color = "MutedText", Cleanup = cleanup })
				inset = 22
			end
			local _, label = Widgets.Text(cleanup, {
				Parent = button,
				Text = name,
				Color = "MutedText",
				TextSize = 12,
				Bold = true,
				TextXAlignment = iconName and Enum.TextXAlignment.Left or Enum.TextXAlignment.Center,
				TextTruncate = Enum.TextTruncate.AtEnd,
				Position = UDim2.fromOffset(inset, 0),
				Size = UDim2.new(1, -(inset + 4), 1, 0),
			})
			labels[name] = label
			cleanup:Add(button.Activated:Connect(function()
				if self.Enabled then
					self.State:Set(name)
				end
			end))
		end

		local valid, default = self:_Normalize(config.Default or values[1])
		Utility.Check(valid, "Segmented", id, "Default must be a value (or index) from Values.")

		local function render(value, animate)
			local index = table.find(self.Values, value) or 1
			local goal = UDim2.new((index - 1) / #self.Values, 0, 0, 0)
			if animate then
				Animation:Play(highlight, { Position = goal }, {
					Duration = 0.22,
					Style = Enum.EasingStyle.Back,
					Direction = Enum.EasingDirection.Out,
				})
			else
				highlight.Position = goal
			end
			for name, label in labels do
				local active = name == value
				local color = Theme.Resolve(active and (config.SelectedColor or "AccentText") or "MutedText", "MutedText")
				if animate then
					Animation:Play(label.Instance, { TextColor3 = color }, { Duration = 0.15 })
				else
					label.Instance.TextColor3 = color
				end
				if icons[name] then
					icons[name]:SetColor(active and (config.SelectedColor or "AccentText") or "MutedText")
				end
			end
		end
		Component.BindValue(self, id, default, render)

		function self:SetColor(color)
			highlight.BackgroundColor3 = Theme.Resolve(color, "Accent")
			return self
		end

		return self
	end
end
end)()

__modules["Components/Progress"] = (function()
return function(import)
	local Component = import("Core/Component")
	local Utility = import("Core/Utility")
	local Signal = import("Core/Signal")
	local Widgets = import("Core/Widgets")
	local Theme = import("Core/Theme")
	local Animation = import("Services/Animation")

	local Progress = setmetatable({}, { __index = Component.Base })
	Progress.__index = Progress

	function Progress:_Normalize(value)
		if type(value) ~= "number" or value ~= value then
			return false
		end
		return true, math.clamp(value, 0, 1)
	end

	function Progress:SetProgress(alpha)
		return self:SetValue(alpha)
	end

	function Progress:Increment(amount)
		return self:SetValue((self.State:Get() or 0) + (amount or 0.1))
	end

	function Progress:Complete()
		return self:SetValue(1)
	end

	function Progress:GetRemaining()
		return self._remaining or 0
	end

	function Progress:IsRunning()
		return self._running == true
	end

	function Progress:_Stop()
		self._running = false
		if self._thread then
			pcall(task.cancel, self._thread)
			self._thread = nil
		end
	end

	function Progress:Start(seconds)
		self:_Stop()
		self._total = tonumber(seconds) or self._total or self.Config.Seconds or 60
		self._remaining = self._total
		self:_Tick()
		return self:_Spin()
	end

	function Progress:_Spin()
		if self._running or (self._remaining or 0) <= 0 then
			return self
		end
		self._running = true
		self._thread = task.spawn(function()
			local last = os.clock()
			while self._running and not self._destroyed do
				task.wait(0.05)
				local now = os.clock()
				self._remaining = math.max(self._remaining - (now - last), 0)
				last = now
				self:_Tick()
				if self._remaining <= 0 then
					self._running = false
					self.Finished:Fire()
					Utility.SafeCall("Progress " .. tostring(self.Id), self.Config.OnFinish)
					if self.Config.Loop then
						task.wait(0.2)
						self:Start(self._total)
					end
					break
				end
			end
		end)
		self.Cleanup:Add(self._thread)
		return self
	end

	function Progress:Pause()
		self._running = false
		if self._thread then
			pcall(task.cancel, self._thread)
			self._thread = nil
		end
		return self
	end

	function Progress:Resume()
		return self:_Spin()
	end

	function Progress:Toggle()
		if self._running then
			return self:Pause()
		end
		if (self._remaining or 0) <= 0 then
			return self:Start(self._total)
		end
		return self:_Spin()
	end

	function Progress:Stop()
		self:_Stop()
		self._remaining = 0
		self:_Tick()
		return self
	end

	function Progress:Reset()
		self:_Stop()
		self._remaining = self._total or self.Config.Seconds or 0
		self:_Tick()
		return self
	end

	function Progress:AddTime(seconds)
		self._total = (self._total or 0) + seconds
		self._remaining = math.max((self._remaining or 0) + seconds, 0)
		self:_Tick()
		return self
	end

	function Progress:_Tick()
		local total = self._total or 1
		local alpha = total > 0 and math.clamp(self._remaining / total, 0, 1) or 0
		if self.Config.Fill == true then
			alpha = 1 - alpha
		end
		self._apply(alpha, false)
		if self._label then
			self._label.SetText(self:_Format(alpha))
		end
	end

	function Progress:_Format(alpha)
		local config = self.Config
		if type(config.Format) == "function" then
			local ok, text = pcall(config.Format, alpha, self._remaining or 0)
			return ok and tostring(text) or ""
		end
		if self._countdown then
			return Component.Clock(self._remaining or 0)
		end
		return string.format(config.Format or "%d%%", alpha * 100)
	end

	function Progress:SetIndeterminate(value)
		self._loop = value == true
		if not self._loop then
			Animation:Cancel(self._fill)
			self._fill.Position = UDim2.new()
			self._apply(self.State:Get(), true)
			return self
		end
		task.spawn(function()
			while self._loop and not self._destroyed do
				self._fill.Position = UDim2.fromScale(-0.35, 0)
				self._fill.Size = UDim2.fromScale(0.35, 1)
				Animation:Play(self._fill, { Position = UDim2.fromScale(1, 0) }, {
					Duration = 0.9,
					Style = Enum.EasingStyle.Sine,
					Direction = Enum.EasingDirection.InOut,
				})
				task.wait(1)
			end
		end)
		return self
	end

	return function(ctx, id, config)
		local countdown = config.Mode == "Countdown" or config.Seconds ~= nil
		local self = Component.New(ctx, Progress, countdown and "Countdown" or "Progress", id, config, {
			RightWidth = config.Width or 190,
			RightHeight = 20,
		})
		local cleanup = self.Cleanup
		local accent = config.Color or "Accent"
		local showValue = config.ShowValue ~= false
		self._countdown = countdown
		self.Finished = Signal.new()
		cleanup:Add(self.Finished)

		local label
		if showValue then
			local _, handle = Widgets.Text(cleanup, {
				Parent = self.Right,
				Text = countdown and "00:00" or "0%",
				Color = config.ValueColor or "MutedText",
				Bold = true,
				TextSize = 11,
				TextXAlignment = Enum.TextXAlignment.Right,
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.new(1, 0, 0.5, 0),
				Size = UDim2.fromOffset(countdown and 46 or 38, 14),
				Markup = false,
			})
			label = handle
			self._label = handle
		end

		local reserved = showValue and (countdown and 52 or 44) or 0
		local track = Widgets.Surface(cleanup, {
			Name = "Track",
			Parent = self.Right,
			Fill = "TertiaryBackground",
			Transparency = "ElementTransparency",
			Stroke = "Border",
			StrokeTransparency = 0.6,
			Radius = "Full",
			ClipsDescendants = true,
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0, 0, 0.5, 0),
			Size = UDim2.new(1, -reserved, 0, config.Thickness or 6),
		})
		local fill = Widgets.Surface(cleanup, {
			Name = "Fill",
			Parent = track,
			Fill = accent,
			Radius = "Full",
			Size = UDim2.fromScale(0, 1),
		})
		self._track, self._fill = track, fill

		local stops = Widgets.Stops(config.Gradient)
		if stops then
			Utility.Create("UIGradient", { Color = stops, Parent = fill })
		end

		if config.Glow ~= false then
			local glow = Widgets.Surface(cleanup, {
				Name = "Head",
				Parent = fill,
				Fill = "Text",
				BackgroundTransparency = 0.75,
				Radius = "Full",
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.fromScale(1, 0.5),
				Size = UDim2.new(0, 10, 1, 0),
			})
			self._glow = glow
		end

		local function apply(value, animate)
			if self._loop then
				return
			end
			local size = UDim2.fromScale(math.clamp(value or 0, 0, 1), 1)
			if animate then
				Animation:Play(fill, { Size = size }, { Duration = 0.3, Style = Enum.EasingStyle.Quint })
			else
				fill.Size = size
			end
			if self._glow then
				self._glow.Visible = (value or 0) > 0.02
			end
		end
		self._apply = apply

		local function render(value, animate)
			if self._countdown then
				return
			end
			apply(value, animate)
			if label then
				label.SetText(self:_Format(value))
			end
		end
		self._render = render
		Component.BindValue(self, id, math.clamp(config.Default or 0, 0, 1), render)

		function self:SetColor(color)
			fill.BackgroundColor3 = Theme.Resolve(color, "Accent")
			return self
		end

		if countdown then
			self._total = config.Seconds or 60
			self._remaining = self._total
			self:_Tick()
			if config.AutoStart ~= false then
				self:Start(self._total)
			end
		end
		if config.Indeterminate then
			self:SetIndeterminate(true)
		end
		return self
	end
end
end)()

__modules["Components/Countdown"] = (function()
return function(import)
	local Progress = import("Components/Progress")

	return function(ctx, id, config)
		config.Mode = "Countdown"
		config.Seconds = config.Seconds or 60
		return Progress(ctx, id, config)
	end
end
end)()

__modules["Components/Stat"] = (function()
return function(import)
	local Component = import("Core/Component")
	local Utility = import("Core/Utility")
	local Widgets = import("Core/Widgets")
	local Icons = import("Icons/Icon")
	local Animation = import("Services/Animation")

	local Stat = setmetatable({}, { __index = Component.Base })
	Stat.__index = Stat

	local function format(value, config)
		if type(value) == "number" then
			local rounded = Utility.Round(value, config.Decimals or 0)
			if config.Short and math.abs(rounded) >= 1000 then
				local units = { "k", "M", "B" }
				local scaled, step = rounded, 0
				while math.abs(scaled) >= 1000 and step < #units do
					scaled /= 1000
					step += 1
				end
				return string.format("%.1f%s", scaled, units[step])
			end
			return string.format("%." .. tostring(config.Decimals or 0) .. "f", rounded)
		end
		return tostring(value)
	end

	function Stat:_Normalize(value)
		if value == nil then
			return true, 0
		end
		return true, value
	end

	function Stat:Bind(getter, interval)
		self:Unbind()
		self._poll = task.spawn(function()
			while not self._destroyed do
				local ok, value = pcall(getter)
				if ok and value ~= nil then
					self:SetValue(value)
				end
				task.wait(interval or 1)
			end
		end)
		self.Cleanup:Add(self._poll)
		return self
	end

	function Stat:Unbind()
		if self._poll then
			pcall(task.cancel, self._poll)
			self._poll = nil
		end
		return self
	end

	return function(ctx, id, config)
		local self = Component.New(ctx, Stat, "Stat", id, config, {
			RightWidth = config.Width or 120,
			RightHeight = 30,
			MinHeight = 52,
		})
		local cleanup = self.Cleanup

		local trendHolder
		if config.Trend then
			trendHolder = Utility.Create("Frame", {
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.new(1, 0, 0.5, 0),
				Size = UDim2.fromOffset(14, 14),
				Parent = self.Right,
			})
			self._trend = Icons.Create(trendHolder, "trending-up", {
				Size = 14,
				Color = "Success",
				Cleanup = cleanup,
			})
		end

		local _, value = Widgets.Text(cleanup, {
			Name = "Value",
			Parent = self.Right,
			Text = "0",
			Color = config.ValueColor or "Text",
			Gradient = config.ValueGradient,
			Heavy = true,
			TextSize = config.TextSize or 19,
			TextXAlignment = Enum.TextXAlignment.Right,
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, trendHolder and -19 or 0, 0.5, 0),
			Size = UDim2.new(1, trendHolder and -19 or 0, 1, 0),
		})
		self._value = value

		local suffix = config.Suffix or ""
		local previous = 0

		local function render(current, animate)
			local text = format(current, config) .. suffix
			value.SetText(text)
			if animate then
				Widgets.Pulse(value.Instance, 0.86, 0.3)
			end
			if self._trend and type(current) == "number" then
				local up = current >= previous
				self._trend:Set(up and "trending-up" or "trending-down")
				self._trend:SetColor(up and "Success" or "Error")
			end
			if type(current) == "number" then
				previous = current
			end
		end
		Component.BindValue(self, id, config.Default or 0, render)

		if config.Bind then
			self:Bind(config.Bind, config.Interval)
		end
		return self
	end
end
end)()

__modules["Components/Image"] = (function()
return function(import)
	local Component = import("Core/Component")
	local Utility = import("Core/Utility")
	local Widgets = import("Core/Widgets")
	local Icons = import("Icons/Icon")
	local Animation = import("Services/Animation")

	local Banner = setmetatable({}, { __index = Component.Base })
	Banner.__index = Banner

	function Banner:SetImage(spec)
		self._art:Set(spec)
		return self
	end

	function Banner:SetTitle(text)
		if self._title then
			self._title.SetText(text)
		end
		return self
	end

	function Banner:SetDescription(text)
		if self._description then
			self._description.SetText(text)
		end
		return self
	end

	function Banner:SetTransparency(value)
		local image = self._art.Instance:FindFirstChildWhichIsA("ImageLabel")
		if image then
			Animation:Play(image, { ImageTransparency = math.clamp(value, 0, 1) }, { Duration = 0.2 })
		end
		return self
	end

	return function(ctx, id, config)
		local height = config.Height or 120
		local self = Component.NewBare(ctx, Banner, "Image", id, config)
		local cleanup = self.Cleanup

		local frame = Widgets.Surface(cleanup, {
			Name = "Image",
			Parent = ctx.Parent,
			Fill = "SecondaryBackground",
			Transparency = "ComponentTransparency",
			Stroke = "Border",
			StrokeTransparency = "ComponentStrokeTransparency",
			Radius = config.Radius or 14,
			ClipsDescendants = true,
			Size = UDim2.new(1, 0, 0, height),
			LayoutOrder = ctx.Order(),
		})
		cleanup:Add(frame)
		self.Frame = frame

		self._art = Icons.Create(frame, config.Image, Icons.Options(config, {
			Size = height,
			Color = config.Color or "Text",
			Shape = config.Shape,
			Corner = config.Corner,
			Tint = config.Tint,
			ScaleType = config.ScaleType or Enum.ScaleType.Crop,
			Cleanup = cleanup,
		}))
		self._art.Instance.Size = UDim2.fromScale(1, 1)
		self._art.Instance.Position = UDim2.new()

		if config.Title or config.Description then
			local shade = Utility.Create("Frame", {
				Name = "Shade",
				BackgroundColor3 = Color3.new(0, 0, 0),
				BackgroundTransparency = 0.35,
				AnchorPoint = Vector2.new(0, 1),
				Position = UDim2.fromScale(0, 1),
				Size = UDim2.new(1, 0, 0, 56),
				Parent = frame,
			})
			Utility.Create("UIGradient", {
				Rotation = 90,
				Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 1),
					NumberSequenceKeypoint.new(1, 0),
				}),
				Parent = shade,
			})
			local column = Utility.Create("Frame", {
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(0, 1),
				Position = UDim2.new(0, 14, 1, -10),
				Size = UDim2.new(1, -28, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				Parent = frame,
			})
			Widgets.List(column, 2)
			if config.Title then
				local _, handle = Widgets.Text(cleanup, {
					Parent = column,
					Text = config.Title,
					Color = config.TitleColor or "#FFFFFF",
					Gradient = config.TitleGradient,
					Heavy = true,
					TextSize = 15,
					Size = UDim2.new(1, 0, 0, 18),
					LayoutOrder = 1,
				})
				self._title = handle
			end
			if config.Description then
				local _, handle = Widgets.Text(cleanup, {
					Parent = column,
					Text = config.Description,
					Color = config.DescriptionColor or "#D4D4D8",
					TextSize = 12,
					TextWrapped = true,
					AutomaticSize = Enum.AutomaticSize.Y,
					Size = UDim2.new(1, 0, 0, 0),
					LayoutOrder = 2,
				})
				self._description = handle
			end
		end

		if config.Callback then
			local hit = Utility.Create("TextButton", {
				Name = "Hit",
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 1),
				ZIndex = 5,
				Parent = frame,
			})
			cleanup:Add(hit.Activated:Connect(function()
				Utility.SafeCall("Image " .. tostring(id), config.Callback)
			end))
			cleanup:Add(hit.MouseEnter:Connect(function()
				Widgets.Pulse(frame, 0.985, 0.25)
			end))
		end
		return self
	end
end
end)()

__modules["Components/Code"] = (function()
return function(import)
	local Component = import("Core/Component")
	local Utility = import("Core/Utility")
	local Widgets = import("Core/Widgets")
	local Capabilities = import("Core/Capabilities")
	local Icons = import("Icons/Icon")
	local Animation = import("Services/Animation")

	local Code = setmetatable({}, { __index = Component.Base })
	Code.__index = Code

	function Code:_Normalize(value)
		if value == nil then
			return true, ""
		end
		return true, tostring(value)
	end

	function Code:GetText()
		return self.State:Get()
	end

	function Code:SetText(text)
		return self:SetValue(text)
	end

	function Code:Copy()
		local ok = Capabilities.SetClipboard(self.State:Get())
		if ok and self._copyIcon then
			self._copyIcon:Set("check")
			Widgets.Pulse(self._copy, 0.8, 0.3)
			task.delay(1.2, function()
				if self._copyIcon and not self._destroyed then
					self._copyIcon:Set("copy")
				end
			end)
		end
		return ok
	end

	return function(ctx, id, config)
		local self = Component.NewBare(ctx, Code, "Code", id, config)
		local cleanup = self.Cleanup

		local frame = Utility.Create("Frame", {
			Name = "Code",
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.new(1, 0, 0, 0),
			LayoutOrder = ctx.Order(),
			Parent = ctx.Parent,
		})
		cleanup:Add(frame)
		Widgets.List(frame, 6)
		self.Frame = frame

		if config.Title then
			local _, handle = Widgets.Text(cleanup, {
				Parent = frame,
				Text = config.Title,
				Color = config.TitleColor or "MutedText",
				Bold = true,
				TextSize = 12,
				Size = UDim2.new(1, 0, 0, 14),
				LayoutOrder = 1,
			})
			self._label = handle
		end

		local block = Widgets.Surface(cleanup, {
			Name = "Block",
			Parent = frame,
			Fill = config.Background or "Background",
			Transparency = config.Transparency or 0.25,
			Stroke = "Border",
			StrokeTransparency = 0.5,
			Radius = 10,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.new(1, 0, 0, 0),
			LayoutOrder = 2,
		})
		Widgets.Padding(block, 12, 11, 40, 11)

		local box = Widgets.Text(cleanup, {
			Class = "TextBox",
			Name = "Text",
			Parent = block,
			Text = config.Default or config.Text or "",
			TextColor3 = Color3.new(1, 1, 1),
			TextSize = config.TextSize or 12,
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
			ClearTextOnFocus = false,
			MultiLine = true,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.new(1, 0, 0, 0),
		})
		box.FontFace = Font.new("rbxasset://fonts/families/RobotoMono.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
		box.TextEditable = config.Editable == true
		self._box = box

		Component.BindValue(self, id, config.Default or config.Text or "", function(value)
			if box.Text ~= value then
				box.Text = value
			end
		end)
		cleanup:Add(box.FocusLost:Connect(function()
			if config.Editable then
				self.State:Set(box.Text)
			else
				box.Text = self.State:Get()
			end
		end))

		if Capabilities.Clipboard and config.Copy ~= false then
			self._copy = Widgets.Chip(cleanup, {
				Name = "Copy",
				Parent = block,
				Radius = 8,
				AnchorPoint = Vector2.new(1, 0),
				Position = UDim2.new(1, 7, 0, 0),
				Size = UDim2.fromOffset(24, 24),
			})
			self._copyIcon = Icons.Create(self._copy, "copy", {
				Size = 12,
				Position = UDim2.fromOffset(6, 6),
				Cleanup = cleanup,
			})
			cleanup:Add(self._copy.Activated:Connect(function()
				self:Copy()
			end))
		end
		return self
	end
end
end)()

__modules["Components/List"] = (function()
return function(import)
	local Component = import("Core/Component")
	local Utility = import("Core/Utility")
	local Signal = import("Core/Signal")
	local Widgets = import("Core/Widgets")
	local Editable = import("Core/Editable")
	local Icons = import("Icons/Icon")
	local Animation = import("Services/Animation")

	local List = setmetatable({}, { __index = Component.Base })
	List.__index = List

	function List:_Normalize(value)
		if type(value) ~= "table" then
			return false
		end
		local out = {}
		for _, entry in value do
			if type(entry) == "string" then
				table.insert(out, entry)
			end
		end
		return true, out
	end

	function List:SetTitle(text)
		self._title.SetText(text)
		return self
	end

	function List:GetItems()
		return table.clone(self.State:Get() or {})
	end

	function List:Has(item)
		return table.find(self.State:Get() or {}, item) ~= nil
	end

	function List:Add(item)
		if type(item) ~= "string" or item == "" then
			return self
		end
		local items = self:GetItems()
		if table.find(items, item) and not self.Config.Duplicates then
			return self
		end
		table.insert(items, item)
		self.State:Set(items)
		Utility.SafeCall("List " .. tostring(self.Id), self.Config.OnAdd, item)
		return self
	end

	function List:Remove(item)
		local items = self:GetItems()
		local index = type(item) == "number" and item or table.find(items, item)
		if not index then
			return self
		end
		local removed = table.remove(items, index)
		self.State:Set(items)
		Utility.SafeCall("List " .. tostring(self.Id), self.Config.OnRemove, removed)
		return self
	end

	function List:Rename(old, new)
		local items = self:GetItems()
		local index = table.find(items, old)
		if not index or type(new) ~= "string" or new == "" or old == new then
			return self
		end
		items[index] = new
		self.State:Set(items)
		Utility.SafeCall("List " .. tostring(self.Id), self.Config.OnRename, old, new)
		return self
	end

	function List:Move(item, offset)
		local items = self:GetItems()
		local index = table.find(items, item)
		if not index then
			return self
		end
		local target = math.clamp(index + offset, 1, #items)
		if target == index then
			return self
		end
		table.remove(items, index)
		table.insert(items, target, item)
		self.State:Set(items)
		return self
	end

	function List:Clear()
		self.State:Set({})
		return self
	end

	return function(ctx, id, config)
		local self = Component.NewBare(ctx, List, "List", id, config)
		local cleanup = self.Cleanup
		self.ItemsChanged = Signal.new()
		cleanup:Add(self.ItemsChanged)

		local frame = Widgets.Surface(cleanup, {
			Name = "List",
			Parent = ctx.Parent,
			Fill = "SecondaryBackground",
			Transparency = "ComponentTransparency",
			Stroke = "Border",
			StrokeTransparency = "ComponentStrokeTransparency",
			Radius = 14,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.new(1, 0, 0, 0),
			LayoutOrder = ctx.Order(),
		})
		cleanup:Add(frame)
		Widgets.Padding(frame, 12, 11)
		Widgets.List(frame, 7)
		self.Frame, self.Stroke = frame, frame:FindFirstChildOfClass("UIStroke")

		local header = Utility.Create("Frame", {
			Name = "Header",
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 18),
			LayoutOrder = 1,
			Parent = frame,
		})
		Widgets.List(header, 7, {
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
		})
		if config.Icon then
			local holder = Utility.Create("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.fromOffset(14, 14),
				LayoutOrder = 1,
				Parent = header,
			})
			self._icon = Icons.Create(holder, config.Icon, Icons.Options(config, {
				Size = config.IconSize or 14,
				Color = config.IconColor or "MutedText",
				Cleanup = cleanup,
			}))
		end
		local _, titleHandle = Widgets.Text(cleanup, {
			Parent = header,
			Text = config.Title or "List",
			Color = config.TitleColor or "Text",
			Gradient = config.TitleGradient,
			Bold = true,
			AutomaticSize = Enum.AutomaticSize.X,
			Size = UDim2.new(0, 0, 1, 0),
			LayoutOrder = 2,
		})
		self._title = titleHandle
		local _, countHandle = Widgets.Text(cleanup, {
			Parent = header,
			Text = "0",
			Color = "MutedText",
			TextSize = 11,
			AutomaticSize = Enum.AutomaticSize.X,
			Size = UDim2.new(0, 0, 1, 0),
			LayoutOrder = 3,
		})

		local body = Utility.Create("Frame", {
			Name = "Items",
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.new(1, 0, 0, 0),
			LayoutOrder = 2,
			Parent = frame,
		})
		Widgets.List(body, 4)

		local rows = cleanup:Extend()
		local empty = config.Empty or "Nothing here yet"

		local function build(items)
			rows:Clean()
			rows = cleanup:Extend()
			countHandle.SetText(tostring(#items))
			if #items == 0 then
				rows:Add((Widgets.Text(rows, {
					Parent = body,
					Text = empty,
					Color = "MutedText",
					TextSize = 12,
					Size = UDim2.new(1, 0, 0, 24),
					LayoutOrder = 1,
				})))
				return
			end
			for index, item in items do
				local row = Widgets.Surface(rows, {
					Class = "TextButton",
					Name = "Item",
					Parent = body,
					Fill = "TertiaryBackground",
					Transparency = "ElementTransparency",
					Radius = 9,
					Size = UDim2.new(1, 0, 0, 28),
					LayoutOrder = index,
				})
				rows:Add(row)

				Widgets.Text(rows, {
					Parent = row,
					Text = tostring(index),
					Color = "MutedText",
					TextSize = 11,
					TextXAlignment = Enum.TextXAlignment.Center,
					Position = UDim2.fromOffset(4, 0),
					Size = UDim2.fromOffset(18, 28),
				})

				local label, text = Widgets.Text(rows, {
					Class = config.Editable ~= false and "TextBox" or "TextLabel",
					Parent = row,
					Text = item,
					Color = config.ItemColor,
					TextSize = 12,
					TextTruncate = Enum.TextTruncate.AtEnd,
					Position = UDim2.fromOffset(24, 0),
					Size = UDim2.new(1, -(24 + (config.Removable ~= false and 30 or 8)), 1, 0),
					Markup = config.Editable == false,
				})

				if config.Editable ~= false then
					local editor = Editable.Attach(rows, label, text, {
						Label = "List item",
						Color = config.ItemColor,
						Source = function()
							return item
						end,
						Validate = function(value)
							return value ~= "" and (value == item or self:Has(value) == false)
						end,
						OnCommit = function(value)
							self:Rename(item, value)
						end,
					})
					rows:Add(row.Activated:Connect(function()
						editor.Begin()
					end))
				end

				if config.Removable ~= false then
					local trash = Widgets.Chip(rows, {
						Name = "Remove",
						Parent = row,
						Radius = "Full",
						AnchorPoint = Vector2.new(1, 0.5),
						Position = UDim2.new(1, -5, 0.5, 0),
						Size = UDim2.fromOffset(19, 19),
						ZIndex = 3,
					})
					Icons.Create(trash, "x", { Size = 10, Color = "Error", Position = UDim2.fromOffset(4.5, 4.5), Cleanup = rows })
					rows:Add(trash.Activated:Connect(function()
						self:Remove(item)
					end))
				end
			end
		end

		if config.Creatable ~= false then
			local addRow = Utility.Create("Frame", {
				Name = "Add",
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 28),
				LayoutOrder = 3,
				Parent = frame,
			})
			local holder, box, _, field = Widgets.Field(cleanup, {
				Name = "Input",
				Parent = addRow,
				Radius = 9,
				Placeholder = config.Placeholder or "Add item...",
				Size = UDim2.new(1, -32, 1, 0),
			})
			local add = Widgets.Chip(cleanup, {
				Name = "Confirm",
				Parent = addRow,
				Radius = 9,
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.new(1, 0, 0.5, 0),
				Size = UDim2.fromOffset(28, 28),
				Fill = "Accent",
				Transparency = 0,
			})
			Icons.Create(add, "plus", { Size = 13, Color = "AccentText", Position = UDim2.fromOffset(7.5, 7.5), Cleanup = cleanup })

			local function commit()
				local value = box.Text
				if value == "" then
					return
				end
				if self:Has(value) and not config.Duplicates then
					field.Flash("Error")
					return
				end
				self:Add(value)
				box.Text = ""
				Widgets.Pulse(add, 0.8, 0.3)
			end
			cleanup:Add(add.Activated:Connect(commit))
			cleanup:Add(box.FocusLost:Connect(function(enter)
				if enter then
					commit()
				end
			end))
		end

		Component.BindValue(self, id, config.Default or {}, function(items)
			build(items)
			self.ItemsChanged:Fire(table.clone(items))
		end)
		return self
	end
end
end)()

__modules["Components/Player"] = (function()
return function(import)
	local Players = game:GetService("Players")
	local Component = import("Core/Component")
	local Utility = import("Core/Utility")
	local Signal = import("Core/Signal")
	local Widgets = import("Core/Widgets")
	local Theme = import("Core/Theme")
	local Icons = import("Icons/Icon")
	local Animation = import("Services/Animation")

	local Picker = setmetatable({}, { __index = Component.Base })
	Picker.__index = Picker

	local ROW = 34

	local function headshot(player)
		return string.format("rbxthumb://type=AvatarHeadShot&id=%d&w=48&h=48", player.UserId)
	end

	function Picker:_Normalize(value)
		if value == nil then
			return true, nil
		end
		if typeof(value) == "Instance" and value:IsA("Player") then
			return true, value.Name
		end
		if type(value) == "string" then
			return true, value
		end
		return false
	end

	function Picker:GetPlayer()
		local name = self.State:Get()
		return name and Players:FindFirstChild(name) or nil
	end

	function Picker:_List()
		local out = {}
		local me = Players.LocalPlayer
		for _, player in Players:GetPlayers() do
			if player ~= me or self.Config.IncludeSelf == true then
				if not self.Config.Filter or self.Config.Filter(player) then
					table.insert(out, player)
				end
			end
		end
		table.sort(out, function(a, b)
			return a.DisplayName:lower() < b.DisplayName:lower()
		end)
		return out
	end

	function Picker:Refresh()
		local name = self.State:Get()
		if name and not Players:FindFirstChild(name) and self.Config.Clear ~= false then
			self.State:Set(nil)
		end
		self._render(self.State:Get())
		if self._rebuild then
			self._rebuild()
		end
		return self
	end

	function Picker:Close()
		if self._popup then
			self._popup.Close()
		end
		return self
	end

	function Picker:_Open()
		if self._destroyed or not self.Enabled or self._popup then
			return
		end
		local button = self._button
		local width = math.max(self.Config.PopupWidth or 210, button.AbsoluteSize.X / Theme.Scale)
		local list = self:_List()
		local function measure(count)
			return math.min(math.clamp(count, 1, 6) * ROW + 10 + 34, 300)
		end
		local popup = self.Window:OpenPopup(button, width, measure(#list))
		self._popup = popup
		local cleanup = popup.Cleanup
		Animation:Play(self._chevron.Instance, { Rotation = 180 }, { Duration = 0.18 })
		cleanup:Add(popup.Closed:Connect(function()
			if self._popup == popup then
				self._popup = nil
			end
			self._rebuild = nil
			if self._chevron.Instance.Parent then
				Animation:Play(self._chevron.Instance, { Rotation = 0 }, { Duration = 0.18 })
			end
		end))

		local filterText = ""
		local _, filterBox = Widgets.Field(cleanup, {
			Name = "Filter",
			Parent = popup.Frame,
			Radius = 8,
			Placeholder = "Search player...",
			Position = UDim2.fromOffset(5, 5),
			Size = UDim2.new(1, -10, 0, 24),
		})

		local scroller = Widgets.Scroller(cleanup, {
			Name = "Players",
			Parent = popup.Frame,
			Position = UDim2.fromOffset(0, 34),
			Size = UDim2.new(1, 0, 1, -34),
		})
		Widgets.Padding(scroller, 5)
		Widgets.List(scroller, 2)

		local rows = cleanup:Extend()

		local function build()
			rows:Clean()
			rows = cleanup:Extend()
			local shown = 0
			for index, player in self:_List() do
				local label = player.DisplayName
				if filterText == "" or string.find(string.lower(label .. player.Name), filterText, 1, true) then
					shown += 1
					local row = Widgets.Surface(rows, {
						Class = "TextButton",
						Name = player.Name,
						Parent = scroller,
						Fill = "SecondaryBackground",
						Transparency = 1,
						Radius = 9,
						Size = UDim2.new(1, 0, 0, ROW - 2),
						LayoutOrder = index,
					})
					rows:Add(row)
					local holder = Utility.Create("Frame", {
						BackgroundTransparency = 1,
						AnchorPoint = Vector2.new(0, 0.5),
						Position = UDim2.new(0, 7, 0.5, 0),
						Size = UDim2.fromOffset(22, 22),
						Parent = row,
					})
					Icons.Create(holder, headshot(player), { Size = 22, Corner = "Full", Cleanup = rows })
					Widgets.Text(rows, {
						Parent = row,
						Text = label,
						TextSize = 12,
						Bold = true,
						Position = UDim2.new(0, 36, 0, 4),
						Size = UDim2.new(1, -62, 0, 13),
						TextTruncate = Enum.TextTruncate.AtEnd,
						Markup = false,
					})
					Widgets.Text(rows, {
						Parent = row,
						Text = "@" .. player.Name,
						Color = "MutedText",
						TextSize = 11,
						Position = UDim2.new(0, 36, 0, 16),
						Size = UDim2.new(1, -62, 0, 12),
						TextTruncate = Enum.TextTruncate.AtEnd,
						Markup = false,
					})
					local check = Icons.Create(row, "check", {
						Size = 13,
						Color = "Accent",
						AnchorPoint = Vector2.new(1, 0.5),
						Position = UDim2.new(1, -8, 0.5, 0),
						Cleanup = rows,
					})
					check.Instance.Visible = self.State:Get() == player.Name
					Widgets.Interactive(rows, row, row, { Alpha = { 1, 0.6, 0.45 } })
					rows:Add(row.Activated:Connect(function()
						self.State:Set(player.Name)
						popup.Close()
					end))
				end
			end
			if shown == 0 then
				rows:Add((Widgets.Text(rows, {
					Parent = scroller,
					Text = "No players",
					Color = "MutedText",
					TextXAlignment = Enum.TextXAlignment.Center,
					Size = UDim2.new(1, 0, 0, ROW),
				})))
				shown = 1
			end
			popup.Resize(measure(shown))
		end
		self._rebuild = build
		build()

		cleanup:Add(filterBox:GetPropertyChangedSignal("Text"):Connect(function()
			filterText = string.lower(filterBox.Text)
			build()
		end))
	end

	return function(ctx, id, config)
		local self = Component.New(ctx, Picker, "Player", id, config, {
			RightWidth = config.Width or 176,
			RightHeight = 26,
		})
		local cleanup = self.Cleanup
		self.Picked = Signal.new()
		cleanup:Add(self.Picked)

		local button = Widgets.Surface(cleanup, {
			Class = "TextButton",
			Name = "Select",
			Parent = self.Right,
			Fill = "TertiaryBackground",
			Transparency = "ElementTransparency",
			Stroke = "Border",
			StrokeTransparency = 0.45,
			Radius = 10,
			Size = UDim2.fromScale(1, 1),
		})
		self._button = button

		local avatarHolder = Utility.Create("Frame", {
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0, 5, 0.5, 0),
			Size = UDim2.fromOffset(18, 18),
			Visible = false,
			Parent = button,
		})
		self._avatar = Icons.Create(avatarHolder, nil, { Size = 18, Corner = "Full", Cleanup = cleanup })

		local _, label = Widgets.Text(cleanup, {
			Parent = button,
			Position = UDim2.fromOffset(10, 0),
			Size = UDim2.new(1, -32, 1, 0),
			TextSize = 12,
			TextTruncate = Enum.TextTruncate.AtEnd,
			Markup = false,
		})
		self._label = label
		self._chevron = Icons.Create(button, "chevron-down", {
			Size = 13,
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, -8, 0.5, 0),
			Cleanup = cleanup,
		})
		Widgets.Interactive(cleanup, button, button, { Base = "TertiaryBackground" })

		self._render = function(value)
			local player = value and Players:FindFirstChild(value)
			if player then
				self._avatar:Set(headshot(player))
				avatarHolder.Visible = true
				label.Instance.Position = UDim2.fromOffset(28, 0)
				label.Instance.Size = UDim2.new(1, -50, 1, 0)
				label.SetText(player.DisplayName)
			else
				avatarHolder.Visible = false
				label.Instance.Position = UDim2.fromOffset(10, 0)
				label.Instance.Size = UDim2.new(1, -32, 1, 0)
				label.SetText(config.Placeholder or "Select player")
			end
		end

		Component.BindValue(self, id, config.Default, function(value)
			self._render(value)
			self.Picked:Fire(value and Players:FindFirstChild(value) or nil)
		end)

		cleanup:Add(button.Activated:Connect(function()
			if self._popup then
				self:Close()
				return
			end
			self:_Open()
		end))
		cleanup:Add(Players.PlayerAdded:Connect(function()
			if self._rebuild then
				self._rebuild()
			end
		end))
		cleanup:Add(Players.PlayerRemoving:Connect(function(player)
			task.defer(function()
				if not self._destroyed then
					if self.State:Get() == player.Name and config.Clear ~= false then
						self.State:Set(nil)
					end
					if self._rebuild then
						self._rebuild()
					end
				end
			end)
		end))
		cleanup:Add(function()
			if self._popup then
				self._popup.Close()
			end
		end)
		return self
	end
end
end)()

__modules["Components/Preview"] = (function()
return function(import)
	local RunService = game:GetService("RunService")
	local Players = game:GetService("Players")
	local Component = import("Core/Component")
	local Utility = import("Core/Utility")
	local Signal = import("Core/Signal")
	local Theme = import("Core/Theme")
	local Widgets = import("Core/Widgets")
	local Icons = import("Icons/Icon")
	local Drag = import("Services/Drag")
	local Animation = import("Services/Animation")

	local Preview = {}

	Preview.__index = function(object, key)
		local method = rawget(Preview, key)
		if method ~= nil then
			return method
		end
		local base = Component.Base[key]
		if base ~= nil then
			return base
		end
		local name = type(key) == "string" and string.match(key, "^Add(%u%w*)$")
		if name and Component.Registry[name] then
			return function(self, first, second)
				return Component.Add(self, name, first, second)
			end
		end
		return nil
	end

	local LIMBS = {
		{ "Head", "UpperTorso" },
		{ "UpperTorso", "LowerTorso" },
		{ "UpperTorso", "LeftUpperArm" },
		{ "LeftUpperArm", "LeftLowerArm" },
		{ "LeftLowerArm", "LeftHand" },
		{ "UpperTorso", "RightUpperArm" },
		{ "RightUpperArm", "RightLowerArm" },
		{ "RightLowerArm", "RightHand" },
		{ "LowerTorso", "LeftUpperLeg" },
		{ "LeftUpperLeg", "LeftLowerLeg" },
		{ "LeftLowerLeg", "LeftFoot" },
		{ "LowerTorso", "RightUpperLeg" },
		{ "RightUpperLeg", "RightLowerLeg" },
		{ "RightLowerLeg", "RightFoot" },
		{ "Head", "Torso" },
		{ "Torso", "Left Arm" },
		{ "Torso", "Right Arm" },
		{ "Torso", "Left Leg" },
		{ "Torso", "Right Leg" },
	}

	local function dummy()
		local model = Instance.new("Model")
		model.Name = "Dummy"
		local function part(name, size, offset, color)
			local piece = Instance.new("Part")
			piece.Name = name
			piece.Size = size
			piece.CFrame = CFrame.new(offset)
			piece.Anchored = true
			piece.CanCollide = false
			piece.Color = color
			piece.TopSurface = Enum.SurfaceType.Smooth
			piece.BottomSurface = Enum.SurfaceType.Smooth
			piece.Parent = model
			return piece
		end
		local skin = Color3.fromRGB(234, 184, 146)
		local shirt = Color3.fromRGB(70, 90, 140)
		local pants = Color3.fromRGB(45, 48, 60)
		part("Head", Vector3.new(1.2, 1.2, 1.2), Vector3.new(0, 4.5, 0), skin)
		local torso = part("Torso", Vector3.new(2, 2, 1), Vector3.new(0, 3, 0), shirt)
		part("Left Arm", Vector3.new(1, 2, 1), Vector3.new(-1.5, 3, 0), skin)
		part("Right Arm", Vector3.new(1, 2, 1), Vector3.new(1.5, 3, 0), skin)
		part("Left Leg", Vector3.new(1, 2, 1), Vector3.new(-0.5, 1, 0), pants)
		part("Right Leg", Vector3.new(1, 2, 1), Vector3.new(0.5, 1, 0), pants)
		model.PrimaryPart = torso
		return model
	end

	local function subject(source)
		if typeof(source) == "Instance" then
			if source:IsA("Model") then
				return source
			end
			if source:IsA("Player") then
				return source.Character
			end
		end
		if type(source) == "string" then
			local player = Players:FindFirstChild(source)
			return player and player.Character or nil
		end
		return nil
	end

	function Preview:SetModel(source)
		local target = subject(source)
		local model
		if target then
			local ok, clone = pcall(function()
				target.Archivable = true
				return target:Clone()
			end)
			model = ok and clone or nil
		end
		if not model then
			model = dummy()
		end
		for _, item in model:GetDescendants() do
			if item:IsA("BasePart") then
				item.Anchored = true
				item.CanCollide = false
				item.CastShadow = false
			elseif item:IsA("Script") or item:IsA("LocalScript") or item:IsA("Humanoid") then
				item:Destroy()
			end
		end
		if self._model then
			self._model:Destroy()
		end
		self._model = model
		model.Parent = self._world

		local pivot = model:GetPivot()
		self._origin = CFrame.new(pivot.Position)
		self:Refocus()
		self:_Apply()
		self.ModelChanged:Fire(model)
		return self
	end

	function Preview:GetModel()
		return self._model
	end

	function Preview:Refocus()
		local model, camera, viewport = self._model, self._camera, self.Viewport
		if not model or not model.Parent then
			return self
		end
		local box, size = model:GetBoundingBox()
		local view = viewport.AbsoluteSize
		local aspect = view.Y > 0 and math.max(view.X / view.Y, 0.05) or 1
		local half = math.tan(math.rad(camera.FieldOfView / 2))
		local spread = math.max(size.X, size.Z, 1)
		local vertical = (math.max(size.Y, 1) / 2) / half
		local horizontal = (spread / 2) / (half * aspect)
		local distance = math.max(vertical, horizontal) * (self.Config.Zoom or 1.3)
		self._distanceStuds = distance
		camera.CFrame = CFrame.new(box.Position + Vector3.new(0, 0, -distance), box.Position)
		return self
	end

	function Preview:SetFeature(name, enabled)
		self.Features[name] = enabled == true
		self:_Apply()
		return self
	end

	function Preview:GetFeature(name)
		return self.Features[name] == true
	end

	function Preview:ToggleFeature(name)
		return self:SetFeature(name, not self.Features[name])
	end

	function Preview:SetColor(color)
		self.Color = Theme.Resolve(color, "Accent")
		self:_Apply()
		return self
	end

	function Preview:SetThickness(value)
		self.Thickness = math.clamp(tonumber(value) or 1, 1, 6)
		self:_Apply()
		return self
	end

	function Preview:SetLabel(text)
		self._espName = text
		return self
	end

	function Preview:SetSpin(enabled)
		self._spin = enabled == true
		return self
	end

	function Preview:GetFeatures()
		return table.clone(self.Features)
	end

	function Preview:_Apply()
		local color = self.Color or Theme.Get("Accent")
		for _, item in self._parts do
			if item.stroke then
				item.stroke.Color = color
				item.stroke.Thickness = self.Thickness
			else
				item.instance.BackgroundColor3 = color
			end
		end
		if self._chams then
			local on = self.Features.Chams
			for _, piece in self._model and self._model:GetDescendants() or {} do
				if piece:IsA("BasePart") then
					if on then
						if self._original[piece] == nil then
							self._original[piece] = { piece.Color, piece.Material, piece.Transparency }
						end
						piece.Color = color
						piece.Material = Enum.Material.Neon
					elseif self._original[piece] then
						piece.Color = self._original[piece][1]
						piece.Material = self._original[piece][2]
						piece.Transparency = self._original[piece][3]
					end
				end
			end
		end
	end

	function Preview:_Draw()
		local model, camera = self._model, self._camera
		local overlay = self._overlay
		if not model or not model.Parent or not overlay.Parent then
			return
		end
		local size = overlay.AbsoluteSize
		if size.X < 4 or size.Y < 4 then
			return
		end

		local box3, extent = model:GetBoundingBox()
		local minX, minY, maxX, maxY = math.huge, math.huge, -math.huge, -math.huge
		for x = -1, 1, 2 do
			for y = -1, 1, 2 do
				for z = -1, 1, 2 do
					local world = box3.Position + Vector3.new(extent.X / 2 * x, extent.Y / 2 * y, extent.Z / 2 * z)
					local point = camera:WorldToViewportPoint(world)
					minX, maxX = math.min(minX, point.X), math.max(maxX, point.X)
					minY, maxY = math.min(minY, point.Y), math.max(maxY, point.Y)
				end
			end
		end
		local width, height = maxX - minX, maxY - minY
		local box = self._box
		box.Position = UDim2.fromOffset(minX, minY)
		box.Size = UDim2.fromOffset(width, height)
		box.Visible = self.Features.Box == true

		for index, piece in self._corners do
			piece.Visible = self.Features.Corners == true
			local length = math.min(width, height) * 0.25
			if index == 1 then
				piece.Position = UDim2.fromOffset(minX, minY)
			elseif index == 2 then
				piece.Position = UDim2.fromOffset(maxX - length, minY)
			elseif index == 3 then
				piece.Position = UDim2.fromOffset(minX, maxY - length)
			else
				piece.Position = UDim2.fromOffset(maxX - length, maxY - length)
			end
			piece.Size = UDim2.fromOffset(length, length)
		end

		self._name.Visible = self.Features.Name == true
		self._name.Position = UDim2.fromOffset(minX + width / 2, minY - 15)
		self._name.Size = UDim2.fromOffset(math.max(width, 60), 13)

		self._distance.Visible = self.Features.Distance == true
		self._distance.Position = UDim2.fromOffset(minX + width / 2, maxY + 3)
		self._distance.Size = UDim2.fromOffset(math.max(width, 60), 12)

		local healthbar = self._health
		healthbar.Visible = self.Features.Health == true
		healthbar.Position = UDim2.fromOffset(minX - 6, minY)
		healthbar.Size = UDim2.fromOffset(3, height)
		self._healthFill.Size = UDim2.new(1, 0, self._healthValue, 0)

		local tracer = self._tracer
		tracer.Visible = self.Features.Tracer == true
		if tracer.Visible then
			local originX, originY = size.X / 2, size.Y
			local targetX, targetY = minX + width / 2, maxY
			local dx, dy = targetX - originX, targetY - originY
			local length = math.sqrt(dx * dx + dy * dy)
			tracer.Position = UDim2.fromOffset((originX + targetX) / 2, (originY + targetY) / 2)
			tracer.Size = UDim2.fromOffset(length, self.Thickness)
			tracer.Rotation = math.deg(math.atan2(dy, dx))
		end

		local skeleton = self.Features.Skeleton == true
		for index, line in self._bones do
			local pair = LIMBS[index]
			local a = model:FindFirstChild(pair[1])
			local b = model:FindFirstChild(pair[2])
			if skeleton and a and b then
				local pa = camera:WorldToViewportPoint(a.Position)
				local pb = camera:WorldToViewportPoint(b.Position)
				local dx, dy = pb.X - pa.X, pb.Y - pa.Y
				local length = math.sqrt(dx * dx + dy * dy)
				line.Visible = true
				line.Position = UDim2.fromOffset((pa.X + pb.X) / 2, (pa.Y + pb.Y) / 2)
				line.Size = UDim2.fromOffset(length, math.max(self.Thickness - 0.5, 1))
				line.Rotation = math.deg(math.atan2(dy, dx))
			else
				line.Visible = false
			end
		end
	end

	return function(ctx, id, config)
		local self = Component.NewBare(ctx, Preview, "Preview", id, config)
		local cleanup = self.Cleanup
		local height = config.Height or 186
		local paneWidth = config.PaneWidth or 136

		self.Window = ctx.Window
		self.TabRef, self.SectionRef = ctx.Tab, ctx.Section
		self.Features = config.Features or {}
		self.Color = Theme.Resolve(config.Color, "Accent")
		self.Thickness = config.Thickness or 1
		self.ModelChanged = Signal.new()
		self._parts, self._corners, self._bones, self._original = {}, {}, {}, {}
		self._healthValue = config.Health or 0.72
		self._espName = config.Label or "Player"
		self._spin = config.Spin ~= false
		self._order = 0
		self.NextOrder = function()
			self._order += 1
			return self._order
		end
		cleanup:Add(self.ModelChanged)

		local frame, stroke = Widgets.Surface(cleanup, {
			Name = "Preview",
			Parent = ctx.Parent,
			Fill = "SecondaryBackground",
			Transparency = "ComponentTransparency",
			Stroke = "Border",
			StrokeTransparency = "ComponentStrokeTransparency",
			Radius = 16,
			Size = UDim2.new(1, 0, 0, height),
			LayoutOrder = ctx.Order(),
		})
		cleanup:Add(frame)
		self.Frame, self.Stroke = frame, stroke
		Widgets.Padding(frame, 10, 10)

		local stage = Widgets.Surface(cleanup, {
			Name = "Stage",
			Parent = frame,
			Fill = config.StageColor or "Background",
			Transparency = config.StageTransparency or 0.25,
			Stroke = "Border",
			StrokeTransparency = 0.55,
			Radius = 12,
			ClipsDescendants = true,
			Size = UDim2.new(0, paneWidth, 1, 0),
		})
		self.Stage = stage

		local viewport = Utility.Create("ViewportFrame", {
			Name = "Viewport",
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			Ambient = config.Ambient or Color3.fromRGB(190, 190, 200),
			LightColor = config.LightColor or Color3.fromRGB(255, 255, 255),
			LightDirection = Vector3.new(-0.3, -1, -0.6),
			Parent = stage,
		})
		self.Viewport = viewport

		local world = Instance.new("WorldModel")
		world.Parent = viewport
		self._world = world

		local camera = Instance.new("Camera")
		camera.FieldOfView = config.FieldOfView or 42
		camera.Parent = viewport
		viewport.CurrentCamera = camera
		self._camera = camera

		local overlay = Utility.Create("Frame", {
			Name = "Esp",
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			ClipsDescendants = true,
			ZIndex = 3,
			Parent = stage,
		})
		self._overlay = overlay

		local box = Utility.Create("Frame", {
			Name = "Box",
			BackgroundTransparency = 1,
			Visible = false,
			Parent = overlay,
		})
		local boxStroke = Utility.Create("UIStroke", { Thickness = 1, Parent = box })
		self._box = box
		table.insert(self._parts, { instance = box, stroke = boxStroke })

		for index = 1, 4 do
			local corner = Utility.Create("Frame", {
				Name = "Corner",
				BackgroundTransparency = 1,
				Visible = false,
				Parent = overlay,
			})
			local horizontal = Utility.Create("Frame", {
				Size = UDim2.new(1, 0, 0, 1),
				Position = index <= 2 and UDim2.new() or UDim2.new(0, 0, 1, -1),
				Parent = corner,
			})
			local vertical = Utility.Create("Frame", {
				Size = UDim2.new(0, 1, 1, 0),
				Position = (index % 2 == 1) and UDim2.new() or UDim2.new(1, -1, 0, 0),
				Parent = corner,
			})
			table.insert(self._parts, { instance = horizontal })
			table.insert(self._parts, { instance = vertical })
			table.insert(self._corners, corner)
		end

		local name = Widgets.Text(cleanup, {
			Name = "Name",
			Parent = overlay,
			Text = self._espName,
			Bold = true,
			TextSize = 11,
			TextXAlignment = Enum.TextXAlignment.Center,
			AnchorPoint = Vector2.new(0.5, 0),
			Visible = false,
			Markup = false,
		})
		self._name = name
		table.insert(self._parts, { instance = name, stroke = Utility.Create("UIStroke", { Thickness = 2, Color = Color3.new(), Transparency = 0.4, Parent = name }) })

		local distance = Widgets.Text(cleanup, {
			Name = "Distance",
			Parent = overlay,
			Text = config.Distance or "14 studs",
			TextSize = 10,
			Color = "MutedText",
			TextXAlignment = Enum.TextXAlignment.Center,
			AnchorPoint = Vector2.new(0.5, 0),
			Visible = false,
			Markup = false,
		})
		self._distance = distance

		local health = Utility.Create("Frame", {
			Name = "Health",
			BackgroundColor3 = Color3.fromRGB(20, 20, 20),
			Visible = false,
			Parent = overlay,
		})
		local healthFill = Utility.Create("Frame", {
			BackgroundColor3 = Color3.fromRGB(80, 220, 120),
			AnchorPoint = Vector2.new(0, 1),
			Position = UDim2.fromScale(0, 1),
			Size = UDim2.fromScale(1, 0.7),
			Parent = health,
		})
		self._health, self._healthFill = health, healthFill

		local tracer = Utility.Create("Frame", {
			Name = "Tracer",
			AnchorPoint = Vector2.new(0.5, 0.5),
			Visible = false,
			Parent = overlay,
		})
		self._tracer = tracer
		table.insert(self._parts, { instance = tracer })

		for _ = 1, #LIMBS do
			local bone = Utility.Create("Frame", {
				Name = "Bone",
				AnchorPoint = Vector2.new(0.5, 0.5),
				Visible = false,
				Parent = overlay,
			})
			table.insert(self._bones, bone)
			table.insert(self._parts, { instance = bone })
		end

		local right = Utility.Create("Frame", {
			Name = "Panel",
			BackgroundTransparency = 1,
			Position = UDim2.fromOffset(paneWidth + 10, 0),
			Size = UDim2.new(1, -(paneWidth + 10), 1, 0),
			Parent = frame,
		})
		local scroller = Widgets.Scroller(cleanup, {
			Name = "Options",
			Parent = right,
			Thickness = 2,
		})
		Widgets.List(scroller, 6)
		self.Container = scroller

		if config.Title then
			local header = Utility.Create("Frame", {
				Name = "Header",
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 16),
				LayoutOrder = 0,
				Parent = scroller,
			})
			Widgets.List(header, 6, {
				FillDirection = Enum.FillDirection.Horizontal,
				VerticalAlignment = Enum.VerticalAlignment.Center,
			})
			if config.Icon then
				local holder = Utility.Create("Frame", {
					BackgroundTransparency = 1,
					Size = UDim2.fromOffset(14, 14),
					LayoutOrder = 1,
					Parent = header,
				})
				Icons.Create(holder, config.Icon, Icons.Options(config, {
					Size = config.IconSize or 14,
					Color = config.IconColor or "Accent",
					Cleanup = cleanup,
				}))
			end
			local _, handle = Widgets.Text(cleanup, {
				Parent = header,
				Text = config.Title,
				Color = config.TitleColor or "Text",
				Gradient = config.TitleGradient,
				Bold = true,
				AutomaticSize = Enum.AutomaticSize.X,
				Size = UDim2.new(0, 0, 1, 0),
				LayoutOrder = 2,
			})
			self._title = handle
			self._order = 0
		end

		local spin = 0
		local dragging = false
		local hidden = false
		cleanup:Add(RunService.RenderStepped:Connect(function(delta)
			if self._destroyed or hidden or not self._model then
				return
			end
			if self._spin and not dragging then
				spin += delta * (config.SpinSpeed or 0.5)
			end
			self._model:PivotTo(self._origin * CFrame.Angles(0, spin, 0))
			self:_Draw()
		end))

		local hit = Utility.Create("TextButton", {
			Name = "Rotate",
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			ZIndex = 6,
			Parent = stage,
		})
		local lastX
		Drag.Track(hit, cleanup, function(position)
			dragging = true
			if lastX then
				spin -= (position.X - lastX) * 0.012
			end
			lastX = position.X
		end, function()
			dragging = false
			lastX = nil
		end)

		cleanup:Add(viewport:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
			if not self._destroyed then
				self:Refocus()
			end
		end))

		Theme.BindFn(function()
			if not self.Color or config.Color == nil then
				self.Color = Theme.Get("Accent")
			end
			self:_Apply()
		end, cleanup)

		self:SetModel(config.Model or config.Player or Players.LocalPlayer)

		function self:SetHealth(alpha)
			self._healthValue = math.clamp(tonumber(alpha) or 0, 0, 1)
			healthFill.BackgroundColor3 = Color3.fromRGB(
				math.floor(255 * (1 - self._healthValue)),
				math.floor(200 * self._healthValue + 40),
				90
			)
			return self
		end
		self:SetHealth(self._healthValue)

		function self:SetTitle(text)
			if self._title then
				self._title.SetText(text)
			end
			return self
		end

		function self:SetName(text)
			self._espName = text
			name.Text = text
			return self
		end

		function self:SetVisible(visible)
			hidden = visible == false
			frame.Visible = visible == true
			return self
		end

		return self
	end
end
end)()

__modules["Components/Graph"] = (function()
return function(import)
	local RunService = game:GetService("RunService")
	local Component = import("Core/Component")
	local Utility = import("Core/Utility")
	local Widgets = import("Core/Widgets")
	local Theme = import("Core/Theme")
	local Icons = import("Icons/Icon")
	local Animation = import("Services/Animation")

	local Graph = setmetatable({}, { __index = Component.Base })
	Graph.__index = Graph

	function Graph:Push(value)
		value = tonumber(value)
		if not value then
			return self
		end
		table.insert(self.Points, value)
		while #self.Points > self.Capacity do
			table.remove(self.Points, 1)
		end
		self._dirty = true
		return self
	end

	function Graph:Clear()
		table.clear(self.Points)
		self._dirty = true
		return self
	end

	function Graph:GetPoints()
		return table.clone(self.Points)
	end

	function Graph:Latest()
		return self.Points[#self.Points]
	end

	function Graph:Average()
		if #self.Points == 0 then
			return 0
		end
		local sum = 0
		for _, value in self.Points do
			sum += value
		end
		return sum / #self.Points
	end

	function Graph:Bounds()
		local low, high = math.huge, -math.huge
		for _, value in self.Points do
			low = math.min(low, value)
			high = math.max(high, value)
		end
		if low == math.huge then
			return 0, 1
		end
		if self.Config.Min ~= nil then
			low = self.Config.Min
		end
		if self.Config.Max ~= nil then
			high = self.Config.Max
		end
		if high - low < 1e-3 then
			high = low + 1
		end
		return low, high
	end

	function Graph:_Draw()
		local count = #self.Points
		if count == 0 then
			for _, bar in self.Bars do
				bar.Visible = false
			end
			return
		end
		local low, high = self:Bounds()
		local span = high - low
		local total = #self.Bars
		local first = math.max(count - total + 1, 1)
		local shown = count - first + 1

		for index = 1, total do
			local bar = self.Bars[index]
			local slot = index - (total - shown)
			if slot < 1 then
				bar.Visible = false
			else
				local value = self.Points[first + slot - 1]
				local alpha = math.clamp((value - low) / span, 0, 1)
				bar.Visible = true
				bar.Size = UDim2.new(1 / total, -1, math.max(alpha, 0.02), 0)
			end
		end

		if self._value then
			self._value.SetText(string.format(self.Config.Format or "%.0f", self.Points[count]) .. (self.Config.Suffix or ""))
		end
		if self._range then
			self._range.SetText(string.format("%.0f / %.0f", low, high))
		end
	end

	function Graph:Bind(getter, interval)
		self:Unbind()
		self._thread = task.spawn(function()
			while not self._destroyed do
				local ok, value = pcall(getter)
				if ok and value ~= nil then
					self:Push(value)
				end
				task.wait(interval or self.Config.Interval or 0.5)
			end
		end)
		self.Cleanup:Add(self._thread)
		return self
	end

	function Graph:Unbind()
		if self._thread then
			pcall(task.cancel, self._thread)
			self._thread = nil
		end
		return self
	end

	return function(ctx, id, config)
		local self = Component.NewBare(ctx, Graph, "Graph", id, config)
		local cleanup = self.Cleanup
		local height = config.Height or 96
		self.Points = {}
		self.Capacity = config.Capacity or 90

		local frame, stroke = Widgets.Surface(cleanup, {
			Name = "Graph",
			Parent = ctx.Parent,
			Fill = "SecondaryBackground",
			Transparency = "ComponentTransparency",
			Stroke = "Border",
			StrokeTransparency = "ComponentStrokeTransparency",
			Radius = 14,
			Size = UDim2.new(1, 0, 0, height),
			LayoutOrder = ctx.Order(),
		})
		cleanup:Add(frame)
		self.Frame, self.Stroke = frame, stroke
		Widgets.Padding(frame, 13, 11)

		local header = Utility.Create("Frame", {
			Name = "Header",
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 16),
			Parent = frame,
		})
		if config.Icon then
			local holder = Utility.Create("Frame", {
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(0, 0.5),
				Position = UDim2.new(0, 0, 0.5, 0),
				Size = UDim2.fromOffset(14, 14),
				Parent = header,
			})
			self._icon = Icons.Create(holder, config.Icon, Icons.Options(config, {
				Size = config.IconSize or 14,
				Color = config.IconColor or config.Color or "Accent",
				Cleanup = cleanup,
			}))
		end
		local _, titleHandle = Widgets.Text(cleanup, {
			Parent = header,
			Text = config.Title or "Graph",
			Color = config.TitleColor or "Text",
			Bold = true,
			TextSize = 12,
			Position = UDim2.fromOffset(config.Icon and 20 or 0, 0),
			Size = UDim2.new(1, -110, 1, 0),
			TextTruncate = Enum.TextTruncate.AtEnd,
		})
		self._title = titleHandle

		local _, value = Widgets.Text(cleanup, {
			Parent = header,
			Text = "0",
			Color = config.Color or "Accent",
			Heavy = true,
			TextSize = 13,
			TextXAlignment = Enum.TextXAlignment.Right,
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.fromScale(1, 0),
			Size = UDim2.fromOffset(74, 16),
			Markup = false,
		})
		self._value = value

		local plot = Utility.Create("Frame", {
			Name = "Plot",
			BackgroundTransparency = 1,
			ClipsDescendants = true,
			Position = UDim2.fromOffset(0, 22),
			Size = UDim2.new(1, 0, 1, -38),
			Parent = frame,
		})

		for line = 1, 3 do
			Widgets.Surface(cleanup, {
				Parent = plot,
				Fill = "Border",
				Radius = 0,
				BackgroundTransparency = 0.6,
				Position = UDim2.fromScale(0, (line - 1) / 2),
				Size = UDim2.new(1, 0, 0, 1),
			})
		end

		local bars = Utility.Create("Frame", {
			Name = "Bars",
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			Parent = plot,
		})
		self.Bars = {}
		local count = config.Bars or 48
		for index = 1, count do
			local bar = Widgets.Surface(cleanup, {
				Parent = bars,
				Fill = config.Color or "Accent",
				Radius = 2,
				AnchorPoint = Vector2.new(0, 1),
				Position = UDim2.new((index - 1) / count, 0, 1, 0),
				Size = UDim2.new(1 / count, -1, 0, 0),
				Visible = false,
			})
			table.insert(self.Bars, bar)
		end
		local stops = Widgets.Stops(config.Gradient)
		if stops then
			for _, bar in self.Bars do
				Utility.Create("UIGradient", { Color = stops, Rotation = 90, Parent = bar })
			end
		end

		local footer = Utility.Create("Frame", {
			Name = "Footer",
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(0, 1),
			Position = UDim2.fromScale(0, 1),
			Size = UDim2.new(1, 0, 0, 12),
			Parent = frame,
		})
		local _, range = Widgets.Text(cleanup, {
			Parent = footer,
			Text = "0 / 1",
			Color = "MutedText",
			TextSize = 10,
			Size = UDim2.fromScale(1, 1),
			Markup = false,
		})
		self._range = range
		if config.Description then
			Widgets.Text(cleanup, {
				Parent = footer,
				Text = config.Description,
				Color = "MutedText",
				TextSize = 10,
				TextXAlignment = Enum.TextXAlignment.Right,
				Size = UDim2.fromScale(1, 1),
			})
		end

		cleanup:Add(RunService.Heartbeat:Connect(function()
			if self._dirty and not self._destroyed then
				self._dirty = false
				self:_Draw()
			end
		end))

		function self:SetTitle(text)
			self._title.SetText(text)
			return self
		end

		if config.Source then
			self:Bind(config.Source, config.Interval)
		end
		return self
	end
end
end)()

__modules["Bootstrap"] = (function()
return function(import)
	local VERSION = "1.0.0"
	local CREDIT = "ServerDead"

	local Utility = import("Core/Utility")
	local Signal = import("Core/Signal")
	local State = import("Core/State")
	local Config = import("Core/Config")
	local Capabilities = import("Core/Capabilities")
	local Markup = import("Core/Markup")
	local Theme = import("Core/Theme")
	local Component = import("Core/Component")
	local Window = import("Core/Window")
	local Icons = import("Icons/Icon")
	local IconStore = import("Icons/Store")
	local IconRegistry = import("Icons/Registry")
	local IconProviders = import("Icons/Providers")
	local Input = import("Services/Input")
	local Acrylic = import("Services/Acrylic")
	local Tooltip = import("Services/Tooltip")
	local Notification = import("Services/Notification")
	local StatusBar = import("Services/StatusBar")
	local Hash = import("Core/Hash")

	local globalEnv
	do
		local ok, env = pcall(function()
			return getgenv()
		end)
		globalEnv = ok and env or _G
	end

	if type(globalEnv.__DeaDx) == "table" and type(globalEnv.__DeaDx.Unload) == "function" then
		pcall(function()
			globalEnv.__DeaDx:Unload()
		end)
	end

	for _, name in { "DeaDx", "Dark", "Darker", "Amoled", "Light", "Midnight", "Crimson", "Ocean", "Forest", "Amethyst", "Sunset" } do
		Theme.Register(name, import("Themes/" .. name))
	end
	Theme.Set("DeaDx")

	for _, name in {
		"Button", "Toggle", "Slider", "Dropdown", "MultiDropdown", "Input",
		"Keybind", "Colorpicker", "Paragraph", "Label", "Divider",
		"Segmented", "Progress", "Countdown", "Stat", "Image", "Code",
		"List", "Player", "Preview", "Graph",
	} do
		local path = "Components/" .. name
		local factory
		Component.Register(name, function(ctx, id, config)
			factory = factory or import(path)
			return factory(ctx, id, config)
		end)
	end

	local DeaDx = {
		Version = VERSION,
		Credit = CREDIT,
		Icons = Icons,
		IconStore = IconStore,
		Config = Config,
		Theme = Theme,
		Markup = Markup,
		State = State,
		Signal = Signal,
		Capabilities = Capabilities,
		Component = Component,
		Options = Config._states,
		Windows = {},
		StatusBars = {},
		Screens = {},
	}

	function DeaDx:CreateWindow(config)
		local window = Window.new(config or {})
		window.Owner = self
		table.insert(self.Windows, window)
		window.OnDestroy:Connect(function()
			local index = table.find(self.Windows, window)
			if index then
				table.remove(self.Windows, index)
			end
		end)
		return window
	end

	function DeaDx:CreateStatusBar(config)
		local bar = StatusBar.new(config or {})
		table.insert(self.StatusBars, bar)
		return bar
	end

	function DeaDx:StatusBarAnchors()
		return StatusBar.Anchors()
	end

	function DeaDx:CreateLoadingScreen(config)
		local screen = import("Services/Loading").new(config or {})
		table.insert(self.Screens, screen)
		return screen
	end

	function DeaDx:CreateKeySystem(config)
		local key = import("Services/KeySystem").new(config or {})
		self.Key = key
		return key
	end

	function DeaDx:Integrity()
		return import("Core/Integrity").Report()
	end

	function DeaDx:GuardIntegrity(interval, callback)
		return import("Core/Integrity").Guard(interval, callback)
	end

	function DeaDx:Luarmor(config, key)
		return import("Services/Luarmor").Check(config, key)
	end

	function DeaDx:LuarmorLoad(config, key)
		return import("Services/Luarmor").Load(config, key)
	end

	function DeaDx:LuarmorPurge(config)
		return import("Services/Luarmor").PurgeCache(config)
	end

	function DeaDx:LuarmorInfo(status)
		return import("Services/Luarmor").Info(status)
	end

	function DeaDx:KeyPlus(config, key)
		return import("Services/KeyPlus").Request(config, key)
	end

	function DeaDx:KeyPlusRun(config, key)
		return import("Services/KeyPlus").Run(config, key)
	end

	function DeaDx:KeyPlusPack(secret, key, hwid, nonce, stamp, payload)
		return import("Services/KeyPlus").Pack(secret, key, hwid, nonce, stamp, payload)
	end

	function DeaDx:KeyPlusOpen(secret, key, hwid, nonce, response, window)
		return import("Services/KeyPlus").Open(secret, key, hwid, nonce, response, window)
	end

	function DeaDx:Hash(text, salt)
		if salt ~= nil then
			return Hash.Salted(text, salt)
		end
		return Hash.Sha256(text)
	end

	function DeaDx:GetHwid()
		return Capabilities.Hwid()
	end

	function DeaDx:Notify(config)
		return Notification.Notify(config)
	end

	function DeaDx:Ask(config)
		return Notification.Ask(config)
	end

	function DeaDx:Prompt(config)
		return Notification.Prompt(config)
	end

	function DeaDx:SetNotificationSide(side)
		Notification.SetSide(side)
		return self
	end

	function DeaDx:SetNotificationMax(value)
		return Notification.SetMax(value)
	end

	function DeaDx:SetNotificationWidth(value)
		return Notification.SetWidth(value)
	end

	function DeaDx:CloseNotifications()
		Notification.CloseAll()
		return self
	end

	function DeaDx:SetTheme(name)
		return Theme.Set(name)
	end

	function DeaDx:GetTheme()
		return Theme.GetName()
	end

	function DeaDx:GetThemes()
		return Theme.Names()
	end

	function DeaDx:RegisterTheme(name, definition)
		Theme.Register(name, definition)
		return self
	end

	function DeaDx:AddThemeEditor(container, config)
		return import("Services/ThemeEditor").Build(container, config)
	end

	function DeaDx:AddConsole(container, config)
		return import("Services/Console").Build(container, config)
	end

	function DeaDx:AddConfigManager(container, config)
		return import("Services/ConfigPanel").Build(container, config)
	end

	function DeaDx:AddKeybinds(container, config)
		return import("Services/KeybindPanel").Build(container, config)
	end

	function DeaDx:Log(text, level, tag)
		return import("Services/Console").Log(text, level, tag)
	end

	function DeaDx:ClearLog()
		import("Services/Console").Clear()
		return self
	end

	function DeaDx:GetLog()
		return import("Services/Console").Dump()
	end

	function DeaDx:MirrorLog(enabled)
		import("Services/Console").Mirror = enabled == true
		return self
	end

	function DeaDx:ExportTheme(name)
		return import("Services/ThemeEditor").Export(name)
	end

	function DeaDx:SetAccent(color)
		Theme.Override("Accent", Theme.Resolve(color, "Accent"))
		return self
	end

	function DeaDx:LockTheme(name)
		return Theme.Lock(name)
	end

	function DeaDx:UnlockTheme()
		return Theme.Unlock()
	end

	function DeaDx:IsThemeLocked()
		return Theme.IsLocked()
	end

	function DeaDx:LockScale(value)
		return Theme.LockScale(value)
	end

	function DeaDx:UnlockScale()
		return Theme.UnlockScale()
	end

	function DeaDx:IsScaleLocked()
		return Theme.IsScaleLocked()
	end

	function DeaDx:SetFont(font)
		Theme.SetFont(font)
		return self
	end

	function DeaDx:SetScale(scale)
		Theme.SetScale(scale)
		return self
	end

	function DeaDx:SetIconProvider(name)
		return IconRegistry.SetProvider(name)
	end

	function DeaDx:GetIconProvider()
		return IconRegistry.GetProvider()
	end

	function DeaDx:GetIconProviders()
		return IconRegistry.Providers()
	end

	function DeaDx:RegisterIconProvider(name, resolve)
		IconRegistry.Register(name, resolve)
		return self
	end

	function DeaDx:SetIconTemplate(provider, template)
		IconProviders.SetTemplate(provider, template)
		return self
	end

	function DeaDx:RegisterIcon(alias, spec)
		IconRegistry.Alias(alias, spec)
		return self
	end

	function DeaDx:SetIconVerify(enabled)
		IconStore.Verify = enabled == true
		return self
	end

	function DeaDx:GetIconStats()
		return IconStore.Stats()
	end

	function DeaDx:ClearIconCache()
		IconStore.Clear()
		return self
	end

	function DeaDx:ForgetIcon(name)
		return IconStore.Forget(name)
	end

	function DeaDx:ImportIcon(name, body)
		return IconStore.Import(name, body)
	end

	function DeaDx:ListIcons()
		return Icons:List()
	end

	function DeaDx:RegisterComponent(name, factory)
		Component.Register(name, factory)
		return self
	end

	function DeaDx:RegisterColor(name, hex)
		Markup.RegisterColor(name, hex)
		return self
	end

	function DeaDx:SetAcrylicAssets(shadow, noise)
		if type(shadow) == "string" then
			Acrylic.ShadowAsset = shadow
		end
		if type(noise) == "string" then
			Acrylic.NoiseAsset = noise
		end
		return self
	end

	function DeaDx:Save(name)
		return Config:Save(name)
	end

	function DeaDx:Load(name)
		return Config:Load(name)
	end

	function DeaDx:DeleteConfig(name)
		return Config:Delete(name)
	end

	function DeaDx:ListConfigs()
		return Config:List()
	end

	function DeaDx:SetAutoSave(enabled, name)
		return Config:SetAutoSave(enabled, name)
	end

	function DeaDx:ResetConfig()
		Config:Reset()
		return self
	end

	function DeaDx:Undo()
		return Config:Undo()
	end

	function DeaDx:Redo()
		return Config:Redo()
	end

	function DeaDx:CanUndo()
		return Config:CanUndo()
	end

	function DeaDx:CanRedo()
		return Config:CanRedo()
	end

	function DeaDx:SetDebug(enabled)
		Utility.Debug = enabled == true
		return self
	end

	function DeaDx:GetVersion()
		return VERSION
	end

	function DeaDx:GetStats()
		local guis = 0
		local parent = Utility.GetGuiParent()
		if parent then
			for _, child in parent:GetChildren() do
				if child:GetAttribute("DeaDx") then
					guis += 1
				end
			end
		end
		return {
			Version = VERSION,
			Windows = #self.Windows,
			StatusBars = #self.StatusBars,
			Binds = Input.BindCount(),
			Guis = guis,
			Notifications = Notification.Count(),
			Theme = Theme.GetName(),
			Icons = IconStore.Stats(),
			Options = #Config:Keys(),
		}
	end

	function DeaDx:Unload()
		for _, window in table.clone(self.Windows) do
			window:Destroy()
		end
		for _, bar in table.clone(self.StatusBars) do
			bar:Destroy()
		end
		for _, screen in table.clone(self.Screens) do
			screen:Destroy()
		end
		if self.Key then
			self.Key:Destroy()
			self.Key = nil
		end
		table.clear(self.Windows)
		table.clear(self.StatusBars)
		table.clear(self.Screens)
		Notification.Reset()
		Tooltip.Reset()
		Input.Reset()
		Acrylic.Reset()
		if globalEnv.__DeaDx == self then
			globalEnv.__DeaDx = nil
		end
	end

	globalEnv.__DeaDx = DeaDx
	return DeaDx
end
end)()

local __defined = os.clock() - __clock
local __loaded = {}
local function import(path)
	local cached = __loaded[path]
	if cached ~= nil then
		return cached
	end
	local factory = __modules[path]
	if factory == nil then
		error("[DEADX][ERROR] Missing module: " .. tostring(path), 0)
	end
	local module = factory
	if type(factory) == "function" then
		module = factory(import)
	end
	__loaded[path] = module
	return module
end

local __boot = os.clock()
local __library = import("Bootstrap")
__library.LoadTime = {
	Define = math.floor(__defined * 10000) / 10,
	Boot = math.floor((os.clock() - __boot) * 10000) / 10,
	Modules = 0,
}
for _ in __loaded do
	__library.LoadTime.Modules += 1
end
return __library
