-- This script is made by feariosz0 in discord, v1.1.3

local noclipbool = false
local infstambool = false
local autorebool = false
local autogbool = false
local infjumpbool = false
local silentAimEnabled = false
local espbool = false
local espconn;
local antisitconn;

local loopkill = false
local boosting = false

local autoreloadbool = false
local hotswapbool = false
local autoreloadconn = nil
local oldplaysound = nil

local invisiblebool = false
local invisibleconn = nil
local invisiblebind = nil
local invisanimtrack = nil
local invisoldcf = nil

local firerateval = 100
local nospreadbool = false
local automaticbool = false
local gunmodconn = nil
local originalGunData = {}

local stopkick = false
local antishield = false

local tpdelay = 12
local lasttp = 0

local ignore = false

local admins = {}
local whitelisted = { -- ts me twin dont delete ;)
	"vole7vin",
	"RONALDO_32720",
}

local function gets(service)
    return game:GetService(service)
end

local players = gets('Players')
local storage = gets('ReplicatedStorage')
local chat = gets('Chat')
local team = gets('Teams')
local StarterGui = gets('StarterGui')
local run = gets('RunService')
local input = gets('UserInputService')
local texts = gets('TextChatService')
local core = gets('CoreGui')
local TweenService = gets('TweenService')
local VIM = game:GetService("VirtualInputManager")

local textcs = texts:WaitForChild("TextChannels"):WaitForChild("RBXGeneral")

local function notify(title, text, duration)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = duration or 5
        })
    end)
end

local localp = players.LocalPlayer
local playerGui = localp:WaitForChild("PlayerGui")
local cam = workspace.CurrentCamera

local previous = playerGui:FindFirstChild("CommandBar")
if previous then
    previous:Destroy()
end

local function getpl()
    for _, v in pairs(players:GetPlayers()) do
        return v
    end
end

local function getch()
    if localp.Character then
        return localp.Character
    else
        repeat
            task.wait(0.1)
        until localp.Character
        return localp.Character
    end
end

local function gethm()
    local ch = getch()
    if ch:FindFirstChildOfClass('Humanoid') then
        return ch:FindFirstChildOfClass('Humanoid')
    else
        repeat
            task.wait()
        until ch:FindFirstChildOfClass('Humanoid')
        return ch:FindFirstChildOfClass('Humanoid')
    end
end

local function gethp()
    local ch = getch()
    if ch:FindFirstChild('HumanoidRootPart') then
        return ch:FindFirstChild('HumanoidRootPart')
    else
        repeat
            task.wait()
        until ch:FindFirstChild('HumanoidRootPart')
        return ch:FindFirstChild('HumanoidRootPart')
    end
end

local function crim2()
    local hp = gethp()
    local cf = CFrame.new(-975, 108, 2071)
    
    hp.CFrame = cf
    repeat task.wait() until localp.Team.Name == 'Criminals'
end

local function change(teamn)
    if teamn == 'Inmates' then
        repeat
            local Event = storage.Remotes.RequestTeamChange
            Event:InvokeServer(team.Neutral,1)
            task.wait()
            Event:InvokeServer(team.Inmates,1)
            if localp.PlayerGui.Home.IntroFrame.ContentBackground.MainMenuFrame.TeamsFrame.Inmates.Button.TextLabel.Text ~= 'Join' then
                notify('AC Bypass', 'Team full cant do', 5)
                break
            end
        until localp.Team.Name == 'Inmates'
    elseif teamn == 'Guards' then
        repeat
            local Event = storage.Remotes.RequestTeamChange
            Event:InvokeServer(team.Neutral,1)
            task.wait()
            Event:InvokeServer(team.Guards,1)
            if localp.PlayerGui.Home.IntroFrame.ContentBackground.MainMenuFrame.TeamsFrame.Guards.Button.TextLabel.Text ~= 'Join' then
                notify('AC Bypass', 'Team full cant do', 5)
                break
            end
        until localp.Team.Name == 'Guards'
    elseif teamn == 'Criminals' then
        repeat
            local Event = storage.Remotes.RequestTeamChange
            Event:InvokeServer(team.Neutral,1)
            task.wait()
            Event:InvokeServer(team.Inmates,1)
            if localp.PlayerGui.Home.IntroFrame.ContentBackground.MainMenuFrame.TeamsFrame.Inmates.Button.TextLabel.Text ~= 'Join' then
                notify('AC Bypass', 'Team full cant do', 5)
                break
            end
        until localp.Team.Name == 'Inmates'
        task.wait(0.1)
        crim2()
        repeat task.wait() until not getch():FindFirstChild('ForceField')
    end
end

local function counttp()
    if ignore then
        return true
    end

    local now = tick()
    local remaining = tpdelay - (now - lasttp)

    if remaining > 0 then
        notify("Teleport", "Wait A bit...", 5)
        change(localp.Team.Name)

        local deadline = tick() + 8
        repeat
            task.wait(0.1)
            local ch = localp.Character
            local hp = ch and ch:FindFirstChild("HumanoidRootPart")
            local hm = ch and ch:FindFirstChildOfClass("Humanoid")
            if hp and hm and hm.Health > 0 then
                break
            end
        until tick() > deadline

        lasttp = now
        return true
    end

    lasttp = now
    return true
end

do -- limit for kick/kill
    local p = Instance.new('Part')
    p.Name = 'HeightLimit'
    p.Size = Vector3.new(10000000000000, 10, 10000000000000)
    p.Position = Vector3.new(929, 180, 2397)
    p.Anchored = true
    p.Transparency = 1
    p.CanCollide = true
    p.Parent = workspace
end

local function noclip()
    if storage:FindFirstChild('Scripts') and storage:FindFirstChild('Scripts'):FindFirstChild('ClientItemHandler') then
        storage.Scripts.CharacterCollision:Destroy()
    end
    if not noclipbool then
        noclipbool = true
    end
    while noclipbool do
        local ch = getch()
        for _, v in pairs(ch:GetChildren()) do
            if v:IsA('BasePart') then
                v.CanCollide = false
            end
        end
        task.wait()
    end
end

local function unnoclip()
    noclipbool = false
    local ch = getch()
    if ch:FindFirstChild("Head") then ch.Head.CanCollide = true end
    if ch:FindFirstChild("Torso") then ch.Torso.CanCollide = true end
end

local function infstam()
    infstambool = true
    while infstambool do
        local ch = getch()
        if ch:FindFirstChild('AntiJump') then
            ch.AntiJump.Disabled = true
        end
        task.wait()
    end
end

local function crim()
    if not counttp() then
        return
    end
    local hp = gethp()
    local og = hp.CFrame
    local ogcam = cam.CFrame
    local cf = CFrame.new(-975, 108, 2071)
    
    hp.CFrame = cf
    repeat task.wait() until localp.Team.Name == 'Criminals'
    hp.CFrame = og
    cam.CFrame = ogcam
end

local function autore()
    if not autorebool then
        autorebool = true
    end
    while autorebool do
        local hm = gethm()
        if hm and hm.Health == 0 then
            local og = gethp().CFrame
            local ogcam = cam.CFrame
            local ogt = localp.Team.Name
            local ogi = ignore
            ignore = true
            change(localp.Team.Name)
            repeat task.wait() until getch():FindFirstChildOfClass('Humanoid')
            if getch():FindFirstChild('ForceField') and ogt == 'Criminals' then
                repeat task.wait() until not getch():FindFirstChild('ForceField')
            end
            gethp().CFrame = og
            cam.CFrame = ogcam   
            ignore = ogi
        end
        task.wait()
    end
end

local function helper()
    local hm = gethm()
    local anim = Instance.new('Animation')
    anim.AnimationId = 'rbxassetid://180426354'
    anim.Name = 'HelperAnim'
    anim.Parent = hm
    local track = hm:LoadAnimation(anim)
    track:Play()
end

local function ak47()
    if not counttp() then
        return
    end
    local hp = gethp()
    local hm = gethm()
    local cf = CFrame.new(-932, 94, 2039)
    local og = hp.CFrame
    local ogcam = cam.CFrame
    local Event = storage.Remotes.InteractWithItem

    while task.wait() do
        gethp().CFrame = CFrame.new(-929, 97, 2056)
        helper()
        task.wait(0.1)
        hp.CFrame = cf
        hm:ChangeState(Enum.HumanoidStateType.Jumping)
        Event:InvokeServer(
            workspace.Prison_ITEMS.giver["AK-47"]["Meshes/AK47_7"]
        )
        if localp.Backpack:FindFirstChild('AK-47') then
            for _, track in pairs(hm:GetPlayingAnimationTracks()) do
                track:Stop()
            end
            hp.CFrame = og
            cam.CFrame = ogcam
            break
        end
    end
end

local function shotgun()
    if not counttp() then
        return
    end
    local hp = gethp()
    local hm = gethm()
    local cf = CFrame.new(-939, 94, 2040)
    local og = hp.CFrame
    local ogcam = cam.CFrame
    local Event = storage.Remotes.InteractWithItem

    while task.wait() do
        gethp().CFrame = CFrame.new(-929, 97, 2056)
        helper()
        task.wait(0.1)
        hp.CFrame = cf
        hm:ChangeState(Enum.HumanoidStateType.Jumping)
        Event:InvokeServer(
            workspace.Prison_ITEMS.giver:GetChildren()[4]["Meshes/r870_2"]
        )
        if localp.Backpack:FindFirstChild('Remington 870') then
            for _, track in pairs(hm:GetPlayingAnimationTracks()) do
                track:Stop()
            end
            hp.CFrame = og
            cam.CFrame = ogcam
            break
        end
    end
end

local function autog()
    if not autogbool then
        autogbool = true
    end
    while autogbool do
        if not localp:FindFirstChildOfClass('Backpack') then
            task.wait(0.5)
        end
        if localp.Team.Name == 'Neutral' then
            repeat task.wait(0.1) until localp.Team.Name ~= 'Neutral'
            task.wait(0.5)
        end
        local hm = gethm()
        local og = gethp().CFrame
        local ogcam = cam.CFrame

        local function hasgun(name)
            local ch = localp.Character
            return localp.Backpack:FindFirstChild(name) or (ch and ch:FindFirstChild(name))
        end
        
        if not hasgun('Remington 870') or not hasgun('Remington 870') then
            if not counttp() then
                return
            end
        end

        if not hasgun('AK-47') then
            local Event = storage.Remotes.InteractWithItem
            gethp().CFrame = CFrame.new(-929, 97, 2056)
            helper()
            task.wait(0.1)
            gethp().CFrame = CFrame.new(-932, 94, 2039)
            hm:ChangeState(Enum.HumanoidStateType.Jumping)

            while not hasgun('AK-47') do
                gethp().CFrame = CFrame.new(-932, 94, 2039)
                Event:InvokeServer(
                    workspace.Prison_ITEMS.giver["AK-47"]["Meshes/AK47_7"]
                )
                task.wait()
            end

            for _, track in pairs(gethm():GetPlayingAnimationTracks()) do
                track:Stop()
            end
        end

        if not hasgun('Remington 870') then
            local Event = storage.Remotes.InteractWithItem
            gethp().CFrame = CFrame.new(-929, 97, 2056)
            helper()
            task.wait(0.1)
            gethp().CFrame = CFrame.new(-939, 94, 2040)
            hm:ChangeState(Enum.HumanoidStateType.Jumping)

            while not hasgun('Remington 870') do
                gethp().CFrame = CFrame.new(-939, 94, 2040)
                Event:InvokeServer(
                    workspace.Prison_ITEMS.giver:GetChildren()[4]["Meshes/r870_2"]
                )
                task.wait()
            end

            for _, track in pairs(gethm():GetPlayingAnimationTracks()) do
                track:Stop()
            end
        end

        gethp().CFrame = og
        cam.CFrame = ogcam
        task.wait(0.5)
    end
end

local function base()
    if not counttp() then
        return
    end
    local hp = gethp()
    local cf = CFrame.new(-929, 97, 2056)
    hp.CFrame = cf
end

local function yard()
    local ch = getch()
    if ch:FindFirstChild('ForceField') then
        notify('Teleport', 'Please Wait For ForceField To Expire', 5)
        repeat task.wait(0.1) until not ch:FindFirstChild('ForceField')
    end
    if not counttp() then
        return
    end
    local hp = gethp()
    local cf = CFrame.new(799, 98, 2469)
    hp.CFrame = cf
end

local function prison()
    local ch = getch()
    if ch:FindFirstChild('ForceField') then
        notify('Teleport', 'Please Wait For ForceField To Expire', 5)
        repeat task.wait(0.1) until not ch:FindFirstChild('ForceField')
    end
    if not counttp() then
        return
    end
    local hp = gethp()
    local cf = CFrame.new(913, 100, 2385)
    hp.CFrame = cf
end

local function cafeteria()
    local ch = getch()
    if ch:FindFirstChild('ForceField') then
        notify('Teleport', 'Please Wait For ForceField To Expire', 5)
        repeat task.wait(0.1) until not ch:FindFirstChild('ForceField')
    end
    if not counttp() then
        return
    end
    local hp = gethp()
    local cf = CFrame.new(906, 100, 2298)
    hp.CFrame = cf
end

local function tower()
    local ch = getch()
    if ch:FindFirstChild('ForceField') then
        notify('Teleport', 'Please Wait For ForceField To Expire', 5)
        repeat task.wait(0.1) until not ch:FindFirstChild('ForceField')
    end
    if not counttp() then
        return
    end
    local hp = gethp()
    local cf = CFrame.new(822, 125, 2588)
    hp.CFrame = cf
end

local function rdoors()
    for _, v in pairs(workspace.Doors:GetChildren()) do
        v:Destroy()
    end
end

local function findpl(arg)
    if not arg or arg == "" then
        return nil, "No player name given"
    end

    arg = arg:lower():gsub("%s+", "")

    local exact, prefix = {}, {}

    for _, p in pairs(players:GetPlayers()) do
        if p ~= localp then
            local name = p.Name:lower()
            local display = (p.DisplayName or ""):lower():gsub("%s+", "")

            if name == arg or display == arg then
                table.insert(exact, p)
            elseif name:sub(1, #arg) == arg or display:sub(1, #arg) == arg then
                table.insert(prefix, p)
            end
        end
    end

    local candidates = #exact > 0 and exact or prefix

    if #candidates == 0 then
        return nil, 'Player "' .. arg .. '" Not Found'
    end

    if #candidates > 1 then
        table.sort(candidates, function(a, b)
            return #a.Name < #b.Name
        end)
    end

    local found = candidates[1]

    if whitelisted[found.Name] then
        notify('Info', 'This Player Is Whitelisted', 5)
        return
    end

    return found
end

local function animh()
    local hum = gethm()
    local animator = hum:WaitForChild("Animator")
    
    local anim = Instance.new("Animation")
    anim.AnimationId = "rbxassetid://215384594"
    local anim1 = Instance.new("Animation")
    anim1.AnimationId = "rbxassetid://279229192"
    
    local track = animator:LoadAnimation(anim)
    track:Play()
    track.TimePosition = 2
    track:AdjustSpeed(0)
    local track1 = animator:LoadAnimation(anim1)
    track1:Play()
    track1.TimePosition = 2
    track1:AdjustSpeed(0)
end

local function arrest(arg)
    local player, err = findpl(arg)

    if not player then
        notify('Arrest', err, 5)
        return
    end

    local ch = player.Character
    local target = ch:FindFirstChild('HumanoidRootPart')

    if not target then
        notify('Arrest', 'Target Character Not Found', 5)
        return
    end
    
    local sh = ch:GetAttribute('Hostile')
    if not sh then
        notify('Arrest', 'Cant arrest player, not a hostile', 5)
    end
    
    local ogt = localp.Team.Name
    
    if localp.Team.Name ~= 'Guards' then
        change('Guards')
        repeat task.wait(0.1) until localp:FindFirstChild('Backpack'):FindFirstChild('Handcuffs')
    end

    local event = storage.Remotes.ArrestPlayer
    local hp = gethp()
    local ch1 = getch()
    
    if ch:FindFirstChild('ForceField') then
        notify('Arrest', 'Please Wait For ForceField To Expire', 5)
        repeat task.wait(0.1) until not ch:FindFirstChild('ForceField')
    end
    
    local og = hp.CFrame
    
    for _, v in pairs(ch1:GetChildren()) do
        if v:IsA('Tool') then
            v.Parent = localp.Backpack
        end
    end
    
    if not ch1:FindFirstChild('Handcuffs') then
        if not localp.Backpack:FindFirstChild('Handcuffs') then
            notify('Must Be In Guards Team!')
            return
        end
        localp.Backpack.Handcuffs.Parent = ch1
    end
    
    if not counttp() then
        return
    end
    
    animh()

    for i = 1, 10 do
        event:InvokeServer(player,1)
        hp.CFrame = target.CFrame
    end
    for _, trac in pairs(gethm():GetPlayingAnimationTracks()) do
        trac:Stop()
    end
    change(ogt)
    repeat task.wait() until getch():FindFirstChild('HumanoidRootPart')
    gethp().CFrame = og
end

local function kill(arg)
    local player, err = findpl(arg)
    if not player then
        notify('Kill', err, 5)
        return
    end
    
    local ogt = localp.Team.Name
    
    local ch = player.Character
    local target = ch:FindFirstChild('HumanoidRootPart')
    if not target then
        notify('Kill', 'Target Character Not Found', 5)
        return
    end
    
    if ch:FindFirstChild('ForceField') then
        notify('Kill', 'Please Wait For ForceField To Expire', 5)
        repeat task.wait(0.1) until not ch:FindFirstChild('ForceField')
    end
    
    if not counttp() then
        return
    end
    
    if player.Team.Name == 'Guards' and localp.Team.Name == 'Guards' then
        change('Inmates')
    end
    
    local ch1 = getch()
    
    if ch1:FindFirstChild('ForceField') then
        notify('Teleport', 'Please Wait For ForceField To Expire', 5)
        repeat task.wait(0.1) until not ch1:FindFirstChild('ForceField')
    end
    
    local hp = gethp()
    local hm = gethm()
    local og = hp.CFrame
    
    animh()
    
    local Event = storage.meleeEvent
    repeat
        if hm.Health == 0 then
            cam.CameraSubject = gethm()
            break
        end
        cam.CameraSubject = ch.Humanoid
        Event:FireServer(
            player,
            1,
            1
        )
        hp.CFrame = target.CFrame * CFrame.new(0, -2.5, 0)
        hm:ChangeState(3)
        task.wait()
    until ch.Humanoid.Health == 0
    for _, trac in pairs(gethm():GetPlayingAnimationTracks()) do
        trac:Stop()
    end
    if ogt == 'Guards' then
        change(ogt)
    end
    hp.CFrame = og
    cam.CameraSubject = gethm()
end

local infjumpconn;

local function infjump()
    if not infjumpbool then
        infjumpbool = true
    end

    if infjumpconn then
        infjumpconn:Disconnect()
        infjumpconn = nil
    end
    
    infjumpconn = input.JumpRequest:Connect(function()
        if not infjumpbool then return end
        local hm = gethm()
        if hm and hm.Health > 0 then
            hm:ChangeState(Enum.HumanoidStateType.Jumping)
        else
            infjumpbool = false
        end
    end)
end

local function car()
    if not counttp() then
        return
    end
    local ch = getch()
    local hp = gethp()
    local hm = gethm()
    local og = hp.CFrame
    local cf = CFrame.new(624, 98, 2495)
    local Event = storage.Remotes.InteractWithItem

    for _, v in pairs(workspace.CarContainer:GetChildren()) do
        if v.Name == "Squad" then
            v:Destroy()
        end
    end

    hp.CFrame = cf
    task.wait(0.2)

    Event:InvokeServer(
        workspace.Prison_ITEMS.buttons:GetChildren()[4]["Car Spawner"]
    )

    local cars = workspace.CarContainer
    local carModel = cars:WaitForChild("Squad")
    local body = carModel:WaitForChild("Body")

    task.wait(0.5)

    local seat = carModel:FindFirstChildWhichIsA("VehicleSeat", true) or carModel:FindFirstChildWhichIsA("Seat", true)

    if seat then
        hp.CFrame = seat.CFrame
        task.wait(0.5)
    else
        notify("Car", "No seat found", 5)
        task.wait(1)
        return
    end

    local parts = {}

    for _, v in pairs(body:GetDescendants()) do
        if v:IsA("BasePart") then
            table.insert(parts, v)
        end
    end

    if #parts == 0 then
        notify("Car", "No car parts found", 5)
        hp.CFrame = og
        return
    end

    for _, v in pairs(parts) do
        if v ~= hp then
            v.CFrame = og * CFrame.new(0, 15, 0)
        end
    end
    
    task.wait(0.1)
    
    for _, v in pairs(carModel.Wheels:GetChildren()) do
        v.CFrame = body.Main.CFrame
    end

    task.wait(0.2)
    hp.CFrame = og
    task.wait()
    local seat1;
    
    for _, v in pairs(body:GetChildren()) do
        if v.Name == 'VehicleSeat' then
            seat1 = v
        end
    end

    if seat1 then
        hp.CFrame = seat1.CFrame
        task.wait(0.5)
    else
        notify("Car", "No seat found", 5)
        task.wait(1)
        return
    end
end

local function antihelper()
    local cars = workspace:FindFirstChild("CarContainer")
    if not cars then return end

    for _, car in ipairs(cars:GetChildren()) do
        local wheels = car:FindFirstChild("Wheels", true)

        for _, v in ipairs(car:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = wheels and v:IsDescendantOf(wheels) or false
            end
        end
    end
end

local function antikick()
    while task.wait(0.1) do
        pcall(antihelper)
    end
end

local function kickhelper(hum)
    return hum and hum.SeatPart ~= nil
end

local function bring(arg)
    local player, err = findpl(arg)
    if not player then
        notify("bring", err, 5)
        return
    end

    local targetChar = player.Character
    local targetHum = targetChar and targetChar:FindFirstChildOfClass("Humanoid")

    if not targetHum then
        notify("bring", "Couldnt find humanoid", 5)
        return
    end

    if kickhelper(targetHum) then
        notify("bring", "Player is seated, cant do", 5)
        return
    end
    
    if not counttp() then
        return
    end
    
    if localp.Team.Name == 'Criminals' then
        local Event = storage.Remotes.RequestTeamChange
        Event:InvokeServer(team.Neutral,1)
    end
    
    repeat
        local Event = storage.Remotes.RequestTeamChange
        Event:InvokeServer(team.Guards,1)
        task.wait()
        Event:InvokeServer(team.Inmates,1)
    until localp.Team.Name == 'Inmates' or localp.Team.Name == 'Guards'
    
    local ch = getch()
    local hp = gethp()
    local hm = gethm()
    local og = hp.CFrame
    local cf = CFrame.new(624, 98, 2495)
    local Event = storage.Remotes.InteractWithItem
    
    local buttons = workspace:FindFirstChild("Prison_ITEMS")
    buttons = buttons and buttons:FindFirstChild("buttons")
    local spawner = buttons and buttons:GetChildren()[4]
    spawner = spawner and spawner:FindFirstChild("Car Spawner")

    for _, v in pairs(workspace.CarContainer:GetChildren()) do
        if v.Name == "Squad" then
            v:Destroy()
        end
    end

    hp.CFrame = cf
    task.wait(0.1)

    local ok = pcall(function()
        repeat
            Event:InvokeServer(spawner)
            task.wait(0.1)
        until cars:FindFirstChild("Squad", 5)
    end)

    local cars = workspace.CarContainer
    local carModel = cars:WaitForChild("Squad")
    local body = carModel:WaitForChild("Body")

    task.wait(0.5)

    local seat;
    
    for _, v in pairs(body:GetChildren()) do
        if v.Name == 'VehicleSeat' then
            seat = v
        end
    end

    if seat then
        hp.CFrame = seat.CFrame
        task.wait(0.5)
    else
        notify("Car", "No seat found", 5)
        task.wait(1)
        return
    end

    local parts = {}

    for _, v in pairs(body:GetDescendants()) do
        if v:IsA("BasePart") then
            table.insert(parts, v)
        end
    end

    if #parts == 0 then
        notify("Car", "No car parts found", 5)
        hp.CFrame = og
        return
    end

    repeat
        for _, v in pairs(parts) do
            if v ~= hp then
                v.CFrame = targetChar.Head.CFrame * CFrame.new(0, 5, 0) * CFrame.Angles(math.rad(90),0,0)
            end
        end
         
        task.wait(0.1)
        
        for _, v in pairs(parts) do
            if v ~= hp then
                v.CFrame = og * CFrame.new(0, 15, 0)
            end
        end
        
        task.wait(0.1)
    until kickhelper(targetHum)
end

local function handlemissingcar(cars)
    if cars and cars:FindFirstChild("Squad") then
        return false
    end
    
    local hp = gethp()
    
    for i = 1,2 do
        if hp then
            hp.CFrame = CFrame.new(workspace.FallenPartsDestroyHeight,workspace.FallenPartsDestroyHeight+5,workspace.FallenPartsDestroyHeight)
        end
    end
    
    if hp then
        hp.Velocity = Vector3.zero
    end

    local ch = localp.Character
    local hm = ch:FindFirstChildOfClass("Humanoid")

    if hm and hm.Health > 0 then
        gethp().CFrame = CFrame.new(workspace.FallenPartsDestroyHeight,workspace.FallenPartsDestroyHeight+5,workspace.FallenPartsDestroyHeight)
    end

    return true
end

local function setMaxSimRadius()
	local sethidden = (getgenv and getgenv().sethiddenproperty) or _G.sethiddenproperty or sethiddenproperty
	local setsim = (getgenv and getgenv().setsimulationradius) or _G.setsimulationradius or setsimulationradius

	if typeof(sethidden) == 'function' then
		pcall(sethidden, localp, 'SimulationRadius', 1e9)
		pcall(sethidden, localp, 'MaximumSimulationRadius', 1e9)
	end

	if typeof(setsim) == 'function' then
		pcall(setsim, 1e9)
	end
end

local function kick(arg)
    local player, err = findpl(arg)
    if not player then
        notify("Kick", err, 5)
        return
    end

    local targetChar = player.Character
    local targetHum = targetChar and targetChar:FindFirstChildOfClass("Humanoid")

    if not targetHum then
        notify("Kick", "Couldnt find humanoid", 5)
        return
    end

    local cars = workspace:FindFirstChild("CarContainer")
    if not cars then
        notify("Kick", "CarContainer not found", 5)
        return
    end
    
    if localp.Team.Name == 'Criminals' then
        local Event = storage.Remotes.RequestTeamChange
        Event:InvokeServer(team.Neutral,1)
    end
    
    repeat
        local Event = storage.Remotes.RequestTeamChange
        Event:InvokeServer(team.Guards,1)
        task.wait()
        Event:InvokeServer(team.Inmates,1)
    until localp.Team.Name == 'Inmates' or localp.Team.Name == 'Guards'
    
    if not counttp() then
        return
    end
    
    setMaxSimRadius()

    for _, v in ipairs(cars:GetChildren()) do
        if v.Name == "Squad" then
            v:Destroy()
        end
    end

    local hp = gethp()
    local hm = gethm()
    local Event = storage.Remotes.InteractWithItem

    hp.CFrame = CFrame.new(624, 98, 2495)
    task.wait()

    local buttons = workspace:FindFirstChild("Prison_ITEMS")
    buttons = buttons and buttons:FindFirstChild("buttons")
    local spawner = buttons and buttons:GetChildren()[4]
    spawner = spawner and spawner:FindFirstChild("Car Spawner")

    if not spawner then
        notify("Kick", "Car spawner not found", 5)
        return
    end

    local ok = pcall(function()
        repeat
            Event:InvokeServer(spawner)
            task.wait(0.1)
        until cars:FindFirstChild("Squad", 5)
    end)

    if not ok then
        notify("Kick", "Car spawn failed", 5)
        return
    end

    local carModel = cars:FindFirstChild("Squad", 5)
    if not carModel or handlemissingcar(cars) then
        notify("Kick", "Car disappeared or failed to spawn", 5)
        return
    end

    local body = carModel:FindFirstChild("Body")
    local seat = body and body:FindFirstChild("VehicleSeat")

    if not body or not seat then
        notify("Kick", "Car body or seat missing", 5)
        return
    end

    local parts = {}

    for _, v in ipairs(body:GetDescendants()) do
        if v:IsA("BasePart") then
            table.insert(parts, v)
        end
    end

    if #parts == 0 then
        handlemissingcar(cars)
        return
    end

    hp = gethp()
    hp.CFrame = seat.CFrame
    task.wait(0.09)

    for _, v in ipairs(parts) do
        if handlemissingcar(cars) then
            return
        end

        if v and v.Parent then
            local success = pcall(function()
                repeat
                    if handlemissingcar(cars) then
                        return
                    end
                    
                    v.Velocity = Vector3.new(10000, 10000, 0)

                    local ch = player.Character
                    local hd = ch.Head
                    if not hd then
                        gethp().CFrame = CFrame.new(workspace.FallenPartsDestroyHeight,workspace.FallenPartsDestroyHeight+5,workspace.FallenPartsDestroyHeight)
                        break
                    end
                    if hm.Health < 100 then
                        gethp().CFrame = CFrame.new(workspace.FallenPartsDestroyHeight,workspace.FallenPartsDestroyHeight+5,workspace.FallenPartsDestroyHeight)
                        break
                    end
                    
                    sethiddenproperty(v, 'PhysicsRepRootPart', ch.Humanoid.RootPart)
                    sethiddenproperty(v, 'PhysicsRepRootRef', InstanceHandle.new(ch.Humanoid.RootPart))
                    v.CFrame = hd.CFrame * CFrame.new(-3, 0.5, -3)
                    v.Velocity = Vector3.new(10000, 10000, 10000)
                    task.wait()
                    v.CFrame = hd.CFrame * CFrame.new(-3, 1, -4)
                    v.CFrame = hd.CFrame * CFrame.new(-4, 1.5, -3)
                until false -- kickhelper(ch:FindFirstChildOfClass("Humanoid"))
            end)

            if not success and handlemissingcar(cars) then
                task.wait(players.RespawnTime)
                kick(arg)
            end
        end
    end
end

local function handlemissingcar2(cars)
    if cars and cars:FindFirstChild("Squad") then
        return false
    end

    return true
end

-- kick2 (ripoff vape♥️)

local function isNetworkOwned(part)
	local isnetowner = (getgenv and getgenv().isnetworkowner) or _G.isnetworkowner or isnetworkowner
	if typeof(isnetowner) ~= 'function' then return true end

	local success, owned = pcall(isnetowner, part)
	repeat task.wait() until success and owned
	return success and owned
end

local function kick2(arg)
    local player, err = findpl(arg)
    if not player then
        notify("Kick", err, 5)
        return
    end

    local targetChar = player.Character
    local targetHum = targetChar and targetChar:FindFirstChildOfClass("Humanoid")

    if not targetHum then
        notify("Kick", "Couldnt find humanoid", 5)
        return
    end

    local cars = workspace:FindFirstChild("CarContainer")
    if not cars then
        notify("Kick", "CarContainer not found", 5)
        return
    end

    if localp.Team.Name == "Criminals" then
        local Event = storage.Remotes.RequestTeamChange
        Event:InvokeServer(team.Neutral, 1)
    end

    repeat
        local Event = storage.Remotes.RequestTeamChange
        Event:InvokeServer(team.Guards, 1)
        task.wait()
        Event:InvokeServer(team.Inmates, 1)
    until localp.Team.Name == "Inmates" or localp.Team.Name == "Guards"

    setMaxSimRadius()

    for _, v in ipairs(cars:GetChildren()) do
        if v.Name == "Squad" then
            v:Destroy()
        end
    end

    local hp = gethp()
    local hm = gethm()
    local Event = storage.Remotes.InteractWithItem

    local buttons = workspace:FindFirstChild("Prison_ITEMS")
    buttons = buttons and buttons:FindFirstChild("buttons")

    local spawner = buttons and buttons:GetChildren()[4]
    spawner = spawner and spawner:FindFirstChild("Car Spawner")

    if not spawner then
        notify("Kick", "Car spawner not found", 5)
        return
    end
    
    hp.CFrame = spawner.CFrame

    local ok = pcall(function()
        repeat
            Event:InvokeServer(spawner)
            pcall(function() Event:InvokeServer(buttons:GetChildren()[5]['Car Spawner']) end)            
            local tw = TweenService:Create(hp, TweenInfo.new(0.7), {CFrame = spawner.CFrame})
            tw:Play()
            tw.Completed:Wait()
            task.wait(0.1)
            local tw2 = TweenService:Create(hp, TweenInfo.new(0.7), {CFrame = CFrame.new(589, 98, 2494)})
            tw2:Play()
            tw2.Completed:Wait()
        until cars:FindFirstChild("Squad", 5)
    end)

    if not ok then
        notify("Kick", "Car spawn failed", 5)
        return
    end

    local carModel = cars:FindFirstChild("Squad", 5)
    if not carModel or handlemissingcar2(cars) then
        notify("Kick", "Car disappeared or failed to spawn", 5)
        return
    end

    local body = carModel:FindFirstChild("Body")
    local seat = body and body:FindFirstChild("VehicleSeat")

    if not body or not seat then
        notify("Kick", "Car body or seat missing", 5)
        return
    end

    local parts = {}

    for _, v in ipairs(body:GetDescendants()) do
        if v:IsA("BasePart") then
            table.insert(parts, v)
        end
    end

    if #parts == 0 then
        handlemissingcar2(cars)
        return
    end

    hp = gethp()

    for _, v in ipairs(parts) do
        if handlemissingcar2(cars) then
            return
        end

        if v and v.Parent then
            local success = pcall(function()
                if isNetworkOwned(seat) then
                    if handlemissingcar2(cars) then
                        return
                    end
                    v.Velocity = Vector3.new(10000, 10000, 10000)
                    local ch = player.Character
                    local hd = ch.Head
                    seat.CFrame = hd.CFrame * CFrame.new(-2, 0, -12)
                    seat.AssemblyLinearVelocity = Vector3.new(10000,10000,0)
                    sethiddenproperty(seat, "PhysicsRepRootPart", ch.Humanoid.RootPart)
                    sethiddenproperty(seat, 'PhysicsRepRootRef', InstanceHandle.new(ch.Humanoid.RootPart))
                end
            end)

            if not success and handlemissingcar2(cars) then
                task.wait(players.RespawnTime)
                kick2(arg)
            end
        end
    end
end

local function explode(arg)
    local player, err = findpl(arg)
    if not player then
        notify("Explode", err, 5)
        return
    end

    local ch = player.Character
    local tr = ch and ch:FindFirstChild("HumanoidRootPart")
    if not tr then
        notify("Explode", "Target root not found", 5)
        return
    end

    local hp = gethp()
    local og = hp.CFrame
    local og1 = hp.Velocity
    for i = 1,10 do
        hp.Velocity = Vector3.new(10000,0,10000)
        hp.CFrame = tr.CFrame * CFrame.new(0,1,-3)
        task.wait(0.1)
    end
    hp.CFrame = og
    hp.Velocity = og1
end

local function goto(arg)
    local player, err = findpl(arg)

    if not player then
        notify('Teleport', err, 5)
        return
    end
    
    if not player.Character then
        notify('Teleport', 'Character Not Found', 5)
        return
    end
    
    if not player.Character:FindFirstChild('HumanoidRootPart') then
        notify('Teleport', 'HumanoidRootPart Not Found', 5)
        return
    end
    
    if not counttp() then
        return
    end
    
    local ch = getch()
    local hp = gethp()
    
    local ch1 = player.Character
    local hp1 = ch1.HumanoidRootPart
    
    hp.CFrame = hp1.CFrame
end

local function hammer()
    if not workspace:FindFirstChild('Hammer') then
        notify('Hammer', 'Please Wait For It To Spawn', 5)
        repeat
            task.wait(0.1)
        until workspace:FindFirstChild('Hammer')
    end
    
    if not counttp() then
        return
    end
    
    local item = workspace:FindFirstChild('Hammer').ITEMPICKUP
    local cf = item.CFrame
    local Event = storage.Remotes.GiverPressed
    
    local hp = gethp()
    local og = hp.CFrame
    
    local pack = localp.Backpack
    
    while true do
        hp.CFrame = cf
        Event:FireServer(workspace.Hammer)
        if pack:FindFirstChild('Hammer') then
            break
        end
        task.wait()
    end
    
    hp.CFrame = og
end

local function knife()
    if not workspace:FindFirstChild('Crude Knife') then
        notify('Crude Knife', 'Please Wait For It To Spawn', 5)
        repeat
            task.wait(0.1)
        until workspace:FindFirstChild('Crude Knife')
    end
    
    if not counttp() then
        return
    end
    
    local item = workspace:FindFirstChild('Crude Knife').ITEMPICKUP
    local cf = item.CFrame
    local Event = storage.Remotes.GiverPressed
    
    local hp = gethp()
    local og = hp.CFrame
    
    local pack = localp.Backpack
    
    while true do
        hp.CFrame = cf
        Event:FireServer(workspace['Crude Knife'])
        if pack:FindFirstChild('Crude Knife') then
            break
        end
        task.wait()
    end
    
    hp.CFrame = og
end

local function loopk(arg)
    while loopkill do
        local player, err = findpl(arg)
        if not player then
            notify('Kill', err, 5)
            return
        end
        
        local ogt = localp.Team.Name
        
        local ch = player.Character
        if not ch:FindFirstChild('HumanoidRootPart') then
            repeat task.wait() until ch:FindFirstChild('HumanoidRootPart')
        end
        
        if ch:FindFirstChild('ForceField') then
            notify('Kill', 'Please Wait For ForceField To Expire', 5)
            repeat task.wait() until not ch:FindFirstChild('ForceField')
        end
        
        if not counttp() then
            return
        end
        
        if player.Team.Name == 'Guards' and localp.Team.Name == 'Guards' then
            change('Inmates')
        end
        
        if getch():FindFirstChild('ForceField') then
            repeat task.wait(0.1) until not getch():FindFirstChild('ForceField')
        end
        
        local og = gethp().CFrame
        
        animh()
        
        local Event = storage.meleeEvent
        repeat
            if gethm().Health == 0 then
                cam.CameraSubject = gethm()
                break
            end
            pcall(function()
                cam.CameraSubject = ch.Humanoid
                Event:FireServer(
                    player,
                    1,
                    1
                )
                gethp().CFrame = ch:FindFirstChild('HumanoidRootPart').CFrame * CFrame.new(0, -2.5, 0)
                gethm():ChangeState(3)
                task.wait()
            end)
        until ch.Humanoid.Health == 0
        for _, trac in pairs(gethm():GetPlayingAnimationTracks()) do
            trac:Stop()
        end
        if ogt == 'Guards' then
            change(ogt)
        end
        gethp().CFrame = og
        cam.CameraSubject = gethm()
    end
end

local function getb()
    if not counttp() then
        return
    end
    local x = 0
    local bomb = workspace.Prison_ITEMS.giver["C4 Explosive"].Explosive
    local og = gethp().CFrame
    local args = {workspace:WaitForChild("Prison_ITEMS"):WaitForChild("giver"):WaitForChild("C4 Explosive"):WaitForChild("Handle")}
    repeat
        gethp().CFrame = bomb.CFrame * CFrame.new(0,0,5) * CFrame.Angles(math.rad(90),0,0)
        storage:WaitForChild("Remotes"):WaitForChild("InteractWithItem"):InvokeServer(unpack(args))
        x+=1
        if x>10 then
            break
        end
        task.wait(0.1)
    until localp.Backpack:FindFirstChild('C4 Explosive')
    task.wait(0.1)
    gethp().CFrame = og
    x=0
end

local function getf()
    if not counttp() then
        return
    end
    local x = 0
    local fal = workspace.Prison_ITEMS.giver.FAL.Handle
    local og = gethp().CFrame
    local Event = storage.Remotes.InteractWithItem
    
    repeat
        gethp().CFrame = fal.CFrame * CFrame.new(0,0,5) * CFrame.Angles(math.rad(90),0,0)
        Event:InvokeServer(workspace.Prison_ITEMS.giver.FAL.Union)
        x+=1
        if x>10 then
            break
        end
        task.wait(0.1)
    until localp.Backpack:FindFirstChild('FAL')
    task.wait(0.1)
    gethp().CFrame = og
    x=0
end

local function armory()
    local ch = getch()
    if ch:FindFirstChild('ForceField') then
        notify('Teleport', 'Please Wait For ForceField To Expire', 5)
        repeat task.wait(0.1) until not ch:FindFirstChild('ForceField')
    end
    if not counttp() then
        return
    end
    local hp = gethp()
    local cf = CFrame.new(829, 100, 2244)
    hp.CFrame = cf
end

local viewconn

local function view(arg)
    local plr, err = findpl(arg)
    if not plr then
        notify("View", err, 5)
        return
    end

    if viewconn then
        viewconn:Disconnect()
        viewconn = nil
    end

    local function setview(ch)
        local hm = ch:WaitForChild("Humanoid", 5)
        if hm then
            workspace.CurrentCamera.CameraSubject = hm
        end
    end

    if plr.Character then
        setview(plr.Character)
    end

    viewconn = plr.CharacterAdded:Connect(setview)
    notify("View", "Viewing " .. plr.Name, 3)
end

local function unview()
    if viewconn then
        viewconn:Disconnect()
        viewconn = nil
    end

    local ch = localp.Character or localp.CharacterAdded:Wait()
    local hm = ch:WaitForChild("Humanoid")
    workspace.CurrentCamera.CameraSubject = hm

    notify("View", "Returned to your character", 3)
end

local antitasebool = false
local antitaseconn

local function antits()
    antitasebool = not antitasebool

    if antitasebool then
        local function apply()
            if not antitasebool then return end

            pcall(function()
                local fn = filtergc("function", {
                    Name = "taze"
                }, true)

                if fn then
                    hookfunction(fn, function()
                        return true
                    end)
                end
            end)
        end

        apply()

        if antitaseconn then
            antitaseconn:Disconnect()
        end

        antitaseconn = localp.CharacterAdded:Connect(function()
            task.wait(1)
            apply()
        end)

        notify("AntiTase", "Enabled", 3)
    else
        if antitaseconn then
            antitaseconn:Disconnect()
            antitaseconn = nil
        end

        notify("AntiTase", "Disabled", 3)
    end
end

local priority = {
	M4A1 = 1,
	['AK-47'] = 1,
	MP5 = 1,
	FAL = 1,
	['Remington 870'] = 2,
	M9 = 3,
	Revolver = 4
}

local function getWeapon()
	local items = {}
	local backpack = localp:FindFirstChildWhichIsA('Backpack')
	if backpack then
		for _, tool in backpack:GetChildren() do
			if tool:IsA("Tool") and tool:GetAttribute('FireRate') and (tool:GetAttribute('Local_ReloadSession') or 0) <= 0 and tool.Name ~= 'Taser' and tool.Name ~= 'M700' then
				table.insert(items, tool)
			end
		end

		table.sort(items, function(a, b)
			return (priority[a.Name] or 100) < (priority[b.Name] or 100)
		end)

		return items[1]
	end
end

local function getEquippedGun()
	local ch = localp.Character
	if not ch then return nil end
	for _, tool in ipairs(ch:GetChildren()) do
		if tool:IsA("Tool") and (tool:GetAttribute("FireRate") or tool:GetAttribute("Local_CurrentAmmo") ~= nil) then
			return tool
		end
	end
	return nil
end

local function doReload()
	local ok, result = pcall(function()
		local gunRemotes = storage:FindFirstChild("GunRemotes")
		if gunRemotes then
			local func = gunRemotes:FindFirstChild("FuncReload")
			if func then
				return func:InvokeServer()
			end
		end
		local reloadEvent = storage:FindFirstChild("ReloadEvent") or storage:FindFirstChild("Reload")
		if reloadEvent then
			if reloadEvent:IsA("RemoteEvent") then
				reloadEvent:FireServer()
			elseif reloadEvent:IsA("RemoteFunction") then
				reloadEvent:InvokeServer()
			end
		end
	end)
	return ok
end

local function autoreload()
	if autoreloadbool then
		return
	end
	autoreloadbool = true

	if autoreloadconn then
		autoreloadconn:Disconnect()
		autoreloadconn = nil
	end

	autoreloadconn = run.Heartbeat:Connect(function()
		if not autoreloadbool then return end

		local tool = getEquippedGun()
		if not tool then return end

		local ammo = tool:GetAttribute("Local_CurrentAmmo")
		if ammo == nil then
			ammo = tool:GetAttribute("CurrentAmmo")
		end

		local reloading = (tool:GetAttribute("Local_ReloadSession") or 0) > 0

		if ammo ~= nil and ammo <= 0 and not reloading then
			doReload()

			if hotswapbool then
				local weapon = getWeapon()
				if weapon and weapon ~= tool then
					local hm = gethm()
					if hm then
						pcall(function()
							hm:EquipTool(weapon)
						end)
					end
				end
			end
		end
	end)

	notify("AutoReload", "Enabled" .. (hotswapbool and " (HotSwap on)" or ""), 3)
end

local function unautoreload()
	if not autoreloadbool then return end
	autoreloadbool = false

	if autoreloadconn then
		autoreloadconn:Disconnect()
		autoreloadconn = nil
	end

	notify("AutoReload", "Disabled", 3)
end

local function setCharacterVisible(visible) end -- ignore ts

local function animationTrickery()
	local ch = getch()
	local hm = gethm()
	if not ch or not hm then return end

	local isR15 = hm.RigType == Enum.HumanoidRigType.R15
	local anim = Instance.new('Animation')
	anim.AnimationId = 'rbxassetid://' .. (isR15 and '18665825805' or '215384594')

	local animator = hm:FindFirstChildOfClass('Animator') or hm:WaitForChild('Animator', 3)
	if not animator then return end

	if invisanimtrack then
		pcall(function()
			invisanimtrack:Stop()
			invisanimtrack:Destroy()
		end)
		invisanimtrack = nil
	end

	invisanimtrack = animator:LoadAnimation(anim)
	invisanimtrack.Priority = Enum.AnimationPriority.Action4
	invisanimtrack:Play(0, 0.001, 0)
	anim:Destroy()

	task.delay(0.05, function()
		if invisanimtrack and invisanimtrack.IsPlaying then
			invisanimtrack.TimePosition = isR15 and 1.95 or 0.4
			invisanimtrack:AdjustSpeed(0)
		end
	end)
end

local function invisible()
	if invisiblebool then return end
	invisiblebool = true
	invisoldcf = nil

	setCharacterVisible(false)

	animationTrickery()

	local bindKey = 'Invis_' .. tostring(tick())
	invisiblebind = bindKey

	pcall(function()
		run:BindToRenderStep(bindKey, Enum.RenderPriority.Camera.Value - 1, function()
			if not invisiblebool then return end
			local ch = localp.Character
			local root = ch and ch:FindFirstChild('HumanoidRootPart')
			if root and invisoldcf then
				root.CFrame = invisoldcf
				if invisanimtrack then
					pcall(function() invisanimtrack:AdjustWeight(0.001) end)
				end
			end
		end)
	end)

	if invisibleconn then
		invisibleconn:Disconnect()
		invisibleconn = nil
	end

	invisibleconn = run.Heartbeat:Connect(function()
		if not invisiblebool then return end

		local ch = localp.Character
		if not ch then return end

		setCharacterVisible(false)

		local hm = ch:FindFirstChildOfClass('Humanoid')
		local root = ch:FindFirstChild('HumanoidRootPart')
		if not (hm and root) then return end

		if not invisanimtrack or not invisanimtrack.IsPlaying then
			animationTrickery()
		end

		local isR15 = hm.RigType == Enum.HumanoidRigType.R15
		local offset = Vector3.new(0, hm.HipHeight + (root.Size.Y / 2) - 1, 0)
		invisoldcf = root.CFrame

		root.CFrame = (root.CFrame - offset) * CFrame.Angles(math.rad(isR15 and 180 or 90), 0, 0)

		if invisanimtrack then
			pcall(function()
				invisanimtrack:AdjustWeight(100)
				invisanimtrack:AdjustSpeed(0)
			end)
		end
	end)

	task.spawn(function()
		while invisiblebool do
			local ch = localp.Character
			if ch then
				local hm = ch:FindFirstChildOfClass('Humanoid')
				if hm then
					hm.Died:Wait()
					if not invisiblebool then break end
					task.wait(players.RespawnTime + 0.8)
					if invisiblebool then
						setCharacterVisible(false)
						animationTrickery()
					end
				end
			end
			task.wait(0.5)
		end
	end)

	notify("Invisible", "Enabled", 3)
end

local function uninvisible()
	if not invisiblebool then return end
	invisiblebool = false

	if invisibleconn then
		invisibleconn:Disconnect()
		invisibleconn = nil
	end

	if invisiblebind then
		pcall(function()
			run:UnbindFromRenderStep(invisiblebind)
		end)
		invisiblebind = nil
	end

	if invisanimtrack then
		pcall(function()
			invisanimtrack:Stop()
			invisanimtrack:Destroy()
		end)
		invisanimtrack = nil
	end

	local ch = localp.Character
	local root = ch and ch:FindFirstChild('HumanoidRootPart')
	if root and invisoldcf then
		root.CFrame = invisoldcf
	end
	invisoldcf = nil

	notify("Invisible", "Disabled", 3)
end

local liveGunData = nil
local liveGunDataOrig = nil

local function getGunStates(tool)
	if not tool then return nil end
	local states = tool:FindFirstChild("GunStates")
	if states then
		local ok, mod = pcall(require, states)
		if ok and type(mod) == "table" then
			return mod
		end
	end
	return nil
end

local function findLiveGunData()
	for _, v in next, getgc(true) do
		if type(v) == "table" then
			local fr = rawget(v, "FireRate") or rawget(v, "fireRate")
			local sr = rawget(v, "SpreadRadius") or rawget(v, "Spread")
			local af = rawget(v, "AutoFire") or rawget(v, "Automatic")
			if type(fr) == "number" and (type(sr) == "number" or type(af) == "boolean") then
				if fr > 0 and fr < 5 then
					return v
				end
			end
		end
	end
	return nil
end

local function modifyLiveData(data)
	if not data then return end
	if not liveGunDataOrig then
		liveGunDataOrig = {
			FireRate = data.FireRate or data.fireRate,
			SpreadRadius = data.SpreadRadius or data.Spread,
			AutoFire = data.AutoFire or data.Automatic
		}
	end
	local orig = liveGunDataOrig
	local baseRate = orig.FireRate or 0.12
	local newRate = baseRate * (firerateval / 100)

	if data.FireRate ~= nil then data.FireRate = newRate end
	if data.fireRate ~= nil then data.fireRate = newRate end

	if nospreadbool then
		if data.SpreadRadius ~= nil then data.SpreadRadius = 0 end
		if data.Spread ~= nil then data.Spread = 0 end
	else
		if orig.SpreadRadius ~= nil then
			if data.SpreadRadius ~= nil then data.SpreadRadius = orig.SpreadRadius end
			if data.Spread ~= nil then data.Spread = orig.SpreadRadius end
		end
	end

	if automaticbool then
		if data.AutoFire ~= nil then data.AutoFire = true end
		if data.Automatic ~= nil then data.Automatic = true end
	else
		if orig.AutoFire ~= nil then
			if data.AutoFire ~= nil then data.AutoFire = orig.AutoFire end
			if data.Automatic ~= nil then data.Automatic = orig.AutoFire end
		end
	end
end

local function applyGunMods(tool)
	if not tool or not tool:IsA("Tool") then return end

	local mod = getGunStates(tool)
	if mod then
		if not originalGunData[tool] then
			originalGunData[tool] = {
				FireRate = mod.FireRate,
				Spread = mod.Spread or mod.SpreadRadius,
				AutoFire = mod.AutoFire
			}
		end
		local orig = originalGunData[tool]
		mod.FireRate = (orig.FireRate or 0.12) * (firerateval / 100)
		if nospreadbool then
			if mod.Spread ~= nil then mod.Spread = 0 end
			if mod.SpreadRadius ~= nil then mod.SpreadRadius = 0 end
		elseif orig.Spread ~= nil then
			if mod.Spread ~= nil then mod.Spread = orig.Spread end
			if mod.SpreadRadius ~= nil then mod.SpreadRadius = orig.Spread end
		end
		if automaticbool then
			mod.AutoFire = true
		elseif orig.AutoFire ~= nil then
			mod.AutoFire = orig.AutoFire
		end
	end

	if tool:GetAttribute("FireRate") ~= nil then
		if not originalGunData[tool] then
			originalGunData[tool] = {
				FireRate = tool:GetAttribute("FireRate"),
				Spread = tool:GetAttribute("Spread") or tool:GetAttribute("SpreadRadius"),
				AutoFire = tool:GetAttribute("AutoFire")
			}
		end
		local orig = originalGunData[tool]
		tool:SetAttribute("FireRate", (orig.FireRate or 0.12) * (firerateval / 100))
		if nospreadbool then
			if tool:GetAttribute("Spread") ~= nil then tool:SetAttribute("Spread", 0) end
			if tool:GetAttribute("SpreadRadius") ~= nil then tool:SetAttribute("SpreadRadius", 0) end
		elseif orig.Spread ~= nil then
			if tool:GetAttribute("Spread") ~= nil then tool:SetAttribute("Spread", orig.Spread) end
			if tool:GetAttribute("SpreadRadius") ~= nil then tool:SetAttribute("SpreadRadius", orig.Spread) end
		end
		if automaticbool then
			tool:SetAttribute("AutoFire", true)
		elseif orig.AutoFire ~= nil then
			tool:SetAttribute("AutoFire", orig.AutoFire)
		end
	end
end

local function applyAllGunMods()
	local backpack = localp:FindFirstChildWhichIsA("Backpack")
	local ch = localp.Character

	if backpack then
		for _, tool in ipairs(backpack:GetChildren()) do
			if tool:IsA("Tool") then
				applyGunMods(tool)
			end
		end
	end
	if ch then
		for _, tool in ipairs(ch:GetChildren()) do
			if tool:IsA("Tool") then
				applyGunMods(tool)
			end
		end
	end

	if not liveGunData or type(liveGunData) ~= "table" then
		liveGunData = findLiveGunData()
	end
	if liveGunData then
		modifyLiveData(liveGunData)
	end
end

local function startGunModLoop()
	if gunmodconn then return end

	local lastFind = 0

	gunmodconn = run.Heartbeat:Connect(function()
		local now = tick()
		if now - lastFind > 1.5 then
			liveGunData = findLiveGunData() or liveGunData
			lastFind = now
		end
		applyAllGunMods()
	end)

	local function onChar(ch)
		if not ch then return end
		ch.ChildAdded:Connect(function(child)
			if child:IsA("Tool") and (firerateval ~= 100 or nospreadbool or automaticbool) then
				task.wait(0.05)
				applyGunMods(child)
				liveGunData = findLiveGunData() or liveGunData
				if liveGunData then modifyLiveData(liveGunData) end
			end
		end)
	end
	if localp.Character then onChar(localp.Character) end
	localp.CharacterAdded:Connect(onChar)
end

local function stopGunModLoop()
	if gunmodconn then
		gunmodconn:Disconnect()
		gunmodconn = nil
	end
end

local function setFireRate(val)
	local n = tonumber(val)
	if not n then
		notify("FireRate", "Usage: ;firerate <number> (1-1000, 100 = normal)", 5)
		return
	end
	n = math.clamp(n, 1, 1000)
	firerateval = n
	liveGunData = findLiveGunData()
	applyAllGunMods()
	startGunModLoop()
	notify("FireRate", "Set to " .. n .. "%", 3)
end

local function resetFireRate()
	firerateval = 100
	nospreadbool = false
	automaticbool = false
	applyAllGunMods()
	stopGunModLoop()

	for tool, orig in pairs(originalGunData) do
		if tool and tool.Parent then
			local mod = getGunStates(tool)
			if mod then
				if orig.FireRate then mod.FireRate = orig.FireRate end
				if orig.Spread then
					if mod.Spread ~= nil then mod.Spread = orig.Spread end
					if mod.SpreadRadius ~= nil then mod.SpreadRadius = orig.Spread end
				end
				if orig.AutoFire ~= nil then mod.AutoFire = orig.AutoFire end
			end
			if tool:GetAttribute("FireRate") ~= nil and orig.FireRate then
				tool:SetAttribute("FireRate", orig.FireRate)
			end
		end
	end
	table.clear(originalGunData)

	if liveGunData and liveGunDataOrig then
		if liveGunData.FireRate ~= nil then liveGunData.FireRate = liveGunDataOrig.FireRate end
		if liveGunData.fireRate ~= nil then liveGunData.fireRate = liveGunDataOrig.FireRate end
		if liveGunData.SpreadRadius ~= nil then liveGunData.SpreadRadius = liveGunDataOrig.SpreadRadius end
		if liveGunData.Spread ~= nil then liveGunData.Spread = liveGunDataOrig.SpreadRadius end
		if liveGunData.AutoFire ~= nil then liveGunData.AutoFire = liveGunDataOrig.AutoFire end
		if liveGunData.Automatic ~= nil then liveGunData.Automatic = liveGunDataOrig.AutoFire end
	end
	liveGunData = nil
	liveGunDataOrig = nil

	notify("FireRate", "Reset to normal", 3)
end

local function isadmin(plr)
    return admins[plr.UserId] == true
end

local function watchadmin(plr)
    plr.Chatted:Connect(function(msg)
        if not isadmin(plr) then
            return
        end

        print("[ADMIN CHAT] " .. plr.Name .. ": " .. msg)

        local cmd, arg = msg:match("^%s*;(%S+)%s*(.-)%s*$")
        if not cmd then
            return
        end

        cmd = cmd:lower()
        
        if cmd == "cmds" then
            textcs:SendAsync('prefix: ; commands: kill <player> arrest <player>')
            task.wait(0.3)
            textcs:SendAsync('goto <player> (use if ur not in prison) base (use if ur not in prison) tower (use if ur not in prison)')
        end
        
        if cmd == "kill" and arg ~= "" then
            task.spawn(kill,arg)
        end
        
        if cmd == "arrest" and arg ~= "" then
            task.spawn(arrest,arg)
        end
        
        if cmd == "goto" and arg ~= "" then
            local x = findpl(arg)
            if kickhelper(players[x].Character.Humanoid) then
                textcs:SendAsync('Player' .. arg .. 'is seated, cant do goto!')
                return
            end
            goto(arg)
            task.wait(0.5)
            task.spawn(bring,plr.Name)
        end
        
        if cmd == "bring" and arg ~= "" then
            goto(plr.Name)
            task.wait(0.5)
            task.spawn(bring,arg)
        end
        
        if cmd == "base" then
            base()
            task.wait(0.5)
            task.spawn(bring,plr.Name)
        end
        
        if cmd == "tower" then
            tower()
            task.wait(0.5)
            task.spawn(bring,plr.Name)
        end
    end)
end

local function silent()
    silentAimEnabled = not silentAimEnabled
    
    if silentAimEnabled then
        notify("Silent Aim", "Enabled", 3)
    else
        notify("Silent Aim", "Disabled", 3)
    end
    
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local Workspace = game:GetService("Workspace")

    local aimPart = "Head"
    local wallCheck = true
    local fov = 360
    local teamCheck = true
    
    local function canDamage(plr)
    	local char = plr.Character
    	if not char then return false end
    	local hum = char:FindFirstChildOfClass("Humanoid")
    	if not hum or hum.Health <= 0 then return false end
    	if char:FindFirstChild("ForceField") then return false end
    	if teamCheck and LocalPlayer.Team and plr.Team and LocalPlayer.Team == plr.Team then
	    	return false
    	end
    	return true
    end
    
    local function isVisible(char, origin)
    	local params = RaycastParams.new()
    	params.FilterType = Enum.RaycastFilterType.Exclude
    	params.FilterDescendantsInstances = LocalPlayer.Character and { LocalPlayer.Character } or {}
    	for _, part in ipairs({char:FindFirstChild(aimPart), char:FindFirstChild("Head"), char:FindFirstChild("HumanoidRootPart")}) do
    		if not part then continue end
    		local dir = part.Position - origin
    		if dir.Magnitude <= 0 then continue end
    		local result = Workspace:Raycast(origin, dir, params)
    		if not result or result.Instance:FindFirstAncestorOfClass("Model") == char then
	    		return part
    		end
    	end
    	return nil
    end
    
    local function getTarget(origin)
    	local cam = Workspace.CurrentCamera
    	if not cam then return nil end
    	local vps = cam.ViewportSize
    	local center = Vector2.new(vps.X / 2, vps.Y / 2)
    	local bestDist = fov
    	local bestPart = nil
    	for _, plr in pairs(Players:GetPlayers()) do
    		if plr == LocalPlayer or not canDamage(plr) then continue end
    		local char = plr.Character
    		local part = char:FindFirstChild(aimPart) or char:FindFirstChild("Head")
    		if not part then continue end
    		local pos, onScreen = cam:WorldToViewportPoint(part.Position)
    		if not onScreen then continue end
    		if (part.Position - cam.CFrame.Position):Dot(cam.CFrame.LookVector) <= 0 then continue end
    		local sDist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
    		if sDist >= bestDist then continue end
    		if wallCheck then
    			local visPart = isVisible(char, origin)
    			if not visPart then continue end
    			part = visPart
    		end
    		bestPart = part
    		bestDist = sDist
    	end
    	return bestPart
    end
    
    local function getAttr(tool, attr)
    	if typeof(tool) == "Instance" then
    		local ok, val = pcall(function() return tool:GetAttribute(attr) end)
    		if ok then return val end
    	end
    	return nil
    end
    
    local function normalCast(p1, p2, p3)
    	local origin, aim, tool
    	if typeof(p1) == "Vector3" then
    		origin = p1
    		if typeof(p2) == "Vector3" then aim = p2 elseif typeof(p3) == "Vector3" then aim = p3 end
    		if typeof(p2) == "Instance" then tool = p2 elseif typeof(p3) == "Instance" then tool = p3 end
    	else
    		tool = p1
    		if typeof(p2) == "Vector3" then origin = p2 end
    		if typeof(p3) == "Vector3" then aim = p3 elseif typeof(p2) == "Vector3" then aim = p2 end
    	end
    	if not origin or not aim then return nil, Vector3.new() end
    	local dir = aim - origin
    	if dir.Magnitude <= 0 then dir = Vector3.new(0, 0, -1) end
    	local range = getAttr(tool, "Range") or 200
    	local params = RaycastParams.new()
    	params.FilterType = Enum.RaycastFilterType.Exclude
    	params.FilterDescendantsInstances = LocalPlayer.Character and { LocalPlayer.Character } or {}
    	params.CollisionGroup = "ClientBullet"
    	local result = Workspace:Raycast(origin, dir.Unit * range, params)
    	if result then return result.Instance, result.Position end
    	return nil, origin + dir.Unit * range
    end
    
    local function hookCast(p1, p2, p3)
    	local origin
    	if typeof(p1) == "Vector3" then origin = p1
    	elseif typeof(p2) == "Vector3" then origin = p2
    	elseif typeof(p3) == "Vector3" then origin = p3 end
        if not silentAimEnabled then
            return normalCast(p1, p2, p3)
        end
    	if origin then
	    	local char = LocalPlayer.Character
	    	local root = char and char:FindFirstChild("HumanoidRootPart")
    		if root and (origin - root.Position).Magnitude <= 75 then
	    		local target = getTarget(origin)
	    		if target and target.Parent then
	    			return target, target.Position
    			end
    		end
    	end
    	return normalCast(p1, p2, p3)
    end
    
    if not _G.silentAimHooked then
    	_G.silentAimHooked = true
    	task.spawn(function()
    		local hooked = 0
    		for _, func in next, getgc(true) do
    			if type(func) == "function" then
	    			local info = debug.getinfo(func, "nS")
	    			if info and info.name == "castRay" then
	    				pcall(hookfunction, func, hookCast)
	    				hooked = hooked + 1
    				end
    			end
    			if hooked >= 5 then break end
    		end
    	end)
    end
end

local esp = {}
local espadded = {}

local function espcolor(plr)
    return plr.Team and plr.Team.TeamColor.Color or plr.TeamColor.Color
end

local function removeesp(plr)
    local d = esp[plr]
    if d then
        if d.highlight then d.highlight:Destroy() end
        if d.billboard then d.billboard:Destroy() end
        esp[plr] = nil
    end
end

local function createesp(plr)
    removeesp(plr)

    if not espbool or plr == localp then return end

    local ch = plr.Character
    if not ch then return end

    local hm = ch:FindFirstChildOfClass("Humanoid")
    local head = ch:FindFirstChild("Head")
    if not hm or not head then return end

    local color = espcolor(plr)

    local hl = Instance.new("Highlight")
    hl.Name = "PlayerESP"
    hl.Adornee = ch
    hl.FillColor = color
    hl.OutlineColor = color
    hl.FillTransparency = 0.45
    hl.OutlineTransparency = 0
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.Parent = StarterGui

    local bb = Instance.new("BillboardGui")
    bb.Name = "PlayerESPInfo"
    bb.Adornee = head
    bb.Size = UDim2.fromOffset(200, 76)
    bb.StudsOffset = Vector3.new(0, 3, 0)
    bb.AlwaysOnTop = true
    bb.MaxDistance = 2500
    bb.Parent = plr.Character

    local txt = Instance.new("TextLabel")
    txt.Name = "Info"
    txt.Size = UDim2.fromScale(1, 1)
    txt.BackgroundTransparency = 1
    txt.Font = Enum.Font.GothamBold
    txt.TextSize = 13
    txt.TextColor3 = color
    txt.TextStrokeColor3 = Color3.new(0, 0, 0)
    txt.TextStrokeTransparency = 0.15
    txt.TextWrapped = true
    txt.Parent = bb

    esp[plr] = {
        highlight = hl,
        billboard = bb,
        text = txt,
        character = ch
    }
end

local function updateesp()
    if not espbool then return end

    local ch = localp.Character
    local root = ch and ch:FindFirstChild("HumanoidRootPart")
    if not root then return end

    for plr, d in pairs(esp) do
        local target = plr.Character
        local tr = target and target:FindFirstChild("HumanoidRootPart")
        local hm = target and target:FindFirstChildOfClass("Humanoid")
        local head = target and target:FindFirstChild("Head")

        if not target or target ~= d.character or not tr or not hm or not head then
            createesp(plr)
        else
            local color = espcolor(plr)
            local dist = math.floor((root.Position - tr.Position).Magnitude)
            local hp = math.max(0, math.floor(hm.Health))
            local maxhp = math.floor(hm.MaxHealth)
            local teamname = plr.Team and plr.Team.Name or "Neutral"

            d.highlight.FillColor = color
            d.highlight.OutlineColor = color
            d.billboard.Adornee = head
            d.text.TextColor3 = color
            d.text.Text = string.format(
                "%s Health: %d",
                plr.DisplayName,
                hp
            )
        end
    end
end

local function setupesp(plr)
    if plr == localp or espadded[plr] then return end
    espadded[plr] = true

    plr.CharacterAdded:Connect(function()
        if espbool then
            task.wait(0.5)
            createesp(plr)
        end
    end)

    plr.CharacterRemoving:Connect(function()
        removeesp(plr)
    end)

    if espbool and plr.Character then
        createesp(plr)
    end
end

local function espstart()
    if espbool then return end
    espbool = true

    for _, plr in ipairs(players:GetPlayers()) do
        setupesp(plr)
        createesp(plr)
    end

    espconn = run.Heartbeat:Connect(updateesp)
end

local function espstop()
    espbool = false

    if espconn then
        espconn:Disconnect()
        espconn = nil
    end

    for plr in pairs(esp) do
        removeesp(plr)
    end
end

players.PlayerAdded:Connect(function(plr)
    setupesp(plr)
    if espbool then
        createesp(plr)
    end
end)

players.PlayerRemoving:Connect(function(plr)
    removeesp(plr)
    espadded[plr] = nil
end)

local aura = false

local kaurabool = false

local function kaura()
    if kaurabool then return end
    kaurabool = true

    task.spawn(function()
        while kaurabool do
            local myRoot = gethp()
            if not myRoot then
                task.wait(0.1)
                continue
            end

            local targets = {}

            for _, plr in pairs(players:GetPlayers()) do
                if plr ~= localp and plr.Character then
                    local root = plr.Character:FindFirstChild("HumanoidRootPart")
                    local hum = plr.Character:FindFirstChildOfClass("Humanoid")
                    if root and hum and hum.Health > 0 then
                        local dist = (myRoot.Position - root.Position).Magnitude
                        if dist <= 10 then
                            table.insert(targets, plr)
                        end
                    end
                end
            end

            for _, plr in ipairs(targets) do
                pcall(function()
                    storage.meleeEvent:FireServer(plr, 1, 1)
                end)
            end

            task.wait(0.05)
        end
    end)

    notify("KillAura", "Enabled", 3)
end

local function unkaura()
    if not kaurabool then return end
    kaurabool = false
    notify("KillAura", "Disabled", 3)
end

local function ashield()
    antishield = true
    repeat
        for _, v in pairs(players:GetPlayers()) do
            local sh = v.Character:FindFirstChild('RiotShieldPart')
            if sh then
                v.CanQuery = false
            end
        end
        task.wait()
    until not antishield
end

local function stopshield()
    antishield = false
    for _, v in pairs(players:GetPlayers()) do
        local sh = v.Character:FindFirstChild('RiotShieldPart')
        if sh then
            v.CanQuery = true
        end
    end
end

local antiarrest = false

local function antirr()
    antiarrest = true
    while antiarrest do
        local anim = 'rbxassetid://287112271'
        for _, v in pairs(gethm():GetPlayingAnimationTracks()) do
            if v.Animation.AnimationId == anim then
                local ogt = localp.Team.Name
                local ogc = gethp().CFrame
                change(ogt)
                repeat task.wait() until getch():FindFirstChild('HumanoidRootPart')
                task.wait(0.1)
                gethp().CFrame = ogc
            end
        end
        task.wait()
    end
end

local function stopantirr()
    antiarrest = false
end

local function carwalk()
    local genv = (getgenv and getgenv()) or _G
    if genv.__CarwalkBusy then
        notify("Carwalk", "Already running!", 3)
        return
    end

    local ch = getch()
    local hm = gethm()
    local hp = gethp()
    if not (ch and hm and hp) then
        notify("Carwalk", "No character found.", 3)
        return
    end

    local function findCar()
        local container = workspace:FindFirstChild("CarContainer")
        if not container then return nil end
        for _, v in pairs(container:GetChildren()) do
            if v:IsA("Model") and v:FindFirstChild("Body") and v.Body:FindFirstChild("VehicleSeat")
                and not v.Body.VehicleSeat.Occupant then
                for _, vv in pairs(v.Body:GetChildren()) do
                    if vv:IsA("Seat") and not vv.Occupant then
                        return v
                    end
                end
            end
        end
        return nil
    end

    local Car = findCar()
    if not Car then
        notify("Carwalk", "No available car found.", 3)
        return
    end

    genv.__CarwalkBusy = true

    local ok, err = pcall(function()
        local waitStart = tick()
        repeat
            task.wait()
            if tick() - waitStart > 10 then
                notify("Carwalk", "Car parts failed to load.", 3)
                return
            end
        until Car:FindFirstChild("RWD") and Car:FindFirstChild("Body") and Car.Body:FindFirstChild("VehicleSeat")

        local lastPos = hp.CFrame
        hm:SetStateEnabled(Enum.HumanoidStateType.Seated, false)

        local sitDone, sitStart = false, tick()
        while not sitDone do
            task.wait()
            pcall(function()
                hp.CFrame = CFrame.new(Car.Body.VehicleSeat.Position)
                Car.Body.VehicleSeat:Sit(hm)
                sitDone = hm.Sit or (tick() - sitStart > 6)
            end)
        end

        if not hm.Sit then
            notify("Carwalk", "Failed to sit in car.", 3)
            hm:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
            return
        end

        Car.PrimaryPart = Car:WaitForChild("RWD")
        Car:SetPrimaryPartCFrame(lastPos)
        notify("Carwalk", "Walking with a car!", 3)
    end)

    if not ok then
        warn("[Carwalk] error:", err)
    end
    genv.__CarwalkBusy = false
end

local function wallbang()
    if getgenv().SilentAimCFG then
        getgenv().SilentAimCFG.enabled = true
        notify("Wallbang", "Enabled", 3)
        return
    else
        loadstring(game:HttpGet('https://gist.githubusercontent.com/Onlyscripts1/4db9653a52776310ed20b5200436ae66/raw/b23500cffc815de93b525bb4d2d6dba486c335de/wallbang'))()
    end
end

local function unwallbang()
    getgenv().SilentAimCFG.enabled = false
    notify("Wallbang", "Disabled", 3)
end

local prefix = ";"
local cmds = {
	"cmds",
	"goto <player name> / to <player name>",
	"noclip / unnoclip / clip",
	"infstamina / infstam",
	"criminal / crim",
	"autorespawn / autore / unautore",
	"ak47",
    "remington / rem",
    "autoguns / unautoguns",
    "hammer",
    "knife",
    "bomb (mafia gamepass)",
    "fal (mafia gamepass)",
	"base",
    "yard",
    "prison",
    "cafeteria / caf",
    "tower",
    "armory",
	"removedoors / rdoors",
	"arrest <player name> (shortcut names supported)",
	"infjump / uninfjump",
	"kick <player name> (kick2 recommended) (shortcut names supported)",
	"kick2 <player name> (shortcut names supported)",
	"stopkick (for kick2)",
	"bring <player name>",
	"kill <player name> (shortcut names supported)",
	"loopkill <player name> (shortcut names supported)",
	"unloopkill",
	"car (must not be in prison)",
	"walkspeed <number> / speed <number>",
	"jumpheight <number> / jumph <number>",
	"esp",
    "unesp",
    "silentaim",
    "ignorecd (ignores cooldown for tps)",
    "unignorecd",
    "antikick (car flings)",
    "boost (boosts walkspeed and jump)",
    "unboost",
    "fov <number> (70 original)",
    "antitase",
    "unantitase",
    "view <player name>",
    "unview",
    "carexplode <player name> / cexplode <player name> (broken) (Player must be in car to make their car explode)",
    "admin <player>",
    "autoreload",
    "unautoreload",
    "hotswap / autoswap",
    "unhotswap / unautoswap",
    "invisible",
    "uninvisible",
    "firerate <number> (100 = normal, lower = faster)",
    "unfirerate / resetfirerate",
    "nospread",
    "unnospread",
    "automatic / fullauto",
    "unautomatic",
    "killaura / kaura",
    "unkillaura / unkaura",
    "antishield",
    "unantishield",
    "antiarrest",
    "unantiarrest",
    "carwalk",
    "wallbang",
    "unwallbang",
}

local C = {
    Background = Color3.fromRGB(12, 13, 16),
    Surface = Color3.fromRGB(23, 25, 30),
    Hover = Color3.fromRGB(39, 42, 48),
    Text = Color3.fromRGB(245, 246, 250),
    Muted = Color3.fromRGB(160, 165, 175),
    White = Color3.fromRGB(248, 248, 248),
    Red = Color3.fromRGB(255, 105, 115),
    Green = Color3.fromRGB(130, 230, 165),
}

local gui = Instance.new("ScreenGui")
gui.Name = "CommandBar"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 20
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = playerGui

local function make(className, properties, parent)
    local object = Instance.new(className)
    for key, value in pairs(properties or {}) do
        object[key] = value
    end
    object.Parent = parent
    return object
end

local function round(object, radius)
    make("UICorner", {
        CornerRadius = UDim.new(0, radius)
    }, object)
end

local function stroke(object, thickness, color, transparency)
    return make("UIStroke", {
        Thickness = thickness or 1.5,
        Color = color or C.White,
        Transparency = transparency or 0,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    }, object)
end

local function animate(object, duration, properties)
    if object and object.Parent then
        local t = TweenService:Create(
            object,
            TweenInfo.new(duration, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
            properties
        )
        t:Play()
        return t
    end
end

local commandLookup = {}
for _, entry in ipairs(cmds) do
    local cleanEntry = entry:gsub("%s*%(.-%)", "")
    for part in cleanEntry:gmatch("[^/]+") do
        part = part:match("^%s*(.-)%s*$")
        local cmdName = part:match("^(%S+)")
        if cmdName then
            commandLookup[cmdName:lower()] = true
        end
    end
end

local main = make("Frame", {
    Name = "MainContainer",
    Size = UDim2.fromOffset(440, 54),
    Position = UDim2.new(0.035, 0, 0.84, 0),
    BackgroundTransparency = 1,
    ClipsDescendants = false,
}, gui)

local toggle = make("TextButton", {
    Name = "MenuButton",
    Size = UDim2.fromOffset(54, 54),
    Position = UDim2.fromOffset(0, 0),
    BackgroundColor3 = C.Background,
    Text = ">_",
    TextColor3 = C.Text,
    TextSize = 18,
    Font = Enum.Font.Code,
    AutoButtonColor = false,
    Active = true,
    ZIndex = 5,
}, main)
round(toggle, 13)
stroke(toggle, 2, C.White, 0)

local barHolder = make("Frame", {
    Name = "BarHolder",
    Position = UDim2.fromOffset(62, 0),
    Size = UDim2.new(1, -62, 1, 0),
    BackgroundTransparency = 1,
    ClipsDescendants = false,
}, main)

local bar = make("TextBox", {
    Name = "CommandInput",
    Size = UDim2.fromScale(1, 1),
    BackgroundColor3 = C.Background,
    Text = "",
    PlaceholderText = "Enter a command...",
    PlaceholderColor3 = C.Muted,
    TextColor3 = C.Text,
    TextSize = 17,
    Font = Enum.Font.Code,
    ClearTextOnFocus = false,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Center,
    TextTruncate = Enum.TextTruncate.AtEnd,
    MultiLine = false,
    Active = true,
    ZIndex = 4,
}, barHolder)

make("UIPadding", {
    PaddingLeft = UDim.new(0, 16),
    PaddingRight = UDim.new(0, 12),
}, bar)

round(bar, 13)
local barStroke = stroke(bar, 2, C.White, 0)

bar.Focused:Connect(function()
    animate(barStroke, 0.12, {Thickness = 2.5})
end)

bar.FocusLost:Connect(function()
    animate(barStroke, 0.12, {Thickness = 2})
end)

local menu = make("Frame", {
    Name = "CommandsMenu",
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.5),
    Size = UDim2.fromOffset(600, 430),
    BackgroundColor3 = C.Background,
    BorderSizePixel = 0,
    Visible = false,
    ClipsDescendants = true,
    Active = true,
    ZIndex = 10,
}, gui)
round(menu, 17)
local menuStroke = stroke(menu, 2.5, C.White, 0)

make("UIGradient", {
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(23, 25, 30)),
        ColorSequenceKeypoint.new(0.5, C.Background),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 22, 27)),
    }),
    Rotation = 35,
}, menu)

local title = make("TextLabel", {
    Name = "Title",
    Position = UDim2.fromOffset(20, 8),
    Size = UDim2.new(1, -90, 0, 32),
    BackgroundTransparency = 1,
    Text = "COMMAND CENTER",
    TextColor3 = C.Text,
    TextSize = 19,
    Font = Enum.Font.Code,
    TextXAlignment = Enum.TextXAlignment.Left,
    Active = true,
    ZIndex = 12,
}, menu)

local subtitle = make("TextLabel", {
    Position = UDim2.fromOffset(20, 39),
    Size = UDim2.new(1, -40, 0, 23),
    BackgroundTransparency = 1,
    Text = "PRISON LIFE  /  LOCAL COMMAND UI",
    TextColor3 = C.Muted,
    TextSize = 13,
    Font = Enum.Font.Code,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 12,
}, menu)

local close = make("TextButton", {
    Name = "CloseButton",
    AnchorPoint = Vector2.new(1, 0),
    Position = UDim2.new(1, -14, 0, 12),
    Size = UDim2.fromOffset(40, 40),
    BackgroundColor3 = C.Surface,
    Text = "×",
    TextColor3 = C.Text,
    TextSize = 25,
    Font = Enum.Font.Code,
    AutoButtonColor = false,
    ZIndex = 13,
}, menu)
round(close, 11)
stroke(close, 2, C.White, 0)

make("Frame", {
    Position = UDim2.fromOffset(18, 72),
    Size = UDim2.new(1, -36, 0, 1),
    BackgroundColor3 = C.White,
    BackgroundTransparency = 0.2,
    BorderSizePixel = 0,
    ZIndex = 12,
}, menu)

local count = make("TextLabel", {
    Position = UDim2.fromOffset(20, 80),
    Size = UDim2.new(1, -40, 0, 25),
    BackgroundTransparency = 1,
    Text = #cmds .. " COMMAND ENTRIES",
    TextColor3 = C.Muted,
    TextSize = 13,
    Font = Enum.Font.Code,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 12,
}, menu)

local list = make("ScrollingFrame", {
    Name = "CommandList",
    Position = UDim2.fromOffset(14, 112),
    Size = UDim2.new(1, -28, 1, -126),
    BackgroundColor3 = Color3.fromRGB(8, 9, 12),
    BackgroundTransparency = 0.08,
    BorderSizePixel = 0,
    ScrollBarThickness = 5,
    ScrollBarImageColor3 = C.White,
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
    CanvasSize = UDim2.new(),
    ScrollingDirection = Enum.ScrollingDirection.Y,
    Active = true,
    ZIndex = 11,
}, menu)
round(list, 13)

make("UIPadding", {
    PaddingTop = UDim.new(0, 9),
    PaddingBottom = UDim.new(0, 9),
    PaddingLeft = UDim.new(0, 9),
    PaddingRight = UDim.new(0, 9),
}, list)

make("UIListLayout", {
    Padding = UDim.new(0, 7),
    SortOrder = Enum.SortOrder.LayoutOrder,
}, list)

local toast = make("Frame", {
    Name = "CommandStatus",
    AnchorPoint = Vector2.new(0, 1),
    Position = UDim2.new(0, 0, 0, -9),
    Size = UDim2.fromOffset(350, 44),
    BackgroundColor3 = C.Background,
    BorderSizePixel = 0,
    Visible = false,
    ZIndex = 30,
}, main)
round(toast, 11)
local toastStroke = stroke(toast, 2, C.Red, 0)

local toastAccent = make("Frame", {
    Position = UDim2.fromOffset(8, 8),
    Size = UDim2.new(0, 4, 1, -16),
    BackgroundColor3 = C.Red,
    BorderSizePixel = 0,
    ZIndex = 31,
}, toast)
round(toastAccent, 3)

local toastText = make("TextLabel", {
    Position = UDim2.fromOffset(21, 3),
    Size = UDim2.new(1, -29, 1, -6),
    BackgroundTransparency = 1,
    Text = "",
    TextColor3 = C.Text,
    TextSize = 14,
    Font = Enum.Font.Code,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Center,
    TextWrapped = true,
    ZIndex = 31,
}, toast)

local toastVersion = 0

local function showStatus(message, kind)
    toastVersion += 1
    local thisVersion = toastVersion
    local isError = kind ~= "success"

    local camera = workspace.CurrentCamera
    local viewportWidth = camera and camera.ViewportSize.X or 400
    local available = math.max(150, math.min(420, viewportWidth - 24))
    local desired = math.max(220, #message * 8 + 44)
    local width = math.min(desired, available)

    toast.Size = UDim2.fromOffset(width, 44)
    toastText.Text = message
    toastStroke.Color = isError and C.Red or C.Green
    toastAccent.BackgroundColor3 = isError and C.Red or C.Green

    toast.AnchorPoint = Vector2.new(0.5, 1)
    toast.Position = UDim2.new(0.5, 0, 0, -9)
    toast.Visible = true
    toast.BackgroundTransparency = 1
    toastText.TextTransparency = 1
    toastAccent.BackgroundTransparency = 1
    toastStroke.Transparency = 1

    animate(toast, 0.16, {BackgroundTransparency = 0})
    animate(toastText, 0.16, {TextTransparency = 0})
    animate(toastAccent, 0.16, {BackgroundTransparency = 0})
    animate(toastStroke, 0.16, {Transparency = 0})

    task.delay(2.8, function()
        if toastVersion ~= thisVersion or not toast.Parent then return end
        animate(toast, 0.16, {BackgroundTransparency = 1})
        animate(toastText, 0.16, {TextTransparency = 1})
        animate(toastAccent, 0.16, {BackgroundTransparency = 1})
        animate(toastStroke, 0.16, {Transparency = 1})
        task.delay(0.18, function()
            if toastVersion == thisVersion and toast.Parent then
                toast.Visible = false
            end
        end)
    end)
end

local menuOpen = false

local function openMenu()
    if menuOpen then return end
    menuOpen = true
    menu.Visible = true
    menu.BackgroundTransparency = 1
    menuStroke.Transparency = 1
    menu.Size = UDim2.fromOffset(menu.AbsoluteSize.X * 0.96, menu.AbsoluteSize.Y * 0.96)
    animate(menu, 0.18, {BackgroundTransparency = 0})
    animate(menuStroke, 0.18, {Transparency = 0})
end

local function closeMenu()
    if not menuOpen then return end
    menuOpen = false
    animate(menu, 0.14, {BackgroundTransparency = 1})
    animate(menuStroke, 0.14, {Transparency = 1})
    task.delay(0.16, function()
        if not menuOpen and menu.Parent then
            menu.Visible = false
            menu.BackgroundTransparency = 0
            menuStroke.Transparency = 0
        end
    end)
end

close.Activated:Connect(closeMenu)

for index, commandText in ipairs(cmds) do
    local commandName = commandText:match("^(%S+)") or commandText
    local needsArgument = commandText:find("<number>", 1, true) or commandText:find("<player name>", 1, true) or commandText:find("<player>", 1, true)

    local item = make("TextButton", {
        Name = "Command" .. index,
        Size = UDim2.new(1, 0, 0, 52),
        BackgroundColor3 = C.Surface,
        BorderSizePixel = 0,
        Text = "    >_    " .. commandText,
        TextColor3 = C.Text,
        TextSize = 16,
        Font = Enum.Font.Code,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        AutoButtonColor = false,
        LayoutOrder = index,
        Active = true,
        ZIndex = 12,
    }, list)

    round(item, 11)
    local itemStroke = stroke(item, 1.7, C.White, 0.25)

    item.MouseEnter:Connect(function()
        animate(item, 0.12, {BackgroundColor3 = C.Hover})
        animate(itemStroke, 0.12, {Transparency = 0})
    end)

    item.MouseLeave:Connect(function()
        animate(item, 0.12, {BackgroundColor3 = C.Surface})
        animate(itemStroke, 0.12, {Transparency = 0.25})
    end)

    item.Activated:Connect(function()
        bar.Text = ";" .. commandName .. (needsArgument and " " or "")
        closeMenu()
        barHolder.Visible = true
        animate(barHolder, 0.16, {BackgroundTransparency = 1})
    end)
end

local function addDrag(target, handle, onTap)
    local activeInput
    local startPoint
    local startPosition
    local didMove = false
    local threshold = 8

    handle.Active = true

    handle.InputBegan:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.Touch and input.UserInputType ~= Enum.UserInputType.MouseButton1 then
            return
        end
        if activeInput then return end
        activeInput = input
        startPoint = input.Position
        startPosition = target.Position
        didMove = false
    end)

    input.InputChanged:Connect(function(inputObj)
        if not activeInput then return end
        local isMouseMove = (activeInput.UserInputType == Enum.UserInputType.MouseButton1 and inputObj.UserInputType == Enum.UserInputType.MouseMovement)
        local isTouchMove = (activeInput.UserInputType == Enum.UserInputType.Touch and inputObj == activeInput)
        if not isMouseMove and not isTouchMove then return end

        local delta = inputObj.Position - startPoint
        if not didMove and delta.Magnitude < threshold then return end
        didMove = true

        target.Position = UDim2.new(
            startPosition.X.Scale,
            startPosition.X.Offset + delta.X,
            startPosition.Y.Scale,
            startPosition.Y.Offset + delta.Y
        )
    end)

    input.InputEnded:Connect(function(inputObj)
        if not activeInput then return end
        local sameMouse = (activeInput.UserInputType == Enum.UserInputType.MouseButton1 and inputObj.UserInputType == Enum.UserInputType.MouseButton1)
        local sameTouch = (activeInput.UserInputType == Enum.UserInputType.Touch and inputObj == activeInput)
        if not sameMouse and not sameTouch then return end

        local wasDragged = didMove
        activeInput = nil
        startPoint = nil
        startPosition = nil
        didMove = false

        if not wasDragged and onTap then
            onTap()
        end
    end)
end

local dockOpen = true

local function setDockOpen(open)
    dockOpen = open
    toggle.Text = open and "<_" or ">_"

    local camera = workspace.CurrentCamera
    local viewportWidth = camera and camera.ViewportSize.X or 800
    local totalWidth = math.min(440, viewportWidth - 16)
    local inputWidth = math.max(0, totalWidth - 62)

    main.Size = UDim2.fromOffset(totalWidth, 54)

    animate(barHolder, 0.16, {
        Size = UDim2.new(0, open and inputWidth or 0, 1, 0)
    })

    if not open then
        bar:ReleaseFocus()
    end
end

addDrag(main, toggle, function()
    setDockOpen(not dockOpen)
end)

addDrag(menu, title)

local function runcommand(msg, frombar)
    msg = msg:lower():match("^%s*(.-)%s*$")
    if not msg or msg == "" then return end
    
    local pfx = msg:sub(1, 1)
    if not frombar and not (
        pfx == ":" or pfx == ";" or pfx == "!" or
        pfx == "?" or pfx == "/" or pfx == "."
    ) then
        return
    end
 
    if pfx == ":" or pfx == ";" or pfx == "!" or
       pfx == "?" or pfx == "/" or pfx == "." then
        msg = msg:sub(2):match("^%s*(.-)%s*$")
    end

    local cmd, arg = msg:match("^(%S+)%s*(.-)$")
    if not cmd then
        return
    end
    cmd = cmd:lower()
    arg = arg or ""
    
    local valid = true

    if cmd == "cmds" then
        openMenu()
        showStatus("Opened command menu.", "success")
    elseif cmd == "noclip" then
        task.spawn(noclip)
    elseif cmd == "unnoclip" or cmd == "clip" then
        unnoclip()
    elseif cmd == "infstamina" or cmd == "infstam" then
        task.spawn(infstam)
    elseif cmd == "criminal" or cmd == "crim" then
        crim()
    elseif cmd == "autorespawn" or cmd == "autore" then
        task.spawn(autore)
    elseif cmd == "unautore" then
        autorebool = false
    elseif cmd == "ak47" then
        task.spawn(ak47)
    elseif cmd == "remington" or cmd == "rem" then
        task.spawn(shotgun)
    elseif cmd == "autoguns" then
        task.spawn(autog)
    elseif cmd == "unautoguns" then
        autogbool = false
    elseif cmd == "hammer" then
        task.spawn(hammer)
    elseif cmd == "knife" then
        task.spawn(knife)
    elseif cmd == "bomb" then
        task.spawn(getb)
    elseif cmd == "fal" then
        task.spawn(getf)
    elseif cmd == "base" then
        base()
    elseif cmd == "yard" then
        yard()
    elseif cmd == "prison" then
        prison()
    elseif cmd == "caf" or cmd == "cafeteria" then
        cafeteria()
    elseif cmd == "tower" then
        tower()
    elseif cmd == "armory" then
        armory()
    elseif cmd == "removedoors" or cmd == "rdoors" then
        rdoors()
    elseif cmd == "infjump" then
        infjump()
    elseif cmd == "uninfjump" then
        infjumpbool = false
        if infjumpconn then infjumpconn:Disconnect() end
    elseif cmd == "ignorecd" then
        ignore = true
    elseif cmd == "unignorecd" then
        ignore = false
    elseif cmd == "car" then
        task.spawn(car)
    elseif cmd == "carwalk" then
        task.spawn(carwalk)
    elseif cmd == "wallbang" then
        wallbang()
    elseif cmd == "unwallbang" then
        unwallbang()
    elseif cmd == "antishield" then
        ashield()
    elseif cmd == "unantishield" then
        stopshield()
    elseif cmd == "view" and arg ~= "" then
        view(arg)
    elseif cmd == "unview" then
        unview()
    elseif cmd == "goto" or cmd == "to" then
        if arg ~= "" then
            goto(arg)
        end
    elseif cmd == "admin" and arg ~= "" then
        local plr, err = findpl(arg)
        if not plr then
            notify("Admin", err, 5)
            return
        end

        admins[plr.UserId] = true
        notify("Admin", plr.Name .. " is now an admin", 5)
        textcs:SendAsync(plr.Name .. ' have been ranked admin, type ;cmds to get started')
        
        for _, plr in ipairs(players:GetPlayers()) do
            watchadmin(plr)
        end
        
        players.PlayerAdded:Connect(watchadmin)
    elseif cmd == "boost" then
        boosting = true
        task.spawn(function()
            while boosting do
                local hm = gethm()
                if hm then
                    hm.WalkSpeed = 30
                    hm.JumpHeight = 30
                end
                task.wait()
            end
        end)
    elseif cmd == "unboost" then
        boosting = false
        local hm = gethm()
        if hm then
            hm.WalkSpeed = 16
            hm.JumpHeight = 5.5
        end
    elseif cmd == "esp" then
        espstart()
    elseif cmd == "unesp" then
        espstop()
    elseif cmd == "silentaim" then
        silent()
    elseif cmd == "antitase" then
        antits()
    elseif cmd == "unantitase" then
        if antitasebool then
            antits()
        end
    elseif cmd == "unsilentaim" then
        silentAimEnabled = false
    elseif cmd == "arrest" and arg ~= "" then
        task.spawn(arrest, arg)
    elseif cmd == "kill" and arg ~= "" then
        task.spawn(kill, arg)
    elseif cmd == "bring" and arg ~= "" then
        task.spawn(bring, arg)
    elseif cmd == "loopkill" and arg ~= "" then
        loopkill = true
        task.spawn(loopk, arg)
    elseif cmd == "unloopkill" then
        loopkill = false
    elseif cmd == "killaura" or cmd == "kaura" then
        task.spawn(kaura)
    elseif cmd == "unkillaura" or cmd == "unkaura" then
        unkaura()
    elseif cmd == "antiarrest" then
        task.spawn(antirr)
    elseif cmd == "unantiarrest" then
        stopantirr()
    elseif cmd == "kick" and arg ~= "" then
        task.spawn(kick, arg)
    elseif cmd == "kick2" and arg ~= "" then
        repeat
            if stopkick then
                stopkick = false
                break
            end
            task.spawn(kick2, arg)
            task.wait(1)
        until not findpl(arg)
    elseif cmd == 'stopkick' then
        stopkick = true
    elseif (cmd == "carexplode" or cmd == "cexplode") and arg ~= "" then
        task.spawn(explode, arg)
    elseif cmd == "walkspeed" or cmd == "speed" then
        local n = tonumber(arg)
        if n then
            gethm().WalkSpeed = n
        end
    elseif cmd == "jumpheight" or cmd == "jumph" then
        local n = tonumber(arg)
        if n then
            gethm().JumpHeight = n
        end
    elseif cmd == "fov" then
        local n = tonumber(arg)
        if n then
            workspace.CurrentCamera.FieldOfView = n
        end
    elseif cmd == "antikick" then
        task.spawn(antikick)
    elseif cmd == "autoreload" then
        task.spawn(autoreload)
    elseif cmd == "unautoreload" then
        unautoreload()
    elseif cmd == "hotswap" or cmd == "autoswap" then
        hotswapbool = true
        notify("HotSwap", "Enabled", 3)
    elseif cmd == "unhotswap" or cmd == "unautoswap" then
        hotswapbool = false
        notify("HotSwap", "Disabled", 3)
    elseif cmd == "invisible" then
        task.spawn(invisible)
    elseif cmd == "uninvisible" then
        uninvisible()
    elseif cmd == "firerate" then
        if arg ~= "" then
            setFireRate(arg)
        else
            notify("FireRate", "Usage: ;firerate <number> (100 = normal)", 5)
        end
    elseif cmd == "unfirerate" or cmd == "resetfirerate" then
        resetFireRate()
    elseif cmd == "nospread" then
        nospreadbool = true
        applyAllGunMods()
        startGunModLoop()
        notify("NoSpread", "Enabled", 3)
    elseif cmd == "unnospread" then
        nospreadbool = false
        applyAllGunMods()
        notify("NoSpread", "Disabled", 3)
    elseif cmd == "automatic" or cmd == "fullauto" then
        automaticbool = true
        applyAllGunMods()
        startGunModLoop()
        notify("Automatic", "Enabled", 3)
    elseif cmd == "unautomatic" then
        automaticbool = false
        applyAllGunMods()
        notify("Automatic", "Disabled", 3)
    else
        valid = false
    end
    
    if not valid then
        notify("Error", 'Invalid command: "' .. cmd .. '"', 4)
        valid = true
    end
end

localp.Chatted:Connect(function(msg)
    runcommand(msg, false)
end)

bar.FocusLost:Connect(function(enterPressed)
    if not enterPressed then return end
    local msg = bar.Text
    bar.Text = ""
    runcommand(msg, true)
end)

local function updateLayout()
    if not cam then return end
    local viewport = cam.ViewportSize
    local smallScreen = viewport.X < 600

    local dockWidth = math.max(160, math.min(440, viewport.X - 24))
    main.Size = UDim2.fromOffset(dockWidth, 54)

    local inputWidth = math.max(0, dockWidth - 62)
    barHolder.Size = UDim2.new(0, dockOpen and inputWidth or 0, 1, 0)

    local menuWidth = math.max(180, math.min(viewport.X - 24, 760))
    local menuHeight = math.max(220, math.min(viewport.Y - 40, 560))

    menu.Size = UDim2.fromOffset(menuWidth, menuHeight)
    menu.Position = UDim2.fromScale(0.5, 0.5)

    title.TextSize = smallScreen and 16 or 19
    subtitle.TextSize = smallScreen and 10 or 13
    count.TextSize = smallScreen and 11 or 13

    for _, item in ipairs(list:GetChildren()) do
        if item:IsA("TextButton") then
            item.Size = UDim2.new(1, 0, 0, smallScreen and 48 or 54)
            item.TextSize = smallScreen and 13 or 16
        end
    end

    toast.Position = UDim2.new(0.5, 0, 0, -9)
end

updateLayout()

workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
    cam = workspace.CurrentCamera
    updateLayout()
end)

task.spawn(function()
    local rotation = 35
    while gui.Parent do
        task.wait(0.05)
        rotation = (rotation + 0.2) % 360
        local gradient = menu:FindFirstChildOfClass("UIGradient")
        if gradient then
            gradient.Rotation = rotation
        end
    end
end)

task.spawn(function()
    task.wait(1)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "Info",
            Text  = "Say ;cmds or open up command bar (prefix . : ; ! ? /)",
            Duration = 10
        })
    end)
    antikick()
end)
