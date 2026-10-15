local CONFIG = {
	SERVICE = "Oushu",
	IDENTIFIER = "1204628",
	PROVIDER = "Direct",
	SCRIPT_URL = "https://api.jnkie.com/api/v1/luascripts/public/460efca1c00d926766e8d919b5eb6f05036c159d3450a504609eed6c922b045f/download",

	TITLE = "Salad Visuals",
	FOLDER = "Salad Visuals",
	KEY_FILE = "Salad Visuals/key.txt",
	MAX_ATTEMPTS = 5,
}

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

while not player do
	Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
	player = Players.LocalPlayer
end

local genv = (getgenv and getgenv()) or _G

local MESSAGES = {
	KEYLESS = "Keyless",
	KEY_VALID = "Key valid",
	KEY_INVALID = "Key not found",
	KEY_EXPIRED = "Key expired",
	HWID_BANNED = "Device banned",
	KEY_INVALIDATED = "Key disabled",
	ALREADY_USED = "Key already used",
	HWID_MISMATCH = "Key is bound to another device",
	SERVICE_NOT_FOUND = "Key system offline",
	SERVICE_MISMATCH = "Key is for another script",
	PREMIUM_REQUIRED = "Premium key required",
	RATE_LIMITED = "Too many tries, wait 5 minutes",
	ERROR = "Network error",
}

local STALE = {
	KEY_INVALID = true,
	KEY_EXPIRED = true,
	KEY_INVALIDATED = true,
	ALREADY_USED = true,
	SERVICE_MISMATCH = true,
}

local function describe(code)
	code = tostring(code or "")

	if MESSAGES[code] then
		return MESSAGES[code]
	end

	if code:match("^http %d+") then
		return "Server error (" .. code .. ")"
	end

	return code ~= "" and code or "Unknown error"
end

local function readKey()
	local ok, key = pcall(function()
		return isfile(CONFIG.KEY_FILE) and readfile(CONFIG.KEY_FILE)
	end)

	key = ok and type(key) == "string" and key:gsub("%s", "") or ""

	return key ~= "" and key or nil
end

local function saveKey(key)
	pcall(function()
		if not isfolder(CONFIG.FOLDER) then
			makefolder(CONFIG.FOLDER)
		end

		writefile(CONFIG.KEY_FILE, key)
	end)
end

local function forgetKey()
	pcall(delfile, CONFIG.KEY_FILE)
end

local function copy(text)
	return (pcall(setclipboard or toclipboard, text))
end

local function loadJunkie()
	local ok, lib = pcall(function()
		return loadstring(game:HttpGet("https://jnkie.com/sdk/library.lua"))()
	end)

	if not ok or type(lib) ~= "table" then
		return nil, lib
	end

	lib.service, lib.identifier, lib.provider = CONFIG.SERVICE, CONFIG.IDENTIFIER, CONFIG.PROVIDER

	return lib
end

local function check(junkie, key)
	local ok, res = pcall(junkie.check_key, key)

	if not ok or type(res) ~= "table" then
		return false, "ERROR"
	end

	local valid = res.valid == true or res.success == true

	return valid, tostring(valid and (res.message or "KEY_VALID") or res.error or res.message or "ERROR")
end

local function kick()
	pcall(player.Kick, player, "You are banned from " .. CONFIG.TITLE .. ".")
end

local function run(key)
	genv.SCRIPT_KEY = key

	local ok, err = pcall(function()
		loadstring(game:HttpGet(CONFIG.SCRIPT_URL))()
	end)

	if not ok then
		warn("[" .. CONFIG.TITLE .. "] " .. tostring(err))
	end
end

local THEME = {
	bg = Color3.fromRGB(6, 6, 8),
	panel = Color3.fromRGB(11, 11, 14),
	head = Color3.fromRGB(15, 15, 18),
	line = Color3.fromRGB(52, 52, 64),
	text = Color3.fromRGB(240, 240, 245),
	dim = Color3.fromRGB(122, 122, 134),
	accent = Color3.fromRGB(255, 255, 255),
	good = Color3.fromRGB(120, 220, 150),
	bad = Color3.fromRGB(255, 110, 110),
}

local quick = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

local function new(class, props, parent)
	local o = Instance.new(class)

	for k, v in pairs(props) do
		o[k] = v
	end

	o.Parent = parent

	return o
end

local function round(o, r)
	new("UICorner", { CornerRadius = UDim.new(0, r) }, o)
end

local function ring(o, t)
	new("UIStroke", { Color = THEME.line, Transparency = t, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }, o)
end

local function fade(o, keys)
	new("UIGradient", { Transparency = NumberSequence.new(keys) }, o)
end

local function anim(o, props)
	TweenService:Create(o, quick, props):Play()
end

local function mount(gui)
	for _, find in ipairs({
		function() return gethui() end,
		function() return game:GetService("CoreGui") end,
		function() return player:WaitForChild("PlayerGui", 5) end,
	}) do
		local ok, parent = pcall(find)

		if ok and typeof(parent) == "Instance" and pcall(function() gui.Parent = parent end) then
			return
		end
	end
end

local function keyWindow(junkie)
	local closed = Instance.new("BindableEvent")
	local result

	local gui = new("ScreenGui", {
		ResetOnSpawn = false,
		IgnoreGuiInset = true,
		DisplayOrder = 1001,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
	})

	pcall(protect_gui or protectgui or (syn and syn.protect_gui), gui)
	mount(gui)

	local view = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1280, 720)

	local frame = new("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(math.min(340, view.X - 24), 142),
		BackgroundColor3 = THEME.panel,
		BorderSizePixel = 0,
		Active = true,
	}, gui)

	round(frame, 8)
	ring(frame, 0.55)

	new("UIGradient", {
		Rotation = 90,
		Color = ColorSequence.new(Color3.new(1, 1, 1), Color3.fromRGB(178, 178, 190)),
	}, frame)

	local scale = new("UIScale", { Scale = 0.92 }, frame)

	local cap = new("Frame", {
		Size = UDim2.new(1, 0, 0, 30),
		BackgroundColor3 = THEME.head,
		BorderSizePixel = 0,
		Active = true,
	}, frame)

	round(cap, 8)

	new("Frame", {
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.fromScale(0, 1),
		Size = UDim2.new(1, 0, 0, 8),
		BackgroundColor3 = THEME.head,
		BorderSizePixel = 0,
	}, cap)

	new("TextLabel", {
		Position = UDim2.fromOffset(12, 0),
		Size = UDim2.new(1, -48, 1, 0),
		BackgroundTransparency = 1,
		Font = Enum.Font.GothamBold,
		Text = CONFIG.TITLE,
		TextColor3 = THEME.text,
		TextSize = 13,
		TextXAlignment = Enum.TextXAlignment.Left,
	}, cap)

	local close = new("TextButton", {
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -5, 0.5, 0),
		Size = UDim2.fromOffset(22, 22),
		BackgroundColor3 = THEME.accent,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		AutoButtonColor = false,
		Text = "",
	}, cap)

	round(close, 6)

	local cross = {}

	for i, angle in ipairs({ 45, -45 }) do
		cross[i] = new("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromOffset(10, 1.5),
			Rotation = angle,
			BackgroundColor3 = THEME.dim,
			BorderSizePixel = 0,
		}, close)
	end

	close.MouseEnter:Connect(function()
		anim(close, { BackgroundTransparency = 0.92 })

		for _, bar in ipairs(cross) do
			anim(bar, { BackgroundColor3 = THEME.text })
		end
	end)

	close.MouseLeave:Connect(function()
		anim(close, { BackgroundTransparency = 1 })

		for _, bar in ipairs(cross) do
			anim(bar, { BackgroundColor3 = THEME.dim })
		end
	end)

	local rule = new("Frame", {
		Position = UDim2.fromOffset(0, 30),
		Size = UDim2.new(1, 0, 0, 2),
		BackgroundColor3 = THEME.accent,
		BackgroundTransparency = 0.45,
		BorderSizePixel = 0,
	}, frame)

	fade(rule, {
		NumberSequenceKeypoint.new(0, 1),
		NumberSequenceKeypoint.new(0.12, 0.2),
		NumberSequenceKeypoint.new(0.5, 0),
		NumberSequenceKeypoint.new(0.88, 0.2),
		NumberSequenceKeypoint.new(1, 1),
	})

	local box = new("TextBox", {
		Position = UDim2.fromOffset(12, 44),
		Size = UDim2.new(1, -24, 0, 30),
		BackgroundColor3 = THEME.bg,
		BorderSizePixel = 0,
		ClearTextOnFocus = false,
		Font = Enum.Font.GothamMedium,
		PlaceholderColor3 = THEME.dim,
		PlaceholderText = "Key",
		Text = "",
		TextColor3 = THEME.text,
		TextSize = 13,
		TextTruncate = Enum.TextTruncate.AtEnd,
		TextXAlignment = Enum.TextXAlignment.Left,
	}, frame)

	round(box, 6)
	ring(box, 0.62)
	new("UIPadding", { PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10) }, box)

	local function button(text, x)
		local slab = new("Frame", {
			Position = UDim2.new(x, x == 0 and 12 or 4, 0, 82),
			Size = UDim2.new(0.5, -16, 0, 28),
			BackgroundColor3 = THEME.head,
			BackgroundTransparency = 0.12,
			BorderSizePixel = 0,
			ClipsDescendants = true,
		}, frame)

		round(slab, 6)
		ring(slab, 0.62)

		local label = new("TextLabel", {
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			Font = Enum.Font.GothamBold,
			Text = text,
			TextColor3 = THEME.dim,
			TextTransparency = 0.25,
			TextSize = 13,
		}, slab)

		local beam = new("Frame", {
			AnchorPoint = Vector2.new(0.5, 1),
			Position = UDim2.fromScale(0.5, 1),
			Size = UDim2.new(1, 0, 0, 1),
			BackgroundColor3 = THEME.accent,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
		}, slab)

		fade(beam, {
			NumberSequenceKeypoint.new(0, 1),
			NumberSequenceKeypoint.new(0.5, 0),
			NumberSequenceKeypoint.new(1, 1),
		})

		local tap = new("TextButton", {
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			AutoButtonColor = false,
			Text = "",
		}, slab)

		tap.MouseEnter:Connect(function()
			anim(label, { TextColor3 = THEME.text, TextTransparency = 0 })
			anim(beam, { BackgroundTransparency = 0.35 })
		end)

		tap.MouseLeave:Connect(function()
			anim(label, { TextColor3 = THEME.dim, TextTransparency = 0.25 })
			anim(beam, { BackgroundTransparency = 1 })
		end)

		return tap
	end

	local getKey = button("Get Key", 0)
	local checkKey = button("Check Key", 0.5)

	local status = new("TextLabel", {
		Position = UDim2.fromOffset(12, 118),
		Size = UDim2.new(1, -24, 0, 14),
		BackgroundTransparency = 1,
		Font = Enum.Font.GothamMedium,
		Text = "",
		TextColor3 = THEME.dim,
		TextSize = 12,
		TextTruncate = Enum.TextTruncate.AtEnd,
		TextXAlignment = Enum.TextXAlignment.Left,
	}, frame)

	local function say(text, color)
		status.Text = text
		status.TextColor3 = color or THEME.dim
	end

	local dragging, start, origin, finger

	cap.InputBegan:Connect(function(input)
		local kind = input.UserInputType

		if kind == Enum.UserInputType.MouseButton1 or kind == Enum.UserInputType.Touch then
			dragging, start, origin = true, input.Position, frame.Position
			finger = kind == Enum.UserInputType.Touch and input or nil
		end
	end)

	local moved = UserInputService.InputChanged:Connect(function(input)
		if not dragging or (finger and input ~= finger) then
			return
		end

		if not finger and input.UserInputType ~= Enum.UserInputType.MouseMovement then
			return
		end

		local delta = input.Position - start

		frame.Position = UDim2.new(origin.X.Scale, origin.X.Offset + delta.X, origin.Y.Scale, origin.Y.Offset + delta.Y)
	end)

	local released = UserInputService.InputEnded:Connect(function(input)
		if input == finger or input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging, finger = false, nil
		end
	end)

	TweenService:Create(scale, TweenInfo.new(0.2, Enum.EasingStyle.Quint), { Scale = 1 }):Play()

	local function finish(value)
		if result ~= nil then
			return
		end

		result = value or false
		moved:Disconnect()
		released:Disconnect()

		local out = TweenService:Create(scale, TweenInfo.new(0.15, Enum.EasingStyle.Quint, Enum.EasingDirection.In), { Scale = 0.9 })

		out:Play()
		out.Completed:Wait()
		gui:Destroy()
		closed:Fire()
	end

	local busy, attempts, link = false, 0, nil

	getKey.Activated:Connect(function()
		if busy then
			return
		end

		busy = true
		say("Getting link...")

		task.spawn(function()
			local ok, fresh, err = pcall(junkie.get_key_link)

			if ok and type(fresh) == "string" and fresh ~= "" then
				link = fresh
			end

			if not link then
				say(describe(ok and err or "ERROR"), THEME.bad)
			elseif copy(link) then
				say("Link copied, open it in your browser", THEME.good)
			else
				box.Text = link
				say("Open the link from the box in your browser", THEME.good)
			end

			busy = false
		end)
	end)

	local function submit()
		if busy then
			return
		end

		local key = box.Text:gsub("%s", "")

		if key == "" or key:match("^https?://") then
			say("Paste your key", THEME.bad)
			return
		end

		busy = true
		attempts += 1
		say("Checking...")

		task.spawn(function()
			local valid, code = check(junkie, key)

			if valid then
				say(describe(code), THEME.good)
				saveKey(key)
				task.wait(0.35)
				finish(key)
				return
			end

			if code == "HWID_BANNED" then
				finish(false)
				kick()
				return
			end

			if attempts >= CONFIG.MAX_ATTEMPTS then
				say("Too many tries, rejoin", THEME.bad)
				task.wait(2)
				finish(false)
				return
			end

			say(describe(code), THEME.bad)
			busy = false
		end)
	end

	checkKey.Activated:Connect(submit)

	box.FocusLost:Connect(function(enter)
		if enter then
			submit()
		end
	end)

	close.Activated:Connect(function()
		finish(false)
	end)

	if result == nil then
		closed.Event:Wait()
	end

	return result or nil
end

if genv.__SaladKeyLoader then
	return
end

genv.__SaladKeyLoader = true

local ok, err = pcall(function()
	local junkie, why = loadJunkie()

	if not junkie then
		warn("[" .. CONFIG.TITLE .. "] " .. tostring(why))
		return
	end

	local saved = readKey()
	local valid, code = check(junkie, saved or "KEYLESS")

	if code == "HWID_BANNED" then
		kick()
		return
	end

	if valid then
		run(saved or "KEYLESS")
		return
	end

	if saved and STALE[code] then
		forgetKey()
	end

	local key = keyWindow(junkie)

	if key then
		run(key)
	end
end)

genv.__SaladKeyLoader = nil

if not ok then
	warn("[" .. CONFIG.TITLE .. "] " .. tostring(err))
end

do ("JNKIE Loader - Unauthorized tampering or debugging of protected scripts is strictly prohibited and may result in a global blacklist from JNKIE protected scripts."):sub(1,1);local k=getgenv().SCRIPT_KEY or SCRIPT_KEY;local m="Could not load the script. Check your internet connection and try again later.";local function v(h)warn(h);task.spawn(function()pcall(function()game:GetService("Players").LocalPlayer:Kick(h)end);task.wait();pcall(function()local p=game:GetService("CoreGui").RobloxPromptGui.promptOverlay.ErrorPrompt;p.TitleFrame.ErrorTitle.Text="JNKIE";p.MessageArea.ErrorFrame.ErrorMessage.Text=h end)end)end;local r=(type(syn)=="table" and type(syn.request)=="function" and syn.request)or(type(request)=="function" and request)or(type(http_request)=="function" and http_request)or(type(http)=="table" and type(http.request)=="function" and http.request);if type(k)~="string" then v("No key provided. Get a key from the script provider, enter it, then try again.");return end;if type(r)~="function" then warn(m);return end;local function q(o)local d,a,x;task.spawn(function()a,x=pcall(r,o);d=true end);local s=os.clock();repeat task.wait()until d or os.clock()-s>15;if not d then return false,nil end;return a,x end;local a,x=q({Url="https://api.jnkie.com/api/v1/luascripts/delivery/460efca1c00d926766e8d919b5eb6f05036c159d3450a504609eed6c922b045f?v=2&errors=text",Method="POST",Headers={["Content-Type"]="text/plain"},Body=k});local h=a and type(x)=="table" and type(x.Body)=="string" and(x.StatusCode==400 or x.StatusCode==401 or x.StatusCode==403)and x.Body;if h then local c,n=h:match("^([^\r\n]+)\n([^\r\n]+)$");c=c or h;if#c<=75 and(c=="LDR-DENIED"or c:match("^LDR%-DENIED:[A-Z_]+$"))then if not n or#n>512 then n=m;if k==""or k:match("^%s*$")then n="No key provided. Get a key from the script provider, enter it, then try again." end end;v(n.." ("..c..")");return end end;if a and type(x)=="table" and x.StatusCode==200 and type(x.Body)=="string" and (string.sub(x.Body,1,8)=="https://") then a,x=q({Url=x.Body,Method="GET"})end;if a and type(x)=="table" and(x.StatusCode==302 or x.StatusCode==303)then local h=x.Headers or x.headers;local l=type(h)=="table" and(h.Location or h.location);if type(l)=="string" and (string.sub(l,1,8)=="https://") then a,x=q({Url=l,Method="GET"})end end;if not a or type(x)~="table" or x.StatusCode~=200 or type(x.Body)~="string" or#x.Body==0 then warn(m);return end;local b=x.Body;x=nil;local f=loadstring(b);b=nil;if type(f)~="function" then warn(m);return end;f()end