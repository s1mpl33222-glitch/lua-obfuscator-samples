-- ================================
--         EDIT THIS SECTION
-- ================================
if getgenv().Starhook_Is_In_LoadMain or getgenv().XFent_Is_In_LoadMain then
	warn("[STARHOOK] Loader loop blocked. Make sure the JNKIe dashboard serves the main script after validation.")
	return
end
getgenv().LOAD = false

local Config = {
	Brand          = "Starhook",
	-- Must match the existing JNKIe dashboard service; branding stays Starhook.
	Service        = "XFent",
	Identifier     = "1056672",
	Provider       = "XFent",
	MaxKeyAttempts = 5,
	KeyFile        = "XFentNewHub.txt",
	LegacyKeyFile  = "StarhookKey.txt",
	Discord        = "WAJWzXt2MH",
	Website        = "https://starhook.mysellauth.com",
	KeyUrl         = "https://jnkie.com/get-key/starhook",
	WhiteStarImage = "rbxassetid://126261214665847",
	PurpleStarImage = "rbxassetid://136036184796327",
	GameSupport = {
	Universal = {
		Name    = "",
		Free    = "",
		Premium = "",
	},
	},
}

local Colors = {
	Overlay = Color3.fromRGB(2, 2, 3),
	Panel   = Color3.fromRGB(11, 11, 13),
	Panel2  = Color3.fromRGB(18, 18, 21),
	Input   = Color3.fromRGB(7, 7, 9),
	Line    = Color3.fromRGB(38, 38, 43),
	Red     = Color3.fromRGB(255, 72, 96),
	Accent  = Color3.fromRGB(158, 92, 255),
	Text    = Color3.fromRGB(245, 245, 245),
	Muted   = Color3.fromRGB(145, 145, 152),
	Dim     = Color3.fromRGB(82, 82, 90),
	Green   = Color3.fromRGB(95, 220, 125),
	Yellow  = Color3.fromRGB(235, 195, 85),
}

local Customization = {
	-- [[ INTRO & PANEL TEXTS ]] --
	PanelTitle1  = "STAR",
	PanelTitle2  = "HOOK",
	PanelSub     = "",
	
	-- [[ THEME COLORS ]] --
	ThemeColor   = Colors.Accent,
	
	-- [[ MAIN STATUS & INPUT TEXTS ]] --
	StatusReady     = "",
	StatusWait      = "",
	PlaceholderText = "Paste your Starhook key...",
	
	-- [[ BUTTON TEXTS ]] --
	RedeemButton = "UNLOCK",
	GetKeyButton = "GET KEY",
	
	-- [[ NOTIFICATIONS ]] --
	NotifSystem  = "Starhook",
	NotifLoading = "Loading",
	NotifSuccess = "Access granted",
	NotifError   = "Invalid key",
	
	MsgKeyFound  = "Saved key filled in. Press UNLOCK.",
	MsgKeyValid  = "Welcome back. Launching Starhook...",
	MsgNoKey     = "Enter a key to continue.",
	
	ColorSuccess = Colors.Green,
	ColorError   = Colors.Red,
	ColorSystem  = Colors.Yellow,
	ColorDim     = Colors.Accent,
	
	-- [[ COPY BUTTONS ]] --
	CopyKeyLink  = Config.KeyUrl,
	CopyDiscord  = "discord.gg/" .. Config.Discord,
	CopyWebsite  = Config.Website,
	
	MsgCopiedDiscord = "Discord invite copied",
	MsgCopiedWebsite = "Starhook website copied",
	MsgCopiedKeyLink = "Key link copied",
}

-- Intro timing (seconds)
local SLIDE_IN_TIME  = 0.35  -- logo reveal
local HOLD_TIME      = 0.12  -- pause at center before blowup
local BLOWUP_TIME    = 0.30  -- scale up + fade out
local PANEL_DELAY    = 0.05  -- gap before panel appears
local PANEL_TIME     = 0.28  -- panel slide-in
-- ================================
--       DO NOT EDIT BELOW
-- ================================

local Players          = game:GetService("Players")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting         = game:GetService("Lighting")
local LocalPlayer      = Players.LocalPlayer
local PlayerGui        = LocalPlayer:WaitForChild("PlayerGui")

local function cleanupKeyUI()
	for _, c in ipairs(PlayerGui:GetChildren()) do
		if c.Name == "StarhookKeySystem" or c.Name == "StarhookNotificationsGui"
			or c.Name == "XFentKeySystem" or c.Name == "XFentJunkieClean"
			or c.Name == "XFentJunkieOverlay" or c.Name == "XFentCustomTerminal"
			or c.Name == "XFentTestKeyUI" then
			pcall(c.Destroy, c)
		end
	end
	for _, blurName in ipairs({"StarhookKeyBlur", "XFentKeyBlur"}) do
		local b = Lighting:FindFirstChild(blurName)
		if b then pcall(b.Destroy, b) end
	end
end

local function Notify(title, text, duration, color)
	duration = duration or 3
	color = color or Colors.Accent

	local NotifGui = PlayerGui:FindFirstChild("StarhookNotificationsGui")
	if not NotifGui then
		NotifGui = Instance.new("ScreenGui")
		NotifGui.Name = "StarhookNotificationsGui"
		NotifGui.ResetOnSpawn = false
		NotifGui.DisplayOrder = 1000
		NotifGui.Parent = PlayerGui

		local NotifContainer = Instance.new("Frame")
		NotifContainer.Name = "Container"
		NotifContainer.Size = UDim2.new(0, 232, 1, -16)
		NotifContainer.Position = UDim2.new(1, -246, 0, 0)
		NotifContainer.BackgroundTransparency = 1
		NotifContainer.Parent = NotifGui

		local UIListLayout = Instance.new("UIListLayout")
		UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
		UIListLayout.Padding = UDim.new(0, 5)
		UIListLayout.Parent = NotifContainer
	end

	local container = NotifGui.Container
	local hasMessage = tostring(text or "") ~= ""
	local notificationHeight = hasMessage and 46 or 38

	local wrapper = Instance.new("Frame")
	wrapper.Size = UDim2.new(1, 0, 0, notificationHeight)
	wrapper.BackgroundTransparency = 1
	wrapper.Parent = container

	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, 0, 1, 0)
	frame.Position = UDim2.new(1.15, 0, 0, 0)
	frame.BackgroundTransparency = 1
	frame.BackgroundColor3 = Colors.Panel
	frame.BorderSizePixel = 0
	frame.ClipsDescendants = true
	frame.Parent = wrapper
	local frameCorner = Instance.new("UICorner")
	frameCorner.CornerRadius = UDim.new(0, 0)
	frameCorner.Parent = frame

	local border = Instance.new("UIStroke")
	border.Color = Colors.Line
	border.Thickness = 1
	border.Transparency = 1
	border.Parent = frame

	local logo = Instance.new("ImageLabel")
	logo.Size = UDim2.fromOffset(22, 22)
	logo.Position = UDim2.new(0, 9, 0.5, -11)
	logo.BackgroundTransparency = 1
	logo.Image = "rbxassetid://132713336875542"
	logo.ImageTransparency = 1
	logo.ScaleType = Enum.ScaleType.Fit
	logo.Parent = frame

	local titleLbl = Instance.new("TextLabel")
	titleLbl.BackgroundTransparency = 1
	titleLbl.Position = hasMessage and UDim2.new(0, 40, 0, 6) or UDim2.new(0, 40, 0.5, -8)
	titleLbl.Size = UDim2.new(1, -52, 0, 16)
	titleLbl.Text = tostring(title)
	titleLbl.TextColor3 = Colors.Text
	titleLbl.TextSize = 10
	titleLbl.Font = Enum.Font.GothamBold
	titleLbl.TextXAlignment = Enum.TextXAlignment.Left
	titleLbl.TextTransparency = 1
	titleLbl.Parent = frame

	local textLbl = Instance.new("TextLabel")
	textLbl.BackgroundTransparency = 1
	textLbl.Position = UDim2.new(0, 40, 0, 22)
	textLbl.Size = UDim2.new(1, -52, 0, 15)
	textLbl.Text = tostring(text or "")
	textLbl.TextColor3 = Colors.Muted
	textLbl.TextSize = 9
	textLbl.Font = Enum.Font.GothamMedium
	textLbl.TextXAlignment = Enum.TextXAlignment.Left
	textLbl.TextTransparency = 1
	textLbl.TextTruncate = Enum.TextTruncate.AtEnd
	textLbl.Visible = hasMessage
	textLbl.Parent = frame

	local timerTrack = Instance.new("Frame")
	timerTrack.Size = UDim2.new(1, -12, 0, 1)
	timerTrack.Position = UDim2.new(0, 6, 1, -2)
	timerTrack.BackgroundColor3 = Colors.Panel2
	timerTrack.BorderSizePixel = 0
	timerTrack.Parent = frame
	local timerFill = Instance.new("Frame")
	timerFill.Size = UDim2.fromScale(1, 1)
	timerFill.BackgroundColor3 = color
	timerFill.BorderSizePixel = 0
	timerFill.Parent = timerTrack

	local enterInfo = TweenInfo.new(0.26, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
	TweenService:Create(frame, enterInfo, {Position = UDim2.fromScale(0, 0), BackgroundTransparency = 0.08}):Play()
	TweenService:Create(border, enterInfo, {Transparency = 0.48}):Play()
	TweenService:Create(logo, enterInfo, {ImageTransparency = 0.03}):Play()
	TweenService:Create(titleLbl, enterInfo, {TextTransparency = 0}):Play()
	TweenService:Create(textLbl, enterInfo, {TextTransparency = 0}):Play()
	task.delay(0.26, function()
		if timerFill.Parent then
			TweenService:Create(timerFill, TweenInfo.new(math.max(0.1, duration - 0.26), Enum.EasingStyle.Linear), {Size = UDim2.new(0, 0, 1, 0)}):Play()
		end
	end)

	task.spawn(function()
		task.wait(duration)
		local exitInfo = TweenInfo.new(0.26, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
		TweenService:Create(frame, exitInfo, {Position = UDim2.new(1.15, 0, 0, 0), BackgroundTransparency = 1}):Play()
		TweenService:Create(border, exitInfo, {Transparency = 1}):Play()
		TweenService:Create(logo, exitInfo, {ImageTransparency = 1}):Play()
		TweenService:Create(titleLbl, exitInfo, {TextTransparency = 1}):Play()
		TweenService:Create(textLbl, exitInfo, {TextTransparency = 1}):Play()
		task.wait(0.28)
		wrapper:Destroy()
	end)
end

local uiClosed = false

local function hasFS()
	return type(writefile) == "function"
		and type(readfile) == "function"
		and type(isfile) == "function"
end
local fsOk = hasFS()

local function saveKey(k)  if not fsOk then return end pcall(function() writefile(Config.KeyFile, k) end) end
local function loadKey()
	if not fsOk then return nil end
	for _, fileName in ipairs({Config.KeyFile, Config.LegacyKeyFile}) do
		local ok, value = pcall(function()
			if isfile(fileName) then return readfile(fileName) end
		end)
		if ok and type(value) == "string" then
			value = value:match("^%s*(.-)%s*$")
			if value ~= "" then
				if fileName ~= Config.KeyFile then saveKey(value) end
				return value
			end
		end
	end
	return nil
end

local function getScript()
	local fallback = Config.GameSupport.Universal and Config.GameSupport.Universal.Free or ""
	
	for key, data in pairs(Config.GameSupport) do
		if key == game.PlaceId or key == game.GameId then
			return (data.Free and data.Free ~= "") and data.Free or fallback
		end
		if type(data) == "table" and type(data.Places) == "table" then
			if table.find(data.Places, game.PlaceId) or table.find(data.Places, game.GameId) then
				return (data.Free and data.Free ~= "") and data.Free or fallback
			end
		end
	end
	
	return fallback
end

local function loadMain() 
	local s = getScript() 
	if s == "" then return end

	task.spawn(function()
		task.wait(0.5)
		
		local ok, err = pcall(function()
			local url = s:match("https?://[%w%-_%.%?%.:/%+=&]+")
			if url and s:match("loadstring") then
				local code = game:HttpGet(url)
				local func, compileErr = loadstring(code)
				if not func then return error("Compile Error from URL: " .. tostring(compileErr)) end
				
				getgenv().Starhook_Is_In_LoadMain = true
				local ran, result = pcall(func)
				getgenv().Starhook_Is_In_LoadMain = false
				if not ran then error(result) end
				return result
			else
				local func, compileErr = loadstring(s)
				if not func then return error("Compile Error: " .. tostring(compileErr)) end
				
				getgenv().Starhook_Is_In_LoadMain = true
				local ran, result = pcall(func)
				getgenv().Starhook_Is_In_LoadMain = false
				if not ran then error(result) end
				return result
			end
		end)
		if not ok then
			warn("[STARHOOK] Main script failed: " .. tostring(err))
			Notify("Launch failed", "Please rerun Starhook and try again", 5, Colors.Red)
		end
	end)
end

local Junkie
local function getSDK()
	if Junkie then return Junkie end
	local sdk = loadstring(game:HttpGet("https://jnkie.com/sdk/library.lua"))()
	assert(type(sdk) == "table" and type(sdk.check_key) == "function", "Invalid JNKIe SDK")
	sdk.service = Config.Service
	sdk.identifier = Config.Identifier
	sdk.provider = Config.Provider
	Junkie = sdk
	return sdk
end

local function validateKey(key)
	key = tostring(key or ""):gsub("^%s+", ""):gsub("%s+$", "")
	if key == "" then return false, "Enter a key" end
	local ok, res = pcall(function() return getSDK().check_key(key) end)
	if uiClosed then return false, "Cancelled", false end
	if not ok or type(res) ~= "table" then return false, "Unable to reach JNKIe", false end
	
	if res and res.valid then
		getgenv().SCRIPT_KEY = res.message == "KEYLESS" and "KEYLESS" or key
		
		if res.message ~= "KEYLESS" then saveKey(key) end
		return true, "access granted"
	end
	
	local errStr = tostring(res.error or res.message or "Invalid key")
	local keyFailure = ({KEY_INVALID=true, KEY_EXPIRED=true, HWID_BANNED=true, KEY_INVALIDATED=true, ALREADY_USED=true, HWID_MISMATCH=true, SERVICE_MISMATCH=true, PREMIUM_REQUIRED=true})[errStr] == true
	local friendlyErrors = {
		KEY_INVALID = "Key not found",
		KEY_EXPIRED = "Key expired — get a new one",
		HWID_BANNED = "This device is banned",
		KEY_INVALIDATED = "Key has been disabled",
		ALREADY_USED = "One-time key already used",
		HWID_MISMATCH = "Device limit reached",
		SERVICE_NOT_FOUND = "Starhook service unavailable",
		SERVICE_MISMATCH = "Key belongs to another service",
		PREMIUM_REQUIRED = "Premium key required",
		ERROR = "Network error — try again",
	}
	errStr = friendlyErrors[errStr] or errStr
	
	return false, errStr, keyFailure
end

local skipUI = false
cleanupKeyUI()
local savedKey = loadKey()
if savedKey then
	Notify(Customization.NotifSystem, Customization.MsgKeyFound, 3, Customization.ColorSystem)
else
	Notify(Customization.NotifSystem, Customization.MsgNoKey, 2.5, Customization.ColorDim)
end

-- helpers
local function corner(p, r)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, r or 6)
	c.Parent = p
	return c
end
local function lbl(p, t, pos, sz, col, ts, f)
	local l = Instance.new("TextLabel") l.BackgroundTransparency = 1 l.Position = pos l.Size = sz l.Text = t
	l.TextColor3 = col or Colors.Text l.TextSize = ts or 14 l.Font = f or Enum.Font.GothamMedium
	l.TextXAlignment = Enum.TextXAlignment.Left l.TextYAlignment = Enum.TextYAlignment.Center
	l.TextTruncate = Enum.TextTruncate.AtEnd l.Parent = p return l
end
local function btn(p, t, pos, sz, bg, fg)
	local b = Instance.new("TextButton") b.Position = pos b.Size = sz b.BackgroundColor3 = bg or Colors.Panel2
	b.BorderSizePixel = 0 b.AutoButtonColor = false b.Text = t b.TextColor3 = fg or Colors.Text
	b.TextSize = 13 b.Font = Enum.Font.GothamMedium b.Parent = p corner(b, 4)
	b:SetAttribute("BaseR", b.BackgroundColor3.R) b:SetAttribute("BaseG", b.BackgroundColor3.G) b:SetAttribute("BaseB", b.BackgroundColor3.B)
	b.MouseEnter:Connect(function()
		if b:GetAttribute("Active") then return end
		local base = Color3.new(b:GetAttribute("BaseR"), b:GetAttribute("BaseG"), b:GetAttribute("BaseB"))
		TweenService:Create(b, TweenInfo.new(0.12), {BackgroundColor3 = base:Lerp(Colors.Text, 0.10)}):Play()
	end)
	b.MouseLeave:Connect(function() if b:GetAttribute("Active") then return end TweenService:Create(b, TweenInfo.new(0.16), {BackgroundColor3 = Color3.new(b:GetAttribute("BaseR"), b:GetAttribute("BaseG"), b:GetAttribute("BaseB"))}):Play() end)
	return b
end

if not skipUI then
	-- GUI root
	local gui = Instance.new("ScreenGui")
	gui.Name = "StarhookKeySystem" gui.ResetOnSpawn = false gui.IgnoreGuiInset = true
	gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling gui.DisplayOrder = 999 gui.Parent = PlayerGui
	local liveConnections = {}
	local function track(connection)
		table.insert(liveConnections, connection)
		return connection
	end

	local overlay = Instance.new("Frame")
	overlay.Size = UDim2.fromScale(1, 1) overlay.BackgroundColor3 = Colors.Overlay
	overlay.BackgroundTransparency = 1 overlay.BorderSizePixel = 0 overlay.Parent = gui

	local blur = Instance.new("BlurEffect")
	blur.Name = "StarhookKeyBlur" blur.Size = 0 blur.Parent = Lighting

	local function destroyInterface(cancelled)
		if cancelled then uiClosed = true end
		for _, connection in ipairs(liveConnections) do
			pcall(function() connection:Disconnect() end)
		end
		table.clear(liveConnections)
		if blur and blur.Parent then blur:Destroy() end
		if gui and gui.Parent then gui:Destroy() end
		getgenv().Starhook_KeySystem_Loaded = false
	end

	-- ========== INTRO ==========
	local LOGO_START = 64
	local LOGO_MID   = 112
	local LOGO_BIG   = 260

	local introLogo = Instance.new("ImageLabel")
	introLogo.Name = "StarhookIntroLogo"
	introLogo.BackgroundTransparency = 1
	introLogo.AnchorPoint = Vector2.new(0.5, 0.5)
	introLogo.Size = UDim2.fromOffset(LOGO_START, LOGO_START)
	introLogo.Position = UDim2.fromScale(0.5, 0.5)
	introLogo.Image = "rbxassetid://132713336875542"
	introLogo.ImageTransparency = 1
	introLogo.ScaleType = Enum.ScaleType.Fit
	introLogo.Rotation = -12
	introLogo.ZIndex = 10
	introLogo.Parent = overlay

	local easeOut = Enum.EasingStyle.Exponential

	local function emitParticles(pos)
		for i = 1, 16 do
			local p = Instance.new("ImageLabel")
			local particleSize = math.random(12, 22)
			p.Size = UDim2.fromOffset(particleSize, particleSize)
			p.BackgroundTransparency = 1
			p.Image = (i % 2 == 0) and Config.PurpleStarImage or Config.WhiteStarImage
			p.ImageTransparency = 0.05
			p.ScaleType = Enum.ScaleType.Fit
			p.Position = pos
			p.AnchorPoint = Vector2.new(0.5, 0.5)
			p.Parent = overlay
			local angle = math.rad(math.random(0, 360))
			local dist = math.random(50, 120)
			local endPos = UDim2.new(pos.X.Scale, pos.X.Offset + math.cos(angle)*dist, pos.Y.Scale, pos.Y.Offset + math.sin(angle)*dist)
			TweenService:Create(p, TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Position = endPos,
				ImageTransparency = 1,
				Size = UDim2.fromOffset(0, 0),
				Rotation = math.random(-180, 180)
			}):Play()
			task.delay(0.5, function() if p then p:Destroy() end end)
		end
	end

	local function runIntro(onDone)
		local tSlide = TweenInfo.new(SLIDE_IN_TIME, easeOut, Enum.EasingDirection.Out)
		TweenService:Create(introLogo, tSlide, {
			Size = UDim2.fromOffset(LOGO_MID, LOGO_MID),
			ImageTransparency = 0,
			Rotation = 0,
		}):Play()

		task.wait(SLIDE_IN_TIME + HOLD_TIME)
		if uiClosed or not gui.Parent then return end
		emitParticles(UDim2.new(0.5, 0, 0.5, 0))

		local tBlow = TweenInfo.new(BLOWUP_TIME, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		TweenService:Create(introLogo, tBlow, {
			Size = UDim2.fromOffset(LOGO_BIG, LOGO_BIG),
			ImageTransparency = 1,
			Rotation = 10,
		}):Play()
		TweenService:Create(blur, TweenInfo.new(BLOWUP_TIME, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = 0}):Play()
		task.wait(BLOWUP_TIME)
		if uiClosed or not gui.Parent then return end
		TweenService:Create(blur, TweenInfo.new(0.2), {Size = 0}):Play()
		introLogo:Destroy()
		task.wait(PANEL_DELAY)
		if not uiClosed and gui.Parent then onDone() end
	end

	-- ========== MAIN PANEL ==========
	local panel = Instance.new("Frame")
	panel.Size = UDim2.fromOffset(520, 300)
	panel.Position = UDim2.new(0.5, -260, 0.5, -120)
	panel.BackgroundColor3 = Colors.Panel
	panel.BackgroundTransparency = 1
	panel.BorderSizePixel = 0 panel.Active = true
	panel.Parent = overlay panel.Visible = false
	corner(panel, 3)

	local border = Instance.new("UIStroke") border.Color = Color3.new(1,1,1) border.Thickness = 1 border.Transparency = 0.18 border.Parent = panel
	local bgGrad = Instance.new("UIGradient") bgGrad.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Customization.ThemeColor), ColorSequenceKeypoint.new(0.5, Colors.Panel), ColorSequenceKeypoint.new(1, Customization.ThemeColor)}) bgGrad.Rotation = 0 bgGrad.Parent = border

	local shadow = Instance.new("ImageLabel")
	shadow.Name = "Shadow"
	shadow.AnchorPoint = Vector2.new(0.5, 0.5)
	shadow.Position = UDim2.new(0.5, 0, 0.5, 2)
	shadow.Size = UDim2.new(1, 45, 1, 45)
	shadow.BackgroundTransparency = 1
	shadow.Image = "rbxassetid://6015897843"
	shadow.ImageColor3 = Color3.new(0,0,0)
	shadow.ImageTransparency = 0.5
	shadow.ZIndex = -1
	shadow.Parent = panel

	local borderRotation = 0
	track(game:GetService("RunService").RenderStepped:Connect(function(dt)
		borderRotation = (borderRotation + dt * 16) % 360
		bgGrad.Rotation = borderRotation
	end))

	local top = Instance.new("Frame") top.Size = UDim2.new(1, 0, 0, 58) top.BackgroundTransparency = 1 top.BorderSizePixel = 0 top.Parent = panel
	local brandLogo = Instance.new("ImageLabel")
	brandLogo.Name = "StarhookLogo" brandLogo.Size = UDim2.fromOffset(50, 50)
	brandLogo.Position = UDim2.fromOffset(8, 4) brandLogo.BackgroundTransparency = 1
	brandLogo.Image = "rbxassetid://132713336875542" brandLogo.ScaleType = Enum.ScaleType.Fit
	brandLogo.Parent = top
	lbl(top, Customization.PanelTitle1, UDim2.new(0, 70, 0, 10), UDim2.new(0, 76, 0, 38), Colors.Text, 27, Enum.Font.GothamBlack)
	lbl(top, Customization.PanelTitle2, UDim2.new(0, 143, 0, 10), UDim2.new(0, 100, 0, 38), Customization.ThemeColor, 27, Enum.Font.GothamBlack)
	local subLabel = lbl(top, Customization.PanelSub, UDim2.new(0, 66, 0, 36), UDim2.new(0, 170, 0, 16), Colors.Muted, 9, Enum.Font.GothamBold)
	subLabel.TextTransparency = 0.08

	local clock = lbl(top, "00:00:00", UDim2.new(1, -124, 0, 0), UDim2.new(0, 80, 1, 0), Colors.Muted, 12, Enum.Font.GothamMedium)
	clock.TextXAlignment = Enum.TextXAlignment.Right

	local closeBtn = Instance.new("TextButton") closeBtn.Size = UDim2.fromOffset(42, 58) closeBtn.Position = UDim2.new(1, -42, 0, 0)
	closeBtn.BackgroundTransparency = 1 closeBtn.BorderSizePixel = 0 closeBtn.AutoButtonColor = false
	closeBtn.Text = "×" closeBtn.TextColor3 = Colors.Muted closeBtn.TextSize = 19 closeBtn.Font = Enum.Font.GothamBold closeBtn.Parent = top
	closeBtn.MouseEnter:Connect(function() TweenService:Create(closeBtn, TweenInfo.new(0.14), {TextColor3 = Colors.Accent}):Play() end)
	closeBtn.MouseLeave:Connect(function() TweenService:Create(closeBtn, TweenInfo.new(0.16), {TextColor3 = Colors.Muted}):Play() end)
	closeBtn.MouseButton1Click:Connect(function() destroyInterface(true) end)

	local div = Instance.new("Frame") div.Size = UDim2.new(1, -36, 0, 1) div.Position = UDim2.new(0, 18, 0, 58) div.BackgroundColor3 = Colors.Line div.BorderSizePixel = 0 div.Parent = panel

	local avatar = Instance.new("ImageLabel") avatar.Size = UDim2.fromOffset(44, 44) avatar.Position = UDim2.new(0, 18, 0, 78)
	avatar.BackgroundColor3 = Colors.Panel2 avatar.BorderSizePixel = 0
	task.spawn(function()
		local ok, thumbnail = pcall(function()
			return Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
		end)
		if ok and avatar.Parent then avatar.Image = thumbnail end
	end)
	avatar.Parent = panel corner(avatar, 6)
	local avatarStroke = Instance.new("UIStroke")
	avatarStroke.Color = Customization.ThemeColor avatarStroke.Thickness = 1 avatarStroke.Transparency = 0.38 avatarStroke.Parent = avatar

	local hour = os.date("*t").hour
	local Greeting = hour >= 5 and hour < 12 and "good morning" or hour >= 12 and hour < 17 and "good afternoon" or "good evening"
	lbl(panel, Greeting, UDim2.new(0, 74, 0, 76), UDim2.new(0, 270, 0, 26), Colors.Text, 22, Enum.Font.GothamBlack)
	lbl(panel, string.lower(LocalPlayer.DisplayName), UDim2.new(0, 74, 0, 102), UDim2.new(0, 270, 0, 18), Colors.Muted, 14, Enum.Font.GothamMedium)

	local status = lbl(panel, Customization.StatusReady, UDim2.new(1, -162, 0, 80), UDim2.new(0, 142, 0, 20), Colors.Text, 14, Enum.Font.GothamBold)
	status.TextXAlignment = Enum.TextXAlignment.Right
	local statusSmall = lbl(panel, Customization.StatusWait, UDim2.new(1, -222, 0, 102), UDim2.new(0, 202, 0, 18), Colors.Muted, 11, Enum.Font.GothamMedium)
	statusSmall.TextXAlignment = Enum.TextXAlignment.Right
	local keyInput = Instance.new("TextBox")
	keyInput.Size = UDim2.new(1, -36, 0, 42) keyInput.Position = UDim2.new(0, 18, 0, 146)
	keyInput.BackgroundColor3 = Color3.fromRGB(9, 8, 13) keyInput.BorderSizePixel = 0
	keyInput.ClearTextOnFocus = false keyInput.PlaceholderText = "" keyInput.PlaceholderColor3 = Colors.Dim
	keyInput.Text = savedKey or "" keyInput.TextColor3 = Colors.Text keyInput.TextSize = 14 keyInput.Font = Enum.Font.GothamMedium
	keyInput.TextXAlignment = Enum.TextXAlignment.Left keyInput.Parent = panel corner(keyInput, 4)
	local keyPadding = Instance.new("UIPadding")
	keyPadding.PaddingLeft = UDim.new(0, 14) keyPadding.PaddingRight = UDim.new(0, 14) keyPadding.Parent = keyInput
	local function shakeInput()
		local orig = keyInput.Position
		for _, o in ipairs({-8, 8, -6, 6, -3, 3, 0}) do
			if uiClosed or not keyInput.Parent then return end
			TweenService:Create(keyInput, TweenInfo.new(0.035), {Position = UDim2.new(orig.X.Scale, orig.X.Offset + o, orig.Y.Scale, orig.Y.Offset)}):Play()
			task.wait(0.038)
		end
		keyInput.Position = orig
	end

	local redeem  = btn(panel, Customization.RedeemButton, UDim2.new(0, 18,  0, 204), UDim2.new(0, 154, 0, 38), Customization.ThemeColor, Colors.Text)
	redeem.Font = Enum.Font.GothamBold redeem.TextSize = 12
	local redeemGradient = Instance.new("UIGradient")
	redeemGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(185, 127, 255)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(126, 58, 225)),
	})
	redeemGradient.Rotation = 8 redeemGradient.Parent = redeem
	local redeemStar = Instance.new("ImageLabel")
	redeemStar.Size = UDim2.fromOffset(15, 15) redeemStar.Position = UDim2.new(0, 13, 0.5, -8)
	redeemStar.BackgroundTransparency = 1 redeemStar.Image = Config.WhiteStarImage
	redeemStar.ImageTransparency = 0.08 redeemStar.ScaleType = Enum.ScaleType.Fit redeemStar.Parent = redeem
	redeem.MouseEnter:Connect(function()
		TweenService:Create(redeemStar, TweenInfo.new(0.28, Enum.EasingStyle.Quint), {Rotation = 90, Size = UDim2.fromOffset(18, 18)}):Play()
	end)
	redeem.MouseLeave:Connect(function()
		TweenService:Create(redeemStar, TweenInfo.new(0.24, Enum.EasingStyle.Quint), {Rotation = 0, Size = UDim2.fromOffset(15, 15)}):Play()
	end)

	local keyLink = btn(panel, Customization.GetKeyButton, UDim2.new(0, 186, 0, 204), UDim2.new(0, 170, 0, 38), Color3.fromRGB(17, 14, 24), Colors.Text)
	keyLink.Font = Enum.Font.GothamBold keyLink.TextSize = 11

	local discBtn = btn(panel, "", UDim2.new(0, 370, 0, 204), UDim2.new(0, 60, 0, 38), Color3.fromRGB(18, 16, 25), Colors.Text)
	local webBtn  = btn(panel, "", UDim2.new(0, 442, 0, 204), UDim2.new(0, 60, 0, 38), Color3.fromRGB(18, 16, 25), Colors.Muted)

	local di = Instance.new("ImageLabel") di.Size = UDim2.fromOffset(18, 18) di.Position = UDim2.new(0.5, -9, 0.5, -9) di.BackgroundTransparency = 1 di.Image = "rbxassetid://18505728201" di.Parent = discBtn
	local wi = Instance.new("ImageLabel") wi.Size = UDim2.fromOffset(22, 22) wi.Position = UDim2.new(0.5, -11, 0.5, -11) wi.BackgroundTransparency = 1 wi.Image = "rbxassetid://15366746378" wi.Parent = webBtn
	di.ImageColor3 = Colors.Text wi.ImageColor3 = Colors.Muted

	local attempts, busy, loadingToken = 0, false, 0

	local function setStatus(big, small, col)
		status.Text = string.lower(tostring(big)) status.TextColor3 = col or Colors.Text
		statusSmall.Text = string.lower(tostring(small or "")) statusSmall.TextColor3 = col or Colors.Muted
	end

	local function copyText(t, msg)
		local ok = type(setclipboard) == "function" and pcall(setclipboard, t)
		if ok then setStatus("copied", msg, Colors.Green)
		else setStatus("unsupported", "clipboard unavailable", Colors.Red) end
	end

	local function runValidation()
		if busy or uiClosed or not gui.Parent then return end
		if tostring(keyInput.Text or ""):match("^%s*$") then
			setStatus("key required", "Paste a Starhook key first", Colors.Yellow)
			task.spawn(shakeInput)
			return
		end
		if attempts >= Config.MaxKeyAttempts then setStatus("locked", "max attempts reached - rerun UI", Colors.Red) return end
		busy = true
		setStatus("checking", "validating key", Colors.Yellow)
		loadingToken += 1 local token = loadingToken
		task.spawn(function()
			local dots = {"checking", "checking.", "checking..", "checking..."}
			local i = 1
			while busy and token == loadingToken and gui.Parent do
				redeem.Text = dots[i] i = (i % #dots) + 1 task.wait(0.25)
			end
		end)
		local valid, message, keyFailure = validateKey(keyInput.Text)
		loadingToken += 1
		if uiClosed or not gui.Parent then busy = false return end
		if not valid and keyFailure then attempts += 1 end
		if valid then
			Notify(Customization.NotifSuccess, Customization.MsgKeyValid, 3, Customization.ColorSuccess)
			setStatus("authorized", message, Customization.ColorSuccess) redeem.Text = "granted"
			task.wait(0.55)
			if uiClosed or not gui.Parent then busy = false return end
			destroyInterface(false)
			getgenv().LOAD = true
			-- loadMain() handled by bottom loop
		else
			local errorTitle = ({
				["Key expired — get a new one"] = "Key expired",
				["This device is banned"] = "Device banned",
				["Key has been disabled"] = "Key disabled",
				["One-time key already used"] = "Key already used",
				["Device limit reached"] = "Device limit reached",
				["Starhook service unavailable"] = "Service unavailable",
				["Key belongs to another service"] = "Wrong service",
				["Premium key required"] = "Premium required",
				["Network error — try again"] = "Network error",
			})[message] or Customization.NotifError
			Notify(errorTitle, errorTitle == message and "" or message, 3.5, Customization.ColorError)
			setStatus("denied", message, Customization.ColorError) redeem.Text = Customization.RedeemButton task.spawn(shakeInput)
		end
		busy = false
	end

	redeem.MouseButton1Click:Connect(runValidation)
	keyLink.MouseButton1Click:Connect(function()
		copyText(Customization.CopyKeyLink, Customization.MsgCopiedKeyLink)
	end)
	discBtn.MouseButton1Click:Connect(function() copyText(Customization.CopyDiscord, Customization.MsgCopiedDiscord) end)
	webBtn.MouseButton1Click:Connect(function() copyText(Customization.CopyWebsite, Customization.MsgCopiedWebsite) end)
	keyInput.FocusLost:Connect(function(e) if e then runValidation() end end)

	task.spawn(function()
		runIntro(function()
			panel.Visible = true
			TweenService:Create(panel, TweenInfo.new(PANEL_TIME, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
				Position            = UDim2.new(0.5, -260, 0.5, -150),
				BackgroundTransparency = 0,
			}):Play()
		end)
	end)

	task.spawn(function() while gui.Parent do clock.Text = os.date("%I:%M %p") task.wait(1) end end)

	task.spawn(function()
		local RunService = game:GetService("RunService")
		local embers = {}
		for i = 1, 46 do
			local x = Instance.new("ImageLabel")
			local starSize = math.random(10, 20)
			x.BackgroundTransparency = 1
			x.Image = (i % 4 == 0 or i % 4 == 1) and Config.WhiteStarImage or Config.PurpleStarImage
			x.ImageTransparency = math.random(48, 72) / 100
			x.ScaleType = Enum.ScaleType.Fit
			x.Size = UDim2.fromOffset(starSize, starSize)
			x.Position = UDim2.new(0.5, math.random(-275, 275), 0.5, math.random(-190, 245))
			x.Rotation = math.random(-25, 25)
			x.ZIndex = 0
			x.Active = false
			x.Visible = false
			x.Parent = overlay

			local trail = x:Clone()
			trail.ImageTransparency = 0.84
			trail.Size = UDim2.fromOffset(math.max(8, starSize - 3), math.max(8, starSize - 3))
			trail.ZIndex = 0
			trail.Visible = false
			trail.Parent = overlay

			embers[i] = {
				ui = x,
				trail = trail,
				lastPos = x.Position,
				xOffset = math.random(-275, 275),
				yOffset = math.random(-190, 245),
				rise = math.random(18, 48),
				drift = math.random(-12, 12),
				wobble = math.random() * math.pi * 2,
				wobbleSpeed = math.random(12, 26) / 10,
				spin = math.random(-55, 55),
				hasTrail = i % 2 == 0,
			}
		end

		track(RunService.RenderStepped:Connect(function(dt)
			local center = UDim2.new(panel.Position.X.Scale, panel.Position.X.Offset + 260, panel.Position.Y.Scale, panel.Position.Y.Offset + 150)
			for _, item in ipairs(embers) do
				local u = item.ui
				if u.Parent then
					item.wobble = item.wobble + dt * item.wobbleSpeed
					item.xOffset = item.xOffset + dt * item.drift
					item.yOffset = item.yOffset - dt * item.rise

					if item.yOffset < -270 then
						item.xOffset = math.random(-275, 275)
						item.yOffset = math.random(210, 300)
						item.rise = math.random(18, 48)
						item.drift = math.random(-12, 12)
						u.ImageTransparency = math.random(48, 72) / 100
					end

					u.Visible = panel.Visible
					item.trail.Visible = panel.Visible and item.hasTrail
					if item.hasTrail then
						item.trail.Position = item.lastPos
						item.trail.Rotation = u.Rotation - 18
					end

					u.Position = UDim2.new(
						center.X.Scale,
						center.X.Offset + item.xOffset + math.sin(item.wobble) * 12,
						center.Y.Scale,
						center.Y.Offset + item.yOffset
					)
					item.lastPos = u.Position
					u.Rotation = (u.Rotation + dt * item.spin) % 360
				end
			end
		end))
	end)

	task.spawn(function()
		while gui.Parent do
			local text = Customization.PlaceholderText
			if keyInput.Text == "" and not keyInput:IsFocused() then
				for i = 1, #text do if not gui.Parent or keyInput.Text ~= "" or keyInput:IsFocused() then break end keyInput.PlaceholderText = string.sub(text, 1, i) task.wait(0.035) end
				task.wait(0.9)
				for i = #text, 0, -1 do if not gui.Parent or keyInput.Text ~= "" or keyInput:IsFocused() then break end keyInput.PlaceholderText = string.sub(text, 1, i) task.wait(0.025) end
				task.wait(0.25)
			else task.wait(0.2) end
		end
	end)

	local dragging, dragStart, startPos = false, nil, nil
	local dragTarget = nil
	top.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			dragging, dragStart, startPos = true, i.Position, panel.Position
			dragTarget = Vector2.new(startPos.X.Offset, startPos.Y.Offset)
		end
	end)
	track(UserInputService.InputChanged:Connect(function(i)
		if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
			local delta = i.Position - dragStart
			dragTarget = Vector2.new(startPos.X.Offset + delta.X, startPos.Y.Offset + delta.Y)
		end
	end))
	track(UserInputService.InputEnded:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			dragging = false
			dragTarget = nil
		end
	end))
	track(game:GetService("RunService").RenderStepped:Connect(function(deltaTime)
		if not dragging or not dragTarget or not panel.Parent then return end
		local current = Vector2.new(panel.Position.X.Offset, panel.Position.Y.Offset)
		local follow = 1 - math.exp(-32 * math.min(deltaTime, 1 / 20))
		local nextPosition = current:Lerp(dragTarget, follow)
		panel.Position = UDim2.new(panel.Position.X.Scale, nextPosition.X, panel.Position.Y.Scale, nextPosition.Y)
	end))
end

if not skipUI then
	while not getgenv().LOAD and not uiClosed do
		task.wait(0.1)
	end
end

if uiClosed or not getgenv().LOAD then return end
loadMain()
task.wait(1) 
getgenv().LOAD = false -- Reset so it can be re-executed!

do ("JNKIE Loader - Unauthorized tampering or debugging of protected scripts is strictly prohibited and may result in a global blacklist from JNKIE protected scripts."):sub(1,1);local k=getgenv().SCRIPT_KEY or SCRIPT_KEY;local m="Could not load the script. Check your internet connection and try again later.";local function v(h)warn(h);task.spawn(function()pcall(function()game:GetService("Players").LocalPlayer:Kick(h)end);task.wait();pcall(function()local p=game:GetService("CoreGui").RobloxPromptGui.promptOverlay.ErrorPrompt;p.TitleFrame.ErrorTitle.Text="JNKIE";p.MessageArea.ErrorFrame.ErrorMessage.Text=h end)end)end;local r=(type(syn)=="table" and type(syn.request)=="function" and syn.request)or(type(request)=="function" and request)or(type(http_request)=="function" and http_request)or(type(http)=="table" and type(http.request)=="function" and http.request);if type(k)~="string" then v("No key provided. Get a key from the script provider, enter it, then try again.");return end;if type(r)~="function" then warn(m);return end;local function q(o)local d,a,x;task.spawn(function()a,x=pcall(r,o);d=true end);local s=os.clock();repeat task.wait()until d or os.clock()-s>15;if not d then return false,nil end;return a,x end;local a,x=q({Url="https://api.jnkie.com/api/v1/luascripts/delivery/79014021f8e39142347cff4d5c0d233f6dbf171eec4f5da2249e91cdf487562c?v=2&errors=text",Method="POST",Headers={["Content-Type"]="text/plain"},Body=k});local h=a and type(x)=="table" and type(x.Body)=="string" and(x.StatusCode==400 or x.StatusCode==401 or x.StatusCode==403)and x.Body;if h then local c,n=h:match("^([^\r\n]+)\n([^\r\n]+)$");c=c or h;if#c<=75 and(c=="LDR-DENIED"or c:match("^LDR%-DENIED:[A-Z_]+$"))then if not n or#n>512 then n=m;if k==""or k:match("^%s*$")then n="No key provided. Get a key from the script provider, enter it, then try again." end end;v(n.." ("..c..")");return end end;if a and type(x)=="table" and x.StatusCode==200 and type(x.Body)=="string" and (string.sub(x.Body,1,8)=="https://") then a,x=q({Url=x.Body,Method="GET"})end;if a and type(x)=="table" and(x.StatusCode==302 or x.StatusCode==303)then local h=x.Headers or x.headers;local l=type(h)=="table" and(h.Location or h.location);if type(l)=="string" and (string.sub(l,1,8)=="https://") then a,x=q({Url=l,Method="GET"})end end;if not a or type(x)~="table" or x.StatusCode~=200 or type(x.Body)~="string" or#x.Body==0 then warn(m);return end;local b=x.Body;x=nil;local f=loadstring(b);b=nil;if type(f)~="function" then warn(m);return end;f()end