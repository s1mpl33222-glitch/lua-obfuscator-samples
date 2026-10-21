local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local guiParent = (syn and syn.protect_gui and game:GetService("CoreGui")) or (gethui and gethui()) or player:WaitForChild("PlayerGui")

-- 1. Create the Intro GUI
local introGui = Instance.new("ScreenGui")
introGui.Name = "JZHubIntro_Galaxy"
introGui.IgnoreGuiInset = true
introGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
introGui.Parent = guiParent

-- 2. Create Galaxy Background
local bg = Instance.new("Frame")
bg.Size = UDim2.new(1, 0, 1, 0)
bg.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
bg.BorderSizePixel = 0
bg.Parent = introGui

local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(4, 2, 12)),     -- Deep void
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(26, 11, 46)), -- Nebula purple
    ColorSequenceKeypoint.new(1, Color3.fromRGB(4, 2, 12))
})
gradient.Rotation = 45
gradient.Parent = bg

-- Generate Galaxy Stars
for i = 1, 80 do
    local star = Instance.new("Frame")
    local size = math.random(1, 3)
    star.Size = UDim2.new(0, size, 0, size)
    star.Position = UDim2.new(math.random(), 0, math.random(), 0)
    star.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    star.BackgroundTransparency = math.random(2, 8) / 10
    star.BorderSizePixel = 0
    Instance.new("UICorner", star).CornerRadius = UDim.new(1, 0)
    star.Parent = bg
end

-- 3. UI Elements
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 100)
title.Position = UDim2.new(0, 0, 0.5, -50)
title.BackgroundTransparency = 1
title.Text = "🌸 JZ HUB 🌸"
title.TextColor3 = Color3.fromRGB(240, 128, 158)
title.Font = Enum.Font.GothamBold
title.TextSize = 45
title.TextTransparency = 1
title.Parent = bg

local sword = Instance.new("TextLabel")
sword.Size = UDim2.new(0, 150, 0, 150)
sword.Position = UDim2.new(0.5, -75, -0.2, 0) -- Starts above the screen in the center
sword.BackgroundTransparency = 1
sword.Text = "🗡️"
sword.TextSize = 120
sword.Rotation = -45 -- Points the emoji straight down
sword.ZIndex = 10
sword.Parent = introGui

-- Slower flower particle function
local function spawnFlower()
    local flower = Instance.new("TextLabel")
    flower.Size = UDim2.new(0, 30, 0, 30)
    flower.Position = UDim2.new(math.random(), 0, -0.1, 0)
    flower.BackgroundTransparency = 1
    flower.Text = "🌸"
    flower.TextSize = math.random(20, 35)
    flower.Parent = bg

    -- Drifting slowly between 6 and 12 seconds
    local fallTween = TweenService:Create(flower, TweenInfo.new(math.random(6, 12), Enum.EasingStyle.Linear), {
        Position = UDim2.new(flower.Position.X.Scale, 0, 1.1, 0),
        Rotation = math.random(360, 720)
    })
    fallTween:Play()
    fallTween.Completed:Connect(function()
        if flower.Parent then flower:Destroy() end
    end)
end

-- 4. Run the Cinematic Sequence
task.spawn(function()
    -- Fade in Title
    TweenService:Create(title, TweenInfo.new(1.5), {TextTransparency = 0}):Play()
    
    -- Rain slow flowers for a few seconds
    for i = 1, 25 do
        spawnFlower()
        task.wait(0.12)
    end
    
    task.wait(0.5)

    -- Sword slashes straight DOWN
    local slashTween = TweenService:Create(sword, TweenInfo.new(0.35, Enum.EasingStyle.Exponential, Enum.EasingDirection.In), {
        Position = UDim2.new(0.5, -75, 1.2, 0)
    })
    slashTween:Play()
    slashTween.Completed:Wait()

    -- 5. Screen Slice Effect (Left and Right)
    
    -- Anime Impact Flash
    local flash = Instance.new("Frame")
    flash.Size = UDim2.new(1, 0, 1, 0)
    flash.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    flash.ZIndex = 20
    flash.Parent = introGui
    TweenService:Create(flash, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
    game:GetService("Debris"):AddItem(flash, 0.5)

    -- Setup the two sliding halves
    local leftHalf = Instance.new("Frame")
    leftHalf.Size = UDim2.new(0.5, 0, 1, 0)
    leftHalf.Position = UDim2.new(0, 0, 0, 0)
    leftHalf.ClipsDescendants = true
    leftHalf.BackgroundTransparency = 1
    leftHalf.Parent = introGui

    local rightHalf = Instance.new("Frame")
    rightHalf.Size = UDim2.new(0.5, 0, 1, 0)
    rightHalf.Position = UDim2.new(0.5, 0, 0, 0)
    rightHalf.ClipsDescendants = true
    rightHalf.BackgroundTransparency = 1
    rightHalf.Parent = introGui

    -- Clone the galaxy into both halves, offset perfectly to look seamless
    local bgLeft = bg:Clone()
    bgLeft.Size = UDim2.new(2, 0, 1, 0)
    bgLeft.Position = UDim2.new(0, 0, 0, 0)
    bgLeft.Parent = leftHalf

    local bgRight = bg:Clone()
    bgRight.Size = UDim2.new(2, 0, 1, 0)
    bgRight.Position = UDim2.new(-1, 0, 0, 0)
    bgRight.Parent = rightHalf

    -- Destroy original to allow the split to reveal the game
    bg:Destroy()
    sword:Destroy()

    -- Tween the two halves apart horizontally
    local splitLeft = TweenService:Create(leftHalf, TweenInfo.new(0.8, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
        Position = UDim2.new(-0.5, 0, 0, 0)
    })
    local splitRight = TweenService:Create(rightHalf, TweenInfo.new(0.8, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
        Position = UDim2.new(1, 0, 0, 0)
    })

    splitLeft:Play()
    splitRight:Play()
    splitLeft.Completed:Wait()

    -- Clean up intro GUI
    introGui:Destroy()

    -- 6. Execute your main hub script
    loadstring(game:HttpGet("https://pastebin.com/raw/W2tCqZgk"))()
end)