local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'

local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local isAntiCheatDisabled = false
local notifiedAntiCheat = false

local Window = Library:CreateWindow({
    Title = 'nexsync | hotel',
    Center = true,
    AutoShow = false,
    TabPadding = 8,
    MenuFadeTime = 0.2
})

local Tabs = {
    Main = Window:AddTab('Main'),
    Movement = Window:AddTab('Movement'),
    Visuals = Window:AddTab('Visuals'),
    Automation = Window:AddTab('Automation'),
    ['UI Settings'] = Window:AddTab('UI Settings'),
}

local MainGroup = Tabs.Main:AddLeftGroupbox('Environment Bypass')
local BypassGroup = Tabs.Main:AddRightGroupbox('Damage Protection')
local MoveGroup = Tabs.Movement:AddLeftGroupbox('Active Movement')
local MoveGroupRight = Tabs.Movement:AddRightGroupbox('Physics Tweaks')
local VisualGroup = Tabs.Visuals:AddLeftGroupbox('World Lighting')
local VisualGroupRight = Tabs.Visuals:AddRightGroupbox('Sensory ESP')
local AutoGroup = Tabs.Automation:AddLeftGroupbox('Teleport Hub')

local function getNil(name, class)
    for _, v in next, getnilinstances() do
        if v.ClassName == class and v.Name == name then
            return v
        end
    end
end

local function safeDelete(path)
    if path and path:IsDescendantOf(game) then
        pcall(function() path:Destroy() end)
    end
end

local function toggleDoorState(doorNum, state)
    local door = Workspace:FindFirstChild("Door" .. tostring(doorNum))
    if door and door:IsDescendantOf(game) then
        for _, part in next, door:GetDescendants() do
            if part:IsA("BasePart") then
                if state then
                    if not part:GetAttribute("OrigTransparency") then
                        part:SetAttribute("OrigTransparency", part.Transparency)
                        part:SetAttribute("OrigCanCollide", part.CanCollide)
                    end
                    part.Transparency = 0.7
                    part.CanCollide = false
                else
                    part.Transparency = part:GetAttribute("OrigTransparency") or 0
                    part.CanCollide = part:GetAttribute("OrigCanCollide") or true
                end
            end
        end
    end
end

local doorNums = {201, 202, 203, 301, 302, 303, 401, 402, 403}
local doorPhaseConnection

MainGroup:AddToggle('ClaimDoorsToggle', {
    Text = 'Claim & Phase Doors',
    Default = false,
    Callback = function(Value)
        if doorPhaseConnection then doorPhaseConnection:Disconnect() ; doorPhaseConnection = nil end

        if Value then
            local Event = ReplicatedStorage:FindFirstChild("RemoveDoor")
            if Event and firesignal then
                firesignal(Event.OnClientEvent, "all")
                for _, num in next, doorNums do
                    firesignal(Event.OnClientEvent, tostring(num))
                    task.wait(0.05)
                end
            end

            -- Continuously re-enforce phase so player interactions can't reset it
            doorPhaseConnection = RunService.Heartbeat:Connect(function()
                for _, num in next, doorNums do
                    local door = Workspace:FindFirstChild("Door" .. tostring(num))
                    if door and door:IsDescendantOf(game) then
                        for _, part in next, door:GetDescendants() do
                            if part:IsA("BasePart") and (part.CanCollide or part.Transparency < 0.5) then
                                part.Transparency = 0.7
                                part.CanCollide = false
                            end
                        end
                    end
                end
            end)
        else
            for _, num in next, doorNums do
                toggleDoorState(num, false)
            end
        end
    end
})

local obstacleConnection
local obstacleEnabled = false
local obstacleNames = {
    StairsDamage = true, HallBlock = true, HallBlock2 = true, HallBlock3 = true,
    EnterVent = true, DarknessFog = true, DarknessFog2 = true, DarknessFog3 = true,
    DarknessFog3Top = true, DarknessFog4 = true, GlobalStairBlock = true,
    RatTrap = true, Rat = true, Room245 = true
}

MainGroup:AddToggle('ClearObstaclesToggle', {
    Text = 'Clear Map Obstacles',
    Default = false,
    Callback = function(Value)
        obstacleEnabled = Value
        if obstacleConnection then obstacleConnection:Disconnect() end

        if Value then
            local function nukeObj(obj)
                if not obj or not obj.Parent then return end
                -- Try Parent = nil first (works when :Destroy() is script-guarded)
                pcall(function() obj.Parent = nil end)
                if obj.Parent then
                    pcall(function() obj:Destroy() end)
                end
                -- If still alive, fully neuter it
                if obj and obj:IsDescendantOf(game) then
                    for _, desc in next, obj:GetDescendants() do
                        if desc:IsA("TouchTransmitter") or desc:IsA("Script") or desc:IsA("LocalScript") then
                            pcall(function() desc.Parent = nil end)
                            pcall(function() desc:Destroy() end)
                        end
                    end
                    if obj:IsA("BasePart") then
                        pcall(function()
                            obj.CanTouch = false
                            obj.CanCollide = false
                            obj.Transparency = 1
                            obj.Size = Vector3.new(0.01, 0.01, 0.01)
                        end)
                    elseif obj:IsA("Model") then
                        for _, part in next, obj:GetDescendants() do
                            if part:IsA("BasePart") then
                                pcall(function()
                                    part.CanTouch = false
                                    part.CanCollide = false
                                    part.Transparency = 1
                                end)
                            end
                        end
                    end
                end
            end

            local function checkAndDestroy(obj)
                if obstacleNames[obj.Name] then
                    nukeObj(obj)
                end
            end

            -- Connect to both ChildAdded and DescendantAdded for maximum coverage
            obstacleConnection = Workspace.DescendantAdded:Connect(checkAndDestroy)

            -- Initial deep scan
            for _, v in next, Workspace:GetDescendants() do
                checkAndDestroy(v)
            end

            -- Per-frame poll for DarknessFog3/3Top since they respawn fast
            task.spawn(function()
                while obstacleEnabled do
                    for _, name in next, {"DarknessFog3", "DarknessFog3Top"} do
                        local found = Workspace:FindFirstChild(name, true)
                        if found then nukeObj(found) end
                    end
                    task.wait() -- every frame
                end
            end)
        end
    end
})

local stairDamageThread
local stairDamageEnabled = false
BypassGroup:AddToggle('AntiStairDamage', {
    Text = 'Disable Stair Damage',
    Default = false,
    Callback = function(Value)
        stairDamageEnabled = Value
        if Value then
            task.spawn(function()
                while stairDamageEnabled do
                    if not Workspace:IsDescendantOf(game) then break end
                    local sd = Workspace:FindFirstChild("StairsDamage")
                    if sd then
                        pcall(function() sd:Destroy() end)
                    end
                    task.wait(0.5)
                end
            end)
        end
    end
})

local limboEscapeConnection
local limboEnabled = false
BypassGroup:AddToggle('AntiLimbo', {
    Text = 'Disable Limbo Kill',
    Default = false,
    Callback = function(Value)
        limboEnabled = Value
        if limboEscapeConnection then limboEscapeConnection:Disconnect() ; limboEscapeConnection = nil end
        
        local clonesFolder = Workspace:FindFirstChild("LimboKill_Clones")
        if clonesFolder then pcall(function() clonesFolder:Destroy() end) end

        local function setCharacterCanTouch(state)
            local char = LocalPlayer.Character
            if char then
                for _, part in next, char:GetDescendants() do
                    if part:IsA("BasePart") then
                        pcall(function() part.CanTouch = state end)
                    end
                end
            end
        end
        
        if not Value then
            setCharacterCanTouch(true)
            return
        end

        local limboKillData = {}
        
        clonesFolder = Instance.new("Folder")
        clonesFolder.Name = "LimboKill_Clones"
        clonesFolder.Parent = Workspace

        local function tryDisable(child)
            if child.Name ~= "LimboKill" or not child:IsDescendantOf(game) then return end
            
            local cf = child:IsA("BasePart") and child.CFrame or child:GetPivot()
            local size = child:IsA("BasePart") and child.Size or Vector3.new(10, 10, 10)
            table.insert(limboKillData, {CFrame = cf, Size = size})

            local success, clone = pcall(function() return child:Clone() end)
            if success and clone then
                clone.Name = "LimboKill_VisualClone"
                if clone:IsA("BasePart") then
                    clone.Transparency = 0.5
                    clone.CanCollide = false
                    clone.CanTouch = false
                    clone.Anchored = true
                end
                for _, sub in next, clone:GetDescendants() do
                    if sub:IsA("TouchTransmitter") or sub:IsA("Script") or sub:IsA("LocalScript") then
                        pcall(function() sub:Destroy() end)
                    end
                    if sub:IsA("BasePart") then
                        sub.Transparency = 0.5
                        sub.CanCollide = false
                        sub.CanTouch = false
                        sub.Anchored = true
                    end
                end
                clone.Parent = clonesFolder
            end

            pcall(function() child:Destroy() end)
        end

        local function isInsideLimboKill(pos)
            for _, data in next, limboKillData do
                local relativePos = data.CFrame:PointToObjectSpace(pos)
                local halfSize = data.Size / 2
                if math.abs(relativePos.X) < (halfSize.X + 6) and
                   math.abs(relativePos.Y) < (halfSize.Y + 6) and
                   math.abs(relativePos.Z) < (halfSize.Z + 6) then
                    return true
                end
            end
            return false
        end

        limboEscapeConnection = RunService.Heartbeat:Connect(function()
            local char = LocalPlayer.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if not root then return end

            local nearLimbo = isInsideLimboKill(root.Position)
            setCharacterCanTouch(not nearLimbo)
        end)

        for _, child in next, Workspace:GetDescendants() do
            if child.Name == "LimboKill" then tryDisable(child) end
        end

        Workspace.DescendantAdded:Connect(function(child)
            if limboEnabled and child.Name == "LimboKill" then
                tryDisable(child)
            end
        end)
    end
})

local floorConnection
BypassGroup:AddToggle('AntiEvilFloor', {
    Text = 'Replace Evil Floor',
    Default = false,
    Callback = function(Value)
        if floorConnection then floorConnection:Disconnect() end
        if Value then
            local function checkFloor(floor)
                if floor.Name == "EvilFloor" and floor:IsDescendantOf(game) then
                    local replacement = Instance.new("Part")
                    replacement.Name = "EvilFloor_Replaced"
                    replacement.Size = floor.Size
                    replacement.CFrame = floor.CFrame
                    replacement.Anchored = true
                    replacement.Material = Enum.Material.SmoothPlastic
                    replacement.Parent = Workspace
                    pcall(function() floor:Destroy() end)
                end
            end
            floorConnection = Workspace.DescendantAdded:Connect(checkFloor)
            for _, floor in next, Workspace:GetDescendants() do
                checkFloor(floor)
            end
        end
    end
})

local cardBypassEnabled = false
local dummyEvent = Instance.new("BindableEvent")
local removeCardEvent = ReplicatedStorage:FindFirstChild("RemoveCard")
local removeCardOnClientEvent = removeCardEvent and removeCardEvent.OnClientEvent

local oldIndex
pcall(function()
    oldIndex = hookmetamethod(game, "__index", function(self, key)
        if cardBypassEnabled and not checkcaller() then
            if self == removeCardEvent and key == "OnClientEvent" then
                return dummyEvent.Event
            end
        end
        return oldIndex(self, key)
    end)
end)

local oldFiresignal
if firesignal then
    pcall(function()
        oldFiresignal = hookfunction(firesignal, function(event, ...)
            if cardBypassEnabled and event == removeCardOnClientEvent then
                return
            end
            return oldFiresignal(event, ...)
        end)
    end)
end

BypassGroup:AddToggle('AntiCardRemove', {
    Text = 'Prevent Card Removal',
    Default = false,
    Callback = function(Value)
        cardBypassEnabled = Value
    end
})

local ratConnection
BypassGroup:AddToggle('AntiRatDamage', {
    Text = 'Disable Rat Damage',
    Default = false,
    Callback = function(Value)
        if ratConnection then ratConnection:Disconnect() end
        if Value then
            local function cleanRat(v)
                if (v.Name == "Rat" or v.Name == "RatTrap") and v:IsDescendantOf(game) then
                    local ti = v:FindFirstChild("TouchInterest")
                    if ti then pcall(function() ti:Destroy() end) end
                end
            end
            ratConnection = Workspace.DescendantAdded:Connect(cleanRat)
            for _, v in next, Workspace:GetDescendants() do
                cleanRat(v)
            end
        end
    end
})

local bossShootConnection
local bossEnabled = false
local function doEvasionSpaz()
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root or not root:IsDescendantOf(game) then return end
    local orig = root.CFrame
    local oldCamType = Camera.CameraType
    Camera.CameraType = Enum.CameraType.Scriptable
    for i = 1, 20 do
        if not root:IsDescendantOf(game) then break end
        root.CFrame = orig + Vector3.new(0, 120, 0)
        task.wait(0.03)
        root.CFrame = CFrame.new(9.9e5, 9.9e5, 9.9e5)
        task.wait(0.03)
    end
    if root:IsDescendantOf(game) then root.CFrame = orig end
    Camera.CameraType = oldCamType
end

local function isBossAimingAtPlayer()
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return false end
    local boss = Workspace:FindFirstChild("LimboBoss", true)
    local bossMain = boss and boss:FindFirstChild("Main", true)
    local bossRoot = bossMain and (bossMain:FindFirstChild("HumanoidRootPart") or bossMain:FindFirstChild("Torso") or bossMain:FindFirstChild("UpperTorso"))
    if not bossRoot then
        -- fallback: use the Model pivot
        if boss then
            local pivot = boss:IsA("Model") and boss:GetPivot() or (bossMain and bossMain:IsA("Model") and bossMain:GetPivot())
            if pivot then
                local toPlayer = (root.Position - pivot.Position).Unit
                local lookVec = pivot.LookVector
                return lookVec:Dot(toPlayer) > 0.6
            end
        end
        return false
    end
    local toPlayer = (root.Position - bossRoot.Position).Unit
    return bossRoot.CFrame.LookVector:Dot(toPlayer) > 0.6
end

local bossConnection
BypassGroup:AddToggle('AntiBossDamage', {
    Text = 'Disable Boss Damage',
    Default = false,
    Callback = function(Value)
        bossEnabled = Value
        if bossConnection then bossConnection:Disconnect() ; bossConnection = nil end
        if bossShootConnection then bossShootConnection:Disconnect() ; bossShootConnection = nil end

        if Value then
            local bossDamageNames = {
                PoisonCylinder = true,
                Laser = true,
                BossHurt = true,
                PoisonBall = true
            }
            bossConnection = Workspace.DescendantAdded:Connect(function(child)
                if bossDamageNames[child.Name] then
                    safeDelete(child)
                end
            end)

            for _, child in next, Workspace:GetDescendants() do
                if bossDamageNames[child.Name] then
                    safeDelete(child)
                end
            end

            task.spawn(function()
                while bossEnabled do
                    local bomb = getNil("ExploderBomb", "Part")
                    if bomb then safeDelete(bomb) end
                    task.wait(1)
                end
            end)

            local function hookShootAnim()
                local boss = Workspace:FindFirstChild("LimboBoss", true)
                local bossMain = boss and boss:FindFirstChild("Main", true)
                if not bossMain then return false end
                local hum = bossMain:FindFirstChildOfClass("Humanoid")
                    or bossMain:FindFirstChild("Humanoid", true)
                local animator = hum and (hum:FindFirstChildOfClass("Animator") or hum:FindFirstChild("Animator", true))
                if not animator then return false end

                bossShootConnection = animator.AnimationPlayed:Connect(function(track)
                    if track.Name == "Shoot" or track.Animation and track.Animation.Name == "Shoot" then
                        if isBossAimingAtPlayer() then
                            task.spawn(doEvasionSpaz)
                        end
                    end
                end)
                return true
            end

            if not hookShootAnim() then
                task.spawn(function()
                    while bossEnabled do
                        if hookShootAnim() then break end
                        task.wait(1)
                    end
                end)
            end
        end
    end
})

BypassGroup:AddToggle('BypassAntiCheat', {
    Text = 'Disable Anti-Cheat (Glitch)',
    Default = false,
    Callback = function(Value)
        isAntiCheatDisabled = Value
        notifiedAntiCheat = false
        if Value then
            local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if root then
                local orig = root.CFrame
                local oldCamType = Camera.CameraType
                Camera.CameraType = Enum.CameraType.Scriptable

                -- Pass 1: rapid Y-spike + far teleport (confuses position tracker)
                -- 9.9e4 = ~100,000 studs — far enough to break tracking, safe enough
                -- not to overflow Roblox's float range and trigger an OOB kill.
                for i = 1, 35 do
                    if not root:IsDescendantOf(game) then break end
                    root.CFrame = orig + Vector3.new(0, 150, 0)
                    task.wait(0.03)
                    root.CFrame = CFrame.new(9.9e4, 9.9e4, 9.9e4)
                    task.wait(0.03)
                end

                -- Pass 2: randomised XZ jitter + random rotation snaps
                -- (breaks rotation/velocity tracking on top of position)
                for i = 1, 20 do
                    if not root:IsDescendantOf(game) then break end
                    local jx = math.random(-500, 500)
                    local jz = math.random(-500, 500)
                    root.CFrame = CFrame.new(jx, 9.9e4, jz)
                        * CFrame.Angles(math.random() * math.pi * 2, math.random() * math.pi * 2, 0)
                    task.wait(0.02)
                    root.CFrame = orig + Vector3.new(0, 200 + i * 10, 0)
                    task.wait(0.02)
                end

                -- Restore to origin cleanly
                if root:IsDescendantOf(game) then
                    root.CFrame = orig
                    root.Velocity = Vector3.zero
                    root.Anchored = true
                    task.wait(0.1) -- let server acknowledge the valid position
                    root.Anchored = false
                end

                -- Reset humanoid state so character isn't stuck in Ragdoll/GettingUp
                -- (which would cause an instant death on the next teleport)
                local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if hum and hum:IsDescendantOf(game) then
                    pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
                end

                Camera.CameraType = oldCamType
            end
        end
    end
})

local glideConnection
local glideSpeed = 0
MoveGroup:AddToggle('GlideSpeed', {
    Text = 'Adaptive Ground Glide (0.3s)',
    Default = false,
    Callback = function(Value)
        if Value and not isAntiCheatDisabled then
            if not notifiedAntiCheat then
                notifiedAntiCheat = true
                Library:Notify("Enable 'Disable Anti-Cheat (Glitch)' under Damage Protection first!", 4)
            end
            Toggles.GlideSpeed:SetValue(false)
            return
        end
        if glideConnection then glideConnection:Disconnect() end
        glideSpeed = 0
        if Value then
            local character = LocalPlayer.Character
            local root = character and character:FindFirstChild("HumanoidRootPart")
            local hum = character and character:FindFirstChildOfClass("Humanoid")
            
            if root and hum then
                local oldWalkspeed = hum.WalkSpeed
                local oldAnchored = root.Anchored
                hum.WalkSpeed = 0
                root.Anchored = true
                
                local steps = 15
                for i = 1, steps do
                    if not root:IsDescendantOf(game) then break end
                    root.CFrame = root.CFrame + Vector3.new(0, 0.3 / steps, 0)
                    task.wait(0.02)
                end
                
                if root:IsDescendantOf(game) then root.Anchored = oldAnchored end
                if hum:IsDescendantOf(game) then hum.WalkSpeed = oldWalkspeed end
                
                local rayParams = RaycastParams.new()
                rayParams.FilterType = Enum.RaycastFilterType.Exclude
                
                glideConnection = RunService.Heartbeat:Connect(function(dt)
                    if not root:IsDescendantOf(game) or not hum:IsDescendantOf(game) then return end
                    
                    local currentExclude = {character}
                    for _, p in next, Players:GetPlayers() do
                        if p.Character then table.insert(currentExclude, p.Character) end
                    end
                    rayParams.FilterDescendantsInstances = currentExclude
                    
                    local rayResult = Workspace:Raycast(root.Position, Vector3.new(0, -15, 0), rayParams)
                    if rayResult then
                        local targetY = rayResult.Position.Y + 3.3
                        root.CFrame = CFrame.new(root.Position.X, targetY, root.Position.Z) * root.CFrame.Rotation
                    end
                    
                    if hum.MoveDirection.Magnitude > 0 then
                        glideSpeed = math.min(glideSpeed + (12 * dt), 55)
                        root.Velocity = hum.MoveDirection * glideSpeed + Vector3.new(0, root.Velocity.Y, 0)
                    else
                        glideSpeed = 0
                        root.Velocity = Vector3.new(0, root.Velocity.Y, 0)
                    end
                end)
            end
        end
    end
})

MoveGroup:AddSlider('WalkSpeedSlider', {
    Text = 'Custom Walk Speed',
    Default = 16,
    Min = 16,
    Max = 150,
    Rounding = 0,
    Compact = false,
    Callback = function(Value)
        if Value > 16 and not isAntiCheatDisabled then
            if not notifiedAntiCheat then
                notifiedAntiCheat = true
                Library:Notify("Enable 'Disable Anti-Cheat (Glitch)' under Damage Protection first!", 4)
            end
            Options.WalkSpeedSlider:SetValue(16)
            return
        end
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.WalkSpeed = Value
        end
    end
})

MoveGroup:AddSlider('JumpPowerSlider', {
    Text = 'Custom Jump Power',
    Default = 50,
    Min = 50,
    Max = 250,
    Rounding = 0,
    Compact = false,
    Callback = function(Value)
        if Value > 50 and not isAntiCheatDisabled then
            if not notifiedAntiCheat then
                notifiedAntiCheat = true
                Library:Notify("Enable 'Disable Anti-Cheat (Glitch)' under Damage Protection first!", 4)
            end
            Options.JumpPowerSlider:SetValue(50)
            return
        end
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.UseJumpPower = true
            hum.JumpPower = Value
        end
    end
})

local noclipConnection
MoveGroupRight:AddToggle('Noclip', {
    Text = 'Noclip (No Detection)',
    Default = false,
    Callback = function(Value)
        if noclipConnection then noclipConnection:Disconnect() end
        if Value then
            noclipConnection = RunService.Stepped:Connect(function()
                if LocalPlayer.Character and LocalPlayer.Character:IsDescendantOf(game) then
                    for _, v in next, LocalPlayer.Character:GetDescendants() do
                        if v:IsA("BasePart") and v.CanCollide then
                            v.CanCollide = false
                        end
                    end
                end
            end)
        end
    end
})

local flightConnection
local flySpeedVal = 50
MoveGroup:AddToggle('Flight', {
    Text = 'Flight Bypass',
    Default = false,
    Callback = function(Value)
        if Value and not isAntiCheatDisabled then
            if not notifiedAntiCheat then
                notifiedAntiCheat = true
                Library:Notify("Enable 'Disable Anti-Cheat (Glitch)' under Damage Protection first!", 4)
            end
            Toggles.Flight:SetValue(false)
            return
        end
        if flightConnection then flightConnection:Disconnect() end
        if Value then
            local character = LocalPlayer.Character
            local root = character and character:FindFirstChild("HumanoidRootPart")
            local hum = character and character:FindFirstChildOfClass("Humanoid")
            
            if root and hum then
                local oldWalkspeed = hum.WalkSpeed
                local oldAnchored = root.Anchored
                hum.WalkSpeed = 0
                root.Anchored = true
                
                local startPos = root.Position
                local steps = 30
                for i = 1, steps do
                    if not root:IsDescendantOf(game) then break end
                    root.CFrame = root.CFrame + Vector3.new(0, 2 / steps, 0)
                    task.wait(0.02)
                end
                
                task.wait(0.1)
                if root:IsDescendantOf(game) then
                    root.CFrame = CFrame.new(startPos) * root.CFrame.Rotation
                end
                task.wait(0.1)
                
                if root:IsDescendantOf(game) then root.Anchored = oldAnchored end
                if hum:IsDescendantOf(game) then
                    hum.WalkSpeed = oldWalkspeed
                    hum.PlatformStand = true
                end
                
                local function getMoveVector()
                    local success, playerModule = pcall(require, LocalPlayer.PlayerScripts:FindFirstChild("PlayerModule"))
                    if success and playerModule then
                        local controls = playerModule:GetControls()
                        if controls and controls.GetMoveVector then
                            return controls:GetMoveVector()
                        end
                    end
                    
                    local move = Vector3.new(0, 0, 0)
                    local UIS = game:GetService("UserInputService")
                    if UIS:IsKeyDown(Enum.KeyCode.W) then move = move + Vector3.new(0, 0, -1) end
                    if UIS:IsKeyDown(Enum.KeyCode.S) then move = move + Vector3.new(0, 0, 1) end
                    if UIS:IsKeyDown(Enum.KeyCode.A) then move = move + Vector3.new(-1, 0, 0) end
                    if UIS:IsKeyDown(Enum.KeyCode.D) then move = move + Vector3.new(1, 0, 0) end
                    return move
                end
                
                flightConnection = RunService.Heartbeat:Connect(function()
                    if not root:IsDescendantOf(game) then return end
                    local moveVec = getMoveVector()
                    local camCF = Camera.CFrame
                    local flyDirection = Vector3.new(0, 0, 0)
                    
                    if moveVec.Magnitude > 0 then
                        flyDirection = (camCF.RightVector * moveVec.X) + (camCF.LookVector * -moveVec.Z)
                    end
                    
                    local UIS = game:GetService("UserInputService")
                    if UIS:IsKeyDown(Enum.KeyCode.Space) then
                        flyDirection = flyDirection + Vector3.new(0, 1, 0)
                    end
                    if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then
                        flyDirection = flyDirection - Vector3.new(0, 1, 0)
                    end
                    
                    if flyDirection.Magnitude > 0 then
                        root.Velocity = flyDirection.Unit * flySpeedVal
                    else
                        root.Velocity = Vector3.new(0, 0, 0)
                    end
                    root.CFrame = CFrame.lookAt(root.Position, root.Position + camCF.LookVector)
                end)
            end
        else
            local character = LocalPlayer.Character
            local hum = character and character:FindFirstChildOfClass("Humanoid")
            if hum and hum:IsDescendantOf(game) then hum.PlatformStand = false end
        end
    end
})

MoveGroup:AddSlider('FlySpeedSlider', {
    Text = 'Custom Flight Speed',
    Default = 50,
    Min = 10,
    Max = 200,
    Rounding = 0,
    Compact = false,
    Callback = function(Value)
        flySpeedVal = Value
    end
})

local clickTPConnection
MoveGroupRight:AddToggle('ClickTPToggle', {
    Text = 'Click TP (Ctrl + Click)',
    Default = false,
    Callback = function(Value)
        if clickTPConnection then clickTPConnection:Disconnect() end
        if Value then
            local UserInputService = game:GetService("UserInputService")
            clickTPConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
                if not gameProcessed and input.UserInputType == Enum.UserInputType.MouseButton1 and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                    local mouse = LocalPlayer:GetMouse()
                    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if root and mouse.Hit then
                        root.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0, 3, 0)) * root.CFrame.Rotation
                    end
                end
            end)
        end
    end
})

local infJumpConnection
MoveGroupRight:AddToggle('InfJump', {
    Text = 'Infinite Jump',
    Default = false,
    Callback = function(Value)
        if infJumpConnection then infJumpConnection:Disconnect() end
        if Value then
            infJumpConnection = game:GetService("UserInputService").JumpRequest:Connect(function()
                local character = LocalPlayer.Character
                local hum = character and character:FindFirstChildOfClass("Humanoid")
                if hum and hum:IsDescendantOf(game) then
                    hum:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
        end
    end
})

local fullBrightConnection
VisualGroup:AddToggle('FullBright', {
    Text = 'Fullbright',
    Default = false,
    Callback = function(Value)
        if fullBrightConnection then fullBrightConnection:Disconnect() end
        
        local function applySettings()
            pcall(function()
                Lighting.Brightness = 2
                Lighting.ClockTime = 14
                Lighting.FogEnd = 100000
                Lighting.GlobalShadows = false
                Lighting.Ambient = Color3.fromRGB(255, 255, 255)
            end)
        end
        
        if Value then
            fullBrightConnection = Lighting.Changed:Connect(applySettings)
            applySettings()
        else
            pcall(function()
                Lighting.Brightness = 1
                Lighting.ClockTime = 12
                Lighting.GlobalShadows = true
            end)
        end
    end
})

local activeESP = {}
local espEnabled = false
local renderConnection

local function removeESP(player)
    local esp = activeESP[player]
    if esp then
        for _, obj in next, esp do
            pcall(function() obj:Remove() end)
        end
        activeESP[player] = nil
    end
end

local function createESP(player)
    if activeESP[player] then return activeESP[player] end
    
    local objects = {
        TL1 = Drawing.new("Line"), TL2 = Drawing.new("Line"),
        TR1 = Drawing.new("Line"), TR2 = Drawing.new("Line"),
        BL1 = Drawing.new("Line"), BL2 = Drawing.new("Line"),
        BR1 = Drawing.new("Line"), BR2 = Drawing.new("Line"),
        HealthOutline = Drawing.new("Line"),
        HealthLine = Drawing.new("Line"),
        Name = Drawing.new("Text")
    }
    
    for _, v in next, objects do
        v.Visible = false
        if v.ClassName == "Line" then
            v.Thickness = 1.5
            v.Color = Color3.fromRGB(255, 255, 255)
        elseif v.ClassName == "Text" then
            v.Size = 13
            v.Center = true
            v.Outline = true
            v.Color = Color3.fromRGB(255, 255, 255)
        end
    end
    
    objects.HealthOutline.Color = Color3.fromRGB(0, 0, 0)
    objects.HealthOutline.Thickness = 3
    
    activeESP[player] = objects
    return objects
end

VisualGroupRight:AddToggle('PlayerESP2D', {
    Text = '2D Corner ESP',
    Default = false,
    Callback = function(Value)
        espEnabled = Value
        if renderConnection then renderConnection:Disconnect() end
        
        if not Value then
            for plr in next, activeESP do removeESP(plr) end
        else
            renderConnection = RunService.RenderStepped:Connect(function()
                for _, player in next, Players:GetPlayers() do
                    if player == LocalPlayer then continue end
                    
                    local char = player.Character
                    local root = char and char:FindFirstChild("HumanoidRootPart")
                    local hum = char and char:FindFirstChildOfClass("Humanoid")
                    
                    if root and hum and hum.Health > 0 and char:IsDescendantOf(game) then
                        local pos, onScreen = Camera:WorldToViewportPoint(root.Position)
                        if onScreen then
                            local esp = createESP(player)
                            
                            local topPos = Camera:WorldToViewportPoint(root.Position + Vector3.new(0, 3, 0))
                            local bottomPos = Camera:WorldToViewportPoint(root.Position - Vector3.new(0, 3.5, 0))
                            
                            local sizeY = math.abs(topPos.Y - bottomPos.Y)
                            local sizeX = sizeY * 0.6
                            local x = pos.X - (sizeX / 2)
                            local y = pos.Y - (sizeY / 2)
                            
                            local cornerLength = sizeX * 0.25
                            
                            local corners = {
                                {esp.TL1, Vector2.new(x, y), Vector2.new(x + cornerLength, y)},
                                {esp.TL2, Vector2.new(x, y), Vector2.new(x, y + cornerLength)},
                                {esp.TR1, Vector2.new(x + sizeX, y), Vector2.new(x + sizeX - cornerLength, y)},
                                {esp.TR2, Vector2.new(x + sizeX, y), Vector2.new(x + sizeX, y + cornerLength)},
                                {esp.BL1, Vector2.new(x, y + sizeY), Vector2.new(x + cornerLength, y + sizeY)},
                                {esp.BL2, Vector2.new(x, y + sizeY), Vector2.new(x, y + sizeY - cornerLength)},
                                {esp.BR1, Vector2.new(x + sizeX, y + sizeY), Vector2.new(x + sizeX - cornerLength, y + sizeY)},
                                {esp.BR2, Vector2.new(x + sizeX, y + sizeY), Vector2.new(x + sizeX, y + sizeY - cornerLength)}
                            }
                            
                            for _, c in next, corners do
                                c[1].From = c[2]
                                c[1].To = c[3]
                                c[1].Visible = true
                            end
                            
                            local healthPct = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
                            local barX = x - 7
                            
                            esp.HealthOutline.From = Vector2.new(barX, y)
                            esp.HealthOutline.To = Vector2.new(barX, y + sizeY)
                            esp.HealthOutline.Visible = true
                            
                            esp.HealthLine.From = Vector2.new(barX, y + sizeY)
                            esp.HealthLine.To = Vector2.new(barX, y + sizeY - (sizeY * healthPct))
                            esp.HealthLine.Color = Color3.fromRGB(255 * (1 - healthPct), 255 * healthPct, 0)
                            esp.HealthLine.Visible = true
                            
                            esp.Name.Position = Vector2.new(x + (sizeX / 2), y - 16)
                            esp.Name.Text = player.DisplayName
                            esp.Name.Visible = true
                        else
                            removeESP(player)
                        end
                    else
                        removeESP(player)
                    end
                end
            end)
        end
    end
})

local objectEspList = {}
local itemEspConnection

local function getHighlightTarget(obj)
    local p = obj.Parent
    if not p then return nil end
    if p:IsA("Model") then
        return p
    end
    if p:IsA("BasePart") then
        local gp = p.Parent
        if gp and gp:IsA("Model") and gp ~= Workspace then
            return gp
        end
        return p
    end
    return nil
end

VisualGroupRight:AddToggle('ObjectESP', {
    Text = 'Interactable ESP(why)',
    Default = false,
    Callback = function(Value)
        if itemEspConnection then itemEspConnection:Disconnect() end
        for _, highlight in next, objectEspList do pcall(function() highlight:Destroy() end) end
        table.clear(objectEspList)
        
        if Value then
            local function scanItems(obj)
                local target
                if obj:IsA("ProximityPrompt") or obj:IsA("ClickDetector") then
                    target = getHighlightTarget(obj)
                elseif obj:IsA("TouchTransmitter") then
                    local p = obj.Parent
                    if p and p:IsA("BasePart") then
                        target = (p.Parent and p.Parent:IsA("Model") and p.Parent ~= Workspace) and p.Parent or p
                    end
                elseif obj:IsA("Tool") and obj:IsDescendantOf(Workspace) then
                    target = obj
                end
                
                if target and not target:FindFirstChildOfClass("Highlight") then
                    local h = Instance.new("Highlight")
                    h.FillColor = Color3.fromRGB(255, 170, 0)
                    h.OutlineColor = Color3.fromRGB(255, 255, 255)
                    h.FillTransparency = 0.5
                    h.Parent = target
                    table.insert(objectEspList, h)
                end
            end
            itemEspConnection = Workspace.DescendantAdded:Connect(scanItems)
            for _, v in next, Workspace:GetDescendants() do scanItems(v) end
        end
    end
})

Players.PlayerRemoving:Connect(removeESP)

local function findRoomSP(roomNum)
    local possibleNames = {
        tostring(roomNum) .. "SP",
        "Room" .. tostring(roomNum) .. "SP",
        "Room " .. tostring(roomNum) .. "SP",
        tostring(roomNum) .. " SP",
        "Room" .. tostring(roomNum) .. " SP"
    }
    for _, name in next, possibleNames do
        local found = Workspace:FindFirstChild(name)
        if found then
            return found
        end
    end
    return nil
end

local function tpToTarget(target)
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    if typeof(target) == "Vector3" then
        root.CFrame = CFrame.new(target)
    elseif target:IsA("BasePart") then
        root.CFrame = target.CFrame + Vector3.new(0, 3, 0)
    elseif target:IsA("Model") then
        root.CFrame = target:GetPivot() + Vector3.new(0, 3, 0)
    end
end

-- Rooms dropdown
local roomTPData = {
    {"Room 201", "201SP"},
    {"Room 202", "202SP"},
    {"Room 203", "203SP"},
    {"Room 245", "245SP"},
    {"Room 301", "301SP"},
    {"Room 302", "302SP"},
    {"Room 303", "303SP"},
    {"Room 401", "401SP"},
    {"Room 402", "402SP"},
    {"Room 403", "403SP"},
}
local roomTPNames = {}
for _, d in next, roomTPData do table.insert(roomTPNames, d[1]) end

AutoGroup:AddDropdown('RoomsTeleport', {
    Values = roomTPNames,
    Default = roomTPNames[1],
    Multi = false,
    Text = 'Room Teleports',
    Callback = function(Value)
        for _, data in next, roomTPData do
            if data[1] == Value then
                local roomNum = data[2]:match("(%d+)")
                local target = findRoomSP(roomNum or data[2])
                if target then tpToTarget(target) else Library:Notify("Room SP not found!", 3) end
                break
            end
        end
    end
})

-- Elevators dropdown
local elevatorTPData = {
    {"Elevator Floor 1", Vector3.new(11, 3, 6)},
    {"Elevator Floor 2", Vector3.new(11, 28, 6)},
    {"Elevator Floor 3", Vector3.new(10, 53, 6)},
    {"Elevator Floor 4", Vector3.new(9, 78, 6)},
    {"Main Elevator", "Elevator_System_Elevator_Floor"},
    {"Obby Elevator", "Elevator2"},
    {"Roof Elevator", "Elevator3"},
}
local elevatorTPNames = {}
for _, d in next, elevatorTPData do table.insert(elevatorTPNames, d[1]) end

AutoGroup:AddDropdown('ElevatorsTeleport', {
    Values = elevatorTPNames,
    Default = elevatorTPNames[1],
    Multi = false,
    Text = 'Elevator Teleports',
    Callback = function(Value)
        for _, data in next, elevatorTPData do
            if data[1] == Value then
                if typeof(data[2]) == "Vector3" then
                    tpToTarget(data[2])
                else
                    local target
                    if data[2] == "Elevator_System_Elevator_Floor" then
                        local sys = Workspace:FindFirstChild("Elevator_System", true)
                        local elev = sys and sys:FindFirstChild("Elevator", true)
                        target = elev and elev:FindFirstChild("Floor", true)
                    elseif data[2] == "Elevator2" then
                        local elev2 = Workspace:FindFirstChild("Elevator2", true)
                        target = elev2 and (elev2:FindFirstChild("Floor", true) or elev2) or elev2
                    elseif data[2] == "Elevator3" then
                        local elev3 = Workspace:FindFirstChild("Elevator3", true)
                        target = elev3 and (elev3:FindFirstChild("Floor", true) or elev3) or elev3
                    end
                    if target then tpToTarget(target) else Library:Notify("Elevator not found!", 3) end
                end
                break
            end
        end
    end
})

-- Lobby dropdown
local lobbyTPData = {
    {"Main Lobby", Vector3.new(-12, 4, -20)},
    {"Front Desk", Vector3.new(0, 4, 0)},
}
local lobbyTPNames = {}
for _, d in next, lobbyTPData do table.insert(lobbyTPNames, d[1]) end

AutoGroup:AddDropdown('LobbyTeleport', {
    Values = lobbyTPNames,
    Default = lobbyTPNames[1],
    Multi = false,
    Text = 'Lobby Teleports',
    Callback = function(Value)
        for _, data in next, lobbyTPData do
            if data[1] == Value then
                tpToTarget(data[2])
                break
            end
        end
    end
})

AutoGroup:AddButton({
    Text = 'Claim Random Keycard',
    Func = function()
        local cardsOnDesk = Workspace:FindFirstChild("CardsOnDesk", true)
        if cardsOnDesk then
            local claimedCount = 0
            for _, grabCard in next, cardsOnDesk:GetChildren() do
                if grabCard.Name == "GrabCard" then
                    local clickPart = grabCard:FindFirstChild("Click")
                    local cd = clickPart and clickPart:FindFirstChild("ClickDetector")
                    if cd then
                        fireclickdetector(cd)
                        claimedCount = claimedCount + 1
                    end
                end
            end
            Library:Notify("Claimed " .. tostring(claimedCount) .. " keycard(s)!", 3)
        else
            Library:Notify("CardsOnDesk not found!", 3)
        end
    end
})

AutoGroup:AddButton({
    Text = 'Call Phone',
    Func = function()
        local phoneClick = Workspace:FindFirstChild("PhoneClick", true)
        local cd = phoneClick and phoneClick:FindFirstChildOfClass("ClickDetector")
        if cd then
            fireclickdetector(cd)
            Library:Notify("Called Phone!", 3)
        else
            Library:Notify("Phone ClickDetector not found or inactive!", 3)
        end
    end
})

local function getClosestRoomNumber()
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return "201" end
    local closestRoom = "201"
    local closestDist = math.huge
    local roomNums = {"201", "202", "203", "301", "302", "303", "401", "402", "403"}
    for _, room in next, roomNums do
        local target = findRoomSP(room)
        if target then
            local pos = target:IsA("BasePart") and target.Position or target:GetPivot().Position
            local dist = (pos - root.Position).Magnitude
            if dist < closestDist then
                closestDist = dist
                closestRoom = room
            end
        end
    end
    return closestRoom
end

local function getLampClickDetector(roomNum)
    local names = {roomNum, "Room" .. roomNum, "Room " .. roomNum}
    for _, name in next, names do
        local folder = Workspace:FindFirstChild(name)
        if folder then
            local lamp = folder:FindFirstChild("LampDesk", true)
            local click = lamp and lamp:FindFirstChild("Click", true)
            local cd = click and click:FindFirstChildOfClass("ClickDetector")
            if cd then return cd end
        end
    end
    return nil
end

-- ── Fun Features ──────────────────────────────────────────────
local FunGroup = Tabs.Automation:AddLeftGroupbox('Fun Features')

-- Player list helper (excludes self)
local function getPlayerNames()
    local names = {}
    for _, p in next, Players:GetPlayers() do
        if p ~= LocalPlayer then
            table.insert(names, p.Name)
        end
    end
    if #names == 0 then table.insert(names, "(nobody)") end
    return names
end

-- CUDDLE FOLLOW ─────────────────────────────────────────────────
-- Selects a player; when they're on a room bed Model, lerp behind them each frame.
-- CFrame.new(0, 0, 1.2) is in LOCAL space: behind the target, same height & rotation.
local cuddleEnabled = false
local cuddleConnection
local allRoomNums = {"201", "202", "203", "245", "301", "302", "303", "401", "402", "403"}

local function getBedModels()
    local beds = {}
    for _, room in next, allRoomNums do
        local folder = Workspace:FindFirstChild(room) or Workspace:FindFirstChild("Room" .. room)
        if folder then
            for _, child in next, folder:GetChildren() do
                if child:IsA("Model") then
                    table.insert(beds, child)
                end
            end
        end
    end
    return beds
end

local function isOnBed(character)
    if not character then return false end
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return false end
    local beds = getBedModels()
    for _, bed in next, beds do
        local ok, pivot = pcall(function() return bed:GetPivot() end)
        if ok and (pivot.Position - root.Position).Magnitude < 8 then
            return true, bed
        end
    end
    return false
end

FunGroup:AddDropdown('CuddleTarget', {
    Values = getPlayerNames(),
    Default = getPlayerNames()[1],
    Multi = false,
    Text = 'Cuddle Target',
})

-- Refresh dropdown when players join/leave
Players.PlayerAdded:Connect(function()
    pcall(function() Options.CuddleTarget:SetValues(getPlayerNames()) end)
end)
Players.PlayerRemoving:Connect(function()
    pcall(function() Options.CuddleTarget:SetValues(getPlayerNames()) end)
end)

FunGroup:AddToggle('CuddleFollowToggle', {
    Text = 'Cuddle Follow',
    Default = false,
    Callback = function(Value)
        cuddleEnabled = Value
        if cuddleConnection then cuddleConnection:Disconnect() ; cuddleConnection = nil end
        if Value then
            cuddleConnection = RunService.Heartbeat:Connect(function()
                local targetName = Options.CuddleTarget.Value
                local target = Players:FindFirstChild(targetName)
                local targetChar = target and target.Character
                local targetRoot = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
                local myChar = LocalPlayer.Character
                local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
                if not (targetRoot and myRoot) then return end

                local onBed = isOnBed(targetChar)
                if onBed then
                    -- Position in LOCAL space: 1.5 studs behind + 0.25 studs higher than target
                    local behindCF = targetRoot.CFrame * CFrame.new(0, 0.25, 1.5)
                    -- Lerp our root toward that spot each frame (alpha=0.18 => smooth ~5-6 frame glide)
                    myRoot.CFrame = myRoot.CFrame:Lerp(behindCF, 0.18)
                end
            end)
        end
    end
})

-- KEYCARD HOARDER ─────────────────────────────────────────────────
-- Claims keycards and immediately uses the server's own RemoveCard signal to
-- strip them back out — this triggers the game's LocalScript removal handler,
-- which is what actually destroys the Tool, so the desk can respawn it.
local cardHoardEnabled = false

local function dumpCardsFromInventory()
    local removeCardEvent = ReplicatedStorage:FindFirstChild("RemoveCard")
    if removeCardEvent and firesignal then
        -- Temporarily allow our firesignal hook to pass this through
        local prev = cardBypassEnabled
        cardBypassEnabled = false
        -- Fire with several arg formats the game might expect
        for _, arg in next, {"all", "1", true, false, ""} do
            pcall(function() firesignal(removeCardEvent.OnClientEvent, arg) end)
        end
        cardBypassEnabled = prev
    end
    -- Fallback: brute-force destroy any Tool in backpack or character
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    local char = LocalPlayer.Character
    if backpack then
        for _, item in next, backpack:GetChildren() do
            if item:IsA("Tool") then pcall(function() item:Destroy() end) end
        end
    end
    if char then
        for _, item in next, char:GetChildren() do
            if item:IsA("Tool") then pcall(function() item:Destroy() end) end
        end
    end
end

FunGroup:AddToggle('CardHoardToggle', {
    Text = 'Keycard Hoarder (Claim & Dump)',
    Default = false,
    Callback = function(Value)
        cardHoardEnabled = Value
        if Value then
            task.spawn(function()
                while cardHoardEnabled do
                    local cardsOnDesk = Workspace:FindFirstChild("CardsOnDesk", true)
                    if cardsOnDesk then
                        for _, grabCard in next, cardsOnDesk:GetChildren() do
                            if grabCard.Name == "GrabCard" then
                                local clickPart = grabCard:FindFirstChild("Click")
                                local cd = clickPart and clickPart:FindFirstChild("ClickDetector")
                                if cd then
                                    fireclickdetector(cd)       -- claim from desk
                                    task.wait(0.15)             -- let it arrive in inventory
                                    dumpCardsFromInventory()    -- erase it so desk respawns
                                    task.wait(0.1)
                                end
                            end
                        end
                    end
                    task.wait(0.5)
                end
            end)
        end
    end
})

-- ELEVATOR TROLL ──────────────────────────────────────────────────
-- Cycles through the 4 known floor buttons:
-- workspace.Elevator_System.Elevator.ElevatorButtons.button{1-4}.ClickDetector
local elevatorTrollEnabled = false

local function getElevatorFloorButtons()
    local buttons = {}
    local sys = Workspace:FindFirstChild("Elevator_System")
    local elev = sys and sys:FindFirstChild("Elevator")
    local btnFolder = elev and elev:FindFirstChild("ElevatorButtons")
    if btnFolder then
        for i = 1, 4 do
            local btn = btnFolder:FindFirstChild("button" .. i)
            local cd = btn and btn:FindFirstChildOfClass("ClickDetector")
            if cd then table.insert(buttons, cd) end
        end
    end
    return buttons
end

FunGroup:AddSlider('ElevatorSpeedSlider', {
    Text = 'Elevator Spam Delay (s)',
    Default = 0.2,
    Min = 0.05,
    Max = 2,
    Rounding = 2,
    Compact = false,
    Callback = function(_) end  -- read live in the loop below
})

FunGroup:AddToggle('ElevatorTrollToggle', {
    Text = 'Elevator Troll (Floor Spam)',
    Default = false,
    Callback = function(Value)
        elevatorTrollEnabled = Value
        if Value then
            Library:Notify("⚠ Elevator Troll: spamming floor buttons. Toggle off if kicked.", 5)
            task.spawn(function()
                local btns = {}
                local btnIdx = 1
                while elevatorTrollEnabled do
                    if #btns == 0 or btnIdx > #btns then
                        btns = getElevatorFloorButtons()
                        btnIdx = 1
                    end
                    if #btns > 0 then
                        local cd = btns[btnIdx]
                        if cd and cd:IsDescendantOf(game) then
                            pcall(function() fireclickdetector(cd) end)
                        end
                        btnIdx = btnIdx + 1
                    end
                    task.wait(Options.ElevatorSpeedSlider.Value)
                end
            end)
        end
    end
})

-- ── Interactive Spam ──────────────────────────────────────────
local SpamGroup = Tabs.Automation:AddRightGroupbox('Interactive Spam')
local roomNumsWithClosest = {"Closest", "201", "202", "203", "301", "302", "303", "401", "402", "403"}

SpamGroup:AddDropdown('LampSpamRoom', {
    Values = roomNumsWithClosest,
    Default = "Closest",
    Multi = false,
    Text = 'Spam Target Room'
})

local lampSpamEnabled = false
SpamGroup:AddToggle('LampSpamToggle', {
    Text = 'Enable Lamp Spam',
    Default = false,
    Callback = function(Value)
        lampSpamEnabled = Value
        if Value then
            task.spawn(function()
                local cachedCD = nil
                local cachedRoom = nil
                while lampSpamEnabled do
                    local selected = Options.LampSpamRoom.Value
                    local roomNum = selected == "Closest" and getClosestRoomNumber() or selected
                    -- Refresh cache only when room changes
                    if roomNum ~= cachedRoom then
                        cachedRoom = roomNum
                        cachedCD = getLampClickDetector(roomNum)
                    end
                    -- Validate cached CD still exists
                    if cachedCD and not cachedCD:IsDescendantOf(game) then
                        cachedCD = getLampClickDetector(roomNum)
                    end
                    if cachedCD then
                        fireclickdetector(cachedCD)
                    end
                    task.wait()
                end
            end)
        end
    end
})

Library:SetWatermarkVisibility(false)
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ 'BackgroundColor' })
ThemeManager:SetFolder('nexsync_hotel')
SaveManager:SetFolder('nexsync_hotel/configs')
SaveManager:BuildConfigSection(Tabs['UI Settings'])
ThemeManager:ApplyToTab(Tabs['UI Settings'])
SaveManager:LoadAutoloadConfig()

Library.ToggleKeybind = Enum.KeyCode.RightControl
Library:Toggle()
