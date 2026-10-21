 
 
 
 
 

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

 
local CONFIG = {
	ToggleKey = Enum.KeyCode.K,
	Title     = "Painel de Controle",
	Size      = UDim2.fromOffset(420, 340),
	Accent    = Color3.fromRGB(90, 140, 255),
	BgColor   = Color3.fromRGB(34, 36, 44),
	BarColor  = Color3.fromRGB(26, 28, 34),
	ItemColor = Color3.fromRGB(46, 49, 60),
	TextColor = Color3.fromRGB(235, 236, 245),
}

 
local function corner(parent, radius)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, radius)
	c.Parent = parent
	return c
end

 
local old = playerGui:FindFirstChild("PainelLuau")
if old then old:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "PainelLuau"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = playerGui

local panel = Instance.new("Frame")
panel.Name = "Panel"
panel.AnchorPoint = Vector2.new(0.5, 0.5)
panel.Position = UDim2.fromScale(0.5, 0.5)
panel.Size = CONFIG.Size
panel.BackgroundColor3 = CONFIG.BgColor
panel.BorderSizePixel = 0
panel.ClipsDescendants = true
panel.Visible = false
panel.Parent = gui
corner(panel, 12)

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(62, 66, 80)
stroke.Thickness = 1
stroke.Parent = panel

 
local bar = Instance.new("Frame")
bar.Name = "TitleBar"
bar.Size = UDim2.new(1, 0, 0, 44)
bar.BackgroundColor3 = CONFIG.BarColor
bar.BorderSizePixel = 0
bar.Parent = panel

local grad = Instance.new("UIGradient")
grad.Color = ColorSequence.new(Color3.fromRGB(44, 48, 60), CONFIG.BarColor)
grad.Rotation = 90
grad.Parent = bar

local title = Instance.new("TextLabel")
title.BackgroundTransparency = 1
title.Position = UDim2.fromOffset(16, 0)
title.Size = UDim2.new(1, -60, 1, 0)
title.Font = Enum.Font.GothamBold
title.TextSize = 15
title.TextColor3 = CONFIG.TextColor
title.TextXAlignment = Enum.TextXAlignment.Left
title.Text = CONFIG.Title
title.Parent = bar

local closeBtn = Instance.new("TextButton")
closeBtn.AnchorPoint = Vector2.new(1, 0.5)
closeBtn.Position = UDim2.new(1, -10, 0.5, 0)
closeBtn.Size = UDim2.fromOffset(28, 28)
closeBtn.BackgroundColor3 = Color3.fromRGB(220, 70, 80)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "✕"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
closeBtn.TextColor3 = Color3.fromRGB(170, 175, 190)
closeBtn.AutoButtonColor = false
closeBtn.Parent = bar
corner(closeBtn, 8)

closeBtn.MouseEnter:Connect(function()
	TweenService:Create(closeBtn, TweenInfo.new(0.15), {
		BackgroundTransparency = 0,
		TextColor3 = Color3.new(1, 1, 1),
	}):Play()
end)
closeBtn.MouseLeave:Connect(function()
	TweenService:Create(closeBtn, TweenInfo.new(0.15), {
		BackgroundTransparency = 1,
		TextColor3 = Color3.fromRGB(170, 175, 190),
	}):Play()
end)

 
local content = Instance.new("ScrollingFrame")
content.Name = "Content"
content.Position = UDim2.fromOffset(0, 44)
content.Size = UDim2.new(1, 0, 1, -44)
content.BackgroundTransparency = 1
content.BorderSizePixel = 0
content.ScrollBarThickness = 4
content.ScrollBarImageColor3 = Color3.fromRGB(80, 85, 100)
content.CanvasSize = UDim2.new()
content.AutomaticCanvasSize = Enum.AutomaticSize.Y
content.Parent = panel

local pad = Instance.new("UIPadding")
pad.PaddingTop = UDim.new(0, 12)
pad.PaddingBottom = UDim.new(0, 12)
pad.PaddingLeft = UDim.new(0, 12)
pad.PaddingRight = UDim.new(0, 12)
pad.Parent = content

local list = Instance.new("UIListLayout")
list.Padding = UDim.new(0, 8)
list.SortOrder = Enum.SortOrder.LayoutOrder
list.Parent = content

 
local function addSection(text)
	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(1, 0, 0, 20)
	lbl.BackgroundTransparency = 1
	lbl.Font = Enum.Font.GothamBold
	lbl.TextSize = 11
	lbl.TextColor3 = CONFIG.Accent
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.Text = string.upper(text)
	lbl.Parent = content
	return lbl
end

local function addButton(text, callback)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, 0, 0, 34)
	btn.BackgroundColor3 = CONFIG.ItemColor
	btn.AutoButtonColor = false
	btn.Text = ""
	btn.Parent = content
	corner(btn, 8)

	local lbl = Instance.new("TextLabel")
	lbl.BackgroundTransparency = 1
	lbl.Position = UDim2.fromOffset(12, 0)
	lbl.Size = UDim2.new(1, -24, 1, 0)
	lbl.Font = Enum.Font.GothamMedium
	lbl.TextSize = 14
	lbl.TextColor3 = CONFIG.TextColor
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.Text = text
	lbl.Parent = btn

	btn.MouseEnter:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.15), {
			BackgroundColor3 = Color3.fromRGB(58, 62, 76),
		}):Play()
	end)
	btn.MouseLeave:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.15), {
			BackgroundColor3 = CONFIG.ItemColor,
		}):Play()
	end)
	btn.MouseButton1Click:Connect(callback)
	return btn
end

local function addToggle(text, default, callback)
	local row = Instance.new("Frame")
	row.Size = UDim2.new(1, 0, 0, 34)
	row.BackgroundColor3 = CONFIG.ItemColor
	row.Parent = content
	corner(row, 8)

	local lbl = Instance.new("TextLabel")
	lbl.BackgroundTransparency = 1
	lbl.Position = UDim2.fromOffset(12, 0)
	lbl.Size = UDim2.new(1, -70, 1, 0)
	lbl.Font = Enum.Font.GothamMedium
	lbl.TextSize = 14
	lbl.TextColor3 = CONFIG.TextColor
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.Text = text
	lbl.Parent = row

	local switch = Instance.new("Frame")
	switch.AnchorPoint = Vector2.new(1, 0.5)
	switch.Position = UDim2.new(1, -10, 0.5, 0)
	switch.Size = UDim2.fromOffset(40, 22)
	switch.BackgroundColor3 = Color3.fromRGB(60, 64, 78)
	switch.Parent = row
	corner(switch, 11)

	local knob = Instance.new("Frame")
	knob.AnchorPoint = Vector2.new(0, 0.5)
	knob.Position = UDim2.new(0, 3, 0.5, 0)
	knob.Size = UDim2.fromOffset(16, 16)
	knob.BackgroundColor3 = Color3.fromRGB(200, 205, 220)
	knob.Parent = switch
	corner(knob, 8)

	local state = default
	local function render()
		TweenService:Create(knob, TweenInfo.new(0.18, Enum.EasingStyle.Quad), {
			Position = state and UDim2.new(1, -19, 0.5, 0) or UDim2.new(0, 3, 0.5, 0),
			BackgroundColor3 = state and Color3.new(1, 1, 1) or Color3.fromRGB(200, 205, 220),
		}):Play()
		TweenService:Create(switch, TweenInfo.new(0.18), {
			BackgroundColor3 = state and CONFIG.Accent or Color3.fromRGB(60, 64, 78),
		}):Play()
	end
	render()

	local click = Instance.new("TextButton")
	click.BackgroundTransparency = 1
	click.Size = UDim2.fromScale(1, 1)
	click.Text = ""
	click.Parent = row
	click.MouseButton1Click:Connect(function()
		state = not state
		render()
		callback(state)
	end)
	return row
end

 
addSection("Ações")

addButton("Dizer olá no chat", function()
	print("[Painel] Olá! 👋")
end)

addButton("Resetar personagem", function()
	local char = player.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if hum then hum.Health = 0 end
end)

addSection("Opções")

addToggle("Modo turbo", false, function(state)
	print("[Painel] Modo turbo:", state)
end)

addToggle("Mostrar FPS", true, function(state)
	print("[Painel] Mostrar FPS:", state)
end)

 
local dragging, dragStart, startPos

bar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = panel.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
		or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - dragStart
		panel.Position = UDim2.new(
			startPos.X.Scale, startPos.X.Offset + delta.X,
			startPos.Y.Scale, startPos.Y.Offset + delta.Y
		)
	end
end)

 
local isOpen = false

local function setOpen(state)
	isOpen = state
	if state then
		panel.Visible = true
		panel.Size = UDim2.fromOffset(0, 0)
		TweenService:Create(panel,
			TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
			{ Size = CONFIG.Size }
		):Play()
	else
		local tween = TweenService:Create(panel,
			TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
			{ Size = UDim2.fromOffset(0, 0) }
		)
		tween:Play()
		tween.Completed:Connect(function()
			if not isOpen then panel.Visible = false end
		end)
	end
end

closeBtn.MouseButton1Click:Connect(function()
	setOpen(false)
end)

UserInputService.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	if input.KeyCode == CONFIG.ToggleKey then
		setOpen(not isOpen)
	end
end)