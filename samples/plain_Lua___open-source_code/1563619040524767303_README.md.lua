-- [[ SH IN THE GAME INTRO SCRIPT FOR DELTA ]] --

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local CoreGui = game:GetService("CoreGui")
local TargetParent = CoreGui or LocalPlayer:WaitForChild("PlayerGui")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SH_IntroGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true 
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 2147483647
ScreenGui.Parent = TargetParent

local Background = Instance.new("Frame")
Background.Size = UDim2.new(1, 0, 1, 0)
Background.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Background.BorderSizePixel = 0
Background.Parent = ScreenGui

local IntroSound = Instance.new("Sound")
IntroSound.SoundId = "rbxassetid://117238020171431"
IntroSound.TimePosition = 26
IntroSound.Volume = 1
IntroSound.Parent = ScreenGui

local ImageLabel = Instance.new("ImageLabel")
ImageLabel.Size = UDim2.new(0, 200, 0, 200)
ImageLabel.Position = UDim2.new(0.5, -100, 0.5, -100)
ImageLabel.BackgroundTransparency = 1
ImageLabel.Image = "rbxassetid://122388586871485"  -- ✅ الصورة الجديدة
ImageLabel.ImageTransparency = 1 
ImageLabel.Parent = Background

local FlashFrame = Instance.new("Frame")
FlashFrame.Size = UDim2.new(1, 0, 1, 0)
FlashFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
FlashFrame.BackgroundTransparency = 1
FlashFrame.BorderSizePixel = 0
FlashFrame.ZIndex = 2 
FlashFrame.Parent = Background

local TextLabel = Instance.new("TextLabel")
TextLabel.Size = UDim2.new(1, 0, 0, 100)
TextLabel.Position = UDim2.new(0, 0, 0.5, -50)
TextLabel.BackgroundTransparency = 1
TextLabel.Text = "SH IN THE GAME ☠️ "  -- ✅ الاسم الجديد
TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.TextSize = 50
TextLabel.Font = Enum.Font.Code
TextLabel.TextTransparency = 1 
TextLabel.Parent = Background

local SkipHintLabel = Instance.new("TextLabel")
SkipHintLabel.Size = UDim2.new(1, 0, 0, 50)
SkipHintLabel.Position = UDim2.new(0, 0, 1, -60)
SkipHintLabel.BackgroundTransparency = 1
SkipHintLabel.Text = "اضغط مرتين لتخطي الإنترو"
SkipHintLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
SkipHintLabel.TextSize = 16
SkipHintLabel.Font = Enum.Font.Code
SkipHintLabel.TextTransparency = 0.4
SkipHintLabel.ZIndex = 11
SkipHintLabel.Parent = Background

local GlitchFrame = Instance.new("Frame")
GlitchFrame.Size = UDim2.new(1, 0, 1, 0)
GlitchFrame.BackgroundTransparency = 1
GlitchFrame.BorderSizePixel = 0
GlitchFrame.Parent = Background

local SkipButton = Instance.new("TextButton")
SkipButton.Size = UDim2.new(1, 0, 1, 0)
SkipButton.BackgroundTransparency = 1
SkipButton.Text = ""
SkipButton.ZIndex = 10
SkipButton.Parent = Background

local function createGlitchLine()
    if not GlitchFrame or not GlitchFrame.Parent then return end
    local line = Instance.new("Frame")
    line.Size = UDim2.new(1, 0, 0, math.random(5, 20))
    line.Position = UDim2.new(0, 0, math.random(0, 90)/100, 0)
    local colors = {Color3.fromRGB(255,0,0), Color3.fromRGB(0,255,0), Color3.fromRGB(0,0,255), Color3.fromRGB(255,0,255)}
    line.BackgroundColor3 = colors[math.random(1, #colors)]
    line.BorderSizePixel = 0
    line.Parent = GlitchFrame
    game:GetService("Debris"):AddItem(line, 0.1)
end

local isSkipped = false
local lastClick = 0

local function skipIntro()
    if isSkipped then return end
    isSkipped = true
    if ImageLabel then ImageLabel:Destroy() end
    if FlashFrame then FlashFrame:Destroy() end
    if TextLabel then TextLabel:Destroy() end
    if SkipHintLabel then SkipHintLabel:Destroy() end
    if GlitchFrame then GlitchFrame:Destroy() end
    if SkipButton then SkipButton:Destroy() end
    TweenService:Create(IntroSound, TweenInfo.new(0.5), {Volume = 0}):Play()
    TweenService:Create(Background, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
    task.wait(0.5)
    IntroSound:Stop()
    ScreenGui:Destroy()
end

SkipButton.MouseButton1Click:Connect(function()
    local currentTime = os.clock()
    if currentTime - lastClick < 0.4 then
        skipIntro()
    end
    lastClick = currentTime
end)

task.wait(1)
if isSkipped then return end

IntroSound:Play()

TweenService:Create(ImageLabel, TweenInfo.new(1), {ImageTransparency = 0}):Play()

local startTime = os.time()
local flashColors = {Color3.fromRGB(255,0,0), Color3.fromRGB(0,255,0), Color3.fromRGB(0,0,255), Color3.fromRGB(255,255,0), Color3.fromRGB(255,0,255), Color3.fromRGB(0,255,255)}

while os.time() - startTime < 6 and not isSkipped do
    if ImageLabel and ImageLabel.Parent then
        ImageLabel:TweenSize(UDim2.new(0, 230, 0, 230), "Out", "Quad", 0.15, true)
    end
    if FlashFrame and FlashFrame.Parent then
        FlashFrame.BackgroundColor3 = flashColors[math.random(1, #flashColors)]
        FlashFrame.BackgroundTransparency = 0.65
    end
    task.wait(0.1)
    if FlashFrame and FlashFrame.Parent then
        FlashFrame.BackgroundTransparency = 1
    end
    if ImageLabel and ImageLabel.Parent then
        ImageLabel:TweenSize(UDim2.new(0, 200, 0, 200), "In", "Quad", 0.15, true)
    end
    task.wait(0.4)
end

if isSkipped then return end

if ImageLabel then ImageLabel:Destroy() end
if FlashFrame then FlashFrame:Destroy() end

TweenService:Create(TextLabel, TweenInfo.new(0.5), {TextTransparency = 0}):Play()

local textWait = os.clock()
while os.clock() - textWait < 2 and not isSkipped do
    task.wait(0.1)
end

if isSkipped then return end

local glitchTime = os.time()
while os.time() - glitchTime < 2 and not isSkipped do
    createGlitchLine()
    if TextLabel and TextLabel.Parent then
        TextLabel.Position = UDim2.new(0, math.random(-10, 10), 0.5, math.random(-55, -45))
        TextLabel.TextColor3 = Color3.fromRGB(math.random(0,255), math.random(0,255), math.random(0,255))
    end
    task.wait(0.05)
end

if isSkipped then return end

if TextLabel then TextLabel:Destroy() end
if SkipHintLabel then SkipHintLabel:Destroy() end
if GlitchFrame then GlitchFrame:Destroy() end
if SkipButton then SkipButton:Destroy() end

Background.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
task.wait(0.5)

if isSkipped then return end

TweenService:Create(IntroSound, TweenInfo.new(1), {Volume = 0}):Play()
TweenService:Create(Background, TweenInfo.new(1), {BackgroundTransparency = 1}):Play()
task.wait(1)

IntroSound:Stop()
ScreenGui:Destroy()
