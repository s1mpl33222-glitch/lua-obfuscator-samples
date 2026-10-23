-- Configuration
local keySystemTitle = "Key System"
local keyPrompt = "Enter your key to continue:"
local getKeyLink = "https://link-center.net/1417470/2BNSLNsklVIF"
local correctKey = "YOUR_KEY_HERE" -- Set this to your actual key

-- Services
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

-- Local Player
local p = Players.LocalPlayer

-- Create GUI
local g = Instance.new("ScreenGui")
g.Name = "KeySystem"
g.ResetOnSpawn = false
g.Parent = p:WaitForChild("PlayerGui")

-- Background
local bg = Instance.new("Frame")
bg.Size = UDim2.new(0, 400, 0, 300)
bg.Position = UDim2.new(0.5, -200, 0.5, -150)
bg.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
bg.BorderSizePixel = 0
bg.Parent = g

-- Rounded corners
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = bg

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 10)
title.BackgroundTransparency = 1
title.Text = keySystemTitle
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = bg

-- Prompt text
local prompt = Instance.new("TextLabel")
prompt.Size = UDim2.new(1, 0, 0, 30)
prompt.Position = UDim2.new(0, 0, 0.2, 0)
prompt.BackgroundTransparency = 1
prompt.Text = keyPrompt
prompt.TextColor3 = Color3.fromRGB(200, 200, 200)
prompt.TextScaled = true
prompt.Font = Enum.Font.Gotham
prompt.Parent = bg

-- TextBox for key
local textBox = Instance.new("TextBox")
textBox.Size = UDim2.new(0.8, 0, 0, 35)
textBox.Position = UDim2.new(0.1, 0, 0.35, 0)
textBox.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
textBox.Text = ""
textBox.PlaceholderText = "Enter key here..."
textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
textBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
textBox.TextScaled = true
textBox.Font = Enum.Font.Gotham
textBox.Parent = bg

local textBoxCorner = Instance.new("UICorner")
textBoxCorner.CornerRadius = UDim.new(0, 6)
textBoxCorner.Parent = textBox

-- Confirm Key Button
local confirmBtn = Instance.new("TextButton")
confirmBtn.Size = UDim2.new(0.35, 0, 0, 35)
confirmBtn.Position = UDim2.new(0.1, 0, 0.55, 0)
confirmBtn.BackgroundColor3 = Color3.fromRGB(50, 180, 80)
confirmBtn.Text = "Confirm Key"
confirmBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
confirmBtn.TextScaled = true
confirmBtn.Font = Enum.Font.GothamBold
confirmBtn.Parent = bg

local confirmCorner = Instance.new("UICorner")
confirmCorner.CornerRadius = UDim.new(0, 6)
confirmCorner.Parent = confirmBtn

-- Get Key Button
local getKeyBtn = Instance.new("TextButton")
getKeyBtn.Size = UDim2.new(0.35, 0, 0, 35)
getKeyBtn.Position = UDim2.new(0.55, 0, 0.55, 0)
getKeyBtn.BackgroundColor3 = Color3.fromRGB(200, 100, 50)
getKeyBtn.Text = "Get Key"
getKeyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
getKeyBtn.TextScaled = true
getKeyBtn.Font = Enum.Font.GothamBold
getKeyBtn.Parent = bg

local getKeyCorner = Instance.new("UICorner")
getKeyCorner.CornerRadius = UDim.new(0, 6)
getKeyCorner.Parent = getKeyBtn

-- Status label
local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, 0, 0, 25)
status.Position = UDim2.new(0, 0, 0.75, 0)
status.BackgroundTransparency = 1
status.Text = ""
status.TextColor3 = Color3.fromRGB(255, 255, 255)
status.TextScaled = true
status.Font = Enum.Font.Gotham
status.Parent = bg

-- Get Key button functionality
getKeyBtn.MouseButton1Click:Connect(function()
    -- Open the link in browser
    local success = syn and syn.request or http_request
    if success then
        -- Try to open link (for executor environments)
        setclipboard(getKeyLink)
        status.Text = "Link copied! Open your browser."
        status.TextColor3 = Color3.fromRGB(255, 255, 100)
    else
        -- Fallback: just copy to clipboard
        setclipboard(getKeyLink)
        status.Text = "Link copied to clipboard!"
        status.TextColor3 = Color3.fromRGB(255, 255, 100)
    end
    
    -- Also try to open in browser
    local url = getKeyLink
    if syn then
        syn.request({
            Url = url,
            Method = "GET"
        })
    end
    
    task.wait(2)
    status.Text = ""
end)

-- Confirm Key functionality
confirmBtn.MouseButton1Click:Connect(function()
    local enteredKey = textBox.Text
    
    if enteredKey == correctKey then
        -- Correct key - remove GUI
        status.Text = "✅ Key accepted!"
        status.TextColor3 = Color3.fromRGB(100, 255, 100)
        task.wait(1)
        g:Destroy()
        print("Key accepted! Script loaded.")
        -- Add your main script here
    else
        -- Wrong key
        status.Text = "❌ Invalid key!"
        status.TextColor3 = Color3.fromRGB(255, 100, 100)
        textBox.Text = ""
    end
end)

-- Also allow Enter key to confirm
textBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        confirmBtn.MouseButton1Click:Fire()
    end
end)
