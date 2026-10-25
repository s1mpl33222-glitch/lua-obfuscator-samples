-- UI Script Precision | Prison Life
local repo = "https://raw.githubusercontent.com/majeskooooo/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

local Options = Library.Options
local Toggles = Library.Toggles

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

Library.Scheme.AccentColor = Color3.fromRGB(155, 196, 226)
Library.Scheme.BackgroundColor = Color3.fromRGB(10, 13, 18)
Library.Scheme.MainColor = Color3.fromRGB(18, 22, 30)
Library.Scheme.OutlineColor = Color3.fromRGB(28, 34, 44)
Library.Scheme.DarkColor = Color3.fromRGB(4, 5, 8)

-- ============ WINDOW SETUP ============
local Window = Library:CreateWindow({
    Title = "",
    Footer = "Precision Hub",
    FooterLeft = "0.6.8",
    FooterRight = "Made by 2knw",
    Icon = 74169651953690,
    NotifySide = "Right",
    ShowCustomCursor = true,
    Size = UDim2.fromOffset(700, 750), 
    Center = true,
    Resizable = true, 
    SidebarCompacted = true,
    ShowMobileButtons = false,
    CornerRadius = 10,
    Font = Enum.Font.Gotham,
})

-- ============ TABS ============
local Tabs = {
    Info = Window:AddTab("Info", "info", "Game info"),
    Aimbot = Window:AddTab("Main", "crosshair", "Core features"),
    Teleports = Window:AddTab("Weapons & Shop", "shopping-basket", "Teleports and Weapons"),
    Visuals = Window:AddTab("Visuals", "eye", "ESP and Visual Customization"),
    ["UI Settings"] = Window:AddTab("UI Settings", "settings", "Customize the UI behavior and appearance"),
}

Library:SetDPIScale(95)

-- ============ INFO TAB ============
local scriptStartTime = tick()

local function getGreeting()
    local hour = tonumber(os.date("%H"))
    if hour < 12 then
        return "Good Morning"
    elseif hour < 18 then
        return "Good Afternoon"
    else
        return "Good Evening"
    end
end

local function formatUptime(seconds)
    local h = math.floor(seconds / 3600)
    local m = math.floor((seconds % 3600) / 60)
    local s = math.floor(seconds % 60)
    return string.format("%dh %dm %ds", h, m, s)
end

local InfoTabLeft = Tabs.Info.Sides[1]
local InfoTabRight = Tabs.Info.Sides[2]
local InfoTabContainer = InfoTabLeft.Parent

local PROFILE_HEIGHT = 110
local PROFILE_GAP = 10

-- ============ PROFILE PANEL ============
local ProfileHolder = Instance.new("Frame")
ProfileHolder.Name = "ProfilePanel"
ProfileHolder.BackgroundColor3 = Library.Scheme.BackgroundColor
ProfileHolder.Position = UDim2.fromOffset(1, 2)
ProfileHolder.Size = UDim2.new(1, -2, 0, PROFILE_HEIGHT)
ProfileHolder.Parent = InfoTabContainer

Library:AddToRegistry(ProfileHolder, { BackgroundColor3 = "BackgroundColor" })

local ProfileCorner = Instance.new("UICorner")
ProfileCorner.CornerRadius = UDim.new(0, Library.CornerRadius)
ProfileCorner.Parent = ProfileHolder
table.insert(Library.Corners, ProfileCorner)

Library:AddOutline(ProfileHolder)

local ProfileFrame = Instance.new("Frame")
ProfileFrame.Name = "ProfileFrame"
ProfileFrame.BackgroundTransparency = 1
ProfileFrame.Size = UDim2.new(1, -16, 1, -16)
ProfileFrame.Position = UDim2.fromOffset(8, 8)
ProfileFrame.Parent = ProfileHolder

local HeadshotImage = Instance.new("ImageLabel")
HeadshotImage.Name = "Headshot"
HeadshotImage.BackgroundColor3 = Library:GetBetterColor(Library.Scheme.BackgroundColor, 8)
HeadshotImage.BackgroundTransparency = 0
HeadshotImage.Size = UDim2.fromOffset(80, 80)
HeadshotImage.Position = UDim2.fromOffset(0, 0)
HeadshotImage.Image = ""
HeadshotImage.Parent = ProfileFrame

Library:AddToRegistry(HeadshotImage, {
    BackgroundColor3 = function()
        return Library:GetBetterColor(Library.Scheme.BackgroundColor, 8)
    end,
})

local HeadshotCorner = Instance.new("UICorner")
HeadshotCorner.CornerRadius = UDim.new(0, 12)
HeadshotCorner.Parent = HeadshotImage

task.spawn(function()
    local ok, content = pcall(function()
        return Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
    end)
    if ok and content then
        HeadshotImage.Image = content
    end
end)

local GreetingLabel = Instance.new("TextLabel")
GreetingLabel.Name = "GreetingLabel"
GreetingLabel.BackgroundTransparency = 1
GreetingLabel.Position = UDim2.fromOffset(92, 2)
GreetingLabel.Size = UDim2.new(1, -92, 0, 26)
GreetingLabel.Font = Enum.Font.GothamBold
GreetingLabel.TextSize = 18
GreetingLabel.TextXAlignment = Enum.TextXAlignment.Left
GreetingLabel.TextColor3 = Library.Scheme.FontColor
GreetingLabel.Text = getGreeting() .. ", " .. player.Name .. "!"
GreetingLabel.Parent = ProfileFrame

Library:AddToRegistry(GreetingLabel, { TextColor3 = "FontColor" })

local ExecutorName = "Unknown"
pcall(function()
    if identifyexecutor then
        ExecutorName = identifyexecutor()
    end
end)

local InfoDetailsLabel = Instance.new("TextLabel")
InfoDetailsLabel.Name = "InfoDetailsLabel"
InfoDetailsLabel.BackgroundTransparency = 1
InfoDetailsLabel.Position = UDim2.fromOffset(92, 30)
InfoDetailsLabel.Size = UDim2.new(1, -92, 0, 60)
InfoDetailsLabel.Font = Enum.Font.Gotham
InfoDetailsLabel.TextSize = 13
InfoDetailsLabel.TextXAlignment = Enum.TextXAlignment.Left
InfoDetailsLabel.TextYAlignment = Enum.TextYAlignment.Top
InfoDetailsLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
InfoDetailsLabel.RichText = true
InfoDetailsLabel.Text = "• Executor: " .. ExecutorName .. "\n"
    .. "• Map: Prison Life\n"
    .. "• Time: " .. os.date("%I:%M %p")
InfoDetailsLabel.Parent = ProfileFrame

local function RepositionInfoSides()
    local Offset = PROFILE_HEIGHT + PROFILE_GAP
    InfoTabLeft.Position = UDim2.new(0, 0, 0, Offset)
    InfoTabLeft.Size = UDim2.new(0.5, -3, 1, -Offset)

    InfoTabRight.Position = UDim2.new(1, 0, 0, Offset)
    InfoTabRight.Size = UDim2.new(0.5, -3, 1, -Offset)
end
RepositionInfoSides()

function Tabs.Info:RefreshSides()
    RepositionInfoSides()
end

-- ============ UPDATES GROUP ============
local UpdatesBox = Tabs.Info:AddLeftGroupbox("Updates", "bell")

UpdatesBox:AddLabel("Prison Life", true)
UpdatesBox:AddLabel(
    "- Added Invisible\n" ..
    "  Credits to A2Flacko\n" ..
    "- Added Anti-invisible\n" ..
    "  Credits to A2Flacko\n" ..
    "- Some Bugs Fixed\n" ..
    "- Added new Teleport Criminal Base\n" ..
    "- Added new Teleport Frontwall\n" ..
    "- Improved Get Weapons System\n" ..
    "- Added Anti Sit\n" ..
    "  to prevent kick exploits\n" ..
    "- Added Korblox\n" ..
    "  Visual\n" ..
    "- Added Headless\n" ..
    "  Visual\n" ..
    "- Added CoD Kaboom Hitsound\n" ..
    "- Added Creepy Bell Hitsound\n" ..
    "- Added You are a Idiot Killsound\n" ..
    "- Added Creepy Bell Killsound\n" ..
    "- Added Vine Boom Killsound\n" ..
    "- Added RDR2 Low Honor Killsound\n" ..
    "- Added Get Out Killsound\n" ..
    "- Added Diahrrea Sound Killsound\n" ..
    "- Added Goku Prowler Killsound\n" ..
    "- Added iPhone Ding Killsound\n" ..
    "- Added Bark Fart Killsound\n" ..
    "- Added Enrique Killsound\n" ..
    "- Added Fatality 2 Killsound\n" ..
    "- Added Weapon Textures\n" ..
    "  Credits to OnlyAdrian for sending every Texture",
    true
)

UpdatesBox:AddDivider("Info")

UpdatesBox:AddButton({
    Text = "Discord Server",
    Func = function()
        pcall(function()
            setclipboard("discord.gg/unxmjPC4x7")
        end)
    end,
})

-- ============ FEEDBACK SYSTEM GROUP ============
local FeedbackBox = Tabs.Info:AddRightGroupbox("Feedback System", "mail")
FeedbackBox:SetDescription("Send feedback to developer (Join the Discord Server for More Info)")

FeedbackBox:AddLabel("Your feedback")

FeedbackBox:AddInput("FeedbackText", {
    Text = "",
    Placeholder = "Type your feedback here",
    ClearTextOnFocus = false,
    Finished = false,
})

do
    local feedbackHolder = Options.FeedbackText.Holder
    local feedbackBox = feedbackHolder:FindFirstChildOfClass("TextBox")
    if feedbackBox then
        feedbackBox.AnchorPoint = Vector2.new(0, 1)
        feedbackBox.Position = UDim2.fromScale(0, 1)
        feedbackBox.Size = UDim2.new(1, 0, 0, 76)
        feedbackBox.TextScaled = false
        feedbackBox.TextSize = 14
        feedbackBox.TextWrapped = true
        feedbackBox.MultiLine = true
        feedbackBox.TextXAlignment = Enum.TextXAlignment.Left
        feedbackBox.TextYAlignment = Enum.TextYAlignment.Top

        feedbackHolder.Size = UDim2.new(1, 0, 0, 90)
    end
end

FeedbackBox:AddButton({
    Text = "Send Feedback",
    Func = function()
        getgenv().SendFeedback(Options.FeedbackText.Value)
    end,
})

-- ============ SERVER STATS GROUP ============
local ServerStatsBox = Tabs.Info:AddRightGroupbox("Server Stats", "info")

local regionCode = "Unknown"
pcall(function()
    regionCode = game:GetService("LocalizationService"):GetCountryRegionForPlayerAsync(player)
end)

local ServerStatsLabel = ServerStatsBox:AddLabel("Region: " .. regionCode .. "\nCountry: " .. regionCode .. "\nUptime: " .. formatUptime(tick() - scriptStartTime), true)

task.spawn(function()
    while task.wait(1) do
        pcall(function()
            ServerStatsLabel:SetText("Region: " .. regionCode .. "\nCountry: " .. regionCode .. "\nUptime: " .. formatUptime(tick() - scriptStartTime))
        end)
    end
end)

-- ============ MOBILE BUTTON ============
if Library.IsMobile then
    local CustomToggleButton = Instance.new("ImageButton")
    CustomToggleButton.Name = "CustomToggleButton"
    CustomToggleButton.BackgroundColor3 = Library.Scheme.BackgroundColor
    CustomToggleButton.Image = "rbxassetid://74169651953690"
    CustomToggleButton.ScaleType = Enum.ScaleType.Fit
    CustomToggleButton.Size = UDim2.fromOffset(40, 40)
    CustomToggleButton.Position = UDim2.fromOffset(6, 6)
    CustomToggleButton.ZIndex = 10
    CustomToggleButton.Parent = Library.ScreenGui

    local ToggleButtonCorner = Instance.new("UICorner")
    ToggleButtonCorner.CornerRadius = UDim.new(0, Library.CornerRadius)
    ToggleButtonCorner.Parent = CustomToggleButton

    Library:AddOutline(CustomToggleButton)
    Library:MakeDraggable(CustomToggleButton, CustomToggleButton, true)

    if not table.find(Library.DraggableElements, CustomToggleButton) then
        table.insert(Library.DraggableElements, CustomToggleButton)
    end

    CustomToggleButton.InputBegan:Connect(function(Input)
        if Input.UserInputType ~= Enum.UserInputType.MouseButton1 and Input.UserInputType ~= Enum.UserInputType.Touch then
            return
        end

        local Start = tick()
        local Changed
        Changed = Input.Changed:Connect(function()
            if Input.UserInputState ~= Enum.UserInputState.End then
                return
            end

            local IsLikelyDragging = tick() - Start > 0.35
            if not IsLikelyDragging then
                Library:Toggle()
            end

            if Changed and Changed.Connected then
                Changed:Disconnect()
                Changed = nil
            end
        end)
    end)
end

-- ============ GET WEAPONS ============
local GetWeaponsBox = Tabs.Teleports:AddLeftGroupbox("Get Weapons", "sword")

GetWeaponsBox:AddDropdown("GetWeaponsList", {
    Values = {"MP5", "AK-47", "M4A1", "FAL", "Remington 870", "M700"},
    Multi = true,
    Text = "Select Weapons to Get",
    Tooltip = "Choose which weapons you want to receive",
    Callback = function(Value)
        local list = {}
        for name, selected in pairs(Value or {}) do
            if selected then
                table.insert(list, name)
            end
        end
        getgenv().SilentAimSettings.GetWeaponsList = list
    end,
})

GetWeaponsBox:AddButton({
    Text = "Get Weapons",
    Func = function()
        if getgenv().GetWeapons then
            getgenv().GetWeapons()
        end
    end,
})

GetWeaponsBox:AddDivider()

GetWeaponsBox:AddCheckbox("AutoGetWeapons", {
    Text = "Auto get Weapons",
    Default = false,
    Callback = function(v)
        getgenv().SilentAimSettings.AutoGetWeapons = v
    end,
})

-- ============ PLAYERS TAB ============
local PlayerSettingsBox = Tabs.Teleports:AddLeftGroupbox("Misc", "sliders")

PlayerSettingsBox:AddCheckbox("Noclip", {
    Text = "Noclip",
    Tooltip = "Allows you to walk through walls and objects",
    Default = false,
    Callback = function(v)
        getgenv().SetNoclipEnabled(v)
    end,
})

PlayerSettingsBox:AddCheckbox("InfiniteJump", {
    Text = "Infinite Jump",
    Tooltip = "Allows you to jump infinitely in the air",
    Default = false,
    Callback = function(v)
        getgenv().SetInfiniteJumpEnabled(v)
    end,
})

PlayerSettingsBox:AddCheckbox("InfiniteStamina", {
    Text = "Infinite Stamina",
    Tooltip = "Disables the jump cooldown",
    Default = false,
    Callback = function(v)
        getgenv().SilentAimSettings.InfiniteStamina = v
    end,
})

PlayerSettingsBox:AddCheckbox("Invisible", {
    Text = "Invisible",
    Default = false,
    Callback = function(v)
        getgenv().SetInvisibleEnabled(v)
    end,
})

PlayerSettingsBox:AddCheckbox("AntiInvisible", {
    Text = "Anti-Invisible",
    Default = false,
    Callback = function(v)
        getgenv().SetAntiInvisibleEnabled(v)
    end,
})

PlayerSettingsBox:AddCheckbox("Korblox", {
    Text = "Korblox",
    Default = false,
    Callback = function(v)
        getgenv().SetKorbloxEnabled(v)
    end,
})

PlayerSettingsBox:AddCheckbox("Headless", {
    Text = "Headless",
    Default = false,
    Callback = function(v)
        getgenv().SetHeadlessEnabled(v)
    end,
})

PlayerSettingsBox:AddCheckbox("AntiSit", {
    Text = "Anti Sit",
    Tooltip = "Prevents you from sitting on any seat, except the driver seat of a vehicle",
    Default = false,
    Callback = function(v)
        getgenv().SetAntiSitEnabled(v)
    end,
})

PlayerSettingsBox:AddCheckbox("CameraFOVEnabled", {
    Text = "Enable Camera FOV",
    Tooltip = "Enables custom camera FOV, otherwise uses the game's default",
    Default = false,
    Callback = function(v)
        getgenv().SilentAimSettings.CameraFOVEnabled = v
    end,
})

PlayerSettingsBox:AddSlider("CameraFOV", {
    Text = "Camera FOV",
    Tooltip = "Changes camera FOV",
    Default = 70,
    Min = 30,
    Max = 120,
    Rounding = 0,
    Callback = function(Value)
        getgenv().SilentAimSettings.CameraFOV = Value
        workspace.CurrentCamera.FieldOfView = Value
    end,
})

PlayerSettingsBox:AddSlider("SpinbotSpeed", {
    Text = "Spinbot",
    Tooltip = "Spins your character at the chosen speed.",
    Default = 0,
    Min = 0,
    Max = 250,
    Rounding = 1,
    Callback = function(Value)
        getgenv().SilentAimSettings.SpinbotSpeed = Value
    end,
})

PlayerSettingsBox:AddDivider()

PlayerSettingsBox:AddButton({
    Text = "Activate Anti-Tase",
    Func = function()
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local remote = nil
        pcall(function()
            remote = ReplicatedStorage:WaitForChild("GunRemotes", 5):WaitForChild("PlayerTased", 5)
        end)

        task.spawn(function()
            while true do
                if remote then
                    local ok, connections = pcall(getconnections, remote.OnClientEvent)
                    if ok then
                        for _, conn in connections do
                            conn:Disable()
                        end
                    end
                end
                task.wait(0.5)
            end
        end)
        
        Library:Notify({ Title = "Anti-Tase", Text = "Anti-Tase enabled️" })
    end,
})

-- ============ ENVIRONMENT GROUP ============
local EnvironmentBox = Tabs.Teleports:AddLeftGroupbox("Environment", "trees")

EnvironmentBox:AddLabel("World appearance settings", true)

local EnvironmentTabbox = EnvironmentBox:AddTabbox()
local EnvironmentNetworkTab = EnvironmentTabbox:AddTab(nil, "globe")
local EnvironmentCloudTab = EnvironmentTabbox:AddTab(nil, "cloud")

-- ============ WORLD GRADIENT ============
local WorldGradientEnabled = false
local DefaultAmbient = game:GetService("Lighting").Ambient
local DefaultOutdoorAmbient = game:GetService("Lighting").OutdoorAmbient
local CurrentGradientColor = Color3.fromRGB(255, 255, 255)
local CurrentOutdoorGradient = Color3.fromRGB(255, 255, 255)

EnvironmentNetworkTab:AddCheckbox("WorldGradient", {
    Text = "World Gradient",
    Tooltip = "Enables custom world gradient colors",
    Default = false,
    Callback = function(v)
        WorldGradientEnabled = v
        if v then
            game:GetService("Lighting").Ambient = CurrentGradientColor
            game:GetService("Lighting").OutdoorAmbient = CurrentOutdoorGradient
        else
            game:GetService("Lighting").Ambient = DefaultAmbient
            game:GetService("Lighting").OutdoorAmbient = DefaultOutdoorAmbient
        end
    end,
})

EnvironmentNetworkTab:AddLabel("Gradient Color"):AddColorPicker("GradientColor", {
    Default = Color3.fromRGB(255, 255, 255),
    Title = "Gradient Color",
    Text = "Gradient Color",
    Tooltip = "Sets the world gradient color",
    Callback = function(Value)
        CurrentGradientColor = Value
        if WorldGradientEnabled then
            game:GetService("Lighting").Ambient = Value
        end
    end,
})

EnvironmentNetworkTab:AddLabel("Outdoor Gradient"):AddColorPicker("OutdoorGradient", {
    Default = Color3.fromRGB(255, 255, 255),
    Title = "Outdoor Gradient",
    Text = "Outdoor Gradient",
    Tooltip = "Sets the outdoor gradient color",
    Callback = function(Value)
        CurrentOutdoorGradient = Value
        if WorldGradientEnabled then
            game:GetService("Lighting").OutdoorAmbient = Value
        end
    end,
})

EnvironmentNetworkTab:AddDivider()

EnvironmentNetworkTab:AddCheckbox("RemoveFog", {
    Text = "Remove Fog",
    Tooltip = "Removes the fog from the game",
    Default = false,
    Callback = function(v)
        if v then
            game:GetService("Lighting").FogEnd = 100000
            game:GetService("Lighting").FogStart = 100000
        else
            game:GetService("Lighting").FogEnd = 5000
            game:GetService("Lighting").FogStart = 500
        end
    end,
}):AddColorPicker("FogColor", {
    Default = Color3.fromRGB(100, 100, 100),
    Title = "Fog Color",
    Text = "Fog Color",
    Tooltip = "Choose the fog color",
    Callback = function(Value)
        setFogColorRGB(Value)
    end,
})

-- ============ CUSTOM SKYBOX ============
local CustomSkyboxEnabled = false
local CurrentSkybox = "None"

EnvironmentCloudTab:AddCheckbox("CustomSkybox", {
    Text = "Custom Skybox",
    Tooltip = "Enables applying a custom skybox",
    Default = false,
    Callback = function(v)
        CustomSkyboxEnabled = v
        if v then
            setSkybox(CurrentSkybox)
        else
            setSkybox("None")
        end
    end,
})

EnvironmentCloudTab:AddDropdown("Skyboxes", {
    Values = {"None", "Gray Skybox", "2knw & Donk666 Skybox", "Snow Skybox", "Cartoon Skybox", "Lince Skybox", "Red Skybox", "Slam Skybox", "Green Eyeball Skybox", "Morioh Skybox", "Rainy Skybox", "Rusk1ddski Skybox"},
    Default = "None",
    Text = "Skyboxes",
    Tooltip = "Choose your skybox",
    Callback = function(Value)
        CurrentSkybox = Value
        if CustomSkyboxEnabled then
            setSkybox(Value)
        end
    end,
})

local playerOptions = {"Select a player..."}
for _, plr in ipairs(Players:GetPlayers()) do
    if plr ~= player then
        table.insert(playerOptions, plr.Name)
    end
end

local viewPlayerOptions = {"Select a player..."}
for _, plr in ipairs(Players:GetPlayers()) do
    if plr ~= player then
        table.insert(viewPlayerOptions, plr.Name)
    end
end

local SPECTATE_PLAYER = nil
local spectateConnection = nil

local function stopSpectate()
    if spectateConnection then
        spectateConnection:Disconnect()
        spectateConnection = nil
    end
    if player.Character then
        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            workspace.CurrentCamera.CameraSubject = humanoid
        end
    end
end

local function startSpectate(targetName)
    if spectateConnection then
        spectateConnection:Disconnect()  
        spectateConnection = nil
    end
    
    local target = Players:FindFirstChild(targetName)
    if not target or not target.Character then return end
    
    local humanoid = target.Character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    
    workspace.CurrentCamera.CameraSubject = humanoid
    spectateConnection = RunService.RenderStepped:Connect(function()
        if target and target.Character then
            local hum = target.Character:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                workspace.CurrentCamera.CameraSubject = hum
            end
        end
    end)
end

-- ============ AIMBOT TAB ============
local AimbotLeftBox = Tabs.Aimbot:AddLeftGroupbox("Aim Settings", "crosshair")

AimbotLeftBox:AddCheckbox("SilentAim", {
    Text = "Silent Aim",
    Tooltip = "Silent Aim method by 7zz",
    Default = true,
    Callback = function(v)
        getgenv().SilentAimSettings.Enabled = v
    end,
})

AimbotLeftBox:AddCheckbox("Autoshoot", {
    Text = "Autoshoot",
    Tooltip = "Automatically fires when Silent Aim has a locked target",
    Default = false,
    Callback = function(v)
        getgenv().SilentAimSettings.Autoshoot = v
    end,
})

AimbotLeftBox:AddCheckbox("WallCheck", {
    Text = "Wall Check",
    Tooltip = "Ignore Players behind Walls",
    Default = true,
    Callback = function(v)
        getgenv().SilentAimSettings.VisibleCheck = v
    end,
})

AimbotLeftBox:AddCheckbox("TeamCheck", {
    Text = "Team Check",
    Tooltip = "Ignore Players on your Team",
    Default = true,
    Callback = function(v)
        getgenv().SilentAimSettings.TeamCheck = v
    end,
})

AimbotLeftBox:AddCheckbox("FriendCheck", {
    Text = "Friend Check",
    Tooltip = "Ignore your Friends",
    Default = true,
    Callback = function(v)
        getgenv().SilentAimSettings.FriendCheck = v
    end,
})

AimbotLeftBox:AddCheckbox("ForceFieldCheck", {
    Text = "ForceField Check",
    Tooltip = "Ignore players who currently have a ForceField",
    Default = true,
    Callback = function(v)
        getgenv().SilentAimSettings.ForceFieldCheck = v
    end,
})

local AutoshootWarningLabel = AimbotLeftBox:AddLabel("Note: Autoshot is not compatible with Hitchance", true)

do
    local warningInstance = AutoshootWarningLabel.Holder and AutoshootWarningLabel.Holder:FindFirstChildOfClass("TextLabel")
    if warningInstance then
        warningInstance.TextColor3 = Color3.fromRGB(255, 70, 70)
    end
end

AimbotLeftBox:AddDivider()

AimbotLeftBox:AddDropdown("TargetTeams", {
    Values = {"Inmates", "Guards", "Criminals"},
    Multi = true,
    Text = "Target Teams",
    Tooltip = "Selected teams are the ones Silent Aim will target (deselect a team to ignore it)",
    Callback = function(Value)
        getgenv().SilentAimSettings.TargetTeams = Value or {}
    end,
})

Options.TargetTeams:SetValue({ Inmates = true, Guards = true, Criminals = true })

-- ============ TARGET MODE ============
local lastTargetModeSelection = { ["Manual"] = true }
local updateInProgress = false

AimbotLeftBox:AddDropdown("TargetMode", {
    Values = {"Manual", "🔗 Trespass", "💢 Hostile"},
    Multi = true,
    Default = { ["Manual"] = true },
    Text = "Target Mode",
    Tooltip = "Manual grabs any valid player. Trespass/Hostile restrict targeting to inmates flagged as such (can combine both, but not with Manual)",
    Callback = function(Value)
        if updateInProgress then return end
        updateInProgress = true
        
        task.defer(function()
            Value = Value or {}

            local wasManual = lastTargetModeSelection["Manual"]
            local isManual = Value["Manual"]
            local isTrespass = Value["🔗 Trespass"]
            local isHostile = Value["💢 Hostile"]

            local manualJustSelected = isManual and not wasManual

            local finalValue = {}

            if manualJustSelected then
                finalValue = { ["Manual"] = true }
            elseif isTrespass or isHostile then
                if isTrespass then finalValue["🔗 Trespass"] = true end
                if isHostile then finalValue["💢 Hostile"] = true end
            else
                finalValue = { ["Manual"] = true }
            end

            lastTargetModeSelection = finalValue

            getgenv().SilentAimSettings.TrespassCheck = finalValue["🔗 Trespass"] == true
            getgenv().SilentAimSettings.HostileCheck = finalValue["💢 Hostile"] == true

            Options.TargetMode:SetValue(finalValue)
            updateInProgress = false
        end)
    end,
})

local targetOptions = {}
for _, plr in ipairs(Players:GetPlayers()) do
    if plr ~= player then
        table.insert(targetOptions, plr.Name)
    end
end

AimbotLeftBox:AddDropdown("AimMode", {
    Values = {"FOV", "Distance"},
    Default = "FOV",
    Text = "Targeting Mode",
    Tooltip = "FOV: Locks on players within FOV radius | Distance: Locks on closest visible player",
    Callback = function(Value)
        getgenv().SilentAimSettings.AimMode = Value
    end,
})

AimbotLeftBox:AddDropdown("TargetPart", {
    Values = {"Head", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg", "HumanoidRootPart", "Random"},
    Default = "HumanoidRootPart",
    Text = "Target Part",
    Tooltip = "Choose which body part the Silent Aim will lock onto. Random cycles part every 0.5s",
    Callback = function(Value)
        getgenv().SilentAimSettings.TargetPart = Value
    end,
})

-- ============ HITBOX EXPANDER ============
local HitboxExpanderBox = Tabs.Aimbot:AddLeftGroupbox("Hitbox Expander", "maximize-2")
HitboxExpanderBox:SetDescription("Enlarges player hitboxes")

HitboxExpanderBox:AddCheckbox("EnableHitboxExpander", {
    Text = "Enable Hitbox Expander",
    Default = false,
    Callback = function(v)
        getgenv().SilentAimSettings.HitboxExpanderEnabled = v
    end,
})

HitboxExpanderBox:AddCheckbox("HitboxTeamCheck", {
    Text = "Team Check",
    Default = true,
    Callback = function(v)
        getgenv().SilentAimSettings.HitboxTeamCheck = v
    end,
})

HitboxExpanderBox:AddSlider("HitboxSize", {
    Text = "Hitbox Size",
    Default = 1,
    Min = 1,
    Max = 15,
    Rounding = 0,
    Callback = function(Value)
        getgenv().SilentAimSettings.HitboxSize = Value
    end,
})

HitboxExpanderBox:AddSlider("HitboxTransparency", {
    Text = "Hitbox Transparency",
    Default = 0.5,
    Min = 0,
    Max = 1,
    Rounding = 1,
    Callback = function(Value)
        getgenv().SilentAimSettings.HitboxTransparency = Value
    end,
})

HitboxExpanderBox:AddDropdown("HitboxShape", {
    Values = {"Box", "Ball"},
    Default = "Box",
    Text = "Hitbox Shape",
    Callback = function(Value)
        getgenv().SilentAimSettings.HitboxShape = Value
    end,
})

-- ============ AIMBOT SLIDERS ============
local AimbotMidBox = Tabs.Aimbot:AddLeftGroupbox("Smoothing & Accuracy", "target")

AimbotMidBox:AddSlider("SilentAimRange", {
    Text = "Silent Aim Range",
    Tooltip = "Color of the highlight when a player is your target",
    Default = 500,
    Min = 30,
    Max = 2000,
    Rounding = 0,
    Callback = function(Value)
        getgenv().SilentAimSettings.SilentAimRange = Value
    end,
})

AimbotMidBox:AddSlider("Smoothing", {
    Text = "Smoothing",
    Default = 0,
    Min = 0,
    Max = 1,
    Rounding = 1,
    Callback = function(Value)
        getgenv().SilentAimSettings.Smoothing = Value
    end,
})

AimbotMidBox:AddSlider("HitChance", {
    Text = "Hit Chance",
    Default = 100,
    Min = 0,
    Max = 100,
    Rounding = 1,
    Callback = function(Value)
        getgenv().SilentAimSettings.HitChance = Value
    end,
})

-- ============ FOV SECTION ============
local FOVBox = Tabs.Aimbot:AddRightGroupbox("Settings", "settings")

local FOVIconTabbox = FOVBox:AddTabbox()
local FOVEyeTab = FOVIconTabbox:AddTab(nil, "scan-eye")
local FOVUsersTab = FOVIconTabbox:AddTab(nil, "users")

FOVEyeTab:AddCheckbox("HideFOV", {
    Text = "Show FOV Circle",
    Default = true,
    Callback = function(v)
        toggleFOVCircle(not v)
    end,
}):AddColorPicker("FOVColor", {
    Default = Color3.fromRGB(255, 255, 255),
    Title = "FOV Color",
    Text = "FOV Color",
    Tooltip = "Choose the FOV circle color",
    Callback = function(Value)
        setFOVColorRGB(Value)
    end,
})

FOVEyeTab:AddSlider("FOVSize", {
    Text = "FOV Circle Radius",
    Default = 100,
    Min = 30,
    Max = 500,
    Rounding = 0,
    Callback = function(Value)
        getgenv().SilentAimSettings.FOVRadius = Value
    end,
})

FOVUsersTab:AddDropdown("TargetOn", {
    Values = targetOptions,
    Default = 1,
    Text = "Target On",
    Tooltip = "Select specific players to target",
    Multi = true,
    AllowNull = true,
    Callback = function(Value)
        local list = {}
        for name, selected in pairs(Value or {}) do
            if selected then
                table.insert(list, name)
            end
        end
        getgenv().SilentAimSettings.TargetOnPlayer = list
    end,
})

FOVUsersTab:AddButton({
    Text = "Reset Target",
    Func = function()
        getgenv().SilentAimSettings.TargetOnPlayer = {}
        local newOptions = {}
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= player then
                table.insert(newOptions, plr.Name)
            end
        end
        Options.TargetOn:SetValues(newOptions)
        Options.TargetOn:SetValue({})
    end,
})

FOVUsersTab:AddDropdown("IgnoreTarget", {
    Values = targetOptions,
    Default = 1,
    Text = "Ignore Target",
    Tooltip = "Select players to completely ignore",
    Multi = true,
    AllowNull = true,
    Callback = function(Value)
        local list = {}
        for name, selected in pairs(Value or {}) do
            if selected then
                table.insert(list, name)
            end
        end
        getgenv().SilentAimSettings.IgnoreTargets = list
    end,
})

FOVUsersTab:AddButton({
    Text = "Reset Ignore List",
    Func = function()
        getgenv().SilentAimSettings.IgnoreTargets = {}
        local newOptions = {}
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= player then
                table.insert(newOptions, plr.Name)
            end
        end
        Options.IgnoreTarget:SetValues(newOptions)
        Options.IgnoreTarget:SetValue({})
    end,
})

-- ============ FAST SWITCH BUTTON ============
local FastSwitchOnColor = Color3.fromRGB(150, 199, 150)

local FastSwitchButton = Instance.new("TextButton")
FastSwitchButton.Name = "FastSwitchButton"
FastSwitchButton.AutoButtonColor = false
FastSwitchButton.BackgroundColor3 = Library.Scheme.MainColor
FastSwitchButton.Position = UDim2.fromOffset(6, 52)
FastSwitchButton.Size = UDim2.fromOffset(130, 32)
FastSwitchButton.Text = "Fast Switch: OFF"
FastSwitchButton.TextColor3 = Library.Scheme.FontColor
FastSwitchButton.Font = Enum.Font.Gotham
FastSwitchButton.TextSize = 14
FastSwitchButton.ZIndex = 10
FastSwitchButton.Visible = false
FastSwitchButton.Parent = Library.ScreenGui

local FastSwitchButtonCorner = Instance.new("UICorner")
FastSwitchButtonCorner.CornerRadius = UDim.new(0, Library.CornerRadius)
FastSwitchButtonCorner.Parent = FastSwitchButton
table.insert(Library.Corners, FastSwitchButtonCorner)

Library:AddOutline(FastSwitchButton)
Library:MakeDraggable(FastSwitchButton, FastSwitchButton, true)

if not table.find(Library.DraggableElements, FastSwitchButton) then
    table.insert(Library.DraggableElements, FastSwitchButton)
end

local function updateFastSwitchButtonVisual()
    local enabled = getgenv().SilentAimSettings.GunSwitchEnabled
    FastSwitchButton.Text = enabled and "Fast Switch: ON" or "Fast Switch: OFF"

    if enabled then
        FastSwitchButton.BackgroundColor3 = FastSwitchOnColor
        Library:AddToRegistry(FastSwitchButton, { TextColor3 = "FontColor" })
    else
        FastSwitchButton.BackgroundColor3 = Library.Scheme.MainColor
        Library:AddToRegistry(FastSwitchButton, {
            BackgroundColor3 = "MainColor",
            TextColor3 = "FontColor",
        })
    end
end

local FastSwitchLockedPosition = nil
local FastSwitchPositionConnection = nil

local function setFastSwitchLocked(locked)
    if locked then
        FastSwitchLockedPosition = FastSwitchButton.Position
        if not FastSwitchPositionConnection then
            FastSwitchPositionConnection = FastSwitchButton:GetPropertyChangedSignal("Position"):Connect(function()
                if FastSwitchLockedPosition then
                    FastSwitchButton.Position = FastSwitchLockedPosition
                end
            end)
        end
    else
        if FastSwitchPositionConnection then
            FastSwitchPositionConnection:Disconnect()
            FastSwitchPositionConnection = nil
        end
        FastSwitchLockedPosition = nil
    end
end

local FASTSWITCH_CLICK_THRESHOLD = 0.35
local FastSwitchHoldMode = false

FastSwitchButton.InputBegan:Connect(function(Input)
    if Input.UserInputType ~= Enum.UserInputType.MouseButton1 and Input.UserInputType ~= Enum.UserInputType.Touch then
        return
    end

    if FastSwitchHoldMode then
        getgenv().ToggleGunSwitch(true)
        updateFastSwitchButtonVisual()

        local Changed
        Changed = Input.Changed:Connect(function()
            if Input.UserInputState ~= Enum.UserInputState.End and Input.UserInputState ~= Enum.UserInputState.Cancel then
                return
            end

            getgenv().ToggleGunSwitch(false)
            updateFastSwitchButtonVisual()

            if Changed and Changed.Connected then
                Changed:Disconnect()
                Changed = nil
            end
        end)
        return
    end

    local Start = tick()
    local Changed
    Changed = Input.Changed:Connect(function()
        if Input.UserInputState ~= Enum.UserInputState.End then
            return
        end

        local IsLikelyDragging = tick() - Start > FASTSWITCH_CLICK_THRESHOLD
        if not IsLikelyDragging then
            local newState = not getgenv().SilentAimSettings.GunSwitchEnabled
            getgenv().ToggleGunSwitch(newState)
            updateFastSwitchButtonVisual()
        end

        if Changed and Changed.Connected then
            Changed:Disconnect()
            Changed = nil
        end
    end)
end)

-- ============ VEHICLE FLY BUTTON ============
local VehicleFlyOnColor = Color3.fromRGB(150, 199, 150)

local VehicleFlyButton = Instance.new("TextButton")
VehicleFlyButton.Name = "VehicleFlyButton"
VehicleFlyButton.AutoButtonColor = false
VehicleFlyButton.BackgroundColor3 = Library.Scheme.MainColor
VehicleFlyButton.Position = UDim2.fromOffset(6, 90)
VehicleFlyButton.Size = UDim2.fromOffset(130, 32)
VehicleFlyButton.Text = "Vehicle Fly: OFF"
VehicleFlyButton.TextColor3 = Library.Scheme.FontColor
VehicleFlyButton.Font = Enum.Font.Gotham
VehicleFlyButton.TextSize = 14
VehicleFlyButton.ZIndex = 10
VehicleFlyButton.Visible = false
VehicleFlyButton.Parent = Library.ScreenGui

local VehicleFlyButtonCorner = Instance.new("UICorner")
VehicleFlyButtonCorner.CornerRadius = UDim.new(0, Library.CornerRadius)
VehicleFlyButtonCorner.Parent = VehicleFlyButton
table.insert(Library.Corners, VehicleFlyButtonCorner)

Library:AddOutline(VehicleFlyButton)
Library:MakeDraggable(VehicleFlyButton, VehicleFlyButton, true)

if not table.find(Library.DraggableElements, VehicleFlyButton) then
    table.insert(Library.DraggableElements, VehicleFlyButton)
end

local function updateVehicleFlyButtonVisual()
    local enabled = getgenv().SilentAimSettings.VehicleFlyEnabled
    VehicleFlyButton.Text = enabled and "Vehicle Fly: ON" or "Vehicle Fly: OFF"

    if enabled then
        VehicleFlyButton.BackgroundColor3 = VehicleFlyOnColor
        Library:AddToRegistry(VehicleFlyButton, { TextColor3 = "FontColor" })
    else
        VehicleFlyButton.BackgroundColor3 = Library.Scheme.MainColor
        Library:AddToRegistry(VehicleFlyButton, {
            BackgroundColor3 = "MainColor",
            TextColor3 = "FontColor",
        })
    end
end

local function toggleVehicleFly(newState)
    getgenv().SilentAimSettings.VehicleFlyEnabled = newState
    updateVehicleFlyButtonVisual()
end

local VEHICLEFLY_CLICK_THRESHOLD = 0.35

VehicleFlyButton.InputBegan:Connect(function(Input)
    if Input.UserInputType ~= Enum.UserInputType.MouseButton1 and Input.UserInputType ~= Enum.UserInputType.Touch then
        return
    end

    local Start = tick()
    local Changed
    Changed = Input.Changed:Connect(function()
        if Input.UserInputState ~= Enum.UserInputState.End then
            return
        end

        local IsLikelyDragging = tick() - Start > VEHICLEFLY_CLICK_THRESHOLD
        if not IsLikelyDragging then
            toggleVehicleFly(not getgenv().SilentAimSettings.VehicleFlyEnabled)
        end

        if Changed and Changed.Connected then
            Changed:Disconnect()
            Changed = nil
        end
    end)
end)

updateVehicleFlyButtonVisual()

task.spawn(function()
    while true do
        task.wait(0.1)
        updateVehicleFlyButtonVisual()
    end
end)

local VehicleFlyLockedPosition = nil
local VehicleFlyPositionConnection = nil

local function setVehicleFlyLocked(locked)
    if locked then
        VehicleFlyLockedPosition = VehicleFlyButton.Position
        if not VehicleFlyPositionConnection then
            VehicleFlyPositionConnection = VehicleFlyButton:GetPropertyChangedSignal("Position"):Connect(function()
                if VehicleFlyLockedPosition then
                    VehicleFlyButton.Position = VehicleFlyLockedPosition
                end
            end)
        end
    else
        if VehicleFlyPositionConnection then
            VehicleFlyPositionConnection:Disconnect()
            VehicleFlyPositionConnection = nil
        end
        VehicleFlyLockedPosition = nil
    end
end

-- ============ GUN SWITCHER ============
local GunSwitcherBox = Tabs.Aimbot:AddRightGroupbox("Gun Switcher", "repeat")

GunSwitcherBox:AddDropdown("SelectGunsToSwitch", {
    Values = {"M9", "Revolver", "MP5", "AK-47", "M4A1", "FAL", "Remington 870", "M700"},
    Multi = true,
    Text = "Select Guns to Switch",
    Tooltip = "Choose which guns to cycle through",
    Callback = function(Value)
        local list = {}
        for name, selected in pairs(Value or {}) do
            if selected then
                table.insert(list, name)
            end
        end
        getgenv().SilentAimSettings.GunSwitchList = list
    end,
})

GunSwitcherBox:AddSlider("SwitchDelay", {
    Text = "Switch Delay",
    Default = 0.001,
    Min = 0.001,
    Max = 1,
    Rounding = 2,
    Callback = function(Value)
        getgenv().SilentAimSettings.GunSwitchDelay = Value
    end,
})

GunSwitcherBox:AddDivider()

GunSwitcherBox:AddCheckbox("ShowGunSwitchButton", {
    Text = "Show Fast Switch Button",
    Default = false,
    Callback = function(v)
        FastSwitchButton.Visible = v
    end,
})

GunSwitcherBox:AddCheckbox("LockFastSwitchButton", {
    Text = "Lock Fast Switch Button",
    Default = false,
    Callback = function(v)
        setFastSwitchLocked(v)
    end,
})

GunSwitcherBox:AddCheckbox("HoldFastSwitchButton", {
    Text = "Hold Fast Switch Button to Enable",
    Default = false,
    Callback = function(v)
        FastSwitchHoldMode = v

        if getgenv().SilentAimSettings.GunSwitchEnabled then
            getgenv().ToggleGunSwitch(false)
            updateFastSwitchButtonVisual()
        end
    end,
})

GunSwitcherBox:AddCheckbox("CycleAllWeapons", {
    Text = "Cycle All Weapons",
    Tooltip = "Automatically includes every weapon you own in Fast Switch, ignoring the dropdown selection above",
    Default = false,
    Callback = function(v)
        getgenv().SilentAimSettings.GunSwitchCycleAll = v
    end,
})

GunSwitcherBox:AddLabel("Fast Switch Keybind"):AddKeyPicker("FastSwitchKeybind", {
    Default = "None",
    NoUI = false,
    Text = "Fast Switch Keybind",
    Callback = function()
        local newState = not getgenv().SilentAimSettings.GunSwitchEnabled
        getgenv().ToggleGunSwitch(newState)
        updateFastSwitchButtonVisual()
    end,
})

task.spawn(function()
    while true do
        task.wait(0.1)
        local keyValue = Options.FastSwitchKeybind.Value
        getgenv().SilentAimSettings.FastSwitchKeyCode = keyValue
    end
end)

-- ============ WEAPON MODIFICATIONS ============
local WeaponModBox = Tabs.Aimbot:AddRightGroupbox("Weapon Mod", "sword")
local WeaponModsTabbox = WeaponModBox:AddTabbox()

local GunModTab = WeaponModsTabbox:AddTab(nil, "wrench")

GunModTab:AddCheckbox("WeaponMod", {
    Text = "Weapon Mod",
    Default = false,
    Callback = function(v)
        getgenv().SetGunModEnabled(v)
    end,
})

GunModTab:AddDivider()

GunModTab:AddCheckbox("AutoFire", {
    Text = "Auto Fire",
    Default = false,
    Callback = function(v)
        getgenv().SetGunModAutoFire(v)
    end,
})

GunModTab:AddCheckbox("FastFirerate", {
    Text = "Fast Firerate",
    Default = false,
    Callback = function(v)
        getgenv().SetGunModFastFirerate(v)
    end,
})

GunModTab:AddCheckbox("AutoReload", {
    Text = "Auto Reload",
    Tooltip = "Automatically reloads the weapon when ammo reaches 0",
    Default = false,
    Callback = function(v)
        getgenv().SetAutoReloadEnabled(v)
    end,
})

GunModTab:AddDivider("Custom Values")

GunModTab:AddSlider("FireRateValue", {
    Text = "Fire Rate",
    Default = 0.001,
    Min = 0.001,
    Max = 0.1,
    Rounding = 2,
    Callback = function(Value)
        getgenv().SetGunModFireRate(Value)
    end,
})

local ChainTab = WeaponModsTabbox:AddTab(nil, "cable")

ChainTab:AddCheckbox("CustomBulletColor", {
    Text = "Custom Bullet Color",
    Tooltip = "Applies a custom color to all bullets, current and future weapons",
    Default = false,
    Callback = function(v)
        setCustomBulletColorEnabled(v)
    end,
})

ChainTab:AddDivider()

ChainTab:AddLabel("Bullet Color"):AddColorPicker("BulletColor", {
    Default = Color3.fromRGB(255, 255, 0),
    Title = "Bullet Color",
    Text = "Bullet Color",
    Tooltip = "Sets the color of all bullets when enabled",
    Callback = function(Value)
        setBulletColorRGB(Value)
    end,
})

local PaintTab = WeaponModsTabbox:AddTab(nil, "paintbrush")
PaintTab:AddCheckbox("EnableWeaponColor", {
    Text = "Enable Weapon Color",
    Default = false,
    Callback = function(v)
        getgenv().SetWeaponColorEnabled(v)
    end,
}):AddColorPicker("WeaponColor", {
    Default = Color3.fromRGB(255, 255, 255),
    Title = "Weapon Color",
    Text = "Weapon Color",
    Tooltip = "Sets the color of your weapon",
    Callback = function(Value)
        getgenv().SetWeaponColorRGB(Value)
    end,
})

PaintTab:AddCheckbox("EnableWeaponTexture", {
    Text = "Enable Weapon Texture",
    Default = false,
    Callback = function(v)
        getgenv().SetWeaponTextureEnabled(v)
    end,
})

PaintTab:AddDivider()

PaintTab:AddSlider("WeaponTransparency", {
    Text = "Weapon Transparency",
    Default = 0,
    Min = 0,
    Max = 1,
    Rounding = 1,
    Callback = function(Value)
        getgenv().SetWeaponTransparency(Value)
    end,
})

PaintTab:AddDropdown("WeaponMaterial", {
    Values = {"ForceField", "SmoothPlastic", "DiamondPlate", "Metal", "Marble", "Neon"},
    Default = "SmoothPlastic",
    Text = "Weapon Material",
    Tooltip = "Sets the material of your weapon",
    Callback = function(Value)
        getgenv().SetWeaponMaterial(Value)
    end,
})

PaintTab:AddDropdown("WeaponTexture", {
    Values = {
        "Matrix",
        "Blue Void",
        "Classic blue White",
        "Green and Black",
        "White",
        "Blue sky's with White Guns",
        "Water Skin",
        "Aurora",
        "Epic White",
        "Pink White",
        "Blue Stars",
    },
    Default = "Matrix",
    Text = "Weapon Texture",
    Tooltip = "Sets the texture of your weapon",
    Callback = function(Value)
        getgenv().SetWeaponTexture(Value)
    end,
})

PaintTab:AddLabel("Credits to OnlyAdrian", true)


local SoundTab = WeaponModsTabbox:AddTab(nil, "volume-2")
local NotifyTab = WeaponModsTabbox:AddTab(nil, "bell")

SoundTab:AddDropdown("WeaponSoundPack", {
    Values = {"None", "Silenced Shot", "Bubble Shot", "Laser Shot", "Dart Gun", "Energy Shot", "Neverlose"},
    Default = "None",
    Text = "Custom Shot Sound",
    Tooltip = "Applies a custom shoot sound to all supported weapons",
    Callback = function(Value)
        getgenv().SetWeaponSoundPack(Value)
    end,
})

SoundTab:AddDivider()

SoundTab:AddCheckbox("CustomKillSound", {
    Text = "Custom Kill Sound",
    Default = false,
    Callback = function(v)
        getgenv().SetCustomKillSoundEnabled(v)
    end,
})

SoundTab:AddCheckbox("CustomHitSound", {
    Text = "Custom Hit Sound",
    Default = false,
    Callback = function(v)
        getgenv().SetCustomHitSoundEnabled(v)
    end,
})

SoundTab:AddDivider()

SoundTab:AddDropdown("KillSound", {
    Values = {
        "Fahhh",
        "Epic Kill 1",
        "Epic Kill 2",
        "Laugh",
        "Cat Laughing Meme",
        "Goofy Laugh",
        "PVZ Laugh",
        "CoD Kaboom",
        "You are a Idiot",
        "Creepy Bell",
        "Vine Boom",
        "RDR2 Low Honor",
        "Get Out",
        "Diahrrea Sound",
        "Goku Prowler",
        "iPhone Ding",
        "Bark Fart",
        "Enrique",
        "Fatality 2",
    },
    Default = 1,
    Text = "Kill Sound",
    Tooltip = "Select a custom kill sound",
    Callback = function(Value)
        getgenv().SetKillSound(Value)
    end,
})

SoundTab:AddDropdown("HitSound", {
    Values = {
        "TF2 Hit",
        "Metal Bat Hit",
        "Neverlose",
        "Minecraft Hit 1",
        "Minecraft Hit 2",
        "MLG Hit",
        "Fahhh Hit",
        "Xbox Live Notification",
        "Rust",
        "Fatality",
        "Skeet",
        "Pick",
        "Creepy Bell",
    },
    Default = 1,
    Text = "Hit Sound",
    Tooltip = "Select a custom hit sound",
    Callback = function(Value)
        getgenv().SetHitSound(Value)
    end,
})

NotifyTab:AddLabel("Effects")

NotifyTab:AddCheckbox("ColorScreenKillEffect", {
    Text = "Color Screen Kill Effect",
    Default = false,
    Callback = function(v)
        getgenv().SetKillEffectEnabled(v)
    end,
}):AddColorPicker("ColorScreenKillEffectColor", {
    Default = Color3.fromRGB(255, 255, 255),
    Title = "Kill Effect Color",
    Text = "Kill Effect Color",
    Tooltip = "Sets the color of the screen flash on kill",
    Callback = function(Value)
        getgenv().SetKillEffectColor(Value)
    end,
})

NotifyTab:AddSlider("ColorEffectFadeDuration", {
    Text = "Color Effect Fade Duration",
    Default = 0.25,
    Min = 0.05,
    Max = 1,
    Rounding = 2,
    Callback = function(Value)
        getgenv().SetKillEffectFadeDuration(Value)
    end,
})

NotifyTab:AddDivider("Logs")

NotifyTab:AddCheckbox("KillLogs", {
    Text = "Kill Logs",
    Default = false,
    Callback = function(v)
        getgenv().SetKillLogsEnabled(v)
    end,
})

NotifyTab:AddCheckbox("HitLogs", {
    Text = "Hit Logs",
    Default = false,
    Callback = function(v)
        getgenv().SetHitLogsEnabled(v)
    end,
})

-- ============ VISUALS TAB ============
local VisualsLeftBox = Tabs.Visuals:AddLeftGroupbox("Highlight ESP", "eye")

VisualsLeftBox:AddCheckbox("ESP", {
    Text = "Highlight ESP",
    Default = false,
    Callback = function(v)
        getgenv().SilentAimSettings.ESPEnabled = v
        updateESP()
    end,
})

VisualsLeftBox:AddLabel("Target Highlight Color"):AddColorPicker("ESPTargetColor", {
    Default = Color3.fromRGB(255, 182, 255),
    Title = "ESP Target Color",
    Text = "Target Highlight Color",
    Tooltip = "Color of the highlight when a player is your target",
    Callback = function(Value)
        setESPTargetColorRGB(Value)
    end,
})

local NameESPBox = Tabs.Visuals:AddLeftGroupbox("Name ESP", "type-outline")

NameESPBox:AddCheckbox("EnableNameESP", {
    Text = "Enable Name ESP",
    Tooltip = "Shows the names above players when ESP is active",
    Default = true,
    Callback = function(v)
        getgenv().SilentAimSettings.ESPNamesEnabled = v
        updateESP()
    end,
})

NameESPBox:AddCheckbox("EnableTargetNameESP", {
    Text = "Enable Target ESP Name",
    Tooltip = "Shows a 'Target' label below the name of your current target",
    Default = false,
    Callback = function(v)
        getgenv().SilentAimSettings.ESPTargetNameEnabled = v
    end,
})

NameESPBox:AddLabel("Text Color"):AddColorPicker("ESPTextColor", {
    Default = Color3.fromRGB(255, 255, 255),
    Title = "Text Color",
    Text = "Text Color",
    Tooltip = "Sets the color of the Name ESP text",
    Callback = function(Value)
        setESPTextColor(Value)
    end,
})

NameESPBox:AddLabel("Target Text Color"):AddColorPicker("ESPTargetTextColor", {
    Default = Color3.fromRGB(255, 182, 255),
    Title = "Target Text Color",
    Text = "Target Text Color",
    Tooltip = "Sets the color of the Target ESP Name text",
    Callback = function(Value)
        setESPTargetTextColor(Value)
    end,
})

NameESPBox:AddDivider()

NameESPBox:AddSlider("NameESPTextSize", {
    Text = "Name ESP Text Size",
    Default = 12,
    Min = 0,
    Max = 24,
    Rounding = 0,
    Callback = function(Value)
        getgenv().SilentAimSettings.ESPNameTextSize = Value
    end,
})

NameESPBox:AddSlider("TargetNameESPTextSize", {
    Text = "Target Name ESP Text Size",
    Default = 12,
    Min = 0,
    Max = 24,
    Rounding = 0,
    Callback = function(Value)
        getgenv().SilentAimSettings.ESPTargetNameTextSize = Value
    end,
})

NameESPBox:AddDivider()

NameESPBox:AddInput("TargetCustomText", {
    Text = "",
    Placeholder = "Target",
    ClearTextOnFocus = false,
    Finished = false,
})

do
    local holder = Options.TargetCustomText.Holder
    local box = holder and holder:FindFirstChildOfClass("TextBox")
    if box then
        box:GetPropertyChangedSignal("Text"):Connect(function()
            Options.TargetCustomText.Value = box.Text
        end)
    end
end

NameESPBox:AddButton({
    Text = "Reset",
    Func = function()
        Options.TargetCustomText:SetValue("")
        getgenv().SetTargetCustomText("Target")
    end,
})

NameESPBox:AddButton({
    Text = "Apply",
    Func = function()
        local text = Options.TargetCustomText.Value
        if not text or text == "" then
            text = "Target"
        end
        getgenv().SetTargetCustomText(text)
    end,
})

-- ============ TRACER ESP SECTION ============
local TracerBox = Tabs.Visuals:AddRightGroupbox("Tracer ESP", "zap")

TracerBox:AddCheckbox("TracerESP", {
    Text = "Tracer ESP",
    Tooltip = "Shows a beam to every visible player, colored by team",
    Default = false,
    Callback = function(v)
        getgenv().SilentAimSettings.TracerESPEnabled = v
    end,
})

TracerBox:AddSlider("TracerThickness", {
    Text = "Tracer Thickness",
    Tooltip = "Thickness of the tracer line",
    Default = 0.2,
    Min = 0.1,
    Max = 1.5,
    Rounding = 1,
    Callback = function(Value)
        getgenv().SilentAimSettings.TracerThickness = Value
    end,
})

TracerBox:AddCheckbox("TracerTargetOnly", {
    Text = "Target Only",
    Tooltip = "Only shows the tracer on the player who is your current target",
    Default = false,
    Callback = function(v)
        getgenv().SilentAimSettings.TracerTargetOnly = v
    end,
})

TracerBox:AddLabel("Target Tracer Color"):AddColorPicker("TracerColor", {
    Default = Color3.fromRGB(255, 182, 255),
    Title = "Target Tracer Color",
    Text = "Target Tracer Color",
    Tooltip = "Color of the tracer for your current target only (other players use their team color)",
    Callback = function(Value)
        setTracerColorRGB(Value)
    end,
})

-- ============ COLOR PICKER SCREEN CLAMP FIX ============
local function ClampColorPickerToScreen(OptionIdx)
    local CP = Options[OptionIdx]
    if not CP or not CP.ColorMenu then return end

    local ColorMenu = CP.ColorMenu
    local OriginalOpen = ColorMenu.Open

    ColorMenu.Open = function(self, ...)
        OriginalOpen(self, ...)

        task.defer(function()
            local Camera = workspace.CurrentCamera
            if not Camera then return end

            local ViewportSize = Camera.ViewportSize
            local MenuSize = self.Menu.AbsoluteSize
            local Margin = 8

            local CurrentPos = self.Menu.Position
            local X = CurrentPos.X.Offset
            local Y = CurrentPos.Y.Offset

            local MaxX = math.max(Margin, ViewportSize.X - MenuSize.X - Margin)
            local MaxY = math.max(Margin, ViewportSize.Y - MenuSize.Y - Margin)

            X = math.clamp(X, Margin, MaxX)
            Y = math.clamp(Y, Margin, MaxY)

            self.Menu.Position = UDim2.fromOffset(X, Y)
        end)
    end
end

ClampColorPickerToScreen("FOVColor")
ClampColorPickerToScreen("ESPTargetColor")
ClampColorPickerToScreen("FogColor")
ClampColorPickerToScreen("TracerColor")
ClampColorPickerToScreen("BulletColor")
ClampColorPickerToScreen("WeaponColor")
ClampColorPickerToScreen("ColorScreenKillEffectColor")
ClampColorPickerToScreen("ESPTextColor")
ClampColorPickerToScreen("ESPTargetTextColor")

-- ============ TELEPORTS TAB ============
local TeleportsBox = Tabs.Teleports:AddRightGroupbox("Teleports", "map-pin")
local TeleportsTabbox = TeleportsBox:AddTabbox()
local LocationsTab = TeleportsTabbox:AddTab(nil, "map-pin")
local TeleportPlayerTab = TeleportsTabbox:AddTab(nil, "users")

local teleports = {
    {"Cafeteria", Vector3.new(868, 100, 2263)},
    {"Yard", Vector3.new(714, 98, 2519)},
    {"Entrance", Vector3.new(663, 100, 2314)},
    {"Secret Room", Vector3.new(728, 100, 2316)},
    {"Inside the Prison", Vector3.new(864, 100, 2406)},
    {"Guardtower", Vector3.new(840, 122, 2593)},
    {"Guardtower 2", Vector3.new(840, 122, 2067)},
    {"Police Room", Vector3.new(850, 100, 2274)},
    {"Police Room 2", Vector3.new(793, 101, 2246)},
    {"Frontwall", Vector3.new(510, 122, 2328)},
    {"Armory", Vector3.new(804, 108, 2257)},
    {"Containers", Vector3.new(254, 73, 2359)},
    {"Sniper Building", Vector3.new(-354, 114, 1991)},
    {"Criminal Base", Vector3.new(-984, 96, 2079)},
}

for _, tp in ipairs(teleports) do
    LocationsTab:AddButton({
        Text = tp[1],
        Func = function()
            local c = player.Character
            if c and c:FindFirstChild("HumanoidRootPart") then
                c.HumanoidRootPart.CFrame = CFrame.new(tp[2])
            end
        end,
    })
end

TeleportPlayerTab:AddDivider("Teleport to Player")

TeleportPlayerTab:AddDropdown("TeleportPlayer", {
    Values = playerOptions,
    Default = 1,
    Text = "Teleport to Player",
    Tooltip = "Select a player to teleport to them",
    Callback = function(Value)
        if not Value or Value == "Select a player..." then return end
        local target = Players:FindFirstChild(Value)
        if target and target.Character then
            local hrp = target.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local c = player.Character
                if c and c:FindFirstChild("HumanoidRootPart") then
                    c.HumanoidRootPart.CFrame = CFrame.new(hrp.Position + Vector3.new(0, 3, 0))
                end
            end
        end
    end,
})

TeleportPlayerTab:AddButton({
    Text = "Update Players List",
    Func = function()
        local options = {"Select a player..."}
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= player then
                table.insert(options, plr.Name)
            end
        end
        Options.TeleportPlayer:SetValues(options)
    end,
})

TeleportPlayerTab:AddDivider("View Player")

TeleportPlayerTab:AddDropdown("ViewPlayer", {
    Values = viewPlayerOptions,
    Default = 1,
    Text = "View Player",
    Tooltip = "Select a player to spectate",
    Callback = function(Value)
        if not Value or Value == "Select a player..." then
            SPECTATE_PLAYER = nil
            stopSpectate()
            return
        end
        SPECTATE_PLAYER = Value
        startSpectate(Value)  
    end,
})

TeleportPlayerTab:AddButton({
    Text = "Update Players List",
    Func = function()
        local options = {"Select a player..."}
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= player then
                table.insert(options, plr.Name)
            end
        end
        SPECTATE_PLAYER = nil
        stopSpectate()
        Options.ViewPlayer:SetValues(options)
    end,
})

-- ============ VEHICLE MOD ============
local VehicleModBox = Tabs.Teleports:AddRightGroupbox("Vehicle Mod", "car")
VehicleModBox:SetDescription("Vehicle Modifications")
local VehicleModsTabbox = VehicleModBox:AddTabbox()

local VehicleFlyTab = VehicleModsTabbox:AddTab(nil, "wind")
local VehicleSpeedTab = VehicleModsTabbox:AddTab(nil, "zap")
local VehicleCustomTab = VehicleModsTabbox:AddTab(nil, "car")

VehicleFlyTab:AddCheckbox("EnableVehicleFly", {
    Text = "Enable Vehicle Fly",
    Default = false,
    Callback = function(v)
        toggleVehicleFly(v)
    end,
})

VehicleFlyTab:AddCheckbox("ShowVehicleFlyButton", {
    Text = "Show Vehicle Fly Button",
    Default = false,
    Callback = function(v)
        VehicleFlyButton.Visible = v
    end,
})

VehicleFlyTab:AddCheckbox("LockVehicleFlyButton", {
    Text = "Lock Vehicle Fly Button",
    Default = false,
    Callback = function(v)
        setVehicleFlyLocked(v)
    end,
})

VehicleFlyTab:AddLabel("Vehicle Fly Keybind"):AddKeyPicker("VehicleFlyKeybind", {
    Default = "None",
    NoUI = false,
    Text = "Vehicle Fly Keybind",
    Callback = function()
        toggleVehicleFly(not getgenv().SilentAimSettings.VehicleFlyEnabled)
    end,
})

task.spawn(function()
    while true do
        task.wait(0.1)
        local keyValue = Options.VehicleFlyKeybind.Value
        getgenv().SilentAimSettings.VehicleFlyKeyCode = keyValue
    end
end)

VehicleFlyTab:AddDivider()

VehicleFlyTab:AddLabel("Sit in vehicle to Activate", true)

VehicleFlyTab:AddSlider("VehicleFlyHeight", {
    Text = "Height (Y)",
    Default = 0,
    Min = 0,
    Max = 65,
    Rounding = 0,
    Callback = function(Value)
        getgenv().SilentAimSettings.VehicleFlyHeight = Value
    end,
})

VehicleFlyTab:AddButton({
    Text = "Flip Vehicle",
    Func = function()
        if getgenv().FlipVehicle then
            getgenv().FlipVehicle()
        end
    end,
})

VehicleSpeedTab:AddCheckbox("VehicleMaxSpeedChanger", {
    Text = "Vehicle Max speed Changer",
    Default = false,
    Callback = function(v)
        getgenv().SilentAimSettings.VehicleMaxSpeedEnabled = v
    end,
})

VehicleSpeedTab:AddDivider()

VehicleSpeedTab:AddSlider("VehicleMaxSpeed", {
    Text = "Vehicle Max Speed",
    Default = 70,
    Min = 70,
    Max = 300,
    Rounding = 0,
    Callback = function(Value)
        getgenv().SilentAimSettings.VehicleMaxSpeed = Value
    end,
})

local CarListDropdown = VehicleCustomTab:AddDropdown("CarList", {
    Values = {},
    Default = nil,
    AllowNull = true,
    Text = "Car List",
    Tooltip = "Select a car",
    Callback = function(Value)
        getgenv().SilentAimSettings.SelectedCar = Value
    end,
})

VehicleCustomTab:AddButton({
    Text = "Refresh List",
    Func = function()
        if getgenv().RefreshCarList then
            local cars = getgenv().RefreshCarList()
            Options.CarList:SetValues(cars)
        end
    end,
})

VehicleCustomTab:AddButton({
    Text = "Bring Car",
    Func = function()
        if getgenv().BringCar and Options.CarList.Value then
            getgenv().BringCar(Options.CarList.Value)
        end
    end,
})

VehicleCustomTab:AddButton({
    Text = "Teleport to Car",
    Func = function()
        if getgenv().TeleportToCar and Options.CarList.Value then
            getgenv().TeleportToCar(Options.CarList.Value)
        end
    end,
})

local VehicleBannableWarningLabel = VehicleCustomTab:AddLabel("Bannable, use at your own risk", true)

do
    local warningInstance = VehicleBannableWarningLabel.Holder and VehicleBannableWarningLabel.Holder:FindFirstChildOfClass("TextLabel")
    if warningInstance then
        warningInstance.TextColor3 = Color3.fromRGB(235, 70, 70)
    end
end
-- ============ UI SETTINGS ============
local MenuGroup = Tabs["UI Settings"]:AddLeftGroupbox("Menu", "settings")

MenuGroup:AddCheckbox("KeybindMenuOpen", {
    Text = "Open Keybind Menu",
    Default = Library.KeybindFrame.Visible,
    Callback = function(value)
        Library.KeybindFrame.Visible = value
    end,
})

MenuGroup:AddCheckbox("ShowCustomCursor", {
    Text = "Custom Cursor",
    Default = Library.ShowCustomCursor,
    Callback = function(Value)
        Library.ShowCustomCursor = Value
    end,
})

MenuGroup:AddCheckbox("AlwaysOnTop", {
    Text = "Always On Top",
    Default = false,
    Callback = function(Value)
        Window:SetAlwaysOnTop(Value)
    end,
})

MenuGroup:AddDropdown("NotificationSide", {
    Values = {"Left", "Right"},
    Default = "Right",
    Text = "Notification Side",
    Callback = function(Value)
        Library:SetNotifySide(Value)
    end,
})

MenuGroup:AddDivider()

MenuGroup:AddLabel("Menu Bind"):AddKeyPicker("MenuKeybind", {
    Default = "RightShift",
    NoUI = true,
    Text = "Menu keybind",
})

MenuGroup:AddButton("Unload", function()
    Library:Unload()
end)

Library.ToggleKeybind = Options.MenuKeybind

-- ============ ADDON SETUP ============
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ "MenuKeybind" })

ThemeManager:SetFolder("PrecisionHub")
SaveManager:SetFolder("PrecisionHub/PrisonLife")

SaveManager:BuildConfigSection(Tabs["UI Settings"])
ThemeManager:ApplyToTab(Tabs["UI Settings"])

SaveManager:LoadAutoloadConfig()
