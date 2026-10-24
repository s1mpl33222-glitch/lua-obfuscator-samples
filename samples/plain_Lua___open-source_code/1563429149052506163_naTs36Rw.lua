local Players = game:GetService("Players")
local player = Players.LocalPlayer

local gui = Instance.new("ScreenGui")
gui.Name = "SantinoV1Maincheat"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 360, 0, 420)
frame.Position = UDim2.new(0.5, -180, 0.5, -210)
frame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
frame.BorderColor3 = Color3.fromRGB(255, 0, 0)
frame.BorderSizePixel = 2
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 55)
title.BackgroundTransparency = 1
title.Text = "Santino V1 MAINCHEAT"
title.TextColor3 = Color3.fromRGB(255, 255, 0)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = frame

local function createButton(name, description, position, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -24, 0, 85)
    button.Position = UDim2.new(0, 12, 0, position)
    button.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
    button.Text = name .. "\n" .. description
    button.TextColor3 = Color3.fromRGB(255, 255, 0)
    button.TextSize = 17
    button.Font = Enum.Font.GothamBold
    button.Parent = frame

    button.MouseButton1Click:Connect(callback)
    return button
end

createButton("SET SKY", "Sky bow down to Santino bitch", 65, function()
    local lighting = game:GetService("Lighting")

    lighting.ClockTime = 0
    lighting.Ambient = Color3.fromRGB(20, 20, 20)
    lighting.OutdoorAmbient = Color3.fromRGB(20, 20, 20)

    print("Sky bow down to Santino bitch")
end)

createButton("BRING ALL", "Teleport players (authorized server only)", 160, function()
    warn("Bring All requires an authorized server-side script.")
end)

createButton("CHAT ALL", "Under na kami ni Santino", 255, function()
    warn("Chat All requires an authorized server-side chat system.")
end)

local close = Instance.new("TextButton")
close.Size = UDim2.new(0, 35, 0, 35)
close.Position = UDim2.new(1, -40, 0, 10)
close.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
close.Text = "X"
close.TextColor3 = Color3.new(1, 1, 1)
close.TextScaled = true
close.Parent = frame

close.MouseButton1Click:Connect(function()
    gui:Destroy()
end)