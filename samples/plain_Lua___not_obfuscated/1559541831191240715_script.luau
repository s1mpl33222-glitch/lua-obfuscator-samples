local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer

--==================================================
-- CONFIG
--==================================================

-- Main Olive Theme
local ACCENT = Color3.fromRGB(145, 155, 55)

-- Copied / Success Color
local COPIED_COLOR = Color3.fromRGB(225, 135, 45)

-- Your script / loader link
local SCRIPT_LINK = "https://discord.gg/pKS6qzcaqB"

--==================================================
-- SCREEN GUI
--==================================================

local gui = Instance.new("ScreenGui")
gui.Name = "HubUpdate"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = player:WaitForChild("PlayerGui")

--==================================================
-- MAIN CARD
--==================================================

local frame = Instance.new("Frame")

frame.Size = UDim2.fromOffset(380, 235)

-- Start slightly below center
frame.Position = UDim2.new(0.5, 0, 0.5, 40)

frame.AnchorPoint = Vector2.new(0.5, 0.5)

frame.BackgroundColor3 = Color3.fromRGB(16, 16, 21)
frame.BorderSizePixel = 0
frame.ClipsDescendants = true

frame.Parent = gui

--==================================================
-- ROUNDED CORNERS
--==================================================

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 16)
corner.Parent = frame

--==================================================
-- BACKGROUND GRADIENT
--==================================================

local gradient = Instance.new("UIGradient")

gradient.Color = ColorSequence.new({

	ColorSequenceKeypoint.new(
		0,
		Color3.fromRGB(30, 31, 25)
	),

	ColorSequenceKeypoint.new(
		0.5,
		Color3.fromRGB(19, 20, 17)
	),

	ColorSequenceKeypoint.new(
		1,
		Color3.fromRGB(10, 11, 9)
	)

})

gradient.Rotation = 135
gradient.Parent = frame

--==================================================
-- BORDER
--==================================================

local stroke = Instance.new("UIStroke")

stroke.Color = ACCENT
stroke.Transparency = 0.55
stroke.Thickness = 1.2

stroke.Parent = frame

--==================================================
-- TOP ACCENT LINE
--==================================================

local topLine = Instance.new("Frame")

topLine.Size = UDim2.new(0.55, 0, 0, 3)
topLine.Position = UDim2.new(0.225, 0, 0, 0)

topLine.BackgroundColor3 = ACCENT
topLine.BorderSizePixel = 0

topLine.Parent = frame

local topCorner = Instance.new("UICorner")
topCorner.CornerRadius = UDim.new(1, 0)
topCorner.Parent = topLine

--==================================================
-- SUBTLE TOP GLOW
--==================================================

local glow = Instance.new("Frame")

glow.Size = UDim2.fromOffset(220, 120)
glow.Position = UDim2.new(0.5, -110, 0, -75)

glow.BackgroundColor3 = ACCENT
glow.BackgroundTransparency = 0.94
glow.BorderSizePixel = 0

glow.ZIndex = 1
glow.Parent = frame

local glowCorner = Instance.new("UICorner")
glowCorner.CornerRadius = UDim.new(1, 0)
glowCorner.Parent = glow

--==================================================
-- UPDATE ICON
--==================================================

local icon = Instance.new("Frame")

icon.Size = UDim2.fromOffset(42, 42)
icon.Position = UDim2.new(0, 20, 0, 22)

icon.BackgroundColor3 = ACCENT
icon.BackgroundTransparency = 0.88
icon.BorderSizePixel = 0

icon.ZIndex = 3
icon.Parent = frame

local iconCorner = Instance.new("UICorner")
iconCorner.CornerRadius = UDim.new(0, 12)
iconCorner.Parent = icon

local iconStroke = Instance.new("UIStroke")

iconStroke.Color = ACCENT
iconStroke.Transparency = 0.55
iconStroke.Thickness = 1

iconStroke.Parent = icon

local iconText = Instance.new("TextLabel")

iconText.Size = UDim2.fromScale(1, 1)
iconText.BackgroundTransparency = 1

iconText.Text = "↑"
iconText.TextColor3 = ACCENT
iconText.TextSize = 25
iconText.Font = Enum.Font.GothamBold

iconText.ZIndex = 4
iconText.Parent = icon

--==================================================
-- TITLE
--==================================================

local title = Instance.new("TextLabel")

title.Size = UDim2.new(1, -115, 0, 30)
title.Position = UDim2.new(0, 75, 0, 20)

title.BackgroundTransparency = 1
title.Text = "SCRIPT UPDATE"

title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 21
title.TextXAlignment = Enum.TextXAlignment.Left
title.Font = Enum.Font.GothamBold

title.ZIndex = 3
title.Parent = frame

--==================================================
-- VERSION LABEL
--==================================================

local version = Instance.new("TextLabel")

version.Size = UDim2.new(1, -115, 0, 18)
version.Position = UDim2.new(0, 76, 0, 47)

version.BackgroundTransparency = 1
version.Text = "NEW VERSION AVAILABLE"

version.TextColor3 = ACCENT
version.TextSize = 10
version.TextXAlignment = Enum.TextXAlignment.Left
version.Font = Enum.Font.GothamBold

version.ZIndex = 3
version.Parent = frame

--==================================================
-- CLOSE BUTTON
--==================================================

local close = Instance.new("TextButton")

close.Size = UDim2.fromOffset(32, 32)
close.Position = UDim2.new(1, -42, 0, 14)

close.BackgroundTransparency = 1
close.Text = "×"

close.TextColor3 = Color3.fromRGB(130, 130, 140)
close.TextSize = 24
close.Font = Enum.Font.Gotham

close.AutoButtonColor = false

close.ZIndex = 5
close.Parent = frame

-- Close hover
close.MouseEnter:Connect(function()

	TweenService:Create(
		close,
		TweenInfo.new(0.15),
		{
			TextColor3 = ACCENT
		}
	):Play()

end)

close.MouseLeave:Connect(function()

	TweenService:Create(
		close,
		TweenInfo.new(0.15),
		{
			TextColor3 = Color3.fromRGB(130, 130, 140)
		}
	):Play()

end)

--==================================================
-- DESCRIPTION
--==================================================

local subtitle = Instance.new("TextLabel")

subtitle.Size = UDim2.new(1, -40, 0, 25)
subtitle.Position = UDim2.new(0, 20, 0, 78)

subtitle.BackgroundTransparency = 1
subtitle.Text = "A new script or loader is available."

subtitle.TextColor3 = Color3.fromRGB(235, 235, 240)
subtitle.TextSize = 14
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.Font = Enum.Font.GothamMedium

subtitle.ZIndex = 3
subtitle.Parent = frame

--==================================================
-- DESCRIPTION 2
--==================================================

local description = Instance.new("TextLabel")

description.Size = UDim2.new(1, -40, 0, 25)
description.Position = UDim2.new(0, 20, 0, 99)

description.BackgroundTransparency = 1
description.Text = "Copy the link below and open it in your browser."

description.TextColor3 = Color3.fromRGB(135, 135, 145)
description.TextSize = 12
description.TextXAlignment = Enum.TextXAlignment.Left
description.Font = Enum.Font.Gotham

description.ZIndex = 3
description.Parent = frame

--==================================================
-- COPY BUTTON
--==================================================

local button = Instance.new("TextButton")

button.Size = UDim2.new(1, -40, 0, 48)
button.Position = UDim2.new(0, 20, 0, 145)

button.BackgroundColor3 = ACCENT
button.BorderSizePixel = 0

button.AutoButtonColor = false
button.Text = ""

button.ZIndex = 3
button.Parent = frame

-- Rounded button
local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 10)
buttonCorner.Parent = button

--==================================================
-- BUTTON GRADIENT
--==================================================

local buttonGradient = Instance.new("UIGradient")

buttonGradient.Color = ColorSequence.new({

	ColorSequenceKeypoint.new(
		0,
		ACCENT
	),

	ColorSequenceKeypoint.new(
		1,
		ACCENT:Lerp(
			Color3.fromRGB(255, 255, 255),
			0.08
		)
	)

})

buttonGradient.Rotation = 90
buttonGradient.Parent = button

--==================================================
-- BUTTON BORDER
--==================================================

local buttonStroke = Instance.new("UIStroke")

buttonStroke.Color = Color3.fromRGB(255, 255, 255)
buttonStroke.Transparency = 0.82
buttonStroke.Thickness = 1

buttonStroke.Parent = button

--==================================================
-- BUTTON TEXT
--==================================================

local buttonText = Instance.new("TextLabel")

-- Full button size so text is perfectly centered
buttonText.Size = UDim2.fromScale(1, 1)
buttonText.Position = UDim2.fromScale(0, 0)

buttonText.BackgroundTransparency = 1

buttonText.Text = "COPY LINK SCRIPT"

buttonText.TextColor3 = Color3.fromRGB(255, 255, 255)
buttonText.TextSize = 13

buttonText.TextXAlignment = Enum.TextXAlignment.Center
buttonText.TextYAlignment = Enum.TextYAlignment.Center

buttonText.Font = Enum.Font.GothamBold

buttonText.ZIndex = 4
buttonText.Parent = button

--==================================================
-- BOTTOM INFO
--==================================================

local info = Instance.new("TextLabel")

info.Size = UDim2.new(1, -40, 0, 20)
info.Position = UDim2.new(0, 20, 1, -27)

info.BackgroundTransparency = 1

info.Text = "Make sure you are using the latest version from scriptpastebin.com."

info.TextColor3 = Color3.fromRGB(135, 135, 145)
info.TextSize = 10

info.Font = Enum.Font.Gotham
info.TextXAlignment = Enum.TextXAlignment.Center

info.ZIndex = 3
info.Parent = frame

--==================================================
-- BUTTON HOVER
--==================================================

local originalSize = button.Size
local originalPosition = button.Position

button.MouseEnter:Connect(function()

	TweenService:Create(
		button,
		TweenInfo.new(
			0.18,
			Enum.EasingStyle.Quad,
			Enum.EasingDirection.Out
		),
		{
			BackgroundColor3 =
				ACCENT:Lerp(
					Color3.fromRGB(255, 255, 255),
					0.10
				),

			Size = UDim2.new(1, -36, 0, 50),
			Position = UDim2.new(0, 18, 0, 144)
		}
	):Play()

	TweenService:Create(
		buttonStroke,
		TweenInfo.new(0.18),
		{
			Transparency = 0.55
		}
	):Play()

end)

button.MouseLeave:Connect(function()

	TweenService:Create(
		button,
		TweenInfo.new(
			0.18,
			Enum.EasingStyle.Quad,
			Enum.EasingDirection.Out
		),
		{
			BackgroundColor3 = ACCENT,

			Size = originalSize,
			Position = originalPosition
		}
	):Play()

	TweenService:Create(
		buttonStroke,
		TweenInfo.new(0.18),
		{
			Transparency = 0.82
		}
	):Play()

end)

--==================================================
-- COPY ACTION
--==================================================

button.MouseButton1Click:Connect(function()

	-- Click animation
	TweenService:Create(
		button,
		TweenInfo.new(0.08),
		{
			Size = UDim2.new(1, -42, 0, 46)
		}
	):Play()

	task.wait(0.08)

	TweenService:Create(
		button,
		TweenInfo.new(0.12),
		{
			Size = originalSize
		}
	):Play()

	-- Copy
	setclipboard(SCRIPT_LINK)

	-- Change text
	buttonText.Text = "LINK COPIED!"

	-- Change to orange
	TweenService:Create(
		button,
		TweenInfo.new(0.2),
		{
			BackgroundColor3 = COPIED_COLOR
		}
	):Play()

	-- Wait
	task.wait(1.5)

	-- Return to normal
	buttonText.Text = "COPY LINK SCRIPT"

	TweenService:Create(
		button,
		TweenInfo.new(0.2),
		{
			BackgroundColor3 = ACCENT
		}
	):Play()

end)

--==================================================
-- CLOSE ANIMATION
--==================================================

local function closeGui()

	TweenService:Create(
		frame,
		TweenInfo.new(
			0.25,
			Enum.EasingStyle.Back,
			Enum.EasingDirection.In
		),
		{
			Size = UDim2.fromOffset(340, 210),

			Position = UDim2.new(
				0.5,
				0,
				0.5,
				15
			)
		}
	):Play()

	TweenService:Create(
		stroke,
		TweenInfo.new(0.2),
		{
			Transparency = 1
		}
	):Play()

	task.wait(0.25)

	gui:Destroy()

end

close.MouseButton1Click:Connect(closeGui)

--==================================================
-- OPEN ANIMATION
--==================================================

frame.Size = UDim2.fromOffset(330, 200)

TweenService:Create(
	frame,
	TweenInfo.new(
		0.45,
		Enum.EasingStyle.Back,
		Enum.EasingDirection.Out
	),
	{
		Size = UDim2.fromOffset(380, 235),

		-- Perfect center
		Position = UDim2.new(
			0.5,
			0,
			0.5,
			0
		)
	}
):Play()

--==================================================
-- BORDER PULSE
--==================================================

task.spawn(function()

	while gui.Parent do

		TweenService:Create(
			stroke,
			TweenInfo.new(
				1.2,
				Enum.EasingStyle.Sine,
				Enum.EasingDirection.InOut
			),
			{
				Transparency = 0.75
			}
		):Play()

		task.wait(1.2)

		TweenService:Create(
			stroke,
			TweenInfo.new(
				1.2,
				Enum.EasingStyle.Sine,
				Enum.EasingDirection.InOut
			),
			{
				Transparency = 0.35
			}
		):Play()

		task.wait(1.2)

	end

end)
