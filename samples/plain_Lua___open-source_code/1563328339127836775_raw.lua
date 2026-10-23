-- Key-protected script loader (dark modern style GUI)
-- Key: 68170246I$6528
-- Loads on success: https://pastefy.app/z1SiCisw/raw

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ============= CONFIG =============
local CORRECT_KEY = "68170246I$6528"

local GET_KEY_LINK = "https://boostylink.com/43K2ybhh"                  
local DISCORD_LINK = "https://discord.gg/7tqF4sDReU"  

local function runMainScript()
    -- Automatically loads the new script on correct key
    loadstring(game:HttpGet("https://pastefy.app/z1SiCisw/raw"))()
end

-- ============= GUI Creation =============
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KeySystemGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = playerGui

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 360, 0, 240)
Frame.Position = UDim2.new(0.5, -180, 0.5, -120)
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 14)
Corner.Parent = Frame

local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(80, 140, 255)
Stroke.Thickness = 1.5
Stroke.Transparency = 0.4
Stroke.Parent = Frame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 50)
Title.BackgroundTransparency = 1
Title.Text = "Key System"
Title.TextColor3 = Color3.fromRGB(120, 180, 255)
Title.TextSize = 30
Title.Font = Enum.Font.GothamBold
Title.Parent = Frame

local Subtitle = Instance.new("TextLabel")
Subtitle.Size = UDim2.new(0.9, 0, 0, 30)
Subtitle.Position = UDim2.new(0.05, 0, 0.22, 0)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "Enter key to continue"
Subtitle.TextColor3 = Color3.fromRGB(180, 180, 200)
Subtitle.TextSize = 16
Subtitle.Font = Enum.Font.Gotham
Subtitle.Parent = Frame

local InputBox = Instance.new("TextBox")
InputBox.Size = UDim2.new(0.85, 0, 0, 45)
InputBox.Position = UDim2.new(0.075, 0, 0.35, 0)
InputBox.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
InputBox.TextColor3 = Color3.new(1,1,1)
InputBox.PlaceholderText = "Paste your key here..."
InputBox.Text = ""
InputBox.TextSize = 18
InputBox.Font = Enum.Font.Gotham
InputBox.ClearTextOnFocus = false
InputBox.Parent = Frame

local InputCorner = Instance.new("UICorner")
InputCorner.CornerRadius = UDim.new(0, 9)
InputCorner.Parent = InputBox

local SubmitBtn = Instance.new("TextButton")
SubmitBtn.Size = UDim2.new(0.4, 0, 0, 50)
SubmitBtn.Position = UDim2.new(0.075, 0, 0.58, 0)
SubmitBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
SubmitBtn.Text = "Submit"
SubmitBtn.TextColor3 = Color3.new(1,1,1)
SubmitBtn.TextSize = 20
SubmitBtn.Font = Enum.Font.GothamSemibold
SubmitBtn.Parent = Frame

local SubmitCorner = Instance.new("UICorner")
SubmitCorner.CornerRadius = UDim.new(0, 10)
SubmitCorner.Parent = SubmitBtn

local GetKeyBtn = Instance.new("TextButton")
GetKeyBtn.Size = UDim2.new(0.4, 0, 0, 50)
GetKeyBtn.Position = UDim2.new(0.525, 0, 0.58, 0)
GetKeyBtn.BackgroundColor3 = Color3.fromRGB(90, 90, 100)
GetKeyBtn.Text = "Get Key"
GetKeyBtn.TextColor3 = Color3.new(1,1,1)
GetKeyBtn.TextSize = 18
GetKeyBtn.Font = Enum.Font.Gotham
GetKeyBtn.Parent = Frame

local GetKeyCorner = Instance.new("UICorner")
GetKeyCorner.CornerRadius = UDim.new(0, 10)
GetKeyCorner.Parent = GetKeyBtn

local DiscordBtn = Instance.new("TextButton")
DiscordBtn.Size = UDim2.new(0.85, 0, 0, 40)
DiscordBtn.Position = UDim2.new(0.075, 0, 0.82, 0)
DiscordBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
DiscordBtn.Text = "Copy Discord Link"
DiscordBtn.TextColor3 = Color3.fromRGB(160, 160, 255)
DiscordBtn.TextSize = 16
DiscordBtn.Font = Enum.Font.Gotham
DiscordBtn.Parent = Frame

local DiscordCorner = Instance.new("UICorner")
DiscordCorner.CornerRadius = UDim.new(0, 9)
DiscordCorner.Parent = DiscordBtn

-- Hover effects
local function tweenBtn(btn, enter)
    local goal = enter and {BackgroundColor3 = btn.BackgroundColor3:Lerp(Color3.new(1,1,1), 0.15)} or {BackgroundColor3 = btn.BackgroundColor3}
    TweenService:Create(btn, TweenInfo.new(0.2), goal):Play()
end

for _, btn in {SubmitBtn, GetKeyBtn, DiscordBtn} do
    btn.MouseEnter:Connect(function() tweenBtn(btn, true) end)
    btn.MouseLeave:Connect(function() tweenBtn(btn, false) end)
end

-- Status helper
local function setStatus(text, color)
    Subtitle.Text = text
    Subtitle.TextColor3 = color or Color3.fromRGB(180, 180, 200)
end

-- Verify key function
local function verifyKey()
    local input = InputBox.Text
    if input == CORRECT_KEY then
        ScreenGui:Destroy()
        StarterGui:SetCore("SendNotification", {
            Title = "Access Granted",
            Text = "Loading script...",
            Duration = 4
        })
        runMainScript()  -- runs the new pastefy loadstring
    else
        setStatus("Invalid Key – Try Again", Color3.fromRGB(255, 90, 90))
        wait(2.5)
        setStatus("Enter key to continue")
    end
end

SubmitBtn.MouseButton1Click:Connect(verifyKey)
InputBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then verifyKey() end
end)

-- Get Key action
GetKeyBtn.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard(GET_KEY_LINK)
        StarterGui:SetCore("SendNotification", {Title = "Copied", Text = "Key link copied!", Duration = 4})
    else
        StarterGui:SetCore("SendNotification", {Title = "Get Key", Text = "Open: " .. GET_KEY_LINK, Duration = 6})
    end
end)

-- Discord copy
DiscordBtn.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard(DISCORD_LINK)
        StarterGui:SetCore("SendNotification", {Title = "Copied", Text = "Discord link copied!", Duration = 4})
    else
        StarterGui:SetCore("SendNotification", {Title = "Discord", Text = "Link: " .. DISCORD_LINK, Duration = 6})
    end
end)

-- Draggable frame
local dragToggle, dragStart, startPos
Frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragToggle = true
        dragStart = input.Position
        startPos = Frame.Position
    end
end)

Frame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragToggle = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragToggle and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)