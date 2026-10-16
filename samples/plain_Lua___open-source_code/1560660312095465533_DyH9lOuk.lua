-- femboyware v0.4.4 | this one has to be final
local nativeRequire = require
local factories, cache, loading = {}, {}, {}
local function require(id)
    if type(id) ~= 'string' or not factories[id] then return nativeRequire(id) end
    if cache[id] ~= nil then return cache[id] end
    assert(not loading[id], 'Circular module: ' .. id)
    loading[id] = true
    local result = factories[id]()
    loading[id] = nil
    cache[id] = result
    return result
end

-- BEGIN src/core/entities.lua
factories["core/entities"] = function()
local Scope = require("core/scope")
local Entities = {}
Entities.__index = Entities
function Entities.new(app)
    local self = setmetatable({app = app, players = {}, list = {}, visibility = {}}, Entities)
    local function add(player)
        if player == app.player then return end
        local entry = {player = player, scope = Scope.new()}
        self.players[player] = entry
        table.insert(self.list, entry)
        local function characterAdded(character)
            if entry.characterScope then entry.characterScope:Destroy() end
            entry.characterScope = Scope.new()
            entry.character = character
            local function refresh()
                entry.root = character:FindFirstChild("HumanoidRootPart")
                entry.head = character:FindFirstChild("Head")
                entry.humanoid = character:FindFirstChildOfClass("Humanoid")
            end
            refresh()
            entry.characterScope:connect(character.ChildAdded, refresh)
            entry.characterScope:connect(character.ChildRemoved, refresh)
        end
        entry.scope:connect(player.CharacterAdded, characterAdded)
        entry.scope:connect(player.CharacterRemoving, function()
            if entry.characterScope then entry.characterScope:Destroy() end
            entry.character = nil; entry.root = nil; entry.head = nil; entry.humanoid = nil
        end)
        if player.Character then characterAdded(player.Character) end
    end
    local function remove(player)
        local entry = self.players[player]
        if not entry then return end
        self.visibility[entry] = nil
        entry.scope:Destroy()
        if entry.characterScope then entry.characterScope:Destroy() end
        self.players[player] = nil
        table.remove(self.list, table.find(self.list, entry))
    end
    for _, player in ipairs(app.services.Players:GetPlayers()) do add(player) end
    app.scope:connect(app.services.Players.PlayerAdded, add)
    app.scope:connect(app.services.Players.PlayerRemoving, remove)
    app.scope:add(function()
        for player in pairs(table.clone(self.players)) do remove(player) end
    end)
    return self
end
function Entities:enemy(entry)
    local player = self.app.player
    return entry.humanoid and entry.humanoid.Health > 0 and entry.root and entry.character
        and (player.Neutral or entry.player.Neutral or player.Team ~= entry.player.Team)
end
function Entities:visible(entry, part)
    local now = os.clock()
    local cache = self.visibility[entry]
    if cache and cache.part == part and now - cache.time < 0.1 then return cache.value end
    local camera = workspace.CurrentCamera
    if not camera then return false end
    local params = self.params or RaycastParams.new()
    self.params = params
    params.FilterType = Enum.RaycastFilterType.Exclude
    local filter = {camera}
    if self.app.player.Character then table.insert(filter, self.app.player.Character) end
    local models = workspace:FindFirstChild("ViewModels")
    if models then table.insert(filter, models) end
    params.FilterDescendantsInstances = filter
    local result = workspace:Raycast(camera.CFrame.Position, part.Position - camera.CFrame.Position, params)
    local value = not result or result.Instance:IsDescendantOf(entry.character)
    self.visibility[entry] = {part = part, time = now, value = value}
    return value
end
function Entities:target(options, previous)
    local camera = workspace.CurrentCamera
    if not camera then return nil end
    local origin = camera.ViewportSize / 2
    if options.origin == "Mouse" then
        origin = self.app.services.UserInputService:GetMouseLocation() - self.app.services.GuiService:GetGuiInset()
    end
    local best, score = nil, math.huge
    for _, entry in ipairs(self.list) do
        if (not options.team or self:enemy(entry)) and entry.root and entry.humanoid and entry.humanoid.Health > 0
            and (not options.environment or entry.player:GetAttribute("EnvironmentID") == self.app.player:GetAttribute("EnvironmentID")) then
            local part = options.hitbox == "Root" and entry.root or entry.head or entry.root
            local point, onScreen = camera:WorldToViewportPoint(part.Position)
            local distance = (part.Position - camera.CFrame.Position).Magnitude
            local screenDistance = (Vector2.new(point.X, point.Y) - origin).Magnitude
            if onScreen and distance <= (options.distance or 10000) and screenDistance <= (options.fov or 150)
                and (not options.visible or self:visible(entry, part)) then
                local candidate = options.priority == "Distance" and distance or screenDistance
                if options.lock and previous == entry then candidate = -1 end
                if candidate < score then best = entry; score = candidate end
            end
        end
    end
    return best
end
return Entities

end

-- BEGIN src/core/human_aim.lua
factories["core/human_aim"] = function()
-- Scalar math keeps the trajectory generator testable outside Roblox.
-- A minimum-jerk reach, curved approach, overshoot correction, and hand noise.
local HumanAim = {}
HumanAim.__index = HumanAim
local function length(x, y) return math.sqrt(x * x + y * y) end
local function minimumJerk(t) return t * t * t * (10 + t * (-15 + 6 * t)) end
function HumanAim.new(options, random)
    return setmetatable({options = options, random = random or math.random, time = 0, x = 0, y = 0, noiseX = 0, noiseY = 0}, HumanAim)
end
function HumanAim:begin(x, y)
    local o, random = self.options, self.random
    self.time, self.x, self.y = 0, 0, 0
    self.targetX, self.targetY = x, y
    local distance = length(x, y)
    -- Fitts-style distance scaling makes short corrections faster than wide turns.
    self.duration = math.max(0.03, (o.duration + o.distanceTime * math.log(1 + distance / math.max(o.targetWidth, 1)))
        * (1 + (random() * 2 - 1) * o.durationVariance))
    self.curve = (random() * 2 - 1) * o.curvature * distance
    self.overshoot = random() < o.overshootChance / 100 and o.overshoot or -o.undershoot
    self.phase = random() * math.pi * 2
    self.noiseX, self.noiseY = 0, 0
end
function HumanAim:step(dt, errorX, errorY)
    dt = math.clamp(dt, 0, 0.1)
    local o = self.options
    local error = length(errorX, errorY)
    if error <= o.deadzone then return 0, 0 end
    if not self.targetX then self:begin(errorX, errorY) end
    self.time += dt
    local t = math.clamp(self.time / self.duration, 0, 1)
    local dx, dy
    if t >= 1 then
        local response = 1 - math.exp(-o.tracking * dt)
        dx, dy = errorX * response, errorY * response
    else
        local reach = minimumJerk(t)
        local correction = self.overshoot * math.sin(math.pi * t) ^ 2 * (2 * t)
        local distance = math.max(length(self.targetX, self.targetY), 0.001)
        local perpendicularX, perpendicularY = -self.targetY / distance, self.targetX / distance
        local curve = self.curve * math.sin(math.pi * reach)
        local noiseDecay = math.exp(-o.noiseReturn * dt)
        local noiseScale = o.noise * math.sqrt(math.max(0, 1 - noiseDecay * noiseDecay))
        self.noiseX = self.noiseX * noiseDecay + (self.random() * 2 - 1) * noiseScale
        self.noiseY = self.noiseY * noiseDecay + (self.random() * 2 - 1) * noiseScale
        local envelope = math.sin(math.pi * t)
        local tremor = math.sin(self.time * o.tremorFrequency * math.pi * 2 + self.phase) * o.tremor * envelope
        local x = self.targetX * (reach + correction) + perpendicularX * (curve + tremor) + self.noiseX * envelope
        local y = self.targetY * (reach + correction) + perpendicularY * (curve + tremor) + self.noiseY * envelope
        dx, dy = x - self.x, y - self.y
        self.x, self.y = x, y
    end
    local amount = length(dx, dy)
    local maximum = o.maxSpeed * dt
    if amount > maximum and amount > 0 then dx *= maximum / amount; dy *= maximum / amount end
    -- User strength blends assistance; trajectory shape remains unchanged.
    return dx * o.strength, dy * o.strength
end
return HumanAim

end

-- BEGIN src/core/identity.lua
factories["core/identity"] = function()
-- Presented identities: the name every femboyware display should show for a
-- player. Mirrors kicia's Identity module (SetPresented / GetPresented).
local Identity = {}
Identity.__index = Identity
function Identity.new(app)
    local self = setmetatable({app = app, byPlayer = {}, listeners = {}}, Identity)
    local players = app.services.Players
    local function register(player)
        if not self.byPlayer[player] then
            self.byPlayer[player] = {name = player.Name, display = player.DisplayName}
        end
    end
    local function forget(player) self.byPlayer[player] = nil end
    for _, player in ipairs(players:GetPlayers()) do register(player) end
    app.scope:connect(players.PlayerAdded, register)
    app.scope:connect(players.PlayerRemoving, forget)
    app.scope:add(function() table.clear(self.byPlayer) end)
    return self
end
function Identity:onChanged(listener)
    table.insert(self.listeners, listener)
end
function Identity:changed(player)
    for _, listener in ipairs(self.listeners) do pcall(listener, player) end
end
function Identity:setPresented(player, name)
    local record = self.byPlayer[player]
    if not record or record.presented == name then return end
    record.presented = name
    self:changed(player)
end
function Identity:setPresentedDisplay(player, display)
    local record = self.byPlayer[player]
    if not record or record.presentedDisplay == display then return end
    record.presentedDisplay = display
    self:changed(player)
end
function Identity:clearPresented(player)
    local record = self.byPlayer[player]
    if not record or record.presented == nil then return end
    record.presented = nil
    self:changed(player)
end
function Identity:clearPresentedDisplay(player)
    local record = self.byPlayer[player]
    if not record or record.presentedDisplay == nil then return end
    record.presentedDisplay = nil
    self:changed(player)
end
function Identity:presented(player)
    local record = self.byPlayer[player]
    return record and record.presented or player.Name
end
function Identity:presentedDisplay(player)
    local record = self.byPlayer[player]
    return record and record.presentedDisplay or player.DisplayName
end
return Identity

end

-- BEGIN src/core/match.lua
factories["core/match"] = function()
-- Readiness gating only: once Rivals is loaded, features run everywhere,
-- including the lobby. The gate still reports a reason so the registry can
-- arm features before the game is ready and start them the moment it is.
local Match = {}
Match.__index = Match
function Match.new(app)
    local self = setmetatable({app = app, blocked = false}, Match)
    app.scheduler:add(app.scope, "Heartbeat", 0.5, function() self:refresh() end)
    self:refresh()
    return self
end
function Match:unavailable(feature)
    if not self.app.rivalsReady then return "Waiting for Rivals to load" end
    return nil
end
function Match:refresh()
    local ready = self.app.rivalsReady
    self.blocked = not ready
    self.app.registry:refresh(function()
        if not ready then return "Waiting for Rivals to load" end
        return nil
    end)
end
return Match

end

-- BEGIN src/core/options.lua
factories["core/options"] = function()
local O = {}
function O.number(key, label, default, minimum, maximum)
    return {key = key, label = label, kind = "number", default = default, min = minimum, max = maximum}
end
function O.boolean(key, label, default)
    return {key = key, label = label, kind = "boolean", default = default}
end
function O.choice(key, label, default, choices)
    return {key = key, label = label, kind = "choice", default = default, choices = choices}
end
function O.text(key, label, default)
    return {key = key, label = label, kind = "text", default = default}
end
-- Colors are stored as 6-digit hex strings so profiles stay JSON-safe.
function O.color(key, label, default)
    return {key = key, label = label, kind = "color", default = default}
end
return O

end

-- BEGIN src/core/overrides.lua
factories["core/overrides"] = function()
-- Layered property ownership: disabling one feature cannot erase another's value.
local Overrides = {}
Overrides.__index = Overrides
function Overrides.new()
    return setmetatable({objects = setmetatable({}, {__mode = "k"})}, Overrides)
end
function Overrides:set(scope, object, key, value)
    local properties = self.objects[object]
    if not properties then properties = {}; self.objects[object] = properties end
    local entry = properties[key]
    if not entry then entry = {original = object[key], layers = {}}; properties[key] = entry end
    local layer
    for _, candidate in ipairs(entry.layers) do if candidate.scope == scope then layer = candidate; break end end
    if not layer then
        layer = {scope = scope}
        table.insert(entry.layers, layer)
        scope:add(function()
            local index = table.find(entry.layers, layer)
            if index then table.remove(entry.layers, index) end
            local top = entry.layers[#entry.layers]
            pcall(function()
                if top then object[key] = top.value else object[key] = entry.original end
            end)
            if not top then
                properties[key] = nil
                if next(properties) == nil then self.objects[object] = nil end
            end
        end)
    end
    layer.value = value
    if entry.layers[#entry.layers] == layer and object[key] ~= value then object[key] = value end
    return entry.original
end
return Overrides

end

-- BEGIN src/core/registry.lua
factories["core/registry"] = function()
local Scope = require("core/scope")
local Registry = {}
Registry.__index = Registry
function Registry.new(app)
    return setmetatable({app = app, list = {}, byId = {}, listeners = {}}, Registry)
end
function Registry:add(definition)
    assert(not self.byId[definition.id], "Duplicate feature: " .. definition.id)
    definition.values = {}
    definition.enabled = false
    definition.status = "off"
    for _, option in ipairs(definition.options or {}) do definition.values[option.key] = option.default end
    self.byId[definition.id] = definition
    table.insert(self.list, definition)
    return definition
end
function Registry:emit(feature)
    for _, listener in ipairs(self.listeners) do pcall(listener, feature) end
end
function Registry:enable(id, enabled)
    local feature = assert(self.byId[id], "Unknown feature: " .. tostring(id))
    assert(type(enabled) == "boolean", "enabled must be boolean")
    if not enabled and not feature.enabled and not feature.scope then return true end
    -- A gated activation arms the feature without starting it, so its options
    -- stay configurable (e.g. setting up a skin in the lobby).
    local reason = enabled and self.app.blockReason and self.app:blockReason(feature) or nil
    if enabled and feature.enabled and (feature.scope ~= nil or reason ~= nil) then return true end
    if feature.scope then feature.scope:Destroy(); feature.scope = nil end
    feature.enabled = enabled
    feature.failed = false
    feature.status = "off"
    if enabled then
        if reason then
            feature.status = reason
        else
            local scope = Scope.new()
            feature.scope = scope
            -- Set first: callbacks can inspect activation state during startup.
            local ok, err = pcall(feature.start, scope, feature.values, self.app)
            if not ok then
                -- Stay enabled so the offending option is still visible and fixable.
                scope:Destroy(); feature.scope = nil
                feature.failed = true
                feature.status = tostring(err)
                self.app:notify(feature.name .. ": " .. feature.status)
                self:emit(feature)
                return false, feature.status
            end
            feature.status = "on"
        end
    end
    self:emit(feature)
    return true
end
-- Pause or start armed features as the gate opens and closes.
function Registry:refresh(reasonFor)
    for _, feature in ipairs(self.list) do
        if feature.enabled then
            local reason = reasonFor and reasonFor(feature) or nil
            if reason then
                if feature.scope then feature.scope:Destroy(); feature.scope = nil end
                if feature.status ~= reason then feature.status = reason; self:emit(feature) end
            elseif not feature.scope and not feature.failed then
                self:enable(feature.id, true)
            end
        end
    end
end
function Registry:set(id, key, value)
    local feature = assert(self.byId[id], "Unknown feature: " .. tostring(id))
    local option
    for _, candidate in ipairs(feature.options or {}) do if candidate.key == key then option = candidate; break end end
    assert(option, "Unknown option: " .. tostring(key))
    if option.kind == "number" then
        assert(type(value) == "number" and value == value and math.abs(value) < math.huge, "Expected finite number")
        value = math.clamp(value, option.min, option.max)
    elseif option.kind == "boolean" then assert(type(value) == "boolean", "Expected boolean")
    elseif option.kind == "choice" then assert(table.find(option.choices, value), "Invalid choice")
    elseif option.kind == "color" then assert(type(value) == "string" and value:match("^%x%x%x%x%x%x$"), "Expected a 6-digit hex color")
    else assert(type(value) == "string" and #value <= 4096, "Expected text, maximum 4096 bytes") end
    if feature.values[key] == value then return value end
    local active = feature.enabled
    local restart = not feature.live or option.restart
    if active and restart then self:enable(id, false) end
    feature.values[key] = value
    if active and restart then self:enable(id, true) else self:emit(feature) end
    return value
end
function Registry:snapshot()
    local result = {version = 1, features = {}}
    for _, feature in ipairs(self.list) do
        result.features[feature.id] = {enabled = feature.enabled, values = table.clone(feature.values)}
    end
    return result
end
-- Only known options with valid values survive; everything else is forgotten.
local function sanitized(feature, values)
    local result = {}
    if type(values) ~= "table" then return result end
    for _, option in ipairs(feature.options or {}) do
        local value = values[option.key]
        if value ~= nil then
            local ok = true
            if option.kind == "number" then
                ok = type(value) == "number" and value == value and math.abs(value) < math.huge
                    and value >= option.min and value <= option.max
            elseif option.kind == "boolean" then ok = type(value) == "boolean"
            elseif option.kind == "choice" then ok = table.find(option.choices, value) ~= nil
            elseif option.kind == "color" then ok = type(value) == "string" and value:match("^%x%x%x%x%x%x$") ~= nil
            else ok = type(value) == "string" and #value <= 4096 end
            if ok then result[option.key] = value end
        end
    end
    return result
end
function Registry:validate(data)
    assert(type(data) == "table" and data.version == 1 and type(data.features) == "table", "Unsupported profile")
    for id, saved in pairs(data.features) do
        if self.byId[id] then
            assert(type(saved) == "table" and type(saved.enabled) == "boolean" and type(saved.values) == "table", "Invalid feature profile")
        end
    end
end
function Registry:load(data)
    self:validate(data)
    for id, saved in pairs(data.features) do
        local feature = self.byId[id]
        if feature then
            self:enable(id, false)
            for key, value in pairs(sanitized(feature, saved.values)) do feature.values[key] = value end
            self:enable(id, saved.enabled)
            self:emit(feature)
        end
    end
end
function Registry:Destroy()
    for i = #self.list, 1, -1 do self:enable(self.list[i].id, false) end
    table.clear(self.listeners)
end
return Registry

end

-- BEGIN src/core/rivals.lua
factories["core/rivals"] = function()
-- All game paths and packet formats live here, away from feature lifecycle code.
local Rivals = {}
Rivals.__index = Rivals
function Rivals.new(app)
    return setmetatable({app = app, modules = {}}, Rivals)
end
function Rivals:path(root, path)
    local result = root
    for part in string.gmatch(path, "[^/]+") do
        result = result and result:FindFirstChild(part)
        if not result then return nil end
    end
    return result
end
-- Rivals is considered loaded once its core modules and controllers exist.
function Rivals:ready()
    local player = self.app.player
    if not game:IsLoaded() then return false end
    local scripts = player:FindFirstChild("PlayerScripts")
    if not scripts or not scripts:FindFirstChild("Controllers") then return false end
    local character = player.Character
    if not character or not character:FindFirstChildOfClass("Humanoid") then return false end
    local gui = player:FindFirstChild("PlayerGui")
    if not gui then return false end
    -- Same signal kicia uses: the game has pushed its HUD screens.
    local input = self.app.services.UserInputService
    local minimum = input.TouchEnabled and not input.KeyboardEnabled and 1 or 2
    local count = 0
    for _, child in ipairs(gui:GetChildren()) do
        if child:IsA("ScreenGui") then count += 1 end
    end
    if count < minimum then return false end
    return self:path(self.app.services.ReplicatedStorage, "Modules/ItemLibrary") ~= nil
        and self:path(self.app.services.ReplicatedStorage, "Modules/CosmeticLibrary") ~= nil
        and self:path(player, "PlayerScripts/Controllers/PlayerDataController") ~= nil
end
-- The lobby screen hosts MainGui.MainFrame.Lobby.Currency while a match hides it.
function Rivals:inLobby()
    local gui = self.app.player:FindFirstChild("PlayerGui")
    local main = gui and gui:FindFirstChild("MainGui")
    local frame = main and main:FindFirstChild("MainFrame")
    local lobby = frame and frame:FindFirstChild("Lobby")
    local currency = lobby and lobby:FindFirstChild("Currency")
    return currency ~= nil and currency.Visible == true
end
function Rivals:module(root, path)
    local instance = self:path(root, path)
    assert(instance and instance:IsA("ModuleScript"), "Rivals module unavailable: " .. path)
    if not self.modules[instance] then
        -- Lower the thread identity so the game module can be required.
        local restore = self.app:identity(2)
        local ok, result = pcall(require, instance)
        restore()
        assert(ok, result)
        self.modules[instance] = result
    end
    return self.modules[instance]
end
function Rivals:controller(name)
    return self:module(self.app.player, "PlayerScripts/Controllers/" .. name)
end
function Rivals:fighter()
    local controller = self:controller("FighterController")
    return controller.LocalFighter or (controller.GetFighter and controller:GetFighter(self.app.player))
end
function Rivals:remote(path)
    local remote = self:path(self.app.services.ReplicatedStorage, "Remotes/" .. path)
    assert(remote and (remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction")), "Rivals remote unavailable: " .. path)
    return remote
end
function Rivals:fire(path, ...)
    local remote = self:remote(path)
    assert(remote:IsA("RemoteEvent"), "Expected RemoteEvent: " .. path)
    remote:FireServer(...)
end
function Rivals:cameraData(part, origin, prediction)
    local utility = self:module(self.app.services.ReplicatedStorage, "Modules/Utility")
    local position = part.Position + part.AssemblyLinearVelocity * prediction
    local look = CFrame.lookAt(origin, position)
    return {[string.char(1)] = {
        [string.char(0)] = utility:EncodeCFrame(look),
        [string.char(1)] = utility:EncodeCFrame(look),
        [string.char(2)] = part,
        [string.char(3)] = utility:EncodeCFrame(part.CFrame:ToObjectSpace(CFrame.new(position))),
    }}
end
function Rivals:enum(name)
    return self:module(self.app.services.ReplicatedStorage, "Modules/EnumLibrary"):ToEnum(name)
end
return Rivals

end

-- BEGIN src/core/scheduler.lua
factories["core/scheduler"] = function()
-- One engine connection per active phase, independent of the feature count.
local Scheduler = {}
Scheduler.__index = Scheduler
function Scheduler.new(runService, report)
    return setmetatable({service = runService, report = report, phases = {}, count = 0}, Scheduler)
end
function Scheduler:add(scope, phase, interval, callback)
    local state = self.phases[phase]
    if not state then
        state = {jobs = {}, scratch = {}}
        self.phases[phase] = state
    end
    local job = {interval = interval, elapsed = 0, callback = callback, alive = true, errors = 0}
    table.insert(state.jobs, job)
    self.count += 1
    if not state.connection then
        state.connection = self.service[phase]:Connect(function(first, second)
            local dt = phase == "Stepped" and second or first
            -- Snapshot allows a failing job to disable its owner during dispatch.
            -- The scratch table is reused so dispatch does not allocate.
            local jobs, scratch = state.jobs, state.scratch
            table.clear(scratch)
            for index = 1, #jobs do scratch[index] = jobs[index] end
            for index = 1, #scratch do
                local current = scratch[index]
                if current.alive then
                    current.elapsed += dt
                    if current.interval == 0 or current.elapsed >= current.interval then
                        local elapsed = current.elapsed
                        current.elapsed = current.interval > 0 and current.elapsed % current.interval or 0
                        local ok, err = pcall(current.callback, elapsed)
                        if not ok then
                            current.errors += 1
                            if current.errors == 1 then self.report(tostring(err)) end
                        else current.errors = 0 end
                    end
                end
            end
        end)
    end
    scope:add(function()
        if not job.alive then return end
        job.alive = false
        self.count -= 1
        local index = table.find(state.jobs, job)
        if index then table.remove(state.jobs, index) end
        if #state.jobs == 0 and state.connection then
            state.connection:Disconnect()
            state.connection = nil
        end
    end)
    return job
end
return Scheduler

end

-- BEGIN src/core/scope.lua
factories["core/scope"] = function()
-- Every enabled feature owns one scope. Cleaning it is safe more than once.
local Scope = {}
Scope.__index = Scope
function Scope.new()
    return setmetatable({items = {}, alive = true}, Scope)
end
local function dispose(item)
    local kind = typeof(item)
    if kind == "function" then item()
    elseif kind == "RBXScriptConnection" then item:Disconnect()
    elseif kind == "Instance" then item:Destroy()
    elseif kind == "thread" then task.cancel(item)
    elseif type(item) == "table" then
        if item.Destroy then item:Destroy() elseif item.Disconnect then item:Disconnect() end
    end
end
function Scope:add(item)
    if self.alive then table.insert(self.items, item) else pcall(dispose, item) end
    return item
end
function Scope:connect(signal, callback)
    return self:add(signal:Connect(function(...)
        if self.alive then callback(...) end
    end))
end
function Scope:Destroy()
    if not self.alive then return end
    self.alive = false
    for i = #self.items, 1, -1 do pcall(dispose, self.items[i]) end
    table.clear(self.items)
end
return Scope

end

-- BEGIN src/core/ui.lua
factories["core/ui"] = function()
-- Linoria (mstudio45 fork) owns presentation; the registry owns feature state.
local UI = {}
function UI.mount(app)
    local Library = require("vendor/LinoriaLib")
    app.library = Library
    local environment = getgenv()
    local registry, syncing = app.registry, false
    -- Only phones get Linoria's floating "Toggle UI"/"Lock UI" buttons. Executors
    -- often report a mobile platform on desktop, so trust the real input hardware.
    local input = app.services.UserInputService
    local mobile = input.TouchEnabled and not input.KeyboardEnabled and not input.MouseEnabled
    Library.IsMobile = mobile
    Library.AccentColor = Color3.fromRGB(239, 152, 194)
    Library.AccentColorDark = Library:GetDarkerColor(Library.AccentColor)
    Library.NotifyOnError = true
    -- Register cleanup immediately, including failures during menu construction.
    local unloading = false
    app.scope:add(function()
        app.onNotify = nil
        app.setMenuOpen = nil
        if not unloading then unloading = true; Library:Unload() end
        if environment.Library == Library or environment.Linoria == Library then
            environment.Library = nil
            environment.Linoria = nil
        end
        app.library = nil
    end)
    Library:OnUnload(function()
        if not unloading then unloading = true; app:Unload() end
    end)
    local window = Library:CreateWindow({Title = "femboyware :3 | Rivals", Center = true, AutoShow = false,
        TabPadding = 2, MenuFadeTime = 0, Size = UDim2.fromOffset(880, 660)})
    local options = Library.Options
    local originalToggle = Library.Toggle
    Library.Toggle = function(...)
        local result = originalToggle(...)
        app.menuOpen = window.Holder.Visible
        return result
    end
    -- Library.Toggle ignores its receiver, so never use the method form here.
    app.setMenuOpen = function(open)
        if window.Holder.Visible ~= open then Library.Toggle(open) end
    end
    app.scope:connect(window.Holder:GetPropertyChangedSignal("Visible"), function() app.menuOpen = window.Holder.Visible end)
    -- Desktop drag: the library drags via the legacy Mouse object, which some
    -- executors break, so drive it from UserInputService. Mobile keeps the
    -- library's touch dragging (and its Toggle UI / Lock UI buttons).
    if not mobile then
        Library.CantDragForced = true
        local holder = window.Holder
        local dragging, dragStart, startPosition = false, nil, nil
        app.scope:connect(input.InputBegan, function(event)
            if not holder.Visible then return end
            local kind = event.UserInputType
            if kind ~= Enum.UserInputType.MouseButton1 and kind ~= Enum.UserInputType.Touch then return end
            local position, topLeft, size = event.Position, holder.AbsolutePosition, holder.AbsoluteSize
            if position.X >= topLeft.X and position.X <= topLeft.X + size.X
                and position.Y >= topLeft.Y and position.Y <= topLeft.Y + 26 then
                dragging, dragStart, startPosition = true, position, holder.Position
            end
        end)
        app.scope:connect(input.InputChanged, function(event)
            if not dragging then return end
            local kind = event.UserInputType
            if kind ~= Enum.UserInputType.MouseMovement and kind ~= Enum.UserInputType.Touch then return end
            local delta = event.Position - dragStart
            holder.Position = UDim2.new(startPosition.X.Scale, startPosition.X.Offset + delta.X,
                startPosition.Y.Scale, startPosition.Y.Offset + delta.Y)
        end)
        app.scope:connect(input.InputEnded, function(event)
            if event.UserInputType == Enum.UserInputType.MouseButton1 or event.UserInputType == Enum.UserInputType.Touch then dragging = false end
        end)
    end
    app.onNotify = function(message) Library:Notify(message, 6) end
    local function safely(callback)
        return function(...)
            if syncing or app.destroyed then return end
            local ok, err = pcall(callback, ...)
            if not ok then app:notify(tostring(err)) end
        end
    end
    local function hex(color) return color:ToHex():upper() end
    local tabs, counts, updates = {}, {}, {}
    for _, feature in ipairs(registry.list) do
        local category = feature.category
        if not tabs[category] then tabs[category] = window:AddTab(category); counts[category] = 0 end
        counts[category] += 1
        local tab = tabs[category]
        local group = counts[category] % 2 == 1 and tab:AddLeftGroupbox(feature.name) or tab:AddRightGroupbox(feature.name)
        if feature.description then group:AddLabel(feature.description, true) end
        local prefix = "fw_" .. feature.id
        local enabled = group:AddToggle(prefix, {Text = "Enabled", Default = false})
        enabled:AddKeyPicker(prefix .. "_bind", {Default = "None", SyncToggleState = true, Mode = "Toggle", Text = feature.name})
        enabled:OnChanged(safely(function() registry:enable(feature.id, enabled.Value) end))
        local status = group:AddLabel("off", true)
        -- Hide per-feature options until the feature is on, so the menu stays readable.
        local body = group:AddDependencyBox()
        local controls = {}
        for _, option in ipairs(feature.options or {}) do
            local id = prefix .. "_" .. option.key
            local control, sync
            if option.kind == "boolean" then
                control = body:AddToggle(id, {Text = option.label, Default = option.default, Tooltip = option.tooltip})
                control:OnChanged(safely(function()
                    if feature.values[option.key] ~= control.Value then registry:set(feature.id, option.key, control.Value) end
                end))
                sync = function() if control.Value ~= feature.values[option.key] then control:SetValue(feature.values[option.key]) end end
            elseif option.kind == "number" then
                control = body:AddSlider(id, {Text = option.label, Default = option.default, Min = option.min, Max = option.max,
                    Rounding = option.max <= 5 and 2 or option.max <= 60 and 1 or 0, Compact = false, Tooltip = option.tooltip})
                control:OnChanged(safely(function()
                    if feature.values[option.key] ~= control.Value then registry:set(feature.id, option.key, control.Value) end
                end))
                sync = function() if control.Value ~= feature.values[option.key] then control:SetValue(feature.values[option.key]) end end
            elseif option.kind == "choice" then
                control = body:AddDropdown(id, {Text = option.label, Values = option.choices, Default = option.default,
                    Multi = false, Tooltip = option.tooltip})
                control:OnChanged(safely(function()
                    if feature.values[option.key] ~= control.Value then registry:set(feature.id, option.key, control.Value) end
                end))
                sync = function() if control.Value ~= feature.values[option.key] then control:SetValue(feature.values[option.key]) end end
            elseif option.kind == "color" then
                -- The fork's AddColorPicker returns its parent label; the picker lives in Options.
                body:AddLabel(option.label):AddColorPicker(id, {Default = Color3.fromHex(option.default)})
                control = options[id]
                control:OnChanged(safely(function()
                    local value = hex(control.Value)
                    if feature.values[option.key] ~= value then registry:set(feature.id, option.key, value) end
                end))
                sync = function() if control.Value ~= Color3.fromHex(feature.values[option.key]) then control:SetValueRGB(Color3.fromHex(feature.values[option.key])) end end
            else
                control = body:AddInput(id, {Text = option.label, Default = option.default, Finished = true, MaxLength = 4096, Tooltip = option.tooltip})
                control:OnChanged(safely(function()
                    if feature.values[option.key] ~= control.Value then registry:set(feature.id, option.key, control.Value) end
                end))
                sync = function() if control.Value ~= feature.values[option.key] then control:SetValue(feature.values[option.key]) end end
            end
            controls[option.key] = sync
        end
        -- Features with bespoke controls extend their own body after the options.
        if feature.mount then feature.mount(body, Library, safely) end
        body:SetupDependencies({{enabled, true}})
        updates[feature] = function()
            syncing = true
            local ok, err = pcall(function()
                if enabled.Value ~= feature.enabled then enabled:SetValue(feature.enabled) end
                for key, sync in pairs(controls) do sync() end
                status:SetText(feature.status)
            end)
            syncing = false
            if not ok then app:notify(tostring(err)) end
        end
    end
    table.insert(registry.listeners, function(feature) if updates[feature] then updates[feature]() end end)
    local settings = window:AddTab("Settings")
    local menu = settings:AddLeftGroupbox("Menu")
    menu:AddLabel("Menu key"):AddKeyPicker("fw_menu", {Default = "RightShift", NoUI = true, Text = "Menu"})
    Library.ToggleKeybind = options.fw_menu
    menu:AddButton({Text = "Disable all features", Func = function()
        for _, feature in ipairs(registry.list) do registry:enable(feature.id, false) end
        app:notify("All features disabled")
    end})
    menu:AddButton({Text = "Unload", Func = function() app:Unload() end})
    local profiles = settings:AddRightGroupbox("Configs")
    local configName = profiles:AddInput("fw_profile", {Text = "Config name", Default = "default", Finished = true})
    local configList = profiles:AddDropdown("fw_config_list", {Text = "Saved configs", Values = {"(none)"}, Default = "(none)",
        Searchable = true, AllowNull = true, Tooltip = "Every config saved in your executor's workspace."})
    local function refreshConfigs()
        local files = app:listProfiles()
        if #files == 0 then
            configList:SetValues({"(none)"}); configList:SetValue("(none)")
        else
            configList:SetValues(files)
            if not table.find(files, configList.Value) then configList:SetValue(files[1]) end
        end
    end
    configList:OnChanged(safely(function()
        if configList.Value and configList.Value ~= "(none)" then configName:SetValue(configList.Value) end
    end))
    profiles:AddButton({Text = "Save config", Func = safely(function() app:saveProfile(configName.Value); refreshConfigs(); app:notify("Saved config '" .. configName.Value .. "'") end)})
    profiles:AddButton({Text = "Load config", Func = safely(function() app:loadProfile(configName.Value); app:notify("Loaded config '" .. configName.Value .. "'") end)})
    profiles:AddButton({Text = "Delete config", Func = safely(function() app:deleteProfile(configName.Value); refreshConfigs(); app:notify("Deleted config '" .. configName.Value .. "'") end)})
    profiles:AddButton({Text = "Refresh list", Func = safely(refreshConfigs)})
    local automatic = profiles:AddToggle("fw_autoload", {Text = "Auto load on execute", Default = app.settings.autoLoad})
    automatic:OnChanged(safely(function() app.settings.autoLoad = automatic.Value; app:saveSettings() end))
    local automaticName = profiles:AddInput("fw_autoload_name", {Text = "Config to auto load", Default = app.settings.autoLoadName, Finished = true})
    automaticName:OnChanged(safely(function() app.settings.autoLoadName = automaticName.Value; app:saveSettings() end))
    refreshConfigs()
    local recordings = settings:AddRightGroupbox("Movement recordings")
    recordings:AddInput("fw_recording", {Text = "Recording name", Default = "route", Finished = true})
    recordings:AddButton({Text = "Save recording", Func = safely(function() app:saveRecording(options.fw_recording.Value); app:notify("Recording saved") end)})
    recordings:AddButton({Text = "Load recording", Func = safely(function() app:loadRecording(options.fw_recording.Value); app:notify("Recording loaded") end)})
    local credit = settings:AddLeftGroupbox("Credit")
    credit:AddLabel("femboyware v" .. app.version .. " :3", true)
    credit:AddLabel("Menu by LinoriaLib (MIT).", true)
    -- Linoria keeps the tab strip scrollable, so no manual reflow is needed.
    if mobile then
        local opener = Instance.new("TextButton")
        opener.Name = "FemboywareMenu"; opener.Text = "fw :3"; opener.Size = UDim2.fromOffset(65, 32)
        opener.Position = UDim2.fromOffset(8, 8); opener.TextSize = 14; opener.BackgroundColor3 = Library.MainColor
        opener.TextColor3 = Library.AccentColor; opener.Parent = Library.ScreenGui
        app.scope:connect(opener.Activated, function() Library.Toggle() end)
    end
end
return UI

end

-- BEGIN src/features/automation.lua
factories["features/automation"] = function()
local O = require("core/options")
local Scope = require("core/scope")
return function(app)
    local registry = app.registry
    registry:add({id = "queue", name = "Auto Queue", category = "Automation", options = {
        O.text("queue", "Queue identifier", "1v1"), O.number("interval", "Retry interval (s)", 5, 3, 60),
    }, start = function(scope, values)
        local controller = app.rivals:controller("MatchmakingController")
        assert(type(controller.QueueInto) == "function", "MatchmakingController.QueueInto unavailable")
        local function queue() controller:QueueInto(values.queue) end
        queue()
        app.scheduler:add(scope, "Heartbeat", values.interval, queue)
        scope:add(function()
            local remote = app.rivals:path(app.services.ReplicatedStorage, "Remotes/Matchmaking/LeaveQueue")
            if remote and remote:IsA("RemoteEvent") then remote:FireServer() end
        end)
    end})
    registry:add({id = "respawn", name = "Auto Respawn", category = "Automation", start = function(scope)
        local remote = app.rivals:remote("Duels/RespawnNow")
        local characterScope
        local function bind(character)
            if characterScope then characterScope:Destroy() end
            characterScope = Scope.new()
            local bound
            local function attach()
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if not humanoid or humanoid == bound then return end
                bound = humanoid
                characterScope:connect(humanoid.Died, function() if scope.alive then remote:FireServer() end end)
            end
            attach(); characterScope:connect(character.ChildAdded, attach)
        end
        if app.player.Character then bind(app.player.Character) end
        scope:connect(app.player.CharacterAdded, bind)
        scope:add(function() if characterScope then characterScope:Destroy() end end)
    end})
    registry:add({id = "vote", name = "Auto Map / Weapon Vote", category = "Automation", options = {
        O.text("choices", "Choices, comma separated", "Arena"), O.number("interval", "Vote interval (s)", 2, 1, 30),
    }, start = function(scope, values)
        local remote = app.rivals:remote("Duels/Vote")
        local choices = {}
        for choice in values.choices:gmatch("[^,]+") do
            local trimmed = choice:match("^%s*(.-)%s*$")
            if #trimmed > 0 then table.insert(choices, trimmed) end
        end
        assert(#choices > 0, "Enter at least one vote choice")
        local index = 1
        app.scheduler:add(scope, "Heartbeat", values.interval, function()
            remote:FireServer(choices[index]); index = index % #choices + 1
        end)
    end})
    registry:add({id = "loadout", name = "Auto Loadout", category = "Automation", options = {
        O.text("primary", "Primary", "Assault Rifle"), O.text("secondary", "Secondary", "Handgun"),
        O.text("melee", "Melee", "Knife"), O.text("utility", "Utility", "Grenade"),
        O.number("interval", "Apply interval (s)", 3, 1, 30),
    }, start = function(scope, values)
        local remote = app.rivals:remote("Replication/Fighter/PickWeapons")
        local function apply() remote:FireServer({values.primary, values.secondary, values.melee, values.utility}) end
        apply(); app.scheduler:add(scope, "Heartbeat", values.interval, apply)
    end})
    registry:add({id = "pickup", name = "Auto Pickup", category = "Automation", options = {
        O.number("distance", "Pickup range", 15, 1, 200), O.boolean("health", "Health drops", true), O.boolean("ammo", "Ammo drops", true),
    }, start = function(scope, values)
        local touch = app:capability("firetouchinterest")
        assert(touch, "Executor does not expose firetouchinterest")
        local drops = {}
        local function add(object) if object:IsA("BasePart") and object.Name == "_drop" then drops[object] = true end end
        for _, object in ipairs(workspace:GetChildren()) do add(object) end
        scope:connect(workspace.ChildAdded, add)
        scope:connect(workspace.ChildRemoved, function(object) drops[object] = nil end)
        app.scheduler:add(scope, "Heartbeat", 0.2, function()
            local root, humanoid = app:character()
            if not root or not humanoid then return end
            for drop in pairs(drops) do
                if (drop.Position - root.Position).Magnitude <= values.distance and (
                    values.health and drop:FindFirstChild("Health") and humanoid.Health < humanoid.MaxHealth
                    or values.ammo and drop:FindFirstChild("Ammo")) then
                    touch(root, drop, 0); touch(root, drop, 1)
                end
            end
        end)
    end})
    registry:add({id = "device", name = "Device Spoof", category = "Player", options = {
        O.choice("mode", "Device", "MouseKeyboard", {"Touch", "Gamepad", "MouseKeyboard", "VR"}),
    }, start = function(scope, values)
        local remote = app.rivals:remote("Replication/Fighter/SetControls")
        local input = app.services.UserInputService
        local original = input.TouchEnabled and "Touch" or input.GamepadEnabled and not input.KeyboardEnabled and "Gamepad" or "MouseKeyboard"
        if app.services.VRService.VREnabled then original = "VR" end
        scope:add(function() remote:FireServer(original) end)
        remote:FireServer(values.mode)
        scope:connect(app.player.CharacterAdded, function() remote:FireServer(values.mode) end)
    end})
    registry:add({id = "chat", name = "Chat Messages", category = "Automation", options = {
        O.text("message", "Message", ":3"), O.number("interval", "Interval (s)", 15, 5, 120),
    }, start = function(scope, values)
        local channels = app.services.TextChatService:FindFirstChild("TextChannels")
        local channel = channels and channels:FindFirstChild("RBXGeneral")
        assert(channel, "RBXGeneral text channel unavailable")
        app.scheduler:add(scope, "Heartbeat", values.interval, function() channel:SendAsync(values.message) end)
    end})
    registry:add({id = "detector", live = true, name = "Movement Anomaly Detector", category = "Automation", options = {
        O.number("speed", "Speed threshold", 140, 30, 1000), O.number("cooldown", "Notification cooldown (s)", 20, 5, 120),
    }, start = function(scope, values)
        local samples, notified = {}, {}
        app.scheduler:add(scope, "Heartbeat", 0.5, function()
            local now = os.clock()
            for entry in pairs(samples) do if not app.entities.players[entry.player] then samples[entry] = nil; notified[entry] = nil end end
            for _, entry in ipairs(app.entities.list) do
                if entry.root then
                    local old = samples[entry]
                    if old and entry.character == old.character and now - old.time > 0 then
                        local speed = (entry.root.Position - old.position).Magnitude / (now - old.time)
                        if speed > values.speed and now - (notified[entry] or -math.huge) >= values.cooldown then
                            app:notify(entry.player.DisplayName .. ": movement anomaly (teleports can also trigger this)")
                            notified[entry] = now
                        end
                    end
                    samples[entry] = {position = entry.root.Position, time = now, character = entry.character}
                end
            end
        end)
    end})
end

end

-- BEGIN src/features/combat.lua
factories["features/combat"] = function()
local O = require("core/options")
return function(app)
    local registry = app.registry
    local function options(extra)
        local list = {
            O.number("fov", "FOV radius (px)", 150, 1, 2000),
            O.number("distance", "Maximum distance", 2000, 1, 10000),
            O.boolean("visible", "Visible targets only", true),
            O.boolean("team", "Team check", true),
            O.boolean("lock", "Keep target lock", true),
            O.choice("hitbox", "Hitbox", "Head", {"Head", "UpperTorso", "Root", "Random"}),
            O.choice("priority", "Priority", "Crosshair", {"Crosshair", "Distance"}),
            O.choice("origin", "FOV origin", "Center", {"Center", "Mouse"}),
            O.number("prediction", "Velocity prediction (s)", 0, 0, 1),
            O.boolean("environment", "Same match only", true),
        }
        for _, option in ipairs(extra or {}) do table.insert(list, option) end
        return list
    end
    local function part(target, values)
        if values.hitbox == "Root" then return target.root end
        if values.hitbox == "UpperTorso" then
            return target.character and (target.character:FindFirstChild("UpperTorso") or target.character:FindFirstChild("Torso")) or target.head or target.root
        end
        if values.hitbox == "Random" then return (math.random() < 0.5 and target.head) or target.root end
        return target.head or target.root
    end
    local function allowed(hold)
        return not app.menuOpen and not app.services.UserInputService:GetFocusedTextBox()
            and (not hold or app.services.UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2))
    end
    registry:add({id = "aim", live = true, name = "Aimbot", category = "Combat", options = options({
        O.choice("activation", "Activation", "Right mouse", {"Always", "Right mouse", "Left mouse"}),
        O.number("reaction", "Reaction delay (s)", 0.05, 0, 1),
        O.number("smooth", "Smoothness (higher = snappier)", 14, 1, 60),
        O.boolean("mouse", "Move mouse instead of camera", false),
        O.number("switchDelay", "Target switch delay (s)", 0.1, 0, 1),
    }), start = function(scope, values)
        local input = app.services.UserInputService
        local move = app:capability("mousemoverel")
        if values.mouse and not move then app:notify("No mousemoverel here, using camera aim") end
        local useMouse = values.mouse and move ~= nil
        local target, acquired, lastSwitch = nil, -math.huge, -math.huge
        local function held()
            if values.activation == "Always" then return true end
            if values.activation == "Right mouse" then return input:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) end
            return input:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
        end
        app.scheduler:add(scope, "RenderStepped", 0, function(dt)
            local camera = workspace.CurrentCamera
            if not camera or app.menuOpen or input:GetFocusedTextBox() or not held() then
                target = nil; app.target = nil; return
            end
            local now = os.clock()
            local nextTarget = app.entities:target(values, values.lock and target or nil)
            if nextTarget ~= target then
                if target and nextTarget and now - lastSwitch < values.switchDelay then nextTarget = target end
                target = nextTarget
                lastSwitch = now
                acquired = now + values.reaction
            end
            app.target = target
            if not target or now < acquired then return end
            local hit = part(target, values)
            if not hit then return end
            local goal = hit.Position + hit.AssemblyLinearVelocity * values.prediction
            if useMouse then
                local point, onScreen = camera:WorldToViewportPoint(goal)
                if onScreen then
                    local delta = Vector2.new(point.X, point.Y) - camera.ViewportSize / 2
                    local factor = math.clamp(values.smooth * dt, 0, 1)
                    move(delta.X * factor, delta.Y * factor)
                end
            else
                local aim = CFrame.lookAt(camera.CFrame.Position, goal)
                local factor = values.smooth <= 1 and 1 or math.clamp(values.smooth * dt, 0, 1)
                camera.CFrame = camera.CFrame:Lerp(aim, factor)
            end
        end)
        scope:add(function() app.target = nil end)
    end})
    registry:add({id = "trigger", live = true, name = "Triggerbot", category = "Combat", options = {
        O.number("reaction", "Reaction delay (s)", 0.08, 0, 2),
        O.number("release", "Keep firing after losing target (s)", 0.08, 0, 1),
        O.boolean("team", "Team check", true), O.boolean("hold", "Hold right mouse", false),
    }, start = function(scope, values)
        local input, gui = app.services.UserInputService, app.services.GuiService
        local click = app:capability("mouse1click")
        local params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Exclude
        -- Fire through the game's own input path; mouse1click alone does nothing in most executors.
        local function fire()
            local ok, fighter = pcall(app.rivals.fighter, app.rivals)
            if ok and fighter then
                local function field(object, key)
                    if type(object) ~= "table" then return nil end
                    local success, value = pcall(function() return object[key] end)
                    return success and value or nil
                end
                local inner = field(fighter, "Inner")
                for _, object in ipairs({fighter, field(fighter, "FighterState"), inner, field(inner, "FighterState")}) do
                    local method = field(object, "Input")
                    if type(method) == "function" and pcall(method, object, "StartShooting") then return end
                end
            end
            if click then click() end
        end
        local since, release = nil, 0
        app.scheduler:add(scope, "Heartbeat", 0, function(dt)
            if not allowed(values.hold) then since, release = nil, 0; return end
            local camera = workspace.CurrentCamera
            if not camera then return end
            local filter = {camera}
            if app.player.Character then table.insert(filter, app.player.Character) end
            params.FilterDescendantsInstances = filter
            local mouse = input:GetMouseLocation()
            local ray = camera:ViewportPointToRay(mouse.X, mouse.Y)
            local hit = workspace:Raycast(ray.Origin, ray.Direction * 2000, params)
            local onTarget = false
            if hit then
                for _, entry in ipairs(app.entities.list) do
                    if entry.character and hit.Instance:IsDescendantOf(entry.character)
                        and entry.humanoid and entry.humanoid.Health > 0 and (not values.team or app.entities:enemy(entry)) then onTarget = true; break end
                end
            end
            if onTarget then
                since = (since or 0) + dt
                if since >= values.reaction then release = values.release; fire() end
            else
                since = nil
                release = math.max(0, release - dt)
                if release > 0 then fire() end
            end
        end)
    end})
    registry:add({id = "silent", live = true, name = "Silent Aim", category = "Combat", options = options({
        O.number("chance", "Activation chance (%)", 100, 0, 100),
    }), start = function(scope, values)
        local hook = app:capability("hookfunction")
        assert(hook, "Executor does not expose hookfunction")
        local remote = app.rivals:remote("Replication/Fighter/UseItem")
        local shooting = app.rivals:enum("StartShooting")
        -- Resolve required encoding before installing any hook.
        app.rivals:module(app.services.ReplicatedStorage, "Modules/Utility")
        local target, original
        app.scheduler:add(scope, "Heartbeat", 1 / 30, function()
            target = allowed(false) and app.entities:target(values, target) or nil
        end)
        local function intercept(self, objectId, action, cameraData, ...)
            if scope.alive and self == remote and action == shooting and target and allowed(false)
                and math.random() * 100 < values.chance then
                local hit = part(target, values)
                local camera = workspace.CurrentCamera
                if hit and hit.Parent and camera then
                    local ok, data = pcall(app.rivals.cameraData, app.rivals, hit, camera.CFrame.Position, values.prediction)
                    if ok then cameraData = data end
                end
            end
            return original(self, objectId, action, cameraData, ...)
        end
        local closure = app:capability("newcclosure")
        original = hook(remote.FireServer, closure and closure(intercept) or intercept)
        scope:add(function() hook(remote.FireServer, original) end)
    end})
    registry:add({id = "weapons", live = true, name = "Weapon Overrides", category = "Combat", options = {
        O.boolean("recoil", "Remove recoil", true), O.boolean("spread", "Remove spread", true),
        O.number("rate", "Fire rate multiplier", 1, 0.1, 20),
        O.boolean("projectile", "Fast projectiles", false),
        O.boolean("jumps", "Infinite weapon double jumps", false),
    }, start = function(scope, values)
        app.rivals:controller("FighterController")
        local originals = setmetatable({}, {__mode = "k"})
        app.scheduler:add(scope, "Heartbeat", 0.1, function()
            local fighter = app.rivals:fighter()
            local item = fighter and fighter.EquippedItem
            local info = item and item.Info
            if type(info) ~= "table" then return end
            if not originals[info] then
                originals[info] = table.clone(info)
            end
            local initial = originals[info]
            local function set(key, value)
                if initial[key] ~= nil then app.overrides:set(scope, info, key, value) end
            end
            if values.recoil then set("ShootRecoil", 0) end
            if values.spread then set("ShootSpread", 0) end
            if values.projectile then set("ProjectileSpeed", 99999999) end
            if values.jumps then set("MaxDoubleJumps", math.huge) end
            for _, key in ipairs({"ShootCooldown", "QuickShotCooldown", "BurstCooldown", "AttackCooldown"}) do
                if type(initial[key]) == "number" then set(key, initial[key] / values.rate) end
            end
        end)
    end})
    registry:add({id = "flick", live = true, name = "Flickbot", category = "Combat", options = options({
        O.boolean("instant", "Instant flick", true),
        O.number("smooth", "Flick duration (s)", 0.06, 0.01, 0.5),
        O.boolean("onlyVisible", "Require visible target", true),
    }), start = function(scope, values)
        local input = app.services.UserInputService
        local pressed, goal = false, nil
        app.scheduler:add(scope, "RenderStepped", 0, function(dt)
            local camera = workspace.CurrentCamera
            if not camera then return end
            local down = input:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
            -- A rising edge flicks onto the best target once; holding does not track.
            if down and not pressed and not app.menuOpen and not input:GetFocusedTextBox() then
                local target = app.entities:target(values, nil)
                local hit = target and part(target, values)
                if hit then goal = CFrame.lookAt(camera.CFrame.Position, hit.Position + hit.AssemblyLinearVelocity * values.prediction) end
            end
            pressed = down
            if not goal then return end
            if values.instant then
                camera.CFrame = goal
                goal = nil
            else
                camera.CFrame = camera.CFrame:Lerp(goal, math.clamp(dt / values.smooth, 0, 1))
                if camera.CFrame.LookVector:Dot(goal.LookVector) > 0.9995 then goal = nil end
            end
        end)
    end})
    registry:add({id = "antikatana", name = "Anti Katana", category = "Combat", description = "Blocks your shot while the enemy you are aiming at is deflecting.", start = function(scope)
        local hook, closure = app:capability("hookfunction"), app:capability("newcclosure")
        assert(hook, "Executor does not expose hookfunction")
        local input = app.services.UserInputService
        local deflecting = {}
        local remote = app.rivals:remote("Replication/Fighter/UseItem")
        local shooting = app.rivals:enum("StartShooting")
        -- Watch the katana class to learn when a remote player starts deflecting.
        local items = app.rivals:path(app.player, "PlayerScripts/Modules/Items")
        local katana = items and items:FindFirstChild("Katana")
        if katana then
            local class = app.rivals:module(items, "Katana")
            local meta = getmetatable(class)
            local holder = type(rawget(class, "ReplicateFromServer")) == "function" and class
                or (type(meta) == "table" and type(rawget(meta, "ReplicateFromServer")) == "function" and meta) or nil
            if holder then
                local original = holder.ReplicateFromServer
                local function intercept(self, action, ...)
                    if scope.alive and self and self.Name == "Katana" then
                        local text = tostring(action):lower()
                        if text:find("deflect", 1, true) or text == "startblocking" or text == "startaiming" then
                            local fighter = rawget(self, "ClientFighter") or self.ClientFighter
                            local player = fighter and fighter.Player
                            if player and player ~= app.player then
                                local duration = (self.Info and self.Info.DeflectDuration) or 1
                                deflecting[player.UserId] = os.clock() + duration + 0.12
                            end
                        end
                    end
                    return original(self, action, ...)
                end
                holder.ReplicateFromServer = closure and closure(intercept) or intercept
                scope:add(function() pcall(function() holder.ReplicateFromServer = original end) end)
            end
        else
            app:notify("Anti Katana: katana module not found")
        end
        -- Block the shot only when the player under your crosshair is deflecting.
        local params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Exclude
        local function aimingAtDeflector()
            local camera = workspace.CurrentCamera
            if not camera then return false end
            local mouse = input:GetMouseLocation()
            local ray = camera:ViewportPointToRay(mouse.X, mouse.Y)
            local filter = {camera}
            if app.player.Character then table.insert(filter, app.player.Character) end
            params.FilterDescendantsInstances = filter
            local hit = workspace:Raycast(ray.Origin, ray.Direction * 2000, params)
            local character = hit and hit.Instance:FindFirstAncestorOfClass("Model")
            local player = character and app.services.Players:GetPlayerFromCharacter(character)
            local expire = player and deflecting[player.UserId]
            return expire ~= nil and os.clock() < expire
        end
        local originalFire
        local function intercept(self, objectId, action, ...)
            if scope.alive and self == remote and action == shooting and aimingAtDeflector() then return end
            return originalFire(self, objectId, action, ...)
        end
        originalFire = hook(remote.FireServer, closure and closure(intercept) or intercept)
        scope:add(function() pcall(hook, remote.FireServer, originalFire) end)
    end})
end

end

-- BEGIN src/features/cosmetics.lua
factories["features/cosmetics"] = function()
local O = require("core/options")
local kinds = {"Skin", "Wrap", "Charm", "Finisher"}
local function normalize(name) return tostring(name):lower():gsub("[%W_]", "") end
-- Comma-separated option text; an empty list allows every value.
local function parseList(text)
    local result = {}
    for value in tostring(text):gmatch("[^,]+") do
        local trimmed = value:match("^%s*(.-)%s*$")
        if #trimmed > 0 then result[trimmed:lower()] = true end
    end
    return result
end
local function allows(set, value)
    if next(set) == nil then return true end
    return set[tostring(value or ""):lower()] == true
end
return function(app)
    local service = {selections = {}, revision = 0}
    app.skinchanger = service
    function service:catalog()
        return app.rivals:module(app.services.ReplicatedStorage, "Modules/CosmeticLibrary").Cosmetics
    end
    function service:weapons()
        local library = app.rivals:module(app.services.ReplicatedStorage, "Modules/ItemLibrary")
        local result = {}
        for name in pairs(library.Items or {}) do table.insert(result, name) end
        table.sort(result)
        return result
    end
    function service:list(weapon, kind, query)
        local result = {"None"}
        for name, data in pairs(self:catalog()) do
            if type(data) == "table" and data.Type == kind then
                local owner = data.ItemName or data.WeaponName or data.Weapon or data.Item
                if (not owner and kind ~= "Skin" or tostring(owner):lower() == weapon:lower())
                    and (not query or name:lower():find(query:lower(), 1, true)) then table.insert(result, name) end
            end
        end
        table.sort(result, function(a, b) if a == "None" then return true elseif b == "None" then return false else return a:lower() < b:lower() end end)
        return result
    end
    function service:selection(weapon, kind)
        local entry = self.selections[weapon]
        local name = entry and entry[kind]
        if not name or name == "None" then return nil end
        local source = self:catalog()[name]
        if not source then return nil end
        local result = table.clone(source)
        result.Name = name; result.Type = kind; result.Owned = true; result.Unlocked = true; result.Locked = false
        result.Seed = entry.seed or 1; result.Inverted = entry.inverted == true
        return result
    end
    function service:apply(weapon, choices, seed, inverted)
        assert(type(weapon) == "string" and table.find(self:weapons(), weapon), "Choose a valid weapon")
        local selected = {seed = math.floor(seed), inverted = inverted == true}
        for _, kind in ipairs(kinds) do
            local name = choices[kind]
            assert(name == nil or table.find(self:list(weapon, kind), name), "Cosmetic does not match weapon: " .. tostring(name))
            if name and name ~= "None" then selected[kind] = name end
        end
        self.selections[weapon] = selected
        self.revision += 1
    end
    app.profileParts.cosmetics = {
        save = function() return service.selections end,
        validate = function(data)
            assert(type(data) == "table", "Invalid cosmetic selections")
            local count = 0
            for weapon, selected in pairs(data) do
                count += 1
                assert(count <= 200 and type(weapon) == "string" and #weapon <= 128 and type(selected) == "table", "Invalid cosmetic entry")
                for key, value in pairs(selected) do
                    if key == "seed" then assert(type(value) == "number" and value == value and value >= 1 and value <= 1000000 and value % 1 == 0, "Invalid cosmetic seed")
                    elseif key == "inverted" then assert(type(value) == "boolean", "Invalid wrap inversion")
                    else assert(table.find(kinds, key) and type(value) == "string" and #value <= 256, "Invalid cosmetic name") end
                end
            end
        end,
        load = function(data) service.selections = data or {}; service.revision += 1 end,
    }
    local feature = app.registry:add({id = "skins", name = "Skinchanger", category = "Cosmetics", options = {
        O.boolean("unlock", "Show unowned cosmetics locally", true),
        O.text("types", "Cosmetic types to unlock", "Skin, Wrap, Charm, Finisher"),
        O.text("rarities", "Rarities to unlock", "Legendary, Mythical, Unobtainable"),
    }, start = function(scope, values)
        local dataController = app.rivals:controller("PlayerDataController")
        local clientItem = app.rivals:module(app.player, "PlayerScripts/Modules/ClientReplicatedClasses/ClientFighter/ClientItem")
        local viewModelClass = app.rivals:module(app.player, "PlayerScripts/Modules/ClientReplicatedClasses/ClientFighter/ClientItem/ClientViewModel")
        local replicated = app.rivals:module(app.services.ReplicatedStorage, "Modules/ReplicatedClass")
        local catalog = service:catalog()
        assert(type(dataController.GetWeaponData) == "function" and type(clientItem._CreateViewModel) == "function", "Rivals cosmetic adapter is unavailable")
        local classes, saved = {}, {}
        local folder = app.rivals:path(app.player, "PlayerScripts/Modules/ViewModels")
        if folder then
            for _, instance in ipairs(folder:GetDescendants()) do
                if instance:IsA("ModuleScript") then classes[normalize(instance.Name)] = instance end
            end
        end
        local function localItem(item)
            local fighter = item and item.ClientFighter
            return fighter and (fighter.Player == app.player or fighter.IsLocalPlayer == true)
        end
        local function serialFor(serial, weapon)
            local copy = table.clone(serial)
            local dataKey = replicated:ToEnum("Data")
            local data = table.clone(copy[dataKey] or copy.Data or {})
            copy[dataKey] = data; copy.Data = nil
            local skin = service:selection(weapon, "Skin")
            for _, kind in ipairs(kinds) do
                local cosmetic = service:selection(weapon, kind)
                if cosmetic then data[replicated:ToEnum(kind)] = cosmetic; data[kind] = nil end
            end
            local name = skin and (skin.ViewModelName or skin.Name) or weapon
            data[replicated:ToEnum("Name")] = name; data.Name = nil
            return copy, name
        end
        local originalCreate = clientItem._CreateViewModel
        app.overrides:set(scope, clientItem, "_CreateViewModel", function(item, serial, ...)
            if scope.alive and localItem(item) and service.selections[item.Name] and type(serial) == "table" then serial = serialFor(serial, item.Name) end
            return originalCreate(item, serial, ...)
        end)
        local originalWeaponData = dataController.GetWeaponData
        app.overrides:set(scope, dataController, "GetWeaponData", function(self, weapon, ...)
            local data = originalWeaponData(self, weapon, ...)
            if not scope.alive or not data or not service.selections[weapon] then return data end
            local result = table.clone(data)
            for _, kind in ipairs(kinds) do result[kind] = service:selection(weapon, kind) or result[kind] end
            return result
        end)
        if values.unlock and type(dataController.Get) == "function" then
            local types, rarities = parseList(values.types), parseList(values.rarities)
            local originalGet = dataController.Get
            app.overrides:set(scope, dataController, "Get", function(self, key, ...)
                local data = originalGet(self, key, ...)
                if not scope.alive or key ~= "CosmeticInventory" then return data end
                local result = type(data) == "table" and table.clone(data) or {}
                for name, cosmetic in pairs(catalog) do
                    if type(cosmetic) == "table" and table.find(kinds, cosmetic.Type)
                        and allows(types, cosmetic.Type) and allows(rarities, cosmetic.Rarity) and result[name] == nil then
                        local copy = table.clone(cosmetic)
                        copy.Name = name; copy.Owned = true; copy.Unlocked = true; copy.Locked = false; copy.Seed = 1
                        result[name] = copy
                    end
                end
                return result
            end)
        end
        local function rebuild(item, serial, name)
            local old = item.ViewModel
            if not old or type(serial) ~= "table" then return false end
            local class = viewModelClass
            local instance = classes[normalize(name)]
            if instance then class = app.rivals:module(folder, instance:GetFullName():sub(#folder:GetFullName() + 2):gsub("%.", "/")) end
            -- Keep construction transactional: retain the old model on any failure.
            local restore = app:identity(2)
            local ok, replacement = pcall(class.new, serial, item)
            restore()
            if not ok then return false, replacement end
            if not replacement or not replacement.Model then
                if replacement and replacement.Destroy then pcall(replacement.Destroy, replacement) end
                return false, "Viewmodel constructor returned no model"
            end
            local equipped = item.IsEquipped or app.rivals:fighter().EquippedItem == item
            if equipped and old.Unequip then pcall(old.Unequip, old) end
            item.ViewModel = replacement
            if equipped and replacement.Equip then pcall(replacement.Equip, replacement, true) end
            for _, method in ipairs({"_UpdateWrap", "UpdateWrap", "_UpdateCharm", "UpdateCharm", "_UpdateCosmetics", "UpdateCosmetics"}) do
                if type(replacement[method]) == "function" then pcall(replacement[method], replacement) end
            end
            if old.Destroy then pcall(old.Destroy, old) end
            return true
        end
        -- Added after hooks so restoration rebuilds models before hooks are removed.
        scope:add(function()
            for item, original in pairs(saved) do
                for _, kind in ipairs(kinds) do
                    if item.Set then pcall(item.Set, item, kind, original.values[kind]) end
                    if item.Data then item.Data[kind] = original.values[kind] end
                end
                if item.ViewModel and item.ViewModel.Model and item.ViewModel.Model.Parent then
                    pcall(rebuild, item, original.serial, original.name)
                end
            end
        end)
        app.rivals:controller("FighterController")
        app.scheduler:add(scope, "Heartbeat", 0.2, function()
            local fighter = app.rivals:fighter()
            if not fighter then return end
            for _, item in pairs(fighter.Items or {}) do
                if not service.selections[item.Name] or not item.ViewModel then continue end
                local old = saved[item]
                if not old then
                    local serial = item.ViewModel._serial
                    assert(type(serial) == "table", "Viewmodel serial unavailable; cosmetic adapter needs updating")
                    local key = replicated:ToEnum("Data")
                    serial = table.clone(serial); serial[key] = table.clone(serial[key] or serial.Data or {}); serial.Data = nil
                    old = {serial = serial, name = item.Name, values = {}, revision = -1}
                    for _, kind in ipairs(kinds) do old.values[kind] = item.Get and item:Get(kind) or item.Data and item.Data[kind] end
                    saved[item] = old
                end
                if old.revision == service.revision then continue end
                local serial, name = serialFor(old.serial, item.Name)
                local ok, err = rebuild(item, serial, name)
                assert(ok, "Could not build selected skin: " .. tostring(err))
                for _, kind in ipairs(kinds) do
                    local cosmetic = service:selection(item.Name, kind)
                    if cosmetic then
                        if item.Set then item:Set(kind, cosmetic) end
                        if item.Data then item.Data[kind] = cosmetic end
                    end
                end
                old.revision = service.revision
            end
        end)
    end})
    feature.mount = function(group, library, safely)
        local weapon, query, seed, inverted = "", "", 1, false
        local selected, dropdowns = {}, {}
        local chooser = group:AddDropdown("fw_skin_weapon", {Text = "Weapon", Values = {}, AllowNull = true})
        local function refresh()
            if weapon == "" then return end
            local saved = service.selections[weapon] or {}
            for _, kind in ipairs(kinds) do
                dropdowns[kind]:SetValues(service:list(weapon, kind, query))
                dropdowns[kind]:SetValue(saved[kind] or "None")
            end
        end
        local function populate()
            local weapons = service:weapons()
            chooser:SetValues(weapons)
            if not table.find(weapons, weapon) then chooser:SetValue(weapons[1]) else refresh() end
        end
        chooser:OnChanged(safely(function() weapon = chooser.Value or ""; refresh() end))
        local search = group:AddInput("fw_skin_search", {Text = "Filter cosmetic names", Default = "", Finished = true})
        search:OnChanged(safely(function() query = search.Value; refresh() end))
        for _, kind in ipairs(kinds) do
            local dropdown = group:AddDropdown("fw_skin_" .. kind, {Text = kind, Values = {"None"}, Default = "None"})
            dropdowns[kind] = dropdown
            dropdown:OnChanged(function() selected[kind] = dropdown.Value end)
        end
        local seedControl = group:AddSlider("fw_skin_seed", {Text = "Pattern seed", Default = 1, Min = 1, Max = 1000000, Rounding = 0})
        seedControl:OnChanged(function() seed = seedControl.Value end)
        local inversion = group:AddToggle("fw_skin_invert", {Text = "Invert wrap", Default = false})
        inversion:OnChanged(function() inverted = inversion.Value end)
        group:AddButton({Text = "Refresh weapon catalog", Func = safely(populate)})
        group:AddButton({Text = "Apply selection to weapon", Func = safely(function()
            service:apply(weapon, selected, seed, inverted)
            app:notify("Saved cosmetic selection for " .. weapon .. (feature.enabled and "" or "; enable Skinchanger to apply"))
        end)})
        group:AddButton({Text = "Clear selected weapon", Func = safely(function()
            local active = feature.enabled
            if active then app.registry:enable("skins", false) end
            service.selections[weapon] = nil; service.revision += 1
            if active then app.registry:enable("skins", true) end
            refresh()
        end)})
        -- The catalog needs Rivals, which may not be loaded when the menu opens.
        app:onReady(function() pcall(populate) end)
    end
end

end

-- BEGIN src/features/human_aim.lua
factories["features/human_aim"] = function()
local O = require("core/options")
local HumanAim = require("core/human_aim")
return function(app)
    local options = {}
    local function section(name, list)
        for _, option in ipairs(list) do option.section = name; table.insert(options, option) end
    end
    section("Activation", {
        O.choice("activation", "Activation", "Right mouse", {"Always", "Right mouse", "Left mouse", "Either mouse"}),
        O.choice("output", "Output", "Camera", {"Camera", "Mouse"}),
        O.number("strength", "Assistance strength", 0.8, 0, 1),
        O.number("reaction", "Reaction delay (s)", 0.14, 0, 1),
        O.number("reactionVariance", "Reaction randomness (s)", 0.06, 0, 0.5),
        O.number("switchDelay", "Target switch delay (s)", 0.18, 0, 2),
        O.boolean("pauseManual", "Pause on strong manual input", true),
        O.number("manualThreshold", "Manual input threshold (px)", 35, 1, 200),
    })
    section("Targeting", {
        O.number("fov", "FOV radius (px)", 140, 1, 1000), O.number("distance", "Maximum distance", 1200, 1, 10000),
        O.boolean("visible", "Visibility check", true), O.boolean("team", "Team check", true),
        O.boolean("environment", "Same match only", true), O.boolean("lock", "Keep target lock", true),
        O.choice("priority", "Priority", "Crosshair", {"Crosshair", "Distance"}),
        O.choice("hitbox", "Hitbox", "Head", {"Head", "Root", "UpperTorso", "Random"}),
        O.number("headChance", "Random head chance (%)", 35, 0, 100),
        O.number("prediction", "Velocity prediction (s)", 0.04, 0, 0.5),
        O.number("verticalOffset", "Vertical offset (studs)", 0, -2, 2),
        O.number("deadzone", "Deadzone (px)", 1.5, 0, 20),
    })
    section("Trajectory", {
        O.number("duration", "Base reach duration (s)", 0.18, 0.03, 1),
        O.number("distanceTime", "Distance time scaling", 0.04, 0, 0.3),
        O.number("targetWidth", "Assumed target width (px)", 20, 1, 100),
        O.number("durationVariance", "Duration variance", 0.15, 0, 0.8),
        O.number("curvature", "Path curvature", 0.035, 0, 0.5),
        O.number("overshootChance", "Overshoot chance (%)", 15, 0, 100),
        O.number("overshoot", "Overshoot amount", 0.06, 0, 0.5),
        O.number("undershoot", "Undershoot amount", 0.025, 0, 0.3),
        O.number("maxSpeed", "Maximum speed (px/s)", 1800, 50, 10000),
        O.number("tracking", "Tracking response", 9, 0.1, 40),
        O.number("repath", "Moving-target replan interval (s)", 0.4, 0.1, 2),
        O.number("repathThreshold", "Replan threshold (px)", 45, 1, 300),
    })
    section("Hand movement", {
        O.number("noise", "Correlated hand noise (px)", 0.4, 0, 8),
        O.number("noiseReturn", "Noise return speed", 4, 0.1, 20),
        O.number("tremor", "Tremor amplitude (px)", 0.25, 0, 5),
        O.number("tremorFrequency", "Tremor frequency (Hz)", 10, 1, 25),
        O.number("horizontal", "Horizontal multiplier", 1, 0, 2),
        O.number("vertical", "Vertical multiplier", 0.85, 0, 2),
    })
    app.registry:add({id = "humanAim", live = true, name = "Human Aimbot", category = "Combat", options = options, start = function(scope, values)
        assert(not app.registry.byId.aim.enabled, "Disable the Aimbot before enabling Human Aimbot")
        local move = app:capability("mousemoverel")
        assert(values.output ~= "Mouse" or move, "Executor does not expose mousemoverel")
        local input = app.services.UserInputService
        local controller = HumanAim.new(values)
        local target, hitbox, acquired, lastPlan, lastSwitch, pauseUntil = nil, nil, 0, 0, -math.huge, 0
        local active = false
        app.scheduler:add(scope, "RenderStepped", 0, function(dt)
            local now, camera = os.clock(), workspace.CurrentCamera
            local right = input:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
            local left = input:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
            local held = values.activation == "Always" or values.activation == "Right mouse" and right
                or values.activation == "Left mouse" and left or values.activation == "Either mouse" and (left or right)
            if not held or app.menuOpen or input:GetFocusedTextBox() or not camera then
                active = false; target = nil; app.target = nil; return
            end
            if values.pauseManual and input:GetMouseDelta().Magnitude > values.manualThreshold then pauseUntil = now + 0.12 end
            if now < pauseUntil then return end
            local nextTarget = app.entities:target(values, target)
            if nextTarget ~= target then
                if target and nextTarget and now - lastSwitch < values.switchDelay then nextTarget = nil end
                target = nextTarget; lastSwitch = now
                acquired = now + values.reaction + math.random() * values.reactionVariance
                active = false
                if target then
                    hitbox = values.hitbox == "Random" and (math.random() * 100 < values.headChance and "Head" or "UpperTorso") or values.hitbox
                end
            end
            app.target = target
            if not target or now < acquired then return end
            local hit = hitbox == "Root" and target.root or target.character:FindFirstChild(hitbox or "Head") or target.head or target.root
            if not hit then return end
            local projected, visible = camera:WorldToViewportPoint(hit.Position + hit.AssemblyLinearVelocity * values.prediction + Vector3.yAxis * values.verticalOffset)
            if not visible then return end
            local errorX, errorY = projected.X - camera.ViewportSize.X / 2, projected.Y - camera.ViewportSize.Y / 2
            if not active or now - lastPlan >= values.repath and math.sqrt(errorX * errorX + errorY * errorY) >= values.repathThreshold then
                controller:begin(errorX, errorY); active = true; lastPlan = now
            end
            local x, y = controller:step(dt, errorX, errorY)
            x *= values.horizontal; y *= values.vertical
            if values.output == "Mouse" then
                if move then move(x, y) end
            else
                local center = camera.ViewportSize / 2
                local ray = camera:ViewportPointToRay(center.X + x, center.Y + y)
                camera.CFrame = CFrame.lookAt(camera.CFrame.Position, camera.CFrame.Position + ray.Direction)
            end
        end)
        scope:add(function() app.target = nil end)
    end})
end

end

-- BEGIN src/features/movement.lua
factories["features/movement"] = function()
local O = require("core/options")
return function(app)
    local registry, input = app.registry, app.services.UserInputService
    local function axis(positive, negative)
        return (input:IsKeyDown(positive) and 1 or 0) - (input:IsKeyDown(negative) and 1 or 0)
    end
    local function direction()
        if input:GetFocusedTextBox() or app.menuOpen then return Vector3.zero end
        return Vector3.new(axis(Enum.KeyCode.D, Enum.KeyCode.A), axis(Enum.KeyCode.Space, Enum.KeyCode.LeftControl), axis(Enum.KeyCode.S, Enum.KeyCode.W))
    end
    registry:add({id = "speed", live = true, name = "Movement Speed", category = "Movement", options = {
        O.number("speed", "Speed", 24, 1, 150), O.number("jump", "Jump power", 50, 1, 200),
    }, start = function(scope, values)
        app.scheduler:add(scope, "Heartbeat", 0.1, function()
            local _, humanoid = app:character()
            if humanoid then
                app.overrides:set(scope, humanoid, "WalkSpeed", values.speed)
                if humanoid.UseJumpPower then app.overrides:set(scope, humanoid, "JumpPower", values.jump)
                else app.overrides:set(scope, humanoid, "JumpHeight", values.jump * values.jump / (2 * workspace.Gravity)) end
            end
        end)
    end})
    registry:add({id = "airjump", name = "Air Jump", category = "Movement", start = function(scope)
        scope:connect(input.JumpRequest, function()
            if app.menuOpen or input:GetFocusedTextBox() then return end
            local _, humanoid = app:character()
            if humanoid then humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
        end)
    end})
    registry:add({id = "fly", live = true, name = "Fly", category = "Movement", options = {
        O.number("speed", "Flight speed", 50, 1, 250),
    }, start = function(scope, values)
        local lastRoot
        app.scheduler:add(scope, "Heartbeat", 0, function()
            local root, humanoid = app:character()
            local camera = workspace.CurrentCamera
            if not root or not humanoid or not camera then return end
            lastRoot = root
            app.overrides:set(scope, humanoid, "PlatformStand", true)
            local vector = direction()
            local world = camera.CFrame:VectorToWorldSpace(Vector3.new(vector.X, 0, vector.Z)) + Vector3.yAxis * vector.Y
            root.AssemblyLinearVelocity = world.Magnitude > 0 and world.Unit * values.speed or Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
        end)
        scope:add(function() if lastRoot and lastRoot.Parent then lastRoot.AssemblyLinearVelocity = Vector3.zero end end)
    end})
    registry:add({id = "phase", name = "Phase", category = "Movement", start = function(scope)
        local parts, current = {}, nil
        local function bind(character)
            table.clear(parts)
            current = character
            if not character then return end
            for _, object in ipairs(character:GetDescendants()) do
                if object:IsA("BasePart") then parts[object] = true end
            end
        end
        local characterScope
        local Scope = require("core/scope")
        local function refresh(character)
            if characterScope then characterScope:Destroy() end
            bind(character)
            characterScope = Scope.new()
            if character then
                characterScope:connect(character.DescendantAdded, function(object) if object:IsA("BasePart") then parts[object] = true end end)
                characterScope:connect(character.DescendantRemoving, function(object) parts[object] = nil end)
            end
        end
        refresh(app.player.Character)
        scope:connect(app.player.CharacterAdded, refresh)
        scope:add(function() if characterScope then characterScope:Destroy() end; table.clear(parts) end)
        app.scheduler:add(scope, "Stepped", 0, function()
            if not current or not current.Parent then return end
            for object in pairs(parts) do app.overrides:set(scope, object, "CanCollide", false) end
        end)
    end})
    registry:add({id = "spin", live = true, name = "Spin", category = "Movement", options = {
        O.number("speed", "Degrees per second", 180, -1440, 1440),
    }, start = function(scope, values)
        app.scheduler:add(scope, "Heartbeat", 0, function(dt)
            local root, humanoid = app:character()
            if root and humanoid then
                app.overrides:set(scope, humanoid, "AutoRotate", false)
                -- Rotating the root must not cost the player their momentum.
                local velocity = root.AssemblyLinearVelocity
                root.CFrame *= CFrame.Angles(0, math.rad(values.speed) * dt, 0)
                root.AssemblyLinearVelocity = velocity
            end
        end)
    end})
    registry:add({id = "strafe", live = true, name = "Target Strafe / Orbit", category = "Movement", options = {
        O.number("radius", "Radius", 12, 1, 100), O.number("speed", "Degrees per second", 90, -720, 720),
        O.number("height", "Height offset", 0, -30, 50),
        O.boolean("visible", "Visible target only", true),
    }, start = function(scope, values)
        local target, angle = nil, 0
        app.scheduler:add(scope, "Heartbeat", 0, function(dt)
            local root = app:character()
            if not root or app.menuOpen then return end
            target = app.entities:target({team = true, visible = values.visible, fov = 2000, lock = true}, target)
            if not target then return end
            angle += math.rad(values.speed) * dt
            local center = target.root.Position
            root.CFrame = CFrame.lookAt(center + Vector3.new(math.cos(angle) * values.radius, values.height, math.sin(angle) * values.radius), center)
        end)
    end})
    registry:add({id = "freecam", name = "Freecam", category = "Camera", options = {
        O.number("speed", "Movement speed", 35, 1, 250), O.number("sensitivity", "Look sensitivity", 0.2, 0.01, 2),
    }, start = function(scope, values)
        local camera = assert(workspace.CurrentCamera, "Camera unavailable")
        local initial = camera.CFrame
        local pitch, yaw = initial:ToEulerAnglesYXZ()
        local position = initial.Position
        scope:add(function() if camera.Parent then camera.CFrame = initial end end)
        app.overrides:set(scope, camera, "CameraType", Enum.CameraType.Scriptable)
        scope:connect(input.InputChanged, function(event)
            if not app.menuOpen and event.UserInputType == Enum.UserInputType.MouseMovement
                and input:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
                pitch = math.clamp(pitch - math.rad(event.Delta.Y * values.sensitivity), -1.55, 1.55)
                yaw -= math.rad(event.Delta.X * values.sensitivity)
            end
        end)
        app.scheduler:add(scope, "RenderStepped", 0, function(dt)
            local rotation = CFrame.fromEulerAnglesYXZ(pitch, yaw, 0)
            local vector = direction()
            if vector.Magnitude > 1 then vector = vector.Unit end
            position += rotation:VectorToWorldSpace(vector) * values.speed * dt
            camera.CFrame = CFrame.new(position) * rotation
        end)
    end})
    registry:add({id = "thirdperson", name = "Third Person", category = "Camera", options = {
        O.number("distance", "Camera distance", 10, 1, 50),
    }, start = function(scope, values)
        app.overrides:set(scope, app.player, "CameraMode", Enum.CameraMode.Classic)
        app.overrides:set(scope, app.player, "CameraMaxZoomDistance", math.max(values.distance, app.player.CameraMinZoomDistance))
        app.overrides:set(scope, app.player, "CameraMinZoomDistance", values.distance)
        app.overrides:set(scope, app.player, "CameraMaxZoomDistance", values.distance)
    end})
end

end

-- BEGIN src/features/player.lua
factories["features/player"] = function()
local O = require("core/options")
return function(app)
    -- Name spoofer originals survive restarts so a new name still applies.
    local nameOriginals = setmetatable({}, {__mode = "k"})
    app.registry:add({id = "animation", name = "Animation Player", category = "Player", options = {
        O.text("asset", "Animation asset ID", ""), O.number("speed", "Speed", 1, 0, 5),
        O.boolean("loop", "Loop", true), O.number("weight", "Weight", 1, 0, 1),
    }, start = function(scope, values)
        assert(values.asset:match("^%d+$"), "Enter a numeric animation asset ID")
        local animation = scope:add(Instance.new("Animation"))
        animation.AnimationId = "rbxassetid://" .. values.asset
        local track, humanoid
        local function stop()
            if track then track:Stop(0.15); track:Destroy(); track = nil end
        end
        scope:add(stop)
        app.scheduler:add(scope, "Heartbeat", 0.25, function()
            local _, current = app:character()
            if current ~= humanoid then
                stop(); humanoid = current
            end
            local animator = humanoid and humanoid:FindFirstChildOfClass("Animator")
            if animator and not track then
                track = animator:LoadAnimation(animation)
                track.Looped = values.loop
                track.Priority = Enum.AnimationPriority.Action
                track:Play(0.15, values.weight, values.speed)
            end
        end)
    end})
    app.registry:add({id = "viewmodel", name = "Viewmodel Transform", category = "Player", options = {
        O.number("x", "X offset", 0, -5, 5), O.number("y", "Y offset", 0, -5, 5), O.number("z", "Z offset", 0, -5, 5),
        O.number("roll", "Roll (degrees)", 0, -180, 180),
    }, start = function(scope, values)
        local lastModel, lastOutput, lastBase
        scope:add(function()
            if lastModel and lastModel.Parent and lastOutput and lastModel:GetPivot() == lastOutput then lastModel:PivotTo(lastBase) end
        end)
        local offset = CFrame.new(values.x, values.y, values.z) * CFrame.Angles(0, 0, math.rad(values.roll))
        app.scheduler:add(scope, "RenderStepped", 0, function()
            local camera = workspace.CurrentCamera
            local container = camera and camera:FindFirstChild("ViewModel") or workspace:FindFirstChild("ViewModels")
            local model = container and (container:IsA("Model") and container or container:FindFirstChildOfClass("Model"))
            if not model then return end
            local pivot = model:GetPivot()
            -- Some renderers update less often than RenderStepped; never accumulate offsets.
            if model == lastModel and pivot == lastOutput then pivot = lastBase end
            lastBase = pivot; lastModel = model; lastOutput = pivot * offset
            model:PivotTo(lastOutput)
        end)
    end})
    app.registry:add({id = "name", live = true, name = "Name Spoofer", category = "Player", description = "Changes the name shown for you and other players.", options = {
        O.boolean("mine", "Spoof my name", true),
        O.text("localName", "My display name", "femboy :3"),
        O.text("localUser", "My username", "femboy"),
        O.boolean("others", "Spoof other players", false),
        O.text("otherName", "Display name for others", "player"),
        O.text("otherUser", "Username for others", "player"),
        O.boolean("gui", "Rewrite menus, player list and chat", true),
        O.boolean("tag", "Rewrite overhead name tags", true),
        O.text("replacements", "Extra replacements (find=replace, ...)", ""),
    }, start = function(scope, values)
        local players = app.services.Players
        local records, watched, candidates, tagState = {}, {}, {}, {}
        local function rebuild()
            candidates = {}
            for _, player in ipairs(players:GetPlayers()) do
                local isLocal = player == app.player
                local enabled = isLocal and values.mine or (not isLocal and values.others)
                local spoofUser = isLocal and values.localUser or values.otherUser
                local spoofDisplay = isLocal and values.localName or values.otherName
                if enabled then
                    app.identities:setPresented(player, spoofUser)
                    app.identities:setPresentedDisplay(player, spoofDisplay)
                    table.insert(candidates, {player = player, text = player.Name, spoof = spoofUser})
                    table.insert(candidates, {player = player, text = player.DisplayName, spoof = spoofDisplay})
                else
                    app.identities:clearPresented(player)
                    app.identities:clearPresentedDisplay(player)
                end
            end
            for entry in values.replacements:gmatch("[^,]+") do
                local find, replace = entry:match("^%s*(.-)%s*=%s*(.-)%s*$")
                if find and #find > 0 and replace and #replace > 0 then table.insert(candidates, {text = find, spoof = replace}) end
            end
        end
        local function translate(source)
            local affected, output = nil, source
            for _, candidate in ipairs(candidates) do
                local replaced
                output, replaced = output:gsub(candidate.text:gsub("(%W)", "%%%1"), function() return candidate.spoof end)
                if replaced > 0 and candidate.player then
                    affected = affected or {}
                    affected[candidate.player] = true
                end
            end
            return output, affected
        end
        local function update(object)
            local record = records[object]
            if not record then return end
            if not values.gui then
                if object.Parent and object.Text == record.spoofed then object.Text = nameOriginals[object] end
                record.spoofed = nameOriginals[object]
                return
            end
            -- A game-authored change becomes the new original; our own writes do not.
            if object.Text ~= record.spoofed then nameOriginals[object] = object.Text end
            local source = nameOriginals[object]
            if source == nil then return end
            local result, affected = translate(source)
            record.spoofed = result
            record.players = affected
            if object.Text ~= result then object.Text = result end
        end
        local function register(object)
            if records[object] then return end
            if not (object:IsA("TextLabel") or object:IsA("TextButton") or object:IsA("TextBox")) then return end
            if nameOriginals[object] == nil then nameOriginals[object] = object.Text end
            records[object] = {spoofed = nil, players = nil}
            update(object)
            scope:add(object:GetPropertyChangedSignal("Text"):Connect(function() update(object) end))
            scope:add(object.Destroying:Connect(function() records[object] = nil; nameOriginals[object] = nil end))
            scope:add(function()
                local record = records[object]
                if record and object.Parent and object.Text == record.spoofed then object.Text = nameOriginals[object] end
            end)
        end
        local function textObjects(root)
            local ok, list = pcall(function() return root:QueryDescendants("TextLabel,TextButton,TextBox") end)
            if ok and type(list) == "table" then return list end
            local result = {}
            for _, object in ipairs(root:GetDescendants()) do
                if object:IsA("TextLabel") or object:IsA("TextButton") or object:IsA("TextBox") then table.insert(result, object) end
            end
            return result
        end
        local function watch(root)
            if not root or watched[root] then return end
            watched[root] = true
            for _, object in ipairs(textObjects(root)) do register(object) end
            scope:add(root.DescendantAdded:Connect(register))
        end
        local function reload()
            rebuild()
            for object in pairs(table.clone(records)) do update(object) end
        end
        local function bindCharacter(player)
            local character = player.Character
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
            if not humanoid or not values.tag then return end
            if player == app.player and not values.mine then return end
            if player ~= app.player and not values.others then return end
            local name = player == app.player and values.localName or values.otherName
            local state = tagState[humanoid]
            if not state then state = {original = humanoid.DisplayName}; tagState[humanoid] = state end
            if #name > 0 and state.applied ~= name then state.applied = name; pcall(function() humanoid.DisplayName = name end) end
        end
        local function applyTag()
            for humanoid, state in pairs(tagState) do
                if not humanoid.Parent or not values.tag then
                    if humanoid.Parent then pcall(function() humanoid.DisplayName = state.original end) end
                    tagState[humanoid] = nil
                end
            end
            if not values.tag then return end
            for _, player in ipairs(players:GetPlayers()) do bindCharacter(player) end
        end
        scope:add(function()
            for humanoid, state in pairs(tagState) do if humanoid.Parent then pcall(function() humanoid.DisplayName = state.original end) end end
            table.clear(tagState)
        end)
        if values.gui then
            local ok, core = pcall(function() return game:GetService("CoreGui") end)
            if ok and core then watch(core) end
            watch(app.rivals:path(app.player, "PlayerGui/MainGui"))
            watch(app.player:FindFirstChildOfClass("PlayerGui"))
            -- World name tags (SurfaceGui / BillboardGui on characters) live in workspace.
            watch(workspace)
        end
        reload(); applyTag()
        scope:connect(players.PlayerAdded, function(player) reload(); bindCharacter(player) end)
        scope:connect(players.PlayerRemoving, function() reload() end)
        scope:connect(players.PlayerAdded, function(player) scope:connect(player.CharacterAdded, function() bindCharacter(player) end) end)
        -- Re-apply the instant a setting changes; no menu restart needed.
        local function signature()
            return table.concat({tostring(values.mine), values.localName, values.localUser, tostring(values.others),
                values.otherName, values.otherUser, tostring(values.gui), tostring(values.tag), values.replacements}, "\1")
        end
        local last = signature()
        app.scheduler:add(scope, "Heartbeat", 0.2, function()
            local now = signature()
            if now ~= last then last = now; reload(); applyTag() end
        end)
    end})
    app.registry:add({id = "stats", live = true, name = "Stat Spoofer", category = "Player", description = "Changes the stats and profile shown for you and other players.", options = {
        O.boolean("mine", "Apply to me", true),
        O.boolean("others", "Apply attributes to other players", false),
        O.number("winstreak", "Win streak (0 = off)", 0, 0, 100000),
        O.number("level", "Level (0 = off)", 0, 0, 10000),
        O.number("elo", "Ranked ELO (0 = off)", 0, 0, 100000),
        O.choice("status", "Name tag status", "None", {"None", "Prime", "Contraband"}),
        O.boolean("influencer", "Influencer tag", false),
        O.boolean("employee", "Roblox employee tag", false),
        O.boolean("team", "Studio team tag", false),
        O.number("casualWins", "Profile: casual wins (0 = off)", 0, 0, 1000000),
        O.number("rankedWins", "Profile: ranked wins (0 = off)", 0, 0, 1000000),
        O.number("casualPercent", "Profile: casual win % (0 = off)", 0, 0, 100),
        O.number("rankedPercent", "Profile: ranked win % (0 = off)", 0, 0, 100),
        O.text("favoriteMap", "Profile: favorite map (empty = off)", ""),
        O.text("avatar", "My avatar user ID (empty = off)", ""),
        O.text("otherAvatar", "Avatar user ID for others (empty = off)", ""),
        O.number("keys", "Keys (0 = off)", 0, 0, 1000000000),
        O.number("currency", "Event currency (0 = off)", 0, 0, 1000000000),
        O.choice("ping", "Ping", "None", {"None", "Low", "Medium", "High"}),
        O.text("extra", "Extra attributes (Name=Value, ...)", ""),
    }, start = function(scope, values)
        local players = app.services.Players
        local controller = app.rivals:controller("PlayerDataController")
        local active = {}
        local function track(cleanup) table.insert(active, cleanup) end
        local function clear() for index = #active, 1, -1 do pcall(active[index]) end; table.clear(active) end
        scope:add(clear)
        local profileHooked = false
        local profileInfo = "none"
        local profileInner, profileFields = nil, {}
        local profileOriginals = {}
        -- Deep-copy a season record and rewrite every CurrentELO it holds.
        local function recomputeSeasons(seasons, amount)
            local function clone(value)
                if type(value) ~= "table" then return value end
                local copy = {}
                for key, item in pairs(value) do copy[key] = clone(item) end
                return copy
            end
            local function retag(value)
                for key, item in pairs(value) do
                    if key == "CurrentELO" then value[key] = amount
                    elseif type(item) == "table" then retag(item) end
                end
            end
            local copy = clone(seasons)
            retag(copy)
            return copy
        end
        local function apply()
            clear()
            local extra = {}
            for entry in values.extra:gmatch("[^,]+") do
                local key, value = entry:match("^%s*(.-)%s*=%s*(.-)%s*$")
                if key and #key > 0 and #value > 0 then
                    if tonumber(value) then extra[key] = tonumber(value)
                    elseif value == "true" or value == "false" then extra[key] = value == "true"
                    else extra[key] = value end
                end
            end
            -- Guarded attribute writer (kicia's Guarded): written locally and re-applied
            -- whenever the game overwrites it, which also re-fires the change signal.
            local guards = setmetatable({}, {__mode = "k"})
            local function setAttribute(player, attribute, value)
                local set = guards[player]
                if not set then set = {}; guards[player] = set end
                local guard = set[attribute]
                if value == nil then
                    if guard then guard.destroy(); set[attribute] = nil end
                    return
                end
                if not guard then
                    local original = player:GetAttribute(attribute)
                    local writing = false
                    guard = {}
                    guard.spoofed = value
                    guard.apply = function()
                        writing = true
                        if guard.spoofed ~= nil then player:SetAttribute(attribute, guard.spoofed)
                        else player:SetAttribute(attribute, original) end
                        writing = false
                    end
                    guard.connection = player:GetAttributeChangedSignal(attribute):Connect(function()
                        if writing then return end
                        original = player:GetAttribute(attribute)
                        guard.apply()
                    end)
                    guard.destroy = function()
                        guard.connection:Disconnect()
                        if player.Parent then pcall(function() player:SetAttribute(attribute, original) end) end
                    end
                    track(guard.destroy)
                    set[attribute] = guard
                    guard.apply()
                    return
                end
                guard.spoofed = value
                guard.apply()
            end
            local function applyPlayer(player)
                setAttribute(player, "StatisticDuelsWinStreak", values.winstreak > 0 and math.floor(values.winstreak) or nil)
                setAttribute(player, "Level", values.level > 0 and math.floor(values.level) or nil)
                setAttribute(player, "DisplayELO", values.elo > 0 and math.floor(values.elo) or nil)
                setAttribute(player, "PlayerStatus", values.status ~= "None" and values.status or nil)
                setAttribute(player, "IsInfluencer", values.influencer and true or nil)
                setAttribute(player, "IsRobloxEmployee", values.employee and true or nil)
                setAttribute(player, "GroupRank", values.team and 255 or nil)
                for name, value in pairs(extra) do setAttribute(player, name, value) end
                -- Leaderstat sink: CustomLeaderstats["Current ELO"].
                if values.elo > 0 then
                    task.spawn(function()
                        local stats = player:WaitForChild("CustomLeaderstats", 5)
                        local stat = stats and stats:FindFirstChild("Current ELO")
                        if not (stat and stat:IsA("ValueBase")) then return end
                        local amount, original = math.floor(values.elo), stat.Value
                        stat.Value = amount
                        local connection = stat:GetPropertyChangedSignal("Value"):Connect(function()
                            if stat.Value ~= amount then pcall(function() stat.Value = amount end) end
                        end)
                        track(function() connection:Disconnect(); pcall(function() stat.Value = original end) end)
                    end)
                end
            end
            if values.mine then applyPlayer(app.player) end
            if values.others then
                for _, player in ipairs(players:GetPlayers()) do if player ~= app.player then applyPlayer(player) end end
            end
            track(players.PlayerAdded:Connect(function(player) if values.others and player ~= app.player then applyPlayer(player) end end))
            -- Profile data hook (kicia's CurrentData.Data proxy + TriggerDataChangedSignal).
            local fields = {}
            if values.mine then
                if values.casualWins > 0 then fields.CasualWins = math.floor(values.casualWins) end
                if values.rankedWins > 0 then fields.RankedWins = math.floor(values.rankedWins) end
                if values.casualPercent > 0 then fields.CasualWinPercent = values.casualPercent end
                if values.rankedPercent > 0 then fields.RankedWinPercent = values.rankedPercent end
                if #values.favoriteMap > 0 then fields.FavoriteMap = values.favoriteMap end
                local ok, current = pcall(function() return controller.CurrentData end)
                local inner
                if ok and current ~= nil then
                    -- rawget first: the table can be behind a guarding metatable.
                    local okData, data = pcall(rawget, current, "Data")
                    if not okData or type(data) ~= "table" then
                        local okIndex, indexed = pcall(function() return current.Data end)
                        if okIndex then data = indexed end
                    end
                    inner = data
                end
                profileInfo = "current=" .. tostring(ok and current ~= nil) .. " data=" .. type(inner)
                if type(inner) == "table" then
                    if values.elo > 0 and type(inner.Seasons) == "table" then
                        fields.Seasons = function() return recomputeSeasons(inner.Seasons, math.floor(values.elo)) end
                    end
                    -- Write the spoofed values straight into the data table and keep
                    -- re-applying; replacing CurrentData.Data is guarded in this build.
                    profileInner, profileFields = inner, fields
                    profileHooked = true
                    for key, spoofed in pairs(fields) do
                        if profileOriginals[key] == nil then profileOriginals[key] = inner[key] end
                        pcall(rawset, inner, key, type(spoofed) == "function" and spoofed() or spoofed)
                    end
                    for key, original in pairs(profileOriginals) do
                        if fields[key] == nil then pcall(rawset, inner, key, original); profileOriginals[key] = nil end
                    end
                    local events = current._value_changed_events
                    if type(events) == "table" then
                        for key in pairs(fields) do
                            local signal = events[key]
                            if signal ~= nil then
                                if type(signal.Fire) == "function" then pcall(function() signal:Fire() end)
                                elseif type(signal) == "function" then pcall(signal) end
                            end
                        end
                    end
                end
                if type(controller.Get) == "function" then
                    local originalGet = controller.Get
                    app.overrides:set(scope, controller, "Get", function(self, key, ...)
                        local spoofed = fields[key]
                        if spoofed ~= nil then return type(spoofed) == "function" and spoofed() or spoofed end
                        if key == "Keys" and values.keys > 0 then return math.floor(values.keys) end
                        if key == "EventCurrency" and values.currency > 0 then return math.floor(values.currency) end
                        return originalGet(self, key, ...)
                    end)
                end
                -- Ping: swap the Players upvalue the game's ping helper reads.
                if values.ping ~= "None" then
                    local ranges = {Low = {150, 160}, Medium = {60, 75}, High = {17, 25}}
                    local ok2, utility = pcall(app.rivals.module, app.rivals, app.services.ReplicatedStorage, "Modules/Utility")
                    local meta = ok2 and utility and getmetatable(utility)
                    local ping = meta and meta.__index and meta.__index.GetLocalConnectionPing
                    if type(ping) == "function" and debug and debug.getupvalues and debug.setupvalue then
                        local slot, value
                        for index, upvalue in debug.getupvalues(ping) do
                            if typeof(upvalue) == "Instance" and upvalue == players then slot, value = index, upvalue end
                        end
                        if slot then
                            local fake = {LocalPlayer = {GetNetworkPing = function()
                                local range = ranges[values.ping]
                                return math.random(range[1], range[2]) / 1000
                            end}}
                            local swapped = pcall(debug.setupvalue, ping, slot, fake)
                            if swapped then track(function() pcall(debug.setupvalue, ping, slot, value) end) end
                        end
                    end
                end
            end
            -- Avatar: description/thumbnail lookups resolve spoofed ids.
            local avatarByUserId = {}
            local mineAvatar = values.mine and tonumber(values.avatar) or nil
            if mineAvatar and mineAvatar > 0 then avatarByUserId[app.player.UserId] = math.floor(mineAvatar) end
            local function addOtherAvatars()
                local otherAvatar = values.others and tonumber(values.otherAvatar) or nil
                if not otherAvatar or otherAvatar <= 0 then return end
                for _, player in ipairs(players:GetPlayers()) do
                    if player ~= app.player then avatarByUserId[player.UserId] = math.floor(otherAvatar) end
                end
            end
            addOtherAvatars()
            if next(avatarByUserId) then
                local hook, closure = app:capability("hookfunction"), app:capability("newcclosure")
                if hook then
                    local function substitute(name)
                        local target = players[name]
                        if type(target) ~= "function" then return end
                        local original
                        local intercept = function(self, userId, ...)
                            local spoof = avatarByUserId[userId]
                            return original(self, spoof or userId, ...)
                        end
                        local ok3, patched = pcall(hook, target, closure and closure(intercept) or intercept)
                        if ok3 then
                            original = patched
                            track(function() pcall(hook, target, original) end)
                        end
                    end
                    substitute("GetHumanoidDescriptionFromUserIdAsync")
                    substitute("GetUserThumbnailAsync")
                    track(players.PlayerAdded:Connect(function(player) if player ~= app.player then addOtherAvatars() end end))
                end
            end
        end
        apply()
        local announced, waited = false, 0
        local function signature()
            return table.concat({tostring(values.mine), tostring(values.others), tostring(values.winstreak), tostring(values.level),
                tostring(values.elo), values.status, tostring(values.influencer), tostring(values.employee), tostring(values.team),
                tostring(values.casualWins), tostring(values.rankedWins), tostring(values.casualPercent), tostring(values.rankedPercent),
                values.favoriteMap, values.avatar, values.otherAvatar, tostring(values.keys), tostring(values.currency), values.ping, values.extra}, "\1")
        end
        scope:add(function()
            if type(profileInner) == "table" then
                for key, original in pairs(profileOriginals) do pcall(rawset, profileInner, key, original) end
            end
        end)
        local last = signature()
        app.scheduler:add(scope, "Heartbeat", 0.5, function()
            if profileHooked and values.mine and type(profileInner) == "table" then
                for key, spoofed in pairs(profileFields) do
                    pcall(rawset, profileInner, key, type(spoofed) == "function" and spoofed() or spoofed)
                end
            end
            local now = signature()
            if now ~= last then last = now; apply() end
            -- Retry until the data controller is actually populated.
            if values.mine and not profileHooked then apply() end
            if not announced then
                waited += 0.25
                if profileHooked then announced = true; app:notify("Stat Spoofer: profile hooked")
                elseif waited >= 5 then announced = true; app:notify("Stat Spoofer: no profile data (" .. profileInfo .. ")") end
            end
        end)
    end})
    app.registry:add({id = "appearance", live = true, name = "Character Appearance", category = "Player", description = "Recolours your character.", options = {
        O.choice("mode", "Color mode", "Femboy", {"Femboy", "Rainbow", "Solid"}),
        O.number("red", "Solid red", 244, 0, 255), O.number("green", "Solid green", 159, 0, 255), O.number("blue", "Solid blue", 199, 0, 255),
        O.number("speed", "Rainbow speed", 0.35, 0.05, 5),
        O.choice("material", "Material", "Keep", {"Keep", "Plastic", "SmoothPlastic", "Neon", "Marble", "Metal", "Ice"}),
        O.number("transparency", "Body transparency", 0, 0, 0.9),
    }, start = function(scope, values)
        local Scope = require("core/scope")
        -- Only real body parts; never touch accessories, meshes or the viewmodel.
        local BODY = {Head = true, Torso = true, ["Left Arm"] = true, ["Right Arm"] = true, ["Left Leg"] = true, ["Right Leg"] = true,
            UpperTorso = true, LowerTorso = true, LeftUpperArm = true, LeftLowerArm = true, LeftHand = true,
            RightUpperArm = true, RightLowerArm = true, RightHand = true, LeftUpperLeg = true, LeftLowerLeg = true, LeftFoot = true,
            RightUpperLeg = true, RightLowerLeg = true, RightFoot = true}
        local parts, characterScope, hue = {}, nil, 0
        local function wanted(object)
            return object:IsA("BasePart") and BODY[object.Name] == true and object:FindFirstChildOfClass("SurfaceAppearance") == nil
        end
        local function bind(character)
            if characterScope then characterScope:Destroy() end
            table.clear(parts)
            characterScope = Scope.new()
            if not character then return end
            local function apply(object) if wanted(object) then parts[object] = true end end
            for _, object in ipairs(character:GetDescendants()) do apply(object) end
            characterScope:connect(character.DescendantAdded, apply)
            characterScope:connect(character.DescendantRemoving, function(object) parts[object] = nil end)
        end
        bind(app.player.Character)
        scope:connect(app.player.CharacterAdded, bind)
        scope:add(function() if characterScope then characterScope:Destroy() end; table.clear(parts) end)
        local material = values.material ~= "Keep" and (Enum.Material[values.material] or Enum.Material.Plastic) or nil
        app.scheduler:add(scope, "RenderStepped", 1 / 12, function(dt)
            hue = (hue + dt * values.speed) % 1
            local color
            if values.mode == "Rainbow" then color = Color3.fromHSV(hue, 0.55, 1)
            elseif values.mode == "Solid" then color = Color3.fromRGB(values.red, values.green, values.blue)
            else color = Color3.fromHSV(0.92 + hue * 0.06, 0.45, 1) end
            local transparency = values.transparency > 0 and values.transparency or nil
            for part in pairs(parts) do
                if part.Parent then
                    if part.Color ~= color then app.overrides:set(scope, part, "Color", color) end
                    if material and part.Material ~= material then app.overrides:set(scope, part, "Material", material) end
                    if transparency and part.Transparency ~= transparency then app.overrides:set(scope, part, "Transparency", transparency) end
                end
            end
        end)
    end})
end

end

-- BEGIN src/features/recording.lua
factories["features/recording"] = function()
local O = require("core/options")
return function(app)
    app.recording = nil
    app.registry:add({id = "record", name = "Record Movement", category = "Recording", options = {
        O.number("rate", "Samples per second", 20, 5, 60), O.number("duration", "Maximum duration (s)", 60, 1, 300),
    }, start = function(scope, values)
        assert(not app.registry.byId.replay.enabled, "Stop replay before recording")
        local root = assert(app:character(), "Character root unavailable")
        local initial = root.CFrame
        local recording = {version = 1, place = game.PlaceId, samples = {}, origin = {initial:GetComponents()}}
        local time = 0
        app.recording = recording
        app.scheduler:add(scope, "Heartbeat", 1 / values.rate, function(dt)
            time += dt
            local current = app:character()
            if current and time <= values.duration then
                table.insert(recording.samples, {time = time, frame = {initial:ToObjectSpace(current.CFrame):GetComponents()}})
            end
            if time >= values.duration then
                app.registry:enable("record", false)
                app:notify(string.format("Recorded %d movement samples", #recording.samples))
            end
        end)
    end})
    app.registry:add({id = "replay", name = "Replay Movement", category = "Recording", options = {
        O.boolean("relative", "Align to current position", true), O.boolean("loop", "Loop", false),
        O.number("speed", "Playback speed", 1, 0.1, 5), O.boolean("restore", "Restore starting position", true),
    }, start = function(scope, values)
        assert(not app.registry.byId.record.enabled, "Stop recording before replay")
        local recording = assert(app.recording, "Record or import a movement recording first")
        assert(#recording.samples >= 2, "Recording needs at least two samples")
        local root = assert(app:character(), "Character root unavailable")
        local initial, time, index = root.CFrame, 0, 1
        local anchor = values.relative and initial or CFrame.new(table.unpack(recording.origin))
        local samples = recording.samples
        scope:add(function()
            if values.restore and root.Parent then root.CFrame = initial; root.AssemblyLinearVelocity = Vector3.zero end
        end)
        app.scheduler:add(scope, "Heartbeat", 0, function(dt)
            if app:character() ~= root then app.registry:enable("replay", false); return end
            time += dt * values.speed
            local duration = samples[#samples].time
            if time > duration then
                if values.loop then time %= duration; index = 1
                else app.registry:enable("replay", false); return end
            end
            while index < #samples - 1 and samples[index + 1].time < time do index += 1 end
            local first, second = samples[index], samples[index + 1]
            local alpha = math.clamp((time - first.time) / (second.time - first.time), 0, 1)
            root.CFrame = anchor * CFrame.new(table.unpack(first.frame)):Lerp(CFrame.new(table.unpack(second.frame)), alpha)
            root.AssemblyLinearVelocity = Vector3.zero
        end)
    end})
    function app:exportRecording()
        assert(self.recording, "No recording available")
        return self.services.HttpService:JSONEncode(self.recording)
    end
    function app:importRecording(json)
        assert(not self.registry.byId.record.enabled and not self.registry.byId.replay.enabled, "Stop recording and replay before importing")
        assert(type(json) == "string" and #json <= 8000000, "Recording exceeds 8 MB")
        local data = self.services.HttpService:JSONDecode(json)
        assert(type(data) == "table" and data.version == 1 and type(data.samples) == "table" and #data.samples <= 18000, "Invalid recording")
        local function validFrame(frame)
            assert(type(frame) == "table" and #frame == 12, "Invalid CFrame")
            for _, value in ipairs(frame) do
                assert(type(value) == "number" and value == value and math.abs(value) < 1e8, "Invalid CFrame component")
            end
        end
        validFrame(data.origin)
        local previous = -1
        for _, sample in ipairs(data.samples) do
            assert(type(sample) == "table" and type(sample.time) == "number" and sample.time > previous and sample.time <= 300, "Invalid sample time")
            validFrame(sample.frame); previous = sample.time
        end
        self.recording = data
    end
end

end

-- BEGIN src/features/security.lua
factories["features/security"] = function()
-- Compatibility patch for the client-side integrity module that can block
-- runtime patches. Best-effort; effectiveness in Rivals is not verified.
return function(app)
    app.registry:add({id = "cameraSecurity", name = "Integrity Compatibility", category = "Compatibility", description = "Compatibility patch for the game's integrity checks.", start = function(scope)
        local getRaw = app:capability("getrawmetatable")
        local setReadonly = app:capability("setreadonly")
        local isReadonly = app:capability("isreadonly")
        assert(getRaw and setReadonly and isReadonly, "Requires getrawmetatable, setreadonly, and isreadonly")
        local module = app.rivals:module(app.player, "PlayerScripts/Modules/CameraSecurity")
        local meta = getRaw(module)
        assert(type(meta) == "table", "Integrity module metatable unavailable")
        local keys = {"__index", "__newindex", "__tostring"}
        local originals, replacements = {}, {
            __index = function() return nil end,
            __newindex = function(object, key, value) rawset(object, key, value) end,
            __tostring = function() return "LocalPlayer = nil" end,
        }
        for _, key in ipairs(keys) do originals[key] = rawget(meta, key) end
        local readonly = isReadonly(meta)
        scope:add(function()
            local currentReadonly = isReadonly(meta)
            setReadonly(meta, false)
            for _, key in ipairs(keys) do
                if rawget(meta, key) == replacements[key] then rawset(meta, key, originals[key]) end
            end
            setReadonly(meta, currentReadonly)
        end)
        setReadonly(meta, false)
        local ok, err = pcall(function()
            for _, key in ipairs(keys) do rawset(meta, key, replacements[key]) end
        end)
        setReadonly(meta, readonly)
        assert(ok, err)
        app:notify("Integrity patch installed")
    end})
end

end

-- BEGIN src/features/visuals.lua
factories["features/visuals"] = function()
local O = require("core/options")
return function(app)
    local registry = app.registry
    local function create(scope, class, properties, parent)
        local object = scope:add(Instance.new(class))
        for key, value in pairs(properties) do object[key] = value end
        object.Parent = parent
        return object
    end
    local function overlay(scope, name)
        return create(scope, "ScreenGui", {Name = "femboyware_" .. name, ResetOnSpawn = false, IgnoreGuiInset = true, DisplayOrder = 20}, app:guiParent())
    end
    local pink = Color3.fromRGB(244, 159, 199)
    local function frame(scope, parent)
        return create(scope, "Frame", {BorderSizePixel = 0, BackgroundColor3 = pink}, parent)
    end
    local function text(scope, parent)
        return create(scope, "TextLabel", {BackgroundTransparency = 1, TextColor3 = pink, TextStrokeTransparency = 0.3,
            TextSize = 13, Font = Enum.Font.Code, Text = ""}, parent)
    end
    local function line(object, startPoint, endPoint, thickness)
        local delta = endPoint - startPoint
        object.AnchorPoint = Vector2.new(0.5, 0.5)
        object.Position = UDim2.fromOffset((startPoint.X + endPoint.X) / 2, (startPoint.Y + endPoint.Y) / 2)
        object.Size = UDim2.fromOffset(delta.Magnitude, thickness)
        object.Rotation = math.deg(math.atan2(delta.Y, delta.X))
    end
    registry:add({id = "esp", name = "Player ESP", category = "Visuals", description = "Draws boxes, names and health over other players.", options = {
        O.boolean("team", "Enemies only", true), O.boolean("boxes", "Boxes", true), O.boolean("names", "Names", true),
        O.boolean("display", "Use display names", true), O.boolean("health", "Health bar", true),
        O.boolean("distanceLabel", "Distance", true), O.boolean("tracers", "Tracers", false),
        O.boolean("head", "Head marker", false), O.boolean("arrows", "Offscreen arrows", true),
        O.number("distance", "Maximum distance", 2000, 10, 10000),
        O.number("fps", "Update rate, 0 = every frame", 60, 0, 240),
        O.color("color", "Box and text color", "F49FC7"),
    }, start = function(scope, values)
        local environment = getgenv and getgenv() or {}
        local candidate = environment.Drawing or Drawing
        local hardware = false
        if type(candidate) == "table" and type(candidate.new) == "function" then
            hardware = pcall(function() local probe = candidate.new("Square"); probe.Visible = false; probe:Remove() end)
        end
        local gui = (not hardware) and overlay(scope, "esp") or nil
        -- Reused slots avoid creating a Scope and a dozen objects per player.
        local slots = {}
        local function screenSlot(index)
            local object = slots[index]
            if object then return object end
            object = {edges = {}, cache = {}}
            object.group = frame(scope, gui); object.group.BackgroundTransparency = 1; object.group.Visible = false
            for i = 1, 4 do object.edges[i] = frame(scope, object.group) end
            object.text = {name = text(scope, object.group), info = text(scope, object.group)}
            object.health = frame(scope, object.group)
            object.tracer = frame(scope, object.group)
            object.head = frame(scope, object.group)
            create(scope, "UICorner", {CornerRadius = UDim.new(1, 0)}, object.head)
            object.arrow = text(scope, object.group); object.arrow.Text = "▲"; object.arrow.TextSize = 22
            slots[index] = object
            return object
        end
        local function drawingSlot(index)
            local object = slots[index]
            if object then return object end
            local function make(class)
                local item = candidate.new(class)
                scope:add(function() pcall(function() item:Remove() end) end)
                return item
            end
            object = {cache = {}}
            object.box = make("Square"); object.box.Filled = false; object.box.Thickness = 1
            object.text = {name = make("Text"), info = make("Text")}
            object.text.name.Center = true; object.text.name.Outline = true; object.text.name.Size = 14; object.text.name.Font = 2
            object.text.info.Center = true; object.text.info.Outline = true; object.text.info.Size = 13; object.text.info.Font = 2
            object.health = make("Square"); object.health.Filled = true
            object.tracer = make("Line")
            object.head = make("Circle"); object.head.Filled = false; object.head.Thickness = 1
            object.arrow = make("Text"); object.arrow.Text = "▲"; object.arrow.Center = true; object.arrow.Outline = true; object.arrow.Size = 18; object.arrow.Font = 2
            slots[index] = object
            return object
        end
        local createSlot = hardware and drawingSlot or screenSlot
        local function reset(object)
            if hardware then
                object.box.Visible = false; object.health.Visible = false; object.tracer.Visible = false
                object.head.Visible = false; object.text.name.Visible = false; object.text.info.Visible = false; object.arrow.Visible = false
            else
                object.group.Visible = false
            end
        end
        local function drawBox(object, left, top, width, height, color)
            if hardware then
                object.box.Position = Vector2.new(left, top); object.box.Size = Vector2.new(width, height)
                object.box.Color = color; object.box.Visible = true
            else
                object.group.Visible = true
                local corners = {Vector2.new(left, top), Vector2.new(left + width, top), Vector2.new(left + width, top + height), Vector2.new(left, top + height)}
                for i, edge in ipairs(object.edges) do edge.Visible = true; edge.BackgroundColor3 = color; line(edge, corners[i], corners[i % 4 + 1], 1) end
            end
        end
        local function drawText(object, kind, value, x, y, color)
            local item = object.text[kind]
            if object.cache[kind] ~= value then object.cache[kind] = value; item.Text = value end
            if hardware then item.Position = Vector2.new(x, y); item.Color = color; item.Visible = true
            else object.group.Visible = true; item.Visible = true; item.TextColor3 = color; item.Position = UDim2.fromOffset(x - 90, y); item.Size = UDim2.fromOffset(180, 18) end
        end
        local function drawHealth(object, left, top, width, height, color)
            if hardware then
                object.health.Position = Vector2.new(left, top); object.health.Size = Vector2.new(width, height)
                object.health.Color = color; object.health.Visible = true
            else
                object.group.Visible = true
                object.health.Visible = true; object.health.BackgroundColor3 = color
                object.health.Position = UDim2.fromOffset(left, top); object.health.Size = UDim2.fromOffset(width, height)
            end
        end
        local function drawTracer(object, from, to, color)
            if hardware then
                object.tracer.From = from; object.tracer.To = to; object.tracer.Color = color; object.tracer.Visible = true
            else
                object.group.Visible = true
                object.tracer.Visible = true; object.tracer.BackgroundColor3 = color; line(object.tracer, from, to, 1)
            end
        end
        local function drawHead(object, x, y, radius, color)
            if hardware then
                object.head.Position = Vector2.new(x, y); object.head.Radius = radius; object.head.Color = color; object.head.Visible = true
            else
                object.group.Visible = true
                object.head.Visible = true; object.head.BackgroundColor3 = color
                object.head.Position = UDim2.fromOffset(x - radius, y - radius); object.head.Size = UDim2.fromOffset(radius * 2, radius * 2)
            end
        end
        local function drawArrow(object, x, y, color)
            if hardware then
                object.arrow.Position = Vector2.new(x, y); object.arrow.Color = color; object.arrow.Visible = true
            else
                object.group.Visible = true
                object.arrow.Visible = true; object.arrow.TextColor3 = color
                object.arrow.Position = UDim2.fromOffset(x - 13, y - 13); object.arrow.Size = UDim2.fromOffset(26, 26)
            end
        end
        -- Interval 0 means "every frame", which is what keeps the overlay smooth.
        app.scheduler:add(scope, "RenderStepped", values.fps > 0 and 1 / values.fps or 0, function()
            local camera = workspace.CurrentCamera
            if not camera then return end
            local color = Color3.fromHex(values.color)
            local viewport = camera.ViewportSize
            local center = viewport / 2
            local origin = camera.CFrame.Position
            local count = 0
            for _, entry in ipairs(app.entities.list) do
                local root, humanoid = entry.root, entry.humanoid
                if root and humanoid and humanoid.Health > 0 and (not values.team or app.entities:enemy(entry)) then
                    local position, onScreen = camera:WorldToViewportPoint(root.Position)
                    local distance = (root.Position - origin).Magnitude
                    if distance <= values.distance then
                        count += 1
                        local object = createSlot(count)
                        reset(object)
                        if not onScreen then
                            if values.arrows then
                                local relative = camera.CFrame:PointToObjectSpace(root.Position)
                                local direction = Vector2.new(relative.X, -relative.Y)
                                if direction.Magnitude < 0.01 then direction = Vector2.new(0, 1) end
                                direction = direction.Unit
                                local point = center + direction * (math.min(viewport.X, viewport.Y) * 0.4)
                                drawArrow(object, point.X, point.Y, color)
                            end
                            continue
                        end
                        local top = camera:WorldToViewportPoint(root.Position + Vector3.yAxis * 3)
                        local bottom = camera:WorldToViewportPoint(root.Position - Vector3.yAxis * 3)
                        local height = math.abs(bottom.Y - top.Y)
                        local width = height * 0.55
                        local left, right = position.X - width / 2, position.X + width / 2
                        local y1, y2 = math.min(top.Y, bottom.Y), math.max(top.Y, bottom.Y)
                        if values.boxes then drawBox(object, left, y1, width, height, color) end
                        if values.names then drawText(object, "name", values.display and app.identities:presentedDisplay(entry.player) or app.identities:presented(entry.player), position.X, y1 - 18, color) end
                        if values.distanceLabel then drawText(object, "info", string.format("%d studs • %d HP", math.floor(distance), math.floor(humanoid.Health)), position.X, y2 + 2, color) end
                        if values.health then
                            local fraction = math.clamp(humanoid.Health / math.max(humanoid.MaxHealth, 1), 0, 1)
                            drawHealth(object, left - 6, y2 - height * fraction, 3, height * fraction, Color3.fromRGB(235, 80, 100):Lerp(Color3.fromRGB(100, 235, 150), fraction))
                        end
                        if values.tracers then drawTracer(object, Vector2.new(center.X, viewport.Y), Vector2.new(position.X, y2), color) end
                        if values.head and entry.head then
                            local point = camera:WorldToViewportPoint(entry.head.Position)
                            drawHead(object, point.X, point.Y, 3, color)
                        end
                    end
                end
            end
            for index = count + 1, #slots do reset(slots[index]) end
        end)
    end})
    registry:add({id = "chams", live = true, name = "Chams / Highlight", category = "Visuals", options = {
        O.boolean("team", "Enemies only", true), O.boolean("walls", "Visible through walls", true),
        O.number("fill", "Fill transparency", 0.65, 0, 1), O.number("outline", "Outline transparency", 0, 0, 1),
        O.color("fillColor", "Fill color", "F49FC7"), O.color("outlineColor", "Outline color", "FFFFFF"),
    }, start = function(scope, values)
        local objects = {}
        scope:add(function() for _, item in pairs(objects) do item:Destroy() end end)
        app.scheduler:add(scope, "Heartbeat", 0.1, function()
            local fillColor, outlineColor = Color3.fromHex(values.fillColor), Color3.fromHex(values.outlineColor)
            for entry, object in pairs(objects) do
                if not app.entities.players[entry.player] or object.Adornee ~= entry.character then object:Destroy(); objects[entry] = nil end
            end
            for _, entry in ipairs(app.entities.list) do
                if entry.character then
                    local object = objects[entry]
                    if not object then object = Instance.new("Highlight"); object.Name = "femboyware_chams"; object.Adornee = entry.character; object.Parent = app:guiParent(); objects[entry] = object end
                    object.Enabled = not values.team or app.entities:enemy(entry) == true
                    object.FillColor = fillColor; object.OutlineColor = outlineColor
                    object.FillTransparency = values.fill; object.OutlineTransparency = values.outline
                    object.DepthMode = values.walls and Enum.HighlightDepthMode.AlwaysOnTop or Enum.HighlightDepthMode.Occluded
                end
            end
        end)
    end})
    registry:add({id = "crosshair", name = "Crosshair", category = "Visuals", options = {
        O.number("size", "Arm length", 7, 1, 40), O.number("gap", "Gap", 4, 0, 40), O.number("thickness", "Thickness", 2, 1, 8),
        O.number("spin", "Rotation speed", 0, -360, 360), O.color("color", "Color", "F49FC7"),
    }, start = function(scope, values)
        local gui = overlay(scope, "crosshair")
        local group = frame(scope, gui); group.BackgroundTransparency = 1; group.Size = UDim2.fromOffset(0, 0)
        local bars = {}
        for i = 1, 4 do bars[i] = frame(scope, group) end
        local color, time = Color3.fromHex(values.color), 0
        app.scheduler:add(scope, "RenderStepped", 0, function(dt)
            local camera = workspace.CurrentCamera
            if not camera then return end
            time += dt
            group.Position = UDim2.fromOffset(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
            for i, bar in ipairs(bars) do
                local angle = math.rad((i - 1) * 90 + time * values.spin)
                local direction = Vector2.new(math.cos(angle), math.sin(angle))
                bar.BackgroundColor3 = color
                line(bar, direction * values.gap, direction * (values.gap + values.size), values.thickness)
            end
        end)
    end})
    registry:add({id = "fovcircle", name = "Targeting FOV Circle", category = "Visuals", options = {
        O.choice("feature", "Follow feature", "aim", {"aim", "silent"}), O.color("color", "Circle color", "F49FC7"),
    }, start = function(scope, values)
        local gui = overlay(scope, "fov")
        local circle = frame(scope, gui); circle.BackgroundTransparency = 1; circle.AnchorPoint = Vector2.new(0.5, 0.5)
        create(scope, "UICorner", {CornerRadius = UDim.new(1, 0)}, circle)
        create(scope, "UIStroke", {Color = Color3.fromHex(values.color), Thickness = 1}, circle)
        app.scheduler:add(scope, "RenderStepped", 1 / 30, function()
            local feature, camera = registry.byId[values.feature], workspace.CurrentCamera
            circle.Visible = feature and feature.enabled and camera ~= nil
            if not camera then return end
            local options = feature.values
            local origin = camera.ViewportSize / 2
            if options.origin == "Mouse" then origin = app.services.UserInputService:GetMouseLocation() end
            circle.Position = UDim2.fromOffset(origin.X, origin.Y); circle.Size = UDim2.fromOffset(options.fov * 2, options.fov * 2)
        end)
    end})
    registry:add({id = "targethud", name = "Target HUD", category = "Visuals", start = function(scope)
        local gui = overlay(scope, "target")
        local label = text(scope, gui)
        label.Position = UDim2.new(0.5, -150, 0.7, 0); label.Size = UDim2.fromOffset(300, 50)
        label.BackgroundTransparency = 0.2; label.BackgroundColor3 = Color3.fromRGB(25, 20, 32)
        create(scope, "UICorner", {CornerRadius = UDim.new(0, 8)}, label)
        app.scheduler:add(scope, "Heartbeat", 0.1, function()
            local target = app.target
            label.Visible = target ~= nil and target.humanoid ~= nil
            if label.Visible then label.Text = string.format("%s\n%d / %d HP", app.identities:presentedDisplay(target.player), target.humanoid.Health, target.humanoid.MaxHealth) end
        end)
    end})
    registry:add({id = "aura", live = true, name = "Cosmetic Aura", category = "Visuals", options = {
        O.choice("mode", "Color", "Femboy", {"Femboy", "Rainbow", "Solid"}),
        O.number("red", "Solid red", 244, 0, 255), O.number("green", "Solid green", 159, 0, 255), O.number("blue", "Solid blue", 199, 0, 255),
        O.number("speed", "Rainbow speed", 0.5, 0.05, 5), O.number("rate", "Particle rate", 20, 1, 100),
        O.number("lifetime", "Particle lifetime (s)", 1.2, 0.2, 4), O.number("size", "Particle size", 0.5, 0.05, 2),
        O.number("spread", "Particle speed", 2, 0, 20),
    }, start = function(scope, values)
        local attachment = scope:add(Instance.new("Attachment"))
        local emitter = scope:add(Instance.new("ParticleEmitter"))
        emitter.Name = "femboyware_aura"
        emitter.Texture = "rbxasset://textures/particles/sparkles_main.dds"
        emitter.Rate = values.rate; emitter.Lifetime = NumberRange.new(values.lifetime)
        emitter.SpreadAngle = Vector2.new(180, 180); emitter.Speed = NumberRange.new(values.spread)
        emitter.Size = NumberSequence.new(values.size); emitter.Transparency = NumberSequence.new(0.25)
        emitter.LightEmission = 1; emitter.Parent = attachment
        local function bind(character)
            attachment.Parent = character and character:FindFirstChild("HumanoidRootPart") or nil
        end
        bind(app.player.Character)
        scope:connect(app.player.CharacterAdded, bind)
        local hue = 0
        app.scheduler:add(scope, "Heartbeat", 0.1, function(dt)
            hue = (hue + dt * values.speed) % 1
            local color
            if values.mode == "Rainbow" then color = Color3.fromHSV(hue, 0.6, 1)
            elseif values.mode == "Solid" then color = Color3.fromRGB(values.red, values.green, values.blue)
            else color = Color3.fromHSV(0.92 + hue * 0.06, 0.5, 1) end
            emitter.Color = ColorSequence.new(color)
        end)
    end})
    registry:add({id = "hitfeedback", name = "Hit Feedback", category = "Visuals", description = "Shows a hitmarker and damage numbers when you hit someone.", options = {
        O.boolean("marker", "Hitmarker", true), O.boolean("damage", "Damage numbers", true),
        O.boolean("sound", "Hit sound", true), O.boolean("eliminations", "Elimination alerts", true),
        O.number("duration", "Feedback duration (s)", 0.7, 0.2, 3), O.color("color", "Hitmarker color", "F49FC7"),
    }, start = function(scope, values)
        local gui, input = overlay(scope, "hitfeedback"), app.services.UserInputService
        local color = Color3.fromHex(values.color)
        local markers, tracked, markerUntil, attacking = {}, {}, 0, false
        local cross = {}
        if values.marker then
            local holder = frame(scope, gui)
            holder.AnchorPoint = Vector2.new(0.5, 0.5); holder.Size = UDim2.fromOffset(20, 20)
            holder.BackgroundTransparency = 1; holder.Visible = false
            for i = 1, 2 do
                local bar = frame(scope, holder)
                bar.Size = UDim2.fromOffset(16, 2); bar.AnchorPoint = Vector2.new(0.5, 0.5)
                bar.Position = UDim2.fromScale(0.5, 0.5); bar.Rotation = 45 + (i - 1) * 90
                bar.BackgroundColor3 = color
                cross[i] = bar
            end
            cross.holder = holder
        end
        local sound
        if values.sound then
            sound = scope:add(Instance.new("Sound"))
            sound.SoundId = "rbxasset://sounds/electronicpingshort.wav"
            sound.Volume = 0.6; sound.Parent = app.services.SoundService
        end
        local function damageNumber(position, amount)
            if #markers >= 24 then return end
            local label = text(scope, gui)
            label.Size = UDim2.fromOffset(60, 20); label.AnchorPoint = Vector2.new(0.5, 0.5); label.TextSize = 18
            label.TextColor3 = color
            table.insert(markers, {label = label, position = position, amount = amount, start = os.clock()})
        end
        app.scheduler:add(scope, "Heartbeat", 0.05, function()
            attacking = input:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
            for entry in pairs(tracked) do if not app.entities.players[entry.player] then tracked[entry] = nil end end
            for _, entry in ipairs(app.entities.list) do
                local humanoid = entry.humanoid
                if not humanoid then tracked[entry] = nil
                else
                    local state = tracked[entry]
                    if not state or state.humanoid ~= humanoid then
                        tracked[entry] = {humanoid = humanoid, health = humanoid.Health}
                    else
                        local previous = state.health
                        state.health = humanoid.Health
                        -- Attribute drops to the local player while firing or while aimed at the target.
                        if humanoid.Health < previous and (attacking or app.target == entry) then
                            markerUntil = os.clock() + 0.12
                            if entry.root then damageNumber(entry.root.Position + Vector3.yAxis * 3, previous - humanoid.Health) end
                            if sound then sound.TimePosition = 0; sound:Play() end
                            if humanoid.Health <= 0 and values.eliminations then app:notify(app.identities:presentedDisplay(entry.player) .. " eliminated") end
                        end
                    end
                end
            end
        end)
        app.scheduler:add(scope, "RenderStepped", 0, function()
            local camera, now = workspace.CurrentCamera, os.clock()
            if not camera then return end
            if cross.holder then
                cross.holder.Visible = now < markerUntil
                cross.holder.Position = UDim2.fromOffset(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
            end
            for index = #markers, 1, -1 do
                local marker = markers[index]
                local alpha = 1 - (now - marker.start) / values.duration
                local point, onScreen = camera:WorldToViewportPoint(marker.position)
                if alpha <= 0 or not onScreen then
                    marker.label:Destroy(); table.remove(markers, index)
                else
                    marker.label.Visible = values.damage
                    marker.label.Position = UDim2.fromOffset(point.X, point.Y - (1 - alpha) * 30)
                    marker.label.Text = tostring(math.floor(marker.amount))
                    marker.label.TextTransparency = 1 - alpha
                end
            end
        end)
    end})
    registry:add({id = "soundsesp", name = "Sound ESP", category = "Visuals", options = {
        O.number("duration", "Marker lifetime (s)", 0.8, 0.2, 5), O.number("distance", "Maximum distance", 400, 10, 4000),
        O.boolean("labels", "Show sound name", true), O.color("color", "Marker color", "F49FC7"),
    }, start = function(scope, values)
        local gui, markers, pool = overlay(scope, "sounds"), {}, {}
        local color = Color3.fromHex(values.color)
        local function partOf(sound)
            local node = sound.Parent
            while node and node ~= workspace do
                if node:IsA("BasePart") then return node end
                node = node.Parent
            end
            return nil
        end
        local function observe(instance)
            if not instance:IsA("Sound") or not instance:IsDescendantOf(workspace) then return end
            scope:add(instance.Played:Connect(function()
                local part, character = partOf(instance), app.player.Character
                if not part or (character and part:IsDescendantOf(character)) then return end
                table.insert(markers, {position = part.Position, name = instance.Name, start = os.clock()})
            end))
        end
        for _, instance in ipairs(workspace:GetDescendants()) do observe(instance) end
        scope:connect(workspace.DescendantAdded, observe)
        local function acquire(index)
            local item = pool[index]
            if item then return item end
            local dot = frame(scope, gui); dot.AnchorPoint = Vector2.new(0.5, 0.5); dot.Size = UDim2.fromOffset(10, 10)
            dot.BackgroundColor3 = color
            create(scope, "UICorner", {CornerRadius = UDim.new(1, 0)}, dot)
            local label = text(scope, gui); label.AnchorPoint = Vector2.new(0.5, 1); label.Size = UDim2.fromOffset(200, 16)
            label.TextColor3 = color
            item = {dot = dot, label = label}; pool[index] = item
            return item
        end
        app.scheduler:add(scope, "RenderStepped", 0, function()
            local camera, now = workspace.CurrentCamera, os.clock()
            if not camera then return end
            for index = #markers, 1, -1 do
                if now - markers[index].start > values.duration then table.remove(markers, index) end
            end
            for index, marker in ipairs(markers) do
                local item = acquire(index)
                local point, onScreen = camera:WorldToViewportPoint(marker.position)
                local distance = (marker.position - camera.CFrame.Position).Magnitude
                local alpha = 1 - (now - marker.start) / values.duration
                local visible = onScreen and distance <= values.distance
                item.dot.Visible = visible; item.label.Visible = visible and values.labels
                if visible then
                    item.dot.Position = UDim2.fromOffset(point.X, point.Y)
                    item.dot.BackgroundTransparency = 1 - alpha
                    item.label.Position = UDim2.fromOffset(point.X, point.Y - 8)
                    item.label.Text = marker.name
                    item.label.TextTransparency = 1 - alpha
                end
            end
            for index = #markers + 1, #pool do pool[index].dot.Visible = false; pool[index].label.Visible = false end
        end)
    end})
end

end

-- BEGIN src/features/world.lua
factories["features/world"] = function()
local O = require("core/options")
return function(app)
    local registry, lighting = app.registry, app.services.Lighting
    -- Color options are stored as hex, so convert them to Color3 before writing.
    local function colorKeys(options)
        local set = {}
        for _, option in ipairs(options) do if option.kind == "color" then set[option.key] = true end end
        return set
    end
    local lightingOptions = {
        O.number("ClockTime", "Time of day", 14, 0, 24),
        O.number("Brightness", "Brightness", 2, 0, 10),
        O.number("ExposureCompensation", "Exposure", 0, -5, 5),
        O.boolean("GlobalShadows", "Global shadows", true),
        O.number("EnvironmentDiffuseScale", "Diffuse scale", 1, 0, 1),
        O.number("EnvironmentSpecularScale", "Specular scale", 1, 0, 1),
        O.color("ColorShift_Top", "Sky tint", "FFFFFF"),
        O.color("ColorShift_Bottom", "Ground tint", "FFFFFF"),
    }
    local lightingColors = colorKeys(lightingOptions)
    registry:add({id = "lighting", live = true, name = "Lighting", category = "World", options = lightingOptions, start = function(scope, values)
        app.scheduler:add(scope, "Heartbeat", 0.25, function()
            for key, value in pairs(values) do
                app.overrides:set(scope, lighting, key, lightingColors[key] and Color3.fromHex(value) or value)
            end
        end)
    end})
    registry:add({id = "fog", name = "Fog", category = "World", options = {
        O.number("start", "Fog start", 0, 0, 100000), O.number("finish", "Fog end", 100000, 0, 100000),
        O.color("color", "Fog color", "C8B4DC"),
    }, start = function(scope, values)
        app.overrides:set(scope, lighting, "FogStart", values.start)
        app.overrides:set(scope, lighting, "FogEnd", math.max(values.start, values.finish))
        app.overrides:set(scope, lighting, "FogColor", Color3.fromHex(values.color))
    end})
    registry:add({id = "ambient", name = "Ambient Colors", category = "World", options = {
        O.color("color", "Ambient color", "B496D2"),
    }, start = function(scope, values)
        local color = Color3.fromHex(values.color)
        app.overrides:set(scope, lighting, "Ambient", color)
        app.overrides:set(scope, lighting, "OutdoorAmbient", color)
    end})
    registry:add({id = "fullbright", name = "Fullbright", category = "World", options = {
        O.number("brightness", "Brightness", 1, 0, 1), O.boolean("noFog", "Remove fog", true),
    }, start = function(scope, values)
        local color = Color3.new(values.brightness, values.brightness, values.brightness)
        app.overrides:set(scope, lighting, "Ambient", color)
        app.overrides:set(scope, lighting, "OutdoorAmbient", color)
        app.overrides:set(scope, lighting, "Brightness", 3)
        if values.noFog then
            app.overrides:set(scope, lighting, "FogStart", 0)
            app.overrides:set(scope, lighting, "FogEnd", 1000000)
            app.overrides:set(scope, lighting, "FogColor", color)
        end
    end})
    local function effect(id, name, class, options)
        local colors = colorKeys(options)
        registry:add({id = id, name = name, category = "World", options = options, start = function(scope, values)
            local object = scope:add(Instance.new(class))
            object.Name = "femboyware_" .. id
            for key, value in pairs(values) do object[key] = colors[key] and Color3.fromHex(value) or value end
            object.Parent = lighting
        end})
    end
    effect("color", "Color Correction", "ColorCorrectionEffect", {
        O.number("Saturation", "Saturation", 0.1, -1, 1), O.number("Contrast", "Contrast", 0.1, -1, 1), O.number("Brightness", "Brightness", 0, -1, 1),
        O.color("TintColor", "Tint", "FFFFFF"),
    })
    effect("bloom", "Bloom", "BloomEffect", {
        O.number("Intensity", "Intensity", 0.6, 0, 5), O.number("Size", "Size", 26, 0, 56), O.number("Threshold", "Threshold", 0.4, 0, 5),
    })
    effect("sunrays", "Sun Rays", "SunRaysEffect", {
        O.number("Intensity", "Intensity", 0.2, 0, 1), O.number("Spread", "Spread", 0.5, 0, 1),
    })
    effect("blur", "Blur", "BlurEffect", {O.number("Size", "Blur size", 8, 0, 56)})
    effect("dof", "Depth of Field", "DepthOfFieldEffect", {
        O.number("FarIntensity", "Far intensity", 0.2, 0, 1), O.number("NearIntensity", "Near intensity", 0, 0, 1),
        O.number("FocusDistance", "Focus distance", 50, 0, 500), O.number("InFocusRadius", "Focus radius", 20, 0, 500),
    })
    effect("atmosphere", "Atmosphere", "Atmosphere", {
        O.number("Density", "Density", 0.3, 0, 1), O.number("Offset", "Offset", 0, -1, 1),
        O.number("Glare", "Glare", 0, 0, 10), O.number("Haze", "Haze", 0, 0, 10),
        O.color("Color", "Color", "C8B4DC"), O.color("Decay", "Decay", "FECAFE"),
    })
    registry:add({id = "fov", live = true, name = "Camera FOV", category = "Camera", options = {O.number("value", "Field of view", 100, 1, 120)}, start = function(scope, values)
        app.scheduler:add(scope, "RenderStepped", 0, function()
            local camera = workspace.CurrentCamera
            if camera then app.overrides:set(scope, camera, "FieldOfView", values.value) end
        end)
    end})
    registry:add({id = "sky", name = "Custom Skybox", category = "World", options = {
        O.text("Bk", "Back asset ID", ""), O.text("Dn", "Down asset ID", ""), O.text("Ft", "Front asset ID", ""),
        O.text("Lf", "Left asset ID", ""), O.text("Rt", "Right asset ID", ""), O.text("Up", "Up asset ID", ""),
        O.boolean("CelestialBodiesShown", "Sun and moon", true),
    }, start = function(scope, values)
        for _, object in ipairs(lighting:GetChildren()) do
            if object:IsA("Sky") then app.overrides:set(scope, object, "Parent", nil) end
        end
        local sky = scope:add(Instance.new("Sky"))
        sky.Name = "femboyware_sky"
        for key, value in pairs(values) do
            if key ~= "CelestialBodiesShown" then
                assert(value:match("^%d+$") or value:match("^rbxassetid://%d+$"), "Enter all six skybox asset IDs")
                sky["Skybox" .. key] = value:match("^%d+$") and "rbxassetid://" .. value or value
            end
        end
        sky.CelestialBodiesShown = values.CelestialBodiesShown
        sky.Parent = lighting
    end})
    registry:add({id = "ambience", name = "Ambient Sound", category = "World", options = {
        O.text("asset", "Sound asset ID", ""), O.number("volume", "Volume", 0.5, 0, 2), O.number("speed", "Playback speed", 1, 0.1, 3),
    }, start = function(scope, values)
        assert(values.asset:match("^%d+$"), "Enter a numeric sound asset ID")
        local sound = scope:add(Instance.new("Sound"))
        sound.SoundId = "rbxassetid://" .. values.asset
        sound.Volume = values.volume; sound.PlaybackSpeed = values.speed; sound.Looped = true
        sound.Parent = app.services.SoundService; sound:Play()
    end})
    registry:add({id = "xray", name = "XRay", category = "Visuals", options = {
        O.number("alpha", "Wall transparency", 0.65, 0, 1),
    }, start = function(scope, values)
        local map = workspace:FindFirstChild("Map") or workspace:FindFirstChild("MapFolder")
        assert(map, "Map container unavailable; XRay requires Map or MapFolder")
        local function apply(object)
            if object:IsA("BasePart") then app.overrides:set(scope, object, "LocalTransparencyModifier", values.alpha) end
        end
        for _, object in ipairs(map:GetDescendants()) do apply(object) end
        scope:connect(map.DescendantAdded, apply)
    end})
end

end

-- BEGIN src/main.lua
factories["main"] = function()
local Scope = require("core/scope")
local Scheduler = require("core/scheduler")
local Overrides = require("core/overrides")
local Registry = require("core/registry")
local Entities = require("core/entities")
local Rivals = require("core/rivals")
local Identity = require("core/identity")
local Match = require("core/match")
local UI = require("core/ui")
local environment = getgenv and getgenv() or _G
local previous = environment.Femboyware
if previous and type(previous.Unload) == "function" then previous:Unload() end
if not game:IsLoaded() then game.Loaded:Wait() end
local app = {version = "0.4.4", scope = Scope.new(), services = {}, profileParts = {}, destroyed = false,
    menuOpen = false, rivalsReady = false, readyListeners = {}}
for _, name in ipairs({"Players", "RunService", "UserInputService", "GuiService", "ReplicatedStorage", "HttpService", "Lighting", "SoundService", "TextChatService", "VRService"}) do
    app.services[name] = game:GetService(name)
end
app.player = assert(app.services.Players.LocalPlayer, "femboyware must run on a client")
function app:capability(name)
    local value = environment[name]
    if type(value) ~= "function" and getfenv then value = getfenv()[name] end
    return type(value) == "function" and value or nil
end
function app:notify(message)
    message = tostring(message)
    warn("[femboyware] " .. message)
    if self.onNotify then self.onNotify(message) end
end
function app:guiParent()
    local hidden = self:capability("gethui")
    if hidden then
        local ok, parent = pcall(hidden)
        if ok and typeof(parent) == "Instance" then return parent end
    end
    return self.player:FindFirstChildOfClass("PlayerGui") or self.player:WaitForChild("PlayerGui", 10)
end
function app:character()
    local character = self.player.Character
    return character and character:FindFirstChild("HumanoidRootPart"), character and character:FindFirstChildOfClass("Humanoid")
end
-- Game modules cannot be required from an elevated executor thread; run the
-- require (or call) at identity 2 and restore afterwards.
function app:identity(level)
    local get = self:capability("getthreadidentity") or self:capability("getidentity") or self:capability("get_thread_identity")
    local set = self:capability("setthreadidentity") or self:capability("setidentity") or self:capability("set_thread_identity")
    if not get or not set then return function() end end
    local ok, previous = pcall(get)
    if not ok then return function() end end
    pcall(set, level)
    return function() pcall(set, previous) end
end
-- Run once Rivals is loaded, immediately when that already happened.
function app:onReady(callback)
    if self.rivalsReady then callback() else table.insert(self.readyListeners, callback) end
end
local settingsFile = "femboyware_settings.json"
local function validName(name)
    return type(name) == "string" and #name >= 1 and #name <= 64 and name:match("^[%w_-]+$") ~= nil
end
function app:readSettings()
    local settings = {autoLoad = false, autoLoadName = "default"}
    local read = self:capability("readfile")
    if not read then return settings end
    local ok, content = pcall(read, settingsFile)
    if not ok or type(content) ~= "string" or #content == 0 or #content > 100000 then return settings end
    local decoded
    ok, decoded = pcall(function() return self.services.HttpService:JSONDecode(content) end)
    if not ok or type(decoded) ~= "table" then return settings end
    if type(decoded.autoLoad) == "boolean" then settings.autoLoad = decoded.autoLoad end
    if validName(decoded.autoLoadName) then settings.autoLoadName = decoded.autoLoadName end
    return settings
end
function app:saveSettings()
    local write = self:capability("writefile")
    if not write then return false end
    local ok, err = pcall(write, settingsFile, self.services.HttpService:JSONEncode(self.settings))
    if not ok then self:notify("Could not save settings: " .. tostring(err)) end
    return ok
end
app.scheduler = Scheduler.new(app.services.RunService, function(message) app:notify(message) end)
app.overrides = Overrides.new()
app.registry = Registry.new(app)
app.rivals = Rivals.new(app)
app.identities = Identity.new(app)
app.settings = app:readSettings()
app.rivalsReady = false
app.match = Match.new(app)
function app:blockReason(feature)
    return self.match:unavailable(feature)
end
function app:openMenu()
    if self.setMenuOpen then self.setMenuOpen(true) end
end
function app:Unload()
    if self.destroyed then return end
    self.destroyed = true
    self.registry:Destroy()
    self.scope:Destroy()
    table.clear(self.rivals.modules)
    table.clear(self.readyListeners)
    self.recording = nil
    self.target = nil
    if environment.Femboyware == self then environment.Femboyware = nil end
end
function app:exportProfile()
    local data = self.registry:snapshot()
    data.extensions = {}
    for name, part in pairs(self.profileParts) do data.extensions[name] = part.save() end
    return self.services.HttpService:JSONEncode(data)
end
function app:importProfile(json)
    assert(type(json) == "string" and #json <= 1000000, "Invalid profile or profile exceeds 1 MB")
    local data = self.services.HttpService:JSONDecode(json)
    self.registry:validate(data)
    assert(data.extensions == nil or type(data.extensions) == "table", "Invalid profile extensions")
    for name, part in pairs(self.profileParts) do
        if data.extensions and data.extensions[name] ~= nil then part.validate(data.extensions[name]) end
    end
    for _, feature in ipairs(self.registry.list) do self.registry:enable(feature.id, false) end
    for name, part in pairs(self.profileParts) do part.load(data.extensions and data.extensions[name]) end
    self.registry:load(data)
end
local function filename(name, extension)
    assert(type(name) == "string" and #name <= 64 and name:match("^[%w_-]+$"), "Use 1–64 letters, numbers, underscores, or hyphens for file names")
    return "femboyware_" .. name .. extension
end
function app:saveProfile(name)
    local write = assert(self:capability("writefile"), "Executor does not expose writefile; use exportProfile()")
    write(filename(name, ".json"), self:exportProfile())
end
function app:loadProfile(name)
    local read = assert(self:capability("readfile"), "Executor does not expose readfile; use importProfile(json)")
    self:importProfile(read(filename(name, ".json")))
end
function app:deleteProfile(name)
    local remove = assert(self:capability("delfile"), "Executor does not expose delfile")
    remove(filename(name, ".json"))
end
-- Names of saved configs in the executor's working directory, sorted.
function app:listProfiles()
    local list = self:capability("listfiles")
    if not list then return {} end
    local ok, files = pcall(list, "")
    if not ok or type(files) ~= "table" then return {} end
    local result = {}
    for _, file in ipairs(files) do
        local name = tostring(file):match("femboyware_([%w_-]+)%.json$")
        if name and name ~= "settings" and not table.find(result, name) then table.insert(result, name) end
    end
    table.sort(result)
    return result
end
function app:saveRecording(name)
    local write = assert(self:capability("writefile"), "Executor does not expose writefile")
    write(filename(name, ".recording.json"), self:exportRecording())
end
function app:loadRecording(name)
    local read = assert(self:capability("readfile"), "Executor does not expose readfile")
    self:importRecording(read(filename(name, ".recording.json")))
end
function app:autoLoadConfig()
    if not self.settings.autoLoad then return end
    local name = self.settings.autoLoadName
    if not self:capability("readfile") then
        self:notify("Auto load is on, but this executor does not expose readfile")
        return
    end
    local ok, err = pcall(function() self:loadProfile(name) end)
    if ok then self:notify("Auto-loaded config '" .. name .. "'") else self:notify("Auto load failed: " .. tostring(err)) end
end
local ok, err = pcall(function()
    app.entities = Entities.new(app)
    require("features/combat")(app)
    require("features/human_aim")(app)
    require("features/cosmetics")(app)
    require("features/movement")(app)
    require("features/visuals")(app)
    require("features/world")(app)
    require("features/automation")(app)
    require("features/player")(app)
    require("features/recording")(app)
    require("features/security")(app)
    UI.mount(app)
end)
if not ok then app:Unload(); error("femboyware startup failed: " .. tostring(err)) end
environment.Femboyware = app
local SETTLE_SECONDS = 2
local readySince
local function ready()
    if app.destroyed or app.rivalsReady then return end
    if not app.rivals:ready() then readySince = nil; return end
    -- Require the game to stay loaded for a moment, not just flicker past the checks.
    local now = os.clock()
    if not readySince then readySince = now; return end
    if now - readySince < SETTLE_SECONDS then return end
    app.rivalsReady = true
    app.match:refresh()
    local listeners = app.readyListeners
    app.readyListeners = {}
    for _, callback in ipairs(listeners) do pcall(callback) end
    app:autoLoadConfig()
    app:openMenu()
end
if not app.rivals:ready() then app:notify("Waiting for Rivals to load before opening the window") end
ready()
local nextCheck = 0
app.scope:connect(app.services.RunService.Heartbeat, function()
    local now = os.clock()
    if now < nextCheck then return end
    nextCheck = now + 0.5
    ready()
end)
app:notify(string.format("femboyware v%s :3 — %d features • RightShift opens settings", app.version, #app.registry.list))
return app

end

--[[
LinoriaLib license:
MIT License

Copyright (c) 2021 violin-suzutsuki

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

]]
factories["vendor/LinoriaLib"] = function()
-- femboyware patch: vendored from mstudio45/LinoriaLib (MIT).
-- Remote icon Lua and asset downloads are disabled for offline, auditable use.

local cloneref = (cloneref or clonereference or function(instance: any)
	return instance
end)
local InputService: UserInputService = cloneref(game:GetService("UserInputService"))
local TextService: TextService = cloneref(game:GetService("TextService"))
local CoreGui: CoreGui = cloneref(game:GetService("CoreGui"))
local Teams: Teams = cloneref(game:GetService("Teams"))
local Players: Players = cloneref(game:GetService("Players"))
local RunService: RunService = cloneref(game:GetService("RunService"))
local TweenService: TweenService = cloneref(game:GetService("TweenService"))

local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()
local Mouse = cloneref(LocalPlayer:GetMouse())

local DrawingLib = { drawing_replaced = true, new = function(...) error("Drawing is not supported.") end }
local IsBadDrawingLib = false

if typeof(getgenv) == "function" and typeof(getgenv().Drawing) == "table" then
    DrawingLib = getgenv().Drawing
end

local setclipboard = setclipboard or nil
local getgenv = getgenv or function()
	return shared
end
local ProtectGui = protectgui or (syn and syn.protect_gui) or function() end
local GetHUI = gethui or function()
	return CoreGui
end

local assert = function(condition, errorMessage)
	if not condition then
		error(if errorMessage then errorMessage else "assert failed", 3)
	end
end

local function SafeParentUI(Instance: Instance, Parent: Instance | () -> Instance)
	local success, _error = pcall(function()
		if not Parent then
			Parent = CoreGui
		end

		local DestinationParent
		if typeof(Parent) == "function" then
			DestinationParent = Parent()
		else
			DestinationParent = Parent
		end

		Instance.Parent = DestinationParent
	end)

	if not (success and Instance.Parent) then
		Instance.Parent = LocalPlayer:WaitForChild("PlayerGui", math.huge)
	end
end

local function ParentUI(UI: Instance, SkipHiddenUI: boolean?)
	if SkipHiddenUI then
		SafeParentUI(UI, CoreGui)
		return
	end

	pcall(ProtectGui, UI)
	SafeParentUI(UI, GetHUI)
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
ScreenGui.DisplayOrder = 999
ScreenGui.ResetOnSpawn = false
ParentUI(ScreenGui)

local ModalElement = Instance.new("TextButton")
ModalElement.BackgroundTransparency = 1
ModalElement.Modal = false
ModalElement.Size = UDim2.fromScale(0, 0)
ModalElement.AnchorPoint = Vector2.zero
ModalElement.Text = ""
ModalElement.ZIndex = -999
ModalElement.Parent = ScreenGui

local LibraryMainOuterFrame = nil

local Toggles = {}
local Options = {}
local Labels = {}
local Buttons = {}
local Tooltips = {}
local Dialogues = {}

-- https://github.com/deividcomsono/Obsidian/blob/main/Library.lua#L30
local BaseURL = "https://raw.githubusercontent.com/mstudio45/LinoriaLib/refs/heads/main/"
local CustomImageManager = {}
local CustomImageManagerAssets = {
    Cursor = {
        RobloxId = 9619665977,
        Path = "LinoriaLib/assets/Cursor.png",
        URL = BaseURL .. "assets/Cursor.png",

        Id = nil,
    },

    DropdownArrow = {
        RobloxId = 6282522798,
        Path = "LinoriaLib/assets/DropdownArrow.png",
        URL = BaseURL .. "assets/DropdownArrow.png",

        Id = nil,
    },

    Checker = {
        RobloxId = 12977615774,
        Path = "LinoriaLib/assets/Checker.png",
        URL = BaseURL .. "assets/Checker.png",

        Id = nil,
    },

    CheckerLong = {
        RobloxId = 12978095818,
        Path = "LinoriaLib/assets/CheckerLong.png",
        URL = BaseURL .. "assets/CheckerLong.png",

        Id = nil,
    },

    SaturationMap = {
        RobloxId = 4155801252,
        Path = "LinoriaLib/assets/SaturationMap.png",
        URL = BaseURL .. "assets/SaturationMap.png",

        Id = nil,
    }
}
do
    local function RecursiveCreatePath(Path: string, IsFile: boolean?)
        if not isfolder or not makefolder then
            return
        end

        local Segments = Path:split("/")
        local TraversedPath = ""

        if IsFile then
            table.remove(Segments, #Segments)
        end

        for _, Segment in ipairs(Segments) do
            if not isfolder(TraversedPath .. Segment) then
                makefolder(TraversedPath .. Segment)
            end

            TraversedPath = TraversedPath .. Segment .. "/"
        end

        return TraversedPath
    end

    function CustomImageManager.AddAsset(AssetName: string, RobloxAssetId: number, URL: string, ForceRedownload: boolean?)
        if CustomImageManagerAssets[AssetName] ~= nil then
            error(string.format("Asset %q already exists", AssetName))
        end

        assert(typeof(RobloxAssetId) == "number", "RobloxAssetId must be a number")

        CustomImageManagerAssets[AssetName] = {
            RobloxId = RobloxAssetId,
            Path = string.format("Obsidian/custom_assets/%s", AssetName),
            URL = URL,

            Id = nil,
        }

        CustomImageManager.DownloadAsset(AssetName, ForceRedownload)
    end

    function CustomImageManager.GetAsset(AssetName: string)
        if not CustomImageManagerAssets[AssetName] then
            return nil
        end

        local AssetData = CustomImageManagerAssets[AssetName]
        if AssetData.Id then
            return AssetData.Id
        end

        local AssetID = string.format("rbxassetid://%s", AssetData.RobloxId)

        if getcustomasset then
            local Success, NewID = pcall(getcustomasset, AssetData.Path)

            if Success and NewID then
                AssetID = NewID
            end
        end

        AssetData.Id = AssetID
        return AssetID
    end

    function CustomImageManager.DownloadAsset(AssetName: string, ForceRedownload: boolean?)
        if not getcustomasset or not writefile or not isfile then
            return false, "missing functions"
        end

        local AssetData = CustomImageManagerAssets[AssetName]

        RecursiveCreatePath(AssetData.Path, true)

        if ForceRedownload ~= true and isfile(AssetData.Path) then
            return true, nil
        end

        local success, errorMessage = pcall(function()
            writefile(AssetData.Path, game:HttpGet(AssetData.URL))
        end)

        return success, errorMessage
    end

    -- femboyware patch: assets stay bundled/offline; use the Roblox fallback ids.
end

local DPIScale = 1;
local Library = {
    Registry = {};
    RegistryMap = {};
    HudRegistry = {};

    -- colors and font --
    FontColor = Color3.fromRGB(255, 255, 255);
    MainColor = Color3.fromRGB(28, 28, 28);
    BackgroundColor = Color3.fromRGB(20, 20, 20);

    AccentColor = Color3.fromRGB(0, 85, 255);
    DisabledAccentColor = Color3.fromRGB(142, 142, 142);

    OutlineColor = Color3.fromRGB(50, 50, 50);
    DisabledOutlineColor = Color3.fromRGB(70, 70, 70);

    DisabledTextColor = Color3.fromRGB(142, 142, 142);

    RiskColor = Color3.fromRGB(255, 50, 50);

    Black = Color3.new(0, 0, 0);
    Font = Enum.Font.Code,

    -- frames --
    OpenedFrames = {};
    DependencyBoxes = {};
    DependencyGroupboxes = {};

    -- signals --
    UnloadSignals = {};
    Signals = {};

    -- gui --
    ActiveTab = nil;
    TotalTabs = 0;

    ScreenGui = ScreenGui;
    KeybindFrame = nil;
    KeybindContainer = nil;
    Window = { Holder = nil; Tabs = {}; };

    -- variables --
    VideoLink = "";
    
    Toggled = false;
    ToggleKeybind = nil;

    IsMobile = false;
    DevicePlatform = Enum.Platform.None;

    CanDrag = true;
    CantDragForced = false;

    Unloaded = false;

    -- notification --
    Notify = nil;
    NotifySide = "Left";
    ShowCustomCursor = true;
    ShowToggleFrameInKeybinds = true;
    NotifyOnError = false; -- true = Library:Notify for SafeCallback (still warns in the developer console)

    -- addons --
    SaveManager = nil;
    ThemeManager = nil;

    -- for better usage --
    Toggles = Toggles;
    Options = Options;
    Labels = Labels;
    Buttons = Buttons;
    Dialogues = Dialogues;
    ActiveDialog = nil;

    ImageManager = CustomImageManager;
    ShowCursorBinding = string.sub(tostring({}), 10);
}

if RunService:IsStudio() then
   Library.IsMobile = InputService.TouchEnabled and not InputService.MouseEnabled 
else
    pcall(function() Library.DevicePlatform = InputService:GetPlatform() end) -- For safety so the UI library doesn't error.
    Library.IsMobile = (Library.DevicePlatform == Enum.Platform.Android or Library.DevicePlatform == Enum.Platform.IOS)
end

Library.MinSize = if Library.IsMobile then Vector2.new(550, 200) else Vector2.new(550, 300)

--// Functions \\--
local function ApplyDPIScale(Position)
    return UDim2.new(Position.X.Scale, Position.X.Offset * DPIScale, Position.Y.Scale, Position.Y.Offset * DPIScale)
end

local function ApplyTextScale(TextSize)
    return TextSize * DPIScale
end

local function GetTableSize(t)
    local n = 0
    for _, _ in pairs(t) do
        n = n + 1
    end
    return n
end

local function GetPlayers(ExcludeLocalPlayer, ReturnInstances)
    local PlayerList = Players:GetPlayers()

    if ExcludeLocalPlayer then
        local Idx = table.find(PlayerList, LocalPlayer)

        if Idx then
            table.remove(PlayerList, Idx)
        end
    end

    table.sort(PlayerList, function(Player1, Player2)
        return Player1.Name:lower() < Player2.Name:lower()
    end)

    if ReturnInstances == true then
        return PlayerList
    end

    local FixedPlayerList = {}
    for _, player in next, PlayerList do
        FixedPlayerList[#FixedPlayerList + 1] = player.Name
    end

    return FixedPlayerList
end

local function GetTeams(ReturnInstances)
    local TeamList = Teams:GetTeams()

    table.sort(TeamList, function(Team1, Team2)
        return Team1.Name:lower() < Team2.Name:lower()
    end)

    if ReturnInstances == true then
        return TeamList
    end

    local FixedTeamList = {}
    for _, team in next, TeamList do
        FixedTeamList[#FixedTeamList + 1] = team.Name
    end

    return FixedTeamList
end

local function Trim(Text: string)
    return Text:match("^%s*(.-)%s*$")
end

--// Icon Module \\--
type Icon = {
    Url: string,
    Id: number,
    IconName: string,
    ImageRectOffset: Vector2,
    ImageRectSize: Vector2,
}

type IconModule = {
    Icons: { string },
    GetAsset: (Name: string) -> Icon?,
}

-- femboyware patch: never download or load remote Lua for icons.
local FetchIcons, Icons = false, nil

function IsValidCustomIcon(Icon: string)
    return typeof(Icon) == "string"
        and (Icon:match("rbxasset") or Icon:match("roblox%.com/asset/%?id=") or Icon:match("rbxthumb://type="))
end

function Library:GetIcon(IconName: string)
    if not FetchIcons or not Icons then
        return
    end

    local Success, Icon = pcall(Icons.GetAsset, IconName)
    if not Success then
        return
    end

    return Icon
end

function Library:GetCustomIcon(IconName: string)
    if not IsValidCustomIcon(IconName) then
        return Library:GetIcon(IconName)
    else
        return {
            Url = IconName,
            ImageRectOffset = Vector2.zero,
            ImageRectSize = Vector2.zero,
            Custom = true,
        }
    end
end

function Library:SetIconModule(module: IconModule)
    FetchIcons = true
    Icons = module
end

function Library:GetBetterColor(Color: Color3, Add: number): Color3
    Add = Add * 2
    return Color3.fromRGB(
        math.clamp(Color.R * 255 + Add, 0, 255),
        math.clamp(Color.G * 255 + Add, 0, 255),
        math.clamp(Color.B * 255 + Add, 0, 255)
    )
end

--// Library Functions \\--
function Library:Validate(Table: { [string]: any }, Template: { [string]: any }): { [string]: any }
    if typeof(Table) ~= "table" then
        return Template
    end

    for k, v in pairs(Template) do
        if typeof(k) == "number" then
            continue
        end

        if typeof(v) == "table" then
            Table[k] = Library:Validate(Table[k], v)
        elseif Table[k] == nil then
            Table[k] = v
        end
    end

    return Table
end

function Library:SetDPIScale(value: number) 
    assert(type(value) == "number", "Expected type number for DPI scale but got " .. typeof(value))
    
    DPIScale = value / 100
    Library.MinSize = (if Library.IsMobile then Vector2.new(550, 200) else Vector2.new(550, 300)) * DPIScale
end

function Library:SafeCallback(Func, ...)
    -- https://github.com/deividcomsono/Obsidian/blob/main/Library.lua#L1100
    if not (Func and typeof(Func) == "function") then
        return
    end

    local Result = table.pack(xpcall(Func, function(Error)
        task.defer(error, debug.traceback(Error, 2))
        if Library.NotifyOnError then
            Library:Notify(Error)
        end

        return Error
    end, ...))

    if not Result[1] then
        return nil
    end

    return table.unpack(Result, 2, Result.n)
end

function Library:AttemptSave()
    if (not Library.SaveManager) then return end
    Library.SaveManager:Save()
end

function Library:Create(Class, Properties)
    local _Instance = Class

    if typeof(Class) == "string" then
        _Instance = Instance.new(Class)
    end

    for Property, Value in next, Properties do
        if (Property == "Size" or Property == "Position") then
            Value = ApplyDPIScale(Value)
        elseif Property == "TextSize" then
            Value = ApplyTextScale(Value)
        end

        local success, err = pcall(function()
            _Instance[Property] = Value
        end)

        if (not success) then
            warn(err)
        end
    end

    return _Instance
end

function Library:ApplyTextStroke(Inst)
    Inst.TextStrokeTransparency = 1

    return Library:Create("UIStroke", {
        Color = Color3.new(0, 0, 0);
        Thickness = 1;
        LineJoinMode = Enum.LineJoinMode.Miter;
        Parent = Inst;
    })
end

function Library:CreateLabel(Properties, IsHud)
    local _Instance = Library:Create("TextLabel", {
        BackgroundTransparency = 1;
        Font = Library.Font;
        TextColor3 = Library.FontColor;
        TextSize = 16;
        TextStrokeTransparency = 0;
    })

    Library:ApplyTextStroke(_Instance)

    Library:AddToRegistry(_Instance, {
        TextColor3 = "FontColor";
    }, IsHud)

    return Library:Create(_Instance, Properties)
end

function Library:MakeDraggable(Instance, Cutoff, IsMainWindow)
    Instance.Active = true

    if Library.IsMobile == false then
        Instance.InputBegan:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                if IsMainWindow == true and Library.CantDragForced == true then
                    return
                end
           
                local ObjPos = Vector2.new(
                    Mouse.X - Instance.AbsolutePosition.X,
                    Mouse.Y - Instance.AbsolutePosition.Y
                )

                if ObjPos.Y > (Cutoff or 40) then
                    return
                end

                while InputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
                    Instance.Position = UDim2.new(
                        0,
                        Mouse.X - ObjPos.X + (Instance.Size.X.Offset * Instance.AnchorPoint.X),
                        0,
                        Mouse.Y - ObjPos.Y + (Instance.Size.Y.Offset * Instance.AnchorPoint.Y)
                    )

                    RunService.RenderStepped:Wait()
                end
            end
        end)
    else
        local Dragging, DraggingInput, DraggingStart, StartPosition

        InputService.TouchStarted:Connect(function(Input)
            if IsMainWindow == true and Library.CantDragForced == true then
                Dragging = false
                return
            end

            if not Dragging and Library:MouseIsOverFrame(Instance, Input) and (IsMainWindow == true and (Library.CanDrag == true and Library.Window.Holder.Visible == true) or true) then
                DraggingInput = Input
                DraggingStart = Input.Position
                StartPosition = Instance.Position

                local OffsetPos = Input.Position - DraggingStart
                if OffsetPos.Y > (Cutoff or 40) then
                    Dragging = false
                    return
                end

                Dragging = true
            end
        end)
        InputService.TouchMoved:Connect(function(Input)
            if IsMainWindow == true and Library.CantDragForced == true then
                Dragging = false
                return
            end

            if Input == DraggingInput and Dragging and (IsMainWindow == true and (Library.CanDrag == true and Library.Window.Holder.Visible == true) or true) then
                local OffsetPos = Input.Position - DraggingStart

                Instance.Position = UDim2.new(
                    StartPosition.X.Scale,
                    StartPosition.X.Offset + OffsetPos.X,
                    StartPosition.Y.Scale,
                    StartPosition.Y.Offset + OffsetPos.Y
                )
            end
        end)
        InputService.TouchEnded:Connect(function(Input)
            if Input == DraggingInput then 
                Dragging = false
            end
        end)
    end
end

function Library:MakeDraggableUsingParent(Instance, Parent, Cutoff, IsMainWindow)
    Instance.Active = true

    if Library.IsMobile == false then
        Instance.InputBegan:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                if IsMainWindow == true and Library.CantDragForced == true then
                    return
                end
  
                local ObjPos = Vector2.new(
                    Mouse.X - Parent.AbsolutePosition.X,
                    Mouse.Y - Parent.AbsolutePosition.Y
                )

                if ObjPos.Y > (Cutoff or 40) then
                    return
                end

                while InputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
                    Parent.Position = UDim2.new(
                        0,
                        Mouse.X - ObjPos.X + (Parent.Size.X.Offset * Parent.AnchorPoint.X),
                        0,
                        Mouse.Y - ObjPos.Y + (Parent.Size.Y.Offset * Parent.AnchorPoint.Y)
                    )

                    RunService.RenderStepped:Wait()
                end
            end
        end)
    else  
        Library:MakeDraggable(Parent, Cutoff, IsMainWindow)
    end
end

function Library:MakeResizable(Instance, MinSize)
    if Library.IsMobile then
        return
    end

    Instance.Active = true
    
    local ResizerImage_Size = 25 * DPIScale
    local ResizerImage_HoverTransparency = 0.5

    local Resizer = Library:Create("Frame", {
        SizeConstraint = Enum.SizeConstraint.RelativeXX;
        BackgroundColor3 = Color3.new(0, 0, 0);
        BackgroundTransparency = 1;
        BorderSizePixel = 0;
        Size = UDim2.new(0, 30, 0, 30);
        Position = UDim2.new(1, -30, 1, -30);
        Visible = true;
        ClipsDescendants = true;
        ZIndex = 1;
        Parent = Instance;--Library.ScreenGui;
    })

    local ResizerImage = Library:Create("ImageButton", {
        BackgroundColor3 = Library.AccentColor;
        BackgroundTransparency = 1;
        BorderSizePixel = 0;
        Size = UDim2.new(2, 0, 2, 0);
        Position = UDim2.new(1, -30, 1, -30);
        ZIndex = 2;
        Parent = Resizer;
    })

    local ResizerImageUICorner = Library:Create("UICorner", {
        CornerRadius = UDim.new(0.5, 0);
        Parent = ResizerImage;
    })

    Library:AddToRegistry(ResizerImage, { BackgroundColor3 = "AccentColor"; })

    Resizer.Size = UDim2.fromOffset(ResizerImage_Size, ResizerImage_Size)
    Resizer.Position = UDim2.new(1, -ResizerImage_Size, 1, -ResizerImage_Size)
    MinSize = MinSize or Library.MinSize

    local OffsetPos
    Resizer.Parent = Instance

    local function FinishResize(Transparency)
        ResizerImage.Position = UDim2.new()
        ResizerImage.Size = UDim2.new(2, 0, 2, 0)
        ResizerImage.Parent = Resizer
        ResizerImage.BackgroundTransparency = Transparency
        ResizerImageUICorner.Parent = ResizerImage
        OffsetPos = nil
    end

    ResizerImage.MouseButton1Down:Connect(function()
        if not OffsetPos then
            OffsetPos = Vector2.new(Mouse.X - (Instance.AbsolutePosition.X + Instance.AbsoluteSize.X), Mouse.Y - (Instance.AbsolutePosition.Y + Instance.AbsoluteSize.Y))

            ResizerImage.BackgroundTransparency = 1
            ResizerImage.Size = UDim2.fromOffset(Library.ScreenGui.AbsoluteSize.X, Library.ScreenGui.AbsoluteSize.Y)
            ResizerImage.Position = UDim2.new()
            ResizerImageUICorner.Parent = nil
            ResizerImage.Parent = Library.ScreenGui
        end
    end)

    ResizerImage.MouseMoved:Connect(function()
        if OffsetPos then		
            local MousePos = Vector2.new(Mouse.X - OffsetPos.X, Mouse.Y - OffsetPos.Y)
            local FinalSize = Vector2.new(math.clamp(MousePos.X - Instance.AbsolutePosition.X, MinSize.X, math.huge), math.clamp(MousePos.Y - Instance.AbsolutePosition.Y, MinSize.Y, math.huge))
            Instance.Size = UDim2.fromOffset(FinalSize.X, FinalSize.Y)
        end
    end)

    ResizerImage.MouseEnter:Connect(function()
        FinishResize(ResizerImage_HoverTransparency)
    end)

    ResizerImage.MouseLeave:Connect(function()
        FinishResize(1)
    end)

    ResizerImage.MouseButton1Up:Connect(function()
        FinishResize(ResizerImage_HoverTransparency)
    end)
end

function Library:AddToolTip(InfoStr, DisabledInfoStr, HoverInstance)
    InfoStr = typeof(InfoStr) == "string" and InfoStr or nil
    DisabledInfoStr = typeof(DisabledInfoStr) == "string" and DisabledInfoStr or nil

    local Tooltip = Library:Create("Frame", {
        BackgroundColor3 = Library.MainColor;
        BorderColor3 = Library.OutlineColor;

        ZIndex = 100;
        Parent = Library.ScreenGui;

        Visible = false;
    })

    local Label = Library:CreateLabel({
        Position = UDim2.fromOffset(3, 1);
        
        TextSize = 14;
        Text = InfoStr;
        TextColor3 = Library.FontColor;
        TextXAlignment = Enum.TextXAlignment.Left;
        ZIndex = Tooltip.ZIndex + 1;

        Parent = Tooltip;
    })

    Library:AddToRegistry(Tooltip, {
        BackgroundColor3 = "MainColor";
        BorderColor3 = "OutlineColor";
    })

    Library:AddToRegistry(Label, {
        TextColor3 = "FontColor",
    })

    local TooltipTable = {
        Tooltip = Tooltip;
        Disabled = false;

        Signals = {};
    }
    local IsHovering = false

    local function UpdateText(Text)
        if Text == nil then return end

        local X, Y = Library:GetTextBounds(Text, Library.Font, 14 * DPIScale)

        Label.Text = Text
        Tooltip.Size = UDim2.fromOffset(X + 5, Y + 4)
        Label.Size = UDim2.fromOffset(X, Y)
    end

    local function GiveSignal(Connection: RBXScriptConnection | RBXScriptSignal)
        local ConnectionType = typeof(Connection)
        if Connection and (ConnectionType == "RBXScriptConnection" or ConnectionType == "RBXScriptSignal") then
            table.insert(TooltipTable.Signals, Connection)
        end

        return Connection
    end

    UpdateText(InfoStr)

    GiveSignal(HoverInstance.MouseEnter:Connect(function()
        if Library:MouseIsOverOpenedFrame() then
            Tooltip.Visible = false
            return
        end

        if not TooltipTable.Disabled then
            if InfoStr == nil or InfoStr == "" then
                Tooltip.Visible = false
                return
            end

            if Label.Text ~= InfoStr then
                UpdateText(InfoStr)
            end
        else
            if DisabledInfoStr == nil or DisabledInfoStr == "" then
                Tooltip.Visible = false
                return
            end

            if Label.Text ~= DisabledInfoStr then 
                UpdateText(DisabledInfoStr)
            end
        end

        IsHovering = true

        Tooltip.Position = UDim2.fromOffset(Mouse.X + 15, Mouse.Y + 12)
        Tooltip.Visible = true

        while IsHovering do
            if TooltipTable.Disabled == true and DisabledInfoStr == nil then break end

            RunService.Heartbeat:Wait()
            Tooltip.Position = UDim2.fromOffset(Mouse.X + 15, Mouse.Y + 12)
        end

        IsHovering = false
        Tooltip.Visible = false
    end))

    GiveSignal(HoverInstance.MouseLeave:Connect(function()
        IsHovering = false
        Tooltip.Visible = false
    end))
    
    if LibraryMainOuterFrame then
        GiveSignal(LibraryMainOuterFrame:GetPropertyChangedSignal("Visible"):Connect(function()
            if LibraryMainOuterFrame.Visible == false then
                IsHovering = false
                Tooltip.Visible = false
            end
        end))
    end

    function TooltipTable:Destroy()
        for Idx = #TooltipTable.Signals, 1, -1 do
            local Connection = table.remove(TooltipTable.Signals, Idx)
            if Connection and Connection.Connected then
                Connection:Disconnect()
            end
        end

        Tooltip:Destroy()
    end

    table.insert(Tooltips, TooltipTable)
    return TooltipTable
end

function Library:MouseIsOverFrame(Frame, Input)
    local Pos = Mouse
    if Library.IsMobile and Input then 
        Pos = Input.Position
    end

    local AbsPos, AbsSize = Frame.AbsolutePosition, Frame.AbsoluteSize
    if Pos.X >= AbsPos.X and Pos.X <= AbsPos.X + AbsSize.X
        and Pos.Y >= AbsPos.Y and Pos.Y <= AbsPos.Y + AbsSize.Y then

        return true
    end

    return false
end

function Library:IsFrameInsideDialog(Frame)
    if not Library.ActiveDialog then return false end

    local Pos = Frame.AbsolutePosition
    local AbsPos, AbsSize = Library.ActiveDialog.Container.AbsolutePosition, Library.ActiveDialog.Container.AbsoluteSize
   
    if Pos.X >= AbsPos.X and Pos.X <= AbsPos.X + AbsSize.X
        and Pos.Y >= AbsPos.Y and Pos.Y <= AbsPos.Y + AbsSize.Y then

        return true
    end

    return false
end

function Library:MouseIsOverOpenedFrame(Input)
    -- Inside active dialog
    if Library.ActiveDialog then
        if Library:MouseIsOverFrame(Library.ActiveDialog.Container, Input) then
            return false
        end

        return true
    end

    -- Inside opened frames
    for Frame, _ in next, Library.OpenedFrames do
        if Library:MouseIsOverFrame(Frame, Input) then
            return true
        end
    end

    return false
end

function Library:OnHighlight(HighlightInstance, Instance, Properties, PropertiesDefault, condition)
    local function undoHighlight()
        local Reg = Library.RegistryMap[Instance]

        for Property, ColorIdx in next, PropertiesDefault do
            Instance[Property] = Library[ColorIdx] or ColorIdx

            if Reg and Reg.Properties[Property] then
                Reg.Properties[Property] = ColorIdx
            end
        end
    end

    local function doHighlight()
        if condition and not condition() then 
            undoHighlight()
            return 
        end

        if Library.ActiveDialog and not Library:IsFrameInsideDialog(Instance) then
            undoHighlight()
            return
        end

        local Reg = Library.RegistryMap[Instance]

        for Property, ColorIdx in next, Properties do
            Instance[Property] = Library[ColorIdx] or ColorIdx

            if Reg and Reg.Properties[Property] then
                Reg.Properties[Property] = ColorIdx
            end
        end
    end

    HighlightInstance.MouseEnter:Connect(doHighlight)
    HighlightInstance.MouseMoved:Connect(doHighlight)
    HighlightInstance.MouseLeave:Connect(undoHighlight)
end

function Library:UpdateDependencyBoxes()
    for _, Depbox in next, Library.DependencyBoxes do
        Depbox:Update()
    end
end

function Library:UpdateDependencyGroupboxes()
    for _, Depbox in next, Library.DependencyGroupboxes do
        Depbox:Update()
    end
end

function Library:MapValue(Value, MinA, MaxA, MinB, MaxB)
    return (1 - ((Value - MinA) / (MaxA - MinA))) * MinB + ((Value - MinA) / (MaxA - MinA)) * MaxB
end

function Library:GetTextBounds(Text, Font, Size, Resolution)
    -- Ignores rich text formatting --
    if typeof(Resolution) == "number" then
        Resolution = Vector2.new(Resolution, 10000)
    end

    local Bounds = TextService:GetTextSize(Text:gsub("<%/?[%w:]+[^>]*>", ""), Size, Font, Resolution or Vector2.new(1920, 1080))
    return Bounds.X, Bounds.Y
end

function Library:GetDarkerColor(Color)
    local H, S, V = Color3.toHSV(Color)
    return Color3.fromHSV(H, S, V / 1.5)
end
Library.AccentColorDark = Library:GetDarkerColor(Library.AccentColor)

function Library:AddToRegistry(Instance, Properties, IsHud)
    local Idx = #Library.Registry + 1
    local Data = {
        Instance = Instance;
        Properties = Properties;
        Idx = Idx;
    }

    table.insert(Library.Registry, Data)
    Library.RegistryMap[Instance] = Data

    if IsHud then
        table.insert(Library.HudRegistry, Data)
    end
end

function Library:RemoveFromRegistry(Instance)
    local Data = Library.RegistryMap[Instance]

    if Data then
        for Idx = #Library.Registry, 1, -1 do
            if Library.Registry[Idx] == Data then
                table.remove(Library.Registry, Idx)
            end
        end

        for Idx = #Library.HudRegistry, 1, -1 do
            if Library.HudRegistry[Idx] == Data then
                table.remove(Library.HudRegistry, Idx)
            end
        end

        Library.RegistryMap[Instance] = nil
    end
end

function Library:UpdateColorsUsingRegistry()
    -- TODO: Could have an "active" list of objects
    -- where the active list only contains Visible objects.

    -- IMPL: Could setup .Changed events on the AddToRegistry function
    -- that listens for the "Visible" propert being changed.
    -- Visible: true => Add to active list, and call UpdateColors function
    -- Visible: false => Remove from active list.

    -- The above would be especially efficient for a rainbow menu color or live color-changing.

    for Idx, Object in next, Library.Registry do
        for Property, ColorIdx in next, Object.Properties do
            if typeof(ColorIdx) == "string" then
                Object.Instance[Property] = Library[ColorIdx]
            elseif typeof(ColorIdx) == "function" then
                Object.Instance[Property] = ColorIdx()
            end
        end
    end
end

function Library:GiveSignal(Connection: RBXScriptConnection | RBXScriptSignal) -- Only used for signals not attached to library instances, as those should be cleaned up on object destruction by Roblox
    local ConnectionType = typeof(Connection)
    if Connection and (ConnectionType == "RBXScriptConnection" or ConnectionType == "RBXScriptSignal") then
        table.insert(Library.Signals, Connection)
    end

    return Connection
end

function Library:Unload()
    for Idx = #Library.Signals, 1, -1 do
        local Connection = table.remove(Library.Signals, Idx)
        if Connection and Connection.Connected then
            Connection:Disconnect()
        end
    end

    for _, UnloadCallback in Library.UnloadSignals do
        Library:SafeCallback(UnloadCallback)
    end

    for _, Tooltip in Tooltips do
        Library:SafeCallback(Tooltip.Destroy, Tooltip)
    end

    Library.Unloaded = true
    ScreenGui:Destroy()

    getgenv().Linoria = nil
end

function Library:OnUnload(Callback)
    table.insert(Library.UnloadSignals, Callback)
end

Library:GiveSignal(ScreenGui.DescendantRemoving:Connect(function(Instance)
    if Library.Unloaded then
        return
    end

    if Library.RegistryMap[Instance] then
        Library:RemoveFromRegistry(Instance)
    end
end))

--// Templates \\--
local Templates = { -- TO-DO: do it for missing elements.
    --// Window \\--
    Window = {
        Title = "No Title",
        AutoShow = false,
        Position = UDim2.fromOffset(175, 50),
        Size = UDim2.fromOffset(0, 0),
        AnchorPoint = Vector2.zero,
        TabPadding = 1,
        MenuFadeTime = 0.2,
        NotifySide = "Left",
        ShowCustomCursor = true,
        UnlockMouseWhileOpen = true,
        Center = false
    },

    --// Elements \\--
    Video = {
        Video = "",
        Looped = false,
        Playing = false,
        Volume = 1,
        Height = 200,
        Visible = true,
    },
    UIPassthrough = {
        Instance = nil,
        Height = 24,
        Visible = true,
    }
}

--// Addons \\--
local BaseAddons = {}
do
    local BaseAddonsFuncs = {}

        function BaseAddonsFuncs:AddKeyPicker(Idx, Info)
        local ParentObj = self
        local ToggleLabel = self.TextLabel
        --local Container = self.Container;

        assert(Info.Default, string.format("AddKeyPicker (IDX: %s): Missing default value.", tostring(Idx)))

        local KeyPicker = {
            Value = nil; -- Key
            Modifiers = {}; -- Modifiers
            DisplayValue = nil; -- Picker Text

            Toggled = false;
            Mode = Info.Mode or "Toggle"; -- Always, Toggle, Hold, Press
            Type = "KeyPicker";
            Callback = Info.Callback or function(Value) end;
            ChangedCallback = Info.ChangedCallback or function(New) end;
            SyncToggleState = Info.SyncToggleState or false;
        }

        if KeyPicker.Mode == "Press" then
            assert(ParentObj.Type == "Label", "KeyPicker with the mode \"Press\" can be only applied on Labels.")
            
            KeyPicker.SyncToggleState = false
            Info.Modes = { "Press" }
            Info.Mode = "Press"
        end

        if KeyPicker.SyncToggleState then
            Info.Modes = { "Toggle", "Hold" }

            if not table.find(Info.Modes, Info.Mode) then
                Info.Mode = "Toggle"
            end
        end

        local Picking = false

        -- Special Keys
        local SpecialKeys = {
            ["MB1"] = Enum.UserInputType.MouseButton1,
            ["MB2"] = Enum.UserInputType.MouseButton2,
            ["MB3"] = Enum.UserInputType.MouseButton3
        }

        local SpecialKeysInput = {
            [Enum.UserInputType.MouseButton1] = "MB1",
            [Enum.UserInputType.MouseButton2] = "MB2",
            [Enum.UserInputType.MouseButton3] = "MB3"
        }

        -- Modifiers
        local Modifiers = {
            ["LAlt"] = Enum.KeyCode.LeftAlt,
            ["RAlt"] = Enum.KeyCode.RightAlt,

            ["LCtrl"] = Enum.KeyCode.LeftControl,
            ["RCtrl"] = Enum.KeyCode.RightControl,

            ["LShift"] = Enum.KeyCode.LeftShift,
            ["RShift"] = Enum.KeyCode.RightShift,

            ["Tab"] = Enum.KeyCode.Tab,
            ["CapsLock"] = Enum.KeyCode.CapsLock
        }

        local ModifiersInput = {
            [Enum.KeyCode.LeftAlt] = "LAlt",
            [Enum.KeyCode.RightAlt] = "RAlt",

            [Enum.KeyCode.LeftControl] = "LCtrl",
            [Enum.KeyCode.RightControl] = "RCtrl",

            [Enum.KeyCode.LeftShift] = "LShift",
            [Enum.KeyCode.RightShift] = "RShift",

            [Enum.KeyCode.Tab] = "Tab",
            [Enum.KeyCode.CapsLock] = "CapsLock"
        }

        local IsModifierInput = function(Input)
            return Input.UserInputType == Enum.UserInputType.Keyboard and ModifiersInput[Input.KeyCode] ~= nil
        end

        local GetActiveModifiers = function()
            local ActiveModifiers = {}

            for Name, Input in Modifiers do
                if table.find(ActiveModifiers, Name) then continue end
                if not InputService:IsKeyDown(Input) then continue end

                table.insert(ActiveModifiers, Name)
            end

            return ActiveModifiers
        end

        local AreModifiersHeld = function(Required)
            if not (typeof(Required) == "table" and GetTableSize(Required) > 0) then 
                return true
            end

            local ActiveModifiers = GetActiveModifiers()
            local Holding = true

            for _, Name in Required do
                if table.find(ActiveModifiers, Name) then continue end

                Holding = false
                break
            end

            return Holding
        end

        local IsInputDown = function(Input)
            if not Input then 
                return false
            end

            if SpecialKeysInput[Input.UserInputType] ~= nil then
                return InputService:IsMouseButtonPressed(Input.UserInputType) and not InputService:GetFocusedTextBox()
            elseif Input.UserInputType == Enum.UserInputType.Keyboard then
                return InputService:IsKeyDown(Input.KeyCode) and not InputService:GetFocusedTextBox()
            else
                return false
            end
        end

        local ConvertToInputModifiers = function(CurrentModifiers)
            local InputModifiers = {}

            for _, name in CurrentModifiers do
                table.insert(InputModifiers, Modifiers[name])
            end

            return InputModifiers
        end

        local VerifyModifiers = function(CurrentModifiers)
            if typeof(CurrentModifiers) ~= "table" then
                return {}
            end

            local ValidModifiers = {}

            for _, name in CurrentModifiers do
                if not Modifiers[name] then continue end

                table.insert(ValidModifiers, name)
            end

            return ValidModifiers
        end

        local PickOuter = Library:Create("Frame", {
            BackgroundColor3 = Color3.new(0, 0, 0);
            BorderColor3 = Color3.new(0, 0, 0);
            Size = UDim2.new(0, 28, 0, 15);
            ZIndex = 6;
            Parent = ToggleLabel;
        })

        local PickInner = Library:Create("Frame", {
            BackgroundColor3 = Library.BackgroundColor;
            BorderColor3 = Library.OutlineColor;
            BorderMode = Enum.BorderMode.Inset;
            Size = UDim2.new(1, 0, 1, 0);
            ZIndex = 7;
            Parent = PickOuter;
        })

        Library:AddToRegistry(PickInner, {
            BackgroundColor3 = "BackgroundColor";
            BorderColor3 = "OutlineColor";
        })

        local DisplayLabel = Library:CreateLabel({
            Size = UDim2.new(1, 0, 1, 0);
            TextSize = 13;
            Text = Info.Default;
            TextWrapped = true;
            ZIndex = 8;
            Parent = PickInner;
        })

        -- Keybinds Text
        local KeybindsToggle = {}
        do
            local KeybindsToggleContainer = Library:Create("Frame", {
                BackgroundTransparency = 1;
                Size = UDim2.new(1, 0, 0, 18);
                Visible = false;
                ZIndex = 110;
                Parent = Library.KeybindContainer;
            })

            local KeybindsToggleOuter = Library:Create("Frame", {
                BackgroundColor3 = Color3.new(0, 0, 0);
                BorderColor3 = Color3.new(0, 0, 0);
                Size = UDim2.new(0, 13, 0, 13);
                Position = UDim2.new(0, 0, 0, 6);
                Visible = true;
                ZIndex = 110;
                Parent = KeybindsToggleContainer;
            })

            Library:AddToRegistry(KeybindsToggleOuter, {
                BorderColor3 = "Black";
            })

            local KeybindsToggleInner = Library:Create("Frame", {
                BackgroundColor3 = Library.MainColor;
                BorderColor3 = Library.OutlineColor;
                BorderMode = Enum.BorderMode.Inset;
                Size = UDim2.new(1, 0, 1, 0);
                ZIndex = 111;
                Parent = KeybindsToggleOuter;
            })

            Library:AddToRegistry(KeybindsToggleInner, {
                BackgroundColor3 = "MainColor";
                BorderColor3 = "OutlineColor";
            })

            local KeybindsToggleLabel = Library:CreateLabel({
                BackgroundTransparency = 1;
                Size = UDim2.new(0, 216, 1, 0);
                Position = UDim2.new(1, 6, 0, -1);
                TextSize = 14;
                Text = "";
                TextXAlignment = Enum.TextXAlignment.Left;
                ZIndex = 111;
                Parent = KeybindsToggleInner;
            })

            Library:Create("UIListLayout", {
                Padding = UDim.new(0, 4);
                FillDirection = Enum.FillDirection.Horizontal;
                HorizontalAlignment = Enum.HorizontalAlignment.Right;
                VerticalAlignment = Enum.VerticalAlignment.Center;
                SortOrder = Enum.SortOrder.LayoutOrder;
                Parent = KeybindsToggleLabel;
            })

            local KeybindsToggleRegion = Library:Create("Frame", {
                BackgroundTransparency = 1;
                Size = UDim2.new(0, 170, 1, 0);
                ZIndex = 113;
                Parent = KeybindsToggleOuter;
            })

            Library:OnHighlight(KeybindsToggleRegion, KeybindsToggleOuter,
                { BorderColor3 = "AccentColor" },
                { BorderColor3 = "Black" },
                function()
                    return true
                end
            )

            function KeybindsToggle:Display(State)
                KeybindsToggleInner.BackgroundColor3 = State and Library.AccentColor or Library.MainColor
                KeybindsToggleInner.BorderColor3 = State and Library.AccentColorDark or Library.OutlineColor
                KeybindsToggleLabel.TextColor3 = State and Library.AccentColor or Library.FontColor

                Library.RegistryMap[KeybindsToggleInner].Properties.BackgroundColor3 = State and "AccentColor" or "MainColor"
                Library.RegistryMap[KeybindsToggleInner].Properties.BorderColor3 = State and "AccentColorDark" or "OutlineColor"
                Library.RegistryMap[KeybindsToggleLabel].Properties.TextColor3 = State and "AccentColor" or "FontColor"
            end

            function KeybindsToggle:SetText(Text)
                KeybindsToggleLabel.Text = Text
            end

            function KeybindsToggle:SetVisibility(bool)
                KeybindsToggleContainer.Visible = bool
            end

            function KeybindsToggle:SetNormal(bool)
                KeybindsToggle.Normal = bool

                KeybindsToggleOuter.BackgroundTransparency = if KeybindsToggle.Normal then 1 else 0

                KeybindsToggleInner.BackgroundTransparency = if KeybindsToggle.Normal then 1 else 0
                KeybindsToggleInner.BorderSizePixel = if KeybindsToggle.Normal then 0 else 1

                KeybindsToggleLabel.Position = if KeybindsToggle.Normal then UDim2.new(1, -13, 0, -1) else UDim2.new(1, 6, 0, -1)
            end

            KeyPicker.DoClick = function(...) end --// make luau lsp shut up
            Library:GiveSignal(KeybindsToggleRegion.InputBegan:Connect(function(Input)
                if Library.Unloaded then
                    return
                end

                if KeybindsToggle.Normal then return end
                                        
                if (Input.UserInputType == Enum.UserInputType.MouseButton1 and not Library:MouseIsOverOpenedFrame()) or Input.UserInputType == Enum.UserInputType.Touch then
                    KeyPicker.Toggled = not KeyPicker.Toggled
                    KeyPicker:DoClick()
                end
            end))

            KeybindsToggle.Loaded = true
        end

        local ModeSelectOuter = Library:Create("Frame", {
            BorderColor3 = Color3.new(0, 0, 0);
            BackgroundTransparency = 1;
            Size = UDim2.new(0, 80, 0, 0);
            Visible = false;
            ZIndex = 14;
            Parent = ScreenGui;
        })

        local function UpdateMenuOuterPos()
            ModeSelectOuter.Position = UDim2.fromOffset(ToggleLabel.AbsolutePosition.X + ToggleLabel.AbsoluteSize.X + 4, ToggleLabel.AbsolutePosition.Y)
        end

        UpdateMenuOuterPos()
        ToggleLabel:GetPropertyChangedSignal("AbsolutePosition"):Connect(UpdateMenuOuterPos)

        local ModeSelectInner = Library:Create("Frame", {
            BackgroundColor3 = Library.BackgroundColor;
            BorderColor3 = Library.OutlineColor;
            BorderMode = Enum.BorderMode.Inset;
            Size = UDim2.new(1, 0, 0, 3);
            ZIndex = 15;
            Parent = ModeSelectOuter;
        })

        Library:AddToRegistry(ModeSelectInner, {
            BackgroundColor3 = "BackgroundColor";
            BorderColor3 = "OutlineColor";
        })

        Library:Create("UIListLayout", {
            FillDirection = Enum.FillDirection.Vertical;
            SortOrder = Enum.SortOrder.LayoutOrder;
            Parent = ModeSelectInner;
        })

        local Modes = Info.Modes or { "Always", "Toggle", "Hold" }
        local ModeButtons = {}
        local UnbindButton = {}

        for Idx, Mode in next, Modes do
            local ModeButton = {}

            local Label = Library:CreateLabel({
                Active = false;
                Size = UDim2.new(1, 0, 0, 15);
                TextSize = 13;
                Text = Mode;
                ZIndex = 16;
                Parent = ModeSelectInner;
            })
            ModeSelectInner.Size = ModeSelectInner.Size + UDim2.new(0, 0, 0, 15)
            ModeSelectOuter.Size = ModeSelectOuter.Size + UDim2.new(0, 0, 0, 18)

            function ModeButton:Select()
                for _, Button in next, ModeButtons do
                    Button:Deselect()
                end

                KeyPicker.Mode = Mode

                Label.TextColor3 = Library.AccentColor
                Library.RegistryMap[Label].Properties.TextColor3 = "AccentColor"

                ModeSelectOuter.Visible = false
            end

            function ModeButton:Deselect()
                KeyPicker.Mode = nil

                Label.TextColor3 = Library.FontColor
                Library.RegistryMap[Label].Properties.TextColor3 = "FontColor"
            end

            Label.InputBegan:Connect(function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                    ModeButton:Select()
                end
            end)

            if Mode == KeyPicker.Mode then
                ModeButton:Select()
            end

            ModeButtons[Mode] = ModeButton
        end

        -- Create Unbind button --
        do
            local UnbindInner = Library:Create("Frame", {
                BackgroundColor3 = Library.BackgroundColor;
                BorderColor3 = Library.OutlineColor;
                BorderMode = Enum.BorderMode.Inset;
                Position = UDim2.new(0, 0, 0, ModeSelectInner.Size.Y.Offset + 3);
                Size = UDim2.new(1, 0, 0, 18);
                ZIndex = 15;
                Parent = ModeSelectOuter;
            })

            ModeSelectOuter.Size = ModeSelectOuter.Size + UDim2.new(0, 0, 0, 18)

            Library:AddToRegistry(UnbindInner, {
                BackgroundColor3 = "BackgroundColor";
                BorderColor3 = "OutlineColor";
            })

            local UnbindLabel = Library:CreateLabel({
                Active = false;
                Size = UDim2.new(1, 0, 0, 15);
                TextSize = 13;
                Text = "Unbind Key";
                ZIndex = 16;
                Parent = UnbindInner;
            })

            KeyPicker.SetValue = function(...) end --// make luau lsp shut up
            function UnbindButton:UnbindKey()
                KeyPicker:SetValue({ nil, KeyPicker.Mode, {} })
                ModeSelectOuter.Visible = false
            end

            UnbindLabel.InputBegan:Connect(function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                    UnbindButton:UnbindKey()
                end
            end)
        end

        function KeyPicker:Display(Text)
            DisplayLabel.Text = Text or KeyPicker.DisplayValue

            PickOuter.Size = UDim2.new(0, 999999, 0, 18)
            RunService.RenderStepped:Wait()
            PickOuter.Size = UDim2.new(0, math.max(28, DisplayLabel.TextBounds.X + 8), 0, 18)
        end

        function KeyPicker:Update()
            if Info.NoUI then
                return
            end

            local State = KeyPicker:GetState()
            local ShowToggle = Library.ShowToggleFrameInKeybinds and KeyPicker.Mode == "Toggle"

            if KeyPicker.SyncToggleState and ParentObj.Value ~= State then
                ParentObj:SetValue(State)
            end

            if KeybindsToggle.Loaded then
                KeybindsToggle:SetNormal(not ShowToggle)

                KeybindsToggle:SetVisibility(true)
                KeybindsToggle:SetText(string.format("[%s] %s (%s)", tostring(KeyPicker.DisplayValue), Info.Text, KeyPicker.Mode))
                KeybindsToggle:Display(State)
            end

            local YSize = 0
            local XSize = 0

            for _, Frame in next, Library.KeybindContainer:GetChildren() do
                if Frame:IsA("Frame") and Frame.Visible then
                    YSize = YSize + 18
                    local Label = Frame:FindFirstChild("TextLabel", true)
                    if not Label then continue end
                    
                    local LabelSize = Label.TextBounds.X + 20
                    if (LabelSize > XSize) then
                        XSize = LabelSize
                    end
                end
            end

            Library.KeybindFrame.Size = UDim2.new(0, math.max(XSize + 10, 220), 0, (YSize + 23 + 6) * DPIScale)
            UpdateMenuOuterPos()
        end

        function KeyPicker:GetState()
            if KeyPicker.Mode == "Always" then
                return true
            
            elseif KeyPicker.Mode == "Hold" then
                local Key = KeyPicker.Value
                if Key == "None" then
                    return false
                end

                if not AreModifiersHeld(KeyPicker.Modifiers) then
                    return false
                end

                if SpecialKeys[Key] ~= nil then
                    return InputService:IsMouseButtonPressed(SpecialKeys[Key]) and not InputService:GetFocusedTextBox()
                else
                    return InputService:IsKeyDown(Enum.KeyCode[Key]) and not InputService:GetFocusedTextBox()
                end

            else
                return KeyPicker.Toggled
            end
        end

        function KeyPicker:SetValue(Data, SkipCallback)
            local Key, Mode, Modifiers = Data[1], Data[2], Data[3]

            local IsKeyValid, UserInputType = pcall(function()
                if Key == "None" then
                    Key = nil
                    return nil
                end
                
                if SpecialKeys[Key] == nil then 
                    return Enum.KeyCode[Key]
                end

                return SpecialKeys[Key]
            end)

            if Key == nil then
                KeyPicker.Value = "None"
            elseif IsKeyValid then
                KeyPicker.Value = Key
            else
                KeyPicker.Value = "Unknown"
            end

            KeyPicker.Modifiers = VerifyModifiers(if typeof(Modifiers) == "table" then Modifiers else KeyPicker.Modifiers)
            KeyPicker.DisplayValue = if GetTableSize(KeyPicker.Modifiers) > 0 then (table.concat(KeyPicker.Modifiers, " + ") .. " + " .. KeyPicker.Value) else KeyPicker.Value

            DisplayLabel.Text = KeyPicker.DisplayValue

            if Mode ~= nil and ModeButtons[Mode] ~= nil then 
                ModeButtons[Mode]:Select()
            end

            KeyPicker:Display()
            KeyPicker:Update()

            if SkipCallback == true then return end
            local NewModifiers = ConvertToInputModifiers(KeyPicker.Modifiers)
            Library:SafeCallback(KeyPicker.ChangedCallback, UserInputType, NewModifiers)
            Library:SafeCallback(KeyPicker.Changed, UserInputType, NewModifiers)
        end

        function KeyPicker:OnClick(Callback)
            KeyPicker.Clicked = Callback
        end

        function KeyPicker:OnChanged(Callback)
            KeyPicker.Changed = Callback
            -- Callback(KeyPicker.Value)
        end

        if ParentObj.Addons then
            table.insert(ParentObj.Addons, KeyPicker)
        end

        function KeyPicker:DoClick()
            if KeyPicker.Mode == "Press" then
                if KeyPicker.Toggled and Info.WaitForCallback == true then
                    return
                end

                KeyPicker.Toggled = true
            end

            Library:SafeCallback(KeyPicker.Callback, KeyPicker.Toggled)
            Library:SafeCallback(KeyPicker.Clicked, KeyPicker.Toggled)

            if KeyPicker.Mode == "Press" then
                KeyPicker.Toggled = false
            end
        end

        function KeyPicker:SetModePickerVisibility(bool)
            ModeSelectOuter.Visible = bool
        end

        function KeyPicker:GetModePickerVisibility()
            return ModeSelectOuter.Visible
        end

        PickOuter.InputBegan:Connect(function(PickerInput)
            if PickerInput.UserInputType == Enum.UserInputType.MouseButton1 and not Library:MouseIsOverOpenedFrame() then
                Picking = true

                KeyPicker:Display("...")

                -- Wait for an non modifier key --
                local Input
                local ActiveModifiers = {}

                local GetInput = function()
                    Input = InputService.InputBegan:Wait()
                    if InputService:GetFocusedTextBox() then
                        return true
                    end

                    return false
                end

                repeat
                    task.wait()

                    -- Wait for any input --
                    KeyPicker:Display("...")

                    if GetInput() then
                        Picking = false
                        KeyPicker:Update()
                        return
                    end

                    -- Escape --
                    if Input.KeyCode == Enum.KeyCode.Escape then
                        break
                    end

                    -- Handle modifier keys --
                    if IsModifierInput(Input) then
                        local StopLoop = false

                        repeat
                            task.wait()
                            if InputService:IsKeyDown(Input.KeyCode) then
                                task.wait(0.075)

                                if InputService:IsKeyDown(Input.KeyCode) then
                                    -- Add modifier to the key list --
                                    if not table.find(ActiveModifiers, ModifiersInput[Input.KeyCode]) then
                                        ActiveModifiers[#ActiveModifiers + 1] = ModifiersInput[Input.KeyCode]
                                        KeyPicker:Display(table.concat(ActiveModifiers, " + ") .. " + ...")
                                    end

                                    -- Wait for another input --
                                    if GetInput() then
                                        StopLoop = true
                                        break -- Invalid Input
                                    end

                                    -- Escape --
                                    if Input.KeyCode == Enum.KeyCode.Escape then
                                        break
                                    end

                                    -- Stop loop if its a normal key --
                                    if not IsModifierInput(Input) then
                                        break
                                    end
                                else
                                    if not table.find(ActiveModifiers, ModifiersInput[Input.KeyCode]) then
                                        break -- Modifier is meant to be used as a normal key --
                                    end
                                end
                            end
                        until false

                        if StopLoop then
                            Picking = false
                            KeyPicker:Update()
                            return
                        end
                    end

                    break -- Input found, end loop
                until false

                local Key = "Unknown"
                if SpecialKeysInput[Input.UserInputType] ~= nil then
                    Key = SpecialKeysInput[Input.UserInputType]
                elseif Input.UserInputType == Enum.UserInputType.Keyboard then
                    Key = Input.KeyCode == Enum.KeyCode.Escape and "None" or Input.KeyCode.Name
                end

                ActiveModifiers = if Input.KeyCode == Enum.KeyCode.Escape or Key == "Unknown" then {} else ActiveModifiers

                KeyPicker.Toggled = false
                KeyPicker:SetValue({ Key, KeyPicker.Mode, ActiveModifiers })

                -- RunService.RenderStepped:Wait()
                repeat task.wait() until not IsInputDown(Input) or InputService:GetFocusedTextBox()
                Picking = false

            elseif PickerInput.UserInputType == Enum.UserInputType.MouseButton2 and not Library:MouseIsOverOpenedFrame() then
                local visible = KeyPicker:GetModePickerVisibility()
                
                if visible == false then
                    for _, option in next, Options do
                        if option.Type == "KeyPicker" then
                            option:SetModePickerVisibility(false)
                        end
                    end
                end

                KeyPicker:SetModePickerVisibility(not visible)
            end
        end)

        Library:GiveSignal(InputService.InputBegan:Connect(function(Input)
            if Library.Unloaded then
                return
            end

            if KeyPicker.Value == "Unknown" then return end
        
            if (not Picking) and (not InputService:GetFocusedTextBox()) then
                local Key = KeyPicker.Value
                local HoldingModifiers = AreModifiersHeld(KeyPicker.Modifiers)
                local HoldingKey = false

                if HoldingModifiers then
                    if Input.UserInputType == Enum.UserInputType.Keyboard then
                        if Input.KeyCode.Name == Key then
                            HoldingKey = true
                        end
                    elseif SpecialKeysInput[Input.UserInputType] == Key then
                        HoldingKey = true
                    end
                end

                if KeyPicker.Mode == "Toggle" then
                    if HoldingKey then
                        KeyPicker.Toggled = not KeyPicker.Toggled
                        KeyPicker:DoClick()
                    end
                elseif KeyPicker.Mode == "Press" then
                    if HoldingKey then
                        KeyPicker:DoClick()
                    end
                end

                KeyPicker:Update()
            end

            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                local AbsPos, AbsSize = ModeSelectOuter.AbsolutePosition, ModeSelectOuter.AbsoluteSize

                if Mouse.X < AbsPos.X or Mouse.X > AbsPos.X + AbsSize.X
                    or Mouse.Y < (AbsPos.Y - 20 - 1) or Mouse.Y > AbsPos.Y + AbsSize.Y then

                    KeyPicker:SetModePickerVisibility(false)
                end
            end
        end))

        Library:GiveSignal(InputService.InputEnded:Connect(function(Input)
            if Library.Unloaded then
                return
            end

            if (not Picking) then
                KeyPicker:Update()
            end
        end))
        
        KeyPicker:SetValue({ Info.Default, Info.Mode or "Toggle", Info.DefaultModifiers }, true)
        KeyPicker.DisplayFrame = PickOuter

        KeyPicker.Default = KeyPicker.Value
        KeyPicker.DefaultModifiers = table.clone(KeyPicker.Modifiers or {})

        Options[Idx] = KeyPicker

        return self
    end

    function BaseAddonsFuncs:AddColorPicker(Idx, Info)
        local ParentObj = self
        local ToggleLabel = self.TextLabel
        --local Container = self.Container;

        assert(Info.Default, string.format("AddColorPicker (IDX: %s): Missing default value.", tostring(Idx)))

        local ColorPicker = {
            Value = Info.Default;

            Transparency = Info.Transparency or 0;
            Type = "ColorPicker";
            Title = typeof(Info.Title) == "string" and Info.Title or "Color picker",
            Callback = Info.Callback or function(Color) end;
            Changed = nil,
        }

        local PreviousValues = {
            Value = nil,
            Transparency = nil
        }

        local function RunCallback()
            local NewValue = ColorPicker.Value
            local NewTransparency = ColorPicker.Transparency

            if NewValue == PreviousValues.Value and NewTransparency == PreviousValues.Transparency then
                return
            end

            PreviousValues.Value = ColorPicker.Value
            PreviousValues.Transparency = ColorPicker.Transparency

            Library:SafeCallback(ColorPicker.Callback, ColorPicker.Value, ColorPicker.Transparency)
            Library:SafeCallback(ColorPicker.Changed, ColorPicker.Value, ColorPicker.Transparency)
        end

        function ColorPicker:SetHSVFromRGB(Color)
            local H, S, V = Color:ToHSV()

            ColorPicker.Hue = H
            ColorPicker.Sat = S
            ColorPicker.Vib = V
        end

        ColorPicker:SetHSVFromRGB(ColorPicker.Value)

        local DisplayFrame = Library:Create("Frame", {
            BackgroundColor3 = ColorPicker.Value;
            BorderColor3 = Library:GetDarkerColor(ColorPicker.Value);
            BorderMode = Enum.BorderMode.Inset;
            Size = UDim2.new(0, 28, 0, 15);
            ZIndex = 6;
            Parent = ToggleLabel;
        })

        -- Transparency image taken from https://github.com/matas3535/SplixPrivateDrawingLibrary/blob/main/Library.lua cus i'm lazy
        -- local CheckerFrame = 
        Library:Create("ImageLabel", {
            BorderSizePixel = 0;
            Size = UDim2.new(0, 27, 0, 13);
            ZIndex = 5;
            Image = CustomImageManager.GetAsset("Checker");
            Visible = not not Info.Transparency;
            Parent = DisplayFrame;
        })

        -- 1/16/23
        -- Rewrote this to be placed inside the Library ScreenGui
        -- There was some issue which caused RelativeOffset to be way off
        -- Thus the color picker would never show

        local PickerFrameOuter = Library:Create("Frame", {
            Name = "Color";
            BackgroundColor3 = Color3.new(1, 1, 1);
            BorderColor3 = Color3.new(0, 0, 0);
            Position = UDim2.fromOffset(DisplayFrame.AbsolutePosition.X, DisplayFrame.AbsolutePosition.Y + 18),
            Size = UDim2.fromOffset(230, Info.Transparency and 271 or 253);
            Visible = false;
            ZIndex = 15;
            Parent = ScreenGui,
        })

        DisplayFrame:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
            PickerFrameOuter.Position = UDim2.fromOffset(DisplayFrame.AbsolutePosition.X, DisplayFrame.AbsolutePosition.Y + 18)
        end)

        local PickerFrameInner = Library:Create("Frame", {
            BackgroundColor3 = Library.BackgroundColor;
            BorderColor3 = Library.OutlineColor;
            BorderMode = Enum.BorderMode.Inset;
            Size = UDim2.new(1, 0, 1, 0);
            ZIndex = 16;
            Parent = PickerFrameOuter;
        })

        local Highlight = Library:Create("Frame", {
            BackgroundColor3 = Library.AccentColor;
            BorderSizePixel = 0;
            Size = UDim2.new(1, 0, 0, 2);
            ZIndex = 17;
            Parent = PickerFrameInner;
        })

        local SatVibMapOuter = Library:Create("Frame", {
            BorderColor3 = Color3.new(0, 0, 0);
            Position = UDim2.new(0, 4, 0, 25);
            Size = UDim2.new(0, 200, 0, 200);
            ZIndex = 17;
            Parent = PickerFrameInner;
        })

        local SatVibMapInner = Library:Create("Frame", {
            BackgroundColor3 = Library.BackgroundColor;
            BorderColor3 = Library.OutlineColor;
            BorderMode = Enum.BorderMode.Inset;
            Size = UDim2.new(1, 0, 1, 0);
            ZIndex = 18;
            Parent = SatVibMapOuter;
        })

        local SatVibMap = Library:Create("ImageLabel", {
            BorderSizePixel = 0;
            Size = UDim2.new(1, 0, 1, 0);
            ZIndex = 18;
            Image = CustomImageManager.GetAsset("SaturationMap");
            Parent = SatVibMapInner;
        })

        local CursorOuter = Library:Create("ImageLabel", {
            AnchorPoint = Vector2.new(0.5, 0.5);
            Size = UDim2.new(0, 6, 0, 6);
            BackgroundTransparency = 1;
            Image = CustomImageManager.GetAsset("Cursor");
            ImageColor3 = Color3.new(0, 0, 0);
            ZIndex = 19;
            Parent = SatVibMap;
        })

        -- local CursorInner = 
        Library:Create("ImageLabel", {
            Size = UDim2.new(0, CursorOuter.Size.X.Offset - 2, 0, CursorOuter.Size.Y.Offset - 2);
            Position = UDim2.new(0, 1, 0, 1);
            BackgroundTransparency = 1;
            Image = CustomImageManager.GetAsset("Cursor");
            ZIndex = 20;
            Parent = CursorOuter;
        })

        local HueSelectorOuter = Library:Create("Frame", {
            BorderColor3 = Color3.new(0, 0, 0);
            Position = UDim2.new(0, 208, 0, 25);
            Size = UDim2.new(0, 15, 0, 200);
            ZIndex = 17;
            Parent = PickerFrameInner;
        })

        local HueSelectorInner = Library:Create("Frame", {
            BackgroundColor3 = Color3.new(1, 1, 1);
            BorderSizePixel = 0;
            Size = UDim2.new(1, 0, 1, 0);
            ZIndex = 18;
            Parent = HueSelectorOuter;
        })

        local HueCursor = Library:Create("Frame", { 
            BackgroundColor3 = Color3.new(1, 1, 1);
            AnchorPoint = Vector2.new(0, 0.5);
            BorderColor3 = Color3.new(0, 0, 0);
            Size = UDim2.new(1, 0, 0, 1);
            ZIndex = 18;
            Parent = HueSelectorInner;
        })

        local HueBoxOuter = Library:Create("Frame", {
            BorderColor3 = Color3.new(0, 0, 0);
            Position = UDim2.fromOffset(4, 228),
            Size = UDim2.new(0.5, -6, 0, 20),
            ZIndex = 18,
            Parent = PickerFrameInner;
        })

        local HueBoxInner = Library:Create("Frame", {
            BackgroundColor3 = Library.MainColor;
            BorderColor3 = Library.OutlineColor;
            BorderMode = Enum.BorderMode.Inset;
            Size = UDim2.new(1, 0, 1, 0);
            ZIndex = 18,
            Parent = HueBoxOuter;
        })

        Library:Create("UIGradient", {
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(212, 212, 212))
            });
            Rotation = 90;
            Parent = HueBoxInner;
        })

        local HueBox = Library:Create("TextBox", {
            BackgroundTransparency = 1;
            Position = UDim2.new(0, 5, 0, 0);
            Size = UDim2.new(1, -5, 1, 0);
            Font = Library.Font;
            PlaceholderColor3 = Color3.fromRGB(190, 190, 190);
            PlaceholderText = "Hex color",
            Text = "#FFFFFF",
            TextColor3 = Library.FontColor;
            TextSize = 14;
            TextStrokeTransparency = 0;
            TextXAlignment = Enum.TextXAlignment.Left;
            ZIndex = 20,
            Parent = HueBoxInner;
        })

        Library:ApplyTextStroke(HueBox)

        local RgbBoxBase = Library:Create(HueBoxOuter:Clone(), {
            Position = UDim2.new(0.5, 2, 0, 228),
            Size = UDim2.new(0.5, -6, 0, 20),
            Parent = PickerFrameInner
        })

        local RgbBox = Library:Create(RgbBoxBase.Frame:FindFirstChild("TextBox"), {
            Text = "255, 255, 255",
            PlaceholderText = "RGB color",
            TextColor3 = Library.FontColor
        })

        local TransparencyBoxOuter, TransparencyBoxInner, TransparencyCursor
        
        if Info.Transparency then 
            TransparencyBoxOuter = Library:Create("Frame", {
                BorderColor3 = Color3.new(0, 0, 0);
                Position = UDim2.fromOffset(4, 251);
                Size = UDim2.new(1, -8, 0, 15);
                ZIndex = 19;
                Parent = PickerFrameInner;
            })

            TransparencyBoxInner = Library:Create("Frame", {
                BackgroundColor3 = ColorPicker.Value;
                BorderColor3 = Library.OutlineColor;
                BorderMode = Enum.BorderMode.Inset;
                Size = UDim2.new(1, 0, 1, 0);
                ZIndex = 19;
                Parent = TransparencyBoxOuter;
            })

            Library:AddToRegistry(TransparencyBoxInner, { BorderColor3 = "OutlineColor" })

            Library:Create("ImageLabel", {
                BackgroundTransparency = 1;
                Size = UDim2.new(1, 0, 1, 0);
                Image = CustomImageManager.GetAsset("CheckerLong");
                ZIndex = 20;
                Parent = TransparencyBoxInner;
            })

            TransparencyCursor = Library:Create("Frame", { 
                BackgroundColor3 = Color3.new(1, 1, 1);
                AnchorPoint = Vector2.new(0.5, 0);
                BorderColor3 = Color3.new(0, 0, 0);
                Size = UDim2.new(0, 1, 1, 0);
                ZIndex = 21;
                Parent = TransparencyBoxInner;
            })
        end

        -- local DisplayLabel = 
        Library:CreateLabel({
            Size = UDim2.new(1, 0, 0, 14);
            Position = UDim2.fromOffset(5, 5);
            TextXAlignment = Enum.TextXAlignment.Left;
            TextSize = 14;
            Text = ColorPicker.Title,--Info.Default;
            TextWrapped = false;
            ZIndex = 16;
            Parent = PickerFrameInner;
        })

        local ContextMenu = {}
        do
            ContextMenu.Options = {}
            ContextMenu.Container = Library:Create("Frame", {
                BorderColor3 = Color3.new(),
                ZIndex = 14,

                Visible = false,
                Parent = ScreenGui
            })

            ContextMenu.Inner = Library:Create("Frame", {
                BackgroundColor3 = Library.BackgroundColor;
                BorderColor3 = Library.OutlineColor;
                BorderMode = Enum.BorderMode.Inset;
                Size = UDim2.fromScale(1, 1);
                ZIndex = 15;
                Parent = ContextMenu.Container;
            })

            Library:Create("UIListLayout", {
                Name = "Layout",
                FillDirection = Enum.FillDirection.Vertical;
                SortOrder = Enum.SortOrder.LayoutOrder;
                Parent = ContextMenu.Inner;
            })

            Library:Create("UIPadding", {
                Name = "Padding",
                PaddingLeft = UDim.new(0, 4),
                Parent = ContextMenu.Inner,
            })

            local function updateMenuPosition()
                ContextMenu.Container.Position = UDim2.fromOffset(
                    (DisplayFrame.AbsolutePosition.X + DisplayFrame.AbsoluteSize.X) + 4,
                    DisplayFrame.AbsolutePosition.Y + 1
                )
            end

            local function updateMenuSize()
                local menuWidth = 60
                for i, label in next, ContextMenu.Inner:GetChildren() do
                    if label:IsA("TextLabel") then
                        menuWidth = math.max(menuWidth, label.TextBounds.X)
                    end
                end

                ContextMenu.Container.Size = UDim2.fromOffset(
                    menuWidth + 8,
                    ContextMenu.Inner.Layout.AbsoluteContentSize.Y + 4
                )
            end

            DisplayFrame:GetPropertyChangedSignal("AbsolutePosition"):Connect(updateMenuPosition)
            ContextMenu.Inner.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateMenuSize)

            task.spawn(updateMenuPosition)
            task.spawn(updateMenuSize)

            Library:AddToRegistry(ContextMenu.Inner, {
                BackgroundColor3 = "BackgroundColor";
                BorderColor3 = "OutlineColor";
            })

            function ContextMenu:Show()
                if Library.IsMobile then
                    Library.CanDrag = false
                end

                self.Container.Visible = true
            end

            function ContextMenu:Hide()
                if Library.IsMobile then
                    Library.CanDrag = true
                end
                
                self.Container.Visible = false
            end

            function ContextMenu:AddOption(Str, Callback)
                if typeof(Callback) ~= "function" then
                    Callback = function() end
                end

                local Button = Library:CreateLabel({
                    Active = false;
                    Size = UDim2.new(1, 0, 0, 15);
                    TextSize = 13;
                    Text = Str;
                    ZIndex = 16;
                    Parent = self.Inner;
                    TextXAlignment = Enum.TextXAlignment.Left,
                })

                Library:OnHighlight(Button, Button, 
                    { TextColor3 = "AccentColor" },
                    { TextColor3 = "FontColor" }
                )

                Button.InputBegan:Connect(function(Input)
                    if Input.UserInputType ~= Enum.UserInputType.MouseButton1 or Input.UserInputType ~= Enum.UserInputType.Touch then
                        return
                    end

                    Callback()
                end)
            end

            ContextMenu:AddOption("Copy color", function()
                Library.ColorClipboard = ColorPicker.Value
                Library:Notify("Copied color!", 2)
            end)

            ColorPicker.SetValueRGB = function(...) end --// make luau lsp shut up
            ContextMenu:AddOption("Paste color", function()
                if not Library.ColorClipboard then
                    Library:Notify("You have not copied a color!", 2)
                    return
                end

                ColorPicker:SetValueRGB(Library.ColorClipboard)
            end)

            ContextMenu:AddOption("Copy HEX", function()
                pcall(setclipboard, ColorPicker.Value:ToHex())
                Library:Notify("Copied hex code to clipboard!", 2)
            end)

            ContextMenu:AddOption("Copy RGB", function()
                pcall(setclipboard, table.concat({ math.floor(ColorPicker.Value.R * 255), math.floor(ColorPicker.Value.G * 255), math.floor(ColorPicker.Value.B * 255) }, ", "))
                Library:Notify("Copied RGB values to clipboard!", 2)
            end)
        end
        ColorPicker.ContextMenu = ContextMenu

        Library:AddToRegistry(PickerFrameInner, { BackgroundColor3 = "BackgroundColor"; BorderColor3 = "OutlineColor"; })
        Library:AddToRegistry(Highlight, { BackgroundColor3 = "AccentColor"; })
        Library:AddToRegistry(SatVibMapInner, { BackgroundColor3 = "BackgroundColor"; BorderColor3 = "OutlineColor"; })

        Library:AddToRegistry(HueBoxInner, { BackgroundColor3 = "MainColor"; BorderColor3 = "OutlineColor"; })
        Library:AddToRegistry(RgbBoxBase.Frame, { BackgroundColor3 = "MainColor"; BorderColor3 = "OutlineColor"; })
        Library:AddToRegistry(RgbBox, { TextColor3 = "FontColor", })
        Library:AddToRegistry(HueBox, { TextColor3 = "FontColor", })

        local SequenceTable = {}

        for Hue = 0, 1, 0.1 do
            table.insert(SequenceTable, ColorSequenceKeypoint.new(Hue, Color3.fromHSV(Hue, 1, 1)))
        end

        -- local HueSelectorGradient =
        Library:Create("UIGradient", {
            Color = ColorSequence.new(SequenceTable);
            Rotation = 90;
            Parent = HueSelectorInner;
        })

        function ColorPicker:Display()
            ColorPicker.Value = Color3.fromHSV(ColorPicker.Hue, ColorPicker.Sat, ColorPicker.Vib)
            SatVibMap.BackgroundColor3 = Color3.fromHSV(ColorPicker.Hue, 1, 1)

            Library:Create(DisplayFrame, {
                BackgroundColor3 = ColorPicker.Value;
                BackgroundTransparency = ColorPicker.Transparency;
                BorderColor3 = Library:GetDarkerColor(ColorPicker.Value);
            })

            if TransparencyBoxInner then
                TransparencyBoxInner.BackgroundColor3 = ColorPicker.Value
                TransparencyCursor.Position = UDim2.new(1 - ColorPicker.Transparency, 0, 0, 0)
            end

            CursorOuter.Position = UDim2.new(ColorPicker.Sat, 0, 1 - ColorPicker.Vib, 0)
            HueCursor.Position = UDim2.new(0, 0, ColorPicker.Hue, 0)

            HueBox.Text = "#" .. ColorPicker.Value:ToHex()
            RgbBox.Text = table.concat({ math.floor(ColorPicker.Value.R * 255), math.floor(ColorPicker.Value.G * 255), math.floor(ColorPicker.Value.B * 255) }, ", ")
        end

        function ColorPicker:OnChanged(Func)
            ColorPicker.Changed = Func
        end

        if ParentObj.Addons then
            table.insert(ParentObj.Addons, ColorPicker)
        end

        function ColorPicker:Show()
            for Frame, Val in next, Library.OpenedFrames do
                if Frame.Name == "Color" then
                    Frame.Visible = false
                    Library.OpenedFrames[Frame] = nil
                end
            end

            PickerFrameOuter.Visible = true
            Library.OpenedFrames[PickerFrameOuter] = true
        end

        function ColorPicker:Hide()
            PickerFrameOuter.Visible = false
            Library.OpenedFrames[PickerFrameOuter] = nil
        end

        function ColorPicker:SetValue(HSV, Transparency)
            if typeof(HSV) == "Color3" then
                ColorPicker:SetValueRGB(HSV, Transparency)
                return
            end

            local Color = Color3.fromHSV(HSV[1], HSV[2], HSV[3])

            ColorPicker.Transparency = Transparency or 0
            ColorPicker:SetHSVFromRGB(Color)
            ColorPicker:Display()

            RunCallback()
        end

        function ColorPicker:SetValueRGB(Color, Transparency)
            ColorPicker.Transparency = Transparency or 0
            ColorPicker:SetHSVFromRGB(Color)
            ColorPicker:Display()

            RunCallback()
        end

        HueBox.FocusLost:Connect(function(enter)
            if enter then
                local success, result = pcall(Color3.fromHex, HueBox.Text)
                if success and typeof(result) == "Color3" then
                    ColorPicker.Hue, ColorPicker.Sat, ColorPicker.Vib = Color3.toHSV(result)
                end
            end

            ColorPicker:Display()
        end)

        RgbBox.FocusLost:Connect(function(enter)
            if enter then
                local r, g, b = RgbBox.Text:match("(%d+),%s*(%d+),%s*(%d+)")
                if r and g and b then
                    ColorPicker.Hue, ColorPicker.Sat, ColorPicker.Vib = Color3.toHSV(Color3.fromRGB(r, g, b))
                end
            end

            ColorPicker:Display()
        end)

        SatVibMap.InputBegan:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                while InputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1 or Enum.UserInputType.Touch) do
                    local MinX = SatVibMap.AbsolutePosition.X
                    local MaxX = MinX + SatVibMap.AbsoluteSize.X
                    local MouseX = math.clamp(Mouse.X, MinX, MaxX)

                    local MinY = SatVibMap.AbsolutePosition.Y
                    local MaxY = MinY + SatVibMap.AbsoluteSize.Y
                    local MouseY = math.clamp(Mouse.Y, MinY, MaxY)

                    ColorPicker.Sat = (MouseX - MinX) / (MaxX - MinX)
                    ColorPicker.Vib = 1 - ((MouseY - MinY) / (MaxY - MinY))
                    ColorPicker:Display()

                    RunCallback()

                    RunService.RenderStepped:Wait()
                end

                Library:AttemptSave()
            end
        end)

        HueSelectorInner.InputBegan:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                while InputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1 or Enum.UserInputType.Touch) do
                    local MinY = HueSelectorInner.AbsolutePosition.Y
                    local MaxY = MinY + HueSelectorInner.AbsoluteSize.Y
                    local MouseY = math.clamp(Mouse.Y, MinY, MaxY)

                    ColorPicker.Hue = ((MouseY - MinY) / (MaxY - MinY))
                    ColorPicker:Display()

                    RunCallback()

                    RunService.RenderStepped:Wait()
                end

                Library:AttemptSave()
            end
        end)

        DisplayFrame.InputBegan:Connect(function(Input)
            if Library:MouseIsOverOpenedFrame(Input) then
                return
            end

            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                if PickerFrameOuter.Visible then
                    ColorPicker:Hide()
                else
                    ContextMenu:Hide()
                    ColorPicker:Show()
                end
            elseif Input.UserInputType == Enum.UserInputType.MouseButton2 then
                ContextMenu:Show()
                ColorPicker:Hide()
            end
        end)

        if TransparencyBoxInner then
            TransparencyBoxInner.InputBegan:Connect(function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    while InputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1 or Enum.UserInputType.Touch) do
                        local MinX = TransparencyBoxInner.AbsolutePosition.X
                        local MaxX = MinX + TransparencyBoxInner.AbsoluteSize.X
                        local MouseX = math.clamp(Mouse.X, MinX, MaxX)

                        ColorPicker.Transparency = 1 - ((MouseX - MinX) / (MaxX - MinX))
                        ColorPicker:Display()

                        RunCallback()

                        RunService.RenderStepped:Wait()
                    end

                    Library:AttemptSave()
                end
            end)
        end

        Library:GiveSignal(InputService.InputBegan:Connect(function(Input)
            if Library.Unloaded then
                return
            end

            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                local AbsPos, AbsSize = PickerFrameOuter.AbsolutePosition, PickerFrameOuter.AbsoluteSize

                if Mouse.X < AbsPos.X or Mouse.X > AbsPos.X + AbsSize.X
                    or Mouse.Y < (AbsPos.Y - 20 - 1) or Mouse.Y > AbsPos.Y + AbsSize.Y then

                    ColorPicker:Hide()
                end

                if not Library:MouseIsOverFrame(ContextMenu.Container) then
                    ContextMenu:Hide()
                end
            end

            if Input.UserInputType == Enum.UserInputType.MouseButton2 and ContextMenu.Container.Visible then
                if not Library:MouseIsOverFrame(ContextMenu.Container) and not Library:MouseIsOverFrame(DisplayFrame) then
                    ContextMenu:Hide()
                end
            end
        end))

        ColorPicker:Display()
        ColorPicker.DisplayFrame = DisplayFrame

        ColorPicker.Default = ColorPicker.Value

        Options[Idx] = ColorPicker

        return self
    end

    function BaseAddonsFuncs:AddDropdown(Idx, Info)
        Info.ReturnInstanceInstead = if typeof(Info.ReturnInstanceInstead) == "boolean" then Info.ReturnInstanceInstead else false

        if Info.SpecialType == "Player" then
            Info.ExcludeLocalPlayer = if typeof(Info.ExcludeLocalPlayer) == "boolean" then Info.ExcludeLocalPlayer else false

            Info.Values = GetPlayers(Info.ExcludeLocalPlayer, Info.ReturnInstanceInstead)
            Info.AllowNull = true
        elseif Info.SpecialType == "Team" then
            Info.Values = GetTeams(Info.ReturnInstanceInstead)
            Info.AllowNull = true
        end

        assert(Info.Values, string.format("AddDropdown (IDX: %s): Missing dropdown value list.", tostring(Idx)))
        if not (Info.AllowNull or Info.Default) then
            Info.Default = 1
            warn(string.format("AddDropdown (IDX: %s): Missing default value, selected the first index instead. Pass `AllowNull` as true if this was intentional.", tostring(Idx)))
        end

        Info.Searchable = if typeof(Info.Searchable) == "boolean" then Info.Searchable else false
        Info.FormatDisplayValue = if typeof(Info.FormatDisplayValue) == "function" then Info.FormatDisplayValue else nil
        Info.FormatListValue = if typeof(Info.FormatListValue) == "function" then Info.FormatListValue else nil

        local Dropdown = {
            Values = Info.Values;
            Value = Info.Multi and {};
            DisabledValues = Info.DisabledValues or {};

            Multi = Info.Multi;
            Type = "Dropdown";
            SpecialType = Info.SpecialType; -- can be either "Player" or "Team"
            Visible = if typeof(Info.Visible) == "boolean" then Info.Visible else true;
            Disabled = if typeof(Info.Disabled) == "boolean" then Info.Disabled else false;
            Callback = Info.Callback or function(Value) end;
            Changed = Info.Changed or function(Value) end;

            OriginalText = Info.Text; Text = Info.Text;
            ExcludeLocalPlayer = Info.ExcludeLocalPlayer;
            ReturnInstanceInstead = Info.ReturnInstanceInstead;
        }

        local Tooltip

        local ParentObj = self
        local ToggleLabel = self.TextLabel
        local Container = self.Container

        local RelativeOffset = 0

        for _, Element in next, Container:GetChildren() do
            if not Element:IsA("UIListLayout") then
                RelativeOffset = RelativeOffset + Element.Size.Y.Offset
            end
        end

        local DropdownOuter = Library:Create("Frame", {
            BackgroundColor3 = Color3.new(0, 0, 0);
            BorderColor3 = Color3.new(0, 0, 0);
            Size = UDim2.new(0, 60, 0, 18);
            Visible = Dropdown.Visible;
            ZIndex = 6;
            Parent = ToggleLabel;
        })

        Library:AddToRegistry(DropdownOuter, {
            BorderColor3 = "Black";
        })

        local DropdownInner = Library:Create("Frame", {
            BackgroundColor3 = Library.MainColor;
            BorderColor3 = Library.OutlineColor;
            BorderMode = Enum.BorderMode.Inset;
            Size = UDim2.new(1, 0, 1, 0);
            ZIndex = 6;
            Parent = DropdownOuter;
        })

        Library:AddToRegistry(DropdownInner, {
            BackgroundColor3 = "MainColor";
            BorderColor3 = "OutlineColor";
        })

        Library:Create("UIGradient", {
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(212, 212, 212))
            });
            Rotation = 90;
            Parent = DropdownInner;
        })

        local DropdownInnerSearch
        if Info.Searchable then
            DropdownInnerSearch = Library:Create("TextBox", {
                BackgroundTransparency = 1;
                Visible = false;

                Position = UDim2.new(0, 5, 0, 0);
                Size = UDim2.new(0.9, -5, 1, 0);

                Font = Library.Font;
                PlaceholderColor3 = Color3.fromRGB(190, 190, 190);
                PlaceholderText = "Search...";

                Text = "";
                TextColor3 = Library.FontColor;
                TextSize = 14;
                TextStrokeTransparency = 0;
                TextXAlignment = Enum.TextXAlignment.Left;

                ClearTextOnFocus = false;

                ZIndex = 7;
                Parent = DropdownOuter;
            })

            Library:ApplyTextStroke(DropdownInnerSearch)

            Library:AddToRegistry(DropdownInnerSearch, {
                TextColor3 = "FontColor";
            })
        end

        local DropdownArrow = Library:Create("ImageLabel", {
            AnchorPoint = Vector2.new(0, 0.5);
            BackgroundTransparency = 1;
            Position = UDim2.new(1, -16, 0.5, 0);
            Size = UDim2.new(0, 12, 0, 12);
            Image = CustomImageManager.GetAsset("DropdownArrow");
            ZIndex = 8;
            Parent = DropdownInner;
        })

        local ItemList = Library:CreateLabel({
            Position = UDim2.new(0, 5, 0, 0);
            Size = UDim2.new(1, -5, 1, 0);
            TextSize = 14;
            Text = "--";
            TextXAlignment = Enum.TextXAlignment.Left;
            TextWrapped = false;
            TextTruncate = Enum.TextTruncate.AtEnd;
            RichText = true;
            ZIndex = 7;
            Parent = DropdownInner;
        })

        Library:OnHighlight(DropdownOuter, DropdownOuter,
            { BorderColor3 = "AccentColor" },
            { BorderColor3 = "Black" },
            function()
                return not Dropdown.Disabled
            end
        )

        if typeof(Info.Tooltip) == "string" or typeof(Info.DisabledTooltip) == "string" then
            Tooltip = Library:AddToolTip(Info.Tooltip, Info.DisabledTooltip, DropdownOuter)
            Tooltip.Disabled = Dropdown.Disabled
        end

        local MAX_DROPDOWN_ITEMS = if typeof(Info.MaxVisibleDropdownItems) == "number" then math.clamp(Info.MaxVisibleDropdownItems, 4, 16) else 8

        local ListOuter = Library:Create("Frame", {
            BackgroundColor3 = Color3.new(0, 0, 0);
            BorderColor3 = Color3.new(0, 0, 0);
            ZIndex = 20;
            Visible = false;
            Parent = ScreenGui;
        })

        local OpenedXSizeForList = 0

        local function RecalculateListPosition()
            ListOuter.Position = UDim2.fromOffset(DropdownOuter.AbsolutePosition.X, DropdownOuter.AbsolutePosition.Y + DropdownOuter.Size.Y.Offset + 1)
        end

        local function RecalculateListSize(YSize)
            local Y = YSize or math.clamp(GetTableSize(Dropdown.Values) * (20 * DPIScale), 0, MAX_DROPDOWN_ITEMS * (20 * DPIScale)) + 1
            ListOuter.Size = UDim2.fromOffset(ListOuter.Visible and OpenedXSizeForList or DropdownOuter.AbsoluteSize.X + 0.5, Y)
        end

        RecalculateListPosition()
        RecalculateListSize()

        DropdownOuter:GetPropertyChangedSignal("AbsolutePosition"):Connect(RecalculateListPosition)
        DropdownOuter:GetPropertyChangedSignal("AbsoluteSize"):Connect(RecalculateListSize)

        local ListInner = Library:Create("Frame", {
            BackgroundColor3 = Library.MainColor;
            BorderColor3 = Library.OutlineColor;
            BorderMode = Enum.BorderMode.Inset;
            BorderSizePixel = 0;
            Size = UDim2.new(1, 0, 1, 0);
            ZIndex = 21;
            Parent = ListOuter;
        })

        Library:AddToRegistry(ListInner, {
            BackgroundColor3 = "MainColor";
            BorderColor3 = "OutlineColor";
        })

        local Scrolling = Library:Create("ScrollingFrame", {
            BackgroundTransparency = 1;
            BorderSizePixel = 0;
            CanvasSize = UDim2.new(0, 0, 0, 0);
            Size = UDim2.new(1, 0, 1, 0);
            ZIndex = 21;
            Parent = ListInner;

            TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png",
            BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png",

            ScrollBarThickness = 3,
            ScrollBarImageColor3 = Library.AccentColor,
        })

        Library:AddToRegistry(Scrolling, {
            ScrollBarImageColor3 = "AccentColor"
        })

        Library:Create("UIListLayout", {
            Padding = UDim.new(0, 0);
            FillDirection = Enum.FillDirection.Vertical;
            SortOrder = Enum.SortOrder.LayoutOrder;
            Parent = Scrolling;
        })

        function Dropdown:UpdateColors()
            ItemList.TextColor3 = Dropdown.Disabled and Library.DisabledAccentColor or Color3.new(1, 1, 1)
            DropdownArrow.ImageColor3 = Dropdown.Disabled and Library.DisabledAccentColor or Color3.new(1, 1, 1)
        end

        function Dropdown:GenerateDisplayText(SelectedValue)
            local Str = ""

            if Info.Multi and typeof(SelectedValue) == "table" then
                for Idx, Value in next, Dropdown.Values do
                    if SelectedValue[Value] then
                        Str = Str .. tostring(Info.FormatDisplayValue and Info.FormatDisplayValue(Value) or Value) .. ", "
                    end
                end

                Str = Str:sub(1, #Str - 2)
                Str = (Str == "" and "--" or Str)
            else
                if not SelectedValue then
                    return "--"
                end

                Str = tostring(Info.FormatDisplayValue and Info.FormatDisplayValue(SelectedValue) or SelectedValue)
            end

            return Str
        end

        function Dropdown:Display()
            local Str = Dropdown:GenerateDisplayText(Dropdown.Value)
            ItemList.Text = Str

            local X = ListOuter.Visible and OpenedXSizeForList or Library:GetTextBounds(ItemList.Text, Library.Font, ItemList.TextSize, Vector2.new(ToggleLabel.AbsoluteSize.X, math.huge)) + 26
            DropdownOuter.Size = UDim2.new(0, X, 0, 18)
        end

        function Dropdown:GetActiveValues()
            if Info.Multi then
                local T = {}

                for Value, Bool in next, Dropdown.Value do
                    table.insert(T, Value)
                end

                return T
            else
                return Dropdown.Value and 1 or 0
            end
        end

        function Dropdown:BuildDropdownList()
            local Values = Dropdown.Values
            local DisabledValues = Dropdown.DisabledValues
            local Buttons = {}

            for _, Element in next, Scrolling:GetChildren() do
                if not Element:IsA("UIListLayout") then
                    Element:Destroy()
                end
            end

            local Count = 0
            OpenedXSizeForList = DropdownOuter.AbsoluteSize.X + 0.5

            for Idx, Value in next, Values do
                local StringValue = tostring(Info.FormatListValue and Info.FormatListValue(Value) or Value)
                if Info.Searchable and not string.lower(StringValue):match(string.lower(DropdownInnerSearch.Text)) then
                    continue
                end

                local IsDisabled = table.find(DisabledValues, StringValue)
                local Table = {}

                Count = Count + 1

                local Button = Library:Create("TextButton", {
                    AutoButtonColor = false,
                    BackgroundColor3 = Library.MainColor;
                    BorderColor3 = Library.OutlineColor;
                    BorderMode = Enum.BorderMode.Middle;
                    Size = UDim2.new(1, -1, 0, 20);
                    Text = "";
                    ZIndex = 23;
                    Parent = Scrolling;
                })

                Library:AddToRegistry(Button, {
                    BackgroundColor3 = "MainColor";
                    BorderColor3 = "OutlineColor";
                })

                local ButtonLabel = Library:CreateLabel({
                    Active = false;
                    Size = UDim2.new(1, -6, 1, 0);
                    Position = UDim2.new(0, 6, 0, 0);
                    TextSize = 14;
                    Text = Info.FormatDisplayValue and tostring(Info.FormatDisplayValue(StringValue)) or StringValue;
                    TextXAlignment = Enum.TextXAlignment.Left;
                    RichText = true;
                    ZIndex = 25;
                    Parent = Button;
                })

                Library:OnHighlight(Button, Button,
                    { BorderColor3 = IsDisabled and "DisabledAccentColor" or "AccentColor", ZIndex = 24 },
                    { BorderColor3 = "OutlineColor", ZIndex = 23 }
                )

                local Selected

                if Info.Multi then
                    Selected = Dropdown.Value[Value]
                else
                    Selected = Dropdown.Value == Value
                end

                function Table:UpdateButton()
                    if Info.Multi then
                        Selected = Dropdown.Value[Value]
                    else
                        Selected = Dropdown.Value == Value
                    end

                    ButtonLabel.TextColor3 = Selected and Library.AccentColor or (IsDisabled and Library.DisabledAccentColor or Library.FontColor)
                    Library.RegistryMap[ButtonLabel].Properties.TextColor3 = Selected and "AccentColor" or (IsDisabled and "DisabledAccentColor" or "FontColor")
                end

                if not IsDisabled then
                    Button.MouseButton1Click:Connect(function(Input)
                        local Try = not Selected

                        if Dropdown:GetActiveValues() == 1 and (not Try) and (not Info.AllowNull) then
                        else
                            if Info.Multi then
                                Selected = Try

                                if Selected then
                                    Dropdown.Value[Value] = true
                                else
                                    Dropdown.Value[Value] = nil
                                end
                            else
                                Selected = Try

                                if Selected then
                                    Dropdown.Value = Value
                                else
                                    Dropdown.Value = nil
                                end

                                for _, OtherButton in next, Buttons do
                                    OtherButton:UpdateButton()
                                end
                            end

                            Table:UpdateButton()
                            Dropdown:Display()
                            
                            Library:UpdateDependencyBoxes()
                            Library:UpdateDependencyGroupboxes()
                            Library:SafeCallback(Dropdown.Callback, Dropdown.Value)
                            Library:SafeCallback(Dropdown.Changed, Dropdown.Value)

                            Library:AttemptSave()
                        end
                    end)
                end

                Table:UpdateButton()
                Dropdown:Display()

                local Str = Dropdown:GenerateDisplayText(Value)
                local X = Library:GetTextBounds(Str, Library.Font, ItemList.TextSize, Vector2.new(ToggleLabel.AbsoluteSize.X, math.huge)) + 26
                if X > OpenedXSizeForList then
                    OpenedXSizeForList = X
                end

                Buttons[Button] = Table
            end
            
            Scrolling.CanvasSize = UDim2.fromOffset(0, (Count * (20 * DPIScale)) + 1)

            -- Workaround for silly roblox bug - not sure why it happens but sometimes the dropdown list will be empty
            -- ... and for some reason refreshing the Visible property fixes the issue??????? thanks roblox!
            Scrolling.Visible = false
            Scrolling.Visible = true

            local Y = math.clamp(Count * (20 * DPIScale), 0, MAX_DROPDOWN_ITEMS * (20 * DPIScale)) + 1
            RecalculateListSize(Y)
        end

        function Dropdown:SetValues(NewValues)
            if NewValues then
                Dropdown.Values = NewValues
            end

            Dropdown:BuildDropdownList()
        end

        function Dropdown:AddValues(NewValues)
            if typeof(NewValues) == "table" then
                for _, val in pairs(NewValues) do
                    table.insert(Dropdown.Values, val)
                end
            elseif typeof(NewValues) == "string" then
                table.insert(Dropdown.Values, NewValues)
            else
                return
            end

            Dropdown:BuildDropdownList()
        end

        function Dropdown:SetDisabledValues(NewValues)
            if NewValues then
                Dropdown.DisabledValues = NewValues
            end

            Dropdown:BuildDropdownList()
        end

        function Dropdown:AddDisabledValues(DisabledValues)
            if typeof(DisabledValues) == "table" then
                for _, val in pairs(DisabledValues) do
                    table.insert(Dropdown.DisabledValues, val)
                end
            elseif typeof(DisabledValues) == "string" then
                table.insert(Dropdown.DisabledValues, DisabledValues)
            else
                return
            end

            Dropdown:BuildDropdownList()
        end

        function Dropdown:SetVisible(Visibility)
            Dropdown.Visible = Visibility

            DropdownOuter.Visible = Dropdown.Visible
            if not Dropdown.Visible then 
                Dropdown:CloseDropdown()
            end
        end

        function Dropdown:SetDisabled(Disabled)
            Dropdown.Disabled = Disabled

            if Tooltip then
                Tooltip.Disabled = Disabled
            end

            if Disabled then
                Dropdown:CloseDropdown()
            end

            Dropdown:Display()
            Dropdown:UpdateColors()
        end

        function Dropdown:OpenDropdown()
            if Dropdown.Disabled then
                return
            end

            if Library.IsMobile then
                Library.CanDrag = false
            end

            if Info.Searchable then
                ItemList.Visible = false
                DropdownInnerSearch.Text = ""
                DropdownInnerSearch.Visible = true
            end
            
            ListOuter.Visible = true
            Library.OpenedFrames[ListOuter] = true
            DropdownArrow.Rotation = 180

            Dropdown:Display()
            RecalculateListSize()
        end

        function Dropdown:CloseDropdown()
            if Library.IsMobile then         
                Library.CanDrag = true
            end

            if Info.Searchable then
                DropdownInnerSearch.Text = ""
                DropdownInnerSearch.Visible = false
                ItemList.Visible = true
            end
        
            ListOuter.Visible = false
            Library.OpenedFrames[ListOuter] = nil
            DropdownArrow.Rotation = 0

            Dropdown:Display()
            RecalculateListSize()
        end

        function Dropdown:OnChanged(Func)
            Dropdown.Changed = Func

            -- if Dropdown.Disabled then
            --     return;
            -- end;

            -- Library:SafeCallback(Func, Dropdown.Value);
        end

        function Dropdown:SetValue(Value)
            if Dropdown.Multi then
                local Table = {}

                for Val, Active in pairs(Value or {}) do
                    if typeof(Active) ~= "boolean" then
                        Table[Active] = true
                    elseif Active and table.find(Dropdown.Values, Val) then
                        Table[Val] = true
                    end
                end

                Dropdown.Value = Table
            else
                if table.find(Dropdown.Values, Value) then
                    Dropdown.Value = Value
                elseif not Value then
                    Dropdown.Value = nil
                end
            end

            Dropdown:BuildDropdownList()

            if not Dropdown.Disabled then
                Library:SafeCallback(Dropdown.Callback, Dropdown.Value)
                Library:SafeCallback(Dropdown.Changed, Dropdown.Value)
            end
        end

        function Dropdown:SetText(...)
            -- This is an Compat dropdown for Toggles, it doesn't have an TextLabel --
            return
        end

        DropdownOuter.InputBegan:Connect(function(Input)
            if Dropdown.Disabled then
                return
            end

            if (Input.UserInputType == Enum.UserInputType.MouseButton1 and not Library:MouseIsOverOpenedFrame()) or Input.UserInputType == Enum.UserInputType.Touch then
                if ListOuter.Visible then
                    Dropdown:CloseDropdown()
                else
                    Dropdown:OpenDropdown()
                end
            end
        end)

        if Info.Searchable then
            DropdownInnerSearch:GetPropertyChangedSignal("Text"):Connect(function()
                Dropdown:BuildDropdownList()
            end)
        end

        InputService.InputBegan:Connect(function(Input)
            if Dropdown.Disabled then
                return
            end

            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                local AbsPos, AbsSize = ListOuter.AbsolutePosition, ListOuter.AbsoluteSize

                if Mouse.X < AbsPos.X or Mouse.X > AbsPos.X + AbsSize.X
                    or Mouse.Y < (AbsPos.Y - (20 * DPIScale) - 1) or Mouse.Y > AbsPos.Y + AbsSize.Y then

                    Dropdown:CloseDropdown()
                end
            end
        end)

        Dropdown:BuildDropdownList()
        Dropdown:Display()

        local Defaults = {}

        if typeof(Info.Default) == "string" then
            local DefaultIdx = table.find(Dropdown.Values, Info.Default)
            if DefaultIdx then
                table.insert(Defaults, DefaultIdx)
            end

        elseif typeof(Info.Default) == "table" then
            for _, Value in next, Info.Default do
                local DefaultIdx = table.find(Dropdown.Values, Value)
                if DefaultIdx then
                    table.insert(Defaults, DefaultIdx)
                end
            end

        elseif typeof(Info.Default) == "number" and Dropdown.Values[Info.Default] ~= nil then
            table.insert(Defaults, Info.Default)
        end

        if next(Defaults) then
            for i = 1, #Defaults do
                local Index = Defaults[i]
                if Info.Multi then
                    Dropdown.Value[Dropdown.Values[Index]] = true
                else
                    Dropdown.Value = Dropdown.Values[Index]
                end

                if (not Info.Multi) then break end
            end

            Dropdown:BuildDropdownList()
            Dropdown:Display()
        end

        task.delay(0.1, Dropdown.UpdateColors, Dropdown)

        Dropdown.DisplayFrame = DropdownOuter
        if ParentObj.Addons then
            table.insert(ParentObj.Addons, Dropdown)
        end

        Dropdown.Default = Defaults
        Dropdown.DefaultValues = Dropdown.Values

        Options[Idx] = Dropdown

        return self
    end

    BaseAddons.__index = BaseAddonsFuncs
    BaseAddons.__namecall = function(Table, Key, ...)
        return BaseAddonsFuncs[Key](...)
    end
end

--// Groupbox Addons \\--
local BaseGroupbox = {}
do
    local BaseGroupboxFuncs = {}

    function BaseGroupboxFuncs:AddBlank(Size, Visible)
        local Groupbox = self
        local Container = Groupbox.Container

        return Library:Create("Frame", {
            BackgroundTransparency = 1;
            Size = UDim2.new(1, 0, 0, Size);
            Visible = if typeof(Visible) == "boolean" then Visible else true;
            ZIndex = 1;
            Parent = Container;
        })
    end

    function BaseGroupboxFuncs:AddDivider(...)
        local Params = select(1, ...)
        local Text
        local MarginTop = 2
        local MarginBottom = 9

        if typeof(Params) == "table" then
            Text = Params.Text
            MarginTop = Params.MarginTop or Params.Margin or 2
            MarginBottom = Params.MarginBottom or Params.Margin or 9
        elseif typeof(Params) == "string" then
            Text = Params
        end

        local Groupbox = self
        local Container = self.Container

        Groupbox:AddBlank(MarginTop)

        local DividerOuter
        if Text then
            DividerOuter = Library:Create("Frame", {
                BackgroundTransparency = 1;
                Size = UDim2.new(1, -4, 0, 14);
                ZIndex = 5;
                Parent = Container;
            })

            Library:CreateLabel({
                AutomaticSize = Enum.AutomaticSize.X;
                BackgroundTransparency = 1;
                Position = UDim2.fromScale(0.5, 0.5);
                AnchorPoint = Vector2.new(0.5, 0.5);
                Size = UDim2.fromScale(1, 0);
                Text = Text;
                TextSize = 14;
                TextTransparency = 0.5;
                TextXAlignment = Enum.TextXAlignment.Center;
                ZIndex = 6;
                Parent = DividerOuter;
                RichText = true;
            })

            local X = select(1, Library:GetTextBounds(Text, Library.Font, 14 * DPIScale))
            local SizeX = math.floor(X / 2) + (10 * DPIScale)

            local LeftOuter = Library:Create("Frame", {
                AnchorPoint = Vector2.new(0, 0.5);
                BackgroundColor3 = Color3.new(0, 0, 0);
                BorderColor3 = Color3.new(0, 0, 0);
                Position = UDim2.fromScale(0, 0.5);
                Size = UDim2.new(0.5, -SizeX, 0, 5);
                ZIndex = 5;
                Parent = DividerOuter;
            })
            local LeftInner = Library:Create("Frame", {
                BackgroundColor3 = Library.MainColor;
                BorderColor3 = Library.OutlineColor;
                BorderMode = Enum.BorderMode.Inset;
                Size = UDim2.new(1, 0, 1, 0);
                ZIndex = 6;
                Parent = LeftOuter;
            })

            local RightOuter = Library:Create("Frame", {
                AnchorPoint = Vector2.new(1, 0.5);
                BackgroundColor3 = Color3.new(0, 0, 0);
                BorderColor3 = Color3.new(0, 0, 0);
                Position = UDim2.fromScale(1, 0.5);
                Size = UDim2.new(0.5, -SizeX, 0, 5);
                ZIndex = 5;
                Parent = DividerOuter;
            })
            local RightInner = Library:Create("Frame", {
                BackgroundColor3 = Library.MainColor;
                BorderColor3 = Library.OutlineColor;
                BorderMode = Enum.BorderMode.Inset;
                Size = UDim2.new(1, 0, 1, 0);
                ZIndex = 6;
                Parent = RightOuter;
            })

            Library:AddToRegistry(LeftOuter, { BorderColor3 = "Black"; })
            Library:AddToRegistry(LeftInner, { BackgroundColor3 = "MainColor"; BorderColor3 = "OutlineColor"; })
            Library:AddToRegistry(RightOuter, { BorderColor3 = "Black"; })
            Library:AddToRegistry(RightInner, { BackgroundColor3 = "MainColor"; BorderColor3 = "OutlineColor"; })
        else
            DividerOuter = Library:Create("Frame", {
                BackgroundColor3 = Color3.new(0, 0, 0);
                BorderColor3 = Color3.new(0, 0, 0);
                Size = UDim2.new(1, -4, 0, 5);
                ZIndex = 5;
                Parent = Container;
            })

            local DividerInner = Library:Create("Frame", {
                BackgroundColor3 = Library.MainColor;
                BorderColor3 = Library.OutlineColor;
                BorderMode = Enum.BorderMode.Inset;
                Size = UDim2.new(1, 0, 1, 0);
                ZIndex = 6;
                Parent = DividerOuter;
            })

            Library:AddToRegistry(DividerOuter, {
                BorderColor3 = "Black";
            })

            Library:AddToRegistry(DividerInner, {
                BackgroundColor3 = "MainColor";
                BorderColor3 = "OutlineColor";
            })
        end

        Groupbox:AddBlank(MarginBottom)
        Groupbox:Resize()

        table.insert(Groupbox.Elements, {
            Holder = DividerOuter,
            Type = "Divider",
        })
    end

    function BaseGroupboxFuncs:AddLabel(...)
        local Data = {}

        if select(2, ...) ~= nil and typeof(select(2, ...)) == "table" then
            if select(1, ...) ~= nil then
                assert(typeof(select(1, ...)) == "string", "Expected string for Idx, got " .. typeof(select(1, ...)))
            end
            
            local Params = select(2, ...)

            Data.Text = Params.Text or ""
            Data.DoesWrap = Params.DoesWrap or false
            Data.Idx = select(1, ...)
        else
            Data.Text = select(1, ...) or ""
            Data.DoesWrap = select(2, ...) or false
            Data.Idx = select(3, ...) or nil
        end

        Data.OriginalText = Data.Text
        
        local Label = {
            Type = "Label"
        }

        -- local Blank = nil
        local Groupbox = self
        local Container = Groupbox.Container

        local TextLabel = Library:CreateLabel({
            Size = UDim2.new(1, -4, 0, 15);
            TextSize = 14;
            Text = Data.Text;
            TextWrapped = Data.DoesWrap or false,
            TextXAlignment = Enum.TextXAlignment.Left;
            ZIndex = 5;
            Parent = Container;
            RichText = true;
        })

        if Data.DoesWrap then
            local Y = select(2, Library:GetTextBounds(Data.Text, Library.Font, 14 * DPIScale, Vector2.new(TextLabel.AbsoluteSize.X, math.huge)))
            TextLabel.Size = UDim2.new(1, -4, 0, Y)
        else
            Library:Create("UIListLayout", {
                Padding = UDim.new(0, 4 * DPIScale);
                FillDirection = Enum.FillDirection.Horizontal;
                HorizontalAlignment = Enum.HorizontalAlignment.Right;
                SortOrder = Enum.SortOrder.LayoutOrder;
                Parent = TextLabel;
            })
        end

        Label.TextLabel = TextLabel
        Label.Container = Container

        function Label:SetText(Text)
            TextLabel.Text = Text

            if Data.DoesWrap then
                local Y = select(2, Library:GetTextBounds(Text, Library.Font, 14 * DPIScale, Vector2.new(TextLabel.AbsoluteSize.X, math.huge)))
                TextLabel.Size = UDim2.new(1, -4, 0, Y)
            end

            Groupbox:Resize()
        end

        if (not Data.DoesWrap) then
            setmetatable(Label, BaseAddons)
        end

        -- Blank = 
        Groupbox:AddBlank(5)
        Groupbox:Resize()

        table.insert(Groupbox.Elements, Label)
        
        if Data.Idx then
            -- Options[Data.Idx] = Label;
            Labels[Data.Idx] = Label
        else
            table.insert(Labels, Label)
        end

        return Label
    end
    
    function BaseGroupboxFuncs:AddButton(...)
        local Button = typeof(select(1, ...)) == "table" and select(1, ...) or {
            Text = select(1, ...),
            Func = select(2, ...)
        }
        Button.OriginalText = Button.Text
        Button.Func = Button.Func or Button.Callback
        assert(typeof(Button.Func) == "function", "AddButton: `Func` callback is missing.")

        local Blank = nil
        local Groupbox = self
        local Container = Groupbox.Container
        local IsVisible = if typeof(Button.Visible) == "boolean" then Button.Visible else true

        local function CreateBaseButton(Button)
            local Outer = Library:Create("Frame", {
                BackgroundColor3 = Color3.new(0, 0, 0);
                BorderColor3 = Color3.new(0, 0, 0);
                Size = UDim2.new(1, -4, 0, 20);
                Visible = IsVisible;
                ZIndex = 5;
            })

            local Inner = Library:Create("Frame", {
                BackgroundColor3 = Library.MainColor;
                BorderColor3 = Library.OutlineColor;
                BorderMode = Enum.BorderMode.Inset;
                Size = UDim2.new(1, 0, 1, 0);
                ZIndex = 6;
                Parent = Outer;
            })

            local Label = Library:CreateLabel({
                Size = UDim2.new(1, 0, 1, 0);
                TextSize = 14;
                Text = Button.Text;
                ZIndex = 6;
                Parent = Inner;
                RichText = true;
            })

            Library:Create("UIGradient", {
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(212, 212, 212))
                });
                Rotation = 90;
                Parent = Inner;
            })

            Library:AddToRegistry(Outer, {
                BorderColor3 = "Black";
            })

            Library:AddToRegistry(Inner, {
                BackgroundColor3 = "MainColor";
                BorderColor3 = "OutlineColor";
            })

            Library:OnHighlight(Outer, Outer,
                { BorderColor3 = "AccentColor" },
                { BorderColor3 = "Black" }
            )

            return Outer, Inner, Label
        end

        local function InitEvents(Button)
            local function WaitForEvent(event, timeout, validator)
                local bindable = Instance.new("BindableEvent")
                local connection = event:Once(function(...)

                    if typeof(validator) == "function" and validator(...) then
                        bindable:Fire(true)
                    else
                        bindable:Fire(false)
                    end
                end)
                task.delay(timeout, function()
                    connection:disconnect()
                    bindable:Fire(false)
                end)
                return bindable.Event:Wait()
            end

            local function ValidateClick(Input)
                if Library:MouseIsOverOpenedFrame(Input) then
                    return false
                end

                if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                    return true
                elseif Input.UserInputType == Enum.UserInputType.Touch then
                    return true
                else
                    return false
                end
            end

            Button.Outer.InputBegan:Connect(function(Input)
                if Button.Disabled then
                    return
                end

                if not ValidateClick(Input) then return end
                if Button.Locked then return end

                if Button.DoubleClick then
                    Library:RemoveFromRegistry(Button.Label)
                    Library:AddToRegistry(Button.Label, { TextColor3 = "AccentColor" })

                    Button.Label.TextColor3 = Library.AccentColor
                    Button.Label.Text = "Are you sure?"
                    Button.Locked = true

                    local clicked = WaitForEvent(Button.Outer.InputBegan, 0.5, ValidateClick)

                    Library:RemoveFromRegistry(Button.Label)
                    Library:AddToRegistry(Button.Label, { TextColor3 = "FontColor" })

                    Button.Label.TextColor3 = Library.FontColor
                    Button.Label.Text = Button.Text
                    task.defer(rawset, Button, "Locked", false)

                    if clicked then
                        Library:SafeCallback(Button.Func)
                    end

                    return
                end

                Library:SafeCallback(Button.Func)
            end)
        end

        Button.Outer, Button.Inner, Button.Label = CreateBaseButton(Button)
        Button.Outer.Parent = Container

        InitEvents(Button)

        function Button:AddButton(...)
            local SubButton = typeof(select(1, ...)) == "table" and select(1, ...) or {
                Text = select(1, ...),
                Func = select(2, ...)
            }
            SubButton.OriginalText = SubButton.Text
            SubButton.Func = SubButton.Func or SubButton.Callback
            assert(typeof(SubButton.Func) == "function", "AddButton: `Func` callback is missing.")

            self.Outer.Size = UDim2.new(0.5, -2, 0, 20 * DPIScale)

            SubButton.Outer, SubButton.Inner, SubButton.Label = CreateBaseButton(SubButton)

            SubButton.Outer.Position = UDim2.new(1, 3, 0, 0)
            SubButton.Outer.Size = UDim2.new(1, -3, 0, self.Outer.AbsoluteSize.Y)
            SubButton.Outer.Parent = self.Outer

            function SubButton:UpdateColors()
                SubButton.Label.TextColor3 = SubButton.Disabled and Library.DisabledAccentColor or Color3.new(1, 1, 1)
            end

            function SubButton:AddToolTip(tooltip, disabledTooltip)
                if typeof(tooltip) == "string" or typeof(disabledTooltip) == "string" then
                    if SubButton.TooltipTable then
                        SubButton.TooltipTable:Destroy()
                    end
                
                    SubButton.TooltipTable = Library:AddToolTip(tooltip, disabledTooltip, self.Outer)
                    SubButton.TooltipTable.Disabled = SubButton.Disabled
                end

                return SubButton
            end

            function SubButton:SetDisabled(Disabled)
                SubButton.Disabled = Disabled

                if SubButton.TooltipTable then
                    SubButton.TooltipTable.Disabled = Disabled
                end

                SubButton:UpdateColors()
            end

            function SubButton:SetText(Text)
                if typeof(Text) == "string" then
                    SubButton.Text = Text
                    SubButton.Label.Text = SubButton.Text
                end
            end

            if typeof(SubButton.Tooltip) == "string" or typeof(SubButton.DisabledTooltip) == "string" then
                SubButton.TooltipTable = SubButton:AddToolTip(SubButton.Tooltip, SubButton.DisabledTooltip, SubButton.Outer)
                SubButton.TooltipTable.Disabled = SubButton.Disabled
            end

            task.delay(0.1, SubButton.UpdateColors, SubButton)
            InitEvents(SubButton)

            table.insert(Buttons, SubButton)
            return SubButton
        end

        function Button:UpdateColors()
            Button.Label.TextColor3 = Button.Disabled and Library.DisabledAccentColor or Color3.new(1, 1, 1)
        end

        function Button:AddToolTip(tooltip, disabledTooltip)
            if typeof(tooltip) == "string" or typeof(disabledTooltip) == "string" then
                if Button.TooltipTable then
                    Button.TooltipTable:Destroy()
                end

                Button.TooltipTable = Library:AddToolTip(tooltip, disabledTooltip, self.Outer)
                Button.TooltipTable.Disabled = Button.Disabled
            end

            return Button
        end

        if typeof(Button.Tooltip) == "string" or typeof(Button.DisabledTooltip) == "string" then
            Button.TooltipTable = Button:AddToolTip(Button.Tooltip, Button.DisabledTooltip, Button.Outer)
            Button.TooltipTable.Disabled = Button.Disabled
        end

        function Button:SetVisible(Visibility)
            IsVisible = Visibility

            Button.Outer.Visible = IsVisible
            if Blank then Blank.Visible = IsVisible end

            Groupbox:Resize()
        end

        function Button:SetText(Text)
            if typeof(Text) == "string" then
                Button.Text = Text
                Button.Label.Text = Button.Text
            end
        end

        function Button:SetDisabled(Disabled)
            Button.Disabled = Disabled

            if Button.TooltipTable then
                Button.TooltipTable.Disabled = Disabled
            end

            Button:UpdateColors()
        end

        task.delay(0.1, Button.UpdateColors, Button)
        Blank = Groupbox:AddBlank(5, IsVisible)
        Groupbox:Resize()

        table.insert(Groupbox.Elements, Button)
        table.insert(Buttons, Button)

        return Button
    end

    function BaseGroupboxFuncs:AddInput(Idx, Info)
        assert(Info.Text, string.format("AddInput (IDX: %s): Missing `Text` string.", tostring(Idx)))

        Info.ClearTextOnFocus = if typeof(Info.ClearTextOnFocus) == "boolean" then Info.ClearTextOnFocus else true

        local Textbox = {
            Value = Info.Default or "";
            Numeric = Info.Numeric or false;
            Finished = Info.Finished or false;
            Visible = if typeof(Info.Visible) == "boolean" then Info.Visible else true;
            Disabled = if typeof(Info.Disabled) == "boolean" then Info.Disabled else false;
            AllowEmpty = if typeof(Info.AllowEmpty) == "boolean" then Info.AllowEmpty else true;
            EmptyReset = if typeof(Info.EmptyReset) == "string" then Info.EmptyReset else "---";
            Type = "Input";

            Callback = Info.Callback or function(Value) end;
        }

        local Groupbox = self
        local Container = Groupbox.Container
        local Blank

        local InputLabel = Library:CreateLabel({
            Size = UDim2.new(1, 0, 0, 15);
            TextSize = 14;
            Text = Info.Text;
            TextXAlignment = Enum.TextXAlignment.Left;
            ZIndex = 5;
            Parent = Container;
        })

        Groupbox:AddBlank(1)

        local TextBoxOuter = Library:Create("Frame", {
            BackgroundColor3 = Color3.new(0, 0, 0);
            BorderColor3 = Color3.new(0, 0, 0);
            Size = UDim2.new(1, -4, 0, 20);
            ZIndex = 5;
            Parent = Container;
        })

        local TextBoxInner = Library:Create("Frame", {
            BackgroundColor3 = Library.MainColor;
            BorderColor3 = Library.OutlineColor;
            BorderMode = Enum.BorderMode.Inset;
            Size = UDim2.new(1, 0, 1, 0);
            ZIndex = 6;
            Parent = TextBoxOuter;
        })

        Library:AddToRegistry(TextBoxInner, {
            BackgroundColor3 = "MainColor";
            BorderColor3 = "OutlineColor";
        })

        Library:OnHighlight(TextBoxOuter, TextBoxOuter,
            { BorderColor3 = "AccentColor" },
            { BorderColor3 = "Black" }
        )

        local TooltipTable
        if typeof(Info.Tooltip) == "string" or typeof(Info.DisabledTooltip) == "string" then
            TooltipTable = Library:AddToolTip(Info.Tooltip, Info.DisabledTooltip, TextBoxOuter)
            TooltipTable.Disabled = Textbox.Disabled
        end

        Library:Create("UIGradient", {
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(212, 212, 212))
            });
            Rotation = 90;
            Parent = TextBoxInner;
        })

        local TextBoxContainer = Library:Create("Frame", {
            BackgroundTransparency = 1;
            ClipsDescendants = true;

            Position = UDim2.new(0, 5, 0, 0);
            Size = UDim2.new(1, -5, 1, 0);

            ZIndex = 7;
            Parent = TextBoxInner;
        })

        local Box = Library:Create("TextBox", {
            BackgroundTransparency = 1;

            Position = UDim2.fromOffset(0, 0),
            Size = UDim2.fromScale(5, 1),

            Font = Library.Font;
            PlaceholderColor3 = Color3.fromRGB(190, 190, 190);
            PlaceholderText = Info.Placeholder or "";

            Text = Info.Default or (if Textbox.AllowEmpty == false then Textbox.EmptyReset else "---");
            TextColor3 = Library.FontColor;
            TextSize = 14;
            TextStrokeTransparency = 0;
            TextXAlignment = Enum.TextXAlignment.Left;

            TextEditable = not Textbox.Disabled;
            ClearTextOnFocus = not Textbox.Disabled and Info.ClearTextOnFocus;

            ZIndex = 7;
            Parent = TextBoxContainer;
        })

        Library:ApplyTextStroke(Box)

        Library:AddToRegistry(Box, {
            TextColor3 = "FontColor";
        })

        function Textbox:OnChanged(Func)
            Textbox.Changed = Func

            -- if Textbox.Disabled then
            --     return;
            -- end;

            -- Library:SafeCallback(Func, Textbox.Value);
        end

        function Textbox:UpdateColors()
            Box.TextColor3 = Textbox.Disabled and Library.DisabledAccentColor or Library.FontColor

            Library.RegistryMap[Box].Properties.TextColor3 = Textbox.Disabled and "DisabledAccentColor" or "FontColor"
        end

        function Textbox:Display()
            TextBoxOuter.Visible = Textbox.Visible
            InputLabel.Visible = Textbox.Visible
            if Blank then Blank.Visible = Textbox.Visible end

            Groupbox:Resize()
        end

        function Textbox:SetValue(Text)
            if not Textbox.AllowEmpty and Trim(Text) == "" then
                Text = Textbox.EmptyReset
            end

            if Info.MaxLength and #Text > Info.MaxLength then
                Text = Text:sub(1, Info.MaxLength)
            end

            if Textbox.Numeric then
                if #tostring(Text) > 0 and not tonumber(Text) then
                    Text = Textbox.Value
                end
            end

            Textbox.Value = Text
            Box.Text = Text

            if not Textbox.Disabled then
                Library:SafeCallback(Textbox.Callback, Textbox.Value)
                Library:SafeCallback(Textbox.Changed, Textbox.Value)
            end
        end

        function Textbox:SetVisible(Visibility)
            Textbox.Visible = Visibility

            Textbox:Display()
        end

        function Textbox:SetDisabled(Disabled)
            Textbox.Disabled = Disabled

            Box.TextEditable = not Disabled
            Box.ClearTextOnFocus = not Disabled and Info.ClearTextOnFocus

            if TooltipTable then
                TooltipTable.Disabled = Disabled
            end

            Textbox:UpdateColors()
        end

        if Textbox.Finished then
            Box.FocusLost:Connect(function(enter)
                if not enter then return end

                Textbox:SetValue(Box.Text)
                Library:AttemptSave()
            end)
        else
            Box:GetPropertyChangedSignal("Text"):Connect(function()
                Textbox:SetValue(Box.Text)
                Library:AttemptSave()
            end)
        end

        -- https://devforum.roblox.com/t/how-to-make-textboxes-follow-current-cursor-position/1368429/6
        -- thank you nicemike40 :)

        local function Update()
            local PADDING = 2
            local reveal = TextBoxContainer.AbsoluteSize.X

            if not Box:IsFocused() or Box.TextBounds.X <= reveal - 2 * PADDING then
                -- we aren't focused, or we fit so be normal
                Box.Position = UDim2.new(0, PADDING, 0, 0)
            else
                -- we are focused and don't fit, so adjust position
                local cursor = Box.CursorPosition
                if cursor ~= -1 then
                    -- calculate pixel width of text from start to cursor
                    local subtext = string.sub(Box.Text, 1, cursor-1)
                    local width = TextService:GetTextSize(subtext, Box.TextSize, Box.Font, Vector2.new(math.huge, math.huge)).X

                    -- check if we're inside the box with the cursor
                    local currentCursorPos = Box.Position.X.Offset + width

                    -- adjust if necessary
                    if currentCursorPos < PADDING then
                        Box.Position = UDim2.fromOffset(PADDING-width, 0)
                    elseif currentCursorPos > reveal - PADDING - 1 then
                        Box.Position = UDim2.fromOffset(reveal-width-PADDING-1, 0)
                    end
                end
            end
        end

        task.spawn(Update)

        Box:GetPropertyChangedSignal("Text"):Connect(Update)
        Box:GetPropertyChangedSignal("CursorPosition"):Connect(Update)
        Box.FocusLost:Connect(Update)
        Box.Focused:Connect(Update)

        Blank = Groupbox:AddBlank(5, Textbox.Visible)
        task.delay(0.1, Textbox.UpdateColors, Textbox)
        Textbox:Display()
        Groupbox:Resize()

        Textbox.Default = Textbox.Value

        table.insert(Groupbox.Elements, Textbox)
        Options[Idx] = Textbox

        return Textbox
    end

    function BaseGroupboxFuncs:AddToggle(Idx, Info)
        assert(Info.Text, string.format("AddInput (IDX: %s): Missing `Text` string.", tostring(Idx)))

        local Toggle = {
            Value = Info.Default or false;
            Type = "Toggle";
            Visible = if typeof(Info.Visible) == "boolean" then Info.Visible else true;
            Disabled = if typeof(Info.Disabled) == "boolean" then Info.Disabled else false;
            Risky = if typeof(Info.Risky) == "boolean" then Info.Risky else false;
            OriginalText = Info.Text; Text = Info.Text;

            Callback = Info.Callback or function(Value) end;
            Addons = {};
        }

        local Blank
        local Tooltip
        local Groupbox = self
        local Container = Groupbox.Container

        local ToggleContainer = Library:Create("Frame", {
            BackgroundTransparency = 1;
            Size = UDim2.new(1, -4, 0, 13);
            Visible = Toggle.Visible;
            ZIndex = 5;
            Parent = Container;
        })

        local ToggleOuter = Library:Create("Frame", {
            BackgroundColor3 = Color3.new(0, 0, 0);
            BorderColor3 = Color3.new(0, 0, 0);
            Size = UDim2.new(0, 13, 0, 13);
            Visible = Toggle.Visible;
            ZIndex = 5;
            Parent = ToggleContainer;
        })

        Library:AddToRegistry(ToggleOuter, {
            BorderColor3 = "Black";
        })

        local ToggleInner = Library:Create("Frame", {
            BackgroundColor3 = Library.MainColor;
            BorderColor3 = Library.OutlineColor;
            BorderMode = Enum.BorderMode.Inset;
            Size = UDim2.new(1, 0, 1, 0);
            ZIndex = 6;
            Parent = ToggleOuter;
        })

        Library:AddToRegistry(ToggleInner, {
            BackgroundColor3 = "MainColor";
            BorderColor3 = "OutlineColor";
        })

        local ToggleLabel = Library:CreateLabel({
            Size = UDim2.new(1, -19, 0, 11); -- size of toggle box (13) + size offset of previous layout (6)
            Position = UDim2.new(0, 19, 0, 0);
            TextSize = 14;
            Text = Info.Text;
            TextXAlignment = Enum.TextXAlignment.Left;
            ZIndex = 6;
            Parent = ToggleContainer;
            RichText = true;
        })

        Library:Create("UIListLayout", {
            Padding = UDim.new(0, 4);
            FillDirection = Enum.FillDirection.Horizontal;
            HorizontalAlignment = Enum.HorizontalAlignment.Right;
            SortOrder = Enum.SortOrder.LayoutOrder;
            Parent = ToggleLabel;
        })

        local ToggleRegion = Library:Create("Frame", {
            BackgroundTransparency = 1;
            Size = UDim2.new(0, 170, 1, 0);
            ZIndex = 8;
            Parent = ToggleOuter;
        })

        Library:OnHighlight(ToggleRegion, ToggleOuter,
            { BorderColor3 = "AccentColor" },
            { BorderColor3 = "Black" },
            function()
                if Toggle.Disabled then
                    return false
                end

                for _, Addon in next, Toggle.Addons do
                    if Library:MouseIsOverFrame(Addon.DisplayFrame) then return false end
                end
                return true
            end
        )

        function Toggle:UpdateColors()
            Toggle:Display()
        end

        if typeof(Info.Tooltip) == "string" or typeof(Info.DisabledTooltip) == "string" then
            Tooltip = Library:AddToolTip(Info.Tooltip, Info.DisabledTooltip, ToggleRegion)
            Tooltip.Disabled = Toggle.Disabled
        end

        function Toggle:Display()
            if Toggle.Disabled then
                ToggleLabel.TextColor3 = Library.DisabledTextColor

                ToggleInner.BackgroundColor3 = Toggle.Value and Library.DisabledAccentColor or Library.MainColor
                ToggleInner.BorderColor3 = Library.DisabledOutlineColor

                Library.RegistryMap[ToggleInner].Properties.BackgroundColor3 = Toggle.Value and "DisabledAccentColor" or "MainColor"
                Library.RegistryMap[ToggleInner].Properties.BorderColor3 = "DisabledOutlineColor"
                Library.RegistryMap[ToggleLabel].Properties.TextColor3 = "DisabledTextColor"

                return
            end

            ToggleLabel.TextColor3 = Toggle.Risky and Library.RiskColor or Color3.new(1, 1, 1)

            ToggleInner.BackgroundColor3 = Toggle.Value and Library.AccentColor or Library.MainColor
            ToggleInner.BorderColor3 = Toggle.Value and Library.AccentColorDark or Library.OutlineColor

            Library.RegistryMap[ToggleInner].Properties.BackgroundColor3 = Toggle.Value and "AccentColor" or "MainColor"
            Library.RegistryMap[ToggleInner].Properties.BorderColor3 = Toggle.Value and "AccentColorDark" or "OutlineColor"

            Library.RegistryMap[ToggleLabel].Properties.TextColor3 = Toggle.Risky and "RiskColor" or nil
        end

        function Toggle:OnChanged(Func)
            Toggle.Changed = Func

            -- if Toggle.Disabled then
            --     return;
            -- end;

            -- Library:SafeCallback(Func, Toggle.Value);
        end

        function Toggle:SetValue(Bool)
            if Toggle.Disabled then
                return
            end

            Bool = (not not Bool)

            Toggle.Value = Bool
            Toggle:Display()

            for _, Addon in next, Toggle.Addons do
                if Addon.Type == "KeyPicker" and Addon.SyncToggleState then
                    Addon.Toggled = Bool
                    Addon:Update()
                end
            end

            if not Toggle.Disabled then
                Library:SafeCallback(Toggle.Callback, Toggle.Value)
                Library:SafeCallback(Toggle.Changed, Toggle.Value)
            end

            Library:UpdateDependencyBoxes()
            Library:UpdateDependencyGroupboxes()
        end

        function Toggle:SetVisible(Visibility)
            Toggle.Visible = Visibility

            ToggleOuter.Visible = Toggle.Visible
            if Blank then Blank.Visible = Toggle.Visible end

            Groupbox:Resize()
        end

        function Toggle:SetDisabled(Disabled)
            Toggle.Disabled = Disabled

            if Tooltip then
                Tooltip.Disabled = Disabled
            end

            Toggle:Display()
        end

        function Toggle:SetText(Text)
            if typeof(Text) == "string" then
                Toggle.Text = Text
                ToggleLabel.Text = Toggle.Text
            end
        end

        ToggleRegion.InputBegan:Connect(function(Input)
            if Toggle.Disabled then
                return
            end

            if (Input.UserInputType == Enum.UserInputType.MouseButton1 and not Library:MouseIsOverOpenedFrame()) or Input.UserInputType == Enum.UserInputType.Touch then
                for _, Addon in next, Toggle.Addons do
                    if Library:MouseIsOverFrame(Addon.DisplayFrame) then return end
                end

                Toggle:SetValue(not Toggle.Value) -- Why was it not like this from the start?
                Library:AttemptSave()
            end
        end)

        if Toggle.Risky == true then
            Library:RemoveFromRegistry(ToggleLabel)

            ToggleLabel.TextColor3 = Library.RiskColor
            Library:AddToRegistry(ToggleLabel, { TextColor3 = "RiskColor" })
        end

        Toggle:Display()
        Blank = Groupbox:AddBlank(Info.BlankSize or 5 + 2, Toggle.Visible)
        Groupbox:Resize()

        Toggle.TextLabel = ToggleLabel
        Toggle.Container = Container
        setmetatable(Toggle, BaseAddons)

        Toggle.Default = Toggle.Value

        table.insert(Groupbox.Elements, Toggle)
        Toggles[Idx] = Toggle

        Library:UpdateDependencyBoxes()
        Library:UpdateDependencyGroupboxes()

        return Toggle
    end

    function BaseGroupboxFuncs:AddSlider(Idx, Info)
        assert(Info.Default,    string.format("AddSlider (IDX: %s): Missing default value.", tostring(Idx)))
        assert(Info.Text,       string.format("AddSlider (IDX: %s): Missing slider text.", tostring(Idx)))
        assert(Info.Min,        string.format("AddSlider (IDX: %s): Missing minimum value.", tostring(Idx)))
        assert(Info.Max,        string.format("AddSlider (IDX: %s): Missing maximum value.", tostring(Idx)))
        assert(Info.Rounding,   string.format("AddSlider (IDX: %s): Missing rounding value.", tostring(Idx)))

        local Slider = {
            Value = Info.Default;

            Min = Info.Min;
            Max = Info.Max;
            Rounding = Info.Rounding;
            MaxSize = 232;
            Type = "Slider";
            Visible = if typeof(Info.Visible) == "boolean" then Info.Visible else true;
            Disabled = if typeof(Info.Disabled) == "boolean" then Info.Disabled else false;
            OriginalText = Info.Text; Text = Info.Text;

            Prefix = typeof(Info.Prefix) == "string" and Info.Prefix or "";
            Suffix = typeof(Info.Suffix) == "string" and Info.Suffix or "";

            Callback = Info.Callback or function(Value) end;
        }

        local Blanks = {}
        local SliderText = nil
        local Groupbox = self
        local Container = Groupbox.Container
        local Tooltip

        if not Info.Compact then
            SliderText = Library:CreateLabel({
                Size = UDim2.new(1, 0, 0, 10);
                TextSize = 14;
                Text = Info.Text;
                TextXAlignment = Enum.TextXAlignment.Left;
                TextYAlignment = Enum.TextYAlignment.Bottom;
                Visible = Slider.Visible;
                ZIndex = 5;
                Parent = Container;
                RichText = true;
            })

            table.insert(Blanks, Groupbox:AddBlank(3, Slider.Visible))
        end

        local SliderOuter = Library:Create("Frame", {
            BackgroundColor3 = Color3.new(0, 0, 0);
            BorderColor3 = Color3.new(0, 0, 0);
            Size = UDim2.new(1, -4, 0, 13);
            Visible = Slider.Visible;
            ZIndex = 5;
            Parent = Container;
        })

        SliderOuter:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
            Slider.MaxSize = SliderOuter.AbsoluteSize.X - 2
        end)

        Library:AddToRegistry(SliderOuter, {
            BorderColor3 = "Black";
        })

        local SliderInner = Library:Create("Frame", {
            BackgroundColor3 = Library.MainColor;
            BorderColor3 = Library.OutlineColor;
            BorderMode = Enum.BorderMode.Inset;
            Size = UDim2.new(1, 0, 1, 0);
            ZIndex = 6;
            Parent = SliderOuter;
        })

        Library:AddToRegistry(SliderInner, {
            BackgroundColor3 = "MainColor";
            BorderColor3 = "OutlineColor";
        })

        local Fill = Library:Create("Frame", {
            BackgroundColor3 = Library.AccentColor;
            BorderColor3 = Library.AccentColorDark;
            Size = UDim2.new(0, 0, 1, 0);
            ZIndex = 7;
            Parent = SliderInner;
        })

        Library:AddToRegistry(Fill, {
            BackgroundColor3 = "AccentColor";
            BorderColor3 = "AccentColorDark";
        })

        local HideBorderRight = Library:Create("Frame", {
            BackgroundColor3 = Library.AccentColor;
            BorderSizePixel = 0;
            Position = UDim2.new(1, 0, 0, 0);
            Size = UDim2.new(0, 1, 1, 0);
            ZIndex = 8;
            Parent = Fill;
        })

        Library:AddToRegistry(HideBorderRight, {
            BackgroundColor3 = "AccentColor";
        })

        local DisplayLabel = Library:CreateLabel({
            Size = UDim2.new(1, 0, 1, 0);
            TextSize = 14;
            Text = "Infinite";
            ZIndex = 9;
            Parent = SliderInner;
            RichText = true;
        })

        Library:OnHighlight(SliderOuter, SliderOuter,
            { BorderColor3 = "AccentColor" },
            { BorderColor3 = "Black" },
            function()
                return not Slider.Disabled
            end
        )

        if typeof(Info.Tooltip) == "string" or typeof(Info.DisabledTooltip) == "string" then
            Tooltip = Library:AddToolTip(Info.Tooltip, Info.DisabledTooltip, SliderOuter)
            Tooltip.Disabled = Slider.Disabled
        end

        function Slider:UpdateColors()
            if SliderText then
                SliderText.TextColor3 = Slider.Disabled and Library.DisabledAccentColor or Color3.new(1, 1, 1)
            end
            DisplayLabel.TextColor3 = Slider.Disabled and Library.DisabledAccentColor or Color3.new(1, 1, 1)

            HideBorderRight.BackgroundColor3 = Slider.Disabled and Library.DisabledAccentColor or Library.AccentColor

            Fill.BackgroundColor3 = Slider.Disabled and Library.DisabledAccentColor or Library.AccentColor
            Fill.BorderColor3 = Slider.Disabled and Library.DisabledOutlineColor or Library.AccentColorDark

            Library.RegistryMap[HideBorderRight].Properties.BackgroundColor3 = Slider.Disabled and "DisabledAccentColor" or "AccentColor"

            Library.RegistryMap[Fill].Properties.BackgroundColor3 = Slider.Disabled and "DisabledAccentColor" or "AccentColor"
            Library.RegistryMap[Fill].Properties.BorderColor3 = Slider.Disabled and "DisabledOutlineColor" or "AccentColorDark"
        end
        
        function Slider:Display()
            local CustomDisplayText = nil
            if Info.FormatDisplayValue then
                CustomDisplayText = Info.FormatDisplayValue(Slider, Slider.Value)
            end

            if CustomDisplayText then
                DisplayLabel.Text = tostring(CustomDisplayText)
            else
                local FormattedValue = (Slider.Value == 0 or Slider.Value == -0) and "0" or tostring(Slider.Value)
                if Info.Compact then
                    DisplayLabel.Text = string.format("%s: %s%s%s", Slider.Text, Slider.Prefix, FormattedValue, Slider.Suffix)

                elseif Info.HideMax then
                    DisplayLabel.Text = string.format("%s%s%s", Slider.Prefix, FormattedValue, Slider.Suffix)

                else
                    DisplayLabel.Text = string.format("%s%s%s/%s%s%s", 
                        Slider.Prefix, FormattedValue, Slider.Suffix,
                        Slider.Prefix, tostring(Slider.Max), Slider.Suffix)
                end
            end

            local X = Library:MapValue(Slider.Value, Slider.Min, Slider.Max, 0, 1)
            Fill.Size = UDim2.new(X, 0, 1, 0)

            -- I have no idea what this is
            HideBorderRight.Visible = not (X == 1 or X == 0)
        end

        function Slider:OnChanged(Func)
            Slider.Changed = Func

            -- if Slider.Disabled then
            --     return;
            -- end;
            
            -- Library:SafeCallback(Func, Slider.Value);
        end

        local function Round(Value)
            if Slider.Rounding == 0 then
                return math.floor(Value)
            end

            return tonumber(string.format("%." .. Slider.Rounding .. "f", Value))
        end

        function Slider:GetValueFromXScale(X)
            return Round(Library:MapValue(X, 0, 1, Slider.Min, Slider.Max))
        end
        
        function Slider:SetMax(Value)
            assert(Value > Slider.Min, "Max value cannot be less than the current min value.")
            
            Slider.Value = math.clamp(Slider.Value, Slider.Min, Value)
            Slider.Max = Value
            Slider:Display()
        end
        
        function Slider:SetMin(Value)
            assert(Value < Slider.Max, "Min value cannot be greater than the current max value.")

            Slider.Value = math.clamp(Slider.Value, Value, Slider.Max)
            Slider.Min = Value
            Slider:Display()
        end

        function Slider:SetValue(Str)
            if Slider.Disabled then
                return
            end

            local Num = tonumber(Str)

            if (not Num) then
                return
            end

            Num = math.clamp(Num, Slider.Min, Slider.Max)

            Slider.Value = Num
            Slider:Display()

            if not Slider.Disabled then
                Library:SafeCallback(Slider.Callback, Slider.Value)
                Library:SafeCallback(Slider.Changed, Slider.Value)
            end
        end

        function Slider:SetVisible(Visibility)
            Slider.Visible = Visibility

            if SliderText then SliderText.Visible = Slider.Visible end
            SliderOuter.Visible = Slider.Visible

            for _, Blank in pairs(Blanks) do
                Blank.Visible = Slider.Visible
            end

            Groupbox:Resize()
        end

        function Slider:SetDisabled(Disabled)
            Slider.Disabled = Disabled

            if Tooltip then
                Tooltip.Disabled = Disabled
            end

            Slider:UpdateColors()
        end

        function Slider:SetText(Text)
            if typeof(Text) == "string" then
                Slider.Text = Text

                if SliderText then SliderText.Text = Slider.Text end
                Slider:Display()
            end
        end

        function Slider:SetPrefix(Prefix)
            if typeof(Prefix) == "string" then
                Slider.Prefix = Prefix
                Slider:Display()
            end
        end

        function Slider:SetSuffix(Suffix)
            if typeof(Suffix) == "string" then
                Slider.Suffix = Suffix
                Slider:Display()
            end
        end

        SliderInner.InputBegan:Connect(function(Input)
            if Slider.Disabled then
                return
            end

            if (Input.UserInputType == Enum.UserInputType.MouseButton1 and not Library:MouseIsOverOpenedFrame()) or Input.UserInputType == Enum.UserInputType.Touch then
                if Library.IsMobile then
                    Library.CanDrag = false
                end

                local Sides = {}
                if Library.Window then
                    Sides = Library.Window.Tabs[Library.ActiveTab]:GetSides()
                end

                for _, Side in pairs(Sides) do
                    if typeof(Side) == "Instance" then
                        if Side:IsA("ScrollingFrame") then
                            Side.ScrollingEnabled = false
                        end
                    end
                end

                local mPos = Mouse.X
                local gPos = Fill.AbsoluteSize.X
                local Diff = mPos - (Fill.AbsolutePosition.X + gPos)

                while InputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1 or Enum.UserInputType.Touch) do
                    local nMPos = Mouse.X
                    local nXOffset = math.clamp(gPos + (nMPos - mPos) + Diff, 0, Slider.MaxSize) -- what in tarnation are these variable names
                    local nXScale = Library:MapValue(nXOffset, 0, Slider.MaxSize, 0, 1)

                    local nValue = Slider:GetValueFromXScale(nXScale)
                    local OldValue = Slider.Value
                    Slider.Value = nValue

                    Slider:Display()

                    if nValue ~= OldValue then
                        Library:SafeCallback(Slider.Callback, Slider.Value)
                        Library:SafeCallback(Slider.Changed, Slider.Value)
                    end

                    RunService.RenderStepped:Wait()
                end

                if Library.IsMobile then
                    Library.CanDrag = true
                end
                
                for _, Side in pairs(Sides) do
                    if typeof(Side) == "Instance" then
                        if Side:IsA("ScrollingFrame") then
                            Side.ScrollingEnabled = true
                        end
                    end
                end

                Library:AttemptSave()
            end
        end)

        task.delay(0.1, Slider.UpdateColors, Slider)
        Slider:Display()
        table.insert(Blanks, Groupbox:AddBlank(Info.BlankSize or 6, Slider.Visible))
        Groupbox:Resize()

        Slider.Default = Slider.Value

        table.insert(Groupbox.Elements, Slider)
        Options[Idx] = Slider

        return Slider
    end

    function BaseGroupboxFuncs:AddDropdown(Idx, Info)
        Info.ReturnInstanceInstead = if typeof(Info.ReturnInstanceInstead) == "boolean" then Info.ReturnInstanceInstead else false

        if Info.SpecialType == "Player" then
            Info.ExcludeLocalPlayer = if typeof(Info.ExcludeLocalPlayer) == "boolean" then Info.ExcludeLocalPlayer else false

            Info.Values = GetPlayers(Info.ExcludeLocalPlayer, Info.ReturnInstanceInstead)
            Info.AllowNull = true
        elseif Info.SpecialType == "Team" then
            Info.Values = GetTeams(Info.ReturnInstanceInstead)
            Info.AllowNull = true
        end

        assert(Info.Values, string.format("AddDropdown (IDX: %s): Missing dropdown value list.", tostring(Idx)))
        if not (Info.AllowNull or Info.Default) then
            Info.Default = 1
            warn(string.format("AddDropdown (IDX: %s): Missing default value, selected the first index instead. Pass `AllowNull` as true if this was intentional.", tostring(Idx)))
        end
        
        Info.Searchable = if typeof(Info.Searchable) == "boolean" then Info.Searchable else false
        Info.FormatDisplayValue = if typeof(Info.FormatDisplayValue) == "function" then Info.FormatDisplayValue else nil
        Info.FormatListValue = if typeof(Info.FormatListValue) == "function" then Info.FormatListValue else nil

        if (not Info.Text) then
            Info.Compact = true
        end

        local Dropdown = {
            Values = Info.Values;
            Value = Info.Multi and {};
            DisabledValues = Info.DisabledValues or {};

            Multi = Info.Multi;
            Type = "Dropdown";
            SpecialType = Info.SpecialType; -- can be either "Player" or "Team"
            Visible = if typeof(Info.Visible) == "boolean" then Info.Visible else true;
            Disabled = if typeof(Info.Disabled) == "boolean" then Info.Disabled else false;
            Callback = Info.Callback or function(Value) end;
            Changed = Info.Changed or function(Value) end;

            OriginalText = Info.Text; Text = Info.Text;
            ExcludeLocalPlayer = Info.ExcludeLocalPlayer;
            ReturnInstanceInstead = Info.ReturnInstanceInstead;
        }

        local DropdownLabel
        local Blank
        local CompactBlank
        local Tooltip
        local Groupbox = self
        local Container = Groupbox.Container

        local RelativeOffset = 0

        if not Info.Compact then
            DropdownLabel = Library:CreateLabel({
                Size = UDim2.new(1, 0, 0, 10);
                TextSize = 14;
                Text = Info.Text;
                TextXAlignment = Enum.TextXAlignment.Left;
                TextYAlignment = Enum.TextYAlignment.Bottom;
                Visible = Dropdown.Visible;
                ZIndex = 5;
                Parent = Container;
                RichText = true;
            })

            CompactBlank = Groupbox:AddBlank(3, Dropdown.Visible)
        end

        for _, Element in next, Container:GetChildren() do
            if not Element:IsA("UIListLayout") then
                RelativeOffset = RelativeOffset + Element.Size.Y.Offset
            end
        end

        local DropdownOuter = Library:Create("Frame", {
            BackgroundColor3 = Color3.new(0, 0, 0);
            BorderColor3 = Color3.new(0, 0, 0);
            Size = UDim2.new(1, -4, 0, 20);
            Visible = Dropdown.Visible;
            ZIndex = 5;
            Parent = Container;
        })

        Library:AddToRegistry(DropdownOuter, {
            BorderColor3 = "Black";
        })

        local DropdownInner = Library:Create("Frame", {
            BackgroundColor3 = Library.MainColor;
            BorderColor3 = Library.OutlineColor;
            BorderMode = Enum.BorderMode.Inset;
            Size = UDim2.new(1, 0, 1, 0);
            ZIndex = 6;
            Parent = DropdownOuter;
        })

        Library:AddToRegistry(DropdownInner, {
            BackgroundColor3 = "MainColor";
            BorderColor3 = "OutlineColor";
        })

        Library:Create("UIGradient", {
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(212, 212, 212))
            });
            Rotation = 90;
            Parent = DropdownInner;
        })

        local DropdownInnerSearch
        if Info.Searchable then
            DropdownInnerSearch = Library:Create("TextBox", {
                BackgroundTransparency = 1;
                Visible = false;

                Position = UDim2.new(0, 5, 0, 0);
                Size = UDim2.new(0.9, -5, 1, 0);

                Font = Library.Font;
                PlaceholderColor3 = Color3.fromRGB(190, 190, 190);
                PlaceholderText = "Search...";

                Text = "";
                TextColor3 = Library.FontColor;
                TextSize = 14;
                TextStrokeTransparency = 0;
                TextXAlignment = Enum.TextXAlignment.Left;

                ClearTextOnFocus = false;

                ZIndex = 7;
                Parent = DropdownOuter;
            })

            Library:ApplyTextStroke(DropdownInnerSearch)

            Library:AddToRegistry(DropdownInnerSearch, {
                TextColor3 = "FontColor";
            })
        end

        local DropdownArrow = Library:Create("ImageLabel", {
            AnchorPoint = Vector2.new(0, 0.5);
            BackgroundTransparency = 1;
            Position = UDim2.new(1, -16, 0.5, 0);
            Size = UDim2.new(0, 12, 0, 12);
            Image = CustomImageManager.GetAsset("DropdownArrow");
            ZIndex = 8;
            Parent = DropdownInner;
        })

        local ItemList = Library:CreateLabel({
            Position = UDim2.new(0, 5, 0, 0);
            Size = UDim2.new(1, -5, 1, 0);
            TextSize = 14;
            Text = "--";
            TextXAlignment = Enum.TextXAlignment.Left;
            TextWrapped = false;
            TextTruncate = Enum.TextTruncate.AtEnd;
            RichText = true;
            ZIndex = 7;
            Parent = DropdownInner;
        })

        Library:OnHighlight(DropdownOuter, DropdownOuter,
            { BorderColor3 = "AccentColor" },
            { BorderColor3 = "Black" },
            function()
                return not Dropdown.Disabled
            end
        )

        if typeof(Info.Tooltip) == "string" or typeof(Info.DisabledTooltip) == "string" then
            Tooltip = Library:AddToolTip(Info.Tooltip, Info.DisabledTooltip, DropdownOuter)
            Tooltip.Disabled = Dropdown.Disabled
        end

        local MAX_DROPDOWN_ITEMS = if typeof(Info.MaxVisibleDropdownItems) == "number" then math.clamp(Info.MaxVisibleDropdownItems, 4, 16) else 8

        local ListOuter = Library:Create("Frame", {
            BackgroundColor3 = Color3.new(0, 0, 0);
            BorderColor3 = Color3.new(0, 0, 0);
            ZIndex = 20;
            Visible = false;
            Parent = ScreenGui;
        })

        local function RecalculateListPosition()
            ListOuter.Position = UDim2.fromOffset(DropdownOuter.AbsolutePosition.X, DropdownOuter.AbsolutePosition.Y + DropdownOuter.Size.Y.Offset + 1)
        end

        local function RecalculateListSize(YSize)
            local Y = YSize or math.clamp(GetTableSize(Dropdown.Values) * (20 * DPIScale), 0, MAX_DROPDOWN_ITEMS * (20 * DPIScale)) + 1
            ListOuter.Size = UDim2.fromOffset(DropdownOuter.AbsoluteSize.X + 0.5, Y)
        end

        RecalculateListPosition()
        RecalculateListSize()

        DropdownOuter:GetPropertyChangedSignal("AbsolutePosition"):Connect(RecalculateListPosition)

        local ListInner = Library:Create("Frame", {
            BackgroundColor3 = Library.MainColor;
            BorderColor3 = Library.OutlineColor;
            BorderMode = Enum.BorderMode.Inset;
            BorderSizePixel = 0;
            Size = UDim2.new(1, 0, 1, 0);
            ZIndex = 21;
            Parent = ListOuter;
        })

        Library:AddToRegistry(ListInner, {
            BackgroundColor3 = "MainColor";
            BorderColor3 = "OutlineColor";
        })

        local Scrolling = Library:Create("ScrollingFrame", {
            BackgroundTransparency = 1;
            BorderSizePixel = 0;
            CanvasSize = UDim2.new(0, 0, 0, 0);
            Size = UDim2.new(1, 0, 1, 0);
            ZIndex = 21;
            Parent = ListInner;

            TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png",
            BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png",

            ScrollBarThickness = 3,
            ScrollBarImageColor3 = Library.AccentColor,
        })

        Library:AddToRegistry(Scrolling, {
            ScrollBarImageColor3 = "AccentColor"
        })

        Library:Create("UIListLayout", {
            Padding = UDim.new(0, 0);
            FillDirection = Enum.FillDirection.Vertical;
            SortOrder = Enum.SortOrder.LayoutOrder;
            Parent = Scrolling;
        })

        function Dropdown:UpdateColors()
            if DropdownLabel then
                DropdownLabel.TextColor3 = Dropdown.Disabled and Library.DisabledAccentColor or Color3.new(1, 1, 1)
            end

            ItemList.TextColor3 = Dropdown.Disabled and Library.DisabledAccentColor or Color3.new(1, 1, 1)
            DropdownArrow.ImageColor3 = Dropdown.Disabled and Library.DisabledAccentColor or Color3.new(1, 1, 1)
        end

        function Dropdown:Display()
            local Values = Dropdown.Values
            local Str = ""

            if Info.Multi then
                for Idx, Value in next, Values do
                    if Dropdown.Value[Value] then
                        Str = Str .. tostring(Info.FormatDisplayValue and Info.FormatDisplayValue(Value) or Value) .. ", "
                    end
                end

                Str = Str:sub(1, #Str - 2)
                ItemList.Text = (Str == "" and "--" or Str)
            else
                if not Dropdown.Value then
                    ItemList.Text = "--"
                    return
                end

                ItemList.Text = tostring(Info.FormatDisplayValue and Info.FormatDisplayValue(Dropdown.Value) or Dropdown.Value)
            end
        end

        function Dropdown:GetActiveValues()
            if Info.Multi then
                local T = {}

                for Value, Bool in next, Dropdown.Value do
                    table.insert(T, Value)
                end

                return T
            else
                return Dropdown.Value and 1 or 0
            end
        end

        function Dropdown:BuildDropdownList()
            local Values = Dropdown.Values
            local DisabledValues = Dropdown.DisabledValues
            local Buttons = {}

            for _, Element in next, Scrolling:GetChildren() do
                if not Element:IsA("UIListLayout") then
                    Element:Destroy()
                end
            end

            local Count = 0
            for Idx, Value in next, Values do
                local StringValue = tostring(Info.FormatListValue and Info.FormatListValue(Value) or Value)
                if Info.Searchable and not string.lower(StringValue):match(string.lower(DropdownInnerSearch.Text)) then
                    continue
                end

                local IsDisabled = table.find(DisabledValues, StringValue)
                local Table = {}

                Count = Count + 1

                local Button = Library:Create("TextButton", {
                    AutoButtonColor = false,
                    BackgroundColor3 = Library.MainColor;
                    BorderColor3 = Library.OutlineColor;
                    BorderMode = Enum.BorderMode.Middle;
                    Size = UDim2.new(1, -1, 0, 20);
                    Text = "";
                    ZIndex = 23;
                    Parent = Scrolling;
                })

                Library:AddToRegistry(Button, {
                    BackgroundColor3 = "MainColor";
                    BorderColor3 = "OutlineColor";
                })

                local ButtonLabel = Library:CreateLabel({
                    Active = false;
                    Size = UDim2.new(1, -6, 1, 0);
                    Position = UDim2.new(0, 6, 0, 0);
                    TextSize = 14;
                    Text = Info.FormatDisplayValue and tostring(Info.FormatDisplayValue(StringValue)) or StringValue;
                    TextXAlignment = Enum.TextXAlignment.Left;
                    RichText = true;
                    ZIndex = 25;
                    Parent = Button;
                })

                Library:OnHighlight(Button, Button,
                    { BorderColor3 = IsDisabled and "DisabledAccentColor" or "AccentColor", ZIndex = 24 },
                    { BorderColor3 = "OutlineColor", ZIndex = 23 }
                )

                local Selected

                if Info.Multi then
                    Selected = Dropdown.Value[Value]
                else
                    Selected = Dropdown.Value == Value
                end

                function Table:UpdateButton()
                    if Info.Multi then
                        Selected = Dropdown.Value[Value]
                    else
                        Selected = Dropdown.Value == Value
                    end

                    ButtonLabel.TextColor3 = Selected and Library.AccentColor or (IsDisabled and Library.DisabledAccentColor or Library.FontColor)
                    Library.RegistryMap[ButtonLabel].Properties.TextColor3 = Selected and "AccentColor" or (IsDisabled and "DisabledAccentColor" or "FontColor")
                end

                if not IsDisabled then
                    Button.MouseButton1Click:Connect(function(Input)
                        local Try = not Selected

                        if Dropdown:GetActiveValues() == 1 and (not Try) and (not Info.AllowNull) then
                        else
                            if Info.Multi then
                                Selected = Try

                                if Selected then
                                    Dropdown.Value[Value] = true
                                else
                                    Dropdown.Value[Value] = nil
                                end
                            else
                                Selected = Try

                                if Selected then
                                    Dropdown.Value = Value
                                else
                                    Dropdown.Value = nil
                                end

                                for _, OtherButton in next, Buttons do
                                    OtherButton:UpdateButton()
                                end
                            end

                            Table:UpdateButton()
                            Dropdown:Display()
                            
                            Library:UpdateDependencyBoxes()
                            Library:UpdateDependencyGroupboxes()
                            Library:SafeCallback(Dropdown.Callback, Dropdown.Value)
                            Library:SafeCallback(Dropdown.Changed, Dropdown.Value)

                            Library:AttemptSave()
                        end
                    end)
                end

                Table:UpdateButton()
                Dropdown:Display()

                Buttons[Button] = Table
            end

            Scrolling.CanvasSize = UDim2.fromOffset(0, (Count * (20 * DPIScale)) + 1)

            -- Workaround for silly roblox bug - not sure why it happens but sometimes the dropdown list will be empty
            -- ... and for some reason refreshing the Visible property fixes the issue??????? thanks roblox!
            Scrolling.Visible = false
            Scrolling.Visible = true

            local Y = math.clamp(Count * (20 * DPIScale), 0, MAX_DROPDOWN_ITEMS * (20 * DPIScale)) + 1
            RecalculateListSize(Y)
        end

        function Dropdown:SetValues(NewValues)
            if NewValues then
                Dropdown.Values = NewValues
            end

            Dropdown:BuildDropdownList()
        end

        function Dropdown:AddValues(NewValues)
            if typeof(NewValues) == "table" then
                for _, val in pairs(NewValues) do
                    table.insert(Dropdown.Values, val)
                end
            elseif typeof(NewValues) == "string" then
                table.insert(Dropdown.Values, NewValues)
            else
                return
            end

            Dropdown:BuildDropdownList()
        end

        function Dropdown:SetDisabledValues(NewValues)
            if NewValues then
                Dropdown.DisabledValues = NewValues
            end

            Dropdown:BuildDropdownList()
        end

        function Dropdown:AddDisabledValues(DisabledValues)
            if typeof(DisabledValues) == "table" then
                for _, val in pairs(DisabledValues) do
                    table.insert(Dropdown.DisabledValues, val)
                end
            elseif typeof(DisabledValues) == "string" then
                table.insert(Dropdown.DisabledValues, DisabledValues)
            else
                return
            end

            Dropdown:BuildDropdownList()
        end

        function Dropdown:SetVisible(Visibility)
            Dropdown.Visible = Visibility

            DropdownOuter.Visible = Dropdown.Visible
            if DropdownLabel then DropdownLabel.Visible = Dropdown.Visible end

            if Blank then Blank.Visible = Dropdown.Visible end
            if CompactBlank then CompactBlank.Visible = Dropdown.Visible end

            if not Dropdown.Visible then Dropdown:CloseDropdown() end

            Groupbox:Resize()
        end

        function Dropdown:SetDisabled(Disabled)
            Dropdown.Disabled = Disabled

            if Tooltip then
                Tooltip.Disabled = Disabled
            end

            if Disabled then
                Dropdown:CloseDropdown()
            end

            Dropdown:Display()
            Dropdown:UpdateColors()
        end

        function Dropdown:OpenDropdown()
            if Dropdown.Disabled then
                return
            end

            if Library.IsMobile then
                Library.CanDrag = false
            end

            if Info.Searchable then
                ItemList.Visible = false
                DropdownInnerSearch.Text = ""
                DropdownInnerSearch.Visible = true
            end

            ListOuter.Visible = true
            Library.OpenedFrames[ListOuter] = true
            DropdownArrow.Rotation = 180

            RecalculateListSize()
        end

        function Dropdown:CloseDropdown()
            if Library.IsMobile then            
                Library.CanDrag = true
            end

            if Info.Searchable then
                DropdownInnerSearch.Text = ""
                DropdownInnerSearch.Visible = false
                ItemList.Visible = true
            end

            ListOuter.Visible = false
            Library.OpenedFrames[ListOuter] = nil
            DropdownArrow.Rotation = 0
        end

        function Dropdown:OnChanged(Func)
            Dropdown.Changed = Func

            -- if Dropdown.Disabled then
            --     return;
            -- end;

            -- Library:SafeCallback(Func, Dropdown.Value);
        end

        function Dropdown:SetValue(Value)
            if Dropdown.Multi then
                local Table = {}

                for Val, Active in pairs(Value or {}) do
                    if typeof(Active) ~= "boolean" then
                        Table[Active] = true
                    elseif Active and table.find(Dropdown.Values, Val) then
                        Table[Val] = true
                    end
                end

                Dropdown.Value = Table
            else
                if table.find(Dropdown.Values, Value) then
                    Dropdown.Value = Value
                elseif not Value then
                    Dropdown.Value = nil
                end
            end

            Dropdown:BuildDropdownList()

            if not Dropdown.Disabled then
                Library:SafeCallback(Dropdown.Callback, Dropdown.Value)
                Library:SafeCallback(Dropdown.Changed, Dropdown.Value)
            end
        end

        function Dropdown:SetText(Text)
            if typeof(Text) == "string" then
                if Info.Compact then Info.Compact = false end
                Dropdown.Text = Text

                if DropdownLabel then DropdownLabel.Text = Dropdown.Text end
                Dropdown:Display()
            end
        end

        DropdownOuter.InputBegan:Connect(function(Input)
            if Dropdown.Disabled then
                return
            end

            if (Input.UserInputType == Enum.UserInputType.MouseButton1 and not Library:MouseIsOverOpenedFrame()) or Input.UserInputType == Enum.UserInputType.Touch then
                if ListOuter.Visible then
                    Dropdown:CloseDropdown()
                else
                    Dropdown:OpenDropdown()
                end
            end
        end)

        if Info.Searchable then
            DropdownInnerSearch:GetPropertyChangedSignal("Text"):Connect(function()
                Dropdown:BuildDropdownList()
            end)
        end

        InputService.InputBegan:Connect(function(Input)
            if Dropdown.Disabled then
                return
            end

            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                local AbsPos, AbsSize = ListOuter.AbsolutePosition, ListOuter.AbsoluteSize

                if Mouse.X < AbsPos.X or Mouse.X > AbsPos.X + AbsSize.X
                    or Mouse.Y < (AbsPos.Y - (20 * DPIScale) - 1) or Mouse.Y > AbsPos.Y + AbsSize.Y then

                    Dropdown:CloseDropdown()
                end
            end
        end)

        Dropdown:BuildDropdownList()
        Dropdown:Display()

        local Defaults = {}

        if typeof(Info.Default) == "string" then
            local DefaultIdx = table.find(Dropdown.Values, Info.Default)
            if DefaultIdx then
                table.insert(Defaults, DefaultIdx)
            end
        elseif typeof(Info.Default) == "table" then
            for _, Value in next, Info.Default do
                local DefaultIdx = table.find(Dropdown.Values, Value)
                if DefaultIdx then
                    table.insert(Defaults, DefaultIdx)
                end
            end
        elseif typeof(Info.Default) == "number" and Dropdown.Values[Info.Default] ~= nil then
            table.insert(Defaults, Info.Default)
        end

        if next(Defaults) then
            for i = 1, #Defaults do
                local Index = Defaults[i]
                if Info.Multi then
                    Dropdown.Value[Dropdown.Values[Index]] = true
                else
                    Dropdown.Value = Dropdown.Values[Index]
                end

                if (not Info.Multi) then break end
            end

            Dropdown:BuildDropdownList()
            Dropdown:Display()
        end

        task.delay(0.1, Dropdown.UpdateColors, Dropdown)
        Blank = Groupbox:AddBlank(Info.BlankSize or 5, Dropdown.Visible)
        Groupbox:Resize()

        Dropdown.Default = Defaults
        Dropdown.DefaultValues = Dropdown.Values

        table.insert(Groupbox.Elements, Dropdown)
        Options[Idx] = Dropdown

        return Dropdown
    end

    function BaseGroupboxFuncs:AddViewport(Idx, Info)
        local Dragging, Pinching = false, false
        local LastMousePos, LastPinchDist = nil, 0

        local Viewport = {
            Object = if Info.Clone then Info.Object:Clone() else Info.Object,
            Camera = if not Info.Camera then Instance.new("Camera") else Info.Camera,
            Interactive = Info.Interactive,
            AutoFocus = Info.AutoFocus,
            Height = if typeof(Info.Height) == "number" and Info.Height > 0 then Info.Height else 200,
            Visible = Info.Visible,
            Type = "Viewport",
        }

        assert(
            typeof(Viewport.Object) == "Instance" and (Viewport.Object:IsA("BasePart") or Viewport.Object:IsA("Model")),
            "Instance must be a BasePart or Model."
        )

        assert(
            typeof(Viewport.Camera) == "Instance" and Viewport.Camera:IsA("Camera"),
            "Camera must be a valid Camera instance."
        )

        local function GetModelSize(model)
            if model:IsA("BasePart") then
                return model.Size
            end

            return select(2, model:GetBoundingBox())
        end

        local function FocusCamera()
            local ModelSize = GetModelSize(Viewport.Object)
            local MaxExtent = math.max(ModelSize.X, ModelSize.Y, ModelSize.Z)
            local CameraDistance = MaxExtent * 2
            local ModelPosition = Viewport.Object:GetPivot().Position

            Viewport.Camera.CFrame =
                CFrame.new(ModelPosition + Vector3.new(0, MaxExtent / 2, CameraDistance), ModelPosition)
        end

        local Blank = nil
        local Groupbox = self
        local Container = Groupbox.Container

        local Holder = Library:Create("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -4, 0, Info.Height),
            Visible = Viewport.Visible,
            Parent = Container,
        })

        local Box = Library:Create("Frame", {
            BackgroundColor3 = Library.MainColor,
            BorderColor3 = Library.OutlineColor,
            BorderSizePixel = 1,
            BorderMode = Enum.BorderMode.Inset,
            Size = UDim2.fromScale(1, 1),
            ZIndex = 6,
            Parent = Holder,
        })

        Library:AddToRegistry(Box, {
            BackgroundColor3 = "MainColor";
            BorderColor3 = "OutlineColor";
        })

        Library:Create("UIPadding", {
            PaddingBottom = UDim.new(0, 3),
            PaddingLeft = UDim.new(0, 8),
            PaddingRight = UDim.new(0, 8),
            PaddingTop = UDim.new(0, 4),
            Parent = Box,
        })

        local ViewportFrame = Library:Create("ViewportFrame", {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1),
            Parent = Box,
            CurrentCamera = Viewport.Camera,
            Active = Viewport.Interactive,
            ZIndex = 7
        })

        ViewportFrame.MouseEnter:Connect(function()
            if not Viewport.Interactive then
                return
            end
            
            for _, Side in pairs(Library.Window.Tabs[Library.ActiveTab]:GetSides()) do
                if typeof(Side) == "Instance" then
                    if Side:IsA("ScrollingFrame") then
                        Side.ScrollingEnabled = false
                    end
                end
            end
        end)

        ViewportFrame.MouseLeave:Connect(function()
            if not Viewport.Interactive then
                return
            end

            for _, Side in pairs(Library.Window.Tabs[Library.ActiveTab]:GetSides()) do
                if typeof(Side) == "Instance" then
                    if Side:IsA("ScrollingFrame") then
                        Side.ScrollingEnabled = true
                    end
                end
            end
        end)

        ViewportFrame.InputBegan:Connect(function(input)
            if not Viewport.Interactive then
                return
            end

            if input.UserInputType == Enum.UserInputType.MouseButton2 then
                Dragging = true
                LastMousePos = input.Position
            elseif input.UserInputType == Enum.UserInputType.Touch and not Pinching then
                Dragging = true
                LastMousePos = input.Position
            end
        end)

        Library:GiveSignal(InputService.InputEnded:Connect(function(input)
            if Library.Unloaded then
                return
            end

            if not Viewport.Interactive then
                return
            end

            if input.UserInputType == Enum.UserInputType.MouseButton2 then
                Dragging = false
            elseif input.UserInputType == Enum.UserInputType.Touch then
                Dragging = false
            end
        end))

        Library:GiveSignal(InputService.InputChanged:Connect(function(input)
            if Library.Unloaded then
                return
            end

            if not Viewport.Interactive or not Dragging or Pinching then
                return
            end

            if
                input.UserInputType == Enum.UserInputType.MouseMovement
                or input.UserInputType == Enum.UserInputType.Touch
            then
                local MouseDelta = input.Position - LastMousePos
                LastMousePos = input.Position

                local Position = Viewport.Object:GetPivot().Position
                local Camera = Viewport.Camera

                local RotationY = CFrame.fromAxisAngle(Vector3.new(0, 1, 0), -MouseDelta.X * 0.01)
                Camera.CFrame = CFrame.new(Position) * RotationY * CFrame.new(-Position) * Camera.CFrame

                local RotationX = CFrame.fromAxisAngle(Camera.CFrame.RightVector, -MouseDelta.Y * 0.01)
                local PitchedCFrame = CFrame.new(Position) * RotationX * CFrame.new(-Position) * Camera.CFrame

                if PitchedCFrame.UpVector.Y > 0.1 then
                    Camera.CFrame = PitchedCFrame
                end
            end
        end))

        ViewportFrame.InputChanged:Connect(function(input)
            if not Viewport.Interactive then
                return
            end

            if input.UserInputType == Enum.UserInputType.MouseWheel then
                local ZoomAmount = input.Position.Z * 2
                Viewport.Camera.CFrame += Viewport.Camera.CFrame.LookVector * ZoomAmount
            end
        end)

        Library:GiveSignal(InputService.TouchPinch:Connect(function(touchPositions, scale, velocity, state)
            if Library.Unloaded then
                return
            end

            if not Viewport.Interactive or not Library:MouseIsOverFrame(ViewportFrame, touchPositions[1]) then
                return
            end

            if state == Enum.UserInputState.Begin then
                Pinching = true
                Dragging = false
                LastPinchDist = (touchPositions[1] - touchPositions[2]).Magnitude
            elseif state == Enum.UserInputState.Change then
                local currentDist = (touchPositions[1] - touchPositions[2]).Magnitude
                local delta = (currentDist - LastPinchDist) * 0.1
                LastPinchDist = currentDist
                Viewport.Camera.CFrame += Viewport.Camera.CFrame.LookVector * delta
            elseif state == Enum.UserInputState.End or state == Enum.UserInputState.Cancel then
                Pinching = false
            end
        end))

        Viewport.Object.Parent = ViewportFrame
        if Viewport.AutoFocus then
            FocusCamera()
        end

        function Viewport:SetObject(Object: Instance, Clone: boolean?)
            assert(Object, "Object cannot be nil.")

            if Clone then
                Object = Object:Clone()
            end

            if Viewport.Object then
                Viewport.Object:Destroy()
            end

            Viewport.Object = Object
            Viewport.Object.Parent = ViewportFrame

            Groupbox:Resize()
        end

        function Viewport:SetHeight(Height: number)
            assert(Height > 0, "Height must be greater than 0.")
            Viewport.Height = Height

            Holder.Size = UDim2.new(1, -4, 0, Viewport.Height)
            Groupbox:Resize()
        end

        function Viewport:Focus()
            if not Viewport.Object then
                return
            end

            FocusCamera()
        end

        function Viewport:SetCamera(Camera: Instance)
            assert(
                Camera and typeof(Camera) == "Instance" and Camera:IsA("Camera"),
                "Camera must be a valid Camera instance."
            )

            Viewport.Camera = Camera
            ViewportFrame.CurrentCamera = Camera
        end

        function Viewport:SetInteractive(Interactive: boolean)
            Viewport.Interactive = Interactive
            ViewportFrame.Active = Interactive
        end

        function Viewport:SetVisible(Visible: boolean)
            Viewport.Visible = Visible

            Holder.Visible = Viewport.Visible
            if Blank then Blank.Visible = Viewport.Visible end

            Groupbox:Resize()
        end

        Viewport:SetHeight(Viewport.Height)

        Blank = Groupbox:AddBlank(10, Viewport.Visible)
        Groupbox:Resize()

        Viewport.Holder = Holder
        Viewport.Container = Container

        table.insert(Groupbox.Elements, Viewport)
        Options[Idx] = Viewport

        Library:UpdateDependencyBoxes()
        Library:UpdateDependencyGroupboxes()

        return Viewport
    end

    function BaseGroupboxFuncs:AddImage(Idx, Info)
        local Image = {
            Image = Info.Image,
            Color = Info.Color,
            RectOffset = Info.RectOffset,
            RectSize = Info.RectSize,
            Height = if typeof(Info.Height) == "number" and Info.Height > 0 then Info.Height else 200,
            ScaleType = Info.ScaleType,
            Transparency = Info.Transparency,
            BackgroundTransparency = tonumber(Info.BackgroundTransparency) or 0,

            Visible = Info.Visible,
            Type = "Image",
        }

        local Blank = nil
        local Groupbox = self
        local Container = Groupbox.Container

        local Holder = Library:Create("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -4, 0, Info.Height),
            Visible = Image.Visible,
            Parent = Container,
        })

        local Box = Library:Create("Frame", {
            BackgroundColor3 = Library.MainColor,
            BorderColor3 = Library.OutlineColor,
            BorderSizePixel = 1,
            BackgroundTransparency = Image.BackgroundTransparency,
            BorderMode = Enum.BorderMode.Inset,
            Size = UDim2.fromScale(1, 1),
            ZIndex = 6,
            Parent = Holder,
        })

        Library:AddToRegistry(Box, {
            BackgroundColor3 = "MainColor";
            BorderColor3 = "OutlineColor";
        })

        Library:Create("UIPadding", {
            PaddingBottom = UDim.new(0, 3),
            PaddingLeft = UDim.new(0, 8),
            PaddingRight = UDim.new(0, 8),
            PaddingTop = UDim.new(0, 4),
            Parent = Box,
        })

        local ImageProperties = {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1),
            Image = Image.Image,
            ImageTransparency = Image.Transparency,
            ImageColor3 = Image.Color,
            ImageRectOffset = Image.RectOffset,
            ImageRectSize = Image.RectSize,
            ScaleType = Image.ScaleType,
            ZIndex = 7,
            Parent = Box,
        }

        local Icon = Library:GetCustomIcon(ImageProperties.Image)
        assert(Icon, "Image must be a valid Roblox asset or a valid URL or a valid lucide icon.")

        ImageProperties.Image = Icon.Url
        ImageProperties.ImageRectOffset = Icon.ImageRectOffset
        ImageProperties.ImageRectSize = Icon.ImageRectSize

        local ImageLabel = Library:Create("ImageLabel", ImageProperties)

        function Image:SetHeight(Height: number)
            assert(Height > 0, "Height must be greater than 0.")
            Image.Height = Height

            Holder.Size = UDim2.new(1, -4, 0, Image.Height)
            Groupbox:Resize()
        end

        function Image:SetImage(NewImage: string)
            assert(typeof(NewImage) == "string", "Image must be a string.")

            local Icon = Library:GetCustomIcon(NewImage)
            assert(Icon, "Image must be a valid Roblox asset or a valid URL or a valid lucide icon.")

            NewImage = Icon.Url
            Image.RectOffset = Icon.ImageRectOffset
            Image.RectSize = Icon.ImageRectSize

            ImageLabel.Image = NewImage
            Image.Image = NewImage
        end

        function Image:SetColor(Color: Color3)
            assert(typeof(Color) == "Color3", "Color must be a Color3 value.")

            ImageLabel.ImageColor3 = Color
            Image.Color = Color
        end

        function Image:SetRectOffset(RectOffset: Vector2)
            assert(typeof(RectOffset) == "Vector2", "RectOffset must be a Vector2 value.")

            ImageLabel.ImageRectOffset = RectOffset
            Image.RectOffset = RectOffset
        end

        function Image:SetRectSize(RectSize: Vector2)
            assert(typeof(RectSize) == "Vector2", "RectSize must be a Vector2 value.")

            ImageLabel.ImageRectSize = RectSize
            Image.RectSize = RectSize
        end

        function Image:SetScaleType(ScaleType: Enum.ScaleType)
            assert(
                typeof(ScaleType) == "EnumItem" and ScaleType:IsA("ScaleType"),
                "ScaleType must be a valid Enum.ScaleType."
            )

            ImageLabel.ScaleType = ScaleType
            Image.ScaleType = ScaleType
        end

        function Image:SetTransparency(Transparency: number)
            assert(typeof(Transparency) == "number", "Transparency must be a number between 0 and 1.")
            assert(Transparency >= 0 and Transparency <= 1, "Transparency must be between 0 and 1.")

            ImageLabel.ImageTransparency = Transparency
            Image.Transparency = Transparency
        end

        function Image:SetVisible(Visible: boolean)
            Image.Visible = Visible

            Holder.Visible = Image.Visible
            if Blank then Blank.Visible = Image.Visible end

            Groupbox:Resize()
        end

        Image:SetHeight(Image.Height)

        Blank = Groupbox:AddBlank(10, Image.Visible)
        Groupbox:Resize()

        Image.Holder = Holder
        Image.Container = Container

        table.insert(Groupbox.Elements, Image)
        Options[Idx] = Image

        Library:UpdateDependencyBoxes()
        Library:UpdateDependencyGroupboxes()

        return Image
    end

    function BaseGroupboxFuncs:AddVideo(Idx, Info)
        Info = Library:Validate(Info, Templates.Video)

        local Blank = nil
        local Groupbox = self
        local Container = Groupbox.Container

        local Video = {
            Video = Info.Video,
            Looped = Info.Looped,
            Playing = Info.Playing,
            Volume = Info.Volume,
            Height = Info.Height,
            Visible = Info.Visible,

            Type = "Video",
        }

        local Holder = Library:Create("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -4, 0, Info.Height),
            Visible = Video.Visible,
            Parent = Container,
        })

        local Box = Library:Create("Frame", {
            BackgroundColor3 = Library.MainColor,
            BorderColor3 = Library.OutlineColor,
            BorderSizePixel = 1,
            BorderMode = Enum.BorderMode.Inset,
            Size = UDim2.fromScale(1, 1),
            ZIndex = 6,
            Parent = Holder,
        })

        Library:AddToRegistry(Box, {
            BackgroundColor3 = "MainColor";
            BorderColor3 = "OutlineColor";
        })

        Library:Create("UIPadding", {
            PaddingBottom = UDim.new(0, 3),
            PaddingLeft = UDim.new(0, 8),
            PaddingRight = UDim.new(0, 8),
            PaddingTop = UDim.new(0, 4),
            Parent = Box,
        })

        local VideoFrameInstance = Library:Create("VideoFrame", {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1),
            Video = Video.Video,
            Looped = Video.Looped,
            Volume = Video.Volume,
            ZIndex = 7,
            Parent = Box,
        })

        VideoFrameInstance.Playing = Video.Playing

        function Video:SetHeight(Height: number)
            assert(Height > 0, "Height must be greater than 0.")

            Video.Height = Height
            Holder.Size = UDim2.new(1, -4, 0, Height)
            Groupbox:Resize()
        end

        function Video:SetVideo(NewVideo: string)
            assert(typeof(NewVideo) == "string", "Video must be a string.")

            VideoFrameInstance.Video = NewVideo
            Video.Video = NewVideo
        end

        function Video:SetLooped(Looped: boolean)
            assert(typeof(Looped) == "boolean", "Looped must be a boolean.")

            VideoFrameInstance.Looped = Looped
            Video.Looped = Looped
        end

        function Video:SetVolume(Volume: number)
            assert(typeof(Volume) == "number", "Volume must be a number between 0 and 10.")

            VideoFrameInstance.Volume = Volume
            Video.Volume = Volume
        end

        function Video:SetPlaying(Playing: boolean)
            assert(typeof(Playing) == "boolean", "Playing must be a boolean.")

            VideoFrameInstance.Playing = Playing
            Video.Playing = Playing
        end

        function Video:Play()
            VideoFrameInstance.Playing = true
            Video.Playing = true
        end

        function Video:Pause()
            VideoFrameInstance.Playing = false
            Video.Playing = false
        end

        function Video:SetVisible(Visible: boolean)
            Video.Visible = Visible

            Holder.Visible = Video.Visible
            if Blank then Blank.Visible = Video.Visible end

            Groupbox:Resize()
        end

        Video:SetHeight(Video.Height)

        Blank = Groupbox:AddBlank(10, Video.Visible)
        Groupbox:Resize()

        Video.Holder = Holder
        Video.Container = Container
        Video.VideoFrame = VideoFrameInstance

        table.insert(Groupbox.Elements, Video)
        Options[Idx] = Video

        Library:UpdateDependencyBoxes()
        Library:UpdateDependencyGroupboxes()

        return Video
    end

    function BaseGroupboxFuncs:AddUIPassthrough(Idx, Info)
        Info = Library:Validate(Info, Templates.UIPassthrough)

        local Blank = nil
        local Groupbox = self
        local Container = Groupbox.Container

        assert(Info.Instance, "Instance must be provided.")
        assert(
            typeof(Info.Instance) == "Instance" and Info.Instance:IsA("GuiBase2d"),
            "Instance must inherit from GuiBase2d."
        )
        assert(typeof(Info.Height) == "number" and Info.Height > 0, "Height must be a number greater than 0.")

        local Passthrough = {
            Instance = Info.Instance,
            Height = Info.Height,
            Visible = Info.Visible,

            Type = "UIPassthrough",
        }

        local Holder = Library:Create("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -4, 0, Info.Height),
            Visible = Passthrough.Visible,
            Parent = Container,
        })

        Passthrough.Instance.Parent = Holder
        pcall(function() Passthrough.Instance.ZIndex = 7 end)

        function Passthrough:SetHeight(Height: number)
            assert(typeof(Height) == "number" and Height > 0, "Height must be a number greater than 0.")

            Passthrough.Height = Height
            Holder.Size = UDim2.new(1, -4, 0, Height)
            Groupbox:Resize()
        end

        function Passthrough:SetInstance(Instance: Instance)
            assert(Instance, "Instance must be provided.")
            assert(
                typeof(Instance) == "Instance" and Instance:IsA("GuiBase2d"),
                "Instance must inherit from GuiBase2d."
            )

            if Passthrough.Instance then
                Passthrough.Instance.Parent = nil
            end

            Passthrough.Instance = Instance
            Passthrough.Instance.Parent = Holder
            pcall(function() Passthrough.Instance.ZIndex = 7 end)
        end

        function Passthrough:SetVisible(Visible: boolean)
            Passthrough.Visible = Visible

            Holder.Visible = Passthrough.Visible
            if Blank then Blank.Visible = Passthrough.Visible end

            Groupbox:Resize()
        end

        Passthrough:SetHeight(Passthrough.Height)

        Blank = Groupbox:AddBlank(10, Passthrough.Visible)
        Groupbox:Resize()

        Passthrough.Holder = Holder
        Passthrough.Container = Container

        table.insert(Groupbox.Elements, Passthrough)
        Options[Idx] = Passthrough

        Library:UpdateDependencyBoxes()
        Library:UpdateDependencyGroupboxes()

        return Passthrough
    end

    function BaseGroupboxFuncs:AddDependencyBox()
        local Depbox = {
            Elements = {};
            Dependencies = {};
            TableType = "DepBox";
        }

        local Groupbox = self
        local Container = Groupbox.Container

        local Holder = Library:Create("Frame", {
            BackgroundTransparency = 1;
            Size = UDim2.new(1, 0, 0, 0);
            Visible = false;
            Parent = Container;
        })

        local Frame = Library:Create("Frame", {
            BackgroundTransparency = 1;
            Size = UDim2.new(1, 0, 1, 0);
            Visible = true;
            Parent = Holder;
        })

        local Layout = Library:Create("UIListLayout", {
            FillDirection = Enum.FillDirection.Vertical;
            SortOrder = Enum.SortOrder.LayoutOrder;
            Parent = Frame;
        })

        function Depbox:Resize()
            Holder.Size = UDim2.new(1, 0, 0, Layout.AbsoluteContentSize.Y)
            Groupbox:Resize()
        end

        Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Depbox:Resize()
        end)

        Holder:GetPropertyChangedSignal("Visible"):Connect(function()
            Depbox:Resize()
        end)

        function Depbox:Update()
            for _, Dependency in next, Depbox.Dependencies do
                local Elem = Dependency[1]
                local Value = Dependency[2]

                if if Elem.Multi then not table.find(Elem:GetActiveValues(), Value) else Elem.Value ~= Value then
                    Holder.Visible = false
                    Depbox:Resize()
                    return
                end
            end

            Holder.Visible = true
            Depbox:Resize()
        end

        function Depbox:SetupDependencies(Dependencies)
            for _, Dependency in next, Dependencies do
                assert(typeof(Dependency) == "table", "SetupDependencies: Dependency is not of type `table`.")
                assert(Dependency[1], "SetupDependencies: Dependency is missing element argument.")
                assert(Dependency[2] ~= nil, "SetupDependencies: Dependency is missing value argument.")
            end

            Depbox.Dependencies = Dependencies
            Depbox:Update()
        end

        Depbox.Container = Frame

        setmetatable(Depbox, BaseGroupbox)

        table.insert(Groupbox.Elements, Depbox)
        table.insert(Library.DependencyBoxes, Depbox)

        return Depbox
    end

    function BaseGroupboxFuncs:AddDependencyGroupbox()
        local ParentGroupbox = self
        local Tab = ParentGroupbox.Tab

        local DepGroupbox = {
            Elements = {};
            Dependencies = {};
            TableType = "DepGroupbox";
        }

        local BoxOuter = Library:Create("Frame", {
            BackgroundColor3 = Library.BackgroundColor;
            BorderColor3 = Library.OutlineColor;
            BorderMode = Enum.BorderMode.Inset;
            Size = UDim2.new(1, 0, 0, 507 + 2);
            ZIndex = 2;
            Parent = ParentGroupbox.Side == 1 and Tab.LeftSideFrame or Tab.RightSideFrame;
        })

        Library:AddToRegistry(BoxOuter, {
            BackgroundColor3 = "BackgroundColor";
            BorderColor3 = "OutlineColor";
        })

        local BoxInner = Library:Create("Frame", {
            BackgroundColor3 = Library.BackgroundColor;
            BorderColor3 = Color3.new(0, 0, 0);
            -- BorderMode = Enum.BorderMode.Inset;
            Size = UDim2.new(1, -2, 1, -2);
            Position = UDim2.new(0, 1, 0, 1);
            ZIndex = 4;
            Parent = BoxOuter;
        })

        Library:AddToRegistry(BoxInner, {
            BackgroundColor3 = "BackgroundColor";
        })

        local Highlight = Library:Create("Frame", {
            BackgroundColor3 = Library.AccentColor;
            BorderSizePixel = 0;
            Size = UDim2.new(1, 0, 0, 2);
            ZIndex = 5;
            Parent = BoxInner;
        })

        Library:AddToRegistry(Highlight, {
            BackgroundColor3 = "AccentColor";
        })

        local Container = Library:Create("Frame", {
            BackgroundTransparency = 1;
            Position = UDim2.new(0, 4, 0, 10);
            Size = UDim2.new(1, -4, 1, -10);
            ZIndex = 1;
            Parent = BoxInner;
        })

        Library:Create("UIListLayout", {
            FillDirection = Enum.FillDirection.Vertical;
            SortOrder = Enum.SortOrder.LayoutOrder;
            Parent = Container;
        })

        function DepGroupbox:Resize()
            local Size = 0

            for _, Element in next, DepGroupbox.Container:GetChildren() do
                if (not Element:IsA("UIListLayout")) and Element.Visible then
                    Size = Size + Element.Size.Y.Offset
                end
            end

            BoxOuter.Size = UDim2.new(1, 0, 0, (10 * DPIScale + Size) + 2 + 2)
        end

        function DepGroupbox:Update()
            for _, Dependency in next, DepGroupbox.Dependencies do
                local Elem = Dependency[1]
                local Value = Dependency[2]

                if if Elem.Multi then not table.find(Elem:GetActiveValues(), Value) else Elem.Value ~= Value then
                    BoxOuter.Visible = false
                    DepGroupbox:Resize()
                    return
                end
            end

            BoxOuter.Visible = true
            DepGroupbox:Resize()
        end

        function DepGroupbox:SetupDependencies(Dependencies)
            for _, Dependency in pairs(Dependencies) do
                assert(typeof(Dependency) == "table", "Dependency should be a table.")
                assert(Dependency[1] ~= nil, "Dependency is missing element.")
                assert(Dependency[2] ~= nil, "Dependency is missing expected value.")
            end

            DepGroupbox.Dependencies = Dependencies
            DepGroupbox:Update()
        end

        DepGroupbox.Container = Container
        setmetatable(DepGroupbox, BaseGroupbox)

        DepGroupbox:Resize()

        table.insert(Tab.DependencyGroupboxes, DepGroupbox)
        table.insert(Library.DependencyGroupboxes, DepGroupbox)

        return DepGroupbox
    end

    BaseGroupbox.__index = BaseGroupboxFuncs
    BaseGroupbox.__namecall = function(Table, Key, ...)
        return BaseGroupboxFuncs[Key](...)
    end
end

--// Keybinds UI \\--
do
    local KeybindOuter = Library:Create("Frame", {
        AnchorPoint = Vector2.new(0, 0.5);
        BorderColor3 = Color3.new(0, 0, 0);
        Position = UDim2.new(0, 10, 0.5, 0);
        Size = UDim2.new(0, 210, 0, 20);
        Visible = false;
        ZIndex = 100;
        Parent = ScreenGui;
    })

    local KeybindInner = Library:Create("Frame", {
        BackgroundColor3 = Library.MainColor;
        BorderColor3 = Library.OutlineColor;
        BorderMode = Enum.BorderMode.Inset;
        Size = UDim2.new(1, 0, 1, 0);
        ZIndex = 101;
        Parent = KeybindOuter;
    })

    Library:AddToRegistry(KeybindInner, {
        BackgroundColor3 = "MainColor";
        BorderColor3 = "OutlineColor";
    }, true)

    local ColorFrame = Library:Create("Frame", {
        BackgroundColor3 = Library.AccentColor;
        BorderSizePixel = 0;
        Size = UDim2.new(1, 0, 0, 2);
        ZIndex = 102;
        Parent = KeybindInner;
    })

    Library:AddToRegistry(ColorFrame, {
        BackgroundColor3 = "AccentColor";
    }, true)

    local _KeybindLabel = Library:CreateLabel({
        Size = UDim2.new(1, 0, 0, 20);
        Position = UDim2.fromOffset(5, 2),
        TextXAlignment = Enum.TextXAlignment.Left,

        Text = "Keybinds";
        ZIndex = 104;
        Parent = KeybindInner;
    })
    Library:MakeDraggable(KeybindOuter)

    local KeybindContainer = Library:Create("Frame", {
        BackgroundTransparency = 1;
        Size = UDim2.new(1, 0, 1, -20);
        Position = UDim2.new(0, 0, 0, 20);
        ZIndex = 1;
        Parent = KeybindInner;
    })

    Library:Create("UIListLayout", {
        FillDirection = Enum.FillDirection.Vertical;
        SortOrder = Enum.SortOrder.LayoutOrder;
        Parent = KeybindContainer;
    })

    Library:Create("UIPadding", {
        PaddingLeft = UDim.new(0, 5),
        Parent = KeybindContainer,
    })

    Library.KeybindFrame = KeybindOuter
    Library.KeybindContainer = KeybindContainer
    Library:MakeDraggable(KeybindOuter)
end

--// Watermark \\--
do
    local WatermarkOuter = Library:Create("Frame", {
        BorderColor3 = Color3.new(0, 0, 0);
        Position = UDim2.new(0, 100, 0, -25);
        Size = UDim2.new(0, 213, 0, 20);
        ZIndex = 200;
        Visible = false;
        Parent = ScreenGui;
    })

    local WatermarkInner = Library:Create("Frame", {
        BackgroundColor3 = Library.MainColor;
        BorderColor3 = Library.AccentColor;
        BorderMode = Enum.BorderMode.Inset;
        Size = UDim2.new(1, 0, 1, 0);
        ZIndex = 201;
        Parent = WatermarkOuter;
    })

    Library:AddToRegistry(WatermarkInner, {
        BorderColor3 = "AccentColor";
    })

    local InnerFrame = Library:Create("Frame", {
        BackgroundColor3 = Color3.new(1, 1, 1);
        BorderSizePixel = 0;
        Position = UDim2.new(0, 1, 0, 1);
        Size = UDim2.new(1, -2, 1, -2);
        ZIndex = 202;
        Parent = WatermarkInner;
    })

    local Gradient = Library:Create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Library:GetDarkerColor(Library.MainColor)),
            ColorSequenceKeypoint.new(1, Library.MainColor),
        });
        Rotation = -90;
        Parent = InnerFrame;
    })

    Library:AddToRegistry(Gradient, {
        Color = function()
            return ColorSequence.new({
                ColorSequenceKeypoint.new(0, Library:GetDarkerColor(Library.MainColor)),
                ColorSequenceKeypoint.new(1, Library.MainColor),
            })
        end
    })

    local WatermarkLabel = Library:CreateLabel({
        Position = UDim2.new(0, 5, 0, 0);
        Size = UDim2.new(1, -4, 1, 0);
        TextSize = 14;
        TextXAlignment = Enum.TextXAlignment.Left;
        ZIndex = 203;
        Parent = InnerFrame;
    })

    Library.Watermark = WatermarkOuter
    Library.WatermarkText = WatermarkLabel
    Library:MakeDraggable(Library.Watermark)

    function Library:SetWatermarkVisibility(Bool)
        Library.Watermark.Visible = Bool
    end

    function Library:SetWatermark(Text)
        local X, Y = Library:GetTextBounds(Text, Library.Font, 14)
        Library.Watermark.Size = UDim2.new(0, X + 15, 0, (Y * 1.5) + 3)
        Library:SetWatermarkVisibility(true)

        Library.WatermarkText.Text = Text
    end
end

--// Notifications \\--
do
    Library.LeftNotificationArea = Library:Create("Frame", {
        BackgroundTransparency = 1;
        Position = UDim2.new(0, 0, 0, 40);
        Size = UDim2.new(0, 300, 0, 200);
        ZIndex = 11000;
        Parent = ScreenGui;
    })

    Library:Create("UIListLayout", {
        Padding = UDim.new(0, 4);
        FillDirection = Enum.FillDirection.Vertical;
        SortOrder = Enum.SortOrder.LayoutOrder;
        Parent = Library.LeftNotificationArea;
    })


    Library.RightNotificationArea = Library:Create("Frame", {
        AnchorPoint = Vector2.new(1, 0);
        BackgroundTransparency = 1;
        Position = UDim2.new(1, 0, 0, 40);
        Size = UDim2.new(0, 300, 0, 200);
        ZIndex = 11000;
        Parent = ScreenGui;
    })

    Library:Create("UIListLayout", {
        Padding = UDim.new(0, 4);
        FillDirection = Enum.FillDirection.Vertical;
        HorizontalAlignment = Enum.HorizontalAlignment.Right;
        SortOrder = Enum.SortOrder.LayoutOrder;
        Parent = Library.RightNotificationArea;
    })
        
    function Library:SetNotifySide(Side: string)
        Library.NotifySide = Side
    end

    function Library:Notify(...)
        local Data = {}
        local Info = select(1, ...)

        if typeof(Info) == "table" then
            Data.Title = Info.Title and tostring(Info.Title) or ""
            Data.Description = tostring(Info.Description)
            Data.Time = Info.Time or 5
            Data.SoundId = Info.SoundId
            Data.Steps = Info.Steps
            Data.Persist = Info.Persist
            Data.Icon = Info.Icon
            Data.IconColor = Info.IconColor
        else
            Data.Title = ""
            Data.Description = tostring(Info)
            Data.Time = select(2, ...) or 5
            Data.SoundId = select(3, ...)
        end
        Data.Destroyed = false

        local DeletedInstance = false
        local DeleteConnection = nil
        if typeof(Data.Time) == "Instance" then
            DeleteConnection = Data.Time.Destroying:Connect(function()
                DeletedInstance = true
                DeleteConnection:Disconnect()
                DeleteConnection = nil
            end)
        end

        local Side = string.lower(Library.NotifySide)
        local XSize, YSize = Library:GetTextBounds(Data.Description, Library.Font, 14)
        YSize = YSize + 7

        local NotifyOuter = Library:Create("Frame", {
            BorderColor3 = Color3.new(0, 0, 0);
            Size = UDim2.new(0, 0, 0, YSize);
            ClipsDescendants = true;
            ZIndex = 11000;
            Visible = false;
            Name = "Notif";
            Parent = Side == "left" and Library.LeftNotificationArea or Library.RightNotificationArea;
        })

        local NotifyInner = Library:Create("Frame", {
            BackgroundColor3 = Library.MainColor;
            BorderColor3 = Library.OutlineColor;
            BorderMode = Enum.BorderMode.Inset;
            Size = UDim2.new(1, 0, 1, 0);
            ZIndex = 11001;
            Parent = NotifyOuter;
        })

        Library:AddToRegistry(NotifyInner, {
            BackgroundColor3 = "MainColor";
            BorderColor3 = "OutlineColor";
        }, true)

        local InnerFrame = Library:Create("Frame", {
            BackgroundColor3 = Color3.new(1, 1, 1);
            BorderSizePixel = 0;
            Position = UDim2.new(0, 1, 0, 1);
            Size = UDim2.new(1, -2, 1, -2);
            ZIndex = 11002;
            Parent = NotifyInner;
        })

        local Gradient = Library:Create("UIGradient", {
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Library:GetDarkerColor(Library.MainColor)),
                ColorSequenceKeypoint.new(1, Library.MainColor),
            });
            Rotation = -90;
            Parent = InnerFrame;
        })

        Library:AddToRegistry(Gradient, {
            Color = function()
                return ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Library:GetDarkerColor(Library.MainColor)),
                    ColorSequenceKeypoint.new(1, Library.MainColor),
                })
            end
        })

        local ExtraWidth = 0
        local TextPosition = Side == "left" and UDim2.new(0, 4, 0, 0) or UDim2.new(1, -4, 0, 0)
        local TextSizeOffsetX = -4
        local TextSizeOffsetY = 0

        local IconLabel
        if Data.Icon then
            local ParsedIcon = Library:GetCustomIcon(Data.Icon)
            if ParsedIcon then
                ExtraWidth = ExtraWidth + 20
                TextSizeOffsetX = TextSizeOffsetX - 20
                TextSizeOffsetY = TextSizeOffsetY - 2

                if Side == "left" then
                    TextPosition = UDim2.new(0, 24, 0, 0)
                end

                IconLabel = Library:Create("ImageLabel", {
                    BackgroundTransparency = 1,
                    AnchorPoint = Vector2.new(0, 0.5),
                    Position = if Side == "left" then UDim2.new(0, 6, 0.5, 0) else UDim2.new(0, 4, 0.5, 0),
                    Size = UDim2.fromOffset(14, 14),
                    Image = ParsedIcon.Url,
                    ImageColor3 = Data.IconColor or Library.FontColor,
                    ImageRectOffset = ParsedIcon.ImageRectOffset,
                    ImageRectSize = ParsedIcon.ImageRectSize,
                    ZIndex = 11004,
                    Parent = InnerFrame,
                })
                
                if not Data.IconColor then
                    Library:AddToRegistry(IconLabel, {
                        ImageColor3 = "FontColor";
                    }, true)
                end
                
                if Side == "right" then
                    TextPosition = UDim2.new(1, -8, 0, 0)
                end
            end
        end

        local NotifyLabel = Library:CreateLabel({
            AnchorPoint = Side == "left" and Vector2.new(0, 0) or Vector2.new(1, 0);
            Position = TextPosition;
            Size = UDim2.new(1, TextSizeOffsetX, 1, TextSizeOffsetY);
            Text = (Data.Title == "" and "" or "[" .. Data.Title .. "] ") .. tostring(Data.Description);
            TextXAlignment = Side == "left" and Enum.TextXAlignment.Left or Enum.TextXAlignment.Right;
            TextSize = 14;
            ZIndex = 11003;
            RichText = true;
            Parent = InnerFrame;
        })

        local SideColor = Library:Create("Frame", {
            AnchorPoint = Side == "left" and Vector2.new(0, 0) or Vector2.new(1, 0);
            Position = Side == "left" and UDim2.new(0, -1, 0, -1) or UDim2.new(1, -1, 0, -1);
            BackgroundColor3 = Library.AccentColor;
            BorderSizePixel = 0;
            Size = UDim2.new(0, 3, 1, 2);
            ZIndex = 11004;
            Parent = NotifyOuter;
        })

        Library:AddToRegistry(SideColor, {
            BackgroundColor3 = "AccentColor";
        }, true)

        function Data:Resize()
            XSize, YSize = Library:GetTextBounds(NotifyLabel.Text, Library.Font, 14)
            YSize = YSize + 7
            
            pcall(NotifyOuter.TweenSize, NotifyOuter, UDim2.new(0, XSize * DPIScale + 8 + 4 + ExtraWidth, 0, YSize), "Out", "Quad", 0.4, true)
        end

        function Data:ChangeTitle(NewText)
            NewText = NewText == nil and "" or tostring(NewText)
            Data.Title = NewText
            NotifyLabel.Text = (Data.Title == "" and "" or "[" .. Data.Title .. "] ") .. tostring(Data.Description)
            Data:Resize()
        end

        function Data:ChangeDescription(NewText)
            if NewText == nil then return end
            NewText = tostring(NewText)
            Data.Description = NewText
            NotifyLabel.Text = (Data.Title == "" and "" or "[" .. Data.Title .. "] ") .. tostring(Data.Description)
            Data:Resize()
        end

        function Data:ChangeStep(...)
        end

        function Data:Destroy()
            Data.Destroyed = true

            if typeof(Data.Time) == "Instance" then
                pcall(Data.Time.Destroy, Data.Time)
            end
            
            if DeleteConnection then
                DeleteConnection:Disconnect()
            end

            pcall(NotifyOuter.TweenSize, NotifyOuter, UDim2.new(0, 0, 0, YSize), "Out", "Quad", 0.4, true)
            task.wait(0.4)
            NotifyOuter:Destroy()
        end

        Data:Resize()

        if Data.SoundId then
            Library:Create("Sound", {
                SoundId = "rbxassetid://" .. tostring(Data.SoundId):gsub("rbxassetid://", "");
                Volume = 3;
                PlayOnRemove = true;
                Parent = game:GetService("SoundService");
            }):Destroy()
        end

        NotifyOuter.Visible = true
        pcall(NotifyOuter.TweenSize, NotifyOuter, UDim2.new(0, XSize * DPIScale + 8 + 4 + ExtraWidth, 0, YSize), "Out", "Quad", 0.4, true)

        task.delay(0.4, function()
            if Data.Persist then
                return
            elseif typeof(Data.Time) == "Instance" then
                repeat
                    task.wait()
                until DeletedInstance or Data.Destroyed
            else
                task.wait(Data.Time or 5)
            end

            if not Data.Destroyed then
                Data:Destroy()
            end
        end)

        return Data
    end
end

--// Window \\--
function Library:CreateWindow(...)
    local Arguments = { ... }
    local WindowInfo = Templates.Window

    if typeof(Arguments[1]) == "table" then
        WindowInfo = Library:Validate(Arguments[1], Templates.Window)
    else
        WindowInfo = Library:Validate({
            Title = Arguments[1],
            AutoShow = Arguments[2] or false
        }, Templates.Window)
    end

    local ViewportSize: Vector2 = workspace.CurrentCamera.ViewportSize
    if RunService:IsStudio() and ViewportSize.X <= 5 and ViewportSize.Y <= 5 then
        repeat
            ViewportSize = workspace.CurrentCamera.ViewportSize
            task.wait()
        until ViewportSize.X > 5 and ViewportSize.Y > 5
    end

    if WindowInfo.Size == UDim2.fromOffset(0, 0) then
        WindowInfo.Size = if Library.IsMobile then UDim2.fromOffset(550, math.clamp(ViewportSize.Y - 35, 200, 600)) else UDim2.fromOffset(550, 600)
    end

    Library.NotifySide = WindowInfo.NotifySide
    Library.ShowCustomCursor = WindowInfo.ShowCustomCursor

    if WindowInfo.TabPadding <= 0 then WindowInfo.TabPadding = 1 end
    if WindowInfo.Center then WindowInfo.Position = UDim2.new(0.5, -WindowInfo.Size.X.Offset / 2, 0.5, -WindowInfo.Size.Y.Offset / 2) end

    local Window = {
        Tabs = {};

        OriginalTitle = WindowInfo.Title; 
        Title = WindowInfo.Title;
    }

    local Outer = Library:Create("Frame", {
        AnchorPoint = WindowInfo.AnchorPoint;
        BackgroundColor3 = Color3.new(0, 0, 0);
        BorderSizePixel = 0;
        Position = WindowInfo.Position;
        Size = WindowInfo.Size;
        Visible = false;
        ZIndex = 1;
        Parent = ScreenGui;
        Name = "Window";
    })
    LibraryMainOuterFrame = Outer
    Library:MakeDraggable(Outer, 25, true)
    if WindowInfo.Resizable then Library:MakeResizable(Outer, Library.MinSize) end

    local Inner = Library:Create("Frame", {
        BackgroundColor3 = Library.MainColor;
        BorderColor3 = Library.AccentColor;
        BorderMode = Enum.BorderMode.Inset;
        Position = UDim2.new(0, 1, 0, 1);
        Size = UDim2.new(1, -2, 1, -2);
        ZIndex = 1;
        Parent = Outer;
    })

    Library:AddToRegistry(Inner, {
        BackgroundColor3 = "MainColor";
        BorderColor3 = "AccentColor";
    })

    local WindowLabel = Library:CreateLabel({
        Position = UDim2.new(0, 7, 0, 0);
        Size = UDim2.new(0, 0, 0, 25);
        Text = WindowInfo.Title or "";
        TextXAlignment = Enum.TextXAlignment.Left;
        ZIndex = 1;
        Parent = Inner;
    })

    local MainSectionOuter = Library:Create("Frame", {
        BackgroundColor3 = Library.BackgroundColor;
        BorderColor3 = Library.OutlineColor;
        Position = UDim2.new(0, 8, 0, 25);
        Size = UDim2.new(1, -16, 1, -33);
        ZIndex = 1;
        Parent = Inner;
    })

    Library:AddToRegistry(MainSectionOuter, {
        BackgroundColor3 = "BackgroundColor";
        BorderColor3 = "OutlineColor";
    })

    local MainSectionInner = Library:Create("Frame", {
        BackgroundColor3 = Library.BackgroundColor;
        BorderColor3 = Color3.new(0, 0, 0);
        BorderMode = Enum.BorderMode.Inset;
        Position = UDim2.new(0, 0, 0, 0);
        Size = UDim2.new(1, 0, 1, 0);
        ZIndex = 1;
        Parent = MainSectionOuter;
    })

    Library:AddToRegistry(MainSectionInner, {
        BackgroundColor3 = "BackgroundColor";
    })

    local TabArea = Library:Create("ScrollingFrame", {
        ScrollingDirection = Enum.ScrollingDirection.X;
        CanvasSize = UDim2.new(0, 0, 2, 0);
        HorizontalScrollBarInset = Enum.ScrollBarInset.Always;
        AutomaticCanvasSize = Enum.AutomaticSize.XY;
        ScrollBarThickness = 0;
        BackgroundTransparency = 1;
        Position = UDim2.new(0, 8 - WindowInfo.TabPadding, 0, 4);
        Size = UDim2.new(1, -10, 0, 26);
        ZIndex = 1;
        Parent = MainSectionInner;
    })

    local TabListLayout = Library:Create("UIListLayout", {
        Padding = UDim.new(0, WindowInfo.TabPadding);
        FillDirection = Enum.FillDirection.Horizontal;
        SortOrder = Enum.SortOrder.LayoutOrder;
        VerticalAlignment = Enum.VerticalAlignment.Center;
        Parent = TabArea;
    })

    Library:Create("Frame", {
        BackgroundColor3 = Library.BackgroundColor;
        BorderColor3 = Library.OutlineColor;
        Size = UDim2.new(0, 0, 0, 0);
        LayoutOrder = -1;
        BackgroundTransparency = 1;
        ZIndex = 1;
        Parent = TabArea;
    })
    Library:Create("Frame", {
        BackgroundColor3 = Library.BackgroundColor;
        BorderColor3 = Library.OutlineColor;
        Size = UDim2.new(0, 0, 0, 0);
        LayoutOrder = 9999999;
        BackgroundTransparency = 1;
        ZIndex = 1;
        Parent = TabArea;
    })

    local TabContainer = Library:Create("Frame", {
        BackgroundColor3 = Library.MainColor;
        BorderColor3 = Library.OutlineColor;
        Position = UDim2.new(0, 8, 0, 30);
        Size = UDim2.new(1, -16, 1, -38);
        ZIndex = 2;
        Parent = MainSectionInner;
    })
    
    local InnerVideoBackground = Library:Create("VideoFrame", {
        BackgroundColor3 = Library.MainColor;
        BorderMode = Enum.BorderMode.Inset;
        BorderSizePixel = 0;
        Position = UDim2.new(0, 1, 0, 1);
        Size = UDim2.new(1, -2, 1, -2);
        ZIndex = 2;
        Visible = false;
        Volume = 0;
        Looped = true;
        Parent = TabContainer;
    })
    Library.InnerVideoBackground = InnerVideoBackground

    local BackgroundImage = Library:Create("ImageLabel", {
        Image = "";
        Position = UDim2.fromScale(0, 0);
        Size = UDim2.fromScale(1, 1);
        ScaleType = Enum.ScaleType.Stretch;
        ZIndex = 2;
        BackgroundTransparency = 1;
        ImageTransparency = 0.75;
        Parent = TabContainer;
        Visible = false;
    })

    Library:AddToRegistry(TabContainer, {
        BackgroundColor3 = "MainColor";
        BorderColor3 = "OutlineColor";
    })

    function Window:SetWindowTitle(Title)
        if typeof(Title) == "string" then
            Window.Title = Title
            WindowLabel.Text = Window.Title
        end
    end

    function Window:SetBackgroundImage(NewImage)
        if tonumber(NewImage) then
            NewImage = "rbxassetid://" .. NewImage
        end

        assert(typeof(NewImage) == "string", "Image must be a string.")

        local Icon = Library:GetCustomIcon(NewImage)
        if not Icon then
            BackgroundImage.Visible = false
            return
        end
        
        assert(Icon, "Image must be a valid Roblox asset or a valid URL or a valid lucide icon.")

        BackgroundImage.Image = Icon.Url
        BackgroundImage.ImageRectOffset = Icon.ImageRectOffset
        BackgroundImage.ImageRectSize = Icon.ImageRectSize

        BackgroundImage.Visible = true
    end

    function Window:AddDialog(Idx, Info)
        assert(Info.Title, "AddDialog: Missing `Title` string.")
        assert(Info.Description, "AddDialog: Missing `Description` string.")

        local DialogFrame
        local DialogOverlay
        local DialogContainer
        local ButtonsHolder
        local FooterButtonsList = {}

        DialogOverlay = Library:Create("TextButton", {
            AutoButtonColor = false,
            BackgroundColor3 = Color3.new(0, 0, 0),
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1),
            Text = "",
            Active = false,
            ZIndex = 9000,
            Visible = true,
            Parent = LibraryMainOuterFrame,
        })
        TweenService:Create(DialogOverlay, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundTransparency = 0.5,
        }):Play()

        DialogFrame = Library:Create("TextButton", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = Library.BackgroundColor,
            BorderColor3 = Color3.new(0, 0, 0),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromOffset(300, 0),
            ZIndex = 9001,
            Visible = true,
            Parent = DialogOverlay,
            AutomaticSize = Enum.AutomaticSize.Y,
            Text = "",
            AutoButtonColor = false,
        })

        local DialogInner = Library:Create("Frame", {
            BackgroundColor3 = Library.MainColor,
            BorderColor3 = Library.AccentColor,
            BorderMode = Enum.BorderMode.Inset,
            Size = UDim2.fromScale(1, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            ZIndex = 9002,
            Parent = DialogFrame,
        })

        Library:AddToRegistry(DialogFrame, {
            BackgroundColor3 = "BackgroundColor",
        })

        Library:AddToRegistry(DialogInner, {
            BackgroundColor3 = "MainColor",
            BorderColor3 = "AccentColor",
        })

        local InnerContainer = Library:Create("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            ZIndex = 9003,
            Parent = DialogInner,
        })
        local DialogScale = Library:Create("UIScale", {
            Scale = 0.95,
            Parent = DialogFrame,
        })
        TweenService:Create(DialogScale, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Scale = 1
        }):Play()

        Library:Create("UIPadding", {
            PaddingBottom = UDim.new(0, 10),
            PaddingLeft = UDim.new(0, 15),
            PaddingRight = UDim.new(0, 15),
            PaddingTop = UDim.new(0, 15),
            Parent = InnerContainer,
        })
        local _InnerListLayout = Library:Create("UIListLayout", {
            Padding = UDim.new(0, 10),
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = InnerContainer,
        })

        local HeaderContainer = Library:Create("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            LayoutOrder = 1,
            ZIndex = 9003,
            Parent = InnerContainer,
        })
        Library:Create("UIListLayout", {
            Padding = UDim.new(0, 6),
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = HeaderContainer,
        })
        Library:Create("UIPadding", {
            PaddingBottom = UDim.new(0, 5),
            Parent = HeaderContainer,
        })

        local TitleRow = Library:Create("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 20),
            AutomaticSize = Enum.AutomaticSize.Y,
            LayoutOrder = 1,
            ZIndex = 9003,
            Parent = HeaderContainer,
        })
        Library:Create("UIListLayout", {
            Padding = UDim.new(0, 6),
            FillDirection = Enum.FillDirection.Horizontal,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = TitleRow,
        })

        local TitleLabel = Library:CreateLabel({
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 18),
            AutomaticSize = Enum.AutomaticSize.Y,
            Text = Info.Title or "Dialog",
            TextSize = 18,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 9003,
            Parent = TitleRow,
            RichText = true,
        })
        if Info.TitleColor then
            TitleLabel.TextColor3 = Info.TitleColor
        else
            Library:AddToRegistry(TitleLabel, { TextColor3 = "FontColor" })
        end

        local DescriptionLabel = Library:CreateLabel({
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 14),
            AutomaticSize = Enum.AutomaticSize.Y,
            Text = Info.Description or "Description",
            TextSize = 14,
            TextTransparency = Info.DescriptionColor and 0 or 0.2,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true,
            ZIndex = 9003,
            LayoutOrder = 2,
            Parent = HeaderContainer,
            RichText = true,
        })
        if Info.DescriptionColor then
            DescriptionLabel.TextColor3 = Info.DescriptionColor
        else
            Library:AddToRegistry(DescriptionLabel, { TextColor3 = "FontColor" })
        end

        DialogContainer = Library:Create("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            LayoutOrder = 4,
            Visible = false,
            ZIndex = 9003,
            Parent = InnerContainer,
        })
        Library:Create("UIListLayout", {
            Padding = UDim.new(0, 1),
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = DialogContainer,
        })
        
        local _Sep2 = Library:Create("Frame", {
            BackgroundColor3 = Library.OutlineColor,
            BackgroundTransparency = 0,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 0, 1),
            LayoutOrder = 5,
            ZIndex = 9003,
            Parent = InnerContainer,
        })
        Library:AddToRegistry(_Sep2, {
            BackgroundColor3 = "OutlineColor",
        })

        ButtonsHolder = Library:Create("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            LayoutOrder = 6,
            ZIndex = 9002,
            Parent = InnerContainer,
        })
        Library:Create("UIListLayout", {
            Padding = UDim.new(0, 8),
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Right,
            Wraps = true,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = ButtonsHolder,
        })
        Library:Create("UIPadding", {
            PaddingTop = UDim.new(0, 0),
            Parent = ButtonsHolder,
        })

        local Dialog = {
            Elements = {},
            Container = DialogContainer,
        }

        function Dialog:Resize()
            local MaxWidth = LibraryMainOuterFrame.AbsoluteSize.X * 0.75
            local MinWidth = 400 * DPIScale

            local TotalButtonWidth = 0
            local ButtonCount = 0
            local HasButtons = false

            for _, BtnWrap in pairs(FooterButtonsList) do
                HasButtons = true
                ButtonCount = ButtonCount + 1
                TotalButtonWidth = TotalButtonWidth + BtnWrap.Container.Size.X.Offset
            end

            local TargetWidth = MinWidth
            if HasButtons then
                local RequiredWidth = TotalButtonWidth + ((ButtonCount - 1) * 8 * DPIScale) + (30 * DPIScale)
                TargetWidth = math.max(MinWidth, math.min(RequiredWidth, MaxWidth))
            end

            local DescY = select(2, Library:GetTextBounds(DescriptionLabel.Text, Library.Font, 14 * DPIScale, TargetWidth - (30 * DPIScale)))
            DescriptionLabel.Size = UDim2.new(1, 0, 0, DescY)

            local HasElements = false
            for _, v in pairs(DialogContainer:GetChildren()) do
                if not v:IsA("UIListLayout") and not v:IsA("UIPadding") then
                    HasElements = true
                    break
                end
            end

            if HasElements then
                for _, v in pairs(DialogContainer:GetDescendants()) do
                    if not v:IsA("GuiObject") then continue end
                    if v:GetAttribute("ZIndexApplied") then continue end
                    
                    v:SetAttribute("ZIndexApplied", true)
                    v.ZIndex = v.ZIndex + 9003
                end
            end

            DialogContainer.Visible = HasElements

            ButtonsHolder.Visible = HasButtons
            _Sep2.Visible = HasButtons

            DialogFrame.Size = UDim2.fromOffset(TargetWidth, 0)
        end

        function Dialog:SetTitle(Title)
            TitleLabel.Text = Title
            Dialog:Resize()
        end

        function Dialog:SetDescription(Description)
            DescriptionLabel.Text = Description
            Dialog:Resize()
        end

        function Dialog:Dismiss()
            TweenService:Create(DialogScale, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Scale = 0.95 }):Play()
            TweenService:Create(DialogOverlay, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundTransparency = 1 }):Play()
            
            task.delay(0.1, function()
                DialogOverlay:Destroy()
            end)

            if Library.Dialogues then Library.Dialogues[Idx] = nil end
            Library.ActiveDialog = nil
        end

        DialogOverlay.MouseButton1Click:Connect(function()
            if Info.OutsideClickDismiss then
                Dialog:Dismiss()
            end
        end)

        function Dialog:RemoveFooterButton(ButtonIdx)
            if FooterButtonsList[ButtonIdx] then
                FooterButtonsList[ButtonIdx].Container:Destroy()
                FooterButtonsList[ButtonIdx] = nil
            end
        end

        function Dialog:SetButtonDisabled(ButtonIdx, Disabled)
            if FooterButtonsList[ButtonIdx] and type(FooterButtonsList[ButtonIdx].SetDisabled) == "function" then
                FooterButtonsList[ButtonIdx]:SetDisabled(Disabled)
            end
        end

        function Dialog:SetButtonOrder(ButtonIdx, Order)
            if FooterButtonsList[ButtonIdx] and FooterButtonsList[ButtonIdx].Container then
                FooterButtonsList[ButtonIdx].Container.LayoutOrder = Order
            end
        end

        function Dialog:AddFooterButton(ButtonIdx, ButtonInfo)
            Dialog:RemoveFooterButton(ButtonIdx)

            local WaitTime = ButtonInfo.WaitTime or 0
            local Variant = ButtonInfo.Variant or "Primary"

            local BtnInnerColor = Library.MainColor
            local BtnBorderColor = Library.OutlineColor
            local DestructiveColor = Color3.fromRGB(220, 38, 38)

            if Variant == "Primary" then
                BtnBorderColor = Library.AccentColor
            elseif Variant == "Secondary" then
                BtnInnerColor = Library.BackgroundColor
                BtnBorderColor = Library.OutlineColor
            elseif Variant == "Destructive" then
                BtnBorderColor = DestructiveColor
            elseif Variant == "Ghost" then
                BtnBorderColor = Library.MainColor
            end

            local LabelX = select(1, Library:GetTextBounds(ButtonInfo.Title or ButtonIdx, Library.Font, 14 * DPIScale))
            local BtnW = LabelX + (24 * DPIScale)
            local BtnH = 20 * DPIScale

            local ButtonContainer = Library:Create("Frame", {
                BackgroundColor3 = Color3.new(0, 0, 0),
                BorderColor3 = Color3.new(0, 0, 0),
                Size = UDim2.fromOffset(BtnW, BtnH),
                LayoutOrder = ButtonInfo.Order or 0,
                ZIndex = 9003,
                Parent = ButtonsHolder,
            })
            Library:AddToRegistry(ButtonContainer, { BorderColor3 = "Black" })

            local TextBtn = Library:Create("TextButton", {
                BackgroundColor3 = BtnInnerColor,
                BorderColor3 = BtnBorderColor,
                BorderMode = Enum.BorderMode.Inset,
                BackgroundTransparency = WaitTime > 0 and 0.5 or 0,
                Size = UDim2.new(1, 0, 1, 0),
                Text = "",
                AutoButtonColor = false,
                ZIndex = 9004,
                Parent = ButtonContainer,
            })

            if Variant == "Primary" then
                Library:AddToRegistry(TextBtn, { BackgroundColor3 = "MainColor", BorderColor3 = "AccentColor" })
            elseif Variant == "Secondary" then
                Library:AddToRegistry(TextBtn, { BackgroundColor3 = "BackgroundColor", BorderColor3 = "OutlineColor" })
            elseif Variant == "Ghost" then
                Library:AddToRegistry(TextBtn, { BackgroundColor3 = "MainColor", BorderColor3 = "MainColor" })
            end

            Library:Create("UIGradient", {
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(212, 212, 212)),
                }),
                Rotation = 90,
                Parent = TextBtn,
            })

            local HighlightBorderColor = Variant == "Destructive" and DestructiveColor or Library.AccentColor
            ButtonContainer.MouseEnter:Connect(function()
                ButtonContainer.BorderColor3 = HighlightBorderColor
            end)
            ButtonContainer.MouseLeave:Connect(function()
                ButtonContainer.BorderColor3 = Color3.new(0, 0, 0)
            end)

            local TextColor = Library.FontColor
            if Variant == "Destructive" then
                TextColor = Color3.new(1, 1, 1)
            end

            local BtnLabel = Library:CreateLabel({
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 1),
                Text = ButtonInfo.Title or ButtonIdx,
                TextColor3 = TextColor,
                TextTransparency = WaitTime > 0 and 0.5 or 0,
                TextSize = 14 * DPIScale,
                ZIndex = 9005,
                Parent = TextBtn,
            })

            if Variant ~= "Destructive" then
                Library:AddToRegistry(BtnLabel, { TextColor3 = "FontColor" })
            end

            local ProgressBar
            if WaitTime > 0 then
                ProgressBar = Library:Create("Frame", {
                    BackgroundColor3 = Library.AccentColor,
                    BorderSizePixel = 0,
                    Position = UDim2.new(0, 0, 1, -2),
                    Size = UDim2.new(0, 0, 0, 2),
                    ZIndex = 2,
                    Parent = TextBtn,
                })
                Library:AddToRegistry(ProgressBar, { BackgroundColor3 = "AccentColor" })
            end

            local IsActive = WaitTime <= 0

            local ButtonWrap = {
                Container = ButtonContainer,
                SetDisabled = function(self, Disabled)
                    IsActive = not Disabled
                    if Disabled then
                        TweenService:Create(TextBtn, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundTransparency = 0.5 }):Play()
                        TweenService:Create(BtnLabel, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { TextTransparency = 0.5 }):Play()
                    else
                        TweenService:Create(TextBtn, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundTransparency = 0 }):Play()
                        TweenService:Create(BtnLabel, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { TextTransparency = 0 }):Play()
                    end
                end
            }

            TextBtn.MouseButton1Click:Connect(function()
                if not IsActive then return end

                if ButtonInfo.Callback then
                    ButtonInfo.Callback(Dialog)
                end

                if Info.AutoDismiss ~= false then
                    Dialog:Dismiss()
                end
            end)

            if WaitTime > 0 then
                TweenService:Create(ProgressBar, TweenInfo.new(WaitTime, Enum.EasingStyle.Linear), {
                    Size = UDim2.new(1, 0, 0, 2)
                }):Play()
                
                task.delay(WaitTime, function()
                    ButtonWrap:SetDisabled(false)

                    if ProgressBar then
                        TweenService:Create(ProgressBar, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                            BackgroundTransparency = 1
                        }):Play()
                    end
                end)
            end

            FooterButtonsList[ButtonIdx] = ButtonWrap
        end

        if Info.FooterButtons then
            for BIdx, BInfo in pairs(Info.FooterButtons) do
                if type(BIdx) == "number" and BInfo.Id then BIdx = BInfo.Id end
                Dialog:AddFooterButton(BIdx, BInfo)
            end
        end

        setmetatable(Dialog, BaseGroupbox)

        Library.Dialogues[Idx] = Dialog
        Library.ActiveDialog = Dialog

        Dialog:Resize()

        return Dialog
    end

    function Window:AddTab(Name)
        local Tab = {
            Groupboxes = {};
            Tabboxes = {};
            DependencyGroupboxes = {};
            WarningBox = {
                Bottom = false,
                IsNormal = false,
                LockSize = false,
                Visible = false,
                Title = "WARNING",
                Text = ""
            };
            OriginalName = Name; 
            Name = Name;
            TableType = "Tab";
        }

        local TabButtonWidth = Library:GetTextBounds(Tab.Name, Library.Font, 16)

        local TabButton = Library:Create("Frame", {
            BackgroundColor3 = Library.BackgroundColor;
            BorderColor3 = Library.OutlineColor;
            Size = UDim2.new(0, TabButtonWidth + 8 + 4, 0.85, 0);
            ZIndex = 1;
            Parent = TabArea;
        })

        Library:AddToRegistry(TabButton, {
            BackgroundColor3 = "BackgroundColor";
            BorderColor3 = "OutlineColor";
        })

        local TabButtonLabel = Library:CreateLabel({
            Position = UDim2.new(0, 0, 0, 0);
            Size = UDim2.new(1, 0, 1, -1);
            Text = Tab.Name;
            ZIndex = 1;
            Parent = TabButton;
        })

        local Blocker = Library:Create("Frame", {
            BackgroundColor3 = Library.MainColor;
            BorderSizePixel = 0;
            Position = UDim2.new(0, 0, 1, 0);
            Size = UDim2.new(1, 0, 0, 1);
            BackgroundTransparency = 1;
            ZIndex = 3;
            Parent = TabButton;
        })

        Library:AddToRegistry(Blocker, {
            BackgroundColor3 = "MainColor";
        })

        local TabFrame = Library:Create("Frame", {
            Name = "TabFrame",
            BackgroundTransparency = 1;
            Position = UDim2.new(0, 0, 0, 0);
            Size = UDim2.new(1, 0, 1, 0);
            Visible = false;
            ZIndex = 2;
            Parent = TabContainer;
        })

        local TopBarLabelStroke
        local TopBarHighlight
        local TopBar, TopBarInner, TopBarLabel, TopBarTextLabel, TopBarScrollingFrame
do
            TopBar = Library:Create("Frame", {
                BackgroundColor3 = Library.BackgroundColor;
                BorderColor3 = Color3.fromRGB(248, 51, 51);
                BorderMode = Enum.BorderMode.Inset;
                Position = UDim2.new(0, 7, 0, 7);
                Size = UDim2.new(1, -13, 0, 0);
                ZIndex = 2;
                Parent = TabFrame;
                Visible = false;
            })

            TopBarInner = Library:Create("Frame", {
                BackgroundColor3 = Color3.fromRGB(117, 22, 17);
                BorderColor3 = Color3.new();
                -- BorderMode = Enum.BorderMode.Inset;
                Size = UDim2.new(1, -2, 1, -2);
                Position = UDim2.new(0, 1, 0, 1);
                ZIndex = 4;
                Parent = TopBar;
            })

            TopBarHighlight = Library:Create("Frame", {
                BackgroundColor3 = Color3.fromRGB(255, 75, 75);
                BorderSizePixel = 0;
                Size = UDim2.new(1, 0, 0, 2);
                ZIndex = 5;
                Parent = TopBarInner;
            })

            TopBarScrollingFrame = Library:Create("ScrollingFrame", {
                BackgroundTransparency = 1;
                BorderSizePixel = 0;
                Size = UDim2.new(1, -8, 1, 0);
                CanvasSize = UDim2.new(0, 0, 0, 0);
                AutomaticCanvasSize = Enum.AutomaticSize.Y;
                ScrollBarThickness = 3;
                ZIndex = 5;
                Parent = TopBarInner;
            })

            TopBarLabel = Library:Create("TextLabel", {
                BackgroundTransparency = 1;
                Font = Library.Font;
                TextStrokeTransparency = 0;
                RichText = true;

                Size = UDim2.new(1, 0, 0, 18);
                Position = UDim2.new(0, 4, 0, 2);
                TextSize = 14;
                Text = "Text";
                TextXAlignment = Enum.TextXAlignment.Left;
                TextColor3 = Color3.fromRGB(255, 55, 55);
                ZIndex = 5;
                Parent = TopBarScrollingFrame;
            })

            TopBarLabelStroke = Library:ApplyTextStroke(TopBarLabel)
            TopBarLabelStroke.Color = Color3.fromRGB(174, 3, 3)

            TopBarTextLabel = Library:CreateLabel({
                RichText = true;
                Position = UDim2.new(0, 4, 0, 20);
                Size = UDim2.new(1, 0, 0, 14);
                TextSize = 14;
                Text = "Text";
                TextWrapped = true,
                TextXAlignment = Enum.TextXAlignment.Left;
                TextYAlignment = Enum.TextYAlignment.Top;
                ZIndex = 5;
                Parent = TopBarScrollingFrame;
            })
            
            Library:Create("Frame", {
                BackgroundTransparency = 1;
                Size = UDim2.new(1, 0, 0, 5);
                Visible = true;
                ZIndex = 1;
                Parent = TopBarInner;
            })
        end
        
        local LeftSide = Library:Create("ScrollingFrame", {
            BackgroundTransparency = 1;
            BorderSizePixel = 0;
            Position = UDim2.new(0, 7, 0, 7);
            Size = UDim2.new(0.5, -10, 1, -14);
            CanvasSize = UDim2.new(0, 0, 0, 0);
            BottomImage = "";
            TopImage = "";
            ScrollBarThickness = 0;
            ZIndex = 2;
            Parent = TabFrame;
        })

        local RightSide = Library:Create("ScrollingFrame", {
            BackgroundTransparency = 1;
            BorderSizePixel = 0;
            Position = UDim2.new(0.5, 5, 0, 7);
            Size = UDim2.new(0.5, -10, 1, -14);
            CanvasSize = UDim2.new(0, 0, 0, 0);
            BottomImage = "";
            TopImage = "";
            ScrollBarThickness = 0;
            ZIndex = 2;
            Parent = TabFrame;
        })

        Tab.LeftSideFrame = LeftSide
        Tab.RightSideFrame = RightSide

        Library:Create("UIListLayout", {
            Padding = UDim.new(0, 8);
            FillDirection = Enum.FillDirection.Vertical;
            SortOrder = Enum.SortOrder.LayoutOrder;
            HorizontalAlignment = Enum.HorizontalAlignment.Center;
            Parent = LeftSide;
        })

        Library:Create("UIListLayout", {
            Padding = UDim.new(0, 8);
            FillDirection = Enum.FillDirection.Vertical;
            SortOrder = Enum.SortOrder.LayoutOrder;
            HorizontalAlignment = Enum.HorizontalAlignment.Center;
            Parent = RightSide;
        })

        if Library.IsMobile then
            local SidesValues = {
                ["Left"] = tick(),
                ["Right"] = tick(),
            }

            LeftSide:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
                Library.CanDrag = false

                local ChangeTick = tick()
                SidesValues.Left = ChangeTick
                task.wait(0.15)

                if SidesValues.Left == ChangeTick then
                    Library.CanDrag = true
                end
            end)

            RightSide:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
                Library.CanDrag = false

                local ChangeTick = tick()
                SidesValues.Right = ChangeTick
                task.wait(0.15)
                
                if SidesValues.Right == ChangeTick then
                    Library.CanDrag = true
                end
            end)
        end

        for _, Side in next, { LeftSide, RightSide } do
            Side:WaitForChild("UIListLayout"):GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                Side.CanvasSize = UDim2.fromOffset(0, Side.UIListLayout.AbsoluteContentSize.Y)
            end)
        end

        function Tab:Resize()
            if TopBar.Visible == true then
                local MaximumSize = math.floor(TabFrame.AbsoluteSize.Y / 3.25)
                local Size = 27 + select(2, Library:GetTextBounds(TopBarTextLabel.Text, Library.Font, 14, Vector2.new(TopBarTextLabel.AbsoluteSize.X, math.huge)))

                if Tab.WarningBox.LockSize == true and Size >= MaximumSize then 
                    Size = MaximumSize
                end

                if Tab.WarningBox.Bottom == true then
                    TopBar.Position = UDim2.new(0, 7, 1, -(Size + 7))
                else
                    TopBar.Position = UDim2.new(0, 7, 0, 7)
                end

                TopBar.Size = UDim2.new(1, -13, 0, Size)
                Size = Size + 10
                
                if TopBar.Position.Y.Offset > 0 then
                    LeftSide.Position = UDim2.new(0, 7, 0, 7 + Size)
                    LeftSide.Size = UDim2.new(0.5, -10, 1, -14 - Size)
            
                    RightSide.Position = UDim2.new(0.5, 5, 0, 7 + Size)
                    RightSide.Size = UDim2.new(0.5, -10, 1, -14 - Size)
                else
                    LeftSide.Position = UDim2.new(0, 7, 0, 7)
                    LeftSide.Size = UDim2.new(0.5, -10, 1, -14 - Size)
            
                    RightSide.Position = UDim2.new(0.5, 5, 0, 7)
                    RightSide.Size = UDim2.new(0.5, -10, 1, -14 - Size)
                end
            else
                LeftSide.Position = UDim2.new(0, 7, 0, 7)
                LeftSide.Size = UDim2.new(0.5, -10, 1, -14)
        
                RightSide.Position = UDim2.new(0.5, 5, 0, 7)
                RightSide.Size = UDim2.new(0.5, -10, 1, -14)
            end
        end

        function Tab:UpdateWarningBox(Info)
            if typeof(Info.Bottom) == "boolean"     then Tab.WarningBox.Bottom      = Info.Bottom end
            if typeof(Info.IsNormal) == "boolean"   then Tab.WarningBox.IsNormal      = Info.IsNormal end
            if typeof(Info.LockSize) == "boolean"   then Tab.WarningBox.LockSize    = Info.LockSize end
            if typeof(Info.Visible) == "boolean"    then Tab.WarningBox.Visible     = Info.Visible end
            if typeof(Info.Title) == "string"       then Tab.WarningBox.Title       = Info.Title end
            if typeof(Info.Text) == "string"        then Tab.WarningBox.Text        = Info.Text end

            TopBar.Visible = Tab.WarningBox.Visible
            TopBarLabel.Text = Tab.WarningBox.Title
            TopBarTextLabel.Text = Tab.WarningBox.Text
            if TopBar.Visible then Tab:Resize()
end

            TopBar.BorderColor3 = Tab.WarningBox.IsNormal == true and Color3.fromRGB(27, 42, 53) or Color3.fromRGB(248, 51, 51)
            TopBarInner.BorderColor3 = Tab.WarningBox.IsNormal == true and Library.OutlineColor or Color3.fromRGB(0, 0, 0)
            TopBarInner.BackgroundColor3 = Tab.WarningBox.IsNormal == true and Library.BackgroundColor or Color3.fromRGB(117, 22, 17)
            TopBarHighlight.BackgroundColor3 = Tab.WarningBox.IsNormal == true and Library.AccentColor or Color3.fromRGB(255, 75, 75)
             
            TopBarLabel.TextColor3 = Tab.WarningBox.IsNormal == true and Library.FontColor or Color3.fromRGB(255, 55, 55)
            TopBarLabelStroke.Color = Tab.WarningBox.IsNormal == true and Library.Black or Color3.fromRGB(174, 3, 3)

            if not Library.RegistryMap[TopBarInner] then Library:AddToRegistry(TopBarInner, {}) end
            if not Library.RegistryMap[TopBarHighlight] then Library:AddToRegistry(TopBarHighlight, {}) end
            if not Library.RegistryMap[TopBarLabel] then Library:AddToRegistry(TopBarLabel, {}) end
            if not Library.RegistryMap[TopBarLabelStroke] then Library:AddToRegistry(TopBarLabelStroke, {}) end

            Library.RegistryMap[TopBarInner].Properties.BorderColor3 = Tab.WarningBox.IsNormal == true and "OutlineColor" or nil
            Library.RegistryMap[TopBarInner].Properties.BackgroundColor3 = Tab.WarningBox.IsNormal == true and "BackgroundColor" or nil
            Library.RegistryMap[TopBarHighlight].Properties.BackgroundColor3 = Tab.WarningBox.IsNormal == true and "AccentColor" or nil

            Library.RegistryMap[TopBarLabel].Properties.TextColor3 = Tab.WarningBox.IsNormal == true and "FontColor" or nil
            Library.RegistryMap[TopBarLabelStroke].Properties.Color = Tab.WarningBox.IsNormal == true and "Black" or nil
        end

        function Tab:ShowTab()
            Library.ActiveTab = Name
            for _, Tab in next, Window.Tabs do
                Tab:HideTab()
            end

            Blocker.BackgroundTransparency = 0
            TabButton.BackgroundColor3 = Library.MainColor
            Library.RegistryMap[TabButton].Properties.BackgroundColor3 = "MainColor"
            TabFrame.Visible = true

            Tab:Resize()
        end
        Tab.Show = Tab.ShowTab

        function Tab:HideTab()
            Blocker.BackgroundTransparency = 1
            TabButton.BackgroundColor3 = Library.BackgroundColor
            Library.RegistryMap[TabButton].Properties.BackgroundColor3 = "BackgroundColor"
            TabFrame.Visible = false
        end
        Tab.Hide = Tab.HideTab

        function Tab:SetLayoutOrder(Position)
            TabButton.LayoutOrder = Position
            TabListLayout:ApplyLayout()
        end

        function Tab:GetSides()
            return { ["Left"] = LeftSide, ["Right"] = RightSide }
        end

        function Tab:SetName(Name)
            if typeof(Name) == "string" then
                Tab.Name = Name

                local TabButtonWidth = Library:GetTextBounds(Tab.Name, Library.Font, 16)

                TabButton.Size = UDim2.new(0, TabButtonWidth + 8 + 4, 0.85, 0)
                TabButtonLabel.Text = Tab.Name
            end
        end

        function Tab:AddGroupbox(Info)
            local Groupbox = {
                Elements = {};
                Side = Info.Side;
                Tab = Tab;
                TableType = "Groupbox";
            }

            local BoxOuter = Library:Create("Frame", {
                BackgroundColor3 = Library.BackgroundColor;
                BorderColor3 = Library.OutlineColor;
                BorderMode = Enum.BorderMode.Inset;
                Size = UDim2.new(1, 0, 0, 507 + 2);
                ZIndex = 2;
                Parent = Info.Side == 1 and LeftSide or RightSide;
            })

            Library:AddToRegistry(BoxOuter, {
                BackgroundColor3 = "BackgroundColor";
                BorderColor3 = "OutlineColor";
            })

            local BoxInner = Library:Create("Frame", {
                BackgroundColor3 = Library.BackgroundColor;
                BorderColor3 = Color3.new(0, 0, 0);
                -- BorderMode = Enum.BorderMode.Inset;
                Size = UDim2.new(1, -2, 1, -2);
                Position = UDim2.new(0, 1, 0, 1);
                ZIndex = 4;
                Parent = BoxOuter;
            })

            Library:AddToRegistry(BoxInner, {
                BackgroundColor3 = "BackgroundColor";
            })

            local Highlight = Library:Create("Frame", {
                BackgroundColor3 = Library.AccentColor;
                BorderSizePixel = 0;
                Size = UDim2.new(1, 0, 0, 2);
                ZIndex = 5;
                Parent = BoxInner;
            })

            Library:AddToRegistry(Highlight, {
                BackgroundColor3 = "AccentColor";
            })

            -- local GroupboxLabel = 
            Library:CreateLabel({
                Size = UDim2.new(1, 0, 0, 18);
                Position = UDim2.new(0, 4, 0, 2);
                TextSize = 14;
                Text = Info.Name;
                TextXAlignment = Enum.TextXAlignment.Left;
                ZIndex = 5;
                Parent = BoxInner;
            })

            local Container = Library:Create("Frame", {
                BackgroundTransparency = 1;
                Position = UDim2.new(0, 4, 0, 20);
                Size = UDim2.new(1, -4, 1, -20);
                ZIndex = 1;
                Parent = BoxInner;
            })

            Library:Create("UIListLayout", {
                FillDirection = Enum.FillDirection.Vertical;
                SortOrder = Enum.SortOrder.LayoutOrder;
                Parent = Container;
            })

            function Groupbox:Resize()
                local Size = 0

                for _, Element in next, Groupbox.Container:GetChildren() do
                    if (not Element:IsA("UIListLayout")) and Element.Visible then
                        Size = Size + Element.Size.Y.Offset
                    end
                end

                BoxOuter.Size = UDim2.new(1, 0, 0, (20 * DPIScale + Size) + 2 + 2)
            end

            Groupbox.Container = Container
            setmetatable(Groupbox, BaseGroupbox)

            Groupbox:AddBlank(3)
            Groupbox:Resize()

            Tab.Groupboxes[Info.Name] = Groupbox

            return Groupbox
        end

        function Tab:AddLeftGroupbox(Name)
            return Tab:AddGroupbox({ Side = 1; Name = Name; })
        end

        function Tab:AddRightGroupbox(Name)
            return Tab:AddGroupbox({ Side = 2; Name = Name; })
        end

        function Tab:AddTabbox(Info)
            local Tabbox = {
                Tabs = {};
            }

            local BoxOuter = Library:Create("Frame", {
                BackgroundColor3 = Library.BackgroundColor;
                BorderColor3 = Library.OutlineColor;
                BorderMode = Enum.BorderMode.Inset;
                Size = UDim2.new(1, 0, 0, 0);
                ZIndex = 2;
                Parent = Info.Side == 1 and LeftSide or RightSide;
            })

            Library:AddToRegistry(BoxOuter, {
                BackgroundColor3 = "BackgroundColor";
                BorderColor3 = "OutlineColor";
            })

            local BoxInner = Library:Create("Frame", {
                BackgroundColor3 = Library.BackgroundColor;
                BorderColor3 = Color3.new(0, 0, 0);
                -- BorderMode = Enum.BorderMode.Inset;
                Size = UDim2.new(1, -2, 1, -2);
                Position = UDim2.new(0, 1, 0, 1);
                ZIndex = 4;
                Parent = BoxOuter;
            })

            Library:AddToRegistry(BoxInner, {
                BackgroundColor3 = "BackgroundColor";
            })

            local Highlight = Library:Create("Frame", {
                BackgroundColor3 = Library.AccentColor;
                BorderSizePixel = 0;
                Size = UDim2.new(1, 0, 0, 2);
                ZIndex = 10;
                Parent = BoxInner;
            })

            Library:AddToRegistry(Highlight, {
                BackgroundColor3 = "AccentColor";
            })

            local TabboxButtons = Library:Create("Frame", {
                BackgroundTransparency = 1;
                Position = UDim2.new(0, 0, 0, 1);
                Size = UDim2.new(1, 0, 0, 18);
                ZIndex = 5;
                Parent = BoxInner;
            })

            Library:Create("UIListLayout", {
                FillDirection = Enum.FillDirection.Horizontal;
                HorizontalAlignment = Enum.HorizontalAlignment.Left;
                SortOrder = Enum.SortOrder.LayoutOrder;
                Parent = TabboxButtons;
            })

            function Tabbox:AddTab(Name)
                local Tab = {
                    Elements = {};
                    Container = nil;
                    TableType = "TabboxTab";
                }

                local Button = Library:Create("Frame", {
                    BackgroundColor3 = Library.MainColor;
                    BorderColor3 = Color3.new(0, 0, 0);
                    Size = UDim2.new(0.5, 0, 1, 0);
                    ZIndex = 6;
                    Parent = TabboxButtons;
                })

                Library:AddToRegistry(Button, {
                    BackgroundColor3 = "MainColor";
                })

                -- local ButtonLabel = 
                Library:CreateLabel({
                    Size = UDim2.new(1, 0, 1, 0);
                    TextSize = 14;
                    Text = Name;
                    TextXAlignment = Enum.TextXAlignment.Center;
                    ZIndex = 7;
                    Parent = Button;
                    RichText = true;
                })

                local Block = Library:Create("Frame", {
                    BackgroundColor3 = Library.BackgroundColor;
                    BorderSizePixel = 0;
                    Position = UDim2.new(0, 0, 1, 0);
                    Size = UDim2.new(1, 0, 0, 1);
                    Visible = false;
                    ZIndex = 9;
                    Parent = Button;
                })

                Library:AddToRegistry(Block, {
                    BackgroundColor3 = "BackgroundColor";
                })

                local Container = Library:Create("Frame", {
                    BackgroundTransparency = 1;
                    Position = UDim2.new(0, 4, 0, 20);
                    Size = UDim2.new(1, -4, 1, -20);
                    ZIndex = 1;
                    Visible = false;
                    Parent = BoxInner;
                })

                Library:Create("UIListLayout", {
                    FillDirection = Enum.FillDirection.Vertical;
                    SortOrder = Enum.SortOrder.LayoutOrder;
                    Parent = Container;
                })

                function Tab:Show()
                    for _, Tab in next, Tabbox.Tabs do
                        Tab:Hide()
                    end

                    Container.Visible = true
                    Block.Visible = true

                    Button.BackgroundColor3 = Library.BackgroundColor
                    Library.RegistryMap[Button].Properties.BackgroundColor3 = "BackgroundColor"

                    Tab:Resize()
                end

                function Tab:Hide()
                    Container.Visible = false
                    Block.Visible = false

                    Button.BackgroundColor3 = Library.MainColor
                    Library.RegistryMap[Button].Properties.BackgroundColor3 = "MainColor"
                end

                function Tab:Resize()
                    local TabCount = 0

                    for _, Tab in next, Tabbox.Tabs do
                        TabCount = TabCount + 1
                    end

                    for _, Button in next, TabboxButtons:GetChildren() do
                        if not Button:IsA("UIListLayout") then
                            Button.Size = UDim2.new(1 / TabCount, 0, 1, 0)
                        end
                    end

                    if (not Container.Visible) then
                        return
                    end

                    local Size = 0

                    for _, Element in next, Tab.Container:GetChildren() do
                        if (not Element:IsA("UIListLayout")) and Element.Visible then
                            Size = Size + Element.Size.Y.Offset
                        end
                    end

                    BoxOuter.Size = UDim2.new(1, 0, 0, (20 * DPIScale + Size) + 2 + 2)
                end

                Button.InputBegan:Connect(function(Input)
                    if (Input.UserInputType == Enum.UserInputType.MouseButton1 and not Library:MouseIsOverOpenedFrame()) or Input.UserInputType == Enum.UserInputType.Touch then
                        Tab:Show()
                        Tab:Resize()
                    end
                end)

                Tab.Container = Container
                Tabbox.Tabs[Name] = Tab

                setmetatable(Tab, BaseGroupbox)

                Tab:AddBlank(3)
                Tab:Resize()

                -- Show first tab (number is 2 cus of the UIListLayout that also sits in that instance)
                if #TabboxButtons:GetChildren() == 2 then
                    Tab:Show()
                end

                return Tab
            end

            Tab.Tabboxes[Info.Name or ""] = Tabbox

            return Tabbox
        end

        function Tab:AddLeftTabbox(Name)
            return Tab:AddTabbox({ Name = Name, Side = 1; })
        end

        function Tab:AddRightTabbox(Name)
            return Tab:AddTabbox({ Name = Name, Side = 2; })
        end

        TabButton.InputBegan:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                Tab:ShowTab()
            end
        end)

        TopBar:GetPropertyChangedSignal("Visible"):Connect(function()
            Tab:Resize()
        end)

        -- This was the first tab added, so we show it by default.
        Library.TotalTabs = Library.TotalTabs + 1
        if Library.TotalTabs == 1 then
            Tab:ShowTab()
        end

        Window.Tabs[Name] = Tab
        return Tab
    end

    local TransparencyCache = {}
    local Toggled = false
    local Fading = false
    
    function Window:Toggle(Toggling)
        if typeof(Toggling) == "boolean" and Toggling == Toggled then return end
        if Fading then return end

        local FadeTime = WindowInfo.MenuFadeTime
        Fading = true
        Toggled = (not Toggled)

        Library.Toggled = Toggled
        if WindowInfo.UnlockMouseWhileOpen then
            ModalElement.Modal = Library.Toggled
        end

        if Toggled then
            -- A bit scuffed, but if we're going from not toggled -> toggled we want to show the frame immediately so that the fade is visible.
            Outer.Visible = true

            if DrawingLib.drawing_replaced ~= true and IsBadDrawingLib ~= true then
                IsBadDrawingLib = not (pcall(function()
                    local Cursor = DrawingLib.new("Triangle")
                    Cursor.Thickness = 1
                    Cursor.Filled = true
                    Cursor.Visible = Library.ShowCustomCursor

                    local CursorOutline = DrawingLib.new("Triangle")
                    CursorOutline.Thickness = 1
                    CursorOutline.Filled = false
                    CursorOutline.Color = Color3.new(0, 0, 0)
                    CursorOutline.Visible = Library.ShowCustomCursor
                    
                    local OldMouseIconState = InputService.MouseIconEnabled
                    local ShowCursorBinding = Library.ShowCursorBinding
                    pcall(function() RunService:UnbindFromRenderStep(ShowCursorBinding) end)
                    RunService:BindToRenderStep(ShowCursorBinding, Enum.RenderPriority.Camera.Value - 1, function()
                        InputService.MouseIconEnabled = not Library.ShowCustomCursor
                        local mPos = InputService:GetMouseLocation()
                        local X, Y = mPos.X, mPos.Y
                        Cursor.Color = Library.AccentColor
                        Cursor.PointA = Vector2.new(X, Y)
                        Cursor.PointB = Vector2.new(X + 16, Y + 6)
                        Cursor.PointC = Vector2.new(X + 6, Y + 16)
                        Cursor.Visible = Library.ShowCustomCursor
                        CursorOutline.PointA = Cursor.PointA
                        CursorOutline.PointB = Cursor.PointB
                        CursorOutline.PointC = Cursor.PointC
                        CursorOutline.Visible = Library.ShowCustomCursor

                        if not Toggled or (not ScreenGui or not ScreenGui.Parent) then
                            InputService.MouseIconEnabled = OldMouseIconState
                            if Cursor then Cursor:Destroy() end
                            if CursorOutline then CursorOutline:Destroy() end
                            RunService:UnbindFromRenderStep(ShowCursorBinding)
                        end
                    end)
                end))
            end
        end

        for _, Option in Options do
            task.spawn(function()
                if Option.Type == "Dropdown" then
                    Option:CloseDropdown()

                elseif Option.Type == "KeyPicker" then
                    Option:SetModePickerVisibility(false)

                elseif Option.Type == "ColorPicker" then
                    Option.ContextMenu:Hide()
                    Option:Hide()
                end
            end)
        end

        for _, Desc in next, Outer:GetDescendants() do
            local Properties = {}

            if Desc:IsA("ImageLabel") then
                table.insert(Properties, "ImageTransparency")
                table.insert(Properties, "BackgroundTransparency")

            elseif Desc:IsA("TextLabel") or Desc:IsA("TextBox") then
                table.insert(Properties, "TextTransparency")

            elseif Desc:IsA("Frame") or Desc:IsA("ScrollingFrame") then
                table.insert(Properties, "BackgroundTransparency")
                
            elseif Desc:IsA("UIStroke") then
                table.insert(Properties, "Transparency")
            end

            local Cache = TransparencyCache[Desc]

            if (not Cache) then
                Cache = {}
                TransparencyCache[Desc] = Cache
            end

            for _, Prop in next, Properties do
                if not Cache[Prop] then
                    Cache[Prop] = Desc[Prop]
                end

                if Cache[Prop] == 1 then
                    continue
                end

                TweenService:Create(Desc, TweenInfo.new(FadeTime, Enum.EasingStyle.Linear), { [Prop] = Toggled and Cache[Prop] or 1 }):Play()
            end
        end

        task.wait(FadeTime)
        Outer.Visible = Toggled
        Fading = false
    end

    function Library:Toggle(Toggling)
        return Window:Toggle(Toggling)
    end

    Library:GiveSignal(InputService.InputBegan:Connect(function(Input, Processed) -- :sob:
        if Library.Unloaded then
            return
        end
        
        if typeof(Library.ToggleKeybind) == "table" and Library.ToggleKeybind.Type == "KeyPicker" then
            if Input.UserInputType == Enum.UserInputType.Keyboard and Input.KeyCode.Name == Library.ToggleKeybind.Value then
                task.spawn(Library.Toggle)
            end

        elseif Input.KeyCode == Enum.KeyCode.RightControl or (Input.KeyCode == Enum.KeyCode.RightShift and (not Processed)) then
            task.spawn(Library.Toggle)
        end
    end))

    if Library.IsMobile then
        local ToggleUIOuter = Library:Create("Frame", {
            BorderColor3 = Color3.new(0, 0, 0);
            Position = UDim2.new(0.008, 0, 0.018, 0);
            Size = UDim2.new(0, 77, 0, 30);
            ZIndex = 200;
            Visible = true;
            Parent = ScreenGui;
        })
    
        local ToggleUIInner = Library:Create("Frame", {
            BackgroundColor3 = Library.MainColor;
            BorderColor3 = Library.AccentColor;
            BorderMode = Enum.BorderMode.Inset;
            Size = UDim2.new(1, 0, 1, 0);
            ZIndex = 201;
            Parent = ToggleUIOuter;
        })
    
        Library:AddToRegistry(ToggleUIInner, {
            BorderColor3 = "AccentColor";
        })
    
        local ToggleUIInnerFrame = Library:Create("Frame", {
            BackgroundColor3 = Color3.new(1, 1, 1);
            BorderSizePixel = 0;
            Position = UDim2.new(0, 1, 0, 1);
            Size = UDim2.new(1, -2, 1, -2);
            ZIndex = 202;
            Parent = ToggleUIInner;
        })
    
        local ToggleUIGradient = Library:Create("UIGradient", {
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Library:GetDarkerColor(Library.MainColor)),
                ColorSequenceKeypoint.new(1, Library.MainColor),
            });
            Rotation = -90;
            Parent = ToggleUIInnerFrame;
        })
    
        Library:AddToRegistry(ToggleUIGradient, {
            Color = function()
                return ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Library:GetDarkerColor(Library.MainColor)),
                    ColorSequenceKeypoint.new(1, Library.MainColor),
                })
            end
        })
    
        local ToggleUIButton = Library:Create("TextButton", {
            Position = UDim2.new(0, 5, 0, 0);
            Size = UDim2.new(1, -4, 1, 0);
            BackgroundTransparency = 1;
            Font = Library.Font;
            Text = "Toggle UI";
            TextColor3 = Library.FontColor;
            TextSize = 14;
            TextXAlignment = Enum.TextXAlignment.Left;
            TextStrokeTransparency = 0;
            ZIndex = 203;
            Parent = ToggleUIInnerFrame;
        })
    
        Library:MakeDraggableUsingParent(ToggleUIButton, ToggleUIOuter)

        ToggleUIButton.MouseButton1Down:Connect(function()
            Library:Toggle()
        end)

        -- Lock
        local LockUIOuter = Library:Create("Frame", {
            BorderColor3 = Color3.new(0, 0, 0);
            Position = UDim2.new(0.008, 0, 0.075, 0);
            Size = UDim2.new(0, 77, 0, 30);
            ZIndex = 200;
            Visible = true;
            Parent = ScreenGui;
        })
    
        local LockUIInner = Library:Create("Frame", {
            BackgroundColor3 = Library.MainColor;
            BorderColor3 = Library.AccentColor;
            BorderMode = Enum.BorderMode.Inset;
            Size = UDim2.new(1, 0, 1, 0);
            ZIndex = 201;
            Parent = LockUIOuter;
        })
    
        Library:AddToRegistry(LockUIInner, {
            BorderColor3 = "AccentColor";
        })
    
        local LockUIInnerFrame = Library:Create("Frame", {
            BackgroundColor3 = Color3.new(1, 1, 1);
            BorderSizePixel = 0;
            Position = UDim2.new(0, 1, 0, 1);
            Size = UDim2.new(1, -2, 1, -2);
            ZIndex = 202;
            Parent = LockUIInner;
        })
    
        local LockUIGradient = Library:Create("UIGradient", {
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Library:GetDarkerColor(Library.MainColor)),
                ColorSequenceKeypoint.new(1, Library.MainColor),
            });
            Rotation = -90;
            Parent = LockUIInnerFrame;
        })
    
        Library:AddToRegistry(LockUIGradient, {
            Color = function()
                return ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Library:GetDarkerColor(Library.MainColor)),
                    ColorSequenceKeypoint.new(1, Library.MainColor),
                })
            end
        })
    
        local LockUIButton = Library:Create("TextButton", {
            Position = UDim2.new(0, 5, 0, 0);
            Size = UDim2.new(1, -4, 1, 0);
            BackgroundTransparency = 1;
            Font = Library.Font;
            Text = "Lock UI";
            TextColor3 = Library.FontColor;
            TextSize = 14;
            TextXAlignment = Enum.TextXAlignment.Left;
            TextStrokeTransparency = 0;
            ZIndex = 203;
            Parent = LockUIInnerFrame;
        })
    
        Library:MakeDraggableUsingParent(LockUIButton, LockUIOuter)
        
        LockUIButton.MouseButton1Down:Connect(function()
            Library.CantDragForced = not Library.CantDragForced
            LockUIButton.Text = Library.CantDragForced and "Unlock UI" or "Lock UI"
        end)
    end

    Window:SetBackgroundImage(WindowInfo.BackgroundImage or "")
    if WindowInfo.AutoShow then task.spawn(Library.Toggle) end

    Window.Holder = Outer
    Library.Window = Window

    return Window
end

local function OnPlayerChange()
    if Library.Unloaded then
        return
    end

    local PlayerList, ExcludedPlayerList = GetPlayers(false, true), GetPlayers(true, true)
    local StringPlayerList, StringExcludedPlayerList = GetPlayers(false, false), GetPlayers(true, false)

    for _, Value in next, Options do
        if Value.SetValues and Value.Type == "Dropdown" and Value.SpecialType == "Player" then
            Value:SetValues(
                if Value.ReturnInstanceInstead then
                    (if Value.ExcludeLocalPlayer then ExcludedPlayerList else PlayerList)
                else
                    (if Value.ExcludeLocalPlayer then StringExcludedPlayerList else StringPlayerList)
            )
        end
    end
end

local function OnTeamChange()
    if Library.Unloaded then
        return
    end
    
    local TeamList = GetTeams(false)
    local StringTeamList = GetTeams(true)

    for _, Value in next, Options do
        if Value.SetValues and Value.Type == "Dropdown" and Value.SpecialType == "Team" then
            Value:SetValues(if Value.ReturnInstanceInstead then TeamList else StringTeamList)
        end
    end
end

Library:GiveSignal(Players.PlayerAdded:Connect(OnPlayerChange))
Library:GiveSignal(Players.PlayerRemoving:Connect(OnPlayerChange))

Library:GiveSignal(Teams.ChildAdded:Connect(OnTeamChange))
Library:GiveSignal(Teams.ChildRemoved:Connect(OnTeamChange))

--// Rainbow Handler \\--
local RainbowStep = 0
local Hue = 0

Library:GiveSignal(RunService.RenderStepped:Connect(function(Delta)
    if Library.Unloaded then
        return
    end

    RainbowStep = RainbowStep + Delta
    if RainbowStep >= (1 / 60) then
        RainbowStep = 0

        Hue = Hue + (1 / 400)

        if Hue > 1 then
            Hue = 0
        end

        Library.CurrentRainbowHue = Hue
        Library.CurrentRainbowColor = Color3.fromHSV(Hue, 0.8, 1)
    end
end))

----
getgenv().Linoria = Library
if getgenv().skip_getgenv_linoria ~= true then getgenv().Library = Library end
return Library

end

return require("main")
