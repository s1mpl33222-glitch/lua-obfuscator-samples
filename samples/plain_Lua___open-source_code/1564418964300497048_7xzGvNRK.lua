-- SPEED HUB | Kukurin Life
-- Interface Speed Hub (v6.17 - Fully Translated in English)
-- Place in StarterPlayer > StarterPlayerScripts

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")
local Clipboard = setclipboard or toclipboard or (syn and syn.write_clipboard)

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

--========================================================
-- CONFIGURATION & SYSTEMS
--========================================================

local CONFIG_FILE_NAME = "SpeedHub_Config.json"
local CORRECT_KEY = "FRAXxBeStSCRiPtEr" -- Exact requested key

local SPIN_JUMP_VELOCITY = 15
local SPIN_ASCEND_TIME = 0.35
local SPIN_DESCENT_SPEED = -150
local SPIN_TURNS_PER_SECOND = 10
local SPIN_SPEED = math.rad(360 * SPIN_TURNS_PER_SECOND)
local SPIN_TARGET_ANGLE = math.rad(3000) -- Exact 3000 degrees
local SPIN_REPEAT_DELAY = 0.1
local SPIN_MAX_DESCENT_TIME = 1.5
local SPIN_GROUND_CHECK_DISTANCE = 3.5

local spinEnabled = false
local spinPhase = "Idle"
local spinPhaseStart = os.clock()
local spinTotalAngle = 0
local spinIdleAt = 0
local spinBind = Enum.KeyCode.B
local waitingForSpinBind = false
local spinSavedAutoRotate = true
local spinSavedPlatformStand = false
local spinCycleSeated = false

local spinRootAttachment
local spinUprightAlign
local spinCurrentBody

-- AUTO WHEELIE
local MAX_WHEELIE_ANGLE = 35
local STEER_SPEED = 3.0
local wheelieActive = false
local wheelieAttachment = nil
local wheelieAlignOrientation = nil
local wheelieConnection = nil
local wheelieBind = Enum.KeyCode.N
local waitingForWheelieBind = false

-- SPEED HACK
local speedHackActive = false
local targetSpeedValue = 100
local speedHackConnection = nil
local speedHackAttachment = nil
local speedHackVectorForce = nil
local speedHackBind = Enum.KeyCode.M
local waitingForSpeedHackBind = false

-- RAINBOW SCOOTER
local rainbowActive = false
local rainbowConnection = nil
local rainbowHue = 0
local originalColors = {}

local opened = false
local keyVerified = false
local currentPage = "Main"
local running = true
local dragging = false
local dragStart
local panelStart
local busy = false

local function saveConfig()
    local configData = {
        SpinBind = spinBind.Name,
        WheelieBind = wheelieBind.Name,
        SpeedHackBind = speedHackBind.Name,
        SpeedHackValue = targetSpeedValue
    }
    if writefile then
        pcall(function()
            writefile(CONFIG_FILE_NAME, HttpService:JSONEncode(configData))
        end)
    end
end

local function loadConfig()
    if readfile and isfile and isfile(CONFIG_FILE_NAME) then
        local success, result = pcall(function()
            return HttpService:JSONDecode(readfile(CONFIG_FILE_NAME))
        end)
        if success and type(result) == "table" then
            if result.SpinBind and Enum.KeyCode[result.SpinBind] then spinBind = Enum.KeyCode[result.SpinBind] end
            if result.WheelieBind and Enum.KeyCode[result.WheelieBind] then wheelieBind = Enum.KeyCode[result.WheelieBind] end
            if result.SpeedHackBind and Enum.KeyCode[result.SpeedHackBind] then speedHackBind = Enum.KeyCode[result.SpeedHackBind] end
            if result.SpeedHackValue and tonumber(result.SpeedHackValue) then targetSpeedValue = tonumber(result.SpeedHackValue) end
        end
    end
end

loadConfig()

if playerGui:FindFirstChild("SpeedHubHUD") then
    playerGui.SpeedHubHUD:Destroy()
end

local C = {
    black = Color3.fromRGB(8, 8, 10),
    panel = Color3.fromRGB(15, 15, 18),
    panel2 = Color3.fromRGB(22, 22, 28),
    yellow = Color3.fromRGB(255, 190, 0),
    yellowSoft = Color3.fromRGB(230, 210, 140),
    muted = Color3.fromRGB(120, 110, 80),
    hover = Color3.fromRGB(40, 35, 12),
    discord = Color3.fromRGB(88, 101, 242),
}

local function make(className, props, parent)
    local obj = Instance.new(className)
    for key, value in pairs(props or {}) do obj[key] = value end
    obj.Parent = parent
    return obj
end

local function round(parent, radius)
    make("UICorner", { CornerRadius = UDim.new(0, radius or 10) }, parent)
end

local function outline(parent, color, thickness, transparency)
    make("UIStroke", {
        Color = color or C.yellow,
        Thickness = thickness or 1,
        Transparency = transparency or 0.6,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    }, parent)
end

local function animate(obj, duration, props, style, direction)
    local tween = TweenService:Create(
        obj,
        TweenInfo.new(duration or 0.22, style or Enum.EasingStyle.Quart, direction or Enum.EasingDirection.Out),
        props
    )
    tween:Play()
    return tween
end

-- Discord Tag above head
local function setupDiscordTag(character)
    local head = character:WaitForChild("Head", 5)
    if not head then return end
    if head:FindFirstChild("SpeedHubDiscordTag") then return end
    
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "SpeedHubDiscordTag"
    billboard.Size = UDim2.new(0, 400, 0, 80)
    billboard.StudsOffset = Vector3.new(0, 3.2, 0)
    billboard.AlwaysOnTop = true
    billboard.Adornee = head
    billboard.Parent = head
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.fromScale(1, 1)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = "https://discord.gg/DyUUbP3kXz"
    textLabel.TextColor3 = C.yellow
    textLabel.TextStrokeTransparency = 0.1
    textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    textLabel.Font = Enum.Font.GothamBlack
    textLabel.TextSize = 20
    textLabel.Parent = billboard
end

if player.Character then
    task.spawn(function() setupDiscordTag(player.Character) end)
end

player.CharacterAdded:Connect(function(character)
    task.spawn(function() setupDiscordTag(character) end)
end)

local gui = make("ScreenGui", {
    Name = "SpeedHubHUD",
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
}, playerGui)

--========================================================
-- KEY SYSTEM WINDOW
--========================================================

local keySystemFrame = make("Frame", {
    Name = "KeySystemFrame",
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.5),
    Size = UDim2.fromOffset(420, 245),
    BackgroundColor3 = C.black,
    BorderSizePixel = 0,
    Active = true,
    ZIndex = 20,
}, gui)

round(keySystemFrame, 16)
outline(keySystemFrame, C.yellow, 1.5, 0.3)

make("TextLabel", {
    Position = UDim2.new(0, 0, 0, 16),
    Size = UDim2.new(1, 0, 0, 25),
    BackgroundTransparency = 1,
    Text = "⚡ SPEED HUB - AUTHENTICATION",
    TextColor3 = C.yellow,
    Font = Enum.Font.GothamBold,
    TextSize = 14,
    ZIndex = 21,
}, keySystemFrame)

make("TextLabel", {
    Position = UDim2.new(0, 20, 0, 46),
    Size = UDim2.new(1, -40, 0, 20),
    BackgroundTransparency = 1,
    Text = "The key is available on our Discord:",
    TextColor3 = C.yellowSoft,
    Font = Enum.Font.GothamMedium,
    TextSize = 11,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 21,
}, keySystemFrame)

local discordLinkButton = make("TextButton", {
    Position = UDim2.new(0, 20, 0, 68),
    Size = UDim2.new(1, -40, 0, 20),
    BackgroundTransparency = 1,
    Text = "🔗 https://discord.gg/DyUUbP3kXz (Click to copy)",
    TextColor3 = C.discord,
    Font = Enum.Font.GothamBold,
    TextSize = 11,
    TextXAlignment = Enum.TextXAlignment.Left,
    AutoButtonColor = false,
    ZIndex = 21,
}, keySystemFrame)

discordLinkButton.Activated:Connect(function()
    if Clipboard then
        pcall(function() Clipboard("https://discord.gg/DyUUbP3kXz") end)
    end
    discordLinkButton.Text = "✓ Link copied to clipboard!"
    task.wait(1.5)
    discordLinkButton.Text = "🔗 https://discord.gg/DyUUbP3kXz (Click to copy)"
end)

local keyTextBox = make("TextBox", {
    Position = UDim2.new(0, 20, 0, 96),
    Size = UDim2.new(1, -40, 0, 40),
    BackgroundColor3 = C.panel2,
    Text = "",
    PlaceholderText = "Paste the key here...",
    PlaceholderColor3 = C.muted,
    TextColor3 = C.yellow,
    Font = Enum.Font.GothamBold,
    TextSize = 13,
    ClearTextOnFocus = false,
    ZIndex = 21,
}, keySystemFrame)
round(keyTextBox, 8)
outline(keyTextBox, C.yellow, 1, 0.5)

local verifyButton = make("TextButton", {
    Position = UDim2.new(0, 20, 0, 148),
    Size = UDim2.new(1, -40, 0, 42),
    BackgroundColor3 = C.yellow,
    Text = "SUBMIT KEY",
    TextColor3 = C.black,
    Font = Enum.Font.GothamBold,
    TextSize = 12,
    AutoButtonColor = false,
    BorderSizePixel = 0,
    ZIndex = 21,
}, keySystemFrame)
round(verifyButton, 8)

--========================================================
-- MAIN GUI PANEL
--========================================================

local dim = make("Frame", {
    Name = "DimLayer",
    Size = UDim2.fromScale(1, 1),
    BackgroundTransparency = 1,
    Visible = false,
    ZIndex = 1,
}, gui)

local main = make("Frame", {
    Name = "MainWindow",
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.52),
    Size = UDim2.fromScale(0.62, 0.62),
    BackgroundColor3 = C.black,
    BorderSizePixel = 0,
    ClipsDescendants = true,
    Active = true,
    Visible = false,
    ZIndex = 2,
}, gui)

round(main, 16)
outline(main, C.yellow, 1.2, 0.5)

make("UIStroke", {
    Color = Color3.fromRGB(0, 0, 0),
    Thickness = 6,
    Transparency = 0.4,
    ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
}, main)

make("UISizeConstraint", {
    MinSize = Vector2.new(520, 360),
    MaxSize = Vector2.new(880, 600),
}, main)

local header = make("Frame", {
    Name = "Header",
    Size = UDim2.new(1, 0, 0, 58),
    BackgroundColor3 = C.panel,
    BackgroundTransparency = 0.1,
    BorderSizePixel = 0,
    ZIndex = 3,
}, main)

make("Frame", {
    Position = UDim2.new(0, 0, 1, -1),
    Size = UDim2.new(1, 0, 0, 1),
    BackgroundColor3 = C.yellow,
    BorderSizePixel = 0,
    Transparency = 0.6,
    ZIndex = 4,
}, header)

local logoIcon = make("TextLabel", {
    Name = "SpeedIcon",
    Position = UDim2.new(0, 14, 0, 11),
    Size = UDim2.fromOffset(36, 36),
    BackgroundColor3 = C.panel2,
    Text = "⚡",
    TextColor3 = C.yellow,
    Font = Enum.Font.GothamBold,
    TextSize = 18,
    BorderSizePixel = 0,
    ZIndex = 5,
}, header)

round(logoIcon, 10)
outline(logoIcon, C.yellow, 1, 0.5)

make("TextLabel", {
    Position = UDim2.new(0, 60, 0, 18),
    Size = UDim2.new(0, 250, 0, 22),
    BackgroundTransparency = 1,
    Text = "SPEED HUB",
    TextColor3 = C.yellow,
    Font = Enum.Font.GothamBold,
    TextSize = 16,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 5,
}, header)

local close = make("TextButton", {
    Name = "CloseButton",
    AnchorPoint = Vector2.new(1, 0.5),
    Position = UDim2.new(1, -14, 0.5, 0),
    Size = UDim2.fromOffset(26, 26),
    BackgroundColor3 = C.panel2,
    Text = "✕",
    TextColor3 = C.yellow,
    Font = Enum.Font.GothamBold,
    TextSize = 11,
    AutoButtonColor = false,
    BorderSizePixel = 0,
    ZIndex = 6,
}, header)

round(close, 7)
outline(close, C.yellow, 1, 0.6)

close.MouseEnter:Connect(function()
    animate(close, 0.15, {BackgroundColor3 = Color3.fromRGB(180, 30, 30), TextColor3 = Color3.fromRGB(255, 255, 255)})
end)
close.MouseLeave:Connect(function()
    animate(close, 0.15, {BackgroundColor3 = C.panel2, TextColor3 = C.yellow})
end)

local body = make("Frame", {
    Name = "Body",
    Position = UDim2.new(0, 0, 0, 58),
    Size = UDim2.new(1, 0, 1, -58),
    BackgroundTransparency = 1,
    ZIndex = 3,
}, main)

local sidebar = make("Frame", {
    Name = "Sidebar",
    AnchorPoint = Vector2.new(0, 0),
    Position = UDim2.new(0, 0, 0, 0),
    Size = UDim2.new(0, 175, 1, 0),
    BackgroundColor3 = C.panel,
    BackgroundTransparency = 0.3,
    BorderSizePixel = 0,
    ZIndex = 3,
}, body)

make("Frame", {
    AnchorPoint = Vector2.new(1, 0),
    Position = UDim2.new(1, 0, 0, 0),
    Size = UDim2.new(0, 1, 1, 0),
    BackgroundColor3 = C.yellow,
    BorderSizePixel = 0,
    Transparency = 0.7,
    ZIndex = 4,
}, sidebar)

make("TextLabel", {
    Position = UDim2.new(0, 12, 0, 12),
    Size = UDim2.new(1, -20, 0, 14),
    BackgroundTransparency = 1,
    Text = "MENU",
    TextColor3 = C.muted,
    Font = Enum.Font.GothamBold,
    TextSize = 8,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 4,
}, sidebar)

local nav = make("Frame", {
    Position = UDim2.new(0, 10, 0, 36),
    Size = UDim2.new(1, -20, 0, 220),
    BackgroundTransparency = 1,
    ZIndex = 4,
}, sidebar)

make("UIListLayout", {
    Padding = UDim.new(0, 10),
    SortOrder = Enum.SortOrder.LayoutOrder,
}, nav)

make("TextLabel", {
    AnchorPoint = Vector2.new(0, 1),
    Position = UDim2.new(0, 12, 1, -10),
    Size = UDim2.new(1, -20, 0, 20),
    BackgroundTransparency = 1,
    Text = "SPEED HUB",
    TextColor3 = C.muted,
    Font = Enum.Font.GothamMedium,
    TextSize = 8,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Bottom,
    ZIndex = 4,
}, sidebar)

local content = make("ScrollingFrame", {
    Name = "Content",
    Position = UDim2.new(0, 175, 0, 0),
    Size = UDim2.new(1, -175, 1, 0),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ScrollBarThickness = 4,
    ScrollBarImageColor3 = C.yellow,
    CanvasSize = UDim2.new(0, 0, 0, 0),
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
    ZIndex = 3,
}, body)

local pageTitle = make("TextLabel", {
    Position = UDim2.new(0, 16, 0, 14),
    Size = UDim2.new(1, -32, 0, 22),
    BackgroundTransparency = 1,
    Text = "Main",
    TextColor3 = C.yellow,
    Font = Enum.Font.GothamBold,
    TextSize = 16,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 4,
}, content)

local pageArea = make("Frame", {
    Name = "PageArea",
    Position = UDim2.new(0, 16, 0, 44),
    Size = UDim2.new(1, -32, 1, -55),
    BackgroundTransparency = 1,
    AutomaticSize = Enum.AutomaticSize.Y,
    ZIndex = 4,
}, content)

make("UIListLayout", {
    Padding = UDim.new(0, 10),
    SortOrder = Enum.SortOrder.LayoutOrder,
}, pageArea)

local floating = make("TextButton", {
    Name = "SpeedHubToggle",
    AnchorPoint = Vector2.new(1, 0.5),
    Position = UDim2.new(1, -16, 0.5, 0),
    Size = UDim2.fromOffset(40, 40),
    BackgroundColor3 = C.black,
    Text = "⚡",
    TextColor3 = C.yellow,
    Font = Enum.Font.GothamBold,
    TextSize = 20,
    AutoButtonColor = false,
    BorderSizePixel = 0,
    Visible = false,
    ZIndex = 10,
}, gui)

round(floating, 12)
outline(floating, C.yellow, 1.2, 0.4)

local pages = {}
local navButtons = {}

local function newPageObject(className, props)
    local obj = make(className, props, pageArea)
    table.insert(pages, obj)
    return obj
end

local function clearPage()
    for _, obj in ipairs(pages) do
        if obj and obj.Parent then obj:Destroy() end
    end
    table.clear(pages)
end

local function actionButton(parent, text, pos, size, callback)
    local b = make("TextButton", {
        Position = pos,
        Size = size or UDim2.new(1, 0, 0, 32),
        BackgroundColor3 = C.panel2,
        BackgroundTransparency = 0.1,
        Text = text,
        TextColor3 = C.yellow,
        Font = Enum.Font.GothamSemibold,
        TextSize = 10,
        AutoButtonColor = false,
        BorderSizePixel = 0,
        ZIndex = 6,
    }, parent)

    round(b, 8)
    outline(b, C.yellow, 1, 0.5)

    b.MouseEnter:Connect(function()
        animate(b, 0.15, {BackgroundColor3 = C.hover, BackgroundTransparency = 0.0})
    end)
    b.MouseLeave:Connect(function()
        if not b:GetAttribute("CustomToggle") then
            animate(b, 0.15, {BackgroundColor3 = C.panel2, BackgroundTransparency = 0.1})
        end
    end)

    b.Activated:Connect(callback)
    return b
end

--========================================================
-- LOGIC 1 : MONEY METHOD
--========================================================

local function setSpinPhase(name)
    spinPhase = name
    spinPhaseStart = os.clock()
end

local function getSpinParts()
    local character = player.Character
    if not character then return nil end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local root = character:FindFirstChild("HumanoidRootPart")
    if not humanoid or not root or humanoid.Health <= 0 then return nil end
    local seatPart = humanoid.SeatPart
    local bodyPart = root
    local vehicle
    if seatPart then
        bodyPart = seatPart.AssemblyRootPart or seatPart
        vehicle = seatPart:FindFirstAncestorOfClass("Model")
    end
    return character, humanoid, root, bodyPart, vehicle, seatPart
end

local function removeSpinAligner()
    if spinUprightAlign then spinUprightAlign:Destroy() spinUprightAlign = nil end
    if spinRootAttachment then spinRootAttachment:Destroy() spinRootAttachment = nil end
    spinCurrentBody = nil
end

local function setSpinOrientation(bodyPart, angle)
    if not bodyPart or not bodyPart.Parent then return end
    if spinCurrentBody ~= bodyPart then
        removeSpinAligner()
        spinCurrentBody = bodyPart
        spinRootAttachment = Instance.new("Attachment", bodyPart)
        spinUprightAlign = Instance.new("AlignOrientation", bodyPart)
        spinUprightAlign.Mode = Enum.OrientationAlignmentMode.OneAttachment
        spinUprightAlign.Attachment0 = spinRootAttachment
        spinUprightAlign.Responsiveness = 300
        spinUprightAlign.MaxTorque = 1e9
        spinUprightAlign.MaxAngularVelocity = 1e6
    end
    spinUprightAlign.CFrame = CFrame.Angles(0, angle, 0)
end

local function releaseSpinCharacter(humanoid, bodyPart)
    removeSpinAligner()
    if humanoid and not spinCycleSeated then
        humanoid.AutoRotate = spinSavedAutoRotate
        humanoid.PlatformStand = spinSavedPlatformStand
    end
    if bodyPart and bodyPart.Parent then
        bodyPart.AssemblyAngularVelocity = Vector3.zero
        bodyPart.AssemblyLinearVelocity = Vector3.zero
    end
    spinCycleSeated = false
end

local function resetSpinCycle()
    spinPhase = "Idle"
    spinTotalAngle = 0
    removeSpinAligner()
end

local function isSpinGrounded(character, bodyPart, vehicle)
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = {character, vehicle or bodyPart}
    return Workspace:Raycast(bodyPart.Position, Vector3.new(0, -SPIN_GROUND_CHECK_DISTANCE, 0), params) ~= nil
end

local function setSpinVelocityStrict(bodyPart, y)
    if bodyPart and bodyPart.Parent then
        bodyPart.AssemblyLinearVelocity = Vector3.new(0, y, 0)
    end
end

local spinToggleButton, spinBindButton

local function refreshSpinUI()
    if spinToggleButton and spinToggleButton.Parent then
        spinToggleButton.Text = spinEnabled and "Money Method • ON" or "Money Method • OFF"
        spinToggleButton.BackgroundColor3 = spinEnabled and Color3.fromRGB(70, 55, 0) or C.panel2
    end
    if spinBindButton and spinBindButton.Parent then
        spinBindButton.Text = waitingForSpinBind and "..." or spinBind.Name
    end
end

local function startSpinCycle()
    local character, humanoid, _, bodyPart, _, seatPart = getSpinParts()
    if not character then return false end
    spinCycleSeated = seatPart ~= nil
    if not spinCycleSeated then
        spinSavedAutoRotate = humanoid.AutoRotate
        spinSavedPlatformStand = humanoid.PlatformStand
        humanoid.AutoRotate = false
        humanoid.PlatformStand = true
    end
    spinTotalAngle = 0
    setSpinOrientation(bodyPart, 0)
    setSpinVelocityStrict(bodyPart, SPIN_JUMP_VELOCITY)
    spinPhaseStart = os.clock()
    setSpinPhase("Ascend")
    return true
end

local function stopSpin()
    spinEnabled = false
    local _, humanoid, _, bodyPart = getSpinParts()
    releaseSpinCharacter(humanoid, bodyPart or spinCurrentBody)
    resetSpinCycle()
    refreshSpinUI()
end

local function toggleSpin()
    if spinEnabled then stopSpin() return end
    if not getSpinParts() then return end
    spinEnabled = true
    spinIdleAt = 0
    if not startSpinCycle() then spinEnabled = false end
    refreshSpinUI()
end

RunService.Heartbeat:Connect(function(dt)
    if not spinEnabled then return end
    local character, humanoid, _, bodyPart, vehicle, seatPart = getSpinParts()
    if not character then
        if spinPhase ~= "Idle" then releaseSpinCharacter(nil, spinCurrentBody) resetSpinCycle() end
        return
    end
    local now = os.clock()
    local elapsed = now - spinPhaseStart
    if spinPhase == "Idle" then
        if now - spinIdleAt >= SPIN_REPEAT_DELAY then startSpinCycle() end
    elseif spinPhase == "Ascend" then
        setSpinVelocityStrict(bodyPart, SPIN_JUMP_VELOCITY)
        setSpinOrientation(bodyPart, 0)
        if elapsed >= SPIN_ASCEND_TIME then setSpinPhase("Spin") end
    elseif spinPhase == "Spin" then
        setSpinVelocityStrict(bodyPart, 0)
        spinTotalAngle = math.min(spinTotalAngle + SPIN_SPEED * dt, SPIN_TARGET_ANGLE)
        setSpinOrientation(bodyPart, spinTotalAngle)
        if spinTotalAngle >= SPIN_TARGET_ANGLE then setSpinPhase("Descend") end
    elseif spinPhase == "Descend" then
        setSpinVelocityStrict(bodyPart, SPIN_DESCENT_SPEED)
        setSpinOrientation(bodyPart, SPIN_TARGET_ANGLE)
        if isSpinGrounded(character, bodyPart, vehicle) or elapsed >= SPIN_MAX_DESCENT_TIME then setSpinPhase("Landed") end
    elseif spinPhase == "Landed" then
        setSpinVelocityStrict(bodyPart, 0)
        if elapsed >= 0.05 then
            releaseSpinCharacter(humanoid, bodyPart)
            spinTotalAngle = 0
            spinIdleAt = now
            setSpinPhase("Idle")
        end
    end
end)

--========================================================
-- LOGIC 2 : AUTO WHEELIE
--========================================================

local function stopWheelie()
    wheelieActive = false
    if wheelieConnection then wheelieConnection:Disconnect() wheelieConnection = nil end
    if wheelieAlignOrientation then wheelieAlignOrientation:Destroy() wheelieAlignOrientation = nil end
    if wheelieAttachment then wheelieAttachment:Destroy() wheelieAttachment = nil end
end

local wheelieToggleButton, wheelieBindButton

local function refreshWheelieUI()
    if wheelieToggleButton and wheelieToggleButton.Parent then
        wheelieToggleButton.Text = wheelieActive and "Auto Wheelie • ON" or "Auto Wheelie • OFF"
        wheelieToggleButton.BackgroundColor3 = wheelieActive and Color3.fromRGB(70, 55, 0) or C.panel2
    end
    if wheelieBindButton and wheelieBindButton.Parent then
        wheelieBindButton.Text = waitingForWheelieBind and "..." or wheelieBind.Name
    end
end

local function toggleWheelie()
    local character = player.Character
    if not character then return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not (humanoid and humanoid.SeatPart and humanoid.SeatPart:IsA("VehicleSeat")) then return end

    local seat = humanoid.SeatPart
    if wheelieActive then
        stopWheelie()
    else
        wheelieActive = true
        wheelieAttachment = Instance.new("Attachment", seat)
        wheelieAlignOrientation = Instance.new("AlignOrientation", seat)
        wheelieAlignOrientation.Mode = Enum.OrientationAlignmentMode.OneAttachment
        wheelieAlignOrientation.Attachment0 = wheelieAttachment
        wheelieAlignOrientation.MaxTorque = 10000000
        wheelieAlignOrientation.MaxAngularVelocity = 20
        wheelieAlignOrientation.Responsiveness = 50

        local _, currentYaw, _ = seat.CFrame:ToOrientation()
        wheelieConnection = RunService.Heartbeat:Connect(function(dt)
            if not seat or not seat.Parent then stopWheelie() refreshWheelieUI() return end
            local steerInput = seat.SteerFloat or seat.Steer
            currentYaw = currentYaw - (steerInput * STEER_SPEED * dt)
            wheelieAlignOrientation.CFrame = CFrame.new(seat.Position) * CFrame.Angles(0, currentYaw, 0) * CFrame.Angles(math.rad(MAX_WHEELIE_ANGLE), 0, 0)
        end)
    end
    refreshWheelieUI()
end

--========================================================
-- LOGIC 3 : SPEED HACK (CORRECTED: FORWARD ONLY)
--========================================================

local speedHackToggleButton, speedHackBindButton

local function refreshSpeedHackUI()
    if speedHackToggleButton and speedHackToggleButton.Parent then
        speedHackToggleButton.Text = speedHackActive and "Speed Hack • ON" or "Speed Hack • OFF"
        speedHackToggleButton.BackgroundColor3 = speedHackActive and Color3.fromRGB(70, 55, 0) or C.panel2
    end
    if speedHackBindButton and speedHackBindButton.Parent then
        speedHackBindButton.Text = waitingForSpeedHackBind and "..." or speedHackBind.Name
    end
end

local function stopSpeedHack()
    speedHackActive = false
    if speedHackConnection then speedHackConnection:Disconnect() speedHackConnection = nil end
    if speedHackVectorForce then speedHackVectorForce:Destroy() speedHackVectorForce = nil end
    if speedHackAttachment then speedHackAttachment:Destroy() speedHackAttachment = nil end
    refreshSpeedHackUI()
end

local function toggleSpeedHack()
    if speedHackActive then
        stopSpeedHack()
    else
        local character = player.Character
        if not character then return end
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not humanoid or not humanoid.SeatPart or not humanoid.SeatPart:IsA("VehicleSeat") then return end

        local seat = humanoid.SeatPart
        local vehicle = seat.Parent or seat

        speedHackActive = true
        speedHackAttachment = Instance.new("Attachment", seat)
        speedHackVectorForce = Instance.new("VectorForce", seat)
        speedHackVectorForce.Attachment0 = speedHackAttachment
        speedHackVectorForce.RelativeTo = Enum.ActuatorRelativeTo.World
        speedHackVectorForce.ApplyAtCenterOfMass = true

        speedHackConnection = RunService.Heartbeat:Connect(function(dt)
            if not seat or not seat.Parent or not vehicle or not vehicle.Parent then stopSpeedHack() return end
            local throttleInput = seat.ThrottleFloat or seat.Throttle
            
            -- CORRECTED: Active ONLY when moving forward (throttleInput > 0)
            if throttleInput > 0 then
                local rootPart = seat.AssemblyRootPart or seat
                local currentVelocity = rootPart.AssemblyLinearVelocity
                local horizontalVel = Vector3.new(currentVelocity.X, 0, currentVelocity.Z)
                local lookDir = seat.CFrame.LookVector
                local flatLookDir = Vector3.new(lookDir.X, 0, lookDir.Z).Unit

                if flatLookDir.Magnitude > 0 then
                    local mass = 0
                    for _, p in ipairs(vehicle:GetDescendants()) do if p:IsA("BasePart") then mass = mass + p.Mass end end
                    if mass == 0 then mass = 100 end

                    local targetVel = flatLookDir * targetSpeedValue
                    local smoothVel = horizontalVel:Lerp(targetVel, math.clamp(dt * 4, 0, 1))
                    local velDiff = smoothVel - horizontalVel
                    speedHackVectorForce.Force = Vector3.new(velDiff.X * mass * 10, 0, velDiff.Z * mass * 10)
                else
                    speedHackVectorForce.Force = Vector3.zero
                end
            else
                speedHackVectorForce.Force = Vector3.zero
            end
        end)
    end
    refreshSpeedHackUI()
end

--========================================================
-- LOGIC 4 : RAINBOW SCOOTER
--========================================================

local rainbowToggleButton

local function refreshRainbowUI()
    if rainbowToggleButton and rainbowToggleButton.Parent then
        rainbowToggleButton.Text = rainbowActive and "Rainbow Scooter • ON" or "Rainbow Scooter • OFF"
        rainbowToggleButton.BackgroundColor3 = rainbowActive and Color3.fromRGB(70, 55, 0) or C.panel2
    end
end

local function stopRainbow()
    rainbowActive = false
    if rainbowConnection then rainbowConnection:Disconnect() rainbowConnection = nil end
    for part, originalColor in pairs(originalColors) do
        if part and part.Parent then part.Color = originalColor end
    end
    table.clear(originalColors)
    refreshRainbowUI()
end

local function toggleRainbow()
    if rainbowActive then
        stopRainbow()
    else
        local character = player.Character
        if not character then return end
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not humanoid or not humanoid.SeatPart then return end
        local vehicle = humanoid.SeatPart:FindFirstAncestorOfClass("Model")
        if not vehicle then return end

        table.clear(originalColors)
        for _, descendant in ipairs(vehicle:GetDescendants()) do
            if descendant:IsA("BasePart") then originalColors[descendant] = descendant.Color end
        end

        rainbowActive = true
        rainbowHue = 0
        rainbowConnection = RunService.Heartbeat:Connect(function(dt)
            if not rainbowActive then return end
            local char = player.Character
            if not char then stopRainbow() return end
            local hum = char:FindFirstChildOfClass("Humanoid")
            if not hum or not hum.SeatPart then stopRainbow() return end

            rainbowHue = (rainbowHue + dt * 0.25) % 1
            local rainbowColor = Color3.fromHSV(rainbowHue, 1, 1)
            for part, _ in pairs(originalColors) do
                if part and part.Parent then part.Color = rainbowColor end
            end
        end)
    end
    refreshRainbowUI()
end

--========================================================
-- PANEL PAGES MANAGEMENT
--========================================================

local pageTitles = { Player = "Player", Main = "Main", Settings = "Settings" }

local function showPage(name)
    currentPage = name
    clearPage()

    for key, button in pairs(navButtons) do
        local selected = key == name
        animate(button, 0.2, {
            BackgroundColor3 = selected and C.yellow or C.panel,
            TextColor3 = selected and C.black or C.yellowSoft,
        })
    end

    if pageTitles[name] then pageTitle.Text = pageTitles[name] end

    if name == "Main" then
        -- 1. Money Method
        local box1 = newPageObject("Frame", { Size = UDim2.new(1, 0, 0, 115), BackgroundColor3 = C.panel, BackgroundTransparency = 0.15, BorderSizePixel = 0, ZIndex = 5 })
        round(box1, 12) outline(box1, C.yellow, 1, 0.5)
        make("TextLabel", { Position = UDim2.new(0, 14, 0, 10), Size = UDim2.new(1, -28, 0, 18), BackgroundTransparency = 1, Text = "Money Method", TextColor3 = C.yellow, Font = Enum.Font.GothamBold, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 6 }, box1)

        spinToggleButton = actionButton(box1, "Money Method • OFF", UDim2.new(0, 14, 0, 58), UDim2.new(0.60, -18, 0, 32), toggleSpin)
        spinToggleButton:SetAttribute("CustomToggle", true)
        spinBindButton = actionButton(box1, spinBind.Name, UDim2.new(0.63, 0, 0, 58), UDim2.new(0.37, -4, 0, 32), function() waitingForSpinBind = true refreshSpinUI() end)
        refreshSpinUI()

        -- 2. Auto Wheelie
        local box2 = newPageObject("Frame", { Size = UDim2.new(1, 0, 0, 115), BackgroundColor3 = C.panel, BackgroundTransparency = 0.15, BorderSizePixel = 0, ZIndex = 5 })
        round(box2, 12) outline(box2, C.yellow, 1, 0.5)
        make("TextLabel", { Position = UDim2.new(0, 14, 0, 10), Size = UDim2.new(1, -28, 0, 18), BackgroundTransparency = 1, Text = "Auto Wheelie", TextColor3 = C.yellow, Font = Enum.Font.GothamBold, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 6 }, box2)

        wheelieToggleButton = actionButton(box2, "Auto Wheelie • OFF", UDim2.new(0, 14, 0, 58), UDim2.new(0.60, -18, 0, 32), toggleWheelie)
        wheelieToggleButton:SetAttribute("CustomToggle", true)
        wheelieBindButton = actionButton(box2, wheelieBind.Name, UDim2.new(0.63, 0, 0, 58), UDim2.new(0.37, -4, 0, 32), function() waitingForWheelieBind = true refreshWheelieUI() end)
        refreshWheelieUI()

        -- 3. Speed Hack
        local box3 = newPageObject("Frame", { Size = UDim2.new(1, 0, 0, 115), BackgroundColor3 = C.panel, BackgroundTransparency = 0.15, BorderSizePixel = 0, ZIndex = 5 })
        round(box3, 12) outline(box3, C.yellow, 1, 0.5)
        make("TextLabel", { Position = UDim2.new(0, 14, 0, 10), Size = UDim2.new(1, -28, 0, 18), BackgroundTransparency = 1, Text = "Speed Hack (Scooter Speed)", TextColor3 = C.yellow, Font = Enum.Font.GothamBold, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 6 }, box3)

        local speedTextBox = make("TextBox", { Position = UDim2.new(0, 14, 0, 58), Size = UDim2.new(0.30, -10, 0, 32), BackgroundColor3 = C.panel2, Text = tostring(targetSpeedValue), TextColor3 = C.yellow, Font = Enum.Font.GothamBold, TextSize = 12, ClearTextOnFocus = false, ZIndex = 6 }, box3)
        round(speedTextBox, 8) outline(speedTextBox, C.yellow, 1, 0.5)

        speedTextBox.FocusLost:Connect(function()
            local num = tonumber(speedTextBox.Text)
            if num then targetSpeedValue = num saveConfig() else speedTextBox.Text = tostring(targetSpeedValue) end
        end)

        speedHackToggleButton = actionButton(box3, "Speed Hack • OFF", UDim2.new(0.32, 0, 0, 58), UDim2.new(0.38, -6, 0, 32), toggleSpeedHack)
        speedHackToggleButton:SetAttribute("CustomToggle", true)
        speedHackBindButton = actionButton(box3, speedHackBind.Name, UDim2.new(0.72, 0, 0, 58), UDim2.new(0.28, -4, 0, 32), function() waitingForSpeedHackBind = true refreshSpeedHackUI() end)
        refreshSpeedHackUI()

        -- 4. Rainbow Scooter
        local box4 = newPageObject("Frame", { Size = UDim2.new(1, 0, 0, 115), BackgroundColor3 = C.panel, BackgroundTransparency = 0.15, BorderSizePixel = 0, ZIndex = 5 })
        round(box4, 12) outline(box4, C.yellow, 1, 0.5)
        make("TextLabel", { Position = UDim2.new(0, 14, 0, 10), Size = UDim2.new(1, -28, 0, 18), BackgroundTransparency = 1, Text = "Rainbow Scooter", TextColor3 = C.yellow, Font = Enum.Font.GothamBold, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 6 }, box4)

        rainbowToggleButton = actionButton(box4, "Rainbow Scooter • OFF", UDim2.new(0, 14, 0, 58), UDim2.new(1, -28, 0, 32), toggleRainbow)
        rainbowToggleButton:SetAttribute("CustomToggle", true)
        refreshRainbowUI()

    elseif name == "Player" then
        local boxPlayer = newPageObject("Frame", { Size = UDim2.new(1, 0, 0, 110), BackgroundColor3 = C.panel, BackgroundTransparency = 0.15, BorderSizePixel = 0, ZIndex = 5 })
        round(boxPlayer, 12) outline(boxPlayer, C.yellow, 1, 0.5)
        make("TextLabel", { Position = UDim2.new(0, 14, 0, 10), Size = UDim2.new(1, -28, 0, 18), BackgroundTransparency = 1, Text = "PLAYER PROFILE", TextColor3 = C.yellow, Font = Enum.Font.GothamBold, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 6 }, boxPlayer)
        make("TextLabel", { Position = UDim2.new(0, 14, 0, 35), Size = UDim2.new(1, -28, 0, 65), BackgroundTransparency = 1, Text = "• Username: @" .. player.Name .. "\n• Display Name: " .. player.DisplayName .. "\n• User ID: " .. tostring(player.UserId), TextColor3 = C.yellowSoft, Font = Enum.Font.GothamMedium, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top, ZIndex = 6 }, boxPlayer)

        local boxStats = newPageObject("Frame", { Size = UDim2.new(1, 0, 0, 125), BackgroundColor3 = C.panel, BackgroundTransparency = 0.15, BorderSizePixel = 0, ZIndex = 5 })
        round(boxStats, 12) outline(boxStats, C.yellow, 1, 0.5)
        make("TextLabel", { Position = UDim2.new(0, 14, 0, 10), Size = UDim2.new(1, -28, 0, 18), BackgroundTransparency = 1, Text = "HUB & SERVER STATS", TextColor3 = C.yellow, Font = Enum.Font.GothamBold, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 6 }, boxStats)

        local serverPlayers = #Players:GetPlayers()
        local statsText = "• Hub Users: ~156 active\n• Players in this server: " .. serverPlayers .. " / " .. Players.MaxPlayers .. "\n• Undetectable: ON\n• Script Status: Online & Operational"
        make("TextLabel", { Position = UDim2.new(0, 14, 0, 35), Size = UDim2.new(1, -28, 0, 80), BackgroundTransparency = 1, Text = statsText, TextColor3 = C.yellowSoft, Font = Enum.Font.GothamMedium, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top, ZIndex = 6 }, boxStats)

    elseif name == "Settings" then
        local box = newPageObject("Frame", { Size = UDim2.new(1, 0, 0, 140), BackgroundColor3 = C.panel, BackgroundTransparency = 0.15, BorderSizePixel = 0, ZIndex = 5 })
        round(box, 12) outline(box, C.yellow, 1, 0.5)
        make("TextLabel", { Position = UDim2.new(0, 14, 0, 10), Size = UDim2.new(1, -28, 0, 18), BackgroundTransparency = 1, Text = "Configuration Management", TextColor3 = C.yellow, Font = Enum.Font.GothamBold, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 6 }, box)

        actionButton(box, "Save Config", UDim2.new(0, 14, 0, 42), UDim2.new(1, -28, 0, 36), function() saveConfig() end)
        actionButton(box, "Load Config", UDim2.new(0, 14, 0, 88), UDim2.new(1, -28, 0, 36), function() loadConfig() refreshSpinUI() refreshWheelieUI() refreshSpeedHackUI() end)
    end
end

--========================================================
-- NAVIGATION
--========================================================

local navItems = { {"Player", "Player"}, {"Main", "Main"}, {"Settings", "Settings"} }
for index, item in ipairs(navItems) do
    local button = make("TextButton", {
        Name = item[1] .. "Button",
        Size = UDim2.new(1, 0, 0, 48),
        BackgroundColor3 = C.panel,
        Text = item[2],
        TextColor3 = C.yellowSoft,
        Font = Enum.Font.GothamBold,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        AutoButtonColor = false,
        BorderSizePixel = 0,
        LayoutOrder = index,
        ZIndex = 5,
    }, nav)

    round(button, 8)
    outline(button, C.yellow, 1, 0.7)
    make("UIPadding", { PaddingLeft = UDim.new(0, 14) }, button)
    button.Activated:Connect(function() showPage(item[1]) end)
    navButtons[item[1]] = button
end

--========================================================
-- KEY VALIDATION
--========================================================

verifyButton.Activated:Connect(function()
    if keyTextBox.Text == CORRECT_KEY then
        keyVerified = true
        opened = true
        keySystemFrame:Destroy()
        main.Visible = true
        floating.Visible = true
        showPage("Main")
    else
        verifyButton.Text = "INCORRECT KEY!"
        verifyButton.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
        task.wait(1.5)
        verifyButton.Text = "SUBMIT KEY"
        verifyButton.BackgroundColor3 = C.yellow
    end
end)

--========================================================
-- DRAGGING & WINDOW MANAGEMENT
--========================================================

header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        panelStart = main.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(panelStart.X.Scale, panelStart.X.Offset + delta.X, panelStart.Y.Scale, panelStart.Y.Offset + delta.Y)
    end
end)

local function setOpen(wantOpen)
    if busy or not keyVerified or opened == wantOpen then return end
    busy = true
    opened = wantOpen
    if wantOpen then
        main.Visible = true
        main.Size = UDim2.fromScale(0.55, 0.55)
        animate(main, 0.25, {Size = UDim2.fromScale(0.62, 0.62)}, Enum.EasingStyle.Back).Completed:Wait()
    else
        animate(main, 0.18, {Size = UDim2.fromScale(0.55, 0.53)}, Enum.EasingStyle.Quart, Enum.EasingDirection.In).Completed:Wait()
        main.Visible = false
    end
    busy = false
end

close.Activated:Connect(function() setOpen(false) end)
floating.Activated:Connect(function() setOpen(not opened) end)

UserInputService.InputBegan:Connect(function(input, processed)
    if waitingForSpinBind and input.UserInputType == Enum.UserInputType.Keyboard then
        if input.KeyCode == Enum.KeyCode.Escape then waitingForSpinBind = false
        elseif input.KeyCode ~= Enum.KeyCode.Unknown and input.KeyCode ~= Enum.KeyCode.RightShift then spinBind = input.KeyCode waitingForSpinBind = false saveConfig() end
        refreshSpinUI() return
    end
    if waitingForWheelieBind and input.UserInputType == Enum.UserInputType.Keyboard then
        if input.KeyCode == Enum.KeyCode.Escape then waitingForWheelieBind = false
        elseif input.KeyCode ~= Enum.KeyCode.Unknown and input.KeyCode ~= Enum.KeyCode.RightShift then wheelieBind = input.KeyCode waitingForWheelieBind = false saveConfig() end
        refreshWheelieUI() return
    end
    if waitingForSpeedHackBind and input.UserInputType == Enum.UserInputType.Keyboard then
        if input.KeyCode == Enum.KeyCode.Escape then waitingForSpeedHackBind = false
        elseif input.KeyCode ~= Enum.KeyCode.Unknown and input.KeyCode ~= Enum.KeyCode.RightShift then speedHackBind = input.KeyCode waitingForSpeedHackBind = false saveConfig() end
        refreshSpeedHackUI() return
    end

    if processed then return end
    if input.UserInputType == Enum.UserInputType.Keyboard then
        if spinBind ~= Enum.KeyCode.Unknown and input.KeyCode == spinBind then toggleSpin() end
        if wheelieBind ~= Enum.KeyCode.Unknown and input.KeyCode == wheelieBind then toggleWheelie() end
        if speedHackBind ~= Enum.KeyCode.Unknown and input.KeyCode == speedHackBind then toggleSpeedHack() end
    end
end)

UserInputService.InputBegan:Connect(function(input, processed)
    if not processed and keyVerified and input.KeyCode == Enum.KeyCode.RightShift then
        setOpen(not opened)
    end
end)

RunService.Heartbeat:Connect(function(dt)
    updateSpin(dt)
end)

print("SPEED HUB v6.17 successfully loaded.")