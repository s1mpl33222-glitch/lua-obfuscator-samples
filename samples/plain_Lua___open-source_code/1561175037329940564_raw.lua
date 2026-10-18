local print = function() end
local warn  = function() end
do
    local HS = game:GetService("HttpService")
    local FILE = "TT3Hub.json"
    local data
    local function load()
        if data then return data end
        data = {}
        if readfile then
            pcall(function()
                local raw = readfile(FILE)
                local t = HS:JSONDecode(raw)
                if type(t) == "table" then data = t end
            end)
        end
        return data
    end
    _G.HubCfg = {
        get = function(section)
            local d = load()
            if type(d[section]) ~= "table" then d[section] = {} end
            return d[section]
        end,
        save = function()
            if not writefile then return end
            pcall(function() writefile(FILE, HS:JSONEncode(load())) end)
        end,
    }
end

-- Controle compartilhado dos paineis (funciona mesmo se os dois scripts carregarem em ordens diferentes).
do
    local panelCfg = _G.HubCfg.get("panels")
    _G.TT3PanelVisibility = _G.TT3PanelVisibility or {}
    for id, value in pairs(panelCfg) do
        if type(value) == "boolean" then _G.TT3PanelVisibility[id] = value end
    end
    _G.TT3PanelRegistry = _G.TT3PanelRegistry or {}
    _G.TT3RegisterPanel = function(id, gui)
        if not id or not gui then return end
        _G.TT3PanelRegistry[id] = gui
        local visible = _G.TT3PanelVisibility[id]
        if visible == nil then visible = true; _G.TT3PanelVisibility[id] = true end
        pcall(function() gui.Enabled = visible end)
    end
    _G.TT3SetPanelVisible = function(id, visible)
        visible = visible and true or false
        _G.TT3PanelVisibility[id] = visible
        panelCfg[id] = visible
        local gui = _G.TT3PanelRegistry[id]
        if gui then pcall(function() gui.Enabled = visible end) end
        pcall(_G.HubCfg.save)
        if _G.TT3RefreshPanelButtons then pcall(_G.TT3RefreshPanelButtons) end
    end
end

-- ============================================================
-- ETALEMENT DU DEMARRAGE (anti-freeze a l execution)
-- Les blocs ci-dessous s executent en direct, mais on decale chacun de
-- quelques frames (stagSpawn) pour qu ils ne saturent pas la meme frame au
-- chargement. Ce n est PAS le delai de 7s (retire): l etalement total fait
-- ~0.25s, imperceptible, mais supprime le pic/freeze de lancement.
-- ============================================================
local __stgN = 0
local function stagSpawn(fn)
    __stgN = __stgN + 1
    local n = __stgN
    task.spawn(function()
        -- differe extras de 6s: laisse le TP (invisible.txt) s initialiser en
        -- priorite au chargement -> jeu plus fluide, TP mieux optimise.
        task.wait(6)
        for _ = 1, n do task.wait() end
        -- attendre que LocalPlayer existe: les blocs partent tot (stagSpawn) et
        -- certains lisent Players.LocalPlayer directement -> nil si trop tot
        local Players = game:GetService("Players")
        while not Players.LocalPlayer do task.wait() end
        fn()
    end)
end

-- comme stagSpawn mais SANS le differe de 6s ni le stagger: pour les blocs qui
-- doivent etre actifs IMMEDIATEMENT (anti-ragdoll, FOV). Attend juste LocalPlayer.
local function nowSpawn(fn)
    task.spawn(function()
        local Players = game:GetService("Players")
        while not Players.LocalPlayer do task.wait() end
        fn()
    end)
end

-- ============================================================
-- OTIMIZER (extraido do BJK, sem loader, delay ou notificacao)
-- Inicia imediatamente e pode ser ligado/desligado em Configuracoes.
-- ============================================================
nowSpawn(function()
local okOPT, errOPT = pcall(function()
    if _G.TT3OptimizerLoaded then return end
    _G.TT3OptimizerLoaded = true

    local Players         = game:GetService("Players")
    local Lighting        = game:GetService("Lighting")
    local Workspace       = game:GetService("Workspace")
    local MaterialService = game:GetService("MaterialService")
    local Settings        = settings()

    local cfg = _G.HubCfg.get("optimizer")
    if type(cfg.enabled) == "boolean" then
        _G.TT3OptimizerEnabled = cfg.enabled
    elseif _G.TT3OptimizerEnabled == nil then
        _G.TT3OptimizerEnabled = false
    end

    local connections = {}
    local original = setmetatable({}, { __mode = "k" })
    local protectedBeamNames = {
        PlotBeam=true, BrainrotBeam=true, HighestValueBeam=true, BaseLineBeam=true,
        PlotBeamAttach_Player=true, PlotBeamAttach_Plot=true,
        BrainrotBeamAttach0=true, BrainrotBeamAttach1=true,
    }

    local function disconnectAll()
        for _, conn in ipairs(connections) do
            if typeof(conn) == "RBXScriptConnection" then conn:Disconnect() end
        end
        table.clear(connections)
    end

    local function isCharacterObject(obj)
        local current = obj
        while current and current ~= Workspace do
            if current:IsA("Model") and Players:GetPlayerFromCharacter(current) then return true end
            current = current.Parent
        end
        return false
    end

    local function optimizeLighting()
        pcall(function()
            Lighting.GlobalShadows = false
            Lighting.FogEnd = 9e9
            Lighting.FogStart = 99999
            Lighting.EnvironmentDiffuseScale = 0
            Lighting.EnvironmentSpecularScale = 0
            Lighting.ShadowSoftness = 0
        end)
        for _, obj in ipairs(Lighting:GetChildren()) do
            if obj:IsA("PostEffect") then
                if original[obj] == nil then original[obj] = { enabled = obj.Enabled } end
                pcall(function() obj.Enabled = false end)
            end
        end
    end

    local function optimizeTerrain()
        local terrain = Workspace:FindFirstChildOfClass("Terrain")
        if not terrain then return end
        pcall(function()
            terrain.Decoration = false
            terrain.WaterWaveSize = 0
            terrain.WaterWaveSpeed = 0
            terrain.WaterReflectance = 0
        end)
    end

    local function optimizeObject(obj)
        if not _G.TT3OptimizerEnabled or not obj or not obj.Parent then return end
        if isCharacterObject(obj) or protectedBeamNames[obj.Name] then return end
        if obj:IsA("Beam") and obj.Parent and obj.Parent.Name == "HumanoidRootPart" then return end
        if obj:IsA("Attachment") and obj.Parent and obj.Parent.Name == "HumanoidRootPart" then return end
        pcall(function()
            if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke")
                or obj:IsA("Fire") or obj:IsA("Sparkles") or obj:IsA("Beam")
                or obj:IsA("PointLight") or obj:IsA("SpotLight") or obj:IsA("SurfaceLight") then
                if original[obj] == nil then original[obj] = { enabled = obj.Enabled } end
                obj.Enabled = false
            elseif obj:IsA("BasePart") then
                if original[obj] == nil then
                    original[obj] = { castShadow = obj.CastShadow, material = obj.Material, reflectance = obj.Reflectance }
                end
                obj.CastShadow = false
                obj.Material = Enum.Material.Plastic
                obj.Reflectance = 0
            elseif obj:IsA("SpecialMesh") then
                obj.TextureId = ""
            end
        end)
    end

    local function applyFastFlags()
        local setFlag = setfflag or SetFastFlag or setfastflag or SetFFlag
        if not setFlag then return end
        local flags = {
            FFlagDebugDisableTelemetryEphemeralCounter="True",
            FFlagDebugDisableTelemetryEphemeralStat="True",
            FFlagDebugDisableTelemetryEventIngest="True",
            FFlagDisableTelemetryOnJoin="True",
            DFIntTaskSchedulerTargetFps="240",
            FFlagTaskSchedulerLimitTargetFpsToDevice="False",
            FIntRenderGrassDetailStrands="0",
            FIntRenderShadowIntensity="0",
            DFFlagTextureQualityOverrideEnabled="True",
            DFIntTextureQualityOverride="0",
            FFlagRemoveGlobalShadows="True",
            FFlagDebugDisableParticles="True",
            DFIntGrassMaxDistance="0",
            FFlagGrassRendering="False",
            FFlagWaterReflection="False",
            FFlagWaterRefraction="False",
            FFlagEnableTextureStreaming="True",
        }
        for name, value in pairs(flags) do pcall(function() setFlag(name, value) end) end
    end

    local function enableOptimizer()
        if #connections > 0 then return end
        task.spawn(applyFastFlags)
        pcall(function() if type(setfpscap) == "function" then setfpscap(240) end end)
        pcall(function()
            Settings.Rendering.QualityLevel = Enum.QualityLevel.Level01
            Settings.Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Level01
            Settings.Physics.AllowSleep = true
        end)
        optimizeLighting()
        optimizeTerrain()

        -- Primeira varredura imediata; cede uma frame entre lotes para nao congelar.
        task.spawn(function()
            local descendants = Workspace:GetDescendants()
            for i = 1, #descendants, 100 do
                if not _G.TT3OptimizerEnabled then return end
                for j = i, math.min(i + 99, #descendants) do optimizeObject(descendants[j]) end
                task.wait()
            end
        end)

        connections[#connections + 1] = Workspace.DescendantAdded:Connect(function(obj)
            task.defer(optimizeObject, obj)
        end)
        connections[#connections + 1] = Lighting.DescendantAdded:Connect(function(obj)
            if not _G.TT3OptimizerEnabled then return end
            if obj:IsA("PostEffect") then
                if original[obj] == nil then original[obj] = { enabled = obj.Enabled } end
                pcall(function() obj.Enabled = false end)
            end
        end)
    end

    local function disableOptimizer()
        disconnectAll()
        for obj, state in pairs(original) do
            pcall(function()
                if obj and obj.Parent then
                    if state.castShadow ~= nil then obj.CastShadow = state.castShadow end
                    if state.material ~= nil then obj.Material = state.material end
                    if state.reflectance ~= nil then obj.Reflectance = state.reflectance end
                    if state.enabled ~= nil then obj.Enabled = state.enabled end
                end
            end)
        end
        original = setmetatable({}, { __mode = "k" })
    end

    _G.TT3SetOptimizer = function(state)
        _G.TT3OptimizerEnabled = state and true or false
        cfg.enabled = _G.TT3OptimizerEnabled
        pcall(_G.HubCfg.save)
        if _G.TT3OptimizerEnabled then enableOptimizer() else disableOptimizer() end
        if _G.TT3RefreshOptimizerBtn then pcall(_G.TT3RefreshOptimizerBtn) end
    end
    _G.TT3ToggleOptimizer = function()
        _G.TT3SetOptimizer(not _G.TT3OptimizerEnabled)
    end

    if _G.TT3OptimizerEnabled then enableOptimizer() end
end)
if not okOPT then warn("[OTIMIZER] BLOC EN ERREUR: " .. tostring(errOPT)) end
end)

-- UI mobile compacta: reduz os paineis sem alterar a logica das funcoes.
local function fitMobilePanel(frame, scaleValue)
    local UIS = game:GetService("UserInputService")
    if not UIS.TouchEnabled or not frame then return end
    local scale = Instance.new("UIScale")
    scale.Name = "TT3MobileScale"
    scale.Scale = scaleValue or 0.78
    scale.Parent = frame
    task.defer(function()
        local cam = workspace.CurrentCamera
        if not cam or not frame.Parent then return end
        local view = cam.ViewportSize
        local size = frame.AbsoluteSize
        local x = math.clamp(frame.AbsolutePosition.X, 6, math.max(6, view.X - size.X - 6))
        local y = math.clamp(frame.AbsolutePosition.Y, 6, math.max(6, view.Y - size.Y - 6))
        frame.Position = UDim2.fromOffset(x, y)
    end)
end

-- ============================================================
-- INVISIBLE STEAL + WALKSPEED  (portage COMPLET de TT3)
-- Tout le code fonctionnel est repris: clone du rig, suppression du DoubleRig,
-- animation trickery, detection de lagback + ghosts + error orb, auto-recover,
-- auto-invis pendant le steal, death listener, walkspeed CFrame bypass.
-- Seule l UI a ete refaite en version minimale.
--
-- EXECUTION DIRECTE: ce bloc invisible steal demarre immediatement (nowSpawn:
-- PAS le differe de 6s de stagSpawn). WaitForChild gere l attente du
-- PlayerGui/Character sans bloquer le reste du script.
-- ============================================================
nowSpawn(function()
    local Players    = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local HS         = game:GetService("HttpService")
    local LP         = Players.LocalPlayer
    local PG         = LP:WaitForChild("PlayerGui")

    ------------------------------------------------------------------
    -- CONFIG PERSISTANTE
    ------------------------------------------------------------------
    -- section "invis" du fichier partage TT3Hub.json
    local cfg = _G.HubCfg.get("invis")
    local function saveCfg()
        cfg.angle  = _G.InvisStealAngle
        cfg.depth  = _G.SinkSliderValue
        cfg.ws     = _G.TT3WSValue
        cfg.wsOn   = _G.TT3WSEnabled
        cfg.aInv   = _G.AutoInvisDuringSteal
        cfg.aRec   = _G.AutoRecoverLagback
        cfg.panelX = _G.InvisPanelX
        cfg.panelY = _G.InvisPanelY
        _G.HubCfg.save()
    end

    if _G.InvisStealAngle     == nil then _G.InvisStealAngle     = 225   end  -- valeur TT3 (etait 180)
    if _G.SinkSliderValue     == nil then _G.SinkSliderValue     = 8     end  -- garde 8 = s enfonce + profond (mieux cache)
    if _G.TT3WSValue       == nil then _G.TT3WSValue       = 28    end
    if _G.TT3WSEnabled     == nil then _G.TT3WSEnabled     = true  end
    if _G.AutoInvisDuringSteal== nil then _G.AutoInvisDuringSteal= false end
    if _G.AutoRecoverLagback  == nil then _G.AutoRecoverLagback  = true  end
    do
        if tonumber(cfg.angle) then _G.InvisStealAngle = tonumber(cfg.angle) end
        if tonumber(cfg.depth) then _G.SinkSliderValue = tonumber(cfg.depth) end
        if tonumber(cfg.ws)    then _G.TT3WSValue   = tonumber(cfg.ws) end
        if type(cfg.wsOn) == "boolean" then _G.TT3WSEnabled      = cfg.wsOn end
        if type(cfg.aInv) == "boolean" then _G.AutoInvisDuringSteal = cfg.aInv end
        if type(cfg.aRec) == "boolean" then _G.AutoRecoverLagback   = cfg.aRec end
        if tonumber(cfg.panelX) then _G.InvisPanelX = tonumber(cfg.panelX) end
        if tonumber(cfg.panelY) then _G.InvisPanelY = tonumber(cfg.panelY) end
    end
    _G.invisibleStealEnabled = false

    ------------------------------------------------------------------
    -- ETAT
    ------------------------------------------------------------------
    local animPlaying      = false
    local tracks           = {}
    local folderConns      = {}
    local serverGhosts     = {}
    local ghostEnabled     = true
    local lagbackCallCount = 0
    local lagbackWindow    = 0
    local lastLagback      = 0
    local errorOrbActive   = false
    local errorOrb, errorOrbConn
    local oldRoot, cloneRoot, hip, conn
    local refreshUI

    ------------------------------------------------------------------
    -- GHOSTS DE LAGBACK
    -- Quand le serveur nous rembobine, l ancien root saute d un coup. On pose
    -- une bille rouge la ou le serveur nous a remis. 7 lagbacks en 1s = le
    -- serveur nous refuse en boucle -> error orb, on arrete de spammer.
    ------------------------------------------------------------------
    local function clearErrorOrb()
        if errorOrb and errorOrb.Parent then errorOrb:Destroy() end
        errorOrb = nil; errorOrbActive = false
        if errorOrbConn then errorOrbConn:Disconnect(); errorOrbConn = nil end
    end

    local function createErrorOrb()
        if errorOrbActive then return end
        errorOrbActive = true
        for _, g in pairs(serverGhosts) do if g and g.Parent then g:Destroy() end end
        serverGhosts = {}
    end

    local function clearAllGhosts()
        for _, g in pairs(serverGhosts) do
            pcall(function() if g and g.Parent then g:Destroy() end end)
        end
        serverGhosts = {}; clearErrorOrb()
        lagbackCallCount = 0; lastLagback = 0
        pcall(function()
            if workspace.CurrentCamera then
                for _, c in pairs(workspace.CurrentCamera:GetChildren()) do
                    if c.Name == "LagbackGhost" then c:Destroy() end
                end
            end
        end)
    end

    local function createServerGhost(pos)
        if not ghostEnabled or errorOrbActive then return end
        local now = tick()
        if now - lastLagback < 0.05 then return end
        lastLagback = now
        if now - lagbackWindow > 1 then lagbackCallCount = 0; lagbackWindow = now end
        lagbackCallCount = lagbackCallCount + 1
        if lagbackCallCount >= 7 then createErrorOrb(); return end
        for _, g in pairs(serverGhosts) do if g and g.Parent then g:Destroy() end end
        serverGhosts = {}
        local g = Instance.new("Part")
        g.Name = "LagbackGhost"; g.Shape = Enum.PartType.Ball
        g.Size = Vector3.new(3, 3, 3); g.Color = Color3.fromRGB(255, 0, 0)
        g.Material = Enum.Material.Glass; g.Transparency = 0.3
        g.CanCollide = false; g.Anchored = true; g.CastShadow = false
        g.Position = pos + Vector3.new(0, 5, 0)
        g.Parent = workspace.CurrentCamera
        serverGhosts[#serverGhosts + 1] = g
    end

    ------------------------------------------------------------------
    -- WALKSPEED (CFrame bypass -- repris EXACTEMENT de message.txt/TT3)
    -- message.txt ne coupe le boost QUE sur MoveDirection == 0. L ancienne
    -- version extras ajoutait "velocity > 60 -> return", ce qui coupait le
    -- boost en plein saut / descente / elan et donnait cette sensation de
    -- walkspeed qui rame. Supprime.
    -- On garde uniquement le garde _G.TT3StealHold: il n est vrai QUE
    -- pendant un TP scripte (invisible en jeu normal), et evite de relancer
    -- un lagback si tu tiens une touche pendant un steal-TP. Enleve cette
    -- ligne si tu veux la parite 100% message.txt.
    ------------------------------------------------------------------
    local WS = { enabled = false, conn = nil }
    local function setWalkSpeedEnabled(en)
        WS.enabled = en
        if WS.conn then WS.conn:Disconnect(); WS.conn = nil end
        if refreshUI then refreshUI() end
        if not en then return end
        WS.conn = RunService.Heartbeat:Connect(function(dt)
            if _G.FlingActive then return end   -- pause pendant un fling (sinon le CFrame ecrase la velocite)
            local c = LP.Character
            local hum = c and c:FindFirstChildOfClass("Humanoid")
            local root = c and c:FindFirstChild("HumanoidRootPart")
            if not hum or not root or hum.Health <= 0 then return end
            -- walkspeed = parite 100% TT3/message.txt: PAS de pause TT3StealHold
            -- (c est cette pause qui coupait la vitesse -> "la speed qui rame")
            local target = tonumber(_G.TT3WSValue) or 28
            if hum.MoveDirection.Magnitude > 0 and target > hum.WalkSpeed then
                root.CFrame = root.CFrame + (hum.MoveDirection * (target - hum.WalkSpeed) * dt)
            end
        end)
    end
    _G.setWalkSpeedEnabled = setWalkSpeedEnabled

    -- clamp 15..29 comme message.txt (au-dela le CFrame devient visible cote
    -- serveur et provoque des lagbacks)
    local function setWalkSpeedValue(v)
        v = math.clamp(math.floor((tonumber(v) or 28) + 0.5), 15, 29)
        _G.TT3WSValue = v
        return v
    end
    _G.setWalkSpeedValue = setWalkSpeedValue
    setWalkSpeedValue(_G.TT3WSValue)

    ------------------------------------------------------------------
    -- CLONE DU RIG
    ------------------------------------------------------------------
    local function removeFolders()
        local pf = workspace:FindFirstChild(LP.Name)
        if not pf then return end
        local dr = pf:FindFirstChild("DoubleRig")
        if dr then
            local rr = dr:FindFirstChild("HumanoidRootPart") or dr:FindFirstChildWhichIsA("BasePart")
            if rr and ghostEnabled then createServerGhost(rr.Position) end
            dr:Destroy()
        end
        local cs = pf:FindFirstChild("Constraints")
        if cs then cs:Destroy() end
        folderConns[#folderConns + 1] = pf.ChildAdded:Connect(function(child)
            if child.Name == "DoubleRig" then
                task.defer(function()
                    if not child or not child.Parent then return end
                    local rr = child:FindFirstChild("HumanoidRootPart") or child:FindFirstChildWhichIsA("BasePart")
                    if rr and ghostEnabled then createServerGhost(rr.Position) end
                    child:Destroy()
                end)
            elseif child.Name == "Constraints" then
                child:Destroy()
            end
        end)
    end



    if not _G._xenFixRig then
        local _rigBusy = false
        local _R = {
            {"Root","HumanoidRootPart","LowerTorso"},{"Waist","LowerTorso","UpperTorso"},
            {"Neck","UpperTorso","Head"},
            {"LeftShoulder","UpperTorso","LeftUpperArm"},{"LeftElbow","LeftUpperArm","LeftLowerArm"},
            {"LeftWrist","LeftLowerArm","LeftHand"},
            {"RightShoulder","UpperTorso","RightUpperArm"},{"RightElbow","RightUpperArm","RightLowerArm"},
            {"RightWrist","RightLowerArm","RightHand"},
            {"LeftHip","LowerTorso","LeftUpperLeg"},{"LeftKnee","LeftUpperLeg","LeftLowerLeg"},
            {"LeftAnkle","LeftLowerLeg","LeftFoot"},
            {"RightHip","LowerTorso","RightUpperLeg"},{"RightKnee","RightUpperLeg","RightLowerLeg"},
            {"RightAnkle","RightLowerLeg","RightFoot"},
        }
        local function _fix()
            local _ch = LP.Character
            if not _ch then return end
            local _h = _ch:FindFirstChildOfClass("Humanoid")
            if not _h or _h.RigType ~= Enum.HumanoidRigType.R15 or _h.Health <= 0 then return end
            for _, j in ipairs(_R) do
                local p, c = _ch:FindFirstChild(j[2]), _ch:FindFirstChild(j[3])
                if p and c then
                    local have = false
                    for _, d in ipairs(c:GetChildren()) do
                        if d:IsA("Motor6D") and d.Name == j[1] then have = true break end
                    end
                    if not have then
                        local a0 = p:FindFirstChild(j[1] .. "RigAttachment")
                        local a1 = c:FindFirstChild(j[1] .. "RigAttachment")
                        if a0 and a1 then
                            for _, d in ipairs(c:GetChildren()) do
                                if d:IsA("AnimationConstraint") and d.Name == j[1] then
                                    pcall(function() d.Enabled = false end)
                                end
                            end
                            pcall(function()
                                local m = Instance.new("Motor6D")
                                m.Name, m.Part0, m.Part1, m.C0, m.C1 = j[1], p, c, a0.CFrame, a1.CFrame
                                m.Parent = c
                            end)
                        end
                    end
                end
            end
        end
        _G._xenFixRig = function()
            if _rigBusy then return false end
            _rigBusy = true
            local ok = pcall(_fix)
            _rigBusy = false
            return ok
        end
    end

    local function invisClone()
        local c = LP.Character
        local hum = c and c:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then return false end
        hip = hum.HipHeight
        oldRoot = c:FindFirstChild("HumanoidRootPart")
        if not oldRoot or not oldRoot.Parent then return false end
        for _, x in pairs(oldRoot:GetChildren()) do
            if x:IsA("Attachment") and (x.Name:find("Beam") or x.Name:find("Attach")) then x:Destroy() end
        end
        for _, x in pairs(oldRoot:GetChildren()) do
            if x:IsA("Beam") then x:Destroy() end
        end
        local tmp = Instance.new("Model"); tmp.Parent = game
        c.Parent = tmp
        cloneRoot = oldRoot:Clone(); cloneRoot.Parent = c
        oldRoot.Parent = workspace.CurrentCamera
        cloneRoot.CFrame = oldRoot.CFrame; c.PrimaryPart = cloneRoot
        c.Parent = workspace
        for _, v in pairs(c:GetDescendants()) do
            if v:IsA("Weld") or v:IsA("Motor6D") then
                if v.Part0 == oldRoot then v.Part0 = cloneRoot end
                if v.Part1 == oldRoot then v.Part1 = cloneRoot end
            end
        end
        tmp:Destroy()
        task.defer(function() if _G._xenFixRig then _G._xenFixRig() end end)
        return true
    end

    local function invisRevert()
        local c = LP.Character
        local hum = c and c:FindFirstChildOfClass("Humanoid")
        if not oldRoot or not oldRoot:IsDescendantOf(workspace) or not hum or hum.Health <= 0 then return end
        local tmp = Instance.new("Model"); tmp.Parent = game
        c.Parent = tmp
        oldRoot.Parent = c; c.PrimaryPart = oldRoot
        c.Parent = workspace; oldRoot.CanCollide = true
        for _, v in pairs(c:GetDescendants()) do
            if v:IsA("Weld") or v:IsA("Motor6D") then
                if v.Part0 == cloneRoot then v.Part0 = oldRoot end
                if v.Part1 == cloneRoot then v.Part1 = oldRoot end
            end
        end
        tmp:Destroy()
        if cloneRoot then
            local p = cloneRoot.CFrame
            cloneRoot:Destroy(); cloneRoot = nil
            oldRoot.CFrame = p
        end
        oldRoot = nil
        if hip then hum.HipHeight = hip end
        task.defer(function() if _G._xenFixRig then _G._xenFixRig() end end)
        clearAllGhosts()
    end

    local function animationTrickery()
        local c = LP.Character
        local hum = c and c:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then return end
        local a = Instance.new("Animation")
        a.AnimationId = "http://www.roblox.com/asset/?id=18537363391"
        local animator = hum:FindFirstChildOfClass("Animator") or Instance.new("Animator", hum)
        local tr = animator:LoadAnimation(a)
        tr.Priority = Enum.AnimationPriority.Action4
        tr:Play(0, 1, 0); a:Destroy()
        tracks[#tracks + 1] = tr
        tr.Stopped:Connect(function() if animPlaying then animationTrickery() end end)
        task.defer(function()
            tr.TimePosition = 0.7
            task.delay(0.3, function() pcall(function() tr:AdjustSpeed(math.huge) end) end)
        end)
    end

    ------------------------------------------------------------------
    -- ON / OFF
    ------------------------------------------------------------------
    local invisCooldown = 0

    local function invisTurnOff()
        clearAllGhosts()
        if not animPlaying then return end
        animPlaying = false; _G.invisibleStealEnabled = false
        for _, t in pairs(tracks) do pcall(function() t:Stop(0) end) end
        tracks = {}
        if conn then conn:Disconnect(); conn = nil end
        for _, x in ipairs(folderConns) do pcall(function() x:Disconnect() end) end
        folderConns = {}
        invisRevert(); clearAllGhosts()
        local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            pcall(function()
                local animator = hum:FindFirstChildOfClass("Animator")
                if animator then
                    for _, t in ipairs(animator:GetPlayingAnimationTracks()) do
                        if t.Priority == Enum.AnimationPriority.Action4
                        or t.Priority == Enum.AnimationPriority.Action3 then t:Stop(0) end
                    end
                end
                hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                task.defer(function()
                    if hum and hum.Parent then hum:ChangeState(Enum.HumanoidStateType.Running) end
                end)
            end)
        end
        -- la walkspeed suit l invis, sauf si tu l as coupee toi-meme
        if WS.enabled and _G.TT3WSEnabled then setWalkSpeedEnabled(false) end
        invisCooldown = tick()
        if refreshUI then refreshUI() end
    end

    local function invisTurnOn()
        if animPlaying then return end
        local c = LP.Character
        if not c or not c:FindFirstChildOfClass("Humanoid") then return end
        animPlaying = true; _G.invisibleStealEnabled = true
        tracks = {}; removeFolders()
        if not invisClone() then
            animPlaying = false; _G.invisibleStealEnabled = false
            if refreshUI then refreshUI() end
            return
        end
        task.wait(0.05); animationTrickery()
        task.delay(1, function()
            if _G.invisibleStealEnabled and _G.TT3WSEnabled and not WS.enabled then
                setWalkSpeedEnabled(true)
            end
        end)
        local lastSetPosition, skipFrames = nil, 5
        conn = RunService.PreSimulation:Connect(function()
            local ch = LP.Character
            local hum = ch and ch:FindFirstChildOfClass("Humanoid")
            if not hum or hum.Health <= 0 or not oldRoot then return end
            local root = ch.PrimaryPart or ch:FindFirstChild("HumanoidRootPart")
            if not root then return end
            -- DETECTION LAGBACK: si l ancien root a saute de >6 studs entre
            -- 2 frames alors qu on porte un brainrot, c est le serveur qui
            -- nous a rembobines.
            if skipFrames > 0 then
                skipFrames = skipFrames - 1; lastSetPosition = nil
            elseif lastSetPosition and ghostEnabled then
                local cur = oldRoot.Position
                if (cur - lastSetPosition).Magnitude > 6
                   and not _G.RecoveryInProgress and LP:GetAttribute("Stealing") then
                    lastSetPosition = nil
                    createServerGhost(cur)
                    if _G.AutoRecoverLagback and _G._forceInvisToggle then
                        _G.RecoveryInProgress = true
                        task.spawn(function()
                            pcall(_G._forceInvisToggle); task.wait(0.6)
                            if LP:GetAttribute("Stealing") then pcall(_G._forceInvisToggle) end
                            _G.RecoveryInProgress = false
                        end)
                    end
                end
            end
            if cloneRoot then cloneRoot.CanCollide = true end
            if oldRoot and oldRoot.Parent then
                for _, x in pairs(oldRoot:GetChildren()) do
                    if x:IsA("Attachment") or x:IsA("Beam") then x:Destroy() end
                end
                local sink = (tonumber(_G.SinkSliderValue) or 8) * 0.5
                oldRoot.CFrame = (root.CFrame - Vector3.new(0, sink, 0))
                    * CFrame.Angles(math.rad(tonumber(_G.InvisStealAngle) or 180), 0, 0)
                oldRoot.AssemblyLinearVelocity = root.AssemblyLinearVelocity
                oldRoot.CanCollide = false
                lastSetPosition = oldRoot.Position
            end
        end)
        if refreshUI then refreshUI() end
    end

    _G.toggleInvisibleSteal = function()
        if (tick() - invisCooldown) < 0.3 then return end
        if animPlaying then invisTurnOff() else invisTurnOn() end
    end
    -- bypass du debounce: utilise par l auto-recover et l auto-invis
    _G._forceInvisToggle = function()
        if animPlaying then invisTurnOff() else invisTurnOn() end
    end

    ------------------------------------------------------------------
    -- RESPAWN / MORT
    ------------------------------------------------------------------
    local function setupDeathListener()
        local ch = LP.Character
        local h = ch and ch:FindFirstChildOfClass("Humanoid")
        if h then
            h.Died:Connect(function()
                clearErrorOrb(); clearAllGhosts(); lagbackCallCount = 0
            end)
        end
    end
    setupDeathListener()

    LP.CharacterAdded:Connect(function(newChar)
        task.wait(0.1)
        clearErrorOrb(); clearAllGhosts(); lagbackCallCount = 0
        pcall(function()
            for _, x in pairs(workspace.CurrentCamera:GetChildren()) do
                if x:IsA("BasePart") and x.Name == "HumanoidRootPart" then x:Destroy() end
            end
        end)
        if oldRoot   then pcall(function() oldRoot:Destroy() end);   oldRoot = nil end
        if cloneRoot then pcall(function() cloneRoot:Destroy() end); cloneRoot = nil end
        animPlaying = false; _G.invisibleStealEnabled = false
        if conn then conn:Disconnect(); conn = nil end
        setupDeathListener()
        if refreshUI then refreshUI() end
        task.wait(0.2)
        local cam = workspace.CurrentCamera
        local h = newChar and newChar:FindFirstChildOfClass("Humanoid")
        if cam and h then cam.CameraSubject = h; cam.CameraType = Enum.CameraType.Custom end
    end)

    ------------------------------------------------------------------
    -- AUTO INVIS PENDANT LE STEAL
    ------------------------------------------------------------------
    task.spawn(function()
        local wasStealing, autoEnabled = false, false
        task.wait(1)
        while task.wait(0.15) do
            if not _G.AutoInvisDuringSteal then
                wasStealing = false; autoEnabled = false
            else
                local isStealing = LP:GetAttribute("Stealing")
                if isStealing and not wasStealing and not _G.invisibleStealEnabled then
                    -- DELAI 0.5s: l invis s active 0.5 seconde APRES le debut du steal
                    -- (au lieu d instant). Re-check qu on steal toujours apres l attente
                    -- -> si le steal a fini avant 0.5s, pas d invis.
                    task.spawn(function()
                        task.wait(0.5)
                        if LP:GetAttribute("Stealing") and not _G.invisibleStealEnabled then
                            pcall(_G._forceInvisToggle); autoEnabled = true
                        end
                    end)
                end
                if not isStealing and autoEnabled and _G.invisibleStealEnabled then
                    task.wait(0.3)
                    if not LP:GetAttribute("Stealing") then
                        pcall(_G._forceInvisToggle); autoEnabled = false
                    end
                end
                wasStealing = isStealing
            end
        end
    end)

    ------------------------------------------------------------------
    -- UI MINIMALE
    ------------------------------------------------------------------
    -- meme parent que le GUI AUTO KICK: gethui()/CoreGui + DisplayOrder ->
    -- passe PAR-DESSUS l UI du jeu au lieu d etre recouvert (parente a PG).
    local guiParent = (gethui and gethui()) or game:GetService("CoreGui") or PG
    pcall(function()
        local old = guiParent:FindFirstChild("InvisStealUI")
        if old then old:Destroy() end
    end)
    local sg = Instance.new("ScreenGui")
    sg.Name = "InvisStealUI"; sg.ResetOnSpawn = false; sg.DisplayOrder = 131
    if _G.TT3RegisterPanel then _G.TT3RegisterPanel("invis", sg) end
    pcall(function() sg.Parent = guiParent end)
    if not sg.Parent then sg.Parent = PG end

    local f = Instance.new("Frame", sg)
    f.Size = UDim2.fromOffset(172, 192)
    fitMobilePanel(f, 0.78)
    -- position restauree depuis TT3Hub.json (section invis)
    f.Position = UDim2.fromOffset(tonumber(_G.InvisPanelX) or 14,
                                  tonumber(_G.InvisPanelY) or 400)
    f.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    f.BorderSizePixel = 0; f.Active = true; f.Draggable = true
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 10)
    do local outline = Instance.new("UIStroke", f); outline.Color = Color3.fromRGB(86, 86, 86); outline.Transparency = 0.45; outline.Thickness = 1 end
    local panelStroke = Instance.new("UIStroke", f)
    panelStroke.Color = Color3.fromRGB(120, 120, 120)
    panelStroke.Transparency = 0.35
    panelStroke.Thickness = 1
    -- Draggable natif de Roblox: pas d evenement de fin de drag, on ecoute donc
    -- Position et on sauve en differe (sinon on ecrirait le fichier a chaque
    -- pixel parcouru pendant le deplacement).
    do
        local pending = false
        f:GetPropertyChangedSignal("Position"):Connect(function()
            if pending then return end
            pending = true
            task.delay(0.5, function()
                pending = false
                _G.InvisPanelX = f.AbsolutePosition.X
                _G.InvisPanelY = f.AbsolutePosition.Y
                saveCfg()
            end)
        end)
    end

    local ttl = Instance.new("TextLabel", f)
    ttl.Size = UDim2.new(1, 0, 0, 22); ttl.BackgroundTransparency = 1
    ttl.Text = "INVIS STEAL"; ttl.Font = Enum.Font.GothamBlack
    ttl.TextSize = 12; ttl.TextColor3 = Color3.new(1, 1, 1)

    local ups = {}
    local function mkBtn(y, label, get, set)
        local b = Instance.new("TextButton", f)
        b.Size = UDim2.new(1, -16, 0, 22); b.Position = UDim2.fromOffset(8, y)
        b.Font = Enum.Font.GothamBold; b.TextSize = 11
        b.TextColor3 = Color3.new(1, 1, 1); b.BorderSizePixel = 0
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5)
        local function up()
            local on = get()
            b.Text = label .. (on and ": ON" or ": OFF")
            b.BackgroundColor3 = on and Color3.fromRGB(86, 86, 86) or Color3.fromRGB(58, 58, 58)
        end
        b.MouseButton1Click:Connect(function() set(); up(); saveCfg() end)
        up(); ups[#ups + 1] = up
    end

    -- ligne compacte "Label: valeur" + [-] [+]
    local function mkRow(y, label, min, max, step, dec, get, set)
        local l = Instance.new("TextLabel", f)
        l.BackgroundTransparency = 1; l.Position = UDim2.fromOffset(8, y)
        l.Size = UDim2.fromOffset(90, 18)
        l.Font = Enum.Font.Gotham; l.TextSize = 11
        l.TextColor3 = Color3.fromRGB(210, 210, 210)
        l.TextXAlignment = Enum.TextXAlignment.Left
        local function txt()
            l.Text = label .. ": " .. string.format("%." .. dec .. "f", tonumber(get()) or min)
        end
        local function mk(px, d, sym)
            local b = Instance.new("TextButton", f)
            b.Size = UDim2.fromOffset(24, 16); b.Position = UDim2.fromOffset(px, y + 1)
            b.BackgroundColor3 = Color3.fromRGB(68, 68, 68)
            b.TextColor3 = Color3.new(1, 1, 1)
            b.Font = Enum.Font.GothamBold; b.TextSize = 13; b.Text = sym
            b.BorderSizePixel = 0
            Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
            b.MouseButton1Click:Connect(function()
                local v = (tonumber(get()) or min) + d * step
                -- arrondi au pas pour eviter la derive flottante (0.30000000004)
                v = math.clamp(math.floor(v / step + 0.5) * step, min, max)
                set(v); txt(); saveCfg()
            end)
        end
        mk(100, -1, "-"); mk(130, 1, "+"); txt()
        return txt
    end

    mkBtn(24, "INVIS",       function() return animPlaying end,
                             function() _G.toggleInvisibleSteal() end)
    mkBtn(48, "WALKSPEED",   function() return WS.enabled end,
                             function()
                                 _G.TT3WSEnabled = not WS.enabled
                                 setWalkSpeedEnabled(_G.TT3WSEnabled)
                             end)
    mkBtn(72, "AUTO INVIS",  function() return _G.AutoInvisDuringSteal end,
                             function() _G.AutoInvisDuringSteal = not _G.AutoInvisDuringSteal end)
    mkBtn(96, "AUTO RECOVER", function() return _G.AutoRecoverLagback end,
                             function() _G.AutoRecoverLagback = not _G.AutoRecoverLagback end)

    refreshUI = function() for _, u in ipairs(ups) do pcall(u) end end

    local refreshAngleBtns, refreshWsBtns
    local refreshRot = mkRow(126, "Rotation",  0,  360, 5,   0,
        function() return _G.InvisStealAngle end,
        function(v) _G.InvisStealAngle = v; if refreshAngleBtns then refreshAngleBtns() end end)
    mkRow(148, "Depth",     0,  18,  0.1, 1, function() return _G.SinkSliderValue end, function(v) _G.SinkSliderValue = v end)
    local refreshWs = mkRow(170, "WalkSpeed", 15, 29,  1,   0,
        function() return _G.TT3WSValue end,
        function(v) _G.setWalkSpeedValue(v); if refreshWsBtns then refreshWsBtns() end end)

    -- ACTIVATION AU CHARGEMENT (ligne 11089 de TT3). C est ce qui manquait:
    -- mon code se contentait de rafraichir le bouton sans jamais appeler
    -- setWalkSpeedEnabled, donc le walkspeed n etait JAMAIS actif tant qu on
    -- ne passait pas par l invis. Chez TT3 c est une option autonome.
    if _G.TT3WSEnabled then
        task.defer(function() setWalkSpeedEnabled(true) end)
    else
        refreshUI()
    end
end)

-- ============================================================
-- X-RAY  (portage de TT3)
-- Rend semi-transparents les murs/decors des bases pour voir les brainrots
-- au travers. Event-driven: on applique une fois puis on suit DescendantAdded,
-- donc cout nul tant que rien ne streame (TT3 avait vire le re-walk 1.5s
-- qui faisait laguer).
--
-- 3 dependances de TT3 n existent pas ici et ont ete neutralisees:
--   _G.__laser            -> systeme de lasers absent, appels gardes
--   OriginalTransparency  -> table du FPS Boost Ultra, absente, gardee
--   Config/saveConfig/setToggle -> supprimes (plus de config, toujours ON)
--
-- CHARGEMENT INSTANTANE: le X-Ray part sans le differe de 6s (nowSpawn) pour
-- etre actif des l entree dans le jeu, comme le TP/auto-grab.
-- ============================================================
nowSpawn(function()
local okXR, errXR = pcall(function()
    local Players = game:GetService("Players")
    local LP = Players.LocalPlayer

    -- ANTI-CUMUL. Si un AUTRE script a deja un X-Ray actif (TT3 tourne en
    -- parallele avec "XRay":true dans sa config), les deux s empilent: le
    -- notre lit la transparence DEJA modifiee par l autre et la prend pour
    -- l originale -> 0.5 + (1-0.5)*0.60 = 0.80, d ou l effet "au max".
    -- On a 5s de retard sur les autres scripts, donc si _G.setXRay existe
    -- deja c est qu un X-Ray tourne: on laisse la main et on ne fait rien.
    if type(_G.setXRay) == "function" then
        warn("[XRAY] un autre X-Ray est deja actif -> celui-ci ne s applique pas (anti-cumul)")
        return
    end

    -- X-Ray actif par defaut, avec intensite fixe a 45%.
    _G.XRayEnabled = true
    _G.XRayAlpha = 0.45

    local origT = setmetatable({}, { __mode = "k" })
    local conns = {}
    local loopId = 0

    local function setTargetTransparency(instance, alpha, id)
        if not instance then return end
        if id and id ~= loopId then return end

        local function apply(obj)
            -- TT3 interceptait ici les lasers via _G.__laser (absent chez toi).
            -- L appel n etait PAS garde et aurait plante sur chaque objet.
            local laser = _G.__laser
            if laser and laser.IsLaserObject and laser.IsLaserObject(obj) then
                local plot = laser.GetPlotFromObject and laser.GetPlotFromObject(obj)
                if plot and laser.IsPlotBaseOpen and laser.IsPlotBaseOpen(plot) then
                    if laser.SaveLaserOriginal then laser.SaveLaserOriginal(obj) end
                    if laser.HideLaserObject then laser.HideLaserObject(obj) end
                end
                return
            end
            if obj:IsA("BasePart") then
                if origT[obj] == nil then
                    if obj.Transparency == alpha then origT[obj] = 0
                    else origT[obj] = obj.Transparency end
                end
                local o = origT[obj]
                if o < 1 then
                    local target = o + (1 - o) * alpha
                    if math.abs(obj.Transparency - target) > 0.01 then obj.Transparency = target end
                end
            elseif obj:IsA("TextLabel") or obj:IsA("TextButton") then
                if origT[obj] == nil then
                    local t, b = obj.TextTransparency, obj.BackgroundTransparency
                    if t == alpha then t = 0 end
                    if b == alpha then b = 0 end
                    origT[obj] = { text = t, bg = b }
                end
                local o = origT[obj]
                if o.text < 1 then
                    local tt = o.text + (1 - o.text) * alpha
                    if math.abs(obj.TextTransparency - tt) > 0.01 then obj.TextTransparency = tt end
                end
                if o.bg < 1 then
                    local tb = o.bg + (1 - o.bg) * alpha
                    if math.abs(obj.BackgroundTransparency - tb) > 0.01 then obj.BackgroundTransparency = tb end
                end
            elseif obj:IsA("Frame") or obj:IsA("ScrollingFrame") then
                if origT[obj] == nil then
                    if obj.BackgroundTransparency == alpha then origT[obj] = 0
                    else origT[obj] = obj.BackgroundTransparency end
                end
                local o = origT[obj]
                if o < 1 then
                    local target = o + (1 - o) * alpha
                    if math.abs(obj.BackgroundTransparency - target) > 0.01 then obj.BackgroundTransparency = target end
                end
            elseif obj:IsA("ImageLabel") or obj:IsA("ImageButton") then
                if origT[obj] == nil then
                    local i, b = obj.ImageTransparency, obj.BackgroundTransparency
                    if i == alpha then i = 0 end
                    if b == alpha then b = 0 end
                    origT[obj] = { img = i, bg = b }
                end
                local o = origT[obj]
                if o.img < 1 then
                    local ti = o.img + (1 - o.img) * alpha
                    if math.abs(obj.ImageTransparency - ti) > 0.01 then obj.ImageTransparency = ti end
                end
                if o.bg < 1 then
                    local tb = o.bg + (1 - o.bg) * alpha
                    if math.abs(obj.BackgroundTransparency - tb) > 0.01 then obj.BackgroundTransparency = tb end
                end
            end
        end

        apply(instance)
        local desc = instance:GetDescendants()
        for i, child in ipairs(desc) do
            apply(child)
            if i % 300 == 0 then
                task.wait()
                if id and id ~= loopId then return end
            end
        end
    end

    local XRAY_FOLDERS = { "Base", "PlotSign", "FriendPanel", "Cash",
                           "Decorations", "Skin", "Unlock", "Purchases" }

    local function trackSubtree(root, alpha, id)
        if not root then return end
        if id ~= loopId then return end
        setTargetTransparency(root, alpha, id)
        if id ~= loopId then return end
        conns[#conns + 1] = root.DescendantAdded:Connect(function(obj)
            if id ~= loopId then return end
            setTargetTransparency(obj, alpha, id)
        end)
    end

    local function processPlot(plot, alpha, id)
        if not plot then return end
        if id ~= loopId then return end
        for _, fname in ipairs(XRAY_FOLDERS) do
            if id ~= loopId then return end
            trackSubtree(plot:FindFirstChild(fname), alpha, id)
        end
        if id ~= loopId then return end
        conns[#conns + 1] = plot.ChildAdded:Connect(function(child)
            if id ~= loopId then return end
            for _, fname in ipairs(XRAY_FOLDERS) do
                if child.Name == fname then trackSubtree(child, alpha, id); break end
            end
        end)

        local podiums = plot:FindFirstChild("AnimalPodiums")
        if podiums then
            local function processPodium(podium)
                for _, child in ipairs(podium:GetChildren()) do
                    if child.Name == "Claim" then
                        trackSubtree(child, alpha, id)
                    elseif child.Name == "Base" then
                        trackSubtree(child:FindFirstChild("Decorations"), alpha, id)
                    elseif child:IsA("Model") and child.Name ~= "Decorations" then
                        trackSubtree(child, alpha, id)
                    end
                end
            end
            for _, podium in ipairs(podiums:GetChildren()) do processPodium(podium) end
            conns[#conns + 1] = podiums.ChildAdded:Connect(function(podium)
                if id ~= loopId then return end
                task.wait(0.1)
                if id ~= loopId then return end
                processPodium(podium)
            end)
        end
    end

    local function applyAllPlots(alpha, id)
        local plots = workspace:FindFirstChild("Plots")
        if not plots then return end
        for _, plot in ipairs(plots:GetChildren()) do
            if id ~= loopId then return end
            processPlot(plot, alpha, id)
            -- pas de task.wait() inter-plot: on applique tous les plots dans la
            -- meme passe pour un X-Ray INSTANT au lancement. Le yield anti-freeze
            -- tous les 300 descendants (setTargetTransparency) suffit a lisser.
        end
        conns[#conns + 1] = plots.ChildAdded:Connect(function(plot)
            if id ~= loopId then return end
            task.wait(0.2)
            processPlot(plot, alpha, id)
        end)
    end

    local function setXRay(enabled)
        _G.XRayEnabled = enabled

        for _, c in ipairs(conns) do
            if typeof(c) == "RBXScriptConnection" then c:Disconnect() end
        end
        conns = {}

        loopId = loopId + 1
        local id = loopId

        if enabled then
            local alpha = 0.45
            _G.XRayAlpha = alpha
            task.spawn(function()
                while id == loopId and not workspace:FindFirstChild("Plots") do
                    task.wait()   -- sondage a chaque frame: on attrape Plots des qu il apparait (X-Ray instant)
                end
                if id ~= loopId then return end
                pcall(applyAllPlots, alpha, id)
            end)
        else
            -- OFF instantane et complet: on echange le snapshot puis on restaure
            -- tout en UNE passe synchrone (pas de task.wait). Sans ca, un
            -- re-enable pouvait chevaucher la restauration et laisser des murs
            -- transparents.
            local snap = origT
            origT = setmetatable({}, { __mode = "k" })
            for obj, o in pairs(snap) do
                pcall(function()
                    if obj:IsA("BasePart") then
                        obj.Transparency = o
                    elseif obj:IsA("TextLabel") or obj:IsA("TextButton") then
                        obj.TextTransparency = o.text
                        obj.BackgroundTransparency = o.bg
                    elseif obj:IsA("Frame") or obj:IsA("ScrollingFrame") then
                        obj.BackgroundTransparency = o
                    elseif obj:IsA("ImageLabel") or obj:IsA("ImageButton") then
                        obj.ImageTransparency = o.img
                        obj.BackgroundTransparency = o.bg
                    end
                end)
            end
            -- TT3 restaurait ici les transparences du FPS Boost Ultra
            -- (table OriginalTransparency). Ce systeme n existe pas ici -> garde.
            local fps = _G.OriginalTransparency
            if type(fps) == "table" then
                for part, data in pairs(fps) do
                    if part and part.Parent and typeof(data) == "table" and data.trans then
                        pcall(function() part.Transparency = data.trans end)
                    end
                end
            end
            local laser = _G.__laser
            if laser and laser.RefreshAllPlotLasers then
                pcall(laser.RefreshAllPlotLasers)
            end
        end
    end
    _G.setXRay = setXRay
    _G.toggleXRay = function() setXRay(not _G.XRayEnabled) end

    -- Quand un joueur REJOINT le serveur alors qu on est deja dedans, sa base
    -- lui est assignee/streamee APRES coup et n emet pas toujours un plot
    -- ChildAdded propre. On re-applique donc le X-Ray (alpha COURANT, defaut
    -- 0.60 = les settings de base) des qu un joueur arrive, pour que la nouvelle
    -- base soit transparente instantanement. Debounce: si plusieurs joueurs
    -- rejoignent en meme temps, on ne rescanne qu une seule fois.
    local _xrReapplyPending = false
    Players.PlayerAdded:Connect(function()
        if not _G.XRayEnabled then return end
        if _xrReapplyPending then return end
        _xrReapplyPending = true
        task.spawn(function()
            task.wait(0.5)   -- laisse la base se streamer avant de rescanner
            _xrReapplyPending = false
            if _G.XRayEnabled then pcall(setXRay, true) end
        end)
    end)

    -- actif par defaut, mais controlable par le bouton X-Ray du menu.
    task.spawn(function() setXRay(true) end)
end)

if not okXR then
    warn("[XRAY] BLOC EN ERREUR: " .. tostring(errXR))
    pcall(function()
        local sg = Instance.new("ScreenGui")
        sg.Name = "XRayError"; sg.ResetOnSpawn = false
        sg.Parent = (gethui and gethui()) or game:GetService("CoreGui")
        local t = Instance.new("TextLabel", sg)
        t.Size = UDim2.new(0, 460, 0, 44); t.Position = UDim2.new(0.5, -230, 0, 60)
        t.BackgroundColor3 = Color3.fromRGB(70, 12, 12)
        t.TextColor3 = Color3.new(1, 1, 1)
        t.Font = Enum.Font.GothamBold; t.TextSize = 11; t.TextWrapped = true
        t.Text = "XRAY ERREUR: " .. tostring(errXR)
    end)
end
end)

-- ============================================================
-- INFINITE JUMP (portage de TT3: cooldown 0.1s, velocite 55)
-- Toujours actif. Tant que Espace est maintenu, on relance la vitesse
-- verticale a 55 toutes les 0.1s -- on saute donc en l air indefiniment.
-- Les composantes X/Z sont preservees pour ne pas casser l elan.
-- Differe de 5s comme les autres ajouts.
-- ============================================================
stagSpawn(function()
local okIJ, errIJ = pcall(function()
    local Players    = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local UIS        = game:GetService("UserInputService")
    local LP         = Players.LocalPlayer

    _G.InfiniteJumpEnabled = true
    local lastJump, conn = 0, nil

    local function setInfiniteJump(en)
        _G.InfiniteJumpEnabled = en
        if conn then conn:Disconnect(); conn = nil end
        if not en then return end
        conn = RunService.Heartbeat:Connect(function()
            if not _G.InfiniteJumpEnabled then return end
            if not UIS:IsKeyDown(Enum.KeyCode.Space) then return end
            local now = tick()
            if now - lastJump < 0.1 then return end
            local c = LP.Character
            if not c then return end
            local hrp = c:FindFirstChild("HumanoidRootPart")
            local hum = c:FindFirstChildOfClass("Humanoid")
            if not hrp or not hum or hum.Health <= 0 then return end
            lastJump = now
            hrp.AssemblyLinearVelocity =
                Vector3.new(hrp.AssemblyLinearVelocity.X, 55, hrp.AssemblyLinearVelocity.Z)
        end)
    end
    _G.setInfiniteJump = setInfiniteJump

    setInfiniteJump(true)
end)

if not okIJ then warn("[INFJUMP] BLOC EN ERREUR: " .. tostring(errIJ)) end
end)

-- ============================================================
-- ANTI-RAGDOLL + ANTI-KNOCKBACK (standalone, portage 1:1 de buzz source.lua)
-- Force la sortie des etats Physics/Ragdoll/FallingDown/GettingUp, retire les
-- contraintes de ragdoll (BallSocket/NoCollision/Hinge + attachments A/B),
-- reactive les Motor6D, coupe les anims de chute, rend camera + controles.
-- Anti-knockback: remet AssemblyLinearVelocity a 0 sur ApplyImpulse et ecrete
-- les pics de vitesse pendant un ragdoll (seuil 40 / max 15).
-- Auto-actif au lancement. Toggles: _G.toggleAntiRagdoll(true|false),
-- _G.enableAntiKnockback(), _G.disableAntiKnockback().
--
-- Adaptations pour CET environnement (sinon TP / knockback casses):
--   * ApplyImpulse resolu via le resolveur de remotes hashes (_G.TT3GetRemote),
--     avec repli sur le chemin litteral Packages.Net["RE/CombatService/ApplyImpulse"].
--   * garde _G.TT3StealHold + skip >60 studs/s dans le clamp Heartbeat pour ne
--     PAS ecreter la vitesse pendant un TP scripte (sinon arret net = lagback).
-- ============================================================
nowSpawn(function()
local okAR, errAR = pcall(function()
    local Players           = game:GetService("Players")
    local RunService        = game:GetService("RunService")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local Workspace         = workspace
    local player            = Players.LocalPlayer
    while not player do task.wait(); player = Players.LocalPlayer end

    -- shims host buzz -> no-ops ici
    local Config = { AntiRagdoll = false }
    local function setToggle() end
    local function saveConfig() end

    -- ANTI RAGDOLL
    -- Anti-Ragdoll System (comprehensive with knockback suppression)
    do
        local antiRagdollConnections = {}
        local antiRagdollCharacter, antiRagdollHumanoid, antiRagdollRootPart, antiRagdollAnimator
        local lastVelocity = Vector3.new(0, 0, 0)
        local velocityChangeThreshold = 40
        local velocityMagnitudeThreshold = 25
        local maxVelocity = 15

        local function isFlyingCarpetActive()
            if not antiRagdollCharacter then return false end
            local tool = antiRagdollCharacter:FindFirstChildWhichIsA("Tool")
            if not tool then return false end
            local hrp = antiRagdollCharacter:FindFirstChild("HumanoidRootPart")
            if hrp then
                for _, obj in ipairs(hrp:GetChildren()) do
                    if obj:IsA("BodyVelocity") or obj:IsA("BodyPosition") or obj:IsA("BodyGyro") then
                        return true
                    end
                end
            end
            return false
        end

        local function isRagdolled()
            if not antiRagdollHumanoid then return false end
            local state = antiRagdollHumanoid:GetState()
            return state == Enum.HumanoidStateType.Physics
                or state == Enum.HumanoidStateType.Ragdoll
                or state == Enum.HumanoidStateType.FallingDown
                or state == Enum.HumanoidStateType.GettingUp
        end

        local function enableAntiRagdollControls()
            pcall(function()
                local PlayerModule = player:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule", 10)
                require(PlayerModule):GetControls():Enable()
            end)
        end

        local function cleanupRagdoll()
            if not antiRagdollCharacter then return end
            local carpetEquipped = isFlyingCarpetActive()

            local function processChildren(parent)
                for _, obj in ipairs(parent:GetChildren()) do
                    if obj:IsA("BallSocketConstraint") or obj:IsA("NoCollisionConstraint") or obj:IsA("HingeConstraint")
                        or (obj:IsA("Attachment") and (obj.Name == "A" or obj.Name == "B")) then
                        obj:Destroy()
                    elseif obj:IsA("BodyVelocity") or obj:IsA("BodyPosition") or obj:IsA("BodyGyro") then
                        if not carpetEquipped then obj:Destroy() end
                    elseif obj:IsA("Motor6D") then
                        obj.Enabled = true
                    elseif obj:IsA("BasePart") then
                        for _, child in ipairs(obj:GetChildren()) do
                            if child:IsA("BallSocketConstraint") or child:IsA("NoCollisionConstraint") or child:IsA("HingeConstraint") or child:IsA("Motor6D") then
                                if child:IsA("Motor6D") then
                                    child.Enabled = true
                                else
                                    child:Destroy()
                                end
                            elseif child:IsA("Attachment") and (child.Name == "A" or child.Name == "B") then
                                child:Destroy()
                            end
                        end
                    end
                end
            end

            pcall(function() processChildren(antiRagdollCharacter) end)

            if antiRagdollAnimator then
                for _, track in pairs(antiRagdollAnimator:GetPlayingAnimationTracks()) do
                    local animName = track.Animation and track.Animation.Name:lower() or ""
                    if animName:find("rag") or animName:find("fall") or animName:find("hurt") or animName:find("down") then
                        track:Stop(0)
                    end
                end
            end
        end

        local function setupAntiRagdollCharacter(char)
            antiRagdollCharacter = char
            antiRagdollHumanoid = char:WaitForChild("Humanoid", 10)
            antiRagdollRootPart = char:WaitForChild("HumanoidRootPart", 10)
            antiRagdollAnimator = antiRagdollHumanoid and antiRagdollHumanoid:WaitForChild("Animator", 10)
            lastVelocity = Vector3.new(0, 0, 0)
        end

        local function clearAntiRagdollConnections()
            for _, c in pairs(antiRagdollConnections) do
                pcall(function() c:Disconnect() end)
            end
            antiRagdollConnections = {}
        end

        local function setupAntiRagdollConnections()
            clearAntiRagdollConnections()
            if not antiRagdollHumanoid or not antiRagdollRootPart then return end

            table.insert(antiRagdollConnections, antiRagdollHumanoid.StateChanged:Connect(function()
                if (_G.AntiRagdollEnabled or _G.antiKnockbackEnabled) and isRagdolled() then
                    if not isFlyingCarpetActive() then
                        antiRagdollHumanoid:ChangeState(Enum.HumanoidStateType.Running)
                    end
                    cleanupRagdoll()
                    pcall(function() Workspace.CurrentCamera.CameraSubject = antiRagdollHumanoid end)
                    enableAntiRagdollControls()
                end
            end))

            -- ApplyImpulse: resolveur hashe d abord, repli sur le chemin litteral
            pcall(function()
                local impulse
                if _G.TT3GetRemote then
                    impulse = _G.TT3GetRemote("RemoteEvent", "CombatService/ApplyImpulse")
                end
                if not impulse then
                    local pkgs = ReplicatedStorage:FindFirstChild("Packages")
                    local net  = pkgs and pkgs:FindFirstChild("Net")
                    impulse = net and net:FindFirstChild("RE/CombatService/ApplyImpulse")
                end
                if impulse then
                    table.insert(antiRagdollConnections, impulse.OnClientEvent:Connect(function()
                        if (_G.AntiRagdollEnabled or _G.antiKnockbackEnabled) and isRagdolled() then
                            antiRagdollRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                        end
                    end))
                end
            end)

            table.insert(antiRagdollConnections, antiRagdollCharacter.DescendantAdded:Connect(function()
                if (_G.AntiRagdollEnabled or _G.antiKnockbackEnabled) and isRagdolled() then
                    cleanupRagdoll()
                end
            end))

            table.insert(antiRagdollConnections, RunService.Heartbeat:Connect(function()
                if (_G.AntiRagdollEnabled or _G.antiKnockbackEnabled) and isRagdolled() then
                    -- PENDANT UN TP: on ne touche a rien (sinon la vitesse du vol
                    -- serait ecretee a 15 -> arret net -> lagback).
                    if _G.TT3StealHold then return end
                    if antiRagdollRootPart.AssemblyLinearVelocity.Magnitude > 60 then
                        lastVelocity = antiRagdollRootPart.AssemblyLinearVelocity
                        return
                    end
                    cleanupRagdoll()
                    local velocity = antiRagdollRootPart.AssemblyLinearVelocity
                    if (velocity - lastVelocity).Magnitude > velocityChangeThreshold
                        and velocity.Magnitude > velocityMagnitudeThreshold then
                        antiRagdollRootPart.AssemblyLinearVelocity = velocity.Unit * math.min(velocity.Magnitude, maxVelocity)
                    end
                    lastVelocity = velocity
                end
            end))

            enableAntiRagdollControls()
            cleanupRagdoll()
        end

        local function startAntiRagdoll()
            _G.AntiRagdollEnabled = true
            _G.antiKnockbackEnabled = true
            Config.AntiRagdoll = true; setToggle("Anti Ragdoll", true); saveConfig()
            if player.Character then
                setupAntiRagdollCharacter(player.Character)
                setupAntiRagdollConnections()
            end
        end

        local function stopAntiRagdoll()
            _G.AntiRagdollEnabled = false
            _G.antiKnockbackEnabled = false
            Config.AntiRagdoll = false; setToggle("Anti Ragdoll", false); saveConfig()
            clearAntiRagdollConnections()
        end

        _G.toggleAntiRagdoll = function(enabled)
            if enabled then startAntiRagdoll() else stopAntiRagdoll() end
        end
        _G.enableAntiKnockback = function() startAntiRagdoll() end
        _G.disableAntiKnockback = function() stopAntiRagdoll() end

        player.CharacterAdded:Connect(function(char)
            clearAntiRagdollConnections()
            antiRagdollCharacter = nil; antiRagdollHumanoid = nil; antiRagdollRootPart = nil; antiRagdollAnimator = nil
            local humanoid = char:WaitForChild("Humanoid", 10)
            local rootPart = char:WaitForChild("HumanoidRootPart", 10)
            if not humanoid or not rootPart then return end
            task.wait(0.2)
            setupAntiRagdollCharacter(char)
            if _G.AntiRagdollEnabled or _G.antiKnockbackEnabled then
                setupAntiRagdollConnections()
            end
        end)

        if player.Character then
            setupAntiRagdollCharacter(player.Character)
            if _G.AntiRagdollEnabled or _G.antiKnockbackEnabled then
                setupAntiRagdollConnections()
            end
        end
    end

    -- auto-enable on run (anti-ragdoll + anti-knockback)
    if _G.toggleAntiRagdoll then _G.toggleAntiRagdoll(true) end
end)

if not okAR then warn("[ANTIRAGDOLL] BLOC EN ERREUR: " .. tostring(errAR)) end
end)

-- ============================================================
-- NO-COLLISION JOUEUR : place toutes les parts du perso dans le CollisionGroup
-- "PlayerNoCollision" (plus de collision physique avec les autres joueurs).
-- pcall sur l assignation: si le groupe n existe pas cote client, on ignore.
-- ============================================================
nowSpawn(function()
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    if not LocalPlayer then return end

    local NO_COLLIDE_GROUP = "PlayerNoCollision"

    local function applyChar(char)
        local hrp = char:FindFirstChild("HumanoidRootPart") or char:WaitForChild("HumanoidRootPart", 10)
        if not hrp then return end
        local function setPart(part)
            if part:IsA("BasePart") and part.Name ~= "__HITBOX" then
                pcall(function() part.CollisionGroup = NO_COLLIDE_GROUP end)
            end
        end
        for _, part in ipairs(char:GetDescendants()) do setPart(part) end
        char.DescendantAdded:Connect(setPart)
    end

    if LocalPlayer.Character then task.spawn(applyChar, LocalPlayer.Character) end
    LocalPlayer.CharacterAdded:Connect(applyChar)
end)

-- ============================================================
-- ANTI GUMMY BEAR  (ex AntiGummy.lua, fusionne ici)
-- ON par defaut. Clear BlockTools / Web + BackpackReady, detruit les
-- instances Workspace "GummyBear" (existantes + ChildAdded). Grace 1.5s
-- au respawn pour ne pas casser le loadout. Toggle: _G.AntiGummy.set(on)
-- IMPORTANT: c est ce bloc qui debloque le STEAL apres un item web/gummy.
-- timeUntilCanSteal() (Teleport) renvoie -1 tant que l attribut "Web" est pose
-- -> sans ce clear, le steal (et le hold-pendant-ragdoll) ne part JAMAIS apres
-- s etre fait web/gummy. On remet aussi BlockTools/BackpackReady a l etat OK.
-- nowSpawn: actif tout de suite (pas le differe 6s de stagSpawn).
-- ============================================================
nowSpawn(function()
local okAG, errAG = pcall(function()
    local cloneref = (type(cloneref) == "function" and cloneref) or function(o) return o end
    local Players   = cloneref(game:GetService("Players"))
    local Workspace = cloneref(game:GetService("Workspace"))
    local Player    = Players.LocalPlayer

    local antiGummy = true
    local antiGummyRespawnGraceUntil = 0

    Player.CharacterAdded:Connect(function(char)
        local hum = char:WaitForChild("Humanoid", 5)
        if not hum then return end
        antiGummyRespawnGraceUntil = tick() + 1.5
    end)

    local function clearGummyToolBlockState(char)
        for _, inst in ipairs({ Player, char }) do
            if inst then
                if inst:GetAttribute("BlockTools") ~= nil and inst:GetAttribute("BlockTools") ~= false then
                    inst:SetAttribute("BlockTools", false)
                end
                if inst:GetAttribute("Web") ~= nil and inst:GetAttribute("Web") ~= false then
                    inst:SetAttribute("Web", false)
                end
            end
        end
        if char and char:GetAttribute("BackpackReady") == false then
            char:SetAttribute("BackpackReady", true)
        end
    end

    local function deleteGummyBears()
        for _, obj in ipairs(Workspace:GetChildren()) do
            if obj.Name == "GummyBear" then
                pcall(function() obj:Destroy() end)
            end
        end
    end

    Workspace.ChildAdded:Connect(function(child)
        if antiGummy and child.Name == "GummyBear" then
            pcall(function() child:Destroy() end)
        end
    end)

    task.spawn(function()
        while task.wait(0.1) do
            if not antiGummy then continue end
            local char = Player.Character
            if not char then continue end
            local hum = char:FindFirstChildOfClass("Humanoid")
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hum or not hrp then continue end
            if tick() >= antiGummyRespawnGraceUntil then
                clearGummyToolBlockState(char)
            end
        end
    end)

    deleteGummyBears()

    _G.AntiGummy = {
        set = function(on)
            antiGummy = on and true or false
            if antiGummy then deleteGummyBears() end
        end,
    }
end)
if not okAG then warn("[ANTI-GUMMY] BLOC EN ERREUR: " .. tostring(errAG)) end
end)

-- ============================================================
-- CLEAN ERROR POPUPS (portage de TT3)
-- Toujours actif. GuiService:ClearError() ferme les popups d erreur Roblox
-- ("Disconnected", messages de kick, erreurs reseau) toutes les 0.1s.
-- cloneref si dispo: evite que le jeu remonte a notre reference du service.
-- Differe de 5s comme les autres ajouts.
-- ============================================================
stagSpawn(function()
    _G.CleanErrorGUIs = true
    local GS
    if cloneref then
        pcall(function() GS = cloneref(game:GetService("GuiService")) end)
    end
    GS = GS or game:GetService("GuiService")
    task.spawn(function()
        while true do
            if _G.CleanErrorGUIs then pcall(function() GS:ClearError() end) end
            task.wait(1)   -- throttle anti-freeze: clear error GUIs 10x/s -> 1x/s (inutile plus vite)
        end
    end)
end)

-- ============================================================
-- CARPET SPEED + INSTANT CLONE (portage de TT3) + MENU KEYBIND
--
-- Carpet Speed: tant qu un tapis/planeur est equipe, on pousse le
-- HumanoidRootPart a 140 studs/s dans la direction du deplacement.
-- Il se COUPE tout seul si tu equipes un autre outil, pendant un TP et
-- pendant un steal. Et il est TOUJOURS OFF au lancement: son etat n est
-- jamais sauvegarde, seules les touches le sont.
--
-- Instant Clone: equipe le Quantum Cloner, l active, puis declenche le
-- bouton "TeleportToClone" du ToolsFrames via firesignal.
--
-- ACTIF TOUT DE SUITE: pas de differe de 6s (nowSpawn au lieu de stagSpawn) ->
-- le Carpet Speed et ses keybinds sont dispos des le chargement.
-- ============================================================
nowSpawn(function()
local okCC, errCC = pcall(function()
    local Players    = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local UIS        = game:GetService("UserInputService")
    local HS         = game:GetService("HttpService")
    local LP         = Players.LocalPlayer
    local PG         = LP:WaitForChild("PlayerGui")
    local guiParent  = (gethui and gethui()) or game:GetService("CoreGui") or PG

    ------------------------------------------------------------------
    -- CARPET SPEED
    ------------------------------------------------------------------
    local SPEED_BOOST_TOOL_NAMES = {
        ["Flying Carpet"] = true, ["Carpet"] = true, ["Cloud"] = true,
        ["Witch's Broom"] = true, ["Cupid's Wings"] = true, ["Santa's Sleigh"] = true,
        ["Magic Carpet"] = true, ["Waverider"] = true,
    }

    -- JAMAIS persiste -> OFF a chaque relance du jeu
    local carpetOn, carpetConn, toolConn = false, nil, nil
    local refreshUI

    local function preferredTool()
        local t = _G.TT3CarpetTool
        if type(t) == "string" and t ~= "" then return t end
        return "Flying Carpet"
    end

    local function isSpeedBoostTool(tool)
        if not tool or not tool:IsA("Tool") then return false end
        if SPEED_BOOST_TOOL_NAMES[tool.Name] then return true end
        return tool.Name == preferredTool()
    end

    local function getEquippedTool(char)
        if not char then return nil end
        return char:FindFirstChildWhichIsA("Tool")
    end

    local function equipSpeedBoostToolOnce(c, hum)
        if not c or not hum then return nil end
        local bp = LP:FindFirstChild("Backpack")
        local pref = preferredTool()
        if c:FindFirstChild(pref) then return pref end
        local tb = bp and bp:FindFirstChild(pref)
        if tb then pcall(function() hum:EquipTool(tb) end); return pref end
        for name in pairs(SPEED_BOOST_TOOL_NAMES) do
            if c:FindFirstChild(name) then return name end
            local t = bp and bp:FindFirstChild(name)
            if t then pcall(function() hum:EquipTool(t) end); return name end
        end
        return nil
    end

    -- TT3 utilisait _G._isTpMoving, absent ici. _G.TT3StealHold est pose
    -- par le TP de ce script pendant tout le vol: meme role.
    local function isCarpetSpeedBlocked()
        if _G._isTpMoving then return true end
        if _G.TT3StealHold then return true end
        if LP:GetAttribute("Stealing") then return true end
        return false
    end
    _G.isCarpetSpeedBlocked = isCarpetSpeedBlocked

    local setCarpetSpeed
    setCarpetSpeed = function(en)
        if en and isCarpetSpeedBlocked() then return end
        carpetOn = en
        if refreshUI then refreshUI() end
        if carpetConn then carpetConn:Disconnect(); carpetConn = nil end
        if not en then return end

        local c = LP.Character
        local hum = c and c:FindFirstChildOfClass("Humanoid")
        if c and hum then equipSpeedBoostToolOnce(c, hum) end

        carpetConn = RunService.Heartbeat:Connect(function()
            local ch = LP.Character
            if not ch then return end
            local hrp = ch:FindFirstChild("HumanoidRootPart")
            if isCarpetSpeedBlocked() then
                if hrp then
                    hrp.AssemblyLinearVelocity = Vector3.new(0, hrp.AssemblyLinearVelocity.Y, 0)
                end
                return
            end
            local hm = ch:FindFirstChildOfClass("Humanoid")
            if not hm or not hrp then return end
            local equipped = getEquippedTool(ch)
            -- autre outil equipe = on coupe net
            if equipped and not isSpeedBoostTool(equipped) then
                hrp.AssemblyLinearVelocity = Vector3.new(0, hrp.AssemblyLinearVelocity.Y, 0)
                setCarpetSpeed(false)
                return
            end
            if equipped and isSpeedBoostTool(equipped) then
                local md = hm.MoveDirection
                if md.Magnitude > 0 then
                    hrp.AssemblyLinearVelocity =
                        Vector3.new(md.X * 140, hrp.AssemblyLinearVelocity.Y, md.Z * 140)
                else
                    hrp.AssemblyLinearVelocity = Vector3.new(0, hrp.AssemblyLinearVelocity.Y, 0)
                end
            end
        end)
    end
    _G.setCarpetSpeed = setCarpetSpeed
    _G.toggleCarpetSpeed = function() setCarpetSpeed(not carpetOn) end

    local function stopFromToolSwitch(char)
        if not carpetOn or not char then return end
        local equipped = getEquippedTool(char)
        if equipped and not isSpeedBoostTool(equipped) then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then hrp.AssemblyLinearVelocity = Vector3.new(0, hrp.AssemblyLinearVelocity.Y, 0) end
            setCarpetSpeed(false)
        end
    end
    local function bindToolWatch(char)
        if toolConn then pcall(function() toolConn:Disconnect() end); toolConn = nil end
        if not char then return end
        toolConn = char.ChildAdded:Connect(function(child)
            if child:IsA("Tool") then
                task.defer(function() stopFromToolSwitch(char) end)
            end
        end)
    end

    LP.CharacterAdded:Connect(function(char)
        bindToolWatch(char)
        if carpetOn then
            task.defer(function()
                local hum = char:WaitForChild("Humanoid", 10)
                if hum and carpetOn then equipSpeedBoostToolOnce(char, hum) end
            end)
        end
    end)
    if LP.Character then bindToolWatch(LP.Character) end

    ------------------------------------------------------------------
    -- INSTANT CLONE
    ------------------------------------------------------------------
    local function instantClone()
        local c = LP.Character
        if not c then return end
        local h = c:FindFirstChildOfClass("Humanoid")
        if not h then return end
        local bp = LP:FindFirstChild("Backpack")
        local cl = (bp and bp:FindFirstChild("Quantum Cloner")) or c:FindFirstChild("Quantum Cloner")
        if not cl then return end
        pcall(function() h:UnequipTools() end); task.wait()
        if cl.Parent ~= c then pcall(function() h:EquipTool(cl) end); task.wait() end
        local tf = PG:FindFirstChild("ToolsFrames")
        local qc = tf and tf:FindFirstChild("QuantumCloner")
        local tb = qc and qc:FindFirstChild("TeleportToClone")
        if not tb then return end
        _G.isCloning = true
        pcall(function() cl:Activate() end)
        task.wait(0.05)
        tb.Visible = true
        pcall(function() firesignal(tb.MouseButton1Click) end)
        pcall(function() firesignal(tb.MouseButton1Up) end)
        pcall(function() firesignal(tb.Activated) end)
        task.delay(0.55, function() _G.isCloning = false end)
    end
    _G.instantClone = instantClone

    ------------------------------------------------------------------
    -- FLOAT (portage de TT3)
    -- Plateforme invisible 7x1x7 ancree 3.35 studs sous le personnage, qui
    -- le suit a chaque frame -> on reste en l air. Interdit tant qu on porte
    -- un brainrot (le jeu te fait tomber / annule le vol), et coupee
    -- automatiquement si un steal demarre pendant que Float est actif.
    ------------------------------------------------------------------
    local floatOn, floatPart, floatConn = false, nil, nil

    local function removeFloatPlatform()
        if floatConn then floatConn:Disconnect(); floatConn = nil end
        if floatPart then pcall(function() floatPart:Destroy() end); floatPart = nil end
    end

    local function createFloatPlatform()
        removeFloatPlatform()
        local c = LP.Character
        local hrp = c and c:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local p = Instance.new("Part")
        p.Size = Vector3.new(7, 1, 7)
        p.Anchored = true; p.CanCollide = true
        p.CanTouch = false; p.CanQuery = false
        p.Transparency = 1; p.CastShadow = false
        p.CFrame = CFrame.new(hrp.Position - Vector3.new(0, 3.35, 0))
        p.Parent = workspace
        floatPart = p
        floatConn = RunService.Heartbeat:Connect(function()
            if not floatOn then return end
            local ch = LP.Character
            local h = ch and ch:FindFirstChild("HumanoidRootPart")
            if h and floatPart then
                floatPart.CFrame = CFrame.new(h.Position - Vector3.new(0, 3.35, 0))
            end
        end)
    end

    local function setFloat(on)
        -- jamais de Float en portant un brainrot
        if on and LP:GetAttribute("Stealing") then
            if refreshUI then refreshUI() end
            return
        end
        floatOn = on
        if on then createFloatPlatform() else removeFloatPlatform() end
        if refreshUI then refreshUI() end
    end
    _G.setFloat = setFloat
    _G.toggleFloat = function() setFloat(not floatOn) end

    -- coupure auto si un steal demarre alors que Float est actif
    LP:GetAttributeChangedSignal("Stealing"):Connect(function()
        if floatOn and LP:GetAttribute("Stealing") then setFloat(false) end
    end)
    -- la plateforme ne survit pas au respawn: on la recree
    LP.CharacterAdded:Connect(function()
        task.wait(0.5)
        if floatOn then removeFloatPlatform(); createFloatPlatform() end
    end)

    ------------------------------------------------------------------
    -- KEYBINDS + MENU
    ------------------------------------------------------------------
    local kbCfg = _G.HubCfg.get("carpet")   -- section du fichier partage
    local panelFrame   -- ref du cadre, pour le keybind "Main Menu" (show/hide)
    local resetBusy, resetGeneration = false, 0
    local function normalResetCharacter()
        if resetBusy then return false end
        local char = LP.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not char or not hum or not root or hum.Health <= 0 then return false end

        resetBusy = true
        resetGeneration = resetGeneration + 1
        local myGeneration = resetGeneration
        _G.AntiDieDisabled = true
        _G.TT3TPStop = true
        if type(_G.TT3StopPhysicalTargetWalk) == "function" then pcall(_G.TT3StopPhysicalTargetWalk) end
        if type(_G.TT3ClearTPSync) == "function" then pcall(_G.TT3ClearTPSync) end
        _G.TT3StealHold = false

        local camera = workspace.CurrentCamera
        pcall(function() if camera then camera.CameraType = Enum.CameraType.Scriptable end end)
        local addedConn
        local function finishReset(newCharacter)
            if myGeneration ~= resetGeneration or not resetBusy then return end
            if addedConn then addedConn:Disconnect(); addedConn = nil end
            local currentCamera = workspace.CurrentCamera
            local currentHumanoid = newCharacter and newCharacter:FindFirstChildOfClass("Humanoid")
            pcall(function()
                if currentCamera then
                    currentCamera.CameraType = Enum.CameraType.Custom
                    if currentHumanoid then currentCamera.CameraSubject = currentHumanoid end
                end
            end)
            _G.AntiDieDisabled = false
            _G.TT3TPStop = false
            resetBusy = false
        end
        addedConn = LP.CharacterAdded:Connect(function(newCharacter)
            task.defer(function()
                local newHumanoid = newCharacter:FindFirstChildOfClass("Humanoid")
                    or newCharacter:WaitForChild("Humanoid", 3)
                finishReset(newCharacter)
            end)
        end)

        task.spawn(function()
            local RunService = game:GetService("RunService")
            local resetCFrame = CFrame.new(1000003.56, 999999.69, 8.17)
            local dropDeadline = os.clock() + 3
            -- Ryxx-style out-of-bounds reset; repeat until the game marks the humanoid dead.
            while myGeneration == resetGeneration and LP.Character == char
                and char.Parent and hum.Health > 0 and root.Parent and os.clock() < dropDeadline do
                pcall(function() root.CFrame = resetCFrame end)
                RunService.Heartbeat:Wait()
            end

            -- Reliable fallback if the out-of-bounds fall did not trigger death.
            if myGeneration == resetGeneration and LP.Character == char and hum.Health > 0 then
                pcall(function() hum.BreakJointsOnDeath = true end)
                pcall(function() hum.Health = 0 end)
                pcall(function() hum:ChangeState(Enum.HumanoidStateType.Dead) end)
                pcall(function() char:BreakJoints() end)
            end

            local respawnDeadline = os.clock() + 8
            while myGeneration == resetGeneration and LP.Character == char and os.clock() < respawnDeadline do
                pcall(function() if root.Parent then root.CFrame = resetCFrame end end)
                task.wait(0.1)
            end
            if myGeneration == resetGeneration and resetBusy then finishReset(LP.Character) end
        end)
        return true
    end
    _G.TT3NormalReset = normalResetCharacter
    _G.TT3InstaReset = normalResetCharacter
    _G.InstantReset = normalResetCharacter
    local normalResetButtonEvent = Instance.new("BindableEvent")
    normalResetButtonEvent.Event:Connect(normalResetCharacter)
    task.spawn(function()
        for _ = 1, 12 do
            local ok = pcall(function()
                game:GetService("StarterGui"):SetCore("ResetButtonCallback", normalResetButtonEvent)
            end)
            if ok then break end
            task.wait(1)
        end
    end)
    local binds = {
        { id = "carpet", label = "Carpet Speed",
          key = (type(_G.TT3CarpetSpeedKeyName) == "string" and _G.TT3CarpetSpeedKeyName) or "Q",
          run = function() setCarpetSpeed(not carpetOn) end },
        { id = "clone",  label = "Instant Clone",
          key = (type(_G.TT3CloneKeyName) == "string" and _G.TT3CloneKeyName) or "V",
          run = function() task.spawn(instantClone) end },
        { id = "float",  label = "Float", key = "Z",
          run = function() setFloat(not floatOn) end },
        { id = "invis",  label = "Invisible Steal", key = "U",
          run = function() if _G.toggleInvisibleSteal then pcall(_G.toggleInvisibleSteal) end end },
        { id = "walkspeed", label = "WalkSpeed", key = "H",
          run = function()
              if _G.setWalkSpeedEnabled then
                  _G.TT3WSEnabled = not _G.TT3WSEnabled
                  _G.setWalkSpeedEnabled(_G.TT3WSEnabled)
              end
          end },
        { id = "drop",   label = "Drop Brainrot", key = "G",
          run = function() if _G.TT3DropBrainrot then pcall(_G.TT3DropBrainrot) end end },
        { id = "kick",   label = "Kick", key = "Y",
          run = function() if _G.TT3Kick then pcall(_G.TT3Kick) end end },
        { id = "resetCharacter", label = "Reset", key = "R",
          run = function() if _G.TT3NormalReset then pcall(_G.TT3NormalReset) end end },
        { id = "autobuy", label = "Auto Buy", key = "K",
          run = function() if _G.TT3ToggleAutoBuy then pcall(_G.TT3ToggleAutoBuy) end end },
        { id = "menu",   label = "Main Menu", key = "LeftControl",
          run = function() if panelFrame then panelFrame.Visible = not panelFrame.Visible end end },
    }
    local panelX, panelY = 240, 120

    do
        for _, b in ipairs(binds) do
            if type(kbCfg[b.id]) == "string" and #kbCfg[b.id] > 0 then b.key = kbCfg[b.id] end
        end
        -- NOTE: on ne relit volontairement AUCUN etat ON/OFF ici.
        -- Carpet Speed doit repartir OFF a chaque lancement.
        if tonumber(kbCfg.x) then panelX = tonumber(kbCfg.x) end
        if tonumber(kbCfg.y) then panelY = tonumber(kbCfg.y) end
        -- Auto Buy uses the RoseHub default: fixed 17-stud range; discard any legacy slider value.
        _G.TT3AutoBuyRange = 17
        _G.TT3AutoBuyFireRange = 17
        if kbCfg.buyRange ~= nil then
            kbCfg.buyRange = nil
            pcall(_G.HubCfg.save)
        end
    end
    local function saveKb()
        kbCfg.x = panelX; kbCfg.y = panelY
        for _, b in ipairs(binds) do kbCfg[b.id] = b.key end
        _G.HubCfg.save()
    end

    local capturing = nil

    -- ============================================================
    -- KEYBINDS CLAVIER/SOURIS (meme methode que invisible.txt): supporte les
    -- boutons LATERAUX MB4/MB5. UIS ne les recoit pas -> poll (IsMouseButtonPressed
    -- / Enum.KeyCode.MouseButton4-5 / VK Windows 0x05-0x06). Format des binds:
    -- "Key:Q" / "Mouse:MouseButton4". Legacy "Q" -> "Key:Q" (normalise).
    -- ============================================================
    local VK_XBUTTON1, VK_XBUTTON2 = 0x05, 0x06
    local function _norm(s)
        if type(s) ~= "string" or s == "" then return nil end
        if string.find(s, ":", 1, true) then return s end
        return "Key:" .. s
    end
    local function _bindPretty(s)
        local n = _norm(s); if not n then return "NONE" end
        local kind, name = string.match(n, "^([^:]+):(.+)$")
        if kind == "Mouse" then
            local map = { MouseButton1="MB1", MouseButton2="MB2", MouseButton3="MB3",
                          MouseButton4="MB4", XButton1="MB4", MouseButton5="MB5", XButton2="MB5" }
            return map[name] or name
        end
        return name or n
    end
    local function _isMouseBtn(input)
        local nm = input.UserInputType and input.UserInputType.Name
        return nm == "MouseButton1" or nm == "MouseButton2" or nm == "MouseButton3"
            or nm == "MouseButton4" or nm == "MouseButton5"
    end
    local function _inputMatches(input, bind)
        bind = _norm(bind); if not bind then return false end
        local kind, name = string.match(bind, "^([^:]+):(.+)$")
        if kind == "Key" then
            return input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode.Name == name
        elseif kind == "Mouse" then
            return input.UserInputType.Name == name
        end
        return false
    end
    local function _vkDown(vk)
        for _, fn in ipairs({ iskeydown, iskeypressed }) do
            if typeof(fn) == "function" then local ok, r = pcall(fn, vk); if ok and r then return true end end
        end
        if typeof(getkeystate) == "function" then
            local ok, r = pcall(getkeystate, vk)
            if ok then
                if r == true then return true end
                if type(r) == "number" and (r < 0 or (bit32 and bit32.band(r, 0x8000) ~= 0)) then return true end
            end
        end
        return false
    end
    local function _sideDown(side)
        local name = "MouseButton" .. tostring(side)
        local ok, uit = pcall(function() return Enum.UserInputType[name] end)
        if ok and uit then local ok2, p = pcall(function() return UIS:IsMouseButtonPressed(uit) end); if ok2 and p then return true end end
        local okk, kc = pcall(function() return Enum.KeyCode[name] end)
        if okk and kc then
            local ok2, p = pcall(function() return UIS:IsKeyDown(kc) end); if ok2 and p then return true end
            if typeof(iskeydown) == "function" then local ok3, p3 = pcall(iskeydown, kc); if ok3 and p3 then return true end end
        end
        return _vkDown(side == 5 and VK_XBUTTON2 or VK_XBUTTON1)
    end
    local function _bindIsSide(bind, side)
        bind = _norm(bind); if not bind then return false end
        local want = "Mouse:MouseButton" .. tostring(side)
        if bind == want then return true end
        if side == 4 and (bind == "Mouse:XButton1" or bind == "Mouse:MB4") then return true end
        if side == 5 and (bind == "Mouse:XButton2" or bind == "Mouse:MB5") then return true end
        return false
    end
    -- declenche un bouton lateral: rebind si capture en cours, sinon run du bind
    local function _onSide(side)
        if capturing then
            local b = capturing; capturing = nil
            b.key = "Mouse:MouseButton" .. tostring(side); saveKb()
            if b.refresh then b.refresh() end
            return
        end
        for _, b in ipairs(binds) do
            if _bindIsSide(b.key, side) then b.run(); return end
        end
    end

    UIS.InputBegan:Connect(function(input, gameProcessed)
        -- CAPTURE (rebind): clavier OU souris. MB1 exclu (sert a cliquer l UI),
        -- MB4/MB5 geres par le poll ci-dessous.
        if capturing then
            if input.UserInputType == Enum.UserInputType.Keyboard then
                local b = capturing; capturing = nil
                local nm = input.KeyCode.Name
                if nm ~= "Escape" then b.key = "Key:" .. nm; saveKb() end
                if b.refresh then b.refresh() end
            elseif _isMouseBtn(input) and input.UserInputType ~= Enum.UserInputType.MouseButton1 then
                local b = capturing; capturing = nil
                b.key = "Mouse:" .. input.UserInputType.Name; saveKb()
                if b.refresh then b.refresh() end
            end
            return
        end
        -- TRIGGER: clavier + souris normale (MB4/MB5 via le poll)
        for _, b in ipairs(binds) do
            if not (_bindIsSide(b.key, 4) or _bindIsSide(b.key, 5)) and _inputMatches(input, b.key) then
                -- TT3: le reset doit marcher MEME pendant un steal ou avec une UI
                -- de jeu ouverte -> seul lui (et le menu) ignore gameProcessed.
                if b.id ~= "menu" and gameProcessed then return end
                b.run()
                return
            end
        end
    end)

    -- POLL des boutons lateraux (rising edge). Gate: cout ~0 tant qu aucun bind
    -- lateral n existe et qu on ne capture pas -> juste des compares de string.
    do
        local prev4, prev5 = false, false
        game:GetService("RunService").Heartbeat:Connect(function()
            local need = capturing ~= nil
            if not need then
                for _, b in ipairs(binds) do
                    if _bindIsSide(b.key, 4) or _bindIsSide(b.key, 5) then need = true; break end
                end
            end
            if not need then prev4, prev5 = false, false; return end
            local d4, d5 = _sideDown(4), _sideDown(5)
            if d4 and not prev4 then _onSide(4) end
            if d5 and not prev5 then _onSide(5) end
            prev4, prev5 = d4, d5
        end)
    end

    -- menu
    pcall(function()
        local old = guiParent:FindFirstChild("CarpetCloneUI")
        if old then old:Destroy() end
    end)
    local sg = Instance.new("ScreenGui")
    sg.Name = "CarpetCloneUI"; sg.ResetOnSpawn = false; sg.DisplayOrder = 129
    pcall(function() sg.Parent = guiParent end)
    if not sg.Parent then sg.Parent = PG end

    local f = Instance.new("Frame", sg)
    f.Size = UDim2.fromOffset(226, 420)
    fitMobilePanel(f, 0.88)
    f.Position = UDim2.fromOffset(panelX, panelY)
    panelFrame = f   -- pour le keybind "Main Menu" (show/hide)
    f.Visible = false   -- FERME par defaut, s ouvre avec la touche Main Menu (LeftControl)

    -- ICONE ENGRENAGE (haut-droite de l ecran): ouvre/ferme le menu Keybind & Actions
    do
        local gearGui = Instance.new("ScreenGui")
        gearGui.Name = "TT3GearIcon"; gearGui.ResetOnSpawn = false
        gearGui.IgnoreGuiInset = true; gearGui.DisplayOrder = 130
        pcall(function() gearGui.Parent = guiParent end)
        if not gearGui.Parent then gearGui.Parent = PG end
        local gear = Instance.new("TextButton", gearGui)
        gear.Size = UDim2.fromOffset(34, 34)
        gear.Position = UDim2.new(1, -44, 0, 10)   -- coin haut-droite
        gear.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        gear.BackgroundTransparency = 0.1
        gear.Text = "\u{2699}"   -- engrenage
        gear.TextColor3 = Color3.fromRGB(235, 235, 240)
        gear.Font = Enum.Font.GothamBold; gear.TextSize = 20
        gear.AutoButtonColor = true; gear.BorderSizePixel = 0
        Instance.new("UICorner", gear).CornerRadius = UDim.new(0, 8)
        local st = Instance.new("UIStroke", gear)
        st.Color = Color3.fromRGB(78, 78, 78); st.Transparency = 0.4; st.Thickness = 1
        gear.MouseButton1Click:Connect(function()
            if panelFrame then panelFrame.Visible = not panelFrame.Visible end
        end)
    end
    f.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    f.BorderSizePixel = 0; f.Active = true; f.Draggable = true
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)
    do local outline = Instance.new("UIStroke", f); outline.Color = Color3.fromRGB(86, 86, 86); outline.Transparency = 0.45; outline.Thickness = 1 end
    do
        local pending = false
        f:GetPropertyChangedSignal("Position"):Connect(function()
            if pending then return end
            pending = true
            task.delay(0.5, function()
                pending = false
                panelX, panelY = f.AbsolutePosition.X, f.AbsolutePosition.Y
                saveKb()
            end)
        end)
    end

    local ttl = Instance.new("TextLabel", f)
    ttl.Size = UDim2.new(1, -20, 0, 30); ttl.Position = UDim2.fromOffset(10, 2)
    ttl.BackgroundTransparency = 1
    ttl.Text = "CONFIGURAÇÕES"; ttl.Font = Enum.Font.GothamBlack
    ttl.TextSize = 12; ttl.TextColor3 = Color3.new(1, 1, 1)
    ttl.TextXAlignment = Enum.TextXAlignment.Left

    local scroll = Instance.new("ScrollingFrame", f)
    scroll.Position = UDim2.fromOffset(6, 34)
    scroll.Size = UDim2.new(1, -12, 1, -40)
    scroll.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    scroll.BackgroundTransparency = 0.18
    scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 3
    scroll.ScrollBarImageColor3 = Color3.fromRGB(120, 120, 120)
    scroll.CanvasSize = UDim2.fromOffset(0, 26 + #binds * 26 + 340)
    Instance.new("UICorner", scroll).CornerRadius = UDim.new(0, 7)

    local keyTitle = Instance.new("TextLabel", scroll)
    keyTitle.BackgroundTransparency = 1; keyTitle.Position = UDim2.fromOffset(10, 2)
    keyTitle.Size = UDim2.fromOffset(190, 20); keyTitle.Font = Enum.Font.GothamBold
    keyTitle.TextSize = 10; keyTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    keyTitle.TextXAlignment = Enum.TextXAlignment.Left; keyTitle.Text = "ATALHOS"

    for i, b in ipairs(binds) do
        local y = 26 + (i - 1) * 26
        local l = Instance.new("TextLabel", scroll)
        l.BackgroundTransparency = 1; l.Position = UDim2.fromOffset(10, y)
        l.Size = UDim2.fromOffset(118, 20)
        l.Font = Enum.Font.Gotham; l.TextSize = 11
        l.TextColor3 = Color3.fromRGB(210, 210, 210)
        l.TextXAlignment = Enum.TextXAlignment.Left
        l.Text = b.label

        local kb = Instance.new("TextButton", scroll)
        kb.Size = UDim2.fromOffset(72, 20); kb.Position = UDim2.fromOffset(132, y)
        kb.TextColor3 = Color3.new(1, 1, 1)
        kb.Font = Enum.Font.GothamBold; kb.TextSize = 11
        kb.BorderSizePixel = 0
        Instance.new("UICorner", kb).CornerRadius = UDim.new(0, 4)

        b.refresh = function()
            kb.Text = _bindPretty(b.key)
            -- vert quand le mode est actif, pour le voir d un coup d oeil
            local on = (b.id == "carpet" and carpetOn) or (b.id == "float" and floatOn)
            kb.BackgroundColor3 = on and Color3.fromRGB(86, 86, 86)
                                     or Color3.fromRGB(58, 58, 58)
        end
        b.refresh()

        kb.MouseButton1Click:Connect(function()
            if capturing and capturing.refresh then capturing.refresh() end
            capturing = b
            kb.Text = "..."
            kb.BackgroundColor3 = Color3.fromRGB(86, 86, 86)
        end)
    end

    ------------------------------------------------------------------
    -- ACTIONS: FOV + X-Ray toggle (FPS Boost retire)
    ------------------------------------------------------------------
    local ay = 26 + #binds * 26 + 24
    local actionTitle = Instance.new("TextLabel", scroll)
    actionTitle.BackgroundTransparency = 1; actionTitle.Position = UDim2.fromOffset(10, ay - 22)
    actionTitle.Size = UDim2.fromOffset(190, 20); actionTitle.Font = Enum.Font.GothamBold
    actionTitle.TextSize = 10; actionTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    actionTitle.TextXAlignment = Enum.TextXAlignment.Left; actionTitle.Text = "DESEMPENHO"

    -- FOV: label + [-] [+] (pilote _G.setFOV / _G.TT3FOV, defini par le bloc FOV)
    do
        local fy = ay
        local l = Instance.new("TextLabel", scroll)
        l.BackgroundTransparency = 1; l.Position = UDim2.fromOffset(10, fy)
        l.Size = UDim2.fromOffset(118, 20)
        l.Font = Enum.Font.Gotham; l.TextSize = 11
        l.TextColor3 = Color3.fromRGB(210, 210, 210)
        l.TextXAlignment = Enum.TextXAlignment.Left
        local function txt() l.Text = "FOV: " .. tostring(math.floor((tonumber(_G.TT3FOV) or 70) + 0.5)) end
        local function mk(px, d, sym)
            local b = Instance.new("TextButton", scroll)
            b.Size = UDim2.fromOffset(24, 20); b.Position = UDim2.fromOffset(px, fy)
            b.BackgroundColor3 = Color3.fromRGB(68, 68, 68); b.TextColor3 = Color3.new(1, 1, 1)
            b.Font = Enum.Font.GothamBold; b.TextSize = 14; b.Text = sym; b.BorderSizePixel = 0
            Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
            b.MouseButton1Click:Connect(function()
                if _G.setFOV then _G.setFOV((tonumber(_G.TT3FOV) or 70) + d * 5) end
                txt(); saveKb()
            end)
        end
        mk(132, -1, "-"); mk(180, 1, "+"); txt()
    end

    -- X-RAY: toggle ON/OFF, intensite fixe a 45% (slider retire).
    do
        local ry = ay + 28
        local xrayBtn = Instance.new("TextButton", scroll)
        xrayBtn.Size = UDim2.fromOffset(194, 24)
        xrayBtn.Position = UDim2.fromOffset(10, ry)
        xrayBtn.Font = Enum.Font.GothamBold
        xrayBtn.TextSize = 11
        xrayBtn.TextColor3 = Color3.new(1, 1, 1)
        xrayBtn.BorderSizePixel = 0
        Instance.new("UICorner", xrayBtn).CornerRadius = UDim.new(0, 5)

        local function refreshXRay()
            local on = _G.XRayEnabled == true
            xrayBtn.Text = on and "X-Ray: ON" or "X-Ray: OFF"
            xrayBtn.BackgroundColor3 = on and Color3.fromRGB(86, 86, 86)
                or Color3.fromRGB(58, 58, 58)
        end
        xrayBtn.MouseButton1Click:Connect(function()
            _G.XRayAlpha = 0.45
            if _G.toggleXRay then pcall(_G.toggleXRay) end
            refreshXRay()
        end)
        refreshXRay()
    end


    -- OTIMIZER: inicia ligado instantaneamente; este botao controla o estado.
    do
        local oy = ay + 60
        local optimizerBtn = Instance.new("TextButton", scroll)
        optimizerBtn.Size = UDim2.fromOffset(194, 24)
        optimizerBtn.Position = UDim2.fromOffset(10, oy)
        optimizerBtn.Font = Enum.Font.GothamBold
        optimizerBtn.TextSize = 11
        optimizerBtn.TextColor3 = Color3.new(1, 1, 1)
        optimizerBtn.BorderSizePixel = 0
        Instance.new("UICorner", optimizerBtn).CornerRadius = UDim.new(0, 5)

        local function refreshOptimizer()
            local on = _G.TT3OptimizerEnabled == true
            optimizerBtn.Text = on and "Otimizer: ON" or "Otimizer: OFF"
            optimizerBtn.BackgroundColor3 = on and Color3.fromRGB(86, 86, 86)
                or Color3.fromRGB(58, 58, 58)
        end
        _G.TT3RefreshOptimizerBtn = refreshOptimizer
        optimizerBtn.MouseButton1Click:Connect(function()
            if _G.TT3ToggleOptimizer then pcall(_G.TT3ToggleOptimizer) end
            refreshOptimizer()
        end)
        refreshOptimizer()
    end

    -- PAINEIS: esconde/mostra cada janela e salva a escolha.
    do
        local py = ay + 96
        local panelTitle = Instance.new("TextLabel", scroll)
        panelTitle.BackgroundTransparency = 1; panelTitle.Position = UDim2.fromOffset(10, py)
        panelTitle.Size = UDim2.fromOffset(190, 20); panelTitle.Font = Enum.Font.GothamBold
        panelTitle.TextSize = 10; panelTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
        panelTitle.TextXAlignment = Enum.TextXAlignment.Left; panelTitle.Text = "PAINEIS"

        local panelButtons = {}
        local defs = {
            {"utilis", "Painel UTILIS"}, {"invis", "Painel INVIS"},
            {"noanim", "Painel NO ANIM"},
            {"stealtarget", "Painel STEAL TARGET"},
        }
        local function refreshPanels()
            for id, data in pairs(panelButtons) do
                local on = _G.TT3PanelVisibility[id] ~= false
                data.Text = data:GetAttribute("Label") .. (on and ": ON" or ": OFF")
                data.BackgroundColor3 = on and Color3.fromRGB(86, 86, 86) or Color3.fromRGB(58, 58, 58)
            end
        end
        for i, def in ipairs(defs) do
            local panelId, panelLabel = def[1], def[2]
            local pb = Instance.new("TextButton", scroll)
            pb.Size = UDim2.fromOffset(194, 24); pb.Position = UDim2.fromOffset(10, py + 22 + (i - 1) * 28)
            pb.Font = Enum.Font.GothamBold; pb.TextSize = 11; pb.TextColor3 = Color3.new(1, 1, 1)
            pb.BorderSizePixel = 0; pb:SetAttribute("Label", panelLabel)
            Instance.new("UICorner", pb).CornerRadius = UDim.new(0, 6)
            panelButtons[panelId] = pb
            pb.MouseButton1Click:Connect(function()
                _G.TT3SetPanelVisible(panelId, _G.TT3PanelVisibility[panelId] == false)
            end)
        end
        _G.TT3RefreshPanelButtons = refreshPanels
        refreshPanels()
    end

    refreshUI = function()
        for _, b in ipairs(binds) do if b.refresh then pcall(b.refresh) end end
    end

end)

if not okCC then warn("[CARPET/CLONE] BLOC EN ERREUR: " .. tostring(errCC)) end
end)

-- ============================================================
-- SCROLL OUT DANS UNE BASE (portage de TT3)
-- Le jeu bride le zoom des qu on entre dans une base: il rabaisse
-- CameraMaxZoomDistance, et le toit "pousse" la camera vers toi via
-- l occlusion PopperCam. On corrige les trois causes a chaque frame:
--   1. CameraMaxZoomDistance remis a 128 -- la valeur PAR DEFAUT de Roblox,
--      pas plus: une valeur exotique se verrait tout de suite.
--   2. CameraMinZoomDistance a 0.5 pour garder la vue premiere personne.
--   3. Occlusion en Invisicam au lieu de Zoom(PopperCam): Invisicam conserve
--      la distance de zoom et se contente de rendre les obstacles
--      transparents, alors que PopperCam rapproche la camera de force.
-- Differe de 5s comme les autres ajouts.
-- ============================================================
stagSpawn(function()
local okZ, errZ = pcall(function()
    local Players    = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local LP         = Players.LocalPlayer

    _G.UnlockZoom = true

    local _zoomLast = 0
    RunService.RenderStepped:Connect(function()
        if not _G.UnlockZoom then return end
        -- PERF: reasserter le zoom toutes les ~0.4s suffit (les reglages ne changent
        -- pas chaque frame). Avant: pcall + 3 lectures de proprietes CHAQUE frame.
        local now = os.clock()
        if now - _zoomLast < 0.4 then return end
        _zoomLast = now
        pcall(function()
            if LP.CameraMaxZoomDistance ~= 128 then
                LP.CameraMaxZoomDistance = 128
            end
            if LP.CameraMinZoomDistance > 0.5 then
                LP.CameraMinZoomDistance = 0.5
            end
            if LP.DevCameraOcclusionMode ~= Enum.DevCameraOcclusionMode.Invisicam then
                LP.DevCameraOcclusionMode = Enum.DevCameraOcclusionMode.Invisicam
            end
        end)
    end)
end)

if not okZ then warn("[ZOOM] BLOC EN ERREUR: " .. tostring(errZ)) end
end)


-- ============================================================
-- AUTO KICK + REJOIN (portage de TT3) + petit GUI
--
-- Auto Kick: des qu un texte de l interface contient "you stole", on quitte
-- le serveur immediatement -> le loot est securise.
-- On surveille TOUS les TextLabel / TextButton / TextBox du PlayerGui, y
-- compris ceux crees plus tard (DescendantAdded) et les ScreenGui ajoutes
-- apres coup (ChildAdded), car la notification de steal est instanciee a la
-- volee. Chaque objet est aussi suivi sur son changement de .Text: le jeu
-- reutilise souvent le meme label au lieu d en creer un nouveau.
--
-- Rejoin: retour sur LE MEME serveur via TeleportToPlaceInstance(JobId).
-- Uniquement des retries, aucun repli public -> on ne peut jamais atterrir
-- sur un autre serveur.
--
-- NON repris de TT3 (demande): grief detector, webhook (__TT3StealEmit),
-- retour en serveur prive (KickToPrivateServer), et le delai de 0.2s qui
-- n existait que pour laisser le webhook partir -> ici le kick est instantane.
--
-- Differe de 5s comme les autres ajouts.
-- ============================================================
stagSpawn(function()
local okAK, errAK = pcall(function()
    local Players         = game:GetService("Players")
    local TeleportService = game:GetService("TeleportService")
    local HS              = game:GetService("HttpService")
    local LP              = Players.LocalPlayer
    local PG              = LP:WaitForChild("PlayerGui")
    local guiParent       = (gethui and gethui()) or game:GetService("CoreGui") or PG

    local cfg = _G.HubCfg.get("autokick")   -- section du fichier partage
    if _G.AutoKickOnSteal == nil then _G.AutoKickOnSteal = true end
    if _G.AutoKickKeyword == nil then _G.AutoKickKeyword = "you stole" end
    -- Kick apres achat Auto Buy: TOUJOURS actif (pas de bouton), reutilise CE meme
    -- auto kick -> serveur prive si un code est renseigne.
    _G.TT3KickAfterBuy = true
    local panelX, panelY = 240, 300
    do
        if type(cfg.on) == "boolean" then _G.AutoKickOnSteal = cfg.on end
        if tonumber(cfg.x) then panelX = tonumber(cfg.x) end
        if tonumber(cfg.y) then panelY = tonumber(cfg.y) end
    end
    local function saveCfg()
        cfg.on = _G.AutoKickOnSteal; cfg.x = panelX; cfg.y = panelY
        _G.HubCfg.save()
    end

    ------------------------------------------------------------------
    -- AUTO KICK
    ------------------------------------------------------------------
    local fired = false
    local function doKick()
        if fired then return end
        fired = true
        pcall(function() game:Shutdown() end)
        pcall(function() LP:Kick("\nAuto Kick") end)
    end
    -- Expose pour l Auto Buy: meme kick.
    _G.TT3DoAutoKick = doKick

    local function check(txt)
        if not _G.AutoKickOnSteal then return end
        if type(txt) ~= "string" or txt == "" then return end
        local kw = tostring(_G.AutoKickKeyword or "you stole")
        if string.find(string.lower(txt), kw, 1, true) then doKick() end
    end

    local hooked = setmetatable({}, { __mode = "k" })
    local function hookObj(obj)
        if hooked[obj] then return end
        hooked[obj] = true
        check(obj.Text)
        obj:GetPropertyChangedSignal("Text"):Connect(function() check(obj.Text) end)
    end

    local function isText(o)
        return o:IsA("TextLabel") or o:IsA("TextButton") or o:IsA("TextBox")
    end

    local function watchRoot(root)
        for _, obj in ipairs(root:GetDescendants()) do
            if isText(obj) then hookObj(obj) end
        end
        root.DescendantAdded:Connect(function(desc)
            if isText(desc) then hookObj(desc) end
        end)
    end

    for _, g in ipairs(PG:GetChildren()) do pcall(watchRoot, g) end
    PG.ChildAdded:Connect(function(g) pcall(watchRoot, g) end)

    ------------------------------------------------------------------
    -- REJOIN (meme serveur)
    ------------------------------------------------------------------
    local function rejoin()
        local jobId = game.JobId
        task.spawn(function()
            if not jobId or jobId == "" then return end
            for _ = 1, 4 do
                local ok = pcall(function()
                    TeleportService:TeleportToPlaceInstance(game.PlaceId, jobId, LP)
                end)
                if ok then break end
                task.wait(1.5)
            end
        end)
    end
    _G.Rejoin = rejoin

    ------------------------------------------------------------------
    -- GUI
    ------------------------------------------------------------------
    pcall(function()
        local old = guiParent:FindFirstChild("AutoKickUI")
        if old then old:Destroy() end
    end)
    local sg = Instance.new("ScreenGui")
    sg.Name = "AutoKickUI"; sg.ResetOnSpawn = false; sg.DisplayOrder = 131
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    if _G.TT3RegisterPanel then _G.TT3RegisterPanel("utilis", sg) end
    pcall(function() sg.Parent = guiParent end)
    if not sg.Parent then sg.Parent = PG end

    local f = Instance.new("Frame", sg)
    f.Size = UDim2.fromOffset(220, 224)
    fitMobilePanel(f, 0.80)
    f.Position = UDim2.fromOffset(panelX, panelY)
    f.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    f.BorderSizePixel = 0; f.Active = true; f.Draggable = true
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)
    do local outline = Instance.new("UIStroke", f); outline.Color = Color3.fromRGB(86, 86, 86); outline.Transparency = 0.45; outline.Thickness = 1 end
    do
        local pending = false
        f:GetPropertyChangedSignal("Position"):Connect(function()
            if pending then return end
            pending = true
            task.delay(0.5, function()
                pending = false
                panelX, panelY = f.AbsolutePosition.X, f.AbsolutePosition.Y
                saveCfg()
            end)
        end)
    end

    local ttl = Instance.new("TextLabel", f)
    ttl.Size = UDim2.new(1, 0, 0, 22); ttl.BackgroundTransparency = 1
    ttl.Text = "UTILITIES"; ttl.Font = Enum.Font.GothamBlack
    ttl.TextSize = 11; ttl.TextColor3 = Color3.new(1, 1, 1)

    local b = Instance.new("TextButton", f)
    b.Size = UDim2.new(1, -16, 0, 24); b.Position = UDim2.fromOffset(8, 24)
    b.Font = Enum.Font.GothamBold; b.TextSize = 11
    b.TextColor3 = Color3.new(1, 1, 1); b.BorderSizePixel = 0
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5)
    local function refresh()
        b.Text = "AUTO KICK" .. (_G.AutoKickOnSteal and ": ON" or ": OFF")
        b.BackgroundColor3 = _G.AutoKickOnSteal and Color3.fromRGB(86, 86, 86)
                                                 or Color3.fromRGB(58, 58, 58)
    end
    b.MouseButton1Click:Connect(function()
        _G.AutoKickOnSteal = not _G.AutoKickOnSteal
        refresh(); saveCfg()
    end)
    refresh()

    -- AUTO STEAL: mirrors the mode already used by the main Flower Hub panel.
    local as = Instance.new("TextButton", f)
    as.Size = UDim2.new(1, -16, 0, 24); as.Position = UDim2.fromOffset(8, 50)
    as.Font = Enum.Font.GothamBold; as.TextSize = 11
    as.TextColor3 = Color3.new(1, 1, 1); as.BorderSizePixel = 0
    Instance.new("UICorner", as).CornerRadius = UDim.new(0, 5)
    local function refreshAutoSteal()
        local active = _G.TT3IsAutoStealEnabled and _G.TT3IsAutoStealEnabled() == true
        as.Text = "AUTO STEAL" .. (active and ": ON" or ": OFF")
        as.BackgroundColor3 = active and Color3.fromRGB(86, 86, 86) or Color3.fromRGB(58, 58, 58)
    end
    as.MouseButton1Click:Connect(function()
        if _G.TT3ToggleAutoSteal then
            pcall(_G.TT3ToggleAutoSteal)
            task.wait(0.05)
            refreshAutoSteal()
        else
            as.Text = "AUTO STEAL INDISPONIVEL"
            task.delay(1.5, refreshAutoSteal)
        end
    end)
    refreshAutoSteal()

    -- AUTO BUY: RoseHub-style one-target purchase, restricted to 17 studs.
    local ab = Instance.new("TextButton", f)
    ab.Size = UDim2.new(1, -16, 0, 24); ab.Position = UDim2.fromOffset(8, 76)
    ab.Font = Enum.Font.GothamBold; ab.TextSize = 11
    ab.TextColor3 = Color3.new(1, 1, 1); ab.BorderSizePixel = 0
    Instance.new("UICorner", ab).CornerRadius = UDim.new(0, 5)
    local function refreshAutoBuy()
        local active = _G.TT3AutoBuy == true
        ab.Text = "AUTO BUY" .. (active and ": ON" or ": OFF")
        ab.BackgroundColor3 = active and Color3.fromRGB(86, 86, 86) or Color3.fromRGB(58, 58, 58)
    end
    ab.MouseButton1Click:Connect(function()
        if _G.TT3ToggleAutoBuy then
            pcall(_G.TT3ToggleAutoBuy)
            task.wait(0.05)
            refreshAutoBuy()
        else
            ab.Text = "AUTO BUY INDISPONIVEL"
            task.delay(1.5, refreshAutoBuy)
        end
    end)
    refreshAutoBuy()
    task.spawn(function()
        while sg.Parent do
            refreshAutoSteal()
            refreshAutoBuy()
            task.wait(0.4)
        end
    end)

    -- AJ SCRIPT: o painel principal fica compacto; o editor abre em uma janela modal.
    local AJ_SCRIPT_FILE = "EXEC_AJ_SCRIPT.txt"
    local savedAJScript = type(cfg.ajScript) == "string" and cfg.ajScript or ""
    if type(readfile) == "function" then
        local okRead, stored = pcall(readfile, AJ_SCRIPT_FILE)
        if okRead and type(stored) == "string" then savedAJScript = stored end
    end

    local function persistAJScript(source)
        savedAJScript = source
        if type(writefile) == "function" then
            local okWrite = pcall(writefile, AJ_SCRIPT_FILE, source)
            if okWrite then return true end
        end
        cfg.ajScript = source
        local okConfig = pcall(saveCfg)
        return okConfig
    end

    local ajOpenButton = Instance.new("TextButton", f)
    ajOpenButton.Size = UDim2.new(1, -16, 0, 24)
    ajOpenButton.Position = UDim2.fromOffset(8, 102)
    ajOpenButton.BackgroundColor3 = Color3.fromRGB(70, 48, 62)
    ajOpenButton.TextColor3 = Color3.fromRGB(255, 150, 205)
    ajOpenButton.Text = "AJ SCRIPT"
    ajOpenButton.Font = Enum.Font.GothamBold
    ajOpenButton.TextSize = 11
    ajOpenButton.BorderSizePixel = 0
    Instance.new("UICorner", ajOpenButton).CornerRadius = UDim.new(0, 5)

    local ajOverlay = Instance.new("Frame", sg)
    ajOverlay.Name = "AJScriptOverlay"
    ajOverlay.Size = UDim2.fromScale(1, 1)
    ajOverlay.Position = UDim2.fromScale(0, 0)
    ajOverlay.BackgroundColor3 = Color3.new(0, 0, 0)
    ajOverlay.BackgroundTransparency = 0.42
    ajOverlay.BorderSizePixel = 0
    ajOverlay.Visible = false
    ajOverlay.Active = true
    ajOverlay.ZIndex = 20

    local camera = workspace.CurrentCamera
    local viewport = camera and camera.ViewportSize or Vector2.new(800, 600)
    local popupWidth = math.max(230, math.min(360, viewport.X - 20))
    local popupHeight = math.max(200, math.min(245, viewport.Y - 20))
    local ajModal = Instance.new("Frame", ajOverlay)
    ajModal.Name = "AJScriptEditor"
    ajModal.AnchorPoint = Vector2.new(0.5, 0.5)
    ajModal.Position = UDim2.fromScale(0.5, 0.5)
    ajModal.Size = UDim2.fromOffset(popupWidth, popupHeight)
    ajModal.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
    ajModal.BorderSizePixel = 0
    ajModal.Active = true
    ajModal.ZIndex = 21
    Instance.new("UICorner", ajModal).CornerRadius = UDim.new(0, 10)
    do
        local outline = Instance.new("UIStroke", ajModal)
        outline.Color = Color3.fromRGB(255, 150, 205)
        outline.Transparency = 0.2
        outline.Thickness = 1
    end

    local ajTitle = Instance.new("TextLabel", ajModal)
    ajTitle.Size = UDim2.new(1, -48, 0, 30)
    ajTitle.Position = UDim2.fromOffset(10, 0)
    ajTitle.BackgroundTransparency = 1
    ajTitle.Text = "AUTO JOINER SCRIPT"
    ajTitle.Font = Enum.Font.GothamBlack
    ajTitle.TextSize = 12
    ajTitle.TextColor3 = Color3.fromRGB(255, 150, 205)
    ajTitle.TextXAlignment = Enum.TextXAlignment.Left
    ajTitle.ZIndex = 22

    local closeAJButton = Instance.new("TextButton", ajModal)
    closeAJButton.Size = UDim2.fromOffset(26, 24)
    closeAJButton.Position = UDim2.new(1, -32, 0, 3)
    closeAJButton.BackgroundColor3 = Color3.fromRGB(48, 40, 45)
    closeAJButton.TextColor3 = Color3.new(1, 1, 1)
    closeAJButton.Text = "X"
    closeAJButton.Font = Enum.Font.GothamBold
    closeAJButton.TextSize = 11
    closeAJButton.BorderSizePixel = 0
    closeAJButton.ZIndex = 23
    Instance.new("UICorner", closeAJButton).CornerRadius = UDim.new(0, 5)

    local ajScriptBox = Instance.new("TextBox", ajModal)
    ajScriptBox.Size = UDim2.new(1, -20, 1, -82)
    ajScriptBox.Position = UDim2.fromOffset(10, 34)
    ajScriptBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    ajScriptBox.TextColor3 = Color3.new(1, 1, 1)
    ajScriptBox.PlaceholderColor3 = Color3.fromRGB(165, 165, 165)
    ajScriptBox.PlaceholderText = "Cole aqui o loadstring do Auto Joiner"
    ajScriptBox.Text = savedAJScript
    ajScriptBox.ClearTextOnFocus = false
    ajScriptBox.MultiLine = true
    ajScriptBox.TextWrapped = false
    ajScriptBox.TextXAlignment = Enum.TextXAlignment.Left
    ajScriptBox.TextYAlignment = Enum.TextYAlignment.Top
    ajScriptBox.Font = Enum.Font.Code
    ajScriptBox.TextSize = 11
    ajScriptBox.BorderSizePixel = 0
    ajScriptBox.ZIndex = 22
    Instance.new("UICorner", ajScriptBox).CornerRadius = UDim.new(0, 6)
    do
        local stroke = Instance.new("UIStroke", ajScriptBox)
        stroke.Color = Color3.fromRGB(86, 86, 86)
        stroke.Transparency = 0.35
    end
    do
        local pad = Instance.new("UIPadding", ajScriptBox)
        pad.PaddingLeft = UDim.new(0, 7)
        pad.PaddingTop = UDim.new(0, 6)
        pad.PaddingRight = UDim.new(0, 7)
    end

    local ajButton = Instance.new("TextButton", ajModal)
    ajButton.Size = UDim2.new(1, -20, 0, 30)
    ajButton.Position = UDim2.new(0, 10, 1, -38)
    ajButton.BackgroundColor3 = Color3.fromRGB(70, 48, 62)
    ajButton.TextColor3 = Color3.fromRGB(255, 150, 205)
    ajButton.Text = "AJ"
    ajButton.Font = Enum.Font.GothamBold
    ajButton.TextSize = 12
    ajButton.BorderSizePixel = 0
    ajButton.ZIndex = 23
    Instance.new("UICorner", ajButton).CornerRadius = UDim.new(0, 6)

    local ajBusy = false
    ajOpenButton.Activated:Connect(function() ajOverlay.Visible = true end)
    closeAJButton.Activated:Connect(function() ajOverlay.Visible = false end)
    ajButton.Activated:Connect(function()
        if ajBusy then return end
        local source = tostring(ajScriptBox.Text or "")
        if not source:match("%S") then source = savedAJScript end
        if type(source) ~= "string" or not source:match("%S") then
            ajButton.Text = "COLE O SCRIPT"
            task.delay(1.5, function() if ajButton.Parent and not ajBusy then ajButton.Text = "AJ" end end)
            return
        end
        if #source > 2000000 then
            ajButton.Text = "LIMITE 2 MB"
            task.delay(1.5, function() if ajButton.Parent and not ajBusy then ajButton.Text = "AJ" end end)
            return
        end
        persistAJScript(source)
        local compiler = loadstring
        if type(compiler) ~= "function" then
            ajButton.Text = "LOADSTRING INDISPONIVEL"
            task.delay(1.5, function() if ajButton.Parent and not ajBusy then ajButton.Text = "AJ" end end)
            return
        end
        ajBusy = true
        ajButton.Text = "EXECUTANDO..."
        task.spawn(function()
            local compileOK, chunk, compileErr = pcall(compiler, source)
            if not compileOK or type(chunk) ~= "function" then
                ajBusy = false
                ajButton.Text = "ERRO NO SCRIPT"
                warn("[Flower Hub AJ] Erro de compilacao: " .. tostring(compileErr or chunk))
                task.delay(1.5, function() if ajButton.Parent and not ajBusy then ajButton.Text = "AJ" end end)
                return
            end
            local runOK, runErr = pcall(chunk)
            ajBusy = false
            if runOK then
                ajButton.Text = "EXECUTADO"
                ajButton.BackgroundColor3 = Color3.fromRGB(86, 60, 76)
            else
                ajButton.Text = "ERRO AO EXECUTAR"
                warn("[Flower Hub AJ] Erro ao executar: " .. tostring(runErr))
            end
            task.delay(1.8, function()
                if ajButton.Parent and not ajBusy then
                    ajButton.Text = "AJ"
                    ajButton.BackgroundColor3 = Color3.fromRGB(70, 48, 62)
                end
            end)
        end)
    end)

    local rb = Instance.new("TextButton", f)
    rb.Size = UDim2.new(1, -16, 0, 24); rb.Position = UDim2.fromOffset(8, 132)
    rb.Font = Enum.Font.GothamBold; rb.TextSize = 11
    rb.TextColor3 = Color3.new(1, 1, 1); rb.BorderSizePixel = 0
    rb.BackgroundColor3 = Color3.fromRGB(58, 58, 58)
    rb.Text = "REJOIN"
    Instance.new("UICorner", rb).CornerRadius = UDim.new(0, 5)
    rb.MouseButton1Click:Connect(function()
        rb.Text = "REJOIN..."
        rejoin()
    end)

    -- KICK MANUEL (visuel): affiche l ecran de kick Roblox avec le message
    -- PAS de game:Shutdown (ca c est l auto kick). Bouton dans CE panneau.
    local kb = Instance.new("TextButton", f)
    kb.Size = UDim2.new(1, -16, 0, 24); kb.Position = UDim2.fromOffset(8, 160)
    kb.Font = Enum.Font.GothamBold; kb.TextSize = 11
    kb.TextColor3 = Color3.fromRGB(220, 70, 70); kb.BorderSizePixel = 0
    kb.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    kb.Text = "KICK"
    Instance.new("UICorner", kb).CornerRadius = UDim.new(0, 5)
    kb.MouseButton1Click:Connect(function()
        pcall(function() LP:Kick("\nTT3") end)
    end)

    local resetButton = Instance.new("TextButton", f)
    resetButton.Size = UDim2.new(1, -16, 0, 24)
    resetButton.Position = UDim2.fromOffset(8, 188)
    resetButton.Font = Enum.Font.GothamBold
    resetButton.TextSize = 11
    resetButton.TextColor3 = Color3.fromRGB(255, 150, 205)
    resetButton.BorderSizePixel = 0
    resetButton.BackgroundColor3 = Color3.fromRGB(45, 38, 44)
    resetButton.Text = "Reset"
    Instance.new("UICorner", resetButton).CornerRadius = UDim.new(0, 5)
    resetButton.Activated:Connect(function()
        local resetFn = _G.TT3InstaReset or _G.TT3NormalReset
        if type(resetFn) ~= "function" then
            resetButton.Text = "Reset indisponível"
            task.delay(1.5, function() if resetButton.Parent then resetButton.Text = "Reset" end end)
            return
        end
        local ok, started = pcall(resetFn)
        if ok and started ~= false then
            resetButton.Text = "Resetando..."
            task.delay(10, function()
                if resetButton.Parent and resetButton.Text == "Resetando..." then resetButton.Text = "Reset" end
            end)
        else
            resetButton.Text = "Falha no Reset - tente novamente"
            task.delay(1.5, function() if resetButton.Parent then resetButton.Text = "Reset" end end)
        end
    end)
    LP.CharacterAdded:Connect(function()
        task.delay(0.5, function() if resetButton.Parent then resetButton.Text = "Reset" end end)
    end)

end)
if not okAK then warn("[AUTOKICK] BLOC EN ERRO: " .. tostring(errAK)) end
end)

-- ============================================================
-- AUTO UNLOCK ON STEAL  (portage de message.txt / TT3)
--
-- Des que tu commences un steal (attribut "Stealing" -> true), on declenche le
-- ProximityPrompt du "Unlock" de l etage ou tu te trouves, sur le plot le plus
-- proche (< 40 studs) -> la porte de la base s ouvre toute seule pendant le vol.
-- Etage 1 si Y < 12, sinon etage 2 (comme message.txt).
-- Auto Unlock desactive par defaut. _G.AutoUnlockOnSteal = true pour activer.
--
-- Differe de 5s comme les autres ajouts.
-- ============================================================
stagSpawn(function()
local okUL, errUL = pcall(function()
    local Players = game:GetService("Players")
    local LP      = Players.LocalPlayer

    _G.AutoUnlockOnSteal = false

    local function getUnlockHRP()
        local c = LP.Character
        if not c then return end
        return c:FindFirstChild("HumanoidRootPart") or c:FindFirstChild("UpperTorso")
    end

    -- ouvre le "Unlock" d indice `number` (trie par hauteur = etage) du plot le
    -- plus proche, en tirant tous ses ProximityPrompt
    local function smartInteract(number)
        local hrp = getUnlockHRP()
        if not hrp then return end
        local plots = workspace:FindFirstChild("Plots")
        if not plots then return end
        local closestPlot, minDistance = nil, 40
        for _, plot in pairs(plots:GetChildren()) do
            local ok, plotPos = pcall(function()
                if plot:IsA("Model") then
                    return plot.PrimaryPart and plot.PrimaryPart.Position or plot:GetPivot().Position
                else
                    return plot.Position
                end
            end)
            if ok and plotPos then
                local dist = (hrp.Position - plotPos).Magnitude
                if dist < minDistance then
                    closestPlot = plot; minDistance = dist
                end
            end
        end
        if closestPlot and closestPlot:FindFirstChild("Unlock") then
            local items = {}
            for _, item in pairs(closestPlot.Unlock:GetChildren()) do
                local pos = item:IsA("Model") and item:GetPivot().Position or item.Position
                table.insert(items, { Obj = item, Y = pos.Y })
            end
            table.sort(items, function(a, b) return a.Y < b.Y end)
            if items[number] then
                for _, pr in pairs(items[number].Obj:GetDescendants()) do
                    if pr:IsA("ProximityPrompt") then
                        pcall(function() fireproximityprompt(pr) end)
                    end
                end
            end
        end
    end

    local function getCurrentUnlockFloor()
        local hrp = getUnlockHRP()
        if not hrp then return 1 end
        return (hrp.Position.Y < 12) and 1 or 2
    end

    LP:GetAttributeChangedSignal("Stealing"):Connect(function()
        if not _G.AutoUnlockOnSteal then return end
        if LP:GetAttribute("Stealing") ~= true then return end
        local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local floor = getCurrentUnlockFloor()
        task.spawn(function()
            task.wait(0.1)
            pcall(smartInteract, floor)
        end)
    end)
end)

if not okUL then warn("[AUTOUNLOCK] BLOC EN ERREUR: " .. tostring(errUL)) end
end)

-- ============================================================
-- TIMER ESP + SUBSPACE MINE ESP (portage de TT3)
-- Actifs par defaut, rafraichis toutes les 0.5s.
--
-- Timer ESP: le jeu affiche deja un timer par etage sous forme de
-- BillboardGui contenant un "RemainingTime". On le recopie dans notre
-- propre billboard AlwaysOnTop (donc visible a travers les murs), et
-- UNIQUEMENT pour le premier etage: on garde les timers dont la hauteur
-- est a moins de 4 studs du plus bas de la base, les autres sont retires.
--
-- Subspace Mine ESP: encadre les SubspaceTripmine du dossier ToolsAdds et
-- affiche le proprietaire (extrait du nom de la part).
--
-- Differe de 5s comme les autres ajouts.
-- ============================================================
stagSpawn(function()
local okESP, errESP = pcall(function()

    ------------------------------------------------------------------
    -- SUBSPACE MINE ESP
    ------------------------------------------------------------------
    if _G.SubspaceMineESP == nil then _G.SubspaceMineESP = true end
    local mineData = {}

    local function refreshMineESP()
        local tools = workspace:FindFirstChild("ToolsAdds")
        if not tools then return end
        local current = {}
        for _, obj in ipairs(tools:GetChildren()) do
            if obj:IsA("BasePart") and obj.Name:match("SubspaceTripmine") then
                current[obj] = true
                if not mineData[obj] then
                    local owner = obj.Name:match("SubspaceTripmine(.+)") or "Unknown"
                    local sel = Instance.new("SelectionBox", obj)
                    sel.Color3 = Color3.fromRGB(255, 255, 255)
                    sel.LineThickness = 0.05
                    local bb = Instance.new("BillboardGui", obj)
                    bb.Size = UDim2.new(0, 250, 0, 50)
                    bb.StudsOffset = Vector3.new(0, 2.5, 0)
                    bb.AlwaysOnTop = false
                    local lbl = Instance.new("TextLabel", bb)
                    lbl.Size = UDim2.new(1, 0, 1, 0)
                    lbl.BackgroundTransparency = 1
                    lbl.Text = owner .. "'s Subspace Mine"
                    lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
                    lbl.TextStrokeTransparency = 0
                    lbl.Font = Enum.Font.GothamBold
                    lbl.TextSize = 16
                    mineData[obj] = { sel = sel, bb = bb }
                end
            end
        end
        -- mine disparue -> on nettoie
        for obj, d in pairs(mineData) do
            if not current[obj] or not obj.Parent then
                pcall(function() d.sel:Destroy() end)
                pcall(function() d.bb:Destroy() end)
                mineData[obj] = nil
            end
        end
    end

    local function clearMineESP()
        for obj, d in pairs(mineData) do
            pcall(function() d.sel:Destroy() end)
            pcall(function() d.bb:Destroy() end)
            mineData[obj] = nil
        end
    end

    ------------------------------------------------------------------
    -- TIMER ESP
    ------------------------------------------------------------------
    if _G.TimerESP == nil then _G.TimerESP = true end
    local TIMER_COLOR = Color3.fromRGB(255, 215, 0)   -- jaune

    local function clearTimerESP()
        local plots = workspace:FindFirstChild("Plots")
        if not plots then return end
        for _, plot in ipairs(plots:GetChildren()) do
            for _, desc in ipairs(plot:GetDescendants()) do
                if desc.Name == "TimerESP" and desc:IsA("BillboardGui") then
                    pcall(function() desc:Destroy() end)
                end
            end
        end
    end
    _G.clearTimerESP = clearTimerESP

    local function refreshTimerESP()
        local plots = workspace:FindFirstChild("Plots")
        if not plots then return end
        for _, plot in ipairs(plots:GetChildren()) do
            -- le jeu pose un timer par etage: on releve tous ceux de ce plot
            -- puis on ne garde que les plus bas (= 1er etage)
            local found, minY = {}, math.huge
            for _, g in ipairs(plot:GetDescendants()) do
                if g:IsA("BillboardGui") and g:FindFirstChild("RemainingTime") then
                    local base = g.Adornee or g.Parent
                    if base and base:IsA("BasePart") then
                        found[#found + 1] = { g = g, base = base, y = base.Position.Y }
                        if base.Position.Y < minY then minY = base.Position.Y end
                    end
                end
            end
            for _, item in ipairs(found) do
                local base, g = item.base, item.g
                local existing = base:FindFirstChild("TimerESP")
                if item.y <= minY + 4 then          -- 1er etage uniquement
                    local rt = g:FindFirstChild("RemainingTime")
                    if rt then
                        if not existing then
                            local bb = Instance.new("BillboardGui")
                            bb.Name = "TimerESP"
                            bb.Adornee = base
                            bb.Size = UDim2.new(0, 98, 0, 26)
                            bb.AlwaysOnTop = true      -- visible a travers les murs
                            bb.StudsOffsetWorldSpace = Vector3.new(0, 1.6, 0)
                            local lbl = Instance.new("TextLabel", bb)
                            lbl.Size = UDim2.new(1, 0, 1, 0)
                            lbl.BackgroundTransparency = 1
                            lbl.Text = rt.Text
                            lbl.Font = Enum.Font.GothamBold
                            lbl.TextSize = 15
                            -- jaune + contour noir OPAQUE: en blanc avec un
                            -- contour a 35% le texte se melangeait au decor
                            -- et ressortait gris
                            lbl.TextColor3 = TIMER_COLOR
                            lbl.TextStrokeTransparency = 0
                            lbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                            bb.Parent = base
                        else
                            local l = existing:FindFirstChildOfClass("TextLabel")
                            if l then
                                l.Text = rt.Text
                                -- on reapplique la couleur: les billboards
                                -- crees avant ce changement resteraient blancs
                                if l.TextColor3 ~= TIMER_COLOR then
                                    l.TextColor3 = TIMER_COLOR
                                    l.TextStrokeTransparency = 0
                                end
                            end
                        end
                    end
                elseif existing then
                    pcall(function() existing:Destroy() end)   -- pas le 1er etage
                end
            end
        end
    end

    ------------------------------------------------------------------
    -- BOUCLE COMMUNE
    ------------------------------------------------------------------
    task.spawn(function()
        while true do
            -- PAUSE pendant un TP (anti-freeze) + throttle 6s (ESP non utilises pour l instant)
            if not (_G._isTpMoving or _G.TT3StealHold) then
                if _G.TimerESP then pcall(refreshTimerESP) else pcall(clearTimerESP) end
                if _G.SubspaceMineESP then pcall(refreshMineESP) else pcall(clearMineESP) end
            end
            task.wait(6)
        end
    end)
end)

if not okESP then warn("[ESP] BLOC EN ERREUR: " .. tostring(errESP)) end
end)

-- ============================================================
-- Reset/Fling especiais removidos; o botao e o atalho usam o reset normal do personagem.

-- ============================================================
-- LINE TO BASE (portage de TT3, en BLANC)
-- Un Beam entre ton HumanoidRootPart et le panneau de TA base.
-- Seule difference avec TT3: la couleur, passee de rouge (255,40,40)
-- a blanc pur.
--
-- Detection de ta base: TT3 utilise d abord _G.isMyPlot_Instant (qui
-- n existe pas ici) puis un repli. On garde uniquement le repli: le
-- BillboardGui "YourBase" du PlotSign, sinon le texte du panneau compare
-- a ton pseudo.
--
-- Differe de 5s comme les autres ajouts.
-- ============================================================
stagSpawn(function()
local okLB, errLB = pcall(function()
    local Players    = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local LP         = Players.LocalPlayer

    local BEAM_NAME  = "PlotBeam"
    local ATT0_NAME  = "PlotBeamAttach_Player"
    local ATT1_NAME  = "PlotBeamAttach_Plot"
    local BEAM_COLOR = Color3.fromRGB(255, 255, 255)   -- full white

    if _G.LineToBase == nil then _G.LineToBase = true end

    local plotBeam, plotAtt0, plotAtt1
    -- ANCRAGE PERSISTANT: une part invisible, ancree a la derniere position connue de
    -- ta base. Le beam pointe dessus. Comme c est une instance locale, elle n est PAS
    -- soumise au streaming (contrairement a la part du plot qui se decharge quand tu
    -- t eloignes -> c est ce qui faisait disparaitre la ligne). Conteneur = Folder
    -- persistant (voir _anchorHolder), PAS la CurrentCamera (recreee au respawn).
    local beamAnchor, lastPlotPos
    -- CONTENEUR PERSISTANT: un Folder local dans workspace. Avant, l ancre etait
    -- parentee a workspace.CurrentCamera, MAIS la Camera est DETRUITE et recreee a
    -- chaque respawn/reset -> l ancre partait avec, et c est ce qui faisait
    -- disparaitre la ligne apres un reset. Un Folder local dans workspace survit au
    -- respawn et n est PAS soumis au streaming (instance cote client).
    local function _anchorHolder()
        local h = workspace:FindFirstChild("TT3BeamHolder")
        if not h or not h:IsA("Folder") then
            if h then pcall(function() h:Destroy() end) end
            h = Instance.new("Folder")
            h.Name = "TT3BeamHolder"
            h.Parent = workspace
        end
        return h
    end
    local function ensureAnchor()
        if beamAnchor and beamAnchor.Parent then return beamAnchor end
        if beamAnchor then pcall(function() beamAnchor:Destroy() end) end
        local p = Instance.new("Part")
        p.Name = "PlotBeamAnchor"; p.Anchored = true
        p.CanCollide = false; p.CanQuery = false; p.CanTouch = false
        p.Transparency = 1; p.CastShadow = false; p.Size = Vector3.new(1, 1, 1)
        p.Parent = _anchorHolder()
        beamAnchor = p
        return p
    end

    local function applyStyle(beam)
        if not beam then return end
        beam.FaceCamera    = true
        beam.LightEmission = 1
        beam.Color         = ColorSequence.new(BEAM_COLOR)
        beam.Transparency  = NumberSequence.new(0)   -- full white, opaque
        beam.Width0        = 0.45
        beam.Width1        = 0.45
        beam.TextureMode   = Enum.TextureMode.Wrap
        beam.TextureSpeed  = 0
        beam.Enabled       = true
    end

    local function destroyBeam()
        if plotBeam then pcall(function() plotBeam:Destroy() end) end
        local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local old = hrp:FindFirstChild("PlotBeamGlow")
            if old then pcall(function() old:Destroy() end) end
        end
        if plotAtt0 then pcall(function() plotAtt0:Destroy() end) end
        if plotAtt1 then pcall(function() plotAtt1:Destroy() end) end
        if beamAnchor then pcall(function() beamAnchor:Destroy() end) end
        plotBeam, plotAtt0, plotAtt1, beamAnchor, lastPlotPos = nil, nil, nil, nil, nil
    end

    local _myPlotCache, _myPlotCacheT = nil, 0
    local function _scanMyPlot()
        local plots = workspace:FindFirstChild("Plots")
        if not plots then return nil end
        for _, plot in ipairs(plots:GetChildren()) do
            local sign = plot:FindFirstChild("PlotSign")
            if sign then
                local yb = sign:FindFirstChild("YourBase")
                if yb and yb:IsA("BillboardGui") and yb.Enabled then return plot end
                local sg = sign:FindFirstChildWhichIsA("SurfaceGui", true)
                if sg then
                    local label = sg:FindFirstChildWhichIsA("TextLabel", true)
                    if label and label.Text then
                        local t = label.Text:lower()
                        if t:find(LP.DisplayName:lower(), 1, true)
                           or t:find(LP.Name:lower(), 1, true) then
                            return plot
                        end
                    end
                end
            end
        end
        return nil
    end
    -- CACHE: ta base ne bouge pas -> inutile de refaire le scan recursif ~6x/s
    -- (c etait un cout constant pendant le TP). On re-scanne au max toutes les
    -- 1.5s, ou tout de suite si le plot cache a disparu (respawn/streaming).
    local function findMyPlot()
        if _myPlotCache and _myPlotCache.Parent and (os.clock() - _myPlotCacheT) < 1.5 then
            return _myPlotCache
        end
        _myPlotCache = _scanMyPlot()
        _myPlotCacheT = os.clock()
        return _myPlotCache
    end
    -- Expose pour l Auto Buy (kick uniquement si le brainrot atterrit dans MA base).
    _G.TT3FindMyPlot = findMyPlot

    local function getAnchorPart(plot)
        if not plot then return nil end
        local sign = plot:FindFirstChild("PlotSign")
        if sign then
            if sign:IsA("BasePart") then return sign end
            local part = sign:FindFirstChildWhichIsA("BasePart", true)
            if part then return part end
        end
        local main = plot:FindFirstChild("MainRootPart")
        if main and main:IsA("BasePart") then return main end
        return plot:FindFirstChildWhichIsA("BasePart")
    end

    local function ensureBeam(hrp, plotPos)
        if not hrp or not hrp.Parent or not plotPos then return end
        ensureAnchor()
        beamAnchor.Position = plotPos

        -- attachment cote joueur
        if not plotAtt0 or not plotAtt0.Parent or plotAtt0.Parent ~= hrp then
            if plotAtt0 then pcall(function() plotAtt0:Destroy() end) end
            plotAtt0 = Instance.new("Attachment")
            plotAtt0.Name = ATT0_NAME
            plotAtt0.Parent = hrp
        end

        -- attachment cote base, sur l ANCHOR persistant (pas la part du plot)
        if not plotAtt1 or not plotAtt1.Parent or plotAtt1.Parent ~= beamAnchor then
            if plotAtt1 then pcall(function() plotAtt1:Destroy() end) end
            plotAtt1 = Instance.new("Attachment")
            plotAtt1.Name = ATT1_NAME
            plotAtt1.Position = Vector3.new(0, 4, 0)
            plotAtt1.Parent = beamAnchor
        end

        if not plotBeam or not plotBeam.Parent then
            if plotBeam then pcall(function() plotBeam:Destroy() end) end
            local oldGlow = hrp:FindFirstChild("PlotBeamGlow")
            if oldGlow then pcall(function() oldGlow:Destroy() end) end
            plotBeam = Instance.new("Beam")
            plotBeam.Name = BEAM_NAME
            applyStyle(plotBeam)
            plotBeam.Parent = hrp
        end
        plotBeam.Attachment0 = plotAtt0
        plotBeam.Attachment1 = plotAtt1
    end

    -- REPARATION CHAQUE frame: ensureBeam recree att/beam des qu ils ont saute
    -- (toggle invis -> le clone qui portait le beam est detruit au revert, respawn,
    -- blip de streaming...). Seul le SCAN de la base est throttle (findMyPlot cache
    -- deja a 1.5s) -> ligne PERMANENTE au lieu de "parfois la, parfois pas", cout
    -- negligeable (ensureBeam ne fait que verifier des refs existantes).
    local check = 10   -- scan des la 1re frame (ligne visible tout de suite)
    RunService.Heartbeat:Connect(function()
        if not _G.LineToBase then
            if plotBeam or plotAtt0 or plotAtt1 or beamAnchor then destroyBeam() end
            return
        end

        local char = LP.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then
            -- respawn: on lache juste le beam + l attachment joueur, mais on
            -- GARDE l anchor + la derniere position connue de la base
            if plotBeam then pcall(function() plotBeam:Destroy() end); plotBeam = nil end
            if plotAtt0 then pcall(function() plotAtt0:Destroy() end); plotAtt0 = nil end
            return
        end

        -- SCAN throttle (~1 frame sur 10): rafraichit la position connue de ta base
        -- si elle est streamee la. findMyPlot a deja son propre cache 1.5s.
        check = check + 1
        if check >= 10 then
            check = 0
            local myPlot = findMyPlot()
            if myPlot then
                local plotPart = getAnchorPart(myPlot)
                if plotPart and plotPart.Parent then
                    lastPlotPos = plotPart.Position
                end
            end
        end

        -- CHAQUE frame: des qu on a une position connue, on (re)pose la ligne dessus
        -- MEME si la base est dechargee (streaming) ou si le beam a ete detruit par un
        -- toggle invis / respawn -> auto-heal instantane, plus de disparition.
        if lastPlotPos then
            pcall(ensureBeam, hrp, lastPlotPos)
        end
    end)

    -- RESET / RESPAWN: au nouveau character, le beam + l attachment cote joueur ont
    -- ete detruits avec l ancien HRP. On lache leurs refs et on force un rescan
    -- immediat (check=10) -> la ligne se reforme des la 1re frame, a CHAQUE reset,
    -- sans dependre du timing de l auto-heal. L ancre + lastPlotPos sont conserves.
    LP.CharacterAdded:Connect(function()
        plotBeam, plotAtt0 = nil, nil
        check = 10
    end)

    _G.toggleLineToBase = function(on)
        _G.LineToBase = (on == nil) and (not _G.LineToBase) or (on and true or false)
        if not _G.LineToBase then destroyBeam() end
    end
end)

if not okLB then warn("[LINETOBASE] BLOC EN ERREUR: " .. tostring(errLB)) end
end)

-- ============================================================
-- ANTI BEE & DISCO  --  portage COMPLET de message.txt (SharedState.ANTI_BEE_DISCO)
--
-- Repris tel quel de message.txt:
--   * nuke par NOM des mauvais objets de Lighting
--     (Blue / DiscoEffect / BeeBlur / ColorCorrection)
--   * protectControls: l abeille remplace Controls.moveFunction pour bloquer
--     ton deplacement -> on repose notre fonction a chaque frame (sauf TP)
--   * blockBuzzingSound: coupe le son "Buzzing" de l abeille (chaque frame)
--   * Enable / Disable + _G.ANTI_BEE_DISCO expose (comme message.txt)
--
-- CONSERVE de l ancien bloc extras (demande): le "tueur de post-effets par
-- CLASSE" (Blur / Bloom / SunRays / ColorCorrection / DepthOfField), fusionne
-- dans nuke() -> supprime aussi les post-effets que le filtre par nom rate.
--
-- Adaptations: pas de Config ni de ShowNotification (console muette). L etat
-- vit dans _G.EffetsRemover (defaut true = actif au lancement, =false pour
-- couper). _G.setEffetsRemover(on) garde pour compat avec l ancien bloc.
--
-- Differe de 5s comme les autres ajouts.
-- ============================================================
nowSpawn(function()
local okER, errER = pcall(function()
    local Players     = game:GetService("Players")
    local RunService  = game:GetService("RunService")
    local Lighting    = game:GetService("Lighting")
    local LocalPlayer = Players.LocalPlayer

    if _G.EffetsRemover == nil then _G.EffetsRemover = true end

    -- structure reprise de SharedState.ANTI_BEE_DISCO (message.txt)
    local AB = {
        running              = false,
        connections          = {},
        originalMoveFunction = nil,
        controlsProtected    = false,
        -- anti-bee & disco par NOM (message.txt)
        badLightingNames = { Blue = true, DiscoEffect = true, BeeBlur = true, ColorCorrection = true },
        -- effets remover par CLASSE (conserve de l ancien bloc extras)
        killClasses = {
            BlurEffect            = true,
            BloomEffect           = true,
            SunRaysEffect         = true,
            ColorCorrectionEffect = true,
            DepthOfFieldEffect    = true,
        },
    }

    -- nuke:
    --   * par NOM (bee/disco griefeurs) -> on DETRUIT: le jeu ne les gere pas.
    --   * par CLASSE (post-effets) -> on DESACTIVE (Enabled=false) au lieu de
    --     detruire. Certains post-effets sont geres par les scripts du jeu
    --     (ex: Lighting.SunRays lu chaque frame par CycleController). Les
    --     DETRUIRE cassait ces scripts -> spam "SunRays is not a valid member
    --     of Lighting". Desactives, ils restent des instances valides mais
    --     n affichent plus rien.
    AB.nuke = function(obj)
        if not obj or not obj.Parent then return end
        if AB.badLightingNames[obj.Name] then
            pcall(function() obj:Destroy() end)
            return
        end
        if AB.killClasses[obj.ClassName] then
            pcall(function() obj.Enabled = false end)
        end
    end

    AB.disconnectAll = function()
        for _, conn in ipairs(AB.connections) do
            if typeof(conn) == "RBXScriptConnection" then conn:Disconnect() end
        end
        AB.connections = {}
    end

    -- l abeille remplace Controls.moveFunction pour te bloquer: on repose la
    -- notre a chaque frame (sauf pendant un TP, sinon on casse le trajet)
    AB.protectControls = function()
        if AB.controlsProtected then return end
        -- BUG CORRIGE: au demarrage (nowSpawn) le PlayerModule n est PAS encore
        -- charge. L ancien FindFirstChild renvoyait nil -> "if not PlayerModule then
        -- return" -> la protection ne s installait JAMAIS -> l inversion des touches
        -- (bee) n etait jamais contree. On ATTEND le module (WaitForChild) et on
        -- retente l acquisition des Controls jusqu a l avoir (au lancement = propre).
        task.spawn(function()
            local ps = LocalPlayer:WaitForChild("PlayerScripts", 60)
            local pm = ps and ps:WaitForChild("PlayerModule", 60)
            if not pm then return end
            local Controls
            for _ = 1, 300 do
                local ok, c = pcall(function() return require(pm):GetControls() end)
                if ok and c and type(c.moveFunction) == "function" then Controls = c break end
                task.wait(0.1)
            end
            if not Controls or AB.controlsProtected then return end
            -- capture la VRAIE moveFunction (propre au lancement, avant tout bee).
            if not AB.originalMoveFunction then AB.originalMoveFunction = Controls.moveFunction end
            local function protectedMoveFunction(self, moveVector, relativeToCamera)
                if AB.originalMoveFunction then AB.originalMoveFunction(self, moveVector, relativeToCamera) end
            end
            -- re-force NOTRE moveFunction chaque frame -> annule tout remplacement
            -- (bee = inversion du deplacement). Jamais pendant un TP.
            table.insert(AB.connections, RunService.Heartbeat:Connect(function()
                if not AB.running or not _G.EffetsRemover then return end
                if _G._isTpMoving then return end
                if Controls.moveFunction ~= protectedMoveFunction then
                    Controls.moveFunction = protectedMoveFunction
                end
            end))
            Controls.moveFunction = protectedMoveFunction
            AB.controlsProtected = true
        end)
    end

    AB.restoreControls = function()
        if not AB.controlsProtected then return end
        pcall(function()
            local PlayerScripts = LocalPlayer:FindFirstChild("PlayerScripts")
            local PlayerModule = PlayerScripts and PlayerScripts:FindFirstChild("PlayerModule")
            if not PlayerModule then return end
            local Controls = require(PlayerModule):GetControls()
            if Controls and AB.originalMoveFunction then
                Controls.moveFunction = AB.originalMoveFunction
                AB.controlsProtected = false
            end
        end)
    end

    AB.blockBuzzingSound = function()
        pcall(function()
            local PlayerScripts = LocalPlayer:FindFirstChild("PlayerScripts")
            local beeScript = PlayerScripts and PlayerScripts:FindFirstChild("Bee", true)
            if beeScript then
                local buzzing = beeScript:FindFirstChild("Buzzing")
                if buzzing and buzzing:IsA("Sound") then
                    buzzing:Stop()
                    buzzing.Volume = 0
                end
            end
        end)
    end

    AB.Enable = function()
        if AB.running then return end
        AB.running = true
        _G.EffetsRemover = true
        -- 1er passage: on nettoie tout Lighting (par classe + par nom)
        for _, inst in ipairs(Lighting:GetDescendants()) do AB.nuke(inst) end
        -- tout nouvel effet ajoute a Lighting est tue a la volee
        table.insert(AB.connections, Lighting.DescendantAdded:Connect(function(obj)
            if not AB.running or not _G.EffetsRemover then return end
            AB.nuke(obj)
        end))
        AB.protectControls()
        -- coupe le buzz a chaque frame (comme message.txt)
        table.insert(AB.connections, RunService.Heartbeat:Connect(function()
            if not AB.running or not _G.EffetsRemover then return end
            AB.blockBuzzingSound()
        end))
    end

    AB.Disable = function()
        if not AB.running then return end
        AB.running = false
        _G.EffetsRemover = false
        AB.restoreControls()
        AB.disconnectAll()
    end

    _G.ANTI_BEE_DISCO = AB
    -- compat avec l ancien bloc: _G.setEffetsRemover(true/false)
    _G.setEffetsRemover = function(on)
        if on then AB.Enable() else AB.Disable() end
    end

    -- actif par defaut (comportement extras)
    if _G.EffetsRemover then AB.Enable() end
end)

if not okER then warn("[ANTIBEEDISCO] BLOC EN ERREUR: " .. tostring(errER)) end
end)

-- ============================================================
-- ACTIONS  --  nouveau panneau + GESTION DU FOV (portage de message.txt)
--
-- FOV: on force le champ de vision de la camera a la valeur choisie a CHAQUE
-- frame (RenderStepped). Le jeu remet souvent le FOV a sa valeur par defaut
-- (zoom, entree de base, effets divers): l enforcement continu garantit que
-- "c est toujours la meme" -- ta valeur ne bouge plus.
--   Reglable de 50 a 120 (defaut 70). Slider + boutons [-]/[+].
--   Persiste dans TT3Hub.json, section "actions".
--   _G.TT3FOV = valeur courante   |  _G.setFOV(v) pour la changer a chaud
--   _G.TT3FOVEnabled = false       pour couper l enforcement.
--
-- Differe de 5s comme les autres ajouts.
-- ============================================================
nowSpawn(function()
local okAC, errAC = pcall(function()
    local Players    = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local UIS        = game:GetService("UserInputService")
    local LP         = Players.LocalPlayer
    local PG         = LP:WaitForChild("PlayerGui")
    local guiParent  = (gethui and gethui()) or game:GetService("CoreGui") or PG

    ------------------------------------------------------------------
    -- CONFIG (section "actions" du fichier partage TT3Hub.json)
    ------------------------------------------------------------------
    local MINV, MAXV, DEFV = 50, 120, 70
    local cfg = _G.HubCfg.get("actions")
    if _G.TT3FOV        == nil then _G.TT3FOV        = DEFV end
    if _G.TT3FOVEnabled == nil then _G.TT3FOVEnabled = true end
    local panelX, panelY = 240, 470
    do
        if tonumber(cfg.fov) then _G.TT3FOV = math.clamp(tonumber(cfg.fov), MINV, MAXV) end
        if tonumber(cfg.x)   then panelX = tonumber(cfg.x) end
        if tonumber(cfg.y)   then panelY = tonumber(cfg.y) end
    end
    local function saveCfg()
        cfg.fov = _G.TT3FOV
        cfg.x = panelX; cfg.y = panelY
        _G.HubCfg.save()
    end

    ------------------------------------------------------------------
    -- FOV: valeur + enforcement continu (le coeur du systeme message.txt)
    ------------------------------------------------------------------
    local function setFOVValue(v)
        v = math.clamp(math.floor((tonumber(v) or DEFV) + 0.5), MINV, MAXV)
        _G.TT3FOV = v
        pcall(function() cfg.fov = v; _G.HubCfg.save() end)   -- PERSISTE le FOV (ne se sauvait jamais)
        return v
    end
    _G.setFOV = setFOVValue
    setFOVValue(_G.TT3FOV)

    -- on ecrase le FOV a chaque frame -> le jeu ne peut plus le reprendre
    RunService.RenderStepped:Connect(function()
        if not _G.TT3FOVEnabled then return end
        local cam = workspace.CurrentCamera
        if cam then
            local target = tonumber(_G.TT3FOV) or DEFV
            if math.abs(cam.FieldOfView - target) > 0.01 then
                cam.FieldOfView = target
            end
        end
    end)

    -- GUI ACTIONS (FOV) DEPLACE dans le panneau "Keybind & Actions" (fusion)
end)

if not okAC then warn("[ACTIONS] BLOC EN ERREUR: " .. tostring(errAC)) end
end)

-- ============================================================
-- ============================================================
-- PLAYER ESP (nom/outils seulement). Les anciennes etiquettes Stealing...
-- et le Base Owner rouge sont retires; le statut unique est gere par le TP.
-- ============================================================
stagSpawn(function()
local okESP2, errESP2 = pcall(function()
    local Players = game:GetService("Players")
    local LP = Players.LocalPlayer
    local guiParent = (gethui and gethui()) or game:GetService("CoreGui")
    local cfg = _G.HubCfg.get("esp")
    if _G.TT3PlayerESP == nil then _G.TT3PlayerESP = true end
    if type(cfg.player) == "boolean" then _G.TT3PlayerESP = cfg.player end
    _G.TT3BaseOwnerESP = false
    cfg.owner = false

    local function saveCfg()
        cfg.player = _G.TT3PlayerESP
        cfg.owner = false
        _G.HubCfg.save()
    end
    local function clearOldOwnerTags()
        pcall(function()
            for _, obj in ipairs(guiParent:GetDescendants()) do
                if (obj:IsA("BillboardGui") and obj.Name == "BaseOwnerTag")
                    or (obj:IsA("Highlight") and obj.Name == "BaseOwnerESP") then
                    obj:Destroy()
                end
            end
        end)
    end
    local function clearOldPlayerTags()
        for _, plr in ipairs(Players:GetPlayers()) do
            local char = plr.Character
            if char then
                for _, obj in ipairs(char:GetDescendants()) do
                    if obj:IsA("BillboardGui") and obj.Name:match("^PlayerESP_") then
                        pcall(function() obj:Destroy() end)
                    end
                end
            end
        end
    end
    clearOldOwnerTags()
    clearOldPlayerTags()

    local playerBillboards = {}
    local DANGER_TOOLS = { ["Boogie Bomb"]=true, ["Medusa's Head"]=true, ["Body Swap Potion"]=true,
        ["Laser Cape"]=true, ["Rainbowrath Sword"]=true, ["Gummy Bear"]=true }
    local function getHeldTool(plr)
        local char = plr.Character
        if not char then return nil end
        for _, obj in ipairs(char:GetChildren()) do
            if obj:IsA("Tool") then return obj.Name end
        end
        return nil
    end
    local function makePlayerBillboard(plr)
        local bb = Instance.new("BillboardGui")
        bb.Name = "PlayerESP_" .. tostring(plr.UserId)
        bb.Size = UDim2.new(0, 170, 0, 32)
        bb.StudsOffsetWorldSpace = Vector3.new(0, 2.8, 0)
        bb.AlwaysOnTop = true
        bb.LightInfluence = 0
        bb.ResetOnSpawn = false
        local nameLbl = Instance.new("TextLabel", bb)
        nameLbl.Size = UDim2.new(1, 0, 0, 18)
        nameLbl.BackgroundTransparency = 1
        nameLbl.Font = Enum.Font.GothamBold
        nameLbl.TextSize = 14
        nameLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
        nameLbl.TextStrokeTransparency = 0.4
        nameLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        nameLbl.Text = plr.Name
        local toolLbl = Instance.new("TextLabel", bb)
        toolLbl.Name = "ToolLabel"
        toolLbl.Size = UDim2.new(1, 0, 0, 13)
        toolLbl.Position = UDim2.new(0, 0, 0, 18)
        toolLbl.BackgroundTransparency = 1
        toolLbl.Font = Enum.Font.GothamMedium
        toolLbl.TextSize = 11
        toolLbl.TextColor3 = Color3.fromRGB(100, 220, 255)
        toolLbl.TextStrokeTransparency = 0.4
        toolLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        toolLbl.Text = getHeldTool(plr) or ""
        return bb, nameLbl
    end
    local function createOrRefreshPlayerESP(plr)
        if plr == LP then return end
        local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local hum = plr.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None end
        local uid = plr.UserId
        local entry = playerBillboards[uid]
        if not entry or not entry.bb or not entry.bb.Parent then
            if entry and entry.bb then pcall(function() entry.bb:Destroy() end) end
            local bb, nameLbl = makePlayerBillboard(plr)
            bb.Adornee = hrp
            bb.Parent = hrp
            playerBillboards[uid] = {bb = bb, nameLbl = nameLbl, player = plr}
        elseif entry.bb.Adornee ~= hrp then
            entry.bb.Adornee = hrp
            entry.bb.Parent = hrp
        end
    end
    local function clearPlayerESP()
        for uid, entry in pairs(playerBillboards) do
            if entry.bb then pcall(function() entry.bb:Destroy() end) end
            playerBillboards[uid] = nil
        end
    end
    _G.setPlayerESP = function(on)
        _G.TT3PlayerESP = on and true or false
        if not _G.TT3PlayerESP then clearPlayerESP() end
        saveCfg()
    end
    -- Compatibilidade: o Base Owner vermelho foi removido permanentemente.
    _G.setBaseOwnerESP = function(_)
        _G.TT3BaseOwnerESP = false
        clearOldOwnerTags()
        saveCfg()
    end
    _G.clearBaseOwnerESP = clearOldOwnerTags

    task.spawn(function()
        while true do
            task.wait(6)
            if _G._isTpMoving or _G.TT3StealHold then continue end
            if _G.TT3PlayerESP then
                for _, plr in ipairs(Players:GetPlayers()) do
                    if plr ~= LP then pcall(createOrRefreshPlayerESP, plr) end
                end
                for _, entry in pairs(playerBillboards) do
                    if entry.bb and entry.bb.Parent then
                        pcall(function()
                            local toolLbl = entry.bb:FindFirstChild("ToolLabel")
                            local heldTool = getHeldTool(entry.player)
                            if toolLbl then toolLbl.Text = heldTool or "" end
                            if entry.nameLbl then
                                entry.nameLbl.TextColor3 = (heldTool and DANGER_TOOLS[heldTool])
                                    and Color3.fromRGB(255, 60, 60) or Color3.fromRGB(255, 255, 255)
                            end
                        end)
                    end
                end
            else
                clearPlayerESP()
            end
        end
    end)
end)
if not okESP2 then warn("[ESP2] BLOC EN ERREUR: " .. tostring(errESP2)) end
end)

-- ============================================================
-- BASE TIMER HUD  --  le timer de la base ou TU te trouves, en haut de l ecran
-- Le jeu pose un BillboardGui "RemainingTime" par etage sur chaque plot (le
-- meme que lit le Timer ESP). Ici on prend la base la PLUS PROCHE de toi
-- (celle ou tu es), on lit le timer de son 1er etage (billboard le plus bas)
-- et on l affiche dans un cadre centre en haut, style watermark (dark theme).
-- Cache automatiquement quand tu n es sur aucune base. Pause pendant les TP.
-- ============================================================
stagSpawn(function()
    local okBT, errBT = pcall(function()
    local Players   = game:GetService("Players")
    local Workspace = game:GetService("Workspace")
    local LP        = Players.LocalPlayer
    local PG        = LP:WaitForChild("PlayerGui")

    local gui = Instance.new("ScreenGui")
    gui.Name = "TT3BaseTimer"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    gui.DisplayOrder = 999998
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(gui) end end)
    gui.Parent = PG

    local frame = Instance.new("Frame")
    frame.AnchorPoint = Vector2.new(0.5, 0)
    frame.Position = UDim2.new(0.5, 0, 0, 54)   -- juste sous le watermark FPS/PING
    frame.Size = UDim2.new(0, 120, 0, 52)
    frame.BackgroundTransparency = 1
    frame.BorderSizePixel = 0
    frame.Visible = false
    frame.Parent = gui

    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, 0, 1, 0)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 38
    label.TextColor3 = Color3.fromRGB(200, 200, 210)
    label.TextStrokeTransparency = 0.5
    label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    label.TextXAlignment = Enum.TextXAlignment.Center
    label.Text = "--"
    label.Parent = frame

    -- base (plot) la plus proche de toi, dans un rayon de 80 studs (= celle ou tu es)
    local function nearestPlot(pos)
        local plots = Workspace:FindFirstChild("Plots")
        if not plots then return nil end
        local best, bestD = nil, 80 * 80
        for _, plot in ipairs(plots:GetChildren()) do
            local pp
            if plot:IsA("Model") then
                pp = plot.PrimaryPart and plot.PrimaryPart.Position or plot:GetPivot().Position
            elseif plot:IsA("BasePart") then
                pp = plot.Position
            end
            if pp then
                local dx, dz = pos.X - pp.X, pos.Z - pp.Z
                local d2 = dx * dx + dz * dz
                if d2 < bestD then bestD = d2; best = plot end
            end
        end
        return best
    end

    -- timer du 1er etage (le billboard RemainingTime le plus BAS) d un plot
    local function plotTimerText(plot)
        local bestY, bestTxt = math.huge, nil
        for _, g in ipairs(plot:GetDescendants()) do
            if g:IsA("BillboardGui") then
                local rt = g:FindFirstChild("RemainingTime")
                if rt then
                    local base = g.Adornee or g.Parent
                    local y = (base and base:IsA("BasePart")) and base.Position.Y or math.huge
                    if y < bestY then bestY = y; bestTxt = rt.Text end
                end
            end
        end
        return bestTxt
    end

    task.spawn(function()
        while gui.Parent do
            task.wait(0.5)
            -- pause pendant un TP scripte (moment critique pour les FPS)
            if not _G._isTpMoving then
                local char = LP.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                local plot = hrp and nearestPlot(hrp.Position)
                local txt = plot and plotTimerText(plot)
                if txt and txt ~= "" then
                    if label.Text ~= txt then label.Text = txt end
                    if not frame.Visible then frame.Visible = true end
                elseif frame.Visible then
                    frame.Visible = false
                end
            end
        end
    end)
    end)
    if not okBT then warn("[BASE TIMER] BLOC EN ERREUR: " .. tostring(errBT)) end
end)

-- ============================================================
-- ANTI-DIE  (deplace depuis invisible.txt)
-- Le TP arrive a la base en chute/velocity -> fall damage / ragdoll -> mort.
-- On desactive les states mortels ET on revive en boucle. Toujours actif.
-- Le reset natif met _G.AntiDieDisabled a true temporairement pour laisser
-- Humanoid.Health=0 traverser cette protection jusqu au respawn.
-- ============================================================
if _G.AntiDieDisabled == nil then _G.AntiDieDisabled = false end
nowSpawn(function()
local okAD, errAD = pcall(function()
    local Players    = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local LP         = Players.LocalPlayer

    local _conn, _diedConn, _hbConn
    local function _harden(hum)
        pcall(function() hum.BreakJointsOnDeath = false end)
        pcall(function() hum.RequiresNeck = false end)
        pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false) end)
        pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false) end)
        pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false) end)
        pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.Physics, false) end)
    end
    local function _revive(hum)
        pcall(function() hum.Health = hum.MaxHealth end)
        pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
    end
    local function _bind()
        local char = LP.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        _harden(hum)
        if _conn then pcall(function() _conn:Disconnect() end) end
        if _diedConn then pcall(function() _diedConn:Disconnect() end) end
        if _hbConn then pcall(function() _hbConn:Disconnect() end) end
        _conn = hum:GetPropertyChangedSignal("Health"):Connect(function()
            if _G.AntiDieDisabled then return end
            if hum.Health <= 0 then _revive(hum) end
        end)
        _diedConn = hum.Died:Connect(function()
            if _G.AntiDieDisabled then return end
            _revive(hum)
        end)
        local _lastHarden = 0
        _hbConn = RunService.Heartbeat:Connect(function()
            if _G.AntiDieDisabled or not hum or not hum.Parent then return end
            local now = os.clock()
            if now - _lastHarden >= 0.5 then _lastHarden = now; _harden(hum) end
            if hum.Health <= 0 then _revive(hum) end
            -- pendant un TP on verrouille la vie au max (preventif, pas curatif)
            if _G.TT3TPHealLock and hum.Health < hum.MaxHealth then
                pcall(function() hum.Health = hum.MaxHealth end)
            end
            local state = hum:GetState()
            if state == Enum.HumanoidStateType.Dead or state == Enum.HumanoidStateType.Ragdoll
               or state == Enum.HumanoidStateType.FallingDown then
                pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
            end
        end)
    end
    _bind()
    LP.CharacterAdded:Connect(function(char)
        local hum = char:WaitForChild("Humanoid", 5)
        if hum then _harden(hum) end
        task.wait(0.1)
        _bind()
    end)
end)
if not okAD then warn("[ANTI-DIE] BLOC EN ERREUR: " .. tostring(errAD)) end
end)

-- ============================================================
-- DROP BRAINROT (walk-fling, porte 1:1 de TT3.lua) + KICK (self)
-- Drop Brainrot: fling velocity bref -> le brainrot porte se detache.
-- Kick: game:Shutdown() + LP:Kick("") -> quitte le serveur instantanement.
-- Exposes en globals, appeles par les keybinds G (drop) et Y (kick).
-- ============================================================
stagSpawn(function()
local okDK, errDK = pcall(function()
    local Players    = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local LP         = Players.LocalPlayer

    local _wfConns, _wfActive = {}, false
    local function stopWalkFling()
        _wfActive = false
        for _, c in ipairs(_wfConns) do
            if typeof(c) == "RBXScriptConnection" then c:Disconnect() end
        end
        _wfConns = {}
    end
    local function startWalkFling()
        _wfActive = true
        local ch = LP.Character; if not ch then return end
        local rr = ch:FindFirstChild("HumanoidRootPart")
        -- pendant l invisible steal le vrai root est planque dans la camera
        for _, o in pairs(workspace.CurrentCamera:GetChildren()) do
            if o.Name == "HumanoidRootPart" then rr = o; break end
        end
        if not rr then return end
        table.insert(_wfConns, RunService.Stepped:Connect(function()
            if not _wfActive then return end
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LP and p.Character then
                    for _, pt in ipairs(p.Character:GetChildren()) do
                        if pt:IsA("BasePart") then pt.CanCollide = false end
                    end
                end
            end
        end))
        local co = coroutine.create(function()
            if _G.invisibleStealEnabled then rr.CFrame = rr.CFrame * CFrame.new(0, 3, 0) end
            while _wfActive do
                RunService.Heartbeat:Wait(); if not rr or not rr.Parent then break end
                local v = rr.Velocity; rr.Velocity = v * 10000 + Vector3.new(0, 10000, 0)
                RunService.RenderStepped:Wait(); if rr then rr.Velocity = v end
                RunService.Stepped:Wait(); if rr then rr.Velocity = v + Vector3.new(0, 0.1, 0) end
            end
        end)
        coroutine.resume(co); table.insert(_wfConns, co)
    end

    _G.TT3DropBrainrot = function()
        if _wfActive then return end
        startWalkFling()
        task.delay(0.4, stopWalkFling)
    end

    _G.TT3Kick = function()
        pcall(function() game:Shutdown() end)
        pcall(function() LP:Kick("") end)
    end
end)
if not okDK then warn("[DROP/KICK] BLOC EN ERREUR: " .. tostring(errDK)) end
end)


-- ============================================================
-- (Config, setToggle, ShowNotification, Workspace, LocalPlayer, SharedState,
-- LPH_NO_VIRTUALIZE macro Luraph -> identite, kickPlayer, CarpetState...).
-- Vole via BodyPosition vers le brainrot "Purchase" le plus proche a portee
-- (_G.TT3AutoBuyRange) et l achete en boucle (rate-limite = pas de flood/kick).
-- Toggle: _G.TT3ToggleAutoBuy / keybind "K" (Keybind & Actions). OFF par defaut.
-- ============================================================
stagSpawn(function()
local okAB, errAB = pcall(function()
    local Players            = game:GetService("Players")
    local RunService         = game:GetService("RunService")
    local ReplicatedStorage  = game:GetService("ReplicatedStorage")
    local Workspace          = workspace
    local LocalPlayer        = Players.LocalPlayer
    -- RoseHub default range, enforced for both target-lock and compatibility globals.
    local AUTOBUY_RANGE_FIXED = 17
    _G.TT3AutoBuyRange = AUTOBUY_RANGE_FIXED
    _G.TT3AutoBuyFireRange = AUTOBUY_RANGE_FIXED
    -- SHIM des dependances (tout ce que le bloc verbatim attend)
    local Config = setmetatable({
        AutoBuyEnabled = false, AutoGrabSpeed = 17, AutoKickOnSteal = false, TpSettings = {},
    }, { __index = function(_, k)
        if k == "AutoBuyRange" then return AUTOBUY_RANGE_FIXED end
        return nil
    end })
    local function saveConfig() end
    local function setToggle() end
    local function ShowNotification() end
    local SharedState = { ConveyorAnimals = {} }
    local function LPH_NO_VIRTUALIZE(fn) return fn end
    -- Kick apres achat: on prefere le doKick de l AUTO KICK (part en SERVEUR PRIVE
    -- si un code est renseigne), sinon repli sur le kick simple.
    local function kickPlayer()
        if _G.TT3DoAutoKick then pcall(_G.TT3DoAutoKick)
        elseif _G.TT3Kick then pcall(_G.TT3Kick) end
    end
    local CarpetState = nil
    local function setCarpetSpeed() end
    local AnimalsData, AnimalsShared, NumberUtils   -- optionnels (getBrainrotName, non appele)

    local toggleAutoBuy
    -- Wrapped in a function (run immediately at the bottom) instead of a bare do-block so
    -- all of auto-buy's locals get their OWN Luau register budget. A bare do-block's locals
    -- count against the main chunk's 200-local limit, which this scope's helpers overflowed
    -- ("Out of local registers"). Behaviour is identical: it still runs synchronously here,
    -- and toggleAutoBuy (declared above) is assigned as an upvalue so the UI sees it.
    local function _initAutoBuyScope() -- AUTO BUY SCOPE (NOT lazy: toggleAutoBuy must exist immediately for the UI)
    local autoBuyActive = false
    -- Auto-buy radius ring removed (user request): no visible ring at all, and one
    -- less per-frame neon part to render. Destroy any stray ring left by older builds.
    pcall(function()
        local e = Workspace:FindFirstChild("XiAutoBuyRing")
        if e then e:Destroy() end
    end)
    
    -- Explicit assignment to the OUTER `local toggleAutoBuy` declared at line ~6899.
    -- Was previously `function toggleAutoBuy(on)` -- syntactic sugar that some
    -- contexts can mis-resolve; this form guarantees we update the outer upvalue
    -- the UI closure at line 8131 captures.
    toggleAutoBuy = function(on)
        if on ~= nil then
            autoBuyActive = on
        else
            autoBuyActive = not autoBuyActive
        end
        Config.AutoBuyEnabled = autoBuyActive
        pcall(saveConfig)
        pcall(setToggle, "Auto Buy", autoBuyActive)
        -- radius ring removed; clean up any stray ring when auto-buy is switched off
        if not autoBuyActive then
            pcall(function() local e = Workspace:FindFirstChild("XiAutoBuyRing"); if e then e:Destroy() end end)
        end
        pcall(ShowNotification, "AUTO BUY", autoBuyActive and "ENABLED" or "DISABLED")
        if _G.AutoBuyOnToggle then
            pcall(_G.AutoBuyOnToggle, autoBuyActive)
        end
    end
    
    local RARITY_WORDS = {
        common = true, uncommon = true, rare = true, epic = true,
        legendary = true, secret = true, divine = true, rainbow = true,
        cursed = true, gold = true, diamond = true,
    }
    
    local function getBrainrotName(model)
        if not model then return "Brainrot", "" end
        local nameFound, genFound = "", ""
        for _, bb in ipairs(model:GetDescendants()) do
            if bb:IsA("BillboardGui") then
                for _, lbl in ipairs(bb:GetDescendants()) do
                    if lbl:IsA("TextLabel") and lbl.Text and lbl.Text ~= "" then
                        local t = lbl.Text:match("^%s*(.-)%s*$")
                        local tl = t:lower()
                        if RARITY_WORDS[tl] then continue end
                        if t:match("^%$[%d%.]+[KkMmBb]?/s$") then
                            if genFound == "" then genFound = t end
                            continue
                        end
                        if t:match("^%$[%d%.]+[KkMmBb]?$") then continue end
                        if t:match("^[%d%.]+[KkMmBb]?$") then continue end
                        if nameFound == "" and #t > 1 then nameFound = t end
                    end
                end
            end
        end
        if nameFound == "" then
            pcall(function()
                local info = AnimalsData[model.Name]
                if info and info.DisplayName then
                    nameFound = info.DisplayName
                    local gv = AnimalsShared:GetGeneration(model.Name, nil, nil, nil)
                    local gt = "$" .. NumberUtils:ToString(gv) .. "/s"
                    genFound = gt
                end
            end)
        end
        if nameFound == "" then nameFound = model.Name ~= "" and model.Name or "Brainrot" end
        return nameFound, genFound
    end
    
    local function scanConveyor()
        -- Only the prompt + its part are needed to auto-buy. The old version ALSO called
        -- getBrainrotName() per prompt (another model:GetDescendants each) and walked up to
        -- 8 ancestors -- pure wasted cost that made this whole-Workspace scan brutal, above
        -- all under Luraph. model = realPart.Parent is a cheap liveness handle for partAlive.
        local results = {}
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if not (obj:IsA("ProximityPrompt") and obj.Enabled) then continue end
            local txt = obj.ActionText or ""
            if not (txt == "Purchase" or txt:lower():find("purchase") or txt:lower():find("comprar")) then continue end
            local part = obj.Parent
            if not part then continue end
            local realPart = (part:IsA("Attachment") and part.Parent) or part
            if not (realPart and realPart:IsA("BasePart")) then continue end
            results[#results + 1] = { prompt = obj, part = realPart, model = realPart.Parent }
        end
        return results
    end
    
    SharedState.ConveyorAnimals = {}
    local function refreshConveyor()
        local ok, found = pcall(scanConveyor)
        if ok and found then
            SharedState.ConveyorAnimals = found
        end
    end
    -- No scan at load: defer the first (expensive) Workspace:GetDescendants scan until
    -- Auto Buy is actually toggled on, so it never adds to startup lag.
    _G.refreshConveyor = refreshConveyor
    
    local purchaseRemote = nil
    local function resolvePurchaseRemote()
        if purchaseRemote and purchaseRemote.Parent then return purchaseRemote end
        pcall(function()
            local net = ReplicatedStorage:FindFirstChild("Packages") and ReplicatedStorage.Packages:FindFirstChild("Net")
            if not net then return end
            local kws = {"buy", "purchase", "animal", "shop", "acquire", "conveyor"}
            for _, v in ipairs(net:GetChildren()) do
                local nl = (v.Name or ""):lower()
                for _, kw in ipairs(kws) do
                    if nl:find(kw) then
                        purchaseRemote = v
                        return
                    end
                end
            end
        end)
        return purchaseRemote
    end
    
    -- Weak-keyed so destroyed prompts are GC'd (never leaks): rate-limit each prompt and
    -- never stack yielding InvokeServer threads. This keeps buying continuous but BOUNDED
    -- so the per-frame buy loop can't flood the server (which would get you rate-limited
    -- or kicked) or spawn unbounded threads under lag.
    local _lastPurchaseFire = setmetatable({}, {__mode = "k"})
    local _purchaseInFlight = setmetatable({}, {__mode = "k"})
    local PURCHASE_MIN_INTERVAL = 0.03   -- ~33 fires/sec per prompt (faster, still bounded)
    
    local function firePurchaseNatural(prompt)
        if not prompt or not prompt.Parent or not prompt.Enabled then return end
        local now = os.clock()
        local last = _lastPurchaseFire[prompt]
        if last and (now - last) < PURCHASE_MIN_INTERVAL then return end
        _lastPurchaseFire[prompt] = now
        pcall(function()
            if fireproximityprompt then fireproximityprompt(prompt) end
        end)
        -- FIRE DIRECT DU REMOTE D ACHAT: DESACTIVE PAR DEFAUT (anti-detection).
        -- resolvePurchaseRemote scanne Net par mot-cle ("buy"/"purchase"/...) et
        -- tombe sur un remote LEURRE (nom lisible = honeypot du jeu). Firer ce
        -- leurre = DETECTION -> c est ce qui te bannissait apres quelques minutes.
        -- fireproximityprompt (ci-dessus) fire deja le VRAI remote HASHE du prompt,
        -- sans scan par mot-cle -> pas de leurre. On ne fait le fire direct QUE si
        -- tu l actives explicitement (_G.TT3AutoBuyFireRemote = true), au cas ou
        -- fireproximityprompt seul n achete pas.
        if _G.TT3AutoBuyFireRemote then
            if _purchaseInFlight[prompt] then return end
            _purchaseInFlight[prompt] = true
            task.spawn(function()
                local remote = resolvePurchaseRemote()
                if remote then
                    pcall(function()
                        if remote:IsA("RemoteFunction") then
                            remote:InvokeServer(prompt.Parent)
                        elseif remote:IsA("RemoteEvent") then
                            remote:FireServer(prompt.Parent)
                        end
                    end)
                end
                _purchaseInFlight[prompt] = nil
            end)
        end
    end
    
    local carpetLockConn = nil
    local _abReturning = false   -- true while flying back to the brainrot after a medusa/knockback
    local FLY_GEAR_NAMES = { "Flying Carpet", "Carpet", "Cloud", "Witch's Broom", "Cupid's Wings", "Santa's Sleigh", "Magic Carpet", "Waverider" }
    local function isCarpetTool(t)
        if not (t and t:IsA("Tool")) then return false end
        local carpetName = (Config.TpSettings and Config.TpSettings.Tool) or ""
        if carpetName ~= "" and t.Name == carpetName then return true end
        local nm = t.Name or ""
        for _, n in ipairs(FLY_GEAR_NAMES) do if nm == n then return true end end
        local nl = nm:lower()
        return nl:find("carpet") ~= nil or nl:find("broom") ~= nil or nl:find("glider") ~= nil or nl:find("wings") ~= nil
    end
    local function unequipCarpet()
        -- Move ONLY the flying gear back to the Backpack (leaving every OTHER tool
        -- equipped) so the player never has the flying gear in hand during normal auto-buy
        -- but can still freely equip / switch / use their own tools. Movement uses the
        -- BodyPosition below, so no tool needs to be held.
        pcall(function()
            local char = LocalPlayer.Character
            local bp = LocalPlayer:FindFirstChild("Backpack")
            if not char or not bp then return end
            for _, t in ipairs(char:GetChildren()) do
                if isCarpetTool(t) then t.Parent = bp end
            end
        end)
    end
    local function equipFlyGear()
        -- Equip whatever fly gear the player owns (carpet/broom/wings/...) so the return
        -- to the brainrot after a medusa/knockback is FLOWN on the gear, not walked.
        pcall(function()
            local char = LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if not char or not hum then return end
            for _, t in ipairs(char:GetChildren()) do if isCarpetTool(t) then return end end  -- already holding one
            local bp = LocalPlayer:FindFirstChild("Backpack")
            if bp then
                for _, t in ipairs(bp:GetChildren()) do
                    if isCarpetTool(t) then hum:EquipTool(t); return end
                end
            end
        end)
    end
    -- Keep the fly gear on by default so the player visibly hovers over the brainrot ON the
    -- gear -- but ONLY re-equip it when the hands are empty, so a tool the player manually
    -- switched to is left alone (they can still swap tools; the gear just comes back if idle).
    local function keepFlyGearIfIdle()
        -- _G.TT3AutoBuyKeepCarpet == false -> on ne re-equipe JAMAIS le carpet
        -- pendant l auto-buy: le joueur garde/utilise librement ses propres tools.
        -- Le hover sur le brainrot reste assure par le BodyPosition (carpet pas
        -- necessaire en main). Defaut (nil) = comportement d avant (carpet visible).
        if _G.TT3AutoBuyKeepCarpet == false then return end
        pcall(function()
            local char = LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if not char or not hum then return end
            for _, t in ipairs(char:GetChildren()) do
                if t:IsA("Tool") then return end   -- already holding SOMETHING -> leave it
            end
            local bp = LocalPlayer:FindFirstChild("Backpack")
            if bp then
                for _, t in ipairs(bp:GetChildren()) do
                    if isCarpetTool(t) then hum:EquipTool(t); return end
                end
            end
        end)
    end
    local function startCarpetLock()
        if carpetLockConn then carpetLockConn:Disconnect(); carpetLockConn = nil end
        -- Put the player ON a fly gear (carpet/broom/...) ONCE when a new brainrot is
        -- locked, so they visibly fly over it. We do NOT re-equip it every frame, so the
        -- player can freely switch to any other tool afterwards and it stays switched.
        if _G.TT3AutoBuyKeepCarpet == false then return end   -- laisser le joueur libre de ses tools
        equipFlyGear()
    end
    
    local function stopCarpetLock()
        if carpetLockConn then carpetLockConn:Disconnect(); carpetLockConn = nil end
    end
    
    local HOVER_HEIGHT = 6.0   -- studs to float ABOVE the WHOLE brainrot model (see _abTopOff)
    local BUY_INTERVAL = 0.03
    local DETECT_RADIUS = AUTOBUY_RANGE_FIXED
    local lockedTarget = nil
    local lockedPart = nil
    local lockedModel = nil
    local _lockedBuyFired = false  -- true once we've fired a purchase at the current locked target
    local _abTopOff = 2            -- (part center -> TOP of the whole brainrot model), set per lock
    local _lastAbove = nil        -- last hover target, held briefly across a buy->relock gap
    local _lastTargetTime = 0

    local function partAlive()
        return lockedPart and lockedPart.Parent and lockedModel and lockedModel.Parent
    end
    
    local function promptAlive()
        return lockedTarget and lockedTarget.prompt and lockedTarget.prompt.Parent and lockedTarget.prompt.Enabled
    end
    
    local bodyPos = nil
    local function ensureBodyPos(hrp)
        -- CRITICALLY DAMPED BodyPosition: P scales with the speed slider (fast approach),
        -- D = 2*sqrt(P*mass) so it settles onto the target with NO overshoot -> it can't
        -- oscillate, fling, or launch the character through the map ("ohne dass es kaputt
        -- geht"), and it sticks rock-steady on the brainrot (constant). Physics/BodyPosition
        -- keeps the client as network owner, so movement replicates smoothly (no rubber-band
        -- like a hard per-frame CFrame set would risk).
        local speed = math.clamp(Config.AutoGrabSpeed or 17, 5, 100)
        -- FIRM hold at hover height so the player stays OVER the brainrot and does NOT drift
        -- away ("nicht weg"). It's not "gluing" -- the height (HOVER_HEIGHT) keeps it a clear
        -- fly-over ABOVE the brainrot rather than stuck on it.
        local P = 8000 + speed * 300
        local mass = hrp.AssemblyMass
        if not mass or mass <= 0 then mass = 14 end
        local D = 2 * math.sqrt(P * mass)
        -- Finite, mass-scaled MaxForce: even with the speed maxed out via config, the
        -- single-frame impulse can never get big enough to tunnel/launch the character
        -- through map geometry. Default speed behavior is completely unaffected.
        local maxF = mass * 60000
        if bodyPos and bodyPos.Parent == hrp then
            bodyPos.MaxForce = Vector3.new(maxF, maxF, maxF)
            bodyPos.P = P
            bodyPos.D = D
            return bodyPos
        end
        if bodyPos then bodyPos:Destroy() end
        local bp = Instance.new("BodyPosition")
        bp.MaxForce = Vector3.new(maxF, maxF, maxF)
        bp.P = P
        bp.D = D
        bp.Position = hrp.Position
        bp.Parent = hrp
        bodyPos = bp
        return bp
    end
    
    local function destroyBodyPos()
        if bodyPos then bodyPos:Destroy(); bodyPos = nil end
    end
    
    local RETURN_SPEED = 220
    RunService.PreSimulation:Connect(LPH_NO_VIRTUALIZE(function()
        if not autoBuyActive then
            destroyBodyPos()
            _abReturning = false
            return
        end
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not hrp then destroyBodyPos(); return end
        -- Medusa / boogie / knockback can anchor, ragdoll or platform-stand you; clear it
        -- every frame so nothing can pin you away from the brainrot.
        if hrp.Anchored then hrp.Anchored = false end
        if hum then
            if hum.PlatformStand then hum.PlatformStand = false end
            local st = hum:GetState()
            if st == Enum.HumanoidStateType.Ragdoll or st == Enum.HumanoidStateType.FallingDown or st == Enum.HumanoidStateType.Physics then
                pcall(function() hum:ChangeState(Enum.HumanoidStateType.GettingUp) end)
            end
        end
        if not partAlive() then
            -- The locked brainrot just got bought (or lost). DON'T drop -- keep FLOATING at the
            -- last hover spot for a short grace so we don't fall off before the NEXT brainrot is
            -- locked (fixes "nach einem kauf klebt es manchmal nicht am brainrot").
            if _lastAbove and (os.clock() - _lastTargetTime) < 0.7 then
                local bp = ensureBodyPos(hrp)
                bp.Position = _lastAbove
                local lv = hrp.AssemblyLinearVelocity
                if lv.Magnitude > 250 then hrp.AssemblyLinearVelocity = lv.Unit * 250 end
            else
                destroyBodyPos()
            end
            _abReturning = false
            return
        end
        -- Float clearly ABOVE the WHOLE brainrot model (on the carpet, like the reference
        -- image) instead of on the small prompt part -- so the body never hangs INSIDE a tall
        -- brainrot. _abTopOff is the part-center -> model-top offset captured at lock time.
        local above = Vector3.new(lockedPart.Position.X, lockedPart.Position.Y + _abTopOff + HOVER_HEIGHT, lockedPart.Position.Z)
        _lastAbove = above
        _lastTargetTime = os.clock()
        local dist = (hrp.Position - above).Magnitude
        -- Hysteresis: once knocked >30 studs off (medusa/boogie/hit), fly back on the
        -- gear until within 10 studs, then resume sticking. Normal locks are <=17 studs
        -- so this NEVER triggers during ordinary approach.
        if _abReturning then
            if dist < 10 then _abReturning = false end
        elseif dist > 30 then
            _abReturning = true
        end
        if _abReturning then
            -- Flew off: equip the fly gear the player has and rocket straight back.
            destroyBodyPos()
            equipFlyGear()
            local d = above - hrp.Position
            if d.Magnitude > 0.1 then hrp.AssemblyLinearVelocity = d.Unit * RETURN_SPEED end
            hrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
        else
            -- Gentle hover ABOVE the brainrot on the fly gear: soft hold, no spin-lock, so
            -- it does NOT glue/pin the player -- they float, can drift and switch tools,
            -- while staying in buy range.
            local bp = ensureBodyPos(hrp)
            bp.Position = above
            local lv = hrp.AssemblyLinearVelocity
            if lv.Magnitude > 250 then hrp.AssemblyLinearVelocity = lv.Unit * 250 end
        end
    end))
    
    task.spawn(LPH_NO_VIRTUALIZE(function()
        while true do
            if not autoBuyActive then task.wait(0.05); continue end
            -- On n achete QUE le brainrot VERROUILLE (celui sur lequel on hover).
            -- Le balayage "achete tout le conveyor dans le rayon" a ete retire a la
            -- demande: plus d achat massif, on ne prend que la cible courante.
            if promptAlive() then firePurchaseNatural(lockedTarget.prompt); _lockedBuyFired = true end
            RunService.Heartbeat:Wait()
        end
    end))
    
    local _lastConveyorScan = 0
    task.spawn(function()
        while true do
            task.wait(0.1)
            if not autoBuyActive then
                lockedTarget = nil
                lockedPart = nil
                lockedModel = nil
                _lockedBuyFired = false
                stopCarpetLock()
                destroyBodyPos()
                continue
            end
            -- Keep the fly gear on (only when idle, so manual tool switches are respected).
            keepFlyGearIfIdle()
            if lockedPart or lockedModel then
                if partAlive() then
                    continue   -- still on the current brainrot -- keep buying / hovering
                end
                -- Our locked brainrot vanished from the conveyor while we were firing purchases
                -- at it => WE bought it (it's now in our base). Auto-kick then, exactly as the
                -- user wants. Reliable at the conveyor (always rendered) and never false-fires
                -- on join, unlike watching the base brainrot count.
                -- Notre brainrot verrouille a quitte le tapis (achete). L AUTO KICK
                -- apres achat a ete RETIRE a la demande: l Auto Buy ne kick JAMAIS.
                -- On nettoie juste l etat et on re-lock le prochain.
                pcall(refreshConveyor)
                _lastConveyorScan = os.clock()   -- we just scanned, don't double-scan below
                lockedTarget = nil
                lockedPart = nil
                lockedModel = nil
                _lockedBuyFired = false
                -- Fall THROUGH to re-lock the next brainrot in THIS same iteration -- no 0.1s
                -- gap where the character would drop off before the next target locks.
            end
            -- Throttle the (whole-Workspace) rescan: 0.1s was far too frequent and is the
            -- main Auto-Buy lag source, especially under Luraph. ~3 scans/sec is plenty to
            -- pick up newly-spawned conveyor brainrots.
            if os.clock() - _lastConveyorScan > 0.35 then
                _lastConveyorScan = os.clock()
                pcall(refreshConveyor)
            end
            local char = LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if not hrp then continue end
            local radius = AUTOBUY_RANGE_FIXED
            local best, bestDist = nil, math.huge
            for _, entry in ipairs(SharedState.ConveyorAnimals) do
                if entry.prompt and entry.prompt.Parent and entry.prompt.Enabled and entry.part and entry.part.Parent then
                    local d = (hrp.Position - entry.part.Position).Magnitude
                    if d <= radius and d < bestDist then
                        bestDist = d
                        best = entry
                    end
                end
            end
            if best then
                lockedTarget = best
                lockedPart = best.part
                lockedModel = best.model or best.part.Parent
                _lockedBuyFired = false
                -- Measure to the TOP of the whole brainrot MODEL, not just the small prompt part
                -- (best.model is only the immediate parent, so the hover was landing INSIDE a
                -- tall brainrot -> "im brainrot"). Walk up to the first real Model and use its
                -- full bounding box; clamp so a giant container can't fling us to the sky.
                _abTopOff = math.max(lockedPart.Size.Y * 0.5, 3)
                pcall(function()
                    local m = lockedPart
                    for _ = 1, 6 do
                        if m and m:IsA("Model") then break end
                        m = m and m.Parent
                    end
                    if m and m:IsA("Model") then
                        local cf, size = m:GetBoundingBox()
                        local off = (cf.Position.Y + size.Y * 0.5) - lockedPart.Position.Y
                        if off > _abTopOff then _abTopOff = off end
                    end
                end)
                if _abTopOff > 14 then _abTopOff = 14 end
                ShowNotification("AUTO BUY", "Locked")
                startCarpetLock()
            end
        end
    end)
    
    _G.AutoBuyOnToggle = function(active)
        if active then
            if _G.refreshConveyor then pcall(_G.refreshConveyor) end
            -- Auto-buy moves via BodyPosition; switch Carpet Speed off so its per-frame
            -- force-equip doesn't fight the carpet unequip (flicker) or the movement.
            if CarpetState and CarpetState.enabled then pcall(setCarpetSpeed, false) end
            startCarpetLock()
        else
            stopCarpetLock()
            destroyBodyPos()
        end
    end
    end
    _initAutoBuyScope() -- END AUTO BUY SCOPE (run immediately, exactly like the old do-block)

    -- expose pour le keybind "K" + suivi de l etat dans _G.TT3AutoBuy
    _G.TT3ToggleAutoBuy = function() if toggleAutoBuy then pcall(toggleAutoBuy) end end
    _G.TT3SetAutoBuy    = function(on) if toggleAutoBuy then pcall(toggleAutoBuy, on) end end
    local _origOnToggle = _G.AutoBuyOnToggle
    _G.AutoBuyOnToggle = function(active)
        _G.TT3AutoBuy = active and true or false
        if _origOnToggle then pcall(_origOnToggle, active) end
    end
end)
if not okAB then warn("[AUTOBUY] BLOC EN ERREUR: " .. tostring(errAB)) end
end)

-- ============================================================
-- NO BRAINROT ANIM (remove a animacao dos bonecos/bixos brainrot)
-- Para os Animators dos brainrots assim que uma animacao toca, deixando
-- o boneco parado (sem idle/andar). 100% client-side/visual, nao precisa
-- de nenhum RemoteEvent do jogo. Toggle aqui + botao espelhado no painel
-- Teleport (Teleport_priority.txt) via _G.TT3ToggleBrainrotAnim.
-- ============================================================
stagSpawn(function()
local okNBA, errNBA = pcall(function()
    local Workspace = game:GetService("Workspace")
    local Players   = game:GetService("Players")
    local LP        = Players.LocalPlayer

    if _G.TT3NoBrainrotAnim == nil then _G.TT3NoBrainrotAnim = false end
    local animConns = setmetatable({}, { __mode = "k" })

    -- Heuristica: um boneco de brainrot e um Model com Humanoid OU
    -- AnimationController + uma BillboardGui (nome/raridade flutuando),
    -- igual ao criterio ja usado em getBrainrotName() no Auto Buy.
    local function isBrainrotModel(model)
        if not model or not model:IsA("Model") then return false end
        if not (model:FindFirstChildOfClass("Humanoid") or model:FindFirstChildOfClass("AnimationController")) then
            return false
        end
        for _, d in ipairs(model:GetDescendants()) do
            if d:IsA("BillboardGui") then return true end
        end
        return false
    end

    local function getAnimator(model)
        local owner = model:FindFirstChildOfClass("Humanoid") or model:FindFirstChildOfClass("AnimationController")
        return owner and owner:FindFirstChildOfClass("Animator")
    end

    local function killAnims(model)
        local animator = getAnimator(model)
        if not animator then return end
        for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
            pcall(function() track:Stop(0) end)
        end
        if not animConns[animator] then
            animConns[animator] = animator.AnimationPlayed:Connect(function(track)
                if _G.TT3NoBrainrotAnim then pcall(function() track:Stop(0) end) end
            end)
        end
    end

    local function scanAndKill()
        if not _G.TT3NoBrainrotAnim then return end
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if isBrainrotModel(obj) then pcall(killAnims, obj) end
        end
    end

    -- pega bonecos que aparecem depois do toggle ligado (conveyor, roubados, etc.)
    Workspace.DescendantAdded:Connect(function(obj)
        if not _G.TT3NoBrainrotAnim then return end
        task.defer(function()
            if obj and obj.Parent and obj:IsA("Model") and isBrainrotModel(obj) then
                pcall(killAnims, obj)
            end
        end)
    end)

    -- varredura leve pra reforcar (ex.: animacao que reinicia sem AnimationPlayed novo)
    task.spawn(function()
        while true do
            task.wait(2)
            if _G.TT3NoBrainrotAnim then pcall(scanAndKill) end
        end
    end)

    _G.TT3ToggleBrainrotAnim = function(state)
        if state == nil then state = not _G.TT3NoBrainrotAnim end
        _G.TT3NoBrainrotAnim = state
        if state then pcall(scanAndKill) end
        if _G.TT3RefreshBrainrotAnimBtn then pcall(_G.TT3RefreshBrainrotAnimBtn) end
    end

    ------------------------------------------------------------------
    -- GUI: paineluzinho preto no mesmo estilo do Invis Steal / Utility
    ------------------------------------------------------------------
    local guiParent = (gethui and gethui()) or game:GetService("CoreGui") or LP:WaitForChild("PlayerGui")
    pcall(function()
        local old = guiParent:FindFirstChild("NoBrainrotAnimUI")
        if old then old:Destroy() end
    end)
    local sg = Instance.new("ScreenGui")
    sg.Name = "NoBrainrotAnimUI"; sg.ResetOnSpawn = false; sg.DisplayOrder = 131
    if _G.TT3RegisterPanel then _G.TT3RegisterPanel("noanim", sg) end
    pcall(function() sg.Parent = guiParent end)
    if not sg.Parent then sg.Parent = LP:WaitForChild("PlayerGui") end

    local f = Instance.new("Frame", sg)
    f.Size = UDim2.fromOffset(150, 60)
    fitMobilePanel(f, 0.80)
    f.Position = UDim2.fromOffset(tonumber(_G.NoAnimPanelX) or 14, tonumber(_G.NoAnimPanelY) or 520)
    f.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    f.BorderSizePixel = 0; f.Active = true; f.Draggable = true
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)
    do local outline = Instance.new("UIStroke", f); outline.Color = Color3.fromRGB(86, 86, 86); outline.Transparency = 0.45; outline.Thickness = 1 end
    do
        local pending = false
        f:GetPropertyChangedSignal("Position"):Connect(function()
            if pending then return end
            pending = true
            task.delay(0.5, function()
                pending = false
                _G.NoAnimPanelX, _G.NoAnimPanelY = f.AbsolutePosition.X, f.AbsolutePosition.Y
            end)
        end)
    end

    local ttl = Instance.new("TextLabel", f)
    ttl.Size = UDim2.new(1, 0, 0, 18); ttl.BackgroundTransparency = 1
    ttl.Text = "NO BRAINROT ANIM"; ttl.Font = Enum.Font.GothamBlack
    ttl.TextSize = 10; ttl.TextColor3 = Color3.new(1, 1, 1)

    local b = Instance.new("TextButton", f)
    b.Size = UDim2.new(1, -16, 0, 24); b.Position = UDim2.fromOffset(8, 24)
    b.Font = Enum.Font.GothamBold; b.TextSize = 11
    b.TextColor3 = Color3.new(1, 1, 1); b.BorderSizePixel = 0
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5)
    local function refreshBtn()
        b.Text = "NO ANIM" .. (_G.TT3NoBrainrotAnim and ": ON" or ": OFF")
        b.BackgroundColor3 = _G.TT3NoBrainrotAnim and Color3.fromRGB(86, 86, 86) or Color3.fromRGB(58, 58, 58)
    end
    _G.TT3RefreshBrainrotAnimBtn = refreshBtn
    b.MouseButton1Click:Connect(function() _G.TT3ToggleBrainrotAnim() end)
    refreshBtn()
end)
if not okNBA then warn("[NOBRAINROTANIM] BLOC EN ERREUR: " .. tostring(errNBA)) end
end)


-- ============================================================
-- FPS OPTIMIZER / FPS-PING HUB LEAKED
-- Sem Config, sem UI de configurações e sem keybinds extras.
-- ============================================================
do
    local _FPS_RS = game:GetService("RunService")
    local _FPS_STATS = game:GetService("Stats")
    local _FPS_LIGHTING = game:GetService("Lighting")
    local _FPS_MATERIAL = game:GetService("MaterialService")
    local _FPS_PLAYERS = game:GetService("Players")
    local _FPS_LP = _FPS_PLAYERS.LocalPlayer
    local _FPS_PG = _FPS_LP:WaitForChild("PlayerGui")

    -- FPS Optimizer do Hub Leaked.
    _G.ApplyFPSBoost = _G.ApplyFPSBoost or function()
        if _G.FPSBoostApplied then return end
        _G.FPSBoostApplied = true
        task.spawn(function()
            pcall(function()
                settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
                settings().Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Level01
                settings().Physics.AllowSleep = true
                settings().Physics.PhysicsEnvironmentalThrottle = Enum.EnviromentalPhysicsThrottle.Skip
            end)
            pcall(function()
                if sethiddenproperty then sethiddenproperty(_FPS_LIGHTING, "Technology", Enum.Technology.Compatibility) end
            end)
            pcall(setfpscap, 999)
            local function strip(inst)
                pcall(function()
                    if inst:IsA("Decal") or inst:IsA("Texture") then
                        if inst.Name ~= "face" then inst:Destroy() end
                    elseif inst:IsA("SpecialMesh") then
                        inst.TextureId = ""
                    elseif inst:IsA("ParticleEmitter") or inst:IsA("Trail")
                        or inst:IsA("PointLight") or inst:IsA("SpotLight")
                        or inst:IsA("SurfaceLight") or inst:IsA("Fire")
                        or inst:IsA("Smoke") or inst:IsA("Sparkles")
                        or inst:IsA("Explosion") then
                        inst:Destroy()
                    elseif inst:IsA("BasePart") then
                        inst.CastShadow = false
                        inst.Material = Enum.Material.SmoothPlastic
                        inst.MaterialVariant = ""
                        inst.Reflectance = 0
                    end
                end)
            end
            pcall(function()
                _FPS_LIGHTING.GlobalShadows = false
                _FPS_LIGHTING.FogEnd = 9e9
                _FPS_LIGHTING.FogStart = 9e9
                _FPS_LIGHTING.EnvironmentDiffuseScale = 0
                _FPS_LIGHTING.EnvironmentSpecularScale = 0
                for _, obj in ipairs(_FPS_LIGHTING:GetChildren()) do
                    if obj:IsA("PostEffect") then obj.Enabled = false
                    elseif obj:IsA("Atmosphere") or obj:IsA("Clouds") or obj:IsA("Sky") then obj:Destroy() end
                end
            end)
            pcall(function()
                local terrain = workspace.Terrain
                terrain.Decoration = false
                terrain.WaterWaveSize = 0
                terrain.WaterWaveSpeed = 0
                terrain.WaterReflectance = 0
                terrain.WaterTransparency = 1
            end)
            local descendants = workspace:GetDescendants()
            for i = 1, #descendants, 5000 do
                for j = i, math.min(i + 4999, #descendants) do
                    if descendants[j] and descendants[j].Parent then strip(descendants[j]) end
                end
                task.wait()
            end
            workspace.DescendantAdded:Connect(function(inst) strip(inst) end)
            _FPS_LIGHTING.DescendantAdded:Connect(function(inst)
                pcall(function()
                    if inst:IsA("PostEffect") then inst.Enabled = false
                    elseif inst:IsA("Atmosphere") or inst:IsA("Clouds") then inst:Destroy() end
                end)
            end)
            _FPS_MATERIAL.DescendantAdded:Connect(function(inst) pcall(function() inst:Destroy() end) end)
            for _, player in ipairs(_FPS_PLAYERS:GetPlayers()) do
                if player.Character then
                    for _, inst in ipairs(player.Character:GetDescendants()) do strip(inst) end
                end
                player.CharacterAdded:Connect(function(char)
                    task.wait(0.3)
                    for _, inst in ipairs(char:GetDescendants()) do strip(inst) end
                end)
            end
        end)
    end
    pcall(_G.ApplyFPSBoost)
end


-- FPS/PING do Hub Leaked: único widget visual deste bloco.
do
    local _HFP_RS = game:GetService("RunService")
    local _HFP_LP = game:GetService("Players").LocalPlayer
    local _HFP_PG = _HFP_LP:WaitForChild("PlayerGui")
    local _HFP_PARENT = (gethui and gethui()) or game:GetService("CoreGui") or _HFP_PG
    pcall(function()
        local old = _HFP_PARENT:FindFirstChild("BODHubFPSPing")
        if old then old:Destroy() end
    end)
    local _HFP_GUI = Instance.new("ScreenGui")
    _HFP_GUI.Name = "BODHubFPSPing"
    _HFP_GUI.ResetOnSpawn = false
    _HFP_GUI.IgnoreGuiInset = true
    _HFP_GUI.ZIndexBehavior = Enum.ZIndexBehavior.Global
    _HFP_GUI.DisplayOrder = 2147483647
    pcall(function() _HFP_GUI.Parent = _HFP_PARENT end)
    if not _HFP_GUI.Parent then _HFP_GUI.Parent = _HFP_PG end
    local _HFP_TEXT = Instance.new("TextLabel")
    _HFP_TEXT.Name = "FpsText"
    _HFP_TEXT.BackgroundColor3 = Color3.new(0, 0, 0)
    _HFP_TEXT.BackgroundTransparency = 0.15
    _HFP_TEXT.BorderSizePixel = 0
    _HFP_TEXT.RichText = true
    _HFP_TEXT.Size = UDim2.new(0, 220, 0, 52)
    _HFP_TEXT.Font = Enum.Font.GothamBold
    _HFP_TEXT.TextSize = 13
    _HFP_TEXT.TextColor3 = Color3.fromRGB(255, 255, 255)
    _HFP_TEXT.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    _HFP_TEXT.TextStrokeTransparency = 0.2
    _HFP_TEXT.TextXAlignment = Enum.TextXAlignment.Center
    _HFP_TEXT.TextYAlignment = Enum.TextYAlignment.Center
    _HFP_TEXT.AnchorPoint = Vector2.new(0.5, 0)
    _HFP_TEXT.Position = UDim2.new(0.5, 0, 0, 10)
    _HFP_TEXT.Text = "<font color=\"rgb(255, 255, 255)\"><b>otex private</b></font>\nFps : --   Ping : --"
    _HFP_TEXT.Parent = _HFP_GUI
    local _HFP_CORNER = Instance.new("UICorner", _HFP_TEXT)
    _HFP_CORNER.CornerRadius = UDim.new(0, 10)
    _G.fpsText = _HFP_TEXT
    _G.currentFPS = 60
    local _HFP_FRAMES, _HFP_LAST = 0, tick()
    _HFP_RS.RenderStepped:Connect(function()
        _HFP_FRAMES = _HFP_FRAMES + 1
        local now = tick()
        if now - _HFP_LAST >= 1 then
            local fps = _HFP_FRAMES
            _G.currentFPS = fps
            _HFP_FRAMES = 0
            _HFP_LAST = now
            local ping = 0
            pcall(function() ping = math.floor(_HFP_LP:GetNetworkPing() * 1000) end)
            local fpsColor = "rgb(255,255,255)"
            local pingColor = "rgb(255,255,255)"
            if _HFP_TEXT and _HFP_TEXT.Parent then
                _HFP_TEXT.Text = string.format("otex private", fpsColor, fps, pingColor, ping)
            end
        end
    end)
end
