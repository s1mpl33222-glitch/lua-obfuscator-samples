-- RIZAL GIBRAN HUB - OXYLUS OPTIMIZED v10 (MINI RGB)
local UIS = game:GetService("UserInputService")
local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- 1. PEMBUATAN UI DASAR (UKURAN DIPERPENDEK)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AndroidHub"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local toggleBtn = Instance.new("TextButton")
toggleBtn.Name = "Toggle"
toggleBtn.Size = UDim2.new(0, 50, 0, 50)
toggleBtn.Position = UDim2.new(0, 10, 0.5, -25)
toggleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
toggleBtn.Text = "OPEN"
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.Parent = screenGui
Instance.new("UICorner", toggleBtn)

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 280, 0, 300) -- Ukuran diperpendek dari 420 ke 300
mainFrame.Position = UDim2.new(0.5, -140, 0.5, -150)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
mainFrame.Visible = false
mainFrame.Active = true
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 35)
title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
title.Text = "  Become A Brainrot"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 15
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = mainFrame
Instance.new("UICorner", title)

local container = Instance.new("ScrollingFrame")
container.Size = UDim2.new(1, -10, 1, -70) -- Menyesuaikan sisa ruang
container.Position = UDim2.new(0, 5, 0, 40)
container.BackgroundTransparency = 1
container.CanvasSize = UDim2.new(0, 0, 0, 550)
container.ScrollBarThickness = 3
container.Parent = mainFrame

local layout = Instance.new("UIListLayout", container)
layout.Padding = UDim.new(0, 6)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- TEKS SUBSCRIBE
local subText = Instance.new("TextLabel")
subText.Size = UDim2.new(1, 0, 0, 25)
subText.Position = UDim2.new(0, 0, 1, -25)
subText.BackgroundTransparency = 1
subText.Text = "SUBSCRIBE RIZALGG GT"
subText.TextColor3 = Color3.new(1, 1, 1)
subText.Font = Enum.Font.SourceSansItalic
subText.TextSize = 13
subText.Parent = mainFrame

-- 2. LOGIKA RGB
RunService.RenderStepped:Connect(function()
    local hue = tick() % 5 / 5
    local color = Color3.fromHSV(hue, 1, 1)
    title.TextColor3 = color
    subText.TextColor3 = color
end)

-- 3. SISTEM EKSEKUSI
local products = {
    cash = 3572498427,
    reward = 3569720074,
    steal = 3567415683,
    money10m = 3567414683,
    rebirth = 3567414381,
    secretPack = 3567414096,
    serverLuck = 3567413710,
    tenSpin = 3567412591,
    carryUpgrade = 3567412413,
    plusSpeed = 3567412168
}

local function SendSignal(id)
    MarketplaceService:SignalPromptProductPurchaseFinished(player.UserId, id, true)
end

local function SellAllBrainrot()
    local event = ReplicatedStorage:WaitForChild("Events"):WaitForChild("SellBrainrots")
    for _, tool in pairs(player.Backpack:GetChildren()) do
        if tool:IsA("Tool") then event:FireServer(tool) end
    end
    if player.Character then
        for _, tool in pairs(player.Character:GetChildren()) do
            if tool:IsA("Tool") then event:FireServer(tool) end
        end
    end
end

-- 4. FUNGSI TOMBOL
local function addHack(name, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 35) -- Tinggi tombol dikurangi agar pas
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.Text = name
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 13
    btn.Parent = container
    Instance.new("UICorner", btn)
    btn.MouseButton1Click:Connect(callback)
end

-- DAFTAR FITUR
addHack("SELL ALL BRAINROT", function() SellAllBrainrot() end)
addHack("Buy 10X Cash Offline", function() SendSignal(products.cash) end)
addHack("Buy Random Brainrot", function() SendSignal(products.reward) end)
addHack("Steal Brainrot Player", function() SendSignal(products.steal) end)
addHack("Buy Money 10M", function() SendSignal(products.money10m) end)
addHack("Skip Rebirth", function() SendSignal(products.rebirth) end)
addHack("Secret Pack", function() SendSignal(products.secretPack) end)
addHack("Server Luck 128x", function() SendSignal(products.serverLuck) end)
addHack("10x Spin", function() SendSignal(products.tenSpin) end)
addHack("1+ Carry Upgrade", function() SendSignal(products.carryUpgrade) end)
addHack("Buy 10+ Speed", function() SendSignal(products.plusSpeed) end)

-- 5. DRAGGING & TOGGLE
toggleBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
    toggleBtn.Text = mainFrame.Visible and "CLOSE" or "OPEN"
end)

local dragging, dragStart, startPos
title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)
