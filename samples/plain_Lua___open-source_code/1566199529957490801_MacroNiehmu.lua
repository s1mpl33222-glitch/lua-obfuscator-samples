-- NIEHMU
-- Interface glass premium + fermer / réduire
-- Compatible Real Executor

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- === CONFIG ===
local holding = false
local minimized = false
local toggleKey = Enum.KeyCode.F1
local VK_E = 0x45
local changingKey = false

-- === COULEURS ===
local C = {
	Bg          = Color3.fromRGB(10, 5, 7),
	Glass       = Color3.fromRGB(32, 12, 16),
	Accent      = Color3.fromRGB(170, 32, 45),
	AccentSoft  = Color3.fromRGB(130, 28, 38),
	Text        = Color3.fromRGB(250, 235, 235),
	TextDim     = Color3.fromRGB(175, 145, 150),
	On          = Color3.fromRGB(195, 48, 58),
	Off         = Color3.fromRGB(42, 16, 20),
	Border      = Color3.fromRGB(95, 28, 38),
	Close       = Color3.fromRGB(200, 45, 55),
	Minimize    = Color3.fromRGB(220, 140, 40),
}

-- === GUI ===
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NIEHMU_GUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 255, 0, 148)
Main.Position = UDim2.new(0, 40, 0.38, 0)
Main.BackgroundColor3 = C.Bg
Main.BackgroundTransparency = 0.22
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 16)
MainCorner.Parent = Main

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = C.Border
MainStroke.Thickness = 1.3
MainStroke.Transparency = 0.4
MainStroke.Parent = Main

local TopGlow = Instance.new("Frame")
TopGlow.Size = UDim2.new(1, 0, 0, 44)
TopGlow.BackgroundColor3 = C.Glass
TopGlow.BackgroundTransparency = 0.55
TopGlow.BorderSizePixel = 0
TopGlow.Parent = Main

local TopGlowCorner = Instance.new("UICorner")
TopGlowCorner.CornerRadius = UDim.new(0, 16)
TopGlowCorner.Parent = TopGlow

local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 44)
Header.BackgroundTransparency = 1
Header.Parent = Main

-- Nom NIEHMU uniquement
local Brand = Instance.new("TextLabel")
Brand.Size = UDim2.new(1, -70, 1, 0)
Brand.Position = UDim2.new(0, 16, 0, 0)
Brand.BackgroundTransparency = 1
Brand.Text = "NIEHMU"
Brand.TextColor3 = C.Accent
Brand.Font = Enum.Font.GothamBlack
Brand.TextSize = 17
Brand.TextXAlignment = Enum.TextXAlignment.Left
Brand.Parent = Header

-- Points fermer / réduire
local function createDot(color, position)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 14, 0, 14)
	btn.Position = position
	btn.BackgroundColor3 = color
	btn.BackgroundTransparency = 0.1
	btn.Text = ""
	btn.AutoButtonColor = false
	btn.Parent = Header

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(1, 0)
	corner.Parent = btn

	local stroke = Instance.new("UIStroke")
	stroke.Color = color
	stroke.Thickness = 1
	stroke.Transparency = 0.5
	stroke.Parent = btn

	return btn
end

local CloseBtn = createDot(C.Close, UDim2.new(1, -24, 0.5, -7))
local MinBtn = createDot(C.Minimize, UDim2.new(1, -46, 0.5, -7))

local Content = Instance.new("Frame")
Content.Name = "Content"
Content.Size = UDim2.new(1, 0, 1, -44)
Content.Position = UDim2.new(0, 0, 0, 44)
Content.BackgroundTransparency = 1
Content.Parent = Main

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Name = "Toggle"
ToggleBtn.Size = UDim2.new(0.9, 0, 0, 40)
ToggleBtn.Position = UDim2.new(0.05, 0, 0, 8)
ToggleBtn.BackgroundColor3 = C.Off
ToggleBtn.BackgroundTransparency = 0.08
ToggleBtn.Text = "DÉSACTIVÉ"
ToggleBtn.TextColor3 = C.TextDim
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 14
ToggleBtn.AutoButtonColor = false
ToggleBtn.Parent = Content

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 11)
ToggleCorner.Parent = ToggleBtn

local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Color = C.AccentSoft
ToggleStroke.Thickness = 1.2
ToggleStroke.Transparency = 0.45
ToggleStroke.Parent = ToggleBtn

local KeyBtn = Instance.new("TextButton")
KeyBtn.Name = "Keybind"
KeyBtn.Size = UDim2.new(0.9, 0, 0, 34)
KeyBtn.Position = UDim2.new(0.05, 0, 0, 58)
KeyBtn.BackgroundColor3 = C.Glass
KeyBtn.BackgroundTransparency = 0.2
KeyBtn.Text = "Touche : F1"
KeyBtn.TextColor3 = C.TextDim
KeyBtn.Font = Enum.Font.GothamMedium
KeyBtn.TextSize = 12
KeyBtn.AutoButtonColor = false
KeyBtn.Parent = Content

local KeyCorner = Instance.new("UICorner")
KeyCorner.CornerRadius = UDim.new(0, 10)
KeyCorner.Parent = KeyBtn

local KeyStroke = Instance.new("UIStroke")
KeyStroke.Color = C.Border
KeyStroke.Thickness = 1
KeyStroke.Transparency = 0.5
KeyStroke.Parent = KeyBtn

-- === DRAG ===
local dragging, dragStart, startPos = false, nil, nil

Header.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = Main.Position
	end
end)

Header.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart
		Main.Position = UDim2.new(
			startPos.X.Scale, startPos.X.Offset + delta.X,
			startPos.Y.Scale, startPos.Y.Offset + delta.Y
		)
	end
end)

-- === LOGIQUE ===
local function updateToggle()
	if holding then
		ToggleBtn.Text = "ACTIVÉ"
		ToggleBtn.TextColor3 = Color3.fromRGB(255, 215, 215)
		ToggleBtn.BackgroundColor3 = C.On
		ToggleStroke.Transparency = 0.15
		ToggleStroke.Color = C.Accent
	else
		ToggleBtn.Text = "DÉSACTIVÉ"
		ToggleBtn.TextColor3 = C.TextDim
		ToggleBtn.BackgroundColor3 = C.Off
		ToggleStroke.Transparency = 0.45
		ToggleStroke.Color = C.AccentSoft
	end
end

local function startLoop()
	pcall(function() mouse2press() end)
	pcall(function() mouse1press() end)

	while holding do
		-- Délais un peu aléatoires (moins robotique)
		local delay = 0.045 + math.random() * 0.025

		pcall(function()
			if keyclick then keyclick(VK_E) end
		end)
		pcall(function()
			keypress(VK_E)
			task.wait(0.012 + math.random() * 0.01)
			keyrelease(VK_E)
		end)
		pcall(function()
			local vim = game:GetService("VirtualInputManager")
			vim:SendKeyEvent(true, Enum.KeyCode.E, false, game)
			task.wait(0.008 + math.random() * 0.008)
			vim:SendKeyEvent(false, Enum.KeyCode.E, false, game)
		end)

		task.wait(delay)
	end
end

local function stopLoop()
	holding = false
	pcall(function() keyrelease(VK_E) end)
	pcall(function() mouse2release() end)
	pcall(function() mouse1release() end)
end

local function toggle()
	if not holding then
		holding = true
		updateToggle()
		task.spawn(startLoop)
	else
		stopLoop()
		updateToggle()
	end
end

CloseBtn.MouseButton1Click:Connect(function()
	stopLoop()
	ScreenGui:Destroy()
end)

MinBtn.MouseButton1Click:Connect(function()
	minimized = not minimized
	if minimized then
		TweenService:Create(Main, TweenInfo.new(0.25, Enum.EasingStyle.Quint), {
			Size = UDim2.new(0, 255, 0, 44)
		}):Play()
		Content.Visible = false
	else
		Content.Visible = true
		TweenService:Create(Main, TweenInfo.new(0.25, Enum.EasingStyle.Quint), {
			Size = UDim2.new(0, 255, 0, 148)
		}):Play()
	end
end)

CloseBtn.MouseEnter:Connect(function()
	TweenService:Create(CloseBtn, TweenInfo.new(0.12), {BackgroundTransparency = 0}):Play()
end)
CloseBtn.MouseLeave:Connect(function()
	TweenService:Create(CloseBtn, TweenInfo.new(0.12), {BackgroundTransparency = 0.1}):Play()
end)

MinBtn.MouseEnter:Connect(function()
	TweenService:Create(MinBtn, TweenInfo.new(0.12), {BackgroundTransparency = 0}):Play()
end)
MinBtn.MouseLeave:Connect(function()
	TweenService:Create(MinBtn, TweenInfo.new(0.12), {BackgroundTransparency = 0.1}):Play()
end)

ToggleBtn.MouseButton1Click:Connect(toggle)

ToggleBtn.MouseEnter:Connect(function()
	if not holding then
		TweenService:Create(ToggleBtn, TweenInfo.new(0.15), {BackgroundColor3 = C.AccentSoft}):Play()
	end
end)
ToggleBtn.MouseLeave:Connect(function()
	if not holding then
		TweenService:Create(ToggleBtn, TweenInfo.new(0.15), {BackgroundColor3 = C.Off}):Play()
	end
end)

KeyBtn.MouseButton1Click:Connect(function()
	changingKey = true
	KeyBtn.Text = "Appuie sur une touche..."
	KeyBtn.TextColor3 = Color3.fromRGB(255, 195, 130)
end)

UserInputService.InputBegan:Connect(function(input, gp)
	if gp then return end

	if changingKey and input.UserInputType == Enum.UserInputType.Keyboard then
		toggleKey = input.KeyCode
		changingKey = false
		KeyBtn.Text = "Touche : " .. input.KeyCode.Name
		KeyBtn.TextColor3 = C.TextDim
		return
	end

	if input.KeyCode == toggleKey then
		toggle()
	end
end)

print("NIEHMU chargé")
