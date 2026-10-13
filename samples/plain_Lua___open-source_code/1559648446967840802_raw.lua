-- // ═══════════════════════════════════════════════════════════════════
-- //   ⚡⚡⚡ SH4DOW R15 FE TALL ⚡⚡⚡ — FINAL EDITION
-- //   made by sh4dow / @give.me.robux123 the goat
-- //   Delta Executor • Zero Overflow Guaranteed
-- // ═══════════════════════════════════════════════════════════════════

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local function getSafeParent()
	if gethui then
		local ok, hui = pcall(gethui)
		if ok and hui then return hui end
	end
	if CoreGui then
		local ok = pcall(function() return CoreGui.Name end)
		if ok then return CoreGui end
	end
	return PlayerGui
end
local SafeParent = getSafeParent()

for _, g in pairs({SafeParent, PlayerGui}) do
	local old = g:FindFirstChild("Sh4dowR15Gui")
	if old then old:Destroy() end
end

local function newCorner(p, r)
	local c = Instance.new("UICorner"); c.CornerRadius = r or UDim.new(0, 8); c.Parent = p; return c
end
local function newStroke(p, c, t, tr)
	local s = Instance.new("UIStroke"); s.Color = c; s.Thickness = t or 1; s.Transparency = tr or 0; s.Parent = p; return s
end
local function newGrad(p, colors, rot)
	local g = Instance.new("UIGradient")
	local kps = {}
	for i, c in ipairs(colors) do
		table.insert(kps, ColorSequenceKeypoint.new((i-1)/(#colors-1), c))
	end
	g.Color = ColorSequence.new(kps)
	g.Rotation = rot or 0
	g.Parent = p
	return g
end

-- ═══════════════════════════════════════════════════════════════════
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Sh4dowR15Gui"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 999

pcall(function()
	if syn and syn.protect_gui then syn.protect_gui(ScreenGui)
	elseif protect_gui then protect_gui(ScreenGui) end
end)
ScreenGui.Parent = SafeParent

-- ═══════════════════════════════════════════════════════════════════
--   FENÊTRE PRINCIPALE
-- ═══════════════════════════════════════════════════════════════════
local W, H = 225, 158

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, W, 0, H)
MainFrame.Position = UDim2.new(0, 20, 0, 60)
MainFrame.BackgroundColor3 = Color3.fromRGB(6, 4, 12)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

newCorner(MainFrame, UDim.new(0, 16))

local origSize = UDim2.new(0, W, 0, H)
MainFrame.BackgroundTransparency = 1
MainFrame.Size = UDim2.new(0, 0, 0, 0)
TweenService:Create(MainFrame, TweenInfo.new(0.55, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
	Size = origSize,
	BackgroundTransparency = 0
}):Play()

local Stroke1 = newStroke(MainFrame, Color3.fromRGB(150, 90, 255), 1.5, 0.1)
local Stroke2 = newStroke(MainFrame, Color3.fromRGB(100, 150, 255), 0.6, 0.6)
local Stroke3 = newStroke(MainFrame, Color3.fromRGB(255, 100, 200), 0.4, 0.75)

local BG = newGrad(MainFrame, {
	Color3.fromRGB(30, 18, 60),
	Color3.fromRGB(10, 6, 22),
	Color3.fromRGB(28, 16, 52),
	Color3.fromRGB(12, 8, 28),
	Color3.fromRGB(30, 18, 60),
}, 45)

-- Grille de points
local DotGrid = Instance.new("Frame")
DotGrid.Size = UDim2.new(1, 0, 1, 0)
DotGrid.BackgroundTransparency = 1
DotGrid.ZIndex = 1
DotGrid.Parent = MainFrame

for x = 0, 11 do
	for y = 0, 8 do
		local d = Instance.new("Frame")
		d.Size = UDim2.new(0, 1, 0, 1)
		d.Position = UDim2.new(0, 8 + x * 18, 0, 8 + y * 18)
		d.BackgroundColor3 = Color3.fromRGB(120, 90, 200)
		d.BackgroundTransparency = 0.85
		d.BorderSizePixel = 0
		d.ZIndex = 1
		d.Parent = DotGrid
	end
end

-- Vignette
local Vignette = Instance.new("Frame")
Vignette.Size = UDim2.new(1, 0, 1, 0)
Vignette.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Vignette.BackgroundTransparency = 0.92
Vignette.BorderSizePixel = 0
Vignette.ZIndex = 2
Vignette.Parent = MainFrame
newCorner(Vignette, UDim.new(0, 16))

-- Sweep top (contenu)
local SweepTop = Instance.new("Frame")
SweepTop.Size = UDim2.new(0, 40, 0, 1)
SweepTop.Position = UDim2.new(0, 0, 0, 0)
SweepTop.BackgroundColor3 = Color3.fromRGB(220, 180, 255)
SweepTop.BorderSizePixel = 0
SweepTop.ZIndex = 10
SweepTop.Parent = MainFrame

local SweepBot = Instance.new("Frame")
SweepBot.Size = UDim2.new(0, 40, 0, 1)
SweepBot.Position = UDim2.new(1, -40, 1, -1)
SweepBot.BackgroundColor3 = Color3.fromRGB(220, 180, 255)
SweepBot.BorderSizePixel = 0
SweepBot.ZIndex = 10
SweepBot.Parent = MainFrame

task.spawn(function()
	while MainFrame.Parent do
		SweepTop.Position = UDim2.new(0, -40, 0, 0)
		SweepBot.Position = UDim2.new(1, 40, 1, -1)
		TweenService:Create(SweepTop, TweenInfo.new(2.2, Enum.EasingStyle.Linear), {
			Position = UDim2.new(1, 0, 0, 0)
		}):Play()
		TweenService:Create(SweepBot, TweenInfo.new(2.2, Enum.EasingStyle.Linear), {
			Position = UDim2.new(0, -40, 1, -1)
		}):Play()
		task.wait(2.6)
	end
end)

-- Scanline
local Scanline = Instance.new("Frame")
Scanline.Size = UDim2.new(1, 0, 0, 20)
Scanline.Position = UDim2.new(0, 0, 0, 0)
Scanline.BackgroundColor3 = Color3.fromRGB(180, 120, 255)
Scanline.BackgroundTransparency = 0.9
Scanline.BorderSizePixel = 0
Scanline.ZIndex = 3
Scanline.Parent = MainFrame

task.spawn(function()
	while Scanline.Parent do
		Scanline.Position = UDim2.new(0, 0, 0, 0)
		TweenService:Create(Scanline, TweenInfo.new(2.8, Enum.EasingStyle.Linear), {
			Position = UDim2.new(0, 0, 1, 0)
		}):Play()
		task.wait(3)
	end
end)

-- Accents
local TopAccent = Instance.new("Frame")
TopAccent.Size = UDim2.new(1, -16, 0, 2)
TopAccent.Position = UDim2.new(0, 8, 0, 0)
TopAccent.BackgroundColor3 = Color3.fromRGB(180, 120, 255)
TopAccent.BorderSizePixel = 0
TopAccent.ZIndex = 11
TopAccent.Parent = MainFrame
newCorner(TopAccent, UDim.new(1, 0))
local TopAccentGrad = newGrad(TopAccent, {
	Color3.fromRGB(255, 100, 220),
	Color3.fromRGB(120, 180, 255),
	Color3.fromRGB(180, 100, 255),
	Color3.fromRGB(255, 100, 220),
})

local BottomAccent = Instance.new("Frame")
BottomAccent.Size = UDim2.new(1, -16, 0, 1)
BottomAccent.Position = UDim2.new(0, 8, 1, -1)
BottomAccent.BackgroundColor3 = Color3.fromRGB(120, 90, 200)
BottomAccent.BackgroundTransparency = 0.5
BottomAccent.BorderSizePixel = 0
BottomAccent.ZIndex = 11
BottomAccent.Parent = MainFrame
newCorner(BottomAccent, UDim.new(1, 0))

-- Coins lumineux
local function makeCorner(pos)
	local c = Instance.new("Frame")
	c.Size = UDim2.new(0, 4, 0, 4)
	c.Position = pos
	c.BackgroundColor3 = Color3.fromRGB(200, 150, 255)
	c.BorderSizePixel = 0
	c.ZIndex = 12
	c.Parent = MainFrame
	newCorner(c, UDim.new(1, 0))
	return c
end
local C1 = makeCorner(UDim2.new(0, 5, 0, 5))
local C2 = makeCorner(UDim2.new(1, -9, 0, 5))
local C3 = makeCorner(UDim2.new(0, 5, 1, -9))
local C4 = makeCorner(UDim2.new(1, -9, 1, -9))

-- Traits d'angle
local function makeAngle(ax, ay, rx, ry)
	local f = Instance.new("Frame")
	f.Size = UDim2.new(0, 10, 0, 1)
	f.Position = UDim2.new(ax, rx, ay, ry)
	f.BackgroundColor3 = Color3.fromRGB(180, 130, 255)
	f.BackgroundTransparency = 0.4
	f.BorderSizePixel = 0
	f.ZIndex = 12
	f.Parent = MainFrame
	local f2 = Instance.new("Frame")
	f2.Size = UDim2.new(0, 1, 0, 10)
	f2.Position = UDim2.new(ax, rx, ay, ry)
	f2.BackgroundColor3 = Color3.fromRGB(180, 130, 255)
	f2.BackgroundTransparency = 0.4
	f2.BorderSizePixel = 0
	f2.ZIndex = 12
	f2.Parent = MainFrame
end
makeAngle(0, 0, 4, 4)
makeAngle(1, 0, -14, 4)
makeAngle(0, 1, 4, -14)
makeAngle(1, 1, -14, -14)

-- Animations fond
task.spawn(function()
	while MainFrame.Parent do
		TopAccentGrad.Rotation = (TopAccentGrad.Rotation + 2.5) % 360
		BG.Rotation = (BG.Rotation + 0.5) % 360
		Stroke1.Color = Color3.fromRGB(
			150 + math.sin(tick() * 2) * 40,
			90 + math.sin(tick() * 1.5) * 30,
			255
		)
		Stroke1.Transparency = 0.1 + math.sin(tick() * 3) * 0.15
		Stroke2.Transparency = 0.5 + math.sin(tick() * 2 + 1) * 0.25
		Stroke3.Transparency = 0.7 + math.sin(tick() * 2.5 + 2) * 0.2
		task.wait(0.03)
	end
end)

task.spawn(function()
	local corners = {C1, C2, C3, C4}
	local i = 0
	while MainFrame.Parent do
		i = i % 4 + 1
		local c = corners[i]
		TweenService:Create(c, TweenInfo.new(0.4), {
			BackgroundTransparency = 0, Size = UDim2.new(0, 6, 0, 6)
		}):Play()
		task.wait(0.3)
		TweenService:Create(c, TweenInfo.new(0.6), {
			BackgroundTransparency = 0.5, Size = UDim2.new(0, 3, 0, 3)
		}):Play()
		task.wait(0.3)
	end
end)

-- ═══════════════════════════════════════════════════════════════════
--   HEADER
-- ═══════════════════════════════════════════════════════════════════
local Dot = Instance.new("Frame")
Dot.Size = UDim2.new(0, 5, 0, 5)
Dot.Position = UDim2.new(0, 6, 0, 15)
Dot.BackgroundColor3 = Color3.fromRGB(150, 255, 150)
Dot.BorderSizePixel = 0
Dot.ZIndex = 13
Dot.Parent = MainFrame
newCorner(Dot, UDim.new(1, 0))

local DotRing = Instance.new("Frame")
DotRing.Size = UDim2.new(0, 5, 0, 5)
DotRing.Position = UDim2.new(0, 6, 0, 15)
DotRing.BackgroundTransparency = 1
DotRing.BorderSizePixel = 0
DotRing.ZIndex = 12
DotRing.Parent = MainFrame
newCorner(DotRing, UDim.new(1, 0))
local DotRingStroke = newStroke(DotRing, Color3.fromRGB(150, 255, 150), 1, 0.3)

task.spawn(function()
	while Dot.Parent do
		TweenService:Create(Dot, TweenInfo.new(0.8), { BackgroundTransparency = 0.6 }):Play()
		TweenService:Create(DotRingStroke, TweenInfo.new(0.8), { Transparency = 0.8 }):Play()
		task.wait(0.8)
		TweenService:Create(Dot, TweenInfo.new(0.8), { BackgroundTransparency = 0 }):Play()
		TweenService:Create(DotRingStroke, TweenInfo.new(0.8), { Transparency = 0.3 }):Play()
		task.wait(0.8)
	end
end)

local Header = Instance.new("TextLabel")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 20)
Header.Position = UDim2.new(0, 0, 0, 7)
Header.BackgroundTransparency = 1
Header.Font = Enum.Font.GothamBold
Header.Text = "made by sh4dow / @give.me.robux123 the goat"
Header.TextSize = 9
Header.TextColor3 = Color3.fromRGB(215, 195, 255)
Header.TextStrokeTransparency = 0.75
Header.TextStrokeColor3 = Color3.fromRGB(120, 80, 255)
Header.TextXAlignment = Enum.TextXAlignment.Left
Header.ZIndex = 13
Header.Parent = MainFrame

local HeaderPad = Instance.new("UIPadding")
HeaderPad.PaddingLeft = UDim.new(0, 16)
HeaderPad.Parent = Header

local HeaderGrad = Instance.new("UIGradient")
HeaderGrad.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(220, 200, 255)),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(200, 190, 255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 180, 240)),
}
HeaderGrad.Parent = Header

task.spawn(function()
	local fullText = Header.Text
	Header.Text = ""
	for i = 1, #fullText do
		Header.Text = string.sub(fullText, 1, i)
		task.wait(0.018)
	end
end)

local Divider = Instance.new("Frame")
Divider.Size = UDim2.new(0, 0, 0, 1)
Divider.Position = UDim2.new(0, 8, 0, 30)
Divider.BackgroundColor3 = Color3.fromRGB(120, 80, 255)
Divider.BackgroundTransparency = 0.5
Divider.BorderSizePixel = 0
Divider.ZIndex = 13
Divider.Parent = MainFrame

TweenService:Create(Divider, TweenInfo.new(0.8, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
	Size = UDim2.new(1, -16, 0, 1)
}):Play()

-- ═══════════════════════════════════════════════════════════════════
--   TITRE
-- ═══════════════════════════════════════════════════════════════════
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 26)
Title.Position = UDim2.new(0, 0, 0, 35)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBlack
Title.Text = "SH4DOW R15 FE TALL"
Title.TextSize = 16
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.ZIndex = 13
Title.Parent = MainFrame

local TitleGrad = Instance.new("UIGradient")
TitleGrad.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(180, 130, 255)),
	ColorSequenceKeypoint.new(0.33, Color3.fromRGB(120, 220, 255)),
	ColorSequenceKeypoint.new(0.66, Color3.fromRGB(255, 130, 220)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 130, 255)),
}
TitleGrad.Parent = Title

local TitleStroke = newStroke(Title, Color3.fromRGB(150, 90, 255), 1, 0.5)

task.spawn(function()
	while Title.Parent do
		TitleGrad.Rotation = (TitleGrad.Rotation + 2) % 360
		TitleStroke.Color = Color3.fromRGB(
			150 + math.sin(tick() * 2) * 60,
			90 + math.sin(tick() * 1.5) * 40,
			255
		)
		task.wait(0.03)
	end
end)

task.spawn(function()
	while Title.Parent do
		TweenService:Create(Title, TweenInfo.new(1.5, Enum.EasingStyle.Sine), {
			TextSize = 17
		}):Play()
		task.wait(1.5)
		TweenService:Create(Title, TweenInfo.new(1.5, Enum.EasingStyle.Sine), {
			TextSize = 16
		}):Play()
		task.wait(1.5)
	end
end)

local Sub = Instance.new("TextLabel")
Sub.Size = UDim2.new(1, 0, 0, 12)
Sub.Position = UDim2.new(0, 0, 0, 61)
Sub.BackgroundTransparency = 1
Sub.Font = Enum.Font.GothamMedium
Sub.Text = "◆ DELTA • CLICK TO EXECUTE ◆"
Sub.TextSize = 8
Sub.TextColor3 = Color3.fromRGB(150, 140, 175)
Sub.ZIndex = 13
Sub.Parent = MainFrame

local Counter = Instance.new("TextLabel")
Counter.Size = UDim2.new(1, 0, 0, 10)
Counter.Position = UDim2.new(0, 0, 0, 75)
Counter.BackgroundTransparency = 1
Counter.Font = Enum.Font.GothamMedium
Counter.Text = "runs: 0"
Counter.TextSize = 7
Counter.TextColor3 = Color3.fromRGB(120, 110, 140)
Counter.ZIndex = 13
Counter.Parent = MainFrame

-- ═══════════════════════════════════════════════════════════════════
--   BOUTON 🔥 (SANS SHINE QUI DÉBORDE)
-- ═══════════════════════════════════════════════════════════════════
local Button = Instance.new("TextButton")
Button.Name = "ExecuteButton"
Button.Size = UDim2.new(1, -28, 0, 42)
Button.Position = UDim2.new(0, 14, 1, -52)
Button.BackgroundColor3 = Color3.fromRGB(120, 80, 255)
Button.BorderSizePixel = 0
Button.Text = ""
Button.AutoButtonColor = false
Button.Active = true
Button.ClipsDescendants = true
Button.ZIndex = 14
Button.Parent = MainFrame

newCorner(Button, UDim.new(0, 10))

local BtnGrad = newGrad(Button, {
	Color3.fromRGB(170, 100, 255),
	Color3.fromRGB(90, 150, 255),
	Color3.fromRGB(210, 90, 255),
	Color3.fromRGB(150, 100, 255),
	Color3.fromRGB(90, 150, 255),
	Color3.fromRGB(170, 100, 255),
}, 0)

local BtnStroke = newStroke(Button, Color3.fromRGB(240, 210, 255), 1, 0.35)

-- ⚡ SHEEN SAFE : overlay + UIGradient transparency animée
local SheenOverlay = Instance.new("Frame")
SheenOverlay.Size = UDim2.new(1, 0, 1, 0)
SheenOverlay.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SheenOverlay.BorderSizePixel = 0
SheenOverlay.ZIndex = 4
SheenOverlay.Parent = Button
newCorner(SheenOverlay, UDim.new(0, 10))

local SheenGrad = Instance.new("UIGradient")
SheenGrad.Rotation = 15
SheenGrad.Transparency = NumberSequence.new{
	NumberSequenceKeypoint.new(0, 1),
	NumberSequenceKeypoint.new(0.35, 1),
	NumberSequenceKeypoint.new(0.48, 0.55),
	NumberSequenceKeypoint.new(0.52, 0.55),
	NumberSequenceKeypoint.new(0.65, 1),
	NumberSequenceKeypoint.new(1, 1),
}
SheenGrad.Parent = SheenOverlay

task.spawn(function()
	while SheenOverlay.Parent do
		-- Sweep de -0.5 à 1.5 puis pause
		for i = -50, 150, 3 do
			SheenGrad.Offset = Vector2.new(i / 100, 0)
			task.wait(0.02)
		end
		SheenGrad.Offset = Vector2.new(-0.5, 0)
		task.wait(1.4)
	end
end)

-- Pulse interne
local PulseOverlay = Instance.new("Frame")
PulseOverlay.Size = UDim2.new(1, 0, 1, 0)
PulseOverlay.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
PulseOverlay.BackgroundTransparency = 0.88
PulseOverlay.BorderSizePixel = 0
PulseOverlay.ZIndex = 1
PulseOverlay.Parent = Button
newCorner(PulseOverlay, UDim.new(0, 10))

task.spawn(function()
	while PulseOverlay.Parent do
		TweenService:Create(PulseOverlay, TweenInfo.new(1.4, Enum.EasingStyle.Sine), {
			BackgroundTransparency = 0.72
		}):Play()
		task.wait(1.4)
		TweenService:Create(PulseOverlay, TweenInfo.new(1.4, Enum.EasingStyle.Sine), {
			BackgroundTransparency = 0.92
		}):Play()
		task.wait(1.4)
	end
end)

-- Texte
local BtnText = Instance.new("TextLabel")
BtnText.Size = UDim2.new(1, 0, 1, 0)
BtnText.BackgroundTransparency = 1
BtnText.Font = Enum.Font.GothamBlack
BtnText.Text = "⚡ EXECUTE ⚡"
BtnText.TextSize = 14
BtnText.TextColor3 = Color3.fromRGB(255, 255, 255)
BtnText.TextStrokeTransparency = 0.3
BtnText.TextStrokeColor3 = Color3.fromRGB(50, 10, 100)
BtnText.ZIndex = 6
BtnText.Parent = Button

-- Sparkles internes
local function makeSparkle()
	local s = Instance.new("Frame")
	s.Size = UDim2.new(0, 2, 0, 2)
	s.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	s.BorderSizePixel = 0
	s.ZIndex = 5
	s.Parent = Button
	newCorner(s, UDim.new(1, 0))
	s.Position = UDim2.new(math.random(), 0, math.random(), 0)
	s.BackgroundTransparency = 1
	TweenService:Create(s, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {
		BackgroundTransparency = 0, Size = UDim2.new(0, 4, 0, 4)
	}):Play()
	task.wait(0.5)
	TweenService:Create(s, TweenInfo.new(0.5), {
		BackgroundTransparency = 1, Size = UDim2.new(0, 1, 0, 1)
	}):Play()
	task.wait(0.5)
	s:Destroy()
end

task.spawn(function()
	while Button.Parent do
		task.wait(0.35)
		for _ = 1, 2 do task.spawn(makeSparkle) end
	end
end)

task.spawn(function()
	while Button.Parent do
		BtnGrad.Rotation = (BtnGrad.Rotation + 1.8) % 360
		task.wait(0.03)
	end
end)

-- Hover
local hoverTween
local function onHover()
	if hoverTween then hoverTween:Cancel() end
	hoverTween = TweenService:Create(Button, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
		Size = UDim2.new(1, -22, 0, 45),
		Position = UDim2.new(0, 11, 1, -54),
	})
	hoverTween:Play()
	TweenService:Create(BtnStroke, TweenInfo.new(0.3), { Transparency = 0 }):Play()
end

local function offHover()
	if hoverTween then hoverTween:Cancel() end
	TweenService:Create(Button, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
		Size = UDim2.new(1, -28, 0, 42),
		Position = UDim2.new(0, 14, 1, -52),
	}):Play()
	TweenService:Create(BtnStroke, TweenInfo.new(0.3), { Transparency = 0.35 }):Play()
end

Button.MouseEnter:Connect(onHover)
Button.MouseLeave:Connect(offHover)

-- ═══════════════════════════════════════════════════════════════════
--   NOTIFICATION
-- ═══════════════════════════════════════════════════════════════════
local function notify(title, text, duration)
	duration = duration or 3
	if Delta and Delta.Notification then
		pcall(function() Delta.Notification(title, text, duration) end)
		return
	end
	local toast = Instance.new("Frame")
	toast.Size = UDim2.new(0, 0, 0, 38)
	toast.Position = UDim2.new(0, 20, 0, 20)
	toast.BackgroundColor3 = Color3.fromRGB(16, 12, 30)
	toast.BorderSizePixel = 0
	toast.ClipsDescendants = true
	toast.Parent = ScreenGui
	newCorner(toast, UDim.new(0, 10))
	newStroke(toast, Color3.fromRGB(140, 90, 255), 1, 0.3)
	newGrad(toast, { Color3.fromRGB(40, 25, 70), Color3.fromRGB(16, 12, 30) }, 45)

	local accent = Instance.new("Frame")
	accent.Size = UDim2.new(0, 3, 1, -8)
	accent.Position = UDim2.new(0, 4, 0, 4)
	accent.BackgroundColor3 = Color3.fromRGB(180, 130, 255)
	accent.BorderSizePixel = 0
	accent.Parent = toast
	newCorner(accent, UDim.new(1, 0))

	local tl = Instance.new("TextLabel")
	tl.Size = UDim2.new(1, -16, 1, 0)
	tl.Position = UDim2.new(0, 12, 0, 0)
	tl.BackgroundTransparency = 1
	tl.Font = Enum.Font.GothamBold
	tl.Text = title .. "  —  " .. text
	tl.TextSize = 10
	tl.TextColor3 = Color3.fromRGB(220, 210, 255)
	tl.TextXAlignment = Enum.TextXAlignment.Left
	tl.Parent = toast

	TweenService:Create(toast, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
		Size = UDim2.new(0, 240, 0, 38)
	}):Play()

	task.delay(duration, function()
		TweenService:Create(toast, TweenInfo.new(0.4), {
			Size = UDim2.new(0, 0, 0, 38),
			BackgroundTransparency = 1
		}):Play()
		tl:Destroy()
		task.wait(0.5)
		toast:Destroy()
	end)
end

-- ═══════════════════════════════════════════════════════════════════
--   🎯 TON SCRIPT R6 — INCHANGÉ
-- ═══════════════════════════════════════════════════════════════════
local function executeR6Script()
	local LocalPlayer = game:GetService("Players").LocalPlayer
	local Character = LocalPlayer.Character
	if not Character then return end
	local Humanoid = Character:FindFirstChildOfClass("Humanoid")
	if not Humanoid then return end

	local function rm()
		for i,v in pairs(Character:GetDescendants()) do
			if v:IsA("BasePart") then
				if v.Name == "Handle" or v.Name == "Head" then
					if Character.Head:FindFirstChild("OriginalSize") then
						Character.Head.OriginalSize:Destroy()
					end
				else
					for i,cav in pairs(v:GetDescendants()) do
						if cav:IsA("Attachment") then
							if cav:FindFirstChild("OriginalPosition") then
								cav.OriginalPosition:Destroy()
							end
						end
					end
					v:FindFirstChild("OriginalSize"):Destroy()
					if v:FindFirstChild("AvatarPartScaleType") then
						v:FindFirstChild("AvatarPartScaleType"):Destroy()
					end
				end
			end
		end
	end

	rm()
	wait(0.5)
	Humanoid:FindFirstChild("BodyProportionScale"):Destroy()
	wait(1)

	rm()
	wait(0.5)
	Humanoid:FindFirstChild("BodyHeightScale"):Destroy()
	wait(1)

	rm()
	wait(0.5)
	Humanoid:FindFirstChild("BodyWidthScale"):Destroy()
	wait(1)

	rm()
	wait(0.5)
	Humanoid:FindFirstChild("BodyDepthScale"):Destroy()
	wait(1)

	rm()
	wait(0.5)
	Humanoid:FindFirstChild("HeadScale"):Destroy()
	wait(1)

	notify("Sh4dow R15 FE Tall", "Applied ✓", 3)
end

-- ═══════════════════════════════════════════════════════════════════
--   CLICK
-- ═══════════════════════════════════════════════════════════════════
local executing = false
local runCount = 0

Button.MouseButton1Click:Connect(function()
	if executing then return end
	executing = true

	local origText = BtnText.Text
	BtnText.Text = "⏳ EXECUTING..."

	TweenService:Create(Button, TweenInfo.new(0.07), {
		Size = UDim2.new(1, -38, 0, 36),
		Position = UDim2.new(0, 19, 1, -49),
	}):Play()
	task.wait(0.07)
	TweenService:Create(Button, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
		Size = UDim2.new(1, -22, 0, 45),
		Position = UDim2.new(0, 11, 1, -54),
	}):Play()

	-- Ripples
	for i = 1, 3 do
		task.spawn(function()
			local ring = Instance.new("Frame")
			ring.Size = UDim2.new(0, 10, 0, 10)
			ring.Position = UDim2.new(0.5, -5, 0.5, -5)
			ring.BackgroundTransparency = 1
			ring.ZIndex = 9
			ring.Parent = Button
			newCorner(ring, UDim.new(1, 0))
			local rs = newStroke(ring, Color3.fromRGB(255, 255, 255), 2, 0.2)
			task.wait(i * 0.08)
			TweenService:Create(ring, TweenInfo.new(0.7, Enum.EasingStyle.Quart), {
				Size = UDim2.new(0, 60, 0, 60),
				Position = UDim2.new(0.5, -30, 0.5, -30)
			}):Play()
			TweenService:Create(rs, TweenInfo.new(0.7), { Transparency = 1 }):Play()
			task.wait(0.8)
			ring:Destroy()
		end)
	end

	-- Flash interne
	local flash = Instance.new("Frame")
	flash.Size = UDim2.new(1, 0, 1, 0)
	flash.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	flash.BackgroundTransparency = 0.6
	flash.BorderSizePixel = 0
	flash.ZIndex = 10
	flash.Parent = Button
	newCorner(flash, UDim.new(0, 10))
	TweenService:Create(flash, TweenInfo.new(0.35), { BackgroundTransparency = 1 }):Play()
	task.wait(0.4)
	flash:Destroy()

	-- Shake
	task.spawn(function()
		local orig = MainFrame.Position
		for _ = 1, 6 do
			MainFrame.Position = orig + UDim2.new(0, math.random(-3, 3), 0, math.random(-3, 3))
			task.wait(0.025)
		end
		MainFrame.Position = orig
	end)

	runCount = runCount + 1
	Counter.Text = "runs: " .. runCount
	Counter.TextColor3 = Color3.fromRGB(255, 200, 255)
	TweenService:Create(Counter, TweenInfo.new(0.6), {
		TextColor3 = Color3.fromRGB(120, 110, 140)
	}):Play()

	task.spawn(executeR6Script)

	BtnText.Text = "✓ DONE"
	task.wait(1.2)
	BtnText.Text = origText
	executing = false
end)

-- ═══════════════════════════════════════════════════════════════════
--   DRAG
-- ═══════════════════════════════════════════════════════════════════
local dragging, dragInput, dragStart, startPos
local function updateDrag(input)
	local delta = input.Position - dragStart
	MainFrame.Position = UDim2.new(
		startPos.X.Scale, startPos.X.Offset + delta.X,
		startPos.Y.Scale, startPos.Y.Offset + delta.Y
	)
end

MainFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
	or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = MainFrame.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

MainFrame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement
	or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		updateDrag(input)
	end
end)

-- ═══════════════════════════════════════════════════════════════════
task.wait(0.6)
notify("SH4DOW R15 FE TALL", "Loaded ✓", 3)
print("[SH4DOW R15 FE TALL] Loaded — made by sh4dow / @give.me.robux123 the goat")