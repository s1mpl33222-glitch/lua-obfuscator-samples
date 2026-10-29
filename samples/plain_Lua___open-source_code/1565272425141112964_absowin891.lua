-- hhhh GUI | نطة عالية + سبيد + طيران
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- القيم
local JUMP_POWER = 120
local WALK_SPEED = 100
local FLY_SPEED = 80
local DEFAULT_JUMP = 50
local DEFAULT_SPEED = 16

local state = { jump = false, speed = false, fly = false }

-- مكان الواجهة
local parent
pcall(function() parent = (gethui and gethui()) or game:GetService("CoreGui") end)
if not parent then parent = player:WaitForChild("PlayerGui") end

local old = parent:FindFirstChild("hhhhGui")
if old then old:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "hhhhGui"
gui.ResetOnSpawn = false
gui.Parent = parent

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 230, 0, 220)
main.Position = UDim2.new(0.5, -115, 0.5, -110)
main.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
main.BorderSizePixel = 0
main.Active = true
main.Parent = gui
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 14)

local stroke = Instance.new("UIStroke", main)
stroke.Color = Color3.fromRGB(60, 60, 60)
stroke.Thickness = 1.5

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -40, 0, 44)
title.Position = UDim2.new(0, 14, 0, 0)
title.BackgroundTransparency = 1
title.Text = "hhhh"
title.Font = Enum.Font.GothamBlack
title.TextSize = 26
title.TextColor3 = Color3.new(1, 1, 1)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = main

local close = Instance.new("TextButton")
close.Size = UDim2.new(0, 28, 0, 28)
close.Position = UDim2.new(1, -38, 0, 8)
close.BackgroundColor3 = Color3.fromRGB(25, 10, 10)
close.Text = "X"
close.Font = Enum.Font.GothamBold
close.TextSize = 14
close.TextColor3 = Color3.fromRGB(255, 90, 90)
close.AutoButtonColor = false
close.Parent = main
Instance.new("UICorner", close).CornerRadius = UDim.new(0, 8)

-- سحب الواجهة
do
	local dragging, dragStart, startPos
	main.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = i.Position
			startPos = main.Position
			i.Changed:Connect(function()
				if i.UserInputState == Enum.UserInputState.End then dragging = false end
			end)
		end
	end)
	UserInputService.InputChanged:Connect(function(i)
		if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
			local d = i.Position - dragStart
			main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
		end
	end)
end

-- إنشاء زر
local function makeButton(text, y)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(1, -28, 0, 44)
	b.Position = UDim2.new(0, 14, 0, y)
	b.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	b.Text = text
	b.Font = Enum.Font.GothamBold
	b.TextSize = 16
	b.TextColor3 = Color3.new(1, 1, 1)
	b.AutoButtonColor = false
	b.Parent = main
	Instance.new("UICorner", b).CornerRadius = UDim.new(0, 10)
	local s = Instance.new("UIStroke", b)
	s.Color = Color3.fromRGB(45, 45, 45)
	return b
end

local function paint(btn, on)
	TweenService:Create(btn, TweenInfo.new(0.2), {
		BackgroundColor3 = on and Color3.new(1, 1, 1) or Color3.fromRGB(20, 20, 20),
		TextColor3 = on and Color3.new(0, 0, 0) or Color3.new(1, 1, 1),
	}):Play()
end

local jumpBtn = makeButton("نطة عالية: OFF", 54)
local speedBtn = makeButton("سبيد: OFF", 108)
local flyBtn = makeButton("طيران: OFF", 162)

local function getHum()
	local c = player.Character
	return c and c:FindFirstChildOfClass("Humanoid"), c and c:FindFirstChild("HumanoidRootPart")
end

-- نطة + سبيد
local function applyStats()
	local hum = getHum()
	if not hum then return end
	hum.UseJumpPower = true
	hum.JumpPower = state.jump and JUMP_POWER or DEFAULT_JUMP
	hum.WalkSpeed = state.speed and WALK_SPEED or DEFAULT_SPEED
end

jumpBtn.MouseButton1Click:Connect(function()
	state.jump = not state.jump
	jumpBtn.Text = "نطة عالية: " .. (state.jump and "ON" or "OFF")
	paint(jumpBtn, state.jump)
	applyStats()
end)

speedBtn.MouseButton1Click:Connect(function()
	state.speed = not state.speed
	speedBtn.Text = "سبيد: " .. (state.speed and "ON" or "OFF")
	paint(speedBtn, state.speed)
	applyStats()
end)

-- طيران
local bv, bg, flyConn
local up, down = false, false

UserInputService.InputBegan:Connect(function(i, gp)
	if gp then return end
	if i.KeyCode == Enum.KeyCode.Space then up = true end
	if i.KeyCode == Enum.KeyCode.LeftShift then down = true end
end)
UserInputService.InputEnded:Connect(function(i)
	if i.KeyCode == Enum.KeyCode.Space then up = false end
	if i.KeyCode == Enum.KeyCode.LeftShift then down = false end
end)

local function stopFly()
	if flyConn then flyConn:Disconnect() flyConn = nil end
	if bv then bv:Destroy() bv = nil end
	if bg then bg:Destroy() bg = nil end
	local hum = getHum()
	if hum then hum.PlatformStand = false end
end

local function startFly()
	stopFly()
	local hum, root = getHum()
	if not hum or not root then return end
	hum.PlatformStand = true

	bv = Instance.new("BodyVelocity")
	bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
	bv.Velocity = Vector3.zero
	bv.Parent = root

	bg = Instance.new("BodyGyro")
	bg.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
	bg.P = 9e4
	bg.CFrame = root.CFrame
	bg.Parent = root

	flyConn = RunService.RenderStepped:Connect(function()
		local h, r = getHum()
		if not h or not r or not bv then return end
		local cam = workspace.CurrentCamera
		local move = h.MoveDirection
		local vel = Vector3.zero

		if move.Magnitude > 0 then
			local look = Vector3.new(cam.CFrame.LookVector.X, 0, cam.CFrame.LookVector.Z)
			local right = Vector3.new(cam.CFrame.RightVector.X, 0, cam.CFrame.RightVector.Z)
			if look.Magnitude > 0 then look = look.Unit end
			if right.Magnitude > 0 then right = right.Unit end
			local f = move:Dot(look)
			local s = move:Dot(right)
			vel = (cam.CFrame.LookVector * f + cam.CFrame.RightVector * s) * FLY_SPEED
		end

		if up then vel += Vector3.new(0, FLY_SPEED, 0) end
		if down then vel -= Vector3.new(0, FLY_SPEED, 0) end

		bv.Velocity = vel
		bg.CFrame = cam.CFrame
	end)
end

flyBtn.MouseButton1Click:Connect(function()
	state.fly = not state.fly
	flyBtn.Text = "طيران: " .. (state.fly and "ON" or "OFF")
	paint(flyBtn, state.fly)
	if state.fly then startFly() else stopFly() end
end)

-- بعد الموت يرجع كل شي
player.CharacterAdded:Connect(function()
	task.wait(0.5)
	applyStats()
	if state.fly then startFly() end
end)

-- تثبيت السبيد إذا اللعبة غيّرته
RunService.Heartbeat:Connect(function()
	local hum = getHum()
	if hum and state.speed and hum.WalkSpeed ~= WALK_SPEED then hum.WalkSpeed = WALK_SPEED end
end)

close.MouseButton1Click:Connect(function()
	state.jump, state.speed, state.fly = false, false, false
	applyStats()
	stopFly()
	gui:Destroy()
end)