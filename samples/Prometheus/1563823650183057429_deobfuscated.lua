-- This file was generated at discord.gg/syncrypt

local game_ = game
local t1 = {
	value1 = "GetService",
	value3 = 12834712622936
}

t1.value1 = game_:GetService("CoreGui")

local TweenService = game:GetService("TweenService")

t1.value3 = "\191!\129\1\180\1931\215\228\164\200\24\5r\152\253"
t1.value4 = 18063688655067
t1.value2 = "game"

local t2 = {
	value1 = TweenService
}

t1.value2 = game:GetService("UserInputService")
t2.value2 = t1.value2
t2.value3 = game:GetService("RunService")
t2.value4 = game:GetService("Players")
t2.value5 = true
t2.value6 = nil
t2.value7 = false
t2.value8 = 5
t2.value9 = false
t2.value10 = 5
t2.value11 = false
t2.value12 = false

if t1.value1:FindFirstChild("NatsuHxPro") then
	t1.value1.NatsuHxPro:Destroy()
end

t2.value13 = {
	Background = Color3.fromRGB(12, 12, 14),
	Sidebar = Color3.fromRGB(16, 16, 18),
	Accent = Color3.fromRGB(255, 45, 60),
	AccentDark = Color3.fromRGB(150, 20, 30),
	Text = Color3.fromRGB(240, 240, 240),
	TextDim = Color3.fromRGB(150, 150, 150),
	Element = Color3.fromRGB(22, 22, 25),
	ElementHover = Color3.fromRGB(30, 30, 35),
	NeonCyan = Color3.fromRGB(0, 210, 255),
	NeonMagenta = Color3.fromRGB(180, 40, 255),
	Snow = Color3.fromRGB(245, 250, 255)
}

local GothamBlack = Enum.Font.GothamBlack
local Gotham = Enum.Font.Gotham
local Code = Enum.Font.Code
local GothamBold = Enum.Font.GothamBold

function t2.value14(p1, p2)
	local instance = Instance.new(p1)

	for k, v in pairs(p2 or {}) do
		instance[k] = v
	end

	return instance
end
function t2.value15(p3, p4, p5, p6, p7)
	local Quart = p6 or Enum.EasingStyle.Quart
	local Out = p7 or Enum.EasingDirection.Out
	local tween = t2.value1:Create(p3, TweenInfo.new(p5 or 0.3, Quart, Out), p4)

	tween:Play()

	return tween
end
function t2.value16(p8, p9)
	local Frame = t2.value14("Frame", {
		Parent = p8,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 0.6,
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(0.5, 0.5)
	})

	t2.value14("UICorner", {
		CornerRadius = UDim.new(1, 0),
		Parent = Frame
	})

	local v16 = p9.Position.X - p8.AbsolutePosition.X
	local v17 = p9.Position.Y - p8.AbsolutePosition.Y

	Frame.Position = UDim2.new(0, v16, 0, v17)

	local X = p8.AbsoluteSize.X
	local Y = p8.AbsoluteSize.Y
	local v20 = math.max(X, Y) * 1.5

	Frame.Size = UDim2.new(0, 0, 0, 0)
	t2.value15(Frame, {
		Size = UDim2.new(0, v20, 0, v20),
		BackgroundTransparency = 1
	}, 0.5, Enum.EasingStyle.Sine).Completed:Connect(function()
		Frame:Destroy()
	end)
end

local value14 = t2.value14
local Sibling = Enum.ZIndexBehavior.Sibling

t2.value17 = value14("ScreenGui", {
	Name = "NatsuHxPro",
	Parent = t1.value1,
	ZIndexBehavior = Sibling,
	ResetOnSpawn = false
})
t2.value18 = t2.value14("TextButton", {
	Name = "ToggleBtn",
	Parent = t2.value17,
	BackgroundColor3 = t2.value13.Background,
	Position = UDim2.new(1, -160, 1, -80),
	Size = UDim2.new(0, 130, 0, 42),
	Font = Enum.Font.GothamSemibold,
	Text = "    NATSUHX",
	TextColor3 = t2.value13.Accent,
	TextSize = 14,
	Visible = false,
	Active = true,
	Draggable = true,
	ZIndex = 50
})
t2.value14("UICorner", {
	CornerRadius = UDim.new(1, 0),
	Parent = t2.value18
})
t2.value14("UIStroke", {
	Color = t2.value13.Accent,
	Thickness = 1.5,
	Transparency = 0.5,
	Parent = t2.value18
})
t2.value14("ImageLabel", {
	Parent = t2.value18,
	Size = UDim2.new(0, 24, 0, 24),
	Position = UDim2.new(0, 12, 0.5, -12),
	BackgroundTransparency = 1,
	Image = "rbxassetid://122416526756475"
})
t2.value19 = t2.value14("Frame", {
	Name = "LoadFrame",
	Parent = t2.value17,
	BackgroundColor3 = t2.value13.Background,
	Size = UDim2.new(0, 320, 0, 180),
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.new(0.5, 0, 0.5, 0),
	ClipsDescendants = true
})
t2.value14("UICorner", {
	CornerRadius = UDim.new(0, 8),
	Parent = t2.value19
})
t2.value20 = t2.value14("UIStroke", {
	Color = t2.value13.Accent,
	Thickness = 1,
	Transparency = 0.4,
	Parent = t2.value19
})
t2.value21 = t2.value14("Frame", {
	Parent = t2.value19,
	Size = UDim2.new(0, 56, 0, 56),
	Position = UDim2.new(0.5, -28, 0, 7),
	BackgroundTransparency = 1,
	ZIndex = 1
})
t2.value14("UICorner", {
	CornerRadius = UDim.new(1, 0),
	Parent = t2.value21
})

local UIStroke = t2.value14("UIStroke", {
	Color = Color3.fromRGB(255, 255, 255),
	Thickness = 2.5,
	Parent = t2.value21
})

t2.value14("UIGradient", {
	Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, t2.value13.Accent), ColorSequenceKeypoint.new(1, t2.value13.NeonCyan) }),
	Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1) }),
	Parent = UIStroke
})
t2.value22 = t2.value3.RenderStepped:Connect(function()
	local value21 = t2.value21

	if value21 then
		value21 = t2.value21.Parent
	end

	if not value21 then
		return
	end

	t2.value21.Rotation = t2.value21.Rotation + 5
end)
t2.value14("ImageLabel", {
	Parent = t2.value19,
	Size = UDim2.new(0, 40, 0, 40),
	Position = UDim2.new(0.5, -20, 0, 15),
	BackgroundTransparency = 1,
	Image = "rbxassetid://122416526756475",
	ZIndex = 2
})
t2.value14("TextLabel", {
	Parent = t2.value19,
	BackgroundTransparency = 1,
	Position = UDim2.new(0, 0, 0, 65),
	Size = UDim2.new(1, 0, 0, 30),
	Font = Enum.Font.GothamBlack,
	Text = "NATSUHX",
	TextColor3 = t2.value13.Text,
	TextSize = 22
})
t2.value14("TextLabel", {
	Parent = t2.value19,
	BackgroundTransparency = 1,
	Position = UDim2.new(0, 0, 0, 90),
	Size = UDim2.new(1, 0, 0, 20),
	Font = Enum.Font.Gotham,
	Text = "[BETA 1.0]",
	TextColor3 = t2.value13.Accent,
	TextSize = 11
})
t2.value23 = t2.value14("TextLabel", {
	Parent = t2.value19,
	BackgroundTransparency = 1,
	Position = UDim2.new(0, 0, 1, -55),
	Size = UDim2.new(1, 0, 0, 20),
	Font = Enum.Font.Gotham,
	Text = "Bypassing Anticheat...",
	TextColor3 = t2.value13.TextDim,
	TextSize = 12
})

local Frame = t2.value14("Frame", {
	Parent = t2.value19,
	BackgroundColor3 = t2.value13.Element,
	Position = UDim2.new(0.15, 0, 1, -30),
	Size = UDim2.new(0.7, 0, 0, 4),
	BorderSizePixel = 0
})

t2.value24 = t2.value14("Frame", {
	Parent = Frame,
	BackgroundColor3 = t2.value13.Accent,
	Size = UDim2.new(0, 0, 1, 0),
	BorderSizePixel = 0
})
t2.value14("UIGradient", {
	Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, t2.value13.Accent), ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 100, 100)) }),
	Parent = t2.value24
})
t2.value25 = t2.value14("CanvasGroup", {
	Name = "MainContainer",
	Parent = t2.value17,
	BackgroundColor3 = t2.value13.Background,
	Size = UDim2.new(0, 650, 0, 400),
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.new(0.5, 0, 0.5, 0),
	Visible = false,
	GroupTransparency = 1
})
t2.value14("UICorner", {
	CornerRadius = UDim.new(0, 10),
	Parent = t2.value25
})
t2.value14("UIStroke", {
	Color = t2.value13.Accent,
	Thickness = 1.5,
	Transparency = 0.4,
	Parent = t2.value25
})
t2.value26 = nil
t2.value27 = nil
t2.value28 = nil
t2.value29 = nil
t2.value30 = t2.value25.Position
t2.value25.InputBegan:Connect(function(input)
	if input.UserInputType ~= Enum.UserInputType.MouseButton1 then
		return
	end

	t2.value26 = true
	t2.value28 = input.Position
	t2.value29 = t2.value25.Position
	input.Changed:Connect(function()
		if input.UserInputState ~= Enum.UserInputState.End then
			return
		end

		t2.value26 = false
	end)
end)
t2.value25.InputChanged:Connect(function(input)
	if input.UserInputType ~= Enum.UserInputType.MouseMovement then
		return
	end

	t2.value27 = input
end)
t2.value2.InputChanged:Connect(function(input)
	local value26

	if input == t2.value27 then
		value26 = t2.value26
	else
		value26 = false
	end

	if not value26 then
		return
	end

	local v27 = input.Position - t2.value28

	t2.value30 = UDim2.new(t2.value29.X.Scale, t2.value29.X.Offset + v27.X, t2.value29.Y.Scale, t2.value29.Y.Offset + v27.Y)
end)
t2.value3.RenderStepped:Connect(function()
	if not t2.value25.Visible then
		return
	end

	t2.value25.Position = t2.value25.Position:Lerp(t2.value30, 0.15)
end)
t2.value31 = t2.value14("Frame", {
	Parent = t2.value25,
	Size = UDim2.new(1, 0, 1, 0),
	BackgroundTransparency = 1,
	ZIndex = 1,
	ClipsDescendants = true
})
task.spawn(function()
	local t3 = { t2.value13.Snow, Color3.fromRGB(200, 230, 255), t2.value13.NeonCyan }

	while t2.value5 do
		if t2.value25.Visible then
			local v29 = math.random(2, 5)
			local Frame2 = t2.value14("Frame", {
				Parent = t2.value31,
				Size = UDim2.new(0, v29, 0, v29),
				Position = UDim2.new(math.random(0, 100) / 100, 0, -0.05, 0),
				BackgroundColor3 = t3[math.random(1, #t3)],
				BackgroundTransparency = math.random(20, 60) / 100,
				BorderSizePixel = 0
			})

			t2.value14("UICorner", {
				CornerRadius = UDim.new(1, 0),
				Parent = Frame2
			})

			local v31 = Frame2.Position.X.Scale + math.random(-15, 15) / 100

			t2.value15(Frame2, {
				Position = UDim2.new(v31, 0, 1.05, 0),
				BackgroundTransparency = 1
			}, math.random(3, 7), Enum.EasingStyle.Linear).Completed:Connect(function()
				Frame2:Destroy()
			end)
		end

		task.wait(0.12)
	end
end)
t2.value32 = t2.value14("Frame", {
	Parent = t2.value17,
	Size = UDim2.new(0, 300, 1, -20),
	Position = UDim2.new(1, -320, 0, 20),
	BackgroundTransparency = 1,
	ZIndex = 100
})
t2.value14("UIListLayout", {
	Parent = t2.value32,
	Padding = UDim.new(0, 10),
	VerticalAlignment = Enum.VerticalAlignment.Bottom
})

function t2.value33(p10, p11, p12)
	local Frame2 = t2.value14("Frame", {
		Parent = t2.value32,
		Size = UDim2.new(1, 0, 0, 65),
		BackgroundColor3 = t2.value13.Sidebar,
		BackgroundTransparency = 0.1,
		Position = UDim2.new(1, 50, 0, 0)
	})

	t2.value14("UICorner", {
		CornerRadius = UDim.new(0, 6),
		Parent = Frame2
	})
	t2.value14("UIStroke", {
		Color = t2.value13.Accent,
		Thickness = 1,
		Parent = Frame2
	})
	t2.value14("TextLabel", {
		Parent = Frame2,
		Size = UDim2.new(1, -20, 0, 25),
		Position = UDim2.new(0, 15, 0, 5),
		BackgroundTransparency = 1,
		Text = p10,
		Font = Enum.Font.GothamBold,
		TextColor3 = t2.value13.Accent,
		TextSize = 14,
		TextXAlignment = Enum.TextXAlignment.Left
	})
	t2.value14("TextLabel", {
		Parent = Frame2,
		Size = UDim2.new(1, -20, 0, 25),
		Position = UDim2.new(0, 15, 0, 30),
		BackgroundTransparency = 1,
		Text = p11,
		Font = Enum.Font.Gotham,
		TextColor3 = t2.value13.TextDim,
		TextSize = 12,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextWrapped = true
	})
	t2.value15(Frame2, {
		Position = UDim2.new(0, 0, 0, 0)
	}, 0.4, Enum.EasingStyle.Back)
	task.delay(p12 or 3, function()
		t2.value15(Frame2, {
			Position = UDim2.new(1, 50, 0, 0),
			BackgroundTransparency = 1
		}, 0.3).Completed:Connect(function()
			Frame2:Destroy()
		end)
	end)
end

t2.value34 = t2.value14("CanvasGroup", {
	Name = "AlertFrame",
	Parent = t2.value17,
	BackgroundColor3 = Color3.fromRGB(11, 11, 15),
	Size = UDim2.new(0, 440, 0, 380),
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.new(0.5, 0, 0.5, 0),
	Visible = false,
	GroupTransparency = 1,
	BorderSizePixel = 0,
	ZIndex = 10
})
t2.value14("UICorner", {
	CornerRadius = UDim.new(0, 14),
	Parent = t2.value34
})
t2.value35 = t2.value14("Frame", {
	Parent = t2.value34,
	Size = UDim2.new(1, 0, 1, 0),
	BackgroundTransparency = 1,
	ZIndex = 0
})
task.spawn(function()
	while t2.value5 do
		if t2.value34.Visible then
			local Frame2 = t2.value14("Frame", {
				Parent = t2.value35,
				Size = UDim2.new(0, math.random(1, 4), 0, math.random(1, 4)),
				Position = UDim2.new(math.random(0, 100) / 100, 0, -0.1, 0),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = math.random(40, 80) / 100,
				BorderSizePixel = 0
			})

			t2.value14("UICorner", {
				CornerRadius = UDim.new(1, 0),
				Parent = Frame2
			})
			t2.value15(Frame2, {
				Position = UDim2.new(Frame2.Position.X.Scale + math.random(-5, 5) / 100, 0, 1.1, 0),
				BackgroundTransparency = 1
			}, math.random(2, 5), Enum.EasingStyle.Linear).Completed:Connect(function()
				Frame2:Destroy()
			end)
		end

		task.wait(0.15)
	end
end)

local UIStroke2 = t2.value14("UIStroke", {
	Color = Color3.fromRGB(255, 255, 255),
	Thickness = 1.5,
	Transparency = 0.1,
	Parent = t2.value34
})

t2.value14("UIGradient", {
	Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, t2.value13.Accent), ColorSequenceKeypoint.new(0.5, t2.value13.NeonMagenta), ColorSequenceKeypoint.new(1, t2.value13.NeonCyan) }),
	Rotation = 45,
	Parent = UIStroke2
})
t2.value14("ImageLabel", {
	Parent = t2.value34,
	Size = UDim2.new(1, 40, 1, 40),
	Position = UDim2.new(0, -20, 0, -20),
	BackgroundTransparency = 1,
	Image = "rbxassetid://5028857484",
	ImageColor3 = t2.value13.Accent,
	ImageTransparency = 0.85,
	ZIndex = 0
})

local Frame2 = t2.value14("Frame", {
	Parent = t2.value34,
	Size = UDim2.new(0, 62, 0, 62),
	Position = UDim2.new(0.5, -31, 0, 16),
	BackgroundColor3 = Color3.fromRGB(18, 18, 24),
	BorderSizePixel = 0
})

t2.value14("UICorner", {
	CornerRadius = UDim.new(1, 0),
	Parent = Frame2
})
t2.value14("UIStroke", {
	Color = t2.value13.Accent,
	Thickness = 1.5,
	Parent = Frame2
})

local ImageLabel = t2.value14("ImageLabel", {
	Parent = Frame2,
	Size = UDim2.new(1, -6, 1, -6),
	Position = UDim2.new(0, 3, 0, 3),
	BackgroundTransparency = 1,
	Image = "rbxassetid://122416526756475"
})

t2.value14("UICorner", {
	CornerRadius = UDim.new(1, 0),
	Parent = ImageLabel
})
t2.value14("TextLabel", {
	Parent = t2.value34,
	BackgroundTransparency = 1,
	Size = UDim2.new(1, 0, 0, 24),
	Position = UDim2.new(0, 0, 0, 85),
	Font = Enum.Font.GothamBlack,
	Text = "NATSUHX",
	TextColor3 = Color3.fromRGB(255, 255, 255),
	TextSize = 22
})
t2.value14("TextLabel", {
	Parent = t2.value34,
	BackgroundTransparency = 1,
	Size = UDim2.new(1, 0, 0, 16),
	Position = UDim2.new(0, 0, 0, 108),
	Font = Enum.Font.GothamBold,
	Text = "W E L C O M E   B R O",
	TextColor3 = t2.value13.Accent,
	TextSize = 10,
	TextTransparency = 0.1
})
t2.value36 = t2.value14("Frame", {
	Parent = t2.value34,
	BackgroundColor3 = Color3.fromRGB(255, 255, 255),
	Size = UDim2.new(0.8, 0, 0, 2),
	Position = UDim2.new(0.1, 0, 0, 132),
	BorderSizePixel = 0
})
t2.value14("UIGradient", {
	Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(11, 11, 15)), ColorSequenceKeypoint.new(0.5, t2.value13.Accent), ColorSequenceKeypoint.new(1, Color3.fromRGB(11, 11, 15)) }),
	Parent = t2.value36
})
t2.value14("TextLabel", {
	Parent = t2.value34,
	BackgroundTransparency = 1,
	Size = UDim2.new(1, -40, 0, 130),
	Position = UDim2.new(0, 20, 0, 145),
	Font = Enum.Font.GothamMedium,
	Text = "Terima kasih telah memilih dan menggunakan NatsuHx.\nKami sangat menghargai dukungan dan kepercayaan yang telah diberikan.\nJangan lupa untuk bergabung dengan komunitas kami agar tidak ketinggalan informasi, pembaruan, dan berbagai perkembangan terbaru dari NatsuHx.\n\nThank you for choosing and using NatsuHx.\nWe highly appreciate the support and trust you have given us.\nDon\'t forget to join our community so you won\'t miss out on any info, updates, and the latest developments from NatsuHx.",
	TextColor3 = Color3.fromRGB(180, 185, 200),
	TextSize = 11,
	TextWrapped = true,
	TextYAlignment = Enum.TextYAlignment.Top,
	TextXAlignment = Enum.TextXAlignment.Center
})
t2.value37 = t2.value14("Frame", {
	Parent = t2.value34,
	BackgroundTransparency = 1,
	Size = UDim2.new(1, -32, 0, 32),
	Position = UDim2.new(0, 16, 0, 285)
})
t2.value14("UIListLayout", {
	Parent = t2.value37,
	FillDirection = Enum.FillDirection.Horizontal,
	HorizontalAlignment = Enum.HorizontalAlignment.Center,
	Padding = UDim.new(0, 8)
})

local function v37(p13, p14, p15)
	local TextButton = t2.value14("TextButton", {
		Parent = t2.value37,
		Size = UDim2.new(0, 120, 1, 0),
		BackgroundColor3 = Color3.fromRGB(18, 18, 24),
		Text = p13,
		Font = Enum.Font.GothamBold,
		TextColor3 = Color3.fromRGB(220, 225, 235),
		TextSize = 11,
		AutoButtonColor = false,
		ClipsDescendants = true
	})

	t2.value14("UICorner", {
		CornerRadius = UDim.new(0, 6),
		Parent = TextButton
	})

	local UIStroke3 = t2.value14("UIStroke", {
		Color = p15,
		Thickness = 1,
		Transparency = 0.6,
		Parent = TextButton
	})

	TextButton.MouseEnter:Connect(function()
		t2.value15(TextButton, {
			BackgroundColor3 = p15,
			TextColor3 = Color3.fromRGB(255, 255, 255)
		}, 0.2)
		t2.value15(UIStroke3, {
			Transparency = 0
		}, 0.2)
	end)
	TextButton.MouseLeave:Connect(function()
		t2.value15(TextButton, {
			BackgroundColor3 = Color3.fromRGB(18, 18, 24),
			TextColor3 = Color3.fromRGB(220, 225, 235)
		}, 0.2)
		t2.value15(UIStroke3, {
			Transparency = 0.6
		}, 0.2)
	end)
	TextButton.MouseButton1Down:Connect(function(x, y)
		t2.value16(TextButton, {
			Position = Vector3.new(x, y, 0)
		})
	end)
	TextButton.MouseButton1Click:Connect(function()
		if not setclipboard then
			return
		end

		setclipboard(p14)
		t2.value33("Copied", p13 .. " berhasil dicopy!", 3)
	end)
end

v37("Discord", "https://discord.gg/EFhPEEjknc", Color3.fromRGB(88, 101, 242))
v37("Website", "https://vvip-natsuhx.xo.je", t2.value13.NeonCyan)
v37("Donation", "https://discord.gg/EFhPEEjknc", t2.value13.Accent)
t2.value38 = t2.value14("TextButton", {
	Parent = t2.value34,
	Size = UDim2.new(1, -40, 0, 38),
	Position = UDim2.new(0, 20, 0, 325),
	BackgroundColor3 = t2.value13.Accent,
	Text = "Continue",
	Font = Enum.Font.GothamBlack,
	TextColor3 = Color3.fromRGB(255, 255, 255),
	TextSize = 13,
	AutoButtonColor = false,
	ClipsDescendants = true
})
t2.value14("UICorner", {
	CornerRadius = UDim.new(0, 8),
	Parent = t2.value38
})
t2.value38.MouseEnter:Connect(function()
	t2.value15(t2.value38, {
		BackgroundColor3 = Color3.fromRGB(255, 60, 90)
	}, 0.2)
end)
t2.value38.MouseLeave:Connect(function()
	t2.value15(t2.value38, {
		BackgroundColor3 = t2.value13.Accent
	}, 0.2)
end)
t2.value38.MouseButton1Down:Connect(function(x, y)
	t2.value16(t2.value38, {
		Position = Vector3.new(x, y, 0)
	})
end)
t2.value38.MouseButton1Click:Connect(function()
	t2.value15(t2.value34, {
		Size = UDim2.new(0, 440, 0, 350),
		GroupTransparency = 1
	}, 0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.In).Completed:Connect(function()
		t2.value34.Visible = false
		t2.value25.Visible = true
		t2.value25.Size = UDim2.new(0, 600, 0, 350)
		t2.value25.GroupTransparency = 1
		t2.value15(t2.value25, {
			Size = UDim2.new(0, 650, 0, 400),
			GroupTransparency = 0
		}, 0.4, Enum.EasingStyle.Back)
		t2.value33("NatsuHx", "Script siap digunakan! Tekan RightShift buat hide/show.", 5)
	end)
end)

local Frame3 = t2.value14("Frame", {
	Parent = t2.value25,
	BackgroundColor3 = t2.value13.Sidebar,
	Size = UDim2.new(0, 170, 1, 0),
	BorderSizePixel = 0,
	ZIndex = 2
})

t2.value14("UICorner", {
	CornerRadius = UDim.new(0, 10),
	Parent = Frame3
})
t2.value14("Frame", {
	Parent = Frame3,
	BackgroundColor3 = t2.value13.Sidebar,
	Size = UDim2.new(0, 20, 1, 0),
	Position = UDim2.new(1, -20, 0, 0),
	BorderSizePixel = 0,
	ZIndex = 2
})
t2.value39 = t2.value14("Frame", {
	Parent = Frame3,
	BackgroundColor3 = t2.value13.Accent,
	Size = UDim2.new(0, 2, 1, 0),
	Position = UDim2.new(1, 0, 0, 0),
	BorderSizePixel = 0,
	BackgroundTransparency = 0,
	ZIndex = 3
})

local Frame4 = t2.value14("Frame", {
	Parent = Frame3,
	Size = UDim2.new(1, 0, 1, 0),
	BackgroundTransparency = 1,
	ZIndex = 4
})

t2.value14("UIPadding", {
	Parent = Frame4,
	PaddingTop = UDim.new(0, 25),
	PaddingBottom = UDim.new(0, 20),
	PaddingLeft = UDim.new(0, 15),
	PaddingRight = UDim.new(0, 15)
})
t2.value14("ImageLabel", {
	Parent = Frame4,
	Size = UDim2.new(0, 28, 0, 28),
	Position = UDim2.new(0, 0, 0, -3),
	BackgroundTransparency = 1,
	Image = "rbxassetid://122416526756475"
})
t2.value40 = t2.value14("TextLabel", {
	Parent = Frame4,
	BackgroundTransparency = 1,
	Position = UDim2.new(0, 35, 0, 0),
	Size = UDim2.new(1, -35, 0, 22),
	Font = Enum.Font.GothamBlack,
	Text = "NATSUHX",
	TextColor3 = t2.value13.Text,
	TextSize = 18,
	TextXAlignment = Enum.TextXAlignment.Left
})
t2.value14("UIGradient", {
	Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, t2.value13.Text), ColorSequenceKeypoint.new(1, t2.value13.Accent) }),
	Parent = t2.value40
})
t2.value14("TextLabel", {
	Parent = Frame4,
	BackgroundTransparency = 1,
	Position = UDim2.new(0, 0, 0, 26),
	Size = UDim2.new(1, 0, 0, 15),
	Font = Enum.Font.GothamBold,
	Text = "BETA 1.0",
	TextColor3 = t2.value13.Accent,
	TextSize = 11,
	TextXAlignment = Enum.TextXAlignment.Left
})
task.spawn(function()
	while t2.value5 do
		t2.value15(t2.value39, {
			BackgroundTransparency = 0.7,
			Size = UDim2.new(0, 1, 1, 0)
		}, 1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
		t2.value15(t2.value36, {
			BackgroundTransparency = 0.8
		}, 1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
		t2.value15(t2.value40, {
			TextTransparency = 0.3
		}, 1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
		task.wait(1)
		t2.value15(t2.value39, {
			BackgroundTransparency = 0,
			Size = UDim2.new(0, 2, 1, 0)
		}, 1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
		t2.value15(t2.value36, {
			BackgroundTransparency = 0
		}, 1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
		t2.value15(t2.value40, {
			TextTransparency = 0
		}, 1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
		task.wait(1)
	end
end)
t2.value41 = t2.value14("Frame", {
	Parent = Frame4,
	Size = UDim2.new(1, 0, 1, -110),
	Position = UDim2.new(0, 0, 0, 55),
	BackgroundTransparency = 1
})
t2.value14("UIListLayout", {
	Parent = t2.value41,
	Padding = UDim.new(0, 6),
	HorizontalAlignment = Enum.HorizontalAlignment.Center
})
t2.value42 = t2.value14("TextButton", {
	Parent = Frame4,
	Size = UDim2.new(1, 0, 0, 40),
	Position = UDim2.new(0, 0, 1, -40),
	BackgroundColor3 = t2.value13.Element,
	AutoButtonColor = false,
	Text = "",
	ClipsDescendants = true
})
t2.value14("UICorner", {
	CornerRadius = UDim.new(0, 8),
	Parent = t2.value42
})
t2.value14("ImageLabel", {
	Parent = Frame4,
	Size = UDim2.new(0, 22, 0, 22),
	Position = UDim2.new(0, 12, 1, -29),
	BackgroundTransparency = 1,
	Image = "rbxassetid://14757659556",
	ImageColor3 = Color3.fromRGB(88, 101, 242),
	ZIndex = 5
})
t2.value14("TextLabel", {
	Parent = Frame4,
	Size = UDim2.new(1, -45, 0, 40),
	Position = UDim2.new(0, 42, 1, -40),
	BackgroundTransparency = 1,
	Text = "Discord",
	Font = Enum.Font.GothamSemibold,
	TextColor3 = t2.value13.Text,
	TextSize = 13,
	TextXAlignment = Enum.TextXAlignment.Left,
	ZIndex = 5
})
t2.value42.MouseEnter:Connect(function()
	t2.value15(t2.value42, {
		BackgroundColor3 = t2.value13.ElementHover
	}, 0.2)
end)
t2.value42.MouseLeave:Connect(function()
	t2.value15(t2.value42, {
		BackgroundColor3 = t2.value13.Element
	}, 0.2)
end)
t2.value42.MouseButton1Down:Connect(function(x, y)
	t2.value16(t2.value42, {
		Position = Vector3.new(x, y, 0)
	})
end)
t2.value42.MouseButton1Click:Connect(function()
	if not setclipboard then
		return
	end

	setclipboard("https://discord.gg/EFhPEEjknc")
	t2.value33("Discord", "Link Discord Copy!", 3)
end)
t2.value43 = t2.value14("Frame", {
	Parent = t2.value25,
	Size = UDim2.new(1, -171, 1, 0),
	Position = UDim2.new(0, 171, 0, 0),
	BackgroundTransparency = 1,
	ZIndex = 2
})

local Frame5 = t2.value14("Frame", {
	Parent = t2.value25,
	BackgroundTransparency = 1,
	Size = UDim2.new(1, 0, 0, 30),
	ZIndex = 5
})
local TextButton = t2.value14("TextButton", {
	Parent = Frame5,
	Size = UDim2.new(0, 30, 0, 30),
	Position = UDim2.new(1, -65, 0, 5),
	BackgroundTransparency = 1,
	Text = "-",
	Font = Enum.Font.GothamBold,
	TextColor3 = t2.value13.TextDim,
	TextSize = 20
})
local TextButton2 = t2.value14("TextButton", {
	Parent = Frame5,
	Size = UDim2.new(0, 30, 0, 30),
	Position = UDim2.new(1, -35, 0, 5),
	BackgroundTransparency = 1,
	Text = "X",
	Font = Enum.Font.GothamBold,
	TextColor3 = t2.value13.Accent,
	TextSize = 16
})

local function v45(p16, p17, p18, p19, p20, p21)
	local Frame6 = t2.value14("Frame", {
		Parent = p16,
		Size = UDim2.new(1, 0, 0, 50),
		BackgroundColor3 = t2.value13.Element,
		BorderSizePixel = 0
	})

	t2.value14("UICorner", {
		CornerRadius = UDim.new(0, 8),
		Parent = Frame6
	})
	t2.value14("TextLabel", {
		Parent = Frame6,
		Size = UDim2.new(1, -20, 0, 20),
		Position = UDim2.new(0, 15, 0, 5),
		BackgroundTransparency = 1,
		Text = p17,
		Font = Enum.Font.GothamMedium,
		TextColor3 = t2.value13.Text,
		TextSize = 13,
		TextXAlignment = Enum.TextXAlignment.Left
	})

	local TextLabel = t2.value14("TextLabel", {
		Parent = Frame6,
		Size = UDim2.new(0, 50, 0, 20),
		Position = UDim2.new(1, -65, 0, 5),
		BackgroundTransparency = 1,
		Text = tostring(p20),
		Font = Enum.Font.GothamBold,
		TextColor3 = t2.value13.Accent,
		TextSize = 13,
		TextXAlignment = Enum.TextXAlignment.Right
	})
	local TextButton3 = t2.value14("TextButton", {
		Parent = Frame6,
		Size = UDim2.new(1, -30, 0, 6),
		Position = UDim2.new(0, 15, 0, 32),
		BackgroundColor3 = Color3.fromRGB(40, 40, 45),
		AutoButtonColor = false,
		Text = ""
	})

	t2.value14("UICorner", {
		CornerRadius = UDim.new(1, 0),
		Parent = TextButton3
	})

	local v49 = (p20 - p18) / (p19 - p18)
	local Frame7 = t2.value14("Frame", {
		Parent = TextButton3,
		Size = UDim2.new(v49, 0, 1, 0),
		BackgroundColor3 = t2.value13.Accent,
		BorderSizePixel = 0
	})

	t2.value14("UICorner", {
		CornerRadius = UDim.new(1, 0),
		Parent = Frame7
	})

	local Frame8 = t2.value14("Frame", {
		Parent = Frame7,
		Size = UDim2.new(0, 12, 0, 12),
		Position = UDim2.new(1, -6, 0.5, -6),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BorderSizePixel = 0
	})

	t2.value14("UICorner", {
		CornerRadius = UDim.new(1, 0),
		Parent = Frame8
	})

	local u52 = false

	local function v53(p22)
		local v54 = (p22.Position.X - TextButton3.AbsolutePosition.X) / TextButton3.AbsoluteSize.X
		local v55 = math.clamp(v54, 0, 1)
		local v56 = p18 + v55 * (p19 - p18)
		local v57 = math.floor(v56)

		t2.value15(Frame7, {
			Size = UDim2.new(v55, 0, 1, 0)
		}, 0.1)
		TextLabel.Text = tostring(v57)

		if not p21 then
			return
		end

		p21(v57)
	end

	TextButton3.InputBegan:Connect(function(input)
		if not (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
			return
		end

		u52 = true
		v53(input)
	end)
	t2.value2.InputEnded:Connect(function(input)
		if not (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
			return
		end

		u52 = false
	end)
	t2.value2.InputChanged:Connect(function(input)
		local v58 = u52

		if v58 then
			v58 = input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch
		end

		if not v58 then
			return
		end

		v53(input)
	end)
end

t2.value44 = {}

local function v59(p23, p24, p25)
	local Frame6 = t2.value14("Frame", {
		Parent = p23,
		Size = UDim2.new(1, 0, 0, 42),
		BackgroundColor3 = t2.value13.Element,
		BorderSizePixel = 0
	})

	t2.value14("UICorner", {
		CornerRadius = UDim.new(0, 8),
		Parent = Frame6
	})
	t2.value14("TextLabel", {
		Parent = Frame6,
		Size = UDim2.new(1, -70, 1, 0),
		Position = UDim2.new(0, 15, 0, 0),
		BackgroundTransparency = 1,
		Text = p24,
		Font = Enum.Font.GothamMedium,
		TextColor3 = t2.value13.Text,
		TextSize = 14,
		TextXAlignment = Enum.TextXAlignment.Left
	})

	local TextButton3 = t2.value14("TextButton", {
		Parent = Frame6,
		Size = UDim2.new(0, 44, 0, 22),
		Position = UDim2.new(1, -59, 0.5, -11),
		BackgroundColor3 = Color3.fromRGB(40, 40, 45),
		Text = "",
		AutoButtonColor = false
	})

	t2.value14("UICorner", {
		CornerRadius = UDim.new(1, 0),
		Parent = TextButton3
	})

	local Frame7 = t2.value14("Frame", {
		Parent = TextButton3,
		Size = UDim2.new(0, 18, 0, 18),
		Position = UDim2.new(0, 2, 0.5, -9),
		BackgroundColor3 = t2.value13.TextDim
	})

	t2.value14("UICorner", {
		CornerRadius = UDim.new(1, 0),
		Parent = Frame7
	})

	local u63 = false

	TextButton3.MouseButton1Click:Connect(function()
		u63 = not u63

		if u63 then
			t2.value15(TextButton3, {
				BackgroundColor3 = t2.value13.Accent
			}, 0.25)
			t2.value15(Frame7, {
				Position = UDim2.new(1, -20, 0.5, -9),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			}, 0.25, Enum.EasingStyle.Back)
		else
			t2.value15(TextButton3, {
				BackgroundColor3 = Color3.fromRGB(40, 40, 45)
			}, 0.25)
			t2.value15(Frame7, {
				Position = UDim2.new(0, 2, 0.5, -9),
				BackgroundColor3 = t2.value13.TextDim
			}, 0.25, Enum.EasingStyle.Back)
		end

		if not p25 then
			return
		end

		p25(u63)
	end)
end

t2.value45 = {}
t2.value46 = nil

local function v64(p26, p27, p28)
	local TextButton3 = t2.value14("TextButton", {
		Parent = p26,
		Size = UDim2.new(1, 0, 0, 40),
		BackgroundColor3 = t2.value13.Element,
		Text = p27,
		Font = Enum.Font.GothamMedium,
		TextColor3 = t2.value13.Text,
		TextSize = 14,
		AutoButtonColor = false,
		ClipsDescendants = true
	})

	t2.value14("UICorner", {
		CornerRadius = UDim.new(0, 8),
		Parent = TextButton3
	})
	TextButton3.MouseEnter:Connect(function()
		t2.value15(TextButton3, {
			BackgroundColor3 = t2.value13.ElementHover
		}, 0.2)
	end)
	TextButton3.MouseLeave:Connect(function()
		t2.value15(TextButton3, {
			BackgroundColor3 = t2.value13.Element
		}, 0.2)
	end)
	TextButton3.MouseButton1Down:Connect(function(x, y)
		t2.value16(TextButton3, {
			Position = Vector3.new(x, y, 0)
		})
	end)
	TextButton3.MouseButton1Click:Connect(function()
		if not p28 then
			return
		end

		p28()
	end)
end
local function v66(p29, p30)
	local ScrollingFrame = t2.value14("ScrollingFrame", {
		Parent = t2.value43,
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		ScrollBarThickness = 2,
		ScrollBarImageColor3 = t2.value13.Accent,
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		Visible = p30,
		CanvasSize = UDim2.new(0, 0, 0, 0)
	})

	t2.value14("UIPadding", {
		Parent = ScrollingFrame,
		PaddingTop = UDim.new(0, 35),
		PaddingBottom = UDim.new(0, 20),
		PaddingLeft = UDim.new(0, 25),
		PaddingRight = UDim.new(0, 25)
	})
	t2.value14("UIListLayout", {
		Parent = ScrollingFrame,
		Padding = UDim.new(0, 12),
		SortOrder = Enum.SortOrder.LayoutOrder
	})
	t2.value44[p29] = ScrollingFrame

	local value142 = t2.value14
	local value41 = t2.value41
	local uDim2 = UDim2.new(1, 0, 0, 36)
	local Accent = t2.value13.Accent
	local n1 = 0.85
	local v73 = p30 and n1 and n1 or 1
	local v74 = "    " .. p29
	local GothamSemibold = Enum.Font.GothamSemibold
	local Accent2

	if p30 then
		Accent2 = t2.value13.Accent
	else
		Accent2 = p30
	end

	local TextButton3 = value142("TextButton", {
		Parent = value41,
		Size = uDim2,
		BackgroundColor3 = Accent,
		BackgroundTransparency = v73,
		Text = v74,
		Font = GothamSemibold,
		TextColor3 = Accent2 or t2.value13.TextDim,
		TextSize = 13,
		TextXAlignment = Enum.TextXAlignment.Left,
		AutoButtonColor = false,
		ClipsDescendants = true
	})

	t2.value14("UICorner", {
		CornerRadius = UDim.new(0, 6),
		Parent = TextButton3
	})

	local Frame6 = t2.value14("Frame", {
		Parent = TextButton3,
		BackgroundColor3 = t2.value13.Accent,
		Size = UDim2.new(0, 3, 0.5, 0),
		Position = UDim2.new(0, 6, 0.25, 0),
		BorderSizePixel = 0,
		BackgroundTransparency = p30 and 0 or 1
	})

	t2.value14("UICorner", {
		CornerRadius = UDim.new(1, 0),
		Parent = Frame6
	})
	t2.value45[p29] = {
		Btn = TextButton3,
		Ind = Frame6
	}
	TextButton3.MouseEnter:Connect(function()
		if t2.value46 == p29 then
			return
		end

		t2.value15(TextButton3, {
			TextColor3 = t2.value13.Text
		}, 0.2)
	end)
	TextButton3.MouseLeave:Connect(function()
		if t2.value46 == p29 then
			return
		end

		t2.value15(TextButton3, {
			TextColor3 = t2.value13.TextDim
		}, 0.2)
	end)
	TextButton3.MouseButton1Down:Connect(function(x, y)
		t2.value16(TextButton3, {
			Position = Vector3.new(x, y, 0)
		})
	end)
	TextButton3.MouseButton1Click:Connect(function()
		if t2.value46 == p29 then
			return
		end

		if not t2.value46 then
			t2.value15(TextButton3, {
				BackgroundTransparency = 0.85,
				TextColor3 = t2.value13.Accent
			}, 0.3)
			t2.value15(Frame6, {
				BackgroundTransparency = 0
			}, 0.3)
			ScrollingFrame.Position = UDim2.new(0, -20, 0, 0)
			ScrollingFrame.Visible = true
			t2.value15(ScrollingFrame, {
				Position = UDim2.new(0, 0, 0, 0)
			}, 0.3)

			return
		end

		t2.value15(t2.value45[t2.value46].Btn, {
			BackgroundTransparency = 1,
			TextColor3 = t2.value13.TextDim
		}, 0.2)
		t2.value15(t2.value45[t2.value46].Ind, {
			BackgroundTransparency = 1
		}, 0.2)

		local v79 = t2.value44[t2.value46]

		t2.value15(v79, {
			Position = UDim2.new(0, 20, 0, 0)
		}, 0.2).Completed:Connect(function()
			v79.Visible = false
		end)
		t2.value15(TextButton3, {
			BackgroundTransparency = 0.85,
			TextColor3 = t2.value13.Accent
		}, 0.3)
		t2.value15(Frame6, {
			BackgroundTransparency = 0
		}, 0.3)
		ScrollingFrame.Position = UDim2.new(0, -20, 0, 0)
		ScrollingFrame.Visible = true
		t2.value15(ScrollingFrame, {
			Position = UDim2.new(0, 0, 0, 0)
		}, 0.3)
	end)

	return ScrollingFrame
end

task.spawn(function()
	while t2.value5 do
		local Character = t2.value4.LocalPlayer.Character
		local value6 = t2.value6

		if value6 then
			if Character then
				value6 = Character:FindFirstChild("Humanoid")
			else
				value6 = Character
			end
		end

		if value6 then
			Character.Humanoid.WalkSpeed = t2.value6
		end

		task.wait(0.1)
	end
end)

local autoFarm = v66("Auto Farm", true)

v66("Combat", false)

local Misc = v66("Misc", false)
local Settings = v66("Settings", false)

t2.value47 = {}
t2.value48 = {}

function t2.value49(p31)
	if p31:IsA("BasePart") then
		return p31.CFrame
	end

	if not p31:IsA("Model") then
		return nil
	end

	if p31.PrimaryPart then
		return p31.PrimaryPart.CFrame
	end

	local BasePart = p31:FindFirstChildWhichIsA("BasePart", true)

	if BasePart then
		return BasePart.CFrame
	end

	local ok, result = pcall(function()
		return p31:GetPivot()
	end)

	if ok and result then
		return result
	else
		return nil
	end
end
function t2.value50(p32)
	local v88, v89, v90 = pairs(p32:GetAttributes())

	while true do
		local v91

		v90, v91 = v88(v89, v90)

		if not v90 then
			break
		end

		local v92 = string.lower(v90)

		if string.find(v92, "dirty") or (string.find(v92, "mess") or (string.find(v92, "trash") or (string.find(v92, "clean") or string.find(v92, "wipe")))) then
			local v93 = v91 == true

			if not v93 then
				if type(v91) == "number" then
					v93 = v91 > 0
				else
					v93 = false
				end
			end

			if v93 then
				return true
			end
		end
	end

	for _, descendant in pairs(p32.GetDescendants(p32)) do
		if descendant:IsA("BoolValue") then
			local v96 = string.lower(descendant.Name)
			local v97 = string.find(v96, "dirty") or (string.find(v96, "mess") or string.find(v96, "trash"))

			if v97 then
				v97 = descendant.Value == true
			end

			if v97 then
				return true
			end
		else
			local isProximityPrompt = descendant:IsA("ProximityPrompt")

			if isProximityPrompt then
				isProximityPrompt = descendant.Enabled
			end

			if isProximityPrompt then
				local v99 = string.lower(descendant.ActionText .. " " .. descendant.ObjectText .. " " .. descendant.Name)

				if string.find(v99, "wipe") or (string.find(v99, "clean") or string.find(v99, "bersih")) then
					return true
				end
			else
				local v100 = string.lower(descendant.Name)

				if string.find(v100, "trash") or (string.find(v100, "dirty") or (string.find(v100, "mess") or (string.find(v100, "spill") or (string.find(v100, "stain") or (string.find(v100, "plate") or (string.find(v100, "cup") or (string.find(v100, "leftover") or string.find(v100, "garbage")))))))) then
					if descendant:IsA("BasePart") or (descendant:IsA("Decal") or descendant:IsA("Texture")) then
						if descendant.Transparency < 1 then
							return true
						end
					elseif descendant:IsA("Model") then
						return true
					end
				end
			end
		end
	end

	return false
end

v59(autoFarm, "Auto Cook & Finish", function(p33)
	t2.value7 = p33

	if p33 then
		return
	end

	t2.value47 = {}
end)
v45(autoFarm, "Cook Delay (Seconds)", 0, 20, 5, function(p34)
	t2.value8 = p34
end)
v59(autoFarm, "Auto Make & Finish Soda", function(p35)
	t2.value9 = p35

	if p35 then
		return
	end

	t2.value48 = {}
end)
v45(autoFarm, "Soda Delay (Seconds)", 0, 20, 5, function(p36)
	t2.value10 = p36
end)
v59(autoFarm, "Auto Mop Floor", function(p37)
	t2.value11 = p37
end)
v59(autoFarm, "Auto Clean Table", function(p38)
	t2.value12 = p38
end)
task.spawn(function()
	while t2.value5 do
		if t2.value7 then
			local function v101()
				local _INTERACTABLES = workspace:FindFirstChild("_INTERACTABLES")

				if not _INTERACTABLES then
					return
				end

				local Grill = _INTERACTABLES:FindFirstChild("Grill")

				if not Grill then
					return
				end

				local Grill_RemoteComponent = Grill:FindFirstChild("Grill_RemoteComponent")

				if not Grill_RemoteComponent then
					return
				end

				local RF = Grill_RemoteComponent:FindFirstChild("RF")

				if RF then
					RF = Grill_RemoteComponent.RF:FindFirstChild("ProcessingWorkstation/AttemptStartProcessing")
				end

				local RE = Grill_RemoteComponent:FindFirstChild("RE")

				if RE then
					RE = Grill_RemoteComponent.RE:FindFirstChild("ProcessingWorkstation/FinishProcessing")
				end

				if not (RF and RE) then
					return
				end

				task.spawn(function()
					RF:InvokeServer()
				end)

				local function v107(p39)
					local v108 = type(p39) == "string"

					if v108 then
						v108 = string.match(p39, "%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x")
					end

					if not v108 then
						return
					end

					local v109 = string.match(p39, "%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x")

					if t2.value47[v109] then
						return
					end

					t2.value47[v109] = true
					task.spawn(function()
						task.wait(t2.value8)
						RE:FireServer(v109, true)
					end)
				end

				local GetChildren = Grill.GetChildren

				for _, v in pairs(GetChildren(Grill)) do
					v107(v.Name)

					if v:IsA("StringValue") then
						v107(v.Value)
					end
				end
			end

			pcall(v101)
		end

		if t2.value9 then
			pcall(function()
				local _INTERACTABLES = workspace:FindFirstChild("_INTERACTABLES")

				if not _INTERACTABLES then
					return
				end

				local SodaMachine = _INTERACTABLES:FindFirstChild("SodaMachine")

				if not SodaMachine then
					return
				end

				local SodaMachine_RemoteComponent = SodaMachine:FindFirstChild("SodaMachine_RemoteComponent")

				if not SodaMachine_RemoteComponent then
					return
				end

				local RF = SodaMachine_RemoteComponent:FindFirstChild("RF")

				if RF then
					RF = SodaMachine_RemoteComponent.RF:FindFirstChild("ProcessingWorkstation/AttemptStartProcessing")
				end

				local RE = SodaMachine_RemoteComponent:FindFirstChild("RE")

				if RE then
					RE = SodaMachine_RemoteComponent.RE:FindFirstChild("ProcessingWorkstation/FinishProcessing")
				end

				if not (RF and RE) then
					return
				end

				task.spawn(function()
					RF:InvokeServer()
				end)

				local function v118(p40)
					local v119 = type(p40) == "string"

					if v119 then
						v119 = string.match(p40, "%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x")
					end

					if not v119 then
						return
					end

					local v120 = string.match(p40, "%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x")

					if t2.value48[v120] then
						return
					end

					t2.value48[v120] = true
					task.spawn(function()
						task.wait(t2.value10)
						RE:FireServer(v120, true)
					end)
				end

				for _, child in pairs(SodaMachine:GetChildren()) do
					v118(child.Name)

					if child:IsA("StringValue") then
						v118(child.Value)
					end
				end
			end)
		end

		task.wait(0.5)
	end
end)
task.spawn(function()
	while t2.value5 do
		local LocalPlayer = t2.value4.LocalPlayer

		if LocalPlayer then
			LocalPlayer = LocalPlayer.Character
		end

		if LocalPlayer then
			LocalPlayer = LocalPlayer:FindFirstChild("HumanoidRootPart")
		end

		if LocalPlayer then
			if t2.value11 then
				pcall(function()
					local Miscellaneous = workspace:FindFirstChild("Miscellaneous")

					if not Miscellaneous then
						return
					end

					for _, child in pairs(Miscellaneous:GetChildren()) do
						if not (t2.value11 and t2.value5) then
							return
						end

						if string.find(child.Name, "^Puddle_") then
							local Puddle_RemoteComponent = child:FindFirstChild("Puddle_RemoteComponent")
							local RF

							if Puddle_RemoteComponent then
								RF = Puddle_RemoteComponent:FindFirstChild("RF")

								if RF then
									RF = Puddle_RemoteComponent.RF:FindFirstChild("AttemptMop")
								end
							else
								RF = Puddle_RemoteComponent
							end

							if RF then
								local v129 = t2.value49(child)
								local CFrame = LocalPlayer.CFrame
								local n2, n3

								if v129 then
									LocalPlayer.CFrame = v129 + Vector3.new(0, 3, 0)
									task.wait(0.25)
									n2 = 0
									n3 = 0
								else
									n2 = 0
									n3 = 0
								end

								while true do
									local v133 = child.Parent == Miscellaneous

									if v133 then
										v133 = t2.value11

										if v133 then
											v133 = t2.value5

											if v133 then
												v133 = n3 < 15
											end
										end
									end

									if not v133 then
										break
									end

									local v134 = t2.value49(child)
									local v135

									if v134 then
										v135 = LocalPlayer
									else
										v135 = v134
									end

									if v135 then
										LocalPlayer.CFrame = v134 + Vector3.new(0, 3, 0)
									end

									pcall(function()
										RF:InvokeServer()
									end)
									n2 = n3 + 1
									task.wait(0.3)
									n3 = n2
								end

								if LocalPlayer and CFrame then
									LocalPlayer.CFrame = CFrame
									task.wait(0.15)
								end
							end
						end
					end
				end)
			end

			if t2.value12 then
				local function v136()
					local _PERSISTENT = workspace:FindFirstChild("_PERSISTENT")

					if _PERSISTENT then
						_PERSISTENT = _PERSISTENT:FindFirstChild("Tables")
					end

					if not _PERSISTENT then
						return
					end

					for _, child in pairs(_PERSISTENT:GetChildren()) do
						if not (t2.value12 and t2.value5) then
							return
						end

						local Table_RemoteComponent = child:FindFirstChild("Table_RemoteComponent")
						local RF

						if Table_RemoteComponent then
							RF = Table_RemoteComponent:FindFirstChild("RF")

							if RF then
								RF = Table_RemoteComponent.RF:FindFirstChild("AttemptWipe")
							end
						else
							RF = Table_RemoteComponent
						end

						local v142

						if RF then
							v142 = t2.value50(child)
						else
							v142 = RF
						end

						if v142 then
							local v143 = t2.value49(child)
							local CFrame = LocalPlayer.CFrame
							local n4, n5

							if v143 then
								LocalPlayer.CFrame = v143 + Vector3.new(0, 3.5, 0)
								task.wait(0.25)
								n4 = 0
								n5 = 0
							else
								n4 = 0
								n5 = 0
							end

							while true do
								local value12 = t2.value50(child)

								if value12 then
									value12 = t2.value12

									if value12 then
										value12 = t2.value5

										if value12 then
											value12 = n5 < 10
										end
									end
								end

								if not value12 then
									break
								end

								local v148 = t2.value49(child)
								local v149

								if v148 then
									v149 = LocalPlayer
								else
									v149 = v148
								end

								if v149 then
									LocalPlayer.CFrame = v148 + Vector3.new(0, 3.5, 0)
								end

								pcall(function()
									RF:InvokeServer()
								end)
								n4 = n5 + 1
								task.wait(0.3)
								n5 = n4
							end

							if LocalPlayer and CFrame then
								LocalPlayer.CFrame = CFrame
								task.wait(0.15)
							end
						end
					end
				end

				pcall(v136)
			end
		end

		task.wait(0.5)
	end
end)
v45(Misc, "Speed Player", 0, 200, 16, function(p41)
	t2.value6 = p41
end)
t2.value51 = nil
t2.value52 = false
t2.value53 = 50

function t2.value54(p42)
	local LocalPlayer = t2.value4.LocalPlayer
	local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
	local Humanoid = Character:WaitForChild("Humanoid")

	t2.value52 = p42

	if t2.value52 then
		local BodyVelocity = Instance.new("BodyVelocity")
		local BodyGyro = Instance.new("BodyGyro")

		BodyVelocity.Name = "NatsuFlyBV"
		BodyGyro.Name = "NatsuFlyBG"
		BodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
		BodyVelocity.Velocity = Vector3.zero
		BodyVelocity.Parent = HumanoidRootPart
		BodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
		BodyGyro.P = 90000
		BodyGyro.CFrame = HumanoidRootPart.CFrame
		BodyGyro.Parent = HumanoidRootPart
		Humanoid.PlatformStand = true

		local CurrentCamera = workspace.CurrentCamera

		t2.value51 = t2.value3.RenderStepped:Connect(function()
			if not (t2.value52 and HumanoidRootPart) then
				return
			end

			local vector3 = Vector3.zero

			if t2.value2:IsKeyDown(Enum.KeyCode.W) then
				vector3 = vector3 + CurrentCamera.CFrame.LookVector
			end

			if t2.value2:IsKeyDown(Enum.KeyCode.S) then
				vector3 = vector3 - CurrentCamera.CFrame.LookVector
			end

			if t2.value2:IsKeyDown(Enum.KeyCode.A) then
				vector3 = vector3 - CurrentCamera.CFrame.RightVector
			end

			if not t2.value2:IsKeyDown(Enum.KeyCode.D) then
				BodyVelocity.Velocity = vector3 * t2.value53
				BodyGyro.CFrame = CurrentCamera.CFrame

				return
			end

			vector3 = vector3 + CurrentCamera.CFrame.RightVector
			BodyVelocity.Velocity = vector3 * t2.value53
			BodyGyro.CFrame = CurrentCamera.CFrame
		end)

		return
	end

	if HumanoidRootPart:FindFirstChild("NatsuFlyBV") then
		HumanoidRootPart.NatsuFlyBV:Destroy()
	end

	if HumanoidRootPart:FindFirstChild("NatsuFlyBG") then
		HumanoidRootPart.NatsuFlyBG:Destroy()
	end

	Humanoid.PlatformStand = false

	if not t2.value51 then
		return
	end

	t2.value51:Disconnect()
end

v59(Misc, "Fly Mode", t2.value54)
v64(Misc, "Reset Character", function()
	local LocalPlayer = t2.value4.LocalPlayer
	local Character = LocalPlayer.Character

	if Character then
		Character = LocalPlayer.Character:FindFirstChild("Humanoid")
	end

	if not Character then
		return
	end

	LocalPlayer.Character.Humanoid.Health = 0
end)
v59(Settings, "Anti-Afk", function(_) end)
v64(Settings, "Unload Cheat", function()
	t2.value5 = false

	if not t2.value52 then
		task.wait(1.5)
		t2.value17:Destroy()

		return
	end

	t2.value54(false)
	task.wait(1.5)
	t2.value17:Destroy()
end)
t2.value55 = t2.value14("ImageLabel", {
	Name = "KeyGlow",
	Parent = t2.value17,
	Size = UDim2.new(0, 0, 0, 0),
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.new(0.5, 0, 0.5, 0),
	BackgroundTransparency = 1,
	Image = "rbxassetid://5028857484",
	ImageColor3 = t2.value13.Accent,
	ImageTransparency = 1,
	ZIndex = 0,
	Visible = false
})
t2.value56 = t2.value14("CanvasGroup", {
	Name = "KeyFrame",
	Parent = t2.value17,
	BackgroundColor3 = t2.value13.Background,
	Size = UDim2.new(0, 0, 0, 0),
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.new(0.5, 0, 0.5, 0),
	Visible = false,
	GroupTransparency = 1,
	BorderSizePixel = 0,
	ZIndex = 2
})
t2.value14("UICorner", {
	CornerRadius = UDim.new(0, 10),
	Parent = t2.value56
})
t2.value14("ImageLabel", {
	Parent = t2.value56,
	Size = UDim2.new(1, 0, 1, 0),
	BackgroundTransparency = 1,
	Image = "rbxassetid://2151741365",
	ImageTransparency = 0.94,
	ScaleType = Enum.ScaleType.Tile,
	TileSize = UDim2.new(0, 100, 0, 100),
	ZIndex = 0
})

local UIStroke3 = t2.value14("UIStroke", {
	Color = Color3.fromRGB(255, 255, 255),
	Thickness = 2,
	Transparency = 0,
	Parent = t2.value56
})

t2.value57 = t2.value14("UIGradient", {
	Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, t2.value13.Accent), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1, t2.value13.AccentDark) }),
	Parent = UIStroke3
})
t2.value58 = t2.value14("Frame", {
	Parent = t2.value56,
	Size = UDim2.new(1, 0, 0, 2),
	BackgroundColor3 = t2.value13.Accent,
	BackgroundTransparency = 0.6,
	BorderSizePixel = 0,
	ZIndex = 1
})
t2.value14("UIGradient", {
	Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, t2.value13.Background), ColorSequenceKeypoint.new(0.5, t2.value13.Accent), ColorSequenceKeypoint.new(1, t2.value13.Background) }),
	Parent = t2.value58
})
task.spawn(function()
	local rotation = 0

	while t2.value5 do
		local Visible = t2.value56.Visible

		if Visible then
			Visible = t2.value57
		end

		if Visible then
			local v163 = rotation + 2

			rotation = v163 >= 360 and 0 or v163
			t2.value57.Rotation = rotation
		end

		task.wait(0.02)
	end
end)
task.spawn(function()
	while t2.value5 do
		if t2.value56.Visible then
			t2.value15(t2.value58, {
				Position = UDim2.new(0, 0, 1, 0)
			}, 2.5, Enum.EasingStyle.Linear).Completed:Wait()
			t2.value58.Position = UDim2.new(0, 0, 0, 0)
		end

		task.wait(0.1)
	end
end)
t2.value59 = t2.value14("TextLabel", {
	Parent = t2.value56,
	BackgroundTransparency = 1,
	Size = UDim2.new(1, 0, 0, 40),
	Position = UDim2.new(0, 0, 0, 20),
	Font = GothamBlack,
	Text = "",
	TextColor3 = Color3.fromRGB(255, 255, 255),
	TextSize = 20,
	ZIndex = 2
})
t2.value14("TextLabel", {
	Parent = t2.value56,
	BackgroundTransparency = 1,
	Size = UDim2.new(1, 0, 0, 15),
	Position = UDim2.new(0, 0, 0, 48),
	Font = Gotham,
	Text = "Get your key at vvip-natsuhx.xo.je",
	TextColor3 = t2.value13.TextDim,
	TextSize = 12,
	ZIndex = 2
})

local Frame6 = t2.value14("Frame", {
	Parent = t2.value56,
	BackgroundColor3 = Color3.fromRGB(16, 16, 20),
	Size = UDim2.new(0.8, 0, 0, 40),
	Position = UDim2.new(0.1, 0, 0, 85),
	ZIndex = 2
})

t2.value14("UICorner", {
	CornerRadius = UDim.new(0, 6),
	Parent = Frame6
})
t2.value60 = t2.value14("UIStroke", {
	Color = t2.value13.Accent,
	Thickness = 1,
	Transparency = 0.5,
	Parent = Frame6
})
t2.value61 = t2.value14("TextBox", {
	Parent = Frame6,
	BackgroundTransparency = 1,
	Size = UDim2.new(1, -20, 1, 0),
	Position = UDim2.new(0, 10, 0, 0),
	Font = Code,
	Text = "",
	PlaceholderText = "Enter Key Here...",
	TextColor3 = Color3.fromRGB(255, 255, 255),
	PlaceholderColor3 = t2.value13.TextDim,
	TextSize = 13,
	ClearTextOnFocus = false
})
t2.value61.Focused:Connect(function()
	t2.value15(t2.value60, {
		Transparency = 0,
		Thickness = 1.5
	}, 0.2)
end)
t2.value61.FocusLost:Connect(function()
	t2.value15(t2.value60, {
		Transparency = 0.5,
		Thickness = 1
	}, 0.2)
end)
t2.value62 = t2.value14("Frame", {
	Parent = t2.value56,
	Size = UDim2.new(0.8, 0, 0, 40),
	Position = UDim2.new(0.1, 0, 0, 145),
	BackgroundColor3 = Color3.fromRGB(255, 255, 255),
	ClipsDescendants = true,
	ZIndex = 2
})
t2.value14("UICorner", {
	CornerRadius = UDim.new(0, 6),
	Parent = t2.value62
})
t2.value14("UIGradient", {
	Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, t2.value13.Accent), ColorSequenceKeypoint.new(1, t2.value13.AccentDark) }),
	Parent = t2.value62
})
t2.value63 = t2.value14("TextButton", {
	Parent = t2.value62,
	Size = UDim2.new(1, 0, 1, 0),
	BackgroundTransparency = 1,
	Text = "V E R I F Y",
	Font = GothamBold,
	TextColor3 = Color3.fromRGB(255, 255, 255),
	TextSize = 15,
	ZIndex = 3
})
t2.value63.MouseEnter:Connect(function()
	t2.value15(t2.value62, {
		BackgroundTransparency = 0.2
	}, 0.2)
end)
t2.value63.MouseLeave:Connect(function()
	t2.value15(t2.value62, {
		BackgroundTransparency = 0
	}, 0.2)
end)
t2.value64 = t2.value14("TextButton", {
	Parent = t2.value56,
	Size = UDim2.new(0.38, 0, 0, 35),
	Position = UDim2.new(0.1, 0, 0, 200),
	BackgroundColor3 = Color3.fromRGB(20, 20, 25),
	Text = "GET KEY",
	Font = GothamBold,
	TextColor3 = t2.value13.Accent,
	TextSize = 12,
	AutoButtonColor = false,
	ClipsDescendants = true,
	ZIndex = 2
})
t2.value14("UICorner", {
	CornerRadius = UDim.new(0, 6),
	Parent = t2.value64
})
t2.value14("UIStroke", {
	Color = t2.value13.Accent,
	Thickness = 1,
	Transparency = 0.4,
	Parent = t2.value64
})
t2.value64.MouseEnter:Connect(function()
	t2.value15(t2.value64, {
		BackgroundColor3 = t2.value13.Accent,
		TextColor3 = Color3.fromRGB(255, 255, 255)
	}, 0.2)
end)
t2.value64.MouseLeave:Connect(function()
	t2.value15(t2.value64, {
		BackgroundColor3 = Color3.fromRGB(20, 20, 25),
		TextColor3 = t2.value13.Accent
	}, 0.2)
end)
t2.value64.MouseButton1Click:Connect(function(p43, p44)
	t2.value16(t2.value64, {
		Position = Vector3.new(p43, p44, 0)
	})

	if not setclipboard then
		return
	end

	setclipboard("https://vvip-natsuhx.xo.je/")
	t2.value33("Link Copied", "Link website complete copy! Silakan paste di browser untuk ambil key.", 4)
end)
t2.value65 = t2.value14("TextButton", {
	Parent = t2.value56,
	Size = UDim2.new(0.38, 0, 0, 35),
	Position = UDim2.new(0.52, 0, 0, 200),
	BackgroundColor3 = Color3.fromRGB(20, 20, 25),
	Text = "DISCORD",
	Font = GothamBold,
	TextColor3 = Color3.fromRGB(88, 101, 242),
	TextSize = 12,
	AutoButtonColor = false,
	ClipsDescendants = true,
	ZIndex = 2
})
t2.value14("UICorner", {
	CornerRadius = UDim.new(0, 6),
	Parent = t2.value65
})
t2.value14("UIStroke", {
	Color = Color3.fromRGB(88, 101, 242),
	Thickness = 1,
	Transparency = 0.4,
	Parent = t2.value65
})
t2.value65.MouseEnter:Connect(function()
	t2.value15(t2.value65, {
		BackgroundColor3 = Color3.fromRGB(88, 101, 242),
		TextColor3 = Color3.fromRGB(255, 255, 255)
	}, 0.2)
end)
t2.value65.MouseLeave:Connect(function()
	t2.value15(t2.value65, {
		BackgroundColor3 = Color3.fromRGB(20, 20, 25),
		TextColor3 = Color3.fromRGB(88, 101, 242)
	}, 0.2)
end)
t2.value65.MouseButton1Click:Connect(function(p45, p46)
	t2.value16(t2.value65, {
		Position = Vector3.new(p45, p46, 0)
	})

	if not setclipboard then
		return
	end

	setclipboard("https://discord.gg/EFhPEEjknc")
	t2.value33("Link Copied", "Link Discord berhasil dicopy!", 4)
end)
t2.value63.MouseButton1Click:Connect(function(p47, p48)
	t2.value16(t2.value62, {
		Position = Vector3.new(p47, p48, 0)
	})

	local v165 = "https://webstiee.vercel.app/api/verify?key=" .. t2.value61.Text .. "&hwid=" .. game:GetService("RbxAnalyticsService"):GetClientId()
	local request_ = request or (http_request or (HttpPost or syn.request))

	if not request_ then
		t2.value33("Error", "Executor Anda tidak mendukung HTTP Requests.", 3)
		t2.value63.Text = "V E R I F Y"

		return
	end

	t2.value63.Text = "C H E C K I N G . . ."

	local ok, result = pcall(function()
		return request_({
			Url = v165,
			Method = "GET"
		})
	end)

	if not ok then
		t2.value33("Error", "Gagal menghubungi server.", 3)
		t2.value63.Text = "V E R I F Y"

		return
	end

	local ok2, result2 = pcall(function()
		return game:GetService("HttpService"):JSONDecode(result.Body)
	end)

	if not (ok2 and result2) then
		t2.value33("Error", "Server tidak merespon dengan benar.", 3)
		t2.value63.Text = "V E R I F Y"

		return
	end

	if result2.status ~= "success" then
		t2.value33("Access Denied", result2.message, 3)
		t2.value63.Text = "V E R I F Y"

		return
	end

	t2.value33("Access Granted", result2.message, 3)
	t2.value15(t2.value55, {
		ImageTransparency = 1,
		Size = UDim2.new(0, 0, 0, 0)
	}, 0.4, Enum.EasingStyle.Cubic, Enum.EasingDirection.In)
	t2.value15(t2.value56, {
		Size = UDim2.new(0, 380, 0, 2),
		GroupTransparency = 1
	}, 0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.In).Completed:Connect(function()
		t2.value56.Visible = false
		t2.value34.Size = UDim2.new(0, 0, 0, 2)
		t2.value34.GroupTransparency = 0
		t2.value34.Visible = true
		t2.value15(t2.value34, {
			Size = UDim2.new(0, 440, 0, 2)
		}, 0.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out).Completed:Connect(function()
			t2.value15(t2.value34, {
				Size = UDim2.new(0, 440, 0, 380)
			}, 0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
		end)
	end)
end)
TextButton.MouseButton1Click:Connect(function()
	t2.value25.Visible = false
	t2.value18.Visible = true
end)
TextButton2.MouseButton1Click:Connect(function()
	if not t2.value52 then
		t2.value17:Destroy()

		return
	end

	t2.value54(false)
	t2.value17:Destroy()
end)
t2.value18.MouseButton1Click:Connect(function()
	t2.value18.Visible = false
	t2.value25.Visible = true
	t2.value30 = UDim2.new(0.5, 0, 0.5, 0)
	t2.value25.Position = t2.value30
end)
t2.value2.InputBegan:Connect(function(input, gameProcessed)
	local v171 = not gameProcessed

	if v171 then
		v171 = input.KeyCode == Enum.KeyCode.RightShift
	end

	if not v171 then
		return
	end

	if t2.value25.Visible then
		t2.value25.Visible = false
		t2.value18.Visible = true

		return
	end

	t2.value18.Visible = false
	t2.value25.Visible = true
	t2.value30 = UDim2.new(0.5, 0, 0.5, 0)
	t2.value25.Position = t2.value30
end)
task.spawn(function()
	task.wait(0.5)
	t2.value15(t2.value24, {
		Size = UDim2.new(1, 0, 1, 0)
	}, 2.5, Enum.EasingStyle.Quart)
	task.wait(0.7)
	t2.value23.Text = "Injecting Core Modules..."
	task.wait(0.8)
	t2.value23.Text = "Loading NatsuHx Framework..."
	task.wait(1)
	t2.value23.Text = "Ready."
	t2.value23.TextColor3 = t2.value13.Accent
	task.wait(0.5)

	if t2.value22 then
		t2.value22:Disconnect()
	end

	local v172 = t2.value15(t2.value19, {
		BackgroundTransparency = 1
	}, 0.5)

	t2.value15(t2.value20, {
		Transparency = 1
	}, 0.5)

	local pairs_ = pairs
	local value19 = t2.value19

	for _, descendant in pairs_(value19.GetDescendants(value19)) do
		if descendant:IsA("TextLabel") then
			t2.value15(descendant, {
				TextTransparency = 1
			}, 0.5)
		elseif descendant:IsA("ImageLabel") then
			t2.value15(descendant, {
				ImageTransparency = 1
			}, 0.5)
		else
			local isFrame = descendant:IsA("Frame")

			if isFrame then
				isFrame = descendant.Name ~= "UIStroke"

				if isFrame then
					isFrame = descendant.Name ~= "UIGradient"
				end
			end

			if isFrame then
				t2.value15(descendant, {
					BackgroundTransparency = 1
				}, 0.5)
			end
		end
	end

	v172.Completed:Wait()
	t2.value19.Visible = false
	t2.value55.Visible = true
	t2.value56.Visible = true
	t2.value15(t2.value55, {
		ImageTransparency = 0.5,
		Size = UDim2.new(0, 450, 0, 300)
	}, 0.5)
	t2.value15(t2.value56, {
		Size = UDim2.new(0, 380, 0, 260),
		GroupTransparency = 0
	}, 0.5, Enum.EasingStyle.Back)
	task.spawn(function()
		t2.value59.Text = ""

		for i = 1, 18 do
			t2.value59.Text = string.sub("NATSUHX KEY SYSTEM", 1, i)
			task.wait(0.05)
		end
	end)
end)
