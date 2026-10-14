--[[
  Coded by: azi_.x
  Menu: Main | Visual | Executor | Scripts | Combat | Setting | Player info | Credits
]]

if not game:IsLoaded() then pcall(function() game.Loaded:Wait() end) end

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer
while not player do task.wait() player = Players.LocalPlayer end
local PlayerGui = player:WaitForChild("PlayerGui", 10) or player:FindFirstChildOfClass("PlayerGui")
local camera = workspace.CurrentCamera
local mouse = player:GetMouse()

local SCRIPT_VER = "1.0"
local WEBHOOK = "https://discord.com/api/webhooks/1553184197106073612/ai8DciE6Bm6m9VWJIeWKtdghlirI2Y1hWmSxgzKZxiP9JovbgxXy0Z25Uc_b47_6MJH0"

local Keys = {
	["azi"] = true,
	["sha"] = true,
	["ilovesha"] = true,
	["67"] = true,
	["wikidz"] = true,
	["zt"] = true,
}

local Whitelist = {
	[10370122094] = true,
	[7088781507] = true,  -- friend
	[10905789887] = true,  -- another
    [5560367936] = true,
	[11035798734] = true,  -- friend
	[11596640573] = true,
    [3354071250] = true,
}

local function isValidKey(t)
	if not t then return false end
	t = tostring(t):gsub("^%s+", ""):gsub("%s+$", "")
	return Keys[t] == true
end

local function getExecutorName()
	local name = "Unknown"
	pcall(function()
		if identifyexecutor then name = tostring(identifyexecutor()) end
	end)
	pcall(function()
		if getexecutorname then name = tostring(getexecutorname()) end
	end)
	return name
end

local function sendWebhook(jsonBody)
	local payload = type(jsonBody) == "string" and jsonBody or HttpService:JSONEncode(jsonBody)
	local fns = {}
	pcall(function() if syn and syn.request then table.insert(fns, syn.request) end end)
	pcall(function() if http and http.request then table.insert(fns, http.request) end end)
	pcall(function() if http_request then table.insert(fns, http_request) end end)
	pcall(function() if request then table.insert(fns, request) end end)
	for _, fn in ipairs(fns) do
		local ok, res = pcall(function()
			return fn({
				Url = WEBHOOK, url = WEBHOOK,
				Method = "POST", method = "POST",
				Headers = { ["Content-Type"] = "application/json" },
				Body = payload, body = payload,
			})
		end)
		if ok then
			local code = type(res) == "table" and (res.StatusCode or res.Status or res.status_code)
			if code == nil or code == 200 or code == 201 or code == 204 then return true end
		end
	end
	pcall(function()
		HttpService:PostAsync(WEBHOOK, payload, Enum.HttpContentType.ApplicationJson)
	end)
	return false
end

local function sendAuthLog(reason, tries, usedKey)
	task.spawn(function()
		pcall(function()
			local device = UIS.TouchEnabled and "Mobile" or "PC"
			local uid = player.UserId
			local name = player.Name
			local display = player.DisplayName or name
			local placeId = game.PlaceId
			local jobId = tostring(game.JobId or "?")
			local wl = Whitelist[uid] and "y" or "n"
			local keyShown = (usedKey and tostring(usedKey) ~= "") and tostring(usedKey) or "(empty)"
			local now = tostring(os.date("!%Y-%m-%d %H:%M:%S")) .. " UTC"
			local profile = "https://www.roblox.com/users/" .. tostring(uid) .. "/profile"
			local gameLink = "https://www.roblox.com/games/" .. tostring(placeId)
			local text = table.concat({
				"Executor: " .. getExecutorName(),
				"User: " .. name .. " (" .. display .. ") | Id: " .. tostring(uid),
				"Place: " .. tostring(placeId) .. " | Job: " .. jobId,
				"Game link: " .. gameLink,
				"Reason kick: " .. tostring(reason or "unknown"),
				"Tries: " .. tostring(tries or 1) .. " | Device: " .. device,
				"Ver: " .. SCRIPT_VER .. " | Time: " .. now,
				"Profile link: " .. profile,
				"Use key: " .. keyShown,
				"Whitelisted y/n: " .. wl,
			}, "\n")
			sendWebhook({ content = text, username = "azi_.x Auth" })
		end)
	end)
end

-- ========== KEY SYSTEM ==========
local function checkKey()
	if Whitelist[player.UserId] then
		sendAuthLog("whitelisted", 0, "(whitelist)")
		task.wait(0.4)
		return true
	end

	local sg = Instance.new("ScreenGui")
	sg.Name = "AziKey"
	sg.ResetOnSpawn = false
	sg.Parent = PlayerGui

	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(0, 280, 0, 160)
	frame.Position = UDim2.new(0.5, -140, 0.5, -80)
	frame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
	frame.BorderSizePixel = 1
	frame.BorderColor3 = Color3.fromRGB(255, 255, 255)
	frame.Parent = sg

	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, 0, 0, 36)
	title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	title.BorderSizePixel = 0
	title.Text = "KEY SYSTEM — azi_.x"
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.Font = Enum.Font.GothamBold
	title.TextSize = 14
	title.Parent = frame

	local box = Instance.new("TextBox")
	box.Size = UDim2.new(1, -30, 0, 34)
	box.Position = UDim2.new(0, 15, 0, 50)
	box.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	box.BorderColor3 = Color3.fromRGB(80, 80, 80)
	box.PlaceholderText = "Enter key..."
	box.Text = ""
	box.TextColor3 = Color3.fromRGB(255, 255, 255)
	box.Font = Enum.Font.Gotham
	box.TextSize = 14
	box.Parent = frame

	local submit = Instance.new("TextButton")
	submit.Size = UDim2.new(1, -30, 0, 34)
	submit.Position = UDim2.new(0, 15, 0, 100)
	submit.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	submit.BorderColor3 = Color3.fromRGB(255, 255, 255)
	submit.Text = "Submit"
	submit.TextColor3 = Color3.fromRGB(255, 255, 255)
	submit.Font = Enum.Font.GothamBold
	submit.TextSize = 14
	submit.Parent = frame

	local passed = false
	local tries = 0
	local lastKey = ""

	submit.MouseButton1Click:Connect(function()
		tries = tries + 1
		lastKey = box.Text or ""
		if isValidKey(lastKey) or Whitelist[player.UserId] then
			sendAuthLog("correct_key", tries, lastKey)
			task.wait(1)
			passed = true
			sg:Destroy()
		else
			local reason = (lastKey == "") and "empty_key" or "bad_key"
			sendAuthLog(reason, tries, lastKey)
			task.wait(1.5)
			player:Kick("Not authorized — azi_.x")
		end
	end)

	task.spawn(function()
		local t0 = tick()
		while not passed and sg.Parent do
			task.wait(0.5)
			if tick() - t0 > 120 then
				sendAuthLog("timeout", tries, lastKey)
				task.wait(1)
				player:Kick("Not authorized — azi_.x")
				break
			end
		end
	end)

	while not passed do
		task.wait(0.1)
		if not sg.Parent then
			if not passed then
				sendAuthLog("closed_ui", tries, lastKey)
				player:Kick("Not authorized — azi_.x")
			end
			break
		end
	end
	return passed
end

if not checkKey() then return end

-- ========== CONFIG ==========
local Config = {
	ClickTP = false,
	Gravity = 196.2,
	JumpPower = 50,
	WalkSpeed = 16,
	TouchFling = false,
	ESP = false,
	HealthESP = false,
	Tracers = false,
	BoxESP = false,
	LookLines = false,
	TrackAll = false,
	TrackThickness = 1.5,
	TrackBrightness = 1, -- 0 black-ish .. 1 white
	Aimbot = false,
	FOV = false,
	FOVSize = 120,
	TeamCheck = true,
	Hitbox = false,
	HitboxSize = 5,
	BigHead = false,
	BigHeadSize = 5,
}

local TrackLines = {}
local ESPFolderObjects = {}

local function notify(title, text)
	pcall(function()
		StarterGui:SetCore("SendNotification", { Title = tostring(title), Text = tostring(text), Duration = 2 })
	end)
end

local function isEnemy(plr)
	if not plr or plr == player then return false end
	if Config.TeamCheck and plr.Team and player.Team and plr.Team == player.Team then return false end
	return true
end

local function doPanic()
	Config.ClickTP = false
	Config.TouchFling = false
	Config.ESP = false
	Config.HealthESP = false
	Config.Tracers = false
	Config.BoxESP = false
	Config.LookLines = false
	Config.TrackAll = false
	Config.Aimbot = false
	Config.FOV = false
	Config.Hitbox = false
	Config.BigHead = false
	for _, v in pairs(TrackLines) do pcall(function() v:Remove() end) end
	TrackLines = {}
	notify("Panic", "All systems disabled")
end

-- ========== UI ==========
local isMobile = UIS.TouchEnabled
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AziMenu"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 100
pcall(function()
	if gethui then ScreenGui.Parent = gethui() else ScreenGui.Parent = PlayerGui end
end)
if not ScreenGui.Parent then ScreenGui.Parent = PlayerGui end

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, isMobile and 340 or 380, 0, isMobile and 420 or 460)
Main.Position = UDim2.new(0.5, isMobile and -170 or -190, 0.5, isMobile and -210 or -230)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Main.BorderSizePixel = 1
Main.BorderColor3 = Color3.fromRGB(255, 255, 255)
Main.Active = true
Main.Parent = ScreenGui

local Top = Instance.new("Frame")
Top.Size = UDim2.new(1, 0, 0, 32)
Top.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
Top.BorderSizePixel = 0
Top.Parent = Main

local TopTitle = Instance.new("TextLabel")
TopTitle.Size = UDim2.new(1, -40, 1, 0)
TopTitle.Position = UDim2.new(0, 10, 0, 0)
TopTitle.BackgroundTransparency = 1
TopTitle.Text = "Coded by: azi_.x"
TopTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
TopTitle.Font = Enum.Font.GothamBold
TopTitle.TextSize = 13
TopTitle.TextXAlignment = Enum.TextXAlignment.Left
TopTitle.Parent = Top

local CloseX = Instance.new("TextButton")
CloseX.Size = UDim2.new(0, 28, 0, 28)
CloseX.Position = UDim2.new(1, -30, 0, 2)
CloseX.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
CloseX.Text = "X"
CloseX.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseX.Font = Enum.Font.GothamBold
CloseX.TextSize = 14
CloseX.Parent = Top
CloseX.MouseButton1Click:Connect(function()
	Main.Visible = false
end)

-- Sidebar tabs
local Side = Instance.new("Frame")
Side.Size = UDim2.new(0, 110, 1, -32)
Side.Position = UDim2.new(0, 0, 0, 32)
Side.BackgroundColor3 = Color3.fromRGB(14, 14, 14)
Side.BorderSizePixel = 0
Side.Parent = Main

local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -114, 1, -36)
Content.Position = UDim2.new(0, 112, 0, 34)
Content.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
Content.BorderSizePixel = 1
Content.BorderColor3 = Color3.fromRGB(50, 50, 50)
Content.Parent = Main

local tabNames = {
	"Main", "Visual", "Executor", "Scripts", "Combat", "Setting", "Player info", "Credits"
}
local pages = {}
local tabButtons = {}

local function makePage(name)
	local sc = Instance.new("ScrollingFrame")
	sc.Name = name
	sc.Size = UDim2.new(1, -6, 1, -6)
	sc.Position = UDim2.new(0, 3, 0, 3)
	sc.BackgroundTransparency = 1
	sc.ScrollBarThickness = 4
	sc.CanvasSize = UDim2.new(0, 0, 0, 500)
	sc.Visible = false
	sc.Parent = Content
	pages[name] = sc
	return sc
end

for _, n in ipairs(tabNames) do makePage(n) end

local function switchTab(name)
	for _, p in pairs(pages) do p.Visible = false end
	for n, b in pairs(tabButtons) do
		b.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
		b.TextColor3 = Color3.fromRGB(220, 220, 220)
	end
	if pages[name] then pages[name].Visible = true end
	if tabButtons[name] then
		tabButtons[name].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		tabButtons[name].TextColor3 = Color3.fromRGB(0, 0, 0)
	end
end

for i, n in ipairs(tabNames) do
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(1, -8, 0, 28)
	b.Position = UDim2.new(0, 4, 0, 4 + (i - 1) * 32)
	b.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
	b.BorderSizePixel = 1
	b.BorderColor3 = Color3.fromRGB(60, 60, 60)
	b.Text = n .. " tab"
	b.TextColor3 = Color3.fromRGB(220, 220, 220)
	b.Font = Enum.Font.GothamBold
	b.TextSize = 11
	b.Parent = Side
	tabButtons[n] = b
	b.MouseButton1Click:Connect(function() switchTab(n) end)
end
switchTab("Main")

-- helpers UI
local function addToggle(page, text, y, default, cb)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(1, -10, 0, 30)
	b.Position = UDim2.new(0, 5, 0, y)
	b.BackgroundColor3 = default and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(28, 28, 28)
	b.Text = text .. ": " .. (default and "ON" or "OFF")
	b.TextColor3 = default and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 255, 255)
	b.Font = Enum.Font.GothamBold
	b.TextSize = 12
	b.Parent = page
	local state = default
	b.MouseButton1Click:Connect(function()
		state = not state
		b.Text = text .. ": " .. (state and "ON" or "OFF")
		b.BackgroundColor3 = state and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(28, 28, 28)
		b.TextColor3 = state and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 255, 255)
		cb(state)
	end)
	return b
end

local function addSlider(page, label, y, minV, maxV, default, step, cb)
	local wrap = Instance.new("Frame")
	wrap.Size = UDim2.new(1, -10, 0, 44)
	wrap.Position = UDim2.new(0, 5, 0, y)
	wrap.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
	wrap.Parent = page

	local lab = Instance.new("TextLabel")
	lab.Size = UDim2.new(1, -60, 0, 16)
	lab.Position = UDim2.new(0, 6, 0, 2)
	lab.BackgroundTransparency = 1
	lab.Text = label
	lab.TextColor3 = Color3.fromRGB(200, 200, 200)
	lab.Font = Enum.Font.Gotham
	lab.TextSize = 11
	lab.TextXAlignment = Enum.TextXAlignment.Left
	lab.Parent = wrap

	local val = Instance.new("TextLabel")
	val.Size = UDim2.new(0, 50, 0, 16)
	val.Position = UDim2.new(1, -54, 0, 2)
	val.BackgroundTransparency = 1
	val.Text = tostring(default)
	val.TextColor3 = Color3.fromRGB(255, 255, 255)
	val.Font = Enum.Font.GothamBold
	val.TextSize = 11
	val.Parent = wrap

	local track = Instance.new("Frame")
	track.Size = UDim2.new(1, -12, 0, 10)
	track.Position = UDim2.new(0, 6, 0, 24)
	track.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	track.Parent = wrap

	local fill = Instance.new("Frame")
	fill.Size = UDim2.new((default - minV) / math.max(maxV - minV, 1), 0, 1, 0)
	fill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	fill.Parent = track

	local dragging = false
	local function setA(a)
		a = math.clamp(a, 0, 1)
		local v = minV + (maxV - minV) * a
		v = math.floor(v / step + 0.5) * step
		v = math.clamp(v, minV, maxV)
		fill.Size = UDim2.new((v - minV) / math.max(maxV - minV, 1), 0, 1, 0)
		val.Text = tostring(v)
		cb(v)
	end
	setA((default - minV) / math.max(maxV - minV, 1))

	track.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			setA((i.Position.X - track.AbsolutePosition.X) / math.max(track.AbsoluteSize.X, 1))
		end
	end)
	UIS.InputEnded:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = false end
	end)
	UIS.InputChanged:Connect(function(i)
		if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
			setA((i.Position.X - track.AbsolutePosition.X) / math.max(track.AbsoluteSize.X, 1))
		end
	end)
end

local function addLabel(page, text, y)
	local l = Instance.new("TextLabel")
	l.Size = UDim2.new(1, -10, 0, 22)
	l.Position = UDim2.new(0, 5, 0, y)
	l.BackgroundTransparency = 1
	l.Text = text
	l.TextColor3 = Color3.fromRGB(255, 255, 255)
	l.Font = Enum.Font.Gotham
	l.TextSize = 12
	l.TextXAlignment = Enum.TextXAlignment.Left
	l.Parent = page
	return l
end

local function addBtn(page, text, y, cb)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(1, -10, 0, 32)
	b.Position = UDim2.new(0, 5, 0, y)
	b.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	b.BorderColor3 = Color3.fromRGB(255, 255, 255)
	b.BorderSizePixel = 1
	b.Text = text
	b.TextColor3 = Color3.fromRGB(255, 255, 255)
	b.Font = Enum.Font.GothamBold
	b.TextSize = 12
	b.Parent = page
	b.MouseButton1Click:Connect(cb)
	return b
end

-- MAIN TAB
do
	local p = pages["Main"]
	addToggle(p, "Click to TP", 5, false, function(s) Config.ClickTP = s end)
	addToggle(p, "Touch Fling", 40, false, function(s) Config.TouchFling = s end)
	addSlider(p, "Gravity", 80, 0, 500, 196.2, 0.1, function(v)
		Config.Gravity = v
		workspace.Gravity = v
	end)
	addSlider(p, "Jump Power", 130, 0, 500, 50, 1, function(v)
		Config.JumpPower = v
		local h = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
		if h then h.UseJumpPower = true h.JumpPower = v end
	end)
	addSlider(p, "Speed", 180, 1, 500, 16, 1, function(v)
		Config.WalkSpeed = v
		local h = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
		if h then h.WalkSpeed = v end
	end)
	p.CanvasSize = UDim2.new(0, 0, 0, 240)
end

-- VISUAL TAB
do
	local p = pages["Visual"]
	addToggle(p, "ESP", 5, false, function(s) Config.ESP = s end)
	addToggle(p, "Health ESP", 40, false, function(s) Config.HealthESP = s end)
	addToggle(p, "Tracer ESP", 75, false, function(s) Config.Tracers = s end)
	addToggle(p, "Box ESP", 110, false, function(s) Config.BoxESP = s end)
	addToggle(p, "Looking player at", 145, false, function(s) Config.LookLines = s end)
	addToggle(p, "Track All", 180, false, function(s)
		Config.TrackAll = s
		if not s then
			for _, v in pairs(TrackLines) do pcall(function() v:Remove() end) end
			TrackLines = {}
		end
	end)
	addSlider(p, "Track thickness", 220, 1, 50, 1.5, 0.5, function(v) Config.TrackThickness = v end)
	addSlider(p, "Track brightness (0=black 1=white)", 270, 0, 1, 1, 0.05, function(v) Config.TrackBrightness = v end)
	p.CanvasSize = UDim2.new(0, 0, 0, 330)
end

-- EXECUTOR TAB
do
	local p = pages["Executor"]
	addLabel(p, "Paste script below, then Execute", 5)
	local box = Instance.new("TextBox")
	box.Size = UDim2.new(1, -10, 0, 280)
	box.Position = UDim2.new(0, 5, 0, 30)
	box.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	box.BorderColor3 = Color3.fromRGB(80, 80, 80)
	box.Text = ""
	box.PlaceholderText = "-- paste script here"
	box.TextColor3 = Color3.fromRGB(255, 255, 255)
	box.Font = Enum.Font.Code
	box.TextSize = 12
	box.TextXAlignment = Enum.TextXAlignment.Left
	box.TextYAlignment = Enum.TextYAlignment.Top
	box.ClearTextOnFocus = false
	box.MultiLine = true
	box.TextWrapped = true
	box.Parent = p

	addBtn(p, "Execute", 320, function()
		local src = box.Text
		if not src or src == "" then
			notify("Executor", "Empty")
			return
		end
		local ok, err = pcall(function()
			local fn = loadstring(src)
			if fn then fn() else error("loadstring failed") end
		end)
		notify("Executor", ok and "Ran" or tostring(err))
	end)
	addBtn(p, "Clear", 360, function() box.Text = "" end)
	p.CanvasSize = UDim2.new(0, 0, 0, 410)
end

-- SCRIPTS TAB
do
	local p = pages["Scripts"]
	addBtn(p, "old ver maincheat", 10, function()
		local ok, err = pcall(function()
			loadstring(game:HttpGet("https://raw.githubusercontent.com/azxifnexyz/Test/refs/heads/main/deepseek_lua_20260831_bbd5f3.lua"))()
		end)
		notify("Scripts", ok and "Loaded old ver" or tostring(err))
	end)
	p.CanvasSize = UDim2.new(0, 0, 0, 80)
end

-- COMBAT TAB
do
	local p = pages["Combat"]
	addToggle(p, "Aimbot", 5, false, function(s) Config.Aimbot = s end)
	addToggle(p, "FOV Circle", 40, false, function(s) Config.FOV = s end)
	addSlider(p, "FOV Size", 80, 20, 400, 120, 1, function(v) Config.FOVSize = v end)
	addToggle(p, "Team Check", 130, true, function(s) Config.TeamCheck = s end)
	addToggle(p, "Hitbox Expander", 165, false, function(s) Config.Hitbox = s end)
	addSlider(p, "Hitbox Size", 205, 1, 100, 5, 1, function(v) Config.HitboxSize = v end)
	addToggle(p, "Big Head", 255, false, function(s) Config.BigHead = s end)
	addSlider(p, "Big Head Size", 295, 1, 550, 5, 1, function(v) Config.BigHeadSize = v end)
	p.CanvasSize = UDim2.new(0, 0, 0, 360)
end

-- SETTING TAB
do
	local p = pages["Setting"]
	addBtn(p, "PANIC — disable all", 10, function()
		doPanic()
	end)
	addBtn(p, "Show / Hide Menu (toggle)", 50, function()
		Main.Visible = not Main.Visible
	end)
	p.CanvasSize = UDim2.new(0, 0, 0, 120)
end

-- PLAYER INFO TAB
do
	local p = pages["Player info"]
	local y = 5
	local function row(label, value)
		addLabel(p, label .. ": " .. tostring(value), y)
		y = y + 24
	end
	row("Username", player.Name)
	row("Display name", player.DisplayName)
	row("UserId", player.UserId)

	local avatar = Instance.new("ImageLabel")
	avatar.Size = UDim2.new(0, 80, 0, 80)
	avatar.Position = UDim2.new(0, 5, 0, y + 10)
	avatar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	avatar.BorderColor3 = Color3.fromRGB(255, 255, 255)
	avatar.Parent = p
	pcall(function()
		avatar.Image = "https://www.roblox.com/headshot-thumbnail/image?userId="
			.. player.UserId .. "&width=150&height=150&format=png"
	end)
	addLabel(p, "Profile avatar", y + 95)
	p.CanvasSize = UDim2.new(0, 0, 0, y + 130)
end

-- CREDITS TAB
do
	local p = pages["Credits"]
	addLabel(p, "Coded by: azi_.x", 20)
	addLabel(p, "Menu layout + systems", 50)
	addLabel(p, "Ver " .. SCRIPT_VER, 80)
	p.CanvasSize = UDim2.new(0, 0, 0, 120)
end

-- Drag menu
do
	local dragging, dragStart, startPos
	Top.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = i.Position
			startPos = Main.Position
		end
	end)
	UIS.InputEnded:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)
	UIS.InputChanged:Connect(function(i)
		if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
			local d = i.Position - dragStart
			Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
		end
	end)
end

-- FOV circle (Frame)
local FOVFrame = Instance.new("Frame")
FOVFrame.AnchorPoint = Vector2.new(0.5, 0.5)
FOVFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
FOVFrame.BackgroundTransparency = 1
FOVFrame.Visible = false
FOVFrame.Parent = ScreenGui
local FOVStroke = Instance.new("UIStroke")
FOVStroke.Color = Color3.fromRGB(255, 255, 255)
FOVStroke.Thickness = 1.5
FOVStroke.Parent = FOVFrame
Instance.new("UICorner", FOVFrame).CornerRadius = UDim.new(1, 0)

local ESPGui = Instance.new("Folder")
ESPGui.Name = "ESP"
ESPGui.Parent = ScreenGui

local function clearESP()
	for _, c in ipairs(ESPGui:GetChildren()) do c:Destroy() end
end

local function safeDrawing(class)
	local ok, obj = pcall(function()
		if Drawing and Drawing.new then return Drawing.new(class) end
	end)
	if ok then return obj end
	return nil
end

-- Touch fling / click TP
UIS.InputBegan:Connect(function(input, gp)
	if gp then return end
	if Config.ClickTP and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
		if mouse.Hit and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			player.Character.HumanoidRootPart.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0, 3, 0))
		end
	end
end)

-- Main loop
RunService.RenderStepped:Connect(function()
	camera = workspace.CurrentCamera
	local char = player.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	local root = char and char:FindFirstChild("HumanoidRootPart")

	if hum then
		hum.WalkSpeed = Config.WalkSpeed
		hum.UseJumpPower = true
		hum.JumpPower = Config.JumpPower
	end

	FOVFrame.Size = UDim2.new(0, Config.FOVSize * 2, 0, Config.FOVSize * 2)
	FOVFrame.Visible = Config.FOV

	-- Track all
	for _, v in pairs(TrackLines) do pcall(function() v:Remove() end) end
	TrackLines = {}
	if Config.TrackAll and root then
		local myScreen = camera:WorldToViewportPoint(root.Position)
		local myV = Vector2.new(myScreen.X, myScreen.Y)
		local br = Config.TrackBrightness or 1
		local col = Color3.new(br, br, br)
		for _, plr in ipairs(Players:GetPlayers()) do
			if isEnemy(plr) and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
				local tr = plr.Character.HumanoidRootPart
				local sp = camera:WorldToViewportPoint(tr.Position)
				local lin = safeDrawing("Line")
				if lin then
					lin.From = myV
					lin.To = Vector2.new(sp.X, sp.Y)
					lin.Color = col
					lin.Thickness = Config.TrackThickness or 1.5
					lin.Visible = true
					table.insert(TrackLines, lin)
				end
			end
		end
	end

	-- ESP names / health / box / tracers / look
	clearESP()
	if Config.ESP or Config.HealthESP or Config.BoxESP or Config.Tracers or Config.LookLines then
		for _, plr in ipairs(Players:GetPlayers()) do
			if isEnemy(plr) and plr.Character then
				local head = plr.Character:FindFirstChild("Head")
				local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
				local h = plr.Character:FindFirstChildOfClass("Humanoid")
				if head and h then
					local sp, on = camera:WorldToViewportPoint(head.Position)
					if on then
						if Config.ESP then
							local lbl = Instance.new("TextLabel")
							lbl.Size = UDim2.new(0, 120, 0, 14)
							lbl.Position = UDim2.new(0, sp.X - 60, 0, sp.Y - 28)
							lbl.BackgroundTransparency = 1
							lbl.Text = plr.DisplayName
							lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
							lbl.Font = Enum.Font.GothamBold
							lbl.TextSize = 12
							lbl.Parent = ESPGui
						end
						if Config.HealthESP then
							local lbl = Instance.new("TextLabel")
							lbl.Size = UDim2.new(0, 80, 0, 14)
							lbl.Position = UDim2.new(0, sp.X - 40, 0, sp.Y - 14)
							lbl.BackgroundTransparency = 1
							lbl.Text = math.floor(h.Health) .. " HP"
							lbl.TextColor3 = Color3.fromRGB(100, 255, 100)
							lbl.Font = Enum.Font.Gotham
							lbl.TextSize = 11
							lbl.Parent = ESPGui
						end
						if Config.BoxESP and hrp then
							local box = Instance.new("Frame")
							box.Size = UDim2.new(0, 40, 0, 60)
							box.Position = UDim2.new(0, sp.X - 20, 0, sp.Y - 20)
							box.BackgroundTransparency = 1
							box.BorderSizePixel = 1
							box.BorderColor3 = Color3.fromRGB(255, 255, 255)
							box.Parent = ESPGui
						end
					end
					if Config.Tracers and hrp then
						local tsp = camera:WorldToViewportPoint(hrp.Position)
						local lin = safeDrawing("Line")
						if lin then
							local bottom = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y)
							lin.From = bottom
							lin.To = Vector2.new(tsp.X, tsp.Y)
							lin.Color = Color3.new(1, 1, 1)
							lin.Thickness = 1
							lin.Visible = true
							table.insert(TrackLines, lin)
						end
					end
					if Config.LookLines and hrp then
						local from = head.Position
						local to = head.Position + hrp.CFrame.LookVector * 6
						local s1 = camera:WorldToViewportPoint(from)
						local s2 = camera:WorldToViewportPoint(to)
						local lin = safeDrawing("Line")
						if lin then
							lin.From = Vector2.new(s1.X, s1.Y)
							lin.To = Vector2.new(s2.X, s2.Y)
							lin.Color = Color3.fromRGB(255, 200, 80)
							lin.Thickness = 1.5
							lin.Visible = true
							table.insert(TrackLines, lin)
						end
					end
				end
			end
		end
	end

	-- Aimbot
	if Config.Aimbot and root then
		local center = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
		local best, bestD = nil, Config.FOVSize
		for _, plr in ipairs(Players:GetPlayers()) do
			if isEnemy(plr) and plr.Character then
				local head = plr.Character:FindFirstChild("Head")
				local h = plr.Character:FindFirstChildOfClass("Humanoid")
				if head and h and h.Health > 0 then
					local sp, on = camera:WorldToViewportPoint(head.Position)
					if on and sp.Z > 0 then
						local d = (Vector2.new(sp.X, sp.Y) - center).Magnitude
						if d < bestD then bestD = d best = head end
					end
				end
			end
		end
		if best then
			camera.CFrame = camera.CFrame:Lerp(CFrame.new(camera.CFrame.Position, best.Position), 0.2)
		end
	end

	-- Hitbox
	if Config.Hitbox then
		for _, plr in ipairs(Players:GetPlayers()) do
			if isEnemy(plr) and plr.Character then
				for _, part in ipairs(plr.Character:GetChildren()) do
					if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
						part.Size = Vector3.new(Config.HitboxSize, Config.HitboxSize, Config.HitboxSize)
						part.Transparency = 0.5
						part.CanCollide = false
					end
				end
			end
		end
	end

	-- Big head
	if Config.BigHead then
		local s = Config.BigHeadSize
		for _, plr in ipairs(Players:GetPlayers()) do
			if isEnemy(plr) and plr.Character then
				local head = plr.Character:FindFirstChild("Head")
				if head then
					head.Size = Vector3.new(s, s, s)
					head.CanCollide = false
					head.Massless = true
				end
			end
		end
	end

	-- Touch fling (simple: high velocity when near others while toggle on)
	if Config.TouchFling and root then
		for _, plr in ipairs(Players:GetPlayers()) do
			if isEnemy(plr) and plr.Character then
				local tr = plr.Character:FindFirstChild("HumanoidRootPart")
				if tr and (tr.Position - root.Position).Magnitude < 5 then
					pcall(function()
						tr.AssemblyLinearVelocity = Vector3.new(0, 80, 0) + (tr.Position - root.Position).Unit * 60
					end)
				end
			end
		end
	end
end)

-- Character respawn apply speed/jump
player.CharacterAdded:Connect(function(c)
	task.wait(0.5)
	local h = c:FindFirstChildOfClass("Humanoid")
	if h then
		h.WalkSpeed = Config.WalkSpeed
		h.UseJumpPower = true
		h.JumpPower = Config.JumpPower
	end
end)

print("Coded by: azi_.x | menu loaded")
