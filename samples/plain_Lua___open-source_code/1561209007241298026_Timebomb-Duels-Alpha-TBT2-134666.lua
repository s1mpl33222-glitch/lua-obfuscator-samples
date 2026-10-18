local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local gui = Instance.new("ScreenGui")
gui.ResetOnSpawn = false
gui.DisplayOrder = 999999
gui.IgnoreGuiInset = true
gui.Parent = player:WaitForChild("PlayerGui")

local introFrame = Instance.new("Frame")
introFrame.Size = UDim2.new(1, 0, 1, 0)
introFrame.Position = UDim2.new(0, 0, 0, 0)
introFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
introFrame.BackgroundTransparency = 0
introFrame.BorderSizePixel = 0
introFrame.ZIndex = 200
introFrame.Parent = gui

local bgGrad = Instance.new("UIGradient", introFrame)
bgGrad.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
	ColorSequenceKeypoint.new(0.45, Color3.fromRGB(255, 40, 70)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 180, 80)),
})
bgGrad.Rotation = 45
bgGrad.Enabled = false

local sound = Instance.new("Sound")
sound.SoundId = "rbxassetid://9120263997"
sound.Volume = 0.8
sound.Parent = gui

local function makeParticle(size, color, zindex)
	local p = Instance.new("Frame")
	p.Size = UDim2.new(0, size, 0, size)
	p.Position = UDim2.new(math.random(10, 90) / 100, 0, math.random(10, 90) / 100, 0)
	p.BackgroundColor3 = color
	p.BackgroundTransparency = 0.5
	p.BorderSizePixel = 0
	p.ZIndex = zindex
	p.Parent = introFrame
	Instance.new("UICorner", p).CornerRadius = UDim.new(1, 0)
	return p
end

local particles = {}
for i = 1, 12 do
	local colors = {
		Color3.fromRGB(255, 60, 80),
		Color3.fromRGB(0, 200, 100),
		Color3.fromRGB(255, 255, 255),
		Color3.fromRGB(100, 180, 255),
	}
	local p = makeParticle(math.random(4, 14), colors[math.random(1, #colors)], 201)
	table.insert(particles, p)
end

local glowOuter = Instance.new("Frame")
glowOuter.Size = UDim2.new(0, 0, 0, 0)
glowOuter.Position = UDim2.new(0.5, 0, 0.5, 0)
glowOuter.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
glowOuter.BackgroundTransparency = 0.3
glowOuter.BorderSizePixel = 0
glowOuter.ZIndex = 202
glowOuter.Parent = introFrame
Instance.new("UICorner", glowOuter).CornerRadius = UDim.new(1, 0)

local glowMid = Instance.new("Frame")
glowMid.Size = UDim2.new(0, 0, 0, 0)
glowMid.Position = UDim2.new(0.5, 0, 0.5, 0)
glowMid.BackgroundColor3 = Color3.fromRGB(255, 80, 100)
glowMid.BackgroundTransparency = 0.4
glowMid.BorderSizePixel = 0
glowMid.ZIndex = 203
glowMid.Parent = introFrame
Instance.new("UICorner", glowMid).CornerRadius = UDim.new(1, 0)

local glowInner = Instance.new("Frame")
glowInner.Size = UDim2.new(0, 0, 0, 0)
glowInner.Position = UDim2.new(0.5, 0, 0.5, 0)
glowInner.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
glowInner.BackgroundTransparency = 0
glowInner.BorderSizePixel = 0
glowInner.ZIndex = 204
glowInner.Parent = introFrame
Instance.new("UICorner", glowInner).CornerRadius = UDim.new(1, 0)

local lineTop = Instance.new("Frame")
lineTop.Size = UDim2.new(0, 0, 0, 2)
lineTop.Position = UDim2.new(0.5, 0, 0.4, 0)
lineTop.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
lineTop.BorderSizePixel = 0
lineTop.ZIndex = 205
lineTop.Parent = introFrame

local lineBottom = Instance.new("Frame")
lineBottom.Size = UDim2.new(0, 0, 0, 2)
lineBottom.Position = UDim2.new(0.5, 0, 0.62, 0)
lineBottom.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
lineBottom.BorderSizePixel = 0
lineBottom.ZIndex = 205
lineBottom.Parent = introFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 90)
titleLabel.Position = UDim2.new(0, 0, 0.5, -70)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "TBT2"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextTransparency = 1
titleLabel.ZIndex = 206
titleLabel.Parent = introFrame

local titleStroke = Instance.new("UIStroke", titleLabel)
titleStroke.Thickness = 4
titleStroke.Color = Color3.fromRGB(255, 50, 75)
titleStroke.Transparency = 1

local subLabel = Instance.new("TextLabel")
subLabel.Size = UDim2.new(1, 0, 0, 40)
subLabel.Position = UDim2.new(0, 0, 0.5, 25)
subLabel.BackgroundTransparency = 1
subLabel.Text = "He's back again"
subLabel.TextColor3 = Color3.fromRGB(160, 255, 190)
subLabel.TextScaled = true
subLabel.Font = Enum.Font.GothamBold
subLabel.TextTransparency = 1
subLabel.ZIndex = 206
subLabel.Parent = introFrame

local subStroke = Instance.new("UIStroke", subLabel)
subStroke.Thickness = 2
subStroke.Color = Color3.fromRGB(0, 200, 80)
subStroke.Transparency = 1

local byLabel = Instance.new("TextLabel")
byLabel.Size = UDim2.new(1, 0, 0, 28)
byLabel.Position = UDim2.new(0, 0, 0.5, 72)
byLabel.BackgroundTransparency = 1
byLabel.Text = "— By Flyder —"
byLabel.TextColor3 = Color3.fromRGB(255, 200, 80)
byLabel.TextScaled = true
byLabel.Font = Enum.Font.GothamBold
byLabel.TextTransparency = 1
byLabel.ZIndex = 206
byLabel.Parent = introFrame

local byStroke = Instance.new("UIStroke", byLabel)
byStroke.Thickness = 2
byStroke.Color = Color3.fromRGB(200, 100, 0)
byStroke.Transparency = 1

local scanLine = Instance.new("Frame")
scanLine.Size = UDim2.new(1, 0, 0, 3)
scanLine.Position = UDim2.new(0, 0, 0, 0)
scanLine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
scanLine.BackgroundTransparency = 0.55
scanLine.BorderSizePixel = 0
scanLine.ZIndex = 210
scanLine.Parent = introFrame

local cornerTL = Instance.new("Frame")
cornerTL.Size = UDim2.new(0, 40, 0, 40)
cornerTL.Position = UDim2.new(0, 20, 0, 20)
cornerTL.BackgroundTransparency = 1
cornerTL.BorderSizePixel = 0
cornerTL.ZIndex = 207
cornerTL.Parent = introFrame

local cornerBR = Instance.new("Frame")
cornerBR.Size = UDim2.new(0, 40, 0, 40)
cornerBR.Position = UDim2.new(1, -60, 1, -60)
cornerBR.BackgroundTransparency = 1
cornerBR.BorderSizePixel = 0
cornerBR.ZIndex = 207
cornerBR.Parent = introFrame

local function makeCornerLine(parent, isHoriz, color)
	local l = Instance.new("Frame")
	l.BackgroundColor3 = color
	l.BorderSizePixel = 0
	l.ZIndex = 207
	l.Parent = parent
	if isHoriz then
		l.Size = UDim2.new(1, 0, 0, 2)
		l.Position = UDim2.new(0, 0, 0, 0)
	else
		l.Size = UDim2.new(0, 2, 1, 0)
		l.Position = UDim2.new(0, 0, 0, 0)
	end
	return l
end

makeCornerLine(cornerTL, true, Color3.fromRGB(255, 200, 80))
makeCornerLine(cornerTL, false, Color3.fromRGB(255, 200, 80))
makeCornerLine(cornerBR, true, Color3.fromRGB(0, 200, 80))
makeCornerLine(cornerBR, false, Color3.fromRGB(0, 200, 80))

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 140, 0, 70)
frame.Position = UDim2.new(0.02, 0, 0.02, 0)
frame.BackgroundColor3 = Color3.fromRGB(15, 17, 26)
frame.BackgroundTransparency = 1
frame.BorderSizePixel = 0
frame.Parent = gui

Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 14)

local frameStroke = Instance.new("UIStroke", frame)
frameStroke.Thickness = 1.5
frameStroke.Color = Color3.fromRGB(255, 60, 80)
frameStroke.Transparency = 1

local button = Instance.new("TextButton")
button.Size = UDim2.new(1, -10, 1, -10)
button.Position = UDim2.new(0, 5, 0, 5)
button.BackgroundColor3 = Color3.fromRGB(160, 25, 45)
button.BackgroundTransparency = 1
button.Text = "OFF"
button.TextColor3 = Color3.fromRGB(255, 120, 140)
button.TextTransparency = 1
button.TextScaled = true
button.Font = Enum.Font.GothamBold
button.BorderSizePixel = 0
button.Parent = frame

Instance.new("UICorner", button).CornerRadius = UDim.new(0, 10)

local btnGrad = Instance.new("UIGradient", button)
btnGrad.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(210, 40, 65)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(90, 10, 25)),
})
btnGrad.Rotation = 135

local btnStroke = Instance.new("UIStroke", button)
btnStroke.Thickness = 1
btnStroke.Color = Color3.fromRGB(255, 80, 100)
btnStroke.Transparency = 1

local dragCircle = Instance.new("TextButton")
dragCircle.Size = UDim2.new(0, 30, 0, 30)
dragCircle.Position = UDim2.new(0.5, -15, 0, -15)
dragCircle.BackgroundColor3 = Color3.fromRGB(20, 22, 35)
dragCircle.BackgroundTransparency = 1
dragCircle.Text = "⏺"
dragCircle.TextColor3 = Color3.fromRGB(255, 80, 100)
dragCircle.TextTransparency = 1
dragCircle.TextScaled = true
dragCircle.Font = Enum.Font.GothamBold
dragCircle.BorderSizePixel = 0
dragCircle.ZIndex = 10
dragCircle.Parent = frame

Instance.new("UICorner", dragCircle).CornerRadius = UDim.new(1, 0)

local circleStroke = Instance.new("UIStroke", dragCircle)
circleStroke.Thickness = 2
circleStroke.Color = Color3.fromRGB(255, 255, 255)
circleStroke.Transparency = 1

task.spawn(function()
	while true do
		TweenService:Create(circleStroke,
			TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 0, true),
			{Transparency = 0.7}
		):Play()
		task.wait(1.6)
	end
end)

local function playIntro()
	sound:Play()

	task.spawn(function()
		for _, p in pairs(particles) do
			task.spawn(function()
				while p.Parent do
					local tx = math.random(5, 95) / 100
					local ty = math.random(5, 95) / 100
					TweenService:Create(p, TweenInfo.new(math.random(15, 35) / 10, Enum.EasingStyle.Sine), {
						Position = UDim2.new(tx, 0, ty, 0),
						BackgroundTransparency = math.random(2, 7) / 10
					}):Play()
					task.wait(math.random(15, 35) / 10)
				end
			end)
		end
	end)

	task.wait(0.1)

	bgGrad.Enabled = true
	introFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)

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
			local t = TweenService:Create(scanLine, TweenInfo.new(1.1, Enum.EasingStyle.Linear), {
				Position = UDim2.new(0, 0, 1, 0)
			})
			t:Play()
			t.Completed:Wait()
			scanLine.Position = UDim2.new(0, 0, 0, 0)
		end
	end)

	task.wait(0.25)

	TweenService:Create(glowOuter, TweenInfo.new(0.7, Enum.EasingStyle.Back), {
		Size = UDim2.new(0, 600, 0, 600),
		Position = UDim2.new(0.5, -300, 0.5, -300),
		BackgroundTransparency = 0.88
	}):Play()
	TweenService:Create(glowMid, TweenInfo.new(0.55, Enum.EasingStyle.Back), {
		Size = UDim2.new(0, 320, 0, 320),
		Position = UDim2.new(0.5, -160, 0.5, -160),
		BackgroundTransparency = 0.75
	}):Play()
	TweenService:Create(glowInner, TweenInfo.new(0.4, Enum.EasingStyle.Back), {
		Size = UDim2.new(0, 140, 0, 140),
		Position = UDim2.new(0.5, -70, 0.5, -70),
		BackgroundTransparency = 0.55
	}):Play()

	task.wait(0.45)

	TweenService:Create(lineTop, TweenInfo.new(0.4, Enum.EasingStyle.Quint), {
		Size = UDim2.new(0.82, 0, 0, 2),
		Position = UDim2.new(0.09, 0, 0.4, 0)
	}):Play()
	TweenService:Create(lineBottom, TweenInfo.new(0.4, Enum.EasingStyle.Quint), {
		Size = UDim2.new(0.82, 0, 0, 2),
		Position = UDim2.new(0.09, 0, 0.62, 0)
	}):Play()

	task.wait(0.4)

	TweenService:Create(titleLabel, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {TextTransparency = 0}):Play()
	TweenService:Create(titleStroke, TweenInfo.new(0.3), {Transparency = 0}):Play()

	task.wait(0.25)

	TweenService:Create(subLabel, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {TextTransparency = 0}):Play()
	TweenService:Create(subStroke, TweenInfo.new(0.3), {Transparency = 0}):Play()

	task.wait(0.2)

	TweenService:Create(byLabel, TweenInfo.new(0.4, Enum.EasingStyle.Quint), {TextTransparency = 0}):Play()
	TweenService:Create(byStroke, TweenInfo.new(0.4), {Transparency = 0}):Play()

	task.spawn(function()
		while byLabel.TextTransparency < 0.5 do
			TweenService:Create(byLabel, TweenInfo.new(0.9, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 0, true), {
				TextColor3 = Color3.fromRGB(255, 240, 160)
			}):Play()
			task.wait(1.8)
		end
	end)

	task.wait(1.0)

	for _ = 1, 4 do
		TweenService:Create(titleLabel, TweenInfo.new(0.05), {TextTransparency = 1}):Play()
		task.wait(0.05)
		TweenService:Create(titleLabel, TweenInfo.new(0.05), {TextTransparency = 0}):Play()
		task.wait(0.07)
	end

	task.wait(0.15)

	TweenService:Create(titleLabel, TweenInfo.new(0.28), {TextTransparency = 1}):Play()
	TweenService:Create(subLabel, TweenInfo.new(0.28), {TextTransparency = 1}):Play()
	TweenService:Create(byLabel, TweenInfo.new(0.2), {TextTransparency = 1}):Play()
	TweenService:Create(titleStroke, TweenInfo.new(0.28), {Transparency = 1}):Play()
	TweenService:Create(subStroke, TweenInfo.new(0.28), {Transparency = 1}):Play()
	TweenService:Create(byStroke, TweenInfo.new(0.2), {Transparency = 1}):Play()
	TweenService:Create(lineTop, TweenInfo.new(0.28, Enum.EasingStyle.Quint), {
		Size = UDim2.new(0, 0, 0, 2),
		Position = UDim2.new(0.5, 0, 0.4, 0)
	}):Play()
	TweenService:Create(lineBottom, TweenInfo.new(0.28, Enum.EasingStyle.Quint), {
		Size = UDim2.new(0, 0, 0, 2),
		Position = UDim2.new(0.5, 0, 0.62, 0)
	}):Play()
	TweenService:Create(glowOuter, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
	TweenService:Create(glowMid, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
	TweenService:Create(glowInner, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()

	for _, p in pairs(particles) do
		TweenService:Create(p, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
	end

	task.wait(0.3)

	TweenService:Create(introFrame, TweenInfo.new(0.55, Enum.EasingStyle.Quint), {
		BackgroundTransparency = 1
	}):Play()

	task.wait(0.35)

	TweenService:Create(frame, TweenInfo.new(0.45, Enum.EasingStyle.Back), {BackgroundTransparency = 0}):Play()
	TweenService:Create(frameStroke, TweenInfo.new(0.4), {Transparency = 0.2}):Play()
	TweenService:Create(button, TweenInfo.new(0.4), {BackgroundTransparency = 0, TextTransparency = 0}):Play()
	TweenService:Create(btnStroke, TweenInfo.new(0.4), {Transparency = 0.4}):Play()
	TweenService:Create(dragCircle, TweenInfo.new(0.4), {BackgroundTransparency = 0, TextTransparency = 0}):Play()
	TweenService:Create(circleStroke, TweenInfo.new(0.4), {Transparency = 0.3}):Play()

	task.wait(0.5)
	introFrame:Destroy()
end

task.spawn(playIntro)

local dragging = false
local dragInput, dragStart, startPos

dragCircle.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch
		or input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragInput = input
		dragStart = input.Position
		startPos = frame.Position
		TweenService:Create(dragCircle, TweenInfo.new(0.1), {
			Size = UDim2.new(0, 36, 0, 36),
			Position = UDim2.new(0.5, -18, 0, -18)
		}):Play()
	end
end)

dragCircle.InputEnded:Connect(function(input)
	if input == dragInput then
		dragging = false
		dragInput = nil
		TweenService:Create(dragCircle, TweenInfo.new(0.12), {
			Size = UDim2.new(0, 30, 0, 30),
			Position = UDim2.new(0.5, -15, 0, -15)
		}):Play()
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
		TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(20, 140, 70)}):Play()
		TweenService:Create(button, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(120, 255, 170)}):Play()
		TweenService:Create(btnStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(60, 255, 130)}):Play()
		TweenService:Create(frameStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(50, 230, 120)}):Play()
		TweenService:Create(dragCircle, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(60, 255, 130)}):Play()
		btnGrad.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 180, 85)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 70, 35)),
		})
	else
		button.Text = "OFF"
		TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(160, 25, 45)}):Play()
		TweenService:Create(button, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(255, 120, 140)}):Play()
		TweenService:Create(btnStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(255, 80, 100)}):Play()
		TweenService:Create(frameStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(255, 60, 80)}):Play()
		TweenService:Create(dragCircle, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(255, 80, 100)}):Play()
		btnGrad.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(210, 40, 65)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(90, 10, 25)),
		})
	end
end

button.MouseButton1Click:Connect(function()
	button.Size = UDim2.new(1, -14, 1, -14)
	task.wait(0.05)
	button.Size = UDim2.new(1, -10, 1, -10)
	setEnabled(not enabled)
end)

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