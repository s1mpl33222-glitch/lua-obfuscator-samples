local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 350, 0, 300)
Frame.Position = UDim2.new(0.5, 0, 0.5, 0)
Frame.AnchorPoint = Vector2.new(0.5, 0.5)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

local FrameCorner = Instance.new("UICorner")
FrameCorner.CornerRadius = UDim.new(0, 15)
FrameCorner.Parent = Frame

local Close = Instance.new("TextButton")
Close.Size = UDim2.new(0, 40, 0, 40)
Close.Position = UDim2.new(1, -45, 0, 5)
Close.BackgroundTransparency = 1
Close.Text = "×"
Close.TextScaled = true
Close.TextColor3 = Color3.fromRGB(200, 200, 200)
Close.Font = Enum.Font.SourceSansBold
Close.Parent = Frame
Close.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

local MessageLabel = Instance.new("TextLabel")
MessageLabel.Size = UDim2.new(0, 300, 0, 100)
MessageLabel.Position = UDim2.new(0.5, 0, 0.3, 0)
MessageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
MessageLabel.Text = "Junte-se ao Discord oficial do Raio Hub! Fique por dentro de todas as novidades e atualizações exclusivas no nosso servidor. Além disso, estamos voltando com tudo amanhã, então não perca as novidades fresquinhas! [discord.gg/raiohub](https://discord.gg/raiohub)"
MessageLabel.TextWrapped = true
MessageLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
MessageLabel.BackgroundTransparency = 1
MessageLabel.TextXAlignment = Enum.TextXAlignment.Center
MessageLabel.TextYAlignment = Enum.TextYAlignment.Center
MessageLabel.Font = Enum.Font.SourceSansBold
MessageLabel.TextSize = 18
MessageLabel.Parent = Frame

local CopyButton = Instance.new("TextButton")
CopyButton.Size = UDim2.new(0, 220, 0, 50)
CopyButton.Position = UDim2.new(0.5, 0, 0.75, 0)
CopyButton.AnchorPoint = Vector2.new(0.5, 0.5)
CopyButton.Text = "Copiar Server Link"
CopyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CopyButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
CopyButton.Font = Enum.Font.SourceSansBold
CopyButton.TextSize = 20
CopyButton.Parent = Frame

local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(0, 10)
ButtonCorner.Parent = CopyButton

CopyButton.MouseButton1Click:Connect(function()
    setclipboard("https://discord.gg/cTXBYaxn59")
end)
