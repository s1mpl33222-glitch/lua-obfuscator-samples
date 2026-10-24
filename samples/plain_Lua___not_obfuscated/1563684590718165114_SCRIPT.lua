if _G.Heartagram then
    return
end

_G.Heartagram = true
p = game.Players.LocalPlayer
ps = game:GetService('Players')
RunService = game:GetService('RunService')
TweenService = game:GetService('TweenService')
ReplicatedStorage = game:GetService('ReplicatedStorage')
UIElements = {}
_G.ConfigRegistry = {}
getgenv().ConfigRegistry = _G.ConfigRegistry
isafEnabled = false
isagbEnabled = false
isFarmingCoins = false
noclipConnection = nil
currentTween = nil
originalPartProperties = {}
farmingActive = false
CurrentCoinType = 'Candy'
allCoinsCollected = false
currentCoinsCollected = 0
maxCoinsInRound = 0
FlingActive = false
SelectedFlingTarget = nil
getgenv().OldPos = nil
getgenv().FPDH = workspace.FallenPartsDestroyHeight

local function setupCharacterCollision(a)
    local function disableCollide(b)
        if isafEnabled and b:IsA('BasePart') then
            b.CanCollide = false
        end
    end

    for b, c in ipairs(a:GetChildren())do
        disableCollide(c)
    end

    local b, c = a.ChildAdded:Connect(disableCollide), RunService.Stepped:Connect(function()
        if isafEnabled and a:IsDescendantOf(workspace) then
            for b, c in ipairs(a:GetChildren())do
                if c:IsA('BasePart') and c.CanCollide then
                    c.CanCollide = false
                end
            end
        end
    end)

    a.Destroying:Connect(function()
        b:Disconnect()
        c:Disconnect()
    end)
end
local function trackPlayer(a)
    if a == p then
        return
    end

    local b = a.CharacterAdded:Connect(setupCharacterCollision)

    if a.Character then
        setupCharacterCollision(a.Character)
    end
end

for a, b in ipairs(ps:GetPlayers())do
    trackPlayer(b)
end

ps.PlayerAdded:Connect(trackPlayer)

UserInputService = game:GetService('UserInputService')
success, Library = pcall(function()
        return loadstring(game:HttpGet('https://raw.githubusercontent.com/tontov/ScriptLibrary/refs/heads/main/Main'))()
end)

if not success then
    return
end

Window = Library:CreateWindow({
    Title = '???',
    Theme = 'Light',
    Size = UDim2.fromOffset(570, 370),
    Transparency = 0.1,
    Blurring = true,
    MinimizeKeybind = Enum.KeyCode.LeftAlt,
})
Themes = {
    Light = {
        Primary = Color3.fromRGB(232, 232, 232),
        Secondary = Color3.fromRGB(255, 255, 255),
        Component = Color3.fromRGB(245, 245, 245),
        Interactables = Color3.fromRGB(235, 235, 235),
        Tab = Color3.fromRGB(50, 50, 50),
        Title = Color3.fromRGB(0, 0, 0),
        Description = Color3.fromRGB(100, 100, 100),
        Shadow = Color3.fromRGB(255, 255, 255),
        Outline = Color3.fromRGB(210, 210, 210),
        Icon = Color3.fromRGB(100, 100, 100),
    },
    Dark = {
        Primary = Color3.fromRGB(30, 30, 30),
        Secondary = Color3.fromRGB(35, 35, 35),
        Component = Color3.fromRGB(40, 40, 40),
        Interactables = Color3.fromRGB(45, 45, 45),
        Tab = Color3.fromRGB(200, 200, 200),
        Title = Color3.fromRGB(240, 240, 240),
        Description = Color3.fromRGB(200, 200, 200),
        Shadow = Color3.fromRGB(0, 0, 0),
        Outline = Color3.fromRGB(40, 40, 40),
        Icon = Color3.fromRGB(220, 220, 220),
    },
    Void = {
        Primary = Color3.fromRGB(15, 15, 15),
        Secondary = Color3.fromRGB(20, 20, 20),
        Component = Color3.fromRGB(25, 25, 25),
        Interactables = Color3.fromRGB(30, 30, 30),
        Tab = Color3.fromRGB(200, 200, 200),
        Title = Color3.fromRGB(240, 240, 240),
        Description = Color3.fromRGB(200, 200, 200),
        Shadow = Color3.fromRGB(0, 0, 0),
        Outline = Color3.fromRGB(40, 40, 40),
        Icon = Color3.fromRGB(220, 220, 220),
    },
    Purple = {
        Primary = Color3.fromRGB(30, 20, 40),
        Secondary = Color3.fromRGB(40, 25, 50),
        Component = Color3.fromRGB(50, 30, 65),
        Interactables = Color3.fromRGB(70, 40, 90),
        Tab = Color3.fromRGB(200, 180, 255),
        Title = Color3.fromRGB(230, 210, 255),
        Description = Color3.fromRGB(180, 160, 220),
        Shadow = Color3.fromRGB(15, 10, 20),
        Outline = Color3.fromRGB(90, 60, 120),
        Icon = Color3.fromRGB(200, 170, 255),
    },
}

Window:SetTheme(Themes.Light)

MainTab = Window:AddTab({
    Title = 'Combat',
    Icon = 'rbxassetid://11963373994',
})

Window:AddSection({
    Name = 'Murder Functions',
    Tab = MainTab,
})

autoKillAllEnabled = false
UIElements.autoKillAllToggle = Window:AddToggle({
    Title = 'Auto Kill All',
    Description = 'Automatically kill all players when you are murderer',
    Default = false,
    Tab = MainTab,
    Callback = function(a)
        autoKillAllEnabled = a
    end,
})

Window:AddButton({
    Title = 'Kill All',
    Description = 'Kill All Innocents',
    Tab = MainTab,
    Callback = function()
        if not p then
            return
        end

        local a = p.Character

        if not a or not a.Parent then
            return
        end

        local b = a:FindFirstChild('Knife')

        if not b then
            b = p.Backpack:FindFirstChild('Knife')

            if b then
                b.Parent = a
            else
                Window:Notify({
                    Title = 'No Knife',
                    Description = 'You need to be the murderer!',
                    Duration = 3,
                })

                return
            end
        end

        for c, d in pairs(game.Players:GetPlayers())do
            if d ~= p and d.Character and d.Character:FindFirstChild('Head') then
                pcall(function()
                    b.Events.KnifeStabbed:FireServer()
                    b.Events.HandleTouched:FireServer(d.Character.Head)
                end)
                task.wait(0.05)
            end
        end

        Window:Notify({
            Title = 'Kill All',
            Description = 'Attempted to kill all players',
            Duration = 2,
        })
    end,
})

selectedPlayerToKill = 'None'
killSelectedPlayerDropdown = nil
waitingForKnifeLoop = nil

local function getPlayerList()
    local a = {}

    for b, c in ipairs(ps:GetPlayers())do
        if c ~= p then
            table.insert(a, c.Name)
        end
    end

    if #a == 0 then
        return {
            'No players',
        }
    end

    return a
end
local function killSelectedPlayer()
    if selectedPlayerToKill == 'None' or selectedPlayerToKill == 'No players' then
        Window:Notify({
            Title = 'No Player Selected',
            Description = 'Select a player from the dropdown first',
            Duration = 3,
        })

        return
    end

    local a = ps:FindFirstChild(selectedPlayerToKill)

    if not a or not a.Character or not a.Character:FindFirstChild('Head') then
        Window:Notify({
            Title = 'Invalid Target',
            Description = 'Player not found or dead',
            Duration = 3,
        })

        return
    end
    if not p then
        return
    end

    local b = p.Character

    if not b or not b.Parent then
        return
    end

    local c, d = RolesPlrName['Murderer'] == p, b:FindFirstChild('Knife')

    if not d then
        d = p.Backpack:FindFirstChild('Knife')

        if d then
            d.Parent = b
        else
            if c then
                Window:Notify({
                    Title = 'Waiting for Knife',
                    Description = 'Waiting for knife to appear...',
                    Duration = 2,
                })

                if waitingForKnifeLoop then
                    waitingForKnifeLoop = false
                end

                waitingForKnifeLoop = true

                task.spawn(function()
                    local e = waitingForKnifeLoop

                    while e and waitingForKnifeLoop do
                        task.wait(0.1)

                        if RolesPlrName['Murderer'] ~= p then
                            waitingForKnifeLoop = false

                            Window:Notify({
                                Title = 'Role Changed',
                                Description = 'No longer murderer, stopped waiting',
                                Duration = 2,
                            })

                            return
                        end

                        local f = p.Character

                        if not f then
                            waitingForKnifeLoop = false

                            return
                        end

                        local g = f:FindFirstChild('Knife') or p.Backpack:FindFirstChild('Knife')

                        if g then
                            if g.Parent == p.Backpack then
                                g.Parent = f
                            end

                            local h = ps:FindFirstChild(selectedPlayerToKill)

                            if h and h.Character and h.Character:FindFirstChild('Head') then
                                pcall(function()
                                    g.Events.KnifeStabbed:FireServer()
                                    g.Events.HandleTouched:FireServer(h.Character.Head)
                                end)
                                Window:Notify({
                                    Title = 'Kill Selected',
                                    Description = 'Killed ' .. selectedPlayerToKill,
                                    Duration = 2,
                                })
                            end

                            waitingForKnifeLoop = false

                            return
                        end
                    end
                end)

                return
            else
                Window:Notify({
                    Title = 'No Knife',
                    Description = 'You need to be the murderer!',
                    Duration = 3,
                })

                return
            end
        end
    end

    pcall(function()
        d.Events.KnifeStabbed:FireServer()
        d.Events.HandleTouched:FireServer(a.Character.Head)
    end)
    Window:Notify({
        Title = 'Kill Selected',
        Description = 'Attempted to kill ' .. selectedPlayerToKill,
        Duration = 2,
    })
end
local function refreshPlayerDropdown()
    if killSelectedPlayerDropdown then
        killSelectedPlayerDropdown.Refresh(getPlayerList())
    end
end

killSelectedPlayerDropdown = Window:AddSingleSelect({
    Title = 'Kill Selected Player',
    Description = 'Select a player to kill',
    Options = getPlayerList(),
    Default = 'None',
    Tab = MainTab,
    Callback = function(a)
        selectedPlayerToKill = a

        killSelectedPlayer()
    end,
})

ps.PlayerAdded:Connect(refreshPlayerDropdown)
ps.PlayerRemoving:Connect(refreshPlayerDropdown)
task.spawn(function()
    while true do
        task.wait(0.5)

        if autoKillAllEnabled and p and p.Character then
            local a = p.Character:FindFirstChild('Knife') or p.Backpack:FindFirstChild('Knife')

            if a then
                if a.Parent == p.Backpack then
                    a.Parent = p.Character
                end

                for b, c in pairs(game.Players:GetPlayers())do
                    if c ~= p and c.Character and c.Character:FindFirstChild('Head') then
                        pcall(function()
                            a.Events.KnifeStabbed:FireServer()
                            a.Events.HandleTouched:FireServer(c.Character.Head)
                        end)
                        task.wait(0.05)
                    end
                end
            end
        end
    end
end)
Window:AddSection({
    Name = 'Sheriff Functions',
    Tab = MainTab,
})

autoShootEnabled = false
predictionMultiplier = 2.5
magicBulletEnabled = false
magicBulletToolConnection = nil
disabledGunClients = {}
gunMonitorConnections = {}

local function getPing()
    local a = game:GetService('Stats').Network.ServerStatsItem['Data Ping']:GetValue()

    return a
end

PlayerData = game.ReplicatedStorage.Remotes.Extras.GetPlayerData
PlayerDataChanged = game.ReplicatedStorage.Remotes.Gameplay.PlayerDataChanged
RolesPlrName = {
    ['Sheriff'] = false,
    ['Murderer'] = false,
    ['Innocent'] = false,
    ['Hero'] = false,
}

PlayerDataChanged.OnClientEvent:Connect(function(a)
    for b, c in a do
        local d = game.Players:FindFirstChild(b)

        if d then
            RolesPlrName[c.Role] = d
        end
    end
end)

for a, b in PlayerData:InvokeServer()do
    local c = game.Players:FindFirstChild(a)

    if c then
        RolesPlrName[b.Role] = c
    end
end

local function disableGunClient(a)
    if not a then
        return
    end

    local b = a:FindFirstChild('GunClient')

    if b and b:IsA('LocalScript') then
        if b.Enabled then
            b.Enabled = false
            disabledGunClients[a] = b
        end
    end
end
local function enableGunClient(a)
    if not a then
        return
    end

    local b = disabledGunClients[a]

    if b and b:IsA('LocalScript') then
        b.Enabled = true
        disabledGunClients[a] = nil
    else
        local c = a:FindFirstChild('GunClient')

        if c and c:IsA('LocalScript') and not c.Enabled then
            c.Enabled = true
        end
    end
end
local function createPredictionBeam()
    if predictionBeam then
        return predictionBeam
    end

    local a, b = game:GetService('Workspace'), Instance.new('Part')

    b.Name = 'BeamPart0'
    b.Anchored = true
    b.CanCollide = false
    b.Transparency = 1
    b.Size = Vector3.new(0.1, 0.1, 0.1)
    b.Parent = a

    local c = Instance.new('Part')

    c.Name = 'BeamPart1'
    c.Anchored = true
    c.CanCollide = false
    c.Transparency = 1
    c.Size = Vector3.new(0.1, 0.1, 0.1)
    c.Parent = a

    local d = Instance.new('Attachment')

    d.Name = 'BeamAttachment0'
    d.Parent = b

    local e = Instance.new('Attachment')

    e.Name = 'BeamAttachment1'
    e.Parent = c

    local f = Instance.new('Beam')

    f.Name = 'PredictionBeam'
    f.FaceCamera = true
    f.Width0 = 0.2
    f.Width1 = 0.2
    f.Color = ColorSequence.new(Color3.fromRGB(255, 0, 0))
    f.Transparency = NumberSequence.new(0.5)
    f.LightEmission = 1
    f.LightInfluence = 0
    f.Attachment0 = d
    f.Attachment1 = e
    f.Parent = b
    predictionBeam = {
        Beam = f,
        Attachment0 = d,
        Attachment1 = e,
        Part0 = b,
        Part1 = c,
    }

    return predictionBeam
end
local function updatePredictionBeam(a, b)
    if not predictionBeam then
        createPredictionBeam()
    end
    if predictionBeam.Part0 and predictionBeam.Part1 then
        predictionBeam.Part0.Position = a
        predictionBeam.Part1.Position = b
    end
end

predictionVisualizationConnection = nil

local function startPredictionVisualization()
    if predictionVisualizationConnection then
        return
    end

    createPredictionBeam()

    predictionVisualizationConnection = RunService.RenderStepped:Connect(function()
        if not magicBulletEnabled then
            return
        end

        local a = RolesPlrName['Murderer']

        if not a or not a.Character or not a.Character:FindFirstChild('HumanoidRootPart') then
            return
        end

        local b, c = a.Character.HumanoidRootPart, getPing()
        local d, e = (c / 1000) * predictionMultiplier, b.Velocity
        local f, g = e.Magnitude, nil

        if f < 1 then
            local h = b.CFrame.LookVector * 2

            g = b.Position + h
        else
            g = b.Position + (e * d)
        end

        updatePredictionBeam(b.Position, g)
    end)
end
local function stopPredictionVisualization()
    if predictionVisualizationConnection then
        predictionVisualizationConnection:Disconnect()

        predictionVisualizationConnection = nil
    end
end
local function magicBulletShoot(a)
    if not a then
        return
    end

    local b = RolesPlrName['Murderer']

    if not b or not b.Character or not b.Character:FindFirstChild('HumanoidRootPart') then
        return
    end

    local c, d = b.Character.HumanoidRootPart, getPing()
    local e, f = (d / 1000) * predictionMultiplier, c.Velocity
    local g, h = f.Magnitude, nil

    if g < 1 then
        local i = c.CFrame.LookVector * 2

        h = c.Position + i
    else
        local i = 1 + (g / 50)
        local j = e * i

        h = c.Position + (f * j)
    end

    local i, j = c.Position, c.CFrame.LookVector
    local k = i - (j * 1)
    local l, m, n = CFrame.new(k.X, k.Y, k.Z), CFrame.new(h.X, h.Y, h.Z), a:FindFirstChild('Shoot')

    if n and n:IsA('RemoteEvent') then
        n:FireServer(l, m)
    else
    end
end
local function setupMagicBulletTool(a)
    if not a or not a:IsA('Tool') then
        return
    end
    if magicBulletToolConnection then
        magicBulletToolConnection:Disconnect()

        magicBulletToolConnection = nil
    end

    magicBulletToolConnection = a.Activated:Connect(function()
        if magicBulletEnabled then
            magicBulletShoot(a)
        end
    end)
end
local function enableMagicBullet()
    if p.Character then
        local a = p.Character:FindFirstChild('Gun')

        if a then
            disableGunClient(a)
            setupMagicBulletTool(a)
        end
    end
    if p.Backpack then
        local a = p.Backpack:FindFirstChild('Gun')

        if a then
            disableGunClient(a)
            setupMagicBulletTool(a)
        end
    end
end
local function monitorGunAppearance()
    local a

    a = p.CharacterAdded:Connect(function(b)
        if not magicBulletEnabled then
            return
        end

        local c

        c = b.ChildAdded:Connect(function(d)
            if d.Name == 'Gun' and d:IsA('Tool') and magicBulletEnabled then
                task.wait(0.1)
                disableGunClient(d)
                setupMagicBulletTool(d)
            end
        end)

        table.insert(gunMonitorConnections, c)
    end)

    table.insert(gunMonitorConnections, a)

    if p.Backpack then
        local b

        b = p.Backpack.ChildAdded:Connect(function(c)
            if c.Name == 'Gun' and c:IsA('Tool') and magicBulletEnabled then
                task.wait(0.1)
                disableGunClient(c)
                setupMagicBulletTool(c)
            end
        end)

        table.insert(gunMonitorConnections, b)
    end
end
local function stopGunMonitoring()
    for a, b in pairs(gunMonitorConnections)do
        if b then
            b:Disconnect()
        end
    end

    gunMonitorConnections = {}
end
local function disableMagicBullet()
    if magicBulletToolConnection then
        magicBulletToolConnection:Disconnect()

        magicBulletToolConnection = nil
    end

    stopGunMonitoring()

    for a, b in pairs(disabledGunClients)do
        enableGunClient(a)
    end

    disabledGunClients = {}

    monitorGunAppearance()
end

monitorGunAppearance()

local function autoShootMurderer()
    local a = nil

    if p.Character and p.Character:FindFirstChild('Gun') then
        a = p.Character.Gun
    elseif p.Backpack and p.Backpack:FindFirstChild('Gun') then
        a = p.Backpack.Gun
        a.Parent = p.Character

        task.wait(0.05)
    end
    if not a or a.Parent ~= p.Character then
        return
    end

    local b = RolesPlrName['Murderer']

    if not b or not b.Character or not b.Character:FindFirstChild('HumanoidRootPart') then
        return
    end

    local c, d = b.Character.HumanoidRootPart, getPing()
    local e, f = (d / 1000) * predictionMultiplier, c.Velocity
    local g, h = f.Magnitude, nil

    if g < 1 then
        local i = c.CFrame.LookVector * 2

        h = c.Position + i
    else
        local i = 1 + (g / 50)
        local j = e * i

        h = c.Position + (f * j)
    end

    local i, j = c.Position, c.CFrame.LookVector
    local k = i - (j * 1)
    local l, m, n = CFrame.new(k.X, k.Y, k.Z), CFrame.new(h.X, h.Y, h.Z), a:FindFirstChild('Shoot')

    if n and n:IsA('RemoteEvent') then
        n:FireServer(l, m)
    end
end

UIElements.autoShootToggle = Window:AddToggle({
    Title = 'Auto Shoot Murderer',
    Description = 'Automatically shoot the murderer',
    Default = false,
    Tab = MainTab,
    Callback = function(a)
        autoShootEnabled = a
    end,
})

task.spawn(function()
    while true do
        task.wait(0.1)

        if autoShootEnabled then
            autoShootMurderer()
        end
    end
end)

UIElements.magicBulletToggle = Window:AddToggle({
    Title = 'Magic Bullet',
    Description = 'Shoot from murderer position with prediction (disables GunClient)',
    Default = false,
    Tab = MainTab,
    Callback = function(a)
        magicBulletEnabled = a

        if a then
            enableMagicBullet()
            Window:Notify({
                Title = 'Magic Bullet Enabled',
                Description = 'GunClient disabled, using Tool.Activated',
                Duration = 3,
            })
        else
            disableMagicBullet()
            Window:Notify({
                Title = 'Magic Bullet Disabled',
                Description = 'GunClient restored',
                Duration = 2,
            })
        end
    end,
})

Window:AddSection({
    Name = 'Innocent Functions',
    Tab = MainTab,
})

UIElements.autoGrabGunToggle = Window:AddToggle({
    Title = 'Auto Grab Gun',
    Description = 'Automatically grabbing gun if sheriff died',
    Default = false,
    Tab = MainTab,
    Callback = function(a)
        isagbEnabled = a
    end,
})
LocalPlayerTab = Window:AddTab({
    Title = 'LocalPlayer',
    Icon = 'rbxassetid://11963373994',
})
UIElements.antiFlingToggle = Window:AddToggle({
    Title = 'Anti-Fling',
    Description = 'Prevents other players from flinging you',
    Tab = LocalPlayerTab,
    Callback = function(a)
        isafEnabled = a
    end,
})

Window:AddSection({
    Name = 'Void Hide',
    Tab = LocalPlayerTab,
})

VoidHideSettings = {
    Enabled = false,
    UpdateRate = 0.1,
    VoidChangeRate = 0.06,
    VoidHeight = 9e9 - 1000,
    OffsetX = 20,
    OffsetZ = 20,
    RandomVoidPosition = true,
    VoidRangeMin = 100000000,
    VoidRangeMax = 1000000000,
    VoidHeightMin = 100000000,
    VoidHeightMax = 1000000000,
}
VoidHideSpoofedProperties = {}
VoidHideRealPosition = CFrame.new()
VoidHideLastVoid = tick()
showVoidPositionEnabled = false
voidPositionMarker = nil
VoidHideLastVoidChange = tick()
VoidHideCurrentVoidPosition = nil
VoidHideInVoid = false
VoidHideOldNewIndex = nil
VoidHideOldIndex = nil

local function RandomLargeNumber(a, b)
    local c, d, e = b - a, math.random(0, 999999), math.random(0, 999)
    local f = a + (d + e * 1000000) % c

    return f
end
local function InitializeVoidHide()
    if VoidHideOldIndex then
        return
    end

    local a = p.Character
    local b = a and a:FindFirstChild('HumanoidRootPart')

    if not b then
        return
    end

    VoidHideSpoofedProperties[b] = {}
    VoidHideOldIndex = hookmetamethod(game, '__index', function(c, d)
        if not checkcaller() and c and d then
            local e = VoidHideSpoofedProperties[c]

            if e and e[d] ~= nil then
                return e[d]
            end
        end

        return VoidHideOldIndex(c, d)
    end)
    VoidHideOldNewIndex = hookmetamethod(game, '__newindex', function(c, d, e)
        if not checkcaller() and c and d and e then
            local f = VoidHideSpoofedProperties[c]

            if f and d == 'CFrame' then
                f[d] = e

                if VoidHideSettings.Enabled then
                    return
                end
            end
        end

        return VoidHideOldNewIndex(c, d, e)
    end)
end
local function VoidSpamFunction(a, b)
    if not VoidHideSettings.Enabled then
        VoidHideInVoid = false
        VoidHideCurrentVoidPosition = nil

        return
    end
    if not b or not b.Parent then
        return
    end

    local c = tick()

    if not VoidHideCurrentVoidPosition or (c - VoidHideLastVoidChange) >= VoidHideSettings.VoidChangeRate then
        if VoidHideSettings.RandomVoidPosition then
            local d, e, f = RandomLargeNumber(VoidHideSettings.VoidRangeMin, VoidHideSettings.VoidRangeMax), RandomLargeNumber(VoidHideSettings.VoidHeightMin, VoidHideSettings.VoidHeightMax), RandomLargeNumber(VoidHideSettings.VoidRangeMin, VoidHideSettings.VoidRangeMax)

            if math.random() > 0.5 then
                d = -d
            end
            if math.random() > 0.5 then
                f = -f
            end

            VoidHideCurrentVoidPosition = CFrame.new(d, e, f)
        else
            VoidHideCurrentVoidPosition = CFrame.new(VoidHideRealPosition.Position - Vector3.new(math.random(-VoidHideSettings.OffsetX, VoidHideSettings.OffsetX), VoidHideSettings.VoidHeight, math.random(-VoidHideSettings.OffsetZ, VoidHideSettings.OffsetZ)))
        end

        VoidHideLastVoidChange = c
    end
    if c - VoidHideLastVoid > VoidHideSettings.UpdateRate and not VoidHideInVoid then
        VoidHideInVoid = true

        task.delay(VoidHideSettings.UpdateRate, function()
            VoidHideLastVoid = c
            VoidHideInVoid = false
        end)
    end
    if VoidHideInVoid then
        VoidHideRealPosition = VoidHideOldIndex(b, 'CFrame')

        local d = VoidHideOldIndex(b, 'Velocity')

        VoidHideSpoofedProperties[b]['CFrame'] = VoidHideRealPosition

        VoidHideOldNewIndex(b, 'CFrame', VoidHideCurrentVoidPosition)
        RunService.RenderStepped:Wait()
        VoidHideOldNewIndex(b, 'CFrame', VoidHideRealPosition)
        VoidHideOldNewIndex(b, 'Velocity', d)
    else
        if VoidHideSpoofedProperties[b]['CFrame'] then
            VoidHideSpoofedProperties[b]['CFrame'] = nil
        end
    end
end

VoidHideConnection = nil
voidTracerGui = nil
voidTracerImage = nil
voidHighlight = nil

local function createVoidPositionMarker()
    if voidPositionMarker then
        voidPositionMarker:Destroy()

        voidPositionMarker = nil
    end
    if voidTracerGui then
        voidTracerGui:Destroy()

        voidTracerGui = nil
        voidTracerImage = nil
    end
    if voidHighlight then
        voidHighlight:Destroy()

        voidHighlight = nil
    end
    if not showVoidPositionEnabled or not VoidHideSettings.Enabled then
        return
    end

    voidPositionMarker = Instance.new('Part')
    voidPositionMarker.Name = 'VoidPositionMarker'
    voidPositionMarker.Size = Vector3.new(3, 6, 3)
    voidPositionMarker.Anchored = true
    voidPositionMarker.CanCollide = false
    voidPositionMarker.Transparency = 0.7
    voidPositionMarker.Color = Color3.fromRGB(255, 0, 0)
    voidPositionMarker.Material = Enum.Material.Neon
    voidPositionMarker.Parent = workspace

    local a = Instance.new('BillboardGui')

    a.Name = 'VoidMarkerBillboard'
    a.Size = UDim2.new(5, 0, 5, 0)
    a.AlwaysOnTop = true
    a.Adornee = voidPositionMarker
    a.Parent = voidPositionMarker

    local b = Instance.new('ImageLabel')

    b.Size = UDim2.new(1, 0, 1, 0)
    b.BackgroundTransparency = 1
    b.Image = 'rbxassetid://116203675006105'
    b.Parent = a
    voidHighlight = Instance.new('Highlight')
    voidHighlight.Name = 'VoidHighlight'
    voidHighlight.FillColor = Color3.fromRGB(255, 0, 0)
    voidHighlight.FillTransparency = 0.5
    voidHighlight.OutlineColor = Color3.fromRGB(255, 255, 0)
    voidHighlight.OutlineTransparency = 0
    voidHighlight.Adornee = voidPositionMarker
    voidHighlight.Parent = voidPositionMarker
    voidTracerGui = Instance.new('ScreenGui')
    voidTracerGui.Name = 'VoidTracerGui'
    voidTracerGui.ResetOnSpawn = false
    voidTracerGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    voidTracerGui.Parent = game:GetService('CoreGui')
    voidTracerImage = Instance.new('ImageLabel')
    voidTracerImage.Name = 'VoidTracerImage'
    voidTracerImage.Size = UDim2.new(0, 64, 0, 64)
    voidTracerImage.Position = UDim2.new(0.5, -32, 0.5, -32)
    voidTracerImage.BackgroundTransparency = 1
    voidTracerImage.Image = 'rbxassetid://116203675006105'
    voidTracerImage.ImageTransparency = 0
    voidTracerImage.ZIndex = 10
    voidTracerImage.Parent = voidTracerGui
end

UIElements.voidHideToggle = Window:AddToggle({
    Title = 'Void Hide',
    Description = 'Hide in the void to avoid being hit (server sees you in void, client sees you normally)',
    Default = false,
    Tab = LocalPlayerTab,
    Callback = function(a)
        VoidHideSettings.Enabled = a

        if a then
            InitializeVoidHide()

            if not VoidHideConnection then
                VoidHideConnection = RunService.Heartbeat:Connect(function(b)
                    local c = p.Character
                    local d = c and c:FindFirstChild('HumanoidRootPart')

                    if not d or not d.Parent then
                        local e, f = pcall(function()
                            c = p.Character

                            if c then
                                d = c:WaitForChild('HumanoidRootPart', 1)

                                if d then
                                    VoidHideSpoofedProperties[d] = {}
                                end
                            end
                        end)

                        return
                    end

                    pcall(VoidSpamFunction, b, d)
                end)
            end
            if showVoidPositionEnabled then
                createVoidPositionMarker()
            end

            Window:Notify({
                Title = 'Void Hide Enabled',
                Description = 'You appear in void to the server, but normal to your client',
                Duration = 3,
            })
        else
            if VoidHideConnection then
                VoidHideConnection:Disconnect()

                VoidHideConnection = nil
            end

            VoidHideInVoid = false
            VoidHideCurrentVoidPosition = nil

            if voidPositionMarker then
                voidPositionMarker:Destroy()

                voidPositionMarker = nil
            end
            if voidTracerGui then
                voidTracerGui:Destroy()

                voidTracerGui = nil
                voidTracerImage = nil
            end
            if voidHighlight then
                voidHighlight:Destroy()

                voidHighlight = nil
            end

            local b = p.Character
            local c = b and b:FindFirstChild('HumanoidRootPart')

            if c and VoidHideSpoofedProperties[c] then
                VoidHideSpoofedProperties[c]['CFrame'] = nil
            end

            Window:Notify({
                Title = 'Void Hide Disabled',
                Description = 'Normal position restored',
                Duration = 2,
            })
        end
    end,
})

Window:AddToggle({
    Title = 'Show VoidHide Position',
    Description = 'Show your real server position with an image marker',
    Default = false,
    Tab = LocalPlayerTab,
    Callback = function(a)
        showVoidPositionEnabled = a

        if a then
            createVoidPositionMarker()
        else
            if voidPositionMarker then
                voidPositionMarker:Destroy()

                voidPositionMarker = nil
            end
            if voidTracerGui then
                voidTracerGui:Destroy()

                voidTracerGui = nil
                voidTracerImage = nil
            end
            if voidHighlight then
                voidHighlight:Destroy()

                voidHighlight = nil
            end
        end
    end,
})
RunService.Heartbeat:Connect(function()
    if not showVoidPositionEnabled or not VoidHideSettings.Enabled then
        if voidPositionMarker and not showVoidPositionEnabled then
            voidPositionMarker:Destroy()

            voidPositionMarker = nil
        end
        if voidTracerGui and not showVoidPositionEnabled then
            voidTracerGui:Destroy()

            voidTracerGui = nil
            voidTracerImage = nil
        end
        if voidHighlight and not showVoidPositionEnabled then
            voidHighlight:Destroy()

            voidHighlight = nil
        end

        return
    end
    if not voidPositionMarker or not voidTracerImage then
        return
    end
    if VoidHideCurrentVoidPosition then
        voidPositionMarker.CFrame = VoidHideCurrentVoidPosition

        local a, b = workspace.CurrentCamera, VoidHideCurrentVoidPosition.Position
        local c, d = a:WorldToViewportPoint(b)

        if d then
            local e = 64
            local f = e / 2

            voidTracerImage.Position = UDim2.new(0, c.X - f, 0, c.Y - f)
            voidTracerImage.Visible = true
        else
            voidTracerImage.Visible = false
        end
    else
        voidTracerImage.Visible = false
    end
end)
p.CharacterAdded:Connect(function(a)
    task.wait(0.5)

    local b = a:WaitForChild('HumanoidRootPart')

    if b and VoidHideSettings.Enabled then
        VoidHideSpoofedProperties[b] = {}

        if VoidHideConnection then
            VoidHideConnection:Disconnect()
        end

        VoidHideConnection = RunService.Heartbeat:Connect(function(c)
            local d = p.Character
            local e = d and d:FindFirstChild('HumanoidRootPart')

            if not e or not e.Parent then
                local f, g = pcall(function()
                    d = p.Character

                    if d then
                        e = d:WaitForChild('HumanoidRootPart', 1)

                        if e then
                            VoidHideSpoofedProperties[e] = {}
                        end
                    end
                end)

                return
            end

            pcall(VoidSpamFunction, c, e)
        end)
    end
end)
Window:AddSection({
    Name = 'Character Modifiers',
    Tab = LocalPlayerTab,
})

walkSpeedEnabled = false
jumpPowerEnabled = false
customWalkSpeed = 16
customJumpPower = 50

local function applyWalkSpeed()
    if walkSpeedEnabled and p.Character then
        local a = p.Character:FindFirstChildOfClass('Humanoid')

        if a then
            a.WalkSpeed = customWalkSpeed
        end
    end
end
local function applyJumpPower()
    if jumpPowerEnabled and p.Character then
        local a = p.Character:FindFirstChildOfClass('Humanoid')

        if a then
            a.JumpPower = customJumpPower
        end
    end
end

task.spawn(function()
    while true do
        RunService.Heartbeat:Wait()

        if walkSpeedEnabled then
            applyWalkSpeed()
        end
        if jumpPowerEnabled then
            applyJumpPower()
        end
    end
end)
p.CharacterAdded:Connect(function(a)
    a:WaitForChild('Humanoid')
    task.wait(0.1)

    if walkSpeedEnabled then
        applyWalkSpeed()
    end
    if jumpPowerEnabled then
        applyJumpPower()
    end
    if isFarmingCoins and a:FindFirstChild('HumanoidRootPart') then
        task.wait(0.5)

        local b = a.HumanoidRootPart

        if b:FindFirstChild('FarmGravity') then
            b.FarmGravity:Destroy()
        end

        local c = Instance.new('BodyVelocity')

        c.Name = 'FarmGravity'
        c.MaxForce = Vector3.new(0, math.huge, 0)
        c.Velocity = Vector3.new(0, 1, 0)
        c.Parent = b
    end
end)

UIElements.walkSpeedToggle = Window:AddToggle({
    Title = 'Custom WalkSpeed',
    Description = 'Enable custom walk speed',
    Default = false,
    Tab = LocalPlayerTab,
    Callback = function(a)
        walkSpeedEnabled = a

        if a then
            applyWalkSpeed()
        else
            if p.Character then
                local b = p.Character:FindFirstChildOfClass('Humanoid')

                if b then
                    b.WalkSpeed = 16
                end
            end
        end
    end,
})
UIElements.walkSpeedSlider = Window:AddSlider({
    Title = 'WalkSpeed Value',
    Description = 'Set custom walk speed value',
    Tab = LocalPlayerTab,
    Default = 16,
    MinValue = 16,
    MaxValue = 200,
    AllowDecimals = false,
    Callback = function(a)
        customWalkSpeed = a

        if walkSpeedEnabled then
            applyWalkSpeed()
        end
    end,
})
UIElements.jumpPowerToggle = Window:AddToggle({
    Title = 'Custom JumpPower',
    Description = 'Enable custom jump power',
    Default = false,
    Tab = LocalPlayerTab,
    Callback = function(a)
        jumpPowerEnabled = a

        if a then
            applyJumpPower()
        else
            if p.Character then
                local b = p.Character:FindFirstChildOfClass('Humanoid')

                if b then
                    b.JumpPower = 50
                end
            end
        end
    end,
})
UIElements.jumpPowerSlider = Window:AddSlider({
    Title = 'JumpPower Value',
    Description = 'Set custom jump power value',
    Tab = LocalPlayerTab,
    Default = 50,
    MinValue = 50,
    MaxValue = 200,
    AllowDecimals = false,
    Callback = function(a)
        customJumpPower = a

        if jumpPowerEnabled then
            applyJumpPower()
        end
    end,
})
fovEnabled = false
customFOV = 70

local function applyFOV()
    if fovEnabled then
        local a = workspace.CurrentCamera

        if a then
            a.FieldOfView = customFOV
        end
    end
end

task.spawn(function()
    while true do
        RunService.Heartbeat:Wait()

        if fovEnabled then
            applyFOV()
        end
    end
end)
Window:AddToggle({
    Title = 'Custom FOV',
    Description = 'Enable custom field of view',
    Default = false,
    Tab = LocalPlayerTab,
    Callback = function(a)
        fovEnabled = a

        if a then
            applyFOV()
        else
            local b = workspace.CurrentCamera

            if b then
                b.FieldOfView = 70
            end
        end
    end,
})
Window:AddSlider({
    Title = 'FOV Value',
    Description = 'Set custom field of view value',
    Tab = LocalPlayerTab,
    Default = 70,
    MinValue = 70,
    MaxValue = 120,
    AllowDecimals = false,
    Callback = function(a)
        customFOV = a

        if fovEnabled then
            applyFOV()
        end
    end,
})

AutoFarmTab = Window:AddTab({
    Title = 'AutoFarm',
    Icon = 'rbxassetid://11963373994',
})
AutoFarmInfo = Window:AddInfoPanel({
    Title = 'AutoFarm Statistics',
    Tab = AutoFarmTab,
    Data = {
        ['Status'] = 'Disabled',
        ['Coins Collected'] = '0/0',
        ['Session Time'] = '00:00:00',
        ['Coins Per Hour'] = '0',
    },
})
farmStartTime = 0

local function formatTime(a)
    local b, c, d = math.floor(a / 3600), math.floor((a % 3600) / 60), math.floor(a % 60)

    return string.format('%02d:%02d:%02d', b, c, d)
end
local function restoreNormalGravity()
    if p.Character and p.Character:FindFirstChild('HumanoidRootPart') then
        local a = p.Character.HumanoidRootPart

        for b, c in pairs(a:GetChildren())do
            if c:IsA('BodyVelocity') or c:IsA('BodyGyro') or c:IsA('BodyPosition') or c:IsA('BodyThrust') or c:IsA('BodyForce') then
                c:Destroy()
            end
        end
    end
end
local function addFarmGravity()
    if p.Character and p.Character:FindFirstChild('HumanoidRootPart') then
        local a = p.Character.HumanoidRootPart

        if a:FindFirstChild('FarmGravity') then
            a.FarmGravity:Destroy()
        end

        local b = Instance.new('BodyPosition')

        b.Name = 'FarmGravity'
        b.MaxForce = Vector3.new(0, math.huge, 0)
        b.D = 1000
        b.P = 10000
        b.Position = a.Position
        b.Parent = a
    end
end

p.CharacterAdded:Connect(function(a)
    a:WaitForChild('HumanoidRootPart')
    task.wait(0.5)

    local b = a:FindFirstChild('HumanoidRootPart')

    if b then
        for c, d in pairs(b:GetChildren())do
            if d:IsA('BodyVelocity') or d:IsA('BodyGyro') or d:IsA('BodyPosition') or d:IsA('BodyThrust') or d:IsA('BodyForce') then
                d:Destroy()
            end
        end
    end
end)
task.spawn(function()
    while true do
        task.wait(1)

        if isFarmingCoins then
            local a = os.time() - farmStartTime

            AutoFarmInfo:UpdateValue('Session Time', formatTime(a))
            AutoFarmInfo:UpdateValue('Coins Collected', string.format('%d/%d', currentCoinsCollected, maxCoinsInRound))

            if allCoinsCollected then
                AutoFarmInfo:UpdateValue('Status', 'All coins collected')
            elseif farmingActive then
                AutoFarmInfo:UpdateValue('Status', 'Farming...')
            else
                AutoFarmInfo:UpdateValue('Status', 'Waiting...')
            end
            if a > 0 and currentCoinsCollected > 0 then
                local b = math.floor((currentCoinsCollected / a) * 3600)

                AutoFarmInfo:UpdateValue('Coins Per Hour', tostring(b))
            end
        end
    end
end)

local function returncoincontainer()
    for a, b in pairs(workspace:GetChildren())do
        if b:FindFirstChild('CoinContainer') and b:IsA('Model') then
            return b:FindFirstChild('CoinContainer')
        end
    end

    return nil
end
local function FindNearestCoin(a)
    if not a then
        return nil, math.huge
    end

    local b, c = nil, math.huge

    for d, e in pairs(a:GetChildren())do
        if e:GetAttribute('CoinID') == 'Candy' and e:FindFirstChild('TouchInterest') and e.Transparency == 1 then
            if p.Character and p.Character:FindFirstChild('HumanoidRootPart') then
                local f = (p.Character.HumanoidRootPart.Position - e.Position).Magnitude

                if f < c then
                    b = e
                    c = f
                end
            end
        end
    end

    return b, c
end

resetWhenBagFull = false
flingMurdererWhenBagFull = false
flingShootWhenBagFull = false
shootMurdererWhenBagFull = false
killAllWhenBagFull = false

local function getPlayerRole()
    local a = game:GetService('ReplicatedStorage')
    local b = a:FindFirstChild('GetPlayerData', true)

    if not b then
        return nil
    end

    local c, d = pcall(function()
        return b:InvokeServer()
    end)

    if not c or not d then
        return nil
    end

    local e = d[p.Name]

    if e and e.Role then
        return e.Role
    end

    return nil
end
local function isPlayerDead()
    local a, b = pcall(function()
        return game.ReplicatedStorage.Remotes.Extras.GetPlayerData:InvokeServer()[p.Name]
    end)

    if a and b then
        return b['Dead'] == true
    end

    return false
end

Window:AddToggle({
    Title = 'Farm Coins',
    Description = 'Automatically farm coins with noclip',
    Default = false,
    Tab = AutoFarmTab,
    Callback = function(a)
        isFarmingCoins = a

        if a then
            farmStartTime = os.time()

            AutoFarmInfo:UpdateValue('Status', 'Enabled')
        else
            isFarmingCoins = false

            if farmingActive then
                stopFarming()
            end

            restoreNormalGravity()
            AutoFarmInfo:UpdateValue('Status', 'Disabled')
        end
    end,
})
Window:AddToggle({
    Title = 'Reset When Bag Full (Innocent)',
    Description = 'Reset character when bag is full',
    Default = false,
    Tab = AutoFarmTab,
    Callback = function(a)
        resetWhenBagFull = a
    end,
})
Window:AddToggle({
    Title = 'Fling Murderer When Bag Full (Innocent & Sheriff)',
    Description = 'Fling the murderer when bag is full',
    Default = false,
    Tab = AutoFarmTab,
    Callback = function(a)
        flingMurdererWhenBagFull = a
    end,
})
Window:AddToggle({
    Title = 'Fling Sheriff & Shoot When Bag Full (Innocent)',
    Description = 'Fling sheriff and shoot murderer when bag is full',
    Default = false,
    Tab = AutoFarmTab,
    Callback = function(a)
        flingShootWhenBagFull = a
    end,
})
Window:AddToggle({
    Title = 'Shoot Murderer When Bag Full (Sheriff)',
    Description = 'Shoot murderer when bag is full',
    Default = false,
    Tab = AutoFarmTab,
    Callback = function(a)
        shootMurdererWhenBagFull = a
    end,
})
Window:AddToggle({
    Title = 'Kill All When Bag Full (Murderer)',
    Description = 'Kill all players when bag is full',
    Default = false,
    Tab = AutoFarmTab,
    Callback = function(a)
        killAllWhenBagFull = a
    end,
})

lastBagCheckTime = 0
bagFullActionInProgress = false

task.spawn(function()
    while true do
        task.wait(0.5)

        if isFarmingCoins and not bagFullActionInProgress and allCoinsCollected then
            if isPlayerDead() then
                continue
            end

            bagFullActionInProgress = true
            lastBagCheckTime = os.time()

            local a = getPlayerRole()

            restoreNormalGravity()

            if farmingActive then
                stopFarming()
            end
            if a == 'Innocent' then
                if resetWhenBagFull then
                    Window:Notify({
                        Title = 'Bag Full',
                        Description = 'Resetting character...',
                        Duration = 2,
                    })
                    task.wait(0.5)
                    restoreNormalGravity()

                    if p.Character and p.Character:FindFirstChild('Humanoid') then
                        p.Character.Humanoid.Health = 0
                    else
                    end

                    task.wait(6)

                    bagFullActionInProgress = false

                    continue
                elseif flingMurdererWhenBagFull then
                    Window:Notify({
                        Title = 'Bag Full',
                        Description = 'Flinging murderer...',
                        Duration = 2,
                    })

                    local b, c = pcall(findMurderer)

                    if b and c then
                        FlingActive = true

                        task.spawn(function()
                            local d, e = pcall(function()
                                SkidFling(c)
                            end)

                            if not d then
                            end
                        end)

                        while allCoinsCollected and isFarmingCoins do
                            task.wait(1)

                            local d, e = pcall(findMurderer)

                            if not d or not e or e ~= c then
                                FlingActive = false

                                break
                            end
                        end

                        FlingActive = false
                    else
                    end

                    bagFullActionInProgress = false

                    continue
                elseif flingShootWhenBagFull then
                    Window:Notify({
                        Title = 'Bag Full',
                        Description = 'Flinging sheriff and grabbing gun...',
                        Duration = 2,
                    })

                    bagFullActionInProgress = false

                    continue
                else
                    bagFullActionInProgress = false
                end
            elseif a == 'Sheriff' then
                if flingMurdererWhenBagFull then
                    Window:Notify({
                        Title = 'Bag Full',
                        Description = 'Flinging murderer...',
                        Duration = 2,
                    })

                    local b, c = pcall(findMurderer)

                    if b and c then
                        FlingActive = true

                        task.spawn(function()
                            local d, e = pcall(function()
                                SkidFling(c)
                            end)

                            if not d then
                            end
                        end)

                        while allCoinsCollected and isFarmingCoins do
                            task.wait(1)

                            local d, e = pcall(findMurderer)

                            if not d or not e or e ~= c then
                                FlingActive = false

                                break
                            end
                        end

                        FlingActive = false
                    else
                    end

                    bagFullActionInProgress = false

                    continue
                elseif shootMurdererWhenBagFull then
                    local b, c = pcall(findMurderer)

                    if b and c and c.Character then
                        local d = c.Character:FindFirstChild('Humanoid')

                        if d and d.Health > 0 then
                            Window:Notify({
                                Title = 'Bag Full',
                                Description = 'Shooting murderer...',
                                Duration = 2,
                            })
                            pcall(shootMurderer)
                        else
                        end
                    else
                    end

                    bagFullActionInProgress = false

                    continue
                else
                    bagFullActionInProgress = false
                end
            elseif a == 'Murderer' then
                if killAllWhenBagFull then
                    Window:Notify({
                        Title = 'Bag Full',
                        Description = 'Killing all players...',
                        Duration = 2,
                    })

                    for b, c in pairs(ps:GetPlayers())do
                        if c ~= p and c.Character and c.Character:FindFirstChild('Humanoid') and c.Character.Humanoid.Health > 0 then
                            local d = p.Character and p.Character:FindFirstChild('Knife') or p.Backpack and p.Backpack:FindFirstChild('Knife')

                            if d then
                                if d.Parent == p.Backpack then
                                    p.Character.Humanoid:EquipTool(d)
                                    task.wait(0.1)
                                end
                                if d:FindFirstChild('Events') and d.Events:FindFirstChild('KnifeStabbed') then
                                    d.Events.KnifeStabbed:FireServer(c.Character.Humanoid)
                                end
                            end
                        end
                    end

                    bagFullActionInProgress = false

                    continue
                else
                    bagFullActionInProgress = false
                end
            else
                bagFullActionInProgress = false
            end
        end
    end
end)

VisualsTab = Window:AddTab({
    Title = 'Visuals',
    Icon = 'rbxassetid://11963373994',
})

Window:AddSection({
    Name = 'Character Visuals',
    Tab = VisualsTab,
})

forceFieldEnabled = false
forceFieldColor = Color3.fromRGB(0, 170, 255)
forceFieldOriginalColors = {}

local function applyForceFieldMaterial()
    if not forceFieldEnabled then
        return
    end
    if not p.Character then
        return
    end

    for a, b in pairs(p.Character:GetDescendants())do
        if b:IsA('BasePart') or b:IsA('MeshPart') then
            local c, d = false, b.Parent

            while d and d ~= p.Character do
                if d:IsA('Tool') then
                    c = true

                    break
                end

                d = d.Parent
            end

            if not c then
                if not forceFieldOriginalColors[b] then
                    forceFieldOriginalColors[b] = b.Color
                end

                b.Material = Enum.Material.ForceField
                b.Color = forceFieldColor
            end
        end
    end
end

task.spawn(function()
    while true do
        RunService.Heartbeat:Wait()

        if forceFieldEnabled then
            applyForceFieldMaterial()
        end
    end
end)
p.CharacterAdded:Connect(function(a)
    forceFieldOriginalColors = {}

    a:WaitForChild('Humanoid')
    task.wait(0.1)

    if forceFieldEnabled then
        applyForceFieldMaterial()
    end
end)
Window:AddToggle({
    Title = 'Force Field Body Parts',
    Description = 'Set all body parts material to ForceField',
    Default = false,
    Tab = VisualsTab,
    Callback = function(a)
        forceFieldEnabled = a

        if a then
            applyForceFieldMaterial()
            Window:Notify({
                Title = 'ForceField Enabled',
                Description = 'Body parts material set to ForceField',
                Duration = 2,
            })
        else
            if p.Character then
                for b, c in pairs(p.Character:GetDescendants())do
                    if c:IsA('BasePart') or c:IsA('MeshPart') then
                        local d, e = false, c.Parent

                        while e and e ~= p.Character do
                            if e:IsA('Tool') then
                                d = true

                                break
                            end

                            e = e.Parent
                        end

                        if not d then
                            c.Material = Enum.Material.Plastic

                            if forceFieldOriginalColors[c] then
                                c.Color = forceFieldOriginalColors[c]
                            end
                        end
                    end
                end
            end

            forceFieldOriginalColors = {}

            Window:Notify({
                Title = 'ForceField Disabled',
                Description = 'Body parts material restored',
                Duration = 2,
            })
        end
    end,
})
Window:AddColorPicker({
    Title = 'ForceField Color',
    Description = 'Set custom color for ForceField material',
    Default = Color3.fromRGB(0, 170, 255),
    Tab = VisualsTab,
    Callback = function(a)
        forceFieldColor = a

        if forceFieldEnabled then
            applyForceFieldMaterial()
        end
    end,
})

auraEnabled = false
selectedAuraType = {}
auraparts = {}
auras = {}

task.spawn(function()
    local a = {
        starlight = 'rbxassetid://134645216613107',
        heavenly = 'rbxassetid://139300897520961',
        ribbon = 'rbxassetid://132069507632161',
        sakura = 'rbxassetid://81755778619404',
        angel = 'rbxassetid://97658130917593',
        wind = 'rbxassetid://80694081850877',
        flow = 'rbxassetid://119913533725648',
        star = 'rbxassetid://73754563740680',
    }

    for b, c in pairs(a)do
        local d, e = pcall(function()
            return game:GetObjects(c)[1]
        end)

        if d and e then
            auras[b] = e
        end
    end
end)

local function clearAura()
    for a, b in ipairs(auraparts)do
        pcall(function()
            b:Destroy()
        end)
    end

    auraparts = {}
end
local function createAura(a)
    clearAura()

    if not auraEnabled or not a then
        return
    end

    local b = a:FindFirstChild('HumanoidRootPart')

    if not b then
        return
    end

    local c = 0

    for d in pairs(selectedAuraType)do
        c = c + 1
    end

    if c == 0 then
        return
    end

    for d, e in pairs(selectedAuraType)do
        local f = auras[d]

        if f then
            local g = f:Clone()
            local h = g:GetChildren()

            for i, j in ipairs(h)do
                local k = a:FindFirstChild(j.Name)

                if k then
                    local l = j:GetChildren()

                    for m, n in ipairs(l)do
                        local o = n:Clone()

                        o.Parent = k

                        table.insert(auraparts, o)
                    end
                end
            end

            g:Destroy()
        else
        end
    end
end

Window:AddToggleMultiSelect({
    Title = 'Character Aura',
    Description = 'Add multiple particle aura effects to your character',
    Options = {
        'angel',
        'starlight',
        'heavenly',
        'ribbon',
        'sakura',
        'wind',
        'flow',
        'star',
    },
    Enabled = false,
    Tab = VisualsTab,
    ToggleCallback = function(a)
        auraEnabled = a

        if a then
            createAura(p.Character)
        else
            clearAura()
        end
    end,
    DropdownCallback = function(a)
        selectedAuraType = a

        if auraEnabled and p.Character then
            createAura(p.Character)
        end
    end,
})

killEffectEnabled = false
killEffectColor = Color3.fromRGB(255, 0, 0)
killEffectConnections = {}

local function createKillEffect(a, b)
    if not killEffectEnabled or not a then
        return
    end

    local c = a:Clone()
    local d = c:FindFirstChild('HumanoidRootPart')

    if d then
        d.Transparency = 1
    end

    for e, f in pairs(c:GetDescendants())do
        if f:IsA('BasePart') or f:IsA('MeshPart') then
            if f.Name == 'HumanoidRootPart' then
                f.Transparency = 1
                f.Anchored = true
                f.CanCollide = false

                continue
            end

            f.Anchored = true
            f.CanCollide = false
            f.Material = Enum.Material.Neon
            f.Color = killEffectColor
            f.Transparency = 0

            if f:IsA('MeshPart') then
                f.TextureID = ''
            end
        end
        if f:IsA('Accessory') then
            local g = f:FindFirstChild('Handle')

            if g and (g:IsA('BasePart') or g:IsA('MeshPart')) then
                g.Material = Enum.Material.Neon
                g.Color = killEffectColor
                g.Transparency = 0
                g.Anchored = true
                g.CanCollide = false

                if g:IsA('MeshPart') then
                    g.TextureID = ''
                end
            end
        end
        if f:IsA('SpecialMesh') then
            f.TextureId = ''
        end
        if f:IsA('Decal') then
            if f.Name ~= 'face' then
                f:Destroy()
            else
                f.Transparency = 1
            end
        end
        if f:IsA('Texture') then
            f:Destroy()
        end
        if f:IsA('Script') or f:IsA('LocalScript') or f:IsA('ModuleScript') then
            f:Destroy()
        end
        if f:IsA('Humanoid') or f:IsA('Tool') then
            f:Destroy()
        end
    end

    local e, f = {}, c:FindFirstChild('HumanoidRootPart')

    if f then
        for g, h in pairs(c:GetDescendants())do
            if (h:IsA('BasePart') or h:IsA('MeshPart')) and h ~= f then
                e[h] = f.CFrame:ToObjectSpace(h.CFrame)
            end
        end
    end

    for g, h in pairs(c:GetDescendants())do
        if h:IsA('Weld') or h:IsA('Motor6D') then
            h:Destroy()
        end
    end
    for g, h in pairs(c:GetDescendants())do
        if h:IsA('BasePart') or h:IsA('MeshPart') then
            h.Anchored = true
        end
    end

    if c.PrimaryPart then
        c:SetPrimaryPartCFrame(b)
    elseif f then
        f.CFrame = b
    end
    if f then
        for g, h in pairs(e)do
            if g and g.Parent then
                g.CFrame = f.CFrame:ToWorldSpace(h)
            end
        end
    end

    c.Parent = workspace

    task.spawn(function()
        local g, h = 2, 60
        local i = 1 / h

        for j = 1, h do
            task.wait(g / h)

            for k, l in pairs(c:GetDescendants())do
                if l:IsA('BasePart') or l:IsA('MeshPart') then
                    l.Transparency = math.min(1, l.Transparency + i)
                end
            end
        end

        c:Destroy()
    end)
end
local function setupKillEffectMonitoring()
    for a, b in pairs(killEffectConnections)do
        if b then
            b:Disconnect()
        end
    end

    killEffectConnections = {}

    if not killEffectEnabled then
        return
    end

    for a, b in pairs(Players:GetPlayers())do
        if b ~= p then
            if b.Character then
                local c = b.Character:FindFirstChild('Humanoid')

                if c then
                    local d = c.Died:Connect(function()
                        local d, e = false, false

                        if p.Character then
                            if p.Character:FindFirstChild('Knife') then
                                d = true
                            end
                            if p.Character:FindFirstChild('Gun') then
                                e = true
                            end
                        end
                        if p.Backpack then
                            if p.Backpack:FindFirstChild('Knife') then
                                d = true
                            end
                            if p.Backpack:FindFirstChild('Gun') then
                                e = true
                            end
                        end

                        local f = false

                        if d then
                            f = true
                        elseif e then
                            local g = false

                            if b.Character then
                                if b.Character:FindFirstChild('Knife') then
                                    g = true
                                end
                            end
                            if b.Backpack then
                                if b.Backpack:FindFirstChild('Knife') then
                                    g = true
                                end
                            end
                            if g then
                                f = true
                            end
                        end
                        if f and b.Character and b.Character:FindFirstChild('HumanoidRootPart') then
                            local g = b.Character.HumanoidRootPart.CFrame

                            createKillEffect(b.Character, g)
                        end
                    end)

                    table.insert(killEffectConnections, d)
                end
            end

            local c = b.CharacterAdded:Connect(function(c)
                task.wait(0.5)

                local d = c:FindFirstChild('Humanoid')

                if d and killEffectEnabled then
                    local e = d.Died:Connect(function()
                        local e, f = false, false

                        if p.Character then
                            if p.Character:FindFirstChild('Knife') then
                                e = true
                            end
                            if p.Character:FindFirstChild('Gun') then
                                f = true
                            end
                        end
                        if p.Backpack then
                            if p.Backpack:FindFirstChild('Knife') then
                                e = true
                            end
                            if p.Backpack:FindFirstChild('Gun') then
                                f = true
                            end
                        end

                        local g = false

                        if e then
                            g = true
                        elseif f then
                            local h = false

                            if b.Character and b.Character:FindFirstChild('Knife') then
                                h = true
                            end
                            if b.Backpack and b.Backpack:FindFirstChild('Knife') then
                                h = true
                            end
                            if h then
                                g = true
                            end
                        end
                        if g and c:FindFirstChild('HumanoidRootPart') then
                            local h = c.HumanoidRootPart.CFrame

                            createKillEffect(c, h)
                        end
                    end)

                    table.insert(killEffectConnections, e)
                end
            end)

            table.insert(killEffectConnections, c)
        end
    end

    local a = Players.PlayerAdded:Connect(function(a)
        if not killEffectEnabled or a == p then
            return
        end

        local b = a.CharacterAdded:Connect(function(b)
            task.wait(0.5)

            local c = b:FindFirstChild('Humanoid')

            if c and killEffectEnabled then
                local d = c.Died:Connect(function()
                    local d, e = false, false

                    if p.Character then
                        if p.Character:FindFirstChild('Knife') then
                            d = true
                        end
                        if p.Character:FindFirstChild('Gun') then
                            e = true
                        end
                    end
                    if p.Backpack then
                        if p.Backpack:FindFirstChild('Knife') then
                            d = true
                        end
                        if p.Backpack:FindFirstChild('Gun') then
                            e = true
                        end
                    end

                    local f = false

                    if d then
                        f = true
                    elseif e then
                        local g = false

                        if a.Character and a.Character:FindFirstChild('Knife') then
                            g = true
                        end
                        if a.Backpack and a.Backpack:FindFirstChild('Knife') then
                            g = true
                        end
                        if g then
                            f = true
                        end
                    end
                    if f and b:FindFirstChild('HumanoidRootPart') then
                        local g = b.HumanoidRootPart.CFrame

                        createKillEffect(b, g)
                    end
                end)

                table.insert(killEffectConnections, d)
            end
        end)

        table.insert(killEffectConnections, b)
    end)

    table.insert(killEffectConnections, a)
end

Window:AddToggle({
    Title = 'Kill Effect',
    Description = 'Create neon clone effect when you kill someone',
    Default = false,
    Tab = VisualsTab,
    Callback = function(a)
        killEffectEnabled = a

        if a then
            setupKillEffectMonitoring()
            Window:Notify({
                Title = 'Kill Effect Enabled',
                Description = 'Neon clones will appear on kills',
                Duration = 2,
            })
        else
            for b, c in pairs(killEffectConnections)do
                if c then
                    c:Disconnect()
                end
            end

            killEffectConnections = {}

            Window:Notify({
                Title = 'Kill Effect Disabled',
                Description = 'Kill effects stopped',
                Duration = 2,
            })
        end
    end,
})
Window:AddColorPicker({
    Title = 'Kill Effect Color',
    Description = 'Set color for kill effect clones',
    Default = Color3.fromRGB(255, 0, 0),
    Tab = VisualsTab,
    Callback = function(a)
        killEffectColor = a
    end,
})

chinaHatEnabled = false
chinaHatObjects = {}
chinaHatColor = Color3.fromRGB(255, 123, 123)

local function createChinaHat(a)
    for b, c in ipairs(chinaHatObjects)do
        pcall(function()
            c:Destroy()
        end)
    end

    chinaHatObjects = {}

    if not chinaHatEnabled or not a then
        return
    end

    local b = a:FindFirstChild('Head')

    if not b then
        return
    end

    local c = Instance.new('Part')

    c.Name = 'ChinaHat'
    c.Size = Vector3.new(1, 1, 1)
    c.Color = chinaHatColor
    c.Material = Enum.Material.Neon
    c.Transparency = 0.2
    c.CanCollide = false
    c.Anchored = false
    c.Parent = a

    table.insert(chinaHatObjects, c)

    local d = Instance.new('SpecialMesh')

    d.MeshType = Enum.MeshType.FileMesh
    d.MeshId = 'rbxassetid://1033714'
    d.Scale = Vector3.new(1.7, 1.1, 1.7)
    d.Parent = c

    table.insert(chinaHatObjects, d)

    local e = Instance.new('Weld')

    e.Part0 = b
    e.Part1 = c
    e.C0 = CFrame.new(0, 0.9, 0)
    e.Parent = c

    table.insert(chinaHatObjects, e)

    local f = Instance.new('PointLight')

    f.Color = chinaHatColor
    f.Brightness = 1
    f.Range = 12
    f.Shadows = true
    f.Parent = c

    table.insert(chinaHatObjects, f)
end

Window:AddToggle({
    Title = 'China Hat',
    Description = 'Add a glowing china hat to your character',
    Default = false,
    Tab = VisualsTab,
    Callback = function(a)
        chinaHatEnabled = a

        if a then
            createChinaHat(p.Character)
        else
            for b, c in ipairs(chinaHatObjects)do
                pcall(function()
                    c:Destroy()
                end)
            end

            chinaHatObjects = {}
        end
    end,
})
Window:AddColorPicker({
    Title = 'China Hat Color',
    Description = 'Set the color of the china hat',
    Default = Color3.fromRGB(255, 123, 123),
    Tab = VisualsTab,
    Callback = function(a)
        chinaHatColor = a

        if chinaHatEnabled and p.Character then
            createChinaHat(p.Character)
        end
    end,
})
Window:AddSection({
    Name = 'Character Modifications',
    Tab = VisualsTab,
})

headlessEnabled = false
korbloxEnabled = false
originalLegProperties = {}

local function applyHeadless(a)
    if p.Character and p.Character:FindFirstChild('Head') then
        p.Character.Head.Transparency = a and 1 or 0
    end
end
local function saveOriginalLegProperties()
    if not p.Character then
        return
    end

    local a, b, c = p.Character:FindFirstChild('RightLowerLeg'), p.Character:FindFirstChild('RightUpperLeg'), p.Character:FindFirstChild('RightFoot')

    if a then
        originalLegProperties.RightLowerLeg = {
            MeshId = a.MeshId,
            Transparency = a.Transparency,
        }
    end
    if b then
        originalLegProperties.RightUpperLeg = {
            MeshId = b.MeshId,
            TextureID = b.TextureID,
        }
    end
    if c then
        originalLegProperties.RightFoot = {
            MeshId = c.MeshId,
            Transparency = c.Transparency,
        }
    end
end
local function applyKorblox()
    if not p.Character then
        return
    end

    local a = p.Character:FindFirstChild('RightLowerLeg')

    if a then
        a.MeshId = 'http://www.roblox.com/asset/?id=902942093'
        a.Transparency = 1
    end

    local b = p.Character:FindFirstChild('RightUpperLeg')

    if b then
        b.MeshId = 'http://www.roblox.com/asset/?id=902942096'
        b.TextureID = 'http://www.roblox.com/asset/?id=902843398'
    end

    local c = p.Character:FindFirstChild('RightFoot')

    if c then
        c.MeshId = 'http://www.roblox.com/asset/?id=902942089'
        c.Transparency = 1
    end
end
local function restoreOriginalLeg()
    if not p.Character then
        return
    end

    local a = p.Character:FindFirstChild('RightLowerLeg')

    if a and originalLegProperties.RightLowerLeg then
        a.MeshId = originalLegProperties.RightLowerLeg.MeshId
        a.Transparency = originalLegProperties.RightLowerLeg.Transparency
    end

    local b = p.Character:FindFirstChild('RightUpperLeg')

    if b and originalLegProperties.RightUpperLeg then
        b.MeshId = originalLegProperties.RightUpperLeg.MeshId
        b.TextureID = originalLegProperties.RightUpperLeg.TextureID
    end

    local c = p.Character:FindFirstChild('RightFoot')

    if c and originalLegProperties.RightFoot then
        c.MeshId = originalLegProperties.RightFoot.MeshId
        c.Transparency = originalLegProperties.RightFoot.Transparency
    end
end

saveOriginalLegProperties()
Window:AddToggle({
    Title = 'Headless',
    Description = 'Make your head invisible',
    Default = false,
    Tab = VisualsTab,
    Callback = function(a)
        headlessEnabled = a

        applyHeadless(a)
    end,
})
Window:AddToggle({
    Title = 'Korblox Leg',
    Description = 'Apply korblox leg effect',
    Default = false,
    Tab = VisualsTab,
    Callback = function(a)
        korbloxEnabled = a

        if a then
            applyKorblox()
        else
            restoreOriginalLeg()
        end
    end,
})
Window:AddSection({
    Name = 'Sky & Weather',
    Tab = VisualsTab,
})

oldPropertiesshaders = {}
shadersenabled = false
Lighting = game:GetService('Lighting')

Window:AddToggle({
    Title = 'RTX Shaders',
    Description = 'Enable realistic lighting and sky effects',
    Default = false,
    Tab = VisualsTab,
    Callback = function(a)
        if a then
            shadersenabled = true

            local b = Instance.new('BloomEffect')

            b.Name = 'Bloom (RTX Shaders)'
            b.Intensity = 0.1
            b.Threshold = 0
            b.Size = 100
            b.Parent = Lighting

            local c = Instance.new('Sky')

            c.Name = 'Tropic (RTX Shaders)'
            c.SkyboxUp = 'http://www.roblox.com/asset/?id=169210149'
            c.SkyboxLf = 'http://www.roblox.com/asset/?id=169210133'
            c.SkyboxBk = 'http://www.roblox.com/asset/?id=169210090'
            c.SkyboxFt = 'http://www.roblox.com/asset/?id=169210121'
            c.StarCount = 100
            c.SkyboxDn = 'http://www.roblox.com/asset/?id=169210108'
            c.SkyboxRt = 'http://www.roblox.com/asset/?id=169210143'
            c.Parent = b

            local d = Instance.new('Sky')

            d.Name = 'Sunset (RTX Shaders)'
            d.SkyboxUp = 'rbxassetid://323493360'
            d.SkyboxLf = 'rbxassetid://323494252'
            d.SkyboxBk = 'rbxassetid://323494035'
            d.SkyboxFt = 'rbxassetid://323494130'
            d.SkyboxDn = 'rbxassetid://323494368'
            d.SunAngularSize = 14
            d.SkyboxRt = 'rbxassetid://323494067'
            d.Parent = Lighting
            oldPropertiesshaders.Brightness = Lighting.Brightness
            oldPropertiesshaders.ColorShift_Bottom = Lighting.ColorShift_Bottom
            oldPropertiesshaders.ColorShift_Top = Lighting.ColorShift_Top
            oldPropertiesshaders.OutdoorAmbient = Lighting.OutdoorAmbient
            oldPropertiesshaders.ClockTime = Lighting.ClockTime
            oldPropertiesshaders.FogColor = Lighting.FogColor
            oldPropertiesshaders.FogEnd = Lighting.FogEnd
            oldPropertiesshaders.FogStart = Lighting.FogStart
            oldPropertiesshaders.ExposureCompensation = Lighting.ExposureCompensation
            oldPropertiesshaders.ShadowSoftness = Lighting.ShadowSoftness
            oldPropertiesshaders.Ambient = Lighting.Ambient
            Lighting.Brightness = 2.14
            Lighting.ColorShift_Bottom = Color3.fromRGB(11, 0, 20)
            Lighting.ColorShift_Top = Color3.fromRGB(240, 127, 14)
            Lighting.OutdoorAmbient = Color3.fromRGB(34, 0, 49)
            Lighting.ClockTime = 6.7
            Lighting.FogColor = Color3.fromRGB(94, 76, 106)
            Lighting.FogEnd = 1000
            Lighting.FogStart = 0
            Lighting.ExposureCompensation = 0.24
            Lighting.ShadowSoftness = 0
            Lighting.Ambient = Color3.fromRGB(59, 33, 27)
        else
            shadersenabled = false

            for b, c in ipairs(Lighting:GetChildren())do
                if string.find(c.Name, 'RTX Shaders') then
                    c:Destroy()
                end
            end

            Lighting.Brightness = oldPropertiesshaders.Brightness
            Lighting.ColorShift_Bottom = oldPropertiesshaders.ColorShift_Bottom
            Lighting.ColorShift_Top = oldPropertiesshaders.ColorShift_Top
            Lighting.OutdoorAmbient = oldPropertiesshaders.OutdoorAmbient
            Lighting.ClockTime = oldPropertiesshaders.ClockTime
            Lighting.FogColor = oldPropertiesshaders.FogColor
            Lighting.FogEnd = oldPropertiesshaders.FogEnd
            Lighting.FogStart = oldPropertiesshaders.FogStart
            Lighting.ExposureCompensation = oldPropertiesshaders.ExposureCompensation
            Lighting.ShadowSoftness = oldPropertiesshaders.ShadowSoftness
            Lighting.Ambient = oldPropertiesshaders.Ambient
        end
    end,
})

skyEnabled = false
selectedSkyType = 'Sunset'
lighting = game:GetService('Lighting')
hadOriginalSky = false
originalSkyData = {}
existingSky = lighting:FindFirstChildOfClass('Sky')

if existingSky then
    hadOriginalSky = true
    originalSkyData = {
        SkyboxBk = existingSky.SkyboxBk,
        SkyboxDn = existingSky.SkyboxDn,
        SkyboxFt = existingSky.SkyboxFt,
        SkyboxLf = existingSky.SkyboxLf,
        SkyboxRt = existingSky.SkyboxRt,
        SkyboxUp = existingSky.SkyboxUp,
    }
end

skyboxes = {
    Sunset = {
        SkyboxBk = 'http://www.roblox.com/asset/?id=458016711',
        SkyboxDn = 'http://www.roblox.com/asset/?id=458016826',
        SkyboxFt = 'http://www.roblox.com/asset/?id=458016532',
        SkyboxLf = 'http://www.roblox.com/asset/?id=458016655',
        SkyboxRt = 'http://www.roblox.com/asset/?id=458016782',
        SkyboxUp = 'http://www.roblox.com/asset/?id=458016792',
    },
    Night = {
        SkyboxBk = 'rbxassetid://48020371',
        SkyboxDn = 'rbxassetid://48020144',
        SkyboxFt = 'rbxassetid://48020234',
        SkyboxLf = 'rbxassetid://48020211',
        SkyboxRt = 'rbxassetid://48020254',
        SkyboxUp = 'rbxassetid://48020383',
    },
    Minecraft = {
        SkyboxBk = 'rbxassetid://1876545003',
        SkyboxDn = 'rbxassetid://1876544331',
        SkyboxFt = 'rbxassetid://1876542941',
        SkyboxLf = 'rbxassetid://1876543392',
        SkyboxRt = 'rbxassetid://1876543764',
        SkyboxUp = 'rbxassetid://1876544642',
    },
    Evening = {
        SkyboxLf = 'http://www.roblox.com/asset/?id=7950573918',
        SkyboxBk = 'http://www.roblox.com/asset/?id=7950569153',
        SkyboxDn = 'http://www.roblox.com/asset/?id=7950570785',
        SkyboxFt = 'http://www.roblox.com/asset/?id=7950572449',
        SkyboxRt = 'http://www.roblox.com/asset/?id=7950575055',
        SkyboxUp = 'http://www.roblox.com/asset/?id=7950627627',
    },
    Purple = {
        SkyboxBk = 'rbxassetid://159454299',
        SkyboxDn = 'rbxassetid://159454296',
        SkyboxFt = 'rbxassetid://159454293',
        SkyboxLf = 'rbxassetid://159454286',
        SkyboxRt = 'rbxassetid://159454300',
        SkyboxUp = 'rbxassetid://159454288',
    },
    Pink = {
        SkyboxBk = 'rbxassetid://271042516',
        SkyboxDn = 'rbxassetid://271077243',
        SkyboxFt = 'rbxassetid://271042556',
        SkyboxLf = 'rbxassetid://271042310',
        SkyboxRt = 'rbxassetid://271042467',
        SkyboxUp = 'rbxassetid://271077958',
    },
    Chill = {
        SkyboxBk = 'rbxassetid://5084575798',
        SkyboxDn = 'rbxassetid://5084575916',
        SkyboxFt = 'rbxassetid://5103949679',
        SkyboxLf = 'rbxassetid://5103948542',
        SkyboxRt = 'rbxassetid://5103948784',
        SkyboxUp = 'rbxassetid://5084576400',
    },
}

local function applySky()
    local a = game:GetService('Lighting')
    local b = a:FindFirstChildOfClass('Sky')

    if not b then
        b = Instance.new('Sky')
        b.Parent = a
    end

    local c = skyboxes[selectedSkyType]

    if c then
        b.SkyboxBk = c.SkyboxBk
        b.SkyboxDn = c.SkyboxDn
        b.SkyboxFt = c.SkyboxFt
        b.SkyboxLf = c.SkyboxLf
        b.SkyboxRt = c.SkyboxRt
        b.SkyboxUp = c.SkyboxUp
    end
end

Window:AddToggleDropdown({
    Title = 'Custom Sky',
    Description = 'Change the skybox',
    Options = {
        'Sunset',
        'Night',
        'Minecraft',
        'Evening',
        'Purple',
        'Pink',
        'Chill',
    },
    Default = 'Sunset',
    Enabled = false,
    Tab = VisualsTab,
    ToggleCallback = function(a)
        skyEnabled = a

        if a then
            applySky()
        else
            local b = game:GetService('Lighting')
            local c = b:FindFirstChildOfClass('Sky')

            if hadOriginalSky then
                if c then
                    c.SkyboxBk = originalSkyData.SkyboxBk
                    c.SkyboxDn = originalSkyData.SkyboxDn
                    c.SkyboxFt = originalSkyData.SkyboxFt
                    c.SkyboxLf = originalSkyData.SkyboxLf
                    c.SkyboxRt = originalSkyData.SkyboxRt
                    c.SkyboxUp = originalSkyData.SkyboxUp
                end
            else
                if c then
                    c:Destroy()
                end
            end
        end
    end,
    DropdownCallback = function(a)
        selectedSkyType = a

        if skyEnabled then
            applySky()
        end
    end,
})

weatherEnabled = false
selectedWeatherType = 'LightRain'
weatherPart = nil
weatherEmitter = nil
weatherColor = Color3.fromRGB(200, 200, 255)
weatherIntensity = 1
weatherconfigs = {
    Rain = {
        Speed = NumberRange.new(120, 180),
        BaseRate = 1500,
        Texture = 'rbxassetid://1822883048',
        Lifetime = NumberRange.new(2.5, 3.5),
        Size = NumberSequence.new{
            NumberSequenceKeypoint.new(0, 0.8),
            NumberSequenceKeypoint.new(0.5, 0.9),
            NumberSequenceKeypoint.new(1, 0.7),
        },
        SpreadAngle = Vector2.new(12, 12),
        Acceleration = Vector3.new(0, -30, 0),
        Transparency = NumberSequence.new{
            NumberSequenceKeypoint.new(0, 0.1),
            NumberSequenceKeypoint.new(0.7, 0.3),
            NumberSequenceKeypoint.new(1, 1),
        },
        EmissionDirection = Enum.NormalId.Bottom,
        LightEmission = 0.3,
        LightInfluence = 0.4,
        Color = ColorSequence.new(Color3.fromRGB(220, 230, 255)),
    },
    Snow = {
        Texture = 'rbxassetid://605668174',
        SpreadAngle = Vector2.new(40, 40),
        Speed = NumberRange.new(8, 20),
        BaseRate = 150,
        Lifetime = NumberRange.new(12, 18),
        Size = NumberSequence.new{
            NumberSequenceKeypoint.new(0, 0.6),
            NumberSequenceKeypoint.new(0.5, 0.9),
            NumberSequenceKeypoint.new(1, 0.7),
        },
        Rotation = NumberRange.new(-180, 180),
        RotSpeed = NumberRange.new(-60, 60),
        Acceleration = Vector3.new(0, -6, 0),
        Transparency = NumberSequence.new{
            NumberSequenceKeypoint.new(0, 0.15),
            NumberSequenceKeypoint.new(0.8, 0.4),
            NumberSequenceKeypoint.new(1, 1),
        },
        EmissionDirection = Enum.NormalId.Bottom,
        LightEmission = 0.4,
        LightInfluence = 0.3,
        Color = ColorSequence.new(Color3.fromRGB(255, 255, 255)),
    },
    LightRain = {
        BaseRate = 600,
        Texture = 'rbxasset://textures/particles/sparkles_main.dds',
        Speed = NumberRange.new(70, 110),
        Lifetime = NumberRange.new(3, 4),
        Size = NumberSequence.new{
            NumberSequenceKeypoint.new(0, 0.35),
            NumberSequenceKeypoint.new(0.5, 0.4),
            NumberSequenceKeypoint.new(1, 0.3),
        },
        SpreadAngle = Vector2.new(8, 8),
        Acceleration = Vector3.new(0, -18, 0),
        Transparency = NumberSequence.new{
            NumberSequenceKeypoint.new(0, 0.2),
            NumberSequenceKeypoint.new(0.7, 0.5),
            NumberSequenceKeypoint.new(1, 1),
        },
        EmissionDirection = Enum.NormalId.Bottom,
        LightEmission = 0.5,
        LightInfluence = 0.3,
        Color = ColorSequence.new(Color3.fromRGB(200, 220, 255)),
    },
}

local function createWeather()
    if weatherPart then
        weatherPart:Destroy()

        weatherPart = nil
    end
    if weatherEmitter then
        weatherEmitter:Destroy()

        weatherEmitter = nil
    end
    if not weatherEnabled then
        return
    end

    weatherPart = Instance.new('Part')
    weatherPart.Size = Vector3.new(200, 1, 200)
    weatherPart.CanCollide = false
    weatherPart.Massless = true
    weatherPart.CastShadow = false
    weatherPart.Transparency = 1
    weatherPart.Anchored = true
    weatherPart.Name = 'WeatherPart'
    weatherPart.Parent = workspace

    local a = weatherconfigs[selectedWeatherType]

    if not a then
        return
    end

    weatherEmitter = Instance.new('ParticleEmitter')
    weatherEmitter.Parent = weatherPart
    weatherEmitter.Color = ColorSequence.new(weatherColor)
    weatherEmitter.Rate = a.BaseRate * weatherIntensity
    weatherEmitter.LightEmission = 0
    weatherEmitter.ZOffset = -1

    for b, c in pairs(a)do
        if b ~= 'BaseRate' then
            pcall(function()
                weatherEmitter[b] = c
            end)
        end
    end
end

Window:AddToggleDropdown({
    Title = 'Weather Effect',
    Description = 'Add weather particles',
    Options = {
        'Rain',
        'Snow',
        'LightRain',
    },
    Default = 'LightRain',
    Enabled = false,
    Tab = VisualsTab,
    ToggleCallback = function(a)
        weatherEnabled = a

        createWeather()
    end,
    DropdownCallback = function(a)
        selectedWeatherType = a

        if weatherEnabled then
            createWeather()
        end
    end,
})
Window:AddColorPicker({
    Title = 'Weather Color',
    Description = 'Set weather particle color',
    Default = Color3.fromRGB(200, 200, 255),
    Tab = VisualsTab,
    Callback = function(a)
        weatherColor = a

        if weatherEnabled then
            createWeather()
        end
    end,
})
Window:AddSlider({
    Title = 'Weather Intensity',
    Description = 'Control particle spawn rate (particles per second)',
    Min = 0.1,
    Max = 10,
    Default = 1,
    Increment = 0.1,
    Tab = VisualsTab,
    Callback = function(a)
        weatherIntensity = a

        if weatherEnabled and weatherEmitter and weatherEmitter.Parent then
            local b = weatherconfigs[selectedWeatherType]

            if b and b.BaseRate then
                weatherEmitter.Rate = b.BaseRate * weatherIntensity
            end
        end
    end,
})
task.spawn(function()
    while true do
        RunService.Heartbeat:Wait()

        if weatherEnabled and weatherPart then
            local a, b = workspace.CurrentCamera, p.Character
            local c = b and b:FindFirstChild('HumanoidRootPart')

            if c then
                local d = c.Position

                weatherPart.CFrame = CFrame.new(d.X, d.Y + 50, d.Z)
            elseif a then
                weatherPart.CFrame = a.CFrame * CFrame.new(0, 50, 0)
            end
        end
    end
end)
Window:AddSection({
    Name = 'Crosshair',
    Tab = VisualsTab,
})

crosshairEnabled = false
crosshairLines = {}
crosshairOutlines = {}
crosshairColor = Color3.fromRGB(255, 255, 255)
crosshairSize = 12
crosshairGap = 6
crosshairRotation = 0

local function createCrosshair()
    for a, b in ipairs(crosshairLines)do
        pcall(function()
            b:Remove()
        end)
    end
    for a, b in ipairs(crosshairOutlines)do
        pcall(function()
            b:Remove()
        end)
    end

    crosshairLines = {}
    crosshairOutlines = {}

    if not crosshairEnabled then
        UserInputService.MouseIconEnabled = true

        return
    end

    UserInputService.MouseIconEnabled = false

    for a = 1, 4 do
        local b = Drawing.new('Line')

        b.Thickness = 3
        b.Color = Color3.fromRGB(0, 0, 0)
        b.Transparency = 1
        b.Visible = true

        table.insert(crosshairOutlines, b)

        local c = Drawing.new('Line')

        c.Thickness = 1.5
        c.Color = crosshairColor
        c.Transparency = 1
        c.Visible = true

        table.insert(crosshairLines, c)
    end
end

Window:AddToggle({
    Title = 'Crosshair',
    Description = 'Custom rotating crosshair that follows cursor (hides default cursor)',
    Default = false,
    Tab = VisualsTab,
    Callback = function(a)
        crosshairEnabled = a

        createCrosshair()
    end,
})
Window:AddColorPicker({
    Title = 'Crosshair Color',
    Description = 'Set crosshair color',
    Default = Color3.fromRGB(255, 255, 255),
    Tab = VisualsTab,
    Callback = function(a)
        crosshairColor = a

        if crosshairEnabled then
            for b, c in ipairs(crosshairLines)do
                c.Color = a
            end
        end
    end,
})

local function rotatePoint(a, b, c)
    local d, e, f, g = math.cos(c), math.sin(c), a.X - b.X, a.Y - b.Y

    return Vector2.new(b.X + f * d - g * e, b.Y + f * e + g * d)
end

task.spawn(function()
    while true do
        RunService.RenderStepped:Wait()

        if crosshairEnabled and #crosshairLines >= 4 then
            local a = UserInputService:GetMouseLocation()

            crosshairRotation = crosshairRotation + math.rad(2)

            if crosshairRotation >= math.pi * 2 then
                crosshairRotation = 0
            end

            local b = {
                {
                    from = Vector2.new(0, -crosshairGap - crosshairSize),
                    to = Vector2.new(0, -crosshairGap),
                },
                {
                    from = Vector2.new(0, crosshairGap),
                    to = Vector2.new(0, crosshairGap + crosshairSize),
                },
                {
                    from = Vector2.new(-crosshairGap - crosshairSize, 0),
                    to = Vector2.new(-crosshairGap, 0),
                },
                {
                    from = Vector2.new(crosshairGap, 0),
                    to = Vector2.new(crosshairGap + crosshairSize, 0),
                },
            }

            for c = 1, 4 do
                local d, e = rotatePoint(b[c].from + a, a, crosshairRotation), rotatePoint(b[c].to + a, a, crosshairRotation)

                if crosshairOutlines[c] then
                    crosshairOutlines[c].From = d
                    crosshairOutlines[c].To = e
                end
                if crosshairLines[c] then
                    crosshairLines[c].From = d
                    crosshairLines[c].To = e
                end
            end
        end
    end
end)
Window:AddSection({
    Name = 'Tool Manipulations',
    Tab = VisualsTab,
})

toolSpinEnabled = false
toolSpinMode = '360\u{b0} Forward'
toolSpinSpeed = 1
toolSpinConnection = nil
originalGrip = nil

local function stopToolSpin()
    if toolSpinConnection then
        toolSpinConnection:Disconnect()

        toolSpinConnection = nil
    end

    local a = p.Character

    if a then
        local b = a:FindFirstChildOfClass('Tool')

        if b and originalGrip then
            b.Grip = originalGrip
            originalGrip = nil
        end
    end
end
local function startToolSpin()
    stopToolSpin()

    if not toolSpinEnabled then
        return
    end

    local a, b = 0, 0

    toolSpinConnection = RunService.Heartbeat:Connect(function(c)
        local d = p.Character

        if not d then
            return
        end

        local e = d:FindFirstChildOfClass('Tool')

        if not e then
            return
        end
        if not originalGrip then
            originalGrip = e.Grip
        end

        b = b + c

        if toolSpinMode == '360\u{b0} Forward' then
            a = a + (360 * toolSpinSpeed) * c

            if a >= 360 then
                a = a - 360
            end

            e.Grip = originalGrip * CFrame.Angles(math.rad(a), 0, 0)
        elseif toolSpinMode == '360\u{b0} Back' then
            a = a - (360 * toolSpinSpeed) * c

            if a <= -360 then
                a = a + 360
            end

            e.Grip = originalGrip * CFrame.Angles(math.rad(a), 0, 0)
        elseif toolSpinMode == '360\u{b0} Forward -> 360\u{b0} Back' then
            local f = 2 / toolSpinSpeed
            local g = (b % f) / f

            local function easeBackInOut(h)
                local i = 1.70158 * 1.525

                h = h * 2

                if h < 1 then
                    return 0.5 * (h * h * ((i + 1) * h - i))
                end

                h = h - 2

                return 0.5 * (h * h * ((i + 1) * h + i) + 2)
            end

            local h = easeBackInOut(g)
            local i = math.sin(h * math.pi * 2) * 180

            e.Grip = originalGrip * CFrame.Angles(math.rad(i), 0, 0)
        end
    end)
end
local function setupToolSpinHandlers(a)
    if not a then
        return
    end

    a.ChildAdded:Connect(function(b)
        if b:IsA('Tool') and toolSpinEnabled then
            originalGrip = nil

            task.wait(0.1)
            startToolSpin()
        end
    end)
    a.ChildRemoved:Connect(function(b)
        if b:IsA('Tool') then
            originalGrip = nil
        end
    end)
end

if p.Character then
    setupToolSpinHandlers(p.Character)
end

p.CharacterAdded:Connect(setupToolSpinHandlers)
Window:AddToggleDropdown({
    Title = 'Tool Spin',
    Description = 'Spin your equipped tool with different animations',
    Options = {
        '360\u{b0} Forward',
        '360\u{b0} Back',
        '360\u{b0} Forward -> 360\u{b0} Back',
    },
    Default = '360\u{b0} Forward',
    Enabled = false,
    Tab = VisualsTab,
    ToggleCallback = function(a)
        toolSpinEnabled = a

        if a then
            startToolSpin()
        else
            stopToolSpin()
        end
    end,
    DropdownCallback = function(a)
        toolSpinMode = a

        if toolSpinEnabled then
            startToolSpin()
        end
    end,
})
Window:AddSlider({
    Title = 'Spin Speed',
    Description = 'Control tool rotation speed (higher = faster)',
    Min = 0.1,
    Max = 5,
    Default = 1,
    Increment = 0.1,
    Tab = VisualsTab,
    Callback = function(a)
        toolSpinSpeed = a

        if toolSpinEnabled then
            startToolSpin()
        end
    end,
})

forceFieldToolsEnabled = false
forceFieldToolsColor = Color3.fromRGB(255, 0, 255)
forceFieldToolsOriginalData = {}

local function applyForceFieldToTool()
    if not forceFieldToolsEnabled then
        return
    end

    local a = p.Character

    if not a then
        return
    end

    local b = a:FindFirstChildOfClass('Tool')

    if not b then
        return
    end

    for c, d in pairs(b:GetDescendants())do
        if d:IsA('BasePart') or d:IsA('MeshPart') then
            if not forceFieldToolsOriginalData[d] then
                forceFieldToolsOriginalData[d] = {
                    Material = d.Material,
                    Color = d.Color,
                }
            end

            d.Material = Enum.Material.ForceField
            d.Color = forceFieldToolsColor
        end
    end
end
local function restoreToolMaterial()
    local a = p.Character

    if not a then
        return
    end

    local b = a:FindFirstChildOfClass('Tool')

    if not b then
        return
    end

    for c, d in pairs(b:GetDescendants())do
        if d:IsA('BasePart') or d:IsA('MeshPart') then
            if forceFieldToolsOriginalData[d] then
                d.Material = forceFieldToolsOriginalData[d].Material
                d.Color = forceFieldToolsOriginalData[d].Color
            end
        end
    end
end

task.spawn(function()
    while true do
        RunService.Heartbeat:Wait()

        if forceFieldToolsEnabled then
            applyForceFieldToTool()
        end
    end
end)

local function setupForceFieldToolHandlers(a)
    if not a then
        return
    end

    forceFieldToolsOriginalData = {}

    a:WaitForChild('Humanoid')
    task.wait(0.1)

    if forceFieldToolsEnabled then
        applyForceFieldToTool()
    end

    a.ChildAdded:Connect(function(b)
        if b:IsA('Tool') and forceFieldToolsEnabled then
            task.wait(0.05)
            applyForceFieldToTool()
        end
    end)
    a.ChildRemoved:Connect(function(b)
        if b:IsA('Tool') then
            for c, d in pairs(forceFieldToolsOriginalData)do
                if c.Parent == b or c:IsDescendantOf(b) then
                    forceFieldToolsOriginalData[c] = nil
                end
            end
        end
    end)
end

if p.Character then
    setupForceFieldToolHandlers(p.Character)
end

p.CharacterAdded:Connect(setupForceFieldToolHandlers)
Window:AddToggle({
    Title = 'Force Field Tools',
    Description = 'Set tool parts material to ForceField',
    Default = false,
    Tab = VisualsTab,
    Callback = function(a)
        forceFieldToolsEnabled = a

        if a then
            applyForceFieldToTool()
            Window:Notify({
                Title = 'ForceField Tools Enabled',
                Description = 'Tool parts material set to ForceField',
                Duration = 2,
            })
        else
            restoreToolMaterial()

            forceFieldToolsOriginalData = {}

            Window:Notify({
                Title = 'ForceField Tools Disabled',
                Description = 'Tool parts material restored',
                Duration = 2,
            })
        end
    end,
})
Window:AddColorPicker({
    Title = 'ForceField Tools Color',
    Description = 'Set custom color for tool ForceField material',
    Default = Color3.fromRGB(255, 0, 255),
    Tab = VisualsTab,
    Callback = function(a)
        forceFieldToolsColor = a

        if forceFieldToolsEnabled then
            applyForceFieldToTool()
        end
    end,
})
Window:AddSection({
    Name = 'Material Textures',
    Tab = VisualsTab,
})

texturesEnabled = false
selectedTextureTheme = 'minecraft'
textureObjects = {}
texturethemes = {
    minecraft = {
        {
            'Wood',
            '128754006217410',
        },
        {
            'WoodPlanks',
            '8676581022',
        },
        {
            'Brick',
            '8139086777',
        },
        {
            'Cobblestone',
            '17874801808',
        },
        {
            'Concrete',
            '9405731606',
        },
        {
            'DiamondPlate',
            '14197861013',
        },
        {
            'Fabric',
            '9744916443',
        },
        {
            'Granite',
            '4714662147',
        },
        {
            'Grass',
            '9267183930',
        },
        {
            'Ice',
            '11413423466',
        },
        {
            'Marble',
            '14974016515',
        },
        {
            'Metal',
            '14524282848',
        },
        {
            'Sand',
            '11119324718',
        },
        {
            'Slate',
            '7801228489',
        },
    },
    playboi = {
        {
            'Wood',
            '14784281899',
        },
        {
            'WoodPlanks',
            '14784281899',
        },
        {
            'Brick',
            '12647798329',
        },
        {
            'Cobblestone',
            '12647798329',
        },
        {
            'Concrete',
            '12647798329',
        },
        {
            'DiamondPlate',
            '128808789797567',
        },
        {
            'Fabric',
            '128808789797567',
        },
        {
            'Granite',
            '4722586771',
        },
        {
            'Grass',
            '17303981964',
        },
        {
            'Ice',
            '17303981964',
        },
        {
            'Marble',
            '17303981964',
        },
        {
            'Metal',
            '114917525242362',
        },
        {
            'Sand',
            '114917525242362',
        },
        {
            'Slate',
            '114917525242362',
        },
    },
    icey = {
        {
            'Wood',
            '5933003775',
        },
        {
            'WoodPlanks',
            '5933003775',
        },
        {
            'Brick',
            '17295828838',
        },
        {
            'Cobblestone',
            '11760888310',
        },
        {
            'Concrete',
            '109017797659108',
        },
        {
            'DiamondPlate',
            '11760888310',
        },
        {
            'Fabric',
            '140018484507153',
        },
        {
            'Granite',
            '16833201065',
        },
        {
            'Grass',
            '140018484507153',
        },
        {
            'Ice',
            '1090177976591089',
        },
        {
            'Marble',
            '62967586',
        },
        {
            'Metal',
            '11760888310',
        },
        {
            'Sand',
            '16833201065',
        },
        {
            'Slate',
            '7397414089',
        },
    },
}

local function clearTextures()
    for a, b in ipairs(textureObjects)do
        pcall(function()
            b:Destroy()
        end)
    end

    textureObjects = {}

    local a, b = game:GetService('MaterialService'), Enum.Material:GetEnumItems()

    for c, d in ipairs(b)do
        pcall(function()
            a:SetBaseMaterialOverride(d, '')
        end)
    end
end
local function applyTextures()
    clearTextures()

    if not texturesEnabled then
        return
    end

    local a = texturethemes[selectedTextureTheme]

    if not a then
        return
    end

    local b = game:GetService('MaterialService')

    for c, d in ipairs(a)do
        local e, f = d[1], d[2]

        if not f:find('rbxassetid://') and not f:find('http') then
            f = 'rbxassetid://' .. f
        end

        pcall(function()
            local g = Instance.new('MaterialVariant')

            g.Name = 'Texture_' .. e
            g.BaseMaterial = Enum.Material[e]
            g.ColorMap = f
            g.NormalMap = f
            g.RoughnessMap = f
            g.MetalnessMap = f
            g.StudsPerTile = 5
            g.Parent = b

            table.insert(textureObjects, g)
            b:SetBaseMaterialOverride(Enum.Material[e], g.Name)
        end)
    end
end

Window:AddToggleDropdown({
    Title = 'Material Textures',
    Description = 'Override game material textures',
    Options = {
        'minecraft',
        'playboi',
        'icey',
    },
    Default = 'minecraft',
    Enabled = false,
    Tab = VisualsTab,
    ToggleCallback = function(a)
        texturesEnabled = a

        applyTextures()
    end,
    DropdownCallback = function(a)
        selectedTextureTheme = a

        if texturesEnabled then
            applyTextures()
        end
    end,
})
Window:AddSection({
    Name = 'Lighting & Effects',
    Tab = VisualsTab,
})

lighting = game:GetService('Lighting')
lightingEnabled = false
ambientEnabled = false
ambientColor = Color3.fromRGB(255, 123, 123)
fogEnabled = false
fogColor = Color3.fromRGB(80, 80, 120)
timeEnabled = false
timeValue = 12
defaultAmbient = lighting.Ambient
defaultFogColor = lighting.FogColor
defaultTime = lighting.ClockTime

Window:AddToggle({
    Title = 'ENABLES Custom Light Functions',
    Description = 'Enable custom lighting effects',
    Default = false,
    Tab = VisualsTab,
    Callback = function(a)
        lightingEnabled = a

        if not a then
            lighting.Ambient = defaultAmbient
            lighting.FogColor = defaultFogColor
            lighting.ClockTime = defaultTime
            ambientEnabled = false
            timeEnabled = false
        end
    end,
})
Window:AddToggle({
    Title = 'Custom Ambient',
    Description = 'Change ambient lighting color',
    Default = false,
    Tab = VisualsTab,
    Callback = function(a)
        ambientEnabled = a

        if not a then
            lighting.Ambient = defaultAmbient
        end
    end,
})
Window:AddColorPicker({
    Title = 'Ambient Color',
    Description = 'Set ambient light color',
    Default = Color3.fromRGB(255, 123, 123),
    Tab = VisualsTab,
    Callback = function(a)
        ambientColor = a
    end,
})
Window:AddToggle({
    Title = 'Custom Time',
    Description = 'Lock time of day',
    Default = false,
    Tab = VisualsTab,
    Callback = function(a)
        timeEnabled = a

        if not a then
            lighting.ClockTime = defaultTime
        end
    end,
})
Window:AddSlider({
    Title = 'Time Value',
    Description = 'Set time of day (0-24)',
    Tab = VisualsTab,
    Default = 12,
    MinValue = 0,
    MaxValue = 24,
    AllowDecimals = true,
    Callback = function(a)
        timeValue = a
    end,
})

ccEnabled = false
ccEffect = nil
ccSaturation = 0
ccContrast = 0
ccBrightness = 0

Window:AddToggle({
    Title = 'Color Correction',
    Description = 'Apply color correction effect',
    Default = false,
    Tab = VisualsTab,
    Callback = function(a)
        ccEnabled = a

        if a then
            if ccEffect then
                ccEffect:Destroy()
            end

            ccEffect = Instance.new('ColorCorrectionEffect')
            ccEffect.Name = 'CustomColorCorrection'
            ccEffect.Parent = lighting
            ccEffect.Saturation = ccSaturation
            ccEffect.Contrast = ccContrast
            ccEffect.Brightness = ccBrightness
            ccEffect.Enabled = true
        else
            if ccEffect then
                ccEffect:Destroy()

                ccEffect = nil
            end
        end
    end,
})
Window:AddSlider({
    Title = 'Saturation',
    Description = 'Adjust color saturation (-1 to 1)',
    Tab = VisualsTab,
    Default = 0,
    MinValue = -1,
    MaxValue = 1,
    AllowDecimals = true,
    Callback = function(a)
        ccSaturation = a

        if ccEffect then
            ccEffect.Saturation = a
        end
    end,
})
Window:AddSlider({
    Title = 'Contrast',
    Description = 'Adjust contrast (-1 to 1)',
    Tab = VisualsTab,
    Default = 0,
    MinValue = -1,
    MaxValue = 1,
    AllowDecimals = true,
    Callback = function(a)
        ccContrast = a

        if ccEffect then
            ccEffect.Contrast = a
        end
    end,
})
Window:AddSlider({
    Title = 'Brightness',
    Description = 'Adjust brightness (-1 to 1)',
    Tab = VisualsTab,
    Default = 0,
    MinValue = -1,
    MaxValue = 1,
    AllowDecimals = true,
    Callback = function(a)
        ccBrightness = a

        if ccEffect then
            ccEffect.Brightness = a
        end
    end,
})
task.spawn(function()
    while true do
        RunService.Heartbeat:Wait()

        if lightingEnabled then
            if ambientEnabled then
                lighting.Ambient = ambientColor
            end
            if timeEnabled then
                lighting.ClockTime = timeValue
            end
        end
    end
end)
p.CharacterAdded:Connect(function(a)
    task.wait(0.5)
    saveOriginalLegProperties()

    if auraEnabled then
        createAura(a)
    end
    if chinaHatEnabled then
        createChinaHat(a)
    end
    if headlessEnabled then
        applyHeadless(true)
    end
    if korbloxEnabled then
        applyKorblox()
    end
end)
Window:AddSection({
    Name = 'Watermark',
    Tab = VisualsTab,
})

watermarkEnabled = false
watermarkText1 = nil
watermarkText2 = nil
watermarkText3 = nil
watermarkElapsedTime = 0
watermarkCycle = false
watermarkNewValue = 0
watermarkOldValue = 0
watermarkCooldown = true
watermarkOffsetX = 0
watermarkOffsetY = 0
watermarkTargetOffsetX = 0
watermarkTargetOffsetY = 0
watermarkHeartagramColor = Color3.fromRGB(226, 226, 226)
watermarkHubColor = Color3.fromRGB(255, 123, 189)
watermarkSafeColor = Color3.fromRGB(0, 255, 0)
watermarkUnsafeColor = Color3.fromRGB(255, 0, 0)

local function createWatermark()
    if watermarkText1 then
        watermarkText1:Remove()
        watermarkText2:Remove()

        if watermarkText3 then
            watermarkText3:Remove()
        end

        watermarkText1 = nil
        watermarkText2 = nil
        watermarkText3 = nil
    end
    if not watermarkEnabled then
        return
    end

    watermarkText1 = Drawing.new('Text')
    watermarkText1.Text = 'heartagram'
    watermarkText1.Size = 18
    watermarkText1.Center = false
    watermarkText1.Outline = true
    watermarkText1.Color = watermarkHeartagramColor
    watermarkText1.Visible = true
    watermarkText1.Font = 3
    watermarkText2 = Drawing.new('Text')
    watermarkText2.Text = 'hub'
    watermarkText2.Size = 18
    watermarkText2.Center = false
    watermarkText2.Outline = true
    watermarkText2.Color = watermarkHubColor
    watermarkText2.Visible = true
    watermarkText2.Font = 3
    watermarkText3 = Drawing.new('Text')
    watermarkText3.Text = VoidHideSettings.Enabled and 'Safe' or 'Unsafe'
    watermarkText3.Size = 14
    watermarkText3.Center = false
    watermarkText3.Outline = true
    watermarkText3.Color = VoidHideSettings.Enabled and watermarkSafeColor or watermarkUnsafeColor
    watermarkText3.Visible = true
    watermarkText3.Font = 3
end

Window:AddToggle({
    Title = 'Watermark',
    Description = 'Display watermark on screen',
    Default = false,
    Tab = VisualsTab,
    Callback = function(a)
        watermarkEnabled = a

        createWatermark()
    end,
})
Window:AddColorPicker({
    Title = 'Heartagram Color',
    Description = "Color for 'heartagram' text",
    Default = Color3.fromRGB(226, 226, 226),
    Tab = VisualsTab,
    Callback = function(a)
        watermarkHeartagramColor = a

        if watermarkText1 then
            watermarkText1.Color = a
        end
    end,
})
Window:AddColorPicker({
    Title = 'Hub Color',
    Description = "Color for 'hub' text",
    Default = Color3.fromRGB(255, 123, 189),
    Tab = VisualsTab,
    Callback = function(a)
        watermarkHubColor = a

        if watermarkText2 then
            watermarkText2.Color = a
        end
    end,
})
Window:AddColorPicker({
    Title = 'Safe Color',
    Description = "Color for 'Safe' status text",
    Default = Color3.fromRGB(0, 255, 0),
    Tab = VisualsTab,
    Callback = function(a)
        watermarkSafeColor = a

        if watermarkText3 and VoidHideSettings.Enabled then
            watermarkText3.Color = a
        end
    end,
})
Window:AddColorPicker({
    Title = 'Unsafe Color',
    Description = "Color for 'Unsafe' status text",
    Default = Color3.fromRGB(255, 0, 0),
    Tab = VisualsTab,
    Callback = function(a)
        watermarkUnsafeColor = a

        if watermarkText3 and not VoidHideSettings.Enabled then
            watermarkText3.Color = a
        end
    end,
})
RunService.RenderStepped:Connect(function(a)
    if not watermarkEnabled or not watermarkText1 or not watermarkText2 then
        return
    end

    watermarkElapsedTime = watermarkElapsedTime + a

    local b, c = watermarkText1.TextBounds, watermarkText2.TextBounds
    local d, e = b.X + c.X + 4, workspace.CurrentCamera.ViewportSize
    local f, g = Vector2.new(e.X / 2 - d / 2, e.Y / 2 - 9), 0.1

    watermarkOffsetX = watermarkOffsetX + (watermarkTargetOffsetX - watermarkOffsetX) * g
    watermarkOffsetY = watermarkOffsetY + (watermarkTargetOffsetY - watermarkOffsetY) * g

    local h = f + Vector2.new(watermarkOffsetX, watermarkOffsetY)

    watermarkText1.Position = h
    watermarkText2.Position = h + Vector2.new(b.X + 4, 0)

    if watermarkText3 then
        watermarkText3.Text = VoidHideSettings.Enabled and 'Safe' or 'Unsafe'
        watermarkText3.Color = VoidHideSettings.Enabled and watermarkSafeColor or watermarkUnsafeColor
        watermarkText3.Position = h + Vector2.new(0, 20)
    end
    if watermarkElapsedTime < 0.4 then
        local i = TweenService:GetValue((watermarkElapsedTime / 0.4), Enum.EasingStyle.Circular, (not watermarkCycle) and Enum.EasingDirection.Out or Enum.EasingDirection.In)

        watermarkText2.Transparency = watermarkOldValue + (watermarkNewValue - watermarkOldValue) * i
    elseif watermarkCooldown then
        watermarkCooldown = false
        watermarkText2.Transparency = watermarkCycle and 0 or 1
        watermarkCycle = not watermarkCycle
        watermarkNewValue = watermarkCycle and 0 or 1
        watermarkOldValue = watermarkCycle and 1 or 0

        task.delay(0.4, function()
            watermarkElapsedTime = 0
            watermarkCooldown = true
        end)
    end

    local i = UserInputService.MouseBehavior

    if i == Enum.MouseBehavior.LockCenter then
        watermarkTargetOffsetX = 10
        watermarkTargetOffsetY = 25
    else
        watermarkTargetOffsetX = 0
        watermarkTargetOffsetY = 0
    end
end)
Window:AddSection({
    Name = 'Chams',
    Tab = VisualsTab,
})

chamsEnabled = false
ChamsToggleElement = nil
ChamsToggle = Window:AddToggleMultiSelect({
    Title = 'Chams',
    Description = '\u{412}\u{43a}\u{43b}\u{44e}\u{447}\u{438}\u{442}\u{44c} Chams \u{434}\u{43b}\u{44f} \u{432}\u{44b}\u{431}\u{440}\u{430}\u{43d}\u{43d}\u{44b}\u{445} \u{440}\u{43e}\u{43b}\u{435}\u{439}',
    Options = {
        'Murderer',
        'Sheriff',
        'Innocent',
        'Hero',
    },
    Enabled = false,
    Tab = VisualsTab,
    ToggleCallback = function(a)
        chamsEnabled = a

        if not a then
            ESP_SETTINGS.Murderer = false
            ESP_SETTINGS.Sheriff = false
            ESP_SETTINGS.Innocent = false
            ESP_SETTINGS.Hero = false

            for b, c in ipairs(ps:GetPlayers())do
                RemoveESP(c)
            end
        else
            local b = false

            if ChamsToggleElement then
                local c = ChamsToggleElement.GetValue()

                if c and c.selectedItems then
                    for d, e in pairs(c.selectedItems)do
                        if e then
                            b = true

                            break
                        end
                    end
                end
            end
            if not b then
                ESP_SETTINGS.Murderer = true
                ESP_SETTINGS.Sheriff = true
                ESP_SETTINGS.Innocent = true
                ESP_SETTINGS.Hero = true
            else
                if ChamsToggleElement then
                    local c = ChamsToggleElement.GetValue()

                    if c and c.selectedItems then
                        ESP_SETTINGS.Murderer = c.selectedItems['Murderer'] or false
                        ESP_SETTINGS.Sheriff = c.selectedItems['Sheriff'] or false
                        ESP_SETTINGS.Innocent = c.selectedItems['Innocent'] or false
                        ESP_SETTINGS.Hero = c.selectedItems['Hero'] or false
                    end
                end
            end
        end
    end,
    DropdownCallback = function(a)
        if not chamsEnabled then
            return
        end

        ESP_SETTINGS.Murderer = false
        ESP_SETTINGS.Sheriff = false
        ESP_SETTINGS.Innocent = false
        ESP_SETTINGS.Hero = false

        for b, c in ipairs(a)do
            if c == 'Murderer' then
                ESP_SETTINGS.Murderer = true
            elseif c == 'Sheriff' then
                ESP_SETTINGS.Sheriff = true
            elseif c == 'Innocent' then
                ESP_SETTINGS.Innocent = true
            elseif c == 'Hero' then
                ESP_SETTINGS.Hero = true
            end
        end
    end,
})
ChamsToggleElement = ChamsToggle

Window:AddSection({
    Name = 'ESP',
    Tab = VisualsTab,
})

local a, b, c, d, e, f

nameESPEnabled = false
NameESPToggleElement = nil
NameESPToggle = Window:AddToggleMultiSelect({
    Title = 'Name ESP',
    Description = '\u{41f}\u{43e}\u{43a}\u{430}\u{437}\u{430}\u{442}\u{44c} \u{43d}\u{438}\u{43a}\u{438} \u{43d}\u{430}\u{434} \u{433}\u{43e}\u{43b}\u{43e}\u{432}\u{43e}\u{439} \u{434}\u{43b}\u{44f} \u{432}\u{44b}\u{431}\u{440}\u{430}\u{43d}\u{43d}\u{44b}\u{445} \u{440}\u{43e}\u{43b}\u{435}\u{439}',
    Options = {
        'Murderer',
        'Sheriff',
        'Innocent',
        'Hero',
    },
    Enabled = false,
    Tab = VisualsTab,
    ToggleCallback = function(g)
        nameESPEnabled = g

        if not g then
            NAME_ESP_SETTINGS.Murderer = false
            NAME_ESP_SETTINGS.Sheriff = false
            NAME_ESP_SETTINGS.Innocent = false
            NAME_ESP_SETTINGS.Hero = false

            for h, i in ipairs(ps:GetPlayers())do
                b(i)
            end
        else
            local h = false

            if NameESPToggleElement then
                local i = NameESPToggleElement.GetValue()

                if i and i.selectedItems then
                    for j, k in pairs(i.selectedItems)do
                        if k then
                            h = true

                            break
                        end
                    end
                end
            end
            if not h then
                NAME_ESP_SETTINGS.Murderer = true
                NAME_ESP_SETTINGS.Sheriff = true
                NAME_ESP_SETTINGS.Innocent = true
                NAME_ESP_SETTINGS.Hero = true
            else
                if NameESPToggleElement then
                    local i = NameESPToggleElement.GetValue()

                    if i and i.selectedItems then
                        NAME_ESP_SETTINGS.Murderer = i.selectedItems['Murderer'] or false
                        NAME_ESP_SETTINGS.Sheriff = i.selectedItems['Sheriff'] or false
                        NAME_ESP_SETTINGS.Innocent = i.selectedItems['Innocent'] or false
                        NAME_ESP_SETTINGS.Hero = i.selectedItems['Hero'] or false
                    end
                end
            end
        end
    end,
    DropdownCallback = function(g)
        if not nameESPEnabled then
            return
        end

        NAME_ESP_SETTINGS.Murderer = false
        NAME_ESP_SETTINGS.Sheriff = false
        NAME_ESP_SETTINGS.Innocent = false
        NAME_ESP_SETTINGS.Hero = false

        for h, i in ipairs(g)do
            if i == 'Murderer' then
                NAME_ESP_SETTINGS.Murderer = true
            elseif i == 'Sheriff' then
                NAME_ESP_SETTINGS.Sheriff = true
            elseif i == 'Innocent' then
                NAME_ESP_SETTINGS.Innocent = true
            elseif i == 'Hero' then
                NAME_ESP_SETTINGS.Hero = true
            end
        end
    end,
})
NameESPToggleElement = NameESPToggle
ROLE_COLORS = {
    Murderer = Color3.fromRGB(255, 0, 0),
    Sheriff = Color3.fromRGB(0, 0, 255),
    Hero = Color3.fromRGB(255, 255, 0),
    Innocent = Color3.fromRGB(0, 255, 0),
}

Window:AddSection({
    Name = 'Role Colors',
    Tab = VisualsTab,
})
Window:AddColorPicker({
    Title = 'Murderer Color',
    Description = '\u{426}\u{432}\u{435}\u{442} \u{434}\u{43b}\u{44f} \u{443}\u{431}\u{438}\u{439}\u{446}\u{44b}',
    Default = Color3.fromRGB(255, 0, 0),
    Tab = VisualsTab,
    Callback = function(g)
        ROLE_COLORS.Murderer = g
    end,
})
Window:AddColorPicker({
    Title = 'Sheriff Color',
    Description = '\u{426}\u{432}\u{435}\u{442} \u{434}\u{43b}\u{44f} \u{448}\u{435}\u{440}\u{438}\u{444}\u{430}',
    Default = Color3.fromRGB(0, 0, 255),
    Tab = VisualsTab,
    Callback = function(g)
        ROLE_COLORS.Sheriff = g
    end,
})
Window:AddColorPicker({
    Title = 'Innocent Color',
    Description = '\u{426}\u{432}\u{435}\u{442} \u{434}\u{43b}\u{44f} \u{43d}\u{435}\u{432}\u{438}\u{43d}\u{43e}\u{432}\u{43d}\u{44b}\u{445}',
    Default = Color3.fromRGB(0, 255, 0),
    Tab = VisualsTab,
    Callback = function(g)
        ROLE_COLORS.Innocent = g
    end,
})
Window:AddColorPicker({
    Title = 'Hero Color',
    Description = '\u{426}\u{432}\u{435}\u{442} \u{434}\u{43b}\u{44f} \u{433}\u{435}\u{440}\u{43e}\u{44f}',
    Default = Color3.fromRGB(255, 255, 0),
    Tab = VisualsTab,
    Callback = function(g)
        ROLE_COLORS.Hero = g
    end,
})
Window:AddSection({
    Name = 'ESP Customization',
    Tab = VisualsTab,
})
Window:AddMultiSelect({
    Title = 'ESP Options',
    Description = '\u{412}\u{44b}\u{431}\u{435}\u{440}\u{438}\u{442}\u{435} \u{43f}\u{430}\u{440}\u{430}\u{43c}\u{435}\u{442}\u{440}\u{44b} \u{43e}\u{442}\u{43e}\u{431}\u{440}\u{430}\u{436}\u{435}\u{43d}\u{438}\u{44f} ESP',
    Options = {
        '2D Box',
        'Display Name',
        'Username',
        'Avatar Display',
    },
    Default = {
        'Username',
    },
    Tab = VisualsTab,
    Callback = function(g)
        ESP_CUSTOMIZATION.Box2D = false
        ESP_CUSTOMIZATION.DisplayName = false
        ESP_CUSTOMIZATION.NormalName = false
        ESP_CUSTOMIZATION.AvatarDisplay = false

        for h, i in ipairs(g)do
            if i == '2D Box' then
                ESP_CUSTOMIZATION.Box2D = true
            elseif i == 'Display Name' then
                ESP_CUSTOMIZATION.DisplayName = true
            elseif i == 'Username' then
                ESP_CUSTOMIZATION.NormalName = true
            elseif i == 'Avatar Display' then
                ESP_CUSTOMIZATION.AvatarDisplay = true
            end
        end

        if ESP_CUSTOMIZATION.DisplayName and ESP_CUSTOMIZATION.NormalName then
        end
    end,
})

MiscTab = Window:AddTab({
    Title = 'Misc',
    Icon = 'rbxassetid://11963373994',
})
SpawnerTab = Window:AddTab({
    Title = 'Spawner',
    Icon = 'rbxassetid://11963373994',
})
spawnerItems = {
    {
        original = 'Harvester',
        custom = 'Harvester',
    },
    {
        original = 'Gingerscope',
        custom = 'Gingerscope',
    },
    {
        original = 'Snowcannon',
        custom = 'Snowcannon',
    },
    {
        original = 'Bauble',
        custom = 'Bauble',
    },
    {
        original = 'BaubleChroma',
        custom = 'BaubleChroma',
    },
    {
        original = 'Icepiercer',
        custom = 'Icepiercer',
    },
    {
        original = 'TreeGun2023',
        custom = 'Evergun',
    },
    {
        original = 'TreeKnife2023',
        custom = 'Evergreen',
    },
    {
        original = 'TreeGun2023Chroma',
        custom = 'Chroma Evergun',
    },
    {
        original = 'TreeKnife2023Chroma',
        custom = 'Chroma Evergreen',
    },
    {
        original = 'Bloom',
        custom = 'Bloom',
    },
    {
        original = 'Flora',
        custom = 'Flora',
    },
    {
        original = 'TravelerAxe',
        custom = 'Traveler Axe',
    },
    {
        original = 'TravelerGun',
        custom = 'Traveler Gun',
    },
    {
        original = 'TravelerAxeChroma',
        custom = 'Chroma Traveler Axe',
    },
    {
        original = 'TravelerGunChroma',
        custom = 'Chroma Traveler Gun',
    },
    {
        original = 'Celestial',
        custom = 'Celestial',
    },
    {
        original = 'Constellation',
        custom = 'Constellation',
    },
    {
        original = 'ConstellationChroma',
        custom = 'Chroma Constellation',
    },
    {
        original = 'Candy',
        custom = 'Candy',
    },
    {
        original = 'Sugar',
        custom = 'Sugar',
    },
    {
        original = 'Darksword',
        custom = 'Darksword',
    },
    {
        original = 'Darkshot',
        custom = 'Darkshot',
    },
    {
        original = 'VampireAxe',
        custom = 'Vampire Axe',
    },
    {
        original = 'VampireGun',
        custom = 'Vampire Gun',
    },
    {
        original = 'SwirlyAxe',
        custom = 'Swirly Axe',
    },
    {
        original = 'SwirlyGun',
        custom = 'Swirly Gun',
    },
    {
        original = 'Flowerwood',
        custom = 'Flowerwood',
    },
    {
        original = 'FlowerwoodGun',
        custom = 'Flowerwood Gun',
    },
    {
        original = 'VampireGunChroma',
        custom = 'Chroma Vampire Gun',
    },
    {
        original = 'WatergunChroma',
        custom = 'Chroma Watergun',
    },
    {
        original = 'Turkey2023',
        custom = 'Turkey',
    },
    {
        original = 'Sakura_K',
        custom = 'Sakura',
    },
    {
        original = 'Blossom_G',
        custom = 'Blossom',
    },
    {
        original = 'Makeshift',
        custom = 'Makeshift',
    },
    {
        original = 'Sorry',
        custom = 'Corrupt',
    },
    {
        original = 'HeartWand',
        custom = 'HeartWand',
    },
}

local function spawnItem(g)
    local h = pcall(function()
        local h = require(game:GetService('ReplicatedStorage').Modules.ProfileData)
        local i, j = h.Weapons, g

        for k, l in ipairs(spawnerItems)do
            if l.custom == g then
                j = l.original

                break
            end
        end

        if not i.Owned[j] then
            i.Owned[j] = 1
        else
            i.Owned[j] += 1
        end

        h.Weapons = i

        local k = game:GetService('ReplicatedStorage'):FindFirstChild('Remotes')

        if k then
            local l = k:FindFirstChild('Inventory')

            if l then
                local m = l:FindFirstChild('ChangeInventoryItem')

                if m then
                    m:FireServer(j, 'Add')
                end

                local n = l:FindFirstChild('InventoryDataChanged')

                if n then
                    n:Fire()
                end
            end
        end
    end)

    return h
end

Window:AddSection({
    Name = 'Item Spawner',
    Tab = SpawnerTab,
})

itemOptions = {}

for g, h in ipairs(spawnerItems)do
    itemOptions[h.custom] = h.custom
end

selectedSpawnerItem = nil

Window:AddDropdown({
    Title = 'Select Item',
    Description = 'Choose an item to spawn',
    Tab = SpawnerTab,
    Options = itemOptions,
    Callback = function(g)
        selectedSpawnerItem = g
    end,
})
Window:AddButton({
    Title = 'Spawn Selected Item',
    Description = 'Spawn the selected item to your inventory',
    Tab = SpawnerTab,
    Callback = function()
        if not selectedSpawnerItem then
            Window:Notify({
                Title = 'No Item Selected',
                Description = 'Please select an item first!',
                Duration = 3,
            })

            return
        end

        local g = spawnItem(selectedSpawnerItem)

        if g then
            Window:Notify({
                Title = 'Item Spawned',
                Description = selectedSpawnerItem .. ' has been added to your inventory!',
                Duration = 3,
            })
        else
            Window:Notify({
                Title = 'Spawn Failed',
                Description = 'Failed to spawn ' .. selectedSpawnerItem,
                Duration = 3,
            })
        end
    end,
})
Window:AddSection({
    Name = 'Quick Spawn',
    Tab = SpawnerTab,
})
Window:AddButton({
    Title = 'Spawn Harvester',
    Description = 'Quickly spawn Harvester',
    Tab = SpawnerTab,
    Callback = function()
        if spawnItem('Harvester') then
            Window:Notify({
                Title = 'Item Spawned',
                Description = 'Harvester has been added!',
                Duration = 2,
            })
        end
    end,
})
Window:AddButton({
    Title = 'Spawn Corrupt',
    Description = 'Quickly spawn Corrupt',
    Tab = SpawnerTab,
    Callback = function()
        if spawnItem('Corrupt') then
            Window:Notify({
                Title = 'Item Spawned',
                Description = 'Corrupt has been added!',
                Duration = 2,
            })
        end
    end,
})
Window:AddButton({
    Title = 'Spawn Chroma Evergun',
    Description = 'Quickly spawn Chroma Evergun',
    Tab = SpawnerTab,
    Callback = function()
        if spawnItem('Chroma Evergun') then
            Window:Notify({
                Title = 'Item Spawned',
                Description = 'Chroma Evergun has been added!',
                Duration = 2,
            })
        end
    end,
})
Window:AddButton({
    Title = 'Spawn Chroma Evergreen',
    Description = 'Quickly spawn Chroma Evergreen',
    Tab = SpawnerTab,
    Callback = function()
        if spawnItem('Chroma Evergreen') then
            Window:Notify({
                Title = 'Item Spawned',
                Description = 'Chroma Evergreen has been added!',
                Duration = 2,
            })
        end
    end,
})

Settings = Window:AddTab({
    Title = 'Settings',
    Icon = 'rbxassetid://11293977610',
})
ConfigFolder = 'HrthConfigs'
ConfigExtension = '.hrth'
currentConfigName = 'default'

if not isfolder(ConfigFolder) then
    makefolder(ConfigFolder)
end

ConfigSettings = {
    autoKillAllEnabled = false,
    autoShootEnabled = false,
    magicBulletEnabled = false,
    isafEnabled = false,
    VoidHideEnabled = false,
    walkSpeedEnabled = false,
    customWalkSpeed = 16,
    jumpPowerEnabled = false,
    customJumpPower = 50,
    isagbEnabled = false,
    selectedTheme = 'Purple',
}

local function getConfigList()
    local g, h = {}, listfiles(ConfigFolder)

    for i, j in pairs(h)do
        local k = j:gsub(ConfigFolder .. '\\', ''):gsub(ConfigFolder .. '/', '')

        if k:sub(-#ConfigExtension) == ConfigExtension then
            local l = k:sub(1, -#ConfigExtension - 1)

            table.insert(g, l)
        end
    end

    if #g == 0 then
        table.insert(g, 'No configs found')
    end

    return g
end
local function saveConfig(g)
    if not g or g == '' or g == 'No configs found' then
        Window:Notify({
            Title = 'Config Error',
            Description = 'Invalid config name!',
            Duration = 3,
        })

        return
    end

    local h = ConfigFolder .. '/' .. g .. ConfigExtension

    ConfigSettings = {}

    local i, j = 0, getgenv().ConfigRegistry or _G.ConfigRegistry

    for k, l in pairs(j)do
        i = i + 1

        local m, n = l.element, l.type

        if m and m.GetValue then
            local o = m.GetValue()

            ConfigSettings[k] = o

            local q

            if type(o) == 'table' then
                if o.R and o.G and o.B then
                    q = string.format('Color(%.2f, %.2f, %.2f)', o.R, o.G, o.B)
                elseif o.enabled ~= nil then
                    q = string.format('{enabled=%s, option=%s}', tostring(o.enabled), tostring(o.option))
                else
                    q = game:GetService('HttpService'):JSONEncode(o)
                end
            else
                q = tostring(o)
            end
        else
        end
    end

    local k, l = pcall(function()
        local k = game:GetService('HttpService'):JSONEncode(ConfigSettings)

        writefile(h, k)
    end)

    if k then
        Window:Notify({
            Title = 'Config Saved',
            Description = "Config '" .. g .. "' saved with " .. i .. ' settings!',
            Duration = 3,
        })
    else
        Window:Notify({
            Title = 'Config Error',
            Description = 'Failed to save config: ' .. tostring(l),
            Duration = 5,
        })
    end
end
local function loadConfig(g)
    if not g or g == '' or g == 'No configs found' then
        Window:Notify({
            Title = 'Config Error',
            Description = 'Invalid config name!',
            Duration = 3,
        })

        return
    end

    local h = ConfigFolder .. '/' .. g .. ConfigExtension

    if not isfile(h) then
        Window:Notify({
            Title = 'Config Error',
            Description = "Config '" .. g .. "' not found!",
            Duration = 3,
        })

        return
    end

    local i, j = pcall(function()
        local i = readfile(h)
        local j, k = game:GetService('HttpService'):JSONDecode(i), 0

        for l in pairs(j)do
            k = k + 1
        end

        local l, m = 0, getgenv().ConfigRegistry or _G.ConfigRegistry

        for n, o in pairs(j)do
            if m[n] then
                local q = m[n]
                local r = q.element

                if r and r.SetValue then
                    r.SetValue(o)

                    l = l + 1
                else
                end
            else
            end
        end
    end)

    if i then
        Window:Notify({
            Title = 'Config Loaded',
            Description = "Config '" .. g .. "' loaded successfully!",
            Duration = 3,
        })
    else
    end
    if i then
        Window:Notify({
            Title = 'Config Loaded',
            Description = "Config '" .. g .. "' loaded successfully!",
            Duration = 3,
        })
    else
        Window:Notify({
            Title = 'Config Error',
            Description = 'Failed to load config: ' .. tostring(j),
            Duration = 5,
        })
    end
end

Window:AddSection({
    Name = 'Config System',
    Tab = Settings,
})

configDropdown = Window:AddSingleSelect({
    Title = 'Select Config',
    Description = 'Choose a config to load or save',
    Tab = Settings,
    Options = getConfigList(),
    Default = getConfigList()[1] or 'default',
    Callback = function(g)
        currentConfigName = g
    end,
})

Window:AddButton({
    Title = 'Refresh Config List',
    Description = 'Refresh the list of available configs',
    Tab = Settings,
    Callback = function()
        local g = getConfigList()

        for h, i in ipairs(g) do end

        if configDropdown and configDropdown.Refresh then
            configDropdown.Refresh(g)
        else
        end

        Window:Notify({
            Title = 'Config List',
            Description = 'Found ' .. #g .. ' config(s)',
            Duration = 2,
        })
    end,
})
Window:AddInput({
    Title = 'New Config Name',
    Description = 'Enter a name for new config',
    Tab = Settings,
    Placeholder = 'Enter config name...',
    Callback = function(g)
        if g and g ~= '' then
            currentConfigName = g
        end
    end,
})
Window:AddButton({
    Title = 'Save Config',
    Description = 'Save current settings to config file',
    Tab = Settings,
    Callback = function()
        saveConfig(currentConfigName)
    end,
})
Window:AddButton({
    Title = 'Load Config',
    Description = 'Load settings from selected config',
    Tab = Settings,
    Callback = function()
        loadConfig(currentConfigName)
    end,
})
Window:AddButton({
    Title = 'Delete Config',
    Description = 'Delete the selected config file',
    Tab = Settings,
    Callback = function()
        if currentConfigName == 'No configs found' or not currentConfigName or currentConfigName == '' then
            Window:Notify({
                Title = 'Config Error',
                Description = 'Invalid config name!',
                Duration = 3,
            })

            return
        end

        local g = ConfigFolder .. '/' .. currentConfigName .. ConfigExtension

        if isfile(g) then
            delfile(g)
            Window:Notify({
                Title = 'Config Deleted',
                Description = "Config '" .. currentConfigName .. "' deleted!",
                Duration = 3,
            })
        else
            Window:Notify({
                Title = 'Config Error',
                Description = 'Config not found!',
                Duration = 3,
            })
        end
    end,
})
Window:AddSection({
    Name = 'UI Settings',
    Tab = Settings,
})
Window:AddKeybind({
    Title = 'Minimize Keybind',
    Description = 'Set the keybind for Minimizing',
    Tab = Settings,
    Callback = function(g)
        Window:SetSetting('Keybind', g)
    end,
})
Window:AddSingleSelect({
    Title = 'Set Theme',
    Description = 'Set the theme of the library!',
    Tab = Settings,
    Options = {
        'Light',
        'Dark',
        'Void',
        'Purple',
    },
    Default = 'Light',
    Callback = function(g)
        Window:SetTheme(Themes[g])

        ConfigSettings.selectedTheme = g
    end,
})
Window:AddSlider({
    Title = 'UI Transparency',
    Description = 'Set the transparency of the UI',
    Tab = Settings,
    AllowDecimals = true,
    MaxValue = 1,
    Callback = function(g)
        Window:SetSetting('Transparency', g)
    end,
})
Window:Notify({
    Title = 'Heartagram Hub',
    Description = 'Press Left Alt to Minimize and Open the tab!',
    Duration = 10,
})

Players = game:GetService('Players')
ReplicatedStorage = game:GetService('ReplicatedStorage')
GetPlayerData = ReplicatedStorage:FindFirstChild('GetPlayerData', true)
ESP_SETTINGS = {
    Murderer = false,
    Sheriff = false,
    Innocent = false,
    Hero = false,
}
NAME_ESP_SETTINGS = {
    Murderer = false,
    Sheriff = false,
    Innocent = false,
    Hero = false,
}
ESP_CUSTOMIZATION = {
    Box2D = false,
    DisplayName = false,
    NormalName = true,
    AvatarDisplay = false,
}
c = function(g, h)
    if not g.Character then
        return
    end

    local i = g.Character:FindFirstChild('RoleESP')

    if not i then
        i = Instance.new('Highlight')
        i.Name = 'RoleESP'
        i.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        i.FillTransparency = 0.5
        i.OutlineTransparency = 0
        i.Parent = g.Character
    end

    i.FillColor = h
    i.OutlineColor = h
end
d = function(g)
    if g.Character then
        local h = g.Character:FindFirstChild('RoleESP')

        if h then
            h:Destroy()
        end
    end
end
e = function(g, h)
    if not g.Character then
        return
    end

    local i = g.Character:FindFirstChild('HumanoidRootPart')

    if not i then
        return
    end

    local j = i:FindFirstChild('Box2D')

    if ESP_CUSTOMIZATION.Box2D then
        if not j then
            j = Instance.new('BillboardGui')
            j.Name = 'Box2D'
            j.AlwaysOnTop = true
            j.Size = UDim2.new(4, 0, 5, 0)
            j.StudsOffset = Vector3.new(0, 0, 0)
            j.Parent = i

            local k = Instance.new('Frame')

            k.Name = 'BoxFrame'
            k.BackgroundTransparency = 1
            k.Size = UDim2.new(1, 0, 1, 0)
            k.BorderSizePixel = 2
            k.Parent = j

            local l = Instance.new('UIStroke')

            l.Name = 'Stroke'
            l.Thickness = 2
            l.Parent = k
        end

        local k = j:FindFirstChild('BoxFrame')

        if k then
            local l = k:FindFirstChild('Stroke')

            if l then
                l.Color = h
            end
        end
    else
        if j then
            j:Destroy()
        end
    end
end
a = function(g, h)
    if not g.Character then
        return
    end

    local i, j = g.Character:FindFirstChild('Head'), g.Character:FindFirstChild('HumanoidRootPart')

    if not i or not j then
        return
    end

    local k = i:FindFirstChild('NameESP')

    if not k then
        k = Instance.new('BillboardGui')
        k.Name = 'NameESP'
        k.AlwaysOnTop = true
        k.Size = UDim2.new(0, 200, 0, 80)
        k.StudsOffset = Vector3.new(0, 2, 0)
        k.Parent = i

        local l = Instance.new('Frame')

        l.Name = 'AvatarFrame'
        l.BackgroundColor3 = Color3.new(1, 1, 1)
        l.Size = UDim2.new(0, 40, 0, 40)
        l.Position = UDim2.new(0.5, -20, 0, 0)
        l.BorderSizePixel = 2
        l.Parent = k

        local m = Instance.new('UICorner')

        m.CornerRadius = UDim.new(1, 0)
        m.Parent = l

        local n = Instance.new('ImageLabel')

        n.Name = 'Avatar'
        n.BackgroundTransparency = 1
        n.Size = UDim2.new(1, 0, 1, 0)
        n.Image = ps:GetUserThumbnailAsync(g.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
        n.Parent = l

        local o = Instance.new('UICorner')

        o.CornerRadius = UDim.new(1, 0)
        o.Parent = n

        local q = Instance.new('TextLabel')

        q.Name = 'NameLabel'
        q.BackgroundTransparency = 1
        q.Size = UDim2.new(0, 200, 0, 20)
        q.Position = UDim2.new(0, 0, 0, 45)
        q.Font = Enum.Font.GothamBold
        q.TextSize = 14
        q.TextStrokeTransparency = 0
        q.TextStrokeColor3 = Color3.new(0, 0, 0)
        q.Parent = k
    end

    local l, m = k:FindFirstChild('AvatarFrame'), k:FindFirstChild('NameLabel')

    if m then
        if ESP_CUSTOMIZATION.DisplayName then
            m.Text = g.DisplayName
        elseif ESP_CUSTOMIZATION.NormalName then
            m.Text = g.Name
        else
            m.Text = ''
        end

        m.TextColor3 = h
    end
    if l then
        l.Visible = ESP_CUSTOMIZATION.AvatarDisplay
        l.BorderColor3 = h
    end

    e(g, h)
end
b = function(g)
    if g.Character then
        local h = g.Character:FindFirstChild('Head')

        if h then
            local i = h:FindFirstChild('NameESP')

            if i then
                i:Destroy()
            end
        end

        local i = g.Character:FindFirstChild('HumanoidRootPart')

        if i then
            local j = i:FindFirstChild('Box2D')

            if j then
                j:Destroy()
            end
        end
    end
end
f = function()
    local g, h = pcall(function()
        return GetPlayerData:InvokeServer()
    end)

    if not g then
        return
    end

    for i, j in ipairs(ps:GetPlayers())do
        if j ~= ps.LocalPlayer and j:GetAttribute('Alive') == true then
            local k, l = 'Innocent', h[j.Name]

            if l and l.Role then
                k = l.Role
            end

            local m = ROLE_COLORS[k] or ROLE_COLORS.Innocent

            if ESP_SETTINGS[k] == true then
                c(j, m)
            else
                d(j)
            end
            if NAME_ESP_SETTINGS[k] == true then
                a(j, m)
            else
                b(j)
            end
        else
            d(j)
            b(j)
        end
    end
end

local function findmap()
    for g, h in (game.Workspace:GetChildren())do
        if h:GetAttribute('MapID') then
            return h
        end
    end
end

Window:AddButton({
    Title = 'Map TP',
    Description = 'Teleports you in map',
    Tab = MiscTab,
    Callback = function()
        if not p then
            return
        end

        local g = p.Character

        if not g or not g.Parent then
            return
        end

        for h, i in (findmap().Spawns:GetChildren())do
            g.HumanoidRootPart.CFrame = i.CFrame

            return
        end
    end,
})
Window:AddButton({
    Title = 'Lobby TP',
    Description = 'Teleports you in Lobby',
    Tab = MiscTab,
    Callback = function()
        if not p then
            return
        end

        local g = p.Character

        if not g or not g.Parent then
            return
        end

        for h, i in (workspace.RegularLobby.Spawns:GetChildren())do
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = i.CFrame

            return
        end
    end,
})
Window:AddButton({
    Title = 'Murder TP',
    Description = 'Teleports you to Murder',
    Tab = MiscTab,
    Callback = function()
        if not p then
            return
        end

        local g = p.Character

        if not g or not g.Parent then
            return
        end

        local h, i = pcall(function()
            return GetPlayerData:InvokeServer()
        end)

        if h and i then
            for j, k in pairs(ps:GetPlayers())do
                if k ~= p and k:GetAttribute('Alive') == true then
                    local l = i[k.Name]

                    if l and l.Role == 'Murderer' and k.Character then
                        g.HumanoidRootPart.CFrame = k.Character.HumanoidRootPart.CFrame

                        return
                    end
                end
            end
        end
    end,
})
Window:AddButton({
    Title = 'Sheriff TP',
    Description = 'Teleports you to Sheriff',
    Tab = MiscTab,
    Callback = function()
        if not p then
            return
        end

        local g = p.Character

        if not g or not g.Parent then
            return
        end

        local h, i = pcall(function()
            return GetPlayerData:InvokeServer()
        end)

        if h and i then
            for j, k in pairs(ps:GetPlayers())do
                if k ~= p and k:GetAttribute('Alive') == true then
                    local l = i[k.Name]

                    if l and l.Role == 'Sheriff' and k.Character then
                        g.HumanoidRootPart.CFrame = k.Character.HumanoidRootPart.CFrame

                        return
                    end
                end
            end
        end
    end,
})
Window:AddSection({
    Name = 'Dance Emotes',
    Tab = MiscTab,
})

danceEnabled = false
selectedDanceId = '127118661424463'
currentDanceTrack = nil
danceList = {
    ['Dance 1'] = '127118661424463',
    ['Dance 2'] = '82682811348660',
    ['Dance 3'] = '10714340543',
    ['Dance 4'] = '15609995579',
}

local function playDance()
    if not p.Character then
        return
    end
    if not selectedDanceId then
        return
    end

    local g = p.Character:FindFirstChildOfClass('Humanoid')

    if not g then
        return
    end

    local h = g:FindFirstChildOfClass('Animator')

    if not h then
        h = Instance.new('Animator')
        h.Parent = g
    end
    if currentDanceTrack then
        pcall(function()
            currentDanceTrack:Stop()
        end)
        task.wait(0.1)
        pcall(function()
            currentDanceTrack:Destroy()
        end)

        currentDanceTrack = nil
    end

    task.wait(0.1)

    local i = Instance.new('Animation')

    i.AnimationId = 'rbxassetid://' .. tostring(selectedDanceId)

    local j, k = pcall(function()
        currentDanceTrack = h:LoadAnimation(i)
        currentDanceTrack.Looped = true
        currentDanceTrack.Priority = Enum.AnimationPriority.Action

        currentDanceTrack:Play(0.1, 1, 1)
    end)

    if not j then
    else
    end

    i:Destroy()
end
local function stopDance()
    if currentDanceTrack then
        pcall(function()
            currentDanceTrack:Stop()
            currentDanceTrack:Destroy()
        end)

        currentDanceTrack = nil
    end
end

p.CharacterAdded:Connect(function(g)
    g:WaitForChild('Humanoid')
    task.wait(0.5)

    if danceEnabled then
        playDance()
    end
end)
Window:AddToggleDropdown({
    Title = 'Auto Dance',
    Description = 'Automatically play selected dance (persists through respawns)',
    Options = {
        'Dance 1',
        'Dance 2',
        'Dance 3',
        'Dance 4',
    },
    Default = 'Dance 1',
    Enabled = false,
    Tab = MiscTab,
    ToggleCallback = function(g)
        danceEnabled = g

        if g then
            playDance()
        else
            stopDance()
        end
    end,
    DropdownCallback = function(g)
        local h = danceList[g]

        if h then
            selectedDanceId = h

            if danceEnabled then
                stopDance()
                task.wait(0.2)
                playDance()
            end
        end
    end,
})
Window:AddSection({
    Name = 'Fling Players',
    Tab = MiscTab,
})

local function SkidFling(g)
    local h = p.Character
    local i = h and h:FindFirstChildOfClass('Humanoid')
    local j, k = i and i.RootPart, g.Character

    if not k then
        return
    end

    local l, m, n, o, q

    if k:FindFirstChildOfClass('Humanoid') then
        l = k:FindFirstChildOfClass('Humanoid')
    end
    if l and l.RootPart then
        m = l.RootPart
    end
    if k:FindFirstChild('Head') then
        n = k.Head
    end
    if k:FindFirstChildOfClass('Accessory') then
        o = k:FindFirstChildOfClass('Accessory')
    end
    if o and o:FindFirstChild('Handle') then
        q = o.Handle
    end
    if h and i and j then
        if j.Velocity.Magnitude < 50 then
            getgenv().OldPos = j.CFrame
        end
        if l and l.Sit then
            return
        end
        if n then
            workspace.CurrentCamera.CameraSubject = n
        elseif q then
            workspace.CurrentCamera.CameraSubject = q
        elseif l and m then
            workspace.CurrentCamera.CameraSubject = l
        end
        if not k:FindFirstChildWhichIsA('BasePart') then
            return
        end

        local r = function(r, s, t)
            j.CFrame = CFrame.new(r.Position) * s * t

            h:SetPrimaryPartCFrame(CFrame.new(r.Position) * s * t)

            j.Velocity = Vector3.new(9e7, 9e7 * 10, 9e7)
            j.RotVelocity = Vector3.new(9e8, 9e8, 9e8)
        end
        local s = function(s)
            local t, u, v = 2, tick(), 0

            repeat
                if j and l then
                    if s.Velocity.Magnitude < 50 then
                        v = v + 100

                        r(s, CFrame.new(0, 1.5, 0) + l.MoveDirection * s.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(v), 0, 0))
                        task.wait()
                        r(s, CFrame.new(0, -1.5, 0) + l.MoveDirection * s.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(v), 0, 0))
                        task.wait()
                        r(s, CFrame.new(0, 1.5, 0) + l.MoveDirection * s.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(v), 0, 0))
                        task.wait()
                        r(s, CFrame.new(0, -1.5, 0) + l.MoveDirection * s.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(v), 0, 0))
                        task.wait()
                        r(s, CFrame.new(0, 1.5, 0) + l.MoveDirection, CFrame.Angles(math.rad(v), 0, 0))
                        task.wait()
                        r(s, CFrame.new(0, -1.5, 0) + l.MoveDirection, CFrame.Angles(math.rad(v), 0, 0))
                        task.wait()
                    else
                        r(s, CFrame.new(0, 1.5, l.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
                        task.wait()
                        r(s, CFrame.new(0, -1.5, -l.WalkSpeed), CFrame.Angles(0, 0, 0))
                        task.wait()
                        r(s, CFrame.new(0, 1.5, l.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
                        task.wait()
                        r(s, CFrame.new(0, -1.5, 0), CFrame.Angles(math.rad(90), 0, 0))
                        task.wait()
                        r(s, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0))
                        task.wait()
                        r(s, CFrame.new(0, -1.5, 0), CFrame.Angles(math.rad(90), 0, 0))
                        task.wait()
                        r(s, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0))
                        task.wait()
                    end
                end
            until u + t < tick() or not FlingActive
        end

        workspace.FallenPartsDestroyHeight = 0 / 0

        local t = Instance.new('BodyVelocity')

        t.Parent = j
        t.Velocity = Vector3.new(0, 0, 0)
        t.MaxForce = Vector3.new(9e9, 9e9, 9e9)

        i:SetStateEnabled(Enum.HumanoidStateType.Seated, false)

        if m then
            s(m)
        elseif n then
            s(n)
        elseif q then
            s(q)
        else
        end

        t:Destroy()
        i:SetStateEnabled(Enum.HumanoidStateType.Seated, true)

        workspace.CurrentCamera.CameraSubject = i

        if getgenv().OldPos then
            repeat
                j.CFrame = getgenv().OldPos * CFrame.new(0, 0.5, 0)

                h:SetPrimaryPartCFrame(getgenv().OldPos * CFrame.new(0, 0.5, 0))
                i:ChangeState('GettingUp')

                for u, v in pairs(h:GetChildren())do
                    if v:IsA('BasePart') then
                        v.Velocity, v.RotVelocity = Vector3.new(), Vector3.new()
                    end
                end

                task.wait()
            until (j.Position - getgenv().OldPos.p).Magnitude < 25

            workspace.FallenPartsDestroyHeight = getgenv().FPDH
        end
    else
    end
end
local function FindPlayerByPartialName(g)
    if not g or g == '' then
        return nil
    end

    local h = string.lower(g)

    for i, j in pairs(ps:GetPlayers())do
        if j ~= p and string.lower(j.Name) == h then
            return j
        end
    end
    for i, j in pairs(ps:GetPlayers())do
        if j ~= p and string.sub(string.lower(j.Name), 1, #h) == h then
            return j
        end
    end
    for i, j in pairs(ps:GetPlayers())do
        if j ~= p and string.find(string.lower(j.Name), h, 1, true) then
            return j
        end
    end

    return nil
end

Window:AddInput({
    Title = 'Player Search',
    Description = "Enter player name or part of it (e.g., 'a' finds 'alex324523')",
    Tab = MiscTab,
    Callback = function(g)
        local h = FindPlayerByPartialName(g)

        if h then
            SelectedFlingTarget = h

            Window:Notify({
                Title = 'Player Found',
                Description = 'Selected: ' .. h.Name,
                Duration = 2,
            })
        else
            SelectedFlingTarget = nil

            if g ~= '' then
                Window:Notify({
                    Title = 'Not Found',
                    Description = 'No player found matching: ' .. g,
                    Duration = 2,
                })
            end
        end
    end,
})
Window:AddButton({
    Title = 'Fling Murderer',
    Description = 'Automatically fling the murderer',
    Tab = MiscTab,
    Callback = function()
        if FlingActive then
            return
        end

        local g, h, i = nil, pcall(function()
            return GetPlayerData:InvokeServer()
        end)

        if h and i then
            for j, k in pairs(ps:GetPlayers())do
                if k ~= p and k:GetAttribute('Alive') == true then
                    local l = i[k.Name]

                    if l and l.Role == 'Murderer' then
                        g = k

                        break
                    end
                end
            end
        end
        if g then
            FlingActive = true

            local j = UIElements.voidHideToggle and UIElements.voidHideToggle.GetValue and UIElements.voidHideToggle.GetValue() or false

            if j and UIElements.voidHideToggle.SetValue then
                UIElements.voidHideToggle.SetValue(false)
            end

            Window:Notify({
                Title = 'Fling Started',
                Description = 'Flinging murderer: ' .. g.Name,
                Duration = 3,
            })
            task.spawn(function()
                SkidFling(g)

                FlingActive = false

                if j and UIElements.voidHideToggle.SetValue then
                    task.wait(0.5)
                    UIElements.voidHideToggle.SetValue(true)
                end

                task.wait(0.1)

                if workspace.CurrentCamera and p.Character then
                    workspace.CurrentCamera.CameraSubject = p.Character:FindFirstChildOfClass('Humanoid')
                end
            end)
        else
            Window:Notify({
                Title = 'Error',
                Description = 'Murderer not found!',
                Duration = 3,
            })
        end
    end,
})
Window:AddButton({
    Title = 'Fling Sheriff',
    Description = 'Automatically fling the sheriff',
    Tab = MiscTab,
    Callback = function()
        if FlingActive then
            return
        end

        local g, h, i = nil, pcall(function()
            return GetPlayerData:InvokeServer()
        end)

        if h and i then
            for j, k in pairs(ps:GetPlayers())do
                if k ~= p and k:GetAttribute('Alive') == true then
                    local l = i[k.Name]

                    if l and l.Role == 'Sheriff' then
                        g = k

                        break
                    end
                end
            end
        end
        if g then
            FlingActive = true

            local j = UIElements.voidHideToggle and UIElements.voidHideToggle.GetValue and UIElements.voidHideToggle.GetValue() or false

            if j and UIElements.voidHideToggle.SetValue then
                UIElements.voidHideToggle.SetValue(false)
            end

            Window:Notify({
                Title = 'Fling Started',
                Description = 'Flinging sheriff: ' .. g.Name,
                Duration = 3,
            })
            task.spawn(function()
                SkidFling(g)

                FlingActive = false

                if j and UIElements.voidHideToggle.SetValue then
                    task.wait(0.5)
                    UIElements.voidHideToggle.SetValue(true)
                end

                task.wait(0.1)

                if workspace.CurrentCamera and p.Character then
                    workspace.CurrentCamera.CameraSubject = p.Character:FindFirstChildOfClass('Humanoid')
                end
            end)
        else
            Window:Notify({
                Title = 'Error',
                Description = 'Sheriff not found!',
                Duration = 3,
            })
        end
    end,
})
Window:AddButton({
    Title = 'Fling Selected Player',
    Description = 'Fling the player selected in dropdown',
    Tab = MiscTab,
    Callback = function()
        if FlingActive then
            return
        end
        if not SelectedFlingTarget or not SelectedFlingTarget.Parent then
            Window:Notify({
                Title = 'Error',
                Description = 'Please select a valid player first!',
                Duration = 3,
            })

            return
        end

        FlingActive = true

        local g = UIElements.voidHideToggle and UIElements.voidHideToggle.GetValue and UIElements.voidHideToggle.GetValue() or false

        if g and UIElements.voidHideToggle.SetValue then
            UIElements.voidHideToggle.SetValue(false)
        end

        Window:Notify({
            Title = 'Fling Started',
            Description = 'Flinging: ' .. SelectedFlingTarget.Name,
            Duration = 3,
        })
        task.spawn(function()
            SkidFling(SelectedFlingTarget)

            FlingActive = false

            if g and UIElements.voidHideToggle.SetValue then
                task.wait(0.5)
                UIElements.voidHideToggle.SetValue(true)
            end

            task.wait(0.1)

            if workspace.CurrentCamera and p.Character then
                workspace.CurrentCamera.CameraSubject = p.Character:FindFirstChildOfClass('Humanoid')
            end
        end)
    end,
})
Window:AddButton({
    Title = 'Stop Fling',
    Description = 'Stop current fling operation',
    Tab = MiscTab,
    Callback = function()
        if FlingActive then
            FlingActive = false

            Window:Notify({
                Title = 'Fling Stopped',
                Description = 'Fling operation has been stopped',
                Duration = 3,
            })
        else
            Window:Notify({
                Title = 'Info',
                Description = 'No active fling operation',
                Duration = 2,
            })
        end
    end,
})

local function getgun()
    pcall(function()
        if not isagbEnabled then
            return
        end
        if not p:GetAttribute('Alive') then
            return
        end

        local g = getPlayerRole()

        if g == 'Murderer' then
            return
        end

        local h = findmap()

        if not h then
            return
        end
        if h == 'None' then
            return
        end
        if h:FindFirstChild('GunDrop') then
            local i = h:FindFirstChild('GunDrop')
            local j = i:FindFirstChild('TouchInterest')

            if j and p.Character and p.Character:FindFirstChild('HumanoidRootPart') then
                firetouchinterest(p.Character.HumanoidRootPart, i, 0)
                firetouchinterest(p.Character.HumanoidRootPart, i, 1)
            end
        end
    end)
end
local function enableNoclip()
    if noclipConnection then
        return
    end

    noclipConnection = RunService.Stepped:Connect(function()
        if isFarmingCoins and p.Character then
            for g, h in pairs(p.Character:GetDescendants())do
                if h:IsA('BasePart') then
                    h.CanCollide = false
                end
            end
        end
    end)
end
local function disableNoclip()
    if noclipConnection then
        noclipConnection:Disconnect()

        noclipConnection = nil
    end
    if p.Character then
        for g, h in pairs(originalPartProperties)do
            if g and g.Parent then
                g.CanCollide = h.CanCollide
                g.Massless = h.Massless
            end
        end
    end
end
local function startFarming()
    if not p.Character or not p.Character:FindFirstChild('HumanoidRootPart') then
        return
    end
    if p:GetAttribute('Alive') ~= true then
        return
    end

    local g, h = p.Character.HumanoidRootPart, p.Character:FindFirstChild('Humanoid')

    addFarmGravity()

    originalPartProperties = {}

    for i, j in pairs(p.Character:GetDescendants())do
        if j:IsA('BasePart') then
            originalPartProperties[j] = {
                CanCollide = j.CanCollide,
                Massless = j.Massless,
            }
        end
    end

    g.CFrame = g.CFrame - Vector3.new(0, 2.5, 0)
    g.CFrame = g.CFrame * CFrame.Angles(math.rad(90), 0, 0)

    if h then
        h.PlatformStand = true

        h:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
        h:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
    end

    farmingActive = true
end
local function stopFarming()
    farmingActive = false

    if currentTween then
        currentTween:Cancel()

        currentTween = nil
    end
    if noclipConnection then
        noclipConnection:Disconnect()

        noclipConnection = nil
    end
    if p.Character then
        for g, h in pairs(originalPartProperties)do
            if g and g.Parent then
                g.CanCollide = h.CanCollide
                g.Massless = h.Massless
            end
        end

        local g = p.Character:FindFirstChild('HumanoidRootPart')

        if g then
            g.Velocity = Vector3.new(0, 0, 0)
            g.RotVelocity = Vector3.new(0, 0, 0)
            g.CFrame = g.CFrame * CFrame.Angles(math.rad(-90), 0, 0)
            g.CFrame = g.CFrame + Vector3.new(0, 2.5, 0)
        end

        local h = p.Character:FindFirstChild('Humanoid')

        if h then
            h.PlatformStand = false

            h:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
            h:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
        end
    end

    originalPartProperties = {}
end

CoinCollectedEvent = ReplicatedStorage.Remotes.Gameplay.CoinCollected

CoinCollectedEvent.OnClientEvent:Connect(function(g, h, i)
    if g == CurrentCoinType or g == 'Coin' then
        currentCoinsCollected = tonumber(h) or 0
        maxCoinsInRound = tonumber(i) or 0

        if currentCoinsCollected >= maxCoinsInRound then
            allCoinsCollected = true

            if farmingActive then
                stopFarming()
                restoreNormalGravity()
            end
        else
            allCoinsCollected = false
        end
    end
end)

RoundStartEvent = ReplicatedStorage.Remotes.Gameplay.RoundStart
RoundEndEvent = ReplicatedStorage.Remotes.Gameplay.RoundEndFade

RoundStartEvent.OnClientEvent:Connect(function()
    allCoinsCollected = false
    currentCoinsCollected = 0
    maxCoinsInRound = 0
    bagFullActionInProgress = false
end)
RoundEndEvent.OnClientEvent:Connect(function()
    allCoinsCollected = false
    currentCoinsCollected = 0
    maxCoinsInRound = 0
    bagFullActionInProgress = false

    if farmingActive then
        stopFarming()
        restoreNormalGravity()
    end
end)
task.spawn(function()
    while true do
        RunService.Heartbeat:Wait()

        local g, h, i = getPlayerRole(), {
            'Innocent',
            'Sheriff',
            'Murderer',
            'Hero',
        }, false

        if g then
            for j, k in ipairs(h)do
                if g == k then
                    i = true

                    break
                end
            end
        end
        if farmingActive and i and p.Character and p.Character:FindFirstChild('HumanoidRootPart') and p:GetAttribute('Alive') == true then
            local j, k = p.Character.HumanoidRootPart, returncoincontainer()

            if k then
                for l, m in pairs(k:GetChildren())do
                    if m:GetAttribute('CoinID') == 'Candy' and m:FindFirstChild('TouchInterest') and m.Transparency == 1 then
                        local n = (j.Position - m.Position).Magnitude

                        if n <= 7.5 then
                            firetouchinterest(j, m, 0)
                            firetouchinterest(j, m, 1)
                        end
                    end
                end
            end
        end
    end
end)
task.spawn(function()
    while true do
        RunService.Heartbeat:Wait()

        if bagFullActionInProgress then
            continue
        end

        local g, h, i = getPlayerRole(), {
            'Innocent',
            'Sheriff',
            'Murderer',
            'Hero',
        }, false

        if g then
            for j, k in ipairs(h)do
                if g == k then
                    i = true

                    break
                end
            end
        end
        if farmingActive and not i then
            stopFarming()
            restoreNormalGravity()
        end
        if isFarmingCoins and farmingActive and allCoinsCollected then
            stopFarming()
            restoreNormalGravity()
        end
        if isFarmingCoins and not allCoinsCollected and p:GetAttribute('Alive') == true and i and p.Character and p.Character:FindFirstChild('HumanoidRootPart') then
            local j = returncoincontainer()

            if j then
                local k, l = FindNearestCoin(j)

                if k and k.Transparency == 1 and not allCoinsCollected then
                    if not farmingActive then
                        startFarming()
                    end

                    local m, n = p.Character.HumanoidRootPart, p.Character:FindFirstChild('Humanoid')

                    m.Velocity = Vector3.new(0, 0, 0)
                    m.RotVelocity = Vector3.new(0, 0, 0)

                    local o = k.Position - Vector3.new(0, 2.5, 0)
                    local q = CFrame.new(o) * CFrame.Angles(math.rad(90), 0, 0)

                    enableNoclip()

                    local r = TweenInfo.new(l / 23, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)

                    currentTween = TweenService:Create(m, r, {CFrame = q})

                    currentTween:Play()

                    local s

                    s = RunService.Heartbeat:Connect(function()
                        if isFarmingCoins and p:GetAttribute('Alive') == true and m then
                            m.Velocity = Vector3.new(0, 0, 0)
                            m.RotVelocity = Vector3.new(0, 0, 0)

                            local t = m:FindFirstChild('FarmGravity')

                            if t and t:IsA('BodyPosition') then
                                t.Position = m.Position
                            end
                            if n then
                                n.PlatformStand = true
                            end
                        else
                            if s then
                                s:Disconnect()
                            end
                        end
                    end)

                    while k and k:FindFirstChild('TouchInterest') and k.Transparency == 1 and not allCoinsCollected and isFarmingCoins and p:GetAttribute('Alive') == true do
                        RunService.Heartbeat:Wait()
                    end

                    if s then
                        s:Disconnect()
                    end
                    if currentTween then
                        currentTween:Cancel()
                    end
                    if m then
                        m.Velocity = Vector3.new(0, 0, 0)
                        m.RotVelocity = Vector3.new(0, 0, 0)
                    end
                else
                    if farmingActive then
                        stopFarming()
                        restoreNormalGravity()
                    end
                end
            else
                if farmingActive then
                    stopFarming()
                    restoreNormalGravity()
                end
            end
        else
            if farmingActive then
                stopFarming()
                restoreNormalGravity()
            end
        end
    end
end)
task.spawn(function()
    while true do
        RunService.Heartbeat:Wait()
        f()
        getgun()
    end
end)

for g, h in ipairs(Players:GetPlayers())do
    h.CharacterAdded:Connect(function()
        task.wait(0.5)
        f()
    end)
end

Players.PlayerAdded:Connect(function(g)
    g.CharacterAdded:Connect(function()
        task.wait(0.5)
        f()
    end)
end)
Players.PlayerRemoving:Connect(function(g)
    d(g)
    b(g)
end)
UserInputService.InputBegan:Connect(function(g)
    if g == Keybind then
    end
end)
