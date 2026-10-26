-- Eynch Hub | game loader
-- Finds out which game you are in, shows a short loading animation with the Eynch logo,
-- and runs that game's script from the games/ folder of this repo. Nothing else is contacted.
if not game:IsLoaded() then
	game.Loaded:Wait()
end

local ROOT = "https://raw.githubusercontent.com/eynchLoad/EynchHub/main/"
local RAW = ROOT .. "games/"
local LOGO_URL = ROOT .. "assets/logo.png"
local DISCORD_CODE = "54aGSfX6dN"
local DISCORD_URL = "https://discord.gg/" .. DISCORD_CODE

-- One entry per game. To add a game: upload its script to games/ and add an entry here.
--   file       the file name in games/ (without .lua)
--   places     PlaceIds that load it
--   universes  UniverseIds that load it (covers a game's other places too)
--   creators   CreatorIds (user or group) that load it. One line covers EVERY game by that creator, so only use it
--              for a creator whose games the script really supports.
local GAMES = {
	{
		name = "Run a Sari-Sari Store!",
		file = "i83q4ab",
		places = { 104178853788462 },
		universes = { 10126644530 },
		creators = {},
	},
	{
        name = "Talyer!",
        file = "1io2poi",
        places = { 93820219970672 },
        universes = {},
        creators = {},
    },
}

-- Executors that cannot run the scripts. Put the name (or part of it) in lowercase, for example { "solara", "xeno" }.
-- Anyone using one gets a plain "not supported" message and nothing is loaded.
local BLOCKED_EXECUTORS = {}

local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

local function notify(text)
	pcall(function()
		game:GetService("StarterGui"):SetCore("SendNotification", {
			Title = "Eynch Hub",
			Text = text,
			Duration = 6,
		})
	end)
end

--================ executor check ================--
do
	local blocked = false
	pcall(function()
		local name = tostring(identifyexecutor and identifyexecutor() or ""):lower()
		for _, bad in ipairs(BLOCKED_EXECUTORS) do
			if name:find(bad, 1, true) then blocked = true end
		end
	end)
	if blocked then
		notify("This executor isn't supported.")
		return
	end
end

--================ which game ================--
local function find()
	for _, g in ipairs(GAMES) do
		for _, id in ipairs(g.places or {}) do
			if id == game.PlaceId then return g end
		end
		for _, id in ipairs(g.universes or {}) do
			if id == game.GameId then return g end
		end
		for _, id in ipairs(g.creators or {}) do
			if id == game.CreatorId then return g end
		end
	end
end

local match = find()
if not match then
	local names = {}
	for _, g in ipairs(GAMES) do names[#names + 1] = g.name end
	notify("This game is not supported yet. Supported: " .. table.concat(names, ", "))
	return
end

-- do not run twice in the same server (a new server after a rejoin has a new JobId, so it loads again)
if getgenv and getgenv().EynchHubLoaded == game.JobId and game.JobId ~= "" then
	notify(match.name .. " is already loaded.")
	return
end

--================ loading animation ================--
-- The logo is downloaded once into the executor's workspace folder (EynchHub/logo.png). If the executor cannot do that,
-- a big "E" is drawn instead, so the animation always works.
local function getLogo()
	if not (writefile and isfile and getcustomasset) then return nil end
	local ok, asset = pcall(function()
		if isfolder and makefolder and not isfolder("EynchHub") then makefolder("EynchHub") end
		if not isfile("EynchHub/logo.png") then
			writefile("EynchHub/logo.png", game:HttpGet(LOGO_URL))
		end
		return getcustomasset("EynchHub/logo.png")
	end)
	if ok and type(asset) == "string" and asset ~= "" then return asset end
	return nil
end

-- Copies the invite. If the Discord app is open on a PC it also asks it to show the invite window; the player still
-- chooses whether to join. Nothing joins automatically.
local function joinDiscord()
	local copied = false
	if setclipboard then
		pcall(function() setclipboard(DISCORD_URL) copied = true end)
	end
	pcall(function()
		local req = (syn and syn.request) or request or http_request or (http and http.request)
		if req then
			req({
				Url = "http://127.0.0.1:6463/rpc?v=1",
				Method = "POST",
				Headers = { ["Content-Type"] = "application/json", Origin = "https://discord.com" },
				Body = HttpService:JSONEncode({
					cmd = "INVITE_BROWSER",
					args = { code = DISCORD_CODE },
					nonce = HttpService:GenerateGUID(false),
				}),
			})
		end
	end)
	return copied
end

local PINK = Color3.fromRGB(255, 140, 185)
local PURPLE = Color3.fromRGB(190, 120, 255)

local function showSplash(text)
	local ok, api = pcall(function()
		local gui = Instance.new("ScreenGui")
		gui.Name = "EynchLoading"
		gui.ResetOnSpawn = false
		gui.IgnoreGuiInset = true
		gui.DisplayOrder = 1000
		gui.Parent = (gethui and gethui()) or game:GetService("CoreGui")

		local card = Instance.new("CanvasGroup")
		card.AnchorPoint = Vector2.new(0.5, 0.5)
		card.Position = UDim2.fromScale(0.5, 0.5)
		card.Size = UDim2.fromOffset(280, 256)
		card.BackgroundColor3 = Color3.fromRGB(22, 12, 30)
		card.BackgroundTransparency = 0.08
		card.GroupTransparency = 1
		card.Parent = gui
		Instance.new("UICorner", card).CornerRadius = UDim.new(0, 20)

		local rim = Instance.new("UIStroke", card)
		rim.Thickness = 1.5
		rim.Color = Color3.new(1, 1, 1)
		local rimGrad = Instance.new("UIGradient", rim)
		rimGrad.Color = ColorSequence.new(PINK, PURPLE)
		rimGrad.Rotation = 35

		-- spinning gradient ring around the logo
		local ringBox = Instance.new("Frame")
		ringBox.BackgroundTransparency = 1
		ringBox.AnchorPoint = Vector2.new(0.5, 0)
		ringBox.Position = UDim2.new(0.5, 0, 0, 18)
		ringBox.Size = UDim2.fromOffset(112, 112)
		ringBox.Parent = card
		local ring = Instance.new("Frame")
		ring.BackgroundTransparency = 1
		ring.Size = UDim2.fromScale(1, 1)
		ring.Parent = ringBox
		Instance.new("UICorner", ring).CornerRadius = UDim.new(1, 0)
		local ringStroke = Instance.new("UIStroke", ring)
		ringStroke.Thickness = 3
		ringStroke.Color = Color3.new(1, 1, 1)
		local ringGrad = Instance.new("UIGradient", ringStroke)
		ringGrad.Color = ColorSequence.new(PINK, PURPLE)
		ringGrad.Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0),
			NumberSequenceKeypoint.new(0.55, 0.9),
			NumberSequenceKeypoint.new(1, 0),
		})

		-- the logo (or a drawn E if it could not be downloaded)
		local logoBox = Instance.new("Frame")
		logoBox.BackgroundTransparency = 1
		logoBox.AnchorPoint = Vector2.new(0.5, 0.5)
		logoBox.Position = UDim2.fromScale(0.5, 0.5)
		logoBox.Size = UDim2.fromOffset(84, 84)
		logoBox.Parent = ringBox
		local pulse = Instance.new("UIScale", logoBox)

		local asset = getLogo()
		if asset then
			local img = Instance.new("ImageLabel")
			img.BackgroundTransparency = 1
			img.Size = UDim2.fromScale(1, 1)
			img.Image = asset
			img.ScaleType = Enum.ScaleType.Fit
			img.Parent = logoBox
		else
			local e = Instance.new("TextLabel")
			e.BackgroundTransparency = 1
			e.Size = UDim2.fromScale(1, 1)
			e.Text = "E"
			e.Font = Enum.Font.GothamBlack
			e.TextScaled = true
			e.TextColor3 = Color3.new(1, 1, 1)
			e.Parent = logoBox
			local g = Instance.new("UIGradient", e)
			g.Color = ColorSequence.new(PINK, PURPLE)
			g.Rotation = 90
		end

		local title = Instance.new("TextLabel")
		title.BackgroundTransparency = 1
		title.Position = UDim2.fromOffset(0, 136)
		title.Size = UDim2.new(1, 0, 0, 24)
		title.Text = "Eynch Hub"
		title.Font = Enum.Font.GothamBold
		title.TextSize = 18
		title.TextColor3 = Color3.fromRGB(250, 240, 247)
		title.Parent = card

		local status = Instance.new("TextLabel")
		status.BackgroundTransparency = 1
		status.Position = UDim2.fromOffset(12, 162)
		status.Size = UDim2.new(1, -24, 0, 18)
		status.Text = text or "Loading..."
		status.Font = Enum.Font.Gotham
		status.TextSize = 12
		status.TextColor3 = Color3.fromRGB(190, 160, 182)
		status.TextTruncate = Enum.TextTruncate.AtEnd
		status.Parent = card

		-- sliding loading bar
		local track = Instance.new("Frame")
		track.AnchorPoint = Vector2.new(0.5, 0)
		track.Position = UDim2.new(0.5, 0, 0, 190)
		track.Size = UDim2.fromOffset(180, 4)
		track.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		track.BackgroundTransparency = 0.88
		track.BorderSizePixel = 0
		track.ClipsDescendants = true
		track.Parent = card
		Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)
		local fill = Instance.new("Frame")
		fill.Size = UDim2.fromScale(0.4, 1)
		fill.BackgroundColor3 = Color3.new(1, 1, 1)
		fill.BorderSizePixel = 0
		fill.Parent = track
		Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
		local fillGrad = Instance.new("UIGradient", fill)
		fillGrad.Color = ColorSequence.new(PINK, PURPLE)

		-- Join Discord button
		local join = Instance.new("TextButton")
		join.AnchorPoint = Vector2.new(0.5, 0)
		join.Position = UDim2.new(0.5, 0, 0, 208)
		join.Size = UDim2.fromOffset(200, 32)
		join.AutoButtonColor = false
		join.Text = "💬  Join our Discord"
		join.Font = Enum.Font.GothamBold
		join.TextSize = 13
		join.TextColor3 = Color3.new(1, 1, 1)
		join.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
		join.BackgroundTransparency = 0.15
		join.Parent = card
		Instance.new("UICorner", join).CornerRadius = UDim.new(1, 0)
		local joinGrad = Instance.new("UIGradient", join)
		joinGrad.Color = ColorSequence.new(PINK, PURPLE)
		joinGrad.Rotation = 0
		join.Activated:Connect(function()
			local copied = joinDiscord()
			join.Text = copied and "✓  Invite copied" or "discord.gg/" .. DISCORD_CODE
			task.delay(2.5, function()
				pcall(function() join.Text = "💬  Join our Discord" end)
			end)
		end)

		local t = 0
		local conn = RunService.RenderStepped:Connect(function(dt)
			t = t + dt
			ringGrad.Rotation = (t * 160) % 360
			pulse.Scale = 1 + 0.045 * math.sin(t * 3.2)
			fill.Position = UDim2.fromScale(((t * 0.9) % 1.5) - 0.4, 0)
		end)

		TweenService:Create(card, TweenInfo.new(0.35, Enum.EasingStyle.Quad), { GroupTransparency = 0 }):Play()

		local closed = false
		return {
			setText = function(s) status.Text = s end,
			close = function()
				if closed then return end
				closed = true
				local tw = TweenService:Create(card, TweenInfo.new(0.3, Enum.EasingStyle.Quad), { GroupTransparency = 1 })
				tw:Play()
				task.delay(0.35, function()
					pcall(function() conn:Disconnect() end)
					pcall(function() gui:Destroy() end)
				end)
			end,
		}
	end)
	if ok and type(api) == "table" then return api end
	return { setText = function() end, close = function() end }
end

--================ key ================--
-- The key is free and is posted in the Discord server (members only). Only a hash of it is stored here, so reading this file
-- does not show it. Keep the key in the Discord channel and change KEY_HASH here if you ever change the key.
local KEY_HASH = "1c0b5dab193f35a6"
local KEY_FILE = "EynchHub/key.txt"

local function hashKey(s)
	s = "eynch|" .. s:lower()
	local function fnv(seed)
		local h = seed
		for i = 1, #s do
			h = bit32.bxor(h, s:byte(i))
			-- h * 16777619 mod 2^32, split so the numbers stay exact
			h = ((h % 65536) * 16777619 + (((math.floor(h / 65536) * 16777619) % 65536) * 65536)) % 4294967296
		end
		return string.format("%08x", h)
	end
	return fnv(2166136261) .. fnv(305419896)
end

local function keyOk(k)
	k = tostring(k or ""):gsub("^%s+", ""):gsub("%s+$", "")
	return k ~= "" and hashKey(k) == KEY_HASH, k
end

local function askKey()
	local saved
	pcall(function()
		if isfile and readfile and isfile(KEY_FILE) then saved = readfile(KEY_FILE) end
	end)
	if saved and keyOk(saved) then return true end

	local UIS = game:GetService("UserInputService")
	local lp = game:GetService("Players").LocalPlayer
	local C = {
		bg = Color3.fromRGB(10, 5, 12),
		tint = Color3.fromRGB(34, 18, 34),
		text = Color3.fromRGB(250, 240, 247),
		muted = Color3.fromRGB(190, 160, 182),
		pink = PINK,
		purple = PURPLE,
		green = Color3.fromRGB(125, 225, 160),
		red = Color3.fromRGB(255, 110, 120),
		blue = Color3.fromRGB(110, 190, 255),
	}

	local function New(class, props, parent)
		local obj = Instance.new(class)
		for k, v in pairs(props or {}) do obj[k] = v end
		obj.Parent = parent
		return obj
	end
	local function Round(obj, radius)
		return New("UICorner", { CornerRadius = UDim.new(0, radius) }, obj)
	end
	local function Tween(obj, duration, props, style)
		local t = TweenService:Create(obj, TweenInfo.new(duration, style or Enum.EasingStyle.Quint, Enum.EasingDirection.Out), props)
		t:Play()
		return t
	end
	local function Glass(obj, radius, transparency, rimTransparency)
		obj.BackgroundColor3 = C.tint
		obj.BackgroundTransparency = transparency or 0.28
		obj.BorderSizePixel = 0
		Round(obj, radius or 14)
		New("UIGradient", {
			Rotation = 35,
			Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 0),
				NumberSequenceKeypoint.new(0.55, 0.12),
				NumberSequenceKeypoint.new(1, 0.3),
			}),
		}, obj)
		local stroke = New("UIStroke", {
			Thickness = 1,
			Color = Color3.new(1, 1, 1),
			Transparency = rimTransparency or 0.7,
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		}, obj)
		New("UIGradient", {
			Rotation = 55,
			Color = ColorSequence.new(C.pink, C.purple),
			Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 0.15),
				NumberSequenceKeypoint.new(0.5, 0.78),
				NumberSequenceKeypoint.new(1, 0.2),
			}),
		}, stroke)
	end

	local host = (gethui and gethui()) or game:GetService("CoreGui")
	-- never stack two key windows (an old one from an earlier run)
	pcall(function()
		for _, old in ipairs(host:GetChildren()) do
			if old.Name == "EynchKey" or old.Name == "EynchPremiumLoader" then old:Destroy() end
		end
	end)
	local gui = New("ScreenGui", {
		Name = "EynchKey",
		ResetOnSpawn = false,
		IgnoreGuiInset = true,
		DisplayOrder = 1000,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
	}, host)

	local overlay = New("Frame", {
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = C.bg,
		BackgroundTransparency = 0.32,
		BorderSizePixel = 0,
	}, gui)
	New("UIGradient", {
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(18, 8, 22)),
			ColorSequenceKeypoint.new(0.5, Color3.fromRGB(10, 5, 12)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(28, 12, 32)),
		}),
		Rotation = 25,
	}, overlay)

	local isMobile = UIS.TouchEnabled
	local card = New("CanvasGroup", {
		Size = UDim2.fromOffset(isMobile and 340 or 420, isMobile and 330 or 350),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		GroupTransparency = 1,
	}, overlay)
	Glass(card, 22, 0.23, 0.48)
	local cardScale = New("UIScale", { Scale = 0.9 }, card)

	--================ header ================--
	local header = New("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, -28, 0, 66),
		Position = UDim2.fromOffset(14, 12),
	}, card)

	-- spinning ring with YOUR logo inside (a drawn E if the logo could not be downloaded)
	local holder = New("Frame", { BackgroundTransparency = 1, Size = UDim2.fromOffset(50, 50), Position = UDim2.fromOffset(0, 3) }, header)
	local orbit = New("Frame", { BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1) }, holder)
	Round(orbit, 50)
	local orbitStroke = New("UIStroke", { Thickness = 2.5, Color = Color3.new(1, 1, 1) }, orbit)
	local ringGrad = New("UIGradient", {
		Color = ColorSequence.new(C.pink, C.purple),
		Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0),
			NumberSequenceKeypoint.new(0.55, 0.15),
			NumberSequenceKeypoint.new(0.62, 0.9),
			NumberSequenceKeypoint.new(1, 0.9),
		}),
	}, orbitStroke)
	local logoBox = New("Frame", {
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(36, 36),
	}, holder)
	local asset = getLogo()
	if asset then
		New("ImageLabel", { BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), Image = asset, ScaleType = Enum.ScaleType.Fit }, logoBox)
	else
		local e = New("TextLabel", {
			BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), Text = "E",
			Font = Enum.Font.GothamBlack, TextScaled = true, TextColor3 = Color3.new(1, 1, 1),
		}, logoBox)
		New("UIGradient", { Color = ColorSequence.new(C.pink, C.purple), Rotation = 90 }, e)
	end

	New("TextLabel", {
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(62, 3),
		Size = UDim2.new(1, -105, 0, 25),
		Text = "Eynch Hub",
		Font = Enum.Font.GothamBold,
		TextSize = 18,
		TextColor3 = C.text,
		TextXAlignment = Enum.TextXAlignment.Left,
	}, header)
	New("TextLabel", {
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(62, 30),
		Size = UDim2.new(1, -105, 0, 18),
		Text = "Premium Script Hub  •  Free key",
		Font = Enum.Font.Gotham,
		TextSize = 11,
		TextColor3 = C.muted,
		TextXAlignment = Enum.TextXAlignment.Left,
	}, header)

	local close = New("TextButton", {
		Size = UDim2.fromOffset(30, 30),
		Position = UDim2.new(1, -30, 0, 5),
		Text = "×",
		TextSize = 22,
		Font = Enum.Font.GothamMedium,
		TextColor3 = C.muted,
		BackgroundColor3 = C.tint,
		BackgroundTransparency = 0.5,
		AutoButtonColor = false,
	}, header)
	Round(close, 9)

	New("TextLabel", {
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(16, 80),
		Size = UDim2.new(1, -32, 0, 32),
		Text = "Join our Discord and press Get Key in the panel. Your key is free. Then paste it below.",
		TextWrapped = true,
		Font = Enum.Font.Gotham,
		TextSize = 11,
		TextColor3 = C.muted,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
	}, card)

	--================ discord button ================--
	local discord = New("TextButton", {
		Size = UDim2.new(1, -28, 0, 40),
		Position = UDim2.fromOffset(14, 119),
		Text = "💬  JOIN DISCORD FOR FREE KEY",
		TextColor3 = C.text,
		Font = Enum.Font.GothamBold,
		TextSize = 12,
		AutoButtonColor = false,
	}, card)
	Glass(discord, 11, 0.58, 0.76)
	discord.MouseEnter:Connect(function() Tween(discord, 0.15, { BackgroundTransparency = 0.38, TextColor3 = C.pink }) end)
	discord.MouseLeave:Connect(function() Tween(discord, 0.15, { BackgroundTransparency = 0.58, TextColor3 = C.text }) end)

	--================ key box ================--
	local keyHolder = New("Frame", { Size = UDim2.new(1, -28, 0, 44), Position = UDim2.fromOffset(14, 171) }, card)
	Glass(keyHolder, 11, 0.58, 0.76)
	New("TextLabel", { BackgroundTransparency = 1, Size = UDim2.fromOffset(38, 44), Text = "🔑", TextSize = 17 }, keyHolder)
	local keyBox = New("TextBox", {
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(39, 0),
		Size = UDim2.new(1, -52, 1, 0),
		Text = "",
		PlaceholderText = "Enter your key",
		PlaceholderColor3 = C.muted,
		TextColor3 = C.text,
		TextXAlignment = Enum.TextXAlignment.Left,
		ClearTextOnFocus = false,
		Font = Enum.Font.Gotham,
		TextSize = 13,
	}, keyHolder)

	local status = New("TextLabel", {
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(16, 222),
		Size = UDim2.new(1, -32, 0, 20),
		Text = "Join our Discord, press Get Key, then paste your key here.",
		Font = Enum.Font.Gotham,
		TextSize = 11,
		TextColor3 = C.muted,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd,
	}, card)

	local verify = New("TextButton", {
		Size = UDim2.new(1, -28, 0, 42),
		Position = UDim2.fromOffset(14, 250),
		Text = "",
		AutoButtonColor = false,
	}, card)
	Glass(verify, 12, 0.25, 0.42)
	New("UIGradient", {
		Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, C.pink), ColorSequenceKeypoint.new(1, C.purple) }),
		Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.15), NumberSequenceKeypoint.new(1, 0.35) }),
		Rotation = 15,
	}, verify)
	-- own label so the gradient does not tint the text
	local verifyLabel = New("TextLabel", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		Text = "VERIFY KEY & LOAD",
		Font = Enum.Font.GothamBold,
		TextSize = 13,
		TextColor3 = Color3.new(1, 1, 1),
	}, verify)

	New("Frame", {
		Size = UDim2.new(1, -28, 0, 1),
		Position = UDim2.fromOffset(14, 298),
		BackgroundColor3 = Color3.new(1, 1, 1),
		BackgroundTransparency = 0.9,
		BorderSizePixel = 0,
	}, card)
	New("TextLabel", {
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(14, 300),
		Size = UDim2.new(1, -28, 0, 18),
		Text = "Secure loader • Eynch Hub",
		Font = Enum.Font.Gotham,
		TextSize = 9,
		TextColor3 = C.muted,
	}, card)

	--================ behaviour ================--
	local done, passed, busy = false, false, false

	local function setStatus(message, color)
		status.Text = message
		status.TextColor3 = color or C.muted
	end

	discord.Activated:Connect(function()
		if joinDiscord() then
			setStatus("Discord invite copied. Join, press Get Key, then paste your key here.", C.green)
		else
			keyBox.Text = DISCORD_URL
			setStatus("Copy the invite from the box, join the Discord, then paste your key here.", C.blue)
		end
	end)

	close.Activated:Connect(function() passed, done = false, true end)

	local function submit()
		if busy then return end
		local ok, k = keyOk(keyBox.Text)
		if not ok then
			setStatus(k == "" and "Enter your key first." or "Invalid key. Join Discord to get the free key.", C.red)
			return
		end
		busy = true
		verifyLabel.Text = "AUTHORIZED"
		setStatus("Valid key. Loading Eynch...", C.green)
		pcall(function()
			if writefile then
				if isfolder and makefolder and not isfolder("EynchHub") then makefolder("EynchHub") end
				writefile(KEY_FILE, k)
			end
		end)
		task.wait(0.45)
		passed, done = true, true
	end
	verify.Activated:Connect(submit)
	keyBox.FocusLost:Connect(function(enter) if enter then submit() end end)

	-- drag by the header (mouse + touch)
	local dragging, dragStart, startPos = false, Vector2.zero, card.Position
	local function isPress(i)
		return i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch
	end
	header.InputBegan:Connect(function(i)
		if isPress(i) then
			dragging, dragStart, startPos = true, Vector2.new(i.Position.X, i.Position.Y), card.Position
		end
	end)
	local moveConn = UIS.InputChanged:Connect(function(i)
		if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
			local d = Vector2.new(i.Position.X, i.Position.Y) - dragStart
			card.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
		end
	end)
	local endConn = UIS.InputEnded:Connect(function(i)
		if isPress(i) then dragging = false end
	end)
	local spinConn = RunService.RenderStepped:Connect(function(dt)
		ringGrad.Rotation = (ringGrad.Rotation + dt * 90) % 360
	end)

	Tween(card, 0.4, { GroupTransparency = 0 })
	Tween(cardScale, 0.5, { Scale = 1 }, Enum.EasingStyle.Back)

	while not done do task.wait(0.2) end
	pcall(function() moveConn:Disconnect() endConn:Disconnect() spinConn:Disconnect() end)
	Tween(card, 0.25, { GroupTransparency = 1 })
	Tween(cardScale, 0.25, { Scale = 0.95 })
	task.wait(0.3)
	pcall(function() gui:Destroy() end)
	return passed
end

if not askKey() then return end

local splash = showSplash("Loading " .. match.name .. "...")
local splashAt = os.clock()

--================ download and run ================--
-- a short random wait so a lot of players loading at once do not all hit GitHub in the same moment
task.wait(math.random() * 0.8)

splash.setText("Downloading the script...")
local source
for attempt = 1, 2 do
	local ok, body = pcall(game.HttpGet, game, RAW .. match.file .. ".lua")
	if ok and type(body) == "string" and #body > 100 then
		source = body
		break
	end
	task.wait(1)
end
if not source then
	splash.close()
	notify("Could not download the script. Check your internet and try again.")
	return
end

splash.setText("Starting...")
local fn, err = loadstring(source)
if not fn then
	splash.close()
	notify("The script could not start on this executor.")
	warn("[Eynch Hub] " .. tostring(err))
	return
end

if getgenv then getgenv().EynchHubLoaded = game.JobId end
-- keep the card up for at least 2.5 seconds so the logo and the Discord button can be seen and used
local left = 2.5 - (os.clock() - splashAt)
if left > 0 then task.wait(left) end
splash.close()
local ok, runErr = pcall(fn)
if not ok then
	if getgenv then getgenv().EynchHubLoaded = nil end
	notify("The script stopped with an error.")
	warn("[Eynch Hub] " .. tostring(runErr))
end
