local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

if PlayerGui:FindFirstChild("HackerHubV2") then
    PlayerGui.HackerHubV2:Destroy()
end

if PlayerGui:FindFirstChild("ToggleMenuGui") then
    PlayerGui.ToggleMenuGui:Destroy()
end

if PlayerGui:FindFirstChild("InvisibleUI") then
    PlayerGui.InvisibleUI:Destroy()
end

if _G.InvisibleConnections then
    for _, connection in pairs(_G.InvisibleConnections) do
        if connection then connection:Disconnect() end
    end
    _G.InvisibleConnections = nil
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HackerHubV2"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 520, 0, 380)
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -190)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Thickness = 2
UIStroke.Color = Color3.fromRGB(100, 50, 255)
UIStroke.Parent = MainFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 0, 40)
TitleLabel.Position = UDim2.new(0, 0, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = " Hacker_Hub_V2_2027 | MM2"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 18
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = MainFrame

local ContentFrame = Instance.new("ScrollingFrame")
ContentFrame.Size = UDim2.new(1, -20, 1, -55)
ContentFrame.Position = UDim2.new(0, 10, 0, 45)
ContentFrame.BackgroundTransparency = 1
ContentFrame.CanvasSize = UDim2.new(0, 0, 2.5, 0)
ContentFrame.ScrollBarThickness = 6
ContentFrame.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 8)
UIListLayout.Parent = ContentFrame

local function createCategory(name)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 25)
    lbl.BackgroundTransparency = 1
    lbl.Text = "  📌 " .. name
    lbl.TextColor3 = Color3.fromRGB(170, 130, 255)
    lbl.TextSize = 15
    lbl.Font = Enum.Font.GothamBold
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = ContentFrame
end

local function createToggle(text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 32)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    btn.Text = "   " .. text .. ": OFF"
    btn.TextColor3 = Color3.fromRGB(220, 220, 220)
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamMedium
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Parent = ContentFrame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn
    
    local active = false
    btn.MouseButton1Click:Connect(function()
        active = not active
        btn.Text = "   " .. text .. ": " .. (active and "ON" or "OFF")
        btn.BackgroundColor3 = active and Color3.fromRGB(60, 30, 120) or Color3.fromRGB(35, 35, 45)
        pcall(function() callback(active) end)
    end)
end

createCategory("มอง (ESP)")
createToggle("มองบทบาท", function(v)
    _G.EspRoles = v
    task.spawn(function()
        while _G.EspRoles do
            task.wait(1)
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character then
                    local h = p.Character:FindFirstChild("Highlight")
                    if not h then h = Instance.new("Highlight", p.Character) end
                    local backpack = p:FindFirstChild("Backpack")
                    local char = p.Character
                    local hasKnife = (backpack and backpack:FindFirstChild("Knife")) or (char and char:FindFirstChild("Knife"))
                    local hasGun = (backpack and backpack:FindFirstChild("Gun")) or (char and char:FindFirstChild("Gun"))
                    
                    if hasKnife then
                        h.FillColor = Color3.fromRGB(255, 0, 0)
                    elseif hasGun then
                        h.FillColor = Color3.fromRGB(0, 100, 255)
                    else
                        h.FillColor = Color3.fromRGB(0, 255, 0)
                    end
                end
            end
        end
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("Highlight") then
                p.Character.Highlight:Destroy()
            end
        end
    end)
end)

createToggle("มองปืนที่ตก", function(v)
    _G.EspGun = v
    task.spawn(function()
        while _G.EspGun do
            task.wait(0.5)
            for _, obj in pairs(Workspace:GetDescendants()) do
                if obj.Name == "GunDrop" and not obj:FindFirstChild("Highlight") then
                    local h = Instance.new("Highlight", obj)
                    h.FillColor = Color3.fromRGB(255, 215, 0)
                end
            end
        end
    end)
end)

createToggle("มองโปร/แฮ็กเกอร์", function(v)
end)

createCategory("ระบบป้องกัน (Anti)")
createToggle("กันปลิว/กันกระเด็น", function(v)
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CustomPhysicalProperties = v and PhysicalProperties.new(100, 0, 0) or PhysicalProperties.new(0.7, 0.3, 0.5)
    end
end)

createToggle("กันเตะ/กันแบน/กันเน็ตกาก/กันค้าง", function(v)
    _G.AntiLag = v
    if v then
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    end
end)

createCategory("ผู้เล่น (Player Mods)")
createToggle("วิ่งเร็ว", function(v)
    _G.SpeedEnabled = v
    task.spawn(function()
        while _G.SpeedEnabled do
            task.wait()
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("Humanoid") then
                char.Humanoid.WalkSpeed = v and 35 or 16
            end
        end
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then char.Humanoid.WalkSpeed = 16 end
    end)
end)

createToggle("กระโดดไม่จำกัด", function(v)
    _G.InfJump = v
    UserInputService.JumpRequest:Connect(function()
        if _G.InfJump then
            local char = LocalPlayer.Character
            if char and char:FindFirstChildOfClass("Humanoid") then
                char.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end)
end)

createToggle("ทะลุ", function(v)
    _G.Noclip = v
    RunService.Stepped:Connect(function()
        if _G.Noclip and LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end
    end)
end)

createCategory("ตัวช่วยเล่น (Helper)")
createToggle("ออโต้เก็บปืน (ที่ตก)", function(v)
    _G.AutoGrabGun = v
    task.spawn(function()
        while _G.AutoGrabGun do
            task.wait(0.2)
            pcall(function()
                for _, obj in pairs(Workspace:GetDescendants()) do
                    if obj.Name == "GunDrop" and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        LocalPlayer.Character.HumanoidRootPart.CFrame = obj.CFrame
                    end
                end
            end)
        end
    end)
end)

createToggle("สไลด์เก็บเหรียญ (ความเร็ว 19/20)", function(v)
    _G.AutoCoin = v
    task.spawn(function()
        while _G.AutoCoin do
            task.wait(0.1)
            pcall(function()
                for _, obj in pairs(Workspace:GetDescendants()) do
                    if obj.Name == "Coin" and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        LocalPlayer.Character.HumanoidRootPart.CFrame = obj.CFrame
                    end
                end
            end)
        end
    end)
end)

createToggle("ล็อคหัวฆาตกร", function(v)
    _G.Aimbot = v
    RunService.RenderStepped:Connect(function()
        if _G.Aimbot then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                    local bp = p:FindFirstChild("Backpack")
                    local ch = p.Character
                    if (bp and bp:FindFirstChild("Knife")) or (ch and ch:FindFirstChild("Knife")) then
                        Workspace.CurrentCamera.CFrame = CFrame.new(Workspace.CurrentCamera.CFrame.Position, p.Character.Head.Position)
                    end
                end
            end
        end
    end)
end)

local ToggleGui = Instance.new("ScreenGui")
ToggleGui.Name = "ToggleMenuGui"
ToggleGui.ResetOnSpawn = false
ToggleGui.Parent = PlayerGui

local toggleMenuBtn = Instance.new("TextButton")
toggleMenuBtn.Size = UDim2.new(0, 44, 0, 44)
toggleMenuBtn.Position = UDim2.new(0.02, 0, 0.2, 0)
toggleMenuBtn.BackgroundColor3 = Color3.fromRGB(60, 30, 120)
toggleMenuBtn.Text = ""
toggleMenuBtn.Active = true
toggleMenuBtn.Draggable = true
toggleMenuBtn.Parent = ToggleGui

local menuCorner = Instance.new("UICorner", toggleMenuBtn)
menuCorner.CornerRadius = UDim.new(0, 8)

local menuIcon = Instance.new("ImageLabel")
menuIcon.Size = UDim2.new(0, 28, 0, 28)
menuIcon.Position = UDim2.new(0.5, -14, 0.5, -14)
menuIcon.BackgroundTransparency = 1
menuIcon.Image = "rbxassetid://109553542784125"
menuIcon.Parent = toggleMenuBtn

local menuVisible = true
toggleMenuBtn.MouseButton1Click:Connect(function()
    menuVisible = not menuVisible
    MainFrame.Visible = menuVisible
end)

local FloatGui = Instance.new("ScreenGui")
FloatGui.Name = "HackerFloating"
FloatGui.ResetOnSpawn = false
FloatGui.Parent = PlayerGui

local function createFloatingButton(name, pos, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 110, 0, 40)
    btn.Position = pos
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamBold
    btn.Active = true
    btn.Draggable = true
    btn.Parent = FloatGui
    
    local c = Instance.new("UICorner", btn)
    c.CornerRadius = UDim.new(0, 8)
    
    btn.MouseButton1Click:Connect(callback)
end

createFloatingButton("🔥 ยิงฆาตกร", UDim2.new(0.02, 0, 0.26, 0), function()
end)

createFloatingButton("🗡️ ปามีดออโต้", UDim2.new(0.02, 0, 0.32, 0), function()
end)

createFloatingButton("🎯 เก็บปืน", UDim2.new(0.02, 0, 0.38, 0), function()
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj.Name == "GunDrop" and LocalPlayer.Character then
            LocalPlayer.Character.HumanoidRootPart.CFrame = obj.CFrame
        end
    end
end)

local character, humanoid, rootPart
local partsList = {}
local isInvisible = false
local invisButton, textLabel

local function updateCharacterParts()
    character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    humanoid = character:WaitForChild("Humanoid")
    rootPart = character:WaitForChild("HumanoidRootPart")
    
    partsList = {}
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") and part.Transparency == 0 then
            table.insert(partsList, part)
        end
    end
end

local function toggleInvisibility()
    isInvisible = not isInvisible
    if textLabel then
        textLabel.Text = "ล่องหน: " .. (isInvisible and "ON" or "OFF")
    end
    if invisButton then
        invisButton.BackgroundColor3 = isInvisible and Color3.fromRGB(40, 180, 40) or Color3.fromRGB(255, 0, 0)
    end
    for _, part in pairs(partsList) do
        if part and part.Parent then
            part.Transparency = isInvisible and 0.5 or 0
        end
    end
end

local function createInvisUI()
    local invisGui = Instance.new("ScreenGui")
    invisGui.Name = "InvisibleUI"
    invisGui.ResetOnSpawn = false
    
    invisButton = Instance.new("TextButton")
    invisButton.Size = UDim2.new(0, 150, 0, 40)
    invisButton.Position = UDim2.new(0.02, 0, 0.46, 0)
    invisButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    invisButton.Text = ""
    invisButton.Active = true
    invisButton.Parent = invisGui

    local corner = Instance.new("UICorner", invisButton)
    corner.CornerRadius = UDim.new(0, 8)

    local iconImg = Instance.new("ImageLabel")
    iconImg.Size = UDim2.new(0, 28, 0, 28)
    iconImg.Position = UDim2.new(0, 6, 0.5, -14)
    iconImg.BackgroundTransparency = 1
    iconImg.Image = "rbxassetid://109553542784125"
    iconImg.Parent = invisButton

    textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, -38, 1, 0)
    textLabel.Position = UDim2.new(0, 36, 0, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = "ล่องหน: OFF"
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.Font = Enum.Font.GothamBold
    textLabel.TextSize = 14
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.Parent = invisButton

    invisGui.Parent = PlayerGui

    local dragging, dragInput, dragStart, startPos
    
    invisButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = invisButton.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    invisButton.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    RunService.Heartbeat:Connect(function()
        if dragging and dragInput then
            local delta = dragInput.Position - dragStart
            invisButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    invisButton.MouseButton1Click:Connect(function()
        toggleInvisibility()
    end)
end

updateCharacterParts()
createInvisUI()

local connections = {}

local mouse = LocalPlayer:GetMouse()
connections[1] = mouse.KeyDown:Connect(function(key)
    if key:lower() == "g" then
        toggleInvisibility()
    end
end)

connections[2] = RunService.Heartbeat:Connect(function()
    if isInvisible and rootPart and humanoid then
        local originalCFrame = rootPart.CFrame
        local targetCFrame = originalCFrame * CFrame.new(0, -200000, 0)
        
        humanoid.CameraOffset = targetCFrame:ToObjectSpace(CFrame.new(originalCFrame.Position)).Position
        rootPart.CFrame = targetCFrame
        
        RunService.RenderStepped:Wait()
        
        if humanoid and rootPart then
            humanoid.CameraOffset = Vector3.new(0, 0, 0)
            rootPart.CFrame = originalCFrame
        end
    end
end)

connections[3] = LocalPlayer.CharacterAdded:Connect(function()
    isInvisible = false
    if textLabel then textLabel.Text = "ล่องหน: OFF" end
    if invisButton then invisButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0) end
    task.wait(0.5)
    updateCharacterParts()
end)

_G.InvisibleConnections = connections