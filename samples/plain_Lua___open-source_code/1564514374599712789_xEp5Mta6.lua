local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local lp = Players.LocalPlayer

local events = ReplicatedStorage:WaitForChild("events")
local slapRemote = events:WaitForChild("SendSlap")
local queueRemote = events:WaitForChild("SlapQueue")
local guessRemote = events:WaitForChild("Guess")
local exitRemote = events:WaitForChild("Exit")

local function createSpecialTag(playerName, displayText, textColor, strokeColor, font, textSize, offsetY, maxDist)
    local target = Players:FindFirstChild(playerName)
    if not target then return end

    local char = target.Character or target.CharacterAdded:Wait()
    local head = char:WaitForChild("Head", 8)

    local bb = Instance.new("BillboardGui")
    bb.Name = playerName .. "Tag"
    bb.Adornee = head
    bb.Size = UDim2.new(0, 260, 0, 60)
    bb.StudsOffset = Vector3.new(0, offsetY or 3.5, 0)
    bb.AlwaysOnTop = true
    bb.LightInfluence = 0
    bb.MaxDistance = maxDist or 1200
    bb.ResetOnSpawn = false
    bb.Parent = lp.PlayerGui

    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(1, 0, 1, 0)
    text.BackgroundTransparency = 1
    text.Text = displayText
    text.TextColor3 = textColor
    text.TextStrokeTransparency = 0.4
    text.TextStrokeColor3 = strokeColor or Color3.new(0,0,0)
    text.Font = font or Enum.Font.GothamBlack
    text.TextSize = textSize or 28
    text.Parent = bb

    local glow = Instance.new("UIStroke")
    glow.Color = textColor
    glow.Thickness = 1.8
    glow.Transparency = 0.6
    glow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    glow.Parent = text

    target.CharacterAdded:Connect(function(newChar)
        local newHead = newChar:WaitForChild("Head", 8)
        if newHead then
            bb.Adornee = newHead
        end
    end)
end

createSpecialTag("guestzermember2", "subscribe to Flusspy", Color3.fromRGB(255, 215, 0), Color3.new(0,0,0), Enum.Font.GothamBlack, 28, 3.5, 1200)
createSpecialTag("silencedemotion0", "Pure Evil scripter", Color3.fromRGB(220, 20, 60), Color3.fromRGB(100, 0, 150), Enum.Font.Arcade, 30, 4.2, 1000)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SlapDamageGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game.CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 260, 0, 420)
MainFrame.Position = UDim2.new(0.5, -130, 0.5, -210)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 28)
TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
TitleBar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -40, 1, 0)
Title.Position = UDim2.new(0, 8, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Slap Control"
Title.TextColor3 = Color3.fromRGB(220, 220, 220)
Title.TextSize = 12
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 22, 0, 22)
CloseButton.Position = UDim2.new(1, -26, 0.5, -11)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Text = "X"
CloseButton.TextSize = 14
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = TitleBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 4)
CloseCorner.Parent = CloseButton

local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, -12, 1, -50)
ContentFrame.Position = UDim2.new(0, 6, 0, 40)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(1, 0, 1, 0)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.ScrollBarThickness = 2
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 100)
ScrollFrame.Parent = ContentFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 6)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Parent = ScrollFrame

local function createInput(labelText, placeholder, default)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 48)
    frame.BackgroundTransparency = 1
    frame.LayoutOrder = #ScrollFrame:GetChildren()
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 16)
    label.BackgroundTransparency = 1
    label.Text = labelText
    label.TextColor3 = Color3.fromRGB(180, 180, 200)
    label.TextSize = 11
    label.Font = Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local box = Instance.new("TextBox")
    box.Size = UDim2.new(1, 0, 0, 28)
    box.Position = UDim2.new(0, 0, 0, 16)
    box.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    box.TextColor3 = Color3.fromRGB(240, 240, 240)
    box.PlaceholderText = placeholder
    box.Text = default
    box.TextSize = 13
    box.Font = Enum.Font.Gotham
    box.Parent = frame
    
    local boxCorner = Instance.new("UICorner")
    boxCorner.CornerRadius = UDim.new(0, 4)
    boxCorner.Parent = box
    
    frame.Parent = ScrollFrame
    return box
end

local DamageBox = createInput("Damage", "9999", "9999")
local SpeedBox = createInput("Speed (1-20)", "18", "18")

local toggleStates = {
    autoSlap = false,
    autoQueue = false,
    autoGuess = false,
    autoPlot = false,
    autoSlap1s = false
}

local runningThreads = {
    autoSlap = nil,
    autoQueue = nil,
    autoGuess = nil,
    autoPlot = nil,
    autoSlap1s = nil
}

local buttonColors = {
    autoSlap = Color3.fromRGB(255, 80, 80),
    autoQueue = Color3.fromRGB(80, 180, 255),
    autoGuess = Color3.fromRGB(80, 255, 120),
    autoPlot = Color3.fromRGB(180, 80, 255),
    autoSlap1s = Color3.fromRGB(255, 180, 50)
}

local function createToggle(name, displayName, color)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Size = UDim2.new(1, 0, 0, 32)
    button.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    button.TextColor3 = Color3.fromRGB(240, 240, 240)
    button.Font = Enum.Font.GothamMedium
    button.TextSize = 12
    button.Text = displayName .. " (OFF)"
    button.AutoButtonColor = false
    button.LayoutOrder = #ScrollFrame:GetChildren()
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = button
    
    local function updateButton()
        if toggleStates[name] then
            button.Text = displayName .. " (ON)"
            button.BackgroundColor3 = color
        else
            button.Text = displayName .. " (OFF)"
            button.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
        end
    end
    
    updateButton()
    button.Parent = ScrollFrame
    
    return button
end

local AutoSlapButton = createToggle("autoSlap", "Auto Slap", buttonColors.autoSlap)
local AutoQueueButton = createToggle("autoQueue", "Auto Queue", buttonColors.autoQueue)
local AutoGuessButton = createToggle("autoGuess", "Auto Guess", buttonColors.autoGuess)
local AutoPlotButton = createToggle("autoPlot", "Auto Plot", buttonColors.autoPlot)
local AutoSlap1sButton = createToggle("autoSlap1s", "Auto Slap 1s", buttonColors.autoSlap1s)

local PlotBugButton = Instance.new("TextButton")
PlotBugButton.Size = UDim2.new(1, 0, 0, 32)
PlotBugButton.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
PlotBugButton.TextColor3 = Color3.fromRGB(240, 240, 240)
PlotBugButton.Font = Enum.Font.GothamBold
PlotBugButton.TextSize = 13
PlotBugButton.Text = "PLOT BUG"
PlotBugButton.AutoButtonColor = false
PlotBugButton.LayoutOrder = #ScrollFrame:GetChildren()

local PlotBugCorner = Instance.new("UICorner")
PlotBugCorner.CornerRadius = UDim.new(0, 4)
PlotBugCorner.Parent = PlotBugButton

PlotBugButton.Parent = ScrollFrame

UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y)
end)

local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 36, 0, 36)
ToggleButton.Position = UDim2.new(0, 8, 0, 8)
ToggleButton.BackgroundColor3 = Color3.fromRGB(40, 120, 200)
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Text = "≡"
ToggleButton.TextSize = 16
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.Parent = ScreenGui

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 6)
ToggleCorner.Parent = ToggleButton

ToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
    ToggleButton.Visible = not MainFrame.Visible
end)

CloseButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    ToggleButton.Visible = true
end)

local dragStart, startPos
local function updateInput(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragStart = nil
            end
        end)
    end
end

local function updateDrag(input)
    if dragStart and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end

TitleBar.InputBegan:Connect(updateInput)
TitleBar.InputChanged:Connect(updateDrag)

local function showNotification(message)
    local notif = Instance.new("TextLabel")
    notif.Size = UDim2.new(0, 250, 0, 60)
    notif.Position = UDim2.new(0.5, -125, 0.2, 0)
    notif.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    notif.TextColor3 = Color3.fromRGB(240, 240, 240)
    notif.Text = message
    notif.TextSize = 13
    notif.Font = Enum.Font.GothamMedium
    notif.TextWrapped = true
    notif.ZIndex = 10
    notif.Parent = ScreenGui
    
    local notifCorner = Instance.new("UICorner")
    notifCorner.CornerRadius = UDim.new(0, 6)
    notifCorner.Parent = notif
    
    task.wait(2.5)
    notif:Destroy()
end

local function updateButtonAppearance(button, isOn)
    if isOn then
        button.Text = string.gsub(button.Text, "%(OFF%)", "(ON)")
        button.BackgroundColor3 = Color3.fromRGB(40, 120, 200)
    else
        button.Text = string.gsub(button.Text, "%(ON%)", "(OFF)")
        button.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    end
end

local function checkIfSitting()
    pcall(function()
        local character = lp.Character
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                return humanoid.Sit
            end
        end
    end)
    return false
end

AutoSlapButton.MouseButton1Click:Connect(function()
    toggleStates.autoSlap = not toggleStates.autoSlap
    updateButtonAppearance(AutoSlapButton, toggleStates.autoSlap)
    
    if toggleStates.autoSlap then
        runningThreads.autoSlap = task.spawn(function()
            while toggleStates.autoSlap do
                if not checkIfSitting() then
                    local damage = tonumber(DamageBox.Text) or 9999
                    local speed = math.clamp(tonumber(SpeedBox.Text) or 15, 1, 20)
                    
                    pcall(function() 
                        slapRemote:FireServer(damage) 
                    end)
                    task.wait(0.5 / speed)
                else
                    task.wait(0.1)
                end
            end
        end)
    else
        if runningThreads.autoSlap then
            task.cancel(runningThreads.autoSlap)
            runningThreads.autoSlap = nil
        end
    end
end)

AutoQueueButton.MouseButton1Click:Connect(function()
    toggleStates.autoQueue = not toggleStates.autoQueue
    updateButtonAppearance(AutoQueueButton, toggleStates.autoQueue)
    
    if toggleStates.autoQueue then
        runningThreads.autoQueue = task.spawn(function()
            while toggleStates.autoQueue do
                pcall(function() 
                    queueRemote:FireServer() 
                end)
                task.wait(0.1)
            end
        end)
    else
        if runningThreads.autoQueue then
            task.cancel(runningThreads.autoQueue)
            runningThreads.autoQueue = nil
        end
    end
end)

AutoGuessButton.MouseButton1Click:Connect(function()
    toggleStates.autoGuess = not toggleStates.autoGuess
    updateButtonAppearance(AutoGuessButton, toggleStates.autoGuess)
    
    if toggleStates.autoGuess then
        runningThreads.autoGuess = task.spawn(function()
            while toggleStates.autoGuess do
                local root = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
                if root then
                    local closest, minDist = nil, math.huge
                    for _, player in ipairs(Players:GetPlayers()) do
                        if player ~= lp and player.Character then
                            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                            if hrp then
                                local dist = (hrp.Position - root.Position).Magnitude
                                if dist < minDist then
                                    minDist = dist
                                    closest = player
                                end
                            end
                        end
                    end
                    
                    if closest then
                        pcall(function() 
                            guessRemote:FireServer(closest.Name) 
                        end)
                    end
                end
                task.wait(0.5)
            end
        end)
    else
        if runningThreads.autoGuess then
            task.cancel(runningThreads.autoGuess)
            runningThreads.autoGuess = nil
        end
    end
end)

AutoPlotButton.MouseButton1Click:Connect(function()
    toggleStates.autoPlot = not toggleStates.autoPlot
    updateButtonAppearance(AutoPlotButton, toggleStates.autoPlot)
    
    if toggleStates.autoPlot then
        runningThreads.autoPlot = task.spawn(function()
            pcall(function()
                local catcher = Workspace:FindFirstChild("catcher")
                if catcher then
                    catcher:Destroy()
                end
            end)
            
            while toggleStates.autoPlot do
                pcall(function()
                    local character = lp.Character
                    if character then
                        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                        if humanoidRootPart then
                            local fireTouchInterest = loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Fire-all-Touch-Interests-60782"))()
                            if fireTouchInterest then
                                fireTouchInterest()
                            end
                        end
                    end
                end)
                task.wait(0.3)
            end
        end)
    else
        if runningThreads.autoPlot then
            task.cancel(runningThreads.autoPlot)
            runningThreads.autoPlot = nil
        end
    end
end)

AutoSlap1sButton.MouseButton1Click:Connect(function()
    toggleStates.autoSlap1s = not toggleStates.autoSlap1s
    updateButtonAppearance(AutoSlap1sButton, toggleStates.autoSlap1s)
    
    if toggleStates.autoSlap1s then
        runningThreads.autoSlap1s = task.spawn(function()
            while toggleStates.autoSlap1s do
                if not checkIfSitting() then
                    local damage = tonumber(DamageBox.Text) or 9999
                    pcall(function() 
                        slapRemote:FireServer(damage) 
                    end)
                    task.wait(1.0)
                else
                    task.wait(0.1)
                end
            end
        end)
    else
        if runningThreads.autoSlap1s then
            task.cancel(runningThreads.autoSlap1s)
            runningThreads.autoSlap1s = nil
        end
    end
end)

PlotBugButton.MouseButton1Click:Connect(function()
    showNotification("Make sure you are in a plot that hasn't started yet!")
    
    pcall(function()
        queueRemote:FireServer()
        exitRemote:FireServer()
        
        loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-better-fix-camera-than-iy-46746"))()
    end)
end)

if UserInputService.TouchEnabled then
    MainFrame.Size = UDim2.new(0, 180, 0, 290)
    MainFrame.Position = UDim2.new(0.5, -90, 0.5, -145)
    
    ToggleButton.Size = UDim2.new(0, 28, 0, 28)
    
    TitleBar.Size = UDim2.new(1, 0, 0, 24)
    Title.TextSize = 10
    
    CloseButton.Size = UDim2.new(0, 18, 0, 18)
    CloseButton.Position = UDim2.new(1, -20, 0.5, -9)
    CloseButton.TextSize = 12
    
    ContentFrame.Size = UDim2.new(1, -8, 1, -40)
    ContentFrame.Position = UDim2.new(0, 4, 0, 35)
    
    ScrollFrame.ScrollBarThickness = 1
    
    for _, child in pairs(ScrollFrame:GetChildren()) do
        if child:IsA("Frame") then
            child.Size = UDim2.new(1, 0, 0, 40)
            local label = child:FindFirstChildOfClass("TextLabel")
            if label then
                label.TextSize = 9
            end
            local box = child:FindFirstChildOfClass("TextBox")
            if box then
                box.Size = UDim2.new(1, 0, 0, 24)
                box.Position = UDim2.new(0, 0, 0, 14)
                box.TextSize = 11
            end
        elseif child:IsA("TextButton") then
            child.Size = UDim2.new(1, 0, 0, 26)
            child.TextSize = 10
        end
    end
end