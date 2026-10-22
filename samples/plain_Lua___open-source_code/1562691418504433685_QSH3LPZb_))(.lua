local P = game:GetService("Players").LocalPlayer
local U = game:GetService("UserInputService")
local R = game:GetService("RunService")
local E = game:GetService("TweenService")
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local Camera = workspace.CurrentCamera

-- Logic Variables
local Features = {
	wallHop = true,
	recording = false,
	replaying = false,
	looping = false,
	noclip = false,
	fly = false,
	esp = false,
	infJump = false,
	spinbot = false,
	fullbright = false,
	walkSpeed = 16,
	jumpPower = 50,
	flySpeed = 50,
	spinSpeed = 20,
	fov = 70
}

local frames, lastHop, elapsed, sample, idx = {}, 0, 0, 0, 1
local espHighlights = {}
local origLighting = { Ambient = Lighting.Ambient, OutdoorAmbient = Lighting.OutdoorAmbient, Brightness = Lighting.Brightness }

-- Theme Colors
local Theme = {
	WindowBg = Color3.fromRGB(15, 15, 15),
	SidebarBg = Color3.fromRGB(20, 20, 20),
	CardBg = Color3.fromRGB(25, 25, 25),
	CardHover = Color3.fromRGB(30, 30, 30),
	Stroke = Color3.fromRGB(40, 40, 40),
	TextMain = Color3.fromRGB(240, 240, 240),
	TextSub = Color3.fromRGB(150, 150, 150),
	Accent = Color3.fromRGB(65, 220, 115), -- WindUI Green
	ToggleOff = Color3.fromRGB(50, 50, 50),
}

-- UI Setup
local gui = Instance.new("ScreenGui")
gui.Name = "WindUI_Ultimate_Mobile"
gui.ResetOnSpawn = false
gui.Parent = P:WaitForChild("PlayerGui")

local function makeDraggable(obj)
	local dragToggle, dragStart, startPos
	obj.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragToggle = true; dragStart = input.Position; startPos = obj.Position
		end
	end)
	U.InputChanged:Connect(function(input)
		if dragToggle and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - dragStart
			E:Create(obj, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
			}):Play()
		end
	end)
	U.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragToggle = false end
	end)
end

-- Floating Button
local openBtn = Instance.new("TextButton")
openBtn.Size = UDim2.fromOffset(45, 45)
openBtn.Position = UDim2.new(0, 20, 0.5, -22)
openBtn.BackgroundColor3 = Theme.WindowBg
openBtn.Text = "W"
openBtn.TextColor3 = Theme.Accent
openBtn.Font = Enum.Font.GothamBold
openBtn.TextSize = 22
openBtn.Visible = false
openBtn.Parent = gui
Instance.new("UICorner", openBtn).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", openBtn).Color = Theme.Stroke
makeDraggable(openBtn)

-- Main Window
local window = Instance.new("Frame")
window.Size = UDim2.fromOffset(500, 320)
window.Position = UDim2.new(0.5, -250, 0.5, -160)
window.BackgroundColor3 = Theme.WindowBg
window.BorderSizePixel = 0
window.ClipsDescendants = true
window.Active = true
window.Parent = gui
Instance.new("UICorner", window).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", window).Color = Theme.Stroke
makeDraggable(window)

-- Close Button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.fromOffset(30, 30)
closeBtn.Position = UDim2.new(1, -40, 0, 10)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "X"
closeBtn.TextColor3 = Theme.TextSub
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
closeBtn.ZIndex = 10
closeBtn.Parent = window
closeBtn.Activated:Connect(function() window.Visible = false; openBtn.Visible = true end)
openBtn.Activated:Connect(function() window.Visible = true; openBtn.Visible = false end)

-- Sidebar
local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0, 130, 1, 0)
sidebar.BackgroundColor3 = Theme.SidebarBg
sidebar.BorderSizePixel = 0
sidebar.Parent = window
local sbLine = Instance.new("Frame")
sbLine.Size = UDim2.new(0, 1, 1, 0)
sbLine.Position = UDim2.new(1, -1, 0, 0)
sbLine.BackgroundColor3 = Theme.Stroke
sbLine.BorderSizePixel = 0
sbLine.Parent = sidebar

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -20, 0, 50)
titleLabel.Position = UDim2.new(0, 15, 0, 5)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "WindUI"
titleLabel.TextColor3 = Theme.TextMain
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 16
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = sidebar

-- Tab System Logic
local contentContainer = Instance.new("Frame")
contentContainer.Size = UDim2.new(1, -130, 1, 0)
contentContainer.Position = UDim2.new(0, 130, 0, 0)
contentContainer.BackgroundTransparency = 1
contentContainer.Parent = window

local tabs = {}
local activeTab = nil

local function createTab(name, icon, order)
	-- Sidebar Button
	local tabBtn = Instance.new("TextButton")
	tabBtn.Size = UDim2.new(1, -16, 0, 34)
	tabBtn.Position = UDim2.new(0, 8, 0, 55 + (order * 38))
	tabBtn.BackgroundColor3 = Theme.CardBg
	tabBtn.BackgroundTransparency = 1
	tabBtn.Text = "  " .. icon .. "  " .. name
	tabBtn.TextColor3 = Theme.TextSub
	tabBtn.Font = Enum.Font.GothamMedium
	tabBtn.TextSize = 12
	tabBtn.TextXAlignment = Enum.TextXAlignment.Left
	tabBtn.Parent = sidebar
	Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 6)
	
	-- Content Page
	local page = Instance.new("ScrollingFrame")
	page.Size = UDim2.new(1, 0, 1, 0)
	page.BackgroundTransparency = 1
	page.BorderSizePixel = 0
	page.ScrollBarThickness = 2
	page.ScrollBarImageColor3 = Theme.Stroke
	page.Visible = false
	page.Parent = contentContainer
	
	local pad = Instance.new("UIPadding", page)
	pad.PaddingTop, pad.PaddingLeft, pad.PaddingRight, pad.PaddingBottom = UDim.new(0, 15), UDim.new(0, 15), UDim.new(0, 15), UDim.new(0, 15)
	local layout = Instance.new("UIListLayout", page)
	layout.Padding = UDim.new(0, 8)
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	
	-- Tab Switching
	tabBtn.Activated:Connect(function()
		if activeTab == name then return end
		for tName, tData in pairs(tabs) do
			tData.page.Visible = (tName == name)
			E:Create(tData.btn, TweenInfo.new(0.2), {
				BackgroundTransparency = (tName == name) and 0 or 1,
				TextColor3 = (tName == name) and Theme.TextMain or Theme.TextSub
			}):Play()
		end
		activeTab = name
	end)
	
	tabs[name] = {btn = tabBtn, page = page}
	return page
end

-- UI Component Generators
local function createToggle(page, text, order, default, callback)
	local state = default
	local card = Instance.new("Frame")
	card.Size = UDim2.new(1, 0, 0, 42)
	card.BackgroundColor3 = Theme.CardBg
	card.LayoutOrder = order
	card.Parent = page
	Instance.new("UICorner", card).CornerRadius = UDim.new(0, 6)
	Instance.new("UIStroke", card).Color = Theme.Stroke
	
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -70, 1, 0)
	label.Position = UDim2.new(0, 15, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = text
	label.TextColor3 = Theme.TextMain
	label.Font = Enum.Font.GothamMedium
	label.TextSize = 13
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = card
	
	local toggleBg = Instance.new("Frame")
	toggleBg.Size = UDim2.new(0, 36, 0, 20)
	toggleBg.AnchorPoint = Vector2.new(1, 0.5)
	toggleBg.Position = UDim2.new(1, -15, 0.5, 0)
	toggleBg.BackgroundColor3 = state and Theme.Accent or Theme.ToggleOff
	toggleBg.Parent = card
	Instance.new("UICorner", toggleBg).CornerRadius = UDim.new(1, 0)
	
	local knob = Instance.new("Frame")
	knob.Size = UDim2.new(0, 14, 0, 14)
	knob.AnchorPoint = Vector2.new(0, 0.5)
	knob.Position = state and UDim2.new(0, 19, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)
	knob.Parent = toggleBg
	Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)
	
	local btn = Instance.new("TextButton", card)
	btn.Size = UDim2.new(1,0,1,0); btn.BackgroundTransparency = 1; btn.Text = ""
	
	btn.Activated:Connect(function()
		state = not state
		E:Create(toggleBg, TweenInfo.new(0.2), {BackgroundColor3 = state and Theme.Accent or Theme.ToggleOff}):Play()
		E:Create(knob, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = state and UDim2.new(0, 19, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)}):Play()
		callback(state)
	end)
end

local function createButton(page, text, order, callback)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, 0, 0, 38)
	btn.BackgroundColor3 = Theme.CardBg
	btn.LayoutOrder = order
	btn.Text = text
	btn.TextColor3 = Theme.TextMain
	btn.Font = Enum.Font.GothamMedium
	btn.TextSize = 13
	btn.AutoButtonColor = false
	btn.Parent = page
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
	Instance.new("UIStroke", btn).Color = Theme.Stroke
	
	btn.MouseEnter:Connect(function() E:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Theme.CardHover}):Play() end)
	btn.MouseLeave:Connect(function() E:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Theme.CardBg}):Play() end)
	btn.Activated:Connect(function()
		E:Create(btn, TweenInfo.new(0.1), {Size = UDim2.new(0.97, 0, 0, 36)}):Play()
		task.wait(0.1)
		E:Create(btn, TweenInfo.new(0.1), {Size = UDim2.new(1, 0, 0, 38)}):Play()
		callback()
	end)
end

local function createSlider(page, text, min, max, default, order, callback)
	local card = Instance.new("Frame")
	card.Size = UDim2.new(1, 0, 0, 60)
	card.BackgroundColor3 = Theme.CardBg
	card.LayoutOrder = order
	card.Parent = page
	Instance.new("UICorner", card).CornerRadius = UDim.new(0, 6)
	Instance.new("UIStroke", card).Color = Theme.Stroke
	
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -30, 0, 20)
	label.Position = UDim2.new(0, 15, 0, 8)
	label.BackgroundTransparency = 1
	label.Text = text
	label.TextColor3 = Theme.TextMain
	label.Font = Enum.Font.GothamMedium
	label.TextSize = 13
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = card
	
	local valLabel = Instance.new("TextLabel")
	valLabel.Size = UDim2.new(0, 40, 0, 20)
	valLabel.Position = UDim2.new(1, -55, 0, 8)
	valLabel.BackgroundTransparency = 1
	valLabel.Text = tostring(default)
	valLabel.TextColor3 = Theme.Accent
	valLabel.Font = Enum.Font.GothamBold
	valLabel.TextSize = 13
	valLabel.TextXAlignment = Enum.TextXAlignment.Right
	valLabel.Parent = card
	
	local sliderBg = Instance.new("Frame")
	sliderBg.Size = UDim2.new(1, -30, 0, 6)
	sliderBg.Position = UDim2.new(0, 15, 0, 38)
	sliderBg.BackgroundColor3 = Theme.ToggleOff
	sliderBg.Parent = card
	Instance.new("UICorner", sliderBg).CornerRadius = UDim.new(1, 0)
	
	local fill = Instance.new("Frame")
	fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
	fill.BackgroundColor3 = Theme.Accent
	fill.Parent = sliderBg
	Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
	
	local btn = Instance.new("TextButton", sliderBg)
	btn.Size = UDim2.new(1, 0, 1, 20); btn.Position = UDim2.new(0,0,0,-10)
	btn.BackgroundTransparency = 1; btn.Text = ""
	
	local dragging = false
	local function updateSlider(input)
		local percent = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
		local val = math.floor(min + (max - min) * percent)
		E:Create(fill, TweenInfo.new(0.05), {Size = UDim2.new(percent, 0, 1, 0)}):Play()
		valLabel.Text = tostring(val)
		callback(val)
	end
	
	btn.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true; updateSlider(input)
		end
	end)
	U.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then updateSlider(input) end
	end)
	U.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
	end)
end

-- Initialize Tabs
local pageMove = createTab("Movement", "🏃", 0)
local pageMacro = createTab("Macro", "⏺️", 1)
local pageExploit = createTab("Exploits", "⚡", 2)
local pageVis = createTab("Visuals", "👁️", 3)

-- MOVEMENT TAB
createToggle(pageMove, "Enable Wall Hop", 1, Features.wallHop, function(s) Features.wallHop = s end)
createToggle(pageMove, "Infinite Jump", 2, Features.infJump, function(s) Features.infJump = s end)
createSlider(pageMove, "Walk Speed", 16, 150, 16, 3, function(v) Features.walkSpeed = v end)
createSlider(pageMove, "Jump Power", 50, 200, 50, 4, function(v) Features.jumpPower = v end)

-- MACRO TAB
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, 0, 0, 20); statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Status: Idle"; statusLabel.TextColor3 = Theme.Accent
statusLabel.Font = Enum.Font.GothamMedium; statusLabel.TextSize = 13; statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.LayoutOrder = 0; statusLabel.Parent = pageMacro

local function updateStatus(txt) statusLabel.Text = "Status: " .. txt end

createButton(pageMacro, "Start Recording", 1, function()
	if Features.replaying then return end
	frames = {}; Features.recording = true; elapsed = 0; sample = 0
	updateStatus("Recording...")
end)
createButton(pageMacro, "Stop / Save", 2, function()
	Features.recording = false; updateStatus("Saved " .. #frames .. " frames")
end)
createButton(pageMacro, "Play Macro", 3, function()
	if #frames < 2 or Features.recording or Features.replaying then updateStatus("Need frames!"); return end
	Features.replaying = true; elapsed = 0; idx = 1
	updateStatus("Replaying...")
end)
createToggle(pageMacro, "Loop Playback", 4, Features.looping, function(s) Features.looping = s end)

-- EXPLOITS TAB
createToggle(pageExploit, "Noclip", 1, Features.noclip, function(s) Features.noclip = s end)
createToggle(pageExploit, "Fly (Mobile Ready)", 2, Features.fly, function(s) Features.fly = s end)
createSlider(pageExploit, "Fly Speed", 10, 200, 50, 3, function(v) Features.flySpeed = v end)
createToggle(pageExploit, "Spinbot", 4, Features.spinbot, function(s) Features.spinbot = s end)
createSlider(pageExploit, "Spin Speed", 5, 100, 20, 5, function(v) Features.spinSpeed = v end)

-- VISUALS TAB
createToggle(pageVis, "Player ESP", 1, Features.esp, function(s)
	Features.esp = s
	for _, p in pairs(Players:GetPlayers()) do
		if p ~= P and p.Character then
			if s and not espHighlights[p] then
				local h = Instance.new("Highlight", p.Character)
				h.FillColor = Color3.fromRGB(255, 50, 50); h.FillTransparency = 0.5; espHighlights[p] = h
			elseif not s and espHighlights[p] then
				espHighlights[p]:Destroy(); espHighlights[p] = nil
			end
		end
	end
end)
createToggle(pageVis, "Fullbright", 2, Features.fullbright, function(s)
	Features.fullbright = s
	Lighting.Ambient = s and Color3.new(1,1,1) or origLighting.Ambient
	Lighting.OutdoorAmbient = s and Color3.new(1,1,1) or origLighting.OutdoorAmbient
	Lighting.Brightness = s and 2 or origLighting.Brightness
end)
createSlider(pageVis, "Field of View", 70, 120, 70, 3, function(v) Features.fov = v end)

-- Core Game Logic Variables
local function getChar()
	local c = P.Character
	if c and c:FindFirstChild("Humanoid") and c:FindFirstChild("HumanoidRootPart") and c.Humanoid.Health > 0 then
		return c, c.HumanoidRootPart, c.Humanoid
	end
end

-- Input Connections (Hop & Inf Jump)
U.JumpRequest:Connect(function()
	local c, r, h = getChar()
	if not c then return end
	
	if Features.infJump then
		h:ChangeState(Enum.HumanoidStateType.Jumping)
	end
	
	if Features.wallHop and not Features.replaying and os.clock() - lastHop >= 0.12 and h.FloorMaterial == Enum.Material.Air then
		local rp = RaycastParams.new(); rp.FilterDescendantsInstances = {c}
		local best, dist = nil, 4
		for a = 0, 315, 45 do
			local hit = workspace:Raycast(r.Position, Vector3.new(math.cos(math.rad(a)), 0, math.sin(math.rad(a))) * 4, rp)
			if hit and math.abs(hit.Normal.Y) < 0.25 and hit.Distance < dist then best = hit; dist = hit.Distance end
		end
		if best then
			lastHop = os.clock()
			local v = r.AssemblyLinearVelocity; local n = best.Normal
			r.AssemblyLinearVelocity = Vector3.new(v.X * 0.95 + n.X * 3, math.max(v.Y, 65), v.Z * 0.95 + n.Z * 3)
		end
	end
end)

-- Frame Updates (Fly, Spinbot, Noclip, WalkSpeed, Recorder)
R.Stepped:Connect(function()
	if Features.noclip then
		local c = P.Character
		if c then for _, part in pairs(c:GetDescendants()) do if part:IsA("BasePart") then part.CanCollide = false end end end
	end
end)

R.Heartbeat:Connect(function(dt)
	Camera.FieldOfView = Features.fov
	local c, r, h = getChar()
	if not c then return end

	-- Modifiers
	if h.WalkSpeed ~= Features.walkSpeed then h.WalkSpeed = Features.walkSpeed end
	if h.JumpPower ~= Features.jumpPower then h.JumpPower = Features.jumpPower; h.UseJumpPower = true end
	
	if Features.spinbot then
		r.CFrame = r.CFrame * CFrame.Angles(0, math.rad(Features.spinSpeed), 0)
	end

	if Features.fly then
		local moveDir = h.MoveDirection
		if moveDir.Magnitude > 0 then
			r.AssemblyLinearVelocity = Vector3.new(moveDir.X * Features.flySpeed, Camera.CFrame.LookVector.Y * Features.flySpeed * moveDir.Magnitude, moveDir.Z * Features.flySpeed)
		else
			r.AssemblyLinearVelocity = Vector3.zero
		end
	end

	-- Recorder
	if Features.recording then
		sample += dt
		while sample >= 0.05 do sample -= 0.05; table.insert(frames, {time = (#frames) * 0.05, cframe = r.CFrame}) end
		updateStatus("Recording: " .. #frames .. " frames")
	end
	
	if Features.replaying and #frames >= 2 then
		elapsed += dt
		local duration = frames[#frames].time
		if elapsed >= duration then
			if Features.looping then elapsed = elapsed % duration; idx = 1
			else r.CFrame = frames[#frames].cframe; Features.replaying = false; updateStatus("Playback finished"); return end
		end
		while idx < #frames - 1 and frames[idx + 1].time < elapsed do idx += 1 end
		local a, b = frames[idx], frames[math.min(idx + 1, #frames)]
		local span = b.time - a.time
		r.CFrame = a.cframe:Lerp(b.cframe, span > 0 and math.clamp((elapsed - a.time) / span, 0, 1) or 0)
		updateStatus(Features.looping and "Replaying (Looped)" or "Replaying...")
	end
end)

-- Open first tab
for name, t in pairs(tabs) do t.btn.BackgroundTransparency = 1; t.btn.TextColor3 = Theme.TextSub; t.page.Visible = false end
tabs["Movement"].btn.BackgroundTransparency = 0
tabs["Movement"].btn.TextColor3 = Theme.TextMain
tabs["Movement"].page.Visible = true
activeTab = "Movement"
