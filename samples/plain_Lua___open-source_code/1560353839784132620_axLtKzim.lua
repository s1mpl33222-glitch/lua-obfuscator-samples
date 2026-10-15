-- loexer hub - Framework
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

if CoreGui:FindFirstChild("LoexerHubUI") then
    CoreGui.LoexerHubUI:Destroy()
end

-- Global Variables
_G.Aimbot = false
_G.AimbotFOVRadius = 100

_G.ESPZombie = false
_G.ESPZombieColor = Color3.fromRGB(0, 170, 255)
_G.Triggerbot = false

_G.Fly = false
_G.FlySpeed = 50
_G.Noclip = false
_G.AutoRetreat = false
_G.LastHealth = 100

_G.AutoMove = false
_G.AutoStrafe = false
_G.StrafeSpeed = 20
_G.AutoJump = false
_G.InfiniteJump = false
_G.SpinBot = false
_G.SpinSpeed = 20
_G.WalkSpeedVal = 16
_G.SpectateTarget = ""
_G.FollowTarget = ""

_G.FastAttack = false
_G.globalTarget = nil

local ToggleKey = Enum.KeyCode.Insert
local CloseKey = Enum.KeyCode.K

local InterFont = Enum.Font.SourceSans
pcall(function() InterFont = Enum.Font.Inter end)

-- ScreenGui
local LoexerHubUI = Instance.new("ScreenGui")
LoexerHubUI.Name = "LoexerHubUI"
LoexerHubUI.ResetOnSpawn = false
LoexerHubUI.Parent = CoreGui

-- Main Panel (714 x 448 px, #111018)
local MainFrame = Instance.new("Frame", LoexerHubUI)
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 714, 0, 448)
MainFrame.Position = UDim2.new(0.5, -357, 0.5, -224)
MainFrame.BackgroundColor3 = Color3.fromHex("#111018")
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.ClipsDescendants = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

-- Left Sidebar
local LeftSide = Instance.new("Frame", MainFrame)
LeftSide.Name = "LeftSide"
LeftSide.Size = UDim2.new(0, 180, 1, 0)
LeftSide.BackgroundColor3 = Color3.fromHex("#141414")
LeftSide.BorderSizePixel = 0
Instance.new("UICorner", LeftSide).CornerRadius = UDim.new(0, 10)

-- Right Content Area (#111018)
local RightSide = Instance.new("Frame", MainFrame)
RightSide.Name = "RightSide"
RightSide.Size = UDim2.new(1, -180, 1, 0)
RightSide.Position = UDim2.new(0, 180, 0, 0)
RightSide.BackgroundColor3 = Color3.fromHex("#111018")
RightSide.BorderSizePixel = 0
Instance.new("UICorner", RightSide).CornerRadius = UDim.new(0, 10)

-- Dragging
local TopBar = Instance.new("Frame", MainFrame)
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 45)
TopBar.BackgroundTransparency = 1
TopBar.ZIndex = 10

local dragging, dragStart, startPos
TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        local targetPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        TweenService:Create(MainFrame, TweenInfo.new(0.05, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Position = targetPos}):Play()
    end
end)

-- Header Logo & Title
local LogoImg = Instance.new("ImageLabel", LeftSide)
LogoImg.Size = UDim2.new(0, 28, 0, 28)
LogoImg.Position = UDim2.new(0, 12, 0, 10)
LogoImg.Image = "rbxassetid://71514816796273"
LogoImg.BackgroundTransparency = 1

local TitleLbl = Instance.new("TextLabel", LeftSide)
TitleLbl.Size = UDim2.new(0, 130, 0, 28)
TitleLbl.Position = UDim2.new(0, 46, 0, 10)
TitleLbl.Text = "loexer hub"
TitleLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLbl.TextSize = 14
TitleLbl.Font = InterFont
TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
TitleLbl.BackgroundTransparency = 1

-- Profile Section
local ProfileFrame = Instance.new("Frame", LeftSide)
ProfileFrame.Size = UDim2.new(1, -16, 0, 45)
ProfileFrame.Position = UDim2.new(0, 8, 1, -50)
ProfileFrame.BackgroundTransparency = 1

local AvatarImg = Instance.new("ImageLabel", ProfileFrame)
AvatarImg.Size = UDim2.new(0, 34, 0, 34)
AvatarImg.Position = UDim2.new(0, 0, 0.5, -17)
AvatarImg.BackgroundTransparency = 1
Instance.new("UICorner", AvatarImg).CornerRadius = UDim.new(1, 0)

task.spawn(function()
    local content = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
    AvatarImg.Image = content
end)

local UserLbl = Instance.new("TextLabel", ProfileFrame)
UserLbl.Size = UDim2.new(1, -40, 0, 16)
UserLbl.Position = UDim2.new(0, 38, 0, 4)
UserLbl.Text = LocalPlayer.DisplayName
UserLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
UserLbl.Font = InterFont
UserLbl.TextSize = 11
UserLbl.TextXAlignment = Enum.TextXAlignment.Left
UserLbl.BackgroundTransparency = 1

local SpecLbl = Instance.new("TextLabel", ProfileFrame)
SpecLbl.Size = UDim2.new(1, -40, 0, 14)
SpecLbl.Position = UDim2.new(0, 38, 0, 20)
SpecLbl.Text = "Special Member"
SpecLbl.TextColor3 = Color3.fromRGB(0, 170, 255)
SpecLbl.Font = InterFont
SpecLbl.TextSize = 10
SpecLbl.TextXAlignment = Enum.TextXAlignment.Left
SpecLbl.BackgroundTransparency = 1

-- Tabs Container
local TabScroll = Instance.new("ScrollingFrame", LeftSide)
TabScroll.Size = UDim2.new(1, -10, 1, -105)
TabScroll.Position = UDim2.new(0, 5, 0, 45)
TabScroll.BackgroundTransparency = 1
TabScroll.ScrollBarThickness = 0

local TabList = Instance.new("UIListLayout", TabScroll)
TabList.SortOrder = Enum.SortOrder.LayoutOrder
TabList.Padding = UDim.new(0, 4)

-- Search Box & Content Area
local SearchBox = Instance.new("TextBox", RightSide)
SearchBox.Size = UDim2.new(1, -20, 0, 26)
SearchBox.Position = UDim2.new(0, 10, 0, 10)
SearchBox.PlaceholderText = "Search..."
SearchBox.Text = ""
SearchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
SearchBox.PlaceholderColor3 = Color3.fromRGB(130, 130, 130)
SearchBox.BackgroundColor3 = Color3.fromHex("#191B2A")
SearchBox.Font = InterFont
SearchBox.TextSize = 12
SearchBox.BorderSizePixel = 0
Instance.new("UICorner", SearchBox).CornerRadius = UDim.new(0, 6)

local ContentArea = Instance.new("Frame", RightSide)
ContentArea.Size = UDim2.new(1, -20, 1, -46)
ContentArea.Position = UDim2.new(0, 10, 0, 40)
ContentArea.BackgroundTransparency = 1

local Tabs = {}

local function CreateTab(name)
    local TabBtn = Instance.new("TextButton", TabScroll)
    TabBtn.Size = UDim2.new(1, 0, 0, 30)
    TabBtn.Text = name
    TabBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
    TabBtn.BackgroundColor3 = Color3.fromHex("#191B2A")
    TabBtn.Font = InterFont
    TabBtn.TextSize = 12
    TabBtn.BorderSizePixel = 0
    TabBtn.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)

    local Page = Instance.new("ScrollingFrame", ContentArea)
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.ScrollBarThickness = 3
    Page.ScrollBarImageColor3 = Color3.fromRGB(0, 170, 255)
    Page.Visible = false

    local PageList = Instance.new("UIListLayout", Page)
    PageList.SortOrder = Enum.SortOrder.LayoutOrder
    PageList.Padding = UDim.new(0, 6)

    PageList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Page.CanvasSize = UDim2.new(0, 0, 0, PageList.AbsoluteContentSize.Y + 10)
    end)

    local tabObj = {Name = name, Btn = TabBtn, Page = Page}

    TabBtn.MouseButton1Click:Connect(function()
        for _, t in pairs(Tabs) do
            t.Page.Visible = false
            t.Btn.BackgroundColor3 = Color3.fromHex("#191B2A")
            t.Btn.TextColor3 = Color3.fromRGB(180, 180, 180)
        end
        Page.Visible = true
        TabBtn.BackgroundColor3 = Color3.fromHex("#25283D")
        TabBtn.TextColor3 = Color3.fromRGB(0, 170, 255)
    end)

    table.insert(Tabs, tabObj)
    return tabObj
end

-- UI Element Creators
local function AddHeader(parent, text)
    local Header = Instance.new("TextLabel", parent)
    Header.Size = UDim2.new(1, 0, 0, 22)
    Header.Text = text
    Header.TextColor3 = Color3.fromRGB(0, 170, 255)
    Header.Font = InterFont
    Header.TextSize = 13
    Header.BackgroundTransparency = 1
    Header.TextXAlignment = Enum.TextXAlignment.Left
    return Header
end

local function AddToggle(parent, text, default, callback)
    local Frame = Instance.new("Frame", parent)
    Frame.Size = UDim2.new(1, -5, 0, 34)
    Frame.BackgroundColor3 = Color3.fromHex("#191B2A")
    Frame.BorderSizePixel = 0
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)

    local Label = Instance.new("TextLabel", Frame)
    Label.Size = UDim2.new(1, -70, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.Font = InterFont
    Label.TextSize = 12
    Label.BackgroundTransparency = 1
    Label.TextXAlignment = Enum.TextXAlignment.Left

    local Track = Instance.new("Frame", Frame)
    Track.Size = UDim2.new(0, 59, 0, 18)
    Track.Position = UDim2.new(1, -65, 0.5, -9)
    Track.BackgroundColor3 = default and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(50, 50, 50)
    Track.BorderSizePixel = 0
    Instance.new("UICorner", Track).CornerRadius = UDim.new(1, 0)

    local Knob = Instance.new("Frame", Track)
    Knob.Size = UDim2.new(0, 20, 0, 11)
    Knob.Position = default and UDim2.new(1, -22, 0.5, -5.5) or UDim2.new(0, 2, 0.5, -5.5)
    Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Knob.BorderSizePixel = 0
    Instance.new("UICorner", Knob).CornerRadius = UDim.new(0, 4)

    local ClickBtn = Instance.new("TextButton", Track)
    ClickBtn.Size = UDim2.new(1, 0, 1, 0)
    ClickBtn.BackgroundTransparency = 1
    ClickBtn.Text = ""

    local state = default
    ClickBtn.MouseButton1Click:Connect(function()
        state = not state
        local targetPos = state and UDim2.new(1, -22, 0.5, -5.5) or UDim2.new(0, 2, 0.5, -5.5)
        local targetColor = state and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(50, 50, 50)

        TweenService:Create(Knob, TweenInfo.new(0.2), {Position = targetPos}):Play()
        TweenService:Create(Track, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
        callback(state)
    end)
end

local function AddSlider(parent, text, minVal, maxVal, defaultVal, callback)
    local Frame = Instance.new("Frame", parent)
    Frame.Size = UDim2.new(1, -5, 0, 40)
    Frame.BackgroundColor3 = Color3.fromHex("#191B2A")
    Frame.BorderSizePixel = 0
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)

    local Label = Instance.new("TextLabel", Frame)
    Label.Size = UDim2.new(1, -60, 0, 18)
    Label.Position = UDim2.new(0, 10, 0, 3)
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.Font = InterFont
    Label.TextSize = 12
    Label.BackgroundTransparency = 1
    Label.TextXAlignment = Enum.TextXAlignment.Left

    local ValLabel = Instance.new("TextLabel", Frame)
    ValLabel.Size = UDim2.new(0, 50, 0, 18)
    ValLabel.Position = UDim2.new(1, -55, 0, 3)
    ValLabel.Text = tostring(defaultVal)
    ValLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    ValLabel.Font = InterFont
    ValLabel.TextSize = 12
    ValLabel.BackgroundTransparency = 1
    ValLabel.TextXAlignment = Enum.TextXAlignment.Right

    local Bar = Instance.new("Frame", Frame)
    Bar.Size = UDim2.new(1, -20, 0, 4)
    Bar.Position = UDim2.new(0, 10, 0, 26)
    Bar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Bar.BorderSizePixel = 0
    Instance.new("UICorner", Bar).CornerRadius = UDim.new(1, 0)

    local Fill = Instance.new("Frame", Bar)
    Fill.Size = UDim2.new((defaultVal - minVal) / (maxVal - minVal), 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    Fill.BorderSizePixel = 0
    Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)

    local Knob = Instance.new("Frame", Bar)
    Knob.Size = UDim2.new(0, 12, 0, 12)
    Knob.Position = UDim2.new((defaultVal - minVal) / (maxVal - minVal), -6, 0.5, -6)
    Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Knob.BorderSizePixel = 0
    Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)

    local sliding = false
    local function Update(input)
        local pos = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
        local val = math.floor(minVal + (maxVal - minVal) * pos)
        Fill.Size = UDim2.new(pos, 0, 1, 0)
        Knob.Position = UDim2.new(pos, -6, 0.5, -6)
        ValLabel.Text = tostring(val)
        callback(val)
    end

    Bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            sliding = true
            Update(input)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            sliding = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            Update(input)
        end
    end)
end

local function AddButton(parent, text, callback)
    local Frame = Instance.new("Frame", parent)
    Frame.Size = UDim2.new(1, -5, 0, 32)
    Frame.BackgroundColor3 = Color3.fromHex("#191B2A")
    Frame.BorderSizePixel = 0
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)

    local Btn = Instance.new("TextButton", Frame)
    Btn.Size = UDim2.new(1, 0, 1, 0)
    Btn.Text = text
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.Font = InterFont
    Btn.TextSize = 12
    Btn.BackgroundTransparency = 1

    Btn.MouseButton1Click:Connect(callback)
end

local function AddTextBox(parent, labelText, placeholder, callback)
    local Frame = Instance.new("Frame", parent)
    Frame.Size = UDim2.new(1, -5, 0, 34)
    Frame.BackgroundColor3 = Color3.fromHex("#191B2A")
    Frame.BorderSizePixel = 0
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)

    local Box = Instance.new("TextBox", Frame)
    Box.Size = UDim2.new(1, -20, 1, 0)
    Box.Position = UDim2.new(0, 10, 0, 0)
    Box.PlaceholderText = labelText .. " (" .. placeholder .. ")"
    Box.Text = ""
    Box.TextColor3 = Color3.fromRGB(255, 255, 255)
    Box.PlaceholderColor3 = Color3.fromRGB(130, 130, 130)
    Box.Font = InterFont
    Box.TextSize = 12
    Box.BackgroundTransparency = 1
    Box.TextXAlignment = Enum.TextXAlignment.Left

    Box.FocusLost:Connect(function(enter)
        if enter then callback(Box.Text) end
    end)
end

-- TABS
local PlayerTab = CreateTab("Player")
local ZombieTab = CreateTab("Zombie")
PlayerTab.Page.Visible = true

-- PLAYER TAB
AddHeader(PlayerTab.Page, "Movement & Mobility")
AddToggle(PlayerTab.Page, "Fly", false, function(s) _G.Fly = s end)
AddSlider(PlayerTab.Page, "Fly Speed", 1, 500, 50, function(v) _G.FlySpeed = v end)
AddToggle(PlayerTab.Page, "Noclip", false, function(s) _G.Noclip = s end)
AddSlider(PlayerTab.Page, "WalkSpeed", 16, 500, 16, function(v) _G.WalkSpeedVal = v end)
AddToggle(PlayerTab.Page, "Auto Move", false, function(s) _G.AutoMove = s end)
AddToggle(PlayerTab.Page, "Auto Strafe", false, function(s) _G.AutoStrafe = s end)
AddSlider(PlayerTab.Page, "Strafe Speed", 1, 100, 20, function(v) _G.StrafeSpeed = v end)

AddHeader(PlayerTab.Page, "Jump & Spin")
AddToggle(PlayerTab.Page, "Auto Jump", false, function(s) _G.AutoJump = s end)
AddToggle(PlayerTab.Page, "Infinite Jump", false, function(s) _G.InfiniteJump = s end)
AddToggle(PlayerTab.Page, "Spin Bot", false, function(s) _G.SpinBot = s end)
AddSlider(PlayerTab.Page, "Spin Speed", 1, 100, 20, function(v) _G.SpinSpeed = v end)

AddHeader(PlayerTab.Page, "Utility Functions")
AddToggle(PlayerTab.Page, "Auto Retreat", false, function(s) _G.AutoRetreat = s end)
AddTextBox(PlayerTab.Page, "Goto / Teleport", "Username", function(targetName)
    for _, p in pairs(Players:GetPlayers()) do
        if p.Name:lower():find(targetName:lower()) and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame
            end
        end
    end
end)
AddTextBox(PlayerTab.Page, "Spectate/View", "Username", function(targetName)
    _G.SpectateTarget = targetName
    for _, p in pairs(Players:GetPlayers()) do
        if p.Name:lower():find(targetName:lower()) and p.Character then
            Workspace.CurrentCamera.CameraSubject = p.Character:FindFirstChildOfClass("Humanoid")
        end
    end
end)
AddTextBox(PlayerTab.Page, "Follow Target", "Username", function(targetName) _G.FollowTarget = targetName end)

AddHeader(PlayerTab.Page, "Quick Actions")
AddButton(PlayerTab.Page, "Fast Respawn", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.Health = 0
    end
end)
AddButton(PlayerTab.Page, "Re-join", function()
    game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
end)

-- ZOMBIE TAB
AddHeader(ZombieTab.Page, "Zombie ESP System")
AddToggle(ZombieTab.Page, "Zombie Wallhack (ESP)", false, function(s) _G.ESPZombie = s end)

AddHeader(ZombieTab.Page, "Combat & Aim")
AddToggle(ZombieTab.Page, "Aimbot (Hold F Key)", false, function(s) _G.Aimbot = s end)
AddSlider(ZombieTab.Page, "FOV Radius", 10, 500, 100, function(v) _G.AimbotFOVRadius = v end)
AddToggle(ZombieTab.Page, "Triggerbot (Auto Click)", false, function(s) _G.Triggerbot = s end)

AddHeader(ZombieTab.Page, "Auto Farm")
AddToggle(ZombieTab.Page, "Fast Attack (Auto Farm)", false, function(s) _G.FastAttack = s end)

-- FOV Circle
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 2
FOVCircle.NumSides = 64
FOVCircle.Radius = _G.AimbotFOVRadius
FOVCircle.Filled = false
FOVCircle.Visible = false
FOVCircle.Color = Color3.fromRGB(0, 170, 255)

-- Toggle Menu Key
UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe then
        if input.KeyCode == ToggleKey or input.KeyCode == CloseKey then
            MainFrame.Visible = not MainFrame.Visible
        end
    end
end)

-- ZOMBIE ESP SYSTEM
local function UpdateZombieESP()
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and obj:FindFirstChildOfClass("Humanoid") and not Players:GetPlayerFromCharacter(obj) then
            local highlight = obj:FindFirstChild("LoexerESP")
            if _G.ESPZombie then
                if not highlight then
                    highlight = Instance.new("Highlight")
                    highlight.Name = "LoexerESP"
                    highlight.Adornee = obj
                    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    highlight.FillColor = _G.ESPZombieColor
                    highlight.FillTransparency = 0.5
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    highlight.OutlineTransparency = 0
                    highlight.Parent = obj
                end
            else
                if highlight then highlight:Destroy() end
            end
        end
    end
end

-- AIMBOT TARGET FINDER
local function GetClosestTarget()
    local closestTarget = nil
    local shortestDistance = _G.AimbotFOVRadius
    local mousePos = UserInputService:GetMouseLocation()

    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and obj:FindFirstChildOfClass("Humanoid") and not Players:GetPlayerFromCharacter(obj) then
            local part = obj:FindFirstChild("Head") or obj:FindFirstChild("HumanoidRootPart")
            if part then
                local screenPos, onScreen = Workspace.CurrentCamera:WorldToViewportPoint(part.Position)
                if onScreen then
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                    if dist < shortestDistance then
                        shortestDistance = dist
                        closestTarget = part
                    end
                end
            end
        end
    end
    return closestTarget
end

-- FAST ATTACK / AUTO FARM LOGIC
local groundDistance = 8
local function getNearest()
    local nearest, dist = nil, 99999
    if Workspace:FindFirstChild("BossFolder") then
        for _, v in pairs(Workspace.BossFolder:GetChildren()) do
            if v:FindFirstChild("Head") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head") then
                local m = (LocalPlayer.Character.Head.Position - v.Head.Position).Magnitude
                if m < dist then
                    dist = m
                    nearest = v
                end
            end
        end
    end
    if Workspace:FindFirstChild("enemies") then
        for _, v in pairs(Workspace.enemies:GetChildren()) do
            if v:FindFirstChild("Head") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head") then
                local m = (LocalPlayer.Character.Head.Position - v.Head.Position).Magnitude
                if m < dist then
                    dist = m
                    nearest = v
                end
            end
        end
    end
    return nearest
end

task.spawn(function()
    while task.wait() do
        if _G.FastAttack and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
            if LocalPlayer.Character:FindFirstChild("Torso") then
                LocalPlayer.Character.Torso.Velocity = Vector3.new(0, 0, 0)
            end
        end
    end
end)

task.spawn(function()
    while task.wait() do
        if _G.FastAttack and _G.globalTarget and _G.globalTarget:FindFirstChild("Head") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool") then
            local target = _G.globalTarget
            if ReplicatedStorage:FindFirstChild("Gun") then
                ReplicatedStorage.Gun:FireServer({
                    ["Normal"] = Vector3.new(0, 0, 0),
                    ["Direction"] = target.Head.Position,
                    ["Name"] = LocalPlayer.Character:FindFirstChildOfClass("Tool").Name,
                    ["Hit"] = target.Head,
                    ["Origin"] = target.Head.Position,
                    ["Pos"] = target.Head.Position,
                })
            end
        end
    end
end)

-- RENDER & MAIN LOOP
RunService.RenderStepped:Connect(function()
    local mouseLoc = UserInputService:GetMouseLocation()
    FOVCircle.Position = mouseLoc
    FOVCircle.Radius = _G.AimbotFOVRadius
    FOVCircle.Visible = _G.Aimbot

    UpdateZombieESP()

    -- FAST ATTACK TARGETING
    if _G.FastAttack and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local target = getNearest()
        if target and target:FindFirstChild("Head") and target:FindFirstChild("HumanoidRootPart") then
            Workspace.CurrentCamera.CFrame = CFrame.new(Workspace.CurrentCamera.CFrame.Position, target.Head.Position)
            LocalPlayer.Character.HumanoidRootPart.CFrame = (target.HumanoidRootPart.CFrame * CFrame.new(0, groundDistance, 9))
            _G.globalTarget = target
        else
            _G.globalTarget = nil
        end
    else
        _G.globalTarget = nil
    end

    -- AIMBOT
    if _G.Aimbot and UserInputService:IsKeyDown(Enum.KeyCode.F) then
        local targetPart = GetClosestTarget()
        if targetPart then
            Workspace.CurrentCamera.CFrame = CFrame.new(Workspace.CurrentCamera.CFrame.Position, targetPart.Position)
        end
    end

    -- TRIGGERBOT
    if _G.Triggerbot then
        local target = Mouse.Target
        if target and target.Parent then
            local parentModel = target.Parent
            if parentModel:FindFirstChildOfClass("Humanoid") and not Players:GetPlayerFromCharacter(parentModel) then
                mouse1click()
            end
        end
    end

    -- FLY
    if _G.Fly and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        local cam = Workspace.CurrentCamera
        local moveDir = Vector3.new()

        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + cam.CFrame.RightVector end

        hrp.Velocity = moveDir * _G.FlySpeed
    end

    -- NOCLIP
    if _G.Noclip and LocalPlayer.Character then
        for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end

    -- AUTO MOVE & SPEED
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        local hum = LocalPlayer.Character.Humanoid
        hum.WalkSpeed = _G.WalkSpeedVal
        if _G.AutoMove then hum:Move(Vector3.new(0, 0, -1), true) end
    end

    -- SPIN BOT
    if _G.SpinBot and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(_G.SpinSpeed), 0)
    end
end)

-- INFINITE JUMP
UserInputService.JumpRequest:Connect(function()
    if _G.InfiniteJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)