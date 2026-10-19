-- This file was generated at discord.gg/syncrypt

local game_ = game
game_ = game_:GetService("Players")

local LocalPlayer = game_.LocalPlayer
local Color3_ = Color3
local GetPlayers = game_.GetPlayers
Color3_ = Color3_.fromRGB(255, 60, 60)

local color3 = Color3.fromRGB(255, 255, 255)

Color3_ = function(p1, p2)
    if p1:FindFirstChild("ESP_Highlight") then
        return
    else
        local Highlight = Instance.new("Highlight")

        Highlight.Name = "ESP_Highlight"
        Highlight.FillColor = Color3_
        Highlight.OutlineColor = color3
        Highlight.FillTransparency = 0.6
        Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        Highlight.Adornee = p1
        Highlight.Parent = p1
        Highlight = p1:WaitForChild("Head", 5)

        if Highlight then
            local BillboardGui = Instance.new("BillboardGui")

            BillboardGui.Name = "ESP_Name"
            BillboardGui.Size = UDim2.new(0, 100, 0, 20)
            BillboardGui.StudsOffset = Vector3.new(0, 2.5, 0)
            BillboardGui.AlwaysOnTop = true
            BillboardGui.Adornee = Highlight
            BillboardGui.Parent = p1
            Highlight = Instance.new("TextLabel")
            Highlight.Size = UDim2.new(1, 0, 1, 0)
            Highlight.BackgroundTransparency = 1
            Highlight.Text = p2.DisplayName
            Highlight.TextColor3 = Color3.new(1, 1, 1)
            Highlight.TextStrokeTransparency = 0
            Highlight.TextScaled = true
            Highlight.Parent = BillboardGui

            return
        else
            return
        end

        return
    end
end
LocalPlayer = function(player)
    if player == LocalPlayer then
        return
    end
end
for _, v in ipairs(GetPlayers(game_)) do
    LocalPlayer(v)
end
game_.PlayerAdded:Connect(LocalPlayer)
