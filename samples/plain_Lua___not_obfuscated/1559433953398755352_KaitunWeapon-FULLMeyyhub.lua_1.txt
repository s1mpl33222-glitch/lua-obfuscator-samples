--[[
    MEYY HUB - KAITUN WEAPON - SCRIPT COMPLETO DESCIFRADO (100% AUTOCONTENIDO)
    ------------------------------------------------------------------
    - Extraido del servidor de meyyhub con tu key (naa-21ETAU5C) y tu HWID.
    - Sin autenticacion, sin anti-tamper, sin checks de key: codigo puro.
    - SIN DEPENDENCIAS EXTERNAS: los modulos que antes se descargaban de
      pastefy estan incrustados dentro (buscar "[INLINE" para verlos).
    - Funciones: auto farm de armas kaitun (tween/TP entre coordenadas, attack, modulo de movimiento embebido)
    - Para usarlo: pega/ejecuta este archivo completo en tu executor.
]]
local Services = setmetatable({}, {__index = function(self, name)
    local s, c = pcall(function() return cloneref(game:GetService(name)) end)
    if s then rawset(self, name, c) return c
    else error("Invalid Roblox Service: " .. tostring(name))
    end
end})
pcall(function()
    -- [INLINE Weapon Tween/TP — original: https://pastefy.app/aBWBIAry/raw]
(function() --begin Weapon Tween/TP

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local CollectionService = game:GetService("CollectionService")

local LocalPlayer = Players.LocalPlayer
local CommF_ = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_")

local place_check = game.PlaceId
local sea1 = (place_check == 2753915549 or place_check == 85211729168715)
local sea2 = (place_check == 4442272183 or place_check == 79091703265657)
local sea3 = (place_check == 7449423635 or place_check == 100117331123089)
local newsea = (place_check == 73902483975735)

if not (sea1 or sea2 or sea3 or newsea) then
    LocalPlayer:Kick("You are not in the correct game!")
end

local SeaIndex = sea3 and 3 or sea2 and 2 or sea1 and 1 or newsea and 4

---------
-- BIẾN HỖ TRỢ VÀ TỌA ĐỘ
---------
local newdao = CFrame.new(10641.09, -1953.92, 9825.07)
local cframenpc = CFrame.new(-16271.12, 25.58, 1371.98)

local currentTweenId = 0
local TPLoop = nil
local NoclipLoop = nil
local TP_Speed = 170 

_G.Config_ = _G.Config_ or {}

---------
-- HÀM TIỆN ÍCH (UTILITIES)
---------
local function GetTargetCFrame(Target)
    if typeof(Target) == "CFrame" then
        return Target
    elseif typeof(Target) == "Vector3" then
        return CFrame.new(Target)
    elseif typeof(Target) == "Instance" then
        if Target:IsA("BasePart") then
            return Target.CFrame
        elseif Target:IsA("Model") and Target.PrimaryPart then
            return Target.PrimaryPart.CFrame
        elseif Target:IsA("Player") and Target.Character and Target.Character:FindFirstChild("HumanoidRootPart") then
            return Target.Character.HumanoidRootPart.CFrame
        end
    end
    return nil
end

local function GetDistance(Target, IgnoreY)
    local targetPos = GetTargetCFrame(Target)
    if not targetPos then return math.huge end
    
    local character = LocalPlayer.Character
    local hrp = character and character:FindFirstChild("HumanoidRootPart")
    if not hrp then return math.huge end
    
    if IgnoreY then
        return (Vector3.new(hrp.Position.X, 0, hrp.Position.Z) - Vector3.new(targetPos.Position.X, 0, targetPos.Position.Z)).Magnitude
    end
    return (hrp.Position - targetPos.Position).Magnitude
end

local function WaitForHumanoid()
    local character = LocalPlayer.Character
    if not character then return nil end
    local humanoid = character:FindFirstChild("Humanoid")
    if humanoid then return humanoid end
    
    local timeout = tick() + 5
    while tick() < timeout do
        humanoid = character:FindFirstChild("Humanoid")
        if humanoid then return humanoid end
        task.wait(0.1)
    end
    return nil
end

local function CheckItem(ITEM_NAME)
    for _, v in pairs(LocalPlayer.Backpack:GetChildren()) do
        if v:IsA('Tool') and string.find(v.Name, ITEM_NAME) then return v end
    end
    local character = LocalPlayer.Character
    if character then
        for _, v in pairs(character:GetChildren()) do
            if v:IsA('Tool') and string.find(v.Name, ITEM_NAME) then return v end
        end
    end
    return nil
end

local function CheckLegendaryItems()
    local items = {"God's Chalice", "Fist of Darkness", "Sweet Chalice", "Hallow Essence", "Flower1", "Flower2", "Flower3", "Fire Essence", "Sweet Chalice"}
    for _, item in ipairs(items) do
        if CheckItem(item) then return true end
    end
    return false
end

local function InArea(POS)
    local targetCFrame = GetTargetCFrame(POS)
    if not targetCFrame then return {Name = ""} end
    
    local WorldOrigin = workspace:FindFirstChild("_WorldOrigin")
    if not WorldOrigin or not WorldOrigin:FindFirstChild("Locations") then return {Name = ""} end
    
    for _, v in pairs(WorldOrigin.Locations:GetChildren()) do
        if v:FindFirstChild("Mesh") and (targetCFrame.Position - v.Position).Magnitude <= v.Mesh.Scale.X then
            return v
        end
    end
    return {Name = ""}
end

local function GetSpawnPoint(x)
    local origin = workspace:FindFirstChild("_WorldOrigin")
    if not origin then return nil end
    local spawns = origin:FindFirstChild("PlayerSpawns") and origin.PlayerSpawns:FindFirstChild("Pirates")
    if not spawns then return nil end
    
    for _, v in pairs(spawns:GetChildren()) do
        if (v.Part.Position - x.Position).Magnitude <= 2500 then
            return v
        end
    end
    return nil
end



local function RequestEntrance(targetPos)
    local targetCFrame = GetTargetCFrame(targetPos)
    if not targetCFrame then return end
    
    local tpPoints = {}
    if SeaIndex == 1 then
        tpPoints = {
            ["Sky3"] = Vector3.new(-7894, 5547, -380),
            ["Sky3Exit"] = Vector3.new(-4607, 874, -1667),
            ["UnderWater"] = Vector3.new(61163, 11, 1819),
            ["UnderwaterExit"] = Vector3.new(4050, -1, -1814)
        }
    elseif SeaIndex == 2 then
        tpPoints = {
            ["Swan Mansion"] = Vector3.new(-390, 332, 673),
            ["Swan Room"] = Vector3.new(2285, 15, 905),
            ["Cursed Ship"] = Vector3.new(923, 126, 32852),
            ["Zombie Island"] = Vector3.new(-6509, 83, -133)
        }
    elseif SeaIndex == 3 then
        tpPoints = {
            ["Hydra Island"] = Vector3.new(5657.88, 1013.07, -335.49),
            ["Mansion"] = Vector3.new(-12462, 375, -7552),
            ["Castle"] = Vector3.new(-5036, 315, -3179),
            ["Temple of Time"] = Vector3.new(28286, 14897, 103),
            ["Greate Tree"] = Vector3.new(3024.17, 2280.69, -7325.12)
        }
    end
    
    local closestPoint, minDistance = nil, math.huge
    for _, pos in pairs(tpPoints) do
        local dist = (pos - targetCFrame.Position).Magnitude
        if dist < minDistance then
            minDistance = dist
            closestPoint = pos
        end
    end
    
    if closestPoint and minDistance < GetDistance(targetCFrame) then
        CollectionService:AddTag(LocalPlayer, "Teleporting")
        CommF_:InvokeServer("requestEntrance", closestPoint)
        task.wait(1)
        CollectionService:RemoveTag(LocalPlayer, "Teleporting")
    end
end

local function EnableNoclip(hrp)
    if not NoclipLoop then
        NoclipLoop = RunService.Stepped:Connect(function()
            local character = LocalPlayer.Character
            if character then
                for _, v in pairs(character:GetDescendants()) do
                    if v:IsA("BasePart") and v.CanCollide then
                        v.CanCollide = false
                    end
                end
            end
        end)
    end
end

local function DisableNoclip(hrp)
    if hrp then
        local align = hrp:FindFirstChild("TP_Align")
        if align then
            align.Enabled = false
        end
    end
    
    if NoclipLoop then
        NoclipLoop:Disconnect()
        NoclipLoop = nil
    end
end
function old_tp(TargetInput)
    local targetCFrame = GetTargetCFrame(TargetInput)
    if not targetCFrame then return end
    
    local character = LocalPlayer.Character
    local hrp = character and character:FindFirstChild("HumanoidRootPart")
    local humanoid = character and character:FindFirstChild("Humanoid")
    if not hrp or not humanoid then return end

    currentTweenId = currentTweenId + 1
    local thisTween = currentTweenId
    
    if TPLoop then TPLoop:Disconnect() end

    EnableNoclip(hrp)
    
    local isBoat = humanoid.SeatPart and humanoid.SeatPart:IsA("VehicleSeat")
    if not isBoat then
        humanoid.PlatformStand = true
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
    end
    
    local alignPosition = hrp:FindFirstChild("TP_Align")
    local targetAttachment = workspace.Terrain:FindFirstChild("TP_TargetAtt")
    local rootAttachment = hrp:FindFirstChild("TP_RootAtt")
    
    if not alignPosition then
        if targetAttachment then targetAttachment:Destroy() end
        if rootAttachment then rootAttachment:Destroy() end
        
        targetAttachment = Instance.new("Attachment")
        targetAttachment.Name = "TP_TargetAtt"
        targetAttachment.Parent = workspace.Terrain
        
        rootAttachment = Instance.new("Attachment")
        rootAttachment.Name = "TP_RootAtt"
        rootAttachment.Parent = hrp
        
        alignPosition = Instance.new("AlignPosition")
        alignPosition.Name = "TP_Align"
        alignPosition.Mode = Enum.PositionAlignmentMode.TwoAttachment
        alignPosition.Attachment0 = rootAttachment
        alignPosition.Attachment1 = targetAttachment
        alignPosition.MaxForce = 9e99
        alignPosition.MaxVelocity = TP_Speed or 250
        alignPosition.Responsiveness = 200
        alignPosition.ApplyAtCenterOfMass = true
        alignPosition.Parent = hrp
    end

    targetAttachment.WorldPosition = targetCFrame.Position
    alignPosition.MaxVelocity = TP_Speed or 250
    alignPosition.Enabled = true

    TPLoop = RunService.Heartbeat:Connect(function(deltaTime)
        if currentTweenId ~= thisTween then
            if TPLoop then TPLoop:Disconnect() end
            return
        end
        
        local currentTarget = GetTargetCFrame(TargetInput)
        if not currentTarget or humanoid.Health <= 0 then
            DisableNoclip(hrp)
            local isBoatNow = humanoid.SeatPart and humanoid.SeatPart:IsA("VehicleSeat")
            if not isBoatNow then
                humanoid.PlatformStand = false
                humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, false)
                humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
                humanoid:ChangeState(Enum.HumanoidStateType.Running)
            end
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
            if TPLoop then TPLoop:Disconnect() end
            return
        end

        local currentPos = hrp.Position
        local finalPos = currentTarget.Position
        local distance = (finalPos - currentPos).Magnitude
        
        if distance <= 10 then
            hrp.CFrame = currentTarget
            DisableNoclip(hrp)
            local isBoatNow = humanoid.SeatPart and humanoid.SeatPart:IsA("VehicleSeat")
            if not isBoatNow then
                humanoid.PlatformStand = false
                humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, false)
                humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
                humanoid:ChangeState(Enum.HumanoidStateType.Running)
            end
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
            if TPLoop then TPLoop:Disconnect() end
            return
        end
        
        hrp.AssemblyAngularVelocity = Vector3.zero
        
        targetAttachment.WorldPosition = finalPos
        alignPosition.MaxVelocity = TP_Speed or 250
    end)
    
    return thisTween
end
---------
getgenv().TP = function(TargetInput, ...)
    local targetCFrame = GetTargetCFrame(TargetInput)
    if not targetCFrame then return end
    
    local character = LocalPlayer.Character
    local hrp = character and character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local currentArea = InArea(hrp.Position).Name
    local targetArea = InArea(targetCFrame).Name

    local isRisk = false
    pcall(function()
        local mainGui = LocalPlayer.PlayerGui:FindFirstChild("Main")
        if mainGui then
            for _, v in pairs(mainGui:GetDescendants()) do
                if v:IsA("TextLabel") and v.Visible and string.find(string.lower(v.Text), "risk") then
                    isRisk = true
                    break
                end
            end
        end
    end)

    local tpPoints = {}
    if SeaIndex == 1 then
        tpPoints = {
            ["Sky3"] = Vector3.new(-7894, 5547, -380),
            ["Sky3Exit"] = Vector3.new(-4607, 874, -1667),
            ["UnderWater"] = Vector3.new(61163, 11, 1819),
            ["UnderwaterExit"] = Vector3.new(4050, -1, -1814)
        }
    elseif SeaIndex == 2 then
        tpPoints = {
            ["Swan Mansion"] = Vector3.new(-390, 332, 673),
            ["Swan Room"] = Vector3.new(2285, 15, 905),
            ["Cursed Ship"] = Vector3.new(923, 126, 32852),
            ["Zombie Island"] = Vector3.new(-6509, 83, -133)
        }
    elseif SeaIndex == 3 then
        tpPoints = {
            ["Hydra Island"] = Vector3.new(5657.88, 1013.07, -335.49),
            ["Mansion"] = Vector3.new(-12462, 375, -7552),
            ["Castle"] = Vector3.new(-5036, 315, -3179),
            ["Temple of Time"] = Vector3.new(28286, 14897, 103),
            ["Greate Tree"] = Vector3.new(3024.17, 2280.69, -7325.12)
        }
    end

    local entranceDist = math.huge
    local distToClosestEntrance = math.huge

    for _, pos in pairs(tpPoints) do
        local distTarget = (pos - targetCFrame.Position).Magnitude
        if distTarget < entranceDist then
            entranceDist = distTarget
        end
        
        local distPlayer = (pos - hrp.Position).Magnitude
        if distPlayer < distToClosestEntrance then
            distToClosestEntrance = distPlayer
        end
    end

    local currentDist = (hrp.Position - targetCFrame.Position).Magnitude
    local useEntrance = false

    if currentArea == targetArea and targetArea ~= "" then
        useEntrance = false
    else
        if entranceDist < currentDist then
            useEntrance = true
        end
    end

    if distToClosestEntrance < 1000 then
        useEntrance = false
    end

    if useEntrance then
        RequestEntrance(targetCFrame)
        task.wait(0.5)
    end
    
    if SeaIndex == 3 and GetDistance(newdao.Position) < 2000 then
        hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp and math.abs(newdao.Position.Y - hrp.CFrame.Y) > 1000 then
            repeat
                task.wait()
                old_tp(cframenpc)
                if GetDistance(cframenpc) < 10 then
                    local net = ReplicatedStorage:FindFirstChild("Modules") and ReplicatedStorage.Modules:FindFirstChild("Net")
                    if net then
                        net["RF/SubmarineWorkerSpeak"]:InvokeServer("AskKilledTikiBoss")
                        task.wait(0.5)
                        net["RF/SubmarineWorkerSpeak"]:InvokeServer("TravelToSubmergedIsland")
                    end
                end
            until GetDistance(targetCFrame) < 2000
            task.wait(0.6)
            if hrp:FindFirstChild("TP_BodyVelocity") then
                hrp.TP_BodyVelocity:Destroy()
            end
        end
    end
    
    return old_tp(TargetInput, ...)
end
---------
---------
getgenv().stoptp = function()
    currentTweenId = currentTweenId + 1 
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    DisableNoclip(hrp)
end

LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

print("Tp Engine Optimized - Loaded successfully!")
end)() --end Weapon Tween/TP
end)
replicated = game.ReplicatedStorage
local plr = game:GetService("Players").LocalPlayer
local TweenService = game:GetService("TweenService")
local RS = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
    local Players = game:GetService("Players")
    local TweenService = game:GetService("TweenService")
    local RunService = game:GetService("RunService")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local Workspace = game:GetService("Workspace")
    local HttpService = game:GetService("HttpService")

    local LocalPlayer = Players.LocalPlayer
    local RS = ReplicatedStorage


getgenv().CachedJobIds = {}
getgenv().ScanPage = 15
getgenv().UseApiFallback = false
getgenv().IsScanning = false

local RS = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")

local function StartBackgroundScan(minP, maxP)
    if getgenv().IsScanning or (#getgenv().CachedJobIds > 0) or getgenv().UseApiFallback then return end
    getgenv().IsScanning = true
    getgenv().ScanPage = 15
    
    task.spawn(function()
        local minPlayers = minP or 6
        local maxPlayers = maxP or 10
        local maxPages = 150
        
        while getgenv().IsScanning and getgenv().ScanPage <= maxPages do
            local success, servers = pcall(function()
                return RS:WaitForChild("__ServerBrowser"):InvokeServer(getgenv().ScanPage)
            end)

            if success and type(servers) == "table" then
                for jobId, serverData in pairs(servers) do
                    if type(serverData) == "table" and jobId ~= game.JobId and serverData["Count"] and serverData["Count"] > minPlayers and serverData["Count"] < maxPlayers then
                        local alreadyExists = false
                        for _, id in ipairs(getgenv().CachedJobIds) do
                            if id == jobId then alreadyExists = true break end
                        end
                        
                        if not alreadyExists then
                            table.insert(getgenv().CachedJobIds, jobId)
                        end
                        
                        -- Lưu tối đa 5 server để dành, đủ rồi thì ngắt quét ngầm cho mượt
                        if #getgenv().CachedJobIds >= 5 then
                            getgenv().IsScanning = false
                            return
                        end
                    end
                end
            end

            getgenv().ScanPage = getgenv().ScanPage + 1
            task.wait()
        end
        
        if getgenv().ScanPage > maxPages and #getgenv().CachedJobIds == 0 then
            getgenv().UseApiFallback = true
            getgenv().IsScanning = false
        end
    end)
end
StartBackgroundScan(6, 10)

local function HopServer(minP, maxP)
    if getgenv().IsHopping then return end
    getgenv().IsHopping = true
    getgenv().HopMinP = minP or 6
    getgenv().HopMaxP = maxP or 10
    getgenv().HopServerFunc = HopServer 
    
    getgenv().MainTaskStatus = "SERVER HOPPING"

    task.spawn(function()
        while #getgenv().CachedJobIds == 0 and not getgenv().UseApiFallback do
            getgenv().SubTaskStatus = "Searching Server (Page " .. tostring(getgenv().ScanPage) .. ")"
            task.wait(0.1)
        end

        if getgenv().UseApiFallback then
            getgenv().SubTaskStatus = "Using API Fallback..."
            pcall(function()
                local servers = HttpService:JSONDecode(
                    game:HttpGetAsync("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")
                ).data
                for _, server in pairs(servers) do
                    if server.playing < getgenv().HopMaxP and server.id ~= game.JobId then
                        RS:WaitForChild("__ServerBrowser"):InvokeServer("teleport", server.id)
                        task.wait(4)
                        break
                    end
                end
            end)
        elseif #getgenv().CachedJobIds > 0 then
            getgenv().SubTaskStatus = "Teleporting..."
            
            while #getgenv().CachedJobIds > 0 do
                local targetJobId = table.remove(getgenv().CachedJobIds, 1)
                pcall(function()
                    RS:WaitForChild("__ServerBrowser"):InvokeServer("teleport", targetJobId)
                end)
                
                task.wait(2)
            end
        end

        task.wait(2)
        if getgenv().IsHopping then
            getgenv().IsHopping = false
            StartBackgroundScan(getgenv().HopMinP, getgenv().HopMaxP)
        end
    end)
end
---------
    local function StartAttack()
        task.spawn(function()
        -- [INLINE FastAttack — original: https://pastefy.app/45hCw1JE/raw]
(function() --begin FastAttack
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local VirtualInputManager = game:GetService("VirtualInputManager")

local Player = Players.LocalPlayer
local Modules = ReplicatedStorage:FindFirstChild("Modules")
local Net = Modules and Modules:FindFirstChild("Net")
local RegisterAttack = Net and Net:FindFirstChild("RE/RegisterAttack")
local RegisterHit = Net and Net:FindFirstChild("RE/RegisterHit")
local ShootGunEvent = Net and Net:FindFirstChild("RE/ShootGunEvent")
local GunValidator = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("Validator2")

local LocalPlayer = Players.LocalPlayer
local NetModule
pcall(function()
    if Modules and Modules:FindFirstChild("Net") then
        NetModule = require(Modules.Net)
    end
end)

local Remotes = {}
local Assets = ReplicatedStorage:WaitForChild("Assets")

local RemoteFolder = ReplicatedStorage:FindFirstChild("Remotes")
if RemoteFolder then
    for _, child in ipairs(RemoteFolder:GetChildren()) do
        if child:IsA("RemoteEvent") then
            local id = child:GetAttribute("Id")
            if id then
                Remotes[id] = child
            end
        end
    end

    RemoteFolder.ChildAdded:Connect(function(child)
        if child:IsA("RemoteEvent") then
            local id = child:GetAttribute("Id")
            if id then
                Remotes[id] = child
            end
        end
    end)
end

local KillTrap = {
    LockedTargets = {}, 
    StuckTimeout = 1.5
}

function KillTrap:Process(enemy)
    local hum = enemy:FindFirstChild("Humanoid")
    if not hum then 
        if self.LockedTargets[enemy] then
            self.LockedTargets[enemy] = nil
        end
        return false 
    end
    
    local currentHealth = hum.Health
    local data = self.LockedTargets[enemy]

    if currentHealth <= 0 then
        if self.LockedTargets[enemy] then
            self.LockedTargets[enemy] = nil
        end
        return false
    end

    if not data then
        self.LockedTargets[enemy] = {
            lastHealth = currentHealth,
            lastChangeTime = tick()
        }
        return true
    end

    if currentHealth < data.lastHealth then
        data.lastHealth = currentHealth
        data.lastChangeTime = tick()
        return true
    elseif currentHealth == data.lastHealth then
        if tick() - data.lastChangeTime > self.StuckTimeout then
            self.LockedTargets[enemy] = nil
            return false
        end
        return true
    else
        data.lastHealth = currentHealth
        data.lastChangeTime = tick()
        return true
    end
end

---------
local function GetClosestEnemy()
    local character = LocalPlayer.Character
    if not character then return nil end
    
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return nil end

    local closestEnemy = nil
    local shortestDistance = math.huge

    local enemiesFolder = workspace:FindFirstChild("Enemies")
    local charsFolder = workspace:FindFirstChild("Characters")
    local seaBeastsFolder = workspace:FindFirstChild("SeaBeasts")
    
    local function Scan(folder)
        if not folder then return end
        for _, enemy in ipairs(folder:GetChildren()) do
            if enemy:IsA("Model") and enemy ~= character then
                local n = enemy.Name
                local isSeaBeast = (folder.Name == "SeaBeasts") or n:find("SeaBeast") or n == "Leviathan Segment" or n == "Leviathan"
                local isShip = n:find("PirateBrigade") or n:find("PirateGrandBrigade") or n:find("Brigade")
                
                if isSeaBeast then
                    local pivotSuccess, pivot = pcall(function() return enemy:GetPivot() end)
                    if pivotSuccess and pivot then
                        local dist = (rootPart.Position - pivot.Position).Magnitude
                        if dist <= 6000 and dist < shortestDistance then
                            closestEnemy = enemy
                            shortestDistance = dist
                        end
                    end
                elseif isShip then
                    local healthVal = enemy:FindFirstChild("Health")
                    if healthVal and healthVal.Value > 0 then
                        local pivotSuccess, pivot = pcall(function() return enemy:GetPivot() end)
                        if pivotSuccess and pivot then
                            local dist = (rootPart.Position - pivot.Position).Magnitude
                            if dist <= 6000 and dist < shortestDistance then
                                closestEnemy = enemy
                                shortestDistance = dist
                            end
                        end
                    end
                else
                    local root = enemy:FindFirstChild("HumanoidRootPart")
                    local hum = enemy:FindFirstChild("Humanoid")
                    if root and hum and hum.Health > 0 then
                        local dist = (rootPart.Position - root.Position).Magnitude
                        if dist <= 6000 then
                            KillTrap:Process(enemy)
                        end
                    end
                end
            end
        end
    end

    Scan(enemiesFolder)
    Scan(seaBeastsFolder)
    Scan(charsFolder)

    for enemy, _ in pairs(KillTrap.LockedTargets) do
        if KillTrap:Process(enemy) then
            local enemyRoot = enemy:FindFirstChild("HumanoidRootPart")
            if enemyRoot then
                local distance = (rootPart.Position - enemyRoot.Position).Magnitude
                if distance < shortestDistance then
                    closestEnemy = enemy
                    shortestDistance = distance
                end
            end
        end
    end
    
    return closestEnemy
end

local function Attack()
    local character = LocalPlayer.Character
    if not character then return end
    
    ---------
    local tool = character:FindFirstChildOfClass("Tool") or LocalPlayer.Backpack:FindFirstChildOfClass("Tool")
    ---------
    if not tool or tool:GetAttribute("WeaponType") ~= "Melee" then return end

    local enemy = GetClosestEnemy()
    if enemy then
        local regAttack = Remotes["RE/RegisterAttack"] or RegisterAttack
        if regAttack then
            regAttack:FireServer()
        end

        local hitPart = enemy:FindFirstChild("Head") or enemy:FindFirstChild("HumanoidRootPart") or enemy.PrimaryPart or enemy:FindFirstChildWhichIsA("BasePart")
        if hitPart then
            local regHit = Remotes["RE/RegisterHit"] or RegisterHit
            if regHit then
                regHit:FireServer(enemy, hitPart)
            end
            if NetModule and NetModule.RemoteEvent then
                NetModule:RemoteEvent("RegisterHit"):FireServer(enemy, hitPart)
            end
        end
    end
end

local function GetBladeHits()
    local targets = {}
    local char = game.Players.LocalPlayer.Character
    if not char then return targets end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return targets end

    local enemiesFolder = workspace:FindFirstChild("Enemies")
    local charsFolder = workspace:FindFirstChild("Characters")
    local seaBeastsFolder = workspace:FindFirstChild("SeaBeasts")
    
    local function CheckFolder(folder)
        if not folder then return end
        for _, v in pairs(folder:GetChildren()) do
            if v:IsA("Model") and v ~= char then
                local n = v.Name
                local isSeaBeast = (folder.Name == "SeaBeasts") or n:find("SeaBeast") or n == "Leviathan Segment" or n == "Leviathan"
                local isShip = n:find("PirateBrigade") or n:find("PirateGrandBrigade") or n:find("Brigade")

                if isSeaBeast then
                    local pivotSuccess, pivot = pcall(function() return v:GetPivot() end)
                    if pivotSuccess and pivot then
                        if (pivot.Position - root.Position).Magnitude <= 6000 then
                            table.insert(targets, v)
                        end
                    end
                elseif isShip then
                    local healthVal = v:FindFirstChild("Health")
                    if healthVal and healthVal.Value > 0 then
                        local pivotSuccess, pivot = pcall(function() return v:GetPivot() end)
                        if pivotSuccess and pivot then
                            if (pivot.Position - root.Position).Magnitude <= 6000 then
                                table.insert(targets, v)
                            end
                        end
                    end
                elseif v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") then
                    local dist = (v.HumanoidRootPart.Position - root.Position).Magnitude
                    if dist <= 6000 then
                        KillTrap:Process(v)
                    end
                end
            end
        end
    end

    CheckFolder(enemiesFolder)
    CheckFolder(seaBeastsFolder)
    CheckFolder(charsFolder)

    for enemy, _ in pairs(KillTrap.LockedTargets) do
        if KillTrap:Process(enemy) then
            table.insert(targets, enemy)
        end
    end

    return targets
end

local function AttackAll()
    local player = game.Players.LocalPlayer
    local character = player.Character
    if not character then return end

    ---------
    local equippedWeapon = character:FindFirstChild("EquippedWeapon") or player.Backpack:FindFirstChildOfClass("Tool")
    ---------
    if not equippedWeapon then return end

    local regAttack = Remotes["RE/RegisterAttack"] or RegisterAttack
    local regHit = Remotes["RE/RegisterHit"] or RegisterHit
    
    local enemies = GetBladeHits()
    if #enemies > 0 then
        if regAttack then
            regAttack:FireServer(-math.huge)
        end
        
        local args = {nil, {}}
        for i, v in pairs(enemies) do
            local hitPart = v:FindFirstChild("Head") or v:FindFirstChild("HumanoidRootPart") or v.PrimaryPart or v:FindFirstChildWhichIsA("BasePart")
            if not args[1] then
                args[1] = hitPart
            end
            args[2][i] = {v, hitPart}
        end
        
        if args[1] and regHit then
            regHit:FireServer(unpack(args))
        end
    end
end
---------

---------
RunService.Stepped:Connect(function()
    AttackAll()
end)
---------

local Config = {
    AttackDistance = 65,
    AttackMobs = true,
    AttackPlayers = true,
    AttackCooldown = 0,
    ComboResetTime = 0,
    MaxCombo = 2,
    HitboxLimbs = {"RightLowerArm", "RightUpperArm", "LeftLowerArm", "LeftUpperArm", "RightHand", "LeftHand"},
    AutoClickEnabled = true
}

local FastAttack = {}
FastAttack.__index = FastAttack

function FastAttack.new()
    local self = setmetatable({
        Debounce = 0,
        ComboDebounce = 0,
        ShootDebounce = 0,
        M1Combo = 0,
        EnemyRootPart = nil,
        Connections = {},
        Overheat = {Dragonstorm = {MaxOverheat = 3, Cooldown = 0, TotalOverheat = 0, Distance = 350, Shooting = false}},
        ShootsPerTarget = {["Dual Flintlock"] = 2},
        SpecialShoots = {["Skull Guitar"] = "TAP", ["Bazooka"] = "Position", ["Cannon"] = "Position", ["Dragonstorm"] = "Overheat"}
    }, FastAttack)
    
    pcall(function()
        local CombatController = require(ReplicatedStorage.Controllers.CombatController)
        if getupvalue then
            self.ShootFunction = getupvalue(CombatController.Attack, 9)
        end
        
        local Flags = Modules:FindFirstChild("Flags")
        if Flags then
            self.CombatFlags = require(Flags).COMBAT_REMOTE_THREAD
        end

        local LocalScript = Player:WaitForChild("PlayerScripts"):FindFirstChildOfClass("LocalScript")
        if LocalScript and getsenv then
            local env = getsenv(LocalScript)
            if env._G and env._G.SendHitsToServer then
                self.HitFunction = env._G.SendHitsToServer
            end
        end
    end)
    
    return self
end

function FastAttack:IsEntityAlive(entity)
    local humanoid = entity and entity:FindFirstChild("Humanoid")
    return humanoid and humanoid.Health > 0
end

function FastAttack:CheckStun(Character, Humanoid, ToolTip)
    local Stun = Character:FindFirstChild("Stun")
    local Busy = Character:FindFirstChild("Busy")
    if Humanoid.Sit and (ToolTip == "Sword" or ToolTip == "Melee" or ToolTip == "Blox Fruit") then
        return false
    elseif (Stun and Stun.Value > 0) or (Busy and Busy.Value) then
        return false
    end
    return true
end

function FastAttack:GetBladeHits(Character, Distance)
    local Position = Character:GetPivot().Position
    local BladeHits = {}
    local MaxDist = Distance or 6000
    
    local function ScanForNewTargets(Folder)
        if not Folder then return end
        for _, Enemy in ipairs(Folder:GetChildren()) do
            if Enemy ~= Character then
                local n = Enemy.Name
                local isSeaBeast = (Folder.Name == "SeaBeasts") or n:find("SeaBeast") or n == "Leviathan Segment" or n == "Leviathan"
                local isShip = n:find("PirateBrigade") or n:find("PirateGrandBrigade") or n:find("Brigade")
                
                if isSeaBeast or isShip then
                    local pivotSuccess, pivot = pcall(function() return Enemy:GetPivot() end)
                    if pivotSuccess and pivot then
                        if (Position - pivot.Position).Magnitude <= MaxDist then
                            local BasePart = Enemy:FindFirstChild("Head") or Enemy:FindFirstChild("Hitbox") or Enemy:FindFirstChild("HumanoidRootPart") or Enemy.PrimaryPart or Enemy:FindFirstChildWhichIsA("BasePart")
                            if BasePart then
                                if not self.EnemyRootPart then
                                    self.EnemyRootPart = BasePart
                                else
                                    table.insert(BladeHits, {Enemy, BasePart})
                                end
                            end
                        end
                    end
                elseif self:IsEntityAlive(Enemy) then
                    local root = Enemy:FindFirstChild("HumanoidRootPart")
                    if root and (Position - root.Position).Magnitude <= MaxDist then
                        KillTrap:Process(Enemy)
                    end
                end
            end
        end
    end

    if Config.AttackMobs then 
        ScanForNewTargets(Workspace:FindFirstChild("Enemies")) 
        ScanForNewTargets(Workspace:FindFirstChild("SeaBeasts")) 
    end
    if Config.AttackPlayers then ScanForNewTargets(Workspace:FindFirstChild("Characters")) end

    for Enemy, _ in pairs(KillTrap.LockedTargets) do
        if KillTrap:Process(Enemy) then
            local BasePart = Enemy:FindFirstChild(Config.HitboxLimbs[math.random(#Config.HitboxLimbs)]) or Enemy:FindFirstChild("HumanoidRootPart")
            if BasePart then
                if not self.EnemyRootPart then
                    self.EnemyRootPart = BasePart
                else
                    table.insert(BladeHits, {Enemy, BasePart})
                end
            end
        end
    end
    
    return BladeHits
end

function FastAttack:GetClosestEnemy(Character, Distance)
    local BladeHits = self:GetBladeHits(Character, Distance)
    local Closest, MinDistance = nil, math.huge
    
    for _, Hit in ipairs(BladeHits) do
        local Magnitude = (Character:GetPivot().Position - Hit[2].Position).Magnitude
        if Magnitude < MinDistance then
            MinDistance = Magnitude
            Closest = Hit[2]
        end
    end
    return Closest
end

function FastAttack:GetCombo()
    self.ComboDebounce = tick()
    self.M1Combo = 3
    return 3
end

function FastAttack:ShootInTarget(TargetPosition)
    local Character = Player.Character
    if not Character then return end
    
    local Equipped = Character:FindFirstChildOfClass("Tool") or Player.Backpack:FindFirstChildOfClass("Tool")
    if not Equipped or Equipped.ToolTip ~= "Gun" then return end
    
    local Cooldown = Equipped:FindFirstChild("Cooldown") and Equipped.Cooldown.Value or 0.3
    if (tick() - self.ShootDebounce) < Cooldown then return end
    
    local ShootType = self.SpecialShoots[Equipped.Name] or "Normal"
    if ShootType == "Position" or (ShootType == "TAP" and Equipped:FindFirstChild("RemoteEvent")) then
        Equipped:SetAttribute("LocalTotalShots", (Equipped:GetAttribute("LocalTotalShots") or 0) + 1)
        
        if self.ShootFunction and getupvalue and GunValidator then
            GunValidator:FireServer(self:GetValidator2())
        end
        
        if ShootType == "TAP" and Equipped:FindFirstChild("RemoteEvent") then
            Equipped.RemoteEvent:FireServer("TAP", TargetPosition)
        elseif ShootGunEvent then
            ShootGunEvent:FireServer(TargetPosition)
        end
        self.ShootDebounce = tick()
    else
        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
        task.wait(0.05)
        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
        self.ShootDebounce = tick()
    end
end

function FastAttack:GetValidator2()
    if not getupvalue or not setupvalue or not self.ShootFunction then return 0, 0 end
    
    local u27 = getupvalue(self.ShootFunction, 13)
    local u23 = getupvalue(self.ShootFunction, 14)
    local u26 = getupvalue(self.ShootFunction, 15)
    local u22 = getupvalue(self.ShootFunction, 16)
    local u24 = getupvalue(self.ShootFunction, 17)
    local u25 = getupvalue(self.ShootFunction, 18)
    local u28 = getupvalue(self.ShootFunction, 19)
    
    local u81 = u27 * u23
    local u82 = (u26 * u23 + u27 * u22) % u24
    u82 = (u82 * u24 + u81) % u25
    u26 = math.floor(u82 / u24)
    u27 = u82 - u26 * u24
    u28 = u28 + 1
    
    setupvalue(self.ShootFunction, 13, u27)
    setupvalue(self.ShootFunction, 14, u23)
    setupvalue(self.ShootFunction, 15, u26)
    setupvalue(self.ShootFunction, 16, u22)
    setupvalue(self.ShootFunction, 17, u24)
    setupvalue(self.ShootFunction, 18, u25)
    setupvalue(self.ShootFunction, 19, u28)
    
    return math.floor(u82 / u25 * 16777215), u28
end

function FastAttack:UseNormalClick(Character, Humanoid, Cooldown)
    self.EnemyRootPart = nil
    local BladeHits = self:GetBladeHits(Character)
    
    local regAttack = Remotes["RE/RegisterAttack"] or RegisterAttack
    local regHit = Remotes["RE/RegisterHit"] or RegisterHit

    if self.EnemyRootPart or #BladeHits > 0 then
        if regAttack then
            regAttack:FireServer(-math.huge) 
        end

        if self.EnemyRootPart then
            local HitTable = {}
            if self.EnemyRootPart.Parent then
                table.insert(HitTable, {self.EnemyRootPart.Parent, self.EnemyRootPart})
            end
            for _, hitData in ipairs(BladeHits) do
                table.insert(HitTable, {hitData[1], hitData[2]})
            end

            if self.CombatFlags and self.HitFunction then
                self.HitFunction(self.EnemyRootPart, HitTable)
            elseif regHit then
                regHit:FireServer(self.EnemyRootPart, HitTable)
            end
        end
    end
end

function FastAttack:UseFruitM1(Character, Equipped, Combo)
    local Targets = self:GetBladeHits(Character)
    
    if #Targets > 0 or self.EnemyRootPart then
        local Direction
        if Targets[1] then
            Direction = (Targets[1][2].Position - Character:GetPivot().Position).Unit
        else
            Direction = Character:GetPivot().LookVector
        end
        local remote = Equipped:FindFirstChild("LeftClickRemote")
        if remote then
            remote:FireServer(Direction, Combo)
        end
    end
end

function FastAttack:Attack()
    if not Config.AutoClickEnabled or (tick() - self.Debounce) < Config.AttackCooldown then return end
    local Character = Player.Character
    if not Character then return end
    
    local Humanoid = Character:FindFirstChild("Humanoid")
    if not Humanoid then return end
    
    local Equipped = Character:FindFirstChildOfClass("Tool") or Player.Backpack:FindFirstChildOfClass("Tool")
    if not Equipped then return end
    
    local ToolTip = Equipped.ToolTip
    if not table.find({"Melee", "Blox Fruit", "Sword", "Gun"}, ToolTip) then return end
    
    local CooldownVal = Equipped:FindFirstChild("Cooldown")
    local Cooldown = CooldownVal and CooldownVal.Value or Config.AttackCooldown
    if not self:CheckStun(Character, Humanoid, ToolTip) then return end
    
    local Combo = self:GetCombo()
    Cooldown = Cooldown + (Combo >= Config.MaxCombo and 0.05 or 0)
    self.Debounce = Combo >= Config.MaxCombo and ToolTip ~= "Gun" and (tick() + 0.05) or tick()
    
    if ToolTip == "Blox Fruit" and Equipped:FindFirstChild("LeftClickRemote") then
        self:UseFruitM1(Character, Equipped, Combo)
    elseif ToolTip == "Gun" then
        local Target = self:GetClosestEnemy(Character, 120)
        if Target then
            self:ShootInTarget(Target.Position)
        end
    else
        self:UseNormalClick(Character, Humanoid, Cooldown)
    end
end

local AttackInstance = FastAttack.new()

table.insert(AttackInstance.Connections, RunService.Stepped:Connect(function()
    AttackInstance:Attack()
end))

if getgc and hookfunction then
    for _, v in pairs(getgc(true)) do
        if typeof(v) == "function" and iscclosure(v) then
            local info = debug.getinfo(v)
            local name = info and info.name
            if name == "Attack" or name == "attack" or name == "RegisterHit" then
                pcall(function()
                    hookfunction(v, function(...)
                        AttackInstance:Attack()
                        return v(...)
                    end)
                end)
            end
        end
    end
end
end)() --end FastAttack
        end)
    end

---------
---------
task.spawn(function()
    while task.wait(0.25) do
        pcall(function()
            replicated.Remotes.CommF_:InvokeServer("ColorsDealer", "2")
        end)
        pcall(function()
            replicated.Remotes.CommF_:InvokeServer("LegendarySwordDealer", "1")
            replicated.Remotes.CommF_:InvokeServer("LegendarySwordDealer", "2")
        end)
    end
end)
---------
---------
local HttpService = game:GetService("HttpService")

local function FormatForAPI(str)
if not str then return "" end
return string.gsub(str, "[%s_%(%)%[%]%%]", "")
end

local function GetHistoryFileName(filter)
return "meyy_history_" .. tostring(filter) .. ".json"
end

local function LoadHistory(filter)
local fileName = GetHistoryFileName(filter)
if isfile and isfile(fileName) then
local success, data = pcall(function()
return HttpService:JSONDecode(readfile(fileName))
end)
if success and type(data) == "table" then
return data
end
end
return {}
end

local function SaveHistory(filter, historyTable)
local fileName = GetHistoryFileName(filter)
if writefile then
pcall(function()
writefile(fileName, HttpService:JSONEncode(historyTable))
end)
end
end

getgenv().FailedJobIds = getgenv().FailedJobIds or {}
getgenv().LastApiRefresh = 0
local joinFailed = false

local isHopping = false
local isFighting = false
---------
---------
local function HopToServerByAPI(filterNames, maxPlayers, waitTime)
    maxPlayers = maxPlayers or 12
    waitTime   = waitTime or 25
    local apiUrl = "https://api-meomeo.up.railway.app/?key=" .. filterNames
    local CURRENT_PLACE_ID = game.PlaceId
    local maxRetries = math.max(1, math.floor(waitTime / 3))

    getgenv().MainTaskStatus = "SERVER HOPPING"
    getgenv().SubTaskStatus = "Requesting API: " .. tostring(filterNames)

    for attempt = 1, maxRetries do
        getgenv().SubTaskStatus = "Fetching API (" .. tostring(filterNames) .. ") [" .. attempt .. "/" .. maxRetries .. "]"
        
        local historyList = LoadHistory(filterNames)
        local oldJobIds = {}
        for _, jobId in ipairs(historyList) do oldJobIds[jobId] = true end

        local ok, result = pcall(function()
            local responseBody
            pcall(function() responseBody = game:HttpGet(apiUrl) end)
            if not responseBody then
                local reqFunc = (syn and syn.request) or request or http.request
                if reqFunc then
                    local req = reqFunc({ Url = apiUrl, Method = "GET" })
                    if req then responseBody = req.Body end
                end
            end
            if not responseBody then
                getgenv().SubTaskStatus = "API Request Failed (Attempt " .. attempt .. "/" .. maxRetries .. ")"
                return "ERROR"
            end
            
            local data
            local decodeOk, decodeRes = pcall(function() return HttpService:JSONDecode(responseBody) end)
            if not decodeOk or type(decodeRes) ~= "table" then
                getgenv().SubTaskStatus = "JSON Decode Error (Attempt " .. attempt .. "/" .. maxRetries .. ")"
                return "ERROR"
            end
            data = decodeRes
            
            local dataList = data["Make By Dragons Toro"] or data.servers or data.data or data.Servers or data
            if type(dataList) ~= "table" then
                getgenv().SubTaskStatus = "Invalid API Response (Attempt " .. attempt .. "/" .. maxRetries .. ")"
                return "ERROR"
            end

            local seen, servers, currentJobIds = {}, {}, {}
            for _, entry in pairs(dataList) do
                if type(entry) == "table" then
                    local jobId   = entry.joinId or entry.jobId or entry.jobid or entry.id
                    local placeId = tonumber(entry.placeId) or tonumber(entry.placeid) or CURRENT_PLACE_ID
                    
                    local players = 99
                    local rawPlayers = entry.players or entry.playing or entry.Players or entry.Playing
                    
                    if type(rawPlayers) == "string" then
                        local currentP = string.match(rawPlayers, "(%d+)/")
                        if currentP then
                            players = tonumber(currentP)
                        else
                            players = tonumber(rawPlayers) or 99
                        end
                    elseif type(rawPlayers) == "number" then
                        players = rawPlayers
                    end

                    if jobId and placeId and not seen[jobId] then
                        seen[jobId] = true
                        table.insert(currentJobIds, jobId)
                        table.insert(servers, { jobid = jobId, placeid = placeId, players = players })
                    end
                end
            end
            SaveHistory(filterNames, currentJobIds)

---------
            local newServers, allFiltered = {}, {}
            for _, s in ipairs(servers) do
                if s.placeid == CURRENT_PLACE_ID and s.players >= 2 and s.players < maxPlayers then
                    table.insert(allFiltered, s)
                    if not oldJobIds[s.jobid] then table.insert(newServers, s) end
                end
            end

            if #newServers == 0 or #historyList > 20 then
                SaveHistory(filterNames, {})
                oldJobIds = {}
                newServers = allFiltered
            end

            local targetServers = newServers
            if #targetServers == 0 then
                getgenv().SubTaskStatus = "No Valid Server (" .. tostring(filterNames) .. ")"
                return "NO_SERVER"
            end
---------
            getgenv().SubTaskStatus = "Found " .. #targetServers .. " Servers | Filtering Candidates..."

            for index, server in ipairs(targetServers) do
                local jobId = server.jobid
                if jobId == game.JobId then continue end
                if getgenv().FailedJobIds[jobId] and (tick() - getgenv().FailedJobIds[jobId] < 60) then continue end

                getgenv().SubTaskStatus = "Connecting: " .. string.sub(jobId, 1, 8) .. "... (" .. tostring(server.players) .. "P) [" .. index .. "/" .. #targetServers .. "]"

                local localJoinFailed = false
                local teleportService = game:GetService("TeleportService")
                local guiService = game:GetService("GuiService")
                local coreGui = game:GetService("CoreGui")

                local tpConn
                tpConn = teleportService.TeleportInitFailed:Connect(function()
                    localJoinFailed = true
                    getgenv().FailedJobIds[jobId] = tick()
                    getgenv().SubTaskStatus = "Teleport Failed: " .. string.sub(jobId, 1, 8) .. "..."
                end)

                local errConn
                errConn = guiService.ErrorMessageChanged:Connect(function()
                    localJoinFailed = true
                    getgenv().FailedJobIds[jobId] = tick()
                    getgenv().SubTaskStatus = "Roblox Error Prompt: " .. string.sub(jobId, 1, 8) .. "..."
                    pcall(function() teleportService:CancelQueuedTeleports() end)
                    pcall(function() guiService:ClearError() end)
                end)

                local errUIConn
                pcall(function()
                    local promptOverlay = coreGui:WaitForChild("RobloxPromptGui", 2):WaitForChild("promptOverlay", 2)
                    if promptOverlay then
                        if promptOverlay:FindFirstChild("ErrorPrompt") then
                            localJoinFailed = true
                            getgenv().FailedJobIds[jobId] = tick()
                            getgenv().SubTaskStatus = "Error Prompt Detected: " .. string.sub(jobId, 1, 8) .. "..."
                            pcall(function() teleportService:CancelQueuedTeleports() end)
                            pcall(function() promptOverlay.ErrorPrompt:Destroy() end)
                        end

                        errUIConn = promptOverlay.ChildAdded:Connect(function(child)
                            if child.Name == "ErrorPrompt" or string.find(string.lower(child.Name), "error") then
                                localJoinFailed = true
                                getgenv().FailedJobIds[jobId] = tick()
                                getgenv().SubTaskStatus = "Error UI Detected: " .. string.sub(jobId, 1, 8) .. "..."
                                pcall(function() teleportService:CancelQueuedTeleports() end)
                                pcall(function() child:Destroy() end)
                            end
                        end)
                    end
                end)

                local teleportOk = pcall(function()
                    game:GetService("ReplicatedStorage"):WaitForChild("__ServerBrowser"):InvokeServer("teleport", jobId)
                end)

                if teleportOk then
                    local startTime = tick()
                    while (tick() - startTime < 3) do
                        if localJoinFailed then break end
                        getgenv().SubTaskStatus = "Teleporting to " .. string.sub(jobId, 1, 8) .. "... (" .. string.format("%.1fs", 3 - (tick() - startTime)) .. ")"
                        task.wait(0.2)
                    end
                else
                    localJoinFailed = true
                    getgenv().FailedJobIds[jobId] = tick()
                    getgenv().SubTaskStatus = "Teleport Invoke Failed: " .. string.sub(jobId, 1, 8) .. "..."
                end

                if tpConn then tpConn:Disconnect() end
                if errConn then errConn:Disconnect() end
                if errUIConn then errUIConn:Disconnect() end

                if not localJoinFailed then 
                    getgenv().SubTaskStatus = "Joining Server: " .. string.sub(jobId, 1, 8) .. "..."
                    return true 
                end
                
                getgenv().SubTaskStatus = "Hop Failed (" .. string.sub(jobId, 1, 8) .. "...), trying next..."
                task.wait(0.25)
            end
            return "RETRY"
        end)

        if ok and result == true then return true end
        if ok and result == "ALL_CACHED" then return "ALL_CACHED" end
        getgenv().SubTaskStatus = "API Attempt " .. attempt .. " Failed. Retrying..."
        task.wait(0.5)
    end

    getgenv().SubTaskStatus = "API Hop Failed! Falling back to Normal Hop..."
    task.wait(0.5)
    if HopServer then
        HopServer()
    elseif getgenv().HopServerFunc then
        getgenv().HopServerFunc()
    end
    return false
end
---------

---------
    local function JoinSea(targetSea)
    getgenv().MainTaskStatus = "TRAVELING"
    getgenv().SubTaskStatus = "Joining Sea " .. tostring(targetSea)
    local placeId = game.PlaceId
    local commF = Services.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_")
    
    if targetSea == 1 then
        if placeId == 4442272183 or placeId == 79091703265657 or placeId == 7449423635 or placeId == 100117331123089 then
            commF:InvokeServer("TravelMain")
        end
    elseif targetSea == 2 then
        if placeId == 2753915549 or placeId == 85211729168715 or placeId == 7449423635 or placeId == 100117331123089 then
            commF:InvokeServer("TravelDressrosa")
        end
    elseif targetSea == 3 then
        if placeId == 4442272183 or placeId == 79091703265657 or placeId == 2753915549 or placeId == 85211729168715 then
            commF:InvokeServer("TravelZou")
        end
    end
end

local function joinMarines()
    local args = {
        [1] = "SetTeam",
        [2] = "Marines"
    }
    local remote = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("CommF_")
    remote:InvokeServer(unpack(args))
end


while task.wait(0.5) do
    if LocalPlayer.Team and LocalPlayer.Team.Name == "Marines" then
        break
    end
    
    local success, err = pcall(function()
        joinMarines()
    end)
    
    if LocalPlayer.Team and LocalPlayer.Team.Name == "Marines" then
        break
    end
end

task.spawn(function()
    while task.wait(1) do
        pcall(function()
            local char = LocalPlayer.Character or plr.Character
            if char and not char:FindFirstChild("HasBuso") then
                replicated.Remotes.CommF_:InvokeServer("Buso")
            end
        end)
    end
end)

---------
task.spawn(function()
    local lastPosition = nil
    local lastMoveTime = tick()

    while task.wait(1) do
        local isWaitingForBoss = false
        if getgenv().MainTaskStatus and string.find(tostring(getgenv().MainTaskStatus), "WAITING BOSS SPAWN TIME") then
            isWaitingForBoss = true
        end

        if isWaitingForBoss then
            lastMoveTime = tick() 
            continue
        end

        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local currentPos = char.HumanoidRootPart.Position

            if lastPosition then
                local distance = (currentPos - lastPosition).Magnitude
                if distance > 5 then
                    lastPosition = currentPos
                    lastMoveTime = tick()
                else
                    if tick() - lastMoveTime > 120 then 
                        getgenv().MainTaskStatus = "ANTI-BUG"
                        getgenv().SubTaskStatus = "Stuck for 2 mins, hopping server!"
                        
                        if type(HopServer) == "function" then
                            HopServer()
                        elseif type(getgenv().HopServerFunc) == "function" then
                            getgenv().HopServerFunc()
                        end
                        
                        lastMoveTime = tick() 
                    end
                end
            else
                lastPosition = currentPos
                lastMoveTime = tick()
            end
        else
            lastMoveTime = tick() 
        end
    end
end)
---------
-- Soul Cane
replicated.Remotes.CommF_:InvokeServer("BuyItem", "Soul Cane")
-- Bisento
replicated.Remotes.CommF_:InvokeServer("BuyItem", "Bisento")
-- Dual-Headed Blade
replicated.Remotes.CommF_:InvokeServer("BuyItem", "Dual-Headed Blade")
-- Pipe
replicated.Remotes.CommF_:InvokeServer("BuyItem", "Pipe")
-- Sword
replicated.Remotes.CommF_:InvokeServer("BuyItem", "Cutlass")
-- Sword
replicated.Remotes.CommF_:InvokeServer("BuyItem", "Dual Katana")
-- Sword
replicated.Remotes.CommF_:InvokeServer("BuyItem", "Katana")
-- Sword
replicated.Remotes.CommF_:InvokeServer("BuyItem", "Iron Mace")
-- Sword
replicated.Remotes.CommF_:InvokeServer("BuyItem", "Triple Katana")
-- kabucha 
 replicated.Remotes.CommF_:InvokeServer("BlackbeardReward", "Slingshot", "2")
-- Cannon
 replicated.Remotes.CommF_:InvokeServer("BuyItem", "Cannon")
-- Refined Flintlock
replicated.Remotes.CommF_:InvokeServer("BuyItem", "Refined Slingshot")
-- Flintlock
replicated.Remotes.CommF_:InvokeServer("BuyItem", "Flintlock")
--  Dual Flintlock
replicated.Remotes.CommF_:InvokeServer("BuyItem", "Dual Flintlock")
-- Musket
replicated.Remotes.CommF_:InvokeServer("BuyItem", "Musket")
-- Slingshot
replicated.Remotes.CommF_:InvokeServer("BuyItem", "Slingshot")
-- Bizarre Rifle
replicated.Remotes.CommF_:InvokeServer("Ectoplasm", "Buy", 1)


local Config = {
    TargetBossName = "iemnaieudau", 
    TweenSpeed = 200,
    HoverHeight = 40
}

local BossDrops = {
    ["Bisento"] = {Boss = "Greybeard", Sea = 1},
    ["Wardens Sword"] = {Boss = "Chief Warden", Sea = 1},
    ["Magma Blaster"] = {Boss = "Magma Admiral", Sea = 1},
    ["Bazooka"] = {Boss = "Wysper", Sea = 1},
    ["Pole (1st Form)"] = {Boss = "Thunder God", Sea = 1},
    ["Trident"] = {Boss = "Fishman Lord", Sea = 1},
    ["Longsword"] = {Boss = "Diamond", Sea = 2},
    ["Gravity Blade"] = {Boss = "Orbitus", Sea = 2},
    ["Dragon Trident"] = {Boss = "Tide Keeper", Sea = 2},
    ["Flail"] = {Boss = "Smoke Admiral", Sea = 2},
    ["Twin Hooks"] = {Boss = "Captain Elephant", Sea = 3},
    ["Canvander"] = {Boss = "Beautiful Pirate", Sea = 3},
    ["Buddy Sword"] = {Boss = "Cake Queen", Sea = 3},
    ["Venom Bow"] = {Boss = "Hydra Leader", Sea = 3},
    ["Hallow Scythe"] = {Boss = "Soul Reaper", Sea = 3},
    ["Shizu"] = {Boss = "Legendary Sword Dealer", Sea = 2},
    ["True Triple Katana"] = {Boss = "MysteriousMan", Sea = 2},
    ["Oroshi"] = {Boss = "Legendary Sword Dealer", Sea = 2},
    ["Saishi"] = {Boss = "Legendary Sword Dealer", Sea = 2}
    
}



---------
    local function EquipWeapon()
        local char = LocalPlayer.Character
        if not char then return end
        
        if getgenv().MasteryWeapon then
            local tool = char:FindFirstChild(getgenv().MasteryWeapon) or LocalPlayer.Backpack:FindFirstChild(getgenv().MasteryWeapon)
            if tool and tool:IsA("Tool") then
                tool.Parent = char
                return
            end
        end
        
        local targetTooltip = (getgenv().Config and getgenv().Config.Weapon) or "Melee"
        
        local function CheckParent(parent)
            for _, item in pairs(parent:GetChildren()) do
                if item:IsA("Tool") and item.ToolTip == targetTooltip then
                    item.Parent = char
                    return true
                end
            end
            return false
        end
        
        if not CheckParent(char) then
            CheckParent(LocalPlayer.Backpack)
        end
    end
---------

    
    


---------
    local function IsBossMatch(name)
        if Config.TargetBossName == nil or Config.TargetBossName == "" then return false end
        if Config.TargetBossName == "Elite" then
            return name == "Urban" or name == "Deandre" or name == "Diablo"
        elseif Config.TargetBossName == "rip_indra" then
            return name == "rip_indra True Form"
        else
            return string.find(name, Config.TargetBossName) ~= nil
        end
    end

    local function GetBoss()
        local searchTargets = {}
        local enemiesDir = Workspace:FindFirstChild("Enemies")
        if enemiesDir then
            table.insert(searchTargets, enemiesDir)
        end
        
        local fortFolder = ReplicatedStorage:FindFirstChild("FortBuilderReplicatedSpawnPositionsFolder")
        if fortFolder then
            table.insert(searchTargets, fortFolder)
        end
        
        table.insert(searchTargets, ReplicatedStorage)
        
        for _, target in pairs(searchTargets) do
            for _, enemy in pairs(target:GetChildren()) do
                if IsBossMatch(enemy.Name) then
                    local hum = enemy:FindFirstChild("Humanoid")
                    local root = enemy:FindFirstChild("HumanoidRootPart")
                    
                    if hum and root and hum.Health > 0 then
                        return enemy 
                    end
                end
            end
        end
        
        return nil 
    end


---------

local function CuteGetBossSpawn()
    local worldOrigin = Workspace:FindFirstChild("_WorldOrigin")
    if worldOrigin then
        local enemySpawns = worldOrigin:FindFirstChild("EnemySpawns")
        if enemySpawns then
            for _, spawnPart in pairs(enemySpawns:GetChildren()) do
                if string.find(string.lower(spawnPart.Name), string.lower(Config.TargetBossName), 1, true) then
                    return spawnPart
                end
            end
        end
    end
    return nil
end

    

---------
    local function ExecuteFarm()
        local boss = GetBoss()
        
        if boss then
            getgenv().MainTaskStatus = "FARMING BOSS"
            getgenv().SubTaskStatus = "Attacking: " .. tostring(Config.TargetBossName)
            StartAttack()
            
            while boss and boss:FindFirstChild("Humanoid") and boss.Humanoid.Health > 0 and boss.Parent do
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") and boss:FindFirstChild("HumanoidRootPart") then
                    EquipWeapon()
                    local bossRoot = boss.HumanoidRootPart
                    local targetCFrame = bossRoot.CFrame * CFrame.new(0, Config.HoverHeight, 0)
                    
                    if getgenv().TP then
                        getgenv().TP(targetCFrame)
                    end
                end
                task.wait()
            end
            
            if getgenv().stoptp then getgenv().stoptp() end
            task.wait(2)
            
            local requireApiHop = false
            if Config.TargetBossName == "Darkbeard" then
                local hasDarkFrag = false
                pcall(function()
                    local IRS = require(game:GetService("ReplicatedStorage"):WaitForChild("ItemReplicationService"))
                    local KEYS = require(game:GetService("ReplicatedStorage").ItemReplicationService.KEYS)
                    for _, item in pairs(IRS:GetItems(KEYS.QUANTITY) or {}) do
                        local ok, conf = pcall(function() return require(game:GetService("ReplicatedStorage"):WaitForChild("ItemConfig")).match(item.ItemId):unwrap() end)
                        if ok and conf and conf.Index.DebugLabel and string.find(conf.Index.DebugLabel, "Dark Fragment") then
                            if item.Value and item.Value > 0 then
                                hasDarkFrag = true
                            end
                            break
                        end
                    end
                end)
            if not hasDarkFrag then
                    requireApiHop = true
                    apiName = "Darkbeard"
                end
            elseif Config.TargetBossName == "Soul Reaper" then
                requireApiHop = true
                apiName = "SoulReaper"
            end

            if requireApiHop then
                HopToServerByAPI(apiName, 12, 2)
            else
                HopServer()
            end
        else
            getgenv().MainTaskStatus = "KILL BOSS"
            getgenv().SubTaskStatus = "Waiting for boss spawn..."
            local bossSpawn = CuteGetBossSpawn()
            local char = LocalPlayer.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            
            if bossSpawn and root then
                local distanceToSpawn = (root.Position - bossSpawn.Position).Magnitude
                
                if distanceToSpawn <= 100 then
            if Config.TargetBossName == "Darkbeard" then
                        HopToServerByAPI("Darkbeard", 12, 2)
                    elseif Config.TargetBossName == "Soul Reaper" then
                        HopToServerByAPI("SoulReaper", 12, 2)
                    else
                        HopServer()
                    end
                else
                    local targetCFrame = bossSpawn.CFrame * CFrame.new(0, Config.HoverHeight, 0)
                    
                    local foundBoss = false
                    while task.wait() do
                        if getgenv().TP then getgenv().TP(targetCFrame) end
                        
                        if GetBoss() then
                            if getgenv().stoptp then getgenv().stoptp() end
                            foundBoss = true
                            break
                        end
                        
                        local currentRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        if currentRoot and (currentRoot.Position - targetCFrame.Position).Magnitude <= 20 then
                            if getgenv().stoptp then getgenv().stoptp() end
                            break
                        end
                    end
                    
                    if foundBoss then
                        ExecuteFarm()
                    else
                        local waitStart = tick()
                        while tick() - waitStart < 5 do
                            if GetBoss() then
                                foundBoss = true
                                break
                            end
                            task.wait(0.1)
                        end

                        if foundBoss then
                            ExecuteFarm()
                        else
                            if Config.TargetBossName == "Darkbeard" then
                                HopToServerByAPI("Darkbeard", 12, 2)
                            elseif Config.TargetBossName == "Soul Reaper" then
                                HopToServerByAPI("SoulReaper", 12, 2)
                            else
                                HopServer()
                            end
                        end
                    end
                end
            else
                if Config.TargetBossName == "Darkbeard" then
                    getgenv().MainTaskStatus = "SOUL GUITAR"
                    getgenv().SubTaskStatus = "Hopping for Darkbeard"
                    HopToServerByAPI("Darkbeard", 12, 2)
                elseif Config.TargetBossName == "Soul Reaper" then
                    getgenv().MainTaskStatus = "HALLOW SCYTHE"
                    getgenv().SubTaskStatus = "Hopping for Soul Reaper"
                    HopToServerByAPI("SoulReaper", 12, 2)
                else
                    HopServer()
                end
            end
        end
    end

local function AutoFarmBoss()
    ExecuteFarm()
end

---------
    local function get_hallow_scythe()
        Config.TargetBossName = "Soul Reaper"
        
        local boss = (typeof(GetBoss) == "function" and GetBoss()) or nil
        if boss then
            getgenv().MainTaskStatus = "HALLOW SCYTHE"
            getgenv().SubTaskStatus = "Attacking Soul Reaper"
            if typeof(AutoFarmBoss) == "function" then
                AutoFarmBoss()
            elseif typeof(ExecuteFarm) == "function" then
                ExecuteFarm()
            end
        else
            getgenv().MainTaskStatus = "HALLOW SCYTHE"
            getgenv().SubTaskStatus = "Hopping for Soul Reaper"
            if typeof(HopToServerByAPI) == "function" then
                HopToServerByAPI("SoulReaper", 12, 2)
            elseif typeof(getgenv().HopToServerByAPI) == "function" then
                getgenv().HopToServerByAPI("SoulReaper", 12, 2)
            elseif typeof(HopServer) == "function" then
                HopServer()
            elseif typeof(getgenv().HopServerFunc) == "function" then
                getgenv().HopServerFunc()
            end
        end
    end
---------

local World1, World2, World3 = false, false, false
local placeId = game.PlaceId

if placeId == 2753915549 or placeId == 85211729168715 then World1 = true
elseif placeId == 4442272183 or placeId == 79091703265657 then World2 = true
elseif placeId == 7449423635 or placeId == 100117331123089 then World3 = true end



RunService.Stepped:Connect(function()
    if getgenv().AutoMaterial and plr.Character then
        for _, v in pairs(plr.Character:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end
end)



local function TweenObject(Object, Pos, Speed)
    Speed = Speed or 350
    if not Object or not Pos then return end
    local Distance = (Pos.Position - Object.Position).Magnitude
    local info = TweenInfo.new(Distance / Speed, Enum.EasingStyle.Linear)
    local tween = TweenService:Create(Object, info, {CFrame = Pos})
    tween:Play()
end



local function MoveTo(targetCFrame)
    if getgenv().TP then
        getgenv().TP(targetCFrame)
    else
        local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
        if hrp then hrp.CFrame = targetCFrame end
    end
end


local ItemReplicationService = require(RS:WaitForChild("ItemReplicationService"))
local KEYS = require(RS.ItemReplicationService.KEYS)
local ItemConfig = require(RS:WaitForChild("ItemConfig"))

local function getItemName(itemId)
    local ok, name = pcall(function()
        return ItemConfig.match(itemId):unwrap().Index.DebugLabel
    end)
    if ok and name then
        return name
    end
    return "Unknown_" .. tostring(itemId)
end

local function GetIdItem(targetName)
    local quantityItems = ItemReplicationService:GetItems(KEYS.QUANTITY)
    if not quantityItems then return nil end

    for _, item in pairs(quantityItems) do
        local rawName = getItemName(item.ItemId)
        local cleanName = string.match(rawName, "^(.-)%s*%[") or rawName
        
        if cleanName == targetName or string.find(rawName, targetName, 1, true) then
            return item.ItemId
        end
    end
    return nil
end

local function getItemCount(targetItemId)
    local quantityItems = ItemReplicationService:GetItems(KEYS.QUANTITY)
    if quantityItems then
        for _, item in pairs(quantityItems) do
            if item.ItemId == targetItemId then
                return item.Value or 0
            end
        end
    end
    return 0
end

local function CheckItem(itemName)
    if itemName == "None" or not itemName then return false, 0 end
    
    while ItemReplicationService.IsInitialized ~= true do
        task.wait()
    end
    local targetList = { itemName }
    if itemName == "Skull Guitar" or itemName == "Soul Guitar" then
        targetList = { "Soul Guitar", "Skull Guitar" }
    end
    local itemId = GetIdItem(itemName)
    if itemId then
        local count = getItemCount(itemId)
        return true, (count > 0 and count or 1)
    end
    
    return false, 0
end



local function GetMaterialData(matName)
    local MMon, MPos = {}, nil
    if World1 then
        if matName == "Angel Wings" then MMon = {"Shanda", "Royal Squad", "Royal Soldier", "Wysper", "Thunder God"} MPos = CFrame.new(-4698, 845, -1912)
        elseif matName == "Leather" or matName == "Scrap Metal" then MMon = {"Brute", "Pirate"} MPos = CFrame.new(-1145, 15, 4350)
        elseif matName == "Magma Ore" then MMon = {"Military Soldier", "Military Spy", "Magma Admiral"} MPos = CFrame.new(-5815, 84, 8820)
        elseif matName == "Fish Tail" then MMon = {"Fishman Warrior", "Fishman Commando", "Fishman Lord"} MPos = CFrame.new(61123, 19, 1569) end
    elseif World2 then
        if matName == "Leather" or matName == "Scrap Metal" then MMon = {"Marine Captain"} MPos = CFrame.new(-2010.5, 73, -3326.6)
        elseif matName == "Magma Ore" then MMon = {"Magma Ninja", "Lava Pirate"} MPos = CFrame.new(-5428, 78, -5959)
        elseif matName == "Ectoplasm" then MMon = {"Ship Deckhand", "Ship Engineer", "Ship Steward", "Ship Officer"} MPos = CFrame.new(911.3, 125.9, 33159.5)
        elseif matName == "Mystic Droplet" then MMon = {"Water Fighter"} MPos = CFrame.new(-3385, 239, -10542)
        elseif matName == "Radioactive Material" then MMon = {"Factory Staff"} MPos = CFrame.new(295, 73, -56)
        elseif matName == "Vampire Fang" then MMon = {"Vampire"} MPos = CFrame.new(-6033, 7, -1317) end
    elseif World3 then
        if matName == "Scrap Metal" then MMon = {"Jungle Pirate", "Forest Pirate"} MPos = CFrame.new(-11975.7, 331.7, -10620)
        elseif matName == "Fish Tail" then MMon = {"Fishman Raider", "Fishman Captain"} MPos = CFrame.new(-10993, 332, -8940)
        elseif matName == "Conjured Cocoa" then MMon = {"Chocolate Bar Battler", "Cocoa Warrior"} MPos = CFrame.new(620.6, 78.9, -12581.3)
        elseif matName == "Dragon Scale" then MMon = {"Dragon Crew Archer", "Dragon Crew Warrior"} MPos = CFrame.new(6594, 383, 139)
        elseif matName == "Gunpowder" then MMon = {"Pistol Billionaire"} MPos = CFrame.new(-84.8, 85.6, 6132)
        elseif matName == "Mini Tusk" then MMon = {"Mythological Pirate"} MPos = CFrame.new(-13545, 470, -6917)
        elseif matName == "Demonic Wisp" then MMon = {"Demonic Soul"} MPos = CFrame.new(-9495.6, 453.5, 5977.3)
        elseif matName == "Bones" then MMon = {"Reborn Skeleton", "Living Zombie", "Demonic Soul", "Posessed Mummy"} MPos = CFrame.new(-9495.6, 453.5, 5977.3) end
    end
    return MMon, MPos
end



local function GetMobPosition(EnemiesName)
    local pos = Vector3.zero
    local count = 0
    local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end

    for _, v in pairs(workspace.Enemies:GetChildren()) do
        if v.Name == EnemiesName and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
            if (v.HumanoidRootPart.Position - hrp.Position).Magnitude <= 0 then
                pos += v.HumanoidRootPart.Position
                count += 1
            end
        end
    end
    if count == 0 then
        return nil
    end
    return pos / count
end


local function BringMob(enable)
    if not enable then return end
    local enemies = workspace.Enemies:GetChildren()
    if #enemies == 0 then return end
    local totalpos = {}
    for _, v in pairs(enemies) do
        if not totalpos[v.Name] then
            totalpos[v.Name] = GetMobPosition(v.Name)
        end
    end
    for _, v in pairs(workspace.Enemies:GetChildren()) do
        if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
            local hrp = v.HumanoidRootPart
            local humanoid = v.Humanoid
            if humanoid.Health > 0 and (hrp.Position - plr.Character.HumanoidRootPart.Position).Magnitude <= 10 then
                local mobPos = totalpos[v.Name]
                if mobPos then
                    local TargetCFrame = CFrame.new(mobPos.X, mobPos.Y, mobPos.Z)
                    local Distance = (hrp.Position - TargetCFrame.Position).Magnitude
                    if Distance > 3 and Distance <= 10 then
                        TweenObject(hrp, TargetCFrame, 300)
                        hrp.CanCollide = false
                        if humanoid:FindFirstChild("Animator") then
                            humanoid.Animator:Destroy()
                        end
                        pcall(function()
                            sethiddenproperty(plr, "SimulationRadius", math.huge)
                        end)
                    end
                end
            end
        end
    end
end


local lastCampedSpawn = nil

local function GetEnemiesSpawn(enemyNames) 
    local worldOrigin = workspace:FindFirstChild("_WorldOrigin")
    local bestSpawn = nil
    local minDistance = math.huge
    local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
    
    if not hrp then return nil end

    if worldOrigin then
        local enemySpawns = worldOrigin:FindFirstChild("EnemySpawns")
        if enemySpawns then
            for _, spawnPart in pairs(enemySpawns:GetChildren()) do
                for _, eName in ipairs(enemyNames or {}) do
                    if string.find(spawnPart.Name, eName) then
                        if spawnPart ~= lastCampedSpawn then
                            local dist = (hrp.Position - spawnPart.Position).Magnitude
                            if dist < minDistance then
                                minDistance = dist
                                bestSpawn = spawnPart
                            end
                        end
                    end
                end
            end
        end
    end
    
    if bestSpawn then
        lastCampedSpawn = bestSpawn
    end
    
    return bestSpawn
end

local function FarmMaterialLogic(matName, targetAmount)
    StartAttack()
    getgenv().AutoMaterial = true
    getgenv().MainTaskStatus = "FARMING MATERIAL"
    getgenv().SubTaskStatus = "Gathering: " .. tostring(matName)
    task.spawn(function()
        while getgenv().AutoMaterial do
            task.wait()
            
            local char = plr.Character
            if not char or not char:FindFirstChild("Humanoid") or char.Humanoid.Health <= 0 then
                plr.CharacterAdded:Wait()
                task.wait(1)
                continue
            end

            local hasItem, currentAmount = CheckItem(matName)
            if currentAmount >= targetAmount then
                getgenv().AutoMaterial = false
                if getgenv().stoptp then getgenv().stoptp() end
                break
            end

            local MMon, MPos = GetMaterialData(matName)
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then continue end
            
            local targetMob = nil
            local closestDist = 1000
            
            for _, v in pairs(workspace.Enemies:GetChildren()) do
                local isTarget = false
                for _, en in ipairs(MMon or {}) do 
                    if v.Name == en then isTarget = true break end 
                end
                
                if isTarget and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and v:FindFirstChild("HumanoidRootPart") then
                    local dist = (v.HumanoidRootPart.Position - hrp.Position).Magnitude
                    if dist <= closestDist then
                        closestDist = dist
                        targetMob = v
                    end
                end
            end
            
            if targetMob then
                local startTime = tick()
                
                repeat
                    task.wait()
                    
                    local currentGhChar = plr.Character
                    if not currentGhChar or not currentGhChar:FindFirstChild("Humanoid") or currentGhChar.Humanoid.Health <= 0 then
                        break
                    end

                    if targetMob and targetMob:FindFirstChild("HumanoidRootPart") and targetMob:FindFirstChild("Humanoid") and targetMob.Humanoid.Health > 0 then
                        local targetCFrame = targetMob.HumanoidRootPart.CFrame * CFrame.new(0, 35, 0)
                        if getgenv().TP then
                            getgenv().TP(targetCFrame)
                        end
                    else
                        break
                    end

                    BringMob(true)
                    
                    local toolChar = plr.Character
                    if toolChar then
                        if getgenv().MasteryWeapon then
                            local tool = toolChar:FindFirstChild(getgenv().MasteryWeapon) or plr.Backpack:FindFirstChild(getgenv().MasteryWeapon)
                            if tool and tool:IsA("Tool") then
                                tool.Parent = toolChar
                            end
                        else
                            local targetTooltip = (getgenv().Config and getgenv().Config.Weapon) or "Melee"
                            local function equip(parent)
                                for _, item in pairs(parent:GetChildren()) do
                                    if item:IsA("Tool") and item.ToolTip == targetTooltip then
                                        item.Parent = toolChar
                                        return true
                                    end
                                end
                                return false
                            end
                            if not equip(toolChar) and plr.Backpack then equip(plr.Backpack) end
                        end
                    end
                    
                    hasItem, currentAmount = CheckItem(matName)
                    if currentAmount >= targetAmount or not getgenv().AutoMaterial then 
                        if getgenv().stoptp then getgenv().stoptp() end
                        break 
                    end
                    
                    if tick() - startTime > 4 then
                        break
                    end
                    
                until not targetMob or not targetMob.Parent or not targetMob:FindFirstChild("Humanoid") or targetMob.Humanoid.Health <= 0
            else
                local nextSpawn = GetEnemiesSpawn(MMon)
                if nextSpawn then
                    if getgenv().TP then getgenv().TP(nextSpawn.CFrame * CFrame.new(0, 35, 0)) end
                    task.wait()
                elseif MPos then
                    if getgenv().TP then getgenv().TP(MPos) end
                end
            end
        end
    end)
end
local function EquipItemInv(itemName)
    if itemName then
        replicated.Remotes.CommF_:InvokeServer("LoadItem", itemName)
    end
end


local function GetCurrentSea()
    local pId = game.PlaceId
    if pId == 2753915549 or pId == 85211729168715 then return 1
    elseif pId == 4442272183 or pId == 79091703265657 then return 2
    elseif pId == 7449423635 or pId == 100117331123089 then return 3 end
    return 1
end
---------
local BlankTablets = {"Segment6", 'Segment2', 'Segment8', "Segment9", 'Segment5'}
local Trophy = {["Segment1"] = "Trophy1", ["Segment3"] = "Trophy2", ['Segment4'] = "Trophy3", ['Segment7'] = "Trophy4", ["Segment10"] = "Trophy5"}
local Pipes = {['Part1'] = 'Really black', ['Part2'] = 'Really black', ["Part3"] = "Dusty Rose", ['Part4'] = "Storm blue", ['Part5'] = 'Really black', ['Part6'] = "Parsley green", ["Part7"] = 'Really black', ["Part8"] = "Dusty Rose", ["Part9"] = 'Really black', ['Part10'] = 'Storm blue'}

local function CheckFullMoon()
    return game:GetService("Lighting"):GetAttribute("MoonPhase") == 5
end

local function CheckSoulGuitarStage()
    local commF = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("CommF_")
    local success, progress = pcall(function()
        return commF:InvokeServer("GuitarPuzzleProgress", "Check")
    end)

    if not success or not progress or type(progress) ~= "table" then
        return 0
    end

    if not progress.Swamp then return 1 end
    if not progress.Gravestones then return 2 end
    if not progress.Ghost then return 3 end
    if not progress.Trophies then return 4 end
    if not progress.Pipes then return 5 end
    
    return 6
end

---------
local function AutoSoulGuitar()
    while task.wait() do
        local hasGuitar, _ = CheckItem("Skull Guitar")
        if hasGuitar then break end

        local plrData = LocalPlayer:FindFirstChild("Data")
        local level = plrData and plrData:FindFirstChild("Level") and plrData.Level.Value or 0
        local fragments = plrData and plrData:FindFirstChild("Fragments") and plrData.Fragments.Value or 0

        if fragments < 5000 or level < 2300 then break end

        local hasDarkFrag, _ = CheckItem("Dark Fragment")
        if not hasDarkFrag then
            if GetCurrentSea() ~= 2 then
                getgenv().MainTaskStatus = "SOUL GUITAR"
                getgenv().SubTaskStatus = "Travelling to Sea 2 for Dark Fragment"
                JoinSea(2)
                task.wait(10)
                return
            else
               Config.TargetBossName = "Darkbeard"
                local darkbeardFound = false
                local searchTargets = {
                    workspace:FindFirstChild("Enemies"),
                    game:GetService("ReplicatedStorage"):FindFirstChild("FortBuilderReplicatedSpawnPositionsFolder"),
                    game:GetService("ReplicatedStorage")
                }
                for _, target in pairs(searchTargets) do
                    if target then
                        for _, enemy in pairs(target:GetChildren()) do
                            if string.find(enemy.Name, "Darkbeard") then
                                local hum = enemy:FindFirstChild("Humanoid")
                                if hum and hum.Health > 0 then
                                    darkbeardFound = true
                                    break
                                end
                            end
                        end
                    end
                    if darkbeardFound then break end
                end

                if darkbeardFound then
                    getgenv().MainTaskStatus = "SOUL GUITAR"
                    getgenv().SubTaskStatus = "Attacking Darkbeard"
                    AutoFarmBoss()
                else
                    getgenv().MainTaskStatus = "SOUL GUITAR"
                    getgenv().SubTaskStatus = "Hopping for Darkbeard"
                    HopToServerByAPI("Darkbeard", 12, 2)
                end
                return
            end
        end
        
        local hasEcto, ectoCount = CheckItem("Ectoplasm")
        if ectoCount < 250 then
            if GetCurrentSea() ~= 2 then
                getgenv().MainTaskStatus = "SOUL GUITAR"
                getgenv().SubTaskStatus = "Teleporting to Sea 2 for Ectoplasm"
                JoinSea(2)
                task.wait(10)
                return
            else
                if not getgenv().AutoMaterial then
                    FarmMaterialLogic("Ectoplasm", 250)
                end
            end
            continue
        end

        if GetCurrentSea() ~= 3 then 
            getgenv().MainTaskStatus = "SOUL GUITAR"
            getgenv().SubTaskStatus = "Travelling to Sea 3"
            JoinSea(3)
            task.wait(10)
            return 
        end

        local commF = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("CommF_")
        local currentStage = CheckSoulGuitarStage()
        
        if currentStage == 0 then
            commF:InvokeServer("gravestoneEvent", 2)
            if not CheckFullMoon() then
                getgenv().MainTaskStatus = "SOUL GUITAR"
                getgenv().SubTaskStatus = "Hopping for Full Moon"
                HopToServerByAPI("FullMoon", 12, 2)
                return
            else
                local targetPos = CFrame.new(-8654.0, 140, 6167)
                local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if hrp and (hrp.Position - targetPos.Position).Magnitude > 5 then
                    MoveTo(targetPos)
                    task.wait()
                end
                commF:InvokeServer("gravestoneEvent", 2, true)
                task.wait(5)
            end
---------
elseif currentStage == 1 then
        getgenv().TTL9 = getgenv().TTL9 or 0
        getgenv().LastestTime1 = getgenv().LastestTime1 or os.time()
        if os.time() ~= getgenv().LastestTime1 then
            getgenv().TTL9 = getgenv().TTL9 + 1
            getgenv().LastestTime1 = os.time()
        end
        
        if getgenv().TTL9 > 90 then 
            HopServer() 
            return 
        end
        
        local zombieList = {}
        for _, obj in pairs(workspace.Enemies:GetChildren()) do
            if obj.Name == "Living Zombie" and obj:FindFirstChild("Humanoid") and obj.Humanoid.Health > 0 then 
                table.insert(zombieList, obj) 
            end
        end
        
        if #zombieList == 0 then
            getgenv().SyncKillingZombies = false
        end
        
        local killPos = Vector3.new(-10172.2529, 138.6893, 6002.4512)
        local standCFrame = CFrame.new(killPos) * CFrame.new(0, 35, 0)
        
        if #zombieList < 6 and not getgenv().SyncKillingZombies then
            getgenv().MainTaskStatus = "SOUL GUITAR"
            getgenv().SubTaskStatus = "Task 1/5: Waiting for Living Zombies (" .. #zombieList .. "/6)"
            MoveTo(standCFrame)
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.Velocity = Vector3.zero
                hrp.CFrame = standCFrame
            end
        else
            getgenv().MainTaskStatus = "SOUL GUITAR"
            
            local Net = game:GetService("ReplicatedStorage"):FindFirstChild("Modules") and game:GetService("ReplicatedStorage").Modules:FindFirstChild("Net")
            local regAttack = (Remotes and Remotes["RE/RegisterAttack"]) or (Net and Net:FindFirstChild("RE/RegisterAttack"))
            local regHit = (Remotes and Remotes["RE/RegisterHit"]) or (Net and Net:FindFirstChild("RE/RegisterHit"))
            
            for _, zombie in pairs(zombieList) do
                local root = zombie:FindFirstChild("HumanoidRootPart")
                local hum = zombie:FindFirstChild("Humanoid")
                if root and hum and hum.Health > 0 then
                    root.CFrame = CFrame.new(killPos)
                    root.CanCollide = false
                    if hum:FindFirstChild("Animator") then
                        hum.Animator:Destroy()
                    end
                    pcall(function() sethiddenproperty(LocalPlayer, "SimulationRadius", math.huge) end)
                end
            end
            
            MoveTo(standCFrame)
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp and (hrp.Position - standCFrame.Position).Magnitude <= 20 then
                local bv = hrp:FindFirstChild("FreezeBV") or Instance.new("BodyVelocity")
                bv.Name = "FreezeBV"
                bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
                bv.Velocity = Vector3.zero
                bv.Parent = hrp
                hrp.CFrame = standCFrame
            end
            
            EquipWeapon()
            
            table.sort(zombieList, function(a, b)
                local hA = a:FindFirstChild("Humanoid") and a.Humanoid.Health or 0
                local hB = b:FindFirstChild("Humanoid") and b.Humanoid.Health or 0
                return hA > hB
            end)

            local mobsAbove, allBelowThreshold = {}, true
            for _, m in ipairs(zombieList) do
                local hum = m:FindFirstChild("Humanoid")
                if hum and hum.Health > 0 then
                    if (hum.Health / hum.MaxHealth) * 100 > 30 then
                        if #mobsAbove < 2 then table.insert(mobsAbove, m) end
                        allBelowThreshold = false
                    end
                end
            end
            
            if allBelowThreshold then
                getgenv().SyncKillingZombies = true
            end

            local targetGroup = getgenv().SyncKillingZombies and zombieList or mobsAbove
            local hitTable, primaryHead = {}, nil
            for _, mob in ipairs(targetGroup) do
                local head = mob:FindFirstChild("Head") or mob:FindFirstChild("HumanoidRootPart")
                if head then
                    if not primaryHead then primaryHead = head end
                    table.insert(hitTable, {mob, head})
                end
            end

            if primaryHead and #hitTable > 0 then
                local net = RS:FindFirstChild("Modules") and RS.Modules:FindFirstChild("Net")
                local regAttack = (net and net:FindFirstChild("RE/RegisterAttack")) or RS:FindFirstChild("RE/RegisterAttack", true)
                local regHit = (net and net:FindFirstChild("RE/RegisterHit")) or RS:FindFirstChild("RE/RegisterHit", true)

                if regAttack then pcall(function() regAttack:FireServer(-math.huge) end) end
                if not getgenv().SyncKillingZombies then
                    getgenv().SubTaskStatus = "Task 1/5: Balancing health down to 30%"
                    if regHit then pcall(function() regHit:FireServer(primaryHead, hitTable) end) end
                    task.wait(0.2)
                else
                    getgenv().SubTaskStatus = "Task 1/5: Sync Killing All Zombies!"
                    for i = 1, 15 do
                        if regHit then pcall(function() regHit:FireServer(primaryHead, hitTable) end) end
                    end
                    task.wait(0.1)
                end
            end
        end
---------
        elseif currentStage == 2 then
            getgenv().MainTaskStatus = "SOUL GUITAR"
            getgenv().SubTaskStatus = "Task 2/5: Completing placards"
            local W = workspace.Map:FindFirstChild("Haunted Castle")
            if W then
                local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    while (hrp.Position - Vector3.new(-8800.0, 178, 6033)).Magnitude > 10 do
                        task.wait()
                        MoveTo(CFrame.new(-8800.0, 178, 6033))
                    end
                    for h, X in pairs({Placard1 = "Right", Placard2 = "Right", Placard3 = "Left", Placard4 = 'Right', Placard5 = 'Left', Placard6 = 'Left', Placard7 = "Left"}) do
                        if W:FindFirstChild(h) and W[h]:FindFirstChild(X) and W[h][X]:FindFirstChild("ClickDetector") then
                            fireclickdetector(W[h][X].ClickDetector)
                        end
                    end
                    task.wait(5)
                end
            end
        elseif currentStage == 3 then
            commF:InvokeServer("GuitarPuzzleProgress", "Ghost")
            task.wait(5)
        elseif currentStage == 4 then
            getgenv().MainTaskStatus = "SOUL GUITAR"
            getgenv().SubTaskStatus = "Task 4/5: Completing Trophies"
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                while (hrp.Position - Vector3.new(-9530.0126953125, 6.104853630065918, 6054.83349609375)).Magnitude > 30 do
                    task.wait()
                    MoveTo(CFrame.new(-9530.0126953125, 6.104853630065918, 6054.83349609375))
                end
                local W = workspace.Map:FindFirstChild("Haunted Castle")
                if W and W:FindFirstChild("Tablet") then
                    for _, h in pairs(BlankTablets) do
                        local X = W.Tablet:FindFirstChild(h)
                        if X and X:FindFirstChild("Line") and X.Line.Rotation.Z ~= 0 then
                            repeat 
                                task.wait() 
                                if X:FindFirstChild("ClickDetector") then
                                    fireclickdetector(X.ClickDetector)
                                end
                            until X.Line.Rotation.Z == 0
                        end
                    end
                    for h, X in pairs(Trophy) do
                        if W:FindFirstChild("Trophies") and W.Trophies:FindFirstChild("Quest") and W.Trophies.Quest:FindFirstChild(X) then
                            local w = tostring(W.Trophies.Quest[X].Handle.CFrame)
                            w = w:split(", ")[4]
                            local targetZ = "180"
                            if w == "1" or w == "-1" then targetZ = "90" end
                            
                            local tabObj = W.Tablet:FindFirstChild(h)
                            if tabObj and tabObj:FindFirstChild("Line") and not string.find(tostring(tabObj.Line.Rotation.Z), targetZ) then
                                repeat 
                                    task.wait() 
                                    if tabObj:FindFirstChild("ClickDetector") then
                                        fireclickdetector(tabObj.ClickDetector)
                                    end
                                until string.find(tostring(tabObj.Line.Rotation.Z), targetZ)
                            end
                        end
                    end
                    task.wait(5)
                end
            end
        elseif currentStage == 5 then
            getgenv().MainTaskStatus = "SOUL GUITAR"
            getgenv().SubTaskStatus = "Task 5/5: Connecting Pipes"
            local W = workspace.Map:FindFirstChild("Haunted Castle")
            if W and W:FindFirstChild("Lab Puzzle") and W["Lab Puzzle"]:FindFirstChild("ColorFloor") and W["Lab Puzzle"].ColorFloor:FindFirstChild("Model") then
                for pKey, pColor in pairs(Pipes) do
                    pcall(function()
                        local X = W['Lab Puzzle'].ColorFloor.Model:FindFirstChild(pKey)
                        if X and X.BrickColor.Name ~= pColor then
                            repeat 
                                task.wait() 
                                if X:FindFirstChild("ClickDetector") then
                                    fireclickdetector(X.ClickDetector)
                                end
                            until X.BrickColor.Name == pColor
                        end
                    end)
                end
            end
            commF:InvokeServer('soulGuitarBuy')
            task.wait(5)
        elseif currentStage == 6 then
            local hasBones, bonesCount = CheckItem("Bones")
            if bonesCount >= 500 then
                commF:InvokeServer('soulGuitarBuy')
                task.wait(5)
            else
                if not getgenv().AutoMaterial then
                    FarmMaterialLogic("Bones", 500)
                end
            end
        end
    end
end
---------
---------
---------
local function getItemMastery(itemName)
    local targetItemId = nil
    if type(itemName) == "number" then
        targetItemId = itemName
    elseif type(itemName) == "string" then
        targetItemId = GetIdItem(itemName)
    end

    if not targetItemId then return 0 end

    local masteryItems = ItemReplicationService:GetItems(KEYS.MASTERY)
    if masteryItems then
        for _, item in pairs(masteryItems) do
            if item.ItemId == targetItemId then
                return item.Value or 0
            end
        end
    end
    return 0
end

local function _3SwordLegend()
    local missingSwords = {}
    if not CheckItem("Shizu") then table.insert(missingSwords, "swordshizu") end
    if not CheckItem("Oroshi") then table.insert(missingSwords, "swordoroshi") end
    if not CheckItem("Saishi") then table.insert(missingSwords, "swordsaishi") end

    if #missingSwords > 0 then
        if GetCurrentSea() ~= 2 then
            getgenv().MainTaskStatus = "3 SWORD LEGEND"
            getgenv().SubTaskStatus = "Travelling to Sea 2"
            JoinSea(2)
            task.wait(10)
            return true
        end
        
        getgenv().MainTaskStatus = "3 SWORD LEGEND"
        getgenv().SubTaskStatus = "Hopping for Swords: " .. tostring(#missingSwords)
        
        local allCached = true
        for _, hopKey in ipairs(missingSwords) do
            local status = HopToServerByAPI(hopKey, 12, 2)
            if status == true then 
                allCached = false
                return true
            elseif status == "ALL_CACHED" then
                continue
            else
                allCached = false
                return true
            end
        end
        
        if allCached then
            getgenv().SubTaskStatus = "All caches full! Resetting histories..."
            for _, hopKey in ipairs(missingSwords) do
                SaveHistory(hopKey, {}) 
            end
        end
        return true
    end

    local legendSwords = {"Shizu", "Oroshi", "Saishi"}
    local targetSword = nil

    for _, sword in ipairs(legendSwords) do
        local mas = getItemMastery(sword)
        if mas and mas < 300 then
            targetSword = sword
            break
        end
    end

    if targetSword then
        getgenv().MasteryWeapon = targetSword 
        local args = {
            "LoadItem",
            targetSword
        }
        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer(unpack(args))
        
        local allOtherDone = true
        for _, seaData in ipairs(getgenv().Config) do
            if type(seaData) == "table" and seaData.Weapons then
                for _, wName in ipairs(seaData.Weapons) do
                    local isLegend = false
                    for _, ls in ipairs(legendSwords) do
                        if wName == ls then isLegend = true break end
                    end
                    if not isLegend and wName ~= "True Triple Katana" then
                        local hasItem, _ = CheckItem(wName)
                        if not hasItem then
                            allOtherDone = false
                            break
                        end
                    end
                end
            end
            if not allOtherDone then break end
        end
        
        if allOtherDone then
            if GetCurrentSea() ~= 3 then
                getgenv().MainTaskStatus = "3 SWORD LEGEND"
                getgenv().SubTaskStatus = "Travelling to Sea 3 for Mastery"
                JoinSea(3)
                task.wait(10)
                return true
            end

            getgenv().MainTaskStatus = "FARMING MASTERY"
            getgenv().SubTaskStatus = targetSword .. " Mastery Fallback"
            Config.TargetBossName = "Beautiful Pirate" 
            AutoFarmBoss()
            return true
        else
            return false
        end
    else
        getgenv().MasteryWeapon = nil 
        
        if not CheckItem("True Triple Katana") then
            if GetCurrentSea() ~= 2 then
                getgenv().MainTaskStatus = "3 SWORD LEGEND"
                getgenv().SubTaskStatus = "Travelling to Sea 2 for True Triple Katana"
                JoinSea(2)
                task.wait(10)
                return true
            end
            
            getgenv().MainTaskStatus = "3 SWORD LEGEND"
            getgenv().SubTaskStatus = "Getting True Triple Katana"
            

            local targetPos = CFrame.new(-2572.5742, 1624.5582, -3744.1216)
            local char = LocalPlayer.Character or plr.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local hrp = char.HumanoidRootPart
                if (hrp.Position - targetPos.Position).Magnitude > 10 then
                    MoveTo(targetPos)
                else
            if getgenv().stoptp then getgenv().stoptp() end
                    pcall(function()
                        local commF = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("CommF_")
                        local args1 = {
                            "MysteriousMan",
                            "1"
                        }
                        commF:InvokeServer(unpack(args1))
                        
                        task.wait(0.5)
                        
                        local args2 = {
                            "MysteriousMan",
                            "2"
                        }
                        commF:InvokeServer(unpack(args2))
                    end)
                    task.wait(1)
                end
            else
                MoveTo(targetPos)
            end

            return true
        end
        return false
    end
end

local function get_tushita()
    while task.wait(1) do
        local hasItem, _ = CheckItem("Tushita")
        if hasItem then
            break
        end

        local plrData = LocalPlayer:FindFirstChild("Data")
        local level = plrData and plrData:FindFirstChild("Level") and plrData.Level.Value or 0
        if level < 2000 then return end

        if GetCurrentSea() ~= 3 then
            getgenv().MainTaskStatus = "TUSHITA"
            getgenv().SubTaskStatus = "Travelling to Sea 3"
            JoinSea(3)
            task.wait(10)
            return
        end

        local TushitaProgress = replicated.Remotes.CommF_:InvokeServer("TushitaProgress")

        if type(TushitaProgress) == "table" and not TushitaProgress.OpenedDoor then
            Config.TargetBossName = "rip_indra True Form"
            local indra = GetBoss()

            if not indra then
                getgenv().MainTaskStatus = "TUSHITA"
                getgenv().SubTaskStatus = "Hopping for Rip Indra"
                HopToServerByAPI("ripindra", 12, 2)
                return
            else
                getgenv().MainTaskStatus = "TUSHITA"
                getgenv().SubTaskStatus = "Placing Torches"
                local targetPos = CFrame.new(5714, 20, 256)
                if getgenv().TP then
                    getgenv().TP(targetPos)
                else
                    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then hrp.CFrame = targetPos end
                end

                local hasTorch = false
                if LocalPlayer.Backpack:FindFirstChild("Holy Torch") or (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Holy Torch")) then
                    hasTorch = true
                end

                if hasTorch then
                    for W = 1, 5 do
                        replicated.Remotes.CommF_:InvokeServer("TushitaProgress", "Torch", W)
                        task.wait(0.5)
                    end
                end
            end
        else
            Config.TargetBossName = "Longma"
            local longma = GetBoss()
            if longma then
                getgenv().MainTaskStatus = "TUSHITA"
                getgenv().SubTaskStatus = "Defeating Longma"
                AutoFarmBoss()
            else
                HopServer()
                return
            end
        end
    end
end

local function checkBisentoVersion()
    local isV2 = LocalPlayer:GetAttribute("BisentoEvolution")
    
    if isV2 then
        print("Bisento: V2")
        return "V2"
    else
        print("Bisento: V1")
        return "V1"
    end
end

local function GetGreybeardRespawnTime()
    local ws = game:GetService("Workspace")
    local worldOrigin = ws:FindFirstChild("_WorldOrigin")
    if not worldOrigin then
        return nil
    end
    
    local marker = worldOrigin:FindFirstChild("GREYBEARD Respawn Marker")
    if not marker then
        return nil
    end
    
    local respawnTimer = marker:FindFirstChild("RespawnTimer")
    if respawnTimer then
        local frame = respawnTimer:FindFirstChild("Frame")
        if frame then
            local timerLabel = frame:FindFirstChild("Timer")
            if timerLabel and timerLabel:IsA("TextLabel") then
                local rawText = timerLabel.Text
                
                local cleanText = string.gsub(rawText, "<[^>]+>", "")
                cleanText = string.gsub(cleanText, "%s+", "")
                
                local hourStr, minStr, secStr = string.match(cleanText, "(%d+):(%d+):(%d+)")
                if hourStr and minStr and secStr then
                    local hours = tonumber(hourStr)
                    local minutes = tonumber(minStr)
                    local seconds = tonumber(secStr)
                    return (hours * 3600) + (minutes * 60) + seconds
                end
                
                local mStr, sStr = string.match(cleanText, "(%d+):(%d+)")
                if mStr and sStr then
                    local minutes = tonumber(mStr)
                    local seconds = tonumber(sStr)
                    return (minutes * 60) + seconds
                end
                
                local singleNumber = tonumber(string.match(cleanText, "%d+"))
                if singleNumber then
                    return singleNumber
                end
            end
        end
    end
    
    return nil
end

local function get_bisento_v2()
    Config.TargetBossName = "Greybeard"
    
    local boss = GetBoss()
    if not boss then
        local timeLeft = GetGreybeardRespawnTime()
        if timeLeft and timeLeft <= 900 then
            while task.wait(1) do
                local t = GetGreybeardRespawnTime()
                if GetBoss() then 
                    break 
                end
                
                if t then
                    getgenv().MainTaskStatus = "WAITING BOSS SPAWN TIME < 15Min"
                    getgenv().SubTaskStatus = "Greybeard spawns in: " .. tostring(t) .. "s"
                else
                    break
                end
            end
        end
    end
    EquipItemInv("Bisento")
    AutoFarmBoss()
    task.wait(1)
    if checkBisentoVersion() == "V2" then
        print("Bisento has evolved to V2!")
    end
end
---------
---------
local function get_saber()
    while true do
        local hasSaber, _ = CheckItem("Saber")
        if hasSaber then
            break
        end

        local plrData = LocalPlayer:FindFirstChild("Data")
        local level = plrData and plrData:FindFirstChild("Level") and plrData.Level.Value or 0
        if level < 200 then
            break
        end

        if GetCurrentSea() ~= 1 then
            getgenv().MainTaskStatus = "SABER QUEST"
            getgenv().SubTaskStatus = "Travelling to Sea 1"
            JoinSea(1)
            task.wait(10)
            return
        end

        local commF = replicated:WaitForChild("Remotes"):WaitForChild("CommF_")
        local progress = commF:InvokeServer("ProQuestProgress")
        
        local stage = 0
        if type(progress) == "table" then
            local allPlates = true
            if type(progress.Plates) == "table" then
                for _, pressed in pairs(progress.Plates) do
                    if pressed == false then
                        allPlates = false
                        break
                    end
                end
            else
                allPlates = false
            end

            if not allPlates then
                stage = 1
            elseif not progress.UsedTorch then
                stage = 2
            elseif not progress.UsedCup then
                stage = 3
            elseif not progress.TalkedSon then
                stage = 4
            elseif not progress.KilledMob then
                stage = 5
            elseif not progress.UsedRelic then
                stage = 6
            elseif not progress.KilledShanks then
                stage = 7
            end
        end

        if stage == 1 then
            getgenv().MainTaskStatus = "SABER QUEST"
            getgenv().SubTaskStatus = "Touching Quest Plates"
            local jungleMap = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Jungle")
            if jungleMap and jungleMap:FindFirstChild("QuestPlates") then
                for _, plate in pairs(jungleMap.QuestPlates:GetChildren()) do
                    local btn = plate:FindFirstChild("Button")
                    if btn then
                        local char = LocalPlayer.Character
                        local hrp = char and char:FindFirstChild("HumanoidRootPart")
                        if hrp then
                            while (hrp.Position - btn.Position).Magnitude > 5 do
                                MoveTo(btn.CFrame)
                                task.wait()
                                hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                                if not hrp then break end
                            end
                            task.wait(0.5)
                        end
                    end
                end
            end
            task.wait(1)
        elseif stage == 2 then
            getgenv().MainTaskStatus = "SABER QUEST"
            getgenv().SubTaskStatus = "Using Torch"
            commF:InvokeServer("ProQuestProgress", "GetTorch")
            task.wait(1)
            commF:InvokeServer("ProQuestProgress", "DestroyTorch")
            task.wait(1)
        elseif stage == 3 then
            getgenv().MainTaskStatus = "SABER QUEST"
            getgenv().SubTaskStatus = "Filling Cup for Sick Man"
            commF:InvokeServer("ProQuestProgress", "GetCup")
            task.wait(0.5)
            
            local char = LocalPlayer.Character
            local cupTool = LocalPlayer.Backpack:FindFirstChild("Cup") or (char and char:FindFirstChild("Cup"))
            if cupTool and char and char:FindFirstChild("Humanoid") then
                char.Humanoid:EquipTool(cupTool)
                task.wait(0.5)
                commF:InvokeServer("ProQuestProgress", "FillCup", cupTool)
                task.wait(0.5)
            end
            commF:InvokeServer("ProQuestProgress", "SickMan")
            task.wait(1)
        elseif stage == 4 then
            getgenv().MainTaskStatus = "SABER QUEST"
            getgenv().SubTaskStatus = "Talking to Rich Son"
            commF:InvokeServer("ProQuestProgress", "RichSon")
            task.wait(1)
        elseif stage == 5 then
            getgenv().MainTaskStatus = "SABER QUEST"
            getgenv().SubTaskStatus = "Defeating Mob Leader"
            Config.TargetBossName = "Mob Leader"
            AutoFarmBoss()
            task.wait(1)
        elseif stage == 6 then
            getgenv().MainTaskStatus = "SABER QUEST"
            getgenv().SubTaskStatus = "Placing Relic"
            commF:InvokeServer("ProQuestProgress", "RichSon")
            task.wait(1)
            commF:InvokeServer("ProQuestProgress", "PlaceRelic")
            task.wait(1)

        elseif stage == 7 then
            Config.TargetBossName = "Saber Expert"
            local boss = GetBoss()
            if boss then
                getgenv().MainTaskStatus = "SABER QUEST"
                getgenv().SubTaskStatus = "Defeating Saber Expert"
                AutoFarmBoss()
            else
                getgenv().MainTaskStatus = "SABER QUEST"
                getgenv().SubTaskStatus = "Hopping for Saber Expert"
                if type(HopServer) == "function" then
                    HopServer()
                elseif type(getgenv().HopServerFunc) == "function" then
                    getgenv().HopServerFunc()
                end
                return
            end
        end
        task.wait(1)
    end
end

local function StartKaitunWeapons()
    task.spawn(function()
        while task.wait() do
            for _, seaData in ipairs(getgenv().Config) do
                if type(seaData) == "table" and seaData.Weapons then
                    for _, weaponName in ipairs(seaData.Weapons) do
                        local hasItem, _ = CheckItem(weaponName)
                        getgenv().MainTaskStatus = "WEAPON TRACKER"
                        getgenv().SubTaskStatus = "Checking: " .. tostring(weaponName)
                        if weaponName == "Saber" and not hasItem then
                            get_saber()
                            return
                        end
                        if weaponName == "Tushita" and not hasItem then
                            get_tushita()
                            return
                        end
                        if weaponName == "Skull Guitar" and not hasItem then
                            AutoSoulGuitar()
                            return
                        end
                        if weaponName == "Bisento" and hasItem and checkBisentoVersion() == "V1" then
                            local bossData = BossDrops["Bisento"]
                            if bossData then
                                if GetCurrentSea() ~= bossData.Sea then
                                    JoinSea(bossData.Sea)
                                    task.wait()
                                    return
                                else
                                    get_bisento_v2()
                                    return
                                end
                            end
                        end

                    if weaponName == "Hallow Scythe" and not hasItem then
                            local bossData = BossDrops["Hallow Scythe"]
                            if bossData then
                                if GetCurrentSea() ~= bossData.Sea then
                                    JoinSea(bossData.Sea)
                                    task.wait()
                                    return
                                else
                                    get_hallow_scythe()
                                    return
                                end
                            end
                        end

                        if weaponName == "Shizu" or weaponName == "Oroshi" or weaponName == "Saishi" or weaponName == "True Triple Katana" then
                            local hasShizu = CheckItem("Shizu")
                            local hasOroshi = CheckItem("Oroshi")
                            local hasSaishi = CheckItem("Saishi")

                            local masShizu = getItemMastery("Shizu")
                            local masOroshi = getItemMastery("Oroshi")
                            local masSaishi = getItemMastery("Saishi")

                            local needLegend = (not hasShizu) or (not hasOroshi) or (not hasSaishi) or (hasShizu and masShizu < 300) or (hasOroshi and masOroshi < 300) or (hasSaishi and masSaishi < 300)

                            if needLegend then
                                local isBlocking = _3SwordLegend()
                                if isBlocking then return end
                            elseif weaponName == "True Triple Katana" and not hasItem then
                                local isBlocking = _3SwordLegend()
                                if isBlocking then return end
                            end
                            
                        elseif not hasItem then
                            local bossData = BossDrops[weaponName]
                            if bossData then
                                print("Target Weapon: " .. weaponName)
                                if GetCurrentSea() ~= bossData.Sea then
                                    JoinSea(bossData.Sea)
                                    task.wait() 
                                    return
                                else
                                    Config.TargetBossName = bossData.Boss
                                    AutoFarmBoss()
                                    return 
                                end
                            end
                        end
                    end
                end
            end
        end
    end)
end
---------

StartKaitunWeapons()


local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

getgenv().MainTaskStatus = "INITIALIZING..."
getgenv().SubTaskStatus = "Loading Hub System..."

local Theme = {
    Background = Color3.fromRGB(15, 15, 15),
    Darker = Color3.fromRGB(8, 8, 8),
    ContainerBg = Color3.fromHex("#1A1A1A"),
    ContainerTrans = 0.5,
    Text = Color3.fromHex("#FFFFFF"),
    TextDim = Color3.fromHex("#808080"),
    Active = Color3.fromHex("#888888"),
    TextGrad = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromHex("#FFFFFF")),
        ColorSequenceKeypoint.new(0.5, Color3.fromHex("#A0A0A0")),
        ColorSequenceKeypoint.new(1, Color3.fromHex("#1A1A1A"))
    }),
    StrokeGrad = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(50, 50, 50)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
    })
}

local AllWeaponsList = {
    "Soul Cane", "Bisento", "Dual-Headed Blade", "Pipe", "Cutlass", "Dual Katana", "Katana",
    "Iron Mace", "Triple Katana", "Slingshot", "Cannon", "Refined Slingshot", "Flintlock",
    "Dual Flintlock", "Musket", "Bizarre Rifle", "Buddy Sword", "Twin Hooks", "Canvander", "Venom Bow",
    "Longsword", "Gravity Blade", "Dragon Trident", "Flail", "Wardens Sword", "Magma Blaster", "Bazooka",
    "Pole (1st Form)", "Trident", "Skull Guitar", "Shizu", "Oroshi", "True Triple Katana", "Saishi",
    "Hallow Scythe", "Tushita", "Saber"
}


local KaitunGui = Instance.new("ScreenGui")
KaitunGui.Name = "MeyyWeaponHub"
KaitunGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
KaitunGui.ResetOnSpawn = false

if gethui then
    KaitunGui.Parent = gethui()
else
    KaitunGui.Parent = CoreGui
end

local function MakeDraggable(topbar, object)
    local dragging, dragInput, dragStart, startPos

    local function update(input)
        local delta = input.Position - dragStart
        local newPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        TweenService:Create(object, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Position = newPos}):Play()
    end

    topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = object.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then 
                    dragging = false 
                end
            end)
        end
    end)

    topbar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then 
            dragInput = input 
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then 
            update(input) 
        end
    end)
end

local function CreateButtonEffects(button)
    local scale = Instance.new("UIScale")
    scale.Scale = 1
    scale.Parent = button

    button.MouseEnter:Connect(function()
        TweenService:Create(scale, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Scale = 1.05}):Play()
    end)

    button.MouseLeave:Connect(function()
        TweenService:Create(scale, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Scale = 1}):Play()
    end)

    button.MouseButton1Down:Connect(function()
        TweenService:Create(scale, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Scale = 0.8}):Play()
    end)

    button.MouseButton1Up:Connect(function()
        local t1 = TweenService:Create(scale, TweenInfo.new(0.15, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out), {Scale = 1.3})
        t1:Play()
        t1.Completed:Connect(function()
            TweenService:Create(scale, TweenInfo.new(0.15, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out), {Scale = 1}):Play()
        end)
    end)
end

local function ApplyTextGradient(obj)
    obj.TextColor3 = Theme.Text
    local grad = Instance.new("UIGradient", obj)
    grad.Rotation = 90
    grad.Color = Theme.TextGrad
    
    local shadow = Instance.new("UIStroke")
    shadow.Color = Theme.Darker
    shadow.Thickness = 0.5
    shadow.Transparency = 0
    shadow.Parent = obj
    
    return grad
end

local ToggleContainer = Instance.new("Frame")
ToggleContainer.Name = "ToggleContainer"
ToggleContainer.Size = UDim2.new(0, 60, 0, 30)
ToggleContainer.Position = UDim2.new(0, 15, 0, 15)
ToggleContainer.BackgroundColor3 = Theme.Darker
ToggleContainer.BackgroundTransparency = 0.4
ToggleContainer.BorderSizePixel = 0
ToggleContainer.Parent = KaitunGui

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(1, 0)
ToggleCorner.Parent = ToggleContainer

local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Color = Color3.fromRGB(255, 255, 255)
ToggleStroke.Thickness = 1.5
ToggleStroke.Parent = ToggleContainer

local ToggleGrad = Instance.new("UIGradient")
ToggleGrad.Color = Theme.StrokeGrad
ToggleGrad.Parent = ToggleStroke

local ToggleBall = Instance.new("Frame")
ToggleBall.Size = UDim2.new(0, 22, 0, 22)
ToggleBall.Position = UDim2.new(0, 34, 0.5, -11)
ToggleBall.BackgroundColor3 = Theme.Text
ToggleBall.Parent = ToggleContainer
Instance.new("UICorner", ToggleBall).CornerRadius = UDim.new(1, 0)

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(1, 0, 1, 0)
ToggleBtn.BackgroundTransparency = 1
ToggleBtn.Text = ""
ToggleBtn.Parent = ToggleContainer

MakeDraggable(ToggleContainer, ToggleContainer)

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 420, 0, 220)
MainFrame.Position = UDim2.new(0.5, -210, 0.5, -110)
MainFrame.BackgroundColor3 = Theme.Background
MainFrame.BackgroundTransparency = 0.3
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = false
MainFrame.Parent = KaitunGui

local MainGroup = Instance.new("CanvasGroup")
MainGroup.Size = UDim2.new(1, 0, 1, 0)
MainGroup.BackgroundTransparency = 1
MainGroup.Parent = MainFrame

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(255, 255, 255)
MainStroke.Thickness = 1.5
MainStroke.Parent = MainFrame

local MainStrokeGrad = Instance.new("UIGradient")
MainStrokeGrad.Color = Theme.StrokeGrad
MainStrokeGrad.Parent = MainStroke

MakeDraggable(MainFrame, MainFrame)

local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 35)
Header.BackgroundTransparency = 1
Header.Parent = MainGroup

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 250, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "WEAPON TRACKER HUB"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 12
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header
ApplyTextGradient(Title)

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 20, 0, 20)
CloseBtn.Position = UDim2.new(1, -25, 0.5, -10)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Theme.TextDim
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 12
CloseBtn.Parent = Header
CreateButtonEffects(CloseBtn)

local HDivider = Instance.new("Frame")
HDivider.Size = UDim2.new(1, -20, 0, 1)
HDivider.Position = UDim2.new(0, 10, 0, 35)
HDivider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
HDivider.BorderSizePixel = 0
HDivider.Parent = MainGroup

local HDivGrad = Instance.new("UIGradient")
HDivGrad.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 1),
    NumberSequenceKeypoint.new(0.5, 0.2),
    NumberSequenceKeypoint.new(1, 1)
})
HDivGrad.Parent = HDivider

local ProgressCard = Instance.new("Frame")
ProgressCard.Size = UDim2.new(1, -20, 0, 75)
ProgressCard.Position = UDim2.new(0, 10, 0, 45)
ProgressCard.BackgroundColor3 = Theme.ContainerBg
ProgressCard.BackgroundTransparency = Theme.ContainerTrans
ProgressCard.Parent = MainGroup
Instance.new("UICorner", ProgressCard).CornerRadius = UDim.new(0, 8)

local ProgStroke = Instance.new("UIStroke", ProgressCard)
ProgStroke.Color = Theme.Text
ProgStroke.Thickness = 1
local ProgStrokeGrad = Instance.new("UIGradient", ProgStroke)
ProgStrokeGrad.Color = Theme.StrokeGrad

local ProgTitle = Instance.new("TextLabel")
ProgTitle.Size = UDim2.new(1, 0, 0, 20)
ProgTitle.Position = UDim2.new(0, 15, 0, 10)
ProgTitle.BackgroundTransparency = 1
ProgTitle.Text = "TOTAL WEAPONS OWNED"
ProgTitle.Font = Enum.Font.GothamBold
ProgTitle.TextSize = 10
ProgTitle.TextColor3 = Theme.TextDim
ProgTitle.TextXAlignment = Enum.TextXAlignment.Left
ProgTitle.Parent = ProgressCard

local ProgValue = Instance.new("TextLabel")
ProgValue.Size = UDim2.new(0, 150, 0, 30)
ProgValue.Position = UDim2.new(0, 15, 0, 30)
ProgValue.BackgroundTransparency = 1
ProgValue.Text = "0 / " .. tostring(#AllWeaponsList)
ProgValue.Font = Enum.Font.GothamBold
ProgValue.TextSize = 22
ProgValue.TextXAlignment = Enum.TextXAlignment.Left
ProgValue.Parent = ProgressCard
ApplyTextGradient(ProgValue)

local MissingValue = Instance.new("TextLabel")
MissingValue.Size = UDim2.new(0, 150, 0, 30)
MissingValue.Position = UDim2.new(1, -165, 0, 30)
MissingValue.BackgroundTransparency = 1
MissingValue.Text = "Missing: 0"
MissingValue.Font = Enum.Font.GothamBold
MissingValue.TextSize = 14
MissingValue.TextXAlignment = Enum.TextXAlignment.Right
MissingValue.Parent = ProgressCard
ApplyTextGradient(MissingValue)

local StatusCard = Instance.new("Frame")
StatusCard.Size = UDim2.new(1, -20, 0, 75)
StatusCard.Position = UDim2.new(0, 10, 0, 130)
StatusCard.BackgroundColor3 = Theme.ContainerBg
StatusCard.BackgroundTransparency = Theme.ContainerTrans
StatusCard.Parent = MainGroup
Instance.new("UICorner", StatusCard).CornerRadius = UDim.new(0, 8)

local StatStroke = Instance.new("UIStroke", StatusCard)
StatStroke.Color = Theme.Text
StatStroke.Thickness = 1
local StatStrokeGrad = Instance.new("UIGradient", StatStroke)
StatStrokeGrad.Color = Theme.StrokeGrad

local StatTitle = Instance.new("TextLabel")
StatTitle.Size = UDim2.new(1, 0, 0, 20)
StatTitle.Position = UDim2.new(0, 15, 0, 10)
StatTitle.BackgroundTransparency = 1
StatTitle.Text = "CURRENT STATUS"
StatTitle.Font = Enum.Font.GothamBold
StatTitle.TextSize = 10
StatTitle.TextColor3 = Theme.TextDim
StatTitle.TextXAlignment = Enum.TextXAlignment.Left
StatTitle.Parent = StatusCard

local MainTaskLbl = Instance.new("TextLabel")
MainTaskLbl.Size = UDim2.new(1, -30, 0, 20)
MainTaskLbl.Position = UDim2.new(0, 15, 0, 30)
MainTaskLbl.BackgroundTransparency = 1
MainTaskLbl.Text = "Main: " .. getgenv().MainTaskStatus
MainTaskLbl.Font = Enum.Font.GothamBold
MainTaskLbl.TextSize = 13
MainTaskLbl.TextXAlignment = Enum.TextXAlignment.Left
MainTaskLbl.Parent = StatusCard
ApplyTextGradient(MainTaskLbl)

local SubTaskLbl = Instance.new("TextLabel")
SubTaskLbl.Size = UDim2.new(1, -30, 0, 15)
SubTaskLbl.Position = UDim2.new(0, 15, 0, 50)
SubTaskLbl.BackgroundTransparency = 1
SubTaskLbl.Text = "Sub: " .. getgenv().SubTaskStatus
SubTaskLbl.Font = Enum.Font.GothamBold
SubTaskLbl.TextSize = 11
SubTaskLbl.TextColor3 = Theme.TextDim
SubTaskLbl.TextXAlignment = Enum.TextXAlignment.Left
SubTaskLbl.Parent = StatusCard



local isMainVisible = true
ToggleBtn.MouseButton1Click:Connect(function()
    isMainVisible = not isMainVisible
    if isMainVisible then
        MainFrame.Visible = true
        TweenService:Create(ToggleBall, TweenInfo.new(0.2, Enum.EasingStyle.Sine), {Position = UDim2.new(0, 34, 0.5, -11)}):Play()
        TweenService:Create(ToggleContainer, TweenInfo.new(0.2, Enum.EasingStyle.Sine), {BackgroundColor3 = Theme.Darker}):Play()
        TweenService:Create(MainGroup, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {GroupTransparency = 0}):Play()
        TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, -210, 0.5, -110)}):Play()
    else
        TweenService:Create(ToggleBall, TweenInfo.new(0.2, Enum.EasingStyle.Sine), {Position = UDim2.new(0, 4, 0.5, -11)}):Play()
        TweenService:Create(ToggleContainer, TweenInfo.new(0.2, Enum.EasingStyle.Sine), {BackgroundColor3 = Theme.Active}):Play()
        local t = TweenService:Create(MainGroup, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {GroupTransparency = 1})
        TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Position = UDim2.new(0.5, -210, 0.5, -90)}):Play()
        t:Play()
        t.Completed:Connect(function()
            if not isMainVisible then 
                MainFrame.Visible = false 
            end
        end)
    end
end)

CloseBtn.MouseButton1Click:Connect(function()
    KaitunGui:Destroy()
end)

RunService.RenderStepped:Connect(function()
    local t = tick()
    ToggleGrad.Rotation = (t * 100) % 360
    MainStrokeGrad.Rotation = (t * 100) % 360
    ProgStrokeGrad.Rotation = (t * 100) % 360
    StatStrokeGrad.Rotation = (t * 100) % 360

    MainTaskLbl.Text = "Main: " .. tostring(getgenv().MainTaskStatus)
    SubTaskLbl.Text = "Sub: " .. tostring(getgenv().SubTaskStatus)
end)
---------
local WeaponUI_API = {
    SetOwned = function(val, total)
        if ProgValue and ProgValue.Text ~= (tostring(val) .. " / " .. tostring(total)) then
            ProgValue.Text = tostring(val) .. " / " .. tostring(total)
        end
    end,
    SetMissing = function(val)
        if MissingValue and MissingValue.Text ~= ("Missing: " .. tostring(val)) then
            MissingValue.Text = "Missing: " .. tostring(val)
        end
    end
}

task.spawn(function()
    while ItemReplicationService.IsInitialized ~= true do
        task.wait()
    end

    local lastOwned = -1
    local total = #AllWeaponsList

    while task.wait(1) do
        local countOwned = 0
        
        for _, weaponName in ipairs(AllWeaponsList) do
            local hasItem, _ = CheckItem(weaponName)
            if hasItem then
                countOwned = countOwned + 1
            end
        end

        if countOwned ~= lastOwned then
            lastOwned = countOwned
            local missing = total - countOwned
            local curOwned = countOwned

            task.defer(function()
                WeaponUI_API.SetOwned(curOwned, total)
                WeaponUI_API.SetMissing(missing)
            end)
        end
    end
end)
---------
