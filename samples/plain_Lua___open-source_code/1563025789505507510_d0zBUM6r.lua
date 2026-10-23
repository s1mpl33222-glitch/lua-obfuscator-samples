-- Services
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer

-- Remove existing GUI if it already exists
if CoreGui:FindFirstChild("ScriptUpdateNotification") then
    CoreGui.ScriptUpdateNotification:Destroy()
end

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ScriptUpdateNotification"
screenGui.Parent = CoreGui
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Create Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Parent = screenGui
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -90)
mainFrame.Size = UDim2.new(0, 400, 0, 180)

-- Add Corner Radius
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 10)
uiCorner.Parent = mainFrame

-- Add Subtle Stroke/Border
local uiStroke = Instance.new("UIStroke")
uiStroke.Parent = mainFrame
uiStroke.Color = Color3.fromRGB(60, 60, 70)
uiStroke.Thickness = 1.5

-- Create Title Label
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Parent = mainFrame
titleLabel.BackgroundTransparency = 1
titleLabel.Position = UDim2.new(0, 20, 0, 15)
titleLabel.Size = UDim2.new(1, -60, 0, 30)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Text = "Notice: Script Updated"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 18
titleLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Create Close (X) Button
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Parent = mainFrame
closeButton.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
closeButton.BorderSizePixel = 0
closeButton.Position = UDim2.new(1, -40, 0, 15)
closeButton.Size = UDim2.new(0, 25, 0, 25)
closeButton.Font = Enum.Font.GothamBold
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(200, 200, 200)
closeButton.TextSize = 14

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeButton

-- Create Message Label
local messageLabel = Instance.new("TextLabel")
messageLabel.Name = "MessageLabel"
messageLabel.Parent = mainFrame
messageLabel.BackgroundTransparency = 1
messageLabel.Position = UDim2.new(0, 20, 0, 55)
messageLabel.Size = UDim2.new(1, -40, 0, 30)
messageLabel.Font = Enum.Font.Gotham
messageLabel.Text = "We updated our script! Click the button below to copy the new loadstring:"
messageLabel.TextColor3 = Color3.fromRGB(180, 180, 190)
messageLabel.TextSize = 13
messageLabel.TextWrapped = true
messageLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Create Copy Loadstring Button
local copyButton = Instance.new("TextButton")
copyButton.Name = "CopyButton"
copyButton.Parent = mainFrame
copyButton.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
copyButton.BorderSizePixel = 0
copyButton.Position = UDim2.new(0, 20, 0, 105)
copyButton.Size = UDim2.new(1, -40, 0, 45)
copyButton.Font = Enum.Font.Code
copyButton.Text = 'loadstring(game:HttpGet("https://pastefy.app/Lk0vDMmN/raw"))()'
copyButton.TextColor3 = Color3.fromRGB(0, 255, 150)
copyButton.TextSize = 11
copyButton.TextWrapped = true

local copyCorner = Instance.new("UICorner")
copyCorner.CornerRadius = UDim.new(0, 6)
copyCorner.Parent = copyButton

local copyStroke = Instance.new("UIStroke")
copyStroke.Parent = copyButton
copyStroke.Color = Color3.fromRGB(50, 50, 65)
copyStroke.Thickness = 1

-- Copy functionality on click
copyButton.MouseButton1Click:Connect(function()
    local targetText = 'loadstring(game:HttpGet("https://pastefy.app/Lk0vDMmN/raw"))()'
    
    if setclipboard then
        setclipboard(targetText)
        copyButton.Text = "Copied to Clipboard!"
        copyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        TweenService:Create(copyButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 180, 100)}):Play()
        
        task.wait(1.5)
        
        copyButton.Text = targetText
        copyButton.TextColor3 = Color3.fromRGB(0, 255, 150)
        TweenService:Create(copyButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 35, 45)}):Play()
    else
        copyButton.Text = "Executor does not support setclipboard!"
    end
end)

-- Close button functionality
closeButton.MouseButton1Click:Connect(function()
    local tween = TweenService:Create(mainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0)
    })
    tween:Play()
    tween.Completed:Connect(function()
        screenGui:Destroy()
    end)
end)

-- Hover effects
closeButton.MouseEnter:Connect(function()
    TweenService:Create(closeButton, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(220, 50, 50), TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
end)
closeButton.MouseLeave:Connect(function()
    TweenService:Create(closeButton, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(40, 40, 48), TextColor3 = Color3.fromRGB(200, 200, 200)}):Play()
end)

copyButton.MouseEnter:Connect(function()
    TweenService:Create(copyStroke, TweenInfo.new(0.1), {Color3 = Color3.fromRGB(0, 255, 150)}):Play()
end)
copyButton.MouseLeave:Connect(function()
    TweenService:Create(copyStroke, TweenInfo.new(0.1), {Color3 = Color3.fromRGB(50, 50, 65)}):Play()
end)
