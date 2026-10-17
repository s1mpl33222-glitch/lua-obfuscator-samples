local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/main/Library.lua"))()
local Toggles = Library.Toggles
local Options = Library.Options

local Window = Library:CreateWindow({
    Title = "Keyper x Paid - Discord.gg/RUKgU6eNBc",
    Footer = "version: 1.0 | .gg/luax | made by chickenbrts, roaxi, visnouk and yolegit",
    Center = true,
    AutoShow = true,
    Resizable = true,
    MobileButtonsSide = "Left"
})

local function Notify(text, duration)
    Library:Notify({ Title = "Lua x paid", Description = text, Time = duration or 3 })
end

pcall(function()
    local ACBypass = {}
    ACBypass.__index = ACBypass

    local PlayersAC = cloneref(game:GetService("Players"))
    local ReplicatedStorageAC = cloneref(game:GetService("ReplicatedStorage"))
    local ReplicatedFirstAC = cloneref(game:GetService("ReplicatedFirst"))
    local ScriptContextAC = cloneref(game:GetService("ScriptContext"))
    local LocalPlayerAC = PlayersAC.LocalPlayer

    local stateAC = { bypassed = false, load_state = "Unloaded" }
    local kExpectedScripts = { [1914481512] = "Root", [1936447744] = "ReplicatedController", [3892767096] = "MiscellaneousController", [337076960] = "LocalScript3", [2191862192] = "ClientFighter" }

    local function SafeHook(hookfn, ...)
        local args = {...}
        local func, inst, metamethod, detour
        if hookfn == hookmetamethod then inst, metamethod, detour = args[1], args[2], args[3] else func, detour = args[1], args[2] end
        if hookfn == hookfunction and iscclosure(func) then detour = newcclosure(detour) end
        if not iscclosure(detour) then detour = newcclosure(detour) end
        local original
        pcall(function()
            if hookfn == hookmetamethod then original = hookfn(inst, metamethod, detour) else original = hookfn(func, detour) end
        end)
        return original
    end

    local function SafeCall(func, ...)
        if checkcaller() then return func(...) end
        local old = getthreadidentity()
        if old ~= 2 then setthreadidentity(2) end
        local r = { func(...) }
        if old ~= 2 then setthreadidentity(old) end
        return table.unpack(r)
    end

    local function VerifyScripts()
        local getscripts_fn, getbytecode_fn = pcall(function() return getscripts or getsenv end), pcall(function() return getscriptbytecode end)
        if not getscripts_fn or not getbytecode_fn then return true end
        local found = {}
        for _, script_instance in ipairs(getscripts_fn()) do
            local ok, bytecode = pcall(getbytecode_fn, script_instance)
            if ok and bytecode then
                for expected_id, _ in pairs(kExpectedScripts) do
                    if not found[expected_id] then
                        local source_ok, source = pcall(debug.info, script_instance, "s")
                        if source_ok and source and source ~= "=[C]" then found[expected_id] = true end
                    end
                end
            end
        end
        for id, _ in pairs(kExpectedScripts) do if not found[id] then return false end end
        return true
    end

    local function HookKickPrevention()
        for _, name in ipairs({"Kick", "kick"}) do
            local f = LocalPlayerAC[name]
            if type(f) == "function" then
                local old
                old = SafeHook(hookfunction, f, function(self, ...)
                    if self == LocalPlayerAC and not checkcaller() then return end
                    return old(self, ...)
                end)
            end
        end
    end

    local function HookACScript(ac_script)
        if not ac_script then return end
        local oldindex = SafeHook(hookmetamethod, ac_script, "__index", function(t, k)
            if t == ac_script and not checkcaller() and k == "Enabled" and not stateAC.bypassed then return false end
            if checkcaller() then return oldindex(t, k) end
            return SafeCall(oldindex, t, k)
        end)
        local oldnewindex = SafeHook(hookmetamethod, ac_script, "__newindex", function(t, k, v)
            if t == ac_script and not checkcaller() and k == "Enabled" and not stateAC.bypassed then return end
            if checkcaller() then return oldnewindex(t, k, v) end
            return SafeCall(oldnewindex, t, k, v)
        end)
    end

    if VerifyScripts() then
        local ac_script = ReplicatedFirstAC:WaitForChild("LocalScript3", 10)
        local ac_event = ReplicatedStorageAC:WaitForChild("Remotes", 10):WaitForChild("RemoteEvent", 10)
        if ac_script and ac_event then
            HookACScript(ac_script)
            HookKickPrevention()
            ac_script.Enabled = false
            stateAC.bypassed = true
            print("[Lua x paid] AC Bypass loaded")
        end
    end
end)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local rng = Random.new()
local char, root, hum
local conns = {}

local function killConn(key)
    if conns[key] then conns[key]:Disconnect(); conns[key] = nil end
end

local function getLocalRoot()
    return root
end

local function getClosest()
    if not root then return nil end
    local best, bestDist = nil, math.huge
    for _, p in ipairs(Players:GetPlayers()) do
        if p == LocalPlayer or not p.Character then continue end
        local hrp = p.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then continue end
        local d = (root.Position - hrp.Position).Magnitude
        if d < bestDist then bestDist = d; best = p end
    end
    return best
end

local function bindChar(c)
    char = c
    root = c:WaitForChild("HumanoidRootPart", 5)
    hum = c:WaitForChild("Humanoid", 5)
    if riotEnabled then startRiot() end
    if riotAbuseEnabled then startRiotAbuse() end
end

if LocalPlayer.Character then bindChar(LocalPlayer.Character) end

LocalPlayer.CharacterAdded:Connect(function(c)
    bindChar(c)
    task.wait(0.3)
    if CFG.VOID_ENABLED then startVoid() end
    if cfg.orbitEnabled then startOrbit() end
    if cfgDodge.predEnabled then startPrediction() end
    if aaSettings.enabled then startAntiAim() end
end)

LocalPlayer.CharacterRemoving:Connect(function()
    killConn("void"); killConn("orbit"); killConn("pred"); killConn("antiAim"); killConn("riot"); killConn("riotAbuse")
    root = nil; hum = nil; char = nil
end)

local CFG = {
    VOID_ENABLED = false, VOID_METHOD = "Quantum",
    SPEED = 1e9, CHAOS = 0.98, BASE_ALTITUDE = 1e10, RADIUS = 2e11,
    VOID_EVADE = true, VOID_EVADE_RADIUS = 8e9, VOID_EVADE_SPEED = 6e9, VOID_EVADE_VERT = 3e9, VOID_EVADE_FORCE_UP = false, VOID_EVADE_COOLDOWN = 0.05, VOID_EVADE_TRIGGER = 1.0, VOID_EVADE_STRENGTH = 1.0,
}
local elapsed, voidPos, voidDriftDir, basePos, voidEvadeCD, intendedVoidPos = 0, Vector3.new(0, CFG.BASE_ALTITUDE, 0), Vector3.new(1, 0, 0).Unit, Vector3.new(0, CFG.BASE_ALTITUDE, 0), 0, Vector3.new(0, CFG.BASE_ALTITUDE, 0)

local function computeVoidDriftDir3D(t)
    local nx, ny, nz, amp, freq = 0, 0, 0, 1, 0.0001
    for i=1,4 do nx = nx + math.noise(t*freq, 0, 0)*amp; ny = ny + math.noise(0, t*freq, 0)*amp; nz = nz + math.noise(0, 0, t*freq)*amp; freq = freq*2.37; amp = amp*0.5 end
    local sp, cp = t*0.00073, t*0.00213
    nx = nx + math.noise(sp+13.7, 7.3, 0)*0.3 + math.sin(cp)*math.cos(cp*1.618)*0.2
    ny = ny + math.noise(0, sp+31.1, 17.9)*0.3 + math.cos(cp*0.618)*math.sin(cp*2.718)*0.2
    nz = nz + math.noise(7.3, 0, sp+11.5)*0.3 + math.sin(cp*1.3)*math.cos(cp*0.7)*0.2
    local len = math.sqrt(nx*nx + ny*ny + nz*nz)
    if len < 0.001 then return 1, 0, 0 end
    return nx/len, ny/len, nz/len
end

local function stepVoidDrift(dt)
    local m = CFG.VOID_METHOD
    if m == "Drift" then
        local dx, dy, dz = computeVoidDriftDir3D(elapsed)
        voidDriftDir = voidDriftDir:Lerp(Vector3.new(dx, dy, dz).Unit, CFG.CHAOS * dt * 10)
        voidPos = voidPos + voidDriftDir * CFG.SPEED * dt
        if (voidPos - basePos).Magnitude > CFG.RADIUS then voidPos = basePos + (voidPos - basePos).Unit * CFG.RADIUS; voidDriftDir = -voidDriftDir end
        return voidPos
    elseif m == "Chaos" then
        voidPos = voidPos + Vector3.new((math.random()-0.5)*CFG.SPEED*dt*5, (math.random()-0.5)*CFG.SPEED*dt*5, (math.random()-0.5)*CFG.SPEED*dt*5)
        if (voidPos - basePos).Magnitude > CFG.RADIUS then voidPos = basePos + (voidPos - basePos).Unit * CFG.RADIUS end
        return voidPos
    elseif m == "Loop" then
        local r = math.min(CFG.RADIUS * 0.8, 1e9 + (elapsed % 100)*1e7)
        return basePos + Vector3.new(math.cos(elapsed*2)*r, math.sin(elapsed*1.3)*r*0.2, math.sin(elapsed*2)*r)
    elseif m == "Spiral" then
        local r = math.min(CFG.RADIUS * 0.9, (elapsed % 50)*2e9)
        return basePos + Vector3.new(math.cos(elapsed*3)*r, math.sin(elapsed*0.5)*r*0.3, math.sin(elapsed*3)*r)
    elseif m == "Quantum" then
        local r = CFG.RADIUS * (math.random()>0.5 and 1 or -1)
        return basePos + Vector3.new(r, (math.random()-0.5)*CFG.RADIUS*0.2, r) + Vector3.new((math.random()-0.5)*CFG.RADIUS, 0, (math.random()-0.5)*CFG.RADIUS)
    end
    return voidPos
end

local function checkVoidEvasion()
    if not CFG.VOID_EVADE or voidEvadeCD > 0 then return end
    local minDist, threatVec = math.huge, Vector3.new()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local hrp = p.Character:FindFirstChild("HumanoidRootPart")
            local hum = p.Character:FindFirstChildOfClass("Humanoid")
            if hrp and hum and hum.Health > 0 then
                local d = (hrp.Position + hrp.AssemblyLinearVelocity*0.5 - intendedVoidPos).Magnitude
                if d < minDist then minDist = d; threatVec = (hrp.Position + hrp.AssemblyLinearVelocity*0.5 - intendedVoidPos).Unit end
            end
        end
    end
    if minDist < (CFG.VOID_EVADE_RADIUS * CFG.VOID_EVADE_TRIGGER) then
        local strength = CFG.VOID_EVADE_STRENGTH
        voidPos = voidPos - threatVec * CFG.VOID_EVADE_SPEED * (1 + (1 - minDist/(CFG.VOID_EVADE_RADIUS*CFG.VOID_EVADE_TRIGGER))*2) * strength * 0.5
        if (voidPos - basePos).Magnitude > CFG.RADIUS then voidPos = basePos + (voidPos - basePos).Unit * CFG.RADIUS end
        voidEvadeCD = CFG.VOID_EVADE_COOLDOWN
    end
end

local function lockToVoid(dt)
    if voidEvadeCD > 0 then voidEvadeCD = voidEvadeCD - dt end
    checkVoidEvasion()
    intendedVoidPos = stepVoidDrift(dt)
    local hrp = getLocalRoot()
    if not hrp then return end
    pcall(function() hrp.CFrame = CFrame.new(intendedVoidPos); hrp.AssemblyLinearVelocity = Vector3.zero; hrp.AssemblyAngularVelocity = Vector3.zero end)
    if math.random(1,10) == 1 then
        pcall(function() hrp.AssemblyLinearVelocity = Vector3.new((math.random()-0.5)*2e7, (math.random()-0.5)*2e7, (math.random()-0.5)*2e7) end)
    end
end

function startVoid()
    killConn("void")
    local hrp = getLocalRoot()
    if hrp then
        voidPos = Vector3.new(hrp.Position.X, CFG.BASE_ALTITUDE, hrp.Position.Z)
        basePos = Vector3.new(0, CFG.BASE_ALTITUDE, 0)
        intendedVoidPos = voidPos
    end
    conns.void = RunService.Heartbeat:Connect(function(dt)
        if not CFG.VOID_ENABLED then killConn("void"); return end
        elapsed = elapsed + dt
        lockToVoid(dt)
    end)
end
function stopVoid() killConn("void") end

local cfg = { orbitEnabled = false, orbitSpeed = 90, orbitDist = 8, orbitHeight = 0, orbitLerp = 0.3, orbitMode = "Circle", orbitPredict = false, orbitPredStrength = 0.2, orbitFaceTarget = true, orbitAutoLockDist = 50 }
local orbitAngle = 0
local orbitLocalElapsed = 0
local orbitCurrentRadius = 0

function startOrbit()
    killConn("orbit")
    if hum then hum:ChangeState(Enum.HumanoidStateType.Physics) end
    orbitAngle = 0
    orbitLocalElapsed = 0
    orbitCurrentRadius = cfg.orbitDist

    conns.orbit = RunService.Heartbeat:Connect(function(dt)
        if not cfg.orbitEnabled or not root then 
            if not cfg.orbitEnabled then killConn("orbit") end
            return 
        end
        
        local target = getClosest()
        if not target or not target.Character then return end
        local hrp = target.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        if (root.Position - hrp.Position).Magnitude > cfg.orbitAutoLockDist then return end

        local targetPos = hrp.Position
        if cfg.orbitPredict then
            targetPos = targetPos + hrp.AssemblyLinearVelocity * cfg.orbitPredStrength
        end

        orbitAngle = orbitAngle + math.rad(cfg.orbitSpeed) * dt
        orbitLocalElapsed = orbitLocalElapsed + dt

        local r = cfg.orbitDist
        local h = cfg.orbitHeight
        local x, y, z = 0, 0, 0

        if cfg.orbitMode == "Circle" then
            x = math.cos(orbitAngle) * r
            z = math.sin(orbitAngle) * r
            y = h
        elseif cfg.orbitMode == "Figure 8" then
            x = math.sin(orbitAngle) * r
            z = math.sin(orbitAngle) * math.cos(orbitAngle) * r * 0.7
            y = h
        elseif cfg.orbitMode == "Spiral In" then
            orbitCurrentRadius = math.max(1, orbitCurrentRadius - (dt * 2))
            x = math.cos(orbitAngle) * orbitCurrentRadius
            z = math.sin(orbitAngle) * orbitCurrentRadius
            y = h
        elseif cfg.orbitMode == "Spiral Out" then
            orbitCurrentRadius = math.min(cfg.orbitDist * 2, orbitCurrentRadius + (dt * 2))
            x = math.cos(orbitAngle) * orbitCurrentRadius
            z = math.sin(orbitAngle) * orbitCurrentRadius
            y = h
        elseif cfg.orbitMode == "Bounce" then
            x = math.cos(orbitAngle) * r
            z = math.sin(orbitAngle) * r
            y = h + math.sin(orbitLocalElapsed * 3) * 5
        end

        local dst = targetPos + Vector3.new(x, y, z)
        local smooth = root.Position:Lerp(dst, cfg.orbitLerp)

        if cfg.orbitFaceTarget then
            root.CFrame = CFrame.new(smooth, Vector3.new(targetPos.X, smooth.Y, targetPos.Z))
        else
            root.CFrame = CFrame.new(smooth)
        end
    end)
end
function stopOrbit() killConn("orbit"); cfg.orbitEnabled = false end

local cfgDodge = {
    predEnabled = false,
    predRadius = 20,
    predDodgeDist = 30,
    predCooldown = 0.3,
    predThreshold = 800,
    predMult = 1,
}
local lastDodgeTick = 0

function startPrediction()
    killConn("pred")
    conns.pred = RunService.Heartbeat:Connect(function(dt)
        if not cfgDodge.predEnabled or not root then if not cfgDodge.predEnabled then killConn("pred") end return end
        if hum and hum.Health <= 0 then return end
        local myPos = root.Position
        for _, p in ipairs(Players:GetPlayers()) do
            if p == LocalPlayer or not p.Character then continue end
            local hrp = p.Character:FindFirstChild("HumanoidRootPart")
            local vel = hrp and hrp.AssemblyLinearVelocity
            if hrp and vel and vel.Magnitude > cfgDodge.predThreshold then
                local predictedPos = hrp.Position + vel * (dt * 3 * cfgDodge.predMult)
                if (predictedPos - myPos).Magnitude < cfgDodge.predRadius and tick() - lastDodgeTick > cfgDodge.predCooldown then
                    lastDodgeTick = tick()
                    local perp = Vector3.new(-vel.Z, 0, vel.X).Unit
                    local dir = math.random(0,1) == 0 and perp or -perp
                    root.CFrame = CFrame.new(myPos + dir * cfgDodge.predDodgeDist)
                    Notify("dodged " .. p.Name, 1.5)
                    break
                end
            end
        end
    end)
end
function stopPrediction() killConn("pred"); cfgDodge.predEnabled = false end

local aaSettings = { enabled = false, mode = "Spin", speed = 5000, angle = 90, randomSpeed = true, jitterPitch = true }
local aaAngleAccum, aaJitterState, aaRandomTimer, aaRandomMultiplier = 0, 0, 0, 1
function startAntiAim()
    killConn("antiAim")
    conns.antiAim = RunService.Heartbeat:Connect(function(dt)
        if not aaSettings.enabled or not root then if not aaSettings.enabled then killConn("antiAim") end return end
        local speed = aaSettings.speed
        if aaSettings.randomSpeed then
            aaRandomTimer = aaRandomTimer + dt
            if aaRandomTimer > 0.1 then aaRandomTimer = 0; aaRandomMultiplier = 0.2 + math.random()*0.8 end
            speed = speed * aaRandomMultiplier
        end
        if aaSettings.mode == "Spin" then
            aaAngleAccum = aaAngleAccum + speed*dt
            root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(aaAngleAccum), 0)
        elseif aaSettings.mode == "Jitter" then
            root.CFrame = root.CFrame * CFrame.Angles(math.rad(aaJitterState==0 and aaSettings.angle or -aaSettings.angle), math.rad(aaJitterState==0 and aaSettings.angle or -aaSettings.angle), 0)
            aaJitterState = (aaJitterState + 1) % 2
        elseif aaSettings.mode == "Static" then
            root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(aaSettings.angle), 0)
        end
    end)
end
function stopAntiAim() killConn("antiAim"); aaSettings.enabled = false end

local riotEnabled = false
local riotSpeed, riotRange, riotEvadeRange, riotTimer = 0.03, 50, 30, 0
local riotSpinSpeed = 180
local riotAngle = 0

function startRiot()
    killConn("riot")
    conns.riot = RunService.Heartbeat:Connect(function(dt)
        if not riotEnabled or not root then killConn("riot"); return end
        riotTimer = riotTimer + dt
        if riotTimer < riotSpeed then return end
        riotTimer = 0
        
        local currentPos = root.Position
        local target = getClosest()
        local newPos = currentPos

        if target and target.Character then
            local hrp = target.Character:FindFirstChild("HumanoidRootPart")
            if hrp and (currentPos - hrp.Position).Magnitude < riotEvadeRange then
                local dir = (currentPos - hrp.Position).Unit
                newPos = currentPos + dir * math.random(riotRange*0.5, riotRange*1.5)
            else
                local angle = math.random() * 2 * math.pi
                newPos = currentPos + Vector3.new(math.cos(angle)*math.random(riotRange*0.2, riotRange), math.random(-riotRange*0.5, riotRange*0.5), math.sin(angle)*math.random(riotRange*0.2, riotRange))
            end
        else
            local angle = math.random() * 2 * math.pi
            newPos = currentPos + Vector3.new(math.cos(angle)*math.random(riotRange*0.2, riotRange), math.random(-riotRange*0.5, riotRange*0.5), math.sin(angle)*math.random(riotRange*0.2, riotRange))
        end

        riotAngle = riotAngle + (riotSpinSpeed * dt)
        if riotAngle >= 360 then riotAngle = riotAngle - 360 end

        pcall(function()
            root.CFrame = CFrame.new(newPos) * CFrame.Angles(0, math.rad(riotAngle), 0)
            root.AssemblyLinearVelocity = Vector3.zero
        end)
    end)
end
function stopRiot() killConn("riot"); riotEnabled = false end

-- ========== RIOT ABUSE (3D OFFSETS) ==========
local riotAbuseEnabled = false
local riotAbuseHeight = 3      -- Up/Down from center
local riotAbuseForward = 0     -- Forward/Backward
local riotAbuseRight = 0       -- Left/Right
local riotAbuseDown = 0        -- Additional downward offset
local riotAbuseMode = "Stick"

function startRiotAbuse()
    killConn("riotAbuse")
    conns.riotAbuse = RunService.Heartbeat:Connect(function(dt)
        if not riotAbuseEnabled or not root then
            if not riotAbuseEnabled then killConn("riotAbuse") end
            return
        end
        
        local target = getClosest()
        if not target or not target.Character then return end
        local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
        if not targetRoot then return end
        
        -- Apply 3D offsets
        local offset = Vector3.new(
            riotAbuseRight,
            riotAbuseHeight - riotAbuseDown,
            riotAbuseForward
        )
        local targetPos = targetRoot.Position + offset
        
        if riotAbuseMode == "Stick" then
            root.CFrame = CFrame.new(targetPos)
        elseif riotAbuseMode == "Bounce" then
            local bounceOffset = math.abs(math.sin(tick() * 8)) * math.abs(riotAbuseHeight)
            root.CFrame = CFrame.new(targetRoot.Position + Vector3.new(
                riotAbuseRight,
                bounceOffset - riotAbuseDown,
                riotAbuseForward
            ))
        end
        
        root.AssemblyLinearVelocity = Vector3.zero
    end)
end
function stopRiotAbuse() killConn("riotAbuse"); riotAbuseEnabled = false end

local function AddBindableToggle(group, flag, text, default, callback)
    local toggle = group:AddToggle(flag, { Text = text, Default = default or false, Callback = callback })
    toggle:AddKeyPicker(flag .. 'Key', { Default = 'None', Mode = 'Toggle', Text = text, SyncToggleState = true, NoUI = false })
    return toggle
end

local Tabs = {
    VoidSpam        = Window:AddTab("VoidSpam"),
    Orbit           = Window:AddTab("Orbit"),
    Prediction      = Window:AddTab("Prediction"),
    AntiAim         = Window:AddTab("AntiAim"),
    Riot            = Window:AddTab("Riot"),
    Settings        = Window:AddTab("Settings"),
}

local VG = Tabs.VoidSpam:AddLeftGroupbox("Void Control")
AddBindableToggle(VG, "VoidToggle", "Enable Void", false, function(val) CFG.VOID_ENABLED = val; if val then startVoid() else stopVoid() end end)
VG:AddDropdown("VoidMethod", { Text = "Voidspam Methods", Default = "Quantum", Values = {"Drift", "Chaos", "Loop", "Spiral", "Quantum"}, Callback = function(v) CFG.VOID_METHOD = v end })
VG:AddSlider("Speed", { Text = "Speed (B/s)", Default = 1, Min = 1, Max = 2000, Rounding = 0, Callback = function(v) CFG.SPEED = v * 1e9 end })
VG:AddSlider("Chaos", { Text = "Chaos (%)", Default = 98, Min = 1, Max = 100, Rounding = 0, Callback = function(v) CFG.CHAOS = v * 0.01 end })
VG:AddSlider("BaseAltitude", { Text = "Base Altitude (B)", Default = 10, Min = 1, Max = 1000, Rounding = 0, Callback = function(v) CFG.BASE_ALTITUDE = v * 1e9 end })
VG:AddSlider("Radius", { Text = "Radius (B)", Default = 200, Min = 1, Max = 2000, Rounding = 0, Callback = function(v) CFG.RADIUS = v * 1e9 end })

local VG2 = Tabs.VoidSpam:AddRightGroupbox("Evasion & Advanced")
VG2:AddLabel("- evades enemys automaticly")
AddBindableToggle(VG2, "EvadeEnemies", "Evade Enemies", true, function(v) CFG.VOID_EVADE = v end)
VG2:AddSlider("EvadeRadius", { Text = "Evade Radius (B)", Default = 8, Min = 1, Max = 500, Rounding = 0, Callback = function(v) CFG.VOID_EVADE_RADIUS = v * 1e9 end })
VG2:AddSlider("EvadeSpeed", { Text = "Evade Speed (B/s)", Default = 6, Min = 1, Max = 500, Rounding = 0, Callback = function(v) CFG.VOID_EVADE_SPEED = v * 1e9 end })
VG2:AddSlider("EvadeVertical", { Text = "Evade Vertical (B)", Default = 3, Min = 1, Max = 500, Rounding = 0, Callback = function(v) CFG.VOID_EVADE_VERT = v * 1e9 end })
VG2:AddSlider("EvadeCooldown", { Text = "Evade Cooldown (x0.01s)", Default = 5, Min = 1, Max = 100, Rounding = 0, Callback = function(v) CFG.VOID_EVADE_COOLDOWN = v * 0.01 end })
VG2:AddSlider("EvadeTrigger", { Text = "Evade Trigger (%)", Default = 100, Min = 10, Max = 200, Rounding = 0, Callback = function(v) CFG.VOID_EVADE_TRIGGER = v * 0.01 end })
VG2:AddSlider("EvadeStrength", { Text = "Evade Strength (%)", Default = 100, Min = 10, Max = 300, Rounding = 0, Callback = function(v) CFG.VOID_EVADE_STRENGTH = v * 0.01 end })

local OG = Tabs.Orbit:AddLeftGroupbox("Orbit")
AddBindableToggle(OG, "OrbitToggle", "Enable Orbit", false, function(val) cfg.orbitEnabled = val; if val then startOrbit() else stopOrbit() end end)
OG:AddDropdown("OrbitMode", { Text = "Orbit Mode", Default = "Circle", Values = {"Circle", "Figure 8", "Spiral In", "Spiral Out", "Bounce"}, Callback = function(v) cfg.orbitMode = v; orbitCurrentRadius = cfg.orbitDist end })
OG:AddSlider("OrbitSpeed", { Text = "Speed (deg/s)", Default = 90, Min = 5, Max = 720, Rounding = 0, Callback = function(v) cfg.orbitSpeed = v end })
OG:AddSlider("OrbitDist", { Text = "Radius", Default = 8, Min = 1, Max = 200, Rounding = 0, Callback = function(v) cfg.orbitDist = v; orbitCurrentRadius = v end })
OG:AddSlider("OrbitHeight", { Text = "Height Offset", Default = 0, Min = -200, Max = 200, Rounding = 0, Callback = function(v) cfg.orbitHeight = v end })
OG:AddSlider("OrbitLerp", { Text = "Smoothing", Default = 30, Min = 1, Max = 100, Rounding = 0, Callback = function(v) cfg.orbitLerp = v / 100 end })

local OG2 = Tabs.Orbit:AddRightGroupbox("Advanced")
OG2:AddLabel("- auto targets closest player")
AddBindableToggle(OG2, "OrbitFaceTarget", "Face Target", true, function(v) cfg.orbitFaceTarget = v end)
AddBindableToggle(OG2, "OrbitPredict", "Enable Prediction", false, function(v) cfg.orbitPredict = v end)
OG2:AddSlider("OrbitPredStrength", { Text = "Prediction Strength", Default = 20, Min = 0, Max = 100, Rounding = 0, Suffix = "%", Callback = function(v) cfg.orbitPredStrength = v / 100 end })
OG2:AddSlider("OrbitAutoLockDist", { Text = "Max Auto-Lock Dist", Default = 50, Min = 10, Max = 500, Rounding = 0, Callback = function(v) cfg.orbitAutoLockDist = v end })

local PG = Tabs.Prediction:AddLeftGroupbox("Prediction Dodge")
AddBindableToggle(PG, "PredToggle", "Enable Prediction", false, function(val) cfgDodge.predEnabled = val; if val then startPrediction() else stopPrediction() end end)
PG:AddSlider("PredRadius", { Text = "Danger Radius", Default = 20, Min = 5, Max = 100, Rounding = 0, Callback = function(v) cfgDodge.predRadius = v end })
PG:AddSlider("PredDodge", { Text = "Dodge Distance", Default = 30, Min = 5, Max = 150, Rounding = 0, Callback = function(v) cfgDodge.predDodgeDist = v end })
PG:AddSlider("PredCooldown", { Text = "Cooldown (ms)", Default = 300, Min = 50, Max = 2000, Rounding = 0, Callback = function(v) cfgDodge.predCooldown = v / 1000 end })
PG:AddSlider("PredThreshold", { Text = "Speed Threshold", Default = 800, Min = 200, Max = 5000, Rounding = 0, Callback = function(v) cfgDodge.predThreshold = v end })
PG:AddSlider("PredMult", { Text = "Mega Prediction Mult.", Default = 1, Min = 0.5, Max = 10, Rounding = 1, Suffix = "x", Callback = function(v) cfgDodge.predMult = v end })
local PG2 = Tabs.Prediction:AddRightGroupbox("Settings")
PG2:AddLabel("- dodges incomin void spammers")

local AG = Tabs.AntiAim:AddLeftGroupbox("Extreme Anti-Aim")
AddBindableToggle(AG, "AaToggle", "Enable Anti-Aim", false, function(val) aaSettings.enabled = val; if val then startAntiAim() else stopAntiAim() end end)
AG:AddDropdown("AaMode", { Text = "Mode", Default = "Spin", Values = {"Spin", "Jitter", "Static"}, Callback = function(v) aaSettings.mode = v end })
AG:AddSlider("AaSpeed", { Text = "Speed (deg/s)", Default = 5000, Min = 100, Max = 5000, Rounding = 0, Callback = function(v) aaSettings.speed = v end })
AG:AddSlider("AaAngle", { Text = "Jitter/Static Angle", Default = 90, Min = 10, Max = 180, Rounding = 0, Callback = function(v) aaSettings.angle = v end })
AddBindableToggle(AG, "AaRandomSpeed", "Randomize Speed", true, function(v) aaSettings.randomSpeed = v end)
AddBindableToggle(AG, "AaJitterPitch", "Jitter Pitch (2D)", true, function(v) aaSettings.jitterPitch = v end)
local AG2 = Tabs.AntiAim:AddRightGroupbox("Info")
AG2:AddLabel("- spin: rotats 360")
AG2:AddLabel("- jitter: alternats pitch + yaw")
AG2:AddLabel("- static: locks rotation")
AG2:AddLabel("- max speed: 5000 deg/s")

-- ========== RIOT TAB (WITH NEW 3D RIOT ABUSE) ==========
local GG = Tabs.Riot:AddLeftGroupbox("Riot – Godmode")
AddBindableToggle(GG, "RiotToggle", "Enable Riot (Godmode)", false, function(val) riotEnabled = val; if val then startRiot() else stopRiot() end end)
GG:AddSlider("RiotSpeed", { Text = "Teleport Delay (sec)", Default = 0.03, Min = 0.01, Max = 0.5, Rounding = 2, Callback = function(v) riotSpeed = v end })
GG:AddSlider("RiotRange", { Text = "Jump Range (studs)", Default = 50, Min = 10, Max = 200, Rounding = 0, Callback = function(v) riotRange = v end })
GG:AddSlider("RiotEvadeRange", { Text = "Evade Trigger (studs)", Default = 30, Min = 0, Max = 100, Rounding = 0, Callback = function(v) riotEvadeRange = v end })
GG:AddSlider("RiotSpinSpeed", { Text = "Spin Speed (deg/s)", Default = 180, Min = 0, Max = 720, Rounding = 0, Callback = function(v) riotSpinSpeed = v end })

local GG2 = Tabs.Riot:AddRightGroupbox("Info")
GG2:AddLabel("- erratic tp spam")
GG2:AddLabel("- auto evades close enemys")
GG2:AddLabel("- spins 360 during teleports")

-- ========== NEW: 3D RIOT ABUSE ==========
local RA = Tabs.Riot:AddLeftGroupbox("Riot Abuse")
AddBindableToggle(RA, "RiotAbuseToggle", "Enable Riot Abuse", false, function(val) 
    riotAbuseEnabled = val
    if val then 
        startRiotAbuse()
        Notify("Riot Abuse enabled", 2) 
    else 
        stopRiotAbuse()
        Notify("Riot Abuse disabled", 2)
    end
end)
RA:AddDropdown("RiotAbuseMode", { 
    Text = "Abuse Mode", 
    Default = "Stick", 
    Values = {"Stick", "Bounce"}, 
    Callback = function(v) riotAbuseMode = v end
})
RA:AddSlider("RiotAbuseHeight", { 
    Text = "Height Offset", 
    Default = 3, 
    Min = -50, 
    Max = 50, 
    Rounding = 1, 
    Suffix = "m", 
    Callback = function(v) riotAbuseHeight = v end
})
RA:AddSlider("RiotAbuseForward", { 
    Text = "Forward Offset", 
    Default = 0, 
    Min = -50, 
    Max = 50, 
    Rounding = 1, 
    Suffix = "m", 
    Callback = function(v) riotAbuseForward = v end
})
RA:AddSlider("RiotAbuseRight", { 
    Text = "Right Offset", 
    Default = 0, 
    Min = -50, 
    Max = 50, 
    Rounding = 1, 
    Suffix = "m", 
    Callback = function(v) riotAbuseRight = v end
})
RA:AddSlider("RiotAbuseDown", { 
    Text = "Down Offset", 
    Default = 0, 
    Min = 0, 
    Max = 50, 
    Rounding = 1, 
    Suffix = "m", 
    Callback = function(v) riotAbuseDown = v end
})

-- ========== SETTINGS TAB ==========
local Menu = Tabs.Settings:AddLeftGroupbox("Menu")
Menu:AddToggle("KeybindMenu", { Text = "Keybind Menu", Default = false, Callback = function(Value) pcall(function() if Library.KeybindFrame then Library.KeybindFrame.Visible = Value end end) end })

local UI = Tabs.Settings:AddLeftGroupbox("UI")
UI:AddLabel("Menu Keybind"):AddKeyPicker("MenuKeybind", { Default = 'RightShift', Text = 'Menu Keybind', Mode = 'Toggle', NoUI = false })
Library.ToggleKeybind = Options.MenuKeybind

local autoLoadEnabled = true
UI:AddToggle("AutoLoad", { Text = "Auto Load Config", Default = true, Callback = function(val) autoLoadEnabled = val end })

UI:AddButton("Unload Script", function() Library:Unload() end)

local ThemeManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/main/addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/main/addons/SaveManager.lua"))()
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({'MenuKeybind'})
ThemeManager:SetFolder('LuaXPaid')
SaveManager:SetFolder('LuaXPaid/configs')
SaveManager:BuildConfigSection(Tabs.Settings)
ThemeManager:ApplyToTab(Tabs.Settings)

if autoLoadEnabled then pcall(function() SaveManager:LoadAutoloadConfig() end) end

-- 🔥 FINAL BOOT MESSAGE 🔥
Library:Notify({ Title = "Keyper x Paid", Description = "Made by Keyper", Time = 4 })