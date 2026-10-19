-- deobf by prince https://discord.gg/TBBAUZu8cW
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local lp = Players.LocalPlayer
local activated = false
local keybind = Enum.KeyCode.E
local waitingForKey = false
local power = 79000
local lagAmount = 0.15
local lagConn = nil
local minimized = false
local closed = false

local function applyPower(val)
    power = math.clamp(val, 10000, 500000)
    local t = (power - 10000) / 490000
    lagAmount = t * 0.2
end
applyPower(power)

local function startLag()
    if lagConn then lagConn:Disconnect() end
    lagConn = RunService.RenderStepped:Connect(function()
        if not activated then return end
        if lagAmount > 0 then
            local t = tick()
            while tick() - t < lagAmount do end
        end
    end)
end

local function stopLag()
    activated = false
    if lagConn then
        lagConn:Disconnect()
        lagConn = nil
    end
end

local old = CoreGui:FindFirstChild("CzHubSpeedBypass")
if old then old:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "CryonVsSpeedBypass"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = CoreGui

local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.new(0, 280, 0, 0)
main.Position = UDim2.new(0.5, -140, 0.5, -125)
main.BackgroundColor3 = Color3.fromRGB(0, 3, 10)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.ClipsDescendants = true
main.Parent = gui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 13)
mainCorner.Parent = main

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(0, 70, 190)
mainStroke.Thickness = 2
mainStroke.Transparency = 0.05
mainStroke.Parent = main

-- Background image is intentionally visible through a light dark-red overlay.
local bgMask = Instance.new("Frame")
bgMask.Name = "BackgroundMask"
bgMask.Size = UDim2.new(1, -8, 1, -8)
bgMask.Position = UDim2.new(0, 4, 0, 4)
bgMask.BackgroundTransparency = 1
bgMask.BorderSizePixel = 0
bgMask.ClipsDescendants = true
bgMask.ZIndex = 1
bgMask.Parent = main

local bgMaskCorner = Instance.new("UICorner")
bgMaskCorner.CornerRadius = UDim.new(0, 9)
bgMaskCorner.Parent = bgMask

local bgImage = Instance.new("ImageLabel")
bgImage.Name = "BackgroundImage"
bgImage.Size = UDim2.fromScale(1, 1)
bgImage.Position = UDim2.fromScale(0, 0)
bgImage.BackgroundTransparency = 1
bgImage.BorderSizePixel = 0
bgImage.Image = "rbxassetid://97204072864657"
bgImage.ImageTransparency = 0.12
bgImage.ScaleType = Enum.ScaleType.Crop
bgImage.ZIndex = 1
bgImage.Parent = bgMask

local bgImageCorner = Instance.new("UICorner")
bgImageCorner.CornerRadius = UDim.new(0, 9)
bgImageCorner.Parent = bgImage

local blueOverlay = Instance.new("Frame")
blueOverlay.Name = "BlueOverlay"
blueOverlay.Size = UDim2.fromScale(1, 1)
blueOverlay.BackgroundColor3 = Color3.fromRGB(0, 12, 40)
blueOverlay.BackgroundTransparency = 0.72
blueOverlay.BorderSizePixel = 0
blueOverlay.ZIndex = 2
blueOverlay.Parent = main

local overlayCorner = Instance.new("UICorner")
overlayCorner.CornerRadius = UDim.new(0, 13)
overlayCorner.Parent = blueOverlay

local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 48)
header.BackgroundColor3 = Color3.fromRGB(0, 6, 20)
header.BackgroundTransparency = 0.18
header.BorderSizePixel = 0
header.ClipsDescendants = true
header.ZIndex = 5
header.Parent = main

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 13)
headerCorner.Parent = header

local headerLine = Instance.new("Frame")
headerLine.Size = UDim2.new(1, -20, 0, 1)
headerLine.Position = UDim2.new(0, 10, 1, -1)
headerLine.BackgroundColor3 = Color3.fromRGB(0, 85, 220)
headerLine.BackgroundTransparency = 0.25
headerLine.BorderSizePixel = 0
headerLine.ZIndex = 6
headerLine.Parent = header

local minBtn = Instance.new("TextButton")
minBtn.Name = "Minimize"
minBtn.Size = UDim2.new(0, 30, 0, 30)
minBtn.Position = UDim2.new(0, 8, 0, 9)
minBtn.BackgroundColor3 = Color3.fromRGB(0, 10, 32)
minBtn.BackgroundTransparency = 0.15
minBtn.BorderSizePixel = 0
minBtn.Text = "−"
minBtn.TextColor3 = Color3.fromRGB(45, 130, 255)
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 21
minBtn.ZIndex = 8
minBtn.Parent = header
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 8)

local closeBtn = Instance.new("TextButton")
closeBtn.Name = "Close"
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -38, 0, 9)
closeBtn.BackgroundColor3 = Color3.fromRGB(0, 28, 85)
closeBtn.BackgroundTransparency = 0.12
closeBtn.BorderSizePixel = 0
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(55, 145, 255)
closeBtn.Font = Enum.Font.GothamBlack
closeBtn.TextSize = 13
closeBtn.ZIndex = 8
closeBtn.Parent = header
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 8)

local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, -84, 0, 23)
title.Position = UDim2.new(0, 42, 0, 5)
title.BackgroundTransparency = 1
title.Text = "CRYON.VS SPEED BYPASS"
title.TextColor3 = Color3.fromRGB(45, 130, 255)
title.Font = Enum.Font.GothamBlack
title.TextSize = 13
title.TextXAlignment = Enum.TextXAlignment.Center
title.TextTruncate = Enum.TextTruncate.AtEnd
title.ZIndex = 7
title.Parent = header

local madeBy = Instance.new("TextLabel")
madeBy.Name = "MadeBy"
madeBy.Size = UDim2.new(1, -84, 0, 15)
madeBy.Position = UDim2.new(0, 42, 0, 26)
madeBy.BackgroundTransparency = 1
madeBy.Text = "Made by Cryon"
madeBy.TextColor3 = Color3.fromRGB(40, 105, 220)
madeBy.Font = Enum.Font.GothamMedium
madeBy.TextSize = 9
madeBy.TextXAlignment = Enum.TextXAlignment.Center
madeBy.ZIndex = 7
madeBy.Parent = header

local content = Instance.new("Frame")
content.Name = "Content"
content.Size = UDim2.new(1, -24, 1, -60)
content.Position = UDim2.new(0, 12, 0, 54)
content.BackgroundColor3 = Color3.fromRGB(0, 2, 8)
content.BackgroundTransparency = 0.34
content.BorderSizePixel = 0
content.ZIndex = 4
content.Parent = main
Instance.new("UICorner", content).CornerRadius = UDim.new(0, 10)

local contentStroke = Instance.new("UIStroke")
contentStroke.Color = Color3.fromRGB(0, 48, 135)
contentStroke.Thickness = 1
contentStroke.Transparency = 0.35
contentStroke.Parent = content

local toggleBtn = Instance.new("TextButton")
toggleBtn.Name = "Toggle"
toggleBtn.Size = UDim2.new(1, -20, 0, 38)
toggleBtn.Position = UDim2.new(0, 10, 0, 12)
toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 8, 26)
toggleBtn.BackgroundTransparency = 0.08
toggleBtn.BorderSizePixel = 0
toggleBtn.Text = "DISABLED"
toggleBtn.TextColor3 = Color3.fromRGB(60, 150, 255)
toggleBtn.Font = Enum.Font.GothamBlack
toggleBtn.TextSize = 15
toggleBtn.AutoButtonColor = false
toggleBtn.ZIndex = 6
toggleBtn.Parent = content
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 9)

local toggleStroke = Instance.new("UIStroke")
toggleStroke.Color = Color3.fromRGB(0, 48, 135)
toggleStroke.Thickness = 1
toggleStroke.Parent = toggleBtn

local bindLabel = Instance.new("TextLabel")
bindLabel.Size = UDim2.new(0, 92, 0, 26)
bindLabel.Position = UDim2.new(0, 12, 0, 61)
bindLabel.BackgroundTransparency = 1
bindLabel.Text = "Bind"
bindLabel.TextColor3 = Color3.fromRGB(55, 140, 245)
bindLabel.Font = Enum.Font.GothamBold
bindLabel.TextSize = 13
bindLabel.TextXAlignment = Enum.TextXAlignment.Left
bindLabel.ZIndex = 6
bindLabel.Parent = content

local bindBtn = Instance.new("TextButton")
bindBtn.Size = UDim2.new(0, 74, 0, 28)
bindBtn.Position = UDim2.new(1, -86, 0, 60)
bindBtn.BackgroundColor3 = Color3.fromRGB(0, 8, 26)
bindBtn.BackgroundTransparency = 0.08
bindBtn.BorderSizePixel = 0
bindBtn.Text = keybind.Name
bindBtn.TextColor3 = Color3.fromRGB(55, 145, 255)
bindBtn.Font = Enum.Font.GothamBlack
bindBtn.TextSize = 13
bindBtn.AutoButtonColor = false
bindBtn.ZIndex = 6
bindBtn.Parent = content
Instance.new("UICorner", bindBtn).CornerRadius = UDim.new(0, 8)

local powerLabel = Instance.new("TextLabel")
powerLabel.Size = UDim2.new(0, 140, 0, 28)
powerLabel.Position = UDim2.new(0, 12, 0, 98)
powerLabel.BackgroundTransparency = 1
powerLabel.Text = "Power (10k - 500k)"
powerLabel.TextColor3 = Color3.fromRGB(55, 140, 245)
powerLabel.Font = Enum.Font.GothamBold
powerLabel.TextSize = 12
powerLabel.TextXAlignment = Enum.TextXAlignment.Left
powerLabel.ZIndex = 6
powerLabel.Parent = content

local powerBox = Instance.new("TextBox")
powerBox.Size = UDim2.new(0, 96, 0, 30)
powerBox.Position = UDim2.new(1, -108, 0, 97)
powerBox.BackgroundColor3 = Color3.fromRGB(0, 8, 26)
powerBox.BackgroundTransparency = 0.08
powerBox.BorderSizePixel = 0
powerBox.Text = tostring(power)
powerBox.TextColor3 = Color3.fromRGB(60, 150, 255)
powerBox.Font = Enum.Font.GothamBlack
powerBox.TextSize = 13
powerBox.ClearTextOnFocus = false
powerBox.ZIndex = 6
powerBox.Parent = content
Instance.new("UICorner", powerBox).CornerRadius = UDim.new(0, 8)

local footer = Instance.new("TextLabel")
footer.Size = UDim2.new(1, -20, 0, 22)
footer.Position = UDim2.new(0, 10, 1, -32)
footer.BackgroundTransparency = 1
footer.Text = "discord.gg/n5dhp2Ewx"
footer.TextColor3 = Color3.fromRGB(40, 105, 220)
footer.Font = Enum.Font.GothamMedium
footer.TextSize = 10
footer.TextXAlignment = Enum.TextXAlignment.Center
footer.ZIndex = 6
footer.Parent = content

local function updateToggleVisual()
    if activated then
        toggleBtn.Text = "ENABLED"
        TweenService:Create(toggleBtn, TweenInfo.new(0.18), {
            BackgroundColor3 = Color3.fromRGB(0, 70, 190),
            TextColor3 = Color3.fromRGB(75, 165, 255)
        }):Play()
        TweenService:Create(toggleStroke, TweenInfo.new(0.18), {
            Color = Color3.fromRGB(30, 120, 255),
            Thickness = 2
        }):Play()
    else
        toggleBtn.Text = "DISABLED"
        TweenService:Create(toggleBtn, TweenInfo.new(0.18), {
            BackgroundColor3 = Color3.fromRGB(0, 8, 26),
            TextColor3 = Color3.fromRGB(60, 150, 255)
        }):Play()
        TweenService:Create(toggleStroke, TweenInfo.new(0.18), {
            Color = Color3.fromRGB(0, 48, 135),
            Thickness = 1
        }):Play()
    end
end

local function toggle()
    if activated then
        stopLag()
    else
        activated = true
        startLag()
    end
    updateToggleVisual()
end

toggleBtn.MouseButton1Click:Connect(toggle)

bindBtn.MouseButton1Click:Connect(function()
    waitingForKey = true
    bindBtn.Text = "..."
    bindBtn.TextColor3 = Color3.fromRGB(95, 180, 255)
end)

powerBox.FocusLost:Connect(function()
    local val = tonumber(powerBox.Text)
    if val then applyPower(val) end
    powerBox.Text = tostring(power)
end)

local expandedSize = UDim2.new(0, 280, 0, 238)
local minimizedSize = UDim2.new(0, 280, 0, 48)

local function toggleMinimize()
    minimized = not minimized
    content.Visible = not minimized
    bgMask.Visible = not minimized
    blueOverlay.Visible = not minimized
    madeBy.Visible = not minimized
    minBtn.Text = minimized and "+" or "−"

    TweenService:Create(main, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = minimized and minimizedSize or expandedSize
    }):Play()
end
minBtn.MouseButton1Click:Connect(toggleMinimize)

closeBtn.MouseButton1Click:Connect(function()
    if closed then return end
    closed = true
    stopLag()
    TweenService:Create(main, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 280, 0, 0),
        BackgroundTransparency = 1
    }):Play()
    task.wait(0.22)
    if gui.Parent then gui:Destroy() end
end)

-- Subtle red pulse for the title and outer border.
task.spawn(function()
    while gui.Parent and not closed do
        TweenService:Create(title, TweenInfo.new(0.65, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            TextColor3 = Color3.fromRGB(85, 170, 255)
        }):Play()
        TweenService:Create(mainStroke, TweenInfo.new(0.65, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            Color = Color3.fromRGB(25, 110, 255),
            Thickness = 3
        }):Play()
        task.wait(0.65)
        if not gui.Parent or closed then break end
        TweenService:Create(title, TweenInfo.new(0.65, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            TextColor3 = Color3.fromRGB(0, 85, 220)
        }):Play()
        TweenService:Create(mainStroke, TweenInfo.new(0.65, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            Color = Color3.fromRGB(0, 55, 155),
            Thickness = 2
        }):Play()
        task.wait(0.65)
    end
end)

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe or closed then return end

    if waitingForKey then
        if input.UserInputType == Enum.UserInputType.Keyboard then
            keybind = input.KeyCode
            bindBtn.Text = keybind.Name
            bindBtn.TextColor3 = Color3.fromRGB(55, 145, 255)
            waitingForKey = false
        end
        return
    end

    if input.KeyCode == keybind then
        toggle()
    end
end)

lp.CharacterAdded:Connect(function()
    task.wait(1)
    if activated and not closed then
        if lagConn then lagConn:Disconnect() end
        lagConn = nil
        startLag()
    end
end)

TweenService:Create(main, TweenInfo.new(0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
    Size = expandedSize
}):Play()