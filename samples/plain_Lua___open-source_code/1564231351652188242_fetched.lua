local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

local DISCORD_LINK = "https://discord.gg/e52GujVvbN"

local gui = Instance.new("ScreenGui")
gui.Name = "DeprecatedNotice"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 999999999
gui.Parent = (gethui and gethui()) or CoreGui

local overlay = Instance.new("Frame")
overlay.Name = "Overlay"
overlay.Size = UDim2.new(1, 0, 1, 0)
overlay.Position = UDim2.new(0, 0, 0, 0)
overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
overlay.BorderSizePixel = 0
overlay.ZIndex = 1
overlay.Parent = gui

local container = Instance.new("Frame")
container.Name = "Container"
container.AnchorPoint = Vector2.new(0.5, 0.5)
container.Position = UDim2.new(0.5, 0, 0.5, 0)
container.Size = UDim2.new(0, 380, 0, 220)
container.BackgroundTransparency = 1
container.ZIndex = 2
container.Parent = overlay

local uiScale = Instance.new("UIScale")
uiScale.Scale = 1
uiScale.Parent = container

local function updateScale()
    local viewport = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize
    if not viewport then return end
    local scaleFactor = math.min(viewport.X / 460, viewport.Y / 340, 1.1)
    scaleFactor = math.max(scaleFactor, 0.55)
    uiScale.Scale = scaleFactor
end

updateScale()
workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateScale)

local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, 0, 0, 26)
title.Position = UDim2.new(0.5, 0, 0, 6)
title.AnchorPoint = Vector2.new(0.5, 0)
title.BackgroundTransparency = 1
title.Text = "SCRIPT DISCONTINUED"
title.TextColor3 = Color3.fromRGB(235, 235, 235)
title.TextSize = 16
title.Font = Enum.Font.GothamMedium
title.TextWrapped = true
title.ZIndex = 2
title.Parent = container

local subtitle = Instance.new("TextLabel")
subtitle.Name = "Subtitle"
subtitle.Size = UDim2.new(1, -30, 0, 44)
subtitle.Position = UDim2.new(0.5, 0, 0, 40)
subtitle.AnchorPoint = Vector2.new(0.5, 0)
subtitle.BackgroundTransparency = 1
subtitle.Text = "This version is no longer supported. Join the Discord server to get the current release."
subtitle.TextColor3 = Color3.fromRGB(140, 140, 140)
subtitle.TextSize = 13
subtitle.Font = Enum.Font.Gotham
subtitle.TextWrapped = true
subtitle.ZIndex = 2
subtitle.Parent = container

local button = Instance.new("TextButton")
button.Name = "CopyButton"
button.Size = UDim2.new(1, 0, 0, 42)
button.Position = UDim2.new(0.5, 0, 0, 102)
button.AnchorPoint = Vector2.new(0.5, 0)
button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
button.Text = "Join Discord Server"
button.TextColor3 = Color3.fromRGB(0, 0, 0)
button.TextSize = 14
button.Font = Enum.Font.GothamMedium
button.AutoButtonColor = false
button.ZIndex = 2
button.Parent = container

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(1, 0)
buttonCorner.Parent = button

local hint = Instance.new("TextLabel")
hint.Name = "Hint"
hint.Size = UDim2.new(1, 0, 0, 16)
hint.Position = UDim2.new(0.5, 0, 0, 156)
hint.AnchorPoint = Vector2.new(0.5, 0)
hint.BackgroundTransparency = 1
hint.Text = "Tap to copy invite link"
hint.TextColor3 = Color3.fromRGB(90, 90, 90)
hint.TextSize = 11
hint.Font = Enum.Font.Gotham
hint.ZIndex = 2
hint.Parent = container

local resetting = false

local function copyLink()
    local ok = pcall(function()
        if setclipboard then
            setclipboard(DISCORD_LINK)
        elseif toclipboard then
            toclipboard(DISCORD_LINK)
        end
    end)

    button.Text = "Copied"
    hint.Text = ok and DISCORD_LINK or ("Copy failed — " .. DISCORD_LINK)

    if resetting then return end
    resetting = true
    task.delay(2.2, function()
        button.Text = "Join Discord Server"
        hint.Text = "Tap to copy invite link"
        resetting = false
    end)
end

button.MouseButton1Click:Connect(copyLink)
button.MouseEnter:Connect(function()
    button.BackgroundColor3 = Color3.fromRGB(225, 225, 225)
end)
button.MouseLeave:Connect(function()
    button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
end)

UserInputService.MouseIconEnabled = true
UserInputService.MouseBehavior = Enum.MouseBehavior.Default