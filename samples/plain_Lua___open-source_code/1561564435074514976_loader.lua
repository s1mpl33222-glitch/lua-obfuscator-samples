local RELAY_LOGO = "data:image/png;base64,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fERH/+zHPfY4dP8Hk2pbposgJREIQSQEUQggkASBAFJQSCglQQWFQBIQECo2ND771Kj9B5x78UV//L/hYZ45knxE5575q102773RoCQyXQRpIRAKihQSQp0UlCQIBJC6ACIhNIsomhdHjzl16B+HHTVw4KXVEOaZM8lHdN4ZJx25We9e/UhVBAIWAkhIBEFmIYDMJAkosxBAIRPemXTz9Tf9cdt+J5wxuVqtMs+cSz6i88446fDNem90EiAJBQNIQSEUAsoHEQithEKoE6RGyNTGpmduH35fryOPO/H18RMmMM+cTT6is37df/utNtvkiiRSCFEkgAoEIggkoMgMAQRCIQGFUAgorYlvPv7syI3n77L4X3v12jjTpk1jnjmbfEQ77/iDr554zBEjUq12pE4KSUARaSEhUiMSWgsgIklASiGIFJz0zPNP7/CtDfrc9PDDf2OjjTYK88zx5CPafqft2h570F53ztehw9rUqZCACgoJKKUkiGAggDJdmEFCALHQ9NyLYw65f8TN50yY0CUvvfQSQ4YMYZ45n3xE++67r5tssM6Pv77SshcTKipJQBBBSUJJJQlSkgAVITQLIDUpqIgZ89ob5w254fcHnnHuxVXmmavIR9S1a1f22/eojtt/v8ctbdu2WRcUAgGkINMJBKQugBSkIHWShEKUjHvr7dtHPHXHNrvtcepE5pnryMdgt912dvNvbrziaut89U7giySEUBIBwZAEkRBUiISgUgpSMgVg6ruNT99155BNhz80+rXrrhvKPHMf+Zgs3q2bB++/1yY/3LL31alWFwwBVEIQqQtBIBGkIApICDUJTJtW/ft9dzza57e/vfDJ58aN47XXXmOeuY98jL79rTXcZqvNe23Z57uXSbqSUBcDiIRCQAGlRQoohDQ2Nb125fU3bX3N4BseefbZZ5ln7iUfs65du7L7T3+80g5b9jlngQU7r1udNq0BMKkCghQEpSQCKSFU35k06fGH7n74pwMuvuxvf3vmGeaZu8knYNFFF2WjDb/VbvNem26+2morHTR/5449q9OmtQ0RKhaikoCaSqWSpsamlx59fMS54yY1XnzddcMmDh8+PMwz15NPUI8eX7f7qiu26bXBBqu2lw2/uvSyPTt26ditbUNDh0Dj1MamNx9/4smn29Hmnr/c/sB9L9E4sX///hx11FG5+uqrmWfu9/8A+zgEn0j2PD4AAAAASUVORK5CYII="

local ProjectId = "6a9517176bf508256ce22521"
local Base = "https://cdn.snc.dev/" .. ProjectId .. "/"
local ApiBase = "https://www.relayscripts.lol/api/loader"
local KeyUrl = "https://www.relayscripts.lol/get-key"
local WebsiteLabel = "relayscripts.lol"
local DiscordInvite = "tZjYAWCC3f"
local DiscordLabel = "discord.gg/" .. DiscordInvite
local KeyFile = "Relay/key.txt"
local LogoFile = "Relay/logo.png"

local Hubs = {
	{ "Animal Hospital", "d4fw9wf0ki", { 3725359351, 10148749921, 78515283254292 } },
	{ "Arsenal", "df1wzh8el4k", { 111958650, 286090429 } },
	{ "Basketball Legends", "1vfh6t0use", { 4931927012, 14259168147 } },
	{ "Blade Ball", "ntkin5mii2", { 4777817887, 13772394625 } },
	{ "Blox Fruits", "ri1nlgg6ebd", { 994732206, 2753915549, 4442272183, 7449423635 } },
	{ "Bloxstrike", "xel4nlifwyi", { 7633926880, 114234929420007 } },
	{ "Chess Club", "8z4515q457r", { 7266261686, 139394516128799 } },
	{ "Clean All The Leaves", "5d1jhf7nyre", { 10539411000, 92637789841354 } },
	{ "Fisch", "qwjlmqk81s", { 5750914919, 16732694052 } },
	{ "Football Fusion 3", "mnl3or7e7qs", { 9908641400, 82866880824588 } },
	{ "Hoopz", "83qa4pqa6rg", { 2287245386, 104140629757949, 6229116934 } },
	{ "Hostile Skies", "zpi5xpzeag8", { 686030892, 1886551928, 116448363211843 } },
	{ "Operations Siege", "90lnh9389ck", { 4849157113, 13997018456 } },
	{ "Phantom Forces", "b7u9t22gv3", { 113491250, 292439477 } },
	{ "RH2", "k9d7w73i8mi", { 2459091562, 6549794549, 6678600773, 7235817949 } },
	{ "Slayers 2", "vcn4bwdbay", { 5595353122, 16205713724, 136406881576517 } },
	{ "Spelling Bee", "8m5ni3suqni", { 6022371481, 17590362521 } },
	{ "Superstar Baseball", "buog4eiy6z", { 7128251171, 101432174163538 } },
	{ "Turbo Soccer", "vkda4rtzzch", { 10767012496, 101880234193261 } },
	{ "Untitled Boxing Game", "1micoadfus1", { 4730278139, 13621938427, 6969237940 } },
}

local Supported, ScriptUrls = {}, {}
for _, hub in ipairs(Hubs) do
	for _, id in ipairs(hub[3]) do
		Supported[id] = hub[1]
		ScriptUrls[id] = Base .. hub[2]
	end
end

local HttpService = game:GetService("HttpService")
local configReady = false
task.spawn(function()
	pcall(function()
		local body = game:HttpGet(ApiBase .. "/config")
		local data = HttpService:JSONDecode(body)
		if type(data.games) == "table" then
			for _, entry in ipairs(data.games) do
				local ids = type(entry.ids) == "table" and entry.ids or { entry.placeId }
				for _, raw in ipairs(ids) do
					local id = tonumber(raw)
					if id and type(entry.loader) == "string" and #entry.loader > 0 then
						Supported[id] = entry.name or Supported[id] or "Supported game"
						ScriptUrls[id] = entry.loader
					end
				end
			end
		end
		if type(data.links) == "table" then
			KeyUrl = data.links.getKey or KeyUrl
			WebsiteLabel = data.links.website or WebsiteLabel
			if type(data.links.discord) == "string" then
				DiscordInvite = data.links.discord:match("discord%.gg/([%w%-_]+)") or DiscordInvite
				DiscordLabel = "discord.gg/" .. DiscordInvite
			end
		end
	end)
	configReady = true
end)

local function awaitConfig(limit)
	local t0 = os.clock()
	while not configReady and os.clock() - t0 < limit do task.wait(0.05) end
	return configReady
end

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local MarketplaceService = game:GetService("MarketplaceService")
local LocalPlayer = Players.LocalPlayer

local genv = getgenv and getgenv() or _G
if genv.RelayKeyGui then pcall(function() genv.RelayKeyGui:Destroy() end) end

local function readKey()
	if not (isfile and readfile) then return nil end
	local ok, v = pcall(function() return isfile(KeyFile) and readfile(KeyFile) or nil end)
	if ok and type(v) == "string" then
		v = v:gsub("^%s+", ""):gsub("%s+$", "")
		if #v > 0 then return v end
	end
	return nil
end

local function saveKey(k)
	if not writefile then return end
	pcall(function()
		if makefolder and isfolder and not isfolder("Relay") then makefolder("Relay") end
		writefile(KeyFile, k)
	end)
end

local function clearKey()
	pcall(function() if delfile and isfile and isfile(KeyFile) then delfile(KeyFile) end end)
end

local function validFormat(k)
	if type(k) ~= "string" then return false end
	k = k:gsub("%s", "")
	if #k < 8 or #k > 128 then return false end
	return k:match("^[%w%-_%.]+$") ~= nil
end

local function executorName()
	local ok, name = pcall(function() return identifyexecutor and identifyexecutor() end)
	if ok and type(name) == "string" and #name > 0 then return name end
	return "Unknown"
end

local productName, productReady = nil, false
task.spawn(function()
	local ok, info = pcall(function() return MarketplaceService:GetProductInfo(game.PlaceId) end)
	if ok and type(info) == "table" and info.Name then productName = tostring(info.Name) end
	productReady = true
end)

local function gameInfo()
	local name = Supported[game.GameId] or Supported[game.PlaceId]
	return name or productName or ("Place " .. tostring(game.PlaceId)), name ~= nil
end

local function checkKey(k)
	local req = (syn and syn.request) or http_request or request or (fluxus and fluxus.request)
	if not req then return true, nil, false end
	local ok, res = pcall(req, { Url = ApiBase .. "/validate", Method = "POST", Headers = { ["Content-Type"] = "application/json" }, Body = HttpService:JSONEncode({ key = k }) })
	if not ok or type(res) ~= "table" then return true, nil, false end
	local okJson, data = pcall(HttpService.JSONDecode, HttpService, res.Body or "")
	if not okJson or type(data) ~= "table" then return true, nil, false end
	if data.valid == true then return true, data.message, true end
	return false, data.message or "That key was rejected.", false
end

local function logExecution(k, success, err)
	task.spawn(function()
		local req = (syn and syn.request) or http_request or request or (fluxus and fluxus.request)
		if not req then return end
		local lp = Players.LocalPlayer
		local name = gameInfo()
		pcall(req, {
			Url = ApiBase .. "/execution",
			Method = "POST",
			Headers = { ["Content-Type"] = "application/json" },
			Body = HttpService:JSONEncode({
				key = k,
				username = lp and lp.Name or "",
				displayName = lp and lp.DisplayName or "",
				userId = lp and lp.UserId or 0,
				placeId = game.PlaceId,
				gameId = game.GameId,
				jobId = game.JobId,
				game = name,
				executor = executorName(),
				success = success,
				error = err and tostring(err) or nil,
			}),
		})
	end)
end

local function runLoader(k)
	genv.key = k
	_G.key = k
	pcall(function() getfenv(0).key = k end)
	local url = ScriptUrls[game.GameId] or ScriptUrls[game.PlaceId]
	if not url then return false, "Relay does not support this game yet" end
	local ok, src = pcall(game.HttpGet, game, url)
	if not ok or type(src) ~= "string" or #src == 0 then
		task.wait(1)
		ok, src = pcall(game.HttpGet, game, url)
	end
	if not ok or type(src) ~= "string" or #src == 0 then return false, "Could not download the script" end
	if #src < 400 and src:lower():find("not found") then return false, "The script for this game is offline. Ask staff to reupload it." end
	local fn = loadstring(src)
	if not fn then return false, "Script failed to compile" end
	local ran, runErr = pcall(fn)
	if not ran and tostring(runErr):find("is locked") then
		task.wait(1)
		local ok2, src2 = pcall(game.HttpGet, game, url)
		local fn2 = ok2 and type(src2) == "string" and loadstring(src2)
		if fn2 then ran, runErr = pcall(fn2) end
	end
	logExecution(k, ran, not ran and runErr or nil)
	if not ran then return false, tostring(runErr) end
	return true
end

local function openDiscord(code)
	local req = (syn and syn.request) or http_request or request or (fluxus and fluxus.request)
	if not req then return false end
	for port = 6463, 6472 do
		local ok, res = pcall(req, {
			Url = ("http://127.0.0.1:%d/rpc?v=1"):format(port),
			Method = "POST",
			Headers = { ["Content-Type"] = "application/json", Origin = "https://discord.com" },
			Body = HttpService:JSONEncode({ cmd = "INVITE_BROWSER", nonce = HttpService:GenerateGUID(false), args = { code = code } }),
		})
		if ok and res and (res.StatusCode == 200 or res.Success) then return true end
	end
	return false
end

local forceUI = genv.RelayForceUI == true
genv.RelayForceUI = nil

local function currentLib()
	return _G.RelayLib or genv.RelayLib
end

local function startState(libBefore)
	local s = _G.RelayStatus
	if type(s) == "string" and s:upper():sub(1, 5) == "ERROR" then return "error", s end
	if s == "SUCCESS" then return "ok" end
	local lib = currentLib()
	if lib ~= nil and lib ~= libBefore then return "ok" end
	return nil
end

local function waitStart(libBefore, limit)
	local t0 = os.clock()
	local state, why = startState(libBefore)
	while not state and os.clock() - t0 < limit do
		task.wait(0.25)
		state, why = startState(libBefore)
	end
	return state, why
end

local startupError, startupKind

local function tryFast(k)
	local before = currentLib()
	_G.RelayStatus = nil
	local ok, err = runLoader(k)
	if not ok then
		startupError, startupKind = err, "load"
		return false
	end
	local state, why = waitStart(before, 20)
	if state == "ok" then return true end
	if state == "error" then
		startupError, startupKind = why, "error"
	elseif genv.SNC_RUNNING then
		startupError, startupKind = "The script server did not accept that key.", "key"
	else
		startupError, startupKind = "The script did not start.", "timeout"
	end
	return false
end

local preset = genv.key
local saved = readKey()
local presetOk = not forceUI and type(preset) == "string" and validFormat(preset)
local savedOk = not forceUI and saved ~= nil and validFormat(saved)
if presetOk or savedOk then awaitConfig(4) end
local detectedName, supported = gameInfo()

if presetOk and supported then
	if tryFast(preset) then return end
end

if savedOk and supported and saved ~= preset and (startupKind == nil or startupKind == "key") then
	if tryFast(saved) then return end
end
if forceUI then saved = nil end

task.spawn(function()
	if not openDiscord(DiscordInvite) then
		pcall(function() setclipboard("https://discord.gg/" .. DiscordInvite) end)
	end
end)

local Lucide
local pendingIcons = {}

local function paintIcon(img, name)
	if not Lucide then
		pendingIcons[img] = name
		return
	end
	local asset = Lucide.GetAsset and Lucide.GetAsset(name)
	if asset then
		img.Image = asset.Url
		img.ImageRectSize = asset.ImageRectSize
		img.ImageRectOffset = asset.ImageRectOffset
	end
end

task.spawn(function()
	local LUCIDE_URL = "https://raw.githubusercontent.com/mstudio45/lucide-roblox-direct/refs/heads/main/source.lua"
	for attempt = 1, 2 do
		local ok, lib = pcall(function() return loadstring(game:HttpGet(LUCIDE_URL))() end)
		if ok and type(lib) == "table" then
			Lucide = lib
			break
		end
		if attempt == 1 then task.wait(1) end
	end
	if not Lucide then return end
	local queued = pendingIcons
	pendingIcons = {}
	for img, name in pairs(queued) do pcall(paintIcon, img, name) end
end)

local function icon(parent, name, size, colour, pos)
	local img = Instance.new("ImageLabel")
	img.BackgroundTransparency = 1
	img.Size = UDim2.fromOffset(size, size)
	img.Position = pos
	img.ImageColor3 = colour
	img.Parent = parent
	paintIcon(img, name)
	return img
end

local logoImage = ""
pcall(function()
	local raw = RELAY_LOGO:match("base64,(.+)$")
	local decode = (crypt and crypt.base64decode) or base64_decode or (base64 and base64.decode)
	if raw and decode and writefile and getcustomasset then
		if makefolder and isfolder and not isfolder("Relay") then makefolder("Relay") end
		if not (isfile and isfile(LogoFile)) then writefile(LogoFile, decode(raw)) end
		logoImage = getcustomasset(LogoFile)
	end
end)

local ACCENT = Color3.fromRGB(231, 222, 209)
local BG = Color3.fromRGB(8, 8, 10)
local BG2 = Color3.fromRGB(16, 16, 20)
local PANEL = Color3.fromRGB(17, 17, 21)
local FIELD = Color3.fromRGB(24, 24, 29)
local LINE = Color3.fromRGB(42, 42, 49)
local TEXT = Color3.fromRGB(244, 242, 238)
local DIM = Color3.fromRGB(134, 134, 144)
local FAINT = Color3.fromRGB(78, 78, 88)
local RED = Color3.fromRGB(240, 92, 92)
local GREEN = Color3.fromRGB(118, 214, 140)
local WHITE = Color3.new(1, 1, 1)
local FONT = Enum.Font.GothamMedium
local BOLD = Enum.Font.GothamBold
local HEAVY = Enum.Font.GothamBlack

local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")

local function create(class, props, children)
	local inst = Instance.new(class)
	for k, v in pairs(props) do inst[k] = v end
	for _, c in ipairs(children or {}) do c.Parent = inst end
	return inst
end
local function corner(r) return create("UICorner", { CornerRadius = UDim.new(0, r) }) end
local function round() return create("UICorner", { CornerRadius = UDim.new(1, 0) }) end
local function stroke(c, t, tr) return create("UIStroke", { Color = c, Thickness = t or 1, Transparency = tr or 0, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }) end
local function tween(obj, t, props, style, dir)
	local tw = TweenService:Create(obj, TweenInfo.new(t, style or Enum.EasingStyle.Quint, dir or Enum.EasingDirection.Out), props)
	tw:Play()
	return tw
end
local function label(parent, text, pos, size, font, tsize, colour, align)
	return create("TextLabel", { Position = pos, Size = size, BackgroundTransparency = 1, Text = text, Font = font, TextSize = tsize, TextColor3 = colour, TextXAlignment = align or Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, Parent = parent })
end

local alive = true
local conns = {}
local function bind(signal, fn)
	local c = signal:Connect(fn)
	conns[#conns + 1] = c
	return c
end

local gui = create("ScreenGui", { Name = "RelayKey", ResetOnSpawn = false, ZIndexBehavior = Enum.ZIndexBehavior.Sibling, IgnoreGuiInset = true, DisplayOrder = 999 })
pcall(function() gui.Parent = (gethui and gethui()) or game:GetService("CoreGui") end)
if not gui.Parent then gui.Parent = LocalPlayer:WaitForChild("PlayerGui") end
genv.RelayKeyGui = gui

local blur = Instance.new("BlurEffect")
blur.Name = "RelayKeyBlur"
blur.Size = 0
pcall(function() blur.Parent = Lighting end)

gui.Destroying:Connect(function()
	alive = false
	for _, c in ipairs(conns) do pcall(function() c:Disconnect() end) end
	pcall(function() blur:Destroy() end)
end)

local backdrop = create("Frame", { Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.new(0, 0, 0), BackgroundTransparency = 1, BorderSizePixel = 0, Parent = gui })
create("UIGradient", { Color = ColorSequence.new(Color3.fromRGB(14, 14, 18), Color3.new(0, 0, 0)), Rotation = 90, Parent = backdrop })

local W, H = 560, 412
local holder = create("Frame", { Size = UDim2.fromOffset(W, H), Position = UDim2.fromScale(0.5, 0.5), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, Parent = gui })
local popScale = create("UIScale", { Scale = 0.86, Parent = holder })

local function fitScale()
	local cam = workspace.CurrentCamera
	local vp = cam and cam.ViewportSize or Vector2.new(1280, 720)
	return math.clamp(math.min((vp.X - 24) / W, (vp.Y - 24) / H), 0.5, 1)
end


local main = create("CanvasGroup", { Size = UDim2.fromScale(1, 1), BackgroundColor3 = BG, GroupTransparency = 1, BorderSizePixel = 0, ZIndex = 1, Parent = holder }, { corner(18) })
local mainFill = create("Frame", { Size = UDim2.fromScale(1, 1), BackgroundColor3 = WHITE, BorderSizePixel = 0, Parent = main }, { corner(18) })
create("UIGradient", { Color = ColorSequence.new(BG2, BG), Rotation = 90, Parent = mainFill })

local baseBorder = create("Frame", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ZIndex = 4, Parent = holder }, { corner(18) })
local baseStroke = stroke(LINE, 1, 1)
baseStroke.Parent = baseBorder
local border = create("Frame", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ZIndex = 5, Parent = holder }, { corner(18) })
local borderStroke = stroke(ACCENT, 1.5, 1)
borderStroke.Parent = border
local borderGrad = create("UIGradient", {
	Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.38, 1), NumberSequenceKeypoint.new(0.5, 0), NumberSequenceKeypoint.new(0.62, 1), NumberSequenceKeypoint.new(1, 1) }),
	Parent = borderStroke,
})

local orbs = {}
for i, spec in ipairs({ { 300, -80, -90, 0.93 }, { 240, W - 170, H - 150, 0.95 } }) do
	local orb = create("Frame", { Size = UDim2.fromOffset(spec[1], spec[1]), Position = UDim2.fromOffset(spec[2], spec[3]), BackgroundColor3 = ACCENT, BackgroundTransparency = spec[4], BorderSizePixel = 0, Parent = main }, { round() })
	create("UIGradient", { Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1) }), Rotation = 45 + i * 90, Parent = orb })
	orbs[i] = { frame = orb, x = spec[2], y = spec[3], phase = i * 1.7 }
end

local particles = {}
local rng = Random.new()
for i = 1, 18 do
	local s = rng:NextInteger(2, 3)
	local p = create("Frame", { Size = UDim2.fromOffset(s, s), BackgroundColor3 = ACCENT, BackgroundTransparency = 1, BorderSizePixel = 0, Parent = main }, { round() })
	particles[i] = { frame = p, x = rng:NextNumber(0, W), y = rng:NextNumber(0, H), speed = rng:NextNumber(6, 18), drift = rng:NextNumber(-6, 6), phase = rng:NextNumber(0, 6.28) }
end

local topLine = create("Frame", { Size = UDim2.new(1, -36, 0, 1), Position = UDim2.fromOffset(18, 0), BackgroundColor3 = ACCENT, BorderSizePixel = 0, Parent = main })
local topGrad = create("UIGradient", { Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.45, 0.2), NumberSequenceKeypoint.new(0.55, 0.2), NumberSequenceKeypoint.new(1, 1) }), Offset = Vector2.new(-1, 0), Parent = topLine })

local sections = {}
local function section(y, h)
	local sec = create("CanvasGroup", { Position = UDim2.fromOffset(0, y + 16), Size = UDim2.new(1, 0, 0, h), BackgroundTransparency = 1, GroupTransparency = 1, Parent = main })
	sections[#sections + 1] = { frame = sec, y = y }
	return sec
end

local pulses = {}
local function pulseDot(parent, pos, colour, size)
	size = size or 6
	local ring = create("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), Position = pos, Size = UDim2.fromOffset(size, size), BackgroundColor3 = colour, BackgroundTransparency = 0.5, BorderSizePixel = 0, Parent = parent }, { round() })
	local dot = create("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), Position = pos, Size = UDim2.fromOffset(size, size), BackgroundColor3 = colour, BorderSizePixel = 0, Parent = parent }, { round() })
	local entry = { ring = ring, dot = dot, size = size, phase = rng:NextNumber(0, 1), speed = 0.7 }
	pulses[#pulses + 1] = entry
	return entry
end
local function paintPulse(entry, colour)
	tween(entry.dot, 0.25, { BackgroundColor3 = colour })
	tween(entry.ring, 0.25, { BackgroundColor3 = colour })
end

local function ripple(button, colour)
	local m = UserInputService:GetMouseLocation()
	local abs = button.AbsolutePosition
	local sc = math.max(popScale.Scale, 0.01)
	local x, y = (m.X - abs.X) / sc, (m.Y - abs.Y) / sc
	if x < 0 or y < 0 or x > button.AbsoluteSize.X / sc or y > button.AbsoluteSize.Y / sc then
		x, y = button.AbsoluteSize.X / sc / 2, button.AbsoluteSize.Y / sc / 2
	end
	local size = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) / sc * 2.4
	local r = create("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset(x, y), Size = UDim2.fromOffset(0, 0), BackgroundColor3 = colour or WHITE, BackgroundTransparency = 0.78, BorderSizePixel = 0, ZIndex = 10, Parent = button }, { round() })
	tween(r, 0.55, { Size = UDim2.fromOffset(size, size), BackgroundTransparency = 1 }, Enum.EasingStyle.Quad)
	task.delay(0.6, function() r:Destroy() end)
end

local header = section(18, 56)
local logoBox = create("Frame", { Position = UDim2.fromOffset(24, 6), Size = UDim2.fromOffset(44, 44), BackgroundColor3 = FIELD, BorderSizePixel = 0, Parent = header }, { round() })
local ringStroke = stroke(WHITE, 1.6, 0)
ringStroke.Parent = logoBox
local ringGrad = create("UIGradient", {
	Color = ColorSequence.new(ACCENT, ACCENT),
	Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.5, 0.85), NumberSequenceKeypoint.new(1, 0) }),
	Parent = ringStroke,
})
local logoScale
if logoImage ~= "" then
	local img = create("ImageLabel", { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(26, 26), BackgroundTransparency = 1, Image = logoImage, ScaleType = Enum.ScaleType.Fit, ImageColor3 = ACCENT, Parent = logoBox })
	logoScale = create("UIScale", { Parent = img })
else
	local t = label(logoBox, ">>", UDim2.fromOffset(0, 0), UDim2.fromScale(1, 1), HEAVY, 18, ACCENT, Enum.TextXAlignment.Center)
	logoScale = create("UIScale", { Parent = t })
end
local titleRow = create("Frame", { Position = UDim2.fromOffset(80, 6), Size = UDim2.new(1, -140, 0, 44), BackgroundTransparency = 1, Parent = header }, {
	create("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, VerticalAlignment = Enum.VerticalAlignment.Center, Padding = UDim.new(0, 12), SortOrder = Enum.SortOrder.LayoutOrder }),
})
local title = create("TextLabel", { Size = UDim2.fromOffset(0, 32), AutomaticSize = Enum.AutomaticSize.X, BackgroundTransparency = 1, Text = "relay", Font = HEAVY, TextSize = 28, TextColor3 = TEXT, LayoutOrder = 1, Parent = titleRow })
local titleGrad = create("UIGradient", {
	Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, TEXT), ColorSequenceKeypoint.new(0.45, TEXT), ColorSequenceKeypoint.new(0.5, ACCENT), ColorSequenceKeypoint.new(0.55, TEXT), ColorSequenceKeypoint.new(1, TEXT) }),
	Offset = Vector2.new(-1, 0),
	Parent = title,
})
local badge = create("Frame", { Size = UDim2.fromOffset(0, 26), AutomaticSize = Enum.AutomaticSize.X, BackgroundColor3 = WHITE, BorderSizePixel = 0, ClipsDescendants = true, LayoutOrder = 2, Parent = titleRow }, {
	round(),
	create("UIGradient", { Color = ColorSequence.new(Color3.fromRGB(38, 35, 31), Color3.fromRGB(22, 22, 26)), Rotation = 90 }),
	create("UIPadding", { PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 12) }),
	create("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, VerticalAlignment = Enum.VerticalAlignment.Center, Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder }),
})
local badgeStroke = stroke(ACCENT, 1, 0.35)
badgeStroke.Parent = badge
local badgeGrad = create("UIGradient", {
	Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.1), NumberSequenceKeypoint.new(0.5, 0.85), NumberSequenceKeypoint.new(1, 0.1) }),
	Parent = badgeStroke,
})
local badgeIcon = create("ImageLabel", { Size = UDim2.fromOffset(12, 12), BackgroundTransparency = 1, ImageColor3 = ACCENT, LayoutOrder = 1, Parent = badge })
paintIcon(badgeIcon, "shield-check")
local badgeText = create("TextLabel", { Size = UDim2.fromOffset(0, 26), AutomaticSize = Enum.AutomaticSize.X, BackgroundTransparency = 1, Text = "KEY SYSTEM", Font = BOLD, TextSize = 11, TextColor3 = ACCENT, LayoutOrder = 2, Parent = badge })
local badgeShimmer = create("UIGradient", {
	Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, ACCENT), ColorSequenceKeypoint.new(0.45, ACCENT), ColorSequenceKeypoint.new(0.5, WHITE), ColorSequenceKeypoint.new(0.55, ACCENT), ColorSequenceKeypoint.new(1, ACCENT) }),
	Offset = Vector2.new(-1, 0),
	Parent = badgeText,
})
local closeBtn = create("TextButton", { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(1, -40, 0, 22), Size = UDim2.fromOffset(32, 32), BackgroundColor3 = FIELD, BorderSizePixel = 0, Text = "", AutoButtonColor = false, ClipsDescendants = true, Parent = header }, { corner(9), stroke(LINE, 1, 0.3) })
local closeIcon = icon(closeBtn, "x", 14, DIM, UDim2.fromOffset(9, 9))

local divider = create("Frame", { Position = UDim2.fromOffset(24, 84), Size = UDim2.new(1, -48, 0, 1), BackgroundColor3 = LINE, BorderSizePixel = 0, Parent = main })
create("UIGradient", { Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.15, 0), NumberSequenceKeypoint.new(0.85, 0), NumberSequenceKeypoint.new(1, 1) }), Parent = divider })

local cardSec = section(100, 74)
local gameCard = create("Frame", { Position = UDim2.fromOffset(24, 2), Size = UDim2.new(1, -48, 0, 70), BackgroundColor3 = PANEL, BorderSizePixel = 0, ClipsDescendants = true, Parent = cardSec }, { corner(14), stroke(LINE, 1, 0.35) })
create("UIGradient", { Color = ColorSequence.new(Color3.fromRGB(22, 22, 27), PANEL), Rotation = 0, Parent = gameCard })
local sheen = create("Frame", { Size = UDim2.new(0, 90, 1, 0), Position = UDim2.new(0, -120, 0, 0), BackgroundColor3 = WHITE, BackgroundTransparency = 0.94, BorderSizePixel = 0, Rotation = 0, Parent = gameCard })
create("UIGradient", { Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.5, 0), NumberSequenceKeypoint.new(1, 1) }), Parent = sheen })
local gameIcon = create("ImageLabel", { Position = UDim2.fromOffset(12, 11), Size = UDim2.fromOffset(48, 48), BackgroundColor3 = FIELD, BorderSizePixel = 0, ScaleType = Enum.ScaleType.Crop, Parent = gameCard }, { corner(11), stroke(LINE, 1, 0.2) })
local gameIconScale = create("UIScale", { Scale = 0.6, Parent = gameIcon })
task.spawn(function()
	local file = "Relay/gameicon_" .. tostring(game.GameId) .. ".png"
	local ok = pcall(function()
		if not (isfile and isfile(file)) then
			local res = game:HttpGet("https://thumbnails.roblox.com/v1/games/icons?universeIds=" .. tostring(game.GameId) .. "&size=150x150&format=Png")
			local url = res:match('"imageUrl":"([^"]+)"')
			if url and writefile then
				if makefolder and isfolder and not isfolder("Relay") then makefolder("Relay") end
				writefile(file, game:HttpGet(url))
			end
		end
		if getcustomasset and isfile and isfile(file) then gameIcon.Image = getcustomasset(file) end
	end)
	if not ok or gameIcon.Image == "" then
		pcall(function() gameIcon.Image = "rbxthumb://type=GameIcon&id=" .. tostring(game.PlaceId) .. "&w=150&h=150" end)
	end
end)
label(gameCard, "DETECTED GAME", UDim2.fromOffset(74, 12), UDim2.fromOffset(200, 12), BOLD, 9, FAINT)
local gameName = label(gameCard, detectedName, UDim2.fromOffset(74, 25), UDim2.new(1, -190, 0, 20), BOLD, 15, TEXT)
local supportDot = pulseDot(gameCard, UDim2.fromOffset(79, 54), supported and GREEN or DIM, 5)
local supportText = label(gameCard, supported and "Supported by Relay" or "Not supported yet", UDim2.fromOffset(89, 46), UDim2.fromOffset(240, 16), FONT, 12, supported and GREEN or DIM)
local execPill = create("Frame", { AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -14, 0.5, 0), Size = UDim2.fromOffset(96, 32), BackgroundColor3 = FIELD, BorderSizePixel = 0, Parent = gameCard }, { corner(9), stroke(LINE, 1, 0.25) })
icon(execPill, "cpu", 13, ACCENT, UDim2.fromOffset(11, 9))
label(execPill, executorName(), UDim2.fromOffset(30, 0), UDim2.new(1, -36, 1, 0), BOLD, 12, TEXT)

local keySec = section(186, 92)
label(keySec, "LICENSE KEY", UDim2.fromOffset(26, 2), UDim2.fromOffset(200, 14), BOLD, 10, DIM)

local field = create("Frame", { Position = UDim2.fromOffset(24, 22), Size = UDim2.new(1, -48, 0, 54), BackgroundColor3 = PANEL, BorderSizePixel = 0, Parent = keySec }, { corner(14) })
local fieldStroke = stroke(LINE, 1, 0.2)
fieldStroke.Parent = field
local keyIcon = icon(field, "key-round", 16, DIM, UDim2.fromOffset(17, 19))
local pasteW = getclipboard and 30 or 0
local box = create("TextBox", { Position = UDim2.fromOffset(44, 0), Size = UDim2.new(1, -180 - pasteW, 1, 0), BackgroundTransparency = 1, Text = "", PlaceholderText = "Paste your Relay key", PlaceholderColor3 = FAINT, Font = FONT, TextSize = 14, TextColor3 = TEXT, TextXAlignment = Enum.TextXAlignment.Left, ClearTextOnFocus = false, ClipsDescendants = true, Parent = field })
if getclipboard then
	local pasteBtn = create("TextButton", { AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(1, -170, 0.5, 0), Size = UDim2.fromOffset(28, 28), BackgroundColor3 = FIELD, BorderSizePixel = 0, Text = "", AutoButtonColor = false, ClipsDescendants = true, Parent = field }, { corner(8) })
	local pasteIcon = icon(pasteBtn, "clipboard-paste", 13, DIM, UDim2.fromOffset(7, 7))
	pasteBtn.MouseEnter:Connect(function() tween(pasteIcon, 0.15, { ImageColor3 = ACCENT }) end)
	pasteBtn.MouseLeave:Connect(function() tween(pasteIcon, 0.15, { ImageColor3 = DIM }) end)
	pasteBtn.MouseButton1Click:Connect(function()
		ripple(pasteBtn, ACCENT)
		local ok, clip = pcall(getclipboard)
		if ok and type(clip) == "string" and #clip > 0 then box.Text = clip:gsub("%s", "") end
	end)
end
local submit = create("TextButton", { AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -7, 0.5, 0), Size = UDim2.fromOffset(124, 40), BackgroundColor3 = ACCENT, BorderSizePixel = 0, Text = "", AutoButtonColor = false, ClipsDescendants = true, Parent = field }, { corner(10) })
local submitScale = create("UIScale", { Parent = submit })
create("UIGradient", { Color = ColorSequence.new(WHITE, Color3.fromRGB(205, 196, 183)), Rotation = 90, Parent = submit })
local shine = create("Frame", { Size = UDim2.new(0, 40, 1, 0), Position = UDim2.new(0, -60, 0, 0), BackgroundColor3 = WHITE, BackgroundTransparency = 0.55, BorderSizePixel = 0, Rotation = 18, Parent = submit })
create("UIGradient", { Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.5, 0), NumberSequenceKeypoint.new(1, 1) }), Parent = shine })
local submitText = label(submit, "Submit", UDim2.fromOffset(0, 0), UDim2.new(1, -26, 1, 0), BOLD, 13, BG, Enum.TextXAlignment.Center)
local submitIcon = icon(submit, "arrow-right", 15, BG, UDim2.new(1, -30, 0.5, -7))
local track = create("Frame", { Position = UDim2.fromOffset(38, 84), Size = UDim2.new(1, -76, 0, 2), BackgroundColor3 = LINE, BackgroundTransparency = 0.4, BorderSizePixel = 0, ClipsDescendants = true, Parent = keySec }, { round() })
local bar = create("Frame", { Size = UDim2.fromScale(0, 1), Position = UDim2.fromScale(0.5, 0), BackgroundColor3 = ACCENT, BorderSizePixel = 0, Parent = track }, { round() })
create("UIGradient", { Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.3, 0), NumberSequenceKeypoint.new(0.7, 0), NumberSequenceKeypoint.new(1, 1) }), Parent = bar })

local msgSec = section(284, 40)
local msgIcon = icon(msgSec, "lock", 12, DIM, UDim2.fromOffset(28, 3))
local message = create("TextLabel", { Position = UDim2.fromOffset(48, 0), Size = UDim2.new(1, -76, 0, 36), BackgroundTransparency = 1, Text = "", Font = FONT, TextSize = 12, TextColor3 = DIM, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top, TextWrapped = true, Parent = msgSec })

local btnSec = section(H - 70, 52)
local function pillButton(x, w, iconName, text, filled)
	local b = create("TextButton", { Position = UDim2.fromOffset(x, 6), Size = UDim2.fromOffset(w, 40), BackgroundColor3 = filled and FIELD or PANEL, BorderSizePixel = 0, Text = "", AutoButtonColor = false, ClipsDescendants = true, Parent = btnSec }, { corner(11) })
	local st = stroke(filled and ACCENT or LINE, 1, filled and 0.45 or 0.15)
	st.Parent = b
	local ic = icon(b, iconName, 14, filled and ACCENT or DIM, UDim2.fromOffset(14, 13))
	local t = label(b, text, UDim2.fromOffset(36, 0), UDim2.new(1, -40, 1, 0), BOLD, 12, TEXT)
	b.MouseEnter:Connect(function()
		tween(b, 0.18, { Position = UDim2.fromOffset(x, 3), BackgroundColor3 = Color3.fromRGB(32, 32, 38) })
		tween(st, 0.18, { Color = ACCENT, Transparency = 0.2 })
		tween(ic, 0.18, { ImageColor3 = ACCENT })
	end)
	b.MouseLeave:Connect(function()
		tween(b, 0.18, { Position = UDim2.fromOffset(x, 6), BackgroundColor3 = filled and FIELD or PANEL })
		tween(st, 0.18, { Color = filled and ACCENT or LINE, Transparency = filled and 0.45 or 0.15 })
		tween(ic, 0.18, { ImageColor3 = filled and ACCENT or DIM })
	end)
	b.MouseButton1Down:Connect(function() ripple(b, ACCENT) end)
	return b, t
end
local getKey, getKeyText = pillButton(24, 112, "sparkles", "Get a key", true)
local discordBtn, discordText = pillButton(146, 108, "message-circle", "Discord", false)
local siteBtn, siteText = pillButton(264, 108, "globe", "Website", false)
label(btnSec, "v2  ·  relayscripts.lol", UDim2.new(1, -170, 0, 6), UDim2.fromOffset(146, 40), FONT, 11, FAINT, Enum.TextXAlignment.Right)

local msgToken = 0
local function setMessage(text, colour, iconName)
	msgToken += 1
	local mine = msgToken
	colour = colour or DIM
	message.Text = tostring(text)
	message.TextColor3 = colour
	tween(msgIcon, 0.2, { ImageColor3 = colour })
	paintIcon(msgIcon, iconName or (colour == RED and "circle-alert" or colour == GREEN and "circle-check" or "lock"))
	message.MaxVisibleGraphemes = 0
	task.spawn(function()
		local total = utf8.len(message.Text) or #message.Text
		local step = math.max(1, math.floor(total / 30))
		local shown = 0
		while shown < total and mine == msgToken and alive do
			shown = math.min(total, shown + step)
			message.MaxVisibleGraphemes = shown
			task.wait(0.014)
		end
		if mine == msgToken then message.MaxVisibleGraphemes = -1 end
	end)
end

local function setStatus(_, colour)
	tween(fieldStroke, 0.3, { Color = colour == RED and RED or colour == GREEN and GREEN or LINE, Transparency = colour == ACCENT and 0.2 or 0 })
end

local function shake()
	local base = holder.Position
	task.spawn(function()
		for _, dx in ipairs({ 12, -10, 8, -6, 4, -2, 0 }) do
			if not alive then return end
			holder.Position = UDim2.new(base.X.Scale, base.X.Offset + dx, base.Y.Scale, base.Y.Offset)
			task.wait(0.035)
		end
	end)
	fieldStroke.Color = RED
	fieldStroke.Transparency = 0
	tween(fieldStroke, 0.9, { Color = LINE, Transparency = 0.2 }, Enum.EasingStyle.Quad)
end

local spinning = false
local progressMode = "idle"
local function setButton(state, text)
	if state == "busy" then
		spinning = true
		progressMode = "busy"
		submitText.Text = text or "Checking"
		paintIcon(submitIcon, "loader-circle")
		tween(submit, 0.2, { BackgroundColor3 = ACCENT })
	elseif state == "done" then
		spinning = false
		progressMode = "done"
		submitIcon.Rotation = 0
		submitText.Text = text or "Loaded"
		paintIcon(submitIcon, "check")
		tween(submit, 0.25, { BackgroundColor3 = GREEN })
		submitScale.Scale = 0.9
		tween(submitScale, 0.45, { Scale = 1 }, Enum.EasingStyle.Back)
	else
		spinning = false
		progressMode = "idle"
		submitIcon.Rotation = 0
		submitText.Text = text or "Submit"
		paintIcon(submitIcon, "arrow-right")
		tween(submit, 0.2, { BackgroundColor3 = ACCENT })
	end
end

local closing = false
local function closeUi(after)
	if closing then return end
	closing = true
	tween(popScale, 0.3, { Scale = popScale.Scale * 0.9 }, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
	tween(main, 0.28, { GroupTransparency = 1 }, Enum.EasingStyle.Quad)
	tween(borderStroke, 0.28, { Transparency = 1 }, Enum.EasingStyle.Quad)
	tween(baseStroke, 0.28, { Transparency = 1 }, Enum.EasingStyle.Quad)
	tween(backdrop, 0.35, { BackgroundTransparency = 1 }, Enum.EasingStyle.Quad)
	tween(blur, 0.35, { Size = 0 }, Enum.EasingStyle.Quad)
	task.delay(0.38, function()
		gui:Destroy()
		if after then after() end
	end)
end

closeBtn.MouseEnter:Connect(function()
	tween(closeBtn, 0.18, { BackgroundColor3 = Color3.fromRGB(58, 30, 32), Rotation = 90 })
	tween(closeIcon, 0.18, { ImageColor3 = RED })
end)
closeBtn.MouseLeave:Connect(function()
	tween(closeBtn, 0.18, { BackgroundColor3 = FIELD, Rotation = 0 })
	tween(closeIcon, 0.18, { ImageColor3 = DIM })
end)
closeBtn.MouseButton1Click:Connect(function() closeUi() end)

box.Focused:Connect(function()
	tween(fieldStroke, 0.2, { Color = ACCENT, Transparency = 0 })
	tween(field, 0.2, { BackgroundColor3 = Color3.fromRGB(21, 21, 26) })
	tween(keyIcon, 0.2, { ImageColor3 = ACCENT })
	if progressMode == "idle" then tween(bar, 0.45, { Size = UDim2.fromScale(1, 1), Position = UDim2.fromScale(0, 0) }) end
end)
box.FocusLost:Connect(function()
	tween(fieldStroke, 0.2, { Color = LINE, Transparency = 0.2 })
	tween(field, 0.2, { BackgroundColor3 = PANEL })
	tween(keyIcon, 0.2, { ImageColor3 = DIM })
	if progressMode == "idle" then tween(bar, 0.35, { Size = UDim2.fromScale(0, 1), Position = UDim2.fromScale(0.5, 0) }) end
end)
bind(box:GetPropertyChangedSignal("Text"), function()
	if progressMode ~= "idle" then return end
	local n = #box.Text:gsub("%s", "")
	if n > 0 then
		local k = create("UIScale", { Scale = 1.06, Parent = keyIcon })
		tween(k, 0.2, { Scale = 1 })
		task.delay(0.25, function() k:Destroy() end)
	end
end)

submit.MouseEnter:Connect(function()
	tween(submitScale, 0.2, { Scale = 1.04 }, Enum.EasingStyle.Back)
	shine.Position = UDim2.new(0, -60, 0, 0)
	tween(shine, 0.55, { Position = UDim2.new(1, 20, 0, 0) }, Enum.EasingStyle.Quad)
end)
submit.MouseLeave:Connect(function() tween(submitScale, 0.2, { Scale = 1 }) end)
submit.MouseButton1Down:Connect(function()
	tween(submitScale, 0.1, { Scale = 0.94 })
	ripple(submit, WHITE)
end)
submit.MouseButton1Up:Connect(function() tween(submitScale, 0.25, { Scale = 1.04 }, Enum.EasingStyle.Back) end)

local function flash(lbl, text, orig)
	lbl.Text = text
	task.delay(1.6, function() if alive then lbl.Text = orig end end)
end
getKey.MouseButton1Click:Connect(function()
	pcall(function() setclipboard(KeyUrl) end)
	flash(getKeyText, "Copied", "Get a key")
	setMessage("Key link copied. Open it in your browser to get a key.", GREEN, "link")
end)
discordBtn.MouseButton1Click:Connect(function()
	pcall(function() setclipboard("https://discord.gg/" .. DiscordInvite) end)
	if openDiscord(DiscordInvite) then flash(discordText, "Opening", "Discord") else flash(discordText, "Copied", "Discord") end
end)
siteBtn.MouseButton1Click:Connect(function()
	local site = tostring(WebsiteLabel)
	if not site:match("^https?://") then site = "https://www." .. site:gsub("^www%.", "") end
	pcall(function() setclipboard(site) end)
	flash(siteText, "Copied", "Website")
end)

do
	local dragInput, dragStart, startPos
	header.InputBegan:Connect(function(io)
		local t = io.UserInputType
		if t == Enum.UserInputType.MouseButton1 or t == Enum.UserInputType.Touch then
			dragInput, dragStart, startPos = io, io.Position, holder.Position
		end
	end)
	bind(UserInputService.InputChanged, function(io)
		if not dragInput then return end
		local t = io.UserInputType
		local mine = (t == Enum.UserInputType.Touch and io == dragInput)
			or (t == Enum.UserInputType.MouseMovement and dragInput.UserInputType == Enum.UserInputType.MouseButton1)
		if mine then
			local d = io.Position - dragStart
			holder.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
		end
	end)
	bind(UserInputService.InputEnded, function(io)
		if not dragInput then return end
		if io == dragInput or (io.UserInputType == Enum.UserInputType.MouseButton1 and dragInput.UserInputType == Enum.UserInputType.MouseButton1) then
			dragInput = nil
		end
	end)
end

local clock = 0
local barX = -0.35
bind(RunService.RenderStepped, function(dt)
	if not alive then return end
	clock += dt
	borderGrad.Rotation = (borderGrad.Rotation + dt * 45) % 360
	ringGrad.Rotation = (ringGrad.Rotation + dt * 120) % 360
	if logoScale then logoScale.Scale = 1 + math.sin(clock * 2.2) * 0.05 end
	local cycle = (clock % 3.2) / 3.2
	titleGrad.Offset = Vector2.new(-1 + cycle * 2.6, 0)
	badgeGrad.Rotation = (badgeGrad.Rotation + dt * 90) % 360
	badgeShimmer.Offset = Vector2.new(-1 + ((clock * 0.4 + 0.3) % 1.4) * 1.6, 0)
	topGrad.Offset = Vector2.new(-1 + ((clock * 0.35) % 1) * 2, 0)
	for _, o in ipairs(orbs) do
		o.frame.Position = UDim2.fromOffset(o.x + math.sin(clock * 0.35 + o.phase) * 26, o.y + math.cos(clock * 0.28 + o.phase) * 20)
	end
	for _, p in ipairs(particles) do
		p.y -= p.speed * dt
		p.x += math.sin(clock + p.phase) * p.drift * dt
		if p.y < -6 then
			p.y = H + 6
			p.x = rng:NextNumber(0, W)
		end
		p.frame.Position = UDim2.fromOffset(p.x, p.y)
		p.frame.BackgroundTransparency = 0.55 + 0.4 * (0.5 + 0.5 * math.sin(clock * 1.6 + p.phase))
	end
	for _, e in ipairs(pulses) do
		e.phase = (e.phase + dt * e.speed) % 1
		local s = e.size + e.phase * e.size * 1.8
		e.ring.Size = UDim2.fromOffset(s, s)
		e.ring.BackgroundTransparency = 0.45 + 0.55 * e.phase
	end
	if spinning then submitIcon.Rotation = (submitIcon.Rotation + dt * 420) % 360 end
	if progressMode == "busy" then
		barX += dt * 0.9
		if barX > 1 then barX = -0.35 end
		bar.Size = UDim2.fromScale(0.35, 1)
		bar.Position = UDim2.fromScale(barX, 0)
	elseif progressMode == "done" then
		bar.Size = bar.Size:Lerp(UDim2.fromScale(1, 1), math.min(1, dt * 8))
		bar.Position = bar.Position:Lerp(UDim2.fromScale(0, 0), math.min(1, dt * 8))
		bar.BackgroundColor3 = GREEN
	end
end)

if workspace.CurrentCamera then
	bind(workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"), function()
		if not closing then popScale.Scale = fitScale() end
	end)
end

local busy = false

local function trySubmit()
	if busy then return end
	local k = box.Text:gsub("%s", "")
	if not validFormat(k) then
		shake()
		setMessage("That key is not in a valid format.", RED)
		return
	end
	if not supported and configReady then
		shake()
		setMessage("Relay does not support this game yet.", RED)
		return
	end
	busy = true
	setButton("busy", "Checking")
	setMessage("Checking your key with Relay...", DIM, "shield-check")
	setStatus("CHECKING", ACCENT)
	task.spawn(function()
		if not supported then
			awaitConfig(8)
			detectedName, supported = gameInfo()
			if not supported then
				busy = false
				setButton("idle")
				setStatus("KEY REQUIRED", ACCENT)
				shake()
				setMessage("Relay does not support this game yet.", RED)
				return
			end
		end
		local valid, why, confirmed = checkKey(k)
		if not valid then
			busy = false
			setButton("idle")
			shake()
			setMessage(why or "That key was rejected.", RED)
			setStatus("KEY REJECTED", RED)
			return
		end
		setButton("busy", "Loading")
		setStatus("LOADING", ACCENT)
		setMessage("Key verified. Downloading " .. detectedName .. "...", ACCENT, "download")
		local before = currentLib()
		_G.RelayStatus = nil
		local ok, err = runLoader(k)
		if not ok then
			busy = false
			if confirmed then saveKey(k) end
			setButton("idle")
			shake()
			setMessage(err or "Could not start.", RED)
			setStatus("FAILED", RED)
			return
		end
		local state, failure = waitStart(before, 20)
		if state == "ok" then
			saveKey(k)
			setStatus("LOADED", GREEN)
			setButton("done", "Loaded")
			setMessage("Key accepted. Loading " .. detectedName .. "...", GREEN)
			task.wait(1)
			closeUi()
		elseif state == "error" then
			busy = false
			saveKey(k)
			setButton("idle")
			shake()
			setMessage("The script hit an error while starting: " .. tostring(failure):gsub("^ERROR:%s*", ""), RED)
			setStatus("SCRIPT ERROR", RED)
		elseif confirmed or genv.SNC_RUNNING then
			busy = false
			saveKey(k)
			setButton("idle")
			shake()
			setMessage("Key accepted, but the script did not start. Try again or ask support.", RED)
			setStatus("SCRIPT DID NOT START", RED)
		else
			busy = false
			clearKey()
			setButton("idle")
			shake()
			setMessage("That key was rejected. Use Get a key to grab a new one.", RED)
			setStatus("KEY REJECTED", RED)
		end
	end)
end

submit.MouseButton1Click:Connect(trySubmit)
box.FocusLost:Connect(function(enter) if enter then trySubmit() end end)

local initialText, initialTextColour = "Your key is saved after the first successful load.", DIM
if saved then box.Text = saved end
if startupKind == "key" and saved then
	initialText, initialTextColour = "Your saved key did not work" .. (startupError and (": " .. tostring(startupError)) or ". Paste a new one."), RED
elseif startupError then
	initialText, initialTextColour = tostring(startupError), RED
end
local unsupportedText = "Relay does not have a script for this game yet. Check the Discord for the game list."
if not supported and configReady then initialText, initialTextColour = unsupportedText, RED end

task.spawn(function()
	awaitConfig(15)
	local t0 = os.clock()
	while not productReady and os.clock() - t0 < 10 do task.wait(0.1) end
	if not gui.Parent then return end
	local wasSupported = supported
	detectedName, supported = gameInfo()
	gameName.Text = detectedName
	paintPulse(supportDot, supported and GREEN or DIM)
	supportText.Text = supported and "Supported by Relay" or "Not supported yet"
	tween(supportText, 0.25, { TextColor3 = supported and GREEN or DIM })
	if not supported then
		if not busy then setMessage(unsupportedText, RED) end
	elseif not wasSupported and not busy and not startupError then
		setMessage("Your key is saved after the first successful load.", DIM)
	end
end)


local target = fitScale()
tween(backdrop, 0.5, { BackgroundTransparency = 0.35 }, Enum.EasingStyle.Quad)
tween(blur, 0.5, { Size = 14 }, Enum.EasingStyle.Quad)
tween(popScale, 0.65, { Scale = target }, Enum.EasingStyle.Back)
tween(main, 0.4, { GroupTransparency = 0 }, Enum.EasingStyle.Quad)
tween(borderStroke, 0.6, { Transparency = 0 }, Enum.EasingStyle.Quad)
tween(baseStroke, 0.6, { Transparency = 0.1 }, Enum.EasingStyle.Quad)
for i, sec in ipairs(sections) do
	task.delay(0.12 + i * 0.08, function()
		if not alive then return end
		tween(sec.frame, 0.55, { Position = UDim2.fromOffset(0, sec.y), GroupTransparency = 0 })
	end)
end
task.delay(0.45, function()
	if not alive then return end
	tween(gameIconScale, 0.5, { Scale = 1 }, Enum.EasingStyle.Back)
	tween(sheen, 0.9, { Position = UDim2.new(1, 30, 0, 0) }, Enum.EasingStyle.Quad)
end)
task.delay(0.7, function()
	if not alive or busy then return end
	if configReady and not supported then
		setMessage(unsupportedText, RED)
	else
		setMessage(initialText, initialTextColour)
	end
end)
