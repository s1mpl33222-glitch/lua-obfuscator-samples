local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- 🎃 Halloween Colors
local COLORS = {
    bg        = Color3.fromRGB(22, 14, 34),   -- dark purple-black
    bgLight   = Color3.fromRGB(48, 24, 66),   -- purple
    topBar    = Color3.fromRGB(255, 117, 24), -- pumpkin orange
    stroke    = Color3.fromRGB(255, 140, 0),
    start     = Color3.fromRGB(255, 117, 24), -- orange
    stop      = Color3.fromRGB(124, 58, 237), -- witch purple
    text      = Color3.fromRGB(255, 244, 230),
    candy     = Color3.fromRGB(166, 255, 77), -- slime green
}

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MM2FarmGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 270, 0, 170)
mainFrame.Position = UDim2.new(0.5, -135, 0.5, -85)
mainFrame.BackgroundColor3 = COLORS.bg
mainFrame.BackgroundTransparency = 0
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 14)
uiCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = COLORS.stroke
mainStroke.Thickness = 2.5
mainStroke.Parent = mainFrame

local mainGradient = Instance.new("UIGradient")
mainGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, COLORS.bgLight),
    ColorSequenceKeypoint.new(1, COLORS.bg),
})
mainGradient.Rotation = 90
mainGradient.Parent = mainFrame

-- Top Bar
local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 36)
topBar.BackgroundColor3 = COLORS.topBar
topBar.BorderSizePixel = 0
topBar.Parent = mainFrame

local topCorner = Instance.new("UICorner")
topCorner.CornerRadius = UDim.new(0, 14)
topCorner.Parent = topBar

local topGradient = Instance.new("UIGradient")
topGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 150, 40)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(214, 80, 0)),
})
topGradient.Rotation = 0
topGradient.Parent = topBar

-- Header container (auto-centers emoji + title + emoji)
local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 1, 0)
header.BackgroundTransparency = 1
header.Parent = topBar

local headerLayout = Instance.new("UIListLayout")
headerLayout.FillDirection = Enum.FillDirection.Horizontal
headerLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
headerLayout.VerticalAlignment = Enum.VerticalAlignment.Center
headerLayout.SortOrder = Enum.SortOrder.LayoutOrder
headerLayout.Padding = UDim.new(0, 5) -- equal gap on both sides of the title
headerLayout.Parent = header

-- Pumpkin Icon (left)
local pumpkin = Instance.new("TextLabel")
pumpkin.Size = UDim2.new(0, 24, 0, 24)
pumpkin.BackgroundTransparency = 1
pumpkin.Text = "🎃"
pumpkin.TextScaled = true
pumpkin.Font = Enum.Font.GothamBold
pumpkin.LayoutOrder = 1
pumpkin.Parent = header

-- Title (width follows the text length)
local title = Instance.new("TextLabel")
title.Size = UDim2.new(0, 0, 1, 0)
title.AutomaticSize = Enum.AutomaticSize.X
title.BackgroundTransparency = 1
title.Text = "MM2 Auto Farm Candy"
title.TextColor3 = Color3.fromRGB(30, 10, 40)
title.TextScaled = false
title.TextSize = 16
title.Font = Enum.Font.GothamBlack
title.LayoutOrder = 2
title.Parent = header

-- Pumpkin Icon (right, same size as the left one)
local pumpkinEnd = Instance.new("TextLabel")
pumpkinEnd.Size = UDim2.new(0, 24, 0, 24)
pumpkinEnd.BackgroundTransparency = 1
pumpkinEnd.Text = "🎃"
pumpkinEnd.TextScaled = true
pumpkinEnd.Font = Enum.Font.GothamBold
pumpkinEnd.LayoutOrder = 3
pumpkinEnd.Parent = header

-- Status
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(0.9, 0, 0, 22)
statusLabel.Position = UDim2.new(0.05, 0, 0, 44)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "👻 Status: Ready!"
statusLabel.TextColor3 = COLORS.text
statusLabel.TextScaled = true
statusLabel.Font = Enum.Font.GothamSemibold
statusLabel.Parent = mainFrame

-- Speed
local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0.9, 0, 0, 22)
speedLabel.Position = UDim2.new(0.05, 0, 0, 68)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "⚡ Speed: 50"
speedLabel.TextColor3 = COLORS.candy
speedLabel.TextScaled = true
speedLabel.Font = Enum.Font.GothamSemibold
speedLabel.Parent = mainFrame

-- START / STOP Button
local startButton = Instance.new("TextButton")
startButton.Size = UDim2.new(0.9, 0, 0, 38)
startButton.Position = UDim2.new(0.05, 0, 0, 96)
startButton.BackgroundColor3 = COLORS.start
startButton.Text = "🍬 START"
startButton.TextColor3 = Color3.fromRGB(30, 10, 40)
startButton.TextScaled = true
startButton.Font = Enum.Font.GothamBlack
startButton.Parent = mainFrame

local startCorner = Instance.new("UICorner")
startCorner.CornerRadius = UDim.new(0, 10)
startCorner.Parent = startButton

local startStroke = Instance.new("UIStroke")
startStroke.Color = Color3.fromRGB(255, 200, 120)
startStroke.Thickness = 2
startStroke.Parent = startButton

-- Halloween decorations
local bat = Instance.new("TextLabel")
bat.Size = UDim2.new(0, 18, 0, 18)
bat.Position = UDim2.new(1, -24, 0, 70)
bat.BackgroundTransparency = 1
bat.Text = "🦇"
bat.TextScaled = true
bat.Parent = mainFrame

local spider = Instance.new("TextLabel")
spider.Size = UDim2.new(0, 18, 0, 18)
spider.Position = UDim2.new(0, 6, 0, 70)
spider.BackgroundTransparency = 1
spider.Text = "🕷️"
spider.TextScaled = true
spider.Parent = mainFrame

-- Credit Text
local creditLabel = Instance.new("TextLabel")
creditLabel.Size = UDim2.new(1, 0, 0, 13)
creditLabel.Position = UDim2.new(0, 0, 1, -19)
creditLabel.BackgroundTransparency = 1
creditLabel.Text = "🦇 Made by Mozil Scripts 🦇"
creditLabel.TextColor3 = Color3.fromRGB(255, 190, 120)
creditLabel.TextScaled = true
creditLabel.Font = Enum.Font.GothamSemibold
creditLabel.TextTransparency = 0.3
creditLabel.Parent = mainFrame

-- Variables
local isFarming = false
local farmingConnection = nil

-- Smooth Draggable
local UserInputService = game:GetService("UserInputService")
local DragTweenService = game:GetService("TweenService")

local dragging = false
local dragInput = nil
local dragStart = nil
local startPos = nil
local dragTween = nil

local function updateDrag(input)
    local delta = input.Position - dragStart
    local goal = UDim2.new(
        startPos.X.Scale,
        startPos.X.Offset + delta.X,
        startPos.Y.Scale,
        startPos.Y.Offset + delta.Y
    )
    if dragTween then dragTween:Cancel() end
    dragTween = DragTweenService:Create(
        mainFrame,
        TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {Position = goal}
    )
    dragTween:Play()
end

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

mainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        updateDrag(input)
    end
end)

-- ==================== FARMING SCRIPT ====================
local TweenService = game:GetService("TweenService")
local LP = game.Players.LocalPlayer
local Char = LP.Character or LP.CharacterAdded:Wait()
local HRP = Char:WaitForChild("HumanoidRootPart")
local Humanoid = Char:WaitForChild("Humanoid")

local function GetMap()
    while true do
        for _, obj in ipairs(workspace:GetChildren()) do
            if obj:GetAttribute("MapID") and obj:FindFirstChild("CoinContainer") then
                return obj
            end
        end
        task.wait()
    end
end

local function getNearest()
    local map = GetMap()
    local closest, dist = nil, math.huge
    for _, coin in ipairs(map.CoinContainer:GetChildren()) do
        local v = coin:FindFirstChild("CoinVisual")
        if v and not v:GetAttribute("Collected") then
            local d = (HRP.Position - coin.Position).Magnitude
            if d < dist then
                closest = coin
                dist = d
            end
        end
    end
    return closest
end

local function tp(hp)
    Humanoid:ChangeState(11)
    local d = (HRP.Position - hp.Position).Magnitude
    local t = TweenService:Create(HRP, TweenInfo.new(d / 25, Enum.EasingStyle.Linear), {CFrame = hp.CFrame})
    t:Play()
    t.Completed:Wait()
end

local function startFarming()
    if farmingConnection then return end

    farmingConnection = task.spawn(function()
        while isFarming do
            local target = getNearest()
            if target and LP:GetAttribute("Alive") then
                tp(target)
                local v = target:FindFirstChild("CoinVisual")
                while v and not v:GetAttribute("Collected") and v.Parent and isFarming do
                    if not LP:GetAttribute("Alive") then break end
                    local n = getNearest()
                    if n and n ~= target then break end
                    task.wait()
                end
            else
                task.wait(0.5)
            end
        end
    end)
end

local function stopFarming()
    isFarming = false
    if farmingConnection then
        farmingConnection = nil
    end
end

-- Toggle Function
local function toggleFarming()
    isFarming = not isFarming

    if isFarming then
        startButton.Text = "💀 STOP"
        startButton.BackgroundColor3 = COLORS.stop
        startButton.TextColor3 = COLORS.text
        startStroke.Color = Color3.fromRGB(190, 150, 255)
        statusLabel.Text = "🔪 Status: Farming..."
        startFarming()
        print("MM2 Farm Started!")
    else
        startButton.Text = "🍬 START"
        startButton.BackgroundColor3 = COLORS.start
        startButton.TextColor3 = Color3.fromRGB(30, 10, 40)
        startStroke.Color = Color3.fromRGB(255, 200, 120)
        statusLabel.Text = "👻 Status: Stopped"
        stopFarming()
        print("MM2 Farm Stopped!")
    end
end

-- Button Connections
startButton.MouseButton1Click:Connect(toggleFarming)
