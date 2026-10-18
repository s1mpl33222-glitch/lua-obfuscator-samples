local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local HttpService      = game:GetService("HttpService")
local LocalPlayer      = Players.LocalPlayer
local PlayerGui        = LocalPlayer:WaitForChild("PlayerGui")

pcall(function()
    for _, n in ipairs({"Staticc Anti Bat", "Staticc_Anti_Bat", "Cloud.vs Anti Bat", "Cloud_vs_Anti_Bat"}) do
        local old = PlayerGui:FindFirstChild(n)
        if old then old:Destroy() end
    end
end)

local CONFIG_FILE = "Staticc_AntiBat_Config.json"

local AntiBatEnabled        = false
local InfiniteJumpEnabled   = false
local IsJumpingHold         = false
local CurrentKeybind        = Enum.KeyCode.N
local WaitingForKeybind     = false
local CurrentBG             = "rbxassetid://136853450837947"
local minimized             = false

local AntiBatConn    = nil
local AntiRagdollConn = nil
local JumpHoldConn   = nil

local function saveConfig()
    local data = {
        Keybind    = CurrentKeybind.Name,
        Background = CurrentBG,
        AntiBat    = AntiBatEnabled,
        InfJump    = InfiniteJumpEnabled,
    }
    pcall(function()
        writefile(CONFIG_FILE, HttpService:JSONEncode(data))
    end)
end

local function loadConfig()
    local ok, result = pcall(function()
        if isfile and isfile(CONFIG_FILE) then
            return HttpService:JSONDecode(readfile(CONFIG_FILE))
        end
    end)
    if ok and type(result) == "table" then
        if result.Keybind and Enum.KeyCode[result.Keybind] then
            CurrentKeybind = Enum.KeyCode[result.Keybind]
        end
        if result.Background then
            CurrentBG = result.Background
        end
        if result.AntiBat ~= nil then AntiBatEnabled = result.AntiBat == true end
        if result.InfJump ~= nil then
            InfiniteJumpEnabled = result.InfJump == true
        end
    end
end
pcall(loadConfig)

local function startAntiBat()
    local char = LocalPlayer.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    if AntiBatConn then AntiBatConn:Disconnect() end
    AntiBatConn = RunService.Heartbeat:Connect(function()
        if not root or not root.Parent then return end
        local origXZ = Vector3.new(root.Velocity.X, 0, root.Velocity.Z)
        root.Velocity = Vector3.new(1000, root.Velocity.Y, 1000)
        RunService.RenderStepped:Wait()
        if root and root.Parent then
            root.Velocity = Vector3.new(origXZ.X, root.Velocity.Y, origXZ.Z)
        end
    end)
end

local function stopAntiBat()
    if AntiBatConn then
        AntiBatConn:Disconnect()
        AntiBatConn = nil
    end
end

local function startJumpHoldLoop()
    if JumpHoldConn then JumpHoldConn:Disconnect() end
    JumpHoldConn = RunService.Heartbeat:Connect(function()
        if not InfiniteJumpEnabled then return end
        local char = LocalPlayer.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root or not hum then return end
        if IsJumpingHold or hum.Jump then
            root.Velocity = Vector3.new(root.Velocity.X, 55, root.Velocity.Z)
        end
    end)
end

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.Space then
        IsJumpingHold = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Space then
        IsJumpingHold = false
    end
end)

local function startAntiRagdoll()
    if AntiRagdollConn then return end
    AntiRagdollConn = RunService.Heartbeat:Connect(function()
        local char = LocalPlayer.Character
        if not char then return end
        local hum2 = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if hum2 then
            local st = hum2:GetState()
            if st == Enum.HumanoidStateType.Physics
                or st == Enum.HumanoidStateType.Ragdoll
                or st == Enum.HumanoidStateType.FallingDown then
                hum2:ChangeState(Enum.HumanoidStateType.Running)
                workspace.CurrentCamera.CameraSubject = hum2
                pcall(function()
                    local pm = LocalPlayer.PlayerScripts:FindFirstChild("PlayerModule")
                    if pm then
                        local cm = pm:FindFirstChild("ControlModule")
                        if cm then require(cm):Enable() end
                    end
                end)
                if root then
                    root.Velocity = Vector3.new(0, 0, 0)
                    root.RotVelocity = Vector3.new(0, 0, 0)
                end
            end
        end
        for _, obj in ipairs(char:GetDescendants()) do
            if obj:IsA("Motor6D") and not obj.Enabled then
                obj.Enabled = true
            end
        end
    end)
end

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.3)
    if AntiBatEnabled then startAntiBat() end
    task.wait(0.5)
    startAntiRagdoll()
end)

-- ================== UI ==================

local Staticc_Anti_Bat = Instance.new("ScreenGui")
Staticc_Anti_Bat.Name = "Staticc Anti Bat"
Staticc_Anti_Bat.IgnoreGuiInset = true
Staticc_Anti_Bat.ResetOnSpawn = false
Staticc_Anti_Bat.DisplayOrder = 10
Staticc_Anti_Bat.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Staticc_Anti_Bat.Parent = PlayerGui

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Active = true
Main.ClipsDescendants = true
Main.Position = UDim2.new(0.5, -140, 0.5, -132)
Main.Size = UDim2.new(0, 280, 0, 265) -- Altura aumentada para caber o Keybind!
Main.BackgroundColor3 = Color3.fromRGB(10, 0, 0)
Main.BorderSizePixel = 0
Main.Parent = Staticc_Anti_Bat

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 16)
MainCorner.Parent = Main

local MainGradient = Instance.new("UIGradient")
MainGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0.00, Color3.fromRGB(90, 0, 0)),
    ColorSequenceKeypoint.new(0.45, Color3.fromRGB(35, 0, 0)),
    ColorSequenceKeypoint.new(1.00, Color3.fromRGB(0, 0, 0)),
}
MainGradient.Rotation = 135
MainGradient.Parent = Main

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(200, 20, 20)
MainStroke.Thickness = 1.4
MainStroke.Transparency = 0.15
MainStroke.Parent = Main

local SpaceBackground = Instance.new("ImageLabel")
SpaceBackground.Name = "SpaceBackground"
SpaceBackground.ZIndex = 0
SpaceBackground.Size = UDim2.new(1, 0, 1, 0)
SpaceBackground.BackgroundTransparency = 1
SpaceBackground.Image = CurrentBG
SpaceBackground.ImageTransparency = 0
SpaceBackground.ScaleType = Enum.ScaleType.Crop
SpaceBackground.Parent = Main
Instance.new("UICorner", SpaceBackground).CornerRadius = UDim.new(0, 16)

local RedOverlay = Instance.new("Frame")
RedOverlay.Name = "RedOverlay"
RedOverlay.ZIndex = 1
RedOverlay.Size = UDim2.new(1, 0, 1, 0)
RedOverlay.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
RedOverlay.BackgroundTransparency = 0.75
RedOverlay.BorderSizePixel = 0
RedOverlay.Parent = Main
Instance.new("UICorner", RedOverlay).CornerRadius = UDim.new(0, 16)

local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Active = true
Header.ZIndex = 2
Header.Size = UDim2.new(1, 0, 0, 50)
Header.BackgroundTransparency = 1
Header.Parent = Main

local HeaderIcon = Instance.new("Frame")
HeaderIcon.Name = "HeaderIcon"
HeaderIcon.ZIndex = 5
HeaderIcon.Position = UDim2.new(0, 16, 0.5, -5)
HeaderIcon.Size = UDim2.new(0, 10, 0, 10)
HeaderIcon.BackgroundColor3 = Color3.fromRGB(255, 40, 40)
HeaderIcon.BorderSizePixel = 0
HeaderIcon.Parent = Header
Instance.new("UICorner", HeaderIcon).CornerRadius = UDim.new(1, 0)

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.ZIndex = 5
Title.Position = UDim2.new(0, 36, 0, 7)
Title.Size = UDim2.new(1, -140, 0, 18)
Title.BackgroundTransparency = 1
Title.Text = "STATICC ANTI BAT"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 15
Title.Font = Enum.Font.GothamBlack
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local SubTitle = Instance.new("TextLabel")
SubTitle.Name = "SubTitle"
SubTitle.ZIndex = 5
SubTitle.Position = UDim2.new(0, 36, 0, 27)
SubTitle.Size = UDim2.new(1, -140, 0, 14)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "discord.gg/Z9rMHYEmPC"
SubTitle.TextColor3 = Color3.fromRGB(220, 170, 170)
SubTitle.TextSize = 10
SubTitle.Font = Enum.Font.Gotham
SubTitle.TextXAlignment = Enum.TextXAlignment.Left
SubTitle.Parent = Header

local BgBtn = Instance.new("TextButton")
BgBtn.Name = "BgBtn"
BgBtn.ZIndex = 5
BgBtn.AnchorPoint = Vector2.new(1, 0.5)
BgBtn.Position = UDim2.new(1, -62, 0.5, 0)
BgBtn.Size = UDim2.new(0, 44, 0, 22)
BgBtn.BackgroundColor3 = Color3.fromRGB(45, 0, 0)
BgBtn.BackgroundTransparency = 0.1
BgBtn.Text = "BG"
BgBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
BgBtn.TextSize = 10
BgBtn.Font = Enum.Font.GothamBlack
BgBtn.AutoButtonColor = false
BgBtn.Parent = Header
Instance.new("UICorner", BgBtn).CornerRadius = UDim.new(0, 8)
local BgStroke = Instance.new("UIStroke")
BgStroke.Color = Color3.fromRGB(220, 30, 30)
BgStroke.Transparency = 0.2
BgStroke.Parent = BgBtn

local MinBtn = Instance.new("TextButton")
MinBtn.Name = "MinBtn"
MinBtn.ZIndex = 5
MinBtn.AnchorPoint = Vector2.new(1, 0.5)
MinBtn.Position = UDim2.new(1, -12, 0.5, 0)
MinBtn.Size = UDim2.new(0, 24, 0, 24)
MinBtn.BackgroundColor3 = Color3.fromRGB(35, 0, 0)
MinBtn.BackgroundTransparency = 0.3
MinBtn.Text = "-"
MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinBtn.TextSize = 16
MinBtn.Font = Enum.Font.GothamBlack
MinBtn.AutoButtonColor = false
MinBtn.Parent = Header
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 8)
local MinStroke = Instance.new("UIStroke")
MinStroke.Color = Color3.fromRGB(200, 25, 25)
MinStroke.Transparency = 0.3
MinStroke.Parent = MinBtn

local ContentHolder = Instance.new("Frame")
ContentHolder.Name = "ContentHolder"
ContentHolder.ZIndex = 2
ContentHolder.ClipsDescendants = true
ContentHolder.Position = UDim2.new(0, 0, 0, 50)
ContentHolder.Size = UDim2.new(1, 0, 1, -50)
ContentHolder.BackgroundTransparency = 1
ContentHolder.Parent = Main

local Content = Instance.new("Frame")
Content.Name = "Content"
Content.ZIndex = 2
Content.Size = UDim2.new(1, 0, 1, 0)
Content.BackgroundTransparency = 1
Content.Parent = ContentHolder

local StatusRow = Instance.new("Frame")
StatusRow.Name = "StatusRow"
StatusRow.ZIndex = 4
StatusRow.Position = UDim2.new(0, 12, 0, 6)
StatusRow.Size = UDim2.new(1, -24, 0, 34)
StatusRow.BackgroundColor3 = Color3.fromRGB(25, 0, 0)
StatusRow.BackgroundTransparency = 0.25
StatusRow.Parent = Content
Instance.new("UICorner", StatusRow).CornerRadius = UDim.new(0, 12)

local StatusGradient = Instance.new("UIGradient")
StatusGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(60, 0, 0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)),
}
StatusGradient.Rotation = 90
StatusGradient.Parent = StatusRow

local StatusDot = Instance.new("Frame")
StatusDot.Name = "StatusDot"
StatusDot.ZIndex = 6
StatusDot.Position = UDim2.new(0, 14, 0.5, -4)
StatusDot.Size = UDim2.new(0, 8, 0, 8)
StatusDot.BackgroundColor3 = Color3.fromRGB(255, 70, 90)
StatusDot.BorderSizePixel = 0
StatusDot.Parent = StatusRow
Instance.new("UICorner", StatusDot).CornerRadius = UDim.new(1, 0)

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Name = "StatusLabel"
StatusLabel.ZIndex = 6
StatusLabel.Position = UDim2.new(0, 30, 0, 0)
StatusLabel.Size = UDim2.new(0, 100, 1, 0)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Status"
StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
StatusLabel.TextSize = 13
StatusLabel.Font = Enum.Font.GothamBlack
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.Parent = StatusRow

local StatusValue = Instance.new("TextLabel")
StatusValue.Name = "StatusValue"
StatusValue.ZIndex = 6
StatusValue.Position = UDim2.new(1, -114, 0, 0)
StatusValue.Size = UDim2.new(0, 100, 1, 0)
StatusValue.BackgroundTransparency = 1
StatusValue.Text = "INACTIVE"
StatusValue.TextColor3 = Color3.fromRGB(255, 70, 90)
StatusValue.TextSize = 14
StatusValue.Font = Enum.Font.GothamBlack
StatusValue.TextXAlignment = Enum.TextXAlignment.Right
StatusValue.Parent = StatusRow

local function makeRow(name, yPos, labelText)
    local row = Instance.new("Frame")
    row.Name = name
    row.ZIndex = 4
    row.Position = UDim2.new(0, 12, 0, yPos)
    row.Size = UDim2.new(1, -24, 0, 52)
    row.BackgroundColor3 = Color3.fromRGB(25, 0, 0)
    row.BackgroundTransparency = 0.25
    row.Parent = Content
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 12)

    local g = Instance.new("UIGradient")
    g.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(55, 0, 0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)),
    }
    g.Rotation = 90
    g.Parent = row

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(180, 20, 20)
    stroke.Transparency = 0.55
    stroke.Thickness = 1
    stroke.Parent = row

    local label = Instance.new("TextLabel")
    label.Name = name .. "Label"
    label.ZIndex = 6
    label.Position = UDim2.new(0, 14, 0.5, -9)
    label.Size = UDim2.new(0, 170, 0, 18)
    label.BackgroundTransparency = 1
    label.Text = labelText
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 14
    label.Font = Enum.Font.GothamBlack
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = row

    local toggleBg = Instance.new("Frame")
    toggleBg.Name = name .. "ToggleBg"
    toggleBg.ZIndex = 6
    toggleBg.Position = UDim2.new(1, -58, 0.5, -11)
    toggleBg.Size = UDim2.new(0, 44, 0, 22)
    toggleBg.BackgroundColor3 = Color3.fromRGB(52, 52, 58)
    toggleBg.BorderSizePixel = 0
    toggleBg.Parent = row
    Instance.new("UICorner", toggleBg).CornerRadius = UDim.new(1, 0)

    local toggleDot = Instance.new("Frame")
    toggleDot.Name = name .. "ToggleDot"
    toggleDot.ZIndex = 7
    toggleDot.Position = UDim2.new(0, 3, 0.5, -8)
    toggleDot.Size = UDim2.new(0, 16, 0, 16)
    toggleDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    toggleDot.BorderSizePixel = 0
    toggleDot.Parent = toggleBg
    Instance.new("UICorner", toggleDot).CornerRadius = UDim.new(1, 0)

    local click = Instance.new("TextButton")
    click.Name = name .. "Click"
    click.ZIndex = 10
    click.Position = UDim2.new(1, -65, 0, 0)
    click.Size = UDim2.new(0, 50, 0, 52)
    click.BackgroundTransparency = 1
    click.Text = ""
    click.Parent = row

    return row, toggleBg, toggleDot, click
end

local AntiBatRow, ToggleBg, ToggleDot, AntiBatClick = makeRow("AntiBatRow", 48, "Anti Bat")
local InfJumpRow, InfToggleBg, InfToggleDot, InfJumpClick = makeRow("InfJumpRow", 106, "Inf Jump")

local KeybindRow = Instance.new("Frame")
KeybindRow.Name = "KeybindRow"
KeybindRow.ZIndex = 4
KeybindRow.Position = UDim2.new(0, 12, 0, 164)
KeybindRow.Size = UDim2.new(1, -24, 0, 34)
KeybindRow.BackgroundColor3 = Color3.fromRGB(25, 0, 0)
KeybindRow.BackgroundTransparency = 0.25
KeybindRow.Parent = Content
Instance.new("UICorner", KeybindRow).CornerRadius = UDim.new(0, 12)

local KBGradient = Instance.new("UIGradient")
KBGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(55, 0, 0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)),
}
KBGradient.Rotation = 90
KBGradient.Parent = KeybindRow

local KeybindLabel = Instance.new("TextLabel")
KeybindLabel.Name = "KeybindLabel"
KeybindLabel.ZIndex = 6
KeybindLabel.Position = UDim2.new(0, 14, 0, 0)
KeybindLabel.Size = UDim2.new(0, 80, 1, 0)
KeybindLabel.BackgroundTransparency = 1
KeybindLabel.Text = "Keybind"
KeybindLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
KeybindLabel.TextSize = 12
KeybindLabel.Font = Enum.Font.GothamBlack
KeybindLabel.TextXAlignment = Enum.TextXAlignment.Left
KeybindLabel.Parent = KeybindRow

local KeybindBtn = Instance.new("TextButton")
KeybindBtn.Name = "KeybindBtn"
KeybindBtn.ZIndex = 10
KeybindBtn.AnchorPoint = Vector2.new(1, 0.5)
KeybindBtn.Position = UDim2.new(1, -14, 0.5, 0)
KeybindBtn.Size = UDim2.new(0, 54, 0, 22)
KeybindBtn.BackgroundColor3 = Color3.fromRGB(45, 0, 0)
KeybindBtn.BackgroundTransparency = 0.2
KeybindBtn.Text = CurrentKeybind.Name
KeybindBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
KeybindBtn.TextSize = 12
KeybindBtn.Font = Enum.Font.GothamBlack
KeybindBtn.AutoButtonColor = false
KeybindBtn.Parent = KeybindRow
Instance.new("UICorner", KeybindBtn).CornerRadius = UDim.new(0, 8)
local KBStroke = Instance.new("UIStroke")
KBStroke.Color = Color3.fromRGB(220, 30, 30)
KBStroke.Transparency = 0.3
KBStroke.Parent = KeybindBtn

-- ================== SELETOR DE BACKGROUND ==================

local BackgroundPicker = Instance.new("Frame")
BackgroundPicker.Name = "BackgroundPicker"
BackgroundPicker.Visible = false
BackgroundPicker.ZIndex = 20
BackgroundPicker.AnchorPoint = Vector2.new(0.5, 0.5)
BackgroundPicker.Position = UDim2.new(0.5, 0, 0.5, 0)
BackgroundPicker.Size = UDim2.new(0, 270, 0, 240)
BackgroundPicker.BackgroundColor3 = Color3.fromRGB(10, 0, 0)
BackgroundPicker.BorderSizePixel = 0
BackgroundPicker.Parent = Staticc_Anti_Bat
Instance.new("UICorner", BackgroundPicker).CornerRadius = UDim.new(0, 16)

local BPGradient = Instance.new("UIGradient")
BPGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(70, 0, 0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)),
}
BPGradient.Rotation = 135
BPGradient.Parent = BackgroundPicker

local BPStroke = Instance.new("UIStroke")
BPStroke.Color = Color3.fromRGB(210, 25, 25)
BPStroke.Thickness = 1.4
BPStroke.Transparency = 0.15
BPStroke.Parent = BackgroundPicker

local Header2 = Instance.new("Frame")
Header2.Name = "Header"
Header2.ZIndex = 21
Header2.Size = UDim2.new(1, 0, 0, 38)
Header2.BackgroundColor3 = Color3.fromRGB(20, 0, 0)
Header2.BackgroundTransparency = 0.15
Header2.BorderSizePixel = 0
Header2.Parent = BackgroundPicker
Instance.new("UICorner", Header2).CornerRadius = UDim.new(0, 16)

local BPTitle = Instance.new("TextLabel")
BPTitle.ZIndex = 22
BPTitle.Position = UDim2.new(0, 14, 0, 0)
BPTitle.Size = UDim2.new(1, -54, 1, 0)
BPTitle.BackgroundTransparency = 1
BPTitle.Text = "Change Background"
BPTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
BPTitle.TextSize = 16
BPTitle.Font = Enum.Font.GothamBlack
BPTitle.TextXAlignment = Enum.TextXAlignment.Left
BPTitle.Parent = Header2

local Close = Instance.new("TextButton")
Close.Name = "Close"
Close.ZIndex = 22
Close.AnchorPoint = Vector2.new(1, 0.5)
Close.Position = UDim2.new(1, -12, 0.5, 0)
Close.Size = UDim2.new(0, 28, 0, 25)
Close.BackgroundColor3 = Color3.fromRGB(35, 0, 0)
Close.BackgroundTransparency = 0.1
Close.Text = "×"
Close.TextColor3 = Color3.fromRGB(255, 255, 255)
Close.TextSize = 18
Close.Font = Enum.Font.GothamBlack
Close.AutoButtonColor = false
Close.Parent = Header2
Instance.new("UICorner", Close).CornerRadius = UDim.new(0, 8)

local BackgroundGrid = Instance.new("Frame")
BackgroundGrid.Name = "BackgroundGrid"
BackgroundGrid.ZIndex = 21
BackgroundGrid.Position = UDim2.new(0, 12, 0, 48)
BackgroundGrid.Size = UDim2.new(1, -24, 1, -60)
BackgroundGrid.BackgroundTransparency = 1
BackgroundGrid.Parent = BackgroundPicker

local UIGridLayout = Instance.new("UIGridLayout")
UIGridLayout.CellPadding = UDim2.new(0, 8, 0, 8)
UIGridLayout.CellSize = UDim2.new(0, 76, 0, 76)
UIGridLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIGridLayout.FillDirectionMaxCells = 3
UIGridLayout.Parent = BackgroundGrid

local bgIds = {
    {name = "NONE", id = ""},
    {name = "1", id = "rbxassetid://136853450837947"},
    {name = "2", id = "rbxassetid://112613824816084"},
    {name = "3", id = "rbxassetid://102836957979461"},
    {name = "4", id = "rbxassetid://91719185010760"},
}

local function applyBackground(id)
    if id == "" then
        TweenService:Create(Main, TweenInfo.new(0.3), {BackgroundTransparency = 0.5}):Play()
        TweenService:Create(RedOverlay, TweenInfo.new(0.3), {BackgroundTransparency = 0.5}):Play()
        SpaceBackground.ImageTransparency = 1
    else
        TweenService:Create(Main, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
        TweenService:Create(RedOverlay, TweenInfo.new(0.3), {BackgroundTransparency = 0.75}):Play()
        SpaceBackground.ImageTransparency = 0
        SpaceBackground.Image = id
    end
end

for i, data in ipairs(bgIds) do
    local btn = Instance.new("TextButton")
    btn.ZIndex = 22
    btn.LayoutOrder = i
    btn.BackgroundColor3 = Color3.fromRGB(15, 0, 0)
    btn.BackgroundTransparency = 0.1
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.Parent = BackgroundGrid
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)
    
    local s = Instance.new("UIStroke")
    s.Color = Color3.fromRGB(200, 25, 25)
    s.Transparency = 0.1
    s.Parent = btn

    if data.name == "NONE" then
        btn.Text = "NONE"
        btn.TextColor3 = Color3.fromRGB(255, 100, 100)
        btn.Font = Enum.Font.GothamBlack
        btn.TextSize = 14
        btn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        btn.BackgroundTransparency = 0.3
    else
        local img = Instance.new("ImageLabel")
        img.ZIndex = 22
        img.Size = UDim2.new(1, 0, 1, 0)
        img.BackgroundTransparency = 1
        img.Image = data.id
        img.ScaleType = Enum.ScaleType.Crop
        img.Parent = btn
        Instance.new("UICorner", img).CornerRadius = UDim.new(0, 10)
    end

    btn.MouseButton1Click:Connect(function()
        CurrentBG = data.id
        applyBackground(data.id)
        BackgroundPicker.Visible = false
        saveConfig()
    end)
end

local function setToggle(knob, bg, enabled)
    TweenService:Create(knob, TweenInfo.new(0.15), {
        Position = enabled and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    }):Play()
    TweenService:Create(bg, TweenInfo.new(0.15), {
        BackgroundColor3 = enabled and Color3.fromRGB(200, 20, 20) or Color3.fromRGB(52, 52, 58),
    }):Play()
end

local function updateStatus()
    local anyOn = AntiBatEnabled or InfiniteJumpEnabled
    if anyOn then
        StatusValue.Text = "ACTIVE"
        StatusValue.TextColor3 = Color3.fromRGB(255, 90, 90)
        StatusDot.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    else
        StatusValue.Text = "INACTIVE"
        StatusValue.TextColor3 = Color3.fromRGB(255, 70, 90)
        StatusDot.BackgroundColor3 = Color3.fromRGB(255, 70, 90)
    end
end

local function setAntiBat(on)
    AntiBatEnabled = on == true
    if AntiBatEnabled then
        startAntiBat()
    else
        stopAntiBat()
    end
    setToggle(ToggleDot, ToggleBg, AntiBatEnabled)
    updateStatus()
    saveConfig()
end

local function setInfJump(on)
    InfiniteJumpEnabled = on == true
    if not InfiniteJumpEnabled then IsJumpingHold = false end
    setToggle(InfToggleDot, InfToggleBg, InfiniteJumpEnabled)
    updateStatus()
    saveConfig()
end

AntiBatClick.MouseButton1Click:Connect(function()
    setAntiBat(not AntiBatEnabled)
end)

InfJumpClick.MouseButton1Click:Connect(function()
    setInfJump(not InfiniteJumpEnabled)
end)

KeybindBtn.MouseButton1Click:Connect(function()
    if WaitingForKeybind then return end
    WaitingForKeybind = true
    KeybindBtn.Text = "..."
    KeybindBtn.TextColor3 = Color3.fromRGB(255, 200, 100)
end)

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if WaitingForKeybind then
        if input.UserInputType == Enum.UserInputType.Keyboard then
            CurrentKeybind = input.KeyCode
            WaitingForKeybind = false
            KeybindBtn.Text = CurrentKeybind.Name
            KeybindBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            saveConfig()
        end
        return
    end
    if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == CurrentKeybind then
        setAntiBat(not AntiBatEnabled)
    end
end)

BgBtn.MouseButton1Click:Connect(function()
    BackgroundPicker.Visible = not BackgroundPicker.Visible
end)

Close.MouseButton1Click:Connect(function()
    BackgroundPicker.Visible = false
end)

MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        ContentHolder.Visible = false
        BgBtn.Visible = false
        BackgroundPicker.Visible = false
        Main.Size = UDim2.new(0, 280, 0, 50)
        MinBtn.Text = "+"
    else
        ContentHolder.Visible = true
        BgBtn.Visible = true
        Main.Size = UDim2.new(0, 280, 0, 265) -- Altura ajustada novamente
        MinBtn.Text = "-"
    end
end)

local dragging, dragStart, startPos
Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Main.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

startAntiRagdoll()
startJumpHoldLoop()
setToggle(ToggleDot, ToggleBg, AntiBatEnabled)
setToggle(InfToggleDot, InfToggleBg, InfiniteJumpEnabled)
updateStatus()
if AntiBatEnabled then startAntiBat() end
KeybindBtn.Text = CurrentKeybind.Name
applyBackground(CurrentBG)