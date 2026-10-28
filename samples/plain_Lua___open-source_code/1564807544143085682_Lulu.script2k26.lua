local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

if playerGui:FindFirstChild("EzKukirinGui") then playerGui.EzKukirinGui:Destroy() end
if playerGui:FindFirstChild("EzKukirinMobile") then playerGui.EzKukirinMobile:Destroy() end

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

local function secureTeleport(targetPart, targetCFrame)
	if not targetPart then return end
	targetPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
	targetPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
	targetPart.CFrame = targetCFrame
	local char = player.Character
	if char then
		for _, part in ipairs(char:GetDescendants()) do
			if part:IsA("BasePart") then
				part.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
				part.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
			end
		end
	end
end

local OpenCase = nil
local caseConfig = {Cases = {}}
pcall(function() OpenCase = ReplicatedStorage.Remotes.Cases.OpenCase end)
pcall(function() caseConfig = require(ReplicatedStorage.Datas.CaseConfig) end)

-- Variables d'état
local savedCFrame = nil
local waitTimeSetting = 1.75
local speedMultiplier = 1.2
local flySpeedMultiplier = 0.8
local flyHeightSetting = 5
local isWheelieActive = false
local isAutoCrateActive = false
local isAutoDeliverActive = false
local selectedCaseName = nil
local selectedCasePrice = 0
local isSpeedModifierActive = false
local targetKMH = 50
local pickup = Vector3.new(1430.30, 61.18, -606.11)

-- Boost
local boostEnabled = true
local accelerationMult = 0.02
local speedLimit = 200
local accelHeld = false

-- Scooter Godmode & Fake Creator Variables
local isScooterGodActive = false
local lockedScooterSeat = nil
local scooterConnection = nil
local isFakeCreatorActive = false
local creatorBillboard = nil

-- Stance Variables
local isStanceActive = false
local stanceConnection = nil

-- Variables de sécurité pour le Turn Money
local isTurningMoney = false
local originalSeat = nil
local lockSeatConnection = nil

-- ============================================================
-- COULEURS
-- ============================================================
local Colors = {
	Bg = Color3.fromRGB(12, 5, 5),
	Panel = Color3.fromRGB(20, 8, 8),
	RedDark = Color3.fromRGB(100, 10, 10),
	RedMid = Color3.fromRGB(150, 20, 20),
	RedNeon = Color3.fromRGB(255, 40, 40),
	Text = Color3.fromRGB(230, 210, 210),
	TextMuted = Color3.fromRGB(180, 130, 130),
	Green = Color3.fromRGB(20, 150, 80)
}

-- ============================================================
-- UI SETUP
-- ============================================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "EzKukirinGui"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = playerGui

-- WATERMARK DISCORD
local discordLabel = Instance.new("TextLabel", screenGui)
discordLabel.Name = "DiscordWatermark"
discordLabel.AnchorPoint = Vector2.new(0.5, 0.5)
discordLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
discordLabel.Size = UDim2.new(0, 300, 0, 25)
discordLabel.BackgroundTransparency = 1
discordLabel.Text = "https://discord.gg/YYjbEynDe"
discordLabel.TextColor3 = Color3.fromRGB(180, 20, 20)
discordLabel.TextTransparency = 0.3
discordLabel.TextSize = 20
discordLabel.Font = Enum.Font.GothamBold
discordLabel.ZIndex = 1

-- WATERMARK TIKTOK
local tiktokLabel = Instance.new("TextLabel", screenGui)
tiktokLabel.Name = "TikTokWatermark"
tiktokLabel.AnchorPoint = Vector2.new(0.5, 1)
tiktokLabel.Position = UDim2.new(0.5, 0, 1, -6)
tiktokLabel.Size = UDim2.new(0, 260, 0, 16)
tiktokLabel.BackgroundTransparency = 1
tiktokLabel.Text = "by lulu.2i6 on tiktok"
tiktokLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
tiktokLabel.TextTransparency = 0.35
tiktokLabel.Font = Enum.Font.Gotham
tiktokLabel.TextSize = 11
tiktokLabel.ZIndex = 1

local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 220, 0, 320)
mainFrame.Position = UDim2.new(0.5, -110, 0.5, -160)
mainFrame.BackgroundColor3 = Colors.Bg
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 0
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 10)

local mainStroke = Instance.new("UIStroke", mainFrame)
mainStroke.Color = Colors.RedMid
mainStroke.Thickness = 1.5
mainStroke.Transparency = 0.3

-- Header
local header = Instance.new("Frame", mainFrame)
header.Size = UDim2.new(1, 0, 0, 35)
header.BackgroundColor3 = Colors.Panel
header.BackgroundTransparency = 0.2
header.BorderSizePixel = 0
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 10)

local fixHeader = Instance.new("Frame", header)
fixHeader.Size = UDim2.new(1, 0, 0, 10)
fixHeader.Position = UDim2.new(0, 0, 1, -10)
fixHeader.BackgroundColor3 = Colors.Panel
fixHeader.BackgroundTransparency = 0.2
fixHeader.BorderSizePixel = 0

local title = Instance.new("TextLabel", header)
title.Size = UDim2.new(1, -16, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "L2i6 Hub"
title.TextColor3 = Colors.RedNeon
title.Font = Enum.Font.GothamBold
title.TextSize = 13
title.TextXAlignment = Enum.TextXAlignment.Left

local closeBtn = Instance.new("TextButton", header)
closeBtn.Size = UDim2.new(0, 20, 0, 20)
closeBtn.Position = UDim2.new(1, -26, 0.5, -10)
closeBtn.BackgroundColor3 = Colors.RedDark
closeBtn.Text = "X"
closeBtn.TextColor3 = Colors.Text
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 11
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 4)

-- Drag Menu
local dragging, dragInput, dragStart, startPos
header.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true; dragStart = input.Position; startPos = mainFrame.Position
		input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
	end
end)
header.InputChanged:Connect(function(input)
	if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and dragging then
		local delta = input.Position - dragStart
		mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

-- BOUTON OUVRIR
local openBtn = Instance.new("TextButton", screenGui)
openBtn.Size = UDim2.new(0, 70, 0, 24)
openBtn.Position = UDim2.new(0.5, -35, 0, 15)
openBtn.BackgroundColor3 = Colors.RedDark
openBtn.Text = "Ouvrir"
openBtn.TextColor3 = Colors.RedNeon
openBtn.Font = Enum.Font.GothamBold
openBtn.TextSize = 10
openBtn.Visible = false
Instance.new("UICorner", openBtn).CornerRadius = UDim.new(0, 4)

local openStroke = Instance.new("UIStroke", openBtn)
openStroke.Color = Colors.RedNeon
openStroke.Thickness = 1.5

-- Drag bouton Ouvrir
local dragOpen, dragStartOpen, startPosOpen
openBtn.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragOpen = true; dragStartOpen = input.Position; startPosOpen = openBtn.Position
		input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragOpen = false end end)
	end
end)
openBtn.InputChanged:Connect(function(input)
	if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and dragOpen then
		local delta = input.Position - dragStartOpen
		openBtn.Position = UDim2.new(startPosOpen.X.Scale, startPosOpen.X.Offset + delta.X, startPosOpen.Y.Scale, startPosOpen.Y.Offset + delta.Y)
	end
end)

closeBtn.MouseButton1Click:Connect(function()
	mainFrame.Visible = false
	openBtn.Visible = true
end)

openBtn.MouseButton1Click:Connect(function()
	mainFrame.Visible = true
	openBtn.Visible = false
end)

-- Scrolling Content
local content = Instance.new("ScrollingFrame", mainFrame)
content.Size = UDim2.new(1, -16, 1, -50)
content.Position = UDim2.new(0, 8, 0, 42)
content.BackgroundTransparency = 1
content.BorderSizePixel = 0
content.ScrollBarThickness = 2
content.ScrollBarImageColor3 = Colors.RedMid
content.CanvasSize = UDim2.new()
content.AutomaticCanvasSize = Enum.AutomaticSize.Y

local listLayout = Instance.new("UIListLayout", content)
listLayout.Padding = UDim.new(0, 5)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- ============================================================
-- COMPOSANTS UI
-- ============================================================
local function createSection(text)
	local frame = Instance.new("Frame", content)
	frame.Size = UDim2.new(1, 0, 0, 14)
	frame.BackgroundTransparency = 1
	frame.LayoutOrder = #content:GetChildren()
	
	local label = Instance.new("TextLabel", frame)
	label.Size = UDim2.new(1, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.Text = string.upper(text)
	label.TextColor3 = Colors.RedNeon
	label.Font = Enum.Font.GothamBold
	label.TextSize = 9
	label.TextXAlignment = Enum.TextXAlignment.Left
end

local function createButton(text, color)
	local btn = Instance.new("TextButton", content)
	btn.Size = UDim2.new(1, 0, 0, 24)
	btn.BackgroundColor3 = color or Colors.RedDark
	btn.Text = text
	btn.TextColor3 = Colors.Text
	btn.Font = Enum.Font.GothamMedium
	btn.TextSize = 10
	btn.AutoButtonColor = false
	btn.LayoutOrder = #content:GetChildren()
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
	
	local stroke = Instance.new("UIStroke", btn)
	stroke.Color = Colors.RedMid
	stroke.Thickness = 1
	stroke.Transparency = 0.5

	btn.MouseEnter:Connect(function() TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Colors.RedMid}):Play() end)
	btn.MouseLeave:Connect(function() TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = color or Colors.RedDark}):Play() end)
	return btn
end

local function createSlider(labelText, minV, maxV, defaultV, isInt, callback)
	local holder = Instance.new("Frame", content)
	holder.Size = UDim2.new(1, 0, 0, 26)
	holder.BackgroundTransparency = 1
	holder.LayoutOrder = #content:GetChildren()

	local lbl = Instance.new("TextLabel", holder)
	lbl.Size = UDim2.new(1, 0, 0, 10)
	lbl.BackgroundTransparency = 1
	lbl.Text = labelText .. " : " .. (isInt and tostring(defaultV) or string.format("%.1f", defaultV))
	lbl.TextColor3 = Colors.TextMuted
	lbl.Font = Enum.Font.Gotham
	lbl.TextSize = 8
	lbl.TextXAlignment = Enum.TextXAlignment.Left

	local bar = Instance.new("Frame", holder)
	bar.Size = UDim2.new(1, 0, 0, 6)
	bar.Position = UDim2.new(0, 0, 0, 14)
	bar.BackgroundColor3 = Colors.Panel
	bar.BorderSizePixel = 0
	Instance.new("UICorner", bar).CornerRadius = UDim.new(0, 4)

	local fill = Instance.new("Frame", bar)
	fill.Size = UDim2.new((defaultV - minV)/(maxV - minV), 0, 1, 0)
	fill.BackgroundColor3 = Colors.RedMid
	fill.BorderSizePixel = 0
	Instance.new("UICorner", fill).CornerRadius = UDim.new(0, 4)

	bar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			local percent = math.clamp((input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
			fill.Size = UDim2.new(percent, 0, 1, 0)
			local val = minV + (percent * (maxV - minV))
			if isInt then val = math.floor(val + 0.5) end
			lbl.Text = labelText .. " : " .. (isInt and tostring(val) or string.format("%.1f", val))
			callback(val)
		end
	end)
	return holder
end

-- ============================================================
-- FONCTIONS
-- ============================================================
local function findNearbySeat()
    local char = player.Character
    if not char then return nil end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return nil end

    local bestSeat = nil
    local shortestDist = 35

    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("VehicleSeat") and obj.CanCollide then
            local dist = (obj.Position - root.Position).Magnitude
            if dist < shortestDist then
                shortestDist = dist
                bestSeat = obj
            end
        end
    end
    return bestSeat
end

local function keepSeated(hum)
	if not hum then return end
	pcall(function()
		hum.PlatformStand = false
		hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
		hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
	end)
end

local function zeroVel(part)
	if not part then return end
	part.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
	part.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
end

-- ============================================================
-- MENU
-- ============================================================
createSection("Position")
local posRow = Instance.new("Frame", content)
posRow.Size = UDim2.new(1, 0, 0, 22)
posRow.BackgroundTransparency = 1
posRow.LayoutOrder = #content:GetChildren()
local layoutRow = Instance.new("UIListLayout", posRow)
layoutRow.FillDirection = Enum.FillDirection.Horizontal
layoutRow.Padding = UDim.new(0, 4)
layoutRow.SortOrder = Enum.SortOrder.LayoutOrder

local setPosBtn = Instance.new("TextButton", posRow)
setPosBtn.Size = UDim2.new(0.32, 0, 1, 0); setPosBtn.BackgroundColor3 = Colors.RedDark
setPosBtn.Text = "Set Pos"; setPosBtn.TextColor3 = Colors.Text; setPosBtn.Font = Enum.Font.GothamMedium; setPosBtn.TextSize = 9
Instance.new("UICorner", setPosBtn).CornerRadius = UDim.new(0, 4)

local tpPosBtn = Instance.new("TextButton", posRow)
tpPosBtn.Size = UDim2.new(0.32, 0, 1, 0); tpPosBtn.BackgroundColor3 = Colors.RedDark
tpPosBtn.Text = "TP Pos"; tpPosBtn.TextColor3 = Colors.Text; tpPosBtn.Font = Enum.Font.GothamMedium; tpPosBtn.TextSize = 9
Instance.new("UICorner", tpPosBtn).CornerRadius = UDim.new(0, 4)

local antiBanBtn = Instance.new("TextButton", posRow)
antiBanBtn.Size = UDim2.new(0.32, 0, 1, 0); antiBanBtn.BackgroundColor3 = Colors.RedDark
antiBanBtn.Text = "Anti Ban"; antiBanBtn.TextColor3 = Colors.Text; antiBanBtn.Font = Enum.Font.GothamMedium; antiBanBtn.TextSize = 9
Instance.new("UICorner", antiBanBtn).CornerRadius = UDim.new(0, 4)

-- SECTION SCOOTER & STANCE
createSection("Scooter & Stance")
local scooterBtn = createButton("Scooter Godmode : OFF", Colors.Panel)
local stanceBtn = createButton("Stance Conduite : OFF", Colors.Panel)

createSection("Autres")
local creatorBtn = createButton("Fake Content Creator : OFF", Colors.Panel)
local actionBtn = createButton("Turn Money", Colors.RedDark)

createSection("Money & Wait")
local waitRow = Instance.new("Frame", content)
waitRow.Size = UDim2.new(1, 0, 0, 18)
waitRow.BackgroundTransparency = 1
waitRow.LayoutOrder = #content:GetChildren()
local layoutWait = Instance.new("UIListLayout", waitRow)
layoutWait.FillDirection = Enum.FillDirection.Horizontal
layoutWait.Padding = UDim.new(0, 4)

local wait1sBtn = Instance.new("TextButton", waitRow)
wait1sBtn.Size = UDim2.new(0.48, 0, 1, 0); wait1sBtn.BackgroundColor3 = Colors.Green
wait1sBtn.Text = "Wait : 1s"; wait1sBtn.TextColor3 = Colors.Text; wait1sBtn.Font = Enum.Font.GothamBold; wait1sBtn.TextSize = 9
Instance.new("UICorner", wait1sBtn).CornerRadius = UDim.new(0, 4)

local wait2sBtn = Instance.new("TextButton", waitRow)
wait2sBtn.Size = UDim2.new(0.48, 0, 1, 0); wait2sBtn.BackgroundColor3 = Colors.RedDark
wait2sBtn.Text = "Wait : 2s"; wait2sBtn.TextColor3 = Colors.Text; wait2sBtn.Font = Enum.Font.GothamBold; wait2sBtn.TextSize = 9
Instance.new("UICorner", wait2sBtn).CornerRadius = UDim.new(0, 4)

createSection("Vitesse & Fly")
createSlider("Spin Speed", 0.1, 3.0, 1.2, false, function(v) speedMultiplier = v end)
createSlider("Fly Speed", 0.1, 1.5, 0.8, false, function(v) flySpeedMultiplier = v end)
createSlider("Fly Height", 1, 20, 5, true, function(v) flyHeightSetting = v end)
local wheelieBtn = createButton("Wheelie Auto : OFF", Colors.Panel)
local speedModBtn = createButton("Speed Modifier : OFF", Colors.Panel)

local speedBox = Instance.new("TextBox", content)
speedBox.Size = UDim2.new(1, 0, 0, 20)
speedBox.BackgroundColor3 = Colors.Panel
speedBox.Text = "50"
speedBox.PlaceholderText = "KM/H..."
speedBox.TextColor3 = Colors.Text
speedBox.Font = Enum.Font.GothamBold
speedBox.TextSize = 9
speedBox.LayoutOrder = #content:GetChildren()
Instance.new("UICorner", speedBox).CornerRadius = UDim.new(0, 4)
local sBoxStroke = Instance.new("UIStroke", speedBox)
sBoxStroke.Color = Colors.RedMid

createSection("Boost")
local boostBtn = createButton("Speed Boost : ON", Colors.Green)
createSlider("Accélération Boost", 0.5, 2.0, 2.0, false, function(v) accelerationMult = v / 100 end)
createSlider("Limite Vitesse", 50, 500, 200, true, function(v) speedLimit = v end)

createSection("Automatisations")
local pumpkinBtn = createButton("TP Pumpkins", Colors.RedDark)
local autoCrateBtn = createButton("Auto Crate : OFF", Colors.Panel)
local autoDeliverBtn = createButton("Auto Delivery : OFF", Colors.Panel)

createSection("Crates")
local cratesScroll = Instance.new("ScrollingFrame", content)
cratesScroll.Size = UDim2.new(1, 0, 0, 60)
cratesScroll.BackgroundColor3 = Colors.Panel
cratesScroll.BackgroundTransparency = 0.5
cratesScroll.BorderSizePixel = 0
cratesScroll.ScrollBarThickness = 2
cratesScroll.ScrollBarImageColor3 = Colors.RedMid
cratesScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
cratesScroll.LayoutOrder = #content:GetChildren()
Instance.new("UICorner", cratesScroll).CornerRadius = UDim.new(0, 4)
local crateList = Instance.new("UIListLayout", cratesScroll)
crateList.Padding = UDim.new(0, 4)

local caseButtonReferences = {}
if caseConfig and caseConfig.Cases then
	for i, c in pairs(caseConfig.Cases) do
		local titleText = string.lower(tostring(c.Title or c.Name or ""))
		if not (titleText:find("g5") or titleText:find("hardware")) then
			local cBtn = Instance.new("TextButton", cratesScroll)
			cBtn.Size = UDim2.new(0.95, 0, 0, 20); cBtn.BackgroundColor3 = Colors.RedDark
			cBtn.Text = c.Title or "Case"; cBtn.TextColor3 = Colors.RedNeon
			cBtn.Font = Enum.Font.GothamBold; cBtn.TextSize = 9
			Instance.new("UICorner", cBtn).CornerRadius = UDim.new(0, 4)
			
			caseButtonReferences[c.Name] = {Button = cBtn, IsSelected = false}
			
			cBtn.MouseButton1Click:Connect(function()
				selectedCaseName = c.Name; selectedCasePrice = c.Price or 0
				for name, data in pairs(caseButtonReferences) do
					data.IsSelected = (name == c.Name)
					data.Button.BackgroundColor3 = data.IsSelected and Colors.Green or Colors.RedDark
				end
				if OpenCase then pcall(function() OpenCase:InvokeServer(c.Name, c.Price) end) end
			end)
		end
	end
end

-- ============================================================
-- LOGIQUE FAKE CONTENT CREATOR
-- ============================================================
local function updateCreatorBillboard()
    if not isFakeCreatorActive then
        if creatorBillboard then creatorBillboard:Destroy(); creatorBillboard = nil end
        return
    end
    local char = player.Character
    local head = char and char:FindFirstChild("Head")
    if head and not creatorBillboard then
        creatorBillboard = Instance.new("BillboardGui")
        creatorBillboard.Name = "FakeCreatorTag"
        creatorBillboard.Size = UDim2.new(0, 200, 0, 50)
        creatorBillboard.StudsOffset = Vector3.new(0, 2.5, 0)
        creatorBillboard.AlwaysOnTop = true
        creatorBillboard.Parent = head

        local textLabel = Instance.new("TextLabel")
        textLabel.Size = UDim2.new(1, 0, 1, 0)
        textLabel.BackgroundTransparency = 1
        textLabel.Text = "Content Creator"
        textLabel.TextColor3 = Color3.fromRGB(255, 40, 40)
        textLabel.Font = Enum.Font.GothamBold
        textLabel.TextSize = 20
        textLabel.TextStrokeTransparency = 0
        textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        textLabel.Parent = creatorBillboard
    end
end

creatorBtn.MouseButton1Click:Connect(function()
    isFakeCreatorActive = not isFakeCreatorActive
    creatorBtn.Text = "Fake Content Creator : " .. (isFakeCreatorActive and "ON" or "OFF")
    creatorBtn.BackgroundColor3 = isFakeCreatorActive and Colors.Green or Colors.Panel
    updateCreatorBillboard()
end)

player.CharacterAdded:Connect(function()
    task.wait(1)
    if isFakeCreatorActive then
        creatorBillboard = nil
        updateCreatorBillboard()
    end
end)

-- ============================================================
-- LOGIQUE STANCE (INCLINAISON COMME SUR LA PHOTO)
-- ============================================================
stanceBtn.MouseButton1Click:Connect(function()
    isStanceActive = not isStanceActive
    stanceBtn.Text = "Stance Conduite : " .. (isStanceActive and "ON" or "OFF")
    stanceBtn.BackgroundColor3 = isStanceActive and Colors.Green or Colors.Panel

    local char = player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")

    if isStanceActive then
        if stanceConnection then stanceConnection:Disconnect() end
        stanceConnection = RunService.RenderStepped:Connect(function()
            if not isStanceActive then return end
            local currentChar = player.Character
            local currentHum = currentChar and currentChar:FindFirstChildOfClass("Humanoid")
            local currentRoot = currentChar and currentChar:FindFirstChild("HumanoidRootPart")
            
            local scooter = nil
            if currentHum and currentHum.SeatPart then
                scooter = currentHum.SeatPart.AssemblyRootPart or currentHum.SeatPart.Parent.PrimaryPart or currentHum.SeatPart
            end

            if currentHum and currentRoot and scooter then
                -- On NE détache PAS le joueur du siège. 
                -- On incline juste son CFrame pour qu'il se penche en avant.
                local rotX, rotY, rotZ = scooter.CFrame:ToOrientation()
                currentRoot.CFrame = CFrame.new(currentRoot.Position) * CFrame.Angles(math.rad(15), rotY, 0)
            end
        end)
    else
        if stanceConnection then
            stanceConnection:Disconnect()
            stanceConnection = nil
        end
    end
end)

-- ============================================================
-- LOGIQUE SCOOTER GODMODE
-- ============================================================
scooterBtn.MouseButton1Click:Connect(function()
    isScooterGodActive = not isScooterGodActive
    local char = player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")

    if isScooterGodActive then
        if hum and hum.SeatPart and hum.SeatPart:IsA("VehicleSeat") then
            lockedScooterSeat = hum.SeatPart
        else
            lockedScooterSeat = findNearbySeat()
        end

        if not lockedScooterSeat then
            scooterBtn.Text = "ERR: NO SCOOTER"
            scooterBtn.BackgroundColor3 = Colors.RedNeon
            isScooterGodActive = false
            task.delay(1.5, function()
                if not isScooterGodActive then
                    scooterBtn.Text = "Scooter Godmode : OFF"
                    scooterBtn.BackgroundColor3 = Colors.Panel
                end
            end)
            return
        end

        scooterBtn.Text = "Scooter Godmode : ON"
        scooterBtn.BackgroundColor3 = Colors.Green

        if scooterConnection then scooterConnection:Disconnect() end
        scooterConnection = RunService.Heartbeat:Connect(function()
            if not isScooterGodActive then return end
            local currentCharacter = player.Character
            if not currentCharacter then return end
            local currentHumanoid = currentCharacter:FindFirstChildOfClass("Humanoid")
            local currentRoot = currentCharacter:FindFirstChild("HumanoidRootPart")
            if not currentHumanoid or not currentRoot or not lockedScooterSeat or not lockedScooterSeat.Parent then
                return
            end

            pcall(function()
                currentHumanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
                currentHumanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
                currentHumanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp, true)
                if currentHumanoid:GetState() == Enum.HumanoidStateType.FallingDown or currentHumanoid:GetState() == Enum.HumanoidStateType.Ragdoll then
                    currentHumanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
                end
            end)

            currentHumanoid.PlatformStand = false

            if currentHumanoid.Health < currentHumanoid.MaxHealth then
                currentHumanoid.Health = currentHumanoid.MaxHealth
            end

            if currentHumanoid.SeatPart ~= lockedScooterSeat then
                pcall(function()
                    lockedScooterSeat:Sit(currentHumanoid)
                end)

                if currentHumanoid.SeatPart ~= lockedScooterSeat then
                    local targetCF = lockedScooterSeat.CFrame * CFrame.new(0, 1.15, -0.1)
                    currentRoot.CFrame = targetCF
                    pcall(function()
                        currentRoot.AssemblyLinearVelocity = lockedScooterSeat.AssemblyLinearVelocity
                        currentRoot.AssemblyAngularVelocity = lockedScooterSeat.AssemblyAngularVelocity
                    end)
                end
            end
        end)
    else
        scooterBtn.Text = "Scooter Godmode : OFF"
        scooterBtn.BackgroundColor3 = Colors.Panel
        if scooterConnection then
            scooterConnection:Disconnect()
            scooterConnection = nil
        end
        lockedScooterSeat = nil
        if hum then
            pcall(function()
                hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
                hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
                hum.PlatformStand = false
            end)
        end
    end
end)

-- ============================================================
-- TURN MONEY (CFrame rapide + Velocity Fly)
-- ============================================================
local isRunning = false
actionBtn.MouseButton1Click:Connect(function()
	if isRunning then 
		isRunning = false
		actionBtn.Text = "Turn Money"
		actionBtn.BackgroundColor3 = Colors.RedDark
		if lockSeatConnection then lockSeatConnection:Disconnect(); lockSeatConnection = nil end
		
		local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
		if hum then 
			hum.PlatformStand = false 
			hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
			hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
		end
		return 
	end
	
	isRunning = true
	actionBtn.BackgroundColor3 = Colors.RedMid
	local tp = getRootPart()
	if not tp then isRunning = false; return end
	
	local char = player.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	
	if hum and hum.SeatPart then originalSeat = hum.SeatPart end

	if hum then
		hum.PlatformStand = true 
		hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
		hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
		hum:SetStateEnabled(Enum.HumanoidStateType.GettingUp, false)
	end

	if lockSeatConnection then lockSeatConnection:Disconnect() end
	lockSeatConnection = RunService.RenderStepped:Connect(function()
		if not isRunning then
			if lockSeatConnection then lockSeatConnection:Disconnect(); lockSeatConnection = nil end
			return
		end
		if hum and originalSeat and originalSeat.Parent then
			hum.Sit = true
			hum.SeatPart = originalSeat 
		end
	end)

	task.spawn(function()
		while isRunning do
			local origin = tp.CFrame
			
			-- MONTÉE RAPIDE
			actionBtn.Text = "Ascent..."
			local top = origin + Vector3.new(0, flyHeightSetting, 0)
			local ascentTime = 0.5
			local start = tick()
			while isRunning and tick() - start < ascentTime do
				local alpha = (tick() - start) / ascentTime
				tp.CFrame = origin:Lerp(top, alpha)
				tp.AssemblyLinearVelocity = Vector3.new(0, 150 * flySpeedMultiplier, 0) -- Fly Velocity
				tp.AssemblyAngularVelocity = Vector3.new(0,0,0)
				RunService.RenderStepped:Wait()
			end
			if not isRunning then break end
			
			-- ROTATION RAPIDE (8 TOURS EN 2.5S)
			actionBtn.Text = "Spin (Rapide)..."
			local baseCF = tp.CFrame
			local spinStart = tick()
			local spinDuration = 2.5
			local totalYaw = 8 * math.pi * 2
			while isRunning and tick() - spinStart < spinDuration do
				local a = (tick() - spinStart) / spinDuration
				tp.CFrame = baseCF * CFrame.Angles(0, totalYaw * a, 0)
				tp.AssemblyLinearVelocity = Vector3.new(0,0,0)
				tp.AssemblyAngularVelocity = Vector3.new(0,0,0)
				RunService.RenderStepped:Wait()
			end
			if not isRunning then break end
			tp.CFrame = baseCF
			
			-- DESCENTE RAPIDE
			actionBtn.Text = "Descent..."
			local currentTop = tp.CFrame
			local descentTime = 0.5
			local descStart = tick()
			while isRunning and tick() - descStart < descentTime do
				local alpha = (tick() - descStart) / descentTime
				tp.CFrame = currentTop:Lerp(origin, alpha)
				tp.AssemblyLinearVelocity = Vector3.new(0, -150 * flySpeedMultiplier, 0) -- Fly Velocity
				tp.AssemblyAngularVelocity = Vector3.new(0,0,0)
				RunService.RenderStepped:Wait()
			end
			if not isRunning then break end
			tp.CFrame = origin
			
			-- ATTENTE 1.75 SECONDES
			actionBtn.Text = "Wait (1.75s)..."
			task.wait(1.75)
		end
	end)
end)

-- ============================================================
-- BOUTONS DIVERS
-- ============================================================
setPosBtn.MouseButton1Click:Connect(function()
	local tp = getRootPart()
	if tp then savedCFrame = tp.CFrame; setPosBtn.Text = "Saved !"; task.wait(1); setPosBtn.Text = "Set Pos" end
end)

tpPosBtn.MouseButton1Click:Connect(function()
	local tp = getRootPart()
	if savedCFrame and tp then secureTeleport(tp, savedCFrame); tpPosBtn.Text = "TP'd !"; task.wait(1); tpPosBtn.Text = "TP Pos" end
end)

antiBanBtn.MouseButton1Click:Connect(function()
	local tp = getRootPart()
	if tp then secureTeleport(tp, CFrame.new(120, 229, -202)); antiBanBtn.Text = "Done!"; task.wait(1); antiBanBtn.Text = "Anti Ban" end
end)

wheelieBtn.MouseButton1Click:Connect(function()
	isWheelieActive = not isWheelieActive
	wheelieBtn.Text = "Wheelie Auto : " .. (isWheelieActive and "ON" or "OFF")
	wheelieBtn.BackgroundColor3 = isWheelieActive and Colors.Green or Colors.Panel
end)

speedModBtn.MouseButton1Click:Connect(function()
	isSpeedModifierActive = not isSpeedModifierActive
	speedModBtn.Text = "Speed Modifier : " .. (isSpeedModifierActive and "ON" or "OFF")
	speedModBtn.BackgroundColor3 = isSpeedModifierActive and Colors.Green or Colors.Panel
end)

speedBox.FocusLost:Connect(function()
	local num = tonumber(speedBox.Text)
	if num then targetKMH = math.max(0, num); speedBox.Text = tostring(targetKMH) end
end)

boostBtn.MouseButton1Click:Connect(function()
	boostEnabled = not boostEnabled
	boostBtn.Text = "Speed Boost : " .. (boostEnabled and "ON" or "OFF")
	boostBtn.BackgroundColor3 = boostEnabled and Colors.Green or Colors.Panel
end)

wait1sBtn.MouseButton1Click:Connect(function() waitTimeSetting = 1; wait1sBtn.BackgroundColor3 = Colors.Green; wait2sBtn.BackgroundColor3 = Colors.RedDark end)
wait2sBtn.MouseButton1Click:Connect(function() waitTimeSetting = 2; wait2sBtn.BackgroundColor3 = Colors.Green; wait1sBtn.BackgroundColor3 = Colors.RedDark end)

-- Pumpkins & Delivery logic
local isPumpkinTpRunning = false
pumpkinBtn.MouseButton1Click:Connect(function()
	if isPumpkinTpRunning then isPumpkinTpRunning = false; pumpkinBtn.Text = "TP Pumpkins"; pumpkinBtn.BackgroundColor3 = Colors.RedDark; return end
	isPumpkinTpRunning = true; pumpkinBtn.BackgroundColor3 = Colors.RedMid; pumpkinBtn.Text = "Scanning..."
	local tp = getRootPart(); if not tp then isPumpkinTpRunning = false; return end
	task.spawn(function()
		while isPumpkinTpRunning do
			for _, obj in ipairs(workspace:GetDescendants()) do
				if not isPumpkinTpRunning then break end
				if obj:IsA("Model") or obj:IsA("BasePart") then
					local n = string.lower(obj.Name)
					if string.find(n, "pumpkin") or string.find(n, "citrouille") then
						local pos = obj:IsA("Model") and obj:GetPivot().Position or obj.Position
						local nearSpawn = false
						for _, s in ipairs(workspace:GetDescendants()) do
							if s:IsA("SpawnLocation") and (s.Position - pos).Magnitude < 100 then nearSpawn = true; break end
						end
						if not nearSpawn then secureTeleport(tp, CFrame.new(pos + Vector3.new(0,3,0))); break end
					end
				end
			end
			task.wait(0.5)
		end
		pumpkinBtn.Text = "TP Pumpkins"; pumpkinBtn.BackgroundColor3 = Colors.RedDark
	end)
end)

autoCrateBtn.MouseButton1Click:Connect(function()
	isAutoCrateActive = not isAutoCrateActive
	autoCrateBtn.Text = "Auto Crate : " .. (isAutoCrateActive and "ON" or "OFF")
	autoCrateBtn.BackgroundColor3 = isAutoCrateActive and Colors.Green or Colors.Panel
end)

task.spawn(function()
	while true do
		if isAutoCrateActive and selectedCaseName and OpenCase then pcall(function() OpenCase:InvokeServer(selectedCaseName, selectedCasePrice) end) end
		task.wait(0.2)
	end
end)

autoDeliverBtn.MouseButton1Click:Connect(function()
	isAutoDeliverActive = not isAutoDeliverActive
	autoDeliverBtn.Text = "Auto Delivery : " .. (isAutoDeliverActive and "ON" or "OFF")
	autoDeliverBtn.BackgroundColor3 = isAutoDeliverActive and Colors.Green or Colors.Panel
end)

task.spawn(function()
	local FD = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("FoodDelivery")
	while true do
		if isAutoDeliverActive and FD then
			local tp = getRootPart()
			if tp then
				secureTeleport(tp, CFrame.new(pickup + Vector3.new(0,3,0)))
				task.wait(1.5)
				local start = FD:FindFirstChild("Start")
				if start and pcall(function() return start:InvokeServer() end) then
					local cust = workspace:FindFirstChild("DeliveryCustomer")
					if cust and cust.PrimaryPart then
						secureTeleport(tp, CFrame.new(cust.PrimaryPart.Position + Vector3.new(0,3,0)))
						task.wait(1.5)
						local deliver = FD:FindFirstChild("Deliver")
						if deliver then pcall(function() deliver:InvokeServer() end) end
					end
				end
			end
		end
		task.wait(1)
	end
end)

-- ============================================================
-- BOUCLE PRINCIPALE (Vitesse / Boost / Mobile)
-- ============================================================
RunService.RenderStepped:Connect(function(dt)
	local tp = getRootPart()
	if not tp then return end

	if isSpeedModifierActive then
		local vel = tp.AssemblyLinearVelocity
		local flatSpeed = Vector3.new(vel.X, 0, vel.Z).Magnitude
		if flatSpeed > 1.5 then
			local look = tp.CFrame.LookVector
			local flatLook = Vector3.new(look.X, 0, look.Z).Unit
			if flatSpeed < targetKMH then
				tp.AssemblyLinearVelocity = Vector3.new(flatLook.X * math.min(targetKMH, flatSpeed + (dt*60)), vel.Y, flatLook.Z * math.min(targetKMH, flatSpeed + (dt*60)))
			elseif flatSpeed > targetKMH + 2 then
				tp.AssemblyLinearVelocity = Vector3.new(flatLook.X * targetKMH, vel.Y, flatLook.Z * targetKMH)
			end
		end
	end

	if boostEnabled then
		local accel = accelHeld or UserInputService:IsKeyDown(Enum.KeyCode.W)
		local vel = tp.AssemblyLinearVelocity
		local horiz = Vector3.new(vel.X, 0, vel.Z).Magnitude
		if accel and horiz < speedLimit then
			local newVel = vel * Vector3.new(1 + accelerationMult, 1, 1 + accelerationMult)
			local newHoriz = Vector3.new(newVel.X, 0, newVel.Z).Magnitude
			if newHoriz > speedLimit then
				local dir = Vector3.new(newVel.X, 0, newVel.Z).Unit
				tp.AssemblyLinearVelocity = Vector3.new(dir.X * speedLimit, newVel.Y, dir.Z * speedLimit)
			else
				tp.AssemblyLinearVelocity = newVel
			end
		end
	end
end)

-- MOBILE BOOST
local mobileGui = Instance.new("ScreenGui", playerGui)
mobileGui.Name = "EzKukirinMobile"
mobileGui.ResetOnSpawn = false
mobileGui.IgnoreGuiInset = true

local mobileBoost = Instance.new("TextButton", mobileGui)
mobileBoost.Size = UDim2.new(0, 80, 0, 80)
mobileBoost.Position = UDim2.new(1, -100, 1, -120)
mobileBoost.BackgroundColor3 = Colors.RedDark
mobileBoost.BackgroundTransparency = 0.2
mobileBoost.Text = "BOOST"
mobileBoost.TextSize = 16
mobileBoost.Font = Enum.Font.GothamBold
mobileBoost.TextColor3 = Colors.RedNeon
mobileBoost.BorderSizePixel = 0
Instance.new("UICorner", mobileBoost).CornerRadius = UDim.new(1, 0)

local mStroke = Instance.new("UIStroke", mobileBoost)
mStroke.Color = Colors.RedNeon
mStroke.Thickness = 2

mobileBoost.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
		accelHeld = true
		mobileBoost.BackgroundColor3 = Colors.RedMid
	end
end)
mobileBoost.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
		accelHeld = false
		mobileBoost.BackgroundColor3 = Colors.RedDark
	end
end)
UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch and #UserInputService:GetTouches() == 0 then
		accelHeld = false
		mobileBoost.BackgroundColor3 = Colors.RedDark
	end
end)