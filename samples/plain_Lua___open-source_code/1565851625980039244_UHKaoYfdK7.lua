local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local LP = Players.LocalPlayer
local PlayerGui = LP:WaitForChild("PlayerGui")

local AntiDie = false
local Spinning = false
local Minimized = false
local SpinSpeed = 360
local MIN_SPEED = 1
local MAX_SPEED = 10000000000
local SpinKeybind = Enum.KeyCode.RightShift
local ListeningForKey = false
local AutoOnCarry = true          

local C_BG      = Color3.fromRGB(8, 8, 16)
local C_PANEL   = Color3.fromRGB(14, 14, 28)
local C_STROKE  = Color3.fromRGB(0, 240, 255)
local C_STROKE2 = Color3.fromRGB(80, 40, 180)
local C_TEXT    = Color3.fromRGB(220, 240, 255)
local C_TEXTDIM = Color3.fromRGB(140, 160, 200)
local C_NEON    = Color3.fromRGB(0, 255, 220)
local C_PURPLE  = Color3.fromRGB(160, 60, 255)
local C_ON      = Color3.fromRGB(0, 255, 180)
local C_OFF     = Color3.fromRGB(30, 30, 55)
local C_GREEN   = Color3.fromRGB(0, 255, 140)
local C_RED     = Color3.fromRGB(255, 50, 80)

local Gui = Instance.new("ScreenGui")
Gui.Name = "ConfuserV6"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.Parent = PlayerGui

local Main = Instance.new("Frame")
Main.Size = UDim2.fromOffset(250, 310)
Main.Position = UDim2.new(0.5, -125, 0.5, -155)
Main.BackgroundColor3 = C_BG
Main.BorderSizePixel = 0
Main.Parent = Gui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 14)
MainCorner.Parent = Main

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = C_STROKE
MainStroke.Thickness = 2
MainStroke.Transparency = 0.15
MainStroke.Parent = Main

local Glow = Instance.new("UIStroke")
Glow.Color = C_NEON
Glow.Thickness = 4
Glow.Transparency = 0.7
Glow.Parent = Main

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 60)
Header.BackgroundTransparency = 1
Header.ZIndex = 2
Header.Parent = Main

local Dot = Instance.new("Frame")
Dot.Size = UDim2.fromOffset(9, 9)
Dot.Position = UDim2.fromOffset(14, 16)
Dot.BackgroundColor3 = C_RED
Dot.BorderSizePixel = 0
Dot.ZIndex = 3
Dot.Parent = Header

local DotCorner = Instance.new("UICorner")
DotCorner.CornerRadius = UDim.new(1, 0)
DotCorner.Parent = Dot

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -70, 0, 22)
Title.Position = UDim2.fromOffset(32, 8)
Title.BackgroundTransparency = 1
Title.Text = "⚡ Confuser V6"
Title.TextColor3 = C_NEON
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.ZIndex = 3
Title.Parent = Header

local Subtitle = Instance.new("TextLabel")
Subtitle.Size = UDim2.new(1, -70, 0, 14)
Subtitle.Position = UDim2.fromOffset(32, 30)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "neon • spin • anti die"
Subtitle.TextColor3 = C_TEXTDIM
Subtitle.Font = Enum.Font.GothamMedium
Subtitle.TextSize = 10
Subtitle.TextXAlignment = Enum.TextXAlignment.Left
Subtitle.ZIndex = 3
Subtitle.Parent = Header

local Minimize = Instance.new("TextButton")
Minimize.Size = UDim2.fromOffset(28, 28)
Minimize.Position = UDim2.new(1, -38, 0, 12)
Minimize.BackgroundColor3 = C_PANEL
Minimize.BorderSizePixel = 0
Minimize.Text = "−"
Minimize.TextColor3 = C_TEXT
Minimize.TextSize = 16
Minimize.Font = Enum.Font.GothamBold
Minimize.AutoButtonColor = false
Minimize.ZIndex = 3
Minimize.Parent = Header

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 8)
MinCorner.Parent = Minimize

local MinStroke = Instance.new("UIStroke")
MinStroke.Color = C_STROKE2
MinStroke.Thickness = 1.2
MinStroke.Parent = Minimize

local function CreateToggle(Name, Y)
	local Box = Instance.new("Frame")
	Box.Name = Name
	Box.Size = UDim2.new(1, -20, 0, 40)
	Box.Position = UDim2.fromOffset(10, Y)
	Box.BackgroundColor3 = C_PANEL
	Box.BorderSizePixel = 0
	Box.ZIndex = 2
	Box.Parent = Main

	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0, 10)
	Corner.Parent = Box

	local Stroke = Instance.new("UIStroke")
	Stroke.Color = C_STROKE2
	Stroke.Thickness = 1.2
	Stroke.Parent = Box

	local Label = Instance.new("TextLabel")
	Label.Size = UDim2.new(1, -75, 1, 0)
	Label.Position = UDim2.fromOffset(14, 0)
	Label.BackgroundTransparency = 1
	Label.Text = Name
	Label.TextColor3 = C_TEXT
	Label.Font = Enum.Font.GothamMedium
	Label.TextSize = 13
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.ZIndex = 3
	Label.Parent = Box

	local Button = Instance.new("TextButton")
	Button.Size = UDim2.fromOffset(44, 24)
	Button.Position = UDim2.new(1, -56, 0.5, -12)
	Button.BackgroundColor3 = C_OFF
	Button.BorderSizePixel = 0
	Button.Text = ""
	Button.AutoButtonColor = false
	Button.ZIndex = 3
	Button.Parent = Box

	local ButtonCorner = Instance.new("UICorner")
	ButtonCorner.CornerRadius = UDim.new(1, 0)
	ButtonCorner.Parent = Button

	local Circle = Instance.new("Frame")
	Circle.Size = UDim2.fromOffset(18, 18)
	Circle.Position = UDim2.fromOffset(3, 3)
	Circle.BackgroundColor3 = Color3.fromRGB(240, 240, 255)
	Circle.BorderSizePixel = 0
	Circle.ZIndex = 4
	Circle.Parent = Button

	local CircleCorner = Instance.new("UICorner")
	CircleCorner.CornerRadius = UDim.new(1, 0)
	CircleCorner.Parent = Circle

	return Box, Button, Circle
end

local AntiDieBox, AntiDieButton, AntiDieCircle = CreateToggle("Anti Die", 70)
local SpinBox, SpinButton, SpinCircle = CreateToggle("Spin", 118)
local AutoBox, AutoButton, AutoCircle = CreateToggle("Auto on Carry", 166)

local KeybindButton = Instance.new("TextButton")
KeybindButton.Name = "KeybindButton"
KeybindButton.Size = UDim2.fromOffset(80, 30)
KeybindButton.Position = UDim2.fromOffset(10, 218)
KeybindButton.BackgroundColor3 = C_PANEL
KeybindButton.BorderSizePixel = 0
KeybindButton.Text = SpinKeybind.Name
KeybindButton.TextColor3 = C_TEXT
KeybindButton.Font = Enum.Font.GothamMedium
KeybindButton.TextSize = 11
KeybindButton.AutoButtonColor = false
KeybindButton.ZIndex = 3
KeybindButton.Parent = Main

local KeybindCorner = Instance.new("UICorner")
KeybindCorner.CornerRadius = UDim.new(0, 9)
KeybindCorner.Parent = KeybindButton

local KeyStroke = Instance.new("UIStroke")
KeyStroke.Color = C_STROKE2
KeyStroke.Thickness = 1.2
KeyStroke.Parent = KeybindButton

local SpeedBox = Instance.new("TextBox")
SpeedBox.Name = "SpeedBox"
SpeedBox.Size = UDim2.fromOffset(140, 30)
SpeedBox.Position = UDim2.fromOffset(100, 218)
SpeedBox.BackgroundColor3 = C_PANEL
SpeedBox.BorderSizePixel = 0
SpeedBox.Text = tostring(SpinSpeed)
SpeedBox.PlaceholderText = "Speed 1 - 10B"
SpeedBox.TextColor3 = C_TEXT
SpeedBox.PlaceholderColor3 = C_TEXTDIM
SpeedBox.Font = Enum.Font.GothamMedium
SpeedBox.TextSize = 12
SpeedBox.ClearTextOnFocus = false
SpeedBox.ZIndex = 3
SpeedBox.Parent = Main

local SpeedCorner = Instance.new("UICorner")
SpeedCorner.CornerRadius = UDim.new(0, 9)
SpeedCorner.Parent = SpeedBox

local SpeedStroke = Instance.new("UIStroke")
SpeedStroke.Color = C_STROKE2
SpeedStroke.Thickness = 1.2
SpeedStroke.Parent = SpeedBox

local Footer = Instance.new("TextLabel")
Footer.Size = UDim2.new(1, -20, 0, 26)
Footer.Position = UDim2.new(0, 10, 1, -36)
Footer.BackgroundColor3 = Color3.fromRGB(20, 10, 40)
Footer.BorderSizePixel = 0
Footer.Text = "⚡ Confuser V6 • Neon"
Footer.TextColor3 = C_NEON
Footer.Font = Enum.Font.GothamBold
Footer.TextSize = 12
Footer.ZIndex = 2
Footer.Parent = Main

local FooterCorner = Instance.new("UICorner")
FooterCorner.CornerRadius = UDim.new(0, 8)
FooterCorner.Parent = Footer

local FooterStroke = Instance.new("UIStroke")
FooterStroke.Color = C_PURPLE
FooterStroke.Thickness = 1.2
FooterStroke.Parent = Footer

local ToggleInfo = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

local function SetToggle(Button, Circle, Enabled)
	if Enabled then
		TweenService:Create(Button, ToggleInfo, {BackgroundColor3 = C_ON}):Play()
		TweenService:Create(Circle, ToggleInfo, {Position = UDim2.new(1, -21, 0, 3)}):Play()
	else
		TweenService:Create(Button, ToggleInfo, {BackgroundColor3 = C_OFF}):Play()
		TweenService:Create(Circle, ToggleInfo, {Position = UDim2.fromOffset(3, 3)}):Play()
	end
end

local function UpdateDot()
	local Color = Spinning and C_GREEN or C_RED
	TweenService:Create(Dot, TweenInfo.new(0.15), {BackgroundColor3 = Color}):Play()
end

local Highlight

local function UpdateHighlight()
	if Highlight then
		Highlight:Destroy()
		Highlight = nil
	end
	if not (AntiDie or Spinning) then return end
	local Character = LP.Character
	if not Character then return end
	Highlight = Instance.new("Highlight")
	Highlight.Name = "ConfuserOutline"
	Highlight.Adornee = Character
	Highlight.FillTransparency = 1
	Highlight.OutlineTransparency = 0
	Highlight.OutlineColor = C_NEON
	Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	Highlight.Parent = Character
end

local ProtectionConns = {}

local function CleanupProtection()
	for _, connection in pairs(ProtectionConns) do
		connection:Disconnect()
	end
	table.clear(ProtectionConns)
end

local function IsProtectionActive()
	return AntiDie or Spinning
end

local function SetupProtection(Character)
	if not IsProtectionActive() then return end
	if not Character or not Character.Parent then return end

	local hum = Character:FindFirstChildOfClass("Humanoid")
	if not hum then
		hum = Character:WaitForChild("Humanoid", 10)
	end
	if not hum or not hum.Parent then return end

	CleanupProtection()

	hum.BreakJointsOnDeath = false
	hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)

	table.insert(ProtectionConns, hum:GetPropertyChangedSignal("Health"):Connect(function()
		if IsProtectionActive() and hum.Parent and hum.Health <= 0 then
			hum.Health = hum.MaxHealth
		end
	end))

	table.insert(ProtectionConns, hum.Died:Connect(function()
		if not IsProtectionActive() then return end
		task.defer(function()
			if hum and hum.Parent and hum.Health <= 0 then
				hum.Health = hum.MaxHealth
			end
		end)
	end))
end

local function DisableProtection()
	CleanupProtection()
	local Character = LP.Character
	if not Character then return end
	local hum = Character:FindFirstChildOfClass("Humanoid")
	if hum then
		hum.BreakJointsOnDeath = true
		hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
	end
end

local function UpdateProtection()
	if IsProtectionActive() then
		SetupProtection(LP.Character)
	else
		DisableProtection()
	end
	UpdateHighlight()
end

local SpinConnection = nil

local function GetHumanoid()
	local Character = LP.Character
	if not Character then return nil end
	return Character:FindFirstChildOfClass("Humanoid")
end

local function StartSpinRotation()
	if SpinConnection then return end

	local hum = GetHumanoid()
	if hum then
		hum.AutoRotate = false
	end

	SpinConnection = RunService.Stepped:Connect(function(_, dt)
		if not Spinning then return end

		local Character = LP.Character
		if not Character then return end
		local Root = Character:FindFirstChild("HumanoidRootPart")
		local Humanoid = Character:FindFirstChildOfClass("Humanoid")
		if not Root then return end

		if Humanoid and Humanoid.AutoRotate then
			Humanoid.AutoRotate = false
		end

		local Degrees = (SpinSpeed * dt) % 360
		Root.CFrame = Root.CFrame * CFrame.Angles(0, math.rad(Degrees), 0)
	end, Enum.RenderPriority.Character.Value + 1)
end

local function StopSpinRotation()
	if SpinConnection then
		SpinConnection:Disconnect()
		SpinConnection = nil
	end
	local hum = GetHumanoid()
	if hum then
		hum.AutoRotate = true
	end
end

local function SetSpinning(state)
	Spinning = state
	if Spinning then
		StartSpinRotation()
	else
		StopSpinRotation()
	end
	SetToggle(SpinButton, SpinCircle, Spinning)
	UpdateProtection()
	UpdateDot()
end

local function ApplySpeed(text)
	local n = tonumber(text)
	if not n or n ~= n then n = SpinSpeed end
	if n == math.huge then n = MAX_SPEED end
	if n == -math.huge then n = MIN_SPEED end
	n = math.floor(n)
	n = math.clamp(n, MIN_SPEED, MAX_SPEED)
	SpinSpeed = n
	SpeedBox.Text = tostring(n)
end

SpeedBox:GetPropertyChangedSignal("Text"):Connect(function()
	local digitsOnly = SpeedBox.Text:gsub("%D", "")
	if digitsOnly ~= SpeedBox.Text then
		SpeedBox.Text = digitsOnly
	end
end)

SpeedBox.FocusLost:Connect(function()
	ApplySpeed(SpeedBox.Text)
end)

ApplySpeed(tostring(SpinSpeed))

AntiDieButton.MouseButton1Click:Connect(function()
	AntiDie = not AntiDie
	SetToggle(AntiDieButton, AntiDieCircle, AntiDie)
	UpdateProtection()
end)

SpinButton.MouseButton1Click:Connect(function()
	SetSpinning(not Spinning)
end)

AutoButton.MouseButton1Click:Connect(function()
	AutoOnCarry = not AutoOnCarry
	SetToggle(AutoButton, AutoCircle, AutoOnCarry)
end)

local function ResetKeybindVisual()
	ListeningForKey = false
	KeybindButton.Text = SpinKeybind.Name
	KeybindButton.TextColor3 = C_TEXT
	KeyStroke.Color = C_STROKE2
end

local function SetKeybind(k)
	SpinKeybind = k
	ResetKeybindVisual()
end

KeybindButton.MouseButton1Click:Connect(function()
	if ListeningForKey then
		ResetKeybindVisual()
	else
		ListeningForKey = true
		KeybindButton.Text = "Press..."
		KeybindButton.TextColor3 = C_NEON
		KeyStroke.Color = C_NEON
	end
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if ListeningForKey then
		local ut = input.UserInputType
		if ut == Enum.UserInputType.Keyboard then
			if input.KeyCode == Enum.KeyCode.Escape then
				ResetKeybindVisual()
			else
				SetKeybind(input.KeyCode)
			end
		elseif ut.Name:match("^Gamepad") then
			SetKeybind(input.KeyCode)
		end
		return
	end

	if UserInputService:GetFocusedTextBox() then return end

	if input.KeyCode == SpinKeybind and input.KeyCode ~= Enum.KeyCode.Unknown then
		SetSpinning(not Spinning)
	end
end)

local wasCarrying = false

local function isCarrying()
	local char = LP.Character
	if not char then return false end

	for _, child in pairs(char:GetChildren()) do
		local name = child.Name:lower()
		if name:find("brainrot") or name:find("brain") or name:find("animal") or
		   name:find("carry") or name:find("stolen") or name:find("held") or name:find("steal") then
			return true
		end
	end

	for attrName, attrValue in pairs(char:GetAttributes()) do
		local name = attrName:lower()
		if (name:find("carrying") or name:find("carry") or name:find("stealing") or
			name:find("isstealing") or name:find("hasbrainrot")) and attrValue == true then
			return true
		end
	end

	local humanoid = char:FindFirstChildOfClass("Humanoid")
	if humanoid and humanoid.WalkSpeed > 0 and humanoid.WalkSpeed <= 25 and humanoid.WalkSpeed ~= 16 then
		return true
	end

	return false
end

task.spawn(function()
	while Gui.Parent do
		task.wait(0.12)
		if not AutoOnCarry then
			wasCarrying = false
			continue
		end

		local currentlyCarrying = isCarrying()

		if currentlyCarrying and not wasCarrying then
			if not Spinning then
				SetSpinning(true)
			end
			if not AntiDie then
				AntiDie = true
				SetToggle(AntiDieButton, AntiDieCircle, true)
				UpdateProtection()
			end
		elseif not currentlyCarrying and wasCarrying then
			if Spinning then
				SetSpinning(false)
			end
			if AntiDie then
				AntiDie = false
				SetToggle(AntiDieButton, AntiDieCircle, false)
				UpdateProtection()
			end
		end

		wasCarrying = currentlyCarrying
	end
end)

local function SetupCharacter(Character)
	local Humanoid = Character:WaitForChild("Humanoid", 10)
	if not Humanoid then return end

	task.wait(0.1)

	if Spinning then
		Humanoid.AutoRotate = false
	end

	if IsProtectionActive() then
		SetupProtection(Character)
		UpdateHighlight()
	end
end

LP.CharacterAdded:Connect(SetupCharacter)

if LP.Character then
	SetupCharacter(LP.Character)
end

LP.CharacterRemoving:Connect(function()
	CleanupProtection()
	wasCarrying = false
end)

Minimize.MouseButton1Click:Connect(function()
	Minimized = not Minimized
	if Minimized then
		AntiDieBox.Visible = false
		SpinBox.Visible = false
		AutoBox.Visible = false
		KeybindButton.Visible = false
		SpeedBox.Visible = false
		Footer.Visible = false
		Main.Size = UDim2.fromOffset(250, 56)
		Minimize.Text = "+"
	else
		AntiDieBox.Visible = true
		SpinBox.Visible = true
		AutoBox.Visible = true
		KeybindButton.Visible = true
		SpeedBox.Visible = true
		Footer.Visible = true
		Main.Size = UDim2.fromOffset(250, 310)
		Minimize.Text = "−"
	end
end)

local Dragging = false
local DragStart
local StartPosition

Header.InputBegan:Connect(function(Input)
	if Input.UserInputType == Enum.UserInputType.Touch
		or Input.UserInputType == Enum.UserInputType.MouseButton1 then
		Dragging = true
		DragStart = Input.Position
		StartPosition = Main.Position
	end
end)

UserInputService.InputChanged:Connect(function(Input)
	if not Dragging then return end
	if Input.UserInputType == Enum.UserInputType.Touch
		or Input.UserInputType == Enum.UserInputType.MouseMovement then
		local Delta = Input.Position - DragStart
		Main.Position = UDim2.new(
			StartPosition.X.Scale,
			StartPosition.X.Offset + Delta.X,
			StartPosition.Y.Scale,
			StartPosition.Y.Offset + Delta.Y
		)
	end
end)

UserInputService.InputEnded:Connect(function(Input)
	if Input.UserInputType == Enum.UserInputType.Touch
		or Input.UserInputType == Enum.UserInputType.MouseButton1 then
		Dragging = false
	end
end)

SetToggle(AntiDieButton, AntiDieCircle, false)
SetToggle(SpinButton, SpinCircle, false)
SetToggle(AutoButton, AutoCircle, true)   
UpdateDot()

print("[Confuser V6] Loaded — Neon Edition + Auto Carry detection")
