local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

local gui = Instance.new("ScreenGui")
gui.Name = "GalaxyBackgroundGUI"
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false
gui.Parent = CoreGui

local background = Instance.new("Frame")
background.Name = "Background"
background.Size = UDim2.new(1, 0, 1, 0)
background.BackgroundColor3 = Color3.fromRGB(10, 2, 2)
background.BackgroundTransparency = 1
background.BorderSizePixel = 0
background.Parent = gui

local bgImage = Instance.new("ImageLabel")
bgImage.Name = "BackgroundImage"
bgImage.Size = UDim2.new(1, 0, 1, 0)
bgImage.BackgroundTransparency = 1
bgImage.Image = "rbxassetid://134082978486929"
bgImage.ImageTransparency = 1
bgImage.ScaleType = Enum.ScaleType.Crop
bgImage.Parent = background

local vignette = Instance.new("Frame")
vignette.Size = UDim2.new(1, 0, 1, 0)
vignette.BackgroundTransparency = 1
vignette.BorderSizePixel = 0
vignette.Parent = background

local vignetteGrad = Instance.new("UIGradient")
vignetteGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0,0,0)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(20,0,0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0,0,0))
})
vignetteGrad.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 1),
    NumberSequenceKeypoint.new(0.3, 0.5),
    NumberSequenceKeypoint.new(0.7, 0.5),
    NumberSequenceKeypoint.new(1, 1)
})
vignetteGrad.Rotation = 90
vignetteGrad.Parent = vignette

for i = 1, 100 do
    local star = Instance.new("Frame")
    star.Size = UDim2.new(0, math.random(1, 3), 0, math.random(1, 3))
    star.Position = UDim2.new(math.random(), 0, math.random(), 0)
    star.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
    star.BorderSizePixel = 0
    star.BackgroundTransparency = math.random(20, 80) / 100
    star.Parent = background

    task.spawn(function()
        while star and star.Parent do
            local twinkle = TweenService:Create(star, TweenInfo.new(
                math.random(15, 30)/10,
                Enum.EasingStyle.Linear,
                Enum.EasingDirection.InOut,
                -1
            ), {BackgroundTransparency = math.random(0, 100) / 100})
            twinkle:Play()
            twinkle.Completed:Wait()
        end
    end)
end

local galaxyArms = {}
local armColors = {
    {Color3.fromRGB(255, 0, 50), Color3.fromRGB(100, 0, 0)},
    {Color3.fromRGB(200, 0, 50), Color3.fromRGB(50, 0, 20)},
    {Color3.fromRGB(150, 20, 20), Color3.fromRGB(255, 50, 50)},
    {Color3.fromRGB(100, 0, 0), Color3.fromRGB(40, 0, 0)},
}

for idx, colors in ipairs(armColors) do
    local arm = Instance.new("Frame")
    arm.Name = "GalaxyArm"..idx
    arm.AnchorPoint = Vector2.new(0.5, 0.5)
    arm.Position = UDim2.new(0.5, 0, 0.5, 0)
    arm.Size = UDim2.new(1.5, 0, 0.3, 0)
    arm.Rotation = idx * 45
    arm.BackgroundTransparency = 0.5
    arm.BorderSizePixel = 0
    arm.Parent = background

    local armGrad = Instance.new("UIGradient")
    armGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, colors[1]),
        ColorSequenceKeypoint.new(0.5, colors[2]),
        ColorSequenceKeypoint.new(1, colors[1])
    })
    armGrad.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.8),
        NumberSequenceKeypoint.new(0.3, 0.3),
        NumberSequenceKeypoint.new(0.7, 0.3),
        NumberSequenceKeypoint.new(1, 0.8)
    })
    armGrad.Rotation = 0
    armGrad.Parent = arm

    table.insert(galaxyArms, arm)
end

for _, arm in ipairs(galaxyArms) do
    task.spawn(function()
        while arm and arm.Parent do
            local rotTween = TweenService:Create(arm, TweenInfo.new(
                10 + math.random()*5, 
                Enum.EasingStyle.Linear, 
                Enum.EasingDirection.InOut, 
                -1
            ), {Rotation = arm.Rotation + 360})
            rotTween:Play()
            rotTween.Completed:Wait()
        end
    end)
    
    task.spawn(function()
        local grad = arm:FindFirstChildOfClass("UIGradient")
        if not grad then return end
        while arm and arm.Parent do
            local offTween = TweenService:Create(grad, TweenInfo.new(
                6 + math.random()*4, 
                Enum.EasingStyle.Linear, 
                Enum.EasingDirection.InOut, 
                -1
            ), {Rotation = grad.Rotation + 360})
            offTween:Play()
            offTween.Completed:Wait()
        end
    end)
end

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(0, 500, 0, 60)
titleLabel.Position = UDim2.new(0.5, -250, 0.4, -30)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "ThanhDuyHub V1.4.0"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 36
titleLabel.Font = Enum.Font.Arcade
titleLabel.TextTransparency = 1
titleLabel.Parent = gui

local titleStroke = Instance.new("UIStroke")
titleStroke.Color = Color3.fromRGB(200, 0, 0)
titleStroke.Thickness = 2
titleStroke.Parent = titleLabel

local loadingLabel = Instance.new("TextLabel")
loadingLabel.Name = "LoadingLabel"
loadingLabel.Size = UDim2.new(0, 300, 0, 40)
loadingLabel.Position = UDim2.new(0.5, -150, 0.5, -20)
loadingLabel.BackgroundTransparency = 1
loadingLabel.Text = "Loading... 0%"
loadingLabel.TextColor3 = Color3.fromRGB(255, 200, 200)
loadingLabel.TextSize = 24
loadingLabel.Font = Enum.Font.Arcade
loadingLabel.TextTransparency = 1
loadingLabel.Parent = gui

local skipButton = Instance.new("TextButton")
skipButton.Name = "SkipButton"
skipButton.Size = UDim2.new(0, 200, 0, 40)
skipButton.Position = UDim2.new(0.5, -100, 0.85, -20)
skipButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
skipButton.BackgroundTransparency = 0.3
skipButton.Text = "Skip Loading"
skipButton.TextColor3 = Color3.fromRGB(255, 255, 255)
skipButton.TextSize = 20
skipButton.Font = Enum.Font.Arcade
skipButton.Visible = false
skipButton.Parent = gui

local skipStroke = Instance.new("UIStroke")
skipStroke.Color = Color3.fromRGB(255, 50, 50)
skipStroke.Thickness = 2
skipStroke.Parent = skipButton

local skipCorner = Instance.new("UICorner")
skipCorner.CornerRadius = UDim.new(0, 8)
skipCorner.Parent = skipButton

local function fadeInBackground()
    local tweenInfo = TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    TweenService:Create(background, tweenInfo, {BackgroundTransparency = 0.2}):Play()
    TweenService:Create(bgImage, tweenInfo, {ImageTransparency = 0.3}):Play()
end

local function fadeInTitle()
    local tweenInfo = TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(titleLabel, tweenInfo, {TextTransparency = 0})
    tween:Play()
    tween.Completed:Wait()
end

local function fadeInLoading()
    local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(loadingLabel, tweenInfo, {TextTransparency = 0})
    tween:Play()
    tween.Completed:Wait()
end

local function fadeOutGUI()
    local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
    local elements = {titleLabel, loadingLabel, skipButton}
    for _, element in ipairs(elements) do
        if element and element.Parent then
            local tween = TweenService:Create(element, tweenInfo, {TextTransparency = 1})
            tween:Play()
        end
    end
    task.wait(0.5)
    local bgTween = TweenService:Create(background, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1})
    local imgTween = TweenService:Create(bgImage, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {ImageTransparency = 1})
    bgTween:Play()
    imgTween:Play()
    bgTween.Completed:Wait()
    gui:Destroy()
end

local function showSkipButton()
    skipButton.Visible = true
    skipButton.Position = UDim2.new(0.5, -100, 0.85, -20)
    skipButton.BackgroundTransparency = 0.3
    
    local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    local tween = TweenService:Create(skipButton, tweenInfo, {Position = UDim2.new(0.5, -100, 0.88, -20)})
    tween:Play()
end

local loadingComplete = false
local scriptExecuted = false

local function loadMainScript()
    if scriptExecuted then return end
    scriptExecuted = true
    loadstring(game:HttpGet("https://api.jnkie.com/api/v1/luascripts/public/8d6150f8cadccb27861339da3340df23f855488c3886d8e419028833c38d261e/download"))()
end

local function startLoading()
    fadeInBackground()
    fadeInTitle()
    task.wait(0.5)
    fadeInLoading()
    
    task.wait(4)
    if not loadingComplete then
        showSkipButton()
    end
    
    local loadingStages = {
        {duration = 1, targetPercent = 10},
        {duration = 3, targetPercent = 40},
        {duration = 1, targetPercent = 55},
        {duration = 2.5, targetPercent = 80},
        {duration = 2.5, targetPercent = 100}
    }
    
    local currentPercent = 0
    
    for _, stage in ipairs(loadingStages) do
        if loadingComplete then break end
        
        local startPercent = currentPercent
        local targetPercent = stage.targetPercent
        local duration = stage.duration
        
        local startTime = tick()
        while tick() - startTime < duration do
            if loadingComplete then break end
            local elapsed = tick() - startTime
            local alpha = math.min(elapsed / duration, 1)
            currentPercent = startPercent + (targetPercent - startPercent) * alpha
            loadingLabel.Text = string.format("Loading... %d%%", math.floor(currentPercent))
            task.wait()
        end
        
        if not loadingComplete then
            currentPercent = targetPercent
            loadingLabel.Text = string.format("Loading... %d%%", math.floor(currentPercent))
        end
    end
    
    if not loadingComplete then
        loadingComplete = true
        loadingLabel.Text = "Loading... 100%"
        task.wait(1)
        fadeOutGUI()
        task.wait(0.5)
        loadMainScript()
    end
end

skipButton.MouseButton1Click:Connect(function()
    if loadingComplete then return end
    loadingComplete = true
    loadingLabel.Text = "Loading... 100%"
    task.wait(0.5)
    fadeOutGUI()
    task.wait(0.5)
    loadMainScript()
end)

task.spawn(startLoading)
