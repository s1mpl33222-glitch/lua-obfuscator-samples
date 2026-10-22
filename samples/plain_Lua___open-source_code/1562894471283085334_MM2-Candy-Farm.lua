local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Variable to track if teleportation is enabled
local teleportEnabled = false

-- Function to find the CoinContainer
local function findCoinContainer()
    for _, child in pairs(workspace:GetChildren()) do
        local coinContainer = child:FindFirstChild("CoinContainer")
        if coinContainer then
            return coinContainer
        end
    end
    return nil
end

-- Function to find the nearest coin within a certain radius
local function findNearestCoin(radius)
    local coinContainer = findCoinContainer()
    if not coinContainer then
        print("CoinContainer not found")
        return nil
    end
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    local nearestCoin = nil
    local nearestDistance = radius
    for _, coin in pairs(coinContainer:GetChildren()) do
        local distance = (coin.Position - humanoidRootPart.Position).Magnitude
        if distance < nearestDistance then
            nearestCoin = coin
            nearestDistance = distance
        end
    end
    return nearestCoin
end

-- Function to teleport to a coin
local function teleportToCoin(coin)
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(humanoidRootPart, tweenInfo, {CFrame = coin.CFrame})
    tween:Play()
    return tween
end

-- Variable to track if a teleport is in progress
local isTeleporting = false

-- Function to teleport to a nearby coin or a random coin
local function teleportToNearbyOrRandomCoin()
    if not teleportEnabled or isTeleporting then return end
    local nearbyRadius = 50 -- Adjust this value to change the "nearby" distance
    local nearbyCoin = findNearestCoin(nearbyRadius)
    if nearbyCoin then
        print("Teleporting to nearby coin")
        isTeleporting = true
        local tween = teleportToCoin(nearbyCoin)
        tween.Completed:Wait()
        isTeleporting = false
    else
        local coinContainer = findCoinContainer()
        if not coinContainer then
            print("CoinContainer not found")
            return
        end
        local coins = coinContainer:GetChildren()
        if #coins == 0 then
            print("No coins found")
            return
        end
        local randomCoin = coins[math.random(1, #coins)]
        print("Teleporting to random coin")
        isTeleporting = true
        local tween = teleportToCoin(randomCoin)
        tween.Completed:Wait()
        isTeleporting = false
    end
end

-- Function to create GUI
local function createGUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "MM2CandyAutoFarmGUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = player.PlayerGui

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 200, 0, 100)
    Frame.Position = UDim2.new(0.5, -100, 0.5, -50)
    Frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Frame.BorderSizePixel = 0
    Frame.Parent = ScreenGui
    Frame.Active = true
    Frame.Draggable = true
    Frame.Selectable = true

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 30)
    Title.BackgroundTransparency = 1
    Title.Text = "MM2 Candy Auto Farm"
    Title.TextColor3 = Color3.new(1, 1, 1)
    Title.TextSize = 18
    Title.Font = Enum.Font.SourceSansBold
    Title.Parent = Frame

    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Size = UDim2.new(0.8, 0, 0, 40)
    ToggleButton.Position = UDim2.new(0.1, 0, 0.5, 0)
    ToggleButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    ToggleButton.Text = "Teleport OFF"
    ToggleButton.TextColor3 = Color3.new(1, 1, 1)
    ToggleButton.TextSize = 14
    ToggleButton.Font = Enum.Font.SourceSansBold
    ToggleButton.Parent = Frame

    -- Function to toggle teleportation
    local function toggleTeleport()
        teleportEnabled = not teleportEnabled
        if teleportEnabled then
            ToggleButton.Text = "Teleport ON"
            ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        else
            ToggleButton.Text = "Teleport OFF"
            ToggleButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        end
    end

    -- Connect the toggle button
    ToggleButton.MouseButton1Click:Connect(toggleTeleport)

    return ScreenGui
end

-- Create initial GUI
local gui = createGUI()

-- Function to handle character spawning
local function onCharacterAdded(newCharacter)
    character = newCharacter
    -- Check if GUI exists, if not, recreate it
    if not player.PlayerGui:FindFirstChild("MM2CandyAutoFarmGUI") then
        gui = createGUI()
    end
end

-- Connect to current and future characters
player.CharacterAdded:Connect(onCharacterAdded)

-- Start the continuous teleportation loop
RunService.Heartbeat:Connect(function()
    if teleportEnabled and character and character:FindFirstChild("HumanoidRootPart") then
        teleportToNearbyOrRandomCoin()
    end
end)

print("MM2 Candy Auto Farm script with persistent GUI and fixed toggle loaded.")
