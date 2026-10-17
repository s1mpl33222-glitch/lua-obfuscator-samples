local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

local flingTarget = nil
local isFlinging = false
local antiFlingEnabled = false
local espEnabled = false

if CoreGui:FindFirstChild("Hacker_Hub_V2_2027") then
    CoreGui.Hacker_Hub_V2_2027:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "Hacker_Hub_V2_2027"
screenGui.ResetOnSpawn = false
screenGui.Parent = CoreGui

local toggleBtn = Instance.new("ImageButton")
toggleBtn.Size = UDim2.new(0, 50, 0, 50)
toggleBtn.Position = UDim2.new(0, 20, 0, 150)
toggleBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
toggleBtn.Image = "rbxassetid://89114452344960"
toggleBtn.Active = true
toggleBtn.Draggable = true
toggleBtn.Parent = screenGui

Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(1, 0)
local toggleStroke = Instance.new("UIStroke", toggleBtn)
toggleStroke.Thickness = 3
local toggleGradient = Instance.new("UIGradient", toggleStroke)
toggleGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 0))
})

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 320, 0, 420)
mainFrame.Position = UDim2.new(0.5, -160, 0.5, -210)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)
local mainStroke = Instance.new("UIStroke", mainFrame)
mainStroke.Thickness = 4
local mainGradient = Instance.new("UIGradient", mainStroke)
mainGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 165, 0))
})

local titleLabel = Instance.new("TextLabel", mainFrame)
titleLabel.Size = UDim2.new(1, 0, 0, 35)
titleLabel.Position = UDim2.new(0, 0, 0, 5)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Hacker Hub V2 🇯🇵"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold

local topControlFrame = Instance.new("Frame", mainFrame)
topControlFrame.Size = UDim2.new(1, -20, 0, 40)
topControlFrame.Position = UDim2.new(0, 10, 0, 45)
topControlFrame.BackgroundTransparency = 1

local stopBtn = Instance.new("TextButton", topControlFrame)
stopBtn.Size = UDim2.new(0.48, 0, 1, 0)
stopBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
stopBtn.Text = "停止"
stopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
stopBtn.TextScaled = true
stopBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", stopBtn).CornerRadius = UDim.new(0, 6)

local antiBtn = Instance.new("TextButton", topControlFrame)
antiBtn.Size = UDim2.new(0.48, 0, 1, 0)
antiBtn.Position = UDim2.new(0.52, 0, 0, 0)
antiBtn.BackgroundColor3 = Color3.fromRGB(40, 120, 180)
antiBtn.Text = "アンチフリング: OFF"
antiBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
antiBtn.TextScaled = true
antiBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", antiBtn).CornerRadius = UDim.new(0, 6)

local espTopBtn = Instance.new("TextButton", mainFrame)
espTopBtn.Size = UDim2.new(1, -20, 0, 35)
espTopBtn.Position = UDim2.new(0, 10, 0, 90)
espTopBtn.BackgroundColor3 = Color3.fromRGB(120, 40, 180)
espTopBtn.Text = "ESP: OFF"
espTopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
espTopBtn.TextScaled = true
espTopBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", espTopBtn).CornerRadius = UDim.new(0, 6)

local scrollFrame = Instance.new("ScrollingFrame", mainFrame)
scrollFrame.Size = UDim2.new(1, -20, 0, 265)
scrollFrame.Position = UDim2.new(0, 10, 0, 135)
scrollFrame.BackgroundTransparency = 1
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.ScrollBarThickness = 6

local uiList = Instance.new("UIListLayout", scrollFrame)
uiList.SortOrder = Enum.SortOrder.LayoutOrder
uiList.Padding = UDim.new(0, 5)

local function updatePlayerList()
    for _, child in ipairs(scrollFrame:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local btn = Instance.new("TextButton", scrollFrame)
            btn.Size = UDim2.new(1, -5, 0, 45)
            btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            btn.Text = "        " .. player.Name
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.TextSize = 14
            btn.Font = Enum.Font.GothamBold
            btn.TextXAlignment = Enum.TextXAlignment.Left
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
            
            local img = Instance.new("ImageLabel", btn)
            img.Size = UDim2.new(0, 35, 0, 35)
            img.Position = UDim2.new(0, 5, 0.5, -17.5)
            img.BackgroundTransparency = 1
            
            local success, thumb = pcall(function()
                return Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size42x42)
            end)
            if success then
                img.Image = thumb
            end
            
            Instance.new("UICorner", img).CornerRadius = UDim.new(1, 0)
            
            btn.MouseButton1Click:Connect(function()
                flingTarget = player
                isFlinging = true
            end)
        end
    end
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, uiList.AbsoluteContentSize.Y)
end

Players.PlayerAdded:Connect(updatePlayerList)
Players.PlayerRemoving:Connect(updatePlayerList)
task.spawn(updatePlayerList)

toggleBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)

stopBtn.MouseButton1Click:Connect(function()
    isFlinging = false
    flingTarget = nil
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
        char.HumanoidRootPart.RotVelocity = Vector3.new(0, 0, 0)
    end
end)

antiBtn.MouseButton1Click:Connect(function()
    antiFlingEnabled = not antiFlingEnabled
    if antiFlingEnabled then
        antiBtn.Text = "アンチフリング: ON"
        antiBtn.BackgroundColor3 = Color3.fromRGB(40, 180, 40)
    else
        antiBtn.Text = "アンチフリング: OFF"
        antiBtn.BackgroundColor3 = Color3.fromRGB(40, 120, 180)
    end
end)

local function removeESP(player)
    if player.Character and player.Character:FindFirstChild("HackerHub_Highlight") then
        player.Character.HackerHub_Highlight:Destroy()
    end
end

local function addESP(player)
    if player ~= LocalPlayer and player.Character then
        if not player.Character:FindFirstChild("HackerHub_Highlight") then
            local hl = Instance.new("Highlight")
            hl.Name = "HackerHub_Highlight"
            hl.Adornee = player.Character
            hl.FillColor = Color3.fromRGB(255, 0, 0)
            hl.OutlineColor = Color3.fromRGB(255, 255, 255)
            hl.Parent = player.Character
        end
    end
end

espTopBtn.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    if espEnabled then
        espTopBtn.Text = "ESP: ON"
        espTopBtn.BackgroundColor3 = Color3.fromRGB(40, 180, 40)
        for _, p in ipairs(Players:GetPlayers()) do addESP(p) end
    else
        espTopBtn.Text = "ESP: OFF"
        espTopBtn.BackgroundColor3 = Color3.fromRGB(120, 40, 180)
        for _, p in ipairs(Players:GetPlayers()) do removeESP(p) end
    end
end)

RunService.Heartbeat:Connect(function()
    if isFlinging and flingTarget and flingTarget.Character and flingTarget.Character:FindFirstChild("HumanoidRootPart") then
        local localChar = LocalPlayer.Character
        if localChar and localChar:FindFirstChild("HumanoidRootPart") and localChar:FindFirstChild("Humanoid") then
            local root = localChar.HumanoidRootPart
            local targetRoot = flingTarget.Character.HumanoidRootPart
            
            for _, part in ipairs(localChar:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
            
            local cam = workspace.CurrentCamera
            if cam then
                cam.CameraSubject = flingTarget.Character.Humanoid
            end
            
            local angle = tick() * 35
            local offset = Vector3.new(math.cos(angle) * 1.5, 0, math.sin(angle) * 1.5)
            root.CFrame = targetRoot.CFrame + offset
            
            root.Velocity = Vector3.new(999999, 999999, 999999)
            root.RotVelocity = Vector3.new(999999, 999999, 999999)
        end
    else
        local localChar = LocalPlayer.Character
        if localChar and localChar:FindFirstChild("Humanoid") then
            local cam = workspace.CurrentCamera
            if cam and cam.CameraSubject ~= localChar.Humanoid and isFlinging == false then
                cam.CameraSubject = localChar.Humanoid
            end
        end
    end
    
    if antiFlingEnabled then
        local localChar = LocalPlayer.Character
        if localChar and localChar:FindFirstChild("HumanoidRootPart") then
            local root = localChar.HumanoidRootPart
            if root.Velocity.Magnitude > 100 or root.RotVelocity.Magnitude > 100 then
                root.Velocity = Vector3.new(0, 0, 0)
                root.RotVelocity = Vector3.new(0, 0, 0)
            end
        end
    end
    
    if espEnabled then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and not p.Character:FindFirstChild("HackerHub_Highlight") then
                addESP(p)
            end
        end
    end
end)