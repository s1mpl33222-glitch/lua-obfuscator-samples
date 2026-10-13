
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer

local function getGuiParent()
    if LocalPlayer:FindFirstChild("PlayerGui") then
        return LocalPlayer.PlayerGui
    end
    return CoreGui
end

local GUI_PARENT = getGuiParent()

local VERSIONS = {
    V1 = {
        Range = 250,
        TPOffset = Vector3.new(0, 0, 0),
        LoopDelay = 0.08,
        SmartRotation = true,
        ResetVelocity = true,
        PredictMovement = true,
        PredictionFactor = 0.15,
        HealthCheck = true,
        TeamCheck = false,
        BehindTarget = false,
        BehindDistance = 4,
        AntiFling = true,
        SafeDistance = 3,
        SideOffset = 2.5,
    },
    V2 = {
        Range = 250,
        TPOffset = Vector3.new(0, 3, 0),
        LoopDelay = 0.08,
        SmartRotation = false,
        ResetVelocity = true,
        PredictMovement = false,
        PredictionFactor = 0,
        HealthCheck = true,
        TeamCheck = false,
        BehindTarget = false,
        BehindDistance = 0,
        AntiFling = false,
        SafeDistance = 0,
        SideOffset = 0,
    },
}

local CONFIG = {
    ToggleKey = Enum.KeyCode.Y,
    AntiDieKey = Enum.KeyCode.G,
    AutoBatEnabled = true,
    AutoBatDelay = 0.08,
    CurrentVersion = "V1",
}

local State = {
    TpBatEnabled = false,
    AntiDieEnabled = false,
    isRunning = false,
    tpLoopThread = nil,
    isWaitingForKey = false,
    hittingCooldown = false,
    Ref = {},
}

local function getActiveConfig()
    return VERSIONS[CONFIG.CurrentVersion]
end

local function getMyHRP()
    local char = LocalPlayer.Character
    if not char then return nil end
    return char:FindFirstChild("HumanoidRootPart")
end

local function getMyHumanoid()
    local char = LocalPlayer.Character
    if not char then return nil end
    return char:FindFirstChildOfClass("Humanoid")
end

local function getBat()
    local char = LocalPlayer.Character
    if not char then return nil end
    local tool = char:FindFirstChild("Bat")
    if tool then return tool end
    local bp = LocalPlayer:FindFirstChild("Backpack")
    if bp then
        tool = bp:FindFirstChild("Bat")
        if tool then
            tool.Parent = char
            return tool
        end
    end
    return nil
end

local function tryHitBat()
    if State.hittingCooldown then return end
    State.hittingCooldown = true
    pcall(function()
        local bat = getBat()
        if bat then
            bat:Activate()
            local ev = bat:FindFirstChildWhichIsA("RemoteEvent")
            if ev then ev:FireServer() end
        end
    end)
    task.delay(CONFIG.AutoBatDelay, function() State.hittingCooldown = false end)
end

local function isValidEnemy(player)
    local cfg = getActiveConfig()
    if player == LocalPlayer then return false end
    if not player.Character then return false end

    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return false end
    if cfg.HealthCheck and humanoid.Health <= 0 then return false end

    if cfg.TeamCheck then
        if player.Team == LocalPlayer.Team and player.Team ~= nil then
            return false
        end
    end

    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    return true, hrp, humanoid
end

local function predictPosition(hrp)
    local cfg = getActiveConfig()
    if not cfg.PredictMovement then return hrp.Position end
    return hrp.Position + (hrp.AssemblyLinearVelocity * cfg.PredictionFactor)
end

local function findNearestEnemy()
    local cfg = getActiveConfig()
    local myHRP = getMyHRP()
    if not myHRP then return nil end

    local nearestHRP = nil
    local shortestDist = cfg.Range

    for _, player in ipairs(Players:GetPlayers()) do
        local valid, hrp = isValidEnemy(player)
        if valid then
            local dist = (hrp.Position - myHRP.Position).Magnitude
            if dist < shortestDist then
                shortestDist = dist
                nearestHRP = hrp
            end
        end
    end
    return nearestHRP
end

local function teleportTo(targetHRP)
    local cfg = getActiveConfig()
    local myHRP = getMyHRP()
    local myHumanoid = getMyHumanoid()
    if not myHRP then return end

    local targetPos = predictPosition(targetHRP)
    local finalPos

    if cfg.BehindTarget then
        local direction = (targetPos - myHRP.Position).Unit
        finalPos = targetPos + (direction * -cfg.BehindDistance)
        finalPos = finalPos + Vector3.new(0, 2, 0)
    else
        if cfg.SideOffset and cfg.SideOffset > 0 then
            local dir = (myHRP.Position - targetPos)
            dir = Vector3.new(dir.X, 0, dir.Z)
            if dir.Magnitude < 0.1 then
                dir = Vector3.new(1, 0, 0)
            else
                dir = dir.Unit
            end
            finalPos = targetPos + (dir * cfg.SideOffset)
        else
            finalPos = targetPos + cfg.TPOffset
        end
    end

    local newCFrame
    if cfg.SmartRotation then
        newCFrame = CFrame.new(finalPos, targetPos)
    else
        newCFrame = CFrame.new(finalPos)
    end

    myHRP.CFrame = newCFrame

    if cfg.ResetVelocity then
        myHRP.Velocity = Vector3.new(0, 0, 0)
        myHRP.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        myHRP.RotVelocity = Vector3.new(0, 0, 0)
        myHRP.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
    end

    if cfg.AntiFling and myHumanoid then
        myHumanoid.PlatformStand = false
        myHumanoid.Sit = false
    end
end

local function updateStatusUI(active)
    if State.Ref.StatusLabel then
        if active then
            State.Ref.StatusLabel.Text = 'ACTIVE'
            State.Ref.StatusLabel.TextColor3 = Color3.new(0.392157, 1, 0.470588)
            if State.Ref.StatusDot then
                State.Ref.StatusDot.BackgroundColor3 = Color3.new(0.392157, 1, 0.470588)
            end
        else
            State.Ref.StatusLabel.Text = 'INACTIVE'
            State.Ref.StatusLabel.TextColor3 = Color3.new(1, 0.313726, 0.392157)
            if State.Ref.StatusDot then
                State.Ref.StatusDot.BackgroundColor3 = Color3.new(1, 0.313726, 0.392157)
            end
        end
    end
end

local function startTpBat()
    if State.isRunning then return end
    State.isRunning = true
    State.TpBatEnabled = true
    State.tpLoopThread = task.spawn(function()
        while State.TpBatEnabled do
            local target = findNearestEnemy()
            if target then
                teleportTo(target)
                if CONFIG.AutoBatEnabled then
                    tryHitBat()
                end
            end
            task.wait(getActiveConfig().LoopDelay)
        end
    end)
    updateStatusUI(true)
end

local function stopTpBat()
    if not State.isRunning then return end
    State.isRunning = false
    State.TpBatEnabled = false
    if State.tpLoopThread then
        pcall(function() task.cancel(State.tpLoopThread) end)
        State.tpLoopThread = nil
    end
    updateStatusUI(false)
end

local function toggleTpBat()
    if State.TpBatEnabled then stopTpBat() else startTpBat() end
end

local antiDieToggled = false
local billboard = nil

local function createBillboard(char)
    if not char then return end
    local head = char:FindFirstChild("Head") or char:WaitForChild("Head", 5)
    if not head then return end

    if billboard then billboard:Destroy() billboard = nil end
    local old = head:FindFirstChild("AntiDieTag")
    if old then old:Destroy() end

    billboard = Instance.new("BillboardGui")
    billboard.Name = "AntiDieTag"
    billboard.Size = UDim2.new(0, 200, 0, 60)
    billboard.StudsOffsetWorldSpace = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    billboard.LightInfluence = 0
    billboard.MaxDistance = math.huge
    billboard.ResetOnSpawn = false
    billboard.Parent = head

    local frame = Instance.new("Frame", billboard)
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    frame.BackgroundTransparency = 0.3
    frame.BorderSizePixel = 0
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

    local txt1 = Instance.new("TextLabel", frame)
    txt1.Size = UDim2.new(1, 0, 0.5, 0)
    txt1.Position = UDim2.new(0, 0, 0, 0)
    txt1.BackgroundTransparency = 1
    txt1.Text = "ANTI DIE"
    txt1.TextColor3 = Color3.fromRGB(255, 255, 255)
    txt1.Font = Enum.Font.GothamBlack
    txt1.TextSize = 20
    txt1.TextXAlignment = Enum.TextXAlignment.Center
    txt1.TextYAlignment = Enum.TextYAlignment.Bottom

    local txt2 = Instance.new("TextLabel", frame)
    txt2.Size = UDim2.new(1, 0, 0.5, 0)
    txt2.Position = UDim2.new(0, 0, 0.5, 0)
    txt2.BackgroundTransparency = 1
    txt2.Text = "debofed by fa4e7xx"
    txt2.TextColor3 = Color3.fromRGB(255, 255, 255)
    txt2.Font = Enum.Font.GothamBold
    txt2.TextSize = 14
    txt2.TextXAlignment = Enum.TextXAlignment.Center
    txt2.TextYAlignment = Enum.TextYAlignment.Top
end

local function destroyBillboard()
    if billboard then
        billboard:Destroy()
        billboard = nil
    end
    local char = LocalPlayer.Character
    if char then
        local head = char:FindFirstChild("Head")
        if head then
            local old = head:FindFirstChild("AntiDieTag")
            if old then old:Destroy() end
        end
    end
end

local heartConn = nil
local deathConns = {}
local charAddedConn = nil

local function protectChar(char)
    if not char then return end
    local hum = char:WaitForChild("Humanoid", 5)
    if not hum then return end

    hum.MaxHealth = math.huge
    hum.Health = math.huge
    hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)

    local sc = hum.StateChanged:Connect(function(_, new)
        if not antiDieToggled then return end
        if new == Enum.HumanoidStateType.Dead then
            hum.Health = math.huge
            hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
        end
    end)
    table.insert(deathConns, sc)

    local hc = hum:GetPropertyChangedSignal("Health"):Connect(function()
        if not antiDieToggled then return end
        if hum.Health < hum.MaxHealth then
            hum.Health = math.huge
        end
    end)
    table.insert(deathConns, hc)

    if heartConn then heartConn:Disconnect() end
    heartConn = RunService.Heartbeat:Connect(function()
        if not antiDieToggled then return end
        if hum and hum.Parent and hum.Health < hum.MaxHealth then
            hum.Health = math.huge
        end
    end)

    createBillboard(char)
end

local function startAntiDie()
    antiDieToggled = true
    State.AntiDieEnabled = true

    for _, c in ipairs(deathConns) do pcall(function() c:Disconnect() end) end
    deathConns = {}
    if heartConn then heartConn:Disconnect(); heartConn = nil end
    if charAddedConn then charAddedConn:Disconnect(); charAddedConn = nil end

    local char = LocalPlayer.Character
    if char then protectChar(char) end

    charAddedConn = LocalPlayer.CharacterAdded:Connect(function(c)
        if not antiDieToggled then return end
        task.wait(0.2)
        for _, c2 in ipairs(deathConns) do pcall(function() c2:Disconnect() end) end
        deathConns = {}
        protectChar(c)
    end)
end

local function stopAntiDie()
    antiDieToggled = false
    State.AntiDieEnabled = false

    for _, c in ipairs(deathConns) do pcall(function() c:Disconnect() end) end
    deathConns = {}
    if heartConn then heartConn:Disconnect(); heartConn = nil end
    if charAddedConn then charAddedConn:Disconnect(); charAddedConn = nil end

    destroyBillboard()

    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
            hum.MaxHealth = 100
            hum.Health = 100
        end
    end
end

local function toggleAntiDie()
    if antiDieToggled then stopAntiDie() else startAntiDie() end
end

local function startKeybindListener()
    if State.isWaitingForKey then return end
    State.isWaitingForKey = true

    if State.Ref.KeyLabel then
        State.Ref.KeyLabel.Text = '...'
        State.Ref.KeyLabel.TextColor3 = Color3.new(1, 0.8, 0.2)
    end

    local connection
    connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.UserInputType ~= Enum.UserInputType.Keyboard then return end

        if input.KeyCode == Enum.KeyCode.Escape then
            State.isWaitingForKey = false
            if State.Ref.KeyLabel then
                State.Ref.KeyLabel.Text = CONFIG.ToggleKey.Name
                State.Ref.KeyLabel.TextColor3 = Color3.new(0.784314, 0.784314, 0.784314)
            end
            connection:Disconnect()
            return
        end

        CONFIG.ToggleKey = input.KeyCode
        State.isWaitingForKey = false

        if State.Ref.KeyLabel then
            State.Ref.KeyLabel.Text = input.KeyCode.Name
            State.Ref.KeyLabel.TextColor3 = Color3.new(0.392157, 1, 0.470588)
            task.wait(0.3)
            State.Ref.KeyLabel.TextColor3 = Color3.new(0.784314, 0.784314, 0.784314)
        end

        connection:Disconnect()
    end)
end

local function buildUI()
    local old = GUI_PARENT:FindFirstChild("SpaceTpBatUI")
    if old then old:Destroy() end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = 'SpaceTpBatUI'
    ScreenGui.ResetOnSpawn = false
    ScreenGui.DisplayOrder = 10
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = GUI_PARENT

    local Main = Instance.new("Frame")
    Main.Name = 'Main'
    Main.Size = UDim2.new(0, 250, 0, 300)
    Main.Position = UDim2.new(0.5, -125, 0.5, -150)
    Main.BackgroundColor3 = Color3.new(0.05, 0.05, 0.05)
    Main.BorderSizePixel = 0
    Main.Active = true
    Main.ClipsDescendants = true
    Main.ZIndex = 1
    Main.Parent = ScreenGui

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 16)
    MainCorner.Parent = Main

    pcall(function()
        local ImageLabel = Instance.new("ImageLabel")
        ImageLabel.Name = "BackgroundImage"
        ImageLabel.Size = UDim2.new(0, 250, 0, 300)
        ImageLabel.Position = UDim2.new(0, 0, 0, 0)
        ImageLabel.BackgroundTransparency = 1
        ImageLabel.Image = 'rbxassetid://114138477258742'
        ImageLabel.ScaleType = Enum.ScaleType.Crop
        ImageLabel.ZIndex = 0
        ImageLabel.Parent = Main
    end)

    local Dot = Instance.new("Frame")
    Dot.Size = UDim2.new(0, 10, 0, 10)
    Dot.Position = UDim2.new(0, 16, 0, 12)
    Dot.BackgroundColor3 = Color3.new(0.705882, 0.705882, 0.705882)
    Dot.BorderSizePixel = 0
    Dot.ZIndex = 5
    Dot.Parent = Main

    local DotCorner = Instance.new("UICorner")
    DotCorner.CornerRadius = UDim.new(1, 0)
    DotCorner.Parent = Dot

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(0, 180, 0, 18)
    Title.Position = UDim2.new(0, 36, 0, 6)
    Title.BackgroundTransparency = 1
    Title.Text = 'Space Tp Bat'
    Title.TextColor3 = Color3.new(1, 1, 1)
    Title.Font = Enum.Font.GothamBlack
    Title.TextSize = 15
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.ZIndex = 5
    Title.Parent = Main

    local Subtitle = Instance.new("TextLabel")
    Subtitle.Size = UDim2.new(0, 180, 0, 14)
    Subtitle.Position = UDim2.new(0, 36, 0, 26)
    Subtitle.BackgroundTransparency = 1
    Subtitle.Text = 'debofed by fa4e7xx'
    Subtitle.TextColor3 = Color3.new(0.784314, 0.784314, 0.784314)
    Subtitle.Font = Enum.Font.Gotham
    Subtitle.TextSize = 10
    Subtitle.TextXAlignment = Enum.TextXAlignment.Left
    Subtitle.ZIndex = 5
    Subtitle.Parent = Main

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 24, 0, 24)
    CloseBtn.Position = UDim2.new(1, -32, 0, 10)
    CloseBtn.BackgroundColor3 = Color3.new(0.0980392, 0.0980392, 0.0980392)
    CloseBtn.BackgroundTransparency = 0.5
    CloseBtn.Text = '-'
    CloseBtn.TextColor3 = Color3.new(1, 1, 1)
    CloseBtn.Font = Enum.Font.GothamBlack
    CloseBtn.TextSize = 16
    CloseBtn.BorderSizePixel = 0
    CloseBtn.ZIndex = 5
    CloseBtn.Parent = Main

    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 6)
    CloseCorner.Parent = CloseBtn

    local StatusBox = Instance.new("Frame")
    StatusBox.Size = UDim2.new(1, -24, 0, 32)
    StatusBox.Position = UDim2.new(0, 12, 0, 62)
    StatusBox.BackgroundColor3 = Color3.new(0.0588235, 0.0588235, 0.0588235)
    StatusBox.BackgroundTransparency = 0.5
    StatusBox.BorderSizePixel = 0
    StatusBox.ZIndex = 4
    StatusBox.Parent = Main

    local StatusBoxCorner = Instance.new("UICorner")
    StatusBoxCorner.CornerRadius = UDim.new(0, 12)
    StatusBoxCorner.Parent = StatusBox

    local StatusDot = Instance.new("Frame")
    StatusDot.Size = UDim2.new(0, 8, 0, 8)
    StatusDot.Position = UDim2.new(0, 14, 0.5, -4)
    StatusDot.BackgroundColor3 = Color3.new(1, 0.313726, 0.392157)
    StatusDot.BorderSizePixel = 0
    StatusDot.ZIndex = 6
    StatusDot.Parent = StatusBox

    local StatusDotCorner = Instance.new("UICorner")
    StatusDotCorner.CornerRadius = UDim.new(1, 0)
    StatusDotCorner.Parent = StatusDot

    local StatusTextLabel = Instance.new("TextLabel")
    StatusTextLabel.Size = UDim2.new(0, 100, 1, 0)
    StatusTextLabel.Position = UDim2.new(0, 30, 0, 0)
    StatusTextLabel.BackgroundTransparency = 1
    StatusTextLabel.Text = 'Status'
    StatusTextLabel.TextColor3 = Color3.new(1, 1, 1)
    StatusTextLabel.Font = Enum.Font.GothamBold
    StatusTextLabel.TextSize = 13
    StatusTextLabel.TextXAlignment = Enum.TextXAlignment.Left
    StatusTextLabel.ZIndex = 6
    StatusTextLabel.Parent = StatusBox

    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Size = UDim2.new(0, 120, 1, 0)
    StatusLabel.Position = UDim2.new(1, -124, 0, 0)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Text = 'INACTIVE'
    StatusLabel.TextColor3 = Color3.new(1, 0.313726, 0.392157)
    StatusLabel.Font = Enum.Font.GothamBold
    StatusLabel.TextSize = 14
    StatusLabel.TextXAlignment = Enum.TextXAlignment.Right
    StatusLabel.ZIndex = 6
    StatusLabel.Parent = StatusBox

    local TpBox = Instance.new("Frame")
    TpBox.Size = UDim2.new(1, -24, 0, 50)
    TpBox.Position = UDim2.new(0, 12, 0, 102)
    TpBox.BackgroundColor3 = Color3.new(0.0588235, 0.0588235, 0.0588235)
    TpBox.BackgroundTransparency = 0.5
    TpBox.BorderSizePixel = 0
    TpBox.ZIndex = 4
    TpBox.Parent = Main

    local TpBoxCorner = Instance.new("UICorner")
    TpBoxCorner.CornerRadius = UDim.new(0, 12)
    TpBoxCorner.Parent = TpBox

    local TpText = Instance.new("TextLabel")
    TpText.Size = UDim2.new(0, 90, 0, 18)
    TpText.Position = UDim2.new(0, 14, 0, 16)
    TpText.BackgroundTransparency = 1
    TpText.Text = 'TP Bat'
    TpText.TextColor3 = Color3.new(1, 1, 1)
    TpText.Font = Enum.Font.GothamBold
    TpText.TextSize = 14
    TpText.TextXAlignment = Enum.TextXAlignment.Left
    TpText.ZIndex = 6
    TpText.Parent = TpBox

    local KeyLabel = Instance.new("TextButton")
    KeyLabel.Size = UDim2.new(0, 34, 0, 20)
    KeyLabel.Position = UDim2.new(1, -100, 0.5, -10)
    KeyLabel.BackgroundColor3 = Color3.new(0.156863, 0.156863, 0.156863)
    KeyLabel.BackgroundTransparency = 0.3
    KeyLabel.Text = CONFIG.ToggleKey.Name
    KeyLabel.TextColor3 = Color3.new(0.784314, 0.784314, 0.784314)
    KeyLabel.Font = Enum.Font.GothamBold
    KeyLabel.TextSize = 12
    KeyLabel.AutoButtonColor = false
    KeyLabel.BorderSizePixel = 0
    KeyLabel.ZIndex = 6
    KeyLabel.Parent = TpBox

    local KeyLabelCorner = Instance.new("UICorner")
    KeyLabelCorner.CornerRadius = UDim.new(0, 6)
    KeyLabelCorner.Parent = KeyLabel

    local TpSwitch = Instance.new("TextButton")
    TpSwitch.Size = UDim2.new(0, 44, 0, 22)
    TpSwitch.Position = UDim2.new(1, -58, 0.5, -11)
    TpSwitch.BackgroundColor3 = Color3.new(0.156863, 0.156863, 0.156863)
    TpSwitch.Text = ''
    TpSwitch.BorderSizePixel = 0
    TpSwitch.ZIndex = 6
    TpSwitch.Parent = TpBox

    local TpSwitchCorner = Instance.new("UICorner")
    TpSwitchCorner.CornerRadius = UDim.new(0, 11)
    TpSwitchCorner.Parent = TpSwitch

    local TpKnob = Instance.new("Frame")
    TpKnob.Size = UDim2.new(0, 16, 0, 16)
    TpKnob.Position = UDim2.new(0, 3, 0.5, -8)
    TpKnob.BackgroundColor3 = Color3.new(0.784314, 0.784314, 0.784314)
    TpKnob.BorderSizePixel = 0
    TpKnob.ZIndex = 7
    TpKnob.Parent = TpSwitch

    local TpKnobCorner = Instance.new("UICorner")
    TpKnobCorner.CornerRadius = UDim.new(1, 0)
    TpKnobCorner.Parent = TpKnob

    local AntiBox = Instance.new("Frame")
    AntiBox.Size = UDim2.new(1, -24, 0, 50)
    AntiBox.Position = UDim2.new(0, 12, 0, 160)
    AntiBox.BackgroundColor3 = Color3.new(0.0588235, 0.0588235, 0.0588235)
    AntiBox.BackgroundTransparency = 0.5
    AntiBox.BorderSizePixel = 0
    AntiBox.ZIndex = 4
    AntiBox.Parent = Main

    local AntiBoxCorner = Instance.new("UICorner")
    AntiBoxCorner.CornerRadius = UDim.new(0, 12)
    AntiBoxCorner.Parent = AntiBox

    local AntiText = Instance.new("TextLabel")
    AntiText.Size = UDim2.new(0, 150, 0, 18)
    AntiText.Position = UDim2.new(0, 14, 0, 16)
    AntiText.BackgroundTransparency = 1
    AntiText.Text = 'Anti Die'
    AntiText.TextColor3 = Color3.new(1, 1, 1)
    AntiText.Font = Enum.Font.GothamBold
    AntiText.TextSize = 14
    AntiText.TextXAlignment = Enum.TextXAlignment.Left
    AntiText.ZIndex = 6
    AntiText.Parent = AntiBox

    local AntiSwitch = Instance.new("TextButton")
    AntiSwitch.Size = UDim2.new(0, 44, 0, 22)
    AntiSwitch.Position = UDim2.new(1, -58, 0.5, -11)
    AntiSwitch.BackgroundColor3 = Color3.new(0.156863, 0.156863, 0.156863)
    AntiSwitch.Text = ''
    AntiSwitch.BorderSizePixel = 0
    AntiSwitch.ZIndex = 6
    AntiSwitch.Parent = AntiBox

    local AntiSwitchCorner = Instance.new("UICorner")
    AntiSwitchCorner.CornerRadius = UDim.new(0, 11)
    AntiSwitchCorner.Parent = AntiSwitch

    local AntiKnob = Instance.new("Frame")
    AntiKnob.Size = UDim2.new(0, 16, 0, 16)
    AntiKnob.Position = UDim2.new(0, 3, 0.5, -8)
    AntiKnob.BackgroundColor3 = Color3.new(0.784314, 0.784314, 0.784314)
    AntiKnob.BorderSizePixel = 0
    AntiKnob.ZIndex = 7
    AntiKnob.Parent = AntiSwitch

    local AntiKnobCorner = Instance.new("UICorner")
    AntiKnobCorner.CornerRadius = UDim.new(1, 0)
    AntiKnobCorner.Parent = AntiKnob

    local VersionBox = Instance.new("Frame")
    VersionBox.Size = UDim2.new(1, -24, 0, 50)
    VersionBox.Position = UDim2.new(0, 12, 0, 218)
    VersionBox.BackgroundColor3 = Color3.new(0.0588235, 0.0588235, 0.0588235)
    VersionBox.BackgroundTransparency = 0.5
    VersionBox.BorderSizePixel = 0
    VersionBox.ZIndex = 4
    VersionBox.Parent = Main

    local VersionBoxCorner = Instance.new("UICorner")
    VersionBoxCorner.CornerRadius = UDim.new(0, 12)
    VersionBoxCorner.Parent = VersionBox

    local VersionText = Instance.new("TextLabel")
    VersionText.Size = UDim2.new(0, 150, 0, 18)
    VersionText.Position = UDim2.new(0, 14, 0, 16)
    VersionText.BackgroundTransparency = 1
    VersionText.Text = 'Version'
    VersionText.TextColor3 = Color3.new(1, 1, 1)
    VersionText.Font = Enum.Font.GothamBold
    VersionText.TextSize = 14
    VersionText.TextXAlignment = Enum.TextXAlignment.Left
    VersionText.ZIndex = 6
    VersionText.Parent = VersionBox

    local V1Btn = Instance.new("TextButton")
    V1Btn.Size = UDim2.new(0, 44, 0, 22)
    V1Btn.Position = UDim2.new(1, -104, 0.5, -11)
    V1Btn.BackgroundColor3 = Color3.new(0.313726, 0.313726, 0.313726)
    V1Btn.Text = 'V1'
    V1Btn.TextColor3 = Color3.new(1, 1, 1)
    V1Btn.TextSize = 11
    V1Btn.Font = Enum.Font.GothamBold
    V1Btn.AutoButtonColor = false
    V1Btn.BorderSizePixel = 0
    V1Btn.ZIndex = 6
    V1Btn.Parent = VersionBox

    local V1Corner = Instance.new("UICorner")
    V1Corner.CornerRadius = UDim.new(0, 6)
    V1Corner.Parent = V1Btn

    local V2Btn = Instance.new("TextButton")
    V2Btn.Size = UDim2.new(0, 44, 0, 22)
    V2Btn.Position = UDim2.new(1, -56, 0.5, -11)
    V2Btn.BackgroundColor3 = Color3.new(0.156863, 0.156863, 0.156863)
    V2Btn.Text = 'V2'
    V2Btn.TextColor3 = Color3.new(1, 1, 1)
    V2Btn.TextSize = 11
    V2Btn.Font = Enum.Font.GothamBold
    V2Btn.AutoButtonColor = false
    V2Btn.BorderSizePixel = 0
    V2Btn.ZIndex = 6
    V2Btn.Parent = VersionBox

    local V2Corner = Instance.new("UICorner")
    V2Corner.CornerRadius = UDim.new(0, 6)
    V2Corner.Parent = V2Btn

    State.Ref.Main = Main
    State.Ref.StatusLabel = StatusLabel
    State.Ref.StatusDot = StatusDot
    State.Ref.TpSwitch = TpSwitch
    State.Ref.TpKnob = TpKnob
    State.Ref.AntiSwitch = AntiSwitch
    State.Ref.AntiKnob = AntiKnob
    State.Ref.KeyLabel = KeyLabel

    local isMinimized = false
    local originalSize = UDim2.new(0, 250, 0, 300)
    local miniSize = UDim2.new(0, 250, 0, 60)

    CloseBtn.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized

        if isMinimized then
            TweenService:Create(Main, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = miniSize
            }):Play()
            CloseBtn.Text = '+'
            StatusBox.Visible = false
            TpBox.Visible = false
            AntiBox.Visible = false
            VersionBox.Visible = false
        else
            TweenService:Create(Main, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = originalSize
            }):Play()
            CloseBtn.Text = '-'
            StatusBox.Visible = true
            TpBox.Visible = true
            AntiBox.Visible = true
            VersionBox.Visible = true
        end
    end)

    KeyLabel.MouseButton1Click:Connect(function()
        startKeybindListener()
    end)

    TpSwitch.MouseButton1Click:Connect(function()
        toggleTpBat()
        if State.TpBatEnabled then
            TweenService:Create(TpKnob, TweenInfo.new(0.2), {
                Position = UDim2.new(1, -19, 0.5, -8),
                BackgroundColor3 = Color3.new(0.392157, 1, 0.470588)
            }):Play()
            TweenService:Create(TpSwitch, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.new(0.235294, 0.392157, 0.235294)
            }):Play()
        else
            TweenService:Create(TpKnob, TweenInfo.new(0.2), {
                Position = UDim2.new(0, 3, 0.5, -8),
                BackgroundColor3 = Color3.new(0.784314, 0.784314, 0.784314)
            }):Play()
            TweenService:Create(TpSwitch, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.new(0.156863, 0.156863, 0.156863)
            }):Play()
        end
    end)

    AntiSwitch.MouseButton1Click:Connect(function()
        toggleAntiDie()
        if State.AntiDieEnabled then
            TweenService:Create(AntiKnob, TweenInfo.new(0.2), {
                Position = UDim2.new(1, -19, 0.5, -8),
                BackgroundColor3 = Color3.new(0.392157, 1, 0.470588)
            }):Play()
            TweenService:Create(AntiSwitch, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.new(0.235294, 0.392157, 0.235294)
            }):Play()
        else
            TweenService:Create(AntiKnob, TweenInfo.new(0.2), {
                Position = UDim2.new(0, 3, 0.5, -8),
                BackgroundColor3 = Color3.new(0.784314, 0.784314, 0.784314)
            }):Play()
            TweenService:Create(AntiSwitch, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.new(0.156863, 0.156863, 0.156863)
            }):Play()
        end
    end)

    V1Btn.MouseButton1Click:Connect(function()
        V1Btn.BackgroundColor3 = Color3.new(0.313726, 0.313726, 0.313726)
        V2Btn.BackgroundColor3 = Color3.new(0.156863, 0.156863, 0.156863)
        CONFIG.CurrentVersion = "V1"
    end)

    V2Btn.MouseButton1Click:Connect(function()
        V2Btn.BackgroundColor3 = Color3.new(0.313726, 0.313726, 0.313726)
        V1Btn.BackgroundColor3 = Color3.new(0.156863, 0.156863, 0.156863)
        CONFIG.CurrentVersion = "V2"
    end)

    local dragging = false
    local dragStart, startPos

    Main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = Main.Position
        end
    end)

    Main.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            Main.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    return ScreenGui
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if State.isWaitingForKey then return end

    if input.KeyCode == CONFIG.ToggleKey then
        toggleTpBat()
        if State.Ref.TpSwitch and State.Ref.TpKnob then
            if State.TpBatEnabled then
                TweenService:Create(State.Ref.TpKnob, TweenInfo.new(0.2), {
                    Position = UDim2.new(1, -19, 0.5, -8),
                    BackgroundColor3 = Color3.new(0.392157, 1, 0.470588)
                }):Play()
                TweenService:Create(State.Ref.TpSwitch, TweenInfo.new(0.2), {
                    BackgroundColor3 = Color3.new(0.235294, 0.392157, 0.235294)
                }):Play()
            else
                TweenService:Create(State.Ref.TpKnob, TweenInfo.new(0.2), {
                    Position = UDim2.new(0, 3, 0.5, -8),
                    BackgroundColor3 = Color3.new(0.784314, 0.784314, 0.784314)
                }):Play()
                TweenService:Create(State.Ref.TpSwitch, TweenInfo.new(0.2), {
                    BackgroundColor3 = Color3.new(0.156863, 0.156863, 0.156863)
                }):Play()
            end
        end
    end

    if input.KeyCode == CONFIG.AntiDieKey then
        toggleAntiDie()
        if State.Ref.AntiSwitch and State.Ref.AntiKnob then
            if State.AntiDieEnabled then
                TweenService:Create(State.Ref.AntiKnob, TweenInfo.new(0.2), {
                    Position = UDim2.new(1, -19, 0.5, -8),
                    BackgroundColor3 = Color3.new(0.392157, 1, 0.470588)
                }):Play()
                TweenService:Create(State.Ref.AntiSwitch, TweenInfo.new(0.2), {
                    BackgroundColor3 = Color3.new(0.235294, 0.392157, 0.235294)
                }):Play()
            else
                TweenService:Create(State.Ref.AntiKnob, TweenInfo.new(0.2), {
                    Position = UDim2.new(0, 3, 0.5, -8),
                    BackgroundColor3 = Color3.new(0.784314, 0.784314, 0.784314)
                }):Play()
                TweenService:Create(State.Ref.AntiSwitch, TweenInfo.new(0.2), {
                    BackgroundColor3 = Color3.new(0.156863, 0.156863, 0.156863)
                }):Play()
            end
        end
    end
end)

LocalPlayer.CharacterAdded:Connect(function()
    if State.TpBatEnabled then
        stopTpBat()
        task.wait(0.5)
        if State.AntiDieEnabled then
            startAntiDie()
        end
        startTpBat()
    end
end)

LocalPlayer.CharacterRemoving:Connect(function()
    stopTpBat()
    stopAntiDie()
end)

pcall(buildUI)