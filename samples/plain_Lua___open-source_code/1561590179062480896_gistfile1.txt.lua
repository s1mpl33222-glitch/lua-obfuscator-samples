local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera
local playerGui = player:WaitForChild("PlayerGui")

if playerGui:FindFirstChild("FreecamGui") then playerGui.FreecamGui:Destroy() end
if playerGui:FindFirstChild("FreecamSetupGui") then playerGui.FreecamSetupGui:Destroy() end

local setupGui = Instance.new("ScreenGui")
setupGui.Name = "FreecamSetupGui"
setupGui.ResetOnSpawn = false
setupGui.Parent = playerGui

local setupFrame = Instance.new("Frame")
setupFrame.Size = UDim2.new(0, 280, 0, 160)
setupFrame.Position = UDim2.new(0.5, -140, 0.5, -80)
setupFrame.BackgroundColor3 = Color3.fromRGB(20, 22, 28)
setupFrame.BorderSizePixel = 0
setupFrame.Parent = setupGui

Instance.new("UICorner", setupFrame).CornerRadius = UDim.new(0, 16)

local setupStroke = Instance.new("UIStroke", setupFrame)
setupStroke.Color = Color3.fromRGB(0, 170, 255)
setupStroke.Thickness = 2

local setupTitle = Instance.new("TextLabel")
setupTitle.Size = UDim2.new(1, 0, 0, 45)
setupTitle.BackgroundTransparency = 1
setupTitle.Text = "SELECT DEVICE MODE"
setupTitle.TextColor3 = Color3.fromRGB(240, 240, 255)
setupTitle.TextSize = 18
setupTitle.Font = Enum.Font.GothamBold
setupTitle.Parent = setupFrame

local pcBtn = Instance.new("TextButton")
pcBtn.Size = UDim2.new(0, 110, 0, 55)
pcBtn.Position = UDim2.new(0, 20, 0, 70)
pcBtn.BackgroundColor3 = Color3.fromRGB(35, 90, 220)
pcBtn.Text = "🖥️ PC"
pcBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
pcBtn.TextSize = 20
pcBtn.Font = Enum.Font.GothamBold
pcBtn.Parent = setupFrame
Instance.new("UICorner", pcBtn).CornerRadius = UDim.new(0, 12)

local pcStroke = Instance.new("UIStroke", pcBtn)
pcStroke.Color = Color3.fromRGB(100, 180, 255)
pcStroke.Thickness = 1.5

local mobileBtn = Instance.new("TextButton")
mobileBtn.Size = UDim2.new(0, 110, 0, 55)
mobileBtn.Position = UDim2.new(0, 150, 0, 70)
mobileBtn.BackgroundColor3 = Color3.fromRGB(220, 90, 35)
mobileBtn.Text = "📱 Mobile"
mobileBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
mobileBtn.TextSize = 20
mobileBtn.Font = Enum.Font.GothamBold
mobileBtn.Parent = setupFrame
Instance.new("UICorner", mobileBtn).CornerRadius = UDim.new(0, 12)

local mobileStroke = Instance.new("UIStroke", mobileBtn)
mobileStroke.Color = Color3.fromRGB(255, 160, 100)
mobileStroke.Thickness = 1.5

local function startFreecamSystem(isMobileMode)
	setupGui:Destroy()

	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "FreecamGui"
	screenGui.ResetOnSpawn = false
	screenGui.Parent = playerGui

	local menuFrame = Instance.new("Frame")
	menuFrame.Name = "MenuFrame"
	menuFrame.Size = UDim2.new(0, 240, 0, 75)
	menuFrame.Position = UDim2.new(1, -250, 0, 15)
	menuFrame.BackgroundColor3 = Color3.fromRGB(18, 20, 26)
	menuFrame.BackgroundTransparency = 0.15
	menuFrame.BorderSizePixel = 0
	menuFrame.Parent = screenGui
	Instance.new("UICorner", menuFrame).CornerRadius = UDim.new(0, 14)

	local menuStroke = Instance.new("UIStroke", menuFrame)
	menuStroke.Color = Color3.fromRGB(70, 75, 95)
	menuStroke.Thickness = 1.5

	local minimizeBtn = Instance.new("TextButton")
	minimizeBtn.Size = UDim2.new(0, 24, 0, 24)
	minimizeBtn.Position = UDim2.new(0, 6, 0, -8)
	minimizeBtn.BackgroundColor3 = Color3.fromRGB(35, 40, 55)
	minimizeBtn.Text = "-"
	minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	minimizeBtn.TextSize = 18
	minimizeBtn.Font = Enum.Font.GothamBold
	minimizeBtn.Parent = menuFrame
	Instance.new("UICorner", minimizeBtn).CornerRadius = UDim.new(1, 0)

	local minBtnStroke = Instance.new("UIStroke", minimizeBtn)
	minBtnStroke.Color = Color3.fromRGB(100, 110, 140)
	minBtnStroke.Thickness = 1

	local miniOpenBtn = Instance.new("TextButton")
	miniOpenBtn.Size = UDim2.new(0, 80, 0, 36)
	miniOpenBtn.Position = menuFrame.Position
	miniOpenBtn.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
	miniOpenBtn.Text = "Freecam"
	miniOpenBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	miniOpenBtn.TextSize = 13
	miniOpenBtn.Font = Enum.Font.GothamBold
	miniOpenBtn.Visible = false
	miniOpenBtn.Parent = screenGui
	Instance.new("UICorner", miniOpenBtn).CornerRadius = UDim.new(0, 18)

	local miniStroke = Instance.new("UIStroke", miniOpenBtn)
	miniStroke.Color = Color3.fromRGB(0, 170, 255)
	miniStroke.Thickness = 1.5

	minimizeBtn.MouseButton1Click:Connect(function()
		miniOpenBtn.Position = menuFrame.Position
		menuFrame.Visible = false
		miniOpenBtn.Visible = true
	end)

	miniOpenBtn.MouseButton1Click:Connect(function()
		menuFrame.Position = miniOpenBtn.Position
		miniOpenBtn.Visible = false
		menuFrame.Visible = true
	end)

	local mainBtn = Instance.new("TextButton")
	mainBtn.Size = UDim2.new(0, 52, 0, 52)
	mainBtn.Position = UDim2.new(0, 10, 0, 12)
	mainBtn.BackgroundColor3 = Color3.fromRGB(235, 55, 75)
	mainBtn.Text = "CAM"
	mainBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	mainBtn.TextSize = 15
	mainBtn.Font = Enum.Font.GothamBold
	mainBtn.Parent = menuFrame
	Instance.new("UICorner", mainBtn).CornerRadius = UDim.new(1, 0)

	local mainBtnStroke = Instance.new("UIStroke", mainBtn)
	mainBtnStroke.Color = Color3.fromRGB(255, 120, 130)
	mainBtnStroke.Thickness = 2

	local moveSpeed = 35
	local speedInput = Instance.new("TextBox")
	speedInput.Size = UDim2.new(0, 58, 0, 34)
	speedInput.Position = UDim2.new(0, 70, 0, 12)
	speedInput.BackgroundColor3 = Color3.fromRGB(30, 35, 48)
	speedInput.Text = "35"
	speedInput.PlaceholderText = "35"
	speedInput.TextColor3 = Color3.fromRGB(0, 210, 255)
	speedInput.TextSize = 15
	speedInput.Font = Enum.Font.GothamBold
	speedInput.Parent = menuFrame
	Instance.new("UICorner", speedInput).CornerRadius = UDim.new(0, 8)

	local speedInputStroke = Instance.new("UIStroke", speedInput)
	speedInputStroke.Color = Color3.fromRGB(0, 170, 255)
	speedInputStroke.Thickness = 1.2

	local speedLabel = Instance.new("TextLabel")
	speedLabel.Size = UDim2.new(0, 58, 0, 16)
	speedLabel.Position = UDim2.new(0, 70, 0, 48)
	speedLabel.BackgroundTransparency = 1
	speedLabel.Text = "⚡ Speed"
	speedLabel.TextColor3 = Color3.fromRGB(170, 180, 200)
	speedLabel.TextSize = 11
	speedLabel.Font = Enum.Font.GothamMedium
	speedLabel.Parent = menuFrame

	speedInput.FocusLost:Connect(function()
		local val = tonumber(speedInput.Text)
		if val then
			moveSpeed = val
		else
			speedInput.Text = tostring(moveSpeed)
		end
	end)

	local camSensitivity = 0.25
	local senInput = Instance.new("TextBox")
	senInput.Size = UDim2.new(0, 58, 0, 34)
	senInput.Position = UDim2.new(0, 136, 0, 12)
	senInput.BackgroundColor3 = Color3.fromRGB(30, 35, 48)
	senInput.Text = "0.25"
	senInput.PlaceholderText = "0.25"
	senInput.TextColor3 = Color3.fromRGB(190, 100, 255)
	senInput.TextSize = 15
	senInput.Font = Enum.Font.GothamBold
	senInput.Parent = menuFrame
	Instance.new("UICorner", senInput).CornerRadius = UDim.new(0, 8)

	local senInputStroke = Instance.new("UIStroke", senInput)
	senInputStroke.Color = Color3.fromRGB(170, 80, 255)
	senInputStroke.Thickness = 1.2

	local senLabel = Instance.new("TextLabel")
	senLabel.Size = UDim2.new(0, 58, 0, 16)
	senLabel.Position = UDim2.new(0, 136, 0, 48)
	senLabel.BackgroundTransparency = 1
	senLabel.Text = "🎯 Sen"
	senLabel.TextColor3 = Color3.fromRGB(170, 180, 200)
	senLabel.TextSize = 11
	senLabel.Font = Enum.Font.GothamMedium
	senLabel.Parent = menuFrame

	senInput.FocusLost:Connect(function()
		local val = tonumber(senInput.Text)
		if val then
			camSensitivity = val
		else
			senInput.Text = tostring(camSensitivity)
		end
	end)

	local lockBtn = Instance.new("TextButton")
	lockBtn.Size = UDim2.new(0, 26, 0, 26)
	lockBtn.Position = UDim2.new(1, -30, 0, 12)
	lockBtn.BackgroundColor3 = Color3.fromRGB(45, 50, 68)
	lockBtn.Text = "🔓"
	lockBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	lockBtn.TextSize = 13
	lockBtn.Font = Enum.Font.GothamBold
	lockBtn.Parent = menuFrame
	Instance.new("UICorner", lockBtn).CornerRadius = UDim.new(0, 6)

	local isMenuLocked = false
	lockBtn.MouseButton1Click:Connect(function()
		isMenuLocked = not isMenuLocked
		if isMenuLocked then
			lockBtn.Text = "🔒"
			lockBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
		else
			lockBtn.Text = "🔓"
			lockBtn.BackgroundColor3 = Color3.fromRGB(45, 50, 68)
		end
	end)

	local draggingMenu = false
	local activeDragInput = nil
	local dragStartMouse = Vector2.zero
	local dragStartPos = Vector2.zero

	menuFrame.InputBegan:Connect(function(input)
		if isMenuLocked then return end
		if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and not activeDragInput then
			local pos = input.Position
			local lockPos = lockBtn.AbsolutePosition
			local lockSize = lockBtn.AbsoluteSize
			local inLock = (pos.X >= lockPos.X and pos.X <= lockPos.X + lockSize.X and pos.Y >= lockPos.Y and pos.Y <= lockPos.Y + lockSize.Y)
			
			local mainPos = mainBtn.AbsolutePosition
			local mainSize = mainBtn.AbsoluteSize
			local inMain = (pos.X >= mainPos.X and pos.X <= mainPos.X + mainSize.X and pos.Y >= mainPos.Y and pos.Y <= mainPos.Y + mainSize.Y)

			local minPos = minimizeBtn.AbsolutePosition
			local minSize = minimizeBtn.AbsoluteSize
			local inMin = (pos.X >= minPos.X and pos.X <= minPos.X + minSize.X and pos.Y >= minPos.Y and pos.Y <= minPos.Y + minSize.Y)

			if not inLock and not inMain and not inMin and not speedInput:IsFocused() and not senInput:IsFocused() then
				draggingMenu = true
				activeDragInput = input
				dragStartMouse = Vector2.new(input.Position.X, input.Position.Y)
				dragStartPos = menuFrame.AbsolutePosition
			end
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if draggingMenu and input == activeDragInput then
			local mousePos = Vector2.new(input.Position.X, input.Position.Y)
			local delta = mousePos - dragStartMouse
			menuFrame.Position = UDim2.new(0, dragStartPos.X + delta.X, 0, dragStartPos.Y + delta.Y)
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input == activeDragInput then
			draggingMenu = false
			activeDragInput = nil
		end
	end)

	local controlFrame = Instance.new("Frame")
	controlFrame.Name = "CamControls"
	controlFrame.Size = UDim2.new(0, 200, 0, 200)
	controlFrame.Position = UDim2.new(0.04, 0, 0.45, 0)
	controlFrame.BackgroundTransparency = 1
	controlFrame.Visible = false
	controlFrame.Parent = screenGui

	local moveStates = {
		Forward = false,
		Backward = false,
		Left = false,
		Right = false,
		Up = false,
		Down = false
	}

	if isMobileMode then
		local function bindTouchButton(btn, directionKey)
			btn.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
					moveStates[directionKey] = true
				end
			end)

			btn.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
					moveStates[directionKey] = false
				end
			end)
		end

		local function createDirBtn(name, text, pos, size, dirKey)
			local btn = Instance.new("TextButton")
			btn.Name = name
			btn.Size = size
			btn.Position = pos
			btn.BackgroundColor3 = Color3.fromRGB(20, 24, 32)
			btn.BackgroundTransparency = 0.2
			btn.Text = text
			btn.TextColor3 = Color3.fromRGB(255, 255, 255)
			btn.TextSize = 26
			btn.Font = Enum.Font.GothamBold
			btn.Parent = controlFrame
			Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)

			local btnStroke = Instance.new("UIStroke", btn)
			btnStroke.Color = Color3.fromRGB(0, 170, 255)
			btnStroke.Thickness = 2
			
			bindTouchButton(btn, dirKey)
			return btn
		end

		createDirBtn("Forward", "▲", UDim2.new(0.35, 0, 0, 0), UDim2.new(0, 60, 0, 60), "Forward")
		createDirBtn("Backward", "▼", UDim2.new(0.35, 0, 0.68, 0), UDim2.new(0, 60, 0, 60), "Backward")
		createDirBtn("Left", "◄", UDim2.new(0, 0, 0.34, 0), UDim2.new(0, 60, 0, 60), "Left")
		createDirBtn("Right", "►", UDim2.new(0.7, 0, 0.34, 0), UDim2.new(0, 60, 0, 60), "Right")
		createDirBtn("Up", "▲", UDim2.new(1.18, 0, 0.05, 0), UDim2.new(0, 52, 0, 52), "Up")
		createDirBtn("Down", "▼", UDim2.new(1.18, 0, 0.58, 0), UDim2.new(0, 52, 0, 52), "Down")
	end

	local isFreecam = false
	local camPos = Vector3.new()
	local rotX, rotY = 0, 0

	local function resetCameraToPlayer()
		local character = player.Character
		if character then
			local humanoid = character:FindFirstChildOfClass("Humanoid")
			local rootPart = character:FindFirstChild("HumanoidRootPart")
			
			if rootPart then rootPart.Anchored = false end
			if humanoid then 
				humanoid.WalkSpeed = 16 
				humanoid.JumpPower = 50 
				camera.CameraSubject = humanoid
			end
		end
		
		ContextActionService:UnbindAction("DisableCharacterMovement")
		camera.CameraType = Enum.CameraType.Custom
	end

	local function setCharacterFrozen(frozen)
		local character = player.Character
		if not character then return end
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		local rootPart = character:FindFirstChild("HumanoidRootPart")

		if frozen then
			if rootPart then rootPart.Anchored = true end
			if humanoid then 
				humanoid.WalkSpeed = 0 
				humanoid.JumpPower = 0 
				humanoid:UnequipTools()
			end
			
			ContextActionService:BindActionAtPriority(
				"DisableCharacterMovement",
				function() return Enum.ContextActionResult.Sink end,
				false,
				10000,
				Enum.PlayerActions.CharacterForward,
				Enum.PlayerActions.CharacterBackward,
				Enum.PlayerActions.CharacterLeft,
				Enum.PlayerActions.CharacterRight,
				Enum.PlayerActions.CharacterJump
			)
		else
			resetCameraToPlayer()
		end
	end

	mainBtn.MouseButton1Click:Connect(function()
		isFreecam = not isFreecam

		if isFreecam then
			mainBtn.BackgroundColor3 = Color3.fromRGB(45, 215, 115)
			mainBtnStroke.Color = Color3.fromRGB(120, 255, 170)
			if isMobileMode then controlFrame.Visible = true end
			
			camPos = camera.CFrame.Position
			local rx, ry, _ = camera.CFrame:ToOrientation()
			rotX, rotY = math.deg(rx), math.deg(ry)
			
			camera.CameraType = Enum.CameraType.Scriptable
			setCharacterFrozen(true)
		else
			mainBtn.BackgroundColor3 = Color3.fromRGB(235, 55, 75)
			mainBtnStroke.Color = Color3.fromRGB(255, 120, 130)
			if isMobileMode then controlFrame.Visible = false end
			
			for k in pairs(moveStates) do moveStates[k] = false end
			setCharacterFrozen(false)
		end
	end)

	player.CharacterAdded:Connect(function()
		if not isFreecam then
			task.wait(0.2)
			resetCameraToPlayer()
		end
	end)

	local activeCamTouch = nil
	local lastTouchPos = Vector2.zero

	UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if not isFreecam or draggingMenu then return end
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			local pos = input.Position
			local menuPos = menuFrame.AbsolutePosition
			local menuSize = menuFrame.AbsoluteSize
			
			local inMenu = (pos.X >= menuPos.X and pos.X <= menuPos.X + menuSize.X and pos.Y >= menuPos.Y and pos.Y <= menuPos.Y + menuSize.Y)
			local inControls = false
			if isMobileMode and controlFrame.Visible then
				local ctrlPos = controlFrame.AbsolutePosition
				local ctrlSize = controlFrame.AbsoluteSize
				inControls = (pos.X >= ctrlPos.X and pos.X <= ctrlPos.X + ctrlSize.X * 1.5 and pos.Y >= ctrlPos.Y and pos.Y <= ctrlPos.Y + ctrlSize.Y)
			end

			if not inMenu and not inControls and not activeCamTouch then
				activeCamTouch = input
				lastTouchPos = Vector2.new(pos.X, pos.Y)
			end
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if not isFreecam or input ~= activeCamTouch then return end
		local currentPos = Vector2.new(input.Position.X, input.Position.Y)
		local delta = currentPos - lastTouchPos
		lastTouchPos = currentPos

		rotY = rotY - delta.X * camSensitivity
		rotX = math.clamp(rotX - delta.Y * camSensitivity, -80, 80)
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input == activeCamTouch then
			activeCamTouch = nil
		end
	end)

	RunService.RenderStepped:Connect(function(dt)
		if not isFreecam then return end

		local targetRotation = CFrame.Angles(0, math.rad(rotY), 0) * CFrame.Angles(math.rad(rotX), 0, 0)
		local moveVector = Vector3.new()

		if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveVector = moveVector + Vector3.new(0, 0, -1) end
		if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveVector = moveVector + Vector3.new(0, 0, 1) end
		if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveVector = moveVector + Vector3.new(-1, 0, 0) end
		if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveVector = moveVector + Vector3.new(1, 0, 0) end
		if UserInputService:IsKeyDown(Enum.KeyCode.E) then moveVector = moveVector + Vector3.new(0, 1, 0) end
		if UserInputService:IsKeyDown(Enum.KeyCode.Q) then moveVector = moveVector + Vector3.new(0, -1, 0) end

		if moveStates.Forward then moveVector = moveVector + Vector3.new(0, 0, -1) end
		if moveStates.Backward then moveVector = moveVector + Vector3.new(0, 0, 1) end
		if moveStates.Left then moveVector = moveVector + Vector3.new(-1, 0, 0) end
		if moveStates.Right then moveVector = moveVector + Vector3.new(1, 0, 0) end
		if moveStates.Up then moveVector = moveVector + Vector3.new(0, 1, 0) end
		if moveStates.Down then moveVector = moveVector + Vector3.new(0, -1, 0) end

		local currentSpd = moveSpeed * dt
		camPos = camPos + (targetRotation * moveVector * currentSpd)
		
		camera.CFrame = CFrame.new(camPos) * targetRotation
	end)

	pcall(function()
		StarterGui:SetCore("SendNotification", {
			Title = "Freecam System",
			Text = "Successfully Loaded!",
			Duration = 4
		})
	end)
end

pcBtn.MouseButton1Click:Connect(function() startFreecamSystem(false) end)
mobileBtn.MouseButton1Click:Connect(function() startFreecamSystem(true) end)
