local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local ProximityPromptService = game:GetService("ProximityPromptService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local tween = nil
pcall(function()
    StarterGui:SetCore("SendNotification", {
        Title = "Thông Báo Script",
        Text = "Đã sửa lỗi TP Walk mượt mà!",
        Duration = 5,
    })
end)
ProximityPromptService.PromptShown:Connect(function(prompt)
    prompt.HoldDuration = 0
end)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TPWalkSliderUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
local TextButton = Instance.new("TextButton")
TextButton.Size = UDim2.new(0.12, 0, 0.08, 0)
TextButton.Position = UDim2.new(0.02, 0, 0.2, 0)
TextButton.Text = "TOGGLE"
TextButton.TextScaled = true
TextButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TextButton.Active = true
TextButton.Parent = ScreenGui
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0.3, 0)
UICorner.Parent = TextButton
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0.4, 0, 0.58, 0)
Frame.Position = UDim2.new(0.15, 0, 0.2, 0)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Parent = ScreenGui
local UICorner2 = Instance.new("UICorner")
UICorner2.CornerRadius = UDim.new(0.08, 0)
UICorner2.Parent = Frame
local TextButton2 = Instance.new("TextButton")
TextButton2.Size = UDim2.new(0.12, 0, 0.09, 0)
TextButton2.Position = UDim2.new(0.86, 0, 0.02, 0)
TextButton2.Text = "X"
TextButton2.TextScaled = true
TextButton2.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
TextButton2.TextColor3 = Color3.fromRGB(255, 255, 255)
TextButton2.Parent = Frame
local UICorner3 = Instance.new("UICorner")
UICorner3.CornerRadius = UDim.new(0.3, 0)
UICorner3.Parent = TextButton2
TextButton.MouseButton1Click:Connect(function()
    Frame.Visible = not Frame.Visible
end)
TextButton2.MouseButton1Click:Connect(function()
    Frame.Visible = false
end)
local TextButton3 = Instance.new("TextButton")
TextButton3.Size = UDim2.new(0.88, 0, 0.13, 0)
TextButton3.Position = UDim2.new(0.06, 0, 0.12, 0)
TextButton3.Text = "Bypass Anti cheat"
TextButton3.TextScaled = true
TextButton3.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
TextButton3.TextColor3 = Color3.fromRGB(255, 255, 255)
TextButton3.Parent = Frame
local UICorner4 = Instance.new("UICorner")
UICorner4.CornerRadius = UDim.new(0.2, 0)
UICorner4.Parent = TextButton3
local TextButton4 = Instance.new("TextButton")
TextButton4.Size = UDim2.new(0.62, 0, 0.13, 0)
TextButton4.Position = UDim2.new(0.06, 0, 0.27, 0)
TextButton4.Text = "Move to Stand"
TextButton4.TextScaled = true
TextButton4.BackgroundColor3 = Color3.fromRGB(45, 125, 230)
TextButton4.TextColor3 = Color3.fromRGB(255, 255, 255)
TextButton4.Parent = Frame
local UICorner5 = Instance.new("UICorner")
UICorner5.CornerRadius = UDim.new(0.2, 0)
UICorner5.Parent = TextButton4
local TextButton5 = Instance.new("TextButton")
TextButton5.Size = UDim2.new(0.24, 0, 0.13, 0)
TextButton5.Position = UDim2.new(0.7, 0, 0.27, 0)
TextButton5.Text = "STOP"
TextButton5.TextScaled = true
TextButton5.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
TextButton5.TextColor3 = Color3.fromRGB(255, 255, 255)
TextButton5.Visible = false
TextButton5.Parent = Frame
local UICorner6 = Instance.new("UICorner")
UICorner6.CornerRadius = UDim.new(0.2, 0)
UICorner6.Parent = TextButton5
local TextButton6 = Instance.new("TextButton")
TextButton6.Size = UDim2.new(0.88, 0, 0.13, 0)
TextButton6.Position = UDim2.new(0.06, 0, 0.42, 0)
TextButton6.Text = "Respawn Character"
TextButton6.TextScaled = true
TextButton6.BackgroundColor3 = Color3.fromRGB(230, 140, 30)
TextButton6.TextColor3 = Color3.fromRGB(255, 255, 255)
TextButton6.Parent = Frame
local UICorner7 = Instance.new("UICorner")
UICorner7.CornerRadius = UDim.new(0.2, 0)
UICorner7.Parent = TextButton6
local TextButton7 = Instance.new("TextButton")
TextButton7.Size = UDim2.new(0.88, 0, 0.13, 0)
TextButton7.Position = UDim2.new(0.06, 0, 0.57, 0)
TextButton7.Text = "TP Walk: OFF"
TextButton7.TextScaled = true
TextButton7.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
TextButton7.TextColor3 = Color3.fromRGB(255, 255, 255)
TextButton7.Parent = Frame
local UICorner8 = Instance.new("UICorner")
UICorner8.CornerRadius = UDim.new(0.2, 0)
UICorner8.Parent = TextButton7
local TextLabel = Instance.new("TextLabel")
TextLabel.Size = UDim2.new(0.88, 0, 0.08, 0)
TextLabel.Position = UDim2.new(0.06, 0, 0.72, 0)
TextLabel.Text = "TP Speed: 50 Studs/s"
TextLabel.TextScaled = true
TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.BackgroundTransparency = 1
TextLabel.Parent = Frame
local Frame2 = Instance.new("Frame")
Frame2.Size = UDim2.new(0.88, 0, 0.07, 0)
Frame2.Position = UDim2.new(0.06, 0, 0.83, 0)
Frame2.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
Frame2.BorderSizePixel = 0
Frame2.Parent = Frame
local UICorner9 = Instance.new("UICorner")
UICorner9.CornerRadius = UDim.new(0.5, 0)
UICorner9.Parent = Frame2
local TextButton8 = Instance.new("TextButton")
TextButton8.Size = UDim2.new(0.12, 0, 2, 0)
TextButton8.Position = UDim2.new(0.16, 0, -0.5, 0)
TextButton8.AnchorPoint = Vector2.new(0.5, 0)
TextButton8.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
TextButton8.Text = ""
TextButton8.Parent = Frame2
local UICorner10 = Instance.new("UICorner")
UICorner10.CornerRadius = UDim.new(0.5, 0)
UICorner10.Parent = TextButton8
local function v30(p1)
    local u38 = false
    local u39 = nil
    local inputPosition = nil
    local p1Position = nil
    local function u42(p2)
        local v65 = p2.Position - inputPosition
        p1.Position = UDim2.new(p1Position.X.Scale, p1Position.X.Offset + v65.X, p1Position.Y.Scale, p1Position.Y.Offset + v65.Y)
    end
    p1.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            u38 = true
            inputPosition = input.Position
            p1Position = p1.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    u38 = false
                end
            end)
        end
    end)
    p1.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            u39 = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == u39 and u38 then
            u42(input)
        end
    end)
end
v30(Frame)
v30(TextButton)
local n1 = 50
local u32 = false
local u33 = false
TextButton3.MouseButton1Click:Connect(function()
    local Character = LocalPlayer.Character
    if Character then
        local Humanoid = Character:FindFirstChildOfClass("Humanoid")
        if Humanoid then
            Humanoid:Destroy()
        end
        Instance.new("Humanoid").Parent = Character
    end
end)
TextButton4.MouseButton1Click:Connect(function()
    local Character = LocalPlayer.Character
    if not Character then
        return
    end
    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
    if not HumanoidRootPart then
        return
    end
    if tween then
        tween:Cancel()
    end
    local cFrame = CFrame.new(544.577637, 92.0762939, -364.869049, -1, 0, 0, 0, 1, 0, 0, 0, -1)
    local tweenInfo = TweenInfo.new(7, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false, 0)
    local t1 = {
        CFrame = cFrame,
    }
    tween = TweenService:Create(HumanoidRootPart, tweenInfo, t1)
    TextButton5.Visible = true
    tween.Completed:Connect(function()
        TextButton5.Visible = false
        tween = nil
    end)
    tween:Play()
end)
TextButton5.MouseButton1Click:Connect(function()
    if tween then
        tween:Cancel()
        tween = nil
    end
    TextButton5.Visible = false
end)
TextButton6.MouseButton1Click:Connect(function()
    local Character = LocalPlayer.Character
    if Character then
        local Humanoid = Character:FindFirstChildOfClass("Humanoid")
        if Humanoid then
            Humanoid.Health = 0
        end
    end
end)
TextButton7.MouseButton1Click:Connect(function()
    u32 = not u32
    if u32 then
        TextButton7.Text = "TP Walk: ON"
        TextButton7.BackgroundColor3 = Color3.fromRGB(46, 139, 87)
    else
        TextButton7.Text = "TP Walk: OFF"
        TextButton7.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    end
end)
local function u34(p3)
    local AbsolutePositionX = Frame2.AbsolutePosition.X
    local AbsoluteSizeX = Frame2.AbsoluteSize.X
    local PositionX = p3.Position.X
    local v56 = math.clamp((PositionX - AbsolutePositionX) / AbsoluteSizeX, 0, 1)
    n1 = math.floor(1 + v56 * 299)
    TextButton8.Position = UDim2.new(v56, 0, -0.5, 0)
    TextLabel.Text = "TP Speed: " .. n1 .. " Studs/s"
end
TextButton8.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        u33 = true
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        u33 = false
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if u33 and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        u34(input)
    end
end)
RunService.Heartbeat:Connect(function(dt)
    if u32 then
        local Character = LocalPlayer.Character
        if Character then
            local Humanoid = Character:FindFirstChildOfClass("Humanoid")
            local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
            if Humanoid and HumanoidRootPart and Humanoid.MoveDirection.Magnitude > 0 then
                HumanoidRootPart.CFrame = HumanoidRootPart.CFrame + Humanoid.MoveDirection * n1 * dt
            end
        end
    end
end)
