-- Michelle Hub | WindUI
repeat task.wait() until game:IsLoaded()

local ok, WindUI = pcall(function()
    return loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
end)
if not ok or not WindUI then
    warn("WindUI failed:", WindUI)
    return
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local UserInputService = UIS
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RS = ReplicatedStorage
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")
local MaterialService = game:GetService("MaterialService")
local SoundService = game:GetService("SoundService")

local lp = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local CommF = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_")
local CommE = ReplicatedStorage:WaitForChild("Remotes"):FindFirstChild("CommE")
local Net = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Net")

local registerAttack = Net:FindFirstChild("RE/RegisterAttack")
local registerHit
pcall(function()
    registerHit = require(ReplicatedStorage.Modules.Net):RemoteEvent("RegisterHit", true)
end)
if not registerHit then
    registerHit = Net:FindFirstChild("RE/RegisterHit")
end
local ShootGunEvent = Net:FindFirstChild("RE/ShootGunEvent")
local Validator2 = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("Validator2")

local Config = {
    FastAttack = false, FAPlayers = true, FAMobs = true, FARange = 1000,
    BringMobs = false, BringRange = 3000,
    FruitM1 = false, VoidFruitM1 = false,
    FruitM1Players = true, FruitM1Mobs = true, VoidAllM1 = false,

    SafeGun = false, SafeMobs = true, SafePlayers = true, SafeSea = true, SafeRange = 500,
    SuperGun = false, SuperMobs = true, SuperPlayers = true, SuperSea = true, SuperRange = 500,
    Disappear = false,

    AutoV3 = false, AutoV4 = false, AutoPvP = false,
    InfiniteZoom = false, AntiAFK = true,
    Notifications = true,
    Fly = false, FlySpeed = 250, FlyVertical = 180, FlySmooth = true,
    WalkOnWater = false, AntiLava = false,
    SpeedEnabled = false, SpeedMode = "CFrame", SpeedValue = 50,

    Tracker = false,
    TrackerFly = false, TrackerFlySpeed = 275, TrackerOrbitRadius = 50,
    TrackerNoTpRange = 300, TrackerPositionMode = "orbit",
    AutoFlee = false, AutoFleeHP = 30,
    TweenNearest = false, TweenToPlayer = false, TweenSpeed = 350,
    TweenOX = 0, TweenOY = 1.5, TweenOZ = 3.5,
    InstaTP = false, Spectate = false, SelectedTrackPlayer = "Nearest",
    PredictionStrength = 0.1,

    M1Extender = false, M1Range = 50,
    GunClickSL = false,
    SilentPlayer = false, SilentNPC = false,
    AimMode = "360", AimPriority = "Nearest",
    ShowFOV = false, FOVMode = "V1", FOVRadius = 150, AimMaxRange = 2000,
    Tracer = false, TracerColor = "Red",
    SoruAutoAim = false, SoruAimMode = "360", SoruFOVType = "V1",
    SoruPriority = "Nearest", SoruFOVRadius = 150, SoruRange = 300, SoruShowFOV = false,
    ZBoostEnabled = false, ZBoostPower = 450, ZBoostDuration = 0.55,
    NoGfxMode = "Off",
    FlagJobId = "",
    FlagRegion = "Singapore",
    BypassTpNpc = false, BypassTpRange = 500, BypassTpMode = "Nearest", BypassTpAbove = true, BypassTpHeight = 12,
    LowGraphics = false, DisableShadows = false, NoFog = false,

    SkyEnabled = false, SkyType = "black storm",
    AmbientEnabled = false, AmbientType = "Rain",
    MinecraftTex = false,
    -- Blacklist persistence
    BL_Melee_Z = false, BL_Melee_X = false, BL_Melee_C = false, BL_Melee_V = false, BL_Melee_F = false,
    BL_Sword_Z = false, BL_Sword_X = false, BL_Sword_C = false, BL_Sword_V = false, BL_Sword_F = false,
    BL_Fruit_Z = false, BL_Fruit_X = false, BL_Fruit_C = false, BL_Fruit_V = false, BL_Fruit_F = false, BL_Fruit_TAP = false,
    BL_Gun_Z = false, BL_Gun_X = false, BL_Gun_C = false, BL_Gun_V = false, BL_Gun_F = false,
}


local CONFIG_FILE = "MichelleHub_Config.json"

local function Notify(title, content, duration)
    if not Config.Notifications then return end
    pcall(function()
        WindUI:Notify({ Title = title or "Michelle Hub", Content = content or "", Duration = duration or 2 })
    end)
end

local function SaveConfig()
    if not writefile then
        return false
    end
    local ok = pcall(function()
        local data = {}
        for k, v in pairs(Config) do
            local t = type(v)
            if t == "boolean" or t == "number" or t == "string" then
                data[k] = v
            end
        end
        local encoded = HttpService:JSONEncode(data)
        writefile(CONFIG_FILE, encoded)
        pcall(function()
            if makefolder and not isfolder("MichelleHub") then makefolder("MichelleHub") end
            writefile("MichelleHub/Config.json", encoded)
        end)
    end)
    return ok == true
end

local function LoadConfig()
    pcall(function()
        if not (isfile and readfile) then return end
        local raw = nil
        if isfile(CONFIG_FILE) then
            raw = readfile(CONFIG_FILE)
        elseif isfile("MichelleHub/Config.json") then
            raw = readfile("MichelleHub/Config.json")
        end
        if not raw or raw == "" then return end
        local data = HttpService:JSONDecode(raw)
        if type(data) ~= "table" then return end
        for k, v in pairs(data) do
            if Config[k] ~= nil and type(Config[k]) == type(v) then
                Config[k] = v
            end
        end
    end)
end

LoadConfig()
task.spawn(function()
    while true do
        task.wait(5)
        SaveConfig()
    end
end)
pcall(function() game:BindToClose(function() SaveConfig() end) end)
local function save()
    task.defer(SaveConfig)
end

local character = lp.Character or lp.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
lp.CharacterAdded:Connect(function(c)
    character = c
    humanoidRootPart = c:WaitForChild("HumanoidRootPart")
end)
local savedZoom = lp.CameraMaxZoomDistance

local function isAlive(model)
    if not model or not model.Parent then return false end
    local hum = model:FindFirstChildOfClass("Humanoid")
    local root = model:FindFirstChild("HumanoidRootPart") or model.PrimaryPart
    return hum and hum.Health > 0 and root ~= nil
end

local function getFruit()
    local char, bp = lp.Character, lp:FindFirstChild("Backpack")
    for _, container in ipairs({ char, bp }) do
        if container then
            for _, t in ipairs(container:GetChildren()) do
                if t:IsA("Tool") and (t.ToolTip == "Blox Fruit" or t:GetAttribute("WeaponType") == "Demon Fruit" or t.Name:find("-")) then
                    return t
                end
            end
        end
    end
end

-- ==================== Z BOOST ====================
local boostGui = nil
local function destroyBoostGui()
    if boostGui then boostGui:Destroy() boostGui = nil end
end
local function doBoost()
    if not Config.ZBoostEnabled then return end
    local char = lp.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local dir = Camera.CFrame.LookVector
    local att = Instance.new("Attachment")
    att.Parent = hrp
    local lv = Instance.new("LinearVelocity")
    lv.MaxForce = 99999999
    lv.VelocityConstraintMode = Enum.VelocityConstraintMode.Vector
    lv.VectorVelocity = dir * Config.ZBoostPower
    lv.Attachment0 = att
    lv.Parent = hrp
    task.delay(Config.ZBoostDuration, function()
        if lv and lv.Parent then lv:Destroy() end
        if att and att.Parent then att:Destroy() end
    end)
end
local function createBoostGui()
    destroyBoostGui()
    local gui = Instance.new("ScreenGui")
    gui.Name = "MichelleZBoost"
    gui.ResetOnSpawn = false
    gui.Parent = lp:WaitForChild("PlayerGui")
    boostGui = gui
    local f = Instance.new("Frame", gui)
    f.Size = UDim2.new(0, 90, 0, 42)
    f.Position = UDim2.new(0.37, 0, 0.26, 0)
    f.BackgroundColor3 = Color3.fromRGB(75, 30, 135)
    f.Active = true
    f.Draggable = true
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 12)
    local zBtn = Instance.new("TextButton", f)
    zBtn.Size = UDim2.new(0, 40, 0, 30)
    zBtn.Position = UDim2.new(0, 12, 0, 6)
    zBtn.BackgroundColor3 = Color3.fromRGB(210, 140, 255)
    zBtn.Text = "Z"
    zBtn.TextSize = 18
    zBtn.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", zBtn).CornerRadius = UDim.new(0, 8)
    zBtn.MouseButton1Click:Connect(function()
        doBoost()
        zBtn.Text = "!"
        zBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 80)
        task.wait(0.35)
        zBtn.Text = "Z"
        zBtn.BackgroundColor3 = Color3.fromRGB(210, 140, 255)
    end)
end
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Z and Config.ZBoostEnabled then doBoost() end
end)

-- ==================== FAST ATTACK ====================
task.spawn(function()
    while true do
        task.wait(0.08)
        if not Config.FastAttack then continue end
        pcall(function()
            local char = lp.Character
            if not char then return end
            local myHRP = char:FindFirstChild("HumanoidRootPart")
            if not myHRP then return end
            local Mod = RS:FindFirstChild("Modules")
            local Net2 = Mod and Mod:FindFirstChild("Net")
            local RA2 = Net2 and Net2:FindFirstChild("RE/RegisterAttack")
            local RH2 = Net2 and Net2:FindFirstChild("RE/RegisterHit")
            if not RA2 or not RH2 then return end
            local myPos = myHRP.Position
            local all = {}
            if Config.FAPlayers then
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= lp and p.Character then
                        local pH = p.Character:FindFirstChildOfClass("Humanoid")
                        local pR = p.Character:FindFirstChild("HumanoidRootPart")
                        local pHd = p.Character:FindFirstChild("Head")
                        if pH and pR and pHd and pH.Health > 0 and (pR.Position - myPos).Magnitude <= Config.FARange then
                            all[#all + 1] = { p.Character, pHd }
                        end
                    end
                end
            end
            if Config.FAMobs then
                local en = workspace:FindFirstChild("Enemies")
                if en then
                    for _, n in pairs(en:GetChildren()) do
                        local nH = n:FindFirstChildOfClass("Humanoid")
                        local nR = n:FindFirstChild("HumanoidRootPart")
                        local nHd = n:FindFirstChild("Head")
                        if nH and nR and nHd and nH.Health > 0 and (nR.Position - myPos).Magnitude <= Config.FARange then
                            all[#all + 1] = { n, nHd }
                        end
                    end
                end
            end
            if #all > 0 then
                RA2:FireServer(0)
                for _, t in pairs(all) do
                    pcall(function() RH2:FireServer(t[2], all) end)
                end
            end
        end)
    end
end)

-- ==================== FRUIT M1 ====================
local FruitM1 = { maxVec = Vector3.new(9e30, 9e30, 9e30), on = false, conn = nil, clickConn = nil, fbCombo = 1 }
function FruitM1.GetFruit() return getFruit() end
function FruitM1.IsTrex(tool) return tool and tool.Name == "T-Rex-T-Rex" end
function FruitM1.IsDragon(tool) return tool and tool.Name == "Dragon-Dragon" end
function FruitM1.IsBlade(tool) return tool and tool.Name == "Blade-Blade" end
function FruitM1.IsPain(tool) return tool and tool.Name == "Pain-Pain" end
function FruitM1.IsControl(tool) return tool and tool.Name == "Control-Control" end
function FruitM1.IsGas(tool) return tool and tool.Name == "Gas-Gas" end
function FruitM1.MaxCombo(tool)
    if FruitM1.IsTrex(tool) then return 4 end
    if FruitM1.IsBlade(tool) then return 2 end
    if FruitM1.IsPain(tool) then return 4 end
    if FruitM1.IsControl(tool) then return 4 end
    if FruitM1.IsGas(tool) then return 5 end
    if FruitM1.IsDragon(tool) then
        local char = lp.Character
        return (char and char:FindFirstChild("DragonHybrid")) and 5 or 3
    end
    return 5
end
function FruitM1.TapInterval(combo, maxCombo)
    if Config.VoidFruitM1 and combo and maxCombo and combo >= maxCombo then return 1 end
    local char = lp.Character
    local cd = char and (char:GetAttribute("FruitTAPCooldown") or 0) or 0
    return 0.2 - cd
end
function FruitM1.SetNormal(enabled)
    FruitM1.on = enabled
    if FruitM1.conn then pcall(task.cancel, FruitM1.conn) FruitM1.conn = nil end
    if FruitM1.clickConn then pcall(task.cancel, FruitM1.clickConn) FruitM1.clickConn = nil end
    if not enabled then return end

    -- Fast attack de fruits SIN equipar + prediction (LeftClickRemote)
    FruitM1.conn = task.spawn(function()
        local PingService = game:GetService("Stats")
        while FruitM1.on do
            local ok, err = pcall(function()
                local fruit = FruitM1.GetFruit() -- busca en Backpack y Character
                local char = lp.Character
                local myHRP = char and char:FindFirstChild("HumanoidRootPart")
                if not fruit or not myHRP then return end

                local remote = fruit:FindFirstChild("LeftClickRemote")
                if not remote then return end

                local stun = char:FindFirstChild("Stun")
                local busy = char:FindFirstChild("Busy")
                if (stun and stun.Value and stun.Value > 0) or (busy and busy.Value) then return end

                local range = 600
                local bestHRP, bestDist, bestVel

                -- Players
                for _, player in ipairs(Players:GetPlayers()) do
                    if player ~= lp and player.Character then
                        local thrp = player.Character:FindFirstChild("HumanoidRootPart")
                        local hum = player.Character:FindFirstChildOfClass("Humanoid")
                        if thrp and hum and hum.Health > 0 then
                            local d = (thrp.Position - myHRP.Position).Magnitude
                            if d < range and (not bestDist or d < bestDist) then
                                bestHRP, bestDist = thrp, d
                                bestVel = thrp.AssemblyLinearVelocity
                            end
                        end
                    end
                end
                -- NPCs / Mobs
                local enemies = Workspace:FindFirstChild("Enemies")
                if enemies then
                    for _, npc in ipairs(enemies:GetChildren()) do
                        if npc:IsA("Model") then
                            local thrp = npc:FindFirstChild("HumanoidRootPart")
                            local hum = npc:FindFirstChildOfClass("Humanoid")
                            if thrp and hum and hum.Health > 0 then
                                local d = (thrp.Position - myHRP.Position).Magnitude
                                if d < range and (not bestDist or d < bestDist) then
                                    bestHRP, bestDist = thrp, d
                                    bestVel = thrp.AssemblyLinearVelocity
                                end
                            end
                        end
                    end
                end

                if not bestHRP then return end

                -- Prediction: velocity + ping
                local ping = 0.05
                pcall(function()
                    ping = PingService.Network.ServerStatsItem["Data Ping"]:GetValue() / 1000
                end)
                local predTime = math.clamp(ping * 1.35 + 0.04, 0.04, 0.28)
                local predPos = bestHRP.Position + (bestVel or Vector3.zero) * predTime
                local dir = (predPos - myHRP.Position) * Vector3.new(1, 0, 1)
                if dir.Magnitude < 0.1 then
                    dir = myHRP.CFrame.LookVector
                else
                    dir = dir.Unit
                end

                local maxCombo = FruitM1.MaxCombo(fruit)
                if maxCombo < 1 then maxCombo = 1 end
                local combo = FruitM1.fbCombo or 1
                local isSpecial = FruitM1.IsTrex(fruit) or FruitM1.IsDragon(fruit)
                    or FruitM1.IsBlade(fruit) or FruitM1.IsGas(fruit)
                    or FruitM1.IsPain(fruit) or FruitM1.IsControl(fruit)

                if isSpecial then
                    remote:FireServer(dir, combo)
                else
                    remote:FireServer(dir, combo, true)
                end
                FruitM1.fbCombo = (combo < maxCombo) and (combo + 1) or 1
            end)
            task.wait(0.05) -- spam rapido para que peguen todos los clicks
        end
    end)
end

-- ==================== GUN AURA ====================
local function GetBestPart(model)
    return model:FindFirstChild("HumanoidRootPart") or model:FindFirstChild("Head") or model.PrimaryPart
end

local ShootFunction, getupval, setupval, getupvals
pcall(function()
    getupval = debug.getupvalue or getupvalue
    setupval = debug.setupvalue or setupvalue
    getupvals = debug.getupvalues or getupvalues
end)
local V_Idx = { v26 = 12, v22 = 13, v25 = 14, v21 = 15, v23 = 16, v24 = 17, v27 = 18 }
local function InitDragonGun()
    local ok2, result = pcall(require, ReplicatedStorage:WaitForChild("Controllers"):WaitForChild("CombatController"))
    if ok2 and type(result) == "table" and result.Attack and getupval then
        ShootFunction = getupval(result.Attack, 9)
    end
end
local function GetNextValidator()
    if not getupval then return 0, 0 end
    if not ShootFunction then InitDragonGun() end
    if not ShootFunction then return 0, 0 end
    local upvals = getupvals and getupvals(ShootFunction)
    if not upvals then return 0, 0 end
    if upvals[V_Idx.v21] ~= 727595 then
        for i, v in pairs(upvals) do
            if v == 727595 then
                local o = i - 15
                V_Idx.v21 = i; V_Idx.v22 = 13 + o; V_Idx.v23 = 16 + o; V_Idx.v24 = 17 + o
                V_Idx.v26 = 12 + o; V_Idx.v25 = 14 + o; V_Idx.v27 = 18 + o
                break
            end
        end
    end
    local v1 = getupval(ShootFunction, V_Idx.v21)
    local v2 = getupval(ShootFunction, V_Idx.v22)
    local v3 = getupval(ShootFunction, V_Idx.v23)
    local v4 = getupval(ShootFunction, V_Idx.v24)
    local v5 = getupval(ShootFunction, V_Idx.v25)
    local v6 = getupval(ShootFunction, V_Idx.v26)
    local v7 = getupval(ShootFunction, V_Idx.v27)
    if not (v1 and v2 and v3 and v4 and v5 and v6 and v7) then return 0, 0 end
    local v9 = ((v5 * v2 + v6 * v1) % v3 * v3 + v6 * v2) % v4
    v5 = math.floor(v9 / v3); v6 = v9 - v5 * v3; v7 = v7 + 1
    setupval(ShootFunction, V_Idx.v25, v5)
    setupval(ShootFunction, V_Idx.v26, v6)
    setupval(ShootFunction, V_Idx.v27, v7)
    return math.floor(v9 / v4 * 16777215), v7
end

local function GetClosestGunTarget(range, doPlayers, doMobs, doSea)
    local root = humanoidRootPart
    if not root then return nil end
    local closest, dist, myPos = nil, math.huge, root.Position
    if doMobs then
        local ef = Workspace:FindFirstChild("Enemies")
        if ef then
            for _, enemy in pairs(ef:GetChildren()) do
                local h = enemy:FindFirstChildOfClass("Humanoid")
                local r = GetBestPart(enemy)
                if h and h.Health > 0 and r then
                    local d = (r.Position - myPos).Magnitude
                    if d < dist and d <= range then dist = d; closest = r end
                end
            end
        end
    end
    if doPlayers then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= lp and player.Character then
                local h = player.Character:FindFirstChildOfClass("Humanoid")
                local r = GetBestPart(player.Character)
                if h and h.Health > 0 and r then
                    local d = (r.Position - myPos).Magnitude
                    if d < dist and d <= range then dist = d; closest = r end
                end
            end
        end
    end
    if doSea then
        for _, folderName in ipairs({ "SeaEvent", "SeaEvents", "Boats", "Ships" }) do
            local folder = Workspace:FindFirstChild(folderName)
            if folder then
                for _, obj in pairs(folder:GetDescendants()) do
                    if obj:IsA("Model") then
                        local h = obj:FindFirstChildOfClass("Humanoid")
                        local r = GetBestPart(obj)
                        if h and h.Health > 0 and r then
                            local d = (r.Position - myPos).Magnitude
                            if d < dist and d <= range then dist = d; closest = r end
                        end
                    end
                end
            end
        end
    end
    return closest
end

local _cachedToolSafe, _cachedTargetSafe, _timerSafe = nil, nil, 0
local _cachedToolSuper, _cachedTargetSuper, _timerSuper = nil, nil, 0

task.spawn(function()
    while true do
        if not Config.SafeGun then task.wait(0.05) continue end
        pcall(function()
            local char = lp.Character
            if not char then return end
            if not _cachedToolSafe or not _cachedToolSafe.Parent or _cachedToolSafe.ToolTip ~= "Gun" then
                _cachedToolSafe = char:FindFirstChildOfClass("Tool")
                if not _cachedToolSafe or _cachedToolSafe.ToolTip ~= "Gun" then _cachedToolSafe = nil return end
            end
            _timerSafe = _timerSafe + 1
            if _timerSafe >= 3 or not _cachedTargetSafe or not _cachedTargetSafe.Parent then
                _cachedTargetSafe = GetClosestGunTarget(Config.SafeRange, Config.SafePlayers, Config.SafeMobs, Config.SafeSea)
                _timerSafe = 0
            end
            if not _cachedTargetSafe then return end
            local valCode, valCount = GetNextValidator()
            if valCode ~= 0 and Validator2 then pcall(function() Validator2:FireServer(valCode, valCount) end) end
            _cachedToolSafe:SetAttribute("LocalOverheat", 0)
            _cachedToolSafe:SetAttribute("IsReloading_Client", false)
            _cachedToolSafe:SetAttribute("LocalShotsLeft", 100)
            if ShootGunEvent then ShootGunEvent:FireServer(_cachedTargetSafe.Position, { _cachedTargetSafe }) end
        end)
        task.wait(0.03)
    end
end)

task.spawn(function()
    while true do
        if not Config.SuperGun then task.wait(0.05) continue end
        pcall(function()
            local char = lp.Character
            if not char then return end
            if not _cachedToolSuper or not _cachedToolSuper.Parent or _cachedToolSuper.ToolTip ~= "Gun" then
                _cachedToolSuper = char:FindFirstChildOfClass("Tool")
                if not _cachedToolSuper or _cachedToolSuper.ToolTip ~= "Gun" then _cachedToolSuper = nil return end
            end
            _timerSuper = _timerSuper + 1
            if _timerSuper >= 3 or not _cachedTargetSuper or not _cachedTargetSuper.Parent then
                _cachedTargetSuper = GetClosestGunTarget(Config.SuperRange, Config.SuperPlayers, Config.SuperMobs, Config.SuperSea)
                _timerSuper = 0
            end
            if not _cachedTargetSuper then return end
            local valCode, valCount = GetNextValidator()
            if valCode ~= 0 and Validator2 then pcall(function() Validator2:FireServer(valCode, valCount) end) end
            _cachedToolSuper:SetAttribute("LocalOverheat", 0)
            _cachedToolSuper:SetAttribute("IsReloading_Client", false)
            _cachedToolSuper:SetAttribute("LocalShotsLeft", 100)
            if ShootGunEvent then ShootGunEvent:FireServer(_cachedTargetSuper.Position, { _cachedTargetSuper }) end
        end)
        task.wait(0.03)
    end
end)

-- ==================== DISAPPEAR ====================
local disappearConn = nil
local function setDisappear(on)
    Config.Disappear = on
    if disappearConn then task.cancel(disappearConn) disappearConn = nil end
    if not on then return end
    disappearConn = task.spawn(function()
        while Config.Disappear do
            task.wait(0.1)
            pcall(function()
                if sethiddenproperty then sethiddenproperty(lp, "SimulationRadius", math.huge) end
                local enemies = Workspace:FindFirstChild("Enemies")
                if not enemies then return end
                for _, mob in ipairs(enemies:GetChildren()) do
                    local root = mob:FindFirstChild("HumanoidRootPart")
                    if root then
                        pcall(function() root.CFrame = CFrame.new(0, -500, 0) end)
                    end
                end
            end)
        end
    end)
end
UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.P then
        setDisappear(not Config.Disappear)
    end
end)

-- ==================== BRING MOBS ====================
RunService.Heartbeat:Connect(function()
    if not Config.BringMobs then return end
    pcall(function()
        local hrp = humanoidRootPart
        if not hrp then return end
        if sethiddenproperty then pcall(function() sethiddenproperty(lp, "SimulationRadius", math.huge) end) end
        local targetPos = hrp.Position
        local enemies = Workspace:FindFirstChild("Enemies")
        if not enemies then return end
        for _, enemy in ipairs(enemies:GetChildren()) do
            if enemy:IsA("Model") then
                local eHum = enemy:FindFirstChildOfClass("Humanoid")
                local eRoot = enemy:FindFirstChild("HumanoidRootPart")
                if eHum and eRoot and eHum.Health > 0 then
                    if (eRoot.Position - targetPos).Magnitude <= Config.BringRange then
                        eRoot.CFrame = CFrame.new(targetPos.X, targetPos.Y - 18, targetPos.Z)
                        eRoot.CanCollide = false
                        eHum.WalkSpeed = 0
                        eHum.JumpPower = 0
                    end
                end
            end
        end
    end)
end)

-- ==================== TRACKER FLY ====================
local trackerConn = nil
local function StartTrackerFly()
    if trackerConn then return end
    trackerConn = RunService.Heartbeat:Connect(function()
        if not Config.TrackerFly then return end
        local hrp = humanoidRootPart
        if not hrp then return end
        local closest, dist = nil, math.huge
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= lp and p.Character then
                local r = p.Character:FindFirstChild("HumanoidRootPart")
                local h = p.Character:FindFirstChildOfClass("Humanoid")
                if r and h and h.Health > 0 then
                    local d = (r.Position - hrp.Position).Magnitude
                    if d < dist then dist = d; closest = r end
                end
            end
        end
        if closest and dist > 8 then
            local dir = (closest.Position - hrp.Position)
            if dir.Magnitude > 0 then
                local step = math.min(Config.TrackerFlySpeed * 0.03, dir.Magnitude - Config.TrackerOrbitRadius)
                if step > 0 then
                    hrp.CFrame = hrp.CFrame + dir.Unit * step
                end
            end
        end
    end)
end
local function StopTrackerFly()
    if trackerConn then trackerConn:Disconnect(); trackerConn = nil end
end

-- ==================== CESTIAN-STYLE TWEEN / INSTA / SPECTATE ====================
local TweenService = game:GetService("TweenService")
local activeTrackTween = nil
local function getTrackTargetHRP()
    local name = Config.SelectedTrackPlayer or "Nearest"
    if name ~= "Nearest" then
        local p = Players:FindFirstChild(name)
        if p and p.Character then
            return p.Character:FindFirstChild("HumanoidRootPart"), p
        end
        return nil, nil
    end
    local my = humanoidRootPart
    if not my then return nil, nil end
    local best, bd, bp = nil, math.huge, nil
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= lp and p.Character then
            local r = p.Character:FindFirstChild("HumanoidRootPart")
            local h = p.Character:FindFirstChildOfClass("Humanoid")
            if r and h and h.Health > 0 then
                local d = (r.Position - my.Position).Magnitude
                if d < bd then bd = d; best = r; bp = p end
            end
        end
    end
    return best, bp
end
RunService.Heartbeat:Connect(function()
    if not (Config.TweenNearest or Config.TweenToPlayer or Config.InstaTP) then return end
    pcall(function()
        local hrp = humanoidRootPart
        if not hrp then return end
        local targetHRP = getTrackTargetHRP()
        if not targetHRP then return end
        local ox, oy, oz = Config.TweenOX or 0, Config.TweenOY or 1.5, Config.TweenOZ or 3.5
        local pred = targetHRP.Position + (targetHRP.AssemblyLinearVelocity * (Config.PredictionStrength or 0.1))
        local dest = CFrame.new(pred) * CFrame.new(ox, oy, oz)
        if Config.InstaTP then
            hrp.CFrame = dest
            hrp.AssemblyLinearVelocity = Vector3.zero
        elseif Config.TweenNearest or Config.TweenToPlayer then
            local dist = (dest.Position - hrp.Position).Magnitude
            local speed = Config.TweenSpeed or 350
            if activeTrackTween then activeTrackTween:Cancel() end
            activeTrackTween = TweenService:Create(hrp, TweenInfo.new(math.max(dist / speed, 0.05), Enum.EasingStyle.Linear), { CFrame = dest })
            activeTrackTween:Play()
        end
    end)
end)
RunService.RenderStepped:Connect(function()
    if not Config.Spectate then return end
    pcall(function()
        local _, plr = getTrackTargetHRP()
        if plr and plr.Character then
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            if hum then Workspace.CurrentCamera.CameraSubject = hum end
        end
    end)
end)

-- ==================== AUTO FLEE ====================
local fleeConnection = nil
local fleeTeleported = false
local FLEE_Y, FLEE_Z = 530, 300
local function GetFleeDestination()
    local pid = game.PlaceId
    if pid == 4442272183 or pid == 79091703265657 then
        return Vector3.new(923, 126, 32852)
    elseif pid == 7449423635 or pid == 100117331123089 then
        return Vector3.new(-5027.03, 316.43, -3206.07)
    end
    return nil
end
local function RestoreFleeState()
    pcall(function()
        local char = lp.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
        end
        if hum then
            hum.PlatformStand = false
            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            hum:ChangeState(Enum.HumanoidStateType.Running)
        end
    end)
end
local function StartAutoFlee()
    if fleeConnection then return end
    fleeConnection = task.spawn(function()
        while Config.AutoFlee do
            task.wait()
            pcall(function()
                if not Config.AutoFlee then return end
                local char = lp.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if not hum or not hrp or hum.Health <= 0 then return end
                local hpPercent = (hum.Health / hum.MaxHealth) * 100
                if hpPercent <= Config.AutoFleeHP then
                    if not fleeTeleported then
                        fleeTeleported = true
                        local dest = GetFleeDestination()
                        if dest then
                            pcall(function() ReplicatedStorage.Remotes.CommF_:InvokeServer("requestEntrance", dest) end)
                        end
                    end
                    local deltaTime = task.wait()
                    local newPosition = hrp.Position + Vector3.new(0, FLEE_Y * deltaTime, FLEE_Z * deltaTime)
                    hrp.AssemblyLinearVelocity = Vector3.zero
                    hrp.AssemblyAngularVelocity = Vector3.zero
                    hum:ChangeState(Enum.HumanoidStateType.Physics)
                    hrp.CFrame = CFrame.new(newPosition) * (hrp.CFrame - hrp.Position)
                elseif fleeTeleported then
                    fleeTeleported = false
                    RestoreFleeState()
                end
            end)
        end
        fleeConnection = nil
        fleeTeleported = false
        RestoreFleeState()
    end)
end
local function StopAutoFlee()
    Config.AutoFlee = false
    fleeConnection = nil
    fleeTeleported = false
    RestoreFleeState()
end

-- ==================== AUTO BUFFS ====================
task.spawn(function()
    while true do
        task.wait(1)
        if Config.AutoV3 and CommE then pcall(function() CommE:FireServer("ActivateAbility") end) end
    end
end)
task.spawn(function()
    while true do
        task.wait(0.5)
        if Config.AutoV4 then
            pcall(function()
                local aw = (lp.Character and lp.Character:FindFirstChild("Awakening"))
                    or (lp.Backpack and lp.Backpack:FindFirstChild("Awakening"))
                if aw then
                    local rf = aw:FindFirstChildWhichIsA("RemoteFunction")
                    if rf then rf:InvokeServer(true) end
                end
            end)
        end
    end
end)
task.spawn(function()
    while true do
        task.wait(30)
        if Config.AutoPvP then pcall(function() CommF:InvokeServer("EnablePvp") end) end
    end
end)

-- ==================== STATS GUI ====================
local statsScreen, statsLabel, statsConn, statsFrame
local statsFpsCount, statsFpsLast, statsFpsValue = 0, tick(), 60
pcall(function()
    statsScreen = Instance.new("ScreenGui")
    statsScreen.Name = "MichelleStatsGui"
    statsScreen.ResetOnSpawn = false
    statsScreen.Enabled = false
    statsScreen.Parent = lp:WaitForChild("PlayerGui")
    statsFrame = Instance.new("Frame", statsScreen)
    statsFrame.Size = UDim2.new(0, 200, 0, 28)
    statsFrame.Position = UDim2.new(0.5, -100, 0, 8)
    statsFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    statsFrame.BackgroundTransparency = 0.3
    statsFrame.Active = true
    statsFrame.Draggable = true
    Instance.new("UICorner", statsFrame).CornerRadius = UDim.new(0, 8)
    statsLabel = Instance.new("TextLabel", statsFrame)
    statsLabel.Size = UDim2.new(1, 0, 1, 0)
    statsLabel.BackgroundTransparency = 1
    statsLabel.Font = Enum.Font.GothamBold
    statsLabel.TextSize = 13
    statsLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
    statsLabel.Text = "FPS: -- | Ping: --"
end)
local function setStatsGui(on)
    Config.StatsGui = on
    if statsScreen then statsScreen.Enabled = on end
    if statsConn then statsConn:Disconnect() statsConn = nil end
    if not on then return end
    statsConn = RunService.Heartbeat:Connect(function()
        statsFpsCount = statsFpsCount + 1
        local now = tick()
        if now - statsFpsLast >= 1 then
            statsFpsValue = statsFpsCount / (now - statsFpsLast)
            statsFpsCount = 0
            statsFpsLast = now
        end
        local ping = math.floor(lp:GetNetworkPing() * 1000)
        local fps = math.floor(statsFpsValue)
        if statsLabel then
            if fps < 30 then statsLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
            elseif fps < 50 then statsLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
            else statsLabel.TextColor3 = Color3.fromRGB(0, 255, 100) end
            statsLabel.Text = string.format("FPS: %d | Ping: %dms", fps, ping)
        end
    end)
end

-- ==================== REMOVE GHOST SHIP ====================
task.spawn(function()
    while true do
        task.wait(2)
        if not Config.RemoveGhostShip then continue end
        pcall(function()
            for _, obj in ipairs(Workspace:GetDescendants()) do
                local n = obj.Name:lower()
                if n:find("ghost") and n:find("ship") then
                    pcall(function() obj:Destroy() end)
                end
            end
        end)
    end
end)

-- ==================== FLY ====================
local flyBV, flyBG, flyConn
local holdUp, holdDown = false, false
local noclipParts = {}
local function setNoclip(on)
    local char = lp.Character
    if not char then return end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            if on then
                if noclipParts[part] == nil then noclipParts[part] = part.CanCollide end
                part.CanCollide = false
            else
                if noclipParts[part] ~= nil then part.CanCollide = noclipParts[part] end
            end
        end
    end
    if not on then noclipParts = {} end
end
local function destroyFlyMovers()
    pcall(function() if flyBV then flyBV:Destroy() end end)
    pcall(function() if flyBG then flyBG:Destroy() end end)
    flyBV, flyBG = nil, nil
end
local function cleanupFly()
    if flyConn then flyConn:Disconnect() flyConn = nil end
    destroyFlyMovers()
    setNoclip(false)
    local hum = lp.Character and lp.Character:FindFirstChildOfClass("Humanoid")
    if hum then pcall(function() hum.PlatformStand = false end) end
end
local function ensureFlyMovers(hrp)
    if not hrp then return end
    if not flyBV or not flyBV.Parent then
        flyBV = Instance.new("BodyVelocity")
        flyBV.Name = "MichelleFlyBV"
        flyBV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        flyBV.Velocity = Vector3.zero
        flyBV.Parent = hrp
    end
    if not flyBG or not flyBG.Parent then
        flyBG = Instance.new("BodyGyro")
        flyBG.Name = "MichelleFlyBG"
        flyBG.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        flyBG.P = 3e4
        flyBG.Parent = hrp
    end
end
local function startFly()
    cleanupFly()
    local hrp = humanoidRootPart
    local hum = lp.Character and lp.Character:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end
    Config.Fly = true
    hum.PlatformStand = true
    setNoclip(true)
    ensureFlyMovers(hrp)
    flyConn = RunService.Heartbeat:Connect(function(dt)
        if not Config.Fly then return end
        hrp = humanoidRootPart
        hum = lp.Character and lp.Character:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum or hum.Health <= 0 then return end
        ensureFlyMovers(hrp)
        hum.PlatformStand = true
        setNoclip(true)
        local camCF = Camera.CFrame
        local look, right = camCF.LookVector, camCF.RightVector
        local md = hum.MoveDirection
        local move = Vector3.zero
        if md.Magnitude > 0.08 then
            local flatLook = Vector3.new(look.X, 0, look.Z)
            local flatRight = Vector3.new(right.X, 0, right.Z)
            if flatLook.Magnitude > 0.01 then flatLook = flatLook.Unit end
            if flatRight.Magnitude > 0.01 then flatRight = flatRight.Unit end
            local flatMd = Vector3.new(md.X, 0, md.Z)
            local fwd, str = 0, 0
            if flatMd.Magnitude > 0.01 then
                flatMd = flatMd.Unit
                fwd = flatMd:Dot(flatLook)
                str = flatMd:Dot(flatRight)
            end
            move = look * fwd + right * str
            if move.Magnitude > 0.01 then move = move.Unit * math.clamp(md.Magnitude, 0, 1) end
        end
        if holdUp then move = move + Vector3.new(0, 1, 0) end
        if holdDown then move = move - Vector3.new(0, 1, 0) end
        local targetVel = Vector3.zero
        if move.Magnitude > 0.05 then
            move = move.Unit
            targetVel = Vector3.new(move.X * Config.FlySpeed, move.Y * Config.FlyVertical, move.Z * Config.FlySpeed)
        end
        if Config.FlySmooth then
            flyBV.Velocity = flyBV.Velocity:Lerp(targetVel, math.clamp(dt * 12, 0.1, 0.5))
        else
            flyBV.Velocity = targetVel
        end
        flyBG.CFrame = CFrame.lookAt(hrp.Position, hrp.Position + look)
    end)
end
local function stopFly()
    Config.Fly = false
    cleanupFly()
end
UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.Space then holdUp = true
    elseif input.KeyCode == Enum.KeyCode.LeftShift then holdDown = true end
end)
UIS.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Space then holdUp = false
    elseif input.KeyCode == Enum.KeyCode.LeftShift then holdDown = false end
end)
lp.CharacterAdded:Connect(function()
    destroyFlyMovers()
    noclipParts = {}
    task.wait(0.6)
    if Config.Fly then startFly() end
end)

pcall(function()
    lp.Idled:Connect(function()
        if not Config.AntiAFK then return end
        local vu = game:GetService("VirtualUser")
        if vu then vu:CaptureController(); vu:ClickButton2(Vector2.zero) end
    end)
end)

local waterPart
task.spawn(function()
    while true do
        task.wait(0.15)
        if Config.WalkOnWater then
            local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
            if not waterPart or not waterPart.Parent then
                waterPart = Instance.new("Part")
                waterPart.Size = Vector3.new(200, 1, 200)
                waterPart.Transparency = 1
                waterPart.Anchored = true
                waterPart.CanCollide = false
                waterPart.Name = "MichelleWaterPlatform"
                waterPart.Parent = Workspace
            end
            if hrp and hrp.Position.Y >= 9.5 then
                waterPart.Position = Vector3.new(hrp.Position.X, 9.2, hrp.Position.Z)
                waterPart.CanCollide = true
            else
                waterPart.CanCollide = false
            end
        elseif waterPart then
            waterPart.CanCollide = false
        end
    end
end)

local antiLavaConn
local function startAntiLava()
    if antiLavaConn then antiLavaConn:Disconnect() end
    local t = 0
    antiLavaConn = RunService.Stepped:Connect(function(_, dt)
        t = t + dt
        if t < 0.2 then return end
        t = 0
        local char = lp.Character
        if not (char and Config.AntiLava) then return end
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart")
                and part.Name ~= "HumanoidRootPart"
                and part.Name ~= "Head"
                and part.Name ~= "Torso"
                and part.Name ~= "UpperTorso"
                and part.Name ~= "LowerTorso" then
                pcall(function() part.CanTouch = false end)
            end
        end
    end)
end
local function stopAntiLava()
    if antiLavaConn then antiLavaConn:Disconnect() antiLavaConn = nil end
end

RunService.Heartbeat:Connect(function()
    if not Config.SpeedEnabled then return end
    local char = lp.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end
    local md = hum.MoveDirection
    if Config.SpeedMode == "WalkSpeed" then
        hum.WalkSpeed = Config.SpeedValue
    elseif Config.SpeedMode == "CFrame" and md.Magnitude > 0 then
        hrp.CFrame = hrp.CFrame + md * (Config.SpeedValue / 100)
    elseif Config.SpeedMode == "Velocity" and md.Magnitude > 0 then
        hrp.AssemblyLinearVelocity = Vector3.new(md.X * Config.SpeedValue, hrp.AssemblyLinearVelocity.Y, md.Z * Config.SpeedValue)
    end
end)

-- ==================== SKY ====================
local skies = {
    ["black storm"] = {
        SkyboxLf = "rbxassetid://15502507918", SkyboxUp = "rbxassetid://15502511911",
        SkyboxRt = "rbxassetid://15502509398", SkyboxFt = "rbxassetid://15502510289",
        SkyboxDn = "rbxassetid://15502508460", SkyboxBk = "rbxassetid://15502511288",
    },
    ["blue space"] = {
        SkyboxLf = "rbxassetid://15536114370", SkyboxUp = "rbxassetid://15536117282",
        SkyboxRt = "rbxassetid://15536118762", SkyboxFt = "rbxassetid://15536116141",
        SkyboxDn = "rbxassetid://15536112543", SkyboxBk = "rbxassetid://15536110634",
    },
    ["realistic"] = {
        SkyboxUp = "rbxassetid://653719321", SkyboxDn = "rbxassetid://653718790",
        SkyboxLf = "rbxassetid://653719190", SkyboxFt = "rbxassetid://653719067",
        SkyboxRt = "rbxassetid://653718931", SkyboxBk = "rbxassetid://653719502",
    },
    ["stormy"] = {
        SkyboxUp = "http://www.roblox.com/asset/?id=18703232671", SkyboxBk = "http://www.roblox.com/asset/?id=18703245834",
        SkyboxLf = "http://www.roblox.com/asset/?id=18703237556", SkyboxDn = "http://www.roblox.com/asset/?id=18703243349",
        SkyboxFt = "http://www.roblox.com/asset/?id=18703240532", SkyboxRt = "http://www.roblox.com/asset/?id=18703235430",
    },
    ["pink"] = {
        SkyboxUp = "rbxassetid://12216108877", SkyboxLf = "rbxassetid://12216110170",
        SkyboxRt = "rbxassetid://12216110471", SkyboxFt = "rbxassetid://12216109489",
        SkyboxBk = "rbxassetid://12216109205", SkyboxDn = "rbxassetid://12216109875",
    },
    ["c00lkidd"] = {
        SkyboxBk = "rbxassetid://6444884337", SkyboxDn = "rbxassetid://6444884780",
        SkyboxFt = "rbxassetid://6444884337", SkyboxLf = "rbxassetid://6444884337",
        SkyboxRt = "rbxassetid://6444884337", SkyboxUp = "rbxassetid://6412503613",
    },
}
local skyInst = nil
local function applySky()
    if skyInst then skyInst:Destroy() skyInst = nil end
    if not Config.SkyEnabled then return end
    local d = skies[Config.SkyType]
    if not d then return end
    local s = Instance.new("Sky")
    for k, v in pairs(d) do s[k] = v end
    s.Parent = Lighting
    skyInst = s
end

local ambientPresets = {
    Rain = { Ambient = Color3.fromRGB(90, 100, 120), Outdoor = Color3.fromRGB(70, 80, 100), Brightness = 1 },
    Night = { Ambient = Color3.fromRGB(40, 40, 60), Outdoor = Color3.fromRGB(30, 30, 50), Brightness = 0.5 },
    Day = { Ambient = Color3.fromRGB(140, 140, 140), Outdoor = Color3.fromRGB(128, 128, 128), Brightness = 2 },
    Foggy = { Ambient = Color3.fromRGB(100, 100, 110), Outdoor = Color3.fromRGB(90, 90, 100), Brightness = 1.2 },
}
local function applyAmbient()
    if not Config.AmbientEnabled then
        Lighting.Ambient = Color3.fromRGB(70, 70, 70)
        Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
        return
    end
    local p = ambientPresets[Config.AmbientType] or ambientPresets.Rain
    Lighting.Ambient = p.Ambient
    Lighting.OutdoorAmbient = p.Outdoor
    Lighting.Brightness = p.Brightness
end

local function applyMinecraft(on)
    Config.MinecraftTex = on
    if on then
        pcall(function()
            Lighting.GlobalShadows = false
            Lighting.Brightness = 2.5
            Lighting.Ambient = Color3.fromRGB(140, 140, 140)
            Lighting.OutdoorAmbient = Color3.fromRGB(140, 140, 140)
        end)
    else
        pcall(function()
            Lighting.GlobalShadows = true
            Lighting.Brightness = 2
        end)
    end
end

-- ==================== SILENT AIM (Nameless full module port) ====================
-- Same logic as NamelessWare SilentAimModule: prediction, blacklist, mouse override,
-- FireServer args[1] only, TAP skip, Soru C, Godhuman/Sword Z override, faceTarget

local mouse = lp:GetMouse()
local Camera = Workspace.CurrentCamera

local SilentAimModule = (function()
    local module = {}
    local player = lp
    local UIS = UserInputService
    local camera = Workspace.CurrentCamera
    local CoreGui = game:GetService("CoreGui")

    local SilentAimPlayersEnabled = false
    local SilentAimNPCsEnabled = false
    local PredictionEnabled = true
    local PredictionAmount = 0.12
    local ZSkillorM1 = true
    local ShowFOVCircle = false
    local FOVRadius = 150
    local FOVMode = "V1"
    local AimMode = "360"
    local TargetPriority = "Nearest"
    local maxRange = 2000

    local SoruAutoAimEnabled = false
    local SoruAutoAimRange = 300
    local SoruTargetingMode = "360"
    local SoruFOVType = "V1"
    local SoruFOVRadius = 150
    local SoruTargetPriority = "Nearest"
    local SoruShowFOVCircle = false
    local SoruCurrentTarget = nil
    local SoruPredictedPosition = nil

    local TracerEnabled = false
    local TracerColor = "Red"
    local tracerModel, tracerAttachment0, tracerAttachment1, tracerBeam = nil, nil, nil, nil

    local renderConnection, heartbeatConnection = nil, nil
    local currentTool, currentToolCategory = nil, "Melee"
    local PlayersPosition, NPCPosition = nil, nil
    local Selectedplayer = nil
    local characterConnections = {}
    local Skills = {"X"}
    local BlacklistedKeys = {
        Melee = { Z = false, X = false, C = false, V = false, F = false },
        Sword = { Z = false, X = false, C = false, V = false, F = false },
        Fruit = { Z = false, X = false, C = false, V = false, F = false, TAP = false },
        Gun   = { Z = false, X = false, C = false, V = false, F = false },
    }
    local currentSkillKey = nil
    local SKILL_KEYS = {"Z", "X", "C", "V", "F", "TAP"}
    local lastSkillTime = 0
    local OverrideGodhumanSanguineEnabled = true

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "Michelle_FOV"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true
    pcall(function()
        if syn and syn.protect_gui then syn.protect_gui(ScreenGui) end
    end)
    ScreenGui.Parent = (gethui and gethui()) or CoreGui or player:WaitForChild("PlayerGui")

    local FOVFrame = Instance.new("Frame")
    FOVFrame.Name = "FOVCircle"
    FOVFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    FOVFrame.BackgroundTransparency = 1
    FOVFrame.Visible = false
    FOVFrame.Parent = ScreenGui
    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = Color3.fromRGB(160, 70, 255)
    UIStroke.Thickness = 2
    UIStroke.Parent = FOVFrame
    Instance.new("UICorner", FOVFrame).CornerRadius = UDim.new(1, 0)

    local SoruFOVFrame = Instance.new("Frame")
    SoruFOVFrame.Name = "SoruFOVCircle"
    SoruFOVFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    SoruFOVFrame.BackgroundTransparency = 1
    SoruFOVFrame.Visible = false
    SoruFOVFrame.Parent = ScreenGui
    local SoruUIStroke = Instance.new("UIStroke")
    SoruUIStroke.Color = Color3.fromRGB(0, 255, 100)
    SoruUIStroke.Thickness = 2
    SoruUIStroke.Parent = SoruFOVFrame
    Instance.new("UICorner", SoruFOVFrame).CornerRadius = UDim.new(1, 0)

    local function getToolCategory(tool)
        if not tool then return "Melee" end
        local name = string.lower(tool.Name)
        local tip = tool.ToolTip or ""
        if tip == "Gun" or name:find("guitar") or name:find("rifle") or name:find("gun") or name:find("bow") or name:find("kabucha") then
            return "Gun"
        end
        local meleeNames = {"claw", "godhuman", "superhuman", "talon", "step", "karate", "breath", "kung fu", "combat", "fist", "sanguine", "electric"}
        for _, m in ipairs(meleeNames) do
            if name:find(m) then return "Melee" end
        end
        if tip == "Blox Fruit" or name:find("fruit") or name:find("-") then return "Fruit" end
        if tip == "Sword" then return "Sword" end
        return "Sword"
    end

    local function isOverrideTool(tool)
        if not tool then return false end
        local name = string.lower(tool.Name)
        if name == "godhuman" or name:find("sanguine") or name:find("yama") then return true end
        if currentToolCategory == "Sword" then return true end
        if currentToolCategory == "Melee" and (name:find("godhuman") or name:find("sanguine")) then return true end
        return false
    end

    local function isKeyCurrentlyBlacklisted(key)
        if not key then return false end
        local cat = currentToolCategory or "Melee"
        if BlacklistedKeys[cat] and BlacklistedKeys[cat][key] ~= nil then
            return BlacklistedKeys[cat][key] == true
        end
        return false
    end

    local function getHRP(model)
        return model and model:FindFirstChild("HumanoidRootPart")
    end

    local function faceTarget(targetPos)
        if not targetPos then return end
        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local currentPos = hrp.Position
        local lookVector = (Vector3.new(targetPos.X, currentPos.Y, targetPos.Z) - currentPos)
        if lookVector.Magnitude < 0.001 then return end
        lookVector = lookVector.Unit
        hrp.CFrame = CFrame.lookAt(currentPos, currentPos + lookVector, Vector3.new(0, 1, 0))
    end

    local function setCurrentSkillKey(key)
        currentSkillKey = key
        lastSkillTime = os.clock()
        if SilentAimPlayersEnabled or SilentAimNPCsEnabled then
            local targetPos = PlayersPosition or NPCPosition
            if targetPos then
                task.spawn(function() faceTarget(targetPos) end)
            end
        end
        task.spawn(function()
            local myTime = lastSkillTime
            task.wait(1.5)
            if lastSkillTime == myTime and currentSkillKey == key then
                currentSkillKey = nil
            end
        end)
    end

    local lastDirection = nil
    local function predicted(hrp)
        if not hrp then return nil end
        local hum = hrp.Parent and hrp.Parent:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then return hrp.Position end
        if not PredictionEnabled then return hrp.Position end
        local vel = hrp.AssemblyLinearVelocity or hrp.Velocity or Vector3.zero
        local speed = vel.Magnitude
        if speed < 5 then
            lastDirection = nil
            return hrp.Position
        end
        local currentDirection = vel.Unit
        if lastDirection then
            if lastDirection:Dot(currentDirection) < 0.7 then
                lastDirection = nil
                return hrp.Position
            end
        end
        lastDirection = currentDirection
        local ping = 0
        pcall(function() ping = player:GetNetworkPing() end)
        ping = math.clamp(ping, 0, 0.35)
        local factor = PredictionAmount + ping
        if speed > 100 then factor = math.min(factor, 0.15) end
        return hrp.Position + vel * factor
    end

    local function isAllyWithMe(targetplayer)
        local myGui = player:FindFirstChild("PlayerGui")
        if not myGui then return false end
        local scrolling = myGui:FindFirstChild("Main")
            and myGui.Main:FindFirstChild("Allies")
            and myGui.Main.Allies:FindFirstChild("Container")
            and myGui.Main.Allies.Container:FindFirstChild("Allies")
            and myGui.Main.Allies.Container.Allies:FindFirstChild("ScrollingFrame")
        if scrolling then
            for _, frame in pairs(scrolling:GetDescendants()) do
                if frame:IsA("ImageButton") and frame.Name == targetplayer.Name then
                    return true
                end
            end
        end
        return false
    end

    local function isTargetProtected(targetPlayer)
        if not targetPlayer then return false end
        local char = targetPlayer.Character
        if not char then return false end
        if char:GetAttribute("SafeZone") == true or char:GetAttribute("PvpDisabled") == true
            or char:GetAttribute("CombatProtected") == true or char:GetAttribute("PVP") == false then
            return true
        end
        if char:FindFirstChildWhichIsA("ForceField") then return true end
        return false
    end

    local function isEnemy(targetplayer)
        if not targetplayer or targetplayer == player then return false end
        if isTargetProtected(targetplayer) then return false end
        local myTeam, targetTeam = player.Team, targetplayer.Team
        if myTeam and targetTeam then
            if myTeam.Name == "Pirates" and targetTeam.Name == "Marines" then return true end
            if myTeam.Name == "Marines" and targetTeam.Name == "Pirates" then return true end
            if myTeam.Name == "Pirates" and targetTeam.Name == "Pirates" then
                return not isAllyWithMe(targetplayer)
            end
            if myTeam.Name == "Marines" and targetTeam.Name == "Marines" then return false end
        end
        return true
    end

    local function getFOVCenter(mode)
        if mode == "V2" then return UIS:GetMouseLocation() end
        camera = Workspace.CurrentCamera
        return camera.ViewportSize / 2
    end

    local function isTargetValid(hrp, lpHRP, aimMode, fovRadius, fovType)
        if not hrp or not lpHRP then return false end
        if aimMode == "180" then
            local dir = (hrp.Position - lpHRP.Position).Unit
            if lpHRP.CFrame.LookVector:Dot(dir) < 0 then return false end
        elseif aimMode == "FOV" then
            local screenPos, onScreen = camera:WorldToViewportPoint(hrp.Position)
            if not onScreen then return false end
            local center = getFOVCenter(fovType)
            if (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude > fovRadius then
                return false
            end
        end
        return true
    end

    local function getClosestplayer(lpHRP)
        if not lpHRP then return nil end
        if TargetPriority == "Lock Player" then
            if Selectedplayer and Selectedplayer.Character and Selectedplayer.Character.Parent then
                if isTargetProtected(Selectedplayer) then return nil end
                local hum = Selectedplayer.Character:FindFirstChildWhichIsA("Humanoid")
                local hrp = getHRP(Selectedplayer.Character)
                if hum and hum.Health > 0 and hrp then
                    if isTargetValid(hrp, lpHRP, AimMode, FOVRadius, FOVMode)
                        and (hrp.Position - lpHRP.Position).Magnitude <= maxRange then
                        return Selectedplayer
                    end
                end
            end
            return nil
        end
        local valid = {}
        for _, pl in ipairs(Players:GetPlayers()) do
            if pl ~= player and isEnemy(pl) and pl.Character and pl.Character.Parent then
                local hum = pl.Character:FindFirstChildWhichIsA("Humanoid")
                local hrp = getHRP(pl.Character)
                if hum and hum.Health > 0 and hrp and isTargetValid(hrp, lpHRP, AimMode, FOVRadius, FOVMode) then
                    local dist = (hrp.Position - lpHRP.Position).Magnitude
                    if dist <= maxRange then
                        table.insert(valid, { Player = pl, Humanoid = hum, HRP = hrp, Distance = dist })
                    end
                end
            end
        end
        if #valid == 0 then return nil end
        if AimMode == "360" or AimMode == "180" then
            if TargetPriority == "Nearest" then
                table.sort(valid, function(a, b) return a.Distance < b.Distance end)
            elseif TargetPriority == "Low HP" or TargetPriority == "LowestHP" then
                table.sort(valid, function(a, b) return a.Humanoid.Health < b.Humanoid.Health end)
            elseif TargetPriority == "HighestHP" then
                table.sort(valid, function(a, b) return a.Humanoid.Health > b.Humanoid.Health end)
            elseif TargetPriority == "Looking At Me" then
                table.sort(valid, function(a, b)
                    local dirA = (lpHRP.Position - a.HRP.Position).Unit
                    local dirB = (lpHRP.Position - b.HRP.Position).Unit
                    return a.HRP.CFrame.LookVector:Dot(dirA) > b.HRP.CFrame.LookVector:Dot(dirB)
                end)
            else
                table.sort(valid, function(a, b) return a.Distance < b.Distance end)
            end
        else
            local center = getFOVCenter(FOVMode)
            table.sort(valid, function(a, b)
                local pA = camera:WorldToViewportPoint(a.HRP.Position)
                local pB = camera:WorldToViewportPoint(b.HRP.Position)
                return (Vector2.new(pA.X, pA.Y) - center).Magnitude < (Vector2.new(pB.X, pB.Y) - center).Magnitude
            end)
        end
        return valid[1].Player
    end

    local function getClosestNPC(lpHRP)
        if not lpHRP then return nil end
        local enemiesFolder = Workspace:FindFirstChild("Enemies")
        if not enemiesFolder then return nil end
        local closest, closestDist = nil, math.huge
        for _, npc in ipairs(enemiesFolder:GetChildren()) do
            if npc:IsA("Model") then
                local hum = npc:FindFirstChildWhichIsA("Humanoid")
                local hrp = getHRP(npc)
                if hum and hum.Health > 0 and hrp and isTargetValid(hrp, lpHRP, AimMode, FOVRadius, FOVMode) then
                    local dist = (hrp.Position - lpHRP.Position).Magnitude
                    if dist <= maxRange and dist < closestDist then
                        closestDist = dist
                        closest = npc
                    end
                end
            end
        end
        return closest
    end

    local function getSoruTarget(lpHRP)
        if not lpHRP then return nil end
        local valid = {}
        for _, pl in ipairs(Players:GetPlayers()) do
            if pl ~= player and pl.Character and pl.Character.Parent and isEnemy(pl) then
                local hum = pl.Character:FindFirstChildWhichIsA("Humanoid")
                local hrp = getHRP(pl.Character)
                if hum and hum.Health > 0 and hrp then
                    if isTargetValid(hrp, lpHRP, SoruTargetingMode, SoruFOVRadius, SoruFOVType) then
                        local dist = (hrp.Position - lpHRP.Position).Magnitude
                        if dist <= SoruAutoAimRange then
                            table.insert(valid, { HRP = hrp, Humanoid = hum, Distance = dist })
                        end
                    end
                end
            end
        end
        if #valid == 0 then return nil end
        if SoruTargetingMode == "360" or SoruTargetingMode == "180" then
            if SoruTargetPriority == "Nearest" then
                table.sort(valid, function(a, b) return a.Distance < b.Distance end)
            elseif SoruTargetPriority == "Low HP" then
                table.sort(valid, function(a, b) return a.Humanoid.Health < b.Humanoid.Health end)
            elseif SoruTargetPriority == "Looking At Me" then
                table.sort(valid, function(a, b)
                    local dirA = (lpHRP.Position - a.HRP.Position).Unit
                    local dirB = (lpHRP.Position - b.HRP.Position).Unit
                    return a.HRP.CFrame.LookVector:Dot(dirA) > b.HRP.CFrame.LookVector:Dot(dirB)
                end)
            end
        else
            local center = getFOVCenter(SoruFOVType)
            table.sort(valid, function(a, b)
                local pA = camera:WorldToViewportPoint(a.HRP.Position)
                local pB = camera:WorldToViewportPoint(b.HRP.Position)
                return (Vector2.new(pA.X, pA.Y) - center).Magnitude < (Vector2.new(pB.X, pB.Y) - center).Magnitude
            end)
        end
        return valid[1].HRP
    end

    task.spawn(function()
        while true do
            task.wait(0.15)
            if SoruAutoAimEnabled then
                local myHRP = getHRP(player.Character)
                local targetHRP = myHRP and getSoruTarget(myHRP)
                if targetHRP then
                    SoruPredictedPosition = predicted(targetHRP) or targetHRP.Position
                    SoruCurrentTarget = targetHRP
                else
                    SoruCurrentTarget = nil
                    SoruPredictedPosition = nil
                end
            else
                SoruCurrentTarget = nil
                SoruPredictedPosition = nil
            end
        end
    end)

    local function updateTracerColor()
        if not tracerBeam then return end
        local colorMap = {
            Red = Color3.fromRGB(255, 0, 0), Green = Color3.fromRGB(0, 255, 0),
            Blue = Color3.fromRGB(0, 0, 255), Yellow = Color3.fromRGB(255, 255, 0),
            White = Color3.fromRGB(255, 255, 255),
        }
        tracerBeam.Color = ColorSequence.new(colorMap[TracerColor] or colorMap.Red)
    end
    local function createTracer()
        if tracerModel then return end
        tracerModel = Instance.new("Model")
        tracerModel.Name = "MichelleSilentAimTracer"
        tracerModel.Parent = Workspace
        tracerAttachment0 = Instance.new("Attachment", tracerModel)
        tracerAttachment1 = Instance.new("Attachment", tracerModel)
        tracerBeam = Instance.new("Beam", tracerModel)
        tracerBeam.Attachment0 = tracerAttachment0
        tracerBeam.Attachment1 = tracerAttachment1
        tracerBeam.Width0 = 0.1
        tracerBeam.Width1 = 0.1
        tracerBeam.FaceCamera = true
        updateTracerColor()
    end
    local function destroyTracer()
        if tracerModel then tracerModel:Destroy() end
        tracerModel, tracerAttachment0, tracerAttachment1, tracerBeam = nil, nil, nil, nil
    end

    -- Mouse module override (Godhuman / Sanguine / Sword Z)
    pcall(function()
        local MouseModuleInstance = RS:FindFirstChild("Mouse")
        if not MouseModuleInstance then return end
        local MouseModule = nil
        pcall(function() MouseModule = require(MouseModuleInstance) end)
        if not MouseModule or type(MouseModule) ~= "table" then return end
        local realStore = { Hit = rawget(MouseModule, "Hit"), Target = rawget(MouseModule, "Target") }
        local mmt = getrawmetatable(MouseModule)
        if mmt then setreadonly(mmt, false) else mmt = {}; setmetatable(MouseModule, mmt) end
        rawset(MouseModule, "Hit", nil)
        rawset(MouseModule, "Target", nil)
        mmt.__index = function(self, key)
            if key == "Hit" then
                if OverrideGodhumanSanguineEnabled
                    and (SilentAimPlayersEnabled or SilentAimNPCsEnabled)
                    and (PlayersPosition or NPCPosition)
                    and isOverrideTool(currentTool)
                    and currentSkillKey == "Z"
                    and not isKeyCurrentlyBlacklisted(currentSkillKey) then
                    local pos = PlayersPosition or NPCPosition
                    if pos then return CFrame.new(pos) end
                end
                return realStore.Hit
            elseif key == "Target" then
                if OverrideGodhumanSanguineEnabled
                    and (SilentAimPlayersEnabled or SilentAimNPCsEnabled)
                    and (PlayersPosition or NPCPosition)
                    and isOverrideTool(currentTool)
                    and currentSkillKey == "Z"
                    and not isKeyCurrentlyBlacklisted(currentSkillKey) then
                    return nil
                end
                return realStore.Target
            end
            return rawget(self, key)
        end
        mmt.__newindex = function(self, key, value)
            if key == "Hit" or key == "Target" then
                realStore[key] = value
            else
                rawset(self, key, value)
            end
        end
        setreadonly(mmt, true)
    end)

    UIS.InputBegan:Connect(function(input, gp)
        if gp then return end
        local keyMap = {
            [Enum.KeyCode.Z] = "Z", [Enum.KeyCode.X] = "X", [Enum.KeyCode.C] = "C",
            [Enum.KeyCode.V] = "V", [Enum.KeyCode.F] = "F",
        }
        local key = keyMap[input.KeyCode]
        if key then setCurrentSkillKey(key) end
    end)

    task.spawn(function()
        local pg = player:WaitForChild("PlayerGui", 20)
        if not pg then return end
        local main = pg:FindFirstChild("Main") or pg:WaitForChild("Main", 15)
        if not main then return end
        local skills = main:FindFirstChild("Skills") or main:WaitForChild("Skills", 10)
        if not skills then return end
        local function hookBtn(btn)
            if not btn:IsA("GuiButton") then return end
            if btn:GetAttribute("MHHooked") then return end
            if table.find(SKILL_KEYS, btn.Name) then
                btn:SetAttribute("MHHooked", true)
                btn.Activated:Connect(function() setCurrentSkillKey(btn.Name) end)
            end
        end
        for _, d in ipairs(skills:GetDescendants()) do hookBtn(d) end
        skills.DescendantAdded:Connect(hookBtn)
    end)

    local function getSkillKeyFromArgs(args)
        for _, arg in ipairs(args) do
            if type(arg) == "string" and table.find(SKILL_KEYS, arg) then
                return arg
            end
        end
        return nil
    end

    local function startRenderLoop()
        if not renderConnection then
            renderConnection = RunService.RenderStepped:Connect(function()
                camera = Workspace.CurrentCamera
                if ShowFOVCircle then
                    local center = getFOVCenter(FOVMode)
                    FOVFrame.Position = UDim2.fromOffset(center.X, center.Y)
                    FOVFrame.Size = UDim2.fromOffset(FOVRadius * 2, FOVRadius * 2)
                    FOVFrame.Visible = true
                else
                    FOVFrame.Visible = false
                end
                if SoruShowFOVCircle then
                    local center = getFOVCenter(SoruFOVType)
                    SoruFOVFrame.Position = UDim2.fromOffset(center.X, center.Y)
                    SoruFOVFrame.Size = UDim2.fromOffset(SoruFOVRadius * 2, SoruFOVRadius * 2)
                    SoruFOVFrame.Visible = true
                else
                    SoruFOVFrame.Visible = false
                end
                pcall(function()
                    local lpChar = player.Character
                    if not lpChar then return end
                    local lpHRP = lpChar:FindFirstChild("HumanoidRootPart")
                    if not lpHRP then return end
                    if not SilentAimPlayersEnabled and not SilentAimNPCsEnabled then
                        if TracerEnabled and tracerBeam then tracerBeam.Enabled = false end
                        PlayersPosition = nil
                        NPCPosition = nil
                        return
                    end
                    if SilentAimPlayersEnabled then
                        local targetplayer = getClosestplayer(lpHRP)
                        if targetplayer and targetplayer.Character then
                            PlayersPosition = predicted(getHRP(targetplayer.Character))
                        else
                            PlayersPosition = nil
                        end
                    else
                        PlayersPosition = nil
                    end
                    if SilentAimNPCsEnabled then
                        local npc = getClosestNPC(lpHRP)
                        if npc then
                            NPCPosition = predicted(getHRP(npc))
                        else
                            NPCPosition = nil
                        end
                    else
                        NPCPosition = nil
                    end
                    if TracerEnabled and tracerBeam and tracerAttachment0 and tracerAttachment1 then
                        local targetPos = PlayersPosition or NPCPosition
                        if lpHRP and targetPos then
                            tracerAttachment0.WorldPosition = lpHRP.Position
                            tracerAttachment1.WorldPosition = targetPos
                            tracerBeam.Enabled = true
                        else
                            tracerBeam.Enabled = false
                        end
                    end
                end)
            end)
        end
        if not heartbeatConnection then
            heartbeatConnection = RunService.Heartbeat:Connect(function()
                if not ZSkillorM1 or (not SilentAimPlayersEnabled and not SilentAimNPCsEnabled) then return end
                if currentSkillKey and isKeyCurrentlyBlacklisted(currentSkillKey) then return end
                if currentTool then
                    local n = string.lower(currentTool.Name)
                    if n:find("portal") or n:find("lightning") then return end
                end
                if not OverrideGodhumanSanguineEnabled then return end
                if not isOverrideTool(currentTool) then return end
                if currentSkillKey ~= "Z" then return end
                local targetPos = PlayersPosition or NPCPosition
                if targetPos then
                    local targetCFrame = CFrame.new(targetPos)
                    pcall(function()
                        mouse.Hit = targetCFrame
                    end)
                end
            end)
        end
    end

    local function stopRenderLoop()
        if renderConnection then renderConnection:Disconnect(); renderConnection = nil end
        if heartbeatConnection then heartbeatConnection:Disconnect(); heartbeatConnection = nil end
        FOVFrame.Visible = false
        SoruFOVFrame.Visible = false
        destroyTracer()
        PlayersPosition = nil
        NPCPosition = nil
    end

    -- MAIN namecall / index hooks (Nameless exact behavior)
    pcall(function()
        local mt = getrawmetatable(game)
        if not mt then return end
        local oldNamecall = mt.__namecall
        local oldIndex = mt.__index
        setreadonly(mt, false)
        mt.__namecall = newcclosure(function(self, ...)
            local Method = getnamecallmethod()
            local args = {...}
            if args[1] == "TAP" then
                return oldNamecall(self, ...)
            end
            local skillKey = getSkillKeyFromArgs(args)
            if skillKey then
                if SilentAimPlayersEnabled or SilentAimNPCsEnabled then
                    local targetPos = PlayersPosition or NPCPosition
                    if targetPos then
                        task.spawn(function() faceTarget(targetPos) end)
                    end
                end
                setCurrentSkillKey(skillKey)
            end
            -- Soru: only skill C
            if SoruAutoAimEnabled and SoruPredictedPosition and skillKey == "C" then
                for i, arg in ipairs(args) do
                    if typeof(arg) == "Vector3" then
                        args[i] = SoruPredictedPosition
                    end
                end
            end
            local skip = false
            if skillKey and isKeyCurrentlyBlacklisted(skillKey) then
                skip = true
            elseif not skillKey and currentSkillKey and isKeyCurrentlyBlacklisted(currentSkillKey) then
                skip = true
            end
            if not skip then
                if Method == "FireServer" then
                    if typeof(args[1]) == "Vector3" then
                        if SilentAimPlayersEnabled and PlayersPosition then
                            args[1] = PlayersPosition
                        elseif SilentAimNPCsEnabled and NPCPosition then
                            args[1] = NPCPosition
                        end
                    end
                elseif Method == "InvokeServer" and currentTool and currentTool.Name == "Buddy Sword" then
                    if type(args[1]) == "string" and table.find(Skills, args[1]) then
                        if SilentAimPlayersEnabled and PlayersPosition then
                            args[2] = PlayersPosition
                        elseif SilentAimNPCsEnabled and NPCPosition then
                            args[2] = NPCPosition
                        end
                    end
                end
            end
            return oldNamecall(self, unpack(args))
        end)
        mt.__index = newcclosure(function(t, k)
            if SoruAutoAimEnabled and t == mouse and SoruPredictedPosition then
                if k == "Hit" then return CFrame.new(SoruPredictedPosition) end
                if k == "Target" then return SoruCurrentTarget end
            end
            return oldIndex(t, k)
        end)
        setreadonly(mt, true)
    end)

    local function clearConnections()
        for _, c in ipairs(characterConnections) do
            pcall(function() c:Disconnect() end)
        end
        characterConnections = {}
    end

    local function onCharacterAdded(char)
        clearConnections()
        currentTool = nil
        currentToolCategory = "Melee"
        for _, child in ipairs(char:GetChildren()) do
            if child:IsA("Tool") then
                currentTool = child
                currentToolCategory = getToolCategory(child)
            end
        end
        table.insert(characterConnections, char.ChildAdded:Connect(function(child)
            if child:IsA("Tool") then
                currentTool = child
                currentToolCategory = getToolCategory(child)
                currentSkillKey = nil
            end
        end))
        table.insert(characterConnections, char.ChildRemoved:Connect(function(child)
            if child == currentTool then
                currentTool = nil
                currentToolCategory = "Melee"
            end
        end))
    end
    player.CharacterAdded:Connect(onCharacterAdded)
    if player.Character then onCharacterAdded(player.Character) end

    function module:SetPlayerSilentAim(state)
        SilentAimPlayersEnabled = state
        if state then startRenderLoop()
        elseif not SilentAimNPCsEnabled then stopRenderLoop() end
    end
    function module:SetNPCSilentAim(state)
        SilentAimNPCsEnabled = state
        if state then startRenderLoop()
        elseif not SilentAimPlayersEnabled then stopRenderLoop() end
    end
    function module:SetBlacklistKey(cat, key, state)
        if BlacklistedKeys[cat] and BlacklistedKeys[cat][key] ~= nil then
            BlacklistedKeys[cat][key] = state
        end
    end
    function module:IsKeyBlacklisted(cat, key)
        return BlacklistedKeys[cat] and BlacklistedKeys[cat][key] or false
    end
    function module:SetAimMode(mode) AimMode = mode end
    function module:SetTargetPriority(prio) TargetPriority = prio end
    function module:SetShowFOVCircle(state) ShowFOVCircle = state end
    function module:SetFOVRadius(num) FOVRadius = num end
    function module:SetFOVMode(mode) FOVMode = mode end
    function module:SetDistanceLimit(num) if type(num) == "number" then maxRange = num end end
    function module:SetSelectedPlayer(playerName)
        if not playerName or playerName == "" or playerName == "None" or playerName == "Nearest" then
            Selectedplayer = nil
            return
        end
        Selectedplayer = Players:FindFirstChild(playerName)
    end
    function module:SetSoruAutoAim(state)
        SoruAutoAimEnabled = state
        if not state then
            SoruCurrentTarget = nil
            SoruPredictedPosition = nil
        end
    end
    function module:SetSoruRange(r) SoruAutoAimRange = r end
    function module:SetSoruAimMode(mode) SoruTargetingMode = mode end
    function module:SetSoruFOVType(mode) SoruFOVType = mode end
    function module:SetSoruFOVRadius(r) SoruFOVRadius = r end
    function module:SetSoruPriority(p) SoruTargetPriority = p end
    function module:SetSoruShowFOVCircle(state) SoruShowFOVCircle = state end
    function module:SetTracerEnabled(state)
        TracerEnabled = state
        if state then createTracer() else destroyTracer() end
    end
    function module:SetTracerColor(color) TracerColor = color; updateTracerColor() end
    function module:GetTargetPos() return PlayersPosition or NPCPosition end
    function module:GetBlacklist() return BlacklistedKeys end
    return module
end)()

-- Sync from Config
SilentAimModule:SetPlayerSilentAim(Config.SilentPlayer == true)
SilentAimModule:SetNPCSilentAim(Config.SilentNPC == true)
SilentAimModule:SetAimMode(Config.AimMode or "360")
SilentAimModule:SetTargetPriority(Config.AimPriority or "Nearest")
SilentAimModule:SetShowFOVCircle(Config.ShowFOV == true)
SilentAimModule:SetFOVMode(Config.FOVMode or "V1")
SilentAimModule:SetFOVRadius(Config.FOVRadius or 150)
SilentAimModule:SetDistanceLimit(Config.AimMaxRange or 2000)
SilentAimModule:SetSoruAutoAim(Config.SoruAutoAim == true)
SilentAimModule:SetSoruAimMode(Config.SoruAimMode or "360")
SilentAimModule:SetSoruFOVType(Config.SoruFOVType or "V1")
SilentAimModule:SetSoruFOVRadius(Config.SoruFOVRadius or Config.FOVRadius or 150)
SilentAimModule:SetSoruRange(Config.SoruRange or 300)
SilentAimModule:SetSoruPriority(Config.SoruPriority or "Nearest")
SilentAimModule:SetSoruShowFOVCircle(Config.SoruShowFOV == true)

-- Load blacklist from Config
for _, cat in ipairs({"Melee", "Sword", "Fruit", "Gun"}) do
    for _, key in ipairs({"Z", "X", "C", "V", "F", "TAP"}) do
        local ck = "BL_" .. cat .. "_" .. key
        if Config[ck] == true then
            SilentAimModule:SetBlacklistKey(cat, key, true)
        end
    end
end

-- M1 Extender (Nameless style: on click only)
local M1ExtenderMod = (function()
    local M = {}
    local active = false
    local maxRange = 50
    local function getTarget()
        local myChar = lp.Character
        local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
        if not myRoot then return nil end
        local target, shortestDist = nil, maxRange
        for _, folder in pairs({ Workspace:FindFirstChild("Enemies"), Workspace:FindFirstChild("Characters") }) do
            if folder then
                for _, v in pairs(folder:GetChildren()) do
                    local eRoot = v:FindFirstChild("HumanoidRootPart")
                    local eHum = v:FindFirstChildOfClass("Humanoid")
                    if v ~= myChar and eRoot and eHum and eHum.Health > 0 then
                        local dist = (eRoot.Position - myRoot.Position).Magnitude
                        if dist < shortestDist then
                            shortestDist = dist
                            target = v
                        end
                    end
                end
            end
        end
        return target
    end
    UIS.InputBegan:Connect(function(input, processed)
        if processed or not active then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            local target = getTarget()
            local tool = lp.Character and lp.Character:FindFirstChildOfClass("Tool")
            if target and tool then
                local head = target:FindFirstChild("Head") or target:FindFirstChild("HumanoidRootPart")
                if head then
                    pcall(function()
                        local RA = registerAttack or (Net and Net:FindFirstChild("RE/RegisterAttack"))
                        local RH = registerHit or (Net and Net:FindFirstChild("RE/RegisterHit"))
                        if RA then RA:FireServer() end
                        if RH then
                            local hitData = {}
                            for _, part in pairs(target:GetChildren()) do
                                if part:IsA("BasePart") then
                                    table.insert(hitData, { target, part })
                                end
                            end
                            RH:FireServer(head, hitData)
                        end
                    end)
                end
            end
        end
    end)
    function M:Toggle(v) active = v end
    function M:SetRange(v) maxRange = v end
    return M
end)()
M1ExtenderMod:Toggle(Config.M1Extender == true)
M1ExtenderMod:SetRange(Config.M1Range or 50)

-- Gun Click SL (Nameless)
local GunClickSLMod = (function()
    local enabled = false
    local aimPos = nil
    local hookInstalled = false
    local function getClosestTarget()
        local char = lp.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not root then return nil end
        local closest, dist = nil, math.huge
        local myPos = root.Position
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= lp and player.Character then
                local targetPart = player.Character:FindFirstChild("HumanoidRootPart")
                local hum = player.Character:FindFirstChildOfClass("Humanoid")
                if targetPart and hum and hum.Health > 0 then
                    local d = (targetPart.Position - myPos).Magnitude
                    if d < dist then
                        dist = d
                        closest = targetPart
                    end
                end
            end
        end
        return closest
    end
    local function installHook()
        if hookInstalled then return end
        hookInstalled = true
        local mt = getrawmetatable(game)
        local oldNamecall = mt.__namecall
        setreadonly(mt, false)
        mt.__namecall = newcclosure(function(self, ...)
            local args = {...}
            local method = getnamecallmethod()
            if enabled and aimPos and method == "FireServer" then
                local remoteName = tostring(self.Name or self)
                if remoteName:find("ShootGun") then
                    if typeof(args[1]) == "Vector3" then
                        args[1] = aimPos.Position
                    end
                    if typeof(args[2]) == "table" then
                        args[2] = { aimPos }
                    end
                    return oldNamecall(self, unpack(args))
                end
            end
            return oldNamecall(self, ...)
        end)
        setreadonly(mt, true)
    end
    local M = {}
    function M:SetEnabled(state)
        if state == enabled then return end
        enabled = state
        if state then
            aimPos = nil
            installHook()
            task.spawn(function()
                while enabled do
                    aimPos = getClosestTarget()
                    task.wait(0.05)
                end
            end)
        else
            aimPos = nil
        end
    end
    return M
end)()
if Config.GunClickSL then GunClickSLMod:SetEnabled(true) end

-- Compat shims for UI that referenced old SilentAim / Soru / M1Ext tables
local SilentAim = {
    Player = Config.SilentPlayer,
    NPC = Config.SilentNPC,
    AimMode = Config.AimMode or "360",
    Priority = Config.AimPriority or "Nearest",
    ShowFOV = Config.ShowFOV,
    FOVMode = Config.FOVMode or "V1",
    FOVRadius = Config.FOVRadius or 150,
    MaxRange = Config.AimMaxRange or 2000,
}
local Soru = {
    Enabled = Config.SoruAutoAim,
    AimMode = Config.SoruAimMode or "360",
    FOVType = Config.SoruFOVType or "V1",
    Priority = Config.SoruPriority or "Nearest",
    FOVRadius = Config.SoruFOVRadius or 150,
    Range = Config.SoruRange or 300,
    ShowFOV = Config.SoruShowFOV,
}
local M1Ext = { on = Config.M1Extender, range = Config.M1Range or 50 }
local function updateFOVCircle() end
local function updateSoruFOV() end



-- ==================== BYPASS TP NPC (Cestian-style) ====================
local BypassTpConn = nil
local function StartBypassTpNpc()
    if BypassTpConn then return end
    BypassTpConn = task.spawn(function()
        while Config.BypassTpNpc do
            task.wait(0.15)
            pcall(function()
                local char = lp.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if not hrp then return end
                local enemies = Workspace:FindFirstChild("Enemies")
                if not enemies then return end
                local range = Config.BypassTpRange or 500
                local mode = Config.BypassTpMode or "Nearest"
                local list = {}
                for _, npc in ipairs(enemies:GetChildren()) do
                    if npc:IsA("Model") then
                        local eRoot = npc:FindFirstChild("HumanoidRootPart")
                        local eHum = npc:FindFirstChildOfClass("Humanoid")
                        if eRoot and eHum and eHum.Health > 0 then
                            local d = (eRoot.Position - hrp.Position).Magnitude
                            if d <= range then
                                table.insert(list, { root = eRoot, dist = d, model = npc })
                            end
                        end
                    end
                end
                if #list == 0 then return end
                table.sort(list, function(a, b) return a.dist < b.dist end)
                if mode == "Nearest" then
                    local t = list[1].root
                    local yOff = Config.BypassTpAbove and (Config.BypassTpHeight or 12) or 3
                    hrp.CFrame = CFrame.new(t.Position + Vector3.new(0, yOff, 0))
                elseif mode == "All in Range" then
                    for _, item in ipairs(list) do
                        pcall(function()
                            item.root.CFrame = hrp.CFrame * CFrame.new(0, -5, -3)
                            item.root.CanCollide = false
                            item.root.AssemblyLinearVelocity = Vector3.zero
                        end)
                    end
                elseif mode == "Bring to Me" then
                    for _, item in ipairs(list) do
                        pcall(function()
                            item.root.CFrame = CFrame.new(hrp.Position + Vector3.new(0, -8, 0))
                            item.root.CanCollide = false
                        end)
                    end
                end
            end)
        end
        BypassTpConn = nil
    end)
end
local function StopBypassTpNpc()
    Config.BypassTpNpc = false
    BypassTpConn = nil
end


-- ==================== POTATO GRAPHICS (Nameless No GFX + Cestian Flags) ====================
local noGfxMode = "Off"
local noGfxConnections = {}
local noGfxModifiedObjects = {}
local hotbarIconsOriginals = {}

local function restoreNoGfx()
    for obj, data in pairs(noGfxModifiedObjects) do
        pcall(function()
            if data.Texture ~= nil then obj.Texture = data.Texture end
            if data.Enabled ~= nil then obj.Enabled = data.Enabled end
        end)
    end
    noGfxModifiedObjects = {}
    for iconLabel, oldImage in pairs(hotbarIconsOriginals) do
        pcall(function() iconLabel.Image = oldImage or "" end)
    end
    hotbarIconsOriginals = {}
    if noGfxConnections.DescendantAdded then
        noGfxConnections.DescendantAdded:Disconnect()
        noGfxConnections.DescendantAdded = nil
    end
    if noGfxConnections.HotbarChildAdded then
        noGfxConnections.HotbarChildAdded:Disconnect()
        noGfxConnections.HotbarChildAdded = nil
    end
end

local function processObject(inst)
    local className = inst.ClassName
    if className == "Beam" or className == "Trail" then
        if not noGfxModifiedObjects[inst] then
            noGfxModifiedObjects[inst] = { Texture = inst.Texture }
            inst.Texture = "rbxassetid://84308155859778"
        end
    elseif className == "ParticleEmitter" then
        if not noGfxModifiedObjects[inst] then
            noGfxModifiedObjects[inst] = { Texture = inst.Texture, Enabled = inst.Enabled }
            inst.Texture = ""
            inst.Enabled = false
        end
    end
end

local function startNoGfxV1()
    restoreNoGfx()
    task.spawn(function()
        local descendants = Workspace:GetDescendants()
        for i = 1, #descendants do
            local inst = descendants[i]
            if not inst:IsA("Terrain") and not inst:IsA("Camera") then
                processObject(inst)
            end
            if i % 100 == 0 then RunService.Heartbeat:Wait() end
        end
    end)
    noGfxConnections.DescendantAdded = Workspace.DescendantAdded:Connect(processObject)
end

local function startNoGfxV2()
    restoreNoGfx()
    task.spawn(function()
        local descendants = Workspace:GetDescendants()
        for i = 1, #descendants do
            local inst = descendants[i]
            if not inst:IsA("Terrain") and not inst:IsA("Camera") then
                processObject(inst)
            end
            if i % 100 == 0 then RunService.Heartbeat:Wait() end
        end
    end)
    noGfxConnections.DescendantAdded = Workspace.DescendantAdded:Connect(processObject)
    task.spawn(function()
        local PlayerGui = lp:WaitForChild("PlayerGui", 10)
        if not PlayerGui then return end
        local Backpack = PlayerGui:FindFirstChild("Backpack") or PlayerGui:WaitForChild("Backpack", 5)
        if not Backpack then return end
        local Hotbar = Backpack:FindFirstChild("Hotbar")
        local HotbarContainer = Hotbar and (Hotbar:FindFirstChild("Container") or Hotbar)
        if not HotbarContainer then return end
        local function updateHotbarIconSilent()
            for _, slot in ipairs(HotbarContainer:GetChildren()) do
                local iconLabel = slot:FindFirstChild("Icon") or slot:FindFirstChild("Image") or slot:FindFirstChildOfClass("ImageLabel")
                if iconLabel and iconLabel:IsA("ImageLabel") then
                    if not hotbarIconsOriginals[iconLabel] then
                        hotbarIconsOriginals[iconLabel] = iconLabel.Image
                    end
                    iconLabel.Image = "rbxassetid://84308155859778"
                    iconLabel.ImageColor3 = Color3.fromRGB(255, 255, 255)
                end
            end
        end
        updateHotbarIconSilent()
        noGfxConnections.HotbarChildAdded = HotbarContainer.ChildAdded:Connect(function()
            task.defer(updateHotbarIconSilent)
        end)
    end)
end

local function setNoGfxMode(mode)
    if mode == noGfxMode then return end
    noGfxMode = mode
    Config.NoGfxMode = mode
    restoreNoGfx()
    if mode == "V1" then startNoGfxV1()
    elseif mode == "V2" then startNoGfxV2()
    end
end

local function hopToJobId(jobId)
    jobId = tostring(jobId or ""):gsub("%s+", "")
    if jobId == "" then return false end
    local ok = pcall(function()
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, jobId, lp)
    end)
    return ok
end



-- ==================== MOVEMENT (Nameless-style) ====================
local MovementState = {
    Noclip = false,
    InfiniteJump = false,
    SuperJump = false,
    SuperJumpPower = 100,
    BunnyHop = false,
    NoFallDamage = false,
    DashDistance = false,
    DashLength = 50,
    HipHeight = false,
    HipHeightValue = 2,
}

local noclipConn, jumpConn, bhopConn, fallConn, dashConn, hipConn

local function setNoclipParts(enabled)
    local char = lp.Character
    if not char then return end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = not enabled
        end
    end
end

local function StartNoclip()
    if noclipConn then return end
    MovementState.Noclip = true
    noclipConn = RunService.Stepped:Connect(function()
        if not MovementState.Noclip then return end
        setNoclipParts(true)
    end)
end
local function StopNoclip()
    MovementState.Noclip = false
    if noclipConn then noclipConn:Disconnect() noclipConn = nil end
    setNoclipParts(false)
end

local function StartInfiniteJump()
    if jumpConn then return end
    MovementState.InfiniteJump = true
    jumpConn = UIS.JumpRequest:Connect(function()
        if not MovementState.InfiniteJump then return end
        local hum = lp.Character and lp.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end)
end
local function StopInfiniteJump()
    MovementState.InfiniteJump = false
    if jumpConn then jumpConn:Disconnect() jumpConn = nil end
end

local function StartSuperJump()
    if not MovementState.SuperJump then return end
    -- apply on jump
end

-- Super jump via state change
do
    local sjConn
    local function ensureSJ()
        if sjConn then return end
        sjConn = RunService.Heartbeat:Connect(function()
            if not MovementState.SuperJump then return end
            local char = lp.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if not hum or not hrp then return end
            if hum.Jump and hum:GetState() == Enum.HumanoidStateType.Jumping then
                local v = hrp.AssemblyLinearVelocity
                if v.Y > 0 and v.Y < MovementState.SuperJumpPower then
                    hrp.AssemblyLinearVelocity = Vector3.new(v.X, MovementState.SuperJumpPower, v.Z)
                end
            end
        end)
    end
    ensureSJ()
end

local function StartBunnyHop()
    if bhopConn then return end
    MovementState.BunnyHop = true
    bhopConn = RunService.Heartbeat:Connect(function()
        if not MovementState.BunnyHop then return end
        local char = lp.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hum or not hrp then return end
        if hum.FloorMaterial ~= Enum.Material.Air then
            hum.Jump = true
            local md = hum.MoveDirection
            if md.Magnitude > 0.1 then
                local speed = math.max(hum.WalkSpeed, Config.SpeedValue or 50)
                hrp.AssemblyLinearVelocity = Vector3.new(md.X * speed * 1.2, hrp.AssemblyLinearVelocity.Y, md.Z * speed * 1.2)
            end
        end
    end)
end
local function StopBunnyHop()
    MovementState.BunnyHop = false
    if bhopConn then bhopConn:Disconnect() bhopConn = nil end
end

local function StartNoFall()
    if fallConn then return end
    MovementState.NoFallDamage = true
    fallConn = RunService.Heartbeat:Connect(function()
        if not MovementState.NoFallDamage then return end
        local hum = lp.Character and lp.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
            if hum:GetState() == Enum.HumanoidStateType.Freefall then
                -- prevent death by fall
            end
        end
        local char = lp.Character
        if char then
            local fd = char:FindFirstChild("FallDamage") or char:FindFirstChild("Falling")
            -- Blox Fruits uses attribute sometimes
            pcall(function() char:SetAttribute("FallDamage", 0) end)
        end
    end)
end
local function StopNoFall()
    MovementState.NoFallDamage = false
    if fallConn then fallConn:Disconnect() fallConn = nil end
end

local function StartDashDistance()
    if dashConn then return end
    MovementState.DashDistance = true
    dashConn = RunService.Heartbeat:Connect(function()
        if not MovementState.DashDistance then return end
        local char = lp.Character
        if not char then return end
        -- Blox Fruits dash attributes
        pcall(function()
            char:SetAttribute("DashLength", MovementState.DashLength)
            char:SetAttribute("DashDistance", MovementState.DashLength)
            char:SetAttribute("SoruLength", MovementState.DashLength)
        end)
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            pcall(function()
                hum:SetAttribute("DashLength", MovementState.DashLength)
            end)
        end
    end)
end
local function StopDashDistance()
    MovementState.DashDistance = false
    if dashConn then dashConn:Disconnect() dashConn = nil end
end

local function StartHipHeight()
    if hipConn then return end
    MovementState.HipHeight = true
    hipConn = RunService.Heartbeat:Connect(function()
        if not MovementState.HipHeight then return end
        local hum = lp.Character and lp.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.HipHeight = MovementState.HipHeightValue
        end
    end)
end
local function StopHipHeight()
    MovementState.HipHeight = false
    if hipConn then hipConn:Disconnect() hipConn = nil end
    local hum = lp.Character and lp.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.HipHeight = 2 end
end

-- ==================== FAST FLAGS (Cestian-style) ====================
-- Sets como Supremacy Fps tab: FF1 / FF2 / FF3
local FastFlagSets = {
    [1] = { -- Performance / FPS
        {"DFIntTaskSchedulerTargetFps", "9999"},
        {"FFlagTaskSchedulerLimitTargetFpsTo2402", "False"},
        {"FFlagDebugGraphicsPreferVulkan", "True"},
        {"FFlagDebugGraphicsDisableDirect3D11", "True"},
        {"DFIntTextureQualityOverride", "1"},
        {"DFIntTextureCompositorActiveJobs", "1"},
        {"FFlagDisablePostFx", "True"},
        {"FIntRenderShadowIntensity", "0"},
        {"DFIntDebugFRMQualityLevelOverride", "1"},
        {"FFlagCommitToGraphicsQualityLevels", "True"},
        {"FFlagDebugSkyGray", "True"},
        {"FFlagDisableNewLightAttenuation", "True"},
    },
    [2] = { -- Network / Latency
        {"DFIntConnectionMTUSize", "1492"},
        {"DFIntHttpCurlConnectionCacheSize", "134217728"},
        {"DFIntMaxFrameBufferSize", "4"},
        {"DFIntMaxInterpolationPathLength", "1"},
        {"DFIntTimestepArbiterThresholdInTicks", "1"},
        {"FFlagSimDefaultPrimalSolver", "True"},
        {"DFIntS2PhysicsSenderRate", "15"},
        {"DFIntPhysicsSenderMaxBandwidthBps", "1000000"},
    },
    [3] = { -- Extra potato
        {"FFlagHandleAltEnterFullscreenManually", "False"},
        {"FFlagFixPlayerCollisionWhenSwimming", "False"},
        {"DFIntAnimationLodFacsDistanceMin", "0"},
        {"DFIntAnimationLodFacsDistanceMax", "0"},
        {"DFIntAnimationLodFacsMinVisSize", "0"},
        {"FFlagEnableInGameMenuChromeABTest3", "False"},
        {"FFlagEnableInGameMenuChromeABTest4", "False"},
        {"FFlagEnableInGameMenuModernization", "False"},
        {"FFlagUserShowGuiHideToggles", "True"},
    },
}

local function InjectFastFlags(setId)
    setId = setId or 1
    local list = FastFlagSets[setId] or FastFlagSets[1]
    local injected, failed = 0, 0
    local function trySet(name, value)
        local ok = false
        if typeof(setfflag) == "function" then
            ok = pcall(setfflag, name, tostring(value))
        end
        if not ok and typeof(setflag) == "function" then
            ok = pcall(setflag, name, tostring(value))
        end
        -- algunos executors: game:DefineFastFlag / SetFastFlag
        if not ok then
            ok = pcall(function()
                if getgenv and getgenv().setfflag then
                    getgenv().setfflag(name, tostring(value))
                end
            end)
        end
        return ok
    end
    for _, pair in ipairs(list) do
        if trySet(pair[1], pair[2]) then
            injected = injected + 1
        else
            failed = failed + 1
        end
    end
    pcall(function()
        if setfpscap then setfpscap(999) end
    end)
    return injected, failed
end


-- ==================== UI ====================
local Window = WindUI:CreateWindow({
    Title = "Michelle Hub",
    Icon = "star",
    Theme = "Dark",
})

local Main = Window:Tab({ Title = "Main", Icon = "home" })
Main:Toggle({ Title = "Fast Attack", Value = Config.FastAttack, Callback = function(v) Config.FastAttack = v; save() end })
Main:Toggle({ Title = "Attack Players", Value = Config.FAPlayers, Callback = function(v) Config.FAPlayers = v; save() end })
Main:Toggle({ Title = "Attack NPCs", Value = Config.FAMobs, Callback = function(v) Config.FAMobs = v; save() end })
Main:Slider({ Title = "FA Range", Step = 50, Value = { Min = 50, Max = 5000, Default = Config.FARange }, Callback = function(v) Config.FARange = v; save() end })
Main:Toggle({ Title = "Bring Mobs", Value = Config.BringMobs, Callback = function(v) Config.BringMobs = v; save() end })
Main:Slider({ Title = "Bring Range", Step = 50, Value = { Min = 50, Max = 5000, Default = Config.BringRange }, Callback = function(v) Config.BringRange = v; save() end })

local GunAura = Window:Tab({ Title = "Gun Aura", Icon = "crosshair" })
GunAura:Toggle({ Title = "Gun Aura Safe", Value = Config.SafeGun, Callback = function(v)
    Config.SafeGun = v
    _cachedToolSafe = nil
    _cachedTargetSafe = nil
    save()
end })
GunAura:Toggle({ Title = "Safe Mobs", Value = Config.SafeMobs, Callback = function(v) Config.SafeMobs = v; save() end })
GunAura:Toggle({ Title = "Safe Players", Value = Config.SafePlayers, Callback = function(v) Config.SafePlayers = v; save() end })
GunAura:Toggle({ Title = "Safe Sea Events", Value = Config.SafeSea, Callback = function(v) Config.SafeSea = v; save() end })
GunAura:Slider({ Title = "Safe Gun Range", Step = 50, Value = { Min = 50, Max = 30000, Default = Config.SafeRange }, Callback = function(v) Config.SafeRange = v; save() end })
GunAura:Toggle({ Title = "Super Gun Aura", Value = Config.SuperGun, Callback = function(v)
    Config.SuperGun = v
    _cachedToolSuper = nil
    _cachedTargetSuper = nil
    save()
end })
GunAura:Toggle({ Title = "Super Mobs", Value = Config.SuperMobs, Callback = function(v) Config.SuperMobs = v; save() end })
GunAura:Toggle({ Title = "Super Players", Value = Config.SuperPlayers, Callback = function(v) Config.SuperPlayers = v; save() end })
GunAura:Toggle({ Title = "Super Sea Events", Value = Config.SuperSea, Callback = function(v) Config.SuperSea = v; save() end })
GunAura:Slider({ Title = "Super Gun Range", Step = 50, Value = { Min = 50, Max = 30000, Default = Config.SuperRange }, Callback = function(v) Config.SuperRange = v; save() end })
GunAura:Toggle({ Title = "Disappear Everything", Value = Config.Disappear, Callback = function(v)
    setDisappear(v)
    save()
end })
GunAura:Paragraph({ Title = "Disappear Keybind", Desc = "Tecla P para activar/desactivar" })


local Dungeons = Window:Tab({ Title = "Dungeons", Icon = "swords" })
Dungeons:Paragraph({ Title = "Fruit Fast Attack", Desc = "Fast attack de fruta SIN equipar (Cestian style)" })
Dungeons:Toggle({ Title = "Fruit Fast Attack (sin equipar)", Value = Config.FruitM1, Callback = function(v)
    Config.FruitM1 = v
    if FruitM1 and FruitM1.SetNormal then
        FruitM1.SetNormal(v)
    end
    save()
end })
Dungeons:Paragraph({ Title = "Bypass TP NPC", Desc = "Teletransporte a NPCs ignorando limites" })
Dungeons:Toggle({ Title = "Bypass TP NPC", Value = Config.BypassTpNpc or false, Callback = function(v)
    Config.BypassTpNpc = v
    if v then
        StartBypassTpNpc()
    else
        StopBypassTpNpc()
    end
    save()
end })
Dungeons:Slider({
    Title = "NPC TP Range",
    Step = 25,
    Value = { Min = 50, Max = 5000, Default = Config.BypassTpRange or 500 },
    Callback = function(v)
        Config.BypassTpRange = v
        save()
    end,
})
Dungeons:Dropdown({
    Title = "TP Mode",
    Values = {"Nearest", "All in Range", "Bring to Me"},
    Value = Config.BypassTpMode or "Nearest",
    Callback = function(v)
        Config.BypassTpMode = v
        save()
    end,
})
Dungeons:Toggle({
    Title = "TP Above NPC",
    Value = Config.BypassTpAbove ~= false,
    Callback = function(v)
        Config.BypassTpAbove = v
        save()
    end,
})
Dungeons:Slider({
    Title = "Height Above NPC",
    Step = 1,
    Value = { Min = 3, Max = 50, Default = Config.BypassTpHeight or 12 },
    Callback = function(v)
        Config.BypassTpHeight = v
        save()
    end,
})

local Trackers = Window:Tab({ Title = "Trackers", Icon = "users" })
local trackPlayerNames = {"Nearest"}
for _, p in ipairs(Players:GetPlayers()) do
    if p ~= lp then table.insert(trackPlayerNames, p.Name) end
end
Trackers:Dropdown({
    Title = "Target Player",
    Values = trackPlayerNames,
    Value = Config.SelectedTrackPlayer or "Nearest",
    Callback = function(v)
        Config.SelectedTrackPlayer = v
        save()
    end,
})
Trackers:Toggle({
    Title = "Tween Nearest",
    Value = Config.TweenNearest,
    Callback = function(v)
        Config.TweenNearest = v
        if v then Config.TweenToPlayer = false end
        save()
    end,
})
Trackers:Toggle({
    Title = "Tween To Player",
    Value = Config.TweenToPlayer,
    Callback = function(v)
        Config.TweenToPlayer = v
        if v then Config.TweenNearest = false end
        save()
    end,
})
Trackers:Toggle({
    Title = "Insta TP",
    Value = Config.InstaTP,
    Callback = function(v) Config.InstaTP = v; save() end,
})
Trackers:Slider({
    Title = "Tween Speed",
    Step = 10,
    Value = { Min = 50, Max = 800, Default = Config.TweenSpeed or 350 },
    Callback = function(v) Config.TweenSpeed = v; save() end,
})
Trackers:Slider({
    Title = "Offset X",
    Step = 0.5,
    Value = { Min = -20, Max = 20, Default = Config.TweenOX or 0 },
    Callback = function(v) Config.TweenOX = v; save() end,
})
Trackers:Slider({
    Title = "Offset Y",
    Step = 0.5,
    Value = { Min = -20, Max = 50, Default = Config.TweenOY or 1.5 },
    Callback = function(v) Config.TweenOY = v; save() end,
})
Trackers:Slider({
    Title = "Offset Z",
    Step = 0.5,
    Value = { Min = -20, Max = 20, Default = Config.TweenOZ or 3.5 },
    Callback = function(v) Config.TweenOZ = v; save() end,
})
Trackers:Toggle({
    Title = "Tracker Orbit / Fly",
    Value = Config.TrackerFly,
    Callback = function(v)
        Config.TrackerFly = v
        if v then StartTrackerFly() else StopTrackerFly() end
        save()
    end,
})
Trackers:Slider({
    Title = "Tracker Speed",
    Step = 5,
    Value = { Min = 50, Max = 500, Default = Config.TrackerFlySpeed },
    Callback = function(v) Config.TrackerFlySpeed = v; save() end,
})
Trackers:Slider({
    Title = "Orbit Radius",
    Step = 1,
    Value = { Min = 5, Max = 150, Default = Config.TrackerOrbitRadius },
    Callback = function(v) Config.TrackerOrbitRadius = v; save() end,
})
Trackers:Toggle({
    Title = "Auto Flee",
    Value = Config.AutoFlee,
    Callback = function(v)
        Config.AutoFlee = v
        if v then StartAutoFlee() else StopAutoFlee() end
        save()
    end,
})
Trackers:Slider({
    Title = "Auto Flee HP %",
    Step = 1,
    Value = { Min = 5, Max = 80, Default = Config.AutoFleeHP },
    Callback = function(v) Config.AutoFleeHP = v; save() end,
})
Trackers:Toggle({
    Title = "Spectate Target",
    Value = Config.Spectate,
    Callback = function(v)
        Config.Spectate = v
        if not v then
            pcall(function()
                local cam = Workspace.CurrentCamera
                local hum = lp.Character and lp.Character:FindFirstChildOfClass("Humanoid")
                if hum then cam.CameraSubject = hum end
            end)
        end
        save()
    end,
})

local Aim = Window:Tab({ Title = "Aim", Icon = "target" })
Aim:Toggle({ Title = "Silent Aim Players", Value = Config.SilentPlayer, Callback = function(v)
    Config.SilentPlayer = v
    SilentAimModule:SetPlayerSilentAim(v)
    save()
end })
Aim:Toggle({ Title = "Silent Aim NPCs", Value = Config.SilentNPC, Callback = function(v)
    Config.SilentNPC = v
    SilentAimModule:SetNPCSilentAim(v)
    save()
end })
Aim:Dropdown({
    Title = "Aim Mode",
    Values = {"360", "180", "FOV"},
    Value = Config.AimMode or "360",
    Callback = function(v)
        Config.AimMode = v
        SilentAimModule:SetAimMode(v)
        save()
    end,
})
Aim:Dropdown({
    Title = "Priority",
    Values = {"Nearest", "Low HP", "HighestHP", "Looking At Me", "Lock Player"},
    Value = Config.AimPriority or "Nearest",
    Callback = function(v)
        Config.AimPriority = v
        SilentAimModule:SetTargetPriority(v)
        save()
    end,
})
Aim:Dropdown({
    Title = "FOV Mode",
    Values = {"V1", "V2"},
    Value = Config.FOVMode or "V1",
    Callback = function(v)
        Config.FOVMode = v
        SilentAimModule:SetFOVMode(v)
        save()
    end,
})
Aim:Toggle({ Title = "Show FOV Circle", Value = Config.ShowFOV, Callback = function(v)
    Config.ShowFOV = v
    SilentAimModule:SetShowFOVCircle(v)
    save()
end })
Aim:Slider({
    Title = "FOV Radius",
    Step = 5,
    Value = { Min = 10, Max = 2000, Default = Config.FOVRadius or 150 },
    Callback = function(v)
        Config.FOVRadius = v
        SilentAimModule:SetFOVRadius(v)
        -- AIM TP (Soru) same size
        Config.SoruFOVRadius = v
        SilentAimModule:SetSoruFOVRadius(v)
        save()
    end,
})
Aim:Slider({
    Title = "Max Range",
    Step = 50,
    Value = { Min = 50, Max = 10000, Default = Config.AimMaxRange or 2000 },
    Callback = function(v)
        Config.AimMaxRange = v
        SilentAimModule:SetDistanceLimit(v)
        save()
    end,
})
Aim:Toggle({ Title = "M1 Extender (solo rango)", Value = Config.M1Extender, Callback = function(v)
    Config.M1Extender = v
    M1ExtenderMod:Toggle(v)
    save()
end })
Aim:Slider({
    Title = "M1 Range",
    Step = 5,
    Value = { Min = 10, Max = 300, Default = Config.M1Range or 50 },
    Callback = function(v)
        Config.M1Range = v
        M1ExtenderMod:SetRange(v)
        save()
    end,
})
Aim:Toggle({ Title = "Gun Click SL", Value = Config.GunClickSL, Callback = function(v)
    Config.GunClickSL = v
    GunClickSLMod:SetEnabled(v)
    save()
end })
Aim:Toggle({ Title = "Z Boost", Value = Config.ZBoostEnabled, Callback = function(v)
    Config.ZBoostEnabled = v
    if v then createBoostGui() else destroyBoostGui() end
    save()
end })
Aim:Slider({
    Title = "Z Boost Power",
    Step = 10,
    Value = { Min = 100, Max = 2000, Default = Config.ZBoostPower or 450 },
    Callback = function(v) Config.ZBoostPower = v; save() end,
})
Aim:Toggle({ Title = "Soru Auto Aim", Value = Config.SoruAutoAim, Callback = function(v)
    Config.SoruAutoAim = v
    SilentAimModule:SetSoruAutoAim(v)
    save()
end })
Aim:Dropdown({
    Title = "Soru Aim Mode",
    Values = {"360", "180", "FOV"},
    Value = Config.SoruAimMode or "360",
    Callback = function(v)
        Config.SoruAimMode = v
        SilentAimModule:SetSoruAimMode(v)
        save()
    end,
})
Aim:Dropdown({
    Title = "Soru FOV Type",
    Values = {"V1", "V2"},
    Value = Config.SoruFOVType or "V1",
    Callback = function(v)
        Config.SoruFOVType = v
        SilentAimModule:SetSoruFOVType(v)
        save()
    end,
})
Aim:Dropdown({
    Title = "Soru Priority",
    Values = {"Nearest", "Low HP", "Looking At Me"},
    Value = Config.SoruPriority or "Nearest",
    Callback = function(v)
        Config.SoruPriority = v
        SilentAimModule:SetSoruPriority(v)
        save()
    end,
})
Aim:Slider({
    Title = "Soru FOV Radius",
    Step = 5,
    Value = { Min = 10, Max = 2000, Default = Config.SoruFOVRadius or 150 },
    Callback = function(v)
        Config.SoruFOVRadius = v
        SilentAimModule:SetSoruFOVRadius(v)
        save()
    end,
})
Aim:Slider({
    Title = "Soru Max Range",
    Step = 10,
    Value = { Min = 50, Max = 1000, Default = Config.SoruRange or 300 },
    Callback = function(v)
        Config.SoruRange = v
        SilentAimModule:SetSoruRange(v)
        save()
    end,
})
Aim:Toggle({ Title = "Show Soru FOV", Value = Config.SoruShowFOV, Callback = function(v)
    Config.SoruShowFOV = v
    SilentAimModule:SetSoruShowFOVCircle(v)
    save()
end })
Aim:Toggle({ Title = "Tracer", Value = Config.Tracer, Callback = function(v)
    Config.Tracer = v
    SilentAimModule:SetTracerEnabled(v)
    save()
end })

local BL = Window:Tab({ Title = "Blacklist", Icon = "ban" })
local function blToggle(cat, key)
    local ck = "BL_" .. cat .. "_" .. key
    BL:Toggle({
        Title = cat .. ": Blacklist " .. key,
        Value = Config[ck] == true,
        Callback = function(v)
            Config[ck] = v
            SilentAimModule:SetBlacklistKey(cat, key, v)
            save()
        end,
    })
end
-- Melee: Z X C (como Nameless)
BL:Paragraph({ Title = "--- MELEES ---", Desc = "Z / X / C" })
for _, key in ipairs({"Z", "X", "C"}) do
    blToggle("Melee", key)
end
-- Fruit: Z X C V F TAP
BL:Paragraph({ Title = "--- FRUITS ---", Desc = "Z / X / C / V / F / TAP" })
for _, key in ipairs({"Z", "X", "C", "V", "F", "TAP"}) do
    blToggle("Fruit", key)
end
-- Sword: Z X
BL:Paragraph({ Title = "--- SWORDS ---", Desc = "Z / X" })
for _, key in ipairs({"Z", "X"}) do
    blToggle("Sword", key)
end
-- Gun: Z X
BL:Paragraph({ Title = "--- GUNS ---", Desc = "Z / X" })
for _, key in ipairs({"Z", "X"}) do
    blToggle("Gun", key)
end

local Misc = Window:Tab({ Title = "Misc", Icon = "settings" })
Misc:Toggle({ Title = "Notifications", Value = Config.Notifications, Callback = function(v)
    Config.Notifications = v
    save()
end })
Misc:Toggle({ Title = "Anti AFK", Value = Config.AntiAFK, Callback = function(v) Config.AntiAFK = v; save() end })
Misc:Toggle({ Title = "Auto V3", Value = Config.AutoV3, Callback = function(v) Config.AutoV3 = v; save() end })
Misc:Toggle({ Title = "Auto V4", Value = Config.AutoV4, Callback = function(v) Config.AutoV4 = v; save() end })
Misc:Toggle({ Title = "Auto PvP", Value = Config.AutoPvP, Callback = function(v) Config.AutoPvP = v; save() end })
Misc:Toggle({ Title = "Infinite Zoom", Value = Config.InfiniteZoom, Callback = function(v)
    Config.InfiniteZoom = v
    lp.CameraMaxZoomDistance = v and math.huge or savedZoom
    save()
end })
Misc:Toggle({ Title = "Stats Gui", Value = Config.StatsGui, Callback = function(v)
    setStatsGui(v)
    save()
end })
Misc:Toggle({ Title = "Remove Ghost Ship", Value = Config.RemoveGhostShip, Callback = function(v)
    Config.RemoveGhostShip = v
    save()
end })
Misc:Toggle({ Title = "Walk on Water", Value = Config.WalkOnWater, Callback = function(v) Config.WalkOnWater = v; save() end })
Misc:Toggle({ Title = "Anti Lava", Value = Config.AntiLava, Callback = function(v)
    Config.AntiLava = v
    if v then startAntiLava() else stopAntiLava() end
    save()
end })
Misc:Toggle({ Title = "Speed Hack", Value = Config.SpeedEnabled, Callback = function(v)
    Config.SpeedEnabled = v
    if not v then
        local hum = lp.Character and lp.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = 16 end
    end
    save()
end })
Misc:Dropdown({
    Title = "Speed Mode",
    Values = {"WalkSpeed","CFrame","Velocity"},
    Value = Config.SpeedMode,
    Callback = function(v) Config.SpeedMode = v; save() end,
})
Misc:Slider({ Title = "Speed Value", Step = 1, Value = { Min = 16, Max = 500, Default = Config.SpeedValue }, Callback = function(v) Config.SpeedValue = v; save() end })

Misc:Button({ Title = "Buy Cyborg Race", Callback = function()
    pcall(function() CommF:InvokeServer("CyborgTrainer", "Buy") end)
    Notify("Michelle Hub", "Buy Cyborg Race enviado", 2)
end })
Misc:Button({ Title = "Buy Ghoul Race", Callback = function()
    pcall(function()
        CommF:InvokeServer("Ectoplasm", "BuyCheck", 4)
        CommF:InvokeServer("Ectoplasm", "Buy", 4)
    end)
    Notify("Michelle Hub", "Buy Ghoul Race enviado", 2)
end })
Misc:Button({ Title = "Reset Stats", Callback = function()
    pcall(function()
        CommF:InvokeServer("BlackbeardReward", "Refund", "2")
    end)
    pcall(function()
        CommF:InvokeServer("ResetStats")
    end)
    Notify("Michelle Hub", "Reset Stats enviado", 2)
end })
Misc:Button({ Title = "Reroll Race", Callback = function()
    pcall(function()
        CommF:InvokeServer("BlackbeardReward", "Reroll", "2")
    end)
    Notify("Michelle Hub", "Reroll Race enviado", 2)
end })
Misc:Button({ Title = "Save Config Now", Callback = function()
    local ok = SaveConfig()
    if ok then
        Notify("Michelle Hub", "Config guardada OK", 2)
    else
        Notify("Michelle Hub", "No se pudo guardar (sin writefile?)", 3)
    end
end })

-- ==================== POTATO GRAPHICS ====================

-- ==================== MOVEMENT TAB ====================
local Movement = Window:Tab({ Title = "Movement", Icon = "person-standing" })
Movement:Paragraph({ Title = "Fly & Speed", Desc = "Movimiento basico" })
Movement:Toggle({
    Title = "Fly",
    Value = Config.Fly,
    Callback = function(v)
        Config.Fly = v
        if v then startFly() else stopFly() end
        save()
    end,
})
Movement:Slider({
    Title = "Fly Speed",
    Step = 10,
    Value = { Min = 50, Max = 500, Default = Config.FlySpeed or 250 },
    Callback = function(v) Config.FlySpeed = v; save() end,
})
Movement:Toggle({
    Title = "Speed Hack",
    Value = Config.SpeedEnabled,
    Callback = function(v)
        Config.SpeedEnabled = v
        if not v then
            local hum = lp.Character and lp.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = 16 end
        end
        save()
    end,
})
Movement:Dropdown({
    Title = "Speed Mode",
    Values = {"WalkSpeed", "CFrame", "Velocity"},
    Value = Config.SpeedMode or "CFrame",
    Callback = function(v) Config.SpeedMode = v; save() end,
})
Movement:Slider({
    Title = "Speed Value",
    Step = 1,
    Value = { Min = 16, Max = 500, Default = Config.SpeedValue or 50 },
    Callback = function(v) Config.SpeedValue = v; save() end,
})

Movement:Paragraph({ Title = "Movement", Desc = "Noclip, jump, dash, etc." })
Movement:Toggle({
    Title = "Noclip",
    Value = false,
    Callback = function(v)
        if v then StartNoclip() else StopNoclip() end
        save()
    end,
})
Movement:Toggle({
    Title = "Infinite Jump",
    Value = false,
    Callback = function(v)
        if v then StartInfiniteJump() else StopInfiniteJump() end
        save()
    end,
})
Movement:Toggle({
    Title = "Super Jump",
    Value = false,
    Callback = function(v)
        MovementState.SuperJump = v
        save()
    end,
})
Movement:Slider({
    Title = "Super Jump Power",
    Step = 5,
    Value = { Min = 50, Max = 300, Default = 100 },
    Callback = function(v)
        MovementState.SuperJumpPower = v
        save()
    end,
})
Movement:Toggle({
    Title = "Bunny Hop",
    Value = false,
    Callback = function(v)
        if v then StartBunnyHop() else StopBunnyHop() end
        save()
    end,
})
Movement:Toggle({
    Title = "No Fall Damage",
    Value = false,
    Callback = function(v)
        if v then StartNoFall() else StopNoFall() end
        save()
    end,
})
Movement:Toggle({
    Title = "Dash Distance",
    Value = false,
    Callback = function(v)
        if v then StartDashDistance() else StopDashDistance() end
        save()
    end,
})
Movement:Slider({
    Title = "Dash Length",
    Step = 5,
    Value = { Min = 10, Max = 200, Default = 50 },
    Callback = function(v)
        MovementState.DashLength = v
        save()
    end,
})
Movement:Toggle({
    Title = "Custom Hip Height",
    Value = false,
    Callback = function(v)
        if v then StartHipHeight() else StopHipHeight() end
        save()
    end,
})
Movement:Slider({
    Title = "Hip Height Value",
    Step = 0.5,
    Value = { Min = 0, Max = 20, Default = 2 },
    Callback = function(v)
        MovementState.HipHeightValue = v
        save()
    end,
})


local Potato = Window:Tab({ Title = "Potato Graphics", Icon = "monitor" })
Potato:Paragraph({ Title = "No GFX (Nameless)", Desc = "V1 = particles/beams | V2 = + hotbar icons" })
Potato:Dropdown({
    Title = "No GFX Mode",
    Values = {"Off", "V1", "V2"},
    Value = Config.NoGfxMode or "Off",
    Callback = function(v)
        setNoGfxMode(v)
        save()
    end,
})
Potato:Paragraph({ Title = "Low Graphics (Cestian)", Desc = "Bajar calidad del juego" })
Potato:Toggle({
    Title = "Low Graphics",
    Value = Config.LowGraphics or false,
    Callback = function(v)
        Config.LowGraphics = v
        pcall(function()
            if v then
                settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
                UserSettings():GetService("UserGameSettings").SavedQualityLevel = Enum.SavedQualitySetting.QualityLevel1
            else
                settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic
            end
        end)
        save()
    end,
})
Potato:Toggle({
    Title = "Disable Shadows",
    Value = Config.DisableShadows or false,
    Callback = function(v)
        Config.DisableShadows = v
        pcall(function()
            Lighting.GlobalShadows = not v
        end)
        save()
    end,
})
Potato:Toggle({
    Title = "No Fog",
    Value = Config.NoFog or false,
    Callback = function(v)
        Config.NoFog = v
        pcall(function()
            if v then
                Lighting.FogEnd = 9e9
                Lighting.FogStart = 9e9
            else
                Lighting.FogEnd = 100000
            end
        end)
        save()
    end,
})
Potato:Paragraph({ Title = "Fast Flags (Cestian)", Desc = "Inyecta FFlags del executor (FPS / red / fisica)" })
Potato:Button({
    Title = "Inject Fast Flags 1",
    Callback = function()
        local n, f = InjectFastFlags(1)
        Notify("Michelle Hub", "FF1: " .. tostring(n) .. " ok | " .. tostring(f) .. " fail", 3)
    end,
})
Potato:Button({
    Title = "Inject Fast Flags 2",
    Callback = function()
        local n, f = InjectFastFlags(2)
        Notify("Michelle Hub", "FF2: " .. tostring(n) .. " ok | " .. tostring(f) .. " fail", 3)
    end,
})
Potato:Button({
    Title = "Inject Fast Flags 3",
    Callback = function()
        local n, f = InjectFastFlags(3)
        Notify("Michelle Hub", "FF3: " .. tostring(n) .. " ok | " .. tostring(f) .. " fail", 3)
    end,
})
Potato:Button({
    Title = "Inject All Fast Flags",
    Callback = function()
        local n1, f1 = InjectFastFlags(1)
        local n2, f2 = InjectFastFlags(2)
        local n3, f3 = InjectFastFlags(3)
        Notify("Michelle Hub", "Total: " .. tostring(n1+n2+n3) .. " flags inyectadas", 3)
    end,
})

task.defer(function()
    if Config.Fly then startFly() end
    if Config.AntiLava then startAntiLava() end
    if Config.InfiniteZoom then lp.CameraMaxZoomDistance = math.huge end
    if Config.ZBoostEnabled then createBoostGui() end
    if Config.StatsGui then setStatsGui(true) end
    if Config.FruitM1 then FruitM1.SetNormal(true) end
    if Config.TrackerFly then StartTrackerFly() end
    if Config.AutoFlee then StartAutoFlee() end
    if Config.GunClickSL then GunClickSLMod:SetEnabled(true) end
    if Config.NoGfxMode and Config.NoGfxMode ~= "Off" then setNoGfxMode(Config.NoGfxMode) end
    if Config.LowGraphics then
        pcall(function()
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        end)
    end
    if Config.BypassTpNpc then StartBypassTpNpc() end
end)

Notify("Michelle Hub", "Cargado correctamente", 3)
print("Michelle Hub")
