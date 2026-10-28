local function newLatencyTracker(poll)

    local self = {}

    function self:Reset()

        self.Seconds, self.SampleAt = nil, nil

        self.PollAt, self.Source = -math.huge, "Unavailable"

        self.Samples, self.OneWay, self.Jitter = {}, nil, 0

        self.Frame, self.NextAdaptiveSample = 0.0167, 0

    end

    local function valid(value, limit)

        return type(value) == "number" and value == value and value >= 0 and value <= limit

    end

    local function median(values)

        local copy = table.clone(values)

        table.sort(copy)

        return copy[math.floor((#copy + 1) / 2)]

    end

    function self:UpdateFrame(dt)

        if valid(dt, 0.1) and dt > 0 then

            self.Frame = self.Frame * 0.85 + math.min(dt, 0.025) * 0.15

        end

    end

    function self:Step(now, replicatedRTT, adaptive)

        if adaptive then

            local sampleNow = os.clock()

            if sampleNow >= self.NextAdaptiveSample then

                self.NextAdaptiveSample = sampleNow + 0.25

                local ok, value = false, nil

                if type(poll) == "function" then ok, value = pcall(poll) end

                if not ok or not valid(value, 0.35) then

                    -- PerformanceStats.Ping is a one-way millisecond value.
                    -- Do not use Data Ping RTT here because render/load spikes can pollute timing.
                    local stats = game:GetService("Stats")

                    local fallback, ms = pcall(function() return stats.PerformanceStats.Ping:GetValue() end)

                    value = if fallback and valid(ms, 350) then ms / 1000 else nil

                    self.Source = if value ~= nil then "Performance Ping fallback" else "latency unavailable"

                else

                    self.Source = "GetNetworkPing one-way"

                end

                if value ~= nil then

                    self.Samples[#self.Samples + 1] = value

                    if #self.Samples > 9 then table.remove(self.Samples, 1) end

                    local filtered = median(self.Samples)

                    if self.OneWay == nil then

                        self.OneWay = filtered

                    else

                        local delta = math.clamp(filtered - self.OneWay, -0.012, 0.012)

                        self.OneWay = math.clamp(self.OneWay + delta * 0.35, 0, 0.35)

                    end

                    local deviations = {}

                    for _, sample in ipairs(self.Samples) do

                        deviations[#deviations + 1] = math.abs(sample - filtered)

                    end

                    self.Jitter = math.clamp(median(deviations) * 1.5, 0, 0.02)

                    self.SampleAt = sampleNow

                    self.Seconds = self.OneWay

                end

            end

            if self.OneWay and self.SampleAt and os.clock() - self.SampleAt <= 2 then

                -- Estimate round-trip reaction time once, with bounded jitter/frame slack.

                return math.clamp(self.OneWay * 2 + self.Jitter + math.clamp(self.Frame, 0, 0.025), 0, 0.7)

            end

            return nil

        end

        if now < self.PollAt then self:Reset() end

        if now - self.PollAt >= 0.5 then

            self.PollAt = now

            local ok, value = false, nil

            if type(poll) == "function" then ok, value = pcall(poll) end

            local source = "Network"

            if not ok or not valid(value, 2) then

                value = if valid(replicatedRTT, 4000) then replicatedRTT / 2000 else nil

                source = "Game fallback"

            end

            if value ~= nil then

                if self.SampleAt == nil or now - self.SampleAt > 3 then

                    self.Seconds = value

                else

                    self.Seconds += (value - self.Seconds) * 0.25

                end

                self.SampleAt, self.Source = now, source

            end

        end

        if self.SampleAt and now - self.SampleAt > 3 then

            self.Seconds, self.SampleAt, self.Source = nil, nil, "Unavailable"

        end

        return self.Seconds

    end

    self:Reset()

    return self

end

local function newController(adapter, settings)

    local latency = newLatencyTracker(adapter.NetworkPing)

    local self = {

        Alive = true, Settings = settings, Threats = {}, Attempt = nil, Counter = nil,

        LastWindow = 0, LastSuccess = 0, LastSend = -math.huge, LastDash = -math.huge, LastBlock = -math.huge, Generation = 0,

        LastWeaveTry = -math.huge, Missed = 0,

        Status = "Ready", Weaves = 0, Counters = 0, Latency = latency, PingLead = 0,

    }

    local function number(value, fallback)

        return if type(value) == "number" and value == value and math.abs(value) < math.huge then value else fallback

    end

    local function active(data, field, now)

        return number(data[field], 0) > now

    end

    local function gate(data, now, action)

        if not data or not data.Alive or data.Sitting or data.Restricted or data.InSafeZone then return false end

        if data.Stance == nil or data.Stance == "" or data.ActionLock or data.Downed

            or data.BeingCarried or data.IsCarrying or data.IsBlocking then return false end

        for _, field in ipairs({"ActionLockAfter", "HardStun", "FullStun", "SoftStun", "Ragdoll"}) do

            if active(data, field, now) then return false end

        end

        if action == "Weave" then

            return data.StanceHasWeave == true and not active(data, "WeaveCooldownUntil", now)

                and not active(data, "WeaveWindow", now) and not active(data, "WeaveState", now)

        end

        return data.StanceHasCritical == true and not active(data, "CriticalCooldownUntil", now)

            and not active(data, "CriticalEndlagAfter", now)

    end

    function self:Reset(data)

        table.clear(self.Threats)

        latency:Reset()

        self.PingLead = 0

        self.Attempt, self.Counter = nil, nil

        self.Generation += 1

        self.LastWindow = number(data and data.WeaveWindow, 0)

        self.LastSuccess = number(data and data.WeaveState, 0)

    end

    function self:Set(name, value)

        if self.Settings[name] == value then return end

        self.Settings[name] = value

        if name == "AutoWeave" and not value then self.Attempt = nil end

        if name == "AutoHeavy" and not value then self.Counter = nil end

        if not self.Settings.AutoWeave and not self.Settings.AutoHeavy then

            table.clear(self.Threats)

            self.Attempt, self.Counter = nil, nil

        end

    end

    function self:Observe(key, target, attack)

        if not self.Alive or not (settings.AutoWeave or settings.AutoHeavy or settings.DashFallback or settings.AutoBlockSideAttacks) then return end

        self.Threats[key] = {Target = target, Attack = attack, Consumed = false, Seen = adapter.Now()}

    end

    function self:Forget(target)

        for key, threat in pairs(self.Threats) do

            if threat.Target == target then self.Threats[key] = nil end

        end

        if self.Attempt and self.Attempt.Target == target then self.Attempt = nil end

        if self.Counter and self.Counter.Target == target then self.Counter = nil end

    end

    function self:Stop()

        self.Alive = false

        self:Reset(nil)

        self.Status = "Stopped"

    end

    function self:Step()

        if not self.Alive then return end

        local data, now = adapter.State(), adapter.Now()

        if not data then self:Reset(nil); self.Status = "Waiting for character state"; return end

        local success = number(data.WeaveState, 0)

        local window = number(data.WeaveWindow, 0)

        local best, bestETA
        local sideBest, sideBestETA

        local ping = latency:Step(now, data.ReadPing, settings.AdaptivePing == true)

        local limit = math.clamp(number(settings.MaxPingLeadMs, 100), 0, 100) / 1000

        local windowLimit = math.clamp(number(data.WeaveDuration, 0.2), 0, 0.2) / 2

        local lead = if settings.AdaptivePing == true or settings.PingCompensation ~= false then math.min(ping or 0, limit, windowLimit) else 0

        self.PingLead = lead

        for key, threat in pairs(self.Threats) do

            local info = adapter.Threat(key, threat.Target, threat.Attack)

            if not info or not info.Playing or now - threat.Seen > 4 then

                self.Threats[key] = nil

            -- Only react when the attacker is actually facing the player and is
            -- inside the tighter estimated strike range. The larger Detection Range
            -- remains for the visual/scan area; it no longer triggers weaves by itself.
            elseif not threat.Consumed and info.Speed > 0

                and info.Distance <= math.min(settings.Range, number(settings.HitRange, 4.5))

                and info.Vertical <= 6 and info.Visible then

                local onset = if threat.Attack.Heavy then settings.HeavyDelay else settings.LightDelay
                local rawETA = (onset - info.Position) / info.Speed
                local eta = rawETA - lead

                -- Do not require the attacker to face the local character: wide/side
                -- hitboxes can still connect. A stopped/cancelled animation is removed
                -- above before it can trigger. Only keep attacks whose estimated strike
                -- time is close enough to be a credible hit, reducing feint reactions.
                if rawETA >= -0.08 and rawETA <= 0.32 then
                    if not bestETA or eta < bestETA then
                        best, bestETA = threat, eta
                    end
                    if (not info.Facing or not adapter.FrontFacing(threat.Target))
                        and (not sideBestETA or eta < sideBestETA) then
                        sideBest, sideBestETA = threat, eta
                    end
                end

            end

        end

        if window > self.LastWindow and window > now and best then

            self.Attempt = {Target = best.Target, Expires = now + 0.8, Generation = self.Generation}

        end

        if success > self.LastSuccess and success > now - 0.15 and window == 0 then

            local attempt = self.Attempt

            self.Attempt = nil

            if settings.AutoHeavy and attempt and attempt.Expires >= now and attempt.Generation == self.Generation then

                self.Counter = {Target = attempt.Target, Expires = now + 0.65, Generation = self.Generation}

                self.Status = "Weave confirmed; waiting for counter opening"

            end

        end

        self.LastSuccess, self.LastWindow = success, window

        if self.Attempt and (now > self.Attempt.Expires or not data.Alive) then self.Attempt = nil end

        if self.Attempt and self.Attempt.Requested and now >= self.Attempt.RetryAt

            and window <= self.LastWindow and not active(data, "WeaveWindow", now)

            and not active(data, "WeaveState", now) then

            self.Attempt = nil

        end

        local counter = self.Counter

        if counter then

            if not settings.AutoHeavy or now > counter.Expires or counter.Generation ~= self.Generation or not data.Alive then

                self.Counter = nil

            elseif data.Style ~= "Boxing" and data.Style ~= "Destroyer" then

                self.Counter = nil

                self.Status = "Auto Heavy requires Boxing or Destroyer"

            elseif gate(data, now, "Critical") then

                local target = adapter.CounterTarget(counter.Target)

                if not target or target.Distance > settings.CounterRange or target.Vertical > 5

                    or not target.Facing or not target.Visible then

                    self.Counter = nil

                    self.Status = "Counter cancelled: target out of reach"

                elseif now - self.LastSend >= 0.12 then

                    self.Counter = nil

                    self.LastSend = now

                    local sent, sendErr = pcall(adapter.Send, "Critical")

                    if not sent then

                        self.Status = "Counter send failed: " .. tostring(sendErr)

                        return

                    end

                    self.Counters += 1

                    self.Status = "Heavy counter requested"

                    return

                end

            end

        end

        -- Behavior requested: an incoming attacker inside the front cone can be weaved;
        -- an incoming attacker outside the front cone is blocked with F instead.
        -- Handle the side threat first so it never falls through to the weave branch.
        if settings.AutoBlockSideAttacks and (not settings.AutoWeave or not best) and sideBest and sideBestETA <= 0
            and sideBestETA >= -0.12 and now - self.LastBlock >= 0.22
            and data.Alive and not data.Downed and not data.ActionLock and not data.IsBlocking then
            self.LastBlock = now
            sideBest.Consumed = true
            pcall(function() game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.F, false, game) end)
            task.delay(0.18, function()
                pcall(function() game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.F, false, game) end)
            end)
            self.Status = "Side attack detected: blocking with F"
            return
        end

        if settings.AutoWeave and not self.Attempt and best and bestETA <= 0 and gate(data, now, "Weave")

            and bestETA >= -0.16 and now - self.LastWeaveTry >= 0.095 then

            self.Attempt = {Target = best.Target, Expires = now + 0.8,

                RetryAt = now + 0.16, Requested = true, Generation = self.Generation}

            self.LastWeaveTry = now

            self.LastSend = now

            if settings.FaceAttacker then pcall(adapter.FaceTarget, best.Target) end

            local sent, sendErr = pcall(adapter.Send, "Weave", adapter.Direction())

            if not sent then

                self.Attempt = nil

                self.Status = "Weave send failed: " .. tostring(sendErr)

                return

            end

            self.Weaves += 1

            self.Status = "Weave requested (awaiting confirmation)"

        elseif settings.AutoWeave and settings.DashFallback and best and bestETA <= 0 and bestETA >= -0.16

            and active(data, "WeaveCooldownUntil", now) and data.Alive

            and not data.Sitting and not data.Restricted and not data.InSafeZone

            and not data.Downed and not data.ActionLock and not data.IsBlocking

            and now - self.LastDash >= 0.85 and now - self.LastSend >= 0.12 then

            local ok, didDash = pcall(adapter.DashBackward)

            if ok and didDash then

                best.Consumed = true

                self.LastDash, self.LastSend = now, now

                self.Status = "Q backward dash requested (weave cooldown)"

            elseif not ok then

                self.Status = "Dash failed: " .. tostring(didDash)

            end

        elseif not settings.AutoWeave and not settings.AutoHeavy then

            self.Status = "Ready (automation off)"

        elseif not data.Alive then

            self.Status = "Waiting for respawn"

        elseif data.Stance == "" then

            self.Status = "Enter combat stance"

        end

    end

    self:Reset(adapter.State())

    return self

end

if game.GameId ~= 10414383300 then

    warn("Larpshin only runs in Ishin")

    return

end

if not game:IsLoaded() then game.Loaded:Wait() end

local env = (type(getgenv) == "function" and getgenv()) or _G

local previous = env.__Larpshin

if type(previous) == "table" and type(previous.Stop) == "function" then previous:Stop() end

local app = {Alive = true, Connections = {}, Characters = {}, Version = "0.1.1"}

env.__Larpshin = app

local Rere, controller

local function disconnect(connection)

    if type(connection) == "function" then pcall(connection)

    elseif connection then pcall(function() connection:Disconnect() end) end

end

function app:Stop()

    if not self.Alive then return end

    self.Alive = false

    if controller then controller:Stop() end

    for _, record in pairs(self.Characters) do

        for _, c in ipairs(record.Connections) do disconnect(c) end

    end

    table.clear(self.Characters)

    for _, c in ipairs(self.Connections) do disconnect(c) end

    table.clear(self.Connections)

    if Rere then pcall(Rere.Shutdown) end

    if env.__Larpshin == self then env.__Larpshin = nil end

end

local function own(signal, callback, list)

    local c = signal:Connect(function(...)

        if not app.Alive then return end

        local ok, err = pcall(callback, ...)

        if not ok then app:Stop(); warn("Larpshin stopped: " .. tostring(err)) end

    end)

    table.insert(list or app.Connections, c)

    return c

end

local function start()

    local Players = game:GetService("Players")

    local RunService = game:GetService("RunService")

    local Workspace = game:GetService("Workspace")

    local player = Players.LocalPlayer

    assert(player, "LocalPlayer not ready")

    assert(type(loadstring) == "function", "loadstring unavailable")

    assert(type(filtergc) == "function" and type(debug.getupvalues) == "function",

        "Larpshin requires filtergc and debug.getupvalues for Ishin's native combat adapter")

    local fn = filtergc("function", {Name = "TryBlock", Constants = {"Weave"}}, true)

    assert(type(fn) == "function", "Ishin combat has not loaded; enter the game first")

    local registry

    for _, v in ipairs(debug.getupvalues(fn)) do

        if type(v) == "table" and rawget(v, "__deps__") then registry = v; break end

    end

    assert(registry and type(registry.get) == "function", "Ishin combat registry unavailable")

    local remote = registry:lazyGetStorage()["Remote.Combat"]

    local clock = registry:get("GetTick")

    assert(remote and type(remote.FireServer) == "function" and type(clock) == "function", "Native combat adapter unavailable")

    local state = registry:get("player-state-replica")

    local main = registry:get("main-data-replica")

    local characterConfig = registry:get("CharacterConfig")

    local controls = registry:get("ControlTable")

    local settings = {AutoWeave = false, AutoHeavy = false, AutoWorkEnabled = false, Range = 8, HitRange = 4.5, CounterRange = 7,

        LightDelay = 0.10, HeavyDelay = 0.28, PingCompensation = true, AdaptivePing = false, MaxPingLeadMs = 100,

        FaceAttacker = true, FrontAttacksOnly = false, FrontConeAngle = 50, AutoBlockSideAttacks = true, CFrameSpeed = 0, CFrameMovementEnabled = false, NoClipEnabled = false, FlyEnabled = false, FlySpeed = 60, NameESPEnabled = false, ESPDistance = true, ESP2DBoxEnabled = false, ESP3DBoxEnabled = false, ESPMaxDistance = 1000, ShowRadius = true, DashFallback = false, AutoRun = false, FakeKendo = false}

    app.Settings = settings
    local autoWorkRunning = false
    local autoWorkGeneration = 0
    local autoWorkStatus = "Off"

    local virtualInput = game:GetService("VirtualInputManager")

    local inputService = game:GetService("UserInputService")

    local shiftHeld = false

    local lastStance = nil

    local lastMoving = false

    local function setAutoRunHeld(wanted)

        if shiftHeld == wanted then return end

        local ok = pcall(function()

            virtualInput:SendKeyEvent(wanted, Enum.KeyCode.LeftShift, false, game)

        end)

        if ok then shiftHeld = wanted end

    end

    local function restartSprint()

        if not settings.AutoRun then return end

        setAutoRunHeld(false)

        setAutoRunHeld(true)

    end

    table.insert(app.Connections, function() setAutoRunHeld(false) end)

    -- Fly toggle: camera-relative flight using temporary movers, cleaned up on disable/stop.
    local flyVelocity, flyGyro = nil, nil
    local function stopFly()
        if flyVelocity then pcall(function() flyVelocity:Destroy() end); flyVelocity = nil end
        if flyGyro then pcall(function() flyGyro:Destroy() end); flyGyro = nil end
    end
    local function startFly()
        stopFly()
        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum or hum.Health <= 0 then return end
        flyVelocity = Instance.new("BodyVelocity")
        flyVelocity.Name = "LarpshinFlyVelocity"
        flyVelocity.MaxForce = Vector3.new(1e6, 1e6, 1e6)
        flyVelocity.Velocity = Vector3.zero
        flyVelocity.Parent = hrp
        flyGyro = Instance.new("BodyGyro")
        flyGyro.Name = "LarpshinFlyGyro"
        flyGyro.MaxTorque = Vector3.new(1e6, 1e6, 1e6)
        flyGyro.P = 1e4
        flyGyro.CFrame = Workspace.CurrentCamera.CFrame
        flyGyro.Parent = hrp
        hum.PlatformStand = false
    end
    table.insert(app.Connections, stopFly)
    own(RunService.Heartbeat, function()
        if not settings.FlyEnabled then if flyVelocity or flyGyro then stopFly() end; return end
        if not flyVelocity or not flyGyro or not flyVelocity.Parent or not flyGyro.Parent then startFly() end
        if not flyVelocity or not flyGyro then return end
        local cam = Workspace.CurrentCamera
        if not cam then return end
        local move = Vector3.zero
        if inputService:IsKeyDown(Enum.KeyCode.W) then move += cam.CFrame.LookVector end
        if inputService:IsKeyDown(Enum.KeyCode.S) then move -= cam.CFrame.LookVector end
        if inputService:IsKeyDown(Enum.KeyCode.D) then move += cam.CFrame.RightVector end
        if inputService:IsKeyDown(Enum.KeyCode.A) then move -= cam.CFrame.RightVector end
        if inputService:IsKeyDown(Enum.KeyCode.Space) then move += Vector3.yAxis end
        if inputService:IsKeyDown(Enum.KeyCode.LeftControl) then move -= Vector3.yAxis end
        local speed = math.clamp(tonumber(settings.FlySpeed) or 60, 10, 150)
        flyVelocity.Velocity = move.Magnitude > 0 and move.Unit * speed or Vector3.zero
        flyGyro.CFrame = cam.CFrame
    end)

    -- ESP: optional head labels and unfilled 2D/3D outline boxes.
    local espObjects = {}
    local ESP_COLOR = Color3.fromRGB(80, 235, 255)
    local function clearESPPlayer(plr)
        local record = espObjects[plr]
        if not record then return end
        if record.gui then pcall(function() record.gui:Destroy() end) end
        if record.screenGui then pcall(function() record.screenGui:Destroy() end) end
        if record.box3d then pcall(function() record.box3d:Destroy() end) end
        espObjects[plr] = nil
    end
    local function clearNameESP()
        for plr in pairs(espObjects) do clearESPPlayer(plr) end
    end
    local function make2DBox(plr, record)
        if not settings.ESP2DBoxEnabled then return end
        local gui = Instance.new("ScreenGui")
        gui.Name = "LarpshinESP2D"; gui.ResetOnSpawn = false; gui.IgnoreGuiInset = true
        gui.DisplayOrder = 20; gui.Parent = player:WaitForChild("PlayerGui")
        record.screenGui = gui
        record.edges = {}
        for i = 1, 4 do
            local edge = Instance.new("Frame")
            edge.Name = "BoxEdge"; edge.BorderSizePixel = 0; edge.BackgroundColor3 = ESP_COLOR
            edge.BackgroundTransparency = 0; edge.Size = UDim2.fromOffset(2, 2); edge.Visible = false; edge.Parent = gui
            record.edges[i] = edge
        end
    end
    local function refreshNameESP()
        settings.ESP2DBoxEnabled = false
        settings.ESP3DBoxEnabled = false
        clearNameESP()
        if not settings.NameESPEnabled
            and not settings.ESP2DBoxEnabled and not settings.ESP3DBoxEnabled then return end
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= player then
                local char = plr.Character
                local head = char and char:FindFirstChild("Head")
                if head then
                    local record = {}
                    if settings.NameESPEnabled then
                        local gui = Instance.new("BillboardGui")
                        gui.Name = "LarpshinPlayerESP"; gui.Adornee = head; gui.Size = UDim2.fromOffset(130, 22)
                        gui.StudsOffset = Vector3.new(0, 2.5, 0); gui.AlwaysOnTop = true
                        gui.MaxDistance = math.clamp(tonumber(settings.ESPMaxDistance) or 1000, 50, 3000)
                        gui.Parent = player:WaitForChild("PlayerGui")
                        local label = Instance.new("TextLabel")
                        label.Name = "PlayerNameText"; label.BackgroundTransparency = 1; label.Size = UDim2.fromScale(1, 1)
                        label.Text = tostring(plr.DisplayName or plr.Name)
                        label.TextColor3 = ESP_COLOR; label.TextStrokeTransparency = 0.2
                        label.TextScaled = false; label.TextSize = 11; label.TextWrapped = false
                        label.Font = Enum.Font.GothamBold; label.Parent = gui
                        record.gui = gui; record.label = label
                    end
                    if settings.ESP3DBoxEnabled then
                        local adorn = Instance.new("BoxHandleAdornment")
                        adorn.Name = "LarpshinESP3DBox"
                        adorn.Adornee = char:FindFirstChild("HumanoidRootPart")
                        adorn.Color3 = ESP_COLOR
                        adorn.Transparency = 0
                        adorn.SurfaceTransparency = 1
                        adorn.AlwaysOnTop = true
                        adorn.ZIndex = 5
                        adorn.Size = Vector3.new(4, 6, 2)
                        adorn.Visible = false
                        adorn.Parent = Workspace
                        record.box3d = adorn
                    end
                    make2DBox(plr, record)
                    espObjects[plr] = record
                end
            end
        end
    end
    table.insert(app.Connections, clearNameESP)
    local espUpdateAccumulator = 0
    own(RunService.Heartbeat, function(dt)
        espUpdateAccumulator += dt
        if espUpdateAccumulator < 1 / 15 then return end
        espUpdateAccumulator = 0
        settings.ESP2DBoxEnabled = false
        settings.ESP3DBoxEnabled = false
        if not settings.NameESPEnabled
            and not settings.ESP2DBoxEnabled and not settings.ESP3DBoxEnabled then
            if next(espObjects) then clearNameESP() end
            return
        end
        local cameraNow = Workspace.CurrentCamera
        local myChar = player.Character
        local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
        local maxDistance = math.clamp(tonumber(settings.ESPMaxDistance) or 1000, 50, 3000)
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= player then
                local rec = espObjects[plr]
                local char = plr.Character
                local head = char and char:FindFirstChild("Head")
                if not rec or (rec.gui and not rec.gui.Parent)
                    or (rec.gui and head and rec.gui.Adornee ~= head)
                    or (rec.screenGui and not rec.screenGui.Parent) then
                    refreshNameESP()
                    break
                end
                if rec and char and head then
                    local rootPart = char:FindFirstChild("HumanoidRootPart")
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    local distance = rootPart and myRoot and (rootPart.Position - myRoot.Position).Magnitude
                    local inRange = not distance or distance <= maxDistance
                    if rec.label then
                        rec.label.Text = tostring(plr.DisplayName or plr.Name) ..
                            (settings.ESPDistance and distance and ("\n" .. math.floor(distance) .. " studs") or "")
                        rec.gui.Enabled = inRange
                    end
                    local bboxOk, bboxCF, bboxSize = false, nil, nil
                    if char then
                        bboxOk, bboxCF, bboxSize = pcall(function() return char:GetBoundingBox() end)
                    end
                    if rec.box3d then
                        local boxVisible = inRange and hum ~= nil and hum.Health > 0 and rootPart ~= nil and bboxOk
                        rec.box3d.Adornee = rootPart
                        if boxVisible then
                            rec.box3d.Size = bboxSize
                            rec.box3d.CFrame = rootPart.CFrame:ToObjectSpace(bboxCF)
                        end
                        rec.box3d.Visible = boxVisible
                    end
                    if rec.edges and cameraNow and rootPart and head and hum then
                        local visible = inRange and hum.Health > 0
                        local headPoint, headOnScreen = cameraNow:WorldToViewportPoint(head.Position + Vector3.new(0, head.Size.Y * 0.5, 0))
                        local rootPoint, rootOnScreen = cameraNow:WorldToViewportPoint(rootPart.Position)
                        visible = visible and headPoint.Z > 0 and rootPoint.Z > 0
                        local viewportSize = cameraNow.ViewportSize
                        if visible then
                            local boxHeight = math.max(8, math.abs(rootPoint.Y - headPoint.Y) * 2.15)
                            local boxWidth = math.max(6, boxHeight * 0.48)
                            local x = headPoint.X - boxWidth * 0.5
                            local y = headPoint.Y - boxHeight * 0.12
                            visible = x + boxWidth > 0 and y + boxHeight > 0
                                and x < viewportSize.X and y < viewportSize.Y
                            for _, edge in ipairs(rec.edges) do edge.Visible = visible end
                            if visible then
                                local edges = rec.edges
                                edges[1].Position = UDim2.fromOffset(x, y); edges[1].Size = UDim2.fromOffset(boxWidth, 1)
                                edges[2].Position = UDim2.fromOffset(x, y + boxHeight); edges[2].Size = UDim2.fromOffset(boxWidth, 1)
                                edges[3].Position = UDim2.fromOffset(x, y); edges[3].Size = UDim2.fromOffset(1, boxHeight)
                                edges[4].Position = UDim2.fromOffset(x + boxWidth, y); edges[4].Size = UDim2.fromOffset(1, boxHeight)
                            end
                        else
                            for _, edge in ipairs(rec.edges) do edge.Visible = false end
                        end
                    end
                end
            end
        end
    end)
    own(Players.PlayerRemoving, function(plr) clearESPPlayer(plr) end)

    -- Auto Work: walk directly to each configured position and retry every second.
    local autoWorkSpots = {
        Vector3.new(196.724, -9.978, 59.735),
        Vector3.new(192.958, -10.298, 59.999),
        Vector3.new(180.749, -10.618, 60.737),
        Vector3.new(148.411, -10.618, 60.206),
        Vector3.new(141.675, -8.597, 62.425),
        Vector3.new(141.254, -8.299, 68.190),
        Vector3.new(141.001, -8.717, 87.302)
    }

    local function stopAutoWork()
        autoWorkRunning = false
        autoWorkGeneration += 1
        settings.AutoWorkEnabled = false
        autoWorkStatus = "Off"
        local character = player.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        local rootPart = character and character:FindFirstChild("HumanoidRootPart")
        if humanoid and rootPart then humanoid:MoveTo(rootPart.Position) end
    end

    table.insert(app.Connections, function()
        autoWorkRunning = false
        autoWorkGeneration += 1
    end)

    local function startAutoWork()
        if autoWorkRunning then return end
        autoWorkRunning = true
        settings.AutoWorkEnabled = true
        autoWorkGeneration += 1
        local myGeneration = autoWorkGeneration
        autoWorkStatus = "Starting"

        task.spawn(function()
            while app.Alive and autoWorkRunning and autoWorkGeneration == myGeneration do
                for index, position in ipairs(autoWorkSpots) do
                    if not (app.Alive and autoWorkRunning and autoWorkGeneration == myGeneration) then
                        break
                    end

                    local arrived = false
                    while app.Alive and autoWorkRunning and autoWorkGeneration == myGeneration do
                        local character = player.Character
                        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
                        local rootPart = character and character:FindFirstChild("HumanoidRootPart")

                        if humanoid and rootPart and humanoid.Health > 0 then
                            if (rootPart.Position - position).Magnitude <= 3 then
                                arrived = true
                                break
                            end

                            autoWorkStatus = string.format("Walking to point %d/%d (retrying)", index, #autoWorkSpots)
                            pcall(function() humanoid:MoveTo(position) end)
                        else
                            autoWorkStatus = "Waiting for character"
                        end

                        -- Reissue MoveTo once per second until this point is reached.
                        task.wait(1)
                    end

                    if not (app.Alive and autoWorkRunning and autoWorkGeneration == myGeneration) then
                        break
                    end

                    if arrived then
                        autoWorkStatus = string.format("Working at point %d/%d", index, #autoWorkSpots)
                        pcall(function()
                            virtualInput:SendKeyEvent(true, Enum.KeyCode.T, false, game)
                        end)
                        task.wait(0.12)
                        pcall(function()
                            virtualInput:SendKeyEvent(false, Enum.KeyCode.T, false, game)
                        end)
                        task.wait(0.6)
                    end
                end

                if autoWorkRunning and autoWorkGeneration == myGeneration then
                    autoWorkStatus = "Restarting route"
                    task.wait(0.3)
                end
            end

            if autoWorkGeneration == myGeneration then
                autoWorkStatus = "Off"
            end
        end)
    end

    -- Self-fling button helper (affects only your own character, not other players).
    local function selfFling()
        local char = player.Character; local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then hrp.AssemblyLinearVelocity = Vector3.new(math.random(-1,1), 1, math.random(-1,1)).Unit * 180 + Vector3.new(0, 120, 0) end
    end

    -- Optional CFrame movement boost. Zero disables it; movement follows the
    -- Humanoid's intended direction and preserves the current vertical position.
    -- Optional No Clip toggle. Preserve each part's original collision state
    -- and restore it when disabled or when the script is stopped.
    local noClipOriginal = {}
    local function restoreNoClip()
        for part, original in pairs(noClipOriginal) do
            if part and part.Parent then
                pcall(function() part.CanCollide = original end)
            end
        end
        table.clear(noClipOriginal)
    end

    own(RunService.Heartbeat, function()
        if settings.NoClipEnabled or autoWorkRunning then
            local char = player.Character
            if char then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        if noClipOriginal[part] == nil then
                            noClipOriginal[part] = part.CanCollide
                        end
                        if part.CanCollide then part.CanCollide = false end
                    end
                end
            end
        elseif next(noClipOriginal) ~= nil then
            restoreNoClip()
        end
    end)

    table.insert(app.Connections, restoreNoClip)

    own(RunService.Heartbeat, function(dt)

        if not settings.CFrameMovementEnabled then return end

        local speed = math.clamp(tonumber(settings.CFrameSpeed) or 0, 0, 100)

        if speed <= 0 then return end

        local char = player.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local hrp = char and char:FindFirstChild("HumanoidRootPart")

        if not hum or hum.Health <= 0 or not hrp then return end

        local direction = hum.MoveDirection
        if direction.Magnitude <= 0.02 then return end

        local displacement = direction.Unit * speed * math.min(dt, 0.1)
        hrp.CFrame = hrp.CFrame + displacement

    end)

    own(inputService.InputBegan, function(input, processed)

        if not processed and input.KeyCode == Enum.KeyCode.T then

            restartSprint()

        end

    end)

    own(RunService.Heartbeat, function()

        if not settings.AutoRun then

            setAutoRunHeld(false)

            lastMoving = false

            return

        end

        local char = player.Character

        local hum = char and char:FindFirstChildOfClass("Humanoid")

        local moving = hum ~= nil and hum.Health > 0 and hum.MoveDirection.Magnitude > 0.02

        local stance = state and state.Data and state.Data.Stance

        if stance ~= lastStance then

            if lastStance ~= nil and moving then restartSprint() end

            lastStance = stance

        end

        if moving then

            if not lastMoving or not shiftHeld then setAutoRunHeld(true) end

        else

            setAutoRunHeld(false)

        end

        lastMoving = moving

    end)

    -- Kendo style: native M1 detection plus optional named combat animations.

    local attacks = {}

    local KendoStyle = {

        M1 = {"138879764141061", "88933140898192", "115475660627075", "140021888835093"},

        Block = "89313806025011", BlockHit = "79698927438954",

        Critical = "71126000171857", IdleShort = "130882613806431",

        IdleTall = "130882613806431", Walk = "122819379496112",

        Run = "126866594956455"

    }

    local knownNativeM1Ids = { ["81936561700214"] = true }

    local replacementIds = {}

    for _, id in ipairs(KendoStyle.M1) do replacementIds[id] = true end

    for key, id in pairs(KendoStyle) do

        if key ~= "M1" then replacementIds[id] = true end

    end

    local kendoTracks, kendoAnimator, kendoConnection = {}, nil, nil

    local kendoIndex, lastNativeAttack = 0, -math.huge

    -- Mouse-click timing helps identify native M1 animations whose asset IDs/names vary.

    local lastM1Input = -math.huge

    local comboResetAfter = 0.9

    local kendoStatus = "Waiting for native animation"

    local activeReplacement = {}

    local busy = false

    local lastCritical = -math.huge

    local lastCombatAction = -math.huge

    local idleTrack = nil



    local function stopKendo()

        if idleTrack and idleTrack.IsPlaying then pcall(function() idleTrack:Stop(0.08) end) end

        for _, track in pairs(activeReplacement) do

            pcall(function() track:Stop(0.08) end)

        end

        table.clear(activeReplacement)

    end

    local function clearKendo()

        if kendoConnection then kendoConnection:Disconnect(); kendoConnection = nil end

        stopKendo()

        for _, track in ipairs(kendoTracks) do pcall(function() track:Destroy() end) end

        table.clear(kendoTracks)

        kendoAnimator = nil

        kendoIndex = 0

        lastNativeAttack = -math.huge

        lastM1Input = -math.huge

        lastCritical = -math.huge

        idleTrack = nil

    end

    table.insert(app.Connections, clearKendo)



    local function classify(animation, assetId)

        local attack = attacks[assetId]

        if knownNativeM1Ids[assetId] or (attack and not attack.Heavy) then return "M1" end

        -- Critical is exclusively triggered by the R key, not animation registry events.

        if attack and attack.Heavy then return nil end

        local name = string.lower(animation.Name or "")

        if name:find("blockhit", 1, true) or name:find("block_hit", 1, true)

            or name:find("guardhit", 1, true) then return "BlockHit" end

        if name:find("block", 1, true) or name:find("guard", 1, true) then return "Block" end

        -- Critical only from verified heavy attack asset IDs in the combat registry.

        if name:find("critical", 1, true) or name:find("heavy", 1, true) then return nil end

        if name:match("punch%d+$") or name:match("kick%d+$") or name:match("m1%d*$")

            or name:find("slash", 1, true) then return "M1" end

        if name:find("run", 1, true) or name:find("sprint", 1, true) then return "Run" end

        if name:find("walk", 1, true) then return "Walk" end

        if name:find("idle", 1, true) or name:find("stance", 1, true) then return "IdleShort" end

        -- Fallback only immediately after a normal left-click. This avoids treating

        -- unrelated/critical animations as M1 just because their IDs are unknown.

        if os.clock() - lastM1Input <= 0.4 then return "M1" end

        return nil

    end



    local function attachKendo(character)

        clearKendo()

        local humanoid = character:WaitForChild("Humanoid", 10)

        local animator = humanoid and humanoid:WaitForChild("Animator", 10)

        if not animator or not app.Alive or player.Character ~= character then return end

        kendoAnimator = animator

        local tracksById = {}

        local function loadTrack(id)

            if tracksById[id] then return tracksById[id] end

            local animation = Instance.new("Animation")

            animation.AnimationId = "rbxassetid://" .. id

            local ok, track = pcall(function() return animator:LoadAnimation(animation) end)

            animation:Destroy()

            if not ok or not track then

                kendoStatus = "Load failed " .. id .. ": " .. tostring(track)

                return nil

            end

            track.Looped = false

            table.insert(kendoTracks, track)

            tracksById[id] = track

            return track

        end

        for _, id in ipairs(KendoStyle.M1) do loadTrack(id) end

        for key, id in pairs(KendoStyle) do

            if key ~= "M1" then loadTrack(id) end

        end

        idleTrack = tracksById[KendoStyle.IdleShort]



        -- Handle M1 input directly as a visual fallback. The game's native

        -- combat still handles damage; this only swaps the local animation.

        -- The AnimationPlayed listener below stops the native attack animation.

        local function playKendoM1FromInput()

            if not settings.FakeKendo or not app.Alive or player.Character ~= character then return end

            if humanoid.Health <= 0 then return end

            local stance = state and state.Data and state.Data.Stance

            if not stance or stance == "" then return end



            local now = os.clock()

            if now - lastNativeAttack < 0.12 then return end

            if now - lastNativeAttack > comboResetAfter then kendoIndex = 0 end

            lastNativeAttack = now

            lastM1Input = now

            kendoIndex = (kendoIndex % #KendoStyle.M1) + 1



            if idleTrack and idleTrack.IsPlaying then idleTrack:Stop(0.03) end

            local replacement = tracksById[KendoStyle.M1[kendoIndex]]

            if not replacement then

                kendoStatus = "M1 track missing: " .. tostring(KendoStyle.M1[kendoIndex])

                return

            end

            pcall(function()

                replacement:Stop(0)

                replacement.Looped = false

                replacement.Priority = Enum.AnimationPriority.Action4

                replacement:Play(0.03, 1, 1)

            end)

            activeReplacement.M1 = replacement

            kendoStatus = "M1 input replacement " .. kendoIndex

        end



        -- R is the game's critical input. Trigger the visual once per key press.

        -- Never infer critical from ordinary animation playback.

        -- Match Gakuran's held-M1 behavior: start one visual swing on press,
        -- then keep advancing the Kendo combo while the physical mouse button
        -- remains held. The game's own combat input still handles damage.
        local m1HoldLoopRunning = false
        local rConnection = inputService.InputBegan:Connect(function(input, processed)

            -- Do not gate MouseButton1 on `processed`: Ishin's combat input can
            -- mark the click as processed before this listener receives it.
            if input.UserInputType == Enum.UserInputType.MouseButton1 then

                lastM1Input = os.clock()
                playKendoM1FromInput()

                if not m1HoldLoopRunning then
                    m1HoldLoopRunning = true
                    task.spawn(function()
                        while app.Alive and player.Character == character
                            and settings.FakeKendo and humanoid.Health > 0
                            and inputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
                            task.wait(0.18)
                            if not (app.Alive and player.Character == character
                                and settings.FakeKendo and humanoid.Health > 0
                                and inputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)) then
                                break
                            end
                            playKendoM1FromInput()
                        end
                        m1HoldLoopRunning = false
                    end)
                end
            end

            if processed or input.KeyCode ~= Enum.KeyCode.R then return end

            if not settings.FakeKendo or not app.Alive or player.Character ~= character then return end

            if humanoid.Health <= 0 then return end

            local stance = state and state.Data and state.Data.Stance

            if not stance or stance == "" then return end

            local now = os.clock()

            if now - lastCritical < 0.35 then return end

            lastCritical = now

            lastCombatAction = now

            if idleTrack and idleTrack.IsPlaying then idleTrack:Stop(0.05) end

            local crit = tracksById[KendoStyle.Critical]

            if not crit then return end

            pcall(function()

                crit:Stop(0)

                crit.Looped = false

                crit.Priority = Enum.AnimationPriority.Action4

                crit:Play(0.04, 1, 1)

            end)

            activeReplacement.Critical = crit

            kendoStatus = "Critical: R"

        end)

        table.insert(app.Connections, function() rConnection:Disconnect() end)



        kendoConnection = animator.AnimationPlayed:Connect(function(original)

            if busy or not app.Alive or not settings.FakeKendo then return end

            if player.Character ~= character or humanoid.Health <= 0 then return end

            local animation = original.Animation

            if not animation then return end

            local assetId = animation.AnimationId:match("%d+")

            if not assetId or replacementIds[assetId] then return end

            local kind = classify(animation, assetId)

            if not kind then return end -- Unknown UUIDs are NOT assumed to be M1.

            local stance = state and state.Data and state.Data.Stance

            if not stance or stance == "" then return end

            local now = os.clock()

            if kind == "Critical" then return end -- Critical is R-only.

            if kind == "M1" or kind == "Critical" or kind == "Block" or kind == "BlockHit" then

                lastCombatAction = now

                if idleTrack and idleTrack.IsPlaying then idleTrack:Stop(0.05) end

            end

            local id

            if kind == "M1" then
                -- M1 visuals are owned exclusively by playKendoM1FromInput().
                -- Always stop a classified native M1 track, even when it arrives
                -- late; never let AnimationPlayed start a second Kendo swing.
                pcall(function()
                    original:Stop(0)
                end)
                return
            else
                id = KendoStyle[kind]
            end

            local replacement = id and tracksById[id]

            if not replacement then return end

            if activeReplacement[kind] then

                pcall(function() activeReplacement[kind]:Stop(0.04) end)

            end

            -- Movement/stance loops are allowed; attacks must always play once.

            local continuous = kind == "IdleShort" or kind == "IdleTall"

                or kind == "Walk" or kind == "Run" or kind == "Block"

            replacement.Looped = continuous

            replacement.Priority = original.Priority

            busy = true

            local ok = pcall(function()

                replacement:Play(0.04, 1, 1)

                original:Stop(0.04)

            end)

            busy = false

            if ok then

                activeReplacement[kind] = replacement

                kendoStatus = "Replaced " .. kind .. (kind == "M1" and (" " .. kendoIndex) or "")

            else

                kendoStatus = "Playback failed: " .. kind

            end

        end)

        kendoStatus = "Ready: M1 / Block / Critical / Movement"

    end

    own(player.CharacterAdded, attachKendo)

    if player.Character then task.defer(attachKendo, player.Character) end



    local lastKendoStance

    own(RunService.Heartbeat, function()

        local stance = state and state.Data and state.Data.Stance

        if lastKendoStance ~= nil and (not stance or stance == "") then

            kendoIndex = 0

            stopKendo()

        end

        lastKendoStance = stance

        -- Start and maintain Kendo stance independently of UUID-named idle animations.

        -- Only while standing still, outside the short attack recovery window.

        if settings.FakeKendo and idleTrack and kendoAnimator and stance and stance ~= "" then

            local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")

            local still = humanoid and humanoid.Health > 0 and humanoid.MoveDirection.Magnitude < 0.08

            local safeToIdle = still and os.clock() - lastCombatAction > 0.6

            if safeToIdle and not idleTrack.IsPlaying then

                idleTrack.Looped = true

                idleTrack.Priority = Enum.AnimationPriority.Action

                idleTrack:Play(0.15, 1, 1)

            elseif not safeToIdle and idleTrack.IsPlaying then

                idleTrack:Stop(0.1)

            end

        elseif idleTrack and idleTrack.IsPlaying then

            idleTrack:Stop(0.1)

        end

        if kendoIndex ~= 0 and os.clock() - lastNativeAttack > comboResetAfter then

            kendoIndex = 0

        end

    end)

    local function root(character)

        return character and character:FindFirstChild("HumanoidRootPart")

    end

    local function snapshot()

        local d = state and state.Data

        if not d then return nil end

        local out = table.clone(d)

        local character = player.Character

        local h = character and character:FindFirstChildOfClass("Humanoid")

        out.Alive = h ~= nil and h.Health > 0 and root(character) ~= nil

        out.Sitting = h and h.Sit

        out.Restricted = h and (h:HasTag("Downed") or h:HasTag("CrutchCrawling")

            or h:HasTag("HoldingBlockingObject") or h:HasTag("PlayingBasketball"))

        local data = main and main.Data

        local slot = data and data.CSlots and data.CSlots[data.CSlot]

        local style = slot and slot.FightingStyle

        out.Style = (characterConfig and characterConfig.RenamedFightingStyles or {})[style] or style

        out.WeaveDuration = controls and controls.Combat and controls.Combat.WeaveWindow

        return out

    end

    local ray = RaycastParams.new()

    ray.FilterType = Enum.RaycastFilterType.Exclude

    local function geometry(character, counter)

        local me, them = root(player.Character), root(character)

        local humanoid = character and character:FindFirstChildOfClass("Humanoid")

        if not me or not them or not humanoid or humanoid.Health <= 0 or not character:IsDescendantOf(Workspace)

            or humanoid:HasTag("Downed") then return nil end

        local diff = them.Position - me.Position

        local planar = Vector3.new(diff.X, 0, diff.Z)

        local toMe = -planar

        local look = if counter then me.CFrame.LookVector else them.CFrame.LookVector

        local direction = if counter then planar else toMe

        -- Keep facing as diagnostic info only. Side/wide hitboxes can connect even
        -- when the attacker is turned away; attack timing and cancellation decide.
        local facingThreshold = if counter then 0.15 else math.cos(math.rad(30))
        local facing = direction.Magnitude < 0.01 or look:Dot(direction.Unit) >= facingThreshold

        ray.FilterDescendantsInstances = {player.Character, character}

        local visible = Workspace:Raycast(me.Position, diff, ray) == nil

        return {Distance = planar.Magnitude, Vertical = math.abs(diff.Y), Facing = facing, Visible = visible}

    end

    local radiusFolder = Instance.new("Folder")

    radiusFolder.Name = "LarpshinRadiusCircle"

    radiusFolder.Parent = Workspace

    local radiusSegments = {}

    for i = 1, 50 do

        local segment = Instance.new("Part")

        segment.Name = "RadiusSegment"

        segment.Anchored = true

        segment.CanCollide = false

        segment.CanTouch = false

        segment.CanQuery = false

        segment.CastShadow = false

        segment.Material = Enum.Material.Neon

        segment.Color = Color3.fromRGB(0, 195, 255)

        segment.Transparency = 1

        segment.Size = Vector3.new(0.08, 0.08, 1)

        segment.Parent = radiusFolder

        radiusSegments[i] = segment

    end

    table.insert(app.Connections, function() radiusFolder:Destroy() end)

    local circleAccumulator = 0

    own(RunService.Heartbeat, function(dt)

        circleAccumulator += dt

        if circleAccumulator < 1 / 25 then return end

        circleAccumulator = 0

        local hrp = root(player.Character)

        local visible = settings.ShowRadius and hrp ~= nil

        if not visible then

            for _, part in ipairs(radiusSegments) do part.Transparency = 1 end

            return

        end

        local radius = math.max(0.5, settings.Range)

        local rayParams = RaycastParams.new()

        rayParams.FilterType = Enum.RaycastFilterType.Exclude

        rayParams.FilterDescendantsInstances = {player.Character, radiusFolder}

        local groundHit = Workspace:Raycast(hrp.Position, Vector3.new(0, -12, 0), rayParams)

        local origin = groundHit and (groundHit.Position + Vector3.new(0, 0.16, 0))

            or (hrp.Position - Vector3.new(0, hrp.Size.Y * 0.5 + 1.5, 0))

        local function drawSegment(part, p1, p2)

            part.Size = Vector3.new(0.09, 0.09, (p2 - p1).Magnitude)

            part.CFrame = CFrame.lookAt((p1 + p2) / 2, p2)

            part.Transparency = 0.25

        end

        if settings.FrontAttacksOnly then

            -- Draw a narrow 50-degree forward detection cone instead of a full circle.
            -- Roblox LookVector points along local -Z; atan2(X, Z) gives its yaw.
            local look = hrp.CFrame.LookVector

            local yaw = math.atan2(look.X, look.Z)

            local halfAngle = math.rad(math.clamp(settings.FrontConeAngle, 10, 180) / 2)

            local arcSegments = 48

            local previous = origin + Vector3.new(math.sin(yaw - halfAngle) * radius, 0,
                math.cos(yaw - halfAngle) * radius)

            for i = 1, arcSegments do

                local angle = yaw - halfAngle + (2 * halfAngle) * i / arcSegments

                local current = origin + Vector3.new(math.sin(angle) * radius, 0,
                    math.cos(angle) * radius)

                drawSegment(radiusSegments[i], previous, current)

                previous = current

            end

            local leftEdge = origin + Vector3.new(math.sin(yaw - halfAngle) * radius, 0,
                math.cos(yaw - halfAngle) * radius)

            local rightEdge = origin + Vector3.new(math.sin(yaw + halfAngle) * radius, 0,
                math.cos(yaw + halfAngle) * radius)

            drawSegment(radiusSegments[49], origin, leftEdge)

            drawSegment(radiusSegments[50], origin, rightEdge)

        else

            -- Keep the original 360-degree detection circle when the cone toggle is off.
            for i = 1, 48 do

                local a = (i - 1) * math.pi * 2 / 48

                local b = i * math.pi * 2 / 48

                local p1 = origin + Vector3.new(math.cos(a) * radius, 0, math.sin(a) * radius)

                local p2 = origin + Vector3.new(math.cos(b) * radius, 0, math.sin(b) * radius)

                drawSegment(radiusSegments[i], p1, p2)

            end

            radiusSegments[49].Transparency = 1

            radiusSegments[50].Transparency = 1

        end

    end)

    controller = newController({

        State = snapshot, Now = clock,

        NetworkPing = function() return player:GetNetworkPing() end,

        Threat = function(track, character)

            local g = geometry(character, false)

            if not g then return nil end

            g.Playing, g.Speed, g.Position = track.IsPlaying, track.Speed, track.TimePosition

            return g

        end,

        CounterTarget = function(character) return geometry(character, true) end,

        FrontFacing = function(character)

            local me, them = root(player.Character), root(character)

            if not me or not them then return false end

            local delta = them.Position - me.Position

            local flatToTarget = Vector3.new(delta.X, 0, delta.Z)

            local look = me.CFrame.LookVector

            local flatLook = Vector3.new(look.X, 0, look.Z)

            if flatToTarget.Magnitude < 0.01 or flatLook.Magnitude < 0.01 then return true end

            -- Adjustable total cone angle; half extends to either side of facing.
            local halfAngle = math.clamp(settings.FrontConeAngle, 10, 180) / 2
            return flatLook.Unit:Dot(flatToTarget.Unit) >= math.cos(math.rad(halfAngle))

        end,

        FaceTarget = function(character)

            local me, them = root(player.Character), root(character)

            if not me or not them then return end

            local delta = them.Position - me.Position

            local flat = Vector3.new(delta.X, 0, delta.Z)

            if flat.Magnitude < 0.05 then return end

            me.CFrame = CFrame.lookAt(me.Position, me.Position + flat)

        end,

        DashBackward = function()

            local me = root(player.Character)

            local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")

            if not me or not hum or hum.Health <= 0 then return false end

            -- Move directly opposite the character's current horizontal facing.
            -- Do not rotate toward or calculate a position behind the enemy.
            local look = me.CFrame.LookVector

            local backward = Vector3.new(-look.X, 0, -look.Z)

            if backward.Magnitude < 0.2 then return false end

            hum:Move(backward.Unit, false)

            local vim = game:GetService("VirtualInputManager")

            vim:SendKeyEvent(true, Enum.KeyCode.Q, false, game)

            task.delay(0.06, function()

                pcall(function() vim:SendKeyEvent(false, Enum.KeyCode.Q, false, game) end)

            end)

            return true

        end,

        Direction = function()

            local h = player.Character and player.Character:FindFirstChildOfClass("Humanoid")

            local camera = Workspace.CurrentCamera

            if not h or not camera or h.MoveDirection.Magnitude < 0.1 then return "Back" end

            local v = camera.CFrame:VectorToObjectSpace(h.MoveDirection)

            if math.abs(v.X) > math.abs(v.Z) then return if v.X > 0 then "Right" else "Left" end

            return if v.Z > 0 then "Back" else "Front"

        end,

        Send = function(action, direction)

            assert(app.Alive, "runtime stopped")

            if direction then remote:FireServer(action, direction) else remote:FireServer(action) end

        end,

    }, settings)

    app.Controller = controller

    local animations = registry:get("ReplicatedAssetsAnimations")

    local styles = animations and animations.Combat and animations.Combat.Styles

    assert(typeof(styles) == "Instance", "Ishin attack animation assets unavailable")

    attacks = {}

    local function addAnimation(animation)

        if not animation:IsA("Animation") then return end

        local name = animation.Name

        local light = name:match("Punch%d+$") or name:match("Kick%d+$")

        local heavy = name:match("Critical$") or name:match("CriticalStart$") or name == "WrestlingCriticalUser"

        if light or heavy then

            local id = animation.AnimationId:match("%d+")

            if id then attacks[id] = {Name = name, Heavy = heavy ~= nil} end

        end

    end

    for _, animation in ipairs(styles:GetDescendants()) do addAnimation(animation) end

    own(styles.DescendantAdded, addAnimation)

    app.Attacks = attacks

    local function unbind(character)

        local record = app.Characters[character]

        if record then

            for _, c in ipairs(record.Connections) do disconnect(c) end

            app.Characters[character] = nil

        end

        controller:Forget(character)

    end

    local function bind(character)

        if character == player.Character or app.Characters[character] then return end

        local record = {Connections = {}}

        app.Characters[character] = record

        local function attach(animator)

            if not animator:IsA("Animator") or record.Animator then return end

            record.Animator = animator

            local function observed(track)

                local animation = track.Animation

                local id = animation and animation.AnimationId:match("%d+")

                if id and attacks[id] then controller:Observe(track, character, attacks[id]) end

            end

            own(animator.AnimationPlayed, observed, record.Connections)

            for _, track in ipairs(animator:GetPlayingAnimationTracks()) do observed(track) end

        end

        own(character.DescendantAdded, attach, record.Connections)

        local h = character:FindFirstChildOfClass("Humanoid")

        local animator = h and h:FindFirstChildOfClass("Animator")

        if animator then attach(animator) end

    end

    local function watch(other)

        if other == player then return end

        own(other.CharacterAdded, bind)

        own(other.CharacterRemoving, unbind)

        if other.Character then bind(other.Character) end

    end

    own(Players.PlayerAdded, watch)

    own(Players.PlayerRemoving, function(other) if other.Character then unbind(other.Character) end end)

    for _, other in ipairs(Players:GetPlayers()) do watch(other) end

    own(player.CharacterRemoving, function() controller:Reset(nil); state = nil end)

    own(player.CharacterAdded, function() controller:Reset(nil) end)

    local onState = registry:get("on-player-state-replica")

    assert(type(onState) == "function", "Native state lifecycle unavailable")

    table.insert(app.Connections, onState(function(value)

        if not app.Alive then return end

        state = value

        controller:Reset(snapshot())

    end))

    local onMain = registry:get("on-main-data-replica")

    if type(onMain) == "function" then

        table.insert(app.Connections, onMain(function(value) if app.Alive then main = value end end))

    end

    local elapsed, recovery = 0, 0

    own(RunService.Heartbeat, function(dt)

        controller.Latency:UpdateFrame(dt)

        elapsed += dt

        recovery += dt

        if recovery >= 0.10 then

            recovery = 0

            local latest = registry:get("player-state-replica")

            if latest ~= state then state = latest; controller:Reset(snapshot()) end

            if settings.AutoWeave or settings.AutoHeavy or settings.DashFallback or settings.AutoBlockSideAttacks then

                for character, record in pairs(app.Characters) do

                    local me, them = root(player.Character), root(character)

                    if me and them and (me.Position - them.Position).Magnitude < settings.Range + 5 and record.Animator then

                        for _, track in ipairs(record.Animator:GetPlayingAnimationTracks()) do

                            if not controller.Threats[track] then

                                local id = track.Animation and track.Animation.AnimationId:match("%d+")

                                if id and attacks[id] then controller:Observe(track, character, attacks[id]) end

                            end

                        end

                    end

                end

            end

        end

        if elapsed >= 1 / 60 then elapsed = 0; controller:Step() end

    end)

    Rere = assert(loadstring(game:HttpGet("https://api.x8stuff.lol/assets/Rere.lua"), "Larpshin/Rere"))()

    assert(type(Rere.BindClose) == "function", "Rere close lifecycle unavailable")

    if not app.Alive then Rere.Shutdown(); return end

    Rere.Init(player:WaitForChild("PlayerGui"))

    local camera = Workspace.CurrentCamera

    local viewport = camera and camera.ViewportSize or Vector2.new(1280, 720)

    local size = Vector2.new(math.min(430, math.max(240, viewport.X - 24)), math.min(460, math.max(240, viewport.Y - 24)))

    local window = {size = Rere.State(size), isOpened = Rere.State(true), isUncollapsed = Rere.State(true),

        position = Rere.State(Vector2.new(math.max(0, (viewport.X - size.X) / 2), math.max(0, (viewport.Y - size.Y) / 2)))}

    local ui = {}

    for k, value in pairs(settings) do ui[k] = Rere.State(value) end

    table.insert(app.Connections, Rere.BindClose("Larpshin", function(title) return title == "Larpshin" end, function() app:Stop() end))

    local function id(name) Rere.SetNextWidgetID("Larpshin/" .. name) end
    local tabMovement = Rere.State(false)
    local tabCombat = Rere.State(true)
    local tabVisuals = Rere.State(false)
    local tabSettings = Rere.State(false)

    table.insert(app.Connections, Rere:Connect(function()

        if not app.Alive then return end

        id("Window"); Rere.Window({"Larpshin"}, window)

        if window.isOpened.value and window.isUncollapsed.value then

            Rere.TabBar()
            id("TabMovement"); Rere.Tab({"Movement"}, {isOpened = tabMovement})
            id("Movement"); Rere.SeparatorText({"Movement"})

            id("AutoWorkEnabled"); Rere.Checkbox({"Auto Work (walk route + press T)"}, {isChecked = ui.AutoWorkEnabled})
            if settings.AutoWorkEnabled ~= ui.AutoWorkEnabled.value then
                if ui.AutoWorkEnabled.value then
                    startAutoWork()
                else
                    stopAutoWork()
                end
            end
            id("AutoWorkStatus"); Rere.TextWrapped({"Auto Work: " .. autoWorkStatus .. " | retries every 1 second"})

            id("AutoRun"); Rere.Checkbox({"Auto Run (also in T combat stance)"}, {isChecked = ui.AutoRun})

            id("FlyEnabled"); Rere.Checkbox({"Fly (ON/OFF)"}, {isChecked = ui.FlyEnabled})
            if settings.FlyEnabled ~= ui.FlyEnabled.value then settings.FlyEnabled = ui.FlyEnabled.value; if settings.FlyEnabled then startFly() else stopFly() end end
            id("FlySpeed"); Rere.SliderNum({"Fly Speed", 1, 10, 150, "%d studs/s"}, {number = ui.FlySpeed})
            settings.FlySpeed = ui.FlySpeed.value
            id("SelfFling"); if Rere.Button({"Fling Self"}).clicked() then selfFling() end


            id("NoClipEnabled"); Rere.Checkbox({"No Clip (ON/OFF)"}, {isChecked = ui.NoClipEnabled})
            if settings.NoClipEnabled ~= ui.NoClipEnabled.value then
                settings.NoClipEnabled = ui.NoClipEnabled.value
            end

            id("CFrameMovementEnabled"); Rere.Checkbox({"CFrame Movement (ON/OFF)"}, {isChecked = ui.CFrameMovementEnabled})
            if settings.CFrameMovementEnabled ~= ui.CFrameMovementEnabled.value then
                settings.CFrameMovementEnabled = ui.CFrameMovementEnabled.value
            end

            id("CFrameSpeed"); Rere.SliderNum({"CFrame Movement Speed", 1, 0, 100, "%d studs/s"}, {number = ui.CFrameSpeed})
            controller:Set("CFrameSpeed", ui.CFrameSpeed.value)

            if settings.AutoRun ~= ui.AutoRun.value then

                settings.AutoRun = ui.AutoRun.value

                if not settings.AutoRun then setAutoRunHeld(false) end

            end

                id("FakeKendo"); Rere.Checkbox({"Fake Style: Kendo (all animations)"}, {isChecked = ui.FakeKendo})

                id("KendoM1Hint"); Rere.TextWrapped({"Click or hold M1 for the Kendo combo."})

                if settings.FakeKendo ~= ui.FakeKendo.value then

                    settings.FakeKendo = ui.FakeKendo.value

                    if not settings.FakeKendo then

                        stopKendo()

                        kendoIndex = 0

                    else

                        kendoStatus = "Waiting for real M1"

                    end

                end

            id("KendoStatus"); Rere.TextWrapped({"Fake Style: " .. kendoStatus})

            Rere.End()
            id("TabCombat"); Rere.Tab({"Combat"}, {isOpened = tabCombat})
            id("Combat"); Rere.SeparatorText({"Combat"})

            id("AutoWeave"); Rere.Checkbox({"Auto Weave"}, {isChecked = ui.AutoWeave})

            controller:Set("AutoWeave", ui.AutoWeave.value)

            id("FrontAttacksOnly"); Rere.Checkbox({"Front Attacks Only"}, {isChecked = ui.FrontAttacksOnly})

            controller:Set("FrontAttacksOnly", ui.FrontAttacksOnly.value)

            id("FrontConeAngle"); Rere.SliderNum({"Front Cone Angle", 5, 10, 180, "%d°"}, {number = ui.FrontConeAngle})

            controller:Set("FrontConeAngle", ui.FrontConeAngle.value)

            id("AutoBlockSideAttacks"); Rere.Checkbox({"Block Side Attacks with F"}, {isChecked = ui.AutoBlockSideAttacks})

            controller:Set("AutoBlockSideAttacks", ui.AutoBlockSideAttacks.value)

            -- Front-only mode relies on the player's current facing direction,
            -- so automatically disable the option that turns toward the target.
            if ui.FrontAttacksOnly.value and ui.FaceAttacker.value then
                ui.FaceAttacker.value = false
            end

            id("DashFallback"); Rere.Checkbox({"Q Dash Backward (Weave Cooldown)"}, {isChecked = ui.DashFallback})

            controller:Set("DashFallback", ui.DashFallback.value)

            id("AutoHeavy"); Rere.Checkbox({"Heavy Counter After Weave"}, {isChecked = ui.AutoHeavy})

            controller:Set("AutoHeavy", ui.AutoHeavy.value)

            id("FaceAttacker"); Rere.Checkbox({"Face Attacker on Auto Weave"}, {isChecked = ui.FaceAttacker})

            controller:Set("FaceAttacker", ui.FaceAttacker.value)

            id("ShowRadius"); Rere.Checkbox({"Show Detection Radius Circle"}, {isChecked = ui.ShowRadius})

            controller:Set("ShowRadius", ui.ShowRadius.value)

            id("Range"); Rere.SliderNum({"Detection Range", 0.5, 3, 15, "%.1f studs"}, {number = ui.Range})

            controller:Set("Range", ui.Range.value)

            id("HitRange"); Rere.SliderNum({"Predicted Hit Range", 0.5, 2, 10, "%.1f studs"}, {number = ui.HitRange})

            controller:Set("HitRange", ui.HitRange.value)

            id("CounterRange"); Rere.SliderNum({"Counter Range", 0.5, 3, 10, "%.1f studs"}, {number = ui.CounterRange})

            controller:Set("CounterRange", ui.CounterRange.value)

            Rere.End()
            id("TabVisuals"); Rere.Tab({"Visuals / ESP"}, {isOpened = tabVisuals})
            id("Visuals"); Rere.SeparatorText({"Visuals / ESP"})
            id("NameESPEnabled"); Rere.Checkbox({"Player ESP (ON/OFF)"}, {isChecked = ui.NameESPEnabled})
            if settings.NameESPEnabled ~= ui.NameESPEnabled.value then settings.NameESPEnabled = ui.NameESPEnabled.value; refreshNameESP() end
            id("ESPDistance"); Rere.Checkbox({"Show Distance"}, {isChecked = ui.ESPDistance})
            if settings.ESPDistance ~= ui.ESPDistance.value then settings.ESPDistance = ui.ESPDistance.value; refreshNameESP() end
            id("ESPMaxDistance"); Rere.SliderNum({"ESP Max Distance", 25, 50, 3000, "%d studs"}, {number = ui.ESPMaxDistance})
            if settings.ESPMaxDistance ~= ui.ESPMaxDistance.value then settings.ESPMaxDistance = ui.ESPMaxDistance.value; refreshNameESP() end
            id("ESPInfo"); Rere.TextWrapped({"Name and distance in studs only. 2D/3D boxes and skeleton ESP are disabled."})
            Rere.End()
            id("TabSettings"); Rere.Tab({"Settings"}, {isOpened = tabSettings})
            id("Timing"); Rere.SeparatorText({"Timing"})

            id("PingCompensation"); Rere.Checkbox({"Ping Compensation"}, {isChecked = ui.PingCompensation})

            controller:Set("PingCompensation", ui.PingCompensation.value)

            id("AdaptivePing"); Rere.Checkbox({"Adaptive Ping"}, {isChecked = ui.AdaptivePing})

            controller:Set("AdaptivePing", ui.AdaptivePing.value)

            if settings.AdaptivePing then
                id("AdaptivePingInfo"); Rere.TextWrapped({"Adaptive Ping | " .. controller.Latency.Source
                    .. " | jitter: " .. string.format("%.0f ms", controller.Latency.Jitter * 1000)
                    .. " | frame: " .. string.format("%.0f ms", math.clamp(controller.Latency.Frame, 0, 0.025) * 1000)})
            end

            id("MaxPingLeadMs"); Rere.SliderNum({"Max Ping Lead", 5, 0, 100, "%d ms"}, {number = ui.MaxPingLeadMs})

            controller:Set("MaxPingLeadMs", ui.MaxPingLeadMs.value)

            id("LightDelay"); Rere.SliderNum({"Light Attack Timing", 0.01, 0, 0.5, "%.2f s"}, {number = ui.LightDelay})

            controller:Set("LightDelay", ui.LightDelay.value)

            id("HeavyDelay"); Rere.SliderNum({"Heavy Attack Timing", 0.01, 0, 0.8, "%.2f s"}, {number = ui.HeavyDelay})

            controller:Set("HeavyDelay", ui.HeavyDelay.value)

            id("Session"); Rere.SeparatorText({"Session"})

            local d = snapshot()

            id("Style"); Rere.Text({"Style: " .. tostring(d and d.Style or "Loading")})

            local ping = controller.Latency.Seconds

            id("Ping"); Rere.Text({if ping then string.format("Ping (RTT estimate): %.0f ms", ping * 2000) else "Ping: unavailable"})

            id("PingLead"); Rere.Text({string.format("Weave lead: %.0f ms | %s", controller.PingLead * 1000, controller.Latency.Source)})

            id("Status"); Rere.TextWrapped({controller.Status})

            id("Counts"); Rere.Text({string.format("Weave requests: %d | Heavy requests: %d", controller.Weaves, controller.Counters)})

            id("Stop"); if Rere.Button({"Stop Larpshin"}).clicked() then app:Stop() end
            Rere.End()
            Rere.End() -- TabBar
        end

        if app.Alive then Rere.End() end

    end))

    local reloadState = getfenv().STATE

    if type(reloadState) == "table" and type(reloadState.onCleanup) == "function" then

        reloadState.onCleanup(function() app:Stop() end)

    end

end

local ok, err = pcall(start)

if not ok then app:Stop(); error("Larpshin: " .. tostring(err), 0) end

return app
