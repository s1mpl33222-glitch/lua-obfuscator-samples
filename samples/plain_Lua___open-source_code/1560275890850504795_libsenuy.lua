local sv = {
	http = game:GetService("HttpService"),
	uis = game:GetService("UserInputService"),
	ts = game:GetService("TweenService"),
	plrs = game:GetService("Players"),
	coregui = game:GetService("CoreGui"),
	sg = game:GetService("StarterGui"),
	textservice = game:GetService("TextService"),
}

local theme = {
	Accent = Color3.fromRGB(232, 232, 238),
	AccentText = Color3.fromRGB(14, 14, 17),
	Backdrop = Color3.fromRGB(9, 9, 11),
	Sidebar = Color3.fromRGB(13, 13, 16),
	Card = Color3.fromRGB(19, 19, 23),
	Element = Color3.fromRGB(27, 27, 32),
	ElementHover = Color3.fromRGB(36, 36, 43),
	Track = Color3.fromRGB(46, 46, 54),
	Stroke = Color3.fromRGB(42, 42, 50),
	StrokeSoft = Color3.fromRGB(31, 31, 37),
	Text = Color3.fromRGB(238, 238, 243),
	SubText = Color3.fromRGB(162, 162, 174),
	Dim = Color3.fromRGB(116, 116, 128),
	Good = Color3.fromRGB(74, 222, 128),
	Bad = Color3.fromRGB(248, 113, 113),
	Gold = Color3.fromRGB(245, 196, 81),
	Blue = Color3.fromRGB(96, 165, 250),
	Row = Color3.fromRGB(25, 25, 27),
	Inner = Color3.fromRGB(40, 40, 43),
	InnerHover = Color3.fromRGB(52, 52, 56),
	Field = Color3.fromRGB(43, 43, 46),
	Bar = Color3.fromRGB(66, 66, 70),
	Pill = Color3.fromRGB(20, 20, 23),
	TabActive = Color3.fromRGB(29, 29, 32),
	Option = Color3.fromRGB(34, 34, 37),
	ChatBg = Color3.fromRGB(15, 15, 17),
	Mine = Color3.fromRGB(29, 29, 32),
	Mention = Color3.fromRGB(38, 33, 22),
	Box = Color3.fromRGB(16, 16, 18),
}

local function elevate()
	local setfn = (type(setthreadidentity) == "function" and setthreadidentity)
		or (type(set_thread_identity) == "function" and set_thread_identity)
		or (type(setidentity) == "function" and setidentity)
		or (type(setthreadcontext) == "function" and setthreadcontext)
		or (type(set_thread_context) == "function" and set_thread_context)
		or (type(syn) == "table" and type(syn.set_thread_identity) == "function" and syn.set_thread_identity)
	if setfn then
		pcall(setfn, 8)
	end
end

local function hexcolor(color)
	return string.format(
		"#%02X%02X%02X",
		math.floor(color.R * 255 + 0.5),
		math.floor(color.G * 255 + 0.5),
		math.floor(color.B * 255 + 0.5)
	)
end

local function textheight(text, size, font, width, maxheight)
	local ok, bounds = pcall(function()
		return sv.textservice:GetTextSize(tostring(text or ""), size, font, Vector2.new(math.max(20, width), 100000))
	end)
	if ok and bounds and bounds.Y > 0 then
		return math.min(maxheight or 100000, math.ceil(bounds.Y) + 2)
	end
	return size
end

local function escaperich(text)
	return (tostring(text or ""):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"))
end

local function clipboardread()
	local fn = getclipboard or getclipboardtext or readclipboard
	if type(fn) ~= "function" then
		return nil
	end
	local ok, value = pcall(fn)
	if ok and type(value) == "string" and value ~= "" then
		return value
	end
	return nil
end

local function clipboardwrite(text)
	local fn = setclipboard or toclipboard or writeclipboard
	if type(fn) ~= "function" then
		return false
	end
	return (pcall(fn, tostring(text)))
end

local lucideurl = "https://raw.githubusercontent.com/latte-soft/lucide-roblox/master/lib/Icons.luau"
local iconpack, iconpackloading = nil, false
local iconqueue = {}
local loadiconpack

local iconaliases = {
	player = "user",
	players = "users",
	next = "chevron-right",
	main = "home",
	home = "home",
	config = "settings",
	setting = "settings",
	settings = "settings",
	farm = "sprout",
	auto = "repeat",
	shop = "shopping-cart",
	store = "store",
	pet = "paw-print",
	pets = "paw-print",
	misc = "layout-grid",
	visual = "eye",
	teleport = "map-pin",
	quest = "scroll",
	fishing = "fish",
	event = "calendar",
	egg = "egg",
	chat = "message-circle",
	donator = "crown",
	key = "key",
	discord = "message-square",
	info = "info",
	forum = "messages-square",
}

local fallbackicons = {
	["home"] = "rbxassetid://6340513838",
	["menu"] = "rbxassetid://6340513838",
	["settings"] = "rbxassetid://70386228443175",
	["cog"] = "rbxassetid://70386228443175",
	["eye"] = "rbxassetid://14321059114",
	["user"] = "rbxassetid://108483430622128",
	["users"] = "rbxassetid://12120698352",
	["shopping-cart"] = "rbxassetid://128874923961846",
	["store"] = "rbxassetid://4985385964",
	["backpack"] = "rbxassetid://8601111810",
	["sword"] = "rbxassetid://82472368671405",
	["swords"] = "rbxassetid://82472368671405",
	["repeat"] = "rbxassetid://122032243989747",
	["refresh-cw"] = "rbxassetid://122032243989747",
	["map-pin"] = "rbxassetid://17824309485",
	["compass"] = "rbxassetid://125300760963399",
	["gamepad-2"] = "rbxassetid://84173963561612",
	["scroll"] = "rbxassetid://114127804740858",
	["crosshair"] = "rbxassetid://12614416478",
	["bar-chart"] = "rbxassetid://12094445329",
	["activity"] = "rbxassetid://12094445329",
	["star"] = "rbxassetid://107005941750079",
	["skull"] = "rbxassetid://17313330026",
	["credit-card"] = "rbxassetid://18747025078",
	["scan"] = "rbxassetid://109869955247116",
	["search"] = "rbxassetid://8447654914",
	["alert-triangle"] = "rbxassetid://73186275216515",
	["help-circle"] = "rbxassetid://17510196486",
	["lightbulb"] = "rbxassetid://16833255748",
	["info"] = "rbxassetid://16833255748",
	["messages-square"] = "rbxassetid://12120698352",
	["zap"] = "rbxassetid://13321880293",
	["droplet"] = "rbxassetid://100076212630732",
	["play"] = "rbxassetid://108886429866687",
	["chevron-right"] = "rbxassetid://12662718374",
	["fish"] = "rbxassetid://97167558235554",
	["globe"] = "rbxassetid://137601480983962",
	["mouse-pointer-click"] = "rbxassetid://7734010488",
	["egg"] = "rbxassetid://8601111810",
	["gift"] = "rbxassetid://18747025078",
}

local function lucideasset(name, size)
	if not iconpack then
		return nil
	end
	local set = iconpack[tostring(size or 48) .. "px"] or iconpack["48px"] or iconpack["256px"]
	local entry = set and set[name]
	if type(entry) ~= "table" then
		return nil
	end
	local rect, offset = entry[2], entry[3]
	return "rbxassetid://" .. tostring(entry[1]),
		Vector2.new(offset and offset[1] or 0, offset and offset[2] or 0),
		Vector2.new(rect and rect[1] or 0, rect and rect[2] or 0)
end

local function applyicon(image, name, size)
	if not image then
		return false
	end
	name = tostring(name or "")
	if name == "" then
		image.Image = ""
		return false
	end
	if tonumber(name) then
		name = "rbxassetid://" .. name
	end
	if name:match("^rbxassetid://") or name:match("^rbxasset://") or name:match("^http") or name:match("^rbxthumb://") then
		image.Image = name
		image.ImageRectOffset = Vector2.new(0, 0)
		image.ImageRectSize = Vector2.new(0, 0)
		return true
	end

	name = iconaliases[name:lower()] or name:lower()

	local assetid, rectoffset, rectsize = lucideasset(name, size or 48)
	if assetid then
		image.Image = assetid
		image.ImageRectOffset = rectoffset
		image.ImageRectSize = rectsize
		return true
	end

	if not iconpack then
		table.insert(iconqueue, { image, name, size })
		loadiconpack()
	end

	local fallback = fallbackicons[name] or fallbackicons[(name:gsub("_", "-"))]
	image.Image = fallback or ""
	image.ImageRectOffset = Vector2.new(0, 0)
	image.ImageRectSize = Vector2.new(0, 0)
	return fallback ~= nil
end

-- Roblox can't show an https:// image directly: download it once into
-- Sena/cache (kept even after the link expires) and load it with getcustomasset.
local function urlimage(url, cacheonly)
	if type(getcustomasset) ~= "function" or type(writefile) ~= "function" then
		return nil
	end
	local name = tostring(url):gsub("[?#].*$", ""):match("([^/]+)$") or "image.png"
	name = name:gsub("[^%w%._%-]", "")
	if not name:match("%.%w+$") then
		name = name .. ".png"
	end
	local path = "Sena/cache/" .. name
	pcall(function()
		if not isfolder("Sena") then
			makefolder("Sena")
		end
		if not isfolder("Sena/cache") then
			makefolder("Sena/cache")
		end
	end)
	local cached = false
	pcall(function()
		cached = isfile(path)
	end)
	if not cached and cacheonly then
		return nil
	end
	if not cached then
		local ok, body = pcall(function()
			return game:HttpGet(url, true)
		end)
		if not ok or type(body) ~= "string" or #body < 64 then
			return nil
		end
		if not pcall(writefile, path, body) then
			return nil
		end
	end
	local ok, asset = pcall(getcustomasset, path)
	return ok and asset or nil
end

loadiconpack = function()
	if iconpack or iconpackloading then
		return
	end
	iconpackloading = true
	task.spawn(function()
		local ok, cached = pcall(function()
			return getgenv().SenaLucideIcons
		end)
		if ok and type(cached) == "table" then
			iconpack = cached
		else
			pcall(function()
				local source = game:HttpGet(lucideurl)
				if type(source) == "string" and #source > 1000 then
					local chunk = loadstring(source)
					if chunk then
						local okrun, result = pcall(chunk)
						if okrun and type(result) == "table" then
							iconpack = result
							pcall(function()
								getgenv().SenaLucideIcons = result
							end)
						end
					end
				end
			end)
		end
		iconpackloading = false

		local queue = iconqueue
		iconqueue = {}
		if iconpack then
			elevate()
			for _, entry in ipairs(queue) do
				if entry[1] and entry[1].Parent then
					pcall(applyicon, entry[1], entry[2], entry[3])
				end
			end
		end
	end)
end

task.defer(loadiconpack)

local function executorname()
	local ok, name = pcall(function()
		if type(identifyexecutor) == "function" then
			return (identifyexecutor())
		end
		if type(getexecutorname) == "function" then
			return getexecutorname()
		end
		return nil
	end)
	name = ok and name and tostring(name) or ""
	name = name:gsub("^%s+", ""):gsub("%s+$", "")
	if name == "" then
		return game:GetService("RunService"):IsStudio() and "Studio" or "Unknown"
	end
	return name
end

if getgenv().ChloeX_Running then
	if getgenv().ChloeX_ReopenPrompt then
		return
	end

	getgenv().ChloeX_ReopenPrompt = true

	local bind = Instance.new("BindableFunction")
	local result = nil

	bind.OnInvoke = function(answer)
		result = answer == "Re-Open"
	end

	pcall(function()
		sv.sg:SetCore("SendNotification", {
			Title = "Sena Already Opened",
			Text = "Destroy and Re-Open Sena?",
			Icon = "rbxassetid://96240498384290",
			Duration = 10,
			Button1 = "Re-Open",
			Button2 = "Cancel",
			Callback = bind,
		})
	end)

	task.delay(10, function()
		if result == nil then
			result = false
		end
	end)

	repeat
		task.wait()
	until result ~= nil

	bind:Destroy()
	getgenv().ChloeX_ReopenPrompt = nil

	if not result then
		return
	end

	if getgenv().ChloeX_Instance then
		pcall(function()
			getgenv().ChloeX_Instance:DestroyGui()
		end)
	else
		for _, name in ipairs({
			"Chloeex",
			"ToggleUIButton",
			"OverlayGui",
			"NotifyGui",
			"AnnounceGui",
		}) do
			local old = sv.coregui:FindFirstChild(name)
			if old then
				old:Destroy()
			end
		end

		getgenv().ChloeX_Running = nil
		getgenv().ChloeX_ReopenPrompt = nil
		getgenv().ChloeX_Instance = nil
	end
end

getgenv().ChloeX_Running = true

local allConnections = {}
local resizeDebounceTable = {}
local heartbeatCallbacks = {}
local heartbeatConnection = nil

local function trackConnection(conn, name)
	if not conn then
		return nil
	end
	table.insert(allConnections, { conn = conn, name = name or "unnamed" })
	return conn
end

local function disconnectAll()
	for _, entry in ipairs(allConnections) do
		if entry.conn then
			pcall(function()
				entry.conn:Disconnect()
			end)
		end
	end
	allConnections = {}
end

local function registerHeartbeat(name, callback)
	if not name or not callback then
		return
	end
	heartbeatCallbacks[name] = callback
	if not heartbeatConnection then
		heartbeatConnection = game:GetService("RunService").Heartbeat:Connect(function(dt)
			for _, cb in pairs(heartbeatCallbacks) do
				if cb then
					pcall(function()
						cb(dt)
					end)
				end
			end
		end)
	end
end

local function unregisterHeartbeat(name)
	heartbeatCallbacks[name] = nil
	if next(heartbeatCallbacks) == nil and heartbeatConnection then
		heartbeatConnection:Disconnect()
		heartbeatConnection = nil
	end
end

local function debounceResize(key, callback, delay)
	delay = delay or 0.1
	if resizeDebounceTable[key] then
		task.cancel(resizeDebounceTable[key])
	end
	resizeDebounceTable[key] = task.delay(delay, function()
		pcall(function()
			callback()
		end)
		resizeDebounceTable[key] = nil
	end)
end

local config = { gamefolder = nil, autoloadfile = nil, data = {}, elements = {}, version = nil, current = nil, loaded = false }

local metakeys = {
	["Input_Config Name"] = true,
	["Input_External Config"] = true,
}

local function packconfig(data)
	local out = {}
	for key, value in pairs(data or {}) do
		local keep = not metakeys[key]
		if value == false or value == nil then
			keep = false
		elseif type(value) == "string" and value:gsub("%s+", "") == "" then
			keep = false
		elseif type(value) == "table" and next(value) == nil then
			keep = false
		end
		if keep then
			out[key] = value
		end
	end
	return out
end

local function missingdefault(key, element)
	if key:match("^Toggle_") then
		return false
	elseif key:match("^Input_") then
		return ""
	elseif key:match("^Dropdown_") then
		if type(element.Value) == "table" then
			return {}
		end
		return nil
	end
	return nil
end
local instance = {}
local classes = {
	"ScreenGui",
	"BillboardGui",
	"SurfaceGui",
	"ViewportFrame",
	"CanvasGroup",
	"Frame",
	"ScrollingFrame",
	"VideoFrame",
	"TextLabel",
	"TextButton",
	"TextBox",
	"ImageLabel",
	"ImageButton",
	"UIListLayout",
	"UIGridLayout",
	"UITableLayout",
	"UIPageLayout",
	"UIFlexItem",
	"UIAspectRatioConstraint",
	"UISizeConstraint",
	"UITextSizeConstraint",
	"UIPadding",
	"UICorner",
	"UIStroke",
	"UIGradient",
	"Folder",
	"Configuration",
	"BoolValue",
	"IntValue",
	"NumberValue",
	"StringValue",
	"Color3Value",
	"Vector3Value",
	"CFrameValue",
	"ObjectValue",
	"UIScale",
	"UITextSizeConstraint",
	"LocalizationTable",
}
local draggable = {
	dragging = false,
	resizing = false,
	draginput = nil,
	resizeinput = nil,
	dragstart = nil,
	resizestart = nil,
	startpos = nil,
	startsize = nil,
	minx = 420,
	miny = 260,
	defx = 640,
	defy = 400,
}

local sliderDrag = { active = nil, lastUpdateTime = 0 }
local sliderUpdateThrottle = 0.005

trackConnection(
	sv.uis.InputChanged:Connect(function(input)
		if
			sliderDrag.active
			and (
				input.UserInputType == Enum.UserInputType.MouseMovement
				or input.UserInputType == Enum.UserInputType.Touch
			)
		then
			local now = tick()
			if (now - sliderDrag.lastUpdateTime) > sliderUpdateThrottle then
				sliderDrag.active.setfromx(input.Position.X)
				sliderDrag.lastUpdateTime = now
			end
		end
	end),
	"global.sliderDrag.InputChanged"
)

trackConnection(
	sv.uis.InputEnded:Connect(function(input)
		if
			sliderDrag.active
			and (
				input.UserInputType == Enum.UserInputType.MouseButton1
				or input.UserInputType == Enum.UserInputType.Touch
			)
		then
			sliderDrag.active.hidebubble()
			sliderDrag.active = nil
		end
	end),
	"global.sliderDrag.InputEnded"
)

for _, class in ipairs(classes) do
	instance[class:lower()] = function(parent)
		local obj = Instance.new(class)
		obj.Parent = parent
		return obj
	end
end

local sliceimage = "rbxassetid://3570695787"
local rowalpha = 0

-- Rounded row background. Normally a sliced ImageLabel child named "Bg", but
-- that child draws OVER its parent (ZIndexBehavior Sibling), which hid every
-- TextButton's own text, and inside a UIListLayout it became the first list
-- item and pushed the real content out of view. Those parents (TextButtons,
-- and frames that pass native = true) get their own BackgroundColor3 + a
-- UICorner instead; the returned proxy keeps .ImageColor3 / .ImageTransparency
-- working for hoverbg and friends.
local function roundbg(parent, radius, color, native)
	if native or parent:IsA("TextButton") then
		parent.BackgroundColor3 = color
		parent.BackgroundTransparency = rowalpha
		parent.BorderSizePixel = 0
		local corner = parent:FindFirstChildOfClass("UICorner") or instance.uicorner(parent)
		corner.CornerRadius = UDim.new(0, radius)
		return setmetatable({}, {
			__index = function(_, key)
				if key == "ImageColor3" then
					return parent.BackgroundColor3
				elseif key == "ImageTransparency" then
					return parent.BackgroundTransparency
				end
				return nil
			end,
			__newindex = function(_, key, value)
				if key == "ImageColor3" then
					parent.BackgroundColor3 = value
				elseif key == "ImageTransparency" then
					parent.BackgroundTransparency = value
				end
			end,
		})
	end
	parent.BackgroundTransparency = 1
	local bg = instance.imagelabel(parent)
	bg.Name = "Bg"
	bg.BackgroundTransparency = 1
	bg.BorderSizePixel = 0
	bg.ImageTransparency = rowalpha
	bg.Image = sliceimage
	bg.ScaleType = Enum.ScaleType.Slice
	bg.SliceCenter = Rect.new(100, 100, 100, 100)
	bg.SliceScale = radius / 100
	bg.ImageColor3 = color
	bg.Size = UDim2.new(1, 0, 1, 0)
	bg.ZIndex = 0
	return bg
end

local function hoverbg(button, bg, normal, hover)
	button.MouseEnter:Connect(function()
		bg.ImageColor3 = hover
	end)
	button.MouseLeave:Connect(function()
		bg.ImageColor3 = normal
	end)
	button.MouseButton1Down:Connect(function()
		bg.ImageColor3 = normal
	end)
	button.MouseButton1Up:Connect(function()
		bg.ImageColor3 = hover
	end)
end

-- Short press dip on buttons (was called everywhere but never defined).
local function pesseffect(button)
	local scale = button:FindFirstChild("PressScale")
	if not scale then
		scale = Instance.new("UIScale")
		scale.Name = "PressScale"
		scale.Parent = button
	end
	sv.ts:Create(scale, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Scale = 0.96 }):Play()
	task.delay(0.08, function()
		if scale.Parent then
			sv.ts:Create(scale, TweenInfo.new(0.16, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 }):Play()
		end
	end)
end

local hasfs = type(isfolder) == "function" and type(makefolder) == "function"
if hasfs and not isfolder("Sena") then
	pcall(makefolder, "Sena")
end

function config:getlist()
	local configs = {}

	if isfolder and listfiles and self.gamefolder and isfolder(self.gamefolder) then
		for _, filepath in pairs(listfiles(self.gamefolder)) do
			local filename = filepath:match("([^/\\]+)%.json$")
			if filename then
				table.insert(configs, filename)
			end
		end
	end

	return configs
end

function config:getautoload()
	if isfile and self.autoloadfile and isfile(self.autoloadfile) then
		local success, content = pcall(readfile, self.autoloadfile)

		if success and content and content ~= "" then
			return content:match("^%s*(.-)%s*$")
		end
	end

	return nil
end

function config:setautoload(name)
	if not name or name == "" then
		return false
	end

	if writefile and self.autoloadfile then
		writefile(self.autoloadfile, tostring(name))
		print("[SENA] Autoload config set to: " .. tostring(name))
		return true
	end

	return false
end

function config:clearautoload()
	if delfile and self.autoloadfile and isfile(self.autoloadfile) then
		delfile(self.autoloadfile)
		print("[SENA] Autoload config cleared")
		return true
	end

	return false
end

function config:save(name)
	if not name or name == "" then
		warn("[SENA] Config name cannot be empty")
		return false
	end

	if not writefile or not self.gamefolder then
		return false
	end

	self.data._version = self.version

	local filepath = self.gamefolder .. "/" .. name .. ".json"
	writefile(filepath, sv.http:JSONEncode(packconfig(self.data)))

	self.current = name
	print("[SENA] Config saved as: " .. name)

	return true
end

function config:load(name)
	if not name or name == "" then
		warn("[SENA] Config name cannot be empty")
		return false
	end

	if not self.version then
		return false
	end

	local filepath = self.gamefolder .. "/" .. name .. ".json"

	if not isfile or not isfile(filepath) then
		warn("[SENA] Config file not found: " .. name)
		return false
	end

	local success, result = pcall(function()
		return sv.http:JSONDecode(readfile(filepath))
	end)

	if not success or type(result) ~= "table" then
		warn("[SENA] Failed to decode config")
		return false
	end

	if result._version ~= self.version then
		warn("[SENA] Config version mismatch")
		return false
	end

	self.data = result
	self.current = name
	self.loaded = true
	self:loadelements()

	print("[SENA] Config loaded: " .. name)
	return true
end

function config:delete(name)
	if not name or name == "" then
		warn("[SENA] Config name cannot be empty")
		return false
	end

	local filepath = self.gamefolder .. "/" .. name .. ".json"

	if not delfile or not isfile or not isfile(filepath) then
		warn("[SENA] Config file not found: " .. name)
		return false
	end

	delfile(filepath)
	print("[SENA] Config deleted: " .. name)

	if self:getautoload() == name then
		self:clearautoload()
	end

	if self.current == name then
		self.current = nil
	end

	return true
end

function config:loadelements()
	for key, element in pairs(self.elements) do
		if element.Set and not metakeys[key] then
			local value = self.data[key]
			local apply = value ~= nil
			if value == nil then
				value = missingdefault(key, element)
				apply = value ~= nil or key:match("^Dropdown_") ~= nil
			end
			if apply then
				local ok, err = pcall(function()
					if element.LoadValue then
						element:LoadValue(value)
					else
						element:Set(value, true)
					end
				end)
				if not ok then
					warn("[SENA] Config load failed for " .. tostring(key) .. ":", err)
				end
			end
		end
	end
end

function config:reset()
	self.data = {
		_version = self.version,
	}
	self.loaded = false

	for key, element in pairs(self.elements) do
		if element.Set then
			pcall(function()
				if element.ResetValue then
					-- back to the hub's own Default for this element
					element:ResetValue()
				elseif key:match("^Toggle_") then
					element:Set(false)
				elseif key:match("^Input_") then
					element:Set("")
				elseif key:match("^Dropdown_") then
					if type(element.Value) == "table" then
						element:Set({})
					else
						element:Set(nil)
					end
				end
			end)
		end
	end

	print("[SENA] Elements reset to defaults")
end

function config:loadexternal(json)
	if not json or json == "" then
		warn("[SENA] External config JSON kosong")
		return false
	end

	local success, data = pcall(function()
		return sv.http:JSONDecode(json)
	end)

	if not success or type(data) ~= "table" then
		warn("[SENA] External config JSON invalid")
		return false
	end

	if data._version and self.version and data._version ~= self.version then
		warn("[SENA] External config version mismatch")
		return false
	end

	self.data = data
	self.loaded = true
	self:loadelements()

	print("[SENA] External config loaded from JSON input")
	return true
end

function isMobileDevice()
	return sv.uis.TouchEnabled and not sv.uis.KeyboardEnabled and not sv.uis.MouseEnabled
end

local isMobile = isMobileDevice()

function safesize(width, height)
	local viewport = workspace.CurrentCamera.ViewportSize

	local x = width / viewport.X
	local y = height / viewport.Y

	if isMobile then
		x = math.min(x, 0.5)
		y = math.min(y, 0.3)
	end

	return UDim2.new(x, 0, y, 0)
end

function makedraggable(topbar, object)
	if isMobile then
		draggable.defx, draggable.defy = 470, 270
	end

	object.Size = UDim2.new(0, draggable.defx, 0, draggable.defy)

	local resize = instance.frame(object)
	resize.Name = "resize"
	resize.AnchorPoint = Vector2.new(1, 1)
	resize.BackgroundTransparency = 1
	resize.Size = UDim2.new(0, 40, 0, 40)
	resize.Position = UDim2.new(1, 20, 1, 20)
	resize.Active = true
	local dragConnection = nil
	local resizeConnection = nil

	trackConnection(
		topbar.InputBegan:Connect(function(input)
			if
				input.UserInputType ~= Enum.UserInputType.MouseButton1
				and input.UserInputType ~= Enum.UserInputType.Touch
			then
				return
			end

			draggable.dragging = true
			draggable.dragstart = input.Position
			draggable.startpos = object.Position

			if dragConnection then
				dragConnection:Disconnect()
			end
			dragConnection = input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					draggable.dragging = false
					dragConnection:Disconnect()
					dragConnection = nil
				end
			end)
		end),
		"makedraggable.drag.InputBegan"
	)

	trackConnection(
		topbar.InputChanged:Connect(function(input)
			if
				input.UserInputType == Enum.UserInputType.MouseMovement
				or input.UserInputType == Enum.UserInputType.Touch
			then
				draggable.draginput = input
			end
		end),
		"makedraggable.drag.InputChanged"
	)

	trackConnection(
		resize.InputBegan:Connect(function(input)
			if
				input.UserInputType ~= Enum.UserInputType.MouseButton1
				and input.UserInputType ~= Enum.UserInputType.Touch
			then
				return
			end

			draggable.resizing = true
			draggable.resizestart = input.Position
			draggable.startsize = object.Size

			if resizeConnection then
				resizeConnection:Disconnect()
			end
			resizeConnection = input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					draggable.resizing = false
					resizeConnection:Disconnect()
					resizeConnection = nil
				end
			end)
		end),
		"makedraggable.resize.InputBegan"
	)

	trackConnection(
		resize.InputChanged:Connect(function(input)
			if
				input.UserInputType == Enum.UserInputType.MouseMovement
				or input.UserInputType == Enum.UserInputType.Touch
			then
				draggable.resizeinput = input
			end
		end),
		"makedraggable.resize.InputChanged"
	)

	trackConnection(
		sv.uis.InputChanged:Connect(function(input)
			if draggable.dragging and input == draggable.draginput then
				draggable.pendingdrag = input.Position
			end
			if draggable.resizing and input == draggable.resizeinput then
				draggable.pendingresize = input.Position
			end
		end),
		"makedraggable.global.InputChanged"
	)

	trackConnection(
		game:GetService("RunService").RenderStepped:Connect(function()
			local drag = draggable.pendingdrag
			if drag then
				draggable.pendingdrag = nil
				local delta = drag - draggable.dragstart
				object.Position = UDim2.new(
					draggable.startpos.X.Scale,
					draggable.startpos.X.Offset + delta.X,
					draggable.startpos.Y.Scale,
					draggable.startpos.Y.Offset + delta.Y
				)
			end

			local resize = draggable.pendingresize
			if resize then
				draggable.pendingresize = nil
				local delta = resize - draggable.resizestart
				local width = math.max(draggable.startsize.X.Offset + delta.X, draggable.minx)
				local height = math.max(draggable.startsize.Y.Offset + delta.Y, draggable.miny)
				object.Size = UDim2.new(0, width, 0, height)
			end
		end),
		"makedraggable.render"
	)
end

local Chloex = {}

local function notifyholder(top)
	local gui = sv.coregui:FindFirstChild("NotifyGui")
	if not gui then
		gui = instance.screengui(sv.coregui)
		gui.Name = "NotifyGui"
		gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		gui.ResetOnSpawn = false
		gui.DisplayOrder = 9999
	end

	local name = top and "AnnounceLayout" or "NotifyLayout"
	local holder = gui:FindFirstChild(name)
	if not holder then
		holder = instance.frame(gui)
		holder.Name = name
		holder.AnchorPoint = top and Vector2.new(0.5, 0) or Vector2.new(1, 1)
		holder.Position = top and UDim2.new(0.5, 0, 0, 30) or UDim2.new(1, -30, 1, -30)
		holder.Size = UDim2.new(0, top and 400 or 320, 1, 0)
		holder.BackgroundTransparency = 1
		holder.BorderSizePixel = 0

		holder.ChildRemoved:Connect(function()
			local offset = 0
			for _, v in ipairs(holder:GetChildren()) do
				local target = top and UDim2.new(0, 0, 0, offset) or UDim2.new(0, 0, 1, -offset)
				sv.ts
					:Create(v, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), { Position = target })
					:Play()
				offset = offset + v.Size.Y.Offset + 12
			end
		end)
	end

	return holder
end

local function stackoffset(holder, top)
	local offset = 0
	for _, v in ipairs(holder:GetChildren()) do
		if top then
			offset = v.Position.Y.Offset + v.Size.Y.Offset + 12
		else
			offset = -v.Position.Y.Offset + v.Size.Y.Offset + 12
		end
	end
	return offset
end

local function buildnotify(cfg, top)
	elevate()
	local holder = notifyholder(top)
	local offset = stackoffset(holder, top)
	local width = holder.Size.X.Offset
	local textsize = tonumber(cfg.TextSize) or 13
	local headersize = tonumber(cfg.HeaderSize) or 14

	local bodyheight = math.max(textsize, textheight(cfg.Content, textsize, Enum.Font.GothamBold, width - 48, textsize * 8))
	local height = math.max(65, bodyheight + 40)

	local notifyframe = instance.frame(holder)
	notifyframe.Name = "NotifyFrame"
	notifyframe.BackgroundTransparency = 1
	notifyframe.BorderSizePixel = 0
	notifyframe.Size = UDim2.new(1, 0, 0, height)
	notifyframe.AnchorPoint = top and Vector2.new(0, 0) or Vector2.new(0, 1)
	notifyframe.Position = top and UDim2.new(0, 0, 0, offset) or UDim2.new(0, 0, 1, -offset)

	local notifyframereal = instance.frame(notifyframe)
	notifyframereal.Name = "NotifyFrameReal"
	notifyframereal.BackgroundColor3 = theme.Card
	notifyframereal.BorderSizePixel = 0
	notifyframereal.Position = UDim2.new(0, 400, 0, 0)
	notifyframereal.Size = UDim2.new(1, 0, 1, 0)
	instance.uicorner(notifyframereal).CornerRadius = UDim.new(0, 8)

	local notifystroke = instance.uistroke(notifyframereal)
	notifystroke.Color = theme.Stroke
	notifystroke.Thickness = 1

	local topbar = instance.frame(notifyframereal)
	topbar.Name = "Top"
	topbar.Size = UDim2.new(1, 0, 0, 36)
	topbar.BackgroundTransparency = 1
	topbar.BorderSizePixel = 0

	local icon = instance.imagelabel(topbar)
	icon.BackgroundTransparency = 1
	icon.Size = UDim2.new(0, 50, 0, 50)
	icon.Position = UDim2.new(0, -12, 0.9, 0)
	icon.AnchorPoint = Vector2.new(0, 0.5)
	icon.Image = cfg.Icon or "rbxassetid://6859372539"

	local titlewidth = 0
	pcall(function()
		titlewidth = sv.textservice:GetTextSize(cfg.Title, headersize, Enum.Font.GothamBold, Vector2.new(1000, 100)).X
	end)
	titlewidth = math.ceil(titlewidth)

	local title = instance.textlabel(topbar)
	title.Font = Enum.Font.GothamBold
	title.Text = cfg.Title
	title.TextSize = headersize
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.BackgroundTransparency = 1
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.Size = UDim2.new(0, titlewidth + 2, 1, 0)
	title.Position = UDim2.new(0, 38, 0, 0)

	local descx = 38 + titlewidth + 8
	local desc = instance.textlabel(topbar)
	desc.Font = Enum.Font.GothamBold
	desc.Text = cfg.Description
	desc.TextSize = headersize
	desc.TextXAlignment = Enum.TextXAlignment.Left
	desc.TextTruncate = Enum.TextTruncate.AtEnd
	desc.BackgroundTransparency = 1
	desc.TextColor3 = cfg.Color
	desc.Size = UDim2.new(1, -(descx + 34), 1, 0)
	desc.Position = UDim2.new(0, descx, 0, 0)

	local close = instance.textbutton(topbar)
	close.Text = ""
	close.Size = UDim2.new(0, 25, 0, 25)
	close.AnchorPoint = Vector2.new(1, 0.5)
	close.Position = UDim2.new(1, -5, 0.5, 0)
	close.BackgroundTransparency = 1
	close.BorderSizePixel = 0

	local closeicon = instance.imagelabel(close)
	closeicon.Image = "rbxassetid://9886659671"
	closeicon.BackgroundTransparency = 1
	closeicon.Size = UDim2.new(1, -8, 1, -8)
	closeicon.Position = UDim2.new(0.5, 0, 0.5, 0)
	closeicon.AnchorPoint = Vector2.new(0.5, 0.5)

	local content = instance.textlabel(notifyframereal)
	content.Font = Enum.Font.GothamBold
	content.Text = cfg.Content
	content.TextWrapped = true
	content.TextXAlignment = Enum.TextXAlignment.Left
	content.TextYAlignment = Enum.TextYAlignment.Top
	content.TextSize = textsize
	content.BackgroundTransparency = 1
	content.TextColor3 = theme.SubText
	content.Position = UDim2.new(0, 38, 0, 27)
	content.Size = UDim2.new(1, -48, 0, bodyheight)

	local handle = {}
	local closed = false

	function handle:Close()
		if closed then
			return
		end
		closed = true
		elevate()
		sv.ts
			:Create(
				notifyframereal,
				TweenInfo.new(cfg.Time, Enum.EasingStyle.Back, Enum.EasingDirection.InOut),
				{ Position = UDim2.new(0, 400, 0, 0) }
			)
			:Play()
		task.delay(cfg.Time / 1.2, function()
			pcall(function()
				notifyframe:Destroy()
			end)
		end)
	end

	function handle:SetContent(text)
		content.Text = tostring(text or "")
	end

	close.Activated:Connect(function()
		handle:Close()
	end)

	sv.ts
		:Create(
			notifyframereal,
			TweenInfo.new(cfg.Time, Enum.EasingStyle.Back, Enum.EasingDirection.InOut),
			{ Position = UDim2.new(0, 0, 0, 0) }
		)
		:Play()

	return handle
end

function Chloex:MakeNotify(notifyconfig)
	notifyconfig = notifyconfig or {}
	notifyconfig.Title = tostring(notifyconfig.Title or "Sena")
	notifyconfig.Description = tostring(notifyconfig.Description or "Notification")
	notifyconfig.Content = tostring(notifyconfig.Content or "Content")
	notifyconfig.Color = notifyconfig.Color or theme.Accent
	notifyconfig.Time = tonumber(notifyconfig.Time) or 0.5
	notifyconfig.Delay = tonumber(notifyconfig.Delay) or 5

	local handle = buildnotify(notifyconfig, false)
	task.delay(notifyconfig.Delay, function()
		handle:Close()
	end)
	return handle
end

function chloex(msg, delay, color, title, desc)
	return Chloex:MakeNotify({
		Title = title or "Sena",
		Description = desc or "Notification",
		Content = msg or "Content",
		Color = color or theme.Accent,
		Delay = delay or 4,
	})
end

function Chloex:Notify(notifyconfig)
	notifyconfig = notifyconfig or {}
	return Chloex:MakeNotify({
		Title = notifyconfig.Title or notifyconfig[1] or "Sena",
		Description = notifyconfig.Description or notifyconfig.Desc or "Notification",
		Content = notifyconfig.Content or notifyconfig.Text or notifyconfig[2] or "",
		Color = notifyconfig.Color or theme.Accent,
		Delay = tonumber(notifyconfig.Duration or notifyconfig.Delay or notifyconfig.Time or notifyconfig[3]) or 4,
	})
end

local AnnounceGui, AnnounceHolder
local announcesound = "rbxassetid://84088708071202"
local ANNOUNCE_WIDTH = 420

local function ensureannouncegui()
	if AnnounceGui and AnnounceGui.Parent then
		return AnnounceGui, AnnounceHolder
	end

	local parent = sv.coregui
	pcall(function()
		local ok, hidden = pcall(function()
			return gethui()
		end)
		if ok and hidden then
			parent = hidden
		end
	end)

	pcall(function()
		for _, name in ipairs({ "AnnounceGui", "SenaAnnounce" }) do
			local old = parent:FindFirstChild(name) or sv.coregui:FindFirstChild(name)
			if old then
				pcall(function()
					old:Destroy()
				end)
			end
		end
	end)

	AnnounceGui = instance.screengui(parent)
	AnnounceGui.Name = "AnnounceGui"
	AnnounceGui.AutoLocalize = false
	AnnounceGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	AnnounceGui.ResetOnSpawn = false
	AnnounceGui.DisplayOrder = 10000

	pcall(function()
		if syn and syn.protect_gui then
			syn.protect_gui(AnnounceGui)
		elseif protect_gui then
			protect_gui(AnnounceGui)
		end
	end)

	AnnounceHolder = instance.frame(AnnounceGui)
	AnnounceHolder.Name = "Holder"
	AnnounceHolder.AnchorPoint = Vector2.new(0.5, 0)
	AnnounceHolder.Position = UDim2.new(0.5, 0, 0, 24)
	AnnounceHolder.Size = UDim2.new(0, ANNOUNCE_WIDTH, 1, -48)
	AnnounceHolder.BackgroundTransparency = 1
	AnnounceHolder.BorderSizePixel = 0

	local list = instance.uilistlayout(AnnounceHolder)
	list.Padding = UDim.new(0, 8)
	list.HorizontalAlignment = Enum.HorizontalAlignment.Center
	list.VerticalAlignment = Enum.VerticalAlignment.Top
	list.SortOrder = Enum.SortOrder.LayoutOrder

	return AnnounceGui, AnnounceHolder
end

local function playannouncesound(id)
	pcall(function()
		elevate()
		local sound = Instance.new("Sound")
		sound.Name = "AnnounceSound"
		sound.SoundId = id or announcesound
		sound.Volume = 0.7
		sound.Parent = AnnounceGui or sv.coregui

		local ss = game:GetService("SoundService")
		local played = false
		if ss then
			pcall(function()
				ss:PlayLocalSound(sound)
				played = true
			end)
		end
		if not played then
			sound:Play()
		end

		task.delay(6, function()
			pcall(function()
				sound:Destroy()
			end)
		end)
	end)
end

local function resolveannouncesound(value)
	if value == false then
		return nil
	end
	local text = tostring(value == nil and "default" or value):lower()
	if text == "off" or text == "none" or text == "false" or text == "0" then
		return nil
	end
	if text == "default" or text == "true" or text == "" then
		return announcesound
	end
	local id = tostring(value):gsub("^%s+", ""):gsub("%s+$", "")
	if id:match("^%d+$") then
		return "rbxassetid://" .. id
	end
	return id
end

local function countannouncelines(text, width, font, textSize, maxLines)
	text = tostring(text or "")
	if text == "" then
		return 0
	end
	maxLines = maxLines or 6
	width = math.floor(tonumber(width) or 0)

	local lines
	if width >= 20 then
		local ok, bounds = pcall(function()
			return sv.textservice:GetTextSize(text, textSize, font, Vector2.new(width, 100000))
		end)
		if ok and bounds and bounds.Y > 0 then
			lines = math.ceil(bounds.Y / (textSize + 2))
		end
	end

	if not lines then
		local perLine = math.max(10, math.floor((width > 0 and width or 200) / (textSize * 0.52)))
		lines = 0
		for segment in (text .. "\n"):gmatch("(.-)\n") do
			lines = lines + math.max(1, math.ceil(#segment / perLine))
		end
	end

	return math.clamp(lines, 1, maxLines)
end

function Chloex:Announce(announceconfig)
	announceconfig = announceconfig or {}
	local content = tostring(
		announceconfig.Content or announceconfig.Text or announceconfig.Description or announceconfig[2] or ""
	)
	local duration = tonumber(announceconfig.Duration or announceconfig.Time or announceconfig[3]) or 15
	local soundid = resolveannouncesound(announceconfig.Sound)
	local iconName = announceconfig.Icon or "rbxassetid://114954261913892"
	if iconName == "megaphone" then
		iconName = "rbxassetid://114954261913892"
	end

	local title
	if announceconfig.Title or announceconfig[1] then
		title = tostring(announceconfig.Title or announceconfig[1])
		if announceconfig.Name and tostring(announceconfig.Name) ~= "" and not title:lower():find(tostring(announceconfig.Name):lower(), 1, true) then
			title = tostring(announceconfig.Name) .. " " .. title
		end
	else
		title = tostring(announceconfig.Name or "Sena") .. " Announcements"
	end

	ensureannouncegui()

	local PAD, BADGE, GAP = 14, 32, 12
	local textLeft = PAD + BADGE + GAP
	local textWidth = ANNOUNCE_WIDTH - textLeft - PAD - 28
	local lines = content ~= "" and countannouncelines(content, textWidth, Enum.Font.GothamMedium, 13, 8) or 0
	local bodyH = lines > 0 and (lines * 17) or 0
	-- who sent it (set by the server): "From Sena [OWNER]" / "From Reyzanzu [STAFF]"
	local sender = tostring(announceconfig.From or "")
	local senderRole = tostring(announceconfig.Role or "")
	local fromH = sender ~= "" and 16 or 0
	local contentH = math.max(BADGE, 18 + fromH + (bodyH > 0 and (4 + bodyH) or 0))
	local height = PAD + contentH + 14 + 4 + 8

	local slot = instance.frame(AnnounceHolder)
	slot.Name = "Slot"
	slot.BackgroundTransparency = 1
	slot.BorderSizePixel = 0
	slot.Size = UDim2.new(1, 0, 0, height)
	slot.ClipsDescendants = false

	local card = instance.frame(slot)
	card.Name = "Announcement"
	card.BackgroundColor3 = theme.Card
	card.BorderSizePixel = 0
	card.AnchorPoint = Vector2.new(0.5, 0)
	card.Position = UDim2.new(0.5, 0, 0, -height - 40)
	card.Size = UDim2.new(1, 0, 1, 0)
	card.BackgroundTransparency = 1
	instance.uicorner(card).CornerRadius = UDim.new(0, 10)

	local cardStroke = instance.uistroke(card)
	cardStroke.Color = theme.Stroke
	cardStroke.Thickness = 1
	cardStroke.Transparency = 1

	local scale = instance.uiscale(card)
	scale.Scale = 0.96

	local badge = instance.frame(card)
	badge.Name = "Badge"
	badge.BackgroundColor3 = theme.Element
	badge.BorderSizePixel = 0
	badge.Position = UDim2.new(0, PAD, 0, PAD)
	badge.Size = UDim2.new(0, BADGE, 0, BADGE)
	badge.BackgroundTransparency = 0
	instance.uicorner(badge).CornerRadius = UDim.new(0, 8)

	local badgeStroke = instance.uistroke(badge)
	badgeStroke.Color = theme.Stroke
	badgeStroke.Thickness = 1
	badgeStroke.Transparency = 1

	local badgeIcon = instance.imagelabel(badge)
	badgeIcon.BackgroundTransparency = 1
	badgeIcon.AnchorPoint = Vector2.new(0.5, 0.5)
	badgeIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
	badgeIcon.Size = UDim2.new(0, 20, 0, 20)
	badgeIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
	badgeIcon.ImageTransparency = 1
	applyicon(badgeIcon, iconName, 48)
	if badgeIcon.Image == "" then
		applyicon(badgeIcon, "zap", 48)
	end

	local badgeFallback = instance.textlabel(badge)
	badgeFallback.BackgroundTransparency = 1
	badgeFallback.Size = UDim2.new(1, 0, 1, 0)
	badgeFallback.Font = Enum.Font.GothamBold
	badgeFallback.Text = "!"
	badgeFallback.TextColor3 = theme.Text
	badgeFallback.TextSize = 16
	badgeFallback.TextTransparency = 1
	badgeFallback.Visible = (badgeIcon.Image == "")

	local titleLabel = instance.textlabel(card)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Position = UDim2.new(0, textLeft, 0, PAD)
	titleLabel.Size = UDim2.new(1, -textLeft - PAD - 26, 0, 18)
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.Text = title
	titleLabel.TextColor3 = theme.Text
	titleLabel.TextSize = 14
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.TextTruncate = Enum.TextTruncate.AtEnd
	titleLabel.TextTransparency = 1

	local fromLabel = nil
	if sender ~= "" then
		local badgeText = ""
		if senderRole == "owner" then
			badgeText = '  <font color="#EF4444"><b>[OWNER]</b></font>'
		elseif senderRole == "staff" then
			badgeText = '  <font color="#A855F7"><b>[STAFF]</b></font>'
		end
		fromLabel = instance.textlabel(card)
		fromLabel.BackgroundTransparency = 1
		fromLabel.Position = UDim2.new(0, textLeft, 0, PAD + 18 + 1)
		fromLabel.Size = UDim2.new(1, -textLeft - PAD - 26, 0, 14)
		fromLabel.Font = Enum.Font.GothamMedium
		fromLabel.RichText = true
		fromLabel.Text = '<font color="' .. hexcolor(theme.SubText) .. '">From</font>  <b>' .. escaperich(sender) .. "</b>" .. badgeText
		fromLabel.TextColor3 = theme.Text
		fromLabel.TextSize = 12
		fromLabel.TextXAlignment = Enum.TextXAlignment.Left
		fromLabel.TextTruncate = Enum.TextTruncate.AtEnd
		fromLabel.TextTransparency = 1
	end

	local descLabel = nil
	if content ~= "" then
		descLabel = instance.textlabel(card)
		descLabel.BackgroundTransparency = 1
		descLabel.Position = UDim2.new(0, textLeft, 0, PAD + 18 + 4 + fromH)
		descLabel.Size = UDim2.new(1, -textLeft - PAD, 0, bodyH)
		descLabel.Font = Enum.Font.GothamMedium
		descLabel.Text = content
		descLabel.TextColor3 = theme.Text
		descLabel.TextSize = 13
		descLabel.TextXAlignment = Enum.TextXAlignment.Left
		descLabel.TextYAlignment = Enum.TextYAlignment.Top
		descLabel.TextWrapped = true
		descLabel.TextTransparency = 1
	end

	local closeButton = instance.textbutton(card)
	closeButton.Name = "Close"
	closeButton.AnchorPoint = Vector2.new(1, 0)
	closeButton.Position = UDim2.new(1, -10, 0, 10)
	closeButton.Size = UDim2.new(0, 24, 0, 24)
	closeButton.BackgroundColor3 = theme.Element
	closeButton.BackgroundTransparency = 1
	closeButton.BorderSizePixel = 0
	closeButton.Text = ""
	closeButton.AutoButtonColor = false
	closeButton.ZIndex = 3
	instance.uicorner(closeButton).CornerRadius = UDim.new(0, 6)

	local closeIcon = instance.imagelabel(closeButton)
	closeIcon.BackgroundTransparency = 1
	closeIcon.AnchorPoint = Vector2.new(0.5, 0.5)
	closeIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
	closeIcon.Size = UDim2.new(0, 12, 0, 12)
	closeIcon.ImageColor3 = theme.SubText
	closeIcon.ImageTransparency = 1
	closeIcon.ZIndex = 4
	applyicon(closeIcon, "x", 48)

	local closeText = nil
	if closeIcon.Image == "" then
		closeText = instance.textlabel(closeButton)
		closeText.BackgroundTransparency = 1
		closeText.Size = UDim2.new(1, 0, 1, 0)
		closeText.Font = Enum.Font.GothamBold
		closeText.Text = "×"
		closeText.TextColor3 = theme.SubText
		closeText.TextSize = 16
		closeText.TextTransparency = 1
		closeText.ZIndex = 4
	end

	local track = instance.frame(card)
	track.Name = "Track"
	track.BackgroundColor3 = theme.Track
	track.BorderSizePixel = 0
	track.AnchorPoint = Vector2.new(0, 1)
	track.Position = UDim2.new(0, PAD, 1, -10)
	track.Size = UDim2.new(1, -PAD * 2, 0, 3)
	track.BackgroundTransparency = 1
	instance.uicorner(track).CornerRadius = UDim.new(0, 2)

	local bar = instance.frame(track)
	bar.Name = "Bar"
	bar.BackgroundColor3 = announceconfig.Color or theme.Accent
	bar.BorderSizePixel = 0
	bar.Size = UDim2.new(1, 0, 1, 0)
	bar.BackgroundTransparency = 1
	instance.uicorner(bar).CornerRadius = UDim.new(0, 2)

	local ENTER = TweenInfo.new(0.42, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
	local FADE = TweenInfo.new(0.28, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

	sv.ts:Create(card, ENTER, { Position = UDim2.new(0.5, 0, 0, 0) }):Play()
	sv.ts:Create(scale, ENTER, { Scale = 1 }):Play()
	sv.ts:Create(card, FADE, { BackgroundTransparency = 0 }):Play()
	sv.ts:Create(cardStroke, FADE, { Transparency = 0 }):Play()
	sv.ts:Create(badge, FADE, { BackgroundTransparency = 0 }):Play()
	sv.ts:Create(badgeStroke, FADE, { Transparency = 0 }):Play()
	sv.ts:Create(badgeIcon, FADE, { ImageTransparency = 0 }):Play()
	sv.ts:Create(badgeFallback, FADE, { TextTransparency = 0 }):Play()
	sv.ts:Create(titleLabel, FADE, { TextTransparency = 0 }):Play()
	sv.ts:Create(closeIcon, FADE, { ImageTransparency = 0 }):Play()
	if closeText then sv.ts:Create(closeText, FADE, { TextTransparency = 0 }):Play() end
	if descLabel then sv.ts:Create(descLabel, FADE, { TextTransparency = 0.15 }):Play() end
	if fromLabel then sv.ts:Create(fromLabel, FADE, { TextTransparency = 0 }):Play() end
	sv.ts:Create(track, FADE, { BackgroundTransparency = 0.4 }):Play()
	sv.ts:Create(bar, FADE, { BackgroundTransparency = 0 }):Play()
	sv.ts:Create(bar, TweenInfo.new(duration, Enum.EasingStyle.Linear), { Size = UDim2.new(0, 0, 1, 0) }):Play()

	if soundid then
		playannouncesound(soundid)
	end

	local closed = false
	local function close()
		elevate()
		if closed then return end
		closed = true
		local OUT = TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
		sv.ts:Create(card, OUT, { Position = UDim2.new(0.5, 0, 0, -height - 40), BackgroundTransparency = 1 }):Play()
		sv.ts:Create(scale, OUT, { Scale = 0.96 }):Play()
		sv.ts:Create(cardStroke, OUT, { Transparency = 1 }):Play()
		sv.ts:Create(badge, OUT, { BackgroundTransparency = 1 }):Play()
		sv.ts:Create(badgeStroke, OUT, { Transparency = 1 }):Play()
		sv.ts:Create(badgeIcon, OUT, { ImageTransparency = 1 }):Play()
		sv.ts:Create(badgeFallback, OUT, { TextTransparency = 1 }):Play()
		sv.ts:Create(titleLabel, OUT, { TextTransparency = 1 }):Play()
		sv.ts:Create(closeIcon, OUT, { ImageTransparency = 1 }):Play()
		if closeText then sv.ts:Create(closeText, OUT, { TextTransparency = 1 }):Play() end
		if descLabel then sv.ts:Create(descLabel, OUT, { TextTransparency = 1 }):Play() end
		if fromLabel then sv.ts:Create(fromLabel, OUT, { TextTransparency = 1 }):Play() end
		sv.ts:Create(track, OUT, { BackgroundTransparency = 1 }):Play()
		sv.ts:Create(bar, OUT, { BackgroundTransparency = 1 }):Play()
		task.delay(0.24, function()
			elevate()
			pcall(function() slot:Destroy() end)
		end)
	end

	closeButton.MouseEnter:Connect(function()
		elevate()
		sv.ts:Create(closeButton, TweenInfo.new(0.16), { BackgroundTransparency = 0 }):Play()
		sv.ts:Create(closeIcon, TweenInfo.new(0.16), { ImageColor3 = theme.Text }):Play()
		if closeText then sv.ts:Create(closeText, TweenInfo.new(0.16), { TextColor3 = theme.Text }):Play() end
	end)
	closeButton.MouseLeave:Connect(function()
		elevate()
		sv.ts:Create(closeButton, TweenInfo.new(0.16), { BackgroundTransparency = 1 }):Play()
		sv.ts:Create(closeIcon, TweenInfo.new(0.16), { ImageColor3 = theme.SubText }):Play()
		if closeText then sv.ts:Create(closeText, TweenInfo.new(0.16), { TextColor3 = theme.SubText }):Play() end
	end)
	closeButton.MouseButton1Click:Connect(function()
		close()
	end)

	task.delay(duration, function()
		if not closed then
			close()
		end
	end)

	return { Close = close }
end

function Chloex:Prompt(promptconfig)
	promptconfig = promptconfig or {}
	local title = tostring(promptconfig.Title or "Sena")
	local content = tostring(promptconfig.Content or "")
	local duration = math.max(5, tonumber(promptconfig.Duration) or 60)
	local avatar = promptconfig.Avatar
	local callback = promptconfig.Callback
	local acceptlabel = tostring(promptconfig.Accept or "Accept")
	local declinelabel = tostring(promptconfig.Decline or "Decline")

	local promptfunc = {}
	local answered = false
	local closed = false

	task.spawn(function()
		elevate()
		local notifylayout = notifyholder(false)

		local notifyposheigh = 0
		for _, v in ipairs(notifylayout:GetChildren()) do
			notifyposheigh = -v.Position.Y.Offset + v.Size.Y.Offset + 12
		end

		local notifyframe = instance.frame(notifylayout)
		notifyframe.Name = "NotifyFrame"
		notifyframe.BackgroundTransparency = 1
		notifyframe.BorderSizePixel = 0
		notifyframe.Size = UDim2.new(1, 0, 0, 98)
		notifyframe.AnchorPoint = Vector2.new(0, 1)
		notifyframe.Position = UDim2.new(0, 0, 1, -notifyposheigh)

		local notifyframereal = instance.frame(notifyframe)
		notifyframereal.Name = "NotifyFrameReal"
		notifyframereal.BackgroundColor3 = theme.Card
		notifyframereal.BorderSizePixel = 0
		notifyframereal.Position = UDim2.new(0, 400, 0, 0)
		notifyframereal.Size = UDim2.new(1, 0, 1, 0)
		instance.uicorner(notifyframereal).CornerRadius = UDim.new(0, 8)

		local stroke = instance.uistroke(notifyframereal)
		stroke.Color = theme.Stroke
		stroke.Thickness = 1

		local avatarframe = instance.frame(notifyframereal)
		avatarframe.Name = "Avatar"
		avatarframe.BackgroundColor3 = theme.Element
		avatarframe.BorderSizePixel = 0
		avatarframe.Position = UDim2.new(0, 12, 0, 12)
		avatarframe.Size = UDim2.new(0, 34, 0, 34)
		instance.uicorner(avatarframe).CornerRadius = UDim.new(1, 0)

		if avatar then
			local pic = instance.imagelabel(avatarframe)
			pic.BackgroundTransparency = 1
			pic.Size = UDim2.new(1, 0, 1, 0)
			pic.Image = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(avatar) .. "&w=60&h=60"
			instance.uicorner(pic).CornerRadius = UDim.new(1, 0)
		else
			local mark = instance.textlabel(avatarframe)
			mark.BackgroundTransparency = 1
			mark.Size = UDim2.new(1, 0, 1, 0)
			mark.Font = Enum.Font.GothamBold
			mark.Text = "?"
			mark.TextColor3 = theme.Text
			mark.TextSize = 14
		end

		local titlelabel = instance.textlabel(notifyframereal)
		titlelabel.Font = Enum.Font.GothamBold
		titlelabel.Text = title
		titlelabel.RichText = true
		titlelabel.TextSize = 14
		titlelabel.TextColor3 = theme.Text
		titlelabel.TextXAlignment = Enum.TextXAlignment.Left
		titlelabel.TextTruncate = Enum.TextTruncate.AtEnd
		titlelabel.BackgroundTransparency = 1
		titlelabel.Position = UDim2.new(0, 56, 0, 11)
		titlelabel.Size = UDim2.new(1, -68, 0, 16)

		local contentlabel = instance.textlabel(notifyframereal)
		contentlabel.Font = Enum.Font.GothamBold
		contentlabel.Text = content
		contentlabel.TextSize = 12
		contentlabel.TextColor3 = theme.SubText
		contentlabel.TextWrapped = true
		contentlabel.TextXAlignment = Enum.TextXAlignment.Left
		contentlabel.TextYAlignment = Enum.TextYAlignment.Top
		contentlabel.BackgroundTransparency = 1
		local promptbody = math.max(14, textheight(content, 12, Enum.Font.GothamBold, 320 - 68, 14 * 4))
		contentlabel.Position = UDim2.new(0, 56, 0, 29)
		contentlabel.Size = UDim2.new(1, -68, 0, promptbody)
		notifyframe.Size = UDim2.new(1, 0, 0, 29 + promptbody + 8 + 26 + 10)

		local function makebutton(text, x, w, accent)
			local btn = instance.textbutton(notifyframereal)
			btn.Position = UDim2.new(0, x, 1, -36)
			btn.Size = UDim2.new(0, w, 0, 26)
			btn.BackgroundColor3 = accent and theme.Accent or Color3.fromRGB(255, 255, 255)
			btn.BackgroundTransparency = accent and 0 or 0.92
			btn.BorderSizePixel = 0
			btn.Font = Enum.Font.GothamBold
			btn.Text = text
			btn.TextColor3 = accent and theme.AccentText or theme.Text
			btn.TextSize = 12
			btn.AutoButtonColor = true
			instance.uicorner(btn).CornerRadius = UDim.new(0, 6)
			return btn
		end

		local half = math.floor((320 - 56 - 12 - 6) / 2)
		local acceptbtn = makebutton(acceptlabel, 56, half, true)
		local declinebtn = makebutton(declinelabel, 56 + half + 6, half, false)

		local bar = instance.frame(notifyframereal)
		bar.Name = "Bar"
		bar.BackgroundColor3 = theme.Accent
		bar.BackgroundTransparency = 0.35
		bar.BorderSizePixel = 0
		bar.AnchorPoint = Vector2.new(0, 1)
		bar.Position = UDim2.new(0, 0, 1, 0)
		bar.Size = UDim2.new(1, 0, 0, 2)
		instance.uicorner(bar).CornerRadius = UDim.new(0, 2)

		function promptfunc:Close()
			if closed then
				return
			end
			closed = true
			elevate()
			sv.ts
				:Create(
					notifyframereal,
					TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.InOut),
					{ Position = UDim2.new(0, 400, 0, 0) }
				)
				:Play()
			task.delay(0.42, function()
				pcall(function()
					notifyframe:Destroy()
				end)
			end)
		end

		local function answer(accepted)
			if answered then
				return
			end
			answered = true
			promptfunc:Close()
			if type(callback) == "function" then
				task.spawn(function()
					elevate()
					local ok, err = pcall(callback, accepted)
					if not ok then
						warn("[SENA] Prompt callback error:", err)
					end
				end)
			end
		end

		function promptfunc:Answer(accepted)
			answer(accepted)
		end

		acceptbtn.Activated:Connect(function()
			answer(true)
		end)
		declinebtn.Activated:Connect(function()
			answer(false)
		end)

		sv.ts
			:Create(
				notifyframereal,
				TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.InOut),
				{ Position = UDim2.new(0, 0, 0, 0) }
			)
			:Play()
		sv.ts:Create(bar, TweenInfo.new(duration, Enum.EasingStyle.Linear), { Size = UDim2.new(0, 0, 0, 2) }):Play()

		task.wait(duration)
		if not answered then
			answer(nil)
		end
	end)

	return promptfunc
end

function Chloex:MakeOverlay(overlayconfig)
	overlayconfig = overlayconfig or {}
	overlayconfig.Content = overlayconfig.Content or "Status"
	overlayconfig.Position = typeof(overlayconfig.Position) == "UDim2" and overlayconfig.Position or UDim2.new(0, 20, 0, 20)

	local overlayfunc = {}

	local overlaygui = instance.screengui(sv.coregui)
	overlaygui.Name = "OverlayGui"
	overlaygui.ResetOnSpawn = false
	overlaygui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

	local overlayframe = instance.frame(overlaygui)
	overlayframe.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	overlayframe.BackgroundTransparency = 0.4
	overlayframe.BorderSizePixel = 0
	overlayframe.Position = overlayconfig.Position
	overlayframe.Size = UDim2.new(0, 150, 0, 30)
	overlayframe.AutomaticSize = Enum.AutomaticSize.Y

	local uicorner = instance.uicorner(overlayframe)
	uicorner.CornerRadius = UDim.new(0, 6)

	local contentlabel = instance.textlabel(overlayframe)
	contentlabel.Font = Enum.Font.GothamBold
	contentlabel.Text = overlayconfig.Content
	contentlabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	contentlabel.TextSize = 13
	contentlabel.BackgroundTransparency = 1
	contentlabel.TextWrapped = true
	contentlabel.AutomaticSize = Enum.AutomaticSize.Y
	contentlabel.Size = UDim2.new(1, -10, 0, 0)
	contentlabel.Position = UDim2.new(0, 10, 0, 5)
	contentlabel.TextXAlignment = Enum.TextXAlignment.Left

	local dragging, dragstart, startpos
	overlayframe.InputBegan:Connect(function(input)
		if
			input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch
		then
			dragging = true
			dragstart = input.Position
			startpos = overlayframe.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	trackConnection(
		sv.uis.InputChanged:Connect(function(input)
			if
				dragging
				and (
					input.UserInputType == Enum.UserInputType.MouseMovement
					or input.UserInputType == Enum.UserInputType.Touch
				)
			then
				local delta = input.Position - dragstart
				overlayframe.Position =
					UDim2.new(startpos.X.Scale, startpos.X.Offset + delta.X, startpos.Y.Scale, startpos.Y.Offset + delta.Y)
			end
		end),
		"overlay.drag"
	)

	function overlayfunc:SetContent(text)
		contentlabel.Text = text or ""
	end

	function overlayfunc:SetVisible(bool)
		overlayframe.Visible = bool
	end

	function overlayfunc:Destroy()
		overlaygui:Destroy()
	end

	return overlayfunc
end

Chloex.Unloaded = false
Chloex.DonatorInfo = nil
Chloex.LockRegistry = {}
Chloex.DonatorListeners = {}
Chloex._isDonator = false
Chloex._isTrial = false

-- A donator claim (from the loader or an earlier run in this Roblox session) is
-- only trusted while its key is still inside its paid time. Paused keys have no
-- running clock, so they never expire locally; the backend decides for them.
local EXPIRY_GRACE = 120

local function donatorinfo()
	local info = Chloex.DonatorInfo
	if type(info) ~= "table" then
		local ok, g = pcall(function()
			return getgenv and getgenv().SenaDonatorInfo
		end)
		info = ok and type(g) == "table" and g or nil
	end
	return info
end

local function claimexpired()
	local info = donatorinfo()
	if type(info) ~= "table" or info.paused == true then
		return false
	end
	local exp = tonumber(info.expires)
	return exp ~= nil and exp > 0 and exp + EXPIRY_GRACE <= os.time()
end

local function writetierglobals()
	if getgenv then
		getgenv().SenaIsDonator = Chloex._isDonator or Chloex._isTrial
		getgenv().SenaIsTrial = Chloex._isTrial
	end
	if _G then
		_G.SenaIsDonator = Chloex._isDonator or Chloex._isTrial
		_G.SenaIsTrial = Chloex._isTrial
	end
end

-- Adopt the tier the loader / SenaGuard wrote into the globals. Runs when the
-- lib loads and again when a Window is built; after that only SetDonator (key
-- redeem, backend tier reports, local expiry) changes the tier.
local function adoptclaim()
	if Chloex._isDonator or Chloex._isTrial then
		return
	end
	local okT, valT = pcall(function()
		return (getgenv and getgenv().SenaIsTrial == true) or (_G and _G.SenaIsTrial == true)
	end)
	local ok, val = pcall(function()
		return (getgenv and getgenv().SenaIsDonator == true) or (_G and _G.SenaIsDonator == true)
	end)
	if not ((okT and valT) or (ok and val)) then
		return
	end
	if claimexpired() then
		-- stale claim: the key ran out since it was set. Clear it before any
		-- element is built, so saved donator settings never get applied.
		pcall(function()
			getgenv().SenaDonatorInfo = nil
		end)
		writetierglobals()
		return
	end
	if okT and valT then
		Chloex._isTrial = true
	else
		Chloex._isDonator = true
	end
end

adoptclaim()

-- Lock or unlock every donator element to match the current tier. Each lock
-- controller is idempotent, so calling this on every tier report is cheap.
local function applydonatorlocks()
	local donator = Chloex._isDonator == true
	local trial = Chloex._isTrial == true
	for i = #Chloex.LockRegistry, 1, -1 do
		local lock = Chloex.LockRegistry[i]
		if lock.Dead and lock.Dead() then
			table.remove(Chloex.LockRegistry, i)
		else
			-- Locked2/DonatorOnly elements open only for a donator; a trial key
			-- leaves them locked. Ordinary elements open for donator OR trial.
			local unlocked
			if lock.DonatorOnly then
				unlocked = donator
			else
				unlocked = donator or trial
			end
			if unlocked then
				pcall(lock.Unlock, lock)
			else
				pcall(lock.Lock, lock)
			end
		end
	end
end

function Chloex:SetDonator(state, istrial)
	local before = tostring(Chloex._isDonator) .. tostring(Chloex._isTrial)
	if istrial then
		Chloex._isTrial = true
		Chloex._isDonator = false
	else
		Chloex._isTrial = false
		Chloex._isDonator = (state == true)
	end
	writetierglobals()
	if not (Chloex._isDonator or Chloex._isTrial) then
		Chloex.DonatorInfo = nil
		pcall(function()
			getgenv().SenaDonatorInfo = nil
		end)
	end
	applydonatorlocks()
	if before == tostring(Chloex._isDonator) .. tostring(Chloex._isTrial) then
		return
	end
	for _, fn in ipairs(Chloex.DonatorListeners) do
		task.spawn(function()
			elevate()
			pcall(fn)
		end)
	end
end

-- The lib's own state is the only source of truth; globals are an output
-- (writetierglobals) plus one-time input (adoptclaim).
local function isdonator()
	return Chloex._isDonator == true or Chloex._isTrial == true
end

local function istrial()
	return Chloex._isTrial == true
end

-- Whether the current tier may open an element of the given lock class.
-- Ordinary Locked/Donator elements open for donator OR trial; Locked2/
-- DonatorOnly elements open only for a real donator (trial stays locked).
local function tierallows(donatoronly)
	if donatoronly then
		return Chloex._isDonator == true
	end
	return Chloex._isDonator == true or Chloex._isTrial == true
end

function Chloex:IsDonator()
	return isdonator()
end

function Chloex:IsTrial()
	return istrial()
end

function Chloex:UnlockAllDonatorFeatures()
	Chloex:SetDonator(true)
end

-- Locks every donator element again (their saved values stay in the config
-- and come back on the next unlock). SetDonator(false) does the same.
function Chloex:RelockDonatorFeatures()
	Chloex:SetDonator(false)
end

-- Local expiry check: when the backend has not confirmed the key recently
-- (offline, or an older server that sends no lic_state), the paid time from
-- /key/check decides. The backend's word wins while it is reachable.
task.spawn(function()
	while not Chloex.Unloaded do
		task.wait(15)
		if isdonator() and claimexpired() then
			local b = Chloex:GetBackend()
			local confirmed = b and (os.time() - (b.LastValid or 0)) < 30
			if not confirmed then
				warn("[SENA] Donator key time is up, locking donator features")
				Chloex:SetDonator(false)
				pcall(function()
					Chloex:Notify({ Title = "Sena", Description = "Donator", Content = "Your donator key has expired. Donator features are locked again.", Duration = 6, Color = theme.Bad })
				end)
			end
		end
	end
end)

local backend = nil

local defaultbackend = {
	Api = "http://56.10.112.179:8080",
	Key = "sena_20VvixjHsd1OPPwgHYJAstpM",
}

local function httpgetjson(url)
	local ok, body = pcall(function()
		return game:HttpGet(url, true)
	end)
	if not ok or type(body) ~= "string" or body == "" then
		return nil
	end
	local okjson, data = pcall(function()
		return sv.http:JSONDecode(body)
	end)
	if not okjson or type(data) ~= "table" then
		return nil
	end
	return data
end

local function backendurl(path, params)
	local parts = {}
	for key, value in pairs(params or {}) do
		parts[#parts + 1] = tostring(key) .. "=" .. sv.http:UrlEncode(tostring(value))
	end
	parts[#parts + 1] = "t=" .. tostring(os.time()) .. tostring(math.random(1000, 9999))
	return backend.Api .. path .. "?" .. table.concat(parts, "&")
end

local function localplayer()
	local lp = sv.plrs.LocalPlayer
	if lp then
		return lp
	end
	local t0 = os.clock()
	while not lp and os.clock() - t0 < 5 do
		lp = sv.plrs.LocalPlayer
		if lp then
			break
		end
		task.wait(0.1)
	end
	return lp
end

local function localuserid()
	local lp = sv.plrs.LocalPlayer
	local ok, id = pcall(function()
		return lp and lp.UserId
	end)
	if ok and id and id ~= 0 then
		return tostring(id)
	end
	return tostring((lp and lp.UserId) or 0)
end

local function localusername()
	local lp = sv.plrs.LocalPlayer
	local ok, name = pcall(function()
		return lp and lp.Name
	end)
	return tostring(ok and name or (lp and lp.Name) or "")
end

local function localdisplayname()
	local lp = sv.plrs.LocalPlayer
	local ok, name = pcall(function()
		return lp and lp.DisplayName
	end)
	return tostring(ok and name or "")
end

local function isowner()
	if localusername():lower() == "aevinexyz" or localuserid() == "8478064806" then
		return true
	end
	if getgenv and getgenv().SenaIsOwner == true then
		return true
	end
	if _G and _G.SenaIsOwner == true then
		return true
	end
	return false
end

function Chloex:IsOwner()
	return isowner()
end

local function detectgamename()
	local ok, info = pcall(function()
		return game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId)
	end)
	if ok and type(info) == "table" and type(info.Name) == "string" and info.Name ~= "" then
		return info.Name
	end
	return "PlaceId " .. tostring(game.PlaceId)
end

local keyfiles = {
	"SenaHUB/sena_key.txt",
	"SenaHUB/Sena_AutoSave.json",
	"sena_key.txt",
	"Sena/sena_key.txt",
	"SenaKey.txt",
	"senahub_key.txt",
	"Sena_AutoSave.json",
	"Sena/Sena_AutoSave.json",
}

local function readsavedkey()
	local found = nil
	if not (isfile and readfile) then
		return nil
	end
	for _, f in ipairs(keyfiles) do
		pcall(function()
			if isfile(f) then
				local c = readfile(f)
				if f:find("%.json$") then
					local okj, d = pcall(sv.http.JSONDecode, sv.http, c)
					if okj and type(d) == "table" and d.donatorKey and #tostring(d.donatorKey) > 0 then
						found = tostring(d.donatorKey)
					end
				elseif c and c:gsub("%s+", "") ~= "" then
					found = c
				end
			end
		end)
		if found and found:gsub("%s+", "") ~= "" then
			return found
		end
	end
	return nil
end

local function savekey(key)
	pcall(function()
		if writefile then
			writefile("sena_key.txt", key)
			if makefolder and isfolder then
				if not isfolder("SenaHUB") then
					pcall(makefolder, "SenaHUB")
				end
				pcall(writefile, "SenaHUB/sena_key.txt", key)
			end
		end
	end)
end

local function publishkey(key, info)
	if getgenv then
		getgenv().SenaKey = key
		getgenv().SenaDonatorKey = key
		getgenv().SenaDonatorInfo = info
	end
	if _G then
		_G.SenaKey = key
		_G.SenaDonatorKey = key
		_G.SenaDonatorInfo = info
	end
	writetierglobals()
end

function Chloex:GetSavedKey()
	local rawkey = (getgenv and (getgenv().SenaKey or getgenv().SenaDonatorKey or (getgenv().SenaDonator and getgenv().SenaDonator.Key)))
		or (_G and (_G.SenaKey or _G.SenaDonatorKey))
	if (not rawkey or rawkey == "") then
		rawkey = readsavedkey()
	end
	if type(rawkey) ~= "string" or rawkey:gsub("%s+", "") == "" then
		return nil
	end
	return rawkey:gsub("%s+", ""):upper()
end

function Chloex:CheckDonatorKey(customkey)
	local activekey = Chloex:GetSavedKey()
	local key = customkey and tostring(customkey):gsub("%s+", ""):upper() or activekey
	if not key or key == "" then
		Chloex:SetDonator(false)
		Chloex.DonatorInfo = nil
		if getgenv then
			getgenv().SenaDonatorInfo = nil
		end
		return false, "no_key"
	end

	local cfg = (getgenv and getgenv().SenaBackend) or backend or defaultbackend
	local api = tostring(cfg.Api or defaultbackend.Api):gsub("/+$", "")
	local apikey = tostring(cfg.Key or defaultbackend.Key)

	-- Same order as loader.lua (gethwid, then ClientId). A different order makes
	-- one device register two HWID slots. getexecutorname() is not an HWID:
	-- everyone on the same executor would share it.
	local hwid = ""
	pcall(function()
		if type(gethwid) == "function" then
			hwid = tostring(gethwid() or "")
		end
	end)
	if hwid == "" then
		pcall(function()
			hwid = tostring(game:GetService("RbxAnalyticsService"):GetClientId() or "")
		end)
	end
	if hwid == "" then
		hwid = "unknown"
	end

	local uid = localuserid()
	if uid == "0" or uid == "" then
		local lp = localplayer()
		if lp and lp.UserId and lp.UserId ~= 0 then
			uid = tostring(lp.UserId)
		end
	end

	local url = string.format(
		"%s/key/check?key=%s&license=%s&hwid=%s&uid=%s&place=%s&t=%s",
		api,
		sv.http:UrlEncode(apikey),
		sv.http:UrlEncode(key),
		sv.http:UrlEncode(hwid),
		sv.http:UrlEncode(uid),
		sv.http:UrlEncode(tostring(game.PlaceId or "")),
		tostring(os.time())
	)

	local okh, raw
	for attempt = 1, 3 do
		okh, raw = pcall(function()
			return game:HttpGet(url, true)
		end)
		if okh and raw and #raw > 0 then
			break
		end
		if attempt < 3 then
			task.wait(1)
		end
	end

	if okh and raw then
		local okj, res = pcall(sv.http.JSONDecode, sv.http, raw)
		if okj and type(res) == "table" and res.ok and res.valid then
			Chloex.DonatorInfo = res
			if res.is_trial == true or res.tier == "trial" then
				Chloex:SetDonator(false, true)
			else
				Chloex:UnlockAllDonatorFeatures()
			end
			publishkey(key, res)
			savekey(key)
			print(string.format("[SENA] Donator key verified: %s (%d days left)", tostring(res.name or key), tonumber(res.days_left or 0)))
			return true, res
		end

		local reason = tostring(okj and type(res) == "table" and res.reason or "invalid"):lower()
		if not (okj and type(res) == "table" and res.ok and res.valid == false) then
			-- garbled answer or server error: not a verdict on the key
			warn("[SENA] Bad response verifying key")
			if isdonator() and not claimexpired() then
				return true, donatorinfo() or { valid = true }
			end
			return false, "network_error"
		end
		if isdonator() and key ~= activekey then
			-- a wrong key typed into Redeem must not lock a donator whose own
			-- key is still active
			return false, reason
		end

		Chloex:SetDonator(false)
		local msg = "Invalid Key. Running in Free Mode."
		if reason:find("hwid limit") then
			msg = "HWID limit reached (3/3). Running Free Version. Reset in Discord."
		elseif reason:find("expired") then
			msg = "Donator Key expired. Running Free Version."
		end
		warn("[SENA] " .. msg)
		pcall(function()
			Chloex:Notify({ Title = "Sena", Description = "Free Mode", Content = msg, Duration = 6, Color = theme.Bad })
		end)
		return false, reason
	end

	-- Offline: keep the current tier only while its paid time has not run out.
	warn("[SENA] Network error verifying key")
	if isdonator() and not claimexpired() then
		return true, donatorinfo() or { valid = true }
	end
	return false, "network_error"
end

local function handlejoinupdate(this, req)
	local id = tostring(req.id or "")
	if id == "" then
		return
	end
	this.JoinSeen = this.JoinSeen or {}
	local status = tostring(req.status or "")
	local seenkey = id .. ":" .. status
	if this.JoinSeen[seenkey] then
		return
	end
	this.JoinSeen[seenkey] = true

	for _, fn in ipairs(this.JoinListeners) do
		task.spawn(function()
			elevate()
			pcall(fn, req)
		end)
	end

	if req.incoming then
		if status ~= "pending" then
			return
		end
		if (os.time() - (tonumber(req.ts) or 0)) > 110 then
			return
		end
		Chloex:Prompt({
			Title = tostring(req.name or "Someone"),
			Content = "wants to join your server (" .. tostring(req.game or "?") .. ")",
			Avatar = tostring(req.av or ""):match("^%d+$") and req.av or nil,
			Accept = "Accept",
			Decline = "Decline",
			Duration = 60,
			Callback = function(accepted)
				if accepted == nil then
					return
				end
				local ok, err = Chloex:AnswerJoin(id, accepted == true)
				if not ok then
					Chloex:Notify({ Title = "Sena", Description = "Request join", Content = "Could not answer: " .. tostring(err), Duration = 4 })
				elseif accepted then
					Chloex:Notify({ Title = "Sena", Description = "Request join", Content = tostring(req.name or "They") .. " is on the way to your server.", Duration = 4 })
				end
			end,
		})
	else
		if status == "accepted" then
			local place = tonumber(req.place)
			local job = tostring(req.job or "")
			if job == tostring(game.JobId) then
				Chloex:Notify({ Title = "Sena", Description = "Request join", Content = "You are already in " .. tostring(req.to_name or "their") .. "'s server.", Duration = 4 })
			elseif place and job ~= "" then
				Chloex:Notify({ Title = "Sena", Description = "Request join", Content = tostring(req.to_name or "They") .. " accepted. Joining their server...", Duration = 5 })
				task.delay(1.2, function()
					pcall(function()
						local lp = localplayer()
						if lp then
							game:GetService("TeleportService"):TeleportToPlaceInstance(place, job, lp)
						end
					end)
				end)
			end
		elseif status == "declined" then
			Chloex:Notify({ Title = "Sena", Description = "Request join", Content = tostring(req.to_name or "They") .. " declined.", Duration = 4 })
		elseif status == "expired" then
			Chloex:Notify({ Title = "Sena", Description = "Request join", Content = tostring(req.to_name or "They") .. " did not answer.", Duration = 4 })
		end
	end
end

local function startbackendloop(this)
	if this.LoopAlive then
		return
	end
	this.LoopAlive = true

	task.spawn(function()
		elevate()
		local uid = localuserid()
		local failures = 0
		if not this.Game or this.Game == "" then
			this.Game = detectgamename()
		end

		while this.Running and not Chloex.Unloaded do
			if uid == "0" or uid == "" then
				uid = localuserid()
			end
			local trial = istrial()
			local don = not trial and isdonator()
			local lic = (getgenv and getgenv().SenaKey) or (_G and _G.SenaKey) or ""
			local params = {
				uid = uid,
				key = this.Key,
				name = localusername(),
				display = localdisplayname(),
				donator = don and "1" or "0",
				trial = trial and "1" or "0",
				lic = tostring(lic or ""),
				chat_since = this.ChatSince,
				ann_since = this.AnnSince,
				dm_since = this.DmSince,
				join_since = this.JoinSince,
				game = this.Game or "",
				place = game.PlaceId,
			}
			for k, v in pairs(this.Extra) do
				params[k] = v
			end

			local data = httpgetjson(backendurl("/sync", params))

			if data and ((type(data.kick) == "string" and data.kick ~= "") or data.blacklisted) then
				this.Running = false
				local kickmsg = (type(data.kick) == "string" and data.kick ~= "") and data.kick
					or "You've been blacklisted from SENA.\nAppeal at discord.gg/senahub"
				pcall(function()
					local p = localplayer()
					if p then
						p:Kick(kickmsg)
					end
				end)
				return
			end

			if data and data.ok then
				failures = 0
				this.Connected = true
				this.Online = tonumber(data.online) or this.Online

				-- Tier report. Upgrades apply at once; a downgrade needs the
				-- server to have actually judged the license (lic_state from a
				-- current bot; older bots send none and never downgrade) twice
				-- in a row, so one odd answer cannot flip features off.
				if data.tier == "trial" or data.is_trial == true then
					this.FreeStreak = 0
					this.LastValid = os.time()
					if not istrial() then
						Chloex:SetDonator(false, true)
					end
				elseif data.tier == "donator" or data.is_donator == true then
					this.FreeStreak = 0
					this.LastValid = os.time()
					if not Chloex._isDonator then
						Chloex:UnlockAllDonatorFeatures()
					end
				elseif data.tier == "free" and (data.lic_state == "invalid" or data.lic_state == "none") then
					this.FreeStreak = (this.FreeStreak or 0) + 1
					if this.FreeStreak >= 2 and isdonator() then
						warn("[SENA] Backend reports this key is no longer active, locking donator features")
						Chloex:SetDonator(false)
						pcall(function()
							Chloex:Notify({ Title = "Sena", Description = "Donator", Content = "Your donator key is no longer active. Donator features are locked again.", Duration = 6, Color = theme.Bad })
						end)
					end
				else
					this.FreeStreak = 0
				end

				this.ChatTtl = tonumber(data.chat_ttl) or this.ChatTtl
				this.ChatMax = tonumber(data.chat_max) or this.ChatMax
				local poll = tonumber(data.poll)
				if poll then
					this.Interval = math.max(2, poll)
				end

				-- Maintenance switches (/pauseglobalchat, /pauseforum). Older bots send none = all off.
				local pausenow = {
					chat = data.chat_paused == true,
					dm = data.chat_pause_dm == true,
					chatmsg = tostring(data.chat_pause_msg or ""),
					forum = data.forum_paused == true,
					forummsg = tostring(data.forum_pause_msg or ""),
				}
				local prevpause = this.Paused or {}
				if prevpause.chat ~= pausenow.chat or prevpause.dm ~= pausenow.dm or prevpause.chatmsg ~= pausenow.chatmsg
					or prevpause.forum ~= pausenow.forum or prevpause.forummsg ~= pausenow.forummsg then
					this.Paused = pausenow
					for _, fn in ipairs(this.PauseListeners or {}) do
						task.spawn(function()
							elevate()
							local ok, err = pcall(fn, pausenow)
							if not ok then
								warn("[SENA] pause listener error:", err)
							end
						end)
					end
				end

				local cutoff = os.time() - this.ChatTtl
				while #this.History > 0 and (tonumber(this.History[1].ts) or 0) < cutoff do
					table.remove(this.History, 1)
				end

				if type(data.chat) == "table" then
					for _, msg in ipairs(data.chat) do
						local id = tonumber(msg.id) or 0
						if id > this.ChatSince then
							this.ChatSince = id
						end
						this.History[#this.History + 1] = msg
						if #this.History > 60 then
							table.remove(this.History, 1)
						end
						for _, fn in ipairs(this.Listeners) do
							task.spawn(function()
								elevate()
								local ok, err = pcall(fn, msg)
								if not ok then
									warn("[SENA] chat listener error:", err)
								end
							end)
						end
					end
				end

				if type(data.dm) == "table" then
					for _, msg in ipairs(data.dm) do
						local id = tonumber(msg.id) or 0
						if id > this.DmSince then
							this.DmSince = id
						end
						msg.pm = true
						this.DmHistory[#this.DmHistory + 1] = msg
						if #this.DmHistory > 60 then
							table.remove(this.DmHistory, 1)
						end
						for _, fn in ipairs(this.DmListeners) do
							task.spawn(function()
								elevate()
								local ok, err = pcall(fn, msg)
								if not ok then
									warn("[SENA] dm listener error:", err)
								end
							end)
						end
					end
				elseif tonumber(data.dm_seq) and this.DmSince == 0 then
					this.DmSince = tonumber(data.dm_seq)
				end

				local firstjoinsync = this.JoinSince == 0
				if tonumber(data.join_seq) and firstjoinsync then
					this.JoinSince = math.max(this.JoinSince, tonumber(data.join_seq))
				end
				if type(data.joins) == "table" then
					for _, req in ipairs(data.joins) do
						local ver = tonumber(req.ver) or 0
						if ver > this.JoinSince then
							this.JoinSince = ver
						end
						if not firstjoinsync or (req.incoming and tostring(req.status) == "pending") then
							task.spawn(function()
								elevate()
								local ok, err = pcall(handlejoinupdate, this, req)
								if not ok then
									warn("[SENA] join handler error:", err)
								end
							end)
						else
							this.JoinSeen = this.JoinSeen or {}
							this.JoinSeen[tostring(req.id or "") .. ":" .. tostring(req.status or "")] = true
						end
					end
				end

				if data.fuse ~= nil then
					for _, fn in ipairs(this.FuseListeners) do
						task.spawn(function()
							elevate()
							local ok, err = pcall(fn, data.fuse)
							if not ok then
								warn("[SENA] fuse listener error:", err)
							end
						end)
					end
				end

				local annseq = tonumber(data.ann_seq)
				if annseq then
					if this.AnnSince < 0 then
						this.AnnSince = annseq
					elseif type(data.ann) == "table" then
						for _, ann in ipairs(data.ann) do
							local id = tonumber(ann.id) or 0
							if id > this.AnnSince then
								this.AnnSince = id
							end
							if this.Announcements then
								Chloex:Announce({
									Title = ann.title,
									Content = ann.text,
									Duration = tonumber(ann.duration) or 15,
									Sound = ann.sound,
									From = ann.from,
									Role = ann.role,
								})
							end
						end
					end
				end
			else
				failures = failures + 1
				this.Connected = false
			end

			local wait = this.Interval + (math.random(0, 1500) / 1000)
			if failures > 0 then
				wait = math.min(30, this.Interval * (1 + failures)) + (math.random(0, 1500) / 1000)
			end
			task.wait(wait)
		end

		this.LoopAlive = false
		this.Connected = false
	end)
end

function Chloex:ConnectBackend(backendconfig)
	backendconfig = backendconfig or {}
	if backendconfig.Disabled then
		return nil
	end

	if not backend then
		local api = tostring(backendconfig.Api or defaultbackend.Api or ""):gsub("/+$", "")
		if api == "" then
			warn("[SENA] ConnectBackend: Api kosong")
			return nil
		end
		backend = {
			Api = api,
			Key = tostring(backendconfig.Key or defaultbackend.Key or ""),
			Game = backendconfig.Game and tostring(backendconfig.Game) or nil,
			Interval = math.max(2, tonumber(backendconfig.Interval) or 3),
			Announcements = backendconfig.Announcements ~= false,
			ChatSince = 0,
			AnnSince = -1,
			ChatTtl = 600,
			ChatMax = 120,
			Online = 0,
			Running = true,
			Connected = false,
			LoopAlive = false,
			Listeners = {},
			FuseListeners = {},
			DmListeners = {},
			JoinListeners = {},
			PauseListeners = {},
			Paused = {},
			DmSince = 0,
			JoinSince = 0,
			DmHistory = {},
			Extra = {},
			History = {},
		}
	else
		if backendconfig.Api then
			backend.Api = tostring(backendconfig.Api):gsub("/+$", "")
		end
		if backendconfig.Key then
			backend.Key = tostring(backendconfig.Key)
		end
		if backendconfig.Game then
			backend.Game = tostring(backendconfig.Game)
		end
		if backendconfig.Interval then
			backend.Interval = math.max(2, tonumber(backendconfig.Interval) or backend.Interval)
		end
		if backendconfig.Announcements ~= nil then
			backend.Announcements = backendconfig.Announcements ~= false
		end
		backend.Running = true
	end

	startbackendloop(backend)
	return backend
end

function Chloex:GetBackend()
	return backend
end

function Chloex:DisconnectBackend()
	if backend then
		backend.Running = false
	end
end

function Chloex:OnChat(fn)
	if not backend or type(fn) ~= "function" then
		return false
	end
	backend.Listeners[#backend.Listeners + 1] = fn
	return true
end

function Chloex:OnDM(fn)
	if not backend or type(fn) ~= "function" then
		return false
	end
	backend.DmListeners[#backend.DmListeners + 1] = fn
	return true
end

function Chloex:OnJoin(fn)
	if not backend or type(fn) ~= "function" then
		return false
	end
	backend.JoinListeners[#backend.JoinListeners + 1] = fn
	return true
end

function Chloex:OnPause(fn)
	if not backend or type(fn) ~= "function" then
		return false
	end
	backend.PauseListeners = backend.PauseListeners or {}
	backend.PauseListeners[#backend.PauseListeners + 1] = fn
	if backend.Paused then
		task.spawn(pcall, fn, backend.Paused)
	end
	return true
end

function Chloex:GetPaused()
	return backend and backend.Paused or {}
end

function Chloex:OnFuse(fn)
	if not backend or type(fn) ~= "function" then
		return false
	end
	backend.FuseListeners[#backend.FuseListeners + 1] = fn
	return true
end

function Chloex:SetSyncExtra(key, value)
	if not backend then
		return false
	end
	backend.Extra[tostring(key)] = value
	return true
end

function Chloex:BackendCall(path, params)
	if not backend then
		return nil, "not connected"
	end
	local trial = istrial()
	local don = not trial and isdonator()
	local lic = (getgenv and getgenv().SenaKey) or (_G and _G.SenaKey) or ""
	local merged = {
		uid = localuserid(),
		key = backend.Key,
		name = localusername(),
		display = localdisplayname(),
		game = backend.Game or "",
		place = game.PlaceId,
		donator = don and "1" or "0",
		trial = trial and "1" or "0",
		lic = tostring(lic or ""),
	}
	for k, v in pairs(params or {}) do
		merged[k] = v
	end
	local data = httpgetjson(backendurl(path, merged))
	if not data then
		return nil, "no response"
	end
	if data.ok == false then
		return data, tostring(data.error or "error")
	end
	return data, nil
end

local roomtagmap = {
	id = "indonesian",
	indo = "indonesian",
	indonesia = "indonesian",
	indonesian = "indonesian",
	ph = "philippines",
	philippines = "philippines",
	filipino = "philippines",
	pinoy = "philippines",
	vn = "vietnam",
	vietnam = "vietnam",
	vietnamese = "vietnam",
	br = "brazilian",
	brazil = "brazilian",
	brazilian = "brazilian",
	brasil = "brazilian",
	gen = "general",
	general = "general",
	all = "general",
}

local roomtags = {
	indonesian = "[ID]",
	philippines = "[PH]",
	vietnam = "[VN]",
	brazilian = "[BR]",
	general = "[GEN]",
}

local function parsemessageroom(msg)
	if type(msg) ~= "table" then
		return "general", ""
	end
	local text = tostring(msg.text or "")
	local tag, body = text:match("^%[([%w_]+)%]%s*(.*)$")
	local detected = nil
	if tag then
		local r = roomtagmap[tag:lower()]
		if r then
			detected = r
			text = body
		end
	end
	if msg.room and type(msg.room) == "string" and msg.room ~= "" then
		local r = roomtagmap[msg.room:lower()]
		if r then
			detected = r
		end
	end
	return detected or "general", text
end

local function keysharenotice()
	pcall(function()
		Chloex:Notify({
			Title = "Sena",
			Description = "Chat",
			Content = "Pesan diblokir: Dilarang membagikan key lisensi di chat!",
			Duration = 6,
			Color = theme.Bad,
		})
	end)
end

local function badwordkick(err, where)
	local minutes = err:match("^badword:(%d+)") or "?"
	local reason = "Sena: kata kasar terdeteksi di " .. where .. ". Ban " .. minutes .. " menit."
	task.delay(1.5, function()
		pcall(function()
			local p = localplayer()
			if p then
				p:Kick(reason)
			end
		end)
	end)
end

function Chloex:SendChat(text, room, hide)
	if not backend then
		return false, "not connected"
	end
	text = tostring(text or ""):gsub("^%s+", ""):gsub("%s+$", "")
	if text == "" then
		return false, "empty"
	end

	local upper = text:upper()
	if upper:match("SENA%-[%w]+%-[%w]+%-[%w]+") or upper:match("TRIAL%-[%w]+%-[%w]+%-[%w]+") or text:match("%w%w%w%w%-%w%w%w%w%-%w%w%w%w") then
		keysharenotice()
		return false, "Sharing key is prohibited"
	end

	room = tostring(room or "general"):lower()
	local tag = roomtags[room]
	local sendtext = text
	if tag and not sendtext:find("^%[") and room ~= "general" then
		sendtext = tag .. " " .. text
	end

	local owner = isowner()
	local trial = not owner and istrial()
	local don = not owner and not trial and isdonator()
	local lic = (getgenv and getgenv().SenaKey) or (_G and _G.SenaKey) or ""

	local ishide = false
	if not owner then
		if hide ~= nil then
			ishide = (hide == true or hide == "1" or hide == 1)
		elseif getgenv and getgenv().SenaHideName ~= nil then
			ishide = (getgenv().SenaHideName == true)
		elseif _G and _G.SenaHideName ~= nil then
			ishide = (_G.SenaHideName == true)
		elseif Chloex.HideName ~= nil then
			ishide = (Chloex.HideName == true)
		else
			ishide = true
		end
	end

	local data = httpgetjson(backendurl("/chat/send", {
		uid = localuserid(),
		key = backend.Key,
		name = owner and "Sena" or localusername(),
		game = backend.Game,
		text = sendtext,
		room = room,
		donator = don and "1" or "0",
		trial = trial and "1" or "0",
		owner = owner and "1" or "0",
		tier = owner and "owner" or (trial and "trial" or (don and "donator" or "free")),
		lic = tostring(lic or ""),
		hide = ishide and "1" or "0",
	}))
	if not data then
		return false, "no response"
	end
	if data.ok then
		return true
	end
	local err = tostring(data.error or "error")
	if err:match("key_share") then
		keysharenotice()
	elseif err:match("^badword") then
		badwordkick(err, "global chat")
	end
	return false, err
end

function Chloex:SendDM(toname, text)
	if not backend then
		return false, "not connected"
	end
	toname = tostring(toname or ""):gsub("^@", "")
	text = tostring(text or ""):gsub("^%s+", ""):gsub("%s+$", "")
	if toname == "" then
		return false, "who?"
	end
	if text == "" then
		return false, "empty"
	end
	local data, err = Chloex:BackendCall("/dm/send", { to = toname, text = text })
	if not data then
		return false, err
	end
	if data.ok then
		return true, data.to_name
	end
	err = tostring(data.error or "error")
	if err:match("^badword") then
		badwordkick(err, "chat")
	end
	return false, err
end

function Chloex:RequestJoin(toname)
	if not backend then
		return false, "not connected"
	end
	toname = tostring(toname or ""):gsub("^@", "")
	if toname == "" then
		return false, "who?"
	end
	local data, err = Chloex:BackendCall("/join/request", { to = toname })
	if not data then
		return false, err
	end
	if data.ok then
		return true, data.to_name
	end
	return false, tostring(data.error or "error")
end

function Chloex:AnswerJoin(id, accept)
	if not backend then
		return false, "not connected"
	end
	local data, err = Chloex:BackendCall("/join/answer", {
		id = tostring(id),
		accept = accept and "1" or "0",
		place = tostring(game.PlaceId),
		job = tostring(game.JobId),
	})
	if not data then
		return false, err
	end
	if data.ok then
		return true
	end
	return false, tostring(data.error or "error")
end

function Chloex:Window(guiconfig)
	guiconfig = guiconfig or {}
	Chloex.Unloaded = false
	-- the loader may have verified the key after this lib was loaded
	adoptclaim()
	if backend and not backend.Running then
		Chloex:ConnectBackend({})
	end
	guiconfig.Title = guiconfig.Title or "Sena"
	guiconfig.Footer = guiconfig.Footer or "Sena"
	guiconfig.Color = guiconfig.Color or theme.Accent
	guiconfig["Tab Width"] = guiconfig["Tab Width"] or 120
	guiconfig.Version = guiconfig.Version or 1
	local userPassedImage = guiconfig.Image
	local userPassedToggle = guiconfig.ToggleImage or guiconfig.ToggleIcon or guiconfig.ButtonImage
	guiconfig.Image = guiconfig.Image or "96240498384290"
	guiconfig.ImageSize = tonumber(guiconfig.ImageSize) or 48
	guiconfig.AutoConfigTab = guiconfig.AutoConfigTab ~= false
	guiconfig.LazyConfigTab = guiconfig.LazyConfigTab ~= false
	guiconfig.LoadUserThumbnail = guiconfig.LoadUserThumbnail ~= false
	guiconfig.ThumbnailDelay = tonumber(guiconfig.ThumbnailDelay) or 8

	local foldername = guiconfig.Folder or guiconfig.Title:gsub("[^%w_ ]", ""):gsub("%s+", "_")
	config.gamefolder = "Sena/" .. foldername
	config.autoloadfile = config.gamefolder .. "/autoload.txt"

	if hasfs and not isfolder(config.gamefolder) then
		pcall(makefolder, config.gamefolder)
	end

	config.version = guiconfig.Version

	local autoloadname = config:getautoload()
	if autoloadname then
		config:load(autoloadname)
	else
		config.data = { _version = config.version }
	end

	local guifunc = {}
	getgenv().ChloeX_Instance = guifunc
	local chloeex = instance.screengui(sv.coregui)
	chloeex.Name = "Chloeex"
	chloeex.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	chloeex.ResetOnSpawn = false

	local dropshadowholder = instance.frame(chloeex)
	dropshadowholder.Name = "DropShadowHolder"
	dropshadowholder.BackgroundTransparency = 1
	dropshadowholder.BorderSizePixel = 0
	dropshadowholder.AnchorPoint = Vector2.new(0.5, 0.5)
	dropshadowholder.Position = UDim2.new(0.5, 0, 0.5, 0)
	dropshadowholder.ZIndex = 0
	if isMobile then
		dropshadowholder.Size = safesize(470, 270)
	else
		dropshadowholder.Size = safesize(640, 400)
	end

	dropshadowholder.Position = UDim2.new(0.5, 0, 0.5, 0)

	local dropshadow = instance.imagelabel(dropshadowholder)
	dropshadow.Name = "DropShadow"
	dropshadow.Image = "rbxassetid://6015897843"
	dropshadow.ImageColor3 = Color3.fromRGB(15, 15, 15)
	dropshadow.ImageTransparency = 1
	dropshadow.ScaleType = Enum.ScaleType.Slice
	dropshadow.SliceCenter = Rect.new(49, 49, 450, 450)
	dropshadow.AnchorPoint = Vector2.new(0.5, 0.5)
	dropshadow.BackgroundTransparency = 1
	dropshadow.BorderSizePixel = 0
	dropshadow.Position = UDim2.new(0.5, 0, 0.5, 0)
	dropshadow.Size = UDim2.new(1, 47, 1, 47)
	dropshadow.ZIndex = 0

	-- Any Image other than the default Sena logo is the window background; the
	-- floating button logo comes from ToggleImage / ToggleIcon / ButtonImage.
	local bgRaw = guiconfig.Theme
		or guiconfig.Background
		or guiconfig.BackgroundImage
		or (userPassedImage and tostring(userPassedImage):gsub("%s+", "") ~= "96240498384290" and userPassedImage)

	local bgAsset = nil
	if bgRaw then
		local s = tostring(bgRaw):gsub("^%s+", ""):gsub("%s+$", "")
		if s ~= "" and s:lower() ~= "none" and s:lower() ~= "false" then
			if s:match("^%d+$") then
				bgAsset = "rbxassetid://" .. s
			elseif not s:match("^%a+://") then
				bgAsset = "rbxassetid://" .. s:gsub("^rbxassetid://", "")
			else
				bgAsset = s
			end
		end
	end

	local main
	if bgAsset then
		main = instance.imagelabel(dropshadow)
		if bgAsset:match("^https?://") then
			local url = bgAsset
			-- already in Sena/cache: show it right away, only the first run downloads
			main.Image = urlimage(url, true) or ""
			task.spawn(function()
				if main.Image ~= "" then
					return
				end
				local asset = urlimage(url)
				if asset and main.Parent then
					elevate()
					main.Image = asset
				end
			end)
		else
			main.Image = bgAsset
		end
		main.ScaleType = Enum.ScaleType.Crop
		main.BackgroundTransparency = 0
		main.BackgroundColor3 = theme.Backdrop
		local dim = math.clamp(tonumber(guiconfig.ThemeDim or guiconfig.BackgroundDim) or 0.35, 0, 1)
		local gray = math.floor((1 - dim) * 255 + 0.5)
		main.ImageColor3 = Color3.fromRGB(gray, gray, gray)
		rowalpha = math.clamp(tonumber(guiconfig.RowTransparency or guiconfig.RowAlpha) or 0.3, 0, 0.9)
	else
		rowalpha = 0
		main = instance.frame(dropshadow)
		main.BackgroundColor3 = theme.Backdrop
		main.BackgroundTransparency = 0
	end

	local mainstroke = instance.uistroke(main)
	mainstroke.Color = theme.Stroke
	mainstroke.Thickness = 1
	main.Name = "Main"
	main.AnchorPoint = Vector2.new(0.5, 0.5)
	main.BorderColor3 = Color3.fromRGB(0, 0, 0)
	main.BorderSizePixel = 0
	main.Position = UDim2.new(0.5, 0, 0.5, 0)
	main.Size = UDim2.new(1, -47, 1, -47)

	local uicorner = instance.uicorner(main)

	local top = instance.frame(main)
	top.Name = "Top"
	top.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	top.BackgroundTransparency = 1
	top.BorderColor3 = Color3.fromRGB(0, 0, 0)
	top.BorderSizePixel = 0
	top.Size = UDim2.new(1, 0, 0, 38)

	local textlabel = instance.textlabel(top)
	textlabel.Font = Enum.Font.GothamBold
	textlabel.Text = guiconfig.Title
	textlabel.TextColor3 = theme.Text
	textlabel.TextSize = 14
	textlabel.TextXAlignment = Enum.TextXAlignment.Left
	textlabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	textlabel.BackgroundTransparency = 1
	textlabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
	textlabel.BorderSizePixel = 0
	textlabel.Size = UDim2.new(1, -100, 1, 0)
	textlabel.Position = UDim2.new(0, 10, 0, 0)

	local uicorner1 = instance.uicorner(top)

	local textlabel1 = instance.textlabel(top)
	textlabel1.Font = Enum.Font.GothamBold
	textlabel1.Text = guiconfig.Footer
	textlabel1.TextColor3 = theme.SubText
	textlabel1.TextSize = 14
	textlabel1.TextXAlignment = Enum.TextXAlignment.Left
	textlabel1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	textlabel1.BackgroundTransparency = 1
	textlabel1.BorderColor3 = Color3.fromRGB(0, 0, 0)
	textlabel1.BorderSizePixel = 0
	textlabel1.Size = UDim2.new(1, -(textlabel.TextBounds.X + 104), 1, 0)
	textlabel1.Position = UDim2.new(0, textlabel.TextBounds.X + 15, 0, 0)

	local close = instance.textbutton(top)
	close.Name = "Close"
	close.Font = Enum.Font.SourceSans
	close.Text = ""
	close.TextColor3 = Color3.fromRGB(0, 0, 0)
	close.TextSize = 14
	close.AnchorPoint = Vector2.new(1, 0.5)
	close.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	close.BackgroundTransparency = 1
	close.BorderColor3 = Color3.fromRGB(0, 0, 0)
	close.BorderSizePixel = 0
	close.Position = UDim2.new(1, -8, 0.5, 0)
	close.Size = UDim2.new(0, 25, 0, 25)

	local imagelabel1 = instance.imagelabel(close)
	imagelabel1.Image = "rbxassetid://9886659671"
	imagelabel1.AnchorPoint = Vector2.new(0.5, 0.5)
	imagelabel1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	imagelabel1.BackgroundTransparency = 1
	imagelabel1.BorderColor3 = Color3.fromRGB(0, 0, 0)
	imagelabel1.BorderSizePixel = 0
	imagelabel1.Position = UDim2.new(0.49, 0, 0.5, 0)
	imagelabel1.Size = UDim2.new(1, -8, 1, -8)

	local min = instance.textbutton(top)
	min.Name = "Min"
	min.Font = Enum.Font.SourceSans
	min.Text = ""
	min.TextColor3 = Color3.fromRGB(0, 0, 0)
	min.TextSize = 14
	min.AnchorPoint = Vector2.new(1, 0.5)
	min.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	min.BackgroundTransparency = 1
	min.BorderColor3 = Color3.fromRGB(0, 0, 0)
	min.BorderSizePixel = 0
	min.Position = UDim2.new(1, -38, 0.5, 0)
	min.Size = UDim2.new(0, 25, 0, 25)

	local imagelabel2 = instance.imagelabel(min)
	imagelabel2.Image = "rbxassetid://9886659276"
	imagelabel2.AnchorPoint = Vector2.new(0.5, 0.5)
	imagelabel2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	imagelabel2.BackgroundTransparency = 1
	imagelabel2.ImageTransparency = 0.2
	imagelabel2.BorderColor3 = Color3.fromRGB(0, 0, 0)
	imagelabel2.BorderSizePixel = 0
	imagelabel2.Position = UDim2.new(0.5, 0, 0.5, 0)
	imagelabel2.Size = UDim2.new(1, -9, 1, -9)

	local searchbox = instance.textbox(top)
	searchbox.Name = "SearchBox"
	searchbox.AnchorPoint = Vector2.new(1, 0.5)
	searchbox.Position = UDim2.new(1, -66, 0.5, 0)
	searchbox.Size = UDim2.new(0, isMobile and 110 or 150, 0, 24)
	searchbox.BackgroundColor3 = theme.Pill
	searchbox.BackgroundTransparency = 0
	searchbox.BorderSizePixel = 0
	searchbox.Font = Enum.Font.Gotham
	searchbox.PlaceholderText = "Search"
	searchbox.PlaceholderColor3 = theme.Dim
	searchbox.Text = ""
	searchbox.TextColor3 = theme.Text
	searchbox.TextSize = 12
	searchbox.TextXAlignment = Enum.TextXAlignment.Left
	searchbox.ClearTextOnFocus = false
	searchbox.ClipsDescendants = true
	searchbox.TextTruncate = Enum.TextTruncate.AtEnd
	instance.uicorner(searchbox).CornerRadius = UDim.new(1, 0)

	local searchstroke = instance.uistroke(searchbox)
	searchstroke.Color = theme.Stroke
	searchstroke.Thickness = 1
	searchstroke.Transparency = 0.35

	local searchpad = instance.uipadding(searchbox)
	searchpad.PaddingLeft = UDim.new(0, 26)
	searchpad.PaddingRight = UDim.new(0, 10)

	local searchicon = instance.imagelabel(searchbox)
	searchicon.AnchorPoint = Vector2.new(0, 0.5)
	searchicon.Position = UDim2.new(0, -17, 0.5, 0)
	searchicon.Size = UDim2.new(0, 12, 0, 12)
	searchicon.BackgroundTransparency = 1
	searchicon.ImageColor3 = theme.Dim
	applyicon(searchicon, "search", 48)

	local layerstab = instance.frame(main)
	layerstab.Name = "LayersTab"
	layerstab.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	layerstab.BackgroundTransparency = 1
	layerstab.BorderColor3 = Color3.fromRGB(0, 0, 0)
	layerstab.BorderSizePixel = 0
	layerstab.Position = UDim2.new(0, 3, 0, 50)
	layerstab.Size = UDim2.new(0, guiconfig["Tab Width"], 1, -93)

	local uicorner2 = instance.uicorner(layerstab)
	uicorner2.CornerRadius = UDim.new(0, 2)

	local decideframe = instance.frame(main)
	decideframe.Name = "DecideFrame"
	decideframe.AnchorPoint = Vector2.new(0.5, 0)
	decideframe.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	decideframe.BackgroundTransparency = 0.85
	decideframe.BorderColor3 = Color3.fromRGB(0, 0, 0)
	decideframe.BorderSizePixel = 0
	decideframe.Position = UDim2.new(0.5, 0, 0, 38)
	decideframe.Size = UDim2.new(1, 0, 0, 1)

	local decidesaparator = instance.frame(layerstab)
	decidesaparator.Name = "DecideSaparator"
	decidesaparator.AnchorPoint = Vector2.new(1, 0)
	decidesaparator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	decidesaparator.BackgroundTransparency = 0.85
	decidesaparator.BorderColor3 = Color3.fromRGB(0, 0, 0)
	decidesaparator.BorderSizePixel = 0
	decidesaparator.Position = UDim2.new(1, 3, 0, -11)
	decidesaparator.Size = UDim2.new(0, 1, 1, 17)
	decidesaparator.Rotation = 0

	local layers = instance.frame(main)
	layers.Name = "Layers"
	layers.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	layers.BackgroundTransparency = 1
	layers.BorderColor3 = Color3.fromRGB(0, 0, 0)
	layers.BorderSizePixel = 0
	layers.Position = UDim2.new(0, guiconfig["Tab Width"] + 13, 0, 40)
	layers.Size = UDim2.new(1, -(guiconfig["Tab Width"] + 20), 1, -83)

	local uicorner6 = instance.uicorner(layers)
	uicorner6.CornerRadius = UDim.new(0, 2)

	local layersreal = instance.frame(layers)
	layersreal.Name = "LayersReal"
	layersreal.AnchorPoint = Vector2.new(0, 1)
	layersreal.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	layersreal.BackgroundTransparency = 1
	layersreal.BorderColor3 = Color3.fromRGB(0, 0, 0)
	layersreal.BorderSizePixel = 0
	layersreal.ClipsDescendants = true
	layersreal.Position = UDim2.new(0, 0, 1, 0)
	layersreal.Size = UDim2.new(1, 0, 1, 0)

	local layersfolder = instance.folder(layersreal)
	layersfolder.Name = "LayersFolder"

	local layerspagelayout = instance.uipagelayout(layersfolder)
	layerspagelayout.Name = "LayersPageLayout"
	layerspagelayout.SortOrder = Enum.SortOrder.LayoutOrder
	layerspagelayout.TweenTime = 0
	layerspagelayout.EasingDirection = Enum.EasingDirection.InOut
	layerspagelayout.EasingStyle = Enum.EasingStyle.Quad
	layerspagelayout.GamepadInputEnabled = false
	layerspagelayout.ScrollWheelInputEnabled = false
	layerspagelayout.TouchInputEnabled = false

	local scrolltab = instance.scrollingframe(layerstab)
	scrolltab.Name = "ScrollTab"
	scrolltab.CanvasSize = UDim2.new(0, 0, 0, 0)
	scrolltab.ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0)
	scrolltab.ScrollBarThickness = 0
	scrolltab.Active = true
	scrolltab.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	scrolltab.BackgroundTransparency = 1
	scrolltab.BorderColor3 = Color3.fromRGB(0, 0, 0)
	scrolltab.BorderSizePixel = 0
	scrolltab.Size = UDim2.new(1, 0, 0.89, 30)

	local uilistlayout = instance.uilistlayout(scrolltab)
	uilistlayout.Padding = UDim.new(0, 3)
	uilistlayout.SortOrder = Enum.SortOrder.LayoutOrder
	uilistlayout.HorizontalAlignment = Enum.HorizontalAlignment.Left

	local scrolltabpad = instance.uipadding(scrolltab)
	scrolltabpad.PaddingTop = UDim.new(0, 4)
	scrolltabpad.PaddingLeft = UDim.new(0, 6)
	scrolltabpad.PaddingRight = UDim.new(0, 6)

	local function updatesize1()
		scrolltab.CanvasSize = UDim2.new(0, 0, 0, uilistlayout.AbsoluteContentSize.Y)
	end

	trackConnection(
		uilistlayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			debounceResize("tabscroll_resize", updatesize1, 0.05)
		end),
		"tabscroll.propertychanged"
	)
	updatesize1()

	local userfooter = instance.frame(main)
	userfooter.Name = "UserFooter"
	userfooter.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	userfooter.BackgroundTransparency = 1
	userfooter.BorderSizePixel = 0
	userfooter.AnchorPoint = Vector2.new(0, 1)
	userfooter.Position = UDim2.new(0, 0, 1, 0)
	userfooter.Size = UDim2.new(1, 0, 0, 36)

	local uic = instance.uicorner(userfooter)
	uic.CornerRadius = UDim.new(0, 4)

	local headshot = instance.imagelabel(userfooter)
	headshot.Name = "Headshot"
	headshot.BackgroundColor3 = theme.Element
	headshot.BackgroundTransparency = 0.3
	headshot.Size = UDim2.new(0, 25, 0, 25)
	headshot.Position = UDim2.new(0, 10, 0.2, -3)

	local hscorner = instance.uicorner(headshot)
	hscorner.Name = "HS_Corner"
	hscorner.CornerRadius = UDim.new(1, 0)

	local username = instance.textlabel(userfooter)
	username.Name = "Username"
	username.BackgroundTransparency = 1
	username.Font = Enum.Font.Gotham
	username.TextColor3 = Color3.fromRGB(255, 255, 255)
	username.TextSize = 12
	username.TextXAlignment = Enum.TextXAlignment.Left
	username.Position = UDim2.new(0, 42, 0, 0)
	username.Size = UDim2.new(0, 140, 1, 0)
	username.TextTruncate = Enum.TextTruncate.AtEnd

	local localplayer = sv.plrs.LocalPlayer
	local rawname = localplayer and localplayer.Name or "User"
	local shortname

	if #rawname > 3 then
		shortname = string.sub(rawname, 1, 3) .. "..."
	else
		shortname = rawname
	end

	username.Text = "Welcome, " .. shortname

	local showident = false

	local function updateIdent()
		username.Text = "Welcome, " .. (showident and rawname or shortname)
	end

	local footerclick = instance.textbutton(userfooter)
	footerclick.Name = "UserFooterClick"
	footerclick.BackgroundTransparency = 1
	footerclick.Text = ""
	footerclick.Size = UDim2.new(0, 150, 1, 0)
	footerclick.ZIndex = 20
	footerclick.Activated:Connect(function()
		showident = not showident
		updateIdent()
	end)

	local function makepill(parent, pillconfig)
		local pill = instance.frame(parent)
		pill.Name = pillconfig.Name or "Pill"
		pill.LayoutOrder = pillconfig.LayoutOrder or 1
		pill.BackgroundColor3 = theme.Pill
		pill.BackgroundTransparency = 0
		pill.BorderSizePixel = 0
		pill.AutomaticSize = Enum.AutomaticSize.X
		pill.Size = UDim2.new(0, 0, 0, 22)
		instance.uicorner(pill).CornerRadius = UDim.new(1, 0)

		local stroke = instance.uistroke(pill)
		stroke.Color = theme.Stroke
		stroke.Thickness = 1
		stroke.Transparency = 0.35

		local pad = instance.uipadding(pill)
		pad.PaddingLeft = UDim.new(0, pillconfig.Icon and 9 or 12)
		pad.PaddingRight = UDim.new(0, 12)

		local layout = instance.uilistlayout(pill)
		layout.FillDirection = Enum.FillDirection.Horizontal
		layout.VerticalAlignment = Enum.VerticalAlignment.Center
		layout.Padding = UDim.new(0, 6)
		layout.SortOrder = Enum.SortOrder.LayoutOrder

		local icon
		if pillconfig.Icon then
			icon = instance.imagelabel(pill)
			icon.LayoutOrder = 1
			icon.BackgroundTransparency = 1
			icon.Size = UDim2.new(0, 12, 0, 12)
			icon.ImageColor3 = pillconfig.Color or theme.SubText
			applyicon(icon, pillconfig.Icon, 48)
		end

		local label = instance.textlabel(pill)
		label.LayoutOrder = 2
		label.BackgroundTransparency = 1
		label.AutomaticSize = Enum.AutomaticSize.X
		label.Size = UDim2.new(0, 0, 1, 0)
		label.Font = Enum.Font.GothamMedium
		label.Text = pillconfig.Text or ""
		label.TextColor3 = pillconfig.Color or theme.SubText
		label.TextSize = 11

		return pill, label, icon
	end

	local statusstrip = instance.frame(userfooter)
	statusstrip.Name = "Status"
	statusstrip.AnchorPoint = Vector2.new(1, 0.5)
	statusstrip.Position = UDim2.new(1, -10, 0.5, 0)
	statusstrip.Size = UDim2.new(0, 0, 0, 22)
	statusstrip.AutomaticSize = Enum.AutomaticSize.X
	statusstrip.BackgroundTransparency = 1

	local striplayout = instance.uilistlayout(statusstrip)
	striplayout.FillDirection = Enum.FillDirection.Horizontal
	striplayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
	striplayout.VerticalAlignment = Enum.VerticalAlignment.Center
	striplayout.Padding = UDim.new(0, 6)
	striplayout.SortOrder = Enum.SortOrder.LayoutOrder

	if not isMobile then
		makepill(statusstrip, { Name = "Executor", LayoutOrder = 1, Icon = "terminal", Text = "Executor : " .. executorname() })
	end

	local _, fpslabel = makepill(statusstrip, { Name = "Fps", LayoutOrder = 2, Icon = "activity", Text = "-- FPS" })

	local _, donatorlabel, donatoricon = makepill(statusstrip, { Name = "Donator", LayoutOrder = 3, Icon = "crown", Text = "Free" })

	local function refreshdonatorpill()
		local info = Chloex.DonatorInfo or (getgenv and getgenv().SenaDonatorInfo)
		local text, color
		if istrial() then
			text, color = "Trial", theme.Blue
		elseif isdonator() then
			local days = info and tonumber(info.days_left)
			text = days and ("Donator · " .. tostring(math.floor(days)) .. "d") or "Donator"
			color = theme.Gold
		else
			text, color = "Free", theme.SubText
		end
		donatorlabel.Text = text
		donatorlabel.TextColor3 = color
		if donatoricon then
			donatoricon.ImageColor3 = color
		end
	end

	refreshdonatorpill()
	table.insert(Chloex.DonatorListeners, function()
		if donatorlabel and donatorlabel.Parent then
			refreshdonatorpill()
		end
	end)

	do
		local frames, elapsed = 0, 0
		trackConnection(
			game:GetService("RunService").RenderStepped:Connect(function(dt)
				frames = frames + 1
				elapsed = elapsed + dt
				if elapsed >= 1 then
					fpslabel.Text = tostring(math.floor(frames / elapsed + 0.5)) .. " FPS"
					frames, elapsed = 0, 0
				end
			end),
			"footer.fps"
		)
	end

	if guiconfig.LoadUserThumbnail then
		task.delay(math.max(0, guiconfig.ThumbnailDelay), function()
			local uid = localplayer and localplayer.UserId
			if not uid or not headshot or not headshot.Parent then
				return
			end

			local ok, content = pcall(function()
				return sv.plrs:GetUserThumbnailAsync(uid, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
			end)

			if ok and content and headshot and headshot.Parent then
				headshot.Image = content
			end
		end)
	end

	local decideframe2 = instance.frame(main)
	decideframe2.Name = "DecideFrame2"
	decideframe2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	decideframe2.BackgroundTransparency = 0.85
	decideframe2.BorderSizePixel = 0
	decideframe2.AnchorPoint = Vector2.new(0, 1)
	decideframe2.Size = UDim2.new(1, 0, 0, 1)

	local function updateseparator()
		decideframe2.Position = UDim2.new(0, 0, 1, -userfooter.AbsoluteSize.Y)
	end

	updateseparator()
	trackConnection(
		userfooter:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
			debounceResize("footer_separator", updateseparator, 0.05)
		end),
		"footer.propertychanged"
	)

	decideframe2.Position = UDim2.new(0, 0, 1, -userfooter.Size.Y.Offset)

	function guifunc:DestroyGui()
		disconnectAll()
		for key, timer in pairs(resizeDebounceTable) do
			if timer then
				task.cancel(timer)
			end
		end
		resizeDebounceTable = {}
		for name in pairs(heartbeatCallbacks) do
			unregisterHeartbeat(name)
		end

		if sv.coregui:FindFirstChild("Chloeex") then
			chloeex:Destroy()
		end

		if sv.coregui:FindFirstChild("ToggleUIButton") then
			sv.coregui.ToggleUIButton:Destroy()
		end

		if sv.coregui:FindFirstChild("AnnounceGui") then
			sv.coregui.AnnounceGui:Destroy()
		end
		-- AnnounceGui can live under gethui(); overlays and notifications belong
		-- to this instance too, so they go with it
		pcall(function()
			if AnnounceGui then
				AnnounceGui:Destroy()
			end
		end)
		for _, child in ipairs(sv.coregui:GetChildren()) do
			if child.Name == "OverlayGui" or child.Name == "NotifyGui" then
				pcall(function()
					child:Destroy()
				end)
			end
		end

		Chloex.Unloaded = true
		Chloex.LockRegistry = {}
		Chloex:DisconnectBackend()

		getgenv().ChloeX_Instance = nil
		getgenv().ChloeX_Running = nil
		getgenv().ChloeX_ReopenPrompt = nil
	end

	min.Activated:Connect(function()
		dropshadowholder.Visible = false
	end)

	close.Activated:Connect(function()
		local overlay = instance.frame(dropshadowholder)
		overlay.Size = UDim2.new(1, 0, 1, 0)
		overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		overlay.BackgroundTransparency = 0.3
		overlay.ZIndex = 50

		local dialog = instance.frame(overlay)
		dialog.Size = UDim2.new(0, 300, 0, 150)
		dialog.Position = UDim2.new(0.5, -150, 0.5, -75)
		dialog.BackgroundColor3 = theme.Card
		dialog.BackgroundTransparency = 0
		dialog.BorderSizePixel = 0
		dialog.ZIndex = 51
		local uicorner3 = instance.uicorner(dialog)
		uicorner3.CornerRadius = UDim.new(0, 8)
		local dialogstroke = instance.uistroke(dialog)
		dialogstroke.Color = theme.Stroke
		dialogstroke.Thickness = 1

		local title = instance.textlabel(dialog)
		title.Name = "Title"
		title.Size = UDim2.new(1, 0, 0, 40)
		title.Position = UDim2.new(0, 0, 0, 4)
		title.BackgroundTransparency = 1
		title.Font = Enum.Font.GothamBold
		title.Text = "Sena Window"
		title.TextSize = 22
		title.TextColor3 = Color3.fromRGB(255, 255, 255)
		title.ZIndex = 52

		local message = instance.textlabel(dialog)
		message.Name = "Message"
		message.Size = UDim2.new(1, -20, 0, 60)
		message.Position = UDim2.new(0, 10, 0, 30)
		message.BackgroundTransparency = 1
		message.Font = Enum.Font.Gotham
		message.Text = "Do you want to close this window?\nYou will not be able to open it again"
		message.TextSize = 14
		message.TextColor3 = theme.SubText
		message.TextWrapped = true
		message.ZIndex = 52

		local yes = instance.textbutton(dialog)
		yes.Name = "Yes"
		yes.Size = UDim2.new(0.45, -10, 0, 35)
		yes.Position = UDim2.new(0.05, 0, 1, -55)
		yes.BackgroundColor3 = theme.Element
		yes.BackgroundTransparency = 0
		yes.AutoButtonColor = true
		yes.Text = "Yes"
		yes.Font = Enum.Font.GothamBold
		yes.TextSize = 15
		yes.TextColor3 = Color3.fromRGB(255, 255, 255)
		yes.TextTransparency = 0.3
		yes.ZIndex = 52
		local yescorner = instance.uicorner(yes)
		yescorner.CornerRadius = UDim.new(0, 6)

		local cancel = instance.textbutton(dialog)
		cancel.Name = "Cancel"
		cancel.Size = UDim2.new(0.45, -10, 0, 35)
		cancel.Position = UDim2.new(0.5, 10, 1, -55)
		cancel.BackgroundColor3 = theme.Element
		cancel.BackgroundTransparency = 0
		cancel.AutoButtonColor = true
		cancel.Text = "Cancel"
		cancel.Font = Enum.Font.GothamBold
		cancel.TextSize = 15
		cancel.TextColor3 = Color3.fromRGB(255, 255, 255)
		cancel.TextTransparency = 0.3
		cancel.ZIndex = 52
		local cancelcorner = instance.uicorner(cancel)
		cancelcorner.CornerRadius = UDim.new(0, 6)

		yes.MouseButton1Click:Connect(function()
			guifunc:DestroyGui()
		end)

		cancel.MouseButton1Click:Connect(function()
			overlay:Destroy()
		end)
	end)

	local togglekey = Enum.KeyCode.F3
	trackConnection(
		sv.uis.InputBegan:Connect(function(input, gpe)
			if gpe then
				return
			end
			if input.KeyCode == togglekey then
				if dropshadowholder then
					dropshadowholder.Visible = not dropshadowholder.Visible
				end
			end
		end),
		"window.togglekey"
	)

	function guifunc:ToggleUI()
		local screengui = instance.screengui(sv.coregui)
		screengui.Name = "ToggleUIButton"
		screengui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

		local mainbutton = instance.imagelabel(screengui)
		mainbutton.Size = UDim2.new(0, guiconfig.ImageSize, 0, guiconfig.ImageSize)
		mainbutton.Position = UDim2.new(0, 20, 0, 100)
		mainbutton.BackgroundTransparency = 1
		local toggleIcon = userPassedToggle or (not bgAsset and userPassedImage) or "96240498384290"
		local toggleStr = tostring(toggleIcon):gsub("^%s+", ""):gsub("%s+$", "")
		if toggleStr:match("^%d+$") then
			toggleStr = "rbxassetid://" .. toggleStr
		elseif not toggleStr:match("^%a+://") then
			toggleStr = "rbxassetid://" .. toggleStr:gsub("^rbxassetid://", "")
		end
		if toggleStr:match("^https?://") then
			local url = toggleStr
			mainbutton.Image = urlimage(url, true) or "rbxassetid://96240498384290"
			task.spawn(function()
				if not mainbutton.Image:match("^rbxassetid://96240498384290") then
					return
				end
				local asset = urlimage(url)
				if asset and mainbutton.Parent then
					elevate()
					mainbutton.Image = asset
				end
			end)
		else
			mainbutton.Image = toggleStr
		end
		mainbutton.ScaleType = Enum.ScaleType.Crop

		local uicorner = instance.uicorner(mainbutton)
		uicorner.CornerRadius = UDim.new(0, 6)

		local button = instance.textbutton(mainbutton)
		button.Size = UDim2.new(1, 0, 1, 0)
		button.BackgroundTransparency = 1
		button.Text = ""

		button.MouseButton1Click:Connect(function()
			if dropshadowholder then
				dropshadowholder.Visible = not dropshadowholder.Visible
			end
		end)

		local dragging = false
		local dragstart, startpos

		local function update(input)
			local delta = input.Position - dragstart
			mainbutton.Position =
				UDim2.new(startpos.X.Scale, startpos.X.Offset + delta.X, startpos.Y.Scale, startpos.Y.Offset + delta.Y)
		end

		button.InputBegan:Connect(function(input)
			if
				input.UserInputType == Enum.UserInputType.MouseButton1
				or input.UserInputType == Enum.UserInputType.Touch
			then
				dragging = true
				dragstart = input.Position
				startpos = mainbutton.Position
				input.Changed:Connect(function()
					if input.UserInputState == Enum.UserInputState.End then
						dragging = false
					end
				end)
			end
		end)

		trackConnection(
			sv.uis.InputChanged:Connect(function(input)
				if
					dragging
					and (
						input.UserInputType == Enum.UserInputType.MouseMovement
						or input.UserInputType == Enum.UserInputType.Touch
					)
				then
					update(input)
				end
			end),
			"togglebutton.drag"
		)
	end

	guifunc:ToggleUI()

	local tabs = {}
	local searchItems = {}
	local counttab = 0
	local countdropdown = 0
	local templates = {}

	do
		local t = instance.frame(nil)
		t.Name = "Toggle"
		t.BorderSizePixel = 0
		t.Size = UDim2.new(1, 0, 0, 46)
		roundbg(t, 4, theme.Row)

		local ttitle = instance.textlabel(t)
		ttitle.Name = "ToggleTitle"
		ttitle.Font = Enum.Font.GothamBold
		ttitle.TextSize = 13
		ttitle.TextColor3 = theme.Text
		ttitle.TextXAlignment = Enum.TextXAlignment.Left
		ttitle.TextYAlignment = Enum.TextYAlignment.Top
		ttitle.BackgroundTransparency = 1
		ttitle.Position = UDim2.new(0, 10, 0, 15)
		ttitle.Size = UDim2.new(1, -100, 0, 13)

		local tbutton = instance.textbutton(t)
		tbutton.Name = "ToggleButton"
		tbutton.Font = Enum.Font.SourceSans
		tbutton.Text = ""
		tbutton.BackgroundTransparency = 1
		tbutton.Size = UDim2.new(1, 0, 1, 0)

		local tfeature = instance.frame(t)
		tfeature.Name = "FeatureFrame"
		tfeature.AnchorPoint = Vector2.new(1, 0.5)
		tfeature.BackgroundColor3 = theme.Field
		tfeature.BackgroundTransparency = 0
		tfeature.BorderSizePixel = 0
		tfeature.Position = UDim2.new(1, -15, 0.5, 0)
		tfeature.Size = UDim2.new(0, 38, 0, 19)
		instance.uicorner(tfeature)

		local tstroke = instance.uistroke(tfeature)
		tstroke.Color = Color3.fromRGB(255, 255, 255)
		tstroke.Thickness = 2
		tstroke.Transparency = 0.9

		local tcircle = instance.frame(tfeature)
		tcircle.Name = "ToggleCircle"
		tcircle.BackgroundColor3 = theme.Text
		tcircle.BorderSizePixel = 0
		tcircle.Position = UDim2.new(0, 2, 0, 2)
		tcircle.Size = UDim2.new(0, 15, 0, 15)
		instance.uicorner(tcircle).CornerRadius = UDim.new(0, 15)

		templates.Toggle = t
	end

	do
		local s = instance.frame(nil)
		s.Name = "Slider"
		s.BorderSizePixel = 0
		s.Size = UDim2.new(1, 0, 0, 58)
		roundbg(s, 4, theme.Row)

		local stitle = instance.textlabel(s)
		stitle.Name = "SliderTitle"
		stitle.Font = Enum.Font.GothamBold
		stitle.TextColor3 = theme.Text
		stitle.TextSize = 13
		stitle.TextXAlignment = Enum.TextXAlignment.Left
		stitle.TextYAlignment = Enum.TextYAlignment.Center
		stitle.BackgroundTransparency = 1
		stitle.Position = UDim2.new(0, 10, 0, 7)
		stitle.Size = UDim2.new(1, -58, 0, 20)

		local sholder = instance.frame(s)
		sholder.Name = "SliderInputHolder"
		sholder.AnchorPoint = Vector2.new(1, 0)
		sholder.Position = UDim2.new(1, -10, 0, 6)
		sholder.Size = UDim2.new(0, 34, 0, 23)
		roundbg(sholder, 4, theme.Field)

		local sinput = instance.textbox(sholder)
		sinput.Name = "SliderInput"
		sinput.Font = Enum.Font.GothamBold
		sinput.Text = ""
		sinput.TextColor3 = Color3.fromRGB(255, 255, 255)
		sinput.TextSize = 12
		sinput.TextScaled = true
		sinput.TextXAlignment = Enum.TextXAlignment.Center
		sinput.TextYAlignment = Enum.TextYAlignment.Center
		sinput.BackgroundTransparency = 1
		sinput.ClearTextOnFocus = false
		sinput.Size = UDim2.new(1, -6, 1, 0)
		sinput.Position = UDim2.new(0, 3, 0, 0)

		local sinputconstraint = instance.uitextsizeconstraint(sinput)
		sinputconstraint.MinTextSize = 7
		sinputconstraint.MaxTextSize = 12

		local sbar = instance.frame(s)
		sbar.Name = "SliderBar"
		sbar.BackgroundColor3 = theme.Bar
		sbar.BackgroundTransparency = 0
		sbar.Position = UDim2.new(0, 10, 0, 39)
		sbar.Size = UDim2.new(1, -20, 0, 5)
		sbar.Active = true
		instance.uicorner(sbar).CornerRadius = UDim.new(1, 0)

		local sfill = instance.frame(sbar)
		sfill.Name = "SliderFill"
		sfill.BackgroundColor3 = guiconfig.Color
		sfill.BorderSizePixel = 0
		sfill.Size = UDim2.new(0, 0, 1, 0)
		instance.uicorner(sfill).CornerRadius = UDim.new(1, 0)

		local scircle = instance.frame(sbar)
		scircle.Name = "SliderCircle"
		scircle.AnchorPoint = Vector2.new(0.5, 0.5)
		scircle.BackgroundColor3 = guiconfig.Color
		scircle.Position = UDim2.new(0, 0, 0.5, 0)
		scircle.Size = UDim2.new(0, 12, 0, 12)
		scircle.Active = true
		scircle.ZIndex = 4
		instance.uicorner(scircle).CornerRadius = UDim.new(1, 0)

		local scirclestroke = instance.uistroke(scircle)
		scirclestroke.Color = Color3.fromRGB(255, 255, 255)
		scirclestroke.Transparency = 0.45
		scirclestroke.Thickness = 1

		local sbubble = instance.frame(sbar)
		sbubble.Name = "ValueBubble"
		sbubble.AnchorPoint = Vector2.new(0.5, 1)
		sbubble.BackgroundColor3 = theme.Element
		sbubble.BackgroundTransparency = 0
		sbubble.Position = UDim2.new(0, 0, 0, -10)
		sbubble.Size = UDim2.new(0, 48, 0, 22)
		sbubble.Visible = false
		sbubble.ZIndex = 20
		instance.uicorner(sbubble).CornerRadius = UDim.new(0, 5)

		local sbubbletext = instance.textlabel(sbubble)
		sbubbletext.Name = "BubbleText"
		sbubbletext.BackgroundTransparency = 1
		sbubbletext.Size = UDim2.new(1, -6, 1, 0)
		sbubbletext.Position = UDim2.new(0, 3, 0, 0)
		sbubbletext.Font = Enum.Font.GothamBold
		sbubbletext.TextColor3 = Color3.fromRGB(255, 255, 255)
		sbubbletext.TextSize = 11
		sbubbletext.TextScaled = true
		sbubbletext.TextXAlignment = Enum.TextXAlignment.Center
		sbubbletext.TextYAlignment = Enum.TextYAlignment.Center
		sbubbletext.ZIndex = 21

		local sbubbleconstraint = instance.uitextsizeconstraint(sbubbletext)
		sbubbleconstraint.MinTextSize = 7
		sbubbleconstraint.MaxTextSize = 11

		templates.Slider = s
	end

	do
		local o = instance.frame(nil)
		o.Name = "Option"
		o.Size = UDim2.new(1, 0, 0, 30)
		roundbg(o, 3, theme.Option).ImageTransparency = 1

		local obutton = instance.textbutton(o)
		obutton.Name = "OptionButton"
		obutton.BackgroundTransparency = 1
		obutton.Size = UDim2.new(1, 0, 1, 0)
		obutton.Text = ""

		local otext = instance.textlabel(o)
		otext.Name = "OptionText"
		otext.Font = Enum.Font.GothamBold
		otext.TextSize = 13
		otext.TextColor3 = theme.Text
		otext.BackgroundTransparency = 1
		otext.TextXAlignment = Enum.TextXAlignment.Left
		otext.TextTruncate = Enum.TextTruncate.AtEnd

		local ochoose = instance.frame(o)
		ochoose.Name = "ChooseFrame"
		ochoose.AnchorPoint = Vector2.new(0, 0.5)
		ochoose.BackgroundColor3 = guiconfig.Color
		ochoose.Position = UDim2.new(0, 2, 0.5, 0)
		ochoose.Size = UDim2.new(0, 0, 0, 0)

		local ochoosestroke = instance.uistroke(ochoose)
		ochoosestroke.Color = guiconfig.Color
		ochoosestroke.Thickness = 1.6
		ochoosestroke.Transparency = 1
		instance.uicorner(ochoose)

		templates.DropdownOption = o
	end

	dropshadowholder.Size = UDim2.new(0, 115 + textlabel.TextBounds.X + 1 + textlabel1.TextBounds.X, 0, 350)
	makedraggable(top, dropshadowholder)

	local moreblur = instance.frame(layers)
	moreblur.Name = "MoreBlur"
	moreblur.AnchorPoint = Vector2.new(1, 1)
	moreblur.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	moreblur.BackgroundTransparency = 1
	moreblur.BorderColor3 = Color3.fromRGB(0, 0, 0)
	moreblur.BorderSizePixel = 0
	moreblur.ClipsDescendants = true
	moreblur.Position = UDim2.new(1, 8, 1, 8)
	moreblur.Size = UDim2.new(1, 154, 1, 54)
	moreblur.Visible = false

	local dropshadowholder1 = instance.frame(moreblur)
	dropshadowholder1.Name = "DropShadowHolder"
	dropshadowholder1.BackgroundTransparency = 1
	dropshadowholder1.BorderSizePixel = 0
	dropshadowholder1.Size = UDim2.new(1, 0, 1, 0)
	dropshadowholder1.ZIndex = 0

	local dropshadow1 = instance.imagelabel(dropshadowholder1)
	dropshadow1.Name = "DropShadow"
	dropshadow1.Image = "rbxassetid://6015897843"
	dropshadow1.ImageColor3 = Color3.fromRGB(0, 0, 0)
	dropshadow1.ImageTransparency = 1
	dropshadow1.ScaleType = Enum.ScaleType.Slice
	dropshadow1.SliceCenter = Rect.new(49, 49, 450, 450)
	dropshadow1.AnchorPoint = Vector2.new(0.5, 0.5)
	dropshadow1.BackgroundTransparency = 1
	dropshadow1.BorderSizePixel = 0
	dropshadow1.Position = UDim2.new(0.5, 0, 0.5, 0)
	dropshadow1.Size = UDim2.new(1, 35, 1, 35)
	dropshadow1.ZIndex = 0

	local uicorner28 = instance.uicorner(moreblur)

	local connectbutton = instance.textbutton(moreblur)
	connectbutton.Name = "ConnectButton"
	connectbutton.Font = Enum.Font.SourceSans
	connectbutton.Text = ""
	connectbutton.TextColor3 = Color3.fromRGB(0, 0, 0)
	connectbutton.TextSize = 14
	connectbutton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	connectbutton.BackgroundTransparency = 1
	connectbutton.BorderColor3 = Color3.fromRGB(0, 0, 0)
	connectbutton.BorderSizePixel = 0
	connectbutton.Size = UDim2.new(1, 0, 1, 0)

	local dropdownselect = instance.frame(moreblur)
	dropdownselect.Name = "DropdownSelect"
	dropdownselect.AnchorPoint = Vector2.new(1, 0.5)
	dropdownselect.BackgroundColor3 = theme.Element
	dropdownselect.BackgroundTransparency = 0
	dropdownselect.BorderColor3 = Color3.fromRGB(0, 0, 0)
	dropdownselect.BorderSizePixel = 0
	dropdownselect.LayoutOrder = 1
	dropdownselect.Position = UDim2.new(1, 172, 0.5, 0)
	dropdownselect.Size = UDim2.new(0, 160, 1, -16)
	dropdownselect.ClipsDescendants = true

	local uicorner36 = instance.uicorner(dropdownselect)
	uicorner36.CornerRadius = UDim.new(0, 3)

	local uistroke14 = instance.uistroke(dropdownselect)
	uistroke14.Color = theme.Stroke
	uistroke14.Thickness = 2.5
	uistroke14.Transparency = 0.8

	local dropdownselectreal = instance.frame(dropdownselect)
	dropdownselectreal.Name = "DropdownSelectReal"
	dropdownselectreal.AnchorPoint = Vector2.new(0.5, 0.5)
	dropdownselectreal.BackgroundColor3 = theme.Card
	dropdownselectreal.BackgroundTransparency = 0
	dropdownselectreal.BorderColor3 = Color3.fromRGB(0, 0, 0)
	dropdownselectreal.BorderSizePixel = 0
	dropdownselectreal.LayoutOrder = 1
	dropdownselectreal.Position = UDim2.new(0.5, 0, 0.5, 0)
	dropdownselectreal.Size = UDim2.new(1, 1, 1, 1)

	local dropdownfolder = instance.folder(dropdownselectreal)
	dropdownfolder.Name = "DropdownFolder"

	local droppagelayout = instance.uipagelayout(dropdownfolder)
	droppagelayout.Name = "DropPageLayout"
	droppagelayout.EasingDirection = Enum.EasingDirection.InOut
	droppagelayout.EasingStyle = Enum.EasingStyle.Quad
	droppagelayout.TweenTime = 0.01
	droppagelayout.SortOrder = Enum.SortOrder.LayoutOrder
	droppagelayout.FillDirection = Enum.FillDirection.Vertical
	droppagelayout.Archivable = false

	-- popuptoken: a close that is still sliding out must not hide a list that
	-- was opened again in the meantime. Defined after droppagelayout: a function
	-- written above a local sees a nil global instead.
	local popuptoken = 0

	local function opendropdownpopup(index)
		popuptoken = popuptoken + 1
		moreblur.Visible = true
		droppagelayout:JumpToIndex(index)
		sv.ts:Create(moreblur, TweenInfo.new(0.3), { BackgroundTransparency = 1 }):Play()
		sv.ts:Create(dropdownselect, TweenInfo.new(0.3), { Position = UDim2.new(1, -11, 0.5, 0) }):Play()
	end

	local function closedropdownpopup()
		if not moreblur.Visible then
			return
		end
		popuptoken = popuptoken + 1
		local token = popuptoken
		sv.ts:Create(moreblur, TweenInfo.new(0.3), { BackgroundTransparency = 1 }):Play()
		sv.ts:Create(dropdownselect, TweenInfo.new(0.3), { Position = UDim2.new(1, 172, 0.5, 0) }):Play()
		task.delay(0.3, function()
			if popuptoken == token then
				moreblur.Visible = false
			end
		end)
	end

	connectbutton.Activated:Connect(closedropdownpopup)

	local searchopened = {}

	local function runsearch()
		local query = string.lower(searchbox.Text or "")
		local current = layerspagelayout.CurrentPage
		local seen = {}

		if query == "" then
			for section, closefn in pairs(searchopened) do
				pcall(closefn)
			end
			searchopened = {}
		end

		for _, data in ipairs(searchItems) do
			if query == "" or data.Page == current then
				local match = query == ""
					or string.find(string.lower(data.Name), query, 1, true) ~= nil
					or string.find(string.lower(data.Path), query, 1, true) ~= nil
				if data.Object then
					data.Object.Visible = match
				end
				if data.Section then
					local state = seen[data.Section]
					if not state then
						state = { any = false, open = data.OpenSection, close = data.CloseSection, isopen = data.IsOpen }
						seen[data.Section] = state
					end
					if match then
						state.any = true
					end
				end
			end
		end

		for section, state in pairs(seen) do
			section.Visible = query == "" or state.any
			if query ~= "" and state.any and state.open then
				local wasopen = state.isopen and state.isopen()
				if not wasopen then
					searchopened[section] = state.close
					pcall(state.open)
				end
			end
		end
	end

	searchbox:GetPropertyChangedSignal("Text"):Connect(function()
		debounceResize("search", runsearch, 0.05)
	end)

	local lockextra = 22
	local usedkeys = {}

	-- Config key of an element: Flag when given, else Title. Two elements with
	-- the same key share one saved value, so say so.
	local function keyfor(prefix, elementconfig)
		local key = prefix .. tostring(elementconfig.Flag or elementconfig.Title)
		if usedkeys[key] then
			warn(string.format("[SENA] Duplicate config key %q: these elements share one saved value. Give one of them a unique Flag.", key))
		end
		usedkeys[key] = true
		return key
	end

	local function isdonatorelement(elementconfig)
		return elementconfig.Donator == true or elementconfig.Locked == true or elementconfig.Locked2 == true or elementconfig.DonatorOnly == true
	end

	-- Locked2 (alias DonatorOnly) is a stricter tier: a trial key unlocks the
	-- ordinary Locked/Donator elements but never these; only a real donator does.
	local function isdonatoronly(elementconfig)
		return elementconfig.Locked2 == true or elementconfig.DonatorOnly == true
	end

	local CONTENT_FONT = Enum.Font.Gotham
	local CONTENT_SIZE = 12

	-- Description text of an element: Content, Desc or Description; nil when empty.
	local function contenttext(elementconfig)
		local text = elementconfig.Content or elementconfig.Desc or elementconfig.Description
		if text == nil then
			return nil
		end
		text = tostring(text)
		if text:gsub("%s+", "") == "" then
			return nil
		end
		return text
	end

	-- Grey description line under an element title. measure() wraps the text to
	-- the row's current width and returns its height; the element turns that
	-- into its row height (see watchwidth for window resizes).
	local function attachcontent(row, text, x, y, rightinset)
		local label = instance.textlabel(row)
		label.Name = "Content"
		label.BackgroundTransparency = 1
		label.Font = CONTENT_FONT
		label.RichText = true
		label.Text = text
		label.TextColor3 = theme.SubText
		label.TextSize = CONTENT_SIZE
		label.TextWrapped = true
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.TextYAlignment = Enum.TextYAlignment.Top
		label.Position = UDim2.new(0, x, 0, y)
		label.Size = UDim2.new(1, -(x + rightinset), 0, CONTENT_SIZE)
		local function measure()
			local width = row.AbsoluteSize.X
			if width <= 1 then
				width = layers.AbsoluteSize.X
			end
			if width <= 1 then
				width = 440
			end
			local height = textheight(text, CONTENT_SIZE, CONTENT_FONT, width - x - rightinset, 400)
			label.Size = UDim2.new(1, -(x + rightinset), 0, height)
			return height
		end
		return label, measure
	end

	-- Re-run a layout when the row gets wider or narrower (window resize, first
	-- real layout pass). Height changes are ignored, the layout causes those.
	local function watchwidth(row, relayout)
		local lastwidth = -1
		local queued = false
		row:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
			local width = math.floor(row.AbsoluteSize.X + 0.5)
			if width == lastwidth or width <= 1 or queued then
				return
			end
			lastwidth = width
			queued = true
			task.defer(function()
				queued = false
				relayout()
			end)
		end)
	end

	-- Donator lock of one element. Lock() and Unlock() can run any number of
	-- times, because the tier can change mid-session (key redeemed, key expired,
	-- backend verdict). lockopts.OnLock(silent) drops the element back to its
	-- non-donator value (silent = during the build, the hub has not seen a value
	-- yet, so no callback); lockopts.OnUnlock re-applies the saved value. The
	-- saved value itself stays in the config while locked.
	local function makelock(container, controls, lockopts, startlocked)
		lockopts = lockopts or {}
		controls = controls or {}
		local donatoronly = lockopts.DonatorOnly == true
		local locked = false
		local baseheight, basetransparency = container.Size.Y.Offset, container.BackgroundTransparency
		local dimmed, overlay = {}, {}

		local function dim(obj)
			if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
				dimmed[#dimmed + 1] = { obj, "TextTransparency", obj.TextTransparency }
				obj.TextTransparency = obj.TextTransparency + (1 - obj.TextTransparency) * 0.6
			elseif obj:IsA("ImageLabel") or obj:IsA("ImageButton") then
				dimmed[#dimmed + 1] = { obj, "ImageTransparency", obj.ImageTransparency }
				obj.ImageTransparency = obj.ImageTransparency + (1 - obj.ImageTransparency) * 0.6
			elseif obj:IsA("UIStroke") then
				dimmed[#dimmed + 1] = { obj, "Transparency", obj.Transparency }
				obj.Transparency = obj.Transparency + (1 - obj.Transparency) * 0.6
			end
			if obj:IsA("GuiObject") then
				dimmed[#dimmed + 1] = { obj, "BackgroundTransparency", obj.BackgroundTransparency }
				obj.BackgroundTransparency = obj.BackgroundTransparency + (1 - obj.BackgroundTransparency) * 0.6
			end
		end

		local function buildoverlay()
			local lockborder = instance.frame(container)
			lockborder.Name = "LockBorder"
			lockborder.BackgroundTransparency = 1
			lockborder.AnchorPoint = Vector2.new(0.5, 0.5)
			lockborder.Position = UDim2.new(0.5, 0, 0.5, 0)
			lockborder.Size = UDim2.new(1, -2, 1, -2)
			lockborder.ZIndex = 1
			instance.uicorner(lockborder).CornerRadius = UDim.new(0, 3)

			local lockstroke = instance.uistroke(lockborder)
			lockstroke.Name = "LockStroke"
			lockstroke.Color = Color3.fromRGB(255, 255, 255)
			lockstroke.Thickness = 1
			lockstroke.Transparency = 0.85

			local notice = instance.textlabel(container)
			notice.Name = "LockNotice"
			notice.BackgroundTransparency = 1
			notice.Font = Enum.Font.GothamBold
			notice.RichText = true
			local tierlabel = donatoronly and "Donator only" or "Donator / Trial"
			notice.Text = '<font color="' .. hexcolor(theme.Text) .. '">' .. tierlabel .. '</font>  ·  get your key at senahub.xyz/key'
			notice.TextColor3 = theme.SubText
			notice.TextSize = 11
			notice.TextXAlignment = Enum.TextXAlignment.Left
			notice.TextTruncate = Enum.TextTruncate.AtEnd
			notice.Position = UDim2.new(0, 10, 0, baseheight - 4)
			notice.Size = UDim2.new(1, -96, 0, 16)
			notice.ZIndex = 12

			local pill = instance.frame(container)
			pill.Name = "LockPill"
			pill.AnchorPoint = Vector2.new(1, 0)
			pill.Position = UDim2.new(1, -10, 0, baseheight - 4)
			pill.Size = UDim2.new(0, 0, 0, 16)
			pill.AutomaticSize = Enum.AutomaticSize.X
			pill.BackgroundColor3 = theme.Field
			pill.BackgroundTransparency = 0
			pill.BorderSizePixel = 0
			pill.ZIndex = 12
			instance.uicorner(pill).CornerRadius = UDim.new(0, 4)

			local pillstroke = instance.uistroke(pill)
			pillstroke.Color = Color3.fromRGB(255, 255, 255)
			pillstroke.Thickness = 1
			pillstroke.Transparency = 0.85

			local pillpad = instance.uipadding(pill)
			pillpad.PaddingLeft = UDim.new(0, 7)
			pillpad.PaddingRight = UDim.new(0, 8)

			local pilllayout = instance.uilistlayout(pill)
			pilllayout.FillDirection = Enum.FillDirection.Horizontal
			pilllayout.VerticalAlignment = Enum.VerticalAlignment.Center
			pilllayout.Padding = UDim.new(0, 4)
			pilllayout.SortOrder = Enum.SortOrder.LayoutOrder

			local pillicon = instance.imagelabel(pill)
			pillicon.LayoutOrder = 1
			pillicon.BackgroundTransparency = 1
			pillicon.Size = UDim2.new(0, 10, 0, 10)
			pillicon.ImageColor3 = theme.Text
			pillicon.ZIndex = 13
			applyicon(pillicon, "lock", 48)

			local pilltext = instance.textlabel(pill)
			pilltext.LayoutOrder = 2
			pilltext.BackgroundTransparency = 1
			pilltext.AutomaticSize = Enum.AutomaticSize.X
			pilltext.Size = UDim2.new(0, 0, 1, 0)
			pilltext.Font = Enum.Font.GothamBold
			pilltext.Text = "LOCKED"
			pilltext.TextColor3 = theme.Text
			pilltext.TextSize = 10
			pilltext.ZIndex = 13

			local shield = instance.textbutton(container)
			shield.Name = "LockShield"
			shield.BackgroundTransparency = 1
			shield.Text = ""
			shield.Size = UDim2.new(1, 0, 1, 0)
			shield.ZIndex = 15
			shield.Active = true
			shield.AutoButtonColor = false

			shield.Activated:Connect(function()
				elevate()
				sv.ts:Create(lockstroke, TweenInfo.new(0.12), { Transparency = 0.4 }):Play()
				task.delay(0.18, function()
					elevate()
					if lockstroke and lockstroke.Parent then
						sv.ts:Create(lockstroke, TweenInfo.new(0.3), { Transparency = 0.85 }):Play()
					end
				end)
			end)

			overlay = { shield, notice, pill, lockborder }
		end

		local lockfunc = {}

		function lockfunc:IsLocked()
			return locked
		end

		function lockfunc:Lock(silent)
			if locked or not container.Parent then
				return
			end
			locked = true
			elevate()
			if lockopts.OnLock then
				local ok, err = pcall(lockopts.OnLock, silent == true)
				if not ok then
					warn("[SENA] lock error:", err)
				end
			end
			baseheight = lockopts.GetBaseHeight and lockopts.GetBaseHeight() or container.Size.Y.Offset
			basetransparency = container.BackgroundTransparency
			dimmed = {}
			for _, control in ipairs(controls) do
				if control then
					dim(control)
					for _, child in ipairs(control:GetDescendants()) do
						dim(child)
					end
				end
			end
			container.Size = UDim2.new(1, 0, 0, baseheight + lockextra)
			buildoverlay()
			if lockopts.Pin then
				pcall(lockopts.Pin, true)
			end
		end

		function lockfunc:Unlock()
			if not locked then
				return
			end
			locked = false
			elevate()
			for _, obj in ipairs(overlay) do
				pcall(function()
					obj:Destroy()
				end)
			end
			overlay = {}
			for _, d in ipairs(dimmed) do
				pcall(function()
					d[1][d[2]] = d[3]
				end)
			end
			dimmed = {}
			container.BackgroundTransparency = basetransparency
			if lockopts.GetBaseHeight then
				baseheight = lockopts.GetBaseHeight()
			end
			container.Size = UDim2.new(1, 0, 0, baseheight)
			if lockopts.Pin then
				pcall(lockopts.Pin, false)
			end
			if lockopts.OnUnlock then
				local ok, err = pcall(lockopts.OnUnlock)
				if not ok then
					warn("[SENA] unlock error:", err)
				end
			end
		end

		-- The element's own height changed while locked (its description wrapped
		-- differently): move the notice/pill and keep the extra lock strip.
		function lockfunc:Relayout()
			if not locked then
				return
			end
			if lockopts.GetBaseHeight then
				baseheight = lockopts.GetBaseHeight()
			end
			container.Size = UDim2.new(1, 0, 0, baseheight + lockextra)
			local notice, pill = overlay[2], overlay[3]
			if notice and notice.Parent then
				notice.Position = UDim2.new(0, 10, 0, baseheight - 4)
			end
			if pill and pill.Parent then
				pill.Position = UDim2.new(1, -10, 0, baseheight - 4)
			end
			if lockopts.Pin then
				pcall(lockopts.Pin, true)
			end
		end

		lockfunc.Dead = function()
			return container.Parent == nil
		end

		lockfunc.DonatorOnly = donatoronly
		table.insert(Chloex.LockRegistry, lockfunc)
		if startlocked then
			lockfunc:Lock(true)
		end
		return lockfunc
	end

	local hasActiveTab = false

	function tabs:AddTab(tabconfig)
		tabconfig = tabconfig or {}
		tabconfig.Name = tabconfig.Name or "Tab"

		local tabIndex = counttab
		local layoutOrder = tonumber(tabconfig.LayoutOrder) or tabIndex
		local isFirstTab = not hasActiveTab and tabconfig.StartActive ~= false
		if isFirstTab then
			hasActiveTab = true
		end

		local scrollayers = instance.scrollingframe(layersfolder)
		scrollayers.Name = "ScrolLayers"
		scrollayers.ScrollBarImageColor3 = theme.Track
		scrollayers.ScrollBarThickness = 0
		scrollayers.Active = true
		scrollayers.LayoutOrder = layoutOrder
		scrollayers.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		scrollayers.BackgroundTransparency = 1
		scrollayers.BorderColor3 = Color3.fromRGB(0, 0, 0)
		scrollayers.BorderSizePixel = 0
		scrollayers.Size = UDim2.new(1, 0, 1, 0)

		local uilistlayout1 = instance.uilistlayout(scrollayers)
		uilistlayout1.Padding = UDim.new(0, 3)
		uilistlayout1.SortOrder = Enum.SortOrder.LayoutOrder

		local function updatesizescroll()
			scrollayers.CanvasSize = UDim2.new(0, 0, 0, uilistlayout1.AbsoluteContentSize.Y)
		end

		uilistlayout1:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updatesizescroll)

		local tab = instance.frame(scrolltab)
		tab.Name = "Tab"
		tab.BorderSizePixel = 0
		tab.LayoutOrder = layoutOrder
		tab.Size = UDim2.new(1, -6, 0, 28)
		local tabbg = roundbg(tab, 4, theme.TabActive)
		tabbg.ImageTransparency = isFirstTab and 0 or 1

		local tabbutton = instance.textbutton(tab)
		tabbutton.Name = "TabButton"
		tabbutton.Font = Enum.Font.GothamBold
		tabbutton.Text = ""
		tabbutton.TextColor3 = Color3.fromRGB(255, 255, 255)
		tabbutton.TextSize = 13
		tabbutton.TextXAlignment = Enum.TextXAlignment.Left
		tabbutton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		tabbutton.BackgroundTransparency = 1
		tabbutton.BorderColor3 = Color3.fromRGB(0, 0, 0)
		tabbutton.BorderSizePixel = 0
		tabbutton.Size = UDim2.new(1, 0, 1, 0)

		local onOpenCallback
		local onOpenRan = false

		local function runOnOpen()
			if onOpenRan or not onOpenCallback then
				return
			end

			onOpenRan = true
			local ok, err = pcall(onOpenCallback)
			if not ok then
				warn("Tab OnOpen error:", err)
			end
		end

		local tabname = instance.textlabel(tab)
		tabname.Name = "TabName"
		tabname.Font = Enum.Font.GothamBold
		tabname.Text = tostring(tabconfig.Name)
		tabname.TextColor3 = Color3.fromRGB(255, 255, 255)
		tabname.TextSize = 13
		tabname.TextXAlignment = Enum.TextXAlignment.Left
		tabname.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		tabname.BackgroundTransparency = 1
		tabname.BorderColor3 = Color3.fromRGB(0, 0, 0)
		tabname.BorderSizePixel = 0

		local hasicon = tabconfig.Icon ~= nil and tabconfig.Icon ~= ""
		local tabicon
		if hasicon then
			tabicon = instance.imagelabel(tab)
			tabicon.Name = "TabIcon"
			tabicon.AnchorPoint = Vector2.new(0, 0.5)
			tabicon.Position = UDim2.new(0, 8, 0.5, 0)
			tabicon.Size = UDim2.new(0, 14, 0, 14)
			tabicon.BackgroundTransparency = 1
			tabicon.ImageColor3 = isFirstTab and theme.Text or theme.SubText
			applyicon(tabicon, tabconfig.Icon, 48)
		end

		tabname.TextColor3 = isFirstTab and theme.Text or theme.SubText
		tabname.Size = UDim2.new(1, -(hasicon and 28 or 10), 1, 0)
		tabname.Position = UDim2.new(0, hasicon and 26 or 8, 0, 0)

		if isFirstTab then
			layerspagelayout:JumpTo(scrollayers)
			local chooseframe = instance.frame(tab)
			chooseframe.Name = "ChooseFrame"
			chooseframe.BackgroundColor3 = theme.Text
			chooseframe.BorderColor3 = Color3.fromRGB(0, 0, 0)
			chooseframe.BorderSizePixel = 0
			chooseframe.Position = UDim2.new(0, 2, 0, 8)
			chooseframe.Size = UDim2.new(0, 1, 0, 12)

			local uistroke2 = instance.uistroke(chooseframe)
			uistroke2.Color = theme.Text
			uistroke2.Thickness = 1.6

			instance.uicorner(chooseframe)
		end

		tabbutton.Activated:Connect(function()
			if layerspagelayout.CurrentPage == scrollayers then
				runOnOpen()
				return
			end

			local framechoose
			for _, tabframe in ipairs(scrolltab:GetChildren()) do
				if tabframe.Name == "Tab" then
					local cf = tabframe:FindFirstChild("ChooseFrame")
					if cf then
						framechoose = cf
					end
					local tb = tabframe:FindFirstChild("Bg")
					if tb then
						tb.ImageTransparency = 1
					end
					local tn = tabframe:FindFirstChild("TabName")
					if tn then
						tn.TextColor3 = theme.SubText
					end
					local ti = tabframe:FindFirstChild("TabIcon")
					if ti then
						ti.ImageColor3 = theme.SubText
					end
				end
			end

			if not framechoose then
				return
			end

			tabbg.ImageTransparency = 0
			tabname.TextColor3 = theme.Text
			if tabicon then
				tabicon.ImageColor3 = theme.Text
			end

			framechoose.Parent = tab
			framechoose.Position = UDim2.new(0, 2, 0, 8)
			framechoose.Size = UDim2.new(0, 1, 0, 12)

			layerspagelayout:JumpTo(scrollayers)
			runOnOpen()

			if searchbox.Text ~= "" then
				runsearch()
			end
		end)

		local sections = {}
		local countsection = 0

		function sections:OnOpen(callback)
			onOpenCallback = callback
			if isFirstTab then
				runOnOpen()
			end
			return self
		end

		function sections:AddSection(sectiontitletext, alwaysopen)
			sectiontitletext = sectiontitletext or "Title"

			local section = instance.frame(scrollayers)
			section.Name = "Section"
			section.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			section.BackgroundTransparency = 1
			section.BorderSizePixel = 0
			section.LayoutOrder = countsection
			section.ClipsDescendants = true
			section.Size = UDim2.new(1, 0, 0, 30)

			local sectionreal = instance.frame(section)
			sectionreal.AnchorPoint = Vector2.new(0.5, 0)
			sectionreal.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			sectionreal.BackgroundTransparency = 1
			sectionreal.BorderSizePixel = 0
			sectionreal.Position = UDim2.new(0.5, 0, 0, 0)
			sectionreal.Size = UDim2.new(1, 1, 0, 30)

			local uicorner = instance.uicorner(sectionreal)
			uicorner.CornerRadius = UDim.new(0, 4)

			local sectionbutton = instance.textbutton(sectionreal)
			sectionbutton.Font = Enum.Font.SourceSans
			sectionbutton.Text = ""
			sectionbutton.BackgroundTransparency = 1
			sectionbutton.Size = UDim2.new(1, 0, 1, 0)

			local featureframe = instance.frame(sectionreal)
			featureframe.AnchorPoint = Vector2.new(1, 0.5)
			featureframe.BackgroundTransparency = 1
			featureframe.Position = UDim2.new(1, -5, 0.5, 0)
			featureframe.Size = UDim2.new(0, 20, 0, 20)

			local featureimg = instance.imagelabel(featureframe)
			featureimg.Image = "rbxassetid://16851841101"
			featureimg.AnchorPoint = Vector2.new(0.5, 0.5)
			featureimg.BackgroundTransparency = 1
			featureimg.Position = UDim2.new(0.5, 0, 0.5, 0)
			featureimg.Rotation = -90
			featureimg.Size = UDim2.new(1, 6, 1, 6)

			local sectiontitle = instance.textlabel(sectionreal)
			sectiontitle.Font = Enum.Font.GothamBold
			sectiontitle.Text = sectiontitletext
			sectiontitle.TextColor3 = theme.Text
			sectiontitle.TextSize = 13
			sectiontitle.TextXAlignment = Enum.TextXAlignment.Left
			sectiontitle.AnchorPoint = Vector2.new(0, 0.5)
			sectiontitle.BackgroundTransparency = 1
			sectiontitle.Position = UDim2.new(0, 10, 0.5, 0)
			sectiontitle.Size = UDim2.new(1, -50, 0, 13)

			local sectionadd = instance.frame(section)
			sectionadd.AnchorPoint = Vector2.new(0.5, 0)
			sectionadd.BackgroundTransparency = 1
			sectionadd.BorderSizePixel = 0
			sectionadd.ClipsDescendants = true
			sectionadd.Position = UDim2.new(0.5, 0, 0, 30)
			sectionadd.Size = UDim2.new(1, 0, 0, 0)

			local uicorner8 = instance.uicorner(sectionadd)
			uicorner8.CornerRadius = UDim.new(0, 2)

			local uilistlayout2 = instance.uilistlayout(sectionadd)
			uilistlayout2.Padding = UDim.new(0, 3)
			uilistlayout2.SortOrder = Enum.SortOrder.LayoutOrder

			local color_normal = theme.Text
			local color_open = theme.Text

			local opensection = false
			local sectionResizeQueued = false

			local function updatesizesection(animate)
				if not opensection then
					return
				end

				local contentHeight = math.max(0, uilistlayout2.AbsoluteContentSize.Y)
				local sectionsizey = 30 + contentHeight
				sectiontitle.TextColor3 = color_open

				if animate and featureframe.Parent then
					sv.ts:Create(featureframe, TweenInfo.new(0.3), { Rotation = 90 }):Play()
					sv.ts:Create(section, TweenInfo.new(0.3), { Size = UDim2.new(1, 0, 0, sectionsizey) }):Play()
					sv.ts:Create(sectionadd, TweenInfo.new(0.3), { Size = UDim2.new(1, 0, 0, contentHeight) }):Play()
				else
					if featureframe.Parent then
						featureframe.Rotation = 90
					end
					section.Size = UDim2.new(1, 0, 0, sectionsizey)
					sectionadd.Size = UDim2.new(1, 0, 0, contentHeight)
				end

				updatesizescroll()
			end

			local function queueSectionResize()
				if sectionResizeQueued then
					return
				end

				sectionResizeQueued = true
				task.defer(function()
					sectionResizeQueued = false
					updatesizesection(false)
				end)
			end

			local function closesection(animate)
				if not opensection then
					return
				end
				opensection = false
				sectiontitle.TextColor3 = color_normal
				if animate then
					sv.ts:Create(featureframe, TweenInfo.new(0.3), { Rotation = 0 }):Play()
					sv.ts:Create(section, TweenInfo.new(0.3), { Size = UDim2.new(1, 0, 0, 30) }):Play()
					sv.ts:Create(sectionadd, TweenInfo.new(0.3), { Size = UDim2.new(1, 0, 0, 0) }):Play()
				else
					featureframe.Rotation = 0
					section.Size = UDim2.new(1, 0, 0, 30)
					sectionadd.Size = UDim2.new(1, 0, 0, 0)
				end
			end

			sectionbutton.Activated:Connect(function()
				if opensection then
					closesection(true)
				else
					opensection = true
					updatesizesection(true)
				end
			end)

			if alwaysopen then
				opensection = true
				updatesizesection(false)
			end

			uilistlayout2:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(queueSectionResize)

			local items = {}
			local countitem = 0
			local currentSubSection = nil
			local buildStartTime = 0
			local frameThreshold = 0.012
			local function yieldbuild()
				if buildStartTime == 0 then
					buildStartTime = tick()
				end
				if (tick() - buildStartTime) > frameThreshold then
					task.wait()
					buildStartTime = tick()
				end
			end

			local function registerSearchItem(title, object)
				title = tostring(title or "Item")

				local path = tabconfig.Name .. "/" .. sectiontitletext
				if currentSubSection then
					path = path .. "/" .. currentSubSection
				end
				path = path .. "/" .. title

				table.insert(searchItems, {
					Name = title,
					Path = path,
					TabIndex = scrollayers.LayoutOrder,
					Page = scrollayers,
					Section = section,
					Object = object,
					IsOpen = function()
						return opensection
					end,
					OpenSection = function()
						if not opensection then
							opensection = true
							updatesizesection()
						end
					end,
					CloseSection = function()
						closesection(false)
					end,
				})
			end

			function items:AddParagraph(paragraphconfig)
				paragraphconfig = paragraphconfig or {}
				paragraphconfig.Title = paragraphconfig.Title or "Title"
				paragraphconfig.Content = paragraphconfig.Content or "Content"
				local paragraphfunc = {}

				local paragraph = instance.frame(sectionadd)
				paragraph.Name = "Paragraph"
				paragraph.BorderSizePixel = 0
				paragraph.LayoutOrder = countitem
				paragraph.Size = UDim2.new(1, 0, 0, 46)
				roundbg(paragraph, 4, theme.Row)

				local iconoffset = 10
				if paragraphconfig.Icon then
					local iconimg = instance.imagelabel(paragraph)
					iconimg.Name = "ParagraphIcon"
					iconimg.Size = UDim2.new(0, 20, 0, 20)
					iconimg.Position = UDim2.new(0, 8, 0, 12)
					iconimg.BackgroundTransparency = 1

					-- Lucide name ("info", "crown") or an asset id, same as tab icons
					applyicon(iconimg, paragraphconfig.Icon, 48)

					iconoffset = 30
				end

				local paragraphtitle = instance.textlabel(paragraph)
				paragraphtitle.Name = "ParagraphTitle"
				paragraphtitle.Font = Enum.Font.GothamBold
				paragraphtitle.Text = paragraphconfig.Title
				paragraphtitle.TextColor3 = theme.Text
				paragraphtitle.TextSize = 13
				paragraphtitle.TextXAlignment = Enum.TextXAlignment.Left
				paragraphtitle.TextYAlignment = Enum.TextYAlignment.Top
				paragraphtitle.BackgroundTransparency = 1
				paragraphtitle.Position = UDim2.new(0, iconoffset, 0, 10)
				paragraphtitle.Size = UDim2.new(1, -16, 0, 13)

				local paragraphcontent = instance.textlabel(paragraph)
				paragraphcontent.Name = "ParagraphContent"
				paragraphcontent.Font = Enum.Font.GothamBold
				paragraphcontent.Text = paragraphconfig.Content
				paragraphcontent.TextColor3 = Color3.fromRGB(255, 255, 255)
				paragraphcontent.TextSize = 12
				paragraphcontent.TextXAlignment = Enum.TextXAlignment.Left
				paragraphcontent.TextYAlignment = Enum.TextYAlignment.Top
				paragraphcontent.BackgroundTransparency = 1
				paragraphcontent.Position = UDim2.new(0, iconoffset, 0, 25)
				paragraphcontent.TextWrapped = true
				paragraphcontent.RichText = true
				paragraphcontent.Size = UDim2.new(1, -16, 0, 0)

				local paragraphbutton
				if paragraphconfig.ButtonText then
					paragraphbutton = instance.textbutton(paragraph)
					paragraphbutton.Position = UDim2.new(0, 10, 0, 42)
					paragraphbutton.Size = UDim2.new(1, -22, 0, 28)
					paragraphbutton.Font = Enum.Font.GothamBold
					paragraphbutton.TextSize = 12
					paragraphbutton.TextTransparency = 0.3
					paragraphbutton.TextColor3 = Color3.fromRGB(255, 255, 255)
					paragraphbutton.Text = paragraphconfig.ButtonText

					hoverbg(paragraphbutton, roundbg(paragraphbutton, 6, theme.Inner), theme.Inner, theme.InnerHover)

					if paragraphconfig.ButtonCallback then
						paragraphbutton.MouseButton1Click:Connect(paragraphconfig.ButtonCallback)
					end
				end

				local function updatesize()
					local totalheight = paragraphcontent.TextBounds.Y + 33
					if paragraphbutton then
						totalheight = totalheight + paragraphbutton.Size.Y.Offset + 5
					end
					paragraph.Size = UDim2.new(1, 0, 0, totalheight)
				end

				task.defer(updatesize)
				paragraphcontent:GetPropertyChangedSignal("TextBounds"):Connect(updatesize)

				function paragraphfunc:SetContent(content)
					content = content or "Content"
					paragraphcontent.Text = content
					updatesize()
				end

				registerSearchItem(paragraphconfig.Title, paragraph)
				countitem = countitem + 1
				yieldbuild()
				return paragraphfunc
			end

			function items:AddPanel(panelconfig)
				panelconfig = panelconfig or {}

				local panels = {
					Chloe = {
						Image = "rbxassetid://139546726059566",
						AspectRatio = 3.56,
					},
					UgPhone = {
						Image = "rbxassetid://95132907847500",
						AspectRatio = 3.56,
					},
					ChloeStore = {
						Image = "rbxassetid://78353987171005",
						AspectRatio = 3.56,
					},
				}

				local paneldata = panels[panelconfig.Type] or panels.Chloe
				local aspectRatio = tonumber(panelconfig.AspectRatio) or paneldata.AspectRatio

				local panel = instance.imagelabel(sectionadd)
				panel.Name = "Panel"
				panel.BackgroundTransparency = 1
				panel.BorderSizePixel = 0
				panel.Image = panelconfig.Image or paneldata.Image
				panel.ScaleType = Enum.ScaleType.Fit
				panel.Size = UDim2.new(1, 0, 0, 160)
				panel.LayoutOrder = countitem
				panel.ClipsDescendants = true
				panel.ZIndex = 1

				instance.uicorner(panel).CornerRadius = UDim.new(0, tonumber(panelconfig.CornerRadius) or 10)

				local lastWidth = -1
				local resizeQueued = false

				local function updatePanelSize()
					resizeQueued = false

					if not panel or not panel.Parent then
						return
					end

					local width = math.floor(panel.AbsoluteSize.X + 0.5)

					if width <= 1 then
						width = math.floor(sectionadd.AbsoluteSize.X + 0.5)
					end

					if width <= 1 or width == lastWidth then
						return
					end

					lastWidth = width

					local height = math.max(1, math.floor((width / aspectRatio) + 0.5))

					panel.Size = UDim2.new(1, 0, 0, height)
				end

				local function queuePanelResize()
					if resizeQueued then
						return
					end

					resizeQueued = true
					task.defer(updatePanelSize)
				end

				trackConnection(
					sectionadd:GetPropertyChangedSignal("AbsoluteSize"):Connect(queuePanelResize),
					"panel.adaptive.resize"
				)

				task.defer(queuePanelResize)

				countitem = countitem + 1
				yieldbuild()

				return panel
			end

			-- Value model shared by Toggle / Slider / Input / Dropdown:
			--   .Value        what the hub sees (callbacks get exactly this)
			--   config.data   what the player saved; kept while the element is
			--                 donator-locked, so a renewed key brings it back
			--   DefaultValue  the hub's own Default; a locked element sits on it
			-- A locked element never applies a saved value and never fires its
			-- callback with one.

			function items:AddActionList(listconfig)
				listconfig = listconfig or {}
				listconfig.Title = listconfig.Title or "List"
				local emptytext = tostring(listconfig.EmptyText or "Nothing here yet.")
				local visiblerows = math.max(1, tonumber(listconfig.VisibleRows) or 5)
				local buttonwidth = math.max(44, tonumber(listconfig.ButtonWidth) or 74)
				local rowheight = math.max(34, tonumber(listconfig.RowHeight) or 46)
				local rowgap = 4
				local listfunc = {}
				local rows = {}
				local alive = true
				
				local container = instance.frame(sectionadd)
				container.Name = "ActionList"
				container.BorderSizePixel = 0
				container.LayoutOrder = countitem
				container.Size = UDim2.new(1, 0, 0, 62)
				roundbg(container, 4, theme.Row)
				
				local header = instance.textlabel(container)
				header.Name = "ActionListTitle"
				header.Font = Enum.Font.GothamBold
				header.Text = tostring(listconfig.Title)
				header.TextColor3 = theme.Text
				header.TextSize = 13
				header.TextXAlignment = Enum.TextXAlignment.Left
				header.BackgroundTransparency = 1
				header.Position = UDim2.new(0, 10, 0, 9)
				header.Size = UDim2.new(1, -80, 0, 14)
				
				local counter = instance.textlabel(container)
				counter.Name = "ActionListCount"
				counter.Font = Enum.Font.GothamBold
				counter.Text = "0"
				counter.TextColor3 = theme.SubText
				counter.TextSize = 12
				counter.TextXAlignment = Enum.TextXAlignment.Right
				counter.BackgroundTransparency = 1
				counter.AnchorPoint = Vector2.new(1, 0)
				counter.Position = UDim2.new(1, -10, 0, 9)
				counter.Size = UDim2.new(0, 60, 0, 14)
				
				local scroll = instance.scrollingframe(container)
				scroll.Name = "ActionListRows"
				scroll.BackgroundTransparency = 1
				scroll.BorderSizePixel = 0
				scroll.Position = UDim2.new(0, 6, 0, 29)
				scroll.Size = UDim2.new(1, -12, 1, -35)
				scroll.ScrollBarThickness = 3
				scroll.ScrollBarImageColor3 = theme.Bar
				scroll.ScrollingDirection = Enum.ScrollingDirection.Y
				scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
				scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
				
				local layout = instance.uilistlayout(scroll)
				layout.FillDirection = Enum.FillDirection.Vertical
				layout.SortOrder = Enum.SortOrder.LayoutOrder
				layout.Padding = UDim.new(0, rowgap)
				
				local empty = instance.textlabel(scroll)
				empty.Name = "ActionListEmpty"
				empty.Font = Enum.Font.GothamBold
				empty.Text = emptytext
				empty.TextColor3 = theme.Dim
				empty.TextSize = 12
				empty.TextXAlignment = Enum.TextXAlignment.Left
				empty.BackgroundTransparency = 1
				empty.LayoutOrder = 0
				empty.Size = UDim2.new(1, -6, 0, 24)
				
				local function resize(count)
					local shown = math.min(math.max(count, 1), visiblerows)
					local body = shown * rowheight + math.max(shown - 1, 0) * rowgap
					container.Size = UDim2.new(1, 0, 0, 35 + body + 6)
				end
				
				local function tintof(name)
					if name == "green" then return theme.Good end
					if name == "red" then return theme.Bad end
					if name == "gold" then return theme.Gold end
					if name == "dim" then return theme.Inner end
					return theme.Accent
				end
				
				local function textof(name)
					if name == "dim" then return Color3.fromRGB(255, 255, 255) end
					if name == "green" or name == "red" or name == "gold" then return theme.AccentText end
					return theme.AccentText
				end
				
				local function buildrow(index)
					elevate()
					local row = instance.frame(scroll)
					row.Name = "ActionRow"
					row.BorderSizePixel = 0
					row.LayoutOrder = index
					row.Size = UDim2.new(1, -6, 0, rowheight)
					roundbg(row, 4, theme.Element)
					
					local name = instance.textlabel(row)
					name.Name = "RowName"
					name.Font = Enum.Font.GothamBold
					name.TextColor3 = theme.Text
					name.TextSize = 12
					name.RichText = true
					name.TextTruncate = Enum.TextTruncate.AtEnd
					name.TextXAlignment = Enum.TextXAlignment.Left
					name.BackgroundTransparency = 1
					name.Position = UDim2.new(0, 9, 0, 6)
					name.Size = UDim2.new(0.42, -12, 0, 14)
					
					local sub = instance.textlabel(row)
					sub.Name = "RowSub"
					sub.Font = Enum.Font.Gotham
					sub.TextColor3 = theme.SubText
					sub.TextSize = 11
					sub.RichText = true
					sub.TextTruncate = Enum.TextTruncate.AtEnd
					sub.TextXAlignment = Enum.TextXAlignment.Left
					sub.BackgroundTransparency = 1
					sub.Position = UDim2.new(0, 9, 0, 23)
					sub.Size = UDim2.new(0.42, -12, 0, 14)
					
					local status = instance.textlabel(row)
					status.Name = "RowStatus"
					status.Font = Enum.Font.GothamBold
					status.TextColor3 = theme.Text
					status.TextSize = 12
					status.RichText = true
					status.TextTruncate = Enum.TextTruncate.AtEnd
					status.TextXAlignment = Enum.TextXAlignment.Left
					status.BackgroundTransparency = 1
					status.Position = UDim2.new(0.44, 0, 0, 6)
					status.Size = UDim2.new(0.56, -buttonwidth - 14, 0, 14)
					
					local statussub = instance.textlabel(row)
					statussub.Name = "RowStatusSub"
					statussub.Font = Enum.Font.Gotham
					statussub.TextColor3 = theme.Dim
					statussub.TextSize = 11
					statussub.RichText = true
					statussub.TextTruncate = Enum.TextTruncate.AtEnd
					statussub.TextXAlignment = Enum.TextXAlignment.Left
					statussub.BackgroundTransparency = 1
					statussub.Position = UDim2.new(0.44, 0, 0, 23)
					statussub.Size = UDim2.new(0.56, -buttonwidth - 14, 0, 14)
					
					local action = instance.textbutton(row)
					action.Name = "RowAction"
					action.Font = Enum.Font.GothamBold
					action.TextSize = 12
					action.AutoButtonColor = false
					action.Text = "Go"
					action.TextColor3 = theme.AccentText
					action.AnchorPoint = Vector2.new(1, 0.5)
					action.Position = UDim2.new(1, -8, 0.5, 0)
					action.Size = UDim2.new(0, buttonwidth, 0, 26)
					local actionbg = roundbg(action, 6, theme.Accent)
					
					local record = {
						frame = row,
						name = name,
						sub = sub,
						status = status,
						statussub = statussub,
						action = action,
						bg = actionbg,
						entry = nil,
					}
					
					function record.setlabel(text, tint)
						elevate()
						action.Text = tostring(text or "Go")
						actionbg.ImageColor3 = tintof(tint)
						action.TextColor3 = textof(tint)
					end
					
					action.MouseButton1Down:Connect(function()
						pcall(pesseffect, action)
					end)
					action.MouseButton1Click:Connect(function()
						elevate()
						local entry = record.entry
						if not entry or type(entry.onClick) ~= "function" then return end
						local ok, err = pcall(entry.onClick, entry, record.setlabel)
						if not ok then
							warn("ActionList Callback error (" .. tostring(listconfig.Title) .. "):", err)
						end
					end)
					
					return record
				end
				
				function listfunc:Update(entries)
					elevate()
					if not alive then return end
					entries = type(entries) == "table" and entries or {}
					for index, entry in ipairs(entries) do
						local row = rows[index]
						if not row then
							row = buildrow(index)
							rows[index] = row
						end
						row.entry = entry
						row.name.Text = tostring(entry.name or "")
						row.sub.Text = tostring(entry.sub or "")
						row.status.Text = tostring(entry.status or "")
						row.statussub.Text = tostring(entry.statusSub or "")
						row.setlabel(entry.button or "Go", entry.buttonColor)
						row.action.Visible = entry.button ~= false
						row.frame.Visible = true
					end
					for index = #entries + 1, #rows do
						rows[index].entry = nil
						rows[index].frame.Visible = false
					end
					empty.Visible = #entries == 0
					counter.Text = tostring(#entries)
					resize(#entries)
				end
				
				function listfunc:Clear()
					elevate()
					self:Update({})
				end
				
				function listfunc:Alive()
					elevate()
					return alive and container.Parent ~= nil
				end
				
				function listfunc:Destroy()
					elevate()
					alive = false
					pcall(function() container:Destroy() end)
				end
				
				resize(0)
				registerSearchItem(tostring(listconfig.Title), container)
				countitem = countitem + 1
				yieldbuild()
				return listfunc
			end

			function items:AddFusePartner(itemCfg)
				itemCfg = itemCfg or {}
				local tiers = itemCfg.Tiers or { "Divine", "Eternal" }
				local getPets = itemCfg.Pets or function() return {} end
				local onBroadcast = itemCfg.OnBroadcast or function() end
				local onStop = itemCfg.OnStop or function() end
				
				local st = {
					tier = tiers[1],
					auto = itemCfg.AutoSelect ~= false,
					petLabel = "",
					isBroadcasting = false,
					pets = {},
				}

				local TierDrop = items:AddDropdown({
					Title = "Tier",
					Content = "Divine = ArchAngel + World Burner. Eternal = Pegasus + Skeleton Horse.",
					Options = tiers,
					Default = tiers[1],
					Callback = function(v)
						st.tier = (type(v) == "table") and (v[1] or tiers[1]) or tostring(v or tiers[1])
						if st.RefreshPets then st.RefreshPets() end
					end,
				})

				local PetDrop = items:AddDropdown({
					Title = "Your Pet",
					Content = "Recipe pets you own for this tier. The pet decides your pad side.",
					Options = {},
					Default = "",
					Callback = function(v)
						st.petLabel = (type(v) == "table") and (v[1] or "") or tostring(v or "")
					end,
				})

				items:AddToggle({
					Title = "Auto Select",
					Content = "Use the first recipe pet found in your inventory.",
					Default = st.auto,
					Callback = function(v) st.auto = v and true or false end,
				})

				local Status = items:AddParagraph({
					Title = "Status",
					Content = "Not broadcasting.",
				})

				local function SetStatus(text)
					pcall(function()
						if Status and Status.Set then
							Status:Set({ Content = tostring(text or "") })
						end
					end)
				end

				function st.RefreshPets()
					local ok, list = pcall(getPets, st.tier)
					if not ok or type(list) ~= "table" then list = {} end
					st.pets = {}
					local labels = {}
					for _, pet in ipairs(list) do
						local label = tostring(pet.Label or (tostring(pet.Category or "Pet") .. " (" .. tostring(pet.Side or "Pad") .. ")"))
						if not st.pets[label] then
							st.pets[label] = pet
							labels[#labels + 1] = label
						end
					end
					pcall(function()
						if PetDrop and PetDrop.Refresh then
							PetDrop:Refresh(labels, true)
						end
					end)
					if #labels == 0 then
						st.petLabel = ""
					elseif st.petLabel == "" or not st.pets[st.petLabel] then
						st.petLabel = labels[1]
						pcall(function()
							if PetDrop and PetDrop.Set then PetDrop:Set(labels[1]) end
						end)
					end
					return labels
				end

				local BroadcastBtn
				local function SetBroadcastLabel(active)
					st.isBroadcasting = active == true
					pcall(function()
						if BroadcastBtn and BroadcastBtn.Set then
							BroadcastBtn:Set({ Title = active and "Stop Broadcast" or "Broadcast: Find Partner" })
						end
					end)
				end

				BroadcastBtn = items:AddButton({
					Title = "Broadcast: Find Partner",
					Content = "Tell other players you are waiting at the shrine. Only works if you own the recipe pet.",
					Callback = function()
						if st.isBroadcasting then
							pcall(onStop, st)
							SetBroadcastLabel(false)
						else
							pcall(onBroadcast, st)
							SetBroadcastLabel(true)
						end
					end,
				})

				task.defer(function() pcall(st.RefreshPets) end)

				local funcs = {}
				function funcs:SetStatus(text) SetStatus(text) end
				function funcs:Refresh() return st.RefreshPets() end
				function funcs:SetBroadcasting(active) SetBroadcastLabel(active) end
				function funcs:GetState() return st end
				return funcs
			end

			function items:AddFuseList(itemCfg)
				itemCfg = itemCfg or {}
				local list = items:AddActionList({
					Title = itemCfg.Title or "Players looking for a partner",
					EmptyText = itemCfg.EmptyText or "Nobody is broadcasting right now.",
					VisibleRows = itemCfg.VisibleRows or 5,
					ButtonWidth = itemCfg.ButtonWidth or 70,
					RowHeight = itemCfg.RowHeight or 46,
				})
				return list
			end

			function items:AddButton(buttonconfig)
				buttonconfig = buttonconfig or {}
				buttonconfig.Title = buttonconfig.Title or "Confirm"
				buttonconfig.Callback = buttonconfig.Callback or function() end
				buttonconfig.SubTitle = buttonconfig.SubTitle or nil
				buttonconfig.SubCallback = buttonconfig.SubCallback or function() end
				local lockable = isdonatorelement(buttonconfig)
				local donatoronly = isdonatoronly(buttonconfig)
				local islocked = lockable and not tierallows(donatoronly)

				local function runcallback(fn, label)
					if islocked then
						return
					end
					elevate()
					if typeof(fn) == "function" then
						local ok, err = pcall(fn)
						if not ok then
							warn("Button Callback error (" .. tostring(label) .. "):", err)
						end
					end
				end

				local button = instance.frame(sectionadd)
				button.BorderSizePixel = 0
				button.Size = UDim2.new(1, 0, 0, 40)
				button.LayoutOrder = countitem
				roundbg(button, 4, theme.Row)

				local padding = 3
				local gap = 4

				local mainbutton = instance.textbutton(button)
				mainbutton.Font = Enum.Font.GothamBold
				mainbutton.Text = tostring(buttonconfig.Title)
				mainbutton.TextSize = 12
				mainbutton.TextColor3 = Color3.fromRGB(255, 255, 255)
				mainbutton.TextTransparency = 0.3
				mainbutton.AutoButtonColor = false
				mainbutton.ZIndex = 10
				hoverbg(mainbutton, roundbg(mainbutton, 4, theme.Inner), theme.Inner, theme.InnerHover)

				if buttonconfig.SubTitle then
					mainbutton.Size = UDim2.new(0.5, -padding - gap, 1, -10)
					mainbutton.Position = UDim2.new(0, padding, 0, 5)
				else
					mainbutton.Size = UDim2.new(1, -padding * 2, 1, -10)
					mainbutton.Position = UDim2.new(0, padding, 0, 5)
				end

				mainbutton.MouseButton1Down:Connect(function()
					pcall(pesseffect, mainbutton)
				end)

				mainbutton.MouseButton1Click:Connect(function()
					runcallback(buttonconfig.Callback, buttonconfig.Title)
				end)

				local buttons = { mainbutton }

				if buttonconfig.SubTitle then
					local subbutton = instance.textbutton(button)
					subbutton.Font = Enum.Font.GothamBold
					subbutton.Text = tostring(buttonconfig.SubTitle)
					subbutton.TextSize = 12
					subbutton.TextTransparency = 0.3
					subbutton.TextColor3 = Color3.fromRGB(255, 255, 255)
					subbutton.Size = UDim2.new(0.5, -padding - gap, 1, -10)
					subbutton.Position = UDim2.new(0.5, gap, 0, 5)
					subbutton.AutoButtonColor = false
					subbutton.ZIndex = 10
					hoverbg(subbutton, roundbg(subbutton, 4, theme.Inner), theme.Inner, theme.InnerHover)

					subbutton.MouseButton1Down:Connect(function()
						pcall(pesseffect, subbutton)
					end)

					subbutton.MouseButton1Click:Connect(function()
						runcallback(buttonconfig.SubCallback, buttonconfig.SubTitle)
					end)
					buttons[#buttons + 1] = subbutton
				end

				if lockable then
					makelock(button, buttons, {
						DonatorOnly = donatoronly,
						Pin = function(state)
							for _, b in ipairs(buttons) do
								b.Size = state and UDim2.new(b.Size.X.Scale, b.Size.X.Offset, 0, 30)
									or UDim2.new(b.Size.X.Scale, b.Size.X.Offset, 1, -10)
							end
						end,
						OnLock = function()
							islocked = true
						end,
						OnUnlock = function()
							islocked = false
						end,
					}, islocked)
				end

				-- one search entry per row: two entries for the same row fought over
				-- its Visible and searching the SubTitle hid the whole row
				local searchname = tostring(buttonconfig.Title)
				if buttonconfig.SubTitle then
					searchname = searchname .. " / " .. tostring(buttonconfig.SubTitle)
				end
				registerSearchItem(searchname, button)
				countitem = countitem + 1
				yieldbuild()
			end

			function items:AddToggle(toggleconfig)
				toggleconfig = toggleconfig or {}
				toggleconfig.Title = toggleconfig.Title or "Title"
				toggleconfig.Callback = toggleconfig.Callback or function() end

				local configkey = keyfor("Toggle_", toggleconfig)
				local hubdefault = toggleconfig.Default and true or false
				local function savedpref()
					local v = config.data[configkey]
					if v ~= nil then
						return v == true
					end
					if config.loaded then
						return false
					end
					return hubdefault
				end

				local lockable = isdonatorelement(toggleconfig)
				local donatoronly = isdonatoronly(toggleconfig)
				local islocked = lockable and not tierallows(donatoronly)
				local togglefunc = { Value = false, DefaultValue = hubdefault }

				local toggle = templates.Toggle:Clone()
				toggle.LayoutOrder = countitem
				toggle.Parent = sectionadd

				local toggletitle = toggle.ToggleTitle
				toggletitle.Text = toggleconfig.Title

				local togglebutton = toggle.ToggleButton
				local featureframe2 = toggle.FeatureFrame
				local uistroke8 = featureframe2.UIStroke
				local togglecircle = featureframe2.ToggleCircle

				local lock = nil
				local basey = 46
				local description = contenttext(toggleconfig)
				if description then
					toggletitle.Position = UDim2.new(0, 10, 0, 9)
					local _, measure = attachcontent(toggle, description, 10, 26, 72)
					local function relayout()
						basey = math.max(46, 26 + measure() + 10)
						if lock and lock:IsLocked() then
							lock:Relayout()
						else
							toggle.Size = UDim2.new(1, 0, 0, basey)
						end
					end
					relayout()
					watchwidth(toggle, relayout)
				end

				local function render(value, instant)
					elevate()
					local titleColor = theme.Text
					local circleColor = value and theme.AccentText or theme.Text
					local circlePosition = value and UDim2.new(0, 21, 0, 2) or UDim2.new(0, 2, 0, 2)
					local strokeColor = value and guiconfig.Color or Color3.fromRGB(255, 255, 255)
					local strokeTransparency = value and 0 or 0.9
					local backgroundColor = value and guiconfig.Color or theme.Field
					local backgroundTransparency = 0

					if instant then
						toggletitle.TextColor3 = titleColor
						togglecircle.Position = circlePosition
						togglecircle.BackgroundColor3 = circleColor
						uistroke8.Color = strokeColor
						uistroke8.Transparency = strokeTransparency
						featureframe2.BackgroundColor3 = backgroundColor
						featureframe2.BackgroundTransparency = backgroundTransparency
					else
						sv.ts:Create(toggletitle, TweenInfo.new(0.2), { TextColor3 = titleColor }):Play()
						sv.ts
							:Create(togglecircle, TweenInfo.new(0.2), {
								Position = circlePosition,
								BackgroundColor3 = circleColor,
							})
							:Play()
						sv.ts
							:Create(uistroke8, TweenInfo.new(0.2), {
								Color = strokeColor,
								Transparency = strokeTransparency,
							})
							:Play()
						sv.ts
							:Create(featureframe2, TweenInfo.new(0.2), {
								BackgroundColor3 = backgroundColor,
								BackgroundTransparency = backgroundTransparency,
							})
							:Play()
					end
				end

				local function apply(value, instant, save, fire)
					elevate()
					togglefunc.Value = value
					if save then
						config.data[configkey] = value
					end
					if fire and typeof(toggleconfig.Callback) == "function" then
						elevate()
						local ok, err = pcall(toggleconfig.Callback, value)
						if not ok then
							warn("Toggle Callback error:", err)
						end
					end
					render(value, instant)
				end

				togglebutton.Activated:Connect(function()
					if islocked then
						return
					end
					togglefunc:Set(not togglefunc.Value)
				end)

				function togglefunc:Set(value, instant)
					if islocked then
						return
					end
					apply(value and true or false, instant, true, true)
				end

				function togglefunc:LoadValue(value)
					self:Set(value, true)
				end

				function togglefunc:ResetValue()
					self:Set(hubdefault)
				end

				function togglefunc:IsLocked()
					return islocked
				end

				if islocked then
					render(false, true)
				else
					apply(savedpref(), true, true, true)
				end

				if lockable then
					lock = makelock(toggle, { featureframe2 }, {
						DonatorOnly = donatoronly,
						GetBaseHeight = function()
							return basey
						end,
						Pin = function(state)
							featureframe2.Position = state and UDim2.new(1, -15, 0, basey / 2) or UDim2.new(1, -15, 0.5, 0)
						end,
						OnLock = function(silent)
							islocked = true
							if togglefunc.Value then
								apply(false, true, false, not silent)
							end
						end,
						OnUnlock = function()
							islocked = false
							apply(savedpref(), true, true, true)
						end,
					}, islocked)
				end

				countitem = countitem + 1
				yieldbuild()
				config.elements[configkey] = togglefunc
				registerSearchItem(toggleconfig.Title, toggle)
				return togglefunc
			end

			function items:AddSlider(sliderconfig)
				sliderconfig = sliderconfig or {}
				sliderconfig.Title = sliderconfig.Title or sliderconfig.Name or "Slider"
				sliderconfig.Increment = tonumber(sliderconfig.Increment) or 1
				sliderconfig.Min = tonumber(sliderconfig.Min) or 0
				sliderconfig.Max = tonumber(sliderconfig.Max) or 100
				sliderconfig.Default = tonumber(sliderconfig.Default) or sliderconfig.Min
				sliderconfig.Callback = sliderconfig.Callback or function() end

				local configkey = keyfor("Slider_", sliderconfig)

				local function getprecision(step)
					local s = tostring(step)
					if s:find("e") or s:find("E") then
						s = string.format("%.12f", step):gsub("0+$", ""):gsub("%.$", "")
					end

					local dot = s:find("%.")
					return dot and (#s - dot) or 0
				end

				local precision = tonumber(sliderconfig.Precision) or getprecision(sliderconfig.Increment)

				local function roundtoincrement(value)
					local step = sliderconfig.Increment
					return math.floor((value / step) + 0.5) * step
				end

				local function formatnumber(value)
					value = tonumber(string.format("%." .. precision .. "f", value)) or 0

					if precision > 0 then
						return string.format("%." .. precision .. "f", value):gsub("0+$", ""):gsub("%.$", "")
					end

					return tostring(math.floor(value + 0.5))
				end

				local function clampvalue(value)
					value = tonumber(value) or sliderconfig.Min
					value = math.clamp(value, sliderconfig.Min, sliderconfig.Max)
					value = roundtoincrement(value)
					value = math.clamp(value, sliderconfig.Min, sliderconfig.Max)
					value = tonumber(string.format("%." .. precision .. "f", value)) or sliderconfig.Min
					return value
				end

				local hubdefault = clampvalue(sliderconfig.Default)
				local haspref = config.data[configkey] ~= nil
				local function savedpref()
					local v = tonumber(config.data[configkey])
					return v and clampvalue(v) or hubdefault
				end

				local lockable = isdonatorelement(sliderconfig)
				local donatoronly = isdonatoronly(sliderconfig)
				local islocked = lockable and not tierallows(donatoronly)
				local sliderfunc = {
					Value = islocked and hubdefault or savedpref(),
					DefaultValue = hubdefault,
				}

				local slider = templates.Slider:Clone()
				slider.LayoutOrder = countitem
				slider.Parent = sectionadd

				local slidertitle = slider.SliderTitle
				slidertitle.Text = sliderconfig.Title

				local inputholder = slider.SliderInputHolder
				local textbox = inputholder.SliderInput

				local sliderframe = slider.SliderBar
				local sliderfill = sliderframe.SliderFill
				local slidercircle = sliderframe.SliderCircle
				local circlestroke = slidercircle.UIStroke
				local bubble = sliderframe.ValueBubble
				local bubbletext = bubble.BubbleText

				local lock = nil
				local basey = 58
				local description = contenttext(sliderconfig)
				if description then
					local _, measure = attachcontent(slider, description, 10, 31, 20)
					local function relayout()
						local bary = 31 + measure() + 8
						sliderframe.Position = UDim2.new(0, 10, 0, bary)
						basey = bary + 19
						if lock and lock:IsLocked() then
							lock:Relayout()
						else
							slider.Size = UDim2.new(1, 0, 0, basey)
						end
					end
					relayout()
					watchwidth(slider, relayout)
				end

				local dragging = false
				local setting = false

				local function getpercent(value)
					if sliderconfig.Max == sliderconfig.Min then
						return 0
					end

					return math.clamp((value - sliderconfig.Min) / (sliderconfig.Max - sliderconfig.Min), 0, 1)
				end

				local function updatebubble(percent, value)
					bubble.Position = UDim2.new(percent, 0, 0, -10)
					bubbletext.Text = tostring(value)
				end

				local function showbubble()
					bubble.Visible = true

					sv.ts
						:Create(slidercircle, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
							Size = UDim2.new(0, 14, 0, 14),
						})
						:Play()

					sv.ts
						:Create(bubble, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
							BackgroundTransparency = 0.15,
							Size = UDim2.new(0, 48, 0, 22),
						})
						:Play()
				end

				local function hidebubble()
					sv.ts
						:Create(slidercircle, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
							Size = UDim2.new(0, 12, 0, 12),
						})
						:Play()

					sv.ts
						:Create(bubble, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
							Size = UDim2.new(0, 48, 0, 22),
						})
						:Play()

					task.delay(0.15, function()
						if not dragging then
							bubble.Visible = false
						end
					end)
				end

				local function apply(value, fire, save)
					elevate()
					value = clampvalue(value)

					sliderfunc.Value = value
					if save then
						config.data[configkey] = value
					end

					local percent = getpercent(value)
					local formatted = formatnumber(value)

					setting = true
					textbox.Text = formatted
					setting = false

					updatebubble(percent, formatted)

					sv.ts
						:Create(sliderfill, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
							Size = UDim2.new(percent, 0, 1, 0),
						})
						:Play()

					sv.ts
						:Create(slidercircle, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
							Position = UDim2.new(percent, 0, 0.5, 0),
						})
						:Play()

					if fire and typeof(sliderconfig.Callback) == "function" then
						elevate()
						local ok, err = pcall(sliderconfig.Callback, value)
						if not ok then
							warn("Slider Callback error:", err)
						end
					end
				end

				local function setfromx(x)
					local percent = math.clamp((x - sliderframe.AbsolutePosition.X) / sliderframe.AbsoluteSize.X, 0, 1)
					local value = sliderconfig.Min + ((sliderconfig.Max - sliderconfig.Min) * percent)

					sliderfunc:Set(value)
				end

				function sliderfunc:Set(value, nocallback, force)
					if islocked and not force then
						return
					end
					apply(value, not nocallback, not islocked)
				end

				-- config load: unlike Set(v, true) this does fire the callback,
				-- otherwise a loaded config moves the knob but not the hub
				function sliderfunc:LoadValue(value)
					self:Set(value, false)
				end

				function sliderfunc:ResetValue()
					self:Set(hubdefault)
				end

				local function startdrag(input)
					if islocked then
						return
					end
					if
						input.UserInputType == Enum.UserInputType.MouseButton1
						or input.UserInputType == Enum.UserInputType.Touch
					then
						dragging = true
						showbubble()
						setfromx(input.Position.X)
						sliderDrag.active = {
							setfromx = setfromx,
							hidebubble = function()
								dragging = false
								hidebubble()
							end,
						}
					end
				end

				sliderframe.InputBegan:Connect(startdrag)
				slidercircle.InputBegan:Connect(startdrag)

				textbox.Focused:Connect(function()
					showbubble()
				end)

				textbox.FocusLost:Connect(function()
					if setting then
						return
					end

					local text = textbox.Text:gsub(",", ".")
					local value = tonumber(text)

					if value and not islocked then
						sliderfunc:Set(value)
					else
						textbox.Text = formatnumber(sliderfunc.Value)
					end

					hidebubble()
				end)

				-- a value that came from a saved config reaches the hub at build too
				apply(sliderfunc.Value, (not islocked) and haspref, not islocked)

				if lockable then
					lock = makelock(slider, { sliderframe, inputholder }, {
						DonatorOnly = donatoronly,
						GetBaseHeight = function()
							return basey
						end,
						OnLock = function(silent)
							islocked = true
							if sliderfunc.Value ~= hubdefault then
								apply(hubdefault, not silent, false)
							end
						end,
						OnUnlock = function()
							islocked = false
							apply(savedpref(), true, true)
						end,
					}, islocked)
				end

				function sliderfunc:IsLocked()
					return islocked
				end

				countitem = countitem + 1
				yieldbuild()
				config.elements[configkey] = sliderfunc
				registerSearchItem(sliderconfig.Title, slider)
				return sliderfunc
			end

			function items:AddInput(inputconfig)
				inputconfig = inputconfig or {}
				inputconfig.Title = inputconfig.Title or "Title"
				inputconfig.Placeholder = inputconfig.Placeholder or "Write your input here"
				inputconfig.Callback = inputconfig.Callback or function() end

				local configkey = keyfor("Input_", inputconfig)
				local hubdefault = tostring(inputconfig.Default or "")
				local function savedpref()
					local v = config.data[configkey]
					if v ~= nil then
						return tostring(v)
					end
					if config.loaded and not metakeys[configkey] then
						return ""
					end
					return hubdefault
				end

				local lockable = isdonatorelement(inputconfig)
				local donatoronly = isdonatoronly(inputconfig)
				local islocked = lockable and not tierallows(donatoronly)
				local inputfunc = { Value = islocked and hubdefault or savedpref(), DefaultValue = hubdefault }

				local inputcontainer = instance.frame(sectionadd)
				inputcontainer.BorderSizePixel = 0
				inputcontainer.LayoutOrder = countitem
				inputcontainer.Size = UDim2.new(1, 0, 0, 58)
				roundbg(inputcontainer, 4, theme.Row)

				local inputtitle = instance.textlabel(inputcontainer)
				inputtitle.Font = Enum.Font.GothamBold
				inputtitle.Text = inputconfig.Title
				inputtitle.TextSize = 13
				inputtitle.TextColor3 = Color3.fromRGB(255, 255, 255)
				inputtitle.TextXAlignment = Enum.TextXAlignment.Left
				inputtitle.BackgroundTransparency = 1
				inputtitle.Position = UDim2.new(0, 10, 0, 6)
				inputtitle.Size = UDim2.new(1, -20, 0, 14)

				local inputtextbox = instance.textbox(inputcontainer)
				inputtextbox.Font = Enum.Font.GothamBold
				inputtextbox.PlaceholderText = inputconfig.Placeholder
				inputtextbox.PlaceholderColor3 = Color3.fromRGB(255, 255, 255)
				inputtextbox.TextTransparency = 0.4
				inputtextbox.Text = inputfunc.Value
				inputtextbox.TextSize = 11
				inputtextbox.TextColor3 = Color3.fromRGB(255, 255, 255)
				inputtextbox.BackgroundColor3 = theme.Field
				inputtextbox.BackgroundTransparency = 0
				inputtextbox.TextXAlignment = Enum.TextXAlignment.Left
				inputtextbox.ClearTextOnFocus = false
				inputtextbox.Position = UDim2.new(0, 10, 0, 26)
				inputtextbox.Size = UDim2.new(1, -20, 0, 24)
				inputtextbox.ClipsDescendants = true
				inputtextbox.TextTruncate = Enum.TextTruncate.AtEnd

				local padding = instance.uipadding(inputtextbox)
				padding.PaddingLeft = UDim.new(0, 4)

				local lock = nil
				local basey = 58
				local description = contenttext(inputconfig)
				if description then
					local _, measure = attachcontent(inputcontainer, description, 10, 23, 10)
					local function relayout()
						local boxy = 23 + measure() + 5
						inputtextbox.Position = UDim2.new(0, 10, 0, boxy)
						basey = boxy + 32
						if lock and lock:IsLocked() then
							lock:Relayout()
						else
							inputcontainer.Size = UDim2.new(1, 0, 0, basey)
						end
					end
					relayout()
					watchwidth(inputcontainer, relayout)
				end

				inputtextbox.Focused:Connect(function()
					inputtextbox.CursorPosition = #inputtextbox.Text + 1
				end)

				-- suppress: a programmatic Text change (lock, load) must not be
				-- recorded as the player's own typing
				local suppress = false
				local function applyinput(value, fire, save)
					elevate()
					value = tostring(value == nil and "" or value)
					inputfunc.Value = value
					suppress = true
					inputtextbox.Text = value
					suppress = false
					if save then
						config.data[configkey] = value
					end
					if fire and typeof(inputconfig.Callback) == "function" then
						elevate()
						local ok, err = pcall(inputconfig.Callback, value)
						if not ok then
							warn("Input Callback error:", err)
						end
					end
				end

				function inputfunc:Set(value)
					if islocked then
						return
					end
					applyinput(value, true, true)
				end

				function inputfunc:LoadValue(value)
					self:Set(value)
				end

				function inputfunc:ResetValue()
					self:Set(hubdefault)
				end

				inputtextbox:GetPropertyChangedSignal("Text"):Connect(function()
					if suppress or islocked then
						return
					end
					inputfunc.Value = inputtextbox.Text
					config.data[configkey] = inputtextbox.Text
				end)

				inputtextbox.FocusLost:Connect(function()
					inputfunc:Set(inputtextbox.Text)
				end)

				if islocked then
					applyinput(hubdefault, false, false)
				else
					applyinput(inputfunc.Value, true, true)
				end

				if lockable then
					lock = makelock(inputcontainer, { inputtextbox }, {
						DonatorOnly = donatoronly,
						GetBaseHeight = function()
							return basey
						end,
						OnLock = function(silent)
							islocked = true
							if inputfunc.Value ~= hubdefault then
								applyinput(hubdefault, not silent, false)
							end
						end,
						OnUnlock = function()
							islocked = false
							applyinput(savedpref(), true, true)
						end,
					}, islocked)
				end

				function inputfunc:IsLocked()
					return islocked
				end

				countitem = countitem + 1
				yieldbuild()
				config.elements[configkey] = inputfunc
				registerSearchItem(inputconfig.Title, inputcontainer)
				return inputfunc
			end

			function items:AddDropdown(dropdownconfig)
				dropdownconfig = dropdownconfig or {}
				dropdownconfig.Title = dropdownconfig.Title or "Title"
				dropdownconfig.Multi = dropdownconfig.Multi or false
				dropdownconfig.Advanced = dropdownconfig.Advanced or false
				dropdownconfig.Options = dropdownconfig.Options or {}
				dropdownconfig.Callback = dropdownconfig.Callback or function() end
				local multi = dropdownconfig.Multi

				-- a selection in this dropdown's shape: Multi -> a fresh array,
				-- single -> one value or nil. Always a copy, so the hub can keep or
				-- change what it was given without touching the dropdown.
				local function normalize(value)
					if multi then
						local out = {}
						if type(value) == "table" then
							for _, v in ipairs(value) do
								out[#out + 1] = v
							end
						end
						return out
					end
					if type(value) == "table" then
						return value[1]
					end
					if value == "" then
						return nil
					end
					return value
				end

				local function sameselection(a, b)
					if multi then
						if #a ~= #b then
							return false
						end
						for i = 1, #a do
							if a[i] ~= b[i] then
								return false
							end
						end
						return true
					end
					return a == b
				end

				local configkey = keyfor("Dropdown_", dropdownconfig)
				local hubdefault = normalize(dropdownconfig.Default)
				local function savedpref()
					local v = config.data[configkey]
					if v ~= nil then
						return normalize(v)
					end
					if config.loaded then
						return normalize(nil)
					end
					return normalize(hubdefault)
				end

				local lockable = isdonatorelement(dropdownconfig)
				local donatoronly = isdonatoronly(dropdownconfig)
				local islocked = lockable and not tierallows(donatoronly)
				local dropdownfunc = {
					Value = islocked and normalize(hubdefault) or savedpref(),
					Options = dropdownconfig.Options,
					DefaultValue = normalize(hubdefault),
				}

				local function parseOption(option)
					local label, desc, img, value

					if typeof(option) == "table" then
						if option.Label and option.Value ~= nil then
							label = tostring(option.Label)
							value = option.Value
							desc = option.Description or option.Desc or option[2]
							img = option.Image or option.Icon or option[3]
						else
							label = tostring(option[1] or option.Title or option.Name or "Option")
							desc = option[2] or option.Description or option.Desc
							img = option[3] or option.Image or option.Icon
							value = option.Value ~= nil and option.Value or label
						end
					else
						label = tostring(option)
						value = option
					end

					if img and type(img) == "number" then
						img = "rbxassetid://" .. tostring(img)
					elseif img and type(img) == "string" and img ~= "" and not img:find("rbxassetid://") then
						img = "rbxassetid://" .. img
					end

					return label, desc, img, value
				end

				local dropdown = instance.frame(sectionadd)
				dropdown.Name = "Dropdown"
				dropdown.BorderSizePixel = 0
				dropdown.LayoutOrder = countitem
				dropdown.Size = UDim2.new(1, 0, 0, 46)
				roundbg(dropdown, 4, theme.Row)

				local dropdownbutton = instance.textbutton(dropdown)
				dropdownbutton.Name = "ToggleButton"
				dropdownbutton.Text = ""
				dropdownbutton.BackgroundTransparency = 1
				dropdownbutton.Size = UDim2.new(1, 0, 1, 0)

				local dropdowntitle = instance.textlabel(dropdown)
				dropdowntitle.Name = "DropdownTitle"
				dropdowntitle.Font = Enum.Font.GothamBold
				dropdowntitle.Text = dropdownconfig.Title
				dropdowntitle.TextColor3 = theme.Text
				dropdowntitle.TextSize = 13
				dropdowntitle.TextXAlignment = Enum.TextXAlignment.Left
				dropdowntitle.BackgroundTransparency = 1
				dropdowntitle.Position = UDim2.new(0, 10, 0, 0)
				dropdowntitle.Size = UDim2.new(1, -180, 1, 0)

				local selectoptionsframe = instance.frame(dropdown)
				selectoptionsframe.Name = "SelectOptionsFrame"
				selectoptionsframe.AnchorPoint = Vector2.new(1, 0.5)
				selectoptionsframe.Position = UDim2.new(1, -7, 0.5, 0)
				selectoptionsframe.Size = UDim2.new(0, 148, 0, 30)
				selectoptionsframe.LayoutOrder = countdropdown
				roundbg(selectoptionsframe, 4, theme.Inner)

				local optionselecting = instance.textlabel(selectoptionsframe)
				optionselecting.Name = "OptionSelecting"
				optionselecting.Font = Enum.Font.GothamBold
				optionselecting.Text = dropdownconfig.Multi and "Select Options" or "Select Option"
				optionselecting.TextColor3 = Color3.fromRGB(255, 255, 255)
				optionselecting.TextSize = 12
				optionselecting.TextTransparency = 0.6
				optionselecting.TextXAlignment = Enum.TextXAlignment.Left
				optionselecting.AnchorPoint = Vector2.new(0, 0.5)
				optionselecting.BackgroundTransparency = 1
				optionselecting.Position = UDim2.new(0, 5, 0.5, 0)
				optionselecting.Size = UDim2.new(1, -30, 1, -8)

				local optionimg = instance.imagelabel(selectoptionsframe)
				optionimg.Name = "OptionImg"
				optionimg.Image = "rbxassetid://16851841101"
				optionimg.ImageColor3 = theme.Text
				optionimg.AnchorPoint = Vector2.new(1, 0.5)
				optionimg.BackgroundTransparency = 1
				optionimg.Position = UDim2.new(1, 0, 0.5, 0)
				optionimg.Size = UDim2.new(0, 25, 0, 25)

				local lock = nil
				local basey = 46
				local description = contenttext(dropdownconfig)
				if description then
					dropdowntitle.Position = UDim2.new(0, 10, 0, 9)
					dropdowntitle.Size = UDim2.new(1, -180, 0, 14)
					dropdowntitle.TextYAlignment = Enum.TextYAlignment.Top
					local _, measure = attachcontent(dropdown, description, 10, 26, 170)
					local function relayout()
						basey = math.max(46, 26 + measure() + 10)
						if lock and lock:IsLocked() then
							lock:Relayout()
						else
							dropdown.Size = UDim2.new(1, 0, 0, basey)
						end
					end
					relayout()
					watchwidth(dropdown, relayout)
				end

				local dropdowncontainer = instance.frame(dropdownfolder)
				dropdowncontainer.Size = UDim2.new(1, 0, 1, 0)
				dropdowncontainer.BackgroundTransparency = 1

				local searchbox = instance.textbox(dropdowncontainer)
				searchbox.Name = "SearchBox"
				searchbox.PlaceholderText = "Search"
				searchbox.Font = Enum.Font.GothamBold
				searchbox.Text = ""
				searchbox.TextSize = 12
				searchbox.TextColor3 = Color3.fromRGB(255, 255, 255)
				searchbox.BackgroundColor3 = theme.Element
				searchbox.BackgroundTransparency = 0
				searchbox.BorderSizePixel = 0
				searchbox.Size = UDim2.new(1, 0, 0, 25)
				searchbox.Position = UDim2.new(0, 0, 0, 0)
				searchbox.ClearTextOnFocus = false

				local scrollselect = instance.scrollingframe(dropdowncontainer)
				scrollselect.Name = "ScrollSelect"
				scrollselect.Size = UDim2.new(1, 0, 1, -30)
				scrollselect.Position = UDim2.new(0, 0, 0, 30)
				scrollselect.ScrollBarImageColor3 = theme.Track
				scrollselect.ScrollBarImageTransparency = 0.2
				scrollselect.BorderSizePixel = 0
				scrollselect.BackgroundTransparency = 1
				scrollselect.ScrollBarThickness = 3
				scrollselect.CanvasSize = UDim2.new(0, 0, 0, 0)

				local uilistlayout = instance.uilistlayout(scrollselect)
				uilistlayout.Padding = UDim.new(0, 3)
				uilistlayout.SortOrder = Enum.SortOrder.LayoutOrder

				uilistlayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
					scrollselect.CanvasSize = UDim2.new(0, 0, 0, uilistlayout.AbsoluteContentSize.Y)
				end)

				-- Options live in optionlist; their rows are only built the first
				-- time the list is opened (a dropdown nobody opens costs no rows,
				-- and Refresh on a closed dropdown is just a table swap).
				local optionlist = {}
				local built = false

				local function isselected(value)
					if multi then
						return table.find(dropdownfunc.Value, value) ~= nil
					end
					return dropdownfunc.Value ~= nil and dropdownfunc.Value == value
				end

				local function paint(entry, instant)
					local drop = entry.frame
					if not drop or not drop.Parent then
						return
					end
					local selected = isselected(entry.value)
					local targetSize = selected and UDim2.new(0, 1, 0, 12) or UDim2.new(0, 0, 0, 0)
					local targetStroke = selected and 0 or 1
					local targetBackground = selected and 0 or 1
					local stroke = drop.ChooseFrame:FindFirstChild("UIStroke")

					if instant then
						drop.ChooseFrame.Size = targetSize
						if stroke then
							stroke.Transparency = targetStroke
						end
						drop.Bg.ImageTransparency = targetBackground
					else
						local info = TweenInfo.new(selected and 0.2 or 0.1)
						sv.ts:Create(drop.ChooseFrame, info, { Size = targetSize }):Play()
						if stroke then
							sv.ts:Create(stroke, info, { Transparency = targetStroke }):Play()
						end
						sv.ts:Create(drop.Bg, info, { ImageTransparency = targetBackground }):Play()
					end
				end

				local function updatetext()
					local texts, matched = {}, {}
					for _, entry in ipairs(optionlist) do
						if isselected(entry.value) then
							texts[#texts + 1] = entry.label
							matched[entry.value] = true
						end
					end
					-- a pick whose option is not in the list (saved before the list
					-- loaded, a player who left) is still active, so still shown
					local picks = multi and dropdownfunc.Value or { dropdownfunc.Value }
					for _, v in ipairs(picks) do
						if v ~= nil and not matched[v] then
							texts[#texts + 1] = tostring(v)
						end
					end
					optionselecting.Text = (#texts == 0) and (multi and "Select Options" or "Select Option")
						or table.concat(texts, ", ")
				end

				local function fire()
					if typeof(dropdownconfig.Callback) ~= "function" then
						return
					end
					elevate()
					local ok, err
					if multi then
						ok, err = pcall(dropdownconfig.Callback, normalize(dropdownfunc.Value))
					else
						ok, err = pcall(dropdownconfig.Callback, dropdownfunc.Value ~= nil and tostring(dropdownfunc.Value) or "")
					end
					if not ok then
						warn("Dropdown Callback error:", err)
					end
				end

				local function apply(value, instant, save, dofire)
					elevate()
					dropdownfunc.Value = normalize(value)
					if save then
						config.data[configkey] = multi and normalize(dropdownfunc.Value) or dropdownfunc.Value
					end
					for _, entry in ipairs(optionlist) do
						paint(entry, instant)
					end
					updatetext()
					if dofire then
						fire()
					end
				end

				local function applyfilter()
					if not built then
						return
					end
					local query = string.lower(searchbox.Text)
					for _, entry in ipairs(optionlist) do
						if entry.frame then
							entry.frame.Visible = query == ""
								or string.find(string.lower(entry.label), query, 1, true) ~= nil
								or (entry.desc ~= nil and string.find(string.lower(tostring(entry.desc)), query, 1, true) ~= nil)
						end
					end
					scrollselect.CanvasSize = UDim2.new(0, 0, 0, uilistlayout.AbsoluteContentSize.Y)
				end

				searchbox:GetPropertyChangedSignal("Text"):Connect(applyfilter)

				local function buildoption(entry)
					local useAdvanced = dropdownconfig.Advanced and (entry.desc or entry.img)
					local height = 30
					local leftPadding = entry.img and 42 or 8
					local textX = useAdvanced and math.max(8, leftPadding - 10) or leftPadding

					local optionframe = templates.DropdownOption:Clone()
					optionframe.Size = UDim2.new(1, 0, 0, height)
					optionframe.Parent = scrollselect

					local optionbutton = optionframe.OptionButton
					local optiontext = optionframe.OptionText
					optiontext.Text = entry.label
					optiontext.Position = UDim2.new(0, textX, 0, useAdvanced and 1 or 8)
					optiontext.Size = UDim2.new(1, -(textX + 20), 0, 13)

					if entry.img then
						local icon = instance.imagelabel(optionframe)
						icon.Name = "OptionIcon"
						icon.Image = entry.img
						icon.BackgroundTransparency = 1
						icon.Position = UDim2.new(0, 8, 0.5, -14)
						icon.Size = UDim2.new(0, 28, 0, 28)
						icon.ScaleType = Enum.ScaleType.Fit
						instance.uicorner(icon).CornerRadius = UDim.new(0, 5)
					end

					if useAdvanced and entry.desc then
						local optiondesc = instance.textlabel(optionframe)
						optiondesc.Name = "OptionDesc"
						optiondesc.Font = Enum.Font.GothamBold
						optiondesc.Text = tostring(entry.desc)
						optiondesc.TextSize = 10
						optiondesc.TextTransparency = 0.3
						optiondesc.TextColor3 = Color3.fromRGB(255, 255, 255)
						optiondesc.Position = UDim2.new(0, textX, 0, 11)
						optiondesc.Size = UDim2.new(1, -(textX + 20), 0, 10)
						optiondesc.BackgroundTransparency = 1
						optiondesc.TextXAlignment = Enum.TextXAlignment.Left
						optiondesc.TextTruncate = Enum.TextTruncate.AtEnd
					end

					optionbutton.Activated:Connect(function()
						if islocked then
							return
						end
						if multi then
							local sel = normalize(dropdownfunc.Value)
							local idx = table.find(sel, entry.value)
							if idx then
								table.remove(sel, idx)
							else
								table.insert(sel, entry.value)
							end
							apply(sel, false, true, true)
						else
							apply(entry.value, false, true, true)
							closedropdownpopup()
						end
					end)

					entry.frame = optionframe
				end

				local function buildall()
					if built then
						return
					end
					built = true
					for _, entry in ipairs(optionlist) do
						buildoption(entry)
						paint(entry, true)
					end
				end

				local function setoptions(list)
					for _, entry in ipairs(optionlist) do
						if entry.frame then
							entry.frame:Destroy()
						end
					end
					optionlist = {}
					for _, option in ipairs(list or {}) do
						local label, desc, img, value = parseOption(option)
						local entry = { label = label, desc = desc, img = img, value = value }
						optionlist[#optionlist + 1] = entry
						if built then
							buildoption(entry)
						end
					end
					dropdownfunc.Options = list or {}
				end

				dropdownbutton.Activated:Connect(function()
					if islocked then
						return
					end
					buildall()
					applyfilter()
					opendropdownpopup(selectoptionsframe.LayoutOrder)
				end)

				function dropdownfunc:Clear()
					setoptions({})
					dropdownfunc.Value = normalize(nil)
					updatetext()
				end

				function dropdownfunc:AddOption(option)
					local label, desc, img, value = parseOption(option)
					local entry = { label = label, desc = desc, img = img, value = value }
					optionlist[#optionlist + 1] = entry
					if built then
						buildoption(entry)
						paint(entry, true)
						applyfilter()
					end
					updatetext()
				end

				function dropdownfunc:Set(value, instant, force)
					if islocked and not force then
						return
					end
					apply(value, instant, not islocked, true)
				end

				function dropdownfunc:SetValue(val)
					self:Set(val)
				end

				function dropdownfunc:GetValue()
					return self.Value
				end

				function dropdownfunc:SetValues(newlist, selecting, instant)
					setoptions(newlist or {})
					if islocked then
						apply(dropdownfunc.Value, true, false, false)
					else
						apply(selecting, instant, true, true)
					end
					applyfilter()
				end

				-- Refresh swaps the option list and keeps the selection, like
				-- SenaLib (nothing fires). Refresh(list, false) clears it and fires
				-- the callback if something was selected.
				function dropdownfunc:Refresh(newlist, keep)
					setoptions(newlist or {})
					if keep == false and not islocked then
						local cleared = normalize(nil)
						apply(cleared, true, true, not sameselection(normalize(dropdownfunc.Value), cleared))
					else
						apply(dropdownfunc.Value, true, false, false)
					end
					applyfilter()
				end

				function dropdownfunc:LoadValue(value)
					self:Set(value, true)
				end

				function dropdownfunc:ResetValue()
					self:Set(normalize(hubdefault))
				end

				setoptions(dropdownconfig.Options)
				if islocked then
					apply(dropdownfunc.Value, true, false, false)
				else
					apply(dropdownfunc.Value, true, true, true)
				end

				if lockable then
					lock = makelock(dropdown, { selectoptionsframe }, {
						DonatorOnly = donatoronly,
						GetBaseHeight = function()
							return basey
						end,
						Pin = function(state)
							selectoptionsframe.Position = state and UDim2.new(1, -7, 0, basey / 2) or UDim2.new(1, -7, 0.5, 0)
							if not description then
								dropdowntitle.Size = state and UDim2.new(1, -180, 0, basey) or UDim2.new(1, -180, 1, 0)
							end
						end,
						OnLock = function(silent)
							islocked = true
							local base = normalize(hubdefault)
							if not sameselection(normalize(dropdownfunc.Value), base) then
								apply(base, true, false, not silent)
							end
						end,
						OnUnlock = function()
							islocked = false
							apply(savedpref(), true, true, true)
						end,
					}, islocked)
				end

				function dropdownfunc:IsLocked()
					return islocked
				end

				countitem = countitem + 1
				countdropdown = countdropdown + 1
				yieldbuild()
				config.elements[configkey] = dropdownfunc
				registerSearchItem(dropdownconfig.Title, dropdown)
				return dropdownfunc
			end

			function items:AddLiveChat(chatconfig)
				chatconfig = chatconfig or {}
				chatconfig.Title = chatconfig.Title or chatconfig[1] or "Live Chat"
				local height = math.max(180, tonumber(chatconfig.Height) or 260)
				local cooldown = math.max(0, tonumber(chatconfig.Cooldown) or 5)
				local maxshown = math.max(15, tonumber(chatconfig.MaxMessages) or 30)
				local fixedmax = tonumber(chatconfig.MaxLength)

				-- Live chat is opt-in: off by default, choice remembered per device
				local chatpreffile = "Sena/livechat_enabled.txt"
				local function loadchatpref()
					local forced = getgenv and getgenv().SenaLiveChat
					if forced ~= nil then
						return forced == true
					end
					if chatconfig.Default ~= nil and not (isfile and pcall(isfile, chatpreffile) and isfile(chatpreffile)) then
						return chatconfig.Default == true
					end
					local ok, value = pcall(function()
						return isfile and isfile(chatpreffile) and readfile(chatpreffile)
					end)
					return ok and value == "1"
				end
				local function savechatpref(on)
					pcall(function()
						if writefile then
							writefile(chatpreffile, on and "1" or "0")
						end
					end)
				end
				local chatenabled = loadchatpref()
				local chatdirty = true
				local setchatenabled

				local systemline, switchroom, setmode, toggletagdropdown, updatecategorybuttons
				local mode, pmtarget = "global", nil
				local activeroom = "general"
				local lastincoming = nil

				local function maxlength()
					if fixedmax then
						return math.max(10, fixedmax)
					end
					local b = Chloex:GetBackend()
					return math.max(10, tonumber(b and b.ChatMax) or 120)
				end

				local function chatttl()
					local b = Chloex:GetBackend()
					return math.max(30, tonumber(b and b.ChatTtl) or 600)
				end

				local goodhex = hexcolor(theme.Good)
				local badhex = hexcolor(theme.Bad)
				local goldhex = hexcolor(theme.Gold)
				local bluehex = hexcolor(theme.Blue)
				local dimhex = hexcolor(theme.Dim)
				local minehex = hexcolor(theme.Text)

				local chat = instance.frame(sectionadd)
				chat.Name = "LiveChat"
				chat.BorderSizePixel = 0
				chat.LayoutOrder = countitem
				chat.Size = UDim2.new(1, 0, 0, height)
				chat.ClipsDescendants = true
				roundbg(chat, 6, theme.Row)

				local pad = 8
				local headerh = 34
				local roomh = 24
				local barh = isMobile and 32 or 30

				local function pill(parent, name, text, clickable)
					local frame = clickable and instance.textbutton(parent) or instance.frame(parent)
					frame.Name = name
					frame.BackgroundColor3 = theme.Element
					frame.BackgroundTransparency = 0
					frame.BorderSizePixel = 0
					frame.AutomaticSize = Enum.AutomaticSize.X
					frame.Size = UDim2.new(0, 0, 0, 20)
					if clickable then
						frame.Text = ""
						frame.AutoButtonColor = false
					end
					frame.ZIndex = 3
					instance.uicorner(frame).CornerRadius = UDim.new(1, 0)

					local stroke = instance.uistroke(frame)
					stroke.Color = theme.Stroke
					stroke.Thickness = 1
					stroke.Transparency = 0.35

					local padding = instance.uipadding(frame)
					padding.PaddingLeft = UDim.new(0, 10)
					padding.PaddingRight = UDim.new(0, 10)

					local label = instance.textlabel(frame)
					label.Name = "Label"
					label.BackgroundTransparency = 1
					label.AutomaticSize = Enum.AutomaticSize.X
					label.Size = UDim2.new(0, 0, 1, 0)
					label.Font = Enum.Font.GothamMedium
					label.RichText = true
					label.Text = text
					label.TextColor3 = theme.SubText
					label.TextSize = 11
					label.ZIndex = 4

					return frame, label, stroke
				end

				local chattitle = instance.textlabel(chat)
				chattitle.Name = "ChatTitle"
				chattitle.BackgroundTransparency = 1
				chattitle.Position = UDim2.new(0, 12, 0, 0)
				chattitle.Size = UDim2.new(0.3, 0, 0, headerh)
				chattitle.Font = Enum.Font.GothamBold
				chattitle.Text = tostring(chatconfig.Title)
				chattitle.TextColor3 = theme.Text
				chattitle.TextSize = 13
				chattitle.TextXAlignment = Enum.TextXAlignment.Left
				chattitle.TextTruncate = Enum.TextTruncate.AtEnd

				local headerstrip = instance.frame(chat)
				headerstrip.Name = "HeaderStrip"
				headerstrip.AnchorPoint = Vector2.new(1, 0.5)
				headerstrip.Position = UDim2.new(1, -pad, 0, headerh / 2)
				headerstrip.Size = UDim2.new(0, 0, 0, 20)
				headerstrip.AutomaticSize = Enum.AutomaticSize.X
				headerstrip.BackgroundTransparency = 1

				local headerlayout = instance.uilistlayout(headerstrip)
				headerlayout.FillDirection = Enum.FillDirection.Horizontal
				headerlayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
				headerlayout.VerticalAlignment = Enum.VerticalAlignment.Center
				headerlayout.Padding = UDim.new(0, 6)
				headerlayout.SortOrder = Enum.SortOrder.LayoutOrder

				local localowner = isowner()
				local hidename = not localowner
				if not localowner then
					if getgenv and getgenv().SenaHideName ~= nil then
						hidename = (getgenv().SenaHideName == true)
					elseif _G and _G.SenaHideName ~= nil then
						hidename = (_G.SenaHideName == true)
					end
				end

				local function hidetext()
					return hidename and ('<font color="' .. badhex .. '">●</font>  Hidden')
						or ('<font color="' .. goodhex .. '">●</font>  Public')
				end

				local modebtn, modelabel = pill(headerstrip, "Mode", "Rooms", true)
				modebtn.LayoutOrder = 1
				local hidebtn, hidelabel = pill(headerstrip, "HideName", hidetext(), true)
				hidebtn.LayoutOrder = 2
				local onlinepill, onlinelabel = pill(headerstrip, "Online", '<font color="' .. dimhex .. '">●</font>  connecting', false)
				onlinepill.LayoutOrder = 3
				local powerbtn, powerlabel, powerstroke = pill(headerstrip, "Power", "", true)
				powerbtn.LayoutOrder = 0

				local offh = 64
				local offcard = instance.frame(chat)
				offcard.Name = "ChatOff"
				offcard.Position = UDim2.new(0, pad, 0, headerh)
				offcard.Size = UDim2.new(1, -pad * 2, 0, offh - pad)
				offcard.BackgroundColor3 = theme.ChatBg
				offcard.BorderSizePixel = 0
				offcard.ZIndex = 3
				offcard.Visible = false
				instance.uicorner(offcard).CornerRadius = UDim.new(0, 6)
				local offtext = instance.textlabel(offcard)
				offtext.BackgroundTransparency = 1
				offtext.Position = UDim2.new(0, 12, 0, 0)
				offtext.Size = UDim2.new(1, -170, 1, 0)
				offtext.Font = Enum.Font.Gotham
				offtext.Text = "Live chat is off to keep your FPS up. Turn it on to read and send messages."
				offtext.TextColor3 = theme.Dim
				offtext.TextSize = 11
				offtext.TextWrapped = true
				offtext.TextXAlignment = Enum.TextXAlignment.Left
				offtext.ZIndex = 4
				local onbtn = instance.textbutton(offcard)
				onbtn.AnchorPoint = Vector2.new(1, 0.5)
				onbtn.Position = UDim2.new(1, -10, 0.5, 0)
				onbtn.Size = UDim2.new(0, 140, 0, 28)
				onbtn.BackgroundColor3 = theme.Accent
				onbtn.BorderSizePixel = 0
				onbtn.Font = Enum.Font.GothamBold
				onbtn.Text = "Turn On Live Chat"
				onbtn.TextColor3 = theme.AccentText
				onbtn.TextSize = 12
				onbtn.ZIndex = 4
				instance.uicorner(onbtn).CornerRadius = UDim.new(1, 0)

				local rooms = {
					{ id = "general", label = "General" },
					{ id = "indonesian", label = "Indonesian" },
					{ id = "philippines", label = "Philippines" },
					{ id = "vietnam", label = "Vietnam" },
					{ id = "brazilian", label = "Brazilian" },
				}

				local catbar = instance.scrollingframe(chat)
				catbar.Name = "CategoryBar"
				catbar.Position = UDim2.new(0, pad, 0, headerh)
				catbar.Size = UDim2.new(1, -pad * 2, 0, roomh)
				catbar.BackgroundTransparency = 1
				catbar.BorderSizePixel = 0
				catbar.ScrollBarThickness = 0
				catbar.ScrollingDirection = Enum.ScrollingDirection.X
				catbar.CanvasSize = UDim2.new(0, 0, 0, 0)
				catbar.AutomaticCanvasSize = Enum.AutomaticSize.X
				catbar.ZIndex = 3

				local catlayout = instance.uilistlayout(catbar)
				catlayout.FillDirection = Enum.FillDirection.Horizontal
				catlayout.VerticalAlignment = Enum.VerticalAlignment.Center
				catlayout.Padding = UDim.new(0, 5)
				catlayout.SortOrder = Enum.SortOrder.LayoutOrder

				catbar.InputChanged:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseWheel then
						elevate()
						local maxscroll = math.max(0, catbar.AbsoluteCanvasSize.X - catbar.AbsoluteWindowSize.X)
						catbar.CanvasPosition = Vector2.new(math.clamp(catbar.CanvasPosition.X - input.Position.Z * 60, 0, maxscroll), 0)
					end
				end)

				local scrolltop = headerh + roomh + 6
				local scroll = instance.scrollingframe(chat)
				scroll.Name = "Messages"
				scroll.Position = UDim2.new(0, pad, 0, scrolltop)
				scroll.Size = UDim2.new(1, -pad * 2, 1, -(scrolltop + barh + pad * 2))
				scroll.BackgroundColor3 = theme.ChatBg
				scroll.BackgroundTransparency = 0
				scroll.BorderSizePixel = 0
				scroll.ScrollBarThickness = 3
				scroll.ScrollBarImageColor3 = theme.Track
				scroll.ScrollBarImageTransparency = 0.3
				scroll.ScrollingDirection = Enum.ScrollingDirection.Y
				scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
				scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
				scroll.ZIndex = 2
				instance.uicorner(scroll).CornerRadius = UDim.new(0, 6)

				local scrollstroke = instance.uistroke(scroll)
				scrollstroke.Color = theme.Stroke
				scrollstroke.Thickness = 1
				scrollstroke.Transparency = 0.5

				local scrollpad = instance.uipadding(scroll)
				scrollpad.PaddingLeft = UDim.new(0, 8)
				scrollpad.PaddingRight = UDim.new(0, 8)
				scrollpad.PaddingTop = UDim.new(0, 6)
				scrollpad.PaddingBottom = UDim.new(0, 6)

				local scrolllayout = instance.uilistlayout(scroll)
				scrolllayout.Padding = UDim.new(0, 7)
				scrolllayout.SortOrder = Enum.SortOrder.LayoutOrder

				local bar = instance.frame(chat)
				bar.Name = "InputBar"
				bar.AnchorPoint = Vector2.new(0, 1)
				bar.Position = UDim2.new(0, pad, 1, -pad)
				bar.Size = UDim2.new(1, -pad * 2, 0, barh)
				bar.BackgroundTransparency = 1

				local sendw = 60
				local tagw = barh

				local box = instance.textbox(bar)
				box.Name = "Input"
				box.Size = UDim2.new(1, -sendw - tagw - 12, 1, 0)
				box.BackgroundColor3 = theme.Element
				box.BackgroundTransparency = 0
				box.BorderSizePixel = 0
				box.Font = Enum.Font.Gotham
				box.Text = ""
				box.PlaceholderText = "Message in #general..."
				box.PlaceholderColor3 = theme.Dim
				box.TextColor3 = theme.Text
				box.TextSize = 12
				box.TextXAlignment = Enum.TextXAlignment.Left
				box.ClearTextOnFocus = false
				box.ClipsDescendants = true
				box.TextTruncate = Enum.TextTruncate.AtEnd
				box.ZIndex = 3
				instance.uicorner(box).CornerRadius = UDim.new(1, 0)

				local boxstroke = instance.uistroke(box)
				boxstroke.Color = theme.Stroke
				boxstroke.Thickness = 1
				boxstroke.Transparency = 0.35

				local boxpad = instance.uipadding(box)
				boxpad.PaddingLeft = UDim.new(0, 12)
				boxpad.PaddingRight = UDim.new(0, 12)

				local tagbtn = instance.textbutton(bar)
				tagbtn.Name = "TagBtn"
				tagbtn.AnchorPoint = Vector2.new(1, 0)
				tagbtn.Position = UDim2.new(1, -sendw - 6, 0, 0)
				tagbtn.Size = UDim2.new(0, tagw, 1, 0)
				tagbtn.BackgroundColor3 = theme.Element
				tagbtn.BackgroundTransparency = 0
				tagbtn.BorderSizePixel = 0
				tagbtn.Font = Enum.Font.GothamBold
				tagbtn.Text = "@"
				tagbtn.TextColor3 = theme.Text
				tagbtn.TextSize = 14
				tagbtn.AutoButtonColor = true
				tagbtn.ZIndex = 3
				instance.uicorner(tagbtn).CornerRadius = UDim.new(1, 0)

				local tagbtnstroke = instance.uistroke(tagbtn)
				tagbtnstroke.Color = theme.Stroke
				tagbtnstroke.Thickness = 1
				tagbtnstroke.Transparency = 0.35

				local send = instance.textbutton(bar)
				send.Name = "Send"
				send.AnchorPoint = Vector2.new(1, 0)
				send.Position = UDim2.new(1, 0, 0, 0)
				send.Size = UDim2.new(0, sendw, 1, 0)
				send.BackgroundColor3 = guiconfig.Color
				send.BorderSizePixel = 0
				send.Font = Enum.Font.GothamBold
				send.Text = "Send"
				send.TextColor3 = theme.AccentText
				send.TextSize = 12
				send.AutoButtonColor = true
				send.ZIndex = 3
				instance.uicorner(send).CornerRadius = UDim.new(1, 0)

				local unhiddenusers = {}

				local tagdropdown = instance.frame(chat)
				tagdropdown.Name = "TagDropdown"
				tagdropdown.AnchorPoint = Vector2.new(1, 1)
				tagdropdown.Position = UDim2.new(1, -pad, 1, -barh - pad - 6)
				tagdropdown.Size = UDim2.new(0, 210, 0, 150)
				tagdropdown.BackgroundColor3 = theme.Card
				tagdropdown.BorderSizePixel = 0
				tagdropdown.Visible = false
				tagdropdown.ZIndex = 20
				instance.uicorner(tagdropdown).CornerRadius = UDim.new(0, 8)

				local tagstroke = instance.uistroke(tagdropdown)
				tagstroke.Color = theme.Stroke
				tagstroke.Thickness = 1

				local tagtitle = instance.textlabel(tagdropdown)
				tagtitle.Name = "TagTitle"
				tagtitle.BackgroundTransparency = 1
				tagtitle.Position = UDim2.new(0, 10, 0, 6)
				tagtitle.Size = UDim2.new(1, -20, 0, 18)
				tagtitle.Font = Enum.Font.GothamBold
				tagtitle.Text = "Tag a player"
				tagtitle.TextColor3 = theme.Text
				tagtitle.TextSize = 11
				tagtitle.TextXAlignment = Enum.TextXAlignment.Left
				tagtitle.ZIndex = 21

				local tagscroll = instance.scrollingframe(tagdropdown)
				tagscroll.Name = "TagScroll"
				tagscroll.Position = UDim2.new(0, 6, 0, 28)
				tagscroll.Size = UDim2.new(1, -12, 1, -34)
				tagscroll.BackgroundTransparency = 1
				tagscroll.BorderSizePixel = 0
				tagscroll.ScrollBarThickness = 2
				tagscroll.ScrollBarImageColor3 = theme.Track
				tagscroll.ScrollingDirection = Enum.ScrollingDirection.Y
				tagscroll.CanvasSize = UDim2.new(0, 0, 0, 0)
				tagscroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
				tagscroll.ZIndex = 21

				local taglayout = instance.uilistlayout(tagscroll)
				taglayout.Padding = UDim.new(0, 3)
				taglayout.SortOrder = Enum.SortOrder.LayoutOrder

				local function inserttag(name)
					local tagstr = "@" .. name .. " "
					if not box.Text:find(tagstr, 1, true) then
						if box.Text == "" or box.Text:sub(-1) == " " then
							box.Text = box.Text .. tagstr
						else
							box.Text = box.Text .. " " .. tagstr
						end
					end
					box:CaptureFocus()
					pcall(function()
						box.CursorPosition = #box.Text + 1
					end)
				end

				local function populatetagdropdown()
					for _, child in ipairs(tagscroll:GetChildren()) do
						if child:IsA("GuiObject") then
							pcall(function()
								child:Destroy()
							end)
						end
					end

					local list = {}
					for _, v in pairs(unhiddenusers) do
						table.insert(list, v)
					end
					table.sort(list, function(a, b)
						return (a.ts or 0) > (b.ts or 0)
					end)

					if #list == 0 then
						local empty = instance.textlabel(tagscroll)
						empty.BackgroundTransparency = 1
						empty.Size = UDim2.new(1, 0, 0, 50)
						empty.Font = Enum.Font.Gotham
						empty.Text = "No unhidden players in chat yet.\n(Hidden users cannot be tagged)"
						empty.TextColor3 = theme.Dim
						empty.TextSize = 11
						empty.TextWrapped = true
						empty.ZIndex = 22
						return
					end

					for idx, info in ipairs(list) do
						local uname = info.name
						local btn = instance.textbutton(tagscroll)
						btn.Name = "User_" .. uname
						btn.LayoutOrder = idx
						btn.BackgroundColor3 = theme.Element
						btn.BackgroundTransparency = 0
						btn.BorderSizePixel = 0
						btn.Size = UDim2.new(1, 0, 0, 24)
						btn.Font = Enum.Font.GothamMedium
						btn.Text = "  @" .. uname
						btn.TextColor3 = theme.Text
						btn.TextSize = 11
						btn.TextXAlignment = Enum.TextXAlignment.Left
						btn.AutoButtonColor = true
						btn.ZIndex = 22
						instance.uicorner(btn).CornerRadius = UDim.new(1, 0)

						btn.Activated:Connect(function()
							elevate()
							tagdropdown.Visible = false
							inserttag(uname)
						end)
					end
				end

				toggletagdropdown = function()
					elevate()
					tagdropdown.Visible = not tagdropdown.Visible
					if tagdropdown.Visible then
						populatetagdropdown()
					end
				end
				tagbtn.Activated:Connect(toggletagdropdown)

				local shown = 0

				local function nearbottom()
					local ok, result = pcall(function()
						return scroll.AbsoluteCanvasSize.Y - scroll.AbsoluteWindowSize.Y - scroll.CanvasPosition.Y < 40
					end)
					return not ok or result
				end

				local function scrolltobottom()
					task.defer(function()
						elevate()
						pcall(function()
							local y = scroll.AbsoluteCanvasSize.Y - scroll.AbsoluteWindowSize.Y
							scroll.CanvasPosition = Vector2.new(0, math.max(0, y))
						end)
					end)
				end

				local function trim()
					if shown <= maxshown then
						return
					end
					local oldest, oldestorder
					for _, child in ipairs(scroll:GetChildren()) do
						if child:IsA("GuiObject") then
							if not oldestorder or child.LayoutOrder < oldestorder then
								oldest, oldestorder = child, child.LayoutOrder
							end
						end
					end
					if oldest then
						pcall(function()
							oldest:Destroy()
						end)
					end
				end

				local function addline(richtext, ts)
					if not chat.Parent then
						return
					end
					local stick = nearbottom()
					shown = shown + 1
					local line = instance.textlabel(scroll)
					line.Name = "Line"
					line.LayoutOrder = shown
					line.BackgroundTransparency = 1
					line.Size = UDim2.new(1, 0, 0, 0)
					line.AutomaticSize = Enum.AutomaticSize.Y
					line.Font = Enum.Font.Gotham
					line.RichText = true
					line.Text = richtext
					line.TextColor3 = theme.Text
					line.TextSize = 11
					line.TextWrapped = true
					line.TextXAlignment = Enum.TextXAlignment.Center
					line.TextYAlignment = Enum.TextYAlignment.Top
					line.ZIndex = 3
					pcall(function()
						line:SetAttribute("ts", tonumber(ts) or os.time())
					end)
					trim()
					if stick then
						scrolltobottom()
					end
				end

				local function namecolor(name)
					local h = 0
					for i = 1, #name do
						h = (h * 31 + name:byte(i)) % 360
					end
					return Color3.fromHSV(h / 360, 0.42, 0.92)
				end

				local avatarsize = 26
				local nametoid = {}

				local rainbowowner = '<font color="#EF4444"><b>[OWNER]</b></font>'

				local function addmessage(msg, overridetext)
					if not chat.Parent then
						return
					end
					local stick = nearbottom()
					shown = shown + 1
					local name = tostring(msg.name or "??****")
					local mine = msg.mine == true
					local ts = tonumber(msg.ts) or os.time()
					local tint = namecolor(name)
					local rawav = tostring(msg.av or msg.uid or "")
					if rawav == "" and mine then
						rawav = localuserid()
					end

					-- owner badge only from what the server decided (by uid); the
					-- name is free text anyone can set to "Sena"
					local ownermsg = (msg.owner == true)
						or (msg.tier == "owner")
						or (mine and localowner)
					-- staff is decided by the server from the Roblox UserId, never by name
					local staffmsg = not ownermsg and (msg.staff == true or msg.tier == "staff")
					local staffhex = "#A855F7"

					local cleanname = name:gsub("%s*%[DONATOR%]", ""):gsub("%s*%[TRIAL%]", ""):gsub("%s*%[VIP%]", ""):gsub("%s*%[OWNER%]", ""):gsub("%s*%[STAFF%]", "")
					local hidden = (msg.hidden == true) or (name:find("%*") ~= nil)
					if ownermsg then
						cleanname = "Sena"
						hidden = false
					elseif staffmsg then
						hidden = false
					end

					local item = instance.frame(scroll)
					item.Name = "Msg"
					item.LayoutOrder = shown
					item.BackgroundTransparency = 1
					item.BorderSizePixel = 0
					item.Size = UDim2.new(1, 0, 0, 0)
					item.AutomaticSize = Enum.AutomaticSize.Y
					item.ZIndex = 3
					if mine then
						roundbg(item, 6, theme.Mine)
					end
					pcall(function()
						item:SetAttribute("ts", ts)
					end)

					local avatar = instance.imagelabel(item)
					avatar.Name = "Avatar"
					avatar.BackgroundColor3 = ownermsg and Color3.fromRGB(255, 255, 255)
						or (staffmsg and Color3.fromRGB(168, 85, 247))
						or tint
					avatar.BorderSizePixel = 0
					avatar.Position = UDim2.new(0, 6, 0, 5)
					avatar.Size = UDim2.new(0, avatarsize, 0, avatarsize)
					avatar.Image = ""
					avatar.ZIndex = 4
					instance.uicorner(avatar).CornerRadius = UDim.new(1, 0)

					local initial = nil
					local function showinitial()
						if initial then
							return
						end
						initial = instance.textlabel(avatar)
						initial.BackgroundTransparency = 1
						initial.Size = UDim2.new(1, 0, 1, 0)
						initial.Font = Enum.Font.GothamBold
						initial.Text = ownermsg and "S" or name:sub(1, 1):upper()
						initial.TextColor3 = Color3.fromRGB(255, 255, 255)
						initial.TextSize = 12
						initial.ZIndex = 5
					end

					local function applyheadshot(targetuid)
						if not avatar or not avatar.Parent then
							return
						end
						avatar.Image = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(targetuid) .. "&w=48&h=48"
						if initial then
							initial:Destroy()
							initial = nil
						end
					end

					local av = rawav
					if ownermsg then
						av = "8478064806"
						applyheadshot(av)
					elseif av:match("^%d+$") and av ~= "0" then
						applyheadshot(av)
					elseif not name:find("%*") and name ~= "" then
						if nametoid[name] then
							applyheadshot(nametoid[name])
						else
							showinitial()
							task.spawn(function()
								elevate()
								local ingame = sv.plrs:FindFirstChild(name)
								if ingame and ingame.UserId > 0 then
									nametoid[name] = tostring(ingame.UserId)
									applyheadshot(ingame.UserId)
								end
							end)
						end
					else
						showinitial()
					end

					local left = 6 + avatarsize + 9
					if not hidden and cleanname ~= "" and cleanname:lower() ~= "unknown" then
						unhiddenusers[cleanname] = {
							name = cleanname,
							av = ownermsg and "8478064806" or av,
							ts = ts,
						}
					end

					item.InputBegan:Connect(function(input)
						if
							input.UserInputType == Enum.UserInputType.MouseButton1
							or input.UserInputType == Enum.UserInputType.Touch
						then
							elevate()
							if hidden then
								systemline("Cannot tag " .. cleanname .. " — user has Hide Name ON")
							else
								inserttag(cleanname)
								systemline("Tagged @" .. cleanname)
							end
						end
					end)

					local trialmsg = not ownermsg and not staffmsg
						and ((msg.trial == true) or (msg.tier == "trial") or (name:find("%[TRIAL%]") ~= nil) or (mine and istrial()))
					local donatormsg = not ownermsg
						and not staffmsg
						and not trialmsg
						and ((msg.donator == true) or (msg.tier == "donator") or (name:find("%[DONATOR%]") ~= nil) or (mine and isdonator()))

					local whocolor = ownermsg and "#FFFFFF" or (staffmsg and staffhex) or (mine and minehex or hexcolor(tint))
					local whotext = string.format('<font color="%s"><b>%s</b></font>', whocolor, escaperich(cleanname))
					if ownermsg then
						whotext = whotext .. "  " .. rainbowowner
					elseif staffmsg then
						whotext = whotext .. '  <font color="' .. staffhex .. '"><b>[STAFF]</b></font>'
					elseif donatormsg then
						whotext = whotext .. '  <font color="' .. goldhex .. '"><b>DONATOR</b></font>'
					elseif trialmsg then
						whotext = whotext .. '  <font color="' .. bluehex .. '"><b>TRIAL</b></font>'
					end
					if msg.pm then
						whotext = '<font color="' .. goldhex .. '">PM</font>  ' .. whotext
						if mine and msg.to_name then
							whotext = whotext .. '  <font color="' .. dimhex .. '">to</font>  <font color="' .. goldhex .. '">' .. escaperich(msg.to_name) .. "</font>"
						end
					end

					local who = instance.textlabel(item)
					who.Name = "Who"
					who.BackgroundTransparency = 1
					who.Position = UDim2.new(0, left, 0, 5)
					who.Size = UDim2.new(1, -left - 8, 0, 14)
					who.Font = Enum.Font.GothamBold
					who.RichText = true
					who.Text = string.format(
						'%s  <font color="%s" size="10">%s · %s</font>',
						whotext,
						dimhex,
						escaperich(msg.game or "?"),
						os.date("%H:%M", ts)
					)
					who.TextColor3 = theme.Text
					who.TextSize = 12
					who.TextXAlignment = Enum.TextXAlignment.Left
					who.TextTruncate = Enum.TextTruncate.AtEnd
					who.ZIndex = 4

					local rawbody = tostring(overridetext or msg.text or "")
					local escapedbody = escaperich(rawbody)
					local myuname = localusername()
					local mydname = localdisplayname()
					if mydname == "" then
						mydname = myuname
					end
					local mentionedme = false

					local formattedbody = escapedbody:gsub("@([%w_]+)", function(taguser)
						local isme = (taguser:lower() == myuname:lower())
							or (taguser:lower() == mydname:lower())
							or (localowner and taguser:lower() == "sena")
						if isme then
							mentionedme = true
							return '<font color="' .. goldhex .. '"><b>@' .. taguser .. "</b></font>"
						end
						return '<font color="' .. bluehex .. '"><b>@' .. taguser .. "</b></font>"
					end)

					if mentionedme and not mine then
						local mentionstroke = instance.uistroke(item)
						mentionstroke.Color = theme.Gold
						mentionstroke.Thickness = 1
						mentionstroke.Transparency = 0.4
						local mentionbg = item:FindFirstChild("Bg") or roundbg(item, 6, theme.Mention)
						mentionbg.ImageColor3 = theme.Mention
					end

					local body = instance.textlabel(item)
					body.Name = "Body"
					body.BackgroundTransparency = 1
					body.Position = UDim2.new(0, left, 0, 21)
					body.Size = UDim2.new(1, -left - 8, 0, 0)
					body.AutomaticSize = Enum.AutomaticSize.Y
					body.Font = Enum.Font.Gotham
					body.RichText = true
					body.Text = formattedbody
					body.TextColor3 = mine and theme.Text or theme.SubText
					body.TextSize = 12
					body.TextWrapped = true
					body.TextXAlignment = Enum.TextXAlignment.Left
					body.TextYAlignment = Enum.TextYAlignment.Top
					body.ZIndex = 4

					trim()
					if stick then
						scrolltobottom()
					end
				end

				local roombuttons = {}
				local roomunread = {}
				local roommessages = {}
				for _, r in ipairs(rooms) do
					roomunread[r.id] = 0
					roommessages[r.id] = {}
				end

				updatecategorybuttons = function()
					elevate()
					for _, r in ipairs(rooms) do
						local entry = roombuttons[r.id]
						if entry then
							local selected = (activeroom == r.id)
							local unread = roomunread[r.id] or 0
							local text = r.label
							if not selected and unread > 0 then
								text = string.format('%s  <font color="%s">●</font>', r.label, badhex)
							end
							entry.label.Text = text
							entry.frame.BackgroundColor3 = selected and guiconfig.Color or theme.Element
							entry.frame.BackgroundTransparency = 0
							entry.label.TextColor3 = selected and theme.AccentText or theme.SubText
							entry.stroke.Transparency = selected and 1 or 0.35
						end
					end
				end

				switchroom = function(targetroom)
					elevate()
					if not roommessages[targetroom] then
						targetroom = "general"
					end
					activeroom = targetroom
					roomunread[activeroom] = 0
					updatecategorybuttons()

					if mode ~= "pm" then
						box.PlaceholderText = "Message in #" .. activeroom .. "..."
					end

					task.defer(function()
						elevate()
						pcall(function()
							local entry = roombuttons[targetroom]
							local btn = entry and entry.frame
							if btn and catbar.Parent then
								local relx = btn.AbsolutePosition.X - catbar.AbsolutePosition.X + catbar.CanvasPosition.X
								local btnw = btn.AbsoluteSize.X
								local vieww = catbar.AbsoluteWindowSize.X
								if relx < catbar.CanvasPosition.X then
									catbar.CanvasPosition = Vector2.new(math.max(0, relx - 6), 0)
								elseif relx + btnw > catbar.CanvasPosition.X + vieww then
									local maxscroll = math.max(0, catbar.AbsoluteCanvasSize.X - vieww)
									catbar.CanvasPosition = Vector2.new(math.min(maxscroll, relx + btnw - vieww + 6), 0)
								end
							end
						end)
					end)

					for _, child in ipairs(scroll:GetChildren()) do
						if child:IsA("GuiObject") then
							pcall(function()
								child:Destroy()
							end)
						end
					end
					shown = 0

					for _, entry in ipairs(roommessages[activeroom] or {}) do
						if entry.type == "msg" then
							addmessage(entry.data, entry.cleanbody)
						elseif entry.type == "line" then
							addline(entry.text, entry.ts)
						end
					end
					scrolltobottom()
				end

				for idx, r in ipairs(rooms) do
					local rid = r.id
					local frame, label, stroke = pill(catbar, "Room_" .. rid, r.label, true)
					frame.LayoutOrder = idx
					roombuttons[rid] = { frame = frame, label = label, stroke = stroke }
					frame.Activated:Connect(function()
						switchroom(rid)
					end)
				end
				updatecategorybuttons()

				local function chatonscreen()
					return chatenabled
						and chat.Parent ~= nil
						and opensection
						and chloeex.Enabled
						and dropshadowholder.Visible
						and layerspagelayout.CurrentPage == scrollayers
				end

				local renderqueue = {}
				local flushqueued = false
				local function pushrender(entry)
					if not chatonscreen() then
						chatdirty = true
						return
					end
					renderqueue[#renderqueue + 1] = entry
					if flushqueued then
						return
					end
					flushqueued = true
					task.delay(0.2, function()
						flushqueued = false
						elevate()
						local batch = renderqueue
						renderqueue = {}
						if not chatonscreen() then
							chatdirty = true
							return
						end
						if #batch > maxshown then
							switchroom(activeroom)
							return
						end
						for _, e in ipairs(batch) do
							if e[1] == "msg" then
								addmessage(e[2], e[3])
							else
								addline(e[2], e[3])
							end
						end
					end)
				end

				local function refreshifdirty()
					if chatdirty and chatonscreen() then
						chatdirty = false
						renderqueue = {}
						switchroom(activeroom)
					end
				end

				local function notifymention(msg, text)
					if msg.mine == true or (tonumber(msg.ts) or os.time()) < os.time() - 60 then
						return
					end
					local me = localusername():lower()
					local dn = localdisplayname():lower()
					for tag in tostring(text or ""):gmatch("@([%w_]+)") do
						local t = tag:lower()
						if t == me or (dn ~= "" and t == dn) or (localowner and t == "sena") then
							pcall(function()
								Chloex:Notify({
									Title = "Sena",
									Description = "Live Chat",
									Content = tostring(msg.name or "Someone") .. " mentioned you in chat",
									Duration = 4,
									Color = theme.Gold,
								})
							end)
							return
						end
					end
				end

				local function expire()
					local cutoff = os.time() - chatttl()
					for _, child in ipairs(scroll:GetChildren()) do
						if child:IsA("GuiObject") then
							local ts = tonumber(child:GetAttribute("ts")) or 0
							if ts < cutoff then
								pcall(function()
									child:Destroy()
								end)
							end
						end
					end
					for _, list in pairs(roommessages) do
						while #list > 0 and (tonumber(list[1].ts) or 0) < cutoff do
							table.remove(list, 1)
						end
					end
				end

				local function append(msg)
					if type(msg) ~= "table" then
						return
					end
					local ts = tonumber(msg.ts) or os.time()
					if ts < os.time() - chatttl() then
						return
					end

					if msg.pm then
						for _, r in ipairs(rooms) do
							local list = roommessages[r.id]
							if list then
								list[#list + 1] = { type = "msg", data = msg, cleanbody = msg.text, ts = ts }
								if #list > maxshown then
									table.remove(list, 1)
								end
							end
						end
						notifymention(msg, msg.text)
						pushrender({ "msg", msg, msg.text })
						return
					end

					local room, cleanbody = parsemessageroom(msg)
					local list = roommessages[room] or roommessages.general
					list[#list + 1] = { type = "msg", data = msg, cleanbody = cleanbody, ts = ts }
					if #list > maxshown then
						table.remove(list, 1)
					end

					notifymention(msg, cleanbody)
					if room == activeroom then
						pushrender({ "msg", msg, cleanbody })
					else
						roomunread[room] = (roomunread[room] or 0) + 1
						updatecategorybuttons()
					end
				end

				systemline = function(text)
					local ts = os.time()
					local formatted = '<font color="' .. dimhex .. '"><i>' .. escaperich(text) .. "</i></font>"
					for _, r in ipairs(rooms) do
						local list = roommessages[r.id]
						if list then
							list[#list + 1] = { type = "line", text = formatted, ts = ts }
							if #list > maxshown then
								table.remove(list, 1)
							end
						end
					end
					pushrender({ "line", formatted, ts })
				end

				local sending = false
				local lastsent = -math.huge

				-- Maintenance (/pauseglobalchat): the bot refuses sends anyway; this keeps the box honest
				local chatpause = { chat = false, dm = false, msg = "" }
				local function sendblocked()
					if mode == "pm" then
						return chatpause.dm
					end
					return chatpause.chat
				end

				local function setsend(enabled, label)
					if enabled and sendblocked() then
						enabled, label = false, "Paused"
					end
					send.Text = label or "Send"
					send.Active = enabled
					send.BackgroundColor3 = enabled and guiconfig.Color or theme.Track
					send.TextColor3 = enabled and theme.AccentText or theme.SubText
				end

				local function countdown(seconds)
					for i = seconds, 1, -1 do
						if not chat.Parent then
							return
						end
						setsend(false, tostring(i) .. "s")
						task.wait(1)
					end
				end

				local function applypause()
					if sendblocked() then
						box.PlaceholderText = mode == "pm" and "Private messages are paused (maintenance)"
							or "Global chat is under maintenance"
						setsend(false, "Paused")
					else
						box.PlaceholderText = (mode == "pm" and pmtarget) and ("Private message to " .. pmtarget .. "...")
							or ("Message in #" .. activeroom .. "...")
						if not sending and send.Text == "Paused" then
							setsend(true, "Send")
						end
					end
				end

				setmode = function(m, target)
					elevate()
					if m == "pm" then
						if target and target ~= "" then
							pmtarget = tostring(target):gsub("^@", "")
						end
						if not pmtarget then
							systemline("Pick someone first: /pm <player>")
							return
						end
						mode = "pm"
						modelabel.Text = '<font color="' .. goldhex .. '">PM</font>  ' .. escaperich(pmtarget)
						box.PlaceholderText = "Private message to " .. pmtarget .. "..."
					else
						mode = "global"
						modelabel.Text = "Rooms"
						box.PlaceholderText = "Message in #" .. activeroom .. "..."
					end
					applypause()
				end

				modebtn.Activated:Connect(function()
					if mode == "global" then
						setmode("pm")
					else
						setmode("global")
					end
				end)

				local function togglehidename()
					elevate()
					hidename = not hidename
					if getgenv then
						getgenv().SenaHideName = hidename
					end
					if _G then
						_G.SenaHideName = hidename
					end
					Chloex.HideName = hidename
					hidelabel.Text = hidetext()
					systemline("Name visibility: " .. (hidename and "Hidden (Anonymous — others cannot tag you)" or "Public (Real Name — taggable)"))
				end
				hidebtn.Activated:Connect(togglehidename)

				local function help()
					systemline("Commands:")
					systemline("/help - this list")
					systemline("/hide or /anon - toggle hiding your name (anonymous mode)")
					systemline("/tag <player> - mention an unhidden player (or click @)")
					systemline("/pm <player> [message] - private message (switches you to PM mode)")
					systemline("/global or /gen - switch to General room")
					systemline("/id  /ph  /vn  /br - switch room")
					systemline("/requestjoin <player> - ask to join their server")
					systemline("/accept  /decline - answer the latest join request")
					systemline("Tip: click the room pills at the top to change room.")
				end

				local roomcommands = {
					global = "general", g = "general", all = "general", gen = "general", general = "general",
					id = "indonesian", indo = "indonesian", indonesia = "indonesian", indonesian = "indonesian",
					ph = "philippines", philippines = "philippines", filipino = "philippines", pinoy = "philippines",
					vn = "vietnam", vietnam = "vietnam", vietnamese = "vietnam",
					br = "brazilian", brazil = "brazilian", brazilian = "brazilian", brasil = "brazilian",
				}

				local function runcommand(text)
					local cmd, rest = text:match("^/(%w+)%s*(.*)$")
					if not cmd then
						return text
					end
					cmd = cmd:lower()

					if cmd == "help" or cmd == "h" or cmd == "cmd" then
						help()
						return nil
					elseif roomcommands[cmd] then
						local room = roomcommands[cmd]
						switchroom(room)
						setmode("global")
						systemline(room:sub(1, 1):upper() .. room:sub(2) .. " room")
						return nil
					elseif cmd == "pm" or cmd == "w" or cmd == "msg" or cmd == "dm" then
						local who, body = rest:match("^(%S+)%s*(.*)$")
						if not who then
							systemline("Usage: /pm <player> [message]")
							return nil
						end
						setmode("pm", who)
						if body == "" then
							systemline("PM mode: everything you type now goes to " .. tostring(pmtarget))
							return nil
						end
						return body
					elseif cmd == "requestjoin" or cmd == "rj" or cmd == "join" then
						local cleanrest = rest:gsub("^[%.%s@\"']+", ""):gsub("[\"']+$", "")
						local who = cleanrest:match("^(%S+)")
						if not who or who == "" then
							systemline("Usage: /requestjoin <player username or display name>")
							return nil
						end
						task.spawn(function()
							elevate()
							local ok, res = Chloex:RequestJoin(who)
							if ok then
								systemline("Asked " .. tostring(res or who) .. " to join their server. Waiting for the answer...")
							else
								systemline("Request join failed: " .. tostring(res))
							end
						end)
						return nil
					elseif cmd == "hide" or cmd == "anon" or cmd == "incognito" then
						togglehidename()
						return nil
					elseif cmd == "unhide" or cmd == "showname" then
						if hidename then
							togglehidename()
						end
						return nil
					elseif cmd == "tag" or cmd == "mention" then
						local target = rest:match("^(%S+)")
						if not target or target == "" then
							toggletagdropdown()
							return nil
						end
						target = target:gsub("^@", "")
						local found = nil
						for uname in pairs(unhiddenusers) do
							if uname:lower() == target:lower() then
								found = uname
								break
							end
						end
						if found then
							inserttag(found)
							systemline("Tagged @" .. found)
						else
							systemline("Player '" .. target .. "' not found or has Hide Name ON")
						end
						return nil
					elseif cmd == "accept" or cmd == "decline" or cmd == "deny" then
						if not lastincoming then
							systemline("No join request waiting")
							return nil
						end
						local id = lastincoming
						lastincoming = nil
						local accept = cmd == "accept"
						task.spawn(function()
							elevate()
							local ok, err = Chloex:AnswerJoin(id, accept)
							if ok then
								systemline(accept and "Accepted, they are on the way." or "Declined.")
							else
								systemline("Could not answer: " .. tostring(err))
							end
						end)
						return nil
					end

					systemline("Unknown command. /help")
					return nil
				end

				local function submit()
					elevate()
					if sending then
						return
					end
					local text = box.Text:gsub("^%s+", ""):gsub("%s+$", "")
					if text == "" then
						return
					end
					if text:sub(1, 1) == "/" then
						local out = runcommand(text)
						box.Text = ""
						if not out or out == "" then
							return
						end
						text = out
					end

					local limit = maxlength()
					if #text > limit then
						text = text:sub(1, limit)
					end

					if sendblocked() then
						systemline((mode == "pm" and "Private messages are" or "Global chat is") .. " under maintenance"
							.. (chatpause.msg ~= "" and (": " .. chatpause.msg) or ""))
						return
					end

					local remaining = cooldown - (os.clock() - lastsent)
					if remaining > 0 then
						systemline("Wait " .. tostring(math.ceil(remaining)) .. "s before sending again")
						return
					end

					sending = true
					setsend(false, "...")
					local sendroom = activeroom
					task.spawn(function()
						elevate()
						local ok, err
						if mode == "pm" then
							ok, err = Chloex:SendDM(pmtarget, text)
						else
							ok, err = Chloex:SendChat(text, sendroom, hidename)
						end
						if ok then
							lastsent = os.clock()
							box.Text = ""
							countdown(cooldown)
						else
							err = tostring(err or "")
							local wait = err:match("^cooldown:(%d+)")
							if wait then
								systemline("Slow down, " .. wait .. "s left")
								countdown(tonumber(wait) or cooldown)
							elseif err:match("^maintenance") then
								local why = err:match("^maintenance:(.*)") or ""
								systemline("Chat is under maintenance" .. (why ~= "" and (": " .. why) or ""))
							elseif err == "no response" then
								systemline("Chat server not reachable")
							else
								systemline("Failed to send: " .. err)
							end
						end
						sending = false
						if chat.Parent then
							setsend(true, "Send")
						end
					end)
				end

				box.Focused:Connect(function()
					elevate()
					box.BackgroundColor3 = theme.ElementHover
					boxstroke.Transparency = 0
				end)
				box.FocusLost:Connect(function(enterpressed)
					elevate()
					box.BackgroundColor3 = theme.Element
					boxstroke.Transparency = 0.35
					if enterpressed then
						submit()
					end
				end)
				box:GetPropertyChangedSignal("Text"):Connect(function()
					local limit = maxlength()
					if #box.Text > limit then
						box.Text = box.Text:sub(1, limit)
					end
				end)
				send.Activated:Connect(submit)

				local chatbackend = Chloex:GetBackend()
				if not chatbackend then
					local ok, cfg = pcall(function()
						return getgenv and getgenv().SenaBackend
					end)
					chatbackend = Chloex:ConnectBackend((ok and type(cfg) == "table") and cfg or {})
				end

				if not chatbackend then
					systemline("Not connected. Call Chloex:ConnectBackend({ Api = ..., Key = ..., Game = ... }) first.")
					setsend(false, "Send")
					onlinelabel.Text = '<font color="' .. badhex .. '">●</font>  offline'
				else
					Chloex:OnChat(function(msg)
						if chat.Parent and chatenabled then
							append(msg)
						end
					end)
					Chloex:OnPause(function(p)
						if not chat.Parent then
							return
						end
						local was = chatpause.chat
						chatpause.chat = p.chat == true
						chatpause.dm = p.dm == true
						chatpause.msg = tostring(p.chatmsg or "")
						if chatpause.chat ~= was then
							systemline(chatpause.chat
								and ("Global chat is under maintenance" .. (chatpause.msg ~= "" and (": " .. chatpause.msg) or ""))
								or "Global chat is back on")
						end
						applypause()
					end)
					Chloex:OnDM(function(msg)
						if chat.Parent and chatenabled then
							append(msg)
						end
					end)
					Chloex:OnJoin(function(req)
						if not chat.Parent then
							return
						end
						local status = tostring(req.status or "")
						if req.incoming then
							if status == "pending" then
								lastincoming = req.id
								systemline(tostring(req.name or "Someone") .. " wants to join your server - /accept or /decline (or use the popup)")
							end
						elseif status == "accepted" then
							systemline(tostring(req.to_name or "They") .. " accepted your request, teleporting...")
						elseif status == "declined" then
							systemline(tostring(req.to_name or "They") .. " declined your request")
						elseif status == "expired" then
							systemline(tostring(req.to_name or "They") .. " did not answer")
						end
					end)

					task.spawn(function()
						elevate()
						local ticks = 0
						local lasttext = nil
						while chat.Parent and not Chloex.Unloaded do
							ticks = ticks + 1
							if chatonscreen() then
								refreshifdirty()
								if ticks % 5 == 0 then
									local text
									if chatbackend.Connected then
										text = '<font color="' .. goodhex .. '">●</font>  ' .. tostring(chatbackend.Online) .. " online"
									else
										text = '<font color="' .. badhex .. '">●</font>  reconnecting'
									end
									if text ~= lasttext then
										lasttext = text
										onlinelabel.Text = text
									end
								end
							end
							if chatenabled and ticks % 30 == 0 then
								expire()
							end
							task.wait(1)
						end
					end)
				end

				setchatenabled = function(on, silent)
					elevate()
					chatenabled = on == true
					if not silent then
						savechatpref(chatenabled)
					end
					powerlabel.Text = chatenabled and ('<font color="' .. goodhex .. '">●</font>  Chat On')
						or ('<font color="' .. badhex .. '">●</font>  Chat Off')
					catbar.Visible = chatenabled
					scroll.Visible = chatenabled
					bar.Visible = chatenabled
					modebtn.Visible = chatenabled
					hidebtn.Visible = chatenabled
					onlinepill.Visible = chatenabled
					if tagdropdown then
						tagdropdown.Visible = false
					end
					offcard.Visible = not chatenabled
					chat.Size = UDim2.new(1, 0, 0, chatenabled and height or (headerh + offh))
					renderqueue = {}
					if chatenabled then
						local b = Chloex:GetBackend()
						for _, r in ipairs(rooms) do
							roommessages[r.id] = {}
						end
						if b then
							for _, msg in ipairs(b.History or {}) do
								append(msg)
							end
							for _, msg in ipairs(b.DmHistory or {}) do
								append(msg)
							end
						end
						chatdirty = true
						refreshifdirty()
					else
						for _, r in ipairs(rooms) do
							roommessages[r.id] = {}
						end
						for _, child in ipairs(scroll:GetChildren()) do
							if child:IsA("GuiObject") then
								child:Destroy()
							end
						end
						shown = 0
					end
				end
				powerbtn.Activated:Connect(function()
					setchatenabled(not chatenabled)
				end)
				onbtn.Activated:Connect(function()
					setchatenabled(true)
				end)
				setchatenabled(chatenabled, true)
				layerspagelayout:GetPropertyChangedSignal("CurrentPage"):Connect(function()
					task.defer(refreshifdirty)
				end)

				registerSearchItem(chatconfig.Title, chat)
				countitem = countitem + 1
				yieldbuild()

				local chatfunc = {}

				function chatfunc:SetEnabled(on)
					setchatenabled(on)
				end

				function chatfunc:IsEnabled()
					return chatenabled
				end

				function chatfunc:Append(msg)
					append(msg)
				end

				function chatfunc:System(text)
					systemline(text)
				end

				function chatfunc:SetRoom(room)
					switchroom(room)
				end

				function chatfunc:GetRoom()
					return activeroom
				end

				function chatfunc:Clear()
					for _, r in ipairs(rooms) do
						roommessages[r.id] = {}
					end
					for _, child in ipairs(scroll:GetChildren()) do
						if child:IsA("GuiObject") then
							pcall(function()
								child:Destroy()
							end)
						end
					end
					shown = 0
				end

				function chatfunc:Send(text)
					box.Text = tostring(text or "")
					submit()
				end

				return chatfunc
			end

			items.AddChat = items.AddLiveChat

			function items:AddSupportCard(cardconfig)
				cardconfig = cardconfig or {}
				local cardtitle = tostring(cardconfig.Title or "Get Key & Support Sena")
				local carddesc = tostring(
					cardconfig.Description
						or cardconfig.Content
						or "Complete checkpoint verification at senahub.xyz/key for free 12h access, or upgrade to Donator VIP for permanent execution and zero wait."
				)
				local freekeyurl = tostring(cardconfig.FreeKeyUrl or "https://senahub.xyz/key")
				local donateurl = tostring(cardconfig.Url or cardconfig.Link or "https://senahub.xyz/#donator")
				local discordurl = tostring(cardconfig.Discord or "https://dsc.gg/senahub")

				local card = instance.frame(sectionadd)
				card.Name = "SupportCard"
				card.BorderSizePixel = 0
				card.LayoutOrder = countitem
				card.Size = UDim2.new(1, 0, 0, 0)
				card.AutomaticSize = Enum.AutomaticSize.Y
				roundbg(card, 4, theme.Row, true)

				local cardpad = instance.uipadding(card)
				cardpad.PaddingLeft = UDim.new(0, 10)
				cardpad.PaddingRight = UDim.new(0, 10)
				cardpad.PaddingTop = UDim.new(0, 10)
				cardpad.PaddingBottom = UDim.new(0, 10)

				local cardlayout = instance.uilistlayout(card)
				cardlayout.Padding = UDim.new(0, 8)
				cardlayout.SortOrder = Enum.SortOrder.LayoutOrder
				cardlayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

				local order = 0
				local function nextorder()
					order = order + 1
					return order
				end

				local function label(parent, text, size, color, font, xalign, layoutorder, fixedheight)
					local lbl = instance.textlabel(parent)
					lbl.BackgroundTransparency = 1
					lbl.LayoutOrder = layoutorder or 0
					lbl.Font = font or Enum.Font.GothamBold
					lbl.RichText = true
					lbl.Text = text
					lbl.TextColor3 = color or theme.Text
					lbl.TextSize = size or 12
					lbl.TextWrapped = true
					lbl.TextXAlignment = xalign or Enum.TextXAlignment.Left
					lbl.TextYAlignment = Enum.TextYAlignment.Top
					if fixedheight then
						lbl.Size = UDim2.new(1, 0, 0, fixedheight)
					else
						lbl.Size = UDim2.new(1, 0, 0, 0)
						lbl.AutomaticSize = Enum.AutomaticSize.Y
					end
					return lbl
				end

				local function box(parent, layoutorder, transparency)
					local frame = instance.frame(parent)
					frame.BorderSizePixel = 0
					frame.LayoutOrder = layoutorder
					frame.Size = UDim2.new(1, 0, 0, 0)
					frame.AutomaticSize = Enum.AutomaticSize.Y
					roundbg(frame, 4, theme.Box, true)

					local pad = instance.uipadding(frame)
					pad.PaddingLeft = UDim.new(0, 10)
					pad.PaddingRight = UDim.new(0, 10)
					pad.PaddingTop = UDim.new(0, 8)
					pad.PaddingBottom = UDim.new(0, 8)

					local layout = instance.uilistlayout(frame)
					layout.Padding = UDim.new(0, 4)
					layout.SortOrder = Enum.SortOrder.LayoutOrder
					return frame
				end

				local function button(parent, text, layoutorder, accent)
					local btn = instance.textbutton(parent)
					btn.LayoutOrder = layoutorder or 0
					btn.Size = UDim2.new(1, 0, 0, 30)
					btn.BorderSizePixel = 0
					btn.Font = Enum.Font.GothamBold
					btn.Text = text
					btn.TextColor3 = accent and theme.AccentText or Color3.fromRGB(255, 255, 255)
					btn.TextTransparency = accent and 0 or 0.3
					btn.TextSize = 12
					btn.TextTruncate = Enum.TextTruncate.AtEnd
					btn.AutoButtonColor = false
					if accent then
						hoverbg(btn, roundbg(btn, 4, guiconfig.Color), guiconfig.Color, Color3.fromRGB(255, 255, 255))
					else
						hoverbg(btn, roundbg(btn, 4, theme.Inner), theme.Inner, theme.InnerHover)
					end
					btn.MouseButton1Down:Connect(function()
						pcall(pesseffect, btn)
					end)
					return btn
				end

				local header = instance.frame(card)
				header.BackgroundTransparency = 1
				header.LayoutOrder = nextorder()
				header.Size = UDim2.new(1, 0, 0, 0)
				header.AutomaticSize = Enum.AutomaticSize.Y
				local headerlayout = instance.uilistlayout(header)
				headerlayout.Padding = UDim.new(0, 3)
				headerlayout.SortOrder = Enum.SortOrder.LayoutOrder

				local titlelabel = label(header, cardtitle, 14, theme.Text, Enum.Font.GothamBold, Enum.TextXAlignment.Center, 1)
				local desclabel = label(header, carddesc, 11, theme.SubText, Enum.Font.Gotham, Enum.TextXAlignment.Center, 2)

				local pricing = instance.frame(card)
				pricing.BackgroundTransparency = 1
				pricing.LayoutOrder = nextorder()
				pricing.Size = UDim2.new(1, 0, 0, 0)
				pricing.AutomaticSize = Enum.AutomaticSize.Y
				local pricinglayout = instance.uilistlayout(pricing)
				pricinglayout.FillDirection = Enum.FillDirection.Horizontal
				pricinglayout.Padding = UDim.new(0, 8)
				pricinglayout.SortOrder = Enum.SortOrder.LayoutOrder
				pricinglayout.VerticalAlignment = Enum.VerticalAlignment.Top

				local function tier(layoutorder, badge, price, sub, highlight)
					local t = box(pricing, layoutorder)
					t.Size = UDim2.new(0.5, -4, 0, 0)
					if highlight then
						local s = instance.uistroke(t)
						s.Color = guiconfig.Color
						s.Thickness = 1
						s.Transparency = 0.6
					end
					label(t, badge, 10, theme.SubText, Enum.Font.GothamBold, nil, 1, 14)
					label(t, price, 15, theme.Text, Enum.Font.GothamBold, nil, 2, 20)
					label(t, sub, 10, theme.Dim, Enum.Font.Gotham, nil, 3, 14)
					return t
				end

				tier(1, "7 DAYS ACCESS", tostring(cardconfig.WeeklyPrice or "$1.00 USD"), tostring(cardconfig.WeeklySub or "Rp 15.000 / Weekly Access"), false)
				tier(2, "30 DAYS ACCESS", tostring(cardconfig.MonthlyPrice or "$2.00 USD"), tostring(cardconfig.MonthlySub or "Rp 30.000 / Monthly (Stacks)"), true)

				local benefits = box(card, nextorder())
				label(benefits, "DONATOR VIP BENEFITS", 11, theme.Text, Enum.Font.GothamBold, nil, 1, 16)
				local benefitlist = cardconfig.Benefits or {
					{ "Early Updates", "first access to new scripts, game updates and bypasses before public release" },
					{ "More Features Unlocked", "donator-only modules and every locked toggle in this hub" },
					{ "Suggestion Priority", "your feature requests and bug reports get handled first" },
					{ "Private Key & Multi-Device", "dedicated key with up to 3 HWID slots and self-service reset" },
				}
				for i, b in ipairs(benefitlist) do
					label(
						benefits,
						string.format("•  <b>%s</b> — %s", escaperich(b[1] or b.Title or ""), escaperich(b[2] or b.Description or "")),
						10,
						theme.SubText,
						Enum.Font.Gotham,
						nil,
						i + 1
					)
				end

				local tutorial = box(card, nextorder())
				label(tutorial, "HOW TO GET YOUR KEY", 11, theme.Text, Enum.Font.GothamBold, nil, 1, 16)
				local steps = cardconfig.Steps or {
					"Visit <b>senahub.xyz</b> (or press Get VIP below)",
					"Pick a VIP Pass (7D / 30D) and pay via instant QRIS",
					"Your private key shows up on screen right away — copy it",
					"<b>OPTIONAL:</b> enter your Discord username at checkout to receive the VIP role automatically",
				}
				for i, text in ipairs(steps) do
					local row = instance.frame(tutorial)
					row.BackgroundTransparency = 1
					row.LayoutOrder = i + 1
					row.Size = UDim2.new(1, 0, 0, 0)
					row.AutomaticSize = Enum.AutomaticSize.Y

					local num = instance.frame(row)
					num.BorderSizePixel = 0
					num.Size = UDim2.new(0, 18, 0, 18)
					roundbg(num, 4, theme.Inner)

					local numtext = instance.textlabel(num)
					numtext.BackgroundTransparency = 1
					numtext.Size = UDim2.new(1, 0, 1, 0)
					numtext.Font = Enum.Font.GothamBold
					numtext.Text = tostring(i)
					numtext.TextColor3 = theme.Text
					numtext.TextSize = 10

					local steptext = label(row, text, 10, theme.SubText, Enum.Font.Gotham, nil, 2)
					steptext.Position = UDim2.new(0, 24, 0, 0)
					steptext.Size = UDim2.new(1, -24, 0, 0)
				end

				local actions = instance.frame(card)
				actions.BackgroundTransparency = 1
				actions.LayoutOrder = nextorder()
				actions.Size = UDim2.new(1, 0, 0, 0)
				actions.AutomaticSize = Enum.AutomaticSize.Y
				local actionlayout = instance.uilistlayout(actions)
				actionlayout.Padding = UDim.new(0, 6)
				actionlayout.SortOrder = Enum.SortOrder.LayoutOrder

				local freekeybtn = button(actions, "Get Free Key (12h Access via Checkpoint)", 1, false)

				local subrow = instance.frame(actions)
				subrow.BackgroundTransparency = 1
				subrow.LayoutOrder = 2
				subrow.Size = UDim2.new(1, 0, 0, 30)
				local sublayout = instance.uilistlayout(subrow)
				sublayout.FillDirection = Enum.FillDirection.Horizontal
				sublayout.Padding = UDim.new(0, 6)
				sublayout.SortOrder = Enum.SortOrder.LayoutOrder

				local discordbtn = button(subrow, "Join Discord", 1, false)
				discordbtn.Size = UDim2.new(0.5, -3, 1, 0)
				local vipbtn = button(subrow, "Get VIP (senahub.xyz)", 2, false)
				vipbtn.Size = UDim2.new(0.5, -3, 1, 0)

				local function copyaction(url, btn, origtext, successtext)
					elevate()
					clipboardwrite(url)
					if type(openurl) == "function" then
						pcall(openurl, url)
					end
					Chloex:Notify({ Title = "Sena", Description = "Link Copied", Content = url, Duration = 4, Color = theme.Good })
					btn.Text = successtext
					task.delay(2.5, function()
						if btn and btn.Parent then
							btn.Text = origtext
						end
					end)
				end

				freekeybtn.Activated:Connect(function()
					copyaction(freekeyurl, freekeybtn, "Get Free Key (12h Access via Checkpoint)", "Copied Key Link! ✓")
				end)
				discordbtn.Activated:Connect(function()
					copyaction(discordurl, discordbtn, "Join Discord", "Copied Discord Link! ✓")
				end)
				vipbtn.Activated:Connect(function()
					copyaction(donateurl, vipbtn, "Get VIP (senahub.xyz)", "Copied Website Link! ✓")
				end)

				local keybox = box(card, nextorder())

				local donator = isdonator()
				local doninfo = Chloex.DonatorInfo or (getgenv and getgenv().SenaDonatorInfo)
				local daysleft = doninfo and tonumber(doninfo.days_left) or 0

				local keyheaderrow = instance.frame(keybox)
				keyheaderrow.BackgroundTransparency = 1
				keyheaderrow.LayoutOrder = 1
				keyheaderrow.Size = UDim2.new(1, 0, 0, 18)

				local keyheader = instance.textlabel(keyheaderrow)
				keyheader.BackgroundTransparency = 1
				keyheader.Size = UDim2.new(1, -120, 1, 0)
				keyheader.Font = Enum.Font.GothamBold
				keyheader.Text = donator and "Donator Status: Active" or "License Key Activation"
				keyheader.TextColor3 = theme.Text
				keyheader.TextSize = 11
				keyheader.TextXAlignment = Enum.TextXAlignment.Left

				local statusbadge = instance.frame(keyheaderrow)
				statusbadge.AnchorPoint = Vector2.new(1, 0)
				statusbadge.Position = UDim2.new(1, 0, 0, 0)
				statusbadge.Size = UDim2.new(0, 110, 1, 0)
				statusbadge.BorderSizePixel = 0
				local statusbg = roundbg(statusbadge, 4, donator and Color3.fromRGB(25, 47, 33) or theme.Inner)

				local statusbadgetext = instance.textlabel(statusbadge)
				statusbadgetext.BackgroundTransparency = 1
				statusbadgetext.Size = UDim2.new(1, 0, 1, 0)
				statusbadgetext.Font = Enum.Font.GothamBold
				statusbadgetext.Text = donator and (daysleft > 0 and (tostring(daysleft) .. " Days Left") or "Active") or "Not Active"
				statusbadgetext.TextColor3 = donator and theme.Good or theme.SubText
				statusbadgetext.TextSize = 10

				local inputrow = instance.frame(keybox)
				inputrow.BackgroundTransparency = 1
				inputrow.LayoutOrder = 2
				inputrow.Size = UDim2.new(1, 0, 0, 28)

				local keyinput = instance.textbox(inputrow)
				keyinput.Name = "KeyInput"
				keyinput.Size = UDim2.new(1, -70, 1, 0)
				keyinput.BackgroundColor3 = theme.Field
				keyinput.BackgroundTransparency = 0
				keyinput.BorderSizePixel = 0
				keyinput.Font = Enum.Font.GothamBold
				keyinput.PlaceholderText = "Paste your license key (SENA-XXXX-...)"
				keyinput.PlaceholderColor3 = theme.Dim
				keyinput.Text = Chloex:GetSavedKey() or ""
				keyinput.TextColor3 = theme.Text
				keyinput.TextSize = 11
				keyinput.TextXAlignment = Enum.TextXAlignment.Left
				keyinput.ClearTextOnFocus = false
				keyinput.ClipsDescendants = true
				keyinput.TextTruncate = Enum.TextTruncate.AtEnd
				instance.uicorner(keyinput).CornerRadius = UDim.new(0, 4)
				instance.uipadding(keyinput).PaddingLeft = UDim.new(0, 6)
				keyinput.BackgroundTransparency = 0

				local pastebtn = button(inputrow, "Paste", 2, false)
				pastebtn.AnchorPoint = Vector2.new(1, 0)
				pastebtn.Position = UDim2.new(1, 0, 0, 0)
				pastebtn.Size = UDim2.new(0, 64, 1, 0)

				pastebtn.Activated:Connect(function()
					elevate()
					local cb = clipboardread()
					if cb and cb:gsub("%s+", "") ~= "" then
						keyinput.Text = cb:gsub("%s+", "")
						Chloex:Notify({ Title = "Sena", Description = "Key Pasted", Content = "Pasted license key from clipboard.", Duration = 2 })
					else
						Chloex:Notify({ Title = "Sena", Description = "Clipboard", Content = "No text found in clipboard.", Duration = 2, Color = theme.Bad })
					end
				end)

				local redeembtn = button(keybox, donator and "Key Active (Enter new key to renew)" or "Redeem License Key", 3, true)

				local statuslabel = label(
					keybox,
					donator and string.format("Donator VIP Active (%d days remaining). All features unlocked.", daysleft > 0 and daysleft or 30)
						or "Enter your license key above to activate Donator VIP.",
					10,
					theme.SubText,
					Enum.Font.Gotham,
					Enum.TextXAlignment.Center,
					4
				)

				local redeeming = false
				local function doredeem()
					if redeeming then
						return
					end
					local raw = keyinput.Text
					if not raw or raw:gsub("%s+", "") == "" then
						statuslabel.Text = "Please enter a license key before redeeming."
						statuslabel.TextColor3 = theme.Bad
						return
					end

					redeeming = true
					local entered = raw:gsub("%s+", ""):upper()
					redeembtn.Text = "Verifying license..."
					redeembtn.Active = false
					statuslabel.Text = "Contacting Sena license server..."
					statuslabel.TextColor3 = theme.SubText

					task.spawn(function()
						elevate()
						local ok, res = Chloex:CheckDonatorKey(entered)
						if ok and type(res) == "table" and res.valid then
							-- CheckDonatorKey already set the tier (trial keys stay trial)
							local days = tonumber(res.days_left) or 30
							redeembtn.Text = "Activated Successfully! ✓"
							keyheader.Text = "Donator Status: Active"
							statusbg.ImageColor3 = Color3.fromRGB(25, 47, 33)
							statusbadgetext.Text = tostring(days) .. " Days Left"
							statusbadgetext.TextColor3 = theme.Good
							statuslabel.Text = string.format("Donator VIP Active! (%d days remaining)", days)
							statuslabel.TextColor3 = theme.Good

							Chloex:Notify({
								Title = "Sena",
								Description = "Donator VIP",
								Content = string.format("License verified! %d days of Donator access active.", days),
								Duration = 6,
								Color = theme.Good,
							})

							task.delay(3, function()
								if redeembtn and redeembtn.Parent then
									redeembtn.Text = "Key Active (Enter new key to renew)"
									redeembtn.Active = true
								end
								redeeming = false
							end)
						else
							local reason = (type(res) == "table" and res.reason) or tostring(res or "Invalid key")
							if reason:find("hwid limit") then
								reason = "HWID limit reached (3/3). Reset in Discord."
							elseif reason:find("expired") then
								reason = "Key has expired. Please renew."
							elseif reason == "network_error" then
								reason = "Could not reach the license server."
							end

							redeembtn.Text = "Redeem Failed ✗"
							statuslabel.Text = "Failed: " .. reason
							statuslabel.TextColor3 = theme.Bad

							Chloex:Notify({ Title = "Sena", Description = "Activation Failed", Content = reason, Duration = 5, Color = theme.Bad })

							task.delay(2.5, function()
								if redeembtn and redeembtn.Parent then
									redeembtn.Text = isdonator() and "Key Active (Enter new key to renew)" or "Redeem License Key"
									redeembtn.Active = true
								end
								redeeming = false
							end)
						end
					end)
				end

				redeembtn.Activated:Connect(doredeem)
				keyinput.FocusLost:Connect(function(enterpressed)
					if enterpressed then
						doredeem()
					end
				end)

				registerSearchItem(cardtitle, card)
				countitem = countitem + 1
				yieldbuild()

				local cardfunc = {}

				function cardfunc:SetTitle(text)
					titlelabel.Text = tostring(text or "")
				end

				function cardfunc:SetDescription(text)
					desclabel.Text = tostring(text or "")
				end

				function cardfunc:Redeem(key)
					if key then
						keyinput.Text = tostring(key)
					end
					doredeem()
				end

				return cardfunc
			end

			items.AddDonationCard = items.AddSupportCard
			items.AddKeySystem = items.AddSupportCard

			function items:AddDivider()
				local divider = instance.frame(sectionadd)
				divider.Name = "Divider"
				divider.AnchorPoint = Vector2.new(0.5, 0)
				divider.Position = UDim2.new(0.5, 0, 0, 0)
				divider.Size = UDim2.new(1, 0, 0, 2)
				divider.BackgroundColor3 = guiconfig.Color
				divider.BackgroundTransparency = 0
				divider.BorderSizePixel = 0
				divider.LayoutOrder = countitem

				local gradient = instance.uigradient(divider)
				gradient.Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 0.8),
					NumberSequenceKeypoint.new(0.5, 0),
					NumberSequenceKeypoint.new(1, 0.8),
				})

				instance.uicorner(divider).CornerRadius = UDim.new(0, 2)

				countitem = countitem + 1
				return divider
			end

			function items:AddSubSection(sectiontext)
				sectiontext = sectiontext or "Sub Section"

				local subsection = instance.frame(sectionadd)
				subsection.Name = "SubSection"
				subsection.BackgroundTransparency = 1
				subsection.Size = UDim2.new(1, 0, 0, 22)
				subsection.LayoutOrder = countitem

				local background = instance.frame(subsection)
				background.Size = UDim2.new(1, 0, 1, 0)
				background.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				background.BackgroundTransparency = 1
				background.BorderSizePixel = 0
				instance.uicorner(background).CornerRadius = UDim.new(0, 6)

				local label = instance.textlabel(subsection)
				label.AnchorPoint = Vector2.new(0, 0.5)
				label.Position = UDim2.new(0, 10, 0.5, 0)
				label.Size = UDim2.new(1, -20, 1, 0)
				label.BackgroundTransparency = 1
				label.Font = Enum.Font.GothamBold
				label.Text = tostring(sectiontext)
				label.TextColor3 = theme.SubText
				label.TextSize = 13
				label.TextXAlignment = Enum.TextXAlignment.Left

				countitem = countitem + 1
				currentSubSection = tostring(sectiontext)
				return subsection
			end

			function items:AddConfigPanel()
				local selectedconfigname = config.current or ""
				local configdropdown

				local function setdropdownlist(dropdown, list)
					if dropdown and dropdown.Refresh then
						dropdown:Refresh(list)
					elseif dropdown and dropdown.SetValues then
						dropdown:SetValues(list, dropdown.Value)
					end
				end

				local function refreshconfiglist()
					setdropdownlist(configdropdown, config:getlist())
				end

				local saveparagraph = items:AddParagraph({
					Title = "Config Manager",
					Content = "Save: " .. (config.current or "None"),
				})

				local function updatestatus()
					saveparagraph:SetContent("Save: " .. (config.current or "None"))
				end

				local confignameinput = items:AddInput({
					Title = "Config Name",
					Placeholder = "Write config name here",
				})

				configdropdown = items:AddDropdown({
					Title = "Select Config",
					Multi = false,
					Options = config:getlist(),
					Callback = function(value)
						selectedconfigname = value or ""
						if selectedconfigname ~= "" then
							confignameinput:Set(selectedconfigname)
						end
					end,
				})

				items:AddButton({
					Title = "Save Config",
					SubTitle = "Load Config",
					Callback = function()
						local input = config.elements["Input_Config Name"]
						local name = input and input.Value or ""

						if name == "" then
							chloex("Config name cannot be empty", 3, theme.Bad)
							return
						end

						if config:save(name) then
							selectedconfigname = name
							refreshconfiglist()
							updatestatus()
							chloex("Config saved: " .. name, 3, theme.Good)
						end
					end,
					SubCallback = function()
						if selectedconfigname == "" then
							chloex("Select config first", 3, theme.Bad)
							return
						end

						if config:load(selectedconfigname) then
							updatestatus()
							chloex("Config loaded: " .. selectedconfigname, 3, theme.Good)
						end
					end,
				})

				items:AddButton({
					Title = "Delete Config",
					SubTitle = "Override Config",
					Callback = function()
						if selectedconfigname == "" then
							chloex("Select config first", 3, theme.Bad)
							return
						end

						if config:delete(selectedconfigname) then
							selectedconfigname = ""
							-- the deleted name must not stay selected
							if configdropdown then
								configdropdown:Refresh(config:getlist(), false)
							end
							updatestatus()
							chloex("Config deleted", 3, theme.Good)
						end
					end,
					SubCallback = function()
						if selectedconfigname == "" then
							chloex("Select config first", 3, theme.Bad)
							return
						end

						if config:save(selectedconfigname) then
							refreshconfiglist()
							updatestatus()
							chloex("Config overridden: " .. selectedconfigname, 3, theme.Good)
						end
					end,
				})

				items:AddSubSection("Auto-Load Configuration")

				local autostatus = items:AddParagraph({
					Title = "Auto Load Status",
					Content = "Auto Load: " .. (config:getautoload() or "None"),
				})

				items:AddButton({
					Title = "Set Auto Load",
					SubTitle = "Clear Auto Load",
					Callback = function()
						if selectedconfigname == "" then
							chloex("Select config first", 3, theme.Bad)
							return
						end

						if config:setautoload(selectedconfigname) then
							autostatus:SetContent("Auto Load: " .. selectedconfigname)
							chloex("Auto load set: " .. selectedconfigname, 3, theme.Good)
						end
					end,
					SubCallback = function()
						if config:clearautoload() then
							autostatus:SetContent("Auto Load: None")
							chloex("Auto load cleared", 3, theme.Good)
						end
					end,
				})

				items:AddSubSection("Folder Management")

				items:AddButton({
					Title = "Export Config",
					Callback = function()
						config.data._version = config.version
						local json = sv.http:JSONEncode(packconfig(config.data))

						setclipboard(json)
						chloex("Config copied to clipboard", 3, theme.Good)
					end,
				})

				items:AddInput({
					Title = "External Config",
					Placeholder = "Paste raw JSON config here",
				})

				items:AddButton({
					Title = "Import Config",
					Callback = function()
						local input = config.elements["Input_External Config"]
						local json = input and input.Value

						if not json or json == "" then
							chloex("External config JSON kosong", 3, theme.Bad)
							return
						end

						config:reset()

						local ok, err = pcall(function()
							config:loadexternal(json)
						end)

						if ok then
							updatestatus()
							chloex("External config loaded successfully", 3, theme.Good)
						else
							warn(err)
							chloex("Failed to load external JSON", 3, theme.Bad)
						end
					end,
				})

				items:AddSubSection("Reset Configuration")

				items:AddButton({
					Title = "Reset All To Default",
					Callback = function()
						config:reset()
						updatestatus()
						chloex("All elements reset to default", 3, theme.Good)
					end,
				})

				return {
					UpdateStatus = updatestatus,
					RefreshList = refreshconfiglist,
				}
			end

			function items:AddForum(forumconfig)
				forumconfig = forumconfig or {}
				local fixedheight = tonumber(forumconfig.Height)
				local function fitheight()
					if fixedheight then
						return math.max(320, fixedheight)
					end
					-- fill the visible page (section header is 30px, list padding a few px)
					return math.max(320, math.floor(scrollayers.AbsoluteSize.Y - 38))
				end
				local height = fitheight()
				local pad = 8
				local forum = {
					Sort = "top",
					Offset = 0,
					Posts = {},
					Mine = nil,
					Game = nil,
					Busy = false,
					Device = { ram = "Any", ping = "Any", platform = "Any" },
					Options = {
						ram = { "Any", "2GB", "3GB", "4GB", "6GB", "8GB+" },
						ping = { "Any", "Under 50ms", "Under 100ms", "Under 150ms", "Under 250ms" },
						platform = { "Any", "PC", "Mobile" },
					},
				}

				local texthex = hexcolor(theme.Text)
				local dimhex = hexcolor(theme.Dim)
				local goldhex = hexcolor(theme.Gold)

				local function httprequest()
					return (type(request) == "function" and request)
						or (type(http_request) == "function" and http_request)
						or (type(syn) == "table" and type(syn.request) == "function" and syn.request)
						or (type(http) == "table" and type(http.request) == "function" and http.request)
						or nil
				end

				local function deviceid()
					local ok, id = pcall(function()
						if type(gethwid) == "function" then
							return gethwid()
						end
						return game:GetService("RbxAnalyticsService"):GetClientId()
					end)
					id = ok and id and tostring(id) or ""
					if id == "" then
						id = localuserid() .. ":" .. executorname()
					end
					return id
				end

				local function currentping()
					local ok, ms = pcall(function()
						return game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()
					end)
					if not ok or not tonumber(ms) or ms <= 0 then
						ok, ms = pcall(function()
							return sv.plrs.LocalPlayer:GetNetworkPing() * 2000
						end)
					end
					return ok and tonumber(ms) or nil
				end

				local function defaultdevice()
					local ms = currentping()
					local ping = "Any"
					if ms then
						for _, cap in ipairs({ 50, 100, 150, 250 }) do
							if ms < cap then
								ping = "Under " .. cap .. "ms"
								break
							end
						end
					end
					forum.Device.ping = ping
					forum.Device.platform = isMobile and "Mobile" or "PC"
				end
				defaultdevice()

				local function basepayload(extra)
					local trial = istrial()
					local payload = {
						uid = localuserid(),
						key = backend and backend.Key or "",
						name = localusername(),
						display = localdisplayname(),
						place = tostring(game.PlaceId),
						game = backend and backend.Game or "",
						lic = tostring((getgenv and getgenv().SenaKey) or ""),
						trial = trial and "1" or "0",
					}
					for k, v in pairs(extra or {}) do
						payload[k] = v
					end
					return payload
				end

				local function forumpost(path, extra)
					if not backend then
						return nil, "Not connected to Sena yet"
					end
					local payload = basepayload(extra)
					local fn = httprequest()
					if fn then
						local ok, res = pcall(fn, {
							Url = backend.Api .. path,
							Method = "POST",
							Headers = { ["Content-Type"] = "application/json" },
							Body = sv.http:JSONEncode(payload),
						})
						if ok and type(res) == "table" and type(res.Body) == "string" then
							local okjson, data = pcall(function()
								return sv.http:JSONDecode(res.Body)
							end)
							if okjson and type(data) == "table" then
								if data.ok == false then
									return data, tostring(data.error or "error")
								end
								return data, nil
							end
						end
						return nil, "No response from Sena"
					end
					return Chloex:BackendCall(path, extra)
				end

				local function friendlyerror(err)
					err = tostring(err or "error")
					if err:match("^maintenance") then
						local why = err:match("^maintenance:(.*)") or ""
						return "Forum is under maintenance" .. (why ~= "" and (": " .. why) or "")
					end
					local secs = err:match("^cooldown:(%d+)")
					if secs then
						return "Wait " .. secs .. "s before sharing again"
					end
					if err:match("^badword:") then
						return "Title has blocked words"
					end
					if err:match("^key_share") then
						return "Title can't contain a license key"
					end
					if err == "not connected" then
						return "Not connected to Sena yet"
					end
					return err
				end

				local function note(text, good)
					chloex(text, 3, good and theme.Good or theme.Bad)
				end

				local function timeago(ts)
					local s = math.max(0, os.time() - (tonumber(ts) or os.time()))
					if s < 60 then
						return "just now"
					elseif s < 3600 then
						return math.floor(s / 60) .. "m ago"
					elseif s < 86400 then
						return math.floor(s / 3600) .. "h ago"
					end
					return math.floor(s / 86400) .. "d ago"
				end

				local function makepill(parent, text, accent, clickable)
					local frame = clickable and instance.textbutton(parent) or instance.frame(parent)
					frame.BackgroundColor3 = accent and theme.Accent or theme.Element
					frame.BorderSizePixel = 0
					frame.AutomaticSize = Enum.AutomaticSize.X
					frame.Size = UDim2.new(0, 0, 0, 22)
					if clickable then
						frame.Text = ""
						frame.AutoButtonColor = true
					end
					instance.uicorner(frame).CornerRadius = UDim.new(1, 0)
					if not accent then
						local stroke = instance.uistroke(frame)
						stroke.Color = theme.Stroke
						stroke.Transparency = 0.35
					end
					local padding = instance.uipadding(frame)
					padding.PaddingLeft = UDim.new(0, 10)
					padding.PaddingRight = UDim.new(0, 10)
					local label = instance.textlabel(frame)
					label.Name = "Label"
					label.BackgroundTransparency = 1
					label.AutomaticSize = Enum.AutomaticSize.X
					label.Size = UDim2.new(0, 0, 1, 0)
					label.Font = accent and Enum.Font.GothamBold or Enum.Font.GothamMedium
					label.RichText = true
					label.Text = text
					label.TextColor3 = accent and theme.AccentText or theme.SubText
					label.TextSize = 11
					if clickable then
						frame.Activated:Connect(function()
							pesseffect(frame)
						end)
					end
					return frame, label
				end

				local function hlist(parent, spacing, align)
					local layout = instance.uilistlayout(parent)
					layout.FillDirection = Enum.FillDirection.Horizontal
					layout.HorizontalAlignment = align or Enum.HorizontalAlignment.Left
					layout.VerticalAlignment = Enum.VerticalAlignment.Center
					layout.Padding = UDim.new(0, spacing or 6)
					layout.SortOrder = Enum.SortOrder.LayoutOrder
					return layout
				end

				-- names shown to people: "Toggle_Auto Steal" -> "Auto Steal"
				local function shownname(key)
					return (tostring(key):gsub("^%a+_", ""))
				end

				local function joinlist(list, limit)
					local out = {}
					for i, v in ipairs(list) do
						if i > limit then
							out[#out + 1] = "+" .. (#list - limit) .. " more"
							break
						end
						out[#out + 1] = escaperich(v)
					end
					return table.concat(out, ", ")
				end

				local function describe(cfgtable)
					local enabled, filters, values, unknown = {}, {}, {}, 0
					for key, value in pairs(cfgtable or {}) do
						if config.elements[key] == nil then
							unknown = unknown + 1
						else
							local kind = tostring(key):match("^(%a+)_")
							if kind == "Toggle" and value == true then
								enabled[#enabled + 1] = shownname(key)
							elseif kind == "Dropdown" then
								local list = type(value) == "table" and value or { value }
								local picked = {}
								for _, v in ipairs(list) do
									picked[#picked + 1] = tostring(v)
								end
								if #picked > 0 then
									filters[#filters + 1] = { shownname(key), picked }
								end
							elseif kind == "Slider" and tonumber(value) then
								values[#values + 1] = { shownname(key), tonumber(value) }
							end
						end
					end
					table.sort(enabled)
					table.sort(filters, function(a, b)
						return a[1] < b[1]
					end)
					table.sort(values, function(a, b)
						return a[1] < b[1]
					end)

					local lines = {}
					local function head(text)
						return '<font color="' .. texthex .. '"><b>' .. escaperich(text) .. "</b></font>  "
					end
					if #enabled > 0 then
						lines[#lines + 1] = head("Enabled") .. joinlist(enabled, 14)
					end
					for i, f in ipairs(filters) do
						if i > 6 then
							lines[#lines + 1] = '<font color="' .. dimhex .. '">+' .. (#filters - 6) .. " more filters</font>"
							break
						end
						lines[#lines + 1] = head(f[1]) .. joinlist(f[2], 8)
					end
					for i, v in ipairs(values) do
						if i > 4 then
							break
						end
						local n = v[2]
						lines[#lines + 1] = head(v[1]) .. (n == math.floor(n) and tostring(n) or string.format("%.2f", n))
					end
					if unknown > 0 then
						lines[#lines + 1] = '<font color="' .. dimhex .. '"><i>' .. unknown .. " setting(s) from another hub version will be skipped</i></font>"
					end
					if #lines == 0 then
						lines[1] = '<font color="' .. dimhex .. '">Nothing from this hub version</font>'
					end
					return table.concat(lines, "\n"), #enabled, #filters
				end

				local function collectconfig()
					local out = {}
					for key, element in pairs(config.elements) do
						if not metakeys[key] and (key:match("^Toggle_") or key:match("^Dropdown_") or key:match("^Slider_")) then
							local value = element.Value
							if key:match("^Toggle_") then
								if value == true then
									out[key] = true
								end
							elseif key:match("^Slider_") then
								if tonumber(value) then
									out[key] = tonumber(value)
								end
							elseif type(value) == "table" then
								local list = {}
								for _, v in ipairs(value) do
									list[#list + 1] = tostring(v)
								end
								if #list > 0 then
									out[key] = list
								end
							elseif value ~= nil and tostring(value) ~= "" then
								out[key] = tostring(value)
							end
						end
					end
					return out
				end

				-- apply a shared setup: features / filters / sliders from the post,
				-- everything else off; the player's own text inputs (webhooks, names) stay
				local function injectconfig(cfgtable)
					local data = { _version = config.version }
					for key, value in pairs(config.data or {}) do
						if tostring(key):match("^Input_") or metakeys[key] then
							data[key] = value
						end
					end
					for key, value in pairs(cfgtable or {}) do
						if config.elements[key] ~= nil and not tostring(key):match("^Input_") then
							data[key] = value
						end
					end
					config.data = data
					config.loaded = true
					config:loadelements()
				end

				local root = instance.frame(sectionadd)
				root.Name = "ConfigForum"
				root.BorderSizePixel = 0
				root.LayoutOrder = countitem
				root.Size = UDim2.new(1, 0, 0, height)
				root.ClipsDescendants = true
				roundbg(root, 6, theme.Row)
				countitem = countitem + 1
				if not fixedheight then
					scrollayers:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
						root.Size = UDim2.new(1, 0, 0, fitheight())
					end)
				end

				local headerh = 34
				local title = instance.textlabel(root)
				title.BackgroundTransparency = 1
				title.Position = UDim2.new(0, 12, 0, 0)
				title.Size = UDim2.new(0.35, 0, 0, headerh)
				title.Font = Enum.Font.GothamBold
				title.Text = tostring(forumconfig.Title or "Community Setups")
				title.TextColor3 = theme.Text
				title.TextSize = 13
				title.TextXAlignment = Enum.TextXAlignment.Left
				title.TextTruncate = Enum.TextTruncate.AtEnd

				local headerstrip = instance.frame(root)
				headerstrip.AnchorPoint = Vector2.new(1, 0.5)
				headerstrip.Position = UDim2.new(1, -pad, 0, headerh / 2)
				headerstrip.Size = UDim2.new(0.65, -pad, 0, 22)
				headerstrip.BackgroundTransparency = 1
				hlist(headerstrip, 6, Enum.HorizontalAlignment.Right)

				local gamepill, gamelabel = makepill(headerstrip, '<font color="' .. goldhex .. '">●</font>  Detecting game...', false, false)
				gamepill.LayoutOrder = 1
				local countpill, countlabel = makepill(headerstrip, "0 setups", false, false)
				countpill.LayoutOrder = 2
				local refreshbtn = makepill(headerstrip, "Refresh", false, true)
				refreshbtn.LayoutOrder = 3

				-- share card
				local sharey = headerh
				local shareh = 100
				local share = instance.frame(root)
				share.Name = "Share"
				share.Position = UDim2.new(0, pad, 0, sharey)
				share.Size = UDim2.new(1, -pad * 2, 0, shareh)
				share.BackgroundColor3 = theme.Box
				share.BorderSizePixel = 0
				instance.uicorner(share).CornerRadius = UDim.new(0, 6)
				local sharestroke = instance.uistroke(share)
				sharestroke.Color = theme.Stroke
				sharestroke.Transparency = 0.5

				local sharew = 118
				local titlebox = instance.textbox(share)
				titlebox.Position = UDim2.new(0, 8, 0, 8)
				titlebox.Size = UDim2.new(1, -(sharew + 24), 0, 28)
				titlebox.BackgroundColor3 = theme.Element
				titlebox.BorderSizePixel = 0
				titlebox.Font = Enum.Font.Gotham
				titlebox.Text = ""
				titlebox.PlaceholderText = "Name your setup (e.g. Divine egg farm)"
				titlebox.PlaceholderColor3 = theme.Dim
				titlebox.TextColor3 = theme.Text
				titlebox.TextSize = 12
				titlebox.TextXAlignment = Enum.TextXAlignment.Left
				titlebox.ClearTextOnFocus = false
				titlebox.ClipsDescendants = true
				instance.uicorner(titlebox).CornerRadius = UDim.new(1, 0)
				local titlestroke = instance.uistroke(titlebox)
				titlestroke.Color = theme.Stroke
				titlestroke.Transparency = 0.35
				local titlepad = instance.uipadding(titlebox)
				titlepad.PaddingLeft = UDim.new(0, 12)
				titlepad.PaddingRight = UDim.new(0, 12)
				titlebox:GetPropertyChangedSignal("Text"):Connect(function()
					if #titlebox.Text > 48 then
						titlebox.Text = titlebox.Text:sub(1, 48)
					end
				end)

				local sharebtn = instance.textbutton(share)
				sharebtn.AnchorPoint = Vector2.new(1, 0)
				sharebtn.Position = UDim2.new(1, -8, 0, 8)
				sharebtn.Size = UDim2.new(0, sharew, 0, 28)
				sharebtn.BackgroundColor3 = theme.Accent
				sharebtn.BorderSizePixel = 0
				sharebtn.Font = Enum.Font.GothamBold
				sharebtn.Text = "Share Config"
				sharebtn.TextColor3 = theme.AccentText
				sharebtn.TextSize = 12
				sharebtn.AutoButtonColor = true
				instance.uicorner(sharebtn).CornerRadius = UDim.new(1, 0)

				local devicerow = instance.frame(share)
				devicerow.Position = UDim2.new(0, 8, 0, 42)
				devicerow.Size = UDim2.new(1, -16, 0, 22)
				devicerow.BackgroundTransparency = 1
				hlist(devicerow, 6)

				local devicelabel = instance.textlabel(devicerow)
				devicelabel.BackgroundTransparency = 1
				devicelabel.AutomaticSize = Enum.AutomaticSize.X
				devicelabel.Size = UDim2.new(0, 0, 1, 0)
				devicelabel.Font = Enum.Font.GothamBold
				devicelabel.Text = "Device Requirement"
				devicelabel.TextColor3 = theme.SubText
				devicelabel.TextSize = 11
				devicelabel.LayoutOrder = 0

				local devicepills = {}
				local deviceprefix = { ram = "RAM", ping = "Ping", platform = "Device" }
				for order, field in ipairs({ "ram", "ping", "platform" }) do
					local btn, label = makepill(devicerow, "", false, true)
					btn.LayoutOrder = order
					local function render()
						label.Text = '<font color="' .. dimhex .. '">' .. deviceprefix[field] .. "</font>  " .. forum.Device[field]
					end
					render()
					btn.Activated:Connect(function()
						elevate()
						local opts = forum.Options[field]
						local idx = table.find(opts, forum.Device[field]) or 1
						forum.Device[field] = opts[(idx % #opts) + 1]
						render()
					end)
					devicepills[field] = render
				end

				local statusrow = instance.frame(share)
				statusrow.Position = UDim2.new(0, 8, 0, 70)
				statusrow.Size = UDim2.new(1, -16, 0, 22)
				statusrow.BackgroundTransparency = 1

				local statuslabel = instance.textlabel(statusrow)
				statuslabel.BackgroundTransparency = 1
				statuslabel.Size = UDim2.new(1, -120, 1, 0)
				statuslabel.Font = Enum.Font.Gotham
				statuslabel.RichText = true
				statuslabel.Text = ""
				statuslabel.TextColor3 = theme.Dim
				statuslabel.TextSize = 11
				statuslabel.TextXAlignment = Enum.TextXAlignment.Left
				statuslabel.TextTruncate = Enum.TextTruncate.AtEnd

				local deletebtn, deletelabel = makepill(statusrow, "Delete My Post", false, true)
				deletebtn.AnchorPoint = Vector2.new(1, 0)
				deletebtn.Position = UDim2.new(1, 0, 0, 0)
				deletelabel.TextColor3 = theme.Bad
				deletebtn.Visible = false

				-- sort bar
				local sorty = sharey + shareh + 6
				local sortbar = instance.frame(root)
				sortbar.Position = UDim2.new(0, pad, 0, sorty)
				sortbar.Size = UDim2.new(1, -pad * 2, 0, 22)
				sortbar.BackgroundTransparency = 1
				hlist(sortbar, 6)
				local topbtn, toplabel = makepill(sortbar, "Top Liked", false, true)
				topbtn.LayoutOrder = 1
				local newbtn, newlabel = makepill(sortbar, "Newest", false, true)
				newbtn.LayoutOrder = 2

				local listy = sorty + 28
				local scroll = instance.scrollingframe(root)
				scroll.Name = "Posts"
				scroll.Position = UDim2.new(0, pad, 0, listy)
				scroll.Size = UDim2.new(1, -pad * 2, 1, -(listy + pad))
				scroll.BackgroundColor3 = theme.ChatBg
				scroll.BorderSizePixel = 0
				scroll.ScrollBarThickness = 3
				scroll.ScrollBarImageColor3 = theme.Track
				scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
				scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
				scroll.ScrollingDirection = Enum.ScrollingDirection.Y
				instance.uicorner(scroll).CornerRadius = UDim.new(0, 6)
				local scrollpad = instance.uipadding(scroll)
				scrollpad.PaddingLeft = UDim.new(0, 6)
				scrollpad.PaddingRight = UDim.new(0, 8)
				scrollpad.PaddingTop = UDim.new(0, 6)
				scrollpad.PaddingBottom = UDim.new(0, 6)
				local scrolllayout = instance.uilistlayout(scroll)
				scrolllayout.Padding = UDim.new(0, 6)
				scrolllayout.SortOrder = Enum.SortOrder.LayoutOrder

				local emptylabel = instance.textlabel(scroll)
				emptylabel.Name = "Empty"
				emptylabel.BackgroundTransparency = 1
				emptylabel.Size = UDim2.new(1, 0, 0, 60)
				emptylabel.Font = Enum.Font.Gotham
				emptylabel.Text = "Loading setups..."
				emptylabel.TextColor3 = theme.Dim
				emptylabel.TextSize = 12
				emptylabel.TextWrapped = true
				emptylabel.LayoutOrder = 0

				local refresh

				local function updatesortpills()
					local top = forum.Sort == "top"
					topbtn.BackgroundColor3 = top and theme.Accent or theme.Element
					toplabel.TextColor3 = top and theme.AccentText or theme.SubText
					newbtn.BackgroundColor3 = top and theme.Element or theme.Accent
					newlabel.TextColor3 = top and theme.SubText or theme.AccentText
				end
				updatesortpills()

				local function updateshare()
					local _, ons, filters = describe(collectconfig())
					local mine = forum.Mine
					local text = "Will share <b>" .. ons .. "</b> feature(s) and <b>" .. filters .. "</b> filter(s)"
					if mine and forum.MineHidden then
						text = '<font color="' .. hexcolor(theme.Bad) .. '">Your post is hidden after reports. Ask an admin on Discord.</font>'
						sharebtn.Text = "Update Config"
					elseif mine then
						text = text .. '  ·  <font color="' .. goldhex .. '">Your post: ' .. (mine.likes or 0) .. " like(s)</font>"
						sharebtn.Text = "Update Config"
					else
						sharebtn.Text = "Share Config"
					end
					statuslabel.Text = text
					deletebtn.Visible = mine ~= nil
				end

				local rankcolors = {
					Color3.fromRGB(245, 196, 81),
					Color3.fromRGB(196, 200, 210),
					Color3.fromRGB(214, 144, 92),
				}

				local function buildcard(post, order)
					local card = instance.frame(scroll)
					card.Name = "Post"
					card.LayoutOrder = order
					card.BackgroundColor3 = post.mine and theme.Mine or theme.Card
					card.BorderSizePixel = 0
					card.Size = UDim2.new(1, 0, 0, 0)
					card.AutomaticSize = Enum.AutomaticSize.Y
					instance.uicorner(card).CornerRadius = UDim.new(0, 6)
					local cardstroke = instance.uistroke(card)
					cardstroke.Color = (post.rank == 1 and forum.Sort == "top") and theme.Gold or theme.Stroke
					cardstroke.Transparency = (post.rank == 1 and forum.Sort == "top") and 0.4 or 0.55
					local cardpad = instance.uipadding(card)
					cardpad.PaddingLeft = UDim.new(0, 10)
					cardpad.PaddingRight = UDim.new(0, 10)
					cardpad.PaddingTop = UDim.new(0, 8)
					cardpad.PaddingBottom = UDim.new(0, 8)
					local cardlayout = instance.uilistlayout(card)
					cardlayout.Padding = UDim.new(0, 5)
					cardlayout.SortOrder = Enum.SortOrder.LayoutOrder

					local top = instance.frame(card)
					top.BackgroundTransparency = 1
					top.Size = UDim2.new(1, 0, 0, 22)
					top.LayoutOrder = 1

					local rank = tonumber(post.rank) or 0
					local badge = instance.textlabel(top)
					badge.AnchorPoint = Vector2.new(0, 0.5)
					badge.Position = UDim2.new(0, 0, 0.5, 0)
					badge.Size = UDim2.new(0, 30, 0, 20)
					badge.BackgroundColor3 = rankcolors[rank] or theme.Inner
					badge.BorderSizePixel = 0
					badge.Font = Enum.Font.GothamBold
					badge.Text = rank > 0 and ("#" .. rank) or "-"
					badge.TextColor3 = rankcolors[rank] and theme.AccentText or theme.SubText
					badge.TextSize = 11
					instance.uicorner(badge).CornerRadius = UDim.new(1, 0)

					local likebtn, likelabel = makepill(top, "", false, true)
					likebtn.AnchorPoint = Vector2.new(1, 0.5)
					likebtn.Position = UDim2.new(1, 0, 0.5, 0)
					local function renderlike()
						local heart = post.liked and ('<font color="' .. hexcolor(theme.Bad) .. '">♥</font>') or "♡"
						likelabel.Text = heart .. "  " .. tostring(post.likes or 0)
						likebtn.BackgroundColor3 = post.liked and theme.Mention or theme.Element
					end
					renderlike()

					local posttitle = instance.textlabel(top)
					posttitle.BackgroundTransparency = 1
					posttitle.Position = UDim2.new(0, 38, 0, 0)
					posttitle.Size = UDim2.new(1, -110, 1, 0)
					posttitle.Font = Enum.Font.GothamBold
					posttitle.Text = tostring(post.title or "Untitled setup")
					posttitle.TextColor3 = theme.Text
					posttitle.TextSize = 13
					posttitle.TextXAlignment = Enum.TextXAlignment.Left
					posttitle.TextTruncate = Enum.TextTruncate.AtEnd

					local meta = instance.textlabel(card)
					meta.BackgroundTransparency = 1
					meta.Size = UDim2.new(1, 0, 0, 14)
					meta.Font = Enum.Font.Gotham
					meta.RichText = true
					local who = post.owner and ('<font color="' .. goldhex .. '">Sena</font>') or escaperich(post.name or "??****")
					local metatext = escaperich(post.game or forum.Game or "") .. "  ·  by " .. who .. "  ·  " .. timeago(post.updated or post.ts)
					if post.cfg_version and post.cfg_version ~= "" then
						metatext = metatext .. "  ·  v" .. escaperich(post.cfg_version)
					end
					meta.Text = metatext
					meta.TextColor3 = theme.Dim
					meta.TextSize = 11
					meta.TextXAlignment = Enum.TextXAlignment.Left
					meta.TextTruncate = Enum.TextTruncate.AtEnd
					meta.LayoutOrder = 2

					local chips = instance.frame(card)
					chips.BackgroundTransparency = 1
					chips.Size = UDim2.new(1, 0, 0, 20)
					chips.LayoutOrder = 3
					hlist(chips, 5)
					local dev = type(post.device) == "table" and post.device or {}
					local anychip = false
					for i, field in ipairs({ "ram", "ping", "platform" }) do
						local v = tostring(dev[field] or "Any")
						if v ~= "Any" then
							anychip = true
							local chip, chiplabel = makepill(chips, '<font color="' .. dimhex .. '">' .. deviceprefix[field] .. "</font>  " .. escaperich(v), false, false)
							chip.Size = UDim2.new(0, 0, 0, 20)
							chip.BackgroundColor3 = theme.Pill
							chip.LayoutOrder = i
							chiplabel.TextSize = 10
						end
					end
					if not anychip then
						local chip, chiplabel = makepill(chips, "Runs on any device", false, false)
						chip.Size = UDim2.new(0, 0, 0, 20)
						chip.BackgroundColor3 = theme.Pill
						chiplabel.TextSize = 10
					end

					local desc = instance.textlabel(card)
					desc.BackgroundTransparency = 1
					desc.Size = UDim2.new(1, 0, 0, 0)
					desc.AutomaticSize = Enum.AutomaticSize.Y
					desc.Font = Enum.Font.Gotham
					desc.RichText = true
					desc.TextWrapped = true
					desc.Text = (describe(post.config))
					desc.TextColor3 = theme.SubText
					desc.TextSize = 12
					desc.LineHeight = 1.1
					desc.TextXAlignment = Enum.TextXAlignment.Left
					desc.TextYAlignment = Enum.TextYAlignment.Top
					desc.LayoutOrder = 4

					local actions = instance.frame(card)
					actions.BackgroundTransparency = 1
					actions.Size = UDim2.new(1, 0, 0, 26)
					actions.LayoutOrder = 5

					local injectbtn = instance.textbutton(actions)
					injectbtn.Size = UDim2.new(0, 120, 1, 0)
					injectbtn.BackgroundColor3 = theme.Accent
					injectbtn.BorderSizePixel = 0
					injectbtn.Font = Enum.Font.GothamBold
					injectbtn.Text = "Inject Config"
					injectbtn.TextColor3 = theme.AccentText
					injectbtn.TextSize = 12
					injectbtn.AutoButtonColor = true
					instance.uicorner(injectbtn).CornerRadius = UDim.new(1, 0)

					local sidebtn, sidelabel
					if post.mine then
						sidebtn, sidelabel = makepill(actions, "Your post", false, false)
						sidelabel.TextColor3 = theme.Gold
					else
						sidebtn, sidelabel = makepill(actions, post.reported and "Reported" or "Report", false, not post.reported)
						sidelabel.TextColor3 = theme.Dim
					end
					sidebtn.AnchorPoint = Vector2.new(1, 0.5)
					sidebtn.Position = UDim2.new(1, 0, 0.5, 0)

					injectbtn.Activated:Connect(function()
						elevate()
						pesseffect(injectbtn)
						if forum.Paused then
							note("Forum is under maintenance", false)
							return
						end
						local ok, errmsg = pcall(injectconfig, post.config)
						if ok then
							injectbtn.Text = "Injected ✓"
							note("Injected: " .. tostring(post.title or "setup"), true)
							task.delay(2, function()
								if injectbtn.Parent then
									injectbtn.Text = "Inject Config"
								end
							end)
							updateshare()
						else
							warn("[SENA] forum inject failed:", errmsg)
							note("Could not inject this config", false)
						end
					end)

					likebtn.Activated:Connect(function()
						elevate()
						if post.mine then
							note("You can't like your own post", false)
							return
						end
						task.spawn(function()
							local want = not post.liked
							local data, errmsg = forumpost("/forum/like", { id = post.id, on = want and "1" or "0" })
							elevate()
							if errmsg then
								note(friendlyerror(errmsg), false)
								return
							end
							post.liked = data and data.liked == true
							post.likes = tonumber(data and data.likes) or post.likes
							renderlike()
						end)
					end)

					if not post.mine and not post.reported then
						sidebtn.Activated:Connect(function()
							elevate()
							if post.reported then
								return
							end
							if sidelabel.Text ~= "Tap again to report" then
								sidelabel.Text = "Tap again to report"
								sidelabel.TextColor3 = theme.Bad
								task.delay(3, function()
									if sidelabel.Parent and not post.reported then
										sidelabel.Text = "Report"
										sidelabel.TextColor3 = theme.Dim
									end
								end)
								return
							end
							sidelabel.Text = "Reporting..."
							task.spawn(function()
								local data, errmsg = forumpost("/forum/report", { id = post.id })
								elevate()
								if errmsg then
									sidelabel.Text = "Report"
									sidelabel.TextColor3 = theme.Dim
									note(friendlyerror(errmsg), false)
									return
								end
								post.reported = true
								sidelabel.Text = "Reported"
								note("Thanks, the post was reported", true)
								if data and data.hidden then
									card:Destroy()
								end
							end)
						end)
					end

					return card
				end

				local function render()
					for _, child in ipairs(scroll:GetChildren()) do
						if child.Name == "Post" or child.Name == "More" then
							child:Destroy()
						end
					end
					emptylabel.Visible = #forum.Posts == 0
					if #forum.Posts == 0 then
						emptylabel.Text = "No setups shared for this game yet.\nBe the first: name your setup and press Share Config."
					end
					for i, post in ipairs(forum.Posts) do
						buildcard(post, i)
					end
					if forum.Total and #forum.Posts < forum.Total then
						local more = instance.textbutton(scroll)
						more.Name = "More"
						more.LayoutOrder = #forum.Posts + 1
						more.Size = UDim2.new(1, 0, 0, 26)
						more.BackgroundColor3 = theme.Element
						more.BorderSizePixel = 0
						more.Font = Enum.Font.GothamMedium
						more.Text = "Show more (" .. (forum.Total - #forum.Posts) .. ")"
						more.TextColor3 = theme.SubText
						more.TextSize = 12
						instance.uicorner(more).CornerRadius = UDim.new(1, 0)
						more.Activated:Connect(function()
							elevate()
							refresh(true)
						end)
					end
					countlabel.Text = tostring(forum.Total or 0) .. " setup" .. ((forum.Total or 0) == 1 and "" or "s")
					updateshare()
				end

				-- /pauseforum: the whole forum closes -- drop every loaded post (so nothing is left to
				-- inject) and show a maintenance screen until the bot reopens it.
				local function showmaintenance(why)
					forum.Paused = true
					forum.Posts = {}
					forum.Total = 0
					forum.Mine = nil
					render()
					why = tostring(why or "")
					emptylabel.Visible = true
					emptylabel.Text = "Forum is under maintenance" .. (why ~= "" and (": " .. why) or "") .. "\nCheck back soon."
					gamelabel.Text = '<font color="' .. goldhex .. '">●</font>  ' .. escaperich(forum.Game or "")
						.. '  <font color="#F59E0B">· Maintenance</font>'
					countlabel.Text = "Maintenance"
				end

				refresh = function(append)
					if forum.Busy then
						return
					end
					forum.Busy = true
					task.spawn(function()
						local offset = append and #forum.Posts or 0
						local data, errmsg = forumpost("/forum/list", {
							sort = forum.Sort,
							offset = tostring(offset),
							game_name = forum.Game or "",
						})
						elevate()
						forum.Busy = false
						if errmsg and tostring(errmsg):match("^maintenance") then
							showmaintenance(tostring(errmsg):match("^maintenance:(.*)"))
							return
						end
						if errmsg or type(data) ~= "table" then
							emptylabel.Visible = true
							emptylabel.Text = "Could not load setups: " .. friendlyerror(errmsg or "no response")
							return
						end
						forum.Paused = false
						forum.Game = tostring(data.game or forum.Game or "")
						gamelabel.Text = '<font color="' .. goldhex .. '">●</font>  ' .. escaperich(forum.Game)
						forum.Total = tonumber(data.total) or 0
						forum.Mine = type(data.mine) == "table" and data.mine or nil
						if forum.Mine and not append then
							local d = forum.Mine.device
							if type(d) == "table" then
								for field, render in pairs(devicepills) do
									if d[field] then
										forum.Device[field] = tostring(d[field])
										render()
									end
								end
							end
							if titlebox.Text == "" then
								titlebox.Text = tostring(forum.Mine.title or "")
							end
						end
						local posts = type(data.posts) == "table" and data.posts or {}
						if append then
							for _, p in ipairs(posts) do
								forum.Posts[#forum.Posts + 1] = p
							end
						else
							forum.Posts = posts
							scroll.CanvasPosition = Vector2.new(0, 0)
						end
						forum.MineHidden = data.mine_hidden == true
						render()
					end)
				end

				-- live: an open forum tab closes / reopens as soon as /sync reports the switch
				Chloex:OnPause(function(p)
					elevate()
					if p.forum == true and not forum.Paused then
						showmaintenance(p.forummsg)
					elseif p.forum ~= true and forum.Paused then
						forum.Paused = false
						emptylabel.Text = "Loading setups..."
						refresh(false)
					end
				end)

				local function doshare()
					if forum.Busy then
						return
					end
					if forum.Paused then
						note("Forum is under maintenance", false)
						return
					end
					local cfgtable = collectconfig()
					local _, ons = describe(cfgtable)
					if ons < 1 then
						note("Turn on at least 1 feature before sharing", false)
						return
					end
					forum.Busy = true
					sharebtn.Text = "Sharing..."
					task.spawn(function()
						local hide = true
						if getgenv and getgenv().SenaHideName ~= nil then
							hide = getgenv().SenaHideName == true
						end
						local data, errmsg = forumpost("/forum/post", {
							title = titlebox.Text,
							config = sv.http:JSONEncode(cfgtable),
							cfg_version = tostring(config.version or ""),
							dev = deviceid(),
							hide = hide and "1" or "0",
							ram = forum.Device.ram,
							ping = forum.Device.ping,
							platform = forum.Device.platform,
							game_name = forum.Game or "",
						})
						elevate()
						forum.Busy = false
						if errmsg then
							updateshare()
							note(friendlyerror(errmsg), false)
							return
						end
						note(data and data.updated and "Your setup was updated (likes reset)" or "Your setup is live on the forum!", true)
						forum.Sort = data and data.updated and forum.Sort or "new"
						updatesortpills()
						refresh(false)
					end)
				end

				sharebtn.Activated:Connect(function()
					elevate()
					pesseffect(sharebtn)
					doshare()
				end)

				deletebtn.Activated:Connect(function()
					elevate()
					if not forum.Mine or forum.Busy then
						return
					end
					if deletelabel.Text ~= "Tap again to delete" then
						deletelabel.Text = "Tap again to delete"
						task.delay(3, function()
							if deletelabel.Parent then
								deletelabel.Text = "Delete My Post"
							end
						end)
						return
					end
					deletelabel.Text = "Delete My Post"
					task.spawn(function()
						local _, errmsg = forumpost("/forum/delete", { id = forum.Mine.id, dev = deviceid() })
						elevate()
						if errmsg then
							note(friendlyerror(errmsg), false)
							return
						end
						forum.Mine = nil
						note("Your post was deleted", true)
						refresh(false)
					end)
				end)

				refreshbtn.Activated:Connect(function()
					elevate()
					refresh(false)
				end)
				topbtn.Activated:Connect(function()
					elevate()
					if forum.Sort ~= "top" then
						forum.Sort = "top"
						updatesortpills()
						refresh(false)
					end
				end)
				newbtn.Activated:Connect(function()
					elevate()
					if forum.Sort ~= "new" then
						forum.Sort = "new"
						updatesortpills()
						refresh(false)
					end
				end)

				task.spawn(function()
					while root.Parent do
						task.wait(1.5)
						if root.Parent and root.AbsoluteSize.Y > 0 and scrollayers.Visible and not forum.Busy then
							elevate()
							pcall(updateshare)
						end
					end
				end)

				task.spawn(function()
					local ok, info = pcall(function()
						return game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId)
					end)
					if ok and type(info) == "table" and info.Name and not forum.Game then
						forum.Game = tostring(info.Name)
					end
					local t0 = os.clock()
					while not backend and os.clock() - t0 < 15 do
						task.wait(0.5)
					end
					-- the server only accepts players it has seen on /sync; give the first one a moment
					local t1 = os.clock()
					while backend and not backend.Connected and os.clock() - t1 < 10 do
						task.wait(0.5)
					end
					elevate()
					refresh(false)
				end)

				return {
					Refresh = function()
						refresh(false)
					end,
					Share = doshare,
					Inject = injectconfig,
					Describe = function(_, cfgtable)
						return (describe(cfgtable))
					end,
				}
			end

			countsection = countsection + 1
			return items
		end

		counttab = counttab + 1
		-- kept for Chloe X scripts that reach tabs through _G, but never over an
		-- existing global (a tab named "Config" or "Settings" used to clobber it)
		local safename = tabconfig.Name:gsub("%s+", "_")
		if _G[safename] == nil then
			_G[safename] = sections
		end
		return sections
	end

	if guiconfig.AutoConfigTab then
		local ConfigTab = tabs:AddTab({
			Name = "Config",
			Icon = "settings",
			LayoutOrder = 1000000,
			StartActive = false,
		})

		local function buildConfigTab()
			local ConfigSection = ConfigTab:AddSection("Config Configuration", true)
			ConfigSection:AddConfigPanel()
		end

		if guiconfig.LazyConfigTab then
			ConfigTab:OnOpen(buildConfigTab)
		else
			buildConfigTab()
		end
	end

	function tabs:AddForum(forumconfig)
		forumconfig = forumconfig or {}
		local forumtab = tabs:AddTab({
			Name = forumconfig.Name or "Forum",
			Icon = forumconfig.Icon or "forum",
			LayoutOrder = forumconfig.LayoutOrder,
			StartActive = false,
		})
		local holder = { Tab = forumtab }
		forumtab:OnOpen(function()
			local section = forumtab:AddSection(forumconfig.Section or "Config Forum", true)
			holder.Forum = section:AddForum(forumconfig)
		end)
		return holder
	end

	if guiconfig.ForumTab then
		local forumtabconfig = type(guiconfig.ForumTab) == "table" and guiconfig.ForumTab or {}
		forumtabconfig.LayoutOrder = forumtabconfig.LayoutOrder or 999999
		tabs:AddForum(forumtabconfig)
	end

	tabs.Notify = function(self, ...)
		return Chloex:Notify(...)
	end
	tabs.Announce = function(self, ...)
		return Chloex:Announce(...)
	end

	return tabs
end

task.defer(function()
	elevate()
	local ok, cfg = pcall(function()
		return getgenv and getgenv().SenaBackend
	end)
	Chloex:ConnectBackend((ok and type(cfg) == "table") and cfg or {})
end)

Chloex.Elevate = elevate
function Chloex:Elevate()
	elevate()
end

getgenv().ChloeX = Chloex

return Chloex
