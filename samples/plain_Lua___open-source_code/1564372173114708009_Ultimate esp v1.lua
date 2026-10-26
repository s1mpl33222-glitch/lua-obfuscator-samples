local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- by Boston and ChatGPT
local function createHighlight(player)
    if player.Character and not player.Character:FindFirstChild("ESPHighlight") then
        local highlight = Instance.new("Highlight")
        highlight.Name = "ESPHighlight"
        highlight.FillColor = Color3.fromRGB(255, 0, 0)
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.FillTransparency = 0.6 -- ปรับให้จางลง
        highlight.OutlineTransparency = 0
        highlight.Adornee = player.Character
        highlight.Parent = player.Character
    end
end


local function createNameTag(player)
    if player.Character and player.Character:FindFirstChild("Head") and not player.Character.Head:FindFirstChild("NameTag") then
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "NameTag"
        billboard.Adornee = player.Character.Head
        billboard.Size = UDim2.new(0, 130, 0, 25) -- ปรับให้เล็กลง
        billboard.StudsOffset = Vector3.new(0, 2, 0)
        billboard.AlwaysOnTop = true
        billboard.Parent = player.Character.Head

        local textLabel = Instance.new("TextLabel")
        textLabel.Name = "TagLabel"
        textLabel.Size = UDim2.new(1, 0, 1, 0)
        textLabel.BackgroundTransparency = 1
        textLabel.TextColor3 = Color3.new(1, 1, 1)
        textLabel.Font = Enum.Font.Cartoon
        textLabel.TextScaled = true
        textLabel.TextStrokeTransparency = 0.6
        textLabel.Text = ""
        textLabel.Parent = billboard
    end
end


local function updateNameTag(player)
    if player.Character and player.Character:FindFirstChild("Head") and player.Character.Head:FindFirstChild("NameTag") and player.Character:FindFirstChild("Humanoid") then
        local tag = player.Character.Head.NameTag.TagLabel
        local distance = (LocalPlayer.Character.PrimaryPart.Position - player.Character.PrimaryPart.Position).Magnitude
        local health = math.floor(player.Character.Humanoid.Health)
        tag.Text = player.Name .. " | " .. string.format("%.0f", distance).."m | ❤️"..health
    end
end


local function updateHighlight(player)
    if player.Character and player.Character:FindFirstChild("ESPHighlight") and player.Character:FindFirstChild("Humanoid") then
        if player.Character.Humanoid.Health <= 0 then
            player.Character.ESPHighlight.FillColor = Color3.fromRGB(120, 0, 0) -- แดงเข้มตอนตาย
        else
            player.Character.ESPHighlight.FillColor = Color3.fromRGB(255, 0, 0) -- แดงสดตอนอยู่
        end
    end
end


local function setupESP(player)
    if player ~= LocalPlayer then
        player.CharacterAdded:Connect(function()
            wait(0.1)
            createHighlight(player)
            createNameTag(player)
        end)
        if player.Character then
            createHighlight(player)
            createNameTag(player)
        end
    end
end


for _, player in ipairs(Players:GetPlayers()) do
    setupESP(player)
end


Players.PlayerAdded:Connect(function(player)
    setupESP(player)
end)


while true do
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                updateNameTag(player)
                updateHighlight(player)
            end
        end
    end
    wait(0.3)
end
