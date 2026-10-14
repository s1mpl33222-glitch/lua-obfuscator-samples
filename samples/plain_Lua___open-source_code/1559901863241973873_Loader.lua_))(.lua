local CoreGui = game:GetService("CoreGui")

local LOADER = 'loadstring(game:HttpGet("https://www.zeroimpact.online/raw/loader"))()'

-- Prevent duplicate GUI
local existing = CoreGui:FindFirstChild("ZeroImpactLoaderUpdate")
if existing then
    existing:Destroy()
end

local gui = Instance.new("ScreenGui")
gui.Name = "ZeroImpactLoaderUpdate"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

pcall(function()
    gui.Parent = CoreGui
end)

if not gui.Parent then
    gui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
end

-- Main frame
local frame = Instance.new("Frame")
frame.Parent = gui
frame.Size = UDim2.fromOffset(420, 220)
frame.Position = UDim2.fromScale(0.5, 0.5)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
frame.BorderSizePixel = 0

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = frame

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(55, 55, 65)
stroke.Thickness = 1
stroke.Parent = frame

-- Title
local title = Instance.new("TextLabel")
title.Parent = frame
title.BackgroundTransparency = 1
title.Position = UDim2.fromOffset(24, 20)
title.Size = UDim2.new(1, -48, 0, 35)
title.Font = Enum.Font.GothamBold
title.Text = "NEW LOADER DETECTED"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 22
title.TextXAlignment = Enum.TextXAlignment.Left

-- Description
local description = Instance.new("TextLabel")
description.Parent = frame
description.BackgroundTransparency = 1
description.Position = UDim2.fromOffset(24, 62)
description.Size = UDim2.new(1, -48, 0, 55)
description.Font = Enum.Font.Gotham
description.Text = "A new loader is available. Copy it to your executor\nor continue to run it automatically."
description.TextColor3 = Color3.fromRGB(170, 170, 180)
description.TextSize = 14
description.TextWrapped = true
description.TextXAlignment = Enum.TextXAlignment.Left
description.TextYAlignment = Enum.TextYAlignment.Top

-- Copy button
local copyButton = Instance.new("TextButton")
copyButton.Parent = frame
copyButton.Size = UDim2.fromOffset(175, 45)
copyButton.Position = UDim2.new(0, 24, 1, -65)
copyButton.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
copyButton.BorderSizePixel = 0
copyButton.Font = Enum.Font.GothamBold
copyButton.Text = "COPY NEW LOADER"
copyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
copyButton.TextSize = 13

local copyCorner = Instance.new("UICorner")
copyCorner.CornerRadius = UDim.new(0, 8)
copyCorner.Parent = copyButton

-- Continue button
local continueButton = Instance.new("TextButton")
continueButton.Parent = frame
continueButton.Size = UDim2.fromOffset(175, 45)
continueButton.Position = UDim2.new(1, -199, 1, -65)
continueButton.BackgroundColor3 = Color3.fromRGB(70, 110, 255)
continueButton.BorderSizePixel = 0
continueButton.Font = Enum.Font.GothamBold
continueButton.Text = "CONTINUE"
continueButton.TextColor3 = Color3.fromRGB(255, 255, 255)
continueButton.TextSize = 13

local continueCorner = Instance.new("UICorner")
continueCorner.CornerRadius = UDim.new(0, 8)
continueCorner.Parent = continueButton

-- Copy
copyButton.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard(LOADER)

        copyButton.Text = "COPIED!"
        task.wait(1.5)
        copyButton.Text = "COPY NEW LOADER"
    end
end)

-- Continue
continueButton.MouseButton1Click:Connect(function()
    gui:Destroy()

    local success, err = pcall(function()
        loadstring(game:HttpGet(
            "https://www.zeroimpact.online/raw/loader"
        ))()
    end)

    if not success then
        warn("Failed to load new loader:", err)
    end
end)
