local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local gui = Instance.new("ScreenGui")
gui.ResetOnSpawn = false
gui.DisplayOrder = 999999
gui.IgnoreGuiInset = true
gui.Parent = player:WaitForChild("PlayerGui")

-- انترو مليان إفكتات وحركات بصرية فخمة
local introFrame = Instance.new("Frame")
introFrame.Size = UDim2.new(1, 0, 1, 0)
introFrame.Position = UDim2.new(0, 0, 0, 0)
introFrame.BackgroundColor3 = Color3.fromRGB(5, 5, 10)
introFrame.BackgroundTransparency = 0
introFrame.BorderSizePixel = 0
introFrame.ZIndex = 200
introFrame.Parent = gui

-- تدرج لوني متحرك للخلفية
local bgGrad = Instance.new("UIGradient", introFrame)
bgGrad.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(10, 10, 25)),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(40, 10, 60)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 50, 50)),
})
bgGrad.Rotation = 0

-- جسيمات طاقة تتطاير بكثافة طوال فترة الانترو
local function createParticle()
	local p = Instance.new("Frame")
	p.Size = UDim2.new(0, math.random(4, 12), 0, math.random(4, 12))
	p.Position = UDim2.new(math.random(0, 100)/100, 0, 1.1, 0)
	p.BackgroundColor3 = Color3.fromRGB(0, 255, 180)
	p.BackgroundTransparency = 0.2
	p.BorderSizePixel = 0
	p.ZIndex = 201
	p.Parent = introFrame
	Instance.new("UICorner", p).CornerRadius = UDim.new(1, 0)
	
	task.spawn(function()
		local speed = math.random(20, 40) / 10
		TweenService:Create(p, TweenInfo.new(speed, Enum.EasingStyle.Sine), {
			Position = UDim2.new(p.Position.X.Scale + math.random(-30,30)/100, 0, -0.2, 0),
			BackgroundTransparency = 1
		}):Play()
		task.wait(speed)
		p:Destroy()
	end)
end

task.spawn(function()
	while introFrame.Parent do
		createParticle()
		task.wait(0.1)
	end
end)

-- خط المسح الضوئي (Scanner Line)
local scanLine = Instance.new("Frame")
scanLine.Size = UDim2.new(1, 0, 0, 3)
scanLine.Position = UDim2.new(0, 0, 0, 0)
scanLine.BackgroundColor3 = Color3.fromRGB(0, 255, 200)
scanLine.BackgroundTransparency = 0.3
scanLine.BorderSizePixel = 0
scanLine.ZIndex = 215
scanLine.Parent = introFrame

-- دوائر طاقة متوهجة بالمنتصف
local glowRing1 = Instance.new("Frame")
glowRing1.Size = UDim2.new(0, 0, 0, 0)
glowRing1.Position = UDim2.new(0.5, 0, 0.5, 0)
glowRing1.BackgroundColor3 = Color3.fromRGB(100, 0, 255)
glowRing1.BackgroundTransparency = 0.5
glowRing1.BorderSizePixel = 0
glowRing1.ZIndex = 202
glowRing1.Parent = introFrame
Instance.new("UICorner", glowRing1).CornerRadius = UDim.new(1, 0)

local glowRing2 = Instance.new("Frame")
glowRing2.Size = UDim2.new(0, 0, 0, 0)
glowRing2.Position = UDim2.new(0.5, 0, 0.5, 0)
glowRing2.BackgroundColor3 = Color3.fromRGB(0, 255, 180)
glowRing2.BackgroundTransparency = 0.5
glowRing2.BorderSizePixel = 0
glowRing2.ZIndex = 203
glowRing2.Parent = introFrame
Instance.new("UICorner", glowRing2).CornerRadius = UDim.new(1, 0)

-- الشكل الأوسط (المثلث / المعين)
local centerBox = Instance.new("Frame")
centerBox.Size = UDim2.new(0, 0, 0, 0)
centerBox.Position = UDim2.new(0.5, 0, 0.5, 0)
centerBox.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
centerBox.BorderSizePixel = 0
centerBox.ZIndex = 205
centerBox.Parent = introFrame
Instance.new("UICorner", centerBox).CornerRadius = UDim.new(0, 16)
centerBox.Rotation = 45

local boxStroke = Instance.new("UIStroke", centerBox)
boxStroke.Thickness = 3.5
boxStroke.Color = Color3.fromRGB(0, 255, 180)
boxStroke.Transparency = 1

-- كلمة AUTO داخل المثلث
local centerLogoText = Instance.new("TextLabel")
centerLogoText.Size = UDim2.new(1, 0, 1, 0)
centerLogoText.Position = UDim2.new(0, 0, 0, 0)
centerLogoText.BackgroundTransparency = 1
centerLogoText.Text = "AUTO"
centerLogoText.TextColor3 = Color3.fromRGB(0, 255, 180)
centerLogoText.TextScaled = true
centerLogoText.Font = Enum.Font.GothamBold
centerLogoText.TextTransparency = 1
centerLogoText.ZIndex = 208
centerLogoText.Parent = centerBox
centerLogoText.Rotation = -45

-- حقوقك كاملة وبالروابط الصحيحة تماماً
local introTitle = Instance.new("TextLabel")
introTitle.Size = UDim2.new(1, 0, 0, 50)
introTitle.Position = UDim2.new(0, 0, 0.5, 75)
introTitle.BackgroundTransparency = 1
introTitle.Text = "Dev.Script"
introTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
introTitle.TextScaled = true
introTitle.Font = Enum.Font.GothamBold
introTitle.TextTransparency = 1
introTitle.ZIndex = 210
introTitle.Parent = introFrame

local introSub = Instance.new("TextLabel")
introSub.Size = UDim2.new(1, 0, 0, 25)
introSub.Position = UDim2.new(0, 0, 0.5, 130)
introSub.BackgroundTransparency = 1
introSub.Text = "TikTok: hf4_l  |  Discord.gg/4hDr9Zb7P"
introSub.TextColor3 = Color3.fromRGB(0, 255, 180)
introSub.TextScaled = true
introSub.Font = Enum.Font.GothamBold
introSub.TextTransparency = 1
introSub.ZIndex = 210
introSub.Parent = introFrame

-- القائمة المصغرة الرئيسية (بمنتصف الشاشة)
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 160, 0, 85)
frame.Position = UDim2.new(0.5, -80, 0.5, -42)
frame.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
frame.BackgroundTransparency = 1
frame.BorderSizePixel = 0
frame.Parent = gui

Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

local frameStroke = Instance.new("UIStroke", frame)
frameStroke.Thickness = 1.2
frameStroke.Color = Color3.fromRGB(0, 255, 180)
frameStroke.Transparency = 1

local dragBar = Instance.new("TextButton")
dragBar.Size = UDim2.new(1, 0, 0, 24)
dragBar.Position = UDim2.new(0, 0, 0, 0)
dragBar.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
dragBar.BackgroundTransparency = 1
dragBar.Text = "≡ DEV.SCRIPT PANEL ≡"
dragBar.TextColor3 = Color3.fromRGB(0, 255, 180)
dragBar.TextSize = 10
dragBar.Font = Enum.Font.GothamBold
dragBar.BorderSizePixel = 0
dragBar.Parent = frame

Instance.new("UICorner", dragBar).CornerRadius = UDim.new(0, 8)

local button = Instance.new("TextButton")
button.Size = UDim2.new(1, -16, 0, 45)
button.Position = UDim2.new(0, 8, 0, 32)
button.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
button.BackgroundTransparency = 1
button.Text = "OFF"
button.TextColor3 = Color3.fromRGB(160, 160, 180)
button.TextTransparency = 1
button.TextSize = 18
button.Font = Enum.Font.GothamBold
button.BorderSizePixel = 0
button.Parent = frame

Instance.new("UICorner", button).CornerRadius = UDim.new(0, 6)

local btnGrad = Instance.new("UIGradient", button)
btnGrad.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 35, 45)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(18, 18, 25)),
})
btnGrad.Rotation = 90

local btnStroke = Instance.new("UIStroke", button)
btnStroke.Thickness = 1
btnStroke.Color = Color3.fromRGB(60, 60, 80)
btnStroke.Transparency = 1

-- تشغيل الانترو بالتأثيرات
local function playIntro()
	task.wait(0.3)
	
	task.spawn(function()
		while introFrame.Parent do
			TweenService:Create(bgGrad, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 0, true), {
				Rotation = bgGrad.Rotation + 180
			}):Play()
			task.wait(2)
		end
	end)

	task.spawn(function()
		while introFrame.Parent do
			local t = TweenService:Create(scanLine, TweenInfo.new(1, Enum.EasingStyle.Linear), {
				Position = UDim2.new(0, 0, 1, 0)
			})
			t:Play()
			t.Completed:Wait()
			scanLine.Position = UDim2.new(0, 0, 0, 0)
		end
	end)

	TweenService:Create(glowRing1, TweenInfo.new(0.8, Enum.EasingStyle.Back), {
		Size = UDim2.new(0, 300, 0, 300),
		Position = UDim2.new(0.5, -150, 0.5, -150),
		BackgroundTransparency = 0.85
	}):Play()
	
	TweenService:Create(glowRing2, TweenInfo.new(0.6, Enum.EasingStyle.Back), {
		Size = UDim2.new(0, 200, 0, 200),
		Position = UDim2.new(0.5, -100, 0.5, -100),
		BackgroundTransparency = 0.75
	}):Play()

	centerBox.Size = UDim2.new(0, 70, 0, 70)
	centerBox.Position = UDim2.new(0.5, -35, 0.5, -35)
	TweenService:Create(boxStroke, TweenInfo.new(0.4), {Transparency = 0}):Play()

	TweenService:Create(introTitle, TweenInfo.new(0.4, Enum.EasingStyle.Quint), {TextTransparency = 0}):Play()
	TweenService:Create(introSub, TweenInfo.new(0.4, Enum.EasingStyle.Quint), {TextTransparency = 0}):Play()

	local startTime = tick()
	local shakeConn
	local currentScale = 70
	
	shakeConn = RunService.RenderStepped:Connect(function()
		if not centerBox.Parent then 
			if shakeConn then shakeConn:Disconnect() end
			return 
		end
		
		local elapsed = tick() - startTime
		if elapsed < 3.0 then
			currentScale = 70 + (elapsed * 12) 
			local offsetX = math.random(-3, 3)
			local offsetY = math.random(-3, 3)
			local randomRot = 45 + math.random(-5, 5)
			centerBox.Size = UDim2.new(0, currentScale, 0, currentScale)
			centerBox.Position = UDim2.new(0.5, -currentScale/2 + offsetX, 0.5, -currentScale/2 + offsetY)
			centerBox.Rotation = randomRot
		else
			if shakeConn then shakeConn:Disconnect() end
			
			local popTween = TweenService:Create(centerBox, TweenInfo.new(0.15, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
				Size = UDim2.new(0, 140, 0, 140),
				Position = UDim2.new(0.5, -70, 0.5, -70),
				Rotation = 45
			})
			popTween:Play()
			
			popTween.Completed:Wait()
			TweenService:Create(centerLogoText, TweenInfo.new(0.25, Enum.EasingStyle.Quint), {TextTransparency = 0}):Play()
		end
	end)

	task.wait(4.2)

	TweenService:Create(introTitle, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
	TweenService:Create(introSub, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
	TweenService:Create(centerBox, TweenInfo.new(0.4), {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)}):Play()
	TweenService:Create(centerLogoText, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
	TweenService:Create(glowRing1, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
	TweenService:Create(glowRing2, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
	TweenService:Create(introFrame, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()

	task.wait(0.5)

	TweenService:Create(frame, TweenInfo.new(0.4, Enum.EasingStyle.Back), {BackgroundTransparency = 0}):Play()
	TweenService:Create(frameStroke, TweenInfo.new(0.35), {Transparency = 0.2}):Play()
	TweenService:Create(dragBar, TweenInfo.new(0.35), {BackgroundTransparency = 0, TextTransparency = 0}):Play()
	TweenService:Create(button, TweenInfo.new(0.35), {BackgroundTransparency = 0, TextTransparency = 0}):Play()
	TweenService:Create(btnStroke, TweenInfo.new(0.35), {Transparency = 0.3}):Play()

	task.wait(0.5)
	introFrame:Destroy()
end

task.spawn(playIntro)

-- تحريك القائمة
local dragging = false
local dragInput, dragStart, startPos

dragBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch
		or input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragInput = input
		dragStart = input.Position
		startPos = frame.Position
	end
end)

dragBar.InputEnded:Connect(function(input)
	if input == dragInput then
		dragging = false
		dragInput = nil
	end
end)

UIS.InputChanged:Connect(function(input)
	if dragging and input == dragInput then
		local delta = input.Position - dragStart
		frame.Position = UDim2.new(
			startPos.X.Scale, startPos.X.Offset + delta.X,
			startPos.Y.Scale, startPos.Y.Offset + delta.Y
		)
	end
end)

local enabled = false

local function setEnabled(state)
	enabled = state
	if enabled then
		button.Text = "ON"
		TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 130, 90)}):Play()
		TweenService:Create(button, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(200, 255, 230)}):Play()
		TweenService:Create(btnStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(0, 255, 180)}):Play()
		TweenService:Create(frameStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(0, 255, 180)}):Play()
		btnGrad.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 150, 100)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 60, 40)),
		})
	else
		button.Text = "OFF"
		TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(25, 25, 35)}):Play()
		TweenService:Create(button, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(160, 160, 180)}):Play()
		TweenService:Create(btnStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(60, 60, 80)}):Play()
		TweenService:Create(frameStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(0, 255, 180)}):Play()
		btnGrad.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 35, 45)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(18, 18, 25)),
		})
	end
end

button.MouseButton1Click:Connect(function()
	button.Size = UDim2.new(1, -20, 0, 41)
	task.wait(0.05)
	button.Size = UDim2.new(1, -16, 0, 45)
	setEnabled(not enabled)
end)

-- الوظائف البرمجية الأساسية (التتبع والعدو)
local currentTarget = nil

task.spawn(function()
	while true do
		task.wait(0.1)
		if not enabled then
			currentTarget = nil
			continue
		end

		local char = player.Character
		if not char then continue end

		local root = char:FindFirstChild("HumanoidRootPart")
		if not root then continue end

		local tool = char:FindFirstChildOfClass("Tool")
		if not tool then continue end

		local myPos = root.Position
		local bestTarget = nil
		local bestDist = math.huge

		for _, v in pairs(game.Players:GetPlayers()) do
			if v == player then continue end
			if not v.Character then continue end

			local tr = v.Character:FindFirstChild("HumanoidRootPart")
			local hum = v.Character:FindFirstChild("Humanoid")

			if not tr then continue end
			if not hum then continue end
			if hum.Health <= 0 then continue end

			local d = (myPos - tr.Position).Magnitude
			if d < bestDist then
				bestDist = d
				bestTarget = v
			end
		end

		currentTarget = bestTarget
	end
end)

RunService.RenderStepped:Connect(function()
	if not enabled then return end

	local char = player.Character
	if not char then return end

	local hum = char:FindFirstChild("Humanoid")
	local root = char:FindFirstChild("HumanoidRootPart")
	if not hum or not root then return end

	local tool = char:FindFirstChildOfClass("Tool")
	if not tool then return end

	if currentTarget and currentTarget.Character then
		local targetRoot = currentTarget.Character:FindFirstChild("HumanoidRootPart")
		local targetHum = currentTarget.Character:FindFirstChild("Humanoid")
		if targetRoot and targetHum and targetHum.Health > 0 then
			local targetPos = targetRoot.Position
			hum:MoveTo(targetPos)
			if (root.Position - targetPos).Magnitude < 2 then
				hum:MoveTo(targetPos + targetRoot.CFrame.LookVector * 2)
			end
		end
	end
end)
