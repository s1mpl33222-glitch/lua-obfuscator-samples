RIFT_CONFIG = {
	API_BASE = "https://riftscripts.up.railway.app",
	SCRIPT_ID = "hlwn-evade",
	SCRIPT_NAME = "Evade",
	REQUIRES_KEY = true,
	STATUS = "WORKING",
	HUB = false,
	WORKINK = true,
	LINKVERTISE = true,
	DISCORD = "https://discord.gg/DHb6t8DhqA",
}
--[[
	██████╗ ██╗███████╗████████╗
	██╔══██╗██║██╔════╝╚══██╔══╝
	██████╔╝██║█████╗     ██║
	██╔══██╗██║██╔══╝     ██║
	██║  ██║██║██║        ██║
	╚═╝  ╚═╝╚═╝╚═╝        ╚═╝   Key System Loader

	Served by /api/v1/loader/<slug> and /api/v1/hub — the server injects
	RIFT_CONFIG as a global before this code, so it can be obfuscated safely.
	Usage:  loadstring(game:HttpGet("https://your-site.com/api/v1/loader/<slug>"))()
]]

local CONFIG = RIFT_CONFIG or {}
RIFT_CONFIG = nil
CONFIG.CACHE_FILE = "Rift/key.txt"
CONFIG.ACCENT = Color3.fromRGB(168, 85, 247)
CONFIG.ACCENT_DARK = Color3.fromRGB(124, 58, 237)
CONFIG.LOGO = "rbxassetid://75876733222469"
CONFIG.WAIFU = "rbxassetid://85708246103612"

-- Prevent double-injection of the UI
if getgenv and getgenv().__RIFT_LOADING then
	return
end
if getgenv then
	getgenv().__RIFT_LOADING = true
end

-------------------------------------------------------------------------------
-- Services
-------------------------------------------------------------------------------
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

-------------------------------------------------------------------------------
-- Executor compatibility layer
-------------------------------------------------------------------------------
local Compat = {}

Compat.request = (syn and syn.request)
	or (http and http.request)
	or http_request
	or request
	or (fluxus and fluxus.request)

Compat.setclipboard = setclipboard or toclipboard or (Clipboard and Clipboard.set)

Compat.hasFiles = type(isfile) == "function" and type(readfile) == "function" and type(writefile) == "function"

function Compat.getHwid()
	local fns = { gethwid, get_hwid, (syn and syn.gethwid) }
	for _, fn in ipairs(fns) do
		if type(fn) == "function" then
			local ok, id = pcall(fn)
			if ok and type(id) == "string" and #id >= 4 then
				return id
			end
		end
	end
	local ok, id = pcall(function()
		return game:GetService("RbxAnalyticsService"):GetClientId()
	end)
	if ok and type(id) == "string" then
		return id
	end
	return nil
end

function Compat.guiParent()
	if type(gethui) == "function" then
		local ok, hui = pcall(gethui)
		if ok and hui then
			return hui
		end
	end
	local ok, core = pcall(function()
		return game:GetService("CoreGui")
	end)
	if ok and core then
		return core
	end
	return Players.LocalPlayer:WaitForChild("PlayerGui")
end

--- Opens the invite in the Discord desktop app (local RPC), falls back to copying it.
--- Returns "opened", "copied" or "none".
function Compat.openDiscord(invite)
	local code = invite:match("discord%.gg/([%w%-]+)")
		or invite:match("discord%.com/invite/([%w%-]+)")
		or invite:match("discordapp%.com/invite/([%w%-]+)")
	if code and Compat.request then
		for port = 6463, 6472 do
			local ok, res = pcall(Compat.request, {
				Url = "http://127.0.0.1:" .. port .. "/rpc?v=1",
				Method = "POST",
				Headers = { ["Content-Type"] = "application/json", ["Origin"] = "https://discord.com" },
				Body = HttpService:JSONEncode({
					cmd = "INVITE_BROWSER",
					args = { code = code },
					nonce = HttpService:GenerateGUID(false),
				}),
			})
			if ok and type(res) == "table" and (res.StatusCode == 200 or res.Success == true) then
				return "opened"
			end
		end
	end
	if Compat.setclipboard then
		pcall(Compat.setclipboard, invite)
		return "copied"
	end
	return "none"
end

-------------------------------------------------------------------------------
-- Key cache
-------------------------------------------------------------------------------
local Cache = {}

function Cache.read()
	if not Compat.hasFiles then
		return nil
	end
	local ok, content = pcall(function()
		return isfile(CONFIG.CACHE_FILE) and readfile(CONFIG.CACHE_FILE) or nil
	end)
	if ok and content and #content > 0 then
		return (content:gsub("%s+", ""))
	end
	return nil
end

function Cache.write(key)
	if not Compat.hasFiles then
		return
	end
	pcall(function()
		if type(isfolder) == "function" and type(makefolder) == "function" and not isfolder("Rift") then
			makefolder("Rift")
		end
		writefile(CONFIG.CACHE_FILE, key)
	end)
end

local function seenFile(slug)
	return "Rift/changelog_" .. tostring(slug):gsub("[^%w%-_]", "") .. ".txt"
end

--- Id of the last changelog this user already saw for a script (or nil).
function Cache.getSeen(slug)
	if not Compat.hasFiles then
		return nil
	end
	local ok, content = pcall(function()
		local f = seenFile(slug)
		return isfile(f) and readfile(f) or nil
	end)
	if ok and content and #content > 0 then
		return (content:gsub("%s+", ""))
	end
	return nil
end

function Cache.setSeen(slug, id)
	if not Compat.hasFiles or not id then
		return
	end
	pcall(function()
		if type(isfolder) == "function" and type(makefolder) == "function" and not isfolder("Rift") then
			makefolder("Rift")
		end
		writefile(seenFile(slug), tostring(id))
	end)
end

function Cache.clear()
	if Compat.hasFiles and type(delfile) == "function" then
		pcall(function()
			if isfile(CONFIG.CACHE_FILE) then
				delfile(CONFIG.CACHE_FILE)
			end
		end)
	end
end

-------------------------------------------------------------------------------
-- API client
-------------------------------------------------------------------------------
local Api = {}

local function decode(body)
	local ok, data = pcall(function()
		return HttpService:JSONDecode(body)
	end)
	return ok and data or nil
end

function Api.post(path, payload)
	if not Compat.request then
		return nil, "Your executor does not support HTTP requests."
	end
	local ok, res = pcall(Compat.request, {
		Url = CONFIG.API_BASE .. path,
		Method = "POST",
		Headers = { ["Content-Type"] = "application/json" },
		Body = HttpService:JSONEncode(payload),
	})
	if not ok or not res then
		return nil, "Could not reach the Rift servers."
	end
	local data = decode(res.Body or "")
	if not data then
		return nil, "Unexpected server response (" .. tostring(res.StatusCode) .. ")."
	end
	return data, data.message
end

function Api.get(path)
	local ok, body = pcall(function()
		return game:HttpGet(CONFIG.API_BASE .. path)
	end)
	if ok then
		return body
	end
	return nil
end

function Api.getJson(path)
	local body = Api.get(path)
	if body then
		return decode(body)
	end
	return nil
end

--- Hub mode: ask the server which script belongs to this place id.
function Api.resolve(placeId)
	local data, msg = Api.post("/api/v1/resolve", { place_id = tostring(placeId) })
	if data and data.success and data.script then
		return data.script
	end
	return nil, msg or "No script is available for this game yet."
end

--- List of supported games (names only).
function Api.games()
	local data = Api.getJson("/api/v1/games")
	if data and data.success and data.games then
		return data.games
	end
	return {}
end

--- Latest changelog for a script.
function Api.changelog(slug)
	local data = Api.getJson("/api/v1/changelog?script=" .. HttpService:UrlEncode(slug))
	if data and data.success and data.changelog then
		return data.changelog
	end
	return nil
end

--- Read-only check of a saved key: { valid, expires_in, message } or nil when unreachable.
function Api.keyStatus(key, hwid)
	local data = Api.post("/api/v1/key-status", { key = key, hwid = hwid, script_id = CONFIG.SCRIPT_ID })
	if data and data.success then
		return data
	end
	return nil
end

function Api.verify(key, hwid)
	local data, msg = Api.post("/api/v1/verify-key", {
		key = key or "",
		hwid = hwid,
		script_id = CONFIG.SCRIPT_ID,
	})
	if data and data.success then
		return true, data
	end
	return false, msg or "Verification failed."
end

function Api.execute(sessionToken, hwid)
	local src = Api.get(
		"/api/v1/get-script?token="
			.. HttpService:UrlEncode(sessionToken)
			.. "&hwid="
			.. HttpService:UrlEncode(hwid)
	)
	if not src or #src == 0 then
		return false, "Failed to download the script."
	end
	local fn, compileErr = loadstring(src)
	if not fn then
		return false, "Script failed to compile: " .. tostring(compileErr)
	end
	task.spawn(function()
		local ok, runErr = pcall(fn)
		if not ok then
			warn("[Rift] Runtime error: " .. tostring(runErr))
		end
	end)
	return true
end

function Api.keyLink(provider)
	local path = provider == "linkvertise" and "/api/linkvertise/generate" or "/api/workink/generate"
	local data = Api.post(path, {})
	if data and data.success and data.url then
		return data.url
	end
	return CONFIG.API_BASE .. path .. "?redirect=1"
end

--- 93784 -> "1d 2h", 4500 -> "1h 15m", nil -> "Lifetime"
local function formatLeft(seconds)
	if type(seconds) ~= "number" then
		return "Lifetime"
	end
	local d = math.floor(seconds / 86400)
	local h = math.floor((seconds % 86400) / 3600)
	local m = math.floor((seconds % 3600) / 60)
	if d > 0 then
		return d .. "d " .. h .. "h"
	elseif h > 0 then
		return h .. "h " .. m .. "m"
	elseif m > 0 then
		return m .. "m"
	end
	return "<1m"
end

-------------------------------------------------------------------------------
-- Notifications
-------------------------------------------------------------------------------
local function notify(text, duration)
	pcall(function()
		game:GetService("StarterGui"):SetCore("SendNotification", {
			Title = "Rift",
			Text = text,
			Duration = duration or 4,
		})
	end)
end

-------------------------------------------------------------------------------
-- UI helpers
-------------------------------------------------------------------------------
local function create(className, props, children)
	local inst = Instance.new(className)
	for k, v in pairs(props or {}) do
		inst[k] = v
	end
	for _, child in ipairs(children or {}) do
		child.Parent = inst
	end
	return inst
end

local function corner(r)
	return create("UICorner", { CornerRadius = UDim.new(0, r or 8) })
end

local function pad(all)
	return create("UIPadding", {
		PaddingTop = UDim.new(0, all),
		PaddingBottom = UDim.new(0, all),
		PaddingLeft = UDim.new(0, all),
		PaddingRight = UDim.new(0, all),
	})
end

local function stroke(color, transparency, thickness)
	return create("UIStroke", {
		Color = color,
		Transparency = transparency or 0,
		Thickness = thickness or 1,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
	})
end

local function tween(obj, props, t)
	local tw = TweenService:Create(obj, TweenInfo.new(t or 0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), props)
	tw:Play()
	return tw
end

local function makeDraggable(frame, handle)
	local dragging, dragStart, startPos
	handle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = frame.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if
			dragging
			and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch)
		then
			local delta = input.Position - dragStart
			frame.Position =
				UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
end

local function button(text, primary)
	local btn = create("TextButton", {
		AutoButtonColor = false,
		BackgroundColor3 = primary and CONFIG.ACCENT_DARK or Color3.fromRGB(32, 32, 37),
		BackgroundTransparency = primary and 0 or 0.1,
		Size = UDim2.new(1, 0, 0, 38),
		Font = Enum.Font.GothamBold,
		Text = text,
		TextColor3 = Color3.fromRGB(250, 250, 250),
		TextSize = 13,
	}, {
		corner(8),
		stroke(primary and CONFIG.ACCENT or Color3.fromRGB(70, 70, 80), primary and 0.2 or 0.3),
	})
	local base = btn.BackgroundColor3
	btn.MouseEnter:Connect(function()
		tween(btn, { BackgroundColor3 = primary and CONFIG.ACCENT or Color3.fromRGB(48, 48, 56) }, 0.15)
	end)
	btn.MouseLeave:Connect(function()
		tween(btn, { BackgroundColor3 = base }, 0.15)
	end)
	return btn
end

--- A titled glass panel with a scrolling body (UIListLayout-driven canvas).
local function panel(titleText)
	local frame = create("Frame", {
		BackgroundColor3 = Color3.fromRGB(16, 16, 20),
		BackgroundTransparency = 0.25,
		BorderSizePixel = 0,
	}, {
		corner(10),
		stroke(Color3.fromRGB(80, 60, 120), 0.4, 1),
	})
	create("TextLabel", {
		Name = "Title",
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(12, 9),
		Size = UDim2.new(1, -24, 0, 16),
		Font = Enum.Font.GothamBold,
		Text = titleText,
		TextColor3 = CONFIG.ACCENT,
		TextSize = 12,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = frame,
	})
	local scroll = create("ScrollingFrame", {
		Name = "Body",
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = UDim2.fromOffset(12, 32),
		Size = UDim2.new(1, -18, 1, -42),
		CanvasSize = UDim2.new(),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		ScrollBarThickness = 3,
		ScrollBarImageColor3 = CONFIG.ACCENT,
		ScrollBarImageTransparency = 0.3,
		Parent = frame,
	}, {
		create("UIListLayout", { Padding = UDim.new(0, 5), SortOrder = Enum.SortOrder.LayoutOrder }),
	})
	return frame, scroll
end

-------------------------------------------------------------------------------
-- UI
-------------------------------------------------------------------------------
local UI = {}

--- callbacks.onRedeem(key, ui) / callbacks.onGetKey(provider, ui)
--- data = { games = {...}, changelog = { date, entries } }
function UI.build(callbacks, data)
	data = data or {}
	local uiApi = {}

	local gui = create("ScreenGui", {
		Name = "RiftKeySystem_" .. HttpService:GenerateGUID(false):sub(1, 8),
		ResetOnSpawn = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		IgnoreGuiInset = true,
	})
	if syn and syn.protect_gui then
		pcall(syn.protect_gui, gui)
	end

	local W, H = 720, 440
	local main = create("Frame", {
		Name = "Main",
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(W, 0),
		BackgroundColor3 = Color3.fromRGB(10, 10, 13),
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Parent = gui,
	}, {
		corner(14),
		stroke(CONFIG.ACCENT, 0.35, 1.5),
	})

	-- Waifu background (faded) + dark overlay + accent glow gradient
	create("ImageLabel", {
		Name = "Waifu",
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		Image = CONFIG.WAIFU,
		ScaleType = Enum.ScaleType.Crop,
		ImageTransparency = 0.58,
		ImageColor3 = Color3.fromRGB(235, 225, 255),
		Parent = main,
	}, { corner(14) }) -- ClipsDescendants doesn't clip to rounded corners, so round the layers too
	create("Frame", {
		Name = "Overlay",
		BackgroundColor3 = Color3.fromRGB(9, 9, 12),
		BorderSizePixel = 0,
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 0.18,
		Parent = main,
	}, {
		corner(14),
		create("UIGradient", {
			Rotation = 0,
			Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 0.05),
				NumberSequenceKeypoint.new(0.55, 0.45),
				NumberSequenceKeypoint.new(1, 0.65),
			}),
		}),
	})

	-- Everything readable lives in here (renders above background siblings)
	local root = create("Frame", {
		Name = "Root",
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		Parent = main,
	})

	----------------------------------------------------------------- Header
	local header = create("Frame", {
		Name = "Header",
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 56),
		Parent = root,
	})
	create("ImageLabel", {
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(16, 11),
		Size = UDim2.fromOffset(34, 34),
		Image = CONFIG.LOGO,
		Parent = header,
	})
	create("TextLabel", {
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(58, 11),
		Size = UDim2.new(0, 300, 0, 22),
		Font = Enum.Font.GothamBlack,
		RichText = true,
		Text = '<font color="#A855F7">RIFT</font> Key System',
		TextColor3 = Color3.fromRGB(250, 250, 250),
		TextSize = 18,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = header,
	})
	create("TextLabel", {
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(58, 33),
		Size = UDim2.new(0, 360, 0, 15),
		Font = Enum.Font.Gotham,
		Text = CONFIG.SCRIPT_NAME,
		TextColor3 = Color3.fromRGB(180, 170, 200),
		TextSize = 12,
		TextTruncate = Enum.TextTruncate.AtEnd,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = header,
	})
	local close = create("TextButton", {
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, -14, 0, 14),
		Size = UDim2.fromOffset(28, 28),
		BackgroundColor3 = Color3.fromRGB(32, 32, 37),
		BackgroundTransparency = 0.1,
		AutoButtonColor = false,
		Font = Enum.Font.GothamBold,
		Text = "X",
		TextColor3 = Color3.fromRGB(200, 190, 210),
		TextSize = 13,
		Parent = header,
	}, { corner(7), stroke(Color3.fromRGB(70, 70, 80), 0.3) })
	close.MouseEnter:Connect(function()
		tween(close, { BackgroundColor3 = Color3.fromRGB(190, 60, 60) }, 0.15)
	end)
	close.MouseLeave:Connect(function()
		tween(close, { BackgroundColor3 = Color3.fromRGB(32, 32, 37) }, 0.15)
	end)
	create("Frame", {
		BackgroundColor3 = CONFIG.ACCENT,
		BackgroundTransparency = 0.6,
		BorderSizePixel = 0,
		Position = UDim2.fromOffset(16, 55),
		Size = UDim2.new(1, -32, 0, 1),
		Parent = root,
	})

	----------------------------------------------------------- Left: key box
	local left = create("Frame", {
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(18, 70),
		Size = UDim2.fromOffset(322, 352),
		Parent = root,
	})

	local input = create("TextBox", {
		BackgroundColor3 = Color3.fromRGB(20, 20, 24),
		BackgroundTransparency = 0.1,
		ClearTextOnFocus = false,
		Font = Enum.Font.Code,
		PlaceholderText = "RIFT-XXXX-XXXX-XXXX-XXXX",
		PlaceholderColor3 = Color3.fromRGB(110, 105, 125),
		Position = UDim2.fromOffset(0, 4),
		Size = UDim2.new(1, 0, 0, 42),
		Text = "",
		TextColor3 = Color3.fromRGB(244, 244, 245),
		TextSize = 14,
		Parent = left,
	}, { corner(8), stroke(Color3.fromRGB(70, 70, 82), 0.2) })
	local inputStroke = input:FindFirstChildOfClass("UIStroke")
	input.Focused:Connect(function()
		tween(inputStroke, { Color = CONFIG.ACCENT, Transparency = 0 }, 0.15)
	end)
	input.FocusLost:Connect(function()
		tween(inputStroke, { Color = Color3.fromRGB(70, 70, 82), Transparency = 0.2 }, 0.15)
	end)

	-- Returning user with a valid saved key: prefill it and offer "Load Script".
	local primaryLabel = data.prefillKey and "Load Script" or "Redeem Key"
	if data.prefillKey then
		input.Text = data.prefillKey
	end

	local redeemBtn = button(primaryLabel, true)
	redeemBtn.Position = UDim2.fromOffset(0, 56)
	redeemBtn.Parent = left

	-- Provider buttons
	local providers = {}
	if CONFIG.WORKINK ~= false then
		table.insert(providers, { id = "workink", label = "Get Key (Work.ink)" })
	end
	if CONFIG.LINKVERTISE == true then
		table.insert(providers, { id = "linkvertise", label = "Get Key (Linkvertise)" })
	end
	if #providers == 0 then
		providers = { { id = "workink", label = "Get Key" } }
	end
	local row = create("Frame", {
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(0, 102),
		Size = UDim2.new(1, 0, 0, 38),
		Parent = left,
	}, {
		create("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 10) }),
	})
	for i, provider in ipairs(providers) do
		local btn = button(provider.label, false)
		btn.LayoutOrder = i
		btn.Size = #providers > 1 and UDim2.new(0.5, -5, 0, 38) or UDim2.new(1, 0, 0, 38)
		btn.TextSize = #providers > 1 and 12 or 13
		btn.Parent = row
		btn.MouseButton1Click:Connect(function()
			callbacks.onGetKey(provider.id, uiApi)
		end)
	end

	-- Key info pill (shown when we already know the key is active)
	local statusY = 150
	if data.keyLeft then
		statusY = 184
		local pill = create("Frame", {
			BackgroundColor3 = Color3.fromRGB(20, 40, 28),
			BackgroundTransparency = 0.15,
			BorderSizePixel = 0,
			Position = UDim2.fromOffset(0, 150),
			Size = UDim2.new(1, 0, 0, 26),
			Parent = left,
		}, { corner(7), stroke(Color3.fromRGB(74, 222, 128), 0.55) })
		create("Frame", {
			BackgroundColor3 = Color3.fromRGB(74, 222, 128),
			BorderSizePixel = 0,
			Position = UDim2.fromOffset(10, 10),
			Size = UDim2.fromOffset(7, 7),
			Parent = pill,
		}, { corner(4) })
		create("TextLabel", {
			BackgroundTransparency = 1,
			Position = UDim2.fromOffset(24, 0),
			Size = UDim2.new(1, -30, 1, 0),
			Font = Enum.Font.GothamBold,
			RichText = true,
			Text = data.keyLeft == "Lifetime" and "Key active  •  Lifetime"
				or ("Key active  •  " .. data.keyLeft .. " left"),
			TextColor3 = Color3.fromRGB(134, 239, 172),
			TextSize = 12,
			TextXAlignment = Enum.TextXAlignment.Left,
			Parent = pill,
		})
	end

	local status = create("TextLabel", {
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(0, statusY),
		Size = UDim2.new(1, 0, 0, 46),
		Font = Enum.Font.Gotham,
		Text = data.prefillKey and "New update! Check the changelog, then press “Load Script”."
			or (data.notice or "Enter your key, or press a “Get Key” button to receive one."),
		TextColor3 = Color3.fromRGB(175, 170, 190),
		TextSize = 12,
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
		Parent = left,
	})

	-- Discord button
	local discordBtn
	if type(CONFIG.DISCORD) == "string" and #CONFIG.DISCORD > 0 then
		discordBtn = create("TextButton", {
			AutoButtonColor = false,
			BackgroundColor3 = Color3.fromRGB(88, 101, 242),
			Position = UDim2.new(0, 0, 1, -64),
			Size = UDim2.new(1, 0, 0, 38),
			Font = Enum.Font.GothamBold,
			Text = "Join our Discord",
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextSize = 13,
			Parent = left,
		}, { corner(8), stroke(Color3.fromRGB(140, 150, 255), 0.4) })
		discordBtn.MouseEnter:Connect(function()
			tween(discordBtn, { BackgroundColor3 = Color3.fromRGB(108, 121, 255) }, 0.15)
		end)
		discordBtn.MouseLeave:Connect(function()
			tween(discordBtn, { BackgroundColor3 = Color3.fromRGB(88, 101, 242) }, 0.15)
		end)
	end

	-- Small footer brand at the bottom of the left column
	create("TextLabel", {
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.new(0, 0, 1, 0),
		Size = UDim2.new(1, 0, 0, 16),
		Font = Enum.Font.Gotham,
		RichText = true,
		Text = '<font color="#A855F7">Rift Scripts</font>  •  not affiliated with Roblox',
		TextColor3 = Color3.fromRGB(130, 125, 145),
		TextSize = 11,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = left,
	})

	----------------------------------------------- Right: changelog + games
	local clPanel, clBody = panel("CHANGELOG")
	clPanel.Position = UDim2.fromOffset(352, 70)
	clPanel.Size = UDim2.fromOffset(350, 198)
	clPanel.Parent = root

	local cl = data.changelog
	if cl and cl.date then
		clPanel.Title.Text = "CHANGELOG"
		create("TextLabel", {
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.new(1, -12, 0, 9),
			Size = UDim2.new(0, 160, 0, 16),
			Font = Enum.Font.Gotham,
			Text = cl.date,
			TextColor3 = Color3.fromRGB(150, 145, 165),
			TextSize = 11,
			TextXAlignment = Enum.TextXAlignment.Right,
			Parent = clPanel,
		})
	end

	local colorFor = {
		added = Color3.fromRGB(74, 222, 128),
		removed = Color3.fromRGB(248, 113, 113),
		changed = Color3.fromRGB(232, 121, 249),
		plain = Color3.fromRGB(210, 205, 220),
	}
	local entries = (cl and cl.entries) or {}
	if #entries == 0 then
		create("TextLabel", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 20),
			Font = Enum.Font.Gotham,
			Text = "No changelog yet.",
			TextColor3 = Color3.fromRGB(130, 125, 145),
			TextSize = 12,
			TextXAlignment = Enum.TextXAlignment.Left,
			Parent = clBody,
		})
	else
		for i, e in ipairs(entries) do
			local line = create("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				LayoutOrder = i,
				Parent = clBody,
			}, {
				create("UIListLayout", {
					FillDirection = Enum.FillDirection.Horizontal,
					Padding = UDim.new(0, 6),
					VerticalAlignment = Enum.VerticalAlignment.Top,
				}),
			})
			local marker = e.marker ~= nil and e.marker or ""
			if marker ~= "" then
				create("TextLabel", {
					BackgroundTransparency = 1,
					Size = UDim2.fromOffset(38, 16),
					Font = Enum.Font.GothamBold,
					Text = marker,
					TextColor3 = colorFor[e.type] or colorFor.plain,
					TextSize = 12,
					TextXAlignment = Enum.TextXAlignment.Left,
					LayoutOrder = 1,
					Parent = line,
				})
			end
			create("TextLabel", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, marker ~= "" and -44 or 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				Font = Enum.Font.Gotham,
				Text = tostring(e.text or ""),
				TextColor3 = Color3.fromRGB(228, 226, 235),
				TextSize = 12,
				TextWrapped = true,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Top,
				LayoutOrder = 2,
				Parent = line,
			})
		end
	end

	local gmPanel, gmBody = panel("SUPPORTED GAMES")
	gmPanel.Position = UDim2.fromOffset(352, 278)
	gmPanel.Size = UDim2.fromOffset(350, 144)
	gmPanel.Parent = root

	local games = data.games or {}
	if #games == 0 then
		create("TextLabel", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 20),
			Font = Enum.Font.Gotham,
			Text = "Loading…",
			TextColor3 = Color3.fromRGB(130, 125, 145),
			TextSize = 12,
			TextXAlignment = Enum.TextXAlignment.Left,
			Parent = gmBody,
		})
	else
		for i, g in ipairs(games) do
			local gline = create("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 18),
				LayoutOrder = i,
				Parent = gmBody,
			}, {
				create("UIListLayout", {
					FillDirection = Enum.FillDirection.Horizontal,
					Padding = UDim.new(0, 7),
					VerticalAlignment = Enum.VerticalAlignment.Center,
				}),
			})
			local dotColor = Color3.fromRGB(74, 222, 128)
			if g.status == "PATCHED" then
				dotColor = Color3.fromRGB(248, 113, 113)
			elseif g.status == "UPDATING" then
				dotColor = Color3.fromRGB(251, 191, 36)
			end
			create("Frame", {
				BackgroundColor3 = dotColor,
				BorderSizePixel = 0,
				Size = UDim2.fromOffset(7, 7),
				LayoutOrder = 1,
				Parent = gline,
			}, { corner(4) })
			create("TextLabel", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, -16, 1, 0),
				Font = Enum.Font.Gotham,
				Text = tostring(g.name or g.title or "?")
					.. ((g.universal and not tostring(g.name or ""):lower():find("universal")) and "  (Universal)" or ""),
				TextColor3 = Color3.fromRGB(220, 218, 230),
				TextSize = 12,
				TextTruncate = Enum.TextTruncate.AtEnd,
				TextXAlignment = Enum.TextXAlignment.Left,
				LayoutOrder = 2,
				Parent = gline,
			})
		end
	end

	---------------------------------------------------------------- Behaviour
	function uiApi.setStatus(text, kind)
		local colors = {
			info = Color3.fromRGB(175, 170, 190),
			ok = Color3.fromRGB(74, 222, 128),
			err = Color3.fromRGB(248, 113, 113),
			busy = CONFIG.ACCENT,
		}
		status.Text = text
		status.TextColor3 = colors[kind or "info"]
	end
	function uiApi.setBusy(isBusy)
		redeemBtn.Active = not isBusy
		redeemBtn.Text = isBusy and "Checking…" or primaryLabel
	end
	function uiApi.destroy()
		tween(main, { Size = UDim2.fromOffset(W, 0) }, 0.2).Completed:Wait()
		gui:Destroy()
	end

	local busy = false
	redeemBtn.MouseButton1Click:Connect(function()
		if busy then
			return
		end
		local key = input.Text:gsub("%s+", "")
		if #key == 0 then
			uiApi.setStatus("Please paste your key first.", "err")
			return
		end
		busy = true
		uiApi.setBusy(true)
		uiApi.setStatus("Verifying key…", "busy")
		task.spawn(function()
			callbacks.onRedeem(key, uiApi)
			busy = false
			if gui.Parent then
				uiApi.setBusy(false)
			end
		end)
	end)
	if discordBtn then
		discordBtn.MouseButton1Click:Connect(function()
			uiApi.setStatus("Opening Discord…", "busy")
			task.spawn(function()
				local result = Compat.openDiscord(CONFIG.DISCORD)
				if result == "opened" then
					uiApi.setStatus("Discord invite opened in your Discord app!", "ok")
				elseif result == "copied" then
					uiApi.setStatus("Invite link copied! Paste it in your browser: " .. CONFIG.DISCORD, "ok")
				else
					uiApi.setStatus("Join us: " .. CONFIG.DISCORD, "info")
				end
			end)
		end)
	end

	close.MouseButton1Click:Connect(function()
		uiApi.destroy()
		if getgenv then
			getgenv().__RIFT_LOADING = nil
		end
	end)

	makeDraggable(main, header)
	gui.Parent = Compat.guiParent()
	tween(main, { Size = UDim2.fromOffset(W, H) }, 0.35)
	return uiApi
end

-------------------------------------------------------------------------------
-- Main
-------------------------------------------------------------------------------
local function finish()
	if getgenv then
		getgenv().__RIFT_LOADING = nil
	end
end

--- Starts the Rift Hub (chat, player list, tags, admin panel) next to every script.
--- Never blocks or breaks the actual script: runs in its own thread, fully pcall-guarded.
local function startHub()
	if getgenv and getgenv().__RIFT_HUB then
		return
	end
	task.spawn(function()
		pcall(function()
			local src = game:HttpGet(CONFIG.API_BASE .. "/api/v1/rift/client")
			local fn = loadstring(src)
			if fn then
				fn()
			end
		end)
	end)
end

local function run(sessionToken, hwid)
	startHub() -- before the script runs, so a script that never returns can't prevent it
	local ok, err = Api.execute(sessionToken, hwid)
	if ok then
		notify("Loaded " .. CONFIG.SCRIPT_NAME .. " ✓", 3)
	else
		notify(err, 6)
		warn("[Rift] " .. tostring(err))
	end
	return ok, err
end

local function main()
	local hwid = Compat.getHwid()
	if not hwid then
		notify("Could not detect your HWID. Your executor may be unsupported.", 8)
		return finish()
	end

	-- Hub loader: resolve the script for this game first.
	if CONFIG.HUB then
		notify("Searching for a script for this game…", 3)
		local script, err = Api.resolve(game.PlaceId)
		if not script then
			notify(tostring(err), 8)
			return finish()
		end
		CONFIG.SCRIPT_ID = script.slug
		CONFIG.SCRIPT_NAME = script.title
		CONFIG.REQUIRES_KEY = script.requires_key ~= false
		CONFIG.STATUS = script.status or "WORKING"
		if script.universal then
			notify("No script for this game — loading the Universal script.", 5)
		end
	end

	if CONFIG.STATUS == "PATCHED" then
		notify("Heads up: this script is marked as PATCHED.", 5)
	end

	-- Keyless scripts: verify (for analytics) and run.
	if not CONFIG.REQUIRES_KEY then
		local ok, data = Api.verify("", hwid)
		if ok then
			run(data.session_token, hwid)
		else
			notify(tostring(data), 6)
		end
		return finish()
	end

	-- Returning user? Check the saved key without counting an execution yet.
	local cached = Cache.read()
	local prefillKey, keyLeft, notice = nil, nil, nil
	local changelog = Api.changelog(CONFIG.SCRIPT_ID)
	local hasUnseen = changelog and changelog.id and Cache.getSeen(CONFIG.SCRIPT_ID) ~= tostring(changelog.id)

	if cached then
		local st = Api.keyStatus(cached, hwid)
		if st == nil or st.valid then
			-- Key still valid (or status unknown → let /verify-key decide).
			if st and not hasUnseen then
				-- Nothing new to show: load straight away.
				local ok, data = Api.verify(cached, hwid)
				if ok then
					notify("Key active  •  " .. (formatLeft(data.key_expires_in) == "Lifetime" and "Lifetime"
						or formatLeft(data.key_expires_in) .. " left"), 4)
					run(data.session_token, hwid)
					return finish()
				end
				Cache.clear()
				notice = "Saved key is no longer valid: " .. tostring(data)
			elseif st == nil then
				local ok, data = Api.verify(cached, hwid)
				if ok then
					run(data.session_token, hwid)
					return finish()
				end
				Cache.clear()
				notice = "Saved key is no longer valid: " .. tostring(data)
			else
				-- Valid key but a new changelog: open the window so the user sees it.
				prefillKey = cached
				keyLeft = formatLeft(st.expires_in)
			end
		else
			Cache.clear()
			notice = tostring(st.message or "Your saved key is no longer valid.") .. " Get a new one below."
		end
	end

	-- Show the UI (first time, expired key, or unseen changelog).
	local games = Api.games()
	if changelog and changelog.id then
		Cache.setSeen(CONFIG.SCRIPT_ID, changelog.id)
	end

	UI.build({
		onRedeem = function(key, ui)
			local ok, data = Api.verify(key, hwid)
			if not ok then
				ui.setStatus(tostring(data), "err")
				return
			end
			local left = formatLeft(data.key_expires_in)
			ui.setStatus(
				"Key valid (" .. (left == "Lifetime" and "Lifetime" or left .. " left") .. ")! Loading "
					.. CONFIG.SCRIPT_NAME .. "…",
				"ok"
			)
			Cache.write(key)
			task.wait(0.8)
			ui.destroy()
			run(data.session_token, hwid)
			finish()
		end,
		onGetKey = function(provider, ui)
			local label = provider == "linkvertise" and "Linkvertise" or "Work.ink"
			ui.setStatus("Getting your " .. label .. " link…", "busy")
			local link = Api.keyLink(provider)
			if Compat.setclipboard then
				Compat.setclipboard(link)
				ui.setStatus(label .. " link copied! Paste it in your browser, finish it, and copy your key.", "ok")
			else
				ui.setStatus("Open this link: " .. link, "info")
			end
		end,
	}, {
		games = games,
		changelog = changelog,
		prefillKey = prefillKey,
		keyLeft = keyLeft,
		notice = notice,
	})
end

local ok, err = pcall(main)
if not ok then
	warn("[Rift] Loader error: " .. tostring(err))
	finish()
end
