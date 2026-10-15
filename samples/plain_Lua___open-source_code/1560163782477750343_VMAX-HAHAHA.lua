-- RENZ HUB VMAX FINAL - WITH ANTI-CHASE BUTTON - LOGO 85660407447010
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ProximityPromptService = game:GetService("ProximityPromptService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- INTRO
local introGui = Instance.new("ScreenGui")
introGui.Name = "RenzHubIntro"
introGui.IgnoreGuiInset = true
introGui.ResetOnSpawn = false
introGui.DisplayOrder = 999
introGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local bgFrame = Instance.new("Frame")
bgFrame.Size = UDim2.new(1, 0, 1, 0)
bgFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
bgFrame.BackgroundTransparency = 1
bgFrame.Parent = introGui

local logoImage = Instance.new("ImageLabel")
logoImage.Size = UDim2.new(1, 0, 1, 0)
logoImage.Position = UDim2.new(0.5, 0, 0.5, 0)
logoImage.AnchorPoint = Vector2.new(0.5, 0.5)
logoImage.BackgroundTransparency = 1
logoImage.Image = "rbxassetid://85660407447010"
logoImage.ImageTransparency = 1
logoImage.ScaleType = Enum.ScaleType.Fit
logoImage.Parent = bgFrame

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(0, 600, 0, 70)
titleText.Position = UDim2.new(0.5, 0, 0.65, 0)
titleText.AnchorPoint = Vector2.new(0.5, 0.5)
titleText.BackgroundTransparency = 1
titleText.Text = "RENZ HUB | ANTI-HIT"
titleText.TextColor3 = Color3.fromRGB(255, 204, 0)
titleText.Font = Enum.Font.GothamBold
titleText.TextScaled = true
titleText.TextTransparency = 1
titleText.Parent = bgFrame

local subText = Instance.new("TextLabel")
subText.Size = UDim2.new(0, 350, 0, 35)
subText.Position = UDim2.new(0.5, 0, 0.71, 0)
subText.AnchorPoint = Vector2.new(0.5, 0.5)
subText.BackgroundTransparency = 1
subText.Text = "[ RENZ HUB ]"
subText.TextColor3 = Color3.fromRGB(255, 255, 255)
subText.Font = Enum.Font.GothamBold
subText.TextScaled = true
subText.TextTransparency = 1
subText.Parent = bgFrame

local function createTween(obj, time, props)
    local t = TweenService:Create(obj, TweenInfo.new(time, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props)
    t:Play() return t
end

createTween(bgFrame, 0.5, {BackgroundTransparency = 0})
task.wait(0.5)
createTween(logoImage, 1.5, {ImageTransparency = 0})
createTween(titleText, 1.5, {TextTransparency = 0})
createTween(subText, 1.5, {TextTransparency = 0})
task.wait(3.5)
createTween(bgFrame, 1, {BackgroundTransparency = 1})
createTween(logoImage, 1, {ImageTransparency = 1})
createTween(titleText, 1, {TextTransparency = 1})
createTween(subText, 1, {TextTransparency = 1})
task.wait(1)
introGui:Destroy()

-- MAIN HUB WITH BUTTON
if LocalPlayer.PlayerGui:FindFirstChild("RenzHubFinal") then LocalPlayer.PlayerGui:FindFirstChild("RenzHubFinal"):Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "RenzHubFinal"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local function makeDraggable(frame, handle)
    handle = handle or frame
    local dragging, dragInput, dragStart, startPos
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)
    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function() dragging = false end)
end

-- BEE BUTTON
local beeLeft = Instance.new("ImageButton")
beeLeft.Size = UDim2.new(0,80,0,80)
beeLeft.Position = UDim2.new(0,15,0.48,0)
beeLeft.BackgroundColor3 = Color3.fromRGB(10,10,10)
beeLeft.BorderSizePixel = 0
beeLeft.Parent = gui
Instance.new("UICorner",beeLeft).CornerRadius = UDim.new(0,18)
local s = Instance.new("UIStroke",beeLeft) s.Color = Color3.fromRGB(255,204,0) s.Thickness = 2
local icon = Instance.new("TextLabel")
icon.Size = UDim2.new(1,0,1,0)
icon.BackgroundTransparency = 1
icon.Text = "RENZ V1"
icon.TextScaled = true
icon.Parent = beeLeft
makeDraggable(beeLeft)

-- PANEL
local panel = Instance.new("Frame")
panel.Size = UDim2.new(0,380,0,200)
panel.Position = UDim2.new(1,-20,0,70)
panel.AnchorPoint = Vector2.new(1,0)
panel.BackgroundColor3 = Color3.fromRGB(10,10,20)
panel.BorderSizePixel = 0
panel.Parent = gui
Instance.new("UICorner",panel).CornerRadius = UDim.new(0,16)
local ps = Instance.new("UIStroke",panel) ps.Color = Color3.fromRGB(255,210,70) ps.Thickness = 2

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1,0,0,40)
titleBar.BackgroundTransparency = 1
titleBar.Parent = panel
local title2 = Instance.new("TextLabel")
title2.Size = UDim2.new(1,-80,1,0)
title2.Position = UDim2.new(0,10,0,0)
title2.BackgroundTransparency = 1
title2.Text = "RENZ HUB | VMAX"
title2.TextColor3 = Color3.fromRGB(255,220,80)
title2.Font = Enum.Font.GothamBold
title2.TextSize = 14
title2.TextXAlignment = Enum.TextXAlignment.Left
title2.Parent = titleBar
makeDraggable(panel, titleBar)

local btnExit = Instance.new("TextButton")
btnExit.Size = UDim2.new(0,30,0,30)
btnExit.Position = UDim2.new(1,-35,0,5)
btnExit.BackgroundColor3 = Color3.fromRGB(255,60,60)
btnExit.Text = "X"
btnExit.TextColor3 = Color3.fromRGB(255,255,255)
btnExit.Font = Enum.Font.GothamBold
btnExit.TextSize = 16
btnExit.Parent = titleBar
Instance.new("UICorner",btnExit).CornerRadius = UDim.new(0,8)

local btnMin = Instance.new("TextButton")
btnMin.Size = UDim2.new(0,30,0,30)
btnMin.Position = UDim2.new(1,-70,0,5)
btnMin.BackgroundColor3 = Color3.fromRGB(60,60,60)
btnMin.Text = "-"
btnMin.TextColor3 = Color3.fromRGB(255,255,255)
btnMin.Font = Enum.Font.GothamBold
btnMin.TextSize = 18
btnMin.Parent = titleBar
Instance.new("UICorner",btnMin).CornerRadius = UDim.new(0,8)

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1,-20,0,25)
status.Position = UDim2.new(0,10,0,45)
status.BackgroundTransparency = 1
status.Text = "ANTI-CHASE: ON ✅"
status.TextColor3 = Color3.fromRGB(255,220,80)
status.Font = Enum.Font.GothamBold
status.TextSize = 14
status.Parent = panel

-- TOGGLE ANTI-CHASE BUTTON
local btnAnti = Instance.new("TextButton")
btnAnti.Size = UDim2.new(1,-20,0,50)
btnAnti.Position = UDim2.new(0,10,0,75)
btnAnti.BackgroundColor3 = Color3.fromRGB(0, 200, 80)
btnAnti.Text = "ANTI-CHASE: ON - TAP TO OFF"
btnAnti.TextColor3 = Color3.fromRGB(255,255,255)
btnAnti.Font = Enum.Font.GothamBold
btnAnti.TextSize = 13
btnAnti.Parent = panel
Instance.new("UICorner",btnAnti).CornerRadius = UDim.new(0,10)

-- INSTANT STEAL STATUS
local btnSteal = Instance.new("TextButton")
btnSteal.Size = UDim2.new(1,-20,0,40)
btnSteal.Position = UDim2.new(0,10,0,135)
btnSteal.BackgroundColor3 = Color3.fromRGB(30,30,30)
btnSteal.Text = "INSTANT STEAL: ON ✅"
btnSteal.TextColor3 = Color3.fromRGB(255,204,0)
btnSteal.Font = Enum.Font.GothamBold
btnSteal.TextSize = 12
btnSteal.Parent = panel
Instance.new("UICorner",btnSteal).CornerRadius = UDim.new(0,10)

local btnToggle = Instance.new("TextButton")
btnToggle.Size = UDim2.new(1,-20,0,25)
btnToggle.Position = UDim2.new(0,10,0,180)
btnToggle.BackgroundColor3 = Color3.fromRGB(255,204,0)
btnToggle.Text = "PANEL VISIBLE"
btnToggle.TextColor3 = Color3.fromRGB(0,0,0)
btnToggle.Font = Enum.Font.GothamBold
btnToggle.TextSize = 11
btnToggle.Parent = panel
Instance.new("UICorner",btnToggle).CornerRadius = UDim.new(0,8)

-- LOGIC
local AntiChaseEnabled = true
local panelVisible = true

local function getAntiChaseState() return AntiChaseEnabled end

local updateInstancePropertiesData = {
    Vector3.new(500.62, 70.28, -366.71),
    Vector3.new(508.3, 70.28, -366.02),
    Vector3.new(519.43, 70.28, -366.47),
    Vector3.new(529.22, 70.28, -366.71),
    Vector3.new(546.8, 70.28, -364.4),
}
local flag = false
local function updateInstanceProperties(character)
    if not getAntiChaseState() then return end
    if not character or not character.Parent then return end
    for index, item in ipairs(updateInstancePropertiesData) do
        if not getAntiChaseState() then return end
        character:PivotTo(CFrame.new(item))
        if index < #updateInstancePropertiesData then RunService.Heartbeat:Wait() end
    end
end

btnAnti.MouseButton1Click:Connect(function()
    AntiChaseEnabled = not AntiChaseEnabled
    if AntiChaseEnabled then
        btnAnti.BackgroundColor3 = Color3.fromRGB(0, 200, 80)
        btnAnti.Text = "ANTI-CHASE: ON - TAP TO OFF"
        status.Text = "ANTI-CHASE: ON ✅"
    else
        btnAnti.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        btnAnti.Text = "ANTI-CHASE: OFF - TAP TO ON"
        status.Text = "ANTI-CHASE: OFF ❌"
    end
end)

ProximityPromptService.PromptTriggered:Connect(function(prompt, player)
    if player ~= LocalPlayer then return end
    if not getAntiChaseState() or flag then return end
    local character = LocalPlayer.Character
    if not character then return end
    flag = true
    updateInstanceProperties(character)
    flag = false
end)

btnExit.MouseButton1Click:Connect(function() panel.Visible = false panelVisible = false btnToggle.Text = "PANEL HIDDEN - TAP BEE" end)
btnMin.MouseButton1Click:Connect(function() panel.Visible = false panelVisible = false btnToggle.Text = "PANEL HIDDEN - TAP BEE" end)
beeLeft.MouseButton1Click:Connect(function()
    panelVisible = not panelVisible
    panel.Visible = panelVisible
    btnToggle.Text = panelVisible and "PANEL VISIBLE" or "PANEL HIDDEN - TAP BEE"
end)
btnToggle.MouseButton1Click:Connect(function()
    panelVisible = not panelVisible
    panel.Visible = panelVisible
    btnToggle.Text = panelVisible and "PANEL VISIBLE" or "PANEL HIDDEN"
end)

-- INSTANT PROMPT
for _, desc in ipairs(Workspace:GetDescendants()) do
    if desc:IsA("ProximityPrompt") then
        desc.HoldDuration = 0
        desc.RequiresLineOfSight = false
    end
end
Workspace.DescendantAdded:Connect(function(v)
    if v:IsA("ProximityPrompt") then
        v.HoldDuration = 0
        v.RequiresLineOfSight = false
    end
end)

print("RENZ HUB VMAX WITH BUTTON LOADED - LOGO 85660407447010")
