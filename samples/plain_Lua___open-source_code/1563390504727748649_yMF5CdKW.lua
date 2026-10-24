local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer

-- Configuration variables
local MagPower = 30 
local MagsEnabled = true
local AutoTuckEnabled = true
local JumpPowerEnabled = true
local JumpPowerValue = 53
local OriginalJumpPower = 50 
local HitboxVisualEnabled = false 

-- OFL / GOT NEXT MAG CONFIGURATION VARIABLES
local GotNextMagsEnabled = false
local GotNextMagPower = 30
local GotNextHitboxVisualEnabled = false

-- NEW FACILITY MAGS CONFIGURATION VARIABLES
local FacilityMagsEnabled = false
local FacilityMagPower = 30
local FacilityHitboxVisualEnabled = false

-- Target verification helper map for Auto-Tuck
local BALL_NAMES = {
    ["Sxw0mG8l"] = true,
    ["SxwOmG8l"] = true,
    ["SCTW29GV"] = true,
    ["JugsMachine"] = true,
    ["MainBase"] = true,
    ["Turning"] = true,
    ["Handle"] = true,
    ["FootballHandle"] = true,
    ["Football"] = true,
    ["football"] = true,
    ["Ball"] = true,
    ["ball"] = true
}

-- Key System Configuration
local CORRECT_KEY = "love"

-- Create the Hitbox Visual Box (Original Mags)
local VisualBox = Instance.new("SelectionBox")
VisualBox.Color3 = Color3.fromRGB(0, 162, 255)
VisualBox.LineThickness = 0.05
VisualBox.SurfaceColor3 = Color3.fromRGB(0, 162, 255)
VisualBox.SurfaceTransparency = 0.85
VisualBox.Visible = false
VisualBox.Parent = workspace

local VisualPart = Instance.new("Part")
VisualPart.Anchored = true
VisualPart.CanCollide = false
VisualPart.Transparency = 1
VisualPart.Parent = workspace
VisualBox.Adornee = VisualPart

-- OFL MAG HITBOX VISUAL BOX (Sleek Red)
local GotNextVisualBox = Instance.new("SelectionBox")
GotNextVisualBox.Color3 = Color3.fromRGB(255, 60, 60)
GotNextVisualBox.LineThickness = 0.05
GotNextVisualBox.SurfaceColor3 = Color3.fromRGB(255, 60, 60)
GotNextVisualBox.SurfaceTransparency = 0.85
GotNextVisualBox.Visible = false
GotNextVisualBox.Parent = workspace

local GotNextVisualPart = Instance.new("Part")
GotNextVisualPart.Anchored = true
GotNextVisualPart.CanCollide = false
GotNextVisualPart.Transparency = 1
GotNextVisualPart.Parent = workspace
GotNextVisualBox.Adornee = GotNextVisualPart

-- FACILITY MAG HITBOX VISUAL BOX (Sleek Purple)
local FacilityVisualBox = Instance.new("SelectionBox")
FacilityVisualBox.Color3 = Color3.fromRGB(160, 32, 240)
FacilityVisualBox.LineThickness = 0.05
FacilityVisualBox.SurfaceColor3 = Color3.fromRGB(160, 32, 240)
FacilityVisualBox.SurfaceTransparency = 0.85
FacilityVisualBox.Visible = false
FacilityVisualBox.Parent = workspace

local FacilityVisualPart = Instance.new("Part")
FacilityVisualPart.Anchored = true
FacilityVisualPart.CanCollide = false
FacilityVisualPart.Transparency = 1
FacilityVisualPart.Parent = workspace
FacilityVisualBox.Adornee = FacilityVisualPart

local CatchRight = nil
local function setupCharacter(char)
    CatchRight = char:WaitForChild("RightHand", 2) or char:WaitForChild("Right Arm", 5)
    
    local humanoid = char:WaitForChild("Humanoid", 5)
    if humanoid then
        if humanoid.JumpPower ~= math.min(JumpPowerValue, 60) and humanoid.JumpPower ~= 0 then
            OriginalJumpPower = humanoid.JumpPower
        end
        
        humanoid.UseJumpPower = true
        if JumpPowerEnabled then
            humanoid.JumpPower = math.min(JumpPowerValue, 60)
        else
            humanoid.JumpPower = OriginalJumpPower
        end
    end
end

if LocalPlayer.Character then setupCharacter(LocalPlayer.Character) end
LocalPlayer.CharacterAdded:Connect(setupCharacter)

-- SMART HYBRID JUMP ENGINE
UserInputService.JumpRequest:Connect(function()
    if not JumpPowerEnabled then return end
    
    local char = LocalPlayer.Character
    if not char then return end
    
    local rootPart = char:FindFirstChild("HumanoidRootPart")
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    
    if rootPart and humanoid and humanoid.FloorMaterial ~= Enum.Material.Air then
        if JumpPowerValue > 60 then
            local excessPower = JumpPowerValue - 60
            local velocityImpulse = excessPower * 1.35 
            
            task.defer(function()
                rootPart.AssemblyLinearVelocity = Vector3.new(
                    rootPart.AssemblyLinearVelocity.X,
                    rootPart.AssemblyLinearVelocity.Y + velocityImpulse,
                    rootPart.AssemblyLinearVelocity.Z
                )
            end)
        end
    end
end)

-- SMOOTH FRAME-BY-FRAME HITBOX RENDERING
RunService.RenderStepped:Connect(function()
    if CatchRight and CatchRight.Parent then
        -- Original Magnet Hitbox
        if MagsEnabled and HitboxVisualEnabled then
            local boxDiameter = MagPower * 2
            VisualPart.Size = Vector3.new(boxDiameter, boxDiameter, boxDiameter)
            VisualPart.CFrame = CatchRight.CFrame 
            VisualBox.Visible = true
        else
            VisualBox.Visible = false
        end

        -- OFL Mag Hitbox
        if GotNextMagsEnabled and GotNextHitboxVisualEnabled then
            local boxDiameter = GotNextMagPower * 2
            GotNextVisualPart.Size = Vector3.new(boxDiameter, boxDiameter, boxDiameter)
            GotNextVisualPart.CFrame = CatchRight.CFrame 
            GotNextVisualBox.Visible = true
        else
            GotNextVisualBox.Visible = false
        end

        -- Facility Mag Hitbox
        if FacilityMagsEnabled and FacilityHitboxVisualEnabled then
            local boxDiameter = FacilityMagPower * 2
            FacilityVisualPart.Size = Vector3.new(boxDiameter, boxDiameter, boxDiameter)
            FacilityVisualPart.CFrame = CatchRight.CFrame 
            FacilityVisualBox.Visible = true
        else
            FacilityVisualBox.Visible = false
        end
    else
        VisualBox.Visible = false
        GotNextVisualBox.Visible = false
        FacilityVisualBox.Visible = false
    end
end)

-- Helper function to deeply find a target part inside any workspace model/tool
local function findTargetPartInModel(parent, targetName)
    local found = parent:FindFirstChild(targetName)
    if found and found:IsA("BasePart") then
        return found
    end
    for _, child in pairs(parent:GetChildren()) do
        if child:IsA("Tool") or child:IsA("Model") then
            local deepFound = child:FindFirstChild(targetName)
            if deepFound and deepFound:IsA("BasePart") then
                return deepFound
            end
        end
    end
    return nil
end

-- COLLEGE FOOTBALL MAGNETS RUN LOOP (Only targets "Handle")
RunService.Heartbeat:Connect(function()
    if not CatchRight or not MagsEnabled then return end
    
    for _, child in pairs(workspace:GetChildren()) do
        local targetPart = nil
        if child:IsA("BasePart") and child.Name == "Handle" then
            targetPart = child
        elseif child:IsA("Tool") or child:IsA("Model") then
            targetPart = findTargetPartInModel(child, "Handle")
        end
        
        if targetPart and not targetPart:IsDescendantOf(LocalPlayer.Character) then
            if (CatchRight.Position - targetPart.Position).Magnitude <= MagPower then
                firetouchinterest(CatchRight, targetPart, 0)
                firetouchinterest(CatchRight, targetPart, 1)
            end
        end
    end
end)

-- OPTIMIZED STANDALONE OFL MAGNET LOGIC (Only targets "FootballHandle")
task.spawn(function()
    while true do
        task.wait(0.1) 
        
        if CatchRight and CatchRight.Parent and GotNextMagsEnabled then
            for _, child in pairs(workspace:GetChildren()) do
                local targetPart = nil
                if child:IsA("BasePart") and child.Name == "FootballHandle" then
                    targetPart = child
                elseif child:IsA("Tool") or child:IsA("Model") then
                    targetPart = findTargetPartInModel(child, "FootballHandle")
                end
                
                if targetPart and not targetPart:IsDescendantOf(LocalPlayer.Character) then
                    local distance = (CatchRight.Position - targetPart.Position).Magnitude
                    if distance <= GotNextMagPower then
                        firetouchinterest(CatchRight, targetPart, 0)
                        task.wait()
                        firetouchinterest(CatchRight, targetPart, 1)
                    end
                end
            end
        end
    end
end)

-- NEW DEDICATED FACILITY MAGNET ENGINE (Only targets "Sxw0mG8l")
task.spawn(function()
    while true do
        task.wait(0.05) 
        
        if CatchRight and CatchRight.Parent and FacilityMagsEnabled then
            for _, child in pairs(workspace:GetChildren()) do
                local targetPart = nil
                if child:IsA("BasePart") and child.Name == "Sxw0mG8l" then
                    targetPart = child
                elseif child:IsA("Tool") or child:IsA("Model") then
                    targetPart = findTargetPartInModel(child, "Sxw0mG8l")
                end
                
                if targetPart and not targetPart:IsDescendantOf(LocalPlayer.Character) then
                    local distance = (CatchRight.Position - targetPart.Position).Magnitude
                    if distance <= FacilityMagPower then
                        firetouchinterest(CatchRight, targetPart, 0)
                        task.wait()
                        firetouchinterest(CatchRight, targetPart, 1)
                    end
                end
            end
        end
    end
end)

-- ULTRA-RELIABLE DUAL-ZONE AUTO TUCK ENGINE
local function instantTuckTrigger(child)
    if not AutoTuckEnabled then return end
    if child:IsA("Tool") and (BALL_NAMES[child.Name] or child:FindFirstChild("Handle") or child:FindFirstChild("Turning") or child:FindFirstChild("MainBase") or child:FindFirstChild("Sxw0mG8l") or child:FindFirstChild("FootballHandle")) then
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
        task.wait()
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
    end
end

local Backpack = LocalPlayer:WaitForChild("Backpack")
Backpack.ChildAdded:Connect(instantTuckTrigger)

local function trackCharacterInventory(char)
    char.ChildAdded:Connect(instantTuckTrigger)
end
if LocalPlayer.Character then trackCharacterInventory(LocalPlayer.Character) end
LocalPlayer.CharacterAdded:Connect(trackCharacterInventory)


-- UI CONTAINER setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Mekoware_Free"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer.PlayerGui

-- MAIN CONTAINER Frame
local MainHub = Instance.new("Frame")
MainHub.Size = UDim2.new(0, 560, 0, 380)
MainHub.Position = UDim2.new(0.5, -280, 0.4, -190)
MainHub.BackgroundColor3 = Color3.fromRGB(15, 17, 20)
MainHub.BorderSizePixel = 0
MainHub.Active = true
MainHub.Visible = false 
MainHub.Parent = ScreenGui
Instance.new("UICorner", MainHub).CornerRadius = UDim.new(0, 10)

-- KEY SYSTEM CONTAINER Frame
local KeyHub = Instance.new("Frame")
KeyHub.Size = UDim2.new(0, 340, 0, 200)
KeyHub.Position = UDim2.new(0.5, -170, 0.4, -100)
KeyHub.BackgroundColor3 = Color3.fromRGB(15, 17, 20)
KeyHub.BorderSizePixel = 0
KeyHub.Active = true
KeyHub.Parent = ScreenGui
Instance.new("UICorner", KeyHub).CornerRadius = UDim.new(0, 10)

-- KEY HEADER
local KeyHeader = Instance.new("Frame")
KeyHeader.Size = UDim2.new(1, 0, 0, 45)
KeyHeader.BackgroundColor3 = Color3.fromRGB(20, 23, 27)
KeyHeader.BorderSizePixel = 0
KeyHeader.Parent = KeyHub
Instance.new("UICorner", KeyHeader).CornerRadius = UDim.new(0, 10)

local KeyTitle = Instance.new("TextLabel")
KeyTitle.Size = UDim2.new(1, -20, 1, 0)
KeyTitle.Position = UDim2.new(0, 15, 0, 0)
KeyTitle.BackgroundTransparency = 1
KeyTitle.Text = "mekoware [Free] — Key Verification"
KeyTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyTitle.TextSize = 13
KeyTitle.Font = Enum.Font.GothamBold
KeyTitle.TextXAlignment = Enum.TextXAlignment.Left
KeyTitle.Parent = KeyHeader

-- KEY ENTRY TEXTBOX
local KeyInput = Instance.new("TextBox")
KeyInput.Size = UDim2.new(1, -40, 0, 36)
KeyInput.Position = UDim2.new(0, 20, 0, 75)
KeyInput.BackgroundColor3 = Color3.fromRGB(24, 27, 32)
KeyInput.BorderSizePixel = 0
KeyInput.Text = ""
KeyInput.PlaceholderText = "Enter verification key..."
KeyInput.PlaceholderColor3 = Color3.fromRGB(100, 105, 115)
KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyInput.TextSize = 12
KeyInput.Font = Enum.Font.GothamMedium
KeyInput.Parent = KeyHub
Instance.new("UICorner", KeyInput).CornerRadius = UDim.new(0, 6)

-- SUBMIT BUTTON
local KeySubmit = Instance.new("TextButton")
KeySubmit.Size = UDim2.new(1, -40, 0, 36)
KeySubmit.Position = UDim2.new(0, 20, 0, 125)
KeySubmit.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
KeySubmit.BorderSizePixel = 0
KeySubmit.Text = "Verify Key"
KeySubmit.TextColor3 = Color3.fromRGB(255, 255, 255)
KeySubmit.TextSize = 12
KeySubmit.Font = Enum.Font.GothamBold
KeySubmit.Parent = KeyHub
Instance.new("UICorner", KeySubmit).CornerRadius = UDim.new(0, 6)

-- VERIFICATION CHECK LOGIC
KeySubmit.MouseButton1Click:Connect(function()
    if KeyInput.Text == CORRECT_KEY then
        KeyHub.Visible = false
        MainHub.Visible = true
    else
        KeySubmit.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
        KeySubmit.Text = "Incorrect Key! Try Again"
        task.wait(1.5)
        KeySubmit.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
        KeySubmit.Text = "Verify Key"
    end
end)


-- HEADER BAR
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 45)
Header.BackgroundColor3 = Color3.fromRGB(20, 23, 27)
Header.BorderSizePixel = 0
Header.Parent = MainHub
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -20, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "mekoware [Free] <font color='#808595'>v1.0.0</font>"
Title.RichText = true
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

-- SIDEBAR BACKGROUND
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 150, 1, -45)
Sidebar.Position = UDim2.new(0, 0, 0, 45)
Sidebar.BackgroundColor3 = Color3.fromRGB(13, 15, 18)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainHub

-- TAB HOLDER
local TabHolder = Instance.new("ScrollingFrame")
TabHolder.Size = UDim2.new(1, -10, 1, -60)
TabHolder.Position = UDim2.new(0, 5, 0, 10)
TabHolder.BackgroundTransparency = 1
TabHolder.ScrollBarThickness = 0
TabHolder.Parent = Sidebar
local SidebarLayout = Instance.new("UIListLayout")
SidebarLayout.Padding = UDim.new(0, 4)
SidebarLayout.Parent = TabHolder

-- CONTENT PAGES HOLDER
local PageHolder = Instance.new("Frame")
PageHolder.Size = UDim2.new(1, -165, 1, -60)
PageHolder.Position = UDim2.new(0, 157, 0, 53)
PageHolder.BackgroundTransparency = 1
PageHolder.Parent = MainHub

local Pages = {}
local Tabs = {}

local function createPage(name)
    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.ScrollBarThickness = 2
    page.ScrollBarImageColor3 = Color3.fromRGB(45, 48, 55)
    page.Visible = false
    page.Parent = PageHolder
    
    local pageLayout = Instance.new("UIListLayout")
    pageLayout.Padding = UDim.new(0, 12)
    pageLayout.Parent = page
    
    Pages[name] = page
    
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(1, 0, 0, 32)
    tabBtn.BackgroundColor3 = Color3.fromRGB(20, 23, 27)
    tabBtn.BackgroundTransparency = 1
    tabBtn.Text = "   " .. name
    tabBtn.TextColor3 = Color3.fromRGB(140, 145, 160)
    tabBtn.TextSize = 12
    tabBtn.Font = Enum.Font.GothamMedium
    tabBtn.TextXAlignment = Enum.TextXAlignment.Left
    tabBtn.Parent = TabHolder
    Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 6)
    
    tabBtn.MouseButton1Click:Connect(function()
        for _, p in pairs(Pages) do p.Visible = false end
        for t, b in pairs(Tabs) do 
            b.BackgroundTransparency = 1 
            b.TextColor3 = Color3.fromRGB(140, 145, 160)
        end
        page.Visible = true
        tabBtn.BackgroundTransparency = 0
        tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)
    
    Tabs[name] = tabBtn
end

local function createSection(pageName, sectionTitle)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 20)
    lbl.BackgroundTransparency = 1
    lbl.Text = sectionTitle
    lbl.TextColor3 = Color3.fromRGB(180, 185, 200)
    lbl.TextSize = 12
    lbl.Font = Enum.Font.GothamBold
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = Pages[pageName]
end

local function createSlider(pageName, text, minVal, maxVal, defaultVal, callback)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, -10, 0, 50)
    card.BackgroundColor3 = Color3.fromRGB(20, 23, 27)
    card.BorderSizePixel = 0
    card.Parent = Pages[pageName]
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 6)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 0, 22)
    label.Position = UDim2.new(0, 12, 0, 4)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(240, 240, 245)
    label.TextSize = 12
    label.Font = Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = card

    local valLabel = Instance.new("TextLabel")
    valLabel.Size = UDim2.new(0.3, 0, 0, 22)
    valLabel.Position = UDim2.new(0.7, -12, 0, 4)
    valLabel.BackgroundTransparency = 1
    valLabel.Text = tostring(defaultVal)
    valLabel.TextColor3 = Color3.fromRGB(0, 162, 255)
    valLabel.TextSize = 12
    valLabel.Font = Enum.Font.GothamBold
    valLabel.TextXAlignment = Enum.TextXAlignment.Right
    valLabel.Parent = card

    local sliderBG = Instance.new("Frame")
    sliderBG.Size = UDim2.new(1, -24, 0, 5)
    sliderBG.Position = UDim2.new(0, 12, 0, 32)
    sliderBG.BackgroundColor3 = Color3.fromRGB(45, 48, 55)
    sliderBG.BorderSizePixel = 0
    sliderBG.Active = true
    sliderBG.Parent = card
    Instance.new("UICorner", sliderBG).CornerRadius = UDim.new(1, 0)

    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((defaultVal - minVal) / (maxVal - minVal), 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderBG
    Instance.new("UICorner", sliderFill).CornerRadius = UDim.new(1, 0)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 12, 0, 12)
    knob.Position = UDim2.new((defaultVal - minVal) / (maxVal - minVal), -6, 0.5, -6)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.BorderSizePixel = 0
    knob.Parent = sliderBG
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    local dragging = false
    
    local function update(input)
        local ratio = math.clamp((input.Position.X - sliderBG.AbsolutePosition.X) / sliderBG.AbsoluteSize.X, 0, 1)
        local value = math.floor(minVal + (ratio * (maxVal - minVal)))
        sliderFill.Size = UDim2.new(ratio, 0, 1, 0)
        knob.Position = UDim2.new(ratio, -6, 0.5, -6)
        valLabel.Text = tostring(value)
        callback(value)
    end

    sliderBG.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            update(input)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            update(input)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then 
            dragging = false 
        end
    end)
end

local function createToggle(pageName, title, subText, defaultState, callback)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, -10, 0, 48)
    card.BackgroundColor3 = Color3.fromRGB(20, 23, 27)
    card.BorderSizePixel = 0
    card.Parent = Pages[pageName]
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 6)

    local mainLabel = Instance.new("TextLabel")
    mainLabel.Size = UDim2.new(0.7, 0, 0, 20)
    mainLabel.Position = UDim2.new(0, 12, 0, 4)
    mainLabel.BackgroundTransparency = 1
    mainLabel.Text = title
    mainLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    mainLabel.TextSize = 12
    mainLabel.Font = Enum.Font.GothamMedium
    mainLabel.TextXAlignment = Enum.TextXAlignment.Left
    mainLabel.Parent = card

    local descLabel = Instance.new("TextLabel")
    descLabel.Size = UDim2.new(0.7, 0, 0, 16)
    descLabel.Position = UDim2.new(0, 12, 0, 22)
    descLabel.BackgroundTransparency = 1
    descLabel.Text = subText
    descLabel.TextColor3 = Color3.fromRGB(120, 125, 135)
    descLabel.TextSize = 10
    descLabel.Font = Enum.Font.Gotham
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.Parent = card

    local switch = Instance.new("TextButton")
    switch.Size = UDim2.new(0, 34, 0, 18)
    switch.Position = UDim2.new(1, -46, 0.5, -9)
    switch.BackgroundColor3 = defaultState and Color3.fromRGB(0, 162, 255) or Color3.fromRGB(45, 48, 55)
    switch.Text = ""
    switch.Parent = card
    Instance.new("UICorner", switch).CornerRadius = UDim.new(1, 0)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 12, 0, 12)
    knob.Position = defaultState and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 3, 0.5, -6)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.BorderSizePixel = 0
    knob.Parent = switch
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    switch.MouseButton1Click:Connect(function()
        local newState = switch.BackgroundColor3 ~= Color3.fromRGB(0, 162, 255)
        switch.BackgroundColor3 = newState and Color3.fromRGB(0, 162, 255) or Color3.fromRGB(45, 48, 55)
        knob.Position = newState and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 3, 0.5, -6)
        callback(newState)
    end)
end

-- POPULATE PAGES
createPage("Main")
createPage("College Football")
createPage("OFL")
createPage("Settings")

Pages["College Football"].Visible = true
Tabs["College Football"].BackgroundTransparency = 0
Tabs["College Football"].TextColor3 = Color3.fromRGB(255, 255, 255)

-- COLLEGE FOOTBALL INTERFACE SETUP
createSection("College Football", "Magnet Settings")
createSlider("College Football", "Mags (Radius Range)", 1, 100, MagPower, function(val)
    MagPower = val
end)
createToggle("College Football", "Enable Magnet", "Activates targeted checks strictly for parts named Handle", MagsEnabled, function(state)
    MagsEnabled = state
end)
createToggle("College Football", "Show Magnet Hitbox", "Renders a square bounding box showing true magnet reach", HitboxVisualEnabled, function(state)
    HitboxVisualEnabled = state
end)

createSection("College Football", "Automation Engine")
createToggle("College Football", "Auto-Tuck (E)", "Instantly triggers E keypress upon ball detection", AutoTuckEnabled, function(state)
    AutoTuckEnabled = state
end)

createSection("College Football", "Physics Overrides")
createToggle("College Football", "Enable Jump Power", "Enables custom snappy assembly jump mechanics", JumpPowerEnabled, function(state)
    JumpPowerEnabled = state
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        if state then
            char.Humanoid.JumpPower = math.min(JumpPowerValue, 60)
        else
            char.Humanoid.JumpPower = OriginalJumpPower
        end
    end
end)
createSlider("College Football", "Jump Power", 1, 100, JumpPowerValue, function(val)
    JumpPowerValue = val
    if JumpPowerEnabled then
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.JumpPower = math.min(val, 60)
        end
    end
end)

-- MERGED OFL & FACILITY DIRECTLY UNDER THE OFL TAB (Plus matching utilities)
createSection("OFL", "OFL Magnet Engine")
createSlider("OFL", "OFL Mags Reach", 1, 100, GotNextMagPower, function(val)
    GotNextMagPower = val
end)
createToggle("OFL", "Enable OFL Magnets", "Activates targeted checks strictly for parts named FootballHandle", GotNextMagsEnabled, function(state)
    GotNextMagsEnabled = state
end)
createToggle("OFL", "Show OFL Hitbox", "Renders a red visual perimeter representing the optimized OFL zone", GotNextHitboxVisualEnabled, function(state)
    GotNextHitboxVisualEnabled = state
end)

createSection("OFL", "Facility Magnet Engine")
createSlider("OFL", "Facility Mags Reach", 1, 100, FacilityMagPower, function(val)
    FacilityMagPower = val
end)
createToggle("OFL", "Enable Facility Magnets", "Activates targeted checks strictly for parts named Sxw0mG8l", FacilityMagsEnabled, function(state)
    FacilityMagsEnabled = state
end)
createToggle("OFL", "Show Facility Hitbox", "Renders a purple perimeter representing the active Facility bounds", FacilityHitboxVisualEnabled, function(state)
    FacilityHitboxVisualEnabled = state
end)

createSection("OFL", "Automation & Physics Utilities")
createToggle("OFL", "Auto-Tuck (E)", "Instantly triggers E keypress upon ball detection", AutoTuckEnabled, function(state)
    AutoTuckEnabled = state
end)
createToggle("OFL", "Enable Jump Power", "Enables custom snappy assembly jump mechanics", JumpPowerEnabled, function(state)
    JumpPowerEnabled = state
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        if state then
            char.Humanoid.JumpPower = math.min(JumpPowerValue, 60)
        else
            char.Humanoid.JumpPower = OriginalJumpPower
        end
    end
end)
createSlider("OFL", "Jump Power", 1, 100, JumpPowerValue, function(val)
    JumpPowerValue = val
    if JumpPowerEnabled then
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.JumpPower = math.min(val, 60)
        end
    end
end)


-- SETTINGS INTERFACE SETUP
createSection("Settings", "Interface Options")
createToggle("Settings", "Close Interface", "It can be reopened again by pressing K", false, function(state)
    if state then
        MainHub.Visible = false
    end
end)


-- MOBILE & DESKTOP DRAGGING PLATFORM (MAIN HUB)
local dragToggle = nil
local dragStart = nil
local startPos = nil

Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragToggle = true
        dragStart = input.Position
        startPos = MainHub.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragToggle = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragToggle and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        MainHub.Position = UDim2.new(
            startPos.X.Scale, 
            startPos.X.Offset + delta.X, 
            startPos.Y.Scale, 
            startPos.Y.Offset + delta.Y
        )
    end
end)


-- MOBILE & DESKTOP DRAGGING PLATFORM (KEY HUB)
local keyDragToggle = nil
local keyDragStart = nil
local keyStartPos = nil

KeyHeader.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        keyDragToggle = true
        keyDragStart = input.Position
        keyStartPos = KeyHub.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                keyDragToggle = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if keyDragToggle and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - keyDragStart
        KeyHub.Position = UDim2.new(
            keyStartPos.X.Scale, 
            keyStartPos.X.Offset + delta.X, 
            keyStartPos.Y.Scale, 
            keyStartPos.Y.Offset + delta.Y
        )
    end
end)


-- KEYBOARD TOGGLE HANDLER ('K')
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.K and not KeyHub.Visible then
        MainHub.Visible = not MainHub.Visible
    end
end)