local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local u5 = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local function u6()
    return u5.Humanoid.RigType == Enum.HumanoidRigType.R15
end
local function u7(p1, p2, p3)
    local TextButton = Instance.new("TextButton")
    TextButton.Name = p1
    TextButton.Text = p2
    TextButton.BackgroundColor3 = p3
    TextButton.Size = UDim2.new(0, 100, 0, 50)
    TextButton.BorderSizePixel = 0
    TextButton.Font = Enum.Font.SourceSans
    TextButton.TextScaled = true
    return TextButton
end
local function u8(p4)
    local TextLabel = Instance.new("TextLabel")
    TextLabel.Text = p4
    TextLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    TextLabel.BorderSizePixel = 0
    TextLabel.Size = UDim2.new(0, 100, 0, 25)
    TextLabel.Font = Enum.Font.SourceSans
    TextLabel.TextScaled = true
    TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    return TextLabel
end
local function u9()
    local TextBox = Instance.new("TextBox")
    TextBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TextBox.BorderSizePixel = 0
    TextBox.Size = UDim2.new(0, 100, 0, 25)
    TextBox.Font = Enum.Font.SourceSans
    TextBox.TextScaled = true
    TextBox.TextColor3 = Color3.fromRGB(0, 0, 0)
    TextBox.PlaceholderText = "Enter power"
    return TextBox
end
local _, v11, v12, v13, v14, v15 = (function()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "CreditXGui"
    ScreenGui.Parent = LocalPlayer.PlayerGui
    local Frame = Instance.new("Frame")
    Frame.Name = "MainFrame"
    Frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Frame.BorderSizePixel = 0
    Frame.Size = UDim2.new(0, 150, 0, 300)
    Frame.Position = UDim2.new(0.5, -75, 0.5, -150)
    Frame.Parent = ScreenGui
    local TextLabel = Instance.new("TextLabel")
    TextLabel.Name = "Title"
    TextLabel.Text = "Credit X"
    TextLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    TextLabel.BorderSizePixel = 0
    TextLabel.Size = UDim2.new(1, 0, 0, 50)
    TextLabel.Font = Enum.Font.SourceSans
    TextLabel.TextScaled = true
    TextLabel.Parent = Frame
    local v38 = u7("DinoAnimButton", "Dino Anim (Off)", Color3.fromRGB(255, 0, 0))
    v38.Position = UDim2.new(0.5, -50, 0.5, -75)
    v38.Parent = Frame
    local v39 = u7("PunchAnimButton", "Punch Anim (Off)", Color3.fromRGB(255, 0, 0))
    v39.Position = UDim2.new(0.5, -50, 0.5, 0)
    v39.Parent = Frame
    local v40 = u7("FlingButton", "Fling (Off)", Color3.fromRGB(255, 0, 0))
    v40.Position = UDim2.new(0.5, -50, 0.5, 75)
    v40.Parent = Frame
    local v41 = u8("Fling Power:")
    v41.Position = UDim2.new(0.5, -50, 0.5, 125)
    v41.Parent = Frame
    local v42 = u9()
    v42.Position = UDim2.new(0.5, -50, 0.5, 150)
    v42.Parent = Frame
    return ScreenGui, Frame, v38, v39, v40, v42
end)()
local u16 = v15
local u17 = v14
local u18 = v13
local u19 = v12;
(function(p5)
    local u45 = nil
    local inputPosition = nil
    local p5Position = nil
    p5.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            u45 = true
            inputPosition = input.Position
            p5Position = p5.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    u45 = false
                end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and u45 then
            local v63 = input.Position - inputPosition
            p5.Position = UDim2.new(p5Position.X.Scale, p5Position.X.Offset + v63.X, p5Position.Y.Scale, p5Position.Y.Offset + v63.Y)
        end
    end)
end)(v11)
local Animation = Instance.new("Animation")
Animation.AnimationId = "rbxassetid://204328711"
local track = u5.Humanoid:LoadAnimation(Animation)
local Animation2 = Instance.new("Animation")
if u6() then
    Animation2.AnimationId = "rbxassetid://846744780"
else
    Animation2.AnimationId = "rbxassetid://204062532"
end
local track2 = u5.Humanoid:LoadAnimation(Animation2)
local u24 = false
local u25 = false
local u26 = false
if u6() then
    u19:Destroy()
end
u19.MouseButton1Click:Connect(function()
    if not u6() then
        u24 = not u24
        if u24 then
            u19.Text = "Dino Anim (On)"
            u19.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        else
            u19.Text = "Dino Anim (Off)"
            u19.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        end
    end
end)
u18.MouseButton1Click:Connect(function()
    u25 = not u25
    if u25 then
        u18.Text = "Punch Anim (On)"
        u18.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    else
        u18.Text = "Punch Anim (Off)"
        u18.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    end
end)
u17.MouseButton1Click:Connect(function()
    u26 = not u26
    if u26 then
        u17.Text = "Fling (On)"
        u17.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    else
        u17.Text = "Fling (Off)"
        u17.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    end
end)
local n1 = 10000
u16.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local num = tonumber(u16.Text)
        if num then
            n1 = num
        else
            u16.Text = ""
        end
    end
end)
UserInputService.TouchTap:Connect(function(_, p7)
    if not p7 and u25 then
        track2:Play()
    end
end)
u5.Humanoid.Running:Connect(function(speed)
    if u24 and speed > 0 then
        track:Play()
    else
        track:Stop()
    end
end);
(function()
    local n2 = 0.1
    local Character = nil
    local v55 = nil
    RunService.Heartbeat:Wait()
    if u26 then
        local LocalPlayer2 = game.Players.LocalPlayer
        while u26 and (not Character or not Character.Parent or not v55 or not v55.Parent) do
            RunService.Heartbeat:Wait()
            Character = LocalPlayer2.Character
            v55 = Character:FindFirstChild("HumanoidRootPart") or (Character:FindFirstChild("Torso") or Character:FindFirstChild("UpperTorso"))
        end
        if u26 then
            local Velocity = v55.Velocity
            v55.Velocity = Velocity * n1 + Vector3.new(0, n1, 0)
            RunService.RenderStepped:Wait()
            if Character and Character.Parent and v55 and v55.Parent then
                v55.Velocity = Velocity
            end
            RunService.Stepped:Wait()
            if Character and Character.Parent and v55 and v55.Parent then
                v55.Velocity = Velocity + Vector3.new(0, 0.1, 0)
                n2 = -0.1
            end
        end
    end
    while true do
        RunService.Heartbeat:Wait()
        if u26 then
            local LocalPlayer3 = game.Players.LocalPlayer
            while u26 and (not Character or not Character.Parent or not v55 or not v55.Parent) do
                RunService.Heartbeat:Wait()
                Character = LocalPlayer3.Character
                v55 = Character:FindFirstChild("HumanoidRootPart") or (Character:FindFirstChild("Torso") or Character:FindFirstChild("UpperTorso"))
            end
            if u26 then
                local Velocity = v55.Velocity
                v55.Velocity = Velocity * n1 + Vector3.new(0, n1, 0)
                RunService.RenderStepped:Wait()
                if Character and Character.Parent and v55 and v55.Parent then
                    v55.Velocity = Velocity
                end
                RunService.Stepped:Wait()
                if Character and Character.Parent and v55 and v55.Parent then
                    v55.Velocity = Velocity + Vector3.new(0, n2, 0)
                    n2 *= -1
                end
            end
        end
    end
end)()
