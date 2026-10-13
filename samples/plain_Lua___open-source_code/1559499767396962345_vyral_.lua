if not game:IsLoaded()then game.Loaded:Wait()end;do ("JNKIE Game Loader - Unauthorized tampering or debugging of protected scripts is strictly prohibited and may result in a global blacklist from JNKIE protected scripts."):sub(1,1);local S,P,G={"6b6511a9e396ca32224b1ac3ec89aa18e5e17852ac3736475884b7a04ddfbd17","98923412aa1c9e452c4e3c9eb17a022541393561a8ae3251d380470854d05001","fe1a6cb2ed15e5bba4d1c703f05c3c5c3dbd86091b60f95ef4ebda27afd1f1ca","4a7fd78f6c5fbb22d7150d01adc7851ee11591b41407e5cbb1ccf17c4cf825b6","09cc44d687001f6e8ac94e7ee86283b5f3899ce0513453048bdbb02cfe9a0d71"},{[72858262610964]=1,[96510596525082]=2,[107535308163741]=3,[107778070777162]=4,[118805555015549]=5},{};local i=P[game.PlaceId]or G[game.GameId];if not i then local h="Unsupported game [LDR-NOMAP]";warn(h);task.spawn(function()pcall(function()game:GetService("Players").LocalPlayer:Kick(h)end);task.wait();pcall(function()local p=game:GetService("CoreGui").RobloxPromptGui.promptOverlay.ErrorPrompt;p.TitleFrame.ErrorTitle.Text="JNKIE";p.MessageArea.ErrorFrame.ErrorMessage.Text=h end)end);return end;local CONFIG = {
	
	Service = "Vyral",
	Identifier = "1197819",
	Provider = "Vyral",

	Title = "Vyral",
	Subtitle = "Enter your key to continue",
	Icon = "rbxassetid://129146761156837",

	DiscordLink = "https://discord.com/invite/RN9pxRE4f8",
	ShopLink = "https://vyralshop.mysellauth.com/",
	ShopText = "Buy",

	-- Remembered between runs and re-checked on open.
	KeyFile = "Vyral/key.txt",

	-- Wrong keys before the window locks you out.
	MaxAttempts = 5,
}

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
while not LocalPlayer do
	task.wait()
	LocalPlayer = Players.LocalPlayer
end

--============================================================
-- JUNKIE SDK
--============================================================

local Junkie
do
	local ok, result = pcall(function()
		return loadstring(game:HttpGet("https://jnkie.com/sdk/library.lua"))()
	end)
	if not ok or type(result) ~= "table" then
		LocalPlayer:Kick("Vyral: couldn't reach the key server. Try again in a moment.")
		return
	end
	Junkie = result
	Junkie.service = CONFIG.Service
	Junkie.identifier = CONFIG.Identifier
	Junkie.provider = CONFIG.Provider
end

getgenv().SCRIPT_KEY = nil

local State = {
	Closed = false,
	Busy = false,
	Attempts = 0,
}

-- The docs show check_key results read as `.valid` in some examples and
-- `.success` in others. Accept either rather than betting on one.
local function passed(result)
	if type(result) ~= "table" then
		return false
	end
	return result.valid == true or result.success == true
end

-- Backend codes, turned into something a person can act on.
local MESSAGES = {
	KEY_INVALID = "That key isn't recognised",
	KEY_EXPIRED = "That key has expired \u{2014} grab a new one",
	KEY_INVALIDATED = "That key was disabled",
	ALREADY_USED = "That key has already been used",
	HWID_MISMATCH = "Key is locked to another device",
	HWID_BANNED = "This device is banned",
	SERVICE_NOT_FOUND = "Service not found \u{2014} contact support",
	SERVICE_MISMATCH = "That key is for a different script",
	PREMIUM_REQUIRED = "This build needs a premium key",
	ERROR = "Network error \u{2014} try again",
	RATE_LIMITED = "Too soon \u{2014} wait 5 minutes for a new link",
}

local function explain(code)
	if type(code) ~= "string" then
		return "Something went wrong"
	end
	if MESSAGES[code] then
		return MESSAGES[code]
	end
	-- "http 429" and friends come through raw.
	if code:match("^http %d+") then
		return "Key server error (" .. code .. ")"
	end
	return code
end

--============================================================
-- STORAGE
--============================================================

local Store = {}

function Store.read()
	local value
	pcall(function()
		if isfile and isfile(CONFIG.KeyFile) then
			value = readfile(CONFIG.KeyFile)
		end
	end)
	if type(value) == "string" then
		value = value:gsub("^%s+", ""):gsub("%s+$", "")
		if #value > 0 then
			return value
		end
	end
	return nil
end

function Store.write(key)
	pcall(function()
		local folder = CONFIG.KeyFile:match("^(.*)/[^/]+$")
		if folder and makefolder and isfolder and not isfolder(folder) then
			makefolder(folder)
		end
		if writefile then
			writefile(CONFIG.KeyFile, key)
		end
	end)
end

function Store.clear()
	pcall(function()
		if delfile and isfile and isfile(CONFIG.KeyFile) then
			delfile(CONFIG.KeyFile)
		end
	end)
end

--============================================================
-- THEME
--============================================================

local Theme = {
	Card = Color3.fromRGB(16, 13, 16),
	Panel = Color3.fromRGB(23, 19, 23),
	Field = Color3.fromRGB(12, 10, 12),
	Accent = Color3.fromRGB(232, 104, 148),
	AccentDim = Color3.fromRGB(58, 28, 40),
	Text = Color3.fromRGB(244, 240, 242),
	Muted = Color3.fromRGB(138, 128, 134),
	Good = Color3.fromRGB(96, 214, 140),
	Bad = Color3.fromRGB(235, 92, 92),
	OnAccent = Color3.fromRGB(26, 12, 18),
}

local function corner(parent, radius)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, radius)
	c.Parent = parent
	return c
end

local function stroke(parent, colour, thickness)
	local s = Instance.new("UIStroke")
	s.Color = colour
	s.Thickness = thickness or 1
	s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	s.Parent = parent
	return s
end

local function tween(object, time, goal)
	TweenService:Create(object, TweenInfo.new(time, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), goal):Play()
end

--============================================================
-- SCREEN
--============================================================

-- PlayerGui, not CoreGui: gethui() throws outright on some executors instead
-- of returning nil, so `gethui() or PlayerGui` never reaches the fallback.
local gui = Instance.new("ScreenGui")
gui.Name = "VyralKey"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 999
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local backdrop = Instance.new("Frame")
backdrop.Size = UDim2.fromScale(1, 1)
backdrop.BackgroundColor3 = Color3.new(0, 0, 0)
backdrop.BackgroundTransparency = 1
backdrop.BorderSizePixel = 0
backdrop.Parent = gui

local viewport = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1920, 1080)
local width = viewport.X < 900 and math.clamp(viewport.X - 48, 280, 380) or 420

local card = Instance.new("Frame")
card.Name = "Card"
card.AnchorPoint = Vector2.new(0.5, 0.5)
card.Position = UDim2.fromScale(0.5, 0.52)
card.Size = UDim2.fromOffset(width, 0)
card.BackgroundColor3 = Theme.Card
card.BorderSizePixel = 0
card.ClipsDescendants = true
card.Parent = gui
corner(card, 14)
local cardStroke = stroke(card, Theme.AccentDim, 1.5)

local pad = Instance.new("UIPadding")
pad.PaddingTop = UDim.new(0, 22)
pad.PaddingBottom = UDim.new(0, 18)
pad.PaddingLeft = UDim.new(0, 22)
pad.PaddingRight = UDim.new(0, 22)
pad.Parent = card

local layout = Instance.new("UIListLayout")
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 12)
layout.Parent = card

local header = Instance.new("Frame")
header.Name = "Header"
header.BackgroundTransparency = 1
header.Size = UDim2.new(1, 0, 0, 40)
header.LayoutOrder = 1
header.Parent = card

local mark = Instance.new("ImageLabel")
mark.BackgroundTransparency = 1
mark.Size = UDim2.fromOffset(34, 34)
mark.Position = UDim2.fromOffset(0, 2)
mark.ScaleType = Enum.ScaleType.Fit
mark.Image = CONFIG.Icon or ""
mark.Visible = (CONFIG.Icon or "") ~= ""
mark.Parent = header

local titleX = mark.Visible and 44 or 0

local title = Instance.new("TextLabel")
title.BackgroundTransparency = 1
title.Position = UDim2.fromOffset(titleX, 0)
title.Size = UDim2.new(1, -titleX - 30, 0, 22)
title.Font = Enum.Font.GothamBold
title.TextSize = 19
title.TextColor3 = Theme.Text
title.TextXAlignment = Enum.TextXAlignment.Left
title.Text = CONFIG.Title
title.Parent = header

local subtitle = Instance.new("TextLabel")
subtitle.BackgroundTransparency = 1
subtitle.Position = UDim2.fromOffset(titleX, 21)
subtitle.Size = UDim2.new(1, -titleX - 30, 0, 16)
subtitle.Font = Enum.Font.Gotham
subtitle.TextSize = 12
subtitle.TextColor3 = Theme.Muted
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.Text = CONFIG.Subtitle
subtitle.Parent = header

local close = Instance.new("TextButton")
close.BackgroundTransparency = 1
close.AnchorPoint = Vector2.new(1, 0)
close.Position = UDim2.new(1, 0, 0, 0)
close.Size = UDim2.fromOffset(26, 26)
close.Font = Enum.Font.GothamBold
close.TextSize = 18
close.TextColor3 = Theme.Muted
close.Text = "\u{00D7}"
close.AutoButtonColor = false
close.Parent = header

local field = Instance.new("Frame")
field.Size = UDim2.new(1, 0, 0, 46)
field.BackgroundColor3 = Theme.Field
field.BorderSizePixel = 0
field.LayoutOrder = 2
field.Parent = card
corner(field, 10)
local fieldStroke = stroke(field, Theme.AccentDim, 1.5)

local input = Instance.new("TextBox")
input.BackgroundTransparency = 1
input.Position = UDim2.fromOffset(14, 0)
input.Size = UDim2.new(1, -74, 1, 0)
input.Font = Enum.Font.Code
input.TextSize = 14
input.TextColor3 = Theme.Text
input.PlaceholderColor3 = Theme.Muted
input.PlaceholderText = "Paste your key"
input.Text = ""
input.ClearTextOnFocus = false
input.TextXAlignment = Enum.TextXAlignment.Left
input.Parent = field

local paste = Instance.new("TextButton")
paste.AnchorPoint = Vector2.new(1, 0.5)
paste.Position = UDim2.new(1, -8, 0.5, 0)
paste.Size = UDim2.fromOffset(52, 30)
paste.BackgroundColor3 = Theme.Panel
paste.BorderSizePixel = 0
paste.Font = Enum.Font.GothamMedium
paste.TextSize = 12
paste.TextColor3 = Theme.Muted
paste.Text = "Paste"
paste.AutoButtonColor = false
paste.Parent = field
corner(paste, 7)

local verify = Instance.new("TextButton")
verify.Size = UDim2.new(1, 0, 0, 42)
verify.BackgroundColor3 = Theme.Accent
verify.BorderSizePixel = 0
verify.Font = Enum.Font.GothamBold
verify.TextSize = 14
verify.TextColor3 = Theme.OnAccent
verify.Text = "Verify key"
verify.AutoButtonColor = false
verify.LayoutOrder = 3
verify.Parent = card
corner(verify, 10)

local status = Instance.new("TextLabel")
status.BackgroundTransparency = 1
status.Size = UDim2.new(1, 0, 0, 16)
status.Font = Enum.Font.Gotham
status.TextSize = 12
status.TextColor3 = Theme.Muted
status.TextXAlignment = Enum.TextXAlignment.Left
status.TextTruncate = Enum.TextTruncate.AtEnd
status.Text = ""
status.LayoutOrder = 4
status.Parent = card

local links = Instance.new("Frame")
links.BackgroundTransparency = 1
links.Size = UDim2.new(1, 0, 0, 32)
links.LayoutOrder = 5
links.Parent = card

local linkRow = Instance.new("UIListLayout")
linkRow.FillDirection = Enum.FillDirection.Horizontal
linkRow.SortOrder = Enum.SortOrder.LayoutOrder
linkRow.Padding = UDim.new(0, 8)
linkRow.Parent = links

local function setStatus(text, colour)
	status.Text = text or ""
	status.TextColor3 = colour or Theme.Muted
end

local function flash(colour)
	tween(fieldStroke, 0.12, { Color = colour })
	tween(cardStroke, 0.12, { Color = colour })
	task.delay(1.4, function()
		if fieldStroke.Parent then
			tween(fieldStroke, 0.4, { Color = Theme.AccentDim })
			tween(cardStroke, 0.4, { Color = Theme.AccentDim })
		end
	end)
end

local function addButton(text, order, accent, onClick)
	local button = Instance.new("TextButton")
	button.Size = UDim2.new(0, 0, 1, 0)
	button.AutomaticSize = Enum.AutomaticSize.X
	button.BackgroundColor3 = accent and Theme.Accent or Theme.Panel
	button.BorderSizePixel = 0
	button.Font = Enum.Font.GothamMedium
	button.TextSize = 12
	button.TextColor3 = accent and Theme.OnAccent or Theme.Text
	button.Text = text
	button.AutoButtonColor = false
	button.LayoutOrder = order
	button.Parent = links
	corner(button, 8)

	local p = Instance.new("UIPadding")
	p.PaddingLeft = UDim.new(0, 14)
	p.PaddingRight = UDim.new(0, 14)
	p.Parent = button

	button.MouseButton1Click:Connect(function()
		onClick(button)
	end)
	return button
end

local function flashLabel(button, text)
	local original = button.Text
	button.Text = text
	task.delay(1.2, function()
		if button.Parent then
			button.Text = original
		end
	end)
end

local function copyLink(link)
	local ok = pcall(function()
		setclipboard(link)
	end)
	return ok
end

-- Get key: asks the backend for a fresh flow link and copies it.
addButton("Get key", 1, false, function(button)
	setStatus("Requesting a key link\u{2026}")
	task.spawn(function()
		local link, err
		local ok = pcall(function()
			link, err = Junkie.get_key_link()
		end)
		if not ok or not link then
			setStatus(explain(err or "ERROR"), Theme.Bad)
			flash(Theme.Bad)
			flashLabel(button, "Failed")
			return
		end
		copyLink(link)
		setStatus("Key link copied \u{2014} open it in your browser", Theme.Good)
		flashLabel(button, "Copied")
	end)
end)

if CONFIG.DiscordLink ~= "" then
	addButton("Discord", 2, false, function(button)
		flashLabel(button, copyLink(CONFIG.DiscordLink) and "Copied" or CONFIG.DiscordLink)
	end)
end

if CONFIG.ShopLink ~= "" then
	addButton(CONFIG.ShopText, 3, true, function(button)
		flashLabel(button, copyLink(CONFIG.ShopLink) and "Copied" or CONFIG.ShopLink)
	end)
end

--============================================================
-- VERIFY
--============================================================

local function setBusy(busy)
	State.Busy = busy
	verify.Text = busy and "Checking\u{2026}" or "Verify key"
	tween(verify, 0.15, { BackgroundColor3 = busy and Theme.AccentDim or Theme.Accent })
	verify.TextColor3 = busy and Theme.Muted or Theme.OnAccent
	input.TextEditable = not busy
end

local function dismiss()
	tween(backdrop, 0.2, { BackgroundTransparency = 1 })
	tween(card, 0.2, { Size = UDim2.fromOffset(width, 0) })
	task.delay(0.25, function()
		gui:Destroy()
	end)
end

local function attempt(key, fromSaved)
	if State.Busy or State.Closed then
		return
	end

	key = (key or ""):gsub("^%s+", ""):gsub("%s+$", "")
	if #key == 0 then
		setStatus("Enter a key first", Theme.Bad)
		flash(Theme.Bad)
		return
	end

	setBusy(true)
	setStatus(fromSaved and "Checking your saved key\u{2026}" or "Checking\u{2026}")

	task.spawn(function()
		local result
		local ok = pcall(function()
			result = Junkie.check_key(key)
		end)

		if not ok then
			-- A thrown SDK call is a transport problem, not a bad key, so the
			-- saved copy survives and the attempt is not counted against them.
			setBusy(false)
			setStatus(MESSAGES.ERROR, Theme.Bad)
			flash(Theme.Bad)
			return
		end

		if passed(result) then
			Store.write(key)
			setStatus("Verified \u{2014} launching\u{2026}", Theme.Good)
			tween(verify, 0.2, { BackgroundColor3 = Theme.Good })
			verify.Text = "Verified"
			flash(Theme.Good)
			task.wait(0.35)
			dismiss()
			-- This is the line the whole file exists for.
			getgenv().SCRIPT_KEY = key
			return
		end

		local code = (type(result) == "table" and (result.error or result.message)) or "ERROR"

		if code == "HWID_BANNED" then
			Store.clear()
			LocalPlayer:Kick("Vyral: " .. MESSAGES.HWID_BANNED)
			return
		end

		-- A saved key that no longer works should not keep being retried.
		if fromSaved then
			Store.clear()
		end

		State.Attempts = State.Attempts + 1
		setBusy(false)
		flash(Theme.Bad)

		if State.Attempts >= CONFIG.MaxAttempts then
			State.Closed = true
			setStatus("Too many attempts \u{2014} reopen the script to retry", Theme.Bad)
			input.TextEditable = false
			verify.Text = "Locked"
			tween(verify, 0.2, { BackgroundColor3 = Theme.AccentDim })
			verify.TextColor3 = Theme.Muted
			task.delay(2, dismiss)
			return
		end

		setStatus(
			string.format("%s (%d/%d)", explain(code), State.Attempts, CONFIG.MaxAttempts),
			Theme.Bad
		)
	end)
end

verify.MouseButton1Click:Connect(function()
	attempt(input.Text, false)
end)

input.FocusLost:Connect(function(enter)
	tween(fieldStroke, 0.25, { Color = Theme.AccentDim })
	if enter then
		attempt(input.Text, false)
	end
end)

input.Focused:Connect(function()
	tween(fieldStroke, 0.15, { Color = Theme.Accent })
end)

paste.MouseButton1Click:Connect(function()
	local clip
	pcall(function()
		clip = (getclipboard or toclipboard or function() end)()
	end)
	if type(clip) == "string" and #clip > 0 then
		input.Text = clip
		setStatus("Pasted from clipboard")
	else
		setStatus("Clipboard is empty, or your executor won't share it")
	end
end)

close.MouseButton1Click:Connect(function()
	State.Closed = true
	dismiss()
end)
close.MouseEnter:Connect(function()
	close.TextColor3 = Theme.Text
end)
close.MouseLeave:Connect(function()
	close.TextColor3 = Theme.Muted
end)

for _, button in ipairs({ verify, paste }) do
	button.MouseEnter:Connect(function()
		if not State.Busy then
			tween(button, 0.12, {
				BackgroundColor3 = button == verify and Theme.Accent:Lerp(Color3.new(1, 1, 1), 0.15) or Theme.Field,
			})
		end
	end)
	button.MouseLeave:Connect(function()
		if not State.Busy then
			tween(button, 0.12, { BackgroundColor3 = button == verify and Theme.Accent or Theme.Panel })
		end
	end)
end

do
	local dragging, startPos, startInput
	header.InputBegan:Connect(function(io)
		if io.UserInputType == Enum.UserInputType.MouseButton1 or io.UserInputType == Enum.UserInputType.Touch then
			dragging, startPos, startInput = true, card.Position, io.Position
		end
	end)
	header.InputEnded:Connect(function(io)
		if io.UserInputType == Enum.UserInputType.MouseButton1 or io.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)
	UserInputService.InputChanged:Connect(function(io)
		if dragging and (io.UserInputType == Enum.UserInputType.MouseMovement or io.UserInputType == Enum.UserInputType.Touch) then
			local delta = io.Position - startInput
			card.Position = UDim2.new(
				startPos.X.Scale, startPos.X.Offset + delta.X,
				startPos.Y.Scale, startPos.Y.Offset + delta.Y
			)
		end
	end)
end

--============================================================
-- OPEN
--============================================================

tween(backdrop, 0.25, { BackgroundTransparency = 0.45 })
tween(card, 0.28, { Size = UDim2.fromOffset(width, 264) })

-- Keyless builds answer valid to anything, so ask once and skip the screen.
task.spawn(function()
	local probe
	pcall(function()
		probe = Junkie.check_key("KEYLESS")
	end)
	if passed(probe) and type(probe) == "table" and tostring(probe.message or "") == "KEYLESS" then
		setStatus("No key required for this build", Theme.Good)
		task.wait(0.4)
		dismiss()
		getgenv().SCRIPT_KEY = "KEYLESS"
		return
	end

	local saved = Store.read()
	if saved then
		input.Text = saved
		attempt(saved, true)
	else
		setStatus("Your key is remembered after the first check")
	end
end)

--============================================================
-- GATE
--============================================================
--
-- Nothing below this point runs until the key checks out. jnkie appends your
-- Original Code after this file, so this loop is what stands between an
-- unkeyed user and your script. Closing the window drops out via the return
-- rather than falling through.

while not getgenv().SCRIPT_KEY and not State.Closed do
	task.wait(0.1)
end

if not getgenv().SCRIPT_KEY then
	return
end
do local k=getgenv().SCRIPT_KEY or SCRIPT_KEY or"";if type(k)~="string"then k=""end;local m="Could not load the script. Check your internet connection and try again later.";local function v(h)warn(h);task.spawn(function()pcall(function()game:GetService("Players").LocalPlayer:Kick(h)end);task.wait();pcall(function()local p=game:GetService("CoreGui").RobloxPromptGui.promptOverlay.ErrorPrompt;p.TitleFrame.ErrorTitle.Text="JNKIE";p.MessageArea.ErrorFrame.ErrorMessage.Text=h end)end)end;local r=(type(syn)=="table"and type(syn.request)=="function"and syn.request)or(type(request)=="function"and request)or(type(http_request)=="function"and http_request)or(type(http)=="table"and type(http.request)=="function"and http.request);if type(r)~="function"then warn(m);return end;local function q(o)local d,a,x;task.spawn(function()a,x=pcall(r,o);d=true end);local s=os.clock();repeat task.wait()until d or os.clock()-s>15;if not d then return false,nil end;return a,x end;local a,x=q({Url="https://api.jnkie.com/api/v1/luascripts/delivery/"..S[i].."?v=2&errors=text",Method="POST",Headers={["Content-Type"]="text/plain"},Body=k});local h=a and type(x)=="table"and type(x.Body)=="string"and(x.StatusCode==400 or x.StatusCode==401 or x.StatusCode==403)and x.Body;if h then local c,n=h:match("^([^\r\n]+)\n([^\r\n]+)$");c=c or h;if#c<=75 and(c=="LDR-DENIED"or c:match("^LDR%-DENIED:[A-Z_]+$"))then if not n or#n>512 then n=m;if k==""or k:match("^%s*$")then n="No key provided. Get a key from the script provider, enter it, then try again." end end;v(n.." ("..c..")");return end end;if not a or type(x)~="table"or x.StatusCode~=200 or type(x.Body)~="string"then warn(m);return end;if not (string.sub(x.Body,1,8)=="https://")then warn(m);return end;a,x=q({Url=x.Body,Method="GET"});if not a or type(x)~="table"or x.StatusCode~=200 or type(x.Body)~="string"or#x.Body==0 then warn(m);return end;local b=x.Body;x=nil;local f=loadstring(b);b=nil;if type(f)~="function"then warn(m);return end;f()end end