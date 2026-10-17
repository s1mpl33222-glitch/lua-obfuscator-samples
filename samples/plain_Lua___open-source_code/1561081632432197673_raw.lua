do
    local AnimSystem = {
        Enabled = false,
        Selected = "Ninja",
        Originals = nil,
        Conn = nil,
        Packs = {
            ["Ninja"] = {
                idle1 = "rbxassetid://656117400", idle2 = "rbxassetid://656118341", walk = "rbxassetid://656121766", run = "rbxassetid://656118852",
                jump = "rbxassetid://109996626521204", fall = "rbxassetid://656115606", climb = "rbxassetid://656114359", swim = "rbxassetid://656119721", swimidle = "rbxassetid://656121397",
            },
            ["Amazon"] = {
                idle1 = "rbxassetid://10921344533", idle2 = "rbxassetid://10921345304", walk = "rbxassetid://10921355261", run = "rbxassetid://616163682",
                jump = "rbxassetid://104325245285198", fall = "rbxassetid://10921350320", climb = "rbxassetid://10921343576", swim = "rbxassetid://10921352344", swimidle = "rbxassetid://10921353442",
            },
            ["Mage"] = {
                idle1 = "rbxassetid://10921344533", idle2 = "rbxassetid://10921345304", walk = "rbxassetid://707897309", run = "rbxassetid://616163682",
                jump = "rbxassetid://656117878", fall = "rbxassetid://656115606", climb = "rbxassetid://656114359", swim = "rbxassetid://656119721", swimidle = "rbxassetid://656121397",
            },
            ["Vampire"] = {
                idle1 = "rbxassetid://10921315373", idle2 = "", walk = "rbxassetid://10921326949", run = "rbxassetid://10921320299",
                jump = "rbxassetid://10921322186", fall = "rbxassetid://10921321317", climb = "rbxassetid://10921314188", swim = "rbxassetid://10921324408", swimidle = "rbxassetid://10921325443",
            },
            ["Adidas"] = {
                idle1 = "rbxassetid://122257458498464", idle2 = "rbxassetid://102357151005774", walk = "rbxassetid://10921152678", run = "rbxassetid://82598234841035",
                jump = "rbxassetid://75290611992385", fall = "rbxassetid://10921148939", climb = "rbxassetid://88763136693023", swim = "rbxassetid://133308483266208", swimidle = "rbxassetid://109346520324160",
            },
            ["Anim Pack"] = {
                idle1 = "rbxassetid://133806214992291", idle2 = "rbxassetid://94970088341563", walk = "rbxassetid://109168724482748", run = "rbxassetid://10921148209",
                jump = "rbxassetid://116936326516985", fall = "rbxassetid://92294537340807", climb = "rbxassetid://119377220967554", swim = "rbxassetid://134591743181628", swimidle = "rbxassetid://98854111361360",
            },
            ["Adidas Sports"] = {
                idle1 = "rbxassetid://18537376492", idle2 = "rbxassetid://18537371272", walk = "rbxassetid://18537392113", run = "rbxassetid://18537384940",
                jump = "rbxassetid://18537380791", fall = "rbxassetid://18537367238", climb = "rbxassetid://18537363391", swim = "rbxassetid://18537389531", swimidle = "rbxassetid://18537387180",
            },
            ["Adidas Aura"] = {
                idle1 = "rbxassetid://110211186840347", idle2 = "rbxassetid://114191137265065", walk = "rbxassetid://83842218823011", run = "rbxassetid://118320322718866",
                jump = "rbxassetid://109996626521204", fall = "rbxassetid://95603166884636", climb = "rbxassetid://97824616490448", swim = "rbxassetid://134530128383903", swimidle = "rbxassetid://94922130551805",
            },
            ["Wicked Popular"] = {
                idle1 = "rbxassetid://118832222982049", idle2 = "rbxassetid://76049494037641", walk = "rbxassetid://92072849924640", run = "rbxassetid://72301599441680",
                jump = "rbxassetid://104325245285198", fall = "rbxassetid://121152442762481", climb = "rbxassetid://131326830509784", swim = "rbxassetid://99384245425157", swimidle = "rbxassetid://113199415118199",
            },
            ["Elder"] = {
                idle1 = "rbxassetid://10921101664", idle2 = "rbxassetid://10921102574", walk = "rbxassetid://10921111375", run = "rbxassetid://10921104374",
                jump = "rbxassetid://10921107367", fall = "rbxassetid://10921105765", climb = "rbxassetid://10921100400", swim = "rbxassetid://10921108971", swimidle = "rbxassetid://10921110146",
            },
            ["Astronaut"] = {
                idle1 = "rbxassetid://10921034824", idle2 = "rbxassetid://10921036806", walk = "rbxassetid://10921046031", run = "rbxassetid://10921039308",
                jump = "rbxassetid://10921042494", fall = "rbxassetid://10921040576", climb = "rbxassetid://10921032124", swim = "rbxassetid://10921044000", swimidle = "rbxassetid://10921045006",
            },
            ['Wicked "Dancing Through Life"'] = {
                idle1 = "rbxassetid://92849173543269", idle2 = "rbxassetid://132238900951109", walk = "rbxassetid://73718308412641", run = "rbxassetid://135515454877967",
                jump = "rbxassetid://78508480717326", fall = "rbxassetid://78147885297412", climb = "rbxassetid://129447497744818", swim = "rbxassetid://110657013921774", swimidle = "rbxassetid://129183123083281",
            },
            ["Werewolf"] = {
                idle1 = "rbxassetid://10921330408", idle2 = "rbxassetid://10921333667", walk = "rbxassetid://10921342074", run = "rbxassetid://10921336997",
                jump = "", fall = "rbxassetid://10921337907", climb = "rbxassetid://10921329322", swim = "rbxassetid://10921340419", swimidle = "rbxassetid://10921341319",
            },
            ["Superhero"] = {
                idle1 = "rbxassetid://10921288909", idle2 = "rbxassetid://10921290167", walk = "rbxassetid://10921298616", run = "rbxassetid://10921291831",
                jump = "rbxassetid://10921294559", fall = "rbxassetid://10921293373", climb = "rbxassetid://10921286911", swim = "rbxassetid://10921295495", swimidle = "rbxassetid://10921297391",
            },
            ["Toy"] = {
                idle1 = "rbxassetid://10921301576", idle2 = "", walk = "rbxassetid://10921312010", run = "rbxassetid://10921306285",
                jump = "rbxassetid://10921308158", fall = "rbxassetid://10921307241", climb = "rbxassetid://10921300839", swim = "rbxassetid://10921309319", swimidle = "rbxassetid://10921310341",
            },
            ["No Boundaries"] = {
                idle1 = "rbxassetid://18747067405", idle2 = "rbxassetid://18747063918", walk = "rbxassetid://18747074203", run = "rbxassetid://18747070484",
                jump = "rbxassetid://18747069148", fall = "rbxassetid://18747062535", climb = "rbxassetid://18747060903", swim = "rbxassetid://18747073181", swimidle = "rbxassetid://18747071682",
            },
            ["NFL"] = {
                idle1 = "rbxassetid://92080889861410", idle2 = "rbxassetid://74451233229259", walk = "rbxassetid://110358958299415", run = "rbxassetid://117333533048078",
                jump = "rbxassetid://119846112151352", fall = "rbxassetid://129773241321032", climb = "rbxassetid://134630013742019", swim = "rbxassetid://132697394189921", swimidle = "rbxassetid://79090109939093",
            },
        }
    }

    -- FUNCIONES DEL SISTEMA
    local function apply(char)
        local anim = char:FindFirstChild("Animate")
        local pack = AnimSystem.Packs[AnimSystem.Selected]
        if not anim or not pack then return end
        local function s(f, c, id)
            if not id or id == "" then return end
            local folder = anim:FindFirstChild(f)
            local val = folder and folder:FindFirstChild(c)
            if val and val:IsA("Animation") then val.AnimationId = id end
        end
        s("idle", "Animation1", pack.idle1); s("idle", "Animation2", pack.idle2)
        s("walk", "WalkAnim", pack.walk); s("run", "RunAnim", pack.run)
        s("jump", "JumpAnim", pack.jump); s("fall", "FallAnim", pack.fall)
        s("climb", "ClimbAnim", pack.climb); s("swim", "Swim", pack.swim)
        s("swimidle", "SwimIdle", pack.swimidle)
    end

    local function save(char)
        local anim = char:FindFirstChild("Animate")
        if not anim then return end
        local function g(f, c)
            local folder = anim:FindFirstChild(f)
            local val = folder and folder:FindFirstChild(c)
            return val and val.AnimationId
        end
        local ids = {
            idle1 = g("idle", "Animation1"), idle2 = g("idle", "Animation2"),
            walk = g("walk", "WalkAnim"), run = g("run", "RunAnim"),
            jump = g("jump", "JumpAnim"), fall = g("fall", "FallAnim"),
            climb = g("climb", "ClimbAnim"), swim = g("swim", "Swim"),
            swimidle = g("swimidle", "SwimIdle")
        }
        local isCustom = false
        for _, p in pairs(AnimSystem.Packs) do if p.walk == ids.walk then isCustom = true; break end end
        if not isCustom then AnimSystem.Originals = ids end
    end

    local function restore(char)
        local anim = char:FindFirstChild("Animate")
        local orig = AnimSystem.Originals
        if not anim or not orig then return end
        local function s(f, c, id)
            if not id then return end
            local folder = anim:FindFirstChild(f)
            local val = folder and folder:FindFirstChild(c)
            if val and val:IsA("Animation") then val.AnimationId = id end
        end
        s("idle", "Animation1", orig.idle1); s("idle", "Animation2", orig.idle2)
        s("walk", "WalkAnim", orig.walk); s("run", "RunAnim", orig.run)
        s("jump", "JumpAnim", orig.jump); s("fall", "FallAnim", orig.fall)
        s("climb", "ClimbAnim", orig.climb); s("swim", "Swim", orig.swim)
        s("swimidle", "SwimIdle", orig.swimidle)
        local h = char:FindFirstChildOfClass("Humanoid")
        if h then for _, t in ipairs(h:GetPlayingAnimationTracks()) do pcall(function() t:Stop(0) end) end; pcall(function() h:ChangeState(Enum.HumanoidStateType.Running) end) end
    end

    _G.toggleAnimSystem = function(on)
        AnimSystem.Enabled = on
        if AnimSystem.Conn then AnimSystem.Conn:Disconnect(); AnimSystem.Conn = nil end
        local char = game.Players.LocalPlayer.Character
        if on then
            if char then pcall(save, char); pcall(apply, char); local h = char:FindFirstChildOfClass("Humanoid"); if h then for _, t in ipairs(h:GetPlayingAnimationTracks()) do pcall(function() t:Stop(0) end) end; pcall(function() h:ChangeState(Enum.HumanoidStateType.Running) end) end end
            AnimSystem.Conn = game:GetService("RunService").Heartbeat:Connect(function()
                if not AnimSystem.Enabled then return end
                local c = game.Players.LocalPlayer.Character
                if c then pcall(apply, c) end
            end)
        else
            if char then pcall(restore, char) end
        end
    end

    _G.setAnimPack = function(name)
        if AnimSystem.Packs[name] then
            AnimSystem.Selected = name
            if AnimSystem.Enabled then _G.toggleAnimSystem(true) end
        end
    end

    _G.getAnimPack = function() return AnimSystem.Selected end
    _G.getAnimPacks = function() local n={} for k,_ in pairs(AnimSystem.Packs) do table.insert(n,k) return n end end
end


repeat task.wait() until game:IsLoaded()
local Players, RunService, UIS, TS, Lighting, HS = game:GetService("Players"), game:GetService("RunService"), game:GetService("UserInputService"), game:GetService("TweenService"), game:GetService("Lighting"), game:GetService("HttpService")
local LP = Players.LocalPlayer

-- ====================== ANTI-DIE INSERTADO AQUÍ ======================
-- ========== ANTI-DIE ==========
local function activateAntiDie(char)
    char = char or LP.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then
        hum = char:WaitForChild("Humanoid", 5)
    end
    if not hum then return end

    pcall(function()
        hum.BreakJointsOnDeath = false
        hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
    end)

    if hum:GetAttribute("KzAntiDieHooked") then return end
    hum:SetAttribute("KzAntiDieHooked", true)

    hum:GetPropertyChangedSignal("Health"):Connect(function()
        if hum.Health <= 0 then
            pcall(function() hum.Health = hum.MaxHealth end)
        end
    end)

    hum.Died:Connect(function()
        task.wait()
        pcall(function()
            local newHum = Instance.new("Humanoid")
            newHum.Name = "ReplacedHumanoid"
            newHum.Parent = char
            if workspace.CurrentCamera then
                workspace.CurrentCamera.CameraSubject = newHum
            end
            if hum and hum.Parent then hum:Destroy() end
            task.defer(function()
                activateAntiDie(char)
            end)
        end)
    end)
end

-- Aplicar al personaje actual y a futuros respawns
task.spawn(function()
    if LP.Character then
        activateAntiDie(LP.Character)
    end
end)
LP.CharacterAdded:Connect(function(char)
    task.wait(0.1)
    activateAntiDie(char)
end)
-- ====================== FIN ANTI-DIE ================================

local NS, CS = 60, 29
local LAGGER_SPEED_1 = 20
local LAGGER_SPEED_2 = 10
local speedMode, antiRagdollEnabled = false, false
_G.__FROST_MOBILE_BUTTON_REFS = {}
_G.__FROST_UI_SIZE = _G.__FROST_UI_SIZE or 100
_G.__FROST_UI_SCALE_OBJ = nil
local jumpMode = 1
local jumpEnabled = false
local tpDownMode = 1
local laggerToggled = false
local laggerLevel = 1
local medusaCounterEnabled = false
local batCounterEnabled = false
local unwalkEnabled = false
local medusaDebounce, medusaLastUsed, dropActive = false, 0, false
local autoLeftEnabled, autoRightEnabled = false, false
local autoLeftSetVisual, autoRightSetVisual = nil, nil
local speedLabel = nil
local enemySpeedLabels = {}
local autoBatEnabled = false
local autoBatSetVisual = nil
local resetAutoBatMotion = nil
local AUTO_BAT_SPEED, AUTO_BAT_VERT_SPEED, AUTO_BAT_DIST, AUTO_BAT_V_OFF = 58, 52, -2.8, 1
local ALTURA_RELATIVA = 3.5
local AUTO_BAT_TURN_SPEED = 480
local AUTO_BAT_MAX_TURN_RATE = 60
local setBatCounterVisual = nil
local startBatCounter, stopBatCounter
local antiLagEnabled = false
local removeAccessoriesEnabled = false
local autoLeftWasEnabled = false
local autoRightWasEnabled = false
local dropBrainrotWasActive = false
local dropBrainrotSetVisual = nil

-- ====== STRETCH ======
local stretchEnabled = false
local stretchFOV = 120
local stretchConn = nil
local stretchFovConn = nil
local origFOV = 70

local medusaAutoResetEnabled = false
local medusaResetConns = {}
local setMedusaAutoResetVisual = nil

-- ====== LIMPIEZA TOTAL ======
local function stopAllBackgroundTasks()
    if movementLoop then movementLoop:Disconnect(); movementLoop = nil end
    if steppedConn then steppedConn:Disconnect(); steppedConn = nil end
    if enemySpeedConn then enemySpeedConn:Disconnect(); enemySpeedConn = nil end
    if stretchEnabled then disableStretch() end
    if stretchConn then stretchConn:Disconnect(); stretchConn = nil end
    if stretchFovConn then stretchFovConn:Disconnect(); stretchFovConn = nil end
    stopAntiRagdoll()
    stopJumpMode()
    stopBatCounter()
    stopMedusaCounter()
    stopMedusaAutoReset()
    stopAutoSteal()
    stopAutoTPDown()
    disableAutoBat()
    stopBypassAimbot()
    stopAutoLeft()
    stopAutoRight()
    if unwalkEnabled then stopUnwalk() end
    if antiLagEnabled then disableAntiLag() end
    if dropActive then stopDropBrainrot() end
    for _, t in ipairs(dropConnections) do
        if type(t) == "thread" then pcall(task.cancel, t)
        elseif type(t) == "RBXScriptConnection" then pcall(t.Disconnect, t) end
    end
    dropConnections = {}
    dropActive = false
    isStealing = false
    Steal.cachedPrompts = {}
    Steal.promptCacheTime = 0
    _hittingCooldown = false
    bypassHittingCooldown = false
    alPhase = 1
    arPhase = 1
    lastDropTime = 0
    medusaDebounce = false
    medusaLastUsed = 0
end

-- TRACERS
if tracersEnabled then 
    stopTracers() 
end

local function setMedusaCounterState(state)
    medusaCounterEnabled = state
    if state then
        if medusaAutoResetEnabled then
            medusaAutoResetEnabled = false
            if setMedusaAutoResetVisual then setMedusaAutoResetVisual(false) end
            stopMedusaAutoReset()
        end
        if LP.Character then setupMedusa(LP.Character) else stopMedusaCounter() end
    else
        stopMedusaCounter()
    end
    if setMedusaVisual then setMedusaVisual(state) end
end

local function setMedusaAutoResetState(state)
    medusaAutoResetEnabled = state
    if state then
        if medusaCounterEnabled then
            medusaCounterEnabled = false
            if setMedusaVisual then setMedusaVisual(false) end
            stopMedusaCounter()
        end
        if LP.Character then setupMedusaAutoReset(LP.Character) else stopMedusaAutoReset() end
    else
        stopMedusaAutoReset()
    end
    if setMedusaAutoResetVisual then setMedusaAutoResetVisual(state) end
end

local cursedResetRemote = nil
local CURSED_RESET_GUID = "f888ee6e-c86d-46e1-93d7-0639d6635d42"
local instaResetKeybind = {kb = Enum.KeyCode.G, gp = nil}
local setInstaResetVisual = nil
local instaResetFloatingButton = nil
local instaResetFloatingPos = nil
local insta_reset_cooldown = false

local function insta_reset()
    if insta_reset_cooldown then return end
    if not cursedResetRemote then
        for _, desc in ipairs(game:GetDescendants()) do
            if desc:IsA("RemoteEvent") and desc.Name:sub(1, 3) == "RE/" then
                cursedResetRemote = desc
                break
            end
        end
    end
    if not cursedResetRemote then return end
    insta_reset_cooldown = true
    local old_char = LP.Character
    if not old_char then
        insta_reset_cooldown = false
        return
    end
    task.spawn(function()
        while LP.Character == old_char do
            pcall(function()
                cursedResetRemote:FireServer(CURSED_RESET_GUID, LP, "balloon")
            end)
            task.wait()
        end
        insta_reset_cooldown = false
    end)
end

pcall(function()
    if hookfunction and newcclosure then
        local oldFire
        oldFire = hookfunction(Instance.new("RemoteEvent").FireServer, newcclosure(function(self, ...)
            if not cursedResetRemote and typeof(self) == "Instance" and self:IsA("RemoteEvent") and self.Name:sub(1,3) == "RE/" then
                cursedResetRemote = self
            end
            return oldFire(self, ...)
        end))
    end
end)

local function findCursedResetRemote()
    if cursedResetRemote then return end
    for _, desc in ipairs(game:GetDescendants()) do
        if desc:IsA("RemoteEvent") and desc.Name:sub(1,3) == "RE/" then
            cursedResetRemote = desc
            return
        end
    end
end

task.spawn(function()
    task.wait(2)
    findCursedResetRemote()
end)

local BAT_AIMBOT_SPEED = 58
local BYPASS_AIMBOT_SPEED = 60
local bypassToggled = false
local bypassFloatingButton = nil
local bypassFloatingPos = nil
local bypassMode = 1
local bypassModeBtnRef = nil
local dropMode = 1
local dropModeBtnRef = nil
local lastDropTime = 0
local BAT_V2_SWING_COOLDOWN = 0.1

local AP = {
    L1 = Vector3.new(-476.48, -6.28, 92.73),
    L2 = Vector3.new(-483.12, -4.95, 94.80),
    L_FACE = Vector3.new(-482.25, -4.96, 92.09),
    R1 = Vector3.new(-476.16, -6.52, 25.62),
    R2 = Vector3.new(-483.06, -5.03, 25.48),
    R_FACE = Vector3.new(-482.06, -6.93, 35.47),
}

-- ====== AUTO STEAL ======
local Steal = {
    AutoStealEnabled = true,  -- <--- CAMBIADO A true (siempre activado)
    StealRadius = 61.5,
    StealDuration = 1.37,
    Data = {},
    cachedPrompts = {},
    promptCacheTime = 0,
}
local isStealing = false
local stealStartTime = nil
local lastStealTick = 0
local STEAL_COOLDOWN = 0.1
local PROMPT_CACHE_REFRESH = 0.15

local Conns = {autoSteal = nil, batCounter = nil, anchor = {}, progress = nil,
    autoLeft = nil, autoRight = nil}
local progressFill = nil
local progressPct = nil
local progressRadLbl = nil
local pbFrame = nil

local function resetProgressBar()
    if progressPct then progressPct.Text = "0%" end
    if progressFill then progressFill.Size = UDim2.new(0, 0, 1, 0) end
end

local function isMyPlotByName(plotName)
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return false end
    local plot = plots:FindFirstChild(plotName)
    if not plot then return false end
    local sign = plot:FindFirstChild("PlotSign")
    if sign then
        local yb = sign:FindFirstChild("YourBase")
        if yb and yb:IsA("BillboardGui") then
            return yb.Enabled == true
        end
    end
    return false
end

local function findNearestPrompt()
    local char = LP.Character
    if not char then return nil, math.huge end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return nil, math.huge end

    local ct = tick()
    if ct - Steal.promptCacheTime < PROMPT_CACHE_REFRESH and #Steal.cachedPrompts > 0 then
        local np, nd = nil, math.huge
        for _, data in ipairs(Steal.cachedPrompts) do
            if data.prompt and data.prompt.Parent and data.prompt.Enabled ~= false then
                local dist = (data.spawn.Position - root.Position).Magnitude
                if dist <= Steal.StealRadius and dist < nd then
                    np = data.prompt
                    nd = dist
                end
            end
        end
        if np then return np, nd end
    end

    Steal.cachedPrompts = {}
    Steal.promptCacheTime = ct
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return nil, math.huge end

    local np, nd = nil, math.huge
    for _, plot in ipairs(plots:GetChildren()) do
        if not isMyPlotByName(plot.Name) then
            local pods = plot:FindFirstChild("AnimalPodiums")
            if pods then
                for _, pod in ipairs(pods:GetChildren()) do
                    pcall(function()
                        local base = pod:FindFirstChild("Base")
                        local spawn = base and base:FindFirstChild("Spawn")
                        if spawn then
                            local att = spawn:FindFirstChild("PromptAttachment")
                            if att then
                                for _, child in ipairs(att:GetChildren()) do
                                    if child:IsA("ProximityPrompt") and child.ActionText and child.ActionText:find("Steal") then
                                        local dist = (spawn.Position - root.Position).Magnitude
                                        table.insert(Steal.cachedPrompts, {prompt = child, spawn = spawn})
                                        if dist <= Steal.StealRadius and dist < nd then
                                            np = child
                                            nd = dist
                                        end
                                    end
                                end
                            end
                        end
                    end)
                end
            end
        end
    end
    return np, nd
end

local function executeSteal(prompt)
    local ct = tick()
    if ct - lastStealTick < STEAL_COOLDOWN then return end
    if isStealing then return end
    if not prompt or not prompt.Parent or prompt.Enabled == false then return end

    if not Steal.Data[prompt] then
        Steal.Data[prompt] = {hold = {}, trigger = {}, ready = true, useFallback = false}
        pcall(function()
            if getconnections then
                for _, c in ipairs(getconnections(prompt.PromptButtonHoldBegan)) do
                    if c.Function then table.insert(Steal.Data[prompt].hold, c.Function) end
                end
                for _, c in ipairs(getconnections(prompt.Triggered)) do
                    if c.Function then table.insert(Steal.Data[prompt].trigger, c.Function) end
                end
            else
                Steal.Data[prompt].useFallback = true
            end
        end)
    end
    local data = Steal.Data[prompt]
    if not data.ready then return end
    data.ready = false
    isStealing = true
    stealStartTime = ct
    lastStealTick = ct

    if Conns.progress then Conns.progress:Disconnect() end
    Conns.progress = RunService.Heartbeat:Connect(function()
        if not isStealing then
            Conns.progress:Disconnect()
            Conns.progress = nil
            return
        end
        local prog = math.clamp((tick() - stealStartTime) / Steal.StealDuration, 0, 1)
        if progressFill then progressFill.Size = UDim2.new(prog, 0, 1, 0) end
        if progressPct then progressPct.Text = math.floor(prog * 100) .. "%" end
    end)

    task.spawn(function()
        local ok = false
        pcall(function()
            if not data.useFallback and #data.hold > 0 then
                for _, fn in ipairs(data.hold) do task.spawn(function() pcall(fn) end) end
                task.wait(Steal.StealDuration)
                for _, fn in ipairs(data.trigger) do task.spawn(function() pcall(fn) end) end
                ok = true
            end
        end)
        if not ok and type(fireproximityprompt) == "function" then
            pcall(function() fireproximityprompt(prompt) end)
            ok = true
            task.wait(Steal.StealDuration)
        end
        if not ok then
            pcall(function()
                prompt:InputHoldBegin()
                task.wait(Steal.StealDuration)
                prompt:InputHoldEnd()
            end)
            ok = true
        end

        task.wait(Steal.StealDuration * 0.3)
        if Conns.progress then
            Conns.progress:Disconnect()
            Conns.progress = nil
        end
        resetProgressBar()
        task.wait(0.05)
        data.ready = true
        isStealing = false
    end)
end

local function startAutoSteal()
    if Conns.autoSteal then return end
    Conns.autoSteal = RunService.Heartbeat:Connect(function()
        if not Steal.AutoStealEnabled or isStealing then return end
        local p = findNearestPrompt()
        if p then
            executeSteal(p)
        else
            if progressPct and not isStealing then
                progressPct.Text = "0%"
            end
        end
    end)
end

local function stopAutoSteal()
    if Conns.autoSteal then
        Conns.autoSteal:Disconnect()
        Conns.autoSteal = nil
    end
    if Conns.progress then
        Conns.progress:Disconnect()
        Conns.progress = nil
    end
    isStealing = false
    lastStealTick = 0
    Steal.cachedPrompts = {}
    Steal.promptCacheTime = 0
    resetProgressBar()
end

-- ====== STRETCH ======
local function applyStretchFOV(val)
    local cam = workspace.CurrentCamera
    if cam then
        pcall(function() cam.FieldOfView = val end)
    end
end

local function enableStretch()
    if stretchConn then return end
    stretchEnabled = true
    local cam = workspace.CurrentCamera
    if not cam then return end
    origFOV = cam.FieldOfView or 70
    applyStretchFOV(stretchFOV)
    stretchConn = RunService.RenderStepped:Connect(function()
        if not stretchEnabled then
            stretchConn:Disconnect()
            stretchConn = nil
            return
        end
        local c = workspace.CurrentCamera
        if c then
            c.CFrame = c.CFrame * CFrame.new(0,0,0,1,0,0,0,0.7,0,0,0,1)
        end
    end)
    if stretchFovConn then stretchFovConn:Disconnect() end
    stretchFovConn = RunService.RenderStepped:Connect(function()
        if stretchEnabled then
            applyStretchFOV(stretchFOV)
        else
            stretchFovConn:Disconnect()
            stretchFovConn = nil
        end
    end)
end

local function disableStretch()
    stretchEnabled = false
    if stretchConn then
        stretchConn:Disconnect()
        stretchConn = nil
    end
    if stretchFovConn then
        stretchFovConn:Disconnect()
        stretchFovConn = nil
    end
    local cam = workspace.CurrentCamera
    if cam then
        pcall(function() cam.FieldOfView = origFOV or 70 end)
    end
end

-- ====== ENEMY SPEED ======
local enemySpeedConn = nil
local function updateEnemySpeedLabels()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LP then
            local char = player.Character
            if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChildOfClass("Humanoid") and char:FindFirstChildOfClass("Humanoid").Health > 0 then
                local hrp = char:FindFirstChild("HumanoidRootPart")
                local velocity = hrp.AssemblyLinearVelocity
                local speed = (Vector3.new(velocity.X, 0, velocity.Z).Magnitude)
                local label = enemySpeedLabels[player]
                if not label then
                    local head = char:FindFirstChild("Head")
                    if head then
                        local bb = Instance.new("BillboardGui", head)
                        bb.Size = UDim2.new(0, 100, 0, 25)
                        bb.StudsOffset = Vector3.new(0, 3.5, 0)
                        bb.AlwaysOnTop = true
                        bb.Name = "EnemySpeedGui"
                        local textLabel = Instance.new("TextLabel", bb)
                        textLabel.Size = UDim2.new(1, 0, 1, 0)
                        textLabel.BackgroundTransparency = 1
                        textLabel.Text = string.format("%.1f", speed)
                        textLabel.TextColor3 = Color3.fromRGB(255, 255, 255) -- BLANCO
                        textLabel.Font = Enum.Font.FredokaOne
                        textLabel.TextScaled = true
                        textLabel.TextStrokeTransparency = 0
                        textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                        label = textLabel
                        enemySpeedLabels[player] = label
                    end
                elseif label and label.Parent and label.Parent.Parent ~= char then
                    local head = char:FindFirstChild("Head")
                    if head then
                        label.Parent.Parent = head
                    end
                end
                if label then
                    label.Text = string.format("%.1f", speed)
                end
            else
                local label = enemySpeedLabels[player]
                if label and label.Parent and label.Parent.Parent then
                    label.Parent.Parent = nil
                end
                enemySpeedLabels[player] = nil
            end
        end
    end
    for player, label in pairs(enemySpeedLabels) do
        if not player or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
            if label and label.Parent and label.Parent.Parent then
                label.Parent.Parent = nil
            end
            enemySpeedLabels[player] = nil
        end
    end
end

local function startEnemySpeed()
    if enemySpeedConn then enemySpeedConn:Disconnect() end
    enemySpeedConn = RunService.Heartbeat:Connect(function()
        updateEnemySpeedLabels()
    end)
end

local uiLocked = false
local MobilePanel = nil

local MobileButtons = {
    Visible = true,
    Frame = nil,
    Buttons = {}
}
local mobSetAutoBat, mobSetAutoLeft, mobSetAutoRight
local mobSetDropBR, mobSetTpDown, mobSetCarry, mobSetLagger1, mobSetLagger2
local antiLagDescConn = nil
local unwalkSavedAnimate = nil
local _anyKeyListening = false
local autoTPHeight = 20

local KB = {
    DropBrainrot={kb=Enum.KeyCode.X,gp=nil},
    AutoLeft    ={kb=Enum.KeyCode.Z,gp=nil},
    AutoRight   ={kb=Enum.KeyCode.C,gp=nil},
    AutoBat     ={kb=Enum.KeyCode.E,gp=nil},
    TPFloor     ={kb=Enum.KeyCode.F,gp=nil},
    GuiHide     ={kb=Enum.KeyCode.LeftControl,gp=nil},
    CarryToggle={kb=Enum.KeyCode.Q,gp=nil},
    LaggerMode  ={kb=Enum.KeyCode.R,gp=nil},
    AutoTPDown  ={kb=Enum.KeyCode.T,gp=nil},
    InstaReset  ={kb=Enum.KeyCode.G,gp=nil},
    JumpMode    ={kb=Enum.KeyCode.V,gp=nil},
    Bypass      ={kb=Enum.KeyCode.N,gp=nil},  -- Tecla para Anti‑Desync (modo 2)
}

local GAMEPAD_KEYS={
    [Enum.KeyCode.ButtonA]=true,[Enum.KeyCode.ButtonB]=true,[Enum.KeyCode.ButtonX]=true,[Enum.KeyCode.ButtonY]=true,
    [Enum.KeyCode.ButtonL1]=true,[Enum.KeyCode.ButtonR1]=true,[Enum.KeyCode.ButtonL2]=true,[Enum.KeyCode.ButtonR2]=true,
    [Enum.KeyCode.ButtonL3]=true,[Enum.KeyCode.ButtonR3]=true,[Enum.KeyCode.ButtonStart]=true,[Enum.KeyCode.ButtonSelect]=true,
    [Enum.KeyCode.DPadUp]=true,[Enum.KeyCode.DPadDown]=true,[Enum.KeyCode.DPadLeft]=true,[Enum.KeyCode.DPadRight]=true
}

local function isGamepadInput(inp)
    return inp and inp.UserInputType and inp.UserInputType.Name:match("^Gamepad") ~= nil
end

local function isBindableInput(inp)
    if not inp or inp.KeyCode == Enum.KeyCode.Unknown then return false end
    if inp.UserInputType == Enum.UserInputType.Keyboard then return true end
    return isGamepadInput(inp) and GAMEPAD_KEYS[inp.KeyCode] == true
end

local function kbMatch(entry, kc)
    return kc and (kc == entry.kb or (entry.gp and kc == entry.gp))
end

local lastMoveDir = Vector3.new(0,0,0)

local MOVE_KEYS={[Enum.KeyCode.W]=true,[Enum.KeyCode.A]=true,[Enum.KeyCode.S]=true,[Enum.KeyCode.D]=true,
    [Enum.KeyCode.Up]=true,[Enum.KeyCode.Left]=true,[Enum.KeyCode.Down]=true,[Enum.KeyCode.Right]=true}

local steppedConn = nil
local movementLoop = nil

steppedConn = RunService.Stepped:Connect(function()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and p.Character then
            for _, part in ipairs(p.Character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end
end)

movementLoop = RunService.RenderStepped:Connect(function()
    local char = LP.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp then return end
    if not autoBatEnabled and not bypassToggled and not autoLeftEnabled and not autoRightEnabled then
        local md = hum.MoveDirection
        local spd
        if laggerToggled then
            spd = (laggerLevel == 2) and LAGGER_SPEED_2 or LAGGER_SPEED_1
        else
            spd = speedMode and CS or NS
        end
        
        -- ====== SPEED UNPATCH (CRÍTICO) ======
        if hum.WalkSpeed ~= spd then
            hum.WalkSpeed = spd
        end
        -- ====================================
        
        if md.Magnitude > 0 then
            lastMoveDir = md
            hrp.Velocity = Vector3.new(md.X * spd, hrp.Velocity.Y, md.Z * spd)
        elseif antiRagdollEnabled and lastMoveDir.Magnitude > 0 then
            local anyHeld = false
            for key in pairs(MOVE_KEYS) do
                if UIS:IsKeyDown(key) then anyHeld = true; break end
            end
            if anyHeld then
                hrp.Velocity = Vector3.new(lastMoveDir.X * spd, hrp.Velocity.Y, lastMoveDir.Z * spd)
            end
        end
    end
    if speedLabel then
        speedLabel.Text = string.format("%.1f", Vector3.new(hrp.Velocity.X, 0, hrp.Velocity.Z).Magnitude)
    end
end)


local alConn, arConn = nil, nil
local alPhase, arPhase = 1, 1

local function stopAutoLeft()
    if alConn then alConn:Disconnect(); alConn = nil end
    alPhase = 1
    local char = LP.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum:Move(Vector3.zero, false) end
    end
    if autoLeftSetVisual then autoLeftSetVisual(false) end
    if mobSetAutoLeft then mobSetAutoLeft(false) end
end

local function stopAutoRight()
    if arConn then arConn:Disconnect(); arConn = nil end
    arPhase = 1
    local char = LP.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum:Move(Vector3.zero, false) end
    end
    if autoRightSetVisual then autoRightSetVisual(false) end
    if mobSetAutoRight then mobSetAutoRight(false) end
end

local function disableAllAimbots()
    if autoBatEnabled then
        disableAutoBat()
        if autoBatSetVisual then autoBatSetVisual(false) end
        if mobSetAutoBat then mobSetAutoBat(false) end
    end
    if bypassToggled then
        toggleBypass(false)
    end
end

function startAutoLeft()
    if autoRightEnabled then
        autoRightEnabled = false
        stopAutoRight()
        if autoRightSetVisual then autoRightSetVisual(false) end
        if mobSetAutoRight then mobSetAutoRight(false) end
    end
    disableAllAimbots()
    if alConn then alConn:Disconnect() end
    alPhase = 1
    alConn = RunService.Heartbeat:Connect(function()
        if not autoLeftEnabled then return end
        local char = LP.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not root or not hum then return end
        local spd = NS
        if alPhase == 1 then
            local tgt = Vector3.new(AP.L1.X, root.Position.Y, AP.L1.Z)
            if (tgt - root.Position).Magnitude < 1 then
                alPhase = 2
                local d = AP.L2 - root.Position
                local mv = Vector3.new(d.X, 0, d.Z).Unit
                hum:Move(mv, false)
                root.AssemblyLinearVelocity = Vector3.new(mv.X * spd, root.AssemblyLinearVelocity.Y, mv.Z * spd)
                return
            end
            local d = AP.L1 - root.Position
            local mv = Vector3.new(d.X, 0, d.Z).Unit
            hum:Move(mv, false)
            root.AssemblyLinearVelocity = Vector3.new(mv.X * spd, root.AssemblyLinearVelocity.Y, mv.Z * spd)
        elseif alPhase == 2 then
            local tgt = Vector3.new(AP.L2.X, root.Position.Y, AP.L2.Z)
            if (tgt - root.Position).Magnitude < 1 then
                hum:Move(Vector3.zero, false)
                root.AssemblyLinearVelocity = Vector3.zero
                autoLeftEnabled = false
                if alConn then alConn:Disconnect(); alConn = nil end
                alPhase = 1
                if autoLeftSetVisual then autoLeftSetVisual(false) end
                if mobSetAutoLeft then mobSetAutoLeft(false) end
                local facePos = Vector3.new(AP.L_FACE.X, root.Position.Y, AP.L_FACE.Z)
                if (facePos - root.Position).Magnitude > 0.01 then
                    root.CFrame = CFrame.new(root.Position, facePos)
                end
                return
            end
            local d = AP.L2 - root.Position
            local mv = Vector3.new(d.X, 0, d.Z).Unit
            hum:Move(mv, false)
            root.AssemblyLinearVelocity = Vector3.new(mv.X * spd, root.AssemblyLinearVelocity.Y, mv.Z * spd)
        end
    end)
end

function startAutoRight()
    if autoLeftEnabled then
        autoLeftEnabled = false
        stopAutoLeft()
        if autoLeftSetVisual then autoLeftSetVisual(false) end
        if mobSetAutoLeft then mobSetAutoLeft(false) end
    end
    disableAllAimbots()
    if arConn then arConn:Disconnect() end
    arPhase = 1
    arConn = RunService.Heartbeat:Connect(function()
        if not autoRightEnabled then return end
        local char = LP.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not root or not hum then return end
        local spd = NS
        if arPhase == 1 then
            local tgt = Vector3.new(AP.R1.X, root.Position.Y, AP.R1.Z)
            if (tgt - root.Position).Magnitude < 1 then
                arPhase = 2
                local d = AP.R2 - root.Position
                local mv = Vector3.new(d.X, 0, d.Z).Unit
                hum:Move(mv, false)
                root.AssemblyLinearVelocity = Vector3.new(mv.X * spd, root.AssemblyLinearVelocity.Y, mv.Z * spd)
                return
            end
            local d = AP.R1 - root.Position
            local mv = Vector3.new(d.X, 0, d.Z).Unit
            hum:Move(mv, false)
            root.AssemblyLinearVelocity = Vector3.new(mv.X * spd, root.AssemblyLinearVelocity.Y, mv.Z * spd)
        elseif arPhase == 2 then
            local tgt = Vector3.new(AP.R2.X, root.Position.Y, AP.R2.Z)
            if (tgt - root.Position).Magnitude < 1 then
                hum:Move(Vector3.zero, false)
                root.AssemblyLinearVelocity = Vector3.zero
                autoRightEnabled = false
                if arConn then arConn:Disconnect(); arConn = nil end
                arPhase = 1
                if autoRightSetVisual then autoRightSetVisual(false) end
                if mobSetAutoRight then mobSetAutoRight(false) end
                local facePos = Vector3.new(AP.R_FACE.X, root.Position.Y, AP.R_FACE.Z)
                if (facePos - root.Position).Magnitude > 0.01 then
                    root.CFrame = CFrame.new(root.Position, facePos)
                end
                return
            end
            local d = AP.R2 - root.Position
            local mv = Vector3.new(d.X, 0, d.Z).Unit
            hum:Move(mv, false)
            root.AssemblyLinearVelocity = Vector3.new(mv.X * spd, root.AssemblyLinearVelocity.Y, mv.Z * spd)
        end
    end)
end

local function startUnwalk()
    local c = LP.Character
    if not c then return end
    local hum = c:FindFirstChildOfClass("Humanoid")
    if hum then
        for _, t in ipairs(hum:GetPlayingAnimationTracks()) do
            pcall(function() t:Stop() end)
        end
    end
    local anim = c:FindFirstChild("Animate")
    if anim then
        unwalkSavedAnimate = anim:Clone()
        anim:Destroy()
    end
end

local function stopUnwalk()
    local c = LP.Character
    if c then
        local existing = c:FindFirstChild("Animate")
        if not existing then
            local src = game:GetService("StarterPlayer"):FindFirstChildOfClass("StarterCharacterScripts")
            local starterAnim = src and src:FindFirstChild("Animate")
            if starterAnim then
                starterAnim:Clone().Parent = c
            elseif unwalkSavedAnimate then
                unwalkSavedAnimate:Clone().Parent = c
            end
        end
    end
    unwalkSavedAnimate = nil
end

local function setupSpeedIndicator(char)
    local head = char:WaitForChild("Head", 5)
    if not head then return end
    local oldBB = head:FindFirstChild("drakauhubSpeedIndicator")
    if oldBB then oldBB:Destroy() end
    local bb = Instance.new("BillboardGui", head)
    bb.Name = "drakauhubSpeedIndicator"
    bb.Size = UDim2.new(0, 180, 0, 56)
    bb.StudsOffset = Vector3.new(0, 3.2, 0)
    bb.AlwaysOnTop = true
    local titleLabel = Instance.new("TextLabel", bb)
    titleLabel.Size = UDim2.new(1, 0, 0, 24)
    titleLabel.Position = UDim2.new(0, 0, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "Drakau Hub"
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255) -- BLANCO
    titleLabel.Font = Enum.Font.FredokaOne
    titleLabel.TextSize = 18
    titleLabel.TextScaled = false
    titleLabel.TextStrokeTransparency = 0
    titleLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    speedLabel = Instance.new("TextLabel", bb)
    speedLabel.Size = UDim2.new(1, 0, 0, 26)
    speedLabel.Position = UDim2.new(0, 0, 0, 24)
    speedLabel.BackgroundTransparency = 1
    speedLabel.Text = "0.0"
    speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255) -- BLANCO
    speedLabel.Font = Enum.Font.FredokaOne
    speedLabel.TextScaled = true
    speedLabel.TextStrokeTransparency = 0
    speedLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
end

-- ============================================================
-- NUEVO ANTI‑RAGDOLL (versión mejorada)
-- ============================================================
local antiRagdollConn = nil

local function resetAntiRagdollCharacter(char)
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not hum or not root or hum.Health <= 0 then return end

    pcall(function()
        hum:ChangeState(Enum.HumanoidStateType.GettingUp)
        hum:ChangeState(Enum.HumanoidStateType.Running)

        root.Velocity = Vector3.zero
        root.RotVelocity = Vector3.zero

        hum.PlatformStand = false
        hum.Sit = false
        hum.AutoRotate = true
        if hum.JumpPower == 0 then hum.JumpPower = 50 end
        if hum.WalkSpeed == 0 then hum.WalkSpeed = 16 end

        for _, obj in ipairs(char:GetDescendants()) do
            if obj:IsA("Motor6D") then
                obj.Enabled = true
            elseif obj:IsA("Constraint") or obj:IsA("BallSocketConstraint") or obj:IsA("HingeConstraint") then
                obj.Enabled = true
            elseif obj:IsA("BasePart") then
                obj.CanCollide = true
                obj.Velocity = Vector3.zero
                obj.RotVelocity = Vector3.zero
            end
        end

        workspace.CurrentCamera.CameraSubject = hum

        local playerModule = LP.PlayerScripts:FindFirstChild("PlayerModule")
        if playerModule then
            local controlModule = playerModule:FindFirstChild("ControlModule")
            if controlModule then
                local success, module = pcall(require, controlModule)
                if success and module and module.Enable then
                    module:Enable()
                end
            end
        end
    end)
end

function startAntiRagdoll()
    if antiRagdollConn then return end

    antiRagdollConn = RunService.Heartbeat:Connect(function()
        if not antiRagdollEnabled then
            stopAntiRagdoll()
            return
        end

        local char = LP.Character
        if not char then return end

        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then return end

        local state = hum:GetState()

        if state == Enum.HumanoidStateType.Physics
            or state == Enum.HumanoidStateType.Ragdoll
            or state == Enum.HumanoidStateType.FallingDown
            or state == Enum.HumanoidStateType.Dead
            or hum.PlatformStand == true
            or hum.Sit == true then

            resetAntiRagdollCharacter(char)
        end
    end)
end

function stopAntiRagdoll()
    if antiRagdollConn then
        antiRagdollConn:Disconnect()
        antiRagdollConn = nil
    end
end
-- ============================================================

local MEDUSA_COOLDOWN = 25

local function findMedusa()
    local c = LP.Character
    if not c then return nil end
    for _, t in ipairs(c:GetChildren()) do
        if t:IsA("Tool") then
            local n = t.Name:lower()
            if n:find("medusa") or n:find("head") or n:find("stone") then return t end
        end
    end
    local bp = LP:FindFirstChild("Backpack")
    if bp then
        for _, t in ipairs(bp:GetChildren()) do
            if t:IsA("Tool") then
                local n = t.Name:lower()
                if n:find("medusa") or n:find("head") or n:find("stone") then return t end
            end
        end
    end
    return nil
end

local function useMedusaCounter()
    if medusaDebounce then return end
    if tick() - medusaLastUsed < MEDUSA_COOLDOWN then return end
    local c = LP.Character
    if not c then return end
    medusaDebounce = true
    local med = findMedusa()
    if not med then medusaDebounce = false; return end
    if med.Parent ~= c then
        local hum2 = c:FindFirstChildOfClass("Humanoid")
        if hum2 then hum2:EquipTool(med) end
    end
    pcall(function() med:Activate() end)
    medusaLastUsed = tick()
    medusaDebounce = false
end

local function onAnchorChanged(part)
    return part:GetPropertyChangedSignal("Anchored"):Connect(function()
        if medusaCounterEnabled and part.Anchored and part.Transparency == 1 then useMedusaCounter() end
    end)
end

local function setupMedusa(char)
    for _, c in pairs(Conns.anchor) do pcall(function() c:Disconnect() end) end
    Conns.anchor = {}
    if not char or not medusaCounterEnabled then return end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            table.insert(Conns.anchor, onAnchorChanged(part))
        end
    end
    table.insert(Conns.anchor, char.DescendantAdded:Connect(function(part)
        if part:IsA("BasePart") then
            table.insert(Conns.anchor, onAnchorChanged(part))
        end
    end))
end

local function stopMedusaCounter()
    for _, c in pairs(Conns.anchor) do pcall(function() c:Disconnect() end) end
    Conns.anchor = {}
end

local function onMedusaResetAnchorChanged(part)
    return part:GetPropertyChangedSignal("Anchored"):Connect(function()
        if medusaAutoResetEnabled and part.Anchored and part.Transparency == 1 then
            insta_reset()
        end
    end)
end

local function setupMedusaAutoReset(char)
    for _, c in pairs(medusaResetConns) do pcall(function() c:Disconnect() end) end
    medusaResetConns = {}
    if not char or not medusaAutoResetEnabled then return end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            table.insert(medusaResetConns, onMedusaResetAnchorChanged(part))
        end
    end
    table.insert(medusaResetConns, char.DescendantAdded:Connect(function(part)
        if part:IsA("BasePart") then
            table.insert(medusaResetConns, onMedusaResetAnchorChanged(part))
        end
    end))
end

local function stopMedusaAutoReset()
    for _, c in pairs(medusaResetConns) do pcall(function() c:Disconnect() end) end
    medusaResetConns = {}
end

local dropConnections = {}

local function runDropBrainrot()
    if dropActive then return end
    local char = LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local speedH = 0
    if root then
        local vel = root.AssemblyLinearVelocity
        speedH = Vector3.new(vel.X, 0, vel.Z).Magnitude
    end
    local cooldown = 0.25
    if dropMode == 1 then
        if speedH > 5 then
            cooldown = 0.6
        else
            cooldown = 0.25
        end
    end
    if tick() - lastDropTime < cooldown then return end
    lastDropTime = tick()
    dropActive = true
    if dropBrainrotSetVisual then dropBrainrotSetVisual(true) end
    if mobSetDropBR then mobSetDropBR(true) end
    local wasAutoBat = false
    if autoBatEnabled then
        wasAutoBat = true
        disableAutoBat()
        if autoBatSetVisual then autoBatSetVisual(false) end
        if mobSetAutoBat then mobSetAutoBat(false) end
    end
    local function finishDrop()
        dropActive = false
        local c = LP.Character
        if c then
            local root = c:FindFirstChild("HumanoidRootPart")
            local hum = c:FindFirstChildOfClass("Humanoid")
            if root then
                root.AssemblyLinearVelocity = Vector3.zero
                root.AssemblyAngularVelocity = Vector3.zero
                if root.Position.Y < -100 then
                    root.CFrame = CFrame.new(root.Position.X, 5, root.Position.Z)
                end
                local rp = RaycastParams.new()
                rp.FilterDescendantsInstances = {c}
                rp.FilterType = Enum.RaycastFilterType.Exclude
                local rr = workspace:Raycast(root.Position, Vector3.new(0, -2000, 0), rp)
                if rr then
                    local off = (hum and hum.HipHeight or 2) + (root.Size.Y / 2)
                    root.CFrame = CFrame.new(root.Position.X, rr.Position.Y + off, root.Position.Z)
                end
                if hum and hum.Health > 0 then
                    hum:ChangeState(Enum.HumanoidStateType.Running)
                end
                task.wait(0.05)
                root.AssemblyLinearVelocity = Vector3.zero
                root.AssemblyAngularVelocity = Vector3.zero
                task.wait(0.05)
                root.AssemblyLinearVelocity = Vector3.zero
                root.AssemblyAngularVelocity = Vector3.zero
                root.AssemblyLinearVelocity = Vector3.new(0, -1, 0)
                task.wait(0.03)
                root.AssemblyLinearVelocity = Vector3.zero
                if root.Position.Y < -100 then
                    root.CFrame = CFrame.new(root.Position.X, 5, root.Position.Z)
                end
            end
        end
        if wasAutoBat then
            enableAutoBat()
            if autoBatSetVisual then autoBatSetVisual(true) end
            if mobSetAutoBat then mobSetAutoBat(true) end
        end
        if dropBrainrotSetVisual then dropBrainrotSetVisual(false) end
        if mobSetDropBR then mobSetDropBR(false) end
    end
    if dropMode == 1 then
        local flingThread = task.spawn(function()
            local startTime = tick()
            while dropActive and (tick() - startTime) < 0.25 do
                RunService.Heartbeat:Wait()
                local c = LP.Character
                local root = c and c:FindFirstChild("HumanoidRootPart")
                if not root then break end
                local vel = root.AssemblyLinearVelocity
                vel = Vector3.new(0, vel.Y, 0)
                root.AssemblyLinearVelocity = vel * 10000 + Vector3.new(0, 10000, 0)
                RunService.RenderStepped:Wait()
                if root and root.Parent then
                    root.AssemblyLinearVelocity = vel
                end
                RunService.Stepped:Wait()
                if root and root.Parent then
                    root.AssemblyLinearVelocity = vel + Vector3.new(0, 0.1, 0)
                end
            end
            finishDrop()
        end)
        table.insert(dropConnections, flingThread)
        task.delay(0.35, function()
            if dropActive then
                dropActive = false
                finishDrop()
            end
        end)
    else
        local conn = nil
        local startTime = tick()
        conn = RunService.Heartbeat:Connect(function()
            if not dropActive then
                conn:Disconnect()
                return
            end
            local c = LP.Character
            local root = c and c:FindFirstChild("HumanoidRootPart")
            if not root then
                conn:Disconnect()
                finishDrop()
                return
            end
            local elapsed = tick() - startTime
            if elapsed >= 0.2 then
                conn:Disconnect()
                local rp = RaycastParams.new()
                rp.FilterDescendantsInstances = {c}
                rp.FilterType = Enum.RaycastFilterType.Exclude
                local rr = workspace:Raycast(root.Position, Vector3.new(0, -2000, 0), rp)
                if rr then
                    local hum = c:FindFirstChildOfClass("Humanoid")
                    local off = (hum and hum.HipHeight or 2) + (root.Size.Y / 2)
                    root.CFrame = CFrame.new(root.Position.X, rr.Position.Y + off, root.Position.Z)
                    root.AssemblyLinearVelocity = Vector3.zero
                end
                finishDrop()
                return
            end
            root.AssemblyLinearVelocity = Vector3.new(root.AssemblyLinearVelocity.X, 150, root.AssemblyLinearVelocity.Z)
        end)
        table.insert(dropConnections, conn)
    end
end

local function stopDropBrainrot()
    dropActive = false
    for _, t in ipairs(dropConnections) do
        if type(t) == "thread" then
            pcall(task.cancel, t)
        elseif type(t) == "RBXScriptConnection" then
            pcall(t.Disconnect, t)
        end
    end
    dropConnections = {}
    local c = LP.Character
    if c then
        local root = c:FindFirstChild("HumanoidRootPart")
        if root then
            root.AssemblyLinearVelocity = Vector3.zero
        end
    end
    if dropBrainrotSetVisual then dropBrainrotSetVisual(false) end
    if mobSetDropBR then mobSetDropBR(false) end
end

local function executeDropWithToggle(setVisual)
    if dropActive then return end
    task.spawn(function()
        if setVisual then setVisual(true) end
        runDropBrainrot()
        while dropActive do task.wait() end
        task.wait(0.1)
        if setVisual then setVisual(false) end
    end)
end

local infJumpConn = nil
local holdJumpConn = nil
local holdJumpJumpConn = nil

local function startJumpMode()
    if not jumpEnabled then return end
    if jumpMode == 1 then
        if infJumpConn then infJumpConn:Disconnect() end
        infJumpConn = UIS.JumpRequest:Connect(function()
            local char = LP.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if root then
                root.Velocity = Vector3.new(root.Velocity.X, 56, root.Velocity.Z)
            end
        end)
        if holdJumpConn then holdJumpConn:Disconnect(); holdJumpConn = nil end
        if holdJumpJumpConn then holdJumpJumpConn:Disconnect(); holdJumpJumpConn = nil end
    else
        if holdJumpJumpConn then holdJumpJumpConn:Disconnect() end
        holdJumpJumpConn = UIS.JumpRequest:Connect(function()
            local char = LP.Character
            if not char then return end
            local root = char:FindFirstChild("HumanoidRootPart")
            if root then
                root.Velocity = Vector3.new(root.Velocity.X, 54, root.Velocity.Z)
            end
        end)
        if holdJumpConn then holdJumpConn:Disconnect() end
        holdJumpConn = RunService.Heartbeat:Connect(function()
            if autoBatEnabled or bypassToggled then return end
            local char = LP.Character
            if not char then return end
            local root = char:FindFirstChild("HumanoidRootPart")
            if not root then return end
            local hum = char:FindFirstChildOfClass("Humanoid")
            local jumpHeld = UIS:IsKeyDown(Enum.KeyCode.Space) or (hum and hum.Jump == true)
            if jumpHeld and root.Velocity.Y < 30 then
                root.Velocity = Vector3.new(root.Velocity.X, 54, root.Velocity.Z)
            end
            if root.Velocity.Y < -120 then
                root.Velocity = Vector3.new(root.Velocity.X, -120, root.Velocity.Z)
            end
        end)
        if infJumpConn then infJumpConn:Disconnect(); infJumpConn = nil end
    end
end

local function stopJumpMode()
    if infJumpConn then infJumpConn:Disconnect(); infJumpConn = nil end
    if holdJumpConn then holdJumpConn:Disconnect(); holdJumpConn = nil end
    if holdJumpJumpConn then holdJumpJumpConn:Disconnect(); holdJumpJumpConn = nil end
end

RunService.Heartbeat:Connect(function()
    if not jumpEnabled then return end
    local char = LP.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if root and root.Velocity.Y < -120 then
        root.Velocity = Vector3.new(root.Velocity.X, -120, root.Velocity.Z)
    end
end)

local defLightBrightness,defLightClock,defLightAmbient,defGlobalShadows,defFogEnd

local function applyAntiLagDerender(obj)
    pcall(function()
        if obj:IsA("Accessory") or obj:IsA("Hat") then obj:Destroy()
        elseif obj:IsA("BasePart") then
            obj.Material = Enum.Material.Plastic
            obj.Reflectance = 0
            obj.CastShadow = false
        elseif obj:IsA("Decal") or obj:IsA("Texture") then
            obj.Transparency = 1
        elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then
            obj.Enabled = false
        elseif obj:IsA("AnimationController") or obj:IsA("Animator") then
            for _, t in ipairs(obj:GetPlayingAnimationTracks()) do
                pcall(function() t:Stop(0) end)
            end
        end
    end)
end

local function enableAntiLag()
    removeAccessoriesEnabled = true
    antiLagEnabled = true
    if defLightBrightness == nil then
        defLightBrightness = Lighting.Brightness
    end
    if defLightClock == nil then
        defLightClock = Lighting.ClockTime
    end
    if defLightAmbient == nil then
        defLightAmbient = Lighting.OutdoorAmbient
    end
    if defGlobalShadows == nil then
        defGlobalShadows = Lighting.GlobalShadows
    end
    if defFogEnd == nil then
        defFogEnd = Lighting.FogEnd
    end
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 1e10
    Lighting.Brightness = 0
    for _, e in pairs(Lighting:GetChildren()) do
        pcall(function()
            if e:IsA("BlurEffect") or e:IsA("SunRaysEffect") or
               e:IsA("ColorCorrectionEffect") or e:IsA("BloomEffect") or
               e:IsA("DepthOfFieldEffect") then
                e.Enabled = false
            end
        end)
    end
    for _, obj in ipairs(workspace:GetDescendants()) do
        applyAntiLagDerender(obj)
    end
    if antiLagDescConn then antiLagDescConn:Disconnect() end
    antiLagDescConn = workspace.DescendantAdded:Connect(function(obj)
        if removeAccessoriesEnabled then
            applyAntiLagDerender(obj)
        end
    end)
end

local function disableAntiLag()
    removeAccessoriesEnabled = false
    antiLagEnabled = false
    if antiLagDescConn then
        antiLagDescConn:Disconnect()
        antiLagDescConn = nil
    end
    if defLightBrightness ~= nil then
        Lighting.Brightness = defLightBrightness
    end
    if defLightClock ~= nil then
        Lighting.ClockTime = defLightClock
    end
    if defLightAmbient ~= nil then
        Lighting.OutdoorAmbient = defLightAmbient
    end
    if defGlobalShadows ~= nil then
        Lighting.GlobalShadows = defGlobalShadows
    end
    if defFogEnd ~= nil then
        Lighting.FogEnd = defFogEnd
    end
    for _, e in pairs(Lighting:GetChildren()) do
        pcall(function()
            if e:IsA("BlurEffect") or e:IsA("SunRaysEffect") or
               e:IsA("ColorCorrectionEffect") or e:IsA("BloomEffect") or
               e:IsA("DepthOfFieldEffect") then
                e.Enabled = true
            end
        end)
    end
end

local batCounterDebounce = false
local BAT_COUNTER_SLAP_LIST = {"Bat","Slap","Iron Slap","Gold Slap","Diamond Slap","Emerald Slap","Ruby Slap","Dark Matter Slap","Flame Slap","Nuclear Slap","Galaxy Slap","Glitched Slap"}

local function findBatForCounter()
    local char = LP.Character
    if not char then return nil end
    local backpack = LP:FindFirstChildOfClass("Backpack")
    for _, name in ipairs(BAT_COUNTER_SLAP_LIST) do
        local tool = char:FindFirstChild(name) or (backpack and backpack:FindFirstChild(name))
        if tool then return tool end
    end
    for _, child in ipairs(char:GetChildren()) do
        if child:IsA("Tool") and (child.Name:lower():find("bat") or child.Name:lower():find("slap")) then
            return child
        end
    end
    if backpack then
        for _, child in ipairs(backpack:GetChildren()) do
            if child:IsA("Tool") and (child.Name:lower():find("bat") or child.Name:lower():find("slap")) then
                return child
            end
        end
    end
    return nil
end

local function swingBatForCounter(bat, character)
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if bat.Parent ~= character and humanoid then
        pcall(function() humanoid:EquipTool(bat) end)
        task.wait(0.05)
    end
    local remote = bat:FindFirstChildOfClass("RemoteEvent") or bat:FindFirstChildOfClass("RemoteFunction")
    if remote and remote:IsA("RemoteEvent") then
        pcall(function() remote:FireServer() end)
        task.wait(0.15)
        pcall(function() remote:FireServer() end)
    else
        pcall(function() bat:Activate() end)
        task.wait(0.15)
        pcall(function() bat:Activate() end)
    end
end

startBatCounter = function()
    if Conns.batCounter then return end
    Conns.batCounter = RunService.Heartbeat:Connect(function()
        if not batCounterEnabled then return end
        if batCounterDebounce then return end
        local character = LP.Character
        if not character then return end
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not humanoid then return end
        local state = humanoid:GetState()
        if state == Enum.HumanoidStateType.Physics or
           state == Enum.HumanoidStateType.Ragdoll or
           state == Enum.HumanoidStateType.FallingDown then
            batCounterDebounce = true
            task.spawn(function()
                local bat = findBatForCounter()
                if bat then
                    swingBatForCounter(bat, character)
                end
                task.wait(0.5)
                batCounterDebounce = false
            end)
        end
    end)
end

stopBatCounter = function()
    if Conns.batCounter then
        Conns.batCounter:Disconnect()
        Conns.batCounter = nil
    end
    batCounterDebounce = false
end

local function findBat()
    local char = LP.Character
    if not char then return nil end
    for _, tool in ipairs(char:GetChildren()) do
        if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then return tool end
    end
    local bp = LP:FindFirstChildOfClass("Backpack")
    if bp then
        for _, tool in ipairs(bp:GetChildren()) do
            if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then return tool end
        end
    end
    return nil
end

local function isBatTool(tool)
    if not tool then return false end
    for _, name in ipairs(BAT_COUNTER_SLAP_LIST) do
        if tool.Name == name then return true end
    end
    return tool.Name:lower():find("bat") or tool.Name:lower():find("slap")
end

local _aimbotConn = nil
local _prevAutoRotate = nil
local _hittingCooldown = false

local function getClosestTarget()
    local char = LP.Character
    if not char then return nil end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local closest, minDist = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character then
            local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            if tRoot and hum and hum.Health > 0 then
                local dist = (tRoot.Position - root.Position).Magnitude
                if dist < minDist then
                    minDist = dist
                    closest = tRoot
                end
            end
        end
    end
    return closest
end

local function trySwing()
    if _hittingCooldown then return end
    _hittingCooldown = true
    pcall(function()
        local char = LP.Character
        if not char then return end
        local currentTool = char:FindFirstChildOfClass("Tool")
        if currentTool and not isBatTool(currentTool) then
            _hittingCooldown = false
            return
        end
        local bat = findBat()
        if bat then
            if bat.Parent ~= char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then pcall(function() hum:EquipTool(bat) end) end
            end
            pcall(function() bat:Activate() end)
        end
    end)
    task.delay(0.1, function() _hittingCooldown = false end)
    task.delay(0.2, function()
        if _hittingCooldown then _hittingCooldown = false end
    end)
end

startAimbotAdapt = function()
    if _aimbotConn then return end
    local hum0 = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if hum0 then
        if _prevAutoRotate == nil then _prevAutoRotate = hum0.AutoRotate end
        hum0.AutoRotate = false
    end
    _aimbotConn = RunService.RenderStepped:Connect(function()
        if not autoBatEnabled then return end
        local char = LP.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not root or not hum then return end
        if not char:FindFirstChildOfClass("Tool") then
            local bat = findBat()
            if bat then pcall(function() hum:EquipTool(bat) end) end
        end
        local target = getClosestTarget()
        if not target then return end
        local targetVel = target.AssemblyLinearVelocity
        local myPos = root.Position
        local targetPos = target.Position
        local predictPos = targetPos + targetVel * 0.14
        predictPos = predictPos + target.CFrame.LookVector * 0.3
        local direction = predictPos - myPos
        local flatDir = Vector3.new(direction.X, 0, direction.Z)
        if flatDir.Magnitude > 0 then flatDir = flatDir.Unit else flatDir = Vector3.new(0,0,0) end
        local desiredHeight = targetPos.Y + 3.7
        local yVel = (desiredHeight - myPos.Y) * 19.5 + targetVel.Y * 0.8
        if hum.FloorMaterial ~= Enum.Material.Air then
            yVel = math.max(yVel, 13)
        end
        yVel = math.clamp(yVel, -70, 110)
        local desiredVel = Vector3.new(flatDir.X * BAT_AIMBOT_SPEED, yVel, flatDir.Z * BAT_AIMBOT_SPEED)
        root.AssemblyLinearVelocity = root.AssemblyLinearVelocity:Lerp(desiredVel, 0.8)
        local speed3 = targetVel.Magnitude
        local predictTime = math.clamp(speed3 / 150, 0.05, 0.2)
        local predictedPos = targetPos + targetVel * predictTime
        local toPredict = predictedPos - myPos
        if toPredict.Magnitude > 0.1 then
            local goalCF = CFrame.lookAt(myPos, predictedPos)
            local diffCF = root.CFrame:Inverse() * goalCF
            local rx, ry, rz = diffCF:ToEulerAnglesXYZ()
            rx = math.clamp(rx, -2.5, 2.5)
            ry = math.clamp(ry, -2.5, 2.5)
            rz = math.clamp(rz, -2.5, 2.5)
            root.AssemblyAngularVelocity = root.CFrame:VectorToWorldSpace(
                Vector3.new(rx * 42, ry * 42, rz * 42)
            )
        end
        local distToTarget = (root.Position - target.Position).Magnitude
        if distToTarget <= 8 then
            trySwing()
        end
    end)
end

stopAimbotAdapt = function()
    if _aimbotConn then
        pcall(function() _aimbotConn:Disconnect() end)
        _aimbotConn = nil
    end
    local char = LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.AutoRotate = (_prevAutoRotate == nil) and true or _prevAutoRotate
        hum.PlatformStand = false
        pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
    end
    if root then
        root.AssemblyLinearVelocity = Vector3.new(0, -0.1, 0)
        root.AssemblyAngularVelocity = Vector3.zero
    end
    _prevAutoRotate = nil
    _hittingCooldown = false
    lastMoveDir = Vector3.zero
end

enableAutoBat = function()
    if autoLeftEnabled then
        autoLeftEnabled = false
        if autoLeftSetVisual then autoLeftSetVisual(false) end
        stopAutoLeft()
    end
    if autoRightEnabled then
        autoRightEnabled = false
        if autoRightSetVisual then autoRightSetVisual(false) end
        stopAutoRight()
    end
    if bypassToggled then
        bypassToggled = false
        if bypassFloatingButton and bypassFloatingButton:FindFirstChild("Frame") then
            local btnFrame = bypassFloatingButton:FindFirstChild("Frame")
            if btnFrame then
                btnFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)
                local lbl = btnFrame:FindFirstChild("TextLabel")
                if lbl then lbl.TextColor3 = Color3.fromRGB(255, 255, 255) end -- BLANCO
            end
        end
        stopBypassAimbot()
    end
    autoBatEnabled = true
    if autoBatSetVisual then autoBatSetVisual(true) end
    if mobSetAutoBat then mobSetAutoBat(true) end
    startAimbotAdapt()
end

disableAutoBat = function()
    autoBatEnabled = false
    if autoBatSetVisual then autoBatSetVisual(false) end
    if mobSetAutoBat then mobSetAutoBat(false) end
    stopAimbotAdapt()
end

queueAutoBatStart = function()
    if autoLeftEnabled then
        autoLeftEnabled=false
        if autoLeftSetVisual then autoLeftSetVisual(false) end
        if mobSetAutoLeft then mobSetAutoLeft(false) end
        stopAutoLeft()
    end
    if autoRightEnabled then
        autoRightEnabled=false
        if autoRightSetVisual then autoRightSetVisual(false) end
        if mobSetAutoRight then mobSetAutoRight(false) end
        stopAutoRight()
    end
    if not autoBatEnabled then
        autoBatEnabled = true
        if autoBatSetVisual then autoBatSetVisual(true) end
        if mobSetAutoBat then mobSetAutoBat(true) end
        startAimbotAdapt()
    end
end

-- ====== BYPASS AIMBOT (ANTI‑DESYNC) ======
local BAT_V2_FOLLOW_DIST = 1.0
local BAT_V2_HEIGHT_OFFSET = 1.5
local BAT_V2_VERTICAL_OFFSET = 0.0
local BAT_V2_HIT_DIST = 4.5

local bypassHittingCooldown = false
local bypassConn = nil

local function getClosestPlayerV2()
    local char = LP.Character
    if not char then return nil, math.huge end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil, math.huge end
    local closest, bestDist = nil, math.huge
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and p.Character then
            local tr = p.Character:FindFirstChild("HumanoidRootPart")
            local ph = p.Character:FindFirstChildOfClass("Humanoid")
            if tr and ph and ph.Health > 0 then
                local d = (hrp.Position - tr.Position).Magnitude
                if d < bestDist then bestDist = d; closest = p end
            end
        end
    end
    return closest, bestDist
end

local function tryHitBatV2()
    if bypassHittingCooldown then return end
    bypassHittingCooldown = true
    pcall(function()
        local char = LP.Character
        if not char then return end
        local currentTool = char:FindFirstChildOfClass("Tool")
        if currentTool and not isBatTool(currentTool) then
            bypassHittingCooldown = false
            return
        end
        local bat = findBat()
        if bat then
            if bat.Parent ~= char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then pcall(function() hum:EquipTool(bat) end) end
            end
            local remote = bat:FindFirstChildOfClass("RemoteEvent")
            if remote then pcall(function() remote:FireServer() end) else pcall(function() bat:Activate() end) end
        end
    end)
    task.delay(BAT_V2_SWING_COOLDOWN, function() bypassHittingCooldown = false end)
    task.delay(0.2, function()
        if bypassHittingCooldown then bypassHittingCooldown = false end
    end)
end

local function startBypassAimbot()
    if bypassConn then return end
    bypassConn = RunService.Heartbeat:Connect(function()
        if not bypassToggled then return end
        local char = LP.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not root or not hum then return end

        local state = hum:GetState()
        if state == Enum.HumanoidStateType.Physics or state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.FallingDown then
            return
        end

        if not char:FindFirstChildOfClass("Tool") then
            local bat = findBat()
            if bat then pcall(function() hum:EquipTool(bat) end) end
        end
        local target, dist = getClosestPlayerV2()
        if target and target.Character then
            local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
            if targetRoot then
                if bypassMode == 1 then
                    -- Modo 1: Bypass (seguimiento suave)
                    local targetVel = targetRoot.AssemblyLinearVelocity
                    local moveDir = targetVel.Magnitude > 0.1 and targetVel.Unit or targetRoot.CFrame.LookVector
                    local offset = moveDir * BAT_V2_FOLLOW_DIST + Vector3.new(0, BAT_V2_HEIGHT_OFFSET + BAT_V2_VERTICAL_OFFSET, 0)
                    local desiredPos = targetRoot.Position + offset
                    local toTarget = desiredPos - root.Position
                    if toTarget.Magnitude > 0.5 then
                        local moveVec = toTarget.Unit * BYPASS_AIMBOT_SPEED
                        root.AssemblyLinearVelocity = Vector3.new(moveVec.X, moveVec.Y, moveVec.Z)
                    else
                        root.AssemblyLinearVelocity = root.AssemblyLinearVelocity * 0.95
                        if root.AssemblyLinearVelocity.Magnitude < 1 then root.AssemblyLinearVelocity = Vector3.zero end
                    end
                    local distToTarget = (root.Position - targetRoot.Position).Magnitude
                    if distToTarget <= BAT_V2_HIT_DIST then
                        tryHitBatV2()
                    end
                else
                    -- Modo 2: Anti‑Desync (teletransporte + swing)
                    local tr = targetRoot
                    if tr then
                        pcall(function()
                            sethiddenproperty(root, "PhysicsRepRootPart", tr)
                        end)
                        local targetPos = tr.Position + Vector3.new(0, 0.9, 0)
                        if (root.Position - targetPos).Magnitude > 8 then
                            root.CFrame = CFrame.new(targetPos)
                        end
                        local cam = workspace.CurrentCamera
                        if cam then
                            cam.CFrame = CFrame.new(cam.CFrame.Position, tr.Position)
                        end
                        tryHitBatV2()
                    end
                end
            end
        else
            if bypassMode == 1 then
                root.AssemblyLinearVelocity = root.AssemblyLinearVelocity * 0.9
                if root.AssemblyLinearVelocity.Magnitude < 1 then root.AssemblyLinearVelocity = Vector3.zero end
            end
        end
    end)
end

local function stopBypassAimbot()
    if bypassConn then
        bypassConn:Disconnect()
        bypassConn = nil
    end
    local c = LP.Character
    local root = c and c:FindFirstChild("HumanoidRootPart")
    local hum = c and c:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.AutoRotate = true
        hum.PlatformStand = false
        pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
    end
    if root then
        root.AssemblyLinearVelocity = Vector3.new(0, -0.1, 0)
        root.AssemblyAngularVelocity = Vector3.zero
        pcall(function() sethiddenproperty(root, "PhysicsRepRootPart", nil) end)
    end
    bypassHittingCooldown = false
    lastMoveDir = Vector3.zero
end

local function toggleBypass(state)
    if state == nil then
        state = not bypassToggled
    end
    bypassToggled = state
    if bypassToggled then
        if autoBatEnabled then
            disableAutoBat()
            if autoBatSetVisual then autoBatSetVisual(false) end
            if mobSetAutoBat then mobSetAutoBat(false) end
        end
        if autoLeftEnabled then
            autoLeftEnabled = false
            if autoLeftSetVisual then autoLeftSetVisual(false) end
            if mobSetAutoLeft then mobSetAutoLeft(false) end
            stopAutoLeft()
        end
        if autoRightEnabled then
            autoRightEnabled = false
            if autoRightSetVisual then autoRightSetVisual(false) end
            if mobSetAutoRight then mobSetAutoRight(false) end
            stopAutoRight()
        end
        startBypassAimbot()
    else
        stopBypassAimbot()
    end
    if bypassFloatingButton then
        local btnFrame = bypassFloatingButton:FindFirstChild("Frame")
        if btnFrame then
            local label = btnFrame:FindFirstChild("TextLabel")
            if bypassToggled then
                btnFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                if label then label.TextColor3 = Color3.fromRGB(255, 255, 255) end
            else
                btnFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)
                if label then label.TextColor3 = Color3.fromRGB(255, 255, 255) end
            end
        end
    end
    if bypassSetVisual then bypassSetVisual(bypassToggled) end
end

local function toggleBypassMode()
    bypassMode = bypassMode == 1 and 2 or 1
    if bypassModeBtnRef then
        bypassModeBtnRef.Text = bypassMode == 1 and "Bypass" or "TP Bat"
    end
    if bypassToggled then
        stopBypassAimbot()
        startBypassAimbot()
    end
end

-- ====== TP DOWN ======
local autoTPDownEnabled = false
local autoTPDownConn = nil
local autoTPDownThreshold = 20

local function applyTPDown(sinkAmount, forwardForce)
    local char = LP.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    local state = hum:GetState()
    if state == Enum.HumanoidStateType.Physics or
       state == Enum.HumanoidStateType.Ragdoll or
       state == Enum.HumanoidStateType.FallingDown then
        return
    end

    local oldHealth = hum.Health

    -- Conserver exactement l'orientation et la position horizontale avant le TP.
    -- Le TP Down ne doit ni faire avancer ni retourner le personnage.
    local savedRotation = hrp.CFrame - hrp.CFrame.Position

    local rayParams = RaycastParams.new()
    rayParams.FilterDescendantsInstances = {char}
    rayParams.FilterType = Enum.RaycastFilterType.Exclude
    local ray = workspace:Raycast(hrp.Position, Vector3.new(0, -500, 0), rayParams)
    if not ray then return end

    local groundY = ray.Position.Y
    local offset = (hum.HipHeight or 2) + (hrp.Size.Y / 2) - sinkAmount
    local targetY = groundY + offset

    hrp.AssemblyLinearVelocity = Vector3.zero
    hrp.AssemblyAngularVelocity = Vector3.zero
    hrp.CFrame = CFrame.new(hrp.Position.X, targetY, hrp.Position.Z) * savedRotation

    -- Empêcher le moteur d'ajouter un petit déplacement/une rotation au frame suivant.
    RunService.Heartbeat:Wait()
    hrp.AssemblyLinearVelocity = Vector3.zero
    hrp.AssemblyAngularVelocity = Vector3.zero
    hrp.CFrame = CFrame.new(hrp.Position.X, targetY, hrp.Position.Z) * savedRotation

    if forwardForce > 0 then
        -- En V1, le déplacement volontaire reste celui demandé par le mode.
        local forwardDir = savedRotation.LookVector
        hrp.AssemblyLinearVelocity = Vector3.new(forwardDir.X * forwardForce, 0, forwardDir.Z * forwardForce)
    end

    if hum and hum.Health > 0 then
        hum:ChangeState(Enum.HumanoidStateType.Running)
    end

    task.wait(0.05)
    if hum and hum.Health < oldHealth then
        hum.Health = oldHealth
    end
end

local function executeTPDown()
    if tpDownMode == 1 then
        applyTPDown(0.8, 48)
    else
        applyTPDown(0.8, 0)
    end
end

local function startAutoTPDown()
    if autoTPDownConn then autoTPDownConn:Disconnect() end
    autoTPDownConn = RunService.RenderStepped:Connect(function()
        if not autoTPDownEnabled then return end
        if autoLeftEnabled or autoRightEnabled or autoBatEnabled or bypassToggled then return end
        local char = LP.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        local state = hum:GetState()
        if state == Enum.HumanoidStateType.Physics or
           state == Enum.HumanoidStateType.Ragdoll or
           state == Enum.HumanoidStateType.FallingDown then
            return
        end
        if hrp.Position.Y >= autoTPDownThreshold then
            if tpDownMode == 1 then
                applyTPDown(0.8, 48)
            else
                applyTPDown(0.8, 0)
            end
        end
    end)
end

local function stopAutoTPDown()
    if autoTPDownConn then autoTPDownConn:Disconnect(); autoTPDownConn = nil end
end

local modeValLbl = nil
local function refreshSpeedModeLabel()
    if modeValLbl then
        if laggerToggled then
            modeValLbl.Text = laggerLevel == 1 and "Lagger Mode 1" or "Lagger Mode 2"
        elseif speedMode then
            modeValLbl.Text = "Carry Mode"
        else
            modeValLbl.Text = "Normal"
        end
    end
end

function toggleLaggerCycle()
    if speedMode then
        speedMode = false
        if mobSetCarry then mobSetCarry(false) end
    end
    if not laggerToggled then
        laggerToggled = true
        laggerLevel = 1
    else
        if laggerLevel == 1 then
            laggerLevel = 2
        else
            laggerLevel = 1
        end
    end
    refreshSpeedModeLabel()
    if mobSetLagger1 then mobSetLagger1(laggerToggled and laggerLevel == 1) end
    if mobSetLagger2 then mobSetLagger2(laggerToggled and laggerLevel == 2) end
end

local function toggleCarryMode()
    if laggerToggled then
        laggerToggled = false
        laggerLevel = 1
        speedMode = true
    else
        speedMode = not speedMode
        if speedMode then
            laggerToggled = false
            laggerLevel = 1
        end
    end
    refreshSpeedModeLabel()
    if mobSetCarry then mobSetCarry(speedMode) end
    if mobSetLagger1 then mobSetLagger1(laggerToggled and laggerLevel==1) end
    if mobSetLagger2 then mobSetLagger2(laggerToggled and laggerLevel==2) end
end

local function toggleLockUI(state)
    if state == nil then
        uiLocked = not uiLocked
    else
        uiLocked = state
    end
    if setLockUIVisual then setLockUIVisual(uiLocked) end
end

-- ====== RESTAURAR POSICIONES ======
local mobileButtonPositions = {}

-- Forward declarations: resetFloatingPositions is above the real save function.
local saveAllSettings
local lastSavedJSON
local function resetFloatingPositions()
    local BTN_W, BTN_H = 60, 60
    local GAP_X, GAP_Y = 8, 18

    -- Posiciones originales solicitadas.
    local defaults = {
        BatBypass = {-(BTN_W + GAP_X), 0},                    -- al lado de DROP
        TpBat     = {-(BTN_W + GAP_X), (BTN_H + GAP_Y) * 2}, -- debajo de RESET

        DropBR    = {0, 0},
        AutoLeft  = {BTN_W + GAP_X, 0},
        AutoBat   = {0, BTN_H + GAP_Y},
        AutoRight = {BTN_W + GAP_X, BTN_H + GAP_Y},
        TpDown    = {0, (BTN_H + GAP_Y) * 2},
        Carry     = {BTN_W + GAP_X, (BTN_H + GAP_Y) * 2},
        Lagger1   = {0, (BTN_H + GAP_Y) * 3},
        Lagger2   = {BTN_W + GAP_X, (BTN_H + GAP_Y) * 3},
    }

    -- Resetear el panel base.
    if MobilePanel and MobilePanel:FindFirstChild("FloatingPanel") then
        MobilePanel.FloatingPanel.Position = UDim2.new(1, -138, 0, 0)
    end

    -- El propio panel móvil conoce las referencias y posiciones reales.
    -- Esta función se puede llamar todas las veces que quieras.
    if type(_G.__FROST_RESET_MOBILE_BUTTONS) == "function" then
        pcall(_G.__FROST_RESET_MOBILE_BUTTONS)
    else
        local refs = _G.__FROST_MOBILE_BUTTON_REFS or {}
        for name, pos in pairs(defaults) do
            local btn = refs[name]
            if btn and btn.Parent then
                btn.Position = UDim2.new(0, pos[1], 0, pos[2])
            end
        end
    end

    -- RESET al lado de BAT V1.

    -- Limpiar posiciones guardadas SIN sustituir la tabla:
    -- así todos los closures siguen usando la misma referencia.
    for key in pairs(mobileButtonPositions) do
        mobileButtonPositions[key] = nil
    end

    bypassFloatingPos = nil
    savedMobilePanelPos = nil

    -- Guardar inmediatamente el estado limpio.
    lastSavedJSON = nil
    if saveAllSettings then
        pcall(saveAllSettings)
    end
end

-- ====== CONFIGURACIÓN ======
local CONFIG_FILE = "drakauhub_config.json"
local savedMobilePanelPos = nil
local savedProgressBarPos = nil
local savedBypassPos = nil
lastSavedJSON = nil

local function buildConfigTable()
    local config = {
        normalSpeed = NS,
        carrySpeed = CS,
        laggerSpeed1 = LAGGER_SPEED_1,
        laggerSpeed2 = LAGGER_SPEED_2,
        stealRadius = Steal.StealRadius,
        stealDuration = Steal.StealDuration,
        autoTPHeight = autoTPHeight,
        antiRagdoll = antiRagdollEnabled,
        autoSteal = Steal.AutoStealEnabled,
        jumpEnabled = jumpEnabled,
        jumpMode = jumpMode,
        tpDownMode = tpDownMode,
        medusaCounter = medusaCounterEnabled,
        batCounter = batCounterEnabled,
        laggerToggled = laggerToggled,
        laggerLevel = laggerLevel,
        carryMode = speedMode,
        autoBat = autoBatEnabled,
        autoLeft = autoLeftEnabled,
        autoRight = autoRightEnabled,
        unwalk = unwalkEnabled,
        antiLag = antiLagEnabled,
        tracersEnabled = tracersEnabled,
        autoTPDownEnabled = autoTPDownEnabled,
        autoTPDownThreshold = autoTPDownThreshold,
        lockUI = uiLocked,
        uiSize = tonumber(_G.__FROST_UI_SIZE) or 100,
        batAimbotSpeed = BAT_AIMBOT_SPEED,
        bypassToggled = false,
        bypassSpeed = BYPASS_AIMBOT_SPEED,
        bypassMode = bypassMode,
        dropMode = dropMode,
        medusaAutoReset = medusaAutoResetEnabled,
        stretchEnabled = stretchEnabled,
        stretchFOV = stretchFOV,
        dropBrainrotKey = {kb = KB.DropBrainrot.kb and KB.DropBrainrot.kb.Name, gp = KB.DropBrainrot.gp and KB.DropBrainrot.gp.Name},
        autoLeftKey = {kb = KB.AutoLeft.kb and KB.AutoLeft.kb.Name, gp = KB.AutoLeft.gp and KB.AutoLeft.gp.Name},
        autoRightKey = {kb = KB.AutoRight.kb and KB.AutoRight.kb.Name, gp = KB.AutoRight.gp and KB.AutoRight.gp.Name},
        autoBatKey = {kb = KB.AutoBat.kb and KB.AutoBat.kb.Name, gp = KB.AutoBat.gp and KB.AutoBat.gp.Name},
        tpFloorKey = {kb = KB.TPFloor.kb and KB.TPFloor.kb.Name, gp = KB.TPFloor.gp and KB.TPFloor.gp.Name},
        carryToggleKey = {kb = KB.CarryToggle.kb and KB.CarryToggle.kb.Name, gp = KB.CarryToggle.gp and KB.CarryToggle.gp.Name},
        laggerModeKey = {kb = KB.LaggerMode.kb and KB.LaggerMode.kb.Name, gp = KB.LaggerMode.gp and KB.LaggerMode.gp.Name},
        autoTPDownKey = {kb = KB.AutoTPDown.kb and KB.AutoTPDown.kb.Name, gp = KB.AutoTPDown.gp and KB.AutoTPDown.gp.Name},
        instaResetKey = {kb = KB.InstaReset.kb and KB.InstaReset.kb.Name, gp = KB.InstaReset.gp and KB.InstaReset.gp.Name},
        jumpModeKey = {kb = KB.JumpMode.kb and KB.JumpMode.kb.Name, gp = KB.JumpMode.gp and KB.JumpMode.gp.Name},
        bypassKey = {kb = KB.Bypass.kb and KB.Bypass.kb.Name, gp = KB.Bypass.gp and KB.Bypass.gp.Name},
        instaResetFloatingPos = instaResetFloatingPos,
        bypassFloatingPos = bypassFloatingPos,
        mobileButtonPositions = mobileButtonPositions,
        animSystemEnabled = _G.toggleAnimSystem and true or false,
        animSystemSelected = _G.getAnimPack and _G.getAnimPack() or "Ninja",
    }
    if pbFrame then
        config.progressBarPos = {
            XScale = pbFrame.Position.X.Scale,
            XOffset = pbFrame.Position.X.Offset,
            YScale = pbFrame.Position.Y.Scale,
            YOffset = pbFrame.Position.Y.Offset
        }
    end
    if MobilePanel and MobilePanel:FindFirstChild("FloatingPanel") then
        local container = MobilePanel:FindFirstChild("FloatingPanel")
        config.mobilePanelPos = {
            XScale = container.Position.X.Scale,
            XOffset = container.Position.X.Offset,
            YScale = container.Position.Y.Scale,
            YOffset = container.Position.Y.Offset
        }
    end
    return config
end

saveAllSettings = function()
    local config = buildConfigTable()
    local json = HS:JSONEncode(config)
    if json == lastSavedJSON then
        return true
    end
    local success, err = pcall(function()
        writefile(CONFIG_FILE, json)
    end)
    if success then
        lastSavedJSON = json
    end
    return success
end

local function loadAllSettings()
    if not isfile or not isfile(CONFIG_FILE) then return false end
    local success, data = pcall(function()
        return HS:JSONDecode(readfile(CONFIG_FILE))
    end)
    if not success or not data then return false end
    if data.normalSpeed then NS = data.normalSpeed end
    if data.carrySpeed then CS = data.carrySpeed end
    if data.laggerSpeed1 then LAGGER_SPEED_1 = data.laggerSpeed1 end
    if data.laggerSpeed2 then LAGGER_SPEED_2 = data.laggerSpeed2 end
    if data.stealRadius then Steal.StealRadius = data.stealRadius end
    if data.stealDuration then Steal.StealDuration = data.stealDuration end
    if data.autoTPHeight then autoTPHeight = data.autoTPHeight end
    if data.autoTPDownEnabled ~= nil then autoTPDownEnabled = data.autoTPDownEnabled end
    if data.autoTPDownThreshold then autoTPDownThreshold = data.autoTPDownThreshold end
    if data.lockUI ~= nil then uiLocked = data.lockUI end
    if data.uiSize then
        _G.__FROST_UI_SIZE = math.clamp(tonumber(data.uiSize) or 100, 50, 150)
        if _G.__FROST_UI_SCALE_OBJ then
            _G.__FROST_UI_SCALE_OBJ.Scale = _G.__FROST_UI_SIZE / 100
        end
    end
-- TRACERS
if data.tracersEnabled ~= nil then
    tracersEnabled = data.tracersEnabled
    if tracerToggleSetter then
        tracerToggleSetter(tracersEnabled)
    end
    if tracersEnabled then
        task.spawn(function()
            task.wait(0.5)
            startTracers()
        end)
    end
end
    if data.autoLeft ~= nil then autoLeftEnabled = data.autoLeft end
    if data.autoRight ~= nil then autoRightEnabled = data.autoRight end
    if data.antiRagdoll then antiRagdollEnabled = data.antiRagdoll end
    -- Forzar Auto Steal activado (sobrescribe lo que venga en configuración)
    Steal.AutoStealEnabled = true
    if data.jumpEnabled ~= nil then jumpEnabled = data.jumpEnabled end
    if data.jumpMode then jumpMode = data.jumpMode end
    if data.tpDownMode then tpDownMode = data.tpDownMode end
    if data.medusaCounter then medusaCounterEnabled = data.medusaCounter end
    if data.batCounter then batCounterEnabled = data.batCounter end
    if data.autoBat then autoBatEnabled = data.autoBat end
    if data.unwalk then unwalkEnabled = data.unwalk end
    if data.antiLag then antiLagEnabled = data.antiLag end
    if data.laggerToggled then
        laggerToggled = true
        speedMode = false
        laggerLevel = data.laggerLevel or 1
    elseif data.carryMode then
        speedMode = true
        laggerToggled = false
    else
        speedMode = false
        laggerToggled = false
        laggerLevel = 1
    end
    if data.medusaAutoReset ~= nil then
        medusaAutoResetEnabled = data.medusaAutoReset
        if medusaAutoResetEnabled and medusaCounterEnabled then
            medusaCounterEnabled = false
        end
    end
    if data.instaResetKey then
        local ik = data.instaResetKey
        if ik.kb and Enum.KeyCode[ik.kb] then
            KB.InstaReset.kb = Enum.KeyCode[ik.kb]
            KB.InstaReset.gp = nil
        end
        if ik.gp and Enum.KeyCode[ik.gp] then
            KB.InstaReset.gp = Enum.KeyCode[ik.gp]
            KB.InstaReset.kb = nil
        end
    end
    if data.jumpModeKey then
        local jk = data.jumpModeKey
        if jk.kb and Enum.KeyCode[jk.kb] then
            KB.JumpMode.kb = Enum.KeyCode[jk.kb]
            KB.JumpMode.gp = nil
        end
        if jk.gp and Enum.KeyCode[jk.gp] then
            KB.JumpMode.gp = Enum.KeyCode[jk.gp]
            KB.JumpMode.kb = nil
        end
    end
    if data.bypassKey then
        local bk = data.bypassKey
        if bk.kb and Enum.KeyCode[bk.kb] then
            KB.Bypass.kb = Enum.KeyCode[bk.kb]
            KB.Bypass.gp = nil
        end
        if bk.gp and Enum.KeyCode[bk.gp] then
            KB.Bypass.gp = Enum.KeyCode[bk.gp]
            KB.Bypass.kb = nil
        end
    end
    if data.instaResetFloatingPos then
        instaResetFloatingPos = data.instaResetFloatingPos
    end
    if data.bypassFloatingPos then
        bypassFloatingPos = data.bypassFloatingPos
    end
    if data.batAimbotSpeed then
        BAT_AIMBOT_SPEED = data.batAimbotSpeed
        if batSpeedBox then batSpeedBox.Text = tostring(BAT_AIMBOT_SPEED) end
    end
    if data.bypassSpeed then
        BYPASS_AIMBOT_SPEED = data.bypassSpeed
        if bypassSpeedBox then bypassSpeedBox.Text = tostring(BYPASS_AIMBOT_SPEED) end
    end
    bypassToggled = false
    if data.bypassMode then
        bypassMode = data.bypassMode
        if bypassModeBtnRef then
            bypassModeBtnRef.Text = bypassMode == 1 and "Bypass" or "TP Bat"
        end
    end
    if data.dropMode then
        dropMode = data.dropMode
        if dropModeBtnRef then
            dropModeBtnRef.Text = dropMode == 1 and "V1" or "V2"
        end
    end
    if data.stretchEnabled ~= nil then
        stretchEnabled = data.stretchEnabled
    end
    if data.stretchFOV then
        stretchFOV = data.stretchFOV
    end
    local function loadKey(kbData, target)
        if kbData and kbData.kb and Enum.KeyCode[kbData.kb] then
            target.kb = Enum.KeyCode[kbData.kb]
            target.gp = nil
        end
        if kbData and kbData.gp and Enum.KeyCode[kbData.gp] then
            target.gp = Enum.KeyCode[kbData.gp]
            target.kb = nil
        end
    end
    loadKey(data.dropBrainrotKey, KB.DropBrainrot)
    loadKey(data.autoLeftKey, KB.AutoLeft)
    loadKey(data.autoRightKey, KB.AutoRight)
    loadKey(data.autoBatKey, KB.AutoBat)
    loadKey(data.tpFloorKey, KB.TPFloor)
    loadKey(data.carryToggleKey, KB.CarryToggle)
    loadKey(data.laggerModeKey, KB.LaggerMode)
    loadKey(data.autoTPDownKey, KB.AutoTPDown)
    if data.progressBarPos then savedProgressBarPos = data.progressBarPos end
    if data.mobilePanelPos then savedMobilePanelPos = data.mobilePanelPos end
    if type(data.mobileButtonPositions) == "table" then mobileButtonPositions = data.mobileButtonPositions end
    if data.animSystemEnabled ~= nil and _G.toggleAnimSystem then
        _G.toggleAnimSystem(data.animSystemEnabled)
    end
    if data.animSystemSelected and _G.setAnimPack then
        _G.setAnimPack(data.animSystemSelected)
        if animSelectorBtn then animSelectorBtn.Text = data.animSystemSelected end
        if _G.animSelectorBtn then _G.animSelectorBtn.Text = data.animSystemSelected end
    end
    refreshSpeedModeLabel()
    lastSavedJSON = HS:JSONEncode(buildConfigTable())
    return true
end

local function resetToDefaults()
    stopAllBackgroundTasks()
    NS = 60
    CS = 30
    LAGGER_SPEED_1 = 15
    LAGGER_SPEED_2 = 10
    Steal.StealRadius = 64
    Steal.StealDuration = 1.3
    autoTPHeight = 20
    autoTPDownThreshold = 20
    speedMode = false
    laggerToggled = false
    laggerLevel = 1
    antiRagdollEnabled = false
    jumpEnabled = false
    jumpMode = 1
    tpDownMode = 1
    medusaCounterEnabled = false
    batCounterEnabled = false
    autoBatEnabled = false
    autoLeftEnabled = false
    autoRightEnabled = false
    unwalkEnabled = false
    antiLagEnabled = false
    autoTPDownEnabled = false
    uiLocked = false
    Steal.AutoStealEnabled = true  -- Forzado a true incluso en reset
    BAT_AIMBOT_SPEED = 58
    BYPASS_AIMBOT_SPEED = 60
    bypassToggled = false
    bypassMode = 1
    dropMode = 1
    medusaAutoResetEnabled = false
    stretchEnabled = false
    stretchFOV = 120
    if normalBox then normalBox.Text = tostring(NS) end
    if carryBox then carryBox.Text = tostring(CS) end
    if laggerBox then laggerBox.Text = tostring(LAGGER_SPEED_1) end
    if lagger2Box then lagger2Box.Text = tostring(LAGGER_SPEED_2) end
    if radInput then radInput.Text = tostring(Steal.StealRadius) end
    if stealDurationBox then stealDurationBox.Text = tostring(Steal.StealDuration) end
    if autoTPHeightBox then autoTPHeightBox.Text = tostring(autoTPHeight) end
    if batSpeedBox then batSpeedBox.Text = tostring(BAT_AIMBOT_SPEED) end
    if bypassSpeedBox then bypassSpeedBox.Text = tostring(BYPASS_AIMBOT_SPEED) end
    if progressRadLbl then progressRadLbl.Text = "-- · --" end
    if autoBatSetVisual then autoBatSetVisual(false) end
    if autoLeftSetVisual then autoLeftSetVisual(false) end
    if autoRightSetVisual then autoRightSetVisual(false) end
    if setBatCounterVisual then setBatCounterVisual(false) end
    if setMedusaVisual then setMedusaVisual(false) end
    if setMedusaAutoResetVisual then setMedusaAutoResetVisual(false) end
    if setAntiRagVisual then setAntiRagVisual(false) end
    if setJumpVisual then setJumpVisual(false) end
    if setUnwalkVisual then setUnwalkVisual(false) end
    if setAntiLagVisual then setAntiLagVisual(false) end
    if setAutoTPDownVisual then setAutoTPDownVisual(false) end
    if setLockUIVisual then setLockUIVisual(false) end
    if setInstaGrab then setInstaGrab(false) end
    if bypassSetVisual then bypassSetVisual(false) end
    if _G.stretchToggleSetter then _G.stretchToggleSetter(false) end
    if mobSetAutoBat then mobSetAutoBat(false) end
    if mobSetAutoLeft then mobSetAutoLeft(false) end
    if mobSetAutoRight then mobSetAutoRight(false) end
    if mobSetDropBR then mobSetDropBR(false) end
    if mobSetTpDown then mobSetTpDown(false) end
    if mobSetCarry then mobSetCarry(false) end
    if mobSetLagger1 then mobSetLagger1(false) end
    if mobSetLagger2 then mobSetLagger2(false) end
    if modeSelectBtn then
        modeSelectBtn.Text = jumpMode == 1 and "Tap Tap" or "Hold"
    end
    if tpModeSelectBtn then
        tpModeSelectBtn.Text = tpDownMode == 1 and "V1" or "V2"
    end
    if dropModeBtnRef then
        dropModeBtnRef.Text = dropMode == 1 and "V1" or "V2"
    end
    if bypassModeBtnRef then
        bypassModeBtnRef.Text = bypassMode == 1 and "Bypass" or "TP Bat"
    end
    if setJumpToggleState then setJumpToggleState(false) end
    refreshSpeedModeLabel()
    updateProgressBarVisibility()
    lastSavedJSON = HS:JSONEncode(buildConfigTable())
end

local function deleteAllSettings()
    local success = false
    if isfile and isfile(CONFIG_FILE) then
        success = pcall(function() delfile(CONFIG_FILE); return true end)
    end
    if isfile and isfile("drakauhub_PanelPos.txt") then
        pcall(delfile, "drakauhub_PanelPos.txt")
    end
    resetToDefaults()
    if pbFrame then
        pbFrame.Position = UDim2.new(0.5, -140, 1, -66)
    end
    if MobilePanel and MobilePanel:FindFirstChild("FloatingPanel") then
        local container = MobilePanel:FindFirstChild("FloatingPanel")
        container.Position = UDim2.new(1, -128 - 10, 0, 0)
    end
    bypassFloatingPos = nil
    if instaResetFloatingButton and instaResetFloatingButton:FindFirstChild("Frame") then
        local btnFrame = instaResetFloatingButton:FindFirstChild("Frame")
        btnFrame.Position = UDim2.new(1, -128 - 10, 0, 294 + 10)
    end
    if bypassFloatingButton and bypassFloatingButton:FindFirstChild("Frame") then
        local btnFrame = bypassFloatingButton:FindFirstChild("Frame")
        btnFrame.Position = UDim2.new(1, -10 - 60, 0, 294 + 10)
    end
    return success
end

-- ====== FIN DE LA PARTE 1 ======
-- Continúa con la Parte 2 (buildGui y resto)

-- ====== GUI ======
local gui = nil
local main = nil
local miniBtn = nil

local function applyShimmerToText(obj, speed)
    speed = speed or 0.8
    local grad = Instance.new("UIGradient", obj)
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(80,80,80)),
        ColorSequenceKeypoint.new(0.3, Color3.fromRGB(200,200,200)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255,255,255)),
        ColorSequenceKeypoint.new(0.7, Color3.fromRGB(200,200,200)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(80,80,80))
    })
    grad.Rotation = 45
    grad.Offset = Vector2.new(0,0)
    task.spawn(function()
        local t = 0
        while grad and grad.Parent do
            t = t + 0.02
            grad.Offset = Vector2.new(math.sin(t * speed) * 0.4, 0)
            task.wait(0.04)
        end
    end)
    return grad
end

-- ====== CONSTRUCCIÓN DE GUI ======
local function buildGui()
        local BLACK   = Color3.fromRGB(0, 0, 0)
local ACCENT  = Color3.fromRGB(255, 255, 255) -- BLANCO
local INP     = Color3.fromRGB(0, 0, 0)
    local CORNER  = 30
    local GUI_W, GUI_H = 350, 520

    local old=game:GetService("CoreGui"):FindFirstChild("drakau_hub")
    if old then old:Destroy() end
    local pg=LP:FindFirstChild("PlayerGui")
    if pg then
        local o=pg:FindFirstChild("drakau_hub")
        if o then o:Destroy() end
    end
    gui=Instance.new("ScreenGui")
    gui.Name="drakau_hub"
    gui.ResetOnSpawn=false
    gui.DisplayOrder=10
    gui.IgnoreGuiInset=true
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(gui) end end)
    if not pcall(function() gui.Parent=game:GetService("CoreGui") end) then gui.Parent=LP:WaitForChild("PlayerGui") end

    main=Instance.new("Frame",gui)
main.Size=UDim2.new(0,GUI_W,0,GUI_H)
main.Position=UDim2.new(0,20,0,2)

_G.__FROST_UI_SCALE_OBJ = Instance.new("UIScale", main)
_G.__FROST_UI_SCALE_OBJ.Scale = math.clamp((tonumber(_G.__FROST_UI_SIZE) or 100) / 100, 0.5, 1.5)

-- ====== IMAGEN DE FONDO (ESTILO CRYON) - AGREGAR AQUÍ ======
local fullUIBackground = Instance.new("ImageLabel", main)
fullUIBackground.Name = "FullUIBackground"
fullUIBackground.Size = UDim2.new(1, -2, 1, -2)
fullUIBackground.Position = UDim2.new(0, 1, 0, 1)
fullUIBackground.BackgroundTransparency = 1
fullUIBackground.BorderSizePixel = 0
fullUIBackground.Image = "rbxthumb://type=Asset&id=72514274273722&w=420&h=420"
fullUIBackground.ImageTransparency = 0.18
fullUIBackground.ImageColor3 = Color3.fromRGB(255, 255, 255) -- BLANCO
fullUIBackground.ScaleType = Enum.ScaleType.Crop
fullUIBackground.ZIndex = 1

local fullUIBackgroundCorner = Instance.new("UICorner", fullUIBackground)
fullUIBackgroundCorner.CornerRadius = UDim.new(0, math.max(CORNER - 1, 0))

local mainGrad = Instance.new("UIGradient", main)
mainGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 0, 0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
})

mainGrad.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0.3),
    NumberSequenceKeypoint.new(0.5, 0.1),
    NumberSequenceKeypoint.new(1, 0.3)
})
    
   mainGrad.Rotation = 45
mainGrad.Offset = Vector2.new(0,0)
main.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
main.BackgroundTransparency = 0.22
main.BorderSizePixel = 0
main.ClipsDescendants = true
Instance.new("UICorner",main).CornerRadius=UDim.new(0,CORNER)

    task.spawn(function()
        local t=0
        while mainStroke and mainStroke.Parent do
            t = t + 0.04
            local phase = math.sin(t * 1.2)
            mainStroke.Color = Color3.fromRGB(
                128 + 64 * (phase * 0.5 + 0.5),
                128 + 64 * (phase * 0.5 + 0.5),
                128 + 64 * (phase * 0.5 + 0.5)
            )
            mainStroke.Transparency = 0.35 + 0.2 * math.sin(t * 1.8)
            if mainGrad then
                mainGrad.Offset = Vector2.new(math.sin(t * 0.3) * 0.15, math.cos(t * 0.25) * 0.15)
            end
            task.wait(0.04)
        end
    end)

    local shadow = Instance.new("Frame", main)
    shadow.Size = UDim2.new(1, 8, 1, 8)
    shadow.Position = UDim2.new(0, -4, 0, 4)
    shadow.BackgroundColor3 = Color3.fromRGB(0,0,0)
    shadow.BackgroundTransparency = 0.8
    shadow.BorderSizePixel = 0
    shadow.ZIndex = 0
    Instance.new("UICorner", shadow).CornerRadius = UDim.new(0, CORNER)

    -- Branding
    local brandFrame = Instance.new("Frame", main)
    brandFrame.Size = UDim2.new(1, -20, 0, 28)
    brandFrame.Position = UDim2.new(0, 12, 0, 8)
    brandFrame.BackgroundTransparency = 1

    local brandTitle = Instance.new("TextLabel", brandFrame)
    brandTitle.Size = UDim2.new(1, -40, 0, 26)
    brandTitle.Position = UDim2.new(0, 2, 0, 0)
    brandTitle.BackgroundTransparency = 1
    brandTitle.Text = "Drakau Hub"
    brandTitle.TextColor3 = Color3.fromRGB(255, 255, 255) -- BLANCO
    brandTitle.Font = Enum.Font.FredokaOne
    brandTitle.TextSize = 22
    brandTitle.TextXAlignment = Enum.TextXAlignment.Left
    local titleGrad = Instance.new("UIGradient", brandTitle)
    titleGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
    })
    titleGrad.Offset = Vector2.new(0,0)
    task.spawn(function()
        local t=0
        while titleGrad and titleGrad.Parent do
            t = t + 0.03
            titleGrad.Offset = Vector2.new(math.sin(t * 0.8) * 0.3, 0)
            task.wait(0.04)
        end
    end)

    local brandSub = Instance.new("TextLabel", brandFrame)
    brandSub.Size = UDim2.new(1, 0, 0, 14)
    brandSub.Position = UDim2.new(0, 0, 0, 22)
    brandSub.BackgroundTransparency = 1
    brandSub.Text = ""
    brandSub.Visible = false
    brandSub.TextColor3 = Color3.fromRGB(255, 255, 255)
    brandSub.Font = Enum.Font.Gotham
    brandSub.TextSize = 10
    brandSub.TextXAlignment = Enum.TextXAlignment.Center
    applyShimmerToText(brandSub, 0.5)

    local brandLine = Instance.new("Frame", brandFrame)
    brandLine.Size = UDim2.new(0.4, 0, 0, 2)
    brandLine.Position = UDim2.new(0.3, 0, 1, -4)
    brandLine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    brandLine.Visible = false
    brandLine.BorderSizePixel = 0
    Instance.new("UICorner", brandLine).CornerRadius = UDim.new(1, 0)

    -- Botón cerrar
    local closeBtn = Instance.new("TextButton", main)
    closeBtn.Size = UDim2.new(0, 26, 0, 26)
    closeBtn.Position = UDim2.new(1, -34, 0, 9)
    closeBtn.BackgroundColor3 = BLACK
    closeBtn.BackgroundTransparency = 0.20
    closeBtn.BorderSizePixel = 0
    closeBtn.Text = "-"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255) -- BLANCO
    closeBtn.Font = Enum.Font.FredokaOne
    closeBtn.TextSize = 24
    closeBtn.AutoButtonColor = false
    closeBtn.ZIndex = 200
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 8)
    applyShimmerToText(closeBtn, 1.2)

    closeBtn.MouseEnter:Connect(function()
        TS:Create(closeBtn,TweenInfo.new(0.1),{TextColor3=Color3.fromRGB(255, 255, 255),BackgroundColor3=Color3.fromRGB(255, 255, 255)}):Play()
        TS:Create(closeStroke,TweenInfo.new(0.1),{Transparency=0,Color=Color3.fromRGB(255,255,255)}):Play()
    end)
    closeBtn.MouseLeave:Connect(function()
        TS:Create(closeBtn,TweenInfo.new(0.1),{TextColor3=Color3.fromRGB(255, 255, 255),BackgroundColor3=BLACK}):Play()
        TS:Create(closeStroke,TweenInfo.new(0.1),{Transparency=0.3,Color=Color3.fromRGB(255, 255, 255)}):Play()
    end)

    miniBtn=Instance.new("TextButton",gui)
    miniBtn.Size=UDim2.new(0,118,0,30)
    miniBtn.Position=UDim2.new(0,16,0,58)
    miniBtn.BackgroundColor3=BLACK
    miniBtn.BorderSizePixel=0
    miniBtn.Text="Drakau Hub"
    miniBtn.TextColor3=Color3.fromRGB(255, 255, 255) -- BLANCO
    miniBtn.Font=Enum.Font.FredokaOne
    miniBtn.TextSize=12
    miniBtn.ZIndex=20
    miniBtn.Visible=false
    Instance.new("UICorner",miniBtn).CornerRadius=UDim.new(0,8)
    applyShimmerToText(miniBtn, 0.9)

    local function showGui()
        main.Visible=true
        miniBtn.Visible=false
    end

    local function hideGui()
        main.Visible=false
        miniBtn.Visible=true
    end

    closeBtn.MouseButton1Click:Connect(hideGui)
    miniBtn.MouseButton1Click:Connect(showGui)

    -- Área de contenido
    local contentArea = Instance.new("Frame", main)
    -- Barra de pestañas compacta, inspirada en la referencia visual.
    local tabBar = Instance.new("Frame", main)
    tabBar.Name = "TabBar"
    tabBar.Size = UDim2.new(1, -20, 0, 34)
    tabBar.Position = UDim2.new(0, 10, 0, 40)
    tabBar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    tabBar.BackgroundTransparency = 0.45
    tabBar.BorderSizePixel = 0
    tabBar.ZIndex = 20
    Instance.new("UICorner", tabBar).CornerRadius = UDim.new(0, 12)

    local tabDivider = Instance.new("Frame", main)
    tabDivider.Name = "TabDivider"
    tabDivider.Size = UDim2.new(1, -20, 0, 1)
    tabDivider.Position = UDim2.new(0, 10, 0, 80)
    tabDivider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    tabDivider.BackgroundTransparency = 0.6
    tabDivider.BorderSizePixel = 0
    tabDivider.ZIndex = 20

    contentArea.Size = UDim2.new(1, -12, 1, -98)
    contentArea.Position = UDim2.new(0, 6, 0, 92)
    contentArea.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    contentArea.BackgroundTransparency = 0.52
    contentArea.BorderSizePixel = 0
    contentArea.ClipsDescendants = true
    Instance.new("UICorner", contentArea).CornerRadius = UDim.new(0, 16)

    local pageHolder = Instance.new("Frame", contentArea)
    pageHolder.Size = UDim2.new(1, -6, 1, -6)
    pageHolder.Position = UDim2.new(0, 3, 0, 3)
    pageHolder.BackgroundTransparency = 1
    pageHolder.BorderSizePixel = 0

    -- Cada pestaña usa su propio ScrollingFrame, igual que la pestaña Combat.
    -- Esto evita compartir el estado de desplazamiento entre páginas.
    local function buildPage()
        local p = Instance.new("ScrollingFrame")
        p.Name = "ScrollableTabPage"
        p.Parent = pageHolder
        p.Size = UDim2.new(1, -2, 1, 0)
        p.Position = UDim2.new(0, 0, 0, 0)
        p.BackgroundTransparency = 1
        p.BorderSizePixel = 0
        p.ClipsDescendants = true
        p.Active = true
        p.Selectable = false
        p.ScrollingEnabled = true
        p.ScrollingDirection = Enum.ScrollingDirection.Y
        p.ElasticBehavior = Enum.ElasticBehavior.Always
        p.ScrollBarThickness = 5
        p.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
        p.ScrollingEnabled = true
        p.ElasticBehavior = Enum.ElasticBehavior.WhenScrollable
        p.ScrollBarImageTransparency = 0.3
        p.CanvasPosition = Vector2.new(0, 0)
        p.CanvasSize = UDim2.new(0, 0, 0, 0)
        p.AutomaticCanvasSize = Enum.AutomaticSize.Y
        local ll = Instance.new("UIListLayout", p)
        ll.SortOrder = Enum.SortOrder.LayoutOrder
        ll.Padding = UDim.new(0, 5)
        local pd = Instance.new("UIPadding", p)
        pd.PaddingLeft = UDim.new(0, 4)
        pd.PaddingRight = UDim.new(0, 4)
        pd.PaddingTop = UDim.new(0, 4)
        pd.PaddingBottom = UDim.new(0, 4)

        -- Fuerza el tamaño desplazable para que todas las pestañas,
        -- incluidas Movement, Music y Keybinds, funcionen igual que Combat.
        -- AutomaticCanvasSize se encarga del alto real.
        -- Padding inferior grande para poder llegar siempre al último ajuste.
        pd.PaddingBottom = UDim.new(0, 140)

        local function updateCanvasSize()
            p.CanvasSize = UDim2.new(0, 0, 0, ll.AbsoluteContentSize.Y + 160)
        end
        ll:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvasSize)
        task.defer(updateCanvasSize)
        return p
    end

    local tabNames = {
        "MAIN", "COMBAT", "MOVEMENT", "MUSIC", "KEYS"
    }
    local pages = {}
    local tabButtons = {}
    local activeTab = 1
    local scrollPage = nil

    local function setActiveTab(index)
        activeTab = index
        for i, page in ipairs(pages) do
            page.Visible = (i == index)
        end
        for i, button in ipairs(tabButtons) do
            local selected = (i == index)
            button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            button.BackgroundTransparency = selected and 0 or 1
            -- CAMBIO: las pestañas inactivas ahora son blancas, no azules
            button.TextColor3 = selected and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 255, 255)
            local stroke = button:FindFirstChildOfClass("UIStroke")
            if stroke then
                stroke.Color = selected and Color3.fromRGB(220, 220, 220) or Color3.fromRGB(70, 70, 70)
                stroke.Transparency = selected and 0 or 0.35
            end
        end
    end

    for i, name in ipairs(tabNames) do
        local button = Instance.new("TextButton", tabBar)
        button.Name = "Tab_" .. name:gsub("[^%w]", "")
        button.Size = UDim2.new(1/#tabNames, -6, 0, 26)
        local col = (i - 1)
        button.Position = UDim2.new(col / #tabNames, 3, 0, 4)
        button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        button.BackgroundTransparency = 1
        button.BorderSizePixel = 0
        button.Text = name
        button.TextColor3 = Color3.fromRGB(255, 255, 255) -- BLANCO por defecto
        button.Font = Enum.Font.FredokaOne
        button.TextSize = 11
        button.AutoButtonColor = false
        button.ZIndex = 21
        Instance.new("UICorner", button).CornerRadius = UDim.new(0, 10)
        local stroke = Instance.new("UIStroke", button)
        stroke.Thickness = 1
        stroke.Color = Color3.fromRGB(70, 70, 70)
        stroke.Transparency = 0.35
        button.Activated:Connect(function() setActiveTab(i) end)
        table.insert(tabButtons, button)

        local page = buildPage()
        page.Name = "Page_" .. name:gsub("[^%w]", "")
        page.Visible = false
        table.insert(pages, page)
    end
    setActiveTab(1)

    -- Sin bordes: elimina todos los UIStroke y evita que aparezcan nuevos
    local function stripStrokes(root)
        for _, d in ipairs(root:GetDescendants()) do
            if d:IsA("UIStroke") then d:Destroy() end
        end
    end
    stripStrokes(gui)
    gui.DescendantAdded:Connect(function(d)
        if d:IsA("UIStroke") then task.defer(function() if d and d.Parent then d:Destroy() end end) end
    end)

    -- Funciones auxiliares
    local function mkSect(txt)
        local pageIndex = ({
            Speed = 1, Mechanics = 1, Visual = 1, ["Auto Left / Right"] = 1, Steal = 1, Interface = 1, Config = 1,
            Combat = 2,
            Animations = 3, Teleport = 3,
            Music = 4,
            Keybinds = 5
        })[txt]
        if pageIndex and pages[pageIndex] then
            scrollPage = pages[pageIndex]
        end
        local f = Instance.new("Frame", scrollPage)
        f.Size = UDim2.new(1, 0, 0, 22)
        f.BackgroundTransparency = 1
        f.BorderSizePixel = 0
        local l = Instance.new("TextLabel", f)
        l.Size = UDim2.new(1, -10, 1, 0)
        l.Position = UDim2.new(0, 10, 0, 0)
        l.BackgroundTransparency = 1
        l.Text = txt:upper()
        l.TextColor3 = Color3.fromRGB(255, 255, 255) -- BLANCO
        l.Font = Enum.Font.FredokaOne
        l.TextSize = 10
        l.TextXAlignment = Enum.TextXAlignment.Left
        f.LayoutOrder = #scrollPage:GetChildren() + 1
        applyShimmerToText(l, 0.5)
        local line = Instance.new("Frame", f)
        line.Size = UDim2.new(1, -20, 0, 1)
        line.Position = UDim2.new(0, 10, 1, -2)
        line.BackgroundColor3 = Color3.fromRGB(80,80,80)
        line.BackgroundTransparency = 0.5
        line.BorderSizePixel = 0
        return f
    end

    local function mkRow(h)
        local f = Instance.new("Frame", scrollPage)
        f.Size = UDim2.new(1, -2, 0, h or 38)
        f.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
f.BackgroundTransparency = 0.50
        f.BorderSizePixel = 0
        f.LayoutOrder = #scrollPage:GetChildren() + 1
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)
        local rowGrad = Instance.new("UIGradient", f)
        rowGrad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(5,5,5)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(20,20,20)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(5,5,5))
        })
        rowGrad.Rotation = 90
        rowGrad.Offset = Vector2.new(0,0)
        task.spawn(function()
            local t=0
            while rowGrad and rowGrad.Parent do
                t = t + 0.02
                rowGrad.Offset = Vector2.new(math.sin(t * 0.2) * 0.1, 0)
                task.wait(0.04)
            end
        end)
        f.MouseEnter:Connect(function()
            TS:Create(f, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(15,15,15)}):Play()
        end)
        f.MouseLeave:Connect(function()
            TS:Create(f, TweenInfo.new(0.12), {BackgroundColor3 = BLACK}):Play()
        end)
        return f
    end

    local function mkLabel(row, txt)
        local l = Instance.new("TextLabel", row)
        l.Size = UDim2.new(0.55, 0, 1, 0)
        l.Position = UDim2.new(0, 8, 0, 0)
        l.BackgroundTransparency = 1
        l.Text = txt
        l.TextColor3 = Color3.fromRGB(255, 255, 255) -- BLANCO
        l.Font = Enum.Font.FredokaOne
        l.TextSize = 10
        l.TextXAlignment = Enum.TextXAlignment.Left
        applyShimmerToText(l, 0.6)
        return l
    end

    local function mkPill(row, offset)
        local pill = Instance.new("Frame", row)
        pill.Size = UDim2.new(0, 42, 0, 22)
        pill.Position = UDim2.new(1, -(offset or 52), 0.5, -11)
        pill.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        pill.BorderSizePixel = 0
        Instance.new("UICorner", pill).CornerRadius = UDim.new(1, 0)
        local dot = Instance.new("Frame", pill)
        dot.Size = UDim2.new(0, 16, 0, 16)
        dot.Position = UDim2.new(0, 3, 0.5, -8)
        dot.BackgroundColor3 = Color3.fromRGB(130,130,130)
        dot.BorderSizePixel = 0
        Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
        return pill, dot
    end

    local function animPill(pill, dot, on)
        TS:Create(pill,TweenInfo.new(0.18,Enum.EasingStyle.Quad),{BackgroundColor3=on and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(0, 0, 0)}):Play()
        TS:Create(dot,TweenInfo.new(0.18,Enum.EasingStyle.Back),{
            Position=on and UDim2.new(1,-19,0.5,-8) or UDim2.new(0,3,0.5,-8),
            BackgroundColor3=on and Color3.fromRGB(0,0,0) or Color3.fromRGB(130,130,130)
        }):Play()
    end

    local function mkToggle(txt, cb)
        local row = mkRow(38)
        mkLabel(row, txt)
        local pill, dot = mkPill(row, 52)
        local on = false
        local function sv(s) on=s; animPill(pill,dot,s) end
        local clk = Instance.new("TextButton", pill)
        clk.Size = UDim2.new(1,0,1,0)
        clk.BackgroundTransparency = 1
        clk.Text = ""
        clk.Activated:Connect(function()
            on = not on
            sv(on)
            pcall(cb, on)
        end)
        return sv
    end

    local function mkBox(parent, default, w, xOff, cb)
        local tb = Instance.new("TextBox", parent)
        local bw = w or 45
        local xo = math.max(xOff or 52, bw + 8)
        tb.Size = UDim2.new(0, bw, 0, 24)
        tb.Position = UDim2.new(1, -xo, 0.5, -12)
        tb.BackgroundColor3 = INP
        tb.BackgroundTransparency = 0.38
        tb.BorderSizePixel = 0
        tb.Text = tostring(default)
        tb.TextColor3 = Color3.fromRGB(255, 255, 255) -- BLANCO
        tb.Font = Enum.Font.FredokaOne
        tb.TextSize = 10
        tb.ClearTextOnFocus = false
        Instance.new("UICorner", tb).CornerRadius = UDim.new(0, 6)
        local bs = Instance.new("UIStroke", tb)
        bs.Color = Color3.fromRGB(255, 255, 255)
        bs.Thickness = 1
        bs.Transparency = 0.28
        tb.Focused:Connect(function() TS:Create(bs,TweenInfo.new(0.12),{Color=Color3.fromRGB(255, 255, 255),Transparency=0}):Play() end)
        tb.FocusLost:Connect(function()
            TS:Create(bs,TweenInfo.new(0.12),{Color=Color3.fromRGB(80,80,80),Transparency=0.28}):Play()
            if cb then local n = tonumber(tb.Text); if n then cb(n) else tb.Text = tostring(default) end end
        end)
        applyShimmerToText(tb, 0.7)
        return tb
    end

    local function mkSelector(parent, default, cb)
        local btn = Instance.new("TextButton", parent)
        btn.Size = UDim2.new(0, 48, 0, 24)
        btn.Position = UDim2.new(1, -52, 0.5, -12)
        btn.BackgroundColor3 = INP
        btn.BackgroundTransparency = 0.38
        btn.BorderSizePixel = 0
        btn.Text = default
        btn.TextColor3 = Color3.fromRGB(255, 255, 255) -- BLANCO
        btn.Font = Enum.Font.FredokaOne
        btn.TextSize = 11
        btn.TextXAlignment = Enum.TextXAlignment.Center
        btn.TextScaled = false
        btn.ClipsDescendants = false
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
        local stroke = Instance.new("UIStroke", btn)
        stroke.Color = Color3.fromRGB(255, 255, 255)
        stroke.Thickness = 1
        btn.MouseButton1Click:Connect(function()
            if _anyKeyListening then return end
            if cb then cb(btn) end
        end)
        applyShimmerToText(btn, 0.7)
        return btn
    end

    -- ====== PANEL DE SELECCIÓN ======
    local activeChoiceOverlay = nil
    local function openChoicePanel(titleText, items, selectedText, onChoose, themeColor)
        if activeChoiceOverlay then
            pcall(function() activeChoiceOverlay:Destroy() end)
            activeChoiceOverlay = nil
        end

        -- Panel de selección separado de la ventana principal.
        local overlay = Instance.new("Frame", gui)
        activeChoiceOverlay = overlay
        overlay.Name = "ChoiceOverlay"
        overlay.Size = UDim2.new(1, 0, 1, 0)
        overlay.Position = UDim2.new(0, 0, 0, 0)
        overlay.BackgroundTransparency = 1
        overlay.BorderSizePixel = 0
        overlay.ZIndex = 500

        local panel = Instance.new("Frame", overlay)
        panel.Size = UDim2.new(0, GUI_W - 34, 0, 360)
        panel.Position = UDim2.fromOffset(
            main.AbsolutePosition.X + 17,
            main.AbsolutePosition.Y + math.max(0, (main.AbsoluteSize.Y - 360) / 2)
        )
        panel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        panel.BackgroundTransparency = themeColor and 0 or 0.03
        panel.BorderSizePixel = 0
        panel.ZIndex = 501
        Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 14)
        local ps = Instance.new("UIStroke", panel)
        ps.Color = Color3.fromRGB(255, 255, 255)
        ps.Thickness = 1.2
        ps.Transparency = 0.2

        local title = Instance.new("TextLabel", panel)
        title.Size = UDim2.new(1, -54, 0, 38)
        title.Position = UDim2.new(0, 14, 0, 5)
        title.BackgroundTransparency = 1
        title.Active = true
        title.Text = titleText
        title.TextColor3 = themeColor or Color3.fromRGB(255, 255, 255)
        title.Font = Enum.Font.FredokaOne
        title.TextSize = 14
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.ZIndex = 502

        local close = Instance.new("TextButton", panel)
        close.Size = UDim2.new(0, 30, 0, 30)
        close.Position = UDim2.new(1, -36, 0, 8)
        close.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        close.BorderSizePixel = 0
        close.Text = "X"
        close.TextColor3 = Color3.fromRGB(255, 255, 255)
        close.Font = Enum.Font.FredokaOne
        close.TextSize = 12
        close.ZIndex = 503
        Instance.new("UICorner", close).CornerRadius = UDim.new(0, 8)

        -- Arrastre independiente usando la barra del título.
        local draggingChoice = false
        local dragStart = nil
        local startPos = nil

        title.InputBegan:Connect(function(input)
            if uiLocked then return end
            if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                draggingChoice = true
                dragStart = input.Position
                startPos = panel.Position
            end
        end)

        UIS.InputChanged:Connect(function(input)
            if not draggingChoice or uiLocked or not dragStart or not startPos then return end
            if input.UserInputType == Enum.UserInputType.MouseMovement
                or input.UserInputType == Enum.UserInputType.Touch then
                local delta = input.Position - dragStart
                panel.Position = UDim2.new(
                    startPos.X.Scale, startPos.X.Offset + delta.X,
                    startPos.Y.Scale, startPos.Y.Offset + delta.Y
                )
            end
        end)

        UIS.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                draggingChoice = false
                dragStart = nil
                startPos = nil
            end
        end)

        local scroll = Instance.new("ScrollingFrame", panel)
        scroll.Size = UDim2.new(1, -20, 1, -54)
        scroll.Position = UDim2.new(0, 10, 0, 46)
        scroll.BackgroundTransparency = 1
        scroll.BorderSizePixel = 0
        scroll.ScrollBarThickness = 4
        scroll.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
        scroll.CanvasSize = UDim2.new(0,0,0,0)
        scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
        scroll.ZIndex = 502

        local listLayout = Instance.new("UIListLayout", scroll)
        listLayout.SortOrder = Enum.SortOrder.LayoutOrder
        listLayout.Padding = UDim.new(0, 6)

        local padding = Instance.new("UIPadding", scroll)
        padding.PaddingLeft = UDim.new(0, 2)
        padding.PaddingRight = UDim.new(0, 6)
        padding.PaddingTop = UDim.new(0, 2)
        padding.PaddingBottom = UDim.new(0, 6)

        local function closePanel()
            if overlay and overlay.Parent then overlay:Destroy() end
            if activeChoiceOverlay == overlay then activeChoiceOverlay = nil end
        end
        close.Activated:Connect(closePanel)

        for index, text in ipairs(items) do
            local option = Instance.new("TextButton", scroll)
            option.Size = UDim2.new(1, -8, 0, 34)
            option.BackgroundColor3 = (text == selectedText) and (themeColor or Color3.fromRGB(255, 255, 255)) or (themeColor and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(0, 0, 0))
            option.BackgroundTransparency = (text == selectedText) and 0.05 or 0.18
            option.BorderSizePixel = 0
            option.Text = text
            option.TextColor3 = (text == selectedText) and Color3.fromRGB(0, 0, 0) or (themeColor or Color3.fromRGB(255, 255, 255))
            option.Font = Enum.Font.FredokaOne
            option.TextSize = 11
            option.TextXAlignment = Enum.TextXAlignment.Left
            option.ZIndex = 503
            Instance.new("UICorner", option).CornerRadius = UDim.new(0, 9)
            local opad = Instance.new("UIPadding", option)
            opad.PaddingLeft = UDim.new(0, 12)
            local ost = Instance.new("UIStroke", option)
            ost.Color = (text == selectedText) and (themeColor or Color3.fromRGB(255, 255, 255)) or Color3.fromRGB(40, 40, 40)
            ost.Thickness = 1
            ost.Transparency = (text == selectedText) and 0.1 or 0.55
            option.Activated:Connect(function()
                if onChoose then onChoose(index, text) end
                closePanel()
            end)
        end
    end

    -- ====== SPEED SECTION ======
    mkSect("Speed")
    do local row=mkRow(38); mkLabel(row,"Normal Speed"); normalBox=mkBox(row,NS,45,52,function(v) if v>0 and v<=500 then NS=v end end) end
    do local row=mkRow(38); mkLabel(row,"Carry Speed"); carryBox=mkBox(row,CS,45,52,function(v) if v>0 and v<=500 then CS=v end end) end
    do local row=mkRow(38); mkLabel(row,"Lagger 1 Speed"); laggerBox=mkBox(row,LAGGER_SPEED_1,45,52,function(v) if v>0 and v<=500 then LAGGER_SPEED_1=v end end) end
    do local row=mkRow(38); mkLabel(row,"Lagger 2 Speed"); lagger2Box=mkBox(row,LAGGER_SPEED_2,45,52,function(v) if v>0 and v<=500 then LAGGER_SPEED_2=v end end) end
    do local row=mkRow(38); mkLabel(row,"Current Mode"); modeValLbl=Instance.new("TextLabel",row); modeValLbl.Size=UDim2.new(0,90,1,0); modeValLbl.Position=UDim2.new(1,-94,0,0); modeValLbl.BackgroundTransparency=1; modeValLbl.Text="Normal"; modeValLbl.TextColor3=Color3.fromRGB(255, 255, 255); modeValLbl.Font=Enum.Font.FredokaOne; modeValLbl.TextSize=11; modeValLbl.TextXAlignment=Enum.TextXAlignment.Right; applyShimmerToText(modeValLbl, 0.8); local clk=Instance.new("TextButton",row); clk.Size=UDim2.new(1,0,1,0); clk.BackgroundTransparency=1; clk.Text=""; clk.Activated:Connect(function() if _anyKeyListening then return end; toggleCarryMode() end) end

    -- ====== COMBAT SECTION ======
    
    -- [[ ANIMATION MENU BLINDADO ]]
    pcall(function()
        mkSect("Animations")
        mkToggle("Anim Pack", function(on)
            if _G.toggleAnimSystem then pcall(_G.toggleAnimSystem, on) end
        end)
        local row = mkRow(38)
        mkLabel(row, "Pack Select")
        local list = {"Ninja", "Amazon", "Mage", "Vampire", "Adidas", "Anim Pack", "Adidas Sports", "Adidas Aura", "Wicked Popular", "Elder", "Astronaut", 'Wicked "Dancing Through Life"', "Werewolf", "Superhero", "Toy", "No Boundaries", "NFL"}
        local animSelectorBtn
        -- Obtener el nombre del pack actual, con fallback
    local currentAnimPack = (_G.getAnimPack and _G.getAnimPack()) or "Ninja"
    if not currentAnimPack or currentAnimPack == "" then currentAnimPack = "Ninja" end
    animSelectorBtn = mkSelector(row, currentAnimPack, function(b)
            local cur = (_G.getAnimPack and _G.getAnimPack()) or "Ninja"
            openChoicePanel("ANIMATION PACKS", list, cur, function(_, packName)
                if _G.setAnimPack then pcall(_G.setAnimPack, packName) end
                b.Text = packName
                pcall(saveAllSettings)
            end, Color3.fromRGB(255, 255, 255))
        end)
    end)
mkSect("Combat")
    autoBatSetVisual = mkToggle("Auto Bat", function(on)
        if on then enableAutoBat() else disableAutoBat() end
        if mobSetAutoBat then mobSetAutoBat(on) end
    end)
    do local row=mkRow(38); mkLabel(row,"Bat Speed"); batSpeedBox=mkBox(row,BAT_AIMBOT_SPEED,45,52,function(v) if v>0 and v<=200 then BAT_AIMBOT_SPEED=v end end) end

    do local row=mkRow(38); mkLabel(row,"Bypass Speed"); bypassSpeedBox=mkBox(row,BYPASS_AIMBOT_SPEED,45,52,function(v) if v>0 and v<=200 then BYPASS_AIMBOT_SPEED=v end end) end

    setBatCounterVisual = mkToggle("Bat Counter", function(on)
        batCounterEnabled = on
        if on then startBatCounter() else stopBatCounter() end
    end)

    setMedusaVisual = mkToggle("Medusa Counter", function(on)
        setMedusaCounterState(on)
    end)

    setMedusaAutoResetVisual = mkToggle("Medusa Auto Reset", function(on)
        setMedusaAutoResetState(on)
    end)

    setAntiRagVisual = mkToggle("Anti Ragdoll", function(on)
        antiRagdollEnabled = on
        if on then startAntiRagdoll() else stopAntiRagdoll() end
    end)

    -- ====== MECHANICS SECTION ======
    mkSect("Mechanics")
    local Steal = {
    AutoStealEnabled = true,  -- <--- CAMBIADO A true (siempre activado)
    StealRadius = 61.5,
    StealDuration = 1.37,
    Data = {},
    cachedPrompts = {},
    promptCacheTime = 0,
}

local Semi = {
    enabled = false,
    holdMin = 1.3,
    holdMax = 2.6,
    entryDelay = 0.3,
    cooldown = 0.05,
    primeRange = 80,
    radius = 10,
    animals = {},
    promptCache = {},
    internalCache = {},
    state = {active = false, startTime = 0, phase = "idle", label = "", lastResult = "", lastResultTime = 0},
    syncReady = false,
    plotSync = {caches = {}, connections = {}},
}

local isStealing = false
local stealStartTime = nil
local lastStealTick = 0
local STEAL_COOLDOWN = 0.1
local PROMPT_CACHE_REFRESH = 0.15
local STEAL_STATE_FILE = "drakauhub_StealState.json"
local stealScanThread = nil
local stealHeartbeatConn = nil
local stealPlotAddedConn = nil
local stealPlotChildAddedConns = {}

local function saveStealState()
    local config = {
        autoStealEnabled = Steal.AutoStealEnabled,
        stealRadius = Steal.StealRadius,
        stealDuration = Steal.StealDuration,
        semiRadius = Semi.radius,
        semiHoldMin = Semi.holdMin,
        semiHoldMax = Semi.holdMax,
        semiEntryDelay = Semi.entryDelay,
        semiPrimeRange = Semi.primeRange,
    }
    if type(writefile) == "function" then
        pcall(function()
            writefile(STEAL_STATE_FILE, game:GetService("HttpService"):JSONEncode(config))
        end)
    end
end

local function loadStealState()
    if type(isfile) == "function" and isfile(STEAL_STATE_FILE) then
        local ok, data = pcall(function()
            return game:GetService("HttpService"):JSONDecode(readfile(STEAL_STATE_FILE))
        end)
        if ok and type(data) == "table" then
            if data.autoStealEnabled ~= nil then Steal.AutoStealEnabled = data.autoStealEnabled end
            if data.stealRadius then Steal.StealRadius = data.stealRadius end
            if data.stealDuration then Steal.StealDuration = data.stealDuration end
            if data.semiRadius then Semi.radius = math.min(data.semiRadius, 10) end
            if data.semiHoldMin then Semi.holdMin = data.holdMin end
            if data.semiHoldMax then Semi.holdMax = data.holdMax end
            if data.semiEntryDelay then Semi.entryDelay = data.entryDelay end
            if data.semiPrimeRange then Semi.primeRange = data.primeRange end
            return true
        end
    end
    return false
end

loadStealState()

local function rootPart()
    local char = LP.Character
    return char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso")) or nil
end

local function isMyPlotByName(plotName)
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return false end
    local plot = plots:FindFirstChild(plotName)
    if not plot then return false end
    local sign = plot:FindFirstChild("PlotSign")
    if sign then
        local yb = sign:FindFirstChild("YourBase")
        if yb and yb:IsA("BillboardGui") then
            return yb.Enabled == true
        end
    end
    return false
end

local function findNearestPrompt()
    local char = LP.Character
    if not char then return nil, math.huge end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return nil, math.huge end

    local ct = tick()
    if ct - Steal.promptCacheTime < PROMPT_CACHE_REFRESH and #Steal.cachedPrompts > 0 then
        local np, nd = nil, math.huge
        for _, data in ipairs(Steal.cachedPrompts) do
            if data.prompt and data.prompt.Parent and data.prompt.Enabled ~= false then
                local dist = (data.spawn.Position - root.Position).Magnitude
                if dist <= Steal.StealRadius and dist < nd then
                    np = data.prompt
                    nd = dist
                end
            end
        end
        if np then return np, nd end
    end

    Steal.cachedPrompts = {}
    Steal.promptCacheTime = ct
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return nil, math.huge end

    local np, nd = nil, math.huge
    for _, plot in ipairs(plots:GetChildren()) do
        if not isMyPlotByName(plot.Name) then
            local pods = plot:FindFirstChild("AnimalPodiums")
            if pods then
                for _, pod in ipairs(pods:GetChildren()) do
                    pcall(function()
                        local base = pod:FindFirstChild("Base")
                        local spawn = base and base:FindFirstChild("Spawn")
                        if spawn then
                            local att = spawn:FindFirstChild("PromptAttachment")
                            if att then
                                for _, child in ipairs(att:GetChildren()) do
                                    if child:IsA("ProximityPrompt") and child.ActionText and child.ActionText:find("Steal") then
                                        local dist = (spawn.Position - root.Position).Magnitude
                                        table.insert(Steal.cachedPrompts, {prompt = child, spawn = spawn})
                                        if dist <= Steal.StealRadius and dist < nd then
                                            np = child
                                            nd = dist
                                        end
                                    end
                                end
                            end
                        end
                    end)
                end
            end
        end
    end
    return np, nd
end

local function splitPath(path)
    if typeof(path) == "table" then return path end
    local out = {}
    for part in string.gmatch(tostring(path), "[^%.]+") do
        table.insert(out, tonumber(part) or part)
    end
    return out
end

local function resolvePath(path, root)
    local current, parent, key = root, nil, nil
    for _, part in ipairs(splitPath(path)) do
        parent = current
        key = part
        current = current and current[part] or nil
    end
    return current, parent, key
end

local function applySyncDiff(channelName, packet)
    local cache = Semi.plotSync.caches[channelName]
    if typeof(cache) ~= "table" then return end
    local path, action, a, b = packet[1], packet[2], packet[3], packet[4]
    local current, parent, key = resolvePath(path, cache)
    if action == "Changed" then
        if parent ~= nil then parent[key] = a end
    elseif action == "ArrayInsert" then
        if current ~= nil then table.insert(current, b, a) end
    elseif action == "ArrayRemoved" then
        if current ~= nil then table.remove(current, b) end
    elseif action == "DictionaryInsert" then
        if current ~= nil then current[b] = a end
    elseif action == "DictionaryRemoved" then
        if current ~= nil then current[b] = nil end
    end
end

local function attachPlotChannel(remote, plots, requestData)
    if Semi.plotSync.connections[remote] then return end
    local channelName = tostring(remote.Name)
    if not plots:FindFirstChild(channelName) then return end
    if requestData and Semi.plotSync.caches[channelName] == nil then
        local ok, data = pcall(function() return requestData:InvokeServer(channelName) end)
        Semi.plotSync.caches[channelName] = (ok and typeof(data) == "table") and data or {}
    elseif Semi.plotSync.caches[channelName] == nil then
        Semi.plotSync.caches[channelName] = {}
    end
    Semi.plotSync.connections[remote] = remote.OnClientEvent:Connect(function(queue)
        for _, packet in ipairs(queue) do applySyncDiff(channelName, packet) end
    end)
end

function initSemiSync()
    if Semi.syncReady then return true end
    local ok = pcall(function()
        local rs = game:GetService("ReplicatedStorage")
        Semi.packages = rs:WaitForChild("Packages", 10)
        Semi.datas = rs:WaitForChild("Datas", 10)
        Semi.plots = workspace:WaitForChild("Plots", 10)
        if not (Semi.packages and Semi.datas and Semi.plots) then return end
        Semi.animalsData = require(Semi.datas:WaitForChild("Animals", 10))
        local sync = Semi.packages:WaitForChild("Synchronizer", 10)
        Semi.channelFolder = sync:WaitForChild("Channel", 10)
        Semi.routeRemote = sync:WaitForChild("CommunicationRoute", 10)
        Semi.requestData = sync:FindFirstChild("RequestData")
        for _, child in ipairs(Semi.channelFolder:GetChildren()) do
            if child:IsA("RemoteEvent") then attachPlotChannel(child, Semi.plots, Semi.requestData) end
        end
        Semi.channelFolder.ChildAdded:Connect(function(child)
            if child:IsA("RemoteEvent") then attachPlotChannel(child, Semi.plots, Semi.requestData) end
        end)
        Semi.routeRemote.OnClientEvent:Connect(function(actions)
            for _, action in ipairs(actions) do
                local kind, channelName = action[1], tostring(action[2])
                if Semi.plots and Semi.plots:FindFirstChild(channelName) then
                    if kind == "ListenerAdded" then
                        local remote = Semi.channelFolder and Semi.channelFolder:FindFirstChild(channelName)
                        if remote and remote:IsA("RemoteEvent") then attachPlotChannel(remote, Semi.plots, Semi.requestData) end
                    elseif kind == "ListenerRemoved" then
                        for remote, conn in pairs(Semi.plotSync.connections) do
                            if tostring(remote.Name) == channelName then
                                pcall(function() conn:Disconnect() end)
                                Semi.plotSync.connections[remote] = nil
                                Semi.plotSync.caches[channelName] = nil
                                break
                            end
                        end
                    end
                end
            end
        end)
        Semi.syncReady = true
    end)
    return ok and Semi.syncReady == true
end

local function getPlotOwner(plot)
    local sign = plot and plot:FindFirstChild("PlotSign")
    local frame = sign and sign:FindFirstChild("SurfaceGui") and sign.SurfaceGui:FindFirstChild("Frame")
    local label = frame and frame:FindFirstChild("TextLabel")
    if not label or label.Text == "Empty Base" then return nil end
    return label.Text:gsub("'s [Bb]ase$", ""):gsub("%s+$", "")
end

local function isMyBaseAnimal(animalData)
    if not animalData or not animalData.plot or not Semi.plots then return false end
    local plot = Semi.plots:FindFirstChild(animalData.plot)
    if not plot then return false end
    local owner = getPlotOwner(plot)
    return owner == LP.DisplayName or owner == LP.Name
end

local function podiumFor(animalData)
    local plot = Semi.plots and Semi.plots:FindFirstChild(animalData.plot)
    local podiums = plot and plot:FindFirstChild("AnimalPodiums")
    return podiums and podiums:FindFirstChild(animalData.slot) or nil
end

local function animalPos(animalData)
    local podium = podiumFor(animalData)
    return podium and podium:GetPivot().Position or nil
end

local function distToAnimal(animalData)
    local root = rootPart()
    local pos = animalPos(animalData)
    return root and pos and (root.Position - pos).Magnitude or math.huge
end

local function findPromptForAnimal(animalData)
    if not animalData then return nil end
    local cached = Semi.promptCache[animalData.uid]
    if cached and cached.Parent then return cached end
    local podium = podiumFor(animalData)
    local base = podium and podium:FindFirstChild("Base")
    local spawn = base and base:FindFirstChild("Spawn")
    local attach = spawn and spawn:FindFirstChild("PromptAttachment")
    if not attach then return nil end
    for _, prompt in ipairs(attach:GetChildren()) do
        if prompt:IsA("ProximityPrompt") then
            Semi.promptCache[animalData.uid] = prompt
            return prompt
        end
    end
    return nil
end

function scanAllPlotsSemi()
    if not initSemiSync() then return 0 end
    local newCache = {}
    for _, plot in ipairs(Semi.plots:GetChildren()) do
        local cache = Semi.plotSync.caches[plot.Name]
        local animalList = cache and cache.AnimalList
        if typeof(animalList) == "table" then
            for slot, animalData in pairs(animalList) do
                if type(animalData) == "table" then
                    local animalName = animalData.Index
                    local info = Semi.animalsData and Semi.animalsData[animalName]
                    if info then
                        table.insert(newCache, {
                            name = info.DisplayName or animalName,
                            plot = plot.Name,
                            slot = tostring(slot),
                            uid = plot.Name .. "_" .. tostring(slot),
                        })
                    end
                end
            end
        end
    end
    Semi.animals = newCache
    return #newCache
end

local function pickClosest()
    local root = rootPart()
    if not root then return nil end
    local best, bestDist = nil, math.huge
    for _, animalData in ipairs(Semi.animals) do
        if not isMyBaseAnimal(animalData) then
            local pos = animalPos(animalData)
            local dist = pos and (root.Position - pos).Magnitude or math.huge
            if dist <= (Semi.primeRange or 80) and dist < bestDist then
                best, bestDist = animalData, dist
            end
        end
    end
    return best
end

local function buildCallbacks(prompt)
    if Semi.internalCache[prompt] then return end
    local data = {holdCallbacks = {}, triggerCallbacks = {}, ready = true}
    local okHold, holds = pcall(getconnections, prompt.PromptButtonHoldBegan)
    if okHold and type(holds) == "table" then
        for _, conn in ipairs(holds) do
            if type(conn.Function) == "function" then table.insert(data.holdCallbacks, conn.Function) end
        end
    end
    local okTrigger, triggers = pcall(getconnections, prompt.Triggered)
    if okTrigger and type(triggers) == "table" then
        for _, conn in ipairs(triggers) do
            if type(conn.Function) == "function" then table.insert(data.triggerCallbacks, conn.Function) end
        end
    end
    if #data.holdCallbacks > 0 or #data.triggerCallbacks > 0 then Semi.internalCache[prompt] = data end
end

local function resetProgressBar()
    if progressPct then progressPct.Text = "0%" end
    if progressFill then progressFill.Size = UDim2.new(0, 0, 1, 0) end
end

local function updateStealProgress(progress, label)
    progress = math.clamp(progress or 0, 0, 1)
    local pct = math.floor(progress * 100 + 0.5)

    if progressFill then
        progressFill.Size = UDim2.fromScale(progress, 1)
        if label and string.find(label, "HOLDING") then
            progressFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        elseif label and string.find(label, "MOVE CLOSER") then
            progressFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        elseif label and string.find(label, "STOLE") then
            progressFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        elseif label and string.find(label, "MISSED") then
            progressFill.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        else
            progressFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        end
    end

    if progressPct then
        if type(label) == "string" and label ~= "" then
            progressPct.Text = label
        elseif progress > 0 then
            progressPct.Text = pct .. "%"
        else
            progressPct.Text = Steal.AutoStealEnabled and "READY" or "IDLE"
        end
    end
end

function updateProgressBarVisibility()
    if pbFrame then
        pbFrame.Visible = true  -- <--- CAMBIA esto
        if not Steal.AutoStealEnabled then
            resetProgressBar()
            if progressPct then progressPct.Text = "IDLE" end
        end
    end
end

local function scanPlotForAnimals(plot)
    if not plot or not plot:IsA("Model") then return end
    local pods = plot:FindFirstChild("AnimalPodiums")
    if not pods then return end

    local newAnimals = {}
    for _, pod in ipairs(pods:GetChildren()) do
        if pod:IsA("Model") and pod:FindFirstChild("Base") then
            local uid = plot.Name .. "_" .. pod.Name
            local alreadyExists = false
            for _, existing in ipairs(Semi.animals) do
                if existing.uid == uid then
                    alreadyExists = true
                    break
                end
            end
            if not alreadyExists then
                local animalData = {
                    name = pod.Name,
                    plot = plot.Name,
                    slot = pod.Name,
                    uid = uid,
                }
                table.insert(newAnimals, animalData)
                table.insert(Semi.animals, animalData)
            end
        end
    end
    return #newAnimals
end

local function scanAllPlots()
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return 0 end
    local count = 0
    for _, plot in ipairs(plots:GetChildren()) do
        if plot:IsA("Model") then
            count = count + scanPlotForAnimals(plot)
        end
    end
    return count
end

local function setupPlotListeners()
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return end

    if stealPlotAddedConn then
        stealPlotAddedConn:Disconnect()
        stealPlotAddedConn = nil
    end

    for _, conn in pairs(stealPlotChildAddedConns) do
        pcall(function() conn:Disconnect() end)
    end
    stealPlotChildAddedConns = {}

    local function onPlotAdded(plot)
        if plot:IsA("Model") then
            task.wait(0.5)
            pcall(scanPlotForAnimals, plot)
            local pods = plot:FindFirstChild("AnimalPodiums")
            if pods then
                local conn = pods.ChildAdded:Connect(function(pod)
                    task.wait(0.3)
                    pcall(scanPlotForAnimals, plot)
                end)
                table.insert(stealPlotChildAddedConns, conn)
            end
        end
    end

    for _, plot in ipairs(plots:GetChildren()) do
        if plot:IsA("Model") then
            local pods = plot:FindFirstChild("AnimalPodiums")
            if pods then
                local conn = pods.ChildAdded:Connect(function(pod)
                    task.wait(0.3)
                    pcall(scanPlotForAnimals, plot)
                end)
                table.insert(stealPlotChildAddedConns, conn)
            end
        end
    end

    stealPlotAddedConn = plots.ChildAdded:Connect(onPlotAdded)
end

local function executeSemi(prompt, animalData)
    if not prompt or not prompt.Parent or not animalData then return false end
    buildCallbacks(prompt)
    local data = Semi.internalCache[prompt]
    if not data or not data.ready then return false end
    data.ready = false
    Semi.state.active = true
    Semi.state.startTime = tick()
    Semi.state.phase = "holding"
    Semi.state.label = animalData.name or "Animal"
    isStealing = true
    stealStartTime = Semi.state.startTime

    task.spawn(function()
        local startTime = Semi.state.startTime

        for _, fn in ipairs(data.holdCallbacks) do
            task.spawn(function() pcall(fn) end)
        end

        while Semi.enabled and tick() - startTime < (Semi.holdMin or 1.3) do
            local elapsed = tick() - startTime
            Semi.state.phase = "holding"
            updateStealProgress(elapsed / (Semi.holdMax or 2.6), "HOLDING " .. tostring(Semi.state.label))
            task.wait()
        end

        Semi.state.phase = "waitingRange"
        local alreadyInRange = distToAnimal(animalData) <= (tonumber(Semi.radius) or 10)
        local fired = false

        while Semi.enabled and prompt.Parent do
            local elapsed = tick() - startTime
            if elapsed > (Semi.holdMax or 2.6) then break end

            local dist = distToAnimal(animalData)
            updateStealProgress(elapsed / (Semi.holdMax or 2.6), "MOVE CLOSER  " .. tostring(Semi.state.label) .. "  (" .. string.format("%.1f", dist) .. ")")

            if dist <= (tonumber(Semi.radius) or 10) then
                if not alreadyInRange then task.wait(Semi.entryDelay or 0.3) end
                if Semi.enabled then
                    for _, fn in ipairs(data.triggerCallbacks) do
                        task.spawn(function() pcall(fn) end)
                    end
                    fired = true
                end
                break
            end
            task.wait()
        end

        Semi.state.lastResult = fired and ("STOLE " .. tostring(Semi.state.label)) or ("MISSED: " .. tostring(Semi.state.label))
        Semi.state.active = false
        Semi.state.phase = "idle"
        Semi.state.lastResultTime = tick()

        if fired then
            updateStealProgress(1, "STOLE " .. tostring(Semi.state.label))
        else
            updateStealProgress(0, "MISSED: " .. tostring(Semi.state.label))
        end

        task.wait(Semi.cooldown or 0.05)
        data.ready = true
        task.wait(0.5)
        resetProgressBar()
        isStealing = false
    end)
    return true
end

local stealScanThread = nil

local function startAnimalScan()
    if stealScanThread then return end
    stealScanThread = task.spawn(function()
        while true do
            if Steal.AutoStealEnabled then
                pcall(scanAllPlotsSemi)
            end
            task.wait(2)
        end
    end)
end

local function stopAnimalScan()
    if stealScanThread then
        task.cancel(stealScanThread)
        stealScanThread = nil
    end
end

function stopSemiSteal()
    Semi.enabled = false
    if stealHeartbeatConn then
        stealHeartbeatConn:Disconnect()
        stealHeartbeatConn = nil
    end
    Semi.state.active = false
    Semi.state.phase = "idle"
    isStealing = false
    resetProgressBar()
    stopAnimalScan()
    saveStealState()
end

function startSemiSteal()
    Semi.radius = math.min(tonumber(Semi.radius) or 10, 10)
    Semi.enabled = true
    initSemiSync()
    pcall(scanAllPlotsSemi)
    pcall(setupPlotListeners)
    startAnimalScan()

    if stealHeartbeatConn then
        stealHeartbeatConn:Disconnect()
        stealHeartbeatConn = nil
    end

    stealHeartbeatConn = RunService.Heartbeat:Connect(function()
        if not Semi.enabled then return end
        if not Steal.AutoStealEnabled then return end
        if isStealing then return end
        if Semi.state.active then return end

        local target = pickClosest()
        if not target then return end
        local prompt = findPromptForAnimal(target)
        if prompt then executeSemi(prompt, target) end
    end)
    saveStealState()
end

function startAutoSteal()
    startSemiSteal()
    updateProgressBarVisibility()
    saveStealState()
end

function stopAutoSteal()
    stopSemiSteal()
    updateProgressBarVisibility()
    saveStealState()
end

Steal.AutoStealEnabled = true  -- <--- CAMBIADO A true
Semi.radius = 10
Semi.holdMin = 1.3
Semi.holdMax = 2.6
Semi.entryDelay = 0.3
Semi.primeRange = 80

setInstaGrab = mkToggle("Auto Steal", function(on)
    Steal.AutoStealEnabled = on
    if on then
        pcall(startAutoSteal)
    else
        pcall(stopAutoSteal)
    end
    updateProgressBarVisibility()
    if setInstaGrab then setInstaGrab(on) end
end)

-- Forzar estado inicial según la variable Steal.AutoStealEnabled (que es true)
if Steal.AutoStealEnabled then
    task.spawn(function()
        task.wait(0.3)
        pcall(startAutoSteal)
        updateProgressBarVisibility()
        if setInstaGrab then setInstaGrab(true) end
    end)
else
    -- Si está desactivado, asegurar que todo esté detenido
    task.spawn(function()
        pcall(stopAutoSteal)
        updateProgressBarVisibility()
        if setInstaGrab then setInstaGrab(false) end
    end)
end

-- Ya no hay bucle que fuerce la activación. Esto permite que el toggle funcione correctamente.

LP.CharacterAdded:Connect(function()
    task.wait(1)
    pcall(scanAllPlotsSemi)
    pcall(setupPlotListeners)
    if Steal.AutoStealEnabled then
        pcall(startSemiSteal)
    end
end)

    do
        local row = mkRow(38)
        mkLabel(row, "Infinite Jump")
        jumpPill, jumpDot = mkPill(row, 52)
        jumpOn = false
        setJumpToggleState = function(state)
            if jumpOn == state then return end
            jumpOn = state
            animPill(jumpPill, jumpDot, state)
            if state then
                jumpEnabled = true
                startJumpMode()
            else
                jumpEnabled = false
                stopJumpMode()
            end
        end
        local jumpClk = Instance.new("TextButton", jumpPill)
        jumpClk.Size = UDim2.new(1,0,1,0)
        jumpClk.BackgroundTransparency = 1
        jumpClk.Text = ""
        jumpClk.Activated:Connect(function()
            if _anyKeyListening then return end
            setJumpToggleState(not jumpOn)
        end)
        setJumpVisual = function(state) setJumpToggleState(state) end
    end

    do
        local row = mkRow(38)
        mkLabel(row, "Jump Mode")
        modeSelectBtn = mkSelector(row, jumpMode == 1 and "Tap Tap" or "Hold", function(btn)
            local newMode = jumpMode == 1 and 2 or 1
            jumpMode = newMode
            btn.Text = jumpMode == 1 and "Tap Tap" or "Hold"
            if jumpEnabled then
                stopJumpMode()
                startJumpMode()
            end
        end)
    end

    setUnwalkVisual = mkToggle("Unwalk", function(on)
        unwalkEnabled = on
        if on then startUnwalk() else stopUnwalk() end
    end)

do
    -- Variables
    local autoResetOnDeath = false
    local _deathResetConn = nil
    local _deathResetCharAdded = nil
    
    -- Funciones
    local function setupDeathReset()
        if autoResetOnDeath then
            local char = LP.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then
                    if _deathResetConn then _deathResetConn:Disconnect() end
                    _deathResetConn = hum.Died:Connect(function()
                        if autoResetOnDeath then
                            insta_reset()
                        end
                    end)
                end
            end
            if not _deathResetCharAdded then
                _deathResetCharAdded = LP.CharacterAdded:Connect(function(char)
                    task.wait(0.5)
                    setupDeathReset()
                end)
            end
        else
            if _deathResetConn then _deathResetConn:Disconnect(); _deathResetConn = nil end
            if _deathResetCharAdded then _deathResetCharAdded:Disconnect(); _deathResetCharAdded = nil end
        end
    end
    
    local function toggleAutoResetOnDeath(state)
        autoResetOnDeath = state
        setupDeathReset()
        pcall(saveAllSettings)
    end
    
    -- Toggle en GUI
    local setAutoResetOnDeath = mkToggle("Auto Reset on Death", function(on)
        toggleAutoResetOnDeath(on)
    end)
    
    -- Cargar estado guardado
    if type(loadAllSettings) == "function" then
        -- Intentar cargar desde config
        local ok, data = pcall(function()
            if isfile and isfile("drakauhub_config.json") then
                return game:GetService("HttpService"):JSONDecode(readfile("drakauhub_config.json"))
            end
        end)
        if ok and type(data) == "table" and data.autoResetOnDeath ~= nil then
            autoResetOnDeath = data.autoResetOnDeath
            if autoResetOnDeath then
                task.wait(0.1)
                setAutoResetOnDeath(true)
                setupDeathReset()
            end
        end
    end
    
    -- Guardar en buildConfigTable (si existe)
    if type(buildConfigTable) == "function" then
        local oldBuild = buildConfigTable
        buildConfigTable = function()
            local config = oldBuild()
            config.autoResetOnDeath = autoResetOnDeath
            return config
        end
    end
    
    -- Limpiar en stopAllBackgroundTasks (si existe)
    if type(stopAllBackgroundTasks) == "function" then
        local oldStop = stopAllBackgroundTasks
        stopAllBackgroundTasks = function()
            oldStop()
            autoResetOnDeath = false
            if _deathResetConn then _deathResetConn:Disconnect(); _deathResetConn = nil end
            if _deathResetCharAdded then _deathResetCharAdded:Disconnect(); _deathResetCharAdded = nil end
        end
    end
    
    -- Resetear en resetToDefaults (si existe)
    if type(resetToDefaults) == "function" then
        local oldReset = resetToDefaults
        resetToDefaults = function()
            oldReset()
            autoResetOnDeath = false
            setupDeathReset()
            if setAutoResetOnDeath then setAutoResetOnDeath(false) end
        end
    end
    
    -- CharacterAdded
    local oldCharAdded = LP.CharacterAdded
    LP.CharacterAdded:Connect(function(char)
        if autoResetOnDeath then
            task.wait(0.5)
            setupDeathReset()
        end
    end)
end

local tracersEnabled = false
local tracersConn = nil
local tracersData = {}
local TRACER_COLOR = Color3.fromRGB(255, 255, 255) -- BLANCO
local tracerToggleSetter = nil

local function applyTracerGlow(player, char)
    if not char then return end
    if not tracersData[player] then return end
    
    if tracersData[player].Glow then
        pcall(function() tracersData[player].Glow:Destroy() end)
        tracersData[player].Glow = nil
    end
    
    task.wait(0.2)
    
    local glow = Instance.new("Highlight")
    glow.Name = "TracerGlow"
    glow.FillColor = TRACER_COLOR
    glow.FillTransparency = 0.35
    glow.OutlineColor = TRACER_COLOR
    glow.OutlineTransparency = 0.1
    glow.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    glow.Adornee = char
    glow.Parent = char
    
    tracersData[player].Glow = glow
end

local function setupTracer(player)
    if player == LP then return end
    if tracersData[player] then return end
    
    local line = Drawing.new("Line")
    line.Color = TRACER_COLOR
    line.Thickness = 1.5
    line.Transparency = 0.7
    line.Visible = false
    
    tracersData[player] = { 
        Line = line, 
        Glow = nil 
    }
    
    if player.Character then
        applyTracerGlow(player, player.Character)
    end
    
    player.CharacterAdded:Connect(function(char)
        applyTracerGlow(player, char)
    end)
end

local function startTracers()
    if tracersConn then return end
    if not tracersEnabled then return end
    
    for _, v in ipairs(Players:GetPlayers()) do
        setupTracer(v)
    end
    
    Players.PlayerAdded:Connect(setupTracer)
    
    Players.PlayerRemoving:Connect(function(player)
        if tracersData[player] then
            if tracersData[player].Line then
                pcall(function() tracersData[player].Line:Remove() end)
            end
            if tracersData[player].Glow then
                pcall(function() tracersData[player].Glow:Destroy() end)
            end
            tracersData[player] = nil
        end
    end)
    
    tracersConn = RunService.RenderStepped:Connect(function()
        if not tracersEnabled then 
            return 
        end
        
        local myChar = LP.Character
        local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
        
        if not myHrp then
            for _, data in pairs(tracersData) do
                if data.Line then data.Line.Visible = false end
            end
            return
        end
        
        local myPos, visible1 = workspace.CurrentCamera:WorldToViewportPoint(myHrp.Position)
        if not visible1 then
            for _, data in pairs(tracersData) do
                if data.Line then data.Line.Visible = false end
            end
            return
        end
        
        for player, data in pairs(tracersData) do
            local char = player.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            
            if hrp and hum and hum.Health > 0 then
                local targetPos, visible2 = workspace.CurrentCamera:WorldToViewportPoint(hrp.Position)
                if visible2 then
                    data.Line.Visible = true
                    data.Line.From = Vector2.new(myPos.X, myPos.Y)
                    data.Line.To = Vector2.new(targetPos.X, targetPos.Y)
                else
                    data.Line.Visible = false
                end
            else
                data.Line.Visible = false
            end
        end
    end)
end

local function stopTracers()
    if tracersConn then
        tracersConn:Disconnect()
        tracersConn = nil
    end
    
    for player, data in pairs(tracersData) do
        if data.Line then
            pcall(function() data.Line:Remove() end)
        end
        if data.Glow then
            pcall(function() data.Glow:Destroy() end)
        end
    end
    tracersData = {}
end

local function toggleTracers(state)
    tracersEnabled = state
    if state then
        startTracers()
    else
        stopTracers()
    end
    pcall(saveAllSettings)
end

local function setTracerColor(color)
    TRACER_COLOR = color
    for player, data in pairs(tracersData) do
        if data.Line then
            data.Line.Color = color
        end
        if data.Glow then
            data.Glow.FillColor = color
            data.Glow.OutlineColor = color
        end
    end
end

_G.Tracers = {
    start = startTracers,
    stop = stopTracers,
    toggle = toggleTracers,
    setColor = setTracerColor,
    isEnabled = function() return tracersEnabled end
}

task.spawn(function()
    task.wait(1.5)
    if tracersEnabled then
        startTracers()
        if tracerToggleSetter then
            tracerToggleSetter(true)
        end
    end
end)

local oldBuild = buildConfigTable
buildConfigTable = function()
    local config = oldBuild()
    config.tracersEnabled = tracersEnabled
    return config
end

local oldLoad = loadAllSettings
loadAllSettings = function()
    local ok = oldLoad()
    if ok then
        local data = HS:JSONDecode(readfile(CONFIG_FILE))
        if data and data.tracersEnabled ~= nil then
            tracersEnabled = data.tracersEnabled
            if tracerToggleSetter then
                tracerToggleSetter(tracersEnabled)
            end
            if tracersEnabled then
                task.spawn(function()
                    task.wait(0.5)
                    startTracers()
                end)
            end
        end
    end
    return ok
end

local oldCharAdded = LP.CharacterAdded
LP.CharacterAdded:Connect(function(char)
    if tracersEnabled then
        task.spawn(function()
            task.wait(1)
            startTracers()
        end)
    end
end)

local oldStop = stopAllBackgroundTasks
stopAllBackgroundTasks = function()
    oldStop()
    if tracersEnabled then stopTracers() end
end

tracerToggleSetter = mkToggle("Tracers", function(on)
    toggleTracers(on)
end)
_G.tracerToggleSetter = tracerToggleSetter
tracerToggleSetter(tracersEnabled)

    dropBrainrotSetVisual = mkToggle("Drop Brainrot", function(on)
        if on then
            executeDropWithToggle(function(v)
                dropBrainrotSetVisual(v)
                if mobSetDropBR then mobSetDropBR(v) end
            end)
        end
    end)
    setDropVisual = dropBrainrotSetVisual

    do
        local row = mkRow(38)
        mkLabel(row, "Drop Mode")
        dropModeBtnRef = mkSelector(row, dropMode == 1 and "V1" or "V2", function(btn)
            if dropActive then
                stopDropBrainrot()
            end
            dropMode = dropMode == 1 and 2 or 1
            btn.Text = dropMode == 1 and "V1" or "V2"
        end)
    end

    setAntiLagVisual = mkToggle("Anti Lag", function(on)
        if on then enableAntiLag() else disableAntiLag() end
    end)

    -- ====== VISUAL SECTION ======
    mkSect("Visual")
    local stretchToggleSetter
    stretchToggleSetter = mkToggle("Stretch", function(on)
        if on then
            enableStretch()
        else
            disableStretch()
        end
        stretchEnabled = on
        pcall(saveAllSettings)
    end)
    _G.stretchToggleSetter = stretchToggleSetter
    stretchToggleSetter(stretchEnabled)

    do
        local row = mkRow(38)
        mkLabel(row, "FOV")
        local btnFrame = Instance.new("Frame", row)
        btnFrame.Size = UDim2.new(0, 140, 0, 26)
        btnFrame.Position = UDim2.new(1, -148, 0.5, -13)
        btnFrame.BackgroundTransparency = 1
        local function makeFOVBtn(val, x)
            local btn = Instance.new("TextButton", btnFrame)
            btn.Size = UDim2.new(0, 42, 0, 26)
            btn.Position = UDim2.new(0, x, 0, 0)
            btn.BackgroundColor3 = Color3.fromRGB(12,12,12)
            btn.BorderSizePixel = 0
            btn.Text = tostring(val)
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.Font = Enum.Font.FredokaOne
            btn.TextSize = 11
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
            local stroke = Instance.new("UIStroke", btn)
            stroke.Color = Color3.fromRGB(255, 255, 255)
            stroke.Thickness = 1
            if val == stretchFOV then
                btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                btn.TextColor3 = Color3.fromRGB(0,0,0)
            end
            applyShimmerToText(btn, 0.7)
            btn.MouseButton1Click:Connect(function()
                stretchFOV = val
                if stretchEnabled then
                    applyStretchFOV(val)
                end
                for _, b in ipairs(btnFrame:GetChildren()) do
                    if b:IsA("TextButton") then
                        local v = tonumber(b.Text)
                        if v == val then
                            b.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                            b.TextColor3 = Color3.fromRGB(0,0,0)
                        else
                            b.BackgroundColor3 = Color3.fromRGB(12,12,12)
                            b.TextColor3 = Color3.fromRGB(255, 255, 255)
                        end
                    end
                end
                pcall(saveAllSettings)
            end)
            return btn
        end
        makeFOVBtn(90, 0)
        makeFOVBtn(120, 49)
        makeFOVBtn(180, 98)
    end

-- ====== SKY SYSTEM (DÍA / NOCHE) ======
local Sky = {
    Enabled = false,
    Mode = "Day",
    Time = 14,
    CycleSpeed = 1,
    AutoCycle = false,
    Connection = nil,
}

local SkyConfig = {
    Day = {
        Ambient = Color3.fromRGB(255, 255, 255),
        Brightness = 2,
        FogEnd = 5000,
        FogColor = Color3.fromRGB(255, 255, 255),
        OutdoorAmbient = Color3.fromRGB(255, 255, 255),
        SkyColor = Color3.fromRGB(255, 255, 255),
        SunColor = Color3.fromRGB(255, 255, 255),
        SunAngle = 45,
        ShadowSoftness = 0.3,
        AtmosphereDensity = 0.4,
        AtmosphereOffset = 0,
        Exposure = 1.2,
    },
    Night = {
        Ambient = Color3.fromRGB(0, 0, 0),
        Brightness = 0.1,
        FogEnd = 1000,
        FogColor = Color3.fromRGB(0, 0, 0),
        OutdoorAmbient = Color3.fromRGB(0, 0, 0),
        SkyColor = Color3.fromRGB(0, 0, 0),
        SunColor = Color3.fromRGB(255, 255, 255),
        SunAngle = -45,
        ShadowSoftness = 0.8,
        AtmosphereDensity = 0.8,
        AtmosphereOffset = 0.2,
        Exposure = 0.5,
    }
}

local function applySkySettings(mode)
    local config = mode == "Day" and SkyConfig.Day or SkyConfig.Night
    
    Lighting.Brightness = config.Brightness
    Lighting.FogEnd = config.FogEnd
    Lighting.FogColor = config.FogColor
    Lighting.OutdoorAmbient = config.OutdoorAmbient
    
    local sky = Lighting:FindFirstChild("Sky")
    if not sky then
        sky = Instance.new("Sky")
        sky.Parent = Lighting
    end
    
    sky.SkyboxBk = config.SkyColor
    sky.SkyboxDn = config.SkyColor
    sky.SkyboxFt = config.SkyColor
    sky.SkyboxLf = config.SkyColor
    sky.SkyboxRt = config.SkyColor
    sky.SkyboxUp = config.SkyColor
    
    local atmosphere = Lighting:FindFirstChild("Atmosphere")
    if not atmosphere then
        atmosphere = Instance.new("Atmosphere")
        atmosphere.Parent = Lighting
    end
    
    atmosphere.Color = config.SkyColor
    atmosphere.Density = config.AtmosphereDensity
    atmosphere.Offset = config.AtmosphereOffset
    atmosphere.Decay = Enum.AtmosphereDecay.Linear
    
    local sunRays = Lighting:FindFirstChild("SunRaysEffect")
    if not sunRays then
        sunRays = Instance.new("SunRaysEffect")
        sunRays.Parent = Lighting
    end
    sunRays.Intensity = mode == "Day" and 0.2 or 0.05
    
    local bloom = Lighting:FindFirstChild("BloomEffect")
    if not bloom then
        bloom = Instance.new("BloomEffect")
        bloom.Parent = Lighting
    end
    bloom.Intensity = mode == "Day" and 0.3 or 0.1
    
    local colorCorrection = Lighting:FindFirstChild("ColorCorrectionEffect")
    if not colorCorrection then
        colorCorrection = Instance.new("ColorCorrectionEffect")
        colorCorrection.Parent = Lighting
    end
    colorCorrection.Saturation = mode == "Day" and 1 or 0.6
    colorCorrection.Contrast = mode == "Day" and 0.3 or 0.1
    colorCorrection.Brightness = mode == "Day" and 0.1 or -0.1
    
    Lighting.ShadowSoftness = config.ShadowSoftness
    
    if Sky.Time ~= nil then
        Lighting.ClockTime = Sky.Time
    end
end

local function toggleSky(state)
    Sky.Enabled = state
    
    if Sky.Connection then
        Sky.Connection:Disconnect()
        Sky.Connection = nil
    end
    
    if state then
        applySkySettings(Sky.Mode)
        
        if Sky.AutoCycle then
            Sky.Connection = RunService.Heartbeat:Connect(function()
                if not Sky.Enabled or not Sky.AutoCycle then return end
                
                Sky.Time = (Sky.Time + Sky.CycleSpeed * 0.001) % 24
                Lighting.ClockTime = Sky.Time
                
                local isDay = Sky.Time >= 6 and Sky.Time <= 18
                local targetMode = isDay and "Day" or "Night"
                
                if targetMode ~= Sky.Mode then
                    Sky.Mode = targetMode
                    applySkySettings(Sky.Mode)
                end
            end)
        end
    else
        Lighting.Brightness = 2
        Lighting.FogEnd = 5000
        Lighting.FogColor = Color3.fromRGB(255, 255, 255)
        Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
        Lighting.ClockTime = 14
        Lighting.ShadowSoftness = 0.3
        
        local sky = Lighting:FindFirstChild("Sky")
        if sky then sky:Destroy() end
        
        local atmosphere = Lighting:FindFirstChild("Atmosphere")
        if atmosphere then atmosphere:Destroy() end
        
        local sunRays = Lighting:FindFirstChild("SunRaysEffect")
        if sunRays then sunRays:Destroy() end
        
        local bloom = Lighting:FindFirstChild("BloomEffect")
        if bloom then bloom:Destroy() end
        
        local colorCorrection = Lighting:FindFirstChild("ColorCorrectionEffect")
        if colorCorrection then colorCorrection:Destroy() end
    end
end

_G.toggleSky = function(state)
    if state == nil then
        state = not Sky.Enabled
    end
    toggleSky(state)
end

_G.setSkyMode = function(mode)
    if mode ~= "Day" and mode ~= "Night" then return end
    Sky.Mode = mode
    if Sky.Enabled then
        applySkySettings(mode)
    end
end

_G.setSkyTime = function(time)
    time = math.clamp(time, 0, 24)
    Sky.Time = time
    if Sky.Enabled then
        Lighting.ClockTime = time
        local isDay = time >= 6 and time <= 18
        local targetMode = isDay and "Day" or "Night"
        if targetMode ~= Sky.Mode then
            Sky.Mode = targetMode
            applySkySettings(targetMode)
        end
    end
end

_G.toggleAutoCycle = function(state)
    if state == nil then
        state = not Sky.AutoCycle
    end
    Sky.AutoCycle = state
    if Sky.Enabled then
        toggleSky(true)
    end
end

_G.setCycleSpeed = function(speed)
    Sky.CycleSpeed = math.max(0.1, speed)
end

mkSect("Sky")
local skyToggleVisual = mkToggle("Sky System", function(on)
    _G.toggleSky(on)
end)

do
    local row = mkRow(38)
    mkLabel(row, "Sky Mode")
    local modeBtn = mkSelector(row, Sky.Mode or "Day", function(btn)
        local newMode = btn.Text == "Day" and "Night" or "Day"
        btn.Text = newMode
        _G.setSkyMode(newMode)
    end)
end

local autoCycleVisual = mkToggle("Auto Cycle", function(on)
    _G.toggleAutoCycle(on)
end)

do
    local row = mkRow(38)
    mkLabel(row, "Time (0-24)")
    local timeBox = mkBox(row, Sky.Time or 14, 45, 52, function(v)
        if v >= 0 and v <= 24 then
            _G.setSkyTime(v)
        end
    end)
end

    -- ====== AUTO LEFT / RIGHT ======
    mkSect("Auto Left / Right")
    autoLeftSetVisual = mkToggle("Auto Left", function(on)
        if on then
            autoLeftEnabled = true
            startAutoLeft()
        else
            autoLeftEnabled = false
            stopAutoLeft()
        end
        if mobSetAutoLeft then mobSetAutoLeft(on) end
    end)
    autoRightSetVisual = mkToggle("Auto Right", function(on)
        if on then
            autoRightEnabled = true
            startAutoRight()
        else
            autoRightEnabled = false
            stopAutoRight()
        end
        if mobSetAutoRight then mobSetAutoRight(on) end
    end)

    -- ====== TELEPORT ======
    mkSect("Teleport")
    do
        local row = mkRow(38)
        mkLabel(row, "TP Down")
        local clk = Instance.new("TextButton", row)
        clk.Size = UDim2.new(0.55, 0, 1, 0)
        clk.BackgroundTransparency = 1
        clk.Text = ""
        clk.Activated:Connect(function() executeTPDown() end)
        local actLbl = Instance.new("TextLabel", row)
        actLbl.Size = UDim2.new(0, 60, 1, 0)
        actLbl.Position = UDim2.new(1, -64, 0, 0)
        actLbl.BackgroundTransparency = 1
        actLbl.Text = "ACTIVATE"
        actLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
        actLbl.Font = Enum.Font.FredokaOne
        actLbl.TextSize = 10
        actLbl.TextXAlignment = Enum.TextXAlignment.Right
        applyShimmerToText(actLbl, 0.8)
    end
    do
        local row = mkRow(38)
        mkLabel(row, "TP Down Mode")
        tpModeSelectBtn = mkSelector(row, tpDownMode == 1 and "V1" or "V2", function(btn)
            tpDownMode = tpDownMode == 1 and 2 or 1
            btn.Text = tpDownMode == 1 and "V1" or "V2"
        end)
    end
    setAutoTPDownVisual = mkToggle("Auto TP Down", function(on)
        autoTPDownEnabled = on
        if on then startAutoTPDown() else stopAutoTPDown() end
    end)
    do local row=mkRow(38); mkLabel(row,"Height Y"); autoTPHeightBox=mkBox(row,autoTPHeight,45,52,function(v) if v>=1 and v<=500 then autoTPHeight=v; autoTPDownThreshold=v end end) end
    setInstaResetVisual = mkToggle("Insta Reset", function(on)
        if on then
            insta_reset()
            if instaResetFloatingButton and instaResetFloatingButton:FindFirstChild("Frame") then
                local btnFrame = instaResetFloatingButton:FindFirstChild("Frame")
                local label = btnFrame and btnFrame:FindFirstChild("TextLabel")
                if btnFrame then
                    btnFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    if label then label.TextColor3 = Color3.fromRGB(0,0,0) end
                    task.delay(0.1, function()
                        if btnFrame then
                            btnFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)
                            if label then label.TextColor3 = Color3.fromRGB(255, 255, 255) end
                        end
                    end)
                end
            end
            task.delay(0.3, function() if setInstaResetVisual then setInstaResetVisual(false) end end)
        end
    end)

    -- ====== STEAL ======
    mkSect("Steal")
    do local row=mkRow(38); mkLabel(row,"Steal Radius"); radInput=mkBox(row,Steal.StealRadius,45,52,function(v) if v>=0.5 and v<=300 then Steal.StealRadius=v end end) end
    do local row=mkRow(38); mkLabel(row,"Steal Duration"); stealDurationBox=mkBox(row,Steal.StealDuration,45,52,function(v) if v>=0.05 and v<=2 then Steal.StealDuration=v end end) end

    -- ====== INTERFACE ======
    mkSect("Interface")
    do
        local row = mkRow(38)
        mkLabel(row, "UI Size")
        mkBox(row, tonumber(_G.__FROST_UI_SIZE) or 100, 45, 52, function(v)
            v = math.clamp(math.floor(v + 0.5), 50, 150)
            _G.__FROST_UI_SIZE = v
            if _G.__FROST_UI_SCALE_OBJ then
                _G.__FROST_UI_SCALE_OBJ.Scale = v / 100
            end
            pcall(saveAllSettings)
        end)
    end

    setLockUIVisual = mkToggle("Lock UI", function(on)
        toggleLockUI(on)
    end)

    -- ====== CONFIG ======
    mkSect("Config")
    do
        local row = mkRow(38)
        row.Size = UDim2.new(1, -8, 0, 38)
        local resetBtn = Instance.new("TextButton", row)
        resetBtn.Size = UDim2.new(0.9, 0, 0.8, 0)
        resetBtn.Position = UDim2.new(0.05, 0, 0.1, 0)
        resetBtn.BackgroundColor3 = Color3.fromRGB(45,45,45)
        resetBtn.BorderSizePixel = 0
        resetBtn.Text = "RESET POSITIONS"
        resetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        resetBtn.Font = Enum.Font.FredokaOne
        resetBtn.TextSize = 11
        Instance.new("UICorner", resetBtn).CornerRadius = UDim.new(0, 6)
        local resetStroke = Instance.new("UIStroke", resetBtn)
        resetStroke.Color = Color3.fromRGB(150,150,150)
        resetStroke.Thickness = 1.2
        applyShimmerToText(resetBtn, 0.6)
        resetBtn.Activated:Connect(function()
            resetFloatingPositions()
            resetBtn.Text = "RESET ✓"
            resetBtn.BackgroundColor3 = Color3.fromRGB(30,30,30)
            task.delay(1.2, function()
                if resetBtn and resetBtn.Parent then
                    resetBtn.Text = "RESET POSITIONS"
                    resetBtn.BackgroundColor3 = Color3.fromRGB(45,45,45)
                end
            end)
        end)
    end

    do
        local row = mkRow(44)
        row.Size = UDim2.new(1, -8, 0, 44)
        local delBtn = Instance.new("TextButton", row)
        delBtn.Size = UDim2.new(0.9, 0, 0.8, 0)
        delBtn.Position = UDim2.new(0.05, 0, 0.1, 0)
        delBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
        delBtn.BorderSizePixel = 0
        delBtn.Text = "DELETE SETTINGS"
        delBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        delBtn.Font = Enum.Font.FredokaOne
        delBtn.TextSize = 12
        Instance.new("UICorner", delBtn).CornerRadius = UDim.new(0, 6)
        local delStroke = Instance.new("UIStroke", delBtn)
        delStroke.Color = Color3.fromRGB(255, 255, 255)
        delStroke.Thickness = 1.2
        applyShimmerToText(delBtn, 0.6)

        local deleteState=0
        local originalDeleteText="DELETE SETTINGS"
        delBtn.Activated:Connect(function()
            if deleteState==0 then
                deleteState=1
                delBtn.Text="CONFIRM?"
                delBtn.BackgroundColor3=Color3.fromRGB(80,80,80)
                delBtn.TextColor3=Color3.fromRGB(255,255,255)
                task.delay(2,function()
                    if delBtn and delBtn.Parent and deleteState==1 then
                        deleteState=0
                        delBtn.Text=originalDeleteText
                        delBtn.BackgroundColor3=Color3.fromRGB(60,60,60)
                        delBtn.TextColor3=Color3.fromRGB(255,255,255)
                    end
                end)
            elseif deleteState==1 then
                local success=deleteAllSettings()
                if success then
                    delBtn.Text="DELETED ✓"
                    delBtn.BackgroundColor3=Color3.fromRGB(30,30,30)
                    delBtn.TextColor3=Color3.fromRGB(255, 255, 255)
                    task.delay(1.5,function()
                        if delBtn and delBtn.Parent then
                            deleteState=0
                            delBtn.Text=originalDeleteText
                            delBtn.BackgroundColor3=Color3.fromRGB(60,60,60)
                            delBtn.TextColor3=Color3.fromRGB(255,255,255)
                        end
                    end)
                else
                    delBtn.Text="NO FILE"
                    delBtn.BackgroundColor3=Color3.fromRGB(80,80,80)
                    delBtn.TextColor3=Color3.fromRGB(255,255,255)
                    task.delay(1.2,function()
                        if delBtn and delBtn.Parent then
                            deleteState=0
                            delBtn.Text=originalDeleteText
                            delBtn.BackgroundColor3=Color3.fromRGB(60,60,60)
                            delBtn.TextColor3=Color3.fromRGB(255,255,255)
                        end
                    end)
                end
            end
        end)
    end

    -- ====== MUSIC SECTION ======
mkSect("Music")

-- =============================================
-- SISTEMA DE MÚSICA CON TOGGLE + SELECTOR
-- =============================================

local songParent = game:GetService("CoreGui")
local starterGui = game:GetService("StarterGui")
local assetFunction = getcustomasset or getsynasset

-- Variables del sistema
local musicEnabled = false
local selectedSongIndex = 1
local currentSound = nil
local isPlaying = false
local isDownloading = false

-- Lista de canciones (18 canciones: 10 originales + 8 nuevas)
songList = {
    -- Originales
    {
        title = "El corrido del 30",
        url = "https://files.catbox.moe/pf9kd9.mp3",
        file = "corrido_del_30.mp3",
    },
    {
        title = "WARE",
        url = "https://files.catbox.moe/p2pp91.mp3",
        file = "Ware.mp3",
    },
    {
        title = "El Hijo del 7",
        url = "https://files.catbox.moe/wpbab3.mp3",
        file = "elhijodel7.mp3",
    },
    {
        title = "WOW",
        url = "https://files.catbox.moe/14rdtj.mp3",
        file = "WOW.mp3",
    },
    {
        title = "el de la R",
        url = "https://files.catbox.moe/u67vx5.mp3",
        file = "eldelaR.mp3",
    },
    {
        title = "EL CHIRICUAZO",
        url = "https://files.catbox.moe/va3lhi.mp3",
        file = "chiricuazo_v2.mp3",
    },
    {
        title = "HORA 0",
        url = "https://file.garden/algLafWA1jk8WMfK/Myke%20Towers%20-%20HORA%20CERO%20(Lyrics)(MP3_160K).mp3",
        file = "hora_0.mp3",
    },
    {
        title = "El Maestro",
        url = "https://files.catbox.moe/bmjsah.mp3",
        file = "el_maestro.mp3",
    },
    {
        title = "Seteadora",
        url = "https://files.catbox.moe/94olvv.mp3",
        file = "Seteadora.mp3",
    },
    {
        title = "El Ondeado V2",
        url = "https://files.catbox.moe/4lqp91.mp3",
        file = "el_ondeado_v2.mp3",
    },
    -- Nuevas canciones (8)
    {
        title = "tuffsong",
        url = "https://files.catbox.moe/rvf2vy.mp3",
        file = "tuffsong.mp3",
    },
    {
        title = "friosong",
        url = "https://files.catbox.moe/v20ko9.mp3",
        file = "friosong.mp3",
    },
    {
        title = "xoxosong",
        url = "https://files.catbox.moe/jghp0f.mp3",
        file = "xoxosong.mp3",
    },
    {
        title = "beretta",
        url = "https://file.garden/algLafWA1jk8WMfK/Beretta%20-%20video%20oficial(MP3_160K).mp3",
        file = "overseer_beretta_filegarden.mp3",
    },
    {
        title = "tp the 0",
        url = "https://file.garden/algLafWA1jk8WMfK/King%20Von%20-%20Took%20Her%20To%20The%20O%20(Lyrics)(MP3_160K).mp3",
        file = "overseer_to_the_o_filegarden.mp3",
    },
    {
        title = "laja",
        url = "https://file.garden/algLafWA1jk8WMfK/LAJA%20-%20NADIE%20TA%20FRIO%20(Letra)(MP3_160K).mp3",
        file = "overseer_laja_nadie_ta_frio_filegarden.mp3",
    },
    {
        title = "hora 0",
        url = "https://file.garden/algLafWA1jk8WMfK/Myke%20Towers%20-%20HORA%20CERO%20(Lyrics)(MP3_160K).mp3",
        file = "overseer_hora_0_filegarden.mp3",
    },
    {
        title = "lucid",
        url = "https://file.garden/algLafWA1jk8WMfK/Lucid%20Dreams%20-%20Clean%20-%20Juice%20WRLD(MP3_160K).mp3",
        file = "overseer_lucid_dreams_filegarden.mp3",
    },
}

-- Funciones auxiliares
local function fileExists(path)
    if type(isfile) ~= "function" then return false end
    local ok, exists = pcall(isfile, path)
    return ok and exists == true
end

local function validAudio(data)
    if type(data) ~= "string" or #data < 2048 then return false end
    local header = data:sub(1, 256):lower()
    return not (
        header:find("<html", 1, true) or
        header:find("<!doctype", 1, true) or
        header:find("access denied", 1, true) or
        header:find("not found", 1, true) or
        header:find("error", 1, true)
    )
end

local function downloadSong(url, path)
    if type(writefile) ~= "function" then
        return false, "writefile no disponible"
    end

    local data, lastError
    local requestFn = request or http_request or (syn and syn.request) or (fluxus and fluxus.request)

    if type(requestFn) == "function" then
        local ok, res = pcall(requestFn, {
            Url = url,
            Method = "GET",
            Headers = {
                ["User-Agent"] = "Mozilla/5.0",
                ["Accept"] = "audio/mpeg,audio/*;q=0.9,*/*;q=0.8"
            }
        })
        if ok and type(res) == "table" then
            local code = tonumber(res.StatusCode or res.Status or res.status_code) or 0
            local body = res.Body or res.body
            if (code == 0 or (code >= 200 and code < 300)) and validAudio(body) then
                data = body
            else
                lastError = "HTTP " .. tostring(code)
            end
        end
    end

    if not data then
        local ok, result = pcall(function() return game:HttpGet(url, true) end)
        if ok and validAudio(result) then
            data = result
        elseif not ok then
            lastError = tostring(result)
        end
    end

    if not data then
        return false, lastError or "No se pudo descargar"
    end

    local ok, err = pcall(writefile, path, data)
    if not ok then
        return false, tostring(err)
    end
    return true
end

local function getLocalAsset(path)
    if type(assetFunction) ~= "function" then return nil end
    local ok, id = pcall(assetFunction, path)
    if ok and type(id) == "string" and id ~= "" then
        return id
    end
    return nil
end

-- Función para reproducir canción
local function playSong(index)
    if currentSound then
        pcall(function() currentSound:Stop() end)
        pcall(function() currentSound:Destroy() end)
        currentSound = nil
        isPlaying = false
    end

    if not musicEnabled then return end
    if not songList[index] then return end

    local song = songList[index]
    
    local assetId = getLocalAsset(song.file)
    
    if not assetId then
        if isDownloading then return end
        isDownloading = true
        
        local ok, err = downloadSong(song.url, song.file)
        isDownloading = false
        
        if not ok then
            warn("[MUSIC] Error: " .. tostring(err))
            return
        end
        
        assetId = getLocalAsset(song.file)
        if not assetId then return end
    end

    local sound = Instance.new("Sound")
    sound.Name = "CRYON_" .. song.title:gsub("%s+", "_")
    sound.SoundId = assetId
    sound.Volume = 0.75
    sound.Looped = true
    sound.Parent = songParent
    
    pcall(function() sound:Play() end)
    currentSound = sound
    isPlaying = true
end

-- Función para cambiar canción
local function changeSong(index)
    if index < 1 or index > #songList then return end
    selectedSongIndex = index
    if musicEnabled then
        playSong(index)
    end
    if songSelectorBtn then
        songSelectorBtn.Text = songList[index].title
    end
end

-- =============================================
-- CREAR TOGGLE (como Anim Pack)
-- =============================================

local musicToggleVisual = mkToggle("Music", function(on)
    musicEnabled = on
    if on then
        playSong(selectedSongIndex)
    else
        if currentSound then
            pcall(function() currentSound:Stop() end)
            pcall(function() currentSound:Destroy() end)
            currentSound = nil
            isPlaying = false
        end
    end
end)

-- =============================================
-- CREAR SELECTOR (como Pack Select)
-- =============================================

do
    local row = mkRow(38)
    mkLabel(row, "Song Select")
    
    local songTitles = {}
    for _, s in ipairs(songList) do
        table.insert(songTitles, s.title)
    end
    
    songSelectorBtn = nil
    
    -- Obtener el título de la canción actual, con fallback
    local currentSongTitle = (songList[selectedSongIndex] and songList[selectedSongIndex].title) or "Select Song"
    if not currentSongTitle or currentSongTitle == "" then currentSongTitle = "Select Song" end
    songSelectorBtn = mkSelector(row, currentSongTitle, function(btn)
        local currentTitle = songList[selectedSongIndex] and songList[selectedSongIndex].title or nil
        openChoicePanel("SONGS", songTitles, currentTitle, function(index, songTitle)
            selectedSongIndex = index
            btn.Text = songTitle
            if musicEnabled then
                playSong(index)
            end
            pcall(saveAllSettings)
        end, Color3.fromRGB(255, 255, 255))
    end)
    
    _G.songSelectorBtn = songSelectorBtn
    _G.songList = songList
    _G.changeSong = changeSong
end

-- =============================================
-- GUARDAR CONFIGURACIÓN
-- =============================================

local oldBuildConfig = buildConfigTable
buildConfigTable = function()
    local config = oldBuildConfig()
    config.musicEnabled = musicEnabled
    config.selectedSongIndex = selectedSongIndex
    return config
end

local oldLoadSettings = loadAllSettings
loadAllSettings = function()
    local ok = oldLoadSettings()
    if ok then
        local data = HS:JSONDecode(readfile(CONFIG_FILE))
        if data then
            if data.musicEnabled ~= nil then
                musicEnabled = data.musicEnabled
                if musicToggleVisual then
                    musicToggleVisual(musicEnabled)
                end
            end
            if data.selectedSongIndex then
                selectedSongIndex = data.selectedSongIndex
                if songList[selectedSongIndex] then
                    local t = songList[selectedSongIndex].title
                    if songSelectorBtn then songSelectorBtn.Text = t end
                    if _G.songSelectorBtn then _G.songSelectorBtn.Text = t end
                end
                if musicEnabled then
                    task.wait(0.5)
                    playSong(selectedSongIndex)
                end
            end
        end
    end
    return ok
end

    -- ====== KEYBINDS ======
    mkSect("Keybinds")

    local keyButtonRefs = {}

    local function mkKeyButton(parent, kbEntry)
        local btn = Instance.new("TextButton", parent)
        btn.Size = UDim2.new(0, 75, 0, 24)
        btn.Position = UDim2.new(1, -83, 0.5, -12)
        btn.BackgroundColor3 = INP
        btn.BackgroundTransparency = 0.38
        btn.BorderSizePixel = 0
        local function getLabel() return (kbEntry.gp and kbEntry.gp.Name) or (kbEntry.kb and kbEntry.kb.Name) or "None" end
        btn.Text = getLabel()
        btn.TextColor3 = Color3.fromRGB(255, 255, 255) -- BLANCO
        btn.Font = Enum.Font.FredokaOne
        btn.TextSize = 9
        btn.ZIndex = 5
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
        local bs = Instance.new("UIStroke", btn)
        bs.Color = Color3.fromRGB(255, 255, 255)
        bs.Thickness = 1
        applyShimmerToText(btn, 0.7)
        local li = false; local lc; local pv = btn.Text; local listenStart = 0
        btn.Activated:Connect(function()
            if li then li=false; _anyKeyListening=false; if lc then lc:Disconnect(); lc=nil end; btn.Text=pv; btn.TextColor3=Color3.fromRGB(255, 255, 255); return end
            pv = btn.Text; li = true; _anyKeyListening = true; listenStart = tick(); btn.Text = "..."; btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            lc = UIS.InputBegan:Connect(function(inp)
                if not li then return end
                if inp.KeyCode == Enum.KeyCode.Escape then li=false; _anyKeyListening=false; if lc then lc:Disconnect(); lc=nil end; btn.Text=pv; btn.TextColor3=Color3.fromRGB(255, 255, 255); return end
                local isGp = isGamepadInput(inp)
                if isGp and tick()-listenStart < 0.15 then return end
                if not isBindableInput(inp) then return end
                btn.Text = inp.KeyCode.Name; pv = inp.KeyCode.Name; btn.TextColor3 = Color3.fromRGB(255, 255, 255)
                li = false; _anyKeyListening = false; if lc then lc:Disconnect(); lc=nil end
                if isGp then kbEntry.gp = inp.KeyCode; kbEntry.kb = nil else kbEntry.kb = inp.KeyCode; kbEntry.gp = nil end
            end)
        end)
        return btn
    end

    local function addKeybindRow(labelText, kbEntry)
        local row = mkRow(34)
        mkLabel(row, labelText)
        local btn = mkKeyButton(row, kbEntry)
        table.insert(keyButtonRefs, {btn=btn, entry=kbEntry})
    end

    addKeybindRow("Carry Mode", KB.CarryToggle)
    addKeybindRow("Lagger Mode", KB.LaggerMode)
    addKeybindRow("Auto Left", KB.AutoLeft)
    addKeybindRow("Auto Right", KB.AutoRight)
    addKeybindRow("Auto Bat", KB.AutoBat)
    -- AQUÍ ESTÁ EL CAMBIO: "Bat Anti Desync" → ahora activa el modo Anti‑Desync (modo 2)
    addKeybindRow("Bat Anti Desync", KB.Bypass)
    addKeybindRow("TP Down", KB.TPFloor)
    addKeybindRow("Drop Brainrot", KB.DropBrainrot)

    local spacer = Instance.new("Frame", scrollPage)
    spacer.Size = UDim2.new(1, 0, 0, 20)
    spacer.BackgroundTransparency = 1
    spacer.LayoutOrder = 100
    spacer.Visible = true

    _G.keyButtonRefs = keyButtonRefs

    -- ====== BARRA AUTO STEAL (CON IMAGEN DE FONDO) ======
pbFrame = Instance.new("Frame", gui)
pbFrame.Size = UDim2.new(0, 280, 0, 38)
pbFrame.Position = UDim2.new(0.5, -140, 1, -58)
-- Restaurar la última posición guardada de la barra.
if type(savedProgressBarPos) == "table" then
    pbFrame.Position = UDim2.new(
        tonumber(savedProgressBarPos.XScale) or 0.5,
        tonumber(savedProgressBarPos.XOffset) or -140,
        tonumber(savedProgressBarPos.YScale) or 1,
        tonumber(savedProgressBarPos.YOffset) or -58
    )
end
pbFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
pbFrame.BorderSizePixel = 0
pbFrame.Active = true
pbFrame.ClipsDescendants = true
pbFrame.Visible = true
Instance.new("UICorner", pbFrame).CornerRadius = UDim.new(0, 12)

-- IMAGEN DE FONDO (estilo Cryon)
local autoStealBg = Instance.new("ImageLabel", pbFrame)
autoStealBg.Name = "AutoStealBackground"
autoStealBg.Size = UDim2.new(1, 0, 1, 0)
autoStealBg.Position = UDim2.new(0, 0, 0, 0)
autoStealBg.BackgroundTransparency = 1
autoStealBg.BorderSizePixel = 0
autoStealBg.Image = "rbxthumb://type=Asset&id=72514274273722&w=420&h=420"
autoStealBg.ImageTransparency = 0.0
autoStealBg.ImageColor3 = Color3.fromRGB(255, 255, 255)
autoStealBg.ScaleType = Enum.ScaleType.Crop
autoStealBg.ZIndex = 1
Instance.new("UICorner", autoStealBg).CornerRadius = UDim.new(0, 12)

-- BORDE SUTIL
local pbSt = Instance.new("UIStroke", pbFrame)
pbSt.Color = Color3.fromRGB(0, 0, 0)
pbSt.Thickness = 1.2
pbSt.Transparency = 0.25

-- TÍTULO "AUTO STEAL"
local title = Instance.new("TextLabel", pbFrame)
title.Size = UDim2.new(0, 72, 0, 20)
title.Position = UDim2.new(0, 10, 0, 2)
title.BackgroundTransparency = 1
title.Text = "AUTO STEAL"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.FredokaOne
title.TextSize = 10
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 2

-- ESTADO CENTRAL (READY / STEALING / SUCCESS / FAILED)
progressPct = Instance.new("TextLabel", pbFrame)
progressPct.Size = UDim2.new(0, 110, 0, 20)
progressPct.Position = UDim2.new(0.5, -55, 0, 2)
progressPct.BackgroundTransparency = 1
progressPct.Text = Steal.AutoStealEnabled and "READY" or "IDLE"
progressPct.TextColor3 = Color3.fromRGB(255, 255, 255)
progressPct.Font = Enum.Font.FredokaOne
progressPct.TextSize = 10
progressPct.TextXAlignment = Enum.TextXAlignment.Center
progressPct.ZIndex = 2

-- RANGO + FPS + PING (derecha)
progressRadLbl = Instance.new("TextLabel", pbFrame)
progressRadLbl.Size = UDim2.new(0, 76, 0, 20)
progressRadLbl.Position = UDim2.new(1, -84, 0, 2)
progressRadLbl.BackgroundTransparency = 1
progressRadLbl.Text = string.format("RANGE %.2g", Steal.StealRadius)
progressRadLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
progressRadLbl.Font = Enum.Font.FredokaOne
progressRadLbl.TextSize = 9
progressRadLbl.TextXAlignment = Enum.TextXAlignment.Right
progressRadLbl.ZIndex = 2

-- PISTA DE PROGRESO
local track = Instance.new("Frame", pbFrame)
track.Size = UDim2.new(1, -20, 0, 8)
track.Position = UDim2.new(0, 10, 1, -12)
track.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
track.BorderSizePixel = 0
track.ZIndex = 2
Instance.new("UICorner", track).CornerRadius = UDim.new(1,0)

-- BARRA DE PROGRESO (se llena al robar)
progressFill = Instance.new("Frame", track)
progressFill.Size = UDim2.new(0,0,1,0)
progressFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
progressFill.BorderSizePixel = 0
progressFill.ZIndex = 3
Instance.new("UICorner", progressFill).CornerRadius = UDim.new(1,0)

-- FUNCIÓN PARA ARRASTRAR LA BARRA
local function dragProgress(f)
    local dn, ds, sp, di = false, nil, nil, nil
    f.InputBegan:Connect(function(i)
        if uiLocked then return end
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dn = true
            ds = i.Position
            sp = f.Position
        end
    end)
    f.InputChanged:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then
            di = i
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if i == di and dn and not uiLocked and ds and sp then
            local delta = i.Position - ds
            f.Position = UDim2.new(sp.X.Scale, sp.X.Offset + delta.X, sp.Y.Scale, sp.Y.Offset + delta.Y)
        end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            if dn then
                dn = false
                -- Guardar la posición justo al terminar de arrastrar.
                pcall(function() saveAllSettings() end)
            end
        end
    end)
end
dragProgress(pbFrame)

-- FUNCIÓN PARA MOSTRAR/OCULTAR LA BARRA
function updateProgressBarVisibility()
    if pbFrame then pbFrame.Visible = Steal.AutoStealEnabled end
end

-- ACTUALIZACIÓN EN TIEMPO REAL DEL ESTADO
RunService.RenderStepped:Connect(function()
    if not pbFrame or not pbFrame.Parent then return end
    if not Steal.AutoStealEnabled then
        progressFill.Size = UDim2.new(0,0,1,0)
        progressPct.Text = "IDLE"
        progressPct.TextColor3 = Color3.fromRGB(255, 255, 255)
        return
    end

    if StealState.active then
        local pct = math.clamp((tick() - StealState.startTime) / math.max(Steal.StealDuration, 0.05), 0, 1)
        progressFill.Size = UDim2.new(pct,0,1,0)
        if StealState.phase == "waitingRange" then
            progressPct.Text = "WAITING RANGE"
        else
            progressPct.Text = "STEALING"
        end
        progressPct.TextColor3 = Color3.fromRGB(255, 255, 255)
    elseif StealState.lastResultTime > 0 and tick() - StealState.lastResultTime < 1.2 then
        progressFill.Size = UDim2.new(1,0,1,0)
        progressPct.Text = StealState.phase == "success" and "SUCCESS" or "FAILED"
        progressPct.TextColor3 = Color3.fromRGB(255, 255, 255)
    else
        progressFill.Size = UDim2.new(0,0,1,0)
        progressPct.Text = "READY"
        progressPct.TextColor3 = Color3.fromRGB(255, 255, 255)
    end

    progressRadLbl.Text = string.format("RANGE %.2g", Steal.StealRadius)
end)

-- FPS Y PING EN LA MISMA BARRA
task.spawn(function()
    local lastFrame = tick()
    local fpsSamples = {}
    local fpsAvg = 60
    RunService.RenderStepped:Connect(function()
        local now = tick()
        local dt = now - lastFrame
        lastFrame = now
        if dt > 0 then
            table.insert(fpsSamples, 1 / dt)
            if #fpsSamples > 30 then table.remove(fpsSamples, 1) end
            local sum = 0
            for _, v in ipairs(fpsSamples) do sum = sum + v end
            fpsAvg = sum / #fpsSamples
        end
    end)
    while true do
        local ping = 0
        pcall(function()
            ping = LP:GetNetworkPing() * 1000
        end)
        if progressRadLbl then
            progressRadLbl.Text = string.format("%d FPS | %dms", math.floor(fpsAvg + 0.5), math.floor(ping + 0.5))
        end
        task.wait(0.5)
    end
end)

    local function pointInsideVisiblePage(pos)
        for _, page in ipairs(pages) do
            if page.Visible then
                local pagePos = page.AbsolutePosition
                local pageSize = page.AbsoluteSize
                if pos.X >= pagePos.X and pos.X <= pagePos.X + pageSize.X
                    and pos.Y >= pagePos.Y and pos.Y <= pagePos.Y + pageSize.Y then
                    return true
                end
            end
        end
        return false
    end

    local function drag(f)
        local dn,ds,sp,di=false
        f.InputBegan:Connect(function(i)
            if uiLocked then return end
            if (i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch)
                and not pointInsideVisiblePage(i.Position) then
                dn=true; ds=i.Position; sp=f.Position
                i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then dn=false end end)
            end
        end)
        f.InputChanged:Connect(function(i)
            if i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch then di=i end
        end)
        UIS.InputChanged:Connect(function(i)
            if i==di and dn then
                if uiLocked then dn=false; return end
                local nX=sp.X.Offset+(i.Position.X-ds.X)
                local nY=sp.Y.Offset+(i.Position.Y-ds.Y)
                f.Position=UDim2.new(sp.X.Scale,nX,sp.Y.Scale,nY)
            end
        end)
    end
    -- La GUI se puede mover desde cualquier zona que no sea el ScrollingFrame.
    -- Dentro de Music y Keybinds el gesto queda reservado para desplazarse.
    drag(main)
end

-- Fin de la función buildGui

-- ============================================================
-- PARTE 2 – INICIALIZACIÓN, PANELES FLOTANTES Y EVENTOS
-- ============================================================

-- ====== ACTUALIZAR UI DESDE CONFIGURACIÓN CARGADA ======
local function updateUIFromLoaded()
    task.wait()
    -- buildGui() se ejecuta antes de loadAllSettings(); aplicar aquí la posición ya cargada.
    if pbFrame and type(savedProgressBarPos) == "table" then
        pbFrame.Position = UDim2.new(
            tonumber(savedProgressBarPos.XScale) or 0.5,
            tonumber(savedProgressBarPos.XOffset) or -140,
            tonumber(savedProgressBarPos.YScale) or 1,
            tonumber(savedProgressBarPos.YOffset) or -58
        )
    end
    if normalBox then normalBox.Text=tostring(NS) end
    if carryBox then carryBox.Text=tostring(CS) end
    if radInput then radInput.Text=tostring(Steal.StealRadius) end
    if stealDurationBox then stealDurationBox.Text=tostring(Steal.StealDuration) end
    if laggerBox then laggerBox.Text=tostring(LAGGER_SPEED_1) end
    if lagger2Box then lagger2Box.Text=tostring(LAGGER_SPEED_2) end
    if autoTPHeightBox then autoTPHeightBox.Text=tostring(autoTPHeight) end
    if batSpeedBox then batSpeedBox.Text = tostring(BAT_AIMBOT_SPEED) end
    if bypassSpeedBox then bypassSpeedBox.Text = tostring(BYPASS_AIMBOT_SPEED) end
    if dropModeBtnRef then
        dropModeBtnRef.Text = dropMode == 1 and "V1" or "V2"
    end
    if tpModeSelectBtn then
        tpModeSelectBtn.Text = tpDownMode == 1 and "V1" or "V2"
    end
    if bypassModeBtnRef then
        bypassModeBtnRef.Text = bypassMode == 1 and "Bypass" or "TP Bat"
    end
    refreshSpeedModeLabel()
    if uiLocked and setLockUIVisual then setLockUIVisual(true) end
    if antiRagdollEnabled and setAntiRagVisual then setAntiRagVisual(true); startAntiRagdoll() end
    -- Forzar Auto Steal activado
    Steal.AutoStealEnabled = true
    if setInstaGrab then setInstaGrab(true); pcall(startAutoSteal) end
    if jumpEnabled then
        if setJumpVisual then setJumpVisual(true) end
        startJumpMode()
    else
        if setJumpVisual then setJumpVisual(false) end
    end

    if medusaCounterEnabled then
        if setMedusaVisual then setMedusaVisual(true) end
        if LP.Character then setupMedusa(LP.Character) end
        if setMedusaAutoResetVisual then setMedusaAutoResetVisual(false) end
        stopMedusaAutoReset()
    elseif medusaAutoResetEnabled then
        if setMedusaAutoResetVisual then setMedusaAutoResetVisual(true) end
        if LP.Character then setupMedusaAutoReset(LP.Character) end
        if setMedusaVisual then setMedusaVisual(false) end
        stopMedusaCounter()
    else
        if setMedusaVisual then setMedusaVisual(false) end
        if setMedusaAutoResetVisual then setMedusaAutoResetVisual(false) end
        stopMedusaCounter()
        stopMedusaAutoReset()
    end

    if batCounterEnabled and setBatCounterVisual then
        setBatCounterVisual(true)
        startBatCounter()
    end
    if autoTPDownEnabled then if setAutoTPDownVisual then setAutoTPDownVisual(true) end; startAutoTPDown() end
    if autoBatEnabled and autoBatSetVisual then autoBatSetVisual(true); enableAutoBat() end
    if autoLeftEnabled and autoLeftSetVisual then autoLeftSetVisual(true) end
    if autoRightEnabled and autoRightSetVisual then autoRightSetVisual(true) end
    if unwalkEnabled and setUnwalkVisual then setUnwalkVisual(true); task.spawn(function() task.wait(0.5); startUnwalk() end) end
    if antiLagEnabled and setAntiLagVisual then enableAntiLag(); setAntiLagVisual(true) end

    if stretchEnabled then
        enableStretch()
        if _G.stretchToggleSetter then _G.stretchToggleSetter(true) end
    else
        if _G.stretchToggleSetter then _G.stretchToggleSetter(false) end
    end
    if _G.fovButtons then
        for _, btn in ipairs(_G.fovButtons) do
            local val = tonumber(btn.Text)
            if val == stretchFOV then
                btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                btn.TextColor3 = Color3.fromRGB(0,0,0)
            else
                btn.BackgroundColor3 = Color3.fromRGB(12,12,12)
                btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            end
        end
    end

    if _G.keyButtonRefs then
        for _, ref in ipairs(_G.keyButtonRefs) do
            local entry = ref.entry
            local label = (entry.gp and entry.gp.Name) or (entry.kb and entry.kb.Name) or "None"
            ref.btn.Text = label
        end
    end

    if modeSelectBtn then
        modeSelectBtn.Text = jumpMode == 1 and "Tap Tap" or "Hold"
    end

    if mobSetAutoBat then mobSetAutoBat(autoBatEnabled) end
    if mobSetAutoLeft then mobSetAutoLeft(autoLeftEnabled) end
    if mobSetAutoRight then mobSetAutoRight(autoRightEnabled) end
    if mobSetCarry then mobSetCarry(speedMode) end
    if mobSetLagger1 then mobSetLagger1(laggerToggled and laggerLevel==1) end
    if mobSetLagger2 then mobSetLagger2(laggerToggled and laggerLevel==2) end

    updateProgressBarVisibility()
    startEnemySpeed()
end

-- ====== PANEL MÓVIL (BOTONES FLOTANTES) ======
local function createMobilePanel()
    local panel = Instance.new("ScreenGui")
    panel.Name = "drakauhubMobilePanel"
    panel.ResetOnSpawn = false
    panel.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(panel) end end)
    if not pcall(function() panel.Parent = game:GetService("CoreGui") end) then
        panel.Parent = LP:WaitForChild("PlayerGui")
    end

    local BTN_W, BTN_H = 60, 60
    local GAP_X, GAP_Y = 8, 18
    local PANEL_W = BTN_W * 2 + GAP_X
    local PANEL_H = BTN_H * 5 + GAP_Y * 4

    local container = Instance.new("Frame", panel)
    container.Name = "FloatingPanel"
    container.Size = UDim2.new(0, PANEL_W, 0, PANEL_H)
    container.Position = UDim2.new(1, -PANEL_W - 10, 0, 0)
    container.BackgroundTransparency = 1
    container.BorderSizePixel = 0
    container.Active = false

    local ACCENT = Color3.fromRGB(255, 255, 255)
    local INACTIVE_BG = Color3.fromRGB(0, 0, 0)
    local STROKE_COLOR = Color3.fromRGB(255, 255, 255)
    local ACTIVE_BG = Color3.fromRGB(255, 255, 255)
    local ACTIVE_TEXT = Color3.fromRGB(0, 0, 0)

    local buttons = {}
    local defaultPositions = {
        BatBypass = {-(BTN_W + GAP_X), 0},
        TpBat     = {-(BTN_W + GAP_X), (BTN_H + GAP_Y) * 2},
        DropBR    = {0, 0},
        AutoLeft  = {BTN_W + GAP_X, 0},
        AutoBat   = {0, BTN_H + GAP_Y},
        AutoRight = {BTN_W + GAP_X, BTN_H + GAP_Y},
        TpDown    = {0, (BTN_H + GAP_Y) * 2},
        Carry     = {BTN_W + GAP_X, (BTN_H + GAP_Y) * 2},
        Lagger1   = {0, (BTN_H + GAP_Y) * 3},
        Lagger2   = {BTN_W + GAP_X, (BTN_H + GAP_Y) * 3},
    }

    local function readSavedPosition(name)
        local p = mobileButtonPositions and mobileButtonPositions[name]
        if type(p) == "table" then
            return UDim2.new(p.XScale or 0, p.XOffset or 0, p.YScale or 0, p.YOffset or 0)
        end
        local d = defaultPositions[name] or {0,0}
        return UDim2.new(0, d[1], 0, d[2])
    end

    local function saveButtonPosition(name, btn)
        mobileButtonPositions[name] = {
            XScale = btn.Position.X.Scale,
            XOffset = btn.Position.X.Offset,
            YScale = btn.Position.Y.Scale,
            YOffset = btn.Position.Y.Offset
        }
        pcall(saveAllSettings)
    end

    local function createButton(name, text, isToggle, callback)
        local btn = Instance.new("TextButton", container)
        btn.Name = name
        btn.Size = UDim2.new(0, BTN_W, 0, BTN_H)
        btn.Position = readSavedPosition(name)
        btn.BackgroundColor3 = INACTIVE_BG
        btn.BorderSizePixel = 0
        btn.Text = ""
        btn.AutoButtonColor = false
        btn.Active = true
        btn.Selectable = true
        _G.__FROST_MOBILE_BUTTON_REFS[name] = btn
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 18)

        local stroke = Instance.new("UIStroke", btn)
        stroke.Color = STROKE_COLOR
        stroke.Thickness = 1.2
        stroke.Transparency = 0.4

        local label = Instance.new("TextLabel", btn)
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.Font = Enum.Font.FredokaOne
        label.TextSize = 10
        label.TextWrapped = true
        label.Active = false
        applyShimmerToText(label, 0.7)

        local active = false
        local function setActive(state)
            active = state and true or false
            if active then
                btn.BackgroundColor3 = ACTIVE_BG
                label.TextColor3 = ACTIVE_TEXT
                stroke.Color = Color3.fromRGB(255,255,255)
                stroke.Transparency = 0
            else
                btn.BackgroundColor3 = INACTIVE_BG
                label.TextColor3 = Color3.fromRGB(255, 255, 255)
                stroke.Color = STROKE_COLOR
                stroke.Transparency = 0.4
            end
        end

        local dragging = false
        local moved = false
        local dragStart = nil
        local startPos = nil
        local trackedInput = nil
        local threshold = 7

        btn.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                moved = false
                dragStart = input.Position
                startPos = btn.Position
                trackedInput = input
            end
        end)

        UIS.InputChanged:Connect(function(input)
            if not dragging or uiLocked then return end
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                local delta = input.Position - dragStart
                if math.abs(delta.X) > threshold or math.abs(delta.Y) > threshold then moved = true end
                if moved then
                    btn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                            startPos.Y.Scale, startPos.Y.Offset + delta.Y)
                end
            end
        end)

        local function finishDrag(input)
            if not dragging then return end
            if input and trackedInput and input.UserInputType ~= trackedInput.UserInputType and input.UserInputType ~= Enum.UserInputType.MouseButton1 then
                return
            end
            dragging = false
            if moved then
                saveButtonPosition(name, btn)
            else
                if callback then callback(setActive, active) end
            end
            trackedInput = nil
            dragStart = nil
            startPos = nil
        end

        btn.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                finishDrag(input)
            end
        end)
        UIS.InputEnded:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
                finishDrag(input)
            end
        end)

        buttons[name] = {btn=btn, setActive=setActive, label=label}
        return setActive
    end

    mobSetDropBR = createButton("DropBR", "DROP\nBR", true, function(setActive)
        if autoBatEnabled then return end
        setActive(true)
        executeDropWithToggle(function(v)
            if dropBrainrotSetVisual then dropBrainrotSetVisual(v) end
        end)
        task.delay(0.3, function() setActive(false) end)
    end)

    mobSetAutoLeft = createButton("AutoLeft", "AUTO\nLEFT", true, function(setActive)
        autoLeftEnabled = not autoLeftEnabled
        setActive(autoLeftEnabled)
        if autoLeftEnabled then startAutoLeft() else stopAutoLeft() end
        if autoLeftSetVisual then autoLeftSetVisual(autoLeftEnabled) end
    end)

    mobSetAutoBat = createButton("AutoBat", "BAT\nAIMBOT", true, function(setActive)
        if not autoBatEnabled then enableAutoBat() else disableAutoBat() end
        setActive(autoBatEnabled)
    end)

    mobSetAutoRight = createButton("AutoRight", "AUTO\nRIGHT", true, function(setActive)
        autoRightEnabled = not autoRightEnabled
        setActive(autoRightEnabled)
        if autoRightEnabled then startAutoRight() else stopAutoRight() end
        if autoRightSetVisual then autoRightSetVisual(autoRightEnabled) end
    end)

    mobSetTpDown = createButton("TpDown", "TP\nDOWN", true, function(setActive)
        executeTPDown()
        setActive(true)
        task.delay(0.2, function() setActive(false) end)
    end)

    mobSetCarry = createButton("Carry", "CARRY\nSPD", true, function(setActive)
        if not speedMode then
            speedMode = true
            laggerToggled = false
            laggerLevel = 1
            setActive(true)
            if buttons.Lagger1 then buttons.Lagger1.setActive(false) end
            if buttons.Lagger2 then buttons.Lagger2.setActive(false) end
        else
            speedMode = false
            setActive(false)
        end
        refreshSpeedModeLabel()
    end)

    mobSetLagger1 = createButton("Lagger1", "LAGGER\nCARRY", true, function(setActive)
        if speedMode then speedMode=false; if mobSetCarry then mobSetCarry(false) end end
        if not laggerToggled or laggerLevel ~= 1 then
            laggerToggled = true
            laggerLevel = 1
            setActive(true)
            if buttons.Lagger2 then buttons.Lagger2.setActive(false) end
        else
            laggerToggled = false
            laggerLevel = 1
            setActive(false)
        end
        refreshSpeedModeLabel()
    end)

    mobSetLagger2 = createButton("Lagger2", "LAGGER\nMODE", true, function(setActive)
        if speedMode then speedMode=false; if mobSetCarry then mobSetCarry(false) end end
        if not laggerToggled or laggerLevel ~= 2 then
            laggerToggled = true
            laggerLevel = 2
            setActive(true)
            if buttons.Lagger1 then buttons.Lagger1.setActive(false) end
        else
            laggerToggled = false
            laggerLevel = 1
            setActive(false)
        end
        refreshSpeedModeLabel()
    end)

    createButton("BatBypass", "BAT\nV2", true, function(setActive)
        local turningOff = bypassToggled and bypassMode == 1
        if turningOff then
            toggleBypass(false)
        else
            if bypassToggled then toggleBypass(false) end
            bypassMode = 1
            toggleBypass(true)
        end
        if buttons.BatBypass then buttons.BatBypass.setActive(bypassToggled and bypassMode == 1) end
        if buttons.TpBat then buttons.TpBat.setActive(bypassToggled and bypassMode == 2) end
        pcall(saveAllSettings)
    end)

    createButton("TpBat", "ANTI\nDESYNC", true, function(setActive)
        local turningOff = bypassToggled and bypassMode == 2
        if turningOff then
            toggleBypass(false)
        else
            if bypassToggled then toggleBypass(false) end
            bypassMode = 2
            toggleBypass(true)
        end
        if buttons.BatBypass then buttons.BatBypass.setActive(bypassToggled and bypassMode == 1) end
        if buttons.TpBat then buttons.TpBat.setActive(bypassToggled and bypassMode == 2) end
        pcall(saveAllSettings)
    end)

    if buttons.AutoBat then buttons.AutoBat.setActive(autoBatEnabled) end
    if buttons.AutoLeft then buttons.AutoLeft.setActive(autoLeftEnabled) end
    if buttons.AutoRight then buttons.AutoRight.setActive(autoRightEnabled) end
    if buttons.Carry then buttons.Carry.setActive(speedMode) end
    if buttons.Lagger1 then buttons.Lagger1.setActive(laggerToggled and laggerLevel==1) end
    if buttons.Lagger2 then buttons.Lagger2.setActive(laggerToggled and laggerLevel==2) end
    if buttons.BatBypass then buttons.BatBypass.setActive(bypassToggled and bypassMode==1) end
    if buttons.TpBat then buttons.TpBat.setActive(bypassToggled and bypassMode==2) end

    _G.__FROST_RESET_MOBILE_BUTTONS = function()
        for name, data in pairs(buttons) do
            local d = defaultPositions[name]
            if data and data.btn and data.btn.Parent and d then
                data.btn.Position = UDim2.new(0, d[1], 0, d[2])
            end
        end
        for key in pairs(mobileButtonPositions) do
            mobileButtonPositions[key] = nil
        end
    end

    return panel
end

-- ====== BOTÓN FLOTANTE BYPASS (DESACTIVADO) ======
-- Se ha eliminado el botón flotante de bypass y se ha movido al panel móvil.
-- Esta función se mantiene por compatibilidad pero no se usa.
local function createBypassFloatingButton()
    -- No se usa
    return nil
end

-- ============================================================
-- EJECUCIÓN PRINCIPAL
-- ============================================================

-- INTRO: créée avant toute interface pour éviter tout flash de l'UI
_introAnimEnabled = true -- animation forced on
 pcall(function() local _s = readfile("SpeedHubConfig.json") if not _s or _s == "" then _s = readfile("Drakau DuelCCConfig.json") end if _s and _s ~= "" then local _c = game:GetService("HttpService"):JSONDecode(_s)  end end) if _introAnimEnabled then task.spawn(function() local introGui = Instance.new("ScreenGui") introGui.Name = "Drakau Duel_Intro" introGui.ResetOnSpawn = false introGui.DisplayOrder = 999 introGui.IgnoreGuiInset = true introGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling introGui.Parent = LP:WaitForChild("PlayerGui") local hiddenGuis = {} local function hideScreenGuis(root) if not root then return end for _, child in ipairs(root:GetChildren()) do if child:IsA("ScreenGui") and child ~= introGui and child.Name ~= introGui.Name then if hiddenGuis[child] == nil then hiddenGuis[child] = child.Enabled end child.Enabled = false end end end hideScreenGuis(LP:FindFirstChild("PlayerGui")) pcall(function() hideScreenGuis(game:GetService("CoreGui")) end) local introActive = true task.spawn(function() while introActive and introGui and introGui.Parent do hideScreenGuis(LP:FindFirstChild("PlayerGui")) pcall(function() hideScreenGuis(game:GetService("CoreGui")) end) task.wait(0.03) end end) local bg = Instance.new("Frame", introGui) bg.Size = UDim2.new(1, 0, 1, 0) bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0) bg.BackgroundTransparency = 0 bg.BorderSizePixel = 0 bg.ZIndex = 1 local bgGrad = Instance.new("UIGradient", bg) bgGrad.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)), ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)), }) bgGrad.Rotation = 135 local speedLbl = Instance.new("TextLabel", introGui) speedLbl.Size = UDim2.new(0, 500, 0, 90) speedLbl.AnchorPoint = Vector2.new(0.5, 0.5) speedLbl.Position = UDim2.new(0.5, 0, -0.25, 0) speedLbl.BackgroundTransparency = 1 speedLbl.Text = "Drakau Duel" speedLbl.TextColor3 = Color3.fromRGB(255, 255, 255) speedLbl.Font = Enum.Font.GothamBlack speedLbl.TextSize = 80 speedLbl.TextTransparency = 1 speedLbl.ZIndex = 10 local speedGrad = Instance.new("UIGradient", speedLbl) speedGrad.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)), }) speedGrad.Rotation = 0 local hubLbl = Instance.new("TextLabel", introGui) hubLbl.Size = UDim2.new(0, 500, 0, 90) hubLbl.AnchorPoint = Vector2.new(0.5, 0.5) hubLbl.Position = UDim2.new(0.5, 0, 1.25, 0) hubLbl.BackgroundTransparency = 1 hubLbl.Text = ".CC" hubLbl.TextColor3 = Color3.fromRGB(255, 255, 255) hubLbl.Font = Enum.Font.GothamBlack hubLbl.TextSize = 80 hubLbl.TextTransparency = 1 hubLbl.ZIndex = 10 local hubGrad = Instance.new("UIGradient", hubLbl) hubGrad.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)), }) hubGrad.Rotation = 0 local accentLine = Instance.new("Frame", introGui) accentLine.Size = UDim2.new(0, 0, 0, 2) accentLine.AnchorPoint = Vector2.new(0.5, 0.5) accentLine.Position = UDim2.new(0.5, 0, 0.5, 0) accentLine.BackgroundColor3 = Color3.fromRGB(255, 255, 255) accentLine.BorderSizePixel = 0 accentLine.BackgroundTransparency = 1 accentLine.ZIndex = 9 local glowDot = Instance.new("Frame", introGui) glowDot.Size = UDim2.new(0, 6, 0, 6) glowDot.AnchorPoint = Vector2.new(0.5, 0.5) glowDot.Position = UDim2.new(0.5, 0, 0.5, 0) glowDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255) glowDot.BorderSizePixel = 0 glowDot.BackgroundTransparency = 0.3 glowDot.ZIndex = 9 Instance.new("UICorner", glowDot).CornerRadius = UDim.new(1, 0) task.wait(0.3) TS :Create( speedLbl, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { TextTransparency = 0 } ) :Play() TS :Create( hubLbl, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { TextTransparency = 0 } ) :Play() TS:Create(speedLbl, TweenInfo.new(1.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Position = UDim2.new(0.5, 0, 0.5, -58), }):Play() TS:Create(hubLbl, TweenInfo.new(1.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Position = UDim2.new(0.5, 0, 0.5, 58), }):Play() task.spawn(function() local t = 0 while introGui and introGui.Parent do t = t + 0.04 local offset = math.sin(t * 2.5) * 0.35 speedGrad.Offset = Vector2.new(offset, 0) hubGrad.Offset = Vector2.new(-offset, 0) task.wait(0.03) end end) task.wait(1.25) TS:Create(accentLine, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = UDim2.new(0, 220, 0, 2), BackgroundTransparency = 0.5, }):Play() TS:Create(glowDot, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = UDim2.new(0, 120, 0, 120), BackgroundTransparency = 1, }):Play() task.wait(1.0) TS :Create( bg, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundTransparency = 1 } ) :Play() TS :Create( speedLbl, TweenInfo.new(0.65, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { TextTransparency = 1 } ) :Play() TS :Create( hubLbl, TweenInfo.new(0.65, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { TextTransparency = 1 } ) :Play() TS:Create(accentLine, TweenInfo.new(0.55), { BackgroundTransparency = 1 }):Play() task.wait(0.55) task.wait(0.45) introActive = false for otherGui, wasEnabled in pairs(hiddenGuis) do if otherGui and otherGui.Parent then otherGui.Enabled = wasEnabled end end introGui:Destroy() end) else if main then main.Visible = true end end 

-- Laisser l'intro créer son écran noir avant de construire le hub
task.wait(0.1)

buildGui()

if loadAllSettings() then
    updateUIFromLoaded()
end

MobilePanel = createMobilePanel()

-- bypassFloatingButton desactivado: BAT BYPASS y TP BAT ahora viven en el panel móvil

if LP.Character then
    task.wait(0.0)
    setupSpeedIndicator(LP.Character)
end

-- ====== REACCIÓN AL CAMBIO DE PERSONAJE ======
LP.CharacterAdded:Connect(function(char)
    stopAutoSteal()
    stopAutoLeft()
    stopAutoRight()
    stopBatCounter()
    stopMedusaCounter()
    stopAutoTPDown()
    stopAntiRagdoll()
    stopUnwalk()
    stopDropBrainrot()
    stopMedusaAutoReset()
    if autoBatEnabled then disableAutoBat() end
    if bypassToggled then stopBypassAimbot() end

    task.wait(0.1)
    while not LP.Character or not LP.Character:FindFirstChild("HumanoidRootPart") or not LP.Character:FindFirstChildOfClass("Humanoid") do
        task.wait()
    end

    if steppedConn then steppedConn:Disconnect(); steppedConn = nil end
    if movementLoop then movementLoop:Disconnect(); movementLoop = nil end

    steppedConn = RunService.Stepped:Connect(function()
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP and p.Character then
                for _, part in ipairs(p.Character:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end
    end)

    -- TRACERS - Reactivar al reaparecer
    if tracersEnabled then
        task.spawn(function()
            task.wait(1)
            startTracers()
        end)
    end

    movementLoop = RunService.RenderStepped:Connect(function()
        local char2 = LP.Character
        if not char2 then return end
        local hum = char2:FindFirstChildOfClass("Humanoid")
        local hrp = char2:FindFirstChild("HumanoidRootPart")
        if not hum or not hrp then return end

        if not autoBatEnabled and not bypassToggled and not autoLeftEnabled and not autoRightEnabled then
            local md = hum.MoveDirection
            local spd
            if laggerToggled then
                spd = (laggerLevel == 2) and LAGGER_SPEED_2 or LAGGER_SPEED_1
            else
                spd = speedMode and CS or NS
            end

            -- ====== SPEED UNPATCH (CRÍTICO) ======
            if hum.WalkSpeed ~= spd then
                hum.WalkSpeed = spd
            end
            -- ====================================

            if md.Magnitude > 0 then
                lastMoveDir = md
                hrp.Velocity = Vector3.new(md.X * spd, hrp.Velocity.Y, md.Z * spd)
            elseif antiRagdollEnabled and lastMoveDir.Magnitude > 0 then
                local anyHeld = false
                for key in pairs(MOVE_KEYS) do
                    if UIS:IsKeyDown(key) then anyHeld = true; break end
                end
                if anyHeld then
                    hrp.Velocity = Vector3.new(lastMoveDir.X * spd, hrp.Velocity.Y, lastMoveDir.Z * spd)
                end
            end
        end

        if speedLabel then
            speedLabel.Text = string.format("%.1f", Vector3.new(hrp.Velocity.X, 0, hrp.Velocity.Z).Magnitude)
        end
    end)

    setupSpeedIndicator(char)

    if autoBatEnabled then enableAutoBat() end
    if autoLeftEnabled then startAutoLeft() end
    if autoRightEnabled then startAutoRight() end
    if bypassToggled then toggleBypass(true) end
    if Steal.AutoStealEnabled then pcall(startAutoSteal) end
    if jumpEnabled then startJumpMode() end
    if antiRagdollEnabled then startAntiRagdoll() end

    if medusaCounterEnabled then
        setupMedusa(char)
        if setMedusaVisual then setMedusaVisual(true) end
        if setMedusaAutoResetVisual then setMedusaAutoResetVisual(false) end
        stopMedusaAutoReset()
    elseif medusaAutoResetEnabled then
        setupMedusaAutoReset(char)
        if setMedusaAutoResetVisual then setMedusaAutoResetVisual(true) end
        if setMedusaVisual then setMedusaVisual(false) end
        stopMedusaCounter()
    else
        stopMedusaCounter()
        stopMedusaAutoReset()
        if setMedusaVisual then setMedusaVisual(false) end
        if setMedusaAutoResetVisual then setMedusaAutoResetVisual(false) end
    end

    if batCounterEnabled then startBatCounter() end
    if unwalkEnabled then startUnwalk() end
    if autoTPDownEnabled then startAutoTPDown() end

    updateProgressBarVisibility()
    refreshSpeedModeLabel()
end)

-- ====== TECLADO Y GAMEPAD ======
local lastLaggerToggle = 0
local LAGGER_COOLDOWN = 0.3

UIS.InputBegan:Connect(function(input, gpe)
    if _anyKeyListening then return end
    if input.UserInputType == Enum.UserInputType.Keyboard then
        if gpe or UIS:GetFocusedTextBox() then return end
    elseif not isGamepadInput(input) then
        return
    end
    if not isBindableInput(input) then return end

    local kc = input.KeyCode
    if not kc then return end

    if kbMatch(KB.LaggerMode, kc) then
        if tick() - lastLaggerToggle >= LAGGER_COOLDOWN then
            lastLaggerToggle = tick()
            toggleLaggerCycle()
        end
        return
    end
    if kbMatch(KB.CarryToggle, kc) then toggleCarryMode() return end
    if kbMatch(KB.DropBrainrot, kc) then
        if not dropActive then
            if dropBrainrotSetVisual then dropBrainrotSetVisual(true) end
            executeDropWithToggle(dropBrainrotSetVisual)
        end
        return
    end
    if kbMatch(KB.TPFloor, kc) then executeTPDown() return end
    if kbMatch(KB.InstaReset, kc) then insta_reset() return end
    if kbMatch(KB.AutoLeft, kc) then
        autoLeftEnabled = not autoLeftEnabled
        if autoLeftEnabled then
            startAutoLeft()
        else
            stopAutoLeft()
        end
        if autoLeftSetVisual then autoLeftSetVisual(autoLeftEnabled) end
        if mobSetAutoLeft then mobSetAutoLeft(autoLeftEnabled) end
        return
    end
    if kbMatch(KB.AutoRight, kc) then
        autoRightEnabled = not autoRightEnabled
        if autoRightEnabled then
            startAutoRight()
        else
            stopAutoRight()
        end
        if autoRightSetVisual then autoRightSetVisual(autoRightEnabled) end
        if mobSetAutoRight then mobSetAutoRight(autoRightEnabled) end
        return
    end
    if kbMatch(KB.AutoBat, kc) then
        if not autoBatEnabled then
            enableAutoBat()
            if autoBatSetVisual then autoBatSetVisual(true) end
            if mobSetAutoBat then mobSetAutoBat(true) end
        else
            disableAutoBat()
            if autoBatSetVisual then autoBatSetVisual(false) end
            if mobSetAutoBat then mobSetAutoBat(false) end
        end
        return
    end

    -- ====== CAMBIO AQUÍ: la tecla Bypass ahora activa el modo Anti‑Desync (modo 2) ======
    if kbMatch(KB.Bypass, kc) then
        -- Si ya está activado el modo 2, lo desactivamos; si no, activamos modo 2.
        if bypassToggled and bypassMode == 2 then
            toggleBypass(false)
        else
            if bypassToggled then toggleBypass(false) end
            bypassMode = 2  -- Forzamos modo Anti‑Desync
            toggleBypass(true)
        end
        -- Actualizar los botones del panel móvil para reflejar el estado
        if buttons and buttons.BatBypass then buttons.BatBypass.setActive(bypassToggled and bypassMode == 1) end
        if buttons and buttons.TpBat then buttons.TpBat.setActive(bypassToggled and bypassMode == 2) end
        return
    end

    if kbMatch(KB.AutoTPDown, kc) then
        autoTPDownEnabled = not autoTPDownEnabled
        if autoTPDownEnabled then
            startAutoTPDown()
        else
            stopAutoTPDown()
        end
        if setAutoTPDownVisual then setAutoTPDownVisual(autoTPDownEnabled) end
        return
    end
    if kbMatch(KB.JumpMode, kc) then
        if modeSelectBtn then
            local newMode = jumpMode == 1 and 2 or 1
            jumpMode = newMode
            modeSelectBtn.Text = jumpMode == 1 and "Tap Tap" or "Hold"
            if jumpEnabled then
                stopJumpMode()
                startJumpMode()
            end
        end
        return
    end
    if kbMatch(KB.GuiHide, kc) then
        if main then
            if main.Visible then hideGui() else showGui() end
        end
        return
    end
end)



-- ====== GUARDADO AUTOMÁTICO ======
task.spawn(function()
    while true do
        task.wait(5)
        pcall(saveAllSettings)
    end
end)

-- ============================================================
-- FIN DEL SCRIPT
-- ============================================================