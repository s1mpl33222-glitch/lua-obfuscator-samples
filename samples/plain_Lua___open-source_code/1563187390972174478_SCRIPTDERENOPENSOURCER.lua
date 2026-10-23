local PASSWORD       = "RENHUB"
local TARGET_SPEED   = 1e18
local BEST_TREADMILL = Vector3.new(-340.24, 23.54, 145.57)
local BATCH_WIN      = 3000
local BATCH_SPD      = 100
local NOOP           = 999999999999999

local Players     = game:GetService("Players")
local RS          = game:GetService("ReplicatedStorage")
local RUS         = game:GetService("RunService")
local UIS         = game:GetService("UserInputService")
local Tween       = game:GetService("TweenService")
local TeleportSvc = game:GetService("TeleportService")
local LP          = Players.LocalPlayer
local PG          = LP:WaitForChild("PlayerGui")

local WinRE, VelRE, EquipRE
local function refetch()
    WinRE   = RS:FindFirstChild("WinEvent", true)
    VelRE   = RS:FindFirstChild("CambiarVelocidadEvent", true)
    EquipRE = RS:FindFirstChild("EquiparCaminadoraEvent", true)
end
refetch()

local Verified, AutoWin, AutoSpeed = false, false, false
local FiresWin, FiresSpd = 0, 0
local winGen, speedGen = 0, 0
local winConn, speedThread = nil, nil
local currentGui = nil
local speedFireValue = TARGET_SPEED
local uiConnections = {}

local function getStat(n)
    local ls = LP:FindFirstChild("leaderstats")
    if not ls then return 0 end
    local v = ls:FindFirstChild(n)
    return v and v.Value or 0
end

local function teleportToTreadmill()
    local char = LP.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    hrp.CFrame = CFrame.new(BEST_TREADMILL + Vector3.new(0, 4, 0))
    hrp.Velocity = Vector3.new(0, -10, 0)
end

local function hardStopAll()
    AutoWin = false
    AutoSpeed = false
    winGen = winGen + 1
    speedGen = speedGen + 1

    if winConn then
        winConn:Disconnect()
        winConn = nil
    end

    if speedThread then
        pcall(task.cancel, speedThread)
        speedThread = nil
    end

    for _, conn in ipairs(uiConnections) do
        pcall(function() conn:Disconnect() end)
    end
    uiConnections = {}
end

local function startWin()
    if winConn then return end
    AutoWin = true
    winGen = winGen + 1
    local myGen = winGen
    
    winConn = RUS.Heartbeat:Connect(function()
        if not AutoWin or winGen ~= myGen then return end
        if not WinRE then refetch() end
        if not WinRE then return end
        
        for i = 1, BATCH_WIN do
            if not AutoWin or winGen ~= myGen then break end
            pcall(WinRE.FireServer, WinRE, NOOP)
        end
        
        if AutoWin and winGen == myGen then
            FiresWin = FiresWin + BATCH_WIN
        end
    end)
end

local function startSpeed()
    if speedThread then return end
    AutoSpeed = true
    speedGen = speedGen + 1
    local myGen = speedGen

    speedThread = task.spawn(function()
        teleportToTreadmill()
        task.wait(1)
        if speedGen ~= myGen then return end

        local frame = 0
        while speedGen == myGen and AutoSpeed do
            task.wait()
            frame = frame + 1

            if speedGen ~= myGen then break end
            
            if not VelRE or not EquipRE then refetch() end
            if frame % 30 == 0 then teleportToTreadmill() end

            if VelRE then
                for i = 1, BATCH_SPD do
                    if speedGen ~= myGen or not AutoSpeed then break end
                    pcall(VelRE.FireServer, VelRE, speedFireValue)
                end
                if speedGen == myGen and AutoSpeed then
                    FiresSpd = FiresSpd + BATCH_SPD
                end
            end

            if frame % 60 == 0 and EquipRE then
                pcall(EquipRE.FireServer, EquipRE, "Personalizada")
            end
        end
    end)
end

local function buildUI()
    if currentGui then currentGui:Destroy() end

    local C = {
        bg = Color3.fromRGB(15, 15, 18),
        surface = Color3.fromRGB(24, 24, 30),
        surfaceHover = Color3.fromRGB(32, 32, 40),
        accent = Color3.fromRGB(130, 80, 255),
        text = Color3.fromRGB(255, 255, 255),
        subtext = Color3.fromRGB(150, 150, 160),
        green = Color3.fromRGB(40, 200, 100),
        red = Color3.fromRGB(200, 50, 70),
    }

    local gui = Instance.new("ScreenGui")
    gui.Name = "RENHUB_PREMIUM"
    gui.ResetOnSpawn = false
    gui.DisplayOrder = 2147483647
    gui.IgnoreGuiInset = true
    gui.Parent = PG
    currentGui = gui

    local main = Instance.new("Frame")
    main.Size = UDim2.new(0, 340, 0, 220)
    main.Position = UDim2.new(0.5, -170, 0.5, -110)
    main.BackgroundColor3 = C.bg
    main.BorderSizePixel = 0
    main.Parent = gui
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)
    
    local mainStroke = Instance.new("UIStroke")
    mainStroke.Color = C.accent
    mainStroke.Thickness = 1.5
    mainStroke.Transparency = 0.5
    mainStroke.Parent = main

    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 45)
    titleBar.BackgroundColor3 = C.surface
    titleBar.BorderSizePixel = 0
    titleBar.Parent = main
    Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 12)
    
    local titleFix = Instance.new("Frame")
    titleFix.Size = UDim2.new(1, 0, 0, 15)
    titleFix.Position = UDim2.new(0, 0, 1, -15)
    titleFix.BackgroundColor3 = C.surface
    titleFix.BorderSizePixel = 0
    titleFix.Parent = titleBar

    local titleText = Instance.new("TextLabel")
    titleText.Size = UDim2.new(1, -20, 1, 0)
    titleText.Position = UDim2.new(0, 20, 0, 0)
    titleText.BackgroundTransparency = 1
    titleText.TextColor3 = C.text
    titleText.Font = Enum.Font.GothamBold
    titleText.TextSize = 16
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.Text = "RENHUB <font color='#8250FF'>PREMIUM</font>"
    titleText.RichText = true
    titleText.Parent = titleBar

    local body = Instance.new("Frame")
    body.Size = UDim2.new(1, 0, 1, -45)
    body.Position = UDim2.new(0, 0, 0, 45)
    body.BackgroundTransparency = 1
    body.Parent = main

    local loginFrame = Instance.new("Frame")
    loginFrame.Size = UDim2.new(1, 0, 1, 0)
    loginFrame.BackgroundTransparency = 1
    loginFrame.Parent = body

    local passBox = Instance.new("TextBox")
    passBox.Size = UDim2.new(1, -40, 0, 45)
    passBox.Position = UDim2.new(0, 20, 0, 30)
    passBox.BackgroundColor3 = C.surface
    passBox.TextColor3 = C.text
    passBox.PlaceholderColor3 = C.subtext
    passBox.Font = Enum.Font.GothamMedium
    passBox.TextSize = 14
    passBox.PlaceholderText = "Ingresa la contraseña..."
    passBox.Text = ""
    passBox.ClearTextOnFocus = false
    passBox.BorderSizePixel = 0
    passBox.Parent = loginFrame
    Instance.new("UICorner", passBox).CornerRadius = UDim.new(0, 8)
    
    local pStroke = Instance.new("UIStroke")
    pStroke.Color = C.accent
    pStroke.Thickness = 1
    pStroke.Transparency = 0.5
    pStroke.Parent = passBox
    passBox.Focused:Connect(function() Tween:Create(pStroke, TweenInfo.new(0.2), {Transparency = 0}):Play() end)
    passBox.FocusLost:Connect(function() Tween:Create(pStroke, TweenInfo.new(0.2), {Transparency = 0.5}):Play() end)

    local loginBtn = Instance.new("TextButton")
    loginBtn.Size = UDim2.new(1, -40, 0, 40)
    loginBtn.Position = UDim2.new(0, 20, 0, 90)
    loginBtn.BackgroundColor3 = C.accent
    loginBtn.TextColor3 = C.text
    loginBtn.Font = Enum.Font.GothamBold
    loginBtn.TextSize = 14
    loginBtn.Text = "VERIFICAR"
    loginBtn.BorderSizePixel = 0
    loginBtn.AutoButtonColor = false
    loginBtn.Parent = loginFrame
    Instance.new("UICorner", loginBtn).CornerRadius = UDim.new(0, 8)
    
    local errorLbl = Instance.new("TextLabel")
    errorLbl.Size = UDim2.new(1, -40, 0, 20)
    errorLbl.Position = UDim2.new(0, 20, 0, 140)
    errorLbl.BackgroundTransparency = 1
    errorLbl.TextColor3 = C.red
    errorLbl.Font = Enum.Font.Gotham
    errorLbl.TextSize = 12
    errorLbl.Text = ""
    errorLbl.Parent = loginFrame

    local toolsFrame = Instance.new("Frame")
    toolsFrame.Size = UDim2.new(1, 0, 1, 0)
    toolsFrame.BackgroundTransparency = 1
    toolsFrame.Visible = false
    toolsFrame.Parent = body

    local function createToggle(text, yPos, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -40, 0, 45)
        btn.Position = UDim2.new(0, 20, 0, yPos)
        btn.BackgroundColor3 = C.surface
        btn.TextColor3 = C.text
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 14
        btn.Text = text .. "  [OFF]"
        btn.BorderSizePixel = 0
        btn.AutoButtonColor = false
        btn.Parent = toolsFrame
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

        local stroke = Instance.new("UIStroke")
        stroke.Color = C.red
        stroke.Thickness = 1.5
        stroke.Transparency = 0.4
        stroke.Parent = btn

        local isOn = false

        btn.MouseEnter:Connect(function()
            Tween:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = C.surfaceHover}):Play()
        end)
        btn.MouseLeave:Connect(function()
            Tween:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = C.surface}):Play()
        end)

        btn.MouseButton1Click:Connect(function()
            isOn = not isOn
            if isOn then
                btn.Text = text .. "  [ON]"
                stroke.Color = C.green
                Tween:Create(stroke, TweenInfo.new(0.2), {Transparency = 0}):Play()
            else
                btn.Text = text .. "  [OFF]"
                stroke.Color = C.red
                Tween:Create(stroke, TweenInfo.new(0.2), {Transparency = 0.4}):Play()
            end
            callback(isOn)
        end)
    end

    createToggle("AUTO FARM WINS", 15, function(state)
        if state then startWin() else hardStopAll() end
    end)

    createToggle("AUTO FARM SPEED", 70, function(state)
        if state then startSpeed() else hardStopAll() end
    end)

    local rejoinBtn = Instance.new("TextButton")
    rejoinBtn.Size = UDim2.new(1, -40, 0, 40)
    rejoinBtn.Position = UDim2.new(0, 20, 0, 130)
    rejoinBtn.BackgroundColor3 = C.surface
    rejoinBtn.TextColor3 = C.subtext
    rejoinBtn.Font = Enum.Font.GothamBold
    rejoinBtn.TextSize = 13
    rejoinBtn.Text = "REJOIN SERVER"
    rejoinBtn.BorderSizePixel = 0
    rejoinBtn.AutoButtonColor = false
    rejoinBtn.Parent = toolsFrame
    Instance.new("UICorner", rejoinBtn).CornerRadius = UDim.new(0, 8)

    local rStroke = Instance.new("UIStroke")
    rStroke.Color = C.red
    rStroke.Thickness = 1
    rStroke.Transparency = 0.6
    rStroke.Parent = rejoinBtn

    rejoinBtn.MouseEnter:Connect(function()
        Tween:Create(rejoinBtn, TweenInfo.new(0.15), {BackgroundColor3 = C.red, TextColor3 = C.text}):Play()
    end)
    rejoinBtn.MouseLeave:Connect(function()
        Tween:Create(rejoinBtn, TweenInfo.new(0.15), {BackgroundColor3 = C.surface, TextColor3 = C.subtext}):Play()
    end)

    rejoinBtn.MouseButton1Click:Connect(function()
        hardStopAll()
        rejoinBtn.Text = "REJOINING..."
        rejoinBtn.TextColor3 = C.text
        
        local success, err = pcall(function()
            TeleportSvc:Teleport(game.PlaceId, LP)
        end)
        
        if not success then
            rejoinBtn.Text = "ERROR AL REJOIN"
            task.wait(1)
            LP:Kick("RENHUB: Reinicia el juego manualmente (Rejoin falló)")
        end
    end)

    local function attemptLogin()
        if passBox.Text == PASSWORD then
            Verified = true
            errorLbl.Text = ""
            loginFrame.Visible = false
            toolsFrame.Visible = true
            toolsFrame.Position = UDim2.new(0, 0, 0, 20)
            Tween:Create(toolsFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0, 0)}):Play()
        else
            errorLbl.Text = "❌ Contraseña incorrecta"
            passBox.Text = ""
            local orig = main.Position
            for i = 1, 6 do
                main.Position = UDim2.new(orig.X.Scale, orig.X.Offset + (i%2==0 and 6 or -6), orig.Y.Scale, orig.Y.Offset)
                task.wait(0.03)
            end
            main.Position = orig
        end
    end

    loginBtn.MouseButton1Click:Connect(attemptLogin)
    passBox.FocusLost:Connect(function(enterPressed) 
        if enterPressed then attemptLogin() end 
    end)

    local dragging, dStart, dPos = false, nil, nil
    table.insert(uiConnections, titleBar.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dStart = i.Position
            dPos = main.Position
        end
    end))
    table.insert(uiConnections, UIS.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local d = i.Position - dStart
            main.Position = UDim2.new(dPos.X.Scale, dPos.X.Offset + d.X, dPos.Y.Scale, dPos.Y.Offset + d.Y)
        end
    end))
    table.insert(uiConnections, UIS.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end))
end

buildUI()