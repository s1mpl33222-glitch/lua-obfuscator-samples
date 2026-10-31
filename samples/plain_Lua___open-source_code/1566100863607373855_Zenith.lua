-- ═══════════════════════════════════════════
--  ✦ ZENITH PREMIUM | v130 ✦
--  🖤 FULL OPAQUE super-cool loading screen
-- ═══════════════════════════════════════════

print("[Zenith Premium] Booting...")

if not game:IsLoaded() then game.Loaded:Wait() end
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local VIM = game:GetService("VirtualInputManager")
local RS = game:GetService("ReplicatedStorage")
local lp = Players.LocalPlayer

for _,v in ipairs(((gethui and gethui()) or game:GetService("CoreGui")):GetDescendants()) do
    if v.Name == "ZenithPremium" then v:Destroy() end
end

local parent = (gethui and gethui()) or game:GetService("CoreGui")
local gui = Instance.new("ScreenGui")
gui.Name = "ZenithPremium"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 999
gui.Parent = parent

-- ═══════════════════════════════════════════
--   🖤 SUPER COOL FULL-OPAQUE LOADING SCREEN
-- ═══════════════════════════════════════════

local overlay = Instance.new("Frame", gui)
overlay.Size = UDim2.new(1, 0, 1, 0)
overlay.BackgroundColor3 = Color3.fromRGB(2, 0, 8)
overlay.BackgroundTransparency = 0
overlay.BorderSizePixel = 0
overlay.ZIndex = 20
overlay.Active = true

local nebula = Instance.new("UIGradient", overlay)
nebula.Rotation = 45
nebula.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(15, 3, 40)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(4, 2, 12)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 5, 50))
}

task.spawn(function()
    while overlay.Parent do
        TweenService:Create(nebula, TweenInfo.new(4, Enum.EasingStyle.Sine), {Rotation = 180}):Play()
        task.wait(4)
        TweenService:Create(nebula, TweenInfo.new(4, Enum.EasingStyle.Sine), {Rotation = 45}):Play()
        task.wait(4)
    end
end)

for i = 1, 40 do
    local p = Instance.new("TextLabel", overlay)
    p.Size = UDim2.new(0, math.random(8, 20), 0, math.random(8, 20))
    p.Position = UDim2.new(math.random(), 0, math.random() + 0.2, 0)
    p.BackgroundTransparency = 1
    p.Text = (math.random(1, 2) == 1) and "✦" or "✧"
    p.TextColor3 = Color3.fromRGB(
        math.random(120, 255),
        math.random(80, 220),
        math.random(180, 255)
    )
    p.Font = Enum.Font.GothamBlack
    p.TextSize = math.random(8, 20)
    p.TextTransparency = math.random(2, 6) / 10
    p.ZIndex = 22

    task.spawn(function()
        while overlay.Parent do
            local startX = math.random(0, 100) / 100
            local startY = math.random(100, 130) / 100
            local endX = startX + (math.random(-30, 30) / 100)
            local endY = -0.2
            p.Position = UDim2.new(startX, 0, startY, 0)
            p.Rotation = 0
            TweenService:Create(p, TweenInfo.new(math.random(4, 8), Enum.EasingStyle.Linear), {
                Position = UDim2.new(endX, 0, endY, 0),
                Rotation = math.random(180, 720),
                TextTransparency = 1
            }):Play()
            task.wait(math.random(4, 8))
            p.TextTransparency = math.random(2, 6) / 10
            p.Rotation = 0
        end
    end)
end

for i = 1, 3 do
    local ring = Instance.new("Frame", overlay)
    local sz = 300 + (i * 150)
    ring.Size = UDim2.new(0, sz, 0, sz)
    ring.Position = UDim2.new(0.5, -sz/2, 0.5, -sz/2)
    ring.BackgroundTransparency = 1
    ring.ZIndex = 19
    local ringStroke = Instance.new("UIStroke", ring)
    ringStroke.Color = Color3.fromRGB(140, 80, 255)
    ringStroke.Thickness = 2
    ringStroke.Transparency = 0.7
    Instance.new("UICorner", ring).CornerRadius = UDim.new(1, 0)

    task.spawn(function()
        while overlay.Parent do
            TweenService:Create(ring, TweenInfo.new(3 + i, Enum.EasingStyle.Sine), {
                Size = UDim2.new(0, sz * 1.3, 0, sz * 1.3),
                Position = UDim2.new(0.5, -sz * 0.65, 0.5, -sz * 0.65)
            }):Play()
            TweenService:Create(ringStroke, TweenInfo.new(3 + i, Enum.EasingStyle.Sine), {
                Transparency = 1
            }):Play()
            task.wait(3 + i)
            ring.Size = UDim2.new(0, sz, 0, sz)
            ring.Position = UDim2.new(0.5, -sz/2, 0.5, -sz/2)
            ringStroke.Transparency = 0.7
            task.wait(0.1)
        end
    end)
end

local loader = Instance.new("Frame", overlay)
loader.Size = UDim2.new(0, 400, 0, 280)
loader.Position = UDim2.new(0.5, -200, 0.5, -140)
loader.BackgroundColor3 = Color3.fromRGB(10, 4, 22)
loader.BackgroundTransparency = 0
loader.BorderSizePixel = 0
loader.ZIndex = 25
Instance.new("UICorner", loader).CornerRadius = UDim.new(0, 28)

local boxGrad = Instance.new("UIGradient", loader)
boxGrad.Rotation = 45
boxGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 35, 140)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(15, 8, 30)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(80, 35, 140))
}

local lStroke = Instance.new("UIStroke", loader)
lStroke.Color = Color3.fromRGB(180, 100, 255)
lStroke.Thickness = 3.5
lStroke.Transparency = 0

task.spawn(function()
    while loader.Parent do
        TweenService:Create(lStroke, TweenInfo.new(1.4, Enum.EasingStyle.Sine), {Color = Color3.fromRGB(80, 220, 255), Thickness = 5}):Play()
        task.wait(1.4)
        TweenService:Create(lStroke, TweenInfo.new(1.4, Enum.EasingStyle.Sine), {Color = Color3.fromRGB(220, 80, 255), Thickness = 3.5}):Play()
        task.wait(1.4)
    end
end)

local auroraRing = Instance.new("Frame", loader)
auroraRing.Size = UDim2.new(0, 110, 0, 110)
auroraRing.Position = UDim2.new(0.5, -55, 0, 20)
auroraRing.BackgroundTransparency = 1
auroraRing.ZIndex = 26
local auroraStroke = Instance.new("UIStroke", auroraRing)
auroraStroke.Color = Color3.fromRGB(180, 120, 255)
auroraStroke.Thickness = 3
auroraStroke.Transparency = 0.3
Instance.new("UICorner", auroraRing).CornerRadius = UDim.new(1, 0)

task.spawn(function()
    while loader.Parent do
        TweenService:Create(auroraStroke, TweenInfo.new(0.9, Enum.EasingStyle.Sine), {Transparency = 0.9, Thickness = 8}):Play()
        TweenService:Create(auroraRing, TweenInfo.new(0.9, Enum.EasingStyle.Sine), {Size = UDim2.new(0, 140, 0, 140), Position = UDim2.new(0.5, -70, 0, 5)}):Play()
        task.wait(0.9)
        TweenService:Create(auroraStroke, TweenInfo.new(0.9, Enum.EasingStyle.Sine), {Transparency = 0.3, Thickness = 3}):Play()
        TweenService:Create(auroraRing, TweenInfo.new(0.9, Enum.EasingStyle.Sine), {Size = UDim2.new(0, 110, 0, 110), Position = UDim2.new(0.5, -55, 0, 20)}):Play()
        task.wait(0.9)
    end
end)

local star = Instance.new("TextLabel", loader)
star.Size = UDim2.new(0, 90, 0, 90)
star.Position = UDim2.new(0.5, -45, 0, 30)
star.BackgroundTransparency = 1
star.Text = "✦"
star.TextColor3 = Color3.fromRGB(220, 160, 255)
star.Font = Enum.Font.GothamBlack
star.TextSize = 72
star.ZIndex = 27
star.TextStrokeTransparency = 0.3
star.TextStrokeColor3 = Color3.fromRGB(140, 70, 255)

task.spawn(function()
    while loader.Parent do
        star.Rotation = 0
        TweenService:Create(star, TweenInfo.new(3, Enum.EasingStyle.Linear), {Rotation = 360}):Play()
        task.wait(3)
    end
end)

local function makeOrbit(radius, duration, text, color, size)
    local orb = Instance.new("TextLabel", loader)
    orb.Size = UDim2.new(0, size, 0, size)
    orb.BackgroundTransparency = 1
    orb.Text = text
    orb.TextColor3 = color
    orb.Font = Enum.Font.GothamBlack
    orb.TextSize = size
    orb.ZIndex = 27
    orb.TextStrokeTransparency = 0.5
    orb.TextStrokeColor3 = Color3.new(0,0,0)
    local angle = 0
    task.spawn(function()
        while loader.Parent do
            angle = angle + (360 / (duration / 0.05))
            if angle >= 360 then angle = angle - 360 end
            local rad = math.rad(angle)
            local x = math.cos(rad) * radius
            local y = math.sin(rad) * radius
            orb.Position = UDim2.new(0.5, -size/2 + x, 0, 75 - size/2 + y)
            task.wait(0.05)
        end
    end)
end
makeOrbit(85, 4, "✦", Color3.fromRGB(120, 200, 255), 20)
makeOrbit(85, 5, "✧", Color3.fromRGB(255, 150, 220), 18)
makeOrbit(85, 6, "✦", Color3.fromRGB(180, 255, 180), 16)
makeOrbit(85, 7, "✧", Color3.fromRGB(255, 220, 150), 14)

local lTitle = Instance.new("TextLabel", loader)
lTitle.Size = UDim2.new(1, -20, 0, 42)
lTitle.Position = UDim2.new(0, 10, 0, 145)
lTitle.BackgroundTransparency = 1
lTitle.Text = "Z E N I T H   P R E M I U M"
lTitle.TextColor3 = Color3.fromRGB(255, 245, 255)
lTitle.Font = Enum.Font.GothamBlack
lTitle.TextSize = 28
lTitle.TextStrokeTransparency = 0.2
lTitle.TextStrokeColor3 = Color3.fromRGB(180, 90, 255)
lTitle.ZIndex = 27

task.spawn(function()
    while loader.Parent do
        TweenService:Create(lTitle, TweenInfo.new(1.2, Enum.EasingStyle.Sine), {TextStrokeTransparency = 0.0}):Play()
        task.wait(1.2)
        TweenService:Create(lTitle, TweenInfo.new(1.2, Enum.EasingStyle.Sine), {TextStrokeTransparency = 0.6}):Play()
        task.wait(1.2)
    end
end)

local lSub = Instance.new("TextLabel", loader)
lSub.Size = UDim2.new(1, -20, 0, 22)
lSub.Position = UDim2.new(0, 10, 0, 188)
lSub.BackgroundTransparency = 1
lSub.Text = "Initializing..."
lSub.TextColor3 = Color3.fromRGB(210, 190, 240)
lSub.Font = Enum.Font.GothamMedium
lSub.TextSize = 13
lSub.ZIndex = 27

local barBG = Instance.new("Frame", loader)
barBG.Size = UDim2.new(1, -70, 0, 16)
barBG.Position = UDim2.new(0, 35, 0, 220)
barBG.BackgroundColor3 = Color3.fromRGB(22, 15, 40)
barBG.BorderSizePixel = 0
barBG.ZIndex = 26
Instance.new("UICorner", barBG).CornerRadius = UDim.new(1, 0)

local barStroke = Instance.new("UIStroke", barBG)
barStroke.Color = Color3.fromRGB(120, 60, 180)
barStroke.Thickness = 1.5
barStroke.Transparency = 0.4

local barFill = Instance.new("Frame", barBG)
barFill.Size = UDim2.new(0, 0, 1, 0)
barFill.BackgroundColor3 = Color3.fromRGB(140, 70, 255)
barFill.BorderSizePixel = 0
barFill.ZIndex = 27
Instance.new("UICorner", barFill).CornerRadius = UDim.new(1, 0)
local barGrad = Instance.new("UIGradient", barFill)
barGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 100, 200)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(140, 70, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(80, 200, 255))
}

local shimmer = Instance.new("Frame", barBG)
shimmer.Size = UDim2.new(0, 60, 1, 0)
shimmer.Position = UDim2.new(-0.2, 0, 0, 0)
shimmer.BackgroundColor3 = Color3.new(1,1,1)
shimmer.BackgroundTransparency = 0.6
shimmer.BorderSizePixel = 0
shimmer.ZIndex = 28
Instance.new("UICorner", shimmer).CornerRadius = UDim.new(1, 0)
task.spawn(function()
    while loader.Parent do
        shimmer.Position = UDim2.new(-0.2, 0, 0, 0)
        TweenService:Create(shimmer, TweenInfo.new(1.4, Enum.EasingStyle.Linear), {Position = UDim2.new(1.05, 0, 0, 0)}):Play()
        task.wait(1.4)
    end
end)

local pct = Instance.new("TextLabel", loader)
pct.Size = UDim2.new(1, -20, 0, 22)
pct.Position = UDim2.new(0, 10, 0, 245)
pct.BackgroundTransparency = 1
pct.Text = "0%"
pct.TextColor3 = Color3.fromRGB(230, 190, 255)
pct.Font = Enum.Font.GothamBold
pct.TextSize = 15
pct.ZIndex = 27
pct.TextStrokeTransparency = 0.3
pct.TextStrokeColor3 = Color3.fromRGB(120, 60, 220)

task.spawn(function()
    while loader.Parent do
        TweenService:Create(pct, TweenInfo.new(0.6, Enum.EasingStyle.Sine), {TextSize = 17}):Play()
        task.wait(0.6)
        TweenService:Create(pct, TweenInfo.new(0.6, Enum.EasingStyle.Sine), {TextSize = 15}):Play()
        task.wait(0.6)
    end
end)

local loadMessages = {
    "Initializing elite systems...",
    "Locating your ranch...",
    "Establishing secure channels...",
    "Scanning for high-value eggs...",
    "Deploying ESP overlay...",
    "Calibrating teleport engine...",
    "Almost ready...",
    "Zenith online!"
}

local function setProgress(p)
    p = math.clamp(p, 0, 100)
    TweenService:Create(barFill, TweenInfo.new(0.4, Enum.EasingStyle.Quad), {Size = UDim2.new(p / 100, 0, 1, 0)}):Play()
    pct.Text = math.floor(p).."%"
    local idx = math.clamp(math.floor(p / (100 / #loadMessages)) + 1, 1, #loadMessages)
    lSub.Text = loadMessages[idx]
end

setProgress(5)

-- MAIN PANEL
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 280, 0, 0)
main.Position = UDim2.new(0, 20, 0.06, 0)
main.BackgroundColor3 = Color3.fromRGB(14, 10, 24)
main.BackgroundTransparency = 0.05
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.ClipsDescendants = true
main.Visible = false
main.ZIndex = 5
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 18)

local mainGrad = Instance.new("UIGradient", main)
mainGrad.Rotation = 135
mainGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 22, 70)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(14, 10, 24)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 22, 70))
}

local stroke = Instance.new("UIStroke", main)
stroke.Color = Color3.fromRGB(160, 80, 255)
stroke.Thickness = 2
stroke.Transparency = 0.1

task.spawn(function()
    while gui.Parent do
        TweenService:Create(stroke, TweenInfo.new(2, Enum.EasingStyle.Sine), {Color = Color3.fromRGB(80, 220, 255), Transparency = 0.0}):Play()
        task.wait(2)
        TweenService:Create(stroke, TweenInfo.new(2, Enum.EasingStyle.Sine), {Color = Color3.fromRGB(220, 80, 255), Transparency = 0.2}):Play()
        task.wait(2)
    end
end)

local header = Instance.new("Frame", main)
header.Size = UDim2.new(1, 0, 0, 52)
header.BackgroundTransparency = 1
header.BorderSizePixel = 0
header.ZIndex = 6

local title = Instance.new("TextLabel", header)
title.Size = UDim2.new(1, -20, 1, 0)
title.Position = UDim2.new(0, 12, 0, 0)
title.BackgroundTransparency = 1
title.Text = "✦  ZENITH PREMIUM  ✦"
title.TextColor3 = Color3.fromRGB(255, 235, 255)
title.Font = Enum.Font.GothamBlack
title.TextSize = 17
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextStrokeTransparency = 0.2
title.TextStrokeColor3 = Color3.fromRGB(200, 100, 255)
title.ZIndex = 7

task.spawn(function()
    while gui.Parent do
        TweenService:Create(title, TweenInfo.new(1.5, Enum.EasingStyle.Sine), {TextStrokeTransparency = 0.0}):Play()
        task.wait(1.5)
        TweenService:Create(title, TweenInfo.new(1.5, Enum.EasingStyle.Sine), {TextStrokeTransparency = 0.5}):Play()
        task.wait(1.5)
    end
end)

local accentLine = Instance.new("Frame", header)
accentLine.Size = UDim2.new(1, -24, 0, 2)
accentLine.Position = UDim2.new(0, 12, 1, -4)
accentLine.BackgroundColor3 = Color3.fromRGB(180, 100, 255)
accentLine.BorderSizePixel = 0
accentLine.ZIndex = 7
Instance.new("UICorner", accentLine).CornerRadius = UDim.new(1, 0)

local accentGrad = Instance.new("UIGradient", accentLine)
accentGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 100, 200)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(140, 70, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(80, 200, 255))
}

task.spawn(function()
    while gui.Parent do
        TweenService:Create(accentLine, TweenInfo.new(2, Enum.EasingStyle.Sine), {BackgroundTransparency = 0.5}):Play()
        task.wait(2)
        TweenService:Create(accentLine, TweenInfo.new(2, Enum.EasingStyle.Sine), {BackgroundTransparency = 0}):Play()
        task.wait(2)
    end
end)

local statusFrame = Instance.new("Frame", main)
statusFrame.Size = UDim2.new(1, -20, 0, 42)
statusFrame.Position = UDim2.new(0, 10, 0, 58)
statusFrame.BackgroundColor3 = Color3.fromRGB(22, 16, 40)
statusFrame.BackgroundTransparency = 0.15
statusFrame.BorderSizePixel = 0
statusFrame.ZIndex = 6
Instance.new("UICorner", statusFrame).CornerRadius = UDim.new(0, 10)

local statusDot = Instance.new("Frame", statusFrame)
statusDot.Size = UDim2.new(0, 8, 0, 8)
statusDot.Position = UDim2.new(0, 14, 0.5, -4)
statusDot.BackgroundColor3 = Color3.fromRGB(80, 255, 120)
statusDot.BorderSizePixel = 0
statusDot.ZIndex = 7
Instance.new("UICorner", statusDot).CornerRadius = UDim.new(1, 0)

task.spawn(function()
    while gui.Parent do
        TweenService:Create(statusDot, TweenInfo.new(0.8, Enum.EasingStyle.Sine), {BackgroundTransparency = 0.7, Size = UDim2.new(0, 14, 0, 14), Position = UDim2.new(0, 11, 0.5, -7)}):Play()
        task.wait(0.8)
        TweenService:Create(statusDot, TweenInfo.new(0.8, Enum.EasingStyle.Sine), {BackgroundTransparency = 0, Size = UDim2.new(0, 8, 0, 8), Position = UDim2.new(0, 14, 0.5, -4)}):Play()
        task.wait(0.8)
    end
end)

local status = Instance.new("TextLabel", statusFrame)
status.Size = UDim2.new(1, -30, 1, 0)
status.Position = UDim2.new(0, 30, 0, 0)
status.BackgroundTransparency = 1
status.Text = "Ready"
status.TextColor3 = Color3.fromRGB(230, 220, 250)
status.Font = Enum.Font.GothamMedium
status.TextSize = 11
status.TextXAlignment = Enum.TextXAlignment.Left
status.TextWrapped = true
status.ZIndex = 7

local eggList = Instance.new("TextLabel", main)
eggList.Size = UDim2.new(1, -20, 0, 60)
eggList.Position = UDim2.new(0, 10, 0, 108)
eggList.BackgroundColor3 = Color3.fromRGB(22, 16, 40)
eggList.BackgroundTransparency = 0.15
eggList.Text = "○ no eggs"
eggList.TextColor3 = Color3.fromRGB(150, 220, 255)
eggList.Font = Enum.Font.Code
eggList.TextSize = 11
eggList.TextXAlignment = Enum.TextXAlignment.Left
eggList.TextYAlignment = Enum.TextYAlignment.Top
eggList.TextWrapped = true
eggList.ZIndex = 6
Instance.new("UICorner", eggList).CornerRadius = UDim.new(0, 10)

local function addRipple(button)
    button.MouseButton1Down:Connect(function()
        local ripple = Instance.new("Frame", button)
        ripple.Size = UDim2.new(0, 0, 0, 0)
        ripple.Position = UDim2.new(0.5, 0, 0.5, 0)
        ripple.AnchorPoint = Vector2.new(0.5, 0.5)
        ripple.BackgroundColor3 = Color3.new(1,1,1)
        ripple.BackgroundTransparency = 0.5
        ripple.BorderSizePixel = 0
        ripple.ZIndex = 10
        Instance.new("UICorner", ripple).CornerRadius = UDim.new(1, 0)
        TweenService:Create(ripple, TweenInfo.new(0.6, Enum.EasingStyle.Quad), {
            Size = UDim2.new(0, 250, 0, 250),
            BackgroundTransparency = 1
        }):Play()
        task.wait(0.6)
        ripple:Destroy()
    end)
end

local function makeBtn(text, y, bg, sc)
    local b = Instance.new("TextButton", main)
    b.Size = UDim2.new(1, -20, 0, 46)
    b.Position = UDim2.new(0, 10, 0, y)
    b.BackgroundColor3 = bg
    b.Text = ""
    b.AutoButtonColor = false
    b.ClipsDescendants = true
    b.ZIndex = 6
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 12)

    local bGrad = Instance.new("UIGradient", b)
    bGrad.Rotation = 45
    bGrad.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, bg),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(
            math.min(bg.R * 255 + 50, 255),
            math.min(bg.G * 255 + 50, 255),
            math.min(bg.B * 255 + 50, 255)
        ))
    }

    local s = Instance.new("UIStroke", b)
    s.Color = sc
    s.Thickness = 1.5
    s.Transparency = 0.3

    local lbl = Instance.new("TextLabel", b)
    lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Color3.new(1,1,1)
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 13
    lbl.TextStrokeTransparency = 0.5
    lbl.TextStrokeColor3 = Color3.new(0,0,0)
    lbl.ZIndex = 7

    b.MouseEnter:Connect(function()
        TweenService:Create(s, TweenInfo.new(0.2), {Thickness = 3, Transparency = 0}):Play()
        TweenService:Create(b, TweenInfo.new(0.15), {Size = UDim2.new(1, -16, 0, 48), Position = UDim2.new(0, 8, 0, y - 1)}):Play()
    end)
    b.MouseLeave:Connect(function()
        TweenService:Create(s, TweenInfo.new(0.2), {Thickness = 1.5, Transparency = 0.3}):Play()
        TweenService:Create(b, TweenInfo.new(0.15), {Size = UDim2.new(1, -20, 0, 46), Position = UDim2.new(0, 10, 0, y)}):Play()
    end)

    addRipple(b)
    return b, lbl, s
end

local espFolder = Instance.new("Folder", gui)
espFolder.Name = "ZenithESP"
local espEggFolder = Instance.new("Folder", espFolder); espEggFolder.Name = "Eggs"
local espEggOn = true

local btn, btnLbl, btnStroke               = makeBtn("⚡  STEAL 1B+", 176, Color3.fromRGB(60, 25, 120), Color3.fromRGB(160, 80, 255))
local hatchBtn, hatchLbl, hatchStroke     = makeBtn("🥚  AUTO HATCH", 228, Color3.fromRGB(25, 70, 100), Color3.fromRGB(80, 220, 240))
local buyBtn, buyLbl, buyStroke           = makeBtn("💰  AUTO BUY HATCH LUCK", 280, Color3.fromRGB(90, 65, 15), Color3.fromRGB(255, 210, 70))
local espEggBtn, espLbl, espStroke        = makeBtn("👁  EGG ESP: ON", 332, Color3.fromRGB(25, 130, 50), Color3.fromRGB(100, 255, 140))
local volcanoBtn, volLbl, volStroke       = makeBtn("🌋  AUTO VOLCANIC EGG", 384, Color3.fromRGB(100, 30, 20), Color3.fromRGB(255, 140, 70))

setProgress(20)
local dropRemote, basketRemote, eggPlacedRemote
pcall(function()
    local rem = RS:FindFirstChild("Remotes")
    if rem then
        local g = rem:FindFirstChild("Game")
        if g then
            dropRemote = g:FindFirstChild("FusionPetPlace")
            basketRemote = g:FindFirstChild("BasketDrop")
            eggPlacedRemote = g:FindFirstChild("EggPlaced")
        end
    end
end)
setProgress(35)

task.spawn(function()
    while gui.Parent do
        local char = lp.Character
        if char then
            for _,p in ipairs(char:GetDescendants()) do
                if p:IsA("BasePart") and p.CanCollide then
                    pcall(function() p.CanCollide = false end)
                end
            end
        end
        task.wait(1)
    end
end)

-- RANCH AUTO-FIND (locks YOUR plot)
local ranchCF, plotModel = nil, nil
local homeCF = nil
local ranchLockedOnce = false

task.spawn(function()
    if not lp.Character then lp.CharacterAdded:Wait() end
    task.wait(2)
    local hrp = lp.Character:FindFirstChild("HumanoidRootPart")
    if hrp then homeCF = hrp.CFrame end
end)

local function isMyPlot(plot)
    for _, attr in ipairs({"Owner", "UserId", "Player", "Username", "owner", "userid", "player"}) do
        local ok, val = pcall(function() return plot:GetAttribute(attr) end)
        if ok and val ~= nil then
            if val == lp.UserId or val == lp.Name or tostring(val) == tostring(lp.UserId) then
                return true
            end
        end
    end
    for _, v in ipairs(plot:GetDescendants()) do
        if v:IsA("ObjectValue") and v.Value == lp then return true end
        if v:IsA("IntValue") and v.Value == lp.UserId then
            local n = v.Name:lower()
            if n:find("owner") or n:find("user") or n:find("player") then return true end
        end
        if v:IsA("StringValue") then
            local n = v.Name:lower()
            if n:find("owner") or n:find("user") or n:find("player") then
                if v.Value == lp.Name or v.Value == tostring(lp.UserId) then return true end
            end
        end
        if v:IsA("TextLabel") and v.Text ~= "" then
            if v.Text:lower() == lp.Name:lower() or v.Text:find(lp.Name) then return true end
        end
    end
    return false
end

local function autoLockRanch()
    if ranchLockedOnce and ranchCF then return true end
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return false end
    for _, plot in ipairs(plots:GetChildren()) do
        if isMyPlot(plot) then
            local bp = plot:FindFirstChild("Baseplate") or plot:FindFirstChildWhichIsA("BasePart", true)
            if bp then
                ranchCF = bp.CFrame + Vector3.new(0, bp.Size.Y/2 + 4, 0)
                plotModel = plot
                ranchLockedOnce = true
                return true
            end
        end
    end
    local char = lp.Character
    if not char then return false end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    local myPos = (homeCF and homeCF.Position) or hrp.Position
    local closestPlot, closestBaseplate, closestDist = nil, nil, math.huge
    for _, plot in ipairs(plots:GetChildren()) do
        local bp = plot:FindFirstChild("Baseplate") or plot:FindFirstChildWhichIsA("BasePart", true)
        if bp then
            local d = (bp.Position - myPos).Magnitude
            if d < closestDist then
                closestDist = d; closestPlot = plot; closestBaseplate = bp
            end
        end
    end
    if closestBaseplate then
        ranchCF = closestBaseplate.CFrame + Vector3.new(0, closestBaseplate.Size.Y/2 + 4, 0)
        plotModel = closestPlot
        ranchLockedOnce = true
        return true
    end
    return false
end

setProgress(55)
task.spawn(function()
    if not lp.Character then lp.CharacterAdded:Wait() end
    for i = 1, 120 do
        if autoLockRanch() then
            status.Text = "Ranch locked ✓"
            break
        end
        task.wait(0.4)
    end
end)
setProgress(75)

local MIN_VALUE = 1_000_000_000

local function parseValue(t)
    if not t then return 0 end
    t = tostring(t):upper():gsub("%s",""):gsub(",","")
    local inMatch = t:match("1IN([%d%.]+)([KMBTQ]?A?)")
    if inMatch then
        local n = tonumber(inMatch) or 1
        local suf = inMatch:gsub("[%d%.]","")
        if suf == "A" or suf == "QA" or suf == "Q" then return n * 1e15 end
        if suf == "T" then return n * 1e12 end
        if suf == "B" then return n * 1e9 end
        if suf == "M" then return n * 1e6 end
        if suf == "K" then return n * 1e3 end
        return n
    end
    local num, suf = t:match("([%d%.]+)([KMBTQ]?A?)")
    if not num then return 0 end
    local n = tonumber(num) or 0
    if suf == "A" or suf == "QA" or suf == "Q" then return n * 1e15 end
    if suf == "K" then return n*1e3 end
    if suf == "M" then return n*1e6 end
    if suf == "B" then return n*1e9 end
    if suf == "T" then return n*1e12 end
    return n
end

local luckCache = {}
local function readEggLuck(egg)
    if not egg or not egg.Parent then return "?" end
    if luckCache[egg] then return luckCache[egg] end
    local luckLabel = egg:FindFirstChild("Luck")
    if luckLabel and luckLabel:IsA("TextLabel") and luckLabel.Text ~= "" then
        luckCache[egg] = luckLabel.Text; return luckLabel.Text
    end
    for _, c in ipairs(egg:GetDescendants()) do
        if c:IsA("TextLabel") and c.Name:lower() == "luck" and c.Text ~= "" then
            luckCache[egg] = c.Text; return c.Text
        end
    end
    return "?"
end

local function getPos(o)
    if o:IsA("BasePart") then return o.Position end
    if o:IsA("Model") and o.PrimaryPart then return o.PrimaryPart.Position end
    local p = o:FindFirstChildWhichIsA("BasePart", true)
    return p and p.Position
end

local playerChars = {}
task.spawn(function()
    while gui.Parent do
        playerChars = {}
        for _, p in ipairs(Players:GetPlayers()) do
            if p.Character then playerChars[p.Character] = true end
        end
        task.wait(5)
    end
end)

local function isPlayerOrNPC(obj)
    if playerChars[obj] then return true end
    if obj:IsA("Model") and obj:FindFirstChildOfClass("Humanoid") then return true end
    return false
end

local function collectEggs()
    local out, seen = {}, {}
    local function add(o)
        if o and not seen[o] and o.Parent then seen[o] = true; table.insert(out, o) end
    end
    local re = workspace:FindFirstChild("RenderedEggs")
    if re then for _,v in ipairs(re:GetChildren()) do add(v) end end
    local ef = workspace:FindFirstChild("Eggs")
    if ef then for _,v in ipairs(ef:GetChildren()) do add(v) end end
    local plots = workspace:FindFirstChild("Plots")
    if plots then
        for _, plot in ipairs(plots:GetChildren()) do
            for _, v in ipairs(plot:GetDescendants()) do
                if v:IsA("Model") and v.Name:lower():find("egg") then
                    if v:FindFirstChildWhichIsA("ProximityPrompt", true) then add(v) end
                end
            end
        end
    end
    return out
end

local function getCurrentEggs()
    local list = {}
    for _,v in ipairs(collectEggs()) do
        local p = v:FindFirstChildWhichIsA("ProximityPrompt", true)
        if p and p.Enabled and p.Parent then
            local luckText = readEggLuck(v)
            table.insert(list, {egg=v, prompt=p, name=v.Name, luckText=luckText, num=parseValue(luckText)})
        end
    end
    table.sort(list, function(a,b) return a.num > b.num end)
    return list
end

local espCache = {}
local function buildESP(part, color)
    local hl = Instance.new("Highlight")
    hl.Adornee = part
    hl.FillColor = color
    hl.FillTransparency = 0.75
    hl.OutlineTransparency = 0.4
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.Parent = espEggFolder
    local bb = Instance.new("BillboardGui")
    bb.Adornee = part
    bb.Size = UDim2.new(0, 140, 0, 36)
    bb.StudsOffset = Vector3.new(0, 3, 0)
    bb.AlwaysOnTop = true
    bb.LightInfluence = 0
    bb.MaxDistance = 100000
    bb.Parent = espEggFolder
    local nameL = Instance.new("TextLabel", bb)
    nameL.Size = UDim2.new(1, 0, 0.5, 0)
    nameL.BackgroundTransparency = 1
    nameL.TextColor3 = Color3.new(1,1,1)
    nameL.TextStrokeTransparency = 0.4
    nameL.Font = Enum.Font.GothamBold
    nameL.TextSize = 12
    local valL = Instance.new("TextLabel", bb)
    valL.Size = UDim2.new(1, 0, 0.5, 0)
    valL.Position = UDim2.new(0, 0, 0.5, 0)
    valL.BackgroundTransparency = 1
    valL.TextColor3 = Color3.fromRGB(140,255,140)
    valL.TextStrokeTransparency = 0.4
    valL.Font = Enum.Font.Code
    valL.TextSize = 11
    return {hl=hl, bb=bb, nameL=nameL, valL=valL, lastText=nil, lastColor=nil}
end

local function clearAllESP()
    for part, data in pairs(espCache) do
        if data.hl then data.hl:Destroy() end
        if data.bb then data.bb:Destroy() end
    end
    espCache = {}
end

task.spawn(function()
    while gui.Parent do
        if espEggOn then
            local liveParts = {}
            for _,egg in ipairs(collectEggs()) do
                local part = egg:IsA("BasePart") and egg or egg:FindFirstChildWhichIsA("BasePart", true)
                if part and part.Parent then
                    liveParts[part] = true
                    local luckText = readEggLuck(egg)
                    local val = parseValue(luckText)
                    local color = Color3.fromRGB(200,200,220)
                    if val >= 1e12 then color = Color3.fromRGB(255,60,60)
                    elseif val >= 1e9 then color = Color3.fromRGB(255,150,60)
                    elseif val >= 1e6 then color = Color3.fromRGB(255,220,60)
                    elseif val >= 1e3 then color = Color3.fromRGB(80,255,120) end
                    local c = espCache[part]
                    if not c then
                        c = buildESP(part, color)
                        c.nameL.Text = "🥚 "..egg.Name
                        c.valL.Text = "🍀 "..luckText
                        c.valL.TextColor3 = color
                        c.lastText = luckText; c.lastColor = color
                        espCache[part] = c
                    else
                        if c.lastText ~= luckText then c.valL.Text = "🍀 "..luckText; c.lastText = luckText end
                        if c.lastColor ~= color then c.hl.FillColor = color; c.valL.TextColor3 = color; c.lastColor = color end
                    end
                end
            end
            for part, data in pairs(espCache) do
                if not liveParts[part] or not part.Parent then
                    if data.hl then data.hl:Destroy() end
                    if data.bb then data.bb:Destroy() end
                    espCache[part] = nil
                end
            end
        end
        task.wait(4)
    end
end)

local eHeld = false
local function startE()
    if eHeld then return end
    eHeld = true
    pcall(function() VIM:SendKeyEvent(true, Enum.KeyCode.E, false, game) end)
    task.spawn(function()
        while eHeld do
            pcall(function() VIM:SendKeyEvent(true, Enum.KeyCode.E, false, game) end)
            task.wait(0.1)
        end
    end)
end
local function stopE()
    eHeld = false
    task.wait(0.04)
    pcall(function() VIM:SendKeyEvent(false, Enum.KeyCode.E, false, game) end)
end

local GLIDE_SPEED = 900

local function glideTo(hrp, targetPos, speed)
    speed = speed or GLIDE_SPEED
    if not hrp or not hrp.Parent then return false end
    pcall(function() hrp:SetNetworkOwner(lp) end)
    local bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bv.Velocity = Vector3.zero
    bv.Parent = hrp
    local bg = Instance.new("BodyGyro")
    bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bg.P = 5000
    bg.CFrame = hrp.CFrame
    bg.Parent = hrp
    local lastPos = hrp.Position
    local stuckTime = 0
    while hrp.Parent do
        local myPos = hrp.Position
        local dir = targetPos - myPos
        local dist = dir.Magnitude
        if dist < 6 then break end
        local curSpeed = speed
        if dist < 60 then curSpeed = math.max(speed * (dist / 60), 30) end
        bv.Velocity = dir.Unit * curSpeed
        bg.CFrame = CFrame.new(myPos, myPos + dir.Unit)
        if (myPos - lastPos).Magnitude < 1 then
            stuckTime = stuckTime + 0.06
            if stuckTime > 5 then hrp.CFrame = CFrame.new(targetPos); break end
        else
            stuckTime = 0; lastPos = myPos
        end
        task.wait(0.06)
    end
    bv.Velocity = Vector3.zero
    pcall(function()
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.Velocity = Vector3.zero
        hrp.RotVelocity = Vector3.zero
    end)
    bv:Destroy()
    bg:Destroy()
    task.wait(0.03)
    return true
end

local function teleportTo(hrp, targetPos)
    if not hrp or not hrp.Parent then return false end
    pcall(function() hrp:SetNetworkOwner(lp) end)
    pcall(function() hrp.CFrame = CFrame.new(targetPos + Vector3.new(0, 3, 0)) end)
    pcall(function()
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.Velocity = Vector3.zero
        hrp.RotVelocity = Vector3.zero
    end)
    task.wait(0.05)
    return true
end

local function isCarryingEgg(char)
    if not char then return false, "no char" end
    for _, ch in ipairs(char:GetChildren()) do
        if (ch:IsA("Model") or ch:IsA("Tool")) and ch.Name:lower():find("egg") then
            return true, ch.Name
        end
    end
    for _, tool in ipairs(char:GetChildren()) do
        if tool:IsA("Tool") and tool.Name:lower():find("pet") then
            for _, child in ipairs(tool:GetDescendants()) do
                if child.Name:lower():find("egg") then return true, child.Name end
            end
        end
    end
    for _, ch in ipairs(char:GetDescendants()) do
        if (ch:IsA("Model") or ch:IsA("Tool")) and ch.Name:lower():find("egg") then
            return true, ch.Name
        end
    end
    return false, "none"
end

local function dropEgg()
    local char = lp.Character
    if not char then return false end
    local holding = isCarryingEgg(char)
    if not holding then return false end
    pcall(function()
        if dropRemote then dropRemote:FireServer() end
        if basketRemote then basketRemote:FireServer() end
        if eggPlacedRemote then eggPlacedRemote:FireServer() end
    end)
    pcall(function() VIM:SendKeyEvent(true, Enum.KeyCode.Q, false, game) end)
    task.wait(0.05)
    pcall(function() VIM:SendKeyEvent(false, Enum.KeyCode.Q, false, game) end)
    task.wait(0.4)
    return true
end

local function tryPickup(target)
    if not target or not target.Parent then return false end
    local prompt = target:FindFirstChildWhichIsA("ProximityPrompt", true)
    if not prompt then
        for _, c in ipairs(target:GetDescendants()) do
            if c:IsA("ProximityPrompt") then prompt = c; break end
        end
    end
    if prompt then
        pcall(function()
            prompt.HoldDuration = 0
            prompt.MaxActivationDistance = math.huge
            prompt.RequiresLineOfSight = false
            prompt.Enabled = true
            prompt:InputHoldBegin()
            task.wait(0.03)
            prompt:InputHoldEnd()
        end)
        pcall(function() fireproximityprompt(prompt) end)
        pcall(function() fireproximityprompt(prompt) end)
    end
    startE()
    task.wait(0.3)
    stopE()
    task.wait(0.1)
    return (not target.Parent)
end

local function findNearestPrompt(hrp, maxDist)
    maxDist = maxDist or 80
    local best, bestDist = nil, maxDist
    local re = workspace:FindFirstChild("RenderedEggs")
    if not re then re = workspace:FindFirstChild("Eggs") end
    if not re then return nil end
    for _, v in ipairs(re:GetChildren()) do
        local p = nil
        for _, c in ipairs(v:GetChildren()) do
            if c:IsA("ProximityPrompt") then p = c; break end
        end
        if p and p.Enabled then
            local par = p.Parent
            if par and par:IsA("BasePart") then
                local d = (par.Position - hrp.Position).Magnitude
                if d < bestDist then bestDist = d; best = p end
            end
        end
    end
    return best
end

local FENCE_OFFSET = 20
local DROP_WAIT = 2

local function doFullFlow(egg, prompt)
    if not egg or not egg.Parent then return false end
    local char = lp.Character
    if not char then return false end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    local eggPos = getPos(egg)
    if not eggPos then return false end
    if not ranchCF then return false end

    status.Text = "⚡ To egg..."
    teleportTo(hrp, eggPos)

    local carrying = false
    for attempt = 1, 3 do
        if not egg.Parent then break end
        tryPickup(egg)
        task.wait(0.15)
        carrying = isCarryingEgg(char)
        if carrying then break end
        if egg.Parent then
            local p = getPos(egg)
            if p then teleportTo(hrp, p) end
        end
        task.wait(0.15)
    end
    if not carrying then status.Text = "Pickup failed"; return false end

    status.Text = "⚡ To fence..."
    local halfX, halfZ = 40, 40
    local bp = nil
    if plotModel then
        bp = plotModel:FindFirstChild("Baseplate") or plotModel:FindFirstChildWhichIsA("BasePart", true)
        if bp then halfX = bp.Size.X / 2; halfZ = bp.Size.Z / 2 end
    end
    local dropX = halfX + FENCE_OFFSET
    local dropZ = halfZ + FENCE_OFFSET
    local groundY
    if bp then groundY = bp.Position.Y + bp.Size.Y / 2 + 3 else groundY = ranchCF.Position.Y - 4 end

    local myPos = hrp.Position
    local dx = myPos.X - ranchCF.Position.X
    local dz = myPos.Z - ranchCF.Position.Z
    local targetX, targetZ
    if math.abs(dx) > math.abs(dz) then
        local sign = dx > 0 and 1 or -1
        targetX = ranchCF.Position.X + sign * dropX
        targetZ = ranchCF.Position.Z
    else
        local sign = dz > 0 and 1 or -1
        targetX = ranchCF.Position.X
        targetZ = ranchCF.Position.Z + sign * dropZ
    end

    pcall(function() hrp:SetNetworkOwner(lp) end)
    pcall(function() hrp.CFrame = CFrame.new(targetX, groundY, targetZ) end)
    pcall(function()
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.Velocity = Vector3.zero
        hrp.RotVelocity = Vector3.zero
    end)
    task.wait(0.4)

    local lockedCF = hrp.CFrame
    local lockActive = true
    local holdBV = Instance.new("BodyVelocity")
    holdBV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    holdBV.Velocity = Vector3.zero
    holdBV.Parent = hrp
    local holdBG = Instance.new("BodyGyro")
    holdBG.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    holdBG.P = 100000
    holdBG.CFrame = hrp.CFrame
    holdBG.Parent = hrp

    task.spawn(function()
        while lockActive and hrp.Parent do
            pcall(function()
                hrp.CFrame = lockedCF
                hrp.AssemblyLinearVelocity = Vector3.zero
                hrp.Velocity = Vector3.zero
                hrp.RotVelocity = Vector3.zero
            end)
            task.wait(0.02)
        end
    end)

    task.wait(0.4)
    status.Text = "⚡ Drop..."
    dropEgg()
    task.wait(0.6)

    lockActive = false
    task.wait(0.05)
    holdBV:Destroy()
    holdBG:Destroy()
    task.wait(0.1)

    status.Text = "⏳ Waiting 2s..."
    task.wait(DROP_WAIT)

    local carrying2 = false
    for attempt = 1, 3 do
        status.Text = "🕊️ Re-pickup "..attempt.."/3..."
        local rePrompt = findNearestPrompt(hrp, 80)
        if rePrompt then
            local part = rePrompt.Parent
            if part and part:IsA("BasePart") then
                glideTo(hrp, part.Position + Vector3.new(0, 3, 0), GLIDE_SPEED)
            end
            for j = 1, 3 do
                pcall(function()
                    rePrompt.HoldDuration = 0
                    rePrompt.MaxActivationDistance = math.huge
                    rePrompt.RequiresLineOfSight = false
                    rePrompt.Enabled = true
                    rePrompt:InputHoldBegin()
                    task.wait(0.1)
                    rePrompt:InputHoldEnd()
                end)
                pcall(function() fireproximityprompt(rePrompt) end)
                task.wait(0.1)
            end
        end
        startE()
        task.wait(0.8)
        stopE()
        carrying2 = isCarryingEgg(char)
        if carrying2 then break end
        task.wait(0.2)
    end

    if not carrying2 then status.Text = "Re-pickup failed"; return false end

    status.Text = "🕊️ To MY ranch..."
    glideTo(hrp, ranchCF.Position, GLIDE_SPEED)
    status.Text = "✅ Delivered!"
    return true
end

local active = false
local loopRunning = false

local function stealLoop()
    if loopRunning then return end
    loopRunning = true
    while active and gui.Parent do
        if not ranchCF then status.Text = "Waiting for ranch..."; task.wait(0.5); continue end
        local list = getCurrentEggs()
        if #list == 0 then status.Text = "Waiting for 1B+ egg..."; task.wait(0.4); continue end
        local best = nil
        for _,e in ipairs(list) do
            if e.num >= MIN_VALUE and e.egg and e.egg.Parent then best = e; break end
        end
        if not best then status.Text = "Waiting for 1B+ egg..."; task.wait(0.4); continue end
        status.Text = "🏆 Stealing: "..best.name.." ("..best.luckText..")"
        pcall(function() doFullFlow(best.egg, best.prompt) end)
        task.wait(0.3)
    end
    loopRunning = false
end

btn.MouseButton1Click:Connect(function()
    if active then
        active = false
        btnLbl.Text = "⚡  STEAL 1B+"
        btn.BackgroundColor3 = Color3.fromRGB(60, 25, 120)
        status.Text = "Steal OFF"
    else
        active = true
        btnLbl.Text = "⚡  STEAL 1B+: ON"
        btn.BackgroundColor3 = Color3.fromRGB(20, 140, 50)
        status.Text = "Steal ON"
        if not loopRunning then task.spawn(stealLoop) end
    end
end)

local hatchActive = false
local function fireHatchPrompts()
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return end
    for _,p in ipairs(plots:GetChildren()) do
        for _,d in ipairs(p:GetDescendants()) do
            if d:IsA("ProximityPrompt") then
                local a = (d.ActionText or ""):lower()
                local o = (d.ObjectText or ""):lower()
                if a:find("hatch") or a:find("open") or o:find("hatch") or o:find("egg") then
                    d.HoldDuration = 0
                    d.MaxActivationDistance = math.huge
                    pcall(fireproximityprompt, d)
                end
            end
        end
    end
end
local function hatchLoop() while hatchActive and gui.Parent do fireHatchPrompts(); task.wait(0.5) end end

local buyActive = false
local function buyOnce()
    local G = RS.Remotes and RS.Remotes:FindFirstChild("Game")
    if not G then return end
    local P = G:FindFirstChild("Plot")
    if not P then return end
    local up = P:FindFirstChild("Upgrades")
    if up then pcall(function() up:FireServer() end) end
end
local function buyLoop() while buyActive and gui.Parent do buyOnce(); status.Text = "Buying..."; task.wait(0.2) end end

local function findVolcanoCave()
    for _, v in ipairs(workspace:GetChildren()) do
        local n = (v.Name or ""):lower()
        if n:find("volcan") or n:find("lava") or n:find("cave") then return v end
    end
    return nil
end

local function findVolcanicEgg()
    local candidates = {}
    local function checkObj(v)
        if not v or not v.Parent then return end
        local n = (v.Name or ""):lower()
        if n:find("volcan") or n:find("lava") or n:find("magma") or n:find("fire") then
            if n:find("egg") or n:find("spawn") then
                if not candidates[v] then candidates[v] = true end
            end
        end
    end
    local containers = {workspace:FindFirstChild("RenderedEggs"), workspace:FindFirstChild("Eggs")}
    for _, cont in ipairs(containers) do
        if cont then for _, v in ipairs(cont:GetChildren()) do checkObj(v) end end
    end
    for _, v in ipairs(workspace:GetChildren()) do
        local n = (v.Name or ""):lower()
        if n:find("volcan") or n:find("cave") or n:find("lava") or n:find("zone") or n:find("area") or n:find("spawn") then
            for _, child in ipairs(v:GetDescendants()) do checkObj(child) end
        end
    end
    if next(candidates) == nil then
        for _, v in ipairs(workspace:GetDescendants()) do checkObj(v) end
    end
    for v in pairs(candidates) do return v end
    return nil
end

local volcanoActive = false
local volcanoRunning = false

local function volcanicCycle()
    if not volcanoActive or volcanoRunning or not ranchCF then return end
    volcanoRunning = true
    local char = lp.Character
    if not char then volcanoRunning = false; return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then volcanoRunning = false; return end

    local VE = findVolcanicEgg()
    if not VE then
        status.Text = "🌋 Entering cave..."
        local cave = findVolcanoCave()
        if cave then
            local cavePos = getPos(cave)
            if cavePos then
                glideTo(hrp, cavePos, GLIDE_SPEED)
                task.wait(1)
                VE = findVolcanicEgg()
            end
        end
    end

    if not VE then status.Text = "🌋 No volcano egg"; volcanoRunning = false; task.wait(2); return end

    local eggPos = getPos(VE)
    if not eggPos then volcanoRunning = false; return end

    status.Text = "🌋 Picking up..."
    glideTo(hrp, eggPos + Vector3.new(0, 3, 0), GLIDE_SPEED)
    task.wait(0.2)

    local carrying = false
    for attempt = 1, 3 do
        if not VE.Parent then break end
        tryPickup(VE)
        task.wait(0.2)
        carrying = isCarryingEgg(char)
        if carrying then break end
        if VE.Parent then
            local p = getPos(VE)
            if p then glideTo(hrp, p + Vector3.new(0, 3, 0), GLIDE_SPEED) end
        end
        task.wait(0.2)
    end

    if not carrying then status.Text = "🌋 Pickup failed"; volcanoRunning = false; task.wait(1); return end

    status.Text = "🌋 Escaping..."
    local cave = findVolcanoCave()
    if cave then
        local part = cave:IsA("BasePart") and cave or cave:FindFirstChildWhichIsA("BasePart", true)
        if part then
            glideTo(hrp, part.Position + Vector3.new(0, 150, 0), GLIDE_SPEED)
            task.wait(0.3)
        end
    else
        glideTo(hrp, hrp.Position + Vector3.new(0, 150, 0), GLIDE_SPEED)
        task.wait(0.3)
    end

    status.Text = "🌋 To fence..."
    local halfX, halfZ = 40, 40
    local bp = nil
    if plotModel then
        bp = plotModel:FindFirstChild("Baseplate") or plotModel:FindFirstChildWhichIsA("BasePart", true)
        if bp then halfX = bp.Size.X / 2; halfZ = bp.Size.Z / 2 end
    end
    local dropX = halfX + FENCE_OFFSET
    local dropZ = halfZ + FENCE_OFFSET
    local groundY
    if bp then groundY = bp.Position.Y + bp.Size.Y / 2 + 3 else groundY = ranchCF.Position.Y - 4 end

    local myPos = hrp.Position
    local dx = myPos.X - ranchCF.Position.X
    local dz = myPos.Z - ranchCF.Position.Z
    local targetX, targetZ
    if math.abs(dx) > math.abs(dz) then
        local sign = dx > 0 and 1 or -1
        targetX = ranchCF.Position.X + sign * dropX
        targetZ = ranchCF.Position.Z
    else
        local sign = dz > 0 and 1 or -1
        targetX = ranchCF.Position.X
        targetZ = ranchCF.Position.Z + sign * dropZ
    end

    pcall(function() hrp:SetNetworkOwner(lp) end)
    pcall(function() hrp.CFrame = CFrame.new(targetX, groundY, targetZ) end)
    pcall(function()
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.Velocity = Vector3.zero
        hrp.RotVelocity = Vector3.zero
    end)
    task.wait(0.4)

    local lockedCF = hrp.CFrame
    local lockActive = true
    local holdBV = Instance.new("BodyVelocity")
    holdBV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    holdBV.Velocity = Vector3.zero
    holdBV.Parent = hrp
    local holdBG = Instance.new("BodyGyro")
    holdBG.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    holdBG.P = 100000
    holdBG.CFrame = hrp.CFrame
    holdBG.Parent = hrp
    task.spawn(function()
        while lockActive and hrp.Parent do
            pcall(function()
                hrp.CFrame = lockedCF
                hrp.AssemblyLinearVelocity = Vector3.zero
                hrp.Velocity = Vector3.zero
                hrp.RotVelocity = Vector3.zero
            end)
            task.wait(0.02)
        end
    end)
    task.wait(0.4)

    status.Text = "🌋 Drop..."
    dropEgg()
    task.wait(0.6)

    lockActive = false
    task.wait(0.05)
    holdBV:Destroy()
    holdBG:Destroy()
    task.wait(0.1)

    status.Text = "🌋 Waiting 2s..."
    task.wait(2)

    local carrying2 = false
    for attempt = 1, 3 do
        status.Text = "🌋 Re-pickup "..attempt.."/3..."
        local rePrompt = findNearestPrompt(hrp, 80)
        if rePrompt then
            local part = rePrompt.Parent
            if part and part:IsA("BasePart") then
                glideTo(hrp, part.Position + Vector3.new(0, 3, 0), GLIDE_SPEED)
            end
            for j = 1, 3 do
                pcall(function()
                    rePrompt.HoldDuration = 0
                    rePrompt.MaxActivationDistance = math.huge
                    rePrompt.RequiresLineOfSight = false
                    rePrompt.Enabled = true
                    rePrompt:InputHoldBegin()
                    task.wait(0.1)
                    rePrompt:InputHoldEnd()
                end)
                pcall(function() fireproximityprompt(rePrompt) end)
                task.wait(0.1)
            end
        end
        startE()
        task.wait(0.8)
        stopE()
        carrying2 = isCarryingEgg(char)
        if carrying2 then break end
        task.wait(0.2)
    end

    if not carrying2 then status.Text = "🌋 Re-pickup failed"; volcanoRunning = false; return end

    status.Text = "🌋 To ranch..."
    glideTo(hrp, ranchCF.Position, GLIDE_SPEED)
    status.Text = "🌋 ✅ Delivered!"
    volcanoRunning = false
end

task.spawn(function()
    while gui.Parent do
        local list = getCurrentEggs()
        if #list == 0 then eggList.Text = "○ no eggs"
        else
            local txt = ""
            for i = 1, math.min(3, #list) do
                local e = list[i]
                txt = txt .. "· " .. e.name .. " — 🍀 " .. e.luckText .. "\n"
            end
            eggList.Text = txt
        end
        task.wait(6)
    end
end)

hatchBtn.MouseButton1Click:Connect(function()
    hatchActive = not hatchActive
    hatchLbl.Text = hatchActive and "🥚  AUTO HATCH: ON" or "🥚  AUTO HATCH"
    hatchBtn.BackgroundColor3 = hatchActive and Color3.fromRGB(25, 140, 50) or Color3.fromRGB(25, 70, 100)
    status.Text = hatchActive and "Hatch ON" or "Hatch OFF"
    if hatchActive then task.spawn(hatchLoop) end
end)

buyBtn.MouseButton1Click:Connect(function()
    buyActive = not buyActive
    buyLbl.Text = buyActive and "💰  BUY: ON" or "💰  AUTO BUY HATCH LUCK"
    buyBtn.BackgroundColor3 = buyActive and Color3.fromRGB(25, 140, 50) or Color3.fromRGB(90, 65, 15)
    status.Text = buyActive and "Buy ON" or "Buy OFF"
    if buyActive then task.spawn(buyLoop) end
end)

espEggBtn.MouseButton1Click:Connect(function()
    espEggOn = not espEggOn
    espLbl.Text = espEggOn and "👁  EGG ESP: ON" or "👁  EGG ESP: OFF"
    espEggBtn.BackgroundColor3 = espEggOn and Color3.fromRGB(25, 130, 50) or Color3.fromRGB(60, 30, 30)
    if not espEggOn then clearAllESP() end
end)

volcanoBtn.MouseButton1Click:Connect(function()
    volcanoActive = not volcanoActive
    if volcanoActive then
        volLbl.Text = "🌋  VOLCANIC: ON"
        volcanoBtn.BackgroundColor3 = Color3.fromRGB(25, 130, 50)
        status.Text = "Volcanic ON"
        task.spawn(function()
            while volcanoActive and gui.Parent do
                volcanicCycle()
                task.wait(0.3)
            end
        end)
    else
        volLbl.Text = "🌋  AUTO VOLCANIC EGG"
        volcanoBtn.BackgroundColor3 = Color3.fromRGB(100, 30, 20)
        status.Text = "Volcanic OFF"
    end
end)

task.spawn(function()
    task.wait(1)
    setProgress(30)
    task.wait(0.5)
    setProgress(60)
    task.wait(0.5)
    setProgress(85)
    task.wait(0.6)
    setProgress(100)
    task.wait(0.4)

    TweenService:Create(loader, TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 700, 0, 500),
        Position = UDim2.new(0.5, -350, 0.5, -250),
        BackgroundTransparency = 1
    }):Play()
    TweenService:Create(lStroke, TweenInfo.new(0.7), {Transparency = 1}):Play()
    TweenService:Create(star, TweenInfo.new(0.7), {TextTransparency = 1, Rotation = 720, TextSize = 120}):Play()
    TweenService:Create(lTitle, TweenInfo.new(0.7), {TextTransparency = 1}):Play()
    TweenService:Create(lSub, TweenInfo.new(0.7), {TextTransparency = 1}):Play()
    TweenService:Create(barBG, TweenInfo.new(0.7), {BackgroundTransparency = 1}):Play()
    TweenService:Create(barFill, TweenInfo.new(0.7), {BackgroundTransparency = 1}):Play()
    TweenService:Create(pct, TweenInfo.new(0.7), {TextTransparency = 1}):Play()
    TweenService:Create(auroraStroke, TweenInfo.new(0.7), {Transparency = 1}):Play()
    TweenService:Create(overlay, TweenInfo.new(0.9, Enum.EasingStyle.Quad), {BackgroundTransparency = 1}):Play()
    task.wait(0.9)
    overlay:Destroy()

    main.Visible = true
    main.Position = UDim2.new(0, -320, 0.06, 0)
    TweenService:Create(main, TweenInfo.new(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 280, 0, 448),
        Position = UDim2.new(0, 20, 0.06, 0)
    }):Play()
end)

print("[Zenith Premium] Loaded ✦ v130 — FULL OPAQUE super cool loading")
