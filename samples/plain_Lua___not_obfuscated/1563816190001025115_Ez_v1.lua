--------------------------------------------------------------------------------
-- 0. DÉSACTIVATION DE L'ANCIEN SCRIPT SI DÉJÀ EXÉCUTÉ
--------------------------------------------------------------------------------
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

if playerGui:FindFirstChild("EzKukirinGui") then
	playerGui.EzKukirinGui:Destroy()
end

-- Variables globales
local savedCFrame = nil
local waitTimeSetting = 1
local speedMultiplier = 0.8
local flySpeedMultiplier = 0.8
local flyHeightSetting = 5
local isWheelieActive = false

--------------------------------------------------------------------------------
-- 1. CRÉATION DU SCREEN GUI
--------------------------------------------------------------------------------
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "EzKukirinGui"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = playerGui

--------------------------------------------------------------------------------
-- SYSTÈMES DE DRAG
--------------------------------------------------------------------------------
local function makeDraggable(guiObject, dragHandle)
	dragHandle = dragHandle or guiObject
	local dragging = false
	local dragInput, dragStart, startPos

	dragHandle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = guiObject.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	dragHandle.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			local delta = input.Position - dragStart
			guiObject.Position = UDim2.new(
				startPos.X.Scale, startPos.X.Offset + delta.X,
				startPos.Y.Scale, startPos.Y.Offset + delta.Y
			)
		end
	end)
end

--------------------------------------------------------------------------------
-- 2. INTERFACE PRINCIPALE (Hauteur réduite à 420px pour supprimer l'espace vide)
--------------------------------------------------------------------------------
local mainContainer = Instance.new("Folder")
mainContainer.Name = "MainContainer"
mainContainer.Parent = screenGui

-- Bouton Toggle (Tout rose, tout en haut au milieu)
local toggleBtn = Instance.new("TextButton")
toggleBtn.Name = "ToggleBtn"
toggleBtn.Size = UDim2.new(0, 90, 0, 26)
toggleBtn.Position = UDim2.new(0.5, -45, 0, 10)
toggleBtn.Text = "Toggle"
toggleBtn.TextSize = 12
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
toggleBtn.BorderSizePixel = 0
toggleBtn.Parent = mainContainer

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 6)
toggleCorner.Parent = toggleBtn

local toggleStroke = Instance.new("UIStroke")
toggleStroke.Color = Color3.fromRGB(255, 182, 193)
toggleStroke.Thickness = 1.5
toggleStroke.Parent = toggleBtn

-- Cadre Principal (Compact 420px)
local frame = Instance.new("Frame")
frame.Name = "MainFrame"
frame.Size = UDim2.new(0, 260, 0, 420)
frame.Position = UDim2.new(1, -270, 0.5, -210)
frame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
frame.BorderSizePixel = 0
frame.Parent = mainContainer

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 10)
frameCorner.Parent = frame

local frameStroke = Instance.new("UIStroke")
frameStroke.Color = Color3.fromRGB(255, 105, 180)
frameStroke.Thickness = 1.8
frameStroke.Parent = frame

-- Titre de l'interface
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(1, 0, 0, 30)
titleLabel.Position = UDim2.new(0, 0, 0, 4)
titleLabel.Text = "EZ X L2i6"
titleLabel.TextSize = 19
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextColor3 = Color3.fromRGB(255, 105, 180)
titleLabel.BackgroundTransparency = 1
titleLabel.Parent = frame

local titleLine = Instance.new("Frame")
titleLine.Size = UDim2.new(0.92, 0, 0, 1)
titleLine.Position = UDim2.new(0.04, 0, 0, 36)
titleLine.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
titleLine.BorderSizePixel = 0
titleLine.Parent = frame

makeDraggable(toggleBtn)
makeDraggable(frame, titleLabel)

-- Fonction de création des grands boutons
local function createButton(name, text, posY)
	local btn = Instance.new("TextButton")
	btn.Name = name
	btn.Size = UDim2.new(0.92, 0, 0, 35)
	btn.Position = UDim2.new(0.04, 0, 0, posY)
	btn.Text = text
	btn.TextSize = 13
	btn.Font = Enum.Font.GothamBold
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.BackgroundColor3 = Color3.fromRGB(160, 20, 90)
	btn.BorderSizePixel = 0
	btn.Parent = frame

	local btnCorner = Instance.new("UICorner")
	btnCorner.CornerRadius = UDim.new(0, 6)
	btnCorner.Parent = btn

	return btn
end

local setPosBtn = createButton("SetPosBtn", "Set Position", 45)
local tpPosBtn = createButton("TpPosBtn", "TP Position", 85)
local actionBtn = createButton("ActionBtn", "Turn Money", 125)

--------------------------------------------------------------------------------
-- PETITS BOUTONS DE TEMPS D'ATTENTE (1S ET 2S)
--------------------------------------------------------------------------------
local wait1sBtn = Instance.new("TextButton")
wait1sBtn.Name = "Wait1sBtn"
wait1sBtn.Size = UDim2.new(0.44, 0, 0, 30)
wait1sBtn.Position = UDim2.new(0.04, 0, 0, 168)
wait1sBtn.Text = "Wait : 1s"
wait1sBtn.TextSize = 12
wait1sBtn.Font = Enum.Font.GothamBold
wait1sBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
wait1sBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0) -- Vert = Sélectionné par défaut
wait1sBtn.BorderSizePixel = 0
wait1sBtn.Parent = frame

local corner1 = Instance.new("UICorner")
corner1.CornerRadius = UDim.new(0, 6)
corner1.Parent = wait1sBtn

local wait2sBtn = Instance.new("TextButton")
wait2sBtn.Name = "Wait2sBtn"
wait2sBtn.Size = UDim2.new(0.44, 0, 0, 30)
wait2sBtn.Position = UDim2.new(0.52, 0, 0, 168)
wait2sBtn.Text = "Wait : 2s"
wait2sBtn.TextSize = 12
wait2sBtn.Font = Enum.Font.GothamBold
wait2sBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
wait2sBtn.BackgroundColor3 = Color3.fromRGB(160, 20, 90) -- Rose = Non sélectionné par défaut
wait2sBtn.BorderSizePixel = 0
wait2sBtn.Parent = frame

local corner2 = Instance.new("UICorner")
corner2.CornerRadius = UDim.new(0, 6)
corner2.Parent = wait2sBtn

wait1sBtn.MouseButton1Click:Connect(function()
	waitTimeSetting = 1
	wait1sBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
	wait2sBtn.BackgroundColor3 = Color3.fromRGB(160, 20, 90)
end)

wait2sBtn.MouseButton1Click:Connect(function()
	waitTimeSetting = 2
	wait2sBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
	wait1sBtn.BackgroundColor3 = Color3.fromRGB(160, 20, 90)
end)

--------------------------------------------------------------------------------
-- BARRES DE RÉGLAGE (Anglais + FR)
--------------------------------------------------------------------------------
local minSpeed, maxSpeed = 0.1, 1.5

-- 1. Spin Speed / Vitesse Spin
local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0.92, 0, 0, 15)
speedLabel.Position = UDim2.new(0.04, 0, 0, 205)
speedLabel.Text = string.format("Spin Speed : Vitesse Spin (%.1fx)", speedMultiplier)
speedLabel.TextSize = 11
speedLabel.Font = Enum.Font.GothamBold
speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
speedLabel.BackgroundTransparency = 1
speedLabel.TextXAlignment = Enum.TextXAlignment.Left
speedLabel.Parent = frame

local speedBarBg = Instance.new("Frame")
speedBarBg.Size = UDim2.new(0.92, 0, 0, 14)
speedBarBg.Position = UDim2.new(0.04, 0, 0, 222)
speedBarBg.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
speedBarBg.BorderSizePixel = 0
speedBarBg.Parent = frame
Instance.new("UICorner", speedBarBg).CornerRadius = UDim.new(0, 6)

local speedBarFill = Instance.new("Frame")
speedBarFill.Size = UDim2.new((speedMultiplier - minSpeed)/(maxSpeed - minSpeed), 0, 1, 0)
speedBarFill.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
speedBarFill.BorderSizePixel = 0
speedBarFill.Parent = speedBarBg
Instance.new("UICorner", speedBarFill).CornerRadius = UDim.new(0, 6)

-- 2. Fly Speed / Vitesse Envol
local flySpeedLabel = Instance.new("TextLabel")
flySpeedLabel.Size = UDim2.new(0.92, 0, 0, 15)
flySpeedLabel.Position = UDim2.new(0.04, 0, 0, 242)
flySpeedLabel.Text = string.format("Fly Speed : Vitesse Envol (%.1fx)", flySpeedMultiplier)
flySpeedLabel.TextSize = 11
flySpeedLabel.Font = Enum.Font.GothamBold
flySpeedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
flySpeedLabel.BackgroundTransparency = 1
flySpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
flySpeedLabel.Parent = frame

local flySpeedBarBg = Instance.new("Frame")
flySpeedBarBg.Size = UDim2.new(0.92, 0, 0, 14)
flySpeedBarBg.Position = UDim2.new(0.04, 0, 0, 259)
flySpeedBarBg.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
flySpeedBarBg.BorderSizePixel = 0
flySpeedBarBg.Parent = frame
Instance.new("UICorner", flySpeedBarBg).CornerRadius = UDim.new(0, 6)

local flySpeedBarFill = Instance.new("Frame")
flySpeedBarFill.Size = UDim2.new((flySpeedMultiplier - minSpeed)/(maxSpeed - minSpeed), 0, 1, 0)
flySpeedBarFill.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
flySpeedBarFill.BorderSizePixel = 0
flySpeedBarFill.Parent = flySpeedBarBg
Instance.new("UICorner", flySpeedBarFill).CornerRadius = UDim.new(0, 6)

-- 3. Fly Height / Hauteur Envol
local minHeight, maxHeight = 1, 20
local flyHeightLabel = Instance.new("TextLabel")
flyHeightLabel.Size = UDim2.new(0.92, 0, 0, 15)
flyHeightLabel.Position = UDim2.new(0.04, 0, 0, 279)
flyHeightLabel.Text = string.format("Fly Height : Hauteur Envol (%d studs)", flyHeightSetting)
flyHeightLabel.TextSize = 11
flyHeightLabel.Font = Enum.Font.GothamBold
flyHeightLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
flyHeightLabel.BackgroundTransparency = 1
flyHeightLabel.TextXAlignment = Enum.TextXAlignment.Left
flyHeightLabel.Parent = frame

local flyHeightBarBg = Instance.new("Frame")
flyHeightBarBg.Size = UDim2.new(0.92, 0, 0, 14)
flyHeightBarBg.Position = UDim2.new(0.04, 0, 0, 296)
flyHeightBarBg.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
flyHeightBarBg.BorderSizePixel = 0
flyHeightBarBg.Parent = frame
Instance.new("UICorner", flyHeightBarBg).CornerRadius = UDim.new(0, 6)

local flyHeightBarFill = Instance.new("Frame")
flyHeightBarFill.Size = UDim2.new((flyHeightSetting - minHeight)/(maxHeight - minHeight), 0, 1, 0)
flyHeightBarFill.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
flyHeightBarFill.BorderSizePixel = 0
flyHeightBarFill.Parent = flyHeightBarBg
Instance.new("UICorner", flyHeightBarFill).CornerRadius = UDim.new(0, 6)

-- Logique Sliders
local draggingSpeed, draggingFlySpeed, draggingFlyHeight = false, false, false

local function updateSlider(bg, fill, minVal, maxVal, inputX, isInt)
	local absPos = bg.AbsolutePosition.X
	local absSize = bg.AbsoluteSize.X
	local percent = math.clamp((inputX - absPos) / absSize, 0, 1)
	fill.Size = UDim2.new(percent, 0, 1, 0)
	local val = minVal + (percent * (maxVal - minVal))
	if isInt then return math.floor(val + 0.5) end
	return val
end

speedBarBg.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		draggingSpeed = true
		speedMultiplier = updateSlider(speedBarBg, speedBarFill, minSpeed, maxSpeed, input.Position.X, false)
		speedLabel.Text = string.format("Spin Speed : Vitesse Spin (%.1fx)", speedMultiplier)
	end
end)

flySpeedBarBg.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		draggingFlySpeed = true
		flySpeedMultiplier = updateSlider(flySpeedBarBg, flySpeedBarFill, minSpeed, maxSpeed, input.Position.X, false)
		flySpeedLabel.Text = string.format("Fly Speed : Vitesse Envol (%.1fx)", flySpeedMultiplier)
	end
end)

flyHeightBarBg.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		draggingFlyHeight = true
		flyHeightSetting = updateSlider(flyHeightBarBg, flyHeightBarFill, minHeight, maxHeight, input.Position.X, true)
		flyHeightLabel.Text = string.format("Fly Height : Hauteur Envol (%d studs)", flyHeightSetting)
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		draggingSpeed, draggingFlySpeed, draggingFlyHeight = false, false, false
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		if draggingSpeed then
			speedMultiplier = updateSlider(speedBarBg, speedBarFill, minSpeed, maxSpeed, input.Position.X, false)
			speedLabel.Text = string.format("Spin Speed : Vitesse Spin (%.1fx)", speedMultiplier)
		elseif draggingFlySpeed then
			flySpeedMultiplier = updateSlider(flySpeedBarBg, flySpeedBarFill, minSpeed, maxSpeed, input.Position.X, false)
			flySpeedLabel.Text = string.format("Fly Speed : Vitesse Envol (%.1fx)", flySpeedMultiplier)
		elseif draggingFlyHeight then
			flyHeightSetting = updateSlider(flyHeightBarBg, flyHeightBarFill, minHeight, maxHeight, input.Position.X, true)
			flyHeightLabel.Text = string.format("Fly Height : Hauteur Envol (%d studs)", flyHeightSetting)
		end
	end
end)

--------------------------------------------------------------------------------
-- BOUTONS FINAUX EN BAS (Ajustés pour coller proprement sans espace vide)
--------------------------------------------------------------------------------
local wheelieBtn = createButton("WheelieBtn", "Wheelie Auto : OFF", 320)
local pumpkinBtn = createButton("PumpkinBtn", "🎃 TP Pumpkins", 365)

--------------------------------------------------------------------------------
-- 3. TOGGLE VISIBILITÉ MENU
--------------------------------------------------------------------------------
local isOpen = true
toggleBtn.MouseButton1Click:Connect(function()
	isOpen = not isOpen
	frame.Visible = isOpen
end)

--------------------------------------------------------------------------------
-- 4. LOGIQUE WHEELIE AUTO (35°)
--------------------------------------------------------------------------------
local function getRootPart()
	local char = player.Character
	if not char then return nil end
	
	local hum = char:FindFirstChildOfClass("Humanoid")
	if hum and hum.SeatPart then
		local seat = hum.SeatPart
		return seat.AssemblyRootPart or seat.Parent.PrimaryPart or seat
	end
	return char:FindFirstChild("HumanoidRootPart")
end

RunService.RenderStepped:Connect(function()
	if isWheelieActive then
		local targetPart = getRootPart()
		if targetPart then
			local currentPos = targetPart.Position
			local _, ry, _ = targetPart.CFrame:ToOrientation()
			
			targetPart.CFrame = CFrame.new(currentPos) * CFrame.Angles(0, ry, 0) * CFrame.Angles(math.rad(35), 0, 0)
			targetPart.AssemblyLinearVelocity = Vector3.new(targetPart.AssemblyLinearVelocity.X, 0, targetPart.AssemblyLinearVelocity.Z)
			targetPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
		end
	end
end)

wheelieBtn.MouseButton1Click:Connect(function()
	isWheelieActive = not isWheelieActive
	if isWheelieActive then
		wheelieBtn.Text = "Wheelie Auto : ON"
		wheelieBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
	else
		wheelieBtn.Text = "Wheelie Auto : OFF"
		wheelieBtn.BackgroundColor3 = Color3.fromRGB(160, 20, 90)
	end
end)

setPosBtn.MouseButton1Click:Connect(function()
	local targetPart = getRootPart()
	if targetPart then
		savedCFrame = targetPart.CFrame
		setPosBtn.Text = "Position Saved !"
		task.wait(1.5)
		setPosBtn.Text = "Set Position"
	end
end)

tpPosBtn.MouseButton1Click:Connect(function()
	if not savedCFrame then
		tpPosBtn.Text = "No Pos Set !"
		task.wait(1.5)
		tpPosBtn.Text = "TP Position"
		return
	end

	local targetPart = getRootPart()
	if targetPart then
		targetPart.CFrame = savedCFrame
		tpPosBtn.Text = "Teleported !"
		task.wait(1.5)
		tpPosBtn.Text = "TP Position"
	end
end)

--------------------------------------------------------------------------------
-- 5. LOGIQUE TURN MONEY
--------------------------------------------------------------------------------
local isRunning = false
local renderConnection = nil
local loopTask = nil

local function stopLoop()
	isRunning = false
	if renderConnection then
		renderConnection:Disconnect()
		renderConnection = nil
	end
	if loopTask then
		task.cancel(loopTask)
		loopTask = nil
	end
	actionBtn.BackgroundColor3 = Color3.fromRGB(160, 20, 90)
	actionBtn.Text = "Turn Money"
end

actionBtn.MouseButton1Click:Connect(function()
	if isRunning then
		stopLoop()
		return
	end
	
	isRunning = true
	actionBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)

	local targetPart = getRootPart()
	if not targetPart then
		stopLoop()
		return
	end

	loopTask = task.spawn(function()
		while isRunning do
			local originCFrame = targetPart.CFrame

			-- Montée
			actionBtn.Text = "Ascent..."
			local topCFrame = originCFrame + Vector3.new(0, flyHeightSetting, 0)
			local ascentTime = 0.2 / flySpeedMultiplier
			local ascentStart = tick()
			
			while isRunning and (tick() - ascentStart) < ascentTime do
				local alpha = math.clamp((tick() - ascentStart) / ascentTime, 0, 1)
				targetPart.CFrame = originCFrame:Lerp(topCFrame, alpha)
				targetPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
				targetPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
				RunService.RenderStepped:Wait()
			end
			
			if not isRunning then break end
			targetPart.CFrame = topCFrame

			-- Spin
			local baseCFrame = targetPart.CFrame
			actionBtn.Text = string.format("Spin (%.1fx)...", speedMultiplier)
			local startTime = tick()
			local duration = 1.5 / speedMultiplier
			
			renderConnection = RunService.RenderStepped:Connect(function(dt)
				local elapsed = tick() - startTime
				if elapsed < duration then
					baseCFrame = baseCFrame * CFrame.Angles(0, math.rad(2160 * speedMultiplier * dt), 0)
					targetPart.CFrame = baseCFrame
					targetPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
					targetPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
				end
			end)
			
			task.wait(duration)
			
			if renderConnection then
				renderConnection:Disconnect()
				renderConnection = nil
			end
			
			if not isRunning then break end

			-- Descente
			actionBtn.Text = "Descent..."
			targetPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
			targetPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)

			-- Attente
			for i = waitTimeSetting, 1, -1 do
				if not isRunning then break end
				actionBtn.Text = "Wait : " .. i .. "s"
				task.wait(1)
			end
			
			if not isRunning then break end
		end
	end)
end)

--------------------------------------------------------------------------------
-- 6. TÉLÉPORTATION PUMPKINS
--------------------------------------------------------------------------------
local isPumpkinTpRunning = false

local function isNearSpawn(position)
	for _, obj in ipairs(workspace:GetDescendants()) do
		if obj:IsA("SpawnLocation") then
			local distance = (obj.Position - position).Magnitude
			if distance < 80 then
				return true
			end
		end
	end
	return false
end

pumpkinBtn.MouseButton1Click:Connect(function()
	if isPumpkinTpRunning then return end
	
	local targetPart = getRootPart()
	if not targetPart then return end

	isPumpkinTpRunning = true
	pumpkinBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	pumpkinBtn.Text = "🎃 Searching..."

	local count = 0
	for _, obj in ipairs(workspace:GetDescendants()) do
		if obj:IsA("BasePart") or obj:IsA("Model") then
			local nameLower = string.lower(obj.Name)
			if string.find(nameLower, "pumpkin") or string.find(nameLower, "citrouille") then
				local pos = obj:IsA("Model") and obj:GetPivot().Position or obj.Position
				
				if not isNearSpawn(pos) then
					count = count + 1
					pumpkinBtn.Text = "🎃 TP Pumpkin #" .. count
					targetPart.CFrame = CFrame.new(pos + Vector3.new(0, 3, 0))
					task.wait(0.5)
				end
			end
		end
	end

	if count == 0 then
		pumpkinBtn.Text = "🎃 No Pumpkins !"
	else
		pumpkinBtn.Text = "🎃 Done (" .. count .. ") !"
	end

	task.wait(1.5)
	pumpkinBtn.BackgroundColor3 = Color3.fromRGB(160, 20, 90)
	pumpkinBtn.Text = "🎃 TP Pumpkins"
	isPumpkinTpRunning = false
end)