-- ============================================================
-- 0) PROTEÇÃO CONTRA INICIALIZAÇÃO DUPLICADA
-- ============================================================
local genv = (getgenv and getgenv()) or _G
if genv.Anonymus7_Cleanup then pcall(genv.Anonymus7_Cleanup) end
local Anonymus7_Conns = {}
local Anonymus7_Extra = {}

-- ============================================================
-- 1) WINDUI
-- ============================================================
local WindUI = loadstring(game:HttpGet(
"https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"
))()

local Window = WindUI:CreateWindow({
Title = "Anonymus7",
Author = "by: anonymus",
Icon = "rocket",
Background = "https://i.postimg.cc/jjhc7pNM/0dd3861a7a01d66b16f89fe5a6b8a0a4.jpg",
BackgroundImageTransparency = 0.4,
})

local function safeUI(label, fn)
local ok, err = pcall(fn)
if not ok then warn("[Anonymus] Falha ao criar " .. label .. ": " .. tostring(err)) end
return ok
end

-- ============================================================
-- 2) CONFIG
-- ============================================================
local Player     = game:GetService("Players").LocalPlayer
local RunService = game:GetService("RunService")
local Workspace  = game:GetService("Workspace")
local UIS        = game:GetService("UserInputService")

local DETECT_INTERVAL   = 0.1
local RADIUS            = 20
local HEIGHT_ABOVE_HEAD = 3

local THROW_SPEED    = 297.6 
local THROW_KMH      = 300
local THROW_COOLDOWN = 5
local THROW_DEBOUNCE = 0.5

local enabled = false
local currentVehicle, currentData = nil, nil
local lastDetect = 0
local lastThrow  = 0
local thrownCooldown = {}

local function claimSimulation()
    pcall(function() if setsimulationradius then setsimulationradius(math.huge, math.huge) end end)
    pcall(function() if sethiddenproperty then sethiddenproperty(Player, "SimulationRadius", math.huge) end end)
    pcall(function() if sethiddenproperty then sethiddenproperty(Player, "MaximumSimulationRadius", math.huge) end end)
end-- ============================================================
-- 3) DETECÇÃO E TELEKINESIS
-- ============================================================
local function isVehicle(model)
    if not model or not model:IsA("Model") then return false end
    return model:FindFirstChildWhichIsA("VehicleSeat", true) ~= nil
end

local function getVehicleRoot(model)
    if model.PrimaryPart and model.PrimaryPart:IsA("BasePart") then
        return model.PrimaryPart
    end
    local chassis = model:FindFirstChild("Chassis", true)
    if chassis and chassis:IsA("BasePart") then return chassis end
    return model:FindFirstChildWhichIsA("BasePart")
end

local function findVehicleFromPart(part)
    local cur = part
    while cur and cur ~= Workspace do
        if cur:IsA("Model") and isVehicle(cur) then return cur end
        cur = cur.Parent
    end
end

local function detectNearest(head)
    local nearest, nearestDist = nil, math.huge
    local seen = {}
    local now = os.clock()
    local ok, parts = pcall(function()
        return Workspace:GetPartBoundsInRadius(head.Position, RADIUS)
    end)
    if not ok or not parts then return nil end

    for _, part in ipairs(parts) do  
        if part:IsA("BasePart") then  
            local v = findVehicleFromPart(part)  
            if v and not seen[v] then  
                seen[v] = true  
                local cd = thrownCooldown[v]  
                if not cd or now >= cd then  
                    local root = getVehicleRoot(v)  
                    if root and not root.Anchored then  
                        local d = (root.Position - head.Position).Magnitude  
                        if d < nearestDist then  
                            nearest, nearestDist = v, d  
                        end  
                    end  
                end  
            end  
        end  
    end  
    return nearest
end

local function attach(vehicle)
    local primary = getVehicleRoot(vehicle)
    if not primary or primary.Anchored then return nil end

    claimSimulation()

    for _, name in ipairs({"TK_Att", "TK_AP", "TK_AO"}) do  
        local old = primary:FindFirstChild(name)  
        if old then old:Destroy() end  
    end  

    local att = Instance.new("Attachment")  
    att.Name = "TK_Att"  
    att.Parent = primary  

    local ap = Instance.new("AlignPosition")  
    ap.Name = "TK_AP"  
    ap.Attachment0 = att  
    ap.Mode = Enum.PositionAlignmentMode.OneAttachment  
    ap.Position = primary.Position  
    ap.MaxForce = math.huge  
    ap.RigidityEnabled = true  
    ap.Parent = primary  

    local ao = Instance.new("AlignOrientation")  
    ao.Name = "TK_AO"  
    ao.Attachment0 = att  
    ao.Mode = Enum.OrientationAlignmentMode.OneAttachment  
    ao.CFrame = primary.CFrame  
    ao.MaxTorque = math.huge  
    ao.RigidityEnabled = true  
    ao.Parent = primary  

    local savedCollides = {}
    for _, part in ipairs(vehicle:GetDescendants()) do
        if part:IsA("BasePart") then
            savedCollides[part] = part.CanCollide
            part.CanCollide = false
        end
    end

    return { att = att, ap = ap, ao = ao, primary = primary, collides = savedCollides }
end

local function detach(data)
    if not data then return end
    pcall(function() data.ap:Destroy() end)
    pcall(function() data.ao:Destroy() end)
    pcall(function() data.att:Destroy() end)
    
    if data.collides then
        for part, was in pairs(data.collides) do
            if part and part.Parent then
                pcall(function() part.CanCollide = was end)
            end
        end
    end
end

local function clearCurrent()
    detach(currentData)
    currentVehicle, currentData = nil, nil
end-- ============================================================
-- 4) LOOP PRINCIPAL E ARREMESSO
-- ============================================================
table.insert(Anonymus7_Conns, RunService.Heartbeat:Connect(function()
    if not enabled then return end
    local char = Player.Character  
    if not char then clearCurrent() return end  

    local humanoid = char:FindFirstChildOfClass("Humanoid")  
    local head     = char:FindFirstChild("Head")  
    if not humanoid or not head then return end  

    if currentVehicle and humanoid.Sit then  
        local seatPart = humanoid.SeatPart  
        if seatPart and seatPart:IsDescendantOf(currentVehicle) then  
            humanoid.Jump = true  
            humanoid.Sit  = false  
        end  
    end  

    if currentData and currentData.primary and currentData.primary.Parent then  
        if currentData.primary.Anchored then  
            clearCurrent()  
            return  
        end  

        local target = head.Position + Vector3.new(0, head.Size.Y / 2 + HEIGHT_ABOVE_HEAD, 0)  
        currentData.ap.Position = target  

        pcall(function()  
            currentData.primary.AssemblyLinearVelocity  = Vector3.zero  
            currentData.primary.AssemblyAngularVelocity = Vector3.zero  
        end)  

        local hrp = char:FindFirstChild("HumanoidRootPart")  
        if hrp then  
            currentData.ao.CFrame = CFrame.new(target) * hrp.CFrame.Rotation  
        end  
        return  
    end  

    clearCurrent()  

    local now = os.clock()  
    if now - lastDetect < DETECT_INTERVAL then return end  
    lastDetect = now  

    local v = detectNearest(head)  
    if v then  
        local data = attach(v)  
        if data then  
            currentVehicle, currentData = v, data  
        end  
    end
end))

local function throwVehicle()
    if os.clock() - lastThrow < THROW_DEBOUNCE then return end
    lastThrow = os.clock()

    if not currentData or not currentData.primary or not currentData.primary.Parent then  
        pcall(function() WindUI:Notify({Title = "Nenhum veículo", Content = "Chegue perto de um carro primeiro.", Duration = 3}) end)  
        return  
    end  

    local vehicle = currentVehicle  
    local primary = currentData.primary  

    if vehicle then thrownCooldown[vehicle] = os.clock() + THROW_COOLDOWN end  

    detach(currentData)  
    currentVehicle, currentData = nil, nil  
    
    claimSimulation()

    local cam  = Workspace.CurrentCamera  
    local look = (cam and cam.CFrame.LookVector) or Vector3.new(0, 0, -1)  
    local velocity = (look + Vector3.new(0, 0.15, 0)).Unit * THROW_SPEED  

    pcall(function()  
        primary.AssemblyLinearVelocity  = Vector3.zero  
        primary.AssemblyAngularVelocity = Vector3.zero  
    end)  

    local bv = Instance.new("BodyVelocity")  
    bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)  
    bv.Velocity = velocity  
    bv.P = 10000  
    bv.Parent = primary  

    local bav = Instance.new("BodyAngularVelocity")  
    bav.MaxTorque = Vector3.new(1e9, 1e9, 1e9)  
    bav.AngularVelocity = Vector3.new(math.random(-25, 25), math.random(-25, 25), math.random(-25, 25))  
    bav.Parent = primary  

    task.defer(function() pcall(function() primary.AssemblyLinearVelocity = velocity end) end)  
    task.delay(1.5, function()  
        pcall(function() bv:Destroy() end)  
        pcall(function() bav:Destroy() end)  
    end)  

    pcall(function() WindUI:Notify({Title = "Arremessado!", Content = string.format("%d km/h", THROW_KMH), Duration = 2}) end)
end-- ============================================================
-- 5) SPAWN DE MOTO E ENTRAR NO VEÍCULO
-- ============================================================
local function spawnMotorcycle()
    local char = Player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local model = Instance.new("Model")
    model.Name = "Anonymus_Moto"

    local chassis = Instance.new("Part")
    chassis.Name = "Chassis"
    chassis.Size = Vector3.new(1.2, 1, 5)
    local baseCF = CFrame.new(hrp.Position + hrp.CFrame.LookVector * 8 + Vector3.new(0, 2, 0)) * CFrame.Angles(0, math.rad(hrp.Orientation.Y), 0)
    chassis.CFrame = baseCF
    chassis.BrickColor = BrickColor.new("Really red")
    chassis.Material = Enum.Material.Metal
    chassis.Parent = model
    model.PrimaryPart = chassis

    local seat = Instance.new("VehicleSeat")
    seat.Name = "DriveSeat"
    seat.Size = Vector3.new(1, 0.4, 2)
    seat.CFrame = baseCF * CFrame.new(0, 0.7, 0.5)
    seat.BrickColor = BrickColor.new("Really black")
    seat.Parent = model
    
    local weldSeat = Instance.new("WeldConstraint")
    weldSeat.Part0 = chassis
    weldSeat.Part1 = seat
    weldSeat.Parent = chassis

    local function createWheel(offset)
        local wheel = Instance.new("Part")
        wheel.Shape = Enum.PartType.Cylinder
        wheel.Size = Vector3.new(0.6, 2.4, 2.4)
        wheel.CFrame = baseCF * CFrame.new(offset)
        wheel.BrickColor = BrickColor.new("Really black")
        wheel.Parent = model

        local att0 = Instance.new("Attachment", wheel)
        local att1 = Instance.new("Attachment", chassis)
        att1.Position = offset

        local hinge = Instance.new("HingeConstraint")
        hinge.Attachment0 = att0
        hinge.Attachment1 = att1
        hinge.MotorMaxTorque = 1e6
        hinge.Parent = chassis
    end

    createWheel(Vector3.new(0, -0.5, -1.8))
    createWheel(Vector3.new(0, -0.5, 1.8))

    model.Parent = Workspace
    WindUI:Notify({Title = "Moto Spawnada", Content = "Aperte E para pilotar.", Duration = 4})
end

local function forceEnterNearestVehicle()
    local char = Player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end

    local nearestSeat = nil
    local bestDist = math.huge

    -- FIX 1: Ignora bancos ocupados (Occupant ~= nil)
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("VehicleSeat") and obj.Occupant == nil then
            local dist = (obj.Position - hrp.Position).Magnitude
            if dist < bestDist then
                bestDist = dist
                nearestSeat = obj
            end
        end
    end

    if nearestSeat then
        local vehicle = nearestSeat:FindFirstAncestorOfClass("Model") or nearestSeat.Parent

        for _, part in ipairs(vehicle:GetDescendants()) do
            -- Habilita bancos desabilitados
            if part:IsA("VehicleSeat") then
                part.Disabled = false
            end

            -- Desbloqueia via BoolValue / StringValue
            if part:IsA("BoolValue") and (part.Name:lower():find("lock") or part.Name:lower():find("trancado")) then
                part.Value = false
            end
            if part:IsA("StringValue") and part.Name:lower():find("owner") then
                part.Value = Player.Name
            end

            -- FIX 2: Desbloqueia via Attributes (jogos modernos)
            pcall(function()
                part:SetAttribute("Locked",   false)
                part:SetAttribute("Trancado",  false)
                part:SetAttribute("Owner",     Player.Name)
                part:SetAttribute("lock",      false)
            end)

            -- FIX 3: Só desancora BaseParts, e força network ownership
            if part:IsA("BasePart") then
                pcall(function()
                    part.Anchored = false
                    part:SetNetworkOwner(Player)
                end)
            end
        end

        -- FIX 4: Teleporte seguro — usa CFrame lateral ao banco, não em cima
        pcall(function()
            -- Posiciona o jogador ao lado do banco para evitar colisão com o teto
            local offset = nearestSeat.CFrame * CFrame.new(0, 1.5, 2)
            hrp.CFrame = offset
            task.wait(0.08)
            nearestSeat:Sit(hum)
        end)

        WindUI:Notify({Title = "Entrou!", Content = "Veículo destrancado e ocupado.", Duration = 3})
    else
        WindUI:Notify({Title = "Erro", Content = "Nenhum veículo vazio encontrado.", Duration = 3})
    end
end-- ============================================================
-- 6) MÓDULO ESP (PARTE 1/3)
-- ============================================================
local function notify(title, content, dur)
    pcall(function() WindUI:Notify({ Title = title, Content = content, Duration = dur or 3 }) end)
end

local function guiParent()
    local ok, p = pcall(function() return (gethui and gethui()) or game:GetService("CoreGui") end)
    if ok and p then return p end
    return Player:WaitForChild("PlayerGui")
end

local ESP = {}
do
    local Players = game:GetService("Players")
    local hasDrawing = (Drawing ~= nil) and (type(Drawing) == "table" or type(Drawing) == "userdata") and Drawing.new ~= nil

    local S = {
        Box = false, Corner = false, Filled = false, Skeleton = false, Tracer = false,
        Name = false, Distance = false, Health = false, HealthBar = false, Head = false,
        Highlight = false, Vehicle = false, TeamCheck = false, VisCheck = false,
        Color = Color3.fromRGB(255, 0, 0), VehicleColor = Color3.fromRGB(0, 170, 255),
        Thickness = 1, FillOpacity = 0.25, MaxDistance = 1000, TextSize = 14, Rate = 60, TracerOrigin = "Baixo",
    }
    local DEFAULTS = {}
    for k, v in pairs(S) do DEFAULTS[k] = v end
    ESP.S, ESP.hasDrawing = S, hasDrawing

    local ACTIVE_KEYS = { "Box", "Corner", "Filled", "Skeleton", "Tracer", "Name", "Distance", "Health", "HealthBar", "Head", "Highlight", "Vehicle" }
    local function anyActive()
        for _, k in ipairs(ACTIVE_KEYS) do if S[k] then return true end end
        return false
    end
    local function col() return _G.ESP_Color or S.Color end

    local pool, vpool, seats, vconns = {}, {}, {}, {}
    local container
    local function getContainer()
        if not container or not container.Parent then
            container = Instance.new("Folder")
            container.Name = "A7_ESP"
            container.Parent = guiParent()
        end
        return container
    end

    local function mk(t, props)
        local ok, o = pcall(function()
            local x = Drawing.new(t)
            for k, v in pairs(props) do x[k] = v end
            x.Visible = false
            return x
        end)
        return ok and o or nil
    end

    local KEYS = { "box", "fill", "tracer", "name", "dist", "hpText", "hpBg", "hpFill", "head" }
    local function newEntry()
        local e = { corner = {}, skel = {} }
        if not hasDrawing then return e end
        e.box = mk("Square", { Filled = false })
        e.fill = mk("Square", { Filled = true })
        for i = 1, 8 do e.corner[i] = mk("Line", {}) end
        for i = 1, 14 do e.skel[i] = mk("Line", {}) end
        e.tracer = mk("Line", {})
        e.name = mk("Text", { Center = true, Outline = true })
        e.dist = mk("Text", { Center = true, Outline = true })
        e.hpText = mk("Text", { Center = true, Outline = true })
        e.hpBg = mk("Line", { Thickness = 4, Color = Color3.new(0, 0, 0) })
        e.hpFill = mk("Line", { Thickness = 2 })
        e.head = mk("Circle", { Filled = false, NumSides = 24 })
        return e
    end

    local function hideDraw(e)
        for _, k in ipairs(KEYS) do if e[k] then e[k].Visible = false end end
        for i = 1, 8 do if e.corner[i] then e.corner[i].Visible = false end end
        for i = 1, 14 do if e.skel[i] then e.skel[i].Visible = false end end
    end-- ============================================================
-- 7) MÓDULO ESP (PARTE 2/3)
-- ============================================================
    local function setHL(e, char, on, c)
        if on then
            if not e.hl or not e.hl.Parent then
                local h = Instance.new("Highlight")
                h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                h.Parent = getContainer()
                e.hl = h
            end
            e.hl.Adornee = char
            e.hl.FillColor, e.hl.OutlineColor = c, c
            e.hl.FillTransparency = 1 - S.FillOpacity
            e.hl.Enabled = true
        elseif e.hl then
            e.hl.Enabled = false
            e.hl.Adornee = nil
        end
    end
    local function hideEntry(e) hideDraw(e) setHL(e, nil, false) end
    local function destroyEntry(e)
        for _, k in ipairs(KEYS) do if e[k] then pcall(function() e[k]:Remove() end) end end
        for i = 1, 8 do if e.corner[i] then pcall(function() e.corner[i]:Remove() end) end end
        for i = 1, 14 do if e.skel[i] then pcall(function() e.skel[i]:Remove() end) end end
        if e.hl then pcall(function() e.hl:Destroy() end) end
    end

    local function setLine(l, a, b, c, th, v)
        if not l then return end
        l.Visible = v
        if v then l.From, l.To, l.Color, l.Thickness = a, b, c, th end
    end
    local function setText(t, str, pos, c, v)
        if not t then return end
        t.Visible = v
        if v then t.Text, t.Position, t.Color, t.Size = str, pos, c, S.TextSize end
    end

    local R15 = {
        {"Head","UpperTorso"},{"UpperTorso","LowerTorso"},
        {"UpperTorso","LeftUpperArm"},{"LeftUpperArm","LeftLowerArm"},{"LeftLowerArm","LeftHand"},
        {"UpperTorso","RightUpperArm"},{"RightUpperArm","RightLowerArm"},{"RightLowerArm","RightHand"},
        {"LowerTorso","LeftUpperLeg"},{"LeftUpperLeg","LeftLowerLeg"},{"LeftLowerLeg","LeftFoot"},
        {"LowerTorso","RightUpperLeg"},{"RightUpperLeg","RightLowerLeg"},{"RightLowerLeg","RightFoot"},
    }
    local R6 = {
        {"Head","Torso"},{"Torso","Left Arm"},{"Torso","Right Arm"},{"Torso","Left Leg"},{"Torso","Right Leg"},
    }

    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Exclude
    local function isVisible(cam, part, char)
        local filter = { char }
        if Player.Character then table.insert(filter, Player.Character) end
        rayParams.FilterDescendantsInstances = filter
        local o = cam.CFrame.Position
        return Workspace:Raycast(o, part.Position - o, rayParams) == nil
    end

    local function tracerOrigin(vp)
        if S.TracerOrigin == "Centro" then return Vector2.new(vp.X / 2, vp.Y / 2) end
        if S.TracerOrigin == "Topo" then return Vector2.new(vp.X / 2, 0) end
        return Vector2.new(vp.X / 2, vp.Y)
    end

    local function renderPlayer(plr, cam, vp, lpos)
        local e = pool[plr]
        if not e then e = newEntry() pool[plr] = e end
        local char = plr.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local head = char and char:FindFirstChild("Head")
        if not (hum and hrp and head) or hum.Health <= 0 then hideEntry(e) return end
        if S.TeamCheck and plr.Team ~= nil and plr.Team == Player.Team then hideEntry(e) return end
        local dist = (hrp.Position - lpos).Magnitude
        if dist > S.MaxDistance then hideEntry(e) return end
        if S.VisCheck and not isVisible(cam, head, char) then hideEntry(e) return end

        local c = col()
        setHL(e, char, S.Highlight, c)
        if not hasDrawing then return end

        local pos = cam:WorldToViewportPoint(hrp.Position)
        if pos.Z <= 0 then hideDraw(e) return end
        local top = cam:WorldToViewportPoint(hrp.Position + Vector3.new(0, 3, 0))
        local bot = cam:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3.5, 0))
        local h = math.abs(bot.Y - top.Y)
        local w = h / 1.8
        local x, y = pos.X - w / 2, top.Y
        local th = S.Thickness

        if e.box then
            e.box.Visible = S.Box
            if S.Box then e.box.Position, e.box.Size, e.box.Color, e.box.Thickness = Vector2.new(x, y), Vector2.new(w, h), c, th end
        end
        if e.fill then
            e.fill.Visible = S.Filled
            if S.Filled then e.fill.Position, e.fill.Size, e.fill.Color, e.fill.Transparency = Vector2.new(x, y), Vector2.new(w, h), c, S.FillOpacity end
        end
        local cs = S.Corner
        local l = math.max(4, w * 0.25)
        local cr = e.corner
        setLine(cr[1], Vector2.new(x, y), Vector2.new(x + l, y), c, th, cs)
        setLine(cr[2], Vector2.new(x, y), Vector2.new(x, y + l), c, th, cs)
        setLine(cr[3], Vector2.new(x + w, y), Vector2.new(x + w - l, y), c, th, cs)
        setLine(cr[4], Vector2.new(x + w, y), Vector2.new(x + w, y + l), c, th, cs)
        setLine(cr[5], Vector2.new(x, y + h), Vector2.new(x + l, y + h), c, th, cs)
        setLine(cr[6], Vector2.new(x, y + h), Vector2.new(x, y + h - l), c, th, cs)
        setLine(cr[7], Vector2.new(x + w, y + h), Vector2.new(x + w - l, y + h), c, th, cs)
        setLine(cr[8], Vector2.new(x + w, y + h), Vector2.new(x + w, y + h - l), c, th, cs)
        setLine(e.tracer, tracerOrigin(vp), Vector2.new(pos.X, y + h), c, th, S.Tracer)
        
        local list = (hum.RigType == Enum.HumanoidRigType.R15) and R15 or R6
        for i = 1, 14 do
            local drawn = false
            local pr = S.Skeleton and list[i]
            if pr then
                local a, b = char:FindFirstChild(pr[1]), char:FindFirstChild(pr[2])
                if a and b then
                    local pa, pb = cam:WorldToViewportPoint(a.Position), cam:WorldToViewportPoint(b.Position)
                    if pa.Z > 0 and pb.Z > 0 then
                        setLine(e.skel[i], Vector2.new(pa.X, pa.Y), Vector2.new(pb.X, pb.Y), c, th, true)
                        drawn = true
                    end
                end
            end
            if not drawn and e.skel[i] then e.skel[i].Visible = false end
        end
        
        setText(e.name, plr.Name, Vector2.new(pos.X, y - S.TextSize - 3), Color3.new(1, 1, 1), S.Name)
        setText(e.dist, string.format("%.0f studs", dist), Vector2.new(pos.X, y + h + 2), Color3.new(1, 1, 1), S.Distance)
        
        local ratio = math.clamp(hum.Health / math.max(hum.MaxHealth, 1), 0, 1)
        local hc = Color3.fromRGB(255, 0, 0):Lerp(Color3.fromRGB(0, 255, 0), ratio)
        setText(e.hpText, string.format("%.0f/%.0f", hum.Health, hum.MaxHealth), Vector2.new(x - 24, y + h / 2 - S.TextSize / 2), hc, S.Health)
        setLine(e.hpBg, Vector2.new(x - 5, y + h + 1), Vector2.new(x - 5, y - 1), Color3.new(0, 0, 0), 4, S.HealthBar)
        setLine(e.hpFill, Vector2.new(x - 5, y + h), Vector2.new(x - 5, y + h - h * ratio), hc, 2, S.HealthBar)
        
        if e.head then
            local hp = cam:WorldToViewportPoint(head.Position)
            e.head.Visible = S.Head and hp.Z > 0
            if e.head.Visible then e.head.Position, e.head.Radius, e.head.Color, e.head.Thickness = Vector2.new(hp.X, hp.Y), math.max(3, h / 9), c, th end
        end
    end-- ============================================================
-- 8) MÓDULO ESP (PARTE 3/3)
-- ============================================================
    local function startVehicles()
        if vconns[1] then return end
        task.spawn(function()
            local n = 0
            for _, o in ipairs(Workspace:GetDescendants()) do
                if not S.Vehicle then return end
                if o:IsA("VehicleSeat") then seats[o] = true end
                n += 1
                if n % 2000 == 0 then task.wait() end
            end
        end)
        vconns[1] = Workspace.DescendantAdded:Connect(function(o) if o:IsA("VehicleSeat") then seats[o] = true end end)
        vconns[2] = Workspace.DescendantRemoving:Connect(function(o) seats[o] = nil end)
    end
    local function hideVehicles(destroy)
        for m, t in pairs(vpool) do
            if destroy then pcall(function() t:Remove() end) vpool[m] = nil else t.Visible = false end
        end
    end
    local function stopVehicles()
        for i = 1, 2 do if vconns[i] then vconns[i]:Disconnect() vconns[i] = nil end end
        table.clear(seats)
        hideVehicles(true)
    end

    local seenModels = {}
    local function renderVehicles(cam, lpos)
        if not hasDrawing then return end
        table.clear(seenModels)
        for seat in pairs(seats) do
            if not seat.Parent then
                seats[seat] = nil
            else
                local m = seat:FindFirstAncestorOfClass("Model") or seat
                if not seenModels[m] then
                    seenModels[m] = true
                    local root = (m:IsA("Model") and m.PrimaryPart) or seat
                    local d = (root.Position - lpos).Magnitude
                    local t = vpool[m]
                    if not t then t = mk("Text", { Center = true, Outline = true }) vpool[m] = t end
                    local shown = false
                    if t and d <= S.MaxDistance then
                        local p = cam:WorldToViewportPoint(root.Position)
                        if p.Z > 0 then
                            local kmh = root.AssemblyLinearVelocity.Magnitude * 0.28 * 3.6
                            local occ = (seat.Occupant and " | Ocupado") or " | Livre"
                            setText(t, string.format("%s | %.0f studs | %.0f km/h%s", m.Name, d, kmh, occ),
                                Vector2.new(p.X, p.Y), S.VehicleColor, true)
                            shown = true
                        end
                    end
                    if t and not shown then t.Visible = false end
                end
            end
        end
        for m, t in pairs(vpool) do
            if not seenModels[m] then
                t.Visible = false
                if not m.Parent then pcall(function() t:Remove() end) vpool[m] = nil end
            end
        end
    end

    local function step()
        local cam = Workspace.CurrentCamera
        if not cam then return end
        local vp = cam.ViewportSize
        local lc = Player.Character
        local lh = lc and lc:FindFirstChild("HumanoidRootPart")
        local lpos = lh and lh.Position or cam.CFrame.Position
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= Player then
                local ok, err = pcall(renderPlayer, plr, cam, vp, lpos)
                if not ok and not ESP._warned then ESP._warned = true warn("[Anonymus] ESP: " .. tostring(err)) end
            end
        end
        if S.Vehicle then pcall(renderVehicles, cam, lpos) end
    end

    local loop, acc = nil, 0
    local function onFrame(dt)
        if S.Rate < 60 then
            acc += dt
            if acc < 1 / S.Rate then return end
            acc = 0
        end
        step()
    end

    local function hideAll()
        for _, e in pairs(pool) do hideEntry(e) end
        hideVehicles(false)
    end

    function ESP.refresh()
        if anyActive() then
            if not loop then loop = RunService.RenderStepped:Connect(onFrame) end
        else
            if loop then loop:Disconnect() loop = nil end
            hideAll()
        end
        if S.Vehicle then startVehicles() else stopVehicles() end
    end

    function ESP.Clear()
        for p, e in pairs(pool) do destroyEntry(e) pool[p] = nil end
        hideVehicles(true)
    end
    function ESP.Unload()
        for _, k in ipairs(ACTIVE_KEYS) do S[k] = false end
        ESP.refresh()
        ESP.Clear()
        pcall(function() if container then container:Destroy() container = nil end end)
    end
    function ESP.ResetDefaults()
        for k, v in pairs(DEFAULTS) do S[k] = v end
        ESP.refresh()
    end
    function ESP.DisableAll()
        for _, k in ipairs(ACTIVE_KEYS) do S[k] = false end
        ESP.refresh()
    end
    ESP.ACTIVE_KEYS = ACTIVE_KEYS

    table.insert(Anonymus7_Conns, Players.PlayerRemoving:Connect(function(plr)
        local e = pool[plr]
        if e then destroyEntry(e) pool[plr] = nil end
    end))
    table.insert(Anonymus7_Extra, function() ESP.Unload() end)
end

local function syncEl(el, value)
    if el and el.Set then pcall(el.Set, el, value) end
end

-- ============================================================
-- 9) CRIAÇÃO DAS ABAS
-- ============================================================

-- ABA 1: VEÍCULOS
safeUI("Veículos", function()
    local Tab = Window:Tab({ Title = "Veículos", Icon = "car" })
    Tab:Paragraph({ Title = "Aviso", Desc = "Irei atualizar o bypass, não vai demorar e já voltará!" })
end)

-- ABA 2: PLAYER
safeUI("Player", function()
    local Tab = Window:Tab({ Title = "Player", Icon = "user" })
    Tab:Section({ Title = "Teleporte" })
    Tab:Input({ Title = "Nome do Jogador", Desc = "Digite o nome para teleportar.", Placeholder = "Ex: Noob123", Callback = function(text)
        local q = string.lower(tostring(text or ""))
        if q == "" then return end
        local target
        for _, p in ipairs(game:GetService("Players"):GetPlayers()) do
            if p ~= Player and (string.lower(p.Name) == q or string.lower(p.DisplayName) == q) then target = p break end
        end
        if not target then
            for _, p in ipairs(game:GetService("Players"):GetPlayers()) do
                if p ~= Player and (string.find(string.lower(p.Name), q, 1, true) or string.find(string.lower(p.DisplayName), q, 1, true)) then target = p break end
            end
        end
        local tr = target and target.Character and target.Character:FindFirstChild("HumanoidRootPart")
        local mr = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
        if tr and mr then
            mr.CFrame = tr.CFrame * CFrame.new(0, 0, 3)
        else
            notify("Teleporte", "Jogador não encontrado.", 3)
        end
    end })
end)

-- ABA 3: ESP
safeUI("ESP", function()
    local S = ESP.S
    local Tab = Window:Tab({ Title = "ESP", Icon = "eye" })
    if not ESP.hasDrawing then notify("ESP", "API Drawing indisponível neste executor: só o Highlight ESP funcionará.", 6) end

    Tab:Section({ Title = "Cores" })
    Tab:Colorpicker({ Title = "Cor do ESP", Desc = "Muda a cor do destaque dos jogadores.", Value = _G.ESP_Color or S.Color, Callback = function(color) _G.ESP_Color = color S.Color = color end })

    local function tog(key, title, desc, icon)
        ESP.ui = ESP.ui or {}
        ESP.ui[key] = Tab:Toggle({ Title = title, Desc = desc, Icon = icon, Value = S[key], Callback = function(v) S[key] = v ESP.refresh() end })
    end
    local function sld(key, title, desc, min, max, step, onChange)
        ESP.uiS = ESP.uiS or {}
        ESP.uiS[key] = Tab:Slider({ Title = title, Desc = desc, Step = step, Value = { Min = min, Max = max, Default = S[key] }, Callback = function(v) S[key] = v if onChange then onChange() end end })
    end

    Tab:Section({ Title = "Caixas" })
    tog("Box", "Box ESP", "Caixa 2D ao redor do jogador.", "square")
    tog("Corner", "Corner Box ESP", "Somente os cantos da caixa.", "scan")
    tog("Filled", "Filled Box ESP", "Caixa preenchida (opacidade ajustável).", "square")
    Tab:Section({ Title = "Linhas" })
    tog("Skeleton", "Skeleton ESP", "Articulações R6/R15.", "bone")
    tog("Tracer", "Line ESP / Tracer", "Linha da tela até o alvo.", "minus")
    ESP.uiD = Tab:Dropdown({ Title = "Origem do Tracer", Desc = "Ponto de partida da linha.", Values = { "Baixo", "Centro", "Topo" }, Value = "Baixo", Callback = function(opt) if type(opt) == "table" then opt = opt.Title or opt[1] end S.TracerOrigin = opt or "Baixo" end })
    Tab:Section({ Title = "Informações" })
    tog("Name", "Name ESP", "Mostra o nome.", "type")
    tog("Distance", "Distance ESP", "Distância em studs.", "ruler")
    tog("Health", "Health ESP", "Vida em texto.", "heart")
    tog("HealthBar", "Health Bar", "Barra de vida (atualiza sozinha).", "heart-pulse")
    tog("Head", "Head ESP", "Círculo na cabeça.", "circle")
    Tab:Section({ Title = "Contorno" })
    tog("Highlight", "Highlight ESP", "Contorno e preenchimento (máx. ~31 simultâneos).", "sparkles")
    Tab:Section({ Title = "Veículos" })
    tog("Vehicle", "ESP de Veículos", "Nome, distância, velocidade e se está ocupado.", "car")
    Tab:Colorpicker({ Title = "Cor do ESP de veículos", Value = S.VehicleColor, Callback = function(c) S.VehicleColor = c end })
    Tab:Section({ Title = "Filtros" })
    tog("TeamCheck", "Team Check", "Oculta jogadores do seu time (se o jogo usar Teams).", "users")
    tog("VisCheck", "Visibility Check", "Só mostra alvos visíveis (raycast; mais pesado).", "eye")
    Tab:Section({ Title = "Aparência" })
    sld("Thickness", "Espessura das linhas", "1 a 5", 1, 5, 1)
    sld("FillOpacity", "Opacidade do preenchimento", "Filled Box e Highlight", 0, 1, 0.05)
    sld("TextSize", "Tamanho do texto", "10 a 24", 10, 24, 1)
    sld("MaxDistance", "Distância máxima (studs)", "100 a 5000", 100, 5000, 50)
end)-- ABA 4: EXPLOITS
safeUI("Exploits", function()
    local Tab = Window:Tab({ Title = "Exploits", Icon = "zap" })
    Tab:Section({ Title = "Movimento" })
    
    local normalSpeed = nil
    Tab:Slider({ Title = "WalkSpeed", Desc  = "Velocidade do personagem.", Icon  = "rabbit", Step  = 1, Value = { Min = 16, Max = 500, Default = 16 }, Callback = function(value) 
        normalSpeed = (value ~= 16) and value or nil
        local hum = Player.Character and Player.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = value end 
    end })
    table.insert(Anonymus7_Conns, RunService.Heartbeat:Connect(function()
        local hum = Player.Character and Player.Character:FindFirstChildOfClass("Humanoid")
        if normalSpeed and hum and hum.WalkSpeed ~= normalSpeed then hum.WalkSpeed = normalSpeed end
    end))

    local normalJump = nil
    Tab:Slider({ Title = "JumpPower", Desc  = "Força do pulo.", Icon  = "arrow-up", Step  = 1, Value = { Min = 50, Max = 500, Default = 50 }, Callback = function(value) 
        normalJump = (value ~= 50) and value or nil
        local hum = Player.Character and Player.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.UseJumpPower = true; hum.JumpPower = value end 
    end })
    table.insert(Anonymus7_Conns, RunService.Heartbeat:Connect(function()
        local hum = Player.Character and Player.Character:FindFirstChildOfClass("Humanoid")
        if normalJump and hum and (not hum.UseJumpPower or hum.JumpPower ~= normalJump) then hum.UseJumpPower = true hum.JumpPower = normalJump end
    end))

    Tab:Section({ Title = "Habilidades" })

    local infiniteJump = false  
    Tab:Toggle({ Title = "Infinite Jump", Desc  = "Pule no ar infinitamente.", Icon  = "arrow-up", Value = false, Callback = function(state) infiniteJump = state end })
    table.insert(Anonymus7_Conns, UIS.JumpRequest:Connect(function() 
        if infiniteJump then 
            local hum = Player.Character and Player.Character:FindFirstChildOfClass("Humanoid") 
            if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end 
        end 
    end))

    local flyGuiLoaded = false
    local function LoadFlyGui()
        if flyGuiLoaded then notify("Fly", "Fly já está ativo!", 3) return end
        local success, err = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt"))()
            flyGuiLoaded = true
            notify("Fly", "FlyGuiV3 carregado com sucesso!", 3)
        end)
        if not success then notify("Erro", "Não foi possível carregar o FlyGuiV3: " .. tostring(err), 5) end
    end
    local function UnloadFly()
        if not flyGuiLoaded then notify("Fly", "Fly não está ativo!", 3) return end
        pcall(function()
            for _, root in ipairs({ guiParent(), game:GetService("CoreGui"), Player:FindFirstChild("PlayerGui") }) do
                local flyGui = root and root:FindFirstChild("FlyGuiV3")
                if flyGui then flyGui:Destroy() end
            end
            if _G.Fly then _G.Fly = nil end
        end)
        flyGuiLoaded = false
        notify("Fly", "FlyGuiV3 removido!", 3)
    end

    Tab:Button({ Title = "Ativar Fly (WASD)", Desc = "Carrega o FlyGuiV3 com controle WASD.", Icon = "wind", Callback = function() LoadFlyGui() end })
    Tab:Button({ Title = "Desativar Fly", Desc = "Remove o FlyGuiV3.", Icon = "wind", Callback = function() UnloadFly() end })

    local noclipActive = false
    local noclipConn
    local noclipOrig = setmetatable({}, { __mode = "k" })
    Tab:Toggle({ Title = "Noclip", Desc = "Atravessa paredes e objetos.", Icon = "ghost", Value = false, Callback = function(state)
        noclipActive = state
        if state then
            if not noclipConn then
                noclipConn = RunService.Stepped:Connect(function()
                    local char = Player.Character
                    if char then
                        for _, part in ipairs(char:GetDescendants()) do
                            if part:IsA("BasePart") then if noclipOrig[part] == nil then noclipOrig[part] = part.CanCollide end part.CanCollide = false end
                        end
                    end
                end)
                table.insert(Anonymus7_Conns, noclipConn)
            end
        else
            if noclipConn then noclipConn:Disconnect() noclipConn = nil end
            local char = Player.Character
            if char then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then local was = noclipOrig[part] if was ~= nil then part.CanCollide = was noclipOrig[part] = nil end end
                end
            end
        end
    end })
    
    Tab:Section({ Title = "Scripts de Troll" })
    local scripts = {
        { name = "Comer player", r6 = "https://pastebin.com/raw/aPSHMV6K", r15 = "https://pastebin.com/raw/1ePMTt9n" },
        { name = "Sus", r6 = "https://pastebin.com/raw/zHbw7ND1", r15 = "https://pastebin.com/raw/7hvcjDnW" },
        { name = "Chupar buceta", r6 = "https://pastebin.com/raw/SymCfnAW", r15 = "https://pastebin.com/raw/p8yxRfr4" },
        { name = "Boquete", r6 = "https://pastebin.com/raw/FPu4e2Qh", r15 = "https://pastebin.com/raw/DyPP2tAF" },
        { name = "Punheta", r6 = "https://pastefy.app/wa3v2Vgm/raw", r15 = "https://pastefy.app/YZoglOyJ/raw" }
    }
    for _, s in ipairs(scripts) do
        Tab:Button({ Title = s.name, Desc = "Carrega o script (R6/R15 automaticamente).", Callback = function()
            local char = Player.Character
            if not char then notify("Erro", "Personagem não encontrado.", 3) return end
            local isR6 = char:FindFirstChild("Torso") ~= nil
            local url = isR6 and s.r6 or s.r15
            local ok, err = pcall(function() loadstring(game:HttpGet(url))() end)
            if not ok then notify("Erro", "Falha ao carregar script: " .. tostring(err), 5)
            else notify("Script", s.name .. " carregado!", 3) end
        end })
    end
end)

-- ABA 5: DESTRUIÇÃO
local liftToggle
safeUI("Destruição", function()
    local Tab = Window:Tab({ Title = "Destruição", Icon = "flame" })
    Tab:Section({ Title = "Funções" })
    Tab:Input({ Title = "Força do Arremesso (km/h)", Desc = "Mude a velocidade que o carro é lançado.", Placeholder = "300", Callback = function(text) local val = tonumber(text) if val and val > 0 then THROW_KMH = val THROW_SPEED = val / 3.6 / 0.28 end end })
    liftToggle = Tab:Toggle({ Title = "Levantar veículo mais próximo", Desc  = "Levanta o carro num raio de 20 studs.", Icon  = "hand", Value = false, Callback = function(state) enabled = state lastDetect = 0 if not state then clearCurrent() thrownCooldown = {} end end })
    Tab:Button({ Title = "Arremessar Veículo", Desc  = "Lança o carro na direção da câmera.", Icon = "send", Callback = function() throwVehicle() end })
    Tab:Divider()
    Tab:Section({ Title = "Trolls com Veículos" })
    Tab:Button({ Title = "Pilotar Veículo Mais Próximo", Desc = "Entra e desbloqueia o carro/moto mais próximo do mapa.", Icon = "car", Callback = function() forceEnterNearestVehicle() end })
end)

-- ============================================================
-- ATALHOS (PC): C abre/fecha o menu | Y levanta o carro / arremessa
-- ============================================================
safeUI("Atalhos", function()
    local menuOpen = true
    local ok = pcall(function() Window:SetToggleKey(Enum.KeyCode.C) end)

    table.insert(Anonymus7_Conns, UIS.InputBegan:Connect(function(input, gp)
        if gp or UIS:GetFocusedTextBox() then return end

        if input.KeyCode == Enum.KeyCode.C and not ok then
            menuOpen = not menuOpen
            pcall(function()
                if menuOpen then Window:Open() else Window:Close() end
            end)
        end

        if input.KeyCode == Enum.KeyCode.Y then
            if currentData then
                throwVehicle()
            elseif not enabled then
                enabled = true
                lastDetect = 0
                if liftToggle then pcall(function() liftToggle:Set(true) end) end
                pcall(function() WindUI:Notify({Title = "Levantar ativado", Content = "Chegue perto de um carro e aperte Y para arremessar.", Duration = 3}) end)
            end
        end
    end))
end)

-- ABA 6: GERAL
safeUI("Geral", function()
    local Tab = Window:Tab({ Title = "Geral", Icon = "settings" })
    Tab:Section({ Title = "ESP" })
    Tab:Button({ Title = "Desativar todos os ESPs", Icon = "eye-off", Callback = function() ESP.DisableAll() for _, k in ipairs(ESP.ACTIVE_KEYS) do syncEl(ESP.ui and ESP.ui[k], false) end notify("ESP", "Todos os ESPs desativados.") end })
    Tab:Button({ Title = "Restaurar padrões do ESP", Icon = "rotate-ccw", Callback = function() ESP.ResetDefaults() for k, el in pairs(ESP.ui or {}) do syncEl(el, ESP.S[k]) end for k, el in pairs(ESP.uiS or {}) do syncEl(el, ESP.S[k]) end syncEl(ESP.uiD, ESP.S.TracerOrigin) notify("ESP", "Padrões restaurados.") end })
    Tab:Section({ Title = "Módulos" })
    Tab:Button({ Title = "Descarregar ESP", Desc = "Remove desenhos e limpa o cache do ESP.", Icon = "power", Callback = function() ESP.Unload() for _, k in ipairs(ESP.ACTIVE_KEYS) do syncEl(ESP.ui and ESP.ui[k], false) end notify("Geral", "ESP descarregado.") end })
end)

-- ABA 7: CRÉDITOS
safeUI("Créditos", function()
    local t = Window:Tab({ Title = "Créditos", Icon = "info" })
    local autor  = "anonymus"
    local versao = "anonymus — 7 2026"
    local libs = {
        { "WindUI",           "Interface gráfica | carrega ao executar" },
        { "FlyGuiV3",         "Fly da aba Exploits | só carrega ao ativar" },
        { "Scripts de Troll", "Aba Exploits | autores: Anonymus" },
    }
    local temDrawing = (ESP ~= nil and ESP.hasDrawing == true)

    t:Section({ Title = "ANONYMUS 7 HUB" })
    t:Paragraph({ Title = "Desenvolvido por", Desc = autor })
    t:Paragraph({ Title = "Versão", Desc = versao })

    t:Section({ Title = "Bibliotecas e créditos" })
    for _, lib in ipairs(libs) do
        t:Paragraph({ Title = lib[1], Desc = lib[2] })
    end

    t:Paragraph({ Title = "Estado da interface", Desc = "Carregada | API Drawing: " .. (temDrawing and "detectada" or "não detectada") .. " | Serviços externos: não verificados" })

    local clip = (type(setclipboard) == "function" and setclipboard) or (type(toclipboard) == "function" and toclipboard) or nil
    if clip then
        local linhas = { "ANONYMUS 7 HUB", "Desenvolvido por: " .. autor, "Versão: " .. versao, "Bibliotecas e créditos:" }
        for _, lib in ipairs(libs) do linhas[#linhas + 1] = "- " .. lib[1] .. ": " .. lib[2] end
        local info = table.concat(linhas, "\n")
        t:Button({ Title = "Copiar informações", Desc = "Copia autoria, versão etc ", Callback = function()
            local ok = pcall(clip, info)
            notify("Créditos", ok and "Informações copiadas." or "Não foi possível copiar neste executor.", 3)
        end })
    end

    t:Paragraph({ Title = "Aviso", Desc = "Quem tentar vai ficar fudido!" })
end)

-- ============================================================
-- 10) LIMPEZA GERAL
-- ============================================================
genv.Anonymus7_Cleanup = function()
    pcall(clearCurrent)
    for _, c in ipairs(Anonymus7_Conns) do pcall(function() c:Disconnect() end) end
    for _, f in ipairs(Anonymus7_Extra) do pcall(f) end
    pcall(function() Window:Destroy() end)
    genv.Anonymus7_Cleanup = nil
end