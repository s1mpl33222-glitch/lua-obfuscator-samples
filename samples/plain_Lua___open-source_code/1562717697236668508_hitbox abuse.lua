-- LocalScript (place in StarterPlayerScripts)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

local function getCharacter()
	return player.Character or player.CharacterAdded:Wait()
end

local function getHumanoidRootPart(character)
	return character and character:FindFirstChild("HumanoidRootPart")
end

local function getClosestCharacter(originPosition, ignoreCharacter)
	local closestModel = nil
	local closestDistance = math.huge

	for _, obj in ipairs(workspace:GetDescendants()) do
		if obj:IsA("Humanoid") and obj.Health > 0 then
			local model = obj.Parent
			if model and model:IsA("Model") and model ~= ignoreCharacter then
				local hrp = model:FindFirstChild("HumanoidRootPart")
				if hrp and hrp:IsA("BasePart") then
					local dist = (hrp.Position - originPosition).Magnitude
					if dist < closestDistance then
						closestDistance = dist
						closestModel = model
					end
				end
			end
		end
	end

	return closestModel
end

local function getAllCharacters(ignoreCharacter)
	local list = {}
	for _, obj in ipairs(workspace.Players.Survivors:GetDescendants()) do
		if obj:IsA("Humanoid") and obj.Health > 0 then
			local model = obj.Parent
			if model and model:IsA("Model") and model ~= ignoreCharacter then
				local hrp = model:FindFirstChild("HumanoidRootPart")
				if hrp and hrp:IsA("BasePart") then
					table.insert(list, model)
				end
			end
		end
	end
	return list
end

local function parseNumber(text, fallback)
	local n = tonumber(text)
	if n == nil then
		return fallback
	end
	return n
end

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "PrimaryPartTestGui"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = player:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.new(0, 260, 0, 420)
main.Position = UDim2.new(0, 100, 0, 100)
main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
main.BorderSizePixel = 0
main.ClipsDescendants = true
main.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = main

local stroke = Instance.new("UIStroke")
stroke.Thickness = 1
stroke.Color = Color3.fromRGB(70, 70, 70)
stroke.Parent = main

local dragBar = Instance.new("Frame")
dragBar.Name = "DragBar"
dragBar.Size = UDim2.new(1, 0, 0, 28)
dragBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
dragBar.BorderSizePixel = 0
dragBar.Active = true
dragBar.Parent = main

local dragCorner = Instance.new("UICorner")
dragCorner.CornerRadius = UDim.new(0, 10)
dragCorner.Parent = dragBar

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -12, 1, 0)
title.Position = UDim2.new(0, 6, 0, 0)
title.BackgroundTransparency = 1
title.Text = "skibidier v4.4"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 14
title.Font = Enum.Font.GothamSemibold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = dragBar

local content = Instance.new("Frame")
content.Size = UDim2.new(1, -12, 1, -34)
content.Position = UDim2.new(0, 6, 0, 32)
content.BackgroundTransparency = 1
content.Parent = main

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 6)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = content

local function makeButton(text, height)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, 0, 0, height or 36)
	btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	btn.BorderSizePixel = 0
	btn.Text = text
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.TextSize = 14
	btn.Font = Enum.Font.GothamSemibold
	btn.AutoButtonColor = true

	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, 8)
	c.Parent = btn

	return btn
end

local function makeBox(placeholder, defaultText)
	local box = Instance.new("TextBox")
	box.Size = UDim2.new(1, 0, 0, 34)
	box.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	box.BorderSizePixel = 0
	box.Text = defaultText or ""
	box.PlaceholderText = placeholder
	box.PlaceholderColor3 = Color3.fromRGB(170, 170, 170)
	box.TextColor3 = Color3.fromRGB(255, 255, 255)
	box.TextSize = 14
	box.Font = Enum.Font.Gotham
	box.ClearTextOnFocus = false
	box.TextXAlignment = Enum.TextXAlignment.Left

	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, 8)
	c.Parent = box

	local pad = Instance.new("UIPadding")
	pad.PaddingLeft = UDim.new(0, 10)
	pad.PaddingRight = UDim.new(0, 10)
	pad.Parent = box

	return box
end

local runButton = makeButton("Run", 40)
runButton.LayoutOrder = 1
runButton.Parent = content

-- Mode cycles: Extender -> Aim -> All
local modeButton = makeButton("Mode: Extender", 34)
modeButton.LayoutOrder = 2
modeButton.Parent = content

-- Extender frame
local extenderFrame = Instance.new("Frame")
extenderFrame.Size = UDim2.new(1, 0, 0, 202)
extenderFrame.BackgroundTransparency = 1
extenderFrame.LayoutOrder = 3
extenderFrame.Parent = content

local extenderLayout = Instance.new("UIListLayout")
extenderLayout.Padding = UDim.new(0, 6)
extenderLayout.SortOrder = Enum.SortOrder.LayoutOrder
extenderLayout.Parent = extenderFrame

local extenderModeButton = makeButton("Extender Mode: Straight", 34)
extenderModeButton.LayoutOrder = 0
extenderModeButton.Parent = extenderFrame

local studsBox = makeBox("Studs Infront", "10")
studsBox.LayoutOrder = 1
studsBox.Parent = extenderFrame
studsBox.FocusLost:Connect(function()
    local value = math.clamp(parseNumber(studsBox.Text, 10), 0, 20)
    studsBox.Text = tostring(value)
end)

local extenderDurationBox = makeBox("Duration", "0.3")
extenderDurationBox.LayoutOrder = 2
extenderDurationBox.Parent = extenderFrame

local smearToggle = makeButton("Smear: Off", 34)
smearToggle.LayoutOrder = 3
smearToggle.Parent = extenderFrame

local smearStepBox = makeBox("Smear Step (sec)", "0")
smearStepBox.LayoutOrder = 4
smearStepBox.Parent = extenderFrame

local smearStudsBox = makeBox("Smear Studs / Step", "4")
smearStudsBox.LayoutOrder = 5
smearStudsBox.Parent = extenderFrame

-- Aim frame
local aimFrame = Instance.new("Frame")
aimFrame.Size = UDim2.new(1, 0, 0, 34)
aimFrame.BackgroundTransparency = 1
aimFrame.LayoutOrder = 4
aimFrame.Parent = content

local aimDurationBox = makeBox("Duration", "2")
aimDurationBox.LayoutOrder = 1
aimDurationBox.Parent = aimFrame

-- All frame
local allFrame = Instance.new("Frame")
allFrame.Size = UDim2.new(1, 0, 0, 34)
allFrame.BackgroundTransparency = 1
allFrame.LayoutOrder = 5
allFrame.Parent = content

local allDurationBox = makeBox("Duration", "0.3")
allDurationBox.LayoutOrder = 1
allDurationBox.Parent = allFrame

local currentMode = "Extender"
local extenderSubMode = "Straight"
local smearOn = false
local running = false

local modes = {"Extender", "Aim", "All"}

local function updateModeUI()
	modeButton.Text = "Mode: " .. currentMode
	extenderFrame.Visible = (currentMode == "Extender")
	aimFrame.Visible = (currentMode == "Aim")
	allFrame.Visible = (currentMode == "All")
end

local function updateExtenderModeUI()
	extenderModeButton.Text = "Extender Mode: " .. extenderSubMode
end

local function updateSmearUI()
	smearToggle.Text = smearOn and "Smear: On" or "Smear: Off"
end

updateModeUI()
updateExtenderModeUI()
updateSmearUI()

modeButton.MouseButton1Click:Connect(function()
	local idx = table.find(modes, currentMode) or 1
	currentMode = modes[(idx % #modes) + 1]
	updateModeUI()
end)

extenderModeButton.MouseButton1Click:Connect(function()
	extenderSubMode = (extenderSubMode == "Straight") and "Nearest" or "Straight"
	updateExtenderModeUI()
end)

smearToggle.MouseButton1Click:Connect(function()
	smearOn = not smearOn
	updateSmearUI()
end)

-- Dragging
local dragging = false
local dragStart
local startPos
local dragInput

local function updateDrag(input)
	local delta = input.Position - dragStart
	main.Position = UDim2.new(
		startPos.X.Scale,
		startPos.X.Offset + delta.X,
		startPos.Y.Scale,
		startPos.Y.Offset + delta.Y
	)
end

dragBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = main.Position
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		updateDrag(input)
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input == dragInput then
		dragging = false
		dragInput = nil
	end
end)

local function cleanup(tempPart, oldPrimaryPart)
	local character = getCharacter()
	if oldPrimaryPart and oldPrimaryPart.Parent == character then
		pcall(function()
			character.PrimaryPart = oldPrimaryPart
		end)
	end
	if tempPart and tempPart.Parent then
		tempPart:Destroy()
	end
end

local function finishRun(tempPart, oldPrimaryPart)
	cleanup(tempPart, oldPrimaryPart)
	runButton.Text = "Run"
	running = false
end

runButton.MouseButton1Click:Connect(function()
	if running then return end

	running = true
	runButton.Text = "Running..."

	local character = getCharacter()
	local hrp = getHumanoidRootPart(character)

	if not hrp then
		finishRun(nil, nil)
		return
	end

	local oldPrimaryPart = character.PrimaryPart

	local tempPart = Instance.new("Part")
	tempPart.Name = "TempPrimaryPart"
	tempPart.Size = Vector3.new(2, 2, 2)
	tempPart.Anchored = true
	tempPart.CanCollide = false
	tempPart.Transparency = 1
	tempPart.Parent = character

	pcall(function()
		character.PrimaryPart = tempPart
	end)

	local duration
	if currentMode == "Extender" then
		duration = parseNumber(extenderDurationBox.Text, 0.3)
	elseif currentMode == "Aim" then
		duration = parseNumber(aimDurationBox.Text, 2)
	else
		duration = parseNumber(allDurationBox.Text, 0.3)
	end

	task.spawn(function()
		local startTime = time()

		if currentMode == "Extender" then
			local studsInFront = math.clamp(parseNumber(studsBox.Text, 10), 0, 20)
			local smearStep = math.max(0, parseNumber(smearStepBox.Text, 0))
			local targetStuds = math.max(1, math.floor(studsInFront + 0.5))
			local currentStud = 1
			local smearStudsPerStep = math.max(0.1, parseNumber(smearStudsBox.Text, 4))

			local function getTargetCFrame(currentHRP)
				if extenderSubMode == "Nearest" then
					local targetModel = getClosestCharacter(currentHRP.Position, character)
					local targetHRP = targetModel and targetModel:FindFirstChild("HumanoidRootPart")
					if targetHRP and targetHRP:IsA("BasePart") then
						local dir = (targetHRP.Position - currentHRP.Position).Unit
						return currentHRP.CFrame + dir * studsInFront
					end
				end
				return currentHRP.CFrame + (currentHRP.CFrame.LookVector * studsInFront)
			end

			local function getSmearCFrame(currentHRP, studsToUse)
				if extenderSubMode == "Nearest" then
					local targetModel = getClosestCharacter(currentHRP.Position, character)
					local targetHRP = targetModel and targetModel:FindFirstChild("HumanoidRootPart")
					if targetHRP and targetHRP:IsA("BasePart") then
						local dir = (targetHRP.Position - currentHRP.Position).Unit
						return currentHRP.CFrame + dir * studsToUse
					end
				end
				return currentHRP.CFrame + (currentHRP.CFrame.LookVector * studsToUse)
			end

			if smearOn then
				while running and time() - startTime < duration do
					if not tempPart.Parent or not character.Parent then break end
					local currentHRP = getHumanoidRootPart(character)
					if not currentHRP then break end
					local studsToUse = math.min(currentStud, targetStuds)
					tempPart.CFrame = getSmearCFrame(currentHRP, studsToUse)
					if currentStud < targetStuds then
						currentStud = math.min(currentStud + smearStudsPerStep, targetStuds)
					end
					task.wait(smearStep)
				end
				finishRun(tempPart, oldPrimaryPart)
			else
				local conn
				conn = RunService.RenderStepped:Connect(function()
					if not running or not tempPart.Parent or not character.Parent then
						if conn then conn:Disconnect() end
						finishRun(tempPart, oldPrimaryPart)
						return
					end
					local currentHRP = getHumanoidRootPart(character)
					if currentHRP then
						tempPart.CFrame = getTargetCFrame(currentHRP)
					end
					if time() - startTime >= duration then
						if conn then conn:Disconnect() end
						finishRun(tempPart, oldPrimaryPart)
					end
				end)
			end

		elseif currentMode == "Aim" then
			local conn
			conn = RunService.RenderStepped:Connect(function()
				if not running or not tempPart.Parent or not character.Parent then
					if conn then conn:Disconnect() end
					finishRun(tempPart, oldPrimaryPart)
					return
				end
				local currentHRP = getHumanoidRootPart(character)
				if currentHRP then
					local targetModel = getClosestCharacter(currentHRP.Position, character)
					local targetHRP = targetModel and targetModel:FindFirstChild("HumanoidRootPart")
					if targetHRP and targetHRP:IsA("BasePart") then
						tempPart.CFrame = CFrame.lookAt(currentHRP.Position, targetHRP.Position)
					else
						tempPart.CFrame = CFrame.lookAt(currentHRP.Position, currentHRP.Position + currentHRP.CFrame.LookVector)
					end
				end
				if time() - startTime >= duration then
					if conn then conn:Disconnect() end
					finishRun(tempPart, oldPrimaryPart)
				end
			end)

		elseif currentMode == "All" then
			-- Snapshot all characters at the moment Run is pressed
			local targets = getAllCharacters(character)
			local index = 1

			if #targets == 0 then
				finishRun(tempPart, oldPrimaryPart)
				return
			end

			local conn
			conn = RunService.RenderStepped:Connect(function()
				if not running or not tempPart.Parent or not character.Parent then
					if conn then conn:Disconnect() end
					finishRun(tempPart, oldPrimaryPart)
					return
				end

				-- Advance to next character each frame, looping
				if index > #targets then
					index = 1
				end

				local target = targets[index]
				local targetHRP = target and target:FindFirstChild("HumanoidRootPart")

				-- Skip dead/removed targets but still advance
				if targetHRP and targetHRP.Parent then
					tempPart.CFrame = targetHRP.CFrame
				end

				index = index + 1

				if time() - startTime >= duration then
					if conn then conn:Disconnect() end
					finishRun(tempPart, oldPrimaryPart)
				end
			end)
		end
	end)
end)
