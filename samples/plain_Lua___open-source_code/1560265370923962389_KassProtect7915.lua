local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local gui = Instance.new("ScreenGui")
gui.Name = "KASS_Executing"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 270, 0, 100)
frame.Position = UDim2.new(0.5, -135, 0.5, -50)
frame.BackgroundColor3 = Color3.fromRGB(18, 12, 28)
frame.BorderSizePixel = 0
frame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = frame

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(145, 60, 255)
stroke.Thickness = 1.5
stroke.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -20, 1, -20)
title.Position = UDim2.new(0, 10, 0, 10)
title.BackgroundTransparency = 1
title.Text = "KASS PROTECT\nEstá executando..."
title.TextColor3 = Color3.fromRGB(230, 210, 255)
title.TextSize = 18
title.Font = Enum.Font.GothamBold
title.TextWrapped = true
title.Parent = frame

frame.BackgroundTransparency = 1
frame.Size = UDim2.new(0, 240, 0, 80)

TweenService:Create(
    frame,
    TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    {
        BackgroundTransparency = 0,
        Size = UDim2.new(0, 270, 0, 100)
    }
):Play()