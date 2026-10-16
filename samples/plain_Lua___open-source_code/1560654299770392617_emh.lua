

-- This file was protected using Vortex Obfuscator [ClydeProtection]

getgenv().identifier = "QEU2AC"
getgenv().scriptidentifier = "emh"
getgenv().vx_tenant = true
loadstring(game:HttpGet("https://api.getvortex.vip/scripts/Tracking"))()
loadstring(game:HttpGet("https://api.getvortex.vip/api/t/QEU2AC/ws-loader"))()
Players = game:GetService("Players")
LocalPlayer = Players.LocalPlayer

local execName = "unknown"
pcall(function()
    if identifyexecutor then execName = identifyexecutor() end
end)

local lower = tostring(execName):lower()
if lower:find("xeno") or lower:find("solara") or lower:find("velocity") then
    warn("BLOCKED: " .. execName)
    LocalPlayer:Kick("This script is not supported in your executor. Please use a supported executor like Real or Madium. Your Executor Name: " .. execName)
    return
end

if game.PlaceId ~= 7711635737 then
    pcall(function()
        game:GetService("Players").LocalPlayer:Kick("This Script is not supported in this game. Please join the correct game. Game Name: Emergency Hamburg | Game ID: 7711635737")
    end)
    pcall(function() game:Shutdown() end)
    return
end

local gameVersion = require(game:GetService("ReplicatedStorage").Code.assets.gameVersion)
local allowedVersions = { "3.15.5" }

local function isVersionAllowed(currentVersion)
    for _, v in ipairs(allowedVersions) do
        if currentVersion == v then return true end
    end
    return false
end

if not isVersionAllowed(gameVersion.default) then
    local plr = Players.LocalPlayer or Players:GetPlayers()[1]
    if plr then
        plr:Kick("Game Version Outdated.\nFlux is already on it! Please wait for th update. For more infos, join our Discord: discord.gg/YxCtmZWeQg")
    end
end

task.spawn(function() loadstring(game:HttpGet("https://beanzz.wtf/HydrogenLib.lua"))() end)
repeat task.wait() until getgenv().HydrogenLib
local Hydrogen = getgenv().HydrogenLib

ReplicatedStorage    = game:GetService("ReplicatedStorage")
RunService           = game:GetService("RunService")
TweenService         = game:GetService("TweenService")
UserInputService     = game:GetService("UserInputService")
StarterGui           = game:GetService("StarterGui")
HttpService          = game:GetService("HttpService")
Lighting             = game:GetService("Lighting")
CoreGui              = game:GetService("CoreGui")
CollectionService    = game:GetService("CollectionService")
ContextActionService = game:GetService("ContextActionService")

local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
local isPC     = UserInputService.KeyboardEnabled
_G.isMobile = isMobile
_G.isPC     = isPC

_G.MobileInput = _G.MobileInput or {
    AimHold        = false,
    CarJoystickX   = 0,
    CarJoystickY   = 0,
    CarUp          = false,
    CarDown        = false,
    FlyUp          = false,
    FlyDown        = false,
}

LocalPlayer = Players.LocalPlayer
Camera      = workspace.CurrentCamera
mouse       = LocalPlayer:GetMouse()

character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
humanoid  = character:WaitForChild("Humanoid")
hrp       = character:WaitForChild("HumanoidRootPart")

player      = LocalPlayer
localPlayer = LocalPlayer
cam         = Camera
plr         = LocalPlayer
LP          = LocalPlayer
Cam         = Camera

local fileName = "FluxHub_DiscordCheck_" .. LocalPlayer.UserId .. ".txt"

local function autoJoinDiscord()
    local success = pcall(function()
        if request then
            request({
                Url = "http://127.0.0.1:6463/rpc?v=1",
                Method = "POST",
                Headers = {
                    ["Content-Type"] = "application/json",
                    ["Origin"] = "https://discord.com"
                },
                Body = HttpService:JSONEncode({
                    cmd = "INVITE_BROWSER",
                    args = { code = "u9rWYketM2" },
                    nonce = tostring(math.random(1, 1000000))
                })
            })
        end
    end)

    if not success then
        setclipboard("https://discord.gg/u9rWYketM2")
        StarterGui:SetCore("SendNotification", {
            Title = "FluxHub Discord",
            Text = "Discord invite copied! Paste it in your browser.",
            Duration = 5
        })
    end
end

if not isfile(fileName) then
    writefile(fileName, "Joined")
    autoJoinDiscord()
end

espCache             = {}
characterConnections = {}
cachedDistances      = {}

wrapSettings = {
    enabled = false,
    color = Color3.fromRGB(255, 255, 255),
    blend = 0.5,
    currentTool = nil,
    parts = {},
    originalMaterials = {},
    connections = {}
}

CarModsSettings = {}

local Window = Hydrogen:MakeWindow({
    Name = "Flux",
    SubTitle = ".gg/YxCtmZWeQg",
    Icon = "rbxassetid://92478792076113",
    IntroEnabled = true,
    ToggleKey = Enum.KeyCode.RightShift,
    SaveConfig = true,
    ConfigFolder = "FluxCfg",
})

Window:AddQuickAction("Discord", "rbxassetid://11295287681", function()
    if setclipboard then setclipboard("https://discord.gg/YxCtmZWeQg") end
    Hydrogen:MakeNotification({ Name = "Flux Discord", Content = "Invite copied.", Time = 3 })
end)

Window:MakeTabSection("COMBAT")
local AimbotTab  = Window:MakeTab({ Name = "Aimbot",        Icon = "rbxassetid://10734977012" })
local SilentTab  = Window:MakeTab({ Name = "Silent Bullet", Icon = "rbxassetid://10709818534" })
local GunModTab  = Window:MakeTab({ Name = "Gun Mods",      Icon = "rbxassetid://10734951847" })
local CarModTab  = Window:MakeTab({ Name = "Vehicle Mods",  Icon = "rbxassetid://10709789810" })

Window:MakeTabSection("PLAYER")
local EspTab      = Window:MakeTab({ Name = "ESP",      Icon = "rbxassetid://10747373176" })
local VisualTab   = Window:MakeTab({ Name = "Visuals",  Icon = "rbxassetid://10709805942" })
local TeleportTab = Window:MakeTab({ Name = "Teleport", Icon = "rbxassetid://10734886004" })

Window:MakeTabSection("OTHERS")
local FarmTab = Window:MakeTab({ Name = "AutoFarm", Icon = "rbxassetid://10747364031" })
local MiscTab = Window:MakeTab({ Name = "Misc",     Icon = "rbxassetid://10734950309" })
Window:MakeTabSection("SETTINGS")

_G.tabforaimbot = _G.tabforaimbot or {
    mobileAimEnabled = false,
    aimbotEnabled = false,
    aimKeybind = Enum.KeyCode.V,
    aimPart = "HumanoidRootPart",
    teamCheck = true,
    wallCheck = true,
    smoothness = 0.25,
    enemyPredictionEnabled = false,
    knockThreshold = 24,
    fovSize = 100,
    showFOV = false
}

FOVCircle = Drawing.new("Circle")
FOVCircle.Visible = false
FOVCircle.Thickness = 2
FOVCircle.Color = Color3.fromRGB(173, 216, 230)
FOVCircle.Transparency = 0.8
FOVCircle.Filled = false
FOVCircle.NumSides = 64
FOVCircle.Radius = _G.tabforaimbot.fovSize
FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

AimbotTab:AddSection({ Name = "Aimbot Control" })

AimbotTab:AddToggle({
    Name = "Aimbot",
    Default = false,
    Flag = "AimbotToggle",
    Callback = function(Value)
        _G.tabforaimbot.aimbotEnabled = Value
        FOVCircle.Visible = Value and _G.tabforaimbot.showFOV
    end
})

AimbotTab:AddDropdown({
    Name = "Aimbot Part",
    Options = { "Head", "HumanoidRootPart" },
    Default = "HumanoidRootPart",
    Flag = "AimPartDropdown",
    Callback = function(Value)
        _G.tabforaimbot.aimPart = Value
    end
})

if not isMobile then
    AimbotTab:AddBind({
        Name = "Aimbot Keybind",
        Default = Enum.KeyCode.V,
        Flag = "AimbotKeybind",
        Callback = function()
            _G.tabforaimbot.aimbotEnabled = not _G.tabforaimbot.aimbotEnabled
            FOVCircle.Visible = _G.tabforaimbot.aimbotEnabled and _G.tabforaimbot.showFOV
        end
    })
end

AimbotTab:AddSection({ Name = "Targeting" })

AimbotTab:AddSlider({
    Name = "Aimbot Strength",
    Min = 0.1, Max = 1, Default = 0.25, Increment = 0.01,
    ValueName = "Smoothness",
    Flag = "AimbotSmoothness",
    Callback = function(Value)
        _G.tabforaimbot.smoothness = Value
    end
})

AimbotTab:AddSection({ Name = "FOV Settings" })

AimbotTab:AddToggle({
    Name = "Show FOV Circle",
    Default = false,
    Flag = "ShowFOVToggle",
    Callback = function(Value)
        _G.tabforaimbot.showFOV = Value
        FOVCircle.Visible = Value and _G.tabforaimbot.aimbotEnabled
    end
})

AimbotTab:AddColorpicker({
    Name = "FOV Circle Color",
    Default = Color3.fromRGB(255, 255, 255),
    Flag = "ShowFOVColor",
    Callback = function(Color)
        _G.tabforaimbot.fovColor = Color
        FOVCircle.Color = Color
    end
})

AimbotTab:AddSlider({
    Name = "FOV Size",
    Min = 10, Max = 500, Default = 100, Increment = 5,
    ValueName = "Size",
    Flag = "FOVSize",
    Callback = function(Value)
        _G.tabforaimbot.fovSize = Value
        FOVCircle.Radius = Value
    end
})

AimbotTab:AddSection({ Name = "Checks" })

AimbotTab:AddToggle({
    Name = "Team Check", Default = true, Flag = "TeamCheckToggle",
    Callback = function(Value) _G.tabforaimbot.teamCheck = Value end
})

AimbotTab:AddToggle({
    Name = "Knocked Check", Default = true, Flag = "KnockedCheckToggle",
    Callback = function(Value) _G.tabforaimbot.knockedCheck = Value end
})

AimbotTab:AddToggle({
    Name = "Wall Check", Default = true, Flag = "WallCheckToggle",
    Callback = function(Value) _G.tabforaimbot.wallCheck = Value end
})

AimbotTab:AddSection({ Name = "Others" })

AimbotTab:AddToggle({
    Name = "Prediction", Default = false, Flag = "PredictionToggle",
    Callback = function(Value) _G.tabforaimbot.enemyPredictionEnabled = Value end
})

enabled = false

AimbotTab:AddToggle({
    Name = "Trigger Bot",
    Default = false,
    Callback = function(Value)
        enabled = Value
        if enabled then
            Hydrogen:MakeNotification({ Name = "Status", Content = "Trigger Bot is ON", Time = 3 })
        else
            Hydrogen:MakeNotification({ Name = "Status", Content = "Trigger Bot is OFF", Time = 3 })
        end
    end
})

RunService.RenderStepped:Connect(function()
    if enabled then
        local target = mouse.Target
        if target and target.Parent then
            local targetHum = target.Parent:FindFirstChild("Humanoid")
            if targetHum and target.Parent.Name ~= player.Name and targetHum.Health > 0 then
                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
                task.wait(0.1)
                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
            end
        end
    end
end)

function predictTarget(target, predictionTime)
    local targetPosition = target.Character[_G.tabforaimbot.aimPart].Position
    local targetVelocity = target.Character[_G.tabforaimbot.aimPart].Velocity
    return targetPosition + targetVelocity * predictionTime
end

function getClosestTarget()
    Camera = workspace.CurrentCamera
    local closestPlayer = nil
    local closestDistance = math.huge
    local localPlayer_ = game.Players.LocalPlayer
    local localTeam = localPlayer_.Team

    local function targetTeamCheck(p)
        if localTeam and p.Team then
            if localTeam.Name == "Citizen" then return p.Team.Name == "Police"
            elseif localTeam.Name == "Police" then return p.Team.Name == "Citizen" end
        end
        return true
    end

    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= localPlayer_ and p.Character and p.Character:FindFirstChild(_G.tabforaimbot.aimPart) then
            if _G.tabforaimbot.teamCheck and not targetTeamCheck(p) then continue end

            local hum = p.Character:FindFirstChildOfClass("Humanoid")
            if hum and _G.tabforaimbot.knockedCheck and hum.Health <= _G.tabforaimbot.knockThreshold then continue end

            if _G.tabforaimbot.wallCheck then
                local targetPart = p.Character[_G.tabforaimbot.aimPart]
                local rp = RaycastParams.new()
                rp.FilterType = Enum.RaycastFilterType.Exclude

                local ignoreList = { localPlayer_.Character, p.Character }
                if workspace:FindFirstChild("Vehicles") then table.insert(ignoreList, workspace.Vehicles) end
                if workspace:FindFirstChild("Cars") then table.insert(ignoreList, workspace.Cars) end

                if hum then
                    local seat = hum.SeatPart
                    if seat and seat:IsA("VehicleSeat") then
                        local vehModel = seat:FindFirstAncestorOfClass("Model")
                        if vehModel then table.insert(ignoreList, vehModel) end
                    end
                end

                rp.FilterDescendantsInstances = ignoreList
                local origin = Camera.CFrame.Position
                local direction = targetPart.Position - origin
                local result = workspace:Raycast(origin, direction, rp)
                if result then continue end
            end

            local targetPos = Camera:WorldToScreenPoint(p.Character[_G.tabforaimbot.aimPart].Position)
            local distance = (Vector2.new(targetPos.X, targetPos.Y) - Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)).Magnitude

            if distance <= _G.tabforaimbot.fovSize and distance < closestDistance then
                closestDistance = distance
                closestPlayer = p
            end
        end
    end

    return closestPlayer
end

RunService.RenderStepped:Connect(function()
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    FOVCircle.Radius = _G.tabforaimbot.fovSize
end)

RunService.RenderStepped:Connect(function()
    if not _G.tabforaimbot.aimbotEnabled then return end

    local aimActive
    if isMobile then
        aimActive = _G.MobileInput.AimHold or _G.tabforaimbot.mobileAimEnabled
    else
        aimActive = UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
    end

    if not aimActive then return end

    local target = getClosestTarget()
    if target and target.Character and target.Character:FindFirstChild(_G.tabforaimbot.aimPart) then
        Camera = workspace.CurrentCamera
        local targetPos = target.Character[_G.tabforaimbot.aimPart].Position

        if _G.tabforaimbot.enemyPredictionEnabled then
            targetPos = predictTarget(target, 0.2)
            local targetLookAt = (targetPos - Camera.CFrame.Position).Unit
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, Camera.CFrame.Position + targetLookAt)
        else
            local currentLookAt = Camera.CFrame.LookVector
            local targetLookAt = (targetPos - Camera.CFrame.Position).Unit
            local newLookAt = currentLookAt:Lerp(targetLookAt, _G.tabforaimbot.smoothness)
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, Camera.CFrame.Position + newLookAt)
        end
    end
end)

_G.silentAimSettings = _G.silentAimSettings or {
    SilentAim = false,
    Prediction = true,
    KnockedCheck = true,
    TeamCheck = false,
    WallCheck = true,
    Wallbang = true,
    Fov = false,
    FovSize = 80,
    FovColor = Color3.fromRGB(86, 124, 228),
    HitParts = { "HumanoidRootPart", "Head" },
    AutoShowFov = true,
    ShootSpeed = 0.08,
    BulletSpeed = 1000
}

_G.AimData = _G.AimData or {
    Cache = {
        ProjectileController = nil,
        SyncController = nil,
        LastTarget = nil,
        LastShot = 0,
        WeaponCheckTime = 0,
        CachedWeapon = nil
    },
    Service = {
        P = game:GetService("Players"),
        LP = game:GetService("Players").LocalPlayer,
        C = workspace.CurrentCamera,
        RS = game:GetService("RunService"),
        Rep = game:GetService("ReplicatedStorage"),
        Stats = game:GetService("Stats")
    }
}

_G.currentPing = _G.currentPing or 0.1

task.spawn(function()
    while task.wait(1) do
        local success, val = pcall(function()
            return _G.AimData.Service.Stats.Network.ServerStatsItem["Data Ping"]:GetValue() / 1000
        end)
        if success then _G.currentPing = val end
    end
end)

function ScanControllers()
    for _, obj in pairs(getgc(true)) do
        if type(obj) == "table" then
            if rawget(obj, "projectileIdCounter") then _G.AimData.Cache.ProjectileController = obj end
            if rawget(obj, "serverTick") then _G.AimData.Cache.SyncController = obj end
        end
    end
end
ScanControllers()

RemoteFolder = ReplicatedStorage:WaitForChild("2Wz")
RemoteSilentAim = RemoteFolder:WaitForChild("5acb020e-ac6e-4ef8-8c2c-a548efc1af68")

function getWeapon()
    local now = tick()
    if _G.AimData.Cache.CachedWeapon and (now - _G.AimData.Cache.WeaponCheckTime) < 0.5 then
        return _G.AimData.Cache.CachedWeapon
    end

    local char = _G.AimData.Service.LP.Character
    if not char then return "None" end

    local weapons = {"G36", "M4 Carbine", "M58B Shotgun", "MP5", "Glock 17", "Sniper", "AK47", "Desert Eagle"}
    for _, w in ipairs(weapons) do
        if char:FindFirstChild(w) then
            _G.AimData.Cache.CachedWeapon = w
            _G.AimData.Cache.WeaponCheckTime = now
            return w
        end
    end

    _G.AimData.Cache.CachedWeapon = "None"
    return "None"
end

function isKnocked(p)
    if not _G.silentAimSettings.KnockedCheck then return false end
    local char = p.Character
    if not char then return true end
    local hum = char:FindFirstChild("Humanoid")
    if not hum then return true end
    if hum.Health <= 5 then return true end
    if char:FindFirstChild("HumanoidRootPart") and char.HumanoidRootPart:GetAttribute("Knocked") then return true end
    return false
end

function getPredPos(part)
    if not part then return Vector3.zero end
    local pos = part.Position

    if _G.silentAimSettings.Prediction then
        local dist = (_G.AimData.Service.C.CFrame.Position - pos).Magnitude
        local vel = part.Velocity or part.AssemblyLinearVelocity or Vector3.zero
        local travelTime = dist / _G.silentAimSettings.BulletSpeed
        pos = pos + (vel * (_G.currentPing + travelTime))
    end

    return pos
end

function wallCheck(origin, target, ignoreChar)
    if _G.silentAimSettings.Wallbang then return true end
    if not _G.silentAimSettings.WallCheck then return true end

    local filterList = {}
    local lp = _G.AimData.Service.LP

    if lp.Character then table.insert(filterList, lp.Character) end
    if ignoreChar then table.insert(filterList, ignoreChar) end

    for _, name in ipairs({"Vehicles", "Cars", "VehicleSpawns", "Traffic"}) do
        local folder = workspace:FindFirstChild(name)
        if folder then table.insert(filterList, folder) end
    end

    local vehiclesFolder = workspace:FindFirstChild("Vehicles")
    if vehiclesFolder then
        local myCar = vehiclesFolder:FindFirstChild(lp.Name)
        if myCar then table.insert(filterList, myCar) end
    end

    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Blacklist
    params.FilterDescendantsInstances = filterList
    params.IgnoreWater = true
    params.RespectCanCollide = false

    local res = workspace:Raycast(origin, target - origin, params)
    if not res then return true end
    if ignoreChar and res.Instance and res.Instance:IsDescendantOf(ignoreChar) then return true end
    return false
end

local silentAimToggle = nil
local fovToggle = nil

SilentTab:AddSection({ Name = "Silent Aim Control" })

silentAimToggle = SilentTab:AddToggle({
    Name = "Silent Aim",
    Default = _G.silentAimSettings.SilentAim,
    Flag = "SilentAimToggle",
    Callback = function(v)
        _G.silentAimSettings.SilentAim = v
        if v and _G.silentAimSettings.AutoShowFov then
            _G.silentAimSettings.Fov = true
            if fovToggle then fovToggle:Set(true) end
        end
    end
})

SilentTab:AddDropdown({
    Name = "Hit Part",
    Options = {"Head", "HumanoidRootPart", "Torso", "Left Arm", "Right Arm"},
    Default = (_G.silentAimSettings.HitParts or {})[1],
    Flag = "SilentHitPart",
    Callback = function(v)
        _G.silentAimSettings.HitParts = {v}
    end
})

if not isMobile then
    SilentTab:AddBind({
        Name = "Silent Aim Keybind",
        Default = Enum.KeyCode.G,
        Callback = function()
            _G.silentAimSettings.SilentAim = not _G.silentAimSettings.SilentAim
            if silentAimToggle then silentAimToggle:Set(_G.silentAimSettings.SilentAim) end
        end
    })
end

SilentTab:AddSlider({
    Name = "Shoot Speed", Min = 0.01, Max = 0.5, Default = _G.silentAimSettings.ShootSpeed, Increment = 0.01,
    Flag = "SilentShootSpeed",
    Callback = function(v) _G.silentAimSettings.ShootSpeed = v end
})

SilentTab:AddSlider({
    Name = "Bullet Speed (Prediction)", Min = 500, Max = 5000, Default = _G.silentAimSettings.BulletSpeed, Increment = 50,
    Flag = "SilentBulletSpeed",
    Callback = function(v) _G.silentAimSettings.BulletSpeed = v end
})

SilentTab:AddSection({ Name = "FOV Settings" })

fovToggle = SilentTab:AddToggle({
    Name = "Show FOV Circle",
    Default = _G.silentAimSettings.Fov,
    Flag = "SilentFovToggle",
    Callback = function(v) _G.silentAimSettings.Fov = v end
})

SilentTab:AddColorpicker({
    Name = "FOV Color",
    Default = _G.silentAimSettings.FovColor,
    Flag = "SilentFovColor",
    Callback = function(v) _G.silentAimSettings.FovColor = v end
})

SilentTab:AddSlider({
    Name = "FOV Size", Min = 10, Max = 500, Default = _G.silentAimSettings.FovSize, Increment = 5,
    Flag = "SilentFovSize",
    Callback = function(v) _G.silentAimSettings.FovSize = v end
})

SilentTab:AddSection({ Name = "Target Checks" })

SilentTab:AddToggle({
    Name = "Knocked Check", Default = _G.silentAimSettings.KnockedCheck,
    Flag = "SilentKnockedCheck",
    Callback = function(v) _G.silentAimSettings.KnockedCheck = v end
})

SilentTab:AddToggle({
    Name = "Team Check", Default = _G.silentAimSettings.TeamCheck,
    Flag = "SilentTeamCheck",
    Callback = function(v) _G.silentAimSettings.TeamCheck = v end
})

SilentTab:AddToggle({
    Name = "Wall Check", Default = _G.silentAimSettings.WallCheck,
    Flag = "SilentWallCheck",
    Callback = function(v) _G.silentAimSettings.WallCheck = v end
})

SilentTab:AddToggle({
    Name = "Wallbang", Default = _G.silentAimSettings.Wallbang,
    Flag = "SilentWallbang",
    Callback = function(v) _G.silentAimSettings.Wallbang = v end
})

FC = Drawing.new("Circle")
FC.Filled = false
FC.Thickness = 2.5
FC.Visible = false

function FindTarget()
    bestDist = _G.silentAimSettings.FovSize
    target = nil
    center = Vector2.new(_G.AimData.Service.C.ViewportSize.X / 2, _G.AimData.Service.C.ViewportSize.Y / 2)

    for _, p in ipairs(_G.AimData.Service.P:GetPlayers()) do
        if p == _G.AimData.Service.LP or not p.Character then continue end
        if isKnocked(p) then continue end
        if _G.silentAimSettings.TeamCheck and p.Team == _G.AimData.Service.LP.Team then continue end

        for _, partName in ipairs(_G.silentAimSettings.HitParts) do
            local part = p.Character:FindFirstChild(partName)
            if part then
                local tPos = getPredPos(part)
                local sPos, onScreen = _G.AimData.Service.C:WorldToViewportPoint(tPos)

                if onScreen and sPos.Z > 0 then
                    local mag = (Vector2.new(sPos.X, sPos.Y) - center).Magnitude
                    if mag < bestDist then
                        local origin = _G.AimData.Service.C.CFrame.Position
                        local myChar = _G.AimData.Service.LP.Character
                        local myHead = myChar and myChar:FindFirstChild("Head")
                        if myHead then
                            local camCheckParams = RaycastParams.new()
                            camCheckParams.FilterType = Enum.RaycastFilterType.Blacklist
                            camCheckParams.FilterDescendantsInstances = { myChar }
                            local camHit = workspace:Raycast(origin, (tPos - origin).Unit * 1, camCheckParams)
                            if camHit then origin = myHead.Position end
                        end

                        if wallCheck(origin, tPos, p.Character) then
                            bestDist = mag
                            target = { p = p, part = part }
                        end
                    end
                end
            end
        end
    end
    return target
end

function DoFire(data)
    if not data or not data.part then return end

    local PC = _G.AimData.Cache.ProjectileController
    local SC = _G.AimData.Cache.SyncController
    local remote = RemoteSilentAim

    if not PC or not SC or not remote then
        ScanControllers()
        return
    end

    local weaponName = getWeapon()
    if weaponName == "None" then return end

    local weaponObj = _G.AimData.Service.LP.Character:FindFirstChild(weaponName)
    if not weaponObj then return end

    local tPos = getPredPos(data.part)
    local dir = (tPos - _G.AimData.Service.C.CFrame.Position).Unit

    pcall(function()
        _G.AimData.Cache.LastShot = tick()
        remote:FireServer(PC.projectileIdCounter, dir, true, SC:getServerTick())
        PC.projectileIdCounter = PC.projectileIdCounter + 1
    end)
end

_G.AimData.Service.RS.Heartbeat:Connect(function()
    if _G.silentAimSettings.Fov then
        FC.Visible = true
        FC.Position = Vector2.new(_G.AimData.Service.C.ViewportSize.X / 2, _G.AimData.Service.C.ViewportSize.Y / 2)
        FC.Radius = _G.silentAimSettings.FovSize
        FC.Color = _G.silentAimSettings.FovColor
    else
        FC.Visible = false
    end

    if _G.silentAimSettings.SilentAim then
        local target = FindTarget()
        if target then
            FC.Color = Color3.fromRGB(0, 255, 0)
            if (tick() - _G.AimData.Cache.LastShot) >= _G.silentAimSettings.ShootSpeed then
                DoFire(target)
            end
        else
            FC.Color = _G.silentAimSettings.FovColor
        end
    end
end)

GunModule = _G.GunModule or {}
_G.GunModule = GunModule

GunModule.UserConfig = GunModule.UserConfig or {}
if not GunModule.UserConfig.GunMods then
    GunModule.UserConfig.GunMods = {
        AutoReload = false, CrosshairSize = 10, RapidFire = false,
        NoRecoil = false, AimFOV = 70, SoundVolume = 100, GunSound = "Default"
    }
end

GunModule.GunSettings = GunModule.GunSettings or {
    AutoRefill = GunModule.UserConfig.GunMods.AutoReload or false,
    CrosshairSize = GunModule.UserConfig.GunMods.CrosshairSize or 10,
    RapidFire = GunModule.UserConfig.GunMods.RapidFire or false,
    NoRecoil = GunModule.UserConfig.GunMods.NoRecoil or false,
    AimFOV = GunModule.UserConfig.GunMods.AimFOV or 70,
    SoundVolume = GunModule.UserConfig.GunMods.SoundVolume or 100,
    OriginalValues = {},
    TrackedWeapons = { "G36", "Glock 17", "MP5", "M4 Carabine", "Sniper", "M58B Shotgun, Desert Eagle" }
}

GunModule.gunSoundOptions = GunModule.gunSoundOptions or {
    "Default", "Stab", "UwU", "Sniper", "Goofy UwU", "Bong", "Allah", "67", "Silenced", "Spiderman"
}

GunModule.gunSoundIds = GunModule.gunSoundIds or {
    ["Stab"]      = "rbxassetid://7628283135",
    ["UwU"]       = "rbxassetid://130572853112549",
    ["Sniper"]    = "rbxassetid://122180189312589",
    ["Goofy UwU"] = "rbxassetid://133219911426754",
    ["Bong"]      = "rbxassetid://126369856995827",
    ["Allah"]     = "rbxassetid://114353967173897",
    ["67"]        = "rbxassetid://137959261043235",
    ["P90"]       = "rbxassetid://87534588983395",
    ["Pixel"]     = "rbxassetid://7380537613",
    ["Undertale"] = "rbxassetid://438149153",
    ["Ak47"]      = "rbxassetid://5910000043",
    ["M1911"]     = "rbxassetid://1136243671",
    ["Glock"]     = "rbxassetid://6581933860",
    ["MP40"]      = "rbxassetid://103807799095792",
    ["Silenced"]  = "rbxassetid://9114729302",
    ["Spiderman"] = "rbxassetid://129079794434901"
}

GunModule.hitSoundOptions = {
    "Default", "Minecraft", "Metal", "Bing", "Pong", "Skeet",
    "Rust", "Pick", "Bubble", "Neverlose", "Bell", "Allah Akbar"
}

GunModule.hitSoundIds = {
    ["Minecraft"]   = "rbxassetid://40145223",
    ["Metal"]       = "rbxassetid://3748776946",
    ["Bing"]        = "rbxassetid://6607204501",
    ["Pong"]        = "rbxassetid://9117374232",
    ["Skeet"]       = "rbxassetid://5633695679",
    ["Rust"]        = "rbxassetid://1255040462",
    ["Pick"]        = "rbxassetid://1347140027",
    ["Bubble"]      = "rbxassetid://119697580657161",
    ["Neverlose"]   = "rbxassetid://6604811799",
    ["Bell"]        = "rbxassetid://124010691633262",
    ["Allah Akbar"] = "rbxassetid://114353967173897"
}

GunModule.origSounds = GunModule.origSounds or {}
GunModule.originalHitSounds = GunModule.originalHitSounds or {}
GunModule.normalHitSoundId = "rbxassetid://131237241"
GunModule.blockedSoundId = "rbxassetid://160432334"
GunModule.VirtualInputManager = game:GetService("VirtualInputManager")

function GunModule.ToRealVolume(val)
    if val <= 100 then return val / 100
    else return 1 + (val - 100) / 100 * 3 end
end

function GunModule.InitializeSounds()
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("Sound") then
            local id = v.SoundId
            if id == "rbxassetid://801226154" or id == "rbxassetid://801217802" then
                GunModule.origSounds[v] = id
                v.Volume = GunModule.ToRealVolume(GunModule.GunSettings.SoundVolume)
            end
            if id == GunModule.normalHitSoundId or id == GunModule.blockedSoundId then
                GunModule.originalHitSounds[v] = id
            end
        end
    end
end
GunModule.InitializeSounds()

function GunModule.ChangeShootSound(selectedSound)
    local newSoundId = GunModule.gunSoundIds[selectedSound]
    for s, originalId in pairs(GunModule.origSounds) do
        if s and s.Parent then
            if selectedSound == "Default" then s.SoundId = originalId
            elseif newSoundId then s.SoundId = newSoundId end
            s.Volume = GunModule.ToRealVolume(GunModule.GunSettings.SoundVolume)
        end
    end
end

function GunModule.ChangeHitSound(selectedSound)
    local newSoundId = GunModule.hitSoundIds[selectedSound]
    for s, originalId in pairs(GunModule.originalHitSounds) do
        if s and s.Parent then
            if selectedSound == "Default" then s.SoundId = originalId
            elseif newSoundId then s.SoundId = newSoundId end
        end
    end
end

function GunModule.SaveOriginalValues(tool)
    local toolName = tool.Name
    if not GunModule.GunSettings.OriginalValues[toolName] then
        GunModule.GunSettings.OriginalValues[toolName] = {
            Recoil = tool:GetAttribute("Recoil") or 1,
            Instability = tool:GetAttribute("Instability") or 1,
            ShootDelay = tool:GetAttribute("ShootDelay") or 0.1,
            Automatic = tool:GetAttribute("Automatic") or false,
            CrosshairSize = tool:GetAttribute("CrosshairSize") or 10,
            AimFieldOfView = tool:GetAttribute("AimFieldOfView") or 70
        }
    end
end

function GunModule.RestoreOriginalValues(tool, attribute)
    local toolName = tool.Name
    if GunModule.GunSettings.OriginalValues[toolName] and GunModule.GunSettings.OriginalValues[toolName][attribute] ~= nil then
        tool:SetAttribute(attribute, GunModule.GunSettings.OriginalValues[toolName][attribute])
    end
end

task.spawn(function()
    while true do
        pcall(function()
            local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
            if tool then
                GunModule.SaveOriginalValues(tool)
                if GunModule.GunSettings.NoRecoil then
                    tool:SetAttribute("Recoil", 0)
                    tool:SetAttribute("Instability", 0)
                else
                    GunModule.RestoreOriginalValues(tool, "Recoil")
                    GunModule.RestoreOriginalValues(tool, "Instability")
                end
                if GunModule.GunSettings.RapidFire then
                    tool:SetAttribute("ShootDelay", 0)
                    tool:SetAttribute("Automatic", true)
                else
                    GunModule.RestoreOriginalValues(tool, "ShootDelay")
                    GunModule.RestoreOriginalValues(tool, "Automatic")
                end
                tool:SetAttribute("CrosshairSize", GunModule.GunSettings.CrosshairSize)
            end
        end)
        task.wait(0.05)
    end
end)

task.spawn(function()
    while true do
        if GunModule.GunSettings.AutoRefill then
            pcall(function()
                local char = LocalPlayer.Character
                if char then
                    for _, weaponName in ipairs(GunModule.GunSettings.TrackedWeapons) do
                        local weapon = char:FindFirstChild(weaponName) or workspace:FindFirstChild(weaponName)
                        if weapon then
                            local magSize = weapon:GetAttribute("MagCurrentSize")
                                or weapon:GetAttribute("Ammo")
                                or weapon:GetAttribute("Clip")
                                or (weapon:FindFirstChild("Ammo") and weapon.Ammo.Value)
                            if magSize and magSize == 0 then
                                GunModule.VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.R, false, game)
                                task.wait(0.05)
                                GunModule.VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.R, false, game)
                                task.wait(1)
                            end
                        end
                    end
                end
            end)
        end
        task.wait(0.5)
    end
end)

task.spawn(function()
    while task.wait(0.05) do
        pcall(function()
            local char = LocalPlayer.Character
            if char then
                local Tool = char:FindFirstChildOfClass("Tool")
                if Tool then
                    GunModule.SaveOriginalValues(Tool)
                    Tool:SetAttribute("AimFieldOfView", GunModule.GunSettings.AimFOV)
                end
            end
        end)
    end
end)

if LocalPlayer.Character then
    LocalPlayer.Character.ChildAdded:Connect(function(child)
        if child:IsA("Tool") then
            task.wait(0.1)
            GunModule.SaveOriginalValues(child)
        end
    end)
end

LocalPlayer.CharacterAdded:Connect(function(char)
    char.ChildAdded:Connect(function(child)
        if child:IsA("Tool") then
            task.wait(0.1)
            GunModule.SaveOriginalValues(child)
        end
    end)
end)

GunModTab:AddSection({ Name = "Gun Mods" })

Settings = { Enabled = true, AimFOVThreshold = 70 }
S = { inAir = false, simulating = false, frozenFOV = nil }

function IsAirborne()
    local c = LP.Character
    local h = c and c:FindFirstChildOfClass("Humanoid")
    if not h then return false end
    local s = h:GetState()
    return s == Enum.HumanoidStateType.Jumping or s == Enum.HumanoidStateType.Freefall
end

function IsAiming(fov) return fov < Settings.AimFOVThreshold end

RunService.RenderStepped:Connect(function()
    if not Settings.Enabled then return end

    local fov = Cam.FieldOfView
    local airborne = IsAirborne()
    local aiming = IsAiming(fov)

    if airborne and not S.inAir then
        if aiming then
            S.frozenFOV = fov
            S.simulating = true
            mouse2press()
        end
    end

    if airborne and S.simulating then
        Cam.FieldOfView = S.frozenFOV
    end

    if not airborne and S.inAir then
        if S.simulating then
            S.simulating = false
            S.frozenFOV = nil
            task.delay(0.15, function()
                if not IsAiming(Cam.FieldOfView) then mouse2release() end
            end)
        end
    end

    S.inAir = airborne
end)

LP.CharacterAdded:Connect(function()
    task.wait(0.5)
    if S.simulating then pcall(mouse2release) end
    S.inAir = false
    S.simulating = false
    S.frozenFOV = nil
end)

LP.CharacterRemoving:Connect(function()
    if S.simulating then
        pcall(mouse2release)
        S.simulating = false
    end
end)

GunModTab:AddToggle({
    Name = "Jump Shoot", Default = false, Flag = "Enabled",
    Callback = function(v)
        Settings.Enabled = v
        if not v and S.simulating then
            pcall(mouse2release)
            S.simulating = false
            S.frozenFOV = nil
        end
    end,
})

noScopeConn = nil
cooldownConn = nil

GunModTab:AddToggle({
    Name = "OG Sniper", Default = false,
    Callback = function(Value)
        if Value then
            if noScopeConn then return end
            noScopeConn = RunService.Heartbeat:Connect(function()
                local char = localPlayer.Character
                if not char then return end
                local tool = char:FindFirstChild("Sniper")
                if tool then tool:SetAttribute("Scope", false) end
            end)
        else
            if noScopeConn then noScopeConn:Disconnect(); noScopeConn = nil end
        end
    end
})

GunModTab:AddToggle({
    Name = "Auto Reload", Default = GunModule.GunSettings.AutoRefill, Flag = "AutoReload",
    Callback = function(Value)
        GunModule.UserConfig.GunMods.AutoReload = Value
        GunModule.GunSettings.AutoRefill = Value
    end
})

GunModTab:AddToggle({
    Name = "Rapid Fire", Default = GunModule.GunSettings.RapidFire, Flag = "RapidFireToggle",
    Callback = function(Value)
        GunModule.UserConfig.GunMods.RapidFire = Value
        GunModule.GunSettings.RapidFire = Value
        if not Value then
            local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
            if tool then
                task.spawn(function()
                    for i = 1, 5 do
                        GunModule.RestoreOriginalValues(tool, "ShootDelay")
                        GunModule.RestoreOriginalValues(tool, "Automatic")
                        task.wait(0.1)
                    end
                end)
            end
        end
    end
})

GunModTab:AddToggle({
    Name = "No Recoil", Default = GunModule.GunSettings.NoRecoil, Flag = "NoRecoilToggle",
    Callback = function(Value)
        GunModule.UserConfig.GunMods.NoRecoil = Value
        GunModule.GunSettings.NoRecoil = Value
        if not Value then
            local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
            if tool then
                task.spawn(function()
                    for i = 1, 5 do
                        GunModule.RestoreOriginalValues(tool, "Recoil")
                        GunModule.RestoreOriginalValues(tool, "Instability")
                        task.wait(0.1)
                    end
                end)
            end
        end
    end
})

GunModTab:AddSection({ Name = "Custom Weapons Sound" })

GunModTab:AddDropdown({
    Name = "Shoot Sound", Default = GunModule.UserConfig.GunMods.GunSound,
    Flag = "ShootSound", Options = GunModule.gunSoundOptions,
    Callback = function(sel)
        GunModule.UserConfig.GunMods.GunSound = sel
        GunModule.ChangeShootSound(sel)
    end
})

GunModTab:AddDropdown({
    Name = "Hit Sound", Default = "Default", Flag = "HitSoundDropdown",
    Options = GunModule.hitSoundOptions,
    Callback = function(sel) GunModule.ChangeHitSound(sel) end
})

GunModTab:AddSlider({
    Name = "Shoot Sound Volume", Min = 0, Max = 200, Default = 100,
    Increment = 1, ValueName = "%",
    Flag = "ShootSoundVolume",
    Callback = function(Value)
        GunModule.UserConfig.GunMods.SoundVolume = Value
        GunModule.GunSettings.SoundVolume = Value
        local realVol = GunModule.ToRealVolume(Value)
        for s, _ in pairs(GunModule.origSounds) do
            if s and s.Parent then s.Volume = realVol end
        end
    end
})

GunModTab:AddSection({ Name = "Weapon Settings" })

GunModTab:AddSlider({
    Name = "Crosshair Size", Min = 1, Max = 30, Default = GunModule.GunSettings.CrosshairSize,
    Increment = 1, ValueName = "Size",
    Flag = "CrosshairSize",
    Callback = function(Value)
        GunModule.UserConfig.GunMods.CrosshairSize = Value
        GunModule.GunSettings.CrosshairSize = Value
    end
})

GunModTab:AddSlider({
    Name = "Aim FOV", Min = 40, Max = 120, Default = GunModule.GunSettings.AimFOV,
    Increment = 1, ValueName = "FOV",
    Callback = function(Value)
        GunModule.UserConfig.GunMods.AimFOV = Value
        GunModule.GunSettings.AimFOV = Value
    end
})

sniperCooldownValue = 0.5

GunModTab:AddSlider({
    Name = "OG Sniper Cooldown", Min = 0, Max = 3, Default = 0.5,
    Increment = 0.1, ValueName = "Seconds",
    Callback = function(Value)
        sniperCooldownValue = Value
        if not cooldownConn then
            cooldownConn = RunService.Heartbeat:Connect(function()
                local char = localPlayer.Character
                if not char then return end
                local tool = char:FindFirstChild("Sniper")
                if tool then tool:SetAttribute("ShootDelay", sniperCooldownValue) end
            end)
        end
    end
})

do
    carState = {
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
        for k in pairs(carState.fly) do carState.fly[k] = nil end
        carState.inSeat = false
        carState.veh = nil
        carState.seat = nil
    end

    CarModTab:AddSection({ Name = "Car Mod" })
    CarModTab:AddParagraph("Carfly Warning", "Dont fly into something or in the ground. You will get teleported back to your old position.")

    local carRecallToggle = nil

    local mobileCarGui = nil
    local mobileJoystickTouch = nil

    local function getSafeGuiParent()
        local ok1, hui = pcall(function() return gethui() end)
        if ok1 and hui then return hui end
        local ok2, cg = pcall(function() return game:GetService("CoreGui") end)
        if ok2 and cg then return cg end
        return LocalPlayer:WaitForChild("PlayerGui")
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

    local carFlyToggle = CarModTab:AddToggle({
        Name = "Car Fly", Default = false, Flag = "CarFlyEnabled",
        Callback = function(on)
            carState.active = on
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
        CarModTab:AddToggle({
            Name = "Mobile CarFly",
            Default = false,
            Flag = "MobileCarFlyToggle",
            Callback = function(on)
                if on then
                    carState.active = true
                    if carFlyToggle then carFlyToggle:Set(true) end
                    if carRecallToggle then carRecallToggle:Set(true) end
                    createMobileCarGui()
                else
                    carState.active = false
                    if carFlyToggle then carFlyToggle:Set(false) end
                    destroyMobileCarGui()
                    wipeFlyState()
                end
            end,
        })
    end

    if not isMobile then
        CarModTab:AddBind({
            Name = "Car Fly Keybind", Default = Enum.KeyCode.X,
            Flag = "CarFlyKeybind",
            Callback = function()
                local newState = not carState.active
                carState.active = newState
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
            end,
        })
    end

    CarModTab:AddSlider({
        Name = "Car Fly Speed", Min = 10, Max = 300, Default = 110,
        Increment = 1, ValueName = "Speed",
        Flag = "CarFlySpeed",
        Callback = function(v)
            carState.speed = v * carState.baseSpeed
        end,
    })

    recallState = { on = false, cooldown = 0, range = 10 }

    local function grabVehicle()
        local char = localPlayer.Character or localPlayer.CharacterAdded:Wait()
        local hrp_ = char:WaitForChild("HumanoidRootPart")
        local hum = char:FindFirstChildWhichIsA("Humanoid")
        local folder = workspace:FindFirstChild("Vehicles")
        local veh = folder and folder:FindFirstChild(localPlayer.Name)
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

    carRecallToggle = CarModTab:AddToggle({
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

            local char = localPlayer.Character
            if not char then continue end

            local hum = char:FindFirstChildWhichIsA("Humanoid")
            local hrp_ = char:FindFirstChild("HumanoidRootPart")
            if not (hum and hrp_) then continue end
            if hum.SeatPart then continue end
            if tick() < recallState.cooldown then continue end

            local folder = workspace:FindFirstChild("Vehicles")
            local veh = folder and folder:FindFirstChild(localPlayer.Name)
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

    cachedVeh = nil
    bodyParts = {}
    wheelNames = { FL = true, FR = true, RL = true, RR = true }

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

        if UserInputService:IsKeyDown(Enum.KeyCode.E) then up = 1
        elseif UserInputService:IsKeyDown(Enum.KeyCode.Q) then up = -1 end

        straight = fwd > 0.8 and math.abs(side) < 0.2 and up == 0

        return fwd, up, side, straight
    end

    RunService.RenderStepped:Connect(function()
        local char = localPlayer.Character
        if not char then return end

        if not carState.active then
            if carState.fly.lastPos or carState.fly.lastLook then wipeFlyState() end
            return
        end

        local hum = char:FindFirstChildOfClass("Humanoid")
        local folder = workspace:FindFirstChild("Vehicles")
        local veh = folder and folder:FindFirstChild(localPlayer.Name)
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
            carState.fly.lastLook = workspace.CurrentCamera.CFrame.LookVector
            return
        end

        veh.PrimaryPart = veh.PrimaryPart or drive
        local look = workspace.CurrentCamera.CFrame.LookVector
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

CarModTab:AddSection({ Name = "Car-Fling" })
do
    local on = false
    local force = 500

    local flingToggle = CarModTab:AddToggle({
        Name = "Car Fling (Use when Carfly is active)",
        Default = false, Flag = "FlingEnabled",
        Callback = function(state) on = state end,
    })

    if not isMobile then
        CarModTab:AddBind({
            Name = "Car Fling Keybind", Default = Enum.KeyCode.K,
            Flag = "FlingKeybind",
            Callback = function()
                on = not on
                flingToggle:Set(on)
            end,
        })
    end

    local rp = RaycastParams.new()
    rp.FilterType = Enum.RaycastFilterType.Blacklist

    RunService.Heartbeat:Connect(function()
        if not on then return end
        local char = localPlayer.Character
        if not char then return end
        local hrp_ = char:FindFirstChild("HumanoidRootPart")
        if not hrp_ then return end
        rp.FilterDescendantsInstances = { char }
        local hit = workspace:Raycast(hrp_.Position, hrp_.CFrame.LookVector * 3, rp)
        if hit then
            hrp_.AssemblyLinearVelocity = -hit.Normal * force
        end
    end)
end

CarModTab:AddSection({ Name = "Own Vehicle" })

function bringOwnCar()
    local char = localPlayer.Character or localPlayer.CharacterAdded:Wait()
    if not char then return end
    local hrp_ = char:WaitForChild("HumanoidRootPart", 5)
    if not hrp_ then return end
    local hum = char:FindFirstChildWhichIsA("Humanoid")
    if not hum then return end

    local folder = workspace:FindFirstChild("Vehicles")
    if not folder then return end

    local veh = folder:FindFirstChild(localPlayer.Name)
    if not (veh and veh:IsA("Model")) then
        if Hydrogen and Hydrogen.MakeNotification then
            Hydrogen:MakeNotification({ Name = "Error", Content = "Could not find your vehicle.", Time = 4 })
        end
        return
    end

    local drive = veh:FindFirstChild("DriveSeat") or veh:FindFirstChildWhichIsA("VehicleSeat")
    if not drive then return end
    if not veh.PrimaryPart then veh.PrimaryPart = drive end

    veh:SetPrimaryPartCFrame(hrp_.CFrame * CFrame.new(0, 3, -8))
    task.wait(0.2)
    if hum and not hum.SeatPart then drive:Sit(hum) end
end

function enterOwnCar()
    local char = localPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildWhichIsA("Humanoid")
    local hrp_ = char:FindFirstChild("HumanoidRootPart")
    if not (hum and hrp_) then return end
    if hum.SeatPart then return end

    local folder = workspace:FindFirstChild("Vehicles")
    if not folder then return end

    local veh = folder:FindFirstChild(localPlayer.Name)
    if not (veh and veh:IsA("Model")) then return end

    local drive = veh:FindFirstChild("DriveSeat") or veh:FindFirstChildWhichIsA("VehicleSeat")
    if not drive then return end
    if not veh.PrimaryPart then veh.PrimaryPart = drive end

    local dist = (veh.PrimaryPart.Position - hrp_.Position).Magnitude
    if dist <= 15 then
        drive:Sit(hum)
    else
        if Hydrogen and Hydrogen.MakeNotification then
            Hydrogen:MakeNotification({
                Name = "Car too far away",
                Content = "Your vehicle is " .. math.floor(dist) .. " studs away. Use 'Bring Own Car'.",
                Time = 4
            })
        end
    end
end

CarModTab:AddButton({
    Name = "Enter in Car",
    Callback = function() enterOwnCar() end
})

CarModTab:AddButton({
    Name = "Bring Own Car",
    Callback = function() bringOwnCar() end
})

do
    local getAccelerationMultiplier = nil
    local getSurfaceModifier = nil

    CarModTab:AddToggle({
        Name = "SUV Mode", Default = false, Flag = "suvMode",
        Callback = function(enabled)
            local vehicleDrive = game:GetService("Players").LocalPlayer.PlayerScripts.Code.components.vehicle:FindFirstChild("vehicleDrive")
            if not vehicleDrive then return end
            local module = nil
            pcall(function() module = require(vehicleDrive) end)
            if not module or not module.VehicleDrive then return end
            local vdm = module.VehicleDrive

            if enabled then
                getAccelerationMultiplier = getAccelerationMultiplier or vdm.getAccelerationMultiplier
                getSurfaceModifier = getSurfaceModifier or vdm.getSurfaceModifier
                vdm.getAccelerationMultiplier = function() return 1 end
                vdm.getSurfaceModifier = function() return 0 end
            else
                if getAccelerationMultiplier then vdm.getAccelerationMultiplier = getAccelerationMultiplier end
                if getSurfaceModifier then vdm.getSurfaceModifier = getSurfaceModifier end
            end
        end,
    })
end

local Sounds = {
    ["Goofy Car Horn"]  = "rbxassetid://137100035389921",
    ["Scania Bus Horn"] = "rbxassetid://125488657993933",
    ["Allah"]           = "rbxassetid://114353967173897",
    ["Standard"]        = "rbxassetid://143133249"
}

originalSoundId   = "rbxassetid://143133249"
currentSoundId    = originalSoundId
customHornEnabled = false
selectedHorn      = "Standard"
appliedHornIds    = setmetatable({}, {__mode = "k"})

CarModTab:AddToggle({
    Name = "Custom Horn Sound",
    Default = false,
    Flag = "CustomHornToggle",
    Callback = function(state)
        customHornEnabled = state
        if state then
            currentSoundId = Sounds[selectedHorn] or originalSoundId
        else
            currentSoundId = originalSoundId
            for obj in pairs(appliedHornIds) do
                if obj and obj.Parent then obj.SoundId = originalSoundId end
                appliedHornIds[obj] = nil
            end
        end
    end
})

CarModTab:AddDropdown({
    Name = "Horn Sound",
    Options = {"Goofy Car Horn", "Scania Bus Horn", "Allah", "Standard"},
    Default = "Standard",
    Flag = "CustomHornDropdown",
    Callback = function(Value)
        selectedHorn = Value
        if customHornEnabled then
            currentSoundId = Sounds[Value] or originalSoundId
            for obj in pairs(appliedHornIds) do appliedHornIds[obj] = nil end
        end
    end
})

RunService.Heartbeat:Connect(function()
    if not customHornEnabled then return end
    local char = player.Character
    if not char then return end
    local hum  = char:FindFirstChildOfClass("Humanoid")
    local seat = hum and hum.SeatPart
    if not seat or seat.Name ~= "DriveSeat" then return end
    for _, obj in pairs(seat:GetChildren()) do
        if obj:IsA("Sound") and not obj.Looped then
            if appliedHornIds[obj] ~= currentSoundId then
                obj.SoundId = currentSoundId
                appliedHornIds[obj] = currentSoundId
            end
        end
    end
end)

getgenv().InventoryProducer = getgenv().InventoryProducer or nil

function getProducer()
    if getgenv().InventoryProducer then return getgenv().InventoryProducer end
    for _, obj in pairs(getgc(true)) do
        if type(obj) == "table" and type(rawget(obj, "showInventory")) == "function" then
            getgenv().InventoryProducer = obj
            return obj
        end
    end
    return nil
end

CarModTab:AddSection({ Name = "Vehicle Modification" })

CarModTab:AddToggle({
    Name = "Inf Fuel & Anti Break",
    Default = false,
    Callback = function(state)
        local function findVehicleInWorkspace(playerName)
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA("Model") and obj.Name:match(playerName) then return obj end
            end
            return nil
        end

        if state then
            local vehicle = workspace.Vehicles:FindFirstChild(player.Name) or findVehicleInWorkspace(player.Name)
            if vehicle and vehicle:IsA("Model") then
                CarModsSettings.fuelToggle = true
                task.spawn(function()
                    while CarModsSettings.fuelToggle do
                        local cur = workspace.Vehicles:FindFirstChild(player.Name) or findVehicleInWorkspace(player.Name)
                        if cur then
                            cur:SetAttribute("currentHealth", 1000)
                            cur:SetAttribute("IsOn", true)
                            local fv = cur:FindFirstChild("currentFuel")
                            if fv and fv:IsA("NumberValue") then fv.Value = 9999999
                            else cur:SetAttribute("currentFuel", 9999999) end
                        end
                        task.wait(0.1)
                    end
                end)
            else
                Hydrogen:MakeNotification({
                    Name = "Error",
                    Content = "Could not find your vehicle.",
                    Time = 6.5
                })
            end
        else
            CarModsSettings.fuelToggle = false
        end
    end
})

AntiDecelConnection = nil
CarModTab:AddToggle({
    Name = "Anti Vehicle Deceleration",
    Default = false, Flag = "AntiDecelerationToggle",
    Callback = function(Value)
        if Value then
            local function findVehicleInWorkspace(playerName)
                for _, obj in ipairs(workspace:GetDescendants()) do
                    if obj:IsA("Model") and obj.Name:match(playerName) then return obj end
                end
                return nil
            end

            local vehicle = workspace.Vehicles:FindFirstChild(player.Name) or findVehicleInWorkspace(player.Name)
            if not vehicle then return end

            AntiDecelConnection = RunService.RenderStepped:Connect(function()
                local cur = workspace.Vehicles:FindFirstChild(player.Name) or findVehicleInWorkspace(player.Name)
                if cur then
                    cur:SetAttribute("flatTires", "nil")
                    local Wheels = cur:FindFirstChild("Wheels")
                    if not Wheels then
                        for _, part in ipairs(cur:GetDescendants()) do
                            if part.Name:lower():find("wheel") or part.Name:lower():find("rad") then
                                if part:IsA("BasePart") or part:IsA("MeshPart") then
                                    part:SetAttribute("SurfaceMaterial", "Asphalt")
                                end
                            end
                        end
                    else
                        for _, Wheel in ipairs(Wheels:GetChildren()) do
                            if Wheel:IsA("BasePart") or Wheel:IsA("MeshPart") then
                                Wheel:SetAttribute("SurfaceMaterial", "Asphalt")
                            end
                        end
                    end
                end
            end)
        else
            if AntiDecelConnection then AntiDecelConnection:Disconnect(); AntiDecelConnection = nil end
        end
    end
})

CarModTab:AddToggle({
    Name = "Drift Boost", Default = false, Flag = "DriftBoostToggle",
    Callback = function(Value)
        local Roads = workspace:FindFirstChild("Roads")
        local AdditionalRoads = Roads and Roads:FindFirstChild("Additional") and Roads.Additional:FindFirstChild("Roads")

        local function ApplyMaterial(container, material)
            for _, Part in pairs(container:GetDescendants()) do
                if Part:IsA("BasePart") then
                    if material then
                        if not Part:GetAttribute("OriginalMaterial") then
                            Part:SetAttribute("OriginalMaterial", Part.Material.Name)
                        end
                        if not Part:GetAttribute("OriginalColor") then
                            Part:SetAttribute("OriginalColor", Part.Color)
                        end
                        Part.Material = material
                        Part.Color = Part:GetAttribute("OriginalColor")
                    else
                        local OrigMat = Part:GetAttribute("OriginalMaterial")
                        if OrigMat and Enum.Material[OrigMat] then Part.Material = Enum.Material[OrigMat] end
                        local OrigColor = Part:GetAttribute("OriginalColor")
                        if OrigColor then Part.Color = OrigColor end
                    end
                end
            end
        end

        if Value then
            if Roads then ApplyMaterial(Roads, Enum.Material.Ice) end
            if AdditionalRoads then ApplyMaterial(AdditionalRoads, Enum.Material.Ice) end
        else
            if Roads then ApplyMaterial(Roads, nil) end
            if AdditionalRoads then ApplyMaterial(AdditionalRoads, nil) end
        end
    end
})

CarModTab:AddToggle({
    Name = "Anti Crash Damage", Default = false, Flag = "AntiCrashDamageToggle",
    Callback = function(enabled)
        local vf = workspace:FindFirstChild("Vehicles")
        if not vf then return end
        local veh = vf:FindFirstChild(player.Name)
        if not veh then return end
        veh:SetAttribute("IsBeingTowed", enabled)
    end
})

CarModTab:AddToggle({
    Name = "Grip Boost", Default = false, Flag = "GripBoostToggle",
    Callback = function(Value)
        if not getgenv().GripBoost then
            getgenv().GripBoost = { configured = false, originalValues = {}, configTable = nil }
        end

        local config = getgenv().GripBoost

        if not config.configured then
            local carSteeringScript = game.Players.LocalPlayer.PlayerScripts.Code.components.vehicle:FindFirstChild("carSteering")
            if carSteeringScript then
                local mod
                pcall(function() mod = require(carSteeringScript) end)
                local CS = mod and mod.CarSteering or mod
                if CS and CS.handleSteering then
                    for i = 1, 100 do
                        local success, value = pcall(debug.getupvalue, CS.handleSteering, i)
                        if success and type(value) == "table" and value.maxSteeringAngle and value.steeringModifierSpeed then
                            config.configTable = value
                            config.originalValues = {
                                maxSteeringAngle = value.maxSteeringAngle,
                                steeringModifierSpeed = value.steeringModifierSpeed,
                                steeringSpeed = value.steeringSpeed,
                                steerBackMultiplier = value.steerBackMultiplier,
                                minSteer = value.minSteer
                            }
                            config.configured = true
                            break
                        end
                        if not success then break end
                    end
                end
            end
        end

        if config.configured and config.configTable then
            if Value then
                config.configTable.maxSteeringAngle = 15
                config.configTable.steeringModifierSpeed = 20
                config.configTable.steeringSpeed = 4
                config.configTable.steerBackMultiplier = 2
                config.configTable.minSteer = 0.07
            else
                config.configTable.maxSteeringAngle = config.originalValues.maxSteeringAngle or 8
                config.configTable.steeringModifierSpeed = config.originalValues.steeringModifierSpeed or 35
                config.configTable.steeringSpeed = config.originalValues.steeringSpeed or 1.5
                config.configTable.steerBackMultiplier = config.originalValues.steerBackMultiplier or 3
                config.configTable.minSteer = config.originalValues.minSteer or 0.15
            end
        end
    end
})

CarModTab:AddSection({ Name = "Acceleration" })

accelStrength = 2
boostConn = nil

CarModTab:AddSlider({
    Name = "Acceleration Strength", Min = 1, Max = 5, Default = 2, Increment = 0.1,
    Callback = function(value) accelStrength = value end
})

CarModTab:AddToggle({
    Name = "Acceleration Boost", Default = false,
    Callback = function(state)
        if boostConn then boostConn:Disconnect(); boostConn = nil end

        if state then
            boostConn = RunService.Heartbeat:Connect(function()
                local char = game.Players.LocalPlayer.Character
                if not char then return end
                local hum = char:FindFirstChildOfClass("Humanoid")
                if not hum then return end
                local seat = hum.SeatPart
                if not seat or seat.Name ~= "DriveSeat" then return end

                local veh = workspace.Vehicles:FindFirstChild(player.Name)
                if not veh then return end
                local rootPart = veh:FindFirstChild("VehicleBody") or veh:FindFirstChildWhichIsA("BasePart")
                if not rootPart then return end

                local lookVec = rootPart.CFrame.LookVector
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                    rootPart.AssemblyLinearVelocity = rootPart.AssemblyLinearVelocity + lookVec * accelStrength
                elseif UserInputService:IsKeyDown(Enum.KeyCode.S) then
                    rootPart.AssemblyLinearVelocity = rootPart.AssemblyLinearVelocity + (-lookVec) * accelStrength
                end
            end)
        end
    end
})

VehicleMods = {
    jumpPower = 90, jumpForwardBoost = 0, jumpKey = Enum.KeyCode.F3,
    boostPower = 1000, boostKey = Enum.KeyCode.F1,
}

function JumpVehicle()
    local vf = workspace:FindFirstChild("Vehicles")
    if not vf then return end
    local veh = vf:FindFirstChild(player.Name)
    if not veh or not veh:IsA("Model") then return end
    local seat = veh:FindFirstChild("DriveSeat") or veh:FindFirstChildWhichIsA("VehicleSeat")
    if not seat then return end
    if not veh.PrimaryPart then veh.PrimaryPart = seat end

    local body = veh.PrimaryPart
    local dir = (body.CFrame.LookVector * VehicleMods.jumpForwardBoost + Vector3.new(0, 1.4, 0)).Unit
    body.AssemblyLinearVelocity = dir * VehicleMods.jumpPower
    body.AssemblyAngularVelocity = Vector3.zero
end

function BoostVehicle()
    local vf = workspace:FindFirstChild("Vehicles")
    if not vf then return end
    local veh = vf:FindFirstChild(player.Name)
    if not veh or not veh:IsA("Model") then return end
    local seat = veh:FindFirstChild("DriveSeat") or veh:FindFirstChildWhichIsA("VehicleSeat")
    if not seat then return end
    if not veh.PrimaryPart then veh.PrimaryPart = seat end

    local body = veh.PrimaryPart
    body.AssemblyLinearVelocity = body.CFrame.LookVector.Unit * VehicleMods.boostPower
    body.AssemblyAngularVelocity = Vector3.zero
end

CarModTab:AddSection({ Name = "Boost Mods" })

CarModTab:AddSlider({
    Name = "Boost Power", Min = 100, Max = 500, Default = 100,
    Flag = "VehicleBoostPower", Increment = 50, ValueName = "Power",
    Callback = function(value) VehicleMods.boostPower = value end
})

if not isMobile then
    CarModTab:AddBind({
        Name = "Instant Boost Keybind", Default = Enum.KeyCode.F1,
        Flag = "VehicleBoostKeybind",
        Callback = function(key) VehicleMods.boostKey = key; BoostVehicle() end
    })
end

CarModTab:AddButton({ Name = "Instant Boost", Callback = BoostVehicle })

CarModTab:AddSection({ Name = "Vehicle Jumping" })

CarModTab:AddSlider({
    Name = "Jump Power", Min = 50, Max = 300, Default = 90, Increment = 10,
    Flag = "VehicleJumpPower", ValueName = "Power",
    Callback = function(value) VehicleMods.jumpPower = value end
})

CarModTab:AddSlider({
    Name = "Jump Forward Boost", Min = 0, Max = 5, Default = 0, Increment = 0.1,
    Flag = "VehicleJumpForwardBoost", ValueName = "Boost",
    Callback = function(value) VehicleMods.jumpForwardBoost = value end
})

if not isMobile then
    CarModTab:AddBind({
        Name = "Jump Keybind", Default = Enum.KeyCode.F3, Flag = "VehicleJumpKeybind",
        Callback = function(key) VehicleMods.jumpKey = key; JumpVehicle() end
    })
end

CarModTab:AddButton({ Name = "Jump Vehicle", Callback = JumpVehicle })

CarModTab:AddSection({ Name = "Tuning Modification" })

function updateVehicleAttribute(attribute, value)
    local vf = workspace:FindFirstChild("Vehicles")
    if not vf then return end
    local veh = vf:FindFirstChild(player.Name)
    if veh then veh:SetAttribute(attribute, value) end
end

CarModTab:AddSlider({ Name = "Armor", Min = 0, Max = 6, Default = 0, Increment = 1, ValueName = "Level", Flag = "ArmorSlider",
    Callback = function(Value) updateVehicleAttribute("armorLevel", Value) end })
CarModTab:AddSlider({ Name = "Brakes", Min = 0, Max = 6, Default = 0, Increment = 1, ValueName = "Level", Flag = "BrakesSlider",
    Callback = function(Value) updateVehicleAttribute("brakesLevel", Value) end })
CarModTab:AddSlider({ Name = "Engine", Min = 0, Max = 6, Default = 0, Increment = 1, ValueName = "Level", Flag = "EngineSlider",
    Callback = function(Value) updateVehicleAttribute("engineLevel", Value) end })

CarModTab:AddSection({ Name = "Colour Modification" })

WHEEL_NAMES = { "FL", "FR", "RL", "RR" }
EFFECT_NAME = "0974d760-7c65-4ad2-a7dc-6529757cf85b"

function getWheelParticles()
    local emitters = {}
    local vehicles = workspace:FindFirstChild("Vehicles")
    if not vehicles then return emitters end
    local vehicle = vehicles:FindFirstChild(LocalPlayer.Name)
    if not vehicle then return emitters end
    local body = vehicle:FindFirstChild("Body")
    if not body then return emitters end
    local wheels = body:FindFirstChild("Wheels")
    if not wheels then return emitters end

    for _, wn in ipairs(WHEEL_NAMES) do
        local wheel = wheels:FindFirstChild(wn)
        if wheel then
            for _, v in ipairs(wheel:GetDescendants()) do
                if v:IsA("ParticleEmitter") and v.Name == EFFECT_NAME then
                    v.Enabled = true
                    table.insert(emitters, v)
                end
            end
        end
    end
    return emitters
end

CarModTab:AddColorpicker({
    Name = "Wheel Particle Color",
    Default = Color3.fromRGB(255, 255, 255),
    Callback = function(color)
        for _, e in ipairs(getWheelParticles()) do
            e.Color = ColorSequence.new(color)
        end
    end
})

function getCurrentRimColor()
    local vf = workspace:FindFirstChild("Vehicles")
    if not vf then return Color3.fromRGB(255, 255, 255) end
    local pv = vf:FindFirstChild(player.Name)
    if not pv then return Color3.fromRGB(255, 255, 255) end
    for _, obj in pairs(pv:GetDescendants()) do
        if obj.Name == "FL" or obj.Name == "FR" or obj.Name == "RL" or obj.Name == "RR" then
            local rim = obj:FindFirstChild("Rim")
            if rim then
                local main = rim:FindFirstChild("Main")
                if main and main:IsA("BasePart") then return main.Color end
            end
        end
    end
    return Color3.fromRGB(255, 255, 255)
end

function getCurrentCarColor()
    local vf = workspace:FindFirstChild("Vehicles")
    if not vf then return Color3.fromRGB(255, 255, 255) end
    local pv = vf:FindFirstChild(player.Name)
    if not pv then return Color3.fromRGB(255, 255, 255) end
    for _, obj in pairs(pv:GetDescendants()) do
        if obj.Name == "Body" and obj:IsA("BasePart") then return obj.Color end
    end
    return Color3.fromRGB(255, 255, 255)
end

CarModTab:AddColorpicker({
    Name = "Wheel Color", Default = getCurrentRimColor(), Flag = "WheelColor",
    Callback = function(color)
        local vf = workspace:FindFirstChild("Vehicles")
        if not vf then return end
        local pv = vf:FindFirstChild(player.Name)
        if not pv then return end
        for _, obj in pairs(pv:GetDescendants()) do
            if obj.Name == "FL" or obj.Name == "FR" or obj.Name == "RL" or obj.Name == "RR" then
                local rim = obj:FindFirstChild("Rim")
                if rim then
                    local main = rim:FindFirstChild("Main")
                    if main and main:IsA("BasePart") then main.Color = color end
                end
            end
        end
    end
})

CarModTab:AddColorpicker({
    Name = "Body Color", Default = getCurrentCarColor(), Flag = "BodyColor",
    Callback = function(color)
        local vf = workspace:FindFirstChild("Vehicles")
        if not vf then return end
        local pv = vf:FindFirstChild(player.Name)
        if not pv then return end
        for _, obj in pairs(pv:GetDescendants()) do
            if obj.Name == "Body" and obj:IsA("BasePart") then obj.Color = color end
        end
    end
})

CarModTab:AddColorpicker({
    Name = "Headlight Color", Default = Color3.fromRGB(255, 255, 255), Flag = "HeadlightColor",
    Callback = function(Color)
        local vf = workspace:FindFirstChild("Vehicles")
        if not vf then return end
        local veh = vf:FindFirstChild(player.Name)
        if veh and veh:IsA("Model") then
            local Body = veh:FindFirstChild("Body")
            if Body then
                local Headlights = Body:FindFirstChild("Headlights")
                if Headlights then
                    for _, Light in ipairs(Headlights:GetDescendants()) do
                        if Light:IsA("SpotLight") then Light.Color = Color end
                    end
                end
            end
        end
    end
})

CarModTab:AddSection({ Name = "Troll Options" })

local opts = {"Default","V6 Engine","V8 Engine","V10 Engine","Electric Engine","Electric Engine 2","Funny Electric Engine","Mercedes AMG One Engine","Roblox Engine"}
local ids = {
    ["Default"]                  = {e = "rbxassetid://140685060", d = "rbxassetid://358130654", s = "rbxassetid://144126324"},
    ["V6 Engine"]                = {e = "rbxassetid://113404171295712", d = "rbxassetid://2057815938", s = "rbxassetid://96066650287312"},
    ["V8 Engine"]                = {e = "rbxassetid://7427073034", d = "rbxassetid://8144394164", s = "rbxassetid://96066650287312"},
    ["V10 Engine"]               = {e = "rbxassetid://976645312", d = "rbxassetid://8144394631", s = "rbxassetid://96066650287312"},
    ["Electric Engine"]          = {e = "rbxassetid://402899121", d = "rbxassetid://1160914875", s = "rbxassetid://268260239"},
    ["Electric Engine 2"]        = {e = "rbxassetid://402899121", d = "rbxassetid://9070018398", s = "rbxassetid://268260239"},
    ["Funny Electric Engine"]    = {e = "rbxassetid://402899121", d = "rbxassetid://139592319059397", s = "rbxassetid://268260239"},
    ["Mercedes AMG One Engine"]  = {e = "rbxassetid://402899121", d = "rbxassetid://101796349615590", s = "rbxassetid://268260239"},
    ["Roblox Engine"]            = {e = "rbxassetid://140685060", d = "rbxassetid://6948077542", s = "rbxassetid://144126324"}
}

orig = {e={}, d={}, s={}}
appliedEngine = setmetatable({}, {__mode = "k"})
appliedDrive  = setmetatable({}, {__mode = "k"})
appliedStop   = setmetatable({}, {__mode = "k"})

for _, v in pairs(game:GetDescendants()) do
    if v:IsA("Sound") then
        local id = v.SoundId
        if id:match("140685060") then orig.e[v] = id
        elseif id:match("358130654") then orig.d[v] = id
        elseif id:match("144126324") then orig.s[v] = id
        else
            for _, data in pairs(ids) do
                if id:match(data.e:match("%d+")) then orig.e[v] = orig.e[v] or "rbxassetid://140685060" end
                if id:match(data.d:match("%d+")) then orig.d[v] = orig.d[v] or "rbxassetid://358130654" end
                if id:match(data.s:match("%d+")) then orig.s[v] = orig.s[v] or "rbxassetid://144126324" end
            end
        end
    end
end

game.DescendantAdded:Connect(function(v)
    if v:IsA("Sound") then
        local id = v.SoundId
        if id:match("140685060") then orig.e[v] = id
        elseif id:match("358130654") then orig.d[v] = id
        elseif id:match("144126324") then orig.s[v] = id
        else
            for _, data in pairs(ids) do
                if id:match(data.e:match("%d+")) then orig.e[v] = orig.e[v] or "rbxassetid://140685060" end
                if id:match(data.d:match("%d+")) then orig.d[v] = orig.d[v] or "rbxassetid://358130654" end
                if id:match(data.s:match("%d+")) then orig.s[v] = orig.s[v] or "rbxassetid://144126324" end
            end
        end
    end
end)

engineEnabled = false
engineSelected = "V6 Engine"

function applyEngine(sel)
    local data = ids[sel] or ids["Default"]
    for snd in pairs(orig.e) do
        if snd and snd.Parent and appliedEngine[snd] ~= data.e then
            snd.SoundId = data.e; appliedEngine[snd] = data.e
        end
    end
    for snd in pairs(orig.d) do
        if snd and snd.Parent and appliedDrive[snd] ~= data.d then
            snd.SoundId = data.d; appliedDrive[snd] = data.d
        end
    end
    for snd in pairs(orig.s) do
        if snd and snd.Parent and appliedStop[snd] ~= data.s then
            snd.SoundId = data.s; appliedStop[snd] = data.s
        end
    end
end

function resetEngine()
    for snd, oid in pairs(orig.e) do
        if snd and snd.Parent and appliedEngine[snd] ~= oid then
            snd.SoundId = oid; appliedEngine[snd] = oid
        end
    end
    for snd, oid in pairs(orig.d) do
        if snd and snd.Parent and appliedDrive[snd] ~= oid then
            snd.SoundId = oid; appliedDrive[snd] = oid
        end
    end
    for snd, oid in pairs(orig.s) do
        if snd and snd.Parent and appliedStop[snd] ~= oid then
            snd.SoundId = oid; appliedStop[snd] = oid
        end
    end
end

CarModTab:AddToggle({
    Name = "Engine Sound",
    Default = false,
    Flag = "EngineSoundToggle",
    Callback = function(state)
        engineEnabled = state
        if state then applyEngine(engineSelected) else resetEngine() end
    end
})

CarModTab:AddDropdown({
    Name = "Engine Sound Type",
    Options = opts,
    Default = "V6 Engine",
    Flag = "EngineSoundDropdown",
    Callback = function(sel)
        engineSelected = sel
        if engineEnabled then applyEngine(sel) end
    end
})

CarModTab:AddTextbox({
    Name = "Numberplate-Text",
    Placeholder = "Flux",
    Flag = "NumberplateText",
    Callback = function(txt, enterPressed)
        local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if not root then return end
        for _, part in ipairs(workspace:GetDescendants()) do
            if part:IsA("SurfaceGui") and part.Parent:IsA("BasePart") then
                local dist = (part.Parent.Position - root.Position).Magnitude
                if dist < 200 then
                    local label = part:FindFirstChildWhichIsA("TextLabel")
                    if label then label.Text = txt end
                end
            end
        end
    end
})

_G.ESPConfig = {
    Settings = {
        MaxDistance = 1000,
        TextSize = 11,
        CurrentFont = Enum.Font.SourceSansBold,
        ArrowRadius = 250,
        ArrowSize = 35
    },
    HitSettings = {
        Color = Color3.fromRGB(0, 162, 255),
        Font = Enum.Font.FredokaOne,
        TextSize = 28,
        Duration = 1.0
    },
    FontOptions = {
        Pixel = Enum.Font.Code,
        Minecraft = Enum.Font.SourceSansBold,
        Fortnite = Enum.Font.FredokaOne,
        Roblox = Enum.Font.GothamBold,
        Neon = Enum.Font.Highway
    },
    PlayerToggles = {
        NameESP = false,
        NameESPMode = "Only Name",
        StudsESP = false,
        TeamESP = false,
        WantedESP = false,
        AdminESP = false,
        Tracers = false,
        Chams = false,
        HitEffects = true,
        ArrowESP = true
    },
    VehicleToggles = {
        Outline = false, Owner = false, HP = false,
        Fuel = false, Plate = false, Status = false
    },
    FactionColors = {
        ["Police"]  = Color3.fromRGB(0, 120, 255),
        ["Medic"]   = Color3.fromRGB(255, 50, 50),
        ["HARS"]    = Color3.fromRGB(255, 165, 0),
        ["Citizen"] = Color3.fromRGB(180, 180, 180),
        ["Wanted"]  = Color3.fromRGB(255, 215, 0)
    }
}

vehicleCache     = vehicleCache or {}
healthTrackers   = healthTrackers or {}
cachedDistances  = cachedDistances or {}
espCache         = espCache or {}
characterConnections = characterConnections or {}

local function getSafeGuiParent2()
    local ok1, hui = pcall(function() return gethui() end)
    if ok1 and hui then return hui end
    local ok2, coreGui = pcall(function() return game:GetService("CoreGui") end)
    if ok2 and coreGui then return coreGui end
    return LocalPlayer:WaitForChild("PlayerGui")
end

ArrowGui = nil
task.spawn(function()
    task.wait(0.3)
    pcall(function()
        local g = Instance.new("ScreenGui")
        g.Name = "ArrowESPGui"
        g.IgnoreGuiInset = true
        g.ResetOnSpawn = false
        g.Parent = getSafeGuiParent2()
        ArrowGui = g
    end)
end)

isPlayerAdmin = function(targetPlayer) return false end

task.spawn(function()
    local success, mod = pcall(function()
        return require(ReplicatedStorage:WaitForChild("Code"):WaitForChild("modules"):WaitForChild("moderators"))
    end)

    if success and mod and mod.getPlayerRank and mod.PlayerRank then
        isPlayerAdmin = function(targetPlayer)
            if not targetPlayer then return false end
            local ok, rank = pcall(mod.getPlayerRank, targetPlayer)
            if ok and type(rank) == "number" then
                return rank >= (mod.PlayerRank.ServerModerator or 1)
            end
            return false
        end
    else
        isPlayerAdmin = function(targetPlayer)
            if not targetPlayer then return false end
            for _, attr in ipairs({"Admin", "IsAdmin", "Staff", "Moderator"}) do
                if targetPlayer:GetAttribute(attr) then return true end
            end
            if CollectionService:HasTag(targetPlayer, "Admin") then return true end
            return false
        end
    end
end)

function isLookingAtTarget(targetChar)
    if not targetChar then return false end
    local vc = Camera.ViewportSize / 2
    local unitRay = Camera:ViewportPointToRay(vc.X, vc.Y)

    local rp = RaycastParams.new()
    if LocalPlayer.Character then
        rp.FilterDescendantsInstances = {LocalPlayer.Character}
        rp.FilterType = Enum.RaycastFilterType.Exclude
    end

    local result = workspace:Raycast(unitRay.Origin, unitRay.Direction * 1000, rp)
    if result and result.Instance and result.Instance:IsDescendantOf(targetChar) then return true end

    local hrp_ = targetChar:FindFirstChild("HumanoidRootPart")
    if hrp_ then
        local _, onScreen = Camera:WorldToViewportPoint(hrp_.Position)
        if onScreen then
            local sp = Camera:WorldToViewportPoint(hrp_.Position)
            if (Vector2.new(sp.X, sp.Y) - vc).Magnitude < 120 then return true end
        end
    end
    return false
end

function createDamageIndicator(char, dmg)
    if not char or dmg <= 0 then return end
    local head = char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
    if not head then return end

    pcall(function()
        local bb = Instance.new("BillboardGui")
        bb.Name = "DamageIndicator"
        bb.Size = UDim2.new(0, 100, 0, 40)

        local randOffset = Vector3.new(math.random(-2, 2), math.random(2, 4), math.random(-2, 2))
        bb.StudsOffset = randOffset
        bb.AlwaysOnTop = true
        bb.Adornee = head
        bb.Parent = head

        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, 0, 1, 0)
        lbl.BackgroundTransparency = 1
        lbl.TextColor3 = _G.ESPConfig.HitSettings.Color
        lbl.TextStrokeColor3 = Color3.new(0, 0, 0)
        lbl.TextStrokeTransparency = 0.1
        lbl.Font = _G.ESPConfig.HitSettings.Font
        lbl.TextSize = _G.ESPConfig.HitSettings.TextSize
        lbl.Text = tostring(math.floor(dmg))
        lbl.Parent = bb

        local ti = TweenInfo.new(_G.ESPConfig.HitSettings.Duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        TweenService:Create(bb, ti, {StudsOffset = randOffset + Vector3.new(0, 3, 0)}):Play()
        TweenService:Create(lbl, ti, {TextTransparency = 1, TextStrokeTransparency = 1}):Play()

        task.delay(_G.ESPConfig.HitSettings.Duration, function()
            pcall(function() bb:Destroy() end)
        end)
    end)
end

function teamColor(p)
    return p.TeamColor and p.TeamColor.Color or Color3.new(1, 1, 1)
end

function getStuds(p)
    local ct = cachedDistances[p]
    if ct and tick() - ct.time < 0.3 then return ct.distance end

    local theirHRP = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
    local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local dist = math.huge
    if theirHRP and myHRP then dist = (myHRP.Position - theirHRP.Position).Magnitude end

    cachedDistances[p] = {distance = dist, time = tick()}
    return dist
end

function updateFontForAll()
    for _, d in pairs(espCache) do
        if d and d.label then d.label.Font = _G.ESPConfig.Settings.CurrentFont end
    end
    for _, d in pairs(vehicleCache) do
        if d and d.label then d.label.Font = _G.ESPConfig.Settings.CurrentFont end
    end
end

function updateTextSizeForAll()
    for _, d in pairs(espCache) do
        if d and d.label then d.label.TextSize = _G.ESPConfig.Settings.TextSize end
    end
    for _, d in pairs(vehicleCache) do
        if d and d.label then d.label.TextSize = _G.ESPConfig.Settings.TextSize end
    end
end

function createESP(p)
    if espCache[p] then return espCache[p] end

    local data = nil
    local ok, err = pcall(function()
        local gui = Instance.new("BillboardGui")
        gui.Name = "ESPTag"
        gui.Size = UDim2.new(0, 200, 0, 50)
        gui.StudsOffset = Vector3.new(0, 2, 0)
        gui.AlwaysOnTop = true
        gui.MaxDistance = _G.ESPConfig.Settings.MaxDistance
        gui.Enabled = false

        local container = Instance.new("Frame")
        container.Name = "Container"
        container.Size = UDim2.new(1, 0, 1, 0)
        container.BackgroundTransparency = 1
        container.Parent = gui

        local avatarFrame = Instance.new("Frame")
        avatarFrame.Name = "AvatarFrame"
        avatarFrame.Size = UDim2.new(0, 28, 0, 28)
        avatarFrame.Position = UDim2.new(0, 0, 0.5, 0)
        avatarFrame.AnchorPoint = Vector2.new(0, 0.5)
        avatarFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        avatarFrame.BorderSizePixel = 0
        avatarFrame.Visible = false
        avatarFrame.Parent = container

        local avCorner = Instance.new("UICorner")
        avCorner.CornerRadius = UDim.new(1, 0)
        avCorner.Parent = avatarFrame

        local avatarImage = Instance.new("ImageLabel")
        avatarImage.Name = "AvatarImage"
        avatarImage.Size = UDim2.new(1, -2, 1, -2)
        avatarImage.Position = UDim2.new(0.5, 0, 0.5, 0)
        avatarImage.AnchorPoint = Vector2.new(0.5, 0.5)
        avatarImage.BackgroundTransparency = 1
        avatarImage.Image = "rbxthumb://type=AvatarHeadShot&id=" .. p.UserId .. "&w=150&h=150"
        avatarImage.Parent = avatarFrame
        Instance.new("UICorner", avatarImage).CornerRadius = UDim.new(1, 0)

        local avStroke = Instance.new("UIStroke")
        avStroke.Name = "AvatarStroke"
        avStroke.Thickness = 2
        avStroke.Color = Color3.new(1, 1, 1)
        avStroke.Parent = avatarFrame

        local label = Instance.new("TextLabel")
        label.Name = "TextLabel"
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Font = _G.ESPConfig.Settings.CurrentFont
        label.TextSize = _G.ESPConfig.Settings.TextSize
        label.TextStrokeTransparency = 0.2
        label.TextXAlignment = Enum.TextXAlignment.Center
        label.TextYAlignment = Enum.TextYAlignment.Top
        label.RichText = true
        label.TextColor3 = Color3.new(1, 1, 1)
        label.Parent = container

        local tracer = nil
        pcall(function()
            tracer = Drawing.new("Line")
            tracer.Thickness = 1.5
            tracer.Transparency = 1
            tracer.Visible = false
        end)

        local highlight = Instance.new("Highlight")
        highlight.Name = "PlayerChams"
        highlight.FillColor = Color3.new(1, 1, 1)
        highlight.FillTransparency = 0.5
        highlight.OutlineColor = Color3.new(1, 1, 1)
        highlight.OutlineTransparency = 0
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.Enabled = false

        local arrowContainer = Instance.new("Frame")
        arrowContainer.Name = p.Name .. "_Arrow"
        arrowContainer.Size = UDim2.new(0, _G.ESPConfig.Settings.ArrowSize, 0, _G.ESPConfig.Settings.ArrowSize)
        arrowContainer.AnchorPoint = Vector2.new(0.5, 0.5)
        arrowContainer.BackgroundTransparency = 1
        arrowContainer.Visible = false
        if ArrowGui then arrowContainer.Parent = ArrowGui end

        local arrImg = Instance.new("ImageLabel")
        arrImg.Size = UDim2.new(1, 0, 1, 0)
        arrImg.BackgroundTransparency = 1
        arrImg.Image = "rbxthumb://type=AvatarHeadShot&id=" .. p.UserId .. "&w=420&h=420"
        arrImg.Parent = arrowContainer
        Instance.new("UICorner", arrImg).CornerRadius = UDim.new(1, 0)

        local arrStroke = Instance.new("UIStroke")
        arrStroke.Thickness = 2
        arrStroke.Parent = arrImg

        local arrowIcon = Instance.new("TextLabel")
        arrowIcon.Size = UDim2.new(0, 22, 0, 22)
        arrowIcon.AnchorPoint = Vector2.new(0.5, 0.5)
        arrowIcon.BackgroundTransparency = 1
        arrowIcon.Text = "▲"
        arrowIcon.Font = Enum.Font.SourceSansBold
        arrowIcon.TextScaled = true
        arrowIcon.TextStrokeTransparency = 0.1
        arrowIcon.TextStrokeColor3 = Color3.new(0, 0, 0)
        arrowIcon.Parent = arrowContainer

        data = {
            gui = gui, container = container, label = label,
            avatarFrame = avatarFrame, avatarImage = avatarImage, avatarStroke = avStroke,
            tracer = tracer, highlight = highlight,
            arrowContainer = arrowContainer, arrowStroke = arrStroke, arrowIcon = arrowIcon
        }
    end)

    if not ok or not data then
        warn("[Flux ESP] createESP failed for " .. tostring(p.Name) .. ": " .. tostring(err))
        return nil
    end

    espCache[p] = data
    return data
end

function updateESP(p)
    if not p or p == LocalPlayer then return end
    local d = espCache[p]
    if not d then return end

    local char = p.Character
    local head = char and char:FindFirstChild("Head")
    local hrp_ = char and char:FindFirstChild("HumanoidRootPart")

    if not char or not head or not hrp_ then
        if d.gui then d.gui.Enabled = false end
        if d.tracer then d.tracer.Visible = false end
        pcall(function() d.highlight.Enabled = false end)
        return
    end

    local dist = getStuds(p)
    if dist > _G.ESPConfig.Settings.MaxDistance then
        if d.gui then d.gui.Enabled = false end
        if d.tracer then d.tracer.Visible = false end
        pcall(function() d.highlight.Enabled = false end)
        return
    end

    local isWanted = hrp_:GetAttribute("IsWanted")
    local tColor = teamColor(p)
    local chamColor = isWanted and _G.ESPConfig.FactionColors["Wanted"] or tColor

    if _G.ESPConfig.PlayerToggles.Chams then
        if char and char.Parent then
            pcall(function()
                if d.highlight.Parent ~= char then d.highlight.Parent = char end
                d.highlight.FillColor = chamColor
                d.highlight.OutlineColor = chamColor
                d.highlight.Enabled = true
            end)
        end
    else
        pcall(function() d.highlight.Enabled = false end)
    end

    local vc = Camera.ViewportSize / 2
    local hrpPos, onScreen = Camera:WorldToViewportPoint(hrp_.Position)

    if d.tracer then
        if _G.ESPConfig.PlayerToggles.Tracers and onScreen then
            d.tracer.From = vc
            d.tracer.To = Vector2.new(hrpPos.X, hrpPos.Y)
            d.tracer.Color = tColor
            d.tracer.Visible = true
        else
            d.tracer.Visible = false
        end
    end

    if onScreen then
        pcall(function()
            if d.gui.Parent ~= head then d.gui.Parent = head end
            if d.gui.Adornee ~= head then d.gui.Adornee = head end
        end)

        local textParts = {}
        local useAvatar = _G.ESPConfig.PlayerToggles.NameESP and _G.ESPConfig.PlayerToggles.NameESPMode == "Name + Avatar"

        if useAvatar then
            d.avatarFrame.Visible = true
            d.avatarStroke.Color = chamColor
            d.avatarFrame.Position = UDim2.new(0, 0, 0.5, 0)
            d.label.Position = UDim2.new(0, 34, 0, 0)
            d.label.Size = UDim2.new(1, -34, 1, 0)
            d.label.TextXAlignment = Enum.TextXAlignment.Left
        else
            d.avatarFrame.Visible = false
            d.label.Position = UDim2.new(0, 0, 0, 0)
            d.label.Size = UDim2.new(1, 0, 1, 0)
            d.label.TextXAlignment = Enum.TextXAlignment.Center
        end

        if _G.ESPConfig.PlayerToggles.NameESP or _G.ESPConfig.PlayerToggles.StudsESP then
            local top = {}
            if _G.ESPConfig.PlayerToggles.NameESP then table.insert(top, p.Name) end
            if _G.ESPConfig.PlayerToggles.StudsESP then table.insert(top, string.format("[%d Studs]", math.floor(dist))) end
            table.insert(textParts, table.concat(top, " "))
        end

        local bottom = {}
        if _G.ESPConfig.PlayerToggles.TeamESP and p.Team then
            table.insert(bottom, string.format('<font color="rgb(%d,%d,%d)">%s</font>',
                tColor.R * 255, tColor.G * 255, tColor.B * 255, p.Team.Name))
        end
        if _G.ESPConfig.PlayerToggles.WantedESP and isWanted then
            table.insert(bottom, '<font color="rgb(255,215,0)">[WANTED]</font>')
        end
        if _G.ESPConfig.PlayerToggles.AdminESP and isPlayerAdmin(p) then
            table.insert(bottom, '<font color="rgb(255,0,0)">[ADMIN]</font>')
        end
        if #bottom > 0 then table.insert(textParts, table.concat(bottom, "\n")) end

        d.label.Text = table.concat(textParts, "\n")
        d.gui.Enabled = (#textParts > 0)
    else
        d.gui.Enabled = false
    end
end

function getVehicleAdornee(v)
    if v.PrimaryPart then return v.PrimaryPart end
    local hrp_ = v:FindFirstChild("HumanoidRootPart")
    if hrp_ and hrp_:IsA("BasePart") then return hrp_ end
    local body = v:FindFirstChild("Body")
    if body then
        if body:IsA("BasePart") then return body end
        local sub = body:FindFirstChildOfClass("BasePart")
        if sub then return sub end
    end
    return v:FindFirstChildOfClass("BasePart")
end

function getVehiclePlate(v)
    local city = v:GetAttribute("licensePlateCity") or ""
    local letters = v:GetAttribute("licensePlateLetters") or ""
    local numbers = v:GetAttribute("licensePlateNumbers") or ""
    if city ~= "" or letters ~= "" or numbers ~= "" then
        return string.format("%s %s %s", tostring(city), tostring(letters), tostring(numbers))
    end
    return "None"
end

function getVehicleFaction(v)
    local owner = Players:FindFirstChild(v.Name)
    if owner and owner.Team then
        local tn = owner.Team.Name:lower()
        if tn:find("police") or tn:find("sheriff") or tn:find("cop") or tn:find("polizei") then return "Police" end
        if tn:find("medic") or tn:find("fire") or tn:find("ems") or tn:find("feuerwehr") or tn:find("ambulance") then return "Medic" end
        if tn:find("hars") or tn:find("adac") or tn:find("tow") then return "HARS" end
    end
    return "Citizen"
end

function createVehicleESP(v)
    if not v:IsA("Model") or vehicleCache[v] then return end

    local data = nil
    local ok, err = pcall(function()
        local faction = getVehicleFaction(v)
        local fColor = _G.ESPConfig.FactionColors[faction] or _G.ESPConfig.FactionColors["Citizen"]
        local targetPart = getVehicleAdornee(v)

        local highlight = Instance.new("Highlight")
        highlight.Name = "VehicleESP_Highlight"
        highlight.FillTransparency = 1
        highlight.OutlineColor = fColor
        highlight.OutlineTransparency = 0
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.Enabled = _G.ESPConfig.VehicleToggles.Outline
        highlight.Parent = v

        local bb = Instance.new("BillboardGui")
        bb.Name = "VehicleESP_Gui"
        bb.Size = UDim2.new(0, 200, 0, 100)
        bb.AlwaysOnTop = true
        bb.MaxDistance = _G.ESPConfig.Settings.MaxDistance
        bb.ExtentsOffset = Vector3.new(0, 1, 0)
        if targetPart then bb.Adornee = targetPart end
        bb.Parent = v

        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, 0, 1, 0)
        lbl.BackgroundTransparency = 1
        lbl.TextColor3 = fColor
        lbl.TextStrokeTransparency = 0.2
        lbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        lbl.Font = _G.ESPConfig.Settings.CurrentFont
        lbl.TextSize = _G.ESPConfig.Settings.TextSize
        lbl.TextYAlignment = Enum.TextYAlignment.Top
        lbl.Parent = bb

        data = {highlight = highlight, billboard = bb, label = lbl}
    end)

    if ok and data then
        vehicleCache[v] = data
    end
end

function removeVehicleESP(v)
    if vehicleCache[v] then
        pcall(function() vehicleCache[v].highlight:Destroy() end)
        pcall(function() vehicleCache[v].billboard:Destroy() end)
        vehicleCache[v] = nil
    end
end

function updateVehicleESP(v)
    local d = vehicleCache[v]
    if not d then return end
    local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local tp = d.billboard.Adornee or getVehicleAdornee(v)
    if not tp or not myHRP then
        d.billboard.Enabled = false
        d.highlight.Enabled = false
        return
    end
    if (myHRP.Position - tp.Position).Magnitude > _G.ESPConfig.Settings.MaxDistance then
        d.billboard.Enabled = false
        d.highlight.Enabled = false
        return
    end

    local faction = getVehicleFaction(v)
    local fColor = _G.ESPConfig.FactionColors[faction] or _G.ESPConfig.FactionColors["Citizen"]
    d.highlight.OutlineColor = fColor
    d.highlight.Enabled = _G.ESPConfig.VehicleToggles.Outline
    d.label.TextColor3 = fColor
    d.billboard.MaxDistance = _G.ESPConfig.Settings.MaxDistance
    if not d.billboard.Adornee then d.billboard.Adornee = tp end

    local lines = {}
    if _G.ESPConfig.VehicleToggles.Owner then
        local n = v.Name
        if n:match("^%w+-%w+-%w+-%w+-%w+$") or #n > 20 then n = "None" end
        table.insert(lines, "Owner: " .. n)
    end
    if _G.ESPConfig.VehicleToggles.HP then
        local hp = v:GetAttribute("currentHealth") or 600
        table.insert(lines, string.format("HP: %d/600", math.floor(hp)))
    end
    if _G.ESPConfig.VehicleToggles.Fuel then
        local f = v:GetAttribute("currentFuel") or 0
        table.insert(lines, string.format("Fuel: %d L", math.floor(f)))
    end
    if _G.ESPConfig.VehicleToggles.Plate then
        table.insert(lines, "Plate: " .. getVehiclePlate(v))
    end
    if _G.ESPConfig.VehicleToggles.Status then
        local locked = v:GetAttribute("Locked")
        table.insert(lines, "Status: " .. ((locked == true) and "Locked" or "Open"))
    end

    d.label.Text = table.concat(lines, "\n")
    d.billboard.Enabled = (#lines > 0)
end

function updateVisibleESP()
    local anyPlayerEnabled = _G.ESPConfig.PlayerToggles.NameESP
        or _G.ESPConfig.PlayerToggles.StudsESP
        or _G.ESPConfig.PlayerToggles.TeamESP
        or _G.ESPConfig.PlayerToggles.WantedESP
        or _G.ESPConfig.PlayerToggles.AdminESP
        or _G.ESPConfig.PlayerToggles.Tracers
        or _G.ESPConfig.PlayerToggles.Chams
        or _G.ESPConfig.PlayerToggles.ArrowESP

    for p, d in pairs(espCache) do
        if p ~= LocalPlayer then
            pcall(function()
                if anyPlayerEnabled then
                    updateESP(p)
                else
                    if d.gui then d.gui.Enabled = false end
                    if d.tracer then d.tracer.Visible = false end
                    if d.highlight then d.highlight.Enabled = false end
                end
            end)
        end
    end

    local vf = workspace:FindFirstChild("Vehicles")
    local anyVehEnabled = _G.ESPConfig.VehicleToggles.Outline
        or _G.ESPConfig.VehicleToggles.Owner
        or _G.ESPConfig.VehicleToggles.HP
        or _G.ESPConfig.VehicleToggles.Fuel
        or _G.ESPConfig.VehicleToggles.Plate
        or _G.ESPConfig.VehicleToggles.Status

    if vf and anyVehEnabled then
        for _, v in ipairs(vf:GetChildren()) do
            if v:IsA("Model") then
                pcall(function()
                    if not vehicleCache[v] then createVehicleESP(v) end
                    updateVehicleESP(v)
                end)
            end
        end
    else
        for v, _ in pairs(vehicleCache) do
            pcall(function() removeVehicleESP(v) end)
        end
    end

    for v, _ in pairs(vehicleCache) do
        pcall(function()
            if not v or not v.Parent or (vf and v.Parent ~= vf) then
                removeVehicleESP(v)
            end
        end)
    end
end

function trackCharacterHealth(p, char)
    if not char or not char.Parent then return end
    local hum = char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid", 5)
    if not hum or not hum:IsA("Humanoid") then return end

    healthTrackers[p] = hum.Health

    local conn
    conn = hum.HealthChanged:Connect(function(cur)
        if not char or not char.Parent then conn:Disconnect() return end
        local last = healthTrackers[p] or cur
        if cur < last then
            if _G.ESPConfig.PlayerToggles.HitEffects and isLookingAtTarget(char) then
                createDamageIndicator(char, last - cur)
            end
        end
        healthTrackers[p] = cur
    end)
end

function setupPlayer(p)
    if p == LocalPlayer then return end
    pcall(createESP, p)

    if characterConnections[p] then characterConnections[p]:Disconnect() end
    characterConnections[p] = p.CharacterAdded:Connect(function(char)
        task.wait(0.1)
        pcall(updateESP, p)
        pcall(trackCharacterHealth, p, char)
    end)

    if p.Character then
        task.wait(0.1)
        pcall(updateESP, p)
        pcall(trackCharacterHealth, p, p.Character)
    end
end

function cleanupPlayer(p)
    if characterConnections[p] then characterConnections[p]:Disconnect(); characterConnections[p] = nil end
    if espCache[p] then
        pcall(function() espCache[p].gui:Destroy() end)
        pcall(function() if espCache[p].tracer then espCache[p].tracer:Remove() end end)
        pcall(function() espCache[p].highlight:Destroy() end)
        pcall(function() espCache[p].arrowContainer:Destroy() end)
        espCache[p] = nil
    end
    cachedDistances[p] = nil
    healthTrackers[p] = nil
end

lastPlayerCheck = 0
function updatePlayersList()
    local now = tick()
    if now - lastPlayerCheck < 0.5 then return end
    lastPlayerCheck = now
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and not espCache[p] then setupPlayer(p) end
    end
end

task.spawn(function()
    task.wait(0.5)
    for _, p in pairs(Players:GetPlayers()) do
        pcall(setupPlayer, p)
    end
    Players.PlayerAdded:Connect(function(p)
        pcall(setupPlayer, p)
    end)
    Players.PlayerRemoving:Connect(cleanupPlayer)
end)

lastUpdate = 0
task.spawn(function()
    task.wait(0.5)
    RunService.Heartbeat:Connect(function()
        local now = tick()
        if now - lastUpdate < 0.016 then return end
        lastUpdate = now
        pcall(updatePlayersList)
        pcall(updateVisibleESP)
    end)
end)

task.spawn(function()
    task.wait(0.5)
    RunService.RenderStepped:Connect(function()
        if not _G.ESPConfig.PlayerToggles.ArrowESP then
            for p, d in pairs(espCache) do
                if p ~= LocalPlayer and d.arrowContainer then
                    d.arrowContainer.Visible = false
                end
            end
            return
        end

        local camCF = Camera.CFrame
        local vc = Camera.ViewportSize / 2
        local radius = _G.ESPConfig.Settings.ArrowRadius
        local arrowOffset = (_G.ESPConfig.Settings.ArrowSize / 2) + 12
        local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

        for p, d in pairs(espCache) do
            if p == LocalPlayer then continue end
            pcall(function()
                if not d.arrowContainer then return end
                local char = p.Character
                local hrp_ = char and char:FindFirstChild("HumanoidRootPart")
                if not hrp_ or not myHRP then d.arrowContainer.Visible = false return end
                if (myHRP.Position - hrp_.Position).Magnitude > _G.ESPConfig.Settings.MaxDistance then
                    d.arrowContainer.Visible = false
                    return
                end

                local worldDir = hrp_.Position - camCF.Position
                local screenX = worldDir:Dot(camCF.RightVector)
                local screenY = -worldDir:Dot(camCF.UpVector)
                local screenZ = worldDir:Dot(camCF.LookVector)

                if screenZ < 0 then screenX = -screenX; screenY = -screenY end

                local angle = math.atan2(screenY, screenX)
                local posX = vc.X + math.cos(angle) * radius
                local posY = vc.Y + math.sin(angle) * radius

                d.arrowContainer.Position = UDim2.new(0, posX, 0, posY)
                d.arrowIcon.Position = UDim2.new(0.5, math.cos(angle) * arrowOffset, 0.5, math.sin(angle) * arrowOffset)
                d.arrowIcon.Rotation = math.deg(angle) + 90

                local isWanted = hrp_:GetAttribute("IsWanted")
                local tColor = teamColor(p)
                local chamColor = isWanted and _G.ESPConfig.FactionColors["Wanted"] or tColor
                d.arrowStroke.Color = chamColor
                d.arrowIcon.TextColor3 = chamColor
                d.arrowContainer.Visible = true
            end)
        end
    end)
end)

EspTab:AddToggle({
    Name = "Name ESP",
    Default = _G.ESPConfig.PlayerToggles.NameESP,
    Flag = "NameESPToggle",
    Callback = function(value)
        _G.ESPConfig.PlayerToggles.NameESP = value
        updateVisibleESP()
    end
})

EspTab:AddDropdown({
    Name = "Name ESP Mode",
    Options = {"Only Name", "Name + Avatar"},
    Default = _G.ESPConfig.PlayerToggles.NameESPMode,
    Flag = "NameESPMode",
    Callback = function(mode)
        _G.ESPConfig.PlayerToggles.NameESPMode = mode
        updateVisibleESP()
    end
})

local espToggleOrder = {
    {key = "StudsESP", name = "Studs ESP"},
    {key = "TeamESP", name = "Team ESP"},
    {key = "WantedESP", name = "Wanted ESP"},
    {key = "AdminESP", name = "Private Server Admin ESP"},
    {key = "Tracers", name = "Tracers"},
    {key = "Chams", name = "Player Chams"},
    {key = "HitEffects", name = "Hit Indicators"},
    {key = "ArrowESP", name = "Avatar Arrow ESP"},
}

for _, entry in ipairs(espToggleOrder) do
    EspTab:AddToggle({
        Name = entry.name,
        Default = _G.ESPConfig.PlayerToggles[entry.key],
        Flag = entry.key .. "Toggle",
        Callback = function(value)
            _G.ESPConfig.PlayerToggles[entry.key] = value
            updateVisibleESP()
        end
    })
end

EspTab:AddSection({Name = "Vehicle ESP Options"})

local vehicleToggleOrder = {
    {key = "Outline", name = "Vehicle Outline"},
    {key = "Owner", name = "Vehicle Owner"},
    {key = "HP", name = "Vehicle HP"},
    {key = "Fuel", name = "Vehicle Fuel"},
    {key = "Plate", name = "Vehicle Plate"},
    {key = "Status", name = "Vehicle Status"},
}

for _, entry in ipairs(vehicleToggleOrder) do
    EspTab:AddToggle({
        Name = entry.name,
        Default = _G.ESPConfig.VehicleToggles[entry.key],
        Flag = "Vehicle" .. entry.key .. "Toggle",
        Callback = function(value)
            _G.ESPConfig.VehicleToggles[entry.key] = value
            updateVisibleESP()
        end
    })
end

EspTab:AddSection({Name = "ESP Settings"})

EspTab:AddSlider({
    Name = "ESP Distance", Min = 100, Max = 2000, Default = _G.ESPConfig.Settings.MaxDistance,
    Increment = 50, ValueName = "Studs",
    Flag = "ESPDistanceSlider",
    Callback = function(Value)
        _G.ESPConfig.Settings.MaxDistance = Value
        for _, d in pairs(espCache) do
            if d and d.gui then d.gui.MaxDistance = Value end
        end
        updateVisibleESP()
    end
})

EspTab:AddSlider({
    Name = "ESP Size", Min = 6, Max = 24, Default = _G.ESPConfig.Settings.TextSize,
    Increment = 1, ValueName = "px",
    Flag = "ESPSizeSlider",
    Callback = function(Value)
        _G.ESPConfig.Settings.TextSize = Value
        updateTextSizeForAll()
        updateVisibleESP()
    end
})

EspTab:AddDropdown({
    Name = "Font Selection", Default = "Minecraft",
    Options = {"Pixel", "Minecraft", "Fortnite", "Roblox", "Neon"},
    Flag = "ESPFontDropdown",
    Callback = function(Value)
        if _G.ESPConfig.FontOptions[Value] then
            _G.ESPConfig.Settings.CurrentFont = _G.ESPConfig.FontOptions[Value]
            updateFontForAll()
            updateVisibleESP()
        end
    end
})

visualSettings = {
    player = LocalPlayer,
    originalLighting = {},
    isToggled = false, isToggled2 = false, lieDownActive = false,
    savedWalkSpeed = 0, savedJumpPower = 0, savedAtmosphere = nil,
    anim = nil, animTrack = nil, anim2 = nil, animTrack2 = nil,
    animator = nil, animator2 = nil
}

function clearVisuals(char)
    for _, inst in ipairs(char:GetChildren()) do
        if inst:IsA("Accessory") or inst:IsA("Hat") or inst:IsA("Shirt") or inst:IsA("Pants") or inst:IsA("ShirtGraphic") or inst:IsA("CharacterMesh") then
            inst:Destroy()
        end
    end
    local head = char:FindFirstChild("Head")
    if head then
        for _, d in ipairs(head:GetChildren()) do
            if d:IsA("Decal") and d.Name:lower() == "face" then d:Destroy() end
        end
    end
    local bc = char:FindFirstChildOfClass("BodyColors")
    if bc then bc:Destroy() end
end

function attachAccessory(char, accessory)
    local handle = accessory:FindFirstChild("Handle")
    if not handle then return end
    local tAtt, aAtt
    for _, part in ipairs(char:GetChildren()) do
        if part:IsA("BasePart") then
            for _, att in ipairs(part:GetChildren()) do
                if att:IsA("Attachment") then
                    local match = handle:FindFirstChild(att.Name)
                    if match and match:IsA("Attachment") then
                        tAtt = att; aAtt = match; break
                    end
                end
            end
        end
        if tAtt then break end
    end
    if tAtt and aAtt then
        handle.CFrame = tAtt.WorldCFrame * aAtt.CFrame:Inverse()
    else
        local root = char:FindFirstChild("HumanoidRootPart")
        if root then handle.CFrame = root.CFrame end
    end
    local weld = Instance.new("WeldConstraint")
    weld.Part0 = handle
    weld.Part1 = (tAtt and tAtt.Parent) or char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Head")
    weld.Parent = handle
    accessory.Parent = char
end

function applyAppearance(userId)
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local ok, model = pcall(function() return Players:GetCharacterAppearanceAsync(userId) end)
    if not ok or not model then return end
    clearVisuals(char)
    local bc = model:FindFirstChildOfClass("BodyColors")
    if bc then bc:Clone().Parent = char end
    for _, item in ipairs(model:GetChildren()) do
        if item:IsA("Shirt") or item:IsA("Pants") or item:IsA("ShirtGraphic") then item:Clone().Parent = char end
    end
    for _, acc in ipairs(model:GetChildren()) do
        if acc:IsA("Accessory") or acc:IsA("Hat") then attachAccessory(char, acc:Clone()) end
    end
    local head = char:FindFirstChild("Head")
    if head then
        local face = model:FindFirstChild("face", true)
        if face and face:IsA("Decal") then face:Clone().Parent = head end
    end
end

function getUserIdFromUsername(username)
    local success, userId = pcall(function() return Players:GetUserIdFromNameAsync(username) end)
    if success then return userId end
    return nil
end

function getPlayerList()
    local list = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then table.insert(list, p.Name) end
    end
    return list
end

char2 = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
hum = char2:WaitForChild("Humanoid")
visualSettings.animator = hum:WaitForChild("Animator") or Instance.new("Animator", hum)
visualSettings.anim = Instance.new("Animation")
visualSettings.anim.AnimationId = "rbxassetid://9357137817"
visualSettings.animTrack = visualSettings.animator:LoadAnimation(visualSettings.anim)

visualSettings.animator2 = hum:WaitForChild("Animator") or Instance.new("Animator", hum)
visualSettings.anim2 = Instance.new("Animation")
visualSettings.anim2.AnimationId = "rbxassetid://11019608524"
visualSettings.animTrack2 = visualSettings.animator2:LoadAnimation(visualSettings.anim2)

VisualTab:AddSection({Name = "Ingame Based"})

VisualTab:AddToggle({
    Name = "Fake Cuffed", Default = false, Flag = "FakeCuffedToggle",
    Callback = function(v)
        visualSettings.isToggled = v
        if v then visualSettings.animTrack:Play() else visualSettings.animTrack:Stop() end
    end
})

VisualTab:AddToggle({
    Name = "Jerk Off", Default = false, Flag = "JerkOffToggle",
    Callback = function(Value)
        if Value then
            if JerkOffActive then return end
            JerkOffActive = true
            local anim = Instance.new("Animation")
            anim.AnimationId = "rbxassetid://698251653"
            local track = LocalPlayer.Character.Humanoid:LoadAnimation(anim)
            task.spawn(function()
                while JerkOffActive do
                    track:Play()
                    track:AdjustSpeed(1)
                    track.TimePosition = 0.5
                    task.wait(0.1)
                    while track.TimePosition < 0.5 do task.wait(0.1) end
                    track:Stop()
                end
            end)
        else
            JerkOffActive = false
        end
    end
})

VisualTab:AddToggle({
    Name = "Fake Dead", Default = false, Flag = "FakeDeadToggle",
    Callback = function(v)
        visualSettings.isToggled2 = v
        if v then visualSettings.animTrack2:Play() else visualSettings.animTrack2:Stop() end
    end
})

VisualTab:AddToggle({
    Name = "Lie Down", Default = false, Flag = "LieDownToggle",
    Callback = function(v)
        if v and not visualSettings.isToggled2 then
            StarterGui:SetCore("SendNotification", {Title = "Error", Text = "You have to activate Fake Dead to use Lie Down", Duration = 3})
            return
        end
        visualSettings.lieDownActive = v
        local char = visualSettings.player.Character
        if char then
            local hum_ = char:WaitForChild("Humanoid")
            local root_ = char:WaitForChild("HumanoidRootPart")
            if v then
                visualSettings.savedWalkSpeed = hum_.WalkSpeed
                visualSettings.savedJumpPower = hum_.JumpPower
                hum_.PlatformStand = true
                hum_:ChangeState(Enum.HumanoidStateType.Ragdoll)
                root_.CFrame = root_.CFrame * CFrame.Angles(math.rad(90), 0, 0)
            else
                hum_.PlatformStand = false
                hum_:ChangeState(Enum.HumanoidStateType.GettingUp)
            end
        end
    end
})

LocalPlayer.CharacterAdded:Connect(function(newChar)
    local newHum = newChar:WaitForChild("Humanoid")
    visualSettings.animator = newHum:WaitForChild("Animator") or Instance.new("Animator", newHum)
    visualSettings.animTrack = visualSettings.animator:LoadAnimation(visualSettings.anim)
    if visualSettings.isToggled then
        wait(1)
        visualSettings.animTrack:Play()
    end
    if visualSettings.lieDownActive then
        wait(1)
        local h = newChar:WaitForChild("Humanoid")
        local r = newChar:WaitForChild("HumanoidRootPart")
        h.PlatformStand = true
        h:ChangeState(Enum.HumanoidStateType.Ragdoll)
        r.CFrame = r.CFrame * CFrame.Angles(math.rad(90), 0, 0)
    end
end)

LocalPlayer.CharacterAdded:Connect(function(newChar)
    local newHum = newChar:WaitForChild("Humanoid")
    visualSettings.animator2 = newHum:WaitForChild("Animator") or Instance.new("Animator", newHum)
    visualSettings.animTrack2 = visualSettings.animator2:LoadAnimation(visualSettings.anim2)
    if visualSettings.isToggled2 then
        wait(1)
        visualSettings.animTrack2:Play()
    end
end)

VisualTab:AddSection({Name = "Graphic"})

VisualTab:AddToggle({
    Name = "Remove Atmosphere", Default = false, Flag = "RemoveAtmosphereToggle",
    Callback = function(v)
        if v then
            local atmos = Lighting:FindFirstChildOfClass("Atmosphere")
            if atmos then
                visualSettings.savedAtmosphere = atmos:Clone()
                atmos:Destroy()
            end
        else
            if visualSettings.savedAtmosphere then
                local existing = Lighting:FindFirstChildOfClass("Atmosphere")
                if existing then existing:Destroy() end
                visualSettings.savedAtmosphere.Parent = Lighting
                visualSettings.savedAtmosphere = nil
            end
        end
    end
})

VisualTab:AddToggle({
    Name = "Fullbright", Default = false, Flag = "FullbrightToggle",
    Callback = function(v)
        if v then
            visualSettings.originalLighting.Brightness = Lighting.Brightness
            visualSettings.originalLighting.ClockTime = Lighting.ClockTime
            visualSettings.originalLighting.FogEnd = Lighting.FogEnd
            visualSettings.originalLighting.GlobalShadows = Lighting.GlobalShadows
            visualSettings.originalLighting.OutdoorAmbient = Lighting.OutdoorAmbient
            Lighting.Brightness = 2
            Lighting.ClockTime = 12
            Lighting.FogEnd = 100000
            Lighting.GlobalShadows = false
            Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
        else
            for prop, val in pairs(visualSettings.originalLighting) do Lighting[prop] = val end
        end
    end
})

freezeTime = false
customTime = 12

RunService.RenderStepped:Connect(function()
    if freezeTime then Lighting.ClockTime = customTime end
end)

VisualTab:AddToggle({
    Name = "Freeze Time", Default = false,
    Callback = function(Value)
        freezeTime = Value
        if freezeTime then Lighting.ClockTime = customTime end
    end
})

VisualTab:AddSlider({
    Name = "Set Time", Min = 0, Max = 24, Default = 12,
    Increment = 1, ValueName = "h",
    Callback = function(Value)
        customTime = Value
        Lighting.ClockTime = customTime
    end
})

VisualTab:AddToggle({
    Name = "Remove Clouds", Default = false,
    Callback = function(Value)
        local atmos = Lighting:FindFirstChildOfClass("Atmosphere")
        if Value then
            if atmos then
                atmos.Density = 0
                atmos.Haze = 0
                atmos.Glare = 0
                atmos.Offset = 0
            end
            for _, obj in ipairs(Lighting:GetDescendants()) do
                if obj:IsA("Clouds") then obj.Cover = 0; obj.Density = 0 end
            end
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA("Clouds") then obj.Cover = 0; obj.Density = 0 end
            end
        else
            if atmos then
                atmos.Density = 0.395
                atmos.Haze = 0
                atmos.Glare = 0
                atmos.Offset = 0
            end
            for _, obj in ipairs(Lighting:GetDescendants()) do
                if obj:IsA("Clouds") then obj.Cover = 0.5; obj.Density = 0.5 end
            end
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA("Clouds") then obj.Cover = 0.5; obj.Density = 0.5 end
            end
        end
    end
})

VisualTab:AddSection({Name = "Custom Animation"})

animations = {
    ["Helicopter"] = 95301257497525,
    ["Default Dance"] = 88455578674030,
    ["Sit"] = 97185364700038,
    ["Take The L"] = 78653596566468,
    ["Tank"] = 94915612757079,
    ["Vehicle"] = 108747312576405,
    ["Rizz Backflip"] = 131205329995035,
    ["Snow Surfer"] = 100663712757148,
    ["Black Flash"] = 104767795538635,
    ["Skibidi Toilet"] = 127154705636043,
    ["Beat Da Koto Nai"] = 93497729736287,
    ["Spider"] = 87025086742503,
    ["Slickback"] = 74288964113793
}

animationList = {}
for name, _ in pairs(animations) do table.insert(animationList, name) end

currentTrack = nil
selectedAnimation = animationList[1]

VisualTab:AddDropdown({
    Name = "Select Animation", Default = selectedAnimation, Options = animationList,
    Flag = "AnimationDropdown",
    Callback = function(value) selectedAnimation = value end
})

VisualTab:AddToggle({
    Name = "Play Animation", Default = false, Flag = "PlayAnimationToggle",
    Callback = function(isOn)
        if isOn then
            if currentTrack then currentTrack:Stop() end
            local anim = Instance.new("Animation")
            anim.AnimationId = "rbxassetid://" .. animations[selectedAnimation]
            currentTrack = humanoid:LoadAnimation(anim)
            currentTrack:Play()
        else
            if currentTrack then currentTrack:Stop() end
        end
    end
})

VisualTab:AddSection({Name = "Custom Outfit"})

selectedPlayer = nil
skinChangerEnabled = false

local function restoreOwnAppearance()
    local char = LocalPlayer.Character
    if not char then return end

    local ok, model = pcall(function()
        return Players:GetCharacterAppearanceAsync(LocalPlayer.UserId)
    end)
    if not ok or not model then return end

    clearVisuals(char)

    local bc = model:FindFirstChildOfClass("BodyColors")
    if bc then bc:Clone().Parent = char end

    for _, item in ipairs(model:GetChildren()) do
        if item:IsA("Shirt") or item:IsA("Pants") or item:IsA("ShirtGraphic") then
            item:Clone().Parent = char
        end
    end

    for _, acc in ipairs(model:GetChildren()) do
        if acc:IsA("Accessory") or acc:IsA("Hat") then
            attachAccessory(char, acc:Clone())
        end
    end

    local head = char:FindFirstChild("Head")
    if head then
        local face = model:FindFirstChild("face", true)
        if face and face:IsA("Decal") then face:Clone().Parent = head end
    end
end

VisualTab:AddToggle({
    Name = "Skin Changer",
    Description = "Enables the Skin Changer.",
    Default = false,
    Flag = "SkinChangerToggle",
    Callback = function(value)
        skinChangerEnabled = value
        if not value then
            selectedPlayer = nil
            restoreOwnAppearance()
            Hydrogen:MakeNotification({
                Name = "Skin Changer",
                Content = "Disabled - Restored your own avatar.",
                Time = 3
            })
        else
            Hydrogen:MakeNotification({
                Name = "Skin Changer",
                Content = "Enabled.",
                Time = 3
            })
        end
    end
})

local outfitDropdown = VisualTab:AddDropdown({
    Name = "Select Player",
    Default = "",
    Options = getPlayerList(),
    Flag = "PlayerOutfitDropdown",
    Callback = function(opt)
        if not skinChangerEnabled then
            Hydrogen:MakeNotification({
                Name = "Skin Changer",
                Content = "Please enable the Skin Changer toggle first!",
                Time = 3
            })
            return
        end

        selectedPlayer = opt
        if selectedPlayer and selectedPlayer ~= "" then
            local plr_ = Players:FindFirstChild(selectedPlayer)
            if plr_ then applyAppearance(plr_.UserId) end
        end
    end
})

local function refreshPlayerList()
    local newOpts = getPlayerList()
    if outfitDropdown then
        outfitDropdown:Refresh(newOpts, true)
    end
end

Players.PlayerAdded:Connect(refreshPlayerList)
Players.PlayerRemoving:Connect(refreshPlayerList)

VisualTab:AddTextbox({
    Name = "Custom Mode",
    Placeholder = "Enter username...",
    Flag = "CustomOutfitTextbox",
    Callback = function(val, enterPressed)
        if not skinChangerEnabled then
            Hydrogen:MakeNotification({
                Name = "Skin Changer",
                Content = "Please enable the Skin Changer toggle first!",
                Time = 3
            })
            return
        end

        if val ~= "" then
            local userId = getUserIdFromUsername(val)
            if userId then
                applyAppearance(userId)
            else
                Hydrogen:MakeNotification({
                    Name = "Error",
                    Content = "Player '" .. val .. "' was not found.",
                    Time = 3
                })
            end
        end
    end
})

VisualTab:AddSection({Name = "Custom Player"})

trailEnabled = false
particlesEnabled = false
trailColor = Color3.fromRGB(255, 0, 0)
particlesColor = Color3.fromRGB(255, 0, 0)

a0 = Instance.new("Attachment")
a0.Position = Vector3.new(0, 1.4, 0)
a0.Parent = hrp

a1 = Instance.new("Attachment")
a1.Position = Vector3.new(0, -1.4, 0)
a1.Parent = hrp

trail = Instance.new("Trail")
trail.Attachment0 = a0
trail.Attachment1 = a1
trail.WidthScale = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0.25),
    NumberSequenceKeypoint.new(1, 0)
})
trail.Enabled = false
trail.Parent = hrp

particles = Instance.new("ParticleEmitter")
particles.Size = NumberSequence.new(0.3)
particles.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0),
    NumberSequenceKeypoint.new(1, 1)
})
particles.Rate = 22
particles.Speed = NumberRange.new(0)
particles.Enabled = false
particles.Parent = hrp

local function isInDriveSeat()
    local vf = workspace:FindFirstChild("Vehicles")
    if not vf then return false end
    local v = vf:FindFirstChild(player.Name)
    if not v then return false end
    local seat = v:FindFirstChild("DriveSeat")
    if not seat then return false end
    return seat.Occupant == humanoid
end

task.spawn(function()
    while true do
        local inSeat = isInDriveSeat()
        trail.Enabled = trailEnabled and not inSeat
        particles.Enabled = particlesEnabled and not inSeat
        task.wait(0.1)
    end
end)

VisualTab:AddToggle({
    Name = "Trail", Default = false,
    Flag = "TrailToggle",
    Callback = function(Value)
        trailEnabled = Value
        if not Value then trail.Enabled = false end
    end
})

VisualTab:AddColorpicker({
    Name = "Trail Color", Default = Color3.fromRGB(255, 255, 255),
    Flag = "TrailColor",
    Callback = function(Value)
        trailColor = Value
        trail.Color = ColorSequence.new(Value)
    end
})

VisualTab:AddToggle({
    Name = "Particles", Default = false,
    Flag = "ParticlesToggle",
    Callback = function(Value)
        particlesEnabled = Value
        if not Value then particles.Enabled = false end
    end
})

VisualTab:AddColorpicker({
    Name = "Particles Color", Default = particlesColor,
    Flag = "ParticlesColor",
    Callback = function(Value)
        particlesColor = Value
        particles.Color = ColorSequence.new(Value)
    end
})

VisualTab:AddSection({ Name = "Custom Weapons Colour" })

weaponParts = {
    ["Glock 17"] = {"Base", "BaseTop"},
    ["G36"] = {"Body"},
    ["MP5"] = "ALLPARTS",
    ["M4 Carbine"] = {"Base1"},
    ["M58B Shotgun"] = {"BrigherBlack"},
    ["Desert Eagle"] = {"Base"}
}

function handleWrap(action, param1, param2)
    local settings = wrapSettings

    if action == "pick" then
        local parts = {}
        local toolName = type(param1) == "string" and param1 or param1.Name
        local partList = weaponParts[toolName]
        if not partList then return parts end

        if partList == "ALLPARTS" then
            for _, part in ipairs(param1:GetDescendants()) do
                if part:IsA("MeshPart") and part.Name == "MeshPart" then table.insert(parts, part) end
            end
        else
            for _, partName in ipairs(partList) do
                local part = param1:FindFirstChild(partName, true)
                if part and part:IsA("BasePart") then table.insert(parts, part) end
            end
        end
        return parts
    elseif action == "save" then
        for _, part in ipairs(param1) do
            if not settings.originalMaterials[part] then
                settings.originalMaterials[part] = {
                    Material = part.Material, Color = part.Color, Transparency = part.Transparency
                }
                settings.connections[part] = part.AncestryChanged:Connect(function(_, parent)
                    if not parent then
                        if settings.connections[part] then settings.connections[part]:Disconnect() end
                        settings.connections[part] = nil
                        settings.originalMaterials[part] = nil
                    end
                end)
            end
        end
    elseif action == "tint" then
        local parts = param1 or settings.parts
        local color = param2 or settings.color
        local blend = settings.blend
        for _, part in ipairs(parts) do
            local orig = settings.originalMaterials[part]
            if orig and part.Parent then
                part.Material = Enum.Material.Neon
                part.Color = orig.Color:Lerp(color, math.clamp(blend, 0, 1))
                part.Transparency = orig.Transparency
            end
        end
    elseif action == "reset" then
        for part, orig in pairs(settings.originalMaterials) do
            if part and part.Parent then
                part.Material = orig.Material
                part.Color = orig.Color
                part.Transparency = orig.Transparency
            end
            if settings.connections[part] then settings.connections[part]:Disconnect() end
            settings.connections[part] = nil
        end
        settings.parts = {}
        settings.originalMaterials = {}
    elseif action == "equip" then
        settings.currentTool = param1
        settings.parts = handleWrap("pick", param1)
        handleWrap("save", settings.parts)
        if settings.enabled then handleWrap("tint") end
    elseif action == "bind" then
        local char = param1
        local function setupTool(tool)
            if tool and tool:IsA("Tool") then
                tool.Equipped:Connect(function() handleWrap("equip", tool) end)
                tool.Unequipped:Connect(function()
                    settings.currentTool = nil
                    settings.parts = {}
                end)
                if tool.Parent == char then handleWrap("equip", tool) end
            end
        end
        for _, child in ipairs(char:GetChildren()) do setupTool(child) end
        char.ChildAdded:Connect(setupTool)
    end
end

if LocalPlayer.Character then handleWrap("bind", LocalPlayer.Character) end
LocalPlayer.CharacterAdded:Connect(function(char) handleWrap("bind", char) end)

VisualTab:AddToggle({
    Name = "Gun Color", Default = false,
    Flag = "GunColorToggle",
    Callback = function(value)
        wrapSettings.enabled = value
        if value then
            if wrapSettings.currentTool then
                wrapSettings.parts = handleWrap("pick", wrapSettings.currentTool)
                handleWrap("save", wrapSettings.parts)
            end
            handleWrap("tint")
        else
            handleWrap("reset")
        end
    end
})

VisualTab:AddColorpicker({
    Name = "Gun Color Picker", Default = Color3.fromRGB(255, 255, 255),
    Flag = "GunColorPicker",
    Callback = function(color)
        wrapSettings.color = color
        if wrapSettings.enabled and #wrapSettings.parts > 0 then handleWrap("tint") end
    end
})

VisualTab:AddSlider({
    Name = "Gun Blend", Min = 0.1, Max = 1, Default = 0.5,
    Increment = 0.1,
    Flag = "GunBlendSlider",
    Callback = function(value)
        wrapSettings.blend = math.clamp(value, 0.1, 1)
        if wrapSettings.enabled and #wrapSettings.parts > 0 then handleWrap("tint") end
    end
})

tpSettings = tpSettings or { tpSpd = 175, START_HEIGHT = -2, END_HEIGHT = 5 }

do
    ws = workspace
    localPlayer = LocalPlayer

    tpState = { target = nil, special = false, camFlag = false, seatLoop = nil }

    miscSettings = {
        plr = LocalPlayer, ws = ws, ts = TweenService, rs = RunService, uis = UserInputService,
        teams = game:GetService("Teams"), RadarFarmEnabled = false, remote = nil,
        FARMspeed = 160, teleportActive = false, overlayGuis = {}, targetPosition = nil,
        seatCheckConnection = nil, forceVisible = false, isSpecialTeleport = false,
    }
    _G.miscSettings = miscSettings

    overlayParent = (gethui and gethui()) or game:GetService("CoreGui")

    overlayGui = Instance.new("ScreenGui")
    overlayGui.Name = "FluxTpOverlay_" .. math.random(10000, 99999)
    overlayGui.ResetOnSpawn = false
    overlayGui.IgnoreGuiInset = true
    overlayGui.DisplayOrder = 999
    overlayGui.Parent = overlayParent

    overlayFrame = Instance.new("Frame")
    overlayFrame.Size = UDim2.new(1, 0, 1, 0)
    overlayFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    overlayFrame.BorderSizePixel = 0
    overlayFrame.Visible = false
    overlayFrame.Parent = overlayGui

    overlayLabel = Instance.new("TextLabel")
    overlayLabel.Size = UDim2.new(1, 0, 1, 0)
    overlayLabel.BackgroundTransparency = 1
    overlayLabel.Text = "You are being Teleported, this may take a few seconds. Thanks for using Flux!"
    overlayLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    overlayLabel.TextSize = 32
    overlayLabel.Font = Enum.Font.GothamBold
    overlayLabel.TextWrapped = true
    overlayLabel.Parent = overlayFrame

    function showOverlay()
        overlayFrame.BackgroundTransparency = 1
        overlayFrame.Visible = true
        TweenService:Create(overlayFrame, TweenInfo.new(0.2), { BackgroundTransparency = 0 }):Play()
    end

    function hideOverlay()
        local tw = TweenService:Create(overlayFrame, TweenInfo.new(0.2), { BackgroundTransparency = 1 })
        tw:Play()
        tw.Completed:Connect(function()
            overlayFrame.Visible = false
            overlayFrame.BackgroundTransparency = 0
        end)
    end

    function sitInOwnVehicle()
        local veh = ws.Vehicles:FindFirstChild(localPlayer.Name)
        local hum_ = localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Humanoid")
        if not (veh and hum_ and not hum_.SeatPart) then return end
        local seat = veh:FindFirstChild("DriveSeat")
        if seat then seat:Sit(hum_) end
    end

    function startSeatLoop()
        if tpState.seatLoop then tpState.seatLoop:Disconnect() end
        tpState.seatLoop = RunService.Heartbeat:Connect(sitInOwnVehicle)
    end

    function stopSeatLoop()
        if tpState.seatLoop then tpState.seatLoop:Disconnect(); tpState.seatLoop = nil end
    end

    function killVehVelocity(veh)
        for _, d in ipairs(veh:GetDescendants()) do
            if d:IsA("BasePart") then
                d.AssemblyLinearVelocity = Vector3.zero
                d.AssemblyAngularVelocity = Vector3.zero
                d.Velocity = Vector3.zero
                d.RotVelocity = Vector3.zero
            end
        end
    end

    function applyVehicleCFrame(veh, cf)
        if not veh.PrimaryPart then return end
        veh:SetPrimaryPartCFrame(cf)
        killVehVelocity(veh)
    end

    function tweenVehicle(veh, targetCF, duration, onDone)
        if not veh.PrimaryPart then return end
        local val = Instance.new("CFrameValue")
        val.Value = veh:GetPrimaryPartCFrame()
        local conn = val:GetPropertyChangedSignal("Value"):Connect(function()
            if veh and veh.PrimaryPart then
                veh:SetPrimaryPartCFrame(val.Value)
                killVehVelocity(veh)
            end
        end)
        local tw = TweenService:Create(val, TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Value = targetCF })
        tw:Play()
        tw.Completed:Connect(function()
            conn:Disconnect()
            val:Destroy()
            if onDone then onDone() end
        end)
    end

    function doVehicleTeleport(target, onComplete)
        local veh = ws.Vehicles:FindFirstChild(localPlayer.Name)
        if not veh then return end
        if not veh.PrimaryPart then veh.PrimaryPart = veh:FindFirstChildWhichIsA("BasePart", true) end
        if not veh.PrimaryPart then return end

        local startPos = veh.PrimaryPart.Position
        local targetPos = target.Position
        tpState.target = targetPos

        showOverlay()

        local function finish()
            stopSeatLoop()
            tpState.camFlag = false
            tpState.target = nil
            if _G.SetAntiFall then _G.SetAntiFall(false) end
            hideOverlay()
            if onComplete then onComplete() end
        end

        local rot = veh.PrimaryPart.CFrame - veh.PrimaryPart.CFrame.Position
        local rot3 = target - target.Position

        task.spawn(function()
            applyVehicleCFrame(veh, CFrame.new(startPos.X, startPos.Y + 3, startPos.Z) * rot)
            task.wait(0.15)
            if not veh or not veh.Parent or not veh.PrimaryPart then finish() return end

            local risePos = Vector3.new(startPos.X, startPos.Y + 5000, startPos.Z)
            local done1 = false
            tweenVehicle(veh, CFrame.new(risePos) * rot, 1.2, function() done1 = true end)

            local t0 = tick()
            while not done1 and tick() - t0 < 1.5 do
                task.wait(0.05)
                if not veh or not veh.Parent or not veh.PrimaryPart then finish() return end
            end
            if not veh or not veh.Parent or not veh.PrimaryPart then finish() return end

            local midPos = Vector3.new(targetPos.X, startPos.Y + 5000, targetPos.Z)
            local done2 = false
            tweenVehicle(veh, CFrame.new(midPos) * rot, 2.5, function() done2 = true end)

            local t1 = tick()
            while not done2 and tick() - t1 < 3 do
                task.wait(0.05)
                if not veh or not veh.Parent or not veh.PrimaryPart then finish() return end
            end
            if not veh or not veh.Parent or not veh.PrimaryPart then finish() return end

            local dropPos30 = Vector3.new(targetPos.X, targetPos.Y + 30, targetPos.Z)
            tweenVehicle(veh, CFrame.new(dropPos30) * rot3, 0.6, function() end)

            local t2 = tick()
            while tick() - t2 < 0.7 do
                task.wait(0.05)
                if not veh or not veh.Parent or not veh.PrimaryPart then finish() return end
            end
            if not veh or not veh.Parent or not veh.PrimaryPart then finish() return end

            if _G.SetAntiFall then _G.SetAntiFall(true) end

            local dropPos = Vector3.new(targetPos.X, targetPos.Y + 4, targetPos.Z)
            tweenVehicle(veh, CFrame.new(dropPos) * rot3, 0.5, function() end)

            local t3 = tick()
            while tick() - t3 < 0.6 do
                task.wait(0.05)
                if not veh or not veh.Parent or not veh.PrimaryPart then finish() return end
            end

            if _G.SetAntiFall then _G.SetAntiFall(false) end

            task.wait(0.1)
            finish()
            if _G.BringOwnCarButtonAction then _G.BringOwnCarButtonAction() end
        end)
    end

    function doTeleport(target, onComplete)
        tpState.camFlag = true
        tpState.special = false
        sitInOwnVehicle()
        startSeatLoop()
        task.wait(0.5)
        doVehicleTeleport(target, onComplete)
    end

    function doSpecialTeleport(target, onComplete)
        tpState.camFlag = true
        tpState.special = true
        sitInOwnVehicle()
        startSeatLoop()
        task.wait(0.5)
        doVehicleTeleport(target, onComplete)
    end

    _G.tp = doTeleport
    _G.tpSpecial = doSpecialTeleport

    function grabMyCar()
        local char = localPlayer.Character or localPlayer.CharacterAdded:Wait()
        local hrp_ = char:WaitForChild("HumanoidRootPart")
        local hum_ = char:FindFirstChildWhichIsA("Humanoid")
        local folder = ws:FindFirstChild("Vehicles")
        local veh = folder and folder:FindFirstChild(localPlayer.Name)
        if not (veh and veh:IsA("Model")) then return end

        local seat = veh:FindFirstChild("DriveSeat") or veh:FindFirstChildWhichIsA("VehicleSeat")
        if not seat then return end
        if not veh.PrimaryPart then veh.PrimaryPart = seat end

        veh:SetPrimaryPartCFrame(hrp_.CFrame * CFrame.new(0, 3, -8))
        task.wait(0.2)
        if hum_ and not hum_.SeatPart then seat:Sit(hum_) end
    end

    _G.BringOwnCarButtonAction = grabMyCar

    tpLocations = {
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

    function nearestModel(modelName, attrName)
        local nearest = math.huge
        local best = nil
        local hrp_ = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not hrp_ then return nil end
        for _, d in ipairs(ws:GetDescendants()) do
            if d:IsA("Model") and (d.Name == modelName or (attrName and d:GetAttribute(attrName))) then
                local pp = d.PrimaryPart or d:FindFirstChildWhichIsA("BasePart")
                if pp then
                    local dist = (hrp_.Position - pp.Position).Magnitude
                    if dist < nearest then nearest = dist; best = pp end
                end
            end
        end
        return best and best.CFrame
    end

    function nearestVendingMachine()
        local nearest = math.huge
        local best = nil
        local hrp_ = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not hrp_ then return nil end
        for _, d in ipairs(ws:GetDescendants()) do
            if d:IsA("Model") and d.Name == "Vending Machine" then
                for _, c in ipairs(d:GetChildren()) do
                    if c:IsA("BasePart") and c.Name == "Light" and c.Color == Color3.fromRGB(73, 147, 0) then
                        local dist = (hrp_.Position - c.Position).Magnitude
                        if dist < nearest then nearest = dist; best = c end
                    end
                end
            end
        end
        return best and best.CFrame
    end

    function pickHarborSpot()
        local options = {
            CFrame.new(-391.25955200195312, 5.7987871170043945, 3517.556640625),
            CFrame.new(1166.626220703125, 29.150341033935547, 2157.30029296875),
        }
        return options[math.random(1, 2)]
    end

    function teleportToLocation(name)
        local target = tpLocations[name]
        if not target then return end
        if target == "SPECIAL_DEALER" then
            local d = nearestModel("Dealer", "Dealer")
            if d then doSpecialTeleport(d) end
        elseif target == "SPECIAL_SMUGGLER" then
            local s = nearestModel("Smuggler")
            if s then doSpecialTeleport(s) end
        elseif target == "SPECIAL_VENDING" then
            local v = nearestVendingMachine()
            if v then doSpecialTeleport(v) end
        elseif target == "HARBOR_CONTAINER" then
            local h = pickHarborSpot()
            if h then doTeleport(h) end
        else
            doTeleport(target)
        end
    end

    TeleportTab:AddSection({ Name = "Fast Teleports" })

    TeleportTab:AddButton({
        Name = "Teleport to Dealer",
        Callback = function()
            local d = nearestModel("Dealer", "Dealer")
            if d and _G.tpSpecial then _G.tpSpecial(d) end
        end
    })

    TeleportTab:AddButton({
        Name = "Teleport to Smuggler",
        Callback = function()
            local s = nearestModel("Smuggler")
            if s and _G.tpSpecial then _G.tpSpecial(s) end
        end
    })

    TeleportTab:AddButton({
        Name = "Teleport to Vending Machine",
        Callback = function()
            local v = nearestVendingMachine()
            if v and _G.tpSpecial then _G.tpSpecial(v) end
        end
    })

    TeleportTab:AddButton({
        Name = "Teleport to Nearest Wanted Player",
        Callback = function()
            local nearest = math.huge
            local best = nil
            local myHrp = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
            if not myHrp then return end

            for _, p in ipairs(game.Players:GetPlayers()) do
                if p ~= localPlayer and p.Character then
                    local hrp_ = p.Character:FindFirstChild("HumanoidRootPart")
                    if hrp_ and hrp_:GetAttribute("IsWanted") then
                        local dist = (myHrp.Position - hrp_.Position).Magnitude
                        if dist < nearest then nearest = dist; best = hrp_ end
                    end
                end
            end

            if best and _G.tpSpecial then _G.tpSpecial(best.CFrame) end
        end
    })

    TeleportTab:AddSection({ Name = "Locations" })
    TeleportTab:AddParagraph("Locations", "Use the Dropdowns below to teleport to various locations in the game.")

    workPlaces = { "Police Station", "Bus Company", "Fire Station", "ADAC", "Truck Company" }
    robPlaces = {
        "Bank", "Club", "Jeweler", "Harbor", "Gas-N-Go Fuel",
        "Ares Fuel", "Osso Fuel", "Clothing Store", "Farm Shop", "Tool Shop",
    }

    local excluded = {}
    for _, n in ipairs(workPlaces) do excluded[n] = true end
    for _, n in ipairs(robPlaces) do excluded[n] = true end

    otherPlaces = {}
    for name in pairs(tpLocations) do
        if not excluded[name] then table.insert(otherPlaces, name) end
    end
    table.sort(otherPlaces)

    firstFire = { work = true, rob = true, other = true }

    TeleportTab:AddDropdown({
        Name = "Work Places", Default = workPlaces[1], Options = workPlaces,
        Callback = function(sel)
            if firstFire.work then firstFire.work = false; return end
            teleportToLocation(sel)
        end
    })

    TeleportTab:AddDropdown({
        Name = "Robbable Places", Default = robPlaces[1], Options = robPlaces,
        Callback = function(sel)
            if firstFire.rob then firstFire.rob = false; return end
            teleportToLocation(sel)
        end
    })

    TeleportTab:AddDropdown({
        Name = "Others", Default = otherPlaces[1], Options = otherPlaces,
        Callback = function(sel)
            if firstFire.other then firstFire.other = false; return end
            teleportToLocation(sel)
        end
    })
end

FarmTab:AddSection({ Name = "Police Job" })

RemoteFolder = ReplicatedStorage:WaitForChild("2Wz")
RemoteRadarFarm = RemoteFolder:WaitForChild("3d4642d3-a886-4e77-b3a8-2f26ecceb51c")

FarmTab:AddToggle({
    Name = "RadarFarm", Default = false, Flag = "RadarFarmToggle",
    Callback = function(state)
        _G.RadarFarmEnabled = state
        if state then
            task.spawn(function()
                local lastScan = 0
                while _G.RadarFarmEnabled do
                    local now = tick()
                    if now - lastScan >= 1 then
                        local char = LocalPlayer.Character
                        if char then
                            local radarGun = char:FindFirstChild("Radar Gun")
                            if radarGun and RemoteRadarFarm then
                                local vf = workspace:FindFirstChild("Vehicles")
                                if vf then
                                    local vehicles = vf:GetChildren()
                                    local primaryPart = char.PrimaryPart
                                    if primaryPart then
                                        for i = 1, #vehicles do
                                            if not _G.RadarFarmEnabled then break end
                                            local v = vehicles[i]
                                            local driveSeat = v:FindFirstChild("DriveSeat")
                                            if driveSeat then
                                                RemoteRadarFarm:FireServer(radarGun, driveSeat.Position, (driveSeat.Position - primaryPart.Position).Unit)
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
    end
})

autoTaserToggle = false
predictionFactor = 0.22
maxTargetDistance = 20

RemoteAutoTaser = RemoteFolder:WaitForChild("cf170e4b-063f-4c0a-ba4d-920a0bb1941a")

FarmTab:AddToggle({
    Name = "Auto Taser", Default = false, Flag = "AutoTaser",
    Callback = function(Value) autoTaserToggle = Value end
})

function isPlayerOnSeat(p)
    local char = p.Character
    if not char then return false end
    local hum_ = char:FindFirstChildOfClass("Humanoid")
    if hum_ and hum_.Sit then return true end
    for _, part in ipairs(char:GetChildren()) do
        if part:IsA("BasePart") then
            local seat = part:FindFirstAncestorOfClass("VehicleSeat")
            if seat then return true end
        end
    end
    return false
end

function getBestTargetTaser()
    local myChar = LocalPlayer.Character
    if not (myChar and myChar:FindFirstChild("HumanoidRootPart")) then return end

    local bestTarget = nil
    local closest = maxTargetDistance

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local char = p.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local hrp_ = char.HumanoidRootPart
                if hrp_:GetAttribute("IsWanted") == true then
                    local hum_ = char:FindFirstChildOfClass("Humanoid")
                    if hum_ and hum_.Health > 30 and not isPlayerOnSeat(p) then
                        local dist = (myChar.HumanoidRootPart.Position - hrp_.Position).Magnitude
                        if dist < closest then
                            closest = dist
                            bestTarget = { player = p, part = hrp_, distance = dist }
                        end
                    end
                end
            end
        end
    end
    return bestTarget
end

RunService.Heartbeat:Connect(function()
    if not autoTaserToggle then return end
    local myChar = LocalPlayer.Character
    if not (myChar and myChar:FindFirstChild("HumanoidRootPart")) then return end
    local taser = myChar:FindFirstChild("Taser")
    if not taser then return end
    local target = getBestTargetTaser()
    if not target then return end

    local shootFrom = myChar.HumanoidRootPart.Position
    local predictedPos = target.part.Position + (target.part.Velocity * predictionFactor)

    pcall(function()
        RemoteAutoTaser:FireServer(taser, predictedPos, (predictedPos - shootFrom).Unit)
    end)
end)

MAX_DISTANCE = 7
ARREST_TIME = 3
isPressingE = false
isEnabled = false
pressStartTime = 0

VirtualInputManager = game:GetService("VirtualInputManager")

autoCuffGuiName = "AutoCuffTimerUI"
if CoreGui:FindFirstChild(autoCuffGuiName) then CoreGui[autoCuffGuiName]:Destroy() end

autoCuffGui = Instance.new("ScreenGui")
autoCuffGui.Name = autoCuffGuiName
autoCuffGui.Parent = (gethui and gethui()) or CoreGui

timerLabel = Instance.new("TextLabel")
timerLabel.Size = UDim2.new(0, 250, 0, 40)
timerLabel.Position = UDim2.new(0.5, 0, 0.85, 0)
timerLabel.AnchorPoint = Vector2.new(0.5, 0.5)
timerLabel.BackgroundTransparency = 0.4
timerLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
timerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
timerLabel.Font = Enum.Font.GothamBold
timerLabel.TextSize = 20
timerLabel.Text = "Cuffing: 0.0s"
timerLabel.Visible = false
timerLabel.Parent = autoCuffGui
Instance.new("UICorner", timerLabel).CornerRadius = UDim.new(0, 8)

function hasHandcuffsTool()
    if not LocalPlayer.Character then return false end
    for _, obj in pairs(LocalPlayer.Character:GetChildren()) do
        if obj:IsA("Tool") and obj.Name == "Handcuffs" then return true end
    end
    return false
end

function isWantedPlayer(p)
    return p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character.HumanoidRootPart:GetAttribute("IsWanted") == true
end

function startPressingE()
    if isPressingE then return end
    isPressingE = true
    pressStartTime = os.clock()
    timerLabel.Visible = true
    task.wait(0.1)
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
end

function stopPressingE()
    if not isPressingE then return end
    isPressingE = false
    timerLabel.Visible = false
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
end

RunService.Heartbeat:Connect(function()
    if not isEnabled then return end
    if not hasHandcuffsTool() then stopPressingE() return end

    local char = LocalPlayer.Character
    if not char then stopPressingE() return end
    local rootPart = char:FindFirstChild("HumanoidRootPart")
    if not rootPart then stopPressingE() return end

    local wantedPlayerInRange = false
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and isWantedPlayer(p) then
            local targetRoot = p.Character:FindFirstChild("HumanoidRootPart")
            if targetRoot then
                local dist = (rootPart.Position - targetRoot.Position).Magnitude
                if dist <= MAX_DISTANCE then wantedPlayerInRange = true break end
            end
        end
    end

    if wantedPlayerInRange then
        startPressingE()
        if isPressingE then
            local elapsed = os.clock() - pressStartTime
            local remaining = math.max(0, ARREST_TIME - elapsed)
            timerLabel.Text = string.format("Cuffed: %.1f s", remaining)
            local progress = math.clamp(elapsed / ARREST_TIME, 0, 1)
            timerLabel.TextColor3 = Color3.fromRGB(255 + (0 - 255) * progress, 50 + (255 - 50) * progress, 50)
        end
    else
        stopPressingE()
    end
end)

FarmTab:AddToggle({
    Name = "Auto Cuff",
    Callback = function(Value)
        isEnabled = Value
        if not isEnabled then stopPressingE() end
    end
})

autoStopStickToggle = false
RemoteStopStick = RemoteFolder:WaitForChild("b12dac7e-6ca5-476e-b71d-47f187fe51e6")

FarmTab:AddToggle({
    Name = "Auto Stop Stick", Default = false, Flag = "AutoStopStickToggle",
    Callback = function(Value) autoStopStickToggle = Value end
})

function isPlayerSitting(p)
    local char = p.Character
    if not char then return false end
    local hum_ = char:FindFirstChildOfClass("Humanoid")
    if not hum_ then return false end
    if hum_.Sit then return true end
    if hum_:FindFirstChild("SitController") then return true end
    return false
end

function getBestStopStickTarget()
    local myChar = LocalPlayer.Character
    if not (myChar and myChar:FindFirstChild("HumanoidRootPart")) then return end

    local bestTarget = nil
    local closest = 20

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local char = p.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local hrp_ = char.HumanoidRootPart
                if hrp_:GetAttribute("IsWanted") == true and isPlayerSitting(p) then
                    local hum_ = char:FindFirstChildOfClass("Humanoid")
                    if hum_ and hum_.Health > 0 then
                        local dist = (myChar.HumanoidRootPart.Position - hrp_.Position).Magnitude
                        if dist < closest then
                            closest = dist
                            bestTarget = { player = p, part = hrp_, distance = dist }
                        end
                    end
                end
            end
        end
    end
    return bestTarget
end

RunService.Heartbeat:Connect(function()
    if not autoStopStickToggle then return end
    local myChar = LocalPlayer.Character
    if not (myChar and myChar:FindFirstChild("HumanoidRootPart")) then return end

    local stopStick = myChar:FindFirstChild("StopStick") or myChar:FindFirstChild("Stop Stick")
    if not stopStick then return end

    local target = getBestStopStickTarget()
    if not target then return end

    local throwFrom = myChar.HumanoidRootPart.Position
    local predictedPos = target.part.Position + (target.part.Velocity * 0.22)

    if RemoteStopStick then
        RemoteStopStick:FireServer(stopStick, predictedPos, (predictedPos - throwFrom).Unit)
    end
end)

FarmTab:AddSection({ Name = "Anti-AFK" })

FarmTab:AddButton({
    Name = "Anti-AFK",
    Callback = function()
        VirtualUser = game:GetService("VirtualUser")
        Players.LocalPlayer.Idled:Connect(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new(0, 0))
        end)
    end
})

miscSettings = miscSettings or {
    player = LocalPlayer, runService = RunService, TweenService = TweenService,
    Players = Players, UserInputService = UserInputService,
    humanoid = nil, character = nil, spinBotEnabled = false, spinSpeed = 453453454353,
    flyingSpeed = 50, isFlying = false, attachment = nil, alignPosition = nil,
    alignOrientation = nil, AntiTaserEnabled = false, bypassActive = false,
    repelActive = false, stepSize = 0.3
}

UtilitySection = MiscTab:AddSection({ Name = "Utility Section" })

Lighting = game:GetService("Lighting")
local Terrain = workspace.Terrain

savedState = {
    QualityLevel = settings().Rendering.QualityLevel,
    SavedQualityLevel = Enum.SavedQualitySetting.Automatic,
    LightingTechnology = Lighting.Technology,
    GlobalShadows = Lighting.GlobalShadows,
    EnvironmentDiffuseScale = Lighting.EnvironmentDiffuseScale,
    EnvironmentSpecularScale = Lighting.EnvironmentSpecularScale,
    FogEnd = Lighting.FogEnd,
    WaterWaveSize = Terrain.WaterWaveSize,
    WaterWaveSpeed = Terrain.WaterWaveSpeed,
    WaterReflectance = Terrain.WaterReflectance,
    WaterTransparency = Terrain.WaterTransparency,
    PartMaterials = {}, DecalTransparencies = {}, Textures = {},
    ParticleLifetimes = {}, ExplosionSettings = {}, LightingEffects = {}
}

function enableFPSBoost()
    savedState.SavedQualityLevel = Enum.SavedQualitySetting.Automatic
    savedState.QualityLevel = settings().Rendering.QualityLevel
    savedState.LightingTechnology = Lighting.Technology
    savedState.GlobalShadows = Lighting.GlobalShadows
    savedState.EnvironmentDiffuseScale = Lighting.EnvironmentDiffuseScale
    savedState.EnvironmentSpecularScale = Lighting.EnvironmentSpecularScale
    savedState.FogEnd = Lighting.FogEnd
    savedState.WaterWaveSize = Terrain.WaterWaveSize
    savedState.WaterWaveSpeed = Terrain.WaterWaveSpeed
    savedState.WaterReflectance = Terrain.WaterReflectance
    savedState.WaterTransparency = Terrain.WaterTransparency

    for _, obj in ipairs(game:GetDescendants()) do
        if obj:IsA("BasePart") and not obj:IsA("Terrain") then
            savedState.PartMaterials[obj] = {Material = obj.Material, Reflectance = obj.Reflectance}
            obj.Material = Enum.Material.Plastic
            obj.Reflectance = 0
        elseif obj:IsA("Decal") then
            savedState.DecalTransparencies[obj] = obj.Transparency
            obj.Transparency = 1
        elseif obj:IsA("Texture") then
            savedState.Textures[obj] = obj.Texture
            obj.Texture = ""
        elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") then
            savedState.ParticleLifetimes[obj] = obj.Lifetime
            obj.Lifetime = NumberRange.new(0)
        elseif obj:IsA("Explosion") then
            savedState.ExplosionSettings[obj] = {BlastPressure = obj.BlastPressure, BlastRadius = obj.BlastRadius}
            obj.BlastPressure = 1
            obj.BlastRadius = 1
        end
    end

    for _, effect in ipairs(Lighting:GetDescendants()) do
        if effect:IsA("BlurEffect") or effect:IsA("SunRaysEffect") or effect:IsA("ColorCorrectionEffect")
            or effect:IsA("BloomEffect") or effect:IsA("DepthOfFieldEffect") then
            savedState.LightingEffects[effect] = effect.Enabled
            effect.Enabled = false
        end
    end

    Terrain.WaterWaveSize = 0
    Terrain.WaterWaveSpeed = 0
    Terrain.WaterReflectance = 0
    Terrain.WaterTransparency = 1
    Lighting.Technology = Enum.Technology.Compatibility
    Lighting.GlobalShadows = false
    Lighting.EnvironmentDiffuseScale = 0
    Lighting.EnvironmentSpecularScale = 0
    Lighting.FogEnd = 9e9
    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
end

function disableFPSBoost()
    settings().Rendering.QualityLevel = savedState.QualityLevel
    Lighting.Technology = savedState.LightingTechnology
    Lighting.GlobalShadows = savedState.GlobalShadows
    Lighting.EnvironmentDiffuseScale = savedState.EnvironmentDiffuseScale
    Lighting.EnvironmentSpecularScale = savedState.EnvironmentSpecularScale
    Lighting.FogEnd = savedState.FogEnd
    Terrain.WaterWaveSize = savedState.WaterWaveSize
    Terrain.WaterWaveSpeed = savedState.WaterWaveSpeed
    Terrain.WaterReflectance = savedState.WaterReflectance
    Terrain.WaterTransparency = savedState.WaterTransparency

    for obj, data in pairs(savedState.PartMaterials) do
        if obj and obj.Parent then obj.Material = data.Material; obj.Reflectance = data.Reflectance end
    end
    for obj, t in pairs(savedState.DecalTransparencies) do
        if obj and obj.Parent then obj.Transparency = t end
    end
    for obj, tex in pairs(savedState.Textures) do
        if obj and obj.Parent then obj.Texture = tex end
    end
    for obj, life in pairs(savedState.ParticleLifetimes) do
        if obj and obj.Parent then obj.Lifetime = life end
    end
    for obj, data in pairs(savedState.ExplosionSettings) do
        if obj and obj.Parent then obj.BlastPressure = data.BlastPressure; obj.BlastRadius = data.BlastRadius end
    end
    for obj, en in pairs(savedState.LightingEffects) do
        if obj and obj.Parent then obj.Enabled = en end
    end

    savedState.PartMaterials = {}
    savedState.DecalTransparencies = {}
    savedState.Textures = {}
    savedState.ParticleLifetimes = {}
    savedState.ExplosionSettings = {}
    savedState.LightingEffects = {}
end

UtilitySection:AddToggle({
    Name = "FPS Boost", Default = false, Flag = "FPSBoostToggle",
    Callback = function(enabled)
        if enabled then enableFPSBoost() else disableFPSBoost() end
    end
})

RemotePunch = ReplicatedStorage["2Wz"]["e7c49265-639e-4606-a0a0-e4fce406062c"]

autoPunchEnabled = false
punchDistance = 15

function getClosestEnemy()
    local closestEnemy = nil
    local shortest = punchDistance

    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local myHrp = LocalPlayer.Character.HumanoidRootPart
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Humanoid") then
                if p.Character.Humanoid.Health > 0 then
                    local enemyHrp = p.Character.HumanoidRootPart
                    local dist = (myHrp.Position - enemyHrp.Position).Magnitude
                    if dist < shortest then shortest = dist; closestEnemy = p end
                end
            end
        end
    end
    return closestEnemy
end

UtilitySection:AddToggle({
    Name = "Punch Aura", Default = false,
    Callback = function(Value) autoPunchEnabled = Value end
})

task.spawn(function()
    while true do
        task.wait(0.2)
        if autoPunchEnabled then
            local target = getClosestEnemy()
            if target then
                pcall(function() PunchEvent:FireServer() end)
            end
        end
    end
end)

xRayCache = {}
UtilitySection:AddToggle({
    Name = "xRay", Default = false, Flag = "XRayToggle",
    Callback = function(Value)
        if Value then
            for _, part in pairs(workspace:GetDescendants()) do
                if part:IsA("BasePart") and part.Parent ~= player.Character then
                    xRayCache[part] = part.LocalTransparencyModifier
                    part.LocalTransparencyModifier = 0.5
                end
            end
        else
            for part, value in pairs(xRayCache) do
                if part and part.Parent then part.LocalTransparencyModifier = value end
            end
            xRayCache = {}
        end
    end
})

for _, v in pairs(getgc(true)) do
    if type(v) == "function" and getinfo(v).name == "setStamina" then
        getfenv().infStaminaOriginal = v
        break
    end
end

UtilitySection:AddToggle({
    Name = "Inf Stamina", Default = false, Flag = "InfStamina",
    Callback = function(state)
        if not getfenv().infStaminaOriginal then return end
        if state then
            getfenv().infStaminaHook = hookfunction(getfenv().infStaminaOriginal, function(...) return ..., math.huge end)
        else
            if getfenv().infStaminaHook then
                hookfunction(getfenv().infStaminaOriginal, getfenv().infStaminaHook)
                getfenv().infStaminaHook = nil
            end
        end
    end
})

UtilitySection:AddButton({
    Name = "Change Server",
    Callback = function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, player)
    end
})

TrollSection = MiscTab:AddSection({ Name = "Troll Section" })

function canFly()
    return player.Character and player.Character:FindFirstChild("Humanoid") and player.Character:FindFirstChild("Humanoid").SeatPart == nil
end

function enableFly()
    if not canFly() then return false end
    local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
    local humanoid_ = player.Character:FindFirstChild("Humanoid")

    if miscSettings.attachment then miscSettings.attachment:Destroy() end
    if miscSettings.alignPosition then miscSettings.alignPosition:Destroy() end
    if miscSettings.alignOrientation then miscSettings.alignOrientation:Destroy() end

    miscSettings.attachment = Instance.new("Attachment")
    miscSettings.attachment.Parent = humanoidRootPart

    miscSettings.alignPosition = Instance.new("AlignPosition")
    miscSettings.alignPosition.Attachment0 = miscSettings.attachment
    miscSettings.alignPosition.Mode = Enum.PositionAlignmentMode.OneAttachment
    miscSettings.alignPosition.MaxForce = 5000
    miscSettings.alignPosition.Responsiveness = 45
    miscSettings.alignPosition.Parent = humanoidRootPart

    miscSettings.alignOrientation = Instance.new("AlignOrientation")
    miscSettings.alignOrientation.Attachment0 = miscSettings.attachment
    miscSettings.alignOrientation.Mode = Enum.OrientationAlignmentMode.OneAttachment
    miscSettings.alignOrientation.MaxTorque = 5000
    miscSettings.alignOrientation.Responsiveness = 45
    miscSettings.alignOrientation.Parent = humanoidRootPart

    humanoid_.PlatformStand = true
    miscSettings.isFlying = true

    local lastPosition = humanoidRootPart.Position
    miscSettings.alignPosition.Position = lastPosition

    task.spawn(function()
        while miscSettings.isFlying and player.Character and humanoidRootPart and humanoid_ do
            local moveDirection = humanoid_.MoveDirection
            local vertical = Vector3.zero

            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                vertical = vertical + Vector3.new(0, 1, 0)
            elseif UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                vertical = vertical - Vector3.new(0, 1, 0)
            end

            local combined = moveDirection + vertical

            if combined.Magnitude > 0 then
                local dir = combined.Unit
                local newPosition = lastPosition + (dir * miscSettings.flyingSpeed * RunService.Heartbeat:Wait())
                miscSettings.alignPosition.Position = newPosition
                lastPosition = newPosition
            else
                RunService.Heartbeat:Wait()
            end

            local camCFrame = workspace.CurrentCamera.CFrame
            miscSettings.alignOrientation.CFrame = CFrame.new(Vector3.new(), camCFrame.LookVector)
        end
    end)
    return true
end

function disableFly()
    miscSettings.isFlying = false
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character:FindFirstChild("Humanoid").PlatformStand = false
    end
    if miscSettings.attachment then miscSettings.attachment:Destroy() end
    if miscSettings.alignPosition then miscSettings.alignPosition:Destroy() end
    if miscSettings.alignOrientation then miscSettings.alignOrientation:Destroy() end
end

FlyToggle = TrollSection:AddToggle({
    Name = "Player Fly", Default = false, Flag = "FlyToggle",
    Callback = function(Value)
        if Value then
            if not enableFly() then FlyToggle:Set(false) end
        else
            disableFly()
        end
    end
})

if not isMobile then
    TrollSection:AddBind({
        Name = "Fly Bind", Default = Enum.KeyCode.J, Flag = "FlyKeybind",
        Callback = function()
            if miscSettings.isFlying then
                disableFly()
                FlyToggle:Set(false)
            else
                if enableFly() then FlyToggle:Set(true) else FlyToggle:Set(false) end
            end
        end
    })
end

TrollSection:AddSlider({
    Name = "Fly Speed", Min = 5, Max = 70, Default = 25,
    Increment = 1, ValueName = "Speed",
    Flag = "FlySpeedSlider",
    Callback = function(Value) miscSettings.flyingSpeed = Value end
})

player.CharacterAdded:Connect(function()
    if miscSettings.isFlying then
        task.wait(1)
        if FlyToggle.Value then enableFly() end
    end
end)

RunService.Heartbeat:Connect(function(deltaTime)
    if miscSettings.spinBotEnabled then
        local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if root then
            local currentCFrame = root.CFrame
            local rotation = CFrame.Angles(0, math.rad(miscSettings.spinSpeed * deltaTime), 0)
            root.CFrame = currentCFrame * rotation
        end
    end
end)

BypassSection = MiscTab:AddSection({ Name = "Bypass Section" })

BypassSection:AddButton({
    Name = "Bypass Freecam",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/4JrUuEqn"))()
        StarterGui:SetCore("SendNotification", {
            Title = "Freecam Bypass",
            Text = "Press Shift and P to Toggle Freecam Bypass",
            Image = "rbxassetid://",
            Duration = 6
        })
    end
})

ACBypass = {
    BLOCKED = {
        ["487daa5d-78bd-4c64-a171-d31a343fa1ad"] = true,
        ["64f1b6f7-b7c6-4f66-bf16-adca13762290"] = true,
        ["00cf801d-10a8-40b0-bf4e-bed26cc40f61"] = true,
        ["2f324a62-fa23-4ed9-803e-5813c0c524f8"] = true,
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
        end
    else
        ACBypass.supported = false
        function ACBypass.enable() warn("ACBypass: not supported") end
        function ACBypass.disable() warn("ACBypass: not supported") end
    end
end

shared.ACBypass = ACBypass

BypassSection:AddToggle({
    Name = "Anti Cheat Bypass", Default = false,
    Callback = function(state)
        if state then
            if ACBypass.supported then
                pcall(ACBypass.enable)
                Hydrogen:MakeNotification({ Name = "Anti Cheat Bypass", Content = "Activated!", Time = 3 })
            else
                Hydrogen:MakeNotification({ Name = "Error", Content = "Executor not supported!", Time = 5 })
            end
        else
            pcall(ACBypass.disable)
            Hydrogen:MakeNotification({ Name = "Anti Cheat Bypass", Content = "Deactivated!", Time = 3 })
        end
    end
})

AntiSection = MiscTab:AddSection({ Name = "Anti Section" })

AntiSection:AddToggle({
    Name = "Anti-Fall", Default = false, Flag = "AntiFallToggle",
    Callback = function(state)
        if state then
            getfenv().nofall = RunService.Heartbeat:Connect(function()
                local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                if root and root.Velocity.Y < -30 then
                    local ray = workspace:Raycast(root.Position, Vector3.new(0, -20, 0))
                    if ray then root.Velocity = Vector3.zero end
                end
            end)
        elseif getfenv().nofall then
            getfenv().nofall:Disconnect()
            getfenv().nofall = nil
        end
    end
})

AntiSection:AddToggle({
    Name = "Anti-Taser", Default = false, Flag = "AntiTaserToggle",
    Callback = function(state) miscSettings.AntiTaserEnabled = state end
})

RunService.Heartbeat:Connect(function()
    if miscSettings.AntiTaserEnabled and player.Character then
        player.Character:SetAttribute("Tased", false)
    end
end)

AntiEnabled = false

RunService.Stepped:Connect(function()
    if not AntiEnabled then return end
    local char = player.Character
    if not char then return end
    local hum_ = char:FindFirstChildOfClass("Humanoid")
    if not hum_ then return end

    hum_.PlatformStand = false
    hum_:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)

    local state = hum_:GetState()
    if state == Enum.HumanoidStateType.Physics
        or state == Enum.HumanoidStateType.Ragdoll
        or state == Enum.HumanoidStateType.FallingDown then
        hum_:ChangeState(Enum.HumanoidStateType.GettingUp)
    end
    if hum_:GetAttribute("Tased") ~= nil then hum_:SetAttribute("Tased", false) end

    local seat = hum_.SeatPart
    if seat then
        seat.Disabled = false
        seat:SetAttribute("Ragdoll", false)
        seat:SetAttribute("VehicleRagdoll", false)
    end
end)

AntiSection:AddToggle({
    Name = "Anti-Ragdoll", Default = false, Flag = "AntiRagdollToggle",
    Callback = function(Value) AntiEnabled = Value end
})

AntiSection:AddToggle({
    Name = "Anti-Arrest", Default = false, Flag = "AntiArrestToggle",
    Callback = function(Value) miscSettings.repelActive = Value end
})

BlurEffect = Lighting:FindFirstChild("BlurEffect") or Lighting:FindFirstChildOfClass("BlurEffect")

AntiSection:AddToggle({
    Name = "Anti-Flashbang", Default = false, Flag = "AntiFlashbangToggle",
    Callback = function(Value)
        if Value then
            if BlurEffect then BlurEffect.Parent = workspace
            else
                BlurEffect = Lighting:FindFirstChild("BlurEffect") or Lighting:FindFirstChildOfClass("BlurEffect")
                if BlurEffect then BlurEffect.Parent = workspace end
            end
        else
            if BlurEffect then BlurEffect.Parent = Lighting end
        end
    end
})

lastRepelCheck = 0
function isEnemy(p)
    return p ~= player and p.TeamColor == BrickColor.new("Bright blue") and p.Character
end

function getNearbyEnemies()
    local now = tick()
    if now - lastRepelCheck < 0.2 then return {} end
    lastRepelCheck = now
    local list = {}
    for _, p in pairs(Players:GetPlayers()) do
        if isEnemy(p) then
            local enemyRoot = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
            if enemyRoot then
                local dist = (hrp.Position - enemyRoot.Position).Magnitude
                if dist < 35 then table.insert(list, {rootPart = enemyRoot, distance = dist}) end
            end
        end
    end
    return list
end

function repelFromEnemy(enemy)
    local dir = (hrp.Position - enemy.rootPart.Position).Unit
    local targetPos = hrp.Position + dir * (35 - enemy.distance)
    local tween = TweenService:Create(hrp, TweenInfo.new(0.3, Enum.EasingStyle.Linear), {CFrame = CFrame.new(targetPos)})
    tween:Play()
end

player.CharacterAdded:Connect(function()
    task.wait(0.1)
    hrp = player.Character:WaitForChild("HumanoidRootPart")
end)

RunService.Heartbeat:Connect(function()
    if not miscSettings.repelActive or not hrp then return end
    local nearby = getNearbyEnemies()
    if #nearby > 0 then
        table.sort(nearby, function(a, b) return a.distance < b.distance end)
        repelFromEnemy(nearby[1])
    end
end)

MovementSection = MiscTab:AddSection({ Name = "Movement Section" })

antiDownedConnection = nil
AntiSection:AddToggle({
    Name = "Anti-Downed", Default = false, Flag = "AntiDownedToggle",
    Callback = function(state)
        if state then
            local hum_ = player.Character:WaitForChild("Humanoid")
            antiDownedConnection = hum_:GetPropertyChangedSignal("Health"):Connect(function()
                hum_.Health = 0
            end)
        else
            if antiDownedConnection then antiDownedConnection:Disconnect(); antiDownedConnection = nil end
        end
    end
})

MovementSection:AddButton({
    Name = "Escape Car",
    Callback = function()
        local char = player.Character
        if not char then return end
        local hum_ = char:FindFirstChildOfClass("Humanoid")
        if not hum_ then return end
        if hum_.SeatPart then
            hum_.Sit = false
            task.wait(0.1)
            hum_:ChangeState(Enum.HumanoidStateType.Jumping)
            task.spawn(function()
                task.wait(0.2)
                if hum_.SeatPart then
                    hum_.Sit = false
                    local root = char:FindFirstChild("HumanoidRootPart")
                    if root then root.Velocity = root.Velocity + Vector3.new(0, 50, 0) end
                end
            end)
        end
    end
})

MovementSection:AddToggle({
    Name = "Inf Jump", Default = false, Flag = "InfJumpToggle",
    Callback = function(Value) getgenv().InfiniteJumpEnabled = Value end
})

UserInputService.JumpRequest:Connect(function()
    if getgenv().InfiniteJumpEnabled then
        local char = player.Character
        if char and char:FindFirstChildOfClass("Humanoid") then
            char:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
        end
    end
end)

MovementSection:AddToggle({
    Name = "SpinBot", Default = false, Flag = "SpinBotToggle",
    Callback = function(Value) miscSettings.spinBotEnabled = Value end
})

Window:MakeThemeTab({ SaveFile = "FluxHubTheme.json" })

local Info = Window:MakeTab({ Name = "Info", Icon = "rbxassetid://77860784119644" })
Info:AddLabel("Flux v1.2")
Info:AddParagraph("About", "Flux Scripts, for Emergency Hamburg. discord.gg/u9rWYketM2")
Info:AddButton({
    Name = "Reset Settings",
    Callback = function() Window:ResetConfig() end,
})

Hydrogen:Init()