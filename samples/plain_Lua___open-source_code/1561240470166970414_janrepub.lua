-- Configuration & Core Entities
local UI_TITLE = "JAN REPUBLIC"
local BASE_POSITION = Vector3.new(193.92, 4.31, 270.71)
local EGGS_PATH = workspace:WaitForChild("Live"):WaitForChild("Friends")

-- Spawn zones with their anchor rendering positions
local ZONE_DATA = {
    ["Prehistoric"] = Vector3.new(178.79, 0.95, -6421.17),
    ["Space"]       = Vector3.new(165.90, 4.31, -5134.56),
    ["Heaven"]      = Vector3.new(187.17, 4.31, -3884.17),
    ["Haunted"]     = Vector3.new(209.22, 4.31, -2828.85),
    ["Candy"]       = Vector3.new(201.70, 4.31, -2151.00),
    ["Jungle"]      = Vector3.new(207.66, 4.31, -1540.45),
    ["Crystal"]     = Vector3.new(209.79, 4.31, -1085.85),
    ["Snow"]        = Vector3.new(208.68, 4.31, -699.82),
    ["Volcano"]     = Vector3.new(202.17, 4.31, -277.57),
    ["Desert"]      = Vector3.new(214.68, 4.31, -74.48),
    ["Meadow"]      = Vector3.new(194.91, 4.31, 140.14)
}

local SPAWN_ZONES = {
    "Prehistoric", "Space", "Heaven", "Haunted", "Candy", 
    "Jungle", "Crystal", "Snow", "Volcano", "Desert", "Meadow"
}

-- Core Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- Global State
local autoFarmActive = false
local selectedAutoZone = "Prehistoric"

-- Futuristic Colors (Cyberpunk Dark / Electric Cyan & Neon Red Accent)
local Theme = {
    Bg = Color3.fromRGB(12, 14, 20),
    Panel = Color3.fromRGB(20, 24, 35),
    TopBar = Color3.fromRGB(16, 18, 26),
    Accent = Color3.fromRGB(0, 229, 255),      -- Cyan Glow
    AccentDark = Color3.fromRGB(0, 110, 128),
    Text = Color3.fromRGB(240, 248, 255),
    TextMuted = Color3.fromRGB(130, 145, 165),
    Button = Color3.fromRGB(28, 34, 48),
    Green = Color3.fromRGB(0, 230, 118),
    Red = Color3.fromRGB(255, 23, 68),
    Font = Enum.Font.RobotoMono
}

-- Helper function to add visual curves
local function styleCorner(instance, radius)
    local uicorner = Instance.new("UICorner")
    uicorner.CornerRadius = UDim.new(0, radius or 6)
    uicorner.Parent = instance
    return uicorner
end

-- Helper function for clean cyber borders
local function styleStroke(instance, color, thickness)
    local uistroke = Instance.new("UIStroke")
    uistroke.Color = color or Theme.AccentDark
    uistroke.Thickness = thickness or 1
    uistroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    uistroke.Parent = instance
    return uistroke
end

-- Safe Teleport Helper
local function teleportTo(position)
    local character = LocalPlayer.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        character.HumanoidRootPart.CFrame = CFrame.new(position)
    end
end

-- Collect Cycle: TP -> Wait/Collect -> Base Retrieve
local function collectEggSequence(egg)
    if not egg or not egg:IsA("PVInstance") then return end
    
    local eggPos = egg:GetPivot().Position
    teleportTo(eggPos + Vector3.new(0, 2, 0))
    task.wait(0.4)
    
    local prompt = egg:FindFirstChildWhichIsA("ProximityPrompt", true)
    if prompt then
        fireproximityprompt(prompt)
    else
        if VirtualInputManager then
            local VIM = game:GetService("VirtualInputManager")
            VIM:SendKeyEvent(true, Enum.KeyCode.E, false, game)
            task.wait(0.05)
            VIM:SendKeyEvent(false, Enum.KeyCode.E, false, game)
        end
    end
    task.wait(0.4)
    
    teleportTo(BASE_POSITION)
    task.wait(0.7)
end

-- UI Construction
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "JanRepublicGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Main Window
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 480, 0, 340)
MainFrame.Position = UDim2.new(0.5, -240, 0.5, -170)
MainFrame.BackgroundColor3 = Theme.Bg
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui
styleCorner(MainFrame, 10)
styleStroke(MainFrame, Theme.Accent, 1.5)

-- Top Bar (Title & Controls)
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = Theme.TopBar
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame
styleCorner(TopBar, 10)

-- Cover bottom corners of top bar for smooth flush integration
local TopBarFlush = Instance.new("Frame")
TopBarFlush.Size = UDim2.new(1, 0, 0, 10)
TopBarFlush.Position = UDim2.new(0, 0, 1, -10)
TopBarFlush.BackgroundColor3 = Theme.TopBar
TopBarFlush.BorderSizePixel = 0
TopBarFlush.Parent = TopBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Text = " // " .. UI_TITLE
TitleLabel.Size = UDim2.new(0.6, 0, 1, 0)
TitleLabel.Position = UDim2.new(0, 12, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.TextColor3 = Theme.Accent
TitleLabel.Font = Theme.Font
TitleLabel.TextSize = 16
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TopBar

-- Return Base Button (Top Bar Feature)
local ReturnBaseBtn = Instance.new("TextButton")
ReturnBaseBtn.Text = "RETURN BASE"
ReturnBaseBtn.Size = UDim2.new(0, 100, 0, 24)
ReturnBaseBtn.Position = UDim2.new(1, -145, 0, 8)
ReturnBaseBtn.BackgroundColor3 = Theme.Button
ReturnBaseBtn.TextColor3 = Theme.Text
ReturnBaseBtn.Font = Theme.Font
ReturnBaseBtn.TextSize = 11
ReturnBaseBtn.Parent = TopBar
styleCorner(ReturnBaseBtn, 4)
styleStroke(ReturnBaseBtn, Theme.TextMuted, 1)

ReturnBaseBtn.MouseButton1Click:Connect(function()
    teleportTo(BASE_POSITION)
end)

local MinBtn = Instance.new("TextButton")
MinBtn.Text = "-"
MinBtn.Size = UDim2.new(0, 26, 0, 24)
MinBtn.Position = UDim2.new(1, -34, 0, 8)
MinBtn.BackgroundColor3 = Theme.Button
MinBtn.TextColor3 = Theme.Accent
MinBtn.Font = Theme.Font
MinBtn.TextSize = 16
MinBtn.Parent = TopBar
styleCorner(MinBtn, 4)
styleStroke(MinBtn, Theme.AccentDark, 1)

-- Layout Panel Divisions
local ContentContainer = Instance.new("Frame")
ContentContainer.Size = UDim2.new(1, -20, 1, -55)
ContentContainer.Position = UDim2.new(0, 10, 0, 45)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Parent = MainFrame

-- Columns
local ZoneListFrame = Instance.new("ScrollingFrame")
ZoneListFrame.Size = UDim2.new(0, 140, 1, 0)
ZoneListFrame.BackgroundColor3 = Theme.Panel
ZoneListFrame.BorderSizePixel = 0
ZoneListFrame.ScrollBarThickness = 3
ZoneListFrame.CanvasSize = UDim2.new(0, 0, 0, #SPAWN_ZONES * 32)
ZoneListFrame.Parent = ContentContainer
styleCorner(ZoneListFrame, 6)

local EggListFrame = Instance.new("ScrollingFrame")
EggListFrame.Size = UDim2.new(0, 160, 1, 0)
EggListFrame.Position = UDim2.new(0, 148, 0, 0)
EggListFrame.BackgroundColor3 = Theme.Panel
EggListFrame.BorderSizePixel = 0
EggListFrame.ScrollBarThickness = 3
EggListFrame.Parent = ContentContainer
styleCorner(EggListFrame, 6)

local AutoFarmFrame = Instance.new("Frame")
AutoFarmFrame.Size = UDim2.new(1, -316, 1, 0)
AutoFarmFrame.Position = UDim2.new(0, 316, 0, 0)
AutoFarmFrame.BackgroundColor3 = Theme.Panel
AutoFarmFrame.BorderSizePixel = 0
AutoFarmFrame.Parent = ContentContainer
styleCorner(AutoFarmFrame, 6)

-- Padding Layouts
local ZoneLayout = Instance.new("UIListLayout")
ZoneLayout.Padding = UDim.new(0, 4)
ZoneLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
ZoneLayout.Parent = ZoneListFrame

local EggLayout = Instance.new("UIListLayout")
EggLayout.Padding = UDim.new(0, 4)
EggLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
EggLayout.Parent = EggListFrame

local ZonePadding = Instance.new("UIPadding")
ZonePadding.PaddingTop = UDim.new(0, 6)
ZonePadding.Parent = ZoneListFrame

local EggPadding = Instance.new("UIPadding")
EggPadding.PaddingTop = UDim.new(0, 6)
EggPadding.Parent = EggListFrame

-- Auto Farm Title
local AutoTitle = Instance.new("TextLabel")
AutoTitle.Text = "SYSTEM AUTO-FARM"
AutoTitle.Size = UDim2.new(1, 0, 0, 30)
AutoTitle.BackgroundTransparency = 1
AutoTitle.TextColor3 = Theme.TextMuted
AutoTitle.Font = Theme.Font
AutoTitle.TextSize = 13
AutoTitle.Parent = AutoFarmFrame

-- Dropdown Button Header
local DropdownHeaderBtn = Instance.new("TextButton")
DropdownHeaderBtn.Text = selectedAutoZone .. " [v]"
DropdownHeaderBtn.Size = UDim2.new(0.9, 0, 0, 32)
DropdownHeaderBtn.Position = UDim2.new(0.05, 0, 0, 40)
DropdownHeaderBtn.BackgroundColor3 = Theme.Button
DropdownHeaderBtn.TextColor3 = Theme.Accent
DropdownHeaderBtn.Font = Theme.Font
DropdownHeaderBtn.TextSize = 12
DropdownHeaderBtn.ZIndex = 5
DropdownHeaderBtn.Parent = AutoFarmFrame
styleCorner(DropdownHeaderBtn, 4)
styleStroke(DropdownHeaderBtn, Theme.AccentDark, 1)

-- Dropdown List Container (Scrollable)
local DropdownListFrame = Instance.new("ScrollingFrame")
DropdownListFrame.Size = UDim2.new(0.9, 0, 0, 140)
DropdownListFrame.Position = UDim2.new(0.05, 0, 0, 75)
DropdownListFrame.BackgroundColor3 = Theme.Bg
DropdownListFrame.BorderSizePixel = 0
DropdownListFrame.Visible = false
DropdownListFrame.ZIndex = 6
DropdownListFrame.ScrollBarThickness = 2
DropdownListFrame.CanvasSize = UDim2.new(0, 0, 0, #SPAWN_ZONES * 28)
DropdownListFrame.Parent = AutoFarmFrame
styleCorner(DropdownListFrame, 4)
styleStroke(DropdownListFrame, Theme.Accent, 1)

local DropdownLayout = Instance.new("UIListLayout")
DropdownLayout.Parent = DropdownListFrame

-- Start / Stop Auto button
local StartAutoBtn = Instance.new("TextButton")
StartAutoBtn.Text = "INITIALIZE"
StartAutoBtn.Size = UDim2.new(0.9, 0, 0, 38)
StartAutoBtn.Position = UDim2.new(0.05, 0, 1, -48)
StartAutoBtn.BackgroundColor3 = Theme.Button
StartAutoBtn.TextColor3 = Theme.Green
StartAutoBtn.Font = Theme.Font
StartAutoBtn.TextSize = 14
StartAutoBtn.ZIndex = 2
StartAutoBtn.Parent = AutoFarmFrame
styleCorner(StartAutoBtn, 4)
styleStroke(StartAutoBtn, Theme.Green, 1)

-- Populate Dropdown Selection List
for _, zoneName in ipairs(SPAWN_ZONES) do
    local OptionBtn = Instance.new("TextButton")
    OptionBtn.Text = " " .. zoneName:upper()
    OptionBtn.Size = UDim2.new(1, 0, 0, 26)
    OptionBtn.BackgroundColor3 = Theme.Button
    OptionBtn.TextColor3 = Theme.Text
    OptionBtn.Font = Theme.Font
    OptionBtn.TextSize = 11
    OptionBtn.TextXAlignment = Enum.TextXAlignment.Left
    OptionBtn.ZIndex = 7
    OptionBtn.Parent = DropdownListFrame
    
    OptionBtn.MouseButton1Click:Connect(function()
        selectedAutoZone = zoneName
        DropdownHeaderBtn.Text = zoneName .. " [v]"
        DropdownListFrame.Visible = false
    end)
end

DropdownHeaderBtn.MouseButton1Click:Connect(function()
    DropdownListFrame.Visible = not DropdownListFrame.Visible
end)

-- Minimize Animation
local isMinimized = false
MinBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        MainFrame:TweenSize(UDim2.new(0, 480, 0, 40), "Out", "Quad", 0.2, true)
        ContentContainer.Visible = false
        MinBtn.Text = "+"
    else
        MainFrame:TweenSize(UDim2.new(0, 480, 0, 340), "Out", "Quad", 0.2, true)
        ContentContainer.Visible = true
        MinBtn.Text = "-"
    end
end)

-- Fetch active eggs matching filter
local function getEggsInZone(zoneName)
    local list = {}
    for _, egg in ipairs(EGGS_PATH:GetChildren()) do
        if egg:GetAttribute("SpawnZone") == zoneName then
            table.insert(list, egg)
        end
    end
    return list
end

-- Refresh manual egg list panel
local function updateEggListView(zoneName)
    for _, child in ipairs(EggListFrame:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    
    local validEggs = getEggsInZone(zoneName)
    EggListFrame.CanvasSize = UDim2.new(0, 0, 0, (#validEggs * 34) + 10)
    
    for _, egg in ipairs(validEggs) do
        local EggBtn = Instance.new("TextButton")
        EggBtn.Text = "FETCH: " .. egg.Name:upper()
        EggBtn.Size = UDim2.new(0.9, 0, 0, 28)
        EggBtn.BackgroundColor3 = Theme.Button
        EggBtn.TextColor3 = Theme.Text
        EggBtn.Font = Theme.Font
        EggBtn.TextSize = 11
        EggBtn.Parent = EggListFrame
        styleCorner(EggBtn, 4)
        styleStroke(EggBtn, Theme.TextMuted, 1)
        
        EggBtn.MouseButton1Click:Connect(function()
            collectEggSequence(egg)
        end)
    end
end

-- Build Zone Navigation Module
for _, zone in ipairs(SPAWN_ZONES) do
    local ZoneBtn = Instance.new("TextButton")
    ZoneBtn.Text = zone:upper()
    ZoneBtn.Size = UDim2.new(0.9, 0, 0, 28)
    ZoneBtn.BackgroundColor3 = Theme.Button
    ZoneBtn.TextColor3 = Theme.Text
    ZoneBtn.Font = Theme.Font
    ZoneBtn.TextSize = 11
    ZoneBtn.Parent = ZoneListFrame
    styleCorner(ZoneBtn, 4)
    styleStroke(ZoneBtn, Theme.AccentDark, 1)
    
    ZoneBtn.MouseButton1Click:Connect(function()
        updateEggListView(zone)
    end)
end

-- Main Auto Farm Trigger Connection
StartAutoBtn.MouseButton1Click:Connect(function()
    autoFarmActive = not autoFarmActive
    if autoFarmActive then
        StartAutoBtn.Text = "TERMINATE"
        StartAutoBtn.TextColor3 = Theme.Red
        styleStroke(StartAutoBtn, Theme.Red, 1)
        DropdownListFrame.Visible = false
        
        task.spawn(function()
            while autoFarmActive do
                -- Anchor TP to zone rendering center point
                local renderAnchor = ZONE_DATA[selectedAutoZone]
                if renderAnchor then
                    teleportTo(renderAnchor)
                    task.wait(1.5) -- Streaming load delay
                end
                
                local targetEggs = getEggsInZone(selectedAutoZone)
                if #targetEggs == 0 then
                    task.wait(1)
                else
                    for _, egg in ipairs(targetEggs) do
                        if not autoFarmActive then break end
                        collectEggSequence(egg)
                    end
                end
                task.wait(0.5)
            end
        end)
    else
        StartAutoBtn.Text = "INITIALIZE"
        StartAutoBtn.TextColor3 = Theme.Green
        styleStroke(StartAutoBtn, Theme.Green, 1)
    end
end)
