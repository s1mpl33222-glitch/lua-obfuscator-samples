
getgenv().YANZ_KEY_VERIFIED = false
local KeySystemURL = "https://raw.githubusercontent.com/lphisv5/rbxScript/refs/heads/main/YANZ-HUB-KEY-SYSTEM.lua"

local keySuccess, keyResult = pcall(function()
    return game:HttpGet(KeySystemURL, true)
end)

if keySuccess and keyResult then
    local keyFn, keyErr = loadstring(keyResult)
    if keyFn then
        pcall(keyFn)
    else
        warn("Key System Compile Error:", keyErr)
    end
else
    warn("Failed to download Key System:", keyResult)
end

repeat task.wait(1) until getgenv().YANZ_KEY_VERIFIED == true

local Games = {
    [17625359962] = { Name = "RIVALS", Url = "https://raw.githubusercontent.com/lphisv5/rbxScript/refs/heads/main/Rivals.lua" },
    [537413528] = { Name = "Build A Boat For Treasure", Url = "https://raw.githubusercontent.com/lphisv5/rbxScript/refs/heads/main/BuildABoatForTreasure.lua" },
    [93978595733734] = { Name = "Violence District", Url = "https://raw.githubusercontent.com/lphisv5/rbxScript/main/Violence-District.lua" },
    [3351674303] = { Name = "Driving Empire", Url = "https://raw.githubusercontent.com/lphisv5/rbxScript/main/driving-empire.lua" },
    [127707120843339] = { Name = "Math Murder", Url = "https://raw.githubusercontent.com/lphisv5/rbxScript/main/MathMurder.lua" },
    [137228775845999] = { Name = "Ghost Driver", Url = "https://raw.githubusercontent.com/lphisv5/rbxScript/main/ghostdriver.lua" },
    [124216119978534] = { Name = "Ride A Pet", Url = "https://raw.githubusercontent.com/lphisv5/rbxScript/refs/heads/main/RideAPet.lua" },
    [109203247742910] = { Name = "Swing For Eggs", Url = "https://raw.githubusercontent.com/lphisv5/rbxScript/refs/heads/main/SwingForEggs.lua" },
    [76377501906469] = { Name = "Steal an Anime Egg!", Url = "https://raw.githubusercontent.com/lphisv5/rbxScript/refs/heads/main/StealFishEggs.lua" },
    [99183404085821] = { Name = "Steal Fish Eggs", Url = "https://raw.githubusercontent.com/lphisv5/rbxScript/refs/heads/main/StealFishEggs.lua" },
    [17571821642] = { Name = "Math Tower Race", Url = "https://raw.githubusercontent.com/lphisv5/rbxScript/refs/heads/main/MathTowerRace.lua" },
    [123720558354386] = { Name = "Build the Pyramid!", Url = "https://raw.githubusercontent.com/lphisv5/rbxScript/refs/heads/main/BuildthePyramid.lua" },
    [114234929420007] = { Name = "BloxStrike", Url = "https://raw.githubusercontent.com/lphisv5/rbxScript/refs/heads/main/Bloxstrike.lua" },
    [18687417158] = { Name = "Forsaken", Url = "https://raw.githubusercontent.com/lphisv5/rbxScript/refs/heads/main/Forsaken.lua" },
    [114326934417838] = { Name = "Break and Steal an Egg", Url = "https://raw.githubusercontent.com/lphisv5/rbxScript/refs/heads/main/BreakandStealanEgg.lua" }
}

local currentGame = Games[game.PlaceId]

if currentGame then
    local Players = game:GetService("Players")
    local TweenService = game:GetService("TweenService")
    local RunService = game:GetService("RunService")
    local CoreGui = game:GetService("CoreGui")
    local LocalPlayer = Players.LocalPlayer
    
    local gui = Instance.new("ScreenGui")
    gui.Name = "DeltaPremiumLoader"
    gui.ResetOnSpawn = false
    
    local success, err = pcall(function() gui.Parent = CoreGui end)
    if not success then
        local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui", 5)
        if playerGui then gui.Parent = playerGui else return end
    end
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 320, 0, 60)
    frame.Position = UDim2.new(0.5, -160, 0, -80)
    frame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    frame.BackgroundTransparency = 0.15
    frame.BorderSizePixel = 0
    frame.Parent = gui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = frame
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.new(1, 1, 1)
    stroke.Thickness = 1.5
    stroke.Parent = frame
    
    local strokeGradient = Instance.new("UIGradient")
    strokeGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 150, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(200, 50, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 150, 255))
    }
    strokeGradient.Parent = stroke
    
    local rotation = 0
    local gradientAnim = RunService.RenderStepped:Connect(function(dt)
        if dt and dt > 0 then
            rotation = (rotation + (dt * 100)) % 360
            strokeGradient.Rotation = rotation
        end
    end)
    
    local logo = Instance.new("ImageLabel")
    logo.Size = UDim2.new(0, 36, 0, 36)
    logo.Position = UDim2.new(0, 12, 0.5, -18)
    logo.Image = "rbxthumb://type=GameIcon&id=" .. game.GameId .. "&w=150&h=150"
    logo.BackgroundTransparency = 1
    logo.Parent = frame
    
    local logoCorner = Instance.new("UICorner")
    logoCorner.CornerRadius = UDim.new(0, 8)
    logoCorner.Parent = logo
    
    local logoTween = TweenService:Create(logo, TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {Size = UDim2.new(0, 40, 0, 40), ImageTransparency = 0.2})
    logoTween:Play()
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -100, 0, 24)
    title.Position = UDim2.new(0, 60, 0, 8)
    title.Text = currentGame.Name
    title.Font = Enum.Font.GothamBold
    title.TextSize = 16
    title.TextColor3 = Color3.new(1, 1, 1)
    title.BackgroundTransparency = 1
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = frame
    
    local status = Instance.new("TextLabel")
    status.Size = UDim2.new(1, -100, 0, 20)
    status.Position = UDim2.new(0, 60, 0, 32)
    status.Text = "Initializing premium script..."
    status.Font = Enum.Font.Gotham
    status.TextSize = 13
    status.TextColor3 = Color3.fromRGB(160, 180, 255)
    status.BackgroundTransparency = 1
    status.TextXAlignment = Enum.TextXAlignment.Left
    status.Parent = frame
    
    TweenService:Create(frame, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, -160, 0, 40)
    }):Play()
    
    task.spawn(function()
        task.wait(0.5)
        status.Text = "Downloading data..."
        
        local success, response = pcall(function()
            return game:HttpGet(currentGame.Url, true)
        end)
        
        if success and response then
            status.Text = "Compiling script..."
            task.wait(0.3)
            
            local fn, err = loadstring(response)
            if fn then
                status.Text = "Successfully loaded!"
                status.TextColor3 = Color3.fromRGB(100, 255, 120)

                strokeGradient.Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 255, 100)), 
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 255, 100))
                }
                
                task.wait(1.5)
                local slideOut = TweenService:Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                    Position = UDim2.new(0.5, -160, 0, -80),
                    BackgroundTransparency = 1
                })
                slideOut:Play()
                slideOut.Completed:Wait()

                if gradientAnim then gradientAnim:Disconnect() end
                if gui then gui:Destroy() end

                local execSuccess, execErr = pcall(fn)
                if not execSuccess then warn("[YANZ Loader] Runtime error:", execErr) end
            else
                status.Text = "Compile error!"
                status.TextColor3 = Color3.fromRGB(255, 80, 80)
                task.wait(3)
                if gui then gui:Destroy() end
            end
        else
            status.Text = "Download failed!"
            status.TextColor3 = Color3.fromRGB(255, 80, 80)
            task.wait(3)
            if gui then gui:Destroy() end
        end
    end)
else
    task.spawn(function()
        local LocalPlayer = game:GetService("Players").LocalPlayer
        if LocalPlayer then
            pcall(function()
                LocalPlayer:Kick("[YANZ HUB] - Sorry, the script does not support this game.")
            end)
        end
    end)
end
  