-- This file was generated at discord.gg/syncrypt

local v1 = unpack or table.unpack
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")
game:GetService("GuiService")
local TweenService = game:GetService("TweenService")
game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")
StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false)
pcall(function()
    if CoreGui:FindFirstChild("VoidHubOverlay") then
        CoreGui.VoidHubOverlay:Destroy()
    end
end)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VoidHubOverlay"
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 999999
ScreenGui.Parent = CoreGui
local Frame = Instance.new("Frame")
Frame.Name = "GameBlocker"
Frame.Size = UDim2.new(1, 0, 1, 0)
Frame.Position = UDim2.new(0, 0, 0, 0)
Frame.BackgroundTransparency = 1
Frame.Active = true
Frame.ZIndex = 1
Frame.Parent = ScreenGui
local Frame2 = Instance.new("Frame")
Frame2.Name = "BlurBackground"
Frame2.Size = UDim2.new(1, 0, 1, 0)
Frame2.BackgroundColor3 = Color3.new(0, 0, 0)
Frame2.BackgroundTransparency = 0.2
Frame2.BorderSizePixel = 0
Frame2.ZIndex = 1
Frame2.Parent = Frame
local UIGradient = Instance.new("UIGradient")
UIGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 20, 30)),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(10, 10, 20)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(5, 5, 15))
})
UIGradient.Rotation = 45
UIGradient.Parent = Frame2
local Frame3 = Instance.new("Frame")
Frame3.Name = "MainContainer"
Frame3.Size = UDim2.new(0.85, 0, 0.75, 0)
Frame3.Position = UDim2.new(0.5, 0, 0.5, 0)
Frame3.AnchorPoint = Vector2.new(0.5, 0.5)
Frame3.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
Frame3.BackgroundTransparency = 0.1
Frame3.BorderSizePixel = 0
Frame3.ZIndex = 2
Frame3.Parent = Frame
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 20)
UICorner.Parent = Frame3
local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(114, 137, 218)
UIStroke.Thickness = 2
UIStroke.Transparency = 0.3
UIStroke.Parent = Frame3
local ImageLabel = Instance.new("ImageLabel")
ImageLabel.Name = "Glow"
ImageLabel.Size = UDim2.new(1.2, 0, 1.2, 0)
ImageLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
ImageLabel.BackgroundTransparency = 1
ImageLabel.Image = "rbxassetid://5028857084"
ImageLabel.ImageColor3 = Color3.fromRGB(114, 137, 218)
ImageLabel.ImageTransparency = 0.9
ImageLabel.ZIndex = 1
ImageLabel.Parent = Frame3
local Frame4 = Instance.new("Frame")
Frame4.Name = "TitleContainer"
Frame4.Size = UDim2.new(1, 0, 0.12, 0)
Frame4.Position = UDim2.new(0, 0, 0.02, 0)
Frame4.BackgroundTransparency = 1
Frame4.ZIndex = 3
Frame4.Parent = Frame3
local TextLabel = Instance.new("TextLabel")
TextLabel.Name = "Title"
TextLabel.Size = UDim2.new(1, 0, 1, 0)
TextLabel.BackgroundTransparency = 1
TextLabel.Text = "VOIDHUB"
TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.TextScaled = true
TextLabel.Font = Enum.Font.GothamBlack
TextLabel.ZIndex = 3
TextLabel.Parent = Frame4
local UIGradient2 = Instance.new("UIGradient")
UIGradient2.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(114, 137, 218)),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(114, 137, 218))
})
UIGradient2.Parent = TextLabel
local TextLabel2 = Instance.new("TextLabel")
TextLabel2.Name = "MainMessage"
TextLabel2.Size = UDim2.new(0.9, 0, 0.18, 0)
TextLabel2.Position = UDim2.new(0.5, 0, 0.18, 0)
TextLabel2.AnchorPoint = Vector2.new(0.5, 0)
TextLabel2.BackgroundTransparency = 1
TextLabel2.Text = "This is NOT a key system.\nJoin our Discord to support the development\nand stay updated with latest features!"
TextLabel2.TextColor3 = Color3.fromRGB(220, 220, 220)
TextLabel2.TextScaled = false
TextLabel2.TextSize = 16
TextLabel2.TextWrapped = true
TextLabel2.TextYAlignment = Enum.TextYAlignment.Center
TextLabel2.Font = Enum.Font.GothamSemibold
TextLabel2.ZIndex = 3
TextLabel2.Parent = Frame3
local Frame5 = Instance.new("Frame")
Frame5.Name = "CodeContainer"
Frame5.Size = UDim2.new(0.6, 0, 0.1, 0)
Frame5.Position = UDim2.new(0.5, 0, 0.4, 0)
Frame5.AnchorPoint = Vector2.new(0.5, 0)
Frame5.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
Frame5.BorderSizePixel = 0
Frame5.ZIndex = 3
Frame5.Parent = Frame3
local UICorner2 = Instance.new("UICorner")
UICorner2.CornerRadius = UDim.new(0, 8)
UICorner2.Parent = Frame5
local UIStroke2 = Instance.new("UIStroke")
UIStroke2.Color = Color3.fromRGB(114, 137, 218)
UIStroke2.Thickness = 1
UIStroke2.Transparency = 0.5
UIStroke2.Parent = Frame5
local TextLabel3 = Instance.new("TextLabel")
TextLabel3.Name = "CodeLabel"
TextLabel3.Size = UDim2.new(1, 0, 1, 0)
TextLabel3.BackgroundTransparency = 1
TextLabel3.Text = "discord.gg/5sVZW7mQRb"
TextLabel3.TextColor3 = Color3.fromRGB(114, 137, 218)
TextLabel3.TextScaled = false
TextLabel3.TextSize = 20
TextLabel3.Font = Enum.Font.GothamBold
TextLabel3.ZIndex = 4
TextLabel3.Parent = Frame5
local TextButton = Instance.new("TextButton")
TextButton.Name = "CopyButton"
TextButton.Size = UDim2.new(0.5, 0, 0.1, 0)
TextButton.Position = UDim2.new(0.5, 0, 0.58, 0)
TextButton.AnchorPoint = Vector2.new(0.5, 0)
TextButton.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
TextButton.BorderSizePixel = 0
TextButton.Text = "📋 Copy Invite Link"
TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TextButton.TextScaled = false
TextButton.TextSize = 16
TextButton.Font = Enum.Font.GothamBold
TextButton.ZIndex = 3
TextButton.Parent = Frame3
local UICorner3 = Instance.new("UICorner")
UICorner3.CornerRadius = UDim.new(0, 10)
UICorner3.Parent = TextButton
local Frame6 = Instance.new("Frame")
Frame6.Name = "ProgressContainer"
Frame6.Size = UDim2.new(0.8, 0, 0.08, 0)
Frame6.Position = UDim2.new(0.5, 0, 0.85, 0)
Frame6.AnchorPoint = Vector2.new(0.5, 0)
Frame6.BackgroundTransparency = 1
Frame6.ZIndex = 3
Frame6.Parent = Frame3
local Frame7 = Instance.new("Frame")
Frame7.Name = "BarBackground"
Frame7.Size = UDim2.new(1, 0, 0.4, 0)
Frame7.Position = UDim2.new(0, 0, 0, 0)
Frame7.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
Frame7.BorderSizePixel = 0
Frame7.ZIndex = 3
Frame7.Parent = Frame6
local UICorner4 = Instance.new("UICorner")
UICorner4.CornerRadius = UDim.new(1, 0)
UICorner4.Parent = Frame7
local Frame8 = Instance.new("Frame")
Frame8.Name = "BarFill"
Frame8.Size = UDim2.new(0, 0, 1, 0)
Frame8.BackgroundColor3 = Color3.fromRGB(114, 137, 218)
Frame8.BorderSizePixel = 0
Frame8.ZIndex = 4
Frame8.Parent = Frame7
local UICorner5 = Instance.new("UICorner")
UICorner5.CornerRadius = UDim.new(1, 0)
UICorner5.Parent = Frame8
local TextLabel4 = Instance.new("TextLabel")
TextLabel4.Name = "TimerLabel"
TextLabel4.Size = UDim2.new(1, 0, 0.5, 0)
TextLabel4.Position = UDim2.new(0, 0, 0.5, 0)
TextLabel4.BackgroundTransparency = 1
TextLabel4.Text = "Time remaining: 180s"
TextLabel4.TextColor3 = Color3.fromRGB(180, 180, 180)
TextLabel4.TextScaled = false
TextLabel4.TextSize = 12
TextLabel4.Font = Enum.Font.Gotham
TextLabel4.ZIndex = 3
TextLabel4.Parent = Frame6
local TextLabel5 = Instance.new("TextLabel")
TextLabel5.Name = "FooterNote"
TextLabel5.Size = UDim2.new(0.9, 0, 0.05, 0)
TextLabel5.Position = UDim2.new(0.5, 0, 0.95, 0)
TextLabel5.AnchorPoint = Vector2.new(0.5, 0)
TextLabel5.BackgroundTransparency = 1
TextLabel5.Text = "To RScripts Mods: No key system - Contact: vonplayz_real"
TextLabel5.TextColor3 = Color3.fromRGB(150, 150, 150)
TextLabel5.TextScaled = false
TextLabel5.TextSize = 10
TextLabel5.TextWrapped = true
TextLabel5.Font = Enum.Font.Gotham
TextLabel5.ZIndex = 3
TextLabel5.Parent = Frame3
local color3 = Color3.fromRGB(88, 101, 242)
local t1 = { Color3.fromRGB(110, 125, 255) };
(function(p1, p2, p3)
    p1.MouseEnter:Connect(function()
        TweenService:Create(p1, TweenInfo.new(0.2), {
			BackgroundColor3 = p3
		}):Play()
    end)
    p1.MouseLeave:Connect(function()
        TweenService:Create(p1, TweenInfo.new(0.2), {
			BackgroundColor3 = p2
		}):Play()
    end)
end)(TextButton, color3, v1(t1))
local u35 = false
local t2 = {}
TextButton.MouseButton1Click:Connect(function()
    if u35 then
        return
    end

    u35 = true
    pcall(function()
        if setclipboard then
            setclipboard("https://discord.gg/5sVZW7mQRb")
        end
    end)
    TextButton.Text = "✅ Copied!"
    TextButton.BackgroundColor3 = Color3.fromRGB(59, 165, 93)
    task.wait(1.5)
    ScreenGui:Destroy()
    ContextActionService:UnbindAction("VoidHubBlockAll")

    for _, v in ipairs(t2) do
        local v47 = v

        pcall(function()
            v47:Disconnect()
        end)
    end

    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, true)
    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, true)

    local LocalPlayer = Players.LocalPlayer
    local v49 = LocalPlayer

    if v49 then
        v49 = LocalPlayer.Character
    end

    if v49 then
        local HumanoidRootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

        if HumanoidRootPart then
            HumanoidRootPart.Anchored = false
        end
    end

    if LocalPlayer then
        pcall(function()
            LocalPlayer:Kick("✅ Discord link copied to clipboard!\n\nJoin VoidHub Discord:\nhttps://discord.gg/5sVZW7mQRb\n\nCode: 5sVZW7mQRb")
        end)
    end
end);
(function()
    ContextActionService:BindAction("VoidHubBlockAll", function()
        return Enum.ContextActionResult.Sink
    end, false, Enum.UserInputType.MouseButton1, Enum.UserInputType.MouseButton2, Enum.UserInputType.MouseWheel, Enum.UserInputType.Keyboard, Enum.UserInputType.Touch, Enum.UserInputType.Gamepad1, Enum.UserInputType.Gamepad2, Enum.UserInputType.Gamepad3)

    local LocalPlayer = Players.LocalPlayer

    if LocalPlayer then
        local Character = LocalPlayer.Character

        if Character then
            local Humanoid = Character:FindFirstChildOfClass("Humanoid")

            if Humanoid then
                Humanoid.WalkSpeed = 0
                Humanoid.JumpPower = 0
            end

            local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

            if HumanoidRootPart then
                HumanoidRootPart.Anchored = true
            end
        end
    end
end)()
local LocalPlayer = Players.LocalPlayer
if LocalPlayer then
    table.insert(t2, LocalPlayer.CharacterAdded:Connect(function(character)
        task.wait(0.1)

        if not u35 then
            local Humanoid = character:FindFirstChildOfClass("Humanoid")

            if Humanoid then
                Humanoid.WalkSpeed = 0
                Humanoid.JumpPower = 0
            end

            local HumanoidRootPart = character:FindFirstChild("HumanoidRootPart")

            if HumanoidRootPart then
                HumanoidRootPart.Anchored = true
            end
        end
    end))
end
TweenService:Create(Frame8, TweenInfo.new(180, Enum.EasingStyle.Linear), {
	Size = UDim2.new(1, 0, 1, 0)
}):Play()
task.spawn(function()
    for i = 180, 0, -1 do
        local v59 = i

        if u35 then
            return
        end

        TextLabel4.Text = "Time remaining: " .. v59 .. "s"

        if v59 <= 30 then
            TextLabel4.TextColor3 = Color3.fromRGB(255, 100, 100)
            Frame8.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
        elseif v59 <= 60 then
            TextLabel4.TextColor3 = Color3.fromRGB(255, 200, 100)
            Frame8.BackgroundColor3 = Color3.fromRGB(255, 200, 100)
        end

        task.wait(1)
    end
end)
task.wait(180)
if not u35 then
    ScreenGui:Destroy()
    ContextActionService:UnbindAction("VoidHubBlockAll")

    for _, v in ipairs(t2) do
        local v39 = v

        pcall(function()
            v39:Disconnect()
        end)
    end

    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, true)
    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, true)

    local v40 = LocalPlayer

    if v40 then
        v40 = LocalPlayer.Character
    end

    if v40 then
        local HumanoidRootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

        if HumanoidRootPart then
            HumanoidRootPart.Anchored = false
        end
    end

    if LocalPlayer then
        pcall(function()
            LocalPlayer:Kick("⏰ Time expired!\n\nJoin VoidHub Discord:\nhttps://discord.gg/5sVZW7mQRb\n\nCode: 5sVZW7mQRb")
        end)
    end
end
