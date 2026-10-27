-- Guard: Cegah double execute / double UI
if getgenv().__NewFish5_Loaded then
    warn("[NewFish5] Already loaded! Skipping re-execution.")
    return
end
getgenv().__NewFish5_Loaded = true

local BaseURL = "https://key.shieldteam.asia/raw/Fisch/"
local FallbackBaseURL = "https://raw.githubusercontent.com/KAN-FISCH/Fisch/refs/heads/main/"

local function httpGetWithTimeout(url, timeout)
    local result = nil
    local success = false
    local completed = false
    
    local thread = coroutine.running()
    
    task.spawn(function()
        local ok, res = pcall(function()
            return game:HttpGet(url)
        end)
        if not completed then
            completed = true
            success = ok
            result = res
            task.spawn(thread)
        end
    end)
    
    task.delay(timeout or 5, function()
        if not completed then
            completed = true
            success = false
            result = "Timeout"
            task.spawn(thread)
        end
    end)
    
    coroutine.yield()
    return success, result
end
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local folderName = "Shield_Core"

-- FilesToInstall removed as we load directly from URL.


local function CreatePremiumLoadingGUI()
    local CoreGui = game:GetService("CoreGui")
    local loadingGui = Instance.new("ScreenGui")
    loadingGui.Name = "ShieldPremiumLoader"
    loadingGui.ResetOnSpawn = false
    loadingGui.IgnoreGuiInset = true

    local success, _ = pcall(function()
        loadingGui.Parent = CoreGui
    end)
    if not success then
        loadingGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    end

    -- Background Dim
    local bgDim = Instance.new("Frame")
    bgDim.Size = UDim2.new(1, 0, 1, 0)
    bgDim.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    bgDim.BackgroundTransparency = 0.6
    bgDim.BorderSizePixel = 0
    bgDim.Parent = loadingGui

    -- Main Container
    local frame = Instance.new("CanvasGroup")
    frame.Size = UDim2.new(0, 360, 0, 180)
    frame.Position = UDim2.new(0.5, -180, 0.5, -90)
    frame.BackgroundColor3 = Color3.fromRGB(15, 14, 24)
    frame.BorderSizePixel = 0
    frame.ClipsDescendants = false
    frame.Parent = loadingGui

    local isMobile = game:GetService("UserInputService").TouchEnabled and not game:GetService("UserInputService").MouseEnabled
    if isMobile then
        local uiScale = Instance.new("UIScale")
        uiScale.Scale = 0.75
        uiScale.Parent = frame
    end

    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, 16)
    uiCorner.Parent = frame

    local uiStroke = Instance.new("UIStroke")
    uiStroke.Color = Color3.fromRGB(80, 70, 120)
    uiStroke.Thickness = 1
    uiStroke.Transparency = 0.3
    uiStroke.Parent = frame

    -- Drop Shadow
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    shadow.Position = UDim2.new(0.5, 0, 0.5, 8)
    shadow.Size = UDim2.new(1, 50, 1, 50)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://13169223121"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.3
    shadow.ZIndex = -1
    shadow.Parent = frame

    -- Top Shield Logo Area
    local logoContainer = Instance.new("Frame")
    logoContainer.Size = UDim2.new(1, 0, 0, 40)
    logoContainer.Position = UDim2.new(0, 0, 0, 10)
    logoContainer.BackgroundTransparency = 1
    logoContainer.Parent = frame

    -- Left Line
    local lineLeft = Instance.new("Frame")
    lineLeft.Size = UDim2.new(0, 45, 0, 2)
    lineLeft.Position = UDim2.new(0.5, -75, 0.5, 0)
    lineLeft.AnchorPoint = Vector2.new(1, 0.5)
    lineLeft.BackgroundColor3 = Color3.fromRGB(80, 60, 140)
    lineLeft.BorderSizePixel = 0
    lineLeft.Parent = logoContainer

    -- Right Line
    local lineRight = Instance.new("Frame")
    lineRight.Size = UDim2.new(0, 45, 0, 2)
    lineRight.Position = UDim2.new(0.5, 75, 0.5, 0)
    lineRight.AnchorPoint = Vector2.new(0, 0.5)
    lineRight.BackgroundColor3 = Color3.fromRGB(80, 60, 140)
    lineRight.BorderSizePixel = 0
    lineRight.Parent = logoContainer

    -- Shield Icon
    local shieldIcon = Instance.new("ImageLabel")
    shieldIcon.Size = UDim2.new(0, 32, 0, 32)
    shieldIcon.Position = UDim2.new(0.5, -16, 0.5, -16)
    shieldIcon.BackgroundTransparency = 1
    shieldIcon.Image = "http://www.roblox.com/asset/?id=100574044521884" -- Placeholder shield
    shieldIcon.ImageColor3 = Color3.fromRGB(150, 100, 255)
    shieldIcon.Parent = logoContainer
    
    local starIcon = Instance.new("ImageLabel")
    starIcon.Size = UDim2.new(0, 12, 0, 12)
    starIcon.Position = UDim2.new(0.5, -6, 0.5, -6)
    starIcon.BackgroundTransparency = 1
    starIcon.Image = "http://www.roblox.com/asset/?id=6031068433" -- Star
    starIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
    starIcon.Parent = shieldIcon

    -- Title
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 24)
    title.Position = UDim2.new(0, 0, 0, 45)
    title.BackgroundTransparency = 1
    title.Text = "SHIELD TEAM"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Font = Enum.Font.GothamBlack
    title.TextSize = 22
    title.Parent = frame

    -- Subtitle
    local subtitle = Instance.new("TextLabel")
    subtitle.Size = UDim2.new(1, 0, 0, 20)
    subtitle.Position = UDim2.new(0, 0, 0, 70)
    subtitle.BackgroundTransparency = 1
    subtitle.Text = "Installing Modules..."
    subtitle.TextColor3 = Color3.fromRGB(160, 160, 180)
    subtitle.Font = Enum.Font.GothamMedium
    subtitle.TextSize = 12
    subtitle.Parent = frame

    -- Progress Bar Track
    local progressTrack = Instance.new("Frame")
    progressTrack.Size = UDim2.new(0, 320, 0, 24)
    progressTrack.Position = UDim2.new(0.5, -160, 0, 100)
    progressTrack.BackgroundColor3 = Color3.fromRGB(10, 9, 16)
    progressTrack.BorderSizePixel = 0
    progressTrack.Parent = frame

    local trCorner = Instance.new("UICorner")
    trCorner.CornerRadius = UDim.new(0, 12)
    trCorner.Parent = progressTrack
    
    local trStroke = Instance.new("UIStroke")
    trStroke.Color = Color3.fromRGB(40, 35, 60)
    trStroke.Thickness = 1
    trStroke.Parent = progressTrack

    -- Progress Bar Fill
    local progressFill = Instance.new("Frame")
    progressFill.Size = UDim2.new(0, 0, 1, -6)
    progressFill.Position = UDim2.new(0, 3, 0, 3)
    progressFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    progressFill.BorderSizePixel = 0
    progressFill.Parent = progressTrack

    local pfCorner = Instance.new("UICorner")
    pfCorner.CornerRadius = UDim.new(0, 10)
    pfCorner.Parent = progressFill
    
    local pfGrad = Instance.new("UIGradient")
    pfGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(110, 40, 220)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 70, 255))
    })
    pfGrad.Parent = progressFill

    -- Percent Box
    local pctBox = Instance.new("Frame")
    pctBox.Size = UDim2.new(0, 40, 0, 18)
    pctBox.AnchorPoint = Vector2.new(1, 0.5)
    pctBox.Position = UDim2.new(1, -4, 0.5, 0)
    pctBox.BackgroundColor3 = Color3.fromRGB(20, 15, 35)
    pctBox.BackgroundTransparency = 0.5
    pctBox.BorderSizePixel = 0
    pctBox.Parent = progressTrack

    local pctCorner = Instance.new("UICorner")
    pctCorner.CornerRadius = UDim.new(0, 12)
    pctCorner.Parent = pctBox

    local pctStroke = Instance.new("UIStroke")
    pctStroke.Color = Color3.fromRGB(120, 80, 200)
    pctStroke.Thickness = 1
    pctStroke.Transparency = 0.2
    pctStroke.Parent = pctBox

    local pctLabel = Instance.new("TextLabel")
    pctLabel.Size = UDim2.new(1, 0, 1, 0)
    pctLabel.BackgroundTransparency = 1
    pctLabel.Text = "0%"
    pctLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    pctLabel.Font = Enum.Font.GothamBold
    pctLabel.TextSize = 10
    pctLabel.Parent = pctBox

    -- Status Text (Bottom)
    local status = Instance.new("TextLabel")
    status.Size = UDim2.new(1, 0, 0, 20)
    status.Position = UDim2.new(0, 0, 0, 135)
    status.BackgroundTransparency = 1
    status.RichText = true
    status.Text = "⬇ <font color='#ffffff'>Downloading: </font><font color='#b070ff'>Initializing [0%]</font>"
    status.TextColor3 = Color3.fromRGB(200, 200, 200)
    status.Font = Enum.Font.GothamMedium
    status.TextSize = 11
    status.Parent = frame

    -- Intro Animation
    frame.Position = UDim2.new(0.5, -180, 0.5, -90)
    frame.GroupTransparency = 1
    bgDim.BackgroundTransparency = 1
    
    TweenService:Create(bgDim, TweenInfo.new(0.5), {BackgroundTransparency = 0.6}):Play()
    TweenService:Create(frame, TweenInfo.new(0.6, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, -180, 0.5, -90),
        GroupTransparency = 0
    }):Play()

    return loadingGui, status, progressFill, bgDim, frame, pctLabel
end

local function LoadMainScript()
    local gui, statusText, progressFill, bgDim, frame, pctLabel = CreatePremiumLoadingGUI()
    
    statusText.Text = "⬇ <font color='#ffffff'>Downloading Main Script...</font>"
    if pctLabel then pctLabel.Text = "30%" end
    TweenService:Create(progressFill, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = UDim2.new(0.3, 0, 1, -6)
    }):Play()

    local ok, code = httpGetWithTimeout(BaseURL .. "Main_RS.lua", 8)
    if not ok or not code or #code < 100 then
        statusText.Text = "⬇ <font color='#ffffff'>Trying Fallback Mirror...</font>"
        ok, code = httpGetWithTimeout(FallbackBaseURL .. "Main_RS.lua", 8)
    end

    if not ok or not code or #code < 100 then
        statusText.Text = "❌ <font color='#ff5555'>Download Failed!</font>"
        warn("[NewFish5] Failed to download Main_RS.lua!")
        task.wait(2)
        if gui then gui:Destroy() end
        getgenv().__NewFish5_Loaded = nil
        return
    end

    statusText.Text = "⬇ <font color='#ffffff'>Compiling Script... [100%]</font>"
    if pctLabel then pctLabel.Text = "100%" end
    TweenService:Create(progressFill, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = UDim2.new(0.85, 0, 1, -6)
    }):Play()

    local fn, err = loadstring(code)
    if not fn then
        statusText.Text = "❌ <font color='#ff5555'>Compile Error!</font>"
        warn("[NewFish5] Loadstring compile error:", err)
        task.wait(2)
        if gui then gui:Destroy() end
        getgenv().__NewFish5_Loaded = nil
        return
    end

    statusText.Text = "Booting ShieldTeam..."
    statusText.TextColor3 = Color3.fromRGB(100, 255, 100)
    task.wait(0.3)
    
    TweenService:Create(bgDim, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
    local outroTween = TweenService:Create(frame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Position = UDim2.new(0.5, -190, 0.5, -60),
        GroupTransparency = 1
    })
    outroTween:Play()
    outroTween.Completed:Wait()
    
    gui:Destroy()

    local execOk, execErr = pcall(fn)
    if not execOk then
        warn("[NewFish5] Execution error in Main_RS.lua:", execErr)
    end
end

local function ShowModuleSelectorUI()
    local CoreGui = game:GetService("CoreGui")
    local selectorGui = Instance.new("ScreenGui")
    selectorGui.Name = "ShieldModuleSelector"
    selectorGui.ResetOnSpawn = false
    selectorGui.IgnoreGuiInset = true

    local success, _ = pcall(function()
        selectorGui.Parent = CoreGui
    end)
    if not success then
        selectorGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    end

    -- Background Dim
    local bgDim = Instance.new("Frame")
    bgDim.Size = UDim2.new(1, 0, 1, 0)
    bgDim.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    bgDim.BackgroundTransparency = 0.6
    bgDim.BorderSizePixel = 0
    bgDim.Parent = selectorGui

    -- Main Container (Match Screenshot Dimensions & Colors)
    local frame = Instance.new("CanvasGroup")
    frame.Size = UDim2.new(0, 640, 0, 420)
    frame.AnchorPoint = Vector2.new(0.5, 0.5)
    frame.Position = UDim2.new(0.5, 0, 0.5, 0)
    frame.BackgroundColor3 = Color3.fromRGB(15, 14, 24)
    frame.BorderSizePixel = 0
    frame.Parent = selectorGui

    local uiScale = Instance.new("UIScale")
    uiScale.Scale = 0.7
    uiScale.Parent = frame

    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, 16)
    uiCorner.Parent = frame

    local uiStroke = Instance.new("UIStroke")
    uiStroke.Color = Color3.fromRGB(45, 40, 65)
    uiStroke.Thickness = 1.5
    uiStroke.Parent = frame

    -- Centered Title "FEATURES"
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 30)
    title.Position = UDim2.new(0, 0, 0, 20)
    title.BackgroundTransparency = 1
    title.Text = "FEATURES"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 20
    title.Parent = frame

    -- Centered Subtitle
    local subtitle = Instance.new("TextLabel")
    subtitle.Size = UDim2.new(1, 0, 0, 20)
    subtitle.Position = UDim2.new(0, 0, 0, 48)
    subtitle.BackgroundTransparency = 1
    subtitle.Text = "Select the features you want to activate."
    subtitle.TextColor3 = Color3.fromRGB(140, 140, 150)
    subtitle.Font = Enum.Font.GothamMedium
    subtitle.TextSize = 11
    subtitle.Parent = frame

    -- Timer Badge (Pill shaped, top right)
    local timerBadge = Instance.new("Frame")
    timerBadge.Size = UDim2.new(0, 160, 0, 28)
    timerBadge.Position = UDim2.new(1, -180, 0, 20)
    timerBadge.BackgroundColor3 = Color3.fromRGB(10, 9, 16)
    timerBadge.BorderSizePixel = 0
    timerBadge.Parent = frame

    local badgeCorner = Instance.new("UICorner")
    badgeCorner.CornerRadius = UDim.new(1, 0)
    badgeCorner.Parent = timerBadge

    local badgeStroke = Instance.new("UIStroke")
    badgeStroke.Color = Color3.fromRGB(45, 40, 65)
    badgeStroke.Thickness = 1
    badgeStroke.Parent = timerBadge

    -- Timer Circle Icon
    local timerCircle = Instance.new("Frame")
    timerCircle.Size = UDim2.new(0, 12, 0, 12)
    timerCircle.Position = UDim2.new(0, 10, 0.5, -6)
    timerCircle.BackgroundTransparency = 1
    timerCircle.Parent = timerBadge

    local circleCorner = Instance.new("UICorner")
    circleCorner.CornerRadius = UDim.new(1, 0)
    circleCorner.Parent = timerCircle

    local circleStroke = Instance.new("UIStroke")
    circleStroke.Color = Color3.fromRGB(110, 40, 220)
    circleStroke.Thickness = 1.5
    circleStroke.Parent = timerCircle

    -- Timer Circle Dot
    local circleDot = Instance.new("Frame")
    circleDot.Size = UDim2.new(0, 4, 0, 4)
    circleDot.Position = UDim2.new(0.5, -2, 0.5, -2)
    circleDot.BackgroundColor3 = Color3.fromRGB(110, 40, 220)
    circleDot.BorderSizePixel = 0
    circleDot.Parent = timerCircle
    local dotCorner = Instance.new("UICorner")
    dotCorner.CornerRadius = UDim.new(1, 0)
    dotCorner.Parent = circleDot

    -- Timer Text inside Badge
    local timerLabel = Instance.new("TextLabel")
    timerLabel.Size = UDim2.new(1, -32, 1, 0)
    timerLabel.Position = UDim2.new(0, 26, 0, 0)
    timerLabel.BackgroundTransparency = 1
    timerLabel.Text = "Auto-launching in 7s..."
    timerLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
    timerLabel.Font = Enum.Font.GothamMedium
    timerLabel.TextSize = 10
    timerLabel.TextXAlignment = Enum.TextXAlignment.Left
    timerLabel.Parent = timerBadge

    -- Feature Grid Container
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Size = UDim2.new(1, -40, 0, 256)
    scrollFrame.Position = UDim2.new(0, 20, 0, 85)
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.BorderSizePixel = 0
    scrollFrame.ScrollBarThickness = 0
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    scrollFrame.Parent = frame

    local gridLayout = Instance.new("UIGridLayout")
    gridLayout.CellSize = UDim2.new(0, 192, 0, 36)
    gridLayout.CellPadding = UDim2.new(0, 12, 0, 8)
    gridLayout.SortOrder = Enum.SortOrder.LayoutOrder
    gridLayout.Parent = scrollFrame

    local SelectableModules = {
        { Name = "AutoCast", Label = "Auto Cast" },
        { Name = "AutoReel", Label = "Auto Reel" },
        { Name = "AutoShake", Label = "Auto Shake" },
        { Name = "AutoBuyBait", Label = "Auto Buy Bait" },
        { Name = "AutoBuyRod", Label = "Auto Buy Rod" },
        { Name = "AutoSell", Label = "Auto Sell Fish" },
        { Name = "TeleportArea", Label = "Teleport Area" },
        { Name = "TeleportZone", Label = "Teleport Zone" },
        { Name = "ESP", Label = "ESP Player/Items" },
        { Name = "AutoQuest", Label = "Auto Quest" },
        { Name = "WalkSpeed", Label = "WalkSpeed & Jump" },
        { Name = "AutoCosmic", Label = "Auto Cosmic" },
        { Name = "AutoMine", Label = "Auto Mine Drip" },
        { Name = "DisableOxygen", Label = "Disable Oxygen" },
        { Name = "AutoPotion", Label = "Auto Potion" },
        { Name = "MiscFishing", Label = "Misc Fishing" },
        { Name = "AutoHop", Label = "Auto Hop (Server)" },
        { Name = "AutoMinigames", Label = "Auto Minigames" }
    }

    local disabledModules = {}

    for i, module in ipairs(SelectableModules) do
        local cell = Instance.new("Frame")
        cell.BackgroundColor3 = Color3.fromRGB(22, 20, 34)
        cell.BorderSizePixel = 0
        cell.Parent = scrollFrame

        local cellCorner = Instance.new("UICorner")
        cellCorner.CornerRadius = UDim.new(0, 6)
        cellCorner.Parent = cell

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -55, 1, 0)
        label.Position = UDim2.new(0, 12, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = module.Label
        label.TextColor3 = Color3.fromRGB(220, 220, 230)
        label.Font = Enum.Font.GothamMedium
        label.TextSize = 11
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = cell

        -- iOS Toggle Switch
        local togglePill = Instance.new("TextButton")
        togglePill.Size = UDim2.new(0, 36, 0, 20)
        togglePill.Position = UDim2.new(1, -46, 0.5, -10)
        togglePill.BackgroundColor3 = Color3.fromRGB(110, 40, 220)
        togglePill.Text = ""
        togglePill.Parent = cell

        local pillCorner = Instance.new("UICorner")
        pillCorner.CornerRadius = UDim.new(1, 0)
        pillCorner.Parent = togglePill

        local toggleKnob = Instance.new("Frame")
        toggleKnob.Size = UDim2.new(0, 16, 0, 16)
        toggleKnob.Position = UDim2.new(0, 18, 0, 2)
        toggleKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        toggleKnob.Parent = togglePill

        local knobCorner = Instance.new("UICorner")
        knobCorner.CornerRadius = UDim.new(1, 0)
        knobCorner.Parent = toggleKnob

        -- Checkmark label inside knob
        local checkText = Instance.new("TextLabel")
        checkText.Size = UDim2.new(1, 0, 1, 0)
        checkText.BackgroundTransparency = 1
        checkText.Text = "✓"
        checkText.TextColor3 = Color3.fromRGB(110, 40, 220)
        checkText.Font = Enum.Font.GothamBold
        checkText.TextSize = 9
        checkText.Parent = toggleKnob

        local isChecked = true
        togglePill.MouseButton1Click:Connect(function()
            isChecked = not isChecked
            if isChecked then
                disabledModules[module.Name] = nil
                TweenService:Create(togglePill, TweenInfo.new(0.18), {BackgroundColor3 = Color3.fromRGB(110, 40, 220)}):Play()
                TweenService:Create(toggleKnob, TweenInfo.new(0.18), {Position = UDim2.new(0, 18, 0, 2)}):Play()
                task.delay(0.08, function() checkText.Text = "✓" end)
            else
                disabledModules[module.Name] = true
                TweenService:Create(togglePill, TweenInfo.new(0.18), {BackgroundColor3 = Color3.fromRGB(35, 30, 50)}):Play()
                TweenService:Create(toggleKnob, TweenInfo.new(0.18), {Position = UDim2.new(0, 2, 0, 2)}):Play()
                checkText.Text = ""
            end
        end)
    end

    -- Launch Button Container (Purple gradient matching reference)
    local btnContainer = Instance.new("Frame")
    btnContainer.Size = UDim2.new(1, -40, 0, 46)
    btnContainer.Position = UDim2.new(0, 20, 1, -66)
    btnContainer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    btnContainer.BorderSizePixel = 0
    btnContainer.Parent = frame

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 10)
    btnCorner.Parent = btnContainer

    local btnGrad = Instance.new("UIGradient")
    btnGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(110, 40, 220)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 70, 255))
    })
    btnGrad.Parent = btnContainer

    -- Centered Content Wrapper for Icon + Text
    local contentFrame = Instance.new("Frame")
    contentFrame.Size = UDim2.new(1, 0, 1, 0)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Parent = btnContainer

    local listLayout = Instance.new("UIListLayout")
    listLayout.FillDirection = Enum.FillDirection.Horizontal
    listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    listLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    listLayout.Padding = UDim.new(0, 8)
    listLayout.Parent = contentFrame

    -- Corrected Logo/Icon (Roblox Image Asset)
    local launchIcon = Instance.new("ImageLabel")
    launchIcon.Size = UDim2.new(0, 14, 0, 14)
    launchIcon.BackgroundTransparency = 1
    launchIcon.Image = "rbxassetid://10747373176" -- Sharp up-right diagonal arrow icon
    launchIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
    launchIcon.Parent = contentFrame

    -- Solid White Text (unaffected by gradient)
    local btnText = Instance.new("TextLabel")
    btnText.Size = UDim2.new(0, 200, 1, 0)
    btnText.BackgroundTransparency = 1
    btnText.Text = "LAUNCH & ENABLE FEATURES"
    btnText.TextColor3 = Color3.fromRGB(255, 255, 255)
    btnText.Font = Enum.Font.GothamBold
    btnText.TextSize = 13
    btnText.Parent = contentFrame

    -- Invisible Button for Click Events
    local launchBtn = Instance.new("TextButton")
    launchBtn.Size = UDim2.new(1, 0, 1, 0)
    launchBtn.BackgroundTransparency = 1
    launchBtn.Text = ""
    launchBtn.Parent = btnContainer

    -- Countdown & Launch Action
    local countdownActive = true
    local launchEvent = Instance.new("BindableEvent")

    task.spawn(function()
        for i = 7, 1, -1 do
            if not countdownActive then break end
            timerLabel.Text = "Auto-launching in " .. i .. "s..."
            task.wait(1)
        end
        if countdownActive then
            launchEvent:Fire()
        end
    end)

    launchBtn.MouseButton1Click:Connect(function()
        countdownActive = false
        launchEvent:Fire()
    end)

    launchEvent.Event:Wait()

    -- Tween Out Selector
    TweenService:Create(bgDim, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
    local tweenOut = TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Exponential, Enum.EasingDirection.In), {
        Position = UDim2.new(0.5, 0, 0.5, 40),
        GroupTransparency = 1
    })
    tweenOut:Play()
    tweenOut.Completed:Wait()

    selectorGui:Destroy()
    _G.DisabledModules = disabledModules
end

ShowModuleSelectorUI()
LoadMainScript()

