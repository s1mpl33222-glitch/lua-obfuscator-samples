-- deno wuz here 3 year old source updated lol took 5 hours but worth I added hiding tween myself

if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local VirtualInputManager = game:GetService("VirtualInputManager")
local workspace = game:GetService("Workspace")
local player = Players.LocalPlayer

-- ðŸ•’ Determine Season & Theme Settings
local function getSeason()
    local month = tonumber(os.date("%m"))
    if month >= 7 and month <= 9 then
        return "Summer"
    elseif month >= 10 and month <= 11 then
        return "Halloween"
    elseif month == 12 or month <= 2 then
        return "Christmas"
    elseif month >= 3 and month <= 6 then
        return "Easter"
    end
end

local season = getSeason()

-- ðŸŽ¨ Dynamic Season Themes
local seasonThemes = {
    Summer = {
        Colors = {
            ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 154, 0)),
            ColorSequenceKeypoint.new(0.50, Color3.fromRGB(255, 93, 0)),
            ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 30, 0))
        },
        Emoji = "â˜€ï¸"
    },
    Halloween = {
        Colors = {
            ColorSequenceKeypoint.new(0.00, Color3.fromRGB(40, 0, 80)),
            ColorSequenceKeypoint.new(0.50, Color3.fromRGB(140, 30, 255)),
            ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 100, 0))
        },
        Emoji = "ðŸŽƒ"
    },
    Christmas = {
        Colors = {
            ColorSequenceKeypoint.new(0.00, Color3.fromRGB(0, 50, 100)),
            ColorSequenceKeypoint.new(0.50, Color3.fromRGB(0, 150, 255)),
            ColorSequenceKeypoint.new(1.00, Color3.fromRGB(200, 230, 255))
        },
        Emoji = "â„ï¸"
    },
    Easter = {
        Colors = {
            ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 150, 200)),
            ColorSequenceKeypoint.new(0.50, Color3.fromRGB(150, 255, 150)),
            ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 255, 150))
        },
        Emoji = "ðŸŒ¸"
    }
}

local currentTheme = seasonThemes[season] or seasonThemes.Summer

if player.PlayerGui:FindFirstChild("MM2_UI") then
    player.PlayerGui.MM2_UI:Destroy()
end

-- Variables
local autoFarmEnabled = false
local stealthModeEnabled = false
local autoResetEnabled = false
local disableRenderEnabled = false
local antiAFKEnabled = false
local tweenSpeed = 17

local function getCharacter() return player.Character or player.CharacterAdded:Wait() end
local function getHRP() return getCharacter():WaitForChild("HumanoidRootPart") end
local function getHumanoid() return getCharacter():WaitForChild("Humanoid") end

local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "MM2_UI"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 320, 0, 330)
frame.Position = UDim2.new(0.5, -160, 0.5, -165)
frame.BackgroundColor3 = Color3.new(1, 1, 1)
frame.BackgroundTransparency = 0.1
frame.BorderSizePixel = 3
frame.BorderColor3 = Color3.new(1, 1, 1)
frame.Active = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

local gradient = Instance.new("UIGradient", frame)
gradient.Rotation = 90
gradient.Color = ColorSequence.new(currentTheme.Colors) 

frame.Size = UDim2.new(0, 0, 0, 0)
TweenService:Create(frame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, 320, 0, 330)
}):Play()

-- ðŸŽ­ Seasonal Icon Animation
local seasonIcon = Instance.new("TextLabel", frame)
seasonIcon.Size = UDim2.new(0, 42, 0, 42)
seasonIcon.Position = UDim2.new(0.82, 0, 0.04, 0)
seasonIcon.BackgroundTransparency = 1
seasonIcon.Text = currentTheme.Emoji
seasonIcon.TextSize = 30

local bounceTime = 0
RunService.RenderStepped:Connect(function(dt)
    bounceTime += dt * 3
    seasonIcon.Position = UDim2.new(0.82, 0, 0.04, math.sin(bounceTime) * 3)
end)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, -50, 0, 42)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Murder Mystery 2 | " .. season
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.FredokaOne
title.TextSize = 20
title.TextXAlignment = Enum.TextXAlignment.Left

local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -40, 0, 6)
closeBtn.Text = ""
closeBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
closeBtn.BackgroundTransparency = 0.6
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 8)

local closeIcon = Instance.new("ImageLabel", closeBtn)
closeIcon.Size = UDim2.new(0, 16, 0, 16)
closeIcon.Position = UDim2.new(0.5, -8, 0.5, -8)
closeIcon.BackgroundTransparency = 1
closeIcon.Image = "rbxassetid://7072706663" 
closeIcon.Rotation = 180

local contentBg = Instance.new("Frame", frame)
contentBg.Size = UDim2.new(0.92, 0, 0.82, 0)
contentBg.Position = UDim2.new(0.04, 0, 0.15, 0)
contentBg.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
contentBg.BackgroundTransparency = 0.5
contentBg.Active = false
Instance.new("UICorner", contentBg)

local content = Instance.new("Frame", contentBg)
content.Size = UDim2.new(1, -10, 1, -10)
content.Position = UDim2.new(0, 5, 0, 5)
content.BackgroundTransparency = 1

local function createToggle(yPos, labelText, defaultValue, callback)
    local label = Instance.new("TextLabel", content)
    label.Size = UDim2.new(0.7, 0, 0, 30)
    label.Position = UDim2.new(0.05, 0, 0, yPos)
    label.BackgroundTransparency = 1
    label.Text = labelText
    label.TextColor3 = Color3.new(1, 1, 1)
    label.Font = Enum.Font.GothamSemibold
    label.TextSize = 16
    label.TextXAlignment = Enum.TextXAlignment.Left

    local toggleBg = Instance.new("TextButton", content)  
    toggleBg.Size = UDim2.new(0, 50, 0, 25)  
    toggleBg.Position = UDim2.new(0.78, 0, 0, yPos + 2)  
    toggleBg.BackgroundColor3 = defaultValue and Color3.fromRGB(0, 200, 120) or Color3.fromRGB(150, 150, 150)  
    toggleBg.Text = ""  
    toggleBg.AutoButtonColor = false  
    Instance.new("UICorner", toggleBg).CornerRadius = UDim.new(1, 0)  

    local toggleKnob = Instance.new("Frame", toggleBg)  
    toggleKnob.Size = UDim2.new(0, 20, 0, 20)  
    toggleKnob.Position = defaultValue and UDim2.new(1, -22, 0, 2) or UDim2.new(0, 2, 0, 2)  
    toggleKnob.BackgroundColor3 = Color3.new(1, 1, 1)  
    Instance.new("UICorner", toggleKnob).CornerRadius = UDim.new(1, 0)  

    toggleBg.MouseButton1Click:Connect(function()  
        defaultValue = not defaultValue  
        local pos = defaultValue and UDim2.new(1, -22, 0, 2) or UDim2.new(0, 2, 0, 2)  
        local color = defaultValue and Color3.fromRGB(0, 200, 120) or Color3.fromRGB(150, 150, 150)  
        TweenService:Create(toggleKnob, TweenInfo.new(0.25), { Position = pos }):Play()  
        TweenService:Create(toggleBg, TweenInfo.new(0.25), { BackgroundColor3 = color }):Play()  
        callback(defaultValue)  
    end)
end

-- Toggles Structure
createToggle(10, "Auto Farm Coins", autoFarmEnabled, function(value) autoFarmEnabled = value end)
createToggle(40, "Stealth Mode (Underground)", stealthModeEnabled, function(value) stealthModeEnabled = value end)
createToggle(70, "Auto Reset", autoResetEnabled, function(value) autoResetEnabled = value end)
createToggle(100, "Disable Render", disableRenderEnabled, function(value)
    disableRenderEnabled = value
    RunService:Set3dRenderingEnabled(not disableRenderEnabled)
end)

local tweenSpeedBtn = Instance.new("TextButton", content)
tweenSpeedBtn.Size = UDim2.new(0.9, 0, 0, 32)
tweenSpeedBtn.Position = UDim2.new(0.05, 0, 0, 135)
tweenSpeedBtn.BackgroundColor3 = Color3.fromRGB(110, 110, 200)
tweenSpeedBtn.Text = "Tween Speed: " .. tweenSpeed
tweenSpeedBtn.TextColor3 = Color3.new(1, 1, 1)
tweenSpeedBtn.Font = Enum.Font.GothamBold
tweenSpeedBtn.TextSize = 15
Instance.new("UICorner", tweenSpeedBtn)

-- âš ï¸ Warning Label
local speedWarning = Instance.new("TextLabel", content)
speedWarning.Size = UDim2.new(0.9, 0, 0, 14)
speedWarning.Position = UDim2.new(0.05, 0, 0, 169)
speedWarning.BackgroundTransparency = 1
speedWarning.TextTransparency = 1
speedWarning.Text = "âš ï¸ Tween speeds above 22 may get you kicked!"
speedWarning.TextColor3 = Color3.fromRGB(255, 80, 80)
speedWarning.Font = Enum.Font.Gotham
speedWarning.TextSize = 11
speedWarning.Visible = false

local afkBtn = Instance.new("TextButton", content)
afkBtn.Size = UDim2.new(0.9, 0, 0, 32)
afkBtn.Position = UDim2.new(0.05, 0, 0, 172)
afkBtn.BackgroundColor3 = antiAFKEnabled and Color3.fromRGB(70, 160, 70) or Color3.fromRGB(110, 200, 110)
afkBtn.Text = antiAFKEnabled and "Anti-AFK Active" or "Enable Anti-AFK"
afkBtn.TextColor3 = Color3.new(1, 1, 1)
afkBtn.Font = Enum.Font.GothamBold
afkBtn.TextSize = 15
Instance.new("UICorner", afkBtn)

local startTime = tick()
local playTimeLabel = Instance.new("TextLabel", content)
playTimeLabel.Size = UDim2.new(0.9, 0, 0, 28)
playTimeLabel.Position = UDim2.new(0.05, 0, 0, 208)
playTimeLabel.BackgroundTransparency = 1
playTimeLabel.Text = "â³ time in game: 0d 0h 0m 0s"
playTimeLabel.TextColor3 = Color3.new(1, 1, 1)
playTimeLabel.Font = Enum.Font.GothamBold
playTimeLabel.TextSize = 14
playTimeLabel.TextXAlignment = Enum.TextXAlignment.Left

-- ðŸŽ¨ Smooth UI Animation Logic
local warningVisible = false
local animInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

tweenSpeedBtn.MouseButton1Click:Connect(function()
    tweenSpeed = tweenSpeed + 1
    if tweenSpeed > 40 then tweenSpeed = 10 end
    tweenSpeedBtn.Text = "Tween Speed: " .. tweenSpeed
    
    if tweenSpeed > 22 and not warningVisible then
        warningVisible = true
        speedWarning.Visible = true
        
        TweenService:Create(afkBtn, animInfo, {Position = UDim2.new(0.05, 0, 0, 186)}):Play()
        TweenService:Create(playTimeLabel, animInfo, {Position = UDim2.new(0.05, 0, 0, 222)}):Play()
        TweenService:Create(speedWarning, animInfo, {TextTransparency = 0}):Play()
        
    elseif tweenSpeed <= 22 and warningVisible then
        warningVisible = false
        
        TweenService:Create(afkBtn, animInfo, {Position = UDim2.new(0.05, 0, 0, 172)}):Play()
        TweenService:Create(playTimeLabel, animInfo, {Position = UDim2.new(0.05, 0, 0, 208)}):Play()
        
        local fadeOut = TweenService:Create(speedWarning, animInfo, {TextTransparency = 1})
        fadeOut:Play()
        fadeOut.Completed:Connect(function()
            if not warningVisible then
                speedWarning.Visible = false
            end
        end)
    end
end)

-- ðŸ¤– Upgraded Anti-AFK Logic
local function simulateActivity()
    if not antiAFKEnabled then return end
    
    if VirtualInputManager then
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.W, false, game)
        task.wait(0.1)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.W, false, game)
    end
    
    local mouse = player:GetMouse()
    local position = Vector2.new(mouse.X, mouse.Y)
    
    local rightClick = {
        UserInputType = Enum.UserInputType.MouseButton2,
        Position = position,
        UserInputState = Enum.UserInputState.Begin
    }
    UserInputService:InputBegan(rightClick)
    task.wait(0.1)
    rightClick.UserInputState = Enum.UserInputState.End
    UserInputService:InputEnded(rightClick)
end

afkBtn.MouseButton1Click:Connect(function()
    antiAFKEnabled = not antiAFKEnabled
    afkBtn.Text = antiAFKEnabled and "Anti-AFK Active" or "Enable Anti-AFK"
    afkBtn.BackgroundColor3 = antiAFKEnabled and Color3.fromRGB(70, 160, 70) or Color3.fromRGB(110, 200, 110)
    
    if antiAFKEnabled then
        task.spawn(function()
            while antiAFKEnabled do
                task.wait(30)
                if not antiAFKEnabled then break end
                simulateActivity()
            end
        end)
    end
end)

task.spawn(function()
    while true do
        local delta = math.floor(tick() - startTime)
        local d, h, m, s = math.floor(delta/86400), math.floor(delta%86400/3600), math.floor(delta%3600/60), delta%60
        playTimeLabel.Text = string.format("â³ time in game: %dd %02dh %02dm %02ds", d, h, m, s)
        task.wait(1)
    end
end)

-- ðŸ–±ï¸ FIXED BULLETPROOF DRAG LOGIC
local dragging = false
local dragInput, mousePos, framePos

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        mousePos = input.Position
        framePos = frame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - mousePos
        frame.Position = UDim2.new(
            framePos.X.Scale, 
            framePos.X.Offset + delta.X, 
            framePos.Y.Scale, 
            framePos.Y.Offset + delta.Y
        )
    end
end)

local isHidden = false
closeBtn.MouseButton1Click:Connect(function()
    isHidden = not isHidden
    
    local targetRotation = isHidden and 0 or 180
    TweenService:Create(closeIcon, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Rotation = targetRotation}):Play()
    
    local newSize = isHidden and UDim2.new(0, 320, 0, 42) or UDim2.new(0, 320, 0, 330)
    TweenService:Create(frame, TweenInfo.new(0.3), { Size = newSize }):Play()
    
    contentBg.Visible = not isHidden
    seasonIcon.Visible = not isHidden
end)

local CoinCollected = ReplicatedStorage.Remotes.Gameplay.CoinCollected
local RoundStart = ReplicatedStorage.Remotes.Gameplay.RoundStart
local RoundEnd = ReplicatedStorage.Remotes.Gameplay.RoundEndFade

local farming = false
local bag_full = false
local resetting = false

player.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- ðŸ”„ Upgraded Auto-Reset
CoinCollected.OnClientEvent:Connect(function(_, current, max)
    if current == max and not resetting and autoResetEnabled then
        resetting = true
        bag_full = true
        
        task.wait(0.5)
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.Health = 0
        end
        
        player.CharacterAdded:Wait()
        task.wait(1.5)
        resetting = false
        bag_full = false
    end
end)

RoundStart.OnClientEvent:Connect(function()
    farming = true
end)

RoundEnd.OnClientEvent:Connect(function()
    farming = false
end)

local function get_nearest_coin()
    local hrp = getHRP()
    local closest, dist = nil, math.huge
    for _, m in pairs(workspace:GetChildren()) do
        if m:FindFirstChild("CoinContainer") then
            for _, coin in pairs(m.CoinContainer:GetChildren()) do
                if coin:IsA("BasePart") and coin:FindFirstChild("TouchInterest") then
                    local d = (hrp.Position - coin.Position).Magnitude
                    if d < dist and d <= 100 then
                        closest, dist = coin, d
                    end
                end
            end
        end
    end
    return closest, dist
end

-- ðŸš€ THE GHOST MODE PHYSICS LOBOTOMY
local stealthActive = false

RunService.Stepped:Connect(function()
    if stealthActive and autoFarmEnabled and farming then
        local char = player.Character
        if char then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                -- Zero out velocity to prevent flinging
                hrp.AssemblyLinearVelocity = Vector3.zero
                hrp.AssemblyAngularVelocity = Vector3.zero
            end
            
            -- Disable collisions BUT strictly force CanTouch = true
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                    part.CanTouch = true -- This ensures the game still registers physical touches!
                end
            end
        end
    end
end)

-- ðŸš€ MAIN TWEEN LOOP
local stealthDepth = -2.5 -- Lowered exactly 0.3 more studs!

task.spawn(function()
    while true do
        if autoFarmEnabled and farming and not bag_full then
            local char = player.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local humanoid = char and char:FindFirstChild("Humanoid")
            
            local coin, dist = get_nearest_coin()
            
            if coin and hrp and humanoid then
                -- THE DROP & SWEEP
                if stealthModeEnabled and not stealthActive then
                    stealthActive = true
                    humanoid.PlatformStand = true
                    hrp.CFrame = CFrame.new(hrp.Position.X, coin.Position.Y + stealthDepth, hrp.Position.Z) * CFrame.Angles(math.rad(90), 0, 0)
                    task.wait(0.05) 
                elseif not stealthModeEnabled and stealthActive then
                    stealthActive = false
                    humanoid.PlatformStand = false
                    hrp.CFrame = CFrame.new(hrp.Position + Vector3.new(0, 4, 0)) * CFrame.Angles(0, 0, 0)
                end

                local targetCFrame = coin.CFrame
                
                if stealthActive then
                    targetCFrame = CFrame.new(coin.Position + Vector3.new(0, stealthDepth, 0)) * CFrame.Angles(math.rad(90), 0, 0)
                end

                if dist > 150 then
                    hrp.CFrame = targetCFrame
                else
                    local tween = TweenService:Create(hrp, TweenInfo.new(dist / tweenSpeed, Enum.EasingStyle.Linear), {CFrame = targetCFrame})
                    tween:Play()
                    
                    -- PROXIMITY VACUUM / ANTI-LEVITATION LOCK
                    while coin:FindFirstChild("TouchInterest") and coin.Parent and farming and autoFarmEnabled and (stealthModeEnabled == stealthActive) do
                        
                        -- If we are right next to the coin, force the touch event!
                        local currentDist = (hrp.Position - coin.Position).Magnitude
                        if currentDist < 3.5 then
                            -- Use exploit function to guarantee collection if available
                            if type(firetouchinterest) == "function" then
                                firetouchinterest(hrp, coin, 0)
                                task.wait()
                                firetouchinterest(hrp, coin, 1)
                            else
                                -- Failsafe: Micro-wiggle to force the physics engine to wake up and register the hit
                                hrp.CFrame = targetCFrame * CFrame.new(0, math.sin(tick() * 20) * 0.1, 0)
                            end
                        end
                        
                        if tween.PlaybackState == Enum.PlaybackState.Completed then
                            hrp.CFrame = targetCFrame
                        end
                        task.wait()
                    end
                    
                    tween:Cancel()
                end
            else
                -- Gracefully pop up if no coins are left
                if stealthActive then
                    stealthActive = false
                    if humanoid then humanoid.PlatformStand = false end
                    if hrp then hrp.CFrame = CFrame.new(hrp.Position + Vector3.new(0, 4, 0)) * CFrame.Angles(0, 0, 0) end
                end
                task.wait(0.2)
            end
        else
            -- Clean up gracefully
            if stealthActive then
                stealthActive = false
                local char = player.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                local humanoid = char and char:FindFirstChild("Humanoid")
                
                if humanoid then humanoid.PlatformStand = false end
                if hrp then hrp.CFrame = CFrame.new(hrp.Position + Vector3.new(0, 4, 0)) * CFrame.Angles(0, 0, 0) end
            end
            task.wait(0.2)
        end
    end
end)
