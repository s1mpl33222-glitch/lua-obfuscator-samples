--[[
    ELITE HUB (GREEN EDITION - LUXZ ENGINE)
    - Tema: Verde Neon + Bordas Arredondadas
    - Créditos: by kn_01
    - Logo Asset ID: 16861659345
    - Compatibilidade Total com Animações + Cores de Fogo + Bola RGB + Gramado Lux
--]]

----------------------------
-- SERVICES
----------------------------
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")

----------------------------
-- PLAYER / CHARACTER
----------------------------
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

local function UpdateCharacter(newChar)
	Character = newChar
	Humanoid = newChar:WaitForChild("Humanoid")
	RootPart = newChar:WaitForChild("HumanoidRootPart")
end
LocalPlayer.CharacterAdded:Connect(UpdateCharacter)

----------------------------
-- CONFIG / ESTADO
----------------------------
local AutoFollowBallEnabled = false
local AutoFollowConnection = nil
local CurrentFollowBall = nil
local FollowScanTimer = 0
local FollowStopDistance = 0.5

local ReachEnabled = false
local ReachDistance = 3.5
local BypassEnabled = false

-- Sistema de Cores, RGB e Fogo da Bola
local OriginalBallVisuals = setmetatable({}, {__mode="k"})
local RGBBallEnabled = false
local RGBBallConnection = nil
local CurrentBallColor = nil
local BallFireEnabled = false
local CurrentFireConfig = {
	Color = Color3.fromRGB(255, 80, 0),
	SecondaryColor = Color3.fromRGB(255, 220, 0)
}

-- Sistema de Gramado
local Terrain = Workspace:FindFirstChildOfClass("Terrain")
local OriginalGrassParts = setmetatable({}, {__mode="k"})

----------------------------
-- DETECTOR DE ANIMAÇÕES DO JOGO
----------------------------
local function IsPlayingCustomAnimation()
	if not Humanoid then return false end
	local animator = Humanoid:FindFirstChildOfClass("Animator")
	if not animator then return false end

	for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
		if track.IsPlaying and (track.Priority == Enum.AnimationPriority.Action or track.Priority == Enum.AnimationPriority.Action2 or track.Priority == Enum.AnimationPriority.Action3 or track.Priority == Enum.AnimationPriority.Action4) then
			return true
		end
	end
	return false
end

----------------------------
-- UTILS
----------------------------
local function MakeDraggable(guiObject)
	local dragging, dragInput, dragStart, startPos

	guiObject.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then
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

	guiObject.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement
			or input.UserInputType == Enum.UserInputType.Touch then
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

----------------------------
-- DETECTOR DE BOLA (LUX ENGINE)
----------------------------
local function IsCharacterPart(obj)
	local current = obj
	while current and current ~= Workspace do
		if current:IsA("Model") and current:FindFirstChildOfClass("Humanoid") then
			return true
		end
		current = current.Parent
	end
	return false
end

local function HasBallName(obj)
	if not obj then return false end
	local n = string.lower(obj.Name)
	local names = {"soccerball","football","matchball","gameball","futebol","bola","ball","tps"}
	for _, word in ipairs(names) do
		if string.find(n, word, 1, true) then return true end
	end
	return false
end

local function IsBall(part)
	if not part or not part:IsA("BasePart") or IsCharacterPart(part) then return false end
	if string.lower(part.Name) == "tps" then return true end
	if HasBallName(part) or HasBallName(part.Parent) or (part.Parent and HasBallName(part.Parent.Parent)) then
		return true
	end
	local biggest = math.max(part.Size.X, part.Size.Y, part.Size.Z)
	local smallest = math.min(part.Size.X, part.Size.Y, part.Size.Z)
	if biggest < 0.5 or biggest > 8 then return false end
	if part:IsA("Part") and part.Shape == Enum.PartType.Ball and not part.Anchored then return true end
	if part:IsA("MeshPart") and not part.Anchored and smallest / biggest >= 0.80 then return true end
	return false
end

local function IsValidTPSBall(part)
	if not part or not part.Parent or not part:IsA("BasePart") then return false end
	if string.lower(part.Name) ~= "tps" then return false end
	if IsCharacterPart(part) or part.Anchored then return false end
	local biggest = math.max(part.Size.X, part.Size.Y, part.Size.Z)
	local smallest = math.min(part.Size.X, part.Size.Y, part.Size.Z)
	if biggest < 0.5 or biggest > 6 then return false end
	if smallest / biggest < 0.60 then return false end
	return true
end

local function FindClosestBall()
	if not RootPart then return nil end
	local closest = nil
	local closestDistance = math.huge

	for _, part in ipairs(Workspace:GetDescendants()) do
		if IsValidTPSBall(part) then
			local distance = (Vector3.new(part.Position.X, 0, part.Position.Z) - Vector3.new(RootPart.Position.X, 0, RootPart.Position.Z)).Magnitude
			if distance < closestDistance then
				closestDistance = distance
				closest = part
			end
		end
	end

	if closest then return closest end

	for _, part in ipairs(Workspace:GetDescendants()) do
		if part:IsA("BasePart") and IsBall(part) then
			local distance = (Vector3.new(part.Position.X, 0, part.Position.Z) - Vector3.new(RootPart.Position.X, 0, RootPart.Position.Z)).Magnitude
			if distance < closestDistance then
				closestDistance = distance
				closest = part
			end
		end
	end

	return closest
end

----------------------------
-- BYPASS SAFE
----------------------------
local rawnamecall
rawnamecall = hookmetamethod(game, "__namecall", function(self, ...)
	local method = getnamecallmethod()
	if BypassEnabled and not checkcaller() then
		if self == Humanoid and (method == "MoveTo" or method == "moveTo") then
			return nil
		end
	end
	return rawnamecall(self, ...)
end)

----------------------------
-- CORES DA BOLA, RGB E FOGO
----------------------------
local function SaveBallVisual(obj)
	if OriginalBallVisuals[obj] then return end
	if obj:IsA("BasePart") then
		OriginalBallVisuals[obj] = {T="Part",Color=obj.Color}
	elseif obj:IsA("Decal") or obj:IsA("Texture") then
		OriginalBallVisuals[obj] = {T="Texture",Color=obj.Color3,Transparency=obj.Transparency}
	elseif obj:IsA("SpecialMesh") then
		OriginalBallVisuals[obj] = {T="Mesh",VertexColor=obj.VertexColor}
	end
end

local function ColorBallObject(obj, color)
	SaveBallVisual(obj)
	pcall(function()
		if obj:IsA("BasePart") then
			obj.Color = color
		elseif obj:IsA("Decal") or obj:IsA("Texture") then
			obj.Color3 = color
		elseif obj:IsA("SpecialMesh") then
			obj.VertexColor = Vector3.new(color.R, color.G, color.B)
		end
	end)
end

local function ApplyColorToBall(ball, color)
	if not ball or not ball.Parent or not ball:IsA("BasePart") or not IsBall(ball) then return end
	ColorBallObject(ball, color)
	for _, v in ipairs(ball:GetDescendants()) do
		if v:IsA("Decal") or v:IsA("Texture") or v:IsA("SpecialMesh") then
			ColorBallObject(v, color)
		end
	end
end

local function AddFire(ball)
	if not ball or not ball:IsA("BasePart") or not IsBall(ball) then return end
	local fire = ball:FindFirstChild("EliteHubFireEffect")
	if not fire then
		fire = Instance.new("Fire")
		fire.Name = "EliteHubFireEffect"
		fire.Parent = ball
	end
	fire.Color = CurrentFireConfig.Color
	fire.SecondaryColor = CurrentFireConfig.SecondaryColor
	fire.Size = 6
	fire.Heat = 12
	fire.Enabled = true
end

local function RemoveFireFromAll()
	for _, v in ipairs(Workspace:GetDescendants()) do
		if v.Name == "EliteHubFireEffect" or v.Name == "LuxzFire" then
			pcall(function() v:Destroy() end)
		end
	end
end

local function GetRGBBalls()
	local tps, fallback = {}, {}
	for _, v in ipairs(Workspace:GetDescendants()) do
		if v:IsA("BasePart") and not IsCharacterPart(v) then
			local biggest = math.max(v.Size.X, v.Size.Y, v.Size.Z)
			if biggest <= 8 then
				if string.lower(v.Name) == "tps" then
					table.insert(tps, v)
				elseif IsBall(v) then
					table.insert(fallback, v)
				end
			end
		end
	end
	return #tps > 0 and tps or fallback
end

local function StopRGBBall()
	RGBBallEnabled = false
	if RGBBallConnection then
		RGBBallConnection:Disconnect()
		RGBBallConnection = nil
	end
end

local function StartRGBBall()
	if RGBBallEnabled then return end
	RGBBallEnabled = true
	CurrentBallColor = nil
	local hue, timer = 0, 0
	RGBBallConnection = RunService.RenderStepped:Connect(function(dt)
		if not RGBBallEnabled then return end
		hue = (hue + dt * 0.35) % 1
		timer += dt
		if timer < 0.03 then return end
		timer = 0
		local color = Color3.fromHSV(hue, 1, 1)
		for _, ball in ipairs(GetRGBBalls()) do
			ApplyColorToBall(ball, color)
		end
	end)
end

local function ToggleRGBBall()
	if RGBBallEnabled then StopRGBBall() else StartRGBBall() end
end

local function SetBallColor(color)
	StopRGBBall()
	CurrentBallColor = color
	for _, ball in ipairs(GetRGBBalls()) do
		ApplyColorToBall(ball, color)
	end
end

local function RestoreBallColor()
	StopRGBBall()
	CurrentBallColor = nil
	for obj, data in pairs(OriginalBallVisuals) do
		if obj and obj.Parent then
			pcall(function()
				if data.T == "Part" then
					obj.Color = data.Color
				elseif data.T == "Texture" then
					obj.Color3 = data.Color
					obj.Transparency = data.Transparency
				elseif data.T == "Mesh" then
					obj.VertexColor = data.VertexColor
				end
			end)
		end
	end
	for obj in pairs(OriginalBallVisuals) do OriginalBallVisuals[obj] = nil end
end

----------------------------
-- GRAMADO CONFIG (LUX STYLE)
----------------------------
local function IsGrassPart(part)
	if not part or not part:IsA("BasePart") or IsBall(part) or IsCharacterPart(part) then return false end
	if part.Size.X < 15 or part.Size.Z < 15 or not part.Anchored then return false end
	if part.Material == Enum.Material.Grass then return true end
	local n = string.lower(part.Name)
	for _, word in ipairs({"grass","grama","campo","field","pitch","turf","ground","lawn"}) do
		if string.find(n, word, 1, true) then return true end
	end
	local c = part.Color
	return part.Size.X >= 30 and part.Size.Z >= 30 and c.G > c.R * 1.10 and c.G > c.B * 1.10
end

local function ApplyGrass(color)
	if Terrain then
		pcall(function() Terrain:SetMaterialColor(Enum.Material.Grass, color) end)
	end
	for _, v in ipairs(Workspace:GetDescendants()) do
		if IsGrassPart(v) then
			if OriginalGrassParts[v] == nil then
				OriginalGrassParts[v] = v.Color
			end
			pcall(function() v.Color = color end)
		end
	end
end

----------------------------
-- AUTO FOLLOW INTELIGENTE E FLUIDO
----------------------------
local function StartAutoFollowBall()
	if AutoFollowBallEnabled then return end
	AutoFollowBallEnabled = true
	CurrentFollowBall = nil
	FollowScanTimer = 1
	if AutoFollowConnection then AutoFollowConnection:Disconnect() end

	AutoFollowConnection = RunService.RenderStepped:Connect(function(dt)
		if not AutoFollowBallEnabled then return end
		if not Humanoid or not RootPart or Humanoid.Health <= 0 then return end

		-- Permite que animações nativas executem sem interferência
		if IsPlayingCustomAnimation() then
			return
		end

		Humanoid.AutoRotate = true

		FollowScanTimer += dt
		local currentInvalid = not CurrentFollowBall or not CurrentFollowBall.Parent or (string.lower(CurrentFollowBall.Name) == "tps" and not IsValidTPSBall(CurrentFollowBall))
		local currentTooFar = false

		if CurrentFollowBall and CurrentFollowBall.Parent then
			local currentOffset = Vector3.new(CurrentFollowBall.Position.X - RootPart.Position.X, 0, CurrentFollowBall.Position.Z - RootPart.Position.Z)
			currentTooFar = currentOffset.Magnitude > 250
		end

		if currentInvalid or currentTooFar then
			FollowScanTimer = 0
			CurrentFollowBall = FindClosestBall()
		elseif FollowScanTimer >= 0.25 then
			FollowScanTimer = 0
		end

		local ball = CurrentFollowBall
		if not ball or not ball.Parent then return end

		local toBall = Vector3.new(ball.Position.X - RootPart.Position.X, 0, ball.Position.Z - RootPart.Position.Z)
		local distance = toBall.Magnitude

		if distance > FollowStopDistance then
			Humanoid:Move(toBall.Unit, false)
		else
			Humanoid:Move(Vector3.zero, false)
		end
	end)
end

local function StopAutoFollowBall()
	AutoFollowBallEnabled = false
	CurrentFollowBall = nil
	FollowScanTimer = 0
	if AutoFollowConnection then
		AutoFollowConnection:Disconnect()
		AutoFollowConnection = nil
	end
	if Humanoid then Humanoid:Move(Vector3.zero, false) Humanoid.AutoRotate = true end
end

local function ToggleAutoFollowBall()
	if AutoFollowBallEnabled then StopAutoFollowBall() else StartAutoFollowBall() end
end

----------------------------
-- REACH & LOOP GLOBAL DE EFEITOS
----------------------------
local function DoReach(ball)
	if not ReachEnabled or not ball then return end
	local distance = (ball.Position - RootPart.Position).Magnitude
	local reachStuds = ReachDistance * 4.2
	if distance <= reachStuds then
		firetouchinterest(RootPart, ball, 0)
		firetouchinterest(RootPart, ball, 1)
		local leftFoot = Character:FindFirstChild("Left Foot") or Character:FindFirstChild("Left Leg")
		local rightFoot = Character:FindFirstChild("Right Foot") or Character:FindFirstChild("Right Leg")
		if leftFoot then firetouchinterest(leftFoot, ball, 0) firetouchinterest(leftFoot, ball, 1) end
		if rightFoot then firetouchinterest(rightFoot, ball, 0) firetouchinterest(rightFoot, ball, 1) end
	end
end

RunService.PreRender:Connect(function()
	if not RootPart or not RootPart.Parent or not Humanoid then return end
	local ball = FindClosestBall()
	DoReach(ball)
	if ball then
		if CurrentBallColor and not RGBBallEnabled then
			ApplyColorToBall(ball, CurrentBallColor)
		end
		if BallFireEnabled then
			AddFire(ball)
		end
	end
end)

----------------------------
-- UI (ELITE HUB - VERDE NEON COM LOGO ATUALIZADA)
----------------------------
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "EliteHubGui"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local COLOR_BG = Color3.fromRGB(12, 22, 14)
local COLOR_ACCENT = Color3.fromRGB(35, 255, 90)
local COLOR_TEXT = Color3.fromRGB(255, 255, 255)
local COLOR_SUBTEXT = Color3.fromRGB(180, 255, 200)
local COLOR_CARD = Color3.fromRGB(20, 45, 26)

-- Botão Flutuante (FOLLOW)
local FloatButton = Instance.new("TextButton")
local FloatCorner = Instance.new("UICorner")
local FloatStroke = Instance.new("UIStroke")

FloatButton.Name = "AutoBallFloatBtn"
FloatButton.Parent = ScreenGui
FloatButton.BackgroundColor3 = COLOR_BG
FloatButton.Position = UDim2.new(0.82, 0, 0.2, 0)
FloatButton.Size = UDim2.new(0, 130, 0, 42)
FloatButton.Font = Enum.Font.GothamBold
FloatButton.Text = "FOLLOW: OFF [G]"
FloatButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FloatButton.TextSize = 12

FloatCorner.CornerRadius = UDim.new(0, 12)
FloatCorner.Parent = FloatButton

FloatStroke.Color = COLOR_ACCENT
FloatStroke.Thickness = 2
FloatStroke.Parent = FloatButton

MakeDraggable(FloatButton)

local function UpdateFloatButtonText()
	if AutoFollowBallEnabled then
		FloatButton.Text = "FOLLOW: ON [G]"
		FloatButton.TextColor3 = COLOR_ACCENT
		FloatStroke.Color = COLOR_ACCENT
	else
		FloatButton.Text = "FOLLOW: OFF [G]"
		FloatButton.TextColor3 = Color3.fromRGB(255, 255, 255)
		FloatStroke.Color = Color3.fromRGB(180, 180, 180)
	end
end

FloatButton.MouseButton1Click:Connect(function()
	ToggleAutoFollowBall()
	UpdateFloatButtonText()
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if not gameProcessed and input.KeyCode == Enum.KeyCode.G then
		ToggleAutoFollowBall()
		UpdateFloatButtonText()
	end
end)

-- Janela Principal
local MainFrame = Instance.new("Frame")
local MainCorner = Instance.new("UICorner")
local MainStroke = Instance.new("UIStroke")
local TitleBar = Instance.new("TextLabel")
local AuthorLabel = Instance.new("TextLabel")
local HeaderLogo = Instance.new("ImageLabel")

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = COLOR_BG
MainFrame.Position = UDim2.new(0.3, 0, 0.25, 0)
MainFrame.Size = UDim2.new(0, 420, 0, 290)
MainFrame.ClipsDescendants = true
MainFrame.Visible = false

MainCorner.CornerRadius = UDim.new(0, 16)
MainCorner.Parent = MainFrame

MainStroke.Color = COLOR_ACCENT
MainStroke.Thickness = 2
MainStroke.Parent = MainFrame

-- LOGO DO ROBLOX COM O TEU NOVO ID: 16861659345
HeaderLogo.Name = "HeaderLogo"
HeaderLogo.Parent = MainFrame
HeaderLogo.BackgroundTransparency = 1
HeaderLogo.Position = UDim2.new(0, 10, 0, 8)
HeaderLogo.Size = UDim2.new(0, 32, 0, 32)
HeaderLogo.Image = "rbxassetid://16861659345"
HeaderLogo.ScaleType = Enum.ScaleType.Fit

TitleBar.Name = "TitleBar"
TitleBar.Parent = MainFrame
TitleBar.BackgroundTransparency = 1
TitleBar.Position = UDim2.new(0, 48, 0, 6)
TitleBar.Size = UDim2.new(1, -60, 0, 20)
TitleBar.Font = Enum.Font.GothamBold
TitleBar.Text = "ELITE HUB"
TitleBar.TextColor3 = COLOR_ACCENT
TitleBar.TextSize = 16
TitleBar.TextXAlignment = Enum.TextXAlignment.Left

AuthorLabel.Parent = MainFrame
AuthorLabel.BackgroundTransparency = 1
AuthorLabel.Position = UDim2.new(0, 48, 0, 26)
AuthorLabel.Size = UDim2.new(1, -60, 0, 14)
AuthorLabel.Font = Enum.Font.Gotham
AuthorLabel.Text = "by kn_01"
AuthorLabel.TextColor3 = COLOR_SUBTEXT
AuthorLabel.TextSize = 11
AuthorLabel.TextXAlignment = Enum.TextXAlignment.Left

MakeDraggable(MainFrame)

local Sidebar = Instance.new("ScrollingFrame")
Sidebar.Parent = MainFrame
Sidebar.BackgroundTransparency = 1
Sidebar.Position = UDim2.new(0, 10, 0, 50)
Sidebar.Size = UDim2.new(0, 105, 1, -60)
Sidebar.ScrollBarThickness = 2
Sidebar.ScrollBarImageColor3 = COLOR_ACCENT

local Container = Instance.new("Frame")
Container.Parent = MainFrame
Container.BackgroundTransparency = 1
Container.Position = UDim2.new(0, 122, 0, 50)
Container.Size = UDim2.new(1, -132, 1, -60)

local Pages = {}

local function CreateTabButton(name, posOrder)
	local btn = Instance.new("TextButton")
	btn.Parent = Sidebar
	btn.BackgroundColor3 = COLOR_CARD
	btn.Position = UDim2.new(0, 0, 0, (posOrder - 1) * 32)
	btn.Size = UDim2.new(1, -5, 0, 26)
	btn.Font = Enum.Font.GothamMedium
	btn.Text = name
	btn.TextColor3 = COLOR_TEXT
	btn.TextSize = 10

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = btn
	return btn
end

local function CreatePage(name)
	local page = Instance.new("ScrollingFrame")
	page.Name = name
	page.Parent = Container
	page.Size = UDim2.new(1, 0, 1, 0)
	page.BackgroundTransparency = 1
	page.Visible = false
	page.ScrollBarThickness = 2
	page.ScrollBarImageColor3 = COLOR_ACCENT
	Pages[name] = page
	return page
end

local function ShowPage(pageName)
	for name, page in pairs(Pages) do
		page.Visible = (name == pageName)
	end
end

local tabsList = {"Auto Follow", "Reach", "Bola & Fogo", "Gramado", "Anti Lag & FPS", "Bypass"}
for order, tabName in ipairs(tabsList) do
	local btn = CreateTabButton(tabName, order)
	CreatePage(tabName)
	btn.MouseButton1Click:Connect(function() ShowPage(tabName) end)
end

Pages["Auto Follow"].Visible = true

local function AddOptionButton(page, text, callback, yOffset)
	local btn = Instance.new("TextButton")
	btn.Parent = page
	btn.BackgroundColor3 = COLOR_CARD
	btn.Position = UDim2.new(0, 0, 0, yOffset)
	btn.Size = UDim2.new(1, -5, 0, 28)
	btn.Font = Enum.Font.GothamBold
	btn.Text = text
	btn.TextColor3 = COLOR_TEXT
	btn.TextSize = 11

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = btn

	local stroke = Instance.new("UIStroke")
	stroke.Color = COLOR_ACCENT
	stroke.Thickness = 1
	stroke.Parent = btn

	btn.MouseButton1Click:Connect(function()
		callback(btn, stroke)
	end)
	return btn
end

----------------------------
-- OPÇÕES DO MENU
----------------------------
AddOptionButton(Pages["Auto Follow"], "Botão Flutuante: VISÍVEL", function(btn)
	FloatButton.Visible = not FloatButton.Visible
	btn.Text = FloatButton.Visible and "Botão Flutuante: VISÍVEL" or "Botão Flutuante: OCULTO"
end, 0)

local ReachBtn = AddOptionButton(Pages["Reach"], "Status do Reach: OFF", function(btn)
	ReachEnabled = not ReachEnabled
	if ReachEnabled then
		btn.Text = "Status do Reach: ON (" .. ReachDistance .. "m)"
		btn.TextColor3 = COLOR_ACCENT
	else
		btn.Text = "Status do Reach: OFF"
		btn.TextColor3 = COLOR_TEXT
	end
end, 0)

AddOptionButton(Pages["Reach"], "Alcance: 3.5 Metros", function() ReachDistance = 3.5 if ReachEnabled then ReachBtn.Text = "Status do Reach: ON (3.5m)" end end, 34)
AddOptionButton(Pages["Reach"], "Alcance: 5.0 Metros", function() ReachDistance = 5.0 if ReachEnabled then ReachBtn.Text = "Status do Reach: ON (5.0m)" end end, 68)
AddOptionButton(Pages["Reach"], "Alcance: 7.5 Metros (Max)", function() ReachDistance = 7.5 if ReachEnabled then ReachBtn.Text = "Status do Reach: ON (7.5m)" end end, 102)

-- Bola RGB & Cores
AddOptionButton(Pages["Bola & Fogo"], "⚽ Bola RGB: OFF", function(btn)
	ToggleRGBBall()
	btn.Text = "⚽ Bola RGB: " .. (RGBBallEnabled and "ON" or "OFF")
end, 0)

AddOptionButton(Pages["Bola & Fogo"], "Cor Bola: Verde Neon", function() SetBallColor(Color3.fromRGB(30, 255, 80)) end, 34)
AddOptionButton(Pages["Bola & Fogo"], "Cor Bola: Azul Cyan", function() SetBallColor(Color3.fromRGB(0, 230, 255)) end, 68)
AddOptionButton(Pages["Bola & Fogo"], "Cor Bola: Vermelho Neon", function() SetBallColor(Color3.fromRGB(255, 30, 30)) end, 102)
AddOptionButton(Pages["Bola & Fogo"], "Cor Bola: Roxo Neon", function() SetBallColor(Color3.fromRGB(180, 0, 255)) end, 136)
AddOptionButton(Pages["Bola & Fogo"], "Cor Bola: Laranja Fogo", function() SetBallColor(Color3.fromRGB(255, 120, 0)) end, 170)
AddOptionButton(Pages["Bola & Fogo"], "Cor Bola: Branco", function() SetBallColor(Color3.fromRGB(255, 255, 255)) end, 204)
AddOptionButton(Pages["Bola & Fogo"], "Restaurar Bola Original", function() RestoreBallColor() end, 238)

-- Configurações de Fogo
AddOptionButton(Pages["Bola & Fogo"], "🔥 Fogo: Alternar", function(btn)
	BallFireEnabled = not BallFireEnabled
	if not BallFireEnabled then RemoveFireFromAll() end
	btn.Text = "🔥 Fogo: " .. (BallFireEnabled and "ON" or "OFF")
end, 272)

AddOptionButton(Pages["Bola & Fogo"], "Fogo: Laranja / Amarelo", function()
	CurrentFireConfig = { Color = Color3.fromRGB(255, 80, 0), SecondaryColor = Color3.fromRGB(255, 220, 0) }
end, 306)

AddOptionButton(Pages["Bola & Fogo"], "Fogo: Verde Neon", function()
	CurrentFireConfig = { Color = Color3.fromRGB(0, 255, 80), SecondaryColor = Color3.fromRGB(150, 255, 0) }
end, 340)

AddOptionButton(Pages["Bola & Fogo"], "Fogo: Azul Cyber", function()
	CurrentFireConfig = { Color = Color3.fromRGB(0, 200, 255), SecondaryColor = Color3.fromRGB(0, 50, 255) }
end, 374)

AddOptionButton(Pages["Bola & Fogo"], "Fogo: Roxo / Pink", function()
	CurrentFireConfig = { Color = Color3.fromRGB(200, 0, 255), SecondaryColor = Color3.fromRGB(255, 0, 150) }
end, 408)

-- Gramado Lux Style
AddOptionButton(Pages["Gramado"], "Gramado: Azul Lux", function() ApplyGrass(Color3.fromRGB(20,90,255)) end, 0)
AddOptionButton(Pages["Gramado"], "Gramado: Roxo Lux", function() ApplyGrass(Color3.fromRGB(120,40,200)) end, 34)
AddOptionButton(Pages["Gramado"], "Gramado: Vermelho Lux", function() ApplyGrass(Color3.fromRGB(210,35,35)) end, 68)
AddOptionButton(Pages["Gramado"], "Gramado: Verde Neon", function() ApplyGrass(Color3.fromRGB(0,255,70)) end, 102)
AddOptionButton(Pages["Gramado"], "Gramado: Preto Lux", function() ApplyGrass(Color3.fromRGB(20,20,20)) end, 136)

AddOptionButton(Pages["Anti Lag & FPS"], "Ativar Anti-Lag", function(btn)
	Lighting.GlobalShadows = false
	Lighting.FogEnd = 9e9
	for _, obj in ipairs(Workspace:GetDescendants()) do
		if obj:IsA("BasePart") then obj.Material = Enum.Material.SmoothPlastic
		elseif obj:IsA("Decal") or obj:IsA("Texture") then obj:Destroy() end
	end
	btn.Text = "Anti-Lag: ATIVADO"
end, 0)

AddOptionButton(Pages["Bypass"], "Bypass Namecall: OFF", function(btn)
	BypassEnabled = not BypassEnabled
	btn.Text = BypassEnabled and "Bypass Namecall: ON" or "Bypass Namecall: OFF"
	btn.TextColor3 = BypassEnabled and COLOR_ACCENT or Color3.fromRGB(255, 255, 255)
end, 0)

-- Botão Flutuante Principal do Menu
local OpenHubBtn = Instance.new("TextButton")
local OpenCorner = Instance.new("UICorner")
local OpenStroke = Instance.new("UIStroke")

OpenHubBtn.Name = "OpenHubBtn"
OpenHubBtn.Parent = ScreenGui
OpenHubBtn.BackgroundColor3 = COLOR_BG
OpenHubBtn.Position = UDim2.new(0, 20, 0.5, -27)
OpenHubBtn.Size = UDim2.new(0, 55, 0, 55)
OpenHubBtn.Font = Enum.Font.GothamBold
OpenHubBtn.Text = "ELITE"
OpenHubBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenHubBtn.TextSize = 12

OpenCorner.CornerRadius = UDim.new(1, 0)
OpenCorner.Parent = OpenHubBtn

OpenStroke.Color = COLOR_ACCENT
OpenStroke.Thickness = 2.5
OpenStroke.Parent = OpenHubBtn

MakeDraggable(OpenHubBtn)

OpenHubBtn.MouseButton1Click:Connect(function()
	MainFrame.Visible = not MainFrame.Visible
end)
