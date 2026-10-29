local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local rootPart = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

local remotes = ReplicatedStorage:WaitForChild("Remotes", 5)
local gameplayRemotes = remotes and remotes:WaitForChild("Gameplay", 5)

---------------------------------------------------------
-- CONFIG (الإعدادات الافتراضية)
---------------------------------------------------------
local MAX_DIST = 1000 
local TARGET_SPEED = 23 
local RESET_DELAY = 5.0 
local ROUND_START_DELAY = 1.5
---------------------------------------------------------

local enabled = false
local afkActive = false
local isLoaded = false
local bagIsFull = false
local isWaitingForCoins = false 
local activeCoins = {} 
local blacklistedCoins = {} 
local currentTarget = nil
local noCoinsStartTime = nil 
local hasCollectedThisLife = false 

local linearVelocity = nil
local velocityAttachment = nil
local noclipConnection = nil 
local heartbeatConnection = nil
local coinAddedConnection = nil
local coinRemovedConnection = nil
local coinsStartedConnection = nil
local coinCollectedConnection = nil
local targetFinderThread = nil
local characterAddedConnection = nil

local characterParts = {}

local function updateCharacterParts()
    characterParts = {}
    if not character then return end
    for _, part in ipairs(character:GetChildren()) do
        if part:IsA("BasePart") then
            table.insert(characterParts, part)
        end
    end
end

local function restoreCollision()
    for _, part in ipairs(characterParts) do
        if part and part.Parent then
            part.CanCollide = true
        end
    end
end

local function cleanupConnections()
    if heartbeatConnection then heartbeatConnection:Disconnect() heartbeatConnection = nil end
    if noclipConnection then noclipConnection:Disconnect() noclipConnection = nil end
    if coinAddedConnection then coinAddedConnection:Disconnect() coinAddedConnection = nil end
    if coinRemovedConnection then coinRemovedConnection:Disconnect() coinRemovedConnection = nil end
    if coinsStartedConnection then coinsStartedConnection:Disconnect() coinsStartedConnection = nil end
    if coinCollectedConnection then coinCollectedConnection:Disconnect() coinCollectedConnection = nil end
end

local function stopMovement()
    if linearVelocity then
        linearVelocity.VectorVelocity = Vector3.zero
        linearVelocity.Enabled = false
    end
    if rootPart then
        rootPart.AssemblyLinearVelocity = Vector3.zero
        rootPart.AssemblyAngularVelocity = Vector3.zero
    end
end

local function setupVelocity()
    if not rootPart then return end
    
    velocityAttachment = rootPart:FindFirstChild("FarmAttachment")
    if not velocityAttachment then
        velocityAttachment = Instance.new("Attachment")
        velocityAttachment.Name = "FarmAttachment"
        velocityAttachment.Parent = rootPart
    end

    linearVelocity = rootPart:FindFirstChild("FarmLinearVelocity")
    if not linearVelocity then
        linearVelocity = Instance.new("LinearVelocity")
        linearVelocity.Name = "FarmLinearVelocity"
        linearVelocity.Attachment0 = velocityAttachment
        linearVelocity.VelocityConstraintMode = Enum.VelocityConstraintMode.Vector
        linearVelocity.RelativeTo = Enum.ActuatorRelativeTo.World
        linearVelocity.VectorVelocity = Vector3.zero
        linearVelocity.Enabled = false
        linearVelocity.ForceLimitMode = Enum.ForceLimitMode.PerAxis
        linearVelocity.MaxAxesForce = Vector3.new(100000, 100000, 100000)
        linearVelocity.Parent = rootPart
    end
end

local function removeVelocity()
    if linearVelocity then linearVelocity:Destroy() linearVelocity = nil end
    if velocityAttachment then velocityAttachment:Destroy() velocityAttachment = nil end
end

local function startNoclip()
    if noclipConnection then noclipConnection:Disconnect() end
    updateCharacterParts()
    
    noclipConnection = RunService.Stepped:Connect(function()
        if character and enabled and humanoid and humanoid.Health > 0 and not bagIsFull and not isWaitingForCoins then
            for i = 1, #characterParts do
                local part = characterParts[i]
                if part and part.Parent and part.CanCollide then
                    part.CanCollide = false
                end
            end
        end
    end)
    
    if humanoid then
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing, false)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
    end
end

local function stopNoclip()
    if noclipConnection then
        noclipConnection:Disconnect()
        noclipConnection = nil
    end
    restoreCollision()
end

local function antiAfkLoop()
    while afkActive and enabled do
        task.wait(30)
        if not afkActive or not enabled then break end
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end
end

local function isCoin(part)
    if not part:IsA("BasePart") or blacklistedCoins[part] then return false end 
    local name = part.Name:lower()
    return name:find("coin") or name:find("cash") or name:find("money") or name:find("collect")
end

local function checkGuiBagFull()
    local playerGui = player:FindFirstChild("PlayerGui")
    if not playerGui then return false end
    
    for _, gui in ipairs(playerGui:GetChildren()) do
        if gui:IsA("ScreenGui") and gui.Name ~= "AutoFarmUI" then
            local container = gui:FindFirstChild("Container", true)
            if container then
                for _, frame in ipairs(container:GetChildren()) do
                    if frame:IsA("Frame") and frame.Visible then
                        local fullIcon = frame:FindFirstChild("FullBagIcon", true)
                        local fullText = frame:FindFirstChild("Full", true)
                        if (fullIcon and fullIcon.Visible) or (fullText and fullText.Visible) then
                            return true
                        end
                    end
                end
            end
        end
    end
    return false
end

local function trackCoin(part)
    if isCoin(part) then
        activeCoins[part] = true
    end
end

local function untrackCoin(part)
    activeCoins[part] = nil
    if currentTarget == part then
        currentTarget = nil
    end
end

local function triggerBagFullReset()
    if bagIsFull then return end
    bagIsFull = true
    stopMovement()
    stopNoclip()
    
    task.wait(0.2)
    if humanoid and humanoid.Health > 0 then
        humanoid.Health = 0
    end
end

local function initCoinListeners()
    activeCoins = {}
    
    for _, v in ipairs(Workspace:GetDescendants()) do
        if isCoin(v) then
            activeCoins[v] = true
        end
    end
    
    coinAddedConnection = Workspace.DescendantAdded:Connect(trackCoin)
    coinRemovedConnection = Workspace.DescendantRemoving:Connect(untrackCoin)

    if gameplayRemotes then
        local coinsStartedRemote = gameplayRemotes:WaitForChild("CoinsStarted", 5)
        local coinCollectedRemote = gameplayRemotes:WaitForChild("CoinCollected", 5)

        if coinsStartedRemote then
            coinsStartedConnection = coinsStartedRemote.OnClientEvent:Connect(function()
                isWaitingForCoins = true
                stopMovement()
                currentTarget = nil
                activeCoins = {}
                blacklistedCoins = {}
                noCoinsStartTime = nil
                bagIsFull = false
                
                task.wait(ROUND_START_DELAY)
                
                for _, v in ipairs(Workspace:GetDescendants()) do
                    if isCoin(v) then
                        activeCoins[v] = true
                    end
                end
                
                isWaitingForCoins = false
            end)
        end

        if coinCollectedRemote then
            coinCollectedConnection = coinCollectedRemote.OnClientEvent:Connect(function(coinType, currentAmount, maxAmount)
                local current = tonumber(currentAmount)
                local max = tonumber(maxAmount)
                
                if current and max and current >= max then
                    triggerBagFullReset()
                end
            end)
        end
    end
end

local function startTargetFinder()
    if targetFinderThread then task.cancel(targetFinderThread) end
    
    targetFinderThread = task.spawn(function()
        while isLoaded do
            task.wait(0.1)
            
            if enabled and not bagIsFull and checkGuiBagFull() then
                triggerBagFullReset()
            end

            if enabled and not bagIsFull and not isWaitingForCoins and rootPart then
                local rootPos = rootPart.Position
                local nearest = nil
                local nearestDist = MAX_DIST + 1
                
                for coin, _ in pairs(activeCoins) do
                    if coin and coin.Parent and not blacklistedCoins[coin] then
                        local dist = (coin.Position - rootPos).Magnitude
                        if dist < nearestDist then
                            nearestDist = dist
                            nearest = coin
                        end
                    else
                        activeCoins[coin] = nil
                    end
                end
                
                if nearest and not nearest:FindFirstChild("CoinVisual") then
                    activeCoins[nearest] = nil
                    nearest = nil
                end
                
                currentTarget = nearest
            end
        end
    end)
end

local function startMovementEngine()
    cleanupConnections()
    setupVelocity()
    initCoinListeners()
    noCoinsStartTime = nil
    
    if enabled and not bagIsFull then startNoclip() end
    
    heartbeatConnection = RunService.Heartbeat:Connect(function()
        if not enabled or bagIsFull or isWaitingForCoins or not rootPart or not rootPart.Parent or not humanoid or humanoid.Health <= 0 then 
            stopMovement()
            return 
        end
        
        if currentTarget and currentTarget.Parent and not blacklistedCoins[currentTarget] then
            noCoinsStartTime = nil
            local targetPos = currentTarget.Position
            local rootPos = rootPart.Position
            local dist = (targetPos - rootPos).Magnitude
            
            if dist <= 1.2 then
                rootPart.CFrame = CFrame.new(targetPos)
                stopMovement()
                
                hasCollectedThisLife = true
                blacklistedCoins[currentTarget] = true
                activeCoins[currentTarget] = nil
                currentTarget = nil
            else
                if linearVelocity then
                    linearVelocity.Enabled = true
                    linearVelocity.VectorVelocity = (targetPos - rootPos).Unit * TARGET_SPEED
                end
            end
        else
            stopMovement()
            
            if hasCollectedThisLife then
                if not noCoinsStartTime then
                    noCoinsStartTime = os.clock()
                elseif os.clock() - noCoinsStartTime >= RESET_DELAY then
                    noCoinsStartTime = nil 
                    cleanupConnections()
                    humanoid.Health = 0 
                end
            else
                noCoinsStartTime = nil
            end
        end
    end)
end

local function unloadScript()
    isLoaded = false
    enabled = false
    afkActive = false
    bagIsFull = false
    isWaitingForCoins = false
    
    cleanupConnections()
    stopNoclip()
    removeVelocity()
    
    if targetFinderThread then
        task.cancel(targetFinderThread)
        targetFinderThread = nil
    end
    if characterAddedConnection then
        characterAddedConnection:Disconnect()
        characterAddedConnection = nil
    end
    
    activeCoins = {}
    blacklistedCoins = {}
    currentTarget = nil
end

local function loadScript()
    if isLoaded then unloadScript() end
    isLoaded = true
    bagIsFull = false
    isWaitingForCoins = false
    
    character = player.Character or player.CharacterAdded:Wait()
    rootPart = character:WaitForChild("HumanoidRootPart")
    humanoid = character:WaitForChild("Humanoid")
    
    blacklistedCoins = {}
    noCoinsStartTime = nil
    hasCollectedThisLife = false
    
    startTargetFinder()
    startMovementEngine()
    
    if characterAddedConnection then characterAddedConnection:Disconnect() end
    characterAddedConnection = player.CharacterAdded:Connect(function(newChar)
        cleanupConnections()
        removeVelocity()
        
        character = newChar
        rootPart = character:WaitForChild("HumanoidRootPart")
        humanoid = character:WaitForChild("Humanoid")
        
        blacklistedCoins = {} 
        noCoinsStartTime = nil
        hasCollectedThisLife = false 
        bagIsFull = false
        isWaitingForCoins = false
        
        task.wait(1.5)
        if isLoaded and enabled then
            startMovementEngine()
        end
    end)
end

---------------------------------------------------------
-- UI CREATION
---------------------------------------------------------
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AutoFarmUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player:WaitForChild("PlayerGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 270, 0, 220)
Main.Position = UDim2.new(0.5, -135, 0.5, -110)
Main.BackgroundColor3 = Color3.fromRGB(22, 16, 32)
Main.BackgroundTransparency = 0.05
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = Main

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(255, 130, 40)
MainStroke.Thickness = 2
MainStroke.Parent = Main

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 38)
Header.BackgroundTransparency = 1
Header.Parent = Main

local CoinIcon = Instance.new("TextLabel")
CoinIcon.Size = UDim2.new(0, 20, 0, 20)
CoinIcon.Position = UDim2.new(0, 12, 0.5, -10)
CoinIcon.BackgroundTransparency = 1
CoinIcon.Text = "🦄"
CoinIcon.Font = Enum.Font.GothamBold
CoinIcon.TextSize = 16
CoinIcon.Parent = Header

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 190, 0, 20)
Title.Position = UDim2.new(0, 36, 0.5, -10)
Title.BackgroundTransparency = 1
Title.Text = "silverunicorn auto farm"
Title.TextColor3 = Color3.fromRGB(255, 170, 80)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 12
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 26, 0, 26)
MinimizeBtn.Position = UDim2.new(1, -32, 0.5, -13)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(140, 50, 200)
MinimizeBtn.BackgroundTransparency = 0.2
MinimizeBtn.Text = "-"
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.TextSize = 16
MinimizeBtn.Parent = Header

local MinimizeCorner = Instance.new("UICorner")
MinimizeCorner.CornerRadius = UDim.new(1, 13)
MinimizeCorner.Parent = MinimizeBtn

local ContentContainer = Instance.new("Frame")
ContentContainer.Size = UDim2.new(1, 0, 1, -38)
ContentContainer.Position = UDim2.new(0, 0, 0, 38)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Parent = Main

local Row1 = Instance.new("Frame")
Row1.Size = UDim2.new(1, -16, 0, 40)
Row1.Position = UDim2.new(0, 8, 0, 8)
Row1.BackgroundColor3 = Color3.fromRGB(38, 25, 50)
Row1.BackgroundTransparency = 0.1
Row1.BorderSizePixel = 0
Row1.Parent = ContentContainer

local Row1Corner = Instance.new("UICorner")
Row1Corner.CornerRadius = UDim.new(0, 8)
Row1Corner.Parent = Row1

local Row1Stroke = Instance.new("UIStroke")
Row1Stroke.Color = Color3.fromRGB(180, 80, 220)
Row1Stroke.Thickness = 1.5
Row1Stroke.Parent = Row1

local Row1Label = Instance.new("TextLabel")
Row1Label.Size = UDim2.new(0.5, 0, 1, 0)
Row1Label.Position = UDim2.new(0, 12, 0, 0)
Row1Label.BackgroundTransparency = 1
Row1Label.Text = "Auto Farm"
Row1Label.TextColor3 = Color3.fromRGB(240, 220, 255)
Row1Label.Font = Enum.Font.GothamMedium
Row1Label.TextSize = 14
Row1Label.TextXAlignment = Enum.TextXAlignment.Left
Row1Label.Parent = Row1

local Row2 = Instance.new("Frame")
Row2.Size = UDim2.new(1, -16, 0, 40)
Row2.Position = UDim2.new(0, 8, 0, 56)
Row2.BackgroundColor3 = Color3.fromRGB(38, 25, 50)
Row2.BackgroundTransparency = 0.1
Row2.BorderSizePixel = 0
Row2.Parent = ContentContainer

local Row2Corner = Instance.new("UICorner")
Row2Corner.CornerRadius = UDim.new(0, 8)
Row2Corner.Parent = Row2

local Row2Stroke = Instance.new("UIStroke")
Row2Stroke.Color = Color3.fromRGB(180, 80, 220)
Row2Stroke.Thickness = 1.5
Row2Stroke.Parent = Row2

local Row2Label = Instance.new("TextLabel")
Row2Label.Size = UDim2.new(0.5, 0, 1, 0)
Row2Label.Position = UDim2.new(0, 12, 0, 0)
Row2Label.BackgroundTransparency = 1
Row2Label.Text = "Anti-AFK"
Row2Label.TextColor3 = Color3.fromRGB(240, 220, 255)
Row2Label.Font = Enum.Font.GothamMedium
Row2Label.TextSize = 14
Row2Label.TextXAlignment = Enum.TextXAlignment.Left
Row2Label.Parent = Row2

local SpeedRow = Instance.new("Frame")
SpeedRow.Size = UDim2.new(1, -16, 0, 50)
SpeedRow.Position = UDim2.new(0, 8, 0, 104)
SpeedRow.BackgroundColor3 = Color3.fromRGB(38, 25, 50)
SpeedRow.BackgroundTransparency = 0.1
SpeedRow.BorderSizePixel = 0
SpeedRow.Parent = ContentContainer

local SpeedRowCorner = Instance.new("UICorner")
SpeedRowCorner.CornerRadius = UDim.new(0, 8)
SpeedRowCorner.Parent = SpeedRow

local SpeedRowStroke = Instance.new("UIStroke")
SpeedRowStroke.Color = Color3.fromRGB(180, 80, 220)
SpeedRowStroke.Thickness = 1.5
SpeedRowStroke.Parent = SpeedRow

local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Size = UDim2.new(0.6, 0, 0, 20)
SpeedLabel.Position = UDim2.new(0, 12, 0, 5)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Text = "Speed: 23"
SpeedLabel.TextColor3 = Color3.fromRGB(255, 170, 80)
SpeedLabel.Font = Enum.Font.GothamMedium
SpeedLabel.TextSize = 13
SpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
SpeedLabel.Parent = SpeedRow

local SliderBar = Instance.new("TextButton")
SliderBar.Size = UDim2.new(1, -24, 0, 10)
SliderBar.Position = UDim2.new(0, 12, 0, 30)
SliderBar.BackgroundColor3 = Color3.fromRGB(55, 45, 70)
SliderBar.BorderSizePixel = 0
SliderBar.Text = ""
SliderBar.Parent = SpeedRow

local SliderBarCorner = Instance.new("UICorner")
SliderBarCorner.CornerRadius = UDim.new(1, 5)
SliderBarCorner.Parent = SliderBar

local SliderFill = Instance.new("Frame")
SliderFill.Size = UDim2.new((TARGET_SPEED - 10) / 20, 0, 1, 0)
SliderFill.BackgroundColor3 = Color3.fromRGB(255, 130, 40)
SliderFill.BorderSizePixel = 0
SliderFill.Parent = SliderBar

local SliderFillCorner = Instance.new("UICorner")
SliderFillCorner.CornerRadius = UDim.new(1, 5)
SliderFillCorner.Parent = SliderFill

 local function createToggle(parent, initialVal, callback)
    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 44, 0, 24)
    toggle.Position = UDim2.new(1, -52, 0.5, -12)
    toggle.BackgroundColor3 = initialVal and Color3.fromRGB(255, 130, 40) or Color3.fromRGB(55, 45, 70)
    toggle.Text = ""
    toggle.BorderSizePixel = 0
    toggle.Parent = parent

    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(1, 12)
    toggleCorner.Parent = toggle

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 18, 0, 18)
    knob.Position = initialVal and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.BorderSizePixel = 0
    knob.Parent = toggle

    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 9)
    knobCorner.Parent = knob

    local state = initialVal
    toggle.MouseButton1Click:Connect(function()
        state = not state
        local goalPos = state and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
        local goalBg = state and Color3.fromRGB(255, 130, 40) or Color3.fromRGB(55, 45, 70)
        TweenService:Create(toggle, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {BackgroundColor3 = goalBg}):Play()
        TweenService:Create(knob, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {Position = goalPos}):Play()
        callback(state)
    end)
    return toggle
end

createToggle(Row1, false, function(state)
    enabled = state
    if state then
        if not isLoaded then loadScript() end
        startMovementEngine()
        if afkActive then task.spawn(antiAfkLoop) end
    else
        stopMovement()
        stopNoclip()
        noCoinsStartTime = nil
    end
end)

createToggle(Row2, false, function(state)
    afkActive = state
    if state and enabled then task.spawn(antiAfkLoop) end
end)

local draggingSlider = false

local function updateSlider(input)
    local mousePos = input.Position.X
    local barPos = SliderBar.AbsolutePosition.X
    local barSize = SliderBar.AbsoluteSize.X
    
    local relativeX = math.clamp((mousePos - barPos) / barSize, 0, 1)
    SliderFill.Size = UDim2.new(relativeX, 0, 1, 0)
    
    TARGET_SPEED = math.floor(10 + (relativeX * 20))
    SpeedLabel.Text = "Speed: " .. TARGET_SPEED
end

SliderBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingSlider = true
        updateSlider(input)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingSlider = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if draggingSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        updateSlider(input)
    end
end)

local isMinimized = false
MinimizeBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    
    if isMinimized then
        MinimizeBtn.Text = "+"
        TweenService:Create(Main, tweenInfo, {Size = UDim2.new(0, 270, 0, 38)}):Play()
        ContentContainer.Visible = false
    else
        MinimizeBtn.Text = "-"
        ContentContainer.Visible = true
        TweenService:Create(Main, tweenInfo, {Size = UDim2.new(0, 270, 0, 220)}):Play()
    end
end)

local dragging, dragStart, startPos = false, nil, nil

Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Main.Position
        input.UserInputState = Enum.UserInputState.Sink
    end
end)

Header.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then 
        dragging = false 
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

loadScript()
