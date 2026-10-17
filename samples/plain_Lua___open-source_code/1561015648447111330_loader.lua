--[[
  ScriptVerse Key System Loader
  Usage:
    loadstring(game:HttpGet("https://scriptversekey.xyz/s/YOURSLUG"))()
    or loadstring(game:HttpGet("https://scriptversekey.xyz/sv.lua"))()
]]

local API_BASE = "https://scriptversekey.xyz"
local GET_KEY_URL = API_BASE .. "/?view=choose"
local LOGO_URL = API_BASE .. "/logo.png"
local SITE_NAME = "ScriptVerse"

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()
local PLACE_ID = tostring(game.PlaceId)
local loadcode = loadstring or load

-- Tiny Solara-safe require shim prepended to every game hub
local SCRIPT_COMPAT_PREFIX = [=[
-- ScriptVerse Solara compat (auto)
do
	local g = (getgenv and getgenv()) or _G
	local C = rawget(g, "SVCompat")
	if type(C) ~= "table" or not C.__svcompat then
		local function executorName()
			local ok, n = pcall(function()
				return (identifyexecutor and identifyexecutor()) or (getexecutorname and getexecutorname()) or ""
			end)
			return (ok and tostring(n) or ""):lower()
		end
		local exec = executorName()
		local isSolara = exec:find("solara", 1, true) ~= nil
		local realRequire = require
		C = {
			__svcompat = true,
			Executor = exec,
			IsSolara = isSolara,
			AllowRequire = not isSolara,
			AllowHooks = (not isSolara) and typeof(hookmetamethod) == "function",
			AllowGc = (not isSolara) and typeof(getgc) == "function",
			AllowDrawing = typeof(Drawing) == "table" and typeof(Drawing.new) == "function",
		}
		function C.softRequire(mod)
			if mod == nil then return nil end
			if C.IsSolara and typeof(mod) == "Instance" then return nil end
			local ok, res = pcall(realRequire, mod)
			return ok and res or nil
		end
		C.require = C.softRequire
		g.SVCompat = C
	end
end
local require = (function()
	local g = (getgenv and getgenv()) or _G
	local C = rawget(g, "SVCompat")
	if type(C) == "table" and type(C.require) == "function" then
		return C.require
	end
	return require
end)()
]=]

local SV_SLUG = (function()
	local ok, g = pcall(function()
		return (getgenv and getgenv()) or _G
	end)
	if ok and g and type(g.SV_SLUG) == "string" and #g.SV_SLUG > 0 then
		return g.SV_SLUG
	end
	return nil
end)()

local function getHWID()
	local candidates = {
		function()
			return gethwid and gethwid()
		end,
		function()
			return getexecutorname and (tostring(getexecutorname()) .. ":" .. tostring(LocalPlayer.UserId))
		end,
		function()
			return identifyexecutor and (tostring(identifyexecutor()) .. ":" .. tostring(LocalPlayer.UserId))
		end,
		function()
			return tostring(LocalPlayer.UserId) .. ":" .. tostring(game.JobId)
		end,
	}
	for _, fn in ipairs(candidates) do
		local ok, value = pcall(fn)
		if ok and type(value) == "string" and #value > 3 then
			return value
		end
	end
	return "fallback-" .. tostring(LocalPlayer.UserId)
end

local function requestAsync(opts)
	local req = (syn and syn.request)
		or (http and http.request)
		or http_request
		or request
		or (fluxus and fluxus.request)
		or (http and http.request)

	if req then
		local ok, res = pcall(req, {
			Url = opts.Url,
			Method = opts.Method or "GET",
			Headers = opts.Headers or {},
			Body = opts.Body,
		})
		if ok and type(res) == "table" then
			local code = tonumber(res.StatusCode or res.Status or res.status_code or res.status)
			-- Some executors (incl. Solara variants) only set Success + Body
			if not code and res.Success == true then
				code = 200
			end
			return code or 0, tostring(res.Body or res.body or res.Data or "")
		end
	end

	if (opts.Method or "GET") == "GET" then
		local ok, body = pcall(function()
			return game:HttpGet(opts.Url)
		end)
		if ok and type(body) == "string" then
			return 200, body
		end
	else
		local ok, body = pcall(function()
			if game.HttpPost then
				return game:HttpPost(opts.Url, opts.Body or "", "application/json")
			end
			return nil
		end)
		if ok and type(body) == "string" then
			return 200, body
		end
	end

	error("No HTTP request function on this executor (need request/http_request/syn.request)")
end

local function apiPost(path, payload)
	local status, body = requestAsync({
		Url = API_BASE .. path,
		Method = "POST",
		Headers = {
			["Content-Type"] = "application/json",
			["X-Key"] = payload.key or "",
			["X-HWID"] = payload.hwid or "",
			["X-Place-Id"] = PLACE_ID,
		},
		Body = HttpService:JSONEncode(payload),
	})
	local decoded = nil
	pcall(function()
		decoded = HttpService:JSONDecode(body)
	end)
	return status, decoded, body
end

local function saveKey(key)
	pcall(function()
		if writefile then
			writefile("ScriptVerseKey.txt", key)
		end
	end)
end

local function clearSavedKey()
	pcall(function()
		if isfile and delfile and isfile("ScriptVerseKey.txt") then
			delfile("ScriptVerseKey.txt")
		elseif writefile then
			writefile("ScriptVerseKey.txt", "")
		end
	end)
end

local function loadSavedKey()
	local ok, data = pcall(function()
		if isfile and isfile("ScriptVerseKey.txt") and readfile then
			return readfile("ScriptVerseKey.txt")
		end
		return nil
	end)
	if ok and type(data) == "string" and #data > 5 then
		return data:gsub("%s+", "")
	end
	return ""
end

local function protect(gui)
	pcall(function()
		if syn and syn.protect_gui then
			syn.protect_gui(gui)
		end
	end)
	pcall(function()
		if protect_gui then
			protect_gui(gui)
		end
	end)

	local parented = false
	pcall(function()
		if type(gethui) ~= "function" then
			return
		end
		local h = gethui()
		if typeof(h) ~= "Instance" then
			return
		end
		-- Cobalt gethui() is RobloxGui (a ScreenGui). Nesting our ScreenGui there
		-- paints a fullscreen black rectangle over the game.
		if h:IsA("ScreenGui") or h.Name == "RobloxGui" then
			return
		end
		local p = h
		while typeof(p) == "Instance" do
			if p:IsA("ScreenGui") or p.Name == "RobloxGui" then
				return
			end
			p = p.Parent
		end
		gui.Parent = h
		parented = true
	end)
	if not parented then
		local ok = pcall(function()
			gui.Parent = CoreGui
		end)
		if not ok then
			gui.Parent = LocalPlayer:WaitForChild("PlayerGui")
		end
	end
	pcall(function()
		if gui:IsA("GuiObject") then
			gui.BackgroundTransparency = 1
			gui.BorderSizePixel = 0
		end
	end)
end

local function applyLogo(imageLabel)
	imageLabel.Image = LOGO_URL
	task.defer(function()
		pcall(function()
			local bytes = game:HttpGet(LOGO_URL)
			if type(bytes) ~= "string" or #bytes < 50 or not writefile then
				return
			end
			local name = "ScriptVerseLogo.png"
			writefile(name, bytes)
			local assetFn = getcustomasset or getsynasset or getasset
			if assetFn then
				imageLabel.Image = assetFn(name)
			end
		end)
	end)
end

-- =========================
-- UI
-- =========================

local existing = CoreGui:FindFirstChild("ScriptVerseKeyUI")
	or (LocalPlayer:FindFirstChild("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("ScriptVerseKeyUI"))
pcall(function()
	if gethui then
		local h = gethui():FindFirstChild("ScriptVerseKeyUI")
		if h then
			h:Destroy()
		end
	end
end)
if existing then
	existing:Destroy()
end

local viewport = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1280, 720)
local isCompact = viewport.X < 500 or (UserInputService.TouchEnabled and viewport.X < 900)
local cardW = isCompact and math.clamp(math.floor(viewport.X * 0.92), 260, 380) or 380
local cardH = isCompact and 340 or 320

local gui = Instance.new("ScreenGui")
gui.Name = "ScriptVerseKeyUI"
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.DisplayOrder = 999
protect(gui)

local blur = Instance.new("BlurEffect")
blur.Name = "ScriptVerseBlur"
blur.Size = 0
blur.Parent = Lighting
TweenService:Create(blur, TweenInfo.new(0.35, Enum.EasingStyle.Quad), { Size = 12 }):Play()

local dim = Instance.new("Frame")
dim.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
dim.BackgroundTransparency = 1
dim.BorderSizePixel = 0
dim.Size = UDim2.fromScale(1, 1)
dim.Active = false
dim.Parent = gui
TweenService:Create(dim, TweenInfo.new(0.35), { BackgroundTransparency = 0.45 }):Play()

local card = Instance.new("Frame")
card.Name = "Card"
card.AnchorPoint = Vector2.new(0.5, 0.5)
card.Position = UDim2.fromScale(0.5, 0.52)
card.Size = UDim2.fromOffset(cardW, cardH)
card.BackgroundColor3 = Color3.fromRGB(16, 18, 24)
card.BorderSizePixel = 0
card.ClipsDescendants = true
card.Parent = gui
card.BackgroundTransparency = 0.05

local cardScale = Instance.new("UIScale")
cardScale.Scale = 0.94
cardScale.Parent = card

local sizeConstraint = Instance.new("UISizeConstraint")
sizeConstraint.MinSize = Vector2.new(260, 300)
sizeConstraint.MaxSize = Vector2.new(420, 420)
sizeConstraint.Parent = card

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 16)
corner.Parent = card

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(55, 60, 75)
stroke.Thickness = 1
stroke.Transparency = 0.2
stroke.Parent = card

local pad = Instance.new("UIPadding")
pad.PaddingTop = UDim.new(0, 16)
pad.PaddingBottom = UDim.new(0, 14)
pad.PaddingLeft = UDim.new(0, 16)
pad.PaddingRight = UDim.new(0, 16)
pad.Parent = card

TweenService
	:Create(card, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
		Position = UDim2.fromScale(0.5, 0.5),
	})
	:Play()
TweenService:Create(cardScale, TweenInfo.new(0.4, Enum.EasingStyle.Quint), { Scale = 1 }):Play()

-- Header: logo + title
local header = Instance.new("Frame")
header.BackgroundTransparency = 1
header.Size = UDim2.new(1, 0, 0, 40)
header.Parent = card

local logo = Instance.new("ImageLabel")
logo.BackgroundTransparency = 1
logo.Size = UDim2.fromOffset(36, 36)
logo.Position = UDim2.fromOffset(0, 2)
logo.ScaleType = Enum.ScaleType.Fit
logo.Image = ""
logo.Parent = header
applyLogo(logo)

local title = Instance.new("TextLabel")
title.BackgroundTransparency = 1
title.Position = UDim2.fromOffset(46, 0)
title.Size = UDim2.new(1, -46, 1, 0)
title.Font = Enum.Font.GothamBold
title.TextSize = isCompact and 20 or 22
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextYAlignment = Enum.TextYAlignment.Center
title.TextColor3 = Color3.fromRGB(244, 245, 247)
title.RichText = true
title.Text = 'Script<font color="#3B82F6">Verse</font>'
title.Parent = header

local subtitle = Instance.new("TextLabel")
subtitle.BackgroundTransparency = 1
subtitle.Position = UDim2.new(0, 0, 0, 46)
subtitle.Size = UDim2.new(1, 0, 0, 18)
subtitle.Font = Enum.Font.Gotham
subtitle.TextSize = 13
subtitle.TextColor3 = Color3.fromRGB(139, 144, 160)
subtitle.Text = "Enter your key to unlock scripts"
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.Parent = card

local status = Instance.new("TextLabel")
status.Name = "Status"
status.BackgroundTransparency = 1
status.Position = UDim2.new(0, 0, 0, 68)
status.Size = UDim2.new(1, 0, 0, 18)
status.Font = Enum.Font.GothamMedium
status.TextSize = 12
status.TextColor3 = Color3.fromRGB(106, 112, 128)
status.Text = "Waiting for key..."
status.TextXAlignment = Enum.TextXAlignment.Left
status.TextWrapped = true
status.Parent = card

local input = Instance.new("TextBox")
input.Position = UDim2.new(0, 0, 0, 96)
input.Size = UDim2.new(1, 0, 0, 44)
input.BackgroundColor3 = Color3.fromRGB(10, 11, 14)
input.BorderSizePixel = 0
input.ClearTextOnFocus = false
input.Font = Enum.Font.Code
input.TextSize = isCompact and 13 or 14
input.PlaceholderText = "SV-XXXX-XXXX-XXXX-XXXX"
input.PlaceholderColor3 = Color3.fromRGB(80, 86, 100)
input.TextColor3 = Color3.fromRGB(220, 225, 235)
input.Text = loadSavedKey()
input.TextXAlignment = Enum.TextXAlignment.Left
input.TextTruncate = Enum.TextTruncate.AtEnd
input.Parent = card

local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0, 10)
inputCorner.Parent = input

local inputPad = Instance.new("UIPadding")
inputPad.PaddingLeft = UDim.new(0, 12)
inputPad.PaddingRight = UDim.new(0, 12)
inputPad.Parent = input

local inputStroke = Instance.new("UIStroke")
inputStroke.Color = Color3.fromRGB(50, 55, 70)
inputStroke.Thickness = 1
inputStroke.Parent = input

local function makeButton(text, y, color, textColor)
	local btn = Instance.new("TextButton")
	btn.Position = UDim2.new(0, 0, 0, y)
	btn.Size = UDim2.new(1, 0, 0, 42)
	btn.BackgroundColor3 = color
	btn.BorderSizePixel = 0
	btn.AutoButtonColor = false
	btn.Font = Enum.Font.GothamMedium
	btn.TextSize = 14
	btn.TextColor3 = textColor
	btn.Text = text
	btn.Parent = card

	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, 10)
	c.Parent = btn

	btn.MouseEnter:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.15), { BackgroundColor3 = color:Lerp(Color3.new(1, 1, 1), 0.08) })
			:Play()
	end)
	btn.MouseLeave:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.15), { BackgroundColor3 = color }):Play()
	end)

	return btn
end

local continueBtn = makeButton("Continue", 152, Color3.fromRGB(37, 99, 235), Color3.fromRGB(235, 245, 255))
local getKeyBtn = makeButton("Get Key", 204, Color3.fromRGB(30, 33, 42), Color3.fromRGB(220, 225, 235))
local getKeyStroke = Instance.new("UIStroke")
getKeyStroke.Color = Color3.fromRGB(60, 65, 80)
getKeyStroke.Parent = getKeyBtn

local footer = Instance.new("TextLabel")
footer.BackgroundTransparency = 1
footer.Position = UDim2.new(0, 0, 0, cardH - 16 - 28)
footer.Size = UDim2.new(1, 0, 0, 28)
footer.Font = Enum.Font.Gotham
footer.TextSize = 11
footer.TextColor3 = Color3.fromRGB(90, 96, 110)
footer.TextXAlignment = Enum.TextXAlignment.Left
footer.TextYAlignment = Enum.TextYAlignment.Top
footer.TextWrapped = true
footer.TextTruncate = Enum.TextTruncate.AtEnd
do
	local bits = { "Place " .. PLACE_ID }
	if SV_SLUG then
		table.insert(bits, tostring(SV_SLUG))
	end
	footer.Text = table.concat(bits, " - ")
end
footer.Parent = card

local busy = false

local function setStatus(text, color)
	status.Text = text
	status.TextColor3 = color or Color3.fromRGB(106, 112, 128)
end

local function closeUI()
	-- Destroy blur immediately so a hung script doesn't leave the screen stuck
	pcall(function()
		if blur then
			blur:Destroy()
			blur = nil
		end
		local leftover = Lighting:FindFirstChild("ScriptVerseBlur")
		if leftover then
			leftover:Destroy()
		end
	end)
	pcall(function()
		if gui then
			gui:Destroy()
			gui = nil
		end
	end)
end

local function runProtectedScript(source)
	if type(source) ~= "string" or #source < 2 then
		error("Empty script")
	end
	local fn, err = loadcode(source)
	if not fn then
		error("Script compile failed: " .. tostring(err))
	end
	return fn()
end

local function bindClick(btn, fn)
	local last = 0
	local function wrap()
		local now = os.clock()
		if now - last < 0.45 then
			return
		end
		last = now
		fn()
	end
	btn.MouseButton1Click:Connect(wrap)
	pcall(function()
		btn.Activated:Connect(wrap)
	end)
end

local function validateAndLoad()
	if busy then
		return
	end
	busy = true
	continueBtn.Text = "Checking..."
	setStatus("Validating key...", Color3.fromRGB(147, 197, 253))

	local key = (input.Text or ""):gsub("%s+", "")
	if #key < 8 then
		setStatus("Enter a valid key", Color3.fromRGB(248, 113, 113))
		continueBtn.Text = "Continue"
		busy = false
		return
	end

	local okRun, errRun = pcall(function()
		local hwid = getHWID()
		local statusCode, data = apiPost("/api/v1/validate", {
			key = key,
			hwid = hwid,
			placeId = PLACE_ID,
		})

		if statusCode ~= 200 or not data or data.ok ~= true or data.valid ~= true then
			local msg = (data and data.error) or "Invalid key"
			local code = data and data.code
			if code == "redeemed" or (type(msg) == "string" and msg:lower():find("already", 1, true)) then
				clearSavedKey()
			end
			setStatus(tostring(msg), Color3.fromRGB(248, 113, 113))
			continueBtn.Text = "Continue"
			busy = false
			return
		end

		if data.keyType ~= "onetime" then
			saveKey(key)
		else
			clearSavedKey()
		end

		setStatus("Key accepted - loading script...", Color3.fromRGB(74, 222, 128))

		local sc, scriptData = apiPost("/api/v1/script", {
			key = key,
			hwid = hwid,
			placeId = PLACE_ID,
			slug = SV_SLUG,
		})

		if sc ~= 200 or not scriptData or type(scriptData.script) ~= "string" or #scriptData.script < 2 then
			local msg = (scriptData and scriptData.error) or ("Script unavailable (" .. tostring(sc) .. ")")
			setStatus(tostring(msg), Color3.fromRGB(251, 191, 36))
			continueBtn.Text = "Continue"
			busy = false
			return
		end

		-- Compile before closing UI so failures stay visible.
		-- API already prepends SV_COMPAT_PREFIX — don't double-prefix (breaks some executors).
		local scriptSource = scriptData.script
		if type(scriptSource) ~= "string" or not scriptSource:find("SVCompat", 1, true) then
			scriptSource = SCRIPT_COMPAT_PREFIX .. "\n" .. tostring(scriptSource or "")
		end
		local scriptFn, scriptErr = loadcode(scriptSource)
		if not scriptFn then
			local detail = tostring(scriptErr or "unknown")
			if #detail > 80 then
				detail = detail:sub(1, 77) .. "..."
			end
			setStatus("Script compile failed: " .. detail, Color3.fromRGB(248, 113, 113))
			warn("[ScriptVerse] compile:", scriptErr)
			continueBtn.Text = "Continue"
			busy = false
			return
		end

		local uiFn = nil
		if type(scriptData.svui) == "string" and #scriptData.svui > 0 then
			local ufn, uerr = loadcode(scriptData.svui)
			if ufn then
				uiFn = ufn
			else
				warn("[ScriptVerse] SVUI compile:", uerr)
			end
		end

		setStatus("Loaded " .. tostring(scriptData.name or "script"), Color3.fromRGB(74, 222, 128))
		closeUI()
		task.spawn(function()
			task.wait(0.25)
			if uiFn then
				local okUi, uiLibOrErr = pcall(uiFn)
				if okUi then
					local g = (getgenv and getgenv()) or _G
					if type(uiLibOrErr) == "table" then
						g.SVUI = uiLibOrErr
					end
				else
					warn("[ScriptVerse] SVUI error:", uiLibOrErr)
				end
			end
			task.wait(0.1)
			local ok, err = pcall(scriptFn)
			if not ok then
				warn("[ScriptVerse] Script error:", err)
			end
		end)
	end)

	if not okRun then
		setStatus("Error: " .. tostring(errRun), Color3.fromRGB(248, 113, 113))
		continueBtn.Text = "Continue"
		busy = false
		warn("[ScriptVerse]", errRun)
	end
end

bindClick(continueBtn, validateAndLoad)
input.FocusLost:Connect(function(enter)
	if enter then
		validateAndLoad()
	end
end)

bindClick(getKeyBtn, function()
	setStatus("Get Key URL copied - paste in browser", Color3.fromRGB(253, 224, 71))
	pcall(function()
		if setclipboard then
			setclipboard(GET_KEY_URL)
		elseif toclipboard then
			toclipboard(GET_KEY_URL)
		end
	end)
end)

-- Drag (mouse + touch)
do
	local dragging = false
	local dragStart, startPos
	card.InputBegan:Connect(function(inputObj)
		if
			inputObj.UserInputType == Enum.UserInputType.MouseButton1
			or inputObj.UserInputType == Enum.UserInputType.Touch
		then
			dragging = true
			dragStart = inputObj.Position
			startPos = card.Position
			inputObj.Changed:Connect(function()
				if inputObj.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)
	UserInputService.InputChanged:Connect(function(inputObj)
		if
			dragging
			and (
				inputObj.UserInputType == Enum.UserInputType.MouseMovement
				or inputObj.UserInputType == Enum.UserInputType.Touch
			)
		then
			local delta = inputObj.Position - dragStart
			card.Position =
				UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
end

-- Do not auto-submit saved keys (breaks onetime UX with "already used")
