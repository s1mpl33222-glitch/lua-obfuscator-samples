--[[
    ================================================================
    [ SAIRO SYSTEM | BORDER NEON EDITION V69.9 ]
    • Developer: 1sairo_
    • Description: Added Yaqoot Dhab & Fixed Rare Dhabs Jalmood/Yaqoot ESP.
    ================================================================
]]

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local Stats = game:GetService("Stats")
local TeleportService = game:GetService("TeleportService")
local CoreGuiService = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

if CoreGui:FindFirstChild("Sairo") then
    CoreGui.Sairo:Destroy()
end

local SaveFileName = "SairoSettings_V699.json"
local Settings = {
    DhabAll = false,
    DhabRareOnly = false,
    DhabSpecialActive = false,
    SmartAlerts = true,
    Players = false,
    Vehicles = false,
    EspDistance = 500,
    Aimbot = false,
    AimbotDistance = 50,
    RequireWeapon = true,
    UseFOVCircle = true,
    FOVRadius = 120,
    HoldRightClick = false,
    RareHudActive = false,
    HudPosX = 0.75,
    HudPosY = 0.15,
    AntiAfkActive = true,      
    AutoRejoinActive = true,
    FogDisabled = false
}

pcall(function()
    if writefile and readfile and isfile and isfile(SaveFileName) then
        local decoded = HttpService:JSONDecode(readfile(SaveFileName))
        if type(decoded) == "table" then
            for k, v in pairs(decoded) do
                if Settings[k] ~= nil then Settings[k] = v end
            end
        end
    end
end)

local function SaveSettings()
    pcall(function()
        if writefile then
            writefile(SaveFileName, HttpService:JSONEncode(Settings))
        end
    end)
end

local RedTheme = {
    Background = Color3.fromRGB(12, 7, 10),
    Panel      = Color3.fromRGB(20, 10, 16),
    CardBg     = Color3.fromRGB(28, 14, 22),
    ButtonOff  = Color3.fromRGB(40, 18, 28),
    ButtonOn   = Color3.fromRGB(255, 15, 55),
    Accent     = Color3.fromRGB(255, 10, 45),
    ToggleBgOn = Color3.fromRGB(255, 15, 55),
    ToggleBgOff= Color3.fromRGB(45, 20, 32),
    SoftNeonRed= Color3.fromRGB(180, 20, 45)
}

local Colors = {
    White = Color3.fromRGB(255, 255, 255),
    Muted = Color3.fromRGB(175, 140, 160),
    PlayerColor = Color3.fromRGB(255, 60, 60),
    VehicleColor = Color3.fromRGB(255, 150, 0),
    SpecialDhabColor = Color3.fromRGB(255, 0, 255)
}

local RarityNames = {
    T1 = "عادي", T2 = "مميز", T3 = "نادر", T4 = "فاخر", T5 = "أسطوري", T6 = "خرافي"
}

local StateNames = {
    idle = "واقف 🧍", walk = "يمشي 🚶", flee = "يهرب 🏃", alert = "منتبه ⚠️", display = "يستعرض ✨", peek = "يتلصص 👀"
}

local RarityColors = {
    T1 = Color3.fromRGB(150, 160, 175),
    T2 = Color3.fromRGB(70, 160, 95),
    T3 = Color3.fromRGB(65, 130, 195),
    T4 = Color3.fromRGB(130, 90, 175),
    T5 = Color3.fromRGB(255, 180, 50),
    T6 = Color3.fromRGB(255, 50, 70)
}

-- 👑 القائمة المحدثة والمنقولة خصيصاً لتشمل ضب الياقوت والجلمود وبقية النوادر بدون أي خلل
local SpecialDhabsList = {
    ["gl_jamr_pen"] = "ضب الحمم", ["gl_iamr"] = "ضب الحمم", ["gl_jamr"] = "ضب الحمم",
    ["m_almas_pen"] = "ضب الألماس", ["m_almas"] = "ضب الألماس",
    ["m_tibr_pen"] = "ضب النبر", ["m_tibr"] = "ضب النبر",
    ["thurayya"] = "ضب الثريا",
    ["gm_farqad_pen"] = "ضب الفرقد", ["gm_farqad"] = "ضب الفرقد",
    ["m_kahraman_pen"] = "ضب الكهرمان", ["m_kahraman"] = "ضب الكهرمان",
    ["gm_jalmood_957f62"] = "ضب الجلمود", ["gm_jalmood"] = "ضب الجلمود",
    ["jalmood"] = "ضب الجلمود", ["gl_jalmood"] = "ضب الجلمود",
    ["gm_abusakhr_pen"] = "ضب أبو صخر", ["gm_abusakhr"] = "ضب أبو صخر",
    ["g_zumurrud_pen"] = "ضب الزمرد", ["g_zumurrud"] = "ضب الزمرد",
    ["m_yaqoot_b0f651"] = "ضب الياقوت", ["m_yaqoot"] = "ضب الياقوت"
}

local CachedDhabs = {}
local NotifiedRareDhabs = {}
local LastKnownStates = {}
local ActiveESP = {}

local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1.5
FOVCircle.Color = RedTheme.Accent
FOVCircle.Filled = false
FOVCircle.Transparency = 0.7
FOVCircle.Visible = false

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Sairo"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = CoreGui

local NotifySound = Instance.new("Sound", ScreenGui)
NotifySound.SoundId = "rbxassetid://4590657391"
NotifySound.Volume = 0.4

-- 👑 رادار الضبان النادرة (HUD)
local RareHud = Instance.new("Frame", ScreenGui)
RareHud.Name = "RareHud"
RareHud.Size = UDim2.new(0, 260, 0, 90)
RareHud.Position = UDim2.new(Settings.HudPosX, 0, Settings.HudPosY, 0)
RareHud.BackgroundColor3 = RedTheme.Panel
RareHud.BorderSizePixel = 0
RareHud.Visible = Settings.RareHudActive
RareHud.Active = true
Instance.new("UICorner", RareHud).CornerRadius = UDim.new(0, 12)

local RareHudStroke = Instance.new("UIStroke", RareHud)
RareHudStroke.Color = RedTheme.Accent
RareHudStroke.Thickness = 2.2

local RareHudTitle = Instance.new("TextLabel", RareHud)
RareHudTitle.Size = UDim2.new(1, 0, 0, 28)
RareHudTitle.BackgroundTransparency = 1
RareHudTitle.Text = "👑 رادار الضبان النادرة (T5 & T6)"
RareHudTitle.TextColor3 = RedTheme.Accent
RareHudTitle.TextSize = 12
RareHudTitle.Font = Enum.Font.GothamBold

local RareHudContent = Instance.new("TextLabel", RareHud)
RareHudContent.Size = UDim2.new(1, -16, 1, -34)
RareHudContent.Position = UDim2.new(0, 8, 0, 30)
RareHudContent.BackgroundTransparency = 1
RareHudContent.Text = "جاري البحث عن ضب أسطوري أو خرافي قريب..."
RareHudContent.TextColor3 = Colors.White
RareHudContent.TextSize = 11
RareHudContent.Font = Enum.Font.GothamMedium
RareHudContent.TextWrapped = true
RareHudContent.TextXAlignment = Enum.TextXAlignment.Right
RareHudContent.TextYAlignment = Enum.TextYAlignment.Top

local HudDragging, HudDragStart, HudStartPosition = false, nil, nil
RareHud.InputBegan:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
        HudDragging = true
        HudDragStart = Input.Position
        HudStartPosition = RareHud.Position
        Input.Changed:Connect(function()
            if Input.UserInputState == Enum.UserInputState.End then 
                HudDragging = false 
                Settings.HudPosX = RareHud.Position.X.Scale
                Settings.HudPosY = RareHud.Position.Y.Scale
                SaveSettings()
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(Input)
    if HudDragging and (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) then
        local Delta = Input.Position - HudDragStart
        RareHud.Position = UDim2.new(HudStartPosition.X.Scale, HudStartPosition.X.Offset + Delta.X, HudStartPosition.Y.Scale, HudStartPosition.Y.Offset + Delta.Y)
    end
end)

-- 🔴 الإطار الرئيسي
local Main = Instance.new("Frame", ScreenGui)
Main.Name = "Main"
Main.Size = UDim2.new(0, 560, 0, 380)
Main.Position = UDim2.new(0.5, -280, 0.5, -190)
Main.BackgroundColor3 = RedTheme.Background
Main.BorderSizePixel = 0
Main.Visible = true
Main.Active = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 18)

local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Color = RedTheme.Accent
MainStroke.Thickness = 3

local Header = Instance.new("Frame", Main)
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 52)
Header.BackgroundColor3 = RedTheme.Panel
Header.BorderSizePixel = 0
Header.Active = true
Header.ZIndex = 2
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 18)

local OverlapLogoBg = Instance.new("Frame", Main)
OverlapLogoBg.Name = "OverlapLogoBg"
OverlapLogoBg.Size = UDim2.new(0, 70, 0, 70)
OverlapLogoBg.Position = UDim2.new(0, -12, 0, -14)
OverlapLogoBg.BackgroundColor3 = RedTheme.Background
OverlapLogoBg.ZIndex = 10
Instance.new("UICorner", OverlapLogoBg).CornerRadius = UDim.new(1, 0)

local OverlapLogoStroke = Instance.new("UIStroke", OverlapLogoBg)
OverlapLogoStroke.Thickness = 3.5
OverlapLogoStroke.Color = RedTheme.Accent

local HeaderLogo = Instance.new("ImageLabel", OverlapLogoBg)
HeaderLogo.Size = UDim2.new(1, -6, 1, -6)
HeaderLogo.Position = UDim2.new(0, 3, 0, 3)
HeaderLogo.BackgroundTransparency = 1
HeaderLogo.Image = "rbxassetid://98971861944581"
HeaderLogo.ZIndex = 11
Instance.new("UICorner", HeaderLogo).CornerRadius = UDim.new(1, 0)

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, -80, 1, 0)
Title.Position = UDim2.new(0, 72, 0, 0)
Title.BackgroundTransparency = 1
Title.RichText = true
Title.Text = 'SAIRO SYSTEM <font color="#FF0A2D">V69.9</font>'
Title.TextColor3 = Colors.White
Title.TextSize = 14
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left

local StatsFrame = Instance.new("Frame", Header)
StatsFrame.Size = UDim2.new(0, 150, 0, 30)
StatsFrame.Position = UDim2.new(1, -160, 0.5, -15)
StatsFrame.BackgroundColor3 = Color3.fromRGB(15, 6, 11)
StatsFrame.BorderSizePixel = 0
Instance.new("UICorner", StatsFrame).CornerRadius = UDim.new(0, 8)

local FpsLabel = Instance.new("TextLabel", StatsFrame)
FpsLabel.Size = UDim2.new(0.5, -2, 1, 0)
FpsLabel.BackgroundTransparency = 1
FpsLabel.Text = "FPS: 60"
FpsLabel.TextColor3 = RedTheme.Accent
FpsLabel.TextSize = 10
FpsLabel.Font = Enum.Font.GothamBold

local PingLabel = Instance.new("TextLabel", StatsFrame)
PingLabel.Size = UDim2.new(0.5, -2, 1, 0)
PingLabel.Position = UDim2.new(0.5, 2, 0, 0)
PingLabel.BackgroundTransparency = 1
PingLabel.Text = "Ping: 45ms"
PingLabel.TextColor3 = Colors.Muted
PingLabel.TextSize = 10
PingLabel.Font = Enum.Font.GothamBold

task.spawn(function()
    while task.wait(1) do
        pcall(function()
            local fps = math.floor(1 / RunService.RenderStepped:Wait())
            local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
            FpsLabel.Text = "FPS: " .. fps
            PingLabel.Text = "Ping: " .. ping .. "ms"
        end)
    end
end)

local AlertBox = Instance.new("TextLabel", ScreenGui)
AlertBox.Size = UDim2.new(0, 380, 0, 45)
AlertBox.Position = UDim2.new(0.5, -190, 0.05, 0)
AlertBox.BackgroundColor3 = Color3.fromRGB(255, 20, 50)
AlertBox.TextColor3 = Colors.White
AlertBox.TextSize = 13
AlertBox.Font = Enum.Font.GothamBold
AlertBox.Text = "🚨 تنبيه: تم رصد ضب أسطوري/خرافي قريب منك!"
AlertBox.Visible = false
Instance.new("UICorner", AlertBox).CornerRadius = UDim.new(0, 10)

local Toggle = Instance.new("ImageButton", ScreenGui)
Toggle.Name = "OpenButton"
Toggle.BackgroundColor3 = RedTheme.Background
Toggle.Image = "rbxassetid://98971861944581"
Toggle.Size = UDim2.new(0, 56, 0, 56)
Toggle.Position = UDim2.new(0, 12, 0.5, -28)
Toggle.Active = true
Instance.new("UICorner", Toggle).CornerRadius = UDim.new(1, 0)

local ToggleStroke = Instance.new("UIStroke", Toggle)
ToggleStroke.Color = RedTheme.Accent
ToggleStroke.Thickness = 3

local ToggleDragging, ToggleDragStart, ToggleStartPosition, DistanceMoved = false, nil, nil, 0
Toggle.MouseButton1Down:Connect(function()
    ToggleDragging = true
    ToggleDragStart = UserInputService:GetMouseLocation()
    ToggleStartPosition = Toggle.AbsolutePosition
    DistanceMoved = 0
end)

UserInputService.InputChanged:Connect(function(Input)
    if ToggleDragging and (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) then
        local Delta = UserInputService:GetMouseLocation() - ToggleDragStart
        DistanceMoved = Delta.Magnitude
        Toggle.Position = UDim2.new(0, ToggleStartPosition.X + Delta.X, 0, ToggleStartPosition.Y + Delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(Input)
    if ToggleDragging and (Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch) then
        ToggleDragging = false
        if DistanceMoved < 5 then Main.Visible = not Main.Visible end
    end
end)

UserInputService.InputBegan:Connect(function(Input, GameProcessed)
    if not GameProcessed and Input.KeyCode == Enum.KeyCode.RightControl then
        Main.Visible = not Main.Visible
    end
end)

local Dragging, DragInput, DragStart, StartPosition = false, nil, nil, nil
Header.InputBegan:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
        Dragging = true
        DragStart = Input.Position
        StartPosition = Main.Position
        Input.Changed:Connect(function()
            if Input.UserInputState == Enum.UserInputState.End then Dragging = false end
        end)
    end
end)

Header.InputChanged:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
        DragInput = Input
    end
end)

UserInputService.InputChanged:Connect(function(Input)
    if Dragging and Input == DragInput then
        local Delta = Input.Position - DragStart
        Main.Position = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)
    end
end)

local NavBar = Instance.new("Frame", Main)
NavBar.Size = UDim2.new(0, 145, 1, -66)
NavBar.Position = UDim2.new(0, 10, 0, 58)
NavBar.BackgroundColor3 = RedTheme.Panel
NavBar.BorderSizePixel = 0
Instance.new("UICorner", NavBar).CornerRadius = UDim.new(0, 14)

local NavBarStroke = Instance.new("UIStroke", NavBar)
NavBarStroke.Color = RedTheme.Accent
NavBarStroke.Thickness = 2.2

local PagesFolder = Instance.new("Frame", Main)
PagesFolder.Size = UDim2.new(1, -175, 1, -66)
PagesFolder.Position = UDim2.new(0, 165, 0, 58)
PagesFolder.BackgroundTransparency = 1

local Pages = {}
local function CreatePage(PageName)
    local Page = Instance.new("ScrollingFrame", PagesFolder)
    Page.Name = PageName
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.CanvasSize = UDim2.new(0, 0, 0, 420)
    Page.ScrollBarThickness = 3
    Page.Visible = false
    Pages[PageName] = Page
    return Page
end

local InfoPage = CreatePage("Info")
local EspPage = CreatePage("ESP")
local AimPage = CreatePage("Aimbot")
local TeleportPage = CreatePage("Teleport")
local UtilsPage = CreatePage("Utils")
local SettingsPage = CreatePage("Settings")
local SairoHubPage = CreatePage("SairoHub")

local AllButtons = {}

local function SelectTab(TargetPageName, TargetButton)
    for pageName, pageFrame in pairs(Pages) do
        pageFrame.Visible = (pageName == TargetPageName)
    end
    for _, btnObj in pairs(AllButtons) do
        local isSelected = (btnObj == TargetButton)
        TweenService:Create(btnObj, TweenInfo.new(0.2), {
            BackgroundColor3 = isSelected and RedTheme.ButtonOn or RedTheme.ButtonOff,
            TextColor3 = isSelected and Colors.White or Colors.Muted
        }):Play()
    end
end

local function CreateNavButton(Name, Text, Y, TargetPage)
    local Btn = Instance.new("TextButton", NavBar)
    Btn.Size = UDim2.new(1, -12, 0, 32)
    Btn.Position = UDim2.new(0, 6, 0, Y)
    Btn.BackgroundColor3 = RedTheme.ButtonOff
    Btn.Text = Text
    Btn.TextColor3 = Colors.Muted
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 10
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 8)

    Btn.MouseButton1Click:Connect(function()
        SelectTab(TargetPage, Btn)
    end)
    table.insert(AllButtons, Btn)
    return Btn
end

local InfoBtn = CreateNavButton("Info", "🏠 المعلومات", 6, "Info")
local EspBtn = CreateNavButton("ESP", "👁️ قائمة ESP", 42, "ESP")
local AimBtn = CreateNavButton("Aimbot", "🎯 الايمبوت", 78, "Aimbot")
local TeleportBtn = CreateNavButton("Teleport", "🚀 قائمة الانتقال", 114, "Teleport")
local UtilsBtn = CreateNavButton("Utils", "🛠️ أدوات اللاعب", 150, "Utils")

local SubBar = Instance.new("Frame", NavBar)
SubBar.Size = UDim2.new(1, -12, 0, 30)
SubBar.Position = UDim2.new(0, 6, 1, -36)
SubBar.BackgroundTransparency = 1

local SettingsBtn = Instance.new("TextButton", SubBar)
SettingsBtn.Size = UDim2.new(0.48, 0, 1, 0)
SettingsBtn.BackgroundColor3 = Color3.fromRGB(35, 14, 25)
SettingsBtn.Text = "⚙️ الإعدادات"
SettingsBtn.TextColor3 = Colors.Muted
SettingsBtn.Font = Enum.Font.GothamBold
SettingsBtn.TextSize = 8.5
Instance.new("UICorner", SettingsBtn).CornerRadius = UDim.new(0, 6)
SettingsBtn.MouseButton1Click:Connect(function()
    SelectTab("Settings", SettingsBtn)
end)
table.insert(AllButtons, SettingsBtn)

local SairoHubBtn = Instance.new("TextButton", SubBar)
SairoHubBtn.Size = UDim2.new(0.48, 0, 1, 0)
SairoHubBtn.Position = UDim2.new(0.52, 0, 0, 0)
SairoHubBtn.BackgroundColor3 = Color3.fromRGB(35, 14, 25)
SairoHubBtn.Text = "⚡ Sairo Hub"
SairoHubBtn.TextColor3 = Colors.Muted
SairoHubBtn.Font = Enum.Font.GothamBold
SairoHubBtn.TextSize = 8.5
Instance.new("UICorner", SairoHubBtn).CornerRadius = UDim.new(0, 6)
SairoHubBtn.MouseButton1Click:Connect(function()
    SelectTab("SairoHub", SairoHubBtn)
end)
table.insert(AllButtons, SairoHubBtn)

InfoPage.Visible = true
InfoBtn.BackgroundColor3 = RedTheme.ButtonOn
InfoBtn.TextColor3 = Colors.White

local InfoCard = Instance.new("ScrollingFrame", InfoPage)
InfoCard.Size = UDim2.new(1, 0, 1, 0)
InfoCard.BackgroundColor3 = RedTheme.Panel
InfoCard.CanvasSize = UDim2.new(0, 0, 0, 360)
InfoCard.ScrollBarThickness = 3
InfoCard.BorderSizePixel = 0
Instance.new("UICorner", InfoCard).CornerRadius = UDim.new(0, 12)

local InfoTitle = Instance.new("TextLabel", InfoCard)
InfoTitle.Size = UDim2.new(1, -20, 0, 30)
InfoTitle.Position = UDim2.new(0, 10, 0, 10)
InfoTitle.BackgroundTransparency = 1
InfoTitle.Text = "نظام Sairo الاحترافي V69.9"
InfoTitle.TextColor3 = RedTheme.Accent
InfoTitle.TextSize = 13
InfoTitle.Font = Enum.Font.GothamBold
InfoTitle.TextXAlignment = Enum.TextXAlignment.Center

local InfoText = Instance.new("TextLabel", InfoCard)
InfoText.Size = UDim2.new(1, -20, 0, 110)
InfoText.Position = UDim2.new(0, 10, 0, 45)
InfoText.BackgroundTransparency = 1
InfoText.Text = "أهلاً بك في نظام Sairo الاحترافي لصيد الضبان وتسهيل تجربة اللعب.\n\n" ..
    "• المطور: 1sairo_\n\n" ..
    "استمتع بالأداء السريع والخصائص الاحترافية المتكاملة."
InfoText.TextColor3 = Colors.White
InfoText.TextSize = 11
InfoText.Font = Enum.Font.GothamMedium
InfoText.TextWrapped = true
InfoText.TextYAlignment = Enum.TextYAlignment.Top
InfoText.TextXAlignment = Enum.TextXAlignment.Right

local function CreateCopyButton(text, y, linkToCopy)
    local Card = Instance.new("Frame", InfoCard)
    Card.Size = UDim2.new(1, -20, 0, 38)
    Card.Position = UDim2.new(0, 10, 0, y)
    Card.BackgroundColor3 = RedTheme.ButtonOff
    Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 8)
    
    local CardStroke = Instance.new("UIStroke", Card)
    CardStroke.Color = RedTheme.SoftNeonRed
    CardStroke.Thickness = 1.5

    local btn = Instance.new("TextButton", Card)
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = text
    btn.TextColor3 = Colors.White
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11

    btn.MouseButton1Click:Connect(function()
        pcall(function()
            if setclipboard then
                setclipboard(linkToCopy)
                btn.Text = "✅ تم نسخ الرابط بنجاح!"
                task.wait(1.5)
                btn.Text = text
            end
        end)
    end)
    return Card
end

CreateCopyButton("🎵 نسخ رابط التيك توك (TikTok)", 165, "https://www.tiktok.com/@1sairo_")
CreateCopyButton("💬 نسخ رابط الدسكورد (Discord)", 213, "https://discord.gg/dA5v7Tfw5k")

local TeleportCard = Instance.new("ScrollingFrame", TeleportPage)
TeleportCard.Size = UDim2.new(1, 0, 1, 0)
TeleportCard.BackgroundColor3 = RedTheme.Panel
TeleportCard.CanvasSize = UDim2.new(0, 0, 0, 380)
TeleportCard.ScrollBarThickness = 3
TeleportCard.BorderSizePixel = 0
Instance.new("UICorner", TeleportCard).CornerRadius = UDim.new(0, 12)

local TpTitle = Instance.new("TextLabel", TeleportCard)
TpTitle.Size = UDim2.new(1, -20, 0, 26)
TpTitle.Position = UDim2.new(0, 10, 0, 8)
TpTitle.BackgroundTransparency = 1
TpTitle.Text = "🚀 نظام الانتقال السريع المتطور"
TpTitle.TextColor3 = RedTheme.Accent
TpTitle.TextSize = 12
TpTitle.Font = Enum.Font.GothamBold
TpTitle.TextXAlignment = Enum.TextXAlignment.Center

local WarningBanner = Instance.new("Frame", TeleportCard)
WarningBanner.Size = UDim2.new(1, -20, 0, 34)
WarningBanner.Position = UDim2.new(0, 10, 0, 36)
WarningBanner.BackgroundColor3 = Color3.fromRGB(30, 8, 14)
Instance.new("UICorner", WarningBanner).CornerRadius = UDim.new(0, 8)

local WarningStroke = Instance.new("UIStroke", WarningBanner)
WarningStroke.Color = RedTheme.SoftNeonRed
WarningStroke.Thickness = 1.5

local WarningText = Instance.new("TextLabel", WarningBanner)
WarningText.Size = UDim2.new(1, -12, 1, 0)
WarningText.Position = UDim2.new(0, 6, 0, 0)
WarningText.BackgroundTransparency = 1
WarningText.Text = "⚠️ تحذير: أنا غير مسؤول عن أي أمر يصدر أو حظر بالماب."
WarningText.TextColor3 = Color3.fromRGB(255, 120, 140)
WarningText.TextSize = 9.5
WarningText.Font = Enum.Font.GothamBold
WarningText.TextWrapped = true

local TpStatusText = Instance.new("TextLabel", TeleportCard)
TpStatusText.Size = UDim2.new(1, -20, 0, 38)
TpStatusText.Position = UDim2.new(0, 10, 0, 76)
TpStatusText.BackgroundColor3 = Color3.fromRGB(25, 15, 22)
TpStatusText.Text = "حالة الانتقال: جاهز للعمل."
TpStatusText.TextColor3 = Color3.fromRGB(200, 200, 210)
TpStatusText.TextSize = 10
TpStatusText.Font = Enum.Font.GothamBold
TpStatusText.TextWrapped = true
Instance.new("UICorner", TpStatusText).CornerRadius = UDim.new(0, 6)

local function CreateActionBtn(text, y, callback)
    local btn = Instance.new("TextButton", TeleportCard)
    btn.Size = UDim2.new(1, -20, 0, 44)
    btn.Position = UDim2.new(0, 10, 0, y)
    btn.BackgroundColor3 = RedTheme.ButtonOff
    btn.Text = text
    btn.TextColor3 = Colors.White
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    
    local btnStroke = Instance.new("UIStroke", btn)
    btnStroke.Color = Color3.fromRGB(55, 20, 38)
    btnStroke.Thickness = 1.2

    btn.MouseButton1Click:Connect(callback)
    return btn
end

local VillageTargetCF = CFrame.new(130.09, 3.00, -2.36)
local MaxSearchDistance = 300
local FixedSpeedKmh = 90

local function FindBestVehicleModel()
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return nil end

    local closestVeh = nil
    local shortestDist = MaxSearchDistance

    for _, obj in ipairs(Workspace:GetDescendants()) do
        pcall(function()
            if obj:IsA("Model") then
                local hasSeat = obj:FindFirstChildOfClass("VehicleSeat") or obj:FindFirstChildOfClass("Seat")
                if hasSeat then
                    local primary = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
                    if primary then
                        local dist = (primary.Position - root.Position).Magnitude
                        if dist <= shortestDist then
                            shortestDist = dist
                            closestVeh = obj
                        end
                    end
                end
            end
        end)
    end
    return closestVeh
end

CreateActionBtn("🚗 انتقال إلى أقرب سيارة (<300م)", 122, function()
    pcall(function()
        local vehicleModel = FindBestVehicleModel()
        if vehicleModel then
            local char = LocalPlayer.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            local primary = vehicleModel.PrimaryPart or vehicleModel:FindFirstChildWhichIsA("BasePart")
            
            if root and primary then
                TpStatusText.Text = "🚶 جاري التقدم بسلاسة نحو الموتر بسرعة 28..."
                TpStatusText.TextColor3 = Color3.fromRGB(255, 220, 80)
                
                task.spawn(function()
                    local startPos = root.Position
                    local targetPos = primary.Position + Vector3.new(3, 2, 0)
                    local dist = (targetPos - startPos).Magnitude
                    
                    local moveSpeed = 22 
                    local duration = math.clamp(dist / moveSpeed, 1.0, 5.0)
                    local elapsed = 0
                    
                    while elapsed < duration and root and root.Parent do
                        local dt = RunService.Heartbeat:Wait()
                        elapsed = elapsed + dt
                        local alpha = math.clamp(elapsed / duration, 0, 1)
                        root.CFrame = CFrame.new(startPos:Lerp(targetPos, alpha))
                    end
                    
                    TpStatusText.Text = "✅ وصلناك لأقرب سيارة بسلاسة. اركب الآن يدوياً!"
                    TpStatusText.TextColor3 = Color3.fromRGB(80, 255, 140)
                end)
            end
        else
            TpStatusText.Text = "⚠️ لا توجد أي سيارة قريبة منك ضمن نطاق 300 متر."
            TpStatusText.TextColor3 = Color3.fromRGB(255, 100, 100)
        end
    end)
end)

CreateActionBtn("🏠 الانتقال السريع إلى الديرة", 174, function()
    pcall(function()
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local seat = hum and hum.SeatPart
        
        if seat and seat.Parent:IsA("Model") then
            local vehModel = seat.Parent
            local rootPart = vehModel.PrimaryPart or vehModel:FindFirstChildWhichIsA("BasePart")
            local charRoot = char:FindFirstChild("HumanoidRootPart")
            
            if rootPart then
                TpStatusText.Text = "🕵️ جاري النزول والانتقال السريع للديرة..."
                TpStatusText.TextColor3 = Color3.fromRGB(255, 220, 80)
                
                task.spawn(function()
                    local activeWelds = {}
                    for _, part in ipairs(vehModel:GetDescendants()) do
                        if part:IsA("BasePart") and part ~= rootPart then
                            part.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                            part.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                            local weld = Instance.new("WeldConstraint")
                            weld.Part0 = rootPart
                            weld.Part1 = part
                            weld.Parent = part
                            table.insert(activeWelds, weld)
                        end
                    end
                    
                    local startCF = rootPart.CFrame
                    local targetGroundPos = VillageTargetCF.Position
                    
                    local undergroundDepth = -0.5
                    local startUndergroundPos = Vector3.new(startCF.Position.X, targetGroundPos.Y + undergroundDepth, startCF.Position.Z)
                    local destUndergroundPos = Vector3.new(targetGroundPos.X, targetGroundPos.Y + undergroundDepth, targetGroundPos.Z)
                    local finalSurfaceCF = VillageTargetCF + Vector3.new(0, 3, 0)
                    
                    local function MoveVehicleTo(targetCF, lookAtPos)
                        pcall(function()
                            vehModel:PivotTo(CFrame.new(targetCF.Position, lookAtPos))
                            if charRoot then
                                charRoot.CFrame = targetCF + Vector3.new(0, 2, 0)
                            end
                        end)
                    end
                    
                    local elapsed = 0
                    local diveDuration = 0.5
                    while elapsed < diveDuration do
                        local dt = RunService.Heartbeat:Wait()
                        elapsed = elapsed + dt
                        local currentPos = startCF.Position:Lerp(startUndergroundPos, math.clamp(elapsed / diveDuration, 0, 1))
                        MoveVehicleTo(CFrame.new(currentPos), targetGroundPos)
                    end
                    
                    local totalDistance = (destUndergroundPos - startUndergroundPos).Magnitude
                    local speedStudsPerSec = (FixedSpeedKmh * 3.5) / 3.6
                    local travelDistance = math.max(totalDistance, 10)
                    local travelDuration = travelDistance / speedStudsPerSec
                    
                    elapsed = 0
                    while elapsed < travelDuration do
                        local dt = RunService.Heartbeat:Wait()
                        elapsed = elapsed + dt
                        local alpha = math.clamp(elapsed / travelDuration, 0, 1)
                        local currentPos = startUndergroundPos:Lerp(destUndergroundPos, alpha)
                        MoveVehicleTo(CFrame.new(currentPos), targetGroundPos)
                    end
                    
                    elapsed = 0
                    local surfaceDuration = 0.5
                    while elapsed < surfaceDuration do
                        local dt = RunService.Heartbeat:Wait()
                        elapsed = elapsed + dt
                        local currentPos = destUndergroundPos:Lerp(finalSurfaceCF.Position, math.clamp(elapsed / surfaceDuration, 0, 1))
                        MoveVehicleTo(CFrame.new(currentPos), targetGroundPos + Vector3.new(0, 0, 5))
                    end
                    
                    for _, weld in ipairs(activeWelds) do
                        pcall(function() weld:Destroy() end)
                    end
                    
                    for _, part in ipairs(vehModel:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                            part.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                        end
                    end
                    
                    TpStatusText.Text = "✅ تم الانتقال، السفر تحت الأرض، وصعود السيارة فوق الأرض بنجاح!"
                    TpStatusText.TextColor3 = Color3.fromRGB(80, 255, 140)
                end)
            end
        else
            TpStatusText.Text = "⚠️ تأكد من جلوسك داخل الموتر أولاً للانتقال للديرة."
            TpStatusText.TextColor3 = Color3.fromRGB(255, 100, 100)
        end
    end)
end)

local SairoCard = Instance.new("ScrollingFrame", SairoHubPage)
SairoCard.Size = UDim2.new(1, 0, 1, 0)
SairoCard.BackgroundColor3 = RedTheme.Panel
SairoCard.CanvasSize = UDim2.new(0, 0, 0, 360)
SairoCard.ScrollBarThickness = 3
SairoCard.BorderSizePixel = 0
Instance.new("UICorner", SairoCard).CornerRadius = UDim.new(0, 12)

local SairoTitle = Instance.new("TextLabel", SairoCard)
SairoTitle.Size = UDim2.new(1, -20, 0, 30)
SairoTitle.Position = UDim2.new(0, 10, 0, 10)
SairoTitle.BackgroundTransparency = 1
SairoTitle.Text = "⚡ مركز Sairo Hub"
SairoTitle.TextColor3 = RedTheme.Accent
SairoTitle.TextSize = 13
SairoTitle.Font = Enum.Font.GothamBold
SairoTitle.TextXAlignment = Enum.TextXAlignment.Center

local SairoText = Instance.new("TextLabel", SairoCard)
SairoText.Size = UDim2.new(1, -20, 0, 280)
SairoText.Position = UDim2.new(0, 10, 0, 45)
SairoText.BackgroundTransparency = 1
SairoText.Text = "قسم Sairo Hub المخصص:\n\n" ..
    "• جميع أدوات الانتقال والتخفي والصعود جاهزة ومستقرة.\n\n" ..
    "━━━━━━━━━━━━━━━━━━━━━━\n" ..
    "Developer: 1sairo_"
SairoText.TextColor3 = Colors.White
SairoText.TextSize = 11
SairoText.Font = Enum.Font.GothamMedium
SairoText.TextWrapped = true
SairoText.TextYAlignment = Enum.TextYAlignment.Top
SairoText.TextXAlignment = Enum.TextXAlignment.Right

local function CreateToggleButton(ParentFrame, Key, Text, Y, AccentColor, OnToggleCallback)
    local Card = Instance.new("Frame", ParentFrame)
    Card.Size = UDim2.new(1, -6, 0, 44)
    Card.Position = UDim2.new(0, 0, 0, Y)
    Card.BackgroundColor3 = RedTheme.CardBg
    Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 10)

    local CardStroke = Instance.new("UIStroke", Card)
    CardStroke.Color = Color3.fromRGB(55, 20, 38)
    CardStroke.Thickness = 1.2

    local Label = Instance.new("TextLabel", Card)
    Label.Size = UDim2.new(1, -75, 1, 0)
    Label.Position = UDim2.new(0, 14, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = Text
    Label.TextColor3 = Colors.White
    Label.TextSize = 11
    Label.Font = Enum.Font.GothamMedium
    Label.TextXAlignment = Enum.TextXAlignment.Left

    local Switch = Instance.new("TextButton", Card)
    Switch.Size = UDim2.new(0, 44, 0, 22)
    Switch.Position = UDim2.new(1, -52, 0.5, -11)
    Switch.BackgroundColor3 = Settings[Key] and RedTheme.ToggleBgOn or RedTheme.ToggleBgOff
    Switch.Text = ""
    Instance.new("UICorner", Switch).CornerRadius = UDim.new(1, 0)

    local Circle = Instance.new("Frame", Switch)
    Circle.Size = UDim2.new(0, 16, 0, 16)
    Circle.Position = Settings[Key] and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
    Circle.BackgroundColor3 = Colors.White
    Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0)

    local function Refresh()
        local Enabled = Settings[Key]
        TweenService:Create(Switch, TweenInfo.new(0.2), {BackgroundColor3 = Enabled and RedTheme.ToggleBgOn or RedTheme.ToggleBgOff}):Play()
        TweenService:Create(Circle, TweenInfo.new(0.2), {Position = Enabled and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)}):Play()
    end

    Switch.MouseButton1Click:Connect(function()
        Settings[Key] = not Settings[Key]
        Refresh()
        SaveSettings()
        if OnToggleCallback then OnToggleCallback(Settings[Key], Refresh) end
    end)
    
    Refresh()
    return Card
end

local function CreateSlider(ParentFrame, Key, TitleText, Y, MinVal, MaxVal, Suffix)
    local Card = Instance.new("Frame", ParentFrame)
    Card.Size = UDim2.new(1, -6, 0, 60)
    Card.Position = UDim2.new(0, 0, 0, Y)
    Card.BackgroundColor3 = RedTheme.CardBg
    Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 10)

    local CardStroke = Instance.new("UIStroke", Card)
    CardStroke.Color = Color3.fromRGB(55, 20, 38)
    CardStroke.Thickness = 1.2

    local Label = Instance.new("TextLabel", Card)
    Label.Size = UDim2.new(1, -20, 0, 22)
    Label.Position = UDim2.new(0, 12, 0, 6)
    Label.BackgroundTransparency = 1
    Label.Text = TitleText .. ": " .. tostring(math.floor(Settings[Key])) .. Suffix
    Label.TextColor3 = Colors.White
    Label.TextSize = 11
    Label.Font = Enum.Font.GothamBold
    Label.TextXAlignment = Enum.TextXAlignment.Left

    local SliderTrack = Instance.new("Frame", Card)
    SliderTrack.Size = UDim2.new(1, -24, 0, 8)
    SliderTrack.Position = UDim2.new(0, 12, 0, 36)
    SliderTrack.BackgroundColor3 = Color3.fromRGB(40, 15, 25)
    Instance.new("UICorner", SliderTrack).CornerRadius = UDim.new(1, 0)

    local SliderFill = Instance.new("Frame", SliderTrack)
    SliderFill.Size = UDim2.new(0, 0, 1, 0)
    SliderFill.BackgroundColor3 = RedTheme.Accent
    Instance.new("UICorner", SliderFill).CornerRadius = UDim.new(1, 0)

    local SliderKnob = Instance.new("Frame", SliderFill)
    SliderKnob.Size = UDim2.new(0, 14, 0, 14)
    SliderKnob.Position = UDim2.new(1, -7, 0.5, -7)
    SliderKnob.BackgroundColor3 = Colors.White
    Instance.new("UICorner", SliderKnob).CornerRadius = UDim.new(1, 0)

    local function UpdateVisual()
        local pct = math.clamp((Settings[Key] - MinVal) / (MaxVal - MinVal), 0, 1)
        SliderFill.Size = UDim2.new(pct, 0, 1, 0)
        Label.Text = TitleText .. ": " .. tostring(math.floor(Settings[Key])) .. Suffix
    end

    local IsDragging = false
    SliderTrack.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            IsDragging = true
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if IsDragging then
                IsDragging = false
                SaveSettings()
            end
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if IsDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local mouseLoc = UserInputService:GetMouseLocation()
            local absPos = SliderTrack.AbsolutePosition
            local absSize = SliderTrack.AbsoluteSize
            local pct = math.clamp((mouseLoc.X - absPos.X) / absSize.X, 0, 1)
            Settings[Key] = math.floor(MinVal + pct * (MaxVal - MinVal))
            UpdateVisual()
        end
    end)

    UpdateVisual()
    return Card
end

CreateToggleButton(EspPage, "DhabAll", "ESP كشف جميع الضبان العادية", 0, Colors.White)
CreateToggleButton(EspPage, "DhabRareOnly", "ESP كشف الأسطوري (T5) والخرافي (T6)", 50, RarityColors.T5)
CreateToggleButton(EspPage, "DhabSpecialActive", "ESP الضبان النادرة المستقلة", 100, Colors.SpecialDhabColor)
CreateToggleButton(EspPage, "Players", "ESP كشف جميع اللاعبين", 150, Colors.PlayerColor)
CreateToggleButton(EspPage, "Vehicles", "ESP كشف جميع السيارات", 200, Colors.VehicleColor)
CreateSlider(EspPage, "EspDistance", "مسافة كشف ESP", 252, 100, 2000, " متر")

CreateToggleButton(AimPage, "Aimbot", "تفعيل نظام الايمبوت التلقائي", 0, RedTheme.Accent)
CreateToggleButton(AimPage, "RequireWeapon", "يلزم إشهار السلاح للشبك", 50, RarityColors.T5)
CreateToggleButton(AimPage, "HoldRightClick", "شبك عند ضغط كليك يمين فقط", 100, RarityColors.T3)
CreateToggleButton(AimPage, "UseFOVCircle", "إظهار دائرة التصويب (FOV)", 150, RarityColors.T2)
CreateSlider(AimPage, "AimbotDistance", "مسافة شبك الايمبوت", 202, 10, 300, " متر")
CreateSlider(AimPage, "FOVRadius", "حجم دائرة التصويب (FOV)", 268, 30, 300, " بكسل")

CreateToggleButton(UtilsPage, "RareHudActive", "إظهار واجهة الضبان النادرة (HUD)", 0, RarityColors.T5, function(State)
    RareHud.Visible = State
end)
CreateToggleButton(UtilsPage, "SmartAlerts", "التنبيه الذكي عند اقتراب النادر", 50, RarityColors.T5)

local originalFogStart = Lighting.FogStart
local originalFogEnd = Lighting.FogEnd
local originalAtmosphereDensity = nil
local AtmosphereObj = Lighting:FindFirstChildOfClass("Atmosphere")
if AtmosphereObj then originalAtmosphereDensity = AtmosphereObj.Density end

local function ApplyFogSettings(state)
    pcall(function()
        if state then
            Lighting.FogStart = 1000000
            Lighting.FogEnd = 1000000
            if AtmosphereObj then AtmosphereObj.Density = 0 end
        else
            Lighting.FogStart = originalFogStart
            Lighting.FogEnd = originalFogEnd
            if AtmosphereObj and originalAtmosphereDensity then 
                AtmosphereObj.Density = originalAtmosphereDensity 
            end
        end
    end)
end

CreateToggleButton(SettingsPage, "FogDisabled", "إزالة الضباب وتوسيع الرؤية", 0, RarityColors.T3, function(State)
    ApplyFogSettings(State)
end)

CreateToggleButton(SettingsPage, "AntiAfkActive", "منع الخمول (Anti-AFK)", 50, RarityColors.T2)
CreateToggleButton(SettingsPage, "AutoRejoinActive", "إعادة التوصيل عند الفصل", 100, RarityColors.T3)

if Settings.FogDisabled then
    task.spawn(function()
        task.wait(0.5)
        ApplyFogSettings(true)
    end)
end

Lighting.Changed:Connect(function()
    if Settings.FogDisabled then
        ApplyFogSettings(true)
    end
end)

task.spawn(function()
    local VirtualUser = game:GetService("VirtualUser")
    LocalPlayer.Idled:Connect(function()
        if Settings.AntiAfkActive then
            pcall(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new())
            end)
        end
    end)
end)

task.spawn(function()
    local Event = game:GetService("CoreGui").PromptError
    if Event then
        Event.Changed:Connect(function()
            if Settings.AutoRejoinActive then
                task.wait(1)
                pcall(function()
                    TeleportService:Teleport(game.PlaceId, LocalPlayer)
                end)
            end
        end)
    end
    
    local ErrorPrompt = CoreGuiService:FindFirstChild("RobloxPromptGui", true)
    if ErrorPrompt then
        ErrorPrompt.DescendantAdded:Connect(function(msg)
            if msg.Name == "ErrorTitle" and Settings.AutoRejoinActive then
                task.wait(2)
                pcall(function()
                    TeleportService:Teleport(game.PlaceId, LocalPlayer)
                end)
            end
        end)
    end
end)

-- 🛑 دالة الفحص المحسنة والدقيقة للنوادر (شاملة الياقوت، الجلمود وبقية الأسماء، مع استبعاد اللازورد)
local function GetSpecialDhabName(Model)
    local nameLower = Model.Name:lower()
    
    if nameLower:find("lazward") then
        return nil
    end

    if SpecialDhabsList[nameLower] then
        return SpecialDhabsList[nameLower]
    end
    
    for _, child in ipairs(Model:GetChildren()) do
        local childLower = child.Name:lower()
        if childLower:find("lazward") then
        elseif SpecialDhabsList[childLower] then
            return SpecialDhabsList[childLower]
        end
    end
    
    for k, v in pairs(Model:GetAttributes()) do
        local keyLower = tostring(k):lower()
        local valStr = tostring(v):lower()
        
        if valStr:find("lazward") or keyLower:find("lazward") then
            return nil
        end
        
        if SpecialDhabsList[valStr] then
            return SpecialDhabsList[valStr]
        end
    end
    
    for _, desc in ipairs(Model:GetDescendants()) do
        local descLower = desc.Name:lower()
        if SpecialDhabsList[descLower] then
            return SpecialDhabsList[descLower]
        end
    end
    
    return nil
end

local function GetDhabInfo(Model)
    local TierFound = nil
    local StateFound = nil

    local modelNameLower = Model.Name:lower()
    
    if modelNameLower:find("lazward") then
        return nil
    end

    if modelNameLower:find("gl_lazward") then
        TierFound = "T6"
    elseif modelNameLower:find("gm_farqad") or modelNameLower:find("m_kahraman") or modelNameLower:find("gm_jalmood") or modelNameLower:find("jalmood") or modelNameLower:find("gl_jalmood") or modelNameLower:find("gm_abusakhr") or modelNameLower:find("g_zumurrud") or modelNameLower:find("gl_jamr") or modelNameLower:find("m_almas") or modelNameLower:find("m_tibr") or modelNameLower:find("thurayya") or modelNameLower:find("m_yaqoot") then
        TierFound = "T6"
    end

    for Key, Value in pairs(Model:GetAttributes()) do
        local KeyLower = tostring(Key):lower()
        local ValStr = tostring(Value):lower()
        
        if KeyLower == "tier" and not TierFound then
            local tStr = tostring(Value):upper()
            if tStr == "T1" or tStr == "T2" or tStr == "T3" or tStr == "T4" or tStr == "T5" or tStr == "T6" then
                TierFound = tStr
            end
        elseif KeyLower == "species" and (ValStr:find("farqad") or ValStr:find("kahraman") or ValStr:find("jalmood") or ValStr:find("abusakhr") or ValStr:find("zumurrud") or ValStr:find("jamr") or ValStr:find("almas") or ValStr:find("tibr") or ValStr:find("thurayya") or ValStr:find("yaqoot")) then
            TierFound = "T6"
        elseif KeyLower == "state" then
            StateFound = ValStr
        end
    end

    if not TierFound then return nil end

    local Rarity = RarityNames[TierFound] or "عادي"
    
    if StateFound and StateNames[StateFound] then
        LastKnownStates[Model] = StateNames[StateFound]
    elseif not LastKnownStates[Model] then
        LastKnownStates[Model] = "واقف 🧍"
    end

    return LastKnownStates[Model], Rarity, TierFound
end

local function GetCategory(Model)
    if not Model or not Model:IsA("Model") or Model == LocalPlayer.Character then return nil end
    if Players:GetPlayerFromCharacter(Model) then return "Player" end

    if Model:FindFirstChildOfClass("ProximityPrompt") and not Model:FindFirstChildOfClass("VehicleSeat") then
        return nil
    end

    local NameLower = Model.Name:lower()
    if NameLower:find("lazward") then return nil end

    local HasVehicleSeat = Model:FindFirstChildOfClass("VehicleSeat") ~= nil
    local IsCarName = NameLower:find("nissan") or NameLower:find("toyota") or NameLower:find("gmc") or NameLower:find("patrol") or NameLower:find("landcruiser") or NameLower:find("datsun") or NameLower:find("hilux")

    if HasVehicleSeat or (IsCarName and not Model:FindFirstChildOfClass("Seat")) then
        return "Vehicle"
    end

    if GetSpecialDhabName(Model) then
        return "SpecialDhab"
    end

    local _, _, ValidTier = GetDhabInfo(Model)
    if ValidTier then
        return "Dhab"
    end

    return nil
end

local function GetPart(Model)
    return Model:FindFirstChild("HumanoidRootPart") or Model:FindFirstChild("Head") or Model.PrimaryPart or Model:FindFirstChildWhichIsA("BasePart")
end

local function RemoveESP(Model)
    if ActiveESP[Model] then
        local Highlight = Model:FindFirstChild("Sairo_HL")
        if Highlight then Highlight:Destroy() end
        
        local Part = GetPart(Model)
        if Part then
            local Text = Part:FindFirstChild("Sairo_Text")
            if Text then Text:Destroy() end
        end
        
        ActiveESP[Model] = nil
        LastKnownStates[Model] = nil
    end
end

local function AddESP(Model, Category)
    local Part = GetPart(Model)
    if not Part then return end

    local MyChar = LocalPlayer.Character
    local Dist = 0
    if MyChar and MyChar:FindFirstChild("HumanoidRootPart") then
        Dist = math.floor((Part.Position - MyChar.HumanoidRootPart.Position).Magnitude)
    end

    if Dist > Settings.EspDistance then
        RemoveESP(Model)
        return
    end

    local DisplayText, DisplayColor

    if Category == "Player" then
        local PlayerObj = Players:GetPlayerFromCharacter(Model)
        DisplayText = "لاعب: " .. (PlayerObj and PlayerObj.DisplayName or Model.Name) .. " [" .. Dist .. "m]"
        DisplayColor = Colors.PlayerColor
    elseif Category == "Vehicle" then
        DisplayText = "مركبة / موتر [" .. Dist .. "m]"
        DisplayColor = Colors.VehicleColor
    elseif Category == "SpecialDhab" then
        local dhabNameArabic = GetSpecialDhabName(Model) or "ضب نادر"
        DisplayColor = Colors.SpecialDhabColor
        DisplayText = "✨ " .. dhabNameArabic .. " [T6] ✨\nالمسافة: [" .. Dist .. "m]"
    elseif Category == "Dhab" then
        local StateText, Rarity, Tier = GetDhabInfo(Model)
        if not Tier then 
            RemoveESP(Model)
            return 
        end

        if Settings.DhabRareOnly and not Settings.DhabAll then
            if Tier ~= "T5" and Tier ~= "T6" then
                RemoveESP(Model)
                return
            end
        end

        if Settings.SmartAlerts and (Tier == "T5" or Tier == "T6") and Dist <= 200 then
            if not NotifiedRareDhabs[Model] then
                NotifiedRareDhabs[Model] = true
                AlertBox.Text = "🚨 تنبيه: تم رصد ضب " .. Rarity .. " (" .. StateText .. ") قريب منك!"
                AlertBox.Visible = true
                pcall(function() NotifySound:Play() end)
                task.delay(4, function() AlertBox.Visible = false end)
            end
        end

        DisplayColor = RarityColors[Tier] or RarityColors.T1
        DisplayText = Rarity .. " | الحالة: " .. StateText .. "\nالمسافة: [" .. Dist .. "m]"
    end

    ActiveESP[Model] = true

    local Highlight = Model:FindFirstChild("Sairo_HL") or Instance.new("Highlight", Model)
    Highlight.Name = "Sairo_HL"
    Highlight.Adornee = Model
    Highlight.FillColor = DisplayColor
    Highlight.OutlineColor = DisplayColor
    Highlight.FillTransparency = 0.35

    local Billboard = Part:FindFirstChild("Sairo_Text") or Instance.new("BillboardGui", Part)
    Billboard.Name = "Sairo_Text"
    Billboard.Adornee = Part
    Billboard.Size = UDim2.new(0, 220, 0, 50)
    Billboard.StudsOffset = Vector3.new(0, 3.2, 0)
    Billboard.AlwaysOnTop = true

    local Label = Billboard:FindFirstChild("Info") or Instance.new("TextLabel", Billboard)
    Label.Name = "Info"
    Label.Size = UDim2.new(1, 0, 1, 0)
    Label.BackgroundTransparency = 1
    Label.TextStrokeTransparency = 0.2
    Label.TextScaled = true
    Label.Font = Enum.Font.GothamBold
    Label.Text = DisplayText
    Label.TextColor3 = DisplayColor
end

task.spawn(function()
    while ScreenGui.Parent do
        local NewDhabs = {}
        local ClosestRareDhabName = "لا يوجد ضب قريب"
        local ClosestRareDist = math.huge

        local MyChar = LocalPlayer.Character
        local MyRoot = MyChar and MyChar:FindFirstChild("HumanoidRootPart")

        local Targets = {}
        for _, obj in ipairs(Workspace:GetChildren()) do
            if obj:IsA("Model") then
                table.insert(Targets, obj)
            elseif obj.Name:lower():find("dhab") or obj.Name:lower():find("spawn") or obj.Name:lower():find("car") or obj.Name:lower():find("veh") then
                for _, subObj in ipairs(obj:GetChildren()) do
                    if subObj:IsA("Model") then
                        table.insert(Targets, subObj)
                    end
                end
            end
        end

        for _, Model in ipairs(Targets) do
            local Category = GetCategory(Model)
            if Category then
                if Category == "Dhab" or Category == "SpecialDhab" then 
                    table.insert(NewDhabs, Model) 
                    
                    local StateText, Rarity, Tier = GetDhabInfo(Model)
                    if Category == "SpecialDhab" then
                        Tier = "T6"
                        Rarity = "خرافي"
                        StateText = LastKnownStates[Model] or "واقف 🧍"
                    end

                    if Tier and (Tier == "T5" or Tier == "T6") and MyRoot then
                        local Part = GetPart(Model)
                        if Part then
                            local Dist = (Part.Position - MyRoot.Position).Magnitude
                            local ExcludeSelf = Model:IsDescendantOf(MyChar)
                            if not ExcludeSelf and Dist < ClosestRareDist then
                                ClosestRareDist = Dist
                                local targetNameShow = Category == "SpecialDhab" and GetSpecialDhabName(Model) or Rarity
                                ClosestRareDhabName = "⭐ الصنف: " .. targetNameShow .. "\n📌 الحالة: " .. StateText .. "\n📍 المسافة: " .. math.floor(Dist) .. " متر"
                            end
                        end
                    end
                end
                
                local Show = false
                if Category == "Player" and Settings.Players then Show = true
                elseif Category == "Vehicle" and Settings.Vehicles then Show = true
                elseif Category == "SpecialDhab" and Settings.DhabSpecialActive then Show = true
                elseif Category == "Dhab" and (Settings.DhabAll or Settings.DhabRareOnly) then Show = true end

                if Show then 
                    AddESP(Model, Category) 
                else 
                    RemoveESP(Model)
                end
            end
        end
        CachedDhabs = NewDhabs
        
        if Settings.RareHudActive then
            if ClosestRareDist ~= math.huge then
                RareHudContent.Text = ClosestRareDhabName
            else
                RareHudContent.Text = "🔍 لا يوجد ضب أسطوري/خرافي في النطاق حالياً."
            end
        end
        
        task.wait(1.2)
    end
end)

local function HasToolEquipped(Character)
    return Character:FindFirstChildOfClass("Tool") ~= nil
end

RunService.RenderStepped:Connect(function()
    local MousePos = UserInputService:GetMouseLocation()
    FOVCircle.Position = MousePos
    FOVCircle.Radius = Settings.FOVRadius
    FOVCircle.Visible = Settings.Aimbot and Settings.UseFOVCircle

    if not Settings.Aimbot then return end
    local MyChar = LocalPlayer.Character
    if not MyChar then return end

    if Settings.RequireWeapon and not HasToolEquipped(MyChar) then return end
    if Settings.HoldRightClick and not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then return end

    if MyChar:FindFirstChild("HumanoidRootPart") then
        local MyRoot = MyChar.HumanoidRootPart
        local ClosestTarget = nil
        local ShortestDistance = Settings.AimbotDistance

        for _, Model in ipairs(CachedDhabs) do
            if Model and Model.Parent then
                local TestTargetPart = GetPart(Model)
                if TestTargetPart then
                    local ScreenPos, OnScreen = Camera:WorldToViewportPoint(TestTargetPart.Position)
                    local Distance = (TestTargetPart.Position - MyRoot.Position).Magnitude

                    if Distance <= ShortestDistance and OnScreen then
                        if Settings.UseFOVCircle then
                            local MouseDist = (Vector2.new(ScreenPos.X, ScreenPos.Y) - MousePos).Magnitude
                            if MouseDist <= Settings.FOVRadius then ClosestTarget = TestTargetPart end
                        else
                            ClosestTarget = TestTargetPart
                        end
                    end
                end
            end
        end

        if ClosestTarget then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, ClosestTarget.Position)
        end
    end
end)