local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local oldGui = playerGui:FindFirstChild("SpiderUI")
if oldGui then oldGui:Destroy() end

local SWING_ANIM = "rbxassetid://97674654492880"
local swingLaunch = 48
local swingRelease = 28
local swingDistance = 36
local swingHeight = 13
local swingGravity = 0.03
local SWING_SOUND = "rbxassetid://1284846268"
local ZIP_SOUND = "rbxassetid://9084017080"
local CLIMB_ANIM = "rbxassetid://507765644"
local PUNCH_BUTTON_IMAGE = "rbxassetid://135333785603921"
local HANG_ANIM = "rbxassetid://125903067740797"

local swinging = false
local swingStep = 1
local zipStep = 1
local climbing = false
local climbEnabled = false
local swingConn = nil
local swingAnchor = nil
local swingRope = nil
local swingTrack = nil
local climbConn = nil
local climbTrack = nil
local climbVelocity = nil
local climbAlign = nil
local climbAttachment = nil
local webs = {}
local ikList = {}
local gripAtt = nil

local SUITS = {
	["2007 black suit"] = { Shirt = "rbxassetid://94573071076464", Pants = "rbxassetid://71512133603900" },
	["Tobey Suit"] = { Shirt = "rbxassetid://140512161997832", Pants = "rbxassetid://106261471636500" },
	["Andrew Suit"] = { Shirt = "rbxassetid://104856641332381", Pants = "rbxassetid://86713486995081" },
	["Tom Suit"] = { Shirt = "rbxassetid://126695763735565", Pants = "rbxassetid://84732202556990" },
}
local selectedSuit = "2007 black suit"
local outfitEnabled = false
local originalOutfits = setmetatable({}, { __mode = "k" })

local function rememberOriginalOutfit(char)
	if originalOutfits[char] then return end
	local shirt = char:FindFirstChildOfClass("Shirt")
	local pants = char:FindFirstChildOfClass("Pants")
	originalOutfits[char] = {
		shirtObject = shirt,
		shirtTemplate = shirt and shirt.ShirtTemplate or nil,
		pantsObject = pants,
		pantsTemplate = pants and pants.PantsTemplate or nil,
	}
end

local function applyOutfit(char)
	if not char or not char.Parent then return end
	local suit = SUITS[selectedSuit]
	if not suit or suit.Shirt == "" or suit.Pants == "" then return end
	rememberOriginalOutfit(char)
	local shirt = char:FindFirstChildOfClass("Shirt")
	if not shirt then
		shirt = Instance.new("Shirt")
		shirt.Parent = char
	end
	shirt.ShirtTemplate = suit.Shirt
	local pants = char:FindFirstChildOfClass("Pants")
	if not pants then
		pants = Instance.new("Pants")
		pants.Parent = char
	end
	pants.PantsTemplate = suit.Pants
end

local function removeOutfit(char)
	if not char then return end
	local original = originalOutfits[char]
	if not original then
		outfitEnabled = false
		return
	end
	local currentShirt = char:FindFirstChildOfClass("Shirt")
	if original.shirtObject then
		if original.shirtObject.Parent ~= char then
			original.shirtObject.Parent = char
		end
		original.shirtObject.ShirtTemplate = original.shirtTemplate or ""
		if currentShirt and currentShirt ~= original.shirtObject then
			currentShirt:Destroy()
		end
	elseif currentShirt then
		currentShirt:Destroy()
	end
	local currentPants = char:FindFirstChildOfClass("Pants")
	if original.pantsObject then
		if original.pantsObject.Parent ~= char then
			original.pantsObject.Parent = char
		end
		original.pantsObject.PantsTemplate = original.pantsTemplate or ""
		if currentPants and currentPants ~= original.pantsObject then
			currentPants:Destroy()
		end
	elseif currentPants then
		currentPants:Destroy()
	end
	outfitEnabled = false
end

local webWing = false
local webWingConn = nil
local webWingObjects = {}
local webWingIK = {}
local webWingAlign = nil
local webWingAttachment = nil
local webWingHeadLook = nil
local webWingRightHip = nil
local webWingLeftHip = nil
local webWingRightHipOriginal = nil
local webWingLeftHipOriginal = nil

local WEB_WING_SOUND = "rbxassetid://93035214379043"
local webWingSound = nil
local WEB_SHOT_TEXTURE = "rbxassetid://15000399146"
local GROUND_WEB_TEXTURE = "rbxassetid://135020810378886"
local WEB_SHOT_SOUND = "rbxassetid://9120629317"
local webShotObjects = {}
local webShotIK = {}
local webShotPose = false
local abilityMode = 1

local punchStep = 1
local lastPunchTime = 0
local punching = false
local punchConn = nil
local punchObjects = {}
local punchGeneration = 0
local savedPunchHumanoidState = nil
local kickTrack = nil

local function getParts()
	local char = player.Character or player.CharacterAdded:Wait()
	local hrp = char:WaitForChild("HumanoidRootPart")
	local hum = char:WaitForChild("Humanoid")
	return char, hrp, hum
end

local function applyJump(char)
	local hum = char:WaitForChild("Humanoid")
	hum.UseJumpPower = true
	hum.JumpPower = 100
end

if player.Character then task.spawn(applyJump, player.Character) end

player.CharacterAdded:Connect(function(char)
	task.wait(0.5)
	applyJump(char)
	if outfitEnabled then applyOutfit(char) end
end)

local function getAnimator(hum)
	local animator = hum:FindFirstChildOfClass("Animator")
	if not animator then
		animator = Instance.new("Animator")
		animator.Parent = hum
	end
	return animator
end

local function getHand(char, side)
	if side == "Right" then
		return char:FindFirstChild("RightHand") or char:FindFirstChild("Right Arm")
	end
	return char:FindFirstChild("LeftHand") or char:FindFirstChild("Left Arm")
end

local function getArmRoot(char, side)
	if side == "Right" then
		return char:FindFirstChild("RightUpperArm") or char:FindFirstChild("Right Arm") or char:FindFirstChild("UpperTorso")
	end
	return char:FindFirstChild("LeftUpperArm") or char:FindFirstChild("Left Arm") or char:FindFirstChild("UpperTorso")
end

local function findMotor(char, name)
	local motor = char:FindFirstChild(name, true)
	if motor and motor:IsA("Motor6D") then return motor end
	return nil
end

local function setMotor(char, name, cf)
	local motor = findMotor(char, name)
	if motor then motor.Transform = cf end
end

local function resetArmPose(char)
	if not char then return end
	local names = {
		"RightShoulder", "LeftShoulder", "RightElbow", "LeftElbow",
		"RightWrist", "LeftWrist", "Waist", "Neck",
		"RightHip", "LeftHip", "RightKnee", "LeftKnee",
		"RightAnkle", "LeftAnkle",
	}
	for _, name in ipairs(names) do
		setMotor(char, name, CFrame.identity)
	end
end

local function poseWingArms(char)
	setMotor(char, "RightShoulder", CFrame.Angles(math.rad(-10), math.rad(15), math.rad(78)))
	setMotor(char, "LeftShoulder", CFrame.Angles(math.rad(-10), math.rad(-15), math.rad(-78)))
	setMotor(char, "RightElbow", CFrame.Angles(math.rad(8), 0, 0))
	setMotor(char, "LeftElbow", CFrame.Angles(math.rad(8), 0, 0))
end

local function poseShotArms(char)
	setMotor(char, "RightShoulder", CFrame.Angles(math.rad(80), math.rad(10), math.rad(-15)))
	setMotor(char, "LeftShoulder", CFrame.Angles(math.rad(80), math.rad(-10), math.rad(15)))
	setMotor(char, "RightElbow", CFrame.Angles(math.rad(-12), 0, 0))
	setMotor(char, "LeftElbow", CFrame.Angles(math.rad(-12), 0, 0))
end

local function clearWebs()
	for _, obj in ipairs(webs) do if obj and obj.Parent then obj:Destroy() end end
	table.clear(webs)
end

local function clearIK()
	for _, ik in ipairs(ikList) do if ik and ik.Parent then ik:Destroy() end end
	table.clear(ikList)
end

local function playSound(hrp, id)
	local sound = Instance.new("Sound")
	sound.SoundId = id
	sound.Volume = 2
	sound.Parent = hrp
	sound:Play()
	Debris:AddItem(sound, 3)
end

local function addWebFromHand(char, targetAtt, side)
	local hand = getHand(char, side)
	if not hand or not targetAtt then return end
	local handAtt = Instance.new("Attachment")
	handAtt.Name = "WebHandAttachment"
	handAtt.Parent = hand
	local beam = Instance.new("Beam")
	beam.Attachment0 = targetAtt
	beam.Attachment1 = handAtt
	beam.Width0 = 0.92
	beam.Width1 = 0.72
	beam.Texture = "rbxassetid://15000399146"
	beam.TextureMode = Enum.TextureMode.Wrap
	beam.TextureLength = 1
	beam.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255))
	beam.LightEmission = 1
	beam.FaceCamera = true
	beam.Parent = hand
	table.insert(webs, beam)
	table.insert(webs, handAtt)
end

local function attachArm(char, hum, side, targetAtt)
	local hand = getHand(char, side)
	local root = getArmRoot(char, side)
	if not hand or not root or not targetAtt then return end
	local ik = Instance.new("IKControl")
	ik.Name = "WebArmIK_" .. side
	ik.Type = Enum.IKControlType.Position
	ik.EndEffector = hand
	ik.ChainRoot = root
	ik.Target = targetAtt
	ik.Weight = 1
	ik.SmoothTime = 0.08
	ik.Parent = hum
	table.insert(ikList, ik)
end

local gui = Instance.new("ScreenGui")
gui.Name = "SpiderUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = playerGui

local function circleButton(name, pos, imageId)
	local b = Instance.new("ImageButton")
	b.Name = name
	b.Size = UDim2.fromOffset(75, 75)
	b.Position = pos
	b.BackgroundColor3 = Color3.fromRGB(190, 25, 25)
	b.Image = imageId
	b.ScaleType = Enum.ScaleType.Fit
	b.Parent = gui
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(1, 0)
	c.Parent = b
	local s = Instance.new("UIStroke")
	s.Color = Color3.fromRGB(0, 110, 255)
	s.Thickness = 4
	s.Parent = b
	return b
end

local btnClimb = circleButton("BtnClimb", UDim2.new(0.68, 0, 0.57, 0), "rbxassetid://76038791676557")
local btnSwing = circleButton("BtnSwing", UDim2.new(0.68, 0, 0.78, 0), "rbxassetid://124599639623520")
local btnZip = circleButton("BtnZip", UDim2.new(0.79, 0, 0.63, 0), "rbxassetid://87791451477905")
local btnWing = circleButton("BtnWebWing", UDim2.new(0.84, 0, 0.40, 0), "rbxassetid://126070453599788")
local btnWebShot = circleButton("BtnWebShot", UDim2.new(0.68, 0, 0.78, 0), "rbxassetid://115541977197236")
btnWebShot.Visible = false
local btnPunch = circleButton("BtnPunch", UDim2.new(0.68, 0, 0.58, 0), PUNCH_BUTTON_IMAGE)
btnPunch.Visible = false
local btnHang = circleButton("BtnHang", UDim2.new(0.84, 0, 0.58, 0), "rbxassetid://106605923962819")
btnHang.Visible = false
local btnJump = circleButton("BtnChargeJump", UDim2.new(1, -18, 1, -18), "rbxassetid://110760795415545")
btnJump.AnchorPoint = Vector2.new(1, 1)
btnJump.Size = UDim2.fromOffset(82, 82)

local btnMode = Instance.new("TextButton")
btnMode.Name = "BtnMode"
btnMode.Size = UDim2.fromOffset(55, 55)
btnMode.Position = UDim2.new(0.75, 0, 0.08, 0)
btnMode.BackgroundColor3 = Color3.fromRGB(190, 25, 25)
btnMode.Text = "🔄"
btnMode.TextScaled = true
btnMode.Font = Enum.Font.SourceSansBold
btnMode.Parent = gui
Instance.new("UICorner", btnMode).CornerRadius = UDim.new(1, 0)
local modeStroke = Instance.new("UIStroke")
modeStroke.Color = Color3.fromRGB(0, 110, 255)
modeStroke.Thickness = 4
modeStroke.Parent = btnMode

local btnSwingConfig = Instance.new("TextButton")
btnSwingConfig.Name = "BtnSwingConfig"
btnSwingConfig.Size = UDim2.fromOffset(55, 55)
btnSwingConfig.Position = UDim2.new(0.75, 0, 0.005, 0)
btnSwingConfig.BackgroundColor3 = Color3.fromRGB(190, 25, 25)
btnSwingConfig.Text = "🕸"
btnSwingConfig.TextScaled = true
btnSwingConfig.Font = Enum.Font.SourceSansBold
btnSwingConfig.ZIndex = 6
btnSwingConfig.Parent = gui
Instance.new("UICorner", btnSwingConfig).CornerRadius = UDim.new(1, 0)
local swingConfigStroke = Instance.new("UIStroke")
swingConfigStroke.Color = Color3.fromRGB(0, 110, 255)
swingConfigStroke.Thickness = 4
swingConfigStroke.Parent = btnSwingConfig

local swingMenu = Instance.new("Frame")
swingMenu.Name = "SwingConfig"
swingMenu.Size = UDim2.new(0.72, 0, 0, 250)
swingMenu.Position = UDim2.new(0.14, 0, 0.16, 0)
swingMenu.BackgroundColor3 = Color3.fromRGB(15, 20, 35)
swingMenu.BorderSizePixel = 0
swingMenu.Visible = false
swingMenu.ZIndex = 20
swingMenu.Parent = gui
Instance.new("UICorner", swingMenu).CornerRadius = UDim.new(0, 14)
local swingMenuStroke = Instance.new("UIStroke")
swingMenuStroke.Color = Color3.fromRGB(220, 30, 45)
swingMenuStroke.Thickness = 3
swingMenuStroke.Parent = swingMenu

local swingTitle = Instance.new("TextLabel")
swingTitle.Size = UDim2.new(1, 0, 0, 36)
swingTitle.BackgroundTransparency = 1
swingTitle.Text = "Web Swing"
swingTitle.TextColor3 = Color3.fromRGB(255, 55, 65)
swingTitle.TextScaled = true
swingTitle.Font = Enum.Font.GothamBold
swingTitle.ZIndex = 21
swingTitle.Parent = swingMenu

local swingRows = {
	{ name = "Velocidade", get = function() return swingLaunch end, set = function(v) swingLaunch = v end, min = 20, max = 90, step = 4 },
	{ name = "Impulso ao soltar", get = function() return swingRelease end, set = function(v) swingRelease = v end, min = 0, max = 70, step = 4 },
	{ name = "Distância da teia", get = function() return swingDistance end, set = function(v) swingDistance = v end, min = 18, max = 60, step = 2 },
	{ name = "Altura da teia", get = function() return swingHeight end, set = function(v) swingHeight = v end, min = 6, max = 28, step = 1 },
	{ name = "Queda", get = function() return math.floor(swingGravity * 100) end, set = function(v) swingGravity = v / 100 end, min = 1, max = 8, step = 1 },
}

for i, row in ipairs(swingRows) do
	local y = 40 + (i - 1) * 40
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(0.42, 0, 0, 32)
	label.Position = UDim2.new(0.04, 0, 0, y)
	label.BackgroundTransparency = 1
	label.Text = row.name
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.TextScaled = true
	label.Font = Enum.Font.GothamBold
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.ZIndex = 21
	label.Parent = swingMenu

	local value = Instance.new("TextLabel")  
	value.Size = UDim2.new(0.16, 0, 0, 32)  
	value.Position = UDim2.new(0.46, 0, 0, y)  
	value.BackgroundTransparency = 1  
	value.Text = tostring(row.get())  
	value.TextColor3 = Color3.fromRGB(255, 80, 90)  
	value.TextScaled = true  
	value.Font = Enum.Font.GothamBold  
	value.ZIndex = 21  
	value.Parent = swingMenu  

	local function refresh()  
		value.Text = tostring(row.get())  
	end  

	local minus = Instance.new("TextButton")  
	minus.Size = UDim2.fromOffset(34, 32)  
	minus.Position = UDim2.new(0.64, 0, 0, y)  
	minus.BackgroundColor3 = Color3.fromRGB(190, 25, 25)  
	minus.Text = "-"  
	minus.TextScaled = true  
	minus.Font = Enum.Font.GothamBold  
	minus.TextColor3 = Color3.fromRGB(255, 255, 255)  
	minus.ZIndex = 22  
	minus.Parent = swingMenu  
	Instance.new("UICorner", minus).CornerRadius = UDim.new(1, 0)  

	local plus = Instance.new("TextButton")  
	plus.Size = UDim2.fromOffset(34, 32)  
	plus.Position = UDim2.new(0.82, 0, 0, y)  
	plus.BackgroundColor3 = Color3.fromRGB(0, 110, 255)  
	plus.Text = "+"  
	plus.TextScaled = true  
	plus.Font = Enum.Font.GothamBold  
	plus.TextColor3 = Color3.fromRGB(255, 255, 255)  
	plus.ZIndex = 22  
	plus.Parent = swingMenu  
	Instance.new("UICorner", plus).CornerRadius = UDim.new(1, 0)  

	minus.Activated:Connect(function()  
		row.set(math.clamp(row.get() - row.step, row.min, row.max))  
		refresh()  
	end)  
	plus.Activated:Connect(function()  
		row.set(math.clamp(row.get() + row.step, row.min, row.max))  
		refresh()  
	end)
end

btnSwingConfig.Activated:Connect(function()
	swingMenu.Visible = not swingMenu.Visible
end)

local btnOutfit = Instance.new("TextButton")
btnOutfit.Name = "BtnOutfit"
btnOutfit.Size = UDim2.fromOffset(55, 55)
btnOutfit.Position = UDim2.new(0.85, 0, 0.08, 0)
btnOutfit.BackgroundColor3 = Color3.fromRGB(190, 25, 25)
btnOutfit.Text = "👕"
btnOutfit.TextScaled = true
btnOutfit.Font = Enum.Font.SourceSansBold
btnOutfit.Parent = gui
Instance.new("UICorner", btnOutfit).CornerRadius = UDim.new(1, 0)
local outfitStroke = Instance.new("UIStroke")
outfitStroke.Color = Color3.fromRGB(0, 110, 255)
outfitStroke.Thickness = 4
outfitStroke.Parent = btnOutfit

local btnSuitSettings = Instance.new("TextButton")
btnSuitSettings.Name = "BtnSuitSettings"
btnSuitSettings.Size = UDim2.fromOffset(55, 55)
btnSuitSettings.Position = UDim2.new(0.85, 0, 0.005, 0)
btnSuitSettings.BackgroundColor3 = Color3.fromRGB(0, 110, 255)
btnSuitSettings.Text = "⚙️"
btnSuitSettings.TextScaled = true
btnSuitSettings.Font = Enum.Font.SourceSansBold
btnSuitSettings.Parent = gui
Instance.new("UICorner", btnSuitSettings).CornerRadius = UDim.new(1, 0)
local settingsStroke = Instance.new("UIStroke")
settingsStroke.Color = Color3.fromRGB(190, 25, 25)
settingsStroke.Thickness = 4
settingsStroke.Parent = btnSuitSettings

local suitMenu = Instance.new("Frame")
suitMenu.Name = "ChooseYourSuit"
suitMenu.Size = UDim2.new(0.96, 0, 0, 270)
suitMenu.Position = UDim2.new(0.02, 0, 0.12, 0)
suitMenu.BackgroundColor3 = Color3.fromRGB(15, 20, 35)
suitMenu.BorderSizePixel = 0
suitMenu.ZIndex = 20
suitMenu.Parent = gui
Instance.new("UICorner", suitMenu).CornerRadius = UDim.new(0, 14)
local menuStroke = Instance.new("UIStroke")
menuStroke.Color = Color3.fromRGB(220, 30, 45)
menuStroke.Thickness = 3
menuStroke.Parent = suitMenu

local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, 0, 0, 48)
title.BackgroundTransparency = 1
title.Text = "Choose Your Suit🕷"
title.TextColor3 = Color3.fromRGB(255, 55, 65)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.ZIndex = 21
title.Parent = suitMenu
local titleStroke = Instance.new("UIStroke")
titleStroke.Color = Color3.fromRGB(0, 110, 255)
titleStroke.Thickness = 0.7
titleStroke.Parent = title

local suitNames = { "2007 black suit", "Tobey Suit", "Andrew Suit", "Tom Suit" }
local suitColors = {
	Color3.fromRGB(20, 20, 25),
	Color3.fromRGB(190, 30, 40),
	Color3.fromRGB(30, 90, 210),
	Color3.fromRGB(190, 35, 45),
}
local suitAccents = {
	Color3.fromRGB(240, 240, 240),
	Color3.fromRGB(30, 100, 255),
	Color3.fromRGB(220, 35, 45),
	Color3.fromRGB(30, 100, 255),
}
local cardWidth = 0.225
local cardGap = 0.015
for i, suitName in ipairs(suitNames) do
	local card = Instance.new("Frame")
	card.Name = suitName:gsub(" ", "")
	card.Size = UDim2.new(cardWidth, 0, 0, 165)
	card.Position = UDim2.new(0.025 + (i - 1) * (cardWidth + cardGap), 0, 0, 65)
	card.BackgroundTransparency = 1
	card.ZIndex = 21
	card.Parent = suitMenu
	local square = Instance.new("TextButton")
	square.Name = "SelectSuit"
	square.Size = UDim2.new(1, 0, 0, 115)
	square.BackgroundColor3 = suitColors[i]
	square.Text = ""
	square.AutoButtonColor = true
	square.ZIndex = 22
	square.Parent = card
	Instance.new("UICorner", square).CornerRadius = UDim.new(0, 9)
	local squareStroke = Instance.new("UIStroke")
	squareStroke.Color = suitAccents[i]
	squareStroke.Thickness = 3
	squareStroke.Parent = square
	local stripe = Instance.new("Frame")
	stripe.Name = "SuitStripe"
	stripe.Size = UDim2.new(1, 0, 0, 9)
	stripe.Position = UDim2.new(0, 0, 1, -9)
	stripe.BackgroundColor3 = suitAccents[i]
	stripe.BorderSizePixel = 0
	stripe.ZIndex = 23
	stripe.Parent = square
	local label = Instance.new("TextLabel")
	label.Name = "SuitName"
	label.Size = UDim2.new(1, 8, 0, 43)
	label.Position = UDim2.new(0, -4, 0, 119)
	label.BackgroundTransparency = 1
	label.Text = suitName
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.TextScaled = true
	label.TextWrapped = true
	label.Font = Enum.Font.GothamBold
	label.ZIndex = 22
	label.Parent = card
	square.Activated:Connect(function()
		selectedSuit = suitName
		suitMenu.Visible = false
		local char = player.Character
		if char then
			outfitEnabled = true
			applyOutfit(char)
		end
	end)
end

btnSuitSettings.Activated:Connect(function()
	suitMenu.Visible = true
end)

btnOutfit.Activated:Connect(function()
	local char = player.Character
	if not char then return end
	if outfitEnabled then
		removeOutfit(char)
	else
		outfitEnabled = true
		applyOutfit(char)
	end
end)

btnMode.MouseButton1Down:Connect(function()
	if abilityMode == 1 then
		abilityMode = 2
		btnClimb.Visible = false
		btnSwing.Visible = false
		btnZip.Visible = false
		btnWing.Visible = false
		btnWebShot.Visible = true
		btnPunch.Visible = true
		btnHang.Visible = true
	else
		abilityMode = 1
		btnClimb.Visible = true
		btnSwing.Visible = true
		btnZip.Visible = true
		btnWing.Visible = true
		btnWebShot.Visible = false
		btnPunch.Visible = false
		btnHang.Visible = false
	end
end)

local function getClimbSurface()
	local char, hrp = getParts()
	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Exclude
	params.FilterDescendantsInstances = { char }
	params.IgnoreWater = true

	local up = Workspace:Raycast(hrp.Position, Vector3.new(0, 4.8, 0), params)  
	if up and up.Normal.Y < -0.45 then  
		return up, "ceiling"  
	end  

	local flatLook = Vector3.new(hrp.CFrame.LookVector.X, 0, hrp.CFrame.LookVector.Z)  
	if flatLook.Magnitude > 0.01 then  
		local lip = Workspace:Raycast(hrp.Position + Vector3.new(0, 1.4, 0), flatLook.Unit * 2.4 + Vector3.new(0, 3.2, 0), params)  
		if lip and lip.Normal.Y < -0.4 then  
			return lip, "ceiling"  
		end  
	end  

	local directions = {  
		hrp.CFrame.LookVector,  
		-hrp.CFrame.LookVector,  
		hrp.CFrame.RightVector,  
		-hrp.CFrame.RightVector,  
	}  
	local closestResult = nil  
	local closestDistance = math.huge  
	for _, direction in ipairs(directions) do  
		local result = Workspace:Raycast(hrp.Position, direction * 3.6, params)  
		if result and math.abs(result.Normal.Y) < 0.55 then  
			local distance = (result.Position - hrp.Position).Magnitude  
			if distance < closestDistance then  
				closestDistance = distance  
				closestResult = result  
			end  
		end  
	end  
	if closestResult then  
		return closestResult, "wall"  
	end  
	return nil, nil
end

local function stopClimb()
	if not climbing then return end
	climbing = false
	if climbConn then climbConn:Disconnect(); climbConn = nil end
	if climbTrack then
		if climbTrack.IsPlaying then climbTrack:Stop(0.15) end
		climbTrack = nil
	end
	if climbVelocity then climbVelocity:Destroy(); climbVelocity = nil end
	if climbAlign then climbAlign:Destroy(); climbAlign = nil end
	if climbAttachment then climbAttachment:Destroy(); climbAttachment = nil end
	local _, hrp, hum = getParts()
	hum.AutoRotate = true
	hum.PlatformStand = false
	hrp.AssemblyLinearVelocity = Vector3.zero
end

local function startClimb()
	if climbing or not climbEnabled then return end
	local _, hrp, hum = getParts()
	local wall = getClimbSurface()
	if not wall then return end
	climbing = true
	hum.AutoRotate = false
	hum.PlatformStand = false
	local animator = getAnimator(hum)
	local anim = Instance.new("Animation")
	anim.AnimationId = CLIMB_ANIM
	climbTrack = animator:LoadAnimation(anim)
	climbTrack.Priority = Enum.AnimationPriority.Action4
	climbTrack.Looped = true
	climbTrack:Play(0.1)
	hum:ChangeState(Enum.HumanoidStateType.Climbing)
	climbAttachment = Instance.new("Attachment")
	climbAttachment.Name = "SpiderClimbAttachment"
	climbAttachment.Parent = hrp
	climbVelocity = Instance.new("LinearVelocity")
	climbVelocity.Name = "SpiderClimbVelocity"
	climbVelocity.MaxForce = math.huge
	climbVelocity.RelativeTo = Enum.ActuatorRelativeTo.World
	climbVelocity.VectorVelocity = Vector3.zero
	climbVelocity.Attachment0 = climbAttachment
	climbVelocity.Parent = hrp
	climbAlign = Instance.new("AlignOrientation")
	climbAlign.Name = "SpiderClimbOrientation"
	climbAlign.Mode = Enum.OrientationAlignmentMode.OneAttachment
	climbAlign.MaxTorque = math.huge
	climbAlign.Responsiveness = 30
	climbAlign.RigidityEnabled = false
	climbAlign.Attachment0 = climbAttachment
	climbAlign.Parent = hrp
	climbConn = RunService.RenderStepped:Connect(function()
		if not climbing then return end
		if not hrp.Parent then stopClimb(); return end
		local surface, kind = getClimbSurface()
		if not surface then stopClimb(); return end
		local normal = surface.Normal
		local camera = Workspace.CurrentCamera
		local cameraForward = camera.CFrame.LookVector
		local cameraRight = camera.CFrame.RightVector
		local move = hum.MoveDirection
		if kind == "ceiling" then
			hum.PlatformStand = true
			local planar = Vector3.new(move.X, 0, move.Z)
			local speed = 0
			if planar.Magnitude > 0.08 then
				planar = planar.Unit
				speed = 12
			else
				planar = Vector3.new(cameraForward.X, 0, cameraForward.Z)
				if planar.Magnitude > 0.01 then
					planar = planar.Unit
				else
					planar = Vector3.new(0, 0, -1)
				end
			end
			climbVelocity.VectorVelocity = planar * speed + Vector3.new(0, 7, 0)
			climbAlign.CFrame = CFrame.lookAt(Vector3.zero, Vector3.new(0, 1, 0), planar)
		else
			hum.PlatformStand = false
			local horizontal = Vector3.new(move.X, 0, move.Z)
			local vertical = 0
			if horizontal.Magnitude > 0.05 then vertical = horizontal:Dot(cameraForward) end
			local up = Vector3.new(0, 1, 0)
			local wallRight = cameraRight - normal * cameraRight:Dot(normal)
			if wallRight.Magnitude > 0.01 then wallRight = wallRight.Unit end
			climbVelocity.VectorVelocity = up * vertical * 9 + wallRight * move:Dot(wallRight) * 8 - normal * 4
			local facing = -normal
			local look = Vector3.new(facing.X, 0, facing.Z)
			if look.Magnitude > 0.01 then climbAlign.CFrame = CFrame.lookAt(Vector3.zero, look.Unit) end
		end
		if hum:GetState() ~= Enum.HumanoidStateType.Climbing then hum:ChangeState(Enum.HumanoidStateType.Climbing) end
	end)
end

btnClimb.MouseButton1Down:Connect(function()
	climbEnabled = not climbEnabled
	if climbEnabled then
		if getClimbSurface() then startClimb() end
	else
		stopClimb()
	end
end)

local function stopSwing()
	if not swinging then return end
	swinging = false
	if swingConn then swingConn:Disconnect(); swingConn = nil end
	if swingTrack and swingTrack.IsPlaying then swingTrack:Stop(0.2) end
	clearIK()
	clearWebs()
	local char, hrp, hum = getParts()
	resetArmPose(char)
	hum.PlatformStand = false
	hum.JumpPower = 100
	hrp.AssemblyLinearVelocity += hrp.CFrame.LookVector * swingRelease
	if swingRope then swingRope:Destroy(); swingRope = nil end
	if swingAnchor then swingAnchor:Destroy(); swingAnchor = nil end
	gripAtt = nil
	swingStep += 1
	if swingStep > 3 then swingStep = 1 end
end

local function startSwing()
	if swinging then return end
	swinging = true
	local char, hrp, hum = getParts()
	hum.PlatformStand = true
	local animator = getAnimator(hum)
	if swingTrack then
		swingTrack:Stop(0)
		swingTrack = nil
	end
	local anim = Instance.new("Animation")
	anim.AnimationId = SWING_ANIM
	swingTrack = animator:LoadAnimation(anim)
	swingTrack.Priority = Enum.AnimationPriority.Action4
	swingTrack.Looped = true
	swingTrack:Play(0.1)
	playSound(hrp, SWING_SOUND)
	swingAnchor = Instance.new("Part")
	swingAnchor.Name = "WebAnchor"
	swingAnchor.Anchored = true
	swingAnchor.CanCollide = false
	swingAnchor.Transparency = 1
	swingAnchor.Size = Vector3.new(0.2, 0.2, 0.2)
	swingAnchor.Position = hrp.Position + hrp.CFrame.LookVector * swingDistance + Vector3.new(0, swingHeight, 0)
	swingAnchor.Parent = Workspace
	local a0 = Instance.new("Attachment")
	a0.Parent = swingAnchor
	local a1 = Instance.new("Attachment")
	a1.Parent = hrp
	swingRope = Instance.new("RopeConstraint")
	swingRope.Attachment0 = a0
	swingRope.Attachment1 = a1
	swingRope.Length = (swingAnchor.Position - hrp.Position).Magnitude
	swingRope.Visible = false
	swingRope.Parent = hrp
	if swingStep == 1 then
		addWebFromHand(char, a0, "Right")
		attachArm(char, hum, "Right", a0)
	elseif swingStep == 2 then
		addWebFromHand(char, a0, "Left")
		attachArm(char, hum, "Left", a0)
	else
		addWebFromHand(char, a0, "Right")
		addWebFromHand(char, a0, "Left")
		attachArm(char, hum, "Right", a0)
		attachArm(char, hum, "Left", a0)
	end
	hrp.AssemblyLinearVelocity += hrp.CFrame.LookVector * swingLaunch
	swingConn = RunService.Heartbeat:Connect(function()
		if not swinging or not hrp.Parent or not swingAnchor or not swingAnchor.Parent then return end
		local offset = swingAnchor.Position - hrp.Position
		if offset.Magnitude < 0.1 then return end
		local dir = offset.Unit
		local vel = hrp.AssemblyLinearVelocity
		local radial = dir * vel:Dot(dir)
		hrp.AssemblyLinearVelocity = (vel - radial) + Vector3.new(0, -Workspace.Gravity * swingGravity, 0)
	end)
end

btnZip.MouseButton1Down:Connect(function()
	stopSwing()
	local char, hrp, hum = getParts()
	local sides
	if zipStep == 1 then sides = { "Right" }
	elseif zipStep == 2 then sides = { "Left" }
	else sides = { "Right", "Left" } end
	local tip = Instance.new("Part")
	tip.Name = "WebZipTarget"
	tip.Anchored = true
	tip.CanCollide = false
	tip.Transparency = 1
	tip.Size = Vector3.new(0.2, 0.2, 0.2)
	tip.Position = hrp.Position + hrp.CFrame.LookVector * 34 + Vector3.new(0, 12, 0)
	tip.Parent = Workspace
	local tipAtt = Instance.new("Attachment")
	tipAtt.Parent = tip
	for _, side in ipairs(sides) do
		addWebFromHand(char, tipAtt, side)
		attachArm(char, hum, side, tipAtt)
	end
	local animator = getAnimator(hum)
	local zipAnim = Instance.new("Animation")
	zipAnim.AnimationId = "rbxassetid://100103306715371"
	local zipTrack = animator:LoadAnimation(zipAnim)
	zipTrack.Priority = Enum.AnimationPriority.Action4
	zipTrack.Looped = false
	zipTrack:Play(0.05)
	playSound(hrp, ZIP_SOUND)
	local push = Instance.new("BodyVelocity")
	push.MaxForce = Vector3.new(1e7, 1e7, 1e7)
	push.Velocity = hrp.CFrame.LookVector * 120 + Vector3.new(0, 55, 0)
	push.Parent = hrp
	Debris:AddItem(tip, 0.32)
	Debris:AddItem(push, 0.28)
	task.delay(0.32, function()
		clearWebs()
		clearIK()
	end)
	task.delay(0.9, function()
		if zipTrack and zipTrack.IsPlaying then
			zipTrack:Stop(0.1)
		end
		if char and char.Parent then resetArmPose(char) end
	end)
	zipStep += 1
	if zipStep > 3 then zipStep = 1 end
end)

local function clearWebShot()
	webShotPose = false
	for _, obj in ipairs(webShotObjects) do if obj and obj.Parent then obj:Destroy() end end
	table.clear(webShotObjects)
	for _, ik in ipairs(webShotIK) do if ik and ik.Parent then ik:Destroy() end end
	table.clear(webShotIK)
	local char = player.Character
	if char then resetArmPose(char) end
end

local function createGroundWeb(position, normal)
	local part = Instance.new("Part")
	part.Name = "GroundWeb"
	part.Anchored = true
	part.CanCollide = false
	part.CanTouch = false
	part.CanQuery = false
	part.Transparency = 1
	part.Size = Vector3.new(7, 0.05, 7)
	local up = normal.Unit
	local forward = Vector3.new(0, 0, -1)
	if math.abs(up:Dot(forward)) > 0.95 then forward = Vector3.new(1, 0, 0) end
	forward = (forward - up * forward:Dot(up)).Unit
	part.CFrame = CFrame.lookAt(position + up * 0.035, position + up * 0.035 + forward, up)
	part.Parent = Workspace
	local decal = Instance.new("Decal")
	decal.Texture = GROUND_WEB_TEXTURE
	decal.Face = Enum.NormalId.Top
	decal.Parent = part
	table.insert(webShotObjects, part)
	Debris:AddItem(part, 8)
end

local function fireWebProjectile(char, startPosition, direction)
	local projectile = Instance.new("Part")
	projectile.Name = "WebShotProjectile"
	projectile.Anchored = true
	projectile.CanCollide = false
	projectile.CanTouch = false
	projectile.CanQuery = false
	projectile.Transparency = 1
	projectile.Size = Vector3.new(0.35, 0.35, 0.35)
	projectile.Position = startPosition
	projectile.Parent = Workspace
	table.insert(webShotObjects, projectile)
	local frontAttachment = Instance.new("Attachment")
	frontAttachment.Parent = projectile
	local webVisual = Instance.new("Part")
	webVisual.Name = "WebShotVisual"
	webVisual.Anchored = true
	webVisual.CanCollide = false
	webVisual.CanTouch = false
	webVisual.CanQuery = false
	webVisual.Transparency = 1
	webVisual.Size = Vector3.new(0.2, 0.2, 0.2)
	webVisual.Position = startPosition - direction * 0.8
	webVisual.Parent = Workspace
	table.insert(webShotObjects, webVisual)
	local backAttachment = Instance.new("Attachment")
	backAttachment.Parent = webVisual
	local beam = Instance.new("Beam")
	beam.Attachment0 = backAttachment
	beam.Attachment1 = frontAttachment
	beam.Width0 = 0.9
	beam.Width1 = 0.9
	beam.Texture = WEB_SHOT_TEXTURE
	beam.TextureMode = Enum.TextureMode.Wrap
	beam.TextureLength = 1
	beam.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255))
	beam.LightEmission = 1
	beam.FaceCamera = true
	beam.Segments = 4
	beam.Parent = webVisual
	table.insert(webShotObjects, beam)
	local velocity = direction.Unit * 75
	local position = startPosition
	local previousPosition = position
	local elapsed = 0
	local gravity = Vector3.new(0, -120, 0)
	local connection
	connection = RunService.Heartbeat:Connect(function(dt)
		if not projectile.Parent then connection:Disconnect(); return end
		elapsed += dt
		velocity += gravity * dt
		previousPosition = position
		position += velocity * dt
		local params = RaycastParams.new()
		params.FilterType = Enum.RaycastFilterType.Exclude
		params.FilterDescendantsInstances = { char, projectile, webVisual }
		params.IgnoreWater = true
		local result = Workspace:Raycast(previousPosition, position - previousPosition, params)
		if result and result.Normal.Y > 0.45 then
			connection:Disconnect()
			projectile.Position = result.Position
			createGroundWeb(result.Position, result.Normal)
			projectile:Destroy()
			webVisual:Destroy()
			return
		end
		projectile.Position = position
		webVisual.Position = position - direction.Unit * 0.8
		if elapsed > 2.5 then
			connection:Disconnect()
			projectile:Destroy()
			webVisual:Destroy()
		end
	end)
end

local function startWebShot()
	local char, hrp, hum = getParts()
	clearWebShot()
	webShotPose = true
	local direction = hrp.CFrame.LookVector.Unit
	local rightTarget = Instance.new("Attachment")
	rightTarget.Name = "WebShotRightTarget"
	rightTarget.Position = Vector3.new(1.65, 0.15, -2.7)
	rightTarget.Parent = hrp
	table.insert(webShotObjects, rightTarget)
	local leftTarget = Instance.new("Attachment")
	leftTarget.Name = "WebShotLeftTarget"
	leftTarget.Position = Vector3.new(-1.65, 0.15, -2.7)
	leftTarget.Parent = hrp
	table.insert(webShotObjects, leftTarget)
	local rightHand = getHand(char, "Right")
	local rightRoot = getArmRoot(char, "Right")
	if rightHand and rightRoot then
		local ik = Instance.new("IKControl")
		ik.Name = "WebShotRightArmIK"
		ik.Type = Enum.IKControlType.Position
		ik.EndEffector = rightHand
		ik.ChainRoot = rightRoot
		ik.Target = rightTarget
		ik.Weight = 1
		ik.SmoothTime = 0.05
		ik.Parent = hum
		table.insert(webShotIK, ik)
	end
	local leftHand = getHand(char, "Left")
	local leftRoot = getArmRoot(char, "Left")
	if leftHand and leftRoot then
		local ik = Instance.new("IKControl")
		ik.Name = "WebShotLeftArmIK"
		ik.Type = Enum.IKControlType.Position
		ik.EndEffector = leftHand
		ik.ChainRoot = leftRoot
		ik.Target = leftTarget
		ik.Weight = 1
		ik.SmoothTime = 0.05
		ik.Parent = hum
		table.insert(webShotIK, ik)
	end
	poseShotArms(char)
	task.wait(0.12)
	if not char.Parent then clearWebShot(); return end
	rightHand = getHand(char, "Right")
	leftHand = getHand(char, "Left")
	local rightPosition = rightHand and rightHand.Position or (hrp.Position + hrp.CFrame.RightVector + Vector3.new(0, 1, 0))
	local leftPosition = leftHand and leftHand.Position or (hrp.Position - hrp.CFrame.RightVector + Vector3.new(0, 1, 0))
	playSound(hrp, WEB_SHOT_SOUND)
	fireWebProjectile(char, rightPosition, direction)
	fireWebProjectile(char, leftPosition, direction)
	task.delay(0.08, function()
		webShotPose = false
		for _, ik in ipairs(webShotIK) do if ik and ik.Parent then ik:Destroy() end end
		table.clear(webShotIK)
		if rightTarget and rightTarget.Parent then rightTarget:Destroy() end
		if leftTarget and leftTarget.Parent then leftTarget:Destroy() end
		if char and char.Parent then resetArmPose(char) end
	end)
end

btnWebShot.MouseButton1Down:Connect(function() startWebShot() end)

local hanging = false
local hangObjects = {}
local hangTrack = nil

local function stopHang()
	if not hanging then return end
	hanging = false
	if hangTrack and hangTrack.IsPlaying then
		hangTrack:Stop(0.15)
		hangTrack = nil
	end
	for _, obj in ipairs(hangObjects) do
		if obj and obj.Parent then obj:Destroy() end
	end
	table.clear(hangObjects)
	local char, hrp, hum = getParts()
	resetArmPose(char)
	hum.PlatformStand = false
	hum.AutoRotate = true
	hrp.AssemblyLinearVelocity = Vector3.new(0, -5, 0)
end

local function startHang()
	if hanging then
		stopHang()
		return
	end
	local char, hrp, hum = getParts()
	hanging = true
	hum.PlatformStand = true
	hum.AutoRotate = false

	-- Toca a animação personalizada
	local animator = getAnimator(hum)
	local anim = Instance.new("Animation")
	anim.AnimationId = HANG_ANIM
	hangTrack = animator:LoadAnimation(anim)
	hangTrack.Priority = Enum.AnimationPriority.Action4
	hangTrack.Looped = true
	hangTrack:Play(0.1)

	-- Procura o teto/estrutura acima
	local params = RaycastParams.new()  
	params.FilterType = Enum.RaycastFilterType.Exclude  
	params.FilterDescendantsInstances = { char }  
	params.IgnoreWater = true  
	local hit = Workspace:Raycast(hrp.Position, Vector3.new(0, 45, 0), params)  
	local anchorPos = hit and (hit.Position - Vector3.new(0, 0.15, 0)) or (hrp.Position + Vector3.new(0, 22, 0))  

	-- Ponto de fixação no teto
	local anchor = Instance.new("Part")  
	anchor.Name = "HangAnchor"  
	anchor.Anchored = true  
	anchor.CanCollide = false  
	anchor.Transparency = 1  
	anchor.Size = Vector3.new(0.2, 0.2, 0.2)  
	anchor.Position = anchorPos  
	anchor.Parent = Workspace  
	table.insert(hangObjects, anchor)  

	local topAtt = Instance.new("Attachment")  
	topAtt.Parent = anchor  

	-- Ponto da teia conectado ao personagem (no Torso/HRP)
	local lower = char:FindFirstChild("LowerTorso") or hrp  
	local legAtt = Instance.new("Attachment")  
	legAtt.Name = "HangLegWeb"  
	legAtt.Position = Vector3.new(0, 0, 0)  
	legAtt.Parent = lower  
	table.insert(hangObjects, legAtt)  

	-- Criação da teia (Beam)
	local web = Instance.new("Beam")  
	web.Attachment0 = topAtt  
	web.Attachment1 = legAtt  
	web.Width0 = 0.8  
	web.Width1 = 0.6  
	web.Texture = "rbxassetid://15000399146"  
	web.TextureMode = Enum.TextureMode.Wrap  
	web.TextureLength = 1  
	web.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255))  
	web.LightEmission = 1  
	web.FaceCamera = true  
	web.Parent = lower  
	table.insert(hangObjects, web)  

	local att = Instance.new("Attachment")  
	att.Parent = hrp  
	table.insert(hangObjects, att)  

	-- Posiciona o personagem mais para baixo (18 studs abaixo do teto para não subir tanto)
	local alignPos = Instance.new("AlignPosition")  
	alignPos.Mode = Enum.PositionAlignmentMode.OneAttachment  
	alignPos.Attachment0 = att  
	alignPos.MaxForce = math.huge  
	alignPos.Responsiveness = 25  
	alignPos.Position = anchorPos - Vector3.new(0, 18, 0)  
	alignPos.Parent = hrp  
	table.insert(hangObjects, alignPos)  

	local alignOri = Instance.new("AlignOrientation")  
	alignOri.Mode = Enum.OrientationAlignmentMode.OneAttachment  
	alignOri.Attachment0 = att  
	alignOri.MaxTorque = math.huge  
	alignOri.Responsiveness = 25  
	alignOri.CFrame = hrp.CFrame
	alignOri.Parent = hrp  
	table.insert(hangObjects, alignOri)  
end

btnHang.MouseButton1Down:Connect(function()
	if hanging then
		stopHang()
	else
		startHang()
	end
end)

local function restorePunchHumanoid()
	local state = savedPunchHumanoidState
	savedPunchHumanoidState = nil
	if state and state.humanoid and state.humanoid.Parent then
		state.humanoid.AutoRotate = state.autoRotate
		state.humanoid.PlatformStand = state.platformStand
		if not state.platformStand then
			state.humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
		end
	end
end

local function clearPunch()
	punchGeneration += 1
	if punchConn then
		punchConn:Disconnect()
		punchConn = nil
	end
	for _, obj in ipairs(punchObjects) do
		if obj and obj.Parent then obj:Destroy() end
	end
	table.clear(punchObjects)
	if kickTrack and kickTrack.IsPlaying then
		kickTrack:Stop(0.1)
	end
	kickTrack = nil
	restorePunchHumanoid()
	punching = false
	local char = player.Character
	if char then resetArmPose(char) end
end

local function beginPunch(char, hum)
	clearPunch()
	punching = true
	savedPunchHumanoidState = {
		humanoid = hum,
		autoRotate = hum.AutoRotate,
		platformStand = hum.PlatformStand,
	}
	return punchGeneration
end

local function playPunch(side)
	if punching then return end
	local char, hrp, hum = getParts()
	if hum.Health <= 0 then return end
	local generation = beginPunch(char, hum)
	local startTime = os.clock()
	local sign = side == "Right" and 1 or -1
	local other = side == "Right" and "Left" or "Right"
	local target = Instance.new("Attachment")
	target.Name = "SpiderAcrobaticPunchTarget"
	target.Parent = hrp
	table.insert(punchObjects, target)
	local hand = getHand(char, side)
	local root = getArmRoot(char, side)
	if hand and root then
		local ik = Instance.new("IKControl")
		ik.Name = "SpiderAcrobaticPunchIK_" .. side
		ik.Type = Enum.IKControlType.Position
		ik.EndEffector = hand
		ik.ChainRoot = root
		ik.Target = target
		ik.Weight = 1
		ik.SmoothTime = 0.045
		ik.Parent = hum
		table.insert(punchObjects, ik)
	end
	local spinAttachment = Instance.new("Attachment")
	spinAttachment.Name = "SpiderPunchSpinAttachment"
	spinAttachment.Parent = hrp
	table.insert(punchObjects, spinAttachment)
	local spin = Instance.new("AngularVelocity")
	spin.Name = "SpiderPunchBodyTwist"
	spin.Attachment0 = spinAttachment
	spin.RelativeTo = Enum.ActuatorRelativeTo.World
	spin.MaxTorque = 0
	spin.AngularVelocity = Vector3.zero
	spin.Parent = hrp
	table.insert(punchObjects, spin)
	hum.AutoRotate = false
	punchConn = RunService.Heartbeat:Connect(function()
		if generation ~= punchGeneration then return end
		if not char.Parent or not hrp.Parent or hum.Health <= 0 then
			clearPunch()
			return
		end
		local t = os.clock() - startTime
		if t < 0.12 then
			target.Position = Vector3.new(sign * 0.95, 0.15, 0.15)
			setMotor(char, "Waist", CFrame.Angles(math.rad(18), math.rad(-sign * 34), math.rad(sign * 10)))
			setMotor(char, side .. "Shoulder", CFrame.Angles(math.rad(-38), math.rad(sign * 35), math.rad(-sign * 78)))
			setMotor(char, side .. "Elbow", CFrame.Angles(math.rad(-105), 0, math.rad(sign * 8)))
			setMotor(char, other .. "Shoulder", CFrame.Angles(math.rad(35), math.rad(-sign * 18), math.rad(sign * 48)))
			setMotor(char, other .. "Elbow", CFrame.Angles(math.rad(-72), 0, 0))
			setMotor(char, "RightHip", CFrame.Angles(math.rad(-20), 0, math.rad(8)))
			setMotor(char, "LeftHip", CFrame.Angles(math.rad(-20), 0, math.rad(-8)))
			setMotor(char, "RightKnee", CFrame.Angles(math.rad(28), 0, 0))
			setMotor(char, "LeftKnee", CFrame.Angles(math.rad(28), 0, 0))
			spin.MaxTorque = 0
		elseif t < 0.23 then
			target.Position = Vector3.new(sign * 0.55, 0.55, -1.55)
			setMotor(char, "Waist", CFrame.Angles(math.rad(-8), math.rad(sign * 25), math.rad(-sign * 8)))
			setMotor(char, side .. "Shoulder", CFrame.Angles(math.rad(58), math.rad(sign * 18), math.rad(-sign * 22)))
			setMotor(char, side .. "Elbow", CFrame.Angles(math.rad(-42), 0, 0))
			setMotor(char, other .. "Shoulder", CFrame.Angles(math.rad(45), math.rad(-sign * 24), math.rad(sign * 38)))
			setMotor(char, other .. "Elbow", CFrame.Angles(math.rad(-82), 0, 0))
			setMotor(char, "RightHip", CFrame.Angles(math.rad(18), 0, math.rad(12)))
			setMotor(char, "LeftHip", CFrame.Angles(math.rad(-32), 0, math.rad(-10)))
			setMotor(char, "RightKnee", CFrame.Angles(math.rad(-18), 0, 0))
			setMotor(char, "LeftKnee", CFrame.Angles(math.rad(35), 0, 0))
			spin.MaxTorque = 0
		elseif t < 0.36 then
			target.Position = Vector3.new(sign * 0.18, 0.38, -3.1)
			setMotor(char, "Waist", CFrame.Angles(math.rad(-15), math.rad(sign * 42), math.rad(-sign * 12)))
			setMotor(char, side .. "Shoulder", CFrame.Angles(math.rad(105), math.rad(sign * 7), math.rad(-sign * 5)))
			setMotor(char, side .. "Elbow", CFrame.Angles(math.rad(-5), 0, 0))
			setMotor(char, other .. "Shoulder", CFrame.Angles(math.rad(12), math.rad(-sign * 32), math.rad(sign * 24)))
			setMotor(char, other .. "Elbow", CFrame.Angles(math.rad(-58), 0, 0))
			setMotor(char, "RightHip", CFrame.Angles(math.rad(32), 0, math.rad(10)))
			setMotor(char, "LeftHip", CFrame.Angles(math.rad(-40), 0, math.rad(-12)))
			setMotor(char, "RightKnee", CFrame.Angles(math.rad(-22), 0, 0))
			setMotor(char, "LeftKnee", CFrame.Angles(math.rad(42), 0, 0))
			if t < 0.27 then
				hrp.AssemblyLinearVelocity = hrp.CFrame.LookVector * 28 + Vector3.new(0, math.max(hrp.AssemblyLinearVelocity.Y, 5), 0)
			end
			spin.MaxTorque = 0
		elseif t < 0.48 then
			target.Position = Vector3.new(sign * 0.55, 0.45, -1.15)
			setMotor(char, "Waist", CFrame.Angles(math.rad(8), math.rad(-sign * 22), math.rad(sign * 6)))
			setMotor(char, side .. "Shoulder", CFrame.Angles(math.rad(48), math.rad(sign * 22), math.rad(-sign * 34)))
			setMotor(char, side .. "Elbow", CFrame.Angles(math.rad(-62), 0, 0))
			setMotor(char, other .. "Shoulder", CFrame.Angles(math.rad(38), math.rad(-sign * 16), math.rad(sign * 30)))
			setMotor(char, other .. "Elbow", CFrame.Angles(math.rad(-70), 0, 0))
			setMotor(char, "RightHip", CFrame.Angles(math.rad(-8), 0, math.rad(5)))
			setMotor(char, "LeftHip", CFrame.Angles(math.rad(12), 0, math.rad(-5)))
			setMotor(char, "RightKnee", CFrame.Angles(math.rad(12), 0, 0))
			setMotor(char, "LeftKnee", CFrame.Angles(math.rad(8), 0, 0))
			spin.MaxTorque = 0
		elseif t < 0.66 then
			target.Position = Vector3.new(sign * 0.35, 0.3, -0.35)
			setMotor(char, "Waist", CFrame.Angles(math.rad(3), math.rad(-sign * 8), 0))
			setMotor(char, side .. "Shoulder", CFrame.Angles(math.rad(18), math.rad(sign * 8), math.rad(-sign * 12)))
			setMotor(char, side .. "Elbow", CFrame.Angles(math.rad(-35), 0, 0))
			setMotor(char, other .. "Shoulder", CFrame.Angles(math.rad(18), math.rad(-sign * 8), math.rad(sign * 12)))
			setMotor(char, other .. "Elbow", CFrame.Angles(math.rad(-35), 0, 0))
			setMotor(char, "RightHip", CFrame.identity)
			setMotor(char, "LeftHip", CFrame.identity)
			setMotor(char, "RightKnee", CFrame.identity)
			setMotor(char, "LeftKnee", CFrame.identity)
			spin.MaxTorque = 0
		else
			clearPunch()
			return
		end
	end)
end

local function playKick()
	if punching then return end
	local char, hrp, hum = getParts()
	if hum.Health <= 0 then return end
	local generation = beginPunch(char, hum)
	hum.AutoRotate = false
	hum.PlatformStand = false
	local animator = getAnimator(hum)
	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://133566007754001"
	kickTrack = animator:LoadAnimation(anim)
	kickTrack.Priority = Enum.AnimationPriority.Action4
	kickTrack.Looped = false
	kickTrack:Play(0.05)
	local length = kickTrack.Length
	if length <= 0 then
		length = 1.2
	end
	task.delay(length + 0.05, function()
		if generation ~= punchGeneration then return end
		clearPunch()
	end)
end

btnPunch.MouseButton1Down:Connect(function()
	local now = tick()
	if now - lastPunchTime > 1.05 then punchStep = 1 end
	lastPunchTime = now
	if punching then return end
	if punchStep == 1 then
		playPunch("Right")
	elseif punchStep == 2 then
		playPunch("Left")
	else
		playKick()
	end
	punchStep += 1
	if punchStep > 3 then punchStep = 1 end
end)

local function createWebWingTarget(hrp, name, position)
	local attachment = Instance.new("Attachment")
	attachment.Name = name
	attachment.Position = position
	attachment.Parent = hrp
	table.insert(webWingObjects, attachment)
	return attachment
end

local function createWebWingBeam(target, hand)
	if not target or not hand then return end
	local handAttachment = Instance.new("Attachment")
	handAttachment.Name = "WebWingHandAttachment"
	handAttachment.Parent = hand
	local beam = Instance.new("Beam")
	beam.Attachment0 = target
	beam.Attachment1 = handAttachment
	beam.Width0 = 0.92
	beam.Width1 = 0.72
	beam.Texture = "rbxassetid://15000399146"
	beam.TextureMode = Enum.TextureMode.Wrap
	beam.TextureLength = 1
	beam.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255))
	beam.LightEmission = 1
	beam.FaceCamera = true
	beam.Parent = hand
	table.insert(webWingObjects, handAttachment)
	table.insert(webWingObjects, beam)
end

local function stopWebWing()
	if not webWing then return end
	webWing = false
	if webWingSound then
		webWingSound:Stop()
		webWingSound:Destroy()
		webWingSound = nil
	end
	if webWingConn then webWingConn:Disconnect(); webWingConn = nil end
	for _, ik in ipairs(webWingIK) do if ik and ik.Parent then ik:Destroy() end end
	table.clear(webWingIK)
	for _, obj in ipairs(webWingObjects) do if obj and obj.Parent then obj:Destroy() end end
	table.clear(webWingObjects)
	if webWingAlign then webWingAlign:Destroy(); webWingAlign = nil end
	if webWingAttachment then webWingAttachment:Destroy(); webWingAttachment = nil end
	if webWingRightHip and webWingRightHip.Parent then webWingRightHip.Transform = webWingRightHipOriginal or CFrame.identity end
	if webWingLeftHip and webWingLeftHip.Parent then webWingLeftHip.Transform = webWingLeftHipOriginal or CFrame.identity end
	webWingRightHip = nil
	webWingLeftHip = nil
	webWingRightHipOriginal = nil
	webWingLeftHipOriginal = nil
	webWingHeadLook = nil
	local char, _, hum = getParts()
	resetArmPose(char)
	hum.AutoRotate = true
	hum.PlatformStand = false
end

local function startWebWing()
	if webWing then stopWebWing(); return end
	local char, hrp, hum = getParts()
	if hum.FloorMaterial ~= Enum.Material.Air then return end
	webWing = true
	webWingSound = Instance.new("Sound")
	webWingSound.Name = "WebWingSound"
	webWingSound.SoundId = WEB_WING_SOUND
	webWingSound.Volume = 2
	webWingSound.Looped = true
	webWingSound.Parent = hrp
	webWingSound:Play()
	hum.AutoRotate = false
	hum.PlatformStand = true
	local rightArmTarget = createWebWingTarget(hrp, "WebWingRightArmTarget", Vector3.new(2.45, 0.35, 0.05))
	local leftArmTarget = createWebWingTarget(hrp, "WebWingLeftArmTarget", Vector3.new(-2.45, 0.35, 0.05))
	local rightUpperLeg = char:FindFirstChild("RightUpperLeg")
	local leftUpperLeg = char:FindFirstChild("LeftUpperLeg")
	if rightUpperLeg then
		local hip = rightUpperLeg:FindFirstChild("RightHip")
		if hip and hip:IsA("Motor6D") then webWingRightHip = hip; webWingRightHipOriginal = hip.Transform end
	end
	if leftUpperLeg then
		local hip = leftUpperLeg:FindFirstChild("LeftHip")
		if hip and hip:IsA("Motor6D") then webWingLeftHip = hip; webWingLeftHipOriginal = hip.Transform end
	end
	local rightHand = getHand(char, "Right")
	local rightArmRoot = getArmRoot(char, "Right")
	if rightHand and rightArmRoot then
		local ik = Instance.new("IKControl")
		ik.Name = "WebWingRightArmIK"
		ik.Type = Enum.IKControlType.Position
		ik.EndEffector = rightHand
		ik.ChainRoot = rightArmRoot
		ik.Target = rightArmTarget
		ik.Weight = 1
		ik.SmoothTime = 0.08
		ik.Parent = hum
		table.insert(webWingIK, ik)
	end
	local leftHand = getHand(char, "Left")
	local leftArmRoot = getArmRoot(char, "Left")
	if leftHand and leftArmRoot then
		local ik = Instance.new("IKControl")
		ik.Name = "WebWingLeftArmIK"
		ik.Type = Enum.IKControlType.Position
		ik.EndEffector = leftHand
		ik.ChainRoot = leftArmRoot
		ik.Target = leftArmTarget
		ik.Weight = 1
		ik.SmoothTime = 0.08
		ik.Parent = hum
		table.insert(webWingIK, ik)
	end
	createWebWingBeam(rightArmTarget, rightHand)
	createWebWingBeam(leftArmTarget, leftHand)
	webWingAttachment = Instance.new("Attachment")
	webWingAttachment.Name = "WebWingOrientation"
	webWingAttachment.Parent = hrp
	webWingAlign = Instance.new("AlignOrientation")
	webWingAlign.Name = "WebWingAlign"
	webWingAlign.Mode = Enum.OrientationAlignmentMode.OneAttachment
	webWingAlign.Attachment0 = webWingAttachment
	webWingAlign.MaxTorque = math.huge
	webWingAlign.Responsiveness = 20
	webWingAlign.RigidityEnabled = false
	webWingAlign.Parent = hrp
	local head = char:FindFirstChild("Head")
	local upper = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
	webWingHeadLook = Instance.new("Attachment")
	webWingHeadLook.Name = "WebWingHeadLook"
	webWingHeadLook.Parent = hrp
	table.insert(webWingObjects, webWingHeadLook)
	if head and upper then
		local ik = Instance.new("IKControl")
		ik.Name = "WebWingHeadIK"
		ik.Type = Enum.IKControlType.LookAt
		ik.EndEffector = head
		ik.ChainRoot = upper
		ik.Target = webWingHeadLook
		ik.Weight = 1
		ik.SmoothTime = 0.08
		ik.Parent = hum
		table.insert(webWingIK, ik)
	end
	webWingConn = RunService.RenderStepped:Connect(function()
		if not webWing then return end
		if not hrp.Parent then stopWebWing(); return end
		local camera = Workspace.CurrentCamera
		if not camera then return end
		local cameraLook = camera.CFrame.LookVector
		local forward = Vector3.new(cameraLook.X, 0, cameraLook.Z)
		if forward.Magnitude < 0.01 then return end
		forward = forward.Unit
		hrp.AssemblyLinearVelocity = forward * 55 + Vector3.new(0, -4, 0)
		webWingAlign.CFrame = CFrame.lookAt(Vector3.zero, Vector3.new(0, -1, 0), forward)
		poseWingArms(char)
		if webWingRightHip and webWingRightHip.Parent then
			webWingRightHip.Transform = CFrame.Angles(math.rad(-18), math.rad(8), math.rad(8))
		end
		if webWingLeftHip and webWingLeftHip.Parent then
			webWingLeftHip.Transform = CFrame.Angles(math.rad(-18), math.rad(-8), math.rad(-8))
		end
		if webWingHeadLook and webWingHeadLook.Parent and head then
			webWingHeadLook.WorldPosition = head.Position + forward * 10 + Vector3.new(0, 2, 0)
		end
	end)
end

btnWing.MouseButton1Down:Connect(function()
	if webWing then stopWebWing() else startWebWing() end
end)

btnSwing.MouseButton1Down:Connect(startSwing)
btnSwing.MouseButton1Up:Connect(stopSwing)
btnSwing.MouseLeave:Connect(stopSwing)

local chargingJump = false
local jumpCharge = 0
local jumpChargeConn = nil
local jumpBar = nil
local jumpFill = nil
local savedWalkSpeed = 16

local function hideDefaultJump()
	local touchGui = playerGui:FindFirstChild("TouchGui")
	if not touchGui then return end
	local jumpButton = touchGui:FindFirstChild("JumpButton", true)
	if jumpButton then
		jumpButton.Visible = false
	end
end

task.spawn(function()
	while gui.Parent do
		hideDefaultJump()
		task.wait(0.4)
	end
end)

local function clearJumpBar()
	if jumpBar and jumpBar.Parent then
		jumpBar:Destroy()
	end
	jumpBar = nil
	jumpFill = nil
end

local function ensureJumpBar()
	local char, hrp = getParts()
	if jumpBar and jumpBar.Parent then
		return
	end
	jumpBar = Instance.new("BillboardGui")
	jumpBar.Name = "ChargeJumpBar"
	jumpBar.Size = UDim2.fromOffset(130, 16)
	jumpBar.StudsOffset = Vector3.new(0, 3.4, 0)
	jumpBar.AlwaysOnTop = true
	jumpBar.LightInfluence = 0
	jumpBar.Parent = hrp

	local bg = Instance.new("Frame")  
	bg.Size = UDim2.fromScale(1, 1)  
	bg.BackgroundColor3 = Color3.fromRGB(12, 16, 30)  
	bg.BorderSizePixel = 0  
	bg.Parent = jumpBar  
	Instance.new("UICorner", bg).CornerRadius = UDim.new(1, 0)  
	local stroke = Instance.new("UIStroke")  
	stroke.Color = Color3.fromRGB(0, 110, 255)  
	stroke.Thickness = 2  
	stroke.Parent = bg  

	jumpFill = Instance.new("Frame")  
	jumpFill.Size = UDim2.fromScale(0, 1)  
	jumpFill.BackgroundColor3 = Color3.fromRGB(0, 110, 255)  
	jumpFill.BorderSizePixel = 0  
	jumpFill.Parent = bg  
	Instance.new("UICorner", jumpFill).CornerRadius = UDim.new(1, 0)  

	local accent = Instance.new("Frame")  
	accent.Size = UDim2.new(1, 0, 0, 3)  
	accent.Position = UDim2.new(0, 0, 1, -3)  
	accent.BackgroundColor3 = Color3.fromRGB(220, 35, 45)  
	accent.BorderSizePixel = 0  
	accent.Parent = bg
end

local function setJumpFill(alpha)
	if not jumpFill then return end
	jumpFill.Size = UDim2.fromScale(math.clamp(alpha, 0, 1), 1)
	jumpFill.BackgroundColor3 = Color3.fromRGB(0, 110, 255):Lerp(Color3.fromRGB(220, 30, 45), alpha)
end

local function releaseChargeJump()
	if not chargingJump then return end
	chargingJump = false
	if jumpChargeConn then
		jumpChargeConn:Disconnect()
		jumpChargeConn = nil
	end
	local _, hrp, hum = getParts()
	local power = 55 + jumpCharge * 130
	local look = Vector3.new(hrp.CFrame.LookVector.X, 0, hrp.CFrame.LookVector.Z)
	if look.Magnitude < 0.01 then
		look = Vector3.new(0, 0, -1)
	else
		look = look.Unit
	end
	hum.UseJumpPower = true
	hum.JumpPower = power
	hum.WalkSpeed = savedWalkSpeed
	hum:ChangeState(Enum.HumanoidStateType.Jumping)
	hrp.AssemblyLinearVelocity = look * (20 + jumpCharge * 95) + Vector3.new(0, power * 0.78, 0)
	clearJumpBar()
	jumpCharge = 0
	task.delay(0.35, function()
		if hum and hum.Parent then
			hum.JumpPower = 100
		end
	end)
end

local function startChargeJump()
	if chargingJump then return end
	chargingJump = true
	jumpCharge = 0
	local _, _, hum = getParts()
	savedWalkSpeed = hum.WalkSpeed
	hum.WalkSpeed = savedWalkSpeed + 10
	ensureJumpBar()
	setJumpFill(0)
	local startTime = os.clock()
	jumpChargeConn = RunService.Heartbeat:Connect(function()
		if not chargingJump then return end
		jumpCharge = math.clamp((os.clock() - startTime) / 1.15, 0, 1)
		setJumpFill(jumpCharge)
	end)
end

btnJump.MouseButton1Down:Connect(startChargeJump)
btnJump.MouseButton1Up:Connect(releaseChargeJump)
btnJump.MouseLeave:Connect(releaseChargeJump)

RunService.Stepped:Connect(function()
	local char = player.Character
	if not char then return end
	if webWing then poseWingArms(char)
	elseif webShotPose then poseShotArms(char)
	elseif punching then
	end
end)

player.CharacterAdded:Connect(function()
	if swinging then stopSwing() end
	if climbing then stopClimb() end
	if webWing then stopWebWing() end
	clearWebShot()
	clearPunch()
	if hanging then stopHang() end
	clearJumpBar()
	chargingJump = false
	local char = player.Character
	if char then
		local hum = char:FindFirstChildOfClass("Humanoid")
		if hum then hum.WalkSpeed = 16 end
	end
	climbEnabled = false
	swingStep = 1
	zipStep = 1
	punchStep = 1
	abilityMode = 1
	btnClimb.Visible = true
	btnSwing.Visible = true
	btnZip.Visible = true
	btnWing.Visible = true
	btnWebShot.Visible = false
	btnPunch.Visible = false
	btnHang.Visible = false
end)

print("Spider system carregado")
