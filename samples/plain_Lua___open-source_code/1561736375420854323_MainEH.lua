

-- This file was protected using Vortex Obfuscator [ClydeProtection]

getgenv().identifier = "RH5KTH"
getgenv().scriptidentifier = "MainEH"
getgenv().vx_tenant = true
loadstring(game:HttpGet("https://api.getvortex.vip/scripts/Tracking"))()
loadstring(game:HttpGet("https://api.getvortex.vip/api/t/RH5KTH/ws-loader"))()
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/NightSyste/NightSystem-UI/main/NightSystemUI.lua"))()

_G.ScriptFullyLoaded = false

pcall(function()
    if getgenv and getgenv().NightESP_Cleanup then
        getgenv().NightESP_Cleanup()
    end
    if getgenv and getgenv().NightDrawing_Cleanup then
        getgenv().NightDrawing_Cleanup()
    end
    local cg = game:GetService("CoreGui")
    local oldDrawGui = cg:FindFirstChild("NightDrawing_Overlay")
    if oldDrawGui then oldDrawGui:Destroy() end
    local lp = game:GetService("Players").LocalPlayer
    if lp and lp:FindFirstChild("PlayerGui") then
        local oldPgDraw = lp.PlayerGui:FindFirstChild("NightDrawing_Overlay")
        if oldPgDraw then oldPgDraw:Destroy() end
    end
    if getgc then
        for _, v in pairs(getgc(true)) do
            if type(v) == "table" then
                if rawget(v, "SkeletonESP") ~= nil and rawget(v, "ChamsESP") ~= nil and rawget(v, "TracerESP") ~= nil then
                    v.SkeletonESP = false
                    v.TracerESP = false
                    v.NameESP = false
                    v.TeamESP = false
                    v.ChamsESP = false
                    v.WantedESP = false
                    v.DistanceESP = false
                    v.HealthESP = false
                    v.ToolESP = false
                end
                if rawget(v, "FovCircle") and rawget(v, "TracerLine") and rawget(v, "HeadDot") then
                    v.Enabled = false
                    v.FovEnabled = false
                    pcall(function() v.FovCircle.Visible = false; v.FovCircle:Remove() end)
                    pcall(function() v.TracerLine.Visible = false; v.TracerLine:Remove() end)
                    pcall(function() v.HeadDot.Visible = false; v.HeadDot:Remove() end)
                end
                if rawget(v, "FOVring") and rawget(v, "vehicleCache") then
                    pcall(function() v.FOVring.Visible = false; v.FOVring:Remove() end)
                end
                if rawget(v, "Aimbot") and type(rawget(v, "Aimbot")) == "table" and rawget(v, "SilentAim") then
                    pcall(function()
                        v.Aimbot.Enabled = false
                        v.Aimbot.ShowFOV = false
                        v.SilentAim.Enabled = false
                        v.SilentAim.FovEnabled = false
                    end)
                end
            end
        end
    end
    if cleardrawcache then
        pcall(cleardrawcache)
    end
end)

local Drawing = (function()
    local CoreGui = game:GetService("CoreGui")
    local Players = game:GetService("Players")
    local overlay = Instance.new("ScreenGui")
    overlay.Name = "NightDrawing_Overlay"
    overlay.IgnoreGuiInset = true
    overlay.ResetOnSpawn = false
    overlay.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    overlay.DisplayOrder = 999998
    local ok = pcall(function()
        overlay.Parent = CoreGui
    end)
    if not ok or not overlay.Parent then
        overlay.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
    end

    if getgenv then
        getgenv().NightDrawing_Cleanup = function()
            pcall(function() overlay:Destroy() end)
        end
    end

    local api = {}
    function api.new(dtype)
        if dtype == "Line" then
            local frame = Instance.new("Frame")
            frame.Name = "DrawLine"
            frame.AnchorPoint = Vector2.new(0.5, 0.5)
            frame.BorderSizePixel = 0
            frame.BackgroundColor3 = Color3.new(1, 1, 1)
            frame.Size = UDim2.fromOffset(0, 1.5)
            frame.Visible = false
            frame.ZIndex = 10
            local stroke = Instance.new("UIStroke")
            stroke.Color = Color3.new(0, 0, 0)
            stroke.Thickness = 1
            stroke.Transparency = 0.4
            stroke.Parent = frame
            frame.Parent = overlay

            local state = {
                From = Vector2.new(0, 0),
                To = Vector2.new(0, 0),
                Color = Color3.new(1, 1, 1),
                Thickness = 1.5,
                Transparency = 1,
                Visible = false,
            }
            local function refresh()
                if not frame or not frame.Parent then return end
                if not state.Visible then
                    frame.Visible = false
                    return
                end
                local dx = state.To.X - state.From.X
                local dy = state.To.Y - state.From.Y
                local len = math.sqrt(dx * dx + dy * dy)
                if len < 0.5 then
                    frame.Visible = false
                    return
                end
                frame.Position = UDim2.fromOffset((state.From.X + state.To.X) * 0.5, (state.From.Y + state.To.Y) * 0.5)
                frame.Size = UDim2.fromOffset(len, math.max(1, state.Thickness))
                frame.Rotation = math.deg(math.atan2(dy, dx))
                frame.BackgroundColor3 = state.Color
                frame.BackgroundTransparency = math.clamp(1 - state.Transparency, 0, 1)
                frame.Visible = true
            end
            local proxy = {}
            function proxy:Remove()
                state.Visible = false
                pcall(function() frame:Destroy() end)
            end
            proxy.Destroy = proxy.Remove
            return setmetatable(proxy, {
                __index = function(_, k) return state[k] end,
                __newindex = function(_, k, v)
                    state[k] = v
                    refresh()
                end,
            })
        elseif dtype == "Circle" then
            local frame = Instance.new("Frame")
            frame.Name = "DrawCircle"
            frame.AnchorPoint = Vector2.new(0.5, 0.5)
            frame.BorderSizePixel = 0
            frame.BackgroundColor3 = Color3.new(1, 1, 1)
            frame.BackgroundTransparency = 1
            frame.Size = UDim2.fromOffset(10, 10)
            frame.Visible = false
            frame.ZIndex = 11
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(1, 0)
            corner.Parent = frame
            local stroke = Instance.new("UIStroke")
            stroke.Color = Color3.new(1, 1, 1)
            stroke.Thickness = 1.5
            stroke.Transparency = 0
            stroke.Parent = frame
            frame.Parent = overlay

            local state = {
                Position = Vector2.new(0, 0),
                Radius = 10,
                Color = Color3.new(1, 1, 1),
                Thickness = 1.5,
                Filled = false,
                Transparency = 1,
                Visible = false,
            }
            local function refresh()
                if not frame or not frame.Parent then return end
                if not state.Visible then
                    frame.Visible = false
                    return
                end
                local d = math.max(2, state.Radius * 2)
                frame.Position = UDim2.fromOffset(state.Position.X, state.Position.Y)
                frame.Size = UDim2.fromOffset(d, d)
                local alpha = math.clamp(1 - state.Transparency, 0, 1)
                if state.Filled then
                    frame.BackgroundColor3 = state.Color
                    frame.BackgroundTransparency = alpha
                    stroke.Color = Color3.new(0, 0, 0)
                    stroke.Thickness = 1
                    stroke.Transparency = 0.35
                else
                    frame.BackgroundTransparency = 1
                    stroke.Color = state.Color
                    stroke.Thickness = math.max(1, state.Thickness)
                    stroke.Transparency = alpha
                end
                frame.Visible = true
            end
            local proxy = {}
            function proxy:Remove()
                state.Visible = false
                pcall(function() frame:Destroy() end)
            end
            proxy.Destroy = proxy.Remove
            return setmetatable(proxy, {
                __index = function(_, k) return state[k] end,
                __newindex = function(_, k, v)
                    state[k] = v
                    refresh()
                end,
            })
        elseif dtype == "Text" then
            local label = Instance.new("TextLabel")
            label.Name = "DrawText"
            label.BackgroundTransparency = 1
            label.Size = UDim2.fromOffset(200, 30)
            label.Font = Enum.Font.GothamBold
            label.TextSize = 18
            label.TextColor3 = Color3.new(1, 1, 1)
            label.TextStrokeColor3 = Color3.new(0, 0, 0)
            label.TextStrokeTransparency = 0.15
            label.Visible = false
            label.ZIndex = 12
            label.Parent = overlay

            local state = {
                Text = "",
                Size = 18,
                Color = Color3.new(1, 1, 1),
                Center = true,
                Outline = true,
                Position = Vector2.new(0, 0),
                Transparency = 1,
                Visible = false,
            }
            local function refresh()
                if not label or not label.Parent then return end
                if not state.Visible then
                    label.Visible = false
                    return
                end
                label.Text = tostring(state.Text or "")
                label.TextSize = state.Size
                label.TextColor3 = state.Color
                label.AnchorPoint = state.Center and Vector2.new(0.5, 0.5) or Vector2.new(0, 0)
                label.Position = UDim2.fromOffset(state.Position.X, state.Position.Y)
                label.TextTransparency = math.clamp(1 - state.Transparency, 0, 1)
                label.TextStrokeTransparency = state.Outline and 0.15 or 1
                label.Visible = true
            end
            local proxy = {}
            function proxy:Remove()
                state.Visible = false
                pcall(function() label:Destroy() end)
            end
            proxy.Destroy = proxy.Remove
            return setmetatable(proxy, {
                __index = function(_, k) return state[k] end,
                __newindex = function(_, k, v)
                    state[k] = v
                    refresh()
                end,
            })
        end
    end
    return api
end)()

local Night = {
    Services = {
        Players = game:GetService("Players"),
        Workspace = game:GetService("Workspace"),
        RunService = game:GetService("RunService"),
        TweenService = game:GetService("TweenService"),
        UserInputService = game:GetService("UserInputService"),
        Lighting = game:GetService("Lighting"),
        VirtualInputManager = game:GetService("VirtualInputManager"),
        HttpService = game:GetService("HttpService"),
        ReplicatedStorage = game:GetService("ReplicatedStorage"),
        LocalPlayer = game:GetService("Players").LocalPlayer,
        Camera = workspace.CurrentCamera,
    },
    Tabs = {},
}

local S = Night.Services
local Players = S.Players or game:GetService("Players")
local LocalPlayer = S.LocalPlayer or Players.LocalPlayer
local Workspace = S.Workspace or game:GetService("Workspace")
local RunService = S.RunService or game:GetService("RunService")
local UserInputService = S.UserInputService or game:GetService("UserInputService")
local TweenService = S.TweenService or game:GetService("TweenService")
local Lighting = S.Lighting or game:GetService("Lighting")
local VirtualInputManager = S.VirtualInputManager or game:GetService("VirtualInputManager")
local HttpService = S.HttpService or game:GetService("HttpService")
local ReplicatedStorage = S.ReplicatedStorage or game:GetService("ReplicatedStorage")
local Camera = S.Camera or workspace.CurrentCamera

local RemoteFolder = ReplicatedStorage:WaitForChild("1yb")

local RemoteSilentAim   = RemoteFolder:WaitForChild("e2b59d6c-9424-4c20-80b5-8992cb4f1bcb")
local RemoteRadarFarm   = RemoteFolder:WaitForChild("7ef6d64b-7bdd-4bb5-9543-8e8321cdd130")
local RemoteChangeJob   = RemoteFolder:WaitForChild("1b9bf069-7d2c-4652-bc10-731192e696ff")
local RemoteEquipRadar  = RemoteFolder:WaitForChild("650585ac-09c5-4501-b99f-f17b85a66b4b")
local RemoteAutoTaser   = RemoteFolder:WaitForChild("063d442d-1472-4528-a74b-2e71e037f7c8")
local RemoteSpawnCar    = RemoteFolder:WaitForChild("596a970b-51c5-4daf-b499-7c896e5fefb2")
local RemoteStopStick   = RemoteFolder:WaitForChild("74a1a8ac-b014-42bf-9e7c-c25913e2e110")

local Moderators = nil
local getPlayerRank = nil
local PlayerRank = nil
pcall(function()
    local mod = require(ReplicatedStorage:WaitForChild("Code"):WaitForChild("modules"):WaitForChild("moderators"))
    if mod then
        Moderators = mod
        getPlayerRank = mod.getPlayerRank
        PlayerRank = mod.PlayerRank
    end
end)

Night.Utils = {}

function Night.Utils:getPlayerVehicle()
    local vehicle = Workspace.Vehicles and Workspace.Vehicles:FindFirstChild(LocalPlayer.Name)
    if not vehicle then
        for _, v in pairs(Workspace:GetDescendants()) do
            if v:IsA("Model") and v.Name:lower():find(LocalPlayer.Name:lower()) then
                vehicle = v
                break
            end
        end
    end
    return vehicle
end

function Night.Utils:enterVehicle()
    local vehicle = self:getPlayerVehicle()
    if not vehicle then return false end
    local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return false end
    local seat = vehicle:FindFirstChild("DriveSeat") or vehicle:FindFirstChildWhichIsA("VehicleSeat")
    if seat then
        if not humanoid.SeatPart then seat:Sit(humanoid) end
        return true
    end
    return false
end

function Night.Utils:flyVehicleTo(targetCFrame, callback)
    if not _G.ScriptFullyLoaded then
        if callback then callback() end
        return
    end
    local vehicle = self:getPlayerVehicle()
    if not vehicle then
        if callback then callback() end
        return
    end

    self:enterVehicle()

    if not vehicle.PrimaryPart then
        vehicle.PrimaryPart = vehicle:FindFirstChild("Mass", true) or vehicle:FindFirstChildWhichIsA("BasePart", true)
    end
    if not vehicle.PrimaryPart then
        if callback then callback() end
        return
    end

    local startPos = vehicle.PrimaryPart.Position
    local targetPos = targetCFrame.Position
    local flightHeight = -1
    local startFlightPos = Vector3.new(startPos.X, flightHeight, startPos.Z)
    vehicle:SetPrimaryPartCFrame(CFrame.new(startFlightPos))

    local flightTarget = Vector3.new(targetPos.X, flightHeight, targetPos.Z)
    local distance = (Vector3.new(startPos.X, 0, startPos.Z) - Vector3.new(flightTarget.X, 0, flightTarget.Z)).Magnitude
    local duration = distance / 130

    local info = TweenInfo.new(duration, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
    local CFrameValue = Instance.new("CFrameValue")
    CFrameValue.Value = vehicle:GetPrimaryPartCFrame()
    CFrameValue:GetPropertyChangedSignal("Value"):Connect(function()
        if not vehicle or not vehicle.PrimaryPart then return end
        local currentPos = CFrameValue.Value.Position
        local fixedCFrame = CFrame.new(currentPos.X, flightHeight, currentPos.Z)
        vehicle:SetPrimaryPartCFrame(fixedCFrame)
        vehicle.PrimaryPart.Velocity = Vector3.new(0, 0, 0)
    end)

    local tween = TweenService:Create(CFrameValue, info, { Value = CFrame.new(flightTarget) })
    tween:Play()
    tween.Completed:Connect(function()
        CFrameValue:Destroy()
        if vehicle and vehicle.PrimaryPart then
            vehicle:SetPrimaryPartCFrame(targetCFrame)
        end
        if callback then callback() end
    end)
end

Night.SpawnCar = function(carName)
    RemoteSpawnCar:FireServer(carName or "VW Golf Patrol Police")
end

Night.UserConfig = {
    Visuals = {
        ShowNames = false,
        ShowTeam = false,
        ShowHealth = false,
        ShowWanted = false,
        SkeletonESP = false,
        SkeletonColor = {220, 220, 220},
        TextFont = "Cartoon",
        TextSize = 16,
        MaxRange = 1400,
        PlayerTracer = false,
        TracerColor = {255, 255, 255},
        VehicleESP = false,
        AdminESP = true,
        AdminList = "",
    },
    Graphics = {
        XRay = false,
        Fullbright = false,
        RemoveAtmosphere = false,
        GhostMode = false,
        RainbowGhost = false,
        GhostColor = {255, 255, 255},
        PlayerTrail = false,
        TrailColor = {255, 255, 255},
        RandomSkinLoop = false
    },
    CarMods = {
        GodMode = false,
        InfiniteFuel = false,
        GripBoost = false,
        AntiCrashDamage = false,
        EnterLockedCars = false,
        NumberplateText = "NightHub",
        CarFly = false,
        FlyMode = "Normal",
        MobileCarfly = false,
        VehicleFling = false,
        CarFlyKeybind = "X",
        CarFlySpeed = 100,
        VehicleSound = "Default",
        SuspensionHeight = 1.5,
        JumpHeight = 100,
        ForwardPower = 60,
        JumpKeybind = "F2",
        InstantBoostStrength = 2.5,
        AccelerationMultiplier = 2,
        Armor = 0,
        Brakes = 0,
        Engine = 0,
        WheelColor = {255, 255, 255},
        BodyColor = {255, 255, 255}
    },
    Aimbot = {
        Enabled = false,
        MobileButton = false,
        Keybind = "L",
        WallCheck = true,
        ShowFOV = false,
        FOVRadius = 60,
        TargetPart = "Head",
        Prediction = false,
        Smoothing = 2
    },
    SilentAim = {
        Enabled = false,
        Prediction = true,
        WallCheck = false,
        KnockedCheck = true,
        TeamCheck = false,
        IgnoreUntouchable = true,
        ShootSpeed = 100,
        FovEnabled = false,
        FovSize = 150,
    },
    Police = {
        TaserFOVEnabled = false,
        TaserFOVRadius = 150,
    },
}

Night.ConfigManager = {
    Folder = "NightSystem",
    ConfigFile = "NightSystem/Settings.json",
    AutoSave = true,
    SaveDebounce = false,
}

function Night.ConfigManager:InitFolders()
    pcall(function()
        if makefolder and isfolder then
            if not isfolder(self.Folder) then
                makefolder(self.Folder)
            end
            if not isfolder("Night") then
                makefolder("Night")
            end
        end
    end)
end

function Night.ConfigManager:Save(silent)
    if not writefile then return false end
    self:InitFolders()
    local HttpService = game:GetService("HttpService")
    local data = {
        UserConfig = Night.UserConfig,
        Flags = {}
    }
    if OrionLib and OrionLib.Flags then
        for flagName, flagObj in pairs(OrionLib.Flags) do
            pcall(function()
                if flagObj.Save == false then return end
                if flagName == "RadarFarmPosition" or flagName == "AutoSelfReviveDropwDown" then return end
                if flagObj.Type == "Colorpicker" then
                    local c = flagObj.Value
                    if typeof(c) == "Color3" then
                        data.Flags[flagName] = {R = math.floor(c.R * 255), G = math.floor(c.G * 255), B = math.floor(c.B * 255)}
                    end
                elseif flagObj.Type == "Bind" then
                    local b = flagObj.Value
                    if typeof(b) == "EnumItem" then
                        data.Flags[flagName] = b.Name
                    else
                        data.Flags[flagName] = tostring(b)
                    end
                else
                    data.Flags[flagName] = flagObj.Value
                end
            end)
        end
    end

    local success, encoded = pcall(function()
        return HttpService:JSONEncode(data)
    end)

    if success and encoded then
        pcall(function() writefile(self.ConfigFile, encoded) end)
        pcall(function() writefile("Night/" .. tostring(game.GameId) .. ".txt", encoded) end)
        if not silent and OrionLib and OrionLib.MakeNotification then
            OrionLib:MakeNotification({
                Name = "Config Saved",
                Content = "Night System settings saved successfully!",
                Time = 3
            })
        end
        return true
    end
    return false
end

function Night.ConfigManager:TriggerAutoSave()
    if not self.AutoSave then return end
    if self.SaveDebounce then return end
    self.SaveDebounce = true
    task.delay(1.5, function()
        self.SaveDebounce = false
        self:Save(true)
    end)
end

function Night.ConfigManager:Load(silent)
    if not (readfile and isfile) then return false end
    local HttpService = game:GetService("HttpService")
    local raw = nil
    if isfile(self.ConfigFile) then
        pcall(function() raw = readfile(self.ConfigFile) end)
    elseif isfile("Night/" .. tostring(game.GameId) .. ".txt") then
        pcall(function() raw = readfile("Night/" .. tostring(game.GameId) .. ".txt") end)
    end

    if not raw or raw == "" then return false end

    local success, data = pcall(function()
        return HttpService:JSONDecode(raw)
    end)
    if not (success and type(data) == "table") then return false end

    local flagsData = data.Flags or data
    local userCfgData = data.UserConfig

    if type(userCfgData) == "table" then
        for sectionName, sectionTbl in pairs(userCfgData) do
            if type(sectionTbl) == "table" and type(Night.UserConfig[sectionName]) == "table" then
                for k, v in pairs(sectionTbl) do
                    Night.UserConfig[sectionName][k] = v
                end
            end
        end
    end

    local ignoredFlagsOnLoad = {
        RadarFarmPosition = true,
        AutoSelfReviveDropwDown = true,
    }

    if OrionLib and OrionLib.Flags then
        for flagName, val in pairs(flagsData) do
            if not ignoredFlagsOnLoad[flagName] then
                local flagObj = OrionLib.Flags[flagName]
                if flagObj and type(flagObj.Set) == "function" and flagObj.Save ~= false then
                    pcall(function()
                        if flagObj.Type == "Colorpicker" and type(val) == "table" and val.R and val.G and val.B then
                            flagObj:Set(Color3.fromRGB(val.R, val.G, val.B))
                        elseif flagObj.Type == "Bind" and type(val) == "string" then
                            local key = Enum.KeyCode[val]
                            if key then flagObj:Set(key) end
                        else
                            flagObj:Set(val)
                        end
                    end)
                end
            end
        end
    end

    if Night.UserConfig.Aimbot then
        if Night.Aimbot and Night.Aimbot.FOVring then
            Night.Aimbot.FOVring.Visible = Night.UserConfig.Aimbot.ShowFOV
            Night.Aimbot.FOVring.Radius = Night.UserConfig.Aimbot.FOVRadius
        end
    end
    if Night.UserConfig.SilentAim then
        if SilentAim then
            SilentAim.FovEnabled = Night.UserConfig.SilentAim.FovEnabled
            SilentAim.Enabled = Night.UserConfig.SilentAim.Enabled
            SilentAim.FovSize = Night.UserConfig.SilentAim.FovSize
            if SilentAim.FovCircle then
                SilentAim.FovCircle.Visible = SilentAim.FovEnabled
                SilentAim.FovCircle.Radius = SilentAim.FovSize
            end
        end
    end

    if not silent and OrionLib and OrionLib.MakeNotification then
        OrionLib:MakeNotification({
            Name = "Config Loaded",
            Content = "Night System settings loaded successfully!",
            Time = 3
        })
    end
    return true
end


Night.SilentAim = {
    Enabled = Night.UserConfig.SilentAim.Enabled,
    Prediction = Night.UserConfig.SilentAim.Prediction,
    WallCheck = Night.UserConfig.SilentAim.WallCheck,
    KnockedCheck = Night.UserConfig.SilentAim.KnockedCheck,
    TeamCheck = Night.UserConfig.SilentAim.TeamCheck,
    IgnoreUntouchable = Night.UserConfig.SilentAim.IgnoreUntouchable,
    ShootSpeed = Night.UserConfig.SilentAim.ShootSpeed,
    FovEnabled = Night.UserConfig.SilentAim.FovEnabled,
    FovSize = Night.UserConfig.SilentAim.FovSize,
    Remote = RemoteSilentAim,
    ProjectileController = nil,
    SyncController = nil,
    lastShotTime = 0,
    
    FovCircle = Drawing.new("Circle"),
    TracerLine = Drawing.new("Line"),
    HeadDot = Drawing.new("Circle"),
    
    HealthCache = {},
    ActiveDamageIndicators = {},
    
    ignoredTeams = {
        ["ADAC"] = true,
        ["BusCompany"] = true,
        ["FireDepartment"] = true,
        ["Prisoner"] = true,
        ["TruckCompany"] = true,
    },
    SelectedHitParts = { "Head", "HumanoidRootPart" },
}

local SilentAim = Night.SilentAim

for _, obj in pairs(getgc(true)) do
    if type(obj) == "table" then
        if rawget(obj, "projectileIdCounter") then SilentAim.ProjectileController = obj end
        if rawget(obj, "serverTick") then SilentAim.SyncController = obj end
    end
end

SilentAim.FovCircle.Filled = false
SilentAim.FovCircle.Transparency = 1
SilentAim.FovCircle.Thickness = 1
SilentAim.FovCircle.Color = Color3.fromRGB(0, 255, 0)
SilentAim.FovCircle.Visible = SilentAim.FovEnabled

SilentAim.TracerLine.Visible = false
SilentAim.TracerLine.Color = Color3.fromRGB(170, 0, 255)
SilentAim.TracerLine.Thickness = 1.5
SilentAim.TracerLine.Transparency = 1

SilentAim.HeadDot.Visible = false
SilentAim.HeadDot.Color = Color3.fromRGB(170, 0, 255)
SilentAim.HeadDot.Thickness = 1
SilentAim.HeadDot.Radius = 4
SilentAim.HeadDot.Filled = true
SilentAim.HeadDot.Transparency = 1

function SilentAim:SpawnDamageIndicator(targetPart, damage)
    local text = Drawing.new("Text")
    text.Text = "-" .. tostring(math.floor(damage))
    text.Size = 22
    text.Color = Color3.fromRGB(255, 0, 0)
    text.Center = true
    text.Outline = true
    text.Visible = false

    table.insert(self.ActiveDamageIndicators, {
        Drawing = text,
        Target = targetPart,
        SpawnTime = tick(),
        Offset = Vector3.new(math.random(-10, 10)/10, 1.5, math.random(-10, 10)/10)
    })
end

function SilentAim:updateVisuals(target)
    local cam = workspace.CurrentCamera or Camera
    if cam then
        self.FovCircle.Position = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
        self.FovCircle.Radius = self.FovSize
        self.FovCircle.Color = self.Enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 75, 75)
        self.FovCircle.Visible = self.FovEnabled
    end

    if self.Enabled and target and target.Character and (target.Character:FindFirstChild("Head") or target.Character:FindFirstChild("UpperTorso") or target.Character:FindFirstChild("HumanoidRootPart")) then
        local aimPart = target.Character:FindFirstChild("Head") or target.Character:FindFirstChild("UpperTorso") or target.Character:FindFirstChild("HumanoidRootPart")
        local screenPos, onScreen = cam:WorldToViewportPoint(aimPart.Position)
        
        if onScreen and screenPos.Z > 0 then
            local targetVec = Vector2.new(screenPos.X, screenPos.Y)
            self.TracerLine.From = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y)
            self.TracerLine.To = targetVec
            self.TracerLine.Visible = true
            
            self.HeadDot.Position = targetVec
            self.HeadDot.Visible = true
        else
            self.TracerLine.Visible = false
            self.HeadDot.Visible = false
        end
    else
        self.TracerLine.Visible = false
        self.HeadDot.Visible = false
    end
end

function SilentAim:isValidTarget(player)
    if self.IgnoreUntouchable and player.Team and self.ignoredTeams[player.Team.Name] then return false end
    if self.TeamCheck then
        if not player.Team or not LocalPlayer.Team then return true end
        local localTeam = LocalPlayer.Team.Name
        local targetTeam = player.Team.Name
        return (localTeam == "Citizen" and targetTeam == "Police") or
               (localTeam == "Police" and targetTeam == "Citizen")
    end
    return true
end

function SilentAim:isPlayerKnocked(player)
    if not self.KnockedCheck then return false end
    if player and player.Character then
        local humanoid = player.Character:FindFirstChild("Humanoid")
        return humanoid and humanoid.Health <= 25.5
    end
    return false
end

function SilentAim:calculatePrediction(player, targetPartName)
    local targetPart = player.Character and player.Character:FindFirstChild(targetPartName)
    if not targetPart then return nil end
    if not self.Prediction then return targetPart.Position end

    local velocity = targetPart.Velocity or Vector3.new()
    local ping = 0.05
    pcall(function() ping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue() / 1000 end)
    local predictionTime = math.clamp(ping, 0.01, 0.15) 
    return targetPart.Position + (velocity * predictionTime)
end

function SilentAim:isVisible(targetPart)
    if not self.WallCheck then return true end
    local myChar = LocalPlayer.Character
    if not myChar then return false end
    local ignoreList = {myChar, Camera}
    local targetChar = targetPart.Parent
    local vehicle = nil
    local hum = targetChar:FindFirstChildOfClass("Humanoid")
    if hum and hum.SeatPart then
        local current = hum.SeatPart
        while current ~= Workspace and current.Parent ~= nil do
            if current:IsA("Model") then vehicle = current break end
            current = current.Parent
        end
        if not vehicle then vehicle = hum.SeatPart.Parent end
    end
    if vehicle then table.insert(ignoreList, vehicle) end
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = ignoreList
    params.IgnoreWater = true
    local result = Workspace:Raycast(Camera.CFrame.Position, targetPart.Position - Camera.CFrame.Position, params)
    return (not result or result.Instance:IsDescendantOf(targetChar) or (vehicle and result.Instance:IsDescendantOf(vehicle)))
end

function SilentAim:getNearestTarget()
    local closestPlayer = nil
    local shortestDistance = self.FovSize

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and self:isValidTarget(player) and not self:isPlayerKnocked(player) then
            for _, partName in ipairs(self.SelectedHitParts) do
                local targetPart = player.Character:FindFirstChild(partName)
                if targetPart and self:isVisible(targetPart) then
                    local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                    if onScreen and screenPos.Z > 0 then
                        local distance = (Vector2.new(screenPos.X, screenPos.Y) - self.FovCircle.Position).Magnitude
                        if distance <= self.FovSize and distance < shortestDistance then
                            shortestDistance = distance
                            closestPlayer = player
                        end
                    end
                end
            end
        end
    end
    return closestPlayer
end

function SilentAim:fireAtTarget(targetPlayer)
    if not targetPlayer or not targetPlayer.Character then return end
    if self:isPlayerKnocked(targetPlayer) then return end

    local currentTime = tick()
    if currentTime - self.lastShotTime < (1 / self.ShootSpeed) then return end

    local targetPart = nil
    local predictedPos = nil
    for _, partName in ipairs(self.SelectedHitParts) do
        local part = targetPlayer.Character:FindFirstChild(partName)
        if part then
            predictedPos = self:calculatePrediction(targetPlayer, partName)
            if predictedPos then
                targetPart = part
                break
            end
        end
    end

    if not targetPart or not predictedPos then return end
    
    local direction = (predictedPos - Camera.CFrame.Position).Unit

    if self.ProjectileController and self.SyncController and self.Remote then
        pcall(function()
            local id = self.ProjectileController.projectileIdCounter
            self.Remote:FireServer(id, direction, true, self.SyncController:getServerTick())
            self.ProjectileController.projectileIdCounter = self.ProjectileController.projectileIdCounter + 1
        end)
        self.lastShotTime = currentTime

        self.FovCircle.Color = Color3.fromRGB(170, 0, 255)
        task.delay(0.1, function()
            self.FovCircle.Color = self.Enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
        end)
    end
end

RunService.RenderStepped:Connect(function()
    local target = nil
    if SilentAim.Enabled then
        target = SilentAim:getNearestTarget()
        if target then SilentAim:fireAtTarget(target) end
    end
    SilentAim:updateVisuals(target)

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local hum = player.Character:FindFirstChild("Humanoid")
            local head = player.Character:FindFirstChild("Head")
            if hum and head then
                local currentHealth = hum.Health
                local lastHealth = SilentAim.HealthCache[player.Name]
                if lastHealth and currentHealth < lastHealth then
                    local damage = lastHealth - currentHealth
                    if damage > 0.5 then
                        SilentAim:SpawnDamageIndicator(head, damage)
                    end
                end
                SilentAim.HealthCache[player.Name] = currentHealth
            end
        end
    end

    for i = #SilentAim.ActiveDamageIndicators, 1, -1 do
        local ind = SilentAim.ActiveDamageIndicators[i]
        local lifeTime = tick() - ind.SpawnTime
        if lifeTime > 0.2 then
            ind.Drawing:Remove()
            table.remove(SilentAim.ActiveDamageIndicators, i)
        else
            if ind.Target and ind.Target.Parent then
                local pos, onScreen = Camera:WorldToViewportPoint(ind.Target.Position + ind.Offset)
                if onScreen then
                    ind.Drawing.Position = Vector2.new(pos.X, pos.Y - (lifeTime * 200))
                    ind.Drawing.Visible = true
                else
                    ind.Drawing.Visible = false
                end
            else
                ind.Drawing:Remove()
                table.remove(SilentAim.ActiveDamageIndicators, i)
            end
        end
    end
end)

Night.Aimbot = {
    FOVring = Drawing.new("Circle"),
    aimbotGui = nil,
    vehicleCache = {},
    cacheTime = {},
    CACHE_DURATION = 0.5,
    lastFOV = 0,
    lastSilentFOV = 0,
    lastUpdate = 0,
    updateInterval = 1/60,
}

local Aimbot = Night.Aimbot
Aimbot.FOVring.Visible = Night.UserConfig.Aimbot.ShowFOV
Aimbot.FOVring.Thickness = 2
Aimbot.FOVring.Radius = Night.UserConfig.Aimbot.FOVRadius
Aimbot.FOVring.Transparency = 1
Aimbot.FOVring.Color = Color3.fromRGB(127, 255, 0)

function Aimbot:getVehicle(character)
    local now = tick()
    local cached = self.vehicleCache[character]
    if cached and self.cacheTime[character] and (now - self.cacheTime[character]) < self.CACHE_DURATION then
        return cached
    end
    local hum = character:FindFirstChildOfClass("Humanoid")
    local vehicle = nil
    if hum and hum.SeatPart then
        local current = hum.SeatPart
        while current ~= Workspace and current.Parent ~= nil do
            if current:IsA("Model") then
                vehicle = current
                break
            end
            current = current.Parent
        end
        if not vehicle then
            vehicle = hum.SeatPart.Parent
        end
    end
    self.vehicleCache[character] = vehicle
    self.cacheTime[character] = now
    return vehicle
end

function Aimbot:isVisible(targetPart)
    if not Night.UserConfig.Aimbot.WallCheck then return true end
    local myChar = LocalPlayer.Character
    if not myChar then return false end
    local ignoreList = {myChar, Camera}
    local targetChar = targetPart.Parent
    local vehicle = self:getVehicle(targetChar)
    if vehicle then table.insert(ignoreList, vehicle) end
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = ignoreList
    params.IgnoreWater = true
    local result = Workspace:Raycast(Camera.CFrame.Position, targetPart.Position - Camera.CFrame.Position, params)
    return (not result or result.Instance:IsDescendantOf(targetChar) or (vehicle and result.Instance:IsDescendantOf(vehicle)))
end

function Aimbot:toggle(state)
    Night.UserConfig.Aimbot.Enabled = state
    if self.FOVring then
        self.FOVring.Color = state and Color3.fromRGB(127, 255, 0) or Color3.fromRGB(255, 75, 75)
        self.FOVring.Visible = Night.UserConfig.Aimbot.ShowFOV
    end
end

function Aimbot:createMobileGui()
    if self.aimbotGui then return end
    self.aimbotGui = Instance.new("ScreenGui")
    self.aimbotGui.ResetOnSpawn = false
    self.aimbotGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    local btn = Instance.new("TextButton", self.aimbotGui)
    btn.Size = UDim2.new(0, 200, 0, 50)
    btn.Position = UDim2.new(0.5, -100, 0.8, 0)
    btn.Text = Night.UserConfig.Aimbot.Enabled and "Aimbot: ON" or "Aimbot: OFF"
    btn.BackgroundColor3 = Night.UserConfig.Aimbot.Enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", btn)
    btn.MouseButton1Click:Connect(function()
        Aimbot:toggle(not Night.UserConfig.Aimbot.Enabled)
        btn.Text = Night.UserConfig.Aimbot.Enabled and "Aimbot: ON" or "Aimbot: OFF"
        btn.BackgroundColor3 = Night.UserConfig.Aimbot.Enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    end)
end

function Aimbot:getClosest()
    local target, shortest = nil, math.huge
    local center = Camera.ViewportSize / 2
    local playerList = Players:GetPlayers()
    for _, p in pairs(playerList) do
        if p ~= LocalPlayer and p.Character then
            local part = p.Character:FindFirstChild(Night.UserConfig.Aimbot.TargetPart)
            if part then
                local pos, onScreen = Camera:WorldToViewportPoint(part.Position)
                local dist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                if onScreen and dist <= Night.UserConfig.Aimbot.FOVRadius and self:isVisible(part) then
                    if dist < shortest then
                        shortest = dist
                        target = p
                    end
                end
            end
        end
    end
    return target
end

Aimbot.lastFOV = Night.UserConfig.Aimbot.FOVRadius
Aimbot.lastSilentFOV = SilentAim.FovSize

RunService.Heartbeat:Connect(function()
    local now = tick()
    local center = Camera.ViewportSize / 2
    Aimbot.FOVring.Position = center
    Aimbot.FOVring.Visible = Night.UserConfig.Aimbot.ShowFOV
    Aimbot.FOVring.Color = Night.UserConfig.Aimbot.Enabled and Color3.fromRGB(127, 255, 0) or Color3.fromRGB(255, 75, 75)
    if Aimbot.lastFOV ~= Night.UserConfig.Aimbot.FOVRadius then
        Aimbot.FOVring.Radius = Night.UserConfig.Aimbot.FOVRadius
        Aimbot.lastFOV = Night.UserConfig.Aimbot.FOVRadius
    end
    if Night.UserConfig.Aimbot.Enabled and (now - Aimbot.lastUpdate) >= Aimbot.updateInterval then
        Aimbot.lastUpdate = now
        if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) or Night.UserConfig.Aimbot.MobileButton then
            local target = Aimbot:getClosest()
            if target and target.Character then
                local part = target.Character:FindFirstChild(Night.UserConfig.Aimbot.TargetPart)
                if part then
                    local aimPos = part.Position
                    if Night.UserConfig.Aimbot.Prediction then
                        local vel = part.AssemblyLinearVelocity
                        local veh = Aimbot:getVehicle(target.Character)
                        if veh and veh.PrimaryPart then vel = veh.PrimaryPart.AssemblyLinearVelocity end
                        aimPos = aimPos + (vel * 0.0575)
                    end
                    local smoothing = (11 - Night.UserConfig.Aimbot.Smoothing) / 10
                    Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, aimPos), smoothing)
                end
            end
        end
    end
end)

if Night.UserConfig.Aimbot.MobileButton then
    Aimbot:createMobileGui()
end



local fn, v, tbl, fn2, fn3, tbl2
local Remotes = {}
do
	local HttpService = game:GetService("HttpService")
	local clock = typeof(os) == "table" and typeof(os.clock) == "function" and os.clock or tick

	local ok, result = pcall(function()
		if identifyexecutor then
			return (identifyexecutor())
		end
		if getexecutorname then
			return (getexecutorname())
		end
		return nil
	end)

	ok = ok and type(result) == "string" and result ~= ""
	if not ok then
		result = "Unknown"
	end

	local isXeno = string.find(string.lower(result), "xeno", 1, true) ~= nil
	local maxTime = 0.008
	local maxIter = 400
	local lastClock = clock()
	local iterState = 0

	if isXeno then
		fn = function()
			iterState += 1
			if iterState >= maxIter or clock() - lastClock >= maxTime then
				task.wait()
				lastClock = clock()
				iterState = 0
			end
		end
	else
		fn = function() end
	end

	local bestCount = 0
	local bestFolder = nil
	for _, child in pairs(ReplicatedStorage:GetChildren()) do
		if child:IsA("Folder") and #child:GetChildren() > 0 and child:GetChildren()[1]:IsA("RemoteEvent") then
			local count = #child:GetChildren()
			if bestCount < count then
				bestCount = count
				bestFolder = child
			end
		end
	end

	v = bestFolder or RemoteFolder
	tbl = {}

	local function getConsts(f)
		if not f or (type(f) ~= "function" and type(f) ~= "proto") then
			return {}
		end
		local ok2, res2 = pcall(debug.getconstants, f)
		return ok2 and res2 or {}
	end

	local function getProtos(f)
		if not f or type(f) ~= "function" then
			return {}
		end
		local ok2, res2 = pcall(debug.getprotos, f)
		return ok2 and res2 or {}
	end

	fn2 = function(f)
		for _, c in pairs(getConsts(f)) do
			if type(c) == "string" and c:match("^%w+-%w+-%w+-%w+-%w+$") then
				return c
			end
		end
		for _, p in pairs(getProtos(f)) do
			local found = fn2(p)
			if found then
				return found
			end
		end
		return nil
	end

	local function getAllUUIDs(f, acc)
		local list = acc or {}
		for _, c in pairs(getConsts(f)) do
			if type(c) == "string" and c:match("^%w+-%w+-%w+-%w+-%w+$") then
				list[#list + 1] = c
			end
		end
		for _, p in pairs(getProtos(f)) do
			getAllUUIDs(p, list)
		end
		return list
	end

	local function scanRemotes()
		local found = {
			ProjectileUUID = nil,
			AutoTaserUUID = nil,
			RadarFarmUUID = nil,
			AutoReloadUUID = nil,
			BuyItemUUID = nil,
			SellItemUUID = nil,
			DealerBuyAmmoUUID = nil,
			InteractableUUID = nil,
			UncuffUUID = nil,
			UnholdUUID = nil,
		}

		local gcList = getgc(true)
		for _, item in next, gcList, nil do
			fn()
			if type(item) == "table" then
				if not found.ProjectileUUID and rawget(item, "projectileIdCounter") and rawget(item, "networkSynchronizationController") then
					found.ProjectileUUID = fn2(item.fireProjectile)
				end
				if not found.InteractableUUID and rawget(item, "Interactable") and type(rawget(item, "Interactable")) == "table" then
					found.InteractableUUID = fn2(item.Interactable.interact)
				end
				if not found.AutoTaserUUID and rawget(item, "onDeployInput") and rawget(item, "onDeployEventServer") then
					found.AutoTaserUUID = fn2(item.onStart)
				end
				if not found.RadarFarmUUID and rawget(item, "onMeasureInput") and rawget(item, "onMeasureEventServer") then
					found.RadarFarmUUID = fn2(item.onMeasureInput)
				end
				if not found.AutoReloadUUID and rawget(item, "onReloadInput") and rawget(item, "onShootInput") then
					found.AutoReloadUUID = fn2(item.onReloadInput)
				end
				if not found.UnholdUUID and rawget(item, "cuffCharacter") and rawget(item, "unholdCharacter") then
					local uuids = getAllUUIDs(item.onStart)
					found.UncuffUUID = uuids[1]
					found.UnholdUUID = uuids[2] or uuids[1]
				end
			end

			if type(item) == "function" and islclosure(item) then
				local consts = getConsts(item)
				local hasDealer = false
				for _, c in pairs(consts) do
					if type(c) == "string" and c == "crimeBossBuyMultiplier" then
						hasDealer = true
						break
					end
				end
				if hasDealer then
					local protos = getProtos(item)
					local gotSell = false
					local gotAmmo = false
					for _, p in pairs(protos) do
						local pConsts = getConsts(p)
						local hasName, hasMenu, hasPass, uuidVal = false, false, false, nil
						for _, pc in pairs(pConsts) do
							if type(pc) == "string" then
								if pc == "name" then hasName = true end
								if pc == "showItemStoreMenu" then hasMenu = true end
								if pc == "gamepassRequired" then hasPass = true end
								if pc:match("^%w+-%w+-%w+-%w+-%w+$") then uuidVal = pc end
							end
						end
						if hasName and hasMenu and uuidVal then
							if hasPass then
								found.BuyItemUUID = uuidVal
							elseif not gotSell then
								found.SellItemUUID = uuidVal
								gotSell = true
							elseif not gotAmmo then
								found.DealerBuyAmmoUUID = uuidVal
								gotAmmo = true
							end
						end
					end
				end
			end
		end

		local MoneyCollectInteractable = nil
		local ItemCollectInteractable = nil
		local HandcuffsInteractable = nil

		pcall(function()
			local reflect = require(ReplicatedStorage.Code.rbxts_include.node_modules["@flamework"].core.out).Reflect
			local function findInteractableCode(targetName)
				for _, item in next, gcList, nil do
					fn()
					if type(item) == "table" then
						local id = nil
						pcall(function()
							local mt = getmetatable(item)
							if type(mt) ~= "table" then return end
							local toStr = rawget(mt, "__tostring")
							if not toStr then return end
							local ok2, res2 = pcall(toStr, item)
							if ok2 and res2 == targetName then
								id = reflect.getMetadata(item, "identifier")
							end
						end)
						if id then return id end
					end
				end
				return nil
			end
			MoneyCollectInteractable = findInteractableCode("MoneyCollectInteractable")
			ItemCollectInteractable = findInteractableCode("ItemCollectInteractable")
			HandcuffsInteractable = findInteractableCode("HandcuffsInteractable")
		end)

		return {
			SilentAimShoot = found.ProjectileUUID,
			AutoReload = found.AutoReloadUUID,
			AutoCollect = found.InteractableUUID,
			Cuff = found.InteractableUUID,
			Detain = found.UnholdUUID,
			Uncuff = found.UncuffUUID,
			RadarFarm = found.RadarFarmUUID,
			AutoTaser = found.AutoTaserUUID,
			DealerBuy = found.BuyItemUUID,
			DealerSell = found.SellItemUUID,
			DealerBuyAmmo = found.DealerBuyAmmoUUID,
			MoneyCode = MoneyCollectInteractable,
			ItemCode = ItemCollectInteractable,
			HandcuffsCode = HandcuffsInteractable,
			RemoteFolder = v and v.Name or nil,
		}
	end

	pcall(function()
		local scanned = scanRemotes()
		for k, val in pairs(scanned) do
			tbl[k] = val
		end
	end)

	if not v and tbl.RemoteFolder then
		v = ReplicatedStorage:WaitForChild(tbl.RemoteFolder, 10)
	end

	fn3 = function(s4)
		if s4 == "startShift" then return RemoteChangeJob end
		if s4 == "spawnVehicle" then return RemoteSpawnCar end
		if not s4 or not v then
			return nil
		end
		return v:FindFirstChild(s4) or v:WaitForChild(s4, 5)
	end

	tbl2 = {
		SilentAimShoot = fn3(tbl.SilentAimShoot) or RemoteSilentAim,
		AutoCollect = fn3(tbl.AutoCollect),
		RadarFarm = fn3(tbl.RadarFarm) or RemoteRadarFarm,
		AutoTaser = fn3(tbl.AutoTaser) or RemoteAutoTaser,
		AutoReload = fn3(tbl.AutoReload),
		AntiCheatBlock = tbl.AntiCheatBlock,
		DealerBuy = fn3(tbl.DealerBuy),
		DealerBuyAmmo = fn3(tbl.DealerBuyAmmo),
		DealerSell = fn3(tbl.DealerSell),
		Cuff = fn3(tbl.Cuff),
		Detain = fn3(tbl.Detain) or fn3("f7f2148f-d07b-4df6-af31-4a545128baff"),
	}
	Remotes.Punch = fn3(tbl.Punch)
end

Night.GunMods = {
    running = false,
    recoilConnection = nil,
    autoReloadConnection = nil,
    CrosshairSize = 25,
    connectionsCrosshair = {},
    aimFovValue = 40,
    aimFovConnection = nil,
    trackedWeapons = {"G36", "Glock 17", "MP5", "M4 Carabine", "Sniper", "M58B Shotgun"},
    soundOptions = {"Default", "Ak47", "M1911", "Glock", "MP40", "P90", "Pixel", "Undertale"},
    soundIds = {
        ["Ak47"] = "rbxassetid://5910000043",
        ["M1911"] = "rbxassetid://1136243671",
        ["Glock"] = "rbxassetid://6581933860",
        ["MP40"] = "rbxassetid://103807799095792",
        ["P90"] = "rbxassetid://87534588983395",
        ["Pixel"] = "rbxassetid://7380537613",
        ["Undertale"] = "rbxassetid://438149153"
    },
    originalSoundsGun = {},
    soundObjects = {},
}

function Night.GunMods:initializeSoundsGun()
    for _, sound in pairs(game:GetDescendants()) do
        if sound:IsA("Sound") then
            local currentId = sound.SoundId
            if currentId == "rbxassetid://801226154" or currentId == "rbxassetid://801217802" then
                self.originalSoundsGun[sound] = currentId
                self.soundObjects[sound] = true
            end
        end
    end
end

function Night.GunMods:changeSoundsGun(selectedSound)
    local newSoundId = self.soundIds[selectedSound]
    for sound, originalId in pairs(self.originalSoundsGun) do
        if sound and sound.Parent then
            if selectedSound == "Default" then
                sound.SoundId = originalId
            else
                sound.SoundId = newSoundId
            end
        end
    end
end

Night.GunMods:initializeSoundsGun()

function Night.GunMods:updateCrosshair(tool)
    if tool then
        tool:SetAttribute("CrosshairSize", self.CrosshairSize)
    end
end

function Night.GunMods:setupToolListeners()
    for _, connection in pairs(self.connectionsCrosshair) do
        connection:Disconnect()
    end
    self.connectionsCrosshair = {}
    LocalPlayer.CharacterAdded:Connect(function(character)
        self.connectionsCrosshair.toolAdded = character.ChildAdded:Connect(function(child)
            if child:IsA("Tool") then
                self:updateCrosshair(child)
            end
        end)
        for _, tool in pairs(character:GetChildren()) do
            if tool:IsA("Tool") then
                self:updateCrosshair(tool)
            end
        end
    end)
    if LocalPlayer.Character then
        for _, tool in pairs(LocalPlayer.Character:GetChildren()) do
            if tool:IsA("Tool") then
                self:updateCrosshair(tool)
            end
        end
        self.connectionsCrosshair.toolAdded = LocalPlayer.Character.ChildAdded:Connect(function(child)
            if child:IsA("Tool") then
                self:updateCrosshair(child)
            end
        end)
    end
end

Night.WeaponColor1 = {
    ghostColor = Color3.fromRGB(0, 170, 255),
    rainbowEnabled = false,
    enabled = false,
    savedColors = {},
    targetParts = {"Body", "MeshPart", "Base1", "BrigherBlack", "BaseTop"},
    targetTools = {"Glock 17", "MP5", "M58B Shotgun", "M4 Carbine", "G36", "Sniper"},
    hue = 0,
    rainbowConnection = nil,
    checkConnection = nil,
}

function Night.WeaponColor1:HSVToRGB(hue)
    return Color3.fromHSV(hue % 1, 1, 1)
end

function Night.WeaponColor1:isTargetTool(toolName)
    for _, name in ipairs(self.targetTools) do
        if toolName:lower():find(name:lower()) then return true end
    end
    return false
end

function Night.WeaponColor1:findTargetTools(character)
    local tools = {}
    if not character then return tools end
    for _, child in pairs(character:GetChildren()) do
        if child:IsA("Tool") and self:isTargetTool(child.Name) then
            table.insert(tools, child)
        end
    end
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    if backpack then
        for _, tool in pairs(backpack:GetChildren()) do
            if tool:IsA("Tool") and self:isTargetTool(tool.Name) then
                table.insert(tools, tool)
            end
        end
    end
    return tools
end

function Night.WeaponColor1:findTargetParts(tool)
    local parts = {}
    for _, partName in ipairs(self.targetParts) do
        local part = tool:FindFirstChild(partName)
        if part and part:IsA("BasePart") then
            table.insert(parts, part)
        end
    end
    for _, descendant in pairs(tool:GetDescendants()) do
        if descendant:IsA("BasePart") then
            for _, partName in ipairs(self.targetParts) do
                if descendant.Name:lower():find(partName:lower()) then
                    table.insert(parts, descendant)
                    break
                end
            end
        end
    end
    return parts
end

function Night.WeaponColor1:applyColor(parts, color)
    for _, part in ipairs(parts) do
        if not self.savedColors[part] then
            self.savedColors[part] = {Color = part.Color, Material = part.Material}
        end
        part.Color = color
        part.Material = Enum.Material.ForceField
    end
end

function Night.WeaponColor1:restoreOriginal(parts)
    for _, part in ipairs(parts) do
        if self.savedColors[part] then
            part.Color = self.savedColors[part].Color
            part.Material = self.savedColors[part].Material
            self.savedColors[part] = nil
        end
    end
end

function Night.WeaponColor1:checkAndApply(color)
    if not self.enabled then return end
    local character = LocalPlayer.Character
    if not character then return end
    local tools = self:findTargetTools(character)
    for _, tool in ipairs(tools) do
        local parts = self:findTargetParts(tool)
        self:applyColor(parts, color)
    end
end

function Night.WeaponColor1:checkAndRestore()
    local character = LocalPlayer.Character
    if not character then return end
    local tools = self:findTargetTools(character)
    for _, tool in ipairs(tools) do
        local parts = self:findTargetParts(tool)
        self:restoreOriginal(parts)
    end
end

function Night.WeaponColor1:startRainbow()
    if self.rainbowConnection then self.rainbowConnection:Disconnect() end
    self.rainbowEnabled = true
    self.rainbowConnection = RunService.Heartbeat:Connect(function(deltaTime)
        if not self.enabled then return end
        self.hue = (self.hue + deltaTime / 2) % 1
        self:checkAndApply(self:HSVToRGB(self.hue))
    end)
end

function Night.WeaponColor1:stopRainbow()
    if self.rainbowConnection then
        self.rainbowConnection:Disconnect()
        self.rainbowConnection = nil
    end
    self.rainbowEnabled = false
end

function Night.WeaponColor1:startContinuousCheck()
    if self.checkConnection then self.checkConnection:Disconnect() end
    self.checkConnection = RunService.Heartbeat:Connect(function()
        if not self.enabled then return end
        if self.rainbowEnabled then return end
        self:checkAndApply(self.ghostColor)
    end)
end

function Night.WeaponColor1:toggle(state)
    self.enabled = state
    if self.enabled then
        if self.rainbowEnabled then
            self:startRainbow()
        else
            self:startContinuousCheck()
            self:checkAndApply(self.ghostColor)
        end
    else
        self:stopRainbow()
        if self.checkConnection then
            self.checkConnection:Disconnect()
            self.checkConnection = nil
        end
        self:checkAndRestore()
    end
end

function Night.WeaponColor1:onCharacterAdded(character)
    if self.enabled then
        wait(1)
        if self.rainbowEnabled then
            self:startRainbow()
        else
            self:startContinuousCheck()
            self:checkAndApply(self.ghostColor)
        end
    end
    character.ChildAdded:Connect(function(child)
        if child:IsA("Tool") and self:isTargetTool(child.Name) and self.enabled then
            if not self.rainbowEnabled then
                self:checkAndApply(self.ghostColor)
            end
        end
    end)
end

Night.WeaponColor2 = {
    ghostColor = Color3.fromRGB(0, 170, 255),
    rainbowEnabled = false,
    enabled = false,
    savedColors = {},
    targetParts = {"Scope", "Stock", "Base2", "DarkerBlack", "BaseDown"},
    targetTools = {"Glock 17", "MP5", "M58B Shotgun", "M4 Carbine", "G36", "Sniper"},
    hue = 0,
    rainbowConnection = nil,
    checkConnection = nil,
}

function Night.WeaponColor2:HSVToRGB(hue)
    return Color3.fromHSV(hue % 1, 1, 1)
end

function Night.WeaponColor2:isTargetTool(toolName)
    for _, name in ipairs(self.targetTools) do
        if toolName:lower():find(name:lower()) then return true end
    end
    return false
end

function Night.WeaponColor2:findTargetTools(character)
    local tools = {}
    if not character then return tools end
    for _, child in pairs(character:GetChildren()) do
        if child:IsA("Tool") and self:isTargetTool(child.Name) then
            table.insert(tools, child)
        end
    end
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    if backpack then
        for _, tool in pairs(backpack:GetChildren()) do
            if tool:IsA("Tool") and self:isTargetTool(tool.Name) then
                table.insert(tools, tool)
            end
        end
    end
    return tools
end

function Night.WeaponColor2:findTargetParts(tool)
    local parts = {}
    for _, partName in ipairs(self.targetParts) do
        local part = tool:FindFirstChild(partName)
        if part and part:IsA("BasePart") then
            table.insert(parts, part)
        end
    end
    for _, descendant in pairs(tool:GetDescendants()) do
        if descendant:IsA("BasePart") then
            for _, partName in ipairs(self.targetParts) do
                if descendant.Name:lower():find(partName:lower()) then
                    table.insert(parts, descendant)
                    break
                end
            end
        end
    end
    return parts
end

function Night.WeaponColor2:applyColor(parts, color)
    for _, part in ipairs(parts) do
        if not self.savedColors[part] then
            self.savedColors[part] = {Color = part.Color, Material = part.Material}
        end
        part.Color = color
        part.Material = Enum.Material.ForceField
    end
end

function Night.WeaponColor2:restoreOriginal(parts)
    for _, part in ipairs(parts) do
        if self.savedColors[part] then
            part.Color = self.savedColors[part].Color
            part.Material = self.savedColors[part].Material
            self.savedColors[part] = nil
        end
    end
end

function Night.WeaponColor2:checkAndApply(color)
    if not self.enabled then return end
    local character = LocalPlayer.Character
    if not character then return end
    local tools = self:findTargetTools(character)
    for _, tool in ipairs(tools) do
        local parts = self:findTargetParts(tool)
        self:applyColor(parts, color)
    end
end

function Night.WeaponColor2:checkAndRestore()
    local character = LocalPlayer.Character
    if not character then return end
    local tools = self:findTargetTools(character)
    for _, tool in ipairs(tools) do
        local parts = self:findTargetParts(tool)
        self:restoreOriginal(parts)
    end
end

function Night.WeaponColor2:startRainbow()
    if self.rainbowConnection then self.rainbowConnection:Disconnect() end
    self.rainbowEnabled = true
    self.rainbowConnection = RunService.Heartbeat:Connect(function(deltaTime)
        if not self.enabled then return end
        self.hue = (self.hue + deltaTime / 2) % 1
        self:checkAndApply(self:HSVToRGB(self.hue))
    end)
end

function Night.WeaponColor2:stopRainbow()
    if self.rainbowConnection then
        self.rainbowConnection:Disconnect()
        self.rainbowConnection = nil
    end
    self.rainbowEnabled = false
end

function Night.WeaponColor2:startContinuousCheck()
    if self.checkConnection then self.checkConnection:Disconnect() end
    self.checkConnection = RunService.Heartbeat:Connect(function()
        if not self.enabled then return end
        if self.rainbowEnabled then return end
        self:checkAndApply(self.ghostColor)
    end)
end

function Night.WeaponColor2:toggle(state)
    self.enabled = state
    if self.enabled then
        if self.rainbowEnabled then
            self:startRainbow()
        else
            self:startContinuousCheck()
            self:checkAndApply(self.ghostColor)
        end
    else
        self:stopRainbow()
        if self.checkConnection then
            self.checkConnection:Disconnect()
            self.checkConnection = nil
        end
        self:checkAndRestore()
    end
end

function Night.WeaponColor2:onCharacterAdded(character)
    if self.enabled then
        wait(1)
        if self.rainbowEnabled then
            self:startRainbow()
        else
            self:startContinuousCheck()
            self:checkAndApply(self.ghostColor)
        end
    end
    character.ChildAdded:Connect(function(child)
        if child:IsA("Tool") and self:isTargetTool(child.Name) and self.enabled then
            if not self.rainbowEnabled then
                self:checkAndApply(self.ghostColor)
            end
        end
    end)
end


local Window = OrionLib:MakeWindow({
    Name = "Night System",
    SaveConfig = false,
    ConfigFolder = "Night"
})

Night.Tabs = {
    Aimbot    = Window:MakeTab({Name = "Aimbot", Icon = "rbxassetid://98232288704820"}),
    SilentAim = Window:MakeTab({Name = "Silent Aim", Icon = "rbxassetid://138025957139303"}),
    ESP       = Window:MakeTab({Name = "ESP", Icon = "rbxassetid://140499484856973"}),
    Police    = Window:MakeTab({Name = "Police", Icon = "rbxassetid://89652930608206"}),
    GunMods   = Window:MakeTab({Name = "Gun Mods", Icon = "rbxassetid://105216135416947"}),
    Visual    = Window:MakeTab({Name = "Visual", Icon = "rbxassetid://126907380304420"}),
    Vehicle   = Window:MakeTab({Name = "Car Mods", Icon = "rbxassetid://114187792807811"}),
    Teleport  = Window:MakeTab({Name = "Teleport", Icon = "rbxassetid://123690431658937"}),
    Misc      = Window:MakeTab({Name = "Misc", Icon = "rbxassetid://6031093549"}),
    Info      = Window:MakeTab({Name = "Info", Icon = "rbxassetid://6031093549"}),
    Autofarm  = Window:MakeTab({Name = "Autofarm", Icon = "rbxassetid://121450316772412"}),
    Bypass    = Window:MakeTab({Name = "Bypass", Icon = "rbxassetid://10723346959"}),
}

local AimbotTab = Night.Tabs.Aimbot
local SilentAimTab = Night.Tabs.SilentAim
local ESPTab = Night.Tabs.ESP
local VisualTab = Night.Tabs.Visual
local VehicleTab = Night.Tabs.Vehicle
local TeleportTab = Night.Tabs.Teleport
local PoliceTab = Night.Tabs.Police
local GunModTab = Night.Tabs.GunMods
local MiscTab = Night.Tabs.Misc
local InfoTab = Night.Tabs.Info
local AutofarmTab = Night.Tabs.Autofarm
local BypassTab = Night.Tabs.Bypass

AimbotTab:AddSection({Name = "Aimbot Settings"})
AimbotTab:AddToggle({Name = "Enable Aimbot", Default = Night.UserConfig.Aimbot.Enabled, Save = true, Flag = "AimbotEnabled", Callback = function(v) Night.Aimbot:toggle(v) end})
AimbotTab:AddToggle({Name = "Mobile Button", Default = Night.UserConfig.Aimbot.MobileButton, Save = true, Flag = "AimbotMobile", Callback = function(v)
    Night.UserConfig.Aimbot.MobileButton = v
    if v then Night.Aimbot:createMobileGui() elseif Night.Aimbot.aimbotGui then Night.Aimbot.aimbotGui:Destroy(); Night.Aimbot.aimbotGui = nil end
end})
AimbotTab:AddBind({Name = "Aimbot Keybind", Default = Enum.KeyCode[Night.UserConfig.Aimbot.Keybind] or Enum.KeyCode.L, Hold = false, Callback = function() Night.Aimbot:toggle(not Night.UserConfig.Aimbot.Enabled) end})
AimbotTab:AddSection({Name = "Visibility & Checks"})
AimbotTab:AddToggle({Name = "Wall Check", Default = Night.UserConfig.Aimbot.WallCheck, Save = true, Flag = "AimbotWallCheck", Callback = function(v) Night.UserConfig.Aimbot.WallCheck = v end})
AimbotTab:AddToggle({Name = "Show FOV Circle", Default = Night.UserConfig.Aimbot.ShowFOV, Save = true, Flag = "AimbotShowFOV", Callback = function(v)
    Night.UserConfig.Aimbot.ShowFOV = v
    if Night.Aimbot and Night.Aimbot.FOVring then
        Night.Aimbot.FOVring.Visible = v
    end
    if Night.ConfigManager and Night.ConfigManager.AutoSave then
        Night.ConfigManager:TriggerAutoSave()
    end
end})
AimbotTab:AddSlider({Name = "FOV Radius", Min = 10, Max = 500, Default = Night.UserConfig.Aimbot.FOVRadius, Color = Color3.fromRGB(127, 255, 0), Save = true, Flag = "AimbotFOVRadius", Callback = function(v)
    Night.UserConfig.Aimbot.FOVRadius = v
    if Night.Aimbot and Night.Aimbot.FOVring then
        Night.Aimbot.FOVring.Radius = v
    end
    if Night.ConfigManager and Night.ConfigManager.AutoSave then
        Night.ConfigManager:TriggerAutoSave()
    end
end})
AimbotTab:AddSection({Name = "Targeting"})
AimbotTab:AddDropdown({Name = "Target Part", Options = {"Head", "HumanoidRootPart"}, Default = Night.UserConfig.Aimbot.TargetPart, Save = true, Flag = "AimbotTargetPart", Callback = function(v) Night.UserConfig.Aimbot.TargetPart = v end})
AimbotTab:AddToggle({Name = "Prediction", Default = Night.UserConfig.Aimbot.Prediction, Save = true, Flag = "AimbotPrediction", Callback = function(v) Night.UserConfig.Aimbot.Prediction = v end})
AimbotTab:AddSlider({Name = "Smoothing (1 = stark, 10 = schwach)", Min = 1, Max = 10, Default = Night.UserConfig.Aimbot.Smoothing, Color = Color3.fromRGB(137, 207, 240), Save = true, Flag = "AimbotSmoothing", Callback = function(v) Night.UserConfig.Aimbot.Smoothing = v end})

SilentAimTab:AddSection({Name = "Silent Aim Controls"})
SilentAimTab:AddToggle({Name = "Enable Silent Aim", Default = Night.UserConfig.SilentAim.Enabled, Save = true, Flag = "SilentAimEnabled", Callback = function(v) SilentAim.Enabled = v; Night.UserConfig.SilentAim.Enabled = v end})
SilentAimTab:AddToggle({Name = "Prediction", Default = Night.UserConfig.SilentAim.Prediction, Save = true, Flag = "SilentAimPrediction", Callback = function(v) SilentAim.Prediction = v; Night.UserConfig.SilentAim.Prediction = v end})
SilentAimTab:AddToggle({Name = "Wall Check", Default = Night.UserConfig.SilentAim.WallCheck, Save = true, Flag = "SilentAimWallCheck", Callback = function(v) SilentAim.WallCheck = v; Night.UserConfig.SilentAim.WallCheck = v end})
SilentAimTab:AddToggle({Name = "Ignore Knocked", Default = Night.UserConfig.SilentAim.KnockedCheck, Save = true, Flag = "SilentAimKnockedCheck", Callback = function(v) SilentAim.KnockedCheck = v; Night.UserConfig.SilentAim.KnockedCheck = v end})
SilentAimTab:AddToggle({Name = "Team Check (Civ vs Cop)", Default = Night.UserConfig.SilentAim.TeamCheck, Save = true, Flag = "SilentAimTeamCheck", Callback = function(v) SilentAim.TeamCheck = v; Night.UserConfig.SilentAim.TeamCheck = v end})
SilentAimTab:AddToggle({Name = "Ignore Untouchable Teams", Default = Night.UserConfig.SilentAim.IgnoreUntouchable, Save = true, Flag = "SilentAimIgnoreUntouchable", Callback = function(v) SilentAim.IgnoreUntouchable = v; Night.UserConfig.SilentAim.IgnoreUntouchable = v end})
SilentAimTab:AddSlider({Name = "Shoot Speed", Min = 1, Max = 150, Default = Night.UserConfig.SilentAim.ShootSpeed, Color = Color3.fromRGB(255,255,255), Increment = 1, ValueName = "S/s", Save = true, Flag = "SilentAimShootSpeed", Callback = function(v) SilentAim.ShootSpeed = v; Night.UserConfig.SilentAim.ShootSpeed = v end})
SilentAimTab:AddSection({Name = "Visuals"})
SilentAimTab:AddToggle({Name = "Show FOV Circle", Default = Night.UserConfig.SilentAim.FovEnabled, Save = true, Flag = "SilentAimFovEnabled", Callback = function(v)
    SilentAim.FovEnabled = v
    Night.UserConfig.SilentAim.FovEnabled = v
    if SilentAim.FovCircle then
        SilentAim.FovCircle.Visible = v
    end
    if Night.ConfigManager and Night.ConfigManager.AutoSave then
        Night.ConfigManager:TriggerAutoSave()
    end
end})
SilentAimTab:AddSlider({Name = "FOV Size", Min = 10, Max = 500, Default = Night.UserConfig.SilentAim.FovSize, Color = Color3.fromRGB(0, 120, 255), Increment = 5, ValueName = "px", Save = true, Flag = "SilentAimFovSize", Callback = function(v) SilentAim.FovSize = v; Night.UserConfig.SilentAim.FovSize = v end})


pcall(function()
	for _, gui in pairs(game.Players.LocalPlayer.PlayerGui:GetChildren()) do
		if gui:IsA("ScreenGui") and gui.Name:find("^CarFlyControls") then
			gui:Destroy()
		end
	end
end)
local localPlayer
localPlayer = game.Players.LocalPlayer
local UserInputService
UserInputService = game:GetService("UserInputService")

do
	local RunService = game:GetService("RunService")
	local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
	local isPC = UserInputService.KeyboardEnabled
	_G.isMobile = isMobile
	_G.isPC = isPC

	_G.MobileInput = _G.MobileInput or {
		AimHold        = false,
		CarJoystickX   = 0,
		CarJoystickY   = 0,
		CarUp          = false,
		CarDown        = false,
		FlyUp          = false,
		FlyDown        = false,
	}

	local carState = {
		active = false,
		speed = 1165.5,
		baseSpeed = 7.77,
		seat = nil,
		veh = nil,
		inSeat = false,
		fly = {
			lastPos = nil, lastLook = nil, flightStart = nil,
			straightStart = nil, shifted = false,
			freezeCFrame = nil, freezePlayerPos = nil,
		},
	}

	local function wipeFlyState()
		_G.CarFlyActive = false
		for k in pairs(carState.fly) do carState.fly[k] = nil end
		carState.inSeat = false
		carState.veh = nil
		carState.seat = nil
	end

	VehicleTab:AddSection({ Name = "Car Mod" })
	VehicleTab:AddParagraph("Carfly Warning", "Dont fly into something or in the ground. You will get teleported back to your old position.")

	local carRecallToggle = nil
	local mobileCarGui = nil
	local mobileJoystickTouch = nil

	local function getSafeGuiParent()
		local ok1, hui = pcall(function() return gethui() end)
		if ok1 and hui then return hui end
		local ok2, cg = pcall(function() return game:GetService("CoreGui") end)
		if ok2 and cg then return cg end
		return (localPlayer or game.Players.LocalPlayer):WaitForChild("PlayerGui")
	end

	local function createMobileCarGui()
		if mobileCarGui then mobileCarGui:Destroy() end

		local gui = Instance.new("ScreenGui")
		gui.Name = "FluxMobileCarFly"
		gui.ResetOnSpawn = false
		gui.IgnoreGuiInset = true
		gui.DisplayOrder = 999999
		pcall(function() gui.Parent = getSafeGuiParent() end)
		mobileCarGui = gui

		local joySize = 130
		local handleSize = 54

		local base = Instance.new("Frame")
		base.Name = "JoystickBase"
		base.Size = UDim2.new(0, joySize, 0, joySize)
		base.Position = UDim2.new(0, 30, 1, -joySize - 40)
		base.BackgroundColor3 = Color3.fromRGB(18, 20, 28)
		base.BackgroundTransparency = 0.35
		base.BorderSizePixel = 0
		base.Active = true
		base.Parent = gui
		Instance.new("UICorner", base).CornerRadius = UDim.new(1, 0)

		local baseStroke = Instance.new("UIStroke", base)
		baseStroke.Color = Color3.fromRGB(70, 130, 220)
		baseStroke.Thickness = 2
		baseStroke.Transparency = 0.25

		local handle = Instance.new("Frame")
		handle.Name = "Handle"
		handle.Size = UDim2.new(0, handleSize, 0, handleSize)
		handle.Position = UDim2.new(0.5, -handleSize/2, 0.5, -handleSize/2)
		handle.BackgroundColor3 = Color3.fromRGB(80, 150, 240)
		handle.BorderSizePixel = 0
		handle.Parent = base
		Instance.new("UICorner", handle).CornerRadius = UDim.new(1, 0)

		local grad = Instance.new("UIGradient")
		grad.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(130, 200, 255)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(60, 90, 210)),
		})
		grad.Rotation = 45
		grad.Parent = handle

		local handleStroke = Instance.new("UIStroke", handle)
		handleStroke.Color = Color3.fromRGB(190, 225, 255)
		handleStroke.Thickness = 1.5
		handleStroke.Transparency = 0.25

		local dot = Instance.new("Frame")
		dot.Size = UDim2.new(0, 12, 0, 12)
		dot.Position = UDim2.new(0.5, -6, 0.5, -6)
		dot.BackgroundColor3 = Color3.fromRGB(235, 245, 255)
		dot.BorderSizePixel = 0
		dot.Parent = handle
		Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

		local function updateJoystick(px, py)
			local basePos = base.AbsolutePosition
			local baseSize = base.AbsoluteSize
			local center = basePos + baseSize / 2
			local offset = Vector2.new(px, py) - center
			local radius = baseSize.X / 2 - handleSize / 2

			local mag = offset.Magnitude
			if mag > radius then
				offset = offset.Unit * radius
			end

		handle.Position = UDim2.new(0.5, offset.X - handleSize/2, 0.5, offset.Y - handleSize/2)

			local nx = offset.X / radius
			local ny = -offset.Y / radius

			if math.abs(nx) < 0.15 then nx = 0 end
			if math.abs(ny) < 0.15 then ny = 0 end

			_G.MobileInput.CarJoystickX = nx
			_G.MobileInput.CarJoystickY = ny
		end

		local function resetJoystick()
			handle.Position = UDim2.new(0.5, -handleSize/2, 0.5, -handleSize/2)
			_G.MobileInput.CarJoystickX = 0
			_G.MobileInput.CarJoystickY = 0
			mobileJoystickTouch = nil
		end

		base.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.Touch
			or input.UserInputType == Enum.UserInputType.MouseButton1 then
				mobileJoystickTouch = input
				updateJoystick(input.Position.X, input.Position.Y)
				input.Changed:Connect(function()
					if input.UserInputState == Enum.UserInputState.End then
						resetJoystick()
					end
				end)
			end
		end)

		UserInputService.TouchMoved:Connect(function(touch)
			if mobileJoystickTouch and touch == mobileJoystickTouch then
				updateJoystick(touch.Position.X, touch.Position.Y)
			end
		end)
	end

	local function destroyMobileCarGui()
		if mobileCarGui then
			mobileCarGui:Destroy()
			mobileCarGui = nil
		end
		_G.MobileInput.CarJoystickX = 0
		_G.MobileInput.CarJoystickY = 0
	end

	local carFlyToggle = VehicleTab:AddToggle({
		Name = "Car Fly", Default = false, Flag = "CarFlyEnabled",
		Callback = function(on)
			carState.active = on
			_G.CarFlyActive = on
			if on then
				if carRecallToggle then carRecallToggle:Set(true) end
			else
				wipeFlyState()
				task.spawn(function()
					task.wait(1)
					if carRecallToggle then carRecallToggle:Set(false) end
				end)
			end
		end,
	})
	_G.CarFlyToggle = carFlyToggle

	if isMobile then
		VehicleTab:AddToggle({
			Name = "Mobile CarFly",
			Default = false,
			Flag = "MobileCarFlyToggle",
			Callback = function(on)
				if on then
					carState.active = true
					_G.CarFlyActive = true
					if carFlyToggle then carFlyToggle:Set(true) end
					if carRecallToggle then carRecallToggle:Set(true) end
					createMobileCarGui()
				else
					carState.active = false
					_G.CarFlyActive = false
					if carFlyToggle then carFlyToggle:Set(false) end
					destroyMobileCarGui()
					wipeFlyState()
				end
			end
		})
	end

	if not isMobile then
		VehicleTab:AddBind({
			Name = "Car Fly Keybind", Default = Enum.KeyCode.X,
			Flag = "CarFlyKeybind",
			Callback = function()
				local newState = not carState.active
				carState.active = newState
				_G.CarFlyActive = newState
				if carFlyToggle then carFlyToggle:Set(newState) end
				if newState then
					if carRecallToggle then carRecallToggle:Set(true) end
				else
					wipeFlyState()
					task.spawn(function()
						task.wait(1)
						if carRecallToggle then carRecallToggle:Set(false) end
					end)
				end
			end
		})
	end

	VehicleTab:AddSlider({
		Name = "Car Fly Speed", Min = 10, Max = 300, Default = 110,
		Increment = 1, ValueName = "Speed",
		Flag = "CarFlySpeed",
		Callback = function(v)
			carState.speed = v * carState.baseSpeed
		end,
	})

	local recallState = { on = false, cooldown = 0, range = 10 }

	local function grabVehicle()
		local char = (localPlayer or game.Players.LocalPlayer).Character or (localPlayer or game.Players.LocalPlayer).CharacterAdded:Wait()
		local hrp_ = char:WaitForChild("HumanoidRootPart")
		local hum = char:FindFirstChildWhichIsA("Humanoid")
		local folder = workspace:FindFirstChild("Vehicles")
		local veh = folder and folder:FindFirstChild((localPlayer or game.Players.LocalPlayer).Name)
		if not (veh and veh:IsA("Model")) then return end

		local drive = veh:FindFirstChild("DriveSeat") or veh:FindFirstChildWhichIsA("VehicleSeat")
		if not drive then return end
		if not veh.PrimaryPart then veh.PrimaryPart = drive end

		veh:SetPrimaryPartCFrame(hrp_.CFrame * CFrame.new(0, 3, -8))
		task.wait(0.2)

		if hum and not hum.SeatPart then
			drive:Sit(hum)
			carState.seat = drive
			carState.veh = veh
			carState.inSeat = true
		end
	end

	_G.BringOwnCarButtonAction = grabVehicle
	VehicleTab:AddButton({ Name = "Bring Own Car", Callback = grabVehicle })

	carRecallToggle = VehicleTab:AddToggle({
		Name = "Car Recall (Will be activated when car fly is on)",
		Default = true, Flag = "CarRecallEnabled",
		Callback = function(on)
			recallState.on = on
			recallState.cooldown = 0
		end,
	})

	task.spawn(function()
		while task.wait(0.25) do
			if not recallState.on then continue end

			local char = (localPlayer or game.Players.LocalPlayer).Character
			if not char then continue end

			local hum = char:FindFirstChildWhichIsA("Humanoid")
			local hrp_ = char:FindFirstChild("HumanoidRootPart")
			if not (hum and hrp_) then continue end
			if hum.SeatPart then continue end
			if tick() < recallState.cooldown then continue end

			local folder = workspace:FindFirstChild("Vehicles")
			local veh = folder and folder:FindFirstChild((localPlayer or game.Players.LocalPlayer).Name)
		if not (veh and veh:IsA("Model")) then continue end

			local drive = veh:FindFirstChild("DriveSeat") or veh:FindFirstChildWhichIsA("VehicleSeat")
			if not drive then continue end
		if not veh.PrimaryPart then veh.PrimaryPart = drive end

			if (veh.PrimaryPart.Position - hrp_.Position).Magnitude > recallState.range then
				recallState.cooldown = tick() + 1.5
				grabVehicle()
			end
		end
	end)

	local cachedVeh = nil
	local bodyParts = {}
	local wheelNames = { FL = true, FR = true, RL = true, RR = true }

	local function hasWheelAncestor(part)
		local cur = part
		while cur and cur ~= workspace do
			if wheelNames[cur.Name] or cur.Name == "Rim" or cur.Name == "Tire" or cur.Name == "Wheel" then
				return true
			end
			cur = cur.Parent
		end
		return false
	end

	local function collectBodyParts(veh)
		if cachedVeh == veh then return bodyParts end
		cachedVeh = veh
		bodyParts = {}
		for _, d in ipairs(veh:GetDescendants()) do
			if d:IsA("BasePart") and not hasWheelAncestor(d) then
				table.insert(bodyParts, d)
			end
		end
		return bodyParts
	end

	local function killVelocity(parts)
		for _, p in ipairs(parts) do
			if p.Parent then
				p.AssemblyLinearVelocity = Vector3.zero
				p.AssemblyAngularVelocity = Vector3.zero
				p.Velocity = Vector3.zero
				p.RotVelocity = Vector3.zero
			end
		end
	end

	local function readInput()
		local fwd = 0
		local up = 0
		local side = 0
		local straight = false

		if UserInputService:IsKeyDown(Enum.KeyCode.W) then fwd = 1
		elseif UserInputService:IsKeyDown(Enum.KeyCode.S) then fwd = -1
		else
			local jy = _G.MobileInput.CarJoystickY or 0
			if math.abs(jy) > 0.1 then fwd = jy end
		end

		if UserInputService:IsKeyDown(Enum.KeyCode.D) then side = 1
		elseif UserInputService:IsKeyDown(Enum.KeyCode.A) then side = -1
		else
			local jx = _G.MobileInput.CarJoystickX or 0
			if math.abs(jx) > 0.1 then side = jx end
		end

		if UserInputService:IsKeyDown(Enum.KeyCode.E) or UserInputService:IsKeyDown(Enum.KeyCode.Space) then up = 1
		elseif UserInputService:IsKeyDown(Enum.KeyCode.Q) or UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then up = -1 end

		straight = fwd > 0.8 and math.abs(side) < 0.2 and up == 0

		return fwd, up, side, straight
	end

	RunService.RenderStepped:Connect(function()
		local char = (localPlayer or game.Players.LocalPlayer).Character
		if not char then return end

		if not carState.active then
			if carState.fly.lastPos or carState.fly.lastLook then wipeFlyState() end
			return
		end

		local hum = char:FindFirstChildOfClass("Humanoid")
		local folder = workspace:FindFirstChild("Vehicles")
		local veh = folder and folder:FindFirstChild((localPlayer or game.Players.LocalPlayer).Name)
		if not veh then wipeFlyState() return end

		local drive = veh:FindFirstChild("DriveSeat")
		if not drive then wipeFlyState() return end

		if hum and hum.SeatPart then
			carState.seat = hum.SeatPart
			carState.veh = veh
			carState.inSeat = true
			carState.fly.freezeCFrame = nil
			carState.fly.freezePlayerPos = nil
		elseif hum then
			carState.inSeat = false
			carState.veh = veh
			veh.PrimaryPart = veh.PrimaryPart or drive
			carState.fly.freezeCFrame = carState.fly.freezeCFrame or veh.PrimaryPart.CFrame
			veh:SetPrimaryPartCFrame(carState.fly.freezeCFrame)
			killVelocity(collectBodyParts(veh))

			local hrp_ = char:FindFirstChild("HumanoidRootPart")
			if hrp_ then
				carState.fly.freezePlayerPos = carState.fly.freezePlayerPos or hrp_.Position
				local rot = hrp_.CFrame - hrp_.CFrame.Position
				hrp_.CFrame = CFrame.new(carState.fly.freezePlayerPos) * rot
				hrp_.AssemblyLinearVelocity = Vector3.zero
				hrp_.AssemblyAngularVelocity = Vector3.zero
			end

			drive:Sit(hum)
			carState.seat = drive
			carState.fly.lastPos = carState.fly.freezeCFrame.Position
			local cam = workspace.CurrentCamera
			carState.fly.lastLook = cam and cam.CFrame.LookVector or Vector3.new(0, 0, -1)
			return
		end

		veh.PrimaryPart = veh.PrimaryPart or drive
		local cam = workspace.CurrentCamera
		local look = cam and cam.CFrame.LookVector or Vector3.new(0, 0, -1)
		carState.fly.lastPos = carState.fly.lastPos or veh.PrimaryPart.Position
		carState.fly.lastLook = carState.fly.lastLook or look
		local now = tick()
		carState.fly.flightStart = carState.fly.flightStart or now

		local fwd, up, side, straight = readInput()

		if straight then
			carState.fly.straightStart = carState.fly.straightStart or now
			if not carState.fly.shifted and now - carState.fly.straightStart >= 1 then
				local p = veh.PrimaryPart.Position + look:Cross(Vector3.new(0, 1, 0)).Unit * 10
				veh:SetPrimaryPartCFrame(CFrame.new(p, p + look))
				carState.fly.lastPos = p
				carState.fly.shifted = true
			end
		else
			carState.fly.straightStart = nil
			carState.fly.shifted = false
		end

		local spd = carState.speed / 100
		local target = veh.PrimaryPart.Position
			+ look * fwd * spd
			+ Vector3.new(0, 1, 0) * up * spd
			+ look:Cross(Vector3.new(0, 1, 0)).Unit * side * spd

		local newPos = carState.fly.lastPos:Lerp(target, 0.3)
		local newLook = carState.fly.lastLook:Lerp(look, 0.2)
		veh:SetPrimaryPartCFrame(CFrame.new(newPos, newPos + newLook))
		carState.fly.lastPos = newPos
		carState.fly.lastLook = newLook

		killVelocity(collectBodyParts(veh))

		if hum and hum.SeatPart then
			local hrp_ = char:FindFirstChild("HumanoidRootPart")
			if hrp_ then
				hrp_.AssemblyLinearVelocity = Vector3.zero
				hrp_.AssemblyAngularVelocity = Vector3.zero
			end
		end
	end)
end


VehicleTab:AddSection({ Name = "Car-Fling" })

do
	local flag = false
	local n = 500

	local v12 = VehicleTab:AddToggle({
		Name = "Fling (Use with Car Fly only.)",
		Default = false,
		Save = false,
		Flag = "FlingEnabled",
		Callback = function(arg1)
			flag = arg1
		end,
	})

	VehicleTab:AddBind({
		Name = "Toggle Fling",
		Default = Enum.KeyCode.K,
		Hold = false,
		Save = true,
		Flag = "FlingKeybind",
		Callback = function()
			flag = not flag
			v12:Set(flag)
		end,
	})

	local raycastParams = RaycastParams.new()
	raycastParams.FilterType = Enum.RaycastFilterType.Blacklist

	game:GetService("RunService").Heartbeat:Connect(function()
		if not flag then
			return
		end
		local character = game.Players.LocalPlayer.Character
		if not character then
			return
		end
		local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
		if not humanoidRootPart then
			return
		end
		raycastParams.FilterDescendantsInstances = { character }
		local hit = workspace:Raycast(humanoidRootPart.Position, humanoidRootPart.CFrame.LookVector * 3, raycastParams)

		if hit then
			humanoidRootPart.AssemblyLinearVelocity = -hit.Normal * n
		end
	end)
end

VehicleTab:AddSection({ Name = "Vehicle Mods" })

local indestructibleCarActive = false
VehicleTab:AddToggle({
	Name = "Indestructible Car",
	Default = false,
	Save = true,
	Flag = "IndestructibleCar",
	Callback = function(arg1)
		indestructibleCarActive = arg1
		if arg1 then
			task.spawn(function()
				while indestructibleCarActive do
					local localPlayer2 = game.Players.LocalPlayer
					local vehicles = workspace:FindFirstChild("Vehicles")
					vehicles = vehicles and vehicles:FindFirstChild(localPlayer2.Name)

					if vehicles and vehicles:IsA("Model") then
						vehicles:SetAttribute("currentHealth", 1000)
						vehicles:SetAttribute("IsOn", true)
					end

					task.wait(5)
				end
			end)
		end
	end,
})

VehicleTab:AddToggle({
	Name = "Anti Crash Damage",
	Default = false,
	Save = true,
	Flag = "AntiCrashDamage",
	Callback = function(s32)
		local localPlayer2 = game.Players.LocalPlayer

		local function fn4()
			local vehicles = workspace:FindFirstChild("Vehicles")
			if not vehicles then
				return
			end
			local v12 = vehicles:FindFirstChild(localPlayer2.Name)
			if not v12 then
				return
			end

			if s32 then
				v12:SetAttribute("IsBeingTowed", true)
			else
				v12:SetAttribute("IsBeingTowed", false)
			end
		end

		fn4()

		if s32 then
			if not getgenv().AntiCrashConnection then
				local childAdded = workspace.Vehicles.ChildAdded

				getgenv().AntiCrashConnection = childAdded:Connect(function(tbl6)
					if tbl6.Name == localPlayer2.Name then
						task.wait(0.5)
						tbl6:SetAttribute("IsBeingTowed", true)
					end
				end)
			end
		elseif getgenv().AntiCrashConnection then
			getgenv().AntiCrashConnection:Disconnect()
			getgenv().AntiCrashConnection = nil
		end
	end,
})

do
	local flag = false
	local localPlayer2 = game:GetService("Players").LocalPlayer
	local TweenService = game:GetService("TweenService")

	VehicleTab:AddToggle({
		Name = "Maybach Jumping Suspension",
		CurrentValue = false,
		Save = true,
		Flag = "MaybachJumpingToggle",
		Callback = function(arg1)
			flag = arg1

			if flag then
				task.spawn(function()
					local flag2 = true

					while flag do
						local character = localPlayer2.Character

						if not character then
							task.wait(0.5)
						else
							local humanoid = character:FindFirstChild("Humanoid")

							if not humanoid then
								task.wait(0.5)
							elseif not humanoid.SeatPart then
								task.wait(0.5)
							else
								local seatPart = humanoid.SeatPart

								if not seatPart:IsA("Seat") then
									task.wait(0.5)
								else
									local tbl6 = {}

									for _, child in pairs(seatPart:GetChildren()) do
										if child:IsA("SpringConstraint") and child.Name:find("Spring") then
											table.insert(tbl6, child)
										end
									end

									if #tbl6 == 0 then
										task.wait(0.5)
									else
										local n = flag2 and 2.6 or 1.65
										flag2 = not flag2

										for _, v12 in pairs(tbl6) do
											TweenService:Create(v12, TweenInfo.new(0.61, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), { FreeLength = n }):Play()
										end

										task.wait(0.61)
									end
								end
							end
						end
					end
				end)
			end
		end,
	})
end

local localPlayer2
localPlayer2 = game:GetService("Players").LocalPlayer

do
	local vehicles = workspace:WaitForChild("Vehicles")
	local flag = false

	VehicleTab:AddSlider({
		Name = "Vehicle Height",
		Min = 1,
		Max = 9,
		Default = 1.5,
		Color = Color3.fromRGB(246, 221, 77),
		Increment = 0.1,
		ValueName = "",
		Callback = function(n)
			if not flag then
				flag = true
				return
			end
			local minLength = 0.5 + (n - 1) / 9 * 12.5

			pcall(function()
				local v12 = vehicles:FindFirstChild(localPlayer2.Name)
				if not v12 then
					return
				end
				local driveSeat = v12:FindFirstChild("DriveSeat", true)
				if not driveSeat then
					return
				end

				for _, child in pairs(driveSeat:GetChildren()) do
					if child:IsA("SpringConstraint") then
						child.LimitsEnabled = true
						child.MinLength = minLength
						child.MaxLength = minLength
					elseif child:IsA("RopeConstraint") then
						child.Length = minLength
					end
				end
			end)
		end,
	})
end

VehicleTab:AddSection({ Name = "Boosts" })
getgenv().DriftBoostConnections = getgenv().DriftBoostConnections or {}

VehicleTab:AddToggle({
	Name = "Drift Boost",
	Default = false,
	Save = true,
	Flag = "DriftBoostToggle",
	Callback = function(s10)
		local roads = workspace:FindFirstChild("Roads")
		local roads2 = roads and roads:FindFirstChild("Additional") and roads.Additional:FindFirstChild("Roads")

		local function fn4(tbl6, material)
			for _, descendant in pairs(tbl6:GetDescendants()) do
				if descendant:IsA("BasePart") then
					if material then
						if not descendant:GetAttribute("OriginalMaterial") then
							descendant:SetAttribute("OriginalMaterial", descendant.Material.Name)
							descendant:SetAttribute("OriginalColor", descendant.Color)
						end

						descendant.Material = material
						descendant.Color = descendant:GetAttribute("OriginalColor")
					else
						local attribute = descendant:GetAttribute("OriginalMaterial")

						if attribute and Enum.Material[attribute] then
							descendant.Material = Enum.Material[attribute]
						end

						local attribute2 = descendant:GetAttribute("OriginalColor")

						if attribute2 then
							descendant.Color = attribute2
						end
					end
				end
			end
		end

		if s10 then
			if roads then
				fn4(roads, Enum.Material.Ice)
			end

			if roads2 then
				fn4(roads2, Enum.Material.Ice)
			end

			if roads then
				local descendantAdded = roads.DescendantAdded
				local connect = descendantAdded.Connect

				table.insert(getgenv().DriftBoostConnections, connect(descendantAdded, function(tbl6)
					if tbl6:IsA("BasePart") then
						if not tbl6:GetAttribute("OriginalMaterial") then
							tbl6:SetAttribute("OriginalMaterial", tbl6.Material.Name)
							tbl6:SetAttribute("OriginalColor", tbl6.Color)
						end

						tbl6.Material = Enum.Material.Ice
						tbl6.Color = tbl6:GetAttribute("OriginalColor")
					end
				end))
			end

			if roads2 then
				local descendantAdded = roads2.DescendantAdded
				local connect = descendantAdded.Connect

				table.insert(getgenv().DriftBoostConnections, connect(descendantAdded, function(tbl6)
					if tbl6:IsA("BasePart") then
						if not tbl6:GetAttribute("OriginalMaterial") then
							tbl6:SetAttribute("OriginalMaterial", tbl6.Material.Name)
							tbl6:SetAttribute("OriginalColor", tbl6.Color)
						end

						tbl6.Material = Enum.Material.Ice
						tbl6.Color = tbl6:GetAttribute("OriginalColor")
					end
				end))
			end
		else
			if roads then
				fn4(roads, nil)
			end

			if roads2 then
				fn4(roads2, nil)
			end

			for _, driftBoostConnection in ipairs(getgenv().DriftBoostConnections) do
				driftBoostConnection:Disconnect()
			end

			getgenv().DriftBoostConnections = {}
		end
	end,
})

VehicleTab:AddToggle({
	Name = "Anti-Drift",
	CurrentValue = false,
	Save = true,
	Flag = "gripBoost",
	Callback = function(s35)
		if not getgenv().GripBoost then
			getgenv().GripBoost = { configured = false, originalValues = {}, configTable = nil }
		end

		local gripBoost = getgenv().GripBoost

		if not gripBoost.configured then
			local localPlayer3 = game:GetService("Players").LocalPlayer
			if not localPlayer3 or not localPlayer3.PlayerScripts then
				return
			end
			local carSteering = localPlayer3.PlayerScripts.Code.components.vehicle:FindFirstChild("carSteering")

			if carSteering then
				local module = nil

				pcall(function()
					module = require(carSteering)
				end)

				local carSteering2 = module and module.CarSteering or module

				if carSteering2 and carSteering2.handleSteering then
					for i = 1, 100 do
						local ok, configTable = pcall(debug.getupvalue, carSteering2.handleSteering, i)

						if ok and type(configTable) == "table" and configTable.maxSteeringAngle and configTable.steeringModifierSpeed then
							gripBoost.configTable = configTable

							gripBoost.originalValues = {
								maxSteeringAngle = configTable.maxSteeringAngle,
								steeringModifierSpeed = configTable.steeringModifierSpeed,
								steeringSpeed = configTable.steeringSpeed,
								steerBackMultiplier = configTable.steerBackMultiplier,
								minSteer = configTable.minSteer,
							}

							gripBoost.configured = true
							break
						elseif ok then
							continue
						end

						break
					end
				end
			end
		end

		if gripBoost.configured and gripBoost.configTable then
			if s35 then
				gripBoost.configTable.maxSteeringAngle = 15
				gripBoost.configTable.steeringModifierSpeed = 20
				gripBoost.configTable.steeringSpeed = 4
				gripBoost.configTable.steerBackMultiplier = 2
				gripBoost.configTable.minSteer = 0.07
			else
				gripBoost.configTable.maxSteeringAngle = gripBoost.originalValues.maxSteeringAngle or 8
				gripBoost.configTable.steeringModifierSpeed = gripBoost.originalValues.steeringModifierSpeed or 35
				gripBoost.configTable.steeringSpeed = gripBoost.originalValues.steeringSpeed or 1.5
				gripBoost.configTable.steerBackMultiplier = gripBoost.originalValues.steerBackMultiplier or 3
				gripBoost.configTable.minSteer = gripBoost.originalValues.minSteer or 0.15
			end
		end
	end,
})

do
	local getAccelerationMultiplier = nil
	local getSurfaceModifier = nil

	VehicleTab:AddToggle({
		Name = "SUV Mode",
		CurrentValue = false,
		Save = true,
		Flag = "suvMode",
		Callback = function(s18)
			local vehicleDrive = game:GetService("Players").LocalPlayer.PlayerScripts.Code.components.vehicle:FindFirstChild("vehicleDrive")
			if not vehicleDrive then
				return
			end
			local module = nil

			pcall(function()
				module = require(vehicleDrive)
			end)

			if not module or not module.VehicleDrive then
				return
			end
			local vehicleDrive2 = module.VehicleDrive

			if s18 then
				getAccelerationMultiplier = getAccelerationMultiplier or vehicleDrive2.getAccelerationMultiplier
				getSurfaceModifier = getSurfaceModifier or vehicleDrive2.getSurfaceModifier

				vehicleDrive2.getAccelerationMultiplier = function()
					return 1
				end

				vehicleDrive2.getSurfaceModifier = function()
					return 0
				end
			else
				if getAccelerationMultiplier then
					vehicleDrive2.getAccelerationMultiplier = getAccelerationMultiplier
				end

				if getSurfaceModifier then
					vehicleDrive2.getSurfaceModifier = getSurfaceModifier
				end
			end
		end,
	})
end

VehicleTab:AddSection({ Name = "Engine Sounds" })

do
	local tbl6 = {
		v10 = "rbxassetid://92387486484055",
		["7 ExhL"] = "rbxassetid://75247492673971",
		v11 = "rbxassetid://6667206432",
		Electric = "rbxassetid://103303615756712",
		["3500"] = "rbxassetid://78895212189133",
		Sport = "rbxassetid://107090777647557",
		Troll = "rbxassetid://139592319059397",
		["3ra"] = "rbxassetid://72593429158155",
	}

	local tbl7 = {}
	local tbl8 = {}

	local function fn4()
		for _, descendant in pairs(game:GetDescendants()) do
			fn()

			if descendant:IsA("Sound") then
				local soundId = descendant.SoundId

				if soundId == "rbxassetid://358130654" or soundId == "rbxassetid://358130655" then
					tbl7[descendant] = soundId
					tbl8[descendant] = true
				end
			end
		end
	end

	local function fn5(n)
		local v12 = tbl6[n]

		for k, v13 in pairs(tbl7) do
			if k and k.Parent then
				if n == "Default" then
					k.SoundId = v13
				else
					k.SoundId = v12
					k.Looped = true
				end
			end
		end
	end

	fn4()

	VehicleTab:AddDropdown({
		Name = "Vehicle Sound",
		Default = "Default",
		Save = true,
		Flag = "VehicleSound",
		Options = { "Default", "v10", "7 ExhL", "v11", "Electric", "3500", "Sport", "Troll", "3ra" },
		Callback = function(s9)
			fn5(s9)
		end,
	})
end

VehicleTab:AddSection({ Name = "Tuning Mods" })

do
	local localPlayer3 = game.Players.LocalPlayer
	local tbl6 = { "Level 0", "Level 1", "Level 2", "Level 3", "Level 4", "Level 5", "Level 6" }

	local function fn4(s6)
		for _, descendant in ipairs(workspace:GetDescendants()) do
			if descendant:IsA("Model") and descendant.Name:match(s6) then
				return descendant
			end
		end

		return nil
	end

	local function fn5(s37, s38)
		local v12 = workspace.Vehicles:FindFirstChild(localPlayer3.Name) or fn4(localPlayer3.Name)

		if v12 then
			v12:SetAttribute(s37, s38)
		end
	end

	VehicleTab:AddDropdown({
		Name = "Armor",
		Default = "Level 6",
		Options = tbl6,
		Save = true,
		Flag = "CarArmor",
		Callback = function(tbl7)
			fn5("armorLevel", tonumber(tbl7:match("%d+")))
		end,
	})

	VehicleTab:AddDropdown({
		Name = "Brakes",
		Default = "Level 6",
		Options = tbl6,
		Save = true,
		Flag = "CarBrakes",
		Callback = function(tbl7)
			fn5("brakesLevel", tonumber(tbl7:match("%d+")))
		end,
	})

	VehicleTab:AddDropdown({
		Name = "Engine",
		Default = "Level 6",
		Options = tbl6,
		Save = true,
		Flag = "CarEngine",
		Callback = function(tbl7)
			fn5("engineLevel", tonumber(tbl7:match("%d+")))
		end,
	})

	VehicleTab:AddSection({ Name = "Car Boost" })
	local tbl7 = { enabled = false, speedMult = 1.7, accelMult = 1.6, reverseMult = 1.7, brakeMult = 1.3 }
	local tbl8 = { patched = false, drive = nil, orig = {} }

	local function fn6()
		local ok, result = pcall(function()
			return require(game:GetService("Players").LocalPlayer.PlayerScripts.Code.components.vehicle.vehicleDrive)
		end)

		if ok and result and result.VehicleDrive then
			return result.VehicleDrive
		end
		return nil
	end

	local v12 = fn6()

	local function fn7()
		local vehicles = workspace:FindFirstChild("Vehicles")
		return vehicles and vehicles:FindFirstChild(localPlayer.Name)
	end

	local function fn8()
		if tbl8.patched or not v12 then
			return
		end
		tbl8.patched = true
		tbl8.orig.onTick = v12.onTick
		tbl8.orig.getAccelerationMultiplier = v12.getAccelerationMultiplier
		tbl8.orig.calculateTorque = v12.calculateTorque
		tbl8.orig.updateThrottleValues = v12.updateThrottleValues

		v12.onTick = function(tbl9, t23)
			if tbl7.enabled then
				local v13 = fn7()

				if v13 and tbl9.instance == v13 then
					tbl8.drive = tbl9

					if not tbl9.__boostOrigSpeed then
						tbl9.__boostOrigSpeed = tbl9.config.maxSpeed
						tbl9.__boostOrigReverse = tbl9.config.maxReverseSpeed
					end

					tbl9.config.maxSpeed = tbl9.__boostOrigSpeed * tbl7.speedMult
					tbl9.config.maxReverseSpeed = tbl9.__boostOrigReverse * tbl7.reverseMult
				end
			elseif tbl9.__boostOrigSpeed then
				tbl9.config.maxSpeed = tbl9.__boostOrigSpeed
				tbl9.config.maxReverseSpeed = tbl9.__boostOrigReverse
				tbl9.__boostOrigSpeed = nil
				tbl9.__boostOrigReverse = nil
			end

			return tbl8.orig.onTick(tbl9, t23)
		end

		v12.getAccelerationMultiplier = function(tbl9)
			local v13 = tbl8.orig.getAccelerationMultiplier(tbl9)
			local enabled = tbl7.enabled

			if enabled then
				local instance = tbl9.instance
				enabled = fn7() == instance
			end

			if enabled then
				return v13 * tbl7.accelMult
			end
			return v13
		end

		v12.calculateTorque = function(tbl9, t11)
			local v13 = tbl8.orig.calculateTorque(tbl9, t11)
			local enabled = tbl7.enabled

			if enabled then
				local instance = tbl9.instance
				enabled = fn7() == instance
			end

			if enabled and t11 == "brake" then
				return v13 * tbl7.brakeMult
			end
			return v13
		end
	end

	local function fn9(enabled)
		tbl7.enabled = enabled

		if enabled then
			fn8()
		elseif tbl8.drive and tbl8.drive.__boostOrigSpeed then
			tbl8.drive.config.maxSpeed = tbl8.drive.__boostOrigSpeed
			tbl8.drive.config.maxReverseSpeed = tbl8.drive.__boostOrigReverse
			tbl8.drive.__boostOrigSpeed = nil
			tbl8.drive.__boostOrigReverse = nil
		end
	end

	local v13 = VehicleTab:AddToggle({
		Name = "Car Boost",
		Default = false,
		Save = false,
		Flag = "CarBoostEnabled",
		Callback = function(s17)
			fn9(s17)
		end,
	})

	VehicleTab:AddBind({
		Name = "Toggle Car Boost",
		Default = Enum.KeyCode.B,
		Hold = false,
		Save = true,
		Flag = "CarBoostKeybind",
		Callback = function()
			tbl7.enabled = not tbl7.enabled
			v13:Set(tbl7.enabled)
			fn9(tbl7.enabled)
		end,
	})

	VehicleTab:AddSlider({
		Name = "Max Speed Boost (170% Recommended)",
		Min = 100,
		Max = 400,
		Default = 170,
		Color = Color3.fromRGB(246, 221, 77),
		Increment = 5,
		ValueName = "%",
		Save = true,
		Flag = "CarBoostMaxSpeed",
		Callback = function(n)
			tbl7.speedMult = n / 100
		end,
	})

	VehicleTab:AddSlider({
		Name = "Accelerate Force (160% Recommended)",
		Min = 100,
		Max = 400,
		Default = 160,
		Color = Color3.fromRGB(246, 221, 77),
		Increment = 5,
		ValueName = "%",
		Save = true,
		Flag = "CarBoostAccel",
		Callback = function(n)
			tbl7.accelMult = n / 100
		end,
	})

	VehicleTab:AddSlider({
		Name = "Reverse Speed (170% Recommended)",
		Min = 100,
		Max = 400,
		Default = 170,
		Color = Color3.fromRGB(246, 221, 77),
		Increment = 5,
		ValueName = "%",
		Save = true,
		Flag = "CarBoostReverseSpeed",
		Callback = function(n)
			tbl7.reverseMult = n / 100
		end,
	})

	VehicleTab:AddSlider({
		Name = "Brake Force (130% Recommended)",
		Min = 100,
		Max = 300,
		Default = 130,
		Color = Color3.fromRGB(255, 100, 100),
		Increment = 5,
		ValueName = "%",
		Save = true,
		Flag = "CarBoostBrakeForce",
		Callback = function(n)
			tbl7.brakeMult = n / 100
		end,
	})

	VehicleTab:AddSection({ Name = "Car Colours" })
	local localPlayer3 = localPlayer or localPlayer2 or game:GetService("Players").LocalPlayer
	local flag = false
	local tbl9 = {}

	local function fn10()
		local vehicles = workspace:FindFirstChild("Vehicles")
		if not vehicles then
			return Color3.fromRGB(255, 255, 255)
		end
		local v14 = vehicles:FindFirstChild(localPlayer3.Name)
		if not v14 then
			return Color3.fromRGB(255, 255, 255)
		end

		for _, descendant in pairs(v14:GetDescendants()) do
			if descendant.Name == "FL" or descendant.Name == "FR" or descendant.Name == "RL" or descendant.Name == "RR" then
				local rim = descendant:FindFirstChild("Rim")

				if rim then
					local main = rim:FindFirstChild("Main")
					if main and main:IsA("BasePart") then
						return main.Color
					end
				end
			end
		end

		return Color3.fromRGB(255, 255, 255)
	end

	local function fn11()
		local vehicles = workspace:FindFirstChild("Vehicles")
		if not vehicles then
			return Color3.fromRGB(255, 255, 255)
		end
		local v14 = vehicles:FindFirstChild(localPlayer3.Name)
		if not v14 then
			return Color3.fromRGB(255, 255, 255)
		end

		for _, descendant in pairs(v14:GetDescendants()) do
			if descendant.Name == "Body" and descendant:IsA("BasePart") then
				return descendant.Color
			end
		end

		return Color3.fromRGB(255, 255, 255)
	end

	local function fn12(s29)
		local vehicles = workspace:FindFirstChild("Vehicles")
		if not vehicles then
			return
		end
		local v14 = vehicles:FindFirstChild(localPlayer3.Name)
		if not v14 then
			return
		end

		for _, descendant in pairs(v14:GetDescendants()) do
			if descendant.Name == "Body" and descendant:IsA("BasePart") then
				if s29 then
					if not tbl9[descendant] then
						tbl9[descendant] = descendant.Material
					end

					descendant.Material = Enum.Material.Neon
				elseif tbl9[descendant] then
					descendant.Material = tbl9[descendant]
					tbl9[descendant] = nil
				end
			end
		end
	end

	VehicleTab:AddToggle({
		Name = "Activate Neon",
		Default = false,
		Save = false,
		Flag = "CarNeonEnabled",
		Callback = function(s35)
			flag = s35
			fn12(s35)
		end,
	})

	VehicleTab:AddColorpicker({
		Name = "Body Colour",
		Default = fn11(),
		Save = false,
		Flag = "CarBodyColor",
		Callback = function(color)
				local vehicles = workspace:FindFirstChild("Vehicles")
				if not vehicles then
					return
				end
				local v14 = vehicles:FindFirstChild(localPlayer3.Name)
				if not v14 then
					return
				end

				for _, descendant in pairs(v14:GetDescendants()) do
					if descendant.Name == "Body" and descendant:IsA("BasePart") then
						descendant.Color = color
					end
				end
			end,
	})

	VehicleTab:AddColorpicker({
		Name = "Rim Colour",
		Default = fn10(),
		Save = false,
		Flag = "CarRimColor",
		Callback = function(color)
			local vehicles = workspace:FindFirstChild("Vehicles")
			if not vehicles then
				return
			end
			local v14 = vehicles:FindFirstChild(localPlayer3.Name)
			if not v14 then
				return
			end

			for _, descendant in pairs(v14:GetDescendants()) do
				if descendant.Name == "FL" or descendant.Name == "FR" or descendant.Name == "RL" or descendant.Name == "RR" then
					local rim = descendant:FindFirstChild("Rim")

					if rim then
						local main = rim:FindFirstChild("Main")

						if main and main:IsA("BasePart") then
							main.Color = color
						end
					end
				end
			end
		end,
	})

	VehicleTab:AddColorpicker({
		Name = "Headlight Color",
		Save = false,
		Default = Color3.fromRGB(255, 255, 255),
		Flag = "HeadlightColor",
		Callback = function(color)
			local vehicles = workspace:FindFirstChild("Vehicles")
			if not vehicles then
				return
			end
			local v14 = vehicles:FindFirstChild(localPlayer2.Name)
			if not v14 or not v14:IsA("Model") then
				return
			end
			local body = v14:FindFirstChild("Body")
			if not body then
				return
			end
			local headlights = body:FindFirstChild("Headlights")
			if not headlights then
				return
			end
			local headlights2 = headlights:FindFirstChild("Headlights")
			if not headlights2 then
				return
			end

			for _, descendant in pairs(headlights2:GetDescendants()) do
				if descendant:IsA("SpotLight") then
					descendant.Color = color
				end
			end
		end,
	})

	VehicleTab:AddSection({ Name = "Numberplate" })

	local function fn13()
		local vehicles = workspace:FindFirstChild("Vehicles")
		vehicles = vehicles and vehicles:FindFirstChild(localPlayer3.Name)
		if not vehicles then
			return {}
		end
		local licensePlates = vehicles:FindFirstChild("Body") and vehicles.Body:FindFirstChild("LicensePlates")
		if not licensePlates then
			return {}
		end
		local tbl10 = {}

		for _, child in ipairs(licensePlates:GetChildren()) do
			local gui = child:FindFirstChild("Gui")

			if gui and gui:IsA("SurfaceGui") then
				table.insert(tbl10, gui)
			end
		end

		return tbl10
	end

	local function fn14(text)
		for _, v14 in ipairs(fn13()) do
			local textLabel = v14:FindFirstChildWhichIsA("TextLabel")

			if textLabel then
				textLabel.Text = text
			end
		end
	end

	VehicleTab:AddTextbox({
		Name = "Numberplate-Text",
		Default = "NightHub",
		TextDisappear = false,
		Callback = function(s2)
			fn14(s2)
		end,
	})

	task.spawn(function()
		fn14("NightHub")
	end)
end

VehicleTab:AddButton({
	Name = "Randomize License Plate",
	Callback = function()
		local v12 = workspace.Vehicles:FindFirstChild(localPlayer2.Name)
		if not v12 then
			return
		end
		local licensePlates = v12:FindFirstChild("Body") and v12.Body:FindFirstChild("LicensePlates")
		if not licensePlates then
			return
		end
		local text = "HH " .. (string.char(math.random(65, 90)) .. string.char(math.random(65, 90))) .. " " .. math.random(10, 99)

		local function fn4(t36)
			local v13 = licensePlates:FindFirstChild(t36)

			if v13 then
				local gui = v13:FindFirstChild("Gui")

				if gui then
					local textLabel = gui:FindFirstChild("TextLabel")

					if textLabel then
						textLabel.Text = text
					end
				end
			end
		end

		fn4("Front")
		fn4("Back")
	end,
})

VehicleTab:AddSection({ Name = "Infos" })
VehicleTab:AddParagraph("CarFly Info", "If you get kicked out of your car while flying you have to lower your CarFly Speed until you don't get kicked out of the Car anymore.")
VehicleTab:AddParagraph("CarBoost Info", "Car Boost is still at its beta wich means it WILL contain bugs and won't work perfectly. This will be improved in the coming week.")

ESPTab:AddSection({ Name = "Esp" })
local RunService = game:GetService("RunService")

do
	local Players = game:GetService("Players")
	local CoreGui = game:GetService("CoreGui")
	local localPlayer3 = Players.LocalPlayer

	if getgenv and getgenv().NightESP_Cleanup then
		pcall(getgenv().NightESP_Cleanup)
	end

	pcall(function()
		local oldStorage = CoreGui:FindFirstChild("Highlight_Storage")
		if oldStorage then
			oldStorage:Destroy()
		end
		local oldOverlay = CoreGui:FindFirstChild("NightESP_Overlay")
		if oldOverlay then
			oldOverlay:Destroy()
		end
		if localPlayer3 and localPlayer3:FindFirstChild("PlayerGui") then
			local oldPgOverlay = localPlayer3.PlayerGui:FindFirstChild("NightESP_Overlay")
			if oldPgOverlay then
				oldPgOverlay:Destroy()
			end
		end
		for _, p in ipairs(Players:GetPlayers()) do
			if p.Character then
				for _, desc in ipairs(p.Character:GetDescendants()) do
					if desc:IsA("BillboardGui") and (desc.Name == "ESPTag" or desc.Name:find("^ESP_")) then
						desc:Destroy()
					end
				end
			end
		end
	end)

	local espAlive = true
	local tracerLines = {}
	local charConnections = {}
	local charRemovingConnections = {}
	local espTags = {}
	local lastUpdateTimes = {}
	local distanceCache = {}
	local skeletonLines = {}
	local playerCache = {}

	local espSettings = {
		NameESP = false,
		TeamESP = false,
		ChamsESP = false,
		WantedESP = false,
		DistanceESP = false,
		TracerESP = false,
		HealthESP = false,
		SkeletonESP = false,
		ToolESP = false,
	}

	local UPDATE_INTERVAL = 0.15
	local DIST_CACHE_TIME = 0.25
	local MAX_SKELETON_DIST = 1000
	local MAX_ESP_DIST = 5000
	local NUM_BONES = 14

	local highlightFolder = Instance.new("Folder")
	highlightFolder.Name = "Highlight_Storage"
	highlightFolder.Parent = CoreGui

	local overlayGui = Instance.new("ScreenGui")
	overlayGui.Name = "NightESP_Overlay"
	overlayGui.IgnoreGuiInset = true
	overlayGui.ResetOnSpawn = false
	overlayGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	overlayGui.DisplayOrder = 999999
	local okCore = pcall(function()
		overlayGui.Parent = CoreGui
	end)
	if not okCore or not overlayGui.Parent then
		overlayGui.Parent = localPlayer3:WaitForChild("PlayerGui")
	end

	local function createGuiLine(thickness, zIndex)
		local frame = Instance.new("Frame")
		frame.Name = "ESPLine"
		frame.AnchorPoint = Vector2.new(0.5, 0.5)
		frame.BorderSizePixel = 0
		frame.BackgroundColor3 = Color3.new(1, 1, 1)
		frame.BackgroundTransparency = 0
		frame.Size = UDim2.fromOffset(0, thickness or 2)
		frame.Visible = false
		frame.ZIndex = zIndex or 5

		local stroke = Instance.new("UIStroke")
		stroke.Color = Color3.new(0, 0, 0)
		stroke.Thickness = 1
		stroke.Transparency = 0.35
		stroke.Parent = frame

		frame.Parent = overlayGui
		return frame
	end

	local function drawGuiLine(frame, x1, y1, x2, y2, color, thickness)
		local dx = x2 - x1
		local dy = y2 - y1
		local len = math.sqrt(dx * dx + dy * dy)
		if len < 0.5 then
			frame.Visible = false
			return
		end
		frame.Position = UDim2.fromOffset((x1 + x2) * 0.5, (y1 + y2) * 0.5)
		frame.Size = UDim2.fromOffset(len, thickness or 2)
		frame.Rotation = math.deg(math.atan2(dy, dx))
		frame.BackgroundColor3 = color
		frame.Visible = true
	end

	local function getTeamColor(player)
		return (player.Team and player.Team.TeamColor and player.Team.TeamColor.Color) or Color3.new(1, 1, 1)
	end

	local function getDistance(player)
		local cached = distanceCache[player]
		local now = tick()
		if cached and (now - cached.time) < DIST_CACHE_TIME then
			return cached.distance
		end

		local data = playerCache[player]
		local myChar = localPlayer3.Character
		local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
		local dist = math.huge

		if data and data.hrp and data.hrp.Parent and myHrp then
			dist = (myHrp.Position - data.hrp.Position).Magnitude
		end

		distanceCache[player] = { distance = dist, time = now }
		return dist
	end

	local function getHealthColor(hp, maxHp)
		local pct = (maxHp > 0) and (hp / maxHp * 100) or 0
		if pct <= 25 then
			return Color3.fromRGB(255, 0, 0)
		elseif pct <= 50 then
			return Color3.fromRGB(255, 255, 0)
		end
		return Color3.fromRGB(0, 255, 0)
	end

	local function getEquippedTool(player)
		local data = playerCache[player]
		if not data or not data.char then
			return nil
		end
		for _, child in ipairs(data.char:GetChildren()) do
			if child:IsA("Tool") then
				return child.Name
			end
		end
		return nil
	end

	local function getOrCreateTag(player)
		if espTags[player] and espTags[player].gui and espTags[player].gui.Parent then
			return espTags[player]
		end
		if espTags[player] and espTags[player].gui then
			pcall(function() espTags[player].gui:Destroy() end)
		end

		local billboardGui = Instance.new("BillboardGui")
		billboardGui.Name = "ESPTag"
		billboardGui.Size = UDim2.new(0, 200, 0, 14)
		billboardGui.StudsOffset = Vector3.new(0, 2.2, 0)
		billboardGui.ExtentsOffset = Vector3.new(0, 0, 0)
		billboardGui.AlwaysOnTop = true
		billboardGui.MaxDistance = MAX_ESP_DIST
		billboardGui.ClipsDescendants = false
		billboardGui.Enabled = false

		local textLabel = Instance.new("TextLabel")
		textLabel.AnchorPoint = Vector2.new(0.5, 1)
		textLabel.Position = UDim2.new(0.5, 0, 1, 0)
		textLabel.Size = UDim2.new(1, 0, 0, 200)
		textLabel.Font = Enum.Font.GothamBold
		textLabel.TextSize = 11
		textLabel.TextColor3 = Color3.new(1, 1, 1)
		textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
		textLabel.TextStrokeTransparency = 0.2
		textLabel.BackgroundTransparency = 1
		textLabel.TextXAlignment = Enum.TextXAlignment.Center
		textLabel.TextYAlignment = Enum.TextYAlignment.Bottom
		textLabel.ClipsDescendants = false
		textLabel.RichText = true
		textLabel.Parent = billboardGui

		espTags[player] = { gui = billboardGui, label = textLabel }
		return espTags[player]
	end

	local function updateChamsColor(player)
		local hl = highlightFolder:FindFirstChild(player.Name)
		local data = playerCache[player]
		if hl and data and data.char and data.hrp then
			if hl.Adornee ~= data.char then
				hl.Adornee = data.char
			end
			local color = data.hrp:GetAttribute("IsWanted") and Color3.fromRGB(255, 255, 0) or getTeamColor(player)
			hl.FillColor = color
			hl.OutlineColor = color
			hl.Enabled = espSettings.ChamsESP
		elseif hl then
			hl.Enabled = false
		end
	end

	local function createChams(player)
		local existing = highlightFolder:FindFirstChild(player.Name)
		if existing then
			existing:Destroy()
		end

		local highlight = Instance.new("Highlight")
		highlight.Name = player.Name
		local color = getTeamColor(player)
		highlight.FillColor = color
		highlight.OutlineColor = color
		highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
		highlight.FillTransparency = 0.5
		highlight.OutlineTransparency = 0
		highlight.Enabled = espSettings.ChamsESP
		highlight.Parent = highlightFolder

		local data = playerCache[player]
		if data and data.char then
			highlight.Adornee = data.char
			updateChamsColor(player)
		end
	end

	local function createSkeleton(player)
		if skeletonLines[player] then
			return
		end
		skeletonLines[player] = {}
		for i = 1, NUM_BONES do
			skeletonLines[player][i] = createGuiLine(2, 10)
		end
	end

	local function hideSkeleton(player)
		if skeletonLines[player] then
			for _, frame in pairs(skeletonLines[player]) do
				if frame and frame.Parent then
					frame.Visible = false
				end
			end
		end
	end

	local function getSkeletonSegments(char)
		local head = char:FindFirstChild("Head")
		local upperTorso = char:FindFirstChild("UpperTorso")
		if head and upperTorso then
			local lowerTorso = char:FindFirstChild("LowerTorso") or upperTorso
			local lUA = char:FindFirstChild("LeftUpperArm")
			local lLA = char:FindFirstChild("LeftLowerArm")
			local lH = char:FindFirstChild("LeftHand")
			local rUA = char:FindFirstChild("RightUpperArm")
			local rLA = char:FindFirstChild("RightLowerArm")
			local rH = char:FindFirstChild("RightHand")
			local lUL = char:FindFirstChild("LeftUpperLeg")
			local lLL = char:FindFirstChild("LeftLowerLeg")
			local lF = char:FindFirstChild("LeftFoot")
			local rUL = char:FindFirstChild("RightUpperLeg")
			local rLL = char:FindFirstChild("RightLowerLeg")
			local rF = char:FindFirstChild("RightFoot")

			local headPos = head.Position
			local neckPos = upperTorso.CFrame * Vector3.new(0, upperTorso.Size.Y * 0.42, 0)
			local pelvisPos = lowerTorso.Position

			local lShoulder = lUA and (lUA.CFrame * Vector3.new(0, lUA.Size.Y * 0.38, 0)) or nil
			local lElbow = lLA and (lLA.CFrame * Vector3.new(0, lLA.Size.Y * 0.38, 0)) or (lUA and lUA.Position) or nil
			local lHand = (lH and lH.Position) or (lLA and lLA.Position) or nil

			local rShoulder = rUA and (rUA.CFrame * Vector3.new(0, rUA.Size.Y * 0.38, 0)) or nil
			local rElbow = rLA and (rLA.CFrame * Vector3.new(0, rLA.Size.Y * 0.38, 0)) or (rUA and rUA.Position) or nil
			local rHand = (rH and rH.Position) or (rLA and rLA.Position) or nil

			local lHip = lUL and (lUL.CFrame * Vector3.new(0, lUL.Size.Y * 0.38, 0)) or nil
			local lKnee = lLL and (lLL.CFrame * Vector3.new(0, lLL.Size.Y * 0.38, 0)) or (lUL and lUL.Position) or nil
			local lFoot = (lF and lF.Position) or (lLL and lLL.Position) or nil

			local rHip = rUL and (rUL.CFrame * Vector3.new(0, rUL.Size.Y * 0.38, 0)) or nil
			local rKnee = rLL and (rLL.CFrame * Vector3.new(0, rLL.Size.Y * 0.38, 0)) or (rUL and rUL.Position) or nil
			local rFoot = (rF and rF.Position) or (rLL and rLL.Position) or nil

			return {
				{ headPos, neckPos },
				{ neckPos, pelvisPos },
				{ neckPos, lShoulder },
				{ lShoulder, lElbow },
				{ lElbow, lHand },
				{ neckPos, rShoulder },
				{ rShoulder, rElbow },
				{ rElbow, rHand },
				{ pelvisPos, lHip },
				{ lHip, lKnee },
				{ lKnee, lFoot },
				{ pelvisPos, rHip },
				{ rHip, rKnee },
				{ rKnee, rFoot },
			}
		end

		local torso = char:FindFirstChild("Torso")
		if head and torso then
			local lArm = char:FindFirstChild("Left Arm")
			local rArm = char:FindFirstChild("Right Arm")
			local lLeg = char:FindFirstChild("Left Leg")
			local rLeg = char:FindFirstChild("Right Leg")
			local neckPos = torso.CFrame * Vector3.new(0, torso.Size.Y * 0.45, 0)
			local pelvisPos = torso.CFrame * Vector3.new(0, -torso.Size.Y * 0.45, 0)
			local lS = lArm and (lArm.CFrame * Vector3.new(0, lArm.Size.Y * 0.4, 0)) or nil
			local lH = lArm and (lArm.CFrame * Vector3.new(0, -lArm.Size.Y * 0.4, 0)) or nil
			local rS = rArm and (rArm.CFrame * Vector3.new(0, rArm.Size.Y * 0.4, 0)) or nil
			local rH = rArm and (rArm.CFrame * Vector3.new(0, -rArm.Size.Y * 0.4, 0)) or nil
			local lHi = lLeg and (lLeg.CFrame * Vector3.new(0, lLeg.Size.Y * 0.4, 0)) or nil
			local lFo = lLeg and (lLeg.CFrame * Vector3.new(0, -lLeg.Size.Y * 0.4, 0)) or nil
			local rHi = rLeg and (rLeg.CFrame * Vector3.new(0, rLeg.Size.Y * 0.4, 0)) or nil
			local rFo = rLeg and (rLeg.CFrame * Vector3.new(0, -rLeg.Size.Y * 0.4, 0)) or nil
			return {
				{ head.Position, neckPos },
				{ neckPos, pelvisPos },
				{ neckPos, lS },
				{ lS, lH },
				{ rS, rH },
				{ neckPos, rS },
				{ pelvisPos, lHi },
				{ lHi, lFo },
				{ pelvisPos, rHi },
				{ rHi, rFo },
			}
		end
		return nil
	end

	local function updatePlayerSkeleton(player, cam)
		local data = playerCache[player]
		if not data or not data.char or not data.char.Parent or not data.hrp or not data.hrp.Parent then
			hideSkeleton(player)
			return
		end
		if not data.hum or data.hum.Health <= 0 then
			hideSkeleton(player)
			return
		end
		if getDistance(player) > MAX_SKELETON_DIST then
			hideSkeleton(player)
			return
		end

		local hrpViewport, onScreen = cam:WorldToViewportPoint(data.hrp.Position)
		if not onScreen or hrpViewport.Z <= 0 then
			hideSkeleton(player)
			return
		end

		local lines = skeletonLines[player]
		if not lines then
			createSkeleton(player)
			lines = skeletonLines[player]
		end

		local segments = getSkeletonSegments(data.char)
		if not segments then
			hideSkeleton(player)
			return
		end

		local color = data.hrp:GetAttribute("IsWanted") and Color3.fromRGB(255, 215, 0) or getTeamColor(player)
		for i = 1, NUM_BONES do
			local frame = lines[i]
			local seg = segments[i]
			if frame then
				if seg and seg[1] and seg[2] then
					local v1, vis1 = cam:WorldToViewportPoint(seg[1])
					local v2, vis2 = cam:WorldToViewportPoint(seg[2])
					if (vis1 or vis2) and v1.Z > 0 and v2.Z > 0 then
						drawGuiLine(frame, v1.X, v1.Y, v2.X, v2.Y, color, 2)
					else
						frame.Visible = false
					end
				else
					frame.Visible = false
				end
			end
		end
	end

	local function isCacheInvalid(data)
		if not data then return true end
		if not data.char or not data.char.Parent then return true end
		if not data.hrp or not data.hrp.Parent then return true end
		if not data.hum or not data.hum.Parent then return true end
		if not data.head or not data.head.Parent then return true end
		return false
	end

	local function updatePlayerESP(player, forceUpdate)
		local data = playerCache[player]
		if isCacheInvalid(data) then
			local character = player.Character
			if not character or not character.Parent then
				lastUpdateTimes[player] = nil
				if espTags[player] and espTags[player].gui then
					espTags[player].gui.Enabled = false
				end
				return
			end
			local hrp = character:FindFirstChild("HumanoidRootPart")
			local hum = character:FindFirstChildOfClass("Humanoid")
			local head = character:FindFirstChild("Head")
			if not hrp or not hum or not head then
				lastUpdateTimes[player] = nil
				return
			end

			if espTags[player] and espTags[player].gui then
				pcall(function() espTags[player].gui:Destroy() end)
				espTags[player] = nil
			end

			playerCache[player] = { char = character, hrp = hrp, hum = hum, head = head }
			data = playerCache[player]
			lastUpdateTimes[player] = nil
		end

		local now = tick()
		if not forceUpdate and lastUpdateTimes[player] and (now - lastUpdateTimes[player]) < UPDATE_INTERVAL then
			return
		end
		lastUpdateTimes[player] = now

		local isWanted = data.hrp:GetAttribute("IsWanted") == true
		local hum = data.hum
		local dist = getDistance(player)

		local showAnyText = (
			espSettings.NameESP
			or espSettings.TeamESP
			or espSettings.DistanceESP
			or espSettings.HealthESP
			or espSettings.ToolESP
			or (espSettings.WantedESP and isWanted)
		)

		if showAnyText and dist <= MAX_ESP_DIST and hum.Health > 0 then
			pcall(function()
				hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
			end)

			local tag = getOrCreateTag(player)
			local gui = tag.gui
			local label = tag.label

			if gui.Parent ~= data.head or gui.Adornee ~= data.head then
				pcall(function()
					gui.Parent = data.head
					gui.Adornee = data.head
				end)
			end

			local teamColor = getTeamColor(player)
			local tr = math.floor(teamColor.R * 255)
			local tg = math.floor(teamColor.G * 255)
			local tb = math.floor(teamColor.B * 255)

			local lines = {}

			if espSettings.NameESP then
				table.insert(lines, string.format('<font color="rgb(255,255,255)"><b>%s</b></font>', player.Name))
			end

			if espSettings.WantedESP and isWanted then
				table.insert(lines, '<font color="rgb(255,215,0)"><b>★ WANTED ★</b></font>')
			end

			if espSettings.TeamESP and player.Team then
				table.insert(lines, string.format('<font color="rgb(%d,%d,%d)">%s</font>', tr, tg, tb, player.Team.Name))
			end

			if espSettings.ToolESP then
				local toolName = getEquippedTool(player)
				if toolName then
					table.insert(lines, string.format('<font color="rgb(173,216,230)">[%s]</font>', toolName))
				end
			end

			if espSettings.DistanceESP and dist < math.huge then
				table.insert(lines, string.format('<font color="rgb(200,200,200)">[%dm]</font>', math.floor(dist)))
			end

			if espSettings.HealthESP and hum then
				local hp = math.floor(hum.Health)
				local maxHp = math.floor(hum.MaxHealth)
				local hc = getHealthColor(hp, maxHp)
				local hr = math.floor(hc.R * 255)
				local hg = math.floor(hc.G * 255)
				local hb = math.floor(hc.B * 255)
				table.insert(lines, string.format('<font color="rgb(%d,%d,%d)">%d/%d</font>', hr, hg, hb, hp, maxHp))
			end

			if #lines > 0 then
				label.Text = table.concat(lines, "\n")
				gui.Enabled = true
			else
				gui.Enabled = false
			end
		else
			pcall(function()
				if hum and hum.Parent then
					hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.Viewer
				end
			end)
			if espTags[player] and espTags[player].gui then
				espTags[player].gui.Enabled = false
			end
			local existingTag = data.head and data.head:FindFirstChild("ESPTag")
			if existingTag then
				existingTag.Enabled = false
			end
		end

		if espSettings.ChamsESP then
			updateChamsColor(player)
		end
	end

	local function updateAllESP(forceUpdate)
		for _, player in ipairs(Players:GetPlayers()) do
			if player ~= localPlayer3 then
				pcall(updatePlayerESP, player, forceUpdate)
			end
		end
	end

	local function cacheCharacter(player, character)
		task.spawn(function()
			if not character then return end
			local hrp = character:FindFirstChild("HumanoidRootPart") or character:WaitForChild("HumanoidRootPart", 5)
			local hum = character:FindFirstChildOfClass("Humanoid") or character:WaitForChild("Humanoid", 5)
			local head = character:FindFirstChild("Head") or character:WaitForChild("Head", 5)
			if not hrp or not hum or not head or not character.Parent then
				return
			end
			playerCache[player] = { char = character, hrp = hrp, hum = hum, head = head }
			lastUpdateTimes[player] = nil
			createChams(player)
			createSkeleton(player)
			updatePlayerESP(player, true)

			hum.Died:Connect(function()
				hideSkeleton(player)
				if tracerLines[player] then
					tracerLines[player].Visible = false
				end
				if espTags[player] and espTags[player].gui then
					espTags[player].gui.Enabled = false
				end
			end)
		end)
	end

	local function setupPlayer(player)
		if player == localPlayer3 then return end
		createChams(player)
		createSkeleton(player)
		if not tracerLines[player] then
			tracerLines[player] = createGuiLine(1.5, 4)
		end
		if player.Character then
			cacheCharacter(player, player.Character)
		end
		if charConnections[player] then
			charConnections[player]:Disconnect()
		end
		charConnections[player] = player.CharacterAdded:Connect(function(character)
			playerCache[player] = nil
			lastUpdateTimes[player] = nil
			hideSkeleton(player)
			cacheCharacter(player, character)
		end)
		if charRemovingConnections[player] then
			charRemovingConnections[player]:Disconnect()
		end
		charRemovingConnections[player] = player.CharacterRemoving:Connect(function()
			playerCache[player] = nil
			lastUpdateTimes[player] = nil
			hideSkeleton(player)
			if tracerLines[player] then
				tracerLines[player].Visible = false
			end
			if espTags[player] and espTags[player].gui then
				espTags[player].gui.Enabled = false
			end
		end)
	end

	local playerAddedConn = Players.PlayerAdded:Connect(setupPlayer)

	local playerRemovingConn = Players.PlayerRemoving:Connect(function(player)
		if tracerLines[player] then
			pcall(function() tracerLines[player]:Destroy() end)
			tracerLines[player] = nil
		end
		if espTags[player] then
			if espTags[player].gui then
				pcall(function() espTags[player].gui:Destroy() end)
			end
			espTags[player] = nil
		end
		local hl = highlightFolder:FindFirstChild(player.Name)
		if hl then
			hl:Destroy()
		end
		if charConnections[player] then
			charConnections[player]:Disconnect()
			charConnections[player] = nil
		end
		if charRemovingConnections[player] then
			charRemovingConnections[player]:Disconnect()
			charRemovingConnections[player] = nil
		end
		if skeletonLines[player] then
			for _, frame in pairs(skeletonLines[player]) do
				pcall(function() frame:Destroy() end)
			end
			skeletonLines[player] = nil
		end
		lastUpdateTimes[player] = nil
		distanceCache[player] = nil
		playerCache[player] = nil
	end)

	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= localPlayer3 then
			setupPlayer(player)
		end
	end

	task.spawn(function()
		while espAlive do
			if espSettings.NameESP or espSettings.TeamESP or espSettings.ChamsESP or espSettings.WantedESP or espSettings.DistanceESP or espSettings.HealthESP or espSettings.ToolESP then
				updateAllESP(false)
			end
			task.wait(0.2)
		end
	end)

	local renderConn = RunService.RenderStepped:Connect(function()
		local cam = workspace.CurrentCamera
		if not cam then return end

		if espSettings.TracerESP then
			for player, frame in pairs(tracerLines) do
				local data = playerCache[player]
				if not data or isCacheInvalid(data) or data.hum.Health <= 0 or getDistance(player) > MAX_ESP_DIST then
					frame.Visible = false
				else
					local pos, onScreen = cam:WorldToViewportPoint(data.hrp.Position)
					if onScreen and pos.Z > 0 then
						local color = data.hrp:GetAttribute("IsWanted") and Color3.fromRGB(255, 165, 0) or getTeamColor(player)
						drawGuiLine(frame, cam.ViewportSize.X * 0.5, cam.ViewportSize.Y, pos.X, pos.Y, color, 1.5)
					else
						frame.Visible = false
					end
				end
			end
		else
			for _, frame in pairs(tracerLines) do
				if frame.Visible then
					frame.Visible = false
				end
			end
		end

		if espSettings.SkeletonESP then
			for _, player in ipairs(Players:GetPlayers()) do
				if player ~= localPlayer3 then
					updatePlayerSkeleton(player, cam)
				end
			end
		else
			for player in pairs(skeletonLines) do
				hideSkeleton(player)
			end
		end
	end)

	if getgenv then
		getgenv().NightESP_Cleanup = function()
			espAlive = false
			pcall(function() renderConn:Disconnect() end)
			pcall(function() playerAddedConn:Disconnect() end)
			pcall(function() playerRemovingConn:Disconnect() end)
			for _, conn in pairs(charConnections) do
				pcall(function() conn:Disconnect() end)
			end
			for _, conn in pairs(charRemovingConnections) do
				pcall(function() conn:Disconnect() end)
			end
			pcall(function() overlayGui:Destroy() end)
			pcall(function() highlightFolder:Destroy() end)
			for _, tag in pairs(espTags) do
				if tag.gui then
					pcall(function() tag.gui:Destroy() end)
				end
			end
		end
	end

	local function onEspToggleChanged(key, enabled)
		espSettings[key] = enabled

		if key == "TracerESP" and not enabled then
			for _, frame in pairs(tracerLines) do
				frame.Visible = false
			end
		elseif key == "ChamsESP" then
			for _, player in ipairs(Players:GetPlayers()) do
				if player ~= localPlayer3 then
					if not highlightFolder:FindFirstChild(player.Name) then
						createChams(player)
					end
					updateChamsColor(player)
				end
			end
		elseif key == "SkeletonESP" and not enabled then
			for player in pairs(skeletonLines) do
				hideSkeleton(player)
			end
		end

		table.clear(lastUpdateTimes)
		updateAllESP(true)
	end

	ESPTab:AddToggle({
		Name = "Name ESP",
		Title = "Name ESP",
		Text = "Name ESP",
		Default = false,
		Save = true,
		Flag = "NameESP",
		Callback = function(enabled)
			onEspToggleChanged("NameESP", enabled)
		end,
	})

	ESPTab:AddToggle({
		Name = "Team ESP",
		Title = "Team ESP",
		Text = "Team ESP",
		Default = false,
		Save = true,
		Flag = "TeamESP",
		Callback = function(enabled)
			onEspToggleChanged("TeamESP", enabled)
		end,
	})

	ESPTab:AddToggle({
		Name = "Chams ESP",
		Title = "Chams ESP",
		Text = "Chams ESP",
		Default = false,
		Save = true,
		Flag = "ChamsESP",
		Callback = function(enabled)
			onEspToggleChanged("ChamsESP", enabled)
		end,
	})

	ESPTab:AddToggle({
		Name = "Wanted ESP",
		Title = "Wanted ESP",
		Text = "Wanted ESP",
		Default = false,
		Save = true,
		Flag = "WantedESP",
		Callback = function(enabled)
			onEspToggleChanged("WantedESP", enabled)
		end,
	})

	ESPTab:AddToggle({
		Name = "Distance ESP",
		Title = "Distance ESP",
		Text = "Distance ESP",
		Default = false,
		Save = true,
		Flag = "DistanceESP",
		Callback = function(enabled)
			onEspToggleChanged("DistanceESP", enabled)
		end,
	})

	ESPTab:AddToggle({
		Name = "Tracer ESP",
		Title = "Tracer ESP",
		Text = "Tracer ESP",
		Default = false,
		Save = true,
		Flag = "TracerESP",
		Callback = function(enabled)
			onEspToggleChanged("TracerESP", enabled)
		end,
	})

	ESPTab:AddToggle({
		Name = "Health ESP",
		Title = "Health ESP",
		Text = "Health ESP",
		Default = false,
		Save = true,
		Flag = "HealthESP",
		Callback = function(enabled)
			onEspToggleChanged("HealthESP", enabled)
		end,
	})

	ESPTab:AddToggle({
		Name = "Skeleton ESP",
		Title = "Skeleton ESP",
		Text = "Skeleton ESP",
		Default = false,
		Save = true,
		Flag = "SkeletonESP",
		Callback = function(enabled)
			onEspToggleChanged("SkeletonESP", enabled)
		end,
	})

	ESPTab:AddToggle({
		Name = "Tool ESP",
		Title = "Tool ESP",
		Text = "Tool ESP",
		Default = false,
		Save = true,
		Flag = "ToolESP",
		Callback = function(enabled)
			onEspToggleChanged("ToolESP", enabled)
		end,
	})
end

local flag, settingsformisc, connection

do
	local v12 = workspace
	local TweenService = game:GetService("TweenService")
	game:GetService("Players")
	local VirtualInputManager = game:GetService("VirtualInputManager")
	local v13 = nil
	local flag2 = false
	flag = false

	settingsformisc = {
		plr = localPlayer,
		ws = v12,
		ts = TweenService,
		rs = RunService,
		uis = UserInputService,
		teams = game:GetService("Teams"),
		RadarFarmEnabled = false,
		remote = tbl2.RadarFarm,
		FARMspeed = 160,
		teleportActive = false,
		overlayGuis = {},
		targetPosition = nil,
		seatCheckConnection = nil,
		forceVisible = false,
		isSpecialTeleport = false,
	}

	_G.settingsformisc = settingsformisc

	local function fn4()
		local v14 = v12.Vehicles:FindFirstChild(localPlayer.Name)
		local humanoid = localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Humanoid")

		if v14 and humanoid and not humanoid.SeatPart then
			local driveSeat = v14:FindFirstChild("DriveSeat")

			if driveSeat then
				driveSeat:Sit(humanoid)
			end
		end
	end

	connection = nil

	local function fn6()
		if connection then
			connection:Disconnect()
			connection = nil
		end
	end

	local function fn5()
		if connection then
			connection:Disconnect()
			connection = nil
		end

		local startTime = tick()
		connection = RunService.Heartbeat:Connect(function()
			if tick() - startTime > 10 then
				fn6()
				return
			end
			fn4()
		end)
	end

	local function fn7(tbl6, s14)
		if not tbl6.PrimaryPart then
			return
		end
		tbl6:SetPrimaryPartCFrame(s14)

		for _, descendant in pairs(tbl6:GetDescendants()) do
			if descendant:IsA("BasePart") then
				descendant.AssemblyLinearVelocity = Vector3.zero
				descendant.AssemblyAngularVelocity = Vector3.zero
				descendant.Velocity = Vector3.zero
				descendant.RotVelocity = Vector3.zero
			end
		end
	end

	local function fn8(tbl6, s18, s19, fn9)
		if not tbl6.PrimaryPart then
			return
		end
		local cFrameValue = Instance.new("CFrameValue")
		cFrameValue.Value = tbl6:GetPrimaryPartCFrame()

		local connection2 = cFrameValue:GetPropertyChangedSignal("Value"):Connect(function()
			if tbl6 and tbl6.PrimaryPart then
				tbl6:SetPrimaryPartCFrame(cFrameValue.Value)

				for _, descendant in pairs(tbl6:GetDescendants()) do
					if descendant:IsA("BasePart") then
						descendant.AssemblyLinearVelocity = Vector3.zero
						descendant.AssemblyAngularVelocity = Vector3.zero
						descendant.Velocity = Vector3.zero
						descendant.RotVelocity = Vector3.zero
					end
				end
			end
		end)

		local tween = TweenService:Create(cFrameValue, TweenInfo.new(s19, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), { Value = s18 })
		tween:Play()

		tween.Completed:Connect(function()
			connection2:Disconnect()
			cFrameValue:Destroy()

			if fn9 then
				fn9()
			end
		end)
	end

	local function fn9(tbl6, s36)
		local n = tick() + (s36 or 5)
		local y = tbl6.PrimaryPart.Position.Y
		local state = 0

		while tick() < n do
			task.wait(0.1)
			if not tbl6 or not tbl6.Parent or not tbl6.PrimaryPart then
				return
			end
			local y2 = tbl6.PrimaryPart.Position.Y

			if math.abs(y2 - y) < 0.05 then
				state += 1
				if not (state >= 3) then
					y = y2
					continue
				end
				return
			end

			state = 0
			y = y2
		end
	end

	local function fn10(s34)
		local character = localPlayer.Character
		local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
		if not humanoidRootPart then
			return false
		end
		local position = humanoidRootPart.Position
		local raycastParams = RaycastParams.new()
		raycastParams.FilterType = Enum.RaycastFilterType.Exclude
		local filterDescendantsInstances = { character }

		if s34 then
			table.insert(filterDescendantsInstances, s34)
		end

		raycastParams.FilterDescendantsInstances = filterDescendantsInstances
		return v12:Raycast(position, Vector3.new(0, 50, 0), raycastParams) ~= nil
	end

	local function fn11(tbl6, fn12)
		local v14 = v12.Vehicles:FindFirstChild(localPlayer.Name)
		if not v14 then
			fn6()
			flag = false
			return
		end

		if not v14.PrimaryPart then
			v14.PrimaryPart = v14:FindFirstChildWhichIsA("BasePart", true)
		end

		if not v14.PrimaryPart then
			fn6()
			flag = false
			return
		end

		if fn10(v14) then
			fn6()
			flag = false
			OrionLib:MakeNotification({
				Name = "There is something above you",
				Content = "You cant teleport right now.",
				Image = "rbxassetid://16338529233",
				Time = 4,
			})

			return
		end

		local position = v14.PrimaryPart.Position
		local position2 = tbl6.Position
		v13 = position2

		local function fn13()
			fn6()
			flag = false
			v13 = nil

			if fn12 then
				fn12()
			end
		end

		local vector = Vector3.new(position.X, position.Y + 2, position.Z)
		local n = v14.PrimaryPart.CFrame - v14.PrimaryPart.CFrame.Position
		fn7(v14, CFrame.new(vector) * n)

		task.spawn(function()
			fn9(v14, 5)
			if not v14 or not v14.Parent or not v14.PrimaryPart then
				return
			end
			task.wait(0.5)
			if not v14 or not v14.Parent or not v14.PrimaryPart then
				return
			end
			local position3 = v14.PrimaryPart.Position
			local vector2 = Vector3.new(position3.X, position3.Y + 5000, position3.Z)
			local n2 = v14.PrimaryPart.CFrame - v14.PrimaryPart.CFrame.Position

			fn8(v14, CFrame.new(vector2) * n2, 0.5, function()
				if not v14 or not v14.Parent or not v14.PrimaryPart then
					return
				end
				task.wait(0.3)
				if not v14 or not v14.Parent or not v14.PrimaryPart then
					return
				end

				if _G.SetAntiFall then
					_G.SetAntiFall(true)
				end

				local y = v14.PrimaryPart.Position.Y
				local n3 = tick() + 3
				local exitTo = nil

				while true do
					if not (tick() < n3) then
						exitTo = 1
						break
					else
						if not (not v14 or not v14.Parent or not v14.PrimaryPart) then
							if y - v14.PrimaryPart.Position.Y >= 1 then
								exitTo = 1
								break
							else
								task.wait()
								continue
							end
						end

						break
					end
				end

				if exitTo == 1 then
					if not v14 or not v14.Parent or not v14.PrimaryPart then
						if _G.SetAntiFall then
							_G.SetAntiFall(false)
						end

						return
					end

					local vector3 = Vector3.new(position2.X, position2.Y + 49, position2.Z)
					local n4 = tbl6 - tbl6.Position
					fn7(v14, CFrame.new(vector3) * n4)
					local n5 = tick() + 8

					while tick() < n5 do
						if not (not v14 or not v14.Parent or not v14.PrimaryPart) then
							local hit = v12:Raycast(v14.PrimaryPart.Position, Vector3.new(0, -10, 0))
							if not (hit and v14.PrimaryPart.Position.Y - hit.Position.Y <= 2) then
								task.wait(0.1)
								continue
							end
						end

						break
					end

					if _G.SetAntiFall then
						_G.SetAntiFall(false)
					end

					fn13()

					if _G.BringOwnCarButtonAction then
						_G.BringOwnCarButtonAction()
					end

					return
				end

				if _G.SetAntiFall then
					_G.SetAntiFall(false)
				end
			end)
		end)
	end

	local function tp(s27, s28)
		if not _G.ScriptFullyLoaded then
			return
		end
		flag = true
		flag2 = false
		fn4()
		fn5()
		task.wait(0.5)
		fn11(s27, s28)
	end

	local function tpSpecial(s26, s27)
		if not _G.ScriptFullyLoaded then
			return
		end
		flag = true
		flag2 = true
		fn4()
		fn5()
		task.wait(0.5)
		fn11(s26, s27)
	end

	_G.tp = tp
	_G.tpSpecial = tpSpecial

	local function bringOwnCarButtonAction(autoSit)
		if not _G.ScriptFullyLoaded then
			return
		end
		local localPlayer3 = game.Players.LocalPlayer
		local character = localPlayer3.Character or localPlayer3.CharacterAdded:Wait()
		local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
		local humanoid = character:FindFirstChildWhichIsA("Humanoid")
		local vehicles = workspace:FindFirstChild("Vehicles")
		vehicles = vehicles and vehicles:FindFirstChild(localPlayer3.Name)

		if vehicles and vehicles:IsA("Model") then
			local driveSeat = vehicles:FindFirstChild("DriveSeat") or vehicles:FindFirstChildWhichIsA("VehicleSeat")

			if driveSeat then
				if not vehicles.PrimaryPart then
					vehicles.PrimaryPart = driveSeat
				end

				vehicles:SetPrimaryPartCFrame(humanoidRootPart.CFrame * CFrame.new(0, 3, -8))
				task.wait(0.2)

				if autoSit and humanoid and not humanoid.SeatPart then
					driveSeat:Sit(humanoid)
				end
			end
		end
	end

	_G.BringOwnCarButtonAction = bringOwnCarButtonAction
	local playerGui = localPlayer:WaitForChild("PlayerGui")

	local tbl6 = {
		["Clothing Store"] = CFrame.new(468.955, 5.62, -1446.053),
		Smuggler = "SPECIAL_SMUGGLER",
		["Truck Company"] = CFrame.new(710.446, 5.25, 1481.296),
		Harbor = "HARBOR_CONTAINER",
		["Osso Fuel"] = CFrame.new(-40.035869598388672, 5.8031911849975586, -753.695556640625),
		Hospital = CFrame.new(-289.66171264648, 3.6448979377747, 1124.63671875),
		ADAC = CFrame.new(-326.53564453125, 5.6045589447021484, 500.89096069335938),
		Jeweler = CFrame.new(-391.25955200195312, 5.7987871170043945, 3517.556640625),
		Prison = CFrame.new(-555.7913818359375, 5.4869866371154785, 3052.372314453125),
		Dealer = "SPECIAL_DEALER",
		["Tool Shop"] = CFrame.new(-745.48626708984375, 5.6109700202941895, 667.30517578125),
		["Ares Fuel"] = CFrame.new(-860.517333984375, 5.6106433868408203, 1500.6187744140625),
		["Vending Machine"] = "SPECIAL_VENDING",
		["Farm Shop"] = CFrame.new(-896.206, 4.984, -1165.972),
		["Fire Station"] = CFrame.new(-961.063232421875, 5.8525166511535645, 3894.586181640625),
		Bank = CFrame.new(-1151.82373046875, 5.8565840721130371, 3219.49169921875),
		["Parking Garage"] = CFrame.new(-1476.473, -23.862, 3669.67),
		["Gas-N-Go Fuel"] = CFrame.new(-1566.311, 5.25, 3812.591),
		Club = CFrame.new(-1858.259, 5.25, 3023.394),
		["Police Station"] = CFrame.new(-1656.735107421875, 5.6010093688964844, 2737.701171875),
		Dealership = CFrame.new(-1414.6466064453125, 5.6124324798583984, 942.3731689453125),
		["Tuning Garage"] = CFrame.new(-1504.6632080078, 5.1776194572449, 144.47509765625),
		["Bus Company"] = CFrame.new(-1676.292, 5.144, -1272.049),
	}

	local function fn12()
		local huge = math.huge
		local v14 = nil

		for _, descendant in pairs(v12:GetDescendants()) do
			if descendant:IsA("Model") and (descendant.Name == "Dealer" or descendant:GetAttribute("Dealer")) then
				local primaryPart = descendant.PrimaryPart or descendant:FindFirstChildWhichIsA("BasePart")

				if primaryPart then
					local magnitude = (localPlayer.Character.HumanoidRootPart.Position - primaryPart.Position).Magnitude

					if magnitude < huge then
						huge = magnitude
						v14 = primaryPart
					end
				end
			end
		end

		return v14 and v14.CFrame
	end

	local function fn13()
		local huge = math.huge
		local v14 = nil

		for _, descendant in pairs(v12:GetDescendants()) do
			if descendant:IsA("Model") and descendant.Name == "Smuggler" then
				local primaryPart = descendant.PrimaryPart or descendant:FindFirstChildWhichIsA("BasePart")

				if primaryPart then
					local magnitude = (localPlayer.Character.HumanoidRootPart.Position - primaryPart.Position).Magnitude

					if magnitude < huge then
						huge = magnitude
						v14 = primaryPart
					end
				end
			end
		end

		return v14 and v14.CFrame
	end

	local function fn14()
		local huge = math.huge
		local v14 = nil

		for _, descendant in pairs(v12:GetDescendants()) do
			if descendant:IsA("Model") and descendant.Name == "Vending Machine" then
				for _, child in pairs(descendant:GetChildren()) do
					if child:IsA("BasePart") and child.Name == "Light" and child.Color == Color3.fromRGB(73, 147, 0) then
						local magnitude = (localPlayer.Character.HumanoidRootPart.Position - child.Position).Magnitude

						if magnitude < huge then
							huge = magnitude
							v14 = child
						end
					end
				end
			end
		end

		return v14 and v14.CFrame
	end

	local function fn15()
		local cframe = CFrame.new

		return ({
			CFrame.new(-391.25955200195312, 5.7987871170043945, 3517.556640625),
			cframe(1166.626220703125, 29.150341033935547, 2157.30029296875),
		})[math.random(1, 2)]
	end

	local function fn16(tbl7)
		local parent = tbl7.Parent
		if parent and parent.Name == "NavigationMap" then
			return true
		end
		return false
	end

	local function fn17(tbl7)
		local tbl8 = {}

		for _, child in pairs(tbl7:GetChildren()) do
			if child:IsA("TextLabel") or child:IsA("TextButton") then
				if child.Text and child.Text ~= "" and child.Text ~= " " then
					table.insert(tbl8, child.Text)
				end
			end
		end

		return tbl8
	end

	local function fn18(list)
		if not list or #list == 0 then
			return nil
		end

		for _, v14 in pairs(list) do
			local str = v14:gsub("^%s+", ""):gsub("%s+$", "")

			for k in pairs(tbl6) do
				if str == k then
					return k
				end
			end
		end

		return nil
	end

	local flag3 = true

	if UserInputService.TouchEnabled then
	end

	local function fn19(arg1)
		if not _G.ScriptFullyLoaded then
			return
		end
		local v14 = tbl6[arg1]
		if not v14 then
			return
		end

		if v14 == "SPECIAL_DEALER" then
			local v15 = fn12()

			if v15 then
				tpSpecial(v15)
			end
		elseif v14 == "SPECIAL_SMUGGLER" then
			local v15 = fn13()

			if v15 then
				tpSpecial(v15)
			end
		elseif v14 == "SPECIAL_VENDING" then
			local v15 = fn14()

			if v15 then
				tpSpecial(v15)
			end
		elseif v14 == "HARBOR_CONTAINER" then
			local v15 = fn15()

			if v15 then
				tp(v15)
			end
		else
			tp(v14)
		end
	end

	local function fn20(s13)
		if not flag3 then
			return
		end
		fn19(s13)
	end

	local function fn21(tbl7)
		if not (tbl7:IsA("TextButton") or tbl7:IsA("ImageButton")) then
			return
		end

		tbl7.MouseButton1Click:Connect(function()
			if not fn16(tbl7) then
				return
			end
			local v14 = fn17(tbl7)
			if #v14 == 0 then
				return
			end
			local v15 = fn18(v14)

			if v15 then
				fn20(v15)
				VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.M, false, game)
				task.wait(0.05)
				VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.M, false, game)
			end
		end)
	end

	local function fn22()
		for _, child in pairs(playerGui:GetChildren()) do
			if child:IsA("ScreenGui") then
				for _, descendant in pairs(child:GetDescendants()) do
					fn21(descendant)
				end

				child.DescendantAdded:Connect(function(descendant)
					task.wait(0.05)
					fn21(descendant)
				end)
			end
		end
	end

	fn22()

	playerGui.ChildAdded:Connect(function(child)
		task.wait(0.1)

		if child:IsA("ScreenGui") then
			for _, descendant in pairs(child:GetDescendants()) do
				fn21(descendant)
			end

			child.DescendantAdded:Connect(function(descendant)
				task.wait(0.05)
				fn21(descendant)
			end)
		end
	end)

	TeleportTab:AddSection({ Name = "Map Teleports" })

	TeleportTab:AddToggle({
		Name = "Map Teleports",
		Default = true,
		Save = true,
		Flag = "TeleportsEnabled",
		Callback = function(arg1)
			flag3 = arg1
		end,
	})

	TeleportTab:AddParagraph("Map Teleports:", "When enabled, clicking a destination on the in-game Map (press M) will teleport you there automatically. If you disable this toggle, use the 'Button Teleports' section below instead to teleport manually via buttons.")
	TeleportTab:AddSection({ Name = "Main" })
	TeleportTab:AddButton({ Name = "Bring Own Car", Callback = bringOwnCarButtonAction })

	TeleportTab:AddButton({
		Name = "Dealer",
		Callback = function()
			local v14 = fn12()

			if v14 and _G.tpSpecial then
				_G.tpSpecial(v14)
			end
		end,
	})

	TeleportTab:AddButton({
		Name = "Smuggler",
		Callback = function()
			local v14 = fn13()

			if v14 and _G.tpSpecial then
				_G.tpSpecial(v14)
			end
		end,
	})

	TeleportTab:AddButton({
		Name = "Vending Machine",
		Callback = function()
			local v14 = fn14()

			if v14 and _G.tpSpecial then
				_G.tpSpecial(v14)
			end
		end,
	})

	TeleportTab:AddButton({
		Name = "Nearest Wanted Player",
		Callback = function()
			local huge = math.huge
			local v14 = nil

			for _, player in pairs(game.Players:GetPlayers()) do
				if player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character.HumanoidRootPart:GetAttribute("IsWanted") then
					local humanoidRootPart = player.Character.HumanoidRootPart
					local magnitude = (localPlayer.Character.HumanoidRootPart.Position - humanoidRootPart.Position).Magnitude

					if magnitude < huge then
						huge = magnitude
						v14 = humanoidRootPart
					end
				end
			end

			if v14 and _G.tpSpecial then
				_G.tpSpecial(v14.CFrame)
			end
		end,
	})

	TeleportTab:AddSection({ Name = "Button Teleports" })
	TeleportTab:AddParagraph("Button Teleports:", "Use these dropdowns to teleport manually if you have Map Teleports disabled.")
	local tbl7 = { "Police Station", "Bus Company", "Fire Station", "ADAC", "Truck Company" }

	local tbl8 = {
		"Bank",
		"Club",
		"Jeweler",
		"Harbor",
		"Gas-N-Go Fuel",
		"Ares Fuel",
		"Osso Fuel",
		"Clothing Store",
		"Farm Shop",
		"Tool Shop",
	}

	local tbl9 = {}
	local tbl10 = {}

	for _, v14 in ipairs(tbl7) do
		tbl10[v14] = true
	end

	for _, v14 in ipairs(tbl8) do
		tbl10[v14] = true
	end

	for k in pairs(tbl6) do
		if not tbl10[k] then
			table.insert(tbl9, k)
		end
	end

	table.sort(tbl9)
	local flag4 = true
	local flag5 = true
	local flag6 = true

	TeleportTab:AddDropdown({
		Name = "Work Places",
		Default = "...",
		Options = tbl7,
		Callback = function(s18)
			if flag4 then
				flag4 = false
				return
			end
			if not s18 or s18 == "..." or s18 == "" then
				return
			end
			fn19(s18)
		end,
	})

	TeleportTab:AddDropdown({
		Name = "Rob Places",
		Default = "...",
		Options = tbl8,
		Callback = function(s2)
			if flag5 then
				flag5 = false
				return
			end
			if not s2 or s2 == "..." or s2 == "" then
				return
			end
			fn19(s2)
		end,
	})

	TeleportTab:AddDropdown({
		Name = "Others",
		Default = "...",
		Options = tbl9,
		Callback = function(s32)
			if flag6 then
				flag6 = false
				return
			end
			if not s32 or s32 == "..." or s32 == "" then
				return
			end
			fn19(s32)
		end,
	})
end

PoliceTab:AddSection({ Name = "Auto Cuff" })
local RunService2

do
	local n = 10
	local flag2 = false
	local flag3 = false
	local tbl6 = {}
	Players = game:GetService("Players")
	RunService2 = game:GetService("RunService")
	local localPlayer3 = Players.LocalPlayer
	local screenGui2 = Instance.new("ScreenGui")
	screenGui2.Name = "AutoCuffTimerGui"
	screenGui2.AutoLocalize = false
	screenGui2.ResetOnSpawn = false
	screenGui2.DisplayOrder = 999
	screenGui2.Parent = game:GetService("CoreGui")
	local textLabel = Instance.new("TextLabel")
	textLabel.Size = UDim2.new(0, 300, 0, 30)
	textLabel.Position = UDim2.new(0.5, -150, 1, -70)
	textLabel.BackgroundTransparency = 1
	textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	textLabel.TextStrokeTransparency = 0
	textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	textLabel.Font = Enum.Font.GothamBold
	textLabel.TextSize = 16
	textLabel.Text = ""
	textLabel.Visible = false
	textLabel.Parent = screenGui2
	local n2 = 2.3

	local function fn4(n3)
		textLabel.Visible = true
		local now = tick()
		local v12 = nil

		return (RunService2.Heartbeat:Connect(function()
			local n4 = math.max(0, n3 - tick() - now)

			if n4 <= 0 then
				textLabel.Text = "Arrested"
				v12:Disconnect()
			else
				textLabel.Text = string.format("Arrest in... %.1fs", n4)
			end
		end))
	end

	local function fn5()
		textLabel.Visible = false
		textLabel.Text = ""
	end

	local function fn6()
		if not localPlayer3.Character then
			return false
		end

		for _, child in pairs(localPlayer3.Character:GetChildren()) do
			if child:IsA("Tool") and child.Name == "Handcuffs" then
				return true
			end
		end

		return false
	end

	local function fn7(tbl7)
		if not tbl7.Character then
			return false
		end
		return tbl7.Character:GetAttribute("IsCuffed") == true or tbl7.Character:GetAttribute("IsHeld") == true
	end

	local function fn8(tbl7)
		if not tbl7.Character then
			return false
		end
		local humanoidRootPart = tbl7.Character:FindFirstChild("HumanoidRootPart")
		if not humanoidRootPart then
			return false
		end
		return humanoidRootPart:GetAttribute("IsWanted") == true
	end

	local function fn9(tbl7, arg2)
		return arg2 or tbl7 and tbl7:FindFirstChild("HumanoidRootPart")
	end

	local function fn10(s19, s20, s21)
		local cuff = tbl2.Cuff
		if not cuff or not s19 or not s20 then
			return
		end

		pcall(function()
			cuff:FireServer(s19, s20, s21)
		end)
	end

	local function fn11()
		local detain = tbl2.Detain
		if not detain then
			return
		end

		pcall(function()
			detain:FireServer()
		end)
	end

	local function fn12(tbl7, tbl8)
		local v12 = fn4(2.3)
		local v13 = fn9(tbl8 and tbl8.Character or tbl7 and tbl7.Parent, tbl7)
		fn10(v13, "51O", "start")
		local now = tick()
		local flag4

		while true do
			flag4 = false

			if not (tick() - now < n2) then
				break
			else
				task.wait(0.05)
				local humanoidRootPart = localPlayer3.Character and localPlayer3.Character:FindFirstChild("HumanoidRootPart")

				if not humanoidRootPart or not tbl7.Parent then
					flag4 = true
					break
				elseif n < (humanoidRootPart.Position - tbl7.Position).Magnitude then
					flag4 = true
					break
				end
			end
		end

		if flag4 then
			fn10(v13, "51O", "cancel")
		else
			fn10(v13, "51O", "stop")
		end

		if v12 then
			v12:Disconnect()
		end

		if flag4 then
			textLabel.Visible = true
			textLabel.Text = "Too far - cancelled"
			task.wait(1)
		end

		fn5()

		if not flag4 and flag3 then
			fn11()
		end
	end

	local VirtualInputManager = game:GetService("VirtualInputManager")
	local isHoldingE = false
	local lastPressETick = 0

	local function startHoldingE()
		if not isHoldingE then
			isHoldingE = true
			_G.AutoCuffHoldingE = true
			pcall(function()
				VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
			end)
		end
	end

	local function stopHoldingE()
		if isHoldingE then
			isHoldingE = false
			_G.AutoCuffHoldingE = false
			pcall(function()
				VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
			end)
		end
	end

	localPlayer3.CharacterRemoving:Connect(function()
		stopHoldingE()
	end)

	RunService2.Heartbeat:Connect(function()
		if not flag2 then
			stopHoldingE()
			return
		end

		local character = localPlayer3.Character
		if not character then
			stopHoldingE()
			return
		end

		local humanoid = character:FindFirstChildOfClass("Humanoid")
		if (humanoid and humanoid.SeatPart) or _G.CarFlyActive then
			stopHoldingE()
			return
		end

		startHoldingE()
		local now = tick()
		if now - lastPressETick >= 0.5 then
			lastPressETick = now
			pcall(function()
				VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
			end)
		end
		local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
		if not humanoidRootPart then
			return
		end

		for _, player in ipairs(Players:GetPlayers()) do
			if player ~= localPlayer3 and player.Character and fn8(player) and not fn7(player) and not tbl6[player] then
				local humanoidRootPart2 = player.Character:FindFirstChild("HumanoidRootPart")

				if humanoidRootPart2 then
					if (humanoidRootPart.Position - humanoidRootPart2.Position).Magnitude <= n then
						tbl6[player] = true

						task.spawn(function()
							fn12(humanoidRootPart2, player)
							task.wait(1)
							tbl6[player] = nil
						end)
					end
				end
			end
		end
	end)

	PoliceTab:AddToggle({
		Name = "Auto Cuff",
		Default = false,
		Save = true,
		Flag = "AutoCuffEnabled",
		Callback = function(s36)
			flag2 = s36

			if not s36 then
				stopHoldingE()
				fn5()
				table.clear(tbl6)
			end
		end,
	})

	PoliceTab:AddToggle({
		Name = "Auto Unhold",
		Default = false,
		Save = true,
		Flag = "AutoUnholdEnabled",
		Callback = function(arg1)
			flag3 = arg1
		end,
	})
end

PoliceTab:AddSection({ Name = "Utility" })

do
	local flag2 = false
	local n = 0
	local tbl6 = {}
	local n2 = 8

	local function fn4(tbl7)
		local now = tick()
		local position = tbl7.Position
		local assemblyLinearVelocity = tbl7.AssemblyLinearVelocity or Vector3.zero
		local v12 = tbl6[tbl7]
		local n3

		if v12 then
			local n4 = math.max(now - v12.time, 0.0001)
			n3 = assemblyLinearVelocity * 0.5 + (position - v12.pos) / n4 * 0.4 + v12.vel * 0.1 + (assemblyLinearVelocity - v12.vel) / n4 * 0.05
		else
			n3 = assemblyLinearVelocity
		end

		tbl6[tbl7] = { pos = position, vel = assemblyLinearVelocity, time = now }
		return position + n3 * math.clamp((workspace.CurrentCamera.CFrame.Position - position).Magnitude / 80 + 0.06, 0.06, 0.4)
	end

	local function fn5()
		local localPlayer3 = game.Players.LocalPlayer
		local character = localPlayer3.Character
		if not character then
			return nil
		end
		local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
		if not humanoidRootPart then
			return nil
		end
		local n3 = 22
		local v12 = nil

		for _, player in ipairs(game.Players:GetPlayers()) do
			if player ~= localPlayer3 then
				local character2 = player.Character

				if character2 then
					local humanoidRootPart2 = character2:FindFirstChild("HumanoidRootPart")
					local humanoid = character2:FindFirstChildOfClass("Humanoid")

					if not (not humanoidRootPart2 or not humanoid or humanoid.Health <= 0) then
						if humanoidRootPart2:GetAttribute("IsWanted") then
							if not character2:GetAttribute("IsCuffed") then
								if not character2:GetAttribute("IsHeld") then
									if not (humanoid.MaxHealth > 0 and humanoid.Health / humanoid.MaxHealth < 0.25) then
										local magnitude = (humanoidRootPart.Position - humanoidRootPart2.Position).Magnitude

										if magnitude < n3 then
											n3 = magnitude
											v12 = player
										end
									end
								end
							end
						end
					end
				end
			end
		end

		return v12
	end

	PoliceTab:AddToggle({
		Name = "Auto Taser",
		Default = false,
		Callback = function(arg1)
			flag2 = arg1
		end,
	})

	local flag3 = false
	local str = "Patrol Police"
	local startShift = fn3("startShift")
	local vector = Vector3.new(-1677.5431, 6.999982, 2802.7532)
	local n3 = 20
	local connection2 = nil
	local n4 = 0

	local function fn6()
		if connection2 then
			connection2:Disconnect()
		end

		connection2 = game:GetService("RunService").Heartbeat:Connect(function()
			if not flag3 then
				return
			end

			if os.clock() - n4 < 0.5 then
				return
			end
			local character = game.Players.LocalPlayer.Character
			if not character then
				return
			end
			local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
			if not humanoidRootPart then
				return
			end

			if n3 < (humanoidRootPart.Position - vector).Magnitude then
				return
			end
			n4 = os.clock()
			startShift:FireServer(str)
		end)
	end

	PoliceTab:AddToggle({
		Name = "Shift Sniper",
		Default = false,
		Flag = "ShiftSniperEnabled",
		Callback = function(s15)
			flag3 = s15

			if s15 then
				fn6()
			elseif connection2 then
				connection2:Disconnect()
				connection2 = nil
			end
		end,
	})

	PoliceTab:AddDropdown({
		Name = "Shift Sniper Job",
		Default = "Patrol Police",
		Options = { "Patrol Police", "Traffic Police", "Undercover Police", "SEK" },
		Flag = "ShiftSniperJob",
		Callback = function(arg1)
			str = arg1
		end,
	})

	local str2 = "Not active"

	local function fn7()
		local ok, result = pcall(function()
			return require(game:GetService("Players").LocalPlayer.PlayerScripts.Code.controllers.radioController)
		end)

		if not ok or not result or not result.RadioController then
			return nil
		end
		return result.RadioController
	end

	local function fn8()
		local ok, result = pcall(function()
			return require(game:GetService("Players").LocalPlayer.PlayerScripts.Code.producer)
		end)

		if not ok or not result or not result.producer then
			return nil
		end
		return result.producer
	end

	local v12 = fn7()
	local v13 = fn8()

	local function fn9(tbl7)
		if not tbl7 then
			return nil
		end

		if tbl7:IsA("BasePart") then
			return tbl7.CFrame
		end

		if tbl7:IsA("Model") then
			if tbl7.PrimaryPart then
				return tbl7.PrimaryPart.CFrame
			end
			return (tbl7:GetBoundingBox())
		end

		return nil
	end

	local function fn10(s35)
		local v14 = fn9(s35)

		if v14 and _G.tpSpecial then
			_G.tpSpecial(v14)
		end
	end

	if v12 then
		local onSystemMessage = v12.onSystemMessage

		v12.onSystemMessage = function(s33, s34, tbl7)
			if str2 == "Auto Teleport to Dispatch" and tbl7 and tbl7.navigationTarget then
				local localPlayer3 = game.Players.LocalPlayer

				if (localPlayer3.Team and localPlayer3.Team.Name or nil) == s34 then
					fn10(tbl7.navigationTarget.instance)
				end
			end

			return onSystemMessage(s33, s34, tbl7)
		end
	end

	if v13 then
		local enableNavigationTarget = v13.enableNavigationTarget

		v13.enableNavigationTarget = function(s30)
			if str2 == "Click to Teleport to Dispatch" then
				fn10(s30)
			end

			return enableNavigationTarget(s30)
		end
	end

	PoliceTab:AddDropdown({
		Name = "Dispatch Teleport",
		Default = "Not active",
		Options = { "Not active", "Auto Teleport to Dispatch", "Click to Teleport to Dispatch" },
		Save = true,
		Flag = "DispatchTeleportMode",
		Callback = function(arg1)
			str2 = arg1
		end,
	})

	game:GetService("RunService").Heartbeat:Connect(function()
		if not flag2 then
			return
		end
		local now = tick()
		if now - n < n2 then
			return
		end
		local character = game.Players.LocalPlayer.Character
		if not character then
			return
		end
		local head = character:FindFirstChild("Head")
		if not head then
			return
		end
		local v14 = nil

		for _, child in ipairs(character:GetChildren()) do
			if child:IsA("Tool") and child.Name:lower():find("taser") then
				v14 = child
				break
			else
				v14 = nil
			end
		end

		if not v14 then
			return
		end
		local v15 = fn5()
		if not v15 or not v15.Character then
			return
		end
		local humanoidRootPart = v15.Character:FindFirstChild("HumanoidRootPart") or v15.Character:FindFirstChild("UpperTorso") or v15.Character:FindFirstChild("Head")
		if not humanoidRootPart then
			return
		end
		local v16 = fn4(humanoidRootPart)
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		local n5 = head.Position + (head.CFrame - head.Position):PointToWorldSpace(humanoid and humanoid.CameraOffset or Vector3.new(0, 1.5, 0))
		local unit = (v16 - n5).Unit

		if tbl2.AutoTaser then
			tbl2.AutoTaser:FireServer(v14, n5, unit)
			n = now
		end
	end)
end

PoliceTab:AddSection({ Name = "Taser Silent Aim" })

do
	local flag2 = false
	local flag3 = false
	local color = Color3.fromRGB(255, 220, 0)
	local line = nil
	local flag4 = false
	local v12 = nil
	local tbl6 = {}
	local n = 50
	local n2 = 0.6
	local autoTaser = tbl2.AutoTaser or RemoteAutoTaser
	local touchEnabled = game:GetService("UserInputService").TouchEnabled
	local position = nil
	local flag5 = false
	local flag6 = false
	local isHoldingLMB = false
	local lastAutoTaserTick = 0

	local showFov = true
	local fovRadius = 150
	local fovColor = Color3.fromRGB(0, 200, 255)
	local fovCircle = Drawing.new("Circle")
	fovCircle.Filled = false
	fovCircle.Thickness = 1.5
	fovCircle.Transparency = 1
	fovCircle.Color = fovColor
	fovCircle.Radius = fovRadius
	fovCircle.Visible = false

	local function fn4()
		local character = game.Players.LocalPlayer.Character
		if not character then
			return nil
		end

		for _, child in ipairs(character:GetChildren()) do
			if child:IsA("Tool") and child.Name:lower():find("taser") then
				return child
			end
		end

		return nil
	end

	local function fn5(tbl7)
		local now = tick()
		local position2 = tbl7.Position
		local assemblyLinearVelocity = tbl7.AssemblyLinearVelocity or Vector3.zero
		local v13 = tbl6[tbl7]
		local n3

		if v13 then
			local n4 = math.max(now - v13.time, 0.0001)
			n3 = assemblyLinearVelocity * 0.5 + (position2 - v13.pos) / n4 * 0.4 + v13.vel * 0.1 + (assemblyLinearVelocity - v13.vel) / n4 * 0.05
		else
			n3 = assemblyLinearVelocity
		end

		tbl6[tbl7] = { pos = position2, vel = assemblyLinearVelocity, time = now }
		return position2 + n3 * math.clamp((workspace.CurrentCamera.CFrame.Position - position2).Magnitude / 80 + 0.06, 0.06, 0.4)
	end

	local function fn6()
		local localPlayer3 = game.Players.LocalPlayer
		local character = localPlayer3.Character
		if not character then
			return nil
		end
		local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
		if not humanoidRootPart then
			return nil
		end
		local currentCamera = workspace.CurrentCamera
		local lookVector = currentCamera.CFrame.LookVector
		local center = Vector2.new(currentCamera.ViewportSize.X / 2, currentCamera.ViewportSize.Y / 2)
		local huge = math.huge
		local v13 = nil

		for _, player in ipairs(game.Players:GetPlayers()) do
			if player ~= localPlayer3 then
				local character2 = player.Character

				if character2 then
					local humanoidRootPart2 = character2:FindFirstChild("HumanoidRootPart")
					local humanoid = character2:FindFirstChildOfClass("Humanoid")

					if not (not humanoidRootPart2 or not humanoid or humanoid.Health <= 0) then
						local isWanted = humanoidRootPart2:GetAttribute("IsWanted") == true or character2:GetAttribute("IsWanted") == true or player:GetAttribute("IsWanted") == true
						if isWanted then
							if not character2:GetAttribute("IsCuffed") and not character2:GetAttribute("IsHeld") then
								if not (humanoid.MaxHealth > 0 and humanoid.Health / humanoid.MaxHealth < 0.25) then
									local magnitude = (humanoidRootPart.Position - humanoidRootPart2.Position).Magnitude

									if magnitude <= n then
										local screenPos, onScreen = currentCamera:WorldToViewportPoint(humanoidRootPart2.Position)
										if onScreen and screenPos.Z > 0 then
											local distToCenter = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
											if distToCenter <= fovRadius then
												local n3 = magnitude / n * (1 - n2) + math.acos(math.clamp(lookVector:Dot((humanoidRootPart2.Position - currentCamera.CFrame.Position).Unit), -1, 1)) / 3.1415926535897931 * n2

												if n3 < huge then
													huge = n3
													v13 = player
												end
											end
										end
									end
								end
							end
						end
					end
				end
			end
		end

		if not v13 then
			for _, player in ipairs(game.Players:GetPlayers()) do
				if player ~= localPlayer3 then
					local character2 = player.Character
					if character2 and not character2:GetAttribute("IsCuffed") and not character2:GetAttribute("IsHeld") then
						local hrp2 = character2:FindFirstChild("HumanoidRootPart")
						local hum2 = character2:FindFirstChildOfClass("Humanoid")
						if hrp2 and hum2 and hum2.Health > 0 then
							local magnitude = (humanoidRootPart.Position - hrp2.Position).Magnitude
							if magnitude <= n then
								local screenPos, onScreen = currentCamera:WorldToViewportPoint(hrp2.Position)
								if onScreen and screenPos.Z > 0 then
									local distToCenter = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
									if distToCenter <= fovRadius and distToCenter < huge then
										huge = distToCenter
										v13 = player
									end
								end
							end
						end
					end
				end
			end
		end

		return v13
	end

	local function fn7()
		local localPlayer3 = game.Players.LocalPlayer
		local character = localPlayer3.Character
		if not character then
			return nil
		end
		local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
		if not humanoidRootPart then
			return nil
		end
		local currentCamera = workspace.CurrentCamera
		local lookVector = currentCamera.CFrame.LookVector
		local center = Vector2.new(currentCamera.ViewportSize.X / 2, currentCamera.ViewportSize.Y / 2)
		local huge = math.huge
		local v13 = nil

		for _, player in ipairs(game.Players:GetPlayers()) do
			if player ~= localPlayer3 then
				local character2 = player.Character

				if character2 then
					local humanoidRootPart2 = character2:FindFirstChild("HumanoidRootPart")
					local humanoid = character2:FindFirstChildOfClass("Humanoid")

					if not (not humanoidRootPart2 or not humanoid or humanoid.Health <= 0) then
						if not character2:GetAttribute("IsCuffed") and not character2:GetAttribute("IsHeld") then
							if not (humanoid.MaxHealth > 0 and humanoid.Health / humanoid.MaxHealth < 0.25) then
								local magnitude = (humanoidRootPart.Position - humanoidRootPart2.Position).Magnitude
								if magnitude <= n then
									local screenPos, onScreen = currentCamera:WorldToViewportPoint(humanoidRootPart2.Position)
									if onScreen and screenPos.Z > 0 then
										local distToCenter = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
										if distToCenter <= fovRadius and distToCenter < huge then
											huge = distToCenter
											v13 = player
										end
									end
								end
							end
						end
					end
				end
			end
		end

		return v13
	end

	local function fn8()
		if not flag2 then
			return
		end

		if flag4 then
			return
		end
		local v13 = fn4()
		if not v13 then
			return
		end
		local v14 = fn6() or v12 or fn7()
		if not v14 or not v14.Character then
			return
		end
		local humanoidRootPart = v14.Character:FindFirstChild("HumanoidRootPart") or v14.Character:FindFirstChild("UpperTorso") or v14.Character:FindFirstChild("Torso") or v14.Character:FindFirstChild("Head")
		if not humanoidRootPart then
			return
		end
		flag4 = true
		local v15 = fn5(humanoidRootPart)
		local character = game.Players.LocalPlayer.Character
		local head = character and character:FindFirstChild("Head")
		if not head then
			flag4 = false
			return
		end

		if not character:FindFirstChildOfClass("Humanoid") then
			flag4 = false
			return
		end
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		local n3 = head.Position + (head.CFrame - head.Position):PointToWorldSpace(humanoid and humanoid.CameraOffset or Vector3.new(0, 1.5, 0))
		local unit = (v15 - n3).Unit
		local attribute = v13:GetAttribute("LastDeployed") or 0

		local remoteToUse = autoTaser or tbl2.AutoTaser or RemoteAutoTaser
		if remoteToUse then
			pcall(function()
				remoteToUse:FireServer(v13, n3, unit)
			end)
			pcall(function()
				remoteToUse:FireServer(v13, v15, unit)
			end)
		end

		pcall(function()
			v13:Activate()
		end)

		local currentCamera = workspace.CurrentCamera
		local cFrame = currentCamera.CFrame
		local cameraType = currentCamera.CameraType
		currentCamera.CameraType = Enum.CameraType.Scriptable
		currentCamera.CFrame = CFrame.new(cFrame.Position, v15)

		task.defer(function()
			currentCamera.CFrame = cFrame
			currentCamera.CameraType = cameraType
		end)

		task.delay(0.12, function()
			if (v13 and v13:GetAttribute("LastDeployed") or 0) ~= attribute then
				local character2 = game.Players.LocalPlayer.Character
				character2 = character2 and character2:FindFirstChild("HumanoidRootPart")

				if character2 then
					local sound = Instance.new("Sound")
					sound.SoundId = "rbxassetid://277635663"
					sound.Volume = 1
					sound.Parent = character2
					sound:Play()
					game:GetService("Debris"):AddItem(sound, 3)
				end
			end
		end)

		task.delay(0.2, function()
			flag4 = false
		end)
	end

	game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			isHoldingLMB = true
		end
	end)

	game:GetService("UserInputService").InputEnded:Connect(function(input, gameProcessed)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			isHoldingLMB = false
		end
	end)

	game:GetService("RunService").Heartbeat:Connect(function()
		if not flag2 then return end
		local taserTool = fn4()
		if not taserTool then return end

		local isPressed = isHoldingLMB or game:GetService("UserInputService"):IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
		if isPressed then
			local now = tick()
			if now - lastAutoTaserTick >= 0.25 and not flag4 then
				lastAutoTaserTick = now
				task.spawn(fn8)
			end
		end
	end)

	local tbl7 = { touch = false, startPos = nil, currentPos = nil }

	game:GetService("UserInputService").TouchStarted:Connect(function(tbl8, arg2)
		if arg2 then
			return
		end

		if not fn4() then
			return
		end
		local playerGui = game.Players.LocalPlayer:FindFirstChild("PlayerGui")

		if playerGui then
			local descendants = playerGui:GetDescendants()

			for _, v13 in ipairs(descendants) do
				if v13:IsA("GuiButton") and v13.Active and v13.Visible then
					local absolutePosition = v13.AbsolutePosition
					local absoluteSize = v13.AbsoluteSize
					if tbl8.Position.X >= absolutePosition.X and tbl8.Position.X <= absolutePosition.X + absoluteSize.X and tbl8.Position.Y >= absolutePosition.Y and tbl8.Position.Y <= absolutePosition.Y + absoluteSize.Y then
						return
					end
				end
			end
		end

		if tbl8.Position.X > game:GetService("UserInputService").ViewportSize.X / 2 and flag5 == false then
			flag5 = true
			flag6 = false
			position = tbl8.Position
			tbl7.touch = true
			tbl7.startPos = tbl8.Position
			tbl7.currentPos = tbl8.Position

			if flag2 and fn4() then
				task.spawn(fn8)
			end
		end
	end)

	game:GetService("UserInputService").TouchMoved:Connect(function(tbl8, arg2)
		if arg2 then
			return
		end

		if not flag5 then
			return
		end

		if tbl8.Position.X < game:GetService("UserInputService").ViewportSize.X / 2 then
			flag5 = false
			flag6 = false
			position = nil
			tbl7.touch = false
			return
		end

		flag6 = true
		local n3 = tbl8.Position - position

		if n3.Magnitude > 5 then
			local currentCamera = workspace.CurrentCamera
			currentCamera.CFrame = currentCamera.CFrame * CFrame.Angles(0, -n3.X * 0.15 / 100, 0) * CFrame.Angles(-n3.Y * 0.15 / 100, 0, 0)
			position = tbl8.Position
			tbl7.currentPos = tbl8.Position
		end
	end)

	game:GetService("UserInputService").TouchEnded:Connect(function(hit, arg2)
		if arg2 then
			return
		end

		if flag5 then
			if not flag6 then
				if flag2 and fn4() then
					task.spawn(fn8)
				end
			end

			flag5 = false
			flag6 = false
			position = nil
			tbl7.touch = false
		end
	end)

	game:GetService("ContextActionService"):BindActionAtPriority("TaserSilentAimMain", function(arg1, n3)
		if n3 == Enum.UserInputState.Begin then
			isHoldingLMB = true
			if flag2 and fn4() and not touchEnabled then
				task.spawn(fn8)
			end
		elseif n3 == Enum.UserInputState.End or n3 == Enum.UserInputState.Cancel then
			isHoldingLMB = false
		end

		return Enum.ContextActionResult.Pass
	end, false, 10001, Enum.UserInputType.MouseButton1, Enum.KeyCode.ButtonR2, Enum.UserInputType.Touch)

	game:GetService("RunService").RenderStepped:Connect(function()
		local currentCamera = workspace.CurrentCamera
		local center = Vector2.new(currentCamera.ViewportSize.X / 2, currentCamera.ViewportSize.Y / 2)

		if fovCircle then
			fovCircle.Position = center
			fovCircle.Radius = fovRadius
			fovCircle.Color = fovColor
			fovCircle.Visible = flag2 and showFov
		end

		v12 = fn6()
		local v13 = v12 or fn7()

		if not flag2 or not flag3 or not fn4() or not v13 or not v13.Character then
			if line then
				line.Visible = false
			end

			return
		end

		local head = v13.Character:FindFirstChild("Head")

		if not head then
			if line then
				line.Visible = false
			end

			return
		end

		local v14, v15 = currentCamera:WorldToViewportPoint(head.Position)

		if not v15 then
			if line then
				line.Visible = false
			end

			return
		end

		if line then
			line.Color = color
			line.From = center
			line.To = Vector2.new(v14.X, v14.Y)
			line.Visible = true
		end
	end)

	PoliceTab:AddToggle({
		Name = "Taser Silent Aim",
		Default = false,
		Save = true,
		Flag = "TaserSilentAimEnabled",
		Callback = function(s33)
			flag2 = s33

			if not s33 then
				if line then
					line.Visible = false
				end
				if fovCircle then
					fovCircle.Visible = false
				end
			end
		end,
	})

	PoliceTab:AddToggle({
		Name = "Show Taser FOV Circle",
		Default = true,
		Save = true,
		Flag = "TaserShowFOV",
		Callback = function(val)
			showFov = val
			if fovCircle then
				fovCircle.Visible = flag2 and val
			end
		end,
	})

	PoliceTab:AddSlider({
		Name = "Taser FOV Radius",
		Min = 20,
		Max = 600,
		Default = 150,
		Increment = 5,
		Color = Color3.fromRGB(0, 200, 255),
		ValueName = "px",
		Save = true,
		Flag = "TaserFOVRadius",
		Callback = function(val)
			fovRadius = val
			if fovCircle then
				fovCircle.Radius = val
			end
		end,
	})

	PoliceTab:AddColorpicker({
		Name = "Taser FOV Color",
		Default = Color3.fromRGB(0, 200, 255),
		Save = true,
		Flag = "TaserFOVColor",
		Callback = function(val)
			fovColor = val
			if fovCircle then
				fovCircle.Color = val
			end
		end,
	})

	PoliceTab:AddToggle({
		Name = "Taser Tracer",
		Default = false,
		Save = true,
		Flag = "TaserTracerEnabled",
		Callback = function(s12)
			flag3 = s12

			if not s12 and line then
				line.Visible = false
			end

			if s12 and not line then
				line = Drawing.new("Line")
				line.Thickness = 1
				line.Transparency = 1
				line.Color = color
				line.Visible = false
			end
		end,
	})

	PoliceTab:AddColorpicker({
		Name = "Taser Tracer Color",
		Default = color,
		Save = true,
		Flag = "TaserTracerColor",
		Callback = function(color2)
			color = color2

			if line then
				line.Color = color2
			end
		end,
	})
end

PoliceTab:AddSection({ Name = "Radar Farm" })

do
	PoliceTab:AddToggle({
		Name = "Radar Farm",
		Default = false,
		Save = true,
		Flag = "RadarFarmToggle",
		Callback = function(state)
			_G.RadarFarmEnabled = state
			if settingsformisc then settingsformisc.RadarFarmEnabled = state end
			if state then
				task.spawn(function()
					local lastScan = 0
					while _G.RadarFarmEnabled do
						local now = tick()
						if now - lastScan >= 1 then
							local lp = LocalPlayer or game.Players.LocalPlayer
							local char = lp and lp.Character
							if char then
								local radarGun = char:FindFirstChild("Radar Gun")
								if not radarGun then
									local bp = lp:FindFirstChild("Backpack")
									local bpGun = bp and bp:FindFirstChild("Radar Gun")
									local hum = char:FindFirstChildOfClass("Humanoid")
									if bpGun and hum then
										pcall(function() hum:EquipTool(bpGun) end)
									end
									radarGun = char:FindFirstChild("Radar Gun")
								end

								local remote = RemoteRadarFarm or (RemoteFolder and RemoteFolder:FindFirstChild("7ef6d64b-7bdd-4bb5-9543-8e8321cdd130"))
								if radarGun and remote then
									local vf = workspace:FindFirstChild("Vehicles")
									if vf then
										local vehicles = vf:GetChildren()
										local primaryPart = char.PrimaryPart or char:FindFirstChild("HumanoidRootPart")
										if primaryPart then
											for i = 1, #vehicles do
												if not _G.RadarFarmEnabled then break end
												local v = vehicles[i]
												local driveSeat = v:FindFirstChild("DriveSeat")
												if driveSeat then
													remote:FireServer(radarGun, driveSeat.Position, (driveSeat.Position - primaryPart.Position).Unit)
												end
											end
										end
									end
								end
							end
							lastScan = now
						end
						task.wait(0.1)
					end
				end)
			end
		end,
	})
end

PoliceTab:AddButton({
	Name = "Anti-AFK",
	Callback = function()
		local VirtualUser = game:service("VirtualUser")

		game:service("Players").LocalPlayer.Idled:connect(function()
			VirtualUser:CaptureController()
			VirtualUser:ClickButton2(Vector2.new())
		end)
	end,
})

PoliceTab:AddParagraph("Radar Farm:", "Equip your radar gun and activate this feature to automatically scan speeding vehicles that are in sight. Earn at least 1,000 XP per hour.")

PoliceTab:AddSection({ Name = "Radar Farm Positions" })

local tbl6 = {
	["Downtown (Bank)"] = CFrame.new(-1280.396728515625, 5.3425455093383789, 3189.96630859375),
	["Police Station Loop"] = CFrame.new(-1146.3516845703125, 4.7257943153381348, 2804.246337890625),
	["Construction Site"] = CFrame.new(238.70320129394531, 9.3783559799194336, 1587.0628662109375),
	["Dealership Statue"] = CFrame.new(-1088.08251953125, 4.5534591674804688, 816.651123046875),
}

local initialRadarTp = true

PoliceTab:AddDropdown({
	Name = "Teleport to Position",
	Default = "...",
	Options = { "Downtown (Bank)", "Police Station Loop", "Construction Site", "Dealership Statue" },
	Save = false,
	Callback = function(arg1)
		if not _G.ScriptFullyLoaded or initialRadarTp then
			initialRadarTp = false
			return
		end
		if not arg1 or arg1 == "..." or arg1 == "" then
			return
		end
		local v12 = tbl6[arg1]

		if v12 and _G.tp then
			_G.tp(v12)
		end
	end,
})

for _, posName in ipairs({ "Downtown (Bank)", "Police Station Loop", "Construction Site", "Dealership Statue" }) do
	PoliceTab:AddButton({
		Name = posName,
		Callback = function()
			local targetCf = tbl6[posName]
			if targetCf then
				if _G.tp then
					_G.tp(targetCf)
				elseif _G.tpSpecial then
					_G.tpSpecial(targetCf)
				end
			end
		end,
	})
end

PoliceTab:AddParagraph("Radar Positions:", "Select a location to teleport your vehicle. Downtown Bank and Police Station Loop are the best Locations.")

GunModTab:AddToggle({Name = "Fast Bullet", Default = false, Save = true, Flag = "GunFastBullet", Callback = function(Value)
    Night.GunMods.running = Value
    if Value then
        task.spawn(function()
            while Night.GunMods.running do
                local Tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
                if Tool then
                    Tool:SetAttribute("ShootDelay", 0)
                    Tool:SetAttribute("Automatic", true)
                end
                task.wait(0.1)
            end
        end)
    end
end})
GunModTab:AddToggle({Name = "Auto Reload", Default = false, Save = true, Flag = "GunAutoReload", Callback = function(state)
    task.spawn(function()
        while state do
            pcall(function()
                local character = LocalPlayer.Character
                if character then
                    for _, weaponName in ipairs(Night.GunMods.trackedWeapons) do
                        local weapon = character:FindFirstChild(weaponName) or Workspace:FindFirstChild(weaponName)
                        if weapon then
                            local magSize = weapon:GetAttribute("MagCurrentSize") or weapon:GetAttribute("Ammo") or weapon:GetAttribute("Clip") or (weapon:FindFirstChild("Ammo") and weapon.Ammo.Value)
                            if magSize and magSize == 0 then
                                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.R, false, game)
                                task.wait(0.1)
                                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.R, false, game)
                                task.wait(1)
                            end
                        end
                    end
                end
            end)
            task.wait(0.5)
        end
    end)
end})
GunModTab:AddToggle({Name = "No Recoil", Default = false, Save = true, Flag = "GunNoRecoil", Callback = function(enabled)
    if enabled then
        if Night.GunMods.recoilConnection then Night.GunMods.recoilConnection:Disconnect() end
        Night.GunMods.recoilConnection = RunService.Heartbeat:Connect(function()
            local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
            if tool then
                tool:SetAttribute("Recoil", 0)
                tool:SetAttribute("Instability", 0)
            end
        end)
    else
        if Night.GunMods.recoilConnection then
            Night.GunMods.recoilConnection:Disconnect()
            Night.GunMods.recoilConnection = nil
        end
    end
end})
GunModTab:AddDropdown({Name = "Shoot Sound", Default = "Default", Save = true, Flag = "GunShootSound", Options = Night.GunMods.soundOptions, Callback = function(v) Night.GunMods:changeSoundsGun(v) end})
GunModTab:AddSlider({Name = "Crosshair Size", Min = 0, Max = 25, Default = 25, Save = true, Flag = "GunCrosshairSize", Color = Color3.fromRGB(255, 255, 255), Increment = 1, ValueName = " ", Callback = function(Value)
    Night.GunMods.CrosshairSize = Value
    local plr = LocalPlayer
    if plr and plr.Character then
        for _, tool in pairs(plr.Character:GetChildren()) do
            if tool:IsA("Tool") then
                Night.GunMods:updateCrosshair(tool)
            end
        end
    end
end})
Night.GunMods:setupToolListeners()
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    Night.GunMods:setupToolListeners()
end)
GunModTab:AddSlider({Name = "Aim FOV", Min = 30, Max = 120, Color = Color3.fromRGB(255, 255, 255), Default = 40, Increment = 1, Save = false, Flag = "GunAimFOV", Callback = function(value)
    Night.GunMods.aimFovValue = value
end})
if Night.GunMods.aimFovConnection then Night.GunMods.aimFovConnection:Disconnect() end
Night.GunMods.aimFovConnection = RunService.Heartbeat:Connect(function()
    local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
    if tool then
        tool:SetAttribute("AimFieldOfView", Night.GunMods.aimFovValue)
    end
end)

GunModTab:AddSection({ Name = "Customize weapon color" })
GunModTab:AddToggle({ Name = "Weapon Color", Default = false, Save = true, Flag = "WeaponColors11", Callback = function(v) Night.WeaponColor1:toggle(v) end })
GunModTab:AddColorpicker({ Name = "Weapons Color Picker", Default = Night.WeaponColor1.ghostColor, Save = true, Flag = "WeaponsColorPicker11", Callback = function(v)
    Night.WeaponColor1.ghostColor = v
    if Night.WeaponColor1.enabled and not Night.WeaponColor1.rainbowEnabled then
        Night.WeaponColor1:checkAndApply(v)
    end
end})
GunModTab:AddToggle({ Name = "Rainbow Mode", Default = false, Save = true, Flag = "WeaponColorRainbowMode11", Callback = function(v)
    Night.WeaponColor1.rainbowEnabled = v
    if Night.WeaponColor1.enabled then
        if v then Night.WeaponColor1:startRainbow() else Night.WeaponColor1:stopRainbow(); Night.WeaponColor1:startContinuousCheck(); Night.WeaponColor1:checkAndApply(Night.WeaponColor1.ghostColor) end
    end
end})
LocalPlayer.CharacterAdded:Connect(function(character) Night.WeaponColor1:onCharacterAdded(character) end)
if LocalPlayer.Character then Night.WeaponColor1:onCharacterAdded(LocalPlayer.Character) end

GunModTab:AddSection({ Name = "Customize secondary weapon color" })
GunModTab:AddToggle({ Name = "Secondary Color", Default = false, Save = true, Flag = "WeaponColors2", Callback = function(v) Night.WeaponColor2:toggle(v) end })
GunModTab:AddColorpicker({ Name = "Secondary Color Picker", Default = Night.WeaponColor2.ghostColor, Save = true, Flag = "WeaponsColorPicker2", Callback = function(v)
    Night.WeaponColor2.ghostColor = v
    if Night.WeaponColor2.enabled and not Night.WeaponColor2.rainbowEnabled then
        Night.WeaponColor2:checkAndApply(v)
    end
end})
GunModTab:AddToggle({ Name = "Rainbow Mode", Default = false, Save = true, Flag = "WeaponColorRainbowMode2", Callback = function(v)
    Night.WeaponColor2.rainbowEnabled = v
    if Night.WeaponColor2.enabled then
        if v then Night.WeaponColor2:startRainbow() else Night.WeaponColor2:stopRainbow(); Night.WeaponColor2:startContinuousCheck(); Night.WeaponColor2:checkAndApply(Night.WeaponColor2.ghostColor) end
    end
end})
LocalPlayer.CharacterAdded:Connect(function(character) Night.WeaponColor2:onCharacterAdded(character) end)
if LocalPlayer.Character then Night.WeaponColor2:onCharacterAdded(LocalPlayer.Character) end

GunModTab:AddSection({ Name = "Sniper Settings" })
local noScopeConn = nil
GunModTab:AddToggle({
    Title = "OG Sniper",
    Desc = "Use sniper without scope",
    Default = false,
    Save = true,
    Flag = "OGSniper",
    Callback = function(state)
        if state then
            if noScopeConn then return end
            noScopeConn = RunService.Heartbeat:Connect(function()
                local char = LocalPlayer.Character
                if not char then return end
                local tool = char:FindFirstChild("Sniper")
                if tool then
                    tool:SetAttribute("Scope", false)
                end
            end)
        else
            if noScopeConn then
                noScopeConn:Disconnect()
                noScopeConn = nil
            end
        end
    end
})


local tbl7

tbl7 = {
	player = game.Players.LocalPlayer,
	runService = game:GetService("RunService"),
	TweenService = game:GetService("TweenService"),
	Players = game:GetService("Players"),
	UserInputService = game:GetService("UserInputService"),
	humanoid = nil,
	character = nil,
	toggleEnabled = false,
	stepSize = 0.3,
	flySpeed = 50,
	isFlying = false,
	flyAttach = nil,
	flyAlign = nil,
	flyOrient = nil,
	flingActive = false,
	AntiTaserEnabled = false,
	predFactor = 0.22,
	maxDist = 20,
	Clip = true,
	Noclipping = nil,
	spinBot = false,
	spinSpeed = 3e13,
	isToggled = false,
	isToggled2 = false,
	savedAtmosphere = nil,
	originalLighting = {},
	animator = nil,
	animation = nil,
	animationTrack = nil,
	animator2 = nil,
	animation2 = nil,
	animationTrack2 = nil,
	bypassActive = false,
	repelActive = false,
	boostAmount = 0,
	ogSniperEnabled = false,
	ogSniperThread = nil,
}

local function fn4(character)
	tbl7.character = character
	tbl7.humanoid = character:WaitForChild("Humanoid")
end

if tbl7.player.Character then
	fn4(tbl7.player.Character)
end

tbl7.player.CharacterAdded:Connect(fn4)
MiscTab:AddSection({ Name = "Config System (Einstellungen)" })
MiscTab:AddButton({
	Name = "Save Config (Speichern)",
	Callback = function()
		Night.ConfigManager:Save(false)
	end
})
MiscTab:AddButton({
	Name = "Load Config (Laden)",
	Callback = function()
		Night.ConfigManager:Load(false)
	end
})
MiscTab:AddToggle({
	Name = "Auto-Save Settings",
	Default = true,
	Save = false,
	Flag = "ConfigAutoSaveToggle",
	Callback = function(v)
		Night.ConfigManager.AutoSave = v
	end
})
MiscTab:AddButton({
	Name = "Reset Config to Defaults",
	Callback = function()
		pcall(function()
			if delfile and isfile and isfile(Night.ConfigManager.ConfigFile) then
				delfile(Night.ConfigManager.ConfigFile)
			end
		end)
		OrionLib:MakeNotification({
			Name = "Config Reset",
			Content = "Config geloescht. Starte das Skript neu fuer Standardwerte.",
			Time = 4
		})
	end
})

MiscTab:AddSection({ Name = "SpeedHack" })

MiscTab:AddToggle({
	Name = "SpeedHack",
	Default = false,
	Save = true,
	Flag = "SpeedHackEnabled",
	Callback = function(toggleEnabled)
		tbl7.toggleEnabled = toggleEnabled
	end,
})

MiscTab:AddBind({
	Name = "SpeedBind",
	Default = Enum.KeyCode.T,
	Hold = false,
	Save = true,
	Flag = "SpeedHackKeybind",
	Callback = function()
		tbl7.toggleEnabled = not tbl7.toggleEnabled
	end,
})

MiscTab:AddSlider({
	Name = "SpeedHack Speed",
	Min = 0.1,
	Max = 0.4,
	Default = 0.4,
	Increment = 0.1,
	ValueName = "Speed",
	Color = Color3.fromRGB(246, 221, 77),
	Save = true,
	Flag = "SpeedHackSpeed",
	Callback = function(stepSize)
		tbl7.stepSize = stepSize
	end,
})

tbl7.runService.Heartbeat:Connect(function()
	if tbl7.toggleEnabled and tbl7.humanoid and tbl7.character and tbl7.character.PrimaryPart then
		local moveDirection = tbl7.humanoid.MoveDirection

		if moveDirection.Magnitude > 0 then
			tbl7.character:SetPrimaryPartCFrame(tbl7.character.PrimaryPart.CFrame + moveDirection * tbl7.stepSize)
		end
	end
end)

MiscTab:AddSection({ Name = "Admin Fly" })

do
	local function fn5()
		if not (tbl7.player.Character and tbl7.player.Character:FindFirstChild("Humanoid") and tbl7.player.Character:FindFirstChild("Humanoid").SeatPart == nil) then
			return false
		end
		local humanoidRootPart = tbl7.player.Character:FindFirstChild("HumanoidRootPart")
		local humanoid = tbl7.player.Character:FindFirstChild("Humanoid")

		if tbl7.flyAttach then
			tbl7.flyAttach:Destroy()
		end

		if tbl7.flyAlign then
			tbl7.flyAlign:Destroy()
		end

		if tbl7.flyOrient then
			tbl7.flyOrient:Destroy()
		end

		tbl7.flyAttach = Instance.new("Attachment")
		tbl7.flyAttach.Parent = humanoidRootPart
		tbl7.flyAlign = Instance.new("AlignPosition")
		tbl7.flyAlign.Attachment0 = tbl7.flyAttach
		tbl7.flyAlign.Mode = Enum.PositionAlignmentMode.OneAttachment
		tbl7.flyAlign.MaxForce = 5000
		tbl7.flyAlign.Responsiveness = 45
		tbl7.flyAlign.Parent = humanoidRootPart
		tbl7.flyOrient = Instance.new("AlignOrientation")
		tbl7.flyOrient.Attachment0 = tbl7.flyAttach
		tbl7.flyOrient.Mode = Enum.OrientationAlignmentMode.OneAttachment
		tbl7.flyOrient.MaxTorque = 5000
		tbl7.flyOrient.Responsiveness = 45
		tbl7.flyOrient.Parent = humanoidRootPart
		humanoid.PlatformStand = true
		tbl7.isFlying = true
		local position = humanoidRootPart.Position
		tbl7.flyAlign.Position = position

		spawn(function()
			while tbl7.isFlying and tbl7.player.Character and humanoidRootPart and humanoid do
				local vector = Vector3.new()
				local cFrame = workspace.CurrentCamera.CFrame
				local UserInputService2 = game:GetService("UserInputService")

				if UserInputService2:IsKeyDown(Enum.KeyCode.W) then
					vector += cFrame.LookVector
				end

				if UserInputService2:IsKeyDown(Enum.KeyCode.S) then
					vector -= cFrame.LookVector
				end

				if UserInputService2:IsKeyDown(Enum.KeyCode.A) then
					vector -= cFrame.RightVector
				end

				if UserInputService2:IsKeyDown(Enum.KeyCode.D) then
					vector += cFrame.RightVector
				end

				if vector.Magnitude > 0 then
					position += vector.Unit * tbl7.flySpeed * tbl7.runService.Heartbeat:Wait()
					tbl7.flyAlign.Position = position
				end

				local lookVector = cFrame.LookVector
				tbl7.flyOrient.CFrame = CFrame.new(Vector3.new(), lookVector)
				tbl7.runService.Heartbeat:Wait()
			end
		end)

		return true
	end

	local function fn6()
		tbl7.isFlying = false

		if tbl7.player.Character and tbl7.player.Character:FindFirstChild("Humanoid") then
			tbl7.player.Character:FindFirstChild("Humanoid").PlatformStand = false
		end

		if tbl7.flyAttach then
			tbl7.flyAttach:Destroy()
		end

		if tbl7.flyAlign then
			tbl7.flyAlign:Destroy()
		end

		if tbl7.flyOrient then
			tbl7.flyOrient:Destroy()
		end
	end

	local v12 = MiscTab:AddToggle({
		Name = "Player Fly ",
		Default = false,
		Save = false,
		Flag = "FlyToggle",
		Callback = function(arg1)
			if arg1 then
				if not fn5() then
					v12:Set(false)
				end
			else
				fn6()
			end
		end,
	})

	MiscTab:AddBind({
		Name = "Fly Bind",
		Default = Enum.KeyCode.J,
		Save = false,
		Flag = "FlyKeybind",
		Callback = function()
			if tbl7.isFlying then
				fn6()
				v12:Set(false)
			else
				v12:Set(fn5())
			end
		end,
	})

	MiscTab:AddSlider({
		Name = "Fly Speed",
		Min = 5,
		Max = 200,
		Default = 55,
		Color = Color3.fromRGB(246, 221, 77),
		Increment = 1,
		ValueName = "Speed",
		Save = true,
		Flag = "FlySpeed",
		Callback = function(flySpeed)
			tbl7.flySpeed = flySpeed
		end,
	})

	tbl7.player.CharacterAdded:Connect(function()
		if tbl7.isFlying then
			task.wait(1)

			if v12.Value then
				fn5()
			end
		end
	end)
end

MiscTab:AddSection({ Name = "Troll" })

MiscTab:AddToggle({
	Name = "Jerk Off",
	Default = false,
	Save = true,
	Flag = "JerkOffEnabled",
	Callback = function(arg1)
		if arg1 then
			if JerkOffActive then
				return
			end
			JerkOffActive = true
			local animation_ = Instance.new("Animation")
			animation_.AnimationId = "rbxassetid://698251653"
			local v12 = tbl7.player.Character.Humanoid:LoadAnimation(animation_)

			task.spawn(function()
				while JerkOffActive do
					v12:Play()
					v12:AdjustSpeed(1)
					v12.TimePosition = 0.5
					task.wait(0.1)

					while v12.TimePosition < 0.5 do
						task.wait(0.1)
					end

					v12:Stop()
				end
			end)
		else
			JerkOffActive = false

			if animation and animationTrack then
				animation:Destroy()
				animationTrack:Destroy()
				animation = nil
				animationTrack = nil
			end
		end
	end,
})

local flag2 = false

MiscTab:AddToggle({
	Name = "Punch Aura",
	Default = false,
	Save = true,
	Flag = "PunchAuraToggle",
	Callback = function(arg1)
		flag2 = arg1

		task.spawn(function()
			while flag2 do
				pcall(function()
					local character = localPlayer2.Character

					if character and character:FindFirstChild("HumanoidRootPart") and character:FindFirstChild("Humanoid") and character.Humanoid.Health > 0 then
						for _, player in pairs(Players:GetPlayers()) do
							if player ~= localPlayer2 and player.Character then
								local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
								local humanoid = player.Character:FindFirstChild("Humanoid")

								if humanoidRootPart and humanoid and humanoid.Health > 0 then
									if (character.HumanoidRootPart.Position - humanoidRootPart.Position).Magnitude <= 14 then
										Remotes.Punch:FireServer(player.Character)
									end
								end
							end
						end
					end
				end)

				task.wait(0.05)
			end
		end)
	end,
})

MiscTab:AddToggle({
	Name = "No Seat Cooldown",
	Default = false,
	Save = true,
	Flag = "NoSeatCooldown",
	Callback = function(arg1)
		if arg1 then
			for _, v12 in pairs(getgc(true)) do
				fn()

				if type(v12) == "function" and islclosure(v12) then
					local ok, result = pcall(debug.getconstants, v12)

					if ok then
						for _, v13 in pairs(result) do
							if v13 == "canSeat" then
								hookfunction(v12, function()
									return true
								end)

								break
							end
						end
					end
				end
			end
		end
	end,
})

MiscTab:AddSection({ Name = "Auto Collect & Camera Stretch" })

MiscTab:AddToggle({
	Name = "Auto Collect",
	Default = false,
	Save = true,
	Flag = "Autocollect",
	Callback = function(s34)
		if getgenv().AutoCollectLoop then
			getgenv().AutoCollectLoop = false
		end

		if not s34 then
			return
		end
		game:GetService("ReplicatedStorage")
		local Workspace = game:GetService("Workspace")
		local autoCollect = tbl2.AutoCollect
		local localPlayer3 = game:GetService("Players").LocalPlayer
		local humanoidRootPart = (localPlayer3.Character or localPlayer3.CharacterAdded:Wait()):WaitForChild("HumanoidRootPart")
		local tbl8 = {}
		local n = 30
		local tbl9 = {}

		for _, descendant in ipairs(Workspace:GetDescendants()) do
			if descendant:IsA("Folder") then
				local str = descendant.Name:lower()

				if str:find("robbery") or str:find("robberies") then
					table.insert(tbl9, descendant)
				end
			end
		end

		Workspace.DescendantAdded:Connect(function(descendant)
			if descendant:IsA("Folder") then
				local str = descendant.Name:lower()

				if str:find("robbery") or str:find("robberies") then
					table.insert(tbl9, descendant)
				end
			end
		end)

		local function fn5(tbl10)
			for _, descendant in ipairs(tbl10:GetDescendants()) do
				if descendant:IsA("MeshPart") and descendant.Transparency == 0 then
					if humanoidRootPart and not tbl8[descendant] and (descendant.Position - humanoidRootPart.Position).Magnitude <= n then
						tbl8[descendant] = true

						task.spawn(function()
							local tbl11

							if descendant.Parent and descendant.Parent.Name == "Money" then
								tbl11 = { descendant, tbl.MoneyCode, "start" }
							else
								tbl11 = { descendant, tbl.ItemCode, "start" }
							end

							autoCollect:FireServer(unpack(tbl11))
							task.wait(2.5)
							tbl11[3] = "stop"
							autoCollect:FireServer(unpack(tbl11))

							if descendant and descendant.Parent and descendant.Transparency == 0 then
								tbl8[descendant] = nil
							end
						end)
					end
				end
			end
		end

		local function fn6()
			local drops = Workspace:FindFirstChild("Drops")
			if not drops then
				return
			end

			for _, child in ipairs(drops:GetChildren()) do
				if child:IsA("MeshPart") and child.Transparency == 0 then
					if humanoidRootPart and not tbl8[child] and (child.Position - humanoidRootPart.Position).Magnitude <= n then
						tbl8[child] = true

						task.spawn(function()
							local tbl10 = { child, tbl.MoneyCode, "start" }
							autoCollect:FireServer(unpack(tbl10))
							task.wait(2.5)
							tbl10[3] = "stop"
							autoCollect:FireServer(unpack(tbl10))
							task.wait(0.5)
							local tbl11 = { child, tbl.ItemCode, "start" }
							autoCollect:FireServer(unpack(tbl11))
							task.wait(2.5)
							tbl11[3] = "stop"
							autoCollect:FireServer(unpack(tbl11))

							if child and child.Parent and child.Transparency == 0 then
								tbl8[child] = nil
							end
						end)
					end
				end
			end
		end

		Workspace:WaitForChild("Drops").ChildAdded:Connect(function(child)
			if child:IsA("MeshPart") then
				task.wait(0.1)

				if child.Transparency == 0 then
					fn6()
				end
			end
		end)

		getgenv().AutoCollectLoop = true

		task.spawn(function()
			while getgenv().AutoCollectLoop do
				for _, v12 in ipairs(tbl9) do
					if v12 and v12.Parent then
						fn5(v12)
					end
				end

				fn6()
				task.wait(0.5)
			end
		end)
	end,
})

do
	local currentCamera = workspace.CurrentCamera
	local fieldOfView = currentCamera.FieldOfView
	local n = 0
	currentCamera.FieldOfViewMode = Enum.FieldOfViewMode.Vertical

	RunService2.RenderStepped:Connect(function()
		if n <= 0 then
			return
		end
		local viewportSize = currentCamera.ViewportSize
		currentCamera.FieldOfView = fieldOfView + n * viewportSize.X / viewportSize.Y * 0.4
	end)

	MiscTab:AddSlider({
		Name = "Camera Stretch Value",
		Min = 0,
		Max = 80,
		Default = 0,
		Color = Color3.fromRGB(246, 221, 77),
		Increment = 1,
		ValueName = "Stretch",
		Save = true,
		Flag = "CameraStretch",
		Callback = function(n2)
			n = n2

			if n2 == 0 then
				currentCamera.FieldOfView = fieldOfView
			end
		end,
	})
end

MiscTab:AddSection({ Name = "Self Revive" })

do
	local str = ""

	local function fn5(n)
		if (n - Vector3.new(-89.7, 5.88, 1055.77)).Magnitude <= (n - Vector3.new(-517.5608, 5.0985003, 3054.8806)).Magnitude then
			return {
				carTarget = CFrame.new(Vector3.new(-89.7, 5.88, 1055.77)),
				walkTarget = Vector3.new(-107.427, 7.648, 1073.643),
				getSeat = function()
					local buildings = workspace:WaitForChild("Buildings", 10)
					if not buildings then
						return nil
					end
					local hospital = buildings:WaitForChild("Hospital", 10)
					if not hospital then
						return nil
					end
					local hospitalBed = hospital:WaitForChild("HospitalBed", 10)
					if not hospitalBed then
						return nil
					end
					return hospitalBed:WaitForChild("Seat", 10)
				end,
			}
		end

		return {
			carTarget = CFrame.new(Vector3.new(-517.5608, 5.0985003, 3054.8806)),
			walkTarget = Vector3.new(-517.5608, 5.0985003, 3054.8806),
			getSeat = function()
				local buildings = workspace:WaitForChild("Buildings", 10)
				if not buildings then
					return nil
				end
				local v12 = nil

				for _, child in pairs(buildings:GetChildren()) do
					if child.Name == "Prison" then
						if v12 == nil or #child:GetDescendants() > #v12:GetDescendants() then
							v12 = child
						end
					end
				end

				if not v12 then
					return nil
				end
				local inmates = v12:WaitForChild("Inmates", 10)
				if not inmates then
					return nil
				end
				local cells = inmates:WaitForChild("Cells", 10)
				if not cells then
					return nil
				end

				for _, child in pairs(cells:GetChildren()) do
					local bed = child:FindFirstChild("Bed")

					if bed then
						local seat = bed:FindFirstChild("Seat")
						if seat then
							return seat
						end
					end
				end

				return nil
			end,
		}
	end

	MiscTab:AddDropdown({
		Name = "Self Revive",
		Default = "",
		Save = false,
		Flag = "AutoSelfReviveDropwDown",
		Options = {
			"Revive & Return",
			"Fully Revive & Return",
			"Revive & Dont Return",
			"Fully Revive & Dont Return",
		},
		Callback = function(n)
			if not n or n == "" or n == "..." then
				return
			end
			str = n
			local VirtualInputManager = game:GetService("VirtualInputManager")

			local function fn6()
				local localPlayer3 = game.Players.LocalPlayer

				if localPlayer3 and localPlayer3.Character then
					local humanoid = localPlayer3.Character:FindFirstChildOfClass("Humanoid")
					if humanoid then
						return humanoid.Health <= 25
					end
				end

				return false
			end

			local function fn7(arg1, arg2)
				OrionLib:MakeNotification({ Name = arg1, Content = arg2, Image = "rbxassetid://17181103870", Time = 5 })
			end

			local function fn8()
				local localPlayer3 = game.Players.LocalPlayer

				if localPlayer3 and localPlayer3.Character then
					local v12 = workspace.Vehicles:FindFirstChild(localPlayer3.Name)

					if v12 and localPlayer3.Character:FindFirstChild("Humanoid") then
						local humanoid = localPlayer3.Character:FindFirstChild("Humanoid")

						if humanoid and not humanoid.SeatPart then
							local driveSeat = v12:FindFirstChild("DriveSeat")

							if driveSeat then
								driveSeat:Sit(humanoid)
							end
						end
					end
				end
			end

			local function fn9(tbl8)
				local localPlayer3 = game.Players.LocalPlayer
				local character = localPlayer3.Character or localPlayer3.CharacterAdded:Wait()
				character:MoveTo(tbl8.walkTarget)
				wait(1)
				local v12 = tbl8.getSeat()
				if not v12 then
					return
				end
				character:MoveTo(v12.Position + Vector3.new(0, 2, 0))
				wait(0.7)
				local humanoid = character:FindFirstChildOfClass("Humanoid")

				if humanoid then
					v12:Sit(humanoid)
				end
			end

			local function fn10()
				VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
				wait(0.1)
				VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
				wait(0.2)
			end

			local localPlayer3 = game.Players.LocalPlayer

			if fn6() then
				local cFrame = localPlayer3.Character and localPlayer3.Character.PrimaryPart and localPlayer3.Character.PrimaryPart.CFrame or nil
				local v12 = fn5(localPlayer3.Character.PrimaryPart.Position)
				if not _G.tpSpecial then
					return
				end

				_G.tpSpecial(v12.carTarget, function()
					wait(1)
					localPlayer3.Character:MoveTo(v12.walkTarget)
					wait(0.5)
					fn9(v12)

					task.spawn(function()
						local humanoid = localPlayer3.Character:FindFirstChildOfClass("Humanoid")
						local flag3 = n == "Fully Revive & Return" or n == "Fully Revive & Dont Return"
						local state = 27

						if flag3 then
							state = 99
						end

						while true do
							humanoid = humanoid and humanoid.Health <= state

							if humanoid then
								wait(1)
								humanoid = localPlayer3.Character:FindFirstChildOfClass("Humanoid")
								continue
							end

							break
						end

						fn10()
						wait(0.5)

						if n == "Revive & Return" or n == "Fully Revive & Return" then
							fn8()
							fn8()
							wait(0.5)

							if cFrame and _G.tpSpecial then
								_G.tpSpecial(cFrame)
							end
						end
					end)
				end)
			else
				fn7("You are not dead", "Night System")
			end
		end,
	})

	local flag3 = false

	MiscTab:AddToggle({
		Name = "Auto Self Revive",
		Default = false,
		Save = false,
		Flag = "AutoSelfRevive",
		Callback = function(s35)
			flag3 = s35

			if s35 then
				task.spawn(function()
					while flag3 do
						wait(1)
						local VirtualInputManager = game:GetService("VirtualInputManager")

						local function fn6()
							local localPlayer3 = game.Players.LocalPlayer

							if localPlayer3 and localPlayer3.Character then
								local humanoid = localPlayer3.Character:FindFirstChildOfClass("Humanoid")
								if humanoid then
									return humanoid.Health <= 24
								end
							end

							return false
						end

						local function fn7()
							local localPlayer3 = game.Players.LocalPlayer

							if localPlayer3 and localPlayer3.Character then
								local v12 = workspace.Vehicles:FindFirstChild(localPlayer3.Name)

								if v12 and localPlayer3.Character:FindFirstChild("Humanoid") then
									local humanoid = localPlayer3.Character:FindFirstChild("Humanoid")

									if humanoid and not humanoid.SeatPart then
										local driveSeat = v12:FindFirstChild("DriveSeat")

										if driveSeat then
											driveSeat:Sit(humanoid)
										end
									end
								end
							end
						end

						local function fn8(tbl8)
							local localPlayer3 = game.Players.LocalPlayer
							local character = localPlayer3.Character or localPlayer3.CharacterAdded:Wait()
							character:MoveTo(tbl8.walkTarget)
							wait(1)
							local v12 = tbl8.getSeat()
							if not v12 then
								return
							end
							character:MoveTo(v12.Position + Vector3.new(0, 2, 0))
							wait(0.7)
							local humanoid = character:FindFirstChildOfClass("Humanoid")

							if humanoid then
								v12:Sit(humanoid)
							end
						end

						local function fn9()
							VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
							wait(0.1)
							VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
							wait(0.2)
						end

						if fn6() then
							local localPlayer3 = game.Players.LocalPlayer
							local cFrame = localPlayer3.Character and localPlayer3.Character.PrimaryPart and localPlayer3.Character.PrimaryPart.CFrame or nil
							local v12 = fn5(localPlayer3.Character.PrimaryPart.Position)

							if _G.tpSpecial then
								_G.tpSpecial(v12.carTarget, function()
									wait(1)
									localPlayer3.Character:MoveTo(v12.walkTarget)
									wait(0.5)
									fn8(v12)

									task.spawn(function()
										local humanoid = localPlayer3.Character:FindFirstChildOfClass("Humanoid")
										local str2 = str == "" and "Fully Revive & Return" or str
										local flag4 = str2 == "Fully Revive & Return" or str2 == "Fully Revive & Dont Return"
										local state = 27

										if flag4 then
											state = 99
										end

										while true do
											humanoid = humanoid and humanoid.Health <= state

											if humanoid then
												wait(1)
												humanoid = localPlayer3.Character:FindFirstChildOfClass("Humanoid")
												continue
											end

											break
										end

										local humanoid2 = localPlayer3.Character and localPlayer3.Character:FindFirstChildOfClass("Humanoid")
										if not humanoid2 then
											return
										end
										local n = 0

										while humanoid2 and not humanoid2.SeatPart and n < 5 do
											wait(0.3)
											n += 0.3
											humanoid2 = localPlayer3.Character and localPlayer3.Character:FindFirstChildOfClass("Humanoid")
										end

										if not humanoid2 or not humanoid2.SeatPart then
											return
										end
										fn9()
										local character = localPlayer3.Character
										local n2 = 0
										character = character and localPlayer3.Character:FindFirstChildOfClass("Humanoid")

										while true do
											character = character and character.SeatPart and n2 < 5

											if character then
												wait(0.2)
												n2 += 0.2
												character = localPlayer3.Character and localPlayer3.Character:FindFirstChildOfClass("Humanoid")
												continue
											end

											break
										end

										wait(0.5)

										if str2 == "Revive & Return" or str2 == "Fully Revive & Return" then
											fn7()
											wait(0.3)
											local humanoid3 = localPlayer3.Character and localPlayer3.Character:FindFirstChildOfClass("Humanoid")

											if not (humanoid3 and humanoid3.SeatPart and humanoid3.SeatPart.Name == "DriveSeat") then
												fn7()
												wait(0.5)
											end

											if cFrame and _G.tpSpecial then
												_G.tpSpecial(cFrame)
											end
										end
									end)
								end)
							end

							wait(30)
						end
					end
				end)
			end
		end,
	})
end

MiscTab:AddSection({ Name = "Safety" })

MiscTab:AddToggle({
	Name = "Anti Taser",
	Default = false,
	Save = true,
	Flag = "AntiTaser",
	Callback = function(antiTaserEnabled)
		tbl7.AntiTaserEnabled = antiTaserEnabled
	end,
})

tbl7.runService.Heartbeat:Connect(function()
	if tbl7.AntiTaserEnabled and tbl7.player.Character then
		tbl7.player.Character:SetAttribute("Tased", false)
	end
end)

do
	local humanoidRootPart = (tbl7.player.Character or tbl7.player.CharacterAdded:Wait()):WaitForChild("HumanoidRootPart")

	MiscTab:AddToggle({
		Name = "Anti Arrest",
		Default = false,
		Save = true,
		Flag = "AntiArrest",
		Callback = function(repelActive)
			tbl7.repelActive = repelActive
		end,
	})

	local n = 0

	local function fn5(tbl8)
		return tbl8 ~= tbl7.player and tbl8.TeamColor == BrickColor.new("Bright blue") and tbl8.Character
	end

	local function fn6()
		local now = tick()
		if now - n < 0.2 then
			return {}
		end
		n = now
		local tbl8 = {}

		for _, player in pairs(tbl7.Players:GetPlayers()) do
			if fn5(player) then
				local humanoidRootPart2 = player.Character and player.Character:FindFirstChild("HumanoidRootPart")

				if humanoidRootPart2 then
					local magnitude = (humanoidRootPart.Position - humanoidRootPart2.Position).Magnitude

					if magnitude < 35 then
						table.insert(tbl8, { rootPart = humanoidRootPart2, distance = magnitude })
					end
				end
			end
		end

		return tbl8
	end

	local function fn7(tbl8)
		local n2 = humanoidRootPart.Position + (humanoidRootPart.Position - tbl8.rootPart.Position).Unit * (35 - tbl8.distance)
		tbl7.TweenService:Create(humanoidRootPart, TweenInfo.new(0.3, Enum.EasingStyle.Linear), { CFrame = CFrame.new(n2) }):Play()
	end

	tbl7.player.CharacterAdded:Connect(function()
		task.wait(0.1)
		humanoidRootPart = tbl7.player.Character:WaitForChild("HumanoidRootPart")
	end)

	tbl7.runService.Heartbeat:Connect(function()
		if not tbl7.repelActive or not humanoidRootPart then
			return
		end
		local v12 = fn6()

		if #v12 > 0 then
			table.sort(v12, function(tbl8, tbl9)
				return tbl8.distance < tbl9.distance
			end)

			fn7(v12[1])
		end
	end)
end

do
	local Lighting = game:GetService("Lighting")
	local blurEffect = Lighting:FindFirstChild("BlurEffect") or Lighting:FindFirstChildOfClass("BlurEffect")

	MiscTab:AddToggle({
		Name = "Anti Flashbang",
		Default = false,
		Save = true,
		Flag = "AntiFlashbang",
		Callback = function(arg1)
			if arg1 then
				if blurEffect then
					blurEffect.Parent = workspace
				else
					blurEffect = Lighting:FindFirstChild("BlurEffect") or Lighting:FindFirstChildOfClass("BlurEffect")

					if blurEffect then
						blurEffect.Parent = workspace
					end
				end
			elseif blurEffect then
				blurEffect.Parent = Lighting
			end
		end,
	})
end

local v15 = MiscTab:AddToggle({
	Name = "Anti Fall",
	Default = false,
	Save = true,
	Flag = "AntiFall",
	Callback = function(arg1)
		if arg1 then
			local renderStepped = tbl7.runService.RenderStepped

			getfenv().nofall = renderStepped:Connect(function()
				local humanoidRootPart = tbl7.player.Character and tbl7.player.Character:FindFirstChild("HumanoidRootPart")

				if humanoidRootPart and humanoidRootPart.Velocity.Y < -30 then
					if workspace:Raycast(humanoidRootPart.Position, Vector3.new(0, -20, 0)) then
						humanoidRootPart.Velocity = Vector3.zero
					end
				end
			end)
		elseif getfenv().nofall then
			getfenv().nofall:Disconnect()
			getfenv().nofall = nil
		end
	end,
})

_G.IsAntiFallActive = function()
	return getfenv().nofall ~= nil
end

_G.SetAntiFall = function(s20)
	if s20 and not getfenv().nofall then
		v15:Set(true)
	elseif not s20 and getfenv().nofall then
		v15:Set(false)
	end
end

local connection2 = nil

MiscTab:AddToggle({
	Name = "Anti Downed",
	Default = false,
	Save = false,
	Flag = "AntiDowned",
	Callback = function(arg1)
		if arg1 then
			local humanoid = tbl7.player.Character:WaitForChild("Humanoid")

			connection2 = humanoid:GetPropertyChangedSignal("Health"):Connect(function()
				humanoid.Health = 100
			end)
		elseif connection2 then
			connection2:Disconnect()
			connection2 = nil
		end
	end,
})

do
	local vehicles = workspace:WaitForChild("Vehicles")
	local n = 0
	local n2 = 0
	local n3 = 70
	local n4 = 0.1
	local n5 = 6
	local connection3 = nil

	local function findFirstChild()
		return vehicles:FindFirstChild(tbl7.player.Name)
	end

	local function fn5(tbl8, n6)
		if not (tbl8 and tbl8.PrimaryPart) then
			return
		end
		local lookVector = tbl8.PrimaryPart.CFrame.LookVector
		local unit = Vector3.new(lookVector.X, 0, lookVector.Z).Unit
		tbl8:SetPrimaryPartCFrame(CFrame.new(tbl8.PrimaryPart.Position + unit * n6, tbl8.PrimaryPart.Position + unit * n6 + unit))
	end

	local function fn6()
		local tbl8 = {}
		local speedCameras = workspace:FindFirstChild("SpeedCameras")
		if not speedCameras then
			return tbl8
		end

		for _, v12 in pairs({ "Mobile", "Stationary" }) do
			local v13 = speedCameras:FindFirstChild(v12)

			if v13 then
				for _, descendant in pairs(v13:GetDescendants()) do
					if descendant:IsA("Model") and (descendant.Name == "MobileSpeedCamera" or descendant.Name == "SpeedCamera") then
						local primaryPart = descendant.PrimaryPart or descendant:FindFirstChildOfClass("Part")

						if primaryPart then
							descendant.PrimaryPart = primaryPart
							table.insert(tbl8, descendant)
						end
					end
				end
			end
		end

		return tbl8
	end

	local function fn7()
		local v12 = findFirstChild()
		local now = tick()
		if not (v12 and v12.PrimaryPart) or now - n < n5 then
			return
		end

		for _, v13 in pairs(fn6()) do
			if v13.PrimaryPart and (v12.PrimaryPart.Position - v13.PrimaryPart.Position).Magnitude < n3 then
				fn5(v12, 160)
				n = now
				break
			end
		end
	end

	MiscTab:AddToggle({
		Name = "Anti Speed Camera",
		Default = false,
		Save = true,
		Flag = "AntiSpeedCamera",
		Callback = function(arg1)
			if arg1 then
				connection3 = tbl7.runService.Heartbeat:Connect(function()
					local now = tick()

					if now - n2 >= n4 then
						n2 = now
						fn7()
					end
				end)
			elseif connection3 then
				connection3:Disconnect()
				connection3 = nil
			end
		end,
	})

	game.Players.PlayerRemoving:Connect(function(player)
		if player == tbl7.player and connection3 then
			connection3:Disconnect()
		end
	end)
end

MiscTab:AddSection({ Name = "Movement" })

MiscTab:AddToggle({
	Name = "Anti Ragdoll",
	Default = false,
	Save = true,
	Flag = "AntiRagdollToggle",
	Callback = function(arg1)
		if arg1 then
			pcall(function()
				local controllers = localPlayer2.PlayerScripts.Code.controllers
				local ragdollController = require(controllers.ragdollController)
				local vehicleRagdollController = require(controllers.vehicleRagdollController)

				if ragdollController and ragdollController.RagdollController then
					ragdollController.RagdollController.onTick = function(tbl8)
						local character = localPlayer2.Character

						if character then
							local humanoid = character:FindFirstChildOfClass("Humanoid")

							if humanoid then
								if humanoid:GetAttribute("Tased") then
									humanoid:SetAttribute("Tased", false)
								end

								local physics = Enum.HumanoidStateType.Physics

								if humanoid:GetState() == physics then
									humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
								end

								humanoid.PlatformStand = false
							end
						end

						if tbl8.ragdollBindable and not tbl8.ragdollBindable.modified then
							tbl8.ragdollBindable.getValue = function()
								return false
							end

							local setBinding = tbl8.ragdollBindable.setBinding

							tbl8.ragdollBindable.setBinding = function(v12, v13, v14)
								if v13 == "Ragdoll" or v13 == "VehicleRagdoll" then
									v14 = false
								end

								return setBinding(v12, v13, v14)
							end

							tbl8.ragdollBindable.modified = true
						end

						if tbl8.inventoryController and tbl8.inventoryController.inventoryHideBindable then
							tbl8.inventoryController.inventoryHideBindable:setBinding("Ragdoll", false)
						end
					end
				end

				if vehicleRagdollController and vehicleRagdollController.VehicleRagdollController then
					vehicleRagdollController.VehicleRagdollController.onTick = function(tbl8)
						tbl8.lastVehicleRoof = 0

						if tbl8.ragdollController and tbl8.ragdollController.ragdollBindable then
							tbl8.ragdollController.ragdollBindable:setBinding("VehicleRagdoll", false)
						end
					end
				end
			end)
		end
	end,
})
;(localPlayer2.Character or localPlayer2.CharacterAdded:Wait()):WaitForChild("HumanoidRootPart")

MiscTab:AddToggle({
	Name = "INF Jump",
	Default = false,
	Save = true,
	Flag = "INFJump",
	Callback = function(infiniteJumpEnabled)
		getgenv().InfiniteJumpEnabled = infiniteJumpEnabled
	end,
})

MiscTab:AddToggle({
	Name = "Noclip",
	Default = false,
	Save = true,
	Flag = "Noclip",
	Callback = function(s26)
		tbl7.Clip = not s26

		if s26 then
			tbl7.Noclipping = tbl7.runService.Stepped:Connect(function()
				for _, descendant in pairs(tbl7.player.Character:GetDescendants()) do
					if descendant:IsA("BasePart") then
						descendant.CanCollide = false
					end
				end
			end)
		elseif tbl7.Noclipping then
			tbl7.Noclipping:Disconnect()
			tbl7.Noclipping = nil
		end
	end,
})

game:GetService("UserInputService").JumpRequest:Connect(function()
	if getgenv().InfiniteJumpEnabled then
		local character = tbl7.player.Character

		if character and character:FindFirstChildOfClass("Humanoid") then
			character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
		end
	end
end)

MiscTab:AddToggle({
	Name = "SpinBot",
	Default = false,
	Save = true,
	Flag = "SpinBot",
	Callback = function(spinBot)
		tbl7.spinBot = spinBot
	end,
})

tbl7.runService.RenderStepped:Connect(function()
	if tbl7.spinBot then
		local humanoidRootPart = tbl7.player.Character and tbl7.player.Character:FindFirstChild("HumanoidRootPart")

		if humanoidRootPart then
			humanoidRootPart.CFrame = humanoidRootPart.CFrame * CFrame.Angles(0, math.rad(tbl7.spinSpeed), 0)
		end
	end
end)

MiscTab:AddSlider({
	Name = "SpinBot Speed",
	Min = 1,
	Max = 50,
	Default = 30,
	Color = Color3.fromRGB(246, 221, 77),
	Increment = 1,
	ValueName = "Speed",
	Save = true,
	Flag = "SpinBotSpeed",
	Callback = function(n)
		tbl7.spinSpeed = n * 1e12
	end,
})

local tbl8 = {}

MiscTab:AddToggle({
	Name = "X-Ray",
	Default = false,
	Save = true,
	Flag = "XRayEnabled",
	Callback = function(arg1)
		if arg1 then
			for _, descendant in pairs(workspace:GetDescendants()) do
				if descendant:IsA("BasePart") and descendant.Parent ~= tbl7.player.Character then
					tbl8[descendant] = descendant.LocalTransparencyModifier
					descendant.LocalTransparencyModifier = 0.5
				end
			end
		else
			for k, v12 in pairs(tbl8) do
				if k and k.Parent then
					k.LocalTransparencyModifier = v12
				end
			end

			tbl8 = {}
		end
	end,
})

MiscTab:AddSection({ Name = "Server" })

do
	local flag3 = false
	local flag4 = false
	local n = 200

	local function fn5(n2)
		if n2 >= 250 then
			return "Developer"
		end

		if n2 >= 200 then
			return "Moderator"
		end
		return "Staff"
	end

	local function fn6()
		local modProtOverlay = game:GetService("CoreGui"):FindFirstChild("ModProtOverlay")

		if modProtOverlay then
			modProtOverlay:Destroy()
		end

		local screenGui2 = Instance.new("ScreenGui")
		screenGui2.Name = "ModProtOverlay"
		screenGui2.AutoLocalize = false
		screenGui2.ResetOnSpawn = false
		screenGui2.DisplayOrder = 9999
		screenGui2.IgnoreGuiInset = true
		screenGui2.Parent = game:GetService("CoreGui")
		local frame2 = Instance.new("Frame")
		frame2.Size = UDim2.new(1, 0, 1, 0)
		frame2.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
		frame2.BackgroundTransparency = 0
		frame2.BorderSizePixel = 0
		frame2.Parent = screenGui2
		local textLabel = Instance.new("TextLabel")
		textLabel.Size = UDim2.new(1, -40, 0, 100)
		textLabel.Position = UDim2.new(0, 20, 0.28, 0)
		textLabel.BackgroundTransparency = 1
		textLabel.Font = Enum.Font.GothamBold
		textLabel.TextSize = 58
		textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		textLabel.TextStrokeTransparency = 0.3
		textLabel.Text = "A MODERATOR IS IN YOUR SERVER"
		textLabel.Parent = frame2
		local textLabel2 = Instance.new("TextLabel")
		textLabel2.Name = "SubLabel"
		textLabel2.Size = UDim2.new(1, -40, 0, 50)
		textLabel2.Position = UDim2.new(0, 20, 0.28, 110)
		textLabel2.BackgroundTransparency = 1
		textLabel2.Font = Enum.Font.GothamBold
		textLabel2.TextSize = 28
		textLabel2.TextColor3 = Color3.fromRGB(255, 220, 220)
		textLabel2.TextStrokeTransparency = 0.5
		textLabel2.Text = ""
		textLabel2.Parent = frame2
		local textLabel3 = Instance.new("TextLabel")
		textLabel3.Size = UDim2.new(1, -40, 0, 35)
		textLabel3.Position = UDim2.new(0, 20, 0.28, 170)
		textLabel3.BackgroundTransparency = 1
		textLabel3.Font = Enum.Font.Gotham
		textLabel3.TextSize = 22
		textLabel3.TextColor3 = Color3.fromRGB(255, 210, 210)
		textLabel3.Text = "Hold SPACE for 2 seconds to stay — or auto-leave in 10s"
		textLabel3.Parent = frame2
		local textLabel4 = Instance.new("TextLabel")
		textLabel4.Name = "TimerLabel"
		textLabel4.Size = UDim2.new(1, 0, 0, 60)
		textLabel4.Position = UDim2.new(0, 0, 0.55, 0)
		textLabel4.BackgroundTransparency = 1
		textLabel4.Font = Enum.Font.GothamBold
		textLabel4.TextSize = 48
		textLabel4.TextColor3 = Color3.fromRGB(255, 255, 255)
		textLabel4.Text = "10"
		textLabel4.Parent = frame2
		local frame3 = Instance.new("Frame")
		frame3.Size = UDim2.new(0, 400, 0, 28)
		frame3.Position = UDim2.new(0.5, -200, 0.55, 70)
		frame3.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
		frame3.BorderSizePixel = 0
		frame3.Parent = frame2
		local uiCorner = Instance.new("UICorner")
		uiCorner.CornerRadius = UDim.new(0, 6)
		uiCorner.Parent = frame3
		local frame4 = Instance.new("Frame")
		frame4.Name = "HoldBarFill"
		frame4.Size = UDim2.new(0, 0, 1, 0)
		frame4.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		frame4.BorderSizePixel = 0
		frame4.Parent = frame3
		local uiCorner2 = Instance.new("UICorner")
		uiCorner2.CornerRadius = UDim.new(0, 6)
		uiCorner2.Parent = frame4
		local textLabel5 = Instance.new("TextLabel")
		textLabel5.Size = UDim2.new(1, 0, 1, 0)
		textLabel5.BackgroundTransparency = 1
		textLabel5.Font = Enum.Font.GothamBold
		textLabel5.TextSize = 14
		textLabel5.TextColor3 = Color3.fromRGB(255, 255, 255)
		textLabel5.TextStrokeTransparency = 0.3
		textLabel5.Text = "Hold SPACE to stay"
		textLabel5.Parent = frame3
		return screenGui2, textLabel2, textLabel4, frame4
	end

	local function fn7(s2, s3)
		if flag4 then
			return
		end
		flag4 = true
		local v12, v13, v14, v16 = fn6()
		v13.Text = string.format("Moderator: %s  |  Rank: %s", s2, s3)
		local now = nil
		local connection3 = nil
		local n2 = 2
		local UserInputService2 = game:GetService("UserInputService")

		local connection4 = UserInputService2.InputBegan:Connect(function(input, gameProcessed)
			if gameProcessed then
				return
			end

			if input.KeyCode == Enum.KeyCode.Space or input.UserInputType == Enum.UserInputType.Touch then
				now = tick()
			end
		end)

		local connection5 = UserInputService2.InputEnded:Connect(function(input, gameProcessed)
			if gameProcessed then
				return
			end

			if input.KeyCode == Enum.KeyCode.Space or input.UserInputType == Enum.UserInputType.Touch then
				now = nil
				v16.Size = UDim2.new(0, 0, 1, 0)
			end
		end)

		local n3 = tick() + 10

		connection3 = game:GetService("RunService").Heartbeat:Connect(function()
			local n4 = math.max(0, n3 - tick())
			v14.Text = string.format("%.1f", n4)

			if now then
				local n5 = math.min(tick() - now, 2)
				v16.Size = UDim2.new(n5 / n2, 0, 1, 0)

				if n5 >= n2 then
					connection4:Disconnect()
					connection5:Disconnect()
					connection3:Disconnect()
					v12:Destroy()
					flag4 = false
					return
				end
			end

			if n4 <= 0 then
				connection4:Disconnect()
				connection5:Disconnect()
				connection3:Disconnect()
				v12:Destroy()
				game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, game.Players.LocalPlayer)
			end
		end)
	end

	local function fn8(tbl9)
		local ok, result = pcall(function()
			return tbl9:GetRankInGroupAsync(12563021)
		end)

		if ok and result >= n then
			return true, result
		end
		return false, 0
	end

	local function fn9(tbl9)
		task.spawn(function()
			if not flag3 then
				return
			end
			local v12, v13 = fn8(tbl9)

			if v12 then
				fn7(tbl9.Name, fn5(v13))
			end
		end)
	end

	game:GetService("Players").PlayerAdded:Connect(function(player)
		if flag3 then
			fn9(player)
		end
	end)

	MiscTab:AddToggle({
		Name = "Moderator Protection",
		Default = false,
		Save = true,
		Flag = "ModeratorProtection",
		Callback = function(s27)
			flag3 = s27
			flag4 = false

			if s27 then
				local v12 = ipairs
				local Players2 = game:GetService("Players")

				for _, player in v12(Players2:GetPlayers()) do
					if player ~= game:GetService("Players").LocalPlayer then
						fn9(player)
					end
				end
			end
		end,
	})
end

local flag3 = false

MiscTab:AddToggle({
	Name = "Auto Rejoin on Kick",
	Default = false,
	Save = true,
	Flag = "AutoRejoinKick",
	Callback = function(arg1)
		flag3 = arg1
	end,
})

game:GetService("CoreGui").ChildRemoved:Connect(function(child)
	if flag3 and child.Name == "RobloxPromptGui" then
		wait(0.5)
		game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, game.Players.LocalPlayer)
	end
end)

game:GetService("GuiService").ErrorMessageChanged:Connect(function()
	if flag3 then
		wait(0.5)
		game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, game.Players.LocalPlayer)
	end
end)

MiscTab:AddButton({
	Name = "Rejoin",
	Callback = function()
		game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, game.Players.LocalPlayer)
	end,
})

MiscTab:AddSection({ Name = "Local Player" })

MiscTab:AddButton({
	Name = "Inf Stamina",
	Callback = function()
		if not getfenv().firsttime then
			getfenv().firsttime = true

			for _, v12 in pairs(getgc(true)) do
				fn()

				if type(v12) == "function" and getinfo(v12).name == "setStamina" then
					hookfunction(v12, function(arg1)
						return arg1, math.huge
					end)

					break
				end
			end
		end
	end,
})

MiscTab:AddButton({
	Name = "Reset Player",
	Callback = function()
		local humanoid = tbl7.player.Character and tbl7.player.Character:FindFirstChild("Humanoid")

		if humanoid then
			humanoid.Health = 0
		end
	end,
})

MiscTab:AddButton({
	Name = "Escape Car",
	Callback = function()
		local character = tbl7.player.Character
		if not character then
			return
		end
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		if not humanoid then
			return
		end

		if humanoid.SeatPart then
			humanoid.Sit = false
			task.wait(0.1)
			humanoid:ChangeState(Enum.HumanoidStateType.Jumping)

			task.spawn(function()
				task.wait(0.2)

				if humanoid.SeatPart then
					humanoid.Sit = false
					local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")

					if humanoidRootPart then
						humanoidRootPart.Velocity = humanoidRootPart.Velocity + Vector3.new(0, 50, 0)
					end
				end
			end)
		end
	end,
})

do
	local tbl9 = {}
	local flag4 = false

	local function fn5(tbl10)
		local str = tbl10:lower()
		return string.find(str, "sign") or string.find(str, "streetlamp") or string.find(str, "lamp")
	end

	local fn6 = nil

	fn6 = function(tbl10, tbl11, tbl12)
		for _, child in ipairs(tbl10:GetChildren()) do
			tbl12.n = tbl12.n + 1
			fn()

			if fn5(child.Name) then
				tbl11[#tbl11 + 1] = child
			else
				fn6(child, tbl11, tbl12)
			end
		end
	end

	MiscTab:AddToggle({
		Name = "Remove Signs",
		Default = false,
		Save = false,
		Flag = "RemoveSignsEnabled",
		Callback = function(s10)
			if flag4 then
				return
			end
			flag4 = true

			pcall(function()
				if s10 then
					for i = #tbl9, 1, -1 do
						local v12 = tbl9[i]

						if v12.obj and v12.obj.Parent == nil and v12.parent and v12.parent.Parent then
							pcall(function()
								v12.obj.Parent = v12.parent
							end)
						end
					end

					tbl9 = {}
					local tbl10 = {}
					fn6(workspace, tbl10, { n = 0 })

					for i = 1, #tbl10 do
						fn()
						local v12 = tbl10[i]

						if v12 and v12.Parent then
							tbl9[#tbl9 + 1] = { obj = v12, parent = v12.Parent }

							pcall(function()
								v12.Parent = nil
							end)
						end
					end
				else
					for i = #tbl9, 1, -1 do
						fn()
						local v12 = tbl9[i]

						if v12.obj and v12.parent and v12.parent.Parent then
							pcall(function()
								v12.obj.Parent = v12.parent
							end)
						end
					end

					tbl9 = {}
				end
			end)

			flag4 = false
		end,
	})
end

local Players2
Players2 = game:GetService("Players")
local localPlayer3
localPlayer3 = Players2.LocalPlayer or Players2.PlayerAdded:Wait()
local fn5

do
	local StarterGui = game:GetService("StarterGui")
	game:GetService("Lighting")
	tbl7 = tbl7 or {}
	tbl7.player = localPlayer3
	tbl7.originalLighting = {}

	local function fn6(tbl9)
		for _, child in ipairs(tbl9:GetChildren()) do
			if child:IsA("Accessory") or child:IsA("Hat") or child:IsA("Shirt") or child:IsA("Pants") or child:IsA("ShirtGraphic") or child:IsA("CharacterMesh") then
				child:Destroy()
			end
		end

		local head = tbl9:FindFirstChild("Head")

		if head then
			for _, child in ipairs(head:GetChildren()) do
				if child:IsA("Decal") and child.Name:lower() == "face" then
					child:Destroy()
				end
			end
		end

		local bodyColors = tbl9:FindFirstChildOfClass("BodyColors")

		if bodyColors then
			bodyColors:Destroy()
		end
	end

	local function fn7(tbl9, tbl10)
		local handle = tbl10:FindFirstChild("Handle")
		if not handle then
			return
		end
		local v12 = nil
		local v13 = nil

		for _, child in ipairs(tbl9:GetChildren()) do
			if child:IsA("BasePart") then
				for _, child2 in ipairs(child:GetChildren()) do
					if child2:IsA("Attachment") then
						local v14 = handle:FindFirstChild(child2.Name)

						if v14 and v14:IsA("Attachment") then
							v12 = child2
							v13 = v14
							break
						end
					end
				end
			end

			if not v12 then
				continue
			end
			break
		end

		if v12 and v13 then
			handle.CFrame = v12.WorldCFrame * v13.CFrame:Inverse()
		else
			local humanoidRootPart = tbl9:FindFirstChild("HumanoidRootPart")

			if humanoidRootPart then
				handle.CFrame = humanoidRootPart.CFrame
			end
		end

		local weldConstraint = Instance.new("WeldConstraint")
		weldConstraint.Part0 = handle
		weldConstraint.Part1 = v12 and v12.Parent or tbl9:FindFirstChild("HumanoidRootPart") or tbl9:FindFirstChild("Head")
		weldConstraint.Parent = handle
		tbl10.Parent = tbl9
	end

	local function fn8(s26)
		local character = localPlayer3.Character or localPlayer3.CharacterAdded:Wait()

		local ok, result = pcall(function()
			return Players2:GetCharacterAppearanceAsync(s26)
		end)

		if not ok or not result then
			return
		end
		fn6(character)
		local bodyColors = result:FindFirstChildOfClass("BodyColors")

		if bodyColors then
			bodyColors:Clone().Parent = character
		end

		for _, child in ipairs(result:GetChildren()) do
			if child:IsA("Shirt") or child:IsA("Pants") or child:IsA("ShirtGraphic") then
				child:Clone().Parent = character
			end
		end

		for _, child in ipairs(result:GetChildren()) do
			if child:IsA("Accessory") or child:IsA("Hat") then
				fn7(character, child:Clone())
			end
		end

		local head = character:FindFirstChild("Head")

		if head then
			local face = result:FindFirstChild("face", true)

			if face and face:IsA("Decal") then
				face:Clone().Parent = head
			end
		end
	end

	fn5 = function()
		local character = localPlayer3.Character

		if character then
			fn6(character)
			wait(0.1)
			fn8(localPlayer3.UserId)
		end
	end

	local function fn9(s18)
		local ok, result = pcall(function()
			return Players2:GetUserIdFromNameAsync(s18)
		end)

		if ok then
			return result
		end
		return nil
	end

	local function fn10()
		local tbl9 = {}

		for _, player in ipairs(Players2:GetPlayers()) do
			if player ~= localPlayer3 then
				table.insert(tbl9, player.Name)
			end
		end

		return tbl9
	end

	local humanoid = (tbl7.player.Character or tbl7.player.CharacterAdded:Wait()):WaitForChild("Humanoid")
	tbl7.animator = humanoid:WaitForChild("Animator") or Instance.new("Animator", humanoid)
	tbl7.anim = Instance.new("Animation")
	tbl7.anim.AnimationId = "rbxassetid://9357137817"
	tbl7.animTrack = tbl7.animator:LoadAnimation(tbl7.anim)
	local humanoid2 = (tbl7.player.Character or tbl7.player.CharacterAdded:Wait()):WaitForChild("Humanoid")
	tbl7.animator2 = humanoid2:WaitForChild("Animator") or Instance.new("Animator", humanoid2)
	tbl7.anim2 = Instance.new("Animation")
	tbl7.anim2.AnimationId = "rbxassetid://11019608524"
	tbl7.animTrack2 = tbl7.animator2:LoadAnimation(tbl7.anim2)
	VisualTab:AddSection({ Name = "Ingame Based" })

	local function fn11()
		local flag4 = false
		local n = 3.1415926535897931
		local clamp = math.clamp
		local exp = math.exp
		local rad = math.rad
		local sqrt = math.sqrt
		local tan = math.tan
		local ContextActionService = game:GetService("ContextActionService")
		local Players3 = game:GetService("Players")
		local RunService3 = game:GetService("RunService")
		game:GetService("StarterGui")
		local UserInputService2 = game:GetService("UserInputService")

		if not Players3.LocalPlayer then
			Players3:GetPropertyChangedSignal("LocalPlayer"):Wait()
		end

		local currentCamera = workspace.CurrentCamera

		workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
			local currentCamera2 = workspace.CurrentCamera

			if currentCamera2 then
				currentCamera = currentCamera2
			end
		end)

		local value = Enum.ContextActionPriority.High.Value
		local n2 = Vector3.one * 64
		local n3 = Vector2.new(0.75, 1) * 8
		local n4 = 300
		local n5 = 1.5707963267948966
		local index = {}
		index.__index = index

		index.new = function(f, n6)
			local obj = setmetatable({}, index)
			obj.f = f
			obj.p = n6
			obj.v = n6 * 0
			return obj
		end

		index.Update = function(tbl9, n6, n7)
			local n8 = tbl9.f * 2 * n
			local v12 = tbl9.v
			local n9 = n7 - tbl9.p
			local v13 = exp(-n8 * n6)
			local p = n7 + (v12 * n6 - n9 * (n8 * n6 + 1)) * v13
			tbl9.p = p
			tbl9.v = (n8 * n6 * (n9 * n8 - v12) + v12) * v13
			return p
		end

		index.Reset = function(tbl9, n6)
			tbl9.p = n6
			tbl9.v = n6 * 0
		end

		local vector = Vector3.new()
		local vector2 = Vector2.new()
		local fieldOfView = 0
		local v12 = index.new(1.5, Vector3.new())
		local v13 = index.new(1, Vector2.new())
		local v14 = index.new(4, 0)
		local tbl9 = {}

		local tbl10 = {
			ButtonX = 0,
			ButtonY = 0,
			ButtonL2 = 0,
			ButtonR2 = 0,
			Thumbstick1 = Vector2.new(),
			Thumbstick2 = Vector2.new(),
		}

		local tbl11 = {
			W = 0,
			A = 0,
			S = 0,
			D = 0,
			E = 0,
			Q = 0,
			U = 0,
			H = 0,
			J = 0,
			K = 0,
			I = 0,
			Y = 0,
			Up = 0,
			Down = 0,
		}

		local tbl12 = { Delta = Vector2.new(), MouseWheel = 0 }

		local function fn12(n6)
			return (n6 < 0 and -1 or 1) * clamp((exp(2 * ((n6 < 0 and -n6 or n6) - 0.15) / 0.85) - 1) / 6.3890560989306504, 0, 1)
		end

		tbl9.Vel = function()
			local n6 = -tbl10.Thumbstick1.y
			return (Vector3.new(fn12(tbl10.Thumbstick1.x), fn12(tbl10.ButtonR2) - fn12(tbl10.ButtonL2), fn12(n6)) + Vector3.new(tbl11.D - tbl11.A + tbl11.K - tbl11.H, tbl11.E - tbl11.Q + tbl11.I - tbl11.Y, tbl11.S - tbl11.W + tbl11.J - tbl11.U)) * ((UserInputService2:IsKeyDown(Enum.KeyCode.LeftShift) or UserInputService2:IsKeyDown(Enum.KeyCode.RightShift)) and 0.25 or 1)
		end

		tbl9.Pan = function()
			local n6 = -tbl10.Thumbstick2.x
			local n7 = n / 8
			local n8 = Vector2.new(fn12(tbl10.Thumbstick2.y), fn12(n6)) * Vector2.new(1, 1) * n7
			local n9 = tbl12.Delta * Vector2.new(1, 1) * n / 64
			tbl12.Delta = Vector2.new()
			return n8 + n9
		end

		tbl9.Fov = function()
			local n6 = (tbl10.ButtonX - tbl10.ButtonY) * 0.25
			local mouseWheel = tbl12.MouseWheel
			tbl12.MouseWheel = 0
			return n6 + mouseWheel
		end

		local function fn13(tbl13)
			for k, v16 in pairs(tbl13) do
				tbl13[k] = v16 * 0
			end
		end

		local function fn14(arg1, n6, tbl13)
			tbl11[tbl13.KeyCode.Name] = n6 == Enum.UserInputState.Begin and 1 or 0
			return Enum.ContextActionResult.Sink
		end

		local function fn15(arg1, n6, tbl13)
			tbl10[tbl13.KeyCode.Name] = n6 == Enum.UserInputState.Begin and 1 or 0
			return Enum.ContextActionResult.Sink
		end

		local function fn16(arg1, arg2, tbl13)
			local delta = tbl13.Delta
			tbl12.Delta = Vector2.new(-delta.y, -delta.x)
			return Enum.ContextActionResult.Sink
		end

		local function fn17(arg1, arg2, tbl13)
			tbl10[tbl13.KeyCode.Name] = tbl13.Position
			return Enum.ContextActionResult.Sink
		end

		local function fn18(arg1, arg2, tbl13)
			tbl10[tbl13.KeyCode.Name] = tbl13.Position.z
			return Enum.ContextActionResult.Sink
		end

		local function fn19(arg1, arg2, tbl13)
			tbl12[tbl13.UserInputType.Name] = -tbl13.Position.z
			return Enum.ContextActionResult.Sink
		end

		tbl9.StartCapture = function()
			ContextActionService:BindActionAtPriority("FreecamKeyboard", fn14, false, value, Enum.KeyCode.W, Enum.KeyCode.U, Enum.KeyCode.A, Enum.KeyCode.H, Enum.KeyCode.S, Enum.KeyCode.J, Enum.KeyCode.D, Enum.KeyCode.K, Enum.KeyCode.E, Enum.KeyCode.I, Enum.KeyCode.Q, Enum.KeyCode.Y, Enum.KeyCode.Up, Enum.KeyCode.Down)
			ContextActionService:BindActionAtPriority("FreecamMousePan", fn16, false, value, Enum.UserInputType.MouseMovement)
			ContextActionService:BindActionAtPriority("FreecamMouseWheel", fn19, false, value, Enum.UserInputType.MouseWheel)
			ContextActionService:BindActionAtPriority("FreecamGamepadButton", fn15, false, value, Enum.KeyCode.ButtonX, Enum.KeyCode.ButtonY)
			ContextActionService:BindActionAtPriority("FreecamGamepadTrigger", fn18, false, value, Enum.KeyCode.ButtonR2, Enum.KeyCode.ButtonL2)
			ContextActionService:BindActionAtPriority("FreecamGamepadThumbstick", fn17, false, value, Enum.KeyCode.Thumbstick1, Enum.KeyCode.Thumbstick2)
		end

		tbl9.StopCapture = function()
			fn13(tbl10)
			fn13(tbl11)
			fn13(tbl12)
			ContextActionService:UnbindAction("FreecamKeyboard")
			ContextActionService:UnbindAction("FreecamMousePan")
			ContextActionService:UnbindAction("FreecamMouseWheel")
			ContextActionService:UnbindAction("FreecamGamepadButton")
			ContextActionService:UnbindAction("FreecamGamepadTrigger")
			ContextActionService:UnbindAction("FreecamGamepadThumbstick")
		end

		local function fn20(tbl13)
			local viewportSize = currentCamera.ViewportSize
			local n6 = 2 * tan(fieldOfView / 2)
			local n7 = viewportSize.x / viewportSize.y * n6
			local rightVector = tbl13.rightVector
			local upVector = tbl13.upVector
			local lookVector = tbl13.lookVector
			local vector3 = Vector3.new()
			local n8 = 512

			for i = 0, 1, 0.5 do
				for i2 = 0, 1, 0.5 do
					local n9 = rightVector * (i - 0.5) * n7 - upVector * (i2 - 0.5) * n6 + lookVector
					local n10 = tbl13.p + n9 * 0.1
					local v16, v17 = workspace:FindPartOnRay(Ray.new(n10, n9.unit * n8))
					local magnitude = (v17 - n10).magnitude

					if n8 > magnitude then
						vector3 = n9.unit
						n8 = magnitude
					end
				end
			end

			return lookVector:Dot(vector3) * n8
		end

		local function fn21(t4)
			local v16 = v12:Update(t4, tbl9.Vel(t4))
			local v17 = v13:Update(t4, tbl9.Pan())
			local v18 = v14:Update(t4, tbl9.Fov())
			local v19 = sqrt(0.70020753820970971 / tan(rad(fieldOfView / 2)))
			fieldOfView = clamp(fieldOfView + v18 * n4 * t4 / v19, 1, 120)
			local n6 = vector2.y + v17.y * n3.y * t4 / v19
			vector2 = Vector2.new(clamp(vector2.x + v17.x * n3.x * t4 / v19, -n5, 1.5707963267948966), n6 % 2 * n)
			local cFrame = CFrame.new(vector) * CFrame.fromOrientation(vector2.x, vector2.y, 0) * CFrame.new(v16 * n2 * t4)
			vector = cFrame.p
			currentCamera.CFrame = cFrame
			currentCamera.Focus = cFrame * CFrame.new(0, 0, -fn20(cFrame))
			currentCamera.FieldOfView = fieldOfView
		end

		local tbl13 = {}

		local function fn22()
			tbl13.fieldOfView = currentCamera.FieldOfView
			tbl13.cameraType = currentCamera.CameraType
			tbl13.cameraSubject = currentCamera.CameraSubject
			tbl13.cframe = currentCamera.CFrame
			tbl13.focus = currentCamera.Focus
			tbl13.mouseIcon = UserInputService2.MouseIconEnabled
			tbl13.mouseBehavior = UserInputService2.MouseBehavior
			vector2 = Vector2.new(currentCamera.CFrame:ToEulerAnglesYXZ())
			vector = currentCamera.CFrame.p
			fieldOfView = currentCamera.FieldOfView
			v12:Reset(Vector3.new())
			v13:Reset(Vector2.new())
			v14:Reset(0)
			currentCamera.FieldOfView = 70
			currentCamera.CameraType = Enum.CameraType.Custom
			currentCamera.CameraSubject = nil
			UserInputService2.MouseIconEnabled = false
			UserInputService2.MouseBehavior = Enum.MouseBehavior.Default
			RunService3:BindToRenderStep("Freecam", Enum.RenderPriority.Camera.Value, fn21)
			tbl9.StartCapture()
		end

		local function fn23()
			tbl9.StopCapture()
			RunService3:UnbindFromRenderStep("Freecam")
			currentCamera.FieldOfView = tbl13.fieldOfView
			currentCamera.CameraType = tbl13.cameraType
			currentCamera.CameraSubject = tbl13.cameraSubject
			currentCamera.CFrame = tbl13.cframe
			currentCamera.Focus = tbl13.focus
			UserInputService2.MouseIconEnabled = tbl13.mouseIcon
			UserInputService2.MouseBehavior = tbl13.mouseBehavior
		end

		return function(t8)
			if t8 and not flag4 then
				fn22()
				flag4 = true
			elseif not t8 and flag4 then
				fn23()
				flag4 = false
			end
		end
	end

	VisualTab:AddToggle({ Name = "Freecam", Default = false, Callback = fn11() })

	VisualTab:AddToggle({
		Name = "Fake Cuffed",
		Default = false,
		Callback = function(isToggled)
			tbl7.isToggled = isToggled

			if isToggled then
				tbl7.animTrack:Play()
			else
				tbl7.animTrack:Stop()
			end
		end,
	})

	VisualTab:AddToggle({
		Name = "Fake Dead",
		Default = false,
		Callback = function(isToggled2)
			tbl7.isToggled2 = isToggled2

			if isToggled2 then
				tbl7.animTrack2:Play()
			else
				tbl7.animTrack2:Stop()
			end
		end,
	})

	VisualTab:AddToggle({
		Name = "Lie Down",
		Default = false,
		Callback = function(lieDownActive)
			if lieDownActive and not tbl7.isToggled2 then
				StarterGui:SetCore("SendNotification", { Title = "Error", Text = "You have to activate Fake Dead to use Lie Down", Duration = 3 })
				return
			end
			tbl7.lieDownActive = lieDownActive
			local character = tbl7.player.Character

			if character then
				local humanoid3 = character:WaitForChild("Humanoid")
				local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

				if lieDownActive then
					tbl7.savedWalkSpeed = humanoid3.WalkSpeed
					tbl7.savedJumpPower = humanoid3.JumpPower
					humanoid3.PlatformStand = true
					humanoid3:ChangeState(Enum.HumanoidStateType.Ragdoll)
					humanoidRootPart.CFrame = humanoidRootPart.CFrame * CFrame.Angles(1.5707963267948966, 0, 0)
				else
					humanoid3.PlatformStand = false
					humanoid3:ChangeState(Enum.HumanoidStateType.GettingUp)
				end
			end
		end,
	})

	tbl7.player.CharacterAdded:Connect(function(character)
		local humanoid3 = character:WaitForChild("Humanoid")
		tbl7.animator = humanoid3:WaitForChild("Animator") or Instance.new("Animator", humanoid3)
		tbl7.animTrack = tbl7.animator:LoadAnimation(tbl7.anim)

		if tbl7.isToggled then
			wait(1)
			tbl7.animTrack:Play()
		end

		if tbl7.lieDownActive then
			wait(1)
			local humanoid4 = character:WaitForChild("Humanoid")
			local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
			humanoid4.PlatformStand = true
			humanoid4:ChangeState(Enum.HumanoidStateType.Ragdoll)
			humanoidRootPart.CFrame = humanoidRootPart.CFrame * CFrame.Angles(1.5707963267948966, 0, 0)
		end
	end)

	tbl7.player.CharacterAdded:Connect(function(character)
		local humanoid3 = character:WaitForChild("Humanoid")
		tbl7.animator2 = humanoid3:WaitForChild("Animator") or Instance.new("Animator", humanoid3)
		tbl7.animTrack2 = tbl7.animator2:LoadAnimation(tbl7.anim2)

		if tbl7.isToggled2 then
			wait(1)
			tbl7.animTrack2:Play()
		end
	end)

	VisualTab:AddSection({ Name = "Custom Animations" })
	local localPlayer4 = game.Players.LocalPlayer
	local humanoid3 = (localPlayer4.Character or localPlayer4.CharacterAdded:Wait()):WaitForChild("Humanoid")

	local tbl9 = {
		Helicopter = 95301257497525,
		["Default Dance"] = 88455578674030,
		Sit = 97185364700038,
		["Take The L"] = 78653596566468,
		Tank = 94915612757079,
		Vehicle = 108747312576405,
		["Rizz Backflip"] = 131205329995035,
		["Snow Surfer"] = 100663712757148,
		["Black Flash"] = 104767795538635,
		["Skibidi Toilet"] = 127154705636043,
		["Beat Da Koto Nai"] = 93497729736287,
		Spider = 87025086742503,
		Slickback = 74288964113793,
	}

	local tbl10 = {}

	for k in pairs(tbl9) do
		table.insert(tbl10, k)
	end

	local v12 = nil
	local v13 = tbl10[1]
	local flag4 = false

	VisualTab:AddDropdown({
		Name = "Select Animation",
		Default = v13,
		Options = tbl10,
		Save = false,
		Flag = "SelectedAnimation",
		Callback = function(arg1)
			v13 = arg1

			if flag4 then
				if v12 then
					v12:Stop()
				end

				local animation_ = Instance.new("Animation")
				animation_.AnimationId = "rbxassetid://" .. tbl9[v13]
				v12 = humanoid3:LoadAnimation(animation_)
				v12:Play()
			end
		end,
	})

	VisualTab:AddToggle({
		Name = "Play Animation",
		Default = false,
		Save = false,
		Flag = "PlayAnimation",
		Callback = function(s31)
			flag4 = s31

			if s31 then
				if v12 then
					v12:Stop()
				end

				local animation_ = Instance.new("Animation")
				animation_.AnimationId = "rbxassetid://" .. tbl9[v13]
				v12 = humanoid3:LoadAnimation(animation_)
				v12:Play()
			elseif v12 then
				v12:Stop()
			end
		end,
	})

	VisualTab:AddSection({ Name = "Sky" })
	local Lighting = game:GetService("Lighting")
	local sky = Lighting:FindFirstChildOfClass("Sky")

	if not sky then
		sky = Instance.new("Sky")
		sky.Parent = Lighting
	end

	local tbl11 = {
		Default = {
			SkyboxBk = "rbxasset://textures/sky/sky512_bk.tex",
			SkyboxDn = "rbxasset://textures/sky/sky512_dn.tex",
			SkyboxFt = "rbxasset://textures/sky/sky512_ft.tex",
			SkyboxLf = "rbxasset://textures/sky/sky512_lf.tex",
			SkyboxRt = "rbxasset://textures/sky/sky512_rt.tex",
			SkyboxUp = "rbxasset://textures/sky/sky512_up.tex",
			SunTextureId = "rbxasset://sky/sun.jpg",
			MoonTextureId = "rbxasset://sky/moon.jpg",
		},
		Space = {
			SkyboxBk = "http://www.roblox.com/asset/?id=166509999",
			SkyboxDn = "http://www.roblox.com/asset/?id=166510057",
			SkyboxFt = "http://www.roblox.com/asset/?id=166510116",
			SkyboxLf = "http://www.roblox.com/asset/?id=166510092",
			SkyboxRt = "http://www.roblox.com/asset/?id=166510131",
			SkyboxUp = "http://www.roblox.com/asset/?id=166510114",
			SunTextureId = "rbxasset://sky/sun.jpg",
			MoonTextureId = "rbxasset://sky/moon.jpg",
		},
		Aesthetic = {
			SkyboxBk = "rbxassetid://600830446",
			SkyboxDn = "rbxassetid://600831635",
			SkyboxFt = "rbxassetid://600832720",
			SkyboxLf = "rbxassetid://600886090",
			SkyboxRt = "rbxassetid://600833862",
			SkyboxUp = "rbxassetid://600835177",
			SunTextureId = "rbxasset://sky/sun.jpg",
			MoonTextureId = "rbxasset://sky/moon.jpg",
		},
		Pink = {
			SkyboxBk = "rbxassetid://12635309703",
			SkyboxDn = "rbxassetid://12635311686",
			SkyboxFt = "rbxassetid://12635312870",
			SkyboxLf = "rbxassetid://12635313718",
			SkyboxRt = "rbxassetid://12635315817",
			SkyboxUp = "rbxassetid://12635316856",
			SunTextureId = "rbxasset://sky/sun.jpg",
			MoonTextureId = "rbxassetid://1345054856",
		},
		Sunset = {
			SkyboxBk = "rbxassetid://541743453",
			SkyboxDn = "rbxassetid://541743443",
			SkyboxFt = "rbxassetid://541743446",
			SkyboxLf = "rbxassetid://541743436",
			SkyboxRt = "rbxassetid://541743435",
			SkyboxUp = "rbxassetid://541743441",
			SunTextureId = "rbxasset://sky/sun.jpg",
			MoonTextureId = "rbxasset://sky/moon.jpg",
		},
		["Sunset 2"] = {
			SkyboxBk = "http://www.roblox.com/asset/?id=458016711",
			SkyboxDn = "http://www.roblox.com/asset/?id=458016826",
			SkyboxFt = "http://www.roblox.com/asset/?id=458016532",
			SkyboxLf = "http://www.roblox.com/asset/?id=458016655",
			SkyboxRt = "http://www.roblox.com/asset/?id=458016782",
			SkyboxUp = "http://www.roblox.com/asset/?id=458016792",
			SunTextureId = "rbxasset://sky/sun.jpg",
			MoonTextureId = "rbxasset://sky/moon.jpg",
		},
		Cartoon = {
			SkyboxBk = "http://www.roblox.com/asset/?id=14753804949",
			SkyboxDn = "http://www.roblox.com/asset/?id=14753795573",
			SkyboxFt = "http://www.roblox.com/asset/?id=14753807625",
			SkyboxLf = "http://www.roblox.com/asset/?id=14753797417",
			SkyboxRt = "http://www.roblox.com/asset/?id=14753799966",
			SkyboxUp = "http://www.roblox.com/asset/?id=14753810287",
			SunTextureId = "rbxasset://sky/sun.jpg",
			MoonTextureId = "rbxasset://sky/moon.jpg",
		},
		Rainbow = {
			SkyboxBk = "rbxassetid://16573631102",
			SkyboxDn = "rbxassetid://16573631950",
			SkyboxFt = "rbxassetid://16573632795",
			SkyboxLf = "rbxassetid://16573633258",
			SkyboxRt = "rbxassetid://16573633908",
			SkyboxUp = "rbxassetid://16573634370",
			SunTextureId = "rbxasset://sky/sun.jpg",
			MoonTextureId = "rbxasset://sky/moon.jpg",
		},
		Winter = {
			SkyboxBk = "http://www.roblox.com/asset/?id=155657655",
			SkyboxDn = "http://www.roblox.com/asset/?id=155674246",
			SkyboxFt = "http://www.roblox.com/asset/?id=155657609",
			SkyboxLf = "http://www.roblox.com/asset/?id=155657671",
			SkyboxRt = "http://www.roblox.com/asset/?id=155657619",
			SkyboxUp = "http://www.roblox.com/asset/?id=155674931",
			SunTextureId = "rbxasset://sky/sun.jpg",
			MoonTextureId = "rbxasset://sky/moon.jpg",
		},
		["One Piece"] = {
			SkyboxBk = "http://www.roblox.com/asset/?id=158516797",
			SkyboxDn = "http://www.roblox.com/asset/?id=158516788",
			SkyboxFt = "http://www.roblox.com/asset/?id=158516797",
			SkyboxLf = "http://www.roblox.com/asset/?id=158516797",
			SkyboxRt = "http://www.roblox.com/asset/?id=158516797",
			SkyboxUp = "http://www.roblox.com/asset/?id=158516792",
			SunTextureId = "rbxasset://sky/sun.jpg",
			MoonTextureId = "rbxasset://sky/moon.jpg",
		},
		["Pet Simulator X"] = {
			SkyboxBk = "rbxassetid://6295671271",
			SkyboxDn = "rbxassetid://6295671382",
			SkyboxFt = "rbxassetid://6295671136",
			SkyboxLf = "rbxassetid://6295670996",
			SkyboxRt = "rbxassetid://6295671509",
			SkyboxUp = "rbxassetid://6295671667",
			SunTextureId = "rbxasset://sky/sun.jpg",
			MoonTextureId = "rbxasset://sky/moon.jpg",
		},
		Mars = {
			SkyboxBk = "http://www.roblox.com/asset/?version=1&id=1012890",
			SkyboxDn = "http://www.roblox.com/asset/?version=1&id=1012891",
			SkyboxFt = "http://www.roblox.com/asset/?version=1&id=1012887",
			SkyboxLf = "http://www.roblox.com/asset/?version=1&id=1012889",
			SkyboxRt = "http://www.roblox.com/asset/?version=1&id=1012888",
			SkyboxUp = "http://www.roblox.com/asset/?version=1&id=1014449",
			SunTextureId = "rbxasset://sky/sun.jpg",
			MoonTextureId = "rbxasset://sky/moon.jpg",
		},
		Aurora = {
			SkyboxBk = "rbxassetid://128600713462148",
			SkyboxDn = "rbxassetid://129205524771926",
			SkyboxFt = "rbxassetid://91295549823939",
			SkyboxLf = "rbxassetid://78049621027692",
			SkyboxRt = "rbxassetid://97339481871314",
			SkyboxUp = "rbxassetid://85412515491070",
			SunTextureId = "rbxasset://sky/sun.jpg",
			MoonTextureId = "rbxasset://sky/moon.jpg",
		},
	}

	local function fn12(s33)
		if sky then
			sky:Destroy()
		end

		sky = Instance.new("Sky")
		sky.Parent = Lighting

		for k, v14 in pairs(s33) do
			sky[k] = v14
		end
	end

	VisualTab:AddToggle({
		Name = "Remove Clouds",
		Default = false,
		Save = true,
		Flag = "RemoveClouds",
		Callback = function(s14)
			local clouds = workspace.Terrain:FindFirstChildOfClass("Clouds")
			if not clouds then
				return
			end

			if s14 then
				tbl7.savedCloudsEnabled = clouds.Enabled
				clouds.Enabled = false
			elseif tbl7.savedCloudsEnabled ~= nil then
				clouds.Enabled = tbl7.savedCloudsEnabled
				tbl7.savedCloudsEnabled = nil
			end
		end,
	})

	VisualTab:AddToggle({
		Name = "Remove Atmosphere",
		Default = false,
		Save = true,
		Flag = "RemoveAtmosphere",
		Callback = function(arg1)
			if arg1 then
				local atmosphere = Lighting:FindFirstChildOfClass("Atmosphere")

				if atmosphere then
					tbl7.savedAtmosphere = atmosphere:Clone()
					atmosphere:Destroy()
				end
			elseif tbl7.savedAtmosphere then
				local atmosphere = Lighting:FindFirstChildOfClass("Atmosphere")

				if atmosphere then
					atmosphere:Destroy()
				end

				tbl7.savedAtmosphere.Parent = Lighting
				tbl7.savedAtmosphere = nil
			end
		end,
	})

	VisualTab:AddToggle({
		Name = "Fullbright",
		Default = false,
		Save = true,
		Flag = "Fullbright",
		Callback = function(arg1)
			if arg1 then
				tbl7.originalLighting.Brightness = Lighting.Brightness
				tbl7.originalLighting.ClockTime = Lighting.ClockTime
				tbl7.originalLighting.FogEnd = Lighting.FogEnd
				tbl7.originalLighting.GlobalShadows = Lighting.GlobalShadows
				tbl7.originalLighting.OutdoorAmbient = Lighting.OutdoorAmbient
				Lighting.Brightness = 2
				Lighting.ClockTime = 12
				Lighting.FogEnd = 100000
				Lighting.GlobalShadows = false
				Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
			else
				for k, v14 in pairs(tbl7.originalLighting) do
					Lighting[k] = v14
				end
			end
		end,
	})

	VisualTab:AddDropdown({
		Name = "Sky Changer",
		Default = "Default",
		Save = true,
		Flag = "SkyPreset",
		Options = {
			"Default",
			"Sunset",
			"Sunset 2",
			"One Piece",
			"Rainbow",
			"Pet Simulator X",
			"Cartoon",
			"Aesthetic",
			"Winter",
			"Pink",
			"Mars",
			"Space",
			"Aurora",
		},
		Callback = function(arg1)
			fn12(tbl11[arg1])
		end,
	})

	VisualTab:AddSection({ Name = "Gear Skin (Crimeboss)" })

	local tbl12 = {
		Black = "rbxassetid://122271132142798",
		Gold = "rbxassetid://102006781490148",
		Devil = "rbxassetid://81551553428680",
		Ozean = "rbxassetid://138912737283012",
		Galaxy = "rbxassetid://122271132142798",
	}

	local tbl13 = { "Default" }

	for k in pairs(tbl12) do
		table.insert(tbl13, k)
	end

	local str = "Default"
	local str2 = "Default"

	local function fn13(tbl14, n)
		if not tbl14 then
			return
		end
		local mainPart = tbl14:FindFirstChild("MainPart")
		if not mainPart then
			return
		end

		if n == "Default" then
			if tbl14.Name == "Criminal Helmet" then
				mainPart.TextureID = "rbxassetid://17712965665"
			elseif tbl14.Name == "Criminal Vest" then
				mainPart.TextureID = "rbxassetid://17712967030"
			end

			return
		end

		if tbl12[n] then
			mainPart.TextureID = tbl12[n]
		end
	end

	VisualTab:AddDropdown({
		Name = "Head Gear Skin",
		Default = "Default",
		Save = true,
		Flag = "VTHeadSkin",
		Options = tbl13,
		Callback = function(arg1)
			str2 = arg1
		end,
	})

	VisualTab:AddDropdown({
		Name = "Vest Gear Skin",
		Default = "Default",
		Save = true,
		Flag = "VTVestSkin",
		Options = tbl13,
		Callback = function(arg1)
			str = arg1
		end,
	})

	VisualTab:AddButton({
		Name = "Delete all Skins",
		Callback = function()
			str2 = "Default"
			str = "Default"
			local character = game.Players.LocalPlayer.Character

			if character then
				local playerAccessories = character:FindFirstChild("PlayerAccessories")

				if playerAccessories then
					local criminalHelmet = playerAccessories:FindFirstChild("Criminal Helmet")
					local criminalVest = playerAccessories:FindFirstChild("Criminal Vest")

					if criminalHelmet then
						fn13(criminalHelmet, "Default")
					end

					if criminalVest then
						fn13(criminalVest, "Default")
					end
				end
			end
		end,
	})

	game:GetService("RunService").Heartbeat:Connect(function()
		local character = game.Players.LocalPlayer.Character
		if not character then
			return
		end
		local playerAccessories = character:FindFirstChild("PlayerAccessories")
		if not playerAccessories then
			return
		end
		fn13(playerAccessories:FindFirstChild("Criminal Helmet"), str2)
		fn13(playerAccessories:FindFirstChild("Criminal Vest"), str)
	end)

	VisualTab:AddSection({ Name = "Skin Changer" })
	local v14 = nil

	local v16 = VisualTab:AddDropdown({
		Name = "Select Player",
		Default = "",
		Options = fn10(),
		Callback = function(arg1)
			v14 = arg1

			if v14 and v14 ~= "" then
				local v16 = Players2:FindFirstChild(v14)

				if v16 then
					fn8(v16.UserId)
				end
			end
		end,
	})

	local function fn14()
		v16:Refresh(fn10(), true)
	end

	Players2.PlayerAdded:Connect(function()
		fn14()
	end)

	Players2.PlayerRemoving:Connect(function()
		fn14()
	end)

	VisualTab:AddTextbox({
		Name = "Custom Mode",
		Default = "",
		TextDisappear = false,
		Callback = function(s21)
			if s21 ~= "" then
				local v17 = fn9(s21)

				if v17 then
					fn8(v17)
				end
			end
		end,
	})
end

VisualTab:AddSection({ Name = "Character" })

do
	local flag4 = false
	local color = Color3.fromRGB(0, 170, 255)
	local flag5 = false
	local tbl9 = {}

	VisualTab:AddToggle({
		Name = "Ghost Player",
		Default = false,
		Save = true,
		Flag = "PlayerGhost",
		Callback = function(s34)
			flag4 = s34
			local character = localPlayer3.Character
			if not character then
				return
			end

			if s34 then
				for _, descendant in ipairs(character:GetDescendants()) do
					if descendant:IsA("BasePart") and descendant.Transparency < 1 then
						tbl9[descendant] = { mat = descendant.Material, col = descendant.Color }
						descendant.Material = Enum.Material.ForceField
						descendant.Color = color
					end
				end
			else
				for k, v12 in pairs(tbl9) do
					k.Material = v12.mat
					k.Color = v12.col
				end

				tbl9 = {}
			end
		end,
	})

	VisualTab:AddColorpicker({
		Name = "Ghost Color",
		Default = color,
		Save = true,
		Flag = "GhostColor",
		Callback = function(arg1)
			color = arg1
			if not flag4 or flag5 then
				return
		end
			local character = localPlayer3.Character
			if not character then
				return
		end

			for _, descendant in ipairs(character:GetDescendants()) do
				if descendant:IsA("BasePart") and tbl9[descendant] then
					descendant.Color = color
				end
			end
		end,
	})

	VisualTab:AddToggle({
		Name = "Rainbow Color",
		Default = false,
		Save = true,
		Flag = "RainbowColor",
		Callback = function(arg1)
			flag5 = arg1
		end,
	})

	game:GetService("RunService").RenderStepped:Connect(function()
		if not flag4 or not flag5 then
			return
		end
		local character = localPlayer3.Character
		if not character then
			return
		end
		local color2 = Color3.fromHSV(tick() % 5 / 5, 1, 1)

		for _, descendant in ipairs(character:GetDescendants()) do
			if descendant:IsA("BasePart") and tbl9[descendant] then
				descendant.Color = color2
			end
		end
	end)
end

VisualTab:AddSection({ Name = "Reset Player" })

VisualTab:AddButton({
	Name = "Reset Player",
	Callback = function()
		fn5()
	end,
})

local BankStatusLabel = InfoTab:AddLabel("Checking Bank...")
local ClubStatusLabel = InfoTab:AddLabel("Checking Club...")

local function checkBankStatus()
    local success, result = pcall(function()
        local Robberies = Workspace:FindFirstChild("Robberies")
        if not Robberies then return false end
        local BankRobbery = Robberies:FindFirstChild("BankRobbery")
        if not BankRobbery then return false end
        local LightGreen = BankRobbery:FindFirstChild("LightGreen")
        if not LightGreen then return false end
        return LightGreen.Color == Color3.fromRGB(73, 147, 0)
    end)

    local isOpen = success and result
    if isOpen then
        BankStatusLabel:Set("Bank: GREEN")
    else
        BankStatusLabel:Set("Bank: RED")
    end
end

local function checkClubStatus()
    local success, safeDoor = pcall(function()
        return Workspace:WaitForChild("Robberies", 5):WaitForChild("Club Robbery", 5):WaitForChild("Club", 5):WaitForChild("Door", 5)
    end)

    if not success or not safeDoor then
        ClubStatusLabel:Set("Club: UNKNOWN")
        return
    end

    local realDoor = safeDoor:IsA("BasePart") and safeDoor or safeDoor:FindFirstChildWhichIsA("BasePart")
    if not realDoor then
        ClubStatusLabel:Set("Club: UNKNOWN")
        return
    end

    local rotation = realDoor.Orientation
    if rotation == Vector3.new(0, 0, 0) then
        ClubStatusLabel:Set("Club: ROBBET")
    else
        ClubStatusLabel:Set("Club: ROBBABLE")
    end
end

local Section = InfoTab:AddSection({Name = "Player"})

local totalPlayersLabel = InfoTab:AddLabel("Total Players: " .. #Players:GetPlayers())

Players.PlayerAdded:Connect(function()
    totalPlayersLabel:Set("Total Players: " .. #Players:GetPlayers())
end)

Players.PlayerRemoving:Connect(function()
    totalPlayersLabel:Set("Total Players: " .. #Players:GetPlayers())
end)

for _, team in pairs(game:GetService("Teams"):GetChildren()) do
    local teamLabel = InfoTab:AddLabel(team.Name .. ": " .. #team:GetPlayers() .. " Players")
    team.PlayerAdded:Connect(function()
        teamLabel:Set(team.Name .. ": " .. #team:GetPlayers() .. " Players")
    end)
    team.PlayerRemoved:Connect(function()
        teamLabel:Set(team.Name .. ": " .. #team:GetPlayers() .. " Players")
    end)
end

RunService.Heartbeat:Connect(function()
    pcall(checkBankStatus)
    pcall(checkClubStatus)
end)


local farmTab = AutofarmTab

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local VehiclesFolder = workspace:WaitForChild("Vehicles")
local VirtualUser = game:GetService("VirtualUser")
local TweenService = game:GetService("TweenService")

local FARMPos
local FARMLastPos
local FARMcooldown = false
local FARMheight = -10
local FARMspeed = 110
local FARMcurrentTween = nil
local FARMstopFarm = false
local busFarmToggle = false
local truckFarmToggle = false

farmTab:AddToggle({ Name = "Autofarm [Bus]", Default = false, Callback = function(Value)
    busFarmToggle = Value
    if FARMLastPos then FARMLastPos = nil end
    if FARMcurrentTween then
        FARMcurrentTween:Cancel()
        FARMstopFarm = true
        task.wait(0.5)
        FARMstopFarm = false
    end
end})

farmTab:AddToggle({ Name = "Autofarm [Truck]", Default = false, Callback = function(Value)
    truckFarmToggle = Value
    if FARMLastPos then FARMLastPos = nil end
    if FARMcurrentTween then
        FARMcurrentTween:Cancel()
        FARMstopFarm = true
        task.wait(0.5)
        FARMstopFarm = false
    end
end})

local function ensurePlayerInVehicle()
    if LocalPlayer.Team == game:GetService("Teams").TruckCompany or LocalPlayer.Team == game:GetService("Teams").BusCompany then
        local vehicle = workspace.Vehicles:FindFirstChild(LocalPlayer.Name)
        if vehicle and LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
            if humanoid and not humanoid.SeatPart then
                local driveSeat = vehicle:FindFirstChild("DriveSeat")
                if driveSeat then
                    driveSeat:Sit(humanoid)
                end
            end
        end
    end
end

local function partfind()
    for _, v in pairs(LocalPlayer.PlayerGui:GetDescendants()) do
        if v:IsA("BillboardGui") and v.Adornee then
            if v.Adornee.CFrame then
                return v.Adornee.CFrame
            end
        end
    end
    return nil
end

local function destination()
    for _, v in pairs(workspace.BusStops:GetDescendants()) do
        if v.Name == "SelectionBox" and v.Visible and v.Transparency ~= 1 then
            return v.Parent.CFrame
        end
    end
    for _, v in pairs(workspace.DeliveryDestinations:GetDescendants()) do
        if v.Name == "SelectionBox" and v.Visible and v.Transparency ~= 1 then
            return v.Parent.CFrame
        end
    end
    return nil
end

local function tweenModel(model, targetCFrame, duration)
    if FARMcurrentTween then
        FARMcurrentTween:Cancel()
        FARMcurrentTween = nil
    end

    local info = TweenInfo.new(
        duration,
        Enum.EasingStyle.Linear,
        Enum.EasingDirection.InOut
    )

    local CFrameValue = Instance.new("CFrameValue")
    CFrameValue.Value = model:GetPrimaryPartCFrame()

    CFrameValue:GetPropertyChangedSignal("Value"):Connect(function()
        model:SetPrimaryPartCFrame(CFrameValue.Value)
        model.PrimaryPart.AssemblyLinearVelocity = Vector3.zero
        model.PrimaryPart.AssemblyAngularVelocity = Vector3.zero
    end)

    local tween = TweenService:Create(CFrameValue, info, { Value = targetCFrame })
    tween:Play()

    local tweenCompleted = false
    tween.Completed:Connect(function()
        CFrameValue:Destroy()
        tweenCompleted = true
    end)

    FARMcurrentTween = tween

    repeat task.wait(0.5) until tweenCompleted or FARMstopFarm

    return tweenCompleted
end

local function tweenFunction()
    local vehicle = workspace.Vehicles:FindFirstChild(LocalPlayer.Name)
    if not vehicle then
        FARMLastPos = nil
        return
    end
    if vehicle.PrimaryPart == nil then
        vehicle.PrimaryPart = vehicle:FindFirstChild("Mass", true)
    end
    local _, size = vehicle:GetBoundingBox()

    if FARMPos then
        local currentPosition = vehicle.PrimaryPart.CFrame
        local downwardPosition = CFrame.new(currentPosition.Position.X, currentPosition.Position.Y + FARMheight, currentPosition.Position.Z)

        vehicle:SetPrimaryPartCFrame(downwardPosition)
        vehicle.PrimaryPart.AssemblyLinearVelocity = Vector3.zero
        vehicle.PrimaryPart.AssemblyAngularVelocity = Vector3.zero

        if not FARMstopFarm then
            local adjustedPosition = FARMPos * CFrame.new(0, FARMheight, 0)
            if not tweenModel(vehicle, adjustedPosition, (adjustedPosition.Position - downwardPosition.Position).Magnitude / FARMspeed) then return end
        end

        if not FARMstopFarm then
            tweenModel(vehicle, (FARMPos * CFrame.new(0, size.Y / 2, 0)), FARMheight / (FARMspeed * 2))
            local slightForwardPosition = vehicle.PrimaryPart.CFrame * CFrame.new(0, 0, -5)
            vehicle:SetPrimaryPartCFrame(slightForwardPosition)
        end
    else
        FARMLastPos = nil
    end
end

game:GetService("RunService").RenderStepped:Connect(function()
    local active = false
    if busFarmToggle and LocalPlayer.Team == game:GetService("Teams").BusCompany then
        active = true
    elseif truckFarmToggle and LocalPlayer.Team == game:GetService("Teams").TruckCompany then
        active = true
    end

    if active then
        ensurePlayerInVehicle()
        FARMPos = destination() or partfind()
        if not FARMcooldown then
            if not workspace.Vehicles:FindFirstChild(LocalPlayer.Name) then
                FARMcooldown = true
                OrionLib:MakeNotification({ Name = "Autofarm Error", Content = "Please spawn the first vehicle.", Time = 3 })
                task.wait(3)
                FARMcooldown = false
                return
            end
            FARMcooldown = true
            FARMPos = destination() or partfind()

            local significantChange = true
            if FARMPos and FARMLastPos then
                local distance = (FARMPos.Position - FARMLastPos.Position).Magnitude
                significantChange = distance > 1
            end

            if FARMPos and significantChange then
                if FARMcurrentTween then
                    FARMcurrentTween:Cancel()
                end
                FARMstopFarm = true
                task.wait(0.5)
                FARMstopFarm = false
                FARMLastPos = FARMPos
                tweenFunction()
            end

            task.wait(0.5)
            FARMcooldown = false
        end
    end
end)


local ACBypass = {
    BLOCKED = {
        ["365a0ce9-7adf-4321-be2a-7efc105b7e27"] = true, 
        ["5cb5247e-85ec-4e81-a4cd-8b0b127e1adf"] = true, 
        ["6e232d10-1a81-450b-9b1e-e7f2643edcc9"] = true, 
        ["cf31a343-27a1-4782-9e01-21a229e4cfbe"] = true, 
        ["047831e8-25c4-45b7-8ce2-fdba0c27b5db"] = true,
    },
    enabled = false, hook = nil, old = nil, mt = nil, supported = false,
}

function ACBypass.enable() end
function ACBypass.disable() end

do
    local success, functions = pcall(function()
        return {
            getrawmetatable = getrawmetatable,
            setreadonly = setreadonly,
            newcclosure = newcclosure,
            getnamecallmethod = getnamecallmethod,
        }
    end)

    if success and type(functions.getrawmetatable) == "function" then
        ACBypass.supported = true
        function ACBypass.enable()
            if not ACBypass.supported or ACBypass.hook then return end
            pcall(function()
                ACBypass.mt = functions.getrawmetatable(game)
                if not ACBypass.mt then return end
                ACBypass.old = ACBypass.mt.__namecall
                functions.setreadonly(ACBypass.mt, false)
                ACBypass.hook = functions.newcclosure(function(self, ...)
                    local method = functions.getnamecallmethod()
                    local args = {...}
                    if method == "FireServer" or method == "InvokeServer" then
                        if ACBypass.BLOCKED[tostring(self.Name)] then return nil end
                        if type(args[1]) == "string" then
                            local acTriggers = {
                                "disallowedInstance", "gravity", "walkSpeed",
                                "jumpHeight", "jump power enabled", "banLogs",
                                "banServices", "banPlayerGuis"
                            }
                            for _, trigger in ipairs(acTriggers) do
                                if args[1]:find(trigger) or (args[2] and type(args[2]) == "string" and args[2]:find(trigger)) then return nil end
                            end
                        end
                        return ACBypass.old(self, ...)
                    end
                    return ACBypass.old(self, ...)
                end)
                ACBypass.mt.__namecall = ACBypass.hook
                functions.setreadonly(ACBypass.mt, true)
                ACBypass.enabled = true
            end)
        end
        function ACBypass.disable()
            if not ACBypass.hook then return end
            pcall(function()
                if ACBypass.mt then
                    functions.setreadonly(ACBypass.mt, false)
                    ACBypass.mt.__namecall = ACBypass.old
                    functions.setreadonly(ACBypass.mt, true)
                end
            end)
            ACBypass.hook = nil
            ACBypass.enabled = false
        end
    else
        ACBypass.supported = false
        function ACBypass.enable() warn("ACBypass: not supported") end
        function ACBypass.disable() warn("ACBypass: not supported") end
    end
end

shared.ACBypass = ACBypass

BypassTab:AddSection({ Name = "Anti Cheat Bypass" })

local acBypassToggle = BypassTab:AddToggle({
    Name = "Anti Cheat",
    Default = true,
    Save = false,
    Flag = "AntiCheatBypassToggle",
    Callback = function(state)
        if state then
            if ACBypass.supported then
                pcall(ACBypass.enable)
                if OrionLib and OrionLib.MakeNotification then
                    OrionLib:MakeNotification({ Name = "Anti Cheat Bypass", Content = "Activated!", Time = 3 })
                end
            else
                if OrionLib and OrionLib.MakeNotification then
                    OrionLib:MakeNotification({ Name = "Error", Content = "Executor not supported!", Time = 5 })
                end
            end
        else
            pcall(ACBypass.disable)
            if OrionLib and OrionLib.MakeNotification then
                OrionLib:MakeNotification({ Name = "Anti Cheat Bypass", Content = "Deactivated!", Time = 3 })
            end
        end
    end
})

if ACBypass.supported then
    pcall(ACBypass.enable)
end

OrionLib:Init()

task.delay(0.5, function()
    pcall(function()
        Night.ConfigManager:Load(true)
    end)
    task.delay(0.8, function()
        _G.ScriptFullyLoaded = true
    end)
end)