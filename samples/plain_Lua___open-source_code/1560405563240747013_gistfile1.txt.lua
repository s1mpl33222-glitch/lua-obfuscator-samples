local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "RETRO HUB",
    Icon = 0,
    LoadingTitle = "🌟 Welcome To Retro Hub", 
    LoadingSubtitle = "", 
    ConfigurationSaving = { Enabled = false },
    Discord = { Enabled = false },
    KeySystem = false,
    Keybind = Enum.KeyCode.K,
    Theme = "AmberGlow",
})

-- ============================================================================
-- 1. BUILD UI FIRST
-- ============================================================================
local TabMain = Window:CreateTab("🏠 Main", 4483362458)
local TabMobile = Window:CreateTab("📱 Mobile Toggles", 4483362458)
local TabStats = Window:CreateTab("📊 Stats", 4483362458)
local TabFun = Window:CreateTab("🎭 Fun", 4483362458)
local TabVisuals = Window:CreateTab("👁️ Visuals", 4483362458)
local TabSkills = Window:CreateTab("⭐ Skills", 4483362458)
local TabReach = Window:CreateTab("👣 Reach", 4483362458)
local TabKeybinds = Window:CreateTab("⌨️ Keybinds", 4483362458)

TabMain:CreateParagraph({Title = "Tutorial", Content = "Click 'Show Rayfield' for Mobile and press 'K' for PC.\nGo to the Keybinds tab to customize your shortcuts!"})

-- ============================================================================
-- 2. CORE SERVICES & VARIABLES
-- ============================================================================
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local me = Players.LocalPlayer
local currentRayfieldAccent = Color3.fromRGB(255, 170, 0)

local states = {
    activePokers = false,
    sneakyMode = false,
    manualPokers = false,
    autoJuggleEnabled = false,
    isBallDeleted = false,
    isBallFrozen = false,
    isGoalFarmOn = false,
    trackerActive = false,
    sneakyRange = 5.5,
    juggleRange = 5.5,
    shoeColor = Color3.fromRGB(255, 0, 0),
    shoeGlow = false,
    rainbowShoes = false,
    customShirtName = "",
    customShirtNumber = "",
    continuousStats = false,
    stats = {Goals = "", Clan = "", BPA = "", Wins = ""},
    guiAccentColor = Color3.fromRGB(255, 170, 0) 
}

local reachRange = 4.6
local reachActive = false
local lastKickTime = 0

local validParts = {}
local currentRoot = nil
local currentHum = nil

local POKER_SPEED = 16
local lastStatUpdate = 0
local lastGkBodyVelocity = nil
local rainbowHue = 0

local predictionFolder = nil
local dots = {}
local bigDot = nil
local DOT_COUNT = 20

local RayfieldElements = {} 
local MobileButtons = {}

local deleteBallThread = nil
local freezeBallThread = nil

-- ============================================================================
-- 3. RUNTIME FUNCTIONS
-- ============================================================================
local function lerp(a, b, t)
    return a + (b - a) * t
end

local function getSneakyBall()
    local field = Workspace:FindFirstChild("FootballField")
    if field then
        for _, name in ipairs({"SoccerBall", "FutsalBall", "BeachBall", "Ball"}) do
            if field:FindFirstChild(name) then return field[name] end
        end
    end
    for _, v in ipairs(Workspace:GetDescendants()) do
        if v:IsA("BasePart") and v.Name:lower():find("ball") then return v end
    end
end

local function updateCharacterParts(char)
    table.clear(validParts)
    currentRoot = nil
    currentHum = nil
    if not char then return end
    
    currentHum = char:WaitForChild("Humanoid", 5)
    currentRoot = char:WaitForChild("HumanoidRootPart", 5)
    
    local parts = {"UpperTorso", "LeftUpperLeg", "RightUpperLeg", "HumanoidRootPart", "Head"}
    for _, name in ipairs(parts) do
        local p = char:WaitForChild(name, 5)
        if p then validParts[p] = name end
    end
end

local function forceHitboxUpdate()
    if currentRoot then
        currentRoot.CFrame = currentRoot.CFrame * CFrame.new(0, 0, 0.001)
    end
end

local function ApplyShoeChangerLogic()
    local char = me.Character
    if not char then return end
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") and (part.Name:lower():find("shoe") or part.Name:lower():find("foot")) then
            part.Color = states.shoeColor
            part.Material = states.shoeGlow and Enum.Material.Neon or Enum.Material.Plastic
        end
    end
end

local function ApplyShirtCustomizerLogic()
    local char = me.Character
    if not char then return end
    for _, d in pairs(char:GetDescendants()) do
        if d:IsA("TextLabel") or d:IsA("TextBox") then
            if d.Name:lower():find("name") or d.Parent.Name:lower():find("name") then
                if states.customShirtName ~= "" then d.Text = states.customShirtName end
            elseif d.Name:lower():find("num") or d.Parent.Name:lower():find("num") then
                if states.customShirtNumber ~= "" then d.Text = states.customShirtNumber end
            end
        end
    end
end

local function CreatePredictionVisuals()
    if predictionFolder then return end
    predictionFolder = Instance.new("Folder", Workspace)
    predictionFolder.Name = "PredictionVisuals"

    for i = 1, DOT_COUNT do
        local dot = Instance.new("Part", predictionFolder)
        dot.Shape = Enum.PartType.Ball
        dot.Size = Vector3.new(0.45, 0.45, 0.45)
        dot.Color = states.guiAccentColor
        dot.Material = Enum.Material.Neon
        dot.Transparency = 0.2
        dot.Anchored = true
        dot.CanCollide = false
        dot.CastShadow = false
        dots[i] = dot
    end

    bigDot = Instance.new("Part", predictionFolder)
    bigDot.Shape = Enum.PartType.Ball
    bigDot.Size = Vector3.new(3.5, 3.5, 3.5)
    bigDot.Color = states.guiAccentColor
    bigDot.Material = Enum.Material.Neon
    bigDot.Transparency = 0.0
    bigDot.Anchored = true
    bigDot.CanCollide = false
    bigDot.CastShadow = false
end

local function DestroyPredictionVisuals()
    if predictionFolder then
        predictionFolder:Destroy()
        predictionFolder = nil
        bigDot = nil
        dots = {}
    end
end

local function executeStatSpoof()
    local statsFolder = me:FindFirstChild("leaderstats") or me:FindFirstChild("PlayerGui")
    for statName, targetText in pairs(states.stats) do
        if targetText ~= "" and statsFolder then
            for _, val in ipairs(statsFolder:GetDescendants()) do
                 if val.Name:lower() == statName:lower() or val.Name:lower():find(statName:lower()) then
                    if val:IsA("StringValue") then val.Value = tostring(targetText)
                    elseif val:IsA("IntValue") or val:IsA("NumberValue") then val.Value = tonumber(targetText) or val.Value end
                end
            end
        end
    end
end

local function BringBallToPlayer()
    local ball = getSneakyBall()
    local char = me.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if ball and root then
        for i=1, 5 do
            ball.CFrame = root.CFrame * CFrame.new(0, -1, -3)
            ball.AssemblyLinearVelocity = Vector3.zero
            ball.AssemblyAngularVelocity = Vector3.zero
            task.wait(0.02)
        end
    end
end

-- ============================================
-- 4. MOBILE MATRIX BUTTONS
-- ============================================
local mobileMatrixGui = Instance.new("ScreenGui")
mobileMatrixGui.Name = "RetroHubMobileMatrix"
mobileMatrixGui.ResetOnSpawn = false
pcall(function() mobileMatrixGui.Parent = CoreGui end)
if not mobileMatrixGui.Parent then mobileMatrixGui.Parent = me:WaitForChild("PlayerGui", 5) end

local function BuildFloatingButton(label, stateKey, startPos, rayfieldElementKey, isTrigger)
    local btnFrame = Instance.new("Frame", mobileMatrixGui)
    btnFrame.Size = UDim2.new(0, 140, 0, 38)
    btnFrame.Position = startPos
    btnFrame.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    btnFrame.Active = true
    btnFrame.Visible = false
    Instance.new("UICorner", btnFrame).CornerRadius = UDim.new(0, 6)
    
    local stroke = Instance.new("UIStroke", btnFrame)
    stroke.Color = Color3.fromRGB(20, 20, 25)
    stroke.Thickness = 2
    
    local btnLabel = Instance.new("TextLabel", btnFrame)
    btnLabel.Size = UDim2.new(1, 0, 1, 0)
    btnLabel.BackgroundTransparency = 1
    btnLabel.Font = Enum.Font.GothamBold
    btnLabel.TextSize = 11
    btnLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    btnLabel.Text = isTrigger and label or label .. ": OFF"

    local dragging, dragInput, dragStart, startPosFrame, hasMoved = false, nil, nil, nil, false
    local lastBtnToggleTime = 0

    btnFrame.InputBegan:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and not dragging then
            dragging = true; dragInput = input; hasMoved = false; dragStart = input.Position; startPosFrame = btnFrame.Position
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            if delta.Magnitude > 8 then 
                hasMoved = true 
                btnFrame.Position = UDim2.new(startPosFrame.X.Scale, startPosFrame.X.Offset + delta.X, startPosFrame.Y.Scale, startPosFrame.Y.Offset + delta.Y)
            end
        end
    end)
    btnFrame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false; dragInput = nil
            if not hasMoved then
                if tick() - lastBtnToggleTime > 0.3 then 
                    lastBtnToggleTime = tick()
                    if isTrigger then
                        BringBallToPlayer()
                    elseif RayfieldElements[rayfieldElementKey] then
                        local targetState = states[stateKey]
                        if stateKey == "reachActive" then targetState = reachActive end
                        RayfieldElements[rayfieldElementKey]:Set(not targetState)
                    end
                end
            end
        end
    end)

    MobileButtons[stateKey] = {Frame = btnFrame, Label = btnLabel, BaseName = label, isTrigger = isTrigger}
end

local function SyncFloatingVisuals(stateKey, val)
    if MobileButtons[stateKey] and not MobileButtons[stateKey].isTrigger then
        MobileButtons[stateKey].Label.Text = MobileButtons[stateKey].BaseName .. (val and ": ON" or ": OFF")
        MobileButtons[stateKey].Frame.BackgroundColor3 = val and states.guiAccentColor or Color3.fromRGB(200, 50, 50)
    end
end

BuildFloatingButton("Active Pokers", "activePokers", UDim2.new(0.8, 0, 0.15, 0), "ActivePokers", false)
BuildFloatingButton("Sneaky", "sneakyMode", UDim2.new(0.8, 0, 0.23, 0), "Sneaky", false)
BuildFloatingButton("Manual Pokers", "manualPokers", UDim2.new(0.8, 0, 0.31, 0), "ManualPokers", false)
BuildFloatingButton("Delete Ball", "isBallDeleted", UDim2.new(0.8, 0, 0.39, 0), "DeleteBall", false)
BuildFloatingButton("Freeze Ball", "isBallFrozen", UDim2.new(0.8, 0, 0.47, 0), "FreezeBall", false)
BuildFloatingButton("Aim Predict", "trackerActive", UDim2.new(0.8, 0, 0.55, 0), "AimPredictor", false)
BuildFloatingButton("Juggle", "autoJuggleEnabled", UDim2.new(0.8, 0, 0.63, 0), "Juggle", false)
BuildFloatingButton("Reach", "reachActive", UDim2.new(0.8, 0, 0.71, 0), "Reach", false)
BuildFloatingButton("Bring Ball", "bringBall", UDim2.new(0.8, 0, 0.79, 0), "BringBall", true)

-- ============================================================================
-- 5. POPULATE UI ELEMENTS
-- ============================================================================

TabMobile:CreateSection("Matrix Toggles")
TabMobile:CreateToggle({Name = "Show Active Pokers", CurrentValue = false, Callback = function(v) MobileButtons["activePokers"].Frame.Visible = v end})
TabMobile:CreateToggle({Name = "Show Manual Pokers", CurrentValue = false, Callback = function(v) MobileButtons["manualPokers"].Frame.Visible = v end})
TabMobile:CreateToggle({Name = "Show Sneaky", CurrentValue = false, Callback = function(v) MobileButtons["sneakyMode"].Frame.Visible = v end})
TabMobile:CreateToggle({Name = "Show Delete Ball", CurrentValue = false, Callback = function(v) MobileButtons["isBallDeleted"].Frame.Visible = v end})
TabMobile:CreateToggle({Name = "Show Freeze Ball", CurrentValue = false, Callback = function(v) MobileButtons["isBallFrozen"].Frame.Visible = v end})
TabMobile:CreateToggle({Name = "Show Aim Predict", CurrentValue = false, Callback = function(v) MobileButtons["trackerActive"].Frame.Visible = v end})
TabMobile:CreateToggle({Name = "Show Juggle", CurrentValue = false, Callback = function(v) MobileButtons["autoJuggleEnabled"].Frame.Visible = v end})
TabMobile:CreateToggle({Name = "Show Reach", CurrentValue = false, Callback = function(v) MobileButtons["reachActive"].Frame.Visible = v end})
TabMobile:CreateToggle({Name = "Show Bring Ball", CurrentValue = false, Callback = function(v) MobileButtons["bringBall"].Frame.Visible = v end})

TabStats:CreateSection("Stats Spoof")
TabStats:CreateInput({Name = "Goals", PlaceholderText = "Goals", RemoveTextAfterFocusLost = false, Callback = function(t) states.stats.Goals = t end})
TabStats:CreateInput({Name = "Clan", PlaceholderText = "Clan", RemoveTextAfterFocusLost = false, Callback = function(t) states.stats.Clan = t end})
TabStats:CreateInput({Name = "BPA", PlaceholderText = "BPA", RemoveTextAfterFocusLost = false, Callback = function(t) states.stats.BPA = t end})
TabStats:CreateInput({Name = "Wins", PlaceholderText = "Wins", RemoveTextAfterFocusLost = false, Callback = function(t) states.stats.Wins = t end})
TabStats:CreateButton({Name = "Apply Visual Stats", Callback = function() executeStatSpoof() end})
TabStats:CreateToggle({Name = "Loop Stats", CurrentValue = false, Callback = function(v) states.continuousStats = v end})

TabFun:CreateSection("Goal Farmer")
TabFun:CreateToggle({Name = "Goal Farm Loop", CurrentValue = false, Callback = function(v) states.isGoalFarmOn = v end})
RayfieldElements.BringBall = TabFun:CreateButton({Name = "Bring Ball", Callback = function() BringBallToPlayer() end})

TabFun:CreateSection("Ball Mods")
RayfieldElements.DeleteBall = TabFun:CreateToggle({
    Name = "Delete Ball", CurrentValue = false, 
    Callback = function(v)
        states.isBallDeleted = v
        SyncFloatingVisuals("isBallDeleted", v)
        if v then
            deleteBallThread = task.spawn(function()
                 while states.isBallDeleted do
                    local Field = Workspace:FindFirstChild("FootballField")
                    if Field then
                        local Ball = Field:FindFirstChild("SoccerBall") or Field:FindFirstChild("Ball")
                        if Ball then Ball:Destroy() end
                    end
                    
                    local KickBall = game:GetService("ReplicatedStorage"):FindFirstChild("KickBall")
                    if KickBall then
                        KickBall:FireServer(
                            Vector3.new(560.5654296875, 600.84350585938, 1582.9370117188),
                            Vector3.new(560.5654296875, 600.84350585938, 1582.9370117188),
                            Vector3.new(560.5654296875, 600.84350585938, 1582.9370117188),
                            0,
                            "djhtelkds"
                        )
                    end
                    task.wait(0.05)
                end
            end)
        else
            if deleteBallThread then task.cancel(deleteBallThread); deleteBallThread = nil end
        end
    end
})

RayfieldElements.FreezeBall = TabFun:CreateToggle({
    Name = "Freeze Ball", CurrentValue = false, 
    Callback = function(v) 
        states.isBallFrozen = v 
        SyncFloatingVisuals("isBallFrozen", v)
        if v then
            freezeBallThread = task.spawn(function()
                while states.isBallFrozen do
                    local ball = getSneakyBall()
                    if ball then
                        ball.Anchored = true
                        pcall(function()
                            local kickBall = game:GetService("ReplicatedStorage"):FindFirstChild("KickBall")
                            if kickBall then
                                kickBall:FireServer(
                                    Vector3.new(0,0,0),
                                    Vector3.new(0,0,0),
                                    Vector3.new(0,0,0),
                                    0,
                                    "djhtelkds"
                                )
                            end
                        end)
                    end
                    task.wait(0.02)
                end
            end)
        else
            if freezeBallThread then task.cancel(freezeBallThread); freezeBallThread = nil end
            local ball = getSneakyBall()
            if ball then ball.Anchored = false end
        end
    end
})

TabVisuals:CreateSection("Shoes")
TabVisuals:CreateColorPicker({Name = "Shoe Color", Color = Color3.fromRGB(255, 0, 0), Callback = function(v) states.shoeColor = v; states.rainbowShoes = false; ApplyShoeChangerLogic() end})
TabVisuals:CreateToggle({Name = "Glow", CurrentValue = false, Callback = function(v) states.shoeGlow = v; ApplyShoeChangerLogic() end})
TabVisuals:CreateToggle({Name = "Rainbow Shoes", CurrentValue = false, Callback = function(v) states.rainbowShoes = v end})

TabVisuals:CreateSection("World")
TabVisuals:CreateSlider({Name = "Time", Range = {0, 24}, Increment = 1, CurrentValue = 7, Callback = function(v) Lighting.ClockTime = v end})

TabVisuals:CreateSection("Aim Predict")
RayfieldElements.AimPredictor = TabVisuals:CreateToggle({
    Name = "Aim Predict", CurrentValue = false,
    Callback = function(v)
        states.trackerActive = v
        SyncFloatingVisuals("trackerActive", v)
        if v then CreatePredictionVisuals() else DestroyPredictionVisuals() end
    end
})

TabVisuals:CreateSection("Shirt")
TabVisuals:CreateInput({Name = "Name", PlaceholderText = "Name", RemoveTextAfterFocusLost = false, Callback = function(t) states.customShirtName = t end})
TabVisuals:CreateInput({Name = "Number", PlaceholderText = "Number", RemoveTextAfterFocusLost = false, Callback = function(t) states.customShirtNumber = t end})
TabVisuals:CreateButton({Name = "Apply Shirt", Callback = function() ApplyShirtCustomizerLogic() end})

TabSkills:CreateSection("============== Skills Configuration ==============")
RayfieldElements.ActivePokers = TabSkills:CreateToggle({Name = "Active Pokers", CurrentValue = false, Callback = function(v) states.activePokers = v; SyncFloatingVisuals("activePokers", v) end})
RayfieldElements.ManualPokers = TabSkills:CreateToggle({Name = "Manual Pokers", CurrentValue = false, Callback = function(v) states.manualPokers = v; SyncFloatingVisuals("manualPokers", v) end})

-- SNEAKY / JUGGLE LOGIC
RayfieldElements.Juggle = TabSkills:CreateToggle({
    Name = "Auto Juggle", CurrentValue = false, 
    Callback = function(v) 
        states.autoJuggleEnabled = v
        SyncFloatingVisuals("autoJuggleEnabled", v)
    end
})
TabSkills:CreateInput({
    Name = "Juggle Range (1 - 5.5)", 
    PlaceholderText = "Enter Juggle Range...", 
    RemoveTextAfterFocusLost = false, 
    Callback = function(t) 
        states.juggleRange = math.clamp(tonumber(t) or 5.5, 1, 5.5) 
    end
})

RayfieldElements.Sneaky = TabSkills:CreateToggle({
    Name = "Auto Sneaky", CurrentValue = false, 
    Callback = function(v) 
        states.sneakyMode = v
        SyncFloatingVisuals("sneakyMode", v) 
    end
})
TabSkills:CreateInput({
    Name = "Sneaky Range (1 - 5.5)", 
    PlaceholderText = "Enter Sneaky Range...", 
    RemoveTextAfterFocusLost = false, 
    Callback = function(t) 
        states.sneakyRange = math.clamp(tonumber(t) or 5.5, 1, 5.5) 
    end
})

TabReach:CreateSection("============== Reach Configuration ==============")
RayfieldElements.Reach = TabReach:CreateToggle({Name = "Enable Reach", CurrentValue = false, Callback = function(v) reachActive = v; SyncFloatingVisuals("reachActive", v) end})
TabReach:CreateInput({
    Name = "Reach Range (1 - 5.5)", 
    PlaceholderText = "Enter Reach Range...", 
    RemoveTextAfterFocusLost = false, 
    Callback = function(t) 
        reachRange = math.clamp(tonumber(t) or 4.6, 1, 5.5) 
    end
})

-- ============================================================================
-- 7. CUSTOM KEYBINDS UI CONFIGURATION
-- ============================================================================
TabKeybinds:CreateSection("⌨️ Click and Change Shortcuts")

TabKeybinds:CreateKeybind({
    Name = "Active Pokers Keybind",
    CurrentKeybind = "G",
    HoldToInteract = false,
    Flag = "Keybind_ActivePokers",
    Callback = function()
        if RayfieldElements.ActivePokers then
            RayfieldElements.ActivePokers:Set(not RayfieldElements.ActivePokers.CurrentValue)
        end
    end,
})

TabKeybinds:CreateKeybind({
    Name = "Sneaky Keybind",
    CurrentKeybind = "Q",
    HoldToInteract = false,
    Flag = "Keybind_Sneaky",
    Callback = function()
        if RayfieldElements.Sneaky then
            RayfieldElements.Sneaky:Set(not RayfieldElements.Sneaky.CurrentValue)
        end
    end,
})

TabKeybinds:CreateKeybind({
    Name = "Manual Pokers Keybind",
    CurrentKeybind = "C",
    HoldToInteract = false,
    Flag = "Keybind_ManualPokers",
    Callback = function()
        if RayfieldElements.ManualPokers then
            RayfieldElements.ManualPokers:Set(not RayfieldElements.ManualPokers.CurrentValue)
        end
    end,
})

TabKeybinds:CreateKeybind({
    Name = "Juggle Keybind",
    CurrentKeybind = "J",
    HoldToInteract = false,
    Flag = "Keybind_Juggle",
    Callback = function()
        if RayfieldElements.Juggle then
            RayfieldElements.Juggle:Set(not RayfieldElements.Juggle.CurrentValue)
        end
    end,
})

TabKeybinds:CreateKeybind({
    Name = "Reach Keybind",
    CurrentKeybind = "X",
    HoldToInteract = false,
    Flag = "Keybind_Reach",
    Callback = function()
        if RayfieldElements.Reach then
            RayfieldElements.Reach:Set(not RayfieldElements.Reach.CurrentValue)
        end
    end,
})

TabKeybinds:CreateKeybind({
    Name = "Bring Ball Keybind",
    CurrentKeybind = "B",
    HoldToInteract = false,
    Flag = "Keybind_BringBall",
    Callback = function()
        BringBallToPlayer()
    end,
})

-- ============================================================================
-- 8. RUNTIME LOOP
-- ============================================================================
me.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    ApplyShoeChangerLogic()
    ApplyShirtCustomizerLogic()
    updateCharacterParts(char)
end)
if me.Character then updateCharacterParts(me.Character) end

RunService.Heartbeat:Connect(function(dt)
    local char = me.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local ball = getSneakyBall()

    if states.rainbowShoes then
        rainbowHue = (rainbowHue + dt * 0.2) % 1
        states.shoeColor = Color3.fromHSV(rainbowHue, 0.9, 1)
        ApplyShoeChangerLogic()
    end

    if states.continuousStats and tick() - lastStatUpdate >= 1 then
        lastStatUpdate = tick()
        pcall(executeStatSpoof)
    end
    
    if states.isGoalFarmOn and ball and root then
        ball.CFrame = CFrame.new(root.Position + Vector3.new(0, 2, 4))
        ball.AssemblyLinearVelocity = root.CFrame.LookVector * 125
    end

    if states.manualPokers and hum and hum.WalkSpeed ~= POKER_SPEED then
        hum.WalkSpeed = POKER_SPEED
    end

    if states.activePokers and root and ball then
        if not lastGkBodyVelocity or lastGkBodyVelocity.Parent ~= root then
            lastGkBodyVelocity = Instance.new("BodyVelocity")
            lastGkBodyVelocity.MaxForce = Vector3.new(1e7, 0, 1e7)
            lastGkBodyVelocity.Parent = root
        end
        local diff = ball.Position - root.Position
        lastGkBodyVelocity.Velocity = Vector3.new(diff.Unit.X * 26, 0, diff.Unit.Z * 26)
    else
        if lastGkBodyVelocity then
            lastGkBodyVelocity:Destroy()
            lastGkBodyVelocity = nil
        end
    end

    if states.trackerActive then
        if not ball or not root then
            for _, dot in ipairs(dots) do if dot then dot.Position = Vector3.new(0, -1000, 0) end end
            if bigDot then bigDot.Position = Vector3.new(0, -1000, 0) end
        else
            local distanceToBall = (ball.Position - root.Position).Magnitude
            if distanceToBall < 20 then
                local pos = ball.Position
                local assumedKickPower = 90 
                local upwardAngle = 0.35 
                
                local aimDirection = (root.CFrame.LookVector + Vector3.new(0, upwardAngle, 0)).Unit
                local simulatedVel = aimDirection * assumedKickPower
                local gravity = Workspace.Gravity

                local points = {}
                local landingPos = pos
                
                for i = 1, 80 do
                    local t = i * 0.015
                    local predicted = Vector3.new(
                        pos.X + simulatedVel.X * t,
                        pos.Y + simulatedVel.Y * t - 0.5 * gravity * t * t,
                        pos.Z + simulatedVel.Z * t
                    )
                    if predicted.Y < 5.5 then landingPos = predicted break end
                    table.insert(points, predicted)
                    landingPos = predicted
                end

                local step = math.max(1, math.floor(#points / DOT_COUNT))
                for i = 1, DOT_COUNT do
                    local idx = math.min(i * step, #points)
                    if points[idx] and dots[i] then
                        dots[i].Position = points[idx]
                        local alpha = i / DOT_COUNT
                        dots[i].Color = states.guiAccentColor
                        dots[i].Size = Vector3.new(0.5 - alpha * 0.3, 0.5 - alpha * 0.3, 0.5 - alpha * 0.3)
                    elseif dots[i] then
                        dots[i].Position = Vector3.new(0, -1000, 0)
                    end
                end

                if bigDot then
                    local pulse = 0.5 + 0.5 * math.sin(tick() * 8)
                    local size = 3 + pulse * 1.5
                    bigDot.Position = landingPos
                    bigDot.Size = Vector3.new(size, size, size)
                    bigDot.Transparency = pulse * 0.4
                    bigDot.Color = states.guiAccentColor
                end
            else
                for _, dot in ipairs(dots) do if dot then dot.Position = Vector3.new(0, -1000, 0) end end
                if bigDot then bigDot.Position = Vector3.new(0, -1000, 0) end
            end
        end
    end
end)

-- ============================================================================
-- 8. PROTECTED METATABLE HOOK
-- ============================================================================
pcall(function()
    local Vector3_new = Vector3.new
    local cachedField = nil
    local cachedBall = nil
    local lastCacheCheck = 0

    local function getHookBall()
        local now = os.clock()
        if now - lastCacheCheck > 0.3 then
            lastCacheCheck = now
            cachedField = Workspace:FindFirstChild("FootballField")
            cachedBall = cachedField and cachedField:FindFirstChild("SoccerBall")
        end
        return cachedBall
    end

    local oldIndex
    oldIndex = hookmetamethod(game, "__index", function(self, key)
        if key == "Position" and not checkcaller() then
            local isReach = reachActive
            local isSneaky = states.sneakyMode
            local isJuggle = states.autoJuggleEnabled

            if isReach or isSneaky or isJuggle then
                local ball = getHookBall()
                if ball then
                    local char = me.Character
                    if char and self.Parent == char then
                        local name = self.Name
                        if name == "UpperTorso" or name == "LowerTorso" or name == "HumanoidRootPart" or name == "Head" then
                            local realPos = oldIndex(self, key)
                            local ballPos = ball.Position

                            local dx = ballPos.X - realPos.X
                            local dy = ballPos.Y - realPos.Y
                            local dz = ballPos.Z - realPos.Z
                            local magnitude = math.sqrt(dx*dx + dy*dy + dz*dz)

                            -- PRIORITY 1: REACH LOGIC
                            if isReach and magnitude <= reachRange then
                                local rootPart = char:FindFirstChild("HumanoidRootPart")
                                local hum = char:FindFirstChildOfClass("Humanoid")

                                if rootPart and hum then
                                    local rawMove = hum.MoveDirection
                                    local moveDirection = Vector3_new(rawMove.X, 0, rawMove.Z)
                                    local moveLen = moveDirection.Magnitude
                                    local isMoving = moveLen > 0.05

                                    local pushMag = math.sqrt(dx*dx + dy*dy + dz*dz)

                                    if pushMag > 0 then
                                        local uX, uY, uZ = dx / pushMag, dy / pushMag, dz / pushMag
                                        local lookVector = rootPart.CFrame.LookVector
                                        local lookDirX, lookDirZ = lookVector.X, lookVector.Z
                                        local lookLen = math.sqrt(lookDirX*lookDirX + lookDirZ*lookDirZ)
                                        if lookLen > 0 then
                                            lookDirX, lookDirZ = lookDirX / lookLen, lookDirZ / lookLen
                                        end

                                        local alignment = 0
                                        if isMoving then
                                            alignment = (moveDirection.X / moveLen) * lookDirX + (moveDirection.Z / moveLen) * lookDirZ
                                        end

                                        local speedFactor = isMoving and math.clamp(moveLen, 1, 2) or 1
                                        local dynamicModifier = 1.0 + (alignment * 0.35) * speedFactor

                                        local forceField = 10
                                        local cancelPower = 10
                                        local ffMult = 0.8 + (forceField / 10) * 0.5
                                        dynamicModifier = dynamicModifier * ffMult

                                        local cancelMult = 0.7 + (cancelPower / 10) * 0.6

                                        if name == "Head" then
                                            if isMoving then
                                                local localMove = rootPart.CFrame:VectorToObjectSpace(moveDirection)
                                                if localMove.Z > 0.1 then
                                                    return oldIndex(self, key)
                                                else
                                                    local bX = (moveDirection.X / moveLen) * (1.5 * dynamicModifier)
                                                    local bZ = (moveDirection.Z / moveLen) * (1.5 * dynamicModifier)
                                                    return Vector3_new(realPos.X + bX, realPos.Y, realPos.Z + bZ)
                                                end
                                            else
                                                local offset_x = uX * (0.2 * dynamicModifier)
                                                local offset_z = uZ * (0.2 * dynamicModifier)
                                                return Vector3_new(ballPos.X - offset_x, realPos.Y, ballPos.Z - offset_z)
                                            end
                                        else
                                            local flatMag = math.sqrt(dx*dx + dz*dz)
                                            local flatX, flatZ = uX, uZ
                                            if flatMag > 0 then
                                                flatX = dx / flatMag
                                                flatZ = dz / flatMag
                                            end

                                            local buffer_x = flatX * (0.35 * dynamicModifier)
                                            local buffer_z = flatZ * (0.35 * dynamicModifier)

                                            local ballVel = ball.AssemblyLinearVelocity
                                            local isKicking = false

                                            local humanoid = char:FindFirstChildOfClass("Humanoid")
                                            if humanoid and humanoid.MoveDirection.Magnitude > 0.5 then
                                                local forwardDot = lookDirX * uX + lookDirZ * uZ
                                                if forwardDot > 0.3 and magnitude < 4 then
                                                    isKicking = true
                                                    lastKickTime = tick()
                                                end
                                            end

                                            if isKicking or (tick() - lastKickTime < 0.15) then
                                                local shotPower = 1.2 + (cancelPower / 10) * 0.8
                                                buffer_x = buffer_x + lookDirX * 0.5 * shotPower
                                                buffer_z = buffer_z + lookDirZ * 0.5 * shotPower
                                            end

                                            if ballVel then
                                                local awaySpeed = ballVel.X * uX + ballVel.Z * uZ
                                                if awaySpeed > 1.5 then
                                                    buffer_x = buffer_x + flatX * 0.18 * cancelMult
                                                    buffer_z = buffer_z + flatZ * 0.18 * cancelMult
                                                end
                                            end

                                            local targetY = realPos.Y

                                            if ballPos.Y > realPos.Y + 2 and magnitude < 5 then
                                                targetY = realPos.Y + 0.5
                                            end

                                            return Vector3_new(ballPos.X - buffer_x, targetY, ballPos.Z - buffer_z)
                                        end
                                    end
                                end
                                return Vector3_new(ballPos.X, realPos.Y, ballPos.Z)
                            end

                            -- PRIORITY 2: AUTO SNEAKY / JUGGLE LOGIC
                            local targetRange = 0
                            if isSneaky then targetRange = math.max(targetRange, states.sneakyRange) end
                            if isJuggle then targetRange = math.max(targetRange, states.juggleRange) end

                            if targetRange > 0 and magnitude <= targetRange then
                                local rootPart = char:FindFirstChild("HumanoidRootPart")
                                local hum = char:FindFirstChildOfClass("Humanoid")
                                
                                if rootPart and hum then
                                    local rawMove = hum.MoveDirection
                                    local moveDirection = Vector3_new(rawMove.X, 0, rawMove.Z)
                                    local moveLen = moveDirection.Magnitude
                                    local isMoving = moveLen > 0.05
                                    
                                    local lookVector = rootPart.CFrame.LookVector
                                    local lookDirX, lookDirZ = lookVector.X, lookVector.Z
                                    local lookLen = math.sqrt(lookDirX*lookDirX + lookDirZ*lookDirZ)
                                    
                                    if lookLen > 0 then
                                        lookDirX, lookDirZ = lookDirX / lookLen, lookDirZ / lookLen
                                    else
                                        lookDirX, lookDirZ = 0, 1
                                    end
                                    
                                    local alignment = 0
                                    if isMoving then
                                        alignment = (moveDirection.X / moveLen) * lookDirX + (moveDirection.Z / moveLen) * lookDirZ
                                    end
                                    
                                    local speedFactor = isMoving and math.clamp(moveLen, 1.2, 2.5) or 1
                                    local dynamicModifier = 1.1 + (alignment * 0.45) * speedFactor
                                    
                                    if name == "Head" then
                                        local buffer_x = lookDirX * (0.12 * dynamicModifier)
                                        local buffer_z = lookDirZ * (0.12 * dynamicModifier)
                                        return Vector3_new(ballPos.X - buffer_x, realPos.Y, ballPos.Z - buffer_z)
                                    else
                                        local flatMag = math.sqrt(dx*dx + dz*dz)
                                        local flatX, flatZ = 0, 0
                                        if flatMag > 0 then
                                            flatX = dx / flatMag
                                            flatZ = dz / flatMag
                                        end
                                        
                                        local buffer_x = flatX * (0.18 * dynamicModifier)
                                        local buffer_z = flatZ * (0.18 * dynamicModifier)
                                        
                                        return Vector3_new(ballPos.X - buffer_x, realPos.Y, ballPos.Z - buffer_z)
                                    end
                                end
                                return Vector3_new(ballPos.X, realPos.Y, ballPos.Z)
                            end
                        end
                    end
                end
            end
            return oldIndex(self, key)
        end
        return oldIndex(self, key)
    end)
end)
