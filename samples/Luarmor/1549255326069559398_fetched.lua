--[[ JOSHBNS CRACK KEY SYSTEM & SCRIPT HUB --]]

local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local HttpService = game:GetService("HttpService")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "JOSHBNS CRACK_MULTI_GAME_HUB"
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 999999

if syn and syn.protect_gui then
    syn.protect_gui(ScreenGui)
    ScreenGui.Parent = CoreGui
elseif gethui then
    ScreenGui.Parent = gethui()
else
    local success, err = pcall(function() 
        ScreenGui.Parent = CoreGui 
    end)
    if not success then
        ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    end
end

-- ==========================================
-- GAME SELECTION INTERFACE
-- ==========================================
local GameSelectFrame = Instance.new("Frame")
GameSelectFrame.Size = UDim2.fromOffset(400, 340)
GameSelectFrame.Position = UDim2.new(0.5, -200, 0.5, -170)
GameSelectFrame.BackgroundColor3 = Color3.fromRGB(15, 20, 30)
GameSelectFrame.BorderSizePixel = 0
GameSelectFrame.Active = true
GameSelectFrame.Draggable = true
GameSelectFrame.Visible = false
GameSelectFrame.Parent = ScreenGui

local SelectCorner = Instance.new("UICorner")
SelectCorner.CornerRadius = UDim.new(0, 8)
SelectCorner.Parent = GameSelectFrame

local SelectStroke = Instance.new("UIStroke")
SelectStroke.Color = Color3.fromRGB(60, 140, 240)
SelectStroke.Thickness = 1.8
SelectStroke.Parent = GameSelectFrame

local SelectBgImage = Instance.new("ImageLabel")
SelectBgImage.Size = UDim2.new(1, 0, 1, 0)
SelectBgImage.BackgroundTransparency = 1
SelectBgImage.Image = "rbxassetid://124125593087369"
SelectBgImage.ImageTransparency = 0.4
SelectBgImage.ScaleType = Enum.ScaleType.Slice
SelectBgImage.ZIndex = 0
SelectBgImage.Parent = GameSelectFrame

local SelectTitleBar = Instance.new("Frame")
SelectTitleBar.Size = UDim2.new(1, 0, 0, 32)
SelectTitleBar.BackgroundColor3 = Color3.fromRGB(18, 28, 45)
SelectTitleBar.BorderSizePixel = 0
SelectTitleBar.ZIndex = 2
SelectTitleBar.Parent = GameSelectFrame

local SelectTitleText = Instance.new("TextLabel")
SelectTitleText.Size = UDim2.new(1, -30, 1, 0)
SelectTitleText.Position = UDim2.new(0, 12, 0, 0)
SelectTitleText.BackgroundTransparency = 1
SelectTitleText.TextColor3 = Color3.fromRGB(90, 170, 255)
SelectTitleText.Text = "JOSHBNS CRACK | SELECT GAME"
SelectTitleText.Font = Enum.Font.FredokaOne
SelectTitleText.TextSize = 11
SelectTitleText.TextXAlignment = Enum.TextXAlignment.Left
SelectTitleText.ZIndex = 2
SelectTitleText.Parent = SelectTitleBar

local SelectCloseBtn = Instance.new("TextButton")
SelectCloseBtn.Size = UDim2.fromOffset(24, 24)
SelectCloseBtn.Position = UDim2.new(1, -28, 0.5, -12)
SelectCloseBtn.BackgroundTransparency = 1
SelectCloseBtn.TextColor3 = Color3.fromRGB(150, 180, 200)
SelectCloseBtn.Text = "X"
SelectCloseBtn.Font = Enum.Font.GothamBold
SelectCloseBtn.TextSize = 12
SelectCloseBtn.ZIndex = 2
SelectCloseBtn.Parent = SelectTitleBar

SelectCloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

local SelectContainer = Instance.new("ScrollingFrame")
SelectContainer.Size = UDim2.new(1, -24, 1, -56)
SelectContainer.Position = UDim2.new(0, 12, 0, 44)
SelectContainer.BackgroundTransparency = 1
SelectContainer.CanvasSize = UDim2.new(0, 0, 0, 160)
SelectContainer.ScrollBarThickness = 3
SelectContainer.ZIndex = 2
SelectContainer.Parent = GameSelectFrame

local SelectLayout = Instance.new("UIListLayout")
SelectLayout.SortOrder = Enum.SortOrder.LayoutOrder
SelectLayout.Padding = UDim.new(0, 10)
SelectLayout.Parent = SelectContainer

-- Card 1: Steal An Egg
local StealAnEggCard = Instance.new("TextButton")
StealAnEggCard.Size = UDim2.new(1, 0, 0, 70)
StealAnEggCard.BackgroundColor3 = Color3.fromRGB(20, 28, 40)
StealAnEggCard.TextColor3 = Color3.fromRGB(255, 255, 255)
StealAnEggCard.Text = ""
StealAnEggCard.AutoButtonColor = false
StealAnEggCard.ZIndex = 2
StealAnEggCard.Parent = SelectContainer

local CardCorner1 = Instance.new("UICorner")
CardCorner1.CornerRadius = UDim.new(0, 6)
CardCorner1.Parent = StealAnEggCard

local CardStroke1 = Instance.new("UIStroke")
CardStroke1.Color = Color3.fromRGB(60, 140, 240)
CardStroke1.Thickness = 1.2
CardStroke1.Parent = StealAnEggCard

local CardTitle1 = Instance.new("TextLabel")
CardTitle1.Size = UDim2.new(1, -20, 0, 24)
CardTitle1.Position = UDim2.new(0, 10, 0, 10)
CardTitle1.BackgroundTransparency = 1
CardTitle1.TextColor3 = Color3.fromRGB(255, 255, 255)
CardTitle1.Text = "STEAL AN EGG"
CardTitle1.Font = Enum.Font.FredokaOne
CardTitle1.TextSize = 14
CardTitle1.TextXAlignment = Enum.TextXAlignment.Left
CardTitle1.ZIndex = 2
CardTitle1.Parent = StealAnEggCard

local CardDesc1 = Instance.new("TextLabel")
CardDesc1.Size = UDim2.new(1, -20, 0, 20)
CardDesc1.Position = UDim2.new(0, 10, 0, 36)
CardDesc1.BackgroundTransparency = 1
CardDesc1.TextColor3 = Color3.fromRGB(160, 180, 200)
CardDesc1.Text = "Access all scripts, item spawners, shaders, and laggers."
CardDesc1.Font = Enum.Font.GothamMedium
CardDesc1.TextSize = 10
CardDesc1.TextXAlignment = Enum.TextXAlignment.Left
CardDesc1.ZIndex = 2
CardDesc1.Parent = StealAnEggCard

-- Card 2: Blox Fruit
local BloxFruitCard = Instance.new("TextButton")
BloxFruitCard.Size = UDim2.new(1, 0, 0, 70)
BloxFruitCard.BackgroundColor3 = Color3.fromRGB(20, 28, 40)
BloxFruitCard.TextColor3 = Color3.fromRGB(255, 255, 255)
BloxFruitCard.Text = ""
BloxFruitCard.AutoButtonColor = false
BloxFruitCard.ZIndex = 2
BloxFruitCard.Parent = SelectContainer

local CardCorner2 = Instance.new("UICorner")
CardCorner2.CornerRadius = UDim.new(0, 6)
CardCorner2.Parent = BloxFruitCard

local CardStroke2 = Instance.new("UIStroke")
CardStroke2.Color = Color3.fromRGB(60, 140, 240)
CardStroke2.Thickness = 1.2
CardStroke2.Parent = BloxFruitCard

local CardTitle2 = Instance.new("TextLabel")
CardTitle2.Size = UDim2.new(1, -20, 0, 24)
CardTitle2.Position = UDim2.new(0, 10, 0, 10)
CardTitle2.BackgroundTransparency = 1
CardTitle2.TextColor3 = Color3.fromRGB(255, 255, 255)
CardTitle2.Text = "BLOX FRUIT"
CardTitle2.Font = Enum.Font.FredokaOne
CardTitle2.TextSize = 14
CardTitle2.TextXAlignment = Enum.TextXAlignment.Left
CardTitle2.ZIndex = 2
CardTitle2.Parent = BloxFruitCard

local CardDesc2 = Instance.new("TextLabel")
CardDesc2.Size = UDim2.new(1, -20, 0, 20)
CardDesc2.Position = UDim2.new(0, 10, 0, 36)
CardDesc2.BackgroundTransparency = 1
CardDesc2.TextColor3 = Color3.fromRGB(160, 180, 200)
CardDesc2.Text = "Access auto farm, raid scripts, fruit notifier, and ESP."
CardDesc2.Font = Enum.Font.GothamMedium
CardDesc2.TextSize = 10
CardDesc2.TextXAlignment = Enum.TextXAlignment.Left
CardDesc2.ZIndex = 2
CardDesc2.Parent = BloxFruitCard

-- ==========================================
-- MAIN HUBS SETUP
-- ==========================================
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.fromOffset(520, 360)
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -180)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 20, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = true
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(60, 140, 240)
UIStroke.Thickness = 1.8
UIStroke.Parent = MainFrame

local MainBgImage = Instance.new("ImageLabel")
MainBgImage.Size = UDim2.new(1, 0, 1, 0)
MainBgImage.BackgroundTransparency = 1
MainBgImage.Image = "rbxassetid://124125593087369"
MainBgImage.ImageTransparency = 0.4
MainBgImage.ScaleType = Enum.ScaleType.Slice
MainBgImage.ZIndex = 0
MainBgImage.Parent = MainFrame

local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 32)
TitleBar.BackgroundColor3 = Color3.fromRGB(18, 28, 45)
TitleBar.BorderSizePixel = 0
TitleBar.ZIndex = 2
TitleBar.Parent = MainFrame

local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(1, -260, 1, 0)
TitleText.Position = UDim2.new(0, 12, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.TextColor3 = Color3.fromRGB(90, 170, 255)
TitleText.Text = "JOSHBNS CRACK HUB | PREMIUM v1.0"
TitleText.Font = Enum.Font.FredokaOne
TitleText.TextSize = 11
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.ZIndex = 2
TitleText.Parent = TitleBar

local DiscordBtn = Instance.new("TextButton")
DiscordBtn.Size = UDim2.fromOffset(135, 20)
DiscordBtn.Position = UDim2.new(1, -275, 0.5, -10)
DiscordBtn.BackgroundColor3 = Color3.fromRGB(5, 8, 15)
DiscordBtn.BackgroundTransparency = 0.05
DiscordBtn.TextColor3 = Color3.fromRGB(100, 220, 255)
DiscordBtn.Text = "discord.gg/cRXBvaVRg"
DiscordBtn.Font = Enum.Font.GothamBold
DiscordBtn.TextSize = 10
DiscordBtn.AutoButtonColor = false
DiscordBtn.ZIndex = 3
DiscordBtn.Parent = TitleBar

local DiscordCorner = Instance.new("UICorner")
DiscordCorner.CornerRadius = UDim.new(0, 4)
DiscordCorner.Parent = DiscordBtn

local DiscordStroke = Instance.new("UIStroke")
DiscordStroke.Color = Color3.fromRGB(30, 150, 255)
DiscordStroke.Thickness = 1.2
DiscordStroke.Parent = DiscordBtn

DiscordBtn.MouseButton1Click:Connect(function()
    pcall(function()
        if setclipboard then
            setclipboard("discord.gg/cRXBvaVRg")
            DiscordBtn.Text = "Copied Discord!"
            task.wait(1.5)
            DiscordBtn.Text = "discord.gg/cRXBvaVRg"
        end
    end)
end)

local BackToGameSelectBtn = Instance.new("TextButton")
BackToGameSelectBtn.Size = UDim2.fromOffset(45, 20)
BackToGameSelectBtn.Position = UDim2.new(1, -135, 0.5, -10)
BackToGameSelectBtn.BackgroundColor3 = Color3.fromRGB(45, 130, 220)
BackToGameSelectBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
BackToGameSelectBtn.Text = "GAMES"
BackToGameSelectBtn.Font = Enum.Font.GothamBold
BackToGameSelectBtn.TextSize = 8
BackToGameSelectBtn.ZIndex = 2
BackToGameSelectBtn.Parent = TitleBar

local BackCorner = Instance.new("UICorner")
BackCorner.CornerRadius = UDim.new(0, 4)
BackCorner.Parent = BackToGameSelectBtn

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.fromOffset(24, 24)
CloseBtn.Position = UDim2.new(1, -28, 0.5, -12)
CloseBtn.BackgroundTransparency = 1
CloseBtn.TextColor3 = Color3.fromRGB(150, 180, 200)
CloseBtn.Text = "X"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 12
CloseBtn.ZIndex = 2
CloseBtn.Parent = TitleBar

local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.fromOffset(24, 24)
MinimizeBtn.Position = UDim2.new(1, -56, 0.5, -12)
MinimizeBtn.BackgroundTransparency = 1
MinimizeBtn.TextColor3 = Color3.fromRGB(150, 180, 200)
MinimizeBtn.Text = "-"
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.TextSize = 14
MinimizeBtn.ZIndex = 2
MinimizeBtn.Parent = TitleBar

local ToggleButton = Instance.new("ImageButton")
ToggleButton.Size = UDim2.fromOffset(60, 60)
ToggleButton.Position = UDim2.new(0.02, 0, 0.35, 0)
ToggleButton.BackgroundColor3 = Color3.fromRGB(15, 20, 30)
ToggleButton.Image = "rbxassetid://129348495818798"
ToggleButton.ScaleType = Enum.ScaleType.Crop
ToggleButton.Visible = false
ToggleButton.Active = true
ToggleButton.Draggable = true
ToggleButton.ZIndex = 9999
ToggleButton.Parent = ScreenGui

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(1, 0)
ToggleCorner.Parent = ToggleButton

local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Color = Color3.fromRGB(60, 140, 240)
ToggleStroke.Thickness = 2.2
ToggleStroke.Parent = ToggleButton

local Sidebar = Instance.new("ScrollingFrame")
Sidebar.Size = UDim2.new(0, 140, 1, -32)
Sidebar.Position = UDim2.new(0, 0, 0, 32)
Sidebar.BackgroundColor3 = Color3.fromRGB(20, 26, 38)
Sidebar.BackgroundTransparency = 0.3
Sidebar.BorderSizePixel = 0
Sidebar.CanvasSize = UDim2.new(0, 0, 0, 350)
Sidebar.ScrollBarThickness = 3
Sidebar.ZIndex = 2
Sidebar.Parent = MainFrame

local SidebarLayout = Instance.new("UIListLayout")
SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
SidebarLayout.Padding = UDim.new(0, 4)
SidebarLayout.Parent = Sidebar

local SidebarPadding = Instance.new("UIPadding")
SidebarPadding.PaddingTop = UDim.new(0, 8)
SidebarPadding.PaddingLeft = UDim.new(0, 6)
SidebarPadding.PaddingRight = UDim.new(0, 6)
SidebarPadding.Parent = Sidebar

local ContentContainer = Instance.new("Frame")
ContentContainer.Size = UDim2.new(1, -140, 1, -32)
ContentContainer.Position = UDim2.new(0, 140, 0, 32)
ContentContainer.BackgroundTransparency = 1
ContentContainer.ZIndex = 2
ContentContainer.Parent = MainFrame

local StealAnEggContainer = Instance.new("Folder")
StealAnEggContainer.Name = "StealAnEggContainer"
StealAnEggContainer.Parent = ContentContainer

local BloxFruitContainer = Instance.new("Folder")
BloxFruitContainer.Name = "BloxFruitContainer"
BloxFruitContainer.Parent = ContentContainer

local function clearSidebarAndPages()
    Sidebar.Visible = true
    ContentContainer.Size = UDim2.new(1, -140, 1, -32)
    ContentContainer.Position = UDim2.new(0, 140, 0, 32)
    for _, child in pairs(Sidebar:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    for _, child in pairs(StealAnEggContainer:GetChildren()) do
        child:Destroy()
    end
    for _, child in pairs(BloxFruitContainer:GetChildren()) do
        child:Destroy()
    end
end

local function setupStealAnEggHub()
    clearSidebarAndPages()
    TitleText.Text = "JOSHBNS CRACK STEAL AN EGG | PREMIUM"

    local Tabs = {}
    local Pages = {}
    local activeTab = nil

    local function createTab(name, layoutOrder, container)
        local TabButton = Instance.new("TextButton")
        TabButton.Size = UDim2.new(1, 0, 0, 34)
        TabButton.BackgroundColor3 = Color3.fromRGB(28, 38, 55)
        TabButton.BackgroundTransparency = 0.5
        TabButton.TextColor3 = Color3.fromRGB(160, 180, 200)
        TabButton.Text = "  " .. name
        TabButton.Font = Enum.Font.GothamMedium
        TabButton.TextSize = 11
        TabButton.TextXAlignment = Enum.TextXAlignment.Left
        TabButton.LayoutOrder = layoutOrder
        TabButton.ZIndex = 2
        TabButton.Parent = Sidebar

        local TabCorner = Instance.new("UICorner")
        TabCorner.CornerRadius = UDim.new(0, 6)
        TabCorner.Parent = TabButton

        local Page = Instance.new("ScrollingFrame")
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.BorderSizePixel = 0
        Page.CanvasSize = UDim2.new(0, 0, 0, 0)
        Page.ScrollBarThickness = 4
        Page.Visible = false
        Page.ZIndex = 2
        Page.Parent = container

        local PageLayout = Instance.new("UIListLayout")
        PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        PageLayout.Padding = UDim.new(0, 6)
        PageLayout.Parent = Page

        local PagePadding = Instance.new("UIPadding")
        PagePadding.PaddingTop = UDim.new(0, 10)
        PagePadding.PaddingLeft = UDim.new(0, 10)
        PagePadding.PaddingRight = UDim.new(0, 10)
        PagePadding.Parent = Page

        PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Page.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 25)
        end)

        TabButton.MouseButton1Click:Connect(function()
            for _, p in pairs(Pages) do p.Visible = false end
            for _, t in pairs(Tabs) do 
                t.BackgroundColor3 = Color3.fromRGB(28, 38, 55)
                t.BackgroundTransparency = 0.5
                t.TextColor3 = Color3.fromRGB(160, 180, 200)
            end
            Page.Visible = true
            TabButton.BackgroundColor3 = Color3.fromRGB(45, 130, 220)
            TabButton.BackgroundTransparency = 0
            TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        end)

        Tabs[name] = TabButton
        Pages[name] = Page

        if not activeTab then
            activeTab = name
            Page.Visible = true
            TabButton.BackgroundColor3 = Color3.fromRGB(45, 130, 220)
            TabButton.BackgroundTransparency = 0
            TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        end

        return Page
    end

    local KeylessScroll = createTab("KEYLESS", 1, StealAnEggContainer)
    local WithKeyScroll = createTab("HAVE KEY", 2, StealAnEggContainer)
    local ShaderScroll = createTab("SHADER", 3, StealAnEggContainer)
    local SpeedBypassScroll = createTab("SPEED BYPASS", 4, StealAnEggContainer)
    local PingLaggerScroll = createTab("PING LAGGER", 5, StealAnEggContainer)
    local AnimationScroll = createTab("ANIMATION/EMOTE", 6, StealAnEggContainer)
    local MusicScroll = createTab("MUSIC", 7, StealAnEggContainer)

    local function addButton(parent, name, color, callback)
        local Btn = Instance.new("TextButton")
        Btn.Size = UDim2.new(1, 0, 0, 34)
        Btn.BackgroundColor3 = color
        Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        Btn.Text = name
        Btn.Font = Enum.Font.GothamBold
        Btn.TextSize = 10
        Btn.ZIndex = 2
        Btn.Parent = parent

        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0, 5)
        Corner.Parent = Btn

        Btn.MouseButton1Click:Connect(function()
            local tweenInfo = TweenInfo.new(0.06, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            TweenService:Create(Btn, tweenInfo, {Size = UDim2.new(0.97, 0, 0, 30)}):Play()
            task.wait(0.06)
            TweenService:Create(Btn, tweenInfo, {Size = UDim2.new(1, 0, 0, 34)}):Play()
            pcall(callback)
        end)
    end

    addButton(KeylessScroll, "ADDED SOURCE HUB", Color3.fromRGB(40, 110, 200), function()
        task.spawn(function() 
            pcall(function() 
                loadstring(game:HttpGet("https://raw.githubusercontent.com/YOUR_USERNAME/YOUR_REPOSITORY/main/YOUR_SCRIPT.lua"))() 
            end) 
        end)
    end)
    addButton(KeylessScroll, "ANTI-HIT", Color3.fromRGB(40, 110, 200), function()
        task.spawn(function() pcall(function() script_key = "Trial" loadstring(game:HttpGet("https://api.getpolsec.com/scripts/hosted/6582551b42d21c6b7eb55f1d76d8d50ce53cb35592093d6615b5e83437594dc0.lua"))() end) end)
    end)
    addButton(KeylessScroll, "CHILLI HUB", Color3.fromRGB(40, 110, 200), function()
        task.spawn(function() pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/tienkhanh1/spicy/main/Chilli.lua"))() end) end)
    end)
    addButton(KeylessScroll, "RONNEI HUB", Color3.fromRGB(35, 100, 185), function()
        task.spawn(function() pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/elonmod/skibidi/refs/heads/main/Ronneihub-keyless.lua"))() end) end)
    end)
    addButton(KeylessScroll, "TSUO HUB", Color3.fromRGB(30, 90, 170), function()
        task.spawn(function() pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/Tsuo7/TsuoHub/main/stealanegg"))() end) end)
    end)
    addButton(KeylessScroll, "UB HUB", Color3.fromRGB(25, 75, 150), function()
        task.spawn(function() pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/TeamUBHub/UBLoader/refs/heads/main/Loader.lua"))() end) end)
    end)
    addButton(KeylessScroll, "NRL HUB", Color3.fromRGB(45, 120, 215), function()
        task.spawn(function() pcall(function() loadstring(game:HttpGet("https://www.nrlscript.com/raw/y9BUU6LkVW"))() end) end)
    end)
    addButton(KeylessScroll, "ZYPHORA HUB", Color3.fromRGB(35, 105, 190), function()
        task.spawn(function() pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/jdififjhdudis-del/ZZy/refs/heads/main/ZZy.lua"))() end) end)
    end)
    addButton(KeylessScroll, "VXEZES HUB", Color3.fromRGB(25, 80, 160), function()
        task.spawn(function() pcall(function() loadstring(game:HttpGet("https://vxezestudio.online/api/scripts/script_G5CGjqj2X3rOS/stream/init"))() end) end)
    end)
    addButton(KeylessScroll, "VOIDSHELL HUB", Color3.fromRGB(50, 130, 225), function()
        task.spawn(function() pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/VoidShell-null/VoidShell-Hub/refs/heads/main/Scripts/StealAnEgg.luau"))() end) end)
    end)
    addButton(KeylessScroll, "CRZ HUB", Color3.fromRGB(30, 85, 165), function()
        task.spawn(function() pcall(function() loadstring(game:HttpGet("https://flowauth.net/v1/loaders/3c4e87ed34813171b0f8d53a108a7d88.lua"))() end) end)
    end)
    addButton(KeylessScroll, "VINCI TORE HUB", Color3.fromRGB(40, 100, 195), function()
        task.spawn(function() pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/tutorkah104-rgb/Sae/refs/heads/main/Sae.luau"))() end) end)
    end)
    addButton(KeylessScroll, "REZZY HUB", Color3.fromRGB(35, 95, 180), function()
        task.spawn(function()
            pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/Roman666Cabj/Nether/refs/heads/main/RezzyStealAnEgg.lua"))() end)
            if ScreenGui:FindFirstChild("RezzySmallUI") then ScreenGui.RezzySmallUI:Destroy() end

            local RezzySmallUI = Instance.new("Frame")
            RezzySmallUI.Name = "RezzySmallUI"
            RezzySmallUI.Size = UDim2.fromOffset(180, 36)
            RezzySmallUI.Position = UDim2.new(0.5, -90, 0, 15)
            RezzySmallUI.BackgroundColor3 = Color3.fromRGB(15, 20, 30)
            RezzySmallUI.BorderSizePixel = 0
            RezzySmallUI.Active = true
            RezzySmallUI.Draggable = true
            RezzySmallUI.ZIndex = 5
            RezzySmallUI.Parent = ScreenGui

            local SmallCorner = Instance.new("UICorner")
            SmallCorner.CornerRadius = UDim.new(0, 6)
            SmallCorner.Parent = RezzySmallUI

            local SmallStroke = Instance.new("UIStroke")
            SmallStroke.Color = Color3.fromRGB(60, 140, 240)
            SmallStroke.Thickness = 1.5
            SmallStroke.Parent = RezzySmallUI

            local SmallText = Instance.new("TextLabel")
            SmallText.Size = UDim2.new(1, -30, 1, 0)
            SmallText.Position = UDim2.new(0, 10, 0, 0)
            SmallText.BackgroundTransparency = 1
            SmallText.TextColor3 = Color3.fromRGB(255, 255, 255)
            SmallText.Text = "KEY - Rezzy"
            SmallText.Font = Enum.Font.GothamBold
            SmallText.TextSize = 11
            SmallText.TextXAlignment = Enum.TextXAlignment.Left
            SmallText.ZIndex = 5
            SmallText.Parent = RezzySmallUI

            local SmallCloseBtn = Instance.new("TextButton")
            SmallCloseBtn.Size = UDim2.fromOffset(20, 20)
            SmallCloseBtn.Position = UDim2.new(1, -24, 0.5, -10)
            SmallCloseBtn.BackgroundTransparency = 1
            SmallCloseBtn.TextColor3 = Color3.fromRGB(150, 180, 200)
            SmallCloseBtn.Text = "X"
            SmallCloseBtn.Font = Enum.Font.GothamBold
            SmallCloseBtn.TextSize = 11
            SmallCloseBtn.ZIndex = 5
            SmallCloseBtn.Parent = RezzySmallUI

            SmallCloseBtn.MouseButton1Click:Connect(function() RezzySmallUI:Destroy() end)
        end)
    end)
    addButton(KeylessScroll, "SENA HUB", Color3.fromRGB(25, 75, 150), function()
        task.spawn(function() pcall(function() loadstring(game:HttpGet('https://raw.githubusercontent.com/senarblx/sena/refs/heads/main/loaderv2sena'))() end) end)
    end)
    addButton(KeylessScroll, "BLYXO HUB", Color3.fromRGB(35, 95, 185), function()
        task.spawn(function() pcall(function() loadstring(game:HttpGet("https://flowauth.net/v1/loaders/69d3463240384f3a73fbe32c178093a2.lua"))() end) end)
    end)
    addButton(KeylessScroll, "LKZ HUB", Color3.fromRGB(40, 100, 195), function()
        task.spawn(function() pcall(function() loadstring(game:HttpGet("https://api.luarmor.net/files/v4/loaders/65bf3459d87ba3ac46350e154b640929.lua"))() end) end)
    end)
    addButton(KeylessScroll, "ON HUB", Color3.fromRGB(25, 70, 140), function()
        task.spawn(function() pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/davizin713/ONhub/refs/heads/main/script.lua",true))() end) end)
    end)
    addButton(KeylessScroll, "ZEROIN HUB", Color3.fromRGB(45, 120, 215), function()
        task.spawn(function() pcall(function() loadstring(game:HttpGet("https://zeroinhub.com/api/script"))() end) end)
    end)
    addButton(KeylessScroll, "MIRANDA HUB", Color3.fromRGB(30, 85, 165), function()
        task.spawn(function() pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/miirandahub/loader/refs/heads/main/stealaeggs"))() end) end)
    end)
    addButton(KeylessScroll, "BK HUB", Color3.fromRGB(35, 95, 180), function()
        task.spawn(function() pcall(function() loadstring(game:HttpGet("https://api.luarmor.net/files/v4/loaders/9ee4edde227ac85f50872bf9e4226508.lua"))() end) end)
    end)
    addButton(KeylessScroll, "LENNON V2 HUB", Color3.fromRGB(40, 105, 200), function()
        task.spawn(function() pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/lennonxscripts/lennonhubv2/refs/heads/main/stealaneggv2"))() end) end)
    end)
    addButton(KeylessScroll, "FOXNAME HUB", Color3.fromRGB(25, 75, 150), function()
        task.spawn(function() pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/caomod2077/Script/refs/heads/main/Fn-stealanegg.lua"))() end) end)
    end)
    addButton(KeylessScroll, "HOSHI HUB", Color3.fromRGB(45, 120, 215), function()
        task.spawn(function() pcall(function() loadstring(game:HttpGet("https://hoshihub.site/loader.lua"))() end) end)
    end)
    addButton(KeylessScroll, "DECODE HUB", Color3.fromRGB(35, 95, 185), function()
        task.spawn(function() pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/ItzYumi/Decode/refs/heads/main/DE%3ACODE.lua", true))() end) end)
    end)
    addButton(KeylessScroll, "FAKE ADMIN", Color3.fromRGB(40, 100, 195), function()
        task.spawn(function() pcall(function() loadstring(game:HttpGet("https://api.luarmor.net/files/v4/loaders/bf2eaf16a19664e333889d0b779b8a89.lua"))() end) end)
    end)
    addButton(KeylessScroll, "PET SPAWNER", Color3.fromRGB(50, 130, 225), function()
        task.spawn(function() pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/chocolascript-glitch/Chocola-Pet-Spawner-steal-an-egg/refs/heads/main/script.lua"))() end) end)
    end)
    addButton(KeylessScroll, "FAKE GIFT EGG", Color3.fromRGB(30, 85, 165), function()
        task.spawn(function() pcall(function() loadstring(game:HttpGet("https://api.luarmor.net/files/v4/loaders/bbfc055ca9dcc305d6433cfffac95fe8.lua"))() end) end)
    end)
    addButton(KeylessScroll, "FAKE TRADE", Color3.fromRGB(40, 100, 195), function()
        task.spawn(function() pcall(function() loadstring(game:HttpGet("https://api.luarmor.net/files/v4/loaders/d8f1c691a58edb11ef782849f80e9b61.lua"))() end) end)
    end)
    addButton(KeylessScroll, "PS SERVER HUB", Color3.fromRGB(35, 95, 185), function()
        task.spawn(function() pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/raw-roblox/PrivateServerBypass/refs/heads/main/lua"))() end) end)
    end)

    addButton(WithKeyScroll, "FYY HUB", Color3.fromRGB(25, 75, 150), function()
        task.spawn(function() pcall(function() loadstring(game:HttpGet("https://FyyCommunity.my.id"))() end) end)
    end)
    addButton(WithKeyScroll, "CLOVER HUB", Color3.fromRGB(45, 120, 215), function()
        task.spawn(function() pcall(function() loadstring(game:HttpGet("https://cloverhub.app/clover.lua"))() end) end)
    end)
    addButton(WithKeyScroll, "BIGFROOT HUB", Color3.fromRGB(35, 95, 185), function()
        task.spawn(function() pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/hanniii1/Loader/refs/heads/main/BFLoader.lua"))() end) end)
    end)
    addButton(WithKeyScroll, "SPEED X HUB", Color3.fromRGB(40, 100, 195), function()
        task.spawn(function() pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua", true))() end) end)
    end)
    addButton(WithKeyScroll, "NASI RENDANG HUB", Color3.fromRGB(25, 70, 140), function()
        task.spawn(function() pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/JualNasiRendang/loader/refs/heads/main/main.lua"))() end) end)
    end)
    addButton(WithKeyScroll, "AIRFLOW HUB", Color3.fromRGB(45, 120, 215), function()
        task.spawn(function() pcall(function() loadstring(game:HttpGet("https://airflowscript.com/loader"))() end) end)
    end)
    addButton(WithKeyScroll, "SPORTSCLUB HUB", Color3.fromRGB(30, 85, 165), function()
        task.spawn(function() pcall(function() loadstring(game:HttpGet("https://loader.sportsclub.fun/loader.luau"))() end) end)
    end)
    addButton(WithKeyScroll, "OXIDE HUB", Color3.fromRGB(40, 100, 195), function()
        task.spawn(function() pcall(function() loadstring(game:HttpGet("https://pastefy.app/aIzaPmW9/raw"))() end) end)
    end)
    addButton(WithKeyScroll, "CHIYO HUB", Color3.fromRGB(40, 105, 200), function()
        task.spawn(function() pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/kaisenlmao/loader/refs/heads/main/chiyo.lua"))() end) end)
    end)
    addButton(WithKeyScroll, "OMG HUB", Color3.fromRGB(25, 75, 150), function()
        task.spawn(function() pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/Omgshit/Scripts/main/MainLoader.lua"))() end) end)
    end)
    addButton(WithKeyScroll, "SNOWY HUB", Color3.fromRGB(45, 120, 215), function()
        task.spawn(function() pcall(function() loadstring(game:HttpGet("https://flowauth.net/v1/ui/a87f00d9adf63658655fcd02ab86a4ef.lua"))() end) end)
    end)
    addButton(WithKeyScroll, "SOLIX HUB", Color3.fromRGB(35, 95, 185), function()
        task.spawn(function() pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/bao8jl/solixhub/main/loader"))() end) end)
    end)
    addButton(WithKeyScroll, "AJJANS HUB", Color3.fromRGB(40, 100, 195), function()
        task.spawn(function() pcall(function() loadstring(game:HttpGet("https://api.luarmor.net/files/v4/loaders/36107afd3107e8d841f9d1a69e2465d4.lua"))() end) end)
    end)

    addButton(ShaderScroll, "KEYLESS SHADER", Color3.fromRGB(35, 95, 180), function()
        task.spawn(function() pcall(function() loadstring(game:HttpGet('https://raw.githubusercontent.com/randomstring0/pshade-ultimate/refs/heads/main/src/cd.lua'))() end) end)
    end)
    addButton(ShaderScroll, "KEYLESS SHADER V1", Color3.fromRGB(25, 75, 150), function()
        task.spawn(function() pcall(function() loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Simple-Shader-37434"))() end) end)
    end)
    addButton(ShaderScroll, "KEYLESS SHADER V3", Color3.fromRGB(45, 120, 215), function()
        task.spawn(function() pcall(function() loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Shader-V3-38521"))() end) end)
    end)
    addButton(ShaderScroll, "UNIVERS HUB GRAPHICS", Color3.fromRGB(35, 95, 185), function()
        task.spawn(function() pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/Uranus197/-Univers-Hub-Graphics-Script-/refs/heads/main/UniversHub"))() end) end)
    end)

    local speedBoostValue = 20
    local tweenSpeedValue = 50

    local function addConfigurableInput(parent, labelText, initialValue, callback)
        local Container = Instance.new("Frame")
        Container.Size = UDim2.new(1, 0, 0, 48)
        Container.BackgroundColor3 = Color3.fromRGB(20, 28, 40)
        Container.ZIndex = 2
        Container.Parent = parent

        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0, 5)
        Corner.Parent = Container

        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, -90, 1, 0)
        Label.Position = UDim2.new(0, 10, 0, 0)
        Label.BackgroundTransparency = 1
        Label.TextColor3 = Color3.fromRGB(255, 255, 255)
        Label.Text = labelText
        Label.Font = Enum.Font.GothamBold
        Label.TextSize = 10
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.ZIndex = 2
        Label.Parent = Container

        local TextBox = Instance.new("TextBox")
        TextBox.Size = UDim2.fromOffset(70, 28)
        TextBox.Position = UDim2.new(1, -78, 0.5, -14)
        TextBox.BackgroundColor3 = Color3.fromRGB(30, 40, 60)
        TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
        TextBox.Text = tostring(initialValue)
        TextBox.Font = Enum.Font.GothamBold
        TextBox.TextSize = 11
        TextBox.ClearTextOnFocus = false
        TextBox.ZIndex = 2
        TextBox.Parent = Container

        local BoxCorner = Instance.new("UICorner")
        BoxCorner.CornerRadius = UDim.new(0, 4)
        BoxCorner.Parent = TextBox

        TextBox.FocusLost:Connect(function()
            local num = tonumber(TextBox.Text)
            if num then
                num = math.clamp(num, 1, 120)
                TextBox.Text = tostring(num)
                callback(num)
            else
                TextBox.Text = tostring(initialValue)
            end
        end)
    end

    addConfigurableInput(SpeedBypassScroll, "SPEED BOOST (WALKSPEED & JP) [1-120]", speedBoostValue, function(val)
        speedBoostValue = val
    end)

    addButton(SpeedBypassScroll, "ACTIVATE SPEED BOOST", Color3.fromRGB(45, 120, 215), function()
        task.spawn(function()
            pcall(function()
                local RunService = game:GetService("RunService")
                if _G.SpeedBoostConnection then
                    _G.SpeedBoostConnection:Disconnect()
                end
                _G.SpeedBoostConnection = RunService.RenderStepped:Connect(function()
                    local char = LocalPlayer.Character
                    if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChildOfClass("Humanoid") then
                        local hrp = char.HumanoidRootPart
                        local hum = char:FindFirstChildOfClass("Humanoid")
                        hum.WalkSpeed = speedBoostValue
                        hum.JumpPower = math.clamp(speedBoostValue * 1.2, 50, 120)
                        hum.UseJumpPower = true
                        if hum.MoveDirection.Magnitude > 0 then
                            local currentVel = hrp.AssemblyLinearVelocity
                            local targetVelocity = hum.MoveDirection * math.min(speedBoostValue, 120)
                            hrp.AssemblyLinearVelocity = Vector3.new(targetVelocity.X, currentVel.Y, targetVelocity.Z)
                        end
                    end
                end)
            end)
        end)
    end)

    addConfigurableInput(SpeedBypassScroll, "TWEEN SPEED BYPASS VALUE [1-1000]", tweenSpeedValue, function(val)
        tweenSpeedValue = val
    end)

    addButton(SpeedBypassScroll, "ACTIVATE TWEEN SPEED BYPASS", Color3.fromRGB(35, 100, 185), function()
        task.spawn(function()
            pcall(function()
                local RunService = game:GetService("RunService")
                if _G.TweenBypassConnection then
                    _G.TweenBypassConnection:Disconnect()
                end
                _G.TweenBypassConnection = RunService.Heartbeat:Connect(function(dt)
                    local char = LocalPlayer.Character
                    if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChildOfClass("Humanoid") then
                        local hrp = char.HumanoidRootPart
                        local hum = char:FindFirstChildOfClass("Humanoid")
                        if hum.MoveDirection.Magnitude > 0 then
                            local multiplier = math.clamp(tweenSpeedValue / 15, 1, 35)
                            local targetPos = hrp.Position + (hum.MoveDirection * multiplier * dt * 60)
                            local newCFrame = CFrame.new(targetPos, targetPos + hrp.CFrame.LookVector)
                            hrp.CFrame = hrp.CFrame:Lerp(newCFrame, 0.45)
                        end
                    end
                end)
            end)
        end)
    end)

    addButton(SpeedBypassScroll, "SPEED BYPASS V1", Color3.fromRGB(35, 95, 185), function()
        task.spawn(function()
            pcall(function()
                local RunService = game:GetService("RunService")
                RunService.Stepped:Connect(function()
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        local hrp = LocalPlayer.Character.HumanoidRootPart
                        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                        if hum and hum.MoveDirection.Magnitude > 0 then
                            hrp.CFrame = hrp.CFrame:Lerp(hrp.CFrame + (hum.MoveDirection * 0.5), 0.7)
                        end
                    end
                end)
            end)
        end)
    end)

    addButton(SpeedBypassScroll, "SPEED BYPASS V2 (CFRAME)", Color3.fromRGB(30, 85, 165), function()
        task.spawn(function()
            pcall(function()
                local RunService = game:GetService("RunService")
                RunService.Heartbeat:Connect(function()
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        local hrp = LocalPlayer.Character.HumanoidRootPart
                        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                        if hum and hum.MoveDirection.Magnitude > 0 then
                            hrp.CFrame = hrp.CFrame:Lerp(hrp.CFrame + (hum.MoveDirection * 1.2), 0.7)
                        end
                    end
                end)
            end)
        end)
    end)

    addButton(PingLaggerScroll, "RIFT LAGGER V1 KEYLESS", Color3.fromRGB(40, 100, 195), function()
        task.spawn(function() getgenv().script_key = "trial" pcall(function() loadstring(game:HttpGet("https://api.getpolsec.com/scripts/hosted/54a45ce90e56387bfc6957d4ff82ef9602ad501d94be449722c82047286265a2.lua"))() end) end)
    end)
    addButton(PingLaggerScroll, "RIFT LAGGER V2 KEYLESS", Color3.fromRGB(35, 85, 165), function()
        task.spawn(function() getgenv().script_key = "trial" pcall(function() loadstring(game:HttpGet("https://api.getpolsec.com/scripts/hosted/bdfe11b74cf289f8e42386e53965f1d9bbd24f7d0f3d353df2315487c90fd2d3.lua"))() end) end)
    end)

    addButton(AnimationScroll, "Animation keyless", Color3.fromRGB(40, 105, 200), function()
        task.spawn(function() pcall(function() loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-7yd7-I-Emote-Script-48024"))() end) end)
    end)

    addButton(MusicScroll, "MUSIC SELECTOR KEYLESS", Color3.fromRGB(35, 95, 185), function()
        task.spawn(function() pcall(function() loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-YouTube-Music-Player-V8-236600"))() end) end)
    end)
end

local function setupBloxFruitHub()
    clearSidebarAndPages()
    TitleText.Text = "JOSHBNS CRACK BLOX FRUIT | PREMIUM"

    Sidebar.Visible = false
    ContentContainer.Size = UDim2.new(1, 0, 1, -32)
    ContentContainer.Position = UDim2.new(0, 0, 0, 32)

    local SinglePage = Instance.new("ScrollingFrame")
    SinglePage.Size = UDim2.new(1, 0, 1, 0)
    SinglePage.BackgroundTransparency = 1
    SinglePage.BorderSizePixel = 0
    SinglePage.CanvasSize = UDim2.new(0, 0, 0, 0)
    SinglePage.ScrollBarThickness = 4
    SinglePage.Visible = true
    SinglePage.ZIndex = 2
    SinglePage.Parent = BloxFruitContainer

    local PageLayout = Instance.new("UIListLayout")
    PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    PageLayout.Padding = UDim.new(0, 6)
    PageLayout.Parent = SinglePage

    local PagePadding = Instance.new("UIPadding")
    PagePadding.PaddingTop = UDim.new(0, 10)
    PagePadding.PaddingLeft = UDim.new(0, 10)
    PagePadding.PaddingRight = UDim.new(0, 10)
    PagePadding.Parent = SinglePage

    PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        SinglePage.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 25)
    end)

    local function addButton(parent, name, color, callback)
        local Btn = Instance.new("TextButton")
        Btn.Size = UDim2.new(1, 0, 0, 34)
        Btn.BackgroundColor3 = color
        Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        Btn.Text = name
        Btn.Font = Enum.Font.GothamBold
        Btn.TextSize = 10
        Btn.ZIndex = 2
        Btn.Parent = parent

        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0, 5)
        Corner.Parent = Btn

        Btn.MouseButton1Click:Connect(function()
            local tweenInfo = TweenInfo.new(0.06, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            TweenService:Create(Btn, tweenInfo, {Size = UDim2.new(0.97, 0, 0, 30)}):Play()
            task.wait(0.06)
            TweenService:Create(Btn, tweenInfo, {Size = UDim2.new(1, 0, 0, 34)}):Play()
            pcall(callback)
        end)
    end

    addButton(SinglePage, "ONION HUB", Color3.fromRGB(45, 110, 210), function()
        task.spawn(function() pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/onion132005-bit/esponion.lua/refs/heads/main/onion13v9.lua"))() end) end)
    end)
    addButton(SinglePage, "QUANTUM ONYX HUB", Color3.fromRGB(40, 100, 195), function()
        task.spawn(function() pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/flazhy/QuantumOnyx/refs/heads/main/QuantumOnyx.lua"))() end) end)
    end)
    addButton(SinglePage, "HERMANOS HUB", Color3.fromRGB(25, 75, 150), function()
        task.spawn(function() pcall(function() getgenv().SCRIPT_KEY = "KEYLESS" loadstring(game:HttpGet("https://api.luapolsec.top/files/v4/loaders/f980e8a1433349b5a296f864fa7b55bc.lua"))() end) end)
    end)
    addButton(SinglePage, "NIGHT HUB", Color3.fromRGB(45, 120, 215), function()
        task.spawn(function() pcall(function() loadstring(game:HttpGet("https://github.com/WhiteX1208/Scripts/blob/main/HopScript.luau?raw=true"))() end) end)
    end)
    addButton(SinglePage, "REDZ HUB", Color3.fromRGB(35, 95, 185), function()
        task.spawn(function() pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/luraobermeyer-jpg/redzhub/refs/heads/main/redzhub.lua.txt"))() end) end)
    end)
    addButton(SinglePage, "BLUE X HUB", Color3.fromRGB(40, 100, 195), function()
        task.spawn(function() pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/Dev-BlueX/BlueX-Hub/refs/heads/main/Main.lua"))() end) end)
    end)
    addButton(SinglePage, "ALCHEMY HUB", Color3.fromRGB(35, 95, 185), function()
        task.spawn(function() pcall(function() loadstring(game:HttpGet("https://scripts.alchemyhub.xyz"))() end) end)
    end)
    addButton(SinglePage, "BANANA HUB", Color3.fromRGB(25, 75, 150), function()
        task.spawn(function() pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/aloaloalo322/sssdas/refs/heads/main/cc"))() end) end)
    end)
    addButton(SinglePage, "AURORA HUB", Color3.fromRGB(45, 120, 215), function()
        task.spawn(function() pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/bloxfruitsnokey/Stellar/refs/heads/main/Aurora/script.luau"))() end) end)
    end)
    addButton(SinglePage, "LINKHIVE HUB", Color3.fromRGB(30, 85, 165), function()
        task.spawn(function() pcall(function() loadstring(game:HttpGet("https://link-hive-scripts.vercel.app/api/loader"))() end) end)
    end)
    addButton(SinglePage, "KUSHI HUB", Color3.fromRGB(40, 100, 195), function()
        task.spawn(function() pcall(function() loadstring(game:HttpGet("https://vss.pandauth.com/kv/e0ce5a677b322621"))() end) end)
    end)
    addButton(SinglePage, "RUBY HUB", Color3.fromRGB(35, 95, 185), function()
        task.spawn(function() pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/bloxfruitsnokey/Redz/refs/heads/main/Ruby/script.lua"))() end) end)
    end)
    addButton(SinglePage, "ECLIPSE HUB", Color3.fromRGB(25, 75, 150), function()
        task.spawn(function() pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/bloxfruitsnokey/Stellar/refs/heads/main/Eclipse/script.luau"))() end) end)
    end)
    addButton(SinglePage, "STYX HUB", Color3.fromRGB(45, 110, 210), function()
        task.spawn(function() pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/ToshyWare/StyxzHub/main/Styxz.lua"))() end) end)
    end)
    addButton(SinglePage, "OMG HUB", Color3.fromRGB(50, 130, 225), function()
        task.spawn(function() pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/Omgshit/Scripts/main/MainLoader.lua"))() end) end)
    end)
    addButton(SinglePage, "GRAVITY HUB", Color3.fromRGB(45, 110, 210), function()
        task.spawn(function() pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/Dev-GravityHub/BloxFruit/refs/heads/main/MainPremium.lua"))() end) end)
    end)
end

StealAnEggCard.MouseButton1Click:Connect(function()
    GameSelectFrame.Visible = false
    setupStealAnEggHub()
    MainFrame.Visible = true
end)

BloxFruitCard.MouseButton1Click:Connect(function()
    GameSelectFrame.Visible = false
    setupBloxFruitHub()
    MainFrame.Visible = true
end)

BackToGameSelectBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    GameSelectFrame.Visible = true
end)

MinimizeBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    ToggleButton.Visible = true
end)

CloseBtn.MouseButton1Click:Connect(function() 
    ScreenGui:Destroy() 
end)

ToggleButton.MouseButton1Click:Connect(function()
    ToggleButton.Visible = false
    if GameSelectFrame.Visible then
        GameSelectFrame.Visible = false
    end
    MainFrame.Visible = true
end)

UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Insert then
        if MainFrame.Visible or GameSelectFrame.Visible then
            MainFrame.Visible = false
            GameSelectFrame.Visible = false
            ToggleButton.Visible = true
        else
            ToggleButton.Visible = false
            GameSelectFrame.Visible = true
        end
    end
end)

GameSelectFrame.Visible = true
