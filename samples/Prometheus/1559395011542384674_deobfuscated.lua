-- This file was generated at discord.gg/syncrypt

local t1 = {}
local t2 = {}
t1.value5 = 22126428612671
t1.value12 = nil
t2.value1 = game:GetService("UserInputService")

local _game = game
local GetService = _game.GetService
t1.value3 = 12834712622936
t1.value4 = 18063688655067
t2.value2 = GetService(_game, "TweenService")
t1.value8 = 25237642063336
t1.value3 = "\188&\136\217\239\1693\197\223\199"
t1.value1 = "game"
t1.value1 = game:GetService("RunService")
t1.value4 = "\171ޘ\164\141\201\127"
t1.value6 = 33503604964593
local _game2 = game
t1.value2 = _game2.GetService
t1.value4 = "\027%\131\245d!\252"
t1.value6 = 32235748178594
t1.value2 = t1.value2(_game2, "CoreGui")
t1.value9 = 21355818788568
t1.value7 = "\149\206FU\179\161\023"
t2.value3 = {
	HubName = "LP10 HUB",
	MapName = "CLIMB FOR ANIMALS EGGS",
	GuiName = "LP10_HalloweenLibrary",
	StartOpen = false,
	Intro = true,
	Ambient = true,
	Lightning = true
}
t2.value4 = {}
t1.value4 = Color3
t1.value9 = "\227\159\127B\1449\130"
t1.value11 = 4566595373134
t1.value9 = 3828369377014
t1.value12 = 35146531930094
t1.value8 = 16
t1.value3 = t1.value4.fromRGB
t1.value10 = "h%\192\248:b\252\198ˮ"
t1.value6 = 12
t1.value7 = 7
t1.value4 = t1.value3(t1.value6, t1.value7, t1.value8)
t1.value6 = Color3.fromRGB
t1.value8 = 30
t1.value10 = 12
t1.value9 = 38
t1.value7 = t1.value6(t1.value8, t1.value10, t1.value9)
t1.value8 = Color3.fromRGB
t1.value11 = 14
t1.value9 = 26
t1.value12 = "\002&\148o|\001\181"
t1.value10 = t1.value8(t1.value9, t1.value11, 22)
t1.value11 = Color3.fromRGB(52, 22, 20)
t1.value12 = Color3.fromRGB(255, 117, 24)

local color3 = Color3.fromRGB(255, 160, 50)
local color3_2 = Color3.fromRGB(122, 46, 180)
local color3_3 = Color3.fromRGB(176, 96, 255)
local color3_4 = Color3.fromRGB(120, 255, 70)
local color3_5 = Color3.fromRGB(255, 238, 215)
local color3_6 = Color3.fromRGB(190, 140, 105)
local color3_7 = Color3.fromRGB(220, 30, 50)
local color3_8 = Color3.fromRGB(0, 0, 0)

t2.value5 = {
	panel = t1.value4,
	panelLight = t1.value7,
	card = t1.value10,
	cardHot = t1.value11,
	orange = t1.value12,
	flame = color3,
	purple = color3_2,
	witch = color3_3,
	slime = color3_4,
	text = color3_5,
	muted = color3_6,
	red = color3_7,
	black = color3_8
}
t1.value12 = 12275578852948
t1.value9 = 6762923478093
t1.value10 = "\140\135\001\243"
t1.value11 = 23335222979186
t1.value9 = 34151152451102
t1.value10 = "\1583D\020"
t2.value6 = {
	"🎃",
	"👻",
	"🦇",
	"💀",
	"🕷\239\184\143",
	"🧙",
	"🍬",
	"🧛",
	"🕯\239\184\143",
	"⚰\239\184\143"
}
t1.value11 = 31743624559037
t1.value9 = "f\174\190\004"
t1.value12 = 9382466949393
t2.value7 = {
	"🦇",
	"👻",
	"🎃",
	"🕸\239\184\143",
	"🍬",
	"💀",
	"🕷\239\184\143"
}
function t1.value6(p1, p2, p3)
    local v131 = Instance.new(p1)

    v131.Parent = p2

    local _pairs = pairs

    if not p3 then
        p3 = {}
    end

    for v133, v134 in _pairs(p3) do
        v131[v133] = v134
    end

    return v131
end
t2.value8 = t1.value6
function t1.value7(p4, p5)
    return t2.value8("UICorner", p4, {
		CornerRadius = UDim.new(0, p5 or 10)
	})
end
t2.value9 = t1.value7
function t1.value8(p6, p7, p8, p9)
    local value8 = t2.value8
    local v142 = p8 or 1
    local v143 = p9 or 0
    local Border = Enum.ApplyStrokeMode.Border

    return value8("UIStroke", p6, {
		Color = p7,
		Thickness = v142,
		Transparency = v143,
		ApplyStrokeMode = Border
	})
end
function t1.value10(p10, p11, p12, p13)
    local value8 = t2.value8
    local colorSequence = ColorSequence.new(p11, p12)
    local v151 = p13 or 90

    return value8("UIGradient", p10, {
		Color = colorSequence,
		Rotation = v151
	})
end
function t1.value9(p14, p15, p16, p17, p18)
    local value2 = t2.value2
    local new = TweenInfo.new

    if not p17 then
        p17 = Enum.EasingStyle.Quart
    end

    if not p18 then
        p18 = Enum.EasingDirection.Out
    end

    return value2:Create(p14, new(p15, p17, p18), p16)
end
t2.value10 = t1.value8
t2.value11 = t1.value10
t2.value12 = t1.value9
function t1.value9(p19, p20)
    local u161 = false
    local u162
    local inputPosition
    local p20Position
    p19.InputBegan:Connect(function(input)
        local v472 = input.UserInputType == Enum.UserInputType.MouseButton1

        if not v472 then
            v472 = input.UserInputType == Enum.UserInputType.Touch
        end

        if v472 then
            u161 = true
            inputPosition = input.Position
            p20Position = p20.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    u161 = false
                end
            end)
        end
    end)
    p19.InputChanged:Connect(function(input)
        local v474 = input.UserInputType == Enum.UserInputType.MouseMovement

        if not v474 then
            v474 = input.UserInputType == Enum.UserInputType.Touch
        end

        if v474 then
            u162 = input
        end
    end)
    t2.value1.InputChanged:Connect(function(input)
        if input == u162 and u161 then
            local v476 = input.Position - inputPosition

            p20.Position = UDim2.new(p20Position.X.Scale, p20Position.X.Offset + v476.X, p20Position.Y.Scale, p20Position.Y.Offset + v476.Y)
        end
    end)
end
t2.value13 = t1.value2
pcall(function()
    if gethui then
        t2.value13 = gethui()
    end
end)
t1.value12 = t2.value13:FindFirstChild(t2.value3.GuiName)

if t1.value12 then
    t1.value12:Destroy()
end
local value8 = t2.value8
local value13 = t2.value13
local GuiName = t2.value3.GuiName
local Sibling = Enum.ZIndexBehavior.Sibling
t2.value14 = value8("ScreenGui", value13, {
	Name = GuiName,
	ResetOnSpawn = false,
	IgnoreGuiInset = true,
	ZIndexBehavior = Sibling
})
local value8_2 = t2.value8
local value14 = t2.value14
local uDim2 = UDim2.fromOffset(54, 54)
local uDim2_2 = UDim2.new(0.07, 0, 0.18, 0)
local panel = t2.value5.panel
t2.value15 = value8_2("TextButton", value14, {
	Name = "HalloweenToggle",
	Size = uDim2,
	Position = uDim2_2,
	BackgroundColor3 = panel,
	AutoButtonColor = false,
	Text = "",
	Visible = false,
	ZIndex = 30
})
t2.value9(t2.value15, 27)

local value10 = t2.value10
local value15 = t2.value15
local orange = t2.value5.orange
t1.value13 = 0.02
t2.value16 = value10(value15, orange, 2, t1.value13)
t2.value11(t2.value15, t2.value5.cardHot, t2.value5.panel, 135)
t2.value17 = t2.value8("UIScale", t2.value15, {
	Scale = 1
})
local value8_3 = t2.value8
t1.value13 = t2.value15
local uDim2_3 = UDim2.new(1, 0, 0, 34)
local uDim2_4 = UDim2.fromOffset(0, 4)
local GothamBlack = Enum.Font.GothamBlack
value8_3("TextLabel", t1.value13, {
	Size = uDim2_3,
	Position = uDim2_4,
	BackgroundTransparency = 1,
	Text = "🎃",
	TextSize = 28,
	Font = GothamBlack,
	ZIndex = 31
})
local value8_4 = t2.value8
t1.value13 = t2.value15
local uDim2_5 = UDim2.new(1, 0, 0, 12)
local uDim2_6 = UDim2.new(0, 0, 1, -15)
local flame = t2.value5.flame
local GothamBold = Enum.Font.GothamBold
t2.value18 = value8_4("TextLabel", t1.value13, {
	Size = uDim2_5,
	Position = uDim2_6,
	BackgroundTransparency = 1,
	Text = "OPEN",
	TextColor3 = flame,
	Font = GothamBold,
	TextSize = 8,
	ZIndex = 31
})
local value8_5 = t2.value8
local value14_2 = t2.value14
local uDim2_7 = UDim2.fromOffset(290, 360)
local uDim2_8 = UDim2.new(0.5, -145, 0.5, -180)
local panel2 = t2.value5.panel
t2.value19 = value8_5("Frame", value14_2, {
	Name = "HalloweenLibrary",
	Size = uDim2_7,
	Position = uDim2_8,
	BackgroundColor3 = panel2,
	BorderSizePixel = 0,
	Active = true,
	ClipsDescendants = true,
	Visible = false,
	ZIndex = 10
})
t2.value9(t2.value19, 15)
t1.value13 = t2.value10(t2.value19, t2.value5.orange, 1.6, 0.05)
t2.value20 = t1.value13
t2.value11(t2.value19, t2.value5.panelLight, t2.value5.panel, 120)
t2.value21 = t2.value8("UIScale", t2.value19, {
	Scale = 1
})
local function v40()
    local CurrentCamera = workspace.CurrentCamera

    if not CurrentCamera then
        return
    end

    local ViewportSize = CurrentCamera.ViewportSize

    t2.value21.Scale = math.clamp(math.min(ViewportSize.X / 330, ViewportSize.Y / 420), 0.68, 1)
end
v40()
if workspace.CurrentCamera then
    workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(v40)
end
local value8_6 = t2.value8
local value19 = t2.value19
local _UDim2 = UDim2
t1.value14 = 1
local new = _UDim2.new
t1.value16 = 22147848104009
t1.value15 = "\127SK\151]d"
local v45 = new(1, 0, t1.value14, 0)

t1.value14 = 11
t1.value18 = 8142647185103
t1.value15 = "\185KT"
t1.value16 = 11148771267655
t2.value22 = value8_6("Frame", value19, {
	Size = v45,
	BackgroundTransparency = 1,
	ZIndex = t1.value14
})
local value8_7 = t2.value8
local value19_2 = t2.value19
local new2 = UDim2.new
t1.value14 = 0
t1.value20 = 22909673466284
local v49 = new2(1, t1.value14, 0, 70)
local new3 = UDim2.new
t1.value16 = -70
t1.value17 = 2609307157695
t1.value14 = new3(0, 0, 1, t1.value16)

local purple = t2.value5.purple
t1.value15 = 0
t1.value19 = "\248z\n\135\164["
t1.value17 = 12
t1.value19 = "\003\154N"
local v52 = value8_7("Frame", value19_2, {
	Size = v49,
	Position = t1.value14,
	BackgroundColor3 = purple,
	BorderSizePixel = t1.value15,
	ZIndex = t1.value17
})
local value8_8 = t2.value8
t1.value16 = 9853102395884
t1.value18 = 19214427595507
local colorSequence = ColorSequence.new(t2.value5.purple, t2.value5.purple)
local new4 = NumberSequence.new
local new5 = NumberSequenceKeypoint.new
t1.value16 = 0
t1.value17 = 1
t1.value15 = new5(t1.value16, t1.value17)
t1.value16 = NumberSequenceKeypoint
t1.value20 = "b\212;"
t1.value22 = "\247\161\185\133\025\255"
local t3 = {
	t1.value15,
	t1.value16.new(1, 0.72)
}

t1.value17 = 15865251142875
t1.value14 = new4(t3)
value8_8("UIGradient", v52, {
	Color = colorSequence,
	Transparency = t1.value14,
	Rotation = 90
})
local value8_9 = t2.value8
t1.value18 = "\2517\217`o"
local value19_3 = t2.value19
t1.value17 = 15288077474767
t1.value14 = "UDim2"
local _UDim2_2 = UDim2
t1.value16 = "\249Z\202"
t1.value20 = "*\178\145L\016\221"
local new6 = _UDim2_2.new
t1.value14 = 1
t1.value15 = 0
local v62 = new6(t1.value14, 0, 1, t1.value15)

t1.value14 = t2.value5.witch
t1.value19 = 29317142099283
t1.value18 = 21057188734541
local t4 = {
	Size = v62,
	BackgroundColor3 = t1.value14,
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	ZIndex = 40
}
t1.value19 = 25054343114130
t1.value23 = "\173\249AR0\f"
t2.value23 = value8_9("Frame", value19_3, t4)
t1.value15 = 16992302341864
t1.value14 = 23766198233915
t2.value9(t2.value23, 15)

local value8_10 = t2.value8
local value19_4 = t2.value19
t1.value17 = "\188\249\030c\173\193Ԕ\135\b"
t1.value14 = UDim2.fromOffset(46, 46)

local fromOffset = UDim2.fromOffset
t1.value16 = -8
t1.value15 = -8
local v67 = fromOffset(t1.value15, t1.value16)

value8_10("TextLabel", value19_4, {
	Size = t1.value14,
	Position = v67,
	BackgroundTransparency = 1,
	Text = "🕸\239\184\143",
	TextSize = 38,
	TextTransparency = 0.25,
	ZIndex = 19
})
local value8_11 = t2.value8
t1.value15 = 12213054035511
t1.value14 = 22434968398031
t1.value20 = 11553648416004
t1.value18 = 6495825595344
local value19_5 = t2.value19
local fromOffset2 = UDim2.fromOffset
t1.value17 = 21431007291131
t1.value16 = "˘\016\150\212gp]"
t1.value14 = fromOffset2(46, 46)

local new7 = UDim2.new
t1.value15 = 1
t1.value17 = 1
t1.value16 = -38
t1.value18 = -38
local v72 = new7(t1.value15, t1.value16, t1.value17, t1.value18)

value8_11("TextLabel", value19_5, {
	Size = t1.value14,
	Position = v72,
	BackgroundTransparency = 1,
	Text = "🕸\239\184\143",
	TextSize = 38,
	TextTransparency = 0.35,
	Rotation = 180,
	ZIndex = 19
})
local value8_12 = t2.value8
t1.value17 = "/q\r"
t1.value14 = 9051724451959
local value19_6 = t2.value19
t1.value14 = UDim2
t1.value15 = 0
t1.value16 = 28
t1.value17 = 9165421351083
t1.value14 = t1.value14.new(1, -90, t1.value15, t1.value16)

local fromOffset3 = UDim2.fromOffset
t1.value20 = 3298191345151
t1.value15 = 36
t1.value16 = 9
local v76 = fromOffset3(t1.value15, t1.value16)

t1.value18 = "Xd\016n\132\197\219r9\206\139\127\155\206\237\156\2237[\194G\255"
t1.value19 = "O\215D\000"
t1.value17 = t2.value3.HubName
local orange2 = t2.value5.orange
t1.value20 = Enum.Font.Creepster
local Left = Enum.TextXAlignment.Left
t1.value26 = "\186l\181\1311\201"
t1.value27 = 34634201202431
local v79 = value8_12("TextLabel", value19_6, {
	Size = t1.value14,
	Position = v76,
	BackgroundTransparency = 1,
	Text = t1.value17,
	TextColor3 = orange2,
	Font = t1.value20,
	TextSize = 24,
	TextXAlignment = Left,
	ZIndex = 20
})
local value8_13 = t2.value8
t1.value14 = "f\129\167\140\252\157\232\216"
local black = t2.value5.black
t1.value16 = "\202aگ۲\191\128W"
t1.value17 = 6621735488523
value8_13("UIStroke", v79, {
	Color = black,
	Thickness = 1.5
})
t1.value20 = 24596529097917
t1.value16 = 33729039564122
t1.value14 = "\178\142\131\200\225\233\189\000\182"
t1.value26 = 33180666936410
local value8_14 = t2.value8
t1.value15 = "\fU,\003"
local value19_7 = t2.value19
local _UDim2_3 = UDim2
t1.value18 = 26911521173747
t1.value15 = -90
t1.value16 = 0
local v85 = _UDim2_3.new(1, t1.value15, t1.value16, 15)

t1.value17 = "wȡ\148Ã\178\189"
t1.value22 = 27242326733197
local fromOffset4 = UDim2.fromOffset
t1.value16 = 38
t1.value17 = 35
t1.value19 = 4262346082240
t1.value15 = fromOffset4(t1.value16, t1.value17)
t1.value16 = 1
t1.value20 = "\136\205:Q"
t1.value18 = "🦇 " .. string.upper(t2.value3.MapName) .. " 🦇"
t1.value19 = t2.value5.witch
local GothamSemibold = Enum.Font.GothamSemibold
t1.value23 = Enum.TextXAlignment.Left
value8_14("TextLabel", value19_7, {
	Size = v85,
	Position = t1.value15,
	BackgroundTransparency = t1.value16,
	Text = t1.value18,
	TextColor3 = t1.value19,
	Font = GothamSemibold,
	TextSize = 8,
	TextXAlignment = t1.value23,
	ZIndex = 20
})
local value8_15 = t2.value8
t1.value20 = "\003r\141"
local value19_8 = t2.value19
t1.value19 = 30419667842901
t1.value23 = 6348007984012
local fromOffset5 = UDim2.fromOffset
t1.value15 = 28
t1.value16 = 28
local v91 = fromOffset5(t1.value15, t1.value16)

t1.value15 = UDim2.new
t1.value17 = 1
t1.value19 = 8
t1.value18 = -38
t1.value20 = 29869496940117
t1.value16 = t1.value15(t1.value17, t1.value18, 0, t1.value19)

local flame2 = t2.value5.flame
local GothamBold2 = Enum.Font.GothamBold
t1.value26 = "\214\198\247\130T\\V\227"
t1.value27 = 29489204540835
t2.value24 = value8_15("TextButton", value19_8, {
	Size = v91,
	Position = t1.value16,
	BackgroundTransparency = 1,
	AutoButtonColor = false,
	Text = "☠",
	TextColor3 = flame2,
	Font = GothamBold2,
	TextSize = 20,
	ZIndex = 21
})
local value8_16 = t2.value8
t1.value18 = 7809718226484
t1.value17 = "\179\223s\244"
local value19_9 = t2.value19
local new8 = UDim2.new
t1.value16 = 1
t1.value17 = 0
t1.value23 = 31964462119460
t1.value18 = 0
t1.value15 = new8(t1.value16, t1.value17, t1.value18, 2)
t1.value17 = UDim2.fromOffset(0, 58)
t1.value18 = t2.value5.orange
local v97 = value8_16("Frame", value19_9, {
	Size = t1.value15,
	Position = t1.value17,
	BackgroundColor3 = t1.value18,
	BorderSizePixel = 0,
	ZIndex = 20
})
local value8_17 = t2.value8
t1.value18 = 29443259446670
t1.value15 = "}\2291\230\148 \145\152\250\149"
t1.value23 = "01\245u\143\v"
t1.value16 = "ColorSequence"
t1.value15 = ColorSequence
t1.value20 = 28785306301532
t1.value26 = 32879607364558
local new9 = t1.value15.new
t1.value18 = ColorSequenceKeypoint.new(0, t2.value5.orange)
t1.value17 = ColorSequenceKeypoint.new
t1.value20 = t2.value5.purple
t1.value23 = 21423161091831
t1.value22 = "FF\158\167~"
local v100 = t1.value17(0.5, t1.value20)

t1.value17 = ColorSequenceKeypoint.new
local slime = t2.value5.slime
local t5 = {
	t1.value18,
	v100,
	t1.value17(1, slime)
}

t1.value17 = 5320932067757
t1.value16 = t5
t1.value15 = new9(t1.value16)

local t6 = {
	Color = t1.value15
}
t1.value20 = 3794574083814
t1.value22 = 15035257527129
t1.value21 = 20532554507609
t1.value19 = 2552450647204
t1.value14 = t6
t2.value25 = value8_17("UIGradient", v97, t1.value14)

local value8_18 = t2.value8
local value19_10 = t2.value19
t1.value18 = UDim2.new
t1.value19 = 1
t1.value20 = -24
local v106 = t1.value18(t1.value19, t1.value20, 0, 252)

t1.value20 = UDim2.fromOffset(12, 72)
t1.value22 = "UDim2"
t1.value25 = "\237c\253"
t1.value23 = UDim2.new
t1.value27 = 0
t1.value24 = 0
t1.value25 = 9340089962749
t1.value22 = 0
local v107 = t1.value23(t1.value22, t1.value24, 0, t1.value27)

t1.value22 = Enum.AutomaticSize.Y
t1.value25 = t2.value5.orange
local ScrollingDirectionY = Enum.ScrollingDirection.Y
t2.value26 = value8_18("ScrollingFrame", value19_10, {
	Name = "FeatureList",
	Size = v106,
	Position = t1.value20,
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	CanvasSize = v107,
	AutomaticCanvasSize = t1.value22,
	ScrollBarThickness = 3,
	ScrollBarImageColor3 = t1.value25,
	ScrollingDirection = ScrollingDirectionY,
	ZIndex = 20
})
local value8_19 = t2.value8
local value26 = t2.value26
t1.value18 = UDim.new(0, 7)

local SortOrderLayoutOrder = Enum.SortOrder.LayoutOrder
t1.value15 = {
	Padding = t1.value18,
	SortOrder = SortOrderLayoutOrder
}
t1.value18 = 22470645131487
t1.value17 = "L\228얲\167LCM"
value8_19("UIListLayout", value26, t1.value15)

local value8_20 = t2.value8
local value26_2 = t2.value26
t1.value19 = "\195\025\"\180\230>\243)\205*\222\195u"
t1.value20 = 34651139817223
t1.value18 = UDim.new(0, 6)
t1.value15 = {
	PaddingBottom = t1.value18
}
t1.value21 = 25368135970340
value8_20("UIPadding", value26_2, t1.value15)
t2.value27 = t2.value26
local value8_21 = t2.value8
t1.value15 = t2.value19
t1.value18 = UDim2.new
t1.value26 = 30453298968420
t1.value19 = 1
t1.value20 = -24
local v115 = t1.value18(t1.value19, t1.value20, 0, 18)

t1.value20 = UDim2.new(0, 12, 1, -25)
t1.value25 = "|\162\v\173\226"
t1.value24 = "\252\134\177\143\1639\135\227\006\204"
t1.value23 = t2.value5.muted
t1.value27 = ">\143\226\155"
t1.value25 = 1729750287141
t1.value22 = Enum.Font.GothamSemibold
t1.value25 = Enum.TextXAlignment.Center
t2.value28 = value8_21("TextLabel", t1.value15, {
	Size = v115,
	Position = t1.value20,
	BackgroundTransparency = 1,
	Text = "👻 0 SCRIPTS  •  LP10  •  HAPPY HALLOWEEN 🎃",
	TextColor3 = t1.value23,
	Font = t1.value22,
	TextSize = 8,
	TextXAlignment = t1.value25,
	ZIndex = 20
})
t2.value29 = 0
t2.value30 = nil
t2.value31 = nil
t1.value16 = Random.new()
t2.value32 = nil
function t1.value17(p21, p22, p23, p24, p25)
    local value8_22 = t2.value8
    local uDim2_9 = UDim2.fromOffset(p24, p24)
    local uDim2_10 = UDim2.new(p23, 0, 1, 0)
    local v175 = t2.value32:NextInteger(-25, 25)
    local v176 = value8_22("TextLabel", p22, {
		Size = uDim2_9,
		Position = uDim2_10,
		BackgroundTransparency = 1,
		Text = p21,
		TextSize = p24,
		TextTransparency = 0.45,
		Rotation = v175,
		ZIndex = 11
	})
    local value12 = t2.value12
    local uDim2_11 = UDim2.new(p23 + t2.value32:NextNumber(-0.12, 0.12), 0, -0.1, 0)
    local v179 = t2.value32:NextInteger(-50, 50)

    value12(v176, p25, {
		Position = uDim2_11,
		TextTransparency = 1,
		Rotation = v179
	}, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut):Play()
    task.delay(p25 + 0.1, function()
        if v176 then
            v176:Destroy()
        end
    end)
end
t2.value32 = t1.value16
t2.value33 = t1.value17
function t1.value18(p26, p27)
    for _ = 1, p27 do
        local value8_23 = t2.value8
        local value14_3 = t2.value14
        local uDim2_12 = UDim2.fromOffset(18, 18)
        local vector2 = Vector2.new(0.5, 0.5)
        local uDim2_13 = UDim2.fromOffset(p26.X, p26.Y)
        local v188 = t2.value6[t2.value32:NextInteger(1, #t2.value6)]
        local v189 = t2.value32:NextInteger(14, 22)
        local v190 = value8_23("TextLabel", value14_3, {
			Size = uDim2_12,
			AnchorPoint = vector2,
			Position = uDim2_13,
			BackgroundTransparency = 1,
			Text = v188,
			TextSize = v189,
			ZIndex = 60
		})
        local v191 = t2.value32:NextNumber(0, math.pi * 2)
        local v192 = t2.value32:NextNumber(35, 80)
        local value12 = t2.value12
        local uDim2_14 = UDim2.fromOffset(p26.X + math.cos(v191) * v192, p26.Y + math.sin(v191) * v192 - 20)
        local v195 = t2.value32:NextInteger(-90, 90)

        value12(v190, 0.7, {
			Position = uDim2_14,
			TextTransparency = 1,
			Rotation = v195
		}):Play()
        task.delay(0.8, function()
            if v190 then
                v190:Destroy()
            end
        end)
    end
end
t2.value34 = t1.value18
function t2.value35()
    t2.value12(t2.value23, 0.05, {
		BackgroundTransparency = 0.7
	}):Play()
    task.delay(0.08, function()
        t2.value12(t2.value23, 0.08, {
			BackgroundTransparency = 1
		}):Play()
        task.delay(0.12, function()
            t2.value12(t2.value23, 0.05, {
				BackgroundTransparency = 0.8
			}):Play()
            task.delay(0.07, function()
                t2.value12(t2.value23, 0.35, {
					BackgroundTransparency = 1
				}):Play()
            end)
        end)
    end)
end
t2.value36 = nil
t2.value36 = 0
function t2.value37(p28, p29)
    t2.value36 = t2.value36 % #t2.value6 + 1

    local value8_24 = t2.value8
    local value27 = t2.value27
    local uDim2_15 = UDim2.new(1, -5, 0, 74)
    local card = t2.value5.card
    local v202 = 1000 + p29
    local v203 = value8_24("Frame", value27, {
		Name = "ScriptCard",
		Size = uDim2_15,
		BackgroundColor3 = card,
		BorderSizePixel = 0,
		LayoutOrder = v202,
		ZIndex = 21
	})

    t2.value9(v203, 11)

    local v204 = t2.value10(v203, t2.value5.orange, 1, 0.55)

    t2.value11(v203, t2.value5.cardHot, t2.value5.card, 135)

    local value8_25 = t2.value8
    local uDim2_16 = UDim2.fromOffset(36, 74)
    local uDim2_17 = UDim2.fromOffset(8, 0)
    local str = tostring(p28.Icon or t2.value6[t2.value36])

    value8_25("TextLabel", v203, {
		Size = uDim2_16,
		Position = uDim2_17,
		BackgroundTransparency = 1,
		Text = str,
		TextSize = 24,
		ZIndex = 22
	})

    local value8_26 = t2.value8
    local uDim2_18 = UDim2.new(1, -128, 0, 20)
    local uDim2_19 = UDim2.fromOffset(50, 11)
    local str2 = tostring(p28.N or "Unnamed Script")
    local text = t2.value5.text
    local GothamBold3 = Enum.Font.GothamBold
    local AtEnd = Enum.TextTruncate.AtEnd
    local Left2 = Enum.TextXAlignment.Left

    value8_26("TextLabel", v203, {
		Size = uDim2_18,
		Position = uDim2_19,
		BackgroundTransparency = 1,
		Text = str2,
		TextColor3 = text,
		Font = GothamBold3,
		TextSize = 11,
		TextTruncate = AtEnd,
		TextXAlignment = Left2,
		ZIndex = 22
	})

    local value8_27 = t2.value8
    local uDim2_20 = UDim2.new(1, -128, 0, 30)
    local uDim2_21 = UDim2.fromOffset(50, 32)
    local _tostring = tostring
    local F = p28.F

    if not F then
        F = p28.Cat or "Ready to be summoned."
    end

    local v222 = _tostring(F)
    local muted = t2.value5.muted
    local Gotham = Enum.Font.Gotham
    local Left3 = Enum.TextXAlignment.Left
    local Top = Enum.TextYAlignment.Top

    value8_27("TextLabel", v203, {
		Size = uDim2_20,
		Position = uDim2_21,
		BackgroundTransparency = 1,
		Text = v222,
		TextColor3 = muted,
		Font = Gotham,
		TextSize = 8,
		TextWrapped = true,
		TextXAlignment = Left3,
		TextYAlignment = Top,
		ZIndex = 22
	})

    if p28.New then
        local value8_28 = t2.value8
        local uDim2_22 = UDim2.fromOffset(62, 14)
        local uDim2_23 = UDim2.new(1, -72, 0, 7)
        local slime2 = t2.value5.slime
        local black2 = t2.value5.black
        local GothamBlack2 = Enum.Font.GothamBlack
        local v233 = value8_28("TextLabel", v203, {
			Size = uDim2_22,
			Position = uDim2_23,
			BackgroundColor3 = slime2,
			Text = "🔥 NEW",
			TextColor3 = black2,
			Font = GothamBlack2,
			TextSize = 7,
			ZIndex = 23
		})

        t2.value9(v233, 5)
        task.spawn(function()
            while true do
                local v477 = v233

                if v477 then
                    v477 = v233.Parent
                end

                if not v477 then
                    break
                end

                local value12 = t2.value12
                local v479 = v233
                local orange3 = t2.value5.orange
                local _Enum = Enum

                value12(v479, 0.7, {
					BackgroundColor3 = orange3
				}, _Enum.EasingStyle.Sine):Play()
                task.wait(0.75)

                local v482 = v233

                if v482 then
                    v482 = v233.Parent
                end

                if not v482 then
                    return
                end

                t2.value12(v233, 0.7, {
					BackgroundColor3 = t2.value5.slime
				}, Enum.EasingStyle.Sine):Play()
                task.wait(0.75)
            end
        end)
    end

    local value8_29 = t2.value8
    local uDim2_24 = UDim2.fromOffset(62, 25)
    local uDim2_25 = UDim2.new(1, -72, 0.5, -9)
    local orange4 = t2.value5.orange
    local black3 = t2.value5.black
    local GothamBlack3 = Enum.Font.GothamBlack
    local v240 = value8_29("TextButton", v203, {
		Size = uDim2_24,
		Position = uDim2_25,
		BackgroundColor3 = orange4,
		AutoButtonColor = false,
		Text = "🎃 CAST",
		TextColor3 = black3,
		Font = GothamBlack3,
		TextSize = 8,
		ZIndex = 23
	})

    t2.value9(v240, 8)
    t2.value10(v240, t2.value5.flame, 0.8, 0.3)

    local function v241()
        task.delay(1.1, function()
            local v539 = v240

            if v539 then
                v539 = v240.Parent
            end

            if v539 then
                v240.Text = "🎃 CAST"
                v240.BackgroundColor3 = t2.value5.orange
            end
        end)
    end

    v240.MouseEnter:Connect(function()
        t2.value12(v240, 0.14, {
			BackgroundColor3 = t2.value5.flame
		}):Play()
        t2.value12(v204, 0.14, {
			Transparency = 0.1
		}):Play()
    end)
    v240.MouseLeave:Connect(function()
        t2.value12(v240, 0.14, {
			BackgroundColor3 = t2.value5.orange
		}):Play()
        t2.value12(v204, 0.14, {
			Transparency = 0.55
		}):Play()
    end)
    v240.MouseButton1Click:Connect(function()
        local v483 = v240.AbsolutePosition + v240.AbsoluteSize / 2

        t2.value34(v483, 7)

        local v484 = type(p28.S) ~= "string"

        if not v484 then
            v484 = p28.S == ""
        end

        if v484 then
            v240.Text = "💀 EMPTY"
            v240.BackgroundColor3 = t2.value5.red
            v241()

            return
        end

        v240.Text = "🕯\239\184\143 SUMMON"
        task.spawn(function()
            local ok, result = pcall(function()
                local v549 = loadstring(p28.S)

                if v549 then
                    v549()
                end
            end)
            local v542 = v240

            if v542 then
                v542 = v240.Parent
            end

            if v542 then
                local v543 = v240
                local v544 = ok and "👻 DONE"

                if not v544 then
                    v544 = "☠ CURSED"
                end

                v543.Text = v544

                local v545 = v240
                local v546 = ok

                if ok then
                    v546 = t2.value5.slime
                end

                if not v546 then
                    v546 = t2.value5.red
                end

                v545.BackgroundColor3 = v546
                v241()
            end

            if not ok then
                warn("[LP10 HALLOWEEN] " .. tostring(result))
            end
        end)
    end)

    local v242 = t2.value8("UIScale", v203, {
		Scale = 0.85
	})

    t2.value12(v242, 0.25, {
		Scale = 1
	}, Enum.EasingStyle.Back):Play()
end
function t2.value38()
    for _, child in ipairs(t2.value27:GetChildren()) do
        if child.Name == "ScriptCard" then
            child:Destroy()
        end
    end

    for i, v in ipairs(t2.value4) do
        t2.value37(v, i)
    end

    t2.value31()
end
function t2.value31()
    t2.value28.Text = "🎃 " .. tostring(t2.value29 + #t2.value4) .. " FEATURES  •  LP10  •  HAPPY HALLOWEEN 👻"
end
t2.value30 = 0
function t2.value39()
    t2.value30 = t2.value30 + 1

    return t2.value30
end
local fromRGB = Color3.fromRGB
t1.value24 = 48
t1.value26 = 30
t1.value27 = 40
t1.value22 = fromRGB(t1.value24, t1.value26, t1.value27)

function t1.value24(p30, ...)
    if type(p30) ~= "function" then
        return
    end

    local ok, result = pcall(p30, ...)

    if not ok then
        warn("[LP10 HALLOWEEN] " .. tostring(result))
    end
end
t2.value40 = t1.value22
t2.value41 = nil
function t1.value26(p31)
    local value8_30 = t2.value8
    local value26_3 = t2.value26
    local uDim2_26 = UDim2.new(1, -5, 0, 26)
    local card = t2.value5.card
    local v273 = t2.value39()
    local v274 = value8_30("Frame", value26_3, {
		Size = uDim2_26,
		BackgroundColor3 = card,
		BorderSizePixel = 0,
		LayoutOrder = v273,
		ZIndex = 21
	})

    t2.value9(v274, 8)
    t2.value10(v274, t2.value5.purple, 1, 0.6)

    local value8_31 = t2.value8
    local uDim2_27 = UDim2.new(1, -12, 1, 0)
    local uDim2_28 = UDim2.fromOffset(6, 0)
    local str = tostring(p31)
    local witch = t2.value5.witch
    local GothamSemibold2 = Enum.Font.GothamSemibold

    value8_31("TextLabel", v274, {
		Size = uDim2_27,
		Position = uDim2_28,
		BackgroundTransparency = 1,
		Text = str,
		TextColor3 = witch,
		Font = GothamSemibold2,
		TextSize = 9,
		ZIndex = 22
	})
end
function t1.value25(p32)
    local str = tostring(p32.value or "== Select ==")
    local u283 = false
    local n1 = 46
    local value8_32 = t2.value8
    local value26_4 = t2.value26
    local uDim2_29 = UDim2.new(1, -5, 0, n1)
    local card = t2.value5.card
    local v289 = t2.value39()
    local v290 = value8_32("Frame", value26_4, {
		Size = uDim2_29,
		BackgroundColor3 = card,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		LayoutOrder = v289,
		ZIndex = 21
	})

    t2.value9(v290, 10)
    t2.value10(v290, t2.value5.orange, 1, 0.5)
    t2.value11(v290, t2.value5.cardHot, t2.value5.card, 135)

    local value8_33 = t2.value8
    local uDim2_30 = UDim2.new(1, -24, 0, 14)
    local uDim2_31 = UDim2.fromOffset(12, 5)
    local str3 = tostring(p32.text or "Select")
    local muted = t2.value5.muted
    local GothamBold4 = Enum.Font.GothamBold
    local Left4 = Enum.TextXAlignment.Left

    value8_33("TextLabel", v290, {
		Size = uDim2_30,
		Position = uDim2_31,
		BackgroundTransparency = 1,
		Text = str3,
		TextColor3 = muted,
		Font = GothamBold4,
		TextSize = 9,
		TextXAlignment = Left4,
		ZIndex = 22
	})

    local value8_34 = t2.value8
    local uDim2_32 = UDim2.new(1, -20, 0, 20)
    local uDim2_33 = UDim2.fromOffset(10, 21)
    local panel3 = t2.value5.panel
    local v302 = str .. "  v"
    local flame3 = t2.value5.flame
    local GothamBold5 = Enum.Font.GothamBold
    local AtEnd = Enum.TextTruncate.AtEnd
    local v306 = value8_34("TextButton", v290, {
		Size = uDim2_32,
		Position = uDim2_33,
		BackgroundColor3 = panel3,
		AutoButtonColor = false,
		Text = v302,
		TextColor3 = flame3,
		Font = GothamBold5,
		TextSize = 9,
		TextTruncate = AtEnd,
		ZIndex = 23
	})

    t2.value9(v306, 6)
    t2.value10(v306, t2.value5.orange, 1, 0.55)

    local value8_35 = t2.value8
    local uDim2_34 = UDim2.new(1, -20, 0, 0)
    local uDim2_35 = UDim2.fromOffset(10, 46)
    local uDim2_36 = UDim2.new(0, 0, 0, 0)
    local AutomaticSizeY = Enum.AutomaticSize.Y
    local orange5 = t2.value5.orange
    local v313 = value8_35("ScrollingFrame", v290, {
		Size = uDim2_34,
		Position = uDim2_35,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		CanvasSize = uDim2_36,
		AutomaticCanvasSize = AutomaticSizeY,
		ScrollBarThickness = 2,
		ScrollBarImageColor3 = orange5,
		Visible = false,
		ZIndex = 23
	})
    local value8_36 = t2.value8
    local uDim = UDim.new(0, 2)
    local SortOrderLayoutOrder2 = Enum.SortOrder.LayoutOrder

    value8_36("UIListLayout", v313, {
		Padding = uDim,
		SortOrder = SortOrderLayoutOrder2
	})

    local function v317()
        local values = p32.values

        if type(values) == "function" then
            local ok, result = pcall(values)

            values = ok and result

            if not values then
                values = {}
            end
        end

        return type(values) == "table" and values or {}
    end
    local function v318()
        u283 = false
        t2.value12(v290, 0.18, {
			Size = UDim2.new(1, -5, 0, n1)
		}):Play()
        task.delay(0.18, function()
            if not u283 then
                v313.Visible = false
            end
        end)
    end
    local function v319(p33)
        str = tostring(p33)
        v306.Text = str .. "  v"
        t2.value41(p32.callback, str)
        v318()
    end
    local function v320()

        for v491, v492 in ipairs(v313:GetChildren()) do

            if v492:IsA("TextButton") then
                v492:Destroy()
            end
        end
        local u493 = v317()
        if #u493 == 0 then
            u493 = { "(nothing found)" }
        end
        for i, v in ipairs(u493) do
            local v496 = v
            local value8_37 = t2.value8
            local v498 = v313
            local uDim2_37 = UDim2.new(1, -4, 0, 20)
            local panel4 = t2.value5.panel
            local v501 = "🕸\239\184\143 " .. tostring(v496)
            local text = t2.value5.text
            local Gotham = Enum.Font.Gotham
            local v504 = value8_37("TextButton", v498, {
				Size = uDim2_37,
				BackgroundColor3 = panel4,
				AutoButtonColor = false,
				Text = v501,
				TextColor3 = text,
				Font = Gotham,
				TextSize = 9,
				LayoutOrder = i,
				ZIndex = 24
			})

            t2.value9(v504, 5)
            v504.MouseEnter:Connect(function()
                t2.value12(v504, 0.1, {
					BackgroundColor3 = t2.value5.cardHot
				}):Play()
            end)
            v504.MouseLeave:Connect(function()
                t2.value12(v504, 0.1, {
					BackgroundColor3 = t2.value5.panel
				}):Play()
            end)
            v504.MouseButton1Click:Connect(function()
                if u493[1] == "(nothing found)" then
                    v318()

                    return
                end

                v319(v496)
            end)
        end
        local v505 = math.min(#u493, 5) * 22
        v313.Size = UDim2.new(1, -20, 0, v505)
        v313.Visible = true
        u283 = true
        t2.value12(v290, 0.2, {
			Size = UDim2.new(1, -5, 0, n1 + v505 + 8)
		}):Play()
    end

    v306.MouseButton1Click:Connect(function()
        if u283 then
            v318()

            return
        end

        v320()
    end)
    t2.value29 = t2.value29 + 1

    if t2.value31 then
        t2.value31()
    end

    return {
		Set = function(p34)
        str = tostring(p34)
        v306.Text = str .. "  v"
    end,
		Get = function()
        return str
    end
	}
end
t2.value41 = t1.value24
function t1.value27(p35)
    local u322 = false
    local value8_38 = t2.value8
    local value26_5 = t2.value26
    local uDim2_38 = UDim2.new(1, -5, 0, 42)
    local card = t2.value5.card
    local v327 = t2.value39()
    local v328 = value8_38("Frame", value26_5, {
		Size = uDim2_38,
		BackgroundColor3 = card,
		BorderSizePixel = 0,
		LayoutOrder = v327,
		ZIndex = 21
	})

    t2.value9(v328, 10)

    local v329 = t2.value10(v328, t2.value5.orange, 1, 0.6)

    t2.value11(v328, t2.value5.cardHot, t2.value5.card, 135)

    local value8_39 = t2.value8
    local uDim2_39 = UDim2.new(1, -72, 1, 0)
    local uDim2_40 = UDim2.fromOffset(12, 0)
    local str = tostring(p35.text or "Toggle")
    local text = t2.value5.text
    local GothamBold6 = Enum.Font.GothamBold
    local AtEnd = Enum.TextTruncate.AtEnd
    local Left5 = Enum.TextXAlignment.Left

    value8_39("TextLabel", v328, {
		Size = uDim2_39,
		Position = uDim2_40,
		BackgroundTransparency = 1,
		Text = str,
		TextColor3 = text,
		Font = GothamBold6,
		TextSize = 11,
		TextTruncate = AtEnd,
		TextXAlignment = Left5,
		ZIndex = 22
	})

    local value8_40 = t2.value8
    local uDim2_41 = UDim2.fromOffset(40, 20)
    local uDim2_42 = UDim2.new(1, -52, 0.5, -10)
    local v341 = value8_40("Frame", v328, {
		Size = uDim2_41,
		Position = uDim2_42,
		BackgroundColor3 = t2.value40,
		BorderSizePixel = 0,
		ZIndex = 22
	})

    t2.value9(v341, 10)
    t2.value10(v341, t2.value5.orange, 1, 0.5)

    local value8_41 = t2.value8
    local uDim2_43 = UDim2.fromOffset(14, 14)
    local uDim2_44 = UDim2.new(0, 3, 0.5, -7)
    local text2 = t2.value5.text
    local v346 = value8_41("Frame", v341, {
		Size = uDim2_43,
		Position = uDim2_44,
		BackgroundColor3 = text2,
		BorderSizePixel = 0,
		ZIndex = 23
	})

    t2.value9(v346, 7)

    local function v347(p36, p37)
        u322 = not not p36 and (true or false)

        local value12 = t2.value12
        local v510 = v346
        local v511 = u322

        if v511 then
            v511 = UDim2.new(1, -17, 0.5, -7)
        end

        if not v511 then
            v511 = UDim2.new(0, 3, 0.5, -7)
        end

        local v512 = u322

        if v512 then
            v512 = t2.value5.black
        end

        if not v512 then
            v512 = t2.value5.text
        end

        value12(v510, 0.18, {
			Position = v511,
			BackgroundColor3 = v512
		}, Enum.EasingStyle.Back):Play()

        local value12_2 = t2.value12
        local v514 = v341
        local v515 = u322

        if v515 then
            v515 = t2.value5.orange
        end

        value12_2(v514, 0.18, {
			BackgroundColor3 = v515 or t2.value40
		}):Play()
        t2.value12(v329, 0.18, {
			Transparency = not u322 and 0.6 or 0.15
		}):Play()

        if u322 and not p37 then
            t2.value34(v341.AbsolutePosition + v341.AbsoluteSize / 2, 4)
        end

        if not p37 then
            t2.value41(p35.callback, u322)
        end
    end

    t2.value8("TextButton", v328, {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Text = "",
		ZIndex = 25
	}).MouseButton1Click:Connect(function()
        v347(not u322)
    end)

    if p35.state then
        v347(true, false)
    end

    local _ = t2.value29 + 1

    if t2.value31 then
        t2.value31()
    end

    return {
		Set = function(p38)
        v347(p38)
    end,
		Get = function()
        return u322
    end
	}
end
function t1.value24(p39)
    local value8_42 = t2.value8
    local value26_6 = t2.value26
    local uDim2_45 = UDim2.new(1, -5, 0, 24)
    local v353 = t2.value39()
    local v354 = value8_42("Frame", value26_6, {
		Size = uDim2_45,
		BackgroundTransparency = 1,
		LayoutOrder = v353,
		ZIndex = 21
	})
    local value8_43 = t2.value8
    local uDim2_46 = UDim2.new(1, 0, 1, 0)
    local v357 = "🕯\239\184\143 " .. tostring(p39) .. " 🕯\239\184\143"
    local orange6 = t2.value5.orange
    local Creepster = Enum.Font.Creepster

    value8_43("TextLabel", v354, {
		Size = uDim2_46,
		BackgroundTransparency = 1,
		Text = v357,
		TextColor3 = orange6,
		Font = Creepster,
		TextSize = 16,
		ZIndex = 22
	})
end
local function v117(p40)
    t2.value19.Visible = p40

    local value18 = t2.value18
    local v362 = p40

    if p40 then
        v362 = "CLOSE"
    end

    if not v362 then
        v362 = "OPEN"
    end

    value18.Text = v362

    if p40 then
        t2.value21.Scale = 0.88
        t2.value12(t2.value21, 0.26, {
			Scale = 1
		}, Enum.EasingStyle.Back):Play()

        if t2.value3.Lightning then
            t2.value35()
        end
    end
end
t2.value24.MouseEnter:Connect(function()
    t2.value12(t2.value24, 0.14, {
		TextColor3 = t2.value5.red
	}):Play()
end)
t2.value24.MouseLeave:Connect(function()
    t2.value12(t2.value24, 0.14, {
		TextColor3 = t2.value5.flame
	}):Play()
end)
t2.value24.MouseButton1Click:Connect(function()
    t2.value19.Visible = false

    local value18 = t2.value18
    local v364 = false

    if not v364 then
        v364 = "OPEN"
    end

    value18.Text = v364
end)
t2.value15.MouseEnter:Connect(function()
    t2.value12(t2.value17, 0.15, {
		Scale = 1.12
	}, Enum.EasingStyle.Back):Play()
    t2.value12(t2.value15, 0.14, {
		BackgroundColor3 = t2.value5.cardHot
	}):Play()
end)
t2.value15.MouseLeave:Connect(function()
    t2.value12(t2.value17, 0.15, {
		Scale = 1
	}):Play()
    t2.value12(t2.value15, 0.14, {
		BackgroundColor3 = t2.value5.panel
	}):Play()
end)
t2.value15.MouseButton1Click:Connect(function()
    v117(not t2.value19.Visible)
end)
t1.value9(t2.value19, t2.value19)
t1.value9(t2.value15, t2.value15)
t1.value1.Heartbeat:Connect(function()
    local v365 = not t2.value14

    if not v365 then
        v365 = not t2.value14.Parent
    end

    if v365 then
        return
    end

    local elapsed = os.clock()
    local v367 = (math.sin(elapsed * 0.9) + 1) / 2
    local v368 = (math.sin(elapsed * 13) * math.sin(elapsed * 7.3) + 1) * 0.04 + 0.05

    t2.value20.Color = t2.value5.orange:Lerp(t2.value5.purple, v367)
    t2.value20.Transparency = v368
    t2.value16.Color = t2.value5.orange:Lerp(t2.value5.slime, (math.sin(elapsed * 1.4) + 1) / 2 * 0.6)
    t2.value16.Thickness = 2 + math.sin(elapsed * 3) * 0.7
    t2.value25.Offset = Vector2.new(math.sin(elapsed * 0.8) * 0.6, 0)
end)

if t2.value3.Ambient then
    task.spawn(function()
        while true do
            local value14_4 = t2.value14

            if value14_4 then
                value14_4 = t2.value14.Parent
            end

            if not value14_4 then
                break
            end

            task.wait(t2.value32:NextNumber(1.2, 2.4))

            if t2.value19.Visible then
                t2.value33(t2.value7[t2.value32:NextInteger(1, #t2.value7)], t2.value22, t2.value32:NextNumber(0.05, 0.85), t2.value32:NextInteger(14, 22), t2.value32:NextNumber(4, 6.5))
            end
        end
    end)
end
if t2.value3.Lightning then
    task.spawn(function()
        while true do
            local value14_5 = t2.value14

            if value14_5 then
                value14_5 = t2.value14.Parent
            end

            if not value14_5 then
                break
            end

            task.wait(t2.value32:NextNumber(9, 18))

            if t2.value19.Visible then
                t2.value35()
            end
        end
    end)
end
local t7 = {}
local function v119(p41, p42)
    for _, descendant in ipairs(p41:GetDescendants()) do
        if descendant:IsA("TextLabel") then
            t2.value12(descendant, p42, {
				TextTransparency = 1,
				TextStrokeTransparency = 1
			}):Play()
        elseif descendant:IsA("Frame") then
            t2.value12(descendant, p42, {
				BackgroundTransparency = 1
			}):Play()
        elseif descendant:IsA("UIStroke") then
            t2.value12(descendant, p42, {
				Transparency = 1
			}):Play()
        end
    end

    if p41:IsA("Frame") then
        t2.value12(p41, p42, {
			BackgroundTransparency = 1
		}):Play()
    end
end
function t7.AddScript(p43)
    if type(p43) ~= "table" or not p43.N then
        return false
    end

    table.insert(t2.value4, p43)
    t2.value38()

    return true
end
t2.value42 = nil
t7.AddButton = t7.AddScript
function t7.SetScripts(p44)
    if type(p44) ~= "table" then
        return false
    end

    t2.value38()

    return true
end
t7.AddToggle = t1.value27
t7.AddDropdown = t1.value25
t7.AddLabel = t1.value26
t7.AddSection = t1.value24
function t7.Open()
    v117(true)
end
function t7.Close()
    t2.value19.Visible = false

    local value18 = t2.value18
    local v433 = false

    if not v433 then
        v433 = "OPEN"
    end

    value18.Text = v433
end
function t7.Strike()
    t2.value35()
end
_G.LP10CompactLibrary = t7
_G.LP10HalloweenLibrary = t7
t2.value38()
t2.value43 = game:GetService("ReplicatedStorage")
t2.value44 = game:GetService("Players").LocalPlayer
t1.value28 = {}
t2.value45 = {}
t2.value46 = t1.value28
t2.value47 = nil
function t1.value28(p45, p46)
    local u438 = p46

    return function(p47)
        t2.value45[p45] = p47

        if not p47 then
            return
        end

        local value46 = t2.value46
        local v537 = t2.value46[p45]

        value46[p45] = (v537 or 0) + 1

        local v538 = t2.value46[p45]

        task.spawn(function()
            while true do
                local v547 = t2.value45[p45]

                if v547 then

                    v547 = t2.value46[p45] == v538
                end

                if not v547 then
                    break
                end

                pcall(u438)
                task.wait()
            end
        end)
    end
end
t2.value48 = nil
function t2.value48(p48, p49)
    return t2.value43.src.Packages._Index:FindFirstChild("sleitnick_knit@1.7.0").knit.Services[p48].RF[p49]
end
t2.value42 = nil
function t2.value49()
    local value42 = t2.value42

    if value42 then
        value42 = t2.value42.Parent
    end

    if value42 then
        return t2.value42
    end

    local Structures = workspace:FindFirstChild("Structures")

    if Structures then
        Structures = Structures:FindFirstChild("Bases")
    end

    if not Structures then
        return nil
    end

    for _, descendant in ipairs(Structures:GetDescendants()) do
        local v430 = descendant:IsA("TextLabel")

        if v430 then
            v430 = descendant.Name == "PlayerName"

            if v430 then
                v430 = descendant.Text == "YOUR BASE"
            end
        end

        if v430 then
            t2.value42 = descendant.Parent.Parent.Parent.Parent

            return t2.value42
        end
    end

    return nil
end
t1.value24("CLIMB FOR ANIMALS EGGS")
t1.value25({
	text = "🦇 Zone List",
	value = "== Select Zone ==",
	values = function()
    local t8 = {}
    local SpawnedEggs = workspace:FindFirstChild("SpawnedEggs")

    if SpawnedEggs then
        for _, child in ipairs(SpawnedEggs:GetChildren()) do
            table.insert(t8, child.Name)
        end
    end

    return t8
end,
	callback = function(p50)
    t2.value47 = p50
end
})
local v120 = t1.value28("Steal", function()
    local value47 = t2.value47

    if value47 then
        value47 = workspace.SpawnedEggs:FindFirstChild(t2.value47)
    end

    if value47 then
        for _, child in ipairs(value47:GetChildren()) do
            if child:GetAttribute("EggId") then
                local HumanoidRootPart = t2.value44.Character.HumanoidRootPart

                HumanoidRootPart.CFrame = child.Hitbox.CFrame
                task.wait(0.2)
                fireproximityprompt(child.Hitbox.PromptAnchor.StealPrompt)
                task.wait(0.2)
                HumanoidRootPart.CFrame = workspace.SafeZone.CFrame

                break
            end
        end
    end

    task.wait(1)
end)

t1.value27({
	text = "🥚 Auto Steal",
	callback = v120
})
local v121 = t1.value28("Place", function()
    local v456 = t2.value49()
    if not v456 then
        task.wait(1)

        return
    end
    local Fences = v456:FindFirstChild("Fences")
    if not Fences then
        return
    end
    local Character = t2.value44.Character
    if not Character then
        Character = t2.value44.CharacterAdded:Wait()
    end
    local v459
    local t9 = {
		t2.value44:WaitForChild("Backpack"),
		Character
	}
    local v461, v462, v463 = ipairs(t9)
    repeat
        local v464

        v463, v464 = v461(v462, v463)

        if not v463 then
            break
        end

        for _, child in ipairs(v464:GetChildren()) do
            if child:IsA("Tool") and child:GetAttribute("ReferenceName") ~= nil then
                v459 = child

                break
            end
        end
    until v459
    if not v459 then
        return
    end
    local BoundingBox, v468
    if Fences:IsA("Model") then
        BoundingBox, v468 = Fences:GetBoundingBox()
    else
        if not Fences:IsA("BasePart") then
            return
        end

        BoundingBox = Fences.CFrame
        v468 = Fences.Size
    end
    local v469 = BoundingBox:PointToWorldSpace(Vector3.new((math.random() - 0.5) * v468.X, v468.Y / 2, (math.random() - 0.5) * v468.Z))
    t2.value48("EggPlacementService", "RequestToPlace"):InvokeServer(v459:GetAttribute("ReferenceName"), CFrame.new(v469))
    task.wait(0.2)
end)

t1.value27({
	text = "🎃 Auto Place",
	callback = v121
})
local v122 = t1.value28("Hatch", function()
    local v453 = t2.value49()

    if not v453 then
        task.wait(1)

        return
    end

    for _, child in ipairs(v453.PlacedEggs:GetChildren()) do
        if child:GetAttribute("CanHatch") then
            t2.value48("EggHatchService", "Hatch"):InvokeServer(child.Name)
        end
    end

    task.wait(5)
end)

t1.value27({
	text = "🐣 Auto Hatch",
	callback = v122
})
local v123 = t1.value28("Equip", function()
    t2.value48("AnimalLoadoutService", "Request"):InvokeServer("EquipBest")
    task.wait(5)
end)

t1.value27({
	text = "🧙 Equip Best",
	callback = v123
})
local v124 = t1.value28("Upgrade", function()
    local v452 = t2.value49()

    if not v452 then
        task.wait(1)

        return
    end

    if v452.TreadmillUpgradeSign.Gui.PlotUpdateAttachment.UpdPlotNotification.Enabled == true then
        t2.value48("TreadmillService", "RequestToUpgrade"):InvokeServer()
    end

    if v452.BaseUpgradeSign.Gui.PlotUpdateAttachment.UpdPlotNotification.Enabled == true then
        t2.value48("BaseUpgradeService", "RequestToUpgrade"):InvokeServer()
    end

    task.wait(0.2)
end)

t1.value27({
	text = "🔮 Auto Upgrade",
	callback = v124
})
local v125 = t1.value28("Rebirth", function()
    if t2.value44.PlayerGui.Hud.LeftMain.Left.Row1.REBIRTHS.Detection.Alert.Visible == true then
        t2.value48("RebirthService", "Request"):InvokeServer(false)
    end

    task.wait(0.2)
end)

t1.value27({
	text = "💀 Auto Rebirth",
	callback = v125
})
local v126 = t1.value28("Train", function()
    for _, child in ipairs(t2.value44.PlayerGui.General:GetChildren()) do
        if not (#child.Name > 20) then
            continue
        end

        local ImageButton = child:FindFirstChild("ImageButton")

        if ImageButton then
            for _, v in ipairs(getconnections(ImageButton.Activated)) do
                v:Fire()
            end

            break
        end
    end

    task.wait(0.2)
end)

t1.value27({
	text = "⚡ x2 Train",
	callback = v126
})
t1.value26("🎃 LP10 HUB  •  Halloween Update")
t2.value31()
local function v127()
    t2.value15.Visible = true
    t2.value17.Scale = 0
    t2.value12(t2.value17, 0.4, {
		Scale = 1
	}, Enum.EasingStyle.Back):Play()
    v117(t2.value3.StartOpen)
end
if t2.value3.Intro then
    task.spawn(function(p51)
        local value8_44 = t2.value8
        local value14_6 = t2.value14
        local uDim2_47 = UDim2.new(1, 0, 1, 0)
        local black4 = t2.value5.black
        local v381 = value8_44("Frame", value14_6, {
			Name = "HalloweenIntro",
			Size = uDim2_47,
			BackgroundColor3 = black4,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Active = true,
			ZIndex = 100
		})

        t2.value8("UIGradient", v381, {
			Color = ColorSequence.new(Color3.fromRGB(46, 14, 52), Color3.fromRGB(4, 2, 6)),
			Rotation = 90
		})
        t2.value12(v381, 0.5, {
			BackgroundTransparency = 0.04
		}):Play()

        local u382 = false

        t2.value8("TextButton", v381, {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			Text = "",
			ZIndex = 101
		}).MouseButton1Click:Connect(function()
            u382 = true
        end)
        task.spawn(function()
            while true do
                local v517 = v381

                if v517 then
                    v517 = v381.Parent and not u382
                end

                if not v517 then
                    break
                end

                local v518 = t2.value32:NextNumber(0.08, 0.85)
                local value8_45 = t2.value8
                local v520 = v381
                local uDim2_48 = UDim2.fromOffset(30, 30)
                local vector2 = Vector2.new(0.5, 0.5)
                local uDim2_49 = UDim2.new(-0.05, 0, v518, 0)
                local v524 = t2.value32:NextInteger(20, 34)
                local v525 = value8_45("TextLabel", v520, {
					Size = uDim2_48,
					AnchorPoint = vector2,
					Position = uDim2_49,
					BackgroundTransparency = 1,
					Text = "🦇",
					TextSize = v524,
					ZIndex = 102
				})
                local value12 = t2.value12
                local v527 = t2.value32:NextNumber(1.6, 2.6)
                local uDim2_50 = UDim2.new(1.05, 0, v518 + t2.value32:NextNumber(-0.15, 0.15), 0)
                local v529 = t2.value32:NextInteger(-25, 25)

                value12(v525, v527, {
					Position = uDim2_50,
					Rotation = v529
				}, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut):Play()
                task.delay(3, function()
                    if v525 then
                        v525:Destroy()
                    end
                end)
                task.wait(0.25)
            end
        end)

        local value8_46 = t2.value8
        local uDim2_51 = UDim2.fromOffset(130, 130)
        local vector2 = Vector2.new(0.5, 0.5)
        local uDim2_52 = UDim2.new(0.5, 0, 0.38, 0)
        local v387 = value8_46("TextLabel", v381, {
			Size = uDim2_51,
			AnchorPoint = vector2,
			Position = uDim2_52,
			BackgroundTransparency = 1,
			Text = "🎃",
			TextSize = 96,
			ZIndex = 103
		})
        local v388 = t2.value8("UIScale", v387, {
			Scale = 0
		})
        local value12 = t2.value12
        local _Enum = Enum

        value12(v388, 0.7, {
			Scale = 1
		}, _Enum.EasingStyle.Back):Play()
        task.spawn(function()
            while true do
                local v530 = v387

                if v530 then
                    v530 = v387.Parent
                end

                if not v530 then
                    break
                end

                local value12_3 = t2.value12
                local v532 = v387
                local _Enum2 = Enum

                value12_3(v532, 0.6, {
					Rotation = 8
				}, _Enum2.EasingStyle.Sine, Enum.EasingDirection.InOut):Play()
                task.wait(0.6)

                local v534 = v387

                if v534 then
                    v534 = v387.Parent
                end

                if not v534 then
                    return
                end

                t2.value12(v387, 0.6, {
					Rotation = -8
				}, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut):Play()
                task.wait(0.6)
            end
        end)

        local value8_47 = t2.value8
        local uDim2_53 = UDim2.new(1, 0, 0, 56)
        local vector2_2 = Vector2.new(0.5, 0.5)
        local uDim2_54 = UDim2.new(0.5, 0, 0.58, 0)
        local orange7 = t2.value5.orange
        local Creepster = Enum.Font.Creepster
        local v397 = value8_47("TextLabel", v381, {
			Size = uDim2_53,
			AnchorPoint = vector2_2,
			Position = uDim2_54,
			BackgroundTransparency = 1,
			Text = "",
			TextColor3 = orange7,
			Font = Creepster,
			TextSize = 52,
			ZIndex = 103
		})

        t2.value8("UIStroke", v397, {
			Color = t2.value5.black,
			Thickness = 2.5
		})

        local value8_48 = t2.value8
        local uDim2_55 = UDim2.new(1, 0, 0, 22)
        local vector2_3 = Vector2.new(0.5, 0.5)
        local uDim2_56 = UDim2.new(0.5, 0, 0.66, 0)
        local witch = t2.value5.witch
        local GothamBlack4 = Enum.Font.GothamBlack
        local v404 = value8_48("TextLabel", v381, {
			Size = uDim2_55,
			AnchorPoint = vector2_3,
			Position = uDim2_56,
			BackgroundTransparency = 1,
			Text = "🎃  HALLOWEEN UPDATE  🎃",
			TextColor3 = witch,
			TextTransparency = 1,
			Font = GothamBlack4,
			TextSize = 15,
			ZIndex = 103
		})
        local value8_49 = t2.value8
        local uDim2_57 = UDim2.new(1, 0, 0, 16)
        local vector2_4 = Vector2.new(0.5, 0.5)
        local uDim2_58 = UDim2.new(0.5, 0, 0.74, 0)
        local muted = t2.value5.muted
        local GothamSemibold3 = Enum.Font.GothamSemibold
        local v411 = value8_49("TextLabel", v381, {
			Size = uDim2_57,
			AnchorPoint = vector2_4,
			Position = uDim2_58,
			BackgroundTransparency = 1,
			Text = "",
			TextColor3 = muted,
			Font = GothamSemibold3,
			TextSize = 11,
			ZIndex = 103
		})
        local value8_50 = t2.value8
        local uDim2_59 = UDim2.fromOffset(220, 8)
        local vector2_5 = Vector2.new(0.5, 0.5)
        local uDim2_60 = UDim2.new(0.5, 0, 0.8, 0)
        local color3_9 = Color3.fromRGB(30, 16, 30)
        local v417 = value8_50("Frame", v381, {
			Size = uDim2_59,
			AnchorPoint = vector2_5,
			Position = uDim2_60,
			BackgroundColor3 = color3_9,
			BorderSizePixel = 0,
			ZIndex = 103
		})

        t2.value9(v417, 4)
        t2.value10(v417, t2.value5.orange, 1, 0.3)

        local value8_51 = t2.value8
        local uDim2_61 = UDim2.new(0, 0, 1, 0)
        local orange8 = t2.value5.orange
        local v421 = value8_51("Frame", v417, {
			Size = uDim2_61,
			BackgroundColor3 = orange8,
			BorderSizePixel = 0,
			ZIndex = 104
		})

        t2.value9(v421, 4)
        t2.value11(v421, t2.value5.orange, t2.value5.slime, 0)

        local v422 = string.upper(t2.value3.HubName)

        for i = 1, #v422 do
            if u382 then
                break
            end

            v397.Text = string.sub(v422, 1, i)
            task.wait(0.07)
        end

        v397.Text = v422
        t2.value12(v404, 0.4, {
			TextTransparency = 0
		}):Play()

        if t2.value3.Lightning then
            t2.value12(v381, 0.05, {
				BackgroundColor3 = t2.value5.purple
			}):Play()
            task.delay(0.1, function()
                t2.value12(v381, 0.3, {
					BackgroundColor3 = t2.value5.black
				}):Play()
            end)
        end

        t2.value12(v421, 2.4, {
			Size = UDim2.new(1, 0, 1, 0)
		}, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut):Play()

        for _, v in ipairs({
			"Summoning spirits...",
			"Carving pumpkins...",
			"Waking the bats...",
			"Brewing potions...",
			"Happy Halloween! 🎃"
		}) do
            if u382 then
                break
            end

            v411.Text = v
            task.wait(0.5)
        end

        v119(v381, 0.5)
        task.wait(0.55)
        v381:Destroy()

        if p51 then
            p51()
        end
    end, v127)
else
    v127()
end
print("🎃 LP10 HUB Halloween Edition loaded.")
