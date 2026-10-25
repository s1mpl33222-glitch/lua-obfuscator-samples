repeat task.wait() until game:IsLoaded()

-- ===== SAFETY FALLBACK =====
if not table.clear then
	function table.clear(t)
		for k in pairs(t) do t[k] = nil end
	end
end

_G.ScriptEnabled      = true
_G.AutoWriteEnabled   = false
_G.AutoSubmitEnabled  = false
_G.RiddleSolverEnabled = false
_G.SubmitAfterCount   = 1
_G.SubmitAttempts     = 3

local FAST_WAIT = 0.000000000000000000000000000000000000000000000000000000000000000001

local enteredCodes = {}
local activeConnections = {}
local latestCode = nil
local lastWrittenCode = nil
local lastAttemptedCode = nil
local lastSubmittedBatch = {}
local autoWriteConn = nil
local pendingQueue = {}
local pendingSeen = {}
local writeBusy = false
local collectedCodes = {}
local collectedSeen = {}
local CODE_SEPARATOR = ""

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

------------------------------------------------------------
-- MOON THEME
------------------------------------------------------------
local Theme = {
	Void      = Color3.fromRGB(8, 9, 13),
	Panel     = Color3.fromRGB(14, 15, 21),
	PanelSoft = Color3.fromRGB(20, 22, 30),
	Moonlight = Color3.fromRGB(223, 229, 240),
	Moonbeam  = Color3.fromRGB(168, 183, 214),
	Silver    = Color3.fromRGB(120, 132, 158),
	Glow      = Color3.fromRGB(199, 210, 235),
	DeepGlow  = Color3.fromRGB(58, 66, 92),
	ToggleOff = Color3.fromRGB(40, 43, 54),
}
local FontTitle = Enum.Font.Michroma
local FontBody  = Enum.Font.Nunito

local sweepGradients = {}
local function makeRounded(parent, radius)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, radius or 12)
	c.Parent = parent
	return c
end
local function applyMoonGlow(parent, thickness)
	local stroke = Instance.new("UIStroke")
	stroke.Thickness = thickness or 1.4
	stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	stroke.Color = Theme.Glow
	stroke.Transparency = 0.05
	local grad = Instance.new("UIGradient")
	grad.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Theme.DeepGlow),
		ColorSequenceKeypoint.new(0.5, Theme.Moonlight),
		ColorSequenceKeypoint.new(1, Theme.DeepGlow),
	}
	grad.Parent = stroke
	stroke.Parent = parent
	table.insert(sweepGradients, grad)
	return stroke
end

------------------------------------------------------------
-- CONFIG (panel position only)
------------------------------------------------------------
local CONFIG_PATH = "K2_FexHub_config.json"
local hasFS = (writefile and readfile and isfile) and true or false
local config = { panelX = nil, panelY = nil }

local function loadConfig()
	if not hasFS or not isfile(CONFIG_PATH) then return end
	local ok, data = pcall(function() return HttpService:JSONDecode(readfile(CONFIG_PATH)) end)
	if ok and type(data) == "table" then
		if data.panelX then config.panelX = data.panelX end
		if data.panelY then config.panelY = data.panelY end
	end
end
local pendingSave = false
local function saveConfig()
	if not hasFS or pendingSave then return end
	pendingSave = true
	task.defer(function()
		pendingSave = false
		pcall(function() writefile(CONFIG_PATH, HttpService:JSONEncode(config)) end)
	end)
end
loadConfig()

------------------------------------------------------------
-- SAB_DB + RIDDLE SOLVER (from FexHub)
------------------------------------------------------------
local SAB_DB = {
	["how old am i"] = "24", ["how old is sammy"] = "24", ["my age"] = "24", ["sammy age"] = "24", ["age"] = "24",
	["where am i from"] = "BRAZIL", ["where is sammy from"] = "BRAZIL", ["my country"] = "BRAZIL", ["sammy country"] = "BRAZIL",
	["favorite color"] = "BLUE", ["fav color"] = "BLUE", ["my color"] = "BLUE", ["sammy color"] = "BLUE", ["color"] = "BLUE",
	["favorite football player"] = "RONALDO", ["fav football player"] = "RONALDO", ["my favorite football player"] = "RONALDO", ["ronaldo"] = "RONALDO",
	["game created on"] = "FRIDAY", ["created on"] = "FRIDAY", ["what day was the game created"] = "FRIDAY", ["what day was sab created"] = "FRIDAY", ["game creation day"] = "FRIDAY",
	["seventh mutation"] = "CURSED", ["7th mutation"] = "CURSED",
	["eighth mutation"] = "DIVINE", ["8th mutation"] = "DIVINE",
	["ninth mutation"] = "CYBER", ["9th mutation"] = "CYBER",
	["tenth mutation"] = "PHANTOM", ["10th mutation"] = "PHANTOM",
	["first machine"] = "RAINBOW MACHINE", ["1st machine"] = "RAINBOW MACHINE",
	["second machine"] = "BUBBLEGUM MACHINE", ["2nd machine"] = "BUBBLEGUM MACHINE",
	["third machine"] = "FUSE MACHINE", ["3rd machine"] = "FUSE MACHINE",
	["fourth machine"] = "CRAFT MACHINE", ["4th machine"] = "CRAFT MACHINE",
	["fifth machine"] = "WITCH FUSE", ["5th machine"] = "WITCH FUSE",
	["sixth machine"] = "BRAINROT DEALER", ["6th machine"] = "BRAINROT DEALER",
	["seventh machine"] = "BRAINROT TRADER", ["7th machine"] = "BRAINROT TRADER",
	["eighth machine"] = "SANTA'S FUSE", ["8th machine"] = "SANTA'S FUSE",
	["ninth machine"] = "SANTA'S SHOP", ["9th machine"] = "SANTA'S SHOP",
	["tenth machine"] = "NEW YEAR'S MACHINE", ["10th machine"] = "NEW YEAR'S MACHINE",
	["eleventh machine"] = "DUELS MACHINE", ["11th machine"] = "DUELS MACHINE",
	["twelfth machine"] = "CUPID'S MACHINE", ["12th machine"] = "CUPID'S MACHINE",
	["thirteenth machine"] = "TRADE MACHINE", ["13th machine"] = "TRADE MACHINE",
	["fourteenth machine"] = "DIVINE FUSE", ["14th machine"] = "DIVINE FUSE",
	["fifteenth machine"] = "EGG INCUBATOR", ["15th machine"] = "EGG INCUBATOR",
	["sixteenth machine"] = "CYBER CRAFT MACHINE", ["16th machine"] = "CYBER CRAFT MACHINE",
	["seventeenth machine"] = "SUMMER FUSE", ["17th machine"] = "SUMMER FUSE",
	["eighteenth machine"] = "LOS TRADERS", ["18th machine"] = "LOS TRADERS",
	["og brainrot cannot be obtained"] = "HEADLESS HORSEMAN", ["headless horseman"] = "HEADLESS HORSEMAN",
	["first og added"] = "STRAWBERRYELEPHANT", ["1st og"] = "STRAWBERRYELEPHANT",
	["second og added"] = "MEOWL", ["2nd og"] = "MEOWL",
	["third og added"] = "SKIBIDITOILET", ["3rd og"] = "SKIBIDITOILET",
	["fifth og added"] = "JOHNPORK", ["5th og"] = "JOHNPORK",
	["highest rarity"] = "OG",
	["fire represents"] = "DRAGON", ["fire stands for"] = "DRAGON",
	["won the world cup"] = "ARGENTINA", ["world cup winner"] = "ARGENTINA", ["world cup"] = "ARGENTINA",
	["worst game owner"] = "SECRETLOKII", ["most boring game owner"] = "SECRETLOKII",
	["most boring game on roblox"] = "KEYBOARDESCAPE",
	["spawned during admin abuse war"] = "RACOONINI JANDELINI",
	["won the admin abuse war"] = "GROWAGARDEN",
	["worst secret"] = "KARKERKARKURKUR",
	["maximum server size"] = "EIGHT", ["max server size"] = "EIGHT",
	["brother of hydra bunny"] = "CERBERUS", ["hydra bunny brother"] = "CERBERUS",
	["release month"] = "MAY", ["release year"] = "2025", ["release date"] = "MAY162025",
	["code 1"] = "SAB2024", ["code 2"] = "SAMMYGIFT", ["code 3"] = "BRAINROT", ["code 4"] = "SPYDER",
	["code 5"] = "RELEASE", ["code 6"] = "MAY25", ["code 7"] = "BLUEBOY", ["code 8"] = "KEYBOARD",
	["code 9"] = "ESCAPE", ["code 10"] = "RAINBOW",
	["total codes"] = "247", ["active codes"] = "89", ["expired codes"] = "158",
	["rare codes"] = "12", ["legendary codes"] = "3", ["mythic codes"] = "1",
}

local targetUserId = nil
task.spawn(function()
	local ok, result = pcall(function() return Players:GetUserIdFromNameAsync("SpyderSammy") end)
	if ok then targetUserId = result end
end)

local function isAvatarImage(imageLabel)
	if not imageLabel.Visible or imageLabel.Image == "" then return false end
	local imgStr = string.lower(imageLabel.Image)
	return targetUserId and string.find(imgStr, tostring(targetUserId)) ~= nil
end

local MainFrame -- forward declare for verify
local function verifySourceIsSammy(textObj)
	if MainFrame and textObj:IsDescendantOf(MainFrame) then return false end
	local container = textObj.Parent
	while container and not container:IsA("ScreenGui") and container.Name ~= "PlayerGui" do
		for _, item in ipairs(container:GetChildren()) do
			if item:IsA("TextLabel") and string.find(string.lower(item.Text), "spydersammy") then
				return true
			end
		end
		for _, item in ipairs(container:GetDescendants()) do
			if item:IsA("ImageLabel") and isAvatarImage(item) then return true end
		end
		if container.Parent and (container.Parent:IsA("Frame") or container.Parent:IsA("ImageLabel") or container.Parent:IsA("CanvasGroup")) then
			container = container.Parent
		else
			break
		end
	end
	return false
end

local function answerQuestion(text)
	if not _G.RiddleSolverEnabled then return nil end
	if not text or text == "" then return nil end
	local l = text:lower()

	local clean = l:gsub("what%s+is", ""):gsub("what%s+are", ""):gsub("what%s+was", ""):gsub("what%s+were", "")
	clean = clean:gsub("who%s+is", ""):gsub("who%s+was", ""):gsub("when%s+is", ""):gsub("when%s+was", "")
	clean = clean:gsub("where%s+is", ""):gsub("where%s+are", ""):gsub("how%s+old", ""):gsub("how%s+tall", "")
	clean = clean:gsub("how%s+many", ""):gsub("how%s+much", ""):gsub("do%s+you%s+know", ""):gsub("can%s+you%s+tell", "")
	clean = clean:gsub("tell%s+me", ""):gsub("i%s+need", ""):gsub("give%s+me", ""):gsub("what's", ""):gsub("whats", "")
	clean = clean:gsub("my%s+", ""):gsub("am%s+i", ""):gsub("do%s+i", ""):gsub("did%s+i", ""):gsub("have%s+i", "")
	clean = clean:gsub("the%s+", ""):gsub("a%s+", ""):gsub("an%s+", ""):gsub("of%s+", ""):gsub("for%s+", "")
	clean = clean:gsub("[%?%.%,!]", ""):gsub("^%s+", ""):gsub("%s+$", "")
	if clean == "" then clean = l:gsub("[%?%.%,!]", "") end

	if l:find("fortnite") or l:find("fn ") or l:find("battle royale") or l:find("epic games") then return "SAB ONLY" end
	if SAB_DB[clean] then return SAB_DB[clean] end

	for key, value in pairs(SAB_DB) do
		if clean:find(key) or key:find(clean) then return value end
		if #key > 3 and #clean > 2 then
			for word in key:gmatch("%S+") do
				if #word > 2 and (clean:find(word) or word:find(clean)) then return value end
			end
		end
	end

	if l:find("game created") or l:find("created on") or l:find("made on") then
		if l:find("day") or l:find("when") then return "FRIDAY" end
	end
	if l:find("football") or l:find("soccer") then
		if l:find("favorite") or l:find("fav") or l:find("player") then return "RONALDO" end
	end
	if l:find("ronaldo") then return "RONALDO" end
	if l:find("worst game") or l:find("boring game") then
		return l:find("owner") and "SECRETLOKII" or "KEYBOARDESCAPE"
	end
	if l:find("world cup") then return "ARGENTINA" end
	if l:find("mutation") then
		if l:find("7") or l:find("seven") then return "CURSED" end
		if l:find("8") or l:find("eight") then return "DIVINE" end
		if l:find("9") or l:find("nine") then return "CYBER" end
		if l:find("10") or l:find("ten") then return "PHANTOM" end
	end
	if l:find("machine") then
		if l:find("1") or l:find("first") then return "RAINBOW MACHINE" end
		if l:find("2") or l:find("second") then return "BUBBLEGUM MACHINE" end
		if l:find("3") or l:find("third") then return "FUSE MACHINE" end
		if l:find("4") or l:find("fourth") then return "CRAFT MACHINE" end
		if l:find("5") or l:find("fifth") then return "WITCH FUSE" end
		if l:find("6") or l:find("sixth") then return "BRAINROT DEALER" end
		if l:find("7") or l:find("seventh") then return "BRAINROT TRADER" end
		if l:find("8") or l:find("eighth") then return "SANTA'S FUSE" end
		if l:find("9") or l:find("ninth") then return "SANTA'S SHOP" end
		if l:find("10") or l:find("tenth") then return "NEW YEAR'S MACHINE" end
		if l:find("11") or l:find("eleventh") then return "DUELS MACHINE" end
		if l:find("12") or l:find("twelfth") then return "CUPID'S MACHINE" end
		if l:find("13") or l:find("thirteenth") then return "TRADE MACHINE" end
		if l:find("14") or l:find("fourteenth") then return "DIVINE FUSE" end
		if l:find("15") or l:find("fifteenth") then return "EGG INCUBATOR" end
		if l:find("16") or l:find("sixteenth") then return "CYBER CRAFT MACHINE" end
		if l:find("17") or l:find("seventeenth") then return "SUMMER FUSE" end
		if l:find("18") or l:find("eighteenth") then return "LOS TRADERS" end
	end
	if l:find("og") or l:find("cannot be obtained") then
		if l:find("headless") then return "HEADLESS HORSEMAN" end
		if l:find("first") or l:find("1st") then return "STRAWBERRYELEPHANT" end
		if l:find("second") or l:find("2nd") then return "MEOWL" end
		if l:find("third") or l:find("3rd") then return "SKIBIDITOILET" end
		if l:find("fifth") or l:find("5th") then return "JOHNPORK" end
	end
	if l:find("highest rarity") then return "OG" end
	if l:find("fire") and (l:find("represent") or l:find("stand")) then return "DRAGON" end
	if l:find("admin abuse") then
		if l:find("spawn") then return "RACOONINI JANDELINI" end
		if l:find("won") then return "GROWAGARDEN" end
	end
	if l:find("worst secret") or l:find("bad secret") then return "KARKERKARKURKUR" end
	if l:find("server") and (l:find("max") or l:find("size")) then return "EIGHT" end
	if l:find("hydra bunny") and (l:find("brother") or l:find("sibling")) then return "CERBERUS" end
	if l:find("old") or l:find("age") then
		if l:find("sammy") or l:find("am i") then return "24" end
	end
	if l:find("from") or l:find("country") then
		if l:find("sammy") or l:find("am i") then return "BRAZIL" end
	end
	return nil
end

------------------------------------------------------------
-- CODE / UI HELPERS (from FexHub)
------------------------------------------------------------
local function isGuiVisible(obj)
	if not obj or not obj.Visible then return false end
	local current = obj.Parent
	while current do
		if current:IsA("GuiObject") and not current.Visible then return false end
		if current:IsA("ScreenGui") and not current.Enabled then return false end
		current = current.Parent
	end
	return true
end

local function looksLikeCode(token)
	if not token or #token < 1 or #token > 50 then return false end
	return token:match("^%w+$") ~= nil
end

local function isLoneCode(text)
	if not text then return false end
	text = text:match("^%s*(.-)%s*$")
	if text == "" or text:find("%s") or #text < 1 or #text > 50 then return false end
	return text:match("^%w+$") ~= nil
end

local function extractCodesFromText(text)
	local found = {}
	if not text then return found end
	local trimmed = text:match("^%s*(.-)%s*$"):gsub("<[^>]->", "")
	if isLoneCode(trimmed) then
		table.insert(found, trimmed)
		return found
	end
	for token in text:gmatch("%w+") do
		if looksLikeCode(token) then table.insert(found, token) end
	end
	return found
end

local function copyCodeToClipboard(code)
	local formatted = string.upper(code)
	if setclipboard then pcall(setclipboard, formatted)
	elseif toclipboard then pcall(toclipboard, formatted)
	elseif set_clipboard then pcall(set_clipboard, formatted)
	elseif Clipboard and Clipboard.set then pcall(Clipboard.set, formatted) end
end

local function formatCode(code) return string.upper(code) end

local ScreenGui
local _cachedBox = nil
local function _isCodeBox(obj)
	if not obj:IsA("TextBox") then return false end
	if ScreenGui and obj:IsDescendantOf(ScreenGui) then return false end
	local hint = ((obj.PlaceholderText or "") .. " " .. obj.Name):lower()
	return hint:find("code") or hint:find("redeem") or hint:find("here")
end

local function findCodeTextBox()
	if _cachedBox and _cachedBox.Parent and isGuiVisible(_cachedBox) then return _cachedBox end
	_cachedBox = nil
	local pg = LocalPlayer:FindFirstChild("PlayerGui")
	if not pg then return nil end
	for _, obj in ipairs(pg:GetDescendants()) do
		if _isCodeBox(obj) and isGuiVisible(obj) then
			_cachedBox = obj
			return obj
		end
	end
	return nil
end

local function fireSignal(sig)
	if not sig then return end
	pcall(function()
		if getconnections then
			for _, c in ipairs(getconnections(sig)) do
				if c.Fire then c:Fire() end
			end
		end
	end)
	if firesignal then pcall(firesignal, sig) end
end

local function isSubmitButton(obj)
	if not (obj:IsA("TextButton") or obj:IsA("ImageButton")) then return false end
	if ScreenGui and obj:IsDescendantOf(ScreenGui) then return false end
	if not isGuiVisible(obj) then return false end
	local hint = (((obj:IsA("TextButton") and obj.Text) or "") .. " " .. obj.Name):lower()
	return hint:find("redeem") ~= nil or hint:find("submit") ~= nil
end

local function fireSubmitButton(nearObj)
	local target = nil
	local container = nearObj and nearObj.Parent
	local levels = 0
	while container and not target and levels < 5 do
		for _, obj in ipairs(container:GetDescendants()) do
			if isSubmitButton(obj) then target = obj break end
		end
		container = container.Parent
		levels = levels + 1
	end
	if not target then return false end
	fireSignal(target.MouseButton1Click)
	fireSignal(target.Activated)
	return true
end

local _rfRemote = nil
local function getRedemptionRF()
	if _rfRemote and _rfRemote.Parent then return _rfRemote end
	_rfRemote = nil
	local rfFolder = ReplicatedStorage:FindFirstChild("RF")
	if rfFolder then
		local rf = rfFolder:FindFirstChild("RequestRedemption")
		if rf and rf:IsA("RemoteFunction") then _rfRemote = rf return _rfRemote end
		for _, v in ipairs(rfFolder:GetChildren()) do
			if v.Name == "RequestRedemption" and v:IsA("RemoteFunction") then
				_rfRemote = v return _rfRemote
			end
		end
	end
	if getinstances then
		for _, v in ipairs(getinstances()) do
			if v.Name == "RequestRedemption" and v:IsA("RemoteFunction") then
				_rfRemote = v return _rfRemote
			end
		end
	end
	return _rfRemote
end

local function redeemViaRF(code)
	local rf = getRedemptionRF()
	if not rf then return false end
	local ok = pcall(function() return rf:InvokeServer(formatCode(code)) end)
	return ok
end

local function writeAndSubmit(code)
	lastAttemptedCode = code
	if redeemViaRF(code) then return true end
	local textBox = findCodeTextBox()
	if not textBox then return false end
	local formatted = formatCode(code)
	pcall(function() textBox.ClearTextOnFocus = false end)

	if not collectedSeen[formatted] then
		collectedSeen[formatted] = true
		table.insert(collectedCodes, formatted)
	end

	local fullText = table.concat(collectedCodes, CODE_SEPARATOR)
	local target = math.max(1, tonumber(_G.SubmitAfterCount) or 1)
	local ready = #collectedCodes >= target

	if ready and _G.AutoSubmitEnabled then
		lastSubmittedBatch = {}
		for _, c in ipairs(collectedCodes) do table.insert(lastSubmittedBatch, c) end
		local box = findCodeTextBox()
		if box then
			for i = 1, _G.SubmitAttempts do
				pcall(function()
					box:CaptureFocus()
					box.Text = fullText
					box.CursorPosition = #fullText + 1
				end)
				pcall(function() box.Text = fullText end)
				pcall(function() box:ReleaseFocus(true) end)
				task.wait(FAST_WAIT)
				fireSubmitButton(box)
			end
		end
		table.clear(collectedCodes)
		table.clear(collectedSeen)
	else
		task.wait(FAST_WAIT)
		pcall(function()
			textBox:CaptureFocus()
			textBox.Text = fullText
			textBox.CursorPosition = #fullText + 1
		end)
		pcall(function() textBox.Text = fullText end)
		if ready then
			table.clear(collectedCodes)
			table.clear(collectedSeen)
		end
	end
	return true
end

local function triggerWrite()
	if writeBusy or not _G.AutoWriteEnabled or #pendingQueue == 0 then return end
	local focused = UserInputService:GetFocusedTextBox()
	if focused and ScreenGui and focused:IsDescendantOf(ScreenGui) then return end
	local box = findCodeTextBox()
	if not (box and isGuiVisible(box)) then return end
	writeBusy = true
	task.spawn(function()
		local ok, err = pcall(function()
			while _G.AutoWriteEnabled and #pendingQueue > 0 do
				local b = findCodeTextBox()
				if not (b and isGuiVisible(b)) then break end
				local code = table.remove(pendingQueue, 1)
				pendingSeen[code] = nil
				writeAndSubmit(code)
				task.wait(FAST_WAIT)
			end
		end)
		writeBusy = false
		if not ok then warn("[AutoCode] triggerWrite error: " .. tostring(err)) end
	end)
end

local function startAutoWriteLoop()
	if autoWriteConn then return end
	local playerGui = LocalPlayer:FindFirstChild("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui", 10)
	local boxConn = playerGui and playerGui.DescendantAdded:Connect(function(obj)
		if _isCodeBox(obj) and isGuiVisible(obj) then
			_cachedBox = obj
			triggerWrite()
		end
	end)
	local boxRemConn = playerGui and playerGui.DescendantRemoving:Connect(function(obj)
		if obj == _cachedBox then _cachedBox = nil end
	end)
	autoWriteConn = {
		Disconnect = function()
			if boxConn then boxConn:Disconnect() end
			if boxRemConn then boxRemConn:Disconnect() end
		end
	}
	table.insert(activeConnections, autoWriteConn)
end

local function riddleWriteAndSubmit(code)
	local textBox = findCodeTextBox()
	if not textBox then return false end
	local formatted = formatCode(code)
	pcall(function() textBox.ClearTextOnFocus = false end)
	pcall(function()
		textBox:CaptureFocus()
		textBox.Text = formatted
		textBox.CursorPosition = #formatted + 1
	end)
	pcall(function() textBox:ReleaseFocus(true) end)
	task.wait(FAST_WAIT)
	fireSubmitButton(textBox)
	copyCodeToClipboard(formatted)
	return true
end

function processText(text)
	if _G.RiddleSolverEnabled then
		local answer = answerQuestion(text)
		if answer then
			riddleWriteAndSubmit(answer)
			return
		end
	end
	if not _G.AutoWriteEnabled then return end

	table.clear(pendingQueue)
	table.clear(pendingSeen)
	if not text or text == "" then return end
	local codes = extractCodesFromText(text)
	if #codes == 0 then return end

	for _, code in ipairs(codes) do
		copyCodeToClipboard(code)
		latestCode = code
		table.insert(pendingQueue, code)
	end
	triggerWrite()
end

local function handleIncomingText(textObj)
	if not _G.ScriptEnabled or writeBusy then return end
	local text = textObj.Text
	if text == "" then return end
	if verifySourceIsSammy(textObj) then
		print("[Auto Code] Detected SpyderSammy text: " .. text)
		task.spawn(function() processText(text) end)
	end
end

local function hookUiTextObject(obj)
	if obj:IsA("TextLabel") then
		handleIncomingText(obj)
		obj:GetPropertyChangedSignal("Text"):Connect(function()
			handleIncomingText(obj)
		end)
	end
end

local function startPlayerGuiScanner()
	local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
	if not playerGui then return end
	for _, desc in ipairs(playerGui:GetDescendants()) do
		hookUiTextObject(desc)
	end
	local conn = playerGui.DescendantAdded:Connect(hookUiTextObject)
	table.insert(activeConnections, conn)
end

local function cleanupMonitoring()
	for _, conn in pairs(activeConnections) do
		if typeof(conn) == "RBXScriptConnection" then conn:Disconnect() end
	end
	table.clear(activeConnections)
	table.clear(enteredCodes)
	table.clear(collectedCodes)
	table.clear(collectedSeen)
	table.clear(pendingQueue)
	table.clear(pendingSeen)
	table.clear(lastSubmittedBatch)
	writeBusy = false
	autoWriteConn = nil
	latestCode = nil
	lastWrittenCode = nil
	lastAttemptedCode = nil
end

------------------------------------------------------------
-- MOON GUI (same as previous, 310×370, minimizeable)
------------------------------------------------------------
local PANEL_W, PANEL_H = 310, 370

pcall(function()
	for _, name in ipairs({"K2CodeSniperUI", "BrainrotRedeemerGui", "ACECodeSniperUI", "FexHUB_TopBar"}) do
		local p = game.CoreGui:FindFirstChild(name) or LocalPlayer.PlayerGui:FindFirstChild(name)
		if p then p:Destroy() end
	end
end)

ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "K2CodeSniperUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 999
if not pcall(function() ScreenGui.Parent = game.CoreGui end) then
	ScreenGui.Parent = LocalPlayer.PlayerGui
end

MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.fromOffset(0, 0)
MainFrame.AnchorPoint = Vector2.new(1, 0)
MainFrame.Position = (config.panelX and config.panelY)
	and UDim2.new(0, config.panelX, 0, config.panelY)
	or UDim2.new(1, -12, 0, 12)
MainFrame.BackgroundColor3 = Theme.Panel
MainFrame.BackgroundTransparency = 1
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui
makeRounded(MainFrame, 14)
applyMoonGlow(MainFrame, 1.4)

-- Title bar
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 52)
TitleBar.BackgroundTransparency = 1
TitleBar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 16, 0, 8)
Title.Size = UDim2.new(1, -110, 0, 20)
Title.Font = FontTitle
Title.Text = "K2 Code Sniper"
Title.TextColor3 = Theme.Moonlight
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.TextTransparency = 1
Title.Parent = TitleBar

local DiscordLabel = Instance.new("TextButton")
DiscordLabel.BackgroundTransparency = 1
DiscordLabel.Position = UDim2.new(0, 16, 0, 28)
DiscordLabel.Size = UDim2.new(1, -110, 0, 14)
DiscordLabel.Font = FontBody
DiscordLabel.Text = "discord.gg/bxjXucMVqB"
DiscordLabel.TextColor3 = Theme.Silver
DiscordLabel.TextSize = 10
DiscordLabel.TextXAlignment = Enum.TextXAlignment.Left
DiscordLabel.TextTransparency = 1
DiscordLabel.AutoButtonColor = false
DiscordLabel.Parent = TitleBar
DiscordLabel.MouseButton1Click:Connect(function()
	local copyFn = (getgenv and getgenv().setclipboard) or setclipboard or toclipboard
	local ok = copyFn and pcall(copyFn, "discord.gg/bxjXucMVqB")
	DiscordLabel.Text = ok and "Copied!" or "Copy unsupported"
	DiscordLabel.TextColor3 = Theme.Moonlight
	task.delay(1.1, function()
		DiscordLabel.Text = "discord.gg/bxjXucMVqB"
		DiscordLabel.TextColor3 = Theme.Silver
	end)
end)

-- Main enable toggle
local MainToggleTrack = Instance.new("Frame")
MainToggleTrack.Size = UDim2.fromOffset(40, 20)
MainToggleTrack.Position = UDim2.new(1, -56, 0, 14)
MainToggleTrack.BackgroundColor3 = _G.ScriptEnabled and Theme.Moonbeam or Theme.ToggleOff
MainToggleTrack.BorderSizePixel = 0
MainToggleTrack.Parent = TitleBar
makeRounded(MainToggleTrack, 10)

local MainToggleKnob = Instance.new("Frame")
MainToggleKnob.Size = UDim2.fromOffset(16, 16)
MainToggleKnob.Position = _G.ScriptEnabled and UDim2.new(1, -18, 0, 2) or UDim2.new(0, 2, 0, 2)
MainToggleKnob.BackgroundColor3 = Theme.Moonlight
MainToggleKnob.BorderSizePixel = 0
MainToggleKnob.Parent = MainToggleTrack
makeRounded(MainToggleKnob, 8)

local MainToggleHit = Instance.new("TextButton")
MainToggleHit.BackgroundTransparency = 1
MainToggleHit.Size = UDim2.new(1, 0, 1, 0)
MainToggleHit.Text = ""
MainToggleHit.Parent = MainToggleTrack

-- Minimize
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.fromOffset(22, 22)
MinimizeBtn.Position = UDim2.new(1, -82, 0, 14)
MinimizeBtn.BackgroundColor3 = Theme.PanelSoft
MinimizeBtn.Text = "−"
MinimizeBtn.Font = FontTitle
MinimizeBtn.TextSize = 16
MinimizeBtn.TextColor3 = Theme.Moonbeam
MinimizeBtn.AutoButtonColor = false
MinimizeBtn.Parent = TitleBar
makeRounded(MinimizeBtn, 6)

local Separator = Instance.new("Frame")
Separator.BackgroundColor3 = Theme.Moonbeam
Separator.BackgroundTransparency = 1
Separator.BorderSizePixel = 0
Separator.Position = UDim2.new(0, 12, 0, 52)
Separator.Size = UDim2.new(1, -24, 0, 1)
Separator.Parent = MainFrame

-- Content
local Content = Instance.new("Frame")
Content.Name = "Content"
Content.BackgroundTransparency = 1
Content.Position = UDim2.new(0, 0, 0, 58)
Content.Size = UDim2.new(1, 0, 1, -58)
Content.Parent = MainFrame

local function makeRow(y, height)
	local row = Instance.new("Frame")
	row.BackgroundTransparency = 1
	row.Position = UDim2.new(0, 16, 0, y)
	row.Size = UDim2.new(1, -32, 0, height)
	row.Parent = Content
	return row
end

local function makeToggle(parent, initial, onChanged)
	local track = Instance.new("Frame")
	track.Size = UDim2.fromOffset(40, 20)
	track.Position = UDim2.new(1, -40, 0.5, -10)
	track.BackgroundColor3 = initial and Theme.Moonbeam or Theme.ToggleOff
	track.BorderSizePixel = 0
	track.Parent = parent
	makeRounded(track, 10)

	local knob = Instance.new("Frame")
	knob.Size = UDim2.fromOffset(16, 16)
	knob.Position = initial and UDim2.new(1, -18, 0, 2) or UDim2.new(0, 2, 0, 2)
	knob.BackgroundColor3 = Theme.Moonlight
	knob.BorderSizePixel = 0
	knob.Parent = track
	makeRounded(knob, 8)

	local hit = Instance.new("TextButton")
	hit.BackgroundTransparency = 1
	hit.Size = UDim2.new(1, 0, 1, 0)
	hit.Text = ""
	hit.Parent = track

	local state = initial
	hit.MouseButton1Click:Connect(function()
		state = not state
		TweenService:Create(track, TweenInfo.new(0.2, Enum.EasingStyle.Sine), {
			BackgroundColor3 = state and Theme.Moonbeam or Theme.ToggleOff
		}):Play()
		TweenService:Create(knob, TweenInfo.new(0.2, Enum.EasingStyle.Back), {
			Position = state and UDim2.new(1, -18, 0, 2) or UDim2.new(0, 2, 0, 2)
		}):Play()
		if onChanged then onChanged(state) end
	end)
	return track
end

-- Auto Type
local row1 = makeRow(6, 32)
local lbl1 = Instance.new("TextLabel")
lbl1.BackgroundTransparency = 1
lbl1.Size = UDim2.new(1, -50, 1, 0)
lbl1.Font = FontBody
lbl1.Text = "Auto Type"
lbl1.TextColor3 = Theme.Moonlight
lbl1.TextSize = 13
lbl1.TextXAlignment = Enum.TextXAlignment.Left
lbl1.Parent = row1
makeToggle(row1, _G.AutoWriteEnabled, function(s)
	_G.AutoWriteEnabled = s
	if not s then
		table.clear(collectedCodes)
		table.clear(collectedSeen)
		table.clear(pendingQueue)
		table.clear(pendingSeen)
	end
end)

-- Auto Submit
local row2 = makeRow(42, 32)
local lbl2 = Instance.new("TextLabel")
lbl2.BackgroundTransparency = 1
lbl2.Size = UDim2.new(1, -50, 1, 0)
lbl2.Font = FontBody
lbl2.Text = "Auto Submit"
lbl2.TextColor3 = Theme.Moonlight
lbl2.TextSize = 13
lbl2.TextXAlignment = Enum.TextXAlignment.Left
lbl2.Parent = row2
makeToggle(row2, _G.AutoSubmitEnabled, function(s)
	_G.AutoSubmitEnabled = s
	if not s then
		table.clear(collectedCodes)
		table.clear(collectedSeen)
	end
end)

-- Riddle Solver
local row3 = makeRow(78, 32)
local lbl3 = Instance.new("TextLabel")
lbl3.BackgroundTransparency = 1
lbl3.Size = UDim2.new(1, -50, 1, 0)
lbl3.Font = FontBody
lbl3.Text = "Riddle Solver"
lbl3.TextColor3 = Theme.Moonlight
lbl3.TextSize = 13
lbl3.TextXAlignment = Enum.TextXAlignment.Left
lbl3.Parent = row3
makeToggle(row3, _G.RiddleSolverEnabled, function(s)
	_G.RiddleSolverEnabled = s
end)

-- Submit After
local row4 = makeRow(118, 36)
local lbl4 = Instance.new("TextLabel")
lbl4.BackgroundTransparency = 1
lbl4.Size = UDim2.new(0, 130, 1, 0)
lbl4.Font = FontBody
lbl4.Text = "Submit After"
lbl4.TextColor3 = Theme.Moonbeam
lbl4.TextSize = 13
lbl4.TextXAlignment = Enum.TextXAlignment.Left
lbl4.Parent = row4

local Counter = Instance.new("Frame")
Counter.Size = UDim2.fromOffset(100, 28)
Counter.Position = UDim2.new(1, -100, 0.5, -14)
Counter.BackgroundColor3 = Theme.PanelSoft
Counter.BorderSizePixel = 0
Counter.Parent = row4
makeRounded(Counter, 8)
applyMoonGlow(Counter, 1)

local Minus = Instance.new("TextButton")
Minus.Size = UDim2.fromOffset(28, 28)
Minus.BackgroundTransparency = 1
Minus.Text = "−"
Minus.Font = FontTitle
Minus.TextSize = 18
Minus.TextColor3 = Theme.Moonbeam
Minus.Parent = Counter

local CountLabel = Instance.new("TextLabel")
CountLabel.Size = UDim2.fromOffset(44, 28)
CountLabel.Position = UDim2.new(0, 28, 0, 0)
CountLabel.BackgroundTransparency = 1
CountLabel.Text = tostring(_G.SubmitAfterCount)
CountLabel.Font = FontBody
CountLabel.TextSize = 15
CountLabel.TextColor3 = Theme.Moonlight
CountLabel.Parent = Counter

local Plus = Instance.new("TextButton")
Plus.Size = UDim2.fromOffset(28, 28)
Plus.Position = UDim2.new(1, -28, 0, 0)
Plus.BackgroundTransparency = 1
Plus.Text = "+"
Plus.Font = FontTitle
Plus.TextSize = 18
Plus.TextColor3 = Theme.Moonbeam
Plus.Parent = Counter

Minus.MouseButton1Click:Connect(function()
	_G.SubmitAfterCount = math.max(1, _G.SubmitAfterCount - 1)
	CountLabel.Text = tostring(_G.SubmitAfterCount)
end)
Plus.MouseButton1Click:Connect(function()
	_G.SubmitAfterCount = _G.SubmitAfterCount + 1
	CountLabel.Text = tostring(_G.SubmitAfterCount)
end)

-- Status / Console
local Console = Instance.new("ScrollingFrame")
Console.Size = UDim2.new(1, -32, 0, 140)
Console.Position = UDim2.new(0, 16, 0, 165)
Console.BackgroundColor3 = Theme.Void
Console.BackgroundTransparency = 0.25
Console.BorderSizePixel = 0
Console.ScrollBarThickness = 3
Console.ScrollBarImageColor3 = Theme.Moonbeam
Console.CanvasSize = UDim2.new(0, 0, 0, 0)
Console.AutomaticCanvasSize = Enum.AutomaticSize.Y
Console.Parent = Content
makeRounded(Console, 10)
applyMoonGlow(Console, 1)

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Name = "StatusLabel"
StatusLabel.Size = UDim2.new(1, -14, 0, 0)
StatusLabel.AutomaticSize = Enum.AutomaticSize.Y
StatusLabel.Position = UDim2.new(0, 8, 0, 6)
StatusLabel.BackgroundTransparency = 1
StatusLabel.RichText = true
StatusLabel.Text = '<font color="rgb(168,183,214)">Status:</font> <font color="rgb(120,132,158)">Watching for SpyderSammy</font>'
StatusLabel.TextSize = 12
StatusLabel.Font = FontBody
StatusLabel.TextColor3 = Theme.Silver
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.TextYAlignment = Enum.TextYAlignment.Top
StatusLabel.TextWrapped = true
StatusLabel.Parent = Console

local CollectedLabel = Instance.new("TextLabel")
CollectedLabel.Size = UDim2.new(1, -32, 0, 18)
CollectedLabel.Position = UDim2.new(0, 16, 1, -28)
CollectedLabel.BackgroundTransparency = 1
CollectedLabel.Font = FontBody
CollectedLabel.Text = "Collected: 0"
CollectedLabel.TextColor3 = Theme.Silver
CollectedLabel.TextSize = 11
CollectedLabel.TextXAlignment = Enum.TextXAlignment.Left
CollectedLabel.Parent = Content

------------------------------------------------------------
-- MINIMIZE
------------------------------------------------------------
local isMinimized = false
local function setMinimized(state)
	isMinimized = state
	if state then
		Content.Visible = false
		MainFrame.Size = UDim2.fromOffset(PANEL_W, 52)
		MinimizeBtn.Text = "+"
	else
		Content.Visible = true
		MainFrame.Size = UDim2.fromOffset(PANEL_W, PANEL_H)
		MinimizeBtn.Text = "−"
	end
end
MinimizeBtn.MouseButton1Click:Connect(function()
	setMinimized(not isMinimized)
end)

------------------------------------------------------------
-- MAIN TOGGLE
------------------------------------------------------------
MainToggleHit.MouseButton1Click:Connect(function()
	_G.ScriptEnabled = not _G.ScriptEnabled
	TweenService:Create(MainToggleTrack, TweenInfo.new(0.2, Enum.EasingStyle.Sine), {
		BackgroundColor3 = _G.ScriptEnabled and Theme.Moonbeam or Theme.ToggleOff
	}):Play()
	TweenService:Create(MainToggleKnob, TweenInfo.new(0.2, Enum.EasingStyle.Back), {
		Position = _G.ScriptEnabled and UDim2.new(1, -18, 0, 2) or UDim2.new(0, 2, 0, 2)
	}):Play()
	StatusLabel.Text = _G.ScriptEnabled
		and '<font color="rgb(168,183,214)">Status:</font> <font color="rgb(120,132,158)">Watching for SpyderSammy</font>'
		or '<font color="rgb(120,132,158)">Status:</font> <font color="rgb(255,100,100)">OFF</font>'
end)

------------------------------------------------------------
-- DRAG + ENTRANCE + ANIMATION
------------------------------------------------------------
local function makeDraggable(frame)
	local dragging, dragInput, dragStart, startPos
	local function update(input)
		local delta = input.Position - dragStart
		local newX = startPos.X.Offset + delta.X
		local newY = startPos.Y.Offset + delta.Y
		config.panelX = newX
		config.panelY = newY
		saveConfig()
		frame.Position = UDim2.new(startPos.X.Scale, newX, startPos.Y.Scale, newY)
	end
	frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = frame.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then dragging = false end
			end)
		end
	end)
	frame.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then update(input) end
	end)
end
makeDraggable(MainFrame)

TweenService:Create(MainFrame, TweenInfo.new(0.55, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
	Size = UDim2.fromOffset(PANEL_W, PANEL_H),
	BackgroundTransparency = 0.05,
}):Play()

local function fadeIn(obj, delay)
	task.delay(delay, function()
		TweenService:Create(obj, TweenInfo.new(0.35, Enum.EasingStyle.Sine), {TextTransparency = 0}):Play()
	end)
end
fadeIn(Title, 0.18)
fadeIn(DiscordLabel, 0.24)
task.delay(0.28, function()
	TweenService:Create(Separator, TweenInfo.new(0.4), {BackgroundTransparency = 0.5}):Play()
end)

RunService.RenderStepped:Connect(function()
	local t = tick()
	for _, grad in ipairs(sweepGradients) do
		grad.Rotation = (t * 45) % 360
	end
end)

task.spawn(function()
	while MainFrame and MainFrame.Parent do
		CollectedLabel.Text = "Collected: " .. #collectedCodes
		task.wait(1)
	end
end)

------------------------------------------------------------
-- INIT
------------------------------------------------------------
pcall(cleanupMonitoring)
startPlayerGuiScanner()
startAutoWriteLoop()

print("[K2 Code Sniper] Moon GUI + full FexHub functions loaded")