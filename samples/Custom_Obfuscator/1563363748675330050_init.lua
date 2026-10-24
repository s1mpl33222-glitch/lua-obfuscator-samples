
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Verification"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")

local TextLabel = Instance.new("TextLabel")
TextLabel.Size = UDim2.new(0, 320, 0, 80)
TextLabel.Position = UDim2.new(0.5, -160, 0.5, -40)
TextLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.Font = Enum.Font.GothamBold
TextLabel.TextScaled = true
TextLabel.Text = "Security check in progress..."
TextLabel.Parent = ScreenGui
