local Players          = game:GetService("Players")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService       = game:GetService("RunService")
local Lighting         = game:GetService("Lighting")

local player    = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ── ESP STATE ────────────────────────────────────────────
local espEnabled   = false
local showNames    = true
local showHealth   = true
local showBox      = false
local showBoxESP   = false
local espMaxDist   = 300  -- max stud distance for ESP visibility
local showDistance = true
local espColor     = Color3.fromHSV(0, 1, 0.9)
local espObjects   = {}

-- ── RTX STATE ────────────────────────────────────────────
local rtxEnabled  = false
local origLighting = {
	Technology = Lighting.Technology,
	Brightness = Lighting.Brightness,
}
local origReflectance = {}

-- ── SCREEN GUI ───────────────────────────────────────────
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ColorSliderGui"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui


-- ── BG BOX ───────────────────────────────────────────────
local bgBox = Instance.new("Frame")
bgBox.Name = "BgBox"
bgBox.Size = UDim2.new(0, 300, 0, 486)
bgBox.Position = UDim2.new(0.633, 0, 0.084, 0)
bgBox.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
bgBox.BorderSizePixel = 0
bgBox.Active = true
bgBox.Draggable = false
bgBox.ZIndex = 5
bgBox.Parent = screenGui
Instance.new("UICorner", bgBox).CornerRadius = UDim.new(0, 10)

local bgStroke = Instance.new("UIStroke")
bgStroke.Color = Color3.fromRGB(60, 60, 60)
bgStroke.Thickness = 1
bgStroke.Parent = bgBox

-- ── DRAG BAR ─────────────────────────────────────────────
local dragBar = Instance.new("Frame")
dragBar.Name = "DragBar"
dragBar.Size = UDim2.new(1, 0, 0, 36)
dragBar.Position = UDim2.new(0, 0, 0, 0)
dragBar.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
dragBar.BorderSizePixel = 0
dragBar.Active = true
dragBar.ZIndex = 8
dragBar.Parent = bgBox
Instance.new("UICorner", dragBar).CornerRadius = UDim.new(0, 10)

local dragBarFix = Instance.new("Frame")
dragBarFix.Size = UDim2.new(1, 0, 0.5, 0)
dragBarFix.Position = UDim2.new(0, 0, 0.5, 0)
dragBarFix.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
dragBarFix.BorderSizePixel = 0
dragBarFix.ZIndex = 8
dragBarFix.Parent = dragBar

local dragIcon = Instance.new("TextLabel")
dragIcon.Size = UDim2.new(1, 0, 1, 0)
dragIcon.BackgroundTransparency = 1
dragIcon.Text = "⠿  Con Ex  [L]"
dragIcon.TextColor3 = Color3.fromRGB(160, 160, 160)
dragIcon.Font = Enum.Font.GothamBold
dragIcon.TextSize = 13
dragIcon.ZIndex = 9
dragIcon.Parent = dragBar

-- ── TAB BAR ──────────────────────────────────────────────
local tabBar = Instance.new("Frame")
tabBar.Size = UDim2.new(1, 0, 0, 36)
tabBar.Position = UDim2.new(0, 0, 0, 36)
tabBar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
tabBar.BorderSizePixel = 0
tabBar.ZIndex = 8
tabBar.Parent = bgBox

local clientTab = Instance.new("TextButton")
clientTab.Size = UDim2.new(0.333, 0, 1, 0)
clientTab.Position = UDim2.new(0, 0, 0, 0)
clientTab.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
clientTab.BorderSizePixel = 0
clientTab.Text = "Client"
clientTab.TextColor3 = Color3.fromRGB(255, 255, 255)
clientTab.Font = Enum.Font.GothamBold
clientTab.TextSize = 13
clientTab.ZIndex = 9
clientTab.Parent = tabBar
Instance.new("UICorner", clientTab).CornerRadius = UDim.new(0, 6)

local espTab = Instance.new("TextButton")
espTab.Size = UDim2.new(0.333, 0, 1, 0)
espTab.Position = UDim2.new(0.333, 0, 0, 0)
espTab.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
espTab.BorderSizePixel = 0
espTab.Text = "ESP"
espTab.TextColor3 = Color3.fromRGB(120, 120, 120)
espTab.Font = Enum.Font.GothamBold
espTab.TextSize = 13
espTab.ZIndex = 9
espTab.Parent = tabBar
Instance.new("UICorner", espTab).CornerRadius = UDim.new(0, 6)

local aimTab = Instance.new("TextButton")
aimTab.Size = UDim2.new(0.334, 0, 1, 0)
aimTab.Position = UDim2.new(0.666, 0, 0, 0)
aimTab.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
aimTab.BorderSizePixel = 0
aimTab.Text = "Aim"
aimTab.TextColor3 = Color3.fromRGB(120, 120, 120)
aimTab.Font = Enum.Font.GothamBold
aimTab.TextSize = 13
aimTab.ZIndex = 9
aimTab.Parent = tabBar
Instance.new("UICorner", aimTab).CornerRadius = UDim.new(0, 6)

local tabUnderline = Instance.new("Frame")
tabUnderline.Size = UDim2.new(0.333, 0, 0, 2)
tabUnderline.Position = UDim2.new(0, 0, 1, -2)
tabUnderline.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
tabUnderline.BorderSizePixel = 0
tabUnderline.ZIndex = 10
tabUnderline.Parent = tabBar

-- ── CLIENT PANEL ─────────────────────────────────────────
local clientPanel = Instance.new("Frame")
clientPanel.Size = UDim2.new(1, 0, 1, -72)
clientPanel.Position = UDim2.new(0, 0, 0, 72)
clientPanel.BackgroundTransparency = 1
clientPanel.ClipsDescendants = true
clientPanel.ZIndex = 6
clientPanel.Visible = true
clientPanel.Parent = bgBox

local clientScroll = Instance.new("ScrollingFrame")
clientScroll.Size = UDim2.new(1, 0, 1, 0)
clientScroll.Position = UDim2.new(0, 0, 0, 0)
clientScroll.BackgroundTransparency = 1
clientScroll.BorderSizePixel = 0
clientScroll.ScrollBarThickness = 4
clientScroll.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)
clientScroll.CanvasSize = UDim2.new(0, 0, 0, 300)
clientScroll.ZIndex = 6
clientScroll.Parent = clientPanel

-- ── GRAPHICS SECTION ─────────────────────────────────────
local rtxSectionLabel = Instance.new("TextLabel")
rtxSectionLabel.Size = UDim2.new(1, -40, 0, 18)
rtxSectionLabel.Position = UDim2.new(0, 20, 0, 8)
rtxSectionLabel.BackgroundTransparency = 1
rtxSectionLabel.Text = "GRAPHICS"
rtxSectionLabel.TextColor3 = Color3.fromRGB(100, 100, 100)
rtxSectionLabel.Font = Enum.Font.GothamBold
rtxSectionLabel.TextSize = 11
rtxSectionLabel.TextXAlignment = Enum.TextXAlignment.Left
rtxSectionLabel.ZIndex = 7
rtxSectionLabel.Parent = clientScroll

local rtxBtn = Instance.new("TextButton")
rtxBtn.Size = UDim2.new(1, -40, 0, 40)
rtxBtn.Position = UDim2.new(0, 20, 0, 30)
rtxBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
rtxBtn.BorderSizePixel = 0
rtxBtn.Text = "✦  RTX  OFF"
rtxBtn.TextColor3 = Color3.fromRGB(160, 160, 160)
rtxBtn.Font = Enum.Font.GothamBold
rtxBtn.TextSize = 14
rtxBtn.ZIndex = 7
rtxBtn.Parent = clientScroll
Instance.new("UICorner", rtxBtn).CornerRadius = UDim.new(0, 8)

local rtxStroke = Instance.new("UIStroke")
rtxStroke.Color = Color3.fromRGB(70, 70, 70)
rtxStroke.Thickness = 1
rtxStroke.Parent = rtxBtn

rtxBtn.MouseButton1Click:Connect(function()
	rtxEnabled = not rtxEnabled

	if rtxEnabled then
		-- RTX ON
		rtxBtn.Text       = "✦  RTX  ON"
		rtxBtn.TextColor3 = Color3.fromRGB(255, 220, 80)
		TweenService:Create(rtxBtn,    TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(40, 35, 10) }):Play()
		TweenService:Create(rtxStroke, TweenInfo.new(0.2), { Color = Color3.fromRGB(200, 160, 30) }):Play()

		-- Future tech: enables real-time global illumination + surface reflections
		Lighting.Technology = Enum.Technology.Future
		Lighting.Brightness = 3

		-- Clear any leftover RTX bloom from a previous toggle
		for _, fx in ipairs(Lighting:GetChildren()) do
			if fx.Name == "RTX_Bloom" then fx:Destroy() end
		end

		-- Bloom: neon/bright surfaces glow
		local bloom = Instance.new("BloomEffect")
		bloom.Name      = "RTX_Bloom"
		bloom.Intensity = 1.6
		bloom.Size      = 56
		bloom.Threshold = 0.8
		bloom.Parent    = Lighting

		-- Store original reflectance per-part and boost to at least 0.35
		origReflectance = {}
		for _, v in ipairs(workspace:GetDescendants()) do
			if v:IsA("BasePart") and not v:IsA("Terrain") then
				origReflectance[v] = v.Reflectance
				v.Reflectance      = math.max(v.Reflectance, 0.35)
				v.Material         = Enum.Material.SmoothPlastic
			end
		end

	else
		-- RTX OFF
		rtxBtn.Text       = "✦  RTX  OFF"
		rtxBtn.TextColor3 = Color3.fromRGB(160, 160, 160)
		TweenService:Create(rtxBtn,    TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(30, 30, 30) }):Play()
		TweenService:Create(rtxStroke, TweenInfo.new(0.2), { Color = Color3.fromRGB(70, 70, 70) }):Play()

		-- Restore lighting
		Lighting.Technology = origLighting.Technology
		Lighting.Brightness = origLighting.Brightness

		-- Remove bloom
		for _, fx in ipairs(Lighting:GetChildren()) do
			if fx.Name == "RTX_Bloom" then fx:Destroy() end
		end

		-- Restore each part's original reflectance
		for v, ref in pairs(origReflectance) do
			if v and v.Parent then
				v.Reflectance = ref
			end
		end
		origReflectance = {}
	end
end)

-- ── ESP COLOR SECTION ────────────────────────────────────
local espColorLabel = Instance.new("TextLabel")
espColorLabel.Size = UDim2.new(1, -40, 0, 18)
espColorLabel.Position = UDim2.new(0, 20, 0, 84)
espColorLabel.BackgroundTransparency = 1
espColorLabel.Text = "ESP COLOR"
espColorLabel.TextColor3 = Color3.fromRGB(100, 100, 100)
espColorLabel.Font = Enum.Font.GothamBold
espColorLabel.TextSize = 11
espColorLabel.TextXAlignment = Enum.TextXAlignment.Left
espColorLabel.ZIndex = 7
espColorLabel.Parent = clientScroll

local track = Instance.new("Frame")
track.Size = UDim2.new(0, 260, 0, 14)
track.Position = UDim2.new(0.5, -130, 0, 106)
track.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
track.BorderSizePixel = 0
track.ZIndex = 7
track.Parent = clientScroll
Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0,    Color3.fromHSV(0,    1, 1)),
	ColorSequenceKeypoint.new(0.17, Color3.fromHSV(0.17, 1, 1)),
	ColorSequenceKeypoint.new(0.33, Color3.fromHSV(0.33, 1, 1)),
	ColorSequenceKeypoint.new(0.5,  Color3.fromHSV(0.5,  1, 1)),
	ColorSequenceKeypoint.new(0.67, Color3.fromHSV(0.67, 1, 1)),
	ColorSequenceKeypoint.new(0.83, Color3.fromHSV(0.83, 1, 1)),
	ColorSequenceKeypoint.new(1,    Color3.fromHSV(1,    1, 1)),
})
gradient.Parent = track

local knob = Instance.new("Frame")
knob.Size = UDim2.new(0, 20, 0, 20)
knob.Position = UDim2.new(0, -10, 0.5, -10)
knob.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
knob.BorderSizePixel = 0
knob.ZIndex = 9
knob.Parent = track
Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

local knobStroke = Instance.new("UIStroke")
knobStroke.Color = Color3.fromRGB(255, 255, 255)
knobStroke.Thickness = 2
knobStroke.Transparency = 0.4
knobStroke.Parent = knob

local hexLabel = Instance.new("TextLabel")
hexLabel.Size = UDim2.new(1, -40, 0, 14)
hexLabel.Position = UDim2.new(0, 20, 0, 124)
hexLabel.BackgroundTransparency = 1
hexLabel.Text = "#FF0000"
hexLabel.TextColor3 = Color3.fromRGB(120, 120, 120)
hexLabel.Font = Enum.Font.Code
hexLabel.TextSize = 10
hexLabel.TextXAlignment = Enum.TextXAlignment.Left
hexLabel.ZIndex = 7
hexLabel.Parent = clientScroll

-- ── BACKGROUND COLOR SECTION ─────────────────────────────
local bgColorLabel = Instance.new("TextLabel")
bgColorLabel.Size = UDim2.new(1, -40, 0, 18)
bgColorLabel.Position = UDim2.new(0, 20, 0, 148)
bgColorLabel.BackgroundTransparency = 1
bgColorLabel.Text = "BACKGROUND COLOR"
bgColorLabel.TextColor3 = Color3.fromRGB(100, 100, 100)
bgColorLabel.Font = Enum.Font.GothamBold
bgColorLabel.TextSize = 11
bgColorLabel.TextXAlignment = Enum.TextXAlignment.Left
bgColorLabel.ZIndex = 7
bgColorLabel.Parent = clientScroll

local bgTrack = Instance.new("Frame")
bgTrack.Size = UDim2.new(0, 260, 0, 14)
bgTrack.Position = UDim2.new(0.5, -130, 0, 170)
bgTrack.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
bgTrack.BorderSizePixel = 0
bgTrack.ZIndex = 7
bgTrack.Parent = clientScroll
Instance.new("UICorner", bgTrack).CornerRadius = UDim.new(1, 0)

local bgGradient = Instance.new("UIGradient")
bgGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0,    Color3.fromHSV(0,    1, 1)),
	ColorSequenceKeypoint.new(0.17, Color3.fromHSV(0.17, 1, 1)),
	ColorSequenceKeypoint.new(0.33, Color3.fromHSV(0.33, 1, 1)),
	ColorSequenceKeypoint.new(0.5,  Color3.fromHSV(0.5,  1, 1)),
	ColorSequenceKeypoint.new(0.67, Color3.fromHSV(0.67, 1, 1)),
	ColorSequenceKeypoint.new(0.83, Color3.fromHSV(0.83, 1, 1)),
	ColorSequenceKeypoint.new(1,    Color3.fromHSV(1,    1, 1)),
})
bgGradient.Parent = bgTrack

local bgKnob = Instance.new("Frame")
bgKnob.Size = UDim2.new(0, 20, 0, 20)
bgKnob.Position = UDim2.new(0, -10, 0.5, -10)
bgKnob.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
bgKnob.BorderSizePixel = 0
bgKnob.ZIndex = 9
bgKnob.Parent = bgTrack
Instance.new("UICorner", bgKnob).CornerRadius = UDim.new(1, 0)

local bgKnobStroke = Instance.new("UIStroke")
bgKnobStroke.Color = Color3.fromRGB(255, 255, 255)
bgKnobStroke.Thickness = 2
bgKnobStroke.Transparency = 0.4
bgKnobStroke.Parent = bgKnob

local bgHexLabel = Instance.new("TextLabel")
bgHexLabel.Size = UDim2.new(1, -40, 0, 14)
bgHexLabel.Position = UDim2.new(0, 20, 0, 188)
bgHexLabel.BackgroundTransparency = 1
bgHexLabel.Text = "#000000"
bgHexLabel.TextColor3 = Color3.fromRGB(120, 120, 120)
bgHexLabel.Font = Enum.Font.Code
bgHexLabel.TextSize = 10
bgHexLabel.TextXAlignment = Enum.TextXAlignment.Left
bgHexLabel.ZIndex = 7
bgHexLabel.Parent = clientScroll
-- ── AIMBOT CIRCLE COLOR SECTION ──────────────────────────
local aimColorLabel = Instance.new("TextLabel")
aimColorLabel.Size = UDim2.new(1, -40, 0, 18)
aimColorLabel.Position = UDim2.new(0, 20, 0, 210)
aimColorLabel.BackgroundTransparency = 1
aimColorLabel.Text = "AIM CIRCLE COLOR"
aimColorLabel.TextColor3 = Color3.fromRGB(100, 100, 100)
aimColorLabel.Font = Enum.Font.GothamBold
aimColorLabel.TextSize = 11
aimColorLabel.TextXAlignment = Enum.TextXAlignment.Left
aimColorLabel.ZIndex = 7
aimColorLabel.Parent = clientScroll

local aimTrack = Instance.new("Frame")
aimTrack.Size = UDim2.new(0, 260, 0, 14)
aimTrack.Position = UDim2.new(0.5, -130, 0, 232)
aimTrack.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
aimTrack.BorderSizePixel = 0
aimTrack.ZIndex = 7
aimTrack.Parent = clientScroll
Instance.new("UICorner", aimTrack).CornerRadius = UDim.new(1, 0)

local aimTrackGradient = Instance.new("UIGradient")
aimTrackGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0,    Color3.fromHSV(0,    1, 1)),
	ColorSequenceKeypoint.new(0.17, Color3.fromHSV(0.17, 1, 1)),
	ColorSequenceKeypoint.new(0.33, Color3.fromHSV(0.33, 1, 1)),
	ColorSequenceKeypoint.new(0.5,  Color3.fromHSV(0.5,  1, 1)),
	ColorSequenceKeypoint.new(0.67, Color3.fromHSV(0.67, 1, 1)),
	ColorSequenceKeypoint.new(0.83, Color3.fromHSV(0.83, 1, 1)),
	ColorSequenceKeypoint.new(1,    Color3.fromHSV(1,    1, 1)),
})
aimTrackGradient.Parent = aimTrack

local aimKnob = Instance.new("Frame")
aimKnob.Size = UDim2.new(0, 20, 0, 20)
-- Start knob at hue 0 (red, matching default fovStroke color)
aimKnob.Position = UDim2.new(0, -10, 0.5, -10)
aimKnob.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
aimKnob.BorderSizePixel = 0
aimKnob.ZIndex = 9
aimKnob.Parent = aimTrack
Instance.new("UICorner", aimKnob).CornerRadius = UDim.new(1, 0)

local aimKnobStroke = Instance.new("UIStroke")
aimKnobStroke.Color = Color3.fromRGB(255, 255, 255)
aimKnobStroke.Thickness = 2
aimKnobStroke.Transparency = 0.4
aimKnobStroke.Parent = aimKnob

local aimHexLabel = Instance.new("TextLabel")
aimHexLabel.Size = UDim2.new(1, -40, 0, 14)
aimHexLabel.Position = UDim2.new(0, 20, 0, 250)
aimHexLabel.BackgroundTransparency = 1
aimHexLabel.Text = "#FF3C3C"
aimHexLabel.TextColor3 = Color3.fromRGB(120, 120, 120)
aimHexLabel.Font = Enum.Font.Code
aimHexLabel.TextSize = 10
aimHexLabel.TextXAlignment = Enum.TextXAlignment.Left
aimHexLabel.ZIndex = 7
aimHexLabel.Parent = clientScroll

-- ── AIM PANEL ────────────────────────────────────────────
local aimPanel = Instance.new("Frame")
aimPanel.Size = UDim2.new(1, 0, 1, -72)
aimPanel.Position = UDim2.new(0, 0, 0, 72)
aimPanel.BackgroundTransparency = 1
aimPanel.ClipsDescendants = true
aimPanel.ZIndex = 6
aimPanel.Visible = false
aimPanel.Parent = bgBox

local aimScroll = Instance.new("ScrollingFrame")
aimScroll.Size = UDim2.new(1, 0, 1, 0)
aimScroll.Position = UDim2.new(0, 0, 0, 0)
aimScroll.BackgroundTransparency = 1
aimScroll.BorderSizePixel = 0
aimScroll.ScrollBarThickness = 4
aimScroll.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)
aimScroll.CanvasSize = UDim2.new(0, 0, 0, 320)
aimScroll.ZIndex = 6
aimScroll.Parent = aimPanel

-- Aimbot state
local aimbotEnabled = false
local aimbotFov     = 150  -- radius in pixels
local aimbotSmooth  = 0.05 -- 0=instant, 1=never reaches
local aimbotMaxDist = 100  -- max stud distance to lock on (10-500)

-- FOV circle overlay (separate ScreenGui so it draws on top of world)
local fovGui = Instance.new("ScreenGui")
fovGui.Name = "AimbotFovGui"
fovGui.ResetOnSpawn = false
fovGui.IgnoreGuiInset = true
fovGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
fovGui.Parent = playerGui

-- Draw FOV circle using a Frame with UICorner + UIStroke (no image needed)
local fovCircle = Instance.new("Frame")
fovCircle.Name = "FovCircle"
fovCircle.AnchorPoint = Vector2.new(0.5, 0.5)
fovCircle.BackgroundTransparency = 1
fovCircle.BorderSizePixel = 0
fovCircle.Size = UDim2.new(0, aimbotFov * 2, 0, aimbotFov * 2)
fovCircle.Visible = false
fovCircle.ZIndex = 100
fovCircle.Parent = fovGui
Instance.new("UICorner", fovCircle).CornerRadius = UDim.new(1, 0)

local fovStroke = Instance.new("UIStroke")
fovStroke.Color = Color3.fromRGB(255, 60, 60)
fovStroke.Thickness = 1.5
fovStroke.Transparency = 0.2
fovStroke.Parent = fovCircle

-- ── AIM PANEL UI ─────────────────────────────────────────
local aimSectionLabel = Instance.new("TextLabel")
aimSectionLabel.Size = UDim2.new(1, -40, 0, 18)
aimSectionLabel.Position = UDim2.new(0, 20, 0, 8)
aimSectionLabel.BackgroundTransparency = 1
aimSectionLabel.Text = "AIMBOT"
aimSectionLabel.TextColor3 = Color3.fromRGB(100, 100, 100)
aimSectionLabel.Font = Enum.Font.GothamBold
aimSectionLabel.TextSize = 11
aimSectionLabel.TextXAlignment = Enum.TextXAlignment.Left
aimSectionLabel.ZIndex = 7
aimSectionLabel.Parent = aimScroll

local aimbotBtn = Instance.new("TextButton")
aimbotBtn.Size = UDim2.new(1, -40, 0, 40)
aimbotBtn.Position = UDim2.new(0, 20, 0, 30)
aimbotBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
aimbotBtn.BorderSizePixel = 0
aimbotBtn.Text = "Aimbot  OFF"
aimbotBtn.TextColor3 = Color3.fromRGB(160, 160, 160)
aimbotBtn.Font = Enum.Font.GothamBold
aimbotBtn.TextSize = 14
aimbotBtn.ZIndex = 7
aimbotBtn.Parent = aimScroll
Instance.new("UICorner", aimbotBtn).CornerRadius = UDim.new(0, 8)

local aimbotStroke = Instance.new("UIStroke")
aimbotStroke.Color = Color3.fromRGB(70, 70, 70)
aimbotStroke.Thickness = 1
aimbotStroke.Parent = aimbotBtn

-- FOV label + slider ──────────────────────────────────────
local fovSectionLabel = Instance.new("TextLabel")
fovSectionLabel.Size = UDim2.new(1, -40, 0, 18)
fovSectionLabel.Position = UDim2.new(0, 20, 0, 86)
fovSectionLabel.BackgroundTransparency = 1
fovSectionLabel.Text = "FOV RADIUS  ( " .. aimbotFov .. " px )"
fovSectionLabel.TextColor3 = Color3.fromRGB(100, 100, 100)
fovSectionLabel.Font = Enum.Font.GothamBold
fovSectionLabel.TextSize = 11
fovSectionLabel.TextXAlignment = Enum.TextXAlignment.Left
fovSectionLabel.ZIndex = 7
fovSectionLabel.Parent = aimScroll

local fovTrack = Instance.new("Frame")
fovTrack.Size = UDim2.new(0, 260, 0, 14)
fovTrack.Position = UDim2.new(0.5, -130, 0, 108)
fovTrack.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
fovTrack.BorderSizePixel = 0
fovTrack.ZIndex = 7
fovTrack.Parent = aimScroll
Instance.new("UICorner", fovTrack).CornerRadius = UDim.new(1, 0)

local fovFill = Instance.new("Frame")
fovFill.Size = UDim2.new(aimbotFov / 400, 0, 1, 0)
fovFill.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
fovFill.BorderSizePixel = 0
fovFill.ZIndex = 8
fovFill.Parent = fovTrack
Instance.new("UICorner", fovFill).CornerRadius = UDim.new(1, 0)

local fovKnob = Instance.new("Frame")
fovKnob.Size = UDim2.new(0, 20, 0, 20)
fovKnob.Position = UDim2.new(aimbotFov / 400, -10, 0.5, -10)
fovKnob.BackgroundColor3 = Color3.fromRGB(220, 80, 80)
fovKnob.BorderSizePixel = 0
fovKnob.ZIndex = 9
fovKnob.Parent = fovTrack
Instance.new("UICorner", fovKnob).CornerRadius = UDim.new(1, 0)
local fovKnobStroke = Instance.new("UIStroke")
fovKnobStroke.Color = Color3.fromRGB(255,255,255)
fovKnobStroke.Thickness = 2
fovKnobStroke.Transparency = 0.5
fovKnobStroke.Parent = fovKnob

-- Smooth label + slider ───────────────────────────────────
local smoothSectionLabel = Instance.new("TextLabel")
smoothSectionLabel.Size = UDim2.new(1, -40, 0, 18)
smoothSectionLabel.Position = UDim2.new(0, 20, 0, 140)
smoothSectionLabel.BackgroundTransparency = 1
smoothSectionLabel.Text = "SMOOTH  ( " .. math.floor(aimbotSmooth * 100) .. "% )"
smoothSectionLabel.TextColor3 = Color3.fromRGB(100, 100, 100)
smoothSectionLabel.Font = Enum.Font.GothamBold
smoothSectionLabel.TextSize = 11
smoothSectionLabel.TextXAlignment = Enum.TextXAlignment.Left
smoothSectionLabel.ZIndex = 7
smoothSectionLabel.Parent = aimScroll

local smoothTrack = Instance.new("Frame")
smoothTrack.Size = UDim2.new(0, 260, 0, 14)
smoothTrack.Position = UDim2.new(0.5, -130, 0, 162)
smoothTrack.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
smoothTrack.BorderSizePixel = 0
smoothTrack.ZIndex = 7
smoothTrack.Parent = aimScroll
Instance.new("UICorner", smoothTrack).CornerRadius = UDim.new(1, 0)

local smoothFill = Instance.new("Frame")
smoothFill.Size = UDim2.new(aimbotSmooth, 0, 1, 0)
smoothFill.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
smoothFill.BorderSizePixel = 0
smoothFill.ZIndex = 8
smoothFill.Parent = smoothTrack
Instance.new("UICorner", smoothFill).CornerRadius = UDim.new(1, 0)

local smoothKnob = Instance.new("Frame")
smoothKnob.Size = UDim2.new(0, 20, 0, 20)
smoothKnob.Position = UDim2.new(aimbotSmooth, -10, 0.5, -10)
smoothKnob.BackgroundColor3 = Color3.fromRGB(220, 80, 80)
smoothKnob.BorderSizePixel = 0
smoothKnob.ZIndex = 9
smoothKnob.Parent = smoothTrack
Instance.new("UICorner", smoothKnob).CornerRadius = UDim.new(1, 0)
local smoothKnobStroke = Instance.new("UIStroke")
smoothKnobStroke.Color = Color3.fromRGB(255,255,255)
smoothKnobStroke.Thickness = 2
smoothKnobStroke.Transparency = 0.5
smoothKnobStroke.Parent = smoothKnob

-- MAX DISTANCE slider ────────────────────────────────────
local distSectionLabel = Instance.new("TextLabel")
distSectionLabel.Size = UDim2.new(1, -40, 0, 18)
distSectionLabel.Position = UDim2.new(0, 20, 0, 194)
distSectionLabel.BackgroundTransparency = 1
distSectionLabel.Text = "MAX DISTANCE  ( " .. aimbotMaxDist .. " studs )"
distSectionLabel.TextColor3 = Color3.fromRGB(100, 100, 100)
distSectionLabel.Font = Enum.Font.GothamBold
distSectionLabel.TextSize = 11
distSectionLabel.TextXAlignment = Enum.TextXAlignment.Left
distSectionLabel.ZIndex = 7
distSectionLabel.Parent = aimScroll

local distTrack = Instance.new("Frame")
distTrack.Size = UDim2.new(0, 260, 0, 14)
distTrack.Position = UDim2.new(0.5, -130, 0, 216)
distTrack.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
distTrack.BorderSizePixel = 0
distTrack.ZIndex = 7
distTrack.Parent = aimScroll
Instance.new("UICorner", distTrack).CornerRadius = UDim.new(1, 0)

local distFill = Instance.new("Frame")
distFill.Size = UDim2.new((aimbotMaxDist - 10) / 490, 0, 1, 0)
distFill.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
distFill.BorderSizePixel = 0
distFill.ZIndex = 8
distFill.Parent = distTrack
Instance.new("UICorner", distFill).CornerRadius = UDim.new(1, 0)

local distKnob = Instance.new("Frame")
distKnob.Size = UDim2.new(0, 20, 0, 20)
distKnob.Position = UDim2.new((aimbotMaxDist - 10) / 490, -10, 0.5, -10)
distKnob.BackgroundColor3 = Color3.fromRGB(220, 80, 80)
distKnob.BorderSizePixel = 0
distKnob.ZIndex = 9
distKnob.Parent = distTrack
Instance.new("UICorner", distKnob).CornerRadius = UDim.new(1, 0)
local distKnobStroke = Instance.new("UIStroke")
distKnobStroke.Color = Color3.fromRGB(255,255,255)
distKnobStroke.Thickness = 2
distKnobStroke.Transparency = 0.5
distKnobStroke.Parent = distKnob

local aimInfoLabel = Instance.new("TextLabel")
aimInfoLabel.Size = UDim2.new(1, -40, 0, 40)
aimInfoLabel.Position = UDim2.new(0, 20, 0, 250)
aimInfoLabel.BackgroundTransparency = 1
aimInfoLabel.Text = "Hold right mouse button to aim.\nTargets head inside the FOV circle."
aimInfoLabel.TextColor3 = Color3.fromRGB(90, 90, 90)
aimInfoLabel.Font = Enum.Font.Gotham
aimInfoLabel.TextSize = 11
aimInfoLabel.TextXAlignment = Enum.TextXAlignment.Left
aimInfoLabel.TextWrapped = true
aimInfoLabel.ZIndex = 7
aimInfoLabel.Parent = aimScroll

-- Aimbot toggle
aimbotBtn.MouseButton1Click:Connect(function()
	aimbotEnabled = not aimbotEnabled
	if aimbotEnabled then
		aimbotBtn.Text       = "Aimbot  ON"
		aimbotBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
		TweenService:Create(aimbotBtn,    TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(45, 15, 15) }):Play()
		TweenService:Create(aimbotStroke, TweenInfo.new(0.15), { Color = Color3.fromRGB(200, 60, 60) }):Play()
		fovCircle.Visible = true
	else
		aimbotBtn.Text       = "Aimbot  OFF"
		aimbotBtn.TextColor3 = Color3.fromRGB(160, 160, 160)
		TweenService:Create(aimbotBtn,    TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(35, 35, 35) }):Play()
		TweenService:Create(aimbotStroke, TweenInfo.new(0.15), { Color = Color3.fromRGB(70, 70, 70) }):Play()
		fovCircle.Visible = false
	end
end)

-- FOV slider drag
local draggingFov    = false
local draggingSmooth = false
local draggingDist   = false

fovKnob.InputBegan:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1 then draggingFov = true end
end)
fovTrack.InputBegan:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1 then
		draggingFov = true
	end
end)
smoothKnob.InputBegan:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1 then draggingSmooth = true end
end)
smoothTrack.InputBegan:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1 then draggingSmooth = true end
end)
distKnob.InputBegan:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1 then draggingDist = true end
end)
distTrack.InputBegan:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1 then draggingDist = true end
end)

UserInputService.InputEnded:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1 then
		draggingFov    = false
		draggingSmooth = false
		draggingDist   = false
	end
end)

-- Helper to compute t from an X position over a track frame
local function trackT(trk, x)
	return math.clamp((x - trk.AbsolutePosition.X) / trk.AbsoluteSize.X, 0, 1)
end

UserInputService.InputChanged:Connect(function(i)
	if i.UserInputType ~= Enum.UserInputType.MouseMovement then return end
	if draggingFov then
		local t = trackT(fovTrack, i.Position.X)
		aimbotFov = math.floor(t * 400)  -- 0 – 400 px
		fovKnob.Position = UDim2.new(t, -10, 0.5, -10)
		fovFill.Size     = UDim2.new(t, 0, 1, 0)
		fovCircle.Size   = UDim2.new(0, aimbotFov * 2, 0, aimbotFov * 2)
		fovSectionLabel.Text = "FOV RADIUS  ( " .. aimbotFov .. " px )"
	elseif draggingSmooth then
		local t = trackT(smoothTrack, i.Position.X)
		aimbotSmooth = t
		smoothKnob.Position = UDim2.new(t, -10, 0.5, -10)
		smoothFill.Size     = UDim2.new(t, 0, 1, 0)
		smoothSectionLabel.Text = "SMOOTH  ( " .. math.floor(t * 100) .. "% )"
	elseif draggingDist then
		local t = trackT(distTrack, i.Position.X)
		aimbotMaxDist = math.floor(10 + t * 490)  -- 10 to 500 studs
		distKnob.Position = UDim2.new(t, -10, 0.5, -10)
		distFill.Size     = UDim2.new(t, 0, 1, 0)
		distSectionLabel.Text = "MAX DISTANCE  ( " .. aimbotMaxDist .. " studs )"
	end
end)

-- ── AIMBOT LOGIC ─────────────────────────────────────────
local Camera = workspace.CurrentCamera

local function getClosestTargetInFov()
	-- Use current mouse position as the FOV circle center
	local mousePos = UserInputService:GetMouseLocation()

	local bestPlayer = nil
	local bestDist   = math.huge

	for _, plr in ipairs(Players:GetPlayers()) do
		if plr == player then continue end
		local char = plr.Character
		if not char then continue end
		local head = char:FindFirstChild("Head")
		local hum  = char:FindFirstChildOfClass("Humanoid")
		if not head or not hum or hum.Health <= 0 then continue end

		local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
		if not onScreen then continue end

		local screenVec = Vector2.new(screenPos.X, screenPos.Y)
		local dist2d    = (screenVec - mousePos).Magnitude

		-- Also check world-space distance against the max distance slider
		local char2 = plr.Character
		local hrp2  = char2 and char2:FindFirstChild("HumanoidRootPart")
		local localChar2 = player.Character
		local localHrp2  = localChar2 and localChar2:FindFirstChild("HumanoidRootPart")
		local worldDist = (hrp2 and localHrp2)
			and (hrp2.Position - localHrp2.Position).Magnitude or math.huge

		if dist2d < aimbotFov and dist2d < bestDist and worldDist <= aimbotMaxDist then
			bestDist   = dist2d
			bestPlayer = plr
		end
	end

	return bestPlayer
end

RunService.RenderStepped:Connect(function()
	-- FOV circle always follows the mouse cursor
	if aimbotEnabled then
		local mouse = UserInputService:GetMouseLocation()
		fovCircle.Position = UDim2.new(0, mouse.X, 0, mouse.Y)
	end

	-- Aimbot: only fires while RMB held
	if not aimbotEnabled then return end
	if not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then return end

	local target = getClosestTargetInFov()
	if not target then return end

	local char = target.Character
	if not char then return end
	local head = char:FindFirstChild("Head")
	if not head then return end

	local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
	if not onScreen then return end

	-- Pull mouse straight to target. lerpAlpha close to 1 = near instant snap.
	local current   = UserInputService:GetMouseLocation()
	local goal      = Vector2.new(screenPos.X, screenPos.Y)
	-- Map smooth slider: 0 -> alpha 1.0 (instant), 1 -> alpha 0.1 (slow)
	local lerpAlpha = 1 - (math.clamp(aimbotSmooth, 0, 0.9) * 0.9)
	local delta     = (goal - current) * lerpAlpha

	mousemoverel(delta.X, delta.Y)
end)

-- ── ESP PANEL ────────────────────────────────────────────
local espPanel = Instance.new("Frame")
espPanel.Size = UDim2.new(1, 0, 1, -72)
espPanel.Position = UDim2.new(0, 0, 0, 72)
espPanel.BackgroundTransparency = 1
espPanel.ClipsDescendants = true
espPanel.ZIndex = 6
espPanel.Visible = false
espPanel.Parent = bgBox

local espScroll = Instance.new("ScrollingFrame")
espScroll.Size = UDim2.new(1, 0, 1, 0)
espScroll.Position = UDim2.new(0, 0, 0, 0)
espScroll.BackgroundTransparency = 1
espScroll.BorderSizePixel = 0
espScroll.ScrollBarThickness = 4
espScroll.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)
espScroll.CanvasSize = UDim2.new(0, 0, 0, 480)
espScroll.ZIndex = 6
espScroll.Parent = espPanel

-- Toggle helper
local function makeToggle(parent, yPos, labelText, defaultState, callback)
	local row = Instance.new("Frame")
	row.Size = UDim2.new(1, -40, 0, 32)
	row.Position = UDim2.new(0, 20, 0, yPos)
	row.BackgroundTransparency = 1
	row.ZIndex = 7
	row.Parent = parent

	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(1, -56, 1, 0)
	lbl.BackgroundTransparency = 1
	lbl.Text = labelText
	lbl.TextColor3 = Color3.fromRGB(200, 200, 200)
	lbl.Font = Enum.Font.Gotham
	lbl.TextSize = 13
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.ZIndex = 7
	lbl.Parent = row

	local tBg = Instance.new("Frame")
	tBg.Size = UDim2.new(0, 44, 0, 22)
	tBg.Position = UDim2.new(1, -44, 0.5, -11)
	tBg.BackgroundColor3 = defaultState and Color3.fromRGB(80, 200, 80) or Color3.fromRGB(60, 60, 60)
	tBg.BorderSizePixel = 0
	tBg.ZIndex = 8
	tBg.Parent = row
	Instance.new("UICorner", tBg).CornerRadius = UDim.new(1, 0)

	local tKnob = Instance.new("Frame")
	tKnob.Size = UDim2.new(0, 16, 0, 16)
	tKnob.Position = defaultState and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
	tKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	tKnob.BorderSizePixel = 0
	tKnob.ZIndex = 9
	tKnob.Parent = tBg
	Instance.new("UICorner", tKnob).CornerRadius = UDim.new(1, 0)

	local state = defaultState
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, 0, 1, 0)
	btn.BackgroundTransparency = 1
	btn.Text = ""
	btn.ZIndex = 10
	btn.Parent = row

	btn.MouseButton1Click:Connect(function()
		state = not state
		TweenService:Create(tBg,   TweenInfo.new(0.15), { BackgroundColor3 = state and Color3.fromRGB(80,200,80) or Color3.fromRGB(60,60,60) }):Play()
		TweenService:Create(tKnob, TweenInfo.new(0.15), { Position = state and UDim2.new(1,-19,0.5,-8) or UDim2.new(0,3,0.5,-8) }):Play()
		callback(state)
	end)
end

local function makeSection(parent, yPos, text)
	local sep = Instance.new("TextLabel")
	sep.Size = UDim2.new(1, -40, 0, 18)
	sep.Position = UDim2.new(0, 20, 0, yPos)
	sep.BackgroundTransparency = 1
	sep.Text = text
	sep.TextColor3 = Color3.fromRGB(100, 100, 100)
	sep.Font = Enum.Font.GothamBold
	sep.TextSize = 11
	sep.TextXAlignment = Enum.TextXAlignment.Left
	sep.ZIndex = 7
	sep.Parent = parent
end

-- ESP master toggle button
local espToggleBtn = Instance.new("TextButton")
espToggleBtn.Size = UDim2.new(1, -40, 0, 40)
espToggleBtn.Position = UDim2.new(0, 20, 0, 10)
espToggleBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
espToggleBtn.BorderSizePixel = 0
espToggleBtn.Text = "ESP  OFF"
espToggleBtn.TextColor3 = Color3.fromRGB(160, 160, 160)
espToggleBtn.Font = Enum.Font.GothamBold
espToggleBtn.TextSize = 14
espToggleBtn.ZIndex = 7
espToggleBtn.Parent = espScroll
Instance.new("UICorner", espToggleBtn).CornerRadius = UDim.new(0, 8)

local espToggleStroke = Instance.new("UIStroke")
espToggleStroke.Color = Color3.fromRGB(70, 70, 70)
espToggleStroke.Thickness = 1
espToggleStroke.Parent = espToggleBtn

makeSection(espScroll, 62, "DISPLAY OPTIONS")
makeToggle(espScroll, 82,  "Show Names",    showNames,    function(v) showNames    = v end)
makeToggle(espScroll, 120, "Show Health",   showHealth,   function(v) showHealth   = v end)
makeToggle(espScroll, 158, "Show Distance", showDistance, function(v) showDistance = v end)
makeToggle(espScroll, 196, "Highlight",     showBox,      function(v)
	showBox = v
	for _, data in pairs(espObjects) do
		if data.highlight and data.highlight.Parent then
			data.highlight.Enabled = showBox and espEnabled
		end
	end
end)
makeToggle(espScroll, 234, "Box ESP",       showBoxESP,   function(v)
	showBoxESP = v
	for _, data in pairs(espObjects) do
		if data.selectionBox and data.selectionBox.Parent then
			data.selectionBox.Visible = showBoxESP and espEnabled and withinRange
		end
	end
end)

makeSection(espScroll, 316, "ESP RANGE")

local espDistLabel = Instance.new("TextLabel")
espDistLabel.Size = UDim2.new(1, -40, 0, 14)
espDistLabel.Position = UDim2.new(0, 20, 0, 338)
espDistLabel.BackgroundTransparency = 1
espDistLabel.Text = "MAX DIST  ( " .. espMaxDist .. " studs )"
espDistLabel.TextColor3 = Color3.fromRGB(100, 100, 100)
espDistLabel.Font = Enum.Font.GothamBold
espDistLabel.TextSize = 11
espDistLabel.TextXAlignment = Enum.TextXAlignment.Left
espDistLabel.ZIndex = 7
espDistLabel.Parent = espScroll

local espDistTrack = Instance.new("Frame")
espDistTrack.Size = UDim2.new(0, 260, 0, 14)
espDistTrack.Position = UDim2.new(0.5, -130, 0, 356)
espDistTrack.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
espDistTrack.BorderSizePixel = 0
espDistTrack.ZIndex = 7
espDistTrack.Parent = espScroll
Instance.new("UICorner", espDistTrack).CornerRadius = UDim.new(1, 0)

local espDistFill = Instance.new("Frame")
espDistFill.Size = UDim2.new((espMaxDist - 10) / 990, 0, 1, 0)
espDistFill.BackgroundColor3 = Color3.fromRGB(80, 200, 80)
espDistFill.BorderSizePixel = 0
espDistFill.ZIndex = 8
espDistFill.Parent = espDistTrack
Instance.new("UICorner", espDistFill).CornerRadius = UDim.new(1, 0)

local espDistKnob = Instance.new("Frame")
espDistKnob.Size = UDim2.new(0, 20, 0, 20)
espDistKnob.Position = UDim2.new((espMaxDist - 10) / 990, -10, 0.5, -10)
espDistKnob.BackgroundColor3 = Color3.fromRGB(100, 220, 100)
espDistKnob.BorderSizePixel = 0
espDistKnob.ZIndex = 9
espDistKnob.Parent = espDistTrack
Instance.new("UICorner", espDistKnob).CornerRadius = UDim.new(1, 0)
local espDistKnobStroke = Instance.new("UIStroke")
espDistKnobStroke.Color = Color3.fromRGB(255,255,255)
espDistKnobStroke.Thickness = 2
espDistKnobStroke.Transparency = 0.5
espDistKnobStroke.Parent = espDistKnob

makeSection(espScroll, 382, "INFO")

local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(1, -40, 0, 36)
infoLabel.Position = UDim2.new(0, 20, 0, 398)
infoLabel.BackgroundTransparency = 1
infoLabel.Text = "ESP color synced to Client tab slider.\nBox = colored model outline through walls."
infoLabel.TextColor3 = Color3.fromRGB(90, 90, 90)
infoLabel.Font = Enum.Font.Gotham
infoLabel.TextSize = 11
infoLabel.TextXAlignment = Enum.TextXAlignment.Left
infoLabel.TextWrapped = true
infoLabel.ZIndex = 7
infoLabel.Parent = espScroll

local playerCountLabel = Instance.new("TextLabel")
playerCountLabel.Size = UDim2.new(1, -40, 0, 20)
playerCountLabel.Position = UDim2.new(0, 20, 0, 440)
playerCountLabel.BackgroundTransparency = 1
playerCountLabel.Text = "Players tracked: 0"
playerCountLabel.TextColor3 = Color3.fromRGB(90, 90, 90)
playerCountLabel.Font = Enum.Font.Code
playerCountLabel.TextSize = 11
playerCountLabel.TextXAlignment = Enum.TextXAlignment.Left
playerCountLabel.ZIndex = 7
playerCountLabel.Parent = espScroll

-- ── ESP OBJECT HELPERS ───────────────────────────────────
local function getCharParts(char)
	return char:FindFirstChild("Head"),
	       char:FindFirstChild("HumanoidRootPart"),
	       char:FindFirstChildOfClass("Humanoid")
end

local function removeESP(plr)
	local d = espObjects[plr]
	if not d then return end
	if d.bill         and d.bill.Parent         then d.bill:Destroy()         end
	if d.highlight    and d.highlight.Parent    then d.highlight:Destroy()    end
	if d.selectionBox and d.selectionBox.Parent then d.selectionBox:Destroy() end
	espObjects[plr] = nil
end



local function createESP(plr)
	if plr == player then return end
	removeESP(plr)

	local char = plr.Character
	if not char then return end
	local head, hrp, hum = getCharParts(char)
	if not head or not hrp or not hum then return end

	local bill = Instance.new("BillboardGui")
	bill.Name = "ESP_Bill"
	bill.Adornee = hrp
	bill.AlwaysOnTop = true
	bill.Size = UDim2.new(0, 130, 0, 60)
	bill.StudsOffset = Vector3.new(0, 3.2, 0)
	bill.ResetOnSpawn = false
	bill.Parent = playerGui

	local nameLabel = Instance.new("TextLabel")
	nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
	nameLabel.BackgroundTransparency = 1
	nameLabel.Text = plr.DisplayName
	nameLabel.TextColor3 = espColor
	nameLabel.Font = Enum.Font.GothamBold
	nameLabel.TextSize = 13
	nameLabel.TextStrokeTransparency = 0.4
	nameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	nameLabel.Parent = bill

	local healthBg = Instance.new("Frame")
	healthBg.Size = UDim2.new(0.8, 0, 0, 4)
	healthBg.Position = UDim2.new(0.1, 0, 0.55, 0)
	healthBg.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	healthBg.BorderSizePixel = 0
	Instance.new("UICorner", healthBg).CornerRadius = UDim.new(1, 0)
	healthBg.Parent = bill

	local healthBar = Instance.new("Frame")
	healthBar.Size = UDim2.new(hum.Health / math.max(hum.MaxHealth, 1), 0, 1, 0)
	healthBar.BackgroundColor3 = Color3.fromRGB(80, 220, 80)
	healthBar.BorderSizePixel = 0
	Instance.new("UICorner", healthBar).CornerRadius = UDim.new(1, 0)
	healthBar.Parent = healthBg

	local distLabel = Instance.new("TextLabel")
	distLabel.Size = UDim2.new(1, 0, 0.35, 0)
	distLabel.Position = UDim2.new(0, 0, 0.65, 0)
	distLabel.BackgroundTransparency = 1
	distLabel.Text = ""
	distLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
	distLabel.Font = Enum.Font.Code
	distLabel.TextSize = 10
	distLabel.TextStrokeTransparency = 0.5
	distLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	distLabel.Parent = bill

	local highlight = Instance.new("Highlight")
	highlight.Name = "ESP_Highlight"
	highlight.Adornee = char
	highlight.FillColor = espColor
	highlight.FillTransparency = 0.82
	highlight.OutlineColor = espColor
	highlight.OutlineTransparency = 0
	highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	highlight.Enabled = showBox and espEnabled
	highlight.Parent = char

	-- BoxHandleAdornment: wireframe box that renders through walls via AlwaysOnTop
	local selectionBox = Instance.new("BoxHandleAdornment")
	selectionBox.Name        = "ESP_SelectionBox"
	selectionBox.Adornee     = hrp
	selectionBox.AlwaysOnTop = true
	selectionBox.ZIndex      = 5
	selectionBox.Size        = Vector3.new(4.5, 6.5, 4.5)  -- rough full-body size
	selectionBox.Color3      = espColor
	selectionBox.Transparency = 0
	selectionBox.Visible     = showBoxESP and espEnabled
	selectionBox.Parent      = workspace

	espObjects[plr] = {
		bill         = bill,
		nameLabel    = nameLabel,
		healthBar    = healthBar,
		healthBg     = healthBg,
		distLabel    = distLabel,
		highlight    = highlight,
		selectionBox = selectionBox,
		hrp          = hrp,
		hum          = hum,
		char         = char,
	}
end

local function refreshAllESP()
	for plr in pairs(espObjects) do removeESP(plr) end
	if not espEnabled then return end
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= player then createESP(plr) end
	end
end

Players.PlayerAdded:Connect(function(plr)
	plr.CharacterAdded:Connect(function()
		task.wait(1)
		if espEnabled then createESP(plr) end
	end)
end)
for _, plr in ipairs(Players:GetPlayers()) do
	if plr ~= player then
		plr.CharacterAdded:Connect(function()
			task.wait(1)
			if espEnabled then createESP(plr) end
		end)
	end
end
Players.PlayerRemoving:Connect(function(plr) removeESP(plr) end)

-- ── RENDER LOOP ──────────────────────────────────────────
RunService.RenderStepped:Connect(function()
	local localChar = player.Character
	local localHrp  = localChar and localChar:FindFirstChild("HumanoidRootPart")

	local count = 0
	for plr, data in pairs(espObjects) do
		if not plr.Character or not data.hrp or not data.hrp.Parent
		   or not data.char or not data.char.Parent then
			removeESP(plr)
			continue
		end

		count += 1

		-- Distance cull: hide everything if beyond espMaxDist
		local withinRange = true
		if localHrp and data.hrp then
			local d3 = (data.hrp.Position - localHrp.Position).Magnitude
			if d3 > espMaxDist then withinRange = false end
		end

		data.nameLabel.Visible = showNames    and espEnabled and withinRange
		data.healthBg.Visible  = showHealth   and espEnabled and withinRange
		data.distLabel.Visible = showDistance and espEnabled and withinRange

		if data.highlight and data.highlight.Parent then
			data.highlight.Enabled      = showBox and espEnabled and withinRange
			data.highlight.FillColor    = espColor
			data.highlight.OutlineColor = espColor
		end

		if data.selectionBox and data.selectionBox.Parent then
			data.selectionBox.Visible = showBoxESP and espEnabled
			data.selectionBox.Color3  = espColor
		end

		if not espEnabled then continue end

		data.nameLabel.Text       = plr.DisplayName
		data.nameLabel.TextColor3 = espColor

		local hum = data.hum
		if hum and hum.Parent then
			local pct = math.clamp(hum.Health / math.max(hum.MaxHealth, 1), 0, 1)
			data.healthBar.Size = UDim2.new(pct, 0, 1, 0)
			local r = math.clamp(2 * (1 - pct), 0, 1)
			local g = math.clamp(2 * pct,       0, 1)
			data.healthBar.BackgroundColor3 = Color3.new(r, g, 0.1)
		end

		if localHrp then
			local dist = math.floor((data.hrp.Position - localHrp.Position).Magnitude)
			data.distLabel.Text = dist .. " studs"
		end

	end

	playerCountLabel.Text = "Players tracked: " .. count
end)

-- ── ESP MASTER TOGGLE ────────────────────────────────────
espToggleBtn.MouseButton1Click:Connect(function()
	espEnabled = not espEnabled
	if espEnabled then
		espToggleBtn.Text       = "ESP  ON"
		espToggleBtn.TextColor3 = espColor
		TweenService:Create(espToggleBtn,    TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(20,45,20) }):Play()
		TweenService:Create(espToggleStroke, TweenInfo.new(0.15), { Color = espColor }):Play()
	else
		espToggleBtn.Text       = "ESP  OFF"
		espToggleBtn.TextColor3 = Color3.fromRGB(160,160,160)
		TweenService:Create(espToggleBtn,    TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(35,35,35) }):Play()
		TweenService:Create(espToggleStroke, TweenInfo.new(0.15), { Color = Color3.fromRGB(70,70,70) }):Play()
	end
	refreshAllESP()
end)

-- ── TAB SWITCHING ─────────────────────────────────────────
local function switchTab(tab)
	-- hide all panels first
	clientPanel.Visible = false
	espPanel.Visible    = false
	aimPanel.Visible    = false
	-- dim all tabs
	for _, t in ipairs({clientTab, espTab, aimTab}) do
		t.BackgroundColor3 = Color3.fromRGB(22,22,22)
		t.TextColor3       = Color3.fromRGB(120,120,120)
	end
	if tab == "client" then
		clientPanel.Visible = true
		clientTab.BackgroundColor3 = Color3.fromRGB(35,35,35)
		clientTab.TextColor3       = Color3.fromRGB(255,255,255)
		TweenService:Create(tabUnderline, TweenInfo.new(0.2, Enum.EasingStyle.Quad), { Position = UDim2.new(0,0,1,-2) }):Play()
	elseif tab == "esp" then
		espPanel.Visible = true
		espTab.BackgroundColor3 = Color3.fromRGB(35,35,35)
		espTab.TextColor3       = Color3.fromRGB(255,255,255)
		TweenService:Create(tabUnderline, TweenInfo.new(0.2, Enum.EasingStyle.Quad), { Position = UDim2.new(0.333,0,1,-2) }):Play()
	elseif tab == "aim" then
		aimPanel.Visible = true
		aimTab.BackgroundColor3 = Color3.fromRGB(35,35,35)
		aimTab.TextColor3       = Color3.fromRGB(255,255,255)
		TweenService:Create(tabUnderline, TweenInfo.new(0.2, Enum.EasingStyle.Quad), { Position = UDim2.new(0.666,0,1,-2) }):Play()
	end
end

clientTab.MouseButton1Click:Connect(function() switchTab("client") end)
espTab.MouseButton1Click:Connect(function()    switchTab("esp")    end)
aimTab.MouseButton1Click:Connect(function()    switchTab("aim")    end)

-- ── COLOR HELPERS ─────────────────────────────────────────
local function toHex(c)
	return string.format("#%02X%02X%02X",
		math.floor(c.R*255), math.floor(c.G*255), math.floor(c.B*255))
end

local function updateEspColor(hue)
	hue = math.clamp(hue, 0, 1)
	local col             = Color3.fromHSV(hue, 1, 0.9)
	knob.Position         = UDim2.new(hue, -10, 0.5, -10)
	knob.BackgroundColor3 = col
	hexLabel.Text         = toHex(col)
	espColor              = col
	if espEnabled then
		espToggleBtn.TextColor3 = col
		espToggleStroke.Color   = col
	end
	for _, data in pairs(espObjects) do
		data.nameLabel.TextColor3 = col
		if data.highlight and data.highlight.Parent then
			data.highlight.FillColor    = col
			data.highlight.OutlineColor = col
		end
	end
end

local function updateBgColor(hue)
	hue = math.clamp(hue, 0, 1)
	local col               = Color3.fromHSV(hue, 0.6, 0.15)
	bgKnob.Position         = UDim2.new(hue, -10, 0.5, -10)
	bgKnob.BackgroundColor3 = Color3.fromHSV(hue, 1, 0.9)
	bgHexLabel.Text         = toHex(col)
	bgBox.BackgroundColor3  = col
	bgStroke.Color          = Color3.fromHSV(hue, 0.5, 0.3)
end

local function updateAimColor(hue)
	hue = math.clamp(hue, 0, 1)
	local col               = Color3.fromHSV(hue, 1, 0.9)
	aimKnob.Position        = UDim2.new(hue, -10, 0.5, -10)
	aimKnob.BackgroundColor3 = col
	aimHexLabel.Text        = toHex(col)
	fovStroke.Color         = col
end

local function getHue(trk, inputX)
	return math.clamp((inputX - trk.AbsolutePosition.X) / trk.AbsoluteSize.X, 0, 1)
end

-- ── DRAG WINDOW ───────────────────────────────────────────
local draggingWindow = false
local dragStartMouse, dragStartPos

dragBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or
	   input.UserInputType == Enum.UserInputType.Touch then
		draggingWindow = true
		dragStartMouse = Vector2.new(input.Position.X, input.Position.Y)
		dragStartPos   = bgBox.Position
	end
end)

-- ── DRAG SLIDERS ──────────────────────────────────────────
local draggingSlider = false
local activeTrack    = nil

knob.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or
	   input.UserInputType == Enum.UserInputType.Touch then
		draggingSlider = true
		activeTrack    = "esp"
	end
end)

track.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or
	   input.UserInputType == Enum.UserInputType.Touch then
		draggingSlider = true
		activeTrack    = "esp"
		updateEspColor(getHue(track, input.Position.X))
	end
end)

bgKnob.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or
	   input.UserInputType == Enum.UserInputType.Touch then
		draggingSlider = true
		activeTrack    = "bg"
	end
end)

bgTrack.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or
	   input.UserInputType == Enum.UserInputType.Touch then
		draggingSlider = true
		activeTrack    = "bg"
		updateBgColor(getHue(bgTrack, input.Position.X))
	end
end)

-- ESP distance slider drag
local draggingEspDist = false
espDistKnob.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or
	   input.UserInputType == Enum.UserInputType.Touch then
		draggingEspDist = true
	end
end)
espDistTrack.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or
	   input.UserInputType == Enum.UserInputType.Touch then
		draggingEspDist = true
		local t = math.clamp((input.Position.X - espDistTrack.AbsolutePosition.X) / espDistTrack.AbsoluteSize.X, 0, 1)
		espMaxDist = math.floor(10 + t * 990)
		espDistKnob.Position = UDim2.new(t, -10, 0.5, -10)
		espDistFill.Size     = UDim2.new(t, 0, 1, 0)
		espDistLabel.Text    = "MAX DIST  ( " .. espMaxDist .. " studs )"
	end
end)

aimKnob.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or
	   input.UserInputType == Enum.UserInputType.Touch then
		draggingSlider = true
		activeTrack    = "aim"
	end
end)

aimTrack.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or
	   input.UserInputType == Enum.UserInputType.Touch then
		draggingSlider = true
		activeTrack    = "aim"
		updateAimColor(getHue(aimTrack, input.Position.X))
	end
end)

-- ── SHARED INPUT ──────────────────────────────────────────
UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or
	   input.UserInputType == Enum.UserInputType.Touch then
		draggingWindow  = false
		draggingSlider  = false
		activeTrack     = nil
		draggingEspDist = false
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or
	   input.UserInputType == Enum.UserInputType.Touch then
		if draggingWindow then
			local delta = Vector2.new(input.Position.X, input.Position.Y) - dragStartMouse
			bgBox.Position = UDim2.new(
				dragStartPos.X.Scale, dragStartPos.X.Offset + delta.X,
				dragStartPos.Y.Scale, dragStartPos.Y.Offset + delta.Y
			)
		elseif draggingEspDist then
			local t = math.clamp((input.Position.X - espDistTrack.AbsolutePosition.X) / espDistTrack.AbsoluteSize.X, 0, 1)
			espMaxDist = math.floor(10 + t * 990)
			espDistKnob.Position = UDim2.new(t, -10, 0.5, -10)
			espDistFill.Size     = UDim2.new(t, 0, 1, 0)
			espDistLabel.Text    = "MAX DIST  ( " .. espMaxDist .. " studs )"
		elseif draggingSlider then
			if activeTrack == "esp" then
				updateEspColor(getHue(track, input.Position.X))
			elseif activeTrack == "bg" then
				updateBgColor(getHue(bgTrack, input.Position.X))
			elseif activeTrack == "aim" then
				updateAimColor(getHue(aimTrack, input.Position.X))
			end
		end
	end
end)

-- ── L KEY TOGGLE ──────────────────────────────────────────
local visible = true

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == Enum.KeyCode.L then
		visible       = not visible
		bgBox.Visible = visible
		bgBox.Active  = visible
	end
end)