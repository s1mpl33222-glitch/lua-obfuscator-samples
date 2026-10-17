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
    local function v10(p3)
        local v11
        local function v12()
            local t1 = {
				["Title"] = "Information",
				["Text"] = v11,
				["Duration"] = 5
			}

            game.StarterGui:SetCore("SendNotification", t1)
        end
        v11 = p3
        pcall(v12)
    end
    copyLink.MouseButton1Click:Connect(function()
        local function v14()

            if typeof(setclipboard) == "function" then
                setclipboard("https://t.me/rbxrobloxscripts")
                v10("The link has been copied to the clipboard!")

                return
            else
                error("no_setclipboard")

                return
            end
        end

        if pcall(v14) then
            return
        end

        v10("Copy manually: https://t.me/rbxrobloxscripts")
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
    TextLabel.MouseButton1Click:Connect(ScreenGui)
    local u17
    ScreenGui = function(p4)
        local v18 = p4.Position - nil

        Frame.Position = UDim2.new((nil).X.Scale, (nil).X.Offset + v18.X, (nil).Y.Scale, (nil).Y.Offset + v18.Y)
    end
    PlayerGui.InputBegan:Connect(function(input)
        if not (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            return
        end

        u17 = true

        local Position = input.Position

        Position = Frame.Position
        input.Changed:Connect(function()
            if input.UserInputState ~= Enum.UserInputState.End then
                return
            end

            u17 = false
        end)
    end)
    UserInputService.InputChanged:Connect(function(input)
        local v20 = u17

        if v20 then
            v20 = input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch
        end

        if not v20 then
            return
        end

        ScreenGui(input)
    end)
end)
Players = { pcall(function()
    loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/80aed6b06a7e38e8260a1b82638ff65b.lua"))()
end) }
UserInputService = Players[2]

if Players[1] then
    return
end
pcall(function()
    local StarterGui = game.StarterGui
    local v22 = UserInputService

    StarterGui:SetCore("SendNotification", {
		["Title"] = "Loading Error",
		["Text"] = tostring(v22),
		["Duration"] = 8
	})
end)
