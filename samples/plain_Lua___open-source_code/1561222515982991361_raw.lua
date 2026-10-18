-- ReefHub Key System
-- Main script is compiled/executed only after a valid key is entered.

local MAIN_SCRIPT = [=[if not game:IsLoaded() then game.Loaded:Wait() end

if getgenv and getgenv().ReefHubUnload then
    pcall(getgenv().ReefHubUnload)
end

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Lighting = game:GetService("Lighting")
local SoundService = game:GetService("SoundService")
local CoreGui = game:GetService("CoreGui")
local PathfindingService = game:GetService("PathfindingService")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local isRunning = true
local activeConnections = {}
local cleanUpInstances = {}
local originalNamecall = nil
local originalUtilityRaycast = nil

local function hideFromStack(fn)
    if typeof(fn) == "function" and setstackhidden then
        pcall(setstackhidden, fn, true)
    end
end

local autoReinjectScript = [[
    task.spawn(function()
        repeat task.wait(0.5) until game:IsLoaded()
        local Players = game:GetService("Players")
        local lp = Players.LocalPlayer or Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
        repeat task.wait(0.5) until lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
        task.wait(1.5)
        local success, err = pcall(function()
            if loadfile then
                local f = loadfile("rivals.luau") or loadfile("Rivals.luau")
                if f then f() end
            end
        end)
    end)
]]

if queue_on_teleport then
    pcall(function() queue_on_teleport(autoReinjectScript) end)
elseif syn and syn.queue_on_teleport then
    pcall(function() syn.queue_on_teleport(autoReinjectScript) end)
end

LocalPlayer.OnTeleport:Connect(function(state)
    if state == Enum.TeleportState.Started or state == Enum.TeleportState.InProgress then
        if queue_on_teleport then
            pcall(function() queue_on_teleport(autoReinjectScript) end)
        elseif syn and syn.queue_on_teleport then
            pcall(function() syn.queue_on_teleport(autoReinjectScript) end)
        end
    end
end)

local Config = {

    Aimbot = false,
    TeamCheck = true,
    AimbotKey = Enum.UserInputType.MouseButton2,
    AimbotKeyMode = "Hold",
    AimbotPart = "Closest",
    AimbotSmoothing = 0.28,
    AimbotFOV = 120,
    AimbotVisibleOnly = true,
    AimbotScopeOnly = false,
    AimbotDisableReloading = true,
    ContinuousTargeting = true,
    InstantCameraLock = false,
    TrackThroughWalls = true,
    CorrectLockedShots = true,

    SilentAim = true,
    SilentKey = Enum.KeyCode.C,
    SilentKeyMode = "Always",
    SilentTargetPart = "Head",
    SilentFOV = 242,
    SilentHitChance = 78,
    SilentHeadChance = 59,
    SilentVisibleOnly = true,
    SilentVulnerableOnly = true,
    SilentIgnoreDeflecting = true,
    SilentIgnoreShielded = true,

    Ragebot = false,
    RagebotAutoShoot = false,
    RagebotTargetStrafe = false,
    TargetStrafeRadius = 14,
    TargetStrafeSpeed = 6,
    Autoplay = false,
    AutoplayDistance = 18,
    RagebotTargetPriority = "Distance",
    RagebotWallbang = true,
    AutoRespawn = false,
    AutoQueue = false,
    QueueMode = "1v1",
    AutoVoteMaps = false,
    MapPriority = "Arena, Onyx, Crossroads",
    AutoBanWeapons = false,
    WeaponBanPriority = "Grenade Launcher, Minigun, RPG",
    SecondBanPriority = "Grenade Launcher, Minigun, RPG",
    AutoLoadout = true,
    LoadoutOnlySelected = false,
    EnabledMaps = "Arena, Crossroads",
    AntiAim = false,
    AntiAimMode = "Jitter",
    AntiAimSpeed = 10,
    HackerDetector = true,
    NotifyHackers = true,
    HackerAutoLoad = true,
    HackerProfile = "rage",
    SpeedThreshold = 180,
    SpeedDuration = 0.75,
    ModDetector = true,
    NotifyMods = true,
    MinGroupRank = 200,
    ModUsernames = "name1, name2",
    ModFriendList = "name1, name2",
    AutoPickup = false,
    PickupRadius = 25,

    ESP_Master = true,
    ESP_EnemyOnly = true,
    ESP_Lobby = true,
    ESP_MaxDistance = 500,
    ESP_Boxes = true,
    ESP_Names = true,
    ESP_Distance = true,
    ESP_HealthBar = true,
    ESP_Weapon = true,
    ESP_Tracers = false,
    ESP_Chams = false,
    ESP_Skeleton = true,
    ESP_HeadDot = true,
    ESP_Tripmines = true,
    ESP_FOV = true,
    TargetVisualizer = true,
    TargetVisualizerHUD = true,
    TargetVisualizerPath = true,
    VisualizerArrowSpacing = 10,
    VisualizerArrowSpeed = 14,

    SpeedHack = false,
    SpeedValue = 49,
    FlyHack = false,
    FlySpeed = 50,
    InfiniteJump = false,
    BunnyHop = false,
    Noclip = false,

    NoRecoil = true,
    NoSpread = true,
    FastReload = false,
    RapidFire = false,
    InstantEquip = false,
    AutomaticGuns = false,
    InfiniteAmmo = false,

    UnlockAllSkins = false,
    SelectedCategory = "Primary",
    SelectedWeapon = "Assault Rifle",
    SelectedWrap = "Liquid Gold",
    SelectedCharm = "Dice",
    SelectedFinisher = "Gingerbreadify",
    RainbowGunSkin = false,
    WeaponChams = false,
    CustomViewModelFOV = false,
    ViewModelFOVValue = 70,
    ViewModelXOffset = 0,
    ViewModelYOffset = 0,
    ViewModelZOffset = 0,
    HideViewModel = false,

    Fullbright = false,
    NoFog = true,
    CustomFOV = false,
    FOVValue = 90,
    BulletTracers = false,
    HitSound = "Skeet",

    ThirdPerson = false,
    ThirdPersonDist = 12,
    Freecam = false,
    FreecamSpeed = 40,

    MenuKey = Enum.KeyCode.RightControl,
    MobileToggle = false
}

local Theme = {
    OuterBorder     = Color3.fromRGB(215, 106, 141),
    BorderPink      = Color3.fromRGB(215, 106, 141),
    BorderPinkDark  = Color3.fromRGB(150, 60, 92),

    WindowBg        = Color3.fromRGB(22, 17, 21),
    WindowBgTop     = Color3.fromRGB(28, 20, 26),
    WindowBgBottom  = Color3.fromRGB(16, 12, 15),
    InnerCanvasBg   = Color3.fromRGB(20, 15, 19),
    HeaderBg        = Color3.fromRGB(24, 18, 23),

    CardBg          = Color3.fromRGB(33, 24, 30),
    CardBgTop       = Color3.fromRGB(44, 32, 41),
    CardBgBottom    = Color3.fromRGB(22, 16, 20),
    BorderDark      = Color3.fromRGB(56, 40, 52),
    BorderCard      = Color3.fromRGB(64, 46, 59),

    AccentPink      = Color3.fromRGB(226, 120, 152),
    AccentPinkLight = Color3.fromRGB(245, 152, 182),
    AccentPinkDark  = Color3.fromRGB(180, 72, 108),
    AccentPinkDim   = Color3.fromRGB(120, 42, 70),

    TextWhite       = Color3.fromRGB(242, 240, 243),
    TextMuted       = Color3.fromRGB(152, 132, 144),
    TextDark        = Color3.fromRGB(105, 88, 100),
    ControlBg       = Color3.fromRGB(15, 11, 14),
    ButtonBg        = Color3.fromRGB(32, 23, 29),
    ButtonHoverBg   = Color3.fromRGB(48, 34, 44),
    ButtonBorder    = Color3.fromRGB(68, 48, 62),
    Red             = Color3.fromRGB(235, 75, 75),
    Yellow          = Color3.fromRGB(245, 195, 65),

    AccentGreen     = Color3.fromRGB(226, 120, 152),
    AccentGreenLight= Color3.fromRGB(245, 152, 182),
    AccentGreenDark = Color3.fromRGB(180, 72, 108),
    AccentGreenDim  = Color3.fromRGB(120, 42, 70)
}

local MainFont = Enum.Font.RobotoMono

local LOBBY_CENTER = Vector3.new(109, -680, 1184)
local function isInLobby()
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return false end
    return (root.Position - LOBBY_CENTER).Magnitude < 450
end

local function isTeammate(p)
    if not p then return false end
    if p == LocalPlayer then return true end
    if Config.TeamCheck == false then return false end

    local pl = nil
    if typeof(p) == "Instance" then
        if p:IsA("Player") then
            pl = p
        elseif LocalPlayer.Character and (p == LocalPlayer.Character or p:IsDescendantOf(LocalPlayer.Character)) then
            return true
        else
            pl = Players:GetPlayerFromCharacter(p:IsA("Model") and p or p:FindFirstAncestorOfClass("Model"))
        end
    end

    if pl and LocalPlayer.Team and pl.Team and LocalPlayer.Team == pl.Team then
        return true
    end

    if pl then
        local myT = LocalPlayer:GetAttribute("TeamID") or LocalPlayer:GetAttribute("Team")
        local theirT = pl:GetAttribute("TeamID") or pl:GetAttribute("Team")
        if myT ~= nil and theirT ~= nil and myT == theirT then
            return true
        end
    end

    local pChar = pl and pl.Character or (typeof(p) == "Instance" and (p:IsA("Model") and p or p:FindFirstAncestorOfClass("Model")))
    local myChar = LocalPlayer.Character
    if pChar and myChar then
        local myCT = myChar:GetAttribute("TeamID") or myChar:GetAttribute("Team")
        local theirCT = pChar:GetAttribute("TeamID") or pChar:GetAttribute("Team")
        if myCT ~= nil and theirCT ~= nil and myCT == theirCT then
            return true
        end
        if pChar:FindFirstChild("TeammateLabel", true) or pChar:FindFirstChild("AllyLabel", true) then
            return true
        end
    end

    return false
end
hideFromStack(isTeammate)

local function isEnemyPlayer(p)
    if not p or p == LocalPlayer then return false end

    if isInLobby() then
        return Config.ESP_Lobby == true
    end

    if isTeammate(p) then
        return false
    end

    if Config.ESP_EnemyOnly and LocalPlayer.Team and p.Team and LocalPlayer.Team == p.Team then
        return false
    end

    return true
end
hideFromStack(isEnemyPlayer)

local function getGuiParent()
    if gethui then
        local ok, h = pcall(gethui)
        if ok and h then return h end
    end
    local ok, gui = pcall(function() return CoreGui end)
    if ok and gui then return gui end
    return LocalPlayer:WaitForChild("PlayerGui", 5) or LocalPlayer:FindFirstChild("PlayerGui")
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ReefHubUI"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.DisplayOrder = 999
screenGui.Parent = getGuiParent()
table.insert(cleanUpInstances, screenGui)

local function UnloadScript()
    isRunning = false
    for _, conn in ipairs(activeConnections) do pcall(function() conn:Disconnect() end) end
    table.clear(activeConnections)
    for _, inst in ipairs(cleanUpInstances) do pcall(function() inst:Destroy() end) end
    table.clear(cleanUpInstances)
    if originalUtilityRaycast then
        pcall(function()
            local util = require(ReplicatedStorage.Modules.Utility)
            util.Raycast = originalUtilityRaycast
        end)
    end
    pcall(function() ContextActionService:UnbindAction("ParagonMenuFreeze") end)
    pcall(function()
        local ps = LocalPlayer:FindFirstChild("PlayerScripts")
        local pm = ps and ps:FindFirstChild("PlayerModule")
        if pm then
            local controls = require(pm):GetControls()
            if controls then controls:Enable() end
        end
    end)
    pcall(function()
        UserInputService.MouseBehavior = Enum.MouseBehavior.Default
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.Anchored = false
        end
    end)
    if getgenv then getgenv().ReefHubUnload = nil end
end

if getgenv then getgenv().ReefHubUnload = UnloadScript end

local originalWeaponStats = {}
local function ApplyWeaponModifications()
    if not isRunning then return end
    pcall(function()
        local rep = game:GetService("ReplicatedStorage")
        local itemModule = rep:FindFirstChild("Modules") and rep.Modules:FindFirstChild("ItemLibrary")
        if not itemModule then return end
        local itemLib = require(itemModule)
        if itemLib and itemLib.Items then
            for name, item in pairs(itemLib.Items) do
                if type(item) == "table" and item.ShootRecoil ~= nil then
                    if not originalWeaponStats[name] then
                        originalWeaponStats[name] = {
                            ShootRecoil = item.ShootRecoil,
                            ShootSpread = item.ShootSpread,
                            AimSpreadMultiplier = item.AimSpreadMultiplier,
                            ShootSpreadPerVelocityUnit = item.ShootSpreadPerVelocityUnit,
                            ShootSpreadPerVelocityLimit = item.ShootSpreadPerVelocityLimit,
                            EquipCooldown = item.EquipCooldown,
                            ReloadLength = item.ReloadLength,
                            EmptyReloadLength = item.EmptyReloadLength,
                            ReloadActionTimestamp = item.ReloadActionTimestamp,
                            EmptyReloadActionTimestamp = item.EmptyReloadActionTimestamp,
                            ShootCooldown = item.ShootCooldown,
                            MaxAmmo = item.MaxAmmo,
                            MaxAmmoReserve = item.MaxAmmoReserve
                        }
                    end

                    local orig = originalWeaponStats[name]
                    item.ShootRecoil = Config.NoRecoil and 0 or orig.ShootRecoil
                    item.ShootSpread = Config.NoSpread and 0 or orig.ShootSpread
                    item.AimSpreadMultiplier = Config.NoSpread and 0 or orig.AimSpreadMultiplier
                    item.ShootSpreadPerVelocityUnit = Config.NoSpread and 0 or orig.ShootSpreadPerVelocityUnit
                    item.ShootSpreadPerVelocityLimit = Config.NoSpread and 0 or orig.ShootSpreadPerVelocityLimit
                    item.EquipCooldown = Config.InstantEquip and 0.01 or orig.EquipCooldown
                    item.ReloadLength = Config.FastReload and 0.05 or orig.ReloadLength
                    item.EmptyReloadLength = Config.FastReload and 0.05 or orig.EmptyReloadLength
                    item.ReloadActionTimestamp = Config.FastReload and 0.01 or orig.ReloadActionTimestamp
                    item.EmptyReloadActionTimestamp = Config.FastReload and 0.01 or orig.EmptyReloadActionTimestamp
                    item.ShootCooldown = Config.RapidFire and (orig.ShootCooldown * 0.4) or orig.ShootCooldown
                    if orig.MaxAmmo then
                        item.MaxAmmo = Config.InfiniteAmmo and 9999 or orig.MaxAmmo
                    end
                    if orig.MaxAmmoReserve then
                        item.MaxAmmoReserve = Config.InfiniteAmmo and 9999 or orig.MaxAmmoReserve
                    end
                end
            end
        end
    end)
end

local function UnlockAllCosmeticsClientSide()
    pcall(function()
        local rep = game:GetService("ReplicatedStorage")
        local pdCtrl = require(LocalPlayer.PlayerScripts.Controllers.PlayerDataController)
        local cosmeticLib = require(rep.Modules.CosmeticLibrary)
        local itemLib = require(rep.Modules.ItemLibrary)

        if pdCtrl and pdCtrl.CurrentData and pdCtrl.CurrentData.Data then
            local cosmInv = pdCtrl.CurrentData.Data.CosmeticInventory or {}
            local rawWeapInv = pdCtrl.CurrentData.Data.WeaponInventory or {}

            if cosmeticLib and cosmeticLib.Cosmetics then
                for name, _ in pairs(cosmeticLib.Cosmetics) do
                    cosmInv[name] = true
                end
            end

            local weapInv = {}
            local existing = {}
            if typeof(rawWeapInv) == "table" then
                for _, item in pairs(rawWeapInv) do
                    if typeof(item) == "table" and item.Name then
                        table.insert(weapInv, item)
                        existing[item.Name] = true
                    end
                end
            end

            if itemLib and itemLib.Items then
                for name, _ in pairs(itemLib.Items) do
                    if not existing[name] then
                        table.insert(weapInv, {
                            Name = name,
                            Level = 100,
                            Prestige = 5,
                            XP = 99999,
                            IsFavorited = false
                        })
                        existing[name] = true
                    end
                end
            end

            pdCtrl.CurrentData.Data.CosmeticInventory = cosmInv
            pdCtrl.CurrentData.Data.WeaponInventory = weapInv
        end
    end)
end

local function ApplySelectedCosmeticsClientSide(weaponName, wrapName, charmName, finisherName)
    pcall(function()
        local rep = game:GetService("ReplicatedStorage")
        local pdCtrl = require(LocalPlayer.PlayerScripts.Controllers.PlayerDataController)
        if pdCtrl and pdCtrl.CurrentData and pdCtrl.CurrentData.Data then
            local weapInv = pdCtrl.CurrentData.Data.WeaponInventory
            if typeof(weapInv) == "table" then
                for _, weapon in ipairs(weapInv) do
                    if typeof(weapon) == "table" and (weapon.Name == weaponName or weaponName == "All") then
                        if wrapName and wrapName ~= "Default" and wrapName ~= "None" then
                            weapon.Wrap = { Name = wrapName, Inverted = false }
                        elseif wrapName == "Default" or wrapName == "None" then
                            weapon.Wrap = nil
                        end

                        if charmName and charmName ~= "None" then
                            weapon.Charm = { Name = charmName }
                        elseif charmName == "None" then
                            weapon.Charm = nil
                        end

                        if finisherName and finisherName ~= "None" then
                            weapon.Finisher = { Name = finisherName }
                        elseif finisherName == "None" then
                            weapon.Finisher = nil
                        end
                    end
                end
            end
        end

        local rem = rep:FindFirstChild("Remotes")
        local dataRem = rem and rem:FindFirstChild("Data")
        local equipCosm = dataRem and dataRem:FindFirstChild("EquipCosmetic")
        if equipCosm and weaponName ~= "All" then
            if wrapName and wrapName ~= "Default" and wrapName ~= "None" then
                equipCosm:FireServer(weaponName, "Wrap", wrapName)
            end
            if charmName and charmName ~= "None" then
                equipCosm:FireServer(weaponName, "Charm", charmName)
            end
            if finisherName and finisherName ~= "None" then
                equipCosm:FireServer(weaponName, "Finisher", finisherName)
            end
        end
    end)
end

local dropdownOverlay = Instance.new("Frame")
dropdownOverlay.Name = "DropdownOverlay"
dropdownOverlay.Size = UDim2.new(1, 0, 1, 0)
dropdownOverlay.BackgroundTransparency = 1
dropdownOverlay.ZIndex = 1000
dropdownOverlay.Parent = screenGui
table.insert(cleanUpInstances, dropdownOverlay)

local activeDropdownClose = nil

UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        if activeDropdownClose then
            activeDropdownClose(input.Position)
        end
    end
end)

local watermarkFrame = Instance.new("Frame")
watermarkFrame.Name = "ParagonWatermark"
watermarkFrame.Size = UDim2.new(0, 275, 0, 22)
watermarkFrame.Position = UDim2.new(1, -285, 0, 8)
watermarkFrame.BackgroundColor3 = Theme.CardBg
watermarkFrame.BorderSizePixel = 0
watermarkFrame.ZIndex = 90
watermarkFrame.Parent = screenGui
table.insert(cleanUpInstances, watermarkFrame)

local wmGrad = Instance.new("UIGradient")
wmGrad.Rotation = 90
wmGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Theme.CardBgTop),
    ColorSequenceKeypoint.new(1, Theme.CardBgBottom)
})
wmGrad.Parent = watermarkFrame

local wmStroke = Instance.new("UIStroke")
wmStroke.Color = Theme.BorderCard
wmStroke.Thickness = 1
wmStroke.Parent = watermarkFrame

local wmTopLine = Instance.new("Frame")
wmTopLine.Size = UDim2.new(1, 0, 0, 1.5)
wmTopLine.BackgroundColor3 = Theme.AccentPink
wmTopLine.BorderSizePixel = 0
wmTopLine.ZIndex = 91
wmTopLine.Parent = watermarkFrame

local wmLineGrad = Instance.new("UIGradient")
wmLineGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Theme.AccentPinkLight),
    ColorSequenceKeypoint.new(1, Theme.AccentPinkDark)
})
wmLineGrad.Parent = wmTopLine

local wmLbl = Instance.new("TextLabel")
wmLbl.Size = UDim2.new(1, -12, 1, -2)
wmLbl.Position = UDim2.new(0, 8, 0, 2)
wmLbl.BackgroundTransparency = 1
wmLbl.Font = MainFont
wmLbl.RichText = true
wmLbl.Text = '<b>P</b>  |  <font color="#e27898">reefhub</font>  |  60 fps  |  0 ms'
wmLbl.TextColor3 = Theme.TextWhite
wmLbl.TextSize = 10.5
wmLbl.TextXAlignment = Enum.TextXAlignment.Left
wmLbl.ZIndex = 92
wmLbl.Parent = watermarkFrame

local notifContainer = Instance.new("Frame")
notifContainer.Name = "NotifContainer"
notifContainer.Size = UDim2.new(0, 260, 1, -40)
notifContainer.Position = UDim2.new(1, -275, 0, 36)
notifContainer.BackgroundTransparency = 1
notifContainer.ZIndex = 100
notifContainer.Parent = screenGui
table.insert(cleanUpInstances, notifContainer)

local notifLayout = Instance.new("UIListLayout")
notifLayout.SortOrder = Enum.SortOrder.LayoutOrder
notifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
notifLayout.Padding = UDim.new(0, 5)
notifLayout.Parent = notifContainer

local function ShowNotification(title, message, notifType, duration)
    if not isRunning then return end
    pcall(function()
        if not notifContainer or not notifContainer.Parent then return end
        duration = duration or 3.5
        notifType = notifType or "INFO"
        local barColor = Theme.AccentGreen
        if notifType == "SUCCESS" then barColor = Theme.AccentGreenLight
        elseif notifType == "WARN" then barColor = Theme.Yellow
        elseif notifType == "ERROR" then barColor = Theme.Red end

        local card = Instance.new("Frame")
        card.Size = UDim2.new(1, 0, 0, 0)
        card.BackgroundColor3 = Theme.CardBg
        card.BorderSizePixel = 0
        card.ClipsDescendants = true
        card.ZIndex = 101
        card.Parent = notifContainer

        local stroke = Instance.new("UIStroke")
        stroke.Color = Theme.BorderDark
        stroke.Thickness = 1
        stroke.Parent = card

        local topAcc = Instance.new("Frame")
        topAcc.Size = UDim2.new(1, 0, 0, 1.5)
        topAcc.BackgroundColor3 = barColor
        topAcc.BorderSizePixel = 0
        topAcc.ZIndex = 102
        topAcc.Parent = card

        local tLbl = Instance.new("TextLabel")
        tLbl.Size = UDim2.new(1, -14, 0, 15)
        tLbl.Position = UDim2.new(0, 8, 0, 3)
        tLbl.BackgroundTransparency = 1
        tLbl.Font = MainFont
        tLbl.Text = title
        tLbl.TextColor3 = Theme.AccentGreen
        tLbl.TextSize = 11.5
        tLbl.TextXAlignment = Enum.TextXAlignment.Left
        tLbl.ZIndex = 102
        tLbl.Parent = card

        local mLbl = Instance.new("TextLabel")
        mLbl.Size = UDim2.new(1, -14, 0, 22)
        mLbl.Position = UDim2.new(0, 8, 0, 18)
        mLbl.BackgroundTransparency = 1
        mLbl.Font = MainFont
        mLbl.Text = message
        mLbl.TextColor3 = Theme.TextWhite
        mLbl.TextSize = 10
        mLbl.TextWrapped = true
        mLbl.TextXAlignment = Enum.TextXAlignment.Left
        mLbl.ZIndex = 102
        mLbl.Parent = card

        TweenService:Create(card, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, 46)}):Play()

        task.delay(duration, function()
            if card and card.Parent then
                local tw = TweenService:Create(card, TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Size = UDim2.new(1, 0, 0, 0)})
                tw:Play()
                tw.Completed:Connect(function() card:Destroy() end)
            end
        end)
    end)
end

local TargetVis = {
    hudFrame = nil,
    hudTitle = nil,
    hudAvatar = nil,
    hudName = nil,
    hudHpFill = nil,
    visualizerFolder = nil,
    poolLines = {},
    poolChevrons = {},
    cachedWaypoints = {},
    autoplayWpIndex = 1,
    lastAutoplayStuckTime = 0,
    lastAutoplayPos = nil,
    lastTargetUserId = nil,
    activeRoot = nil,
    activeChar = nil,
    activeHum = nil,
    activePlayer = nil,
    cachedEnemies = {},
    lastEnemyUpdateTime = 0,
    targetCache = {},
    staticRayParams = nil,
    lastFullbrightCheck = 0,
    lastNoFogCheck = 0,
    lastPathMyPos = nil,
    lastPathActPos = nil,
}

local function initTargetVisualizer()
    local hud = Instance.new("Frame")
    hud.Name = "TargetHUD"
    hud.Size = UDim2.new(0, 310, 0, 72)
    hud.Position = UDim2.new(0.5, -155, 1, -125)
    hud.BackgroundColor3 = Color3.fromRGB(15, 18, 15)
    hud.BorderSizePixel = 0
    hud.Visible = false
    hud.ZIndex = 80
    hud.Parent = screenGui
    table.insert(cleanUpInstances, hud)
    TargetVis.hudFrame = hud

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(45, 55, 45)
    stroke.Thickness = 1.2
    stroke.Parent = hud

    local topLine = Instance.new("Frame")
    topLine.Size = UDim2.new(1, 0, 0, 2.5)
    topLine.BackgroundColor3 = Color3.fromRGB(195, 255, 30)
    topLine.BorderSizePixel = 0
    topLine.ZIndex = 81
    topLine.Parent = hud

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -20, 0, 18)
    title.Position = UDim2.new(0, 10, 0, 4)
    title.BackgroundTransparency = 1
    title.Font = MainFont
    title.Text = "Target  -  150/150"
    title.TextColor3 = Theme.TextWhite
    title.TextSize = 14
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 82
    title.Parent = hud
    TargetVis.hudTitle = title

    local avatar = Instance.new("ImageLabel")
    avatar.Size = UDim2.new(0, 42, 0, 42)
    avatar.Position = UDim2.new(0, 10, 0, 24)
    avatar.BackgroundColor3 = Color3.fromRGB(20, 24, 20)
    avatar.BorderSizePixel = 0
    avatar.ZIndex = 82
    avatar.Parent = hud
    TargetVis.hudAvatar = avatar

    local avStroke = Instance.new("UIStroke")
    avStroke.Color = Color3.fromRGB(195, 255, 30)
    avStroke.Thickness = 1.2
    avStroke.Parent = avatar

    local nameLbl = Instance.new("TextLabel")
    nameLbl.Size = UDim2.new(1, -68, 0, 18)
    nameLbl.Position = UDim2.new(0, 60, 0, 24)
    nameLbl.BackgroundTransparency = 1
    nameLbl.Font = MainFont
    nameLbl.Text = "Player (@username)"
    nameLbl.TextColor3 = Theme.TextWhite
    nameLbl.TextSize = 13
    nameLbl.TextXAlignment = Enum.TextXAlignment.Left
    nameLbl.TextTruncate = Enum.TextTruncate.AtEnd
    nameLbl.ZIndex = 82
    nameLbl.Parent = hud
    TargetVis.hudName = nameLbl

    local hpBg = Instance.new("Frame")
    hpBg.Size = UDim2.new(1, -68, 0, 8)
    hpBg.Position = UDim2.new(0, 60, 0, 48)
    hpBg.BackgroundColor3 = Color3.fromRGB(28, 34, 28)
    hpBg.BorderSizePixel = 0
    hpBg.ZIndex = 82
    hpBg.Parent = hud

    local hpCorner = Instance.new("UICorner")
    hpCorner.CornerRadius = UDim.new(0, 2)
    hpCorner.Parent = hpBg

    local hpFill = Instance.new("Frame")
    hpFill.Size = UDim2.new(1, 0, 1, 0)
    hpFill.BackgroundColor3 = Color3.fromRGB(195, 255, 30)
    hpFill.BorderSizePixel = 0
    hpFill.ZIndex = 83
    hpFill.Parent = hpBg
    TargetVis.hudHpFill = hpFill

    local hpFillCorner = Instance.new("UICorner")
    hpFillCorner.CornerRadius = UDim.new(0, 2)
    hpFillCorner.Parent = hpFill

    local vFolder = Instance.new("Folder")
    vFolder.Name = "ParagonTargetVisualizer"
    vFolder.Parent = Workspace
    table.insert(cleanUpInstances, vFolder)
    TargetVis.visualizerFolder = vFolder

    for i = 1, 40 do
        local p = Instance.new("Part")
        p.Name = "VisLine_" .. i
        p.Anchored = true
        p.CanCollide = false
        p.CanTouch = false
        p.CanQuery = false
        p.CastShadow = false
        p.Material = Enum.Material.Neon
        p.Color = Color3.fromRGB(195, 255, 30)
        p.Transparency = 1
        p.Size = Vector3.new(0.18, 0.06, 1)
        p.Parent = vFolder
        table.insert(TargetVis.poolLines, p)
    end

    for i = 1, 30 do
        local wingL = Instance.new("Part")
        wingL.Name = "ChevL_" .. i
        wingL.Anchored = true
        wingL.CanCollide = false
        wingL.CanTouch = false
        wingL.CanQuery = false
        wingL.CastShadow = false
        wingL.Material = Enum.Material.Neon
        wingL.Color = Color3.fromRGB(195, 255, 30)
        wingL.Transparency = 1
        wingL.Size = Vector3.new(0.22, 0.08, 1.2)
        wingL.Parent = vFolder

        local wingR = Instance.new("Part")
        wingR.Name = "ChevR_" .. i
        wingR.Anchored = true
        wingR.CanCollide = false
        wingR.CanTouch = false
        wingR.CanQuery = false
        wingR.CastShadow = false
        wingR.Material = Enum.Material.Neon
        wingR.Color = Color3.fromRGB(195, 255, 30)
        wingR.Transparency = 1
        wingR.Size = Vector3.new(0.22, 0.08, 1.2)
        wingR.Parent = vFolder

        table.insert(TargetVis.poolChevrons, { Left = wingL, Right = wingR })
    end
end
initTargetVisualizer()

local mainWindow = Instance.new("Frame")
mainWindow.Name = "MainWindow"
mainWindow.Size = UDim2.new(0, 480, 0, 500)
mainWindow.Position = UDim2.new(0.5, -240, 0.5, -250)
mainWindow.BackgroundColor3 = Theme.WindowBg
mainWindow.BorderSizePixel = 0
mainWindow.ClipsDescendants = false
mainWindow.Active = true
mainWindow.ZIndex = 10
mainWindow.Parent = screenGui
table.insert(cleanUpInstances, mainWindow)

local frozenCameraCFrame = nil
local frozenCameraFOV = nil
local FreecamState = { enabled = false, rotX = 0, rotY = 0, pos = Vector3.zero }
local sPing = nil
local lastBhopJumpTime = 0
local lastRageAutoShootTime = 0
local lastAutoShootTime = 0
local isTargetStrafing = false

local function hasWeaponEquipped()
    local char = LocalPlayer.Character
    if not char then return false end
    for _, c in ipairs(char:GetChildren()) do
        if c:IsA("Tool") then return true end
    end
    local vm = Workspace:FindFirstChild("ViewModels")
    local fp = vm and vm:FindFirstChild("FirstPerson")
    if fp and #fp:GetChildren() > 0 then
        for _, c in ipairs(fp:GetChildren()) do
            if c:IsA("Model") or c:IsA("BasePart") then
                return true
            end
        end
    end
    return false
end

local function setPlayerControlsEnabled(enabled)
    pcall(function()
        local ps = LocalPlayer:FindFirstChild("PlayerScripts")
        local pm = ps and ps:FindFirstChild("PlayerModule")
        if pm then
            local controls = require(pm):GetControls()
            if controls then
                if enabled then
                    controls:Enable()
                else
                    controls:Disable()
                end
            end
        end
    end)
end

local function setMenuVisible(visible)
    mainWindow.Visible = visible
    if visible then
        frozenCameraCFrame = Camera.CFrame
        frozenCameraFOV = Camera.FieldOfView
        UserInputService.MouseBehavior = Enum.MouseBehavior.Default
        UserInputService.MouseIconEnabled = true

        setPlayerControlsEnabled(false)

        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if root then
            root.AssemblyLinearVelocity = Vector3.new(0, math.min(root.AssemblyLinearVelocity.Y, 0), 0)
        end

        pcall(function()
            ContextActionService:BindActionAtPriority(
                "ParagonMenuFreeze",
                function() return Enum.ContextActionResult.Sink end,
                false,
                Enum.ContextActionPriority.High.Value + 5000,
                Enum.UserInputType.MouseMovement,
                Enum.UserInputType.Touch,
                Enum.KeyCode.W,
                Enum.KeyCode.A,
                Enum.KeyCode.S,
                Enum.KeyCode.D,
                Enum.KeyCode.Space,
                Enum.KeyCode.LeftShift,
                Enum.KeyCode.LeftControl,
                Enum.KeyCode.Up,
                Enum.KeyCode.Down,
                Enum.KeyCode.Left,
                Enum.KeyCode.Right
            )
        end)
    else
        frozenCameraCFrame = nil
        frozenCameraFOV = nil

        setPlayerControlsEnabled(true)

        pcall(function()
            ContextActionService:UnbindAction("ParagonMenuFreeze")
        end)
    end
end

local windowStroke = Instance.new("UIStroke")
windowStroke.Color = Theme.OuterBorder
windowStroke.Thickness = 1
windowStroke.Parent = mainWindow

local windowGrad = Instance.new("UIGradient")
windowGrad.Rotation = 90
windowGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Theme.WindowBgTop),
    ColorSequenceKeypoint.new(1, Theme.WindowBgBottom)
})
windowGrad.Parent = mainWindow

local topBar = Instance.new("Frame")
topBar.Name = "TopBar"
topBar.Size = UDim2.new(1, 0, 0, 32)
topBar.BackgroundColor3 = Theme.HeaderBg
topBar.BorderSizePixel = 0
topBar.ZIndex = 11
topBar.Parent = mainWindow

local isDragging = false
local dragStart, startPos
topBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDragging = true
        dragStart = input.Position
        startPos = mainWindow.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then isDragging = false end
        end)
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        mainWindow.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

local logoFrame = Instance.new("Frame")
logoFrame.Name = "ParagonLogo"
logoFrame.Size = UDim2.new(0, 16, 0, 18)
logoFrame.Position = UDim2.new(0, 10, 0.5, -9)
logoFrame.BackgroundTransparency = 1
logoFrame.ZIndex = 12
logoFrame.Parent = topBar

local pStem = Instance.new("Frame")
pStem.Size = UDim2.new(0, 5, 0, 17)
pStem.Position = UDim2.new(0, 0, 0, 0.5)
pStem.BackgroundColor3 = Theme.AccentPinkDark
pStem.BorderSizePixel = 0
pStem.ZIndex = 13
pStem.Parent = logoFrame

local pTop = Instance.new("Frame")
pTop.Size = UDim2.new(0, 11, 0, 5)
pTop.Position = UDim2.new(0, 5, 0, 0.5)
pTop.BackgroundColor3 = Theme.AccentPinkLight
pTop.BorderSizePixel = 0
pTop.ZIndex = 14
pTop.Parent = logoFrame

local pRight = Instance.new("Frame")
pRight.Size = UDim2.new(0, 5, 0, 6)
pRight.Position = UDim2.new(0, 11, 0, 4.5)
pRight.BackgroundColor3 = Theme.AccentPink
pRight.BorderSizePixel = 0
pRight.ZIndex = 14
pRight.Parent = logoFrame

local pMid = Instance.new("Frame")
pMid.Size = UDim2.new(0, 7, 0, 4)
pMid.Position = UDim2.new(0, 5, 0, 9.5)
pMid.BackgroundColor3 = Theme.AccentPink
pMid.BorderSizePixel = 0
pMid.ZIndex = 14
pMid.Parent = logoFrame

local titleLbl = Instance.new("TextLabel")
titleLbl.Size = UDim2.new(0, 220, 1, 0)
titleLbl.Position = UDim2.new(0, 34, 0, 0)
titleLbl.BackgroundTransparency = 1
titleLbl.Font = MainFont
titleLbl.RichText = true
titleLbl.Text = '<font color="#ffffff">ReefHub</font><font color="#e27898">.ripped</font>'
titleLbl.TextSize = 14
titleLbl.TextXAlignment = Enum.TextXAlignment.Left
titleLbl.ZIndex = 13
titleLbl.Parent = topBar

local searchBox = Instance.new("TextBox")
searchBox.Size = UDim2.new(0, 105, 0, 19)
searchBox.Position = UDim2.new(1, -135, 0.5, -9.5)
searchBox.BackgroundColor3 = Theme.ControlBg
searchBox.BorderSizePixel = 0
searchBox.Font = MainFont
searchBox.PlaceholderText = "Search..."
searchBox.PlaceholderColor3 = Theme.TextDark
searchBox.Text = ""
searchBox.TextColor3 = Theme.TextWhite
searchBox.TextSize = 11
searchBox.ZIndex = 12
searchBox.Parent = topBar

local pad = Instance.new("UIPadding")
pad.PaddingLeft = UDim.new(0, 6)
pad.Parent = searchBox

local sbStroke = Instance.new("UIStroke")
sbStroke.Color = Theme.BorderDark
sbStroke.Thickness = 1
sbStroke.Parent = searchBox

searchBox.Focused:Connect(function() sbStroke.Color = Theme.BorderPink end)
searchBox.FocusLost:Connect(function() sbStroke.Color = Theme.BorderDark end)

local closeBtn = Instance.new("TextButton")
closeBtn.Name = "CloseButton"
closeBtn.Size = UDim2.new(0, 20, 0, 19)
closeBtn.Position = UDim2.new(1, -26, 0.5, -9.5)
closeBtn.BackgroundColor3 = Theme.ControlBg
closeBtn.BorderSizePixel = 0
closeBtn.Font = MainFont
closeBtn.Text = "×"
closeBtn.TextColor3 = Theme.TextMuted
closeBtn.TextSize = 14
closeBtn.ZIndex = 12
closeBtn.Parent = topBar

local cbStroke = Instance.new("UIStroke")
cbStroke.Color = Theme.BorderDark
cbStroke.Thickness = 1
cbStroke.Parent = closeBtn

closeBtn.MouseEnter:Connect(function()
    closeBtn.TextColor3 = Theme.AccentPinkLight
    cbStroke.Color = Theme.BorderPink
end)
closeBtn.MouseLeave:Connect(function()
    closeBtn.TextColor3 = Theme.TextMuted
    cbStroke.Color = Theme.BorderDark
end)
closeBtn.MouseButton1Click:Connect(function()
    setMenuVisible(false)
end)

local innerCanvas = Instance.new("Frame")
innerCanvas.Name = "InnerCanvas"
innerCanvas.Size = UDim2.new(1, -14, 1, -40)
innerCanvas.Position = UDim2.new(0, 7, 0, 33)
innerCanvas.BackgroundColor3 = Theme.InnerCanvasBg
innerCanvas.BorderSizePixel = 0
innerCanvas.ZIndex = 11
innerCanvas.Parent = mainWindow

local innerStroke = Instance.new("UIStroke")
innerStroke.Color = Theme.BorderDark
innerStroke.Thickness = 1
innerStroke.Parent = innerCanvas

local tabNavFrame = Instance.new("Frame")
tabNavFrame.Name = "TabNavFrame"
tabNavFrame.Size = UDim2.new(1, -12, 0, 22)
tabNavFrame.Position = UDim2.new(0, 6, 0, 4)
tabNavFrame.BackgroundTransparency = 1
tabNavFrame.ZIndex = 12
tabNavFrame.Parent = innerCanvas

local tabNavLayout = Instance.new("UIListLayout")
tabNavLayout.FillDirection = Enum.FillDirection.Horizontal
tabNavLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
tabNavLayout.VerticalAlignment = Enum.VerticalAlignment.Center
tabNavLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabNavLayout.Padding = UDim.new(0, 8)
tabNavLayout.Parent = tabNavFrame

local tabNavPad = Instance.new("UIPadding")
tabNavPad.PaddingLeft = UDim.new(0, 4)
tabNavPad.Parent = tabNavFrame

local tabContentFrame = Instance.new("Frame")
tabContentFrame.Name = "TabContentFrame"
tabContentFrame.Size = UDim2.new(1, -12, 1, -54)
tabContentFrame.Position = UDim2.new(0, 6, 0, 30)
tabContentFrame.BackgroundTransparency = 1
tabContentFrame.ZIndex = 12
tabContentFrame.Parent = innerCanvas

local statusBar = Instance.new("Frame")
statusBar.Name = "StatusBar"
statusBar.Size = UDim2.new(1, -12, 0, 18)
statusBar.Position = UDim2.new(0, 6, 1, -20)
statusBar.BackgroundTransparency = 1
statusBar.ZIndex = 12
statusBar.Parent = innerCanvas

local statusLine = Instance.new("Frame")
statusLine.Size = UDim2.new(1, 0, 0, 1)
statusLine.Position = UDim2.new(0, 0, 0, 0)
statusLine.BackgroundColor3 = Theme.BorderDark
statusLine.BorderSizePixel = 0
statusLine.ZIndex = 12
statusLine.Parent = statusBar

local statusLeft = Instance.new("TextLabel")
statusLeft.Size = UDim2.new(0.6, 0, 1, -2)
statusLeft.Position = UDim2.new(0, 2, 0, 2)
statusLeft.BackgroundTransparency = 1
statusLeft.Font = MainFont
statusLeft.RichText = true
statusLeft.Text = 'welcome back, <font color="#e27898">' .. LocalPlayer.DisplayName .. '</font>'
statusLeft.TextColor3 = Theme.TextMuted
statusLeft.TextSize = 10.5
statusLeft.TextXAlignment = Enum.TextXAlignment.Left
statusLeft.ZIndex = 13
statusLeft.Parent = statusBar

local statusRight = Instance.new("TextLabel")
statusRight.Size = UDim2.new(0.4, -2, 1, -2)
statusRight.Position = UDim2.new(0.6, 0, 0, 2)
statusRight.BackgroundTransparency = 1
statusRight.Font = MainFont
statusRight.RichText = true
statusRight.Text = '<font color="#e27898">[</font> <font color="#888894">rivals</font> <font color="#e27898">]</font>'
statusRight.TextColor3 = Theme.TextMuted
statusRight.TextSize = 10.5
statusRight.TextXAlignment = Enum.TextXAlignment.Right
statusRight.ZIndex = 13
statusRight.Parent = statusBar

local tabList = {"home", "aim", "auto", "esp", "move", "guns", "skins", "world", "view", "config"}
local tabPages = {}
local tabButtons = {}
local currentTab = "home"

local function switchTab(tabName)
    currentTab = tabName
    for tName, page in pairs(tabPages) do
        page.Visible = (tName == tabName)
    end
    for _, btnData in ipairs(tabButtons) do
        local isSelf = (btnData.name == tabName)
        btnData.btn.TextColor3 = isSelf and Theme.AccentPinkLight or Theme.TextMuted
        if btnData.indicator then
            btnData.indicator.Visible = isSelf
        end
    end
end

for idx, tabName in ipairs(tabList) do
    local btn = Instance.new("TextButton")
    btn.Name = "TabBtn_" .. tabName
    btn.LayoutOrder = idx
    btn.Size = UDim2.new(0, 0, 1, 0)
    btn.AutomaticSize = Enum.AutomaticSize.X
    btn.BackgroundTransparency = 1
    btn.Font = MainFont
    btn.Text = tabName:sub(1, 1):upper() .. tabName:sub(2)
    btn.TextColor3 = (tabName == currentTab) and Theme.AccentPinkLight or Theme.TextMuted
    btn.TextSize = 12
    btn.AutoButtonColor = false
    btn.ZIndex = 13
    btn.Parent = tabNavFrame

    local padBtn = Instance.new("UIPadding")
    padBtn.PaddingLeft = UDim.new(0, 4)
    padBtn.PaddingRight = UDim.new(0, 4)
    padBtn.Parent = btn

    local indicator = Instance.new("Frame")
    indicator.Size = UDim2.new(1, -4, 0, 1.5)
    indicator.Position = UDim2.new(0, 2, 1, -1)
    indicator.BackgroundColor3 = Theme.AccentPink
    indicator.BorderSizePixel = 0
    indicator.Visible = (tabName == currentTab)
    indicator.ZIndex = 14
    indicator.Parent = btn

    local indGrad = Instance.new("UIGradient")
    indGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Theme.AccentPinkLight),
        ColorSequenceKeypoint.new(1, Theme.AccentPinkDark)
    })
    indGrad.Parent = indicator

    btn.MouseEnter:Connect(function()
        if tabName ~= currentTab then
            btn.TextColor3 = Theme.TextWhite
        end
    end)
    btn.MouseLeave:Connect(function()
        if tabName ~= currentTab then
            btn.TextColor3 = Theme.TextMuted
        end
    end)

    btn.MouseButton1Click:Connect(function()
        switchTab(tabName)
    end)

    table.insert(tabButtons, {name = tabName, btn = btn, indicator = indicator})

    local page = Instance.new("Frame")
    page.Name = "Page_" .. tabName
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.Visible = (tabName == currentTab)
    page.ZIndex = 13
    page.Parent = tabContentFrame

    local leftCol = Instance.new("ScrollingFrame")
    leftCol.Name = "LeftCol"
    leftCol.Size = UDim2.new(0.49, 0, 1, 0)
    leftCol.Position = UDim2.new(0, 0, 0, 0)
    leftCol.BackgroundTransparency = 1
    leftCol.BorderSizePixel = 0
    leftCol.ScrollBarThickness = 0
    leftCol.AutomaticCanvasSize = Enum.AutomaticSize.Y
    leftCol.ZIndex = 14
    leftCol.Parent = page
    local lLayout = Instance.new("UIListLayout")
    lLayout.Padding = UDim.new(0, 7)
    lLayout.Parent = leftCol

    local rightCol = Instance.new("ScrollingFrame")
    rightCol.Name = "RightCol"
    rightCol.Size = UDim2.new(0.49, 0, 1, 0)
    rightCol.Position = UDim2.new(0.51, 0, 0, 0)
    rightCol.BackgroundTransparency = 1
    rightCol.BorderSizePixel = 0
    rightCol.ScrollBarThickness = 0
    rightCol.AutomaticCanvasSize = Enum.AutomaticSize.Y
    rightCol.ZIndex = 14
    rightCol.Parent = page
    local rLayout = Instance.new("UIListLayout")
    rLayout.Padding = UDim.new(0, 7)
    rLayout.Parent = rightCol

    tabPages[tabName] = page
end

local function createGroupbox(parent, title, desc, bottomNote)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, -2, 0, 0)
    card.AutomaticSize = Enum.AutomaticSize.Y
    card.BackgroundColor3 = Theme.CardBg
    card.BorderSizePixel = 0
    card.ZIndex = 15
    card.Parent = parent

    local cGrad = Instance.new("UIGradient")
    cGrad.Rotation = 90
    cGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Theme.CardBgTop),
        ColorSequenceKeypoint.new(1, Theme.CardBgBottom)
    })
    cGrad.Parent = card

    local stroke = Instance.new("UIStroke")
    stroke.Color = Theme.BorderCard
    stroke.Thickness = 1
    stroke.Parent = card

    local topPinkLine = Instance.new("Frame")
    topPinkLine.Name = "TopAccentLine"
    topPinkLine.Size = UDim2.new(1, 0, 0, 1.5)
    topPinkLine.Position = UDim2.new(0, 0, 0, 0)
    topPinkLine.BackgroundColor3 = Theme.AccentPink
    topPinkLine.BorderSizePixel = 0
    topPinkLine.ZIndex = 16
    topPinkLine.Parent = card

    local lGrad = Instance.new("UIGradient")
    lGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Theme.AccentPinkLight),
        ColorSequenceKeypoint.new(1, Theme.AccentPinkDark)
    })
    lGrad.Parent = topPinkLine

    local header = Instance.new("Frame")
    header.Name = "Header"
    header.Size = UDim2.new(1, 0, 0, desc and 32 or 20)
    header.Position = UDim2.new(0, 0, 0, 1)
    header.BackgroundTransparency = 1
    header.ZIndex = 16
    header.Parent = card

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Name = "TitleLabel"
    titleLbl.Size = UDim2.new(1, -12, 0, 16)
    titleLbl.Position = UDim2.new(0, 6, 0, 2)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Font = MainFont
    titleLbl.Text = title
    titleLbl.TextColor3 = Theme.TextWhite
    titleLbl.TextSize = 12.5
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.ZIndex = 17
    titleLbl.Parent = header

    if desc then
        local descLbl = Instance.new("TextLabel")
        descLbl.Size = UDim2.new(1, -12, 0, 14)
        descLbl.Position = UDim2.new(0, 6, 0, 17)
        descLbl.BackgroundTransparency = 1
        descLbl.Font = MainFont
        descLbl.Text = desc
        descLbl.TextColor3 = Theme.TextMuted
        descLbl.TextSize = 10.5
        descLbl.TextWrapped = true
        descLbl.TextXAlignment = Enum.TextXAlignment.Left
        descLbl.ZIndex = 17
        descLbl.Parent = header
    end

    local content = Instance.new("Frame")
    content.Name = "Content"
    content.Size = UDim2.new(1, -12, 0, 0)
    content.Position = UDim2.new(0, 6, 0, desc and 34 or 22)
    content.AutomaticSize = Enum.AutomaticSize.Y
    content.BackgroundTransparency = 1
    content.ZIndex = 16
    content.Parent = card

    local cLayout = Instance.new("UIListLayout")
    cLayout.Padding = UDim.new(0, 6)
    cLayout.Parent = content

    local cPad = Instance.new("UIPadding")
    cPad.PaddingBottom = UDim.new(0, bottomNote and 3 or 7)
    cPad.Parent = content

    if bottomNote then
        local noteLbl = Instance.new("TextLabel")
        noteLbl.Size = UDim2.new(1, 0, 0, 22)
        noteLbl.BackgroundTransparency = 1
        noteLbl.Font = MainFont
        noteLbl.Text = bottomNote
        noteLbl.TextColor3 = Theme.TextDark
        noteLbl.TextSize = 10
        noteLbl.TextWrapped = true
        noteLbl.TextXAlignment = Enum.TextXAlignment.Left
        noteLbl.ZIndex = 17
        noteLbl.Parent = content
    end

    return content
end

local function addCheckbox(parent, labelText, defaultVal, callback)
    local state = defaultVal or false
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 16)
    row.BackgroundTransparency = 1
    row.ZIndex = 16
    row.Parent = parent

    local box = Instance.new("TextButton")
    box.Size = UDim2.new(0, 13, 0, 13)
    box.Position = UDim2.new(0, 0, 0.5, -6.5)
    box.BackgroundColor3 = state and Theme.AccentPink or Theme.ControlBg
    box.BorderSizePixel = 0
    box.Text = ""
    box.ZIndex = 17
    box.Parent = row

    local bStroke = Instance.new("UIStroke")
    bStroke.Color = state and Theme.AccentPinkLight or Theme.BorderDark
    bStroke.Thickness = 1
    bStroke.Parent = box

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -20, 1, 0)
    lbl.Position = UDim2.new(0, 20, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Font = MainFont
    lbl.Text = labelText
    lbl.TextColor3 = Theme.TextWhite
    lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 17
    lbl.Parent = row

    local function updateState(newVal)
        state = newVal
        box.BackgroundColor3 = state and Theme.AccentPink or Theme.ControlBg
        bStroke.Color = state and Theme.AccentPinkLight or Theme.BorderDark
        if type(callback) == "function" then callback(state) end
    end

    box.MouseButton1Click:Connect(function()
        updateState(not state)
    end)

    return {
        Set = updateState,
        Get = function() return state end
    }
end

local function addSlider(parent, labelText, minVal, maxVal, defaultVal, displayTemplate, callback)
    local curVal = defaultVal or minVal

    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 28)
    container.BackgroundTransparency = 1
    container.ZIndex = 16
    container.Parent = parent

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 12)
    lbl.BackgroundTransparency = 1
    lbl.Font = MainFont
    lbl.Text = labelText
    lbl.TextColor3 = Theme.TextMuted
    lbl.TextSize = 11.5
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 17
    lbl.Parent = container

    local track = Instance.new("TextButton")
    track.Size = UDim2.new(1, 0, 0, 14)
    track.Position = UDim2.new(0, 0, 0, 13)
    track.BackgroundColor3 = Theme.ControlBg
    track.BorderSizePixel = 0
    track.Text = ""
    track.AutoButtonColor = false
    track.ZIndex = 17
    track.Parent = container

    local tStroke = Instance.new("UIStroke")
    tStroke.Color = Theme.BorderDark
    tStroke.Thickness = 1
    tStroke.Parent = track

    local fill = Instance.new("Frame")
    local pct = math.clamp((curVal - minVal) / (maxVal - minVal), 0, 1)
    fill.Size = UDim2.new(pct, 0, 1, 0)
    fill.BackgroundColor3 = Theme.AccentPink
    fill.BorderSizePixel = 0
    fill.ZIndex = 18
    fill.Parent = track

    local fGrad = Instance.new("UIGradient")
    fGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Theme.AccentPinkLight),
        ColorSequenceKeypoint.new(1, Theme.AccentPinkDark)
    })
    fGrad.Parent = fill

    local decimals = 0
    if displayTemplate then
        local d = displayTemplate:match("%%%.(%d+)f")
        if d then
            decimals = tonumber(d)
        elseif displayTemplate:find("%%f") then
            decimals = 2
        end
    elseif (minVal % 1 ~= 0) or (maxVal % 1 ~= 0) or (curVal % 1 ~= 0) then
        decimals = 2
    end

    local function roundVal(raw)
        if decimals > 0 then
            local mult = 10 ^ decimals
            return math.clamp(math.floor(raw * mult + 0.5) / mult, minVal, maxVal)
        else
            return math.clamp(math.floor(raw + 0.5), minVal, maxVal)
        end
    end

    local function getDisplay(v)
        if displayTemplate then
            return string.format(displayTemplate, v, maxVal)
        end
        return tostring(v)
    end

    local valLbl = Instance.new("TextLabel")
    valLbl.Size = UDim2.new(1, 0, 1, 0)
    valLbl.BackgroundTransparency = 1
    valLbl.Font = MainFont
    valLbl.Text = getDisplay(curVal)
    valLbl.TextColor3 = Theme.TextWhite
    valLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    valLbl.TextStrokeTransparency = 0.3
    valLbl.TextSize = 10.5
    valLbl.ZIndex = 19
    valLbl.Parent = track

    local isSliding = false
    local function updateFromInput(input)
        local relX = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
        local raw = minVal + (maxVal - minVal) * relX
        curVal = roundVal(raw)
        local visualPct = math.clamp((curVal - minVal) / (maxVal - minVal), 0, 1)
        fill.Size = UDim2.new(visualPct, 0, 1, 0)
        valLbl.Text = getDisplay(curVal)
        if type(callback) == "function" then callback(curVal) end
    end

    track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isSliding = true
            updateFromInput(input)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isSliding = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if isSliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateFromInput(input)
        end
    end)

    return {
        Set = function(v)
            local num = tonumber(v) or curVal
            curVal = roundVal(num)
            local p = math.clamp((curVal - minVal) / (maxVal - minVal), 0, 1)
            fill.Size = UDim2.new(p, 0, 1, 0)
            valLbl.Text = getDisplay(curVal)
            if type(callback) == "function" then callback(curVal) end
        end
    }
end

local function addDropdown(parent, labelText, options, defaultIdx, callback)
    local selectedIdx = defaultIdx or 1
    local isOpen = false

    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 34)
    container.BackgroundTransparency = 1
    container.ZIndex = 16
    container.Parent = parent

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 13)
    lbl.BackgroundTransparency = 1
    lbl.Font = MainFont
    lbl.Text = labelText
    lbl.TextColor3 = Theme.TextMuted
    lbl.TextSize = 11.5
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 17
    lbl.Parent = container

    local box = Instance.new("TextButton")
    box.Size = UDim2.new(1, 0, 0, 20)
    box.Position = UDim2.new(0, 0, 0, 14)
    box.BackgroundColor3 = Theme.ControlBg
    box.BorderSizePixel = 0
    box.Font = MainFont
    box.Text = "  " .. options[selectedIdx]
    box.TextColor3 = Theme.TextWhite
    box.TextSize = 11.5
    box.TextXAlignment = Enum.TextXAlignment.Left
    box.ZIndex = 17
    box.Parent = container

    local bStroke = Instance.new("UIStroke")
    bStroke.Color = Theme.BorderDark
    bStroke.Thickness = 1
    bStroke.Parent = box

    local chevron = Instance.new("TextLabel")
    chevron.Size = UDim2.new(0, 14, 1, 0)
    chevron.Position = UDim2.new(1, -16, 0, 0)
    chevron.BackgroundTransparency = 1
    chevron.Font = Enum.Font.GothamBold
    chevron.Text = "▼"
    chevron.TextColor3 = Theme.AccentPink
    chevron.TextSize = 8.5
    chevron.ZIndex = 18
    chevron.Parent = box

    local listFrame = Instance.new("ScrollingFrame")
    listFrame.Name = "DropdownMenu_" .. labelText:gsub("%s+", "")
    listFrame.BackgroundColor3 = Theme.CardBg
    listFrame.BorderSizePixel = 0
    listFrame.ScrollBarThickness = 2.5
    listFrame.ScrollBarImageColor3 = Theme.AccentPink
    listFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    listFrame.ZIndex = 1001
    listFrame.Visible = false
    listFrame.Parent = dropdownOverlay

    local lStroke = Instance.new("UIStroke")
    lStroke.Color = Theme.BorderPinkDark
    lStroke.Thickness = 1
    lStroke.Parent = listFrame

    local lGrad = Instance.new("UIGradient")
    lGrad.Rotation = 90
    lGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Theme.CardBgTop),
        ColorSequenceKeypoint.new(1, Theme.CardBgBottom)
    })
    lGrad.Parent = listFrame

    local optLayout = Instance.new("UIListLayout")
    optLayout.Padding = UDim.new(0, 1)
    optLayout.Parent = listFrame

    local function closeDropdown()
        isOpen = false
        listFrame.Visible = false
        chevron.Text = "▼"
        bStroke.Color = Theme.BorderDark
        if activeDropdownClose == closeDropdown then
            activeDropdownClose = nil
        end
    end

    local function refreshOptions()
        for _, child in ipairs(listFrame:GetChildren()) do
            if child:IsA("TextButton") then child:Destroy() end
        end

        for idx, optName in ipairs(options) do
            local optBtn = Instance.new("TextButton")
            optBtn.Size = UDim2.new(1, 0, 0, 20)
            optBtn.BackgroundColor3 = (idx == selectedIdx) and Theme.ButtonBg or Color3.fromRGB(0, 0, 0)
            optBtn.BackgroundTransparency = (idx == selectedIdx) and 0 or 1
            optBtn.BorderSizePixel = 0
            optBtn.Font = MainFont
            optBtn.Text = "  " .. optName
            optBtn.TextColor3 = (idx == selectedIdx) and Theme.AccentPinkLight or Theme.TextWhite
            optBtn.TextSize = 11.5
            optBtn.TextXAlignment = Enum.TextXAlignment.Left
            optBtn.ZIndex = 1002
            optBtn.Parent = listFrame

            optBtn.MouseEnter:Connect(function()
                if idx ~= selectedIdx then
                    optBtn.BackgroundTransparency = 0.5
                    optBtn.BackgroundColor3 = Theme.ButtonHoverBg
                end
            end)
            optBtn.MouseLeave:Connect(function()
                if idx ~= selectedIdx then
                    optBtn.BackgroundTransparency = 1
                end
            end)

            optBtn.MouseButton1Click:Connect(function()
                selectedIdx = idx
                box.Text = "  " .. optName
                closeDropdown()
                if type(callback) == "function" then callback(optName, idx) end
            end)
        end
    end

    local function openDropdown()
        if activeDropdownClose and activeDropdownClose ~= closeDropdown then
            activeDropdownClose()
        end

        refreshOptions()
        local boxPos = box.AbsolutePosition
        local boxSize = box.AbsoluteSize
        local menuHeight = math.min(#options * 21, 140)

        listFrame.Position = UDim2.new(0, boxPos.X, 0, boxPos.Y + boxSize.Y + 2)
        listFrame.Size = UDim2.new(0, boxSize.X, 0, menuHeight)
        listFrame.Visible = true
        isOpen = true
        chevron.Text = "▲"
        bStroke.Color = Theme.BorderPink

        activeDropdownClose = function(clickPos)
            if clickPos then
                local menuPos = listFrame.AbsolutePosition
                local menuSize = listFrame.AbsoluteSize
                local inMenu = clickPos.X >= menuPos.X and clickPos.X <= (menuPos.X + menuSize.X) and clickPos.Y >= menuPos.Y and clickPos.Y <= (menuPos.Y + menuSize.Y)
                local inBox = clickPos.X >= boxPos.X and clickPos.X <= (boxPos.X + boxSize.X) and clickPos.Y >= boxPos.Y and clickPos.Y <= (boxPos.Y + boxSize.Y)
                if not inMenu and not inBox then
                    closeDropdown()
                end
            else
                closeDropdown()
            end
        end
    end

    box.MouseButton1Click:Connect(function()
        if isOpen then
            closeDropdown()
        else
            openDropdown()
        end
    end)

    return {
        Set = function(valOrIdx)
            local targetIdx = 1
            if type(valOrIdx) == "number" then
                targetIdx = math.clamp(valOrIdx, 1, #options)
            elseif type(valOrIdx) == "string" then
                for i, name in ipairs(options) do
                    if name == valOrIdx then
                        targetIdx = i
                        break
                    end
                end
            end
            selectedIdx = targetIdx
            box.Text = "  " .. options[selectedIdx]
            if type(callback) == "function" then callback(options[selectedIdx], selectedIdx) end
        end,
        SetOptions = function(newOptions, newSelected)
            options = newOptions
            local targetIdx = 1
            if type(newSelected) == "number" then
                targetIdx = math.clamp(newSelected, 1, #options)
            elseif type(newSelected) == "string" then
                for i, name in ipairs(options) do
                    if name == newSelected then
                        targetIdx = i
                        break
                    end
                end
            end
            selectedIdx = targetIdx
            box.Text = "  " .. (options[selectedIdx] or "None")
        end,
        Get = function()
            return options[selectedIdx]
        end
    }
end

local function addTextbox(parent, labelText, defaultVal, placeholder, callback)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 33)
    container.BackgroundTransparency = 1
    container.ZIndex = 16
    container.Parent = parent

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 12)
    lbl.BackgroundTransparency = 1
    lbl.Font = MainFont
    lbl.Text = labelText
    lbl.TextColor3 = Theme.TextMuted
    lbl.TextSize = 11.5
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 17
    lbl.Parent = container

    local tb = Instance.new("TextBox")
    tb.Size = UDim2.new(1, 0, 0, 19)
    tb.Position = UDim2.new(0, 0, 0, 13)
    tb.BackgroundColor3 = Theme.ControlBg
    tb.BorderSizePixel = 0
    tb.Font = MainFont
    tb.PlaceholderText = placeholder or ""
    tb.PlaceholderColor3 = Theme.TextDark
    tb.Text = defaultVal or ""
    tb.TextColor3 = Theme.TextWhite
    tb.TextSize = 12
    tb.TextXAlignment = Enum.TextXAlignment.Left
    tb.ZIndex = 17
    tb.Parent = container

    local tPad = Instance.new("UIPadding")
    tPad.PaddingLeft = UDim.new(0, 6)
    tPad.Parent = tb

    local tbStroke = Instance.new("UIStroke")
    tbStroke.Color = Theme.BorderDark
    tbStroke.Thickness = 1
    tbStroke.Parent = tb

    tb.Focused:Connect(function() tbStroke.Color = Theme.BorderPink end)
    tb.FocusLost:Connect(function()
        tbStroke.Color = Theme.BorderDark
        if type(callback) == "function" then callback(tb.Text) end
    end)

    return {
        Set = function(txt)
            tb.Text = tostring(txt)
            if type(callback) == "function" then callback(tb.Text) end
        end,
        Get = function()
            return tb.Text
        end
    }
end

local function clickWeapon()
    if mouse1click then
        pcall(mouse1click)
        return
    end
    if mouse1press and mouse1release then
        pcall(function()
            mouse1press()
            task.wait(0.01)
            mouse1release()
        end)
        return
    end
    local vim = game:GetService("VirtualInputManager")
    if vim then
        local vp = Camera and Camera.ViewportSize or Vector2.new(1280, 720)
        local cx = math.floor(vp.X * 0.5)
        local cy = math.floor(vp.Y * 0.5)
        if UserInputService.TouchEnabled and not UserInputService.MouseEnabled and vim.SendTouchEvent then
            pcall(function()
                vim:SendTouchEvent(0, 0, cx, cy)
                task.wait(0.01)
                vim:SendTouchEvent(0, 2, cx, cy)
            end)
            return
        end
        if vim.SendMouseButtonEvent then
            pcall(function()
                vim:SendMouseButtonEvent(cx, cy, 0, true, Workspace, 0)
                task.wait(0.01)
                vim:SendMouseButtonEvent(cx, cy, 0, false, Workspace, 0)
            end)
            return
        end
    end
end
hideFromStack(clickWeapon)

local uiRegistry = {}
local isSyncingTeamCheck = false
local function updateTeamCheck(v)
    if isSyncingTeamCheck then return end
    isSyncingTeamCheck = true
    Config.TeamCheck = v
    for _, name in ipairs({"AimbotTeamCheck", "SilentTeamCheck", "RagebotTeamCheck"}) do
        if uiRegistry[name] and uiRegistry[name].Set and uiRegistry[name].Get() ~= v then
            pcall(function() uiRegistry[name].Set(v) end)
        end
    end
    isSyncingTeamCheck = false
end
hideFromStack(updateTeamCheck)

local function addButton(parent, btnText, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 22)
    btn.BackgroundColor3 = Theme.ButtonBg
    btn.BorderSizePixel = 0
    btn.Font = MainFont
    btn.Text = btnText
    btn.TextColor3 = Theme.TextWhite
    btn.TextSize = 12
    btn.AutoButtonColor = false
    btn.ZIndex = 17
    btn.Parent = parent

    local bStroke = Instance.new("UIStroke")
    bStroke.Color = Theme.ButtonBorder
    bStroke.Thickness = 1
    bStroke.Parent = btn

    btn.MouseEnter:Connect(function()
        btn.BackgroundColor3 = Theme.ButtonHoverBg
        bStroke.Color = Theme.BorderPinkDark
    end)
    btn.MouseLeave:Connect(function()
        btn.BackgroundColor3 = Theme.ButtonBg
        bStroke.Color = Theme.ButtonBorder
    end)

    btn.MouseButton1Click:Connect(function()
        if type(callback) == "function" then callback() end
    end)
    return btn
end

local function getEnemyPlayers()
    local now = tick()
    if (now - TargetVis.lastEnemyUpdateTime < 0.15) and (#TargetVis.cachedEnemies > 0) then
        return TargetVis.cachedEnemies
    end
    table.clear(TargetVis.cachedEnemies)

    local inLobby = isInLobby()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            if inLobby then
                if Config.ESP_Lobby or Config.TargetVisualizer then
                    table.insert(TargetVis.cachedEnemies, p)
                end
            else
                if isEnemyPlayer(p) then
                    table.insert(TargetVis.cachedEnemies, p)
                end
            end
        end
    end
    TargetVis.lastEnemyUpdateTime = now
    return TargetVis.cachedEnemies
end

local function getClosestTarget(maxFOV, checkVisible, partMode, targetPriority)
    local now = tick()
    local cacheKey = tostring(maxFOV) .. "_" .. tostring(checkVisible) .. "_" .. tostring(partMode) .. "_" .. tostring(targetPriority)
    local cached = TargetVis.targetCache[cacheKey]
    if cached and (now - cached.time < 0.06) and cached.target and cached.target.Parent then
        return cached.target
    end

    if not TargetVis.staticRayParams then
        local p = RaycastParams.new()
        p.FilterType = Enum.RaycastFilterType.Exclude
        p.IgnoreWater = true
        TargetVis.staticRayParams = p
    end

    local closest, closestScore = nil, math.huge
    local mousePos = UserInputService:GetMouseLocation()
    local myChar = LocalPlayer.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    local camPos = Camera.CFrame.Position
    local camLook = Camera.CFrame.LookVector
    local is360 = (maxFOV == nil) or (maxFOV >= 999)

    TargetVis.staticRayParams.FilterDescendantsInstances = {myChar, Camera}

    for _, p in ipairs(getEnemyPlayers()) do
        local char = p.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local rootPart = char and char:FindFirstChild("HumanoidRootPart")

        if char and hum and hum.Health > 0 and rootPart then

            local toRoot = rootPart.Position - camPos
            if is360 or toRoot:Dot(camLook) > -5 then

                local isDeflecting = char:GetAttribute("Deflecting") or char:FindFirstChild("Deflect") or char:FindFirstChild("KatanaDeflect")
                local isShielded = char:GetAttribute("Shielded") or char:FindFirstChild("Shield") or char:FindFirstChild("EnergyShield")
                local isProtected = char:GetAttribute("SpawnImmunity") or char:FindFirstChildOfClass("ForceField")

                local skip = false
                if isTeammate(p) or isTeammate(char) then skip = true end
                if Config.SilentIgnoreDeflecting and isDeflecting then skip = true end
                if Config.SilentIgnoreShielded and isShielded then skip = true end
                if Config.SilentVulnerableOnly and isProtected then skip = true end

                if not skip then
                    local headCandidate = char:FindFirstChild("Head") or char:FindFirstChild("HitboxHead")
                    local bodyCandidate = char:FindFirstChild("UpperTorso") or rootPart
                    local hitPart = nil

                    if partMode == "Head" then
                        hitPart = headCandidate or bodyCandidate
                    elseif partMode == "Body" then
                        hitPart = bodyCandidate or headCandidate
                    elseif partMode == "Closest" then
                        if headCandidate and bodyCandidate then
                            local hScr, hOn = Camera:WorldToViewportPoint(headCandidate.Position)
                            local bScr, bOn = Camera:WorldToViewportPoint(bodyCandidate.Position)
                            if hOn and bOn then
                                local hDist = (Vector2.new(hScr.X, hScr.Y) - mousePos).Magnitude
                                local bDist = (Vector2.new(bScr.X, bScr.Y) - mousePos).Magnitude
                                hitPart = (hDist <= bDist) and headCandidate or bodyCandidate
                            elseif hOn then
                                hitPart = headCandidate
                            elseif bOn then
                                hitPart = bodyCandidate
                            else
                                hitPart = headCandidate
                            end
                        else
                            hitPart = headCandidate or bodyCandidate
                        end
                    else
                        hitPart = headCandidate or bodyCandidate
                    end

                    if hitPart then
                        local inRange = false
                        local score = math.huge
                        if is360 then
                            local worldDist = myRoot and (hitPart.Position - myRoot.Position).Magnitude or (hitPart.Position - camPos).Magnitude
                            if worldDist <= (maxFOV or math.huge) then
                                inRange = true
                                if targetPriority == "Health" then
                                    score = hum.Health
                                else
                                    score = worldDist
                                end
                            end
                        else
                            local scrPos, onScreen = Camera:WorldToViewportPoint(hitPart.Position)
                            if onScreen and scrPos.Z > 0 then
                                local fovDist = (Vector2.new(scrPos.X, scrPos.Y) - mousePos).Magnitude
                                if fovDist <= (maxFOV or math.huge) then
                                    inRange = true
                                    if targetPriority == "Health" then
                                        score = hum.Health
                                    elseif targetPriority == "Distance" and myRoot then
                                        score = (hitPart.Position - myRoot.Position).Magnitude
                                    else
                                        score = fovDist
                                    end
                                end
                            end
                        end

                        if inRange and score < closestScore then
                            if checkVisible then
                                local dir = hitPart.Position - camPos
                                local res = Workspace:Raycast(camPos, dir, TargetVis.staticRayParams)
                                if not res or res.Instance:IsDescendantOf(char) then
                                    closest = hitPart
                                    closestScore = score
                                end
                            else
                                closest = hitPart
                                closestScore = score
                            end
                        end
                    end
                end
            end
        end
    end

    TargetVis.targetCache[cacheKey] = { target = closest, time = now }
    return closest
end

local pageHome = tabPages["home"]
local homeLeft = pageHome:FindFirstChild("LeftCol")
local homeRight = pageHome:FindFirstChild("RightCol")

local gbAccount = createGroupbox(homeLeft, "Account")
local aUser = Instance.new("TextLabel")
aUser.Size = UDim2.new(1, 0, 0, 16)
aUser.BackgroundTransparency = 1
aUser.Font = MainFont
aUser.Text = LocalPlayer.Name
aUser.TextColor3 = Theme.TextWhite
aUser.TextSize = 12.5
aUser.TextXAlignment = Enum.TextXAlignment.Left
aUser.ZIndex = 17
aUser.Parent = gbAccount

local aDisplay = Instance.new("TextLabel")
aDisplay.Size = UDim2.new(1, 0, 0, 16)
aDisplay.BackgroundTransparency = 1
aDisplay.Font = MainFont
aDisplay.Text = "(@" .. LocalPlayer.DisplayName .. ")"
aDisplay.TextColor3 = Theme.TextMuted
aDisplay.TextSize = 12
aDisplay.TextXAlignment = Enum.TextXAlignment.Left
aDisplay.ZIndex = 17
aDisplay.Parent = gbAccount

local gbBuild = createGroupbox(homeLeft, "Build")
local bLbl = Instance.new("TextLabel")
bLbl.Size = UDim2.new(1, 0, 0, 16)
bLbl.BackgroundTransparency = 1
bLbl.Font = MainFont
bLbl.Text = "ReefHub P1003 build"
bLbl.TextColor3 = Theme.TextWhite
bLbl.TextSize = 12.5
bLbl.TextXAlignment = Enum.TextXAlignment.Left
bLbl.ZIndex = 17
bLbl.Parent = gbBuild

local gbSessionInfo = createGroupbox(homeRight, "Current Session")
local sPlayer = Instance.new("TextLabel")
sPlayer.Size = UDim2.new(1, 0, 0, 16)
sPlayer.BackgroundTransparency = 1
sPlayer.Font = MainFont
sPlayer.Text = "Player: " .. LocalPlayer.Name
sPlayer.TextColor3 = Theme.TextWhite
sPlayer.TextSize = 12.5
sPlayer.TextXAlignment = Enum.TextXAlignment.Left
sPlayer.ZIndex = 17
sPlayer.Parent = gbSessionInfo

sPing = Instance.new("TextLabel")
sPing.Size = UDim2.new(1, 0, 0, 16)
sPing.BackgroundTransparency = 1
sPing.Font = MainFont
sPing.Text = "0 ms - " .. #Players:GetPlayers() .. " players"
sPing.TextColor3 = Theme.TextWhite
sPing.TextSize = 12.5
sPing.TextXAlignment = Enum.TextXAlignment.Left
sPing.ZIndex = 17
sPing.Parent = gbSessionInfo

local gbSessionActions = createGroupbox(homeRight, "Session")
addButton(gbSessionActions, "Rejoin server", function()
    ShowNotification("ReefHub", "Reconnecting to experience...", "INFO", 3)
    task.spawn(function()
        task.wait(0.5)
        pcall(function()
            TeleportService:Teleport(17625359962, LocalPlayer)
        end)
    end)
end)

addButton(gbSessionActions, "Join lowest-ping server", function()
    ShowNotification("ReefHub", "Searching for lowest-ping public server...", "INFO", 3)
    task.spawn(function()
        local placeId = 17625359962
        local HttpService = game:GetService("HttpService")
        local url = string.format("https://games.roblox.com/v1/games/%d/servers/0?sortOrder=2&excludeFullGames=true&limit=25", placeId)
        local success, res = pcall(function() return game:HttpGet(url) end)
        local targetServer = nil
        if success and res then
            local sDec, data = pcall(function() return HttpService:JSONDecode(res) end)
            if sDec and data and data.data then
                for _, s in ipairs(data.data) do
                    if s.id ~= game.JobId and s.playing and s.maxPlayers and (s.playing < s.maxPlayers) then
                        if not targetServer or (s.ping and targetServer.ping and s.ping < targetServer.ping) or (s.ping and not targetServer.ping) then
                            targetServer = s
                        end
                    end
                end
            end
        end

        if targetServer then
            ShowNotification("ReefHub", string.format("Joining server (%d ms ping)...", targetServer.ping or 0), "SUCCESS", 3)
            task.wait(0.5)
            pcall(function()
                TeleportService:TeleportToPlaceInstance(placeId, targetServer.id, LocalPlayer)
            end)
        else
            ShowNotification("ReefHub", "Connecting to optimal regional server...", "INFO", 3)
            task.wait(0.5)
            pcall(function()
                TeleportService:Teleport(placeId, LocalPlayer)
            end)
        end
    end)
end)

local pageAuto = tabPages["auto"]
local autoLeft = pageAuto:FindFirstChild("LeftCol")
local autoRight = pageAuto:FindFirstChild("RightCol")

local gbRagebot = createGroupbox(autoLeft, "Ragebot", "Automatically targets and shoots\nenemies.")
uiRegistry["Ragebot"] = addCheckbox(gbRagebot, "Enable ragebot", Config.Ragebot, function(v) Config.Ragebot = v end)
uiRegistry["RagebotTeamCheck"] = addCheckbox(gbRagebot, "Team check", Config.TeamCheck, function(v) updateTeamCheck(v) end)
uiRegistry["RagebotAutoShoot"] = addCheckbox(gbRagebot, "Auto shoot", Config.RagebotAutoShoot, function(v) Config.RagebotAutoShoot = v end)
uiRegistry["RagebotTargetStrafe"] = addCheckbox(gbRagebot, "Target strafe", Config.RagebotTargetStrafe, function(v) Config.RagebotTargetStrafe = v end)
uiRegistry["TargetStrafeRadius"] = addSlider(gbRagebot, "Strafe radius", 6, 30, Config.TargetStrafeRadius, "%d studs", function(v) Config.TargetStrafeRadius = v end)
uiRegistry["TargetStrafeSpeed"] = addSlider(gbRagebot, "Strafe speed", 2, 15, Config.TargetStrafeSpeed, "%d spd", function(v) Config.TargetStrafeSpeed = v end)
uiRegistry["Autoplay"] = addCheckbox(gbRagebot, "Autoplay", Config.Autoplay, function(v) Config.Autoplay = v end)
uiRegistry["AutoplayDistance"] = addSlider(gbRagebot, "Autoplay stop distance", 8, 40, Config.AutoplayDistance, "%d studs", function(v) Config.AutoplayDistance = v end)

local gbMatch = createGroupbox(autoLeft, "Match Automation")
uiRegistry["AutoRespawn"] = addCheckbox(gbMatch, "Auto respawn", Config.AutoRespawn, function(v) Config.AutoRespawn = v end)
uiRegistry["AutoQueue"] = addCheckbox(gbMatch, "Auto queue", Config.AutoQueue, function(v) Config.AutoQueue = v end)
uiRegistry["QueueMode"] = addDropdown(gbMatch, "Queue", {"1v1", "2v2", "3v3", "4v4", "5v5"}, 1, function(v) Config.QueueMode = v end)

local gbVote = createGroupbox(autoLeft, "Automatic Voting")
uiRegistry["AutoVoteMaps"] = addCheckbox(gbVote, "Auto vote maps", Config.AutoVoteMaps, function(v) Config.AutoVoteMaps = v end)
uiRegistry["MapPriority"] = addDropdown(gbVote, "Map priority", {"Arena, Onyx, Crossroads", "Onyx, Arena, Crossroads", "Crossroads, Arena, Onyx"}, 1, function(v) Config.MapPriority = v end)
uiRegistry["AutoBanWeapons"] = addCheckbox(gbVote, "Auto ban weapons", Config.AutoBanWeapons, function(v) Config.AutoBanWeapons = v end)
uiRegistry["WeaponBanPriority"] = addDropdown(gbVote, "Weapon ban priority", {"Grenade Launcher, Minigun, RPG", "RPG, Grenade Launcher, Sniper", "Minigun, RPG, Shotgun"}, 1, function(v) Config.WeaponBanPriority = v end)
uiRegistry["SecondBanPriority"] = addDropdown(gbVote, "Second ban priority", {"Grenade Launcher, Minigun, RPG", "Sniper, Katana, Bow"}, 1, function(v) Config.SecondBanPriority = v end)

local gbLoadout = createGroupbox(autoLeft, "Automatic Loadout")
uiRegistry["AutoLoadout"] = addCheckbox(gbLoadout, "Auto loadout", Config.AutoLoadout, function(v) Config.AutoLoadout = v end)
uiRegistry["LoadoutOnlySelected"] = addCheckbox(gbLoadout, "Only on selected maps", Config.LoadoutOnlySelected, function(v) Config.LoadoutOnlySelected = v end)
uiRegistry["EnabledMaps"] = addDropdown(gbLoadout, "Enabled maps", {"Arena, Crossroads", "Onyx, Crossroads", "All Maps"}, 1, function(v) Config.EnabledMaps = v end)

local gbAntiAim = createGroupbox(autoRight, "Anti-Aim", "Changes the replicated pose only;\nyour camera and aim stay normal.")
uiRegistry["AntiAim"] = addCheckbox(gbAntiAim, "Enable anti-aim", Config.AntiAim, function(v) Config.AntiAim = v end)
uiRegistry["AntiAimMode"] = addDropdown(gbAntiAim, "Mode", {"Spin", "Jitter", "Backwards"}, 1, function(v) Config.AntiAimMode = v end)
uiRegistry["AntiAimSpeed"] = addSlider(gbAntiAim, "Spin speed", 10, 100, Config.AntiAimSpeed, "%d spd", function(v) Config.AntiAimSpeed = v end)

local gbDetectors = createGroupbox(autoRight, "Detectors", nil, "Ragebot's hacker priority consumes this detector and\ngame-provided Hacker attributes.")
uiRegistry["HackerDetector"] = addCheckbox(gbDetectors, "Hacker detector", Config.HackerDetector, function(v) Config.HackerDetector = v end)
uiRegistry["NotifyHackers"] = addCheckbox(gbDetectors, "Notify detected hackers", Config.NotifyHackers, function(v) Config.NotifyHackers = v end)
uiRegistry["HackerAutoLoad"] = addCheckbox(gbDetectors, "Auto load config on detect", Config.HackerAutoLoad, function(v) Config.HackerAutoLoad = v end)
uiRegistry["HackerProfile"] = addTextbox(gbDetectors, "Profile to auto load", Config.HackerProfile, "profile name (e.g. rage)", function(v) Config.HackerProfile = v end)
uiRegistry["SpeedThreshold"] = addSlider(gbDetectors, "Speed threshold", 50, 400, Config.SpeedThreshold, "%d studs/s/%d studs/s", function(v) Config.SpeedThreshold = v end)
uiRegistry["SpeedDuration"] = addSlider(gbDetectors, "Required duration", 0.1, 3, Config.SpeedDuration, "%.2f s/%.0f s", function(v) Config.SpeedDuration = v end)
uiRegistry["ModDetector"] = addCheckbox(gbDetectors, "Moderator detector", Config.ModDetector, function(v) Config.ModDetector = v end)
uiRegistry["NotifyMods"] = addCheckbox(gbDetectors, "Notify moderators", Config.NotifyMods, function(v) Config.NotifyMods = v end)
uiRegistry["MinGroupRank"] = addSlider(gbDetectors, "Minimum group rank", 1, 255, Config.MinGroupRank, "%d/%d", function(v) Config.MinGroupRank = v end)
uiRegistry["ModUsernames"] = addTextbox(gbDetectors, "Moderator usernames", Config.ModUsernames, "name1, name2", function(v) Config.ModUsernames = v end)
uiRegistry["ModFriendList"] = addTextbox(gbDetectors, "Moderator friend list", Config.ModFriendList, "name1, name2", function(v) Config.ModFriendList = v end)

local gbPickups = createGroupbox(autoRight, "Pickups & Tripmines")
uiRegistry["AutoPickup"] = addCheckbox(gbPickups, "Auto pickup nearby drops", Config.AutoPickup, function(v) Config.AutoPickup = v end)
uiRegistry["PickupRadius"] = addSlider(gbPickups, "Pickup radius", 10, 60, Config.PickupRadius, "%d studs/%d studs", function(v) Config.PickupRadius = v end)

local pageAim = tabPages["aim"]
local aimLeft = pageAim:FindFirstChild("LeftCol")
local aimRight = pageAim:FindFirstChild("RightCol")

local gbAimbot = createGroupbox(aimLeft, "Aimbot")
uiRegistry["Aimbot"] = addCheckbox(gbAimbot, "Enable aimbot", Config.Aimbot, function(v) Config.Aimbot = v end)
uiRegistry["AimbotTeamCheck"] = addCheckbox(gbAimbot, "Team check", Config.TeamCheck, function(v) updateTeamCheck(v) end)
uiRegistry["ContinuousTargeting"] = addCheckbox(gbAimbot, "Continuous targeting", Config.ContinuousTargeting, function(v) Config.ContinuousTargeting = v end)
uiRegistry["AimbotKeyMode"] = addDropdown(gbAimbot, "Key mode", {"Hold", "Toggle", "Always"}, 1, function(v) Config.AimbotKeyMode = v end)
uiRegistry["AimbotScopeOnly"] = addCheckbox(gbAimbot, "Scope only", Config.AimbotScopeOnly, function(v) Config.AimbotScopeOnly = v end)
uiRegistry["AimbotDisableReloading"] = addCheckbox(gbAimbot, "Disable while reloading", Config.AimbotDisableReloading, function(v) Config.AimbotDisableReloading = v end)
uiRegistry["AimbotSmoothing"] = addSlider(gbAimbot, "Smoothing speed", 0.05, 1, Config.AimbotSmoothing, "%.2f", function(v) Config.AimbotSmoothing = v end)
uiRegistry["InstantCameraLock"] = addCheckbox(gbAimbot, "Instant camera lock", Config.InstantCameraLock, function(v) Config.InstantCameraLock = v end)
uiRegistry["TrackThroughWalls"] = addCheckbox(gbAimbot, "Track lock through walls", Config.TrackThroughWalls, function(v) Config.TrackThroughWalls = v end)
uiRegistry["AimbotPart"] = addDropdown(gbAimbot, "Persistent lock part", {"Head", "Body", "Closest"}, 1, function(v) Config.AimbotPart = v end)
uiRegistry["CorrectLockedShots"] = addCheckbox(gbAimbot, "Correct locked shots", Config.CorrectLockedShots, function(v) Config.CorrectLockedShots = v end)

local gbSilent = createGroupbox(aimRight, "Silent Aim", "Redirects valid gun shots inside the FOV without moving your camera.")
uiRegistry["SilentAim"] = addCheckbox(gbSilent, "Enable silent aim", Config.SilentAim, function(v) Config.SilentAim = v end)
uiRegistry["SilentTeamCheck"] = addCheckbox(gbSilent, "Team check", Config.TeamCheck, function(v) updateTeamCheck(v) end)
uiRegistry["SilentKeyMode"] = addDropdown(gbSilent, "Key mode", {"Always", "Hold", "Toggle"}, 1, function(v) Config.SilentKeyMode = v end)
uiRegistry["SilentVisibleOnly"] = addCheckbox(gbSilent, "Visible targets only", Config.SilentVisibleOnly, function(v) Config.SilentVisibleOnly = v end)
uiRegistry["SilentVulnerableOnly"] = addCheckbox(gbSilent, "Vulnerable targets only", Config.SilentVulnerableOnly, function(v) Config.SilentVulnerableOnly = v end)
uiRegistry["SilentIgnoreDeflecting"] = addCheckbox(gbSilent, "Ignore deflecting", Config.SilentIgnoreDeflecting, function(v) Config.SilentIgnoreDeflecting = v end)
uiRegistry["SilentIgnoreShielded"] = addCheckbox(gbSilent, "Ignore shielded", Config.SilentIgnoreShielded, function(v) Config.SilentIgnoreShielded = v end)
uiRegistry["SilentTargetPart"] = addDropdown(gbSilent, "Target part", {"Head", "Body", "Closest"}, 1, function(v) Config.SilentTargetPart = v end)
uiRegistry["SilentHeadChance"] = addSlider(gbSilent, "Random head percentage", 0, 100, Config.SilentHeadChance, "%d%%", function(v) Config.SilentHeadChance = v end)
uiRegistry["SilentHitChance"] = addSlider(gbSilent, "Hit chance", 0, 100, Config.SilentHitChance, "%d%%", function(v) Config.SilentHitChance = v end)
uiRegistry["SilentFOV"] = addSlider(gbSilent, "FOV Radius", 30, 400, Config.SilentFOV, "%d px", function(v) Config.SilentFOV = v end)

local pageEsp = tabPages["esp"]
local espLeft = pageEsp:FindFirstChild("LeftCol")
local espRight = pageEsp:FindFirstChild("RightCol")

local gbEspMain = createGroupbox(espLeft, "Player ESP")
uiRegistry["ESP_Master"] = addCheckbox(gbEspMain, "Enable ESP", Config.ESP_Master, function(v) Config.ESP_Master = v end)
uiRegistry["ESP_EnemyOnly"] = addCheckbox(gbEspMain, "Enemy only", Config.ESP_EnemyOnly, function(v) Config.ESP_EnemyOnly = v end)
uiRegistry["ESP_Lobby"] = addCheckbox(gbEspMain, "Show in lobby", Config.ESP_Lobby, function(v) Config.ESP_Lobby = v end)
uiRegistry["ESP_MaxDistance"] = addSlider(gbEspMain, "Max distance", 100, 1000, Config.ESP_MaxDistance, "%d studs", function(v) Config.ESP_MaxDistance = v end)
uiRegistry["ESP_Boxes"] = addCheckbox(gbEspMain, "Box ESP", Config.ESP_Boxes, function(v) Config.ESP_Boxes = v end)
uiRegistry["ESP_Names"] = addCheckbox(gbEspMain, "Name ESP", Config.ESP_Names, function(v) Config.ESP_Names = v end)
uiRegistry["ESP_HealthBar"] = addCheckbox(gbEspMain, "Health bar", Config.ESP_HealthBar, function(v) Config.ESP_HealthBar = v end)
uiRegistry["ESP_Distance"] = addCheckbox(gbEspMain, "Distance ESP", Config.ESP_Distance, function(v) Config.ESP_Distance = v end)
uiRegistry["ESP_Weapon"] = addCheckbox(gbEspMain, "Weapon ESP", Config.ESP_Weapon, function(v) Config.ESP_Weapon = v end)

local gbEspExtra = createGroupbox(espRight, "Render & Chams")
uiRegistry["ESP_Chams"] = addCheckbox(gbEspExtra, "Chams / Highlight", Config.ESP_Chams, function(v) Config.ESP_Chams = v end)
uiRegistry["ESP_HeadDot"] = addCheckbox(gbEspExtra, "Head dot", Config.ESP_HeadDot, function(v) Config.ESP_HeadDot = v end)
uiRegistry["ESP_Tracers"] = addCheckbox(gbEspExtra, "Tracers", Config.ESP_Tracers, function(v) Config.ESP_Tracers = v end)
uiRegistry["ESP_Skeleton"] = addCheckbox(gbEspExtra, "Skeleton ESP", Config.ESP_Skeleton, function(v) Config.ESP_Skeleton = v end)
uiRegistry["ESP_Tripmines"] = addCheckbox(gbEspExtra, "Tripmines ESP", Config.ESP_Tripmines, function(v) Config.ESP_Tripmines = v end)
uiRegistry["ESP_FOV"] = addCheckbox(gbEspExtra, "Draw FOV Circle", Config.ESP_FOV, function(v) Config.ESP_FOV = v end)

local gbTargetVis = createGroupbox(espRight, "Target Visualizer", "Renders an animated ground path and\nlive HUD card for active target.")
uiRegistry["TargetVisualizer"] = addCheckbox(gbTargetVis, "Enable target visualizer", Config.TargetVisualizer, function(v) Config.TargetVisualizer = v end)
uiRegistry["TargetVisualizerHUD"] = addCheckbox(gbTargetVis, "Target HUD card", Config.TargetVisualizerHUD, function(v) Config.TargetVisualizerHUD = v end)
uiRegistry["TargetVisualizerPath"] = addCheckbox(gbTargetVis, "Ground path & arrows", Config.TargetVisualizerPath, function(v) Config.TargetVisualizerPath = v end)
uiRegistry["VisualizerArrowSpacing"] = addSlider(gbTargetVis, "Arrow spacing", 5, 25, Config.VisualizerArrowSpacing, "%d studs", function(v) Config.VisualizerArrowSpacing = v end)
uiRegistry["VisualizerArrowSpeed"] = addSlider(gbTargetVis, "Arrow speed", 5, 30, Config.VisualizerArrowSpeed, "%d spd", function(v) Config.VisualizerArrowSpeed = v end)

local pageMove = tabPages["move"]
local moveLeft = pageMove:FindFirstChild("LeftCol")
local moveRight = pageMove:FindFirstChild("RightCol")

local gbMovement = createGroupbox(moveLeft, "Ground Movement")
uiRegistry["SpeedHack"] = addCheckbox(gbMovement, "Speed hack", Config.SpeedHack, function(v) Config.SpeedHack = v end)
uiRegistry["SpeedValue"] = addSlider(gbMovement, "WalkSpeed", 16, 120, Config.SpeedValue, "%d ws", function(v) Config.SpeedValue = v end)
uiRegistry["InfiniteJump"] = addCheckbox(gbMovement, "Infinite jump", Config.InfiniteJump, function(v) Config.InfiniteJump = v end)
uiRegistry["BunnyHop"] = addCheckbox(gbMovement, "Bunny hop", Config.BunnyHop, function(v) Config.BunnyHop = v end)

local gbAirMovement = createGroupbox(moveRight, "Flight & Collision")
uiRegistry["FlyHack"] = addCheckbox(gbAirMovement, "Fly hack", Config.FlyHack, function(v) Config.FlyHack = v end)
uiRegistry["FlySpeed"] = addSlider(gbAirMovement, "Fly speed", 20, 150, Config.FlySpeed, "%d spd", function(v) Config.FlySpeed = v end)
uiRegistry["Noclip"] = addCheckbox(gbAirMovement, "Noclip", Config.Noclip, function(v) Config.Noclip = v end)

local pageGuns = tabPages["guns"]
local gunsLeft = pageGuns:FindFirstChild("LeftCol")
local gunsRight = pageGuns:FindFirstChild("RightCol")

local gbGunMods = createGroupbox(gunsLeft, "Weapon Mechanics")
uiRegistry["NoRecoil"] = addCheckbox(gbGunMods, "No recoil", Config.NoRecoil, function(v)
    Config.NoRecoil = v
    ApplyWeaponModifications()
end)
uiRegistry["NoSpread"] = addCheckbox(gbGunMods, "No spread", Config.NoSpread, function(v)
    Config.NoSpread = v
    ApplyWeaponModifications()
end)
uiRegistry["FastReload"] = addCheckbox(gbGunMods, "Fast reload", Config.FastReload, function(v)
    Config.FastReload = v
    ApplyWeaponModifications()
end)
uiRegistry["RapidFire"] = addCheckbox(gbGunMods, "Rapid fire", Config.RapidFire, function(v)
    Config.RapidFire = v
    ApplyWeaponModifications()
end)
uiRegistry["InstantEquip"] = addCheckbox(gbGunMods, "Instant weapon equip", Config.InstantEquip, function(v)
    Config.InstantEquip = v
    ApplyWeaponModifications()
end)

local gbGunExtras = createGroupbox(gunsRight, "Weapon Features")
uiRegistry["AutomaticGuns"] = addCheckbox(gbGunExtras, "Automatic mode", Config.AutomaticGuns, function(v) Config.AutomaticGuns = v end)
uiRegistry["InfiniteAmmo"] = addCheckbox(gbGunExtras, "Infinite ammo", Config.InfiniteAmmo, function(v)
    Config.InfiniteAmmo = v
    ApplyWeaponModifications()
end)

local noteGunLbl = Instance.new("TextLabel")
noteGunLbl.Size = UDim2.new(1, 0, 0, 32)
noteGunLbl.BackgroundTransparency = 1
noteGunLbl.Font = MainFont
noteGunLbl.Text = "Note: Fast reload, automatic mode, & infinite ammo are client-sided and may be clamped by server authority in ranked matches."
noteGunLbl.TextColor3 = Theme.TextMuted
noteGunLbl.TextSize = 10
noteGunLbl.TextWrapped = true
noteGunLbl.TextXAlignment = Enum.TextXAlignment.Left
noteGunLbl.ZIndex = 17
noteGunLbl.Parent = gbGunExtras

local pageSkins = tabPages["skins"]
local skinsLeft = pageSkins:FindFirstChild("LeftCol")
local skinsRight = pageSkins:FindFirstChild("RightCol")

local gbSkins = createGroupbox(skinsLeft, "Weapon Customizer")
uiRegistry["UnlockAllSkins"] = addCheckbox(gbSkins, "Unlock all skins (Client)", Config.UnlockAllSkins, function(v)
    Config.UnlockAllSkins = v
    if v then
        UnlockAllCosmeticsClientSide()
        ShowNotification("ReefHub", "All 1,249 skins & cosmetics unlocked client-side.", "SUCCESS", 3)
    end
end)

uiRegistry["SelectedCategory"] = addDropdown(gbSkins, "Category", {"Primary", "Secondary", "Melee", "Utility"}, 1, function(v)
    Config.SelectedCategory = v
end)

uiRegistry["SelectedWeapon"] = addDropdown(gbSkins, "Weapon", {
    "Assault Rifle", "Sniper", "Shotgun", "Katana", "Revolver", "RPG",
    "Submachine Gun", "Hand Gun", "Minigun", "Grenade Launcher", "Energy Rifle", "Bow"
}, 1, function(v)
    Config.SelectedWeapon = v
end)

uiRegistry["SelectedWrap"] = addDropdown(gbSkins, "Equipped Wrap", {
    "Liquid Gold", "Mainframe", "Obsidian", "Scribble", "Vexed", "Igneous",
    "Candy Apple", "Red Rubber", "Tidal", "Purple", "Popsicle", "Lighthouse",
    "Celtic", "Empress", "PixelBlight", "Sunset", "Money", "Portal", "Venom", "Default"
}, 1, function(v)
    Config.SelectedWrap = v
end)

uiRegistry["SelectedCharm"] = addDropdown(gbSkins, "Equipped Charm", {
    "Dice", "Kashy", "Jolly Hat", "Devious Pumpkin", "Chibi Grenade",
    "Lucky Horseshoe", "Bat Daggers", "Pirate Hook", "Mini Present", "None"
}, 1, function(v)
    Config.SelectedCharm = v
end)

uiRegistry["SelectedFinisher"] = addDropdown(gbSkins, "Equipped Finisher", {
    "Flop", "Rising Star", "Gingerbreadify", "Warp Sickness", "Freeze",
    "Batsplosion", "Northern Light Show", "Supernova", "Orbital Strike", "Disintegrate", "None"
}, 1, function(v)
    Config.SelectedFinisher = v
end)

addButton(gbSkins, "Apply Skin to Weapon", function()
    UnlockAllCosmeticsClientSide()
    ApplySelectedCosmeticsClientSide(Config.SelectedWeapon, Config.SelectedWrap, Config.SelectedCharm, Config.SelectedFinisher)
    ShowNotification("ReefHub", "Equipped " .. tostring(Config.SelectedWrap) .. " on " .. tostring(Config.SelectedWeapon), "SUCCESS", 2.5)
end)

addButton(gbSkins, "Apply Skin to ALL Weapons", function()
    UnlockAllCosmeticsClientSide()
    ApplySelectedCosmeticsClientSide("All", Config.SelectedWrap, Config.SelectedCharm, Config.SelectedFinisher)
    ShowNotification("ReefHub", "Equipped " .. tostring(Config.SelectedWrap) .. " on ALL weapons!", "SUCCESS", 2.5)
end)

local gbViewModel = createGroupbox(skinsRight, "Viewmodel & Render")
uiRegistry["RainbowGunSkin"] = addCheckbox(gbViewModel, "Rainbow gun skin", Config.RainbowGunSkin, function(v) Config.RainbowGunSkin = v end)
uiRegistry["WeaponChams"] = addCheckbox(gbViewModel, "Weapon chams & glow", Config.WeaponChams, function(v) Config.WeaponChams = v end)
uiRegistry["CustomViewModelFOV"] = addCheckbox(gbViewModel, "Custom Viewmodel FOV", Config.CustomViewModelFOV, function(v) Config.CustomViewModelFOV = v end)
uiRegistry["ViewModelFOVValue"] = addSlider(gbViewModel, "Viewmodel FOV", 50, 110, Config.ViewModelFOVValue, "%d°", function(v) Config.ViewModelFOVValue = v end)
uiRegistry["ViewModelXOffset"] = addSlider(gbViewModel, "Viewmodel X offset", -30, 30, Config.ViewModelXOffset, "%d/30", function(v) Config.ViewModelXOffset = v end)
uiRegistry["ViewModelYOffset"] = addSlider(gbViewModel, "Viewmodel Y offset", -30, 30, Config.ViewModelYOffset, "%d/30", function(v) Config.ViewModelYOffset = v end)
uiRegistry["ViewModelZOffset"] = addSlider(gbViewModel, "Viewmodel Z offset", -30, 30, Config.ViewModelZOffset, "%d/30", function(v) Config.ViewModelZOffset = v end)
uiRegistry["HideViewModel"] = addCheckbox(gbViewModel, "Hide viewmodel", Config.HideViewModel, function(v) Config.HideViewModel = v end)

local pageWorld = tabPages["world"]
local worldLeft = pageWorld:FindFirstChild("LeftCol")
local worldRight = pageWorld:FindFirstChild("RightCol")

local gbWorldMods = createGroupbox(worldLeft, "World & Visuals")
uiRegistry["Fullbright"] = addCheckbox(gbWorldMods, "Fullbright", Config.Fullbright, function(v)
    Config.Fullbright = v
    if v then
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.GlobalShadows = false
        Lighting.OutdoorAmbient = Color3.fromRGB(150, 150, 150)
    else
        Lighting.Brightness = 1
        Lighting.GlobalShadows = true
    end
end)
uiRegistry["NoFog"] = addCheckbox(gbWorldMods, "No fog", Config.NoFog, function(v)
    Config.NoFog = v
    if v then
        Lighting.FogEnd = 1000000
    else
        Lighting.FogEnd = 1000
    end
end)
uiRegistry["CustomFOV"] = addCheckbox(gbWorldMods, "Custom FOV", Config.CustomFOV, function(v)
    Config.CustomFOV = v
    if v then Camera.FieldOfView = Config.FOVValue end
end)
uiRegistry["FOVValue"] = addSlider(gbWorldMods, "FOV Angle", 70, 120, Config.FOVValue, "%d°", function(v)
    Config.FOVValue = v
    if Config.CustomFOV then Camera.FieldOfView = v end
end)

local gbWorldAudio = createGroupbox(worldRight, "Effects & Sounds")
uiRegistry["BulletTracers"] = addCheckbox(gbWorldAudio, "Bullet tracers", Config.BulletTracers, function(v) Config.BulletTracers = v end)
uiRegistry["HitSound"] = addDropdown(gbWorldAudio, "Hit sound", {"Skeet", "Rust", "Ding"}, 1, function(v) Config.HitSound = v end)

local pageView = tabPages["view"]
local viewLeft = pageView:FindFirstChild("LeftCol")
local viewRight = pageView:FindFirstChild("RightCol")

local gbView = createGroupbox(viewLeft, "Third-Person")
uiRegistry["ThirdPerson"] = addCheckbox(gbView, "Third-person mode", Config.ThirdPerson, function(v)
    Config.ThirdPerson = v
end)
uiRegistry["ThirdPersonDist"] = addSlider(gbView, "Third-person distance", 5, 30, Config.ThirdPersonDist, "%d studs", function(v) Config.ThirdPersonDist = v end)

local gbFreecam = createGroupbox(viewRight, "Freecam")
uiRegistry["Freecam"] = addCheckbox(gbFreecam, "Freecam mode", Config.Freecam, function(v) Config.Freecam = v end)
uiRegistry["FreecamSpeed"] = addSlider(gbFreecam, "Freecam speed", 10, 100, Config.FreecamSpeed, "%d spd", function(v) Config.FreecamSpeed = v end)

local function SerializeConfig()
    local tbl = {}
    for k, v in pairs(Config) do
        if typeof(v) == "EnumItem" then
            tbl[k] = { __type = "EnumItem", enumType = tostring(v.EnumType), name = v.Name }
        elseif typeof(v) == "Color3" then
            tbl[k] = { __type = "Color3", r = v.R, g = v.G, b = v.B }
        elseif typeof(v) == "Vector3" then
            tbl[k] = { __type = "Vector3", x = v.X, y = v.Y, z = v.Z }
        else
            tbl[k] = v
        end
    end
    return tbl
end

local function DeserializeConfig(data)
    local res = {}
    for k, v in pairs(data) do
        if type(v) == "table" and v.__type == "EnumItem" then
            local grp = Enum[v.enumType]
            if grp and grp[v.name] then
                res[k] = grp[v.name]
            end
        elseif type(v) == "table" and v.__type == "Color3" then
            res[k] = Color3.new(v.r, v.g, v.b)
        elseif type(v) == "table" and v.__type == "Vector3" then
            res[k] = Vector3.new(v.x, v.y, v.z)
        else
            res[k] = v
        end
    end
    return res
end

local ProfileSystem = {
    current = "default",
    autoload = "default",
    names = { "default", "rage" },
    profiles = {},
    nameInput = nil,
    dropdown = nil,
    autoLoadLabel = nil,
    defaultProfiles = {
        ["default"] = {
            Aimbot = false,
            TeamCheck = true,
            AimbotDisableReloading = true,
            AimbotFOV = 120,
            AimbotKey = Enum.UserInputType.MouseButton2,
            AimbotKeyMode = "Hold",
            AimbotPart = "Closest",
            AimbotScopeOnly = false,
            AimbotSmoothing = 0.28,
            AimbotVisibleOnly = true,
            AntiAim = false,
            AntiAimMode = "Jitter",
            AntiAimSpeed = 10,
            AutoBanWeapons = false,
            AutoLoadout = true,
            AutoPickup = false,
            AutoQueue = false,
            AutoRespawn = false,
            AutoVoteMaps = false,
            AutomaticGuns = false,
            Autoplay = false,
            AutoplayDistance = 18,
            BulletTracers = false,
            BunnyHop = false,
            CorrectLockedShots = true,
            ContinuousTargeting = true,
            CustomFOV = false,
            CustomViewModelFOV = false,
            ESP_Boxes = true,
            ESP_Chams = false,
            ESP_Distance = true,
            ESP_EnemyOnly = true,
            ESP_FOV = true,
            ESP_HeadDot = true,
            ESP_HealthBar = true,
            ESP_Lobby = true,
            ESP_Master = true,
            ESP_MaxDistance = 500,
            ESP_Names = true,
            ESP_Skeleton = true,
            ESP_Tracers = false,
            ESP_Tripmines = true,
            ESP_Weapon = true,
            EnabledMaps = "Arena, Crossroads",
            FastReload = false,
            FlyHack = false,
            FlySpeed = 50,
            FOVValue = 90,
            Freecam = false,
            FreecamSpeed = 40,
            Fullbright = false,
            HackerAutoLoad = true,
            HackerDetector = true,
            HackerProfile = "rage",
            HideViewModel = false,
            HitSound = "Skeet",
            InfiniteAmmo = false,
            InfiniteJump = false,
            InstantCameraLock = false,
            InstantEquip = false,
            LoadoutOnlySelected = false,
            MapPriority = "Arena, Onyx, Crossroads",
            MenuKey = Enum.KeyCode.RightControl,
            MinGroupRank = 200,
            ModDetector = true,
            ModFriendList = "name1, name2",
            ModUsernames = "name1, name2",
            NoFog = true,
            NoRecoil = true,
            NoSpread = true,
            Noclip = false,
            NotifyHackers = true,
            NotifyMods = true,
            PickupRadius = 25,
            QueueMode = "1v1",
            Ragebot = false,
            RagebotAutoShoot = false,
            RagebotTargetPriority = "Distance",
            RagebotTargetStrafe = false,
            RagebotWallbang = true,
            RainbowGunSkin = false,
            RapidFire = false,
            SecondBanPriority = "Grenade Launcher, Minigun, RPG",
            SelectedCategory = "Primary",
            SelectedCharm = "Dice",
            SelectedFinisher = "Gingerbreadify",
            SelectedWeapon = "Assault Rifle",
            SelectedWrap = "Liquid Gold",
            SilentAim = true,
            SilentFOV = 242,
            SilentHeadChance = 59,
            SilentHitChance = 78,
            SilentIgnoreDeflecting = true,
            SilentIgnoreShielded = true,
            SilentKey = Enum.KeyCode.C,
            SilentKeyMode = "Always",
            SilentTargetPart = "Head",
            SilentVisibleOnly = true,
            SilentVulnerableOnly = true,
            SpeedDuration = 0.75,
            SpeedHack = false,
            SpeedThreshold = 180,
            SpeedValue = 49,
            TargetStrafeRadius = 14,
            TargetStrafeSpeed = 6,
            TargetVisualizer = true,
            TargetVisualizerHUD = true,
            TargetVisualizerPath = true,
            ThirdPerson = false,
            ThirdPersonDist = 12,
            TrackThroughWalls = true,
            UnlockAllSkins = false,
            ViewModelFOVValue = 70,
            ViewModelXOffset = 0,
            ViewModelYOffset = 0,
            ViewModelZOffset = 0,
            VisualizerArrowSpacing = 10,
            VisualizerArrowSpeed = 14,
            WeaponBanPriority = "Grenade Launcher, Minigun, RPG",
            WeaponChams = false,
        },
        ["rage"] = {
            Aimbot = false,
            TeamCheck = true,
            AimbotDisableReloading = true,
            AimbotFOV = 120,
            AimbotKey = Enum.UserInputType.MouseButton2,
            AimbotKeyMode = "Hold",
            AimbotPart = "Closest",
            AimbotScopeOnly = false,
            AimbotSmoothing = 0.28,
            AimbotVisibleOnly = true,
            AntiAim = false,
            AntiAimMode = "Jitter",
            AntiAimSpeed = 10,
            AutoBanWeapons = false,
            AutoLoadout = false,
            AutoPickup = false,
            AutoQueue = false,
            AutoRespawn = false,
            AutoVoteMaps = false,
            AutomaticGuns = false,
            Autoplay = true,
            AutoplayDistance = 18,
            BulletTracers = true,
            BunnyHop = true,
            CorrectLockedShots = true,
            ContinuousTargeting = true,
            CustomFOV = false,
            CustomViewModelFOV = false,
            ESP_Boxes = true,
            ESP_Chams = true,
            ESP_Distance = true,
            ESP_EnemyOnly = true,
            ESP_FOV = true,
            ESP_HeadDot = true,
            ESP_HealthBar = true,
            ESP_Lobby = true,
            ESP_Master = true,
            ESP_MaxDistance = 500,
            ESP_Names = true,
            ESP_Skeleton = true,
            ESP_Tracers = false,
            ESP_Tripmines = true,
            ESP_Weapon = true,
            EnabledMaps = "Arena, Crossroads",
            FastReload = false,
            FlyHack = false,
            FlySpeed = 50,
            FOVValue = 90,
            Freecam = false,
            FreecamSpeed = 40,
            Fullbright = false,
            HackerAutoLoad = true,
            HackerDetector = true,
            HackerProfile = "rage",
            HideViewModel = false,
            HitSound = "Skeet",
            InfiniteAmmo = false,
            InfiniteJump = false,
            InstantCameraLock = false,
            InstantEquip = false,
            LoadoutOnlySelected = false,
            MapPriority = "Arena, Onyx, Crossroads",
            MenuKey = Enum.KeyCode.RightControl,
            MinGroupRank = 200,
            ModDetector = true,
            ModFriendList = "name1, name2",
            ModUsernames = "name1, name2",
            NoFog = true,
            NoRecoil = true,
            NoSpread = true,
            Noclip = false,
            NotifyHackers = true,
            NotifyMods = true,
            PickupRadius = 25,
            QueueMode = "1v1",
            Ragebot = true,
            RagebotAutoShoot = true,
            RagebotTargetPriority = "Distance",
            RagebotTargetStrafe = true,
            RagebotWallbang = true,
            RainbowGunSkin = false,
            RapidFire = false,
            SecondBanPriority = "Grenade Launcher, Minigun, RPG",
            SelectedCategory = "Primary",
            SelectedCharm = "Dice",
            SelectedFinisher = "Gingerbreadify",
            SelectedWeapon = "Assault Rifle",
            SelectedWrap = "Liquid Gold",
            SilentAim = true,
            SilentFOV = 400,
            SilentHeadChance = 100,
            SilentHitChance = 100,
            SilentIgnoreDeflecting = true,
            SilentIgnoreShielded = true,
            SilentKey = Enum.KeyCode.C,
            SilentKeyMode = "Always",
            SilentTargetPart = "Head",
            SilentVisibleOnly = true,
            SilentVulnerableOnly = true,
            SpeedDuration = 0.75,
            SpeedHack = true,
            SpeedThreshold = 180,
            SpeedValue = 49,
            TargetStrafeRadius = 14,
            TargetStrafeSpeed = 6,
            TargetVisualizer = true,
            TargetVisualizerHUD = true,
            TargetVisualizerPath = true,
            ThirdPerson = false,
            ThirdPersonDist = 12,
            TrackThroughWalls = true,
            UnlockAllSkins = false,
            ViewModelFOVValue = 70,
            ViewModelXOffset = 0,
            ViewModelYOffset = 0,
            ViewModelZOffset = 0,
            VisualizerArrowSpacing = 10,
            VisualizerArrowSpeed = 14,
            WeaponBanPriority = "Grenade Launcher, Minigun, RPG",
            WeaponChams = false,
        }
    }
}

function ProfileSystem.readStore()
    local ok, res = pcall(function()
        if readfile and isfile and isfile("reefhub_config.json") then
            local raw = readfile("reefhub_config.json")
            return HttpService:JSONDecode(raw)
        end
        return nil
    end)
    if ok and type(res) == "table" then
        if type(res.profiles) == "table" then
            ProfileSystem.profiles = res.profiles
            ProfileSystem.autoload = tostring(res.autoload or "default")
        else
            ProfileSystem.profiles = { ["default"] = res }
            ProfileSystem.autoload = "default"
        end
    else
        ProfileSystem.profiles = {}
        ProfileSystem.autoload = "default"
    end

    for pName, pData in pairs(ProfileSystem.defaultProfiles) do
        if not ProfileSystem.profiles[pName] then
            local copy = {}
            for k, v in pairs(pData) do copy[k] = v end
            ProfileSystem.profiles[pName] = copy
        end
    end

    local list = {}
    for name, _ in pairs(ProfileSystem.profiles) do
        table.insert(list, tostring(name))
    end
    table.sort(list)
    if #list == 0 then
        list = { "default", "rage" }
    end
    ProfileSystem.names = list

    local found = false
    for _, name in ipairs(ProfileSystem.names) do
        if name == ProfileSystem.autoload then
            found = true
            break
        end
    end
    if not found then
        ProfileSystem.autoload = "default"
    end
    ProfileSystem.current = ProfileSystem.autoload

    if not (isfile and isfile("reefhub_config.json")) then
        ProfileSystem.writeStore()
    end
end

function ProfileSystem.writeStore()
    if not writefile then return false end
    local store = {
        autoload = ProfileSystem.autoload or "default",
        profiles = ProfileSystem.profiles
    }
    local ok = pcall(function()
        local json = HttpService:JSONEncode(store)
        writefile("reefhub_config.json", json)
    end)
    return ok
end

function ProfileSystem.applyProfile(pName, notify)
    pName = tostring(pName or ProfileSystem.current or "default")
    local data = ProfileSystem.profiles[pName]
    if not data then
        if notify then
            ShowNotification("ReefHub", "Profile not found: " .. pName, "WARN", 2.5)
        end
        return false
    end

    local res = DeserializeConfig(data)
    for k, v in pairs(res) do
        Config[k] = v
        if uiRegistry[k] and uiRegistry[k].Set then
            pcall(function() uiRegistry[k].Set(v) end)
        end
    end
    ApplyWeaponModifications()
    if Config.UnlockAllSkins then UnlockAllCosmeticsClientSide() end

    ProfileSystem.current = pName
    if ProfileSystem.nameInput and ProfileSystem.nameInput.Set then
        ProfileSystem.nameInput.Set(pName)
    end
    if ProfileSystem.dropdown and ProfileSystem.dropdown.Set then
        ProfileSystem.dropdown.Set(pName)
    end
    if notify then
        ShowNotification("ReefHub", "Loaded profile: " .. pName, "SUCCESS", 2.5)
    end
    return true
end

function ProfileSystem.saveProfile(pName)
    local rawName = pName or (ProfileSystem.nameInput and ProfileSystem.nameInput.Get and ProfileSystem.nameInput.Get())
    if not rawName or rawName:gsub("%s+", "") == "" then
        rawName = ProfileSystem.current or "default"
    end
    local cleanName = rawName:match("^%s*(.-)%s*$")
    ProfileSystem.profiles[cleanName] = SerializeConfig()
    ProfileSystem.current = cleanName

    local list = {}
    for name, _ in pairs(ProfileSystem.profiles) do
        table.insert(list, tostring(name))
    end
    table.sort(list)
    ProfileSystem.names = list

    ProfileSystem.writeStore()
    if ProfileSystem.dropdown and ProfileSystem.dropdown.SetOptions then
        ProfileSystem.dropdown.SetOptions(ProfileSystem.names, cleanName)
    end
    if ProfileSystem.nameInput and ProfileSystem.nameInput.Set then
        ProfileSystem.nameInput.Set(cleanName)
    end
    ShowNotification("ReefHub", "Saved profile: " .. cleanName, "SUCCESS", 2.5)
end

function ProfileSystem.setAutoload(pName)
    local target = pName or ProfileSystem.current or "default"
    if not ProfileSystem.profiles[target] then
        ProfileSystem.profiles[target] = SerializeConfig()
    end
    ProfileSystem.autoload = target
    ProfileSystem.writeStore()
    if ProfileSystem.autoLoadLabel then
        ProfileSystem.autoLoadLabel.Text = "Auto-load on start: " .. target
    end
    ShowNotification("ReefHub", "Auto-load set to: " .. target, "SUCCESS", 2.5)
end

function ProfileSystem.deleteProfile(pName)
    local target = pName or ProfileSystem.current
    if #ProfileSystem.names <= 1 then
        ShowNotification("ReefHub", "Cannot delete only remaining profile.", "WARN", 2.5)
        return
    end

    ProfileSystem.profiles[target] = nil
    local list = {}
    for name, _ in pairs(ProfileSystem.profiles) do
        table.insert(list, tostring(name))
    end
    table.sort(list)
    ProfileSystem.names = list

    if ProfileSystem.autoload == target then
        ProfileSystem.autoload = ProfileSystem.names[1]
    end
    ProfileSystem.current = ProfileSystem.names[1]

    ProfileSystem.writeStore()
    if ProfileSystem.dropdown and ProfileSystem.dropdown.SetOptions then
        ProfileSystem.dropdown.SetOptions(ProfileSystem.names, ProfileSystem.current)
    end
    if ProfileSystem.nameInput and ProfileSystem.nameInput.Set then
        ProfileSystem.nameInput.Set(ProfileSystem.current)
    end
    if ProfileSystem.autoLoadLabel then
        ProfileSystem.autoLoadLabel.Text = "Auto-load on start: " .. ProfileSystem.autoload
    end
    ProfileSystem.applyProfile(ProfileSystem.current, false)
    ShowNotification("ReefHub", "Deleted profile: " .. target, "INFO", 2.5)
end

ProfileSystem.readStore()

local pageConfig = tabPages["config"]
local cfgLeft = pageConfig:FindFirstChild("LeftCol")
local cfgRight = pageConfig:FindFirstChild("RightCol")

local gbConfig = createGroupbox(cfgLeft, "Profiles")

ProfileSystem.nameInput = addTextbox(gbConfig, "Profile name", ProfileSystem.current, "Profile name...", function(txt)
    ProfileSystem.current = txt
end)

ProfileSystem.dropdown = addDropdown(gbConfig, "Select profile", ProfileSystem.names, 1, function(selected)
    ProfileSystem.current = selected
    if ProfileSystem.nameInput and ProfileSystem.nameInput.Set then
        ProfileSystem.nameInput.Set(selected)
    end
end)

addButton(gbConfig, "Save profile", function()
    ProfileSystem.saveProfile()
end)

addButton(gbConfig, "Load profile", function()
    ProfileSystem.applyProfile(ProfileSystem.current, true)
end)

addButton(gbConfig, "Set as auto-load", function()
    ProfileSystem.setAutoload(ProfileSystem.current)
end)

addButton(gbConfig, "Delete profile", function()
    ProfileSystem.deleteProfile(ProfileSystem.current)
end)

ProfileSystem.autoLoadLabel = Instance.new("TextLabel")
ProfileSystem.autoLoadLabel.Size = UDim2.new(1, 0, 0, 16)
ProfileSystem.autoLoadLabel.BackgroundTransparency = 1
ProfileSystem.autoLoadLabel.Font = MainFont
ProfileSystem.autoLoadLabel.Text = "Auto-load on start: " .. ProfileSystem.autoload
ProfileSystem.autoLoadLabel.TextColor3 = Theme.AccentPinkLight
ProfileSystem.autoLoadLabel.TextSize = 11.5
ProfileSystem.autoLoadLabel.TextXAlignment = Enum.TextXAlignment.Left
ProfileSystem.autoLoadLabel.ZIndex = 17
ProfileSystem.autoLoadLabel.Parent = gbConfig

addButton(gbConfig, "Unload script", UnloadScript)

local gbShortcuts = createGroupbox(cfgRight, "Keybinds & Info")
local kbMenu = Instance.new("TextLabel")
kbMenu.Size = UDim2.new(1, 0, 0, 16)
kbMenu.BackgroundTransparency = 1
kbMenu.Font = MainFont
kbMenu.Text = "Menu Toggle: RightControl"
kbMenu.TextColor3 = Theme.TextWhite
kbMenu.TextSize = 12
kbMenu.TextXAlignment = Enum.TextXAlignment.Left
kbMenu.ZIndex = 17
kbMenu.Parent = gbShortcuts

uiRegistry["MobileToggle"] = addCheckbox(gbShortcuts, "Mobile toggle button", Config.MobileToggle, function(v)
    Config.MobileToggle = v
    local mBtn = screenGui:FindFirstChild("ParagonMobileToggle")
    if mBtn then mBtn.Visible = v end
end)

pcall(function()
    ProfileSystem.applyProfile(ProfileSystem.autoload, false)
end)

local function setupSearch()
    local searchItems = {}
    for tName, page in pairs(tabPages) do
        for _, colName in ipairs({"LeftCol", "RightCol"}) do
            local col = page:FindFirstChild(colName)
            if col then
                for _, card in ipairs(col:GetChildren()) do
                    if card:IsA("Frame") then
                        local header = card:FindFirstChild("Header")
                        local titleLbl = header and (header:FindFirstChild("TitleLabel") or header:FindFirstChildWhichIsA("TextLabel"))
                        local cardTitle = titleLbl and titleLbl.Text or ""
                        local content = card:FindFirstChild("Content")
                        local controls = {}
                        if content then
                            for _, ctrl in ipairs(content:GetChildren()) do
                                if ctrl:IsA("Frame") or ctrl:IsA("TextButton") then
                                    local lbl = ctrl:FindFirstChildWhichIsA("TextLabel") or (ctrl:IsA("TextButton") and ctrl)
                                    local ctrlName = lbl and lbl.Text or ""
                                    if ctrlName ~= "" then
                                        table.insert(controls, {
                                            element = ctrl,
                                            name = ctrlName
                                        })
                                    end
                                end
                            end
                        end
                        table.insert(searchItems, {
                            tab = tName,
                            page = page,
                            card = card,
                            cardTitle = cardTitle,
                            controls = controls
                        })
                    end
                end
            end
        end
    end

    local searchDropdown = Instance.new("ScrollingFrame")
    searchDropdown.Name = "SearchDropdown"
    searchDropdown.Size = UDim2.new(0, 180, 0, 0)
    searchDropdown.Position = UDim2.new(1, -210, 0, 26)
    searchDropdown.BackgroundColor3 = Theme.CardBg
    searchDropdown.BorderSizePixel = 0
    searchDropdown.ScrollBarThickness = 2
    searchDropdown.ScrollBarImageColor3 = Theme.AccentPink
    searchDropdown.AutomaticCanvasSize = Enum.AutomaticSize.Y
    searchDropdown.ZIndex = 1005
    searchDropdown.Visible = false
    searchDropdown.Parent = dropdownOverlay

    local sdStroke = Instance.new("UIStroke")
    sdStroke.Color = Theme.BorderPink
    sdStroke.Thickness = 1
    sdStroke.Parent = searchDropdown

    local sdLayout = Instance.new("UIListLayout")
    sdLayout.Padding = UDim.new(0, 1)
    sdLayout.Parent = searchDropdown

    local function filterUI(query)
        query = query:lower():match("^%s*(.-)%s*$")
        if not query or query == "" then
            searchDropdown.Visible = false
            for _, item in ipairs(searchItems) do
                item.card.Visible = true
                for _, ctrl in ipairs(item.controls) do
                    ctrl.element.Visible = true
                end
            end
            for _, btnData in ipairs(tabButtons) do
                local isSelf = (btnData.name == currentTab)
                btnData.btn.TextColor3 = isSelf and Theme.AccentPinkLight or Theme.TextMuted
            end
            return
        end

        for _, child in ipairs(searchDropdown:GetChildren()) do
            if child:IsA("TextButton") then child:Destroy() end
        end

        local matchingTabs = {}
        local dropdownMatches = 0

        for _, item in ipairs(searchItems) do
            local cardMatches = item.cardTitle:lower():find(query, 1, true) ~= nil
            local anyCtrlMatch = false

            for _, ctrl in ipairs(item.controls) do
                local cMatch = cardMatches or (ctrl.name:lower():find(query, 1, true) ~= nil)
                ctrl.element.Visible = cMatch
                if cMatch then
                    anyCtrlMatch = true
                    if dropdownMatches < 8 and (ctrl.name:lower():find(query, 1, true) ~= nil) then
                        dropdownMatches = dropdownMatches + 1
                        local btn = Instance.new("TextButton")
                        btn.Size = UDim2.new(1, 0, 0, 22)
                        btn.BackgroundColor3 = Theme.ControlBg
                        btn.BackgroundTransparency = 0.5
                        btn.BorderSizePixel = 0
                        btn.Font = MainFont
                        btn.Text = "  " .. ctrl.name .. "  [" .. item.tab:upper() .. "]"
                        btn.TextColor3 = Theme.TextWhite
                        btn.TextSize = 10.5
                        btn.TextXAlignment = Enum.TextXAlignment.Left
                        btn.ZIndex = 1006
                        btn.Parent = searchDropdown

                        btn.MouseEnter:Connect(function()
                            btn.BackgroundColor3 = Theme.ButtonHoverBg
                            btn.TextColor3 = Theme.AccentPinkLight
                        end)
                        btn.MouseLeave:Connect(function()
                            btn.BackgroundColor3 = Theme.ControlBg
                            btn.TextColor3 = Theme.TextWhite
                        end)
                        btn.MouseButton1Click:Connect(function()
                            switchTab(item.tab)
                            searchDropdown.Visible = false
                        end)
                    end
                end
            end

            item.card.Visible = cardMatches or anyCtrlMatch
            if cardMatches or anyCtrlMatch then
                matchingTabs[item.tab] = true
            end
        end

        for _, btnData in ipairs(tabButtons) do
            if matchingTabs[btnData.name] then
                btnData.btn.TextColor3 = Theme.AccentPinkLight
            else
                btnData.btn.TextColor3 = Color3.fromRGB(60, 60, 65)
            end
        end

        if not matchingTabs[currentTab] then
            for _, tName in ipairs(tabList) do
                if matchingTabs[tName] then
                    switchTab(tName)
                    break
                end
            end
        end

        if dropdownMatches > 0 then
            local boxPos = searchBox.AbsolutePosition
            local boxSize = searchBox.AbsoluteSize
            searchDropdown.Position = UDim2.new(0, boxPos.X - 50, 0, boxPos.Y + boxSize.Y + 3)
            searchDropdown.Size = UDim2.new(0, 210, 0, math.min(dropdownMatches * 23, 140))
            searchDropdown.Visible = true
        else
            searchDropdown.Visible = false
        end
    end

    searchBox:GetPropertyChangedSignal("Text"):Connect(function()
        filterUI(searchBox.Text)
    end)
end

setupSearch()

local cornerGrip = Instance.new("Frame")
cornerGrip.Name = "CornerGrip"
cornerGrip.Size = UDim2.new(0, 14, 0, 14)
cornerGrip.Position = UDim2.new(1, -15, 1, -15)
cornerGrip.BackgroundTransparency = 1
cornerGrip.BorderSizePixel = 0
cornerGrip.ZIndex = 25
cornerGrip.Parent = mainWindow

for i = 1, 14 do
    local slice = Instance.new("Frame")
    slice.Name = "Slice_" .. i
    slice.Size = UDim2.new(0, 1, 0, i)
    slice.Position = UDim2.new(0, i - 1, 1, -i)
    slice.BackgroundColor3 = Theme.AccentGreen
    slice.BorderSizePixel = 0
    slice.ZIndex = 26
    slice.Parent = cornerGrip
end

local fovCircleGui = Instance.new("Frame")
fovCircleGui.Name = "FOVCircle"
fovCircleGui.Size = UDim2.new(0, Config.SilentFOV * 2, 0, Config.SilentFOV * 2)
fovCircleGui.Position = UDim2.new(0.5, -Config.SilentFOV, 0.5, -Config.SilentFOV)
fovCircleGui.BackgroundTransparency = 1
fovCircleGui.Visible = Config.ESP_FOV
fovCircleGui.ZIndex = 1
fovCircleGui.Parent = screenGui
table.insert(cleanUpInstances, fovCircleGui)

Instance.new("UICorner", fovCircleGui).CornerRadius = UDim.new(1, 0)
local fovStroke = Instance.new("UIStroke")
fovStroke.Color = Theme.AccentGreen
fovStroke.Transparency = 0.5
fovStroke.Thickness = 1.2
fovStroke.Parent = fovCircleGui

do
    local mBtn = Instance.new("TextButton")
    mBtn.Name = "ParagonMobileToggle"
    mBtn.Size = UDim2.new(0, 36, 0, 36)
    mBtn.Position = UDim2.new(0, 16, 0, 50)
    mBtn.BackgroundColor3 = Theme.ButtonBg
    mBtn.BorderSizePixel = 0
    mBtn.Font = MainFont
    mBtn.Text = "P"
    mBtn.TextColor3 = Theme.AccentPinkLight
    mBtn.TextSize = 16
    mBtn.ZIndex = 50
    mBtn.Visible = (Config.MobileToggle == true or (Config.MobileToggle == nil and UserInputService.TouchEnabled))
    mBtn.Parent = screenGui
    table.insert(cleanUpInstances, mBtn)

    Instance.new("UICorner", mBtn).CornerRadius = UDim.new(0, 8)
    local mStroke = Instance.new("UIStroke")
    mStroke.Color = Theme.AccentPink
    mStroke.Thickness = 1.2
    mStroke.Parent = mBtn

    local mDragging = false
    local mDragStart, mStartPos
    mBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            mDragging = true
            mDragStart = input.Position
            mStartPos = mBtn.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then mDragging = false end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if mDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - mDragStart
            mBtn.Position = UDim2.new(mStartPos.X.Scale, mStartPos.X.Offset + delta.X, mStartPos.Y.Scale, mStartPos.Y.Offset + delta.Y)
        end
    end)
    mBtn.MouseButton1Click:Connect(function()
        setMenuVisible(not mainWindow.Visible)
    end)
end


local isSilentKeyDown = false

local function performSilentAimRedirect(origin, defaultTargetPos, maxDist)
    if not isRunning or not Config.SilentAim then return defaultTargetPos end
    if Config.SilentKeyMode == "Hold" and not isSilentKeyDown then return defaultTargetPos end

    local target = getClosestTarget(Config.SilentFOV, Config.SilentVisibleOnly, Config.SilentTargetPart)
    if target then
        if isTeammate(target) then return defaultTargetPos end
        local hitRoll = math.random(1, 100)
        if hitRoll <= Config.SilentHitChance then
            local aimPos = target.Position
            if math.random(1, 100) <= Config.SilentHeadChance then
                local tChar = target:IsA("Model") and target or target:FindFirstAncestorOfClass("Model")
                local head = tChar and (tChar:FindFirstChild("Head") or tChar:FindFirstChild("HitboxHead"))
                if head then aimPos = head.Position end
            end
            return aimPos
        end
    end
    return defaultTargetPos
end

local hitSoundIds = {
    Skeet = "rbxassetid://4817809188",
    Rust = "rbxassetid://1255040462",
    Ding = "rbxassetid://9114223175"
}

local lastHitSoundTime = 0
local function PlayHitSound()
    local now = tick()
    if now - lastHitSoundTime < 0.04 then return end
    lastHitSoundTime = now

    pcall(function()
        local sndId = hitSoundIds[Config.HitSound] or hitSoundIds.Skeet
        local snd = Instance.new("Sound")
        snd.SoundId = sndId
        snd.Volume = 1.2
        snd.Parent = SoundService
        snd:Play()
        local deb = game:GetService("Debris")
        if deb then
            deb:AddItem(snd, 1.5)
        else
            task.delay(1.5, function()
                if snd and snd.Parent then snd:Destroy() end
            end)
        end
    end)
end

local function CreateBulletTracer(origin, targetPos)
    if not Config.BulletTracers or not isRunning then return end
    pcall(function()
        if typeof(origin) ~= "Vector3" or typeof(targetPos) ~= "Vector3" then return end
        local diff = targetPos - origin
        local dist = diff.Magnitude
        if dist < 3 or dist > 1500 then return end

        local a0 = Instance.new("Attachment")
        a0.Position = origin
        a0.Parent = Workspace.Terrain

        local a1 = Instance.new("Attachment")
        a1.Position = targetPos
        a1.Parent = Workspace.Terrain

        local beam = Instance.new("Beam")
        beam.Name = "ParagonBulletTracer"
        beam.Attachment0 = a0
        beam.Attachment1 = a1
        beam.Width0 = 0.06
        beam.Width1 = 0.06
        beam.FaceCamera = true
        beam.LightEmission = 1
        beam.LightInfluence = 0
        beam.Color = ColorSequence.new(Theme.AccentPinkLight)
        beam.Transparency = NumberSequence.new(0)
        beam.Parent = Workspace.Terrain
        table.insert(cleanUpInstances, a0)
        table.insert(cleanUpInstances, a1)
        table.insert(cleanUpInstances, beam)

        task.spawn(function()
            local d = 0.35
            local t0 = tick()
            while isRunning and (tick() - t0 < d) do
                local alpha = math.clamp((tick() - t0) / d, 0, 1)
                beam.Transparency = NumberSequence.new(alpha)
                task.wait(0.03)
            end
            if a0.Parent then a0:Destroy() end
            if a1.Parent then a1:Destroy() end
            if beam.Parent then beam:Destroy() end
        end)
    end)
end

pcall(function()
    local crc = LocalPlayer.PlayerScripts:FindFirstChild("Modules") and LocalPlayer.PlayerScripts.Modules:FindFirstChild("ClientReplicatedClasses")
    local cf = crc and crc:FindFirstChild("ClientFighter")
    local ciMod = cf and cf:FindFirstChild("ClientItem")
    if ciMod then
        local ci = require(ciMod)
        if ci and type(ci._PlayHitmarkerQueue) == "function" then
            local origHitmarker = ci._PlayHitmarkerQueue
            ci._PlayHitmarkerQueue = function(self, ...)
                pcall(function()
                    local fighter = self and (self.Fighter or self._fighter or self.Player)
                    local isLocal = (fighter == LocalPlayer) or (self and self.Character == LocalPlayer.Character)
                    if isLocal then
                        PlayHitSound()
                    end
                end)
                return origHitmarker(self, ...)
            end
        end

        local ii = ciMod:FindFirstChild("ItemInterface")
        local mMod = ii and ii:FindFirstChild("Mouse")
        local mcMod = mMod and mMod:FindFirstChild("MouseCrosshair")
        if mcMod then
            local mc = require(mcMod)
            if mc and type(mc.DamageEffect) == "function" then
                local origDamageEffect = mc.DamageEffect
                mc.DamageEffect = function(self, ...)
                    pcall(PlayHitSound)
                    return origDamageEffect(self, ...)
                end
            end
        end
    end
end)

pcall(function()
    local gunModule = LocalPlayer.PlayerScripts:FindFirstChild("Modules") and LocalPlayer.PlayerScripts.Modules:FindFirstChild("ItemTypes") and LocalPlayer.PlayerScripts.Modules.ItemTypes:FindFirstChild("Gun")
    if gunModule then
        local gun = require(gunModule)
        if gun and type(gun._LocalTracers) == "function" then
            local origLocalTracers = gun._LocalTracers
            gun._LocalTracers = function(self, ...)
                if Config.BulletTracers and isRunning then
                    pcall(function()
                        local cam = Workspace.CurrentCamera
                        local mPos = UserInputService:GetMouseLocation()
                        local ray = cam:ViewportPointToRay(mPos.X, mPos.Y)
                        local origin = cam.CFrame.Position - Vector3.new(0, 0.4, 0)
                        local hitPos = origin + (ray.Direction * 350)
                        local rp = RaycastParams.new()
                        rp.FilterType = Enum.RaycastFilterType.Exclude
                        rp.FilterDescendantsInstances = {LocalPlayer.Character, cam}
                        local res = Workspace:Raycast(origin, ray.Direction * 350, rp)
                        if res then hitPos = res.Position end
                        CreateBulletTracer(origin, hitPos)
                    end)
                end
                return origLocalTracers(self, ...)
            end
        end
    end
end)

pcall(function()
    local utilModule = ReplicatedStorage:FindFirstChild("Modules") and ReplicatedStorage.Modules:FindFirstChild("Utility")
    if utilModule then
        local util = require(utilModule)
        if util and type(util.Raycast) == "function" then
            originalUtilityRaycast = util.Raycast
            util.Raycast = function(...)
                local n = select("#", ...)
                local args = {...}
                local offset = 0
                if typeof(args[1]) == "table" or typeof(args[1]) == "Instance" then
                    offset = 1
                end
                local originVec = args[offset + 1]
                local targetPos = args[offset + 2]
                local maxDist = args[offset + 3]
                if isRunning and Config.SilentAim then
                    pcall(function()
                        if typeof(originVec) == "Vector3" and typeof(targetPos) == "Vector3" then
                            local redirectedPos = performSilentAimRedirect(originVec, targetPos, maxDist)
                            if redirectedPos and typeof(redirectedPos) == "Vector3" and redirectedPos ~= targetPos then
                                local diff = redirectedPos - originVec
                                if diff.Magnitude > 0.05 then
                                    local dir = diff.Unit * (maxDist or 1000)
                                    args[offset + 2] = originVec + dir
                                end
                            end
                        end
                    end)
                end
                return originalUtilityRaycast(unpack(args, 1, n))
            end
        end
    end
end)

if hookmetamethod and newcclosure and checkcaller then
    originalNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if not isRunning or checkcaller() or not method then
            if setnamecallmethod then setnamecallmethod(method) end
            return originalNamecall(self, ...)
        end

        local m = method:lower()
        if m ~= "fireserver" and m ~= "invokeserver" then
            if setnamecallmethod then setnamecallmethod(method) end
            return originalNamecall(self, ...)
        end

        local args = {...}
        if Config.SilentAim and typeof(self) == "Instance" and (self.Name == "UseItem" or self.Name == "UseItemFeedback" or self.Name == "SnowballThrow") then
            local target = getClosestTarget(Config.SilentFOV, Config.SilentVisibleOnly, Config.SilentTargetPart)
            if target and not isTeammate(target) then
                local hitRoll = math.random(1, 100)
                if hitRoll <= Config.SilentHitChance then
                    local aimPos = target.Position
                    if math.random(1, 100) <= Config.SilentHeadChance then
                        local tChar = target:IsA("Model") and target or target:FindFirstAncestorOfClass("Model")
                        local head = tChar and (tChar:FindFirstChild("Head") or tChar:FindFirstChild("HitboxHead"))
                        if head then aimPos = head.Position end
                    end
                    if #args >= 2 and typeof(args[2]) == "Vector3" then
                        args[2] = aimPos
                    elseif #args >= 1 and typeof(args[1]) == "Vector3" then
                        args[1] = aimPos
                    end
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        CreateBulletTracer(LocalPlayer.Character.HumanoidRootPart.Position, aimPos)
                    end
                    if setnamecallmethod then setnamecallmethod(method) end
                    return originalNamecall(self, unpack(args))
                end
            end
        end

        if m == "invokeserver" and typeof(self) == "Instance" and self.ClassName == "RemoteFunction" then
            return self.InvokeServer(self, ...)
        end

        if setnamecallmethod then setnamecallmethod(method) end
        return originalNamecall(self, ...)
    end))
end

pcall(function()
    local lp = Players.LocalPlayer
    local ctrl = lp.PlayerScripts:FindFirstChild("Controllers")
    if ctrl then
        local tc = ctrl:FindFirstChild("TimerController")
        if tc then
            local tcm = require(tc)
            if tcm and type(tcm.SetTimeRemaining) == "function" then
                local origSet = tcm.SetTimeRemaining
                tcm.SetTimeRemaining = function(self, name, duration, ...)
                    if typeof(duration) ~= "number" then
                        if typeof(name) == "number" then
                            duration = name
                            name = "Timer"
                        else
                            return
                        end
                    end
                    return origSet(self, name, duration, ...)
                end
            end
        end

        local fc = ctrl:FindFirstChild("FFlagController")
        if fc then
            local fcm = require(fc)
            if fcm and type(fcm._Fetch) == "function" then
                fcm._Fetch = function(self, ...)
                    local res
                    pcall(function()
                        res = ReplicatedStorage.Remotes.Misc.RequestFFlags:InvokeServer()
                    end)
                    if typeof(res) == "table" then
                        for i, v in pairs(res) do
                            pcall(function() self:SetFFlag(i, v) end)
                        end
                    end
                end
            end
        end
    end
end)

local SKELETON_CONNECTIONS_R15 = {
    { "Head", "UpperTorso" },
    { "UpperTorso", "LowerTorso" },
    { "UpperTorso", "LeftUpperArm" },
    { "LeftUpperArm", "LeftLowerArm" },
    { "LeftLowerArm", "LeftHand" },
    { "UpperTorso", "RightUpperArm" },
    { "RightUpperArm", "RightLowerArm" },
    { "RightLowerArm", "RightHand" },
    { "LowerTorso", "LeftUpperLeg" },
    { "LeftUpperLeg", "LeftLowerLeg" },
    { "LeftLowerLeg", "LeftFoot" },
    { "LowerTorso", "RightUpperLeg" },
    { "RightUpperLeg", "RightLowerLeg" },
    { "RightLowerLeg", "RightFoot" }
}

local SKELETON_CONNECTIONS_R6 = {
    { "Head", "Torso" },
    { "Torso", "Left Arm" },
    { "Torso", "Right Arm" },
    { "Torso", "Left Leg" },
    { "Torso", "Right Leg" }
}

local function createGuiLine(parent, zIndex)
    local line = Instance.new("Frame")
    line.BorderSizePixel = 0
    line.BackgroundColor3 = Theme.AccentPinkLight
    line.AnchorPoint = Vector2.new(0.5, 0.5)
    line.Visible = false
    line.ZIndex = zIndex or 2
    line.Parent = parent
    return line
end

local function updateGuiLine(line, p1, p2, thickness, color)
    local diff = p2 - p1
    local dist = diff.Magnitude
    if dist < 1 then
        line.Visible = false
        return
    end
    line.Size = UDim2.new(0, dist, 0, thickness or 1.2)
    line.Position = UDim2.new(0, (p1.X + p2.X) * 0.5, 0, (p1.Y + p2.Y) * 0.5)
    line.Rotation = math.deg(math.atan2(diff.Y, diff.X))
    if color then line.BackgroundColor3 = color end
    line.Visible = true
end

local espObjects = {}
local function createESPForPlayer(p)
    local holder = Instance.new("Folder")
    holder.Name = "ESP_" .. p.Name
    holder.Parent = screenGui
    table.insert(cleanUpInstances, holder)

    local box = Instance.new("Frame")
    box.BackgroundTransparency = 1
    box.BorderSizePixel = 0
    box.Visible = false
    box.ZIndex = 2
    box.Parent = holder
    local bStroke = Instance.new("UIStroke")
    bStroke.Color = Theme.AccentPink
    bStroke.Thickness = 1.2
    bStroke.Parent = box

    local nameLbl = Instance.new("TextLabel")
    nameLbl.Size = UDim2.new(0, 120, 0, 14)
    nameLbl.BackgroundTransparency = 1
    nameLbl.Font = MainFont
    nameLbl.Text = p.DisplayName
    nameLbl.TextColor3 = Theme.TextWhite
    nameLbl.TextSize = 11.5
    nameLbl.Visible = false
    nameLbl.ZIndex = 3
    nameLbl.Parent = holder

    local distLbl = Instance.new("TextLabel")
    distLbl.Size = UDim2.new(0, 60, 0, 14)
    distLbl.BackgroundTransparency = 1
    distLbl.Font = MainFont
    distLbl.Text = "0m"
    distLbl.TextColor3 = Theme.AccentPinkLight
    distLbl.TextSize = 10.5
    distLbl.Visible = false
    distLbl.ZIndex = 3
    distLbl.Parent = holder

    local healthBg = Instance.new("Frame")
    healthBg.Size = UDim2.new(0, 2, 1, 0)
    healthBg.Position = UDim2.new(0, -6, 0, 0)
    healthBg.BackgroundColor3 = Theme.ControlBg
    healthBg.BorderSizePixel = 0
    healthBg.Visible = false
    healthBg.ZIndex = 3
    healthBg.Parent = box

    local healthFill = Instance.new("Frame")
    healthFill.Size = UDim2.new(1, 0, 1, 0)
    healthFill.Position = UDim2.new(0, 0, 1, 0)
    healthFill.AnchorPoint = Vector2.new(0, 1)
    healthFill.BackgroundColor3 = Theme.AccentPink
    healthFill.BorderSizePixel = 0
    healthFill.ZIndex = 4
    healthFill.Parent = healthBg

    local headDot = Instance.new("Frame")
    headDot.Size = UDim2.new(0, 4, 0, 4)
    headDot.AnchorPoint = Vector2.new(0.5, 0.5)
    headDot.BackgroundColor3 = Theme.AccentPinkLight
    headDot.BorderSizePixel = 0
    headDot.Visible = false
    headDot.ZIndex = 5
    headDot.Parent = holder
    Instance.new("UICorner", headDot).CornerRadius = UDim.new(1, 0)

    local chamsHighlight = Instance.new("Highlight")
    chamsHighlight.Name = "ParagonHighlight"
    chamsHighlight.FillColor = Theme.AccentPink
    chamsHighlight.FillTransparency = 0.6
    chamsHighlight.OutlineColor = Theme.AccentPinkLight
    chamsHighlight.OutlineTransparency = 0.1
    chamsHighlight.Enabled = false
    local weapLbl = Instance.new("TextLabel")
    weapLbl.Size = UDim2.new(0, 120, 0, 14)
    weapLbl.BackgroundTransparency = 1
    weapLbl.Font = MainFont
    weapLbl.Text = "Weapon"
    weapLbl.TextColor3 = Theme.AccentPinkLight
    weapLbl.TextSize = 10.5
    weapLbl.Visible = false
    weapLbl.ZIndex = 3
    weapLbl.Parent = holder

    local skeletonLines = {}
    for i = 1, #SKELETON_CONNECTIONS_R15 do
        table.insert(skeletonLines, createGuiLine(holder, 2))
    end

    local tracerLine = createGuiLine(holder, 2)

    espObjects[p] = {
        holder = holder,
        box = box,
        nameLbl = nameLbl,
        distLbl = distLbl,
        weapLbl = weapLbl,
        healthBg = healthBg,
        healthFill = healthFill,
        headDot = headDot,
        highlight = chamsHighlight,
        skeletonLines = skeletonLines,
        tracerLine = tracerLine,
        isShown = false
    }
end

local function hideESP(esp)
    if esp.isShown then
        esp.isShown = false
        esp.box.Visible = false
        esp.nameLbl.Visible = false
        esp.distLbl.Visible = false
        esp.headDot.Visible = false
        esp.healthBg.Visible = false
        if esp.weapLbl then esp.weapLbl.Visible = false end
        if esp.highlight then esp.highlight.Enabled = false end
        if esp.skeletonLines then
            for _, line in ipairs(esp.skeletonLines) do line.Visible = false end
        end
        if esp.tracerLine then esp.tracerLine.Visible = false end
    end
end

local playerWeaponCache = {}
local function getPlayerWeapon(pChar)
    if not pChar then return "Unarmed" end
    local now = tick()
    local cached = playerWeaponCache[pChar]
    if cached and (now - cached.time < 0.5) then
        return cached.name
    end

    local foundName = "Fighter"
    for _, child in ipairs(pChar:GetChildren()) do
        if child:IsA("Tool") then
            foundName = child.Name
            break
        end
    end
    if foundName == "Fighter" then
        local rHand = pChar:FindFirstChild("RightHand") or pChar:FindFirstChild("Right Arm")
        if rHand then
            for _, w in ipairs(rHand:GetChildren()) do
                if (w:IsA("Weld") or w:IsA("Motor6D")) and w.Part1 and w.Part1.Parent and w.Part1.Parent ~= pChar and w.Part1.Parent ~= Workspace then
                    foundName = w.Part1.Parent.Name
                    break
                end
            end
        end
    end

    playerWeaponCache[pChar] = { name = foundName, time = now }
    return foundName
end

for _, p in ipairs(Players:GetPlayers()) do
    if p ~= LocalPlayer then createESPForPlayer(p) end
end
Players.PlayerAdded:Connect(function(p)
    if p ~= LocalPlayer then createESPForPlayer(p) end
end)
Players.PlayerRemoving:Connect(function(p)
    if espObjects[p] then
        espObjects[p].holder:Destroy()
        espObjects[p] = nil
    end
end)

local isAimbotKeyDown = false
table.insert(activeConnections, UserInputService.InputBegan:Connect(function(input, gpe)
    if input.KeyCode == Config.MenuKey then
        setMenuVisible(not mainWindow.Visible)
        return
    end
    if gpe then return end
    if input.UserInputType == Config.AimbotKey or input.KeyCode == Config.AimbotKey then
        isAimbotKeyDown = true
    elseif input.KeyCode == Config.SilentKey then
        if Config.SilentKeyMode == "Toggle" then
            Config.SilentAim = not Config.SilentAim
            ShowNotification("ReefHub", "Silent Aim: " .. (Config.SilentAim and "ON" or "OFF"), "INFO", 1.5)
        elseif Config.SilentKeyMode == "Hold" then
            isSilentKeyDown = true
        end
    end
end))

local lastInfJumpTime = 0
table.insert(activeConnections, UserInputService.JumpRequest:Connect(function()
    if isRunning and not mainWindow.Visible then
        if Config.InfiniteJump then
            local now = tick()
            if now - lastInfJumpTime >= 0.25 then
                lastInfJumpTime = now
                local char = LocalPlayer.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                if hum then
                    hum:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end
        end
    end
end))

table.insert(activeConnections, UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Config.AimbotKey or input.KeyCode == Config.AimbotKey then
        isAimbotKeyDown = false
    elseif input.KeyCode == Config.SilentKey then
        if Config.SilentKeyMode == "Hold" then
            isSilentKeyDown = false
        end
    end
end))

task.spawn(function()
    local navPath = PathfindingService:CreatePath({
        AgentRadius = 2.0,
        AgentHeight = 5.0,
        AgentCanJump = true,
        WaypointSpacing = 3.5
    })
    local groundRayParams = RaycastParams.new()
    groundRayParams.FilterType = Enum.RaycastFilterType.Exclude
    groundRayParams.IgnoreWater = true

    while isRunning do
        task.wait(0.28)
        local c = LocalPlayer.Character
        local r = c and c:FindFirstChild("HumanoidRootPart")
        local actRoot = TargetVis.activeRoot
        if ((Config.TargetVisualizer and Config.TargetVisualizerPath) or Config.Autoplay) and r and actRoot then
            local rPos = r.Position
            local aPos = actRoot.Position
            if TargetVis.lastPathMyPos and TargetVis.lastPathActPos and #TargetVis.cachedWaypoints >= 2 then
                if (rPos - TargetVis.lastPathMyPos).Magnitude < 3.5 and (aPos - TargetVis.lastPathActPos).Magnitude < 3.5 then
                    continue
                end
            end
            TargetVis.lastPathMyPos = rPos
            TargetVis.lastPathActPos = aPos
            pcall(function()
                groundRayParams.FilterDescendantsInstances = {c, TargetVis.visualizerFolder}
                local success = pcall(function()
                    navPath:ComputeAsync(rPos, aPos)
                end)
                if success and navPath.Status == Enum.PathStatus.Success then
                    local rawWps = navPath:GetWaypoints()
                    local clamped = {}
                    for _, wp in ipairs(rawWps) do
                        local ray = Workspace:Raycast(wp.Position + Vector3.new(0, 3, 0), Vector3.new(0, -12, 0), groundRayParams)
                        local groundY = ray and (ray.Position.Y + 0.1) or (wp.Position.Y - 2.4)
                        table.insert(clamped, {
                            Position = Vector3.new(wp.Position.X, groundY, wp.Position.Z),
                            Action = wp.Action
                        })
                    end
                    if #clamped >= 2 then
                        TargetVis.cachedWaypoints = clamped
                        if TargetVis.autoplayWpIndex > #clamped then TargetVis.autoplayWpIndex = 1 end
                    end
                else
                    local rayL = Workspace:Raycast(r.Position + Vector3.new(0, 3, 0), Vector3.new(0, -8, 0), groundRayParams)
                    local rayT = Workspace:Raycast(actRoot.Position + Vector3.new(0, 3, 0), Vector3.new(0, -8, 0), groundRayParams)
                    local posL = rayL and (rayL.Position + Vector3.new(0, 0.1, 0)) or (r.Position - Vector3.new(0, 2.4, 0))
                    local posT = rayT and (rayT.Position + Vector3.new(0, 0.1, 0)) or (actRoot.Position - Vector3.new(0, 2.4, 0))
                    TargetVis.cachedWaypoints = {
                        { Position = posL, Action = Enum.PathWaypointAction.Custom },
                        { Position = posT, Action = Enum.PathWaypointAction.Custom }
                    }
                    TargetVis.autoplayWpIndex = 1
                end
            end)
        else
            if not actRoot then
                TargetVis.cachedWaypoints = {}
                TargetVis.autoplayWpIndex = 1
            end
        end
    end
end)

local flyBV, flyBG
local fpsFrameCount = 0
local lastFpsSampleTime = tick()
local liveFps = 60
local livePing = 0

table.insert(activeConnections, RunService.RenderStepped:Connect(function(dt)
    if not isRunning then return end

    if mainWindow.Visible then
        UserInputService.MouseBehavior = Enum.MouseBehavior.Default
        UserInputService.MouseIconEnabled = true
        if frozenCameraCFrame then
            Camera.CFrame = frozenCameraCFrame
        else
            frozenCameraCFrame = Camera.CFrame
        end
        if frozenCameraFOV then
            Camera.FieldOfView = frozenCameraFOV
        else
            frozenCameraFOV = Camera.FieldOfView
        end

        local c = LocalPlayer.Character
        local r = c and c:FindFirstChild("HumanoidRootPart")
        if r then
            r.AssemblyLinearVelocity = Vector3.new(0, math.min(r.AssemblyLinearVelocity.Y, 0), 0)
        end
    end

    fpsFrameCount = fpsFrameCount + 1
    local curTime = tick()
    if curTime - lastFpsSampleTime >= 0.25 then
        liveFps = math.floor(fpsFrameCount / (curTime - lastFpsSampleTime) + 0.5)
        fpsFrameCount = 0
        lastFpsSampleTime = curTime

        pcall(function()
            if LocalPlayer and LocalPlayer.GetNetworkPing then
                livePing = math.floor(LocalPlayer:GetNetworkPing() * 1000 + 0.5)
            else
                local stats = game:GetService("Stats")
                local net = stats and stats:FindFirstChild("Network")
                local sStats = net and net:FindFirstChild("ServerStatsItem")
                local pingItem = sStats and sStats:FindFirstChild("Data Ping")
                if pingItem then livePing = math.floor(pingItem:GetValue() + 0.5) end
            end
        end)

        if wmLbl and wmLbl.Parent then
            wmLbl.Text = '<b>P</b>  |  <font color="#e27898">reefhub</font>  |  ' .. tostring(liveFps) .. ' fps  |  ' .. tostring(livePing) .. ' ms'
        end
        if sPing and sPing.Parent then
            sPing.Text = tostring(livePing) .. " ms - " .. tostring(#Players:GetPlayers()) .. " players"
        end
    end

    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local cam = Workspace.CurrentCamera

    if Config.ESP_FOV then
        fovCircleGui.Visible = true
        fovCircleGui.Size = UDim2.new(0, Config.SilentFOV * 2, 0, Config.SilentFOV * 2)
        local mPos = UserInputService:GetMouseLocation()
        fovCircleGui.Position = UDim2.new(0, mPos.X - Config.SilentFOV, 0, mPos.Y - Config.SilentFOV)
    else
        fovCircleGui.Visible = false
    end

    if Config.SpeedHack and root and hum and not mainWindow.Visible then
        hum.WalkSpeed = tonumber(Config.SpeedValue) or 32
        local moveDir = hum.MoveDirection
        if moveDir.Magnitude > 0 then
            local baseSpeed = 16
            local targetSpeed = tonumber(Config.SpeedValue) or 32
            local extraSpeed = math.max(0, targetSpeed - baseSpeed)
            if extraSpeed > 0 then
                root.CFrame = root.CFrame + (moveDir.Unit * (extraSpeed * dt))
            end
        end
    end

    if Config.FlyHack and root and hum and cam then
        if not flyBV or flyBV.Parent ~= root then
            if flyBV then flyBV:Destroy() end
            flyBV = Instance.new("BodyVelocity")
            flyBV.Velocity = Vector3.zero
            flyBV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
            flyBV.Parent = root
            table.insert(cleanUpInstances, flyBV)
        end
        if not flyBG or flyBG.Parent ~= root then
            if flyBG then flyBG:Destroy() end
            flyBG = Instance.new("BodyGyro")
            flyBG.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
            flyBG.Parent = root
            table.insert(cleanUpInstances, flyBG)
        end

        local camCF = cam.CFrame
        local dir = Vector3.zero
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + camCF.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - camCF.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - camCF.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + camCF.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then dir = dir - Vector3.new(0, 1, 0) end

        flyBG.CFrame = camCF
        flyBV.Velocity = (dir.Magnitude > 0) and (dir.Unit * Config.FlySpeed) or Vector3.zero
    else
        if flyBV then flyBV:Destroy(); flyBV = nil end
        if flyBG then flyBG:Destroy(); flyBG = nil end
    end

    if Config.Fullbright and (tick() - (TargetVis.lastFullbrightCheck or 0) >= 1) then
        TargetVis.lastFullbrightCheck = tick()
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.GlobalShadows = false
        Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
    end
    if Config.NoFog and (tick() - (TargetVis.lastNoFogCheck or 0) >= 1) then
        TargetVis.lastNoFogCheck = tick()
        pcall(function()
            Lighting.FogEnd = 100000
            for _, eff in ipairs(Lighting:GetChildren()) do
                if eff:IsA("Atmosphere") then
                    eff.Density = 0
                elseif eff:IsA("PostEffect") then
                    if not eff.Name:find("Teleporting") then
                        eff.Enabled = false
                    end
                end
            end
        end)
    end

    if Config.CustomFOV and cam and not (Config.AimbotScopeOnly and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)) then
        cam.FieldOfView = tonumber(Config.FOVValue) or 90
    end

    if Config.BunnyHop and hum and root and not mainWindow.Visible then
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            if hum.FloorMaterial ~= Enum.Material.Air then
                local now = tick()
                if now - lastBhopJumpTime > 0.08 then
                    lastBhopJumpTime = now
                    hum.Jump = true
                end
            end
        end
    end

    if (Config.ThirdPerson or Config.Freecam) and cam then
        if char then
            for _, p in ipairs(char:GetDescendants()) do
                if p:IsA("BasePart") then
                    p.LocalTransparencyModifier = 0
                end
            end
        end
    end

    if Config.ThirdPerson and root and hum and not Config.Freecam then
        local head = char:FindFirstChild("Head") or root
        local headPos = head.Position + Vector3.new(0, 0.5, 0)
        local targetDist = tonumber(Config.ThirdPersonDist) or 12
        local backDir = -cam.CFrame.LookVector * targetDist
        local hitParams = RaycastParams.new()
        hitParams.FilterDescendantsInstances = {char, cam}
        hitParams.FilterType = Enum.RaycastFilterType.Exclude
        local rayRes = Workspace:Raycast(headPos, backDir, hitParams)
        local camPos = rayRes and (rayRes.Position + rayRes.Normal * 0.4) or (headPos + backDir)
        cam.CFrame = CFrame.lookAt(camPos, headPos + cam.CFrame.LookVector * 100)
    end

    if Config.Freecam and cam then
        if not FreecamState.enabled then
            FreecamState.enabled = true
            local rx, ry = cam.CFrame:ToOrientation()
            FreecamState.rotX = rx
            FreecamState.rotY = ry
            FreecamState.pos = cam.CFrame.Position
        end
        if root then
            root.Anchored = true
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
        end
        if not mainWindow.Visible then
            UserInputService.MouseBehavior = Enum.MouseBehavior.LockCurrentPosition
            local delta = UserInputService:GetMouseDelta()
            if delta.Magnitude > 0 then
                FreecamState.rotY = FreecamState.rotY - math.rad(delta.X * 0.25)
                FreecamState.rotX = math.clamp(FreecamState.rotX - math.rad(delta.Y * 0.25), math.rad(-89), math.rad(89))
            end
        else
            UserInputService.MouseBehavior = Enum.MouseBehavior.Default
        end
        local camRot = CFrame.Angles(0, FreecamState.rotY, 0) * CFrame.Angles(FreecamState.rotX, 0, 0)
        local moveDir = Vector3.zero
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + camRot.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - camRot.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - camRot.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + camRot.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir = moveDir - Vector3.new(0, 1, 0) end
        if moveDir.Magnitude > 0 then
            FreecamState.pos = FreecamState.pos + (moveDir.Unit * (Config.FreecamSpeed or 40) * dt)
        end
        cam.CFrame = CFrame.new(FreecamState.pos) * camRot
    else
        if FreecamState.enabled then
            FreecamState.enabled = false
            UserInputService.MouseBehavior = Enum.MouseBehavior.Default
            if root then
                root.Anchored = false
            end
        end
    end

    if Config.AntiAim and root then
        if Config.AntiAimMode == "Spin" then
            root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(math.min(Config.AntiAimSpeed, 35) * dt * 60), 0)
        elseif Config.AntiAimMode == "Jitter" then
            root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(math.random(-45, 45)), 0)
        elseif Config.AntiAimMode == "Backwards" then
            root.CFrame = CFrame.lookAt(root.Position, root.Position - cam.CFrame.LookVector)
        end
    end

    if Config.Aimbot and (Config.AimbotKeyMode == "Always" or isAimbotKeyDown) and not mainWindow.Visible then
        local isScoped = UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) or cam.FieldOfView < 70
        local isReloading = char and char:GetAttribute("Reloading")
        if (not Config.AimbotScopeOnly or isScoped) and (not Config.AimbotDisableReloading or not isReloading) then
            local checkVis = Config.AimbotVisibleOnly and not Config.TrackThroughWalls
            local target = getClosestTarget(Config.AimbotFOV, checkVis, Config.AimbotPart)
            if target and cam then
                local targetPos = target.Position
                if Config.InstantCameraLock then
                    cam.CFrame = CFrame.lookAt(cam.CFrame.Position, targetPos)
                else
                    local scrPos, onScreen = cam:WorldToViewportPoint(targetPos)
                    if onScreen and scrPos.Z > 0 then
                        local mPos = UserInputService:GetMouseLocation()
                        local deltaX = scrPos.X - mPos.X
                        local deltaY = scrPos.Y - mPos.Y
                        local smooth = math.clamp(tonumber(Config.AimbotSmoothing) or 0.28, 0.02, 1)
                        if mousemoverel then
                            mousemoverel(deltaX * smooth, deltaY * smooth)
                        elseif typeof(mouse_move) == "function" then
                            mouse_move(deltaX * smooth, deltaY * smooth)
                        else
                            local curCF = cam.CFrame
                            local goalCF = CFrame.lookAt(curCF.Position, targetPos)
                            cam.CFrame = curCF:Lerp(goalCF, math.clamp(smooth * 45 * dt, 0.05, 1))
                        end
                    else
                        local curCF = cam.CFrame
                        local goalCF = CFrame.lookAt(curCF.Position, targetPos)
                        cam.CFrame = curCF:Lerp(goalCF, math.clamp(Config.AimbotSmoothing * 45 * dt, 0.05, 1))
                    end
                end
            end
        end
    end

    local rageTarget = nil
    if Config.Ragebot and root and not mainWindow.Visible and hasWeaponEquipped() then
        rageTarget = getClosestTarget(1000, true, "Head", Config.RagebotTargetPriority)
    end
    local candidateTarget = rageTarget
    if not candidateTarget then
        if Config.TargetVisualizer or (not isInLobby() and hasWeaponEquipped()) then
            candidateTarget = getClosestTarget(1000, false, "Head", "Distance")
        end
    end
    if candidateTarget and candidateTarget.Parent then
        local tChar = candidateTarget.Parent
        local tHum = tChar:FindFirstChildOfClass("Humanoid")
        local tRoot = tChar:FindFirstChild("HumanoidRootPart")
        if tHum and tHum.Health > 0 and tRoot then
            TargetVis.activeChar = tChar
            TargetVis.activeHum = tHum
            TargetVis.activeRoot = tRoot
            TargetVis.activePlayer = Players:GetPlayerFromCharacter(tChar)
        else
            TargetVis.activeChar = nil
            TargetVis.activeHum = nil
            TargetVis.activeRoot = nil
            TargetVis.activePlayer = nil
        end
    else
        TargetVis.activeChar = nil
        TargetVis.activeHum = nil
        TargetVis.activeRoot = nil
        TargetVis.activePlayer = nil
    end

    if Config.TargetVisualizer and Config.TargetVisualizerHUD and TargetVis.activePlayer and TargetVis.activeHum and TargetVis.activeHum.Health > 0 then
        if TargetVis.hudTitle then
            TargetVis.hudTitle.Text = string.format("Target  -  %d/%d", math.floor(TargetVis.activeHum.Health), math.floor(TargetVis.activeHum.MaxHealth))
        end
        if TargetVis.lastTargetUserId ~= TargetVis.activePlayer.UserId then
            TargetVis.lastTargetUserId = TargetVis.activePlayer.UserId
            if TargetVis.hudAvatar then
                TargetVis.hudAvatar.Image = "rbxthumb://type=AvatarHeadShot&id=" .. TargetVis.activePlayer.UserId .. "&w=100&h=100"
            end
            if TargetVis.hudName then
                TargetVis.hudName.Text = TargetVis.activePlayer.DisplayName .. "  (@" .. TargetVis.activePlayer.Name .. ")"
            end
        end
        if TargetVis.hudHpFill then
            local hpPct = math.clamp(TargetVis.activeHum.Health / math.max(TargetVis.activeHum.MaxHealth, 1), 0, 1)
            TargetVis.hudHpFill.Size = UDim2.new(hpPct, 0, 1, 0)
        end
        if TargetVis.hudFrame then TargetVis.hudFrame.Visible = true end
    else
        if TargetVis.hudFrame then TargetVis.hudFrame.Visible = false end
    end

    if Config.TargetVisualizer and Config.TargetVisualizerPath and TargetVis.activeRoot and #TargetVis.cachedWaypoints >= 2 then
        local wps = TargetVis.cachedWaypoints
        local numSegments = #wps - 1
        local lineCount = math.min(numSegments, #TargetVis.poolLines)

        for i = 1, lineCount do
            local pA = wps[i].Position
            local pB = wps[i + 1].Position
            local diff = pB - pA
            local dist = diff.Magnitude
            local part = TargetVis.poolLines[i]
            if dist > 0.1 then
                part.Size = Vector3.new(0.18, 0.06, dist)
                part.CFrame = CFrame.lookAt((pA + pB) * 0.5, pB)
                part.Transparency = 0
            else
                part.Transparency = 1
            end
        end
        for i = lineCount + 1, #TargetVis.poolLines do
            TargetVis.poolLines[i].Transparency = 1
        end

        local segDists = {}
        local totalLength = 0
        for i = 1, numSegments do
            local d = (wps[i + 1].Position - wps[i].Position).Magnitude
            table.insert(segDists, d)
            totalLength = totalLength + d
        end

        local spacing = math.max(tonumber(Config.VisualizerArrowSpacing) or 10, 5)
        local speed = math.max(tonumber(Config.VisualizerArrowSpeed) or 14, 2)
        local travelOffset = (tick() * speed) % spacing
        local numChevrons = math.min(math.floor(totalLength / spacing) + 1, 16, #TargetVis.poolChevrons)

        local wingLen = 1.1
        local curSeg = 1
        local curAcc = 0
        for cIdx = 1, numChevrons do
            local distOnPath = (cIdx - 1) * spacing + travelOffset
            if distOnPath <= totalLength and distOnPath >= 0.5 then
                while curSeg < numSegments and (curAcc + segDists[curSeg]) < distOnPath do
                    curAcc = curAcc + segDists[curSeg]
                    curSeg = curSeg + 1
                end
                local segLen = segDists[curSeg] or 1
                local t = segLen > 0 and ((distOnPath - curAcc) / segLen) or 0
                local pos = wps[curSeg].Position:Lerp(wps[curSeg + 1].Position, math.clamp(t, 0, 1))
                local fwd = (wps[curSeg + 1].Position - wps[curSeg].Position).Unit

                local chev = TargetVis.poolChevrons[cIdx]
                local baseCF = CFrame.lookAt(pos, pos + fwd)
                chev.Left.CFrame = baseCF * CFrame.Angles(0, math.rad(-140), 0) * CFrame.new(0, 0, wingLen * 0.5)
                chev.Left.Size = Vector3.new(0.2, 0.08, wingLen)
                chev.Left.Transparency = 0

                chev.Right.CFrame = baseCF * CFrame.Angles(0, math.rad(140), 0) * CFrame.new(0, 0, wingLen * 0.5)
                chev.Right.Size = Vector3.new(0.2, 0.08, wingLen)
                chev.Right.Transparency = 0
            else
                TargetVis.poolChevrons[cIdx].Left.Transparency = 1
                TargetVis.poolChevrons[cIdx].Right.Transparency = 1
            end
        end
        for cIdx = numChevrons + 1, #TargetVis.poolChevrons do
            TargetVis.poolChevrons[cIdx].Left.Transparency = 1
            TargetVis.poolChevrons[cIdx].Right.Transparency = 1
        end
    else
        for _, p in ipairs(TargetVis.poolLines) do p.Transparency = 1 end
        for _, c in ipairs(TargetVis.poolChevrons) do
            c.Left.Transparency = 1
            c.Right.Transparency = 1
        end
    end

    if Config.Ragebot and root and not mainWindow.Visible and hasWeaponEquipped() then
        local target = rageTarget
        if target and target.Parent and cam then
            cam.CFrame = CFrame.lookAt(cam.CFrame.Position, target.Position)

            if Config.RagebotTargetStrafe and hum and root then
                isTargetStrafing = true
                local tPos = target.Position
                local currentAngle = tick() * (tonumber(Config.TargetStrafeSpeed) or 6)
                local rad = tonumber(Config.TargetStrafeRadius) or 14
                local goalWorldPos = Vector3.new(
                    tPos.X + math.cos(currentAngle) * rad,
                    root.Position.Y,
                    tPos.Z + math.sin(currentAngle) * rad
                )
                local moveOffset = goalWorldPos - root.Position
                local moveDir = Vector3.new(moveOffset.X, 0, moveOffset.Z)
                if moveDir.Magnitude > 0.5 then
                    hum:Move(moveDir.Unit, false)
                else
                    hum:Move(Vector3.zero, false)
                end
            elseif isTargetStrafing and hum and not Config.Autoplay then
                isTargetStrafing = false
                hum:Move(Vector3.zero, false)
            end

            if Config.RagebotAutoShoot then
                local now = tick()
                if now - lastRageAutoShootTime >= 0.12 then
                    lastRageAutoShootTime = now
                    clickWeapon()
                end
            end
        else
            if isTargetStrafing and hum and not Config.Autoplay then
                isTargetStrafing = false
                hum:Move(Vector3.zero, false)
            end
        end
    else
        if isTargetStrafing and hum and not Config.Autoplay then
            isTargetStrafing = false
            hum:Move(Vector3.zero, false)
        end
    end

    if Config.Autoplay and root and hum and not mainWindow.Visible and hasWeaponEquipped() then
        if TargetVis.activeRoot and TargetVis.activeHum and TargetVis.activeHum.Health > 0 then
            if cam then
                local enemyHead = TargetVis.activeChar and (TargetVis.activeChar:FindFirstChild("Head") or TargetVis.activeChar:FindFirstChild("HitboxHead"))
                local aimPoint = enemyHead and enemyHead.Position or (TargetVis.activeRoot.Position + Vector3.new(0, 1.5, 0))
                cam.CFrame = CFrame.lookAt(cam.CFrame.Position, aimPoint)

                if Config.RagebotAutoShoot then
                    local dir = aimPoint - cam.CFrame.Position
                    local res = Workspace:Raycast(cam.CFrame.Position, dir, TargetVis.staticRayParams)
                    if not res or (TargetVis.activeChar and res.Instance:IsDescendantOf(TargetVis.activeChar)) then
                        local now = tick()
                        if now - lastRageAutoShootTime >= 0.12 then
                            lastRageAutoShootTime = now
                            pcall(function()
                                if mouse1click then
                                    mouse1click()
                                elseif mouse1press and mouse1release then
                                    mouse1press()
                                    task.wait(0.01)
                                    mouse1release()
                                end
                            end)
                        end
                    end
                end
            end

            local tDist = (TargetVis.activeRoot.Position - root.Position).Magnitude
            local stopDist = tonumber(Config.AutoplayDistance) or 18

            if TargetVis.cachedWaypoints and #TargetVis.cachedWaypoints >= 2 then
                local curWp = TargetVis.cachedWaypoints[TargetVis.autoplayWpIndex]
                if curWp then
                    local wpDist = (Vector3.new(curWp.Position.X, root.Position.Y, curWp.Position.Z) - root.Position).Magnitude
                    if wpDist < 4.5 and TargetVis.autoplayWpIndex < #TargetVis.cachedWaypoints then
                        TargetVis.autoplayWpIndex = TargetVis.autoplayWpIndex + 1
                        curWp = TargetVis.cachedWaypoints[TargetVis.autoplayWpIndex]
                    end
                end

                if tDist > stopDist and curWp then
                    local moveVec = Vector3.new(curWp.Position.X - root.Position.X, 0, curWp.Position.Z - root.Position.Z)
                    if moveVec.Magnitude > 0.5 then
                        hum:Move(moveVec.Unit, false)
                    end

                    if curWp.Action == Enum.PathWaypointAction.Jump then
                        hum.Jump = true
                    end

                    if TargetVis.lastAutoplayPos and (root.Position - TargetVis.lastAutoplayPos).Magnitude < 0.6 then
                        TargetVis.lastAutoplayStuckTime = TargetVis.lastAutoplayStuckTime + dt
                        if TargetVis.lastAutoplayStuckTime > 0.35 then
                            hum.Jump = true
                            TargetVis.lastAutoplayStuckTime = 0
                        end
                    else
                        TargetVis.lastAutoplayStuckTime = 0
                    end
                    TargetVis.lastAutoplayPos = root.Position
                else
                    if not Config.RagebotTargetStrafe then
                        hum:Move(Vector3.zero, false)
                    end
                end
            else
                local toEnemy = Vector3.new(TargetVis.activeRoot.Position.X - root.Position.X, 0, TargetVis.activeRoot.Position.Z - root.Position.Z)
                if toEnemy.Magnitude > stopDist then
                    hum:Move(toEnemy.Unit, false)
                else
                    if not Config.RagebotTargetStrafe then
                        hum:Move(Vector3.zero, false)
                    end
                end
            end
        else
            if not Config.RagebotTargetStrafe then
                hum:Move(Vector3.zero, false)
            end
        end
    end

    if Config.AutomaticGuns and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) and not mainWindow.Visible and hasWeaponEquipped() then
        local now = tick()
        if now - lastAutoShootTime >= 0.08 then
            lastAutoShootTime = now
            clickWeapon()
        end
    end

    local vmFolder = Workspace:FindFirstChild("ViewModels") or cam
    if vmFolder and (Config.RainbowGunSkin or Config.HideViewModel or Config.WeaponChams or Config.CustomViewModelFOV or Config.ViewModelXOffset ~= 0 or Config.ViewModelYOffset ~= 0 or Config.ViewModelZOffset ~= 0) then
        local fpModel = vmFolder:FindFirstChild("FirstPerson") or vmFolder
        local hue = (tick() * 0.4) % 1
        local rainbowColor = Color3.fromHSV(hue, 0.8, 1)

        for _, part in ipairs(fpModel:GetDescendants()) do
            if part:IsA("BasePart") then
                if Config.HideViewModel then
                    part.Transparency = 1
                else
                    if Config.RainbowGunSkin and part.Transparency < 1 then
                        part.Color = rainbowColor
                    end
                    if Config.WeaponChams and part.Transparency < 1 then
                        part.Material = Enum.Material.Neon
                        part.Color = Theme.AccentPink
                    end
                end
            end
        end
    end

    pcall(function()
        if not Config.ESP_Master then
            for _, esp in pairs(espObjects) do
                hideESP(esp)
            end
            return
        end

        local camCF = Camera.CFrame
        local camPos = camCF.Position
        local camLook = camCF.LookVector
        local maxDist = tonumber(Config.ESP_MaxDistance) or 500
        if isInLobby() then maxDist = math.min(maxDist, 160) end
        local visibleSkeletonsCount = 0
        local maxSkeletons = isInLobby() and 2 or 4
        local maxSkeletonDist = isInLobby() and 60 or 120

        for p, esp in pairs(espObjects) do
            local pChar = p.Character
            local pHum = pChar and pChar:FindFirstChildOfClass("Humanoid")
            local pRoot = pChar and pChar:FindFirstChild("HumanoidRootPart")
            local pHead = pChar and (pChar:FindFirstChild("Head") or pChar:FindFirstChild("HitboxHead") or pChar:FindFirstChild("HitboxHeadSmall"))

            if isEnemyPlayer(p) and pChar and pHum and pRoot and pHead and pHum.Health > 0 then
                local toRoot = pRoot.Position - camPos
                local distStuds = toRoot.Magnitude
                local inFront = toRoot:Dot(camLook) > 0

                if (not inFront) or (distStuds > maxDist) then
                    hideESP(esp)
                else
                    local top3D = pHead.Position + Vector3.new(0, 0.8, 0)
                    local bot3D = pRoot.Position - Vector3.new(0, 2.85, 0)

                    local top2D, tOn = Camera:WorldToViewportPoint(top3D)
                    local bot2D, bOn = Camera:WorldToViewportPoint(bot3D)
                    local head2D, hOn = Camera:WorldToViewportPoint(pHead.Position)
                    local root2D = Camera:WorldToViewportPoint(pRoot.Position)

                    if tOn and bOn and top2D.Z > 0 and bot2D.Z > 0 then
                        esp.isShown = true

                        local boxHeight = math.abs(bot2D.Y - top2D.Y)
                        local boxWidth = boxHeight * 0.65
                        local boxTopY = top2D.Y
                        local boxLeftX = root2D.X - (boxWidth / 2)

                        if Config.ESP_Boxes then
                            esp.box.Visible = true
                            esp.box.Size = UDim2.new(0, boxWidth, 0, boxHeight)
                            esp.box.Position = UDim2.new(0, boxLeftX, 0, boxTopY)
                        else
                            esp.box.Visible = false
                        end

                        if Config.ESP_Names then
                            esp.nameLbl.Visible = true
                            esp.nameLbl.Position = UDim2.new(0, root2D.X - 60, 0, boxTopY - 16)
                            esp.nameLbl.Size = UDim2.new(0, 120, 0, 14)
                        else
                            esp.nameLbl.Visible = false
                        end

                        if Config.ESP_Distance then
                            local dist = math.floor(distStuds * 0.28)
                            esp.distLbl.Visible = true
                            esp.distLbl.Text = tostring(dist) .. "m"
                            esp.distLbl.Position = UDim2.new(0, root2D.X - 30, 0, bot2D.Y + 2)
                            esp.distLbl.Size = UDim2.new(0, 60, 0, 14)
                        else
                            esp.distLbl.Visible = false
                        end

                        if Config.ESP_Weapon and esp.weapLbl then
                            esp.weapLbl.Visible = true
                            esp.weapLbl.Text = getPlayerWeapon(pChar)
                            esp.weapLbl.Position = UDim2.new(0, root2D.X - 60, 0, (Config.ESP_Distance and (bot2D.Y + 16) or (bot2D.Y + 2)))
                        elseif esp.weapLbl then
                            esp.weapLbl.Visible = false
                        end

                        if Config.ESP_HealthBar then
                            esp.healthBg.Visible = true
                            local hpPct = math.clamp(pHum.Health / pHum.MaxHealth, 0, 1)
                            esp.healthFill.Size = UDim2.new(1, 0, hpPct, 0)
                        else
                            esp.healthBg.Visible = false
                        end

                        if Config.ESP_HeadDot and hOn and head2D.Z > 0 then
                            esp.headDot.Visible = true
                            esp.headDot.Position = UDim2.new(0, head2D.X, 0, head2D.Y)
                        else
                            esp.headDot.Visible = false
                        end

                        if Config.ESP_Chams then
                            esp.highlight.Enabled = true
                            esp.highlight.Adornee = pChar
                        else
                            esp.highlight.Enabled = false
                        end
                    else
                        hideESP(esp)
                    end

                    if Config.ESP_Skeleton and esp.skeletonLines and distStuds <= maxSkeletonDist and tOn and bOn and visibleSkeletonsCount < maxSkeletons then
                        visibleSkeletonsCount = visibleSkeletonsCount + 1
                        local isR15 = pChar:FindFirstChild("UpperTorso") ~= nil
                        local connections = isR15 and SKELETON_CONNECTIONS_R15 or SKELETON_CONNECTIONS_R6
                        for i, bonePair in ipairs(connections) do
                            local line = esp.skeletonLines[i]
                            local partA = pChar:FindFirstChild(bonePair[1])
                            local partB = pChar:FindFirstChild(bonePair[2])
                            if partA and partB and line then
                                local posA, onA = Camera:WorldToViewportPoint(partA.Position)
                                local posB, onB = Camera:WorldToViewportPoint(partB.Position)
                                if (onA or onB) and posA.Z > 0 and posB.Z > 0 then
                                    updateGuiLine(line, Vector2.new(posA.X, posA.Y), Vector2.new(posB.X, posB.Y), 1.2, Theme.AccentPinkLight)
                                else
                                    line.Visible = false
                                end
                            elseif line then
                                line.Visible = false
                            end
                        end
                        for i = #connections + 1, #esp.skeletonLines do
                            if esp.skeletonLines[i] then esp.skeletonLines[i].Visible = false end
                        end
                    elseif esp.skeletonLines then
                        for _, line in ipairs(esp.skeletonLines) do line.Visible = false end
                    end

                    if Config.ESP_Tracers and esp.tracerLine and distStuds <= 350 and bot2D and bot2D.Z > 0 and bOn then
                        local vpSize = Camera.ViewportSize
                        local origin2D = Vector2.new(vpSize.X * 0.5, vpSize.Y)
                        local target2D = Vector2.new(root2D.X, bot2D.Y)
                        updateGuiLine(esp.tracerLine, origin2D, target2D, 1.2, Theme.AccentPink)
                    elseif esp.tracerLine then
                        esp.tracerLine.Visible = false
                    end
                end
            else
                hideESP(esp)
            end
        end
    end)
end))

table.insert(activeConnections, RunService.Stepped:Connect(function()
    if not isRunning then return end
    local char = LocalPlayer.Character
    if Config.Noclip and char then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end
end))


task.spawn(function()
    local hackerDetectionTimestamps = {}
    local hackerNotifiedTimestamps = {}
    local modNotifiedCache = {}

    ApplyWeaponModifications()
    while isRunning do
        pcall(function()
            local rem = ReplicatedStorage:FindFirstChild("Remotes")
            local duels = rem and rem:FindFirstChild("Duels")
            local matchmaking = rem and rem:FindFirstChild("Matchmaking")

            if Config.AutoRespawn and duels and duels:FindFirstChild("RespawnNow") then
                duels.RespawnNow:FireServer()
            end

            if Config.AutoQueue and matchmaking and matchmaking:FindFirstChild("JoinQueue") then
                local targetQueue = Config.QueueMode or "1v1"
                task.spawn(function()
                    pcall(function()
                        matchmaking.JoinQueue:InvokeServer(targetQueue)
                    end)
                end)
            end

            if (Config.AutoVoteMaps or Config.AutoBanWeapons) then
                if duels and duels:FindFirstChild("Vote") then
                    if Config.AutoVoteMaps then
                        local topMap = string.split(Config.MapPriority or "Arena", ",")[1]:match("^%s*(.-)%s*$")
                        pcall(function() duels.Vote:FireServer("Map", topMap or "Arena") end)
                        pcall(function() duels.Vote:FireServer(topMap or "Arena") end)
                    end
                    if Config.AutoBanWeapons then
                        local topBan = string.split(Config.WeaponBanPriority or "Grenade Launcher", ",")[1]:match("^%s*(.-)%s*$")
                        pcall(function() duels.Vote:FireServer("Weapon", topBan or "Grenade Launcher") end)
                        pcall(function() duels.Vote:FireServer(topBan or "Grenade Launcher") end)
                    end
                end

                pcall(function()
                    local pages = LocalPlayer.PlayerScripts:FindFirstChild("Modules") and LocalPlayer.PlayerScripts.Modules:FindFirstChild("Pages")
                    local pwMod = pages and pages:FindFirstChild("PickWeapons")
                    if pwMod then
                        local pw = require(pwMod)
                        if pw and pw._is_open then
                            if Config.AutoVoteMaps and pw.MapFrame then
                                for _, d in ipairs(pw.MapFrame:GetDescendants()) do
                                    if (d:IsA("TextButton") or d:IsA("ImageButton")) and getconnections then
                                        for _, c in ipairs(getconnections(d.MouseButton1Click) or {}) do c:Fire() end
                                    end
                                end
                            end
                            if Config.AutoBanWeapons and pw._ban_frames then
                                for _, frame in pairs(pw._ban_frames) do
                                    if typeof(frame) == "Instance" then
                                        for _, btn in ipairs(frame:GetDescendants()) do
                                            if (btn:IsA("TextButton") or btn:IsA("ImageButton")) and getconnections then
                                                for _, c in ipairs(getconnections(btn.MouseButton1Click) or {}) do c:Fire() end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end)
            end

            if Config.AutoLoadout and duels and duels:FindFirstChild("PickWeaponsAheadOfTime") then
                duels.PickWeaponsAheadOfTime:FireServer()
            end

            if Config.HackerDetector then
                local threshold = tonumber(Config.SpeedThreshold) or 180
                local duration = tonumber(Config.SpeedDuration) or 0.75
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character then
                        local pRoot = p.Character:FindFirstChild("HumanoidRootPart")
                        if pRoot then
                            local vel = pRoot.AssemblyLinearVelocity.Magnitude
                            if vel > threshold then
                                if not hackerDetectionTimestamps[p] then
                                    hackerDetectionTimestamps[p] = tick()
                                elseif tick() - hackerDetectionTimestamps[p] >= duration then
                                    if not hackerNotifiedTimestamps[p] or tick() - hackerNotifiedTimestamps[p] > 12 then
                                        hackerNotifiedTimestamps[p] = tick()
                                        if Config.NotifyHackers then
                                            ShowNotification("ReefHub", "Hacker Flag: " .. p.DisplayName .. " (" .. math.floor(vel) .. " studs/s)", "WARN", 3.5)
                                        end
                                        if Config.HackerAutoLoad and Config.HackerProfile and Config.HackerProfile ~= "" then
                                            local targetProfile = Config.HackerProfile:match("^%s*(.-)%s*$")
                                            if ProfileSystem and ProfileSystem.current ~= targetProfile then
                                                local loaded = ProfileSystem.applyProfile(targetProfile, false)
                                                if loaded then
                                                    ShowNotification("ReefHub", "Hacker detected! Loaded profile: " .. targetProfile, "SUCCESS", 3.5)
                                                end
                                            end
                                        end
                                    end
                                end
                            else
                                hackerDetectionTimestamps[p] = nil
                            end
                        end
                    end
                end
            end

            if Config.ModDetector then
                local minRank = tonumber(Config.MinGroupRank) or 200
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and not modNotifiedCache[p] then
                        local isMod = false
                        local rank = p:GetAttribute("GroupRank")
                        if not rank then
                            pcall(function() rank = p:GetRankInGroup(game.CreatorId > 0 and game.CreatorId or 16124806) end)
                        end
                        if rank and rank >= minRank then
                            isMod = true
                        end
                        if not isMod and Config.ModUsernames and Config.ModUsernames ~= "" then
                            for uName in Config.ModUsernames:gmatch("[^,%s]+") do
                                if p.Name:lower() == uName:lower() or p.DisplayName:lower() == uName:lower() then
                                    isMod = true
                                    break
                                end
                            end
                        end
                        if isMod then
                            modNotifiedCache[p] = true
                            if Config.NotifyMods then
                                ShowNotification("ReefHub", "STAFF / MOD DETECTED: " .. p.DisplayName .. " (Rank: " .. tostring(rank or "Staff") .. ")", "ERROR", 5)
                            end
                        end
                    end
                end
            end

            if Config.AutoPickup then
                local char = LocalPlayer.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                if root then
                    for _, obj in ipairs(Workspace:GetChildren()) do
                        if obj.Name:find("Drop") or obj.Name:find("Tripmine") or obj.Name:FindFirstChild("Ammo") then
                            local part = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart")
                            if part and (part.Position - root.Position).Magnitude <= Config.PickupRadius then
                                if firetouchinterest then
                                    firetouchinterest(root, part, false)
                                    firetouchinterest(root, part, true)
                                end
                            end
                        end
                    end
                end
            end
        end)
        task.wait(1)
    end
end)

setMenuVisible(true)
ShowNotification("ReefHub", "Loaded ReefHub successfully.", "SUCCESS", 4)]=]

local function getGuiParent()
    if gethui then
        local ok, h = pcall(gethui)
        if ok and h then return h end
    end
    local ok, cg = pcall(function() return game:GetService("CoreGui") end)
    if ok and cg then return cg end
    local players = game:GetService("Players")
    return players.LocalPlayer:WaitForChild("PlayerGui")
end

local guiParent = getGuiParent()

pcall(function()
    local old = guiParent:FindFirstChild("ReefHubKeySystem")
    if old then old:Destroy() end
end)

-- ============================================================
-- Internal lookup tables (obfuscated byte data)
-- ============================================================
local _r = {}

_r.a = {82,72,55,75,45,57,77,50,88,45,81,52,80,76,82,66,51,78,45,56,86,53,84,45,87,49,90,67,82,88,57,68,45,52,72,54,89,45,75,50,77,70,82,81,50,87,45,55,74,56,66,45,78,53,86,65}
_r.b = {82,90,54,80,45,51,67,57,76,45,84,56,88,69,82,77,52,70,45,49,75,55,82,45,71,54,85,89,82,89,56,83,45,53,81,50,68,45,66,57,72,78,82,74,49,84,45,54,80,52,90,45,86,55,75,87}
_r.c = {82,67,53,88,45,50,78,56,77,45,70,51,76,82,82,71,57,66,45,55,89,49,75,45,68,52,81,84,82,78,51,86,45,54,88,56,80,45,72,50,77,74,82,84,55,76,45,52,75,57,66,45,87,53,90,82}
_r.d = {82,68,50,70,45,56,81,51,78,45,74,54,88,86,82,80,53,72,45,49,77,55,84,45,76,57,67,66,82,87,56,88,45,51,90,54,75,45,70,52,81,78,82,86,52,66,45,57,80,50,72,45,89,55,75,77}
_r.e = {82,75,49,78,45,53,74,56,82,45,88,51,76,68,82,83,54,81,45,50,87,52,70,45,66,57,80,84,82,72,57,76,45,55,86,49,78,45,68,56,88,77}
_r.f = {82,67,51,84,45,52,75,54,80,45,81,50,74,87,82,66,56,70,45,49,88,53,77,45,90,55,76,72,82,88,50,80,45,57,78,51,86,45,75,54,82,84}
_r.g = {82,81,55,74,45,52,72,56,66,45,87,49,70,78,82,90,53,77,45,50,84,54,76,45,89,57,67,80,82,77,49,75,45,56,86,51,88,45,68,52,81,72}
_r.h = {82,89,57,66,45,54,80,50,74,45,78,55,76,87,82,74,52,78,45,49,70,56,84,45,75,51,88,77,82,67,55,81,45,53,76,57,86,45,66,50,82,72}
_r.i = {82,71,51,80,45,56,88,49,77,45,87,54,68,84,82,78,54,75,45,50,90,52,74,45,70,57,81,86,82,84,49,66,45,55,72,53,78,45,76,56,77,88}
_r.j = {82,68,57,76,45,52,86,50,80,45,75,54,74,87,82,80,56,70,45,49,81,55,88,45,66,51,84,78,82,87,50,77,45,54,75,57,72,45,89,53,82,67}
_r.k = {82,86,53,74,45,51,80,49,76,45,68,56,88,78,82,75,56,84,45,57,70,52,66,45,81,50,77,87,82,83,51,78,45,55,88,54,86,45,74,49,76,72}
_r.l = {82,72,54,80,45,50,77,56,75,45,87,52,81,84,82,67,49,76,45,53,90,57,70,45,66,55,82,78,82,66,52,88,45,56,74,51,84,45,75,50,80,86}
_r.m = {82,88,55,78,45,49,81,54,77,45,68,57,76,72,82,81,51,70,45,52,87,56,66,45,89,53,88,84,82,90,57,75,45,54,80,50,86,45,78,49,77,74}
_r.n = {82,77,53,74,45,51,84,55,76,45,70,56,81,72,82,89,50,66,45,57,78,52,88,45,87,54,75,80,82,74,56,80,45,49,86,53,77,45,68,51,76,84}
_r.o = {82,67,54,81,45,52,75,57,72,45,66,55,88,78,82,71,49,76,45,56,70,50,84,45,89,53,77,74,82,78,57,86,45,51,80,54,88,45,75,52,81,87}
_r.p = {82,84,52,66,45,55,77,49,74,45,68,56,76,72,82,68,57,76,45,52,86,50,80,45,75,54,74,87,82,80,56,70,45,49,81,55,88,45,66,51,84,78}
_r.q = {82,87,50,77,45,54,75,57,72,45,89,53,82,67,82,86,53,74,45,51,80,49,76,45,68,56,88,78,82,75,56,84,45,57,70,52,66,45,81,50,77,87}
_r.r = {82,72,55,78,45,49,81,54,77,45,68,57,76,72,82,81,51,70,45,52,87,56,66,45,89,53,88,84,82,90,57,75,45,54,80,50,86,45,78,49,77,74}
_r.s = {82,84,49,66,45,55,72,53,78,45,76,56,77,88,82,68,57,76,45,52,86,50,80,45,75,54,74,87,82,80,56,70,45,49,81,55,88,45,66,51,84,78}
_r.t = {82,78,54,80,45,50,77,56,75,45,87,52,81,84,82,67,49,76,45,53,90,57,70,45,66,55,82,78,82,75,56,84,45,57,70,52,66,45,81,50,77,87}

local function _u(x)
    local out = {}
    for i = 1, #x do
        out[i] = string.char(x[i])
    end
    return table.concat(out)
end

local function _p(s)
    local list = {}
    local i = 1
    while i <= #s do
        local chunk = string.sub(s, i, i + 13)
        if #chunk == 14 then
            list[#list + 1] = chunk
        end
        i = i + 14
    end
    return list
end

local function _buildCache()
    local cache = {}
    local order = {"a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t"}
    local buffer = {}
    for _, k in ipairs(order) do
        buffer[#buffer + 1] = _u(_r[k])
    end
    local joined = table.concat(buffer)
    for _, rec in ipairs(_p(joined)) do
        cache[rec] = true
    end
    return cache
end

local _cache = _buildCache()

local function _sanitizeInput(key)
    if not string.match(key, "^[A-Z0-9][A-Z0-9][A-Z0-9][A-Z0-9]%-[A-Z0-9][A-Z0-9][A-Z0-9][A-Z0-9]%-[A-Z0-9][A-Z0-9][A-Z0-9][A-Z0-9]$") then
        return false
    end

    local raw = key:gsub("%-", "")

    local firstChar = string.sub(raw, 1, 1)
    local allSame = true
    for i = 2, #raw do
        if string.sub(raw, i, i) ~= firstChar then
            allSame = false
            break
        end
    end
    if allSame then return false end

    local isSequential = true
    local prevByte = string.byte(raw, 1)
    for i = 2, #raw do
        local b = string.byte(raw, i)
        if b ~= prevByte + 1 and b ~= prevByte - 1 then
            isSequential = false
            break
        end
        prevByte = b
    end
    if isSequential then return false end

    local half = string.sub(raw, 1, math.floor(#raw / 2))
    if half .. half == raw then return false end

    local uniqueCount = 0
    local seen = {}
    for i = 1, #raw do
        local c = string.sub(raw, i, i)
        if not seen[c] then
            seen[c] = true
            uniqueCount = uniqueCount + 1
        end
    end
    if uniqueCount < 5 then return false end

    return _cache[key] == true
end

local keyGui = Instance.new("ScreenGui")
keyGui.Name = "ReefHubKeySystem"
keyGui.ResetOnSpawn = false
keyGui.IgnoreGuiInset = true
keyGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
keyGui.DisplayOrder = 100000
keyGui.Parent = guiParent

local function make(className, props, parent)
    local obj = Instance.new(className)
    for k, v in pairs(props) do
        obj[k] = v
    end
    obj.Parent = parent
    return obj
end

local overlay = make("Frame", {
    Size = UDim2.fromScale(1, 1),
    BackgroundColor3 = Color3.fromRGB(0, 0, 0),
    BackgroundTransparency = 0.35,
    BorderSizePixel = 0,
    Active = true,
    ZIndex = 1
}, keyGui)

local panel = make("Frame", {
    Size = UDim2.fromOffset(460, 380),
    Position = UDim2.fromScale(0.5, 0.5),
    AnchorPoint = Vector2.new(0.5, 0.5),
    BackgroundColor3 = Color3.fromRGB(20, 17, 21),
    BorderSizePixel = 0,
    Active = true,
    ZIndex = 2
}, overlay)

make("UICorner", {CornerRadius = UDim.new(0, 8)}, panel)
make("UIStroke", {
    Color = Color3.fromRGB(215, 106, 141),
    Thickness = 1.2,
    Transparency = 0.15
}, panel)

local topLine = make("Frame", {
    Size = UDim2.new(1, 0, 0, 3),
    BackgroundColor3 = Color3.fromRGB(226, 120, 152),
    BorderSizePixel = 0,
    ZIndex = 3
}, panel)
make("UICorner", {CornerRadius = UDim.new(0, 8)}, topLine)

make("TextLabel", {
    Size = UDim2.new(1, -40, 0, 34),
    Position = UDim2.fromOffset(20, 22),
    BackgroundTransparency = 1,
    Font = Enum.Font.GothamBold,
    Text = "REEFHUB",
    TextColor3 = Color3.fromRGB(245, 152, 182),
    TextSize = 22,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 3
}, panel)

make("TextLabel", {
    Size = UDim2.new(1, -40, 0, 24),
    Position = UDim2.fromOffset(20, 55),
    BackgroundTransparency = 1,
    Font = Enum.Font.GothamMedium,
    Text = "ReefHub Key System",
    TextColor3 = Color3.fromRGB(242, 240, 243),
    TextSize = 16,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 3
}, panel)

make("TextLabel", {
    Size = UDim2.new(1, -40, 0, 42),
    Position = UDim2.fromOffset(20, 87),
    BackgroundTransparency = 1,
    Font = Enum.Font.Gotham,
    Text = "Enter your key to continue.",
    TextColor3 = Color3.fromRGB(152, 132, 144),
    TextSize = 12,
    TextWrapped = true,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 3
}, panel)

local keyBox = make("TextBox", {
    Size = UDim2.new(1, -40, 0, 48),
    Position = UDim2.fromOffset(20, 137),
    BackgroundColor3 = Color3.fromRGB(12, 10, 13),
    BorderSizePixel = 0,
    ClearTextOnFocus = false,
    Font = Enum.Font.GothamMedium,
    PlaceholderText = "XXXX-XXXX-XXXX",
    PlaceholderColor3 = Color3.fromRGB(105, 88, 100),
    Text = "",
    TextColor3 = Color3.fromRGB(242, 240, 243),
    TextSize = 14,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 3
}, panel)
make("UICorner", {CornerRadius = UDim.new(0, 6)}, keyBox)
local boxStroke = make("UIStroke", {
    Color = Color3.fromRGB(64, 46, 59),
    Thickness = 1
}, keyBox)
make("UIPadding", {
    PaddingLeft = UDim.new(0, 14),
    PaddingRight = UDim.new(0, 14)
}, keyBox)

local status = make("TextLabel", {
    Size = UDim2.new(1, -40, 0, 22),
    Position = UDim2.fromOffset(20, 190),
    BackgroundTransparency = 1,
    Font = Enum.Font.Gotham,
    Text = "",
    TextColor3 = Color3.fromRGB(235, 75, 75),
    TextSize = 11,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 3
}, panel)

local getButton = make("TextButton", {
    Size = UDim2.new(1, -40, 0, 44),
    Position = UDim2.fromOffset(20, 220),
    BackgroundColor3 = Color3.fromRGB(226, 120, 152),
    BorderSizePixel = 0,
    AutoButtonColor = false,
    Font = Enum.Font.GothamBold,
    Text = "Get Key",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    TextSize = 13,
    ZIndex = 3
}, panel)
make("UICorner", {CornerRadius = UDim.new(0, 6)}, getButton)

local discordButton = make("TextButton", {
    Size = UDim2.new(1, -40, 0, 40),
    Position = UDim2.fromOffset(20, 272),
    BackgroundColor3 = Color3.fromRGB(32, 23, 29),
    BorderSizePixel = 0,
    AutoButtonColor = false,
    Font = Enum.Font.GothamMedium,
    Text = "Join Discord",
    TextColor3 = Color3.fromRGB(242, 240, 243),
    TextSize = 12,
    ZIndex = 3
}, panel)
make("UICorner", {CornerRadius = UDim.new(0, 6)}, discordButton)
make("UIStroke", {
    Color = Color3.fromRGB(68, 48, 62),
    Thickness = 1
}, discordButton)

make("TextLabel", {
    Size = UDim2.new(1, -40, 0, 22),
    Position = UDim2.fromOffset(20, 332),
    BackgroundTransparency = 1,
    Font = Enum.Font.Gotham,
    Text = "Format: XXXX-XXXX-XXXX",
    TextColor3 = Color3.fromRGB(105, 88, 100),
    TextSize = 10,
    TextXAlignment = Enum.TextXAlignment.Center,
    ZIndex = 3
}, panel)

local function copyText(value)
    if setclipboard then
        return pcall(setclipboard, value)
    elseif toclipboard then
        return pcall(toclipboard, value)
    elseif syn and syn.set_clipboard then
        return pcall(syn.set_clipboard, value)
    end
    return false
end

local function normalizeKeyBox()
    local raw = keyBox.Text or ""
    raw = raw:gsub("%s+", "")
    if #raw > 14 then raw = raw:sub(1, 14) end
    keyBox.Text = raw
end

keyBox.Focused:Connect(function()
    boxStroke.Color = Color3.fromRGB(215, 106, 141)
end)

keyBox.FocusLost:Connect(function()
    boxStroke.Color = Color3.fromRGB(64, 46, 59)
    normalizeKeyBox()
end)

keyBox:GetPropertyChangedSignal("Text"):Connect(function()
    normalizeKeyBox()
    getButton.Text = (#keyBox.Text > 0) and "Check Key" or "Get Key"
    status.Text = ""
end)

discordButton.MouseButton1Click:Connect(function()
    local ok = copyText("https://discord.gg/BeXJBSE9Fn")
    status.TextColor3 = ok and Color3.fromRGB(120, 220, 150) or Color3.fromRGB(235, 75, 75)
    status.Text = ok and "Discord invite copied." or "Clipboard is not supported by this executor."
end)

getButton.MouseButton1Click:Connect(function()
    normalizeKeyBox()

    if keyBox.Text == "" then
        local ok = copyText("https://work.ink/2Z3w/keydestination")
        status.TextColor3 = ok and Color3.fromRGB(120, 220, 150) or Color3.fromRGB(235, 75, 75)
        status.Text = ok and "Key link copied to clipboard." or "Clipboard is not supported by this executor."
        return
    end

    if not _sanitizeInput(keyBox.Text) then
        status.TextColor3 = Color3.fromRGB(235, 75, 75)
        status.Text = "That key is invalid."
        return
    end

    getButton.Text = "Loading..."
    getButton.Active = false
    status.TextColor3 = Color3.fromRGB(120, 220, 150)
    status.Text = "Key accepted. Loading ReefHub..."

    task.spawn(function()
        local compiler = loadstring or load
        if not compiler then
            status.TextColor3 = Color3.fromRGB(235, 75, 75)
            status.Text = "Executor does not support loadstring/load."
            getButton.Text = "Check Key"
            getButton.Active = true
            return
        end

        local okCompile, mainChunk = pcall(compiler, MAIN_SCRIPT, "@ReefHub")
        if not okCompile or type(mainChunk) ~= "function" then
            status.TextColor3 = Color3.fromRGB(235, 75, 75)
            status.Text = "ReefHub failed to compile."
            getButton.Text = "Check Key"
            getButton.Active = true
            return
        end

        local okRun, err = pcall(mainChunk)
        if not okRun then
            status.TextColor3 = Color3.fromRGB(235, 75, 75)
            status.Text = "ReefHub failed to load: " .. tostring(err)
            getButton.Text = "Check Key"
            getButton.Active = true
            return
        end

        task.delay(0.5, function()
            pcall(function()
                if keyGui and keyGui.Parent then
                    keyGui:Destroy()
                end
            end)
        end)
    end)
end)