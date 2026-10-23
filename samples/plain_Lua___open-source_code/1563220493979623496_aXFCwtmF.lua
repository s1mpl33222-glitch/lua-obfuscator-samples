--[========================================================================]--
-- ART OF AIM SCRIPTS - STABLE RECORDER + UNDETECTED MOVEMENT & INF-JUMP + HOPPER
-- Modern Switch UI Edition (Centered Toggle & Reddish 'A' Logo)
--[========================================================================]--

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer

local MY_NAME = "ART OF AIM SCRIPTS"
local SAVE_FILE_NAME = "recorded_path.json"
local INTERVAL = 0.05
local SPEED = 10 
local BASE_WALKSPEED = 16

-- Color Theme
local DARK_BG         = Color3.fromRGB(20, 20, 28)
local HEADER_BG       = Color3.fromRGB(35, 38, 55)
local ACCENT_RED      = Color3.fromRGB(220, 50, 70)
local SWITCH_BG_OFF   = Color3.fromRGB(45, 45, 60)
local SWITCH_BG_ON    = Color3.fromRGB(220, 50, 70)
local KNOB_COLOR      = Color3.fromRGB(255, 255, 255)
local BTN_COLOR       = Color3.fromRGB(50, 55, 80)

-- Determine Parent GUI safely
local parentGui = (gethui and gethui()) or game:GetService("CoreGui")
if not pcall(function() local x = parentGui.Name end) then
	parentGui = player:WaitForChild("PlayerGui")
end

-- Clean old instances
local oldGui = parentGui:FindFirstChild("RecorderGui")
if oldGui then
	oldGui:Destroy()
end

local gui = Instance.new("ScreenGui")
gui.Name = "RecorderGui"
gui.ResetOnSpawn = false

-- Open/Hide Draggable Toggle Button
local toggleContainer = Instance.new("Frame")
toggleContainer.Size = UDim2.new(0, 48, 0, 48)
toggleContainer.AnchorPoint = Vector2.new(0, 0.5)
toggleContainer.Position = UDim2.new(0, 15, 0.5, 0)
toggleContainer.BackgroundTransparency = 1
toggleContainer.Active = true
toggleContainer.Parent = gui

local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(1, 0, 1, 0)
toggleBtn.Position = UDim2.new(0, 0, 0, 0)
toggleBtn.BackgroundColor3 = Color3.fromRGB(80, 20, 30)
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.Font = Enum.Font.GothamBlack
toggleBtn.TextSize = 26
toggleBtn.Text = "A"
toggleBtn.AutoButtonColor = false
toggleBtn.Parent = toggleContainer

-- Reddish Gradient Texture Effect
local btnGradient = Instance.new("UIGradient")
btnGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 40, 60)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(90, 15, 25))
})
btnGradient.Rotation = 45
btnGradient.Parent = toggleBtn

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 12)
toggleCorner.Parent = toggleBtn

local toggleStroke = Instance.new("UIStroke")
toggleStroke.Color = ACCENT_RED
toggleStroke.Thickness = 2
toggleStroke.Parent = toggleBtn

local hideBadge = Instance.new("TextLabel")
hideBadge.Size = UDim2.new(0, 42, 0, 16)
hideBadge.Position = UDim2.new(0.5, -21, 0, -18)
hideBadge.BackgroundColor3 = Color3.fromRGB(40, 200, 100)
hideBadge.TextColor3 = Color3.fromRGB(255, 255, 255)
hideBadge.Font = Enum.Font.GothamBold
hideBadge.TextSize = 10
hideBadge.Text = "OPEN"
hideBadge.Parent = toggleContainer

local badgeCorner = Instance.new("UICorner")
badgeCorner.CornerRadius = UDim.new(0, 4)
badgeCorner.Parent = hideBadge

-- Draggable Toggle Icon Logic
local dragToggle, dragToggleStart, toggleStartPos
toggleBtn.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragToggle = true
		dragToggleStart = input.Position
		toggleStartPos = toggleContainer.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then dragToggle = false end
		end)
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragToggle and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - dragToggleStart
		toggleContainer.Position = UDim2.new(toggleStartPos.X.Scale, toggleStartPos.X.Offset + delta.X, toggleStartPos.Y.Scale, toggleStartPos.Y.Offset + delta.Y)
	end
end)

-- Main Menu Panel Frame
local OPEN_POS = UDim2.new(0, 75, 0.4, 0)
local HIDDEN_POS = UDim2.new(0, -250, 0.4, 0)

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 210, 0, 410)
frame.Position = HIDDEN_POS
frame.BackgroundColor3 = DARK_BG
frame.BorderSizePixel = 0
frame.Active = true
frame.ClipsDescendants = true
frame.Parent = gui

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 10)
frameCorner.Parent = frame

local frameStroke = Instance.new("UIStroke")
frameStroke.Color = ACCENT_RED
frameStroke.Thickness = 1.5
frameStroke.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 32)
title.BackgroundColor3 = HEADER_BG
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 12
title.Text = "  " .. MY_NAME
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = frame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 10)
titleCorner.Parent = title

local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 24, 0, 20)
minBtn.Position = UDim2.new(1, -28, 0, 6)
minBtn.BackgroundColor3 = DARK_BG
minBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 16
minBtn.Text = "-"
minBtn.ZIndex = 2
minBtn.Parent = title

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 4)
minCorner.Parent = minBtn

-- Helper to create Sliding Toggle Switch Control
local function createToggleSwitch(labelText, y, onToggle)
	local row = Instance.new("Frame")
	row.Size = UDim2.new(1, -20, 0, 28)
	row.Position = UDim2.new(0, 10, 0, y)
	row.BackgroundTransparency = 1
	row.Parent = frame

	local txtLabel = Instance.new("TextLabel")
	txtLabel.Size = UDim2.new(1, -50, 1, 0)
	txtLabel.BackgroundTransparency = 1
	txtLabel.TextColor3 = Color3.fromRGB(230, 230, 240)
	txtLabel.Font = Enum.Font.GothamMedium
	txtLabel.TextSize = 12
	txtLabel.TextXAlignment = Enum.TextXAlignment.Left
	txtLabel.Text = labelText
	txtLabel.Parent = row

	local track = Instance.new("TextButton")
	track.Size = UDim2.new(0, 42, 0, 22)
	track.Position = UDim2.new(1, -42, 0.5, -11)
	track.BackgroundColor3 = SWITCH_BG_OFF
	track.Text = ""
	track.AutoButtonColor = false
	track.Parent = row

	local trackCorner = Instance.new("UICorner")
	trackCorner.CornerRadius = UDim.new(1, 0)
	trackCorner.Parent = track

	local knob = Instance.new("Frame")
	knob.Size = UDim2.new(0, 16, 0, 16)
	knob.Position = UDim2.new(0, 3, 0.5, -8)
	knob.BackgroundColor3 = KNOB_COLOR
	knob.Parent = track

	local knobCorner = Instance.new("UICorner")
	knobCorner.CornerRadius = UDim.new(1, 0)
	knobCorner.Parent = knob

	local state = false

	local function setVisualState(newState)
		state = newState
		local targetKnobX = state and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
		local targetBg = state and SWITCH_BG_ON or SWITCH_BG_OFF
		TweenService:Create(knob, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = targetKnobX}):Play()
		TweenService:Create(track, TweenInfo.new(0.2), {BackgroundColor3 = targetBg}):Play()
	end

	track.Activated:Connect(function()
		state = not state
		setVisualState(state)
		if onToggle then onToggle(state) end
	end)

	return row, setVisualState
end

-- Helper to make Action Buttons
local function makeButton(text, y, height)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(1, -20, 0, height or 26)
	b.Position = UDim2.new(0, 10, 0, y)
	b.BackgroundColor3 = BTN_COLOR
	b.TextColor3 = Color3.fromRGB(255, 255, 255)
	b.Font = Enum.Font.GothamBold
	b.TextSize = 12
	b.Text = text
	b.Parent = frame
	local btnCorner = Instance.new("UICorner")
	btnCorner.CornerRadius = UDim.new(0, 6)
	btnCorner.Parent = b
	return b
end

local frames = {}
local recording = false
local recPaused = false
local playing = false
local looping = false
local infiniteJumpEnabled = false
local playTime, acc, idx = 0, 0, 1
local recordedDuration = 0

local setRecSwitch, setPauseSwitch, setPlaySwitch, setLoopSwitch, setInfJumpSwitch

local function saveRecordingToFile()
	pcall(function()
		if writefile and #frames > 0 then
			local exportData = {}
			for _, f in ipairs(frames) do
				local p = f.cf.Position
				local rx, ry, rz = f.cf:ToOrientation()
				table.insert(exportData, {
					x = p.X, y = p.Y, z = p.Z,
					rx = rx, ry = ry, rz = rz,
					t = f.t
				})
			end
			writefile(SAVE_FILE_NAME, HttpService:JSONEncode(exportData))
		end
	end)
end

local function stopRecording()
	recording = false
	recPaused = false
	if setRecSwitch then setRecSwitch(false) end
	if setPauseSwitch then setPauseSwitch(false) end
	saveRecordingToFile()
end

local function stopPlayback()
	playing = false
	if setPlaySwitch then setPlaySwitch(false) end
	local char = player.Character
	if char then
		local hum = char:FindFirstChildOfClass("Humanoid")
		if hum then 
			hum:Move(Vector3.new(0, 0, 0), false) 
			hum.PlatformStand = false
		end
	end
end

-- Create Modern Toggle Switches
local recRow
recRow, setRecSwitch = createToggleSwitch("● Record Path", 40, function(state)
	if playing then 
		setRecSwitch(false) 
		return 
	end
	recording = state
	if recording then
		frames = {}
		recordedDuration = 0
		acc = 0
		recPaused = false
		setPauseSwitch(false)
	else
		stopRecording()
	end
end)

local pauseRow
pauseRow, setPauseSwitch = createToggleSwitch("⏸ Pause Recording", 72, function(state)
	if not recording then 
		setPauseSwitch(false) 
		return 
	end
	recPaused = state
end)

local playRow
playRow, setPlaySwitch = createToggleSwitch("▶ Playback Path", 104, function(state)
	if recording or #frames < 2 then 
		setPlaySwitch(false) 
		return 
	end
	playing = state
	if playing then
		playTime = 0
		idx = 1
	else
		stopPlayback()
	end
end)

local loopRow
loopRow, setLoopSwitch = createToggleSwitch("⟳ Loop Path", 136, function(state)
	looping = state
end)

local infJumpRow
infJumpRow, setInfJumpSwitch = createToggleSwitch("🦘 Infinite Jump", 168, function(state)
	infiniteJumpEnabled = state
end)

local clearBtn = makeButton("🗑 Clear Saved Path", 204, 26)

local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(1, -20, 0, 18)
speedLabel.Position = UDim2.new(0, 10, 0, 238)
speedLabel.BackgroundTransparency = 1
speedLabel.TextColor3 = Color3.fromRGB(220, 220, 240)
speedLabel.Font = Enum.Font.GothamMedium
speedLabel.TextSize = 12
speedLabel.Text = "Speed: 10 (Normal)"
speedLabel.Parent = frame

local speedDownBtn = Instance.new("TextButton")
speedDownBtn.Size = UDim2.new(0.5, -13, 0, 26)
speedDownBtn.Position = UDim2.new(0, 10, 0, 258)
speedDownBtn.BackgroundColor3 = BTN_COLOR
speedDownBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
speedDownBtn.Font = Enum.Font.GothamBold
speedDownBtn.TextSize = 13
speedDownBtn.Text = "- Speed"
speedDownBtn.Parent = frame
local sdCorner = Instance.new("UICorner")
sdCorner.CornerRadius = UDim.new(0, 6)
sdCorner.Parent = speedDownBtn

local speedUpBtn = Instance.new("TextButton")
speedUpBtn.Size = UDim2.new(0.5, -13, 0, 26)
speedUpBtn.Position = UDim2.new(0.5, 3, 0, 258)
speedUpBtn.BackgroundColor3 = BTN_COLOR
speedUpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
speedUpBtn.Font = Enum.Font.GothamBold
speedUpBtn.TextSize = 13
speedUpBtn.Text = "+ Speed"
speedUpBtn.Parent = frame
local suCorner = Instance.new("UICorner")
suCorner.CornerRadius = UDim.new(0, 6)
suCorner.Parent = speedUpBtn

local timerLabel = Instance.new("TextLabel")
timerLabel.Size = UDim2.new(0.5, 0, 0, 28)
timerLabel.Position = UDim2.new(0, 0, 0, 292)
timerLabel.BackgroundTransparency = 1
timerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
timerLabel.Font = Enum.Font.GothamMedium
timerLabel.TextSize = 14
timerLabel.Text = "0:00.0"
timerLabel.Parent = frame

local hopBtn = Instance.new("TextButton")
hopBtn.Size = UDim2.new(0.5, -15, 0, 28)
hopBtn.Position = UDim2.new(0.5, 5, 0, 292)
hopBtn.BackgroundColor3 = BTN_COLOR
hopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
hopBtn.Font = Enum.Font.GothamBold
hopBtn.TextSize = 11
hopBtn.Text = "⇄ Server Hop"
hopBtn.Parent = frame
local hopCorner = Instance.new("UICorner")
hopCorner.CornerRadius = UDim.new(0, 6)
hopCorner.Parent = hopBtn

local credit = Instance.new("TextLabel")
credit.Size = UDim2.new(1, 0, 0, 24)
credit.Position = UDim2.new(0, 0, 1, -26)
credit.BackgroundTransparency = 1
credit.TextColor3 = Color3.fromRGB(255, 205, 60)
credit.Font = Enum.Font.GothamBold
credit.TextSize = 12
credit.Text = MY_NAME
credit.Parent = frame

local FULL_SIZE = frame.Size
local COLLAPSED_SIZE = UDim2.new(0, 210, 0, 32)

local collapsed = false
local bodyItems = {recRow, pauseRow, playRow, loopRow, infJumpRow, clearBtn, speedLabel, speedDownBtn, speedUpBtn, timerLabel, hopBtn, credit}

minBtn.Activated:Connect(function()
	collapsed = not collapsed
	for _, item in ipairs(bodyItems) do
		item.Visible = not collapsed
	end
	frame.Size = collapsed and COLLAPSED_SIZE or FULL_SIZE
	minBtn.Text = collapsed and "+" or "-"
end)

-- Smooth Slide Open/Hide Animation
local isMenuOpen = false
toggleBtn.Activated:Connect(function()
	isMenuOpen = not isMenuOpen	
	local targetPos = isMenuOpen and OPEN_POS or HIDDEN_POS
	local easeDir = isMenuOpen and Enum.EasingDirection.Out or Enum.EasingDirection.In
	local tweenInfo = TweenInfo.new(0.4, Enum.EasingStyle.Quart, easeDir)
	
	TweenService:Create(frame, tweenInfo, {Position = targetPos}):Play()
	
	if isMenuOpen then
		hideBadge.Text = "HIDE"
		hideBadge.BackgroundColor3 = ACCENT_RED
		toggleStroke.Color = ACCENT_RED
	else
		hideBadge.Text = "OPEN"
		hideBadge.BackgroundColor3 = Color3.fromRGB(40, 200, 100)
		toggleStroke.Color = Color3.fromRGB(40, 200, 100)
	end
end)

-- Draggable Main Menu
local dragging, dragStart, startPos
title.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = frame.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then dragging = false end
		end)
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local d = input.Position - dragStart
		frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
	end
end)

local function loadRecordingFromFile()
	pcall(function()
		if readfile and isfile and isfile(SAVE_FILE_NAME) then
			local content = readfile(SAVE_FILE_NAME)
			local data = HttpService:JSONDecode(content)
			if data and #data > 0 then
				frames = {}
				for _, f in ipairs(data) do
					local loadedCF
					if f.rx and f.ry and f.rz then
						loadedCF = CFrame.new(f.x, f.y, f.z) * CFrame.fromOrientation(f.rx, f.ry, f.rz)
					else
						loadedCF = CFrame.new(f.x, f.y, f.z)
					end
					table.insert(frames, {cf = loadedCF, t = f.t})
				end
				recordedDuration = frames[#frames].t
				timerLabel.Text = string.format("%d:%04.1f", math.floor(recordedDuration / 60), recordedDuration % 60)
			end
		end
	end)
end

local function getCharacterInfo()
	local char = player.Character
	if not char then return nil, nil end
	local root = char:FindFirstChild("HumanoidRootPart")
	local hum = char:FindFirstChildOfClass("Humanoid")
	return root, hum
end

local function applyWalkSpeed()
	local _, hum = getCharacterInfo()
	if hum then
		hum.WalkSpeed = (SPEED / 10) * BASE_WALKSPEED
	end
	speedLabel.Text = string.format("Speed: %d %s", SPEED, (SPEED == 10 and "(Normal)" or ""))
end

UserInputService.JumpRequest:Connect(function()
	if infiniteJumpEnabled then
		local _, hum = getCharacterInfo()
		if hum then
			hum:ChangeState(Enum.HumanoidStateType.Jumping)
		end
	end
end)

-- Main Loop
RunService.Heartbeat:Connect(function(dt)
	local root, hum = getCharacterInfo()
	if not root then return end

	if recording and not recPaused then
		acc = acc + dt
		if acc >= INTERVAL then
			acc = 0
			recordedDuration = recordedDuration + INTERVAL
			table.insert(frames, {cf = root.CFrame, t = recordedDuration})
			timerLabel.Text = string.format("%d:%04.1f", math.floor(recordedDuration / 60), recordedDuration % 60)
		end
	elseif playing then
		playTime = playTime + (dt * (SPEED / 10))

		while frames[idx + 1] and frames[idx + 1].t <= playTime do
			idx = idx + 1
		end

		if idx >= #frames then
			if looping then
				playTime = 0
				idx = 1
				return
			end
			stopPlayback()
			return
		end

		local a = frames[idx]
		local b = frames[idx + 1]
		local deltaT = math.max(b.t - a.t, 0.0001)
		local alpha = math.clamp((playTime - a.t) / deltaT, 0, 1)

		local targetCF = a.cf:Lerp(b.cf, alpha)
		local moveDelta = (targetCF.Position - root.Position)
		
		if hum and hum.PlatformStand then
			hum.PlatformStand = false
		end

		if moveDelta.Magnitude > 0.01 then
			local dir = moveDelta.Unit
			if hum then
				hum:Move(dir, false)
			end
			root.AssemblyLinearVelocity = dir * (SPEED * 1.6)
		else
			if hum then
				hum:Move(Vector3.new(0,0,0), false)
			end
			root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
		end

		root.CFrame = targetCF
		root.AssemblyAngularVelocity = Vector3.new(0, 0, 0)

		timerLabel.Text = string.format("%d:%04.1f", math.floor(playTime / 60), playTime % 60)
	else
		if hum and hum.PlatformStand then
			hum.PlatformStand = false
		end
	end
end)

clearBtn.Activated:Connect(function()
	if playing or recording then return end
	frames = {}
	recordedDuration = 0
	timerLabel.Text = "0:00.0"
	pcall(function()
		if delfile and isfile and isfile(SAVE_FILE_NAME) then
			delfile(SAVE_FILE_NAME)
		end
	end)
	clearBtn.Text = "✓ Cleared!"
	task.delay(1, function() clearBtn.Text = "🗑 Clear Saved Path" end)
end)

speedUpBtn.Activated:Connect(function()
	if SPEED < 50 then
		SPEED = SPEED + 1
		applyWalkSpeed()
	end
end)

speedDownBtn.Activated:Connect(function()
	if SPEED > 1 then
		SPEED = SPEED - 1
		applyWalkSpeed()
	end
end)

-- Safe Execution Server Hopper
hopBtn.Activated:Connect(function()
	task.spawn(function()
		hopBtn.Text = "⏳ Hopping..."
		local placeId = game.PlaceId
		local currentJobId = game.JobId
		local targetServerId = nil

		pcall(function()
			local reqFunc = (syn and syn.request) or request or http_request or (fluxus and fluxus.request)
			local rawData = nil
			local url = string.format("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100", placeId)

			if reqFunc then
				local response = reqFunc({ Url = url, Method = "GET" })
				if response and response.Body then rawData = response.Body end
			elseif game.HttpGet then
				rawData = game:HttpGet(url)
			end

			if rawData then
				local parsed = HttpService:JSONDecode(rawData)
				if parsed and parsed.data then
					for _, server in ipairs(parsed.data) do
						if server.id ~= currentJobId and server.playing and server.maxPlayers and server.playing < server.maxPlayers then
							targetServerId = server.id
							break
						end
					end
				end
			end
		end)

		if targetServerId then
			pcall(function()
				TeleportService:TeleportToPlaceInstance(placeId, targetServerId, player)
			end)
		else
			pcall(function()
				TeleportService:Teleport(placeId, player)
			end)
		end

		task.delay(2, function()
			hopBtn.Text = "⇄ Server Hop"
		end)
	end)
end)

gui.Parent = parentGui

player.CharacterAdded:Connect(function(char)
	char:WaitForChild("Humanoid")
	task.wait(0.2)
	applyWalkSpeed()
end)

loadRecordingFromFile()
applyWalkSpeed()
