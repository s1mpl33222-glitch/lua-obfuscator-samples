local repo = "https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

local Options = getgenv().Options
local Toggles = getgenv().Toggles

Library.ShowToggleFrameInKeybinds = true
Library.ShowCustomCursor = true
Library.NotifySide = "Left"

local Window = Library:CreateWindow({
    Title = "Floppa Hub",
    Center = true,
    AutoShow = true,
    Resizable = true,
    ShowCustomCursor = true,
    UnlockMouseWhileOpen = true,
    NotifySide = "Left",
    TabPadding = 8,
    MenuFadeTime = 0.2
})

local Tabs = {
    Rage = Window:AddTab("Rage"),
    Legit = Window:AddTab("Legit"),
    Visuals = Window:AddTab("Visuals"),
    World = Window:AddTab("World"),
    Misc = Window:AddTab("Misc"),
    ["UI Settings"] = Window:AddTab("UI Settings"),
}

pcall(function()
    local Event = game:GetService("ReplicatedStorage").Remotes.AnnouncementReceived
    firesignal(Event.OnClientEvent, "Thanks for using Floppa Hub!")
end)

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Teams = game:GetService("Teams")
local Stats = game:GetService("Stats")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local RagebotForcedTarget = nil
local RagebotMuzzleOrigin = nil
local AutoBlacklistSet = {}
local ScriptAlive = true

local CleanupCallbacks = {}
local TrackedDrawings = {}
local TrackedConnections = {}

local function RegisterCleanup(fn)
    table.insert(CleanupCallbacks, fn)
end

local function TrackDrawing(obj)
    table.insert(TrackedDrawings, obj)
    return obj
end

local function TrackConnection(conn)
    table.insert(TrackedConnections, conn)
    return conn
end

local FriendsCache = {}
do
    for _, p in Players:GetPlayers() do
        if p ~= LocalPlayer then
            task.spawn(function()
                local ok, result = pcall(LocalPlayer.IsFriendsWith, LocalPlayer, p.UserId)
                if ok then FriendsCache[p.Name] = result end
            end)
        end
    end
    TrackConnection(Players.PlayerAdded:Connect(function(p)
        task.spawn(function()
            local ok, result = pcall(LocalPlayer.IsFriendsWith, LocalPlayer, p.UserId)
            if ok then FriendsCache[p.Name] = result end
        end)
    end))
    TrackConnection(Players.PlayerRemoving:Connect(function(p)
        FriendsCache[p.Name] = nil
    end))
end

local PL = {
    Shoot = nil,
    rawShoot = nil,
    Bullet = nil,
    Reload = nil,
}

local PLTargeting = {}
local aimTimer, shootTimer, aimVec = os.clock(), os.clock(), Vector3.zero

local function GuardedRaycast(origin, direction, params)
    local ok, result = pcall(workspace.Raycast, workspace, origin, direction, params)
    return ok and result or nil
end

local function GuardedGetPartBoundsInBox(cframe, size, params)
    local ok, result = pcall(workspace.GetPartBoundsInBox, workspace, cframe, size, params)
    return ok and result or {}
end

PL.OriginScanner = {}
do
    local rayParams = RaycastParams.new()
    rayParams.CollisionGroup = "ClientBullet"
    rayParams.FilterType = Enum.RaycastFilterType.Exclude

    local rayParams2 = OverlapParams.new()
    rayParams2.CollisionGroup = "ClientBullet"
    rayParams2.FilterType = Enum.RaycastFilterType.Exclude

    PL.OriginScanner.Ray = rayParams
    PL.OriginScanner.Overlap = rayParams2

    local scanOffsets = {
        Vector3.new(0, 1, 0), Vector3.new(1, 0, 0), Vector3.new(0.7, -0.5, -0.5),
        Vector3.new(-0.1, -0.8, -0.8), Vector3.new(-0.8, -0.5, -0.5), Vector3.new(-1, 0, 0),
        Vector3.new(-0.8, 0.4, 0.4), Vector3.new(0, 0.7, 0.7), Vector3.new(0.7, 0.5, 0.5),
        Vector3.new(1, 0, 0), Vector3.new(0.7, 0, -0.8), Vector3.new(-0.1, 0, -1),
        Vector3.new(-0.8, 0, -0.8), Vector3.new(-1, 0, 0), Vector3.new(-0.8, 0, 0.7),
        Vector3.new(0, 0, 1), Vector3.new(0.7, 0, 0.7), Vector3.new(1, 0, 0),
        Vector3.new(0.7, 0.4, -0.5), Vector3.new(-0.1, 0.7, -0.8), Vector3.new(-0.8, 0.4, -0.5),
        Vector3.new(-1, -0.1, 0), Vector3.new(-0.8, -0.5, 0.4), Vector3.new(0, -0.8, 0.7),
        Vector3.new(0.7, -0.6, 0.5), Vector3.new(0, -1, 0),
    }

    local wallbangIgnoreList = {}

    local function RefreshWallbangIgnoreList()
        table.clear(wallbangIgnoreList)
        if LocalPlayer.Character then table.insert(wallbangIgnoreList, LocalPlayer.Character) end
        for _, player in ipairs(Players:GetPlayers()) do
            if player.Character then table.insert(wallbangIgnoreList, player.Character) end
        end
        rayParams.FilterDescendantsInstances = wallbangIgnoreList
        rayParams2.FilterDescendantsInstances = wallbangIgnoreList
    end

    function PL.OriginScanner:UpdateIgnore()
        rayParams.FilterDescendantsInstances = wallbangIgnoreList
        rayParams2.FilterDescendantsInstances = wallbangIgnoreList
    end

    RefreshWallbangIgnoreList()

    TrackConnection(Players.PlayerAdded:Connect(function(player)
        RefreshWallbangIgnoreList()
        TrackConnection(player.CharacterAdded:Connect(RefreshWallbangIgnoreList))
    end))
    TrackConnection(Players.PlayerRemoving:Connect(RefreshWallbangIgnoreList))
    TrackConnection(LocalPlayer.CharacterAdded:Connect(RefreshWallbangIgnoreList))

    function PL.OriginScanner:Scan(origin, target, ...)
        local scanPositions = {}
        for _, v in {...} do
            local pos = typeof(v) == "Instance" and v:IsA("BasePart") and v.Position or v
            if typeof(pos) == "Vector3" and (origin - pos).Magnitude < 7.5 then
                table.insert(scanPositions, pos)
            end
        end
        for i = 5, 7 do
            for _, v in scanOffsets do
                table.insert(scanPositions, origin + v * i)
            end
        end
        for _, pos in scanPositions do
            local ray = GuardedRaycast(target, (pos - target), rayParams)
            if not ray and #GuardedGetPartBoundsInBox(CFrame.new(pos), Vector3.one * 0.1, rayParams2) <= 0 then
                return pos
            end
        end
    end
end

function PL.resolveShoot()
    local home = LocalPlayer.PlayerGui:FindFirstChild("Home")
    if not home then return false end
    local hud = home:FindFirstChild("hud")
    if not hud then return false end
    local actionArea = hud:FindFirstChild("ActionArea")
    if not actionArea then return false end

    for _, connection in getconnections(actionArea.InputBegan) do
        if connection.Function then
            local ok, shootFn = pcall(debug.getupvalue, connection.Function, 2)
            if ok and type(shootFn) == "function" then
                PL.Shoot = shootFn
                PL.rawShoot = shootFn
                pcall(function()
                    PL.Reload = debug.getupvalue(shootFn, 2)
                    PL.Bullet = debug.getupvalue(shootFn, 16)
                end)
                if not PL.Bullet then
                    for i = 1, 30 do
                        local ok2, val = pcall(debug.getupvalue, shootFn, i)
                        if ok2 and type(val) == "function" then
                            PL.Bullet = val
                            break
                        end
                    end
                end
                return PL.Bullet ~= nil
            end
        end
    end
    return false
end

function PL.getGunData()
    local fn = PL.rawShoot
    if not fn then return nil end
    for i = 1, 40 do
        local ok, data = pcall(debug.getupvalue, fn, i)
        if ok and type(data) == "table" and data.Range ~= nil then
            return data
        end
    end
    return nil
end

function PL.getMousePosition()
    if UserInputService.TouchEnabled then
        return Camera.ViewportSize / 2
    end
    return UserInputService:GetMouseLocation()
end

function PL.GetInmateStatus(character)
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid then return "Regular" end
    local displayName = humanoid.DisplayName
    if string.sub(displayName, 1, 4) == "\xF0\x9F\x94\x97" then return "Arrestable"
    elseif string.sub(displayName, 1, 4) == "\xF0\x9F\x92\xA2" then return "Aggressive" end
    return "Regular"
end

function PL.passesCombatFilters(player, character, filters)
    local isBlacklisted = filters.Blacklist and (filters.Blacklist[player.Name] or (filters.AutoBlacklist and filters.AutoBlacklist[player.Name]))
    local teamName = player.Team and player.Team.Name or ""
    local myTeam = LocalPlayer.Team and LocalPlayer.Team.Name or ""

    if isBlacklisted and teamName == myTeam and teamName ~= "Inmates" then return false end
    if isBlacklisted and teamName == "Inmates" and PL.GetInmateStatus(character) == "Regular" then return false end

    if not isBlacklisted then
        if filters.Whitelist and filters.Whitelist[player.Name] then return false end
        if filters.FriendCheck and FriendsCache[player.Name] then return false end
        if filters.Teams and next(filters.Teams) and not filters.Teams[teamName] then return false end

        if teamName == "Inmates" then
            local holdingTaser = filters.HoldingTaser
            local needStatus = (filters.InmateTypes and next(filters.InmateTypes)) or (filters.ArrestSafety and not holdingTaser)
            if needStatus then
                local status = PL.GetInmateStatus(character)
                if filters.InmateTypes and next(filters.InmateTypes) and not filters.InmateTypes[status] then return false end
                if filters.ArrestSafety and not holdingTaser and status == "Arrestable" then return false end
            end
        end
    end

    local humanoid = character:FindFirstChild("Humanoid")
    if filters.DeathCheck and (not humanoid or humanoid.Health <= 0) then return false end
    if filters.ForceFieldCheck and character:FindFirstChild("ForceField") then return false end
    return true
end

function PL.wallcheck(shootOrigin, targetPos, wallbangRootPos)
    PL.OriginScanner:UpdateIgnore()
    local ray = GuardedRaycast(targetPos, shootOrigin - targetPos, PL.OriginScanner.Ray)
    if ray then
        return not wallbangRootPos or not PL.OriginScanner:Scan(wallbangRootPos, targetPos, ray.Position + ray.Normal * 0.05)
    end
    return false
end

function PLTargeting.getClosestPart(settings)
    local origin = settings.Origin or (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character.HumanoidRootPart.Position)
    if not origin then return nil end

    local localCharacter = LocalPlayer.Character
    if not localCharacter then return nil end
    local root = localCharacter:FindFirstChild("HumanoidRootPart")
    if not root then return nil end

    local boneName = settings.Bone or "Head"
    local aimRange = settings.Range or 150
    if settings.Mode == "Position" and settings.RangeLimit then
        aimRange = math.min(aimRange, settings.RangeLimit)
    end

    local wallbangRoot = settings.Wallbang and root.Position or nil
    local sortingTable = {}
    local mousePos = PL.getMousePosition()
    local filters = settings.Filters or {}

    for _, player in Players:GetPlayers() do
        if player == LocalPlayer then continue end
        local character = player.Character
        if not character then continue end
        if not PL.passesCombatFilters(player, character, filters) then continue end

        if player.Team == Teams.Inmates then
            if not (character:GetAttribute("Trespassing") or character:GetAttribute("Hostile")) then continue end
            if settings.AttackCheck and LocalPlayer.Team == Teams.Guards and not character:GetAttribute("Hostile") then continue end
        end

        local targetPart = character:FindFirstChild(boneName) or character:FindFirstChild("HumanoidRootPart")
        if not targetPart then continue end

        local magnitude
        if settings.Mode == "Mouse" then
            local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
            if not onScreen then continue end
            magnitude = (mousePos - Vector2.new(screenPos.X, screenPos.Y)).Magnitude
        else
            magnitude = (targetPart.Position - origin).Magnitude
        end

        if magnitude > aimRange then continue end
        if PL.wallcheck(origin, targetPart.Position, wallbangRoot) then continue end

        table.insert(sortingTable, {Part = targetPart, Magnitude = magnitude})
    end

    table.sort(sortingTable, function(a, b) return a.Magnitude < b.Magnitude end)
    return sortingTable[1] and sortingTable[1].Part or nil
end

function PL.applyWallbang(origin, targetPos, targetPart)
    local character = LocalPlayer.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if not root then return origin, nil end

    PL.OriginScanner:UpdateIgnore()

    local ray = GuardedRaycast(targetPos, (origin - targetPos), PL.OriginScanner.Ray)
    if not ray then
        return origin, nil
    end

    local newOrigin = PL.OriginScanner:Scan(
        root.Position,
        targetPos,
        ray.Position + ray.Normal * 0.01,
        targetPart
    )

    if newOrigin then
        return newOrigin, true
    end

    return origin, nil
end

local bulletHandlers = {}
local oldBullet = nil
local bulletHookActive = false

function PL.addBulletHandler(name, handler, priority)
    table.insert(bulletHandlers, {name, handler, priority or 0})
    table.sort(bulletHandlers, function(a, b) return a[3] < b[3] end)
    PL.ensureBulletHook()
end

function PL.removeBulletHandler(name)
    for i, v in bulletHandlers do
        if v[1] == name then
            table.remove(bulletHandlers, i)
            break
        end
    end
    if #bulletHandlers == 0 then PL.removeBulletHook() end
end

function PL.ensureBulletHook()
    if bulletHookActive or not PL.Bullet then return end
    pcall(function()
        oldBullet = hookfunction(PL.Bullet, newcclosure(function(...)
            local args = table.pack(...)
            for _, h in bulletHandlers do
                local result = h[2](args)
                if result == false then
                    return oldBullet(unpack(args, 1, args.n))
                end
            end
            return oldBullet(unpack(args, 1, args.n))
        end))
        bulletHookActive = true
    end)
end

function PL.removeBulletHook()
    if oldBullet and PL.Bullet then
        pcall(function()
            if restorefunction then
                restorefunction(PL.Bullet)
            else
                hookfunction(PL.Bullet, oldBullet)
            end
        end)
        oldBullet = nil
        bulletHookActive = false
    end
end

task.spawn(function()
    while ScriptAlive and not PL.Bullet do
        if PL.resolveShoot() then
            break
        end
        task.wait(1)
    end
end)

RegisterCleanup(function()
    local names = {}
    for _, h in bulletHandlers do table.insert(names, h[1]) end
    for _, name in names do PL.removeBulletHandler(name) end
    PL.removeBulletHook()
end)

local SilentAimLeft = Tabs.Rage:AddLeftGroupbox("Ragebot")

local SilentAimState = {
    Enabled = false,
    Triggerbot = false,
    ArrestSafety = false,
    MultiPoint = false,
    Wallbang = false,
    ShowFoV = true,
    Range = 120,
    ForceFieldCheck = true,
    DeathCheck = true,
    FriendCheck = false,
    Teams = {},
    InmateTypes = {},
    Whitelist = {},
    Blacklist = {},
}

local currentTarget = nil

local function getSAFilters()
    local holdingTaser = false
    local char = LocalPlayer.Character
    if char and SilentAimState.ArrestSafety then
        local tool = char:FindFirstChildOfClass("Tool")
        if tool then holdingTaser = tool.Name == "Taser" end
    end
    return {
        Teams = SilentAimState.Teams,
        InmateTypes = SilentAimState.InmateTypes,
        Whitelist = SilentAimState.Whitelist,
        Blacklist = SilentAimState.Blacklist,
        AutoBlacklist = AutoBlacklistSet,
        FriendCheck = SilentAimState.FriendCheck,
        DeathCheck = SilentAimState.DeathCheck,
        ForceFieldCheck = SilentAimState.ForceFieldCheck,
        ArrestSafety = SilentAimState.ArrestSafety,
        HoldingTaser = holdingTaser,
    }
end

local function saGetTarget(origin, rangeLimit, attackCheck)
    local basePart = PLTargeting.getClosestPart({
        Origin = origin,
        Mode = "Mouse",
        Range = SilentAimState.Range,
        RangeLimit = rangeLimit,
        Bone = "Head",
        AttackCheck = attackCheck,
        Wallbang = SilentAimState.Wallbang,
        Filters = getSAFilters(),
    })
    if not basePart then return nil end

    if not SilentAimState.MultiPoint then
        return basePart
    end

    local offsets = {
        Vector3.new(0, 0, 0),
        Vector3.new(0, 0.4, 0),
        Vector3.new(0, -0.3, 0),
        Vector3.new(0.35, 0.1, 0),
        Vector3.new(-0.35, 0.1, 0),
        Vector3.new(0.25, 0.2, 0.25),
        Vector3.new(-0.25, 0.2, 0.25),
        Vector3.new(0.25, 0.2, -0.25),
        Vector3.new(-0.25, 0.2, -0.25),
        Vector3.new(0, 0.15, 0.3),
        Vector3.new(0, 0.15, -0.3),
    }

    local mousePos = UserInputService:GetMouseLocation()
    local wallbangRoot = SilentAimState.Wallbang and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character.HumanoidRootPart.Position or nil

    for _, offset in offsets do
        local testPos = basePart.Position + offset
        if not PL.wallcheck(origin, testPos, wallbangRoot) then
            local screenPos, onScreen = Camera:WorldToViewportPoint(testPos)
            if onScreen then
                local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                if dist <= SilentAimState.Range then
                    return {
                        Position = testPos,
                        Parent = basePart.Parent
                    }
                end
            end
        end
    end
    return basePart
end

SilentAimLeft:AddToggle("SilentAimEnabled", {
    Text = "Enabled",
    Default = false,
    Callback = function(v)
        SilentAimState.Enabled = v
        if not v then
            PL.removeBulletHandler("SilentAim")
            currentTarget = nil
            return
        end

        PL.addBulletHandler("SilentAim", function(args)
            if not (SilentAimState.Enabled or RagebotForcedTarget) then return end

            local origin = args[1]
            local gunData = PL.getGunData()
            local rangeLimit = gunData and gunData.Range or 1000
            local attackCheck = not gunData or gunData.Behavior ~= "Taser"

            local hitPart = RagebotForcedTarget or saGetTarget(origin, rangeLimit, attackCheck)
            if not hitPart then
                currentTarget = nil
                return false
            end

            currentTarget = hitPart

            local targetPos
            local targetInstance = nil

            if typeof(hitPart) == "Instance" then
                targetPos = hitPart.Position
                targetInstance = hitPart
            elseif type(hitPart) == "table" and hitPart.Position then
                targetPos = hitPart.Position
                targetInstance = hitPart.Parent and hitPart.Parent:FindFirstChild("Head") or nil
            else
                targetPos = hitPart
            end

            args[2] = targetPos

            if SilentAimState.Wallbang then
                local newOrigin, hit = PL.applyWallbang(origin, targetPos, targetInstance)
                if newOrigin and newOrigin ~= origin then
                    pcall(function()
                        for index, value in debug.getstack(3) do
                            if value == origin then
                                debug.setstack(3, index, newOrigin)
                            end
                        end
                    end)
                    args[1] = newOrigin
                end
            end

            aimVec = args[2]
            aimTimer = os.clock() + 0.3
            shootTimer = os.clock() + 0.3
        end, 1)
    end
})

SilentAimLeft:AddToggle("SilentAimTriggerbot", {
    Text = "AutoFire",
    Default = false,
    Callback = function(v) SilentAimState.Triggerbot = v end
})

SilentAimLeft:AddToggle("SilentAimArrestSafety", {
    Text = "Arrest Safety",
    Default = false,
    Callback = function(v) SilentAimState.ArrestSafety = v end
})

SilentAimLeft:AddToggle("SilentAimMultiPoint", {
    Text = "MultiPoint",
    Default = false,
    Callback = function(v) SilentAimState.MultiPoint = v end
})

SilentAimLeft:AddToggle("SilentAimWallbang", {
    Text = "Wallbang",
    Default = false,
    Callback = function(v) SilentAimState.Wallbang = v end
})

SilentAimLeft:AddSlider("SilentAimRange", {
    Text = "FoV Size",
    Default = 120,
    Min = 10,
    Max = 600,
    Rounding = 0,
    Callback = function(v) SilentAimState.Range = v end
})

SilentAimLeft:AddToggle("SilentAimShowFoV", {
    Text = "Show FoV Circle",
    Default = true,
    Callback = function(v) SilentAimState.ShowFoV = v end
})

local FoVCircle = TrackDrawing(Drawing.new("Circle"))
FoVCircle.Visible = false
FoVCircle.Thickness = 2
FoVCircle.NumSides = 100
FoVCircle.Radius = 120
FoVCircle.Filled = false
FoVCircle.Transparency = 0
FoVCircle.Color = Color3.fromRGB(255, 255, 255)
FoVCircle.ZIndex = 999

local Tracer = TrackDrawing(Drawing.new("Line"))
Tracer.Visible = false
Tracer.Thickness = 1.5
Tracer.Transparency = 1
Tracer.Color = Color3.fromRGB(255, 255, 255)
Tracer.ZIndex = 999

local RenderConnection = RunService.RenderStepped:Connect(function()
    if not ScriptAlive then return end

    local mouse = UserInputService:GetMouseLocation()

    if SilentAimState.Enabled and SilentAimState.ShowFoV then
        FoVCircle.Position = Vector2.new(mouse.X, mouse.Y)
        FoVCircle.Radius = SilentAimState.Range
        FoVCircle.Color = Color3.fromRGB(255, 255, 255)
        FoVCircle.Filled = false
        FoVCircle.Transparency = 0
        FoVCircle.Visible = true
    else
        FoVCircle.Visible = false
    end

    local previewTarget = nil
    if SilentAimState.Enabled or RagebotForcedTarget then
        local head = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head")
        local origin = RagebotMuzzleOrigin or (head and head.Position) or Vector3.zero
        previewTarget = RagebotForcedTarget or saGetTarget(origin, 1000, true)
        currentTarget = previewTarget
    else
        currentTarget = nil
    end

    if SilentAimState.Enabled and previewTarget then
        local pos, onScreen = Camera:WorldToViewportPoint(previewTarget.Position)
        if onScreen then
            Tracer.From = Vector2.new(mouse.X, mouse.Y)
            Tracer.To = Vector2.new(pos.X, pos.Y)
            Tracer.Color = Color3.fromRGB(255, 255, 255)
            Tracer.Visible = true
        else
            Tracer.Visible = false
        end
    else
        Tracer.Visible = false
    end

    if SilentAimState.Triggerbot and previewTarget then
        local char = LocalPlayer.Character
        if char then
            local tool = char:FindFirstChildOfClass("Tool")
            if tool and tool:FindFirstChild("Handle") and tool.Handle:FindFirstChild("ShootSound") then
                mouse1click()
            end
        end
    end
end)

RegisterCleanup(function()
    PL.removeBulletHandler("SilentAim")
    FoVCircle:Remove()
    Tracer:Remove()
    if RenderConnection then RenderConnection:Disconnect() end
end)

do
    local AimbotLeft = Tabs.Legit:AddLeftGroupbox("Aimbot")
    local AimbotRight = Tabs.Legit:AddRightGroupbox("Aimbot Settings")

    local AB = {
        Enabled = false,
        AimPart = "Head",
        FOV = 120,
        Smoothness = 0.12,
        TeamCheck = true,
        FriendCheck = false,
        VisibleCheck = true,
        Sticky = true,
        MaxDistance = 400,
        ShowFOV = true,
        AlwaysOn = false,
        Holding = false,
        CurrentTarget = nil
    }

    local FOVCircle = TrackDrawing(Drawing.new("Circle"))
    FOVCircle.Visible = false
    FOVCircle.Thickness = 1.5
    FOVCircle.NumSides = 64
    FOVCircle.Transparency = 0
    FOVCircle.Color = Color3.fromRGB(255, 255, 255)
    FOVCircle.ZIndex = 999

    local function IsVisible(from, to, ignoreChar)
        local params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Exclude
        params.FilterDescendantsInstances = {LocalPlayer.Character, ignoreChar}
        return workspace:Raycast(from, to - from, params) == nil
    end

    local function IsInFOV(part)
        if not part then return false end
        local cam = workspace.CurrentCamera
        local mouse = UserInputService:GetMouseLocation()
        local screen, onScreen = cam:WorldToViewportPoint(part.Position)
        if not onScreen or screen.Z <= 0 then return false end
        return (Vector2.new(screen.X, screen.Y) - mouse).Magnitude <= AB.FOV
    end

    local function GetTarget()
        local cam = workspace.CurrentCamera
        local mouse = UserInputService:GetMouseLocation()
        local origin = cam.CFrame.Position
        local bestPart, bestDist = nil, AB.FOV

        for _, player in Players:GetPlayers() do
            if player == LocalPlayer then continue end
            if AB.TeamCheck and player.Team and LocalPlayer.Team and player.Team == LocalPlayer.Team then continue end
            if AB.FriendCheck and FriendsCache[player.Name] then continue end

            local char = player.Character
            if not char then continue end

            local hum = char:FindFirstChildOfClass("Humanoid")
            if not hum or hum.Health <= 0 then continue end

            local part = char:FindFirstChild(AB.AimPart) or char:FindFirstChild("HumanoidRootPart")
            if not part then continue end

            if (part.Position - origin).Magnitude > AB.MaxDistance then continue end
            if AB.VisibleCheck and not IsVisible(origin, part.Position, char) then continue end

            local screen, onScreen = cam:WorldToViewportPoint(part.Position)
            if not onScreen or screen.Z <= 0 then continue end

            local dist = (Vector2.new(screen.X, screen.Y) - mouse).Magnitude
            if dist < bestDist then
                bestDist = dist
                bestPart = part
            end
        end

        return bestPart
    end

    local function Aim(part)
        if not part or not IsInFOV(part) then return end
        local cam = workspace.CurrentCamera
        local current = cam.CFrame
        local goal = CFrame.new(current.Position, part.Position)
        local alpha = math.clamp(AB.Smoothness, 0.01, 1)
        cam.CFrame = current:Lerp(goal, alpha)
    end

    TrackConnection(RunService.RenderStepped:Connect(function()
        local mouse = UserInputService:GetMouseLocation()

        if AB.Enabled and AB.ShowFOV then
            FOVCircle.Position = mouse
            FOVCircle.Radius = AB.FOV
            FOVCircle.Color = Color3.fromRGB(255, 255, 255)
            FOVCircle.Filled = false
            FOVCircle.Transparency = 0
            FOVCircle.Visible = true
        else
            FOVCircle.Visible = false
        end

        if not AB.Enabled then
            AB.CurrentTarget = nil
            return
        end

        local active = AB.AlwaysOn or AB.Holding
        if not active then
            if not AB.Sticky then
                AB.CurrentTarget = nil
            end
            return
        end

        if AB.Sticky and AB.CurrentTarget and AB.CurrentTarget.Parent then
            local hum = AB.CurrentTarget.Parent:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 and IsInFOV(AB.CurrentTarget) then
                Aim(AB.CurrentTarget)
                return
            else
                AB.CurrentTarget = nil
            end
        end

        local target = GetTarget()
        AB.CurrentTarget = target
        if target then
            Aim(target)
        end
    end))

    RegisterCleanup(function()
        FOVCircle:Remove()
    end)

    AimbotLeft:AddToggle("LegitAimbotEnabled", {
        Text = "Enabled",
        Default = false,
        Callback = function(Value)
            AB.Enabled = Value
            if not Value then
                AB.CurrentTarget = nil
                AB.Holding = false
            end
        end
    })

    AimbotLeft:AddDropdown("LegitAimbotPart", {
        Values = {"Head", "Torso", "HumanoidRootPart"},
        Default = 1,
        Multi = false,
        Text = "Aim Part",
        Callback = function(Value)
            AB.AimPart = Value
        end
    })

    AimbotLeft:AddToggle("LegitAimbotAlways", {
        Text = "Always On",
        Default = false,
        Callback = function(Value)
            AB.AlwaysOn = Value
        end
    })

    AimbotLeft:AddLabel("Aim Key"):AddKeyPicker("LegitAimbotKey", {
        Default = "E",
        Mode = "Hold",
        Text = "Aim Key",
        NoUI = false
    })

    TrackConnection(RunService.RenderStepped:Connect(function()
        local keybind = Options.LegitAimbotKey
        if keybind then
            AB.Holding = keybind:GetState()
        end
    end))

    AimbotRight:AddSlider("LegitAimbotFOV", {
        Text = "FOV",
        Default = 120,
        Min = 20,
        Max = 400,
        Rounding = 0,
        Callback = function(Value)
            AB.FOV = Value
        end
    })

    AimbotRight:AddSlider("LegitAimbotSmooth", {
        Text = "Smoothness",
        Default = 0.12,
        Min = 0.01,
        Max = 1,
        Rounding = 2,
        Callback = function(Value)
            AB.Smoothness = Value
        end
    })

    AimbotRight:AddSlider("LegitAimbotDist", {
        Text = "Max Distance",
        Default = 400,
        Min = 50,
        Max = 1000,
        Rounding = 0,
        Suffix = " studs",
        Callback = function(Value)
            AB.MaxDistance = Value
        end
    })

    AimbotRight:AddToggle("LegitAimbotTeam", {
        Text = "Team Check",
        Default = true,
        Callback = function(Value)
            AB.TeamCheck = Value
        end
    })

    AimbotRight:AddToggle("LegitAimbotFriend", {
        Text = "Friend Check",
        Default = false,
        Callback = function(Value)
            AB.FriendCheck = Value
        end
    })

    AimbotRight:AddToggle("LegitAimbotVisible", {
        Text = "Visible Check",
        Default = true,
        Callback = function(Value)
            AB.VisibleCheck = Value
        end
    })

    AimbotRight:AddToggle("LegitAimbotSticky", {
        Text = "Sticky Aim",
        Default = true,
        Callback = function(Value)
            AB.Sticky = Value
        end
    })

    AimbotRight:AddToggle("LegitAimbotShowFOV", {
        Text = "Show FOV",
        Default = true,
        Callback = function(Value)
            AB.ShowFOV = Value
        end
    })

    AimbotRight:AddLabel("FOV Color"):AddColorPicker("LegitAimbotFOVColor", {
        Default = Color3.fromRGB(255, 255, 255),
        Title = "FOV Color",
        Callback = function(Value)
        end
    })
end

local GetService = setmetatable({}, {
    __index = function(_, Name)
        return game:GetService(Name)
    end
})

local Workspace, Players, RunService, HttpService = GetService["Workspace"], GetService["Players"], GetService["RunService"], GetService["HttpService"]
local LocalPlayer, Camera = Players.LocalPlayer, Workspace.CurrentCamera
local WorldToViewportPoint, FindFirstChildOfClass, FindFirstChild = Camera.WorldToViewportPoint, game.FindFirstChildOfClass, game.FindFirstChild

local NewVector3, NewVector2, Dim, Dim2, DimOffset = Vector3.new, Vector2.new, UDim.new, UDim2.new, UDim2.fromOffset
local NumSeq = NumberSequence.new
local NumKey = NumberSequenceKeypoint.new

local Format, Spawn, Clear, Floor, Clamp, Abs, Tan, Rad, Huge, Remove = string.format, task.spawn, table.clear, math.floor, math.clamp, math.abs, math.tan, math.rad, math.huge, table.remove
local Frame, ZeroVector3, CameraPosition, CachedFocalLength, ViewPortY, Updates = 1 / 60, NewVector3(0,0,0), NewVector3(0,0,0), 0, 0, 0

local function CameraCache()
    ViewPortY = Camera.ViewportSize.Y
    CachedFocalLength = ViewPortY / (2 * Tan(Rad(Camera.FieldOfView) * 0.5))
end

CameraCache()

Camera:GetPropertyChangedSignal("FieldOfView"):Connect(CameraCache)
Camera:GetPropertyChangedSignal("ViewportSize"):Connect(CameraCache)

local EspLibrary = {
    ['Directory'] = 'Esp',
    ['Cache'] = {},
    ['Holder'] = nil,
    ['Threads'] = {},
    ['Connections'] = {},

    ['Table'] = {
        ['Enabled'] = false,
        ['ShowLocalPlayer'] = false,
        ['Distance'] = 7520,
        ['RefreshRate'] = 60,
        ['Font'] = 'TahomaBold',
        ['FontSize'] = 12,
        ['FontType'] = 'none',

        ['Boxes'] = {
            ['Enabled'] = false,
            ['DynamicBoxes'] = false,
            ['Type'] = "2D",

            ['Bounding Box'] = {
                ['Enabled'] = false,
                ['IncludeAcsessories'] = false,
                ['BoxX'] = 0,
                ['BoxY'] = 0,
            },

            ['Box Glow'] = {
                ['Enabled'] = false,
                ['Top'] = Color3.fromRGB(255, 255, 255),
                ['Bot'] = Color3.fromRGB(255, 255, 255),
                ['Transparency'] = {0.75, 0.75},
            },

            ['Gradients'] = {
                ['Top'] = Color3.fromRGB(255, 255, 255),
                ['Bot'] = Color3.fromRGB(255, 255, 255),
            },

            ['Filled'] = {
                ['Enabled'] = false,
                ['Top'] = Color3.fromRGB(255, 255, 255),
                ['Bot'] = Color3.fromRGB(255, 255, 255),
                ['Transparency'] = {1, 0.65},
            },
        },

        ['Bars'] = {
            ['Health Bar'] = {
                ['Enabled'] = false,
                ['Top'] = Color3.fromRGB(0, 255, 0),
                ['Mid'] = Color3.fromRGB(255, 170, 0),
                ['Bot'] = Color3.fromRGB(255, 0, 0),
            },

            ['Armor Bar'] = {
                ['Enabled'] = false,
                ['Top'] = Color3.fromRGB(255, 255, 255),
                ['Mid'] = Color3.fromRGB(220, 220, 220),
                ['Bot'] = Color3.fromRGB(180, 180, 180),
            },
        },

        ['Texts'] = {
            ['Name'] = {
                ['Enabled'] = false,
                ['Color'] = Color3.fromRGB(255, 255, 255),
            },

            ['Distance'] = {
                ['Enabled'] = false,
                ['Color'] = Color3.fromRGB(255, 255, 255),
            },

            ['Weapon'] = {
                ['Enabled'] = false,
                ['Color'] = Color3.fromRGB(255, 255, 255),
            },
        },

        ['Flags'] = {
            ['Walking'] = {
                ['Enabled'] = false,
                ['Color'] = Color3.fromRGB(255, 0, 0),
                ['Text'] = "Walking",
            },
            ['Jumping'] = {
                ['Enabled'] = false,
                ['Color'] = Color3.fromRGB(144, 238, 144),
                ['Text'] = "Jumping",
            },
        }
    }
}

local Table = EspLibrary.Table

local Fonts = {}; do
    local function FontsRegister(Name, Weight, Style, Asset)
        if not isfile(Asset.Id) then
            writefile(Asset.Id, Asset.Font)
        end

        if isfile(Name .. ".font") then
            delfile(Name .. ".font")
        end

        local Info = {
            name = Name,
            faces = {
                {
                    name = "Normal",
                    weight = Weight,
                    style = Style,
                    assetId = getcustomasset(Asset.Id),
                },
            },
        }

        writefile(Name .. ".font", HttpService:JSONEncode(Info))
        return getcustomasset(Name .. ".font")
    end

    Fonts.Tahoma = FontsRegister("Tahoma", 400, "Normal", {
        Id = "Tahoma.ttf",
        Font = game:HttpGet("https://github.com/i77lhm/storage/raw/refs/heads/main/fonts/fs-tahoma-8px.ttf"),
    })

    Fonts.XPTahoma = FontsRegister("XPTahoma", 400, "Normal", {
        Id = "Tahoma8PTBOLD.ttf",
        Font = game:HttpGet("https://github.com/sametexe001/luas/raw/refs/heads/main/fonts/TAHOMA-8PT-BOLD-WINDOWS-XP.TTF"),
    })

    Fonts.SmallestPixel = FontsRegister("SmallestPixel", 400, "Normal", {
        Id = "smallest_pixel-7.ttf",
        Font = game:HttpGet("https://raw.githubusercontent.com/sametexe001/luas/main/smallest_pixel-7.ttf")
    })

    Fonts.ProggyTiny = FontsRegister("ProggyTiny", 400, "Normal", {
        Id = "ProggyTinyyyy.ttf",
        Font = game:HttpGet("https://github.com/i77lhm/storage/raw/refs/heads/main/fonts/ProggyTiny.ttf")
    })

    Fonts.ProggyClean = FontsRegister("ProggyClean", 400, "Normal", {
        Id = "ProggyClean.ttf",
        Font = game:HttpGet("https://github.com/i77lhm/storage/raw/main/fonts/ProggyClean.ttf"),
    })

    EspLibrary.ProggyTiny = Font.new(Fonts.ProggyClean, Enum.FontWeight.Regular, Enum.FontStyle.Normal)
    EspLibrary.TahomaBold = Font.new(Fonts.XPTahoma, Enum.FontWeight.Regular, Enum.FontStyle.Normal)
    EspLibrary.ProggyClean = Font.new(Fonts.ProggyClean, Enum.FontWeight.Regular, Enum.FontStyle.Normal)
    EspLibrary.Tahoma = Font.new(Fonts.Tahoma, Enum.FontWeight.Regular, Enum.FontStyle.Normal)
    EspLibrary.SmallestPixel = Font.new(Fonts.SmallestPixel, Enum.FontWeight.Regular, Enum.FontStyle.Normal)
end

EspLibrary.__index = EspLibrary

function EspLibrary:CreateObjects(Name, Prop)
    local New = Instance.new(Name)

    for Property, Value in Prop or {} do
        New[Property] = Value
    end

    return New
end

function EspLibrary:CreateThreads(Name, Signal, Callback)
    local Connection = Signal:Connect(Callback)
    self.Threads[Name] = Connection
    return Connection
end

EspLibrary.Holder = EspLibrary:CreateObjects("ScreenGui", {
    Name = "\n",
    Parent = gethui(),
    ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets,
    ZIndexBehavior = Enum.ZIndexBehavior.Global,
    ResetOnSpawn = false,
    DisplayOrder = 10000,
    IgnoreGuiInset = true,
})

function EspLibrary:InitEsp(Data)
    local Objects = Data.Objects

    do
        Objects["TargetHolder"] = self:CreateObjects("Frame", {
            Parent = self.Holder,
            Visible = false,
            BackgroundTransparency = 1,
            Position = Dim2(0, 0, 0, 0),
            Size = Dim2(0, 0, 0, 0),
            BorderSizePixel = 0,
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        })

        Objects["TopHolder"] = self:CreateObjects("Frame", {
            Parent = Objects["TargetHolder"],
            AutomaticSize = Enum.AutomaticSize.Y,
            Visible = true,
            BackgroundTransparency = 1,
            AnchorPoint = NewVector2(0, 1),
            Position = Dim2(0, -2, 0, -5),
            Size = Dim2(1, 4, 0, 0),
            BorderSizePixel = 0,
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        })

        Objects["BottomHolder"] = self:CreateObjects("Frame", {
            Parent = Objects["TargetHolder"],
            AutomaticSize = Enum.AutomaticSize.Y,
            Visible = true,
            BackgroundTransparency = 1,
            Position = Dim2(0, -2, 1, 3),
            Size = Dim2(1, 4, 0, 0),
            BorderSizePixel = 0,
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        })

        Objects["LeftHolder"] = self:CreateObjects("Frame", {
            Parent = Objects["TargetHolder"],
            AutomaticSize = Enum.AutomaticSize.X,
            Visible = true,
            BackgroundTransparency = 1,
            AnchorPoint = NewVector2(1, 0),
            Position = Dim2(0, -5, 0, -2),
            Size = Dim2(0, 0, 1, 4),
            BorderSizePixel = 0,
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        })

        Objects["RightHolder"] = self:CreateObjects("Frame", {
            Parent = Objects["TargetHolder"],
            AutomaticSize = Enum.AutomaticSize.X,
            Visible = true,
            BackgroundTransparency = 1,
            Position = Dim2(1, 5, 0, -2),
            Size = Dim2(0, 0, 1, 4),
            BorderSizePixel = 0,
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        })
    end

    do
        Objects["TopTextHolder"] = self:CreateObjects("Frame", {
            Parent = Objects["TopHolder"],
            AutomaticSize = Enum.AutomaticSize.Y,
            Visible = true,
            BackgroundTransparency = 1,
            Position = Dim2(0, 0, 0, 0),
            Size = Dim2(1, 0, 0, 0),
            BorderSizePixel = 0,
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        })

        Objects["BottomTextHolder"] = self:CreateObjects("Frame", {
            Parent = Objects["BottomHolder"],
            LayoutOrder = 2,
            AutomaticSize = Enum.AutomaticSize.Y,
            Visible = true,
            BackgroundTransparency = 1,
            Position = Dim2(0, 0, 0, 0),
            Size = Dim2(1, 0, 0, 0),
            BorderSizePixel = 0,
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        })

        Objects["LeftTextHolder"] = self:CreateObjects("Frame", {
            Parent = Objects["LeftHolder"],
            AutomaticSize = Enum.AutomaticSize.XY,
            Visible = true,
            BackgroundTransparency = 1,
            Position = Dim2(0, 0, 0, 0),
            Size = Dim2(1, 0, 0, 0),
            BorderSizePixel = 0,
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        })

        Objects["RightTextHolder"] = self:CreateObjects("Frame", {
            Parent = Objects["RightHolder"],
            LayoutOrder = 2,
            AutomaticSize = Enum.AutomaticSize.XY,
            Visible = true,
            BackgroundTransparency = 1,
            Position = Dim2(0, 0, 0, 0),
            Size = Dim2(0, 0, 0, 0),
            BorderSizePixel = 0,
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        })
    end

    do
        Objects["LeftBarHolder"] = self:CreateObjects("Frame", {
            Parent = Objects["LeftHolder"],
            AutomaticSize = Enum.AutomaticSize.X,
            Visible = false,
            BackgroundTransparency = 1,
            Position = Dim2(0, 0, 0, 0),
            Size = Dim2(0, 0, 1, 0),
            BorderSizePixel = 0,
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        })

        Objects["BottomBarHolder"] = self:CreateObjects("Frame", {
            Parent = Objects["BottomHolder"],
            LayoutOrder = 0,
            AutomaticSize = Enum.AutomaticSize.Y,
            Visible = false,
            BackgroundTransparency = 1,
            Position = Dim2(0, 0, 0, 0),
            Size = Dim2(1, 0, 0, 0),
            BorderSizePixel = 0,
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        })
    end

    do
        self:CreateObjects("UIListLayout", {
            Parent = Objects["TopTextHolder"],
            VerticalAlignment = Enum.VerticalAlignment.Bottom,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            Padding = Dim(0, 1),
            SortOrder = Enum.SortOrder.LayoutOrder,
        })

        self:CreateObjects("UIListLayout", {
            Parent = Objects["BottomTextHolder"],
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            Padding = Dim(0, -1),
            SortOrder = Enum.SortOrder.LayoutOrder,
        })

        self:CreateObjects("UIListLayout", {
            Parent = Objects["LeftTextHolder"],
            HorizontalAlignment = Enum.HorizontalAlignment.Right,
            Padding = Dim(0, 0),
            SortOrder = Enum.SortOrder.LayoutOrder,
        })

        self:CreateObjects("UIListLayout", {
            Parent = Objects["RightTextHolder"],
            HorizontalAlignment = Enum.HorizontalAlignment.Left,
            Padding = Dim(0, 0),
            SortOrder = Enum.SortOrder.LayoutOrder,
        })

        self:CreateObjects("UIListLayout", {
            Parent = Objects["LeftBarHolder"],
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Right,
            Padding = Dim(0, 5),
            SortOrder = Enum.SortOrder.LayoutOrder,
        })

        self:CreateObjects("UIListLayout", {
            Parent = Objects["BottomBarHolder"],
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            Padding = Dim(0, 5),
            SortOrder = Enum.SortOrder.LayoutOrder,
        })

        self:CreateObjects("UIListLayout", {
            Parent = Objects["TopHolder"],
            VerticalAlignment = Enum.VerticalAlignment.Bottom,
            Padding = Dim(0, 1),
            SortOrder = Enum.SortOrder.LayoutOrder,
        })

        self:CreateObjects("UIListLayout", {
            Parent = Objects["BottomHolder"],
            Padding = Dim(0, 1),
            SortOrder = Enum.SortOrder.LayoutOrder,
        })

        self:CreateObjects("UIListLayout", {
            Parent = Objects["LeftHolder"],
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Left,
            Padding = Dim(0, 1),
            SortOrder = Enum.SortOrder.LayoutOrder,
        })

        self:CreateObjects("UIListLayout", {
            Parent = Objects["RightHolder"],
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Left,
            Padding = Dim(0, 1),
            SortOrder = Enum.SortOrder.LayoutOrder,
        })
    end

    do
        self:CreateObjects("UIPadding", {
            Parent = Objects["TopTextHolder"],
            PaddingBottom = Dim(0, 0),
        })

        self:CreateObjects("UIPadding", {
            Parent = Objects["BottomTextHolder"],
            PaddingTop = Dim(0, -1)
        })

        self:CreateObjects("UIPadding", {
            Parent = Objects["LeftTextHolder"],
            PaddingTop = Dim(0, -3),
        })

        self:CreateObjects("UIPadding", {
            Parent = Objects["RightTextHolder"],
            PaddingTop = Dim(0, -3),
        })

        self:CreateObjects("UIPadding", {
            Parent = Objects["LeftBarHolder"],
            PaddingRight = Dim(0, 0),
        })

        self:CreateObjects("UIPadding", {
            Parent = Objects["BottomBarHolder"],
            PaddingTop = Dim(0, 2),
        })

        self:CreateObjects("UIPadding", {
            Parent = Objects["LeftHolder"],
            PaddingRight = Dim(0, 1),
        })
    end

    do
        Objects["BoxGlow"] = self:CreateObjects("ImageLabel", {
            Parent = Objects["TargetHolder"],
            Image = "rbxassetid://110204605000367",
            ScaleType = Enum.ScaleType.Slice,
            SliceCenter = Rect.new(NewVector2(21, 21), NewVector2(79, 79)),
            AutomaticSize = Enum.AutomaticSize.XY,
            ImageTransparency = 0.65,
            ResampleMode = Enum.ResamplerMode.Pixelated,
            Visible = true,
            BackgroundTransparency = 1,
            Position = Dim2(0, -21, 0, -21),
            Size = Dim2(0, 0, 0, 0),
            BorderSizePixel = 0,
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        })

        Objects["BoxGlowGradient"] = self:CreateObjects("UIGradient", {
            Parent = Objects["BoxGlow"],
            Rotation = 90,
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)),
            }),
            Transparency = NumSeq({NumKey(0, 0), NumKey(1, 0)}),
        })

        self:CreateObjects("UIPadding", {
            Parent = Objects["BoxGlow"],
            PaddingTop = Dim(0, 21),
            PaddingBottom = Dim(0, 20),
            PaddingLeft = Dim(0, 21),
            PaddingRight = Dim(0, 20),
        })

        Objects["BoxOutlineHolder"] = self:CreateObjects("Frame", {
            Parent = Objects["BoxGlow"],
            Visible = false,
            BackgroundTransparency = 1,
            Position = Dim2(0, 0, 0, 0),
            Size = Dim2(0, 0, 0, 0),
            BorderSizePixel = 0,
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        })

        Objects["BoxOutline"] = self:CreateObjects("UIStroke", {
            Parent = Objects["BoxOutlineHolder"],
            Thickness = 3,
            LineJoinMode = Enum.LineJoinMode.Miter,
        })

        Objects["BoxOutlineGradient"] = self:CreateObjects("UIGradient", {
            Parent = Objects["BoxOutline"],
            Rotation = 90,
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)),
            }),
            Transparency = NumSeq({NumKey(0, 0), NumKey(1, 0)}),
        })

        Objects["BoxInlineHolder"] = self:CreateObjects("Frame", {
            Parent = Objects["BoxGlow"],
            Visible = false,
            BackgroundTransparency = 1,
            Position = Dim2(0, -1, 0, -1),
            Size = Dim2(0, 0, 0, 0),
            BorderSizePixel = 0,
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        })

        Objects["BoxInline"] = self:CreateObjects("UIStroke", {
            Parent = Objects["BoxInlineHolder"],
            Color = Color3.fromRGB(255, 255, 255),
            LineJoinMode = Enum.LineJoinMode.Miter,
        })

        Objects["BoxInlineGradient"] = self:CreateObjects("UIGradient", {
            Parent = Objects["BoxInline"],
            Rotation = 90,
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),
            }),
            Transparency = NumSeq({NumKey(0, 0), NumKey(1, 0)}),
        })

        Objects["BoxFill"] = self:CreateObjects("Frame", {
            Parent = Objects["BoxGlow"],
            Visible = false,
            BackgroundTransparency = 0,
            Position = Dim2(0, 0, 0, 0),
            Size = Dim2(0, 0, 0, 0),
            BorderSizePixel = 0,
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        })

        Objects["BoxFillGradient"] = self:CreateObjects("UIGradient", {
            Parent = Objects["BoxFill"],
            Rotation = 90,
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),
            }),
            Transparency = NumSeq({NumKey(0, 1), NumKey(1, 1)}),
        })
    end

    do
        Objects["HealthBarOutline"] = self:CreateObjects("Frame", {
            Parent = Objects["LeftBarHolder"],
            ZIndex = 5,
            LayoutOrder = 0,
            Visible = false,
            BackgroundTransparency = 0,
            Position = Dim2(0, 0, 0, 0),
            Size = Dim2(0, 1, 1, 0),
            BorderSizePixel = 0,
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            BackgroundColor3 = Color3.fromRGB(0, 0, 0),
            ClipsDescendants = false,
        })

        self:CreateObjects("UIStroke", {
            Parent = Objects["HealthBarOutline"],
            Thickness = 1,
            LineJoinMode = Enum.LineJoinMode.Miter,
        })

        Objects["HealthBar"] = self:CreateObjects("Frame", {
            Parent = Objects["HealthBarOutline"],
            ZIndex = 6,
            AnchorPoint = NewVector2(0, 1),
            Position = Dim2(0, 0, 1, 0),
            Size = Dim2(1, 0, 1, 0),
            BorderSizePixel = 0,
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            ClipsDescendants = true,
        })

        Objects["HealthBarGradient"] = self:CreateObjects("UIGradient", {
            Parent = Objects["HealthBar"],
            Rotation = 90,
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Table['Bars']['Health Bar']['Top']),
                ColorSequenceKeypoint.new(0.5, Table['Bars']['Health Bar']['Mid']),
                ColorSequenceKeypoint.new(1, Table['Bars']['Health Bar']['Bot']),
            }),
            Transparency = NumSeq({NumKey(0, 0), NumKey(1, 0)}),
        })
    end

    do
        Objects["TargetName"] = self:CreateObjects("TextLabel", {
            Parent = Objects["TopTextHolder"],
            FontFace = EspLibrary.TahomaBold,
            TextSize = 12,
            LayoutOrder = 2,
            TextColor3 = Table['Texts']['Name']['Color'],
            Text = "",
            TextXAlignment = Enum.TextXAlignment.Center,
            BorderSizePixel = 0,
            Visible = false,
            BackgroundTransparency = 1,
            ZIndex = 5,
            AutomaticSize = Enum.AutomaticSize.XY,
            Size = Dim2(0, 0, 0, 0),
        })

        self:CreateObjects("UIStroke", {
            Parent = Objects["TargetName"],
            Color = Color3.fromRGB(0, 0, 0),
            LineJoinMode = Enum.LineJoinMode.Miter,
        })

        Objects["Distance"] = self:CreateObjects("TextLabel", {
            Parent = Objects["BottomTextHolder"],
            FontFace = EspLibrary.SmallestPixel,
            TextSize = 9,
            LayoutOrder = 2,
            TextColor3 = Table['Texts']['Distance']['Color'],
            Text = "",
            TextXAlignment = Enum.TextXAlignment.Center,
            BorderSizePixel = 0,
            Visible = false,
            BackgroundTransparency = 1,
            ZIndex = 5,
            AutomaticSize = Enum.AutomaticSize.XY,
            Size = Dim2(0, 0, 0, 0),
        })

        self:CreateObjects("UIStroke", {
            Parent = Objects["Distance"],
            Color = Color3.fromRGB(0, 0, 0),
            LineJoinMode = Enum.LineJoinMode.Miter,
        })

        Objects["WalkFlag"] = self:CreateObjects("TextLabel", {
            Parent = Objects["RightTextHolder"],
            FontFace = EspLibrary.SmallestPixel,
            TextSize = 9,
            LayoutOrder = 1,
            TextColor3 = Table['Flags']['Walking']['Color'],
            Text = Table['Flags']['Walking']['Text'],
            TextXAlignment = Enum.TextXAlignment.Left,
            BorderSizePixel = 0,
            Visible = false,
            BackgroundTransparency = 1,
            ZIndex = 5,
            AutomaticSize = Enum.AutomaticSize.XY,
            Size = Dim2(0, 0, 0, 0),
        })

        self:CreateObjects("UIStroke", {
            Parent = Objects["WalkFlag"],
            Color = Color3.fromRGB(0, 0, 0),
            LineJoinMode = Enum.LineJoinMode.Miter,
        })

        Objects["JumpFlag"] = self:CreateObjects("TextLabel", {
            Parent = Objects["RightTextHolder"],
            FontFace = EspLibrary.SmallestPixel,
            TextSize = 9,
            LayoutOrder = 2,
            TextColor3 = Table['Flags']['Jumping']['Color'],
            Text = Table['Flags']['Jumping']['Text'],
            TextXAlignment = Enum.TextXAlignment.Left,
            BorderSizePixel = 0,
            Visible = false,
            BackgroundTransparency = 1,
            ZIndex = 5,
            AutomaticSize = Enum.AutomaticSize.XY,
            Size = Dim2(0, 0, 0, 0),
        })

        self:CreateObjects("UIStroke", {
            Parent = Objects["JumpFlag"],
            Color = Color3.fromRGB(0, 0, 0),
            LineJoinMode = Enum.LineJoinMode.Miter,
        })

        Objects["Weapon"] = self:CreateObjects("TextLabel", {
            Parent = Objects["BottomTextHolder"],
            FontFace = EspLibrary.SmallestPixel,
            TextSize = 9,
            LayoutOrder = 3,
            TextColor3 = Table['Texts']['Weapon']['Color'],
            Text = "none",
            TextXAlignment = Enum.TextXAlignment.Center,
            BorderSizePixel = 0,
            Visible = false,
            BackgroundTransparency = 1,
            ZIndex = 5,
            AutomaticSize = Enum.AutomaticSize.XY,
            Size = Dim2(0, 0, 0, 0),
        })

        self:CreateObjects("UIStroke", {
            Parent = Objects["Weapon"],
            Color = Color3.fromRGB(0, 0, 0),
            LineJoinMode = Enum.LineJoinMode.Miter,
        })
    end
end

function EspLibrary:CalculateBox(Data)
    local RootPart = Data['RootPart']

    if not RootPart then
        return nil, nil, nil, nil, false
    end

    local RootScreen, OnScreen = WorldToViewportPoint(Camera, RootPart.Position)

    if not OnScreen then
        return nil, nil, nil, nil, false
    end

    local Scale = (RootPart.Size.Y * ViewPortY) / (RootScreen.Z * 2)
    local W, H = 3 * Scale, 4.5 * Scale
    return W, H, RootScreen.X - (W * 0.5), RootScreen.Y - (H * 0.5), OnScreen
end

function EspLibrary:AddTarget(Player)
    if Player == LocalPlayer and not Table['ShowLocalPlayer'] then
        return
    end

    if self.Cache[Player] then
        return
    end

    local Data = {
        ['Player'] = Player,
        ['Objects'] = {},
        ['Conns'] = {},
        ['Character'] = nil,
        ['RootPart'] = nil,
        ['Humanoid'] = nil,
        ['Children'] = nil,
        ['Health'] = 0,
        ['MaxHealth'] = 100,
        ['Armor'] = 100,
        ['MaxArmor'] = 100,
        ['CurrentTool'] = nil,
        ['Alive'] = false,
        ['LastW'] = nil,
        ['LastH'] = nil,
        ['LastX'] = nil,
        ['LastY'] = nil,
        ['WalkActive'] = false,
        ['JumpActive'] = false,
        ['FallingActive'] = false,
        ['LastGlowTop'] = nil,
        ['LastGlowBot'] = nil,
        ['LastGlowT1'] = nil,
        ['LastGlowT2'] = nil,
        ['LastGradTop'] = nil,
        ['LastGradBot'] = nil,
        ['LastFillTop'] = nil,
        ['LastFillBot'] = nil,
        ['LastFillT1'] = nil,
        ['LastFillT2'] = nil,
        ['LastDist'] = nil,
        ['LastDistColor'] = nil,
        ['LastDisplayName'] = nil,
        ['LastNameColor'] = nil,
        ['LastHealthTop'] = nil,
        ['LastHealthMid'] = nil,
        ['LastHealthBot'] = nil,
        ['LastHealthFloor'] = nil,
        ['LastRatio'] = nil,
        ['LastWeapon'] = nil,
        ['LastWeaponColor'] = nil,
    }
    self:InitEsp(Data)
    self['Cache'][Player] = Data

    local HealthHandler = {}; do
        function HealthHandler.BindHealth(Humanoid)
            if Data['Conns']['Health'] then
                Data['Conns']['Health']:Disconnect()
            end

            if Data['Conns']['Died'] then
                Data['Conns']['Died']:Disconnect()
            end

            Data['Humanoid'] = Humanoid
            Data['Health'] = Humanoid.Health
            Data['MaxHealth'] = Humanoid.MaxHealth
            Data['Alive'] = Humanoid.Health > 0

            Data['Conns']['Health'] = Humanoid.HealthChanged:Connect(function(NewHealth)
                Data['Alive'] = NewHealth > 0
                Data['Health'] = NewHealth
            end)

            Data['Conns']['Died'] = Humanoid.Died:Connect(function()
                Data['Alive'] = false
            end)
        end

        Data['BindHealth'] = HealthHandler.BindHealth
    end

    local ToolHandler = {}; do
        function ToolHandler.BindTool(Character)
            if Data['Conns']['ToolAdded'] then
                Data['Conns']['ToolAdded']:Disconnect()
            end

            if Data['Conns']['ToolRemoved'] then
                Data['Conns']['ToolRemoved']:Disconnect()
            end

            if Data['Children'] then
                for _, Child in Data['Children'] do
                    if Child:IsA('Tool') then
                        Data['CurrentTool'] = Child.Name
                        break
                    end
                end
            end

            Data['Conns']['ToolAdded'] = Character.ChildAdded:Connect(function(Child)
                if Child:IsA('Tool') then
                    Data['CurrentTool'] = Child.Name
                end
            end)

            Data['Conns']['ToolRemoved'] = Character.ChildRemoved:Connect(function(Child)
                if Child:IsA('Tool') then
                    Data['CurrentTool'] = nil
                end
            end)
        end

        Data['BindTool'] = ToolHandler.BindTool
    end

    local ChildHandler = {}; do
        function ChildHandler.BindChildren(Character)
            if Data['Conns']['ChildAdded'] then
                Data['Conns']['ChildAdded']:Disconnect()
            end

            if Data['Conns']['ChildRemoved'] then
                Data['Conns']['ChildRemoved']:Disconnect()
            end

            local Children = Character:GetChildren()
            Data['Children'] = Children

            Data['Conns']['ChildAdded'] = Character.ChildAdded:Connect(function(Child)
                Children[#Children + 1] = Child
            end)

            Data['Conns']['ChildRemoved'] = Character.ChildRemoved:Connect(function(Child)
                for I = #Children, 1, -1 do
                    if Children[I] == Child then
                        Remove(Children, I)
                        break
                    end
                end
            end)

            Data['BindTool'](Character)
        end

        Data['BindChildren'] = ChildHandler.BindChildren
    end

    local FlagsHandler = {}; do
        function FlagsHandler.BindFlags(Humanoid)
            if Data['Conns']['MoveDir'] then
                Data['Conns']['MoveDir']:Disconnect()
            end

            if Data['Conns']['StateChange'] then
                Data['Conns']['StateChange']:Disconnect()
            end

            local Objects = Data['Objects']
            Data['JumpActive'] = false
            Data['WalkActive'] = false
            Data['FallingActive'] = false

            Objects['WalkFlag'].Visible = false
            Objects['JumpFlag'].Visible = false

            Data['Conns']['MoveDir'] = Humanoid:GetPropertyChangedSignal('MoveDirection'):Connect(function()
                local Walking = Humanoid.MoveDirection ~= ZeroVector3

                if Walking and not Data['WalkActive'] then
                    Data['WalkActive'] = true

                    if Data['JumpActive'] then
                        Objects['WalkFlag'].LayoutOrder = 2
                    else
                        Objects['WalkFlag'].LayoutOrder = 1
                        Objects['JumpFlag'].LayoutOrder = 2
                    end

                    Objects['WalkFlag'].Visible = Table['Flags']['Walking']['Enabled']
                elseif not Walking and Data['WalkActive'] then
                    Data['WalkActive'] = false
                    Objects['WalkFlag'].Visible = false

                    if Data['JumpActive'] then
                        Objects['JumpFlag'].LayoutOrder = 1
                    end
                end
            end)

            Data['Conns']['StateChange'] = Humanoid.StateChanged:Connect(function(_, NewState)
                if NewState == Enum.HumanoidStateType.Freefall and not Data['JumpActive'] then
                    Data['JumpActive'] = true

                    if Data['WalkActive'] then
                        Objects['JumpFlag'].LayoutOrder = 2
                    else
                        Objects['JumpFlag'].LayoutOrder = 1
                        Objects['WalkFlag'].LayoutOrder = 2
                    end

                    Objects['JumpFlag'].Visible = Table['Flags']['Jumping']['Enabled']
                elseif NewState ~= Enum.HumanoidStateType.Jumping and Data['JumpActive'] then
                    Data['JumpActive'] = false
                    Objects['JumpFlag'].Visible = false

                    if Data['WalkActive'] then
                        Objects['WalkFlag'].LayoutOrder = 1
                    end
                end
            end)
        end

        Data['BindFlags'] = FlagsHandler.BindFlags
    end

    local CharacterHandler = {}; do
        function CharacterHandler.OnCharacter(Character)
            Data['Character'] = Character
            Data['RootPart'] = nil
            Data['Humanoid'] = nil
            Data['Children'] = nil
            Data['Alive'] = false
            Data['WalkActive'] = false
            Data['JumpActive'] = false
            Data['FallingActive'] = false

            if not Character or not Character.Parent then
                return
            end

            local RootPart = FindFirstChild(Character, "HumanoidRootPart")

            if not RootPart then
                RootPart = Character:WaitForChild('HumanoidRootPart', 10)
            end

            local Humanoid = FindFirstChildOfClass(Character, 'Humanoid')

            if not Humanoid then
                Humanoid = Character:WaitForChild('Humanoid', 10)
            end

            if not RootPart or not Humanoid then
                return
            end

            if not Character.Parent then
                return
            end

            Data['RootPart'] = RootPart
            Data['Humanoid'] = Humanoid

            Data['BindChildren'](Character)
            Data['BindHealth'](Humanoid)
            Data['BindFlags'](Humanoid)
        end

        Data['Conns']['CharAdded'] = Player.CharacterAdded:Connect(function(Character)
            task.defer(CharacterHandler.OnCharacter, Character)
        end)

        if Player.Character and Player.Character.Parent then
            task.defer(CharacterHandler.OnCharacter, Player.Character)
        end
    end
end

function EspLibrary:RemoveTarget(Player)
    local Data = self['Cache'][Player]

    if not Data then
        return
    end

    for _, Connections in Data['Conns'] do
        Connections:Disconnect()
    end

    Clear(Data['Conns'])

    if Data['Objects']['TargetHolder'] then
        Data['Objects']['TargetHolder']:Destroy()
    end

    Clear(Data['Objects'])
    self['Cache'][Player] = nil
end

function EspLibrary:Update(Player, Data)
    local Objects = Data['Objects']

    if not Data['RootPart'] then
        if Objects['TargetHolder'].Visible then
            Objects['TargetHolder'].Visible = false
        end
        return
    end

    if not Data['Alive'] then
        if Objects['TargetHolder'].Visible then
            Objects['TargetHolder'].Visible = false
        end
        return
    end

    if Player == LocalPlayer and not Table['ShowLocalPlayer'] then
        if Objects['TargetHolder'].Visible then
            Objects['TargetHolder'].Visible = false
        end
        return
    end

    local RootPos = Data['RootPart'].Position
    local Distance = Floor((CameraPosition - RootPos).Magnitude)

    if Distance > Table['Distance'] then
        if Objects['TargetHolder'].Visible then
            Objects['TargetHolder'].Visible = false
        end
        return
    end

    local W, H, X, Y, OnScreen = self:CalculateBox(Data)

    if not OnScreen or not W then
        if Objects['TargetHolder'].Visible then
            Objects['TargetHolder'].Visible = false
        end
        return
    end

    W = Floor(W)
    H = Floor(H)
    X = Floor(X)
    Y = Floor(Y)

    if not Objects['TargetHolder'].Visible then
        Objects['TargetHolder'].Visible = true
    end

    local DirtySizes = Data['LastW'] ~= W or Data['LastH'] ~= H
    local DirtyPosition = Data['LastX'] ~= X or Data['LastY'] ~= Y

    if DirtyPosition then
        Objects['TargetHolder'].Position = DimOffset(X, Y)
        Data['LastX'] = X
        Data['LastY'] = Y
    end

    if DirtySizes then
        Objects['TargetHolder'].Size = DimOffset(W, H)
        Objects['BoxGlow'].Size = DimOffset(W, H)
        Objects['BoxOutlineHolder'].Size = DimOffset(W, H)
        Objects['BoxInlineHolder'].Size = DimOffset(W + 2, H + 2)
        Objects['BoxFill'].Size = DimOffset(W, H)
        Data['LastW'] = W
        Data['LastH'] = H
    end

    local BoxesCfg = Table['Boxes']
    local TextsCfg = Table['Texts']

    if BoxesCfg['Enabled'] then
        if BoxesCfg['Box Glow']['Enabled'] then
            if Objects['BoxGlow'].ImageTransparency ~= 0 then
                Objects['BoxGlow'].ImageTransparency = 0
            end

            local GlowTop = BoxesCfg['Box Glow']['Top']
            local GlowBot = BoxesCfg['Box Glow']['Bot']

            if Data['LastGlowTop'] ~= GlowTop or Data['LastGlowBot'] ~= GlowBot then
                Objects['BoxGlowGradient'].Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, GlowTop),
                    ColorSequenceKeypoint.new(1, GlowBot),
                })
                Data['LastGlowTop'] = GlowTop
                Data['LastGlowBot'] = GlowBot
            end

            local T1 = BoxesCfg['Box Glow']['Transparency'][1]
            local T2 = BoxesCfg['Box Glow']['Transparency'][2]

            if Data['LastGlowT1'] ~= T1 or Data['LastGlowT2'] ~= T2 then
                Objects['BoxGlowGradient'].Transparency = NumSeq({NumKey(0, T1), NumKey(1, T2)})
                Data['LastGlowT1'] = T1
                Data['LastGlowT2'] = T2
            end
        else
            if Objects['BoxGlow'].ImageTransparency ~= 1 then
                Objects['BoxGlow'].ImageTransparency = 1
            end
        end

        if not Objects['BoxOutlineHolder'].Visible then
            Objects['BoxOutlineHolder'].Visible = true
        end

        if not Objects['BoxInlineHolder'].Visible then
            Objects['BoxInlineHolder'].Visible = true
        end

        local GradTop = BoxesCfg['Gradients']['Top']
        local GradBot = BoxesCfg['Gradients']['Bot']

        if Data['LastGradTop'] ~= GradTop or Data['LastGradBot'] ~= GradBot then
            Objects['BoxInlineGradient'].Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, GradTop),
                ColorSequenceKeypoint.new(1, GradBot),
            })
            Data['LastGradTop'] = GradTop
            Data['LastGradBot'] = GradBot
        end

        if BoxesCfg['Filled']['Enabled'] then
            if not Objects['BoxFill'].Visible then
                Objects['BoxFill'].Visible = true
            end

            local FillTop = BoxesCfg['Filled']['Top']
            local FillBot = BoxesCfg['Filled']['Bot']
            local FillT1 = BoxesCfg['Filled']['Transparency'][1]
            local FillT2 = BoxesCfg['Filled']['Transparency'][2]

            if Data['LastFillTop'] ~= FillTop or Data['LastFillBot'] ~= FillBot then
                Objects['BoxFillGradient'].Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, FillTop),
                    ColorSequenceKeypoint.new(1, FillBot),
                })
                Data['LastFillTop'] = FillTop
                Data['LastFillBot'] = FillBot
            end

            if Data['LastFillT1'] ~= FillT1 or Data['LastFillT2'] ~= FillT2 then
                Objects['BoxFillGradient'].Transparency = NumSeq({NumKey(0, FillT1), NumKey(1, FillT2)})
                Data['LastFillT1'] = FillT1
                Data['LastFillT2'] = FillT2
            end
        else
            if Objects['BoxFill'].Visible then
                Objects['BoxFill'].Visible = false
            end
        end
    else
        if Objects['BoxGlow'].ImageTransparency ~= 1 then
            Objects['BoxGlow'].ImageTransparency = 1
        end

        if Objects['BoxOutlineHolder'].Visible then
            Objects['BoxOutlineHolder'].Visible = false
        end

        if Objects['BoxInlineHolder'].Visible then
            Objects['BoxInlineHolder'].Visible = false
        end

        if Objects['BoxFill'].Visible then
            Objects['BoxFill'].Visible = false
        end
    end

    if TextsCfg['Name']['Enabled'] then
        if not Objects['TargetName'].Visible then
            Objects['TargetName'].Visible = true
        end

        if Data['LastDisplayName'] ~= "Floppa" then
            Objects['TargetName'].Text = "Floppa"
            Data['LastDisplayName'] = "Floppa"
        end

        local NameColor = TextsCfg['Name']['Color']

        if Data['LastNameColor'] ~= NameColor then
            Objects['TargetName'].TextColor3 = NameColor
            Data['LastNameColor'] = NameColor
        end
    else
        if Objects['TargetName'].Visible then
            Objects['TargetName'].Visible = false
        end
    end

    if TextsCfg['Distance']['Enabled'] then
        if not Objects['Distance'].Visible then
            Objects['Distance'].Visible = true
        end

        if Data['LastDist'] ~= Distance then
            Objects['Distance'].Text = Format('%dst', Distance)
            Data['LastDist'] = Distance
        end

        local DistColor = TextsCfg['Distance']['Color']

        if Data['LastDistColor'] ~= DistColor then
            Objects['Distance'].TextColor3 = DistColor
            Data['LastDistColor'] = DistColor
        end
    else
        if Objects['Distance'].Visible then
            Objects['Distance'].Visible = false
        end
    end

    local HealthCfg = Table['Bars']['Health Bar']

    if HealthCfg['Enabled'] then
        local Health = Data['Health'] or 0
        local MaxHealth = Data['MaxHealth'] or 100
        local Ratio = Clamp(Health / MaxHealth, 0, 1)

        if not Objects['LeftBarHolder'].Visible then
            Objects['LeftBarHolder'].Visible = true
        end

        if not Objects['HealthBarOutline'].Visible then
            Objects['HealthBarOutline'].Visible = true
        end

        if Data['LastRatio'] ~= Ratio then
            Objects['HealthBar'].Size = Dim2(1, 0, Ratio, 0)
            Data['LastRatio'] = Ratio
        end

        local GradTop = HealthCfg['Top']
        local GradMid = HealthCfg['Mid']
        local GradBot = HealthCfg['Bot']

        if Data['LastHealthTop'] ~= GradTop or Data['LastHealthMid'] ~= GradMid or Data['LastHealthBot'] ~= GradBot then
            Objects['HealthBarGradient'].Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, GradTop),
                ColorSequenceKeypoint.new(0.5, GradMid),
                ColorSequenceKeypoint.new(1, GradBot),
            })
            Data['LastHealthTop'] = GradTop
            Data['LastHealthMid'] = GradMid
            Data['LastHealthBot'] = GradBot
        end
    else
        if Objects['HealthBarOutline'].Visible then
            Objects['HealthBarOutline'].Visible = false
        end

        if Objects['LeftBarHolder'].Visible then
            Objects['LeftBarHolder'].Visible = false
        end
    end

    local WeaponCfg = TextsCfg['Weapon']

    if WeaponCfg['Enabled'] then
        if not Objects['Weapon'].Visible then
            Objects['Weapon'].Visible = true
        end

        local CurrentTool = Data['CurrentTool'] or 'none'

        if Data['LastWeapon'] ~= CurrentTool then
            Objects['Weapon'].Text = CurrentTool
            Data['LastWeapon'] = CurrentTool
        end

        local WeaponColor = WeaponCfg['Color']

        if Data['LastWeaponColor'] ~= WeaponColor then
            Objects['Weapon'].TextColor3 = WeaponColor
            Data['LastWeaponColor'] = WeaponColor
        end
    else
        if Objects['Weapon'].Visible then
            Objects['Weapon'].Visible = false
        end
    end
end

do
    EspLibrary:CreateThreads('Renderer', RunService.RenderStepped, function()
        if not Table['Enabled'] then
            for _, Data in EspLibrary.Cache do
                if Data['Objects']['TargetHolder'].Visible then
                    Data['Objects']['TargetHolder'].Visible = false
                end
            end
            return
        end

        local Now = os.clock()

        if Now - Updates < Frame then
            return
        end

        Updates = Now
        CameraPosition = Camera.CFrame.Position

        for Player, Data in EspLibrary.Cache do
            EspLibrary:Update(Player, Data)
        end
    end)
end

do
    for _, Player in Players:GetPlayers() do
        EspLibrary:AddTarget(Player)
    end

    EspLibrary:CreateThreads('PlayerAdded', Players.PlayerAdded, function(Player)
        EspLibrary:AddTarget(Player)
    end)

    EspLibrary:CreateThreads('PlayerRemoving', Players.PlayerRemoving, function(Player)
        EspLibrary:RemoveTarget(Player)
    end)
end

do
    function EspLibrary:Unload()
        for Player in self['Cache'] do
            self:RemoveTarget(Player)
        end

        for _, Conn in self['Connections'] do
            Conn:Disconnect()
        end

        Clear(self['Connections'])

        for _, Conn in self['Threads'] do
            Conn:Disconnect()
        end

        Clear(self['Threads'])

        if self['Holder'] then
            self['Holder']:Destroy()
            self['Holder'] = nil
        end

        Clear(self['Cache'])
    end
end

getgenv().EspLib = EspLibrary

do
    local EspLib = getgenv().EspLib
    if not EspLib then
        return
    end

    local EspConfig = EspLib.Table
    if not EspConfig then
        return
    end

    local EspLeft = Tabs.Visuals:AddLeftGroupbox("ESP")
    local EspRight = Tabs.Visuals:AddRightGroupbox("ESP Colors")
    local EspFlags = Tabs.Visuals:AddRightGroupbox("ESP Flags")

    EspLeft:AddToggle("EspEnabled", {
        Text = "Enabled",
        Default = false,
        Callback = function(Value)
            EspConfig.Enabled = Value
        end
    })

    EspLeft:AddToggle("EspShowLocal", {
        Text = "Show Local Player",
        Default = false,
        Callback = function(Value)
            EspConfig.ShowLocalPlayer = Value
        end
    })

    EspLeft:AddSlider("EspDistance", {
        Text = "Max Distance",
        Default = 1000,
        Min = 50,
        Max = 5000,
        Rounding = 0,
        Suffix = " studs",
        Callback = function(Value)
            EspConfig.Distance = Value
        end
    })

    EspLeft:AddToggle("EspBoxes", {
        Text = "Boxes",
        Default = false,
        Callback = function(Value)
            EspConfig.Boxes.Enabled = Value
        end
    })

    EspLeft:AddToggle("EspBoxGlow", {
        Text = "Box Glow",
        Default = false,
        Callback = function(Value)
            EspConfig.Boxes["Box Glow"].Enabled = Value
        end
    })

    EspLeft:AddToggle("EspFilledBox", {
        Text = "Filled Box",
        Default = false,
        Callback = function(Value)
            EspConfig.Boxes.Filled.Enabled = Value
        end
    })

    EspLeft:AddToggle("EspName", {
        Text = "Name",
        Default = false,
        Callback = function(Value)
            EspConfig.Texts.Name.Enabled = Value
        end
    })

    EspLeft:AddToggle("EspDistanceText", {
        Text = "Distance",
        Default = false,
        Callback = function(Value)
            EspConfig.Texts.Distance.Enabled = Value
        end
    })

    EspLeft:AddToggle("EspWeapon", {
        Text = "Weapon",
        Default = false,
        Callback = function(Value)
            EspConfig.Texts.Weapon.Enabled = Value
        end
    })

    EspLeft:AddToggle("EspHealthBar", {
        Text = "Health Bar",
        Default = false,
        Callback = function(Value)
            EspConfig.Bars["Health Bar"].Enabled = Value
        end
    })

    EspFlags:AddToggle("EspWalking", {
        Text = "Walking Flag",
        Default = false,
        Callback = function(Value)
            EspConfig.Flags.Walking.Enabled = Value
        end
    })

    EspFlags:AddToggle("EspJumping", {
        Text = "Jumping Flag",
        Default = false,
        Callback = function(Value)
            EspConfig.Flags.Jumping.Enabled = Value
        end
    })

    EspRight:AddLabel("Box Glow Top"):AddColorPicker("EspGlowTop", {
        Default = Color3.fromRGB(255, 255, 255),
        Title = "Box Glow Top",
        Callback = function(Value)
            EspConfig.Boxes["Box Glow"].Top = Value
        end
    })

    EspRight:AddLabel("Box Glow Bottom"):AddColorPicker("EspGlowBot", {
        Default = Color3.fromRGB(255, 255, 255),
        Title = "Box Glow Bottom",
        Callback = function(Value)
            EspConfig.Boxes["Box Glow"].Bot = Value
        end
    })

    EspRight:AddLabel("Box Gradient Top"):AddColorPicker("EspGradTop", {
        Default = Color3.fromRGB(255, 255, 255),
        Title = "Box Gradient Top",
        Callback = function(Value)
            EspConfig.Boxes.Gradients.Top = Value
        end
    })

    EspRight:AddLabel("Box Gradient Bottom"):AddColorPicker("EspGradBot", {
        Default = Color3.fromRGB(255, 255, 255),
        Title = "Box Gradient Bottom",
        Callback = function(Value)
            EspConfig.Boxes.Gradients.Bot = Value
        end
    })

    EspRight:AddLabel("Filled Top"):AddColorPicker("EspFillTop", {
        Default = Color3.fromRGB(255, 255, 255),
        Title = "Filled Top",
        Callback = function(Value)
            EspConfig.Boxes.Filled.Top = Value
        end
    })

    EspRight:AddLabel("Filled Bottom"):AddColorPicker("EspFillBot", {
        Default = Color3.fromRGB(255, 255, 255),
        Title = "Filled Bottom",
        Callback = function(Value)
            EspConfig.Boxes.Filled.Bot = Value
        end
    })

    EspRight:AddLabel("Name Color"):AddColorPicker("EspNameColor", {
        Default = Color3.fromRGB(255, 255, 255),
        Title = "Name Color",
        Callback = function(Value)
            EspConfig.Texts.Name.Color = Value
        end
    })

    EspRight:AddLabel("Distance Color"):AddColorPicker("EspDistColor", {
        Default = Color3.fromRGB(255, 255, 255),
        Title = "Distance Color",
        Callback = function(Value)
            EspConfig.Texts.Distance.Color = Value
        end
    })

    EspRight:AddLabel("Weapon Color"):AddColorPicker("EspWeaponColor", {
        Default = Color3.fromRGB(255, 255, 255),
        Title = "Weapon Color",
        Callback = function(Value)
            EspConfig.Texts.Weapon.Color = Value
        end
    })

    EspRight:AddLabel("Health Top"):AddColorPicker("EspHealthTop", {
        Default = Color3.fromRGB(0, 255, 0),
        Title = "Health Top",
        Callback = function(Value)
            EspConfig.Bars["Health Bar"].Top = Value
        end
    })

    EspRight:AddLabel("Health Mid"):AddColorPicker("EspHealthMid", {
        Default = Color3.fromRGB(255, 170, 0),
        Title = "Health Mid",
        Callback = function(Value)
            EspConfig.Bars["Health Bar"].Mid = Value
        end
    })

    EspRight:AddLabel("Health Bottom"):AddColorPicker("EspHealthBot", {
        Default = Color3.fromRGB(255, 0, 0),
        Title = "Health Bottom",
        Callback = function(Value)
            EspConfig.Bars["Health Bar"].Bot = Value
        end
    })

    RegisterCleanup(function()
        if EspLib and EspLib.Unload then
            EspLib:Unload()
        end
    end)
end

do
    local CrosshairGroup = Tabs.Visuals:AddRightGroupbox("Crosshair")

    local CH = {
        Enabled = true,
        Style = "Cross",
        Size = 12,
        Thickness = 2,
        Gap = 4,
        Color = Color3.fromRGB(255, 255, 255),
        Outline = true,
        OutlineColor = Color3.fromRGB(0, 0, 0),
        Spin = false,
        SpinSpeed = 90,
        Dot = false,
        DotSize = 2,
        Pulse = false,
        PulseSpeed = 2,
        PulseAmount = 0.3,
    }

    local CrossGui = Instance.new("ScreenGui")
    CrossGui.Name = "FloppaCrosshair"
    CrossGui.ResetOnSpawn = false
    CrossGui.IgnoreGuiInset = true
    CrossGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    CrossGui.DisplayOrder = 9999
    CrossGui.Parent = game:GetService("CoreGui")

    local CrossFrame = Instance.new("Frame")
    CrossFrame.Name = "CrossContainer"
    CrossFrame.BackgroundTransparency = 1
    CrossFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    CrossFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    CrossFrame.Size = UDim2.new(0, 0, 0, 0)
    CrossFrame.Parent = CrossGui

    local SpinFrame = Instance.new("Frame")
    SpinFrame.Name = "SpinContainer"
    SpinFrame.BackgroundTransparency = 1
    SpinFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    SpinFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    SpinFrame.Size = UDim2.new(0, 0, 0, 0)
    SpinFrame.Parent = CrossFrame

    local CrossParts = {}

    local function ClearCross()
        for _, p in ipairs(CrossParts) do
            pcall(function() p:Destroy() end)
        end
        CrossParts = {}
    end

    local function BuildCross()
        ClearCross()

        local style = CH.Style
        local size = CH.Size
        local thickness = CH.Thickness
        local gap = CH.Gap
        local color = CH.Color

        local function applyStroke(frame)
            if CH.Outline then
                local stroke = Instance.new("UIStroke")
                stroke.Color = CH.OutlineColor
                stroke.Thickness = 1
                stroke.Parent = frame
            end
        end

        if style == "Dot" then
            local dot = Instance.new("Frame")
            dot.BackgroundColor3 = color
            dot.BorderSizePixel = 0
            dot.Size = UDim2.new(0, CH.DotSize, 0, CH.DotSize)
            dot.AnchorPoint = Vector2.new(0.5, 0.5)
            dot.Position = UDim2.new(0.5, 0, 0.5, 0)
            dot.Parent = SpinFrame
            table.insert(CrossParts, dot)

        elseif style == "Circle" then
            local circle = Instance.new("Frame")
            circle.BackgroundTransparency = 1
            circle.BorderSizePixel = 0
            circle.Size = UDim2.new(0, size * 2, 0, size * 2)
            circle.AnchorPoint = Vector2.new(0.5, 0.5)
            circle.Position = UDim2.new(0.5, 0, 0.5, 0)
            circle.Parent = SpinFrame

            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(1, 0)
            corner.Parent = circle

            local stroke = Instance.new("UIStroke")
            stroke.Color = color
            stroke.Thickness = thickness
            stroke.Parent = circle

            if CH.Outline then
                local outline = Instance.new("UIStroke")
                outline.Color = CH.OutlineColor
                outline.Thickness = thickness + 1
                outline.Parent = circle
            end

            table.insert(CrossParts, circle)

        elseif style == "Square" then
            local sq = Instance.new("Frame")
            sq.BackgroundTransparency = 1
            sq.BorderSizePixel = 0
            sq.Size = UDim2.new(0, size * 2, 0, size * 2)
            sq.AnchorPoint = Vector2.new(0.5, 0.5)
            sq.Position = UDim2.new(0.5, 0, 0.5, 0)
            sq.Parent = SpinFrame

            local stroke = Instance.new("UIStroke")
            stroke.Color = color
            stroke.Thickness = thickness
            stroke.Parent = sq

            if CH.Outline then
                local outline = Instance.new("UIStroke")
                outline.Color = CH.OutlineColor
                outline.Thickness = thickness + 1
                outline.Parent = sq
            end

            table.insert(CrossParts, sq)

        else
            local positions = {
                {UDim2.new(0.5, 0, 0.5, -gap), UDim2.new(0, thickness, 0, size), Vector2.new(0.5, 1)},
                {UDim2.new(0.5, 0, 0.5, gap),  UDim2.new(0, thickness, 0, size), Vector2.new(0.5, 0)},
                {UDim2.new(0.5, -gap, 0.5, 0), UDim2.new(0, size, 0, thickness), Vector2.new(1, 0.5)},
                {UDim2.new(0.5, gap, 0.5, 0),  UDim2.new(0, size, 0, thickness), Vector2.new(0, 0.5)},
            }
            for _, pos in ipairs(positions) do
                local line = Instance.new("Frame")
                line.BackgroundColor3 = color
                line.BorderSizePixel = 0
                line.Size = pos[2]
                line.Position = pos[1]
                line.AnchorPoint = pos[3]
                line.Parent = SpinFrame
                applyStroke(line)
                table.insert(CrossParts, line)
            end

            if CH.Dot then
                local dot = Instance.new("Frame")
                dot.BackgroundColor3 = color
                dot.BorderSizePixel = 0
                dot.Size = UDim2.new(0, CH.DotSize, 0, CH.DotSize)
                dot.AnchorPoint = Vector2.new(0.5, 0.5)
                dot.Position = UDim2.new(0.5, 0, 0.5, 0)
                dot.Parent = SpinFrame
                applyStroke(dot)
                table.insert(CrossParts, dot)
            end
        end
    end

    BuildCross()

    local spinAngle = 0
    local pulseTime = 0

    TrackConnection(RunService.RenderStepped:Connect(function(dt)
        if not CH.Enabled then
            CrossFrame.Visible = false
            return
        end
        CrossFrame.Visible = true

        local mouse = UserInputService:GetMouseLocation()
        CrossFrame.Position = UDim2.new(0, mouse.X, 0, mouse.Y)

        if CH.Spin then
            spinAngle = (spinAngle + CH.SpinSpeed * dt) % 360
            SpinFrame.Rotation = spinAngle
        else
            SpinFrame.Rotation = 0
        end

        if CH.Pulse then
            pulseTime = pulseTime + dt * CH.PulseSpeed
            local pulseScale = 1 + math.sin(pulseTime * math.pi * 2) * CH.PulseAmount
            SpinFrame.Size = UDim2.new(0, 0, 0, 0)
            for _, part in ipairs(CrossParts) do
                if part:IsA("Frame") then
                    local baseSize = part:GetAttribute("BaseSize")
                    if not baseSize then
                        baseSize = part.Size
                        part:SetAttribute("BaseSizeX", baseSize.X)
                        part:SetAttribute("BaseSizeY", baseSize.Y)
                        part:SetAttribute("BaseSize", true)
                    end
                end
            end
            SpinFrame.Size = UDim2.new(0, 0, 0, 0)
            CrossFrame.Size = UDim2.new(0, 0, 0, 0)
            SpinFrame.Size = UDim2.new(0, 0, 0, 0)

            local scaledSize = CH.Size * pulseScale
            local scaledGap = CH.Gap * pulseScale
            local scaledThickness = CH.Thickness * (1 + (pulseScale - 1) * 0.5)

            for _, part in ipairs(CrossParts) do
                if part:IsA("Frame") then
                    if CH.Style == "Cross" then
                        local sizeX = part.Size.X
                        local sizeY = part.Size.Y
                        if sizeY.Offset > sizeX.Offset then
                            part.Size = UDim2.new(0, scaledThickness, 0, scaledSize)
                        else
                            part.Size = UDim2.new(0, scaledSize, 0, scaledThickness)
                        end
                    elseif CH.Style == "Circle" or CH.Style == "Square" then
                        part.Size = UDim2.new(0, scaledSize * 2, 0, scaledSize * 2)
                    end
                end
            end
        end
    end))

    CrosshairGroup:AddToggle("CrosshairEnabled", {
        Text = "Enabled",
        Default = true,
        Callback = function(v)
            CH.Enabled = v
            CrossFrame.Visible = v
        end
    })

    CrosshairGroup:AddDropdown("CrosshairStyle", {
        Values = {"Cross", "Dot", "Circle", "Square"},
        Default = 1,
        Multi = false,
        Text = "Style",
        Callback = function(v)
            CH.Style = v
            BuildCross()
        end
    })

    CrosshairGroup:AddSlider("CrosshairSize", {
        Text = "Size",
        Default = 12,
        Min = 3,
        Max = 40,
        Rounding = 0,
        Callback = function(v)
            CH.Size = v
            BuildCross()
        end
    })

    CrosshairGroup:AddSlider("CrosshairThickness", {
        Text = "Thickness",
        Default = 2,
        Min = 1,
        Max = 8,
        Rounding = 0,
        Callback = function(v)
            CH.Thickness = v
            BuildCross()
        end
    })

    CrosshairGroup:AddSlider("CrosshairGap", {
        Text = "Gap",
        Default = 4,
        Min = 0,
        Max = 20,
        Rounding = 0,
        Callback = function(v)
            CH.Gap = v
            BuildCross()
        end
    })

    CrosshairGroup:AddToggle("CrosshairOutline", {
        Text = "Outline",
        Default = true,
        Callback = function(v)
            CH.Outline = v
            BuildCross()
        end
    })

    CrosshairGroup:AddLabel("Outline Color"):AddColorPicker("CrosshairOutlineColor", {
        Default = Color3.fromRGB(0, 0, 0),
        Title = "Outline Color",
        Callback = function(v)
            CH.OutlineColor = v
            BuildCross()
        end
    })

    CrosshairGroup:AddLabel("Color"):AddColorPicker("CrosshairColor", {
        Default = Color3.fromRGB(255, 255, 255),
        Title = "Crosshair Color",
        Callback = function(v)
            CH.Color = v
            BuildCross()
        end
    })

    CrosshairGroup:AddToggle("CrosshairSpin", {
        Text = "Spin",
        Default = false,
        Callback = function(v)
            CH.Spin = v
        end
    })

    CrosshairGroup:AddSlider("CrosshairSpinSpeed", {
        Text = "Spin Speed",
        Default = 90,
        Min = 10,
        Max = 720,
        Rounding = 0,
        Suffix = "°/s",
        Callback = function(v)
            CH.SpinSpeed = v
        end
    })

    CrosshairGroup:AddToggle("CrosshairPulse", {
        Text = "Pulse",
        Default = false,
        Callback = function(v)
            CH.Pulse = v
        end
    })

    CrosshairGroup:AddSlider("CrosshairPulseSpeed", {
        Text = "Pulse Speed",
        Default = 2,
        Min = 0.5,
        Max = 5,
        Rounding = 1,
        Callback = function(v)
            CH.PulseSpeed = v
        end
    })

    CrosshairGroup:AddSlider("CrosshairPulseAmount", {
        Text = "Pulse Amount",
        Default = 0.3,
        Min = 0.05,
        Max = 1,
        Rounding = 2,
        Callback = function(v)
            CH.PulseAmount = v
        end
    })

    CrosshairGroup:AddToggle("CrosshairDot", {
        Text = "Dot",
        Default = false,
        Callback = function(v)
            CH.Dot = v
            BuildCross()
        end
    })

    CrosshairGroup:AddSlider("CrosshairDotSize", {
        Text = "Dot Size",
        Default = 2,
        Min = 1,
        Max = 10,
        Rounding = 0,
        Callback = function(v)
            CH.DotSize = v
            BuildCross()
        end
    })

    RegisterCleanup(function()
        pcall(function() CrossGui:Destroy() end)
    end)
end

do
    local RemoveJumpCooldownGroup = Tabs.Misc:AddRightGroupbox("Remove Jump Cooldown")

    local NJCEnabled = false
    local jumpConnDisabled = nil

    local function onCharacterAdded(character)
        local humanoid = character:WaitForChild("Humanoid", 10)
        if not humanoid or not NJCEnabled then return end

        local conns = getconnections(humanoid:GetPropertyChangedSignal("Jump"))
        if conns[1] then
            jumpConnDisabled = conns[1]
            jumpConnDisabled:Disable()
        end
    end

    RemoveJumpCooldownGroup:AddToggle("RemoveJumpCooldownEnabled", {
        Text = "Enabled",
        Default = false,
        Callback = function(Value)
            NJCEnabled = Value
            if Value then
                if LocalPlayer.Character then
                    task.spawn(onCharacterAdded, LocalPlayer.Character)
                end
            elseif jumpConnDisabled then
                pcall(function() jumpConnDisabled:Enable() end)
                jumpConnDisabled = nil
            end
        end
    })

    TrackConnection(LocalPlayer.CharacterAdded:Connect(function(character)
        if NJCEnabled then
            task.spawn(onCharacterAdded, character)
        end
    end))

    RegisterCleanup(function()
        if jumpConnDisabled then
            pcall(function() jumpConnDisabled:Enable() end)
            jumpConnDisabled = nil
        end
    end)
end

do
    local VehicleFlyGroup = Tabs.Misc:AddLeftGroupbox("Vehicle Fly")

    local VFState = {
        Enabled = false,
        Speed = 80,
        VerticalSpeed = 60,
    }

    VehicleFlyGroup:AddToggle("VehicleFlyEnabled", {
        Text = "Enabled",
        Default = false,
        Callback = function(Value)
            VFState.Enabled = Value
        end
    })

    VehicleFlyGroup:AddLabel("Toggle Keybind"):AddKeyPicker("VehicleFlyKeybind", {
        Default = "V",
        Mode = "Toggle",
        Text = "Vehicle Fly Key",
        NoUI = false,
        Callback = function(Value)
            VFState.Enabled = Value
        end
    })

    VehicleFlyGroup:AddSlider("VehicleFlySpeed", {
        Text = "Speed",
        Default = 80,
        Min = 10,
        Max = 300,
        Rounding = 0,
        Suffix = " studs/s",
        Callback = function(Value)
            VFState.Speed = Value
        end
    })

    VehicleFlyGroup:AddSlider("VehicleFlyVertical", {
        Text = "Vertical Speed",
        Default = 60,
        Min = 10,
        Max = 200,
        Rounding = 0,
        Suffix = " studs/s",
        Callback = function(Value)
            VFState.VerticalSpeed = Value
        end
    })

    TrackConnection(RunService.Heartbeat:Connect(function()
        if not VFState.Enabled then return end

        local char = LocalPlayer.Character
        if not char then return end

        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if not humanoid or not humanoid.SeatPart then return end

        local seat = humanoid.SeatPart
        local vehicle = seat:FindFirstAncestorOfClass("Model") or seat.Parent
        if not vehicle then return end

        local root = vehicle.PrimaryPart or seat
        if not root or not root:IsA("BasePart") then return end

        local move = Vector3.zero
        local look = Camera.CFrame.LookVector
        local right = Camera.CFrame.RightVector

        look = Vector3.new(look.X, 0, look.Z)
        right = Vector3.new(right.X, 0, right.Z)

        if look.Magnitude > 0 then look = look.Unit end
        if right.Magnitude > 0 then right = right.Unit end

        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            move = move + look
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            move = move - look
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            move = move - right
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            move = move + right
        end

        if UserInputService:IsKeyDown(Enum.KeyCode.E) then
            move = move + Vector3.new(0, 1, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Q) then
            move = move - Vector3.new(0, 1, 0)
        end

        if move.Magnitude > 0 then
            local horizontal = Vector3.new(move.X, 0, move.Z)
            local vertical = Vector3.new(0, move.Y, 0)

            if horizontal.Magnitude > 0 then
                horizontal = horizontal.Unit * VFState.Speed
            end
            if vertical.Magnitude > 0 then
                vertical = vertical.Unit * VFState.VerticalSpeed
            end

            root.AssemblyLinearVelocity = horizontal + vertical
            root.AssemblyAngularVelocity = Vector3.zero
        else
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
        end
    end))
end

do
    local NoclipGroup = Tabs.Misc:AddLeftGroupbox("Noclip")

    local NC = {
        Enabled = false,
        Connection = nil
    }

    local function DisableHeadLock(char)
        local head = char and char:FindFirstChild("Head")
        if not head then return end

        for _, conn in pairs(getconnections(head:GetPropertyChangedSignal("CanCollide"))) do
            pcall(function() conn:Disable() end)
        end
    end

    local function ForceNoclip()
        local char = LocalPlayer.Character
        if not char then return end

        DisableHeadLock(char)

        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end

    local function StartNoclip()
        ForceNoclip()
        if NC.Connection then return end

        NC.Connection = RunService.Stepped:Connect(function()
            if NC.Enabled then
                ForceNoclip()
            end
        end)
    end

    local function StopNoclip()
        if NC.Connection then
            NC.Connection:Disconnect()
            NC.Connection = nil
        end
    end

    local function SetNoclip(state)
        NC.Enabled = state
        if state then
            StartNoclip()
        else
            StopNoclip()
        end
    end

    NoclipGroup:AddToggle("NoclipEnabled", {
        Text = "Enabled",
        Default = false,
        Callback = function(Value)
            SetNoclip(Value)
        end
    })

    NoclipGroup:AddLabel("Keybind"):AddKeyPicker("NoclipKeybind", {
        Default = "N",
        Mode = "Toggle",
        Text = "Noclip Key",
        NoUI = false,
        Callback = function(Value)
            SetNoclip(Value)
        end
    })

    TrackConnection(LocalPlayer.CharacterAdded:Connect(function()
        task.wait(0.4)
        if NC.Enabled then
            StartNoclip()
        end
    end))

    RegisterCleanup(function()
        StopNoclip()
    end)
end

do
    local SimulateKeycardGroup = Tabs.Misc:AddLeftGroupbox("Simulate Keycard")

    local CollectionService = game:GetService("CollectionService")

    local SKState = {
        Enabled = false,
        Connection = nil,
        CharConnection = nil,
    }

    local function openDoor(door)
        door:SetAttribute("LocalPlayerOpened", true)

        local glow = door:FindFirstChild("scn") and door.scn:FindFirstChild("glow")
        if glow then
            glow.BrickColor = BrickColor.new("Bright green")
            glow.Material = Enum.Material.Neon
        end

        local scanner = door:FindFirstChild("scn") and door.scn:FindFirstChild("cardScanner")
        if scanner and scanner:FindFirstChild("Sound") then
            scanner.Sound:Play()
        end

        task.delay(2, function()
            door:SetAttribute("LocalPlayerOpened", false)
            if glow then
                glow.BrickColor = BrickColor.new("Bright red")
                glow.Material = Enum.Material.SmoothPlastic
            end
        end)
    end

    local function onCharacterAdded(character)
        if SKState.Connection then
            SKState.Connection:Disconnect()
            SKState.Connection = nil
        end

        local root = character:WaitForChild("HumanoidRootPart", 5)
        if not root then return end

        SKState.Connection = root.Touched:Connect(function(hit)
            if not SKState.Enabled then return end
            if hit.Name ~= "hitbox" then return end

            local door = hit.Parent and hit.Parent.Parent
            if door and CollectionService:HasTag(door, "Door") then
                openDoor(door)
            end
        end)
    end

    local function start()
        if SKState.CharConnection then return end

        if LocalPlayer.Character then
            onCharacterAdded(LocalPlayer.Character)
        end

        SKState.CharConnection = LocalPlayer.CharacterAdded:Connect(onCharacterAdded)
    end

    local function stop()
        if SKState.Connection then
            SKState.Connection:Disconnect()
            SKState.Connection = nil
        end
        if SKState.CharConnection then
            SKState.CharConnection:Disconnect()
            SKState.CharConnection = nil
        end
    end

    SimulateKeycardGroup:AddToggle("SimulateKeycardEnabled", {
        Text = "Simulate Keycard",
        Default = false,
        Callback = function(Value)
            SKState.Enabled = Value
            if Value then
                start()
            else
                stop()
            end
        end
    })

    RegisterCleanup(function()
        stop()
    end)
end

do
    local TracerGroup = Tabs.Visuals:AddLeftGroupbox("Bullet Tracers")

    local BT = {
        Enabled = false,
        Color = Color3.fromRGB(255, 255, 255),
        Lifetime = 0.25,
        Fade = true,
    }

    local drawingObjs = {}

    local function clearAll()
        for obj in pairs(drawingObjs) do
            pcall(function()
                obj.Visible = false
                obj:Remove()
            end)
        end
        table.clear(drawingObjs)
    end

    local function createTracer(origin, targetPos)
        local direction = (targetPos - origin)
        local distance = direction.Magnitude
        if distance < 1 then return end

        local velocity = direction.Unit * math.min(distance, 1000)

        local line = TrackDrawing(Drawing.new("Line"))
        line.Thickness = 1.8
        line.Color = BT.Color
        line.Transparency = 1
        line.Visible = true
        line.ZIndex = 998

        drawingObjs[line] = {
            from = origin,
            to = origin + velocity,
            start = os.clock()
        }

        task.delay(BT.Lifetime, function()
            if drawingObjs[line] then
                drawingObjs[line] = nil
                pcall(function()
                    line.Visible = false
                    line:Remove()
                end)
            end
        end)
    end

    TrackConnection(RunService.RenderStepped:Connect(function()
        if not BT.Enabled then return end

        local now = os.clock()
        for line, data in pairs(drawingObjs) do
            local fromScreen, fromVis = Camera:WorldToViewportPoint(data.from)
            local toScreen, toVis = Camera:WorldToViewportPoint(data.to)

            if fromVis and toVis then
                line.From = Vector2.new(fromScreen.X, fromScreen.Y)
                line.To = Vector2.new(toScreen.X, toScreen.Y)
                line.Visible = true

                if BT.Fade then
                    local alpha = 1 - math.clamp((now - data.start) / BT.Lifetime, 0, 1)
                    line.Transparency = alpha
                end
            else
                line.Visible = false
            end
        end
    end))

    TracerGroup:AddToggle("BulletTracersEnabled", {
        Text = "Enabled",
        Default = false,
        Callback = function(Value)
            BT.Enabled = Value
            if Value then
                PL.addBulletHandler("BulletTracers", function(args)
                    if not BT.Enabled then return end
                    local origin = args[1]
                    local target = args[2]
                    if origin and target then
                        createTracer(origin, target)
                    end
                end, 5)
            else
                PL.removeBulletHandler("BulletTracers")
                clearAll()
            end
        end
    })

    TracerGroup:AddLabel("Color"):AddColorPicker("BulletTracersColor", {
        Default = Color3.fromRGB(255, 255, 255),
        Title = "Tracer Color",
        Callback = function(Value)
            BT.Color = Value
        end
    })

    TracerGroup:AddSlider("BulletTracersLifetime", {
        Text = "Lifetime",
        Default = 0.25,
        Min = 0.05,
        Max = 1,
        Rounding = 2,
        Suffix = "s",
        Callback = function(Value)
            BT.Lifetime = Value
        end
    })

    TracerGroup:AddToggle("BulletTracersFade", {
        Text = "Fade Out",
        Default = true,
        Callback = function(Value)
            BT.Fade = Value
        end
    })

    RegisterCleanup(function()
        PL.removeBulletHandler("BulletTracers")
        clearAll()
    end)
end

do
    local DamageGroup = Tabs.Visuals:AddRightGroupbox("Damage Indicator")

    local DI = {
        Enabled = false,
        Font = "GothamBlack",
        Color = Color3.fromRGB(255, 80, 80),
        Size = 18,
    }

    local lastTarget = nil
    local lastHealth = 0
    local lastTimer = 0
    local currentThread = nil
    local currentPart = nil
    local currentLabel = nil

    local function renderStepForLoop(startVal, endVal, increment, callback)
        while true do
            if endVal >= startVal then
                if callback(startVal) then
                    return
                else
                    local diff = tick()
                    RunService.RenderStepped:Wait()
                    startVal = startVal + increment * (tick() - diff) * 60
                end
            else
                callback(endVal)
                return
            end
        end
    end

    local function createIndicator(damage, pos)
        if currentThread then
            task.cancel(currentThread)
            if currentLabel then
                currentLabel.Text = tostring(math.ceil(tonumber(currentLabel.Text) + damage))
            end
            if currentPart then
                currentPart.Position = pos
            end
        else
            currentPart = Instance.new("Part")
            currentPart.Size = Vector3.zero
            currentPart.Position = pos
            currentPart.Anchored = true
            currentPart.CanCollide = false
            currentPart.CanQuery = false
            currentPart.CanTouch = false
            currentPart.Transparency = 1
            currentPart.Parent = workspace

            local billboard = Instance.new("BillboardGui")
            billboard.Adornee = currentPart
            billboard.Size = UDim2.new(0, 200, 0, 50)
            billboard.StudsOffset = Vector3.new(0, 2.5, 0)
            billboard.AlwaysOnTop = true
            billboard.Parent = currentPart

            currentLabel = Instance.new("TextLabel")
            currentLabel.BackgroundTransparency = 1
            currentLabel.Size = UDim2.fromScale(1, 1)
            currentLabel.Position = UDim2.fromScale(0.5, 0.5)
            currentLabel.AnchorPoint = Vector2.new(0.5, 0.5)
            currentLabel.Text = tostring(math.ceil(damage))
            currentLabel.TextColor3 = DI.Color
            currentLabel.TextStrokeTransparency = 0.3
            currentLabel.TextScaled = true
            currentLabel.Font = Enum.Font[DI.Font] or Enum.Font.GothamBlack
            currentLabel.Parent = billboard
        end

        if currentThread then
            task.cancel(currentThread)
            currentThread = nil
        end

        currentThread = task.spawn(function()
            local sign = math.sign(math.random() - 0.5)

            renderStepForLoop(0, 100, 3, function(value)
                if not currentLabel or not currentLabel.Parent then return true end

                local percent = value / 100
                local val0 = game:GetService("TweenService"):GetValue(percent, Enum.EasingStyle.Sine, Enum.EasingDirection.In)
                local val1 = game:GetService("TweenService"):GetValue(percent, Enum.EasingStyle.Back, Enum.EasingDirection.In)
                local scale = 1 - 0.5 * val1

                currentLabel.Position = UDim2.new(0.5 + 0.12 * val0 * sign, 0, 0.5 + 0.12 * val1, 0)
                currentLabel.Size = UDim2.new(scale, 0, 0.8 * scale, 0)
                currentLabel.Rotation = percent ^ 4 * 220 * sign
            end)

            if currentPart then
                pcall(function() currentPart:Destroy() end)
            end
            currentPart = nil
            currentLabel = nil
            currentThread = nil
        end)
    end

    local function onCharacterAdded(char)
        local humanoid = char:WaitForChild("Humanoid", 5)
        if not humanoid then return end

        local lastHp = humanoid.Health

        TrackConnection(humanoid.HealthChanged:Connect(function(newHp)
            if not DI.Enabled then return end
            if lastTimer < os.clock() then return end

            if lastHp > newHp then
                local damage = lastHp - newHp
                local head = char:FindFirstChild("Head")
                if head and damage > 0 then
                    createIndicator(damage, head.Position + Vector3.new(0, 2.2, 0))
                end
            end
            lastHp = newHp
        end))
    end

    PL.addBulletHandler("DamageIndicator", function(args)
        if not DI.Enabled then return end

        local hitPart = args[2]
        if not hitPart then return end

        local character
        if typeof(hitPart) == "Instance" then
            character = hitPart.Parent
        elseif type(hitPart) == "table" and hitPart.Parent then
            character = hitPart.Parent
        end

        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                lastTarget = character
                lastHealth = humanoid.Health
                lastTimer = os.clock() + 0.6
            end
        end
    end, 10)

    for _, player in Players:GetPlayers() do
        if player ~= LocalPlayer and player.Character then
            task.spawn(onCharacterAdded, player.Character)
        end
    end

    TrackConnection(Players.PlayerAdded:Connect(function(player)
        TrackConnection(player.CharacterAdded:Connect(function(char)
            task.spawn(onCharacterAdded, char)
        end))
    end))

    for _, player in Players:GetPlayers() do
        if player ~= LocalPlayer then
            TrackConnection(player.CharacterAdded:Connect(function(char)
                task.spawn(onCharacterAdded, char)
            end))
        end
    end

    DamageGroup:AddToggle("DamageIndicatorEnabled", {
        Text = "Enabled",
        Default = false,
        Callback = function(Value)
            DI.Enabled = Value
            if not Value then
                if currentThread then
                    pcall(task.cancel, currentThread)
                end
                if currentPart then
                    pcall(function() currentPart:Destroy() end)
                end
                currentThread = nil
                currentPart = nil
                currentLabel = nil
            end
        end
    })

    local fontList = {"GothamBlack", "GothamBold", "SourceSansBold", "ArialBold", "Cartoon", "Code", "Highway", "SciFi"}
    DamageGroup:AddDropdown("DamageIndicatorFont", {
        Values = fontList,
        Default = 1,
        Multi = false,
        Text = "Font",
        Callback = function(Value)
            DI.Font = Value
            if currentLabel then
                currentLabel.Font = Enum.Font[Value] or Enum.Font.GothamBlack
            end
        end
    })

    DamageGroup:AddLabel("Color"):AddColorPicker("DamageIndicatorColor", {
        Default = Color3.fromRGB(255, 80, 80),
        Title = "Damage Color",
        Callback = function(Value)
            DI.Color = Value
            if currentLabel then
                currentLabel.TextColor3 = Value
            end
        end
    })

    RegisterCleanup(function()
        PL.removeBulletHandler("DamageIndicator")
        if currentThread then
            pcall(task.cancel, currentThread)
        end
        if currentPart then
            pcall(function() currentPart:Destroy() end)
        end
    end)
end

do
    local Lighting = game:GetService("Lighting")

    local function GetOrCreate(class)
        local effect = Lighting:FindFirstChildOfClass(class)
        if not effect then
            effect = Instance.new(class)
            effect.Parent = Lighting
        end
        effect.Enabled = false
        return effect
    end

    local Bloom = GetOrCreate("BloomEffect")
    local SunRays = GetOrCreate("SunRaysEffect")
    local DepthOfField = GetOrCreate("DepthOfFieldEffect")
    local ColorCorrection = GetOrCreate("ColorCorrectionEffect")
    local Atmosphere = Lighting:FindFirstChildOfClass("Atmosphere") or Instance.new("Atmosphere", Lighting)
    local Sky = Lighting:FindFirstChildOfClass("Sky") or Instance.new("Sky", Lighting)

    Bloom.Intensity, Bloom.Size, Bloom.Threshold = 0.4, 24, 0.95
    SunRays.Intensity, SunRays.Spread = 0.1, 0.1
    DepthOfField.FarIntensity, DepthOfField.NearIntensity = 0, 0
    DepthOfField.FocusDistance, DepthOfField.InFocusRadius = 50, 50
    ColorCorrection.Brightness, ColorCorrection.Contrast, ColorCorrection.Saturation = 0, 0, 0
    ColorCorrection.TintColor = Color3.new(1, 1, 1)
    Atmosphere.Density, Atmosphere.Offset, Atmosphere.Glare, Atmosphere.Haze = 0, 0, 0, 0

    local Defaults = {
        Ambient = Lighting.Ambient,
        OutdoorAmbient = Lighting.OutdoorAmbient,
        Brightness = Lighting.Brightness,
        ClockTime = Lighting.ClockTime,
        GeographicLatitude = Lighting.GeographicLatitude,
        ExposureCompensation = Lighting.ExposureCompensation,
        FogColor = Lighting.FogColor,
        FogStart = Lighting.FogStart,
        FogEnd = Lighting.FogEnd,
        GlobalShadows = Lighting.GlobalShadows,
    }

    local Skyboxes = {
        ["Game's Sky"] = {
            SkyboxBk = Sky.SkyboxBk,
            SkyboxDn = Sky.SkyboxDn,
            SkyboxFt = Sky.SkyboxFt,
            SkyboxLf = Sky.SkyboxLf,
            SkyboxRt = Sky.SkyboxRt,
            SkyboxUp = Sky.SkyboxUp,
        },
        ["Purple Nebula"] = {
            SkyboxBk = "rbxassetid://159454299",
            SkyboxDn = "rbxassetid://159454296",
            SkyboxFt = "rbxassetid://159454293",
            SkyboxLf = "rbxassetid://159454286",
            SkyboxRt = "rbxassetid://159454300",
            SkyboxUp = "rbxassetid://159454288",
        },
        ["Night Sky"] = {
            SkyboxBk = "rbxassetid://12064107",
            SkyboxDn = "rbxassetid://12064152",
            SkyboxFt = "rbxassetid://12064121",
            SkyboxLf = "rbxassetid://12063984",
            SkyboxRt = "rbxassetid://12064115",
            SkyboxUp = "rbxassetid://12064131",
        },
        ["Pink Daylight"] = {
            SkyboxBk = "rbxassetid://271042516",
            SkyboxDn = "rbxassetid://271077243",
            SkyboxFt = "rbxassetid://271042556",
            SkyboxLf = "rbxassetid://271042310",
            SkyboxRt = "rbxassetid://271042467",
            SkyboxUp = "rbxassetid://271077958",
        },
        ["Morning Glow"] = {
            SkyboxBk = "rbxassetid://1417494030",
            SkyboxDn = "rbxassetid://1417494146",
            SkyboxFt = "rbxassetid://1417494253",
            SkyboxLf = "rbxassetid://1417494402",
            SkyboxRt = "rbxassetid://1417494499",
            SkyboxUp = "rbxassetid://1417494643",
        },
        ["Setting Sun"] = {
            SkyboxBk = "rbxassetid://626460377",
            SkyboxDn = "rbxassetid://626460216",
            SkyboxFt = "rbxassetid://626460513",
            SkyboxLf = "rbxassetid://626473032",
            SkyboxRt = "rbxassetid://626458639",
            SkyboxUp = "rbxassetid://626460625",
        },
        ["Fade Blue"] = {
            SkyboxBk = "rbxassetid://153695414",
            SkyboxDn = "rbxassetid://153695352",
            SkyboxFt = "rbxassetid://153695452",
            SkyboxLf = "rbxassetid://153695320",
            SkyboxRt = "rbxassetid://153695383",
            SkyboxUp = "rbxassetid://153695471",
        },
        ["Elegant Morning"] = {
            SkyboxBk = "rbxassetid://153767241",
            SkyboxDn = "rbxassetid://153767216",
            SkyboxFt = "rbxassetid://153767266",
            SkyboxLf = "rbxassetid://153767200",
            SkyboxRt = "rbxassetid://153767231",
            SkyboxUp = "rbxassetid://153767288",
        },
        ["Neptune"] = {
            SkyboxBk = "rbxassetid://218955819",
            SkyboxDn = "rbxassetid://218953419",
            SkyboxFt = "rbxassetid://218954524",
            SkyboxLf = "rbxassetid://218958493",
            SkyboxRt = "rbxassetid://218957134",
            SkyboxUp = "rbxassetid://218950090",
        },
        ["Redshift"] = {
            SkyboxBk = "rbxassetid://401664839",
            SkyboxDn = "rbxassetid://401664862",
            SkyboxFt = "rbxassetid://401664960",
            SkyboxLf = "rbxassetid://401664881",
            SkyboxRt = "rbxassetid://401664901",
            SkyboxUp = "rbxassetid://401664936",
        },
        ["Aesthetic Night"] = {
            SkyboxBk = "rbxassetid://1045964490",
            SkyboxDn = "rbxassetid://1045964368",
            SkyboxFt = "rbxassetid://1045964655",
            SkyboxLf = "rbxassetid://1045964655",
            SkyboxRt = "rbxassetid://1045964655",
            SkyboxUp = "rbxassetid://1045962969",
        },
        ["Gloomy Gray"] = {
            SkyboxBk = "rbxassetid://4495864450",
            SkyboxDn = "rbxassetid://4495864887",
            SkyboxFt = "rbxassetid://4495865458",
            SkyboxLf = "rbxassetid://4495866035",
            SkyboxRt = "rbxassetid://4495866584",
            SkyboxUp = "rbxassetid://4495867486",
        },
        ["Light Within Dark"] = {
            SkyboxBk = "rbxassetid://15502511288",
            SkyboxDn = "rbxassetid://15502508460",
            SkyboxFt = "rbxassetid://15502510289",
            SkyboxLf = "rbxassetid://15502507918",
            SkyboxRt = "rbxassetid://15502509398",
            SkyboxUp = "rbxassetid://15502511911",
        },
        ["Green Space"] = {
            SkyboxBk = "rbxassetid://16823270864",
            SkyboxDn = "rbxassetid://16823272150",
            SkyboxFt = "rbxassetid://16823273508",
            SkyboxLf = "rbxassetid://16823274898",
            SkyboxRt = "rbxassetid://16823276281",
            SkyboxUp = "rbxassetid://16823277547",
        },
        ["The Winter"] = {
            SkyboxBk = "rbxassetid://7307273436",
            SkyboxDn = "rbxassetid://7307275898",
            SkyboxFt = "rbxassetid://7307282434",
            SkyboxLf = "rbxassetid://7307284944",
            SkyboxRt = "rbxassetid://7307287254",
            SkyboxUp = "rbxassetid://7307290025",
        },
        ["Oblivion"] = {
            SkyboxBk = "rbxassetid://16642312709",
            SkyboxDn = "rbxassetid://16642313526",
            SkyboxFt = "rbxassetid://16642314757",
            SkyboxLf = "rbxassetid://16642315809",
            SkyboxRt = "rbxassetid://16642317038",
            SkyboxUp = "rbxassetid://16642318139",
        },
        ["Final Bloodmoon"] = {
            SkyboxBk = "rbxassetid://15493709538",
            SkyboxDn = "rbxassetid://15493710499",
            SkyboxFt = "rbxassetid://15493711616",
            SkyboxLf = "rbxassetid://15493712720",
            SkyboxRt = "rbxassetid://15493713902",
            SkyboxUp = "rbxassetid://15493714708",
        },
        ["Clouds"] = {
            SkyboxBk = "rbxassetid://570557514",
            SkyboxDn = "rbxassetid://570557775",
            SkyboxFt = "rbxassetid://570557559",
            SkyboxLf = "rbxassetid://570557620",
            SkyboxRt = "rbxassetid://570557672",
            SkyboxUp = "rbxassetid://570557727",
        },
        ["Twilight"] = {
            SkyboxBk = "rbxassetid://264908339",
            SkyboxDn = "rbxassetid://264907909",
            SkyboxFt = "rbxassetid://264909420",
            SkyboxLf = "rbxassetid://264909758",
            SkyboxRt = "rbxassetid://264908886",
            SkyboxUp = "rbxassetid://264907379",
        },
        ["Red Mountain"] = {
            SkyboxBk = "rbxassetid://6636457509",
            SkyboxDn = "rbxassetid://6636457509",
            SkyboxFt = "rbxassetid://6636457509",
            SkyboxLf = "rbxassetid://6636457509",
            SkyboxRt = "rbxassetid://6636457509",
            SkyboxUp = "rbxassetid://6636457509",
        },
        ["Cloudy Skies"] = {
            SkyboxBk = "rbxassetid://252760981",
            SkyboxDn = "rbxassetid://252763035",
            SkyboxFt = "rbxassetid://252761439",
            SkyboxLf = "rbxassetid://252760980",
            SkyboxRt = "rbxassetid://252762652",
            SkyboxUp = "rbxassetid://252762652",
        },
        ["Dark Blue"] = {
            SkyboxBk = "rbxassetid://30306692",
            SkyboxDn = "rbxassetid://25901058",
            SkyboxFt = "rbxassetid://30306730",
            SkyboxLf = "rbxassetid://30306626",
            SkyboxRt = "rbxassetid://30306665",
            SkyboxUp = "rbxassetid://30306603",
        },
    }

    local function ApplySkybox(name)
        local data = Skyboxes[name]
        if not data then return end
        for prop, id in pairs(data) do
            if id then Sky[prop] = id end
        end
    end

    local function RestoreDefaults()
        for k, v in pairs(Defaults) do
            pcall(function() Lighting[k] = v end)
        end
        Bloom.Enabled = false
        SunRays.Enabled = false
        DepthOfField.Enabled = false
        ColorCorrection.Enabled = false
        Atmosphere.Density = 0
        Atmosphere.Offset = 0
        Atmosphere.Glare = 0
        Atmosphere.Haze = 0
        ApplySkybox("Game's Sky")
    end

    local LocalVis = {
        ForceField = false,
        Transparency = 0,
        Color = Color3.fromRGB(0, 255, 255),
        Objects = {},
    }

    local function ClearLocalVisuals()
        for _, obj in pairs(LocalVis.Objects) do
            pcall(function() obj:Destroy() end)
        end
        table.clear(LocalVis.Objects)

        local char = LocalPlayer.Character
        if not char then return end

        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Material = Enum.Material.Plastic
                part.Transparency = 0
            end
        end

        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.Transparency = 1
        end
    end

    local function ApplyLocalVisuals()
        ClearLocalVisuals()
        local char = LocalPlayer.Character
        if not char then return end

        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.Transparency = 1
        end

        if LocalVis.ForceField then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.Material = Enum.Material.ForceField
                    part.Color = LocalVis.Color
                    part.Transparency = LocalVis.Transparency
                end
            end
        end
    end

    TrackConnection(LocalPlayer.CharacterAdded:Connect(function()
        task.wait(0.4)
        if LocalVis.ForceField then
            ApplyLocalVisuals()
        else
            local char = LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.Transparency = 1
            end
        end
    end))

    local LightingLeft = Tabs.World:AddLeftGroupbox("Lighting")
    local AtmosphereBox = Tabs.World:AddRightGroupbox("Atmosphere & Fog")
    local EffectsLeft = Tabs.World:AddLeftGroupbox("Post-Processing")
    local EffectsRight = Tabs.World:AddRightGroupbox("Color Correction")
    local SkyboxBox = Tabs.World:AddLeftGroupbox("Skybox")
    local LocalBox = Tabs.World:AddRightGroupbox("Local Character")

    LightingLeft:AddLabel("Ambient"):AddColorPicker("WorldAmbient", {
        Default = Defaults.Ambient, Title = "Ambient",
        Callback = function(v) Lighting.Ambient = v end
    })
    LightingLeft:AddLabel("Outdoor Ambient"):AddColorPicker("WorldOutdoorAmbient", {
        Default = Defaults.OutdoorAmbient, Title = "Outdoor Ambient",
        Callback = function(v) Lighting.OutdoorAmbient = v end
    })
    LightingLeft:AddSlider("WorldBrightness", {
        Text = "Brightness", Default = Defaults.Brightness, Min = 0, Max = 10, Rounding = 2,
        Callback = function(v) Lighting.Brightness = v end
    })
    LightingLeft:AddSlider("WorldClockTime", {
        Text = "Clock Time", Default = Defaults.ClockTime, Min = 0, Max = 24, Rounding = 1,
        Callback = function(v) Lighting.ClockTime = v end
    })
    LightingLeft:AddSlider("WorldLatitude", {
        Text = "Geographic Latitude", Default = Defaults.GeographicLatitude, Min = -90, Max = 90, Rounding = 0,
        Callback = function(v) Lighting.GeographicLatitude = v end
    })
    LightingLeft:AddSlider("WorldExposure", {
        Text = "Exposure Compensation", Default = Defaults.ExposureCompensation, Min = -5, Max = 5, Rounding = 2,
        Callback = function(v) Lighting.ExposureCompensation = v end
    })
    LightingLeft:AddToggle("WorldGlobalShadows", {
        Text = "Global Shadows", Default = Defaults.GlobalShadows,
        Callback = function(v) Lighting.GlobalShadows = v end
    })

    local FogEnabled = false
    local FogStart, FogEnd, FogColor = 0, 1000, Defaults.FogColor

    AtmosphereBox:AddToggle("WorldFogEnabled", {
        Text = "Fog", Default = false,
        Callback = function(v)
            FogEnabled = v
            if v then
                Lighting.FogStart = FogStart
                Lighting.FogEnd = FogEnd
                Lighting.FogColor = FogColor
            else
                Lighting.FogStart = 0
                Lighting.FogEnd = 1000000
            end
        end
    })
    AtmosphereBox:AddLabel("Fog Color"):AddColorPicker("WorldFogColor", {
        Default = Defaults.FogColor, Title = "Fog Color",
        Callback = function(v)
            FogColor = v
            if FogEnabled then Lighting.FogColor = v end
        end
    })
    AtmosphereBox:AddSlider("WorldFogStart", {
        Text = "Fog Start", Default = 0, Min = 0, Max = 2000, Rounding = 0,
        Callback = function(v)
            FogStart = v
            if FogEnabled then Lighting.FogStart = v end
        end
    })
    AtmosphereBox:AddSlider("WorldFogEnd", {
        Text = "Fog End", Default = 1000, Min = 50, Max = 5000, Rounding = 0,
        Callback = function(v)
            FogEnd = v
            if FogEnabled then Lighting.FogEnd = v end
        end
    })

    AtmosphereBox:AddDivider()

    local AtmoEnabled = false
    AtmosphereBox:AddToggle("WorldAtmosphereEnabled", {
        Text = "Atmosphere", Default = false,
        Callback = function(v)
            AtmoEnabled = v
            Atmosphere.Density = v and 0.3 or 0
        end
    })
    AtmosphereBox:AddSlider("WorldDensity", {
        Text = "Density", Default = 0.3, Min = 0, Max = 1, Rounding = 2,
        Callback = function(v) if AtmoEnabled then Atmosphere.Density = v end end
    })
    AtmosphereBox:AddSlider("WorldOffset", {
        Text = "Offset", Default = 0, Min = -1, Max = 1, Rounding = 2,
        Callback = function(v) Atmosphere.Offset = v end
    })
    AtmosphereBox:AddLabel("Atmosphere Color"):AddColorPicker("WorldAtmoColor", {
        Default = Atmosphere.Color, Title = "Atmosphere Color",
        Callback = function(v) Atmosphere.Color = v end
    })
    AtmosphereBox:AddLabel("Decay"):AddColorPicker("WorldDecay", {
        Default = Atmosphere.Decay, Title = "Decay",
        Callback = function(v) Atmosphere.Decay = v end
    })
    AtmosphereBox:AddSlider("WorldGlare", {
        Text = "Glare", Default = 0, Min = 0, Max = 10, Rounding = 2,
        Callback = function(v) Atmosphere.Glare = v end
    })
    AtmosphereBox:AddSlider("WorldHaze", {
        Text = "Haze", Default = 0, Min = 0, Max = 10, Rounding = 2,
        Callback = function(v) Atmosphere.Haze = v end
    })

    EffectsLeft:AddToggle("WorldBloomEnabled", {
        Text = "Bloom", Default = false,
        Callback = function(v) Bloom.Enabled = v end
    })
    EffectsLeft:AddSlider("WorldBloomIntensity", {
        Text = "Bloom Intensity", Default = 0.4, Min = 0, Max = 5, Rounding = 2,
        Callback = function(v) Bloom.Intensity = v end
    })
    EffectsLeft:AddSlider("WorldBloomSize", {
        Text = "Bloom Size", Default = 24, Min = 0, Max = 56, Rounding = 0,
        Callback = function(v) Bloom.Size = v end
    })
    EffectsLeft:AddSlider("WorldBloomThreshold", {
        Text = "Bloom Threshold", Default = 0.95, Min = 0, Max = 2, Rounding = 2,
        Callback = function(v) Bloom.Threshold = v end
    })

    EffectsLeft:AddDivider()

    EffectsLeft:AddToggle("WorldSunRaysEnabled", {
        Text = "Sun Rays", Default = false,
        Callback = function(v) SunRays.Enabled = v end
    })
    EffectsLeft:AddSlider("WorldSunRaysIntensity", {
        Text = "Sun Rays Intensity", Default = 0.1, Min = 0, Max = 1, Rounding = 2,
        Callback = function(v) SunRays.Intensity = v end
    })
    EffectsLeft:AddSlider("WorldSunRaysSpread", {
        Text = "Sun Rays Spread", Default = 0.1, Min = 0, Max = 1, Rounding = 2,
        Callback = function(v) SunRays.Spread = v end
    })

    EffectsLeft:AddDivider()

    EffectsLeft:AddToggle("WorldDoFEnabled", {
        Text = "Depth of Field", Default = false,
        Callback = function(v)
            DepthOfField.Enabled = v
            if not v then
                DepthOfField.FarIntensity = 0
                DepthOfField.NearIntensity = 0
            end
        end
    })
    EffectsLeft:AddSlider("WorldFarIntensity", {
        Text = "Far Intensity", Default = 0.75, Min = 0, Max = 1, Rounding = 2,
        Callback = function(v) if DepthOfField.Enabled then DepthOfField.FarIntensity = v end end
    })
    EffectsLeft:AddSlider("WorldFocusDistance", {
        Text = "Focus Distance", Default = 50, Min = 0, Max = 200, Rounding = 0,
        Callback = function(v) DepthOfField.FocusDistance = v end
    })
    EffectsLeft:AddSlider("WorldInFocusRadius", {
        Text = "In Focus Radius", Default = 30, Min = 0, Max = 50, Rounding = 0,
        Callback = function(v) DepthOfField.InFocusRadius = v end
    })
    EffectsLeft:AddSlider("WorldNearIntensity", {
        Text = "Near Intensity", Default = 0.75, Min = 0, Max = 1, Rounding = 2,
        Callback = function(v) if DepthOfField.Enabled then DepthOfField.NearIntensity = v end end
    })

    EffectsRight:AddToggle("WorldCCEnabled", {
        Text = "Color Correction", Default = false,
        Callback = function(v) ColorCorrection.Enabled = v end
    })
    EffectsRight:AddSlider("WorldCCBrightness", {
        Text = "Brightness", Default = 0, Min = -1, Max = 1, Rounding = 2,
        Callback = function(v) ColorCorrection.Brightness = v end
    })
    EffectsRight:AddSlider("WorldCCContrast", {
        Text = "Contrast", Default = 0, Min = -1, Max = 1, Rounding = 2,
        Callback = function(v) ColorCorrection.Contrast = v end
    })
    EffectsRight:AddSlider("WorldCCSaturation", {
        Text = "Saturation", Default = 0, Min = -1, Max = 1, Rounding = 2,
        Callback = function(v) ColorCorrection.Saturation = v end
    })
    EffectsRight:AddLabel("Tint Color"):AddColorPicker("WorldCCTint", {
        Default = Color3.new(1, 1, 1), Title = "Tint Color",
        Callback = function(v) ColorCorrection.TintColor = v end
    })

    local CurrentSkybox = "Game's Sky"
    local SkyboxEnabled = false

    SkyboxBox:AddToggle("WorldSkyboxEnabled", {
        Text = "Custom Skybox", Default = false,
        Callback = function(v)
            SkyboxEnabled = v
            if v then ApplySkybox(CurrentSkybox) else ApplySkybox("Game's Sky") end
        end
    })

    local SkyboxNames = {}
    for name in pairs(Skyboxes) do table.insert(SkyboxNames, name) end
    table.sort(SkyboxNames)

    SkyboxBox:AddDropdown("WorldSkyboxPreset", {
        Values = SkyboxNames, Default = 1, Multi = false, Text = "Skybox Preset",
        Callback = function(Value)
            CurrentSkybox = Value
            if SkyboxEnabled then ApplySkybox(Value) end
        end
    })

    LocalBox:AddToggle("LocalForceField", {
        Text = "ForceField Chams", Default = false,
        Callback = function(v)
            LocalVis.ForceField = v
            ApplyLocalVisuals()
        end
    })
    LocalBox:AddSlider("LocalTransparency", {
        Text = "Transparency", Default = 0, Min = 0, Max = 1, Rounding = 2,
        Callback = function(v)
            LocalVis.Transparency = v
            if LocalVis.ForceField then ApplyLocalVisuals() end
        end
    })
    LocalBox:AddLabel("Chams Color"):AddColorPicker("LocalChamsColor", {
        Default = Color3.fromRGB(0, 255, 255), Title = "ForceField Color",
        Callback = function(v)
            LocalVis.Color = v
            if LocalVis.ForceField then ApplyLocalVisuals() end
        end
    })

    RegisterCleanup(function()
        RestoreDefaults()
        ClearLocalVisuals()
    end)
end

local MenuGroup = Tabs["UI Settings"]:AddLeftGroupbox("Menu")

MenuGroup:AddToggle("KeybindMenuOpen", {
    Default = Library.KeybindFrame and Library.KeybindFrame.Visible or false,
    Text = "Open Keybind Menu",
    Callback = function(value)
        if Library.KeybindFrame then
            Library.KeybindFrame.Visible = value
        end
    end
})

MenuGroup:AddToggle("ShowCustomCursor", {
    Text = "Custom Cursor",
    Default = true,
    Callback = function(Value)
        Library.ShowCustomCursor = Value
    end
})

MenuGroup:AddDivider()

MenuGroup:AddLabel("Menu bind"):AddKeyPicker("MenuKeybind", {
    Default = "RightShift",
    NoUI = true,
    Text = "Menu keybind"
})

MenuGroup:AddButton("Unload", function()
    ScriptAlive = false
    for _, fn in CleanupCallbacks do
        pcall(fn)
    end
    for _, d in TrackedDrawings do
        pcall(function() d:Remove() end)
    end
    for _, c in TrackedConnections do
        pcall(function() c:Disconnect() end)
    end
    Library:Unload()
end)

Library.ToggleKeybind = Options.MenuKeybind

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ "MenuKeybind" })

ThemeManager:SetFolder("FloppaHub")
SaveManager:SetFolder("FloppaHub/PrisonLife")

SaveManager:BuildConfigSection(Tabs["UI Settings"])
ThemeManager:ApplyToTab(Tabs["UI Settings"])
SaveManager:LoadAutoloadConfig()

Library:Notify("Floppa Hub has Loaded!", 4)