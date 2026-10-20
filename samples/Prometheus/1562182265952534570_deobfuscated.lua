-- This file was generated at discord.gg/syncrypt

local Players = game:GetService("Players")
local t2 = {
	value1 = game:GetService("TweenService"),
	value2 = game:GetService("UserInputService")
}
local RunService = game:GetService("RunService")

t2.value3 = Players.LocalPlayer
Players = t2.value3:WaitForChild("PlayerGui")

local CumHub_TweakerGUI = Players:FindFirstChild("CumHub_TweakerGUI")

if CumHub_TweakerGUI then
    CumHub_TweakerGUI:Destroy()
end
local t1 = {
	value7 = 21355818788568,
	value2 = "Color3"
}
CumHub_TweakerGUI = Color3
t1.value9 = 4982196996368
t1.value6 = "~\217\158w%\14U"
CumHub_TweakerGUI = CumHub_TweakerGUI.fromRGB
t1.value2 = 140
t1.value9 = "W\4[$\"\210\163"
t1.value3 = 110
t1.value4 = 255
t2.value4 = CumHub_TweakerGUI(t1.value2, t1.value3, t1.value4)
CumHub_TweakerGUI = Color3.fromRGB
t1.value3 = 225
t1.value4 = 240
t1.value2 = CumHub_TweakerGUI(t1.value3, t1.value4, 255)
t2.value5 = t1.value2
t1.value3 = Color3
t1.value6 = 179
t1.value5 = 77
t1.value3 = t1.value3.fromRGB(98, t1.value5, t1.value6)
t2.value6 = t1.value3
t1.value4 = Color3
t1.value8 = "\192v\244\202]\230\17"
t1.value3 = t1.value4.fromRGB
t1.value6 = 127
t1.value5 = 154
t1.value9 = 255
t1.value4 = t1.value3(t1.value5, t1.value6, t1.value9)
t2.value7 = t1.value4
t1.value4 = Color3.fromRGB
t1.value9 = 6
t1.value7 = 26
t1.value6 = 7
t1.value5 = t1.value4(t1.value6, t1.value9, t1.value7)
t1.value4 = Color3.fromRGB
t1.value9 = 34
t1.value7 = 29
t1.value8 = 64
t1.value6 = t1.value4(t1.value9, t1.value7, t1.value8)
t2.value8 = t1.value6
t1.value9 = Color3
t1.value8 = 37
t1.value9 = t1.value9.fromRGB(47, t1.value8, 95)
t2.value9 = t1.value9
t1.value7 = Color3
t1.value7 = t1.value7.fromRGB(240, 240, 255)
t2.value10 = t1.value7
t1.value7 = Color3.fromRGB
t1.value8 = t1.value7(150, 150, 190)
t2.value11 = t1.value8
t1.value8 = Color3.fromRGB
t2.value12 = t1.value8(245, 248, 255)
t2.value13 = 0.03
t2.value14 = 24
t2.value15 = "hover a control to see what it does"
t2.value16 = 400
t2.value17 = 560
t2.value18 = UDim2.fromOffset(t2.value16, t2.value17)
CumHub_TweakerGUI = true
t2.value19 = false
t2.value20 = "realistichomeinvasion"
t2.value21 = {}
t2.value22 = {}
t2.value23 = false
t2.value24 = 1
t2.value25 = false
function t2.value26(p1, p2, p3, p4, p5)
    local tween = t2.value1:Create(p1, TweenInfo.new(p3 or 0.2, p4 or Enum.EasingStyle.Quad, p5 or Enum.EasingDirection.Out), p2)

    tween:Play()

    return tween
end
function t2.value27(p6, p7, p8)
    local UICorner = Instance.new("UICorner")

    if not p8 then
        UICorner.CornerRadius = p8 or UDim.new(0, p7 or 8)
        UICorner.Parent = p6

        return UICorner
    end

    p8 = UDim.new(p7, 0)
    UICorner.CornerRadius = p8 or UDim.new(0, p7 or 8)
    UICorner.Parent = p6

    return UICorner
end
function t2.value28(p9, p10, p11, p12)
    local UIStroke = Instance.new("UIStroke")

    UIStroke.Color = p10
    UIStroke.Thickness = p11 or 1
    UIStroke.Transparency = p12 or 0
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke.Parent = p9

    return UIStroke
end
function t2.value29(p13, p14, p15, p16)
    local UIGradient = Instance.new("UIGradient")

    UIGradient.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, p14), ColorSequenceKeypoint.new(0.5, p15), ColorSequenceKeypoint.new(1, p14) })
    UIGradient.Rotation = p16 or 0
    UIGradient.Parent = p13

    return UIGradient
end
function t2.value30(p17, p18, p19, p20, p21, p22)
    local TextButton = Instance.new("TextButton")

    TextButton.Size = p20
    TextButton.Position = p21 or UDim2.new()
    TextButton.BackgroundColor3 = p19
    TextButton.BorderSizePixel = 0
    TextButton.AutoButtonColor = false
    TextButton.Text = p18
    TextButton.TextColor3 = Color3.new(1, 1, 1)
    TextButton.Font = Enum.Font.GothamBold
    TextButton.TextSize = p22 or 12
    TextButton.Parent = p17
    t2.value27(TextButton, 6)

    return TextButton
end
function t2.value31(p23, p24, p25, p26, p27, p28, p29)
    local v11 = t2.value30(p23, p24, p25, p27, p28, p29)

    v11.MouseEnter:Connect(function()
        local t3 = {
			["BackgroundColor3"] = p26
		}

        t2.value26(v11, t3, 0.15)
    end)
    v11.MouseLeave:Connect(function()
        local t4 = {
			["BackgroundColor3"] = p25
		}

        t2.value26(v11, t4, 0.15)
    end)

    return v11
end
function t2.value32(_, p30)
    if not p30 then
        return
    end
end
t2.value33 = Instance.new("ScreenGui")
t2.value33.Name = "CumHub_TweakerGUI"
t2.value33.ResetOnSpawn = false
t2.value33.IgnoreGuiInset = true
t2.value33.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
t2.value33.Enabled = false
t2.value33.Parent = Players
t2.value34 = Instance.new("Frame")
t2.value34.Size = t2.value18
t2.value34.Position = UDim2.fromOffset(30, 40)
t2.value34.BackgroundTransparency = 1
t2.value34.Parent = t2.value33
t2.value35 = Instance.new("Frame")
t2.value35.Size = t2.value18
t2.value35.BackgroundColor3 = t1.value5
t2.value35.BorderSizePixel = 0
t2.value35.ClipsDescendants = true
t2.value35.Parent = t2.value34
t2.value27(t2.value35, t2.value14)
t2.value22.frameGrad = t2.value29(t2.value28(t2.value35, Color3.new(1, 1, 1), 2, 0), t2.value4, t2.value5, 0)
t2.value36 = Instance.new("UIScale")
t2.value36.Scale = 1
t2.value36.Parent = t2.value35
t2.value37 = {
	["stars"] = {},
	["blobs"] = {},
	["swim"] = {},
	["SEG"] = 14,
	["pulse"] = 0
}
t2.value38 = Instance.new("CanvasGroup")
t2.value38.Name = "Cosmos"
t2.value38.Size = UDim2.fromScale(1, 1)
t2.value38.BackgroundTransparency = 1
t2.value38.BorderSizePixel = 0
t2.value38.ClipsDescendants = true
t2.value38.Parent = t2.value35
t2.value27(t2.value38, t2.value14)
Players = Instance.new("Frame")
Players.Name = "Fill"
Players.Size = UDim2.fromScale(1, 1)
Players.BackgroundColor3 = Color3.new(1, 1, 1)
Players.BorderSizePixel = 0
Players.ZIndex = 0
Players.Parent = t2.value38
local UIGradient = Instance.new("UIGradient")

UIGradient.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(26, 21, 58)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(7, 6, 26)), ColorSequenceKeypoint.new(1, Color3.fromRGB(6, 14, 39)) })
UIGradient.Rotation = 70
UIGradient.Parent = Players
Players = { Color3.fromRGB(140, 110, 255), Color3.fromRGB(255, 110, 237), Color3.fromRGB(110, 189, 255) }
UIGradient = t1.value1
UIGradient = t1.value1
local v15 = true
local Frame, parent
for i = 1, CumHub_TweakerGUI and 3 or 0 do
    Frame = Instance.new("Frame")
    parent = i * 50 + 230
    Frame.Size = UDim2.fromOffset(parent, parent)
    Frame.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame.BackgroundColor3 = Players[i]
    Frame.BackgroundTransparency = 0.86
    Frame.BorderSizePixel = 0
    Frame.Parent = t2.value38
    t2.value27(Frame, 0.5, true)
    t2.value37.blobs[i] = {
		["f"] = Frame,
		["ph"] = i * 2.1,
		["cx"] = t2.value16 * (i * 0.3 + 0.2),
		["cy"] = t2.value17 * (i * 0.3 + 0.15)
	}
end
t2.value39 = Random.new(42)
UIGradient = t1.value1
UIGradient = t1.value1
local Frame2
for i = 1, CumHub_TweakerGUI and 70 or 0 do
    Frame2 = Instance.new("Frame")
    Frame = t2.value39:NextInteger(1, 2)
    Frame2.Size = UDim2.fromOffset(Frame, Frame)
    Frame2.Position = UDim2.fromOffset(t2.value39:NextInteger(0, t2.value16), t2.value39:NextInteger(0, t2.value17))
    Frame2.BackgroundColor3 = Color3.new(1, 1, 1)
    Frame2.BackgroundTransparency = 0.3 + t2.value39:NextNumber() * 0.5
    Frame2.BorderSizePixel = 0
    Frame2.Parent = t2.value38

    if i <= 25 then
        t2.value37.stars[#t2.value37.stars + 1] = {
			["f"] = Frame2,
			["ph"] = t2.value39:NextNumber() * 6.28,
			["sp"] = 1 + t2.value39:NextNumber() * 2
		}
    end
end
CumHub_TweakerGUI = Instance.new("Frame")
CumHub_TweakerGUI.AnchorPoint = Vector2.new(0.5, 0.5)
CumHub_TweakerGUI.Size = UDim2.fromOffset(90, 90)
CumHub_TweakerGUI.BackgroundColor3 = Color3.new(1, 1, 1)
CumHub_TweakerGUI.BackgroundTransparency = 0.05
CumHub_TweakerGUI.BorderSizePixel = 0
CumHub_TweakerGUI.ZIndex = 2
CumHub_TweakerGUI.Visible = t2.value19
CumHub_TweakerGUI.Parent = t2.value38
t2.value27(CumHub_TweakerGUI, 0.5, true)
UIGradient = Instance.new("UIGradient")
UIGradient.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(169, 146, 255))
UIGradient.Rotation = 45
UIGradient.Parent = CumHub_TweakerGUI
t2.value37.orb = CumHub_TweakerGUI
t2.value37.halos = {}
CumHub_TweakerGUI = t2.value19 and 3
UIGradient = t1.value1
for i = 1, CumHub_TweakerGUI or 0 do
    Frame2 = Instance.new("Frame")
    Frame2.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame2.BackgroundColor3 = Color3.fromRGB(198, 183, 255)
    Frame2.BackgroundTransparency = 0.88
    Frame2.BorderSizePixel = 0
    Frame2.ZIndex = 2
    Frame2.Parent = t2.value38
    t2.value27(Frame2, 0.5, true)
    t2.value37.halos[i] = Frame2
end
t2.value37.ripples = {}
for i = 1, 2 do
    Frame2 = Instance.new("Frame")
    Frame2.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame2.Size = UDim2.fromOffset(70, 70)
    Frame2.BackgroundTransparency = 1
    Frame2.BorderSizePixel = 0
    Frame2.ZIndex = 5
    Frame2.Parent = t2.value38
    t2.value27(Frame2, 0.5, true)
    t2.value37.ripples[i] = {
		["f"] = Frame2,
		["st"] = t2.value28(Frame2, Color3.fromRGB(198, 183, 255), i == 1 and 3 or 5, 1),
		["t"] = 1,
		["max"] = i == 1 and 260 or 360
	}
end
t2.value37.sparks = {}
for i = 1, 18 do
    Frame2 = Instance.new("Frame")
    Frame2.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame2.Size = UDim2.fromOffset(4, 4)
    Frame2.BackgroundColor3 = Color3.new(1, 1, 1)
    Frame2.BackgroundTransparency = 1
    Frame2.BorderSizePixel = 0
    Frame2.ZIndex = 5
    Frame2.Parent = t2.value38
    t2.value27(Frame2, 0.5, true)
    t2.value37.sparks[i] = {
		["f"] = Frame2,
		["x"] = 0,
		["y"] = 0,
		["vx"] = 0,
		["vy"] = 0,
		["life"] = 1
	}
end
function t2.value37.burst(p31, p32, p33, p34, p35, p36, p37)
    for _, spark in ipairs(t2.value37.sparks) do
        if p33 <= 0 then
            return
        end

        if spark.life >= 1 then
            local vy = t2.value39:NextNumber() * (p35 - p34)
            local value39 = t2.value39

            vy = p34 + vy
            value39 = p36 + value39:NextNumber() * (p37 - p36)

            local vx = math.cos(vy) * value39

            vy = math.sin(vy) * value39
            spark.x = p31
            spark.y = p32
            spark.vx = vx
            spark.vy = vy
            p33 = p33 - 1
            spark.life = 0
        end
    end
end
CumHub_TweakerGUI = function(p38, p39)
    p38.entering = false
    p38.enter = 0
    p38.fade = p39 and 1 or 0

    local x, y

    if p39 then
        x = t2.value39:NextInteger(0, t2.value16)
        y = t2.value39:NextInteger(0, t2.value17)
        p38.x = x
        p38.y = y
    else
        x = t2.value39:NextInteger(1, 4)

        if x == 1 then
            x = t2.value39:NextInteger(0, t2.value17)
            p38.x = -30
            p38.y = x
        elseif x == 2 then
            x = t2.value16 + 30
            y = t2.value39:NextInteger(0, t2.value17)
            p38.x = x
            p38.y = y
        elseif x == 3 then
            p38.x = t2.value39:NextInteger(0, t2.value16)
            p38.y = -30
        else
            x = t2.value39:NextInteger(0, t2.value16)
            y = t2.value17 + 30
            p38.x = x
            p38.y = y
        end
    end

    p38.ang = t2.value39:NextNumber() * 6.28
end
t2.value37.respawn = CumHub_TweakerGUI
local Frame3, Frame4, v33, value1
for i = 1, 0 do
    Frame = t2.value39
    Frame = {
		["spd"] = Frame:NextInteger(26, 50),
		["size"] = t2.value39:NextInteger(7, 11),
		["ph"] = t2.value39:NextNumber() * 6.28,
		["beat"] = t2.value39:NextNumber() * 2 + 6,
		["segs"] = {}
	}
    CumHub_TweakerGUI(Frame, true)
    parent = Instance.new("Frame")
    parent.AnchorPoint = Vector2.new(0.5, 0.5)
    parent.Size = UDim2.fromOffset(Frame.size * 1.6, Frame.size * 1)
    parent.BackgroundColor3 = t2.value12
    parent.BorderSizePixel = 0
    parent.ZIndex = 4
    parent.Parent = t2.value38
    t2.value27(parent, 0.5, true)
    Frame.hst = t2.value28(parent, Color3.fromRGB(180, 195, 255), 2, 0.55)
    Frame3 = Instance.new("Frame")
    Frame3.Size = UDim2.fromScale(0.4, 0.3)
    Frame3.Position = UDim2.fromScale(0.45, 0.12)
    Frame3.BackgroundColor3 = Color3.new(1, 1, 1)
    Frame3.BackgroundTransparency = 0.2
    Frame3.BorderSizePixel = 0
    Frame3.Parent = parent
    t2.value27(Frame3, 0.5, true)
    Frame.head = parent
    Frame.shine = Frame3
    Frame.bt = {}

    for i2 = 1, t2.value37.SEG do
        Frame4 = Instance.new("Frame")
        Frame4.AnchorPoint = Vector2.new(0.5, 0.5)
        v33 = i2 <= 3
        value1 = t1.value1

        if v33 then
            v33 = Frame.size * 0.5
        end

        if not v33 then
            v33 = Frame.size * 0.3 * (1 - (i2 - 3) / (t2.value37.SEG - 3) * 0.8)
            v33 = math.max(1.3, v33)
        end

        t1.value1 = value1
        Frame.th = Frame.th or {}
        Frame.th[i2] = v33
        Frame4.Size = UDim2.fromOffset(Frame.size * 0.6, v33)
        Frame4.BackgroundColor3 = Color3.fromRGB(225, 232, 255)
        Frame.bt[i2] = 0.05 + i2 / t2.value37.SEG * 0.7
        Frame4.BackgroundTransparency = Frame.bt[i2]
        Frame4.BorderSizePixel = 0
        Frame4.ZIndex = 3
        Frame4.Parent = t2.value38
        t2.value27(Frame4, 0.5, true)
        Frame.segs[i2] = Frame4
    end

    t2.value37.swim[#t2.value37.swim + 1] = Frame
end
if v15 then
    CumHub_TweakerGUI = {
		["active"] = true,
		["tweens"] = {},
		["busy"] = {}
	}
    UIGradient = Color3.new(1, 1, 1)
    local color3 = Color3.new(0, 0, 0)
    Frame2 = function(p40, p41, p42, p43, p44)
        local tween = t2.value1:Create(p40, TweenInfo.new(p42, p43 or Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, p44 or false), p41)

        tween:Play()
        CumHub_TweakerGUI.tweens[#CumHub_TweakerGUI.tweens + 1] = tween

        return tween
    end
    function CumHub_TweakerGUI.setActive(p45)
        CumHub_TweakerGUI.active = p45

        for _, tween in ipairs(CumHub_TweakerGUI.tweens) do
            if p45 then
                if tween.PlaybackState == Enum.PlaybackState.Paused then
                    tween:Play()
                end
            elseif tween.PlaybackState == Enum.PlaybackState.Playing then
                tween:Pause()
            end
        end
    end
    v15, Frame, parent = ipairs(t2.value37.stars)
    Frame3 = function(p46, p47, p48, p49, p50)
        local Frame5 = Instance.new("Frame")

        Frame5.AnchorPoint = Vector2.new(0.5, 0.5)
        Frame5.Size = UDim2.fromOffset(p47, p47)
        Frame5.BackgroundColor3 = p48
        Frame5.BackgroundTransparency = p49
        Frame5.BorderSizePixel = 0
        Frame5.ZIndex = p50
        Frame5.Parent = p46
        t2.value27(Frame5, 0.5, true)

        return Frame5
    end
    local function parent2(p51, p52, p53, p54)
        local tween = t2.value39:NextNumber()

        p51.Position = UDim2.fromOffset(-30 + tween * (t2.value16 + 60), p52 + p53 * tween)

        local uDim2 = UDim2.fromOffset(t2.value16 + 30, p52 + p53)

        tween = t2.value1:Create(p51, TweenInfo.new(p54 * (1 - tween) + 0.05, Enum.EasingStyle.Linear), {
			["Position"] = uDim2
		})
        uDim2 = function()
            p51.Position = UDim2.fromOffset(-30, p52)
            Frame2(p51, {
				["Position"] = uDim2
			}, p54)
        end
        tween.Completed:Connect(uDim2)
        tween:Play()
        CumHub_TweakerGUI.tweens[#CumHub_TweakerGUI.tweens + 1] = tween
    end
    Frame4 = function(p55)
        local value39 = t2.value39:NextInteger(1, 4)
        local x

        if value39 == 1 then
            value39 = t2.value39:NextInteger(0, t2.value17)
            x = -40
        elseif value39 == 2 then
            x = t2.value16 + 40
            value39 = t2.value39
            v102 = t2.value17
            value39 = value39:NextInteger(0, v102)
        elseif value39 == 3 then
            x = t2.value39:NextInteger(0, t2.value16)
            value39 = -40
        else
            x = t2.value39:NextInteger(0, t2.value16)
            value39 = t2.value17 + 40
        end

        local vx = t2.value16 * (0.2 + 0.6 * t2.value39:NextNumber())
        local vy = t2.value17 * (0.2 + 0.6 * t2.value39:NextNumber())

        vx = vx - x
        vy = vy - value39

        local v49 = vx * vx + vy * vy

        v49 = math.sqrt(v49)
        v49 = math.max(1, v49)
        vx = vx / v49
        vy = vy / v49
        p55.x = x
        p55.y = value39
        p55.vx = vx
        p55.vy = vy
    end
    v33 = function(p56, p57, p58, p59, p60)
        local tween = t2.value1:Create(p56, TweenInfo.new(p58, p59 or Enum.EasingStyle.Quad, p60 or Enum.EasingDirection.Out), p57)

        tween:Play()

        return tween
    end
    while true do
        parent, value1 = v15(Frame, parent)

        if not parent then
            break
        end

        Frame2(value1.f, {
			["BackgroundTransparency"] = 0.9
		}, 1.2 + t2.value39:NextNumber() * 2, Enum.EasingStyle.Sine, true)
    end
    for _, blob in ipairs(t2.value37.blobs) do
        blob.f.Position = UDim2.fromOffset(blob.cx - 45, blob.cy - 55)
        Frame2(blob.f, {
			["Position"] = UDim2.fromOffset(blob.cx + 45, blob.cy + 55)
		}, 9 + blob.ph * 1.5, Enum.EasingStyle.Sine, true)
    end
    v15 = {
		{
			["x"] = 0.22,
			["y"] = 0.3,
			["r"] = 60,
			["spin"] = 90,
			["c"] = Players[1]
		},
		{
			["x"] = 0.78,
			["y"] = 0.72,
			["r"] = 48,
			["spin"] = -110,
			["c"] = Players[3]
		}
	}
    local Frame5
    for _, v in ipairs(v15) do
        value1 = v.r
        Frame5 = Instance.new("Frame")
        Frame5.AnchorPoint = Vector2.new(0.5, 0.5)
        Frame5.Size = UDim2.fromOffset(value1 * 2, value1 * 2)
        Frame5.Position = UDim2.fromOffset(v.x * t2.value16, v.y * t2.value17)
        Frame5.BackgroundTransparency = 1
        Frame5.BorderSizePixel = 0
        Frame5.ZIndex = 2
        Frame5.Parent = t2.value38
        Frame3(Frame5, value1 * 2.1, v.c, 0.9, 1).Position = UDim2.fromScale(0.5, 0.5)
        Frame3(Frame5, value1 * 0.9, v.c, 0.82, 1).Position = UDim2.fromScale(0.5, 0.5)

        for i = 0, 2 do
            local v57 = i

            for i2 = 1, 9 do
                local v59 = i2 / 9
                local v60 = v57 * 2.0944 + v59 * 3.3 + (t2.value39:NextNumber() - 0.5) * 0.3
                local v61 = value1 * (0.12 + 0.88 * v59) + (t2.value39:NextNumber() - 0.5) * 5

                Frame3(Frame5, 2 + (1 - v59) * 1.8 + t2.value39:NextNumber() * 0.8, v.c:Lerp(UIGradient, 0.9 - v59 * 0.9), 0.1 + v59 * 0.6, 2).Position = UDim2.fromOffset(value1 + math.cos(v60) * v61, value1 + math.sin(v60) * v61)
            end
        end

        Frame3(Frame5, value1 * 0.34, Color3.fromRGB(255, 244, 220), 0.4, 3).Position = UDim2.fromScale(0.5, 0.5)
        Frame3(Frame5, value1 * 0.14, UIGradient, 0.05, 3).Position = UDim2.fromScale(0.5, 0.5)
        value1 = {
			["Rotation"] = v.spin > 0 and 360 or -360
		}
        v = v.spin
        Frame2(Frame5, value1, (math.abs(v)))
    end
    v15 = t2.value16 * 0.16
    Frame = t2.value17 * 0.89
    Frame3(t2.value38, 92, Color3.fromRGB(255, 140, 80), 0.92, 1).Position = UDim2.fromOffset(v15, Frame)
    parent = function(p61, p62, p63, p64, p65)
        local v62 = Frame3(t2.value38, p61, UIGradient, 1, 3)

        v62.Position = UDim2.fromOffset(v15, Frame)
        v62 = t2.value28(v62, UIGradient, p62, 0)

        local UIGradient2 = Instance.new("UIGradient")

        UIGradient2.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, p63), ColorSequenceKeypoint.new(1, p64) })
        UIGradient2.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.55, 0.85), NumberSequenceKeypoint.new(1, 0) })
        UIGradient2.Parent = v62
        Frame2(UIGradient2, {
			["Rotation"] = p65 > 0 and 360 or -360
		}, (math.abs(p65)))
    end
    parent(52, 4, Color3.fromRGB(255, 190, 110), Color3.fromRGB(255, 90, 140), 5)
    parent(68, 2, Color3.fromRGB(140, 200, 255), Color3.fromRGB(190, 140, 255), -8)
    parent = Frame3(t2.value38, 30, color3, 0, 4)
    parent.Position = UDim2.fromOffset(v15, Frame)
    t2.value28(parent, Color3.fromRGB(255, 220, 170), 1, 0.4)
    v15 = Players[2]
    Frame = Frame3(t2.value38, 44, UIGradient, 0.04, 2)
    parent = Instance.new("UIGradient")
    parent.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, v15:Lerp(UIGradient, 0.45)), ColorSequenceKeypoint.new(0.5, v15:Lerp(color3, 0.35)), ColorSequenceKeypoint.new(1, v15:Lerp(color3, 0.85)) })
    parent.Rotation = 35
    parent.Parent = Frame
    t2.value28(Frame, v15:Lerp(UIGradient, 0.5), 1.5, 0.75)
    parent2(Frame, t2.value17 * 0.64, 0, 150)
    local NextInteger
    for i = 1, 8 do
        parent = t2.value39:NextInteger(5, 13)
        value1 = 100 + t2.value39:NextInteger(0, 50)
        Frame5 = Instance.new("Frame")
        Frame5.AnchorPoint = Vector2.new(0.5, 0.5)
        Frame5.Size = UDim2.fromOffset(parent, parent * (0.7 + t2.value39:NextNumber() * 0.3))
        Frame5.BackgroundColor3 = Color3.fromRGB(value1, value1 - 8, value1 - 14)
        Frame5.BackgroundTransparency = 0.08
        Frame5.BorderSizePixel = 0
        Frame5.ZIndex = 3
        Frame5.Parent = t2.value38
        t2.value27(Frame5, 0.35, true)
        Frame3(Frame5, parent * 0.35, Color3.fromRGB(value1 + 50, value1 + 40, value1 + 30), 0.35, 4).Position = UDim2.fromScale(0.3, 0.3)
        Frame3(Frame5, parent * 0.28, Color3.fromRGB(value1 - 45, value1 - 50, value1 - 55), 0.15, 4).Position = UDim2.fromScale(0.66, 0.62)
        parent = t2.value17 * (0.04 + 0.92 * t2.value39:NextNumber())
        value1 = t2.value39:NextNumber()

        local value39 = t2.value39

        NextInteger = value39.NextInteger
        parent2(Frame5, parent, (value1 - 0.5) * t2.value17 * 0.5, NextInteger(value39, 40, 95))
        Frame5.Rotation = t2.value39:NextNumber() * 360
        Frame2(Frame5, {
			["Rotation"] = Frame5.Rotation + (t2.value39:NextNumber() < 0.5 and -360 or 360)
		}, t2.value39:NextInteger(18, 50))
    end
    for _, v in ipairs({
		{ 0.84, 0.17, 1 },
		{ 0.12, 0.12, 0.7 },
		{ 0.9, 0.55, 0.6 },
		{ 0.45, 0.06, 0.6 },
		{ 0.6, 0.93, 0.7 }
	}) do
        parent = v[1] * t2.value16
        parent2 = v[2] * t2.value17
        v = v[3]
        value1 = 1.4 + t2.value39:NextNumber() * 1.6
        Frame5 = Players[2]
        Frame3(t2.value38, 16 * v, Frame5, 0.82, 2).Position = UDim2.fromOffset(parent, parent2)
        Frame3(t2.value38, 3, UIGradient, 0.1, 3).Position = UDim2.fromOffset(parent, parent2)

        for _, v2 in ipairs({ true, false }) do
            local Frame6 = Instance.new("Frame")
            local vector2New = Vector2.new

            t1.value10 = 0.5
            t1.value11 = 0.5
            Frame6.AnchorPoint = vector2New(t1.value11, t1.value10)
            Frame6.Position = UDim2.fromOffset(parent, parent2)
            vector2New = t1.value1
            t1.value10 = t1.value1

            local s1 = "Size"

            t1.value11 = v2

            if v2 then
                t1.value11 = UDim2.fromOffset(6, 2)
            end

            local value11 = t1.value11

            t1.value1 = t1.value10

            if not t1.value11 then
                value11 = UDim2.fromOffset(2, 6)
            end

            Frame6[s1] = value11
            Frame6.BackgroundColor3 = UIGradient
            Frame6.BackgroundTransparency = 0.85
            Frame6.BorderSizePixel = 0
            Frame6.ZIndex = 3
            Frame6.Parent = t2.value38
            t1.value13 = vector2New
            t1.value11 = "Size"

            if v2 then
                v2 = UDim2.fromOffset(24 * v, 2)
            end

            t1.value12 = v2
            v2 = t1.value12
            vector2New = t1.value13
            t1.value10 = v2
            t1.value1 = vector2New

            if not t1.value12 then
                t1.value10 = UDim2.fromOffset(2, 24 * v)
            end

            Frame2(Frame6, {
				[v1987] = t1.value10,
				["BackgroundTransparency"] = 0.1
			}, value1, Enum.EasingStyle.Quint, true)
        end
    end
    color3 = Instance.new("Frame")
    color3.AnchorPoint = Vector2.new(0.5, 0.5)
    color3.Size = UDim2.fromOffset(140, 16)
    color3.BackgroundTransparency = 1
    color3.BorderSizePixel = 0
    color3.ZIndex = 4
    color3.Visible = false
    color3.Parent = t2.value38
    Frame2 = function(p66, p67, p68, p69, p70)
        local Frame6 = Instance.new("Frame")

        Frame6.AnchorPoint = Vector2.new(1, 0.5)
        Frame6.Position = UDim2.new(0, 132, 0.5, 0)
        Frame6.Size = UDim2.fromOffset(p66, p67)
        Frame6.BackgroundColor3 = p68
        Frame6.BorderSizePixel = 0
        Frame6.Rotation = p70
        Frame6.Parent = color3
        t2.value27(Frame6, 0.5, true)

        local UIGradient2 = Instance.new("UIGradient")

        UIGradient2.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, p69) })
        UIGradient2.Parent = Frame6
    end
    Frame2(132, 3, Color3.fromRGB(150, 205, 255), 0, 0)
    Frame2(88, 8, Color3.fromRGB(255, 205, 150), 0.55, 6)
    Frame3(color3, 20, Color3.fromRGB(170, 210, 255), 0.72, 1).Position = UDim2.new(0, 132, 0.5, 0)
    Frame3(color3, 6, Color3.fromRGB(240, 248, 255), 0, 2).Position = UDim2.new(0, 132, 0.5, 0)
    color3 = {}
    parent = function()
        if CumHub_TweakerGUI.busy.comet then
            return
        end
    end
    for i = 1, 6 do
        parent2 = Instance.new("Frame")
        parent2.AnchorPoint = Vector2.new(0.5, 0.5)
        parent2.Size = UDim2.fromOffset(72, 2)
        parent2.BackgroundColor3 = UIGradient
        parent2.BorderSizePixel = 0
        parent2.ZIndex = 4
        parent2.Visible = false
        parent2.Parent = t2.value38
        Frame4 = Instance.new("UIGradient")
        Frame4.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0) })
        Frame4.Parent = parent2
        color3[i] = {
			["f"] = parent2,
			["busy"] = false
		}
    end
    local v78
    Frame2 = function()
        task.spawn(function()
            local v79 = 0.6 + t2.value39:NextNumber() * 0.3

            if not (t2.value39:NextNumber() < 0.5) then
                for i = 1, 6 do
                    if not t2.value33.Parent then
                        return
                    end

                    v78(t2.value16 * (0.05 + 0.9 * t2.value39:NextNumber()), -20, v79 + (t2.value39:NextNumber() - 0.5) * 0.08, 380 + t2.value39:NextInteger(0, 140))
                    task.wait(0.12 + t2.value39:NextNumber() * 0.2)
                end

                return
            end

            v79 = 3.141592653589793 - v79

            for i = 1, 6 do
                if not t2.value33.Parent then
                    return
                end

                v78(t2.value16 * (0.05 + 0.9 * t2.value39:NextNumber()), -20, v79 + (t2.value39:NextNumber() - 0.5) * 0.08, 380 + t2.value39:NextInteger(0, 140))
                task.wait(0.12 + t2.value39:NextNumber() * 0.2)
            end
        end)
    end
    v15 = function()
        local v82 = 0.45 + t2.value39:NextNumber() * 0.5

        if not (t2.value39:NextNumber() < 0.5) then
            v78(t2.value16 * (0.1 + 0.8 * t2.value39:NextNumber()), -20 + t2.value17 * 0.3 * t2.value39:NextNumber(), v82, 420 + t2.value39:NextInteger(0, 120))

            return
        end

        v82 = 3.141592653589793 - v82
        v78(t2.value16 * (0.1 + 0.8 * t2.value39:NextNumber()), -20 + t2.value17 * 0.3 * t2.value39:NextNumber(), v82, 420 + t2.value39:NextInteger(0, 120))
    end
    v78 = function(p71, p72, p73, p74)
        for _, v in ipairs(color3) do
            if not v.busy then
                v.busy = true
                v.f.Rotation = math.deg(p73)
                v.f.Position = UDim2.fromOffset(p71, p72)
                v.f.BackgroundTransparency = 0
                v.f.Visible = true

                local v85 = 260 + t2.value39:NextInteger(0, 120)

                v33(v.f, {
					["Position"] = UDim2.fromOffset(p71 + math.cos(p73) * v85, p72 + math.sin(p73) * v85),
					["BackgroundTransparency"] = 1
				}, v85 / p74, Enum.EasingStyle.Quad, Enum.EasingDirection.In).Completed:Connect(function()
                    v.f.Visible = false
                    v.busy = false
                end)

                return
            end
        end
    end
    color3 = {
		["deb"] = {}
	}
    Players = Players[3]
    color3.puff = Frame3(t2.value38, 20, Players, 1, 1)
    color3.glow = Frame3(t2.value38, 8, Color3.fromRGB(255, 220, 170), 1, 2)
    color3.r1 = Frame3(t2.value38, 10, UIGradient, 1, 2)
    color3.s1 = t2.value28(color3.r1, Color3.fromRGB(255, 205, 150), 2, 1)
    color3.r2 = Frame3(t2.value38, 6, UIGradient, 1, 2)
    color3.s2 = t2.value28(color3.r2, Color3.fromRGB(190, 170, 255), 1.5, 1)
    for i = 1, 8 do
        color3.deb[i] = Frame3(t2.value38, 3, UIGradient, 1, 3)
    end
    Players = {
		color3.puff,
		color3.glow,
		color3.r1,
		color3.r2
	}
    for Frame3, parent2 in ipairs(Players) do

        parent2.Visible = false
    end
    for _, v in ipairs(color3.deb) do
        v.Visible = false
    end
    Players = function()
        if CumHub_TweakerGUI.busy.nova then
            return
        end
    end
    task.spawn(function()
        task.wait(2.5)

        while t2.value33.Parent do
            if CumHub_TweakerGUI.active then
                local v89 = t2.value39:NextNumber()

                if v89 < 0.4 then
                    v15()
                elseif v89 < 0.6 then
                    parent()
                elseif v89 < 0.78 then
                    Players()
                elseif v89 < 0.9 then
                    Frame2()
                else
                    v15()
                end
            end

            task.wait(3.5 + t2.value39:NextNumber() * 4.5)
        end
    end)
    t2.value37.static = true
    t2.value37.gx = CumHub_TweakerGUI
end
function t2.value40(p75, p76)
    local v90, v91, v92 = ipairs(t2.value37.stars)

    while true do
        v92, v173 = v90(v91, v92)

        if not v92 then
            break
        end

        v179 = v173.f
        v173 = p75 * v173.sp + v173.ph
        v179.BackgroundTransparency = math.sin(v173) * 0.4 + 0.45
    end

    local cx, v94

    for _, blob in ipairs(t2.value37.blobs) do
        v173 = blob.f
        v179 = UDim2.fromOffset
        cx = blob.cx
        v94 = p75 * 0.25 + blob.ph
        cx = cx + math.sin(v94) * 50
        v94 = blob.cy
        blob = p75 * 0.2 + blob.ph
        v173.Position = v179(cx, v94 + math.cos(blob) * 60)
    end

    v90 = t2.value16 / 2
    v91 = p75 * 0.3
    v90 = v90 + math.sin(v91) * 110
    v91 = t2.value17 * 0.55
    v92 = p75 * 0.23
    v91 = v91 + math.cos(v92) * 160
    t2.value37.orb.Position = UDim2.fromOffset(v90, v91)
    v92 = 90 + t2.value37.pulse * 18
    t2.value37.orb.Size = UDim2.fromOffset(v92, v92)
    v92 = t2.value37

    local v97 = t2.value37.pulse - p76 * 1.5

    v92.pulse = math.max(0, v97)

    local v98

    for i, halo in ipairs(t2.value37.halos) do
        v94 = 90 + i * 34
        v98 = p75 * 2 + i
        v94 = v94 + math.sin(v98) * 8 + t2.value37.pulse * 40
        halo.Size = UDim2.fromOffset(v94, v94)
        halo.Position = UDim2.fromOffset(v90, v91)
        halo.BackgroundTransparency = 0.9 - t2.value37.pulse * 0.25 + i * 0.015
    end

    local v101

    v92, v97, v101 = ipairs(t2.value37.ripples)

    while true do
        v101, cx = v92(v97, v101)

        if not v101 then
            break
        end

        if cx.t < 1 then
            v94 = cx.t + p76 / 0.9
            cx.t = math.min(1, v94)
            v94 = 70 + cx.t * (cx.max - 70)
            cx.f.Size = UDim2.fromOffset(v94, v94)
            cx.f.Position = UDim2.fromOffset(v90, v91)
            cx.st.Transparency = 0.15 + cx.t * 0.85
        end
    end

    for _, spark in ipairs(t2.value37.sparks) do
        if spark.life < 1 then
            cx = spark.life + p76 / 0.7
            spark.life = math.min(1, cx)
            cx = 1 - 2.5 * p76
            cx = math.max(0, cx)
            v94 = "vx"
            spark[v94] = spark[v94] * cx
            v94 = "vy"
            spark[v94] = spark[v94] * cx
            cx = "x"
            v94 = spark.vx
            spark[cx] = spark[cx] + v94 * p76
            cx = "y"
            v94 = spark.vy
            spark[cx] = spark[cx] + v94 * p76
            cx = 5 * (1 - spark.life) + 1
            spark.f.Size = UDim2.fromOffset(cx, cx)
            spark.f.Position = UDim2.fromOffset(spark.x, spark.y)
            spark.f.BackgroundTransparency = spark.life
        end
    end

    v92 = t2.value37.SEG

    for _, v in ipairs(t2.value37.swim) do
        v94 = v90 - v.x
        v98 = v91 - v.y

        local v106 = v94 * v94 + v98 * v98

        v106 = math.sqrt(v106)

        local s2 = "ang"

        v94 = ((math.atan2(v98, v94) - v.ang + 3.141592653589793) % 6.283185307179586 - 3.141592653589793) * 0.9 * p76
        v98 = p75 * 2 + v.ph
        v98 = math.sin(v98)
        v[s2] = v[s2] + (v94 + v98 * p76 * 0.8)
        v94 = v.ang
        v94 = math.cos(v94)
        v98 = v.ang
        v98 = math.sin(v98)

        if v.entering then
            v106 = v.enter + p76 / 0.9
            v.enter = math.min(1, v106)
            v106 = 2.5 * p76
            v106 = math.min(1, v106)
            s2 = "x"
            v184 = v.x
            v[s2] = v[s2] + (v90 - v184) * v106
            s2 = "y"
            v106 = (v91 - v.y) * v106
            v[s2] = v[s2] + v106

            if v.enter >= 1 then
                t2.value37.pulse = 1
                t2.value37.ripples[2].t = 0
                t2.value37.burst(v90, v91, 10, 0, 6.28, 40, 110)
                t2.value37.respawn(v, false)
            end
        else
            s2 = v.spd * (v106 < 140 and 1.5 or 1)
            v184 = p75 * v.beat + v.ph
            s2 = s2 * ((math.sin(v184) * 0.5 + 0.5) * 0.5 + 0.7)
            v184 = "x"
            v[v184] = v[v184] + v94 * s2 * p76
            v184 = "y"
            s2 = v98 * s2 * p76
            v[v184] = v[v184] + s2

            if v106 < 46 then
                v.entering = true
                v.enter = 0
                t2.value37.pulse = 1
                t2.value37.ripples[1].t = 0
                v106 = v.y - v91
                s2 = v.x - v90
                v106 = math.atan2(v106, s2)
                t2.value37.burst(v.x, v.y, 8, v106 - 1.1, v106 + 1.1, 60, 150)
            end
        end

        v106 = v.fade + p76 / 1.2
        v.fade = math.min(1, v106)
        v106 = v.fade * (1 - v.enter)
        s2 = 0.35 + 0.65 * v106

        local v108 = -v98
        local v109 = -math.sin(p75 * v.beat + v.ph) * v.size * 0.12
        local v110 = v.x + v108 * v109

        v109 = v.y + v94 * v109

        local ang = v.ang
        local v112 = p75 * v.beat + v.ph

        ang = ang + math.sin(v112) * 0.244
        v.head.Position = UDim2.fromOffset(v110, v109)
        v.head.Size = UDim2.fromOffset(v.size * 1.6 * s2, v.size * s2)
        v.head.BackgroundTransparency = 1 - v106
        v.hst.Transparency = 1 - 0.45 * v106
        v.shine.BackgroundTransparency = 1 - 0.8 * v106
        v.head.Rotation = math.deg(ang)
        v112 = v.size * 0.62 * s2
        v110 = v110 - math.cos(ang) * v112
        v109 = v109 - math.sin(ang) * v112
        ang = v.size * 0.74 * (0.3 + 0.7 * v106)

        local v113 = v110
        local v114 = v94
        local v115 = v109

        for i, seg in ipairs(v.segs) do
            local v118 = i * ang
            local v119 = p75 * v.beat * (1 + 1.2 * v.enter) - i * 0.55 + v.ph

            v119 = math.sin(v119) * (i / v92) ^ 0.8 * v.size * 1

            local v120 = v110 - v114 * v118 + v108 * v119

            v118 = v109 - v98 * v118 + v94 * v119
            v119 = v120 - v113

            local v121 = v118 - v115
            local v122 = v.th[i] * s2
            local v123 = v119 * v119 + v121 * v121

            v123 = math.sqrt(v123) + v122
            seg.Size = UDim2.fromOffset(v123, v122)
            seg.BackgroundTransparency = 1 - (1 - v.bt[i]) * v106
            seg.Position = UDim2.fromOffset((v113 + v120) / 2, (v115 + v118) / 2)
            v115 = math.atan2(v121, v119)
            seg.Rotation = math.deg(v115)
            v113 = v120
            v115 = v118
        end
    end
end
Players = Instance.new("Frame")
Players.Size = UDim2.new(1, 0, 0, 50)
Players.BackgroundTransparency = 1
Players.BorderSizePixel = 0
Players.ClipsDescendants = true
Players.ZIndex = 50
Players.Parent = t2.value35
t2.value22.header = Players
CumHub_TweakerGUI = Instance.new("Frame")
CumHub_TweakerGUI.Name = "HeadBg"
CumHub_TweakerGUI.Size = UDim2.new(1, 0, 1, t2.value14)
CumHub_TweakerGUI.BackgroundColor3 = Color3.fromRGB(20, 16, 49)
CumHub_TweakerGUI.BackgroundTransparency = 0.3
CumHub_TweakerGUI.BorderSizePixel = 0
CumHub_TweakerGUI.Parent = Players
t2.value27(CumHub_TweakerGUI, t2.value14)
t2.value22.headBg = CumHub_TweakerGUI
CumHub_TweakerGUI = Instance.new("Frame")
CumHub_TweakerGUI.Size = UDim2.new(1, 0, 0, 2)
CumHub_TweakerGUI.Position = UDim2.new(0, 0, 1, -2)
CumHub_TweakerGUI.BackgroundColor3 = Color3.new(1, 1, 1)
CumHub_TweakerGUI.BorderSizePixel = 0
CumHub_TweakerGUI.Parent = Players
t2.value22.headLine = CumHub_TweakerGUI
t2.value29(CumHub_TweakerGUI, t2.value4, t2.value5, 0)
CumHub_TweakerGUI = Instance.new("Frame")
CumHub_TweakerGUI.Size = UDim2.fromOffset(30, 30)
CumHub_TweakerGUI.Position = UDim2.fromOffset(12, 10)
CumHub_TweakerGUI.BackgroundTransparency = 1
CumHub_TweakerGUI.Parent = Players
t2.value27(CumHub_TweakerGUI, 0.5, true)
t2.value22.logoGrad = t2.value29(t2.value28(CumHub_TweakerGUI, Color3.new(1, 1, 1), 2, 0), t2.value4, t2.value5, 0)
UIGradient = Instance.new("Frame")
UIGradient.AnchorPoint = Vector2.new(0.5, 0.5)
UIGradient.Position = UDim2.fromScale(0.5, 0.5)
UIGradient.Size = UDim2.fromOffset(10, 8)
UIGradient.BackgroundColor3 = t2.value12
UIGradient.BorderSizePixel = 0
UIGradient.Parent = CumHub_TweakerGUI
t2.value27(UIGradient, 0.5, true)
t2.value22.logoCore = UIGradient
CumHub_TweakerGUI = Instance.new("TextLabel")
CumHub_TweakerGUI.Size = UDim2.new(1, -130, 0, 26)
CumHub_TweakerGUI.Position = UDim2.fromOffset(52, 5)
CumHub_TweakerGUI.BackgroundTransparency = 1
CumHub_TweakerGUI.Text = "Tweaker GUI"
CumHub_TweakerGUI.TextXAlignment = Enum.TextXAlignment.Left
CumHub_TweakerGUI.TextTruncate = Enum.TextTruncate.AtEnd
CumHub_TweakerGUI.TextColor3 = Color3.new(1, 1, 1)
CumHub_TweakerGUI.Font = Enum.Font.GothamBlack
CumHub_TweakerGUI.TextSize = 21
CumHub_TweakerGUI.Parent = Players
t2.value22.titleGrad = t2.value29(CumHub_TweakerGUI, t2.value4, t2.value5, 0)
CumHub_TweakerGUI = Instance.new("TextLabel")
CumHub_TweakerGUI.Size = UDim2.new(1, -130, 0, 14)
CumHub_TweakerGUI.Position = UDim2.fromOffset(52, 30)
CumHub_TweakerGUI.BackgroundTransparency = 1
CumHub_TweakerGUI.TextXAlignment = Enum.TextXAlignment.Left
CumHub_TweakerGUI.TextTruncate = Enum.TextTruncate.AtEnd
CumHub_TweakerGUI.TextColor3 = Color3.fromRGB(255, 140, 170)
CumHub_TweakerGUI.Font = Enum.Font.GothamBold
CumHub_TweakerGUI.TextSize = 10
CumHub_TweakerGUI.Text = "REALISTIC HOME INVASION  \226\128\162  RSHIFT HIDE"
CumHub_TweakerGUI.Parent = Players
t2.value22.minBtn = t2.value31(Players, "\226\128\147", t2.value8, t2.value9, UDim2.fromOffset(26, 26), UDim2.new(1, -66, 0, 12), 16)
t2.value22.closeBtn = t2.value31(Players, "\195\151", t2.value8, Color3.fromRGB(200, 50, 70), UDim2.fromOffset(26, 26), UDim2.new(1, -34, 0, 12), 18)
t2.value41 = Instance.new("Frame")
t2.value41.Size = UDim2.new(1, 0, 1, -50)
t2.value41.Position = UDim2.fromOffset(0, 50)
t2.value41.BackgroundTransparency = 1
t2.value41.Parent = t2.value35
t2.value42 = Instance.new("ScrollingFrame")
t2.value42.Size = UDim2.new(1, -24, 0, 28)
t2.value42.Position = UDim2.fromOffset(12, 10)
t2.value42.BackgroundTransparency = 1
t2.value42.BorderSizePixel = 0
t2.value42.ScrollBarThickness = 0
t2.value42.ScrollingDirection = Enum.ScrollingDirection.X
t2.value42.AutomaticCanvasSize = Enum.AutomaticSize.X
t2.value42.CanvasSize = UDim2.new()
t2.value42.Parent = t2.value41
Players = Instance.new("UIListLayout")
Players.FillDirection = Enum.FillDirection.Horizontal
Players.Padding = UDim.new(0, 6)
Players.SortOrder = Enum.SortOrder.LayoutOrder
Players.Parent = t2.value42
t2.value43 = Instance.new("Frame")
t2.value43.Size = UDim2.new(1, -24, 1, -98)
t2.value43.Position = UDim2.fromOffset(12, 46)
t2.value43.BackgroundTransparency = 1
t2.value43.Parent = t2.value41
Players = Instance.new("TextLabel")
Players.Size = UDim2.new(1, -24, 0, 18)
Players.Position = UDim2.new(0, 12, 1, -28)
Players.BackgroundTransparency = 1
Players.TextXAlignment = Enum.TextXAlignment.Left
Players.TextTruncate = Enum.TextTruncate.AtEnd
Players.TextColor3 = t2.value11
Players.Font = Enum.Font.Gotham
Players.TextSize = 11
Players.Text = t2.value15
Players.Parent = t2.value41
t2.value22.help = Players
Players = Instance.new("TextLabel")
Players.Size = UDim2.new(1, -24, 0, 28)
Players.Position = UDim2.new(0, 12, 1, 40)
Players.BackgroundColor3 = t2.value8
Players.BorderSizePixel = 0
Players.TextColor3 = t2.value10
Players.Font = Enum.Font.GothamBold
Players.TextSize = 12
Players.TextTruncate = Enum.TextTruncate.AtEnd
Players.Text = ""
Players.ZIndex = 30
Players.Parent = t2.value35
t2.value27(Players, 8)
t2.value28(Players, t2.value5, 1, 0.3)
t2.value22.toast = Players
t2.value44 = 0
Players = function(p77)
    local value44 = t2

    value44.value44 = value44.value44 + 1
    value44 = t2.value44
    t2.value22.toast.Text = tostring(p77)
    t2.value26(t2.value22.toast, {
		["Position"] = UDim2.new(0, 12, 1, -40)
	}, 0.25, Enum.EasingStyle.Back)
    value44 = function()
        local v125 = value44 == t2.value44

        if v125 then
            v125 = t2.value22.toast.Parent
        end

        if not v125 then
            return
        end

        t2.value26(t2.value22.toast, {
			["Position"] = UDim2.new(0, 12, 1, 40)
		}, 0.25)
    end
    task.delay(1.8, value44)
end
function t2.value45(p78, ...)
    if not (p78 and t2.value25) then
        return
    end

    local ok, result = pcall(p78, ...)

    if ok then
        return
    end

    warn("[Tweaker GUI] " .. tostring(result))
    Players("Error, see Output")
end
t2.value46 = {
	["Notify"] = Players,
	["Gui"] = t2.value33
}
shared.CUMHUB = t2.value46
t2.value47 = {}
function t2.value46.StopAll()
    for _, v in ipairs(t2.value47) do
        if v.get() then
            v.set(false)
        end
    end
end
t2.value48 = {}
t2.value49 = nil
function t2.value46.Tab(p79)
    local t5 = {}
    local layoutOrder = 0
    local ScrollingFrame = Instance.new("ScrollingFrame")

    ScrollingFrame.Size = UDim2.fromScale(1, 1)
    ScrollingFrame.BackgroundTransparency = 1
    ScrollingFrame.BorderSizePixel = 0
    ScrollingFrame.ScrollBarThickness = 3
    ScrollingFrame.ScrollBarImageColor3 = t2.value4
    ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    ScrollingFrame.CanvasSize = UDim2.new()
    ScrollingFrame.Visible = false
    ScrollingFrame.Parent = t2.value43

    local UIListLayout = Instance.new("UIListLayout")

    UIListLayout.Padding = UDim.new(0, 6)
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Parent = ScrollingFrame
    UIListLayout = t2.value31(t2.value42, string.upper(p79), t2.value8, t2.value9, UDim2.fromOffset(0, 28), UDim2.new(), 11)
    UIListLayout.AutomaticSize = Enum.AutomaticSize.X
    UIListLayout.LayoutOrder = #t2.value48 + 1

    local UIPadding = Instance.new("UIPadding")

    UIPadding.PaddingLeft = UDim.new(0, 14)
    UIPadding.PaddingRight = UDim.new(0, 14)
    UIPadding.Parent = UIListLayout
    UIPadding = function()
        t2.value49(t5)
    end
    UIListLayout.MouseButton1Click:Connect(UIPadding)
    t5.sf = ScrollingFrame
    t5.btn = UIListLayout
    t2.value48[#t2.value48 + 1] = t5
    UIListLayout = function(p80)
        layoutOrder = layoutOrder + 1

        local Frame5 = Instance.new("Frame")

        Frame5.Size = UDim2.new(1, -6, 0, p80)
        Frame5.BackgroundColor3 = t2.value8
        Frame5.BackgroundTransparency = t2.value13
        Frame5.BorderSizePixel = 0
        Frame5.LayoutOrder = layoutOrder
        Frame5.Parent = ScrollingFrame
        t2.value27(Frame5, 12)
        t2.value28(Frame5, t2.value4, 1, 0.85)

        return Frame5
    end

    function t5.Section(_, p81)
        layoutOrder = layoutOrder + 1

        local TextLabel = Instance.new("TextLabel")

        TextLabel.Size = UDim2.new(1, -6, 0, 22)
        TextLabel.BackgroundTransparency = 1
        TextLabel.Text = string.upper(p81)
        TextLabel.TextXAlignment = Enum.TextXAlignment.Left
        TextLabel.TextColor3 = t2.value5
        TextLabel.Font = Enum.Font.GothamBlack
        TextLabel.TextSize = 11
        TextLabel.LayoutOrder = layoutOrder
        TextLabel.Parent = ScrollingFrame

        return TextLabel
    end
    function t5.Label(_, p82)
        local v137 = UIListLayout(30)
        local TextLabel = Instance.new("TextLabel")

        TextLabel.Size = UDim2.new(1, -20, 1, 0)
        TextLabel.Position = UDim2.fromOffset(10, 0)
        TextLabel.BackgroundTransparency = 1
        TextLabel.Text = p82
        TextLabel.TextXAlignment = Enum.TextXAlignment.Left
        TextLabel.TextTruncate = Enum.TextTruncate.AtEnd
        TextLabel.TextColor3 = t2.value11
        TextLabel.Font = Enum.Font.Gotham
        TextLabel.TextSize = 12
        TextLabel.Parent = v137

        return TextLabel
    end
    function t5.Button(_, p83, p84, p85)
        local v139 = UIListLayout(34)

        v139 = t2.value31(v139, p83, t2.value6, t2.value7, UDim2.new(1, -12, 1, -10), UDim2.fromOffset(6, 5), 12)

        local function v140()
            t2.value45(p84)
        end

        v139.MouseButton1Click:Connect(v140)
        t2.value32(v139, p85)

        return v139
    end
    function t5.Toggle(_, p86, p87, p88, p89)
        local Frame5 = UIListLayout(34)
        local u142 = p87 and true or false
        local v143 = t2.value30(Frame5, "", Color3.new(1, 1, 1), UDim2.fromScale(1, 1), UDim2.new(), 12)

        v143.BackgroundTransparency = 1

        local TextLabel = Instance.new("TextLabel")

        TextLabel.Size = UDim2.new(1, -70, 1, 0)
        TextLabel.Position = UDim2.fromOffset(10, 0)
        TextLabel.BackgroundTransparency = 1
        TextLabel.Text = p86
        TextLabel.TextXAlignment = Enum.TextXAlignment.Left
        TextLabel.TextTruncate = Enum.TextTruncate.AtEnd
        TextLabel.TextColor3 = t2.value10
        TextLabel.Font = Enum.Font.GothamBold
        TextLabel.TextSize = 13
        TextLabel.Parent = Frame5
        TextLabel = Instance.new("Frame")
        TextLabel.Size = UDim2.fromOffset(42, 20)
        TextLabel.Position = UDim2.new(1, -52, 0.5, -10)
        TextLabel.BackgroundColor3 = t2.value9
        TextLabel.BorderSizePixel = 0
        TextLabel.Parent = Frame5
        t2.value27(TextLabel, 0.5, true)
        Frame5 = Instance.new("Frame")
        Frame5.Size = UDim2.fromOffset(14, 14)
        Frame5.Position = UDim2.fromOffset(3, 3)
        Frame5.BackgroundColor3 = t2.value12
        Frame5.BorderSizePixel = 0
        Frame5.Parent = TextLabel
        t2.value27(Frame5, 0.5, true)

        local t6 = {}

        Frame5 = function(p90)
            local t7 = {
				["BackgroundColor3"] = u142 and t2.value4 or t2.value9
			}
            local v147 = u142

            if not v147 then
                v147 = {
					["Position"] = v147 or UDim2.fromOffset(3, 3)
				}

                if p90 then
                    t2.value26(TextLabel, t7, 0.15)
                    t2.value26(Frame5, v147, 0.15)

                    return
                else
                    TextLabel.BackgroundColor3 = t7.BackgroundColor3
                    Frame5.Position = v147.Position

                    return
                end

                return
            end

            v147 = UDim2.fromOffset(25, 3)
            v147 = {
				["Position"] = v147 or UDim2.fromOffset(3, 3)
			}

            if p90 then
                t2.value26(TextLabel, t7, 0.15)
                t2.value26(Frame5, v147, 0.15)

                return
            else
                TextLabel.BackgroundColor3 = t7.BackgroundColor3
                Frame5.Position = v147.Position

                return
            end
        end

        function t6.Set(_, p91)
            u142 = p91 and true or false
            Frame5(true)
            t2.value45(p88, u142)
        end
        function t6.Get(_)
            return u142
        end

        TextLabel = {
			["get"] = function()
            return u142
        end,
			["set"] = function(p92)
            t6:Set(p92)
        end,
			["quiet"] = function()
            if not u142 then
                return
            end

            u142 = false
            pcall(p88, false)
        end
		}
        t2.value47[#t2.value47 + 1] = TextLabel
        v143.MouseButton1Click:Connect(function()
            t6:Set(not u142)
        end)
        Frame5(false)
        t2.value32(v143, p89)

        return t6
    end
    function t5.Input(_, p93, p94, p95)
        local v148 = UIListLayout(34)
        local v149 = t2.value28(v148, t2.value5, 1, 1)
        local TextBox = Instance.new("TextBox")

        TextBox.Size = UDim2.new(1, -20, 1, 0)
        TextBox.Position = UDim2.fromOffset(10, 0)
        TextBox.BackgroundTransparency = 1
        TextBox.PlaceholderText = p93
        TextBox.PlaceholderColor3 = t2.value11
        TextBox.Text = ""
        TextBox.TextColor3 = t2.value10
        TextBox.Font = Enum.Font.Gotham
        TextBox.TextSize = 13
        TextBox.TextXAlignment = Enum.TextXAlignment.Left
        TextBox.ClearTextOnFocus = false
        TextBox.Parent = v148
        TextBox.Focused:Connect(function()
            t2.value26(v149, {
				["Transparency"] = 0.1
			}, 0.2)
        end)
        TextBox.FocusLost:Connect(function(enterPressed)
            t2.value26(v149, {
				["Transparency"] = 1
			}, 0.2)

            if not enterPressed then
                return
            end

            t2.value45(p94, TextBox.Text)
        end)
        t2.value32(TextBox, p95)

        return TextBox
    end
    function t5.Keybind(_, p96, p97, p98, p99)
        local v151 = UIListLayout(34)
        local F = Enum.KeyCode.F
        local KeyCode
        local function v154()
            KeyCode = Enum.KeyCode[p97] or KeyCode
        end
        KeyCode = F
        pcall(v154)
        F = Instance.new("TextLabel")
        F.Size = UDim2.new(1, -110, 1, 0)
        F.Position = UDim2.fromOffset(10, 0)
        F.BackgroundTransparency = 1
        F.Text = p96
        F.TextXAlignment = Enum.TextXAlignment.Left
        F.TextTruncate = Enum.TextTruncate.AtEnd
        F.TextColor3 = t2.value10
        F.Font = Enum.Font.GothamBold
        F.TextSize = 13
        F.Parent = v151
        v151 = t2.value31(v151, KeyCode.Name, t2.value6, t2.value7, UDim2.fromOffset(88, 24), UDim2.new(1, -96, 0.5, -12), 11)
        local u155 = false
        F = {
			["Get"] = function(_)
            return KeyCode
        end
		}
        v151.MouseButton1Click:Connect(function()
            u155 = true
            v151.Text = "..."
        end)
        v154 = t2.value21
        local InputBegan = t2.value2.InputBegan
        local function v157(p100, p101)
            if p100.UserInputType ~= Enum.UserInputType.Keyboard then
                return
            end

            if u155 then
                if p100.KeyCode == Enum.KeyCode.Escape then
                    v151.Text = KeyCode.Name

                    return
                end

                KeyCode = p100.KeyCode
                v151.Text = KeyCode.Name

                return
            else
                if p101 then
                    return
                end

                if p100.KeyCode ~= KeyCode then
                    return
                end

                t2.value45(p98)

                return
            end
        end
        table.insert(v154, InputBegan:Connect(v157))
        t2.value32(v151, p99)

        return F
    end
    function t5.Selector(_, p102, p103, p104, p105, p106)
        local v158 = UIListLayout(34)
        local u159 = table.find(p103, p104) or 1
        local TextLabel = Instance.new("TextLabel")

        TextLabel.Size = UDim2.new(1, -150, 1, 0)
        TextLabel.Position = UDim2.fromOffset(10, 0)
        TextLabel.BackgroundTransparency = 1
        TextLabel.Text = p102
        TextLabel.TextXAlignment = Enum.TextXAlignment.Left
        TextLabel.TextTruncate = Enum.TextTruncate.AtEnd
        TextLabel.TextColor3 = t2.value10
        TextLabel.Font = Enum.Font.GothamBold
        TextLabel.TextSize = 13
        TextLabel.Parent = v158
        v158 = t2.value31(v158, p103[u159], t2.value6, t2.value7, UDim2.fromOffset(130, 24), UDim2.new(1, -138, 0.5, -12), 11)
        TextLabel = {
			["Get"] = function(_)
            return p103[u159]
        end
		}
        v158.MouseButton1Click:Connect(function()
            u159 = u159 % #p103 + 1
            v158.Text = p103[u159]
            t2.value45(p105, p103[u159])
        end)
        t2.value32(v158, p106)

        return TextLabel
    end
    function t5.Slider(_, p107, p108, p109, p110, p111, p112, p113)
        local v161 = p112 or 1
        local Frame5 = UIListLayout(48)
        local TextLabel = Instance.new("TextLabel")
        TextLabel.Size = UDim2.new(1, -80, 0, 20)
        TextLabel.Position = UDim2.fromOffset(10, 4)
        TextLabel.BackgroundTransparency = 1
        TextLabel.Text = p107
        TextLabel.TextXAlignment = Enum.TextXAlignment.Left
        TextLabel.TextTruncate = Enum.TextTruncate.AtEnd
        TextLabel.TextColor3 = t2.value10
        TextLabel.Font = Enum.Font.GothamBold
        TextLabel.TextSize = 13
        TextLabel.Parent = Frame5
        TextLabel = Instance.new("TextLabel")
        TextLabel.Size = UDim2.fromOffset(60, 20)
        TextLabel.Position = UDim2.new(1, -70, 0, 4)
        TextLabel.BackgroundTransparency = 1
        TextLabel.TextXAlignment = Enum.TextXAlignment.Right
        TextLabel.TextColor3 = t2.value5
        TextLabel.Font = Enum.Font.Code
        TextLabel.TextSize = 12
        TextLabel.Parent = Frame5
        local TextButton = Instance.new("TextButton")
        TextButton.Size = UDim2.new(1, -20, 0, 8)
        TextButton.Position = UDim2.fromOffset(10, 32)
        TextButton.BackgroundColor3 = t2.value9
        TextButton.BorderSizePixel = 0
        TextButton.AutoButtonColor = false
        TextButton.Text = ""
        TextButton.Parent = Frame5
        t2.value27(TextButton, 0.5, true)
        Frame5 = Instance.new("Frame")
        Frame5.BackgroundColor3 = t2.value4
        Frame5.BorderSizePixel = 0
        Frame5.Parent = TextButton
        t2.value27(Frame5, 0.5, true)
        t2.value29(Frame5, t2.value4, t2.value5, 0)
        local v165 = math.clamp(p110 or p108, p108, p109)
        local u166
        v161 = function(p114, p115)
            local v167 = (p114 - p108) / v161 + 0.5
            v167 = math.floor(v167) * v161 + p108
            local v168 = p108
            v167 = math.clamp(v167, v168, p109)
            v168 = v167 ~= u166
            u166 = v167
            Frame5.Size = UDim2.fromScale((v167 - p108) / (p109 - p108), 1)
            local v169 = TextLabel
            local v170 = v167 * 100 + 0.5
            v170 = math.floor(v170) / 100
            v169.Text = tostring(v170)
            if not (p115 and v168) then
                return
            end
            t2.value45(p111, v167)
        end
        u166 = v165
        v161(u166, false)
        Frame5 = function(p116)
            local v171 = p116 - TextButton.AbsolutePosition.X
            local X = TextButton.AbsoluteSize.X

            v171 = v171 / math.max(1, X)
            v161(p108 + math.clamp(v171, 0, 1) * (p109 - p108), true)
        end
        local u173 = false
        TextButton.InputBegan:Connect(function(input)
            if not (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
                return
            end

            u173 = true
            Frame5(input.Position.X)
        end)
        table.insert(t2.value21, t2.value2.InputChanged:Connect(function(input)
            local v174 = u173

            if v174 then
                v174 = input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch
            end

            if not v174 then
                return
            end

            Frame5(input.Position.X)
        end))
        table.insert(t2.value21, t2.value2.InputEnded:Connect(function(input)
            local _ = input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch
        end))
        t2.value32(TextButton, p113)

        return {
			["Set"] = function(_, p117)
            v161(p117, true)
        end,
			["Get"] = function()
            return u166
        end
		}
    end

    return t5
end
function t2.value49(p118)
    for _, v in ipairs(t2.value48) do
        local visible = v == p118

        v.sf.Visible = visible

        local value26 = t2.value26
        local btn = v.btn
        local s3 = "BackgroundColor3"

        if visible then
            visible = t2.value4
        end

        value26(btn, {
			[s3] = visible or t2.value8
		}, 0.15)
    end
end
t2.value50 = "OPS"
CumHub_TweakerGUI = t2.value46.Tab("Guns")
CumHub_TweakerGUI:Section("Operations")
CumHub_TweakerGUI:Toggle("Infinite Ammo", false, function(p119)
    if p119 then
        local LocalPlayer = game.Players.LocalPlayer
        local t8 = {
			["Ammo"] = 99999,
			["AmmoInGun"] = 99999,
			["StoredAmmo"] = 99999,
			["MaxStoredAmmo"] = 99999,
			["Jammed"] = false
		}

        _G.IA = _G.IA or {}
        _G.IA.rest = _G.IA.rest or {}

        if _G.IA.conn then
            _G.IA.conn:Disconnect()
        end

        local function v185(p120, p121, p122)
            if p120[p121] == p122 then
                return
            end

            _G.IA.rest[p120] = _G.IA.rest[p120] or {}

            if _G.IA.rest[p120][p121] == nil then
                _G.IA.rest[p120][p121] = p120[p121]
            end

            p120[p121] = p122
        end

        t8 = function(p123)
            if not p123:IsA("Tool") then
                return
            end

            local RepValues = p123:FindFirstChild("RepValues")

            if RepValues then
                for _, v in ipairs({ "Mag", "Ammo", "StoredAmmo" }) do
                    local v188 = RepValues:FindFirstChild(v)
                    local v189

                    if v188 then
                        v189 = v188.Value ~= 99999
                    else
                        v189 = v188
                    end

                    if v189 then
                        if not _G.IA.rest[v188] then
                            _G.IA.rest[v188] = v188.Value
                        end

                        v188.Value = 99999
                    end
                end
            end

            RepValues = p123:FindFirstChild("ACS_Settings")

            if RepValues then
                v316 = RepValues:IsA("ModuleScript")
            else
                v316 = RepValues
            end

            if not v316 then
                return
            end

            local result

            RepValues, result = pcall(require, RepValues)

            if RepValues then
                RepValues = type(result) == "table"
            end

            if not RepValues then
                return
            end

            for k, v in pairs(t8) do
                v185(result, k, v)
            end

            RepValues = result.JamChance

            if type(RepValues) ~= "number" then
                return
            end

            v185(result, "JamChance", 100000000)
        end
        _G.IA.conn = game:GetService("RunService").Heartbeat:Connect(function()
            local v193 = LocalPlayer

            for _, v in ipairs({ LocalPlayer.Character, v193:FindFirstChildOfClass("Backpack") }) do
                if v then
                    local GetChildren = v.GetChildren

                    for _, v2 in ipairs(GetChildren(v)) do
                        pcall(t8, v2)
                    end
                end
            end
        end)

        return
    end

    if not _G.IA then
        _G.IA = nil

        return
    end

    if _G.IA.conn then
        _G.IA.conn:Disconnect()
    end

    for k, v in pairs(_G.IA.rest or {}) do
        if typeof(k) == "Instance" then
            pcall(function()
                k.Value = v
            end)
        elseif type(k) == "table" then
            local pairs_ = pairs
            for k2, v2 in pairs_(v) do
                local v204 = k2 == "JamChance"

                if v204 then
                    v204 = type(v2) ~= "number" and true or v2 < 1
                end

                if v204 then
                end

                k[k2] = v2
            end
        end
    end

    _G.IA = nil
end, "999999 ammo given to all your weapons")
CumHub_TweakerGUI:Toggle("Full Auto", false, function(p124)
    if p124 then
        v_u_352 = game.Players.LocalPlayer

        local RunService2 = game:GetService("RunService")
        local _G_ = _G
        local s4 = "FA"
        local FA = _G.FA

        if not FA then
            FA = {
				["rest"] = {},
				["seen"] = {},
				["NIL"] = {}
			}
        end

        _G_[s4] = FA

        if _G.FA.conn then
            _G.FA.conn:Disconnect()
        end

        _G_ = _G.FA.NIL
        _G_ = function(p125, p126, p127, p128)
            if p125[p127] == p128 then
                return
            end

            if p126[p127] == nil then
                if p125[p127] == nil then
                    p126[p127] = _G_
                else
                    p126[p127] = p125[p127]
                end
            end

            p125[p127] = p128
        end
        _G_ = function(p129)
            if not p129:IsA("Tool") then
                return
            end

            local ACS_Settings = p129:FindFirstChild("ACS_Settings")

            if ACS_Settings then
                v343 = ACS_Settings:IsA("ModuleScript")
            else
                v343 = ACS_Settings
            end

            if not v343 then
                return
            end

            local result

            ACS_Settings, result = pcall(require, ACS_Settings)

            if ACS_Settings then
                ACS_Settings = type(result) == "table"
            end

            if not ACS_Settings then
                return
            end

            ACS_Settings = _G.FA.rest[result]

            if not ACS_Settings then
                ACS_Settings = {
					["top"] = {},
					["fm"] = {}
				}
                _G.FA.rest[result] = ACS_Settings
            end

            _G_(result, ACS_Settings.top, "ShootType", 3)

            local FireModes = result.FireModes

            if type(FireModes) == "table" then
                _G_(result.FireModes, ACS_Settings.fm, "Auto", true)
                _G_(result.FireModes, ACS_Settings.fm, "Semi", false)
                _G_(result.FireModes, ACS_Settings.fm, "Burst", false)
                _G_(result.FireModes, ACS_Settings.fm, "ChangeFiremode", false)
            end

            if _G.FA.seen[p129] then
                return
            end

            _G.FA.seen[p129] = true
            print("[FA] full auto:", p129.Name)
        end

        local n1 = 0

        v_u_352 = function(p130)
            n1 = n1 + p130

            if n1 < 0.3 then
                return
            else
                local v_u_352_ = v_u_352

                for _, v in ipairs({ v_u_352.Character, v_u_352_:FindFirstChildOfClass("Backpack") }) do
                    if v then
                        for _, child in ipairs(v:GetChildren()) do
                            pcall(_G_, child)
                        end
                    end
                end

                return
            end
        end
        _G.FA.conn = RunService2.Heartbeat:Connect(v_u_352)

        return
    end

    local FA = _G.FA

    if not FA then
        return warn("[FA] not on")
    end

    if not FA.conn then
        for k, v in pairs(FA.rest) do
            for k2, v2 in pairs(v.top) do
                if v2 == FA.NIL then
                    k[k2] = nil
                else
                    k[k2] = v2
                end
            end

            if type(k.FireModes) == "table" then
                for k2, v2 in pairs(v.fm) do
                    if v2 == FA.NIL then
                        k.FireModes[k2] = nil
                    else
                        k.FireModes[k2] = v2
                    end
                end
            end
        end

        _G.FA = nil
        print("[FA] restored")

        return
    end

    FA.conn:Disconnect()

    for k, v in pairs(FA.rest) do
        for k2, v2 in pairs(v.top) do
            if v2 == FA.NIL then
                k[k2] = nil
            else
                k[k2] = v2
            end
        end

        if type(k.FireModes) == "table" then
            for k2, v2 in pairs(v.fm) do
                if v2 == FA.NIL then
                    k.FireModes[k2] = nil
                else
                    k.FireModes[k2] = v2
                end
            end
        end
    end

    _G.FA = nil
    print("[FA] restored")
end, "Weapons perform as automatics")
CumHub_TweakerGUI:Toggle("No Recoil", false, function(p131)
    if p131 then
        local LocalPlayer = game.Players.LocalPlayer
        local RunService2 = game:GetService("RunService")
        local n2 = 0.001

        _G.NR = _G.NR or {
			["rest"] = {}
		}

        if _G.NR.conn then
            _G.NR.conn:Disconnect()
        end

        local function v234(p132)
            return p132:find("reduction") or (p132:find("time") or (p132:find("cool") or (p132:find("recover") or (p132:find("delay") or p132:find("rate")))))
        end
        local function v235(p133, p134)
            for k, v in pairs(p133) do
                if type(v) == "number" then
                    if v ~= n2 then
                        if p134[k] == nil then
                            p134[k] = v
                        end

                        p133[k] = n2
                    end
                elseif type(v) == "table" then
                    p134[k] = p134[k] or {}
                    v235(v, p134[k])
                end
            end
        end

        n2 = function(p135)
            if not p135:IsA("Tool") then
                return
            end

            local ACS_Settings = p135:FindFirstChild("ACS_Settings")

            if ACS_Settings then
                v378 = ACS_Settings:IsA("ModuleScript")
            else
                v378 = ACS_Settings
            end

            if not v378 then
                return
            end

            local result

            ACS_Settings, result = pcall(require, ACS_Settings)

            local v240, pos

            if not ACS_Settings then
                if ACS_Settings then
                    _G.NR.rest[result] = _G.NR.rest[result] or {}

                    for k, v in pairs(result) do
                        if type(k) == "string" then
                            v240 = k:lower()
                            pos = v240:find("recoil")

                            if pos then
                                pos = not v234(v240)
                            end

                            if pos then
                                if type(v) == "number" then
                                    if v ~= n2 then
                                        if _G.NR.rest[result][k] == nil then
                                            _G.NR.rest[result][k] = v
                                        end

                                        result[k] = n2
                                    end
                                elseif type(v) == "table" then
                                    _G.NR.rest[result][k] = _G.NR.rest[result][k] or {}
                                    v235(v, _G.NR.rest[result][k])
                                end
                            end
                        end
                    end

                    return
                else
                    return
                end

                return
            end

            ACS_Settings = type(result) == "table"

            if ACS_Settings then
                _G.NR.rest[result] = _G.NR.rest[result] or {}

                for k, v in pairs(result) do
                    if type(k) == "string" then
                        v240 = k:lower()
                        pos = v240:find("recoil")

                        if pos then
                            pos = not v234(v240)
                        end

                        if pos then
                            if type(v) == "number" then
                                if v ~= n2 then
                                    if _G.NR.rest[result][k] == nil then
                                        _G.NR.rest[result][k] = v
                                    end

                                    result[k] = n2
                                end
                            elseif type(v) == "table" then
                                _G.NR.rest[result][k] = _G.NR.rest[result][k] or {}
                                v235(v, _G.NR.rest[result][k])
                            end
                        end
                    end
                end

                return
            else
                return
            end
        end

        local n3 = 0

        _G.NR.conn = RunService2.Heartbeat:Connect(function(dt)
            n3 = n3 + dt

            if n3 < 0.2 then
                return
            else
                local v247 = LocalPlayer

                for _, v in ipairs({ LocalPlayer.Character, v247:FindFirstChildOfClass("Backpack") }) do
                    if v then
                        local GetChildren = v.GetChildren

                        for _, v2 in ipairs(GetChildren(v)) do
                            pcall(n2, v2)
                        end
                    end
                end

                return
            end
        end)

        return
    end

    local function v253(p136, p137)
        for k, v in pairs(p137) do
            if type(v) == "number" then
                p136[k] = v
            else
                local v256 = type(v) == "table"

                if v256 then
                    v256 = p136[k]
                    v256 = type(v256) == "table"
                end

                if v256 then
                    v253(p136[k], v)
                end
            end
        end
    end

    if not _G.NR then
        _G.NR = nil

        return
    end

    if _G.NR.conn then
        _G.NR.conn:Disconnect()
    end

    local v257 = v253

    for k, v in pairs(_G.NR.rest or {}) do
        v257(k, v)
    end

    _G.NR = nil
end, "Sets recoil to 0.001")
CumHub_TweakerGUI:Toggle("No Spread", false, function(p138)
    if p138 then
        local LocalPlayer = game.Players.LocalPlayer
        local game_ = game
        game_ = game_:GetService("RunService")
        local n4 = 0.001
        _G.SP = _G.SP or {
			["rest"] = {}
		}
        if _G.SP.conn then
            _G.SP.conn:Disconnect()
        end
        local function v263(p139)
            return p139:find("reduction") or (p139:find("time") or (p139:find("cool") or (p139:find("recover") or (p139:find("delay") or p139:find("rate")))))
        end
        local v264
        v264 = function(p140, p141)
            for k, v in pairs(p140) do
                if type(v) == "number" then
                    if v ~= n4 then
                        if p141[k] == nil then
                            p141[k] = v
                        end

                        p140[k] = n4
                    end
                elseif type(v) == "table" then
                    p141[k] = p141[k] or {}
                    v264(v, p141[k])
                end
            end
        end
        n4 = function(p142)
            if not p142:IsA("Tool") then
                return
            end

            local ACS_Settings = p142:FindFirstChild("ACS_Settings")

            if ACS_Settings then
                v415 = ACS_Settings:IsA("ModuleScript")
            else
                v415 = ACS_Settings
            end

            if not v415 then
                return
            end

            local result

            ACS_Settings, result = pcall(require, ACS_Settings)

            local v269, pos

            if not ACS_Settings then
                if ACS_Settings then
                    _G.SP.rest[result] = _G.SP.rest[result] or {}

                    for k, v in pairs(result) do
                        if type(k) == "string" then
                            v269 = k:lower()
                            pos = v269:find("spread")

                            if pos then
                                pos = not v263(v269)
                            end

                            if pos then
                                if type(v) == "number" then
                                    if v ~= n4 then
                                        if _G.SP.rest[result][k] == nil then
                                            _G.SP.rest[result][k] = v
                                        end

                                        result[k] = n4
                                    end
                                elseif type(v) == "table" then
                                    _G.SP.rest[result][k] = _G.SP.rest[result][k] or {}
                                    v264(v, _G.SP.rest[result][k])
                                end
                            end
                        end
                    end

                    return
                else
                    return
                end

                return
            end

            ACS_Settings = type(result) == "table"

            if ACS_Settings then
                _G.SP.rest[result] = _G.SP.rest[result] or {}

                for k, v in pairs(result) do
                    if type(k) == "string" then
                        v269 = k:lower()
                        pos = v269:find("spread")

                        if pos then
                            pos = not v263(v269)
                        end

                        if pos then
                            if type(v) == "number" then
                                if v ~= n4 then
                                    if _G.SP.rest[result][k] == nil then
                                        _G.SP.rest[result][k] = v
                                    end

                                    result[k] = n4
                                end
                            elseif type(v) == "table" then
                                _G.SP.rest[result][k] = _G.SP.rest[result][k] or {}
                                v264(v, _G.SP.rest[result][k])
                            end
                        end
                    end
                end

                return
            else
                return
            end
        end
        local n5 = 0
        _G.SP.conn = game_.Heartbeat:Connect(function(dt)
            n5 = n5 + dt

            if n5 < 0.2 then
                return
            else
                local v276 = LocalPlayer

                for _, v in ipairs({ LocalPlayer.Character, v276:FindFirstChildOfClass("Backpack") }) do
                    if v then
                        local GetChildren = v.GetChildren

                        for _, v2 in ipairs(GetChildren(v)) do
                            pcall(n4, v2)
                        end
                    end
                end

                return
            end
        end)

        return
    end

    local function v282(p143, p144)
        for k, v in pairs(p144) do
            if type(v) == "number" then
                p143[k] = v
            else
                local v285 = type(v) == "table"

                if v285 then
                    v285 = p143[k]
                    v285 = type(v285) == "table"
                end

                if v285 then
                    v282(p143[k], v)
                end
            end
        end
    end

    if not _G.SP then
        _G.SP = nil

        return
    end

    if _G.SP.conn then
        _G.SP.conn:Disconnect()
    end

    local v286 = v282

    for k, v in pairs(_G.SP.rest or {}) do
        v286(k, v)
    end

    _G.SP = nil
end, "0 spread applied to weapons")
CumHub_TweakerGUI = t2.value46.Tab("Visuals")
CumHub_TweakerGUI:Section("ESP")
CumHub_TweakerGUI:Toggle("Chams", false, function(p145)
    if p145 then
        if getgenv().ESP_Active then
            return
        end

        return
    end

    if not getgenv().ESP_Active then
        return
    end

    getgenv().ESP_Active = false

    if getgenv().ESP_Conns then
        for _, espConn in ipairs(getgenv().ESP_Conns) do
            pcall(function()
                espConn:Disconnect()
            end)
        end

        getgenv().ESP_Conns = {}
    end

    if getgenv().ESP_Tracked then
        for _, v in pairs(getgenv().ESP_Tracked) do
            for _, v2 in pairs(v) do
                pcall(function()
                    v2:Destroy()
                end)
            end
        end

        getgenv().ESP_Tracked = {}
    end

    if not getgenv().ESP_Gui then
        return
    end

    pcall(function()
        getgenv().ESP_Gui:Destroy()
    end)
    getgenv().ESP_Gui = nil
end, "Turn ESP on/off")
CumHub_TweakerGUI:Selector("Highlights Who?", { "OPS", "ALL" }, "OPS", function(p146)
    t2.value50 = p146
    _G.CHOICE = p146
end, "Who shows up in the ESP")
CumHub_TweakerGUI:Section("Fullbright")
CumHub_TweakerGUI:Toggle("Fullbright", false, function(p147)
    if p147 then
        if getgenv().FB_Active then
            return
        end

        return
    end

    if not getgenv().FB_Active then
        return
    end

    getgenv().FB_Active = false

    local Lighting = game:GetService("Lighting")

    if getgenv().FB_Conns then
        for _, fbConn in ipairs(getgenv().FB_Conns) do
            pcall(function()
                fbConn:Disconnect()
            end)
        end

        getgenv().FB_Conns = {}
    end

    if getgenv().FB_Saved then
        for k, v in pairs(getgenv().FB_Saved) do
            Lighting[k] = v
        end

        getgenv().FB_Saved = nil
    end

    if not getgenv().FB_AtmoSaved then
        return
    end

    for k, v in pairs(getgenv().FB_AtmoSaved) do
        if k.Parent then
            k.Density = v
        end
    end

    getgenv().FB_AtmoSaved = {}
end)
CumHub_TweakerGUI:Section("Lag reduction")
CumHub_TweakerGUI:Toggle("Reduce Lag", false, function(p148)
    local Lighting
    if p148 then
        game:GetService("Lighting")
        local _ = game:GetService("SoundService")

        if _G.LAG then
            return warn("[LAG] already on")
        end

        return
    else
        Lighting = _G.LAG

        if not Lighting then
            return warn("[LAG] not on")
        end

        return
    end
end)
CumHub_TweakerGUI = t2.value46.Tab("Settings")
CumHub_TweakerGUI:Section("Window")
CumHub_TweakerGUI:Slider("UI scale", 0.6, 1.4, 1, function(p149)
    t2.value24 = p149
    t2.value36.Scale = p149
end, 0.1, "Resize this whole window")
CumHub_TweakerGUI:Button("Turn everything off", function()
    t2.value46.StopAll()
end, "Switch every toggle off without closing")
CumHub_TweakerGUI:Button("Close Tweaker GUI", function()
    t2.value33:Destroy()
end, "Turns everything off, then closes")

if t2.value48[1] then
    t2.value49(t2.value48[1])
end
t2.value51 = nil
t2.value52 = false
t2.value53 = "CumHub_TweakerGUI_key.txt"
t2.value54 = true
t2.value55 = "ads.pandauth.com/getkey/realistichomeinvasion"
CumHub_TweakerGUI = Color3.fromRGB(62, 224, 140)
UIGradient = Color3.fromRGB(240, 84, 96)
t2.value56 = CumHub_TweakerGUI
t2.value57 = UIGradient
function t2.value58(p150)
    local match = tostring(p150 or ""):match("^%s*(.-)%s*$")

    if match == "" then
        return false, "ENTER YOUR KEY", match
    end

    if not t2.value52 then
        return false, "KEY SERVICE UNAVAILABLE", match
    end

    local ok, result = pcall(t2.value51.validate, match)

    if not ok then
        if ok then
            ok = result.isPremium and true or false

            return true, "ACCESS GRANTED", match
        else
            return false, "INVALID KEY", match
        end

        return
    end

    if type(result) == "table" then
        ok = result.success
    else
        ok = false
    end

    if ok then
        ok = result.isPremium and true or false

        return true, "ACCESS GRANTED", match
    else
        return false, "INVALID KEY", match
    end
end
t2.value41.Visible = false
t2.value59 = Instance.new("CanvasGroup")
t2.value59.Name = "KeyGate"
t2.value59.Size = UDim2.fromScale(1, 1)
t2.value59.Position = UDim2.fromOffset(0, 0)
t2.value59.BackgroundColor3 = t1.value5
t2.value59.BackgroundTransparency = 0.45
t2.value41.Visible = false
t2.value59.BorderSizePixel = 0
t2.value59.Active = true
t2.value59.ZIndex = 40
t2.value59.Parent = t2.value35
t2.value27(t2.value59, t2.value14)
t2.value60 = Instance.new("Frame")
t2.value60.AnchorPoint = Vector2.new(0.5, 0.5)
t2.value60.Position = UDim2.new(0.5, 0, 0.5, 25)
t2.value60.Size = UDim2.new(1, -56, 0, 176)
t2.value60.BackgroundTransparency = 1
t2.value60.Parent = t2.value59
t1 = function(p151, p152, p153, p154, p155, p156)
    local TextLabel = Instance.new("TextLabel")

    TextLabel.Size = UDim2.new(1, 0, 0, p153)
    TextLabel.Position = UDim2.fromOffset(0, p152)
    TextLabel.BackgroundTransparency = 1
    TextLabel.Text = p151
    TextLabel.Font = p155
    TextLabel.TextSize = p154
    TextLabel.TextColor3 = p156
    TextLabel.Parent = t2.value60

    return TextLabel
end
CumHub_TweakerGUI = t1("ACCESS REQUIRED", 0, 26, 20, Enum.Font.GothamBlack, Color3.new(1, 1, 1))
t2.value29(CumHub_TweakerGUI, t2.value4, t2.value5, 0)
t1("THANK YOU FOR SUPPORTING A VETERAN.", 28, 14, 10, Enum.Font.GothamBold, t2.value11)
CumHub_TweakerGUI = Instance.new("Frame")
CumHub_TweakerGUI.Size = UDim2.new(1, 0, 0, 42)
CumHub_TweakerGUI.Position = UDim2.fromOffset(0, 56)
CumHub_TweakerGUI.BackgroundColor3 = t2.value8
CumHub_TweakerGUI.BackgroundTransparency = 0.1
CumHub_TweakerGUI.BorderSizePixel = 0
CumHub_TweakerGUI.Parent = t2.value60
t2.value27(CumHub_TweakerGUI, 10)
t2.value61 = t2.value28(CumHub_TweakerGUI, t2.value5, 1, 0.8)
t2.value62 = Instance.new("TextBox")
t2.value62.Size = UDim2.new(1, -24, 1, 0)
t2.value62.Position = UDim2.fromOffset(12, 0)
t2.value62.BackgroundTransparency = 1
t2.value62.Text = ""
t2.value62.PlaceholderText = "ENTER KEY HERE"
t2.value62.PlaceholderColor3 = t2.value11
t2.value62.Font = Enum.Font.GothamMedium
t2.value62.TextSize = 14
t2.value62.TextColor3 = t2.value10
t2.value62.ClearTextOnFocus = false
t2.value62.Parent = CumHub_TweakerGUI
t2.value62.Focused:Connect(function()
    t2.value26(t2.value61, {
		["Transparency"] = 0.1
	}, 0.2)
end)
t2.value62.FocusLost:Connect(function()
    t2.value26(t2.value61, {
		["Transparency"] = 0.8
	}, 0.2)
end)
t2.value63 = t1("", 104, 16, 11, Enum.Font.GothamBold, t2.value11)
t1 = t2.value31(t2.value60, "VERIFY", t2.value6, t2.value7, UDim2.new(0.5, -4, 0, 36), UDim2.fromOffset(0, 130), 12)
CumHub_TweakerGUI = t2.value31(t2.value60, "GET KEY", t2.value8, t2.value9, UDim2.new(0.5, -4, 0, 36), UDim2.new(0.5, 4, 0, 130), 12)
t2.value64 = nil
t2.value64 = true
function t2.value65()
    if t2.value64 then
        return
    end

    t2.value64 = true
    t2.value63.TextColor3 = t2.value11
    t2.value63.Text = "CHECKING..."

    local value54, v309, v310 = t2.value58(t2.value62.Text)

    t2.value63.Text = v309

    if not value54 then
        t2.value63.TextColor3 = t2.value57
        t2.value26(t2.value61, {
			["Color"] = t2.value57,
			["Transparency"] = 0.1
		}, 0.1)

        for i = 1, 6 do
            t2.value60.Position = UDim2.new(0.5, i % 2 == 0 and -8 or 8, 0.5, 25)
            task.wait(0.035)
        end

        t2.value60.Position = UDim2.new(0.5, 0, 0.5, 25)
        t2.value26(t2.value61, {
			["Color"] = t2.value5,
			["Transparency"] = 0.8
		}, 0.3)
        t2.value64 = false

        return
    end

    t2.value63.TextColor3 = t2.value56
    value54 = t2.value54

    if value54 then
        value54 = writefile
    end

    if value54 then
        pcall(writefile, t2.value53, v310)
    end

    t2.value25 = true

    if not t2.value19 then
        task.wait(0.45)
        t2.value41.Visible = true
        t2.value26(t2.value59, {
			["GroupTransparency"] = 1
		}, 0.5)
        task.wait(0.55)
        t2.value59:Destroy()
        Players("Welcome")

        return
    end

    t2.value37.pulse = 1
    t2.value37.ripples[2].t = 0
    t2.value37.burst(t2.value16 / 2, t2.value17 * 0.5, 16, 0, 6.28, 60, 170)
    task.wait(0.45)
    t2.value41.Visible = true
    t2.value26(t2.value59, {
		["GroupTransparency"] = 1
	}, 0.5)
    task.wait(0.55)
    t2.value59:Destroy()
    Players("Welcome")
end
t1.MouseButton1Click:Connect(t2.value65)
t2.value62.FocusLost:Connect(function(enterPressed)
    if not enterPressed then
        return
    end

    t2.value65()
end)
CumHub_TweakerGUI.MouseButton1Click:Connect(function()
    local value55 = t2.value55

    if value55 == "" then
        value55 = function()
            return t2.value51.getKeyUrl()
        end
        value55, v475 = pcall(value55)
        value55 = value55 and tostring(v475) or ""
    end

    if value55 == "" then
        t2.value63.TextColor3 = t2.value57
        t2.value63.Text = "NO KEY LINK AVAILABLE"

        return
    end

    local setclipboard_ = setclipboard

    if not setclipboard_ then
        if setclipboard_ then
            t2.value63.TextColor3 = t2.value56
            t2.value63.Text = "KEY LINK COPIED"

            return
        else
            t2.value62.Text = value55
            t2.value63.TextColor3 = t2.value11
            t2.value63.Text = "LINK IS IN THE BOX, COPY IT"
            warn("[Key] " .. value55)

            return
        end

        return
    end

    setclipboard_ = pcall(setclipboard, value55)

    if setclipboard_ then
        t2.value63.TextColor3 = t2.value56
        t2.value63.Text = "KEY LINK COPIED"

        return
    else
        t2.value62.Text = value55
        t2.value63.TextColor3 = t2.value11
        t2.value63.Text = "LINK IS IN THE BOX, COPY IT"
        warn("[Key] " .. value55)

        return
    end
end)
t2.value33.Enabled = true
t2.value63.Text = "LOADING..."
task.spawn(function()
    local ok, textColor3 = pcall(function()
        return loadstring(game:HttpGet("https://secure.pandauth.com/pv4/lib"))()
    end)

    if ok then
        ok = type(textColor3) == "table"

        if ok then
            ok = textColor3.configure
            ok = type(ok) == "function"

            if ok then
                ok = textColor3.validate
                ok = type(ok) == "function"
            end
        end
    end

    t2.value52 = ok

    if t2.value52 then
        t2.value52 = pcall(textColor3.configure, {
			["serviceId"] = t2.value20
		})
    end

    ok = t2.value54

    if ok then
        ok = t2.value52

        if ok then
            ok = isfile

            if ok then
                ok = readfile
            end
        end
    end

    if ok then
        ok = function()
            if isfile(t2.value53) then
                return readfile(t2.value53)
            else
                return
            end
        end
        ok, textColor3 = pcall(ok)

        if ok then
            if textColor3 then
                textColor3 = t2.value58(textColor3)
            end
        else
            textColor3 = ok
        end

        if textColor3 then
            t2.value25 = true
            t2.value41.Visible = true
            t2.value26(t2.value59, {
				["GroupTransparency"] = 1
			}, 0.35)
            task.wait(0.4)
            t2.value59:Destroy()

            return
        end
    end

    ok = t2.value63
    textColor3 = t2.value52

    if not textColor3 then
        ok.TextColor3 = textColor3 or t2.value57
        t2.value63.Text = t2.value52 and "" or "KEY SERVICE UNAVAILABLE"

        return
    end

    textColor3 = t2.value11
    ok.TextColor3 = textColor3 or t2.value57
    t2.value63.Text = t2.value52 and "" or "KEY SERVICE UNAVAILABLE"
end)
t2.value32(t2.value22.minBtn, "Minimize / expand")
t2.value32(t2.value22.closeBtn, "Close Tweaker GUI")
t2.value66 = t2.value35:FindFirstChild("Cosmos")
t1 = t2.value16
t2.value67 = math.min(t1, 260)
t2.value22.minBtn.MouseButton1Click:Connect(function()
    t2.value23 = not t2.value23
    t2.value22.minBtn.Text = t2.value23 and "+" or "\226\128\147"

    if t2.value23 then
        t2.value41.Visible = false
        t2.value22.toast.Visible = false

        if not t2.value66 then
            t2.value22.headBg.Size = UDim2.fromScale(1, 1)
            t2.value22.headLine.Visible = false
            t2.value26(t2.value35, {
				["Size"] = UDim2.fromOffset(t2.value67, 50)
			}, 0.25, Enum.EasingStyle.Quint)

            return
        end

        t2.value66.Visible = false
        t2.value22.headBg.Size = UDim2.fromScale(1, 1)
        t2.value22.headLine.Visible = false
        t2.value26(t2.value35, {
			["Size"] = UDim2.fromOffset(t2.value67, 50)
		}, 0.25, Enum.EasingStyle.Quint)

        return
    else
        t2.value41.Visible = t2.value25
        t2.value22.toast.Visible = true

        if not t2.value66 then
            t2.value22.headBg.Size = UDim2.new(1, 0, 1, t2.value14)
            t2.value22.headLine.Visible = true
            t2.value26(t2.value35, {
				["Size"] = t2.value18
			}, 0.3, Enum.EasingStyle.Quint)

            return
        end

        t2.value66.Visible = true
        t2.value22.headBg.Size = UDim2.new(1, 0, 1, t2.value14)
        t2.value22.headLine.Visible = true
        t2.value26(t2.value35, {
			["Size"] = t2.value18
		}, 0.3, Enum.EasingStyle.Quint)

        return
    end
end)
t2.value22.closeBtn.MouseButton1Click:Connect(function()
    t2.value33:Destroy()
end)
t2.value68 = nil
t2.value69 = nil
t2.value70 = nil
t2.value22.header.InputBegan:Connect(function(input)
    if not (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
        return
    end

    t2.value68 = true
    t2.value69 = input.Position
    t2.value70 = t2.value34.Position
    input.Changed:Connect(function()
        if input.UserInputState ~= Enum.UserInputState.End then
            return
        end

        t2.value68 = false
    end)
end)
t1 = t2.value21
Players = t2.value2.InputChanged
table.insert(t1, Players:Connect(function(p157)
    local value68 = t2.value68

    if value68 then
        value68 = p157.UserInputType == Enum.UserInputType.MouseMovement or p157.UserInputType == Enum.UserInputType.Touch
    end

    if not value68 then
        return
    end

    value68 = p157.Position

    local workspace_ = workspace

    value68 = value68 - t2.value69
    workspace_ = workspace_.CurrentCamera.ViewportSize

    local v318 = t2.value70.X.Offset + value68.X
    local v319 = -t2.value16 * t2.value24 + 120
    local v320 = workspace_.X - 120

    v318 = math.clamp(v318, v319, v320)
    value68 = t2.value70.Y.Offset + value68.Y
    workspace_ = workspace_.Y - 60
    value68 = math.clamp(value68, 0, workspace_)
    t2.value34.Position = UDim2.fromOffset(v318, value68)
end))
t1 = t2.value21
Players = t2.value2.InputBegan
table.insert(t1, Players:Connect(function(p158, p159)
    if p159 then
        return
    end

    if p158.KeyCode ~= Enum.KeyCode.RightShift then
        return
    end

    t2.value34.Visible = not t2.value34.Visible
end))
t2.value71 = 0
table.insert(t2.value21, RunService.Heartbeat:Connect(function(dt)
    local Visible = t2.value34.Visible

    if Visible then
        Visible = not t2.value23
    end

    local gx = t2.value37.gx

    if gx then
        gx = t2.value37.gx.active ~= Visible
    end

    if gx then
        t2.value37.gx.setActive(Visible)
    end

    if not Visible then
        t2.value71 = 0

        return
    end

    Visible = t2
    Visible.value71 = Visible.value71 + dt

    if t2.value71 < (t2.value37.static and 0.05 or 0.033333333333333) then
        return
    end

    Visible = t2.value71
    Visible = math.min(Visible, 0.1)
    gx = os.clock()
    t2.value22.frameGrad.Rotation = gx * 60 % 360
    t2.value22.logoGrad.Rotation = gx * 150 % 360

    local titleGrad = t2.value22.titleGrad
    local vector2New = Vector2.new
    local v325 = gx * 1.5

    titleGrad.Offset = vector2New(math.sin(v325) * 0.6, 0)
    titleGrad = t2.value22.logoCore
    vector2New = UDim2.fromOffset
    v325 = gx * 3
    v325 = math.sin(v325) * 2 + 10

    local v326 = gx * 3

    titleGrad.Size = vector2New(v325, math.sin(v326) * 2 + 8)

    if t2.value37.static then
        return
    end

    t2.value40(gx, (math.min(Visible, 0.1)))
end))
t2.value33.Destroying:Connect(function()

    for v329, v330 in ipairs(t2.value47) do

        pcall(v330.quiet)
    end
    for _, v in ipairs(t2.value21) do
        v:Disconnect()
    end
    if shared.CUMHUB ~= t2.value46 then
        return
    end
    shared.CUMHUB = nil
end)
t2.value35.Size = UDim2.fromOffset(t2.value16, 0)
t2.value26(t2.value35, {
	["Size"] = t2.value18
}, 0.55, Enum.EasingStyle.Back)
