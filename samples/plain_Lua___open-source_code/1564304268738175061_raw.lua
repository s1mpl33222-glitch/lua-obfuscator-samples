local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

if playerGui:FindFirstChild("EzKukirinGui") then
	playerGui.EzKukirinGui:Destroy()
end
if playerGui:FindFirstChild("CaseMenu") then
	playerGui.CaseMenu:Destroy()
end

-- Crate Opener Remotes & Config
local OpenCase = nil
local caseConfig = {Cases = {}}

pcall(function()
	OpenCase = ReplicatedStorage.Remotes.Cases.OpenCase
end)

pcall(function()
	caseConfig = require(ReplicatedStorage.Datas.CaseConfig)
end)

local savedCFrame = nil
local waitTimeSetting = 1
local speedMultiplier = 0.8
local flySpeedMultiplier = 0.8
local flyHeightSetting = 5
local isWheelieActive = false
local evadeOn = false
local antiFallOn = false
local autoCrateOn = false

local EVADE_DIST = 80
local POLICE_NAMES = {"Police","Officer","Cop","Sheriff","Deputy"}

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "EzKukirinGui"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = playerGui

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

local mainContainer = Instance.new("Folder")
mainContainer.Name = "MainContainer"
mainContainer.Parent = screenGui

local toggleBtn = Instance.new("TextButton")
toggleBtn.Name = "ToggleBtn"
toggleBtn.Size = UDim2.new(0, 90, 0, 26)
toggleBtn.Position = UDim2.new(0.5, -45, 0, 10)
toggleBtn.Text = "Toggle"
toggleBtn.TextSize = 12
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
toggleBtn.BorderSizePixel = 0
toggleBtn.Parent = mainContainer

local toggleGradient = Instance.new("UIGradient", toggleBtn)
toggleGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(220, 20, 60)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(120, 10, 30))
})
toggleGradient.Rotation = 90

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 6)
toggleCorner.Parent = toggleBtn

local toggleStroke = Instance.new("UIStroke")
toggleStroke.Color = Color3.fromRGB(255, 50, 90)
toggleStroke.Thickness = 1.5
toggleStroke.Parent = toggleBtn

local frame = Instance.new("Frame")
frame.Name = "MainFrame"
frame.Size = UDim2.new(0, 260, 0, 605)
frame.Position = UDim2.new(1, -270, 0.5, -302)
frame.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
frame.BorderSizePixel = 0
frame.Parent = mainContainer

local frameGradient = Instance.new("UIGradient", frame)
frameGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(22, 22, 28)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 8, 12))
})
frameGradient.Rotation = 45

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 12)
frameCorner.Parent = frame

local frameStroke = Instance.new("UIStroke")
frameStroke.Color = Color3.fromRGB(200, 30, 70)
frameStroke.Thickness = 1.5
frameStroke.Parent = frame

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(1, 0, 0, 32)
titleLabel.Position = UDim2.new(0, 0, 0, 4)
titleLabel.Text = "Vexs KukiLife"
titleLabel.TextSize = 18
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextColor3 = Color3.fromRGB(255, 70, 110)
titleLabel.BackgroundTransparency = 1
titleLabel.Parent = frame

local titleLine = Instance.new("Frame")
titleLine.Size = UDim2.new(0.92, 0, 0, 1)
titleLine.Position = UDim2.new(0.04, 0, 0, 36)
titleLine.BackgroundColor3 = Color3.fromRGB(180, 20, 60)
titleLine.BorderSizePixel = 0
titleLine.Parent = frame

makeDraggable(toggleBtn)
makeDraggable(frame, titleLabel)

local function createButton(name, text, posY)
	local btn = Instance.new("TextButton")
	btn.Name = name
	btn.Size = UDim2.new(0.92, 0, 0, 35)
	btn.Position = UDim2.new(0.04, 0, 0, posY)
	btn.Text = text
	btn.TextSize = 13
	btn.Font = Enum.Font.GothamBold
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.BackgroundColor3 = Color3.fromRGB(35, 15, 25)
	btn.BorderSizePixel = 0
	btn.Parent = frame

	local grad = Instance.new("UIGradient", btn)
	grad.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(190, 25, 75)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(110, 10, 40))
	})
	grad.Rotation = 90

	local btnCorner = Instance.new("UICorner")
	btnCorner.CornerRadius = UDim.new(0, 6)
	btnCorner.Parent = btn

	local stroke = Instance.new("UIStroke", btn)
	stroke.Color = Color3.fromRGB(220, 60, 100)
	stroke.Thickness = 1
	stroke.Transparency = 0.3

	return btn
end

local setPosBtn = createButton("SetPosBtn", "Set Position", 45)
local tpPosBtn = createButton("TpPosBtn", "TP Position", 85)
local actionBtn = createButton("ActionBtn", "Turn Money", 125)

local wait1sBtn = Instance.new("TextButton")
wait1sBtn.Name = "Wait1sBtn"
wait1sBtn.Size = UDim2.new(0.44, 0, 0, 30)
wait1sBtn.Position = UDim2.new(0.04, 0, 0, 168)
wait1sBtn.Text = "Wait : 1s"
wait1sBtn.TextSize = 12
wait1sBtn.Font = Enum.Font.GothamBold
wait1sBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
wait1sBtn.BackgroundColor3 = Color3.fromRGB(20, 120, 50)
wait1sBtn.BorderSizePixel = 0
wait1sBtn.Parent = frame

Instance.new("UICorner", wait1sBtn).CornerRadius = UDim.new(0, 6)

local wait2sBtn = Instance.new("TextButton")
wait2sBtn.Name = "Wait2sBtn"
wait2sBtn.Size = UDim2.new(0.44, 0, 0, 30)
wait2sBtn.Position = UDim2.new(0.52, 0, 0, 168)
wait2sBtn.Text = "Wait : 2s"
wait2sBtn.TextSize = 12
wait2sBtn.Font = Enum.Font.GothamBold
wait2sBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
wait2sBtn.BackgroundColor3 = Color3.fromRGB(110, 10, 40)
wait2sBtn.BorderSizePixel = 0
wait2sBtn.Parent = frame

Instance.new("UICorner", wait2sBtn).CornerRadius = UDim.new(0, 6)

wait1sBtn.MouseButton1Click:Connect(function()
	waitTimeSetting = 1
	wait1sBtn.BackgroundColor3 = Color3.fromRGB(20, 120, 50)
	wait2sBtn.BackgroundColor3 = Color3.fromRGB(110, 10, 40)
end)

wait2sBtn.MouseButton1Click:Connect(function()
	waitTimeSetting = 2
	wait2sBtn.BackgroundColor3 = Color3.fromRGB(20, 120, 50)
	wait1sBtn.BackgroundColor3 = Color3.fromRGB(110, 10, 40)
end)

local minSpeed, maxSpeed = 0.1, 1.5

local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0.92, 0, 0, 15)
speedLabel.Position = UDim2.new(0.04, 0, 0, 205)
speedLabel.Text = string.format("Spin Speed (%.1fx)", speedMultiplier)
speedLabel.TextSize = 11
speedLabel.Font = Enum.Font.GothamBold
speedLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
speedLabel.BackgroundTransparency = 1
speedLabel.TextXAlignment = Enum.TextXAlignment.Left
speedLabel.Parent = frame

local speedBarBg = Instance.new("Frame")
speedBarBg.Size = UDim2.new(0.92, 0, 0, 14)
speedBarBg.Position = UDim2.new(0.04, 0, 0, 222)
speedBarBg.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
speedBarBg.BorderSizePixel = 0
speedBarBg.Parent = frame
Instance.new("UICorner", speedBarBg).CornerRadius = UDim.new(0, 6)

local speedBarFill = Instance.new("Frame")
speedBarFill.Size = UDim2.new((speedMultiplier - minSpeed)/(maxSpeed - minSpeed), 0, 1, 0)
speedBarFill.BackgroundColor3 = Color3.fromRGB(220, 30, 80)
speedBarFill.BorderSizePixel = 0
speedBarFill.Parent = speedBarBg
Instance.new("UICorner", speedBarFill).CornerRadius = UDim.new(0, 6)

local flySpeedLabel = Instance.new("TextLabel")
flySpeedLabel.Size = UDim2.new(0.92, 0, 0, 15)
flySpeedLabel.Position = UDim2.new(0.04, 0, 0, 242)
flySpeedLabel.Text = string.format("Fly Speed (%.1fx)", flySpeedMultiplier)
flySpeedLabel.TextSize = 11
flySpeedLabel.Font = Enum.Font.GothamBold
flySpeedLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
flySpeedLabel.BackgroundTransparency = 1
flySpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
flySpeedLabel.Parent = frame

local flySpeedBarBg = Instance.new("Frame")
flySpeedBarBg.Size = UDim2.new(0.92, 0, 0, 14)
flySpeedBarBg.Position = UDim2.new(0.04, 0, 0, 259)
flySpeedBarBg.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
flySpeedBarBg.BorderSizePixel = 0
flySpeedBarBg.Parent = frame
Instance.new("UICorner", flySpeedBarBg).CornerRadius = UDim.new(0, 6)

local flySpeedBarFill = Instance.new("Frame")
flySpeedBarFill.Size = UDim2.new((flySpeedMultiplier - minSpeed)/(maxSpeed - minSpeed), 0, 1, 0)
flySpeedBarFill.BackgroundColor3 = Color3.fromRGB(220, 30, 80)
flySpeedBarFill.BorderSizePixel = 0
flySpeedBarFill.Parent = flySpeedBarBg
Instance.new("UICorner", flySpeedBarFill).CornerRadius = UDim.new(0, 6)

local minHeight, maxHeight = 1, 20
local flyHeightLabel = Instance.new("TextLabel")
flyHeightLabel.Size = UDim2.new(0.92, 0, 0, 15)
flyHeightLabel.Position = UDim2.new(0.04, 0, 0, 279)
flyHeightLabel.Text = string.format("Fly Height (%d studs)", flyHeightSetting)
flyHeightLabel.TextSize = 11
flyHeightLabel.Font = Enum.Font.GothamBold
flyHeightLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
flyHeightLabel.BackgroundTransparency = 1
flyHeightLabel.TextXAlignment = Enum.TextXAlignment.Left
flyHeightLabel.Parent = frame

local flyHeightBarBg = Instance.new("Frame")
flyHeightBarBg.Size = UDim2.new(0.92, 0, 0, 14)
flyHeightBarBg.Position = UDim2.new(0.04, 0, 0, 296)
flyHeightBarBg.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
flyHeightBarBg.BorderSizePixel = 0
flyHeightBarBg.Parent = frame
Instance.new("UICorner", flyHeightBarBg).CornerRadius = UDim.new(0, 6)

local flyHeightBarFill = Instance.new("Frame")
flyHeightBarFill.Size = UDim2.new((flyHeightSetting - minHeight)/(maxHeight - minHeight), 0, 1, 0)
flyHeightBarFill.BackgroundColor3 = Color3.fromRGB(220, 30, 80)
flyHeightBarFill.BorderSizePixel = 0
flyHeightBarFill.Parent = flyHeightBarBg
Instance.new("UICorner", flyHeightBarFill).CornerRadius = UDim.new(0, 6)

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
		speedLabel.Text = string.format("Spin Speed (%.1fx)", speedMultiplier)
	end
end)

flySpeedBarBg.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		draggingFlySpeed = true
		flySpeedMultiplier = updateSlider(flySpeedBarBg, flySpeedBarFill, minSpeed, maxSpeed, input.Position.X, false)
		flySpeedLabel.Text = string.format("Fly Speed (%.1fx)", flySpeedMultiplier)
	end
end)

flyHeightBarBg.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		draggingFlyHeight = true
		flyHeightSetting = updateSlider(flyHeightBarBg, flyHeightBarFill, minHeight, maxHeight, input.Position.X, true)
		flyHeightLabel.Text = string.format("Fly Height (%d studs)", flyHeightSetting)
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
			speedLabel.Text = string.format("Spin Speed (%.1fx)", speedMultiplier)
		elseif draggingFlySpeed then
			flySpeedMultiplier = updateSlider(flySpeedBarBg, flySpeedBarFill, minSpeed, maxSpeed, input.Position.X, false)
			flySpeedLabel.Text = string.format("Fly Speed (%.1fx)", flySpeedMultiplier)
		elseif draggingFlyHeight then
			flyHeightSetting = updateSlider(flyHeightBarBg, flyHeightBarFill, minHeight, maxHeight, input.Position.X, true)
			flyHeightLabel.Text = string.format("Fly Height (%d studs)", flyHeightSetting)
		end
	end
end)

local wheelieBtn = createButton("WheelieBtn", "Wheelie Auto : OFF", 320)
local pumpkinBtn = createButton("PumpkinBtn", "TP Pumpkins 🎃", 365)
local evadeBtn = createButton("EvadeBtn", "Police Escape : OFF", 410)
local antiFallBtn = createButton("AntiFallBtn", "Anti Fall : OFF", 455)
local autoCrateBtn = createButton("AutoCrateBtn", "Auto Crate : OFF", 500)

local evadeLabel = Instance.new("TextLabel", frame)
evadeLabel.Size = UDim2.new(0.92, 0, 0, 16)
evadeLabel.Position = UDim2.new(0.04, 0, 0, 550)
evadeLabel.BackgroundTransparency = 1
evadeLabel.TextColor3 = Color3.fromRGB(200, 100, 120)
evadeLabel.Font = Enum.Font.GothamBold
evadeLabel.TextSize = 11
evadeLabel.Text = ""
evadeLabel.TextXAlignment = Enum.TextXAlignment.Center

local isOpen = true
toggleBtn.MouseButton1Click:Connect(function()
	isOpen = not isOpen
	frame.Visible = isOpen
end)

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

local function getHRP()
	local char = player.Character
	if not char then return nil end
	return char:FindFirstChild("HumanoidRootPart")
end

local function findNearestCop()
	local hrp = getHRP()
	if not hrp then return nil, math.huge end
	local best, bestD = nil, math.huge
	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= player and p.Character then
			local root = p.Character:FindFirstChild("HumanoidRootPart")
			if root then
				local d = (root.Position - hrp.Position).Magnitude
				if d < bestD then best = root.Position; bestD = d end
			end
		end
	end
	for _, v in ipairs(workspace:GetDescendants()) do
		if v:IsA("Model") then
			for _, n in ipairs(POLICE_NAMES) do
				if v.Name:lower():find(n:lower()) then
					local root = v:FindFirstChild("HumanoidRootPart") or v.PrimaryPart
					if root and hrp then
						local d = (root.Position - hrp.Position).Magnitude
						if d < bestD then best = root.Position; bestD = d end
					end
				end
			end
		end
	end
	return best, bestD
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
	
	if antiFallOn then
		local char = player.Character
		if char then
			local hum = char:FindFirstChildOfClass("Humanoid")
			if hum then
				pcall(function()
					hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
					hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
					if hum:GetState() == Enum.HumanoidStateType.FallingDown or hum:GetState() == Enum.HumanoidStateType.Ragdoll or hum.PlatformStanding then
						hum.PlatformStanding = false
						hum:ChangeState(Enum.HumanoidStateType.GettingUp)
					end
				end)
			end
		end
	end
end)

wheelieBtn.MouseButton1Click:Connect(function()
	isWheelieActive = not isWheelieActive
	if isWheelieActive then
		wheelieBtn.Text = "Wheelie Auto : ON"
		wheelieBtn.BackgroundColor3 = Color3.fromRGB(20, 120, 50)
	else
		wheelieBtn.Text = "Wheelie Auto : OFF"
		wheelieBtn.BackgroundColor3 = Color3.fromRGB(35, 15, 25)
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

evadeBtn.MouseButton1Click:Connect(function()
	evadeOn = not evadeOn
	evadeBtn.Text = evadeOn and "Police Escape : ON" or "Police Escape : OFF"
	if evadeOn then
		evadeBtn.BackgroundColor3 = Color3.fromRGB(20, 120, 50)
	else
		evadeBtn.BackgroundColor3 = Color3.fromRGB(35, 15, 25)
		evadeLabel.Text = ""
	end
end)

antiFallBtn.MouseButton1Click:Connect(function()
	antiFallOn = not antiFallOn
	antiFallBtn.Text = antiFallOn and "Anti Fall : ON" or "Anti Fall : OFF"
	if antiFallOn then
		antiFallBtn.BackgroundColor3 = Color3.fromRGB(20, 120, 50)
	else
		antiFallBtn.BackgroundColor3 = Color3.fromRGB(35, 15, 25)
	end
end)

autoCrateBtn.MouseButton1Click:Connect(function()
	autoCrateOn = not autoCrateOn
	autoCrateBtn.Text = autoCrateOn and "Auto Crate : ON" or "Auto Crate : OFF"
	if autoCrateOn then
		autoCrateBtn.BackgroundColor3 = Color3.fromRGB(20, 120, 50)
	else
		autoCrateBtn.BackgroundColor3 = Color3.fromRGB(35, 15, 25)
	end
end)

-- Auto Crate Execution Loop
task.spawn(function()
	while true do
		task.wait(0.3)
		if autoCrateOn and OpenCase and caseConfig and caseConfig.Cases then
			for _, c in pairs(caseConfig.Cases) do
				if not autoCrateOn then break end
				local titleText = string.lower(tostring(c.Title or c.Name or ""))
				if not (titleText:find("g5") or titleText:find("hardware")) then
					pcall(function()
						OpenCase:InvokeServer(c.Name, c.Price)
					end)
					task.wait(0.2)
				end
			end
		end
	end
end)

-- Police escape loop
task.spawn(function()
	while true do
		task.wait(0.5)
		if evadeOn then
			local copPos, dist = findNearestCop()
			if copPos and dist < EVADE_DIST then
				evadeLabel.Text = "🚨 Cop " .. math.floor(dist) .. "m — Dodging!"
				local hrp = getHRP()
				if hrp then
					local away = (hrp.Position - copPos).Unit
					local perp = Vector3.new(-away.Z, 0, away.X)
					local dodge = away + perp * 0.6
					hrp.CFrame = CFrame.new(hrp.Position + dodge.Unit * EVADE_DIST)
				end
			else
				evadeLabel.Text = copPos and ("Cop " .. math.floor(dist) .. "m — Clear") or "No cops found"
			end
		end
	end
end)

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
	actionBtn.Text = "Turn Money"
end

actionBtn.MouseButton1Click:Connect(function()
	if isRunning then
		stopLoop()
		return
	end
	
	isRunning = true
	local targetPart = getRootPart()
	if not targetPart then
		stopLoop()
		return
	end

	loopTask = task.spawn(function()
		while isRunning do
			local originCFrame = targetPart.CFrame
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

			actionBtn.Text = "Descent..."
			targetPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
			targetPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)

			for i = waitTimeSetting, 1, -1 do
				if not isRunning then break end
				actionBtn.Text = "Wait : " .. i .. "s"
				task.wait(1)
			end
			
			if not isRunning then break end
		end
	end)
end)

local isPumpkinTpRunning = false

pumpkinBtn.MouseButton1Click:Connect(function()
	if isPumpkinTpRunning then
		isPumpkinTpRunning = false
		pumpkinBtn.Text = "TP Pumpkins 🎃"
		return
	end
	
	local targetPart = getRootPart()
	if not targetPart then
		pumpkinBtn.Text = "No Vehicle/Char!"
		task.wait(1.5)
		pumpkinBtn.Text = "TP Pumpkins 🎃"
		return
	end
	
	isPumpkinTpRunning = true
	pumpkinBtn.Text = "Scanning..."

	task.spawn(function()
		while isPumpkinTpRunning do
			local foundPos = nil
			
			for _, obj in ipairs(workspace:GetDescendants()) do
				if not isPumpkinTpRunning then break end
				if obj and (obj:IsA("BasePart") or obj:IsA("Model")) then
					local nameLower = string.lower(obj.Name)
					if string.find(nameLower, "pumpkin") or string.find(nameLower, "citrouille") or string.find(nameLower, "event") then
						local pos = nil
						if obj:IsA("Model") then
							local pivot = obj:GetPivot()
							if pivot then pos = pivot.Position end
						else
							pos = obj.Position
						end
						
						if pos then
							local isNearSpawn = false
							for _, spawnObj in ipairs(workspace:GetDescendants()) do
								if spawnObj:IsA("SpawnLocation") and (spawnObj.Position - pos).Magnitude < 100 then
									isNearSpawn = true
									break
								end
							end
							
							if not isNearSpawn then
								foundPos = pos
								break
							end
						end
					end
				end
			end
			
			if not foundPos or not isPumpkinTpRunning then
				break
			end
			
			pumpkinBtn.Text = "TP Pumpkins 🎃"
			targetPart.CFrame = CFrame.new(foundPos + Vector3.new(0, 3, 0))
			task.wait(0.5)
		end
		
		pumpkinBtn.Text = "TP Pumpkins 🎃"
		isPumpkinTpRunning = false
	end)
end)
