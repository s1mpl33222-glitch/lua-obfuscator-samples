repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local HS = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LP = Players.LocalPlayer

-- ============================================================
-- MAIN VARIABLES
-- ============================================================
local Steal = {
    AutoStealEnabled = true,
    StealRadius = 61,
    StealDuration = 1.3,
    StealDelay = 0.25,
    Data = {}
}

local isStealing = false
local isRagdolled = false
local isMedusa = false
local autoGrabSetDelayRadius = 9

local Conns = { autoSteal = nil, statusUpdater = nil }

local progressFill = nil
local progressPct = nil
local progressRadLbl = nil
local mainFrame = nil

-- ============================================================
-- COLORS
-- ============================================================
local C = {
    Panel      = Color3.fromRGB(10, 10, 12),
    PanelStroke= Color3.fromRGB(145, 145, 155),
    Purple     = Color3.fromRGB(205, 205, 212),
    White      = Color3.fromRGB(255, 255, 255),
    BtnDark    = Color3.fromRGB(25, 25, 29),
    BarBg      = Color3.fromRGB(20, 20, 24),
    GreyText   = Color3.fromRGB(205, 205, 212),
    Orange     = Color3.fromRGB(235, 235, 240),
    OffGrey    = Color3.fromRGB(75, 75, 82),
}

-- Small UI click sound. Uses a built-in Roblox asset and fails silently if unavailable.
local function playUiClick()
    pcall(function()
        local soundService = game:GetService("SoundService")
        local sound = Instance.new("Sound")
        sound.Name = "ZeyHubbUiClick"
        sound.SoundId = "rbxassetid://6895079853"
        sound.Volume = 0.35
        sound.PlaybackSpeed = 1.0
        sound.Looped = false
        sound.Parent = soundService
        sound:Play()
        task.delay(1.5, function()
            if sound and sound.Parent then sound:Destroy() end
        end)
    end)
end

-- ============================================================
-- SETTINGS (persistent)
-- ============================================================
local Settings = {
    Radius = 61,
    Mode = 75,
    IsLocked = true,
    Position = nil,
    AutoStealEnabled = true,
    RagdollStealEnabled = false,
    MedusaStealEnabled = false,
    BarSize = 0.7,
}

local function loadSettings()
    local data = nil
    if readfile and isfile and isfile("ZeyHubbAutoStealSettings.json") then
        local content = readfile("ZeyHubbAutoStealSettings.json")
        if content and content ~= "" then
            data = HS:JSONDecode(content)
        end
    elseif _G.ZeyHubbAutoStealSettings then
        data = _G.ZeyHubbAutoStealSettings
    end

    if data then
        Settings.Radius = data.radius or 61
        Settings.Mode = data.mode or 75
        Settings.IsLocked = data.isLocked ~= false
        Settings.Position = data.position
        Settings.AutoStealEnabled = true
        Settings.RagdollStealEnabled = data.ragdollStealEnabled or false
        Settings.MedusaStealEnabled = data.medusaStealEnabled or false
        Settings.BarSize = tonumber(data.barSize) or 0.7
    else
        Settings.Radius = 61
        Settings.Mode = 75
        Settings.IsLocked = true
        Settings.Position = nil
        Settings.AutoStealEnabled = true
        Settings.RagdollStealEnabled = false
        Settings.MedusaStealEnabled = false
        Settings.BarSize = 0.7
    end
end

local function saveSettings()
    local pos = mainFrame and mainFrame.Position or nil
    local data = {
        radius = Settings.Radius,
        mode = Settings.Mode,
        isLocked = Settings.IsLocked,
        position = pos and {
            X = pos.X.Scale,
            XOffset = pos.X.Offset,
            Y = pos.Y.Scale,
            YOffset = pos.Y.Offset
        } or nil,
        autoStealEnabled = Settings.AutoStealEnabled,
        ragdollStealEnabled = Settings.RagdollStealEnabled,
        medusaStealEnabled = Settings.MedusaStealEnabled,
        barSize = Settings.BarSize,
    }
    local json = HS:JSONEncode(data)
    if writefile then
        writefile("ZeyHubbAutoStealSettings.json", json)
    else
        _G.ZeyHubbAutoStealSettings = data
    end
end

loadSettings()
Steal.StealRadius = Settings.Radius
Steal.AutoStealEnabled = true

-- ============================================================
-- GET STOP TIME based on Mode (0 = no pause)
-- ============================================================
local function getStopTimeFromMode()
    local mode = Settings.Mode or 0
    if mode == 0 then return nil end
    return (mode / 100) * Steal.StealDuration
end

-- ============================================================
-- UTILITY FUNCTIONS
-- ============================================================
local function isMyPlotByName(plotName)
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return false end
    local plot = plots:FindFirstChild(plotName)
    if not plot then return false end
    local sign = plot:FindFirstChild("PlotSign")
    if sign then
        local yb = sign:FindFirstChild("YourBase")
        if yb and yb:IsA("BillboardGui") then
            return yb.Enabled == true
        end
    end
    return false
end

local function findNearestPrompt()
    local char = LP.Character
    if not char then return nil, nil end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return nil, nil end
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return nil, nil end

    local nearestPrompt, nearestDist, nearestName = nil, math.huge, nil

    for _, plot in ipairs(plots:GetChildren()) do
        if isMyPlotByName(plot.Name) then continue end
        local pods = plot:FindFirstChild("AnimalPodiums")
        if not pods then continue end
        for _, pod in ipairs(pods:GetChildren()) do
            pcall(function()
                local base = pod:FindFirstChild("Base")
                local spawn = base and base:FindFirstChild("Spawn")
                if spawn then
                    local dist = (spawn.Position - root.Position).Magnitude
                    if dist < nearestDist and dist <= Steal.StealRadius then
                        local att = spawn:FindFirstChild("PromptAttachment")
                        if att then
                            for _, child in ipairs(att:GetChildren()) do
                                if child:IsA("ProximityPrompt") and child.ActionText and child.ActionText:find("Steal") then
                                    nearestPrompt = child
                                    nearestDist = dist
                                    nearestName = pod.Name
                                    break
                                end
                            end
                        end
                    end
                end
            end)
        end
    end

    return nearestPrompt, nearestName
end

-- ============================================================
-- STATUS UPDATER (runs every frame – reliable!)
-- ============================================================
local function updateInterruptFlags()
    -- Ragdoll check
    if not Settings.RagdollStealEnabled then
        isRagdolled = false
    else
        local char = LP.Character
        if char then
            local humanoid = char:FindFirstChild("Humanoid")
            if humanoid then
                local state = humanoid:GetState()
                isRagdolled = (state == Enum.HumanoidStateType.Physics)
            else
                isRagdolled = false
            end
        else
            isRagdolled = false
        end
    end

    -- Medusa check
    if not Settings.MedusaStealEnabled then
        isMedusa = false
    else
        local char = LP.Character
        if char then
            local medusaVal = char:FindFirstChild("Medusa")
            if medusaVal and medusaVal:IsA("BoolValue") then
                isMedusa = medusaVal.Value
            else
                isMedusa = false
            end
        else
            isMedusa = false
        end
    end
end

-- ============================================================
-- SHOULD INTERRUPT?
-- ============================================================
local function shouldInterrupt()
    return (Settings.RagdollStealEnabled and isRagdolled) or
           (Settings.MedusaStealEnabled and isMedusa) or
           not Steal.AutoStealEnabled
end

-- ============================================================
-- START STATUS UPDATER
-- ============================================================
local function startStatusUpdater()
    if Conns.statusUpdater then return end
    Conns.statusUpdater = RunService.Heartbeat:Connect(updateInterruptFlags)
end

startStatusUpdater()

-- ============================================================
-- EXECUTE STEAL (with interrupt checks)
-- ============================================================
local function executeSteal(prompt, podName)
    if isStealing then return end
    if shouldInterrupt() then return end

    if not Steal.Data[prompt] then
        Steal.Data[prompt] = { hold = {}, trigger = {}, ready = true }
        pcall(function()
            if getconnections then
                for _, c in ipairs(getconnections(prompt.PromptButtonHoldBegan)) do
                    if c.Function then table.insert(Steal.Data[prompt].hold, c.Function) end
                end
                for _, c in ipairs(getconnections(prompt.Triggered)) do
                    if c.Function then table.insert(Steal.Data[prompt].trigger, c.Function) end
                end
            end
        end)
    end

    local data = Steal.Data[prompt]
    if not data.ready then return end
    data.ready = false
    isStealing = true

    if progressFill then progressFill.Size = UDim2.new(0, 0, 1, 0) end
    if progressPct then progressPct.Text = "0%" end

    task.spawn(function()
        for _, f in ipairs(data.hold) do task.spawn(f) end

        local duration = Steal.StealDuration
        local promptFired = false
        local stopTime = getStopTimeFromMode()

        if stopTime and stopTime > 0 then
            -- Mode‑based steal
            local startTime = tick()
            local stopProgress = stopTime / duration

            -- Phase 1: fill to stopProgress
            while isStealing and Steal.AutoStealEnabled do
                if shouldInterrupt() then
                    -- Interrupted – reset and exit
                    progressFill.Size = UDim2.new(0, 0, 1, 0)
                    progressPct.Text = "0%"
                    data.ready = true
                    isStealing = false
                    return
                end
                local elapsed = tick() - startTime
                local progress = math.min(elapsed / duration, stopProgress)
                progressFill.Size = UDim2.new(progress, 0, 1, 0)
                progressPct.Text = math.floor(progress * 100) .. "%"
                if elapsed >= stopTime then break end
                if not prompt.Parent or not prompt.Parent.Parent then break end
                local char = LP.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp and (hrp.Position - prompt.Parent.Parent.Position).Magnitude > Steal.StealRadius then break end
                task.wait()
            end

            if not isStealing or not Steal.AutoStealEnabled or shouldInterrupt() then
                progressFill.Size = UDim2.new(0, 0, 1, 0)
                progressPct.Text = "0%"
                data.ready = true
                isStealing = false
                return
            end

            progressFill.Size = UDim2.new(stopProgress, 0, 1, 0)
            progressPct.Text = math.floor(stopProgress * 100) .. "%"

            -- Phase 2: wait for proximity or timeout
            local phase2Start = tick()
            local timeout = 2.99
            local enteredRadius = false
            while isStealing and Steal.AutoStealEnabled do
                if shouldInterrupt() then
                    progressFill.Size = UDim2.new(0, 0, 1, 0)
                    progressPct.Text = "0%"
                    data.ready = true
                    isStealing = false
                    return
                end
                if tick() - phase2Start >= timeout then break end
                if not prompt.Parent or not prompt.Parent.Parent then break end
                local char = LP.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local dist = (hrp.Position - prompt.Parent.Parent.Position).Magnitude
                    if dist <= autoGrabSetDelayRadius then
                        enteredRadius = true
                        break
                    elseif dist > Steal.StealRadius then
                        break
                    end
                end
                task.wait()
            end

            if not enteredRadius or not isStealing or not Steal.AutoStealEnabled or shouldInterrupt() or not prompt.Parent then
                progressFill.Size = UDim2.new(0, 0, 1, 0)
                progressPct.Text = "0%"
                data.ready = true
                isStealing = false
                task.wait()
                local newPrompt, newName = findNearestPrompt()
                if newPrompt then executeSteal(newPrompt, newName) end
                return
            end

            -- Phase 3: fill remainder and steal
            local fillStart = tick()
            local fillDuration = duration - stopTime
            while isStealing and Steal.AutoStealEnabled do
                if shouldInterrupt() then
                    progressFill.Size = UDim2.new(0, 0, 1, 0)
                    progressPct.Text = "0%"
                    data.ready = true
                    isStealing = false
                    return
                end
                local fp = (tick() - fillStart) / fillDuration
                local progress = math.min(stopProgress + fp * (1 - stopProgress), 1)
                progressFill.Size = UDim2.new(progress, 0, 1, 0)
                progressPct.Text = math.floor(progress * 100) .. "%"
                if progress >= 1 then break end
                if not prompt.Parent or not prompt.Parent.Parent then break end
                local char = LP.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp and (hrp.Position - prompt.Parent.Parent.Position).Magnitude > Steal.StealRadius then break end
                task.wait()
            end

            if isStealing and Steal.AutoStealEnabled and not shouldInterrupt() and not promptFired then
                promptFired = true
                pcall(function()
                    for _, f in ipairs(data.trigger) do task.spawn(f) end
                    local remote = ReplicatedStorage:FindFirstChild("StealAnimal")
                    if remote and podName then remote:FireServer(podName) end
                    if prompt then prompt:Fire() end
                end)
            end
        else
            -- Continuous steal (no pause)
            local startTime = tick()
            while isStealing and Steal.AutoStealEnabled do
                if shouldInterrupt() then
                    progressFill.Size = UDim2.new(0, 0, 1, 0)
                    progressPct.Text = "0%"
                    data.ready = true
                    isStealing = false
                    return
                end
                local elapsed = tick() - startTime
                local progress = math.min(elapsed / duration, 1)
                progressFill.Size = UDim2.new(progress, 0, 1, 0)
                progressPct.Text = math.floor(progress * 100) .. "%"
                if progress >= 1 and not promptFired then
                    promptFired = true
                    pcall(function()
                        for _, f in ipairs(data.trigger) do task.spawn(f) end
                        local remote = ReplicatedStorage:FindFirstChild("StealAnimal")
                        if remote and podName then remote:FireServer(podName) end
                        if prompt then prompt:Fire() end
                    end)
                    break
                end
                if not prompt.Parent or not prompt.Parent.Parent then break end
                local char = LP.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp and (hrp.Position - prompt.Parent.Parent.Position).Magnitude > Steal.StealRadius then break end
                task.wait()
            end
        end

        if progressFill then progressFill.Size = UDim2.new(0, 0, 1, 0) end
        if progressPct then progressPct.Text = "0%" end
        data.ready = true
        isStealing = false
    end)
end

-- ============================================================
-- START / STOP AUTO STEAL
-- ============================================================
local function startAutoSteal()
    if Conns.autoSteal then return end
    Conns.autoSteal = RunService.Heartbeat:Connect(function()
        if not Steal.AutoStealEnabled or isStealing or shouldInterrupt() then return end
        local p, n = findNearestPrompt()
        if p then executeSteal(p, n) end
    end)
end

local function stopAutoSteal()
    if Conns.autoSteal then
        Conns.autoSteal:Disconnect()
        Conns.autoSteal = nil
    end
    isStealing = false
    if progressFill then
        TS:Create(progressFill, TweenInfo.new(0.2), { Size = UDim2.new(0, 0, 1, 0) }):Play()
    end
    if progressPct then progressPct.Text = "0%" end
end

-- ============================================================
-- CREATE GUI (4 rows in settings)
-- ============================================================
local function createGUI()
    local CoreGui = game:GetService("CoreGui")
    local oldGui = CoreGui:FindFirstChild("ZeyHubbAutoSteal")
    if oldGui then oldGui:Destroy() end

    local gui = Instance.new("ScreenGui")
    gui.Name = "ZeyHubbAutoSteal"
    gui.ResetOnSpawn = false
    gui.DisplayOrder = 999
    gui.Parent = CoreGui

    -- main panel (320x90)
    local baseWidth = 390
    local baseHeight = 90

    mainFrame = Instance.new("Frame", gui)
    mainFrame.Size = UDim2.new(0, baseWidth, 0, baseHeight)
    if Settings.Position then
        mainFrame.Position = UDim2.new(Settings.Position.X, Settings.Position.XOffset, Settings.Position.Y, Settings.Position.YOffset)
    else
        mainFrame.Position = UDim2.new(0.5, -(baseWidth/2), 0.5, -(baseHeight/2))
    end
    mainFrame.BackgroundColor3 = C.Panel
    mainFrame.BackgroundTransparency = 0
    mainFrame.BorderSizePixel = 0
    mainFrame.ZIndex = 10
    mainFrame.Active = true
    local mainUIScale = Instance.new("UIScale")
    mainUIScale.Name = "AutoStealBarScale"
    mainUIScale.Scale = Settings.BarSize or 1
    mainUIScale.Parent = mainFrame
    mainFrame.Draggable = false
    Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 18)

    local panelGradient = Instance.new("UIGradient", mainFrame)
    panelGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(28, 28, 32)),
        ColorSequenceKeypoint.new(0.48, Color3.fromRGB(10, 10, 12)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(34, 34, 39))
    })
    panelGradient.Rotation = 25

    local border = Instance.new("UIStroke", mainFrame)
    border.Color = C.PanelStroke
    border.Thickness = 2
    border.Transparency = 0.08

    mainFrame:GetPropertyChangedSignal("Position"):Connect(function()
        Settings.Position = {
            X = mainFrame.Position.X.Scale,
            XOffset = mainFrame.Position.X.Offset,
            Y = mainFrame.Position.Y.Scale,
            YOffset = mainFrame.Position.Y.Offset
        }
        saveSettings()
    end)

    -- Title
    local title = Instance.new("TextLabel", mainFrame)
    title.Size = UDim2.new(0, 220, 0, 24)
    title.Position = UDim2.new(0, 14, 0, 8)
    title.BackgroundTransparency = 1
    title.Text = "ZeyHubb.vs Auto Steal"
    title.TextColor3 = C.White
    title.Font = Enum.Font.GothamBlack
    title.RichText = true
    title.Text = '<b>ZeyHubb.vs</b> <font color="#BDBDC5">Auto Steal</font>'
    local titleGradient = Instance.new("UIGradient", title)
    titleGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(145, 145, 155)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(245, 245, 250))
    })
    titleGradient.Rotation = 0
    title.TextSize = 16
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 12

    local isLocked = Settings.IsLocked

    -- Lock button (replaces the removed ON/OFF control)
    local lockBtn = Instance.new("TextButton", mainFrame)
    lockBtn.Size = UDim2.new(0, 50, 0, 42)
    lockBtn.Position = UDim2.new(1, -106, 0, 5)
    lockBtn.BackgroundColor3 = Color3.fromRGB(88, 88, 98)
    lockBtn.BorderSizePixel = 0
    lockBtn.Text = isLocked and "🔒" or "🔓"
    lockBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    lockBtn.Font = Enum.Font.GothamBold
    lockBtn.TextSize = 22
    lockBtn.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    lockBtn.TextStrokeTransparency = 0.15
    lockBtn.ZIndex = 14
    Instance.new("UICorner", lockBtn).CornerRadius = UDim.new(1, 0)
    local lockStroke = Instance.new("UIStroke", lockBtn)
    lockStroke.Color = Color3.fromRGB(255, 255, 255)
    lockStroke.Transparency = 0
    lockStroke.Thickness = 2
    local lockGradient = Instance.new("UIGradient", lockBtn)
    lockGradient.Color = ColorSequence.new(Color3.fromRGB(105, 105, 115), Color3.fromRGB(35, 35, 42))
    lockGradient.Rotation = 90

    -- Gear button
    local gearBtn = Instance.new("TextButton", mainFrame)
    gearBtn.Size = UDim2.new(0, 42, 0, 42)
    gearBtn.Position = UDim2.new(1, -48, 0, 5)
    gearBtn.BackgroundColor3 = Color3.fromRGB(88, 88, 98)
    gearBtn.BorderSizePixel = 0
    gearBtn.Text = "⚙️"
    gearBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    gearBtn.Font = Enum.Font.GothamBold
    gearBtn.TextSize = 22
    gearBtn.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    gearBtn.TextStrokeTransparency = 0.15
    gearBtn.ZIndex = 14
    Instance.new("UICorner", gearBtn).CornerRadius = UDim.new(0, 10)
    local gearStroke = Instance.new("UIStroke", gearBtn)
    gearStroke.Color = Color3.fromRGB(255, 255, 255)
    gearStroke.Transparency = 0
    gearStroke.Thickness = 2
    local gearGradient = Instance.new("UIGradient", gearBtn)
    gearGradient.Color = ColorSequence.new(Color3.fromRGB(105, 105, 115), Color3.fromRGB(35, 35, 42))
    gearGradient.Rotation = 90

    -- ==========================================================
    -- SETTINGS PANEL (4 rows)
    -- ==========================================================
    local settingsFrame = Instance.new("Frame", mainFrame)
    settingsFrame.Size = UDim2.new(1, 0, 0, 232)
    settingsFrame.Position = UDim2.new(0, 0, 1, 6)
    settingsFrame.BackgroundColor3 = C.Panel
    settingsFrame.BackgroundTransparency = 0
    settingsFrame.BorderSizePixel = 0
    settingsFrame.ZIndex = 15
    settingsFrame.Visible = false
    Instance.new("UICorner", settingsFrame).CornerRadius = UDim.new(0, 18)
    local settingsGradient = Instance.new("UIGradient", settingsFrame)
    settingsGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 34)),
        ColorSequenceKeypoint.new(0.55, Color3.fromRGB(12, 12, 14)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(38, 38, 43))
    })
    settingsGradient.Rotation = 25

    local settingsBorder = Instance.new("UIStroke", settingsFrame)
    settingsBorder.Color = C.PanelStroke
    settingsBorder.Thickness = 2
    settingsBorder.Transparency = 0.08

    -- Settings header doubles as a drag handle.
    local settingsHeader = Instance.new("TextLabel", settingsFrame)
    settingsHeader.Size = UDim2.new(1, -20, 0, 20)
    settingsHeader.Position = UDim2.new(0, 10, 0, 4)
    settingsHeader.BackgroundTransparency = 1
    settingsHeader.Text = "✦  ZeyHubb.vs  •  SETTINGS  ✦"
    settingsHeader.TextColor3 = C.White
    settingsHeader.Font = Enum.Font.GothamBlack
    settingsHeader.TextSize = 12
    settingsHeader.ZIndex = 17

    local settingsDragging = false
    local settingsDragInput, settingsDragStart, settingsStartPos
    settingsHeader.Active = true
    settingsHeader.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            settingsDragging = true
            settingsDragStart = input.Position
            settingsStartPos = settingsFrame.Position
            settingsDragInput = input
        end
    end)
    settingsHeader.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            settingsDragInput = input
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if settingsDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - settingsDragStart
            settingsFrame.Position = UDim2.new(
                settingsStartPos.X.Scale, settingsStartPos.X.Offset + delta.X,
                settingsStartPos.Y.Scale, settingsStartPos.Y.Offset + delta.Y
            )
        end
    end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            settingsDragging = false
        end
    end)

    -- Row 1: Radius
    local radiusRow = Instance.new("Frame", settingsFrame)
    radiusRow.Size = UDim2.new(1, -20, 0, 38)
    radiusRow.Position = UDim2.new(0, 10, 0, 25)
    radiusRow.BackgroundTransparency = 1

    local radiusLabel = Instance.new("TextLabel", radiusRow)
    radiusLabel.Size = UDim2.new(0, 60, 1, 0)
    radiusLabel.Position = UDim2.new(0, 0, 0, 0)
    radiusLabel.BackgroundTransparency = 1
    radiusLabel.Text = "Radius:"
    radiusLabel.TextColor3 = C.GreyText
    radiusLabel.Font = Enum.Font.GothamMedium
    radiusLabel.TextSize = 16
    radiusLabel.TextXAlignment = Enum.TextXAlignment.Left
    radiusLabel.ZIndex = 16

    local radiusInput = Instance.new("TextBox", radiusRow)
    radiusInput.Size = UDim2.new(0, 60, 1, -4)
    radiusInput.Position = UDim2.new(0, 70, 0, 2)
    radiusInput.BackgroundColor3 = C.BtnDark
    radiusInput.BorderSizePixel = 0
    radiusInput.Text = tostring(Settings.Radius)
    radiusInput.TextColor3 = C.White
    radiusInput.Font = Enum.Font.GothamBold
    radiusInput.TextSize = 16
    radiusInput.TextXAlignment = Enum.TextXAlignment.Center
    radiusInput.ZIndex = 16
    Instance.new("UICorner", radiusInput).CornerRadius = UDim.new(0, 6)

    radiusInput.Focused:Connect(function()
        radiusInput:CaptureFocus()
        task.wait(0.02)
        radiusInput.Text = tostring(Settings.Radius)
        radiusInput:SelectAll()
    end)

    radiusInput.FocusLost:Connect(function()
        playUiClick()
        local val = tonumber(radiusInput.Text)
        if val then
            val = math.round(val)
            if val < 1 then val = 1 end
            if val > 200 then val = 200 end
            Settings.Radius = val
            Steal.StealRadius = val
            radiusInput.Text = tostring(val)
            saveSettings()
        else
            radiusInput.Text = tostring(Settings.Radius)
        end
    end)

    -- Row 2: Modes (double‑click to deselect)
    local modesRow = Instance.new("Frame", settingsFrame)
    modesRow.Size = UDim2.new(1, -20, 0, 38)
    modesRow.Position = UDim2.new(0, 10, 0, 66)
    modesRow.BackgroundTransparency = 1

    local modesLabel = Instance.new("TextLabel", modesRow)
    modesLabel.Size = UDim2.new(0, 60, 1, 0)
    modesLabel.Position = UDim2.new(0, 0, 0, 0)
    modesLabel.BackgroundTransparency = 1
    modesLabel.Text = "Modes:"
    modesLabel.TextColor3 = C.GreyText
    modesLabel.Font = Enum.Font.GothamMedium
    modesLabel.TextSize = 16
    modesLabel.TextXAlignment = Enum.TextXAlignment.Left
    modesLabel.ZIndex = 16

    local modeBoxes = {}
    local modeValues = {75, 80, 85, 90}
    local selectedMode = Settings.Mode

    local function updateModeSelection()
        for i, box in ipairs(modeBoxes) do
            local val = modeValues[i]
            if val == selectedMode then
                box.BackgroundColor3 = Color3.fromRGB(190, 190, 198)
                box.TextColor3 = C.White
            else
                box.BackgroundColor3 = C.BtnDark
                box.TextColor3 = C.GreyText
            end
        end
    end

    local function setMode(newMode)
        playUiClick()
        selectedMode = newMode
        Settings.Mode = newMode
        updateModeSelection()
        saveSettings()
        print("🔄 Mode set to " .. (newMode == 0 and "OFF" or tostring(newMode) .. "%"))
    end

    for i, val in ipairs(modeValues) do
        local box = Instance.new("TextButton", modesRow)
        box.Size = UDim2.new(0, 38, 1, -4)
        box.Position = UDim2.new(0, 70 + (i-1)*48, 0, 2)
        box.BackgroundColor3 = (val == selectedMode) and Color3.fromRGB(190, 190, 198) or C.BtnDark
        box.BorderSizePixel = 0
        box.Text = tostring(val)
        box.TextColor3 = (val == selectedMode) and C.White or C.GreyText
        box.Font = Enum.Font.GothamBold
        box.TextSize = 14
        box.ZIndex = 16
        Instance.new("UICorner", box).CornerRadius = UDim.new(0, 8)
        local boxStroke = Instance.new("UIStroke", box)
        boxStroke.Color = Color3.fromRGB(125, 125, 135)
        boxStroke.Transparency = 0.45
        boxStroke.Thickness = 1

        local lastClick = 0
        box.MouseButton1Click:Connect(function()
            local now = tick()
            if now - lastClick < 0.3 then
                if selectedMode == val then setMode(0) end
            else
                setMode(val)
            end
            lastClick = now
        end)
        modeBoxes[i] = box
    end

    -- Row 3: Ragdoll Steal
    local ragdollRow = Instance.new("Frame", settingsFrame)
    ragdollRow.Size = UDim2.new(1, -20, 0, 38)
    ragdollRow.Position = UDim2.new(0, 10, 0, 102)
    ragdollRow.BackgroundTransparency = 1

    local ragdollLabel = Instance.new("TextLabel", ragdollRow)
    ragdollLabel.Size = UDim2.new(0, 130, 1, 0)
    ragdollLabel.Position = UDim2.new(0, 0, 0, 0)
    ragdollLabel.BackgroundTransparency = 1
    ragdollLabel.Text = "Ragdoll Steal:"
    ragdollLabel.TextColor3 = C.GreyText
    ragdollLabel.Font = Enum.Font.GothamMedium
    ragdollLabel.TextSize = 16
    ragdollLabel.TextXAlignment = Enum.TextXAlignment.Left
    ragdollLabel.ZIndex = 16

    local ragdollToggle = Instance.new("TextButton", ragdollRow)
    ragdollToggle.Size = UDim2.new(0, 58, 0, 32)
    ragdollToggle.Position = UDim2.new(0, 140, 0, 2)
    ragdollToggle.BackgroundColor3 = Settings.RagdollStealEnabled and C.Purple or C.OffGrey
    ragdollToggle.BorderSizePixel = 0
    ragdollToggle.Text = Settings.RagdollStealEnabled and "ON" or "OFF"
    ragdollToggle.TextColor3 = C.White
    ragdollToggle.Font = Enum.Font.GothamBlack
    ragdollToggle.TextSize = 13
    ragdollToggle.ZIndex = 16
    Instance.new("UICorner", ragdollToggle).CornerRadius = UDim.new(1, 0)

    ragdollToggle.MouseButton1Click:Connect(function()
        playUiClick()
        Settings.RagdollStealEnabled = not Settings.RagdollStealEnabled
        ragdollToggle.Text = Settings.RagdollStealEnabled and "ON" or "OFF"
        TS:Create(ragdollToggle, TweenInfo.new(0.15), { BackgroundColor3 = Settings.RagdollStealEnabled and C.Purple or C.OffGrey }):Play()
        saveSettings()
        -- Immediately force a flag update
        updateInterruptFlags()
        print("🔄 Ragdoll Steal: " .. (Settings.RagdollStealEnabled and "ON" or "OFF"))
    end)

    -- Row 4: Medusa Steal
    local medusaRow = Instance.new("Frame", settingsFrame)
    medusaRow.Size = UDim2.new(1, -20, 0, 38)
    medusaRow.Position = UDim2.new(0, 10, 0, 140)
    medusaRow.BackgroundTransparency = 1

    local medusaLabel = Instance.new("TextLabel", medusaRow)
    medusaLabel.Size = UDim2.new(0, 130, 1, 0)
    medusaLabel.Position = UDim2.new(0, 0, 0, 0)
    medusaLabel.BackgroundTransparency = 1
    medusaLabel.Text = "Medusa Steal:"
    medusaLabel.TextColor3 = C.GreyText
    medusaLabel.Font = Enum.Font.GothamMedium
    medusaLabel.TextSize = 16
    medusaLabel.TextXAlignment = Enum.TextXAlignment.Left
    medusaLabel.ZIndex = 16

    local medusaToggle = Instance.new("TextButton", medusaRow)
    medusaToggle.Size = UDim2.new(0, 58, 0, 32)
    medusaToggle.Position = UDim2.new(0, 140, 0, 2)
    medusaToggle.BackgroundColor3 = Settings.MedusaStealEnabled and C.Purple or C.OffGrey
    medusaToggle.BorderSizePixel = 0
    medusaToggle.Text = Settings.MedusaStealEnabled and "ON" or "OFF"
    medusaToggle.TextColor3 = C.White
    medusaToggle.Font = Enum.Font.GothamBlack
    medusaToggle.TextSize = 13
    medusaToggle.ZIndex = 16
    Instance.new("UICorner", medusaToggle).CornerRadius = UDim.new(1, 0)

    medusaToggle.MouseButton1Click:Connect(function()
        playUiClick()
        Settings.MedusaStealEnabled = not Settings.MedusaStealEnabled
        medusaToggle.Text = Settings.MedusaStealEnabled and "ON" or "OFF"
        TS:Create(medusaToggle, TweenInfo.new(0.15), { BackgroundColor3 = Settings.MedusaStealEnabled and C.Purple or C.OffGrey }):Play()
        saveSettings()
        updateInterruptFlags()
        print("🔄 Medusa Steal: " .. (Settings.MedusaStealEnabled and "ON" or "OFF"))
    end)

    -- Row 5: Main Auto Steal UI size (does not resize the settings panel)
    local sizeRow = Instance.new("Frame", settingsFrame)
    sizeRow.Size = UDim2.new(1, -20, 0, 30)
    sizeRow.Position = UDim2.new(0, 10, 0, 178)
    sizeRow.BackgroundTransparency = 1

    local sizeLabel = Instance.new("TextLabel", sizeRow)
    sizeLabel.Size = UDim2.new(0, 150, 1, 0)
    sizeLabel.Position = UDim2.new(0, 0, 0, 0)
    sizeLabel.BackgroundTransparency = 1
    sizeLabel.Text = "Auto Steal UI Size:"
    sizeLabel.TextColor3 = C.GreyText
    sizeLabel.Font = Enum.Font.GothamMedium
    sizeLabel.TextSize = 13
    sizeLabel.TextXAlignment = Enum.TextXAlignment.Left
    sizeLabel.ZIndex = 16

    local sizeInput = Instance.new("TextBox", sizeRow)
    sizeInput.Size = UDim2.new(0, 68, 1, -2)
    sizeInput.Position = UDim2.new(0, 158, 0, 1)
    sizeInput.BackgroundColor3 = C.BtnDark
    sizeInput.BorderSizePixel = 0
    sizeInput.Text = tostring(Settings.BarSize or 1)
    sizeInput.PlaceholderText = "1.0"
    sizeInput.TextColor3 = C.White
    sizeInput.Font = Enum.Font.GothamBold
    sizeInput.TextSize = 14
    sizeInput.TextXAlignment = Enum.TextXAlignment.Center
    sizeInput.ZIndex = 16
    Instance.new("UICorner", sizeInput).CornerRadius = UDim.new(0, 7)
    local sizeStroke = Instance.new("UIStroke", sizeInput)
    sizeStroke.Color = Color3.fromRGB(125, 125, 135)
    sizeStroke.Transparency = 0.4
    sizeStroke.Thickness = 1

    sizeInput.FocusLost:Connect(function()
        playUiClick()
        local value = tonumber(sizeInput.Text)
        if value then
            value = math.clamp(value, 0.65, 1.5)
            value = math.floor(value * 100 + 0.5) / 100
            Settings.BarSize = value
            mainUIScale.Scale = value
            sizeInput.Text = tostring(value)
            saveSettings()
        else
            sizeInput.Text = tostring(Settings.BarSize or 1)
        end
    end)

    -- ==========================================================
    -- Progress bar & labels
    -- ==========================================================
    -- Radius label removed from the main progress bar UI.
    progressRadLbl = nil

    local barBg = Instance.new("Frame", mainFrame)
    barBg.Size = UDim2.new(1, -28, 0, 18)
    barBg.Position = UDim2.new(0, 14, 1, -24)
    barBg.BackgroundColor3 = C.BarBg
    barBg.BorderSizePixel = 0
    barBg.ZIndex = 11
    Instance.new("UICorner", barBg).CornerRadius = UDim.new(1, 0)

    progressFill = Instance.new("Frame", barBg)
    progressFill.Size = UDim2.new(0, 0, 1, 0)
    progressFill.BackgroundColor3 = C.White
    progressFill.BorderSizePixel = 0
    progressFill.ZIndex = 12
    Instance.new("UICorner", progressFill).CornerRadius = UDim.new(1, 0)

    local fillGradient = Instance.new("UIGradient", progressFill)
    fillGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(150, 150, 155)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(240, 240, 240)),
    })

    progressPct = Instance.new("TextLabel", mainFrame)
    progressPct.Size = UDim2.new(0, 50, 0, 16)
    progressPct.Position = UDim2.new(0, 14, 0, 46)
    progressPct.BackgroundTransparency = 1
    progressPct.Text = "0%"
    progressPct.TextColor3 = C.White
    progressPct.Font = Enum.Font.GothamBold
    progressPct.TextSize = 12
    progressPct.TextXAlignment = Enum.TextXAlignment.Left
    progressPct.ZIndex = 12
    progressPct.Visible = true

    -- ==========================================================
    -- INTERACTIONS
    -- ==========================================================
    local function updateLock()
        if isLocked then
            lockBtn.Text = "🔒"
            lockBtn.TextSize = 22
            mainFrame.Draggable = false
        else
            lockBtn.Text = "🔓"
            lockBtn.TextSize = 22
            mainFrame.Draggable = true
        end
        lockBtn.TextColor3 = C.Orange
        Settings.IsLocked = isLocked
        saveSettings()
    end

    lockBtn.MouseButton1Click:Connect(function()
        playUiClick()
        isLocked = not isLocked
        updateLock()
    end)

    local settingsVisible = false
    local settingsTween
    local settingsBasePosition = UDim2.new(0, 0, 1, 6)
    gearBtn.MouseButton1Click:Connect(function()
        playUiClick()
        settingsVisible = not settingsVisible
        if settingsTween then settingsTween:Cancel() end
        if settingsVisible then
            settingsFrame.Visible = true
            settingsFrame.Position = UDim2.new(0, 0, 1, -4)
            settingsFrame.BackgroundTransparency = 1
            settingsTween = TS:Create(settingsFrame, TweenInfo.new(0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                Position = settingsBasePosition,
                BackgroundTransparency = 0
            })
            settingsTween:Play()
        else
            settingsTween = TS:Create(settingsFrame, TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                Position = UDim2.new(0, 0, 1, -4),
                BackgroundTransparency = 1
            })
            settingsTween:Play()
            settingsTween.Completed:Once(function()
                if not settingsVisible then
                    settingsFrame.Visible = false
                    settingsFrame.Position = settingsBasePosition
                    settingsFrame.BackgroundTransparency = 0
                end
            end)
        end
    end)

    -- Initial states
    updateLock()
    -- Auto Steal starts enabled automatically; no ON/OFF button is shown.
    Steal.AutoStealEnabled = true
    Settings.AutoStealEnabled = true
    startAutoSteal()
    saveSettings()
    updateModeSelection()
end

-- ============================================================
-- START
-- ============================================================
createGUI()

-- Auto-save the current configuration periodically and when the client exits.
task.spawn(function()
    while task.wait(15) do
        pcall(saveSettings)
    end
end)

game:BindToClose(function()
    pcall(saveSettings)
end)

print("🚀 ZEYHUBB.VS AUTO STEAL LOADED")
print("📊 Settings:")
print("   Radius: " .. Settings.Radius)
print("   Mode: " .. (Settings.Mode == 0 and "OFF" or Settings.Mode .. "%"))
print("   Locked: " .. tostring(Settings.IsLocked))
print("   AutoSteal: " .. tostring(Settings.AutoStealEnabled))
print("   Ragdoll Steal: " .. tostring(Settings.RagdollStealEnabled))
print("   Medusa Steal: " .. tostring(Settings.MedusaStealEnabled))
print("💡 Auto Steal starts automatically")
print("⚙️ Click gear to open settings panel")
print("🔁 Double‑click a mode to turn it off (continuous steal)")
print("💥 Ragdoll & Medusa now reliably pause auto‑steal")