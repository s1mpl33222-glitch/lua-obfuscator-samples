-- ============================================
-- ORVYN AUTH - "nice try buddy"
-- This is what a dump attempt gets instead of the script.
-- It is intentionally long, does nothing useful, and says so.
-- ============================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local SoundService = game:GetService("SoundService")
local StarterGui = game:GetService("StarterGui")
local ContextActionService = game:GetService("ContextActionService")
local GuiService = game:GetService("GuiService")
local HttpService = game:GetService("HttpService")
local ContentProvider = game:GetService("ContentProvider")
local LocalizationService = game:GetService("LocalizationService")
local TextService = game:GetService("TextService")
local CollectionService = game:GetService("CollectionService")
local PathfindingService = game:GetService("PathfindingService")
local PhysicsService = game:GetService("PhysicsService")
local SocialService = game:GetService("SocialService")
local TeleportService = game:GetService("TeleportService")
local BadgeService = game:GetService("BadgeService")
local MarketplaceService = game:GetService("MarketplaceService")
local DataStoreService = game:GetService("DataStoreService")
local MemoryStoreService = game:GetService("MemoryStoreService")
local MessagingService = game:GetService("MessagingService")
local AssetService = game:GetService("AssetService")
local VRService = game:GetService("VRService")
local HapticService = game:GetService("HapticService")
local VoiceChatService = game:GetService("VoiceChatService")

local player = Players.LocalPlayer
print("Player found: " .. tostring(player))

local playerGui = player:WaitForChild("PlayerGui")
print("PlayerGui found")

local uselessFolder = Instance.new("Folder")
uselessFolder.Name = "UselessStuff_DoNotDelete"
uselessFolder.Parent = playerGui

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "NiceTryBuddyGui"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.DisplayOrder = 999
screenGui.Enabled = true
screenGui.Parent = uselessFolder
print("ScreenGui created")

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 500, 0, 300)
mainFrame.Position = UDim2.new(0.5, -250, 0.5, -150)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 0
mainFrame.Visible = true
mainFrame.Parent = screenGui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 20)
uiCorner.Parent = mainFrame

local uiStroke = Instance.new("UIStroke")
uiStroke.Color = Color3.fromRGB(255, 100, 100)
uiStroke.Thickness = 3
uiStroke.Transparency = 0.2
uiStroke.Parent = mainFrame

local uiGradient = Instance.new("UIGradient")
uiGradient.Color = ColorSequence.new {
    ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 40, 60)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(60, 30, 60)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 40, 60))
}
uiGradient.Rotation = 45
uiGradient.Parent = mainFrame

local uiPadding = Instance.new("UIPadding")
uiPadding.PaddingTop = UDim.new(0, 10)
uiPadding.PaddingBottom = UDim.new(0, 10)
uiPadding.PaddingLeft = UDim.new(0, 10)
uiPadding.PaddingRight = UDim.new(0, 10)
uiPadding.Parent = mainFrame

local uiListLayout = Instance.new("UIListLayout")
uiListLayout.FillDirection = Enum.FillDirection.Vertical
uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
uiListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
uiListLayout.Padding = UDim.new(0, 10)
uiListLayout.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(1, 0, 0, 50)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Nice Try Buddy"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true
titleLabel.TextWrapped = true
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 40
titleLabel.LayoutOrder = 1
titleLabel.Parent = mainFrame

local textGradient = Instance.new("UIGradient")
textGradient.Color = ColorSequence.new {
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 100, 100)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 200, 100)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 100, 100))
}
textGradient.Rotation = 90
textGradient.Parent = titleLabel

local subtitleLabel = Instance.new("TextLabel")
subtitleLabel.Name = "SubtitleLabel"
subtitleLabel.Size = UDim2.new(1, 0, 0, 30)
subtitleLabel.BackgroundTransparency = 1
subtitleLabel.Text = "This GUI does absolutely nothing useful."
subtitleLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
subtitleLabel.TextScaled = true
subtitleLabel.TextWrapped = true
subtitleLabel.Font = Enum.Font.Gotham
subtitleLabel.TextSize = 18
subtitleLabel.LayoutOrder = 2
subtitleLabel.Parent = mainFrame

local spacer = Instance.new("Frame")
spacer.Name = "Spacer"
spacer.Size = UDim2.new(1, 0, 0, 20)
spacer.BackgroundTransparency = 1
spacer.LayoutOrder = 3
spacer.Parent = mainFrame

local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 200, 0, 50)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeButton.Text = "Close (or don't)"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextScaled = true
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 20
closeButton.LayoutOrder = 4
closeButton.Parent = mainFrame

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 10)
buttonCorner.Parent = closeButton

local buttonStroke = Instance.new("UIStroke")
buttonStroke.Color = Color3.fromRGB(255, 100, 100)
buttonStroke.Thickness = 2
buttonStroke.Parent = closeButton

local buttonGradient = Instance.new("UIGradient")
buttonGradient.Color = ColorSequence.new {
    ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 50, 50)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 30, 30))
}
buttonGradient.Rotation = 45
buttonGradient.Parent = closeButton

local clickCount = 0

local function uselessFunction()
    print("This function does nothing.")
    return nil
end

local function anotherUselessFunction()
    for i = 1, 10 do
        local x = i * 2
        local y = x / 2
        local z = y - i
        -- z should be 0, but we do not do anything with it
    end
end

local function yetAnotherUselessFunction(a, b, c)
    if a then
        if b then
            if c then
                return "all true"
            else
                return "c is false"
            end
        else
            return "b is false"
        end
    else
        return "a is false"
    end
end

local function isEven(num)
    return num % 2 == 0
end

local function isOdd(num)
    return num % 2 ~= 0
end

local function factorial(n)
    if n <= 1 then
        return 1
    end
    return n * factorial(n - 1)
end

local function fibonacci(n)
    if n <= 1 then
        return n
    end
    return fibonacci(n - 1) + fibonacci(n - 2)
end

local function randomString(length)
    local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    local result = ""
    for i = 1, length do
        local randIndex = math.random(1, #chars)
        result = result .. chars:sub(randIndex, randIndex)
    end
    return result
end

local function createParticleEffect(position)
    local part = Instance.new("Part")
    part.Position = position
    part.Anchored = true
    part.CanCollide = false
    part.Transparency = 1
    part.Parent = Workspace

    local particleEmitter = Instance.new("ParticleEmitter")
    particleEmitter.Parent = part

    return part
end

local function playSound(soundId)
    local sound = Instance.new("Sound")
    sound.SoundId = soundId
    sound.Parent = SoundService
    -- we do not actually play it
    return sound
end

local uselessCounter = 0
for i = 1, 100 do
    uselessCounter = uselessCounter + i
    if uselessCounter > 1000 then
        uselessCounter = 0
    end
end
print("Useless counter final value: " .. uselessCounter)

local stringBuilder = ""
for i = 1, 50 do
    stringBuilder = stringBuilder .. tostring(i) .. ","
end
print("String builder length: " .. #stringBuilder)

local loopCount = 0
while loopCount < 1 do
    loopCount = loopCount + 1
    uselessFunction()
end

local uselessTable = {
    "apple",
    "banana",
    "cherry",
    "date",
    "elderberry",
    numbers = { 1, 2, 3, 4, 5 },
    nested = {
        deep = {
            deeper = {
                deepest = "wow"
            }
        }
    }
}

for _, value in pairs(uselessTable) do
    if type(value) == "string" then
        local upper = string.upper(value)
        local lower = string.lower(value)
        local len = #value
    end
end

local randomNumber = math.random(1, 1000000)
print("Random number: " .. randomNumber)

local anotherRandomNumber = math.random()
print("Another random number: " .. anotherRandomNumber)

local mathResult = math.sin(math.pi / 4) * math.cos(math.pi / 4) + math.tan(math.pi / 6)
print("Pointless math result: " .. mathResult)

local uselessVector = Vector3.new(1, 2, 3)
local uselessVector2 = Vector3.new(4, 5, 6)
local vectorSum = uselessVector + uselessVector2
print("Vector sum: " .. tostring(vectorSum))

local uselessCFrame = CFrame.new(0, 10, 0)
local rotatedCFrame = uselessCFrame * CFrame.Angles(0, math.pi, 0)
print("CFrame position: " .. tostring(rotatedCFrame.Position))

local uselessColor = Color3.fromRGB(123, 45, 67)
local anotherColor = Color3.fromHSV(0.5, 0.5, 0.5)
print("Colors created but not used")

local uselessUDim2 = UDim2.new(0.5, 100, 0.5, 50)
local anotherUDim2 = UDim2.fromScale(0.25, 0.75)
print("UDim2 values created but not used")

closeButton.MouseButton1Click:Connect(function()
    clickCount = clickCount + 1
    print("Button clicked " .. clickCount .. " times")

    uselessFunction()
    anotherUselessFunction()
    yetAnotherUselessFunction(true, true, true)

    if isEven(clickCount) then
        print("Click count is even")
    else
        print("Click count is odd")
    end

    if clickCount <= 10 then
        local fact = factorial(clickCount)
        print("Factorial of click count: " .. fact)
    end

    if clickCount <= 15 then
        local fib = fibonacci(clickCount)
        print("Fibonacci of click count: " .. fib)
    end

    local randStr = randomString(10)
    print("Random string: " .. randStr)

    local originalSize = closeButton.Size
    local tweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out)
    local tween = TweenService:Create(closeButton, tweenInfo, {
        Size = UDim2.new(0, 220, 0, 55)
    })
    tween:Play()

    task.wait(0.1)
    local revertTween = TweenService:Create(closeButton, TweenInfo.new(0.1), {
        Size = originalSize
    })
    revertTween:Play()

    closeButton.Text = "Clicked " .. clickCount .. " times!"

    if clickCount >= 10 then
        closeButton.Text = "Okay okay, stop clicking!"
        task.wait(2)
        clickCount = 0
        closeButton.Text = "Close (or don't)"
    end
end)

closeButton.MouseEnter:Connect(function()
    local hoverTween = TweenService:Create(closeButton, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(255, 80, 80)
    })
    hoverTween:Play()
end)

closeButton.MouseLeave:Connect(function()
    local leaveTween = TweenService:Create(closeButton, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    })
    leaveTween:Play()
end)

local pulseConnection
pulseConnection = RunService.Heartbeat:Connect(function()
    local time = tick()
    local pulse = math.sin(time * 2) * 0.5 + 0.5
    titleLabel.TextColor3 = Color3.fromRGB(
        255,
        math.floor(200 + pulse * 55),
        math.floor(100 + pulse * 100)
    )
end)

local dragging = false
local dragStart
local startPos

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
        if dragging then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end
end)

local rotationConnection
rotationConnection = RunService.RenderStepped:Connect(function()
    local currentRotation = mainFrame.Rotation
    mainFrame.Rotation = currentRotation + 0.01
    if mainFrame.Rotation >= 360 then
        mainFrame.Rotation = 0
    end
end)

task.delay(30, function()
    if rotationConnection then
        rotationConnection:Disconnect()
    end
    print("Rotation animation stopped after 30 seconds")
end)

task.delay(60, function()
    if subtitleLabel and subtitleLabel.Parent then
        subtitleLabel.Text = "You have been staring at this GUI for a minute. Impressive."
    end
end)

task.delay(120, function()
    if subtitleLabel and subtitleLabel.Parent then
        subtitleLabel.Text = "Seriously, why are you still here? Nice try buddy."
    end
end)

print("============================================")
print("GUI Created Successfully!")
print("This GUI does absolutely nothing useful.")
print("Nice try buddy.")
print("============================================")

local servicesList = {
    "Players", "RunService", "TweenService", "UserInputService",
    "ReplicatedStorage", "Workspace", "Lighting", "SoundService",
    "StarterGui", "ContextActionService", "GuiService"
}

for _, serviceName in ipairs(servicesList) do
    local success, service = pcall(function()
        return game:GetService(serviceName)
    end)
    if success then
        print("Service " .. serviceName .. " exists: " .. tostring(service ~= nil))
    end
end

local finalCalculation = 0
for i = 1, 1000 do
    finalCalculation = finalCalculation + math.sqrt(i) - math.sqrt(i - 1)
end
print("Final useless calculation result: " .. finalCalculation)

local quotes = {
    "Nice try buddy.",
    "This GUI is useless.",
    "Why are you reading the console?",
    "You really like clicking buttons, huh?",
    "This code has more comments than functionality.",
    "Nice try buddy.",
    "Did you really read all of this?",
    "Congratulations, you have wasted your time.",
    "Nice try buddy."
}

local randomQuote = quotes[math.random(1, #quotes)]
print("Random quote: " .. randomQuote)

for i = 1, 5 do
    task.wait(1)
    print("Useless loop iteration: " .. i)
end

print("Done! The GUI is now active. Nice try buddy.")
print("Total lines of code: a lot.")
print("Total usefulness: zero.")

return nil
