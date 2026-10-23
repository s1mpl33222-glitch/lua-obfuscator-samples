-- Create the ScreenGui
local CoreGui = game:GetService("CoreGui")
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "UpdateNoticeBox"
screenGui.IgnoreGuiInset = true -- Covers the top bar
screenGui.ResetOnSpawn = false

-- Protect the GUI 
local success, err = pcall(function()
    screenGui.Parent = CoreGui
end)
if not success then
    screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
end

-- Create the full-screen background frame
local background = Instance.new("Frame")
background.Name = "MainBackground"
background.Size = UDim2.new(1, 0, 1, 0) 
background.Position = UDim2.new(0, 0, 0, 0)
background.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
background.Active = true -- Blocks all clicks from passing through to the game
background.Parent = screenGui

-- Create the main warning text
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(0.6, 0, 0.2, 0)
titleLabel.Position = UDim2.new(0.2, 0, 0.25, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "This Script Is Outdated\nJoin our Discord for the new script."
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = background

-- Create the visible URL text
local urlLabel = Instance.new("TextLabel")
urlLabel.Name = "URLLabel"
urlLabel.Size = UDim2.new(0.6, 0, 0.08, 0)
urlLabel.Position = UDim2.new(0.2, 0, 0.5, 0)
urlLabel.BackgroundTransparency = 1
urlLabel.Text = "https://discord.gg/sourceshubs"
urlLabel.TextColor3 = Color3.fromRGB(170, 170, 170) 
urlLabel.TextScaled = true
urlLabel.Font = Enum.Font.Gotham
urlLabel.Parent = background

-- Create the Copy to Clipboard button
local joinButton = Instance.new("TextButton")
joinButton.Name = "JoinButton"
joinButton.Size = UDim2.new(0, 250, 0, 60)
joinButton.Position = UDim2.new(0.5, -125, 0.65, 0)
joinButton.BackgroundColor3 = Color3.fromRGB(88, 101, 242) 
joinButton.Text = "Copy Discord Link"
joinButton.TextColor3 = Color3.fromRGB(255, 255, 255)
joinButton.TextSize = 24
joinButton.Font = Enum.Font.GothamBold
joinButton.UICorner = Instance.new("UICorner", joinButton)
joinButton.UICorner.CornerRadius = UDim.new(0, 8)
joinButton.Parent = background

-- Clipboard copying functionality
joinButton.MouseButton1Click:Connect(function()
    if setclipboard then
        -- Copies the link to the user's clipboard
        setclipboard("https://discord.gg/sourceshubs")
        
        -- Visual feedback
        joinButton.Text = "Copied to Clipboard!"
        joinButton.BackgroundColor3 = Color3.fromRGB(45, 125, 70) 
        task.wait(2)
        joinButton.Text = "Copy Discord Link"
        joinButton.BackgroundColor3 = Color3.fromRGB(88, 101, 242) 
    else
        -- Fallback if their executor doesn't support clipboard copying
        joinButton.Text = "Type the link above!"
        joinButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50) 
        task.wait(2)
        joinButton.Text = "Copy Discord Link"
        joinButton.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
    end
end)
