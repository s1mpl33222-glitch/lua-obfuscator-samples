--[[ 
    ELSINIO V1.02 - COMPLETE FEATURES RESTORED
--]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Camera = Workspace.CurrentCamera

-- Key Configuration
local CORRECT_KEY = "A"

-- Linisin ang lumang GUI
if PlayerGui:FindFirstChild("ElSinioGUI") then
    PlayerGui.ElSinioGUI:Destroy()
end

-- ScreenGui Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ElSinioGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- Table para sa active border strokes (Color Customizer)
local activeStrokes = {}

local function updateBorderColors(newColor)
    for _, stroke in ipairs(activeStrokes) do
        if stroke and stroke.Parent then
            stroke.Color = newColor
        end
    end
end

----------------------------------------------------
-- KEY SYSTEM FRAME
----------------------------------------------------
local KeyFrame = Instance.new("Frame")
KeyFrame.Name = "KeyFrame"
KeyFrame.Size = UDim2.new(0, 360, 0, 200)
KeyFrame.Position = UDim2.new(0.5, -180, 0.5, -100)
KeyFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
KeyFrame.BorderSizePixel = 0
KeyFrame.Active = true
KeyFrame.Draggable = true
KeyFrame.Parent = ScreenGui

local KeyStroke = Instance.new("UIStroke")
KeyStroke.Thickness = 2
KeyStroke.Color = Color3.fromRGB(255, 255, 255)
KeyStroke.Parent = KeyFrame
table.insert(activeStrokes, KeyStroke)

local KeyTitleBar = Instance.new("Frame")
KeyTitleBar.Size = UDim2.new(1, 0, 0, 30)
KeyTitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
KeyTitleBar.BorderSizePixel = 0
KeyTitleBar.Parent = KeyFrame

local KeyTitleText = Instance.new("TextLabel")
KeyTitleText.Size = UDim2.new(1, -35, 1, 0)
KeyTitleText.Position = UDim2.new(0, 10, 0, 0)
KeyTitleText.BackgroundTransparency = 1
KeyTitleText.TextColor3 = Color3.fromRGB(255, 30, 30)
KeyTitleText.TextSize = 14
KeyTitleText.Font = Enum.Font.GothamBlack
KeyTitleText.TextXAlignment = Enum.TextXAlignment.Left
KeyTitleText.Text = "ELSINIO - KEY SYSTEM"
KeyTitleText.Parent = KeyTitleBar

local KeyLabel = Instance.new("TextLabel")
KeyLabel.Size = UDim2.new(1, -20, 0, 25)
KeyLabel.Position = UDim2.new(0, 10, 0, 40)
KeyLabel.BackgroundTransparency = 1
KeyLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
KeyLabel.TextSize = 13
KeyLabel.Font = Enum.Font.GothamBold
KeyLabel.Text = "ENTER KEY TO ACCESS GUI:"
KeyLabel.Parent = KeyFrame

local KeyInput = Instance.new("TextBox")
KeyInput.Size = UDim2.new(1, -40, 0, 35)
KeyInput.Position = UDim2.new(0, 20, 0, 75)
KeyInput.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyInput.TextSize = 14
KeyInput.Font = Enum.Font.GothamMedium
KeyInput.PlaceholderText = "Enter key here..."
KeyInput.Text = ""
KeyInput.Parent = KeyFrame

local KeyInputCorner = Instance.new("UICorner")
KeyInputCorner.CornerRadius = UDim.new(0, 6)
KeyInputCorner.Parent = KeyInput

local SubmitBtn = Instance.new("TextButton")
SubmitBtn.Size = UDim2.new(1, -40, 0, 35)
SubmitBtn.Position = UDim2.new(0, 20, 0, 125)
SubmitBtn.BackgroundColor3 = Color3.fromRGB(220, 30, 30)
SubmitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SubmitBtn.TextSize = 14
SubmitBtn.Font = Enum.Font.GothamBold
SubmitBtn.Text = "VERIFY KEY"
SubmitBtn.Parent = KeyFrame

local SubmitCorner = Instance.new("UICorner")
SubmitCorner.CornerRadius = UDim.new(0, 6)
SubmitCorner.Parent = SubmitBtn

local StatusText = Instance.new("TextLabel")
StatusText.Size = UDim2.new(1, -20, 0, 20)
StatusText.Position = UDim2.new(0, 10, 0, 168)
StatusText.BackgroundTransparency = 1
StatusText.TextColor3 = Color3.fromRGB(200, 200, 200)
StatusText.TextSize = 11
StatusText.Font = Enum.Font.SourceSans
StatusText.Text = ""
StatusText.Parent = KeyFrame

----------------------------------------------------
-- MAIN CONTAINER FRAME SETUP
----------------------------------------------------
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 520, 0, 360)
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -180)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = false
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

-- Falling Particles Container
local ParticleContainer = Instance.new("Frame")
ParticleContainer.Name = "ParticleContainer"
ParticleContainer.Size = UDim2.new(1, 0, 1, 0)
ParticleContainer.BackgroundTransparency = 1
ParticleContainer.ZIndex = 5
ParticleContainer.Parent = MainFrame

task.spawn(function()
    while MainFrame and MainFrame.Parent do
        task.wait(0.15)
        if MainFrame.Visible then
            local particle = Instance.new("Frame")
            particle.Size = UDim2.new(0, math.random(3, 5), 0, math.random(3, 5))
            particle.Position = UDim2.new(math.random(), 0, 0, -10)
            particle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            particle.BorderSizePixel = 0
            particle.BackgroundTransparency = math.random(2, 5) / 10
            particle.ZIndex = 6
            particle.Parent = ParticleContainer

            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(1, 0)
            corner.Parent = particle

            local fallSpeed = math.random(3, 5)
            local tweenInfo = TweenInfo.new(fallSpeed, Enum.EasingStyle.Linear)
            local tween = TweenService:Create(particle, tweenInfo, {
                Position = UDim2.new(particle.Position.X.Scale, math.random(-10, 10) / 100, 1.1, 0),
                BackgroundTransparency = 1
            })
            tween:Play()
            tween.Completed:Connect(function()
                particle:Destroy()
            end)
        end
    end
end)

local MainStroke = Instance.new("UIStroke")
MainStroke.Thickness = 2
MainStroke.Color = Color3.fromRGB(255, 255, 255)
MainStroke.Parent = MainFrame
table.insert(activeStrokes, MainStroke)

SubmitBtn.MouseButton1Click:Connect(function()
    if KeyInput.Text == CORRECT_KEY then
        StatusText.TextColor3 = Color3.fromRGB(46, 204, 113)
        StatusText.Text = "KEY CORRECT! ACCESS GRANTED."
        task.wait(0.5)
        KeyFrame:Destroy()
        MainFrame.Visible = true
    else
        StatusText.TextColor3 = Color3.fromRGB(231, 76, 60)
        StatusText.Text = "WRONG KEY! PLEASE TRY AGAIN."
    end
end)

-- Title Bar Header
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 30)
TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TitleBar.BorderSizePixel = 0
TitleBar.ZIndex = 10
TitleBar.Parent = MainFrame

local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(1, -35, 1, 0)
TitleText.Position = UDim2.new(0, 10, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.TextColor3 = Color3.fromRGB(255, 30, 30)
TitleText.TextSize = 13
TitleText.Font = Enum.Font.GothamBlack
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Text = "ELSINIO V1.02 MAIN CHEAT"
TitleText.ZIndex = 10
TitleText.Parent = TitleBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -30, 0, 0)
CloseBtn.BackgroundTransparency = 1
CloseBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
CloseBtn.TextSize = 16
CloseBtn.Font = Enum.Font.GothamBlack
CloseBtn.Text = "X"
CloseBtn.ZIndex = 10
CloseBtn.Parent = TitleBar

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Left Sidebar
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 170, 1, -30)
Sidebar.Position = UDim2.new(0, 0, 0, 30)
Sidebar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Sidebar.BorderSizePixel = 0
Sidebar.ZIndex = 7
Sidebar.Parent = MainFrame

local ProfileFrame = Instance.new("Frame")
ProfileFrame.Size = UDim2.new(1, 0, 0, 50)
ProfileFrame.BackgroundTransparency = 1
ProfileFrame.ZIndex = 7
ProfileFrame.Parent = Sidebar

local UsernameLabel = Instance.new("TextLabel")
UsernameLabel.Size = UDim2.new(1, -10, 0, 20)
UsernameLabel.Position = UDim2.new(0, 10, 0, 8)
UsernameLabel.BackgroundTransparency = 1
UsernameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
UsernameLabel.TextSize = 14
UsernameLabel.Font = Enum.Font.GothamBold
UsernameLabel.TextXAlignment = Enum.TextXAlignment.Left
UsernameLabel.Text = LocalPlayer.Name
UsernameLabel.ZIndex = 7
UsernameLabel.Parent = ProfileFrame

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, -10, 0, 15)
StatusLabel.Position = UDim2.new(0, 10, 0, 28)
StatusLabel.BackgroundTransparency = 1
StatusLabel.TextColor3 = Color3.fromRGB(46, 204, 113)
StatusLabel.TextSize = 12
StatusLabel.Font = Enum.Font.SourceSans
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.Text = "● Online"
StatusLabel.ZIndex = 7
StatusLabel.Parent = ProfileFrame

local SidebarScroll = Instance.new("ScrollingFrame")
SidebarScroll.Size = UDim2.new(1, 0, 1, -50)
SidebarScroll.Position = UDim2.new(0, 0, 0, 50)
SidebarScroll.BackgroundTransparency = 1
SidebarScroll.BorderSizePixel = 0
SidebarScroll.CanvasSize = UDim2.new(0, 0, 0, 250)
SidebarScroll.ScrollBarThickness = 2
SidebarScroll.ZIndex = 7
SidebarScroll.Parent = Sidebar

local SidebarList = Instance.new("UIListLayout")
SidebarList.SortOrder = Enum.SortOrder.LayoutOrder
SidebarList.Padding = UDim.new(0, 2)
SidebarList.Parent = SidebarScroll

-- Pages Container
local PagesContainer = Instance.new("Folder")
PagesContainer.Name = "PagesContainer"
PagesContainer.Parent = MainFrame

-- 1. MAIN MENU PAGE
local MainPanel = Instance.new("Frame")
MainPanel.Name = "MainPanel"
MainPanel.Size = UDim2.new(1, -170, 1, -30)
MainPanel.Position = UDim2.new(0, 170, 0, 30)
MainPanel.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainPanel.BorderSizePixel = 0
MainPanel.ZIndex = 7
MainPanel.Visible = true
MainPanel.Parent = PagesContainer

local MainHeader = Instance.new("TextLabel")
MainHeader.Size = UDim2.new(1, 0, 0, 40)
MainHeader.Position = UDim2.new(0, 0, 0, 5)
MainHeader.BackgroundTransparency = 1
MainHeader.TextColor3 = Color3.fromRGB(255, 30, 30)
MainHeader.TextSize = 18
MainHeader.Font = Enum.Font.GothamBlack
MainHeader.Text = "ELSINIO V1.02"
MainHeader.ZIndex = 7
MainHeader.Parent = MainPanel

local ContentScroll = Instance.new("ScrollingFrame")
ContentScroll.Size = UDim2.new(1, -10, 1, -50)
ContentScroll.Position = UDim2.new(0, 5, 0, 45)
ContentScroll.BackgroundTransparency = 1
ContentScroll.BorderSizePixel = 0
ContentScroll.CanvasSize = UDim2.new(0, 0, 0, 350)
ContentScroll.ScrollBarThickness = 3
ContentScroll.ZIndex = 7
ContentScroll.Parent = MainPanel

local ContentList = Instance.new("UIListLayout")
ContentList.SortOrder = Enum.SortOrder.LayoutOrder
ContentList.Padding = UDim.new(0, 6)
ContentList.Parent = ContentScroll

-- 2. SETTINGS PAGE
local SettingsPanel = Instance.new("Frame")
SettingsPanel.Name = "SettingsPanel"
SettingsPanel.Size = UDim2.new(1, -170, 1, -30)
SettingsPanel.Position = UDim2.new(0, 170, 0, 30)
SettingsPanel.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
SettingsPanel.BorderSizePixel = 0
SettingsPanel.ZIndex = 7
SettingsPanel.Visible = false
SettingsPanel.Parent = PagesContainer

local SettingsHeader = Instance.new("TextLabel")
SettingsHeader.Size = UDim2.new(1, 0, 0, 40)
SettingsHeader.Position = UDim2.new(0, 0, 0, 5)
SettingsHeader.BackgroundTransparency = 1
SettingsHeader.TextColor3 = Color3.fromRGB(255, 30, 30)
SettingsHeader.TextSize = 18
SettingsHeader.Font = Enum.Font.GothamBlack
SettingsHeader.Text = "SETTINGS - BORDER COLOR"
SettingsHeader.ZIndex = 7
SettingsHeader.Parent = SettingsPanel

local SettingsScroll = Instance.new("ScrollingFrame")
SettingsScroll.Size = UDim2.new(1, -10, 1, -50)
SettingsScroll.Position = UDim2.new(0, 5, 0, 45)
SettingsScroll.BackgroundTransparency = 1
SettingsScroll.BorderSizePixel = 0
SettingsScroll.CanvasSize = UDim2.new(0, 0, 0, 350)
SettingsScroll.ScrollBarThickness = 3
SettingsScroll.ZIndex = 7
SettingsScroll.Parent = SettingsPanel

local SettingsList = Instance.new("UIListLayout")
SettingsList.SortOrder = Enum.SortOrder.LayoutOrder
SettingsList.Padding = UDim.new(0, 8)
SettingsList.Parent = SettingsScroll

local function AddColorOption(name, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -5, 0, 38)
    btn.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
    btn.BorderSizePixel = 0
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 14
    btn.Font = Enum.Font.GothamBold
    btn.Text = "SET BORDER: " .. name
    btn.ZIndex = 7
    btn.Parent = SettingsScroll

    local colorIndicator = Instance.new("Frame")
    colorIndicator.Size = UDim2.new(0, 20, 0, 20)
    colorIndicator.Position = UDim2.new(1, -30, 0.5, -10)
    colorIndicator.BackgroundColor3 = color
    colorIndicator.BorderSizePixel = 0
    colorIndicator.ZIndex = 8
    colorIndicator.Parent = btn

    local indCorner = Instance.new("UICorner")
    indCorner.CornerRadius = UDim.new(1, 0)
    indCorner.Parent = colorIndicator

    btn.MouseButton1Click:Connect(function()
        updateBorderColors(color)
    end)
end

AddColorOption("WHITE", Color3.fromRGB(255, 255, 255))
AddColorOption("RED", Color3.fromRGB(255, 30, 30))
AddColorOption("BLUE", Color3.fromRGB(30, 144, 255))
AddColorOption("GREEN", Color3.fromRGB(46, 204, 113))
AddColorOption("YELLOW", Color3.fromRGB(241, 196, 15))
AddColorOption("PURPLE", Color3.fromRGB(155, 89, 182))

-- Sidebar Tab Switcher
local function AddSidebarTab(name, order, targetPanel)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 32)
    btn.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
    btn.BorderSizePixel = 0
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamBold
    btn.Text = name
    btn.ZIndex = 7
    btn.LayoutOrder = order
    btn.Parent = SidebarScroll

    btn.MouseButton1Click:Connect(function()
        MainPanel.Visible = false
        SettingsPanel.Visible = false
        targetPanel.Visible = true
    end)
    return btn
end

AddSidebarTab("MAIN MENU", 1, MainPanel)
AddSidebarTab("SETTINGS", 2, SettingsPanel)

local function AddContentButton(name, order, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -5, 0, 38)
    btn.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
    btn.BorderSizePixel = 0
    btn.TextColor3 = Color3.fromRGB(240, 240, 240)
    btn.TextSize = 14
    btn.Font = Enum.Font.GothamBold
    btn.Text = name
    btn.ZIndex = 7
    btn.LayoutOrder = order
    btn.Parent = ContentScroll

    btn.MouseButton1Click:Connect(function()
        if callback then
            callback(btn)
        end
    end)
    return btn
end

----------------------------------------------------
-- BYPASS 1 (AIMBOT & ESP)
----------------------------------------------------
local aimbotEnabled = false
local espLineActive = false
local espNameActive = false
local espHealthActive = false
local espDistanceActive = false
local espCounterActive = false

local CounterFrame = Instance.new("Frame")
CounterFrame.Name = "ESPCounterFrame"
CounterFrame.Size = UDim2.new(0, 160, 0, 35)
CounterFrame.Position = UDim2.new(0.5, -80, 0, 10)
CounterFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
CounterFrame.BorderSizePixel = 0
CounterFrame.Visible = false
CounterFrame.Parent = ScreenGui

local CounterStroke = Instance.new("UIStroke")
CounterStroke.Color = Color3.fromRGB(255, 30, 30)
CounterStroke.Thickness = 1.5
CounterStroke.Parent = CounterFrame
table.insert(activeStrokes, CounterStroke)

local CounterCorner = Instance.new("UICorner")
CounterCorner.CornerRadius = UDim.new(0, 6)
CounterCorner.Parent = CounterFrame

local CounterText = Instance.new("TextLabel")
CounterText.Size = UDim2.new(1, 0, 1, 0)
CounterText.BackgroundTransparency = 1
CounterText.TextColor3 = Color3.fromRGB(255, 255, 255)
CounterText.Font = Enum.Font.GothamBold
CounterText.TextSize = 13
CounterText.Text = "PLAYERS: 0"
CounterText.Parent = CounterFrame

local function getClosestPlayer()
    local closest = nil
    local shortestDist = math.huge

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            local head = player.Character.Head
            local pos, onScreen = Camera:WorldToViewportPoint(head.Position)
            if onScreen then
                local dist = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                if dist < shortestDist then
                    shortestDist = dist
                    closest = head
                end
            end
        end
    end
    return closest
end

RunService.RenderStepped:Connect(function()
    if aimbotEnabled and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local target = getClosestPlayer()
        if target then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position)
        end
    end

    local activePlayersCount = 0

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChildOfClass("Humanoid") then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            local root = player.Character.HumanoidRootPart
            local head = player.Character:FindFirstChild("Head") or root

            if humanoid.Health > 0 then
                activePlayersCount = activePlayersCount + 1

                local hrpPos, onScreen = Camera:WorldToViewportPoint(root.Position)
                if espLineActive and onScreen then
                    local line = ScreenGui:FindFirstChild("Line_" .. player.Name)
                    if not line then
                        line = Instance.new("Frame")
                        line.Name = "Line_" .. player.Name
                        line.AnchorPoint = Vector2.new(0.5, 0.5)
                        line.BackgroundColor3 = Color3.fromRGB(255, 30, 30)
                        line.BorderSizePixel = 0
                        line.Parent = ScreenGui
                    end

                    local startPos = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                    local endPos = Vector2.new(hrpPos.X, hrpPos.Y)
                    local distance = (endPos - startPos).Magnitude
                    local angle = math.atan2(endPos.Y - startPos.Y, endPos.X - startPos.X)

                    line.Size = UDim2.new(0, distance, 0, 1.5)
                    line.Position = UDim2.new(0, (startPos.X + endPos.X) / 2, 0, (startPos.Y + endPos.Y) / 2)
                    line.Rotation = math.deg(angle)
                    line.Visible = true
                else
                    if ScreenGui:FindFirstChild("Line_" .. player.Name) then
                        ScreenGui["Line_" .. player.Name].Visible = false
                    end
                end

                local bGui = player.Character:FindFirstChild("ElSinioESP")
                if (espNameActive or espHealthActive or espDistanceActive) and onScreen then
                    if not bGui then
                        bGui = Instance.new("BillboardGui")
                        bGui.Name = "ElSinioESP"
                        bGui.Adornee = head
                        bGui.Size = UDim2.new(0, 200, 0, 60)
                        bGui.StudsOffset = Vector3.new(0, 3, 0)
                        bGui.AlwaysOnTop = true
                        bGui.Parent = player.Character

                        local lbl = Instance.new("TextLabel")
                        lbl.Name = "ESPLabel"
                        lbl.Size = UDim2.new(1, 0, 1, 0)
                        lbl.BackgroundTransparency = 1
                        lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
                        lbl.Font = Enum.Font.GothamBold
                        lbl.TextSize = 13
                        lbl.TextStrokeTransparency = 0.2
                        lbl.Parent = bGui
                    end

                    local textStr = ""
                    if espNameActive then
                        textStr = textStr .. player.Name .. "\n"
                    end
                    if espHealthActive then
                        local hpPercent = math.floor((humanoid.Health / humanoid.MaxHealth) * 100)
                        textStr = textStr .. "HP: " .. math.floor(humanoid.Health) .. " [" .. hpPercent .. "%]\n"
                    end
                    if espDistanceActive and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        local dist = math.floor((LocalPlayer.Character.HumanoidRootPart.Position - root.Position).Magnitude)
                        textStr = textStr .. "Dist: " .. dist .. " studs"
                    end

                    bGui.ESPLabel.Text = textStr
                    bGui.Enabled = true
                else
                    if bGui then bGui.Enabled = false end
                end
            end
        else
            if ScreenGui:FindFirstChild("Line_" .. player.Name) then
                ScreenGui["Line_" .. player.Name].Visible = false
            end
        end
    end

    if espCounterActive then
        CounterFrame.Visible = true
        CounterText.Text = "PLAYERS ALIVE: " .. tostring(activePlayersCount)
    else
        CounterFrame.Visible = false
    end
end)

local function openBypass1GUI()
    if ScreenGui:FindFirstChild("Bypass1Frame") then
        ScreenGui.Bypass1Frame.Visible = not ScreenGui.Bypass1Frame.Visible
        return
    end

    local subFrame = Instance.new("Frame")
    subFrame.Name = "Bypass1Frame"
    subFrame.Size = UDim2.new(0, 320, 0, 300)
    subFrame.Position = UDim2.new(0.5, 270, 0.5, -150)
    subFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    subFrame.BorderSizePixel = 1
    subFrame.BorderColor3 = Color3.fromRGB(220, 30, 30)
    subFrame.Active = true
    subFrame.Draggable = true
    subFrame.Parent = ScreenGui

    local subStroke = Instance.new("UIStroke")
    subStroke.Color = Color3.fromRGB(255, 30, 30)
    subStroke.Thickness = 1.5
    subStroke.Parent = subFrame
    table.insert(activeStrokes, subStroke)

    local subTitle = Instance.new("TextLabel")
    subTitle.Size = UDim2.new(1, -30, 0, 30)
    subTitle.Position = UDim2.new(0, 10, 0, 0)
    subTitle.BackgroundTransparency = 1
    subTitle.TextColor3 = Color3.fromRGB(255, 50, 50)
    subTitle.TextSize = 14
    subTitle.Font = Enum.Font.GothamBold
    subTitle.TextXAlignment = Enum.TextXAlignment.Left
    subTitle.Text = "BYPASS 1 - CHEATS PANEL"
    subTitle.Parent = subFrame

    local subClose = Instance.new("TextButton")
    subClose.Size = UDim2.new(0, 30, 0, 30)
    subClose.Position = UDim2.new(1, -30, 0, 0)
    subClose.BackgroundTransparency = 1
    subClose.TextColor3 = Color3.fromRGB(220, 220, 220)
    subClose.TextSize = 16
    subClose.Font = Enum.Font.GothamBold
    subClose.Text = "X"
    subClose.Parent = subFrame
    subClose.MouseButton1Click:Connect(function()
        subFrame.Visible = false
    end)

    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, -10, 1, -40)
    scroll.Position = UDim2.new(0, 5, 0, 35)
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    scroll.CanvasSize = UDim2.new(0, 0, 0, 260)
    scroll.ScrollBarThickness = 3
    scroll.Parent = subFrame

    local list = Instance.new("UIListLayout")
    list.SortOrder = Enum.SortOrder.LayoutOrder
    list.Padding = UDim.new(0, 6)
    list.Parent = scroll

    local function CreateToggle(name, defaultState, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -5, 0, 35)
        btn.BackgroundColor3 = defaultState and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(35, 35, 35)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 13
        btn.Text = name .. (defaultState and " [ON]" or " [OFF]")
        btn.Parent = scroll

        local active = defaultState
        btn.MouseButton1Click:Connect(function()
            active = not active
            btn.BackgroundColor3 = active and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(35, 35, 35)
            btn.Text = name .. (active and " [ON]" or " [OFF]")
            callback(active)
        end)
    end

    CreateToggle("AIMBOT (RMB LOCK)", aimbotEnabled, function(state)
        aimbotEnabled = state
    end)

    CreateToggle("ESP LINE", espLineActive, function(state)
        espLineActive = state
    end)

    CreateToggle("ESP NAME", espNameActive, function(state)
        espNameActive = state
    end)

    CreateToggle("ESP HEALTH", espHealthActive, function(state)
        espHealthActive = state
    end)

    CreateToggle("ESP COUNTER", espCounterActive, function(state)
        espCounterActive = state
    end)

    CreateToggle("ESP DISTANCE", espDistanceActive, function(state)
        espDistanceActive = state
    end)
end

----------------------------------------------------
-- BYPASS 2 (INVISIBLE & NO CLIP)
----------------------------------------------------
local invisibleActive = false
local noclipActive = false
local noclipConnection = nil

local function toggleInvisible(state)
    invisibleActive = state
    local character = LocalPlayer.Character
    if not character then return end

    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") or part:IsA("Decal") then
            if part.Name ~= "HumanoidRootPart" then
                part.Transparency = invisibleActive and 1 or 0
            end
        end
    end
end

local function toggleNoClip(state)
    noclipActive = state
    if noclipActive then
        noclipConnection = RunService.Stepped:Connect(function()
            local character = LocalPlayer.Character
            if character then
                for _, part in pairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        if noclipConnection then
            noclipConnection:Disconnect()
            noclipConnection = nil
        end
        local character = LocalPlayer.Character
        if character then
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.CanCollide = true
                end
            end
        end
    end
end

local function openBypass2GUI()
    if ScreenGui:FindFirstChild("Bypass2Frame") then
        ScreenGui.Bypass2Frame.Visible = not ScreenGui.Bypass2Frame.Visible
        return
    end

    local subFrame = Instance.new("Frame")
    subFrame.Name = "Bypass2Frame"
    subFrame.Size = UDim2.new(0, 320, 0, 180)
    subFrame.Position = UDim2.new(0.5, 270, 0.5, 50)
    subFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    subFrame.BorderSizePixel = 1
    subFrame.BorderColor3 = Color3.fromRGB(220, 30, 30)
    subFrame.Active = true
    subFrame.Draggable = true
    subFrame.Parent = ScreenGui

    local subStroke = Instance.new("UIStroke")
    subStroke.Color = Color3.fromRGB(255, 30, 30)
    subStroke.Thickness = 1.5
    subStroke.Parent = subFrame
    table.insert(activeStrokes, subStroke)

    local subTitle = Instance.new("TextLabel")
    subTitle.Size = UDim2.new(1, -30, 0, 30)
    subTitle.Position = UDim2.new(0, 10, 0, 0)
    subTitle.BackgroundTransparency = 1
    subTitle.TextColor3 = Color3.fromRGB(255, 50, 50)
    subTitle.TextSize = 14
    subTitle.Font = Enum.Font.GothamBold
    subTitle.TextXAlignment = Enum.TextXAlignment.Left
    subTitle.Text = "BYPASS 2 - INVISIBLE & NO CLIP"
    subTitle.Parent = subFrame

    local subClose = Instance.new("TextButton")
    subClose.Size = UDim2.new(0, 30, 0, 30)
    subClose.Position = UDim2.new(1, -30, 0, 0)
    subClose.BackgroundTransparency = 1
    subClose.TextColor3 = Color3.fromRGB(220, 220, 220)
    subClose.TextSize = 16
    subClose.Font = Enum.Font.GothamBold
    subClose.Text = "X"
    subClose.Parent = subFrame
    subClose.MouseButton1Click:Connect(function()
        subFrame.Visible = false
    end)

    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, -10, 1, -40)
    scroll.Position = UDim2.new(0, 5, 0, 35)
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    scroll.CanvasSize = UDim2.new(0, 0, 0, 120)
    scroll.ScrollBarThickness = 3
    scroll.Parent = subFrame

    local list = Instance.new("UIListLayout")
    list.SortOrder = Enum.SortOrder.LayoutOrder
    list.Padding = UDim.new(0, 6)
    list.Parent = scroll

    local function CreateToggle(name, defaultState, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -5, 0, 35)
        btn.BackgroundColor3 = defaultState and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(35, 35, 35)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 13
        btn.Text = name .. (defaultState and " [ON]" or " [OFF]")
        btn.Parent = scroll

        local active = defaultState
        btn.MouseButton1Click:Connect(function()
            active = not active
            btn.BackgroundColor3 = active and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(35, 35, 35)
            btn.Text = name .. (active and " [ON]" or " [OFF]")
            callback(active)
        end)
    end

    CreateToggle("INVISIBLE", invisibleActive, function(state)
        toggleInvisible(state)
    end)

    CreateToggle("NO CLIP", noclipActive, function(state)
        toggleNoClip(state)
    end)
end

----------------------------------------------------
-- BYPASS 3 (FLY & DUPE GUN)
----------------------------------------------------
local flyActive = false
local flySpeed = 50
local bv, bg
local dupeGunActive = false

local function toggleFly(state)
    flyActive = state
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local root = character:FindFirstChild("HumanoidRootPart")

    if flyActive and root then
        bv = Instance.new("BodyVelocity")
        bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        bv.Velocity = Vector3.zero
        bv.Parent = root

        bg = Instance.new("BodyGyro")
        bg.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
        bg.CFrame = root.CFrame
        bg.Parent = root

        task.spawn(function()
            while flyActive and root and bv and bg do
                local cam = Workspace.CurrentCamera
                local moveDir = Vector3.zero

                if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + cam.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - cam.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - cam.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + cam.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.E) then moveDir = moveDir + Vector3.new(0, 1, 0) end
                if UserInputService:IsKeyDown(Enum.KeyCode.Q) then moveDir = moveDir - Vector3.new(0, 1, 0) end

                bv.Velocity = moveDir * flySpeed
                bg.CFrame = cam.CFrame
                task.wait()
            end
        end)
    else
        if bv then bv:Destroy() end
        if bg then bg:Destroy() end
    end
end

task.spawn(function()
    while true do
        task.wait(1)
        if dupeGunActive then
            local backpack = LocalPlayer:FindFirstChild("Backpack")
            local character = LocalPlayer.Character
            if backpack and character then
                for _, item in pairs(character:GetChildren()) do
                    if item:IsA("Tool") then
                        item:Clone().Parent = backpack
                    end
                end
            end
        end
    end
end)

local function openBypass3GUI()
    if ScreenGui:FindFirstChild("Bypass3Frame") then
        ScreenGui.Bypass3Frame.Visible = not ScreenGui.Bypass3Frame.Visible
        return
    end

    local subFrame = Instance.new("Frame")
    subFrame.Name = "Bypass3Frame"
    subFrame.Size = UDim2.new(0, 320, 0, 180)
    subFrame.Position = UDim2.new(0.5, 270, 0.5, 240)
    subFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    subFrame.BorderSizePixel = 1
    subFrame.BorderColor3 = Color3.fromRGB(220, 30, 30)
    subFrame.Active = true
    subFrame.Draggable = true
    subFrame.Parent = ScreenGui

    local subStroke = Instance.new("UIStroke")
    subStroke.Color = Color3.fromRGB(255, 30, 30)
    subStroke.Thickness = 1.5
    subStroke.Parent = subFrame
    table.insert(activeStrokes, subStroke)

    local subTitle = Instance.new("TextLabel")
    subTitle.Size = UDim2.new(1, -30, 0, 30)
    subTitle.Position = UDim2.new(0, 10, 0, 0)
    subTitle.BackgroundTransparency = 1
    subTitle.TextColor3 = Color3.fromRGB(255, 50, 50)
    subTitle.TextSize = 14
    subTitle.Font = Enum.Font.GothamBold
    subTitle.TextXAlignment = Enum.TextXAlignment.Left
    subTitle.Text = "BYPASS 3 - FLY & DUPE GUN"
    subTitle.Parent = subFrame

    local subClose = Instance.new("TextButton")
    subClose.Size = UDim2.new(0, 30, 0, 30)
    subClose.Position = UDim2.new(1, -30, 0, 0)
    subClose.BackgroundTransparency = 1
    subClose.TextColor3 = Color3.fromRGB(220, 220, 220)
    subClose.TextSize = 16
    subClose.Font = Enum.Font.GothamBold
    subClose.Text = "X"
    subClose.Parent = subFrame
    subClose.MouseButton1Click:Connect(function()
        subFrame.Visible = false
    end)

    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, -10, 1, -40)
    scroll.Position = UDim2.new(0, 5, 0, 35)
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    scroll.CanvasSize = UDim2.new(0, 0, 0, 120)
    scroll.ScrollBarThickness = 3
    scroll.Parent = subFrame

    local list = Instance.new("UIListLayout")
    list.SortOrder = Enum.SortOrder.LayoutOrder
    list.Padding = UDim.new(0, 6)
    list.Parent = scroll

    local function CreateToggle(name, defaultState, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -5, 0, 35)
        btn.BackgroundColor3 = defaultState and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(35, 35, 35)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 13
        btn.Text = name .. (defaultState and " [ON]" or " [OFF]")
        btn.Parent = scroll

        local active = defaultState
        btn.MouseButton1Click:Connect(function()
            active = not active
            btn.BackgroundColor3 = active and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(35, 35, 35)
            btn.Text = name .. (active and " [ON]" or " [OFF]")
            callback(active)
        end)
    end

    CreateToggle("FLY", flyActive, function(state)
        toggleFly(state)
    end)

    CreateToggle("DUPE GUN", dupeGunActive, function(state)
        dupeGunActive = state
    end)
end

----------------------------------------------------
-- ADD BUTTONS TO MENU
----------------------------------------------------
AddContentButton("BYPASS 1", 1, openBypass1GUI)
AddContentButton("BYPASS 2", 2, openBypass2GUI)
AddContentButton("BYPASS 3", 3, openBypass3GUI)

print("EL SINIO")