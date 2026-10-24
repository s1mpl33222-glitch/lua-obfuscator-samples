-- Lime HUB Key System
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Создаём ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "LimeHUB"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Главный фрейм
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 340, 0, 220)
mainFrame.Position = UDim2.new(0.5, -170, 0.5, -110)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- Скругление углов
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

-- Градиентная полоска сверху
local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 4)
topBar.Position = UDim2.new(0, 0, 0, 0)
topBar.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
topBar.BorderSizePixel = 0
topBar.Parent = mainFrame

local topCorner = Instance.new("UICorner")
topCorner.CornerRadius = UDim.new(0, 12)
topCorner.Parent = topBar

-- Заголовок Lime HUB
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 50)
titleLabel.Position = UDim2.new(0, 0, 0, 10)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "🍋 Lime HUB"
titleLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
titleLabel.TextSize = 28
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = mainFrame

-- Подзаголовок
local subLabel = Instance.new("TextLabel")
subLabel.Size = UDim2.new(1, 0, 0, 20)
subLabel.Position = UDim2.new(0, 0, 0, 50)
subLabel.BackgroundTransparency = 1
subLabel.Text = "Key System"
subLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
subLabel.TextSize = 13
subLabel.Font = Enum.Font.Gotham
subLabel.Parent = mainFrame

-- Поле ввода ключа
local keyBox = Instance.new("TextBox")
keyBox.Size = UDim2.new(0, 280, 0, 40)
keyBox.Position = UDim2.new(0.5, -140, 0, 85)
keyBox.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
keyBox.BorderSizePixel = 0
keyBox.PlaceholderText = "🔑  Enter your key..."
keyBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
keyBox.Text = ""
keyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
keyBox.TextSize = 14
keyBox.Font = Enum.Font.Gotham
keyBox.ClearTextOnFocus = false
keyBox.Parent = mainFrame

local keyCorner = Instance.new("UICorner")
keyCorner.CornerRadius = UDim.new(0, 8)
keyCorner.Parent = keyBox

-- Статус (ошибка / успех)
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, 0, 0, 20)
statusLabel.Position = UDim2.new(0, 0, 0, 130)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = ""
statusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
statusLabel.TextSize = 12
statusLabel.Font = Enum.Font.Gotham
statusLabel.Parent = mainFrame

-- Кнопка GET KEY (с иконкой ключа)
local getButton = Instance.new("TextButton")
getButton.Size = UDim2.new(0, 130, 0, 38)
getButton.Position = UDim2.new(0.5, -145, 0, 158)
getButton.BackgroundColor3 = Color3.fromRGB(0, 200, 80)
getButton.BorderSizePixel = 0
getButton.Text = "🔑  GET KEY"
getButton.TextColor3 = Color3.fromRGB(255, 255, 255)
getButton.TextSize = 14
getButton.Font = Enum.Font.GothamBold
getButton.Parent = mainFrame

local getCorner = Instance.new("UICorner")
getCorner.CornerRadius = UDim.new(0, 8)
getCorner.Parent = getButton

-- Кнопка ACTIVATE
local activateButton = Instance.new("TextButton")
activateButton.Size = UDim2.new(0, 130, 0, 38)
activateButton.Position = UDim2.new(0.5, 15, 0, 158)
activateButton.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
activateButton.BorderSizePixel = 0
activateButton.Text = "ACTIVATE"
activateButton.TextColor3 = Color3.fromRGB(0, 0, 0)
activateButton.TextSize = 14
activateButton.Font = Enum.Font.GothamBold
activateButton.Parent = mainFrame

local activateCorner = Instance.new("UICorner")
activateCorner.CornerRadius = UDim.new(0, 8)
activateCorner.Parent = activateButton

-- Hover эффект GET KEY
getButton.MouseEnter:Connect(function()
    getButton.BackgroundColor3 = Color3.fromRGB(0, 230, 100)
end)
getButton.MouseLeave:Connect(function()
    getButton.BackgroundColor3 = Color3.fromRGB(0, 200, 80)
end)

-- Hover эффект ACTIVATE
activateButton.MouseEnter:Connect(function()
    activateButton.BackgroundColor3 = Color3.fromRGB(50, 255, 130)
end)
activateButton.MouseLeave:Connect(function()
    activateButton.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
end)

-- GET KEY — открывает ссылку
getButton.MouseButton1Click:Connect(function()
    -- Замени ссылку на свою (linkvertise, loot-link и т.д.)
    setclipboard("https://link-hub.net/4707574/7ssbFw2Urp5v")
    statusLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
    statusLabel.Text = "✅ Link copied! Complete the task to get key."
end)

-- ACTIVATE — всегда показывает ошибку
activateButton.MouseButton1Click:Connect(function()
    statusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
    statusLabel.Text = "❌ Key Error. Try again."
end)

-- Draggable (перетаскивание окна)
local dragging, dragStart, startPos
mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)
mainFrame.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)
mainFrame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)