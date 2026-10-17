-- This file was generated at discord.gg/syncrypt

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

Players = Players.LocalPlayer
pcall(function()
    local PlayerGui = Players:FindFirstChildOfClass("PlayerGui") or Players:WaitForChild("PlayerGui")
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "InfoPopup_TG"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = PlayerGui
    PlayerGui = Instance.new("TextButton")
    PlayerGui.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    PlayerGui.BackgroundTransparency = 0.35
    PlayerGui.BorderSizePixel = 0
    PlayerGui.AutoButtonColor = false
    PlayerGui.Text = ""
    PlayerGui.Size = UDim2.fromScale(1, 1)
    PlayerGui.Parent = ScreenGui
    PlayerGui.ZIndex = 1000
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 380, 0, 210)
    Frame.Position = UDim2.new(0.5, -190, 0.5, -105)
    Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Frame.BorderSizePixel = 0
    Frame.Parent = PlayerGui
    Frame.ZIndex = 1001
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 12)
    PlayerGui = Instance.new("UIStroke", Frame)
    PlayerGui.Thickness = 1
    PlayerGui.Color = Color3.fromRGB(70, 70, 70)
    PlayerGui = Instance.new("Frame")
    PlayerGui.Size = UDim2.new(1, 0, 0, 38)
    PlayerGui.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    PlayerGui.BorderSizePixel = 0
    PlayerGui.Parent = Frame
    PlayerGui.ZIndex = 1002
    Instance.new("UICorner", PlayerGui).CornerRadius = UDim.new(0, 12)
    local TextLabel = Instance.new("TextLabel")
    TextLabel.BackgroundTransparency = 1
    TextLabel.Size = UDim2.fromScale(1, 1)
    TextLabel.Font = Enum.Font.SourceSansBold
    TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextLabel.TextSize = 18
    TextLabel.Text = "Subscribe to my Telegram channel!"
    TextLabel.Parent = PlayerGui
    TextLabel.ZIndex = 1003
    TextLabel = Instance.new("TextButton")
    TextLabel.AnchorPoint = Vector2.new(1, 0.5)
    TextLabel.Position = UDim2.new(1, -8, 0.5, 0)
    TextLabel.Size = UDim2.new(0, 28, 0, 24)
    TextLabel.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    TextLabel.TextColor3 = Color3.new(1, 1, 1)
    TextLabel.Text = "\195\151"
    TextLabel.Font = Enum.Font.SourceSansBold
    TextLabel.TextSize = 20
    TextLabel.Parent = PlayerGui
    TextLabel.ZIndex = 1003
    Instance.new("UICorner", TextLabel).CornerRadius = UDim.new(0, 8)
    local TextLabel2 = Instance.new("TextLabel")
    TextLabel2.BackgroundTransparency = 1
    TextLabel2.Position = UDim2.new(0, 16, 0, 52)
    TextLabel2.Size = UDim2.new(1, -32, 0, 48)
    TextLabel2.TextWrapped = true
    TextLabel2.Font = Enum.Font.SourceSans
    TextLabel2.TextSize = 17
    TextLabel2.TextColor3 = Color3.fromRGB(230, 230, 230)
    TextLabel2.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel2.TextYAlignment = Enum.TextYAlignment.Top
    TextLabel2.Text = "Verified scripts and more!"
    TextLabel2.Parent = Frame
    TextLabel2.ZIndex = 1002
    TextLabel2 = Instance.new("TextLabel")
    TextLabel2.BackgroundTransparency = 1
    TextLabel2.Position = UDim2.new(0, 16, 0, 104)
    TextLabel2.Size = UDim2.new(1, -32, 0, 22)
    TextLabel2.Font = Enum.Font.SourceSansBold
    TextLabel2.TextSize = 18
    TextLabel2.TextColor3 = Color3.fromRGB(100, 185, 255)
    TextLabel2.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel2.Text = "https://t.me/rbxrobloxscripts"
    TextLabel2.Parent = Frame
    TextLabel2.ZIndex = 1002
    TextLabel2 = function(p1, p2)
        local TextButton = Instance.new("TextButton")

        TextButton.Size = UDim2.new(0, 160, 0, 32)
        TextButton.Position = p2
        TextButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        TextButton.Text = p1
        TextButton.Font = Enum.Font.SourceSansBold
        TextButton.TextSize = 15
        TextButton.Parent = Frame
        TextButton.ZIndex = 1002
        Instance.new("UICorner", TextButton).CornerRadius = UDim.new(0, 8)

        return TextButton
    end
    local copyLink = TextLabel2("Copy link", UDim2.new(0, 16, 0, 140))
    TextLabel2 = TextLabel2("OK", UDim2.new(1, -176, 0, 178))
    copyLink.MouseButton1Click:Connect(function()
        if pcall(function()

            if typeof(setclipboard) ~= "function" then
                error("no_setclipboard")

                return
            end
        end) then
            return
        end

        local s1 = "Copy manually: https://t.me/rbxrobloxscripts"

        pcall(function()
            local t1 = {
				["Title"] = "Information",
				["Text"] = s1,
				["Duration"] = 5
			}

            game.StarterGui:SetCore("SendNotification", t1)
        end)
    end)
    ScreenGui = function()
        local Parent = ScreenGui

        if Parent then
            Parent = ScreenGui.Parent
        end

        if not Parent then
            return
        end

        ScreenGui:Destroy()
    end
    TextLabel2.MouseButton1Click:Connect(ScreenGui)
    TextLabel = TextLabel.MouseButton1Click
    local v14
    TextLabel:Connect(ScreenGui)
    local u15
    ScreenGui = function(p3)
        local v16 = p3.Position - nil

        Frame.Position = UDim2.new(v14.X.Scale, v14.X.Offset + v16.X, v14.Y.Scale, v14.Y.Offset + v16.Y)
    end
    v14 = nil
    PlayerGui.InputBegan:Connect(function(input)
        if not (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            return
        end

        u15 = true

        local Position = input.Position

        Position = Frame.Position
        input.Changed:Connect(function()
            if input.UserInputState ~= Enum.UserInputState.End then
                return
            end

            u15 = false
        end)
    end)
    UserInputService.InputChanged:Connect(function(input)
        local v18 = u15

        if v18 then
            v18 = input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch
        end

        if not v18 then
            return
        end

        ScreenGui(input)
    end)
end)
Players, UserInputService = pcall(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/yoursvexyyy/VEX-OP/refs/heads/main/99%20nights%20in%20the%20forest%20premium"))()
end)

if Players then
    return
end
pcall(function()
    local v19 = UserInputService

    game.StarterGui:SetCore("SendNotification", {
		["Title"] = "Loading Error",
		["Text"] = tostring(v19),
		["Duration"] = 8
	})
end)
