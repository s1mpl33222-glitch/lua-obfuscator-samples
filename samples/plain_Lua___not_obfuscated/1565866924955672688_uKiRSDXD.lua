-------------------------------------------------
-- SERVICES
-------------------------------------------------
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-------------------------------------------------
-- SETTINGS
-------------------------------------------------
local PULL_ENABLED = true
local magnetSmoothness = 0.15 
local pullRadius = 100 
local snapSpeed = 1.0

local MIN_SMOOTHNESS, MAX_SMOOTHNESS = 0.001, 3
local MIN_RADIUS, MAX_RADIUS = 5, 500
local MIN_SNAP, MAX_SNAP = 0.001, 15

--[ ALL BLACK / SILVER COLOR SCHEME ]------------
local MAIN_BG_COLOR = Color3.fromRGB(0, 0, 0) -- Set to pure black to match the image backgrounds perfectly
local HEADER_BG_COLOR = Color3.fromRGB(0, 0, 0) 
local ACCENT_COLOR = Color3.fromRGB(255, 255, 255) 
local TOGGLE_OFF_COLOR = Color3.fromRGB(20, 20, 20) 
local TEXT_COLOR = Color3.fromRGB(240, 240, 240) 
local INPUT_BOX_COLOR = Color3.fromRGB(15, 15, 15) 
local BORDER_COLOR = Color3.fromRGB(50, 50, 50) 

local ASSET_URL = "rbxthumb://type=Asset&id=14353089782&w=150&h=150"

-------------------------------------------------
-- BALL LOGIC
-------------------------------------------------
local cachedBall = nil
local lastSearchTime = 0

local function getFootball()
    if cachedBall and cachedBall.Parent then return cachedBall end
    
    local currentTime = os.clock()
    if currentTime - lastSearchTime < 0.5 then return nil end
    lastSearchTime = currentTime

    for _, obj in ipairs(Workspace:GetChildren()) do
        if obj:IsA("BasePart") and obj.Name == "Football" then
            cachedBall = obj
            return cachedBall
        end
    end
    
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name == "Football" then
            cachedBall = obj
            return cachedBall
        end
    end
end

local raycastParams = RaycastParams.new()
raycastParams.FilterType = Enum.RaycastFilterType.Exclude

local function isBallInAir(ball)
    if not ball then return false end
    if ball.AssemblyLinearVelocity.Magnitude <= 8 then return false end

    local char = LocalPlayer.Character
    raycastParams.FilterDescendantsInstances = {ball, char}
    local rayResult = Workspace:Raycast(ball.Position, Vector3.new(0, -4, 0), raycastParams)
    return rayResult == nil
end

-------------------------------------------------
-- CORE PULL LOOP
-------------------------------------------------
local isPulling = false
local Vector3Zero = Vector3.zero
local UpVectorOffset = Vector3.new(0, 2.8, 0)

RunService.RenderStepped:Connect(function(dt)
    if not PULL_ENABLED or not isPulling then return end
    
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local ball = getFootball()
    if not hrp or not ball then return end

    local ballPos = ball.Position
    local hrpPos = hrp.Position
    
    if (ballPos - hrpPos).Magnitude > pullRadius then return end
    if not isBallInAir(ball) then return end

    local velocity = ball.AssemblyLinearVelocity
    local predict = (velocity.Magnitude > 0) and (velocity.Unit * (12 + snapSpeed * 1.5)) or Vector3Zero
    local targetPos = ballPos + predict + UpVectorOffset

    if (targetPos - hrpPos).Magnitude < 0.4 then return end

    local power = math.clamp(snapSpeed, 0.001, 15)
    local smooth = math.clamp(magnetSmoothness, 0.001, 3)

    local strength = (power * 18) * (0.35 + smooth)
    local alpha = 1 - math.exp(-strength * dt)
    alpha = math.clamp(alpha, 0.002, 0.9)

    local newPos = hrpPos:Lerp(targetPos, alpha)
    hrp.CFrame = CFrame.new(newPos) * (hrp.CFrame - hrp.CFrame.Position)
end)

-------------------------------------------------
-- GUI SETUP
-------------------------------------------------
local mainGui = Instance.new("ScreenGui")
mainGui.Name = "jzwt hands pv"
mainGui.ResetOnSpawn = false
mainGui.IgnoreGuiInset = true
mainGui.DisplayOrder = 50
mainGui.Parent = PlayerGui
mainGui.Enabled = false

-- The main background frame (250 x 370)
local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(10, 10) 
frame.Position = UDim2.fromScale(0.1, 0.1)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundColor3 = MAIN_BG_COLOR
frame.BorderSizePixel = 0
frame.Parent = mainGui

local borderStroke = Instance.new("UIStroke")
borderStroke.Color = BORDER_COLOR
borderStroke.Thickness = 2
borderStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
borderStroke.Parent = frame
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

-------------------------------------------------
-- CORNER IMAGES 
-------------------------------------------------
local topLeftEmblem = Instance.new("ImageLabel")
topLeftEmblem.Name = "TopLeftEmblem"
topLeftEmblem.Size = UDim2.fromOffset(35, 35)
topLeftEmblem.Position = UDim2.new(0, 8, 0, 8) 
topLeftEmblem.AnchorPoint = Vector2.new(0, 0)
topLeftEmblem.BackgroundTransparency = 1
topLeftEmblem.Image = ASSET_URL
topLeftEmblem.ScaleType = Enum.ScaleType.Fit
topLeftEmblem.ZIndex = 10
topLeftEmblem.Parent = frame

local bottomRightEmblem = Instance.new("ImageLabel")
bottomRightEmblem.Name = "BottomRightEmblem"
bottomRightEmblem.Size = UDim2.fromOffset(35, 35)
bottomRightEmblem.Position = UDim2.new(1, -8, 1, -8) 
bottomRightEmblem.AnchorPoint = Vector2.new(1, 1)
bottomRightEmblem.BackgroundTransparency = 1
bottomRightEmblem.Image = ASSET_URL
bottomRightEmblem.ScaleType = Enum.ScaleType.Fit
bottomRightEmblem.ZIndex = 10
bottomRightEmblem.Parent = frame

-------------------------------------------------
-- CONTENT LAYOUT
-------------------------------------------------
local header = Instance.new("TextLabel")
header.Size = UDim2.new(1, 0, 0, 30)
header.Position = UDim2.new(0, 0, 0, 20) -- Moved up since the center image is removed
header.BackgroundColor3 = HEADER_BG_COLOR
header.BackgroundTransparency = 1
header.Text = "JZWT HANDS PV"
header.TextColor3 = ACCENT_COLOR
header.Font = Enum.Font.GothamBold
header.TextSize = 16
header.Parent = frame

local container = Instance.new("Frame")
container.Size = UDim2.new(1, -20, 1, -65)
container.Position = UDim2.fromOffset(10, 55) -- Moved up to close the gap
container.BackgroundTransparency = 1
container.Parent = frame

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 8)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.SortOrder = Enum.SortOrder.LayoutOrder 
layout.Parent = container

local function createToggle(name, state, orderIndex)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.BackgroundColor3 = state and ACCENT_COLOR or TOGGLE_OFF_COLOR
    btn.Text = name .. ": " .. (state and "ON" or "OFF")
    btn.TextColor3 = state and Color3.fromRGB(0, 0, 0) or TEXT_COLOR
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 14
    btn.LayoutOrder = orderIndex
    btn.Parent = container
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    local stroke = Instance.new("UIStroke", btn)
    stroke.Color = state and ACCENT_COLOR or BORDER_COLOR
    stroke.Thickness = 1
    return btn
end

local function createInput(labelName, defaultVal, orderIndex)
    local group = Instance.new("Frame")
    group.Size = UDim2.new(1, 0, 0, 55)
    group.BackgroundTransparency = 1
    group.LayoutOrder = orderIndex
    group.Parent = container

    local lab = Instance.new("TextLabel")
    lab.Size = UDim2.new(1, 0, 0, 15)
    lab.Position = UDim2.new(0, 0, 0, 0)
    lab.BackgroundTransparency = 1
    lab.Text = labelName
    lab.TextColor3 = Color3.fromRGB(160, 160, 160)
    lab.Font = Enum.Font.Gotham
    lab.TextSize = 12
    lab.TextXAlignment = Enum.TextXAlignment.Left
    lab.Parent = group

    local box = Instance.new("TextBox")
    box.Size = UDim2.new(1, 0, 0, 35)
    box.Position = UDim2.new(0, 0, 0, 20)
    box.BackgroundColor3 = INPUT_BOX_COLOR
    box.Text = tostring(defaultVal)
    box.TextColor3 = TEXT_COLOR
    box.Font = Enum.Font.GothamMedium
    box.TextSize = 14
    box.Parent = group
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 8)
    Instance.new("UIStroke", box).Color = BORDER_COLOR

    return box
end

local pullToggle = createToggle("Vector Pull", PULL_ENABLED, 1)
local smoothInput = createInput("Smoothness (0.001 - 3)", magnetSmoothness, 2)
local snapInput = createInput("Ball Snap (0.001 - 15)", snapSpeed, 3)
local radiusInput = createInput("Max Radius (Studs)", pullRadius, 4)

-------------------------------------------------
-- UI LOGIC
-------------------------------------------------
pullToggle.MouseButton1Click:Connect(function()
    PULL_ENABLED = not PULL_ENABLED
    pullToggle.Text = "Vector Pull: " .. (PULL_ENABLED and "ON" or "OFF")
    pullToggle.BackgroundColor3 = PULL_ENABLED and ACCENT_COLOR or TOGGLE_OFF_COLOR
    pullToggle.TextColor3 = PULL_ENABLED and Color3.fromRGB(0, 0, 0) or TEXT_COLOR
    
    local stroke = pullToggle:FindFirstChildOfClass("UIStroke")
    if stroke then stroke.Color = PULL_ENABLED and ACCENT_COLOR or BORDER_COLOR end
end)

smoothInput.FocusLost:Connect(function()
    local v = tonumber(smoothInput.Text:match("[%d%.]+"))
    if v then 
        magnetSmoothness = math.clamp(v, MIN_SMOOTHNESS, MAX_SMOOTHNESS)
        smoothInput.Text = tostring(magnetSmoothness)
    end
end)

snapInput.FocusLost:Connect(function()
    local v = tonumber(snapInput.Text:match("[%d%.]+"))
    if v then 
        snapSpeed = math.clamp(v, MIN_SNAP, MAX_SNAP)
        snapInput.Text = tostring(snapSpeed)
    end
end)

radiusInput.FocusLost:Connect(function()
    local v = tonumber(radiusInput.Text:match("[%d%.]+"))
    if v then 
        pullRadius = math.clamp(v, MIN_RADIUS, MAX_RADIUS)
        radiusInput.Text = tostring(pullRadius)
    end
end)

-------------------------------------------------
-- DRAGGABLE
-------------------------------------------------
local dragging, dragStart, startPos
frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-------------------------------------------------
-- CONTROLS & ANIMATION
-------------------------------------------------
local popInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local fadeOutInfo = TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In)

local function openGui()
    mainGui.Enabled = true
    frame.Size = UDim2.fromOffset(10, 10)
    frame.Position = UDim2.fromScale(0.1, 0.1)
    
    local tweenSize = TweenService:Create(frame, popInfo, {Size = UDim2.fromOffset(250, 370)})
    local tweenPos = TweenService:Create(frame, popInfo, {Position = UDim2.fromScale(0.5, 0.5)})
    tweenSize:Play()
    tweenPos:Play()
end

local function closeGui()
    local tweenSizeClose = TweenService:Create(frame, fadeOutInfo, {Size = UDim2.fromOffset(10, 10)})
    local tweenPosClose = TweenService:Create(frame, fadeOutInfo, {Position = UDim2.fromScale(0.1, 0.1)})
    tweenSizeClose:Play()
    tweenPosClose:Play()
    tweenSizeClose.Completed:Connect(function() mainGui.Enabled = false end)
end

UserInputService.InputBegan:Connect(function(input, gp)
    if input.KeyCode == Enum.KeyCode.DPadLeft then
        if not mainGui.Enabled then openGui() else closeGui() end
        return
    end

    if gp then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.KeyCode == Enum.KeyCode.ButtonR2 then
        isPulling = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.KeyCode == Enum.KeyCode.ButtonR2 then
        isPulling = false
    end
end)