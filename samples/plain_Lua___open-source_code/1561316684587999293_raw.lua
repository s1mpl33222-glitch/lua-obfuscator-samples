--// FTF ESP & HITBOX EXPANDER - ACCURATE + LOW END OPTIMIZED
--// Players: Green
--// Beast: Red
--// Computers: Blue / Green when actually completed
--// Freeze Pods: White / Yellow when occupied
--// Exits: White
--// Cached object detection - no constant Workspace:GetDescendants()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")

local LP = Players.LocalPlayer

--==================================================
-- CLEANUP
--==================================================

pcall(function()
	local old = CoreGui:FindFirstChild("FTF_ESP")
	if old then
		old:Destroy()
	end
end)

--==================================================
-- GUI
--==================================================

local GUI = Instance.new("ScreenGui")
GUI.Name = "FTF_ESP"
GUI.ResetOnSpawn = false
GUI.IgnoreGuiInset = true
GUI.Parent = CoreGui

local Main = Instance.new("Frame")
Main.Size = UDim2.fromOffset(225,360)
Main.Position = UDim2.new(0.5,-112,0.5,-180)
Main.BackgroundColor3 = Color3.fromRGB(20,20,20)
Main.BorderSizePixel = 0
Main.Parent = GUI

Instance.new("UICorner",Main).CornerRadius = UDim.new(0,10)

local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(60,60,60)
Stroke.Thickness = 1
Stroke.Parent = Main

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,0,0,42)
Title.BackgroundTransparency = 1
Title.Text = "FLEE THE FACILITY"
Title.TextColor3 = Color3.new(1,1,1)
Title.TextSize = 15
Title.Font = Enum.Font.GothamBold
Title.Parent = Main

--==================================================
-- DRAG
--==================================================

local dragging = false
local dragStart
local startPosition

Title.InputBegan:Connect(function(input)

	if input.UserInputType == Enum.UserInputType.MouseButton1
	or input.UserInputType == Enum.UserInputType.Touch then

		dragging = true
		dragStart = input.Position
		startPosition = Main.Position

		input.Changed:Connect(function()

			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end

		end)
	end
end)

UserInputService.InputChanged:Connect(function(input)

	if not dragging then
		return
	end

	if input.UserInputType == Enum.UserInputType.MouseMovement
	or input.UserInputType == Enum.UserInputType.Touch then

		local delta = input.Position - dragStart

		Main.Position = UDim2.new(
			startPosition.X.Scale,
			startPosition.X.Offset + delta.X,
			startPosition.Y.Scale,
			startPosition.Y.Offset + delta.Y
		)
	end
end)

--==================================================
-- OPEN/CLOSE
--==================================================

local Toggle = Instance.new("TextButton")
Toggle.Size = UDim2.fromOffset(60,42)
Toggle.Position = UDim2.new(0,12,0.5,-21)
Toggle.BackgroundColor3 = Color3.fromRGB(20,20,20)
Toggle.Text = "Close"
Toggle.TextColor3 = Color3.new(1,1,1)
Toggle.TextSize = 14
Toggle.Font = Enum.Font.GothamBold
Toggle.Parent = GUI

Instance.new("UICorner",Toggle).CornerRadius = UDim.new(0,9)

local Open = true

Toggle.MouseButton1Click:Connect(function()

	Open = not Open

	Main.Visible = Open
	Toggle.Text = Open and "Close" or "Open"

end)

--==================================================
-- SETTINGS
--==================================================

local Settings = {
	Players = true,
	Computers = true,
	Pods = true,
	Exits = true,
	FPSBoost = false,
	HitboxExpander = false,
	HitboxSize = 2
}

local COLORS = {
	Player = Color3.fromRGB(70,255,110),
	Beast = Color3.fromRGB(255,50,50),

	Computer = Color3.fromRGB(50,140,255),
	FinishedComputer = Color3.fromRGB(70,255,110),

	Pod = Color3.fromRGB(255,255,255),
	OccupiedPod = Color3.fromRGB(255,220,40),

	Exit = Color3.fromRGB(255,255,255)
}

--==================================================
-- ESP STORAGE
--==================================================

local ESP = {}

local Computers = {}
local Pods = {}
local Exits = {}

--==================================================
-- BUTTONS
--==================================================

local function makeButton(text,y,key)

	local button = Instance.new("TextButton")

	button.Size = UDim2.new(1,-30,0,38)
	button.Position = UDim2.fromOffset(15,y)

	button.BackgroundColor3 = Color3.fromRGB(35,35,35)

	button.TextColor3 = Color3.new(1,1,1)
	button.TextSize = 13
	button.Font = Enum.Font.GothamMedium

	button.Text =
		text .. ": " ..
		(Settings[key] and "ON" or "OFF")

	button.Parent = Main

	Instance.new("UICorner",button).CornerRadius = UDim.new(0,7)

	return button
end

local PlayerButton = makeButton("Players",48,"Players")
local ComputerButton = makeButton("Computers",91,"Computers")
local PodButton = makeButton("Freeze Pods",134,"Pods")
local ExitButton = makeButton("Exits",177,"Exits")

local HitboxButton = makeButton("Hitbox Expander",220,"HitboxExpander")

local FPSButton = Instance.new("TextButton")
FPSButton.Size = UDim2.new(1,-30,0,38)
FPSButton.Position = UDim2.fromOffset(15,263)
FPSButton.BackgroundColor3 = Color3.fromRGB(35,35,35)
FPSButton.TextColor3 = Color3.new(1,1,1)
FPSButton.TextSize = 13
FPSButton.Font = Enum.Font.GothamMedium
FPSButton.Text = "FPS Boost: OFF"
FPSButton.Parent = Main

Instance.new("UICorner",FPSButton).CornerRadius = UDim.new(0,7)

--==================================================
-- SLIDER (1 - 10)
--==================================================

local SliderContainer = Instance.new("Frame")
SliderContainer.Size = UDim2.new(1,-30,0,38)
SliderContainer.Position = UDim2.fromOffset(15,306)
SliderContainer.BackgroundColor3 = Color3.fromRGB(35,35,35)
SliderContainer.Parent = Main

Instance.new("UICorner",SliderContainer).CornerRadius = UDim.new(0,7)

local SliderLabel = Instance.new("TextLabel")
SliderLabel.Size = UDim2.new(1,0,0,16)
SliderLabel.BackgroundTransparency = 1
SliderLabel.Text = "Hitbox Size: 2"
SliderLabel.TextColor3 = Color3.new(1,1,1)
SliderLabel.TextSize = 12
SliderLabel.Font = Enum.Font.GothamMedium
SliderLabel.Parent = SliderContainer

local SliderBar = Instance.new("Frame")
SliderBar.Size = UDim2.new(1,-20,0,6)
SliderBar.Position = UDim2.new(0,10,0,24)
SliderBar.BackgroundColor3 = Color3.fromRGB(60,60,60)
SliderBar.BorderSizePixel = 0
SliderBar.Parent = SliderContainer

Instance.new("UICorner",SliderBar).CornerRadius = UDim.new(1,0)

local SliderFill = Instance.new("Frame")
SliderFill.Size = UDim2.new((Settings.HitboxSize - 1) / 9,0,1,0)
SliderFill.BackgroundColor3 = Color3.fromRGB(70,130,255)
SliderFill.BorderSizePixel = 0
SliderFill.Parent = SliderBar

Instance.new("UICorner",SliderFill).CornerRadius = UDim.new(1,0)

local draggingSlider = false

local function updateSlider(input)
	local pos = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
	local val = math.floor(1 + (pos * 9))
	Settings.HitboxSize = val
	SliderLabel.Text = "Hitbox Size: " .. tostring(val)
	SliderFill.Size = UDim2.new(pos, 0, 1, 0)
end

SliderBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		draggingSlider = true
		updateSlider(input)
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		draggingSlider = false
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if draggingSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		updateSlider(input)
	end
end)

--==================================================
-- ESP CREATION
--==================================================

local function removeESP(object)

	local data = ESP[object]

	if not data then
		return
	end

	if data.Highlight then
		data.Highlight:Destroy()
	end

	if data.Billboard then
		data.Billboard:Destroy()
	end

	ESP[object] = nil
end

local function clearType(typeName)

	for object,data in pairs(ESP) do

		if data.Type == typeName then
			removeESP(object)
		end

	end
end

local function getAdornee(object)

	if object:IsA("Model") then

		return object:FindFirstChild("Head")
			or object.PrimaryPart
			or object:FindFirstChildWhichIsA("BasePart")

	elseif object:IsA("BasePart") then

		return object
	end

	return nil
end

local function makeLabel(object,text,color)

	local adornee = getAdornee(object)

	if not adornee then
		return nil,nil
	end

	local billboard = Instance.new("BillboardGui")

	billboard.Name = "FTF_Label"
	billboard.Adornee = adornee
	billboard.Size = UDim2.fromOffset(135,25)
	billboard.StudsOffset = Vector3.new(0,3.5,0)
	billboard.AlwaysOnTop = true

	-- Smaller render distance helps low-end devices.
	billboard.MaxDistance = 600

	billboard.Parent = GUI

	local label = Instance.new("TextLabel")

	label.Size = UDim2.fromScale(1,1)
	label.BackgroundTransparency = 1
	label.Text = text
	label.TextColor3 = color
	label.TextStrokeTransparency = 0
	label.TextStrokeColor3 = Color3.new(0,0,0)
	label.TextSize = 13
	label.Font = Enum.Font.GothamBold
	label.Parent = billboard

	return billboard,label
end

local function addESP(object,color,typeName,text)

	if ESP[object] then
		return
	end

	if not object or not object.Parent then
		return
	end

	local highlight = Instance.new("Highlight")

	highlight.Name = "FTF_ESP"
	highlight.Adornee = object

	highlight.FillColor = color
	highlight.OutlineColor = color

	highlight.FillTransparency = 0.65
	highlight.OutlineTransparency = 0

	highlight.DepthMode =
		Enum.HighlightDepthMode.AlwaysOnTop

	highlight.Parent = object

	local billboard,label =
		makeLabel(object,text,color)

	ESP[object] = {
		Highlight = highlight,
		Billboard = billboard,
		Label = label,

		Type = typeName,

		Color = color,
		Text = text
	}
end

local function updateESP(object,color,text)

	local data = ESP[object]

	if not data then
		return
	end

	if not object.Parent then
		removeESP(object)
		return
	end

	if data.Color ~= color then

		data.Highlight.FillColor = color
		data.Highlight.OutlineColor = color

		if data.Label then
			data.Label.TextColor3 = color
		end

		data.Color = color
	end

	if data.Text ~= text then

		if data.Label then
			data.Label.Text = text
		end

		data.Text = text
	end
end

--==================================================
-- ACCURATE BEAST DETECTION
--==================================================

local function isBeast(player)

	-- Primary FTF state
	local stats =
		player:FindFirstChild("TempPlayerStatsModule")

	if stats then

		local beastValue =
			stats:FindFirstChild("IsBeast")

		if beastValue
		and beastValue:IsA("BoolValue") then

			return beastValue.Value
		end
	end

	-- Fallback used by FTF character
	local character = player.Character

	if character then

		local powers =
			character:FindFirstChild("BeastPowers")

		if powers then
			return true
		end
	end

	return false
end

--==================================================
-- HITBOX EXPANDER LOGIC
--==================================================

local originalSizes = {}

local function updateHitboxes()
	if not Settings.HitboxExpander then
		for char, parts in pairs(originalSizes) do
			if char and char.Parent then
				for _, data in ipairs(parts) do
					if data.Part and data.Part.Parent then
						data.Part.Size = data.OriginalSize
						data.Part.Transparency = data.OriginalTransparency
						data.Part.CanCollide = data.OriginalCanCollide
					end
				end
			end
		end
		table.clear(originalSizes)
		return
	end

	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LP then
			local char = player.Character
			if char and char.Parent then
				local humanoidRootPart = char:FindFirstChild("HumanoidRootPart")
				if humanoidRootPart then
					if not originalSizes[char] then
						originalSizes[char] = {}
						for _, part in ipairs(char:GetChildren()) do
							if part:IsA("BasePart") then
								table.insert(originalSizes[char], {
									Part = part,
									OriginalSize = part.Size,
									OriginalTransparency = part.Transparency,
									OriginalCanCollide = part.CanCollide
								})
							end
						end
					end

					-- Apply scaling
					local scale = Settings.HitboxSize
					for _, data in ipairs(originalSizes[char]) do
						local part = data.Part
						if part and part.Parent then
							part.Size = data.OriginalSize * scale
							part.Transparency = 0.75 -- Semi-transparent so you can see it
							part.CanCollide = false
						end
					end
				end
			end
		end
	end
end

--==================================================
-- PLAYER ESP
--==================================================

local function updatePlayers()

	if not Settings.Players then
		return
	end

	for _,player in ipairs(Players:GetPlayers()) do

		if player ~= LP then

			local character =
				player.Character

			if character
			and character.Parent then

				local color =
					isBeast(player)
					and COLORS.Beast
					or COLORS.Player

				local name =
					player.DisplayName

				if not ESP[character] then

					addESP(
						character,
						color,
						"Players",
						name
					)

				else

					updateESP(
						character,
						color,
						name
					)
				end
			end
		end
	end
end

--==================================================
-- ACCURATE COMPUTER DETECTION
--==================================================

local function isComputer(object)

	if not object:IsA("Model") then
		return false
	end

	-- FTF computers use this exact model.
	if object.Name ~= "ComputerTable" then
		return false
	end

	-- A real ComputerTable has a Screen.
	local screen =
		object:FindFirstChild("Screen")

	if not screen then
		return false
	end

	return true
end

local function computerFinished(computer)

	local screen =
		computer:FindFirstChild("Screen")

	if not screen then
		return false
	end

	-- Actual FTF screen state.
	if screen:IsA("BasePart") then

		if screen.BrickColor ==
			BrickColor.new("Dark green") then

			return true
		end

		if screen.BrickColor ==
			BrickColor.new("Earth green") then

			return true
		end
	end

	-- Some versions expose the state as an attribute.
	for _,name in ipairs({
		"Finished",
		"Completed",
		"Hacked"
	}) do

		if computer:GetAttribute(name) == true then
			return true
		end
	end

	return false
end

local function updateComputer(computer)

	if not Settings.Computers then
		return
	end

	if not computer.Parent then

		Computers[computer] = nil
		removeESP(computer)

		return
	end

	local color

	if computerFinished(computer) then
		color = COLORS.FinishedComputer
	else
		color = COLORS.Computer
	end

	if not ESP[computer] then

		addESP(
			computer,
			color,
			"Computers",
			"Computer"
		)

	else

		updateESP(
			computer,
			color,
			"Computer"
		)
	end
end

--==================================================
-- ACCURATE POD DETECTION
--==================================================

local function isPod(object)

	if not object:IsA("Model") then
		return false
	end

	if object.Name ~= "FreezePod" then
		return false
	end

	return true
end

local function podOccupied(pod)

	-- Check actual character/player descendants first.
	for _,player in ipairs(Players:GetPlayers()) do

		local character =
			player.Character

		if character
		and character.Parent
		and character:IsDescendantOf(pod) then

			return true
		end
	end

	-- FTF pod state values/attributes.
	for _,name in ipairs({
		"Occupied",
		"IsOccupied",
		"Captured"
	}) do

		if pod:GetAttribute(name) == true then
			return true
		end
	end

	for _,child in ipairs(
		pod:GetDescendants()
	) do

		if child:IsA("ObjectValue") then

			if child.Value
			and child.Value:IsA("Player") then

				return true
			end

		elseif child:IsA("BoolValue") then

			local n =
				child.Name:lower()

			if (
				n == "occupied"
				or n == "isoccupied"
				or n == "captured"
			)
			and child.Value then

				return true
			end
		end
	end

	return false
end

local function updatePod(pod)

	if not Settings.Pods then
		return
	end

	if not pod.Parent then

		Pods[pod] = nil
		removeESP(pod)

		return
	end

	local color

	if podOccupied(pod) then
		color = COLORS.OccupiedPod
	else
		color = COLORS.Pod
	end

	if not ESP[pod] then

		addESP(
			pod,
			color,
			"Pods",
			"Freeze Pod"
		)

	else

		updateESP(
			pod,
			color,
			"Freeze Pod"
		)
	end
end

--==================================================
-- ACCURATE EXIT DETECTION
--==================================================

local function isExit(object)

	if not object:IsA("Model") then
		return false
	end

	local name =
		object.Name:lower()

	-- Strict names first.
	if name == "exitdoor"
	or name == "exit" then

		return true
	end

	-- FTF maps can use numbered exit doors.
	if name:match("^exitdoor%d*$") then
		return true
	end

	return false
end

local function updateExit(exit)

	if not Settings.Exits then
		return
	end

	if not exit.Parent then

		Exits[exit] = nil
		removeESP(exit)

		return
	end

	if not ESP[exit] then

		addESP(
			exit,
			COLORS.Exit,
			"Exits",
			"Exit"
		)
	end
end

--==================================================
-- INITIAL MAP SCAN
--==================================================

local function scanMap()

	-- This runs only once.
	-- Afterwards objects are cached.

	for _,object in ipairs(
		Workspace:GetDescendants()
	) do

		if isComputer(object) then

			Computers[object] = true

			updateComputer(object)

		elseif isPod(object) then

			Pods[object] = true

			updatePod(object)

		elseif isExit(object) then

			Exits[object] = true

			updateExit(object)
		end
	end
end

--==================================================
-- NEW OBJECTS
--==================================================

Workspace.DescendantAdded:Connect(function(object)

	task.defer(function()

		if not object.Parent then
			return
		end

		if isComputer(object) then

			Computers[object] = true
			updateComputer(object)

		elseif isPod(object) then

			Pods[object] = true
			updatePod(object)

		elseif isExit(object) then

			Exits[object] = true
			updateExit(object)
		end
	end)
end)

Workspace.DescendantRemoving:Connect(function(object)

	Computers[object] = nil
	Pods[object] = nil
	Exits[object] = nil

	removeESP(object)
end)

--==================================================
-- PLAYER EVENTS
--==================================================

Players.PlayerAdded:Connect(function(player)

	player.CharacterAdded:Connect(function()

		task.wait(0.4)

		if Settings.Players then
			updatePlayers()
		end
	end)
end)

Players.PlayerRemoving:Connect(function(player)

	if player.Character then
		removeESP(player.Character)
		originalSizes[player.Character] = nil
	end
end)

--==================================================
-- FPS BOOST
--==================================================

local originalLighting = {}
local originalObjects = {}

local function enableFPSBoost()

	if Settings.FPSBoost then
		return
	end

	Settings.FPSBoost = true

	FPSButton.Text = "FPS Boost: ON"
	FPSButton.BackgroundColor3 =
		Color3.fromRGB(60,120,70)

	originalLighting.GlobalShadows =
		Lighting.GlobalShadows

	originalLighting.FogEnd =
		Lighting.FogEnd

	Lighting.GlobalShadows = false
	Lighting.FogEnd = 100000

	-- One-time optimization pass.
	for _,object in ipairs(
		Workspace:GetDescendants()
	) do

		if object:IsA("ParticleEmitter")
		or object:IsA("Trail")
		or object:IsA("Beam") then

			originalObjects[object] =
				object.Enabled

			object.Enabled = false

		elseif object:IsA("BasePart") then

			if object.Material ==
				Enum.Material.Neon then

				originalObjects[object] =
					object.Material

				object.Material =
					Enum.Material.SmoothPlastic
			end
		end
	end

	for _,effect in ipairs(
		Lighting:GetChildren()
	) do

		if effect:IsA("PostEffect") then

			originalObjects[effect] =
				effect.Enabled

			effect.Enabled = false
		end
	end
end

local function disableFPSBoost()

	if not Settings.FPSBoost then
		return
	end

	Settings.FPSBoost = false

	FPSButton.Text =
		"FPS Boost: OFF"

	FPSButton.BackgroundColor3 =
		Color3.fromRGB(35,35,35)

	if originalLighting.GlobalShadows ~= nil then

		Lighting.GlobalShadows =
			originalLighting.GlobalShadows

		Lighting.FogEnd =
			originalLighting.FogEnd
	end

	for object,value in pairs(
		originalObjects
	) do

		if object
		and object.Parent then

			pcall(function()

				if object:IsA("BasePart") then

					object.Material = value

				elseif object:IsA("ParticleEmitter")
				or object:IsA("Trail")
				or object:IsA("Beam")
				or object:IsA("PostEffect") then

					object.Enabled = value
				end
			end)
		end
	end

	table.clear(originalObjects)
end

FPSButton.MouseButton1Click:Connect(function()

	if Settings.FPSBoost then
		disableFPSBoost()
	else
		enableFPSBoost()
	end
end)

--==================================================
-- TOGGLES
--==================================================

local function connectToggle(
	button,
	text,
	key,
	typeName
)

	button.MouseButton1Click:Connect(function()

		Settings[key] =
			not Settings[key]

		button.Text =
			text .. ": " ..
			(Settings[key] and "ON" or "OFF")

		if not Settings[key] then

			if typeName then
				clearType(typeName)
			end

		else

			if key == "Players" then

				updatePlayers()

			elseif key == "Computers" then

				for computer in pairs(Computers) do
					updateComputer(computer)
				end

			elseif key == "Pods" then

				for pod in pairs(Pods) do
					updatePod(pod)
				end

			elseif key == "Exits" then

				for exit in pairs(Exits) do
					updateExit(exit)
				end
			end
		end
	end)
end

connectToggle(
	PlayerButton,
	"Players",
	"Players",
	"Players"
)

connectToggle(
	ComputerButton,
	"Computers",
	"Computers",
	"Computers"
)

connectToggle(
	PodButton,
	"Freeze Pods",
	"Pods",
	"Pods"
)

connectToggle(
	ExitButton,
	"Exits",
	"Exits",
	"Exits"
)

connectToggle(
	HitboxButton,
	"Hitbox Expander",
	"HitboxExpander",
	nil
)

--==================================================
-- LOW-END UPDATE LOOP
--==================================================

task.spawn(function()

	local playerTimer = 0
	local computerTimer = 0
	local podTimer = 0

	while GUI.Parent do

		local dt =
			RunService.Heartbeat:Wait()

		playerTimer += dt
		computerTimer += dt
		podTimer += dt

		-- Hitbox Expander loop tick
		updateHitboxes()

		-- Player state
		-- 4 checks per second.
		if playerTimer >= 0.25 then

			playerTimer = 0

			updatePlayers()
		end

		-- Computer state
		-- 2 checks per second.
		if computerTimer >= 0.5 then

			computerTimer = 0

			if Settings.Computers then

				for computer in pairs(
					Computers
				) do

					updateComputer(computer)
				end
			end
		end

		-- Pod state
		-- 2 checks per second.
		if podTimer >= 0.5 then

			podTimer = 0

			if Settings.Pods then

				for pod in pairs(
					Pods
				) do

					updatePod(pod)
				end
			end
		end
	end
end)

--==================================================
-- START
--==================================================

task.defer(function()

	scanMap()

	updatePlayers()

end)
