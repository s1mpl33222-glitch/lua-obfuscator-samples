-- This file was generated at discord.gg/syncrypt

local t2 = {
	value1 = game:GetService("TweenService"),
	value2 = game:GetService("RunService")
}
local LocalPlayer = game:GetService("Players").LocalPlayer

t2.value3 = LocalPlayer.WaitForChild(LocalPlayer, "PlayerGui")
t2.value4 = 7
t2.value5 = 0.8
t2.value6 = Color3.fromRGB(255, 80, 0)
t2.value7 = Color3.fromRGB(255, 140, 0)
t2.value8 = Color3.fromRGB(255, 180, 0)
t2.value9 = Color3.fromRGB(0, 0, 0)
t2.value10 = Color3.fromRGB(255, 255, 255)
t2.value11 = Color3.fromRGB(37, 211, 102)
t2.value12 = Instance.new("ScreenGui")
t2.value12.Name = "FloppHubIntro"
t2.value12.IgnoreGuiInset = true
t2.value12.ResetOnSpawn = false
t2.value12.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
t2.value13 = Instance.new("Frame")
t2.value13.Name = "Background"
t2.value13.Size = UDim2.new(1, 0, 1, 0)
t2.value13.BackgroundColor3 = t2.value9
t2.value13.BorderSizePixel = 0
t2.value13.Parent = t2.value12
t2.value14 = Instance.new("ViewportFrame")
t2.value14.Name = "ViewportContainer"
t2.value14.Size = UDim2.new(1, 0, 1, 0)
t2.value14.BackgroundTransparency = 1
t2.value14.BorderSizePixel = 0
t2.value14.CurrentCamera = Instance.new("Camera")
t2.value14.CurrentCamera.FieldOfView = 50
t2.value14.CurrentCamera.CFrame = CFrame.new(0, 5, 15) * CFrame.Angles(-0.17453292519943295, 0, 0)
t2.value14.Parent = t2.value12

function t2.value15()
	local Frame = Instance.new("Frame")

	Frame.Name = "TextContainer"
	Frame.Size = UDim2.new(1, 0, 0.6, 0)
	Frame.Position = UDim2.new(0, 0, 0.1, 0)
	Frame.BackgroundTransparency = 1
	Frame.Parent = t2.value14

	local t3 = {}

	for i = 1, 6 do
		local TextLabel = Instance.new("TextLabel")

		TextLabel.Name = "MainTextLayer" .. i
		TextLabel.Size = UDim2.new(1, 0, 0.8, 0)
		TextLabel.Position = UDim2.new(0, 0, 0.1, 0)
		TextLabel.BackgroundTransparency = 1
		TextLabel.Font = Enum.Font.GothamBold
		TextLabel.Text = "FloppHub Team On Top"
		TextLabel.TextSize = 70 - i * 4
		TextLabel.TextScaled = false
		TextLabel.TextWrapped = true
		TextLabel.TextColor3 = i == 1 and t2.value7 or t2.value6
		TextLabel.TextTransparency = 0.15 + i * 0.08
		TextLabel.TextStrokeTransparency = 0.3
		TextLabel.TextStrokeColor3 = t2.value9
		TextLabel.ZIndex = 15 - i
		TextLabel.TextXAlignment = Enum.TextXAlignment.Center
		TextLabel.TextYAlignment = Enum.TextYAlignment.Center

		if i == 1 then
			TextLabel.TextColor3 = t2.value8

			local UIGradient = Instance.new("UIGradient")

			UIGradient.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, t2.value8), ColorSequenceKeypoint.new(0.5, t2.value7), ColorSequenceKeypoint.new(1, t2.value6) })
			UIGradient.Rotation = 45
			UIGradient.Parent = TextLabel

			local UIStroke = Instance.new("UIStroke")

			UIStroke.Color = t2.value7
			UIStroke.Thickness = 3
			UIStroke.Transparency = 0.5
			UIStroke.Parent = TextLabel
		end

		TextLabel.Parent = Frame
		t3[i] = TextLabel
	end

	return Frame, t3
end
function t2.value16()
	local TextLabel = Instance.new("TextLabel")

	TextLabel.Name = "Subtitle"
	TextLabel.Size = UDim2.new(1, 0, 0.1, 0)
	TextLabel.Position = UDim2.new(0, 0, 0.65, 0)
	TextLabel.BackgroundTransparency = 1
	TextLabel.Font = Enum.Font.GothamMedium
	TextLabel.Text = "The #1 blox fruits script"
	TextLabel.TextSize = 28
	TextLabel.TextColor3 = t2.value10
	TextLabel.TextStrokeTransparency = 0.2
	TextLabel.TextStrokeColor3 = t2.value7
	TextLabel.TextTransparency = 0.1
	TextLabel.TextXAlignment = Enum.TextXAlignment.Center

	local TextLabel2 = Instance.new("TextLabel")

	TextLabel2.Name = "SubtitleGlow"
	TextLabel2.Size = UDim2.new(1, 0, 1, 0)
	TextLabel2.BackgroundTransparency = 1
	TextLabel2.Font = Enum.Font.GothamMedium
	TextLabel2.Text = "The #1 blox fruits script"
	TextLabel2.TextSize = 28
	TextLabel2.TextColor3 = t2.value7
	TextLabel2.TextTransparency = 0.7
	TextLabel2.ZIndex = 0
	TextLabel2.TextXAlignment = Enum.TextXAlignment.Center
	TextLabel2.Parent = TextLabel

	return TextLabel
end
function t2.value17()
	local Frame = Instance.new("Frame")

	Frame.Name = "WhatsAppMessage"
	Frame.Size = UDim2.new(0, 280, 0, 60)
	Frame.Position = UDim2.new(0.02, 0, 0.85, 0)
	Frame.BackgroundTransparency = 1
	Frame.Parent = t2.value14

	local Frame2 = Instance.new("Frame")

	Frame2.Name = "MessageBubble"
	Frame2.Size = UDim2.new(1, 0, 1, 0)
	Frame2.BackgroundColor3 = t2.value11
	Frame2.BorderSizePixel = 0

	local UICorner = Instance.new("UICorner")

	UICorner.CornerRadius = UDim.new(0, 15)
	UICorner.Parent = Frame2

	local Frame3 = Instance.new("Frame")

	Frame3.Name = "Arrow"
	Frame3.Size = UDim2.new(0, 20, 0, 20)
	Frame3.Position = UDim2.new(-0.08, 0, 0.7, 0)
	Frame3.BackgroundColor3 = t2.value11
	Frame3.BorderSizePixel = 0
	Frame3.Rotation = 45
	Frame3.Parent = Frame2

	local TextLabel = Instance.new("TextLabel")

	TextLabel.Name = "MessageText"
	TextLabel.Size = UDim2.new(0.9, 0, 0.7, 0)
	TextLabel.Position = UDim2.new(0.05, 0, 0.15, 0)
	TextLabel.BackgroundTransparency = 1
	TextLabel.Font = Enum.Font.GothamMedium
	TextLabel.Text = "Join our Discord server!"
	TextLabel.TextSize = 18
	TextLabel.TextColor3 = t2.value10
	TextLabel.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel.TextWrapped = true
	TextLabel.Parent = Frame2
	Frame2.Parent = Frame

	local TextLabel2 = Instance.new("TextLabel")

	TextLabel2.Size = UDim2.new(0, 15, 0, 15)
	TextLabel2.Position = UDim2.new(0.85, 0, 0.7, 0)
	TextLabel2.BackgroundTransparency = 1
	TextLabel2.Font = Enum.Font.GothamBold
	TextLabel2.Text = "✓✓"
	TextLabel2.TextSize = 14
	TextLabel2.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextLabel2.TextTransparency = 0.3
	TextLabel2.Parent = Frame2

	return Frame
end
function t2.value18()
	local Frame = Instance.new("Frame")

	Frame.Name = "ParticleContainer"
	Frame.Size = UDim2.new(1, 0, 1, 0)
	Frame.BackgroundTransparency = 1
	Frame.Parent = t2.value14

	for i = 1, 40 do
		local Frame2 = Instance.new("Frame")

		Frame2.Name = "Particle" .. i

		local v21 = math.random(5, 30)

		Frame2.Size = UDim2.new(0, v21, 0, v21)
		Frame2.BackgroundColor3 = Color3.fromRGB(math.random(220, 255), math.random(100, 180), math.random(0, 80))
		Frame2.BorderSizePixel = 0

		local UICorner = Instance.new("UICorner")

		UICorner.CornerRadius = UDim.new(1, 0)
		UICorner.Parent = Frame2
		Frame2.Parent = Frame
		Frame2.Position = UDim2.new(math.random(), 0, math.random(), 0)
		Frame2.BackgroundTransparency = 1
	end

	return Frame
end
function t2.value19()
	local Frame = Instance.new("Frame")

	Frame.Name = "LightningEffect"
	Frame.Size = UDim2.new(1, 0, 1, 0)
	Frame.BackgroundTransparency = 1
	Frame.Parent = t2.value14

	for i = 1, 4 do
		local Frame2 = Instance.new("Frame")

		Frame2.Name = "Bolt" .. i
		Frame2.Size = UDim2.new(0, 3, 0, math.random(250, 450))
		Frame2.BackgroundColor3 = t2.value7
		Frame2.BorderSizePixel = 0
		Frame2.Position = UDim2.new(math.random(), 0, -0.5, 0)
		Frame2.BackgroundTransparency = 0.85
		Frame2.Rotation = math.random(-35, 35)
		Frame2.Parent = Frame

		local UICorner = Instance.new("UICorner")

		UICorner.CornerRadius = UDim.new(0, 2)
		UICorner.Parent = Frame2
	end

	return Frame
end

t2.value20 = nil

function t2.value20()
	t2.value12.Parent = t2.value3

	local _, v28 = t2.value15()
	local v29 = t2.value16()
	local v30 = t2.value17()
	local v31 = t2.value18()
	local v32 = t2.value19()

	v29.Parent = t2.value14
	v30.Parent = t2.value14
	t2.value13.BackgroundTransparency = 0

	for _, v in pairs(v28) do
		v.TextTransparency = 1
		v.TextStrokeTransparency = 1
	end

	v29.TextTransparency = 1
	v29.SubtitleGlow.TextTransparency = 1
	v30.MessageBubble.BackgroundTransparency = 1
	v30.MessageBubble.MessageText.TextTransparency = 1

	local value1 = t2.value1
	local value13 = t2.value13
	local tweenInfo = TweenInfo.new(t2.value5, Enum.EasingStyle.Quad)

	value1.Create(value1, value13, tweenInfo, {
		BackgroundColor3 = Color3.fromRGB(15, 15, 15)
	}):Play()
	wait(t2.value5 * 0.3)

	for k, v in pairs(v28) do
		local v40 = nil

		local function v41()
			wait(v40)
			v.Position = UDim2.new(0, 0, 0.05 + k * 0.02, 0)

			local value12 = t2.value1
			local v43 = v
			local tweenInfoNew = TweenInfo.new
			local EasingStyle = Enum.EasingStyle

			value12.Create(value12, v43, tweenInfoNew(0.7, EasingStyle.Back, Enum.EasingDirection.Out), {
				TextTransparency = v.TextTransparency,
				TextStrokeTransparency = 0.3
			}):Play()
		end

		v40 = k * 0.08
		spawn(v41)
	end

	local function v46()
		wait(0.4)

		for _, v in pairs(v28) do
			local function v49()
				local TextSize = v.TextSize

				while t2.value12.Parent do
					t2.value1:Create(v, TweenInfo.new(0.9, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
						TextSize = TextSize + 3
					}):Play()
					wait(1.8)
				end
			end

			spawn(v49)
		end
	end

	spawn(v46)

	local function v51()
		wait(0.6)
		t2.value1:Create(v29, TweenInfo.new(0.8), {
			TextTransparency = 0.1
		}):Play()

		local value12 = t2.value1
		local SubtitleGlow = v29.SubtitleGlow
		local TweenInfo_ = TweenInfo

		value12.Create(value12, SubtitleGlow, TweenInfo_.new(0.8), {
			TextTransparency = 0.6
		}):Play()
	end

	spawn(v51)

	local function v55()
		wait(1.2)
		t2.value1:Create(v30.MessageBubble, TweenInfo.new(0.5, Enum.EasingStyle.Back), {
			BackgroundTransparency = 0
		}):Play()
		t2.value1:Create(v30.MessageBubble.MessageText, TweenInfo.new(0.5), {
			TextTransparency = 0
		}):Play()
		t2.value1:Create(v30.MessageBubble.Arrow, TweenInfo.new(0.5), {
			BackgroundTransparency = 0
		}):Play()
		wait(0.2)

		local Position = v30.Position
		local value12 = t2.value1
		local v58 = v30
		local tweenInfoNew = TweenInfo.new

		value12.Create(value12, v58, tweenInfoNew(0.3, Enum.EasingStyle.Bounce), {
			Position = UDim2.new(0.02, 0, 0.83, 0)
		}):Play()
		wait(0.3)
		t2.value1:Create(v30, TweenInfo.new(0.3), {
			Position = Position
		}):Play()
	end

	spawn(v55)

	local function v60()
		local now = tick()
		local n1 = 0.5

		while true do
			local Parent = t2.value12.Parent

			if Parent then
				Parent = tick() - now < t2.value4
			end

			if not Parent then
				return
			end

			local v64 = tick() - now
			local v65 = v64 / t2.value4
			local v66 = v31

			for k, child in pairs(v66.GetChildren(v66)) do
				if child:IsA("Frame") then
					local v69 = k * 0.35 + v65 * 18
					local math_ = math
					local v71 = v69 % (2 * 3.141592653589793)
					local v72 = 0.35 + math_.sin(v65 * 6) * 0.12
					local v73 = math.cos(v71)
					local math_2 = math
					local v75 = n1 + v73 * v72
					local v76 = 0.5 + math_2.sin(v71) * v72 * 0.6

					child.Position = UDim2.new(v75, 0, v76, 0)

					local v77 = v64 * 6 + k

					child.BackgroundTransparency = 0.2 + math.sin(v77) * 0.4
					child.Rotation = v64 * 120 + k * 25
				end
			end

			t2.value2.Heartbeat:Wait()
		end
	end

	spawn(v60)

	local function v78()
		wait(1.5)

		while t2.value12.Parent do
			for i = 1, 4 do
				local v80 = v32:FindFirstChild("Bolt" .. i)

				if v80 then
					v80.BackgroundTransparency = math.random() * 0.4 + 0.4
					v80.Position = UDim2.new(math.random(), 0, -0.3, 0)
					v80.Rotation = math.random(-40, 40)
				end
			end

			wait(0.08)
		end
	end

	spawn(v78)
	wait(t2.value4 - t2.value5 - 0.3)

	local value12 = t2.value1
	local value132 = t2.value13
	local TweenInfo_ = TweenInfo

	value12.Create(value12, value132, TweenInfo_.new(t2.value5), {
		BackgroundTransparency = 1
	}):Play()

	for _, v in pairs(v28) do
		local value14 = t2.value1
		local tweenInfo2 = TweenInfo.new(t2.value5)

		value14.Create(value14, v, tweenInfo2, {
			TextTransparency = 1,
			TextStrokeTransparency = 1
		}):Play()
	end

	t2.value1:Create(v29, TweenInfo.new(t2.value5), {
		TextTransparency = 1
	}):Play()
	t2.value1:Create(v29.SubtitleGlow, TweenInfo.new(t2.value5), {
		TextTransparency = 1
	}):Play()

	local value14 = t2.value1
	local MessageBubble = v30.MessageBubble
	local TweenInfo_2 = TweenInfo

	value14.Create(value14, MessageBubble, TweenInfo_2.new(t2.value5), {
		BackgroundTransparency = 1
	}):Play()
	t2.value1:Create(v30.MessageBubble.MessageText, TweenInfo.new(t2.value5), {
		TextTransparency = 1
	}):Play()

	for _, child in pairs(v31.GetChildren(v31)) do
		if child:IsA("Frame") then
			local value15 = t2.value1
			local TweenInfo_3 = TweenInfo

			value15.Create(value15, child, TweenInfo_3.new(t2.value5), {
				BackgroundTransparency = 1
			}):Play()
		end
	end

	wait(t2.value5)
	t2.value12:Destroy()
end

local ok, value1 = pcall(function()
	t2.value20()
end)
local t1 = {
	value2 = ok,
	value1 = value1
}

if t1.value2 then
	loadstring(game:HttpGet("https://raw.githubusercontent.com/FloppHub-Team/BloxFruits-Script/refs/heads/main/FloppBlox.lua"))()
else
	local warn_ = warn
	local value12 = t1.value1

	warn_("FloppHub Intro Error: " .. tostring(value12))
	t1.value3 = t2.value12

	local value3 = t1.value3

	if t1.value3 then
		value3 = t2.value12.Parent
	end

	if not value3 then
		return true
	end

	t2.value12:Destroy()
end

return true
